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
				if (Enum <= 152) then
					if (Enum <= 75) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
										elseif (Enum == 2) then
											local A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
											end
										else
											Stk[Inst[2]] = Upvalues[Inst[3]];
										end
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = not Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 6) then
										do
											return;
										end
									elseif (Enum > 7) then
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
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum > 9) then
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
										end
									elseif (Enum <= 11) then
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
									elseif (Enum > 12) then
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
										local B;
										local A;
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
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
									end
								elseif (Enum <= 15) then
									if (Enum == 14) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
										Env[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum <= 16) then
									if (Inst[2] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 17) then
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
									if (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum == 19) then
											if (Stk[Inst[2]] < Inst[4]) then
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
										end
									elseif (Enum > 21) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
								elseif (Enum <= 24) then
									if (Enum > 23) then
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 25) then
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 26) then
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
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
								elseif (Enum <= 30) then
									if (Stk[Inst[2]] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 31) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 34) then
								if (Enum > 33) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 35) then
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
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 36) then
								local B;
								local A;
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
							else
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
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum == 38) then
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
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										else
											do
												return Stk[Inst[2]];
											end
										end
									elseif (Enum > 40) then
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
										if (Stk[Inst[2]] == Inst[4]) then
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
								elseif (Enum <= 43) then
									if (Enum == 42) then
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									else
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = #Stk[Inst[3]];
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
									end
								elseif (Enum <= 44) then
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
								elseif (Enum > 45) then
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum == 47) then
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
										if (Stk[Inst[2]] ~= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 49) then
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
								elseif (Enum > 50) then
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
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum <= 53) then
								if (Enum > 52) then
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
								end
							elseif (Enum <= 54) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum > 55) then
								Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum <= 65) then
							if (Enum <= 60) then
								if (Enum <= 58) then
									if (Enum > 57) then
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
										local A;
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
									end
								elseif (Enum > 59) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 62) then
								if (Enum > 61) then
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								else
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								end
							elseif (Enum <= 63) then
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
							elseif (Enum > 64) then
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
							else
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 70) then
							if (Enum <= 67) then
								if (Enum > 66) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								end
							elseif (Enum <= 68) then
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
									if (Mvm[1] == 56) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							elseif (Enum > 69) then
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
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum <= 72) then
							if (Enum == 71) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 73) then
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
						elseif (Enum > 74) then
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
					elseif (Enum <= 113) then
						if (Enum <= 94) then
							if (Enum <= 84) then
								if (Enum <= 79) then
									if (Enum <= 77) then
										if (Enum == 76) then
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
									elseif (Enum > 78) then
										local A;
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
										local A = Inst[2];
										Stk[A] = Stk[A]();
									end
								elseif (Enum <= 81) then
									if (Enum > 80) then
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
								elseif (Enum <= 82) then
									local A;
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
								elseif (Enum == 83) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								else
									local A;
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
							elseif (Enum <= 89) then
								if (Enum <= 86) then
									if (Enum > 85) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 87) then
									Stk[Inst[2]] = Inst[3] ~= 0;
								elseif (Enum == 88) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 91) then
								if (Enum == 90) then
									local A;
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
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								end
							elseif (Enum <= 92) then
								local A;
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 93) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							end
						elseif (Enum <= 103) then
							if (Enum <= 98) then
								if (Enum <= 96) then
									if (Enum == 95) then
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
								elseif (Enum == 97) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
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
							elseif (Enum <= 100) then
								if (Enum > 99) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 101) then
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
							elseif (Enum > 102) then
								local A;
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 108) then
							if (Enum <= 105) then
								if (Enum > 104) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								end
							elseif (Enum <= 106) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum > 107) then
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
						elseif (Enum <= 110) then
							if (Enum > 109) then
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
								Stk[Inst[2]]();
							end
						elseif (Enum <= 111) then
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
						elseif (Enum > 112) then
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 132) then
						if (Enum <= 122) then
							if (Enum <= 117) then
								if (Enum <= 115) then
									if (Enum == 114) then
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									end
								elseif (Enum == 116) then
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
								end
							elseif (Enum <= 119) then
								if (Enum == 118) then
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
								end
							elseif (Enum <= 120) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 121) then
								Env[Inst[3]] = Stk[Inst[2]];
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
						elseif (Enum <= 127) then
							if (Enum <= 124) then
								if (Enum > 123) then
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
							elseif (Enum <= 125) then
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							elseif (Enum == 126) then
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
								Stk[Inst[2]] = Inst[3];
							else
								local A;
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
						elseif (Enum <= 129) then
							if (Enum > 128) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 130) then
							local A;
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
						elseif (Enum > 131) then
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
							Stk[Inst[2]] = {};
						end
					elseif (Enum <= 142) then
						if (Enum <= 137) then
							if (Enum <= 134) then
								if (Enum > 133) then
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
								end
							elseif (Enum <= 135) then
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							elseif (Enum == 136) then
								local A;
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 139) then
							if (Enum > 138) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 140) then
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
						elseif (Enum == 141) then
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
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
						end
					elseif (Enum <= 147) then
						if (Enum <= 144) then
							if (Enum == 143) then
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
						elseif (Enum <= 145) then
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
						elseif (Enum > 146) then
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
						end
					elseif (Enum <= 149) then
						if (Enum > 148) then
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
							if (Stk[Inst[2]] == Inst[4]) then
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 150) then
						local B;
						local A;
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum == 151) then
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
						if (Inst[2] < Stk[Inst[4]]) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
				elseif (Enum <= 229) then
					if (Enum <= 190) then
						if (Enum <= 171) then
							if (Enum <= 161) then
								if (Enum <= 156) then
									if (Enum <= 154) then
										if (Enum > 153) then
											local A;
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
											Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
										end
									elseif (Enum == 155) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									else
										Stk[Inst[2]] = not Stk[Inst[3]];
									end
								elseif (Enum <= 158) then
									if (Enum == 157) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 159) then
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
								elseif (Enum > 160) then
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
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 166) then
								if (Enum <= 163) then
									if (Enum > 162) then
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
								elseif (Enum <= 164) then
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
								elseif (Enum == 165) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									if (Inst[2] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 168) then
								if (Enum == 167) then
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
							elseif (Enum <= 169) then
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
							elseif (Enum == 170) then
								local A;
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
							end
						elseif (Enum <= 180) then
							if (Enum <= 175) then
								if (Enum <= 173) then
									if (Enum == 172) then
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									else
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
									end
								elseif (Enum > 174) then
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 177) then
								if (Enum == 176) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 178) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							elseif (Enum == 179) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 185) then
							if (Enum <= 182) then
								if (Enum > 181) then
									local A;
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 183) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							elseif (Enum == 184) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 187) then
							if (Enum == 186) then
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
						elseif (Enum <= 188) then
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
							end
						elseif (Enum == 189) then
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
						end
					elseif (Enum <= 209) then
						if (Enum <= 199) then
							if (Enum <= 194) then
								if (Enum <= 192) then
									if (Enum > 191) then
										if (Inst[2] < Stk[Inst[4]]) then
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
								elseif (Enum > 193) then
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
							elseif (Enum <= 196) then
								if (Enum > 195) then
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
								end
							elseif (Enum <= 197) then
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 198) then
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum <= 204) then
							if (Enum <= 201) then
								if (Enum > 200) then
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
								end
							elseif (Enum <= 202) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 203) then
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
						elseif (Enum <= 206) then
							if (Enum > 205) then
								if (Inst[2] == Stk[Inst[4]]) then
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
						elseif (Enum <= 207) then
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						elseif (Enum == 208) then
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local Edx;
							local Results, Limit;
							local A;
							Stk[Inst[2]]();
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
							VIP = Inst[3];
						end
					elseif (Enum <= 219) then
						if (Enum <= 214) then
							if (Enum <= 211) then
								if (Enum == 210) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									local Edx = 0;
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
							elseif (Enum <= 212) then
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
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 213) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 216) then
							if (Enum == 215) then
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
						elseif (Enum <= 217) then
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
							if (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 218) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 224) then
						if (Enum <= 221) then
							if (Enum > 220) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							else
								local A;
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 222) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum > 223) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 226) then
						if (Enum == 225) then
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
						end
					elseif (Enum <= 227) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 228) then
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
					end
				elseif (Enum <= 267) then
					if (Enum <= 248) then
						if (Enum <= 238) then
							if (Enum <= 233) then
								if (Enum <= 231) then
									if (Enum == 230) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 232) then
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
							elseif (Enum <= 235) then
								if (Enum > 234) then
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
							elseif (Enum <= 236) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 237) then
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
						elseif (Enum <= 243) then
							if (Enum <= 240) then
								if (Enum == 239) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
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
							elseif (Enum <= 241) then
								local A;
								Stk[Inst[2]]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							elseif (Enum == 242) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
						elseif (Enum <= 245) then
							if (Enum > 244) then
								local B;
								local A;
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
							end
						elseif (Enum <= 246) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum == 247) then
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
							if (Inst[2] <= Stk[Inst[4]]) then
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
						end
					elseif (Enum <= 257) then
						if (Enum <= 252) then
							if (Enum <= 250) then
								if (Enum == 249) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 251) then
								if (Inst[2] <= Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 254) then
							if (Enum == 253) then
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 255) then
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
						elseif (Enum > 256) then
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
							if (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 262) then
						if (Enum <= 259) then
							if (Enum == 258) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 260) then
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
						elseif (Enum > 261) then
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
						end
					elseif (Enum <= 264) then
						if (Enum > 263) then
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
					elseif (Enum <= 265) then
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
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 266) then
						local B;
						local Edx;
						local Results, Limit;
						local A;
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
					else
						local B = Stk[Inst[4]];
						if B then
							VIP = VIP + 1;
						else
							Stk[Inst[2]] = B;
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 286) then
					if (Enum <= 276) then
						if (Enum <= 271) then
							if (Enum <= 269) then
								if (Enum > 268) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 270) then
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
						elseif (Enum <= 273) then
							if (Enum == 272) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 274) then
							local B;
							local Edx;
							local Results, Limit;
							local A;
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						elseif (Enum > 275) then
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
					elseif (Enum <= 281) then
						if (Enum <= 278) then
							if (Enum > 277) then
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 279) then
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
						elseif (Enum == 280) then
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
					elseif (Enum <= 283) then
						if (Enum == 282) then
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
						end
					elseif (Enum <= 284) then
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
					elseif (Enum == 285) then
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					else
						local A;
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
				elseif (Enum <= 296) then
					if (Enum <= 291) then
						if (Enum <= 288) then
							if (Enum == 287) then
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
							end
						elseif (Enum <= 289) then
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 290) then
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
					elseif (Enum <= 293) then
						if (Enum > 292) then
							local A;
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 294) then
						local B;
						local A;
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
					elseif (Enum == 295) then
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 301) then
					if (Enum <= 298) then
						if (Enum > 297) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
						end
					elseif (Enum <= 299) then
						local A;
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
					elseif (Enum > 300) then
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
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 303) then
					if (Enum > 302) then
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
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
					end
				elseif (Enum <= 304) then
					local A;
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
				elseif (Enum == 305) then
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
				elseif (Stk[Inst[2]] ~= Inst[4]) then
					VIP = VIP + 1;
				else
					VIP = Inst[3];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!343O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203043O00556E697403053O005574696C7303063O00506C6179657203063O0054617267657403053O005370652O6C03043O004974656D03043O004361737403053O005072652O7303053O004D6163726F03043O0042696E6403073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C030C3O004765744974656D436F756E7403043O004D61676503063O00417263616E6503103O005265676973746572466F724576656E7403243O00F0C5167101FDE1E7FDC71B7D05E7EDE7F4C50B791BF1E4F6E5CF0D7608FB2OF6FFC1077C03083O00B7B186423857B8BE030B3O00417263616E65426C61737403103O005265676973746572496E466C69676874030D3O00417263616E6542612O72616765026O00084003073O0048617354696572026O003D40026O001040030D3O00417263616E654861726D6F6E79030B3O004973417661696C61626C65025O006AD840025O006A0841024O0040770B41024O0080B3C54003143O00052O10309EBE0A0E142E9EA20A191F2899A0101803063O00EC555C5169DB03183O001120FEC496D91E29EEC89ADB0C29F1C98CC8092DF1DA96CF03063O008B416CBF9DD303063O0053657441504C026O004F402O00022O00129D3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004223O000A0001001245000300063O0020B2000400030007001245000500083O0020B2000500050009001245000600083O0020B200060006000A00064400073O000100062O00383O00064O00388O00383O00044O00383O00014O00383O00024O00383O00054O00260008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00202O000C000B000E00202O000D000B000F00202O000E000C001000202O000F000C001100202O0010000B001200202O0011000B00130012450012000D3O00202701130012001400202O00140012001500202O00150012001600202O00160012001700202O00170012001800202O00170017001900202O00170017001A00202O00180012001800202O00180018001900202O00180018001B0012450019001C4O0059001A001A6O001B8O001C8O001D8O001E8O001F8O0020005A3O00202O005B0010001D00202O005B005B001E00202O005C0011001D0020B2005C005C001E0020DF005D0015001D00202O005D005D001E4O005E5O00202O005F0012001800202O005F005F001900064400600001000100022O00383O005B4O00383O005F3O0020B70061000B001F00064400630002000100012O00383O00604O0012016400073O00122O006500203O00122O006600216O006400666O00613O000100202O0061005B002200202O0061006100234O00610002000100202O0061005B002400202O0061006100232O00360061000200012O00F5006100643O00122O006500256O00668O00678O00688O006900016O006A5O00202O006B000E002600122O006D00273O00122O006E00284O009B006B006E00022O0024006B006B6O006C00173O00202O006D005B002900202O006D006D002A4O006D000200024O006D006D6O006C0002000200102O006C002B006C4O006D00176O006E006B4O00F6006D000200020010B1006D002C006D4O006C006C006D00102O006C002D006C4O006D8O006E5O00122O006F00253O00122O0070002E3O00122O0071002E6O007200723O00202O0073000B001F00064400750003000100082O00383O00714O00383O006C4O00383O00174O00383O005B4O00383O006B4O00383O00704O00383O00664O00383O00694O0068007600073O00122O0077002F3O00122O007800306O007600786O00733O00010020B70073000B001F00064400750004000100042O00383O006E4O00383O006B4O00383O000E4O00383O006D4O0068007600073O00122O007700313O00122O007800326O007600786O00733O0001000644007300050001001A2O00383O005B4O00383O00384O00383O000E4O00383O003F4O00383O00144O00383O00074O00383O005C4O00383O00534O00383O00554O00383O005D4O00383O003E4O00383O00444O00383O003A4O00383O00414O00383O00394O00383O00404O00383O003D4O00383O005F4O00383O00454O00383O00524O00383O00544O00383O00564O00383O003B4O00383O00424O00383O003C4O00383O00433O00064400740006000100062O00383O005B4O00383O001F4O00383O005F4O00383O00144O00383O005D4O00383O00073O00064400750007000100042O00383O001A4O00383O005F4O00383O005E4O00383O001D3O00064400760008000100082O00383O005B4O00383O00594O00383O003E4O00383O00144O00383O00074O00383O00204O00383O000F4O00383O00283O000644007700090001000B2O00383O00644O00383O00654O00383O00624O00383O005B4O00383O000E4O00383O00724O00383O00674O00383O000F4O00383O00684O00383O00694O00383O006A3O0006440078000A0001001E2O00383O005B4O00383O002B4O00383O000E4O00383O000F4O00383O00724O00383O00144O00383O00074O00383O00204O00383O005D4O00383O00324O00383O00374O00383O001E4O00383O004D4O00383O00714O00383O00664O00383O00174O00383O002F4O00383O001D4O00383O00344O00383O00254O00383O00314O00383O00364O00383O002A4O00383O00694O00383O006C4O00383O00304O00383O00354O00383O002E4O00383O00334O00383O00213O0006440079000B000100182O00383O005B4O00383O002A4O00383O000F4O00383O00694O00383O000E4O00383O00144O00383O00074O00383O00254O00383O00724O00383O00204O00383O006C4O00383O005D4O00383O002E4O00383O00334O00383O001D4O00383O004D4O00383O00714O00383O006A4O00383O00214O00383O00324O00383O00374O00383O001E4O00383O00314O00383O00363O000644007A000C000100182O00383O005B4O00383O00214O00383O000F4O00383O00144O00383O00074O00383O00644O00383O00624O00383O000E4O00383O005D4O00383O00324O00383O00374O00383O001E4O00383O004D4O00383O00714O00383O00314O00383O00364O00383O00304O00383O00354O00383O002A4O00383O002E4O00383O00334O00383O001D4O00383O002B4O00383O00203O000644007B000D000100132O00383O000F4O00383O005B4O00383O00664O00383O00184O00383O00174O00383O002A4O00383O000E4O00383O00144O00383O00074O00383O00304O00383O00354O00383O001E4O00383O00254O00383O00204O00383O00214O00383O002B4O00383O00724O00383O005C4O00383O005D3O000644007C000E000100122O00383O005B4O00383O00214O00383O00644O00383O00624O00383O000E4O00383O00144O00383O000F4O00383O00074O00383O00304O00383O00354O00383O001E4O00383O004D4O00383O00714O00383O00224O00383O00664O00383O00184O00383O00174O00383O00253O000644007D000F000100172O00383O005B4O00383O00214O00383O000E4O00383O00664O00383O00714O00383O00144O00383O000F4O00383O00074O00383O005D4O00383O00254O00383O006B4O00383O00694O00383O00204O00383O00304O00383O00354O00383O001E4O00383O004D4O00383O002F4O00383O001D4O00383O00344O00383O002B4O00383O006F4O00383O002A3O000644007E0010000100132O00383O005B4O00383O00254O00383O000E4O00383O00144O00383O000F4O00383O00074O00383O00214O00383O00644O00383O00624O00383O00304O00383O00354O00383O001E4O00383O004D4O00383O00714O00383O00224O00383O002F4O00383O001D4O00383O00344O00383O002A3O000644007F0011000100232O00383O005B4O00383O00324O00383O00374O00383O001E4O00383O004D4O00383O00714O00383O000E4O00383O00144O00383O00074O00383O005D4O00383O00214O00383O000F4O00383O00284O00383O00694O00383O00264O00383O005C4O00383O00294O00383O001D4O00383O00674O00383O001A4O00383O007A4O00383O006B4O00383O00684O00383O00794O00383O00644O00383O00654O00383O00624O00383O007C4O00383O006A4O00383O00724O00383O00174O00383O00784O00383O007B4O00383O007E4O00383O007D3O000644008000120001002B2O00383O00204O00383O00074O00383O00214O00383O00224O00383O00234O00383O00384O00383O00394O00383O003A4O00383O003B4O00383O00594O00383O005A4O00383O00294O00383O002A4O00383O002B4O00383O002C4O00383O003C4O00383O003D4O00383O003E4O00383O003F4O00383O00344O00383O00354O00383O00364O00383O00374O00383O00304O00383O00314O00383O00324O00383O00334O00383O00444O00383O00454O00383O00574O00383O00584O00383O00404O00383O00414O00383O00424O00383O00434O00383O002D4O00383O00274O00383O002E4O00383O002F4O00383O00244O00383O00254O00383O00264O00383O00283O00064400810013000100122O00383O00504O00383O00074O00383O00514O00383O00534O00383O00524O00383O00554O00383O00544O00383O00564O00383O00484O00383O004D4O00383O004A4O00383O004B4O00383O004C4O00383O00474O00383O00464O00383O004F4O00383O004E4O00383O00493O000644008200140001002C2O00383O001C4O00383O00074O00383O001D4O00383O001E4O00383O00804O00383O00814O00383O001B4O00383O005F4O00383O000E4O00383O00714O00383O00704O00383O000B4O00383O00474O00383O001A4O00383O005B4O00383O001F4O00383O005D4O00383O00724O00383O00484O00383O005A4O00383O00634O00383O000F4O00383O00244O00383O00144O00383O00234O00383O00264O00383O00734O00383O00744O00383O00764O00383O00494O00383O00574O00383O00464O00383O004D4O00383O004F4O00383O00504O00383O00754O00383O00774O00383O007F4O00383O00584O00383O004E4O00383O00514O00383O00644O00383O00624O00383O00613O00064400830015000100032O00383O00604O00383O00124O00383O00073O00206E00840012003300122O008500346O008600826O008700836O0084008700016O00013O00163O00023O00026O00F03F026O00704002264O00A900025O00122O000300016O00045O00122O000500013O00042O0003002100012O000300076O0033000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0003000C00034O008E000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0061000C6O00A0000A3O0002002099000A000A00022O00D20009000A4O006A00073O00010004AB0003000500012O0003000300054O0038000400024O005B000300044O00BC00036O00063O00017O00043O00030B3O0052656D6F76654375727365030B3O004973417661696C61626C6503123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O6673000B4O00287O00206O000100206O00026O0002000200064O000A00013O0004223O000A00012O00033O00014O0003000100013O0020B20001000100040010873O000300012O00063O00019O003O00034O00038O006D3O000100012O00063O00017O00093O00028O00027O0040024O0080B3C540026O00F03F030D3O00417263616E654861726D6F6E79030B3O004973417661696C61626C65025O006AD840025O006A0841024O0040770B4100243O00126C3O00013O00261A3O0006000100020004223O0006000100126C000100034O00CA00015O0004223O0023000100261A3O001B000100040004223O001B00012O0003000100024O00B9000200033O00202O00020002000500202O0002000200064O0002000200024O000200026O00010002000200102O0001000700014O000200026O000300046O000300034O00F600020002000200103C0002000800024O00010001000200102O0001000900014O000100013O00122O000100036O000100053O00124O00023O00261A3O0001000100010004223O000100012O005700016O0090000100066O000100016O000100073O00124O00043O00044O000100012O00063O00017O00053O00028O00026O00F03F03073O0048617354696572026O003D40026O00104000143O00126C3O00013O000ECE0002000600013O0004223O000600012O005700016O00CA00015O0004223O0013000100261A3O0001000100010004223O000100012O0003000100023O0020DA00010001000300122O000300043O00122O000400056O0001000400024O000100016O000100016O00018O000100033O00124O00023O00044O000100012O00063O00017O002D3O00028O00026O00084003093O00416C74657254696D6503073O004973526561647903103O004865616C746850657263656E7461676503163O007D2F2E406E1C2E4C71267A4179253F4B6F2A2C403C7503043O00251C435A030B3O004865616C746873746F6E6503153O00FC19481B6C8F0CE013471238831AF219470471911A03073O007F947C297718E7026O001040027O0040030B3O004D692O726F72496D616765030A3O0049734361737461626C6503183O001C8B3FB7D803BD24A8D616876DA1D2178723B6DE07876DF103053O00B771E24DC503133O0047726561746572496E7669736962696C69747903203O00474BB0DD545CA7E34957A3D55350B7D54C50A1C5005DB0DA4557A6D5565CF58903043O00BC2039D503103O00507269736D6174696342612O7269657203083O0042752O66446F776E03173O00FD03486414F5125F5213E640495E10F10E5E5200F1401C03053O007694602D3B030B3O004D612O7342612O72696572031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503183O005BB3E3038B54B3E202BD53A0B014B150B7FE03BD40B7B04203053O00D436D29070026O00F03F03193O00B98328918E95268A85816EAB8E87228A85816EB38492278C8503043O00E3EBE64E03173O0052656672657368696E674865616C696E67506F74696F6E03233O0049B62E1DF9C3411655B46807F9D1451655B4681FF3C4401055F32C0AFAD5470C52A52D03083O007F3BD3486F9CB029031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O0083F143414390E24A2O4B95F006484B86EF4F4E49C7F349544788ED06444B81E648534791E603053O002EE783262003083O00496365426C6F636B03153O00BFB25F71153DA757BDF15E4B1134A647BFA75F0E4403083O0034D6D13A2E7751C8030D3O00496365436F6C6454616C656E74030B3O004973417661696C61626C65030E3O00496365436F6C644162696C69747903143O004CCF33148FBF49C8762F89B640C225229AB5059F03063O00D025AC564BEC0031012O00126C3O00013O00261A3O0038000100020004223O003800012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01001D00013O0004223O001D00012O0003000100013O00062C2O01001D00013O0004223O001D00012O0003000100023O0020B70001000100052O00F60001000200022O0003000200033O0006112O01001D000100020004223O001D00012O0003000100044O000300025O0020B20002000200032O00F600010002000200062C2O01001D00013O0004223O001D00012O0003000100053O00126C000200063O00126C000300074O005B000100034O00BC00016O0003000100063O0020B20001000100080020B70001000100042O00F600010002000200062C2O01003700013O0004223O003700012O0003000100073O00062C2O01003700013O0004223O003700012O0003000100023O0020B70001000100052O00F60001000200022O0003000200083O0006112O010037000100020004223O003700012O0003000100044O0003000200093O0020B20002000200082O00F600010002000200062C2O01003700013O0004223O003700012O0003000100053O00126C000200093O00126C0003000A4O005B000100034O00BC00015O00126C3O000B3O00261A3O006F0001000C0004223O006F00012O000300015O0020B200010001000D0020B700010001000E2O00F600010002000200062C2O01005400013O0004223O005400012O00030001000A3O00062C2O01005400013O0004223O005400012O0003000100023O0020B70001000100052O00F60001000200022O00030002000B3O0006112O010054000100020004223O005400012O0003000100044O000300025O0020B200020002000D2O00F600010002000200062C2O01005400013O0004223O005400012O0003000100053O00126C0002000F3O00126C000300104O005B000100034O00BC00016O000300015O0020B20001000100110020B70001000100042O00F600010002000200062C2O01006E00013O0004223O006E00012O00030001000C3O00062C2O01006E00013O0004223O006E00012O0003000100023O0020B70001000100052O00F60001000200022O00030002000D3O0006112O01006E000100020004223O006E00012O0003000100044O000300025O0020B20002000200112O00F600010002000200062C2O01006E00013O0004223O006E00012O0003000100053O00126C000200123O00126C000300134O005B000100034O00BC00015O00126C3O00023O00261A3O00B5000100010004223O00B500012O000300015O0020B20001000100140020B700010001000E2O00F600010002000200062C2O01009200013O0004223O009200012O00030001000E3O00062C2O01009200013O0004223O009200012O0003000100023O00202E0001000100154O00035O00202O0003000300144O00010003000200062O0001009200013O0004223O009200012O0003000100023O0020B70001000100052O00F60001000200022O00030002000F3O0006112O010092000100020004223O009200012O0003000100044O000300025O0020B20002000200142O00F600010002000200062C2O01009200013O0004223O009200012O0003000100053O00126C000200163O00126C000300174O005B000100034O00BC00016O000300015O0020B20001000100180020B700010001000E2O00F600010002000200062C2O0100B400013O0004223O00B400012O0003000100103O00062C2O0100B400013O0004223O00B400012O0003000100023O00202E0001000100154O00035O00202O0003000300144O00010003000200062O000100B400013O0004223O00B400012O0003000100113O0020400001000100194O000200123O00122O0003000C6O00010003000200062O000100B400013O0004223O00B400012O0003000100044O000300025O0020B20002000200182O00F600010002000200062C2O0100B400013O0004223O00B400012O0003000100053O00126C0002001A3O00126C0003001B4O005B000100034O00BC00015O00126C3O001C3O000ECE000B00F200013O0004223O00F200012O0003000100133O00062C2O0100302O013O0004223O00302O012O0003000100023O0020B70001000100052O00F60001000200022O0003000200143O0006112O0100302O0100020004223O00302O0100126C000100013O00261A000100C1000100010004223O00C100012O0003000200154O0011000300053O00122O0004001D3O00122O0005001E6O00030005000200062O000200DB000100030004223O00DB00012O0003000200063O0020B200020002001F0020B70002000200042O00F600020002000200062C010200DB00013O0004223O00DB00012O0003000200044O0003000300093O0020B200030003001F2O00F600020002000200062C010200DB00013O0004223O00DB00012O0003000200053O00126C000300203O00126C000400214O005B000200044O00BC00026O0003000200153O00261A000200302O0100220004223O00302O012O0003000200063O0020B20002000200230020B70002000200042O00F600020002000200062C010200302O013O0004223O00302O012O0003000200044O0003000300093O0020B200030003001F2O00F600020002000200062C010200302O013O0004223O00302O012O0003000200053O001262000300243O00122O000400256O000200046O00025O00044O00302O010004223O00C100010004223O00302O0100261A3O00010001001C0004223O000100012O000300015O0020B20001000100260020B700010001000E2O00F600010002000200062C2O01000E2O013O0004223O000E2O012O0003000100163O00062C2O01000E2O013O0004223O000E2O012O0003000100023O0020B70001000100052O00F60001000200022O0003000200173O0006112O01000E2O0100020004223O000E2O012O0003000100044O000300025O0020B20002000200262O00F600010002000200062C2O01000E2O013O0004223O000E2O012O0003000100053O00126C000200273O00126C000300284O005B000100034O00BC00016O000300015O0020B20001000100290020B700010001002A2O00F600010002000200062C2O01002E2O013O0004223O002E2O012O000300015O0020B200010001002B0020B700010001000E2O00F600010002000200062C2O01002E2O013O0004223O002E2O012O0003000100183O00062C2O01002E2O013O0004223O002E2O012O0003000100023O0020B70001000100052O00F60001000200022O0003000200193O0006112O01002E2O0100020004223O002E2O012O0003000100044O000300025O0020B200020002002B2O00F600010002000200062C2O01002E2O013O0004223O002E2O012O0003000100053O00126C0002002C3O00126C0003002D4O005B000100034O00BC00015O00126C3O000C3O0004223O000100012O00063O00017O00073O00030B3O0052656D6F7665437572736503073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00344003103O0052656D6F76654375727365466F63757303133O00BBB8E284BAAC82EC9EBEBAB8AF8FA5BAADEA8703053O00CCC9DD8FEB001B4O00287O00206O000100206O00026O0002000200064O001A00013O0004223O001A00012O00033O00013O00062C012O001A00013O0004223O001A00012O00033O00023O0020B25O000300126C000100044O00F63O0002000200062C012O001A00013O0004223O001A00012O00033O00034O0003000100043O0020B20001000100052O00F63O0002000200062C012O001A00013O0004223O001A00012O00033O00053O00126C000100063O00126C000200074O005B3O00024O00BC8O00063O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O00126C3O00013O00261A3O0011000100020004223O001100012O0003000100013O0020E30001000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O0004223O002200012O000300016O0027000100023O0004223O00220001000ECE0001000100013O0004223O000100012O0003000100013O0020E30001000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O0004223O002000012O000300016O0027000100023O00126C3O00023O0004223O000100012O00063O00017O00103O00028O00030B3O004D692O726F72496D616765030A3O0049734361737461626C6503183O007A8CEC537897C1487A84F9443795EC44748AF3437691BE1303043O002117E59E030B3O00417263616E65426C61737403073O0049735265616479030B3O00536970686F6E53746F726D030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503183O0051A8C2BA5EBFFEB95CBBD2AF10AAD3BE53B5CCB951AE81EF03043O00DB30DAA1026O00F03F03093O0045766F636174696F6E03153O00E167734ADA5BE9EB7F3C59C94AE3EB7C7E48CF0FB603073O008084111C29BB2F005A3O00126C3O00013O00261A3O003B000100010004223O003B00012O000300015O0020B20001000100020020B70001000100032O00F600010002000200062C2O01001A00013O0004223O001A00012O0003000100013O00062C2O01001A00013O0004223O001A00012O0003000100023O00062C2O01001A00013O0004223O001A00012O0003000100034O000300025O0020B20002000200022O00F600010002000200062C2O01001A00013O0004223O001A00012O0003000100043O00126C000200043O00126C000300054O005B000100034O00BC00016O000300015O0020B20001000100060020B70001000100072O00F600010002000200062C2O01003A00013O0004223O003A00012O0003000100053O00062C2O01003A00013O0004223O003A00012O000300015O0020B20001000100080020B70001000100092O00F60001000200020006300001003A000100010004223O003A00012O0003000100034O001400025O00202O0002000200064O000300063O00202O00030003000A4O00055O00202O0005000500064O0003000500024O000300036O00010003000200062O0001003A00013O0004223O003A00012O0003000100043O00126C0002000B3O00126C0003000C4O005B000100034O00BC00015O00126C3O000D3O00261A3O00010001000D0004223O000100012O000300015O0020B200010001000E0020B70001000100072O00F600010002000200062C2O01005900013O0004223O005900012O0003000100073O00062C2O01005900013O0004223O005900012O000300015O0020B20001000100080020B70001000100092O00F600010002000200062C2O01005900013O0004223O005900012O0003000100034O000300025O0020B200020002000E2O00F600010002000200062C2O01005900013O0004223O005900012O0003000100043O0012620002000F3O00122O000300106O000100036O00015O00044O005900010004223O000100012O00063O00017O00153O00028O0003093O00417263616E654F726203073O0043686172676573030D3O00417263616E6543686172676573026O000840030C3O0052616469616E74537061726B030A3O00432O6F6C646F776E5570030E3O00546F7563686F667468654D616769030F3O00432O6F6C646F776E52656D61696E73027O0040030A3O00446562752O66446F776E03193O0052616469616E74537061726B56756C6E65726162696C697479030D3O00446562752O6652656D61696E7303123O0052616469616E74537061726B446562752O66026O001C40030C3O00432O6F6C646F776E446F776E026O00F03F03083O00446562752O66557003143O00546F7563686F667468654D616769446562752O66030B3O00417263616E65426C61737403083O004361737454696D6500983O00126C3O00013O00261A3O0078000100010004223O007800012O000300016O0003000200013O00063200020005000100010004223O000B00012O0003000100024O0003000200013O00061101020027000100010004223O002700012O0003000100033O0020B20001000100020020B70001000100032O00F6000100020002000EC500010016000100010004223O001600012O0003000100043O0020B70001000100042O00F6000100020002000EFB00050027000100010004223O002700012O0003000100033O0020B20001000100060020B70001000100072O00F600010002000200062C2O01002700013O0004223O002700012O0003000100033O00208D00010001000800202O0001000100094O0001000200024O000200053O00202O00020002000A00062O00010027000100020004223O002700012O0057000100014O00CA000100063O0004223O004000012O0003000100063O00062C2O01004000013O0004223O004000012O0003000100073O00202E00010001000B4O000300033O00202O00030003000C4O00010003000200062O0001004000013O0004223O004000012O0003000100073O00201900010001000D4O000300033O00202O00030003000E4O00010003000200262O000100400001000F0004223O004000012O0003000100033O0020B20001000100060020B70001000100102O00F600010002000200062C2O01004000013O0004223O004000012O005700016O00CA000100064O0003000100043O0020B70001000100042O00F6000100020002000EC00005005E000100010004223O005E00012O000300016O0003000200013O00068A0001005E000100020004223O005E00012O0003000100024O0003000200013O00068A0001005E000100020004223O005E00012O0003000100033O0020B20001000100060020B70001000100072O00F600010002000200062C2O01005E00013O0004223O005E00012O0003000100033O00208D00010001000800202O0001000100094O0001000200024O000200053O00202O00020002000F00062O0001005E000100020004223O005E00012O0057000100014O00CA000100083O0004223O007700012O0003000100083O00062C2O01007700013O0004223O007700012O0003000100073O00202E00010001000B4O000300033O00202O00030003000C4O00010003000200062O0001007700013O0004223O007700012O0003000100073O00201900010001000D4O000300033O00202O00030003000E4O00010003000200262O000100770001000F0004223O007700012O0003000100033O0020B20001000100060020B70001000100102O00F600010002000200062C2O01007700013O0004223O007700012O005700016O00CA000100083O00126C3O00113O00261A3O0001000100110004223O000100012O0003000100073O00202E0001000100124O000300033O00202O0003000300134O00010003000200062O0001009700013O0004223O009700012O0003000100093O00062C2O01009700013O0004223O0097000100126C000100013O00261A00010085000100010004223O008500012O005700026O0089000200096O000200033O00202O00020002001400202O0002000200154O0002000200024O000300053O00062O00020091000100030004223O009100012O00AD00026O0057000200014O00CA0002000A3O0004223O009700010004223O008500010004223O009700010004223O000100012O00063O00017O00613O00028O00026O001440030E3O0050726573656E63656F664D696E64030A3O0049734361737461626C65030C3O0049734368612O6E656C696E67030D3O00446562752O6652656D61696E7303143O00546F7563686F667468654D616769446562752O6603223O0011200329580F31030552070D0B335305720535520D36092D533E220E3B4E0472556A03053O003D6152665A030B3O00417263616E65426C61737403073O004973526561647903063O0042752O66557003123O0050726573656E63656F664D696E6442752O66030E3O0049735370652O6C496E52616E6765031E3O00AD3CA84AC952210BA02FB85F87541106A02AA45CC9680E01AD3DAE0B940503083O0069CC4ECB2BA7377E030E3O00417263616E654D692O73696C6573030A3O0047434452656D61696E73030E3O004D616E6150657263656E74616765026O003E4003133O004E6574686572507265636973696F6E42752O66030B3O0053746F7043617374696E6703283O00A6AB2D1D16088750B7A92210163BCA58B6B92A1216178752AAA52F1A1C13C96EB5A2220D1644940503083O0031C5CA437E7364A7026O001840030E3O00546F7563686F667468654D61676903083O005072657647434450026O00F03F030D3O00417263616E6542612O7261676503223O002354CA2A8869513164CB21856953365CD6698359513B5FD03E8E694E3F5ACC2CC00403073O003E573BBF49E036030C3O0052616469616E74537061726B030A3O00432O6F6C646F776E5570030B3O00417263616E655375726765030F3O00432O6F6C646F776E52656D61696E73026O002440030D3O005368696674696E67506F77657203083O0042752O66446F776E030F3O00417263616E65537572676542752O66030B3O004973417661696C61626C6503093O004973496E52616E6765026O004440031F3O00F40AF3CFF30BF4CED812F5DEE210BACAE80DF6CDE815F4F6F70AFBDAE242AE03043O00A987629A026O00084003103O00436C65617263617374696E6742752O66030F3O004E6574686572507265636973696F6E030B3O0042752O6652656D61696E7303073O0048617354696572026O00104003213O00CA652755F336F7C67E3747F43FCDD837275BF23FCCC4602A6BED3BC9D8726405A503073O00A8AB1744349D53031F3O00E670F1A4242393CB62E5AC3726C7F77EFAA1212290FA4EE5A5243E82B423A503073O00E7941195CD454D030D3O004E657468657254656D7065737403113O0054696D6553696E63654C61737443617374030A3O00417263616E654563686F03203O008EA2D3F352EDBFB3C2F647FA93B387F858F08CA3C8EC59C090AFC6E852BFD2F503063O009FE0C7A79B37027O0040030B3O00426C2O6F646C757374557003043O004D616E61030F3O00536970686F6E53746F726D42752O66026O003140031E3O00F6E13FD3F9F603D0FBF22FC6B7F033DDFBF733C5F9CC2CDAF6E03992A6A103043O00B297935C03093O0042752O66537461636B03133O00417263616E65417274692O6C65727942752O6603213O008DEF4F331C494581F45F211B407F9FBD4F3D1D407E83EA420D02447B9FF80C634603073O001AEC9D2C52722C030D3O00417263616E654861726D6F6E7903113O00417263616E654861726D6F6E7942752O66026O002E4003213O002B3CD65A242BEA56233DC652262BC61B2921DA572E21C255153EDD5A392B950A7C03043O003B4A4EB503213O0024C3595BBD20EE5753A036D8565FA065D22O55BF21DE4D548C35D95B49B665820C03053O00D345B12O3A031E3O00B6F77AF4E7CE88E775F4FADFF7E676FAE5CFB8F277CAF9C3B6F67CB5BA9303063O00ABD78519958903093O00417263616E654F7262030D3O00417263616E654368617267657303103O00417263616E65436861726765734D6178031B3O00E0DA31FBE135C34DF3CA72F9E03FF046EEDF3CC5FF38FD51E4886403083O002281A8529A8F509C031D3O0084A0300A464BB687BE32185C0E2O8ABD3F0F475987BAA23B0A5B4BC9DD03073O00E9E5D2536B282E026O003F4003213O00C05031D70BC47D3FDF16D24B3ED31681413DD909C54D25D83AD14A33C50081136203053O0065A12252B6031E3O00E91F5AFFD5E7BD3DFD1F5EFB9BE18D21E40956E9D5DD9226E91E5CBE89B603083O004E886D399EBB82E203203O003F2DFAF0303AC6F33F2DEBF0393AB9F231302OF53128F7CE2E37F8E23B7FABA703043O00915E5F99030B3O00446562752O66537461636B03193O0052616469616E74537061726B56756C6E65726162696C697479031E3O00FCDF17D440B2C2CF18D45DA3BDCE1BDA42B3F2DA1AEA5EBFFCDE11951CEF03063O00D79DAD74B52E00CB032O00126C3O00013O00261A3O0069000100020004223O006900012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01002400013O0004223O002400012O0003000100013O00062C2O01002400013O0004223O002400012O0003000100023O0020B70001000100052O00F600010002000200063000010024000100010004223O002400012O0003000100033O0020142O01000100064O00035O00202O0003000300074O0001000300024O000200043O00062O00010024000100020004223O002400012O0003000100054O000300025O0020B20002000200032O00F600010002000200062C2O01002400013O0004223O002400012O0003000100063O00126C000200083O00126C000300094O005B000100034O00BC00016O000300015O0020B200010001000A0020B700010001000B2O00F600010002000200062C2O01004500013O0004223O004500012O0003000100073O00062C2O01004500013O0004223O004500012O0003000100023O00202E00010001000C4O00035O00202O00030003000D4O00010003000200062O0001004500013O0004223O004500012O0003000100054O001400025O00202O00020002000A4O000300033O00202O00030003000E4O00055O00202O00050005000A4O0003000500024O000300036O00010003000200062O0001004500013O0004223O004500012O0003000100063O00126C0002000F3O00126C000300104O005B000100034O00BC00016O0003000100023O00202E0001000100054O00035O00202O0003000300114O00010003000200062O0001006800013O0004223O006800012O0003000100023O0020B70001000100122O00F600010002000200261A00010068000100010004223O006800012O0003000100023O0020B70001000100132O00F6000100020002000EC000140068000100010004223O006800012O0003000100023O00202E00010001000C4O00035O00202O0003000300154O00010003000200062O0001006800013O0004223O006800012O0003000100054O0003000200083O0020B20002000200162O00F600010002000200062C2O01006800013O0004223O006800012O0003000100063O00126C000200173O00126C000300184O005B000100034O00BC00015O00126C3O00193O00261A3O00DA000100010004223O00DA00012O000300015O0020B200010001001A0020B700010001000B2O00F600010002000200062C2O01009400013O0004223O009400012O0003000100093O00062C2O01009400013O0004223O009400012O00030001000A3O00062C2O01007A00013O0004223O007A00012O00030001000B3O0006300001007D000100010004223O007D00012O00030001000A3O00063000010094000100010004223O009400012O00030001000C4O00030002000D3O00068A00010094000100020004223O009400012O0003000100023O0020FC00010001001B00122O0003001C6O00045O00202O00040004001D4O00010004000200062O0001009400013O0004223O009400012O0003000100054O000300025O0020B200020002001A2O00F600010002000200062C2O01009400013O0004223O009400012O0003000100063O00126C0002001E3O00126C0003001F4O005B000100034O00BC00016O000300015O0020B20001000100200020B70001000100212O00F600010002000200062C2O0100A500013O0004223O00A500012O00030001000F4O00F900025O00202O00020002002200202O0002000200234O00020002000200262O000200A2000100240004223O00A200012O00AD00026O0057000200014O00F60001000200022O00CA0001000E4O000300015O0020B20001000100250020B700010001000B2O00F600010002000200062C2O0100D900013O0004223O00D900012O0003000100103O00062C2O0100D900013O0004223O00D900012O0003000100113O00062C2O0100B400013O0004223O00B400012O0003000100123O000630000100B7000100010004223O00B700012O0003000100123O000630000100D9000100010004223O00D900012O00030001000C4O00030002000D3O00068A000100D9000100020004223O00D900012O0003000100023O00202E0001000100264O00035O00202O0003000300274O00010003000200062O000100D900013O0004223O00D900012O000300015O0020B20001000100200020B70001000100282O00F6000100020002000630000100D9000100010004223O00D900012O0003000100054O00A300025O00202O0002000200254O000300033O00202O00030003002900122O0005002A6O0003000500024O000300036O000400016O00010004000200062O000100D900013O0004223O00D900012O0003000100063O00126C0002002B3O00126C0003002C4O005B000100034O00BC00015O00126C3O001C3O00261A3O006E2O01002D0004223O006E2O012O000300015O0020B20001000100110020B700010001000B2O00F600010002000200062C2O01001F2O013O0004223O001F2O012O0003000100133O00062C2O01001F2O013O0004223O001F2O012O000300015O0020B20001000100200020B70001000100212O00F600010002000200062C2O01001F2O013O0004223O001F2O012O0003000100023O00202E00010001000C4O00035O00202O00030003002E4O00010003000200062O0001001F2O013O0004223O001F2O012O000300015O0020B200010001002F0020B70001000100282O00F600010002000200062C2O01001F2O013O0004223O001F2O012O0003000100023O00202O0001000100264O00035O00202O0003000300154O00010003000200062O000100072O0100010004223O00072O012O0003000100023O0020BD0001000100304O00035O00202O0003000300154O0001000300024O000200043O00062O0001001F2O0100020004223O001F2O012O0003000100023O00209200010001003100122O000300143O00122O000400326O00010004000200062O0001001F2O013O0004223O001F2O012O0003000100054O001400025O00202O0002000200114O000300033O00202O00030003000E4O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001001F2O013O0004223O001F2O012O0003000100063O00126C000200333O00126C000300344O005B000100034O00BC00016O000300015O0020B20001000100200020B700010001000B2O00F600010002000200062C2O0100472O013O0004223O00472O012O0003000100143O00062C2O0100472O013O0004223O00472O012O0003000100153O00062C2O01002E2O013O0004223O002E2O012O00030001000B3O000630000100312O0100010004223O00312O012O0003000100153O000630000100472O0100010004223O00472O012O00030001000C4O00030002000D3O00068A000100472O0100020004223O00472O012O0003000100054O00E000025O00202O0002000200204O000300033O00202O00030003000E4O00055O00202O0005000500204O0003000500024O000300036O000400016O00010004000200062O000100472O013O0004223O00472O012O0003000100063O00126C000200353O00126C000300364O005B000100034O00BC00016O000300015O0020B20001000100370020B700010001000B2O00F600010002000200062C2O01006D2O013O0004223O006D2O012O0003000100163O00062C2O01006D2O013O0004223O006D2O012O000300015O0020B20001000100370020B70001000100382O00F6000100020002000EFB0014006D2O0100010004223O006D2O012O000300015O0020B20001000100390020B70001000100282O00F600010002000200062C2O01006D2O013O0004223O006D2O012O0003000100054O001400025O00202O0002000200374O000300033O00202O00030003000E4O00055O00202O0005000500374O0003000500024O000300036O00010003000200062O0001006D2O013O0004223O006D2O012O0003000100063O00126C0002003A3O00126C0003003B4O005B000100034O00BC00015O00126C3O00323O00261A3O00440201003C0004223O004402012O000300015O0020B200010001000A0020B700010001000B2O00F600010002000200062C2O0100AD2O013O0004223O00AD2O012O0003000100073O00062C2O0100AD2O013O0004223O00AD2O012O0003000100173O00062C2O0100AD2O013O0004223O00AD2O012O000300015O0020B20001000100220020B70001000100212O00F600010002000200062C2O0100AD2O013O0004223O00AD2O012O0003000100023O0020B700010001003D2O00F600010002000200062C2O0100AD2O013O0004223O00AD2O012O0003000100023O0020B700010001003E2O00F60001000200022O0003000200183O000611010200AD2O0100010004223O00AD2O012O0003000100023O0020282O01000100304O00035O00202O00030003003F4O000100030002000E2O004000AD2O0100010004223O00AD2O012O0003000100023O0020D700010001003100122O000300143O00122O000400326O00010004000200062O000100AD2O0100010004223O00AD2O012O0003000100054O00E000025O00202O00020002000A4O000300033O00202O00030003000E4O00055O00202O00050005000A4O0003000500024O000300036O000400016O00010004000200062O000100AD2O013O0004223O00AD2O012O0003000100063O00126C000200413O00126C000300424O005B000100034O00BC00016O000300015O0020B20001000100110020B700010001000B2O00F600010002000200062C2O01000102013O0004223O000102012O0003000100133O00062C2O01000102013O0004223O000102012O0003000100173O00062C2O01000102013O0004223O000102012O0003000100023O0020B700010001003D2O00F600010002000200062C2O01000102013O0004223O000102012O0003000100023O00202E00010001000C4O00035O00202O00030003002E4O00010003000200062O0001000102013O0004223O000102012O0003000100023O0020A60001000100434O00035O00202O00030003002E4O000100030002000E2O003C0001020100010004223O000102012O000300015O0020B20001000100200020B70001000100232O00F600010002000200261300010001020100020004223O000102012O0003000100023O00202E0001000100264O00035O00202O0003000300154O00010003000200062O0001000102013O0004223O000102012O0003000100023O00202O0001000100264O00035O00202O0003000300444O00010003000200062O000100E92O0100010004223O00E92O012O0003000100023O00200E0001000100304O00035O00202O0003000300444O0001000300024O000200043O00202O00020002001900062O00010001020100020004223O000102012O0003000100023O0020D700010001003100122O000300143O00122O000400326O00010004000200062O00010001020100010004223O000102012O0003000100054O001400025O00202O0002000200114O000300033O00202O00030003000E4O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001000102013O0004223O000102012O0003000100063O00126C000200453O00126C000300464O005B000100034O00BC00016O000300015O0020B20001000100110020B700010001000B2O00F600010002000200062C2O01004302013O0004223O004302012O0003000100133O00062C2O01004302013O0004223O004302012O000300015O0020B20001000100470020B70001000100282O00F600010002000200062C2O01004302013O0004223O004302012O0003000100023O0020190001000100434O00035O00202O0003000300484O00010003000200262O00010043020100490004223O004302012O0003000100173O00062C2O01001F02013O0004223O001F02012O0003000100023O0020B700010001003D2O00F60001000200020006300001002C020100010004223O002C02012O0003000100023O00202E00010001000C4O00035O00202O00030003002E4O00010003000200062O0001004302013O0004223O004302012O000300015O0020B20001000100200020B70001000100232O00F600010002000200261300010043020100020004223O004302012O000300015O0020B20001000100220020B70001000100232O00F600010002000200261300010043020100140004223O004302012O0003000100054O001400025O00202O0002000200114O000300033O00202O00030003000E4O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001004302013O0004223O004302012O0003000100063O00126C0002004A3O00126C0003004B4O005B000100034O00BC00015O00126C3O002D3O00261A3O008A020100190004223O008A02012O000300015O0020B20001000100110020B700010001000B2O00F600010002000200062C2O01006E02013O0004223O006E02012O0003000100133O00062C2O01006E02013O0004223O006E02012O0003000100023O00202E0001000100264O00035O00202O0003000300154O00010003000200062O0001006E02013O0004223O006E02012O0003000100023O00202E00010001000C4O00035O00202O00030003002E4O00010003000200062O0001006E02013O0004223O006E02012O0003000100054O001400025O00202O0002000200114O000300033O00202O00030003000E4O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001006E02013O0004223O006E02012O0003000100063O00126C0002004C3O00126C0003004D4O005B000100034O00BC00016O000300015O0020B200010001000A0020B700010001000B2O00F600010002000200062C2O0100CA03013O0004223O00CA03012O0003000100073O00062C2O0100CA03013O0004223O00CA03012O0003000100054O00E000025O00202O00020002000A4O000300033O00202O00030003000E4O00055O00202O00050005000A4O0003000500024O000300036O000400016O00010004000200062O000100CA03013O0004223O00CA03012O0003000100063O0012620002004E3O00122O0003004F6O000100036O00015O00044O00CA030100261A3O00430301001C0004223O004303012O000300015O0020B20001000100500020B700010001000B2O00F600010002000200062C2O0100C002013O0004223O00C002012O0003000100193O00062C2O0100C002013O0004223O00C002012O00030001001A3O00062C2O01009B02013O0004223O009B02012O00030001000B3O0006300001009E020100010004223O009E02012O00030001001A3O000630000100C0020100010004223O00C002012O00030001000C4O00030002000D3O00068A000100C0020100020004223O00C002012O000300015O0020B20001000100200020B70001000100212O00F600010002000200062C2O0100C002013O0004223O00C002012O0003000100023O0020780001000100514O0001000200024O000200023O00202O0002000200524O00020002000200062O000100C0020100020004223O00C002012O0003000100054O007C00025O00202O0002000200504O000300033O00202O00030003002900122O0005002A6O0003000500024O000300036O00010003000200062O000100C002013O0004223O00C002012O0003000100063O00126C000200533O00126C000300544O005B000100034O00BC00016O000300015O0020B200010001000A0020B700010001000B2O00F600010002000200062C2O0100F502013O0004223O00F502012O0003000100073O00062C2O0100F502013O0004223O00F502012O000300015O0020B20001000100200020B70001000100212O00F600010002000200062C2O0100F502013O0004223O00F502012O0003000100023O0020B70001000100512O00F60001000200020026AC000100E30201003C0004223O00E302012O0003000100023O0020780001000100514O0001000200024O000200023O00202O0002000200524O00020002000200062O000100F5020100020004223O00F502012O000300015O0020D000010001005000202O0001000100234O0001000200024O000200043O00062O000200F5020100010004223O00F502012O0003000100054O00E000025O00202O00020002000A4O000300033O00202O00030003000E4O00055O00202O00050005000A4O0003000500024O000300036O000400016O00010004000200062O000100F502013O0004223O00F502012O0003000100063O00126C000200553O00126C000300564O005B000100034O00BC00016O000300015O0020B20001000100110020B700010001000B2O00F600010002000200062C2O01004203013O0004223O004203012O0003000100133O00062C2O01004203013O0004223O004203012O0003000100173O00062C2O01004203013O0004223O004203012O0003000100023O0020B700010001003D2O00F600010002000200062C2O01004203013O0004223O004203012O0003000100023O00202E00010001000C4O00035O00202O00030003002E4O00010003000200062O0001004203013O0004223O004203012O000300015O0020B20001000100200020B70001000100232O00F600010002000200261300010042030100020004223O004203012O0003000100023O00202E0001000100264O00035O00202O0003000300154O00010003000200062O0001004203013O0004223O004203012O0003000100023O00202O0001000100264O00035O00202O0003000300444O00010003000200062O0001002A030100010004223O002A03012O0003000100023O00200E0001000100304O00035O00202O0003000300444O0001000300024O000200043O00202O00020002001900062O00010042030100020004223O004203012O0003000100023O00209200010001003100122O000300573O00122O000400326O00010004000200062O0001004203013O0004223O004203012O0003000100054O001400025O00202O0002000200114O000300033O00202O00030003000E4O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001004203013O0004223O004203012O0003000100063O00126C000200583O00126C000300594O005B000100034O00BC00015O00126C3O003C3O00261A3O0001000100320004223O000100012O000300015O0020B20001000100220020B700010001000B2O00F600010002000200062C2O01006D03013O0004223O006D03012O00030001001B3O00062C2O01006D03013O0004223O006D03012O00030001001C3O00062C2O01005403013O0004223O005403012O0003000100113O00063000010057030100010004223O005703012O00030001001C3O0006300001006D030100010004223O006D03012O00030001000C4O00030002000D3O00068A0001006D030100020004223O006D03012O0003000100054O00E000025O00202O0002000200224O000300033O00202O00030003000E4O00055O00202O0005000500224O0003000500024O000300036O000400016O00010004000200062O0001006D03013O0004223O006D03012O0003000100063O00126C0002005A3O00126C0003005B4O005B000100034O00BC00016O000300015O0020B200010001001D0020B700010001000B2O00F600010002000200062C2O01009F03013O0004223O009F03012O00030001001D3O00062C2O01009F03013O0004223O009F03012O0003000100023O00204700010001001B00122O0003001C6O00045O00202O0004000400224O00010004000200062O0001008E030100010004223O008E03012O0003000100023O00204700010001001B00122O0003001C6O00045O00202O0004000400374O00010004000200062O0001008E030100010004223O008E03012O0003000100023O0020FC00010001001B00122O0003001C6O00045O00202O0004000400204O00010004000200062O0001009F03013O0004223O009F03012O0003000100054O001400025O00202O00020002001D4O000300033O00202O00030003000E4O00055O00202O00050005001D4O0003000500024O000300036O00010003000200062O0001009F03013O0004223O009F03012O0003000100063O00126C0002005C3O00126C0003005D4O005B000100034O00BC00016O000300015O0020B200010001000A0020B700010001000B2O00F600010002000200062C2O0100C803013O0004223O00C803012O0003000100073O00062C2O0100C803013O0004223O00C803012O0003000100033O0020282O010001005E4O00035O00202O00030003005F4O000100030002000E2O000100C8030100010004223O00C803012O0003000100033O00201900010001005E4O00035O00202O00030003005F4O00010003000200262O000100C8030100320004223O00C803012O0003000100054O00E000025O00202O00020002000A4O000300033O00202O00030003000E4O00055O00202O00050005000A4O0003000500024O000300036O000400016O00010004000200062O000100C803013O0004223O00C803012O0003000100063O00126C000200603O00126C000300614O005B000100034O00BC00015O00126C3O00023O0004223O000100012O00063O00017O00573O00028O00030D3O004E657468657254656D7065737403073O004973526561647903113O0054696D6553696E63654C61737443617374025O00804640030A3O00446562752O66446F776E03133O004E657468657254656D70657374446562752O66030B3O00426C2O6F646C7573745570030E3O0049735370652O6C496E52616E6765031C3O003BB19FFADF278B9FF7D725B198E69A26A48AE0D10AA483F3C930F4D903053O00BA55D4EB92030E3O00417263616E654D692O73696C657303063O0042752O66557003103O00436C65617263617374696E6742752O66030C3O0052616469616E74537061726B030F3O00432O6F6C646F776E52656D61696E73026O00144003083O0042752O66446F776E03133O004E6574686572507265636973696F6E42752O6603133O00417263616E65417274692O6C65727942752O66030B3O0042752O6652656D61696E73026O00184003073O0048617354696572026O003F40026O001040031D3O00C39315FF37EB67CF8805ED30E25DD1C105EE38FC53FD911EFF2AEB189603073O0038A2E1769E598E030B3O00417263616E65426C617374030B3O00417263616E655375726765030A3O00432O6F6C646F776E557003043O004D616E61030F3O00536970686F6E53746F726D42752O66026O002E40031A3O005D17C3AE2CDD6307CCAE31CC1C16D0AE30D36315C8AE31DD1C5303063O00B83C65A0CF42030C3O0049734368612O6E656C696E67030A3O0047434452656D61696E73030B3O0053746F7043617374696E6703243O00328372BF348E3CBD23817DB234BD71B5229175B034913CAF21836EB70E9274BD22873CE403043O00DC51E21C026O00F03F027O0040030B3O004973417661696C61626C6503083O005072657647434450031B3O0012C781FAE4C22CC697E9EDC253C692FAF8CC2CC58AFAF9C25384DA03063O00A773B5E29B8A03083O004361737454696D652O033O00474344030B3O004578656375746554696D65030D3O00446562752O6652656D61696E7303193O0052616469616E74537061726B56756C6E65726162696C69747903113O00417263616E65426F6D626172646D656E7403103O004865616C746850657263656E74616765025O0080414003093O00497343617374696E67030B3O004361737452656D61696E73026O00E03F031B3O00E330E45D7574F9E02EE64F6F31D5F223F5574461CEE331E21C292103073O00A68242873C1B11030D3O00417263616E6542612O72616765030B3O00446562752O66537461636B031D3O004558CD743E4175CC7422564BC92O70575ACF673B7B5AC67423410A9C2703053O0050242AAE15030E3O00546F7563686F667468654D61676903083O00496E466C69676874030A3O0054726176656C54696D650200A04O99C93F03203O005A1F2279462F387C71043F7F711D367D4750246A4F023C455E1836694B50652E03043O001A2E7057026O000840031B3O00B831A875B1BA7AB6B522B860FFAC55B5AB289464B7BE56B1F971FD03083O00D4D943CB142ODF25031D3O00BB9FABD3B48897D0BB9FBAD3BD88E8C1AA8CBAD9859DA0D3A988E880E203043O00B2DAEDC8030A3O0049734361737461626C6503093O0042752O66537461636B031E3O00B7A7E5D1B8B0D9DDBFA6F5D9BAB0F5902OA5E7C2BD8AF6D8B7A6E390E7E503043O00B0D6D586030D3O00417263616E654861726D6F6E7903113O00417263616E654861726D6F6E7942752O66026O003E40031E3O00F5BFB5D5A65366F9A4A5C7A15A5CE7EDA5C4A94452CBBDBED5BB5319A5FF03073O003994CDD6B4C836031C4O00FC313D771CE90A276613EF3E746502FC273F4902F534277352AC6103053O0016729D5554031D3O00CACE07CC58E497D0CE1ED458E5BC84D803C54FFD97D4C312D758B6F99203073O00C8A4AB73A43D96001D032O00126C3O00013O000ECE000100DB00013O0004223O00DB00012O000300015O0020B20001000100020020B70001000100032O00F600010002000200062C2O01003200013O0004223O003200012O0003000100013O00062C2O01003200013O0004223O003200012O000300015O0020B20001000100020020B70001000100042O00F6000100020002000EFB00050032000100010004223O003200012O0003000100023O00202E0001000100064O00035O00202O0003000300074O00010003000200062O0001003200013O0004223O003200012O0003000100033O00062C2O01003200013O0004223O003200012O0003000100043O0020B70001000100082O00F600010002000200062C2O01003200013O0004223O003200012O0003000100054O001400025O00202O0002000200024O000300023O00202O0003000300094O00055O00202O0005000500024O0003000500024O000300036O00010003000200062O0001003200013O0004223O003200012O0003000100063O00126C0002000A3O00126C0003000B4O005B000100034O00BC00016O000300015O0020B200010001000C0020B70001000100032O00F600010002000200062C2O01007F00013O0004223O007F00012O0003000100073O00062C2O01007F00013O0004223O007F00012O0003000100033O00062C2O01007F00013O0004223O007F00012O0003000100043O0020B70001000100082O00F600010002000200062C2O01007F00013O0004223O007F00012O0003000100043O00202E00010001000D4O00035O00202O00030003000E4O00010003000200062O0001007F00013O0004223O007F00012O000300015O0020B200010001000F0020B70001000100102O00F60001000200020026130001007F000100110004223O007F00012O0003000100043O00202E0001000100124O00035O00202O0003000300134O00010003000200062O0001007F00013O0004223O007F00012O0003000100043O00202O0001000100124O00035O00202O0003000300144O00010003000200062O00010067000100010004223O006700012O0003000100043O00200E0001000100154O00035O00202O0003000300144O0001000300024O000200083O00202O00020002001600062O0001007F000100020004223O007F00012O0003000100043O00209200010001001700122O000300183O00122O000400196O00010004000200062O0001007F00013O0004223O007F00012O0003000100054O001400025O00202O00020002000C4O000300023O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O00010003000200062O0001007F00013O0004223O007F00012O0003000100063O00126C0002001A3O00126C0003001B4O005B000100034O00BC00016O000300015O0020B200010001001C0020B70001000100032O00F600010002000200062C2O0100B500013O0004223O00B500012O0003000100093O00062C2O0100B500013O0004223O00B500012O0003000100033O00062C2O0100B500013O0004223O00B500012O000300015O0020B200010001001D0020B700010001001E2O00F600010002000200062C2O0100B500013O0004223O00B500012O0003000100043O0020B70001000100082O00F600010002000200062C2O0100B500013O0004223O00B500012O0003000100043O0020B700010001001F2O00F60001000200022O00030002000A3O000611010200B5000100010004223O00B500012O0003000100043O0020282O01000100154O00035O00202O0003000300204O000100030002000E2O002100B5000100010004223O00B500012O0003000100054O00E000025O00202O00020002001C4O000300023O00202O0003000300094O00055O00202O00050005001C4O0003000500024O000300036O000400016O00010004000200062O000100B500013O0004223O00B500012O0003000100063O00126C000200223O00126C000300234O005B000100034O00BC00016O0003000100043O00202E0001000100244O00035O00202O00030003000C4O00010003000200062O000100DA00013O0004223O00DA00012O0003000100043O0020B70001000100252O00F600010002000200261A000100DA000100010004223O00DA00012O0003000100043O00202E00010001000D4O00035O00202O0003000300134O00010003000200062O000100DA00013O0004223O00DA00012O0003000100043O00202E0001000100124O00035O00202O0003000300144O00010003000200062O000100DA00013O0004223O00DA00012O0003000100054O00030002000B3O0020B20002000200262O00F600010002000200062C2O0100DA00013O0004223O00DA00012O0003000100063O00126C000200273O00126C000300284O005B000100034O00BC00015O00126C3O00293O000ECE002A00ED2O013O0004223O00ED2O012O000300015O0020B200010001001D0020B70001000100032O00F600010002000200062C2O01000C2O013O0004223O000C2O012O00030001000C3O00062C2O01000C2O013O0004223O000C2O012O00030001000D3O00062C2O0100EC00013O0004223O00EC00012O00030001000E3O000630000100EF000100010004223O00EF00012O00030001000D3O0006300001000C2O0100010004223O000C2O012O00030001000F4O0003000200103O00068A0001000C2O0100020004223O000C2O012O000300015O0020B20001000100020020B700010001002B2O00F6000100020002000630000100042O0100010004223O00042O012O0003000100043O0020FC00010001002C00122O000300196O00045O00202O00040004000F4O00010004000200062O000100042O013O0004223O00042O012O0003000100113O00062C2O0100142O013O0004223O00142O012O0003000100043O00204700010001002C00122O000300116O00045O00202O00040004000F4O00010004000200062O000100142O0100010004223O00142O012O0003000100043O0020FC00010001002C00122O000300296O00045O00202O0004000400024O00010004000200062O000100262O013O0004223O00262O012O0003000100054O00E000025O00202O00020002001D4O000300023O00202O0003000300094O00055O00202O00050005001D4O0003000500024O000300036O000400016O00010004000200062O000100262O013O0004223O00262O012O0003000100063O00126C0002002D3O00126C0003002E4O005B000100034O00BC00016O000300015O0020B200010001001C0020B70001000100032O00F600010002000200062C2O01008C2O013O0004223O008C2O012O0003000100093O00062C2O01008C2O013O0004223O008C2O012O000300015O00203D00010001001C00202O00010001002F4O0001000200024O000200043O00202O0002000200304O00020002000200062O0002008C2O0100010004223O008C2O012O000300015O00206900010001001C00202O0001000100314O0001000200024O000200023O00202O0002000200324O00045O00202O0004000400334O00020004000200062O0001008C2O0100020004223O008C2O012O000300015O0020B20001000100340020B700010001002B2O00F600010002000200062C2O01004E2O013O0004223O004E2O012O0003000100023O0020B70001000100352O00F6000100020002000EFB0036008C2O0100010004223O008C2O012O000300015O0020B20001000100020020B700010001002B2O00F600010002000200062C2O01005C2O013O0004223O005C2O012O0003000100043O00204700010001002C00122O000300166O00045O00202O00040004000F4O00010004000200062O0001006A2O0100010004223O006A2O012O000300015O0020B20001000100020020B700010001002B2O00F60001000200020006300001008C2O0100010004223O008C2O012O0003000100043O0020FC00010001002C00122O000300116O00045O00202O00040004000F4O00010004000200062O0001008C2O013O0004223O008C2O012O0003000100043O00202E0001000100374O00035O00202O00030003001D4O00010003000200062O0001007A2O013O0004223O007A2O012O0003000100043O0020B70001000100382O00F60001000200020026130001007A2O0100390004223O007A2O012O0003000100114O009C000100013O0006300001008C2O0100010004223O008C2O012O0003000100054O00E000025O00202O00020002001C4O000300023O00202O0003000300094O00055O00202O00050005001C4O0003000500024O000300036O000400016O00010004000200062O0001008C2O013O0004223O008C2O012O0003000100063O00126C0002003A3O00126C0003003B4O005B000100034O00BC00016O000300015O0020B200010001003C0020B70001000100032O00F600010002000200062C2O0100AD2O013O0004223O00AD2O012O0003000100123O00062C2O0100AD2O013O0004223O00AD2O012O0003000100023O0020002O010001003D4O00035O00202O0003000300334O00010003000200262O000100AD2O0100190004223O00AD2O012O0003000100054O001400025O00202O00020002003C4O000300023O00202O0003000300094O00055O00202O00050005003C4O0003000500024O000300036O00010003000200062O000100AD2O013O0004223O00AD2O012O0003000100063O00126C0002003E3O00126C0003003F4O005B000100034O00BC00016O000300015O0020B20001000100400020B70001000100032O00F600010002000200062C2O0100EC2O013O0004223O00EC2O012O0003000100133O00062C2O0100EC2O013O0004223O00EC2O012O0003000100143O00062C2O0100BC2O013O0004223O00BC2O012O0003000100153O000630000100BF2O0100010004223O00BF2O012O0003000100143O000630000100EC2O0100010004223O00EC2O012O00030001000F4O0003000200103O00068A000100EC2O0100020004223O00EC2O012O0003000100043O0020FC00010001002C00122O000300296O00045O00202O00040004003C4O00010004000200062O000100EC2O013O0004223O00EC2O012O000300015O0020B200010001003C0020B70001000100412O00F600010002000200062C2O0100DC2O013O0004223O00DC2O012O000300015O0020102O010001003C00202O0001000100424O0001000200024O00025O00202O00020002003C00202O0002000200044O0002000200024O00010001000200262O000100E12O0100430004223O00E12O012O0003000100043O0020B70001000100252O00F60001000200020026C6000100EC2O0100430004223O00EC2O012O0003000100054O000300025O0020B20002000200402O00F600010002000200062C2O0100EC2O013O0004223O00EC2O012O0003000100063O00126C000200443O00126C000300454O005B000100034O00BC00015O00126C3O00463O00261A3O0025020100460004223O002502012O000300015O0020B200010001001C0020B70001000100032O00F600010002000200062C2O01000A02013O0004223O000A02012O0003000100093O00062C2O01000A02013O0004223O000A02012O0003000100054O00E000025O00202O00020002001C4O000300023O00202O0003000300094O00055O00202O00050005001C4O0003000500024O000300036O000400016O00010004000200062O0001000A02013O0004223O000A02012O0003000100063O00126C000200473O00126C000300484O005B000100034O00BC00016O000300015O0020B200010001003C0020B70001000100032O00F600010002000200062C2O01001C03013O0004223O001C03012O0003000100123O00062C2O01001C03013O0004223O001C03012O0003000100054O001400025O00202O00020002003C4O000300023O00202O0003000300094O00055O00202O00050005003C4O0003000500024O000300036O00010003000200062O0001001C03013O0004223O001C03012O0003000100063O001262000200493O00122O0003004A6O000100036O00015O00044O001C030100261A3O0001000100290004223O000100012O000300015O0020B200010001000C0020B700010001004B2O00F600010002000200062C2O01007402013O0004223O007402012O0003000100073O00062C2O01007402013O0004223O007402012O0003000100033O00062C2O01007402013O0004223O007402012O0003000100043O0020B70001000100082O00F600010002000200062C2O01007402013O0004223O007402012O0003000100043O00202E00010001000D4O00035O00202O00030003000E4O00010003000200062O0001007402013O0004223O007402012O0003000100043O0020A600010001004C4O00035O00202O00030003000E4O000100030002000E2O002A0074020100010004223O007402012O000300015O0020B200010001000F0020B70001000100102O00F600010002000200261300010074020100110004223O007402012O0003000100043O00202E0001000100124O00035O00202O0003000300134O00010003000200062O0001007402013O0004223O007402012O0003000100043O00202O0001000100124O00035O00202O0003000300144O00010003000200062O00010063020100010004223O006302012O0003000100043O00200E0001000100154O00035O00202O0003000300144O0001000300024O000200083O00202O00020002001600062O00010074020100020004223O007402012O0003000100054O001400025O00202O00020002000C4O000300023O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O00010003000200062O0001007402013O0004223O007402012O0003000100063O00126C0002004D3O00126C0003004E4O005B000100034O00BC00016O000300015O0020B200010001000C0020B70001000100032O00F600010002000200062C2O0100B602013O0004223O00B602012O0003000100073O00062C2O0100B602013O0004223O00B602012O000300015O0020B200010001004F0020B700010001002B2O00F600010002000200062C2O0100B602013O0004223O00B602012O0003000100043O00201900010001004C4O00035O00202O0003000300504O00010003000200262O000100B6020100210004223O00B602012O0003000100033O00062C2O01009202013O0004223O009202012O0003000100043O0020B70001000100082O00F60001000200020006300001009F020100010004223O009F02012O0003000100043O00202E00010001000D4O00035O00202O00030003000E4O00010003000200062O000100B602013O0004223O00B602012O000300015O0020B200010001000F0020B70001000100102O00F6000100020002002613000100B6020100110004223O00B602012O000300015O0020B200010001001D0020B70001000100102O00F6000100020002002613000100B6020100510004223O00B602012O0003000100054O001400025O00202O00020002000C4O000300023O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O00010003000200062O000100B602013O0004223O00B602012O0003000100063O00126C000200523O00126C000300534O005B000100034O00BC00016O000300015O0020B200010001000F0020B70001000100032O00F600010002000200062C2O0100DD02013O0004223O00DD02012O0003000100163O00062C2O0100DD02013O0004223O00DD02012O0003000100173O00062C2O0100C502013O0004223O00C502012O0003000100153O000630000100C8020100010004223O00C802012O0003000100173O000630000100DD020100010004223O00DD02012O00030001000F4O0003000200103O00068A000100DD020100020004223O00DD02012O0003000100054O001400025O00202O00020002000F4O000300023O00202O0003000300094O00055O00202O00050005000F4O0003000500024O000300036O00010003000200062O000100DD02013O0004223O00DD02012O0003000100063O00126C000200543O00126C000300554O005B000100034O00BC00016O000300015O0020B20001000100020020B70001000100032O00F600010002000200062C2O01001A03013O0004223O001A03012O0003000100013O00062C2O01001A03013O0004223O001A03012O0003000100113O0006300001001A030100010004223O001A03012O000300015O0020B20001000100020020B70001000100042O00F6000100020002000EFB0021001A030100010004223O001A03012O0003000100043O0020FC00010001002C00122O000300196O00045O00202O00040004000F4O00010004000200062O0001000103013O0004223O000103012O000300015O00205D00010001001D00202O0001000100104O0001000200024O00025O00202O00020002000200202O0002000200314O00020002000200062O00010009000100020004223O000903012O0003000100043O0020FC00010001002C00122O000300116O00045O00202O00040004000F4O00010004000200062O0001001A03013O0004223O001A03012O0003000100054O001400025O00202O0002000200024O000300023O00202O0003000300094O00055O00202O0005000500024O0003000500024O000300036O00010003000200062O0001001A03013O0004223O001A03012O0003000100063O00126C000200563O00126C000300574O005B000100034O00BC00015O00126C3O002A3O0004223O000100012O00063O00017O003F3O00028O00027O0040030D3O00417263616E6542612O7261676503073O0049735265616479030B3O00417263616E655375726765030F3O00432O6F6C646F776E52656D61696E73025O00C05240030B3O00446562752O66537461636B03193O0052616469616E74537061726B56756C6E65726162696C697479026O001040030A3O004F726242612O72616765030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503213O00BFE600448DBBCB014491ACF50440C3BFFB067A90AEF5114EBCAEFC025686FEA55103053O00E3DE946325026O00F03F03213O003240512OF7366D50F7EB215355F3B9325D57C9EA235340FDC6235A53E5FC73030603053O0099532O3296026O000840026O001440030D3O00417263616E654368617267657303103O00417263616E65436861726765734D617803213O005C64701D7DAE725F77610E72AC481D777C194CB85D5C64782363A34C4E73334D2503073O002D3D16137C13CB03063O0042752O66557003123O0050726573656E63656F664D696E6442752O6603103O0043616E63656C504F4D53652O74696E6703083O005072657647434450030B3O00417263616E65426C61737403093O0043616E63656C504F4D03293O00C21303F6077CF9D10008E6077EBAC42D02F33D7DB0CF164DF40D7586D2020CE7094FA9C9131EF0422103073O00D9A1726D956210030E3O00546F7563686F667468654D61676903233O00062F2D7FB44B1D260768B4712O2D397BB534132F3D43AF6413323343AC7C13333D3CEE03063O00147240581CDC030C3O0052616469616E74537061726B031F3O002300D6BDF9DEA90E12C2B5EADBFD300ED78BEBC0BC230AEDA4F0D1AE34418603073O00DD5161B2D498B003093O00417263616E654F726203113O0054696D6553696E63654C61737443617374026O002E4003093O004973496E52616E6765026O004440031C3O00CCF51EFA14C8D812E9188DE612FE25DEF71CE911F2F715FA09C8A74B03053O007AAD877D9B030D3O004E657468657254656D70657374030A3O00417263616E654563686F03203O008AC414B13A23F790C40DA93A22DCC4C00FBC0022D885D30B862F39C997C440E103073O00A8E4A160D95F51031F3O00DAC32D5D2152E4C23B4E28529BD021591044CBD03C571047D3D03D596F068B03063O0037BBB14E3C4F030E3O0050726573656E63656F664D696E64030A3O0049734361737461626C65030C3O0049734368612O6E656C696E6703233O003DDC5AF843C18328F150ED79C28923CA1FEA49CABF3EDE5EF94DF09025CF4CEE069ED803073O00E04DAE3F8B26AF03083O00446562752O665570031F3O0085535B2F8A44672C88404B3AC440572BBB52482F964A673E8C404B2BC4130803043O004EE42138030F3O00417263616E65537572676542752O6603083O0042752O66446F776E03213O00CF6CB1028BCB41B00297DC7FB506C5CF71B73C96DE7FA008BADE76B310808E2CE003053O00E5AE1ED2630045022O00126C3O00013O00261A3O00B5000100020004223O00B500012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01003000013O0004223O003000012O0003000100013O00062C2O01003000013O0004223O003000012O000300015O0020B20001000100050020B70001000100062O00F600010002000200261300010030000100070004223O003000012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O000100300001000A0004223O003000012O000300015O0020B200010001000B0020B700010001000C2O00F600010002000200063000010030000100010004223O003000012O0003000100034O001400025O00202O0002000200034O000300023O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001003000013O0004223O003000012O0003000100043O00126C0002000E3O00126C0003000F4O005B000100034O00BC00016O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01006A00013O0004223O006A00012O0003000100013O00062C2O01006A00013O0004223O006A00012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O00010046000100020004223O004600012O000300015O0020B20001000100050020B70001000100062O00F6000100020002000EC500070059000100010004223O005900012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O0001006A000100100004223O006A00012O000300015O0020B20001000100050020B70001000100062O00F60001000200020026130001006A000100070004223O006A00012O000300015O0020B200010001000B0020B700010001000C2O00F60001000200020006300001006A000100010004223O006A00012O0003000100034O001400025O00202O0002000200034O000300023O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001006A00013O0004223O006A00012O0003000100043O00126C000200113O00126C000300124O005B000100034O00BC00016O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O0100B400013O0004223O00B400012O0003000100013O00062C2O0100B400013O0004223O00B400012O0003000100023O0020D90001000100084O00035O00202O0003000300094O00010003000200262O00010095000100100004223O009500012O0003000100023O0020D90001000100084O00035O00202O0003000300094O00010003000200262O00010095000100020004223O009500012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O0001008E000100130004223O008E00012O0003000100053O000EC500140095000100010004223O009500012O0003000100063O000EC500140095000100010004223O009500012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O000100B40001000A0004223O00B400012O0003000100073O0020212O01000100154O0001000200024O000200073O00202O0002000200164O00020002000200062O000100B4000100020004223O00B400012O000300015O0020B200010001000B0020B700010001000C2O00F600010002000200062C2O0100B400013O0004223O00B400012O0003000100034O001400025O00202O0002000200034O000300023O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100B400013O0004223O00B400012O0003000100043O00126C000200173O00126C000300184O005B000100034O00BC00015O00126C3O00133O00261A3O002D2O0100010004223O002D2O012O0003000100073O00202E0001000100194O00035O00202O00030003001A4O00010003000200062O000100DB00013O0004223O00DB00010012450001001B3O00062C2O0100DB00013O0004223O00DB00012O0003000100073O0020FC00010001001C00122O000300106O00045O00202O00040004001D4O00010004000200062O000100DB00013O0004223O00DB00012O0003000100073O0020282O01000100064O00035O00202O0003000300054O000100030002000E2O000700DB000100010004223O00DB00012O0003000100034O0003000200083O0020B200020002001E2O00F600010002000200062C2O0100DB00013O0004223O00DB00012O0003000100043O00126C0002001F3O00126C000300204O005B000100034O00BC00016O000300015O0020B20001000100210020B70001000100042O00F600010002000200062C2O0100042O013O0004223O00042O012O0003000100093O00062C2O0100042O013O0004223O00042O012O00030001000A3O00062C2O0100EA00013O0004223O00EA00012O00030001000B3O000630000100ED000100010004223O00ED00012O00030001000A3O000630000100042O0100010004223O00042O012O00030001000C4O00030002000D3O00068A000100042O0100020004223O00042O012O0003000100073O0020FC00010001001C00122O000300106O00045O00202O0004000400034O00010004000200062O000100042O013O0004223O00042O012O0003000100034O000300025O0020B20002000200212O00F600010002000200062C2O0100042O013O0004223O00042O012O0003000100043O00126C000200223O00126C000300234O005B000100034O00BC00016O000300015O0020B20001000100240020B70001000100042O00F600010002000200062C2O01002C2O013O0004223O002C2O012O00030001000E3O00062C2O01002C2O013O0004223O002C2O012O00030001000F3O00062C2O0100132O013O0004223O00132O012O00030001000B3O000630000100162O0100010004223O00162O012O00030001000F3O0006300001002C2O0100010004223O002C2O012O00030001000C4O00030002000D3O00068A0001002C2O0100020004223O002C2O012O0003000100034O00E000025O00202O0002000200244O000300023O00202O00030003000D4O00055O00202O0005000500244O0003000500024O000300036O000400016O00010004000200062O0001002C2O013O0004223O002C2O012O0003000100043O00126C000200253O00126C000300264O005B000100034O00BC00015O00126C3O00103O00261A3O00AF2O0100100004223O00AF2O012O000300015O0020B20001000100270020B70001000100042O00F600010002000200062C2O0100602O013O0004223O00602O012O0003000100103O00062C2O0100602O013O0004223O00602O012O0003000100113O00062C2O01003E2O013O0004223O003E2O012O00030001000B3O000630000100412O0100010004223O00412O012O0003000100113O000630000100602O0100010004223O00602O012O00030001000C4O00030002000D3O00068A000100602O0100020004223O00602O012O000300015O0020B20001000100270020B70001000100282O00F6000100020002000EFB002900602O0100010004223O00602O012O0003000100073O0020B70001000100152O00F6000100020002002613000100602O0100130004223O00602O012O0003000100034O007C00025O00202O0002000200274O000300023O00202O00030003002A00122O0005002B6O0003000500024O000300036O00010003000200062O000100602O013O0004223O00602O012O0003000100043O00126C0002002C3O00126C0003002D4O005B000100034O00BC00016O000300015O0020B200010001002E0020B70001000100042O00F600010002000200062C2O0100862O013O0004223O00862O012O0003000100123O00062C2O0100862O013O0004223O00862O012O000300015O0020B200010001002E0020B70001000100282O00F6000100020002000EFB002900862O0100010004223O00862O012O000300015O0020B200010001002F0020B700010001000C2O00F600010002000200062C2O0100862O013O0004223O00862O012O0003000100034O001400025O00202O00020002002E4O000300023O00202O00030003000D4O00055O00202O00050005002E4O0003000500024O000300036O00010003000200062O000100862O013O0004223O00862O012O0003000100043O00126C000200303O00126C000300314O005B000100034O00BC00016O000300015O0020B20001000100050020B70001000100042O00F600010002000200062C2O0100AE2O013O0004223O00AE2O012O0003000100133O00062C2O0100AE2O013O0004223O00AE2O012O0003000100143O00062C2O0100952O013O0004223O00952O012O0003000100153O000630000100982O0100010004223O00982O012O0003000100143O000630000100AE2O0100010004223O00AE2O012O00030001000C4O00030002000D3O00068A000100AE2O0100020004223O00AE2O012O0003000100034O00E000025O00202O0002000200054O000300023O00202O00030003000D4O00055O00202O0005000500054O0003000500024O000300036O000400016O00010004000200062O000100AE2O013O0004223O00AE2O012O0003000100043O00126C000200323O00126C000300334O005B000100034O00BC00015O00126C3O00023O00261A3O0001000100130004223O000100012O000300015O0020B20001000100340020B70001000100352O00F600010002000200062C2O0100CA2O013O0004223O00CA2O012O0003000100163O00062C2O0100CA2O013O0004223O00CA2O012O0003000100073O0020B70001000100362O00F6000100020002000630000100CA2O0100010004223O00CA2O012O0003000100034O000300025O0020B20002000200342O00F600010002000200062C2O0100CA2O013O0004223O00CA2O012O0003000100043O00126C000200373O00126C000300384O005B000100034O00BC00016O000300015O0020B200010001001D0020B70001000100042O00F600010002000200062C2O01000602013O0004223O000602012O0003000100173O00062C2O01000602013O0004223O000602012O0003000100023O0020D90001000100084O00035O00202O0003000300094O00010003000200262O000100E12O0100020004223O00E12O012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O000100E72O0100130004223O00E72O012O000300015O0020B200010001000B0020B700010001000C2O00F600010002000200062C2O0100F42O013O0004223O00F42O012O0003000100023O00202E0001000100394O00035O00202O0003000300094O00010003000200062O0001000602013O0004223O000602012O000300015O0020B200010001000B0020B700010001000C2O00F600010002000200062C2O01000602013O0004223O000602012O0003000100034O00E000025O00202O00020002001D4O000300023O00202O00030003000D4O00055O00202O00050005001D4O0003000500024O000300036O000400016O00010004000200062O0001000602013O0004223O000602012O0003000100043O00126C0002003A3O00126C0003003B4O005B000100034O00BC00016O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01004402013O0004223O004402012O0003000100013O00062C2O01004402013O0004223O004402012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O0001001D0201000A0004223O001D02012O0003000100073O00202O0001000100194O00035O00202O00030003003C4O00010003000200062O00010031020100010004223O003102012O0003000100023O0020002O01000100084O00035O00202O0003000300094O00010003000200262O00010044020100130004223O004402012O0003000100073O00202E00010001003D4O00035O00202O00030003003C4O00010003000200062O0001004402013O0004223O004402012O000300015O0020B200010001000B0020B700010001000C2O00F600010002000200063000010044020100010004223O004402012O0003000100034O001400025O00202O0002000200034O000300023O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001004402013O0004223O004402012O0003000100043O0012620002003E3O00122O0003003F6O000100036O00015O00044O004402010004223O000100012O00063O00017O00493O00028O00030D3O00446562752O6652656D61696E7303143O00546F7563686F667468654D616769446562752O66026O002240026O00F03F030D3O004E657468657254656D7065737403073O004973526561647903113O00446562752O665265667265736861626C6503133O004E657468657254656D70657374446562752O6603083O00446562752O665570030D3O00417263616E6543686172676573026O001040030E3O004D616E6150657263656E74616765026O003E40030A3O005370652O6C486173746502F2D24D621058E53F03083O0042752O66446F776E030F3O00417263616E65537572676542752O66030E3O0049735370652O6C496E52616E6765031C3O0015E89259E82F060FE88B41E82E2D5BF98944EE35060BE58742E87D6B03073O00597B8DE6318D5D03093O00417263616E654F7262027O004003093O004973496E52616E6765026O00444003183O00F263F50D1E4FCC7EE40E505EFC64F5042F5AFB70E509501E03063O002A9311966C70026O000840030E3O00417263616E654D692O73696C6573030A3O0049734361737461626C6503063O0042752O66557003103O00436C65617263617374696E6742752O6603083O004361737454696D65030E3O0050726573656E63656F664D696E64030B3O004973417661696C61626C65031E3O000EB42E7EE9ED30AB246CF4E103A33E3FF3E71AA52540F7E00EB5283FB6B003063O00886FC64D1F87030B3O00417263616E65426C617374031B3O00031BA457B3E128AB0E08B442FDF018BC2O019846B5E504AC425BF703083O00C96269C736DD8477030D3O00417263616E6542612O72616765031D3O00B81E80200C3093BB0D91330332A9F9188C34013D93A90482320775FEEB03073O00CCD96CE3416255030C3O0049734368612O6E656C696E67031E3O004ED1F0F629CE5DC6CAEA2AFF53CAFBE16CD451D6F6ED13D056C2E6E06C9603063O00A03EA395854C03123O0050726573656E63656F664D696E6442752O6603103O00417263616E65436861726765734D6178031A3O00D7B20E2ECDD39F0F23C2C5B44D3BCCC3A30510D3DEA11E2A838E03053O00A3B6C06D4F03113O00417263616E654861726D6F6E7942752O6603113O00417263616E65426F6D626172646D656E7403103O004865616C746850657263656E74616765025O00804140031D3O00353403C1FB311902C1E7262707C5B5202915C3FD0B3608C1E63166519003053O0095544660A003093O0042752O66537461636B030E3O00436F6E6A7572654D616E6147656D03073O004D616E6147656D030A3O00432O6F6C646F776E5570031E3O0039140EEC360332E031151EE434031EAD2C0918EE30391DE5391508AD695403043O008D58666D03133O004E6574686572507265636973696F6E42752O66031B3O00B241C97114386AC3BF52D9645A295AD4B05BF560123C46C4F3029E03083O00A1D333AA107A5D35030A3O0047434452656D61696E73030E3O00546F7563686F667468654D616769030F3O00432O6F6C646F776E52656D61696E73025O0080514003133O00417263616E65417274692O6C65727942752O66030B3O0053746F7043617374696E6703253O00F8AFBC2BFEA2F229E9ADB326FE91BF21E8BDBB24FEBDF23CF4BBB120C4BEBA29E8ABF279AD03043O00489BCED200FC012O00126C3O00013O000ECE0001008800013O0004223O008800012O000300015O0020282O01000100024O000300013O00202O0003000300034O000100030002000E2O00040011000100010004223O001100012O0003000100034O0002010200046O000300026O00020002000200102O0002000500024O0001000200024O000100024O0003000100013O0020B20001000100060020B70001000100072O00F600010002000200062C2O01004F00013O0004223O004F00012O0003000100053O00062C2O01004F00013O0004223O004F00012O000300015O00202O0001000100084O000300013O00202O0003000300094O00010003000200062O00010028000100010004223O002800012O000300015O00202O00010001000A4O000300013O00202O0003000300094O00010003000200062O0001004F000100010004223O004F00012O0003000100063O0020B700010001000B2O00F600010002000200261A0001004F0001000C0004223O004F00012O0003000100063O0020B700010001000D2O00F60001000200020026130001004F0001000E0004223O004F00012O0003000100063O0020B700010001000F2O00F60001000200020026130001004F000100100004223O004F00012O0003000100063O00202E0001000100114O000300013O00202O0003000300124O00010003000200062O0001004F00013O0004223O004F00012O0003000100074O0014000200013O00202O0002000200064O00035O00202O0003000300134O000500013O00202O0005000500064O0003000500024O000300036O00010003000200062O0001004F00013O0004223O004F00012O0003000100083O00126C000200143O00126C000300154O005B000100034O00BC00016O0003000100013O0020B20001000100160020B70001000100072O00F600010002000200062C2O01008700013O0004223O008700012O0003000100093O00062C2O01008700013O0004223O008700012O00030001000A3O00062C2O01005E00013O0004223O005E00012O00030001000B3O00063000010061000100010004223O006100012O00030001000A3O00063000010087000100010004223O008700012O0003000100063O0020B700010001000B2O00F600010002000200261300010087000100170004223O008700012O0003000100063O0020B700010001000D2O00F6000100020002002613000100870001000E0004223O008700012O0003000100063O0020B700010001000F2O00F600010002000200261300010087000100100004223O008700012O0003000100063O00202E0001000100114O000300013O00202O0003000300124O00010003000200062O0001008700013O0004223O008700012O0003000100074O007C000200013O00202O0002000200164O00035O00202O00030003001800122O000500196O0003000500024O000300036O00010003000200062O0001008700013O0004223O008700012O0003000100083O00126C0002001A3O00126C0003001B4O005B000100034O00BC00015O00126C3O00053O00261A3O00F20001001C0004223O00F200012O0003000100013O0020B200010001001D0020B700010001001E2O00F600010002000200062C2O0100BC00013O0004223O00BC00012O00030001000C3O00062C2O0100BC00013O0004223O00BC00012O0003000100063O00202E00010001001F4O000300013O00202O0003000300204O00010003000200062O000100BC00013O0004223O00BC00012O000300015O0020980001000100024O000300013O00202O0003000300034O0001000300024O000200013O00202O00020002001D00202O0002000200214O00020002000200062O000200AB000100010004223O00AB00012O0003000100013O0020B20001000100220020B70001000100232O00F6000100020002000630000100BC000100010004223O00BC00012O0003000100074O0014000200013O00202O00020002001D4O00035O00202O0003000300134O000500013O00202O00050005001D4O0003000500024O000300036O00010003000200062O000100BC00013O0004223O00BC00012O0003000100083O00126C000200243O00126C000300254O005B000100034O00BC00016O0003000100013O0020B20001000100260020B70001000100072O00F600010002000200062C2O0100D700013O0004223O00D700012O00030001000D3O00062C2O0100D700013O0004223O00D700012O0003000100074O00E0000200013O00202O0002000200264O00035O00202O0003000300134O000500013O00202O0005000500264O0003000500024O000300036O000400016O00010004000200062O000100D700013O0004223O00D700012O0003000100083O00126C000200273O00126C000300284O005B000100034O00BC00016O0003000100013O0020B20001000100290020B70001000100072O00F600010002000200062C2O0100FB2O013O0004223O00FB2O012O00030001000E3O00062C2O0100FB2O013O0004223O00FB2O012O0003000100074O0014000200013O00202O0002000200294O00035O00202O0003000300134O000500013O00202O0005000500294O0003000500024O000300036O00010003000200062O000100FB2O013O0004223O00FB2O012O0003000100083O0012620002002A3O00122O0003002B6O000100036O00015O00044O00FB2O01000ECE000500732O013O0004223O00732O012O0003000100013O0020B20001000100220020B700010001001E2O00F600010002000200062C2O0100152O013O0004223O00152O012O00030001000F3O00062C2O0100152O013O0004223O00152O012O0003000100063O0020B700010001002C2O00F6000100020002000630000100152O0100010004223O00152O012O000300015O0020142O01000100024O000300013O00202O0003000300034O0001000300024O000200103O00062O000100152O0100020004223O00152O012O0003000100074O0003000200013O0020B20002000200222O00F600010002000200062C2O0100152O013O0004223O00152O012O0003000100083O00126C0002002D3O00126C0003002E4O005B000100034O00BC00016O0003000100013O0020B20001000100260020B70001000100072O00F600010002000200062C2O01003E2O013O0004223O003E2O012O00030001000D3O00062C2O01003E2O013O0004223O003E2O012O0003000100063O00202E00010001001F4O000300013O00202O00030003002F4O00010003000200062O0001003E2O013O0004223O003E2O012O0003000100063O0020212O010001000B4O0001000200024O000200063O00202O0002000200304O00020002000200062O0001003E2O0100020004223O003E2O012O0003000100074O0014000200013O00202O0002000200264O00035O00202O0003000300134O000500013O00202O0005000500264O0003000500024O000300036O00010003000200062O0001003E2O013O0004223O003E2O012O0003000100083O00126C000200313O00126C000300324O005B000100034O00BC00016O0003000100013O0020B20001000100290020B70001000100072O00F600010002000200062C2O0100722O013O0004223O00722O012O00030001000E3O00062C2O0100722O013O0004223O00722O012O0003000100063O00202O00010001001F4O000300013O00202O0003000300334O00010003000200062O000100592O0100010004223O00592O012O0003000100013O0020B20001000100340020B70001000100232O00F600010002000200062C2O0100722O013O0004223O00722O012O000300015O0020B70001000100352O00F6000100020002002613000100722O0100360004223O00722O012O000300015O0020142O01000100024O000300013O00202O0003000300034O0001000300024O000200103O00062O000100722O0100020004223O00722O012O0003000100074O0014000200013O00202O0002000200294O00035O00202O0003000300134O000500013O00202O0005000500294O0003000500024O000300036O00010003000200062O000100722O013O0004223O00722O012O0003000100083O00126C000200373O00126C000300384O005B000100034O00BC00015O00126C3O00173O000ECE0017000100013O0004223O000100012O0003000100013O0020B200010001001D0020B700010001001E2O00F600010002000200062C2O0100A22O013O0004223O00A22O012O00030001000C3O00062C2O0100A22O013O0004223O00A22O012O0003000100063O0020282O01000100394O000300013O00202O0003000300204O000100030002000E2O000500A22O0100010004223O00A22O012O0003000100013O0020B200010001003A0020B70001000100232O00F600010002000200062C2O0100A22O013O0004223O00A22O012O0003000100113O0020B200010001003B0020B700010001003C2O00F600010002000200062C2O0100A22O013O0004223O00A22O012O0003000100074O0014000200013O00202O00020002001D4O00035O00202O0003000300134O000500013O00202O00050005001D4O0003000500024O000300036O00010003000200062O000100A22O013O0004223O00A22O012O0003000100083O00126C0002003D3O00126C0003003E4O005B000100034O00BC00016O0003000100013O0020B20001000100260020B70001000100072O00F600010002000200062C2O0100C42O013O0004223O00C42O012O00030001000D3O00062C2O0100C42O013O0004223O00C42O012O0003000100063O00202E00010001001F4O000300013O00202O00030003003F4O00010003000200062O000100C42O013O0004223O00C42O012O0003000100074O00E0000200013O00202O0002000200264O00035O00202O0003000300134O000500013O00202O0005000500264O0003000500024O000300036O000400016O00010004000200062O000100C42O013O0004223O00C42O012O0003000100083O00126C000200403O00126C000300414O005B000100034O00BC00016O0003000100063O00202E00010001002C4O000300013O00202O00030003001D4O00010003000200062O000100F92O013O0004223O00F92O012O0003000100063O0020B70001000100422O00F600010002000200261A000100F92O0100010004223O00F92O012O0003000100063O00202E00010001001F4O000300013O00202O00030003003F4O00010003000200062O000100F92O013O0004223O00F92O012O0003000100063O0020B700010001000D2O00F6000100020002000EC0000E00E22O0100010004223O00E22O012O0003000100013O0020B20001000100430020B70001000100442O00F6000100020002000EC5000E00E72O0100010004223O00E72O012O0003000100063O0020B700010001000D2O00F6000100020002000EC0004500F92O0100010004223O00F92O012O0003000100063O00202E0001000100114O000300013O00202O0003000300464O00010003000200062O000100F92O013O0004223O00F92O012O0003000100074O0003000200123O0020B20002000200472O00F600010002000200062C2O0100F92O013O0004223O00F92O012O0003000100083O00126C000200483O00126C000300494O005B000100034O00BC00015O00126C3O001C3O0004223O000100012O00063O00017O001E3O00028O00026O00F03F030D3O00417263616E6542612O7261676503073O0049735265616479026O001040030D3O00417263616E6543686172676573026O00084003103O00417263616E65436861726765734D6178030E3O0049735370652O6C496E52616E676503203O004768570F3D4345560F21547B530B734775513127496F57060C5672551D36062E03053O0053261A346E03093O00417263616E654F7262027O004003093O004973496E52616E6765026O004440031C3O0059052447561218494A156747571218525702244E67072F474B12671003043O0026387747030F3O00417263616E654578706C6F73696F6E026O003E4003223O00F2FD5BD72B53CCEA40C62959E0E657D86557FCEA67C22A43F0E767C62D57E0EA188E03063O0036938F38B645030D3O00446562752O6652656D61696E7303143O00546F7563686F667468654D616769446562752O66026O002240030E3O00417263616E654D692O73696C657303063O0042752O66557003133O00417263616E65417274692O6C65727942752O6603103O00436C65617263617374696E6742752O6603213O00D793FC48D1D3BEF240CCC588F34CCC9680F04CE0C28EEA4AD7E991F748CCD3C1AD03053O00BFB6E19F2900B33O00126C3O00013O00261A3O005C000100020004223O005C00012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01003000013O0004223O003000012O0003000100013O00062C2O01003000013O0004223O003000012O0003000100023O0026C600010017000100050004223O001700012O0003000100033O0026C600010017000100050004223O001700012O0003000100043O0020B70001000100062O00F60001000200020026322O01001F000100070004223O001F00012O0003000100043O0020212O01000100064O0001000200024O000200043O00202O0002000200084O00020002000200062O00010030000100020004223O003000012O0003000100054O001400025O00202O0002000200034O000300063O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001003000013O0004223O003000012O0003000100073O00126C0002000A3O00126C0003000B4O005B000100034O00BC00016O000300015O0020B200010001000C0020B70001000100042O00F600010002000200062C2O01005B00013O0004223O005B00012O0003000100083O00062C2O01005B00013O0004223O005B00012O0003000100093O00062C2O01003F00013O0004223O003F00012O00030001000A3O00063000010042000100010004223O004200012O0003000100093O0006300001005B000100010004223O005B00012O00030001000B4O00030002000C3O00068A0001005B000100020004223O005B00012O0003000100043O0020B70001000100062O00F60001000200020026130001005B0001000D0004223O005B00012O0003000100054O007C00025O00202O00020002000C4O000300063O00202O00030003000E00122O0005000F6O0003000500024O000300036O00010003000200062O0001005B00013O0004223O005B00012O0003000100073O00126C000200103O00126C000300114O005B000100034O00BC00015O00126C3O000D3O00261A3O00780001000D0004223O007800012O000300015O0020B20001000100120020B70001000100042O00F600010002000200062C2O0100B200013O0004223O00B200012O00030001000D3O00062C2O0100B200013O0004223O00B200012O0003000100054O007C00025O00202O0002000200124O000300063O00202O00030003000E00122O000500136O0003000500024O000300036O00010003000200062O000100B200013O0004223O00B200012O0003000100073O001262000200143O00122O000300156O000100036O00015O00044O00B2000100261A3O0001000100010004223O000100012O0003000100063O0020282O01000100164O00035O00202O0003000300174O000100030002000E2O00180088000100010004223O008800012O00030001000F4O0002010200106O0003000E6O00020002000200102O0002000200024O0001000200024O0001000E4O000300015O0020B20001000100190020B70001000100042O00F600010002000200062C2O0100B000013O0004223O00B000012O0003000100113O00062C2O0100B000013O0004223O00B000012O0003000100043O00202E00010001001A4O00035O00202O00030003001B4O00010003000200062O000100B000013O0004223O00B000012O0003000100043O00202E00010001001A4O00035O00202O00030003001C4O00010003000200062O000100B000013O0004223O00B000012O0003000100054O001400025O00202O0002000200194O000300063O00202O0003000300094O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100B000013O0004223O00B000012O0003000100073O00126C0002001D3O00126C0003001E4O005B000100034O00BC00015O00126C3O00023O0004223O000100012O00063O00017O005C3O00028O00026O000840030D3O00417263616E6542612O7261676503073O0049735265616479030D3O00417263616E654368617267657303103O00417263616E65436861726765734D6178030E3O004D616E6150657263656E74616765026O004E40030E3O00546F7563686F667468654D616769030F3O00432O6F6C646F776E52656D61696E73026O00244003093O0045766F636174696F6E026O004440026O003440030E3O0049735370652O6C496E52616E6765031A3O002A002B548582FD29133A478A80C76B0027418A93CB241C6807DD03073O00A24B724835EBE7030C3O0049734368612O6E656C696E67030E3O00417263616E654D692O73696C6573030A3O0047434452656D61696E7303063O0042752O66557003133O004E6574686572507265636973696F6E42752O66026O003E40025O0080514003083O0042752O66446F776E03133O00417263616E65417274692O6C65727942752O66030B3O0053746F7043617374696E6703293O008F3D4AE1560EB33D47F65A0D827C45F0500382397BEF5A119F3548E740429E3350E3470B833204B00B03063O0062EC5C248233030A3O0049734361737461626C6503103O00436C65617263617374696E6742752O66031B3O00A50B0FBB4BAD8A3DAD0A1FB349ADA670B61618BB51A1BA3EE44A5C03083O0050C4796CDA25C8D5030B3O00417263616E65426C61737403183O000161017E450BB5027F036C5F4E980F67036B42018440205003073O00EA6013621F2B6E026O001040031A3O00070D51C6A277B4041E40D5AD758E460D5DD3AD668209111294F803073O00EB667F32A7CC12027O0040026O004940030B3O004973417661696C61626C65031A3O0051B3F6224A2B6FA3F431562F57A4B5314B3A51B5FC2C4A6E01F903063O004E30C1954324030B3O00426C2O6F646C7573745570026O001440031A3O00310C83194F3521821953221F871D01221194195539118E58136003053O0021507EE07803113O00436F6E63656E74726174696F6E42752O66031B3O00EDBA00C552E9970ECD4FFFA10FC14FACBA0CD05DF8A10CCA1CBEFA03053O003C8CC863A403183O0086E60727AC82CB062AA394E04434AD93F5102FAD89B4567203053O00C2E794644603093O00417263616E654F7262030D3O00426C2O6F646C757374446F776E03093O004973496E52616E676503153O00475EC2A2F8CD7943D3A1B6DA4958C0B7FFC7480C9303063O00A8262CA1C396030D3O005368696674696E67506F776572026O002840030B3O00417263616E655375726765030F3O00417263616E65537572676542752O66026O002E4003193O0093F48B7024E1B811BFEC8D6135FAF6048FE8836239E7B856D403083O0076E09CE2165088D6025O0080464003193O0051E6508656E757877DFE569747FC19924DFA58944BE157C01403043O00E0228E39030E3O0050726573656E63656F664D696E6403103O004865616C746850657263656E74616765025O0080414003113O00417263616E65426F6D626172646D656E74031B3O00CEB5C0CE76FF5E0BE1A8C3E27EF8530A9EB5CAC972E55401D0E79D03083O006EBEC7A5BD13913D026O00F03F030B3O0054696D65416E6F6D616C79030B3O0042752O6652656D61696E73026O00184003183O00DBF974E985C2E5E97BE998D39AF978FC8A2OD3E479A8DA9703063O00A7BA8B1788EB03123O0050726573656E63656F664D696E6442752O6603183O001BA78B0C14B0B70F16B49B195AA787191BA1810214F5D95F03043O006D7AD5E803093O0042752O66537461636B031B3O00EFE5A131E0F29D3DE7E4B139E2F2B170FCF8B631FAFEAD3EAEA6F603043O00508E97C2030D3O004E657468657254656D7065737403113O00446562752O665265667265736861626C6503133O004E657468657254656D70657374446562752O6603103O0054656D706F72616C5761727042752O66031A3O000DC3634406D4485806CB674910D2375E0CD276580AC9790C529003043O002C63A617006C032O00126C3O00013O00261A3O00BD000100020004223O00BD00012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01003C00013O0004223O003C00012O0003000100013O00062C2O01003C00013O0004223O003C00012O0003000100023O0020212O01000100054O0001000200024O000200023O00202O0002000200064O00020002000200062O0001003C000100020004223O003C00012O0003000100023O0020B70001000100072O00F60001000200020026130001003C000100080004223O003C00012O0003000100033O00062C2O01003C00013O0004223O003C00012O000300015O0020B20001000100090020B700010001000A2O00F6000100020002000EC0000B003C000100010004223O003C00012O000300015O0020B200010001000C0020B700010001000A2O00F6000100020002000EC0000D003C000100010004223O003C00012O0003000100043O000EC0000E003C000100010004223O003C00012O0003000100054O001400025O00202O0002000200034O000300063O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001003C00013O0004223O003C00012O0003000100073O00126C000200103O00126C000300114O005B000100034O00BC00016O0003000100023O00202E0001000100124O00035O00202O0003000300134O00010003000200062O0001007300013O0004223O007300012O0003000100023O0020B70001000100142O00F600010002000200261A00010073000100010004223O007300012O0003000100023O00202E0001000100154O00035O00202O0003000300164O00010003000200062O0001007300013O0004223O007300012O0003000100023O0020B70001000100072O00F6000100020002000EC00017005A000100010004223O005A00012O000300015O0020B20001000100090020B700010001000A2O00F6000100020002000EC50017005F000100010004223O005F00012O0003000100023O0020B70001000100072O00F6000100020002000EC000180073000100010004223O007300012O0003000100023O00202E0001000100194O00035O00202O00030003001A4O00010003000200062O0001007300013O0004223O007300012O0003000100054O0055000200083O00202O00020002001B4O000300046O000500016O00010005000200062O0001007300013O0004223O007300012O0003000100073O00126C0002001C3O00126C0003001D4O005B000100034O00BC00016O000300015O0020B20001000100130020B700010001001E2O00F600010002000200062C2O0100A100013O0004223O00A100012O0003000100093O00062C2O0100A100013O0004223O00A100012O0003000100023O00202E0001000100154O00035O00202O00030003001F4O00010003000200062O000100A100013O0004223O00A100012O0003000100023O00202E0001000100194O00035O00202O0003000300164O00010003000200062O000100A100013O0004223O00A100012O00030001000A3O00062C2O01009000013O0004223O009000012O00030001000B3O000630000100A1000100010004223O00A100012O0003000100054O001400025O00202O0002000200134O000300063O00202O00030003000F4O00055O00202O0005000500134O0003000500024O000300036O00010003000200062O000100A100013O0004223O00A100012O0003000100073O00126C000200203O00126C000300214O005B000100034O00BC00016O000300015O0020B20001000100220020B70001000100042O00F600010002000200062C2O0100BC00013O0004223O00BC00012O00030001000C3O00062C2O0100BC00013O0004223O00BC00012O0003000100054O00E000025O00202O0002000200224O000300063O00202O00030003000F4O00055O00202O0005000500224O0003000500024O000300036O000400016O00010004000200062O000100BC00013O0004223O00BC00012O0003000100073O00126C000200233O00126C000300244O005B000100034O00BC00015O00126C3O00253O00261A3O00DA000100250004223O00DA00012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01006B03013O0004223O006B03012O0003000100013O00062C2O01006B03013O0004223O006B03012O0003000100054O001400025O00202O0002000200034O000300063O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001006B03013O0004223O006B03012O0003000100073O001262000200263O00122O000300276O000100036O00015O00044O006B030100261A3O009F2O0100280004223O009F2O012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01000C2O013O0004223O000C2O012O0003000100013O00062C2O01000C2O013O0004223O000C2O012O0003000100023O0020212O01000100054O0001000200024O000200023O00202O0002000200064O00020002000200062O0001000C2O0100020004223O000C2O012O0003000100023O0020B70001000100072O00F60001000200020026130001000C2O0100290004223O000C2O012O000300015O0020B200010001000C0020B700010001002A2O00F60001000200020006300001000C2O0100010004223O000C2O012O0003000100043O000EC0000E000C2O0100010004223O000C2O012O0003000100054O001400025O00202O0002000200034O000300063O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001000C2O013O0004223O000C2O012O0003000100073O00126C0002002B3O00126C0003002C4O005B000100034O00BC00016O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O0100442O013O0004223O00442O012O0003000100013O00062C2O0100442O013O0004223O00442O012O0003000100023O0020212O01000100054O0001000200024O000200023O00202O0002000200064O00020002000200062O000100442O0100020004223O00442O012O0003000100023O0020B70001000100072O00F6000100020002002613000100442O0100180004223O00442O012O0003000100033O00062C2O0100442O013O0004223O00442O012O0003000100023O0020B700010001002D2O00F600010002000200062C2O0100442O013O0004223O00442O012O000300015O0020B20001000100090020B700010001000A2O00F6000100020002000EC0002E00442O0100010004223O00442O012O0003000100043O000EC0000E00442O0100010004223O00442O012O0003000100054O001400025O00202O0002000200034O000300063O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100442O013O0004223O00442O012O0003000100073O00126C0002002F3O00126C000300304O005B000100034O00BC00016O000300015O0020B20001000100130020B700010001001E2O00F600010002000200062C2O0100742O013O0004223O00742O012O0003000100093O00062C2O0100742O013O0004223O00742O012O0003000100023O00202E0001000100154O00035O00202O00030003001F4O00010003000200062O000100742O013O0004223O00742O012O0003000100023O00202E0001000100154O00035O00202O0003000300314O00010003000200062O000100742O013O0004223O00742O012O0003000100023O0020212O01000100054O0001000200024O000200023O00202O0002000200064O00020002000200062O000100742O0100020004223O00742O012O0003000100054O001400025O00202O0002000200134O000300063O00202O00030003000F4O00055O00202O0005000500134O0003000500024O000300036O00010003000200062O000100742O013O0004223O00742O012O0003000100073O00126C000200323O00126C000300334O005B000100034O00BC00016O000300015O0020B20001000100220020B70001000100042O00F600010002000200062C2O01009E2O013O0004223O009E2O012O00030001000C3O00062C2O01009E2O013O0004223O009E2O012O0003000100023O0020212O01000100054O0001000200024O000200023O00202O0002000200064O00020002000200062O0001009E2O0100020004223O009E2O012O0003000100023O00202E0001000100154O00035O00202O0003000300164O00010003000200062O0001009E2O013O0004223O009E2O012O0003000100054O00E000025O00202O0002000200224O000300063O00202O00030003000F4O00055O00202O0005000500224O0003000500024O000300036O000400016O00010004000200062O0001009E2O013O0004223O009E2O012O0003000100073O00126C000200343O00126C000300354O005B000100034O00BC00015O00126C3O00023O00261A3O0099020100010004223O009902012O000300015O0020B20001000100360020B70001000100042O00F600010002000200062C2O0100DF2O013O0004223O00DF2O012O00030001000D3O00062C2O0100DF2O013O0004223O00DF2O012O00030001000E3O00062C2O0100B02O013O0004223O00B02O012O00030001000F3O000630000100B32O0100010004223O00B32O012O00030001000E3O000630000100DF2O0100010004223O00DF2O012O0003000100104O0003000200043O00068A000100DF2O0100020004223O00DF2O012O0003000100023O0020B70001000100052O00F6000100020002002613000100DF2O0100020004223O00DF2O012O0003000100023O0020B70001000100372O00F6000100020002000630000100CF2O0100010004223O00CF2O012O0003000100023O0020B70001000100072O00F6000100020002000EC5001800CF2O0100010004223O00CF2O012O00030001000A3O00062C2O0100DF2O013O0004223O00DF2O012O000300015O0020B20001000100090020B700010001000A2O00F6000100020002000EC0001700DF2O0100010004223O00DF2O012O0003000100054O007C00025O00202O0002000200364O000300063O00202O00030003003800122O0005000D6O0003000500024O000300036O00010003000200062O000100DF2O013O0004223O00DF2O012O0003000100073O00126C000200393O00126C0003003A4O005B000100034O00BC00016O000300015O0020B200010001003B0020B70001000100042O00F600010002000200062C2O01003602013O0004223O003602012O0003000100113O00062C2O01003602013O0004223O003602012O0003000100123O00062C2O0100EE2O013O0004223O00EE2O012O0003000100133O000630000100F12O0100010004223O00F12O012O0003000100133O00063000010036020100010004223O003602012O0003000100104O0003000200043O00068A00010036020100020004223O003602012O00030001000A3O00062C2O01003602013O0004223O003602012O000300015O0020B200010001000C0020B700010001002A2O00F600010002000200062C2O01000402013O0004223O000402012O000300015O0020B200010001000C0020B700010001000A2O00F6000100020002000EC0003C0036020100010004223O003602012O000300015O0020B200010001003D0020B700010001002A2O00F600010002000200062C2O01001002013O0004223O001002012O000300015O0020B200010001003D0020B700010001000A2O00F6000100020002000EC0003C0036020100010004223O003602012O000300015O0020B20001000100090020B700010001002A2O00F600010002000200062C2O01001C02013O0004223O001C02012O000300015O0020B20001000100090020B700010001000A2O00F6000100020002000EC0003C0036020100010004223O003602012O0003000100023O00202E0001000100194O00035O00202O00030003003E4O00010003000200062O0001003602013O0004223O003602012O0003000100043O000EC0003F0036020100010004223O003602012O0003000100054O007C00025O00202O00020002003B4O000300063O00202O00030003003800122O0005000D6O0003000500024O000300036O00010003000200062O0001003602013O0004223O003602012O0003000100073O00126C000200403O00126C000300414O005B000100034O00BC00016O000300015O0020B200010001003B0020B70001000100042O00F600010002000200062C2O01006F02013O0004223O006F02012O0003000100113O00062C2O01006F02013O0004223O006F02012O0003000100123O00062C2O01004502013O0004223O004502012O0003000100133O00063000010048020100010004223O004802012O0003000100133O0006300001006F020100010004223O006F02012O0003000100104O0003000200043O00068A0001006F020100020004223O006F02012O00030001000A3O0006300001006F020100010004223O006F02012O0003000100023O00202E0001000100194O00035O00202O00030003003E4O00010003000200062O0001006F02013O0004223O006F02012O000300015O0020B200010001003D0020B700010001000A2O00F6000100020002000EC00042006F020100010004223O006F02012O0003000100043O000EC0003F006F020100010004223O006F02012O0003000100054O007C00025O00202O00020002003B4O000300063O00202O00030003003800122O0005000D6O0003000500024O000300036O00010003000200062O0001006F02013O0004223O006F02012O0003000100073O00126C000200433O00126C000300444O005B000100034O00BC00016O000300015O0020B20001000100450020B700010001001E2O00F600010002000200062C2O01009802013O0004223O009802012O0003000100143O00062C2O01009802013O0004223O009802012O0003000100023O0020B70001000100122O00F600010002000200063000010098020100010004223O009802012O0003000100023O0020B70001000100052O00F600010002000200261300010098020100020004223O009802012O0003000100063O0020B70001000100462O00F600010002000200261300010098020100470004223O009802012O000300015O0020B20001000100480020B700010001002A2O00F600010002000200062C2O01009802013O0004223O009802012O0003000100054O000300025O0020B20002000200452O00F600010002000200062C2O01009802013O0004223O009802012O0003000100073O00126C000200493O00126C0003004A4O005B000100034O00BC00015O00126C3O004B3O00261A3O00010001004B0004223O000100012O000300015O0020B20001000100220020B70001000100042O00F600010002000200062C2O0100CA02013O0004223O00CA02012O00030001000C3O00062C2O0100CA02013O0004223O00CA02012O000300015O0020B200010001004C0020B700010001002A2O00F600010002000200062C2O0100CA02013O0004223O00CA02012O0003000100023O00202E0001000100154O00035O00202O00030003003E4O00010003000200062O000100CA02013O0004223O00CA02012O0003000100023O00201200010001004D4O00035O00202O00030003003E4O00010003000200262O000100CA0201004E0004223O00CA02012O0003000100054O00E000025O00202O0002000200224O000300063O00202O00030003000F4O00055O00202O0005000500224O0003000500024O000300036O000400016O00010004000200062O000100CA02013O0004223O00CA02012O0003000100073O00126C0002004F3O00126C000300504O005B000100034O00BC00016O000300015O0020B20001000100220020B70001000100042O00F600010002000200062C2O0100FB02013O0004223O00FB02012O00030001000C3O00062C2O0100FB02013O0004223O00FB02012O0003000100023O00202E0001000100154O00035O00202O0003000300514O00010003000200062O000100FB02013O0004223O00FB02012O0003000100063O0020B70001000100462O00F6000100020002002613000100FB020100470004223O00FB02012O000300015O0020B20001000100480020B700010001002A2O00F600010002000200062C2O0100FB02013O0004223O00FB02012O0003000100023O0020B70001000100052O00F6000100020002002613000100FB020100020004223O00FB02012O0003000100054O001400025O00202O0002000200224O000300063O00202O00030003000F4O00055O00202O0005000500224O0003000500024O000300036O00010003000200062O000100FB02013O0004223O00FB02012O0003000100073O00126C000200523O00126C000300534O005B000100034O00BC00016O000300015O0020B20001000100130020B700010001001E2O00F600010002000200062C2O01002403013O0004223O002403012O0003000100093O00062C2O01002403013O0004223O002403012O0003000100023O00202E0001000100154O00035O00202O00030003001F4O00010003000200062O0001002403013O0004223O002403012O0003000100023O0020B50001000100544O00035O00202O00030003001F4O0001000300024O000200153O00062O00010024030100020004223O002403012O0003000100054O001400025O00202O0002000200134O000300063O00202O00030003000F4O00055O00202O0005000500134O0003000500024O000300036O00010003000200062O0001002403013O0004223O002403012O0003000100073O00126C000200553O00126C000300564O005B000100034O00BC00016O000300015O0020B20001000100570020B70001000100042O00F600010002000200062C2O01006903013O0004223O006903012O0003000100163O00062C2O01006903013O0004223O006903012O0003000100063O00202E0001000100584O00035O00202O0003000300594O00010003000200062O0001006903013O0004223O006903012O0003000100023O0020212O01000100054O0001000200024O000200023O00202O0002000200064O00020002000200062O00010069030100020004223O006903012O0003000100023O00202O0001000100154O00035O00202O00030003005A4O00010003000200062O0001004E030100010004223O004E03012O0003000100023O0020B70001000100072O00F60001000200020026AC0001004E0301000B0004223O004E03012O000300015O0020B200010001003B0020B700010001002A2O00F600010002000200063000010069030100010004223O006903012O0003000100023O00202E0001000100194O00035O00202O00030003003E4O00010003000200062O0001006903013O0004223O006903012O0003000100043O000EFB003C0069030100010004223O006903012O0003000100054O001400025O00202O0002000200574O000300063O00202O00030003000F4O00055O00202O0005000500574O0003000500024O000300036O00010003000200062O0001006903013O0004223O006903012O0003000100073O00126C0002005B3O00126C0003005C4O005B000100034O00BC00015O00126C3O00283O0004223O000100012O00063O00017O00363O00028O00026O00F03F030E3O00417263616E654D692O73696C6573030A3O0049734361737461626C6503063O0042752O66557003133O00417263616E65417274692O6C65727942752O6603103O00436C65617263617374696E6742752O66030E3O00546F7563686F667468654D616769030F3O00432O6F6C646F776E52656D61696E73030B3O0042752O6652656D61696E73026O001040030E3O0049735370652O6C496E52616E6765031E3O007DE52A373DA143FA202520AD70F23A7632AB79C83B3927A568FE263873F203063O00C41C97495653030D3O00417263616E6542612O7261676503073O0049735265616479030D3O00417263616E6543686172676573026O000840031D3O00F2112A118C5D2774F2113B11855D5877FC0616028D4C1962FA0C2750DA03083O001693634970E23878027O004003093O00417263616E654F7262026O00324003093O004973496E52616E6765026O004440031A3O00B967E1F483BD4AEDE78FF874EDF0B2AA7AF6F499B17AECB5DCE803053O00EDD815829503103O00417263616E65436861726765734D6178030E3O004D616E6150657263656E74616765026O002440031E3O00832O5C5EBECC61804F2O4DB1CE5BC24F505A8FDB51964F4B56BFC71ED31C03073O003EE22E2O3FD0A9030F3O00417263616E654578706C6F73696F6E026O003E4003203O00E40B56821108105BFD09598C0C042050A5185A86201F204AE40D5C8C114D7E0A03083O003E857935E37F6D4F030D3O005368696674696E67506F77657203093O0045766F636174696F6E030B3O004973417661696C61626C65026O002840030B3O00417263616E65537572676503083O0042752O66446F776E030F3O00417263616E65537572676542752O66030A3O00436861726765644F726203073O0043686172676573031D3O00031C3BF3C2A7AC172B22FAC1ABB050153DF0E9BCAD041526FCD9A0E24203073O00C270745295B6CE030D3O004E657468657254656D7065737403113O00446562752O665265667265736861626C6503133O004E657468657254656D70657374446562752O66026O001840030A3O004F726242612O72616765031D3O0037AD5810C5F0312DAD4108C5F11A79A9431DFFF0012DA95811CFEC4E6D03073O006E59C82C78A0820087012O00126C3O00013O00261A3O0065000100020004223O006500012O000300015O0020B20001000100030020B70001000100042O00F600010002000200062C2O01003800013O0004223O003800012O0003000100013O00062C2O01003800013O0004223O003800012O0003000100023O00202E0001000100054O00035O00202O0003000300064O00010003000200062O0001003800013O0004223O003800012O0003000100023O00202E0001000100054O00035O00202O0003000300074O00010003000200062O0001003800013O0004223O003800012O000300015O00200D2O010001000800202O0001000100094O0001000200024O000200023O00202O00020002000A4O00045O00202O0004000400064O00020004000200202O00020002000B00202O00020002000200068A00020038000100010004223O003800012O0003000100034O001400025O00202O0002000200034O000300043O00202O00030003000C4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001003800013O0004223O003800012O0003000100053O00126C0002000D3O00126C0003000E4O005B000100034O00BC00016O000300015O0020B200010001000F0020B70001000100102O00F600010002000200062C2O01006400013O0004223O006400012O0003000100063O00062C2O01006400013O0004223O006400012O0003000100073O0026C6000100470001000B0004223O004700012O0003000100083O00261E0001004E0001000B0004223O004E00012O0003000100023O00202E0001000100054O00035O00202O0003000300074O00010003000200062O0001006400013O0004223O006400012O0003000100023O0020B70001000100112O00F600010002000200261A00010064000100120004223O006400012O0003000100034O001400025O00202O00020002000F4O000300043O00202O00030003000C4O00055O00202O00050005000F4O0003000500024O000300036O00010003000200062O0001006400013O0004223O006400012O0003000100053O00126C000200133O00126C000300144O005B000100034O00BC00015O00126C3O00153O00261A3O00C0000100150004223O00C000012O000300015O0020B20001000100160020B70001000100102O00F600010002000200062C2O01009800013O0004223O009800012O0003000100093O00062C2O01009800013O0004223O009800012O00030001000A3O00062C2O01007600013O0004223O007600012O00030001000B3O00063000010079000100010004223O007900012O00030001000A3O00063000010098000100010004223O009800012O00030001000C4O00030002000D3O00068A00010098000100020004223O009800012O0003000100023O0020B70001000100112O00F600010002000200261A00010098000100010004223O009800012O000300015O0020B20001000100080020B70001000100092O00F6000100020002000EC000170098000100010004223O009800012O0003000100034O007C00025O00202O0002000200164O000300043O00202O00030003001800122O000500196O0003000500024O000300036O00010003000200062O0001009800013O0004223O009800012O0003000100053O00126C0002001A3O00126C0003001B4O005B000100034O00BC00016O000300015O0020B200010001000F0020B70001000100102O00F600010002000200062C2O0100BF00013O0004223O00BF00012O0003000100063O00062C2O0100BF00013O0004223O00BF00012O0003000100023O00207B0001000100114O0001000200024O000200023O00202O00020002001C4O00020002000200062O000100AE000100020004223O00AE00012O0003000100023O0020B700010001001D2O00F6000100020002002613000100BF0001001E0004223O00BF00012O0003000100034O001400025O00202O00020002000F4O000300043O00202O00030003000C4O00055O00202O00050005000F4O0003000500024O000300036O00010003000200062O000100BF00013O0004223O00BF00012O0003000100053O00126C0002001F3O00126C000300204O005B000100034O00BC00015O00126C3O00123O00261A3O00DC000100120004223O00DC00012O000300015O0020B20001000100210020B70001000100102O00F600010002000200062C2O0100862O013O0004223O00862O012O00030001000E3O00062C2O0100862O013O0004223O00862O012O0003000100034O007C00025O00202O0002000200214O000300043O00202O00030003001800122O000500226O0003000500024O000300036O00010003000200062O000100862O013O0004223O00862O012O0003000100053O001262000200233O00122O000300246O000100036O00015O00044O00862O0100261A3O0001000100010004223O000100012O000300015O0020B20001000100250020B70001000100102O00F600010002000200062C2O0100482O013O0004223O00482O012O00030001000F3O00062C2O0100482O013O0004223O00482O012O0003000100103O00062C2O0100ED00013O0004223O00ED00012O0003000100113O000630000100F0000100010004223O00F000012O0003000100113O000630000100482O0100010004223O00482O012O00030001000C4O00030002000D3O00068A000100482O0100020004223O00482O012O000300015O0020B20001000100260020B70001000100272O00F600010002000200062C2O012O002O013O0004224O002O012O000300015O0020B20001000100260020B70001000100092O00F6000100020002000EC0002800482O0100010004223O00482O012O000300015O0020B20001000100290020B70001000100272O00F600010002000200062C2O01000C2O013O0004223O000C2O012O000300015O0020B20001000100290020B70001000100092O00F6000100020002000EC0002800482O0100010004223O00482O012O000300015O0020B20001000100080020B70001000100272O00F600010002000200062C2O0100182O013O0004223O00182O012O000300015O0020B20001000100080020B70001000100092O00F6000100020002000EC0002800482O0100010004223O00482O012O0003000100023O00202E00010001002A4O00035O00202O00030003002B4O00010003000200062O000100482O013O0004223O00482O012O000300015O0020B200010001002C0020B70001000100272O00F60001000200020006300001002B2O0100010004223O002B2O012O000300015O0020B20001000100160020B70001000100092O00F6000100020002000EC5002800372O0100010004223O00372O012O000300015O0020B20001000100160020B700010001002D2O00F60001000200020026322O0100372O0100010004223O00372O012O000300015O0020B20001000100160020B70001000100092O00F6000100020002000EC0002800482O0100010004223O00482O012O0003000100034O00A300025O00202O0002000200254O000300043O00202O00030003001800122O000500196O0003000500024O000300036O000400016O00010004000200062O000100482O013O0004223O00482O012O0003000100053O00126C0002002E3O00126C0003002F4O005B000100034O00BC00016O000300015O0020B20001000100300020B70001000100102O00F600010002000200062C2O0100842O013O0004223O00842O012O0003000100123O00062C2O0100842O013O0004223O00842O012O0003000100043O00202E0001000100314O00035O00202O0003000300324O00010003000200062O000100842O013O0004223O00842O012O0003000100023O0020212O01000100114O0001000200024O000200023O00202O00020002001C4O00020002000200062O000100842O0100020004223O00842O012O0003000100023O00202E00010001002A4O00035O00202O00030003002B4O00010003000200062O000100842O013O0004223O00842O012O0003000100073O000EC5003300732O0100010004223O00732O012O0003000100083O000EC5003300732O0100010004223O00732O012O000300015O0020B20001000100340020B70001000100272O00F6000100020002000630000100842O0100010004223O00842O012O0003000100034O001400025O00202O0002000200304O000300043O00202O00030003000C4O00055O00202O0005000500304O0003000500024O000300036O00010003000200062O000100842O013O0004223O00842O012O0003000100053O00126C000200353O00126C000300364O005B000100034O00BC00015O00126C3O00023O0004223O000100012O00063O00017O003B3O00028O00030E3O00546F7563686F667468654D61676903073O004973526561647903083O005072657647434450026O00F03F030D3O00417263616E6542612O7261676503193O00BFCC5E454B75344B94D72O437C473A4AA28346474A447B1EFB03083O002DCBA32B26232A5B030C3O0049734368612O6E656C696E6703093O0045766F636174696F6E030E3O004D616E6150657263656E74616765025O00C05740030B3O00536970686F6E53746F726D030B3O004973417661696C61626C65026O001040026O002440030B3O00417263616E655375726765030F3O00432O6F6C646F776E52656D61696E73030B3O0053746F7043617374696E67031F3O00D184D22082A56BD386C82A88A714D793D32086BD5DDD8B9C2E86A05A92D68E03073O0034B2E5BC43E7C9027O0040030E3O0049735370652O6C496E52616E676503163O00202O5305F9591C23404216F65B26614C510DF91C707503073O004341213064973C030A3O0049734361737461626C6503083O0042752O66446F776E030F3O00417263616E65537572676542752O66030A3O00446562752O66446F776E03143O00546F7563686F667468654D616769446562752O66026O003440026O002E4003113O00DAF1A1DBF2CBEEA1D6B3D2E6A7D6B38CB103053O0093BF87CEB8030E3O00436F6E6A7572654D616E6147656D026O003E4003073O004D616E6147656D03063O0045786973747303183O008727A8CBCD41B7BB25A7CFD96CB58125E6CCD95ABCC47BFE03073O00D2E448C6A1B833030E3O00436173636164696E67506F77657203093O0042752O66537461636B03103O00436C65617263617374696E6742752O6603063O0042752O66557003103O003B48FD114CC93344B31D72C73809A74003063O00AE5629937013026O000840030C3O0052616469616E74537061726B03083O00446562752O66557003103O005601830A1A0814A61B0D8C022B4F45F903083O00CB3B60ED6B456F71030D3O004E657468657254656D70657374030A3O00417263616E654563686F03123O00417263616E654F7665726C6F616442752O66025O00804640030A3O00432O6F6C646F776E557003123O0052616469616E74537061726B446562752O6603193O0052616469616E74537061726B56756C6E65726162696C697479026O0014400075022O00126C3O00013O00261A3O0077000100010004223O007700012O000300015O0020B20001000100020020B70001000100032O00F600010002000200062C2O01002C00013O0004223O002C00012O0003000100013O00062C2O01002C00013O0004223O002C00012O0003000100023O00062C2O01001200013O0004223O001200012O0003000100033O00063000010015000100010004223O001500012O0003000100023O0006300001002C000100010004223O002C00012O0003000100044O0003000200053O00068A0001002C000100020004223O002C00012O0003000100063O0020FC00010001000400122O000300056O00045O00202O0004000400064O00010004000200062O0001002C00013O0004223O002C00012O0003000100074O000300025O0020B20002000200022O00F600010002000200062C2O01002C00013O0004223O002C00012O0003000100083O00126C000200073O00126C000300084O005B000100034O00BC00016O0003000100063O00202E0001000100094O00035O00202O00030003000A4O00010003000200062O0001005900013O0004223O005900012O0003000100063O0020B700010001000B2O00F6000100020002000EFB000C003E000100010004223O003E00012O000300015O0020B200010001000D0020B700010001000E2O00F600010002000200062C2O01004E00013O0004223O004E00012O0003000100063O0020E700010001000B4O0001000200024O000200053O00202O00020002000F00062O00020059000100010004223O005900012O0003000100053O000EC00010004E000100010004223O004E00012O000300015O0020B20001000100110020B70001000100122O00F60001000200020026AC00010059000100050004223O005900012O0003000100074O0003000200093O0020B20002000200132O00F600010002000200062C2O01005900013O0004223O005900012O0003000100083O00126C000200143O00126C000300154O005B000100034O00BC00016O000300015O0020B20001000100060020B70001000100032O00F600010002000200062C2O01007600013O0004223O007600012O00030001000A3O00062C2O01007600013O0004223O007600012O0003000100053O00261300010076000100160004223O007600012O0003000100074O001400025O00202O0002000200064O0003000B3O00202O0003000300174O00055O00202O0005000500064O0003000500024O000300036O00010003000200062O0001007600013O0004223O007600012O0003000100083O00126C000200183O00126C000300194O005B000100034O00BC00015O00126C3O00053O00261A3O00142O0100050004223O00142O012O000300015O0020B200010001000A0020B700010001001A2O00F600010002000200062C2O0100B600013O0004223O00B600012O00030001000C3O00062C2O0100B600013O0004223O00B600012O00030001000D3O000630000100B6000100010004223O00B600012O0003000100063O00202E00010001001B4O00035O00202O00030003001C4O00010003000200062O000100B600013O0004223O00B600012O00030001000B3O00202E00010001001D4O00035O00202O00030003001E4O00010003000200062O000100B600013O0004223O00B600012O0003000100063O0020B700010001000B2O00F60001000200020026130001009E000100100004223O009E00012O000300015O0020B20001000100020020B70001000100122O00F60001000200020026AC000100A40001001F0004223O00A400012O000300015O0020B20001000100020020B70001000100122O00F6000100020002002613000100B6000100200004223O00B600012O0003000100063O0020E700010001000B4O0001000200024O000200053O00202O00020002000F00062O000100B6000100020004223O00B600012O0003000100074O000300025O0020B200020002000A2O00F600010002000200062C2O0100B600013O0004223O00B600012O0003000100083O00126C000200213O00126C000300224O005B000100034O00BC00016O000300015O0020B20001000100230020B700010001001A2O00F600010002000200062C2O0100EB00013O0004223O00EB00012O00030001000E3O00062C2O0100EB00013O0004223O00EB00012O00030001000B3O00202E00010001001D4O00035O00202O00030003001E4O00010003000200062O000100EB00013O0004223O00EB00012O0003000100063O00202E00010001001B4O00035O00202O00030003001C4O00010003000200062O000100EB00013O0004223O00EB00012O000300015O0020B20001000100110020B70001000100122O00F6000100020002002613000100EB000100240004223O00EB00012O000300015O0020242O010001001100202O0001000100124O0001000200024O000200053O00062O000100EB000100020004223O00EB00012O00030001000F3O0020B20001000100250020B70001000100262O00F6000100020002000630000100EB000100010004223O00EB00012O0003000100074O000300025O0020B20002000200232O00F600010002000200062C2O0100EB00013O0004223O00EB00012O0003000100083O00126C000200273O00126C000300284O005B000100034O00BC00016O00030001000F3O0020B20001000100250020B70001000100032O00F600010002000200062C2O0100132O013O0004223O00132O012O0003000100103O00062C2O0100132O013O0004223O00132O012O000300015O0020B20001000100290020B700010001000E2O00F600010002000200062C2O0100132O013O0004223O00132O012O0003000100063O00201900010001002A4O00035O00202O00030003002B4O00010003000200262O000100132O0100160004223O00132O012O0003000100063O00202E00010001002C4O00035O00202O00030003001C4O00010003000200062O000100132O013O0004223O00132O012O0003000100074O0003000200093O0020B20002000200252O00F600010002000200062C2O0100132O013O0004223O00132O012O0003000100083O00126C0002002D3O00126C0003002E4O005B000100034O00BC00015O00126C3O00163O00261A3O006B2O01002F0004223O006B2O012O0003000100113O00062C2O01002F2O013O0004223O002F2O012O000300015O0020B20001000100300020B700010001000E2O00F600010002000200062C2O01002F2O013O0004223O002F2O012O0003000100123O00062C2O01002F2O013O0004223O002F2O0100126C000100013O00261A000100232O0100010004223O00232O012O0003000200144O004E0002000100022O00CA000200134O0003000200133O00062C0102002F2O013O0004223O002F2O012O0003000200134O0027000200023O0004223O002F2O010004223O00232O012O0003000100113O00062C2O01004B2O013O0004223O004B2O012O0003000100153O00062C2O01004B2O013O0004223O004B2O012O000300015O0020B20001000100300020B700010001000E2O00F600010002000200062C2O01004B2O013O0004223O004B2O012O0003000100163O00062C2O01004B2O013O0004223O004B2O0100126C000100013O00261A0001003F2O0100010004223O003F2O012O0003000200174O004E0002000100022O00CA000200134O0003000200133O00062C0102004B2O013O0004223O004B2O012O0003000200134O0027000200023O0004223O004B2O010004223O003F2O012O0003000100113O00062C2O01006A2O013O0004223O006A2O012O00030001000B3O00202E0001000100314O00035O00202O00030003001E4O00010003000200062O0001006A2O013O0004223O006A2O012O0003000100184O0003000200193O00063200020005000100010004223O005D2O012O00030001001A4O0003000200193O0006110102006A2O0100010004223O006A2O0100126C000100013O00261A0001005E2O0100010004223O005E2O012O00030002001B4O004E0002000100022O00CA000200134O0003000200133O00062C0102006A2O013O0004223O006A2O012O0003000200134O0027000200023O0004223O006A2O010004223O005E2O0100126C3O000F3O00261A3O002E020100160004223O002E02012O00030001000F3O0020B20001000100250020B70001000100032O00F600010002000200062C2O01009D2O013O0004223O009D2O012O0003000100103O00062C2O01009D2O013O0004223O009D2O012O000300015O0020B20001000100290020B700010001000E2O00F60001000200020006300001009D2O0100010004223O009D2O012O0003000100063O0020FC00010001000400122O000300056O00045O00202O0004000400114O00010004000200062O0001009D2O013O0004223O009D2O012O00030001001C3O00062C2O0100922O013O0004223O00922O012O00030001001C3O00062C2O01009D2O013O0004223O009D2O012O0003000100063O0020FC00010001000400122O000300166O00045O00202O0004000400114O00010004000200062O0001009D2O013O0004223O009D2O012O0003000100074O0003000200093O0020B20002000200252O00F600010002000200062C2O01009D2O013O0004223O009D2O012O0003000100083O00126C000200323O00126C000300334O005B000100034O00BC00016O0003000100153O000630000100EC2O0100010004223O00EC2O012O000300015O0020262O010001001100202O0001000100124O0001000200024O0002001D6O0003001E6O00045O00202O00040004003400202O00040004000E4O00040002000200062O000400B02O013O0004223O00B02O012O000300045O0020B20004000400350020B700040004000E2O00F60004000200022O00F600030002000200102A0003000500032O003E0002000200030006320001000F000100020004223O00C32O012O0003000100063O00202O00010001002C4O00035O00202O00030003001C4O00010003000200062O000100C32O0100010004223O00C32O012O0003000100063O00202E00010001002C4O00035O00202O0003000300364O00010003000200062O000100EC2O013O0004223O00EC2O012O000300015O0020B200010001000A0020B70001000100122O00F6000100020002000EC0003700EC2O0100010004223O00EC2O012O000300015O00209600010001000200202O0001000100124O0001000200024O0002001D3O00202O00020002000F00062O000100D72O0100020004223O00D72O012O000300015O0020B20001000100020020B70001000100122O00F6000100020002000EC0001F00EC2O0100010004223O00EC2O012O0003000100184O0003000200193O00068A000100EC2O0100020004223O00EC2O012O00030001001A4O0003000200193O00068A000100EC2O0100020004223O00EC2O0100126C000100013O00261A000100E02O0100010004223O00E02O012O00030002001F4O004E0002000100022O00CA000200134O0003000200133O00062C010200EC2O013O0004223O00EC2O012O0003000200134O0027000200023O0004223O00EC2O010004223O00E02O012O0003000100153O0006300001002D020100010004223O002D02012O000300015O0020B20001000100110020B70001000100122O00F6000100020002000EC00024002D020100010004223O002D02012O000300015O0020B20001000100300020B70001000100382O00F600010002000200063000010009020100010004223O000902012O00030001000B3O00202O0001000100314O00035O00202O0003000300394O00010003000200062O00010009020100010004223O000902012O00030001000B3O00202E0001000100314O00035O00202O00030003003A4O00010003000200062O0001002D02013O0004223O002D02012O000300015O0020DD00010001000200202O0001000100124O0001000200024O0002001D3O00202O00020002002F00062O00010008000100020004223O001802012O00030001000B3O00202E0001000100314O00035O00202O00030003001E4O00010003000200062O0001002D02013O0004223O002D02012O0003000100184O0003000200193O00068A0001002D020100020004223O002D02012O00030001001A4O0003000200193O00068A0001002D020100020004223O002D020100126C000100013O00261A00010021020100010004223O002102012O00030002001F4O004E0002000100022O00CA000200134O0003000200133O00062C0102002D02013O0004223O002D02012O0003000200134O0027000200023O0004223O002D02010004223O0021020100126C3O002F3O00261A3O00360201003B0004223O003602012O0003000100133O00062C2O01007402013O0004223O007402012O0003000100134O0027000100023O0004223O0074020100261A3O00010001000F0004223O000100012O0003000100113O00062C2O01005A02013O0004223O005A02012O0003000100153O00062C2O01005A02013O0004223O005A02012O00030001000B3O00202E0001000100314O00035O00202O00030003001E4O00010003000200062O0001005A02013O0004223O005A02012O0003000100184O0003000200193O00063200020005000100010004223O004D02012O00030001001A4O0003000200193O0006110102005A020100010004223O005A020100126C000100013O000ECE0001004E020100010004223O004E02012O0003000200204O004E0002000100022O00CA000200134O0003000200133O00062C0102005A02013O0004223O005A02012O0003000200134O0027000200023O0004223O005A02010004223O004E02012O0003000100184O0003000200193O00063200020005000100010004223O006202012O00030001001A4O0003000200193O0006110102006F020100010004223O006F020100126C000100013O00261A00010063020100010004223O006302012O0003000200214O004E0002000100022O00CA000200134O0003000200133O00062C0102006F02013O0004223O006F02012O0003000200134O0027000200023O0004223O006F02010004223O006302012O0003000100224O004E0001000100022O00CA000100133O00126C3O003B3O0004223O000100012O00063O00017O00613O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030E3O003105A9C023F3D62A138EED30E3C303073O00B74476CC81519003103O001BBE75C519810FA375C60A901CAC77E103063O00E26ECD10846B03123O00FED0E5F853E8C2EEDC64F3D3ECD652E2CCEE03053O00218BA380B903113O00424B01FF455B05D0527E05D35E540DDF4503043O00BE373864026O00F03F026O001840030C3O0043BC393F1FF7F6449B35131603073O009336CF5C7E738303133O001822304D1F771E3C3469047D2F30276F047B1F03063O001E6D51551D6D03163O00EA62519124DBFDEB74469F38C8F5EC7856BF3AD7E8E603073O009C9F1134D656BE030B3O00BBFCB895ADEA9FB0A1ECB603043O00DCCE8FDD026O001C40026O00244003153O008B743F05D7DEFB8B7C2A12FAC9D4896F2827CDC0DE03073O00B2E61D4D77B8AC031B3O00E0AD0F2972F5FAA80F3862EAE6BB3D1263F0D4B80C177EFBE1BB0E03063O009895DE6A7B17027O0040030A3O00C835F36EB4D327D146B803053O00D5BD46962303103O005A4671264A417C0D5D6171055F50671C03043O00682F351403113O00B65F842CAE0AB0498F1FB920A5618812B803063O006FC32CE17CDC030F3O00CD550550A4BED6520561B8BBDD4A0C03063O00CBB8266013CB026O000840030A3O002C607C68CD3C50764DCA03053O00AE59131921030E3O003A015763F694180D13405CFE821903073O006B4F72322E97E7030E3O002CB5B004832BA5CF2B8FB8288D3C03083O00A059C6D549EA59D7030B3O00497DA0FBD77C78B9FBED7803053O00A52811D49E026O002040026O00144003133O00F6D1013532ECD70F0329F2DC1A042FF1D12B1703053O004685B9685303133O000557472BC7016A5628FE0D514C07C00A4C670E03053O00A96425244A03163O001286A6590189B6631086B05B378EB6582D8EAC5923A303043O003060E7C203183O00DC551B2E11F7A9B7C05F232C1ED1988ADC52232417D18CA703083O00E3A83A6E4D79B8CF026O001040030C3O006E2FBA61A3D870AB7E13AD4203083O00C51B5CDF20D1BB11030F3O00164CC6C9025BCAFA0D4BF0EB024DC803043O009B633FA303113O0097C2A4B9B69181D98E8B8D8C87FCA08AB003063O00E4E2B1C1EDD903113O0035A220E73AB510F326B726D13DA42BC51003043O008654D043026O002240030D3O001EA5944E1CBEAF5112AB83742303043O003C73CCE6030D3O00EA3BF863C53BF962EE3FF958D703043O0010875A8B03133O00416703005E5174584712364F584C556601365A03073O0018341466532E3403153O00D13C241006C92A16251DD418283007F02E2D2101D003053O006FA44F414403123O00D6CB8ACD23EBD2D080FC2FF8D4D086CC06DA03063O008AA6B9E3BE4E03153O00CC66C03646260BE27AD33E412A1BC278CC234B0B2903073O0079AB14A5573243030A3O00CF3BBC14B50DC533910603063O0062A658D956D903093O00FFF57C2289D0F2DE4903063O00BC2O961961E6030C3O00CF9A5A2000ECC99D68031AE803063O008DBAE93F626C03103O00E4F9299237F0ED23B836D3F829B731F903053O0045918A4CD6030E3O0065DC8CA8AD1571C18CBAAA0477CA03063O007610AF2OE9DF03103O009E973088E6827B9F8D3BBCDE846A8E9603073O001DEBE455DB8EEB03123O0028C7BFFC654D265C38FDB4C972422B573EC003083O00325DB4DABD172E4703113O00CBB75E6D56DF49D0A1764557CF41D2A14803073O0028BEC43B2C24BC03113O002956D997F573072957D999FB730C1B40D103073O006D5C25BCD49A1D030C3O0011FCA1E6275507EEB0CA3E5403063O003A648FC4A3510089012O00126C3O00013O00261A3O0024000100010004223O00240001001245000100023O0020222O01000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O00122O000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100033O00122O000100023O00202O0001000100034O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100043O00124O000C3O00261A3O00470001000D0004223O00470001001245000100023O0020222O01000100034O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00122O000100023O00202O0001000100034O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100073O00122O000100023O00202O0001000100034O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100083O00124O00163O00261A3O005A000100170004223O005A0001001245000100023O0020DC0001000100034O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O001245000100023O00205C0001000100034O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00044O00882O0100261A3O007D0001001C0004223O007D0001001245000100023O0020222O01000100034O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00122O000100023O00202O0001000100034O000200013O00122O0003001F3O00122O000400206O0002000400024O0001000100024O0001000C3O00122O000100023O00202O0001000100034O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00122O000100023O00202O0001000100034O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00124O00253O00261A3O00A3000100160004223O00A30001001245000100023O00201E2O01000100034O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O0001000F3O00122O000100023O00202O0001000100034O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O000100103O00122O000100023O00202O0001000100034O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100113O00122O000100023O00202O0001000100034O000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200062O000100A1000100010004223O00A1000100126C000100014O00CA000100123O00126C3O002E3O00261A3O00C60001002F0004223O00C60001001245000100023O0020222O01000100034O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100133O00122O000100023O00202O0001000100034O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100143O00122O000100023O00202O0001000100034O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100153O00122O000100023O00202O0001000100034O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000100163O00124O000D3O00261A3O00E9000100380004223O00E90001001245000100023O0020222O01000100034O000200013O00122O000300393O00122O0004003A6O0002000400024O0001000100024O000100173O00122O000100023O00202O0001000100034O000200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100183O00122O000100023O00202O0001000100034O000200013O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O000100193O00122O000100023O00202O0001000100034O000200013O00122O0003003F3O00122O000400406O0002000400024O0001000100024O0001001A3O00124O002F3O00261A3O00122O0100410004223O00122O01001245000100023O0020B40001000100034O000200013O00122O000300423O00122O000400436O0002000400024O00010001000200062O000100F5000100010004223O00F5000100126C000100014O00CA0001001B3O00127F000100023O00202O0001000100034O000200013O00122O000300443O00122O000400456O0002000400024O00010001000200062O00012O002O0100010004224O002O0100126C000100014O00CA0001001C3O0012302O0100023O00202O0001000100034O000200013O00122O000300463O00122O000400476O0002000400024O0001000100024O0001001D3O00122O000100023O00202O0001000100034O000200013O00122O000300483O00122O000400496O0002000400024O0001000100024O0001001E3O00124O00173O000ECE002E00412O013O0004223O00412O01001245000100023O0020B40001000100034O000200013O00122O0003004A3O00122O0004004B6O0002000400024O00010001000200062O0001001E2O0100010004223O001E2O0100126C000100014O00CA0001001F3O00127F000100023O00202O0001000100034O000200013O00122O0003004C3O00122O0004004D6O0002000400024O00010001000200062O000100292O0100010004223O00292O0100126C000100014O00CA000100203O00127F000100023O00202O0001000100034O000200013O00122O0003004E3O00122O0004004F6O0002000400024O00010001000200062O000100342O0100010004223O00342O0100126C000100014O00CA000100213O00127F000100023O00202O0001000100034O000200013O00122O000300503O00122O000400516O0002000400024O00010001000200062O0001003F2O0100010004223O003F2O0100126C000100014O00CA000100223O00126C3O00413O000ECE002500642O013O0004223O00642O01001245000100023O0020222O01000100034O000200013O00122O000300523O00122O000400536O0002000400024O0001000100024O000100233O00122O000100023O00202O0001000100034O000200013O00122O000300543O00122O000400556O0002000400024O0001000100024O000100243O00122O000100023O00202O0001000100034O000200013O00122O000300563O00122O000400576O0002000400024O0001000100024O000100253O00122O000100023O00202O0001000100034O000200013O00122O000300583O00122O000400596O0002000400024O0001000100024O000100263O00124O00383O00261A3O00010001000C0004223O00010001001245000100023O0020222O01000100034O000200013O00122O0003005A3O00122O0004005B6O0002000400024O0001000100024O000100273O00122O000100023O00202O0001000100034O000200013O00122O0003005C3O00122O0004005D6O0002000400024O0001000100024O000100283O00122O000100023O00202O0001000100034O000200013O00122O0003005E3O00122O0004005F6O0002000400024O0001000100024O000100293O00122O000100023O00202O0001000100034O000200013O00122O000300603O00122O000400616O0002000400024O0001000100024O0001002A3O00124O001C3O0004223O000100012O00063O00017O002A3O00028O00027O0040030C3O004570696353652O74696E677303083O0053652O74696E6773030E3O000E502AAD344CF11D2D4B37AB1C6D03083O006E7A2243C35F2985030D3O0067B05843D779A26C43C27D927F03053O00B615D13B2A030E3O00A244C03524BFBB43CD0E35B1B95203063O00DED737A57D4103103O0039C2C332F7C0E14322D6F615E6C8E24403083O002A4CB1A67A92A18D026O000840030D3O00AD8F04C26D7EB69E0AC07C5E9503063O0016C5EA65AE19030F3O002531A4D07FA1D0B62220ACD37887E703083O00E64D54C5BC16CFB703113O00D111C7F085AFF705F600CFF3828FF138FC03083O00559974A69CECC190034O00030F3O00ACE143B7E80585E64BBFED03B0E54903063O0060C4802DD384026O00104003113O0033847C57C69DB1D53484754CF1A7B1DB3E03083O00B855ED1B3FB2CFD403113O0021571D5A1A4B1C4F1C6E004B006A1D4A0603043O003F68396903163O002289B0411995B1541FA8AA4812B0AC4D1F82A84D189303043O00246BE7C403123O0074BBB6824FA7B7974981AA9558A6AA8851B103043O00E73DD5C2026O00F03F030D3O002DA42E630CA119760BB83B751A03043O001369CD5D030B3O008D01CD913AA52ACB8739BA03053O005FC968BEE1030B3O00BAD8C4FABDC2CFC5AADFD203043O00AECFABA1030A3O00F8ED08C1F9D4E4FF01E003063O00B78D9E6D939803113O000408E808200CCF022F06F41C231BE30D2003043O006C4C698600A63O00126C3O00013O00261A3O0024000100020004223O00240001001245000100033O0020222O01000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O00261A3O00500001000D0004223O00500001001245000100033O0020B40001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O00010001000200062O00010030000100010004223O0030000100126C000100014O00CA000100053O00127F000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O00010001000200062O0001003B000100010004223O003B000100126C000100014O00CA000100063O00127F000100033O00202O0001000100044O000200013O00122O000300123O00122O000400136O0002000400024O00010001000200062O00010046000100010004223O0046000100126C000100144O00CA000100073O00129A000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00124O00173O00261A3O0076000100010004223O00760001001245000100033O0020B40001000100044O000200013O00122O000300183O00122O000400196O0002000400024O00010001000200062O0001005C000100010004223O005C000100126C000100014O00CA000100093O00124F000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00124O00203O00261A3O0099000100200004223O00990001001245000100033O0020222O01000100044O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O000100103O00124O00023O000ECE0017000100013O0004223O00010001001245000100033O00205C0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00044O00A500010004223O000100012O00063O00017O005F3O00028O00026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00EACAB403053O00AE8BA5D1812O033O00A0B7F103083O0018C3D382A1A6631003073O004B0AE72550125503063O00762663894C33027O00402O033O00F2290603063O00409D46657269026O001040030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174024O0080B3C540030C3O00466967687452656D61696E73030F3O00456E656D69657334307952616E6765030B3O0052656D6F7665437572736503073O004973526561647903093O00466F637573556E6974026O00344003103O00426F2O73466967687452656D61696E732O033O00474344030F3O0048616E646C65412O666C696374656403143O0052656D6F766543757273654D6F7573656F766572026O003E40026O00144003063O0044A1B4F3154C03053O007020C8C783030D3O004973446561644F7247686F737403173O00476574456E656D696573496E53706C61736852616E6765026O000840030F3O00417263616E65496E74652O6C656374030A3O0049734361737461626C6503083O0042752O66446F776E03103O0047726F757042752O664D692O73696E67031B3O002D425FB9CDAE1D255E48BDCFA7272F441CBFD1A4373C6F5EADC5AD03073O00424C303CD8A3CB030E3O00417263616E6546616D696C69617203123O00417263616E6546616D696C69617242752O66031B3O00BB947AF251CB1BBC8774FA53C725A8C669E15ACD2BB78478E71F9C03073O0044DAE619933FAE030E3O00436F6E6A7572654D616E6147656D031C3O00AE255D46A3BF2F6C41B7A32B6C4BB3A06A435EB3AE255E4EB7B96A0703053O00D6CD4A332C03053O00466F63757303113O0048616E646C65496E636F72706F7265616C03093O00506F6C796D6F72706803123O00506F6C796D6F7270684D6F7573654F766572030A3O005370652O6C737465616C030B3O004973417661696C61626C6503093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030E3O0049735370652O6C496E52616E676503113O00E95CE7F07BE958E7FD7BBA48E3F176FD4903053O00179A2C829C030F3O0048616E646C65445053506F74696F6E030B3O00417263616E65537572676503083O0054696D655761727003123O00426C2O6F646C757374457868617573745570030C3O0054656D706F72616C57617270026O00444003063O0042752O665570030F3O00417263616E65537572676542752O66026O00544003103O0005AFA0AB090410B4BDEE3B1218A8EDFA03063O007371C6CDCE56030E3O004C69676874734A7564676D656E74030A3O00446562752O66446F776E03143O00546F7563686F667468654D616769446562752O6603163O00885EF9529044C1509153F9578159EA1A8956F754C40103043O003AE4379E030A3O004265727365726B696E6703083O00507265764743445003103O0054656D706F72616C5761727042752O66030B3O00426C2O6F646C757374557003083O00446562752O66557003113O00B68CC23D39BF3EBD87D76E31AC3CBAC98803073O0055D4E9B04E5CCD030D3O00416E6365737472616C43612O6C03163O004B568BE7594C9AE346678BE34654C8EF4B5186A21B0C03043O00822A38E803093O00426C2O6F644675727903123O00E8B92BEC4400ECA036FA0032EBBC2AA3116F03063O005F8AD544832003093O0046697265626C2O6F6403113O002C21B346742627AE47362729A84D367B7A03053O00164A48C12303163O00476574456E656D696573496E4D656C2O6552616E676503113O00476574456E656D696573496E52616E67652O033O006D6178031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74002F032O00126C3O00013O00261A3O001C000100020004223O001C0001001245000100033O0020DC0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O0012302O0100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00124O000B3O00261A3O002B000100010004223O002B00012O0003000100044O00F10001000100014O000100056O00010001000100122O000100033O00202O0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100063O00124O00023O00261A3O00970001000E0004223O009700012O0003000100073O0020B200010001000F2O004E00010001000200063000010037000100010004223O003700012O0003000100083O0020B70001000100102O00F600010002000200062C2O01007900013O0004223O0079000100126C000100013O000ECE00020046000100010004223O004600012O00030002000A4O00CA000200094O0003000200093O00261A00020079000100110004223O007900012O00030002000B3O00203900020002001200122O000300136O00048O0002000400024O000200093O00044O00790001000ECE00010038000100010004223O003800012O0003000200083O0020B70002000200102O00F600020002000200063000020050000100010004223O005000012O00030002000C3O00062C0102007100013O0004223O0071000100126C000200014O0003010300033O00261A0002005A000100020004223O005A00012O00030004000D3O00062C0104007100013O0004223O007100012O00030004000D4O0027000400023O0004223O0071000100261A00020052000100010004223O005200012O00030004000C3O00060A01030066000100040004223O006600012O00030004000E3O0020B20004000400140020B70004000400152O00F600040002000200060A01030066000100040004223O006600012O00030003000F4O0003000400073O0020EF0004000400164O000500036O000600103O00122O000700176O000800083O00122O000900176O0004000900024O0004000D3O00122O000200023O00044O005200012O00030002000B3O0020B30002000200184O000300036O000400016O0002000400024O0002000A3O00122O000100023O00044O003800012O0003000100083O0020170001000100194O0001000200024O000100116O000100123O00062O0001009600013O0004223O009600012O0003000100133O00062C2O01009600013O0004223O0096000100126C000100013O00261A00010084000100010004223O008400012O0003000200073O00204800020002001A4O0003000E3O00202O0003000300144O000400103O00202O00040004001B00122O0005001C6O0002000500024O0002000D6O0002000D3O00062O0002009600013O0004223O009600012O00030002000D4O0027000200023O0004223O009600010004223O0084000100126C3O001D3O00261A3O00AD0001000B0004223O00AD0001001245000100033O0020DC0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000F4O0003000100083O0020B70001000100202O00F600010002000200062C2O0100A700013O0004223O00A700012O00063O00014O0003000100153O00207E00010001002100122O0003001D6O0001000300024O000100143O00124O00223O00261A3O00020301001D0004223O000203012O0003000100083O0020B70001000100102O00F60001000200020006300001000E2O0100010004223O000E2O0100126C000100013O00261A000100F6000100010004223O00F600012O00030002000E3O0020B20002000200230020B70002000200242O00F600020002000200062C010200DA00013O0004223O00DA00012O0003000200163O00062C010200DA00013O0004223O00DA00012O0003000200083O0020410002000200254O0004000E3O00202O0004000400234O000500016O00020005000200062O000200CF000100010004223O00CF00012O0003000200073O0020740002000200264O0003000E3O00202O0003000300234O00020002000200062O000200DA00013O0004223O00DA00012O0003000200174O00030003000E3O0020B20003000300232O00F600020002000200062C010200DA00013O0004223O00DA00012O0003000200013O00126C000300273O00126C000400284O005B000200044O00BC00026O00030002000E3O0020B20002000200290020B70002000200242O00F600020002000200062C010200F500013O0004223O00F500012O0003000200183O00062C010200F500013O0004223O00F500012O0003000200083O00202E0002000200254O0004000E3O00202O00040004002A4O00020004000200062O000200F500013O0004223O00F500012O0003000200174O00030003000E3O0020B20003000300292O00F600020002000200062C010200F500013O0004223O00F500012O0003000200013O00126C0003002B3O00126C0004002C4O005B000200044O00BC00025O00126C000100023O00261A000100B5000100020004223O00B500012O00030002000E3O0020B200020002002D0020B70002000200242O00F600020002000200062C0102000E2O013O0004223O000E2O012O0003000200193O00062C0102000E2O013O0004223O000E2O012O0003000200174O00030003000E3O0020B200030003002D2O00F600020002000200062C0102000E2O013O0004223O000E2O012O0003000200013O0012620003002E3O00122O0004002F6O000200046O00025O00044O000E2O010004223O00B500012O0003000100073O0020B200010001000F2O004E00010001000200062C2O01002E03013O0004223O002E030100126C000100013O00261A0001001F2O0100020004223O001F2O012O00030002001A4O004E0002000100022O00CA0002000D4O00030002000D3O00062C0102001E2O013O0004223O001E2O012O00030002000D4O0027000200023O00126C0001000B3O00261A0001004A2O0100010004223O004A2O01001245000200303O00062C010200342O013O0004223O00342O012O00030002000C3O00062C010200342O013O0004223O00342O0100126C000200013O00261A000200282O0100010004223O00282O012O00030003001B4O004E0003000100022O00CA0003000D4O00030003000D3O00062C010300342O013O0004223O00342O012O00030003000D4O0027000300023O0004223O00342O010004223O00282O012O0003000200083O0020B70002000200102O00F6000200020002000630000200492O0100010004223O00492O012O0003000200063O00062C010200492O013O0004223O00492O0100126C000200013O000ECE0001003D2O0100020004223O003D2O012O00030003001C4O004E0003000100022O00CA0003000D4O00030003000D3O00062C010300492O013O0004223O00492O012O00030003000D4O0027000300023O0004223O00492O010004223O003D2O0100126C000100023O00261A0001007D2O01000B0004223O007D2O012O0003000200123O00062C010200652O013O0004223O00652O012O0003000200133O00062C010200652O013O0004223O00652O0100126C000200013O00261A000200532O0100010004223O00532O012O0003000300073O00204800030003001A4O0004000E3O00202O0004000400144O000500103O00202O00050005001B00122O0006001C6O0003000600024O0003000D6O0003000D3O00062O000300652O013O0004223O00652O012O00030003000D4O0027000300023O0004223O00652O010004223O00532O012O00030002001D3O00062C0102007C2O013O0004223O007C2O0100126C000200013O00261A000200692O0100010004223O00692O012O0003000300073O0020750003000300314O0004000E3O00202O0004000400324O000500103O00202O00050005003300122O0006001C6O000700016O0003000700024O0003000D6O0003000D3O00062C0103007C2O013O0004223O007C2O012O00030003000D4O0027000300023O0004223O007C2O010004223O00692O0100126C000100223O000ECE002200142O0100010004223O00142O012O00030002000E3O0020B20002000200340020B70002000200352O00F600020002000200062C010200B52O013O0004223O00B52O012O00030002001E3O00062C010200B52O013O0004223O00B52O012O00030002000E3O0020B20002000200340020B70002000200152O00F600020002000200062C010200B52O013O0004223O00B52O012O00030002000F3O00062C010200B52O013O0004223O00B52O012O00030002001F3O00062C010200B52O013O0004223O00B52O012O0003000200083O0020B70002000200362O00F6000200020002000630000200B52O0100010004223O00B52O012O0003000200083O0020B70002000200372O00F6000200020002000630000200B52O0100010004223O00B52O012O0003000200073O0020B20002000200382O0003000300154O00F600020002000200062C010200B52O013O0004223O00B52O012O0003000200174O00140003000E3O00202O0003000300344O000400153O00202O0004000400394O0006000E3O00202O0006000600344O0004000600024O000400046O00020004000200062O000200B52O013O0004223O00B52O012O0003000200013O00126C0003003A3O00126C0004003B4O005B000200044O00BC00026O0003000200083O0020B70002000200362O00F60002000200020006300002002E030100010004223O002E03012O0003000200083O0020B70002000200372O00F60002000200020006300002002E030100010004223O002E03012O0003000200083O0020B70002000200102O00F600020002000200062C0102002E03013O0004223O002E03012O0003000200073O0020B200020002000F2O004E00020001000200062C0102002E03013O0004223O002E030100126C000200014O0003010300033O00261A000200EE2O01000B0004223O00EE2O012O0003000400204O0003000500093O00068A000400EA2O0100050004223O00EA2O012O0003000400213O00062C010400EA2O013O0004223O00EA2O012O0003000400023O00062C010400DA2O013O0004223O00DA2O012O0003000400223O000630000400DD2O0100010004223O00DD2O012O0003000400223O000630000400EA2O0100010004223O00EA2O0100126C000400013O00261A000400DE2O0100010004223O00DE2O012O0003000500234O004E0005000100022O00CA0005000D4O00030005000D3O00062C010500EA2O013O0004223O00EA2O012O00030005000D4O0027000500023O0004223O00EA2O010004223O00DE2O012O0003000400244O004E0004000100022O00CA0004000D3O00126C000200223O00261A000200F92O0100220004223O00F92O012O00030004000D3O00062C010400F52O013O0004223O00F52O012O00030004000D4O0027000400024O0003000400254O004E0004000100022O00CA0004000D3O00126C0002000E3O000ECE00010008020100020004223O000802012O0003000400073O00200400040004003C4O0005000E3O00202O00050005003D00202O0005000500154O0005000200024O000500056O0004000200024O000300043O00062O0003000702013O0004223O000702012O0027000300023O00126C000200023O00261A000200100201000E0004223O001002012O00030004000D3O00062C0104002E03013O0004223O002E03012O00030004000D4O0027000400023O0004223O002E030100261A000200CB2O0100020004223O00CB2O012O0003000400263O00062C0104004402013O0004223O004402012O00030004000E3O0020B200040004003E0020B70004000400242O00F600040002000200062C0104004402013O0004223O004402012O0003000400083O0020B700040004003F2O00F600040002000200062C0104004402013O0004223O004402012O00030004000E3O0020B20004000400400020B70004000400352O00F600040002000200062C0104004402013O0004223O004402012O00030004000E3O0020B200040004003D0020B70004000400152O00F600040002000200063000040039020100010004223O003902012O0003000400093O00261E00040039020100410004223O003902012O0003000400083O00202E0004000400424O0006000E3O00202O0006000600434O00040006000200062O0004004402013O0004223O004402012O0003000400093O0026C600040044020100440004223O004402012O0003000400174O00030005000E3O0020B200050005003E2O00F600040002000200062C0104004402013O0004223O004402012O0003000400013O00126C000500453O00126C000600464O005B000400064O00BC00046O0003000400273O00062C010400FD02013O0004223O00FD02012O0003000400283O00062C0104004D02013O0004223O004D02012O0003000400023O00063000040050020100010004223O005002012O0003000400283O000630000400FD020100010004223O00FD02012O0003000400204O0003000500093O00068A000400FD020100050004223O00FD020100126C000400013O00261A000400B6020100010004223O00B602012O00030005000E3O0020B20005000500470020B70005000500242O00F600050002000200062C0105008202013O0004223O008202012O0003000500083O00202E0005000500254O0007000E3O00202O0007000700434O00050007000200062O0005008202013O0004223O008202012O0003000500153O00202E0005000500484O0007000E3O00202O0007000700494O00050007000200062O0005008202013O0004223O008202012O0003000500293O000E10000B0071020100050004223O007102012O00030005002A3O000EFB000B0082020100050004223O008202012O0003000500174O00140006000E3O00202O0006000600474O000700153O00202O0007000700394O0009000E3O00202O0009000900474O0007000900024O000700076O00050007000200062O0005008202013O0004223O008202012O0003000500013O00126C0006004A3O00126C0007004B4O005B000500074O00BC00056O00030005000E3O0020B200050005004C0020B70005000500242O00F600050002000200062C010500B502013O0004223O00B502012O0003000500083O0020FC00050005004D00122O000700026O0008000E3O00202O00080008003D4O00050008000200062O0005009C02013O0004223O009C02012O0003000500083O00202E0005000500424O0007000E3O00202O00070007004E4O00050007000200062O000500AA02013O0004223O00AA02012O0003000500083O0020B700050005004F2O00F600050002000200062C010500AA02013O0004223O00AA02012O0003000500083O00202E0005000500424O0007000E3O00202O0007000700434O00050007000200062O000500B502013O0004223O00B502012O0003000500153O00202E0005000500504O0007000E3O00202O0007000700494O00050007000200062O000500B502013O0004223O00B502012O0003000500174O00030006000E3O0020B200060006004C2O00F600050002000200062C010500B502013O0004223O00B502012O0003000500013O00126C000600513O00126C000700524O005B000500074O00BC00055O00126C000400023O00261A00040055020100020004223O005502012O0003000500083O0020FC00050005004D00122O000700026O0008000E3O00202O00080008003D4O00050008000200062O000500FD02013O0004223O00FD020100126C000500013O000ECE000200D5020100050004223O00D502012O00030006000E3O0020B20006000600530020B70006000600242O00F600060002000200062C010600FD02013O0004223O00FD02012O0003000600174O00030007000E3O0020B20007000700532O00F600060002000200062C010600FD02013O0004223O00FD02012O0003000600013O001262000700543O00122O000800556O000600086O00065O00044O00FD0201000ECE000100C1020100050004223O00C102012O00030006000E3O0020B20006000600560020B70006000600242O00F600060002000200062C010600E802013O0004223O00E802012O0003000600174O00030007000E3O0020B20007000700562O00F600060002000200062C010600E802013O0004223O00E802012O0003000600013O00126C000700573O00126C000800584O005B000600084O00BC00066O00030006000E3O0020B20006000600590020B70006000600242O00F600060002000200062C010600F902013O0004223O00F902012O0003000600174O00030007000E3O0020B20007000700592O00F600060002000200062C010600F902013O0004223O00F902012O0003000600013O00126C0007005A3O00126C0008005B4O005B000600084O00BC00065O00126C000500023O0004223O00C102010004223O00FD02010004223O0055020100126C0002000B3O0004223O00CB2O010004223O002E03010004223O00142O010004223O002E0301000ECE0022000100013O0004223O000100012O0003000100083O00200F00010001005C00122O0003001D6O0001000300024O0001002B6O000100083O00202O00010001005D00122O000300416O00010003000200122O000100136O00015O00062C2O01002303013O0004223O0023030100126C000100013O00261A00010012030100010004223O001203010012450002005E4O002B000300153O00202O00030003005F00122O0005001D6O0003000500024O0004002B6O000400046O0002000400024O000200296O0002002B6O000200026O0002002A3O00044O002C03010004223O001203010004223O002C030100126C000100013O00261A00010024030100010004223O0024030100126C000200024O00CA000200293O00126C000200024O00CA0002002A3O0004223O002C03010004223O0024030100126C3O000E3O0004223O000100012O00063O00017O00043O00028O0003053O005072696E7403333O000D6BE759227CA4752D7EE1183E76F0593870EB566C7BFD180969ED5B6239D74D3C69EB4A387CE0182E60A4400778EA5D3876AA03043O00384C1984000F3O00126C3O00013O00261A3O0001000100010004223O000100012O000300016O00D10001000100014O000100013O00202O0001000100024O000200023O00122O000300033O00122O000400046O000200046O00013O000100044O000E00010004223O000100012O00063O00017O00", GetFEnv(), ...);
