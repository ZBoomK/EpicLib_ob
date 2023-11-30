local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local b = Rep(a, repeatNext);
				repeatNext = nil;
				return b;
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				Exponent = 1;
				IsNormal = 0;
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local Str;
		if not Len then
			Len = gBits32();
			if (Len == 0) then
				return "";
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local Type = gBits8();
			local Cons;
			if (Type == 1) then
				Cons = gBits8() ~= 0;
			elseif (Type == 2) then
				Cons = gFloat();
			elseif (Type == 3) then
				Cons = gString();
			end
			Consts[Idx] = Cons;
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local Type = gBit(Descriptor, 2, 3);
				local Mask = gBit(Descriptor, 4, 6);
				local Inst = {gBits16(),gBits16(),nil,nil};
				if (Type == 0) then
					Inst[3] = gBits16();
					Inst[4] = gBits16();
				elseif (Type == 1) then
					Inst[3] = gBits32();
				elseif (Type == 2) then
					Inst[3] = gBits32() - (2 ^ 16);
				elseif (Type == 3) then
					Inst[3] = gBits32() - (2 ^ 16);
					Inst[4] = gBits16();
				end
				if (gBit(Mask, 1, 1) == 1) then
					Inst[2] = Consts[Inst[2]];
				end
				if (gBit(Mask, 2, 2) == 1) then
					Inst[3] = Consts[Inst[3]];
				end
				if (gBit(Mask, 3, 3) == 1) then
					Inst[4] = Consts[Inst[4]];
				end
				Instrs[Idx] = Inst;
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 150) then
					if (Enum <= 74) then
						if (Enum <= 36) then
							if (Enum <= 17) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												local B;
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											end
										elseif (Enum == 2) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 5) then
										if (Enum == 4) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = not Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 6) then
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 7) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum > 9) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = not Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 11) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 14) then
									if (Enum > 13) then
										if (Inst[2] > Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 15) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Enum > 16) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum > 18) then
											if (Inst[2] ~= Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 20) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									end
								elseif (Enum <= 23) then
									if (Enum == 22) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 24) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 25) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum == 27) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 29) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 30) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 33) then
								if (Enum == 32) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 34) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 35) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 55) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum == 37) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = not Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 39) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 42) then
									if (Enum == 41) then
										do
											return Stk[Inst[2]]();
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 43) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								elseif (Enum == 44) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								else
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 50) then
								if (Enum <= 47) then
									if (Enum == 46) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 48) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum > 49) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]]();
								end
							elseif (Enum <= 52) then
								if (Enum == 51) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 53) then
								if (Inst[2] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 54) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 64) then
							if (Enum <= 59) then
								if (Enum <= 57) then
									if (Enum > 56) then
										local Edx;
										local Results, Limit;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = #Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = #Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 58) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 61) then
								if (Enum == 60) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 62) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 63) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 69) then
							if (Enum <= 66) then
								if (Enum == 65) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 67) then
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 68) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							else
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 71) then
							if (Enum == 70) then
								local A;
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return Stk[Inst[2]]();
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 72) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 73) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 112) then
						if (Enum <= 93) then
							if (Enum <= 83) then
								if (Enum <= 78) then
									if (Enum <= 76) then
										if (Enum > 75) then
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											for Idx = Inst[2], Inst[3] do
												Stk[Idx] = nil;
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Inst[2] <= Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = not Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 77) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 80) then
									if (Enum == 79) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 81) then
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 82) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 88) then
								if (Enum <= 85) then
									if (Enum == 84) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 86) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 87) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 90) then
								if (Enum > 89) then
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								else
									Stk[Inst[2]] = {};
								end
							elseif (Enum <= 91) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 92) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 102) then
							if (Enum <= 97) then
								if (Enum <= 95) then
									if (Enum == 94) then
										local B;
										local A;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 96) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 99) then
								if (Enum == 98) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 100) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 101) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 107) then
							if (Enum <= 104) then
								if (Enum > 103) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 105) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 106) then
								local B;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 109) then
							if (Enum == 108) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 110) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 111) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							do
								return Unpack(Stk, A, Top);
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 131) then
						if (Enum <= 121) then
							if (Enum <= 116) then
								if (Enum <= 114) then
									if (Enum > 113) then
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 115) then
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 118) then
								if (Enum == 117) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 119) then
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 120) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 126) then
							if (Enum <= 123) then
								if (Enum == 122) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 124) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 125) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 128) then
							if (Enum == 127) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 129) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 130) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local Edx;
							local Results, Limit;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 140) then
						if (Enum <= 135) then
							if (Enum <= 133) then
								if (Enum > 132) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 134) then
								local B;
								local A;
								A = Inst[2];
								B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 137) then
							if (Enum > 136) then
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 138) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 139) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 145) then
						if (Enum <= 142) then
							if (Enum == 141) then
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							else
								local Edx;
								local Results, Limit;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 143) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 144) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						end
					elseif (Enum <= 147) then
						if (Enum == 146) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 148) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum == 149) then
						local Edx;
						local Results, Limit;
						local A;
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3] ~= 0;
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
						Top = (Limit + A) - 1;
						Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 225) then
					if (Enum <= 187) then
						if (Enum <= 168) then
							if (Enum <= 159) then
								if (Enum <= 154) then
									if (Enum <= 152) then
										if (Enum > 151) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 153) then
										if (Inst[2] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 156) then
									if (Enum == 155) then
										if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 157) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 158) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								end
							elseif (Enum <= 163) then
								if (Enum <= 161) then
									if (Enum > 160) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
									end
								elseif (Enum == 162) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 165) then
								if (Enum == 164) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum <= 166) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 167) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 177) then
							if (Enum <= 172) then
								if (Enum <= 170) then
									if (Enum == 169) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 171) then
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = #Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Index = Stk[A];
									Step = Stk[A + 2];
									if (Step > 0) then
										if (Index > Stk[A + 1]) then
											VIP = Inst[3];
										else
											Stk[A + 3] = Index;
										end
									elseif (Index < Stk[A + 1]) then
										VIP = Inst[3];
									else
										Stk[A + 3] = Index;
									end
								else
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 174) then
								if (Enum == 173) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 175) then
								Stk[Inst[2]] = Stk[Inst[3]];
							elseif (Enum > 176) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 182) then
							if (Enum <= 179) then
								if (Enum == 178) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
									end
								else
									local Edx;
									local Results, Limit;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								end
							elseif (Enum <= 180) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							elseif (Enum > 181) then
								do
									return;
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 184) then
							if (Enum > 183) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 185) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 186) then
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 206) then
						if (Enum <= 196) then
							if (Enum <= 191) then
								if (Enum <= 189) then
									if (Enum == 188) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum > 190) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 193) then
								if (Enum == 192) then
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 194) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 195) then
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 201) then
							if (Enum <= 198) then
								if (Enum == 197) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 199) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 200) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 203) then
							if (Enum == 202) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 204) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 205) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 215) then
						if (Enum <= 210) then
							if (Enum <= 208) then
								if (Enum > 207) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 209) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 212) then
							if (Enum == 211) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 213) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 214) then
							local A;
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 220) then
						if (Enum <= 217) then
							if (Enum == 216) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 218) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 219) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 222) then
						if (Enum == 221) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 223) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 224) then
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					else
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = not Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 263) then
					if (Enum <= 244) then
						if (Enum <= 234) then
							if (Enum <= 229) then
								if (Enum <= 227) then
									if (Enum > 226) then
										Stk[Inst[2]] = #Stk[Inst[3]];
									elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum == 228) then
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 231) then
								if (Enum == 230) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 232) then
								local A = Inst[2];
								local Step = Stk[A + 2];
								local Index = Stk[A] + Step;
								Stk[A] = Index;
								if (Step > 0) then
									if (Index <= Stk[A + 1]) then
										VIP = Inst[3];
										Stk[A + 3] = Index;
									end
								elseif (Index >= Stk[A + 1]) then
									VIP = Inst[3];
									Stk[A + 3] = Index;
								end
							elseif (Enum == 233) then
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 239) then
							if (Enum <= 236) then
								if (Enum > 235) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 237) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 238) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 241) then
							if (Enum > 240) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = #Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 242) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 243) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						end
					elseif (Enum <= 253) then
						if (Enum <= 248) then
							if (Enum <= 246) then
								if (Enum == 245) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 247) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 250) then
							if (Enum == 249) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 251) then
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 252) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 258) then
						if (Enum <= 255) then
							if (Enum == 254) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							else
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 256) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 257) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
							end
						end
					elseif (Enum <= 260) then
						if (Enum > 259) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 261) then
						Stk[Inst[2]] = Inst[3];
					elseif (Enum > 262) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local A = Inst[2];
						local Index = Stk[A];
						local Step = Stk[A + 2];
						if (Step > 0) then
							if (Index > Stk[A + 1]) then
								VIP = Inst[3];
							else
								Stk[A + 3] = Index;
							end
						elseif (Index < Stk[A + 1]) then
							VIP = Inst[3];
						else
							Stk[A + 3] = Index;
						end
					end
				elseif (Enum <= 282) then
					if (Enum <= 272) then
						if (Enum <= 267) then
							if (Enum <= 265) then
								if (Enum > 264) then
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 266) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 269) then
							if (Enum > 268) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 270) then
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						elseif (Enum == 271) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 277) then
						if (Enum <= 274) then
							if (Enum > 273) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 275) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 276) then
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 279) then
						if (Enum > 278) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						else
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Top));
							end
						end
					elseif (Enum <= 280) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 281) then
						if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = not Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 291) then
					if (Enum <= 286) then
						if (Enum <= 284) then
							if (Enum > 283) then
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 285) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 288) then
						if (Enum > 287) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 289) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 290) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 296) then
					if (Enum <= 293) then
						if (Enum > 292) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 294) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = not Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 295) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local NewProto = Proto[Inst[3]];
						local NewUvals;
						local Indexes = {};
						NewUvals = Setmetatable({}, {__index=function(_, Key)
							local Val = Indexes[Key];
							return Val[1][Val[2]];
						end,__newindex=function(_, Key, Value)
							local Val = Indexes[Key];
							Val[1][Val[2]] = Value;
						end});
						for Idx = 1, Inst[4] do
							VIP = VIP + 1;
							local Mvm = Instr[VIP];
							if (Mvm[1] == 175) then
								Indexes[Idx - 1] = {Stk,Mvm[3]};
							else
								Indexes[Idx - 1] = {Upvalues,Mvm[3]};
							end
							Lupvals[#Lupvals + 1] = Indexes;
						end
						Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
					end
				elseif (Enum <= 298) then
					if (Enum > 297) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 299) then
					if (Inst[2] < Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 300) then
					VIP = Inst[3];
				elseif (Stk[Inst[2]] < Inst[4]) then
					VIP = Inst[3];
				else
					VIP = VIP + 1;
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503153O00F4D3D23DD98CC60CC3CAD437D99DD20CC88DD730E703083O007EB1A3BB4586DBA703153O00D55F539FCF785B95E2465595CF694F95E9015692F103043O00E7902F3A002E3O001219012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100042D012O000A00010012E2000300063O0020080004000300070012E2000500083O0020080005000500090012E2000600083O00200800060006000A00062801073O000100062O00AF3O00064O00AF8O00AF3O00044O00AF3O00014O00AF3O00024O00AF3O00053O00200800080003000B00200800090003000C2O0059000A5O0012E2000B000D3O000628010C0001000100022O00AF3O000A4O00AF3O000B4O00AF000D00073O001205010E000E3O001205010F000F4O006E000D000F0002000628010E0002000100032O00AF3O00074O00AF3O00094O00AF3O00084O0046000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00AB00025O00122O000300016O00045O00122O000500013O00042O0003002100012O006600076O0083000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0066000C00034O0039000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00F4000C6O0001000A3O00020020F3000A000A00022O002E0009000A4O00F700073O00010004E80003000500012O0066000300054O00AF000400024O00D1000300044O003600036O00B63O00017O000B3O00028O00026O00F03F025O00A09D40025O00049D40025O00288940025O0042B040025O0028B340025O00E89640025O00C07E40025O00208B40025O001AAE4001313O001205010200014O00B4000300043O000ED4000100070001000200042D012O00070001001205010300014O00B4000400043O001205010200023O002E3B000400020001000300042D012O00020001000ED4000200020001000200042D012O000200010026430003000F0001000200042D012O000F0001002E3B000600130001000500042D012O001300012O00AF000500044O002O01066O001601056O003600055O002E9A000700F8FF2O000700042D012O000B0001002E090109000B0001000800042D012O000B0001000ED40001000B0001000300042D012O000B0001001205010500013O000ED4000100260001000500042D012O002600012O006600066O0040000400063O0006BB000400250001000100042D012O002500012O0066000600014O00AF00076O002O01086O001601066O003600065O001205010500023O002E3B000A001A0001000B00042D012O001A00010026E40005001A0001000200042D012O001A0001001205010300023O00042D012O000B000100042D012O001A000100042D012O000B000100042D012O0030000100042D012O000200012O00B63O00017O00403O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C201885030C3O00C856B541F9439347EE50A25203043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D9026O00144003073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903073O0030EFB7DC0EE1B703043O00AE678EC503043O00703D4D2103073O009836483F58453E03073O00E3C5FC4EDDCBFC03043O003CB4A48E03043O007E4B173003073O0072383E6549478D03073O008FE8C9D6B1E6C903043O00A4D889BB03043O00F4F323AB03073O006BB28651D2C69E024O0080B3C54003103O005265676973746572466F724576656E7403143O000822A3FF8F0A31B0E38D1D20BDE384192CAEE38E03053O00CA586EE2A603063O0053657441504C026O00524000A0013O0087000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O001210000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O0012100009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O001210000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O001205010D00123O001205010E00134O006E000C000E00022O0040000C0004000C2O006D000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100176O000F001100022O002C000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B6O0011001300022O002C0011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F6O0013001500022O00400013000E00132O006600145O001205011500203O001205011600214O006E0014001600022O00400013001300142O006600145O00125E001500223O00122O001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000E00144O00155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O00140014001500122O0015002A6O001600166O00178O00188O00198O001A00556O00565O00122O0057002B3O00122O0058002C6O0056005800024O0056000E00564O00575O00122O0058002D3O00122O0059002E6O0057005900024O0056005600574O00575O00122O0058002F3O00122O005900306O0057005900024O0057000C00574O00585O00122O005900313O00122O005A00326O0058005A00024O0057005700584O00585O00122O005900333O00122O005A00346O0058005A00024O0058000D00584O00595O00122O005A00353O00122O005B00366O0059005B00024O0058005800594O00595O00122O005A00373O00122O005B00386O0059005B00024O0059001100594O005A5O00122O005B00393O00122O005C003A6O005A005C00024O00590059005A4O005A5O00122O005B003B3O00122O005C003B3O00202O005D0004003C000628015F3O000100022O00AF3O005B4O00AF3O005C4O008E00605O00122O0061003D3O00122O0062003E6O006000626O005D3O00014O005D005F3O00062801600001000100012O00AF3O00093O000628016100020001001B2O00AF3O00414O00AF3O00084O00AF3O004B4O00AF3O00514O00668O00AF3O00584O00AF3O00124O00AF3O00594O00AF3O00574O00AF3O003F4O00AF3O004C4O00AF3O00404O00AF3O004A4O00AF3O003C4O00AF3O00454O00AF3O003D4O00AF3O00464O00AF3O00564O00AF3O00474O00AF3O003A4O00AF3O00434O00AF3O003B4O00AF3O00444O00AF3O003E4O00AF3O000B4O00AF3O00484O00AF3O00493O00062801620003000100042O00AF3O00164O00AF3O00564O00AF3O005A4O00AF3O00193O000628016300040001000E2O00AF3O00574O00668O00AF3O001D4O00AF3O005F4O00AF3O00124O00AF3O001E4O00AF3O00094O00AF3O001A4O00AF3O002F4O00AF3O00194O00AF3O00554O00AF3O005C4O00AF3O00274O00AF3O00323O000628016400050001001C2O00AF3O00574O00668O00AF3O00204O00AF3O00084O00AF3O00124O00AF3O005F4O00AF3O00254O00AF3O001C4O00AF3O001F4O00AF3O001D4O00AF3O00184O00AF3O002B4O00AF3O00094O00AF3O00154O00AF3O00244O00AF3O005E4O00AF3O00224O00AF3O00304O00AF3O00194O00AF3O00554O00AF3O005C4O00AF3O00234O00AF3O00284O00663O00014O00AF3O00134O00663O00024O00AF3O002A4O00AF3O00343O000628016500060001001D2O00AF3O00574O00668O00AF3O00244O00AF3O00124O00AF3O005F4O00AF3O001F4O00AF3O001C4O00AF3O00084O00AF3O00254O00AF3O00284O00AF3O001D4O00AF3O00204O00AF3O00234O00AF3O002B4O00AF3O00094O00AF3O00154O00AF3O00304O00AF3O00194O00AF3O00224O00AF3O00554O00AF3O005C4O00663O00014O00AF3O00134O00663O00024O00AF3O00344O00AF3O002A4O00AF3O005E4O00AF3O00324O00AF3O00273O00062801660007000100282O00AF3O00164O00AF3O00614O00AF3O00504O00AF3O00564O00AF3O00574O00AF3O00594O00AF3O00184O00AF3O005E4O00AF3O00654O00AF3O00214O00668O00AF3O00094O00AF3O00124O00AF3O002C4O00AF3O00604O00AF3O00644O00AF3O000E4O00AF3O001E4O00AF3O00554O00AF3O005C4O00AF3O002E4O00AF3O00194O00AF3O00364O00AF3O00624O00AF3O002D4O00AF3O00354O00AF3O005F4O00AF3O00084O00AF3O00104O00AF3O00274O00AF3O00324O00AF3O00044O00AF3O004E4O00AF3O00264O00AF3O00314O00AF3O001A4O00AF3O002F4O00AF3O004F4O00AF3O00294O00AF3O00333O00062801670008000100092O00AF3O00084O00AF3O00574O00668O00AF3O00124O00AF3O001B4O00AF3O00564O00AF3O00174O00AF3O00164O00AF3O00633O000628016800090001001A2O00AF3O00344O00668O00AF3O00314O00AF3O00324O00AF3O00334O00AF3O001D4O00AF3O001B4O00AF3O001C4O00AF3O002B4O00AF3O00254O00AF3O00284O00AF3O00264O00AF3O00274O00AF3O00294O00AF3O002C4O00AF3O001A4O00AF3O00224O00AF3O001E4O00AF3O001F4O00AF3O00204O00AF3O00304O00AF3O002A4O00AF3O002F4O00AF3O00244O00AF3O00214O00AF3O00233O0006280169000A000100162O00AF3O00454O00668O00AF3O00464O00AF3O00474O00AF3O004D4O00AF3O004E4O00AF3O004F4O00AF3O00484O00AF3O00494O00AF3O004C4O00AF3O003D4O00AF3O003E4O00AF3O003F4O00AF3O003C4O00AF3O003A4O00AF3O003B4O00AF3O00424O00AF3O00434O00AF3O00444O00AF3O00374O00AF3O00384O00AF3O00393O000628016A000B0001000F2O00AF3O00404O00668O00AF3O00364O00AF3O00354O00AF3O00554O00AF3O00524O00AF3O00534O00AF3O00544O00AF3O002E4O00AF3O002D4O00AF3O00514O00AF3O00504O00AF3O00414O00AF3O004A4O00AF3O004B3O000628016B000C000100152O00AF3O00084O00AF3O00574O00668O00AF3O00154O00AF3O00184O00AF3O00194O00AF3O005D4O00AF3O005E4O00AF3O005F4O00AF3O00094O00AF3O00564O00AF3O005B4O00AF3O00044O00AF3O005C4O00AF3O00164O00AF3O00664O00AF3O00674O00AF3O00694O00AF3O00684O00AF3O006A4O00AF3O00173O000628016C000D000100022O00AF3O000E4O00667O002052006D000E003F00122O006E00406O006F006B6O0070006C6O006D007000016O00013O000E3O00023O00028O00024O0080B3C540000A3O001205012O00013O000ED40001000100013O00042D012O000100010012052O0100024O00E500015O0012052O0100024O00E5000100013O00042D012O0009000100042D012O000100012O00B63O00017O000A3O00028O00026O00F03F025O005C9C40025O006DB240025O00BAA340025O0023B24003133O00556E6974476574546F74616C4162736F726273025O00AEAC40025O001EAF40025O00F8914000233O001205012O00014O00B4000100023O0026E43O00070001000100042D012O000700010012052O0100014O00B4000200023O001205012O00023O0026433O000B0001000200042D012O000B0001002E3B000400020001000300042D012O000200010026430001000F0001000100042D012O000F0001002E3B0006000B0001000500042D012O000B00010012E2000300074O006600046O000F0003000200022O00AF000200033O002E9A000800040001000800042D012O00170001000EE0000100190001000200042D012O00190001002E3B0009001C0001000A00042D012O001C00012O00A5000300014O00FF000300023O00042D012O002200012O00A500036O00FF000300023O00042D012O0022000100042D012O000B000100042D012O0022000100042D012O000200012O00B63O00017O00853O00028O00025O00C4AF40025O0097B040026O006B40025O00C07140026O00104003103O004865616C746850657263656E74616765025O00989640025O00088140025O0072A940025O003EA140025O00408340025O00E06840025O004EA040025O00206140025O0020B140025O00D0A14003193O006B534DEF70958F0257510BD570878B0257510BCD7A928E045703083O006B39362B9D15E6E7025O00D4B140025O00B0824003173O00E98E17E7BCCFC7D28516DDBCDDC3D28516C5B6C8C6D48503073O00AFBBEB7195D9BC03073O0049735265616479025O0046AD4003173O0052656672657368696E674865616C696E67506F74696F6E025O00A6AE40025O009BB24003253O002EAA875EE66A7035A1860CEB7C7930A68F4BA3697728A68E42A32O7D3AAA8F5FEA6F7D7CFB03073O00185CCFE12C8319025O00409B40031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O0062AE40025O009EB24003193O006FC1BD4D166A4ADFB349096E63D6B94012734CE3B75812724503063O001D2BB3D82C7B025O0088A440025O0040A340026O006F40025O00F8914003253O00B9CB254DB0CE2140B6DC325FFDD1254DB1D02E4BFDC92F58B4D62E0CB9DC2649B3CA295AB803043O002CDDB940026O000840025O00FAA840025O006EA740026O00F03F025O0034AF40025O00607240030F3O009CF7D3D13FDCB97BACC1D5C334CDB703083O001EDE92A1A25AAED2030A3O0049734361737461626C6503083O0042752O66446F776E030F3O004265727365726B65725374616E6365025O00C08D40025O00C05140025O0056A240025O00707A4003313O00E74B6219E05C7B0FF771631EE440730FA54F761EE05C300EE0487504F647660FA55D640BEB4D754AE14B760FEB5D791CE003043O006A852E10025O00A49940025O00A88540030B3O00702572F04E484B347CF25F03063O00203840139C3A025O0085B340025O00A7B240030B3O004865616C746873746F6E6503173O0052CDE45A4EFA934EC7EB531AF6855CCDEB4553E4851A9B03073O00E03AA885363A92025O000AAA40025O0068AC40030A3O0084DA1EFF6AF39DDC19FE03063O0096CDBD709018025O00F4AC40025O00B2A240030A3O0049676E6F72655061696E025O00A7B140025O0076A14003153O002C83B143168D2E00248DB10C008D17152B97B65A0103083O007045E4DF2C64E871030B3O00E61E0BDFAF7588D33C15CA03073O00E6B47F67B3D61C03103O00417370656374734661766F7242752O66030B3O0052612O6C79696E67437279030A3O004973536F6C6F4D6F6465031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503163O009E04534AFD48EE8B3A5C54FD01E489035A48F748F68903073O0080EC653F268421025O00709B40025O003EAD40027O0040025O004CA440025O0028A940025O00E08B40025O00F49240025O0062B340025O00B8AC40025O00E2A940025O002FB240030E3O00E10696E3CFD1268FFADFCD0696EE03053O00AAA36FE297030E3O0042692O746572492O6D756E697479025O00E8AE40025O0022A540025O0016AB40025O007AA94003193O001339A62C4B2516183DBF2D403E3D0870B63D4832270239A43D03073O00497150D2582E5703133O00A422DF13E08428FF17E08422C800E69525C21C03053O0087E14CAD7203133O00456E7261676564526567656E65726174696F6E031E3O001FE3AAB1ABB8A325FFBDB7A9B3A208ECACB9A3B3E71EE8BEB5A22OAE0CE803073O00C77A8DD8D0CCDD025O00D49640025O000AA240025O003DB240025O00F07F4003093O0085A70541A4FDCAA2AC03073O00AFCCC97124D68B03083O00556E69744E616D65030E3O00496E74657276656E65466F63757303133O004EC221D91651C93BD94443C933D90A54C523D903053O006427AC55BC030F3O00897DBF853DBE71AF8500B979B7833603053O0053CD18D9E0030F3O00446566656E736976655374616E6365025O007EB040025O00309D40025O009C9E40025O00BAA740031A3O00E2C0CB38E8D6C42BE3FADE29E7CBCE38A6C1C83BE3CBDE34F0C003043O005D86A5AD025O00649340025O004AA14000ED012O001205012O00013O002E3B000200690001000300042D012O00690001002E09010400690001000500042D012O006900010026E43O00690001000600042D012O006900012O006600015O0006510001001000013O00042D012O001000012O0066000100013O0020FE0001000100072O000F0001000200022O0066000200023O0006CB000100030001000200042D012O00120001002E3B000800EC2O01000900042D012O00EC2O010012052O0100014O00B4000200023O002E3B000B00180001000A00042D012O001800010026430001001A0001000100042D012O001A0001002E9A000C00FCFF2O000D00042D012O00140001001205010200013O000EAA000100210001000200042D012O00210001002E35000E00210001000F00042D012O00210001002E090110001B0001001100042D012O001B00012O0066000300034O0021010400043O00122O000500123O00122O000600136O00040006000200062O000300290001000400042D012O0029000100042D012O00440001002E3B001500440001001400042D012O004400012O0066000300054O0078000400043O00122O000500163O00122O000600176O0004000600024O00030003000400202O0003000300184O00030002000200062O0003004400013O00042D012O00440001002E9A0019000F0001001900042D012O004400012O0066000300064O0066000400073O00200800040004001A2O000F0003000200020006BB0003003F0001000100042D012O003F0001002E09011C00440001001B00042D012O004400012O0066000300043O0012050104001D3O0012050105001E4O00D1000300054O003600035O002E9A001F00A82O01001F00042D012O00EC2O012O0066000300033O0026E4000300EC2O01002000042D012O00EC2O01002E3B002100EC2O01002200042D012O00EC2O012O0066000300054O0078000400043O00122O000500233O00122O000600246O0004000600024O00030003000400202O0003000300184O00030002000200062O000300EC2O013O00042D012O00EC2O01002E3B002600EC2O01002500042D012O00EC2O01002E09012700EC2O01002800042D012O00EC2O012O0066000300064O0066000400073O00200800040004001A2O000F000300020002000651000300EC2O013O00042D012O00EC2O012O0066000300043O0012C0000400293O00122O0005002A6O000300056O00035O00044O00EC2O0100042D012O001B000100042D012O00EC2O0100042D012O0014000100042D012O00EC2O01000EAA002B006D00013O00042D012O006D0001002E09012C00CC0001002D00042D012O00CC00010012052O0100013O0026E4000100720001002E00042D012O00720001001205012O00063O00042D012O00CC00010026E40001006E0001000100042D012O006E0001001205010200013O0026E4000200790001002E00042D012O007900010012052O01002E3O00042D012O006E00010026E4000200750001000100042D012O00750001002E09013000980001002F00042D012O009800012O0066000300084O0078000400043O00122O000500313O00122O000600326O0004000600024O00030003000400202O0003000300334O00030002000200062O0003009800013O00042D012O009800012O0066000300093O0006510003009800013O00042D012O009800012O0066000300013O0020FE0003000300072O000F0003000200022O00660004000A3O00069E000400980001000300042D012O009800012O0066000300013O00205F0003000300344O000500083O00202O0005000500354O000600016O00030006000200062O0003009A0001000100042D012O009A0001002E09013600A70001003700042D012O00A70001002E09013900A70001003800042D012O00A700012O0066000300064O0066000400083O0020080004000400352O000F000300020002000651000300A700013O00042D012O00A700012O0066000300043O0012050104003A3O0012050105003B4O00D1000300054O003600035O002E3B003D00C90001003C00042D012O00C900012O0066000300054O0078000400043O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O0003000300184O00030002000200062O000300C900013O00042D012O00C900012O00660003000B3O000651000300C900013O00042D012O00C900012O0066000300013O0020FE0003000300072O000F0003000200022O00660004000C3O000672000300C90001000400042D012O00C90001002E09014100C90001004000042D012O00C900012O0066000300064O0066000400073O0020080004000400422O000F000300020002000651000300C900013O00042D012O00C900012O0066000300043O001205010400433O001205010500444O00D1000300054O003600035O0012050102002E3O00042D012O0075000100042D012O006E0001000ED4002E00372O013O00042D012O00372O010012052O0100013O002E3B004500302O01004600042D012O00302O01000ED4000100302O01000100042D012O00302O012O0066000200084O0078000300043O00122O000400473O00122O000500486O0003000500024O00020002000300202O0002000200334O00020002000200062O000200F700013O00042D012O00F700012O00660002000D3O000651000200F700013O00042D012O00F700012O0066000200013O0020FE0002000200072O000F0002000200022O00660003000E3O000672000200F70001000300042D012O00F70001002E09014A00F70001004900042D012O00F700012O0066000200064O007A000300083O00202O00030003004B4O000400056O000600016O00020006000200062O000200F20001000100042D012O00F20001002E3B004C00F70001004D00042D012O00F700012O0066000200043O0012050103004E3O0012050104004F4O00D1000200044O003600026O0066000200084O0078000300043O00122O000400503O00122O000500516O0003000500024O00020002000300202O0002000200334O00020002000200062O0002002F2O013O00042D012O002F2O012O00660002000F3O0006510002002F2O013O00042D012O002F2O012O0066000200013O0020ED0002000200344O000400083O00202O0004000400524O00020004000200062O0002002F2O013O00042D012O002F2O012O0066000200013O0020ED0002000200344O000400083O00202O0004000400534O00020004000200062O0002002F2O013O00042D012O002F2O012O0066000200013O0020FE0002000200072O000F0002000200022O0066000300103O0006720002001D2O01000300042D012O001D2O012O0066000200113O0020080002000200542O00170102000100020006BB000200242O01000100042D012O00242O012O0066000200113O0020060002000200554O000300106O000400126O00020004000200062O0002002F2O013O00042D012O002F2O012O0066000200064O0066000300083O0020080003000300532O000F0002000200020006510002002F2O013O00042D012O002F2O012O0066000200043O001205010300563O001205010400574O00D1000200044O003600025O0012052O01002E3O002E3B005800CF0001005900042D012O00CF00010026E4000100CF0001002E00042D012O00CF0001001205012O005A3O00042D012O00372O0100042D012O00CF0001002E09015B008A2O01005C00042D012O008A2O010026E43O008A2O01000100042D012O008A2O010012052O0100013O002E3B005D00402O01005E00042D012O00402O01002643000100422O01002E00042D012O00422O01002E09015F00442O01006000042D012O00442O01001205012O002E3O00042D012O008A2O01002E090161003C2O01006200042D012O003C2O01000ED40001003C2O01000100042D012O003C2O012O0066000200084O0078000300043O00122O000400633O00122O000500646O0003000500024O00020002000300202O0002000200184O00020002000200062O0002006A2O013O00042D012O006A2O012O0066000200133O0006510002006A2O013O00042D012O006A2O012O0066000200013O0020FE0002000200072O000F0002000200022O0066000300143O0006720002006A2O01000300042D012O006A2O012O0066000200064O0066000300083O0020080003000300652O000F0002000200020006BB000200652O01000100042D012O00652O01002E35006600652O01006700042D012O00652O01002E3B0068006A2O01006900042D012O006A2O012O0066000200043O0012050103006A3O0012050104006B4O00D1000200044O003600026O0066000200084O0078000300043O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300202O0002000200334O00020002000200062O000200882O013O00042D012O00882O012O0066000200153O000651000200882O013O00042D012O00882O012O0066000200013O0020FE0002000200072O000F0002000200022O0066000300163O000672000200882O01000300042D012O00882O012O0066000200064O0066000300083O00200800030003006E2O000F000200020002000651000200882O013O00042D012O00882O012O0066000200043O0012050103006F3O001205010400704O00D1000200044O003600025O0012052O01002E3O00042D012O003C2O01002E09017100010001007200042D012O000100010026E43O00010001005A00042D012O000100010012052O0100013O002643000100932O01000100042D012O00932O01002E3B007300E42O01007400042D012O00E42O012O0066000200084O0078000300043O00122O000400753O00122O000500766O0003000500024O00020002000300202O0002000200334O00020002000200062O000200B92O013O00042D012O00B92O012O0066000200173O000651000200B92O013O00042D012O00B92O012O0066000200183O0020FE0002000200072O000F0002000200022O0066000300193O000672000200B92O01000300042D012O00B92O012O0066000200183O00206B0002000200774O0002000200024O000300013O00202O0003000300774O00030002000200062O000200B92O01000300042D012O00B92O012O0066000200064O0066000300073O0020080003000300782O000F000200020002000651000200B92O013O00042D012O00B92O012O0066000200043O001205010300793O0012050104007A4O00D1000200044O003600026O0066000200084O0078000300043O00122O0004007B3O00122O0005007C6O0003000500024O00020002000300202O0002000200334O00020002000200062O000200D42O013O00042D012O00D42O012O0066000200093O000651000200D42O013O00042D012O00D42O012O0066000200013O0020FE0002000200072O000F0002000200022O00660003001A3O000672000200D42O01000300042D012O00D42O012O0066000200013O00205F0002000200344O000400083O00202O00040004007D4O000500016O00020005000200062O000200D62O01000100042D012O00D62O01002E09017E00E32O01007F00042D012O00E32O01002E3B008000E32O01008100042D012O00E32O012O0066000200064O0066000300083O00200800030003007D2O000F000200020002000651000200E32O013O00042D012O00E32O012O0066000200043O001205010300823O001205010400834O00D1000200044O003600025O0012052O01002E3O002643000100E82O01002E00042D012O00E82O01002E3B0085008F2O01008400042D012O008F2O01001205012O002B3O00042D012O0001000100042D012O008F2O0100042D012O000100012O00B63O00017O00173O00028O00025O0024A840025O00805940025O0029B340025O006EB340026O00F03F025O00CAAB40025O0039B040025O00C49740025O00107740025O00206F40025O00C05640025O0004B240025O003C9C4003103O0048616E646C65546F705472696E6B6574026O004440025O00C88340025O0066B140025O0030A240025O0090774003133O0048616E646C65426F2O746F6D5472696E6B6574025O000AAC40025O0056A740004E3O001205012O00014O00B4000100023O002E090103000B0001000200042D012O000B0001002E3B0004000B0001000500042D012O000B0001000ED40001000B00013O00042D012O000B00010012052O0100014O00B4000200023O001205012O00063O002E9A000700F7FF2O000700042D012O000200010026E43O00020001000600042D012O00020001002E3B0009000F0001000800042D012O000F0001002E9A000A00FEFF2O000A00042D012O000F00010026E40001000F0001000100042D012O000F0001001205010200013O0026430002001A0001000100042D012O001A0001002E3B000B00340001000C00042D012O00340001001205010300013O0026430003001F0001000100042D012O001F0001002E9A000D00120001000E00042D012O002F00012O0066000400013O00204C00040004000F4O000500026O000600033O00122O000700106O000800086O0004000800024O00045O002E2O0011002E0001001200042D012O002E00012O006600045O0006510004002E00013O00042D012O002E00012O006600046O00FF000400023O001205010300063O0026E40003001B0001000600042D012O001B0001001205010200063O00042D012O0034000100042D012O001B0001002643000200380001000600042D012O00380001002E3B001300160001001400042D012O001600012O0066000300013O0020AE0003000300154O000400026O000500033O00122O000600106O000700076O0003000700024O00038O00035O00062O000300450001000100042D012O00450001002E3B0016004D0001001700042D012O004D00012O006600036O00FF000300023O00042D012O004D000100042D012O0016000100042D012O004D000100042D012O000F000100042D012O004D000100042D012O000200012O00B63O00017O003D3O00028O00025O005EA940026O00F03F025O001AB140025O004AA640025O00709540025O002AAF40025O00C09A40025O0024AC40025O0080AD40025O00A89C40030B3O001E3D06B41DFF293C2E221D03083O00555C5169DB798B41030A3O0049734361737461626C65025O00BBB140025O005AA540030B3O00426C2O6F6474686972737403183O00FFBF5F4A78CBF5BA4256689FEDA1554673D2FFB244052D8F03063O00BF9DD330251C03063O00FC17F50E3DDA03053O005ABF7F947C03073O004973526561647903063O00436861726765030E3O0049735370652O6C496E52616E6765025O004EA440025O00188040025O00109440025O002EAF4003133O007B8F2F057F826E076A822D1875852F0338D67C03043O007718E74E025O005BB040025O00D2A940025O000C914003063O0020F1494B721303053O00136187283F030D3O009A55273A21229A5321362A3FBA03063O0051CE3C535B4F030B3O004973417661696C61626C65025O008CAD40025O0016AE4003063O0041766174617203123O004FBDD1662ED10DB45CAED37D22C14CB00EFD03083O00C42ECBB0124FA32D025O00288540025O00B49240030C3O008A277D1528FEFCAB2C7B0D3703073O008FD8421E7E449B030F3O0098CD0EC0C9A6C4F28BCA0CC5C1ACD903083O0081CAA86DABA5C3B7025O00DCAE40030C3O005265636B6C652O736E652O73025O0054AD40025O0050894003183O00305D34D3D211F5315632CBCD54F6305D34D7D316E736186F03073O0086423857B8BE74025O00849940025O00E49E40025O00F0B240025O00A06140025O00B0B140025O0046AC4000E23O001205012O00014O00B4000100023O002E9A000200D50001000200042D012O00D700010026E43O00D70001000300042D012O00D70001002E3B000500060001000400042D012O000600010026E4000100060001000100042D012O00060001001205010200013O002E3B000600580001000700042D012O00580001002643000200110001000300042D012O00110001002E3B000900580001000800042D012O00580001002E09010B00320001000A00042D012O003200012O006600036O0078000400013O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003003200013O00042D012O003200012O0066000300023O0006510003003200013O00042D012O003200012O0066000300033O0006510003003200013O00042D012O00320001002E09011000320001000F00042D012O003200012O0066000300044O002601045O00202O0004000400114O000500036O000500056O00030005000200062O0003003200013O00042D012O003200012O0066000300013O001205010400123O001205010500134O00D1000300054O003600036O0066000300053O000651000300E100013O00042D012O00E100012O006600036O0078000400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300164O00030002000200062O000300E100013O00042D012O00E100012O0066000300033O0006BB000300E10001000100042D012O00E100012O0066000300044O009300045O00202O0004000400174O000500063O00202O0005000500184O00075O00202O0007000700174O0005000700024O000500056O00030005000200062O000300520001000100042D012O00520001002E0E001900520001001A00042D012O00520001002E09011C00E10001001B00042D012O00E100012O0066000300013O0012C00004001D3O00122O0005001E6O000300056O00035O00044O00E100010026E40002000B0001000100042D012O000B0001001205010300013O000EAA0001005F0001000300042D012O005F0001002E09011F00CC0001002000042D012O00CC0001002E9A002100350001002100042D012O009400012O0066000400073O0006510004009400013O00042D012O009400012O0066000400083O0006510004006A00013O00042D012O006A00012O0066000400093O0006BB0004006D0001000100042D012O006D00012O0066000400083O0006BB000400940001000100042D012O009400012O00660004000A4O00660005000B3O00069E000400940001000500042D012O009400012O006600046O0078000500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004009400013O00042D012O009400012O006600046O008F000500013O00122O000600243O00122O000700256O0005000700024O00040004000500202O0004000400264O00040002000200062O000400940001000100042D012O00940001002E3B002700940001002800042D012O009400012O0066000400044O002601055O00202O0005000500294O000600036O000600066O00040006000200062O0004009400013O00042D012O009400012O0066000400013O0012050105002A3O0012050106002B4O00D1000400064O003600045O002E09012C00CB0001002D00042D012O00CB00012O00660004000C3O000651000400CB00013O00042D012O00CB00012O00660004000D3O0006510004009F00013O00042D012O009F00012O0066000400093O0006BB000400A20001000100042D012O00A200012O00660004000D3O0006BB000400CB0001000100042D012O00CB00012O00660004000A4O00660005000B3O00069E000400CB0001000500042D012O00CB00012O006600046O0078000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400CB00013O00042D012O00CB00012O006600046O008F000500013O00122O000600303O00122O000700316O0005000700024O00040004000500202O0004000400264O00040002000200062O000400CB0001000100042D012O00CB0001002E9A003200110001003200042D012O00CB00012O0066000400044O000D01055O00202O0005000500334O000600036O000600066O00040006000200062O000400C60001000100042D012O00C60001002E3B003400CB0001003500042D012O00CB00012O0066000400013O001205010500363O001205010600374O00D1000400064O003600045O001205010300033O002E090138005B0001003900042D012O005B00010026E40003005B0001000300042D012O005B0001001205010200033O00042D012O000B000100042D012O005B000100042D012O000B000100042D012O00E1000100042D012O0006000100042D012O00E10001002E09013B00020001003A00042D012O00020001002E09013D00020001003C00042D012O000200010026E43O00020001000100042D012O000200010012052O0100014O00B4000200023O001205012O00033O00042D012O000200012O00B63O00017O0094012O00028O00026O00F03F025O00806540025O0058A040025O00A4AB40025O003EAE40026O000840025O00C4AD40025O00B8A84003073O00791DC5AC37CC5903063O00B83C65A0CF4203073O004973526561647903063O0042752O665570030A3O00456E7261676542752O66025O0090A04003073O004578656375746503183O00349A79BF249679FC228B72BB3D8743A830907BB925C22EEA03043O00DC51E21C03073O0021D48F2OEBC01603063O00A773B5E29B8A030F3O00C32CE059695CC7EC23E0597674C8F603073O00A68242873C1B11030B3O004973417661696C61626C65025O00BCA240025O00607640025O00FAA340025O0052A440025O00A6A240025O001DB24003073O0052616D7061676503183O00564BC36531434F8E66394A4DC2700F504BDC7235500A9C2D03053O0050242AAE1503073O006B0832795B043203043O001A2E705703183O00BC3BAE77AAAB40F4AA2AA573B3BA7AA0B831AC71ABFF17ED03083O00D4D943CB142ODF25025O001CA240025O00E89040025O00C49340025O00AEA54003093O009881A7DDBE8FA9C6B203043O00B2DAEDC8030A3O0049734361737461626C65030F3O0084B0E5DBBAB0F5C397B7E7DEB2BAE803043O00B0D6D586030C3O00C3BFB7C0A02O57F08BA3C6B103073O003994CDD6B4C83603093O00426C2O6F6462617468025O004EB140025O00804940031A3O0010F13A3B7210FC213C3601F43B337A17C221356415F82174254203053O0016729D5554026O001040026O001C40025O003C9D40025O00389F40030C3O00CFBA16D754E5A604E650E3BF03053O003C8CC863A403083O0042752O66446F776E03163O00467572696F7573426C2O6F6474686972737442752O66030C3O004372757368696E67426C6F77031E3O0084E61135AA8EFA0319A08BFB1366B18EFA032AA7B8E00534A582E04473F603053O00C2E7946446030B3O006440CEACF2DC4E45D3B0E203063O00A8262CA1C396025O0046A040025O00E4AE40025O00AAA940025O00F2AA40030B3O00426C2O6F64746869727374031C3O0082F08D7934FCBE1F92EF963623E1B8118CF9BD6231FAB11394BCD72003083O0076E09CE2165088D603093O0075E650924EF9508E4603043O00E0228E39025O00049D40025O00804D4003093O00576869726C77696E64030E3O004973496E4D656C2O6552616E6765025O00688040025O00149540031A3O00C9AFCCCF7FE65400DAE7D6D47DF6510BE1B3C4CF74F4494E8BFF03083O006EBEC7A5BD13913D026O001440025O003AB040025O00409340025O00CAA740025O00EEA240026O005A40030B3O00162A0FCFF1202E09D2E62003053O0095544660A0030C3O000F140CF9300703E91E131FF403043O008D58666D025O00B6B140025O002EA740031C3O00B15FC57F1E295DC8A140DE3009345BC6BF56F5641B2F52C4A7139E2403083O00A1D333AA107A5D35030A3O00C9AFB521F5A99024F4B903043O00489BCED2030A3O00747B53073D412O58012403053O0053261A346E03073O0043686172676573030A3O00526167696E67426C6F77031C3O004A16204F56101844541830064B1E294154121852590520434C57731003043O0026387747027O0040026O001840025O0068B240025O00CAAD40025O0080A240025O007DB240025O00B8AB40025O00206340025O001EA04003093O00D17DF9031448F265FE03063O002A9311966C70030C3O0038B42C6BEFE901A20B6AF5F103063O00886FC64D1F87025O00549F40025O004FB240025O0030A440025O005EA940031A4O0005A859B9E616BD0A49B45FB3E31BAC3D1DA644BAE103E9565903083O00C96269C736DD8477030C3O009A1E96320A3CA2BE2E8F2E1503073O00CCD96CE3416255030F3O006CC6F6EE20C54DD0D4E72DCE5ACCFB03063O00A03EA395854C025O009C9B40025O00A08C40031E3O00D5B2183CCBDFAE0A10C1DAAF1A6FD0DFAE0A23C6E9B40C3DC4D3B44D7B9103053O00A3B6C06D4F025O000AAC40025O00C4AC40025O006C9B40025O00A88540025O002OAA40025O00C05240025O00E07A40025O00EFB140025O00E8A74003093O00B525AC58D057188C2903073O0071E24DC52ABC2003103O00131BE4A73500F1B10D1EFDB92D1FFAB103043O00D55A7694030F3O004D656174436C656176657242752O66025O003DB040025O0026A94003193O004C26BD44414C27BA520D4827BA51415E11A0575F5C2BA0161F03053O002D3B4ED436025O007C9C40025O00BCA54003073O00354E8688933AA803083O00907036E3EBE64ECD03133O00417368656E4A752O6765726E61757442752O66030B3O0042752O6652656D61696E732O033O00474344025O00D4AA40025O00909B40025O00B8A940025O00EC964003173O00B6300AFFC54FB6681CF5DE5CBF2D30E8D149B42D1BBC8403063O003BD3486F9CB0025O0090AF40025O00709C4003093O006183FA235DA1F63F5703043O004D2EE783030D3O009E55B843B35AB162B655B245A903043O0020DA34D603113O0044616E63696E67426C6164657342752O66030D3O006A163FABF8BE4278421635ADE203083O003A2E7751C891D025025O00689540026O008340025O007AA840025O00389A40025O0060B040025O00C2A34003093O004F64796E7346757279031A3O00248829A2BA82303E9E29ECBAB4382C803593BDBC242C8924ECFF03073O00564BEC50CCC9DD025O0071B240025O0038944003073O002O407A95FF8C7703063O00EB122117E59E030F3O0071B4C6BE4297C0B551BDC4B655B4D503043O00DB30DAA103103O005265636B6C652O736E652O7342752O66030E3O005261676550657263656E74616765025O00405540025O00489840025O002AA24003173O00F6707159DA48E5A4627547DC43E5DB657D5BDC4AF4A42903073O008084111C29BB2F025O00509140025O00ADB140025O003EA540025O0020754003093O00A3F35F3E13597D84E903073O001AEC9D2C52722C03093O001E2BDB5F2F3CDC412F03043O003B4A4EB5025O000FB140025O0008AA4003093O004F6E736C6175676874025O00A0A640025O0021B240031A3O002ADF4956B230D6524EF336D8545DBF20EE4E5BA122D44E1AE27D03053O00D345B12O3A025O00AEA140025O00F0B040025O00908B40026O003540030C3O0094F76CE6E1C2B9E25BF9E6DC03063O00ABD785199589030C3O00D6DA33EEE731F246C7DD20E303083O002281A8529A8F509C025O00109240025O00107840031E3O0086A02618404787828D31074759C996BB3D0C444BB691B3210C4D5AC9D7E203073O00E9E5D2536B282E025O008AA240025O00B5B24003073O00E45A37D510D54703053O0065A12252B6030F3O0053752O64656E446561746842752O6603103O004865616C746850657263656E74616765025O0080414003083O00C50C4AEDDAE1902B03083O004E886D399EBB82E2026O003440025O00BC9C40025O00C09140025O00CCAA4003183O003B27FCF22O2BFCB12D36F7F6323AC6E53F2DFEF42A7FABA303043O00915E5F99025O00608740025O00E0A14003073O00CFCC19C54FB0F803063O00D79DAD74B52E030F3O0007B188F9D630A798D3D834BA8FFDD403053O00BA55D4EB92025O000CB04003183O00D0801BEE38E95D82921FF03EE25DFD9517EC3EEB4C82D34203073O0038A2E1769E598E025O0078A840025O0042AD4003093O00227F0D704F0C8B147B03073O00EA6013621F2B6E025O00D88B40025O0079B140031A3O0004135DC8A8708A121712D4A57C8C0A1A6DD3AD608C030B1292FC03073O00EB667F32A7CC12030A3O0062A0F22A4A2972ADFA3403063O004E30C1954324025O00FAB240025O004EB340031C3O00221F87114F372182144E275E93114F3712852755310C871D55704BD203053O0021507EE078025O00C49940025O0018A44003073O00C1EE55C62451F603063O0036938F38B645025O00FEA740025O00AEA440025O00C88340025O00A09940025O0048B140025O0020A94003183O00C480F259DED184BF5AD6D886F34CE0C280ED4EDAC2C1AB1E03053O00BFB6E19F29025O0068AD40025O00C8A24003043O00181E295803073O00A24B724835EBE7030B3O00AD324AEB5B0B803D50ED4103063O0062EC5C248233025O00709840025O006CAC40025O0014A340025O00CCAF4003043O00536C616D03153O00B7150DB705BBBC3EA315098551A9A737A10D4CEE1D03083O0050C4796CDA25C8D5025O00C6AD40025O003EB040030D3O00437269744368616E636550637403093O0042752O66537461636B03143O004D657263696C652O73412O7361756C7442752O66026O002440030E3O00426C2O6F646372617A6542752O66026O002E40025O00C0574003113O00223D0A3E6E15370336750E262436520E3603053O003D6152665A03073O0048617354696572026O003E40026O00AF40025O00F09040025O00388740025O00804740025O0029B040025O003C9C40025O001EAC40025O008C9040025O00B07B40025O00D09640025O006C9540025O0096A340025O0026A540025O00E06F4003093O008E22A444C3551F1DA403083O0069CC4ECB2BA7377E025O001CAF40025O00F4B240031A3O00A7A62C111706C645ADEA30171D03CB549ABE220C1401D311F4FA03083O0031C5CA437E7364A7030B3O001557D0268442563E49CC3D03073O003E573BBF49E036025O0041B240031C3O00E50EF5C6E316F2C0F511EE89F40BF4CEEB07C5DDE610FDCCF342AB9B03043O00A987629A025O00DEA640025O00B6A74003093O00E97B2B5BF931C9DF7F03073O00A8AB1744349D53026O003F40025O002EAC40025O00D0A340031A3O00F67DFAA2212F86E079B5BE2C2380F874CAB9243F80F165B5FC7103073O00E7941195CD454D025O0053B140025O00A49E40025O00989140025O00B6AC40030E3O00B4AFD2F553FA92A8D2E865F081B503063O009FE0C7A79B37030E3O005468756E6465726F7573526F6172025O0020AA40025O003EAC4003203O00E3FB29DCF3F62EDDE2E003C0F8F22E92E4FA32D5FBF603C6F6E13BD7E3B36D8403043O00B297935C025O0058AB40025O00B88340025O00A8B240025O00406A40025O00C89C40025O00E8AE4003073O00F6CA1ED45CF1AD03073O00C8A4AB73A43D9603083O0093F5105682BDE60603053O00E3DE946325025O006AA440025O0080A540025O0096A040025O0068974003183O0021535FE6F8345712E5F03D555EF3C6275340F1FC271201A403053O0099532O3296025O00BEB140025O008EA040030B3O007F7A7C1377BF455464600803073O002D3D16137C13CB030B3O00E01C03FC0A79B5C00602E703073O00D9A1726D956210025O00EC9E40025O00109E40025O003C9040025O00408A40025O00FCB040031C3O00102C3773B8601A292A6FA8340129367BB0712D34396EBB7106606B2803063O00147240581CDC025O00E7B140025O0093B140025O0023B040025O0002B240025O007DB040025O0042B040025O0021B040026O008540025O0034A640025O00E3B240025O00D88F40025O0014AB40030A3O000300D5BDF6D79F3D0EC503073O00DD5161B2D498B0030A3O00FFE61AF214CAC511F40D03053O007AAD877D9B030C3O00B3D301AD3730C680E715AB2603073O00A8E4A160D95F51031C3O00C9D029552150E4D322533817C8D8205B2352E4C52F4E2852CF917D0A03063O0037BBB14E3C4F025O00207240025O00B88A40030C3O000EDC4AF84EC68E2AEC53E45103073O00E04DAE3F8B26AF030C3O00A7534D3D8C485629A64D573903043O004EE42138030C3O00F96CB3178DCF70B62590DC6703053O00E5AE1ED263025O00549640025O0006AE40025O00F9B140025O005EB140031E3O0018FF9342E534371CD2845DE22A7908E48856E138060FEC9456E8297948B503073O00597B8DE6318D5D0024072O001205012O00014O00B4000100033O0026433O00060001000200042D012O00060001002E090104001C0701000300042D012O001C07012O00B4000300033O0026E40001000C0001000100042D012O000C0001001205010200014O00B4000300033O0012052O0100023O002E3B000500070001000600042D012O000700010026E4000100070001000200042D012O000700010026E4000200B70001000700042D012O00B70001002E3B000900370001000800042D012O003700012O006600046O0078000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004003700013O00042D012O003700012O0066000400023O0006510004003700013O00042D012O003700012O0066000400033O0020ED00040004000D4O00065O00202O00060006000E4O00040006000200062O0004003700013O00042D012O00370001002E9A000F000F0001000F00042D012O003700012O0066000400044O002601055O00202O0005000500104O000600056O000600066O00040006000200062O0004003700013O00042D012O003700012O0066000400013O001205010500113O001205010600124O00D1000400064O003600046O006600046O0078000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004004E00013O00042D012O004E00012O0066000400063O0006510004004E00013O00042D012O004E00012O006600046O008F000500013O00122O000600153O00122O000700166O0005000700024O00040004000500202O0004000400174O00040002000200062O000400500001000100042D012O00500001002E9A001800130001001900042D012O00610001002E09011A00610001001B00042D012O00610001002E3B001C00610001001D00042D012O006100012O0066000400044O002601055O00202O00050005001E4O000600056O000600066O00040006000200062O0004006100013O00042D012O006100012O0066000400013O0012050105001F3O001205010600204O00D1000400064O003600046O006600046O0078000500013O00122O000600213O00122O000700226O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007B00013O00042D012O007B00012O0066000400023O0006510004007B00013O00042D012O007B00012O0066000400044O002601055O00202O0005000500104O000600056O000600066O00040006000200062O0004007B00013O00042D012O007B00012O0066000400013O001205010500233O001205010600244O00D1000400064O003600045O002E3B002600B60001002500042D012O00B60001002E3B002700B60001002800042D012O00B600012O006600046O0078000500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400B600013O00042D012O00B600012O0066000400073O000651000400B600013O00042D012O00B600012O0066000400033O0020ED00040004000D4O00065O00202O00060006000E4O00040006000200062O000400B600013O00042D012O00B600012O006600046O0078000500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O0004000400174O00040002000200062O000400B600013O00042D012O00B600012O006600046O008F000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O0004000400174O00040002000200062O000400B60001000100042D012O00B600012O0066000400044O000D01055O00202O0005000500304O000600056O000600066O00040006000200062O000400B10001000100042D012O00B10001002E3B003100B60001003200042D012O00B600012O0066000400013O001205010500333O001205010600344O00D1000400064O003600045O001205010200353O0026E40002001F2O01003600042D012O001F2O01002E09013700DC0001003800042D012O00DC00012O006600046O0078000500013O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400DC00013O00042D012O00DC00012O0066000400083O000651000400DC00013O00042D012O00DC00012O0066000400033O0020ED00040004003B4O00065O00202O00060006003C4O00040006000200062O000400DC00013O00042D012O00DC00012O0066000400044O002601055O00202O00050005003D4O000600056O000600066O00040006000200062O000400DC00013O00042D012O00DC00012O0066000400013O0012050105003E3O0012050106003F4O00D1000400064O003600046O006600046O0078000500013O00122O000600403O00122O000700416O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400E900013O00042D012O00E900012O0066000400093O0006BB000400ED0001000100042D012O00ED0001002E0E004300ED0001004200042D012O00ED0001002E09014500FA0001004400042D012O00FA00012O0066000400044O002601055O00202O0005000500464O000600056O000600066O00040006000200062O000400FA00013O00042D012O00FA00012O0066000400013O001205010500473O001205010600484O00D1000400064O003600046O00660004000A3O0006510004002307013O00042D012O002307012O006600046O0078000500013O00122O000600493O00122O0007004A6O0005000700024O00040004000500202O00040004002B4O00040002000200062O0004002307013O00042D012O002307012O00660004000B3O0006510004002307013O00042D012O00230701002E3B004C00172O01004B00042D012O00172O012O0066000400044O004800055O00202O00050005004D4O0006000C3O00202O00060006004E4O0008000D6O0006000800024O000600066O00040006000200062O000400192O01000100042D012O00192O01002E3B005000230701004F00042D012O002307012O0066000400013O0012C0000500513O00122O000600526O000400066O00045O00044O00230701002643000200232O01005300042D012O00232O01002E09015400FF2O01000800042D012O00FF2O01001205010400014O00B4000500053O002643000400292O01000100042D012O00292O01002E9A005500FEFF2O005600042D012O00252O01001205010500013O002E9A005700580001005700042D012O00822O010026E4000500822O01000200042D012O00822O01002E9A0058002F0001005800042D012O005D2O012O006600066O0078000700013O00122O000800593O00122O0009005A6O0007000900024O00060006000700202O00060006002B4O00060002000200062O0006005D2O013O00042D012O005D2O012O0066000600093O0006510006005D2O013O00042D012O005D2O012O006600066O008F000700013O00122O0008005B3O00122O0009005C6O0007000900024O00060006000700202O0006000600174O00060002000200062O0006005D2O01000100042D012O005D2O012O0066000600033O0020ED00060006003B4O00085O00202O00080008003C4O00060008000200062O0006005D2O013O00042D012O005D2O01002E3B005E005D2O01005D00042D012O005D2O012O0066000600044O002601075O00202O0007000700464O000800056O000800086O00060008000200062O0006005D2O013O00042D012O005D2O012O0066000600013O0012050107005F3O001205010800604O00D1000600084O003600066O006600066O0078000700013O00122O000800613O00122O000900626O0007000900024O00060006000700202O00060006002B4O00060002000200062O000600812O013O00042D012O00812O012O00660006000E3O000651000600812O013O00042D012O00812O012O006600066O0084000700013O00122O000800633O00122O000900646O0007000900024O00060006000700202O0006000600654O000600020002000E2O000200812O01000600042D012O00812O012O0066000600044O002601075O00202O0007000700664O000800056O000800086O00060008000200062O000600812O013O00042D012O00812O012O0066000600013O001205010700673O001205010800684O00D1000600084O003600065O001205010500693O0026E4000500862O01006900042D012O00862O010012050102006A3O00042D012O00FF2O01002E09016C002A2O01006B00042D012O002A2O010026430005008C2O01000100042D012O008C2O01002E090145002A2O01006D00042D012O002A2O01001205010600013O002E09016F00932O01006E00042D012O00932O010026E4000600932O01000200042D012O00932O01001205010500023O00042D012O002A2O01002643000600972O01000100042D012O00972O01002E9A007000F8FF2O007100042D012O008D2O012O006600076O0078000800013O00122O000900723O00122O000A00736O0008000A00024O00070007000800202O00070007002B4O00070002000200062O000700C62O013O00042D012O00C62O012O0066000700073O000651000700C62O013O00042D012O00C62O012O0066000700033O0020ED00070007000D4O00095O00202O00090009000E4O00070009000200062O000700B52O013O00042D012O00B52O012O006600076O008F000800013O00122O000900743O00122O000A00756O0008000A00024O00070007000800202O0007000700174O00070002000200062O000700C62O01000100042D012O00C62O012O0066000700044O000D01085O00202O0008000800304O000900056O000900096O00070009000200062O000700C12O01000100042D012O00C12O01002E35007700C12O01007600042D012O00C12O01002E9A007800070001007900042D012O00C62O012O0066000700013O0012050108007A3O0012050109007B4O00D1000700094O003600076O006600076O0078000800013O00122O0009007C3O00122O000A007D6O0008000A00024O00070007000800202O00070007002B4O00070002000200062O000700EB2O013O00042D012O00EB2O012O0066000700083O000651000700EB2O013O00042D012O00EB2O012O0066000700033O0020ED00070007000D4O00095O00202O00090009000E4O00070009000200062O000700EB2O013O00042D012O00EB2O012O006600076O0078000800013O00122O0009007E3O00122O000A007F6O0008000A00024O00070007000800202O0007000700174O00070002000200062O000700EB2O013O00042D012O00EB2O012O0066000700033O0020DD00070007003B4O00095O00202O00090009003C4O00070009000200062O000700ED2O01000100042D012O00ED2O01002E09018000FA2O01008100042D012O00FA2O012O0066000700044O002601085O00202O00080008003D4O000900056O000900096O00070009000200062O000700FA2O013O00042D012O00FA2O012O0066000700013O001205010800823O001205010900834O00D1000700094O003600075O001205010600023O00042D012O008D2O0100042D012O002A2O0100042D012O00FF2O0100042D012O00252O01002E3B008400030201008500042D012O00030201002643000200050201000100042D012O00050201002E09018600150301008700042D012O00150301001205010400013O002E9A008800060001008800042D012O000C02010026E40004000C0201006900042D012O000C0201001205010200023O00042D012O00150301002643000400120201000100042D012O00120201002E0E008A00120201008900042D012O00120201002E09018B00770201008C00042D012O007702012O006600056O0078000600013O00122O0007008D3O00122O0008008E6O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005004502013O00042D012O004502012O00660005000B3O0006510005004502013O00042D012O004502012O00660005000F3O000E2B010200450201000500042D012O004502012O006600056O0078000600013O00122O0007008F3O00122O000800906O0006000800024O00050005000600202O0005000500174O00050002000200062O0005004502013O00042D012O004502012O0066000500033O0020ED00050005003B4O00075O00202O0007000700914O00050007000200062O0005004502013O00042D012O004502012O0066000500044O004800065O00202O00060006004D4O0007000C3O00202O00070007004E4O0009000D6O0007000900024O000700076O00050007000200062O000500400201000100042D012O00400201002E09019200450201009300042D012O004502012O0066000500013O001205010600943O001205010700954O00D1000500074O003600055O002E3B009600760201009700042D012O007602012O006600056O0078000600013O00122O000700983O00122O000800996O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005007602013O00042D012O007602012O0066000500023O0006510005007602013O00042D012O007602012O0066000500033O0020ED00050005000D4O00075O00202O00070007009A4O00050007000200062O0005007602013O00042D012O007602012O0066000500033O00202200050005009B4O00075O00202O00070007009A4O0005000700024O000600033O00202O00060006009C4O00060002000200062O000500760201000600042D012O00760201002E09019E006F0201009D00042D012O006F02012O0066000500044O000D01065O00202O0006000600104O000700056O000700076O00050007000200062O000500710201000100042D012O00710201002E3B009F0076020100A000042D012O007602012O0066000500013O001205010600A13O001205010700A24O00D1000500074O003600055O001205010400023O0026E4000400060201000200042D012O00060201001205010500013O002E3B00A4000F030100A300042D012O000F03010026E40005000F0301000100042D012O000F03012O0066000600103O000651000600BA02013O00042D012O00BA02012O0066000600113O0006510006008702013O00042D012O008702012O0066000600123O0006BB0006008A0201000100042D012O008A02012O0066000600113O0006BB000600BA0201000100042D012O00BA02012O006600066O0078000700013O00122O000800A53O00122O000900A66O0007000900024O00060006000700202O00060006002B4O00060002000200062O000600BA02013O00042D012O00BA02012O0066000600134O0066000700143O00069E000600BA0201000700042D012O00BA02012O0066000600033O0020ED00060006000D4O00085O00202O00080008000E4O00060008000200062O000600BA02013O00042D012O00BA02012O006600066O0078000700013O00122O000800A73O00122O000900A86O0007000900024O00060006000700202O0006000600174O00060002000200062O000600B002013O00042D012O00B002012O0066000600033O0020F200060006009B4O00085O00202O0008000800A94O00060008000200262O000600BC0201005300042D012O00BC02012O006600066O0078000700013O00122O000800AA3O00122O000900AB6O0007000900024O00060006000700202O0006000600174O00060002000200062O000600BC02013O00042D012O00BC0201002E9A00AC0016000100AD00042D012O00D00201002E0901AF00D0020100AE00042D012O00D00201002E0901B100D0020100B000042D012O00D002012O0066000600044O00DB00075O00202O0007000700B24O0008000C3O00202O00080008004E4O000A000D6O0008000A00024O000800086O00060008000200062O000600D002013O00042D012O00D002012O0066000600013O001205010700B33O001205010800B44O00D1000600084O003600065O002E3B00B6000E030100B500042D012O000E03012O006600066O0078000700013O00122O000800B73O00122O000900B86O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006000E03013O00042D012O000E03012O0066000600063O0006510006000E03013O00042D012O000E03012O006600066O0078000700013O00122O000800B93O00122O000900BA6O0007000900024O00060006000700202O0006000600174O00060002000200062O0006000E03013O00042D012O000E03012O0066000600033O0020DD00060006000D4O00085O00202O0008000800BB4O00060008000200062O000600FF0201000100042D012O00FF02012O0066000600033O00209400060006009B4O00085O00202O00080008000E4O0006000800024O000700033O00202O00070007009C4O00070002000200062O000600FF0201000700042D012O00FF02012O0066000600033O0020FE0006000600BC2O000F000600020002000E2B01BD000E0301000600042D012O000E0301002E3B00BE000E030100BF00042D012O000E03012O0066000600044O002601075O00202O00070007001E4O000800056O000800086O00060008000200062O0006000E03013O00042D012O000E03012O0066000600013O001205010700C03O001205010800C14O00D1000600084O003600065O001205010500023O0026E40005007A0201000200042D012O007A0201001205010400693O00042D012O0006020100042D012O007A020100042D012O000602010026E40002001F0401006900042D012O001F0401001205010400013O002E3B00C2001C030100C300042D012O001C0301000EAA0001001E0301000400042D012O001E0301002E9A00C4006A000100C500042D012O008603012O006600056O0078000600013O00122O000700C63O00122O000800C76O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005003C03013O00042D012O003C03012O0066000500153O0006510005003C03013O00042D012O003C03012O0066000500033O0020DD00050005000D4O00075O00202O00070007000E4O00050007000200062O0005003E0301000100042D012O003E03012O006600056O008F000600013O00122O000700C83O00122O000800C96O0006000800024O00050005000600202O0005000500174O00050002000200062O0005003E0301000100042D012O003E0301002E0901CA004D030100CB00042D012O004D03012O0066000500044O000D01065O00202O0006000600CC4O000700056O000700076O00050007000200062O000500480301000100042D012O00480301002E3B00CE004D030100CD00042D012O004D03012O0066000500013O001205010600CF3O001205010700D04O00D1000500074O003600055O002E0901D10085030100D200042D012O00850301002E3B00D40085030100D300042D012O008503012O006600056O0078000600013O00122O000700D53O00122O000800D66O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005008503013O00042D012O008503012O0066000500083O0006510005008503013O00042D012O008503012O006600056O0078000600013O00122O000700D73O00122O000800D86O0006000800024O00050005000600202O0005000500174O00050002000200062O0005008503013O00042D012O008503012O0066000500033O0020ED00050005000D4O00075O00202O00070007000E4O00050007000200062O0005008503013O00042D012O008503012O0066000500033O0020ED00050005003B4O00075O00202O00070007003C4O00050007000200062O0005008503013O00042D012O008503012O0066000500044O000D01065O00202O00060006003D4O000700056O000700076O00050007000200062O000500800301000100042D012O00800301002E0901D90085030100DA00042D012O008503012O0066000500013O001205010600DB3O001205010700DC4O00D1000500074O003600055O001205010400023O002E0901DD001A040100DE00042D012O001A04010026E40004001A0401000200042D012O001A04012O006600056O0078000600013O00122O000700DF3O00122O000800E06O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500CA03013O00042D012O00CA03012O0066000500023O000651000500CA03013O00042D012O00CA03012O0066000500033O0020ED00050005000D4O00075O00202O00070007000E4O00050007000200062O000500AC03013O00042D012O00AC03012O0066000500033O0020ED00050005003B4O00075O00202O00070007003C4O00050007000200062O000500AC03013O00042D012O00AC03012O0066000500033O0020DD00050005000D4O00075O00202O00070007009A4O00050007000200062O000500CC0301000100042D012O00CC03012O0066000500033O0020D200050005009B4O00075O00202O0007000700E14O0005000700024O000600033O00202O00060006009C4O00060002000200062O000500CA0301000600042D012O00CA03012O00660005000C3O0020FE0005000500E22O000F000500020002000E2B01E300C50301000500042D012O00C503012O006600056O008F000600013O00122O000700E43O00122O000800E56O0006000800024O00050005000600202O0005000500174O00050002000200062O000500CC0301000100042D012O00CC03012O00660005000C3O0020FE0005000500E22O000F000500020002000EE000E600CC0301000500042D012O00CC0301002E3B00E700DB030100E800042D012O00DB0301002E9A00E9000F000100E900042D012O00DB03012O0066000500044O002601065O00202O0006000600104O000700056O000700076O00050007000200062O000500DB03013O00042D012O00DB03012O0066000500013O001205010600EA3O001205010700EB4O00D1000500074O003600055O002E0901EC0019040100ED00042D012O001904012O006600056O0078000600013O00122O000700EE3O00122O000800EF6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005001904013O00042D012O001904012O0066000500063O0006510005001904013O00042D012O001904012O006600056O0078000600013O00122O000700F03O00122O000800F16O0006000800024O00050005000600202O0005000500174O00050002000200062O0005001904013O00042D012O001904012O0066000500033O0020DD00050005000D4O00075O00202O0007000700BB4O00050007000200062O0005000A0401000100042D012O000A04012O0066000500033O00209400050005009B4O00075O00202O00070007000E4O0005000700024O000600033O00202O00060006009C4O00060002000200062O0005000A0401000600042D012O000A04012O0066000500033O0020FE0005000500BC2O000F000500020002000E2B01BD00190401000500042D012O001904012O0066000500044O000D01065O00202O00060006001E4O000700056O000700076O00050007000200062O000500140401000100042D012O00140401002E3B00F200190401008000042D012O001904012O0066000500013O001205010600F33O001205010700F44O00D1000500074O003600055O001205010400693O0026E4000400180301006900042D012O00180301001205010200073O00042D012O001F040100042D012O00180301002E3B00F500C4040100F600042D012O00C404010026E4000200C40401006A00042D012O00C40401001205010400013O0026E40004005F0401000200042D012O005F04012O006600056O0078000600013O00122O000700F73O00122O000800F86O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005004204013O00042D012O004204012O0066000500073O0006510005004204013O00042D012O00420401002E3B00F90042040100FA00042D012O004204012O0066000500044O002601065O00202O0006000600304O000700056O000700076O00050007000200062O0005004204013O00042D012O004204012O0066000500013O001205010600FB3O001205010700FC4O00D1000500074O003600056O006600056O0078000600013O00122O000700FD3O00122O000800FE6O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005005E04013O00042D012O005E04012O00660005000E3O0006510005005E04013O00042D012O005E04012O0066000500044O000D01065O00202O0006000600664O000700056O000700076O00050007000200062O000500590401000100042D012O00590401002E9A00FF000700012O0001042D012O005E04012O0066000500013O0012050106002O012O00120501070002013O00D1000500074O003600055O001205010400693O00120501050003012O00120501060004012O000672000500BE0401000600042D012O00BE0401001205010500013O000647000500BE0401000400042D012O00BE04012O006600056O0078000600013O00122O00070005012O00122O00080006015O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005007304013O00042D012O007304012O0066000500063O0006BB000500770401000100042D012O0077040100120501050007012O00120501060008012O0006720005008C0401000600042D012O008C04012O0066000500044O000D01065O00202O00060006001E4O000700056O000700076O00050007000200062O000500870401000100042D012O0087040100120501050009012O0012050106000A012O0006D3000600870401000500042D012O008704010012050105000B012O0012050106000C012O0006720005008C0401000600042D012O008C04012O0066000500013O0012050106000D012O0012050107000E013O00D1000500074O003600055O0012050105000F012O00120501060010012O00069E000600A70401000500042D012O00A704012O006600056O0078000600013O00122O00070011012O00122O00080012015O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500A704013O00042D012O00A704012O0066000500163O000651000500A704013O00042D012O00A704012O006600056O008F000600013O00122O00070013012O00122O00080014015O0006000800024O00050005000600202O0005000500174O00050002000200062O000500AB0401000100042D012O00AB040100120501050015012O00120501060016012O00069E000600BD0401000500042D012O00BD040100120501050017012O00120501060018012O00069E000500BD0401000600042D012O00BD04012O0066000500044O003C00065O00122O00070019015O0006000600074O000700056O000700076O00050007000200062O000500BD04013O00042D012O00BD04012O0066000500013O0012050106001A012O0012050107001B013O00D1000500074O003600055O001205010400023O001205010500693O000647000400240401000500042D012O00240401001205010200363O00042D012O00C4040100042D012O00240401001205010400023O00069B000200CB0401000400042D012O00CB04010012050104001C012O0012050105001D012O000672000500F60501000400042D012O00F605012O0066000400174O0089000500033O00122O0007001E015O0005000500074O0005000200024O000600186O000700033O00202O00070007000D4O00095O00202O0009000900BB4O000700096O00063O000200122O000700E66O0006000600074O0005000500064O000600033O00122O0008001F015O0006000600084O00085O00122O00090020015O0008000800094O00060008000200122O00070021015O0006000600074O0004000600024O000500196O000600033O00122O0008001E015O0006000600084O0006000200024O000700186O000800033O00202O00080008000D4O000A5O00202O000A000A00BB4O0008000A6O00073O000200122O000800E66O0007000700084O0006000600074O000700033O00122O0009001F015O0007000700094O00095O00122O000A0020015O00090009000A4O00070009000200122O00080021015O0007000700084O0005000700024O0004000400054O000500033O00122O0007001F015O0005000500074O00075O00122O00080022015O0007000700084O00050007000200122O00060023015O0005000500064O00030004000500122O00040024012O00062O000400170001000300042D012O002105012O006600046O008F000500013O00122O00060025012O00122O00070026015O0005000700024O00040004000500202O0004000400174O00040002000200062O0004001D0501000100042D012O001D05012O0066000400033O0012D900060027015O00040004000600122O00060028012O00122O000700356O00040007000200062O000400210501000100042D012O0021050100120501040029012O0012050105002A012O0006720004008D0501000500042D012O008D0501001205010400014O00B4000500063O0012050107002B012O0012050108002C012O00069E0008002A0501000700042D012O002A0501001205010700013O00069B0004002E0501000700042D012O002E05010012050107002D012O0012050108002E012O00069E000700310501000800042D012O00310501001205010500014O00B4000600063O001205010400023O0012050107002F012O00120501080030012O000672000800230501000700042D012O00230501001205010700023O000647000400230501000700042D012O00230501001205010700013O00069B0005003F0501000700042D012O003F050100120501070031012O00120501080032012O000672000800380501000700042D012O00380501001205010600013O00120501070033012O00120501080034012O000672000700470501000800042D012O00470501001205010700013O00069B0006004B0501000700042D012O004B050100120501070035012O00120501080036012O00069E000700400501000800042D012O004005012O006600076O0078000800013O00122O00090037012O00122O000A0038015O0008000A00024O00070007000800202O00070007002B4O00070002000200062O0007006905013O00042D012O006905012O0066000700073O0006510007006905013O00042D012O0069050100120501070039012O0012050108003A012O000672000700690501000800042D012O006905012O0066000700044O002601085O00202O0008000800304O000900056O000900096O00070009000200062O0007006905013O00042D012O006905012O0066000700013O0012050108003B012O0012050109003C013O00D1000700094O003600076O006600076O0078000800013O00122O0009003D012O00122O000A003E015O0008000A00024O00070007000800202O00070007002B4O00070002000200062O0007008D05013O00042D012O008D05012O0066000700093O0006510007008D05013O00042D012O008D05010012050107003F012O0012050108003F012O0006470007008D0501000800042D012O008D05012O0066000700044O002601085O00202O0008000800464O000900056O000900096O00070009000200062O0007008D05013O00042D012O008D05012O0066000700013O0012C000080040012O00122O00090041015O000700096O00075O00044O008D050100042D012O0040050100042D012O008D050100042D012O0038050100042D012O008D050100042D012O0023050100120501040042012O00120501050043012O00069E000400B70501000500042D012O00B705012O006600046O0078000500013O00122O00060044012O00122O00070045015O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400A605013O00042D012O00A605012O0066000400073O000651000400A605013O00042D012O00A605012O0066000400033O0012D900060027015O00040004000600122O00060046012O00122O000700696O00040007000200062O000400AA0501000100042D012O00AA050100120501040047012O00120501050048012O000647000400B70501000500042D012O00B705012O0066000400044O002601055O00202O0005000500304O000600056O000600066O00040006000200062O000400B705013O00042D012O00B705012O0066000400013O00120501050049012O0012050106004A013O00D1000400064O003600045O0012050104004B012O0012050105004C012O000672000500F50501000400042D012O00F505010012050104004D012O0012050105004E012O00069E000400F50501000500042D012O00F505012O00660004001A3O000651000400F505013O00042D012O00F505012O00660004001B3O000651000400C805013O00042D012O00C805012O0066000400123O0006BB000400CB0501000100042D012O00CB05012O00660004001B3O0006BB000400F50501000100042D012O00F505012O0066000400134O0066000500143O00069E000400F50501000500042D012O00F505012O006600046O0078000500013O00122O0006004F012O00122O00070050015O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400F505013O00042D012O00F505012O0066000400033O0020ED00040004000D4O00065O00202O00060006000E4O00040006000200062O000400F505013O00042D012O00F505012O0066000400044O004B00055O00122O00060051015O0005000500064O0006000C3O00202O00060006004E4O0008000D6O0006000800024O000600066O00040006000200062O000400F00501000100042D012O00F0050100120501040052012O00120501050053012O000672000500F50501000400042D012O00F505012O0066000400013O00120501050054012O00120501060055013O00D1000400064O003600045O001205010200693O001205010400353O00069B000200FD0501000400042D012O00FD050100120501040056012O00120501050057012O000672000400100001000500042D012O00100001001205010400013O001205010500013O00069B000500050601000400042D012O0005060100120501050058012O00120501060059012O000672000500850601000600042D012O008506010012050105005A012O0012050106005B012O00069E0005003B0601000600042D012O003B06012O006600056O0078000600013O00122O0007005C012O00122O0008005D015O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002606013O00042D012O002606012O0066000500063O0006510005002606013O00042D012O002606012O00660005000C3O0020FE0005000500E22O000F000500020002001205010600E33O00069E000500260601000600042D012O002606012O006600056O008F000600013O00122O0007005E012O00122O0008005F015O0006000800024O00050005000600202O0005000500174O00050002000200062O0005002A0601000100042D012O002A060100120501050060012O00120501060061012O00069E0006003B0601000500042D012O003B060100120501050062012O00120501060063012O0006720006003B0601000500042D012O003B06012O0066000500044O002601065O00202O00060006001E4O000700056O000700076O00050007000200062O0005003B06013O00042D012O003B06012O0066000500013O00120501060064012O00120501070065013O00D1000500074O003600055O00120501050066012O00120501060067012O00069E0006006B0601000500042D012O006B06012O006600056O0078000600013O00122O00070068012O00122O00080069015O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005006B06013O00042D012O006B06012O0066000500093O0006510005006B06013O00042D012O006B06012O0066000500033O0020ED00050005000D4O00075O00202O00070007000E4O00050007000200062O0005006406013O00042D012O006406012O006600056O0078000600013O00122O0007006A012O00122O0008006B015O0006000800024O00050005000600202O0005000500174O00050002000200062O0005006B06013O00042D012O006B06012O0066000500033O0020ED00050005003B4O00075O00202O0007000700BB4O00050007000200062O0005006B06013O00042D012O006B06012O0066000500033O0020DD00050005003B4O00075O00202O00070007003C4O00050007000200062O0005006F0601000100042D012O006F06010012050105006C012O0012050106006D012O000647000500840601000600042D012O008406012O0066000500044O000D01065O00202O0006000600464O000700056O000700076O00050007000200062O0005007F0601000100042D012O007F06010012050105006E012O001205010600C53O00069B0005007F0601000600042D012O007F06010012050105006F012O00120501060070012O00069E000600840601000500042D012O008406012O0066000500013O00120501060071012O00120501070072013O00D1000500074O003600055O001205010400023O00120501050073012O00120501060074012O00069E000600920601000500042D012O00920601001205010500693O00069B000400900601000500042D012O0090060100120501050075012O00120501060076012O00069E000600920601000500042D012O00920601001205010200533O00042D012O0010000100120501050077012O00120501060078012O00069E000600FE0501000500042D012O00FE050100120501050079012O0012050106007A012O000672000600FE0501000500042D012O00FE0501001205010500023O000647000400FE0501000500042D012O00FE05010012050105007B012O0012050106007C012O00069E000500D40601000600042D012O00D406010012050105007D012O0012050106007E012O00069E000500D40601000600042D012O00D406012O006600056O0078000600013O00122O0007007F012O00122O00080080015O0006000800024O00050005000600202O00050005002B4O00050002000200062O000500D406013O00042D012O00D406012O00660005000E3O000651000500D406013O00042D012O00D406012O006600056O008C000600013O00122O00070081012O00122O00080082015O0006000800024O00050005000600202O0005000500654O00050002000200122O000600023O00062O000600D40601000500042D012O00D406012O006600056O0078000600013O00122O00070083012O00122O00080084015O0006000800024O00050005000600202O0005000500174O00050002000200062O000500D406013O00042D012O00D406012O0066000500044O002601065O00202O0006000600664O000700056O000700076O00050007000200062O000500D406013O00042D012O00D406012O0066000500013O00120501060085012O00120501070086013O00D1000500074O003600055O00120501050087012O00120501060088012O000672000500010701000600042D012O000107012O006600056O0078000600013O00122O00070089012O00122O0008008A015O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005000107013O00042D012O000107012O0066000500083O0006510005000107013O00042D012O000107012O006600056O008C000600013O00122O0007008B012O00122O0008008C015O0006000800024O00050005000600202O0005000500654O00050002000200122O000600023O00062O000600010701000500042D012O000107012O006600056O0078000600013O00122O0007008D012O00122O0008008E015O0006000800024O00050005000600202O0005000500174O00050002000200062O0005000107013O00042D012O000107012O0066000500033O0020DD00050005003B4O00075O00202O00070007003C4O00050007000200062O000500050701000100042D012O000507010012050105008F012O00120501060090012O000672000600160701000500042D012O0016070100120501050091012O00120501060092012O00069E000600160701000500042D012O001607012O0066000500044O002601065O00202O00060006003D4O000700056O000700076O00050007000200062O0005001607013O00042D012O001607012O0066000500013O00120501060093012O00120501070094013O00D1000500074O003600055O001205010400693O00042D012O00FE050100042D012O0010000100042D012O0023070100042D012O0007000100042D012O00230701001205010400013O0006473O00020001000400042D012O000200010012052O0100014O00B4000200023O001205012O00023O00042D012O000200012O00B63O00017O0068012O00028O00026O001040025O00188F40025O0066A040025O008AA440025O00CAA740025O00EEAA40025O00B2A640030A3O00B0D0A684B783A0DDAE9A03063O00E4E2B1C1EDD9030A3O0049734361737461626C65030A3O0006B124EF3AB701EA3BA703043O008654D04303073O0043686172676573026O00F03F030C3O0024BE87481BAD885835B9944503043O003C73CCE6030B3O004973417661696C61626C65025O00088E40025O004CAF40030A3O00526167696E67426C6F77031B3O00F53BEC79E93DD472EB35FC30EA2FE764EE05FF71F53DEE64A769BB03043O0010875A8B025O000CA540025O00F6B240030C3O0077661320465D7653560A3C5903073O0018341466532E34030C3O00E73D343707CD21260603CB3803053O006FA44F4144030C3O00F1CB82CA26EBC8DDA5CB3CF303063O008AA6B9E3BE4E030C3O004372757368696E67426C6F77025O0002A640025O00088040031D3O00C866D0245A2A17CC4BC73B5D3459C661C9235B1C0DCA66C23246634A9903073O0079AB14A557324303093O00E434B639BD00C72CB103063O0062A658D956D903063O0042752O665570030A3O00456E7261676542752O66030C3O00C1E478158EDDF8F25F1494C503063O00BC2O961961E603093O00426C2O6F6462617468025O004EB040025O002AAD40025O00E08640025O00ECA34003193O00D885500D08EFDB9D574201F8D69D563D18ECC88E5A164CBE8E03063O008DBAE93F626C030C3O00D2F839A52DF8E42B9429FEFD03053O0045918A4CD6030F3O0042CA8A82B31363DCA88BBE1874C08703063O007610AF2OE9DF025O0084A440025O00408440031D3O00889620A8E682738CBB37B7E19C3D869139AFE7B4698A9632BEFACB2EDD03073O001DEBE455DB8EEB027O0040025O0022A840025O00806440025O00EC9840025O003CA040026O001440025O00BC9640025O00E4AE40025O00C06240025O008C9940025O00688440025O0034AD4003073O008556C80D20B9B203063O00DED737A57D4103073O004973526561647903073O0052616D7061676503173O003ED0CB0AF3C6E80A21C4CA0EFBFEF94B3ED6C30EB295BF03083O002A4CB1A67A92A18D025O00F2A840025O009CAD4003043O00968604C303063O0016C5EA65AE19030B3O000C3AABD57EA6DB87393BB703083O00E64D54C5BC16CFB703043O00536C616D025O00F07C40025O0046AB4003143O00EA18C7F1CCACE539ED1DF9E88DB3F730ED5492A803083O00559974A69CECC190025O00EAA340025O0018A040026O001840025O002EAF40025O00CCA840030B3O001FD8B5D2735A2F5B2FC7AE03083O00325DB4DABD172E47030C3O00E9B65A584CDD46DA824E5E5D03073O0028BEC43B2C24BC025O00A8A940025O00249C40025O007BB040025O00CDB040030B3O00426C2O6F64746869727374031B3O003E49D3BBFE69053557CFA0BA70183051D58BEE7C1F3B40C8F4A92503073O006D5C25BCD49A1D030A3O0036EEA3CA3F5D26E3ABD403063O003A648FC4A351030A3O00284324AA314EC702155503083O006E7A2243C35F2985025O0060AD40025O00206E40031B3O0067B05C43D8728E5946D962F1565FDA61B8645ED767B62O5E9621E103053O00B615D13B2A026O000840025O00D89840025O00B08F4003073O006A4D710B5A417103043O00682F3514025O00F6AE40025O0086B240025O00149040025O0070A14003073O0045786563757465025O00CC9C40025O0050B04003173O00A654841FA91BA60C8C09B01BAA73951DAE08A658C14EEE03063O006FC32CE17CDC03093O00FA4A0F7CAFA9D9520803063O00CBB8266013CB030F3O000B767A4AC23C606A60CC382O7D4EC003053O00AE59131921030C3O001800535AFF86052B34475CEE03073O006B4F72322E97E7025O00D0AF40025O0057B24003193O003BAABA268E3BB6D431E6B83C862DBEFF2D2OA72E8F2DF7926D03083O00A059C6D549EA59D7030B3O006A7DBBF1C15C79BDECD65C03053O00A52811D49E030B3O00C4D7063A2EECD5092729F703053O004685B9685303083O0042752O66446F776E03103O005265636B6C652O736E652O7342752O66025O0058A140025O0092A640025O00688540025O0075B240031B3O0006494B25CD102O4D38DA1005493FC5104C7B3EC81642413E89561303053O00A96425244A03093O002F89B15C0192A5581403043O003060E7C2030B3O00E954002411D1A382DC551C03083O00E3A83A6E4D79B8CF03093O004F39B144B4C978BF7E03083O00C51B5CDF20D1BB11025O0032B340025O002FB140025O00B4A84003093O004F6E736C617567687403193O000C51D0F7024AC4F3171FCEEE0F4BCAC4175ED1FC064B83A95B03043O009B633FA3025O0063B040025O005EA940025O0098AC40025O0062AD40025O006EA040025O00C6A640025O0080684003093O0086EC42BCE002A5F44503063O0060C4802DD384025O001EB240025O007CAE40025O0074B040025O0080584003193O0037817450D6ADB5CC3DCD764ADEBBBDE7218C6958D7BBF48C6303083O00B855ED1B3FB2CFD4030A3O003A580E56065E2B53074E03043O003F683969031B3O001986A34D05809B460788B3040692A85002B8B0451980A1504BD3FC03043O00246BE7C4025O00708440025O0002A740030C3O007EA7B79455BCAC807FB9AD9003043O00E73DD5C2025O00309140025O00309440025O00188140025O006EAB40025O0084A240025O00CCB140031D3O000ABF286001A4337436AF317C1EED306605B9344C1DAC2F740CB97D265903043O001369CD5D025O006CA340025O009CAA4003093O009E00D79333BE01D08503053O005FC968BEE103093O00576869726C77696E64030E3O004973496E4D656C2O6552616E6765025O00A07340025O00A8A04003193O00B8C3C8DCA3DCC8C0AB8BCCDBA3DFC8F1BBCAD3C9AADF819BFD03043O00AECFABA1025O00208D40025O00108040025O000EA240025O0044A440030C3O000704B9F239F9D92334A0EE2603073O00B74476CC815190030C3O0039BF71F0038300A956F1199B03063O00E26ECD10846B025O00F6A640025O000EB140031D3O00E8D1F5CA49E2CDE7E643E7CCF7994CFECFF4D07EFFC2F2DE44FF83B18D03053O00218BA380B903073O00724001DD424C0103043O00BE373864025O0002AF40025O0092AC40025O008C9540025O00D8964003173O0053B7391D06F7F616A2291207EACC42AE2E1916F7B307F903073O009336CF5C7E7383025O00C1B140025O0098B04003093O0022352C731E5818232C03063O001E6D51551D6D025O00FEB140025O002OAE4003093O004F64796E7346757279025O00A89840025O00A08F40031A3O00F0754DB825E1FAEA634DF63BCBF0EB786BA237CCFBFA6514E76E03073O009C9F1134D656BE025O006C9A4003073O009CEEB0ACAFE8B803043O00DCCE8FDD030B3O0042752O6652656D61696E732O033O0047434403043O0052616765025O00805B4003103O00A96B2805CFC4D78A702419DFFED3817803073O00B2E61D4D77B8AC026O00544003103O00DAA80F09602OF0B2071279FFC7BF0D1E03063O009895DE6A7B17025O00BEA240025O0074AA40025O00D88740025O002FB04003173O00CF27FB53B4DA23B64EA0D132FF7CA1DC34F146A19D74A603053O00D5BD469623025O001C9340025O0028AB40025O005DB240025O001AA740025O00AAA340025O00788540025O0015B040030D3O00437269744368616E6365506374026O00344003093O0042752O66537461636B03143O004D657263696C652O73412O7361756C7442752O66026O002440030E3O00426C2O6F646372617A6542752O66026O002E40025O00407240025O00C0574003073O0048617354696572026O003E40025O00889C40025O00AEB040025O009C9840025O0016B140025O0022AD4003093O00FDEBA1D7F7DDE6BAD003053O0093BF87CEB8025O004AB340025O00B49440025O00789F40025O00405F40025O00E4A640025O002EB04003193O008624A9CEDC51B39020E6CCCD5FA68D17B2C0CA54B79068F79503073O00D2E448C6A1B833025O004DB040025O00349D40025O00388240025O00A06040030B3O001445FC1F77DA3E40E1036703063O00AE5629937013026O007B40025O00D07740025O00F8AD40031B3O00590C8204211B19A24913994B281A1DBF523F990A370814BF1B51DB03083O00CB3B60ED6B456F71025O00E0A940025O0012A940025O00489240026O002O40025O00C09640025O0080B040030E3O000DA05916C4E71C36BD5F2ACFE31C03073O006E59C82C78A082030E3O005468756E6465726F7573526F6172025O0050AA40025O00808740031F3O00BFCB5E48474F2942BED074544C4B290DA6D647524A752F4CB9C44E52031B6B03083O002DCBA32B26232A5B03093O00FD81C52D948F41C09C03073O0034B2E5BC43E7C9025O00889A40025O00A0A240025O0034AE40025O002EA540025O00C8AD40031A3O002E45490AE4632534534944FA492F35486F10F64E2O24551055A503073O004341213064973C025O00508740025O0046A240030C3O00E8EE74E387C2C9F879ED98D403063O00A7BA8B1788EB026O002840025O0074A740025O00F08B40030C3O005265636B6C652O736E652O73025O00989640025O00D2AD40031B3O0008B08B0616B09B1E14B09B1E5AB89D010EBCB7191BA78F080EF5DA03043O006D7AD5E803093O00C1F3BB3EFDD1B722F703043O00508E97C2030B3O0037CF634D0DCF747E02C17203043O002C63A617030F3O004D656174436C656176657242752O66030A3O0041766174617242752O66025O00809540025O00209040025O008AA240025O004CB140025O00C07F40025O001CB240025O00F6A24003193O0073F33038209B7AE23B2F73A969FB3D3F0CB07DE52E3327E42803063O00C41C97495653025O0082AA4003093O00C40B20028E4F1178F703083O001693634970E2387803103O009178F2E782AE70E6C285B179F5FC83BC03053O00EDD8158295025O00B09440025O005AAE40025O00D8B04003183O009546564DBCDE578C4A1F52A5C54A8B714B5EA2CE5B960E0903073O003EE22E2O3FD0A903073O00C00150800A192A03083O003E857935E37F6D4F03133O00417368656E4A752O6765726E61757442752O66025O00107A40025O0059B040025O002OA040025O00689B4003163O00150C37F6C3BAA7501927F9C2A79D041520F2D3BAE24803073O00C270745295B6CE002B062O001205012O00014O00B4000100013O0026433O00080001000200042D012O00080001002E0E000400080001000300042D012O00080001002E3B000600D80001000500042D012O00D80001001205010200013O002E09010800700001000700042D012O00700001000ED4000100700001000200042D012O007000012O006600036O0078000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003D00013O00042D012O003D00012O0066000300023O0006510003003D00013O00042D012O003D00012O006600036O0084000400013O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O00030003000E4O000300020002000E2O000F003D0001000300042D012O003D00012O006600036O0078000400013O00122O000500103O00122O000600116O0004000600024O00030003000400202O0003000300124O00030002000200062O0003003D00013O00042D012O003D0001002E3B0013003D0001001400042D012O003D00012O0066000300034O002601045O00202O0004000400154O000500046O000500056O00030005000200062O0003003D00013O00042D012O003D00012O0066000300013O001205010400163O001205010500174O00D1000300054O003600035O002E3B0018006F0001001900042D012O006F00012O006600036O0078000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003006F00013O00042D012O006F00012O0066000300053O0006510003006F00013O00042D012O006F00012O006600036O0084000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003000E4O000300020002000E2O000F006F0001000300042D012O006F00012O006600036O0078000400013O00122O0005001E3O00122O0006001F6O0004000600024O00030003000400202O0003000300124O00030002000200062O0003006F00013O00042D012O006F00012O0066000300034O000D01045O00202O0004000400204O000500046O000500056O00030005000200062O0003006A0001000100042D012O006A0001002E3B0021006F0001002200042D012O006F00012O0066000300013O001205010400233O001205010500244O00D1000300054O003600035O0012050102000F3O000ED4000F00CF0001000200042D012O00CF00012O006600036O0078000400013O00122O000500253O00122O000600266O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300A100013O00042D012O00A100012O0066000300063O000651000300A100013O00042D012O00A100012O0066000300073O0020ED0003000300274O00055O00202O0005000500284O00030005000200062O0003009000013O00042D012O009000012O006600036O008F000400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O0003000300124O00030002000200062O000300A10001000100042D012O00A100012O0066000300034O000D01045O00202O00040004002B4O000500046O000500056O00030005000200062O0003009C0001000100042D012O009C0001002E0E002C009C0001002D00042D012O009C0001002E09012F00A10001002E00042D012O00A100012O0066000300013O001205010400303O001205010500314O00D1000300054O003600036O006600036O0078000400013O00122O000500323O00122O000600336O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300CE00013O00042D012O00CE00012O0066000300053O000651000300CE00013O00042D012O00CE00012O0066000300073O0020ED0003000300274O00055O00202O0005000500284O00030005000200062O000300CE00013O00042D012O00CE00012O006600036O0078000400013O00122O000500343O00122O000600356O0004000600024O00030003000400202O0003000300124O00030002000200062O000300CE00013O00042D012O00CE00012O0066000300034O000D01045O00202O0004000400204O000500046O000500056O00030005000200062O000300C90001000100042D012O00C90001002E09013600CE0001003700042D012O00CE00012O0066000300013O001205010400383O001205010500394O00D1000300054O003600035O0012050102003A3O002E3B003C00090001003B00042D012O00090001002E09013D00090001003E00042D012O000900010026E4000200090001003A00042D012O00090001001205012O003F3O00042D012O00D8000100042D012O00090001002E09014000822O01004100042D012O00822O010026E43O00822O01003F00042D012O00822O01001205010200013O002E9A0042004B0001004200042D012O00282O01002E3B004400282O01004300042D012O00282O010026E4000200282O01000F00042D012O00282O01002E9A0045001C0001004500042D012O00FF00012O006600036O0078000400013O00122O000500463O00122O000600476O0004000600024O00030003000400202O0003000300484O00030002000200062O000300FF00013O00042D012O00FF00012O0066000300083O000651000300FF00013O00042D012O00FF00012O0066000300034O002601045O00202O0004000400494O000500046O000500056O00030005000200062O000300FF00013O00042D012O00FF00012O0066000300013O0012050104004A3O0012050105004B4O00D1000300054O003600035O002E09014C00272O01004D00042D012O00272O012O006600036O0078000400013O00122O0005004E3O00122O0006004F6O0004000600024O00030003000400202O0003000300484O00030002000200062O000300272O013O00042D012O00272O012O0066000300093O000651000300272O013O00042D012O00272O012O006600036O0078000400013O00122O000500503O00122O000600516O0004000600024O00030003000400202O0003000300124O00030002000200062O000300272O013O00042D012O00272O012O0066000300034O000D01045O00202O0004000400524O000500046O000500056O00030005000200062O000300222O01000100042D012O00222O01002E9A005300070001005400042D012O00272O012O0066000300013O001205010400553O001205010500564O00D1000300054O003600035O0012050102003A3O002E090158002E2O01005700042D012O002E2O010026E40002002E2O01003A00042D012O002E2O01001205012O00593O00042D012O00822O01002E09015B00DD0001005A00042D012O00DD00010026E4000200DD0001000100042D012O00DD00012O006600036O0078000400013O00122O0005005C3O00122O0006005D6O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300492O013O00042D012O00492O012O00660003000A3O000651000300492O013O00042D012O00492O012O006600036O0078000400013O00122O0005005E3O00122O0006005F6O0004000600024O00030003000400202O0003000300124O00030002000200062O0003004B2O013O00042D012O004B2O01002E090160005A2O01006100042D012O005A2O01002E090162005A2O01006300042D012O005A2O012O0066000300034O002601045O00202O0004000400644O000500046O000500056O00030005000200062O0003005A2O013O00042D012O005A2O012O0066000300013O001205010400653O001205010500664O00D1000300054O003600036O006600036O0078000400013O00122O000500673O00122O000600686O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300802O013O00042D012O00802O012O0066000300023O000651000300802O013O00042D012O00802O012O006600036O0084000400013O00122O000500693O00122O0006006A6O0004000600024O00030003000400202O00030003000E4O000300020002000E2O000F00802O01000300042D012O00802O012O0066000300034O000D01045O00202O0004000400154O000500046O000500056O00030005000200062O0003007B2O01000100042D012O007B2O01002E3B006B00802O01006C00042D012O00802O012O0066000300013O0012050104006D3O0012050105006E4O00D1000300054O003600035O0012050102000F3O00042D012O00DD0001000EAA006F00862O013O00042D012O00862O01002E090170005A0201007100042D012O005A0201001205010200013O0026E4000200E12O01000100042D012O00E12O012O006600036O0078000400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O0003000300484O00030002000200062O000300962O013O00042D012O00962O012O00660003000B3O0006BB0003009A2O01000100042D012O009A2O01002E350075009A2O01007400042D012O009A2O01002E09017700A92O01007600042D012O00A92O012O0066000300034O000D01045O00202O0004000400784O000500046O000500056O00030005000200062O000300A42O01000100042D012O00A42O01002E09017A00A92O01007900042D012O00A92O012O0066000300013O0012050104007B3O0012050105007C4O00D1000300054O003600036O006600036O0078000400013O00122O0005007D3O00122O0006007E6O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300E02O013O00042D012O00E02O012O0066000300063O000651000300E02O013O00042D012O00E02O012O0066000300073O0020ED0003000300274O00055O00202O0005000500284O00030005000200062O000300E02O013O00042D012O00E02O012O006600036O0078000400013O00122O0005007F3O00122O000600806O0004000600024O00030003000400202O0003000300124O00030002000200062O000300E02O013O00042D012O00E02O012O006600036O008F000400013O00122O000500813O00122O000600826O0004000600024O00030003000400202O0003000300124O00030002000200062O000300E02O01000100042D012O00E02O012O0066000300034O000D01045O00202O00040004002B4O000500046O000500056O00030005000200062O000300DB2O01000100042D012O00DB2O01002E3B008400E02O01008300042D012O00E02O012O0066000300013O001205010400853O001205010500864O00D1000300054O003600035O0012050102000F3O000ED4000F00530201000200042D012O005302012O006600036O0078000400013O00122O000500873O00122O000600886O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003000802013O00042D012O000802012O00660003000A3O0006510003000802013O00042D012O000802012O0066000300073O0020ED0003000300274O00055O00202O0005000500284O00030005000200062O0003000C02013O00042D012O000C02012O006600036O0078000400013O00122O000500893O00122O0006008A6O0004000600024O00030003000400202O0003000300124O00030002000200062O0003000802013O00042D012O000802012O0066000300073O0020DD00030003008B4O00055O00202O00050005008C4O00030005000200062O0003000C0201000100042D012O000C0201002E35008E000C0201008D00042D012O000C0201002E3B009000190201008F00042D012O001902012O0066000300034O002601045O00202O0004000400644O000500046O000500056O00030005000200062O0003001902013O00042D012O001902012O0066000300013O001205010400913O001205010500924O00D1000300054O003600036O006600036O0078000400013O00122O000500933O00122O000600946O0004000600024O00030003000400202O0003000300484O00030002000200062O0003004102013O00042D012O004102012O00660003000C3O0006510003004102013O00042D012O004102012O006600036O008F000400013O00122O000500953O00122O000600966O0004000600024O00030003000400202O0003000300124O00030002000200062O000300370201000100042D012O003702012O0066000300073O0020DD0003000300274O00055O00202O0005000500284O00030005000200062O000300430201000100042D012O004302012O006600036O008F000400013O00122O000500973O00122O000600986O0004000600024O00030003000400202O0003000300124O00030002000200062O000300430201000100042D012O00430201002E3B009900520201009A00042D012O00520201002E9A009B000F0001009B00042D012O005202012O0066000300034O002601045O00202O00040004009C4O000500046O000500056O00030005000200062O0003005202013O00042D012O005202012O0066000300013O0012050104009D3O0012050105009E4O00D1000300054O003600035O0012050102003A3O002643000200570201003A00042D012O00570201002E9A009F0032FF2O00A000042D012O00872O01001205012O00023O00042D012O005A020100042D012O00872O01002E9A00A10004000100A100042D012O005E02010026433O00600201005900042D012O00600201002E3B00A200DE020100A300042D012O00DE0201002E0901A50080020100A400042D012O008002012O006600026O0078000300013O00122O000400A63O00122O000500A76O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002008002013O00042D012O008002012O0066000200063O0006510002008002013O00042D012O008002012O0066000200034O000D01035O00202O00030003002B4O000400046O000400046O00020004000200062O0002007B0201000100042D012O007B0201002E3500A8007B020100A900042D012O007B0201002E0901AA0080020100AB00042D012O008002012O0066000200013O001205010300AC3O001205010400AD4O00D1000200044O003600026O006600026O0078000300013O00122O000400AE3O00122O000500AF6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002009A02013O00042D012O009A02012O0066000200023O0006510002009A02013O00042D012O009A02012O0066000200034O002601035O00202O0003000300154O000400046O000400046O00020004000200062O0002009A02013O00042D012O009A02012O0066000200013O001205010300B03O001205010400B14O00D1000200044O003600025O002E3B00B200BC020100B300042D012O00BC02012O006600026O0078000300013O00122O000400B43O00122O000500B56O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200A902013O00042D012O00A902012O0066000200053O0006BB000200AB0201000100042D012O00AB0201002E0901B700BC020100B600042D012O00BC02012O0066000200034O000D01035O00202O0003000300204O000400046O000400046O00020004000200062O000200B70201000100042D012O00B70201002E3500B900B7020100B800042D012O00B70201002E9A00BA0007000100BB00042D012O00BC02012O0066000200013O001205010300BC3O001205010400BD4O00D1000200044O003600025O002E0901BE002A060100BF00042D012O002A06012O006600026O0078000300013O00122O000400C03O00122O000500C16O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002002A06013O00042D012O002A06012O00660002000D3O0006510002002A06013O00042D012O002A06012O0066000200034O004800035O00202O0003000300C24O0004000E3O00202O0004000400C34O0006000F6O0004000600024O000400046O00020004000200062O000200D80201000100042D012O00D80201002E3B00C5002A060100C400042D012O002A06012O0066000200013O0012C0000300C63O00122O000400C76O000200046O00025O00044O002A0601002E9A00C80004000100C800042D012O00E202010026433O00E40201003A00042D012O00E40201002E0901CA00BF030100C900042D012O00BF0301002E3B00400013030100CB00042D012O001303012O006600026O0078000300013O00122O000400CC3O00122O000500CD6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002001303013O00042D012O001303012O006600026O0078000300013O00122O000400CE3O00122O000500CF6O0003000500024O00020002000300202O0002000200124O00020002000200062O0002001303013O00042D012O001303012O0066000200053O0006510002001303013O00042D012O001303012O0066000200073O0020ED0002000200274O00045O00202O0004000400284O00020004000200062O0002001303013O00042D012O001303012O0066000200034O000D01035O00202O0003000300204O000400046O000400046O00020004000200062O0002000E0301000100042D012O000E0301002E9A00D00007000100D100042D012O001303012O0066000200013O001205010300D23O001205010400D34O00D1000200044O003600026O006600026O0078000300013O00122O000400D43O00122O000500D56O0003000500024O00020002000300202O0002000200484O00020002000200062O0002002703013O00042D012O002703012O00660002000B3O0006510002002703013O00042D012O002703012O0066000200073O0020DD0002000200274O00045O00202O0004000400284O00020004000200062O000200290301000100042D012O00290301002E0901D60038030100D700042D012O003803012O0066000200034O000D01035O00202O0003000300784O000400046O000400046O00020004000200062O000200330301000100042D012O00330301002E9A00D80007000100D900042D012O003803012O0066000200013O001205010300DA3O001205010400DB4O00D1000200044O003600025O002E3B00DD006F030100DC00042D012O006F03012O006600026O0078000300013O00122O000400DE3O00122O000500DF6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002005B03013O00042D012O005B03012O0066000200103O0006510002004A03013O00042D012O004A03012O0066000200113O0006BB0002004D0301000100042D012O004D03012O0066000200103O0006BB0002005B0301000100042D012O005B03012O0066000200123O0006510002005B03013O00042D012O005B03012O0066000200134O0066000300143O00069E0002005B0301000300042D012O005B03012O0066000200073O0020DD0002000200274O00045O00202O0004000400284O00020004000200062O0002005D0301000100042D012O005D0301002E0901E0006F030100E100042D012O006F03012O0066000200034O004800035O00202O0003000300E24O0004000E3O00202O0004000400C34O0006000F6O0004000600024O000400046O00020004000200062O0002006A0301000100042D012O006A0301002E0901E3006F030100E400042D012O006F03012O0066000200013O001205010300E53O001205010400E64O00D1000200044O003600025O002E9A00E7004F000100E700042D012O00BE03012O006600026O0078000300013O00122O000400E83O00122O000500E96O0003000500024O00020002000300202O0002000200484O00020002000200062O000200AD03013O00042D012O00AD03012O0066000200083O000651000200AD03013O00042D012O00AD03012O0066000200073O0020DD0002000200274O00045O00202O00040004008C4O00020004000200062O000200AF0301000100042D012O00AF03012O0066000200073O0020940002000200EA4O00045O00202O0004000400284O0002000400024O000300073O00202O0003000300EB4O00030002000200062O000200AF0301000300042D012O00AF03012O0066000200073O0020FE0002000200EC2O000F000200020002000E2B01ED009E0301000200042D012O009E03012O006600026O008F000300013O00122O000400EE3O00122O000500EF6O0003000500024O00020002000300202O0002000200124O00020002000200062O000200AF0301000100042D012O00AF03012O0066000200073O0020FE0002000200EC2O000F000200020002000E2B01F000AD0301000200042D012O00AD03012O006600026O0078000300013O00122O000400F13O00122O000500F26O0003000500024O00020002000300202O0002000200124O00020002000200062O000200AF03013O00042D012O00AF0301002E3B00F400BE030100F300042D012O00BE03012O0066000200034O000D01035O00202O0003000300494O000400046O000400046O00020004000200062O000200B90301000100042D012O00B90301002E3B00F600BE030100F500042D012O00BE03012O0066000200013O001205010300F73O001205010400F84O00D1000200044O003600025O001205012O006F3O002E9A00F900572O0100F900042D012O00160501000EAA000F00C503013O00042D012O00C50301002E3B00FB0016050100FA00042D012O00160501001205010200013O002643000200CA0301003A00042D012O00CA0301002E3B00FC00CC030100FD00042D012O00CC0301001205012O003A3O00042D012O00160501002E3B00FE008E040100FF00042D012O008E04010026E40002008E0401000F00042D012O008E04012O0066000300154O0073000400073O00202O000400042O00013O0004000200024O000500166O000600073O00202O0006000600274O00085O00202O00080008008C4O000600086O00053O000200122O0006002O015O0005000500064O0004000400054O000500073O00122O00070002015O0005000500074O00075O00122O00080003015O0007000700084O00050007000200122O00060004015O0005000500064O0004000400054O000500073O00122O00070002015O0005000500074O00075O00122O00080005015O0007000700084O00050007000200122O00060006015O0005000500064O0003000500024O000400176O000500073O00202O000500052O00013O0005000200024O000600166O000700073O00202O0007000700274O00095O00202O00090009008C4O000700096O00063O000200122O0007002O015O0006000600074O0005000500064O000600073O00122O00080002015O0006000600084O00085O00122O00090003015O0008000800094O00060008000200122O00070004015O0006000600074O0005000500064O000600073O00122O00080002015O0006000600084O00085O00122O00090005015O0008000800094O00060008000200122O00070006015O0006000600074O0004000600024O00010003000400122O00030007012O00122O00040007012O00062O0003008D0401000400042D012O008D040100120501030008012O0006720003008D0401000100042D012O008D04012O0066000300073O00126A00050009015O00030003000500122O0005000A012O00122O000600026O00030006000200062O0003008D04013O00042D012O008D0401001205010300014O00B4000400043O0012050105000B012O0012050106000B012O000647000500260401000600042D012O00260401001205010500013O000647000300260401000500042D012O00260401001205010400013O0012050105000C012O0012050106000D012O00069E0006002E0401000500042D012O002E0401001205010500013O00069B000400390401000500042D012O003904010012050105000E012O0012050106000F012O0006720005002E0401000600042D012O002E04012O006600056O0078000600013O00122O00070010012O00122O00080011015O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005004604013O00042D012O004604012O0066000500063O0006BB0005004A0401000100042D012O004A040100120501050012012O00120501060013012O0006720005005F0401000600042D012O005F040100120501050014012O00120501060015012O0006720006005F0401000500042D012O005F04012O0066000500034O000D01065O00202O00060006002B4O000700046O000700076O00050007000200062O0005005A0401000100042D012O005A040100120501050016012O00120501060017012O00069E0006005F0401000500042D012O005F04012O0066000500013O00120501060018012O00120501070019013O00D1000500074O003600055O0012050105001A012O0012050106001B012O0006720006008D0401000500042D012O008D04010012050105001C012O0012050106001D012O0006720006008D0401000500042D012O008D04012O006600056O0078000600013O00122O0007001E012O00122O0008001F015O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005008D04013O00042D012O008D04012O00660005000A3O0006510005008D04013O00042D012O008D040100120501050020012O00120501060020012O000647000500800401000600042D012O008004012O0066000500034O000D01065O00202O0006000600644O000700046O000700076O00050007000200062O000500840401000100042D012O0084040100120501050021012O00120501060022012O0006720006008D0401000500042D012O008D04012O0066000500013O0012C000060023012O00122O00070024015O000500076O00055O00044O008D040100042D012O002E040100042D012O008D040100042D012O002604010012050102003A3O001205010300013O00069B000300950401000200042D012O0095040100120501030025012O00120501040026012O000672000300C60301000400042D012O00C6030100120501030027012O00120501040028012O000672000400D30401000300042D012O00D3040100120501030029012O0012050104002A012O000672000300D30401000400042D012O00D304012O006600036O0078000400013O00122O0005002B012O00122O0006002C015O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300D304013O00042D012O00D304012O0066000300183O000651000300AD04013O00042D012O00AD04012O0066000300113O0006BB000300B00401000100042D012O00B004012O0066000300183O0006BB000300D30401000100042D012O00D304012O0066000300193O000651000300D304013O00042D012O00D304012O0066000300134O0066000400143O00069E000300D30401000400042D012O00D304012O0066000300073O0020ED0003000300274O00055O00202O0005000500284O00030005000200062O000300D304013O00042D012O00D304012O0066000300034O004B00045O00122O0005002D015O0004000400054O0005000E3O00202O0005000500C34O0007000F6O0005000700024O000500056O00030005000200062O000300CE0401000100042D012O00CE04010012050103002E012O0012050104002F012O000672000300D30401000400042D012O00D304012O0066000300013O00120501040030012O00120501050031013O00D1000300054O003600036O006600036O0078000400013O00122O00050032012O00122O00060033015O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300F804013O00042D012O00F804012O0066000300103O000651000300E304013O00042D012O00E304012O0066000300113O0006BB000300E60401000100042D012O00E604012O0066000300103O0006BB000300F80401000100042D012O00F804012O0066000300123O000651000300F804013O00042D012O00F804012O0066000300134O0066000400143O00069E000300F80401000400042D012O00F804012O00660003001A3O0012050104000F3O00069E000400F80401000300042D012O00F804012O0066000300073O0020DD0003000300274O00055O00202O0005000500284O00030005000200062O000300FC0401000100042D012O00FC040100120501030034012O00120501040035012O000672000400140501000300042D012O0014050100120501030036012O00120501040036012O000647000300140501000400042D012O0014050100120501030037012O00120501040038012O00069E000300140501000400042D012O001405012O0066000300034O00DB00045O00202O0004000400E24O0005000E3O00202O0005000500C34O0007000F6O0005000700024O000500056O00030005000200062O0003001405013O00042D012O001405012O0066000300013O00120501040039012O0012050105003A013O00D1000300054O003600035O0012050102000F3O00042D012O00C60301001205010200013O00069B3O001D0501000200042D012O001D05010012050102003B012O0012050103003C012O000672000300020001000200042D012O000200012O006600026O0078000300013O00122O0004003D012O00122O0005003E015O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002005505013O00042D012O005505012O00660002001B3O0006510002002D05013O00042D012O002D05012O0066000200113O0006BB000200300501000100042D012O003005012O00660002001B3O0006BB000200550501000100042D012O005505012O00660002001C3O0006510002005505013O00042D012O005505012O0066000200134O0066000300143O00069E000200550501000300042D012O005505012O00660002001A3O0012050103000F3O0006D30003003F0501000200042D012O003F05012O0066000200143O0012050103003F012O00069E000200550501000300042D012O0055050100120501020040012O00120501030041012O0006720003004C0501000200042D012O004C05012O0066000200034O00C900035O00122O00040042015O0003000300044O000400046O000400046O00020004000200062O000200500501000100042D012O0050050100120501020043012O00120501030044012O000647000200550501000300042D012O005505012O0066000200013O00120501030045012O00120501040046013O00D1000200044O003600026O006600026O0078000300013O00122O00040047012O00122O00050048015O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002009405013O00042D012O009405012O0066000200103O0006510002006505013O00042D012O006505012O0066000200113O0006BB000200680501000100042D012O006805012O0066000200103O0006BB000200940501000100042D012O009405012O0066000200123O0006510002009405013O00042D012O009405012O0066000200134O0066000300143O00069E000200940501000300042D012O009405012O00660002001A3O0012050103000F3O00069E000300940501000200042D012O009405012O006600026O0078000300013O00122O00040049012O00122O0005004A015O0003000500024O00020002000300202O0002000200124O00020002000200062O0002009405013O00042D012O009405012O0066000200073O00200400020002008B4O00045O00122O0005004B015O0004000400054O00020004000200062O0002009C0501000100042D012O009C05012O0066000200073O0020040002000200274O00045O00122O0005004C015O0004000400054O00020004000200062O0002009C0501000100042D012O009C05012O0066000200073O0020DD0002000200274O00045O00202O00040004008C4O00020004000200062O0002009C0501000100042D012O009C05010012050102004D012O0012050103004E012O0006CB000200050001000300042D012O009C05010012050102004F012O00120501030050012O000672000300B40501000200042D012O00B4050100120501020051012O00120501030052012O00069E000200B40501000300042D012O00B4050100120501020053012O00120501030053012O000647000200B40501000300042D012O00B405012O0066000200034O00DB00035O00202O0003000300E24O0004000E3O00202O0004000400C34O0006000F6O0004000600024O000400046O00020004000200062O000200B405013O00042D012O00B405012O0066000200013O00120501030054012O00120501040055013O00D1000200044O003600025O001205010200543O00120501030056012O00069E000300F30501000200042D012O00F305012O006600026O0078000300013O00122O00040057012O00122O00050058015O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200F305013O00042D012O00F305012O00660002000D3O000651000200F305013O00042D012O00F305012O00660002001A3O0012050103000F3O00069E000300F30501000200042D012O00F305012O006600026O0078000300013O00122O00040059012O00122O0005005A015O0003000500024O00020002000300202O0002000200124O00020002000200062O000200F305013O00042D012O00F305012O0066000200073O00209800020002008B4O00045O00122O0005004B015O0004000400054O00020004000200062O000200F305013O00042D012O00F305010012050102005B012O0012050103005B012O000647000200F30501000300042D012O00F305012O0066000200034O004800035O00202O0003000300C24O0004000E3O00202O0004000400C34O0006000F6O0004000600024O000400046O00020004000200062O000200EE0501000100042D012O00EE05010012050102005C012O0012050103005D012O00069E000300F30501000200042D012O00F305012O0066000200013O0012050103005E012O0012050104005F013O00D1000200044O003600026O006600026O0078000300013O00122O00040060012O00122O00050061015O0003000500024O00020002000300202O0002000200484O00020002000200062O0002002806013O00042D012O002806012O00660002000B3O0006510002002806013O00042D012O002806012O0066000200073O0020980002000200274O00045O00122O00050062015O0004000400054O00020004000200062O0002002806013O00042D012O002806012O0066000200073O0020030102000200EA4O00045O00122O00050062015O0004000400054O0002000400024O000300073O00202O0003000300EB4O00030002000200062O000200280601000300042D012O0028060100120501020063012O00120501030064012O00069E000200280601000300042D012O002806012O0066000200034O000D01035O00202O0003000300784O000400046O000400046O00020004000200062O000200230601000100042D012O0023060100120501020065012O00120501030066012O00069E000200280601000300042D012O002806012O0066000200013O00120501030067012O00120501040068013O00D1000200044O003600025O001205012O000F3O00042D012O000200012O00B63O00017O005A012O00025O00E8B140025O0090A940025O004C9040025O00CCAB40028O00025O00307C40025O0060A240026O00F03F03113O0048616E646C65496E636F72706F7265616C03113O00496E74696D69646174696E6753686F7574031A3O00496E74696D69646174696E6753686F75744D6F7573656F766572026O002040025O00349540025O009EA540025O00C05140025O00D09640025O0064AA40025O00D2A540025O00888140025O00788C4003093O0053746F726D426F6C7403123O0053746F726D426F6C744D6F7573656F766572026O003440025O00F8AA40025O0078AB40025O00288540025O002FB040025O0046B140025O00E8A140030D3O00546172676574497356616C6964025O0052AE40025O00889D40025O00C0A140025O0098AC40025O0074AA40025O00F8A340027O0040025O0044B340025O00308C40025O00DCA740025O00089E40025O00707F40025O00449640025O005DB040025O00BCA340025O008C9340025O00449740025O00F08440025O00AC9B40025O0007B340026O000840025O00CC9640025O00907440025O00A6A340025O00D0A140025O00BCA640025O00609140025O0080A740025O00188240025O00FCB140030B3O009D3AF5295D8336BD2DE83103073O0062D55F874634E0030A3O0049734361737461626C6503093O004973496E52616E6765026O003E40025O00F89F40025O007AB040030B3O004865726F69635468726F7703113O00F6A6DB785DFD9CDD7F46F1B4897A55F7AD03053O00349EC3A917025O00707240025O00388840030D3O004DAE37778D3C758C4EB4207B9103083O00EB1ADC5214E6551B030F3O00412O66656374696E67436F6D626174025O0070A340025O00508940030D3O00577265636B696E675468726F77025O00DCB240025O0096A74003133O009FB3ECC17F81AFEEFD6080B3E6D53485A0E0CC03053O0014E8C189A2025O00BAB240025O00D8AB40025O001AA240025O00CCA040025O0098A840025O00188740025O00507040025O00206140025O00E0B140025O003AB240030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O0015FEEC9203083O001142BFA5C687EC7703133O00576169742F502O6F6C205265736F7572636573025O0006AE40025O00ACA740025O00688440025O008C9A40025O00ACA340025O00D4A740025O00C7B240025O00206640025O00B4A340025O00C09840025O009EAC40025O00F88A40025O005AA940025O0064AF40025O0052B24003063O00CEF60CE1FFD203063O00B78D9E6D939803063O00436861726765030E3O0049735370652O6C496E52616E6765025O006AB140025O0014A740025O00807840025O00B8A040030D3O002F01E71E2B0CA6012D00E84C7E03043O006C4C6986030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003103O005265636B6C652O736E652O7342752O66025O00B3B140025O0042A840025O0040A040025O00307D40026O004D40025O00508340025O002EAE40025O0006A940025O001AA140025O00E88E40025O0095B040025O00D88B40025O008EAC40026O002E40025O00607840025O00BFB040025O004CAC40025O00E2A340025O00D49A40026O004140025O0012A44003093O002OC9BEEECACDD0A3F803053O00AE8BA5D18103093O00426C2O6F6446757279025O0078A640025O00AC9440025O001BB240025O00805D4003123O00A1BFEDCEC23C766DB1AAA2CCC70A7E38F2E103083O0018C3D382A1A66310025O00289340025O0040A940030A3O006406FB3F56044D0AE72B03063O00762663894C33030A3O004265727365726B696E6703123O00FF2317010C32F62F0B15492DFC2F0B52587403063O00409D46657269025O006EAD40025O00108640025O00B89F40025O00B8A940025O000C9740030D3O00DB42E1F964EE5EE3F054FB40EE03053O00179A2C829C025O00E09F40025O00508540030D3O00416E6365737472616C43612O6C03163O0010A8AEAB250703A7A19135121DAAEDA3371A1FE6FFFE03063O007371C6CDCE56030B3O00A656F9558263EC53875CED03043O003AE4379E03083O0042752O66446F776E030A3O00456E7261676542752O66025O00D07040025O009CA240025O00A5B240025O00FC9440025O00208A40025O0024B040030B3O004261676F66547269636B73025O005C9B40025O00E0974003153O00B688D71133AB0AA09BD92D37BE75B988D9207CFF6703073O0055D4E9B04E5CCD025O00688D40025O00ABB040025O00D89740025O00C09340025O005AA740025O009C9040030E3O006CA1A0EB045382B2E7174DADA9F703053O007020C8C783025O0048AB40025O00208E40025O00CCA240025O002AA940030E3O004C69676874734A7564676D656E7403173O0020595BB0D7B81D264558BFCEAE2C381051B9CAA5627D0603073O00424C303CD8A3CB03093O009C8F6BF65DC22BB58203073O0044DAE619933FAE025O004CA540025O00E2B140025O00DEAB40025O006BB14003093O0046697265626C2O6F64025O000FB240025O00E09B4003113O00AB234149B4A1255C48F6A02B5A42F6FC7203053O00D6CD4A332C025O00108140025O00BC9040025O00109D40025O0022A040025O00FEB240025O0072AC40025O0044A640025O00288F40025O0096A040025O001EB340025O0054B040025O0096B140025O0046AC40025O00A06240025O00E88B40025O00A8A040025O000EAA40030C3O006AC054F14F36E44BCB52E95003073O009738A5379A2353030B3O00814D0BE7A84A09EFB44C1703043O008EC02365030B3O004973417661696C61626C65030C3O00466967687452656D61696E73026O002840025O00349040025O00489B40030C3O005265636B6C652O736E652O73025O007DB140025O0022AC4003143O00C4702AA8EB89BF05D8703AB0A781AD1FD8357BF403083O0076B61549C387ECCC03073O003A3D0C410308EF03073O009D685C7A20646D03063O00B3AACED3383503083O00CBC3C6AFAA5D47ED03063O000F5D3FC1502O03073O009C4E2B5EB53171030F3O00432O6F6C646F776E52656D61696E73026O002440030D3O0052617661676572506C61796572025O002CAB40025O00688240030F3O0060E9D2A20C466B32E5C5AA05032B2A03073O00191288A4C36B23025O0034AD40025O00D8AC40025O00DCAD40025O00B88940025O00109B40025O00406040025O0062B340025O0094A84003063O006B4E89F64B4A03043O00822A38E8030D3O00DEBC30E24E2CDEBA36EE4531FE03063O005F8AD5448320030A3O0041766174617242752O6603093O00052CB84D650C3DB35A03053O00164A48C12303113O000E7CF64B296BEF5D3E6AD0573E74E1563803043O00384C1984030D3O006AC8BF27C14DF5A434C25BCFBF03053O00AF3EA1CB4603113O001ED8D100302ED6C6012608D2D11E3032C903053O00555CBDA373025O00188B40025O001EA940025O00B07D40025O0032B04003063O00417661746172030E3O0028BA312C28BE703528A53E787BF803043O005849CC50030C3O001C86134D25DF3D901E433AC903063O00BA4EE3702649030B3O00DD59F35C5B73F056E95A4103063O001A9C379D353303063O00ADCE17CDB94203063O0030ECB876B9D803063O00C4AB5624CE2603063O005485DD3750AF026O00444003063O009CF125B2C64E03063O003CDD8744C6A7025O00C88440025O00BDB140025O00405E40025O0020604003143O00FCB8FB884EDCFDAEF68651CAAEB0F98A4C99BCEB03063O00B98EDD98E322025O00049140025O00FEAA40025O0014A040025O005EB340030E3O003399ECBF1286EF9C019AFDB70F8703043O00DE60E98903063O00BAA6B50C87E103073O0090D9D3C77FE893030D3O00CC262A29DB56364BEA223B26C103083O0024984F5E48B5256203073O0048617354696572026O003F4003143O0053706561724F6642617374696F6E437572736F72025O0084AB40025O00C4A04003183O00C4C8423EC5E74839E8DA462CC3D1483197D54636D998146E03043O005FB7B827025O0046AB40025O0074A940025O007C9B4003073O00DA2CBF4E75B9D303083O00D8884DC92F12DCA103063O002EF939C907CE03073O00E24D8C4BBA68BC03063O0098D8D12B4EAB03053O002FD9AEB05F025O00BFB140025O00607640025O004C9F40030D3O0052617661676572437572736F72030F3O00AADC6003B5516A66B5DC7F0CF2062003083O0046D8BD1662D23418030E3O00E9CFA686C1D5D98186C0CED6AC8903053O00B3BABFC3E703063O00E93319FDFC2D03043O0084995F78030D3O0085BB1A2CF9C994BEA00328F9CE03073O00C0D1D26E4D97BA03143O0053706561724F6642617374696F6E506C61796572025O0080A24003183O00F31327E8EDFBEF051DEBFED7F40A2DE7BFC9E10A2CA9AC9403063O00A4806342899F009D053O00553O00018O000100029O009O0000064O00080001000100042D012O00080001002E092O01000A0001000200042D012O000A00012O00668O00FF3O00023O002E09010300570001000400042D012O005700012O00663O00023O0006513O005700013O00042D012O00570001001205012O00053O002E09010600280001000700042D012O002800010026E43O00280001000800042D012O002800012O0066000100033O0020AC0001000100094O000200043O00202O00020002000A4O000300053O00202O00030003000B00122O0004000C6O000500016O0001000500024O00015O002E2O000D00570001000E00042D012O00570001002E9A000F00370001000F00042D012O005700012O006600015O0006510001005700013O00042D012O005700012O006600016O00FF000100023O00042D012O005700010026E43O00100001000500042D012O001000010012052O0100053O002E3B0010004F0001001100042D012O004F0001002E9A001200220001001200042D012O004F00010026E40001004F0001000500042D012O004F0001001205010200053O000EAA000500360001000200042D012O00360001002E3B001400480001001300042D012O004800012O0066000300033O0020450003000300094O000400043O00202O0004000400154O000500053O00202O00050005001600122O000600176O000700016O0003000700024O00038O00035O00062O000300450001000100042D012O00450001002E3B001900470001001800042D012O004700012O006600036O00FF000300023O001205010200083O0026430002004C0001000800042D012O004C0001002E09011B00320001001A00042D012O003200010012052O0100083O00042D012O004F000100042D012O00320001002E3B001D002B0001001C00042D012O002B00010026E40001002B0001000800042D012O002B0001001205012O00083O00042D012O0010000100042D012O002B000100042D012O001000012O00663O00033O0020085O001E2O0017012O000100020006BB3O005E0001000100042D012O005E0001002E3B001F009C0501002000042D012O009C0501001205012O00054O00B4000100023O0026433O00640001000500042D012O00640001002E09012200670001002100042D012O006700010012052O0100054O00B4000200023O001205012O00083O0026433O006B0001000800042D012O006B0001002E09012300600001002400042D012O006000010026430001006F0001002500042D012O006F0001002E3B002600082O01002700042D012O00082O01001205010300054O00B4000400043O002643000300750001000500042D012O00750001002E09012800710001002900042D012O00710001001205010400053O0026430004007C0001000800042D012O007C0001002E0E002B007C0001002A00042D012O007C0001002E3B002C009D0001002D00042D012O009D00012O0066000500063O0006510005008200013O00042D012O008200012O0066000500073O000EE0002500840001000500042D012O00840001002E3B002F009B0001002E00042D012O009B0001001205010500054O00B4000600063O0026E4000500860001000500042D012O00860001001205010600053O0026430006008D0001000500042D012O008D0001002E9A003000FEFF2O003100042D012O008900012O0066000700084O00170107000100022O00E500075O002E9A0032000B0001003200042D012O009B00012O006600075O0006510007009B00013O00042D012O009B00012O006600076O00FF000700023O00042D012O009B000100042D012O0089000100042D012O009B000100042D012O008600010012052O0100333O00042D012O00082O01002E09013500760001003400042D012O00760001002E3B003700760001003600042D012O007600010026E4000400760001000500042D012O00760001001205010500053O002E3B003900FE0001003800042D012O00FE0001002E9A003A00580001003A00042D012O00FE00010026E4000500FE0001000500042D012O00FE0001002E3B003B00D10001003C00042D012O00D100012O0066000600093O000651000600D100013O00042D012O00D100012O0066000600044O00780007000A3O00122O0008003D3O00122O0009003E6O0007000900024O00060006000700202O00060006003F4O00060002000200062O000600D100013O00042D012O00D100012O00660006000B3O0020FE000600060040001205010800414O006E0006000800020006BB000600D10001000100042D012O00D10001002E09014200D10001004300042D012O00D100012O00660006000C4O0064000700043O00202O0007000700444O0008000B3O00202O00080008004000122O000A00416O0008000A00024O000800086O00060008000200062O000600D100013O00042D012O00D100012O00660006000A3O001205010700453O001205010800464O00D1000600084O003600065O002E3B004700FD0001004800042D012O00FD00012O0066000600044O00780007000A3O00122O000800493O00122O0009004A6O0007000900024O00060006000700202O00060006003F4O00060002000200062O000600FD00013O00042D012O00FD00012O00660006000D3O000651000600FD00013O00042D012O00FD00012O00660006000B3O0020FE00060006004B2O000F000600020002000651000600FD00013O00042D012O00FD00012O00660006000E4O0017010600010002000651000600FD00013O00042D012O00FD0001002E3B004D00FD0001004C00042D012O00FD00012O00660006000C4O0024000700043O00202O00070007004E4O0008000B3O00202O00080008004000122O000A00416O0008000A00024O000800086O00060008000200062O000600F80001000100042D012O00F80001002E09014F00FD0001005000042D012O00FD00012O00660006000A3O001205010700513O001205010800524O00D1000600084O003600065O001205010500083O002E09015400A40001005300042D012O00A400010026E4000500A40001000800042D012O00A40001001205010400083O00042D012O0076000100042D012O00A4000100042D012O0076000100042D012O00082O0100042D012O00710001002E09015600292O01005500042D012O00292O01000ED4003300292O01000100042D012O00292O012O00660003000F4O00170103000100022O00E500036O006600035O0006BB000300162O01000100042D012O00162O01002E13005700162O01005800042D012O00162O01002E09015900182O01005A00042D012O00182O012O006600036O00FF000300023O002E3B005B009C0501005C00042D012O009C05012O0066000300103O00209500030003005D4O000400043O00202O00040004005E4O00058O0006000A3O00122O0007005F3O00122O000800606O000600086O00033O000200062O0003009C05013O00042D012O009C0501001205010300614O00FF000300023O00042D012O009C05010026430001002F2O01000500042D012O002F2O01002E130062002F2O01006300042D012O002F2O01002E09016500722O01006400042D012O00722O01001205010300053O002E090166003D2O01006700042D012O003D2O010026E40003003D2O01000800042D012O003D2O01002E3B0069003B2O01006800042D012O003B2O01002E3B006B003B2O01006A00042D012O003B2O010006510002003B2O013O00042D012O003B2O012O00FF000200023O0012052O0100083O00042D012O00722O01002E09016D00302O01006C00042D012O00302O01002E9A006E00F1FF2O006E00042D012O00302O010026E4000300302O01000500042D012O00302O01002E09016F00672O01007000042D012O00672O012O0066000400113O000651000400672O013O00042D012O00672O012O0066000400044O00780005000A3O00122O000600713O00122O000700726O0005000700024O00040004000500202O00040004003F4O00040002000200062O000400672O013O00042D012O00672O012O00660004000C4O0093000500043O00202O0005000500734O0006000B3O00202O0006000600744O000800043O00202O0008000800734O0006000800024O000600066O00040006000200062O000400622O01000100042D012O00622O01002E0E007500622O01007600042D012O00622O01002E3B007800672O01007700042D012O00672O012O00660004000A3O001205010500793O0012050106007A4O00D1000400064O003600046O0066000400033O0020E900040004007B4O0005000B3O00202O00050005007C4O000700043O00202O00070007007D4O000500076O00043O00024O000200043O00122O000300083O00044O00302O01002643000100762O01000800042D012O00762O01002E09017E006B0001007F00042D012O006B0001001205010300053O0026E4000300BC0201000500042D012O00BC02012O0066000400124O0066000500133O00069E000400A42O01000500042D012O00A42O012O0066000400143O000651000400892O013O00042D012O00892O012O0066000400153O000651000400862O013O00042D012O00862O012O0066000400163O0006BB0004008B2O01000100042D012O008B2O012O0066000400163O0006510004008B2O013O00042D012O008B2O01002E09018000A42O01008100042D012O00A42O01001205010400054O00B4000500053O002E3B0082008D2O01008300042D012O008D2O010026E40004008D2O01000500042D012O008D2O01001205010500053O002E9A00843O0001008400042D012O00922O01000ED4000500922O01000500042D012O00922O012O0066000600174O00170106000100022O00E500065O002E3B008600A42O01008500042D012O00A42O012O006600065O000651000600A42O013O00042D012O00A42O012O006600066O00FF000600023O00042D012O00A42O0100042D012O00922O0100042D012O00A42O0100042D012O008D2O012O0066000400124O0066000500133O00069E000400BB0201000500042D012O00BB02012O0066000400183O000651000400BB02013O00042D012O00BB02012O0066000400193O000651000400B12O013O00042D012O00B12O012O0066000400153O0006BB000400B42O01000100042D012O00B42O012O0066000400193O0006BB000400BB0201000100042D012O00BB0201001205010400053O002E3B0087000F0201008800042D012O000F0201002643000400BB2O01000500042D012O00BB2O01002E3B008A000F0201008900042D012O000F0201001205010500054O00B4000600063O002E09018B00BD2O01008C00042D012O00BD2O010026E4000500BD2O01000500042D012O00BD2O01001205010600053O000EAA000500C62O01000600042D012O00C62O01002E3B008D00060201008E00042D012O00060201002E09019000E52O01008F00042D012O00E52O01002E09019100E52O01009200042D012O00E52O012O0066000700044O00780008000A3O00122O000900933O00122O000A00946O0008000A00024O00070007000800202O00070007003F4O00070002000200062O000700E52O013O00042D012O00E52O012O00660007000C4O000D010800043O00202O0008000800954O0009001A6O000900096O00070009000200062O000700E02O01000100042D012O00E02O01002E13009600E02O01009700042D012O00E02O01002E9A009800070001009900042D012O00E52O012O00660007000A3O0012050108009A3O0012050109009B4O00D1000700094O003600075O002E3B009C00050201009D00042D012O000502012O0066000700044O00780008000A3O00122O0009009E3O00122O000A009F6O0008000A00024O00070007000800202O00070007003F4O00070002000200062O0007000502013O00042D012O000502012O00660007001B3O0020ED00070007007C4O000900043O00202O00090009007D4O00070009000200062O0007000502013O00042D012O000502012O00660007000C4O0026010800043O00202O0008000800A04O0009001A6O000900096O00070009000200062O0007000502013O00042D012O000502012O00660007000A3O001205010800A13O001205010900A24O00D1000700094O003600075O001205010600083O002E3B00A400C22O0100A300042D012O00C22O010026E4000600C22O01000800042D012O00C22O01001205010400083O00042D012O000F020100042D012O00C22O0100042D012O000F020100042D012O00BD2O01002E9A00A50051000100A500042D012O006002010026E4000400600201002500042D012O00600201002E0901A7002E020100A600042D012O002E02012O0066000500044O008F0006000A3O00122O000700A83O00122O000800A96O0006000800024O00050005000600202O00050005003F4O00050002000200062O000500210201000100042D012O00210201002E9A00AA000F000100AB00042D012O002E02012O00660005000C4O0026010600043O00202O0006000600AC4O0007001A6O000700076O00050007000200062O0005002E02013O00042D012O002E02012O00660005000A3O001205010600AD3O001205010700AE4O00D1000500074O003600056O0066000500044O00780006000A3O00122O000700AF3O00122O000800B06O0006000800024O00050005000600202O00050005003F4O00050002000200062O0005004602013O00042D012O004602012O00660005001B3O0020ED0005000500B14O000700043O00202O00070007007D4O00050007000200062O0005004602013O00042D012O004602012O00660005001B3O0020DD00050005007C4O000700043O00202O0007000700B24O00050007000200062O0005004A0201000100042D012O004A0201002E3500B4004A020100B300042D012O004A0201002E3B00B500BB020100B600042D012O00BB0201002E3B00B70058020100B800042D012O005802012O00660005001C4O0093000600043O00202O0006000600B94O0007000B3O00202O0007000700744O000900043O00202O0009000900B94O0007000900024O000700076O00050007000200062O0005005A0201000100042D012O005A0201002E3B00BA00BB020100BB00042D012O00BB02012O00660005000A3O0012C0000600BC3O00122O000700BD6O000500076O00055O00044O00BB0201002E3B00BE00B52O0100BF00042D012O00B52O010026E4000400B52O01000800042D012O00B52O01001205010500054O00B4000600063O002E0901C10066020100C000042D012O006602010026E4000500660201000500042D012O00660201001205010600053O0026E40006006F0201000800042D012O006F0201001205010400253O00042D012O00B52O010026E40006006B0201000500042D012O006B0201002E0901C30084020100C200042D012O008402012O0066000700044O00780008000A3O00122O000900C43O00122O000A00C56O0008000A00024O00070007000800202O00070007003F4O00070002000200062O0007008402013O00042D012O008402012O00660007001B3O0020DD0007000700B14O000900043O00202O00090009007D4O00070009000200062O000700860201000100042D012O00860201002E0901C60099020100C700042D012O00990201002E0901C80099020100C900042D012O009902012O00660007000C4O00B1000800043O00202O0008000800CA4O0009000B3O00202O0009000900744O000B00043O00202O000B000B00CA4O0009000B00024O000900096O00070009000200062O0007009902013O00042D012O009902012O00660007000A3O001205010800CB3O001205010900CC4O00D1000700094O003600076O0066000700044O008F0008000A3O00122O000900CD3O00122O000A00CE6O0008000A00024O00070007000800202O00070007003F4O00070002000200062O000700A50201000100042D012O00A50201002E9A00CF0013000100D000042D012O00B60201002E3B00D100AF020100D200042D012O00AF02012O00660007000C4O000D010800043O00202O0008000800D34O0009001A6O000900096O00070009000200062O000700B10201000100042D012O00B10201002E9A00D40007000100D500042D012O00B602012O00660007000A3O001205010800D63O001205010900D74O00D1000700094O003600075O001205010600083O00042D012O006B020100042D012O00B52O0100042D012O0066020100042D012O00B52O01001205010300083O002E0901D800772O0100D900042D012O00772O010026E4000300772O01000800042D012O00772O012O0066000400124O0066000500133O0006D3000400C60201000500042D012O00C60201002E0901DB0096050100DA00042D012O00960501001205010400054O00B4000500053O002643000400CC0201000500042D012O00CC0201002E0901DC00C8020100DD00042D012O00C80201001205010500053O0026E4000500680301000800042D012O00680301001205010600053O002E3B00DF00D8020100DE00042D012O00D80201000EAA000800D60201000600042D012O00D60201002E0901E100D8020100E000042D012O00D80201001205010500253O00042D012O00680301002E0901E200D0020100E300042D012O00D002010026E4000600D00201000500042D012O00D00201001205010700053O002E9A00E40004000100E400042D012O00E10201002643000700E30201000500042D012O00E30201002E9A00E5007C000100E600042D012O005D0301002E3B00E7001B030100E800042D012O001B03012O0066000800044O00780009000A3O00122O000A00E93O00122O000B00EA6O0009000B00024O00080008000900202O00080008003F4O00080002000200062O0008001B03013O00042D012O001B03012O00660008001D3O0006510008001B03013O00042D012O001B03012O00660008001E3O000651000800F802013O00042D012O00F802012O0066000800153O0006BB000800FB0201000100042D012O00FB02012O00660008001E3O0006BB0008001B0301000100042D012O001B03012O0066000800044O00780009000A3O00122O000A00EB3O00122O000B00EC6O0009000B00024O00080008000900202O0008000800ED4O00080002000200062O0008000A03013O00042D012O000A03012O00660008001F3O0020080008000800EE2O00170108000100020026DE0008001B030100EF00042D012O001B0301002E3B00F0001B030100F100042D012O001B03012O00660008000C4O000D010900043O00202O0009000900F24O000A001A6O000A000A6O0008000A000200062O000800160301000100042D012O00160301002E0901F3001B030100F400042D012O001B03012O00660008000A3O001205010900F53O001205010A00F64O00D10008000A4O003600086O0066000800044O00780009000A3O00122O000A00F73O00122O000B00F86O0009000B00024O00080008000900202O00080008003F4O00080002000200062O0008005C03013O00042D012O005C03012O0066000800204O00710009000A3O00122O000A00F93O00122O000B00FA6O0009000B000200062O0008005C0301000900042D012O005C03012O0066000800213O0006510008005C03013O00042D012O005C03012O0066000800223O0006510008003503013O00042D012O003503012O0066000800153O0006BB000800380301000100042D012O003803012O0066000800223O0006BB0008005C0301000100042D012O005C03012O0066000800044O00B90009000A3O00122O000A00FB3O00122O000B00FC6O0009000B00024O00080008000900202O0008000800FD4O00080002000200262O0008004C0301003300042D012O004C03012O00660008001B3O0020DD00080008007C4O000A00043O00202O000A000A007D4O0008000A000200062O0008004C0301000100042D012O004C03012O0066000800133O0026DE0008005C030100FE00042D012O005C03012O00660008000C4O000D010900053O00202O0009000900FF4O000A001A6O000A000A6O0008000A000200062O000800570301000100042D012O005703010012050108002O012O000ED42O00015C0301000800042D012O005C03012O00660008000A3O00120501090002012O001205010A0003013O00D10008000A4O003600085O001205010700083O00120501080004012O00120501090005012O000672000900DD0201000800042D012O00DD0201001205010800083O000647000700DD0201000800042D012O00DD0201001205010600083O00042D012O00D0020100042D012O00DD020100042D012O00D00201001205010600053O00069B0005006F0301000600042D012O006F030100120501060006012O00120501070007012O00069E0006006B0401000700042D012O006B0401001205010600053O00120501070008012O00120501080009012O000672000800770301000700042D012O00770301001205010700053O00069B0006007B0301000700042D012O007B03010012050107000A012O0012050108000B012O0006470007005D0401000800042D012O005D04012O0066000700044O00780008000A3O00122O0009000C012O00122O000A000D015O0008000A00024O00070007000800202O00070007003F4O00070002000200062O000700ED03013O00042D012O00ED03012O0066000700233O000651000700ED03013O00042D012O00ED03012O0066000700243O0006510007008E03013O00042D012O008E03012O0066000700153O0006BB000700910301000100042D012O009103012O0066000700243O0006BB000700ED0301000100042D012O00ED03012O0066000700044O00780008000A3O00122O0009000E012O00122O000A000F015O0008000A00024O00070007000800202O0007000700ED4O00070002000200062O000700B503013O00042D012O00B503012O00660007001B3O0020ED00070007007C4O000900043O00202O0009000900B24O00070009000200062O000700B503013O00042D012O00B503012O00660007001B3O0020980007000700B14O000900043O00122O000A0010015O00090009000A4O00070009000200062O000700B503013O00042D012O00B503012O0066000700044O009D0008000A3O00122O00090011012O00122O000A0012015O0008000A00024O00070007000800202O0007000700FD4O00070002000200122O000800053O00062O000800F50301000700042D012O00F503012O0066000700044O00780008000A3O00122O00090013012O00122O000A0014015O0008000A00024O00070007000800202O0007000700ED4O00070002000200062O000700CE03013O00042D012O00CE03012O00660007001B3O0020ED00070007007C4O000900043O00202O0009000900B24O00070009000200062O000700CE03013O00042D012O00CE03012O00660007001B3O0020040007000700B14O000900043O00122O000A0010015O00090009000A4O00070009000200062O000700F50301000100042D012O00F503012O0066000700044O008F0008000A3O00122O00090015012O00122O000A0016015O0008000A00024O00070007000800202O0007000700ED4O00070002000200062O000700ED0301000100042D012O00ED03012O0066000700044O008F0008000A3O00122O00090017012O00122O000A0018015O0008000A00024O00070007000800202O0007000700ED4O00070002000200062O000700ED0301000100042D012O00ED03012O00660007001B3O0020DD00070007007C4O000900043O00202O00090009007D4O00070009000200062O000700F50301000100042D012O00F503012O0066000700133O001205010800173O0006D3000700F50301000800042D012O00F5030100120501070019012O0012050108001A012O0006D3000800F50301000700042D012O00F503010012050107001B012O0012050108001C012O00069E000800030401000700042D012O000304012O00660007000C4O003C000800043O00122O0009001D015O0008000800094O0009001A6O000900096O00070009000200062O0007000304013O00042D012O000304012O00660007000A3O0012050108001E012O0012050109001F013O00D1000700094O003600076O0066000700044O00780008000A3O00122O00090020012O00122O000A0021015O0008000A00024O00070007000800202O00070007003F4O00070002000200062O0007005C04013O00042D012O005C04012O00660007001D3O0006510007005C04013O00042D012O005C04012O00660007001E3O0006510007001604013O00042D012O001604012O0066000700153O0006BB000700190401000100042D012O001904012O00660007001E3O0006BB0007005C0401000100042D012O005C04012O0066000700044O00780008000A3O00122O00090022012O00122O000A0023015O0008000A00024O00070007000800202O0007000700ED4O00070002000200062O0007002E04013O00042D012O002E04012O0066000700044O009D0008000A3O00122O00090024012O00122O000A0025015O0008000A00024O00070007000800202O0007000700FD4O00070002000200122O000800083O00062O000700470401000800042D012O004704012O0066000700044O009D0008000A3O00122O00090026012O00122O000A0027015O0008000A00024O00070007000800202O0007000700FD4O00070002000200122O00080028012O00062O000800470401000700042D012O004704012O0066000700044O00780008000A3O00122O00090029012O00122O000A002A015O0008000A00024O00070007000800202O0007000700ED4O00070002000200062O0007004704013O00042D012O004704012O0066000700133O001205010800EF3O00069E0007005C0401000800042D012O005C04010012050107002B012O0012050108002C012O000672000700530401000800042D012O005304012O00660007000C4O000D010800043O00202O0008000800F24O0009001A6O000900096O00070009000200062O000700570401000100042D012O005704010012050107002D012O0012050108002E012O0006720008005C0401000700042D012O005C04012O00660007000A3O0012050108002F012O00120501090030013O00D1000700094O003600075O001205010600083O00120501070031012O00120501080032012O000672000700640401000800042D012O00640401001205010700083O00069B000600680401000700042D012O0068040100120501070033012O00120501080034012O00069E000800700301000700042D012O00700301001205010500083O00042D012O006B040100042D012O00700301001205010600333O000647000500CE0401000600042D012O00CE04012O0066000600044O00780007000A3O00122O00080035012O00122O00090036015O0007000900024O00060006000700202O00060006003F4O00060002000200062O0006009605013O00042D012O009605012O0066000600254O00710007000A3O00122O00080037012O00122O00090038015O00070009000200062O000600960501000700042D012O009605012O0066000600263O0006510006009605013O00042D012O009605012O0066000600273O0006510006008804013O00042D012O008804012O0066000600153O0006BB0006008B0401000100042D012O008B04012O0066000600273O0006BB000600960501000100042D012O009605012O00660006001B3O0020ED00060006007C4O000800043O00202O0008000800B24O00060008000200062O0006009605013O00042D012O009605012O00660006001B3O0020DD00060006007C4O000800043O00202O00080008007D4O00060008000200062O000600BB0401000100042D012O00BB04012O00660006001B3O00200400060006007C4O000800043O00122O00090010015O0008000800094O00060008000200062O000600BB0401000100042D012O00BB04012O0066000600133O001205010700173O0006D3000600BB0401000700042D012O00BB04012O0066000600073O001205010700083O0006D3000700BB0401000600042D012O00BB04012O0066000600044O00780007000A3O00122O00080039012O00122O0009003A015O0007000900024O00060006000700202O0006000600ED4O00060002000200062O000600BB04013O00042D012O00BB04012O00660006001B3O0012D90008003B015O00060006000800122O0008003C012O00122O000900256O00060009000200062O000600960501000100042D012O009605012O00660006000C4O00C9000700053O00122O0008003D015O0007000700084O0008001A6O000800086O00060008000200062O000600C80401000100042D012O00C804010012050106003E012O0012050107003F012O00069E000600960501000700042D012O009605012O00660006000A3O0012C000070040012O00122O00080041015O000600086O00065O00044O00960501001205010600253O00069B000500D50401000600042D012O00D5040100120501060042012O00120501070043012O000672000600CD0201000700042D012O00CD0201001205010600054O00B4000700073O001205010800053O000647000600D70401000800042D012O00D70401001205010700053O00120501080044012O00120501090044012O0006470008008B0501000900042D012O008B0501001205010800053O0006470008008B0501000700042D012O008B05012O0066000800044O00780009000A3O00122O000A0045012O00122O000B0046015O0009000B00024O00080008000900202O00080008003F4O00080002000200062O0008001505013O00042D012O001505012O0066000800204O00710009000A3O00122O000A0047012O00122O000B0048015O0009000B000200062O000800150501000900042D012O001505012O0066000800213O0006510008001505013O00042D012O001505012O0066000800223O000651000800FC04013O00042D012O00FC04012O0066000800153O0006BB000800FF0401000100042D012O00FF04012O0066000800223O0006BB000800150501000100042D012O001505012O0066000800044O009D0009000A3O00122O000A0049012O00122O000B004A015O0009000B00024O00080008000900202O0008000800FD4O00080002000200122O000900333O00062O000800190501000900042D012O001905012O00660008001B3O0020DD00080008007C4O000A00043O00202O000A000A007D4O0008000A000200062O000800190501000100042D012O001905012O0066000800133O001205010900FE3O0006D3000800190501000900042D012O001905010012050108004B012O0012050109004C012O0006470008002B0501000900042D012O002B05010012050108004D012O0012050109004D012O0006470008002B0501000900042D012O002B05012O00660008000C4O003C000900053O00122O000A004E015O00090009000A4O000A001A6O000A000A6O0008000A000200062O0008002B05013O00042D012O002B05012O00660008000A3O0012050109004F012O001205010A0050013O00D10008000A4O003600086O0066000800044O00780009000A3O00122O000A0051012O00122O000B0052015O0009000B00024O00080008000900202O00080008003F4O00080002000200062O0008008A05013O00042D012O008A05012O0066000800254O00710009000A3O00122O000A0053012O00122O000B0054015O0009000B000200062O0008008A0501000900042D012O008A05012O0066000800263O0006510008008A05013O00042D012O008A05012O0066000800273O0006510008004505013O00042D012O004505012O0066000800153O0006BB000800480501000100042D012O004805012O0066000800273O0006BB0008008A0501000100042D012O008A05012O00660008001B3O0020ED00080008007C4O000A00043O00202O000A000A00B24O0008000A000200062O0008008A05013O00042D012O008A05012O00660008001B3O0020DD00080008007C4O000A00043O00202O000A000A007D4O0008000A000200062O000800780501000100042D012O007805012O00660008001B3O00200400080008007C4O000A00043O00122O000B0010015O000A000A000B4O0008000A000200062O000800780501000100042D012O007805012O0066000800133O001205010900173O0006D3000800780501000900042D012O007805012O0066000800073O001205010900083O0006D3000900780501000800042D012O007805012O0066000800044O00780009000A3O00122O000A0055012O00122O000B0056015O0009000B00024O00080008000900202O0008000800ED4O00080002000200062O0008007805013O00042D012O007805012O00660008001B3O0012D9000A003B015O00080008000A00122O000A003C012O00122O000B00256O0008000B000200062O0008008A0501000100042D012O008A05012O00660008000C4O00C9000900053O00122O000A0057015O00090009000A4O000A001A6O000A000A6O0008000A000200062O000800850501000100042D012O00850501001205010800333O00120501090058012O0006470008008A0501000900042D012O008A05012O00660008000A3O00120501090059012O001205010A005A013O00D10008000A4O003600085O001205010700083O001205010800083O000647000700DB0401000800042D012O00DB0401001205010500333O00042D012O00CD020100042D012O00DB040100042D012O00CD020100042D012O00D7040100042D012O00CD020100042D012O0096050100042D012O00C802010012052O0100253O00042D012O006B000100042D012O00772O0100042D012O006B000100042D012O009C050100042D012O006000012O00B63O00017O00263O00028O00025O0061B140025O0078AC40030F3O00412O66656374696E67436F6D626174025O00206340025O007C9D40025O008AA540026O00AF40025O00608940025O00389D40025O00949B40026O008440030F3O002DAABC002OFAE7D41D9CBA12F1EBE903083O00B16FCFCE739F888C030A3O0049734361737461626C6503083O0042752O66446F776E030F3O004265727365726B65725374616E6365025O0062AE4003103O00078C0207D15D54009B2F07C04E51068C03073O003F65E97074B42F026O006940025O00B6AF40030B3O00E13AF906F433F033E207EC03063O0056A35B8D7298030F3O0042612O746C6553686F757442752O6603103O0047726F757042752O664D692O73696E67030B3O0042612O746C6553686F7574025O0014A940025O00E0954003163O00510A6067365634677B35461F34632856087B7E38521F03053O005A336B1413025O00909540025O002EAE40030D3O00546172676574497356616C6964025O00E06640025O001AAA40025O00A07A40025O0098A94000853O001205012O00014O00B4000100013O0026433O00060001000100042D012O00060001002E3B000200020001000300042D012O000200010012052O0100013O0026E4000100070001000100042D012O000700012O006600025O0020FE0002000200042O000F0002000200020006510002001200013O00042D012O00120001002E0E000600120001000500042D012O00120001002E3B000800600001000700042D012O00600001002E09010900350001000A00042D012O00350001002E3B000C00350001000B00042D012O003500012O0066000200014O0078000300023O00122O0004000D3O00122O0005000E6O0003000500024O00020002000300202O00020002000F4O00020002000200062O0002003500013O00042D012O003500012O006600025O0020AD0002000200104O000400013O00202O0004000400114O000500016O00020005000200062O0002003500013O00042D012O00350001002E9A0012000D0001001200042D012O003500012O0066000200034O0066000300013O0020080003000300112O000F0002000200020006510002003500013O00042D012O003500012O0066000200023O001205010300133O001205010400144O00D1000200044O003600025O002E3B001500600001001600042D012O006000012O0066000200014O0078000300023O00122O000400173O00122O000500186O0003000500024O00020002000300202O00020002000F4O00020002000200062O0002006000013O00042D012O006000012O0066000200043O0006510002006000013O00042D012O006000012O006600025O00205F0002000200104O000400013O00202O0004000400194O000500016O00020005000200062O000200530001000100042D012O005300012O0066000200053O0020C100020002001A4O000300013O00202O0003000300194O00020002000200062O0002006000013O00042D012O006000012O0066000200034O0066000300013O00200800030003001B2O000F0002000200020006BB0002005B0001000100042D012O005B0001002E09011C00600001001D00042D012O006000012O0066000200023O0012050103001E3O0012050104001F4O00D1000200044O003600025O002E3B002000840001002100042D012O008400012O0066000200053O0020080002000200222O00170102000100020006510002008400013O00042D012O008400012O0066000200063O0006510002008400013O00042D012O00840001002E09012300840001002400042D012O008400012O006600025O0020FE0002000200042O000F0002000200020006BB000200840001000100042D012O00840001001205010200013O0026E4000200720001000100042D012O007200012O0066000300084O00170103000100022O00E5000300074O0066000300073O0006BB0003007C0001000100042D012O007C0001002E3B002600840001002500042D012O008400012O0066000300074O00FF000300023O00042D012O0084000100042D012O0072000100042D012O0084000100042D012O0007000100042D012O0084000100042D012O000200012O00B63O00017O00AF3O00028O00025O000C9640025O00A8A240025O0010AC40025O00F8AF40025O0068AA40026O002040030C3O004570696353652O74696E677303083O001D0BEFE22700FCE503043O00964E6E9B03143O0091CD32EFA01BAD4F90D615EEA50C884991CD04C503083O0020E5A54781C47EDF025O00A3B240026O001C40025O00805840025O0052A24003083O0080D3D9D5C0AF42A003073O0025D3B6ADA1A9C1030D3O00E53B5BD82F7EABC03359D10B5F03073O00D9975A2DB9481B03083O00F079F3065FCD7BF403053O0036A31C877203123O003ADE5E89427A3BC853875D6C1FD2498A6D5B03063O001F48BB3DE22E026O00F03F025O00C9B040025O006C9340025O00E9B240025O00F5B14003083O00F00357C64E7023D003073O0044A36623B2271E03143O00AD60DFC6119A8533BF632OCE0CBBB418AA78F9E303083O0071DE10BAA763D5E3025O00F4AE40025O00E06440025O006CB140025O00E2A740025O006AA04003083O00C2E62437ADFFE42303053O00C491835043030E3O000BA3032A14E711B4120011FA0DA403063O00887ED066687803083O00BEF591FB3483F79603053O005DED90E58F030E4O00E5F53B0A5201FAF52A034900E203063O0026759690796B03083O001EBEFA2E24B5E92903043O005A4DDB8E030C3O00F317241B400875E206202D4403073O001A866441592C67026O000840025O0012AF40025O0050B240025O00308840025O00707C40025O00C8AD40025O0012A84003083O00B91A0DB2D584180A03053O00BCEA7F79C6030C3O002D2116B4303B018F2F3B1D8703043O00E3585273026O001040026O008A40025O0056A24003083O0001E69C29405435F003063O003A5283E85D29030A3O009644D5275C329356D71003063O005FE337B0753D03083O002B7B375FA216793003053O00CB781E432B03073O00E43648DCD5F02803053O00B991452D8F026O001440025O00389E40025O00B2A540025O00E08240025O003DB240025O0050A040025O00B6A240025O0036AC40025O0011B34003083O003145F9E70B4EEAE003043O009362208D030A3O000D50E6F807404A1F46F103073O002B782383AA663603083O00670393A2ACBE834703073O00E43466E7D6C5D0030F3O000BF370F8EF8812DA1BF366C4EF980A03083O00B67E8015AA8AEB79025O00209F40025O0074A440025O00ECA940025O00207A4003083O00B8DF21F28F1D371503083O0066EBBA5586E6735003113O00421F3B6C62D1234523387D73C7365E033003073O0042376C5E3F12B4026O001840025O0016A140025O00D2AD40025O00C07A40025O00C88E4003083O00701AAEB30B7D440C03063O0013237FDAC76203103O0009E80FD50EFE09E915F50DD614E905F503043O00827C9B6A03083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C03093O005929E68F1F4D2EE2BC03053O00692C5A83CE025O00C6AF40025O00D2A34003083O00CCE5A6AD0130F8F303063O005E9F80D2D968030C3O0045EA03905B66F76976EC14A603083O001A309966DF3F1F99025O0049B040025O00B8AF4003083O004B8FDA57A65C3A4203083O003118EAAE23CF325D03093O0019E1F8AB790DE0FA8D03053O00116C929DE803083O0078C600F926A64CD003063O00C82BA3748D4F030F3O00AA2538A0A2E1F0B73F338492F8ECA803073O0083DF565DE3D09403083O00D0402OA214BBE45603063O00D583252OD67D030A3O003338209AF9232830ABE403053O0081464B45DF027O0040025O0010A740025O00F88F40025O00805540025O00F0824003083O001C1B3B3E0809280D03063O00674F7E4F4A61030E3O00B57BCA7D780FA866E47A4A12995B03063O007ADA1FB3133E025O00508140025O0034AB4003083O00278891232E57139E03063O003974EDE5574703113O00BFA2E8D37FFB49AEB4FFE862FD75A5B0FF03073O0027CAD18D87178E03083O00CC361D1E3BF6F82003063O00989F53696A52030C3O0080D050E6C84EB6CF45FAEA7803063O003CE1A63192A9025O00805240025O009AAB40025O00206340025O002AA340025O00E8A440025O0083B040025O00E49940025O00EEA94003083O003E5C232A2CF60A4A03063O00986D39575E45030D3O00ECC40F91BFD55DA6FEF506ACA903083O00C899B76AC3DEB234025O00B07140025O000EA640025O00409940025O00588F4003083O0075CEE7FD75E141D803063O008F26AB93891C030E3O00C591BCDB06F1DBD9818DFB11ECC303073O00B4B0E2D993638303083O00E0BC3B13DAB7281403043O0067B3D94F030C3O005FA419FA4F9FAF4BA21BDD5503073O00C32AD77CB521EC025O0092B040025O00E0764000FA012O001205012O00014O00B4000100013O002E3B000200020001000300042D012O000200010026433O00080001000100042D012O00080001002E9A000400FCFF2O000500042D012O000200010012052O0100013O002E9A000600110001000600042D012O001A00010026E40001001A0001000700042D012O001A00010012E2000200084O009F000300013O00122O000400093O00122O0005000A6O0003000500024O0002000200034O000300013O00122O0004000B3O00122O0005000C6O0003000500024O0002000200032O00E500025O00042D012O00F92O01002E9A000D00370001000D00042D012O005100010026E4000100510001000E00042D012O00510001001205010200013O002643000200230001000100042D012O00230001002E090110003C0001000F00042D012O003C00010012E2000300084O004E000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000300023O00122O000300086O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000300033O00122O000200193O002E3B001B001F0001001A00042D012O001F0001002E09011D001F0001001C00042D012O001F00010026E40002001F0001001900042D012O001F00010012E2000300084O0069000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000300043O00122O000100073O00044O0051000100042D012O001F0001002E9A002200350001002200042D012O008600010026E4000100860001000100042D012O00860001001205010200013O002E090123006A0001002400042D012O006A0001000EAA0019005C0001000200042D012O005C0001002E090125006A0001002600042D012O006A00010012E2000300084O0069000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000300053O00122O000100193O00044O008600010026E4000200560001000100042D012O005600010012E2000300084O0020000400013O00122O0005002B3O00122O0006002C6O0004000600024O0003000300044O000400013O00122O0005002D3O00122O0006002E6O0004000600024O0003000300044O000300063O00122O000300086O000400013O00122O0005002F3O00122O000600306O0004000600024O0003000300044O000400013O00122O000500313O00122O000600326O0004000600024O0003000300044O000300073O00122O000200193O00044O00560001000EAA0033008A0001000100042D012O008A0001002E09013500BD0001003400042D012O00BD0001001205010200013O002643000200910001001900042D012O00910001002E35003600910001003700042D012O00910001002E3B0038009F0001003900042D012O009F00010012E2000300084O0069000400013O00122O0005003A3O00122O0006003B6O0004000600024O0003000300044O000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O000300083O00122O0001003E3O00044O00BD0001002643000200A30001000100042D012O00A30001002E9A003F00EAFF2O004000042D012O008B00010012E2000300084O0020000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O000400013O00122O000500433O00122O000600446O0004000600024O0003000300044O000300093O00122O000300086O000400013O00122O000500453O00122O000600466O0004000600024O0003000300044O000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O0003000A3O00122O000200193O00044O008B0001002643000100C10001004900042D012O00C10001002E9A004A00470001004B00042D012O00062O01001205010200014O00B4000300033O002643000200C70001000100042D012O00C70001002E9A004C00FEFF2O004D00042D012O00C30001001205010300013O002643000300CE0001000100042D012O00CE0001002E35004F00CE0001004E00042D012O00CE0001002E3B005100F10001005000042D012O00F10001001205010400013O0026E4000400EA0001000100042D012O00EA00010012E2000500084O004E000600013O00122O000700523O00122O000800536O0006000800024O0005000500064O000600013O00122O000700543O00122O000800556O0006000800024O0005000500064O0005000B3O00122O000500086O000600013O00122O000700563O00122O000800576O0006000800024O0005000500064O000600013O00122O000700583O00122O000800596O0006000800024O0005000500064O0005000C3O00122O000400193O002E09015A00CF0001005B00042D012O00CF00010026E4000400CF0001001900042D012O00CF0001001205010300193O00042D012O00F1000100042D012O00CF0001002643000300F50001001900042D012O00F50001002E9A005C00D5FF2O005D00042D012O00C800010012E2000400084O0069000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O0004000D3O00122O000100623O00044O00062O0100042D012O00C8000100042D012O00062O0100042D012O00C30001000ED4003E00432O01000100042D012O00432O01001205010200013O000ED4000100302O01000200042D012O00302O01001205010300013O002E3B006300122O01006400042D012O00122O010026E4000300122O01001900042D012O00122O01001205010200193O00042D012O00302O01002E090165000C2O01006600042D012O000C2O010026E40003000C2O01000100042D012O000C2O010012E2000400084O0020000500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O0004000E3O00122O000400086O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400054O0004000F3O00122O000300193O00044O000C2O01002643000200342O01001900042D012O00342O01002E09016F00092O01007000042D012O00092O010012E2000300084O0069000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000300103O00122O000100493O00044O00432O0100042D012O00092O010026E4000100742O01001900042D012O00742O01001205010200013O0026430002004A2O01000100042D012O004A2O01002E09017500632O01007600042D012O00632O010012E2000300084O004E000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000400013O00122O000500793O00122O0006007A6O0004000600024O0003000300044O000300113O00122O000300086O000400013O00122O0005007B3O00122O0006007C6O0004000600024O0003000300044O000400013O00122O0005007D3O00122O0006007E6O0004000600024O0003000300044O000300123O00122O000200193O0026E4000200462O01001900042D012O00462O010012E2000300084O0069000400013O00122O0005007F3O00122O000600806O0004000600024O0003000300044O000400013O00122O000500813O00122O000600826O0004000600024O0003000300044O000300133O00122O000100833O00044O00742O0100042D012O00462O010026E4000100B52O01006200042D012O00B52O01001205010200013O002E090185008B2O01008400042D012O008B2O010026430002007D2O01001900042D012O007D2O01002E090187008B2O01008600042D012O008B2O010012E2000300084O0069000400013O00122O000500883O00122O000600896O0004000600024O0003000300044O000400013O00122O0005008A3O00122O0006008B6O0004000600024O0003000300044O000300143O00122O0001000E3O00044O00B52O010026E4000200772O01000100042D012O00772O01001205010300013O002E09018C00AB2O01008D00042D012O00AB2O010026E4000300AB2O01000100042D012O00AB2O010012E2000400084O004E000500013O00122O0006008E3O00122O0007008F6O0005000700024O0004000400054O000500013O00122O000600903O00122O000700916O0005000700024O0004000400054O000400153O00122O000400086O000500013O00122O000600923O00122O000700936O0005000700024O0004000400054O000500013O00122O000600943O00122O000700956O0005000700024O0004000400054O000400163O00122O000300193O002E090196008E2O01009700042D012O008E2O01002643000300B12O01001900042D012O00B12O01002E090199008E2O01009800042D012O008E2O01001205010200193O00042D012O00772O0100042D012O008E2O0100042D012O00772O01000EAA008300B92O01000100042D012O00B92O01002E09019B00090001009A00042D012O00090001001205010200013O002E3B009C00CC2O01009D00042D012O00CC2O010026E4000200CC2O01001900042D012O00CC2O010012E2000300084O0069000400013O00122O0005009E3O00122O0006009F6O0004000600024O0003000300044O000400013O00122O000500A03O00122O000600A16O0004000600024O0003000300044O000300173O00122O000100333O00044O00090001002643000200D02O01000100042D012O00D02O01002E0901A300BA2O0100A200042D012O00BA2O01001205010300013O000EAA000100D52O01000300042D012O00D52O01002E9A00A4001B000100A500042D012O00EE2O010012E2000400084O004E000500013O00122O000600A63O00122O000700A76O0005000700024O0004000400054O000500013O00122O000600A83O00122O000700A96O0005000700024O0004000400054O000400183O00122O000400086O000500013O00122O000600AA3O00122O000700AB6O0005000700024O0004000400054O000500013O00122O000600AC3O00122O000700AD6O0005000700024O0004000400054O000400193O00122O000300193O002E3B00AF00D12O0100AE00042D012O00D12O010026E4000300D12O01001900042D012O00D12O01001205010200193O00042D012O00BA2O0100042D012O00D12O0100042D012O00BA2O0100042D012O0009000100042D012O00F92O0100042D012O000200012O00B63O00017O00833O00028O00025O00B0AC40025O00F88A40026O001040030C3O004570696353652O74696E677303083O0096F55CD0ACFE4FD703043O00A4C59028030C3O008AF7A484CF2OB3F1A385F58603063O00D6E390CAEBBD03083O00DEA0936F19BD542F03083O005C8DC5E71B70D333030D3O00F4FE86AFC8EFF18D80C3FFD7BA03053O00B1869FEAC3026O00F03F025O0068B24003083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC003103O00CC8A73333B2FD08C5C2D3B01CC846A2F03063O0046BEEB1F5F42026O001440025O00208340025O00E89040025O000EAA40025O0060A740026O00184003083O0028896D2012827E2703043O00547BEC19030D3O00E682A903A3A7E9B9BF04A49DC003063O00D590EBCA77CC03083O00101DCA3E212D4A3003073O002D4378BE4A4843030E3O003223FBA4FE8DFCDA2536F9ACF78F03083O008940428DC599E88E03063O0013DC23BF8D1103053O00E863B042C603083O00DF243C127283FE3F03083O004C8C4148661BED99030C3O0059CA13D3C532BB5ECE1FDCD003073O00DE2ABA76B2B76103063O004DE0459358FE03043O00EA3D8C24025O00BCA040025O00409A40025O00688740025O00709F40025O00A06A40025O00289740025O00D09640025O00A4B140025O004CA240025O00606540025O0053B24003083O0089E70EF2ECB4E50903053O0085DA827A86030B3O0035F1F7C1CEB53D32FACBF403073O00585C9F83A4BCC303083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B03113O002AF98C13CF3DF59C13F23AFD8415C406CC03053O00A14E9CEA7603083O0094B2DDC8AEB9CECF03043O00BCC7D7A9030A3O00E9074C6FE9F20A5A53D803053O00889C693F1B027O0040025O00C4A240025O00EAAA40026O006440025O00BCAB40025O00FAA040025O00E8B24003083O00BE35EC3054EF8A2303063O0081ED5098443D030E3O0044BB01C11D1B5448A10AF43F054103073O003831C864937C7703083O00FF3BABE4C530B8E303043O0090AC5EDF030C3O00311CA76E2A1BA755320AAC4203043O0027446FC2025O00A06240025O00F4AA40025O0058AE40025O0008954003083O00E5A3F3D370B9D1B503063O00D7B6C687A71903123O00985AEF6C884FEF469E40FC4DBE5DEB468E4C03043O0028ED298A026O000840025O009CAA40025O00C6A44003083O001BA4D068172D363103083O004248C1A41C7E4351030D3O00F23FAD712178E83EAD68277FE903063O0016874CC83846025O0040AA4003083O007E1438FB441F2BFC03043O008F2D714C03113O00ADAB191EB1AC0839AA911131ADB61528A103043O005C2OD87C03083O006837B854F45535BF03053O009D3B52CC2003163O002O2DE6DFE7F8D2B63D3AD1FFEEEFDDB42A3FF7F3E6E403083O00D1585E839A898AB3025O0007B34003083O00F471EEEC43C973E903053O002AA7149A98030E3O005FEDA77478225EF1B05B433459F603063O00412A9EC2221103083O002922461824E31CFD03083O008E7A47326C4D8D7B03103O0017ABEB0C3E078BF2152E1BABEB01132503053O005B75C29F78026O00A64003083O0029182A0C3CFF230903073O00447A7D5E78559103153O002O12DD5FCFDCBE2519C85BC6DCA81608C651C6F18A03073O00DA777CAF3EA8B9025O00A0A240025O00E0894003083O00F08CD09588DBC49A03063O00B5A3E9A42OE103093O0045983B47458633725C03043O001730EB5E03083O004FDFCC495E3DD56F03073O00B21CBAB83D3753030C3O00D1DE420FE601E7C9EF4830E603073O0095A4AD275C926E03083O00C022040B1315F43403063O007B9347707F7A03143O00D9DE875848D8C48F7842CDD98B7F41FFC58D645203053O0026ACADE21100AF012O001205012O00014O00B4000100013O0026433O00060001000100042D012O00060001002E09010200020001000300042D012O000200010012052O0100013O0026E4000100410001000400042D012O00410001001205010200013O0026E40002002B0001000100042D012O002B00010012E2000300054O00C6000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O00030003000400062O0003001A0001000100042D012O001A0001001205010300014O00E500035O001276000300056O000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400062O000300290001000100042D012O00290001001205010300014O00E5000300023O0012050102000E3O002E9A000F00DFFF2O000F00042D012O000A0001000ED4000E000A0001000200042D012O000A00010012E2000300054O00C6000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000400013O00122O000500123O00122O000600136O0004000600024O00030003000400062O0003003D0001000100042D012O003D0001001205010300014O00E5000300033O0012052O0100143O00042D012O0041000100042D012O000A0001002E3B0015007B0001001600042D012O007B0001002E090118007B0001001700042D012O007B00010026E40001007B0001001900042D012O007B00010012E2000200054O00C6000300013O00122O0004001A3O00122O0005001B6O0003000500024O0002000200034O000300013O00122O0004001C3O00122O0005001D6O0003000500024O00020002000300062O000200550001000100042D012O00550001001205010200014O00E5000200043O001276000200056O000300013O00122O0004001E3O00122O0005001F6O0003000500024O0002000200034O000300013O00122O000400203O00122O000500216O0003000500024O00020002000300062O000200670001000100042D012O006700012O0066000200013O001205010300223O001205010400234O006E0002000400022O00E5000200053O001276000200056O000300013O00122O000400243O00122O000500256O0003000500024O0002000200034O000300013O00122O000400263O00122O000500276O0003000500024O00020002000300062O000200790001000100042D012O007900012O0066000200013O001205010300283O001205010400294O006E0002000400022O00E5000200063O00042D012O00AE2O01002E9A002A00520001002A00042D012O00CD00010026E4000100CD0001001400042D012O00CD0001001205010200014O00B4000300033O002643000200850001000100042D012O00850001002E3B002B00810001002C00042D012O00810001001205010300013O0026430003008A0001000100042D012O008A0001002E3B002D00B70001002E00042D012O00B70001001205010400013O002E09013000910001002F00042D012O009100010026E4000400910001000E00042D012O009100010012050103000E3O00042D012O00B70001002E090132008B0001003100042D012O008B0001002643000400970001000100042D012O00970001002E090134008B0001003300042D012O008B00010012E2000500054O00C6000600013O00122O000700353O00122O000800366O0006000800024O0005000500064O000600013O00122O000700373O00122O000800386O0006000800024O00050005000600062O000500A50001000100042D012O00A50001001205010500014O00E5000500073O001276000500056O000600013O00122O000700393O00122O0008003A6O0006000800024O0005000500064O000600013O00122O0007003B3O00122O0008003C6O0006000800024O00050005000600062O000500B40001000100042D012O00B40001001205010500014O00E5000500083O0012050104000E3O00042D012O008B00010026E4000300860001000E00042D012O008600010012E2000400054O00C6000500013O00122O0006003D3O00122O0007003E6O0005000700024O0004000400054O000500013O00122O0006003F3O00122O000700406O0005000700024O00040004000500062O000400C70001000100042D012O00C70001001205010400014O00E5000400093O0012052O0100193O00042D012O00CD000100042D012O0086000100042D012O00CD000100042D012O00810001002643000100D10001004100042D012O00D10001002E9A0042003F0001004300042D012O000E2O01001205010200013O002E09014400F90001004500042D012O00F90001000EAA000100D80001000200042D012O00D80001002E3B004700F90001004600042D012O00F90001001205010300013O0026E4000300F40001000100042D012O00F400010012E2000400054O004E000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O000500013O00122O0006004A3O00122O0007004B6O0005000700024O0004000400054O0004000A3O00122O000400056O000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O000500013O00122O0006004E3O00122O0007004F6O0005000700024O0004000400054O0004000B3O00122O0003000E3O0026E4000300D90001000E00042D012O00D900010012050102000E3O00042D012O00F9000100042D012O00D90001002E3B005000D20001005100042D012O00D20001002643000200FF0001000E00042D012O00FF0001002E3B005200D20001005300042D012O00D200010012E2000300054O0069000400013O00122O000500543O00122O000600556O0004000600024O0003000300044O000400013O00122O000500563O00122O000600576O0004000600024O0003000300044O0003000C3O00122O000100583O00044O000E2O0100042D012O00D20001002643000100122O01000E00042D012O00122O01002E3B005900492O01005A00042D012O00492O01001205010200014O00B4000300033O0026E4000200142O01000100042D012O00142O01001205010300013O0026E4000300272O01000E00042D012O00272O010012E2000400054O0069000500013O00122O0006005B3O00122O0007005C6O0005000700024O0004000400054O000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O0004000D3O00122O000100413O00044O00492O01002E9A004300F0FF2O004300042D012O00172O01002E9A005F00EEFF2O005F00042D012O00172O010026E4000300172O01000100042D012O00172O010012E2000400054O0020000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O000500013O00122O000600623O00122O000700636O0005000700024O0004000400054O0004000E3O00122O000400056O000500013O00122O000600643O00122O000700656O0005000700024O0004000400054O000500013O00122O000600663O00122O000700676O0005000700024O0004000400054O0004000F3O00122O0003000E3O00044O00172O0100042D012O00492O0100042D012O00142O01002E9A006800390001006800042D012O00822O010026E4000100822O01005800042D012O00822O01001205010200013O0026E40002006C2O01000100042D012O006C2O010012E2000300054O008B000400013O00122O000500693O00122O0006006A6O0004000600024O0003000300044O000400013O00122O0005006B3O00122O0006006C6O0004000600024O0003000300044O000300103O00122O000300056O000400013O00122O0005006D3O00122O0006006E6O0004000600024O0003000300044O000400013O00122O0005006F3O00122O000600706O0004000600024O00030003000400062O0003006A2O01000100042D012O006A2O01001205010300014O00E5000300113O0012050102000E3O002E090116004E2O01007100042D012O004E2O010026E40002004E2O01000E00042D012O004E2O010012E2000300054O00C6000400013O00122O000500723O00122O000600736O0004000600024O0003000300044O000400013O00122O000500743O00122O000600756O0004000600024O00030003000400062O0003007E2O01000100042D012O007E2O01001205010300014O00E5000300123O0012052O0100043O00042D012O00822O0100042D012O004E2O01000EAA000100862O01000100042D012O00862O01002E3B007600070001007700042D012O000700010012E2000200054O00FA000300013O00122O000400783O00122O000500796O0003000500024O0002000200034O000300013O00122O0004007A3O00122O0005007B6O0003000500024O0002000200034O000200133O00122O000200056O000300013O00122O0004007C3O00122O0005007D6O0003000500024O0002000200034O000300013O00122O0004007E3O00122O0005007F6O0003000500024O0002000200034O000200143O00122O000200056O000300013O00122O000400803O00122O000500816O0003000500024O0002000200034O000300013O00122O000400823O00122O000500836O0003000500024O0002000200034O000200153O00122O0001000E3O00042D012O0007000100042D012O00AE2O0100042D012O000200012O00B63O00017O004B3O00028O00027O0040025O00ECAD40025O00E8B040026O00F03F025O0044AB40025O0022AE40030C3O004570696353652O74696E677303083O000E153AECD5313A2O03063O005F5D704E98BC030E3O00D4E6803DE1BFDED5FD9601EBB0D703073O00B2A195E57584DE026O000840025O002C9140025O0092B240025O00289E4003083O0024369D1C1E3D8E1B03043O00687753E9030E3O00E1EA2E2C48F0EC34154AE1F0040603053O00239598474203083O002AED56A43317EF5103053O005A798822D0030D3O00D50F5617C6024629CE1A5D3DE303043O007EA76E35025O00C0714003083O0012D8AE66062FDAA903053O006F41BDDA1203113O0045421C3D1F6EAA4E4A123B187FA746481003073O00CF232B7B556B3C03083O0043AFB4FE707EADB303053O001910CAC08A03113O00D4C5B9E7BBE6E8DBB9D5A0E0F5F8B9F7A703063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B103163O00A4160E489F0A0F5D99371441942F1244991D16449E0C03043O002DED787A03083O00E4EDB638DEE6A53F03043O004CB788C203123O0053E8F13D425D016AF2D130424A07722OE93C03073O00741A868558302F03083O002DC4B4F0B47C19D203063O00127EA1C084DD030B3O004A3BAB30445626A501424C03053O00363F48CE6403083O00FB5C516EEC75CF4A03063O001BA839251A85030A3O0038B9799AD62EA37DA4C403053O00B74DCA1CC8025O0020A340025O00C49840025O0007B340025O001CB340026O00104003083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203113O00CDA3BBCB812OE296B5D381E3EB88BBCA8D03063O008C85C6DAA7E8034O0003083O00862BA0698DBB29A703053O00E4D54ED41D03113O00AF4DB801E78265B806E4955CB917EE864003053O008BE72CD66503083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C603103O009E3DB0083E03E38220B2103416E6842003073O008FEB4ED5405B6203083O00BE4D90FD79B88A5B03063O00D6ED28E48910030D3O008DE6EED517AE96F7E0D7068EB503063O00C6E5838FB96303083O006289BC675882AF6003043O001331ECC8030F3O00F632F7BBEDB4F907F9A3EDB5F01FC603063O00DA9E5796D78400DC3O001205012O00013O0026433O00050001000200042D012O00050001002E09010400380001000300042D012O003800010012052O0100013O0026430001000A0001000500042D012O000A0001002E09010700180001000600042D012O001800010012E2000200084O0069000300013O00122O000400093O00122O0005000A6O0003000500024O0002000200034O000300013O00122O0004000B3O00122O0005000C6O0003000500024O0002000200034O00025O00124O000D3O00044O003800010026430001001E0001000100042D012O001E0001002E0E000F001E0001000E00042D012O001E0001002E9A001000EAFF2O000600042D012O000600010012E2000200084O0020000300013O00122O000400113O00122O000500126O0003000500024O0002000200034O000300013O00122O000400133O00122O000500146O0003000500024O0002000200034O000200023O00122O000200086O000300013O00122O000400153O00122O000500166O0003000500024O0002000200034O000300013O00122O000400173O00122O000500186O0003000500024O0002000200034O000200033O00122O000100053O00044O00060001002E9A0019002C0001001900042D012O00640001000ED40001006400013O00042D012O006400010012E2000100084O00C6000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O000200013O00122O0003001C3O00122O0004001D6O0002000400024O00010001000200062O0001004A0001000100042D012O004A00010012052O0100014O00E5000100043O0012E2000100084O004E000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O000100053O00122O000100086O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O000200013O00122O000300243O00122O000400256O0002000400024O0001000100024O000100063O00124O00053O0026E43O008B0001000500042D012O008B00010012E2000100084O00FA000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O000100073O00122O000100086O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100083O00122O000100086O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100093O00124O00023O002E3B003300AD0001003200042D012O00AD0001002E09013400AD0001003500042D012O00AD00010026E43O00AD0001003600042D012O00AD00010012E2000100084O00C6000200013O00122O000300373O00122O000400386O0002000400024O0001000100024O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O0001009F0001000100042D012O009F00010012052O01003B4O00E50001000A3O00125A000100086O000200013O00122O0003003C3O00122O0004003D6O0002000400024O0001000100024O000200013O00122O0003003E3O00122O0004003F6O0002000400022O00400001000100022O00E50001000B3O00042D012O00DB0001000ED4000D000100013O00042D012O000100010012E2000100084O008B000200013O00122O000300403O00122O000400416O0002000400024O0001000100024O000200013O00122O000300423O00122O000400436O0002000400024O0001000100024O0001000C3O00122O000100086O000200013O00122O000300443O00122O000400456O0002000400024O0001000100024O000200013O00122O000300463O00122O000400476O0002000400024O00010001000200062O000100C90001000100042D012O00C900010012052O0100014O00E50001000D3O001276000100086O000200013O00122O000300483O00122O000400496O0002000400024O0001000100024O000200013O00122O0003004A3O00122O0004004B6O0002000400024O00010001000200062O000100D80001000100042D012O00D800010012052O0100014O00E50001000E3O001205012O00363O00042D012O000100012O00B63O00017O00593O00028O00025O0004AF40025O00107240026O00F03F025O00B2A240025O00809940025O0079B240030D3O004973446561644F7247686F737403113O00CCE35213F6ECE9470EF2EBEA7512F4F0F903053O009B858D267A030B3O004973417661696C61626C65026O002040027O0040030C3O004570696353652O74696E677303073O0064E5FFCF4D55F903053O0021308A98A82O033O0073193503063O005712765031A103073O007811DDA7BC490D03053O00D02C7EBAC02O033O00F41EB703083O002E977AC4A6749CA9025O00949240025O00DCA240025O00C09840025O0048B040025O00D89A40025O0096A240025O002CA840025O00D6AF40025O006DB240025O00DAA140025O0032A04003163O00476574456E656D696573496E4D656C2O6552616E6765030E3O004973496E4D656C2O6552616E6765026O001440026O009740030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O009CA640025O00DEA540025O00A8B140025O0086B140025O00EC9340025O002AAC40025O00708340025O0004964003103O00426F2O73466967687452656D61696E73026O006E40025O00989240025O00D88340025O00A2A140025O0022A040025O002EB240025O00A49E40025O00B08040024O0080B3C540030C3O00466967687452656D61696E73025O00806840025O009EA740030C3O0049734368612O6E656C696E67025O00E8B140025O005EA340025O00649B40025O007C9040026O00A040025O00CEA740025O00B07940025O0034A740025O00809440025O00D2A540025O00B0A040025O00E07F40025O0092A240025O0050A340025O00E8A040025O0098AA40025O00E09040025O00CCA640025O00C4AA40025O00D49B40025O0018B140025O00CCAF40025O0098A540025O0018A74003073O00EDE001591CB42203083O0076B98F663E70D1512O033O00537F2A03083O00583C104986C5757C0034012O001205012O00014O00B4000100013O002E3B000300020001000200042D012O00020001000ED40001000200013O00042D012O000200010012052O0100013O000ED40004004F0001000100042D012O004F0001001205010200013O0026430002000E0001000400042D012O000E0001002E09010500230001000600042D012O00230001002E9A000700080001000700042D012O001600012O006600035O0020FE0003000300082O000F0003000200020006510003001600013O00042D012O001600012O00B63O00014O0066000300014O0078000400023O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003002200013O00042D012O002200010012050103000C4O00E5000300033O0012050102000D3O0026E40002004A0001000100042D012O004A0001001205010300013O0026E4000300410001000100042D012O004100010012E20004000E4O004E000500023O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500023O00122O000600113O00122O000700126O0005000700024O0004000400054O000400043O00122O0004000E6O000500023O00122O000600133O00122O000700146O0005000700024O0004000400054O000500023O00122O000600153O00122O000700166O0005000700024O0004000400054O000400053O00122O000300043O002E9A001700E5FF2O001700042D012O00260001002E9A001800E3FF2O001800042D012O002600010026E4000300260001000400042D012O00260001001205010200043O00042D012O004A000100042D012O002600010026E40002000A0001000D00042D012O000A00010012052O01000D3O00042D012O004F000100042D012O000A0001002E9A001900040001001900042D012O00530001002643000100550001000D00042D012O00550001002E09011A00FC0001001B00042D012O00FC00012O0066000200043O0006BB0002005A0001000100042D012O005A0001002E3B001D00720001001C00042D012O00720001001205010200014O00B4000300033O002E09011E005C0001001F00042D012O005C00010026E40002005C0001000100042D012O005C0001001205010300013O002E3B002100610001002000042D012O006100010026E4000300610001000100042D012O006100012O006600045O0020F10004000400224O000600036O0004000600024O000400066O000400066O000400046O000400073O00044O0074000100042D012O0061000100042D012O0074000100042D012O005C000100042D012O00740001001205010200044O00E5000200074O0066000200093O0020EE00020002002300122O000400246O0002000400024O000200083O002E2O002500430001002500042D012O00BC00012O00660002000A3O0020080002000200262O00170102000100020006BB000200870001000100042D012O008700012O006600025O0020FE0002000200272O000F0002000200020006BB000200870001000100042D012O00870001002E3B002800BC0001002900042D012O00BC0001001205010200014O00B4000300033O002E3B002B00890001002A00042D012O00890001000ED4000100890001000200042D012O00890001001205010300013O002643000300920001000100042D012O00920001002E3B002D00A70001002C00042D012O00A70001001205010400013O000EAA000100970001000400042D012O00970001002E3B002F00A00001002E00042D012O00A000012O00660005000C3O00201C0105000500304O000600066O000700016O0005000700024O0005000B6O0005000B6O0005000D3O00122O000400043O002E3B003100930001003200042D012O009300010026E4000400930001000400042D012O00930001001205010300043O00042D012O00A7000100042D012O00930001002643000300AD0001000400042D012O00AD0001002E35003400AD0001003300042D012O00AD0001002E9A003500E3FF2O003600042D012O008E0001002E3B003800BC0001003700042D012O00BC00012O00660004000D3O0026E4000400BC0001003900042D012O00BC00012O00660004000C3O00203000040004003A4O000500066O00068O0004000600024O0004000D3O00044O00BC000100042D012O008E000100042D012O00BC000100042D012O00890001002E09013B00C30001003C00042D012O00C300012O006600025O0020FE00020002003D2O000F000200020002000651000200C500013O00042D012O00C50001002E3B003E00332O01003F00042D012O00332O01002E09014100E40001004000042D012O00E40001002E09014200E40001004300042D012O00E400012O006600025O0020FE0002000200272O000F000200020002000651000200E400013O00042D012O00E40001001205010200014O00B4000300033O0026E4000200D00001000100042D012O00D00001001205010300013O002643000300D70001000100042D012O00D70001002E09014500D30001004400042D012O00D300012O00660004000F4O00170104000100022O00E50004000E4O00660004000E3O000651000400332O013O00042D012O00332O012O00660004000E4O00FF000400023O00042D012O00332O0100042D012O00D3000100042D012O00332O0100042D012O00D0000100042D012O00332O01001205010200014O00B4000300033O002E09014600E60001004700042D012O00E600010026E4000200E60001000100042D012O00E60001001205010300013O002E09014900EB0001004800042D012O00EB00010026E4000300EB0001000100042D012O00EB00012O0066000400104O00170104000100022O00E50004000E4O00660004000E3O000651000400332O013O00042D012O00332O012O00660004000E4O00FF000400023O00042D012O00332O0100042D012O00EB000100042D012O00332O0100042D012O00E6000100042D012O00332O01002E3B004A00070001004B00042D012O00070001002643000100022O01000100042D012O00022O01002E09014D00070001004C00042D012O00070001001205010200013O002E09014E00092O01004F00042D012O00092O010026E4000200092O01000D00042D012O00092O010012052O0100043O00042D012O000700010026430002000D2O01000100042D012O000D2O01002E090150001C2O01005100042D012O001C2O01001205010300013O000ED4000100152O01000300042D012O00152O012O0066000400114O00310004000100012O0066000400124O0031000400010001001205010300043O002643000300192O01000400042D012O00192O01002E090152000E2O01005300042D012O000E2O01001205010200043O00042D012O001C2O0100042D012O000E2O01002643000200202O01000400042D012O00202O01002E3B005500032O01005400042D012O00032O012O0066000300134O006700030001000100122O0003000E6O000400023O00122O000500563O00122O000600576O0004000600024O0003000300044O000400023O00122O000500583O00122O000600596O0004000600024O0003000300044O000300143O00122O0002000D3O00044O00032O0100042D012O0007000100042D012O00332O0100042D012O000200012O00B63O00017O00033O0003053O005072696E74032B3O00033FBE580F48A43738A54E5D3FA73C6A8951467CEB6519B9515F70B7312FA8014D66E53D01AD4F4A6BAA6B03073O00C5454ACC212F1F00084O00B37O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

