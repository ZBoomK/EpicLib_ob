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
				if (Enum <= 154) then
					if (Enum <= 76) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
										elseif (Enum > 2) then
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
											if (Inst[2] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
											Stk[Inst[2]] = #Stk[Inst[3]];
										end
									elseif (Enum <= 6) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 7) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
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
											local A = Inst[2];
											local Results, Limit = _R(Stk[A]());
											Top = (Limit + A) - 1;
											local Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
										end
									elseif (Enum <= 11) then
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
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
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 15) then
									if (Enum > 14) then
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
										do
											return Unpack(Stk, A, A + Inst[3]);
										end
									end
								elseif (Enum <= 16) then
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
								elseif (Enum > 17) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[A] = Stk[A]();
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum > 19) then
											local Edx;
											local Results, Limit;
											local B;
											local A;
											Upvalues[Inst[3]] = Stk[Inst[2]];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
											Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
											Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
											Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									elseif (Enum > 21) then
										if (Inst[2] ~= Inst[4]) then
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
								elseif (Enum <= 24) then
									if (Enum == 23) then
										local B;
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									else
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
									end
								elseif (Enum <= 25) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
									Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
									Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 26) then
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum == 28) then
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 30) then
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
								elseif (Enum == 31) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
									Env[Inst[3]] = Stk[Inst[2]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 34) then
								if (Enum == 33) then
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
							elseif (Enum <= 35) then
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
							elseif (Enum == 36) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum == 38) then
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
												VIP = Inst[3];
											else
												VIP = VIP + 1;
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
									elseif (Enum > 40) then
										local B;
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
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									elseif (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 43) then
									if (Enum > 42) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Inst[2] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 44) then
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
								elseif (Enum > 45) then
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum == 47) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 49) then
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
								elseif (Enum > 50) then
									do
										return Stk[Inst[2]]();
									end
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 53) then
								if (Enum == 52) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Inst[2] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 54) then
								local Edx;
								local Results, Limit;
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
							elseif (Enum == 55) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 66) then
							if (Enum <= 61) then
								if (Enum <= 58) then
									if (Enum == 57) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
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
								elseif (Enum <= 59) then
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
								elseif (Enum == 60) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 63) then
								if (Enum > 62) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local Edx;
									local Results, Limit;
									local B;
									local A;
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
								end
							elseif (Enum <= 64) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 65) then
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
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 71) then
							if (Enum <= 68) then
								if (Enum > 67) then
									local Edx;
									local Results;
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Stk[A + 1])};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Inst[2] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 69) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 70) then
								do
									return Stk[Inst[2]];
								end
							else
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							end
						elseif (Enum <= 73) then
							if (Enum > 72) then
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 74) then
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
						elseif (Enum > 75) then
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 115) then
						if (Enum <= 95) then
							if (Enum <= 85) then
								if (Enum <= 80) then
									if (Enum <= 78) then
										if (Enum > 77) then
											if (Inst[2] > Stk[Inst[4]]) then
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
									elseif (Enum == 79) then
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
									elseif (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum <= 82) then
									if (Enum == 81) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 83) then
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
								elseif (Enum > 84) then
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
							elseif (Enum <= 90) then
								if (Enum <= 87) then
									if (Enum > 86) then
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
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 88) then
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
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 89) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								end
							elseif (Enum <= 92) then
								if (Enum == 91) then
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
								end
							elseif (Enum <= 93) then
								Env[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 94) then
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
						elseif (Enum <= 105) then
							if (Enum <= 100) then
								if (Enum <= 97) then
									if (Enum > 96) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 98) then
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
								elseif (Enum > 99) then
									Stk[Inst[2]]();
								else
									local A;
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 102) then
								if (Enum == 101) then
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 103) then
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
							elseif (Enum == 104) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 110) then
							if (Enum <= 107) then
								if (Enum > 106) then
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
							elseif (Enum <= 108) then
								local B;
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
								Stk[A](Stk[A + 1]);
							elseif (Enum == 109) then
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
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 112) then
							if (Enum == 111) then
								Stk[Inst[2]] = {};
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
						elseif (Enum <= 113) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 114) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
							end
						end
					elseif (Enum <= 134) then
						if (Enum <= 124) then
							if (Enum <= 119) then
								if (Enum <= 117) then
									if (Enum > 116) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 118) then
									Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 121) then
								if (Enum == 120) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								end
							elseif (Enum <= 122) then
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
							elseif (Enum == 123) then
								local B;
								local Edx;
								local Results, Limit;
								local A;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 129) then
							if (Enum <= 126) then
								if (Enum > 125) then
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								else
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum <= 127) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 128) then
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 131) then
							if (Enum > 130) then
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
							elseif (Inst[2] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 132) then
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
						elseif (Enum == 133) then
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
					elseif (Enum <= 144) then
						if (Enum <= 139) then
							if (Enum <= 136) then
								if (Enum > 135) then
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
								end
							elseif (Enum <= 137) then
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
							elseif (Enum == 138) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 141) then
							if (Enum == 140) then
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
						elseif (Enum <= 142) then
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum > 143) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 149) then
						if (Enum <= 146) then
							if (Enum == 145) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
						elseif (Enum <= 147) then
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
						elseif (Enum > 148) then
							local A;
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Inst[2] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 151) then
						if (Enum > 150) then
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
					elseif (Enum <= 152) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
					elseif (Enum > 153) then
						Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
					else
						local A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Top));
					end
				elseif (Enum <= 232) then
					if (Enum <= 193) then
						if (Enum <= 173) then
							if (Enum <= 163) then
								if (Enum <= 158) then
									if (Enum <= 156) then
										if (Enum == 155) then
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									elseif (Enum == 157) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 160) then
									if (Enum > 159) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 161) then
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
								elseif (Enum == 162) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 168) then
								if (Enum <= 165) then
									if (Enum > 164) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 166) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								elseif (Enum == 167) then
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
							elseif (Enum <= 170) then
								if (Enum > 169) then
									local B;
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
							elseif (Enum <= 171) then
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
							elseif (Enum > 172) then
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
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
						elseif (Enum <= 183) then
							if (Enum <= 178) then
								if (Enum <= 175) then
									if (Enum == 174) then
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum <= 176) then
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
								elseif (Enum > 177) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 180) then
								if (Enum == 179) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
							elseif (Enum <= 181) then
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
							elseif (Enum > 182) then
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 188) then
							if (Enum <= 185) then
								if (Enum == 184) then
									local B;
									local A;
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								end
							elseif (Enum <= 186) then
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
							elseif (Enum == 187) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 190) then
							if (Enum == 189) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								do
									return;
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
						elseif (Enum <= 191) then
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
						elseif (Enum == 192) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 212) then
						if (Enum <= 202) then
							if (Enum <= 197) then
								if (Enum <= 195) then
									if (Enum == 194) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 196) then
									local Edx;
									local Results, Limit;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
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
							elseif (Enum <= 199) then
								if (Enum > 198) then
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 200) then
								local B;
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
							elseif (Enum > 201) then
								local B;
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
							else
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 207) then
							if (Enum <= 204) then
								if (Enum > 203) then
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 205) then
								local B;
								local Edx;
								local Results, Limit;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A]());
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 206) then
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 209) then
							if (Enum > 208) then
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
								local B;
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 210) then
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
						elseif (Enum > 211) then
							local B;
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
						end
					elseif (Enum <= 222) then
						if (Enum <= 217) then
							if (Enum <= 214) then
								if (Enum == 213) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A]();
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
								end
							elseif (Enum <= 215) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							elseif (Enum == 216) then
								if (Inst[2] < Stk[Inst[4]]) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Stk[A + 1]));
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
						elseif (Enum <= 219) then
							if (Enum > 218) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 220) then
							local B;
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
						elseif (Enum > 221) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 227) then
						if (Enum <= 224) then
							if (Enum > 223) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
						elseif (Enum <= 225) then
							Stk[Inst[2]] = not Stk[Inst[3]];
						elseif (Enum > 226) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
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
					elseif (Enum <= 229) then
						if (Enum > 228) then
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
					elseif (Enum <= 230) then
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
					elseif (Enum > 231) then
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
				elseif (Enum <= 271) then
					if (Enum <= 251) then
						if (Enum <= 241) then
							if (Enum <= 236) then
								if (Enum <= 234) then
									if (Enum > 233) then
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
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
									end
								elseif (Enum > 235) then
									VIP = Inst[3];
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 238) then
								if (Enum > 237) then
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
							elseif (Enum <= 239) then
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Results, Limit = _R(Stk[A](Stk[A + 1]));
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
							elseif (Enum == 240) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 246) then
							if (Enum <= 243) then
								if (Enum > 242) then
									local Edx;
									local Results, Limit;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								else
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
									end
								end
							elseif (Enum <= 244) then
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
							elseif (Enum == 245) then
								local Edx;
								local Results, Limit;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 248) then
							if (Enum == 247) then
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
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 249) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
						elseif (Enum > 250) then
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
					elseif (Enum <= 261) then
						if (Enum <= 256) then
							if (Enum <= 253) then
								if (Enum == 252) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 254) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum > 255) then
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
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 258) then
							if (Enum == 257) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 259) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 260) then
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
					elseif (Enum <= 266) then
						if (Enum <= 263) then
							if (Enum == 262) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 264) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 265) then
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
							local A = Inst[2];
							local C = Inst[4];
							local CB = A + 2;
							local Result = {Stk[A](Stk[A + 1], Stk[CB])};
							for Idx = 1, C do
								Stk[CB + Idx] = Result[Idx];
							end
							local R = Result[1];
							if R then
								Stk[CB] = R;
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 268) then
						if (Enum > 267) then
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
						else
							local Edx;
							local Results, Limit;
							local B;
							local A;
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
							Results, Limit = _R(Stk[A](Stk[A + 1]));
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
							Results, Limit = _R(Stk[A](Stk[A + 1]));
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 269) then
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
					elseif (Enum == 270) then
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
						Upvalues[Inst[3]] = Stk[Inst[2]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						do
							return;
						end
					end
				elseif (Enum <= 290) then
					if (Enum <= 280) then
						if (Enum <= 275) then
							if (Enum <= 273) then
								if (Enum == 272) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 274) then
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
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							end
						elseif (Enum <= 277) then
							if (Enum > 276) then
								local B;
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
								do
									return;
								end
							end
						elseif (Enum <= 278) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 279) then
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A;
							A = Inst[2];
							Stk[A] = Stk[A]();
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 285) then
						if (Enum <= 282) then
							if (Enum == 281) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
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
								VIP = Inst[3];
							end
						elseif (Enum <= 283) then
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
						elseif (Enum > 284) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						else
							local A;
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						end
					elseif (Enum <= 287) then
						if (Enum == 286) then
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
						end
					elseif (Enum <= 288) then
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
						Env[Inst[3]] = Stk[Inst[2]];
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
					elseif (Enum == 289) then
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
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 300) then
					if (Enum <= 295) then
						if (Enum <= 292) then
							if (Enum > 291) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 293) then
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
						elseif (Enum > 294) then
							local A;
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Inst[4]) then
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
					elseif (Enum <= 297) then
						if (Enum > 296) then
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
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 298) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Stk[Inst[4]]];
					elseif (Enum == 299) then
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
							if (Mvm[1] == 125) then
								Indexes[Idx - 1] = {Stk,Mvm[3]};
							else
								Indexes[Idx - 1] = {Upvalues,Mvm[3]};
							end
							Lupvals[#Lupvals + 1] = Indexes;
						end
						Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
				elseif (Enum <= 305) then
					if (Enum <= 302) then
						if (Enum == 301) then
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
							VIP = Inst[3];
						end
					elseif (Enum <= 303) then
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
					elseif (Enum == 304) then
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
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
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
						Stk[Inst[2]] = Inst[3];
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
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3] ~= 0;
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					end
				elseif (Enum <= 307) then
					if (Enum > 306) then
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
					end
				elseif (Enum <= 308) then
					local B;
					local Edx;
					local Results, Limit;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A]();
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Results, Limit = _R(Stk[A]());
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
					Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Upvalues[Inst[3]] = Stk[Inst[2]];
				elseif (Enum == 309) then
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
				else
					Stk[Inst[2]] = Inst[3] ~= 0;
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD98CC60CDDCCD82ED99FC213DECDD429E9BCDE50DDD6DA03083O007EB1A3BB4586DBA7031B3O00DCC703BB81E555BAF5D809A881F651A5F6D905AFB1D54DE6F5C20B03083O00C899B76AC3DEB234002E3O0012213O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004EC3O000A000100128E000300063O0020A600040003000700128E000500083O0020A600050005000900128E000600083O0020A600060006000A00062B01073O000100062O007D3O00064O007D8O007D3O00044O007D3O00014O007D3O00024O007D3O00053O0020A600080003000B0020A600090003000C2O006F000A5O00128E000B000D3O00062B010C0001000100022O007D3O000A4O007D3O000B4O007D000D00073O001228010E000E3O001228010F000F4O00C1000D000F000200062B010E0002000100032O007D3O00074O007D3O00094O007D3O00084O00B9000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00A200025O00122O000300016O00045O00122O000500013O00042O0003002100012O00FE00076O00D9000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004E80003000500012O00FE000300054O007D000400024O0037000300044O007300036O0014012O00017O00063O00028O00025O00804740025O00089140026O00F03F025O006C9540025O00A8A640011F3O001228010200014O00E3000300033O001228010400013O00263200040003000100010004EC3O00030001002E1C0002000D000100030004EC3O000D00010026320002000D000100040004EC3O000D00012O007D000500034O00F200066O00DB00056O007300055O00262D00020011000100010004EC3O00110001002E8B00060002000100050004EC3O000200012O00FE00056O0008000300053O0006780003001A000100010004EC3O001A00012O00FE000500014O007D00066O00F200076O00DB00056O007300055O001228010200043O0004EC3O000200010004EC3O000300010004EC3O000200012O0014012O00017O00543O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O00644303374603043O004529226003053O009DCCF2252C03063O004BDCA3B76A6203053O00219E9818F703053O00B962DAEB5703043O00E83D34F203063O00CAAB5C4786BE03053O0019D3299B3A03043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03073O003BCF4C7E7174F803083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D982O033O000903B403043O004B6776D903073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903043O0005E1AAC203043O00AE678EC503043O006D6174682O033O005B294703073O009836483F58453E03073O008D55A44CB557BD03043O0020DA34D6030A3O006A123CA7FFBF4955490E03083O003A2E7751C891D02503073O001C8D22A0A6BE3D03073O00564BEC50CCC9DD030A3O0056447A8AF0847E4E709C03063O00EB122117E59E03073O0067BBD3B75FB9CA03043O00DB30DAA1030A3O00C0747146D540ECEB766503073O008084111C29BB2F030C3O0047657445717569706D656E74026O002A40028O00026O002C40024O0080B3C540026O005E4003103O005265676973746572466F724576656E7403143O00311E270378330D341F7A241C391F7320102A1F7903053O003D6152665A03073O008F21A646C8590D03083O0069CC4ECB2BA7377E03083O0080BC260C0A0BC95403083O0031C5CA437E7364A703183O000777FE10A56461126AEA00B02O7B196FE00AA87770107EFB03073O003E573BBF49E03603143O00E7520566D316ECF4441471D11FF7E2591B60DC1103073O00A8AB1744349D53030C3O00DC70FBA92A2BA0E17DF1AC2B03073O00E7941195CD454D03103O005265676973746572496E466C6967687403063O0053657441504C025O00A0704000D2013O00D3000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F4O00105O00122O0011001A3O00122O0012001B6O0010001200024O0010000400104O00115O00122O0012001C3O00122O0013001D6O0011001300024O0011000400114O00125O00122O0013001E3O00122O0014001F6O0012001400024O0012000400124O00135O00122O001400203O00122O001500216O0013001500024O0013000400134O00145O001228011500223O001262001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000400144O00155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O0014001400154O00155O00122O0016002A3O00122O0017002B6O0015001700024O0015000400154O00165O00122O0017002C3O00122O0018002D6O0016001800024O0015001500164O00165O00122O0017002E3O00122O0018002F6O0016001800024O00150015001600122O001600306O00175O00122O001800313O00122O001900326O0017001900024O0016001600174O00178O00188O00198O001A002F3O00062B01303O000100162O007D3O00234O00FE8O007D3O00254O007D3O00264O007D3O001C4O007D3O001B4O007D3O001A4O007D3O00274O007D3O00284O007D3O00294O007D3O001D4O007D3O001E4O007D3O001F4O007D3O00204O007D3O00214O007D3O00224O007D3O002D4O007D3O002E4O007D3O002F4O007D3O002A4O007D3O002B4O007D3O002C4O00D100315O00122O003200333O00122O003300346O0031003300024O0031000C00314O00325O00122O003300353O00122O003400366O0032003400024O0031003100322O00D100325O00122O003300373O00122O003400386O0032003400024O0032000D00324O00335O00122O003400393O00122O0035003A6O0033003500024O0032003200332O00D100335O00122O0034003B3O00122O0035003C6O0033003500024O0033000E00334O00345O00122O0035003D3O00122O0036003E6O0034003600024O0033003300342O006F00345O00209800350007003F2O004B0035000200020020A60036003500400006F8003600BC00013O0004EC3O00BC00012O007D0036000D3O0020A60037003500402O004B003600020002000678003600BF000100010004EC3O00BF00012O007D0036000D3O001228013700414O004B0036000200020020A60037003500420006F8003700C700013O0004EC3O00C700012O007D0037000D3O0020A60038003500422O004B003700020002000678003700CA000100010004EC3O00CA00012O007D0037000D3O001228013800414O004B003700020002001228013800433O001242003900433O00122O003A00413O00122O003B00416O003C8O003D8O003E5O00122O003F00413O00122O004000443O00122O004100413O00122O004200413O00122O004300413O00122O004400416O004500473O00202O00480004004500062B014A0001000100022O007D3O00384O007D3O00394O0017004B5O00122O004C00463O00122O004D00476O004B004D6O00483O00014O00485O00122O004900483O00122O004A00496O0048004A00024O0048000400484O00495O00122O004A004A3O00122O004B004B6O0049004B00024O00480048004900202O00490004004500062B014B0002000100022O007D3O00354O007D3O00074O00D0004C5O00122O004D004C3O00122O004E004D6O004C004E6O00493O000100202O00490004004500062B014B0003000100022O007D3O00314O00FE8O006C004C5O00122O004D004E3O00122O004E004F6O004C004E6O00493O00014O00495O00122O004A00503O00122O004B00516O0049004B00024O00490031004900202O0049004900524O00490002000100062B01490004000100022O007D3O00044O00FE7O00062B014A0005000100042O007D3O00044O00FE8O00FE3O00014O00FE3O00023O00062B014B0006000100022O007D3O00044O00FE7O00062B014C0007000100012O007D3O004B3O00062B014D0008000100022O007D3O00044O00FE7O00062B014E0009000100012O007D3O004D3O00062B014F000A000100022O007D3O00044O00FE7O00062B0150000B000100012O007D3O004F3O00062B0151000C000100022O007D3O00044O00FE7O00062B0152000D000100012O007D3O00513O00062B0153000E000100022O007D3O00044O00FE7O00062B0154000F000100012O007D3O00533O00062B01550010000100032O007D3O00314O00FE8O007D3O00083O00062B01560011000100032O007D3O00314O00FE8O007D3O00473O00062B01570012000100012O007D3O00313O00062B01580013000100012O007D3O00313O00062B015900140001000C2O007D3O00314O00FE8O007D3O00124O007D3O00274O007D3O00074O007D3O00334O007D3O00084O007D3O00414O007D3O003A4O00FE3O00014O007D3O00144O00FE3O00023O00062B015A00150001001A2O007D3O00474O00FE3O00014O00FE3O00024O007D3O003D4O007D3O004E4O007D3O003C4O007D3O00314O00FE8O007D3O00074O007D3O00144O007D3O00524O007D3O00504O007D3O003B4O007D3O00164O007D3O00514O007D3O004F4O007D3O00404O007D3O00154O007D3O003F4O007D3O00134O007D3O00394O007D3O00434O007D3O004B4O007D3O004D4O007D3O003E4O007D3O00443O00062B015B0016000100032O007D3O00484O007D3O00344O007D3O00193O00062B015C0017000100072O007D3O00324O00FE8O007D3O00074O007D3O00314O007D3O00124O007D3O00334O007D3O005B3O00062B015D0018000100032O007D3O00314O00FE8O007D3O00123O00062B015E00190001001C2O007D3O00314O00FE8O007D3O00074O007D3O00524O007D3O004F4O007D3O00114O007D3O002E4O007D3O00494O007D3O00504O007D3O004C4O007D3O00474O007D3O002C4O007D3O00084O007D3O00434O007D3O00424O007D3O002D4O007D3O003C4O007D3O003B4O00FE3O00014O007D3O00444O00FE3O00024O007D3O00144O007D3O00484O007D3O005D4O007D3O005C4O007D3O002F4O007D3O00514O007D3O002B3O00062B015F001A0001000D2O007D3O00394O007D3O00314O00FE8O007D3O00114O007D3O002B4O007D3O00084O007D3O002D4O007D3O00074O007D3O002E4O007D3O00444O007D3O002C4O007D3O002F4O007D3O002A3O00062B0160001B000100342O007D3O00304O007D3O00174O00FE8O007D3O00184O007D3O00454O007D3O00074O007D3O00464O007D3O00084O007D3O00474O007D3O00134O007D3O00194O007D3O00484O007D3O00384O007D3O00044O007D3O00394O007D3O00424O007D3O00444O00FE3O00014O00FE3O00024O007D3O00434O007D3O00314O007D3O00254O007D3O000B4O007D3O00124O007D3O00114O007D3O00574O007D3O00404O007D3O003F4O007D3O002A4O007D3O004A4O007D3O003D4O007D3O002C4O007D3O000A4O007D3O00334O007D3O00294O007D3O00594O007D3O005A4O007D3O004E4O007D3O005D4O007D3O001A4O007D3O005E4O007D3O00524O007D3O004C4O007D3O005F4O007D3O005C4O007D3O002F4O007D3O00144O007D3O00554O007D3O002E4O007D3O003E4O007D3O00564O007D3O00583O00062B0161001C000100022O007D3O00044O00FE7O00201800620004005300122O006300546O006400606O006500616O0062006500016O00013O001D3O008F3O00028O00025O00989140025O00807F40026O00F03F025O00405B40025O0002AD40025O0028AD40025O00206840025O0020AA40025O00D2A940025O00AEAF40025O0058B340026O000840025O008AA640025O00149E40025O00BEB140025O00E89840025O00207540025O0062AB40025O00349440025O00507440030C3O004570696353652O74696E677303083O00D64B641EEC40771903043O006A852E1003123O00712E67F948524D3067C82O525D337BF3564403063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A9203093O006A4346F07A88B70E4D03083O006B39362B9D15E6E7025O0040514003083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC030A3O0018AE9347D3787B2887B103073O00185CCFE12C8319026O001040026O008540026O007740025O00D88F40025O0062B040025O0070A74003083O002O0B96D2A336099103053O00CA586EE2A603103O00F61C87DFCFC2038BF9CDF30096FEC5CD03053O00AAA36FE297025O00207240025O0074A54003083O00E7C1FA48DDCAE94F03043O003CB4A48E030B3O006D4D001D35E41C535B113A03073O0072383E6549478D03083O008BECCFD0B1E7DCD703043O00A4D889BB030A3O00E7F53480A7FD02D3EA2203073O006BB28651D2C69E025O00588440025O005AB14003083O0078D6AC5812734CC003063O001D2BB3D82C7B030F3O0099DC2D43B3DB2F40A9F63049B3DC3203043O002CDDB94003083O0032E25C4B7A0FE05B03053O00136187283F030A3O0089493A37233EBA553D3E03063O0051CE3C535B4F025O00606840025O00309C4003083O007DAEC46626CD4AB703083O00C42ECBB0124FA32D03113O008D2C7B1020F2E1BF107B0D2BF7F9BD0A4E03073O008FD8421E7E449B026O001440025O000C9E40025O00F9B140025O00989540025O0050A14003083O002235A62C47392E0203073O00497150D2582E5703113O00A929CC1EEE8F2BFD1DF38823C33CE68C2903053O0087E14CAD7203083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030F3O0085D811FC71F8AAED1FE471F9A3F52003063O0096CDBD709018025O005AA640025O0036A34003083O001681AB580D86162O03083O007045E4DF2C64E871030E3O00E10C02FBB37D8AC01714C7B9728303073O00E6B47F67B3D61C027O0040025O00EAAE40025O0066A04003083O00BF004B52ED4FE79F03073O0080EC653F268421030D3O0084AC1048A2E3DCB8A61F419EDB03073O00AFCCC97124D68B03083O0074C921C80D49CB2603053O006427AC55BC03113O008476AD8521BF6DA99404A46CB1B327B87603053O0053CD18D9E0025O004CAF40025O0028874003083O00D5C0D929EFCBCA2E03043O005D86A5AD03163O0097FCD5C728DCA76EAADDCFCE23F9BA77AAF7CDCB29DA03083O001EDE92A1A25AAED2025O00BC9D40025O006AAF40026O00184003083O00B128B15ED54E169103073O0071E24DC52ABC20030C3O001413E0BD3F04C4BA2802F5B903043O00D55A769403083O00682BA042445529A703053O002D3B4ED436030B3O002059948E941DA4E018598D03083O00907036E3EBE64ECD03083O00802D1BE8D955B43B03063O003BD3486F9CB003133O007D92EE204189C7284388ED244DB3FA3F4F89F703043O004D2EE783025O00BCA140025O0022B040025O006EA240025O002AAD40025O0042A440025O00ECAE4003083O0099CD19DFCCADD0F203083O0081CAA86DABA5C3B7030F3O00065D3AD7D01DE5114C25DDD013F22A03073O0086423857B8BE7403083O000F341DAF10E52O2603083O00555C5169DB798B4103103O00DAA1594873D6EFB6764070D8E8B2424103063O00BF9DD330251C025O00609240025O00F4B140025O00C4A24003083O00EC1AE00833D118E703053O005ABF7F947C03093O00518A3E1B779427187603043O007718E74E00B5012O001228012O00014O00E3000100023O00262D3O0006000100010004EC3O00060001002E8B00020009000100030004EC3O000900010012282O0100014O00E3000200023O001228012O00043O00262D3O000F000100040004EC3O000F0001002E160005000F000100060004EC3O000F0001002E43000700F5FF2O00080004EC3O00020001002E8B000A000F000100090004EC3O000F00010026320001000F000100010004EC3O000F0001001228010200013O002E1C000B00180001000C0004EC3O0018000100262D0002001A0001000D0004EC3O001A0001002E1C000E00630001000F0004EC3O00630001001228010300014O00E3000400043O00262D00030020000100010004EC3O00200001002E8B0010001C000100110004EC3O001C0001001228010400013O0026320004004B000100010004EC3O004B0001001228010500013O002E8B0012002C000100130004EC3O002C0001000E820004002A000100050004EC3O002A0001002E4300140004000100150004EC3O002C0001001228010400043O0004EC3O004B0001000E2800010024000100050004EC3O0024000100128E000600164O008F000700013O00122O000800173O00122O000900186O0007000900024O0006000600074O000700013O00122O000800193O00122O0009001A6O0007000900024O00060006000700062O0006003C000100010004EC3O003C0001001228010600014O00F900065O001208010600166O000700013O00122O0008001B3O00122O0009001C6O0007000900024O0006000600074O000700013O00122O0008001D3O00122O0009001E6O0007000900024O0006000600074O000600023O00122O000500043O00044O00240001002E43001F00D6FF2O001F0004EC3O0021000100263200040021000100040004EC3O0021000100128E000500164O008F000600013O00122O000700203O00122O000800216O0006000800024O0005000500064O000600013O00122O000700223O00122O000800236O0006000800024O00050005000600062O0005005D000100010004EC3O005D0001001228010500014O00F9000500033O001228010200243O0004EC3O006300010004EC3O002100010004EC3O006300010004EC3O001C000100262D00020067000100010004EC3O00670001002E4300250035000100260004EC3O009A0001001228010300013O002E4300270014000100270004EC3O007C000100262D0003006E000100040004EC3O006E0001002E8B0028007C000100290004EC3O007C000100128E000400164O0001000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000400043O00122O000200043O00044O009A000100262D00030080000100010004EC3O00800001002E1C002F00680001002E0004EC3O0068000100128E000400164O0096000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000400053O00122O000400166O000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000400063O00122O000300043O0004EC3O00680001002632000200D0000100240004EC3O00D00001001228010300013O002E1C003800BA000100390004EC3O00BA0001002632000300BA000100010004EC3O00BA000100128E000400164O0096000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000500013O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O000400073O00122O000400166O000500013O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O000400083O00122O000300043O000E82000400BE000100030004EC3O00BE0001002E8B0043009D000100420004EC3O009D000100128E000400164O008F000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O000500013O00122O000600463O00122O000700476O0005000700024O00040004000500062O000400CC000100010004EC3O00CC0001001228010400014O00F9000400093O001228010200483O0004EC3O00D000010004EC3O009D00010026320002000B2O0100040004EC3O000B2O01001228010300013O002E1C004900F80001004A0004EC3O00F8000100262D000300D9000100010004EC3O00D90001002E1C004C00F80001004B0004EC3O00F8000100128E000400164O008F000500013O00122O0006004D3O00122O0007004E6O0005000700024O0004000400054O000500013O00122O0006004F3O00122O000700506O0005000700024O00040004000500062O000400E7000100010004EC3O00E70001001228010400014O00F90004000A3O001209010400166O000500013O00122O000600513O00122O000700526O0005000700024O0004000400054O000500013O00122O000600533O00122O000700546O0005000700024O00040004000500062O000400F6000100010004EC3O00F60001001228010400014O00F90004000B3O001228010300043O000E82000400FC000100030004EC3O00FC0001002E43005500D9FF2O00560004EC3O00D3000100128E000400164O0001000500013O00122O000600573O00122O000700586O0005000700024O0004000400054O000500013O00122O000600593O00122O0007005A6O0005000700024O0004000400054O0004000C3O00122O0002005B3O00044O000B2O010004EC3O00D3000100262D0002000F2O01005B0004EC3O000F2O01002E43005C003A0001005D0004EC3O00472O01001228010300013O002632000300312O0100010004EC3O00312O0100128E000400164O008F000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000500013O00122O000600603O00122O000700616O0005000700024O00040004000500062O000400202O0100010004EC3O00202O01001228010400014O00F90004000D3O001209010400166O000500013O00122O000600623O00122O000700636O0005000700024O0004000400054O000500013O00122O000600643O00122O000700656O0005000700024O00040004000500062O0004002F2O0100010004EC3O002F2O01001228010400014O00F90004000E3O001228010300043O002E1C006700102O0100660004EC3O00102O01002632000300102O0100040004EC3O00102O0100128E000400164O008F000500013O00122O000600683O00122O000700696O0005000700024O0004000400054O000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500062O000400432O0100010004EC3O00432O01001228010400014O00F90004000F3O0012280102000D3O0004EC3O00472O010004EC3O00102O01002E1C006C00702O01006D0004EC3O00702O01002632000200702O01006E0004EC3O00702O0100128E000300164O001A010400013O00122O0005006F3O00122O000600706O0004000600024O0003000300044O000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000300103O00122O000300166O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000300113O00122O000300166O000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000400013O00122O000500793O00122O0006007A6O0004000600024O0003000300044O000300123O00044O00B42O0100262D000200742O0100480004EC3O00742O01002E8B007C00140001007B0004EC3O00140001001228010300014O00E3000400043O002E8B007D00762O01007E0004EC3O00762O01002E8B007F00762O0100800004EC3O00762O01002632000300762O0100010004EC3O00762O01001228010400013O000E28000100982O0100040004EC3O00982O0100128E000500164O0096000600013O00122O000700813O00122O000800826O0006000800024O0005000500064O000600013O00122O000700833O00122O000800846O0006000800024O0005000500064O000500133O00122O000500166O000600013O00122O000700853O00122O000800866O0006000800024O0005000500064O000600013O00122O000700873O00122O000800886O0006000800024O0005000500064O000500143O00122O000400043O002E4300890004000100890004EC3O009C2O0100262D0004009E2O0100040004EC3O009E2O01002E8B008A007D2O01008B0004EC3O007D2O0100128E000500164O0001000600013O00122O0007008C3O00122O0008008D6O0006000800024O0005000500064O000600013O00122O0007008E3O00122O0008008F6O0006000800024O0005000500064O000500153O00122O0002006E3O00044O001400010004EC3O007D2O010004EC3O001400010004EC3O00762O010004EC3O001400010004EC3O00B42O010004EC3O000F00010004EC3O00B42O010004EC3O000200012O0014012O00017O000D3O00028O00025O003CA040025O00606440026O00F03F025O0014B040025O00088740025O00ECA740025O00689C40025O000AAD40025O009AA840025O005C9240025O00D4AF40024O0080B3C54000233O001228012O00014O00E3000100023O002E1C00030009000100020004EC3O000900010026323O0009000100010004EC3O000900010012282O0100014O00E3000200023O001228012O00043O0026323O0002000100040004EC3O00020001002E1C0006000B000100050004EC3O000B000100262D00010011000100010004EC3O00110001002E43000700FCFF2O00080004EC3O000B0001001228010200013O00262D00020018000100010004EC3O00180001002E35000900180001000A0004EC3O00180001002E1C000C00120001000B0004EC3O001200010012280103000D4O00F900035O0012280103000D4O00F9000300013O0004EC3O002200010004EC3O001200010004EC3O002200010004EC3O000B00010004EC3O002200010004EC3O000200012O0014012O00017O00013O00030C3O0047657445717569706D656E7400054O000F012O00013O00206O00016O000200029O006O00017O00033O00030C3O00CF03F4CDE804DDDCEB06FBC703043O00A987629A03103O005265676973746572496E466C6967687400094O00BD9O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O000200016O00017O00053O00030E3O00A7B2C6E953F681A9D4CF56FD8CA203063O009FE0C7A79B3703083O00DEFE2CF1F8E632C603043O00B297935C029O00104O001D9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004EC3O000E0001001228012O00054O00473O00024O0014012O00017O001C3O00028O00025O00F6A840025O0024AD40026O00F03F025O00DAA540025O0018AF40025O00449540025O0086B240025O0058AF40025O00D0AF40025O00BEAD40025O00F09340025O00609E40025O0080A24003053O007061697273030E3O00ABE84D2016457B82EE783310407F03073O001AEC9D2C52722C03043O0050657473025O00B49A40025O0098B04003083O000323C5782B3DC14803043O003B4A4EB5025O0058A140025O0009B140025O0004AF40025O0004A940025O009CAE40025O002DB14001643O0012282O0100014O00E3000200043O002E1C0002005D000100030004EC3O005D0001000E280004005D000100010004EC3O005D00012O00E3000400043O002E8B00050048000100060004EC3O0048000100263200020048000100040004EC3O00480001001228010500013O000E280001000C000100050004EC3O000C000100263200030011000100040004EC3O001100012O0047000400023O00262D00030015000100010004EC3O00150001002E43000700F8FF2O00080004EC3O000B0001001228010600013O00262D0006001A000100040004EC3O001A0001002E8B000A001C000100090004EC3O001C0001001228010300043O0004EC3O000B0001002E8B000C00160001000B0004EC3O00160001002E8B000D00160001000E0004EC3O0016000100263200060016000100010004EC3O00160001001228010400013O0012440007000F6O00088O000900013O00122O000A00103O00122O000B00116O0009000B00024O00080008000900202O0008000800124O00070002000900044O00400001002E1C00130037000100140004EC3O003700012O00FE000C00013O0012AE000D00153O00122O000E00166O000C000E00024O000C000B000C00064O00370001000C0004EC3O003700010004EC3O004000012O00FE000C00024O00B3000D00043O00122O000E00046O000C000E00024O000D00036O000E00043O00122O000F00046O000D000F00024O0004000C000D00060A0107002D000100020004EC3O002D0001001228010600043O0004EC3O001600010004EC3O000B00010004EC3O000C00010004EC3O000B00010004EC3O00630001002E8B00170007000100180004EC3O0007000100263200020007000100010004EC3O00070001001228010500013O00262D00050051000100040004EC3O00510001002E43001900040001001A0004EC3O00530001001228010200043O0004EC3O0007000100262D00050057000100010004EC3O00570001002E8B001C004D0001001B0004EC3O004D0001001228010300014O00E3000400043O001228010500043O0004EC3O004D00010004EC3O000700010004EC3O0063000100263200010002000100010004EC3O00020001001228010200014O00E3000300033O0012282O0100043O0004EC3O000200012O0014012O00017O00053O00030E3O0002C45B48B72CD054498724D3565F03053O00D345B12O3A03103O0091E075D2FCCAA5E15DE0FBCAA3EC76FB03063O00ABD785199589029O00104O001D9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004EC3O000E0001001228012O00054O00473O00024O0014012O00017O00013O00029O00084O00FE8O00DA3O00010002000E340001000500013O0004EC3O000500012O00888O0036012O00014O00473O00024O0014012O00017O00053O00030E3O00C6DD33E8EB39FD4CF2FC33F8E33503083O002281A8529A8F509C03153O00A1B73E0446478AB1AB210A465AAD90A0321F2O418703073O00E9E5D2536B282E029O00104O001D9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004EC3O000E0001001228012O00054O00473O00024O0014012O00017O00013O00029O00084O00FE8O00DA3O00010002000E340001000500013O0004EC3O000500012O00888O0036012O00014O00473O00024O0014012O00017O00053O00030E3O00E65733C401C8433CC531C0403ED303053O0065A12252B603143O00CC1F5CFFDFF1962FE4065CECFFF7902FFC0456F003083O004E886D399EBB82E2029O00104O001D9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004EC3O000E0001001228012O00054O00473O00024O0014012O00017O00013O00029O00084O00FE8O00DA3O00010002000E340001000500013O0004EC3O000500012O00888O0036012O00014O00473O00024O0014012O00017O00053O00030E3O00192AF8E33A36F8FF2D0BF8F3323A03043O00915E5F9903113O00CBC418D048BEF8C310F15BA5FCD91DDA4003063O00D79DAD74B52E029O00104O001D9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004EC3O000E0001001228012O00054O00473O00024O0014012O00017O00013O00029O00084O00FE8O00DA3O00010002000E340001000500013O0004EC3O000500012O00888O0036012O00014O00473O00024O0014012O00017O00053O00030E3O0012A18AE0DE3CB585E1EE34B687F703053O00BA55D4EB92030F3O00F28802D236FC5CE69404FF2DE757CC03073O0038A2E1769E598E029O00104O001D9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004EC3O000E0001001228012O00054O00473O00024O0014012O00017O00013O00029O00084O00FE8O00DA3O00010002000E340001000500013O0004EC3O000500012O00888O0036012O00014O00473O00024O0014012O00017O00073O00030A3O00446562752O66446F776E030F3O00442O6F6D4272616E64446562752O66030C3O007404CEAB2DDE7B10CCAB23D603063O00B83C65A0CF4203083O00496E466C69676874030D3O00446562752O6652656D61696E73026O000840011B3O00207000013O00014O00035O00202O0003000300024O00010003000200062O00010019000100010004EC3O001900012O00FE00016O0004000200013O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O00010002000200062O0001001900013O0004EC3O001900012O00FE000100023O0020FF0001000100064O00035O00202O0003000300024O00010003000200262O00010018000100070004EC3O001800012O008800016O00362O0100014O0047000100024O0014012O00017O00083O00030A3O00446562752O66446F776E030F3O00442O6F6D4272616E64446562752O66030C3O00198372B83E845BA93D867DB203043O00DC51E21C03083O00496E466C69676874030D3O00446562752O6652656D61696E73026O000840026O001040011D3O00207000013O00014O00035O00202O0003000300024O00010003000200062O0001001B000100010004EC3O001B00012O00FE00016O0004000200013O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O00010002000200062O0001001600013O0004EC3O0016000100209800013O00062O00FE00035O0020A60003000300022O00C10001000300020026CF0001001A000100070004EC3O001A00012O00FE000100023O0026500001001A000100080004EC3O001A00012O008800016O00362O0100014O0047000100024O0014012O00017O00023O0003113O00446562752O665265667265736861626C6503043O00442O6F6D01063O00204100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E73030F3O00442O6F6D4272616E64446562752O66026O002440010A3O0020222O013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004EC3O000700012O008800016O00362O0100014O0047000100024O0014012O00017O003C3O00028O00025O00608840025O00E2A840025O00806C40026O00F03F025O0016B040025O00F4AB40030B3O007445D970227743DE7D3F4A03053O0050242AAE1503073O0049735265616479025O00C6A640025O00D49D40030B3O00506F776572536970686F6E025O0004A940025O00D6AF4003183O005E1F207F5C2F24735E1838740E00257F4D1F3A784F04772803043O001A2E7057025O00D08340025O00C6A140026O00504003093O009D26A67BB1BD4AB8AD03083O00D4D943CB142ODF2503083O0042752O66446F776E030F3O0044656D6F6E6963436F726542752O6603093O00497343617374696E6703093O0044656D6F6E626F6C7403093O009E88A5DDB48FA7DEAE03043O00B2DAEDC803113O0054696D6553696E63654C61737443617374026O001040025O0034A140025O00B0854003123O0044656D6F6E626F6C74506574412O7461636B030E3O0049735370652O6C496E52616E676503153O00B2B0EBDFB8B7E9DCA2F5F6C2B3B6E9DD2OB4F290E203043O00B0D6D586025O000C9140025O00C2A540027O0040025O001EB240025O0030A640025O00F4AC40025O0078AE40025O00309440025O003EB140026O002840026O002C4003103O0034C78BF6E5CE01D0A4FEE6C006D490FF03063O00A773B5E29B8A030B3O004973417661696C61626C65030F3O00D137EA51747FF0EB2EE25A7274C8E603073O00A68242873C1B11025O006EAB40025O00A8A040030A3O00C7A5B7D0A7417BFBA1A203073O003994CDD6B4C83603133O00536861646F77426F6C74506574412O7461636B030A3O00536861646F77426F6C7403173O0001F534307905C2373B7A06BD25267311F238367706BD6303053O0016729D555400FE3O001228012O00014O00E3000100013O00262D3O0006000100010004EC3O00060001002E43000200FEFF2O00030004EC3O000200010012282O0100013O002E4300040067000100040004EC3O006E00010026320001006E000100050004EC3O006E0001001228010200013O00262D00020010000100010004EC3O00100001002E8B00060067000100070004EC3O006700012O00FE00036O00BC000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003001C000100010004EC3O001C0001002E1C000B00290001000C0004EC3O002900012O00FE000300024O00FE00045O0020A600040004000D2O004B00030002000200067800030024000100010004EC3O00240001002E8B000F00290001000E0004EC3O002900012O00FE000300013O001228010400103O001228010500114O0037000300054O007300035O002E8B00120066000100130004EC3O00660001002E430014003B000100140004EC3O006600012O00FE00036O0004000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003006600013O0004EC3O006600012O00FE000300033O0006F80003006600013O0004EC3O006600012O00FE000300043O0020ED0003000300174O00055O00202O0005000500184O00030005000200062O0003006600013O0004EC3O006600012O00FE000300043O0020700003000300194O00055O00202O00050005001A4O00030005000200062O00030066000100010004EC3O006600012O00FE00036O0002000400013O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O00030003001D4O000300020002000E2O001E0066000100030004EC3O00660001002E8B002000660001001F0004EC3O006600012O00FE000300024O007A000400053O00202O0004000400214O000500063O00202O0005000500224O00075O00202O00070007001A4O0005000700024O000500056O000600016O00030006000200062O0003006600013O0004EC3O006600012O00FE000300013O001228010400233O001228010500244O0037000300054O007300035O001228010200053O002E8B0025000C000100260004EC3O000C00010026320002000C000100050004EC3O000C00010012282O0100273O0004EC3O006E00010004EC3O000C0001002632000100D7000100010004EC3O00D70001001228010200014O00E3000300033O002E8B00290072000100280004EC3O00720001002E8B002A00720001002B0004EC3O0072000100263200020072000100010004EC3O00720001001228010300013O0026320003007D000100050004EC3O007D00010012282O0100053O0004EC3O00D7000100262D00030081000100010004EC3O00810001002E1C002D00790001002C0004EC3O007900010012280104002E4O0014000400076O000400096O000500093O00122O0006002F6O0007000A6O00088O000900013O00122O000A00303O00122O000B00316O0009000B00024O00080008000900202O0008000800324O000800096O00078O00053O00024O0006000B3O00122O0007002F6O0008000A6O00098O000A00013O00122O000B00303O00122O000C00316O000A000C00024O00090009000A00202O0009000900324O0009000A6O00088O00063O00024O0005000500064O0006000A6O00078O000800013O00122O000900333O00122O000A00346O0008000A00024O00070007000800202O0007000700324O000700086O00068O00043O00024O0005000B6O000600093O00122O0007002F6O0008000A6O00098O000A00013O00122O000B00303O00122O000C00316O000A000C00024O00090009000A00202O0009000900324O0009000A6O00088O00063O00024O0007000B3O00122O0008002F6O0009000A6O000A8O000B00013O00122O000C00303O00122O000D00316O000B000D00024O000A000A000B00202O000A000A00324O000A000B6O00098O00073O00024O0006000600074O0007000A6O00088O000900013O00122O000A00333O00122O000B00346O0009000B00024O00080008000900202O0008000800324O000800096O00078O00053O00024O0004000400052O00F9000400083O001228010300053O0004EC3O007900010004EC3O00D700010004EC3O00720001002E4300350030FF2O00350004EC3O0007000100263200010007000100270004EC3O00070001002E4300360022000100360004EC3O00FD00012O00FE00026O0004000300013O00122O000400373O00122O000500386O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200FD00013O0004EC3O00FD00012O00FE000200024O007A000300053O00202O0003000300394O000400063O00202O0004000400224O00065O00202O00060006003A4O0004000600024O000400046O000500016O00020005000200062O000200FD00013O0004EC3O00FD00012O00FE000200013O00128C0003003B3O00122O0004003C6O000200046O00025O00044O00FD00010004EC3O000700010004EC3O00FD00010004EC3O000200012O0014012O00017O006F3O00028O00025O0094A640025O0072A440026O00F03F025O00208D40025O0008AF40025O00D0B140025O000CA540025O00C6A340025O0002AF40025O00108740025O0022A140025O00FEB140025O008CAA40025O0036AA40025O0021B140025O00F49C40025O00389B40027O0040025O0014A340025O0008A440026O000840030C3O00AAC414B13A23F88BD314B83303073O00A8E4A160D95F51030B3O004973417661696C61626C65030C3O00F5D43A542A45EBDE3C482E5B03063O0037BBB14E3C4F030F3O00432O6F6C646F776E52656D61696E73026O003E4003063O0042752O66557003103O004E6574686572506F7274616C42752O66030F3O001ECF5CF94FC9892ECB5BD849DA8C3E03073O00E04DAE3F8B26AF025O0016B140025O0048B040025O00F6A740025O0026A140025O00A2A740025O00FAA5402O033O00474344026O00E03F025O00D8A240025O00407640025O00E0B140025O004AB34003133O00F7DE1EC952F88CC1C61CCA54F59CDDD912CA4903073O00C8A4AB73A43D96025O00E4A640025O00488440025O002CA040025O004C9240025O000CB040025O00BCAE40025O0056AB40025O00DEAA40025O00C89540025O00A0604003073O0047657454696D6503063O0092F51051B39703053O00E3DE946325026O005E40025O00608B40025O00CEA940025O00405540026O003940025O00406A4003133O00144053F8FD045340FAF6305941D2FC205B55F803053O0099532O3296025O00D4A640025O00D4AB40026O007B40025O00F07E40025O00805040025O00C09640025O0076A440025O00A89440030F3O006E637E117CA57B547A761A7AAE435903073O002D3D16137C13CB03103O00E60004F80D79ABC43408F90565B8D31603073O00D9A1726D956210025O0025B040025O00C8A240030F3O00212O3571B37A24293479BA7D172E3C03063O00147240581CDC03103O001613DBB9F7D9AF3427D7B8FFC5BC230503073O00DD5161B2D498B003073O0048617354696572025O00708B40025O002CA940030F3O00FEF210F615C3D114F71FCBEE18F51E03053O007AAD877D9B025O00C06F40025O00B2A940025O00649640025O00FCA440025O002EA540025O00088640026O001440026O001840026O001040026O00204003133O00B75455238B4F7C2B894E56278775413C854F4C03043O004EE42138026O00344003093O0042752O66537461636B030F3O0044656D6F6E6963436F726542752O6603083O0042752O66446F776E030F3O00FD6BBF0E8AC048BB0F80C877B70D8103053O00E5AE1ED26303113O0038EC8A5DC92F3C1AE99545EC31321EFF9503073O00597B8DE6318D5D00E3012O001228012O00014O00E3000100033O002E1C00030009000100020004EC3O000900010026323O0009000100010004EC3O000900010012282O0100014O00E3000200023O001228012O00043O002E8B00050002000100060004EC3O000200010026323O0002000100040004EC3O000200012O00E3000300033O00262D00010012000100010004EC3O00120001002E8B00070021000100080004EC3O00210001001228010400013O00262D00040017000100040004EC3O00170001002E8B000A0019000100090004EC3O001900010012282O0100043O0004EC3O00210001000E820001001D000100040004EC3O001D0001002E1C000C00130001000B0004EC3O00130001001228010200014O00E3000300033O001228010400043O0004EC3O00130001002E8B000E000E0001000D0004EC3O000E000100262D00010027000100040004EC3O00270001002E1C0010000E0001000F0004EC3O000E0001002E1C0012006F000100110004EC3O006F00010026320002006F000100130004EC3O006F0001001228010400013O00263200040043000100040004EC3O004300012O00FE00056O0079000600013O00122O000700046O000800036O0006000800024O000700023O00122O000800046O000900036O0007000900024O00060006000700062O00050008000100060004EC3O00410001002E1C0015003D000100140004EC3O003D00010004EC3O004100012O00FE000500044O00DA0005000100022O00E1000500054O00F9000500033O001228010200163O0004EC3O006F00010026320004002C000100010004EC3O002C00012O00FE000500064O0004000600073O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500194O00050002000200062O0005006000013O0004EC3O006000012O00FE000500064O0057000600073O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600202O00050005001C4O000500020002000E2O001D0060000100050004EC3O006000012O00FE000500083O00202E01050005001E4O000700063O00202O00070007001F4O00050007000200044O006100012O008800056O0036010500014O00F9000500054O00EF000500096O000600066O000700073O00122O000800203O00122O000900216O0007000900024O00060006000700202O0006000600194O000600076O00053O00024O000300053O00122O000400043O00044O002C0001002E8B002300F6000100220004EC3O00F6000100262D00020075000100010004EC3O00750001002E8B002400F6000100250004EC3O00F60001001228010400013O000E2800040090000100040004EC3O00900001002E8B0027008E000100260004EC3O008E00012O00FE0005000A4O00DA0005000100020006F80005008E00013O0004EC3O008E00012O00FE0005000B4O00DA0005000100020006F80005008E00013O0004EC3O008E00012O00FE0005000D4O00CD0006000E6O0006000100024O0007000F6O000700016O00053O00024O000600083O00202O0006000600284O00060002000200202O0006000600294O0005000500064O0005000C3O001228010200043O0004EC3O00F60001002E8B002B00940001002A0004EC3O0094000100262D00040096000100010004EC3O00960001002E1C002D00760001002C0004EC3O007600012O00FE000500064O0072000600073O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O00050005001C4O0005000200024O000500103O002E2O003100F4000100300004EC3O00F400012O00FE000500114O00FE000600124O004B0005000200020006F8000500F400013O0004EC3O00F40001001228010500014O00E3000600073O002E1C003300AF000100320004EC3O00AF0001000E28000100AF000100050004EC3O00AF0001001228010600014O00E3000700073O001228010500043O000E82000400B3000100050004EC3O00B30001002E1C003400A8000100350004EC3O00A80001002E8B003700B7000100360004EC3O00B7000100262D000600B9000100010004EC3O00B90001002E1C003800B3000100390004EC3O00B3000100128E0008003A4O00170108000100024O000900136O000A00073O00122O000B003B3O00122O000C003C6O000A000C00024O00090009000A4O00080008000900102O0007003D0008002E2O003E00F40001003F0004EC3O00F40001000ED8000100F4000100070004EC3O00F400012O00FE000800014O0027010900146O000A00156O0008000A00024O000900026O000A00146O000B00156O0009000B00024O00080008000900202O00080008003D00262O000800DF000100400004EC3O00DF00012O00FE000800014O002A000900146O000A00156O0008000A00024O000900026O000A00146O000B00156O0009000B00024O00080008000900202O00080008003D000E2O004100E2000100080004EC3O00E200012O00FE000800153O000EFD004200F4000100080004EC3O00F400012O00FE000800123O0006F8000800F400013O0004EC3O00F400012O00FE000800064O00BC000900073O00122O000A00433O00122O000B00446O0009000B00024O00080008000900202O0008000800194O00080002000200062O000800F4000100010004EC3O00F400012O00F9000700103O0004EC3O00F400010004EC3O00B300010004EC3O00F400010004EC3O00A80001001228010400043O0004EC3O007600010026320002006E2O0100040004EC3O006E2O01001228010400013O002E8B004500FD000100460004EC3O00FD000100262D000400FF000100010004EC3O00FF0001002E4300470054000100480004EC3O00512O01002E1C004900272O01004A0004EC3O00272O01002E8B004C00272O01004B0004EC3O00272O012O00FE000500064O00BC000600073O00122O0007004D3O00122O0008004E6O0006000800024O00050005000600202O0005000500194O00050002000200062O000500272O0100010004EC3O00272O012O00FE000500064O0004000600073O00122O0007004F3O00122O000800506O0006000800024O00050005000600202O0005000500194O00050002000200062O000500272O013O0004EC3O00272O012O00FE0005000B4O00DA0005000100020006F8000500272O013O0004EC3O00272O012O00FE0005000D4O00CD0006000F6O0006000100024O000700166O000700016O00053O00024O000600083O00202O0006000600284O00060002000200202O0006000600294O0005000500064O0005000C3O002E8B005200502O0100510004EC3O00502O012O00FE000500064O00BC000600073O00122O000700533O00122O000800546O0006000800024O00050005000600202O0005000500194O00050002000200062O000500502O0100010004EC3O00502O012O00FE000500064O0004000600073O00122O000700553O00122O000800566O0006000800024O00050005000600202O0005000500194O00050002000200062O000500442O013O0004EC3O00442O012O00FE000500083O0020C200050005005700122O0007001D3O00122O000800136O00050008000200062O000500502O0100010004EC3O00502O012O00FE0005000B4O00DA0005000100020006F8000500502O013O0004EC3O00502O012O00FE0005000F4O00110005000100024O000600083O00202O0006000600284O00060002000200202O0006000600294O0005000500064O0005000C3O001228010400043O00262D000400552O0100040004EC3O00552O01002E8B005900F9000100580004EC3O00F900012O00FE0005000A4O00DA000500010002000678000500632O0100010004EC3O00632O012O00FE000500064O00BC000600073O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O0005000500194O00050002000200062O000500692O0100010004EC3O00692O012O00FE0005000B4O00DA0005000100020006F8000500692O013O0004EC3O00692O01002E8B005D006B2O01005C0004EC3O006B2O01001228010500014O00F90005000C3O001228010200133O0004EC3O006E2O010004EC3O00F90001000E82001600742O0100020004EC3O00742O01002E16005E00742O01005F0004EC3O00742O01002E8B00600027000100610004EC3O002700012O00FE00046O0061000500013O00122O000600136O000700036O0005000700024O000600023O00122O000700136O000800036O0006000800024O00050005000600062O000500932O0100040004EC3O00932O012O00FE00046O0061000500013O00122O000600626O000700036O0005000700024O000600023O00122O000700626O000800036O0006000800024O00050005000600062O000400932O0100050004EC3O00932O012O00FE000400174O00DA000400010002002650000400912O0100630004EC3O00912O012O008800046O0036010400014O00F9000400034O00FE00046O0061000500013O00122O000600646O000700036O0005000700024O000600023O00122O000700646O000800036O0006000800024O00050005000600062O000500A62O0100040004EC3O00A62O012O00FE000400174O00DA000400010002002650000400A42O0100650004EC3O00A42O012O008800046O0036010400014O00F9000400034O00FE000400064O0048000500073O00122O000600663O00122O000700676O0005000700024O00040004000500202O00040004001C4O00040002000200262O000400D92O0100680004EC3O00D92O012O00FE000400103O002606010400D92O0100680004EC3O00D92O012O00FE000400083O0020FF0004000400694O000600063O00202O00060006006A4O00040006000200262O000400C12O0100130004EC3O00C12O012O00FE000400083O0020ED00040004006B4O000600063O00202O00060006006A4O00040006000200062O000400DB2O013O0004EC3O00DB2O012O00FE000400064O0086000500073O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004001C4O0004000200024O000500193O00202O00050005006200062O000400D92O0100050004EC3O00D92O012O00FE000400064O00D6000500073O00122O0006006E3O00122O0007006F6O0005000700024O00040004000500202O00040004001C4O0004000200024O000500193O00202O00050005006200062O000400DA2O0100050004EC3O00DA2O012O008800046O0036010400014O00F9000400183O0004EC3O00E22O010004EC3O002700010004EC3O00E22O010004EC3O000E00010004EC3O00E22O010004EC3O000200012O0014012O00017O00143O00028O00025O0094A340025O004CAA40030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574026O004440025O001BB040025O0069B140025O00C05E40025O00508740026O00F03F025O0008AF40025O00A06940025O006CAD40025O00608F4003133O0048616E646C65426F2O746F6D5472696E6B6574025O00E09B40025O0010A140025O005CB140025O00F08B4000413O001228012O00013O0026323O002B000100010004EC3O002B00010012282O0100013O00262D00010008000100010004EC3O00080001002E8B00030024000100020004EC3O00240001001228010200013O0026320002001D000100010004EC3O001D00012O00FE00035O002O200103000300054O000400016O000500023O00122O000600066O000700076O00030007000200122O000300043O00122O000300043O00062O0003001A000100010004EC3O001A0001002E160007001A000100080004EC3O001A0001002E1C000A001C000100090004EC3O001C000100128E000300044O0047000300023O0012280102000B3O00262D000200210001000B0004EC3O00210001002E8B000C00090001000D0004EC3O000900010012282O01000B3O0004EC3O002400010004EC3O0009000100262D000100280001000B0004EC3O00280001002E1C000E00040001000F0004EC3O00040001001228012O000B3O0004EC3O002B00010004EC3O000400010026323O00010001000B0004EC3O000100012O00FE00015O0020EB0001000100104O000200016O000300023O00122O000400066O000500056O00010005000200122O000100043O002E2O0011003A000100120004EC3O003A000100128E000100043O0006780001003C000100010004EC3O003C0001002E8B00130040000100140004EC3O0040000100128E000100044O0047000100023O0004EC3O004000010004EC3O000100012O0014012O00017O00243O00028O00026O00F03F025O00C49940025O0087B040025O00F2A840025O00809540025O0038824003123O00C778FB091258F670F5041944F445F7001F4403063O002A9311966C7003123O004973457175692O706564416E64526561647903063O0042752O66557003103O0044656D6F6E6963506F77657242752O6603133O003CB32072E8E62BA32070E9E10C92346D2OE61B03063O00886FC64D1F87030B3O004973417661696C61626C6503103O004E6574686572506F7274616C42752O66030C3O002C0CB35EB8F627A6101DA65A03083O00C96269C736DD8477025O004EAB40025O00D2B04003123O0054696D65627265616368696E6754616C6F6E025O00F6A240025O002EA340031B3O00AD058E240027A9B80F8B280C3293AD0D8F2E0C75A5AD098E32426703073O00CCD96CE341625503133O006DD6F8E823CE7AC6F8EA22C95DF7ECF72DCE4A03063O00A03EA395854C025O0082AA40025O0052A540025O004FB040025O00E8B140025O00789D40025O0042AF40025O00ACAD40025O004C9040025O00D0A14000903O001228012O00014O00E3000100023O00262D3O0006000100020004EC3O00060001002E1C00040089000100030004EC3O00890001002E4300053O000100050004EC3O0006000100263200010006000100010004EC3O00060001001228010200013O002E1C0007000B000100060004EC3O000B00010026320002000B000100010004EC3O000B00012O00FE00036O0004000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003B00013O0004EC3O003B00012O00FE000300023O00207000030003000B4O000500033O00202O00050005000C4O00030005000200062O0003003D000100010004EC3O003D00012O00FE000300034O00BC000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003003B000100010004EC3O003B00012O00FE000300023O00207000030003000B4O000500033O00202O0005000500104O00030005000200062O0003003D000100010004EC3O003D00012O00FE000300034O0004000400013O00122O000500113O00122O000600126O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003003D00013O0004EC3O003D0001002E1C0014004A000100130004EC3O004A00012O00FE000300044O00FE000400053O0020A60004000400152O004B00030002000200067800030045000100010004EC3O00450001002E4300160007000100170004EC3O004A00012O00FE000300013O001228010400183O001228010500194O0037000300054O007300036O00FE000300034O0004000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003005B00013O0004EC3O005B00012O00FE000300023O0020ED00030003000B4O000500033O00202O00050005000C4O00030005000200062O0003008F00013O0004EC3O008F0001001228010300014O00E3000400063O0026320003007C000100020004EC3O007C00012O00E3000600063O002E8B001D00730001001C0004EC3O0073000100263200040073000100020004EC3O00730001002E43001E3O0001001E0004EC3O00640001000E2800010064000100050004EC3O006400012O00FE000700064O00DA0007000100022O007D000600073O002E1C0020008F0001001F0004EC3O008F00010006F80006008F00013O0004EC3O008F00012O0047000600023O0004EC3O008F00010004EC3O006400010004EC3O008F0001002E1C00220060000100210004EC3O0060000100263200040060000100010004EC3O00600001001228010500014O00E3000600063O001228010400023O0004EC3O006000010004EC3O008F000100262D00030080000100010004EC3O00800001002E8B0024005D000100230004EC3O005D0001001228010400014O00E3000500053O001228010300023O0004EC3O005D00010004EC3O008F00010004EC3O000B00010004EC3O008F00010004EC3O000600010004EC3O008F00010026323O0002000100010004EC3O000200010012282O0100014O00E3000200023O001228012O00023O0004EC3O000200012O0014012O00017O00343O00028O00026O00F03F025O0050B240025O0093B140025O00D88440025O00C05140025O007C9840025O00F07340025O0082B140025O00D2A540025O00888140025O00A7B140030A3O00F4A51F3CC6C4AB0421C403053O00A3B6C06D4F030A3O0049734361737461626C65025O00E7B140025O0062AD40025O00288540025O00689640025O0016A640030A3O004265727365726B696E6703113O00362312D3F0262D09CEF2742907C3F1747203053O0095544660A0025O00F8A340025O00FCAA40025O00B0984003093O001A0A02E23C2018FF2103043O008D58666D03093O00426C2O6F6446757279025O001C9940026O00344003113O00B15FC57F1E0253D4A14A8A7F1D3E5181E503083O00A1D333AA107A5D35025O00108E40025O003AB240025O0044A840025O0044B34003093O00DDA7A02DF9A2BD27FF03043O00489BCED2025O00A09D40025O00B09A40025O00049340025O00707F4003093O0046697265626C2O6F64025O00907B40025O0007B34003103O004073460B314A755B0A73497D570A731E03053O0053261A346E025O004EAD40025O00D88640025O0022AF40025O0010944000833O001228012O00014O00E3000100023O00262D3O0006000100020004EC3O00060001002E8B00030078000100040004EC3O0078000100262D0001000A000100010004EC3O000A0001002E1C00050006000100060004EC3O00060001001228010200013O00262D00020011000100010004EC3O00110001002E9400070011000100080004EC3O00110001002E1C000900520001000A0004EC3O00520001001228010300013O00263200030016000100020004EC3O00160001001228010200023O0004EC3O00520001002E1C000B00120001000C0004EC3O0012000100263200030012000100010004EC3O001200012O00FE00046O00BC000500013O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000F4O00040002000200062O00040028000100010004EC3O00280001002E1600100028000100110004EC3O00280001002E430012000F000100130004EC3O00350001002E430014000D000100140004EC3O003500012O00FE000400024O00FE00055O0020A60005000500152O004B0004000200020006F80004003500013O0004EC3O003500012O00FE000400013O001228010500163O001228010600174O0037000400064O007300045O002E430018001B000100180004EC3O00500001002E1C001A0050000100190004EC3O005000012O00FE00046O0004000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004005000013O0004EC3O005000012O00FE000400024O00FE00055O0020A600050005001D2O004B0004000200020006780004004B000100010004EC3O004B0001002E43001E00070001001F0004EC3O005000012O00FE000400013O001228010500203O001228010600214O0037000400064O007300045O001228010300023O0004EC3O00120001000E8200020058000100020004EC3O00580001002E9400230058000100220004EC3O00580001002E8B0025000B000100240004EC3O000B00012O00FE00036O00BC000400013O00122O000500263O00122O000600276O0004000600024O00030003000400202O00030003000F4O00030002000200062O00030066000100010004EC3O00660001002E1600280066000100290004EC3O00660001002E8B002A00820001002B0004EC3O008200012O00FE000300024O00FE00045O0020A600040004002C2O004B0003000200020006780003006E000100010004EC3O006E0001002E8B002E00820001002D0004EC3O008200012O00FE000300013O00128C0004002F3O00122O000500306O000300056O00035O00044O008200010004EC3O000B00010004EC3O008200010004EC3O000600010004EC3O00820001002E1C00320002000100310004EC3O00020001002E8B00340002000100330004EC3O000200010026323O0002000100010004EC3O000200010012282O0100014O00E3000200023O001228012O00023O0004EC3O000200012O0014012O00017O00E53O00028O00026O00F03F025O00A6A340025O00309C40025O0080A740025O00109E40030B3O0072E14E8550DD50904AE15703043O00E0228E3903073O004973526561647903093O0042752O66537461636B030F3O0044656D6F6E6963436F726542752O66026O001040030F3O00EDB2C8D07CFF6B07D2A2C3D476FF5903083O006EBEC7A5BD13913D030B3O004973417661696C61626C6503083O0042752O66446F776E03103O004E6574686572506F7274616C42752O66025O000C9F40025O00088140030B3O00506F776572536970686F6E03163O00CAE460ED99F8C9E267E084C99AFF6EFA8AC9CEAB26BA03063O00A7BA8B1788EB027O0040025O00707240025O0020B340025O00B4934003093O00191390144E23178F1603053O0021507EE078026O00084003133O00CBBA02CA58DBA911C853EFA310E059FFA104CA03053O003C8CC863A4026O003740025O0034AC4003093O00496D706C6F73696F6E03093O004973496E52616E6765026O00444003123O008EF9142AAD94FD0B28E293ED1627AC93B45C03053O00C2E7946446025O00DCB240025O00F49A40030A3O007544C0A7F9DF6443CDB703063O00A8262CA1C39603083O00507265764743445003103O004772696D6F69726546656C6775617264026O003E40030A3O00536861646F77426F6C74030E3O0049735370652O6C496E52616E676503153O0093F483723FFF89148FF0963624F1A4178EE8C2276003083O0076E09CE2165088D6025O008EAE40025O0024A440030A3O0029BD890915A2AA0216A103043O006D7AD5E8026O001440025O008EB040025O00C0554003153O00FDFFA334E1E09D32E1FBB670FAEEB031E0E3E261BA03043O00508E97C2025O00D4A340030C3O002DC3634406D4474311D2764003043O002C63A617025O0069B040025O00CCA040030C3O004E6574686572506F7274616C03173O0072F23D3E36B643E7262427A570B73D2F21A572E369676503063O00C41C97495653025O001AB040030F3O00C016241D8D562E7FFF062F1987561C03083O001693634970E2387803063O0042752O66557003133O008B60EFF882B651E7F882B67CE1C194AA74ECE103053O00EDD8158295030F3O00432O6F6C646F776E52656D61696E73026O002A40030F3O0053752O6D6F6E56696C656669656E64031A3O00915B2O52BFC7619447535AB6C05B8C4A1F4BA9DB5F8C5A1F0EE803073O003EE22E2O3FD0A9025O0086A240025O00BCA440025O0014AB40025O00A8B140025O0008A840025O003AB240030C3O0070162942571100535413264803043O002638774703133O00C0FA55DB2A58D7EA55D92B5FF0DB41C42458E703063O0036938F38B64503083O004361737454696D65025O00B88D40025O000C9040025O00AC9F40025O00ACA740025O005AA940025O00DCAB40030C3O0048616E646F6647756C64616E025O00649540025O0094A14003173O00DE80F14DE0D987C04ECADA85FE479FC298ED48D1C2C1AD03053O00BFB6E19F2903133O00180725588489E62E1F275B8284F63200295B9F03073O00A24B724835EBE7030B3O004578656375746554696D65030A3O00BF3445E65C15AE3348F603063O0062EC5C248233030F3O0048616E646C65445053506F74696F6E025O00488D40025O0094AD40025O0086A440025O00D07740025O00B07140025O00C0B140025O00508340025O00D8AD40025O00288C40025O007AB040025O00BFB040026O005F40025O00ABB240025O009EAF40025O0012A440025O009CAE40025O00A4AF40025O00749540025O00A4A840025O00B89F40025O00349040025O0026B140025O0062AD40025O00508540025O002OA040025O00208A40025O00FC9540025O00FC9D40025O00BCA340025O00D49A4003133O00970C01B74AA69135A91602B3469CAC22A5171803083O0050C4796CDA25C8D5030A3O0049734361737461626C6503133O0033660F724400AE057E0D71420DBE196103715F03073O00EA6013621F2B6E030A3O00351753C3A365A909134603073O00EB667F32A7CC12025O0072A240025O009C904003133O0053752O6D6F6E44656D6F6E6963547972616E74031E3O0043B4F82E4B206FA5F02E4B2059A2CA375D3C51AFE163503742A0FB37047803063O004E30C1954324025O0048AC40025O005CA040025O00F89B40025O002AA940025O006BB140025O0016AE4003093O0072AA31111DE1FC5ABB03073O009336CF5C7E7383030F3O003E24387002703B3839780B77083F3103063O001E6D51551D6D03093O0044656D6F6E626F6C7403133O00FB7459B938DC2OF36514A22FCCFDF16514E46003073O009C9F1134D656BE030B3O009EE0AAB9BCDCB4ACA6E0B303043O00DCCE8FDD03133O00B568201AD7C2F683702219D1CFE69F6F2C19CC03073O00B2E61D4D77B8AC025O0032A740025O00109D40025O00EC9A40025O001EA34003163O00E5B11D1E65C7E6B71A1378F6B5AA130976F6E1FE584303063O009895DE6A7B17030A3O00EE2EF747BACA04F94FA103053O00D5BD469623025O00BC9240025O00AEAB40025O00449940025O008EA940025O0096A040025O0080434003153O005C5D750C40424B0A405960485B4C66092O41345B1F03043O00682F3514030C3O0026AC7EE0048429B87CE00A8C03063O00E26ECD10846B030F3O00D8D6EDD44EE5F5E9D544EDCAE5D74503053O00218BA380B9030A3O005370652O6C4861737465025O00A8A040025O00206940025O001AA840025O0038924003183O005F590ADA685702E1504D08DA2O5644CA4E4A05D04318568A03043O00BE373864025O00F2B040025O007DB140025O008DB140025O0026AC4003113O00C618598F3B1F2A5FE10A418213062A4CF603083O003E857935E37F6D4F030F3O0023013FF8D9A094191837F3DFABAC1403073O00C270745295B6CE030C3O0017AD5810C5F03E36BA5819CC03073O006E59C82C78A082030C3O0085C65F4E46580B42B9D72O4A03083O002DCBA32B26232A5B03133O00E190D12E88A770D788D32D8EAA60CB97DD2D9303073O0034B2E5BC43E7C9026O002640025O0036A640025O003EA74003113O0043612O6C44726561647374616C6B657273031C3O0022405C08C8583124405417E35D2F2A444217B7483A33405E10B70E7303073O004341213064973C03103O00F8F5A7D5FCD6F5ABFEF6D3E0BBD9E1DB03053O0093BF87CEB8030F3O00B73DABCCD75D848D24A3C7D156BC8003073O00D2E448C6A1B833030C3O00184CE71876DC0646E10472C203063O00AE5629937013030C3O0075059903201D21A449148C0703083O00CB3B60ED6B456F71025O00149F40025O00C06540025O00206A40025O00D2A040025O00109B40025O00B2AB40031B3O002304A5EC3EF9C52129AAE43DF7C22504A8A125E9C52518B8A163A203073O00B74476CC815190025O00949140026O00504000D3042O001228012O00014O00E3000100023O00262D3O0006000100020004EC3O00060001002E1C000300CA040100040004EC3O00CA040100263200010006000100010004EC3O00060001001228010200013O002632000200C7000100020004EC3O00C70001001228010300013O002E1C0006004A000100050004EC3O004A00010026320003004A000100020004EC3O004A00012O00FE00046O0004000500013O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O00040002000200062O0004003A00013O0004EC3O003A00012O00FE000400023O00200E01040004000A4O00065O00202O00060006000B4O00040006000200262O0004003A0001000C0004EC3O003A00012O00FE000400034O00DA0004000100020006F80004003300013O0004EC3O003300012O00FE00046O00BC000500013O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004003A000100010004EC3O003A00012O00FE000400044O00DA0004000100020006F80004003A00013O0004EC3O003A00012O00FE000400023O0020700004000400104O00065O00202O0006000600114O00040006000200062O0004003C000100010004EC3O003C0001002E430012000E000100130004EC3O004800012O00FE000400054O009D00055O00202O0005000500144O000600066O00040006000200062O0004004800013O0004EC3O004800012O00FE000400013O001228010500153O001228010600164O0037000400064O007300045O001228010200173O0004EC3O00C70001002E43001800C2FF2O00180004EC3O000C0001000E8200010050000100030004EC3O00500001002E1C0019000C0001001A0004EC3O000C00012O00FE00046O0004000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008E00013O0004EC3O008E00012O00FE000400074O00DA000400010002000ED80017008E000100040004EC3O008E00012O00FE000400084O00DA0004000100020006780004008E000100010004EC3O008E00012O00FE000400094O00DA0004000100020006780004008E000100010004EC3O008E00012O00FE000400034O00DA0004000100020006780004008E000100010004EC3O008E00012O00FE0004000A3O000E34001D007A000100040004EC3O007A00012O00FE0004000A3O000ED80017008E000100040004EC3O008E00012O00FE00046O0004000500013O00122O0006001E3O00122O0007001F6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004008E00013O0004EC3O008E0001002E1C0020008E000100210004EC3O008E00012O00FE000400054O00E000055O00202O0005000500224O0006000B6O000700076O0008000C3O00202O00080008002300122O000A00246O0008000A00024O000800086O00040008000200062O0004008E00013O0004EC3O008E00012O00FE000400013O001228010500253O001228010600264O0037000400064O007300045O002E8B002800C5000100270004EC3O00C500012O00FE00046O0004000500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400C500013O0004EC3O00C500012O00FE000400023O00201A00040004002B00122O000600026O00075O00202O00070007002C4O00040007000200062O000400C500013O0004EC3O00C500012O00FE0004000D3O000ED8002D00C5000100040004EC3O00C500012O00FE000400023O0020ED0004000400104O00065O00202O0006000600114O00040006000200062O000400C500013O0004EC3O00C500012O00FE000400023O0020ED0004000400104O00065O00202O00060006000B4O00040006000200062O000400C500013O0004EC3O00C500012O00FE000400054O001501055O00202O00050005002E4O000600076O0008000C3O00202O00080008002F4O000A5O00202O000A000A002E4O0008000A00024O000800086O00040008000200062O000400C500013O0004EC3O00C500012O00FE000400013O001228010500303O001228010600314O0037000400064O007300045O001228010300023O0004EC3O000C0001002632000200552O0100170004EC3O00552O01001228010300013O00262D000300CE000100010004EC3O00CE0001002E1C003200222O0100330004EC3O00222O012O00FE00046O0004000500013O00122O000600343O00122O000700356O0005000700024O00040004000500202O0004000400094O00040002000200062O000400F000013O0004EC3O00F000012O00FE000400034O00DA000400010002000678000400F0000100010004EC3O00F000012O00FE000400023O0020ED0004000400104O00065O00202O0006000600114O00040006000200062O000400F000013O0004EC3O00F000012O00FE000400084O00DA000400010002000678000400F0000100010004EC3O00F000012O00FE0004000E4O0058000500023O00202O00050005000A4O00075O00202O00070007000B4O00050007000200102O00050036000500062O000400F2000100050004EC3O00F20001002E1C003700042O0100380004EC3O00042O012O00FE000400054O001501055O00202O00050005002E4O000600076O0008000C3O00202O00080008002F4O000A5O00202O000A000A002E4O0008000A00024O000800086O00040008000200062O000400042O013O0004EC3O00042O012O00FE000400013O001228010500393O0012280106003A4O0037000400064O007300045O002E43003B000F0001003B0004EC3O00132O012O00FE00046O0004000500013O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400132O013O0004EC3O00132O012O00FE0004000E3O00262D000400152O0100360004EC3O00152O01002E1C003E00212O01003F0004EC3O00212O012O00FE000400054O009D00055O00202O0005000500404O0006000F6O00040006000200062O000400212O013O0004EC3O00212O012O00FE000400013O001228010500413O001228010600424O0037000400064O007300045O001228010300023O000E28000200CA000100030004EC3O00CA0001002E430043002E000100430004EC3O00522O012O00FE00046O0004000500013O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400094O00040002000200062O000400522O013O0004EC3O00522O012O00FE0004000E3O00262D0004003A2O0100360004EC3O003A2O012O00FE000400023O0020ED0004000400464O00065O00202O0006000600114O00040006000200062O000400522O013O0004EC3O00522O012O00FE00046O0048000500013O00122O000600473O00122O000700486O0005000700024O00040004000500202O0004000400494O00040002000200262O000400522O01004A0004EC3O00522O012O00FE000400103O0006F8000400522O013O0004EC3O00522O012O00FE000400054O00FE00055O0020A600050005004B2O004B0004000200020006F8000400522O013O0004EC3O00522O012O00FE000400013O0012280105004C3O0012280106004D4O0037000400064O007300045O0012280102001D3O0004EC3O00552O010004EC3O00CA000100263200020008030100010004EC3O00080301001228010300013O00262D0003005C2O0100010004EC3O005C2O01002E1C004F005A0201004E0004EC3O005A0201001228010400013O00262D000400632O0100010004EC3O00632O01002E35005100632O0100500004EC3O00632O01002E8B00530055020100520004EC3O005502012O00FE00056O0004000600013O00122O000700543O00122O000800556O0006000800024O00050005000600202O0005000500094O00050002000200062O0005008C2O013O0004EC3O008C2O012O00FE000500114O000B010600126O000700136O00088O000900013O00122O000A00563O00122O000B00576O0009000B00024O00080008000900202O0008000800584O000800096O00063O00024O000700146O000800136O00098O000A00013O00122O000B00563O00122O000C00576O000A000C00024O00090009000A00202O0009000900584O0009000A6O00073O00024O00060006000700062O0006008C2O0100050004EC3O008C2O012O00FE000500114O00FE000600133O0020B700060006000C00069C000500902O0100060004EC3O00902O01002E94005A00902O0100590004EC3O00902O01002E8B005C00A62O01005B0004EC3O00A62O01002E8B005D00A62O01005E0004EC3O00A62O012O00FE000500054O00AA00065O00202O00060006005F4O000700086O0009000C3O00202O00090009002F4O000B5O00202O000B000B005F4O0009000B00024O000900096O00050009000200062O000500A12O0100010004EC3O00A12O01002E1C006100A62O0100600004EC3O00A62O012O00FE000500013O001228010600623O001228010700634O0037000500074O007300056O00FE000500113O000ED800010054020100050004EC3O005402012O00FE000500114O0090000600126O00078O000800013O00122O000900643O00122O000A00656O0008000A00024O00070007000800202O0007000700664O0007000200024O000800154O00FE000900023O0020F50009000900104O000B5O00202O000B000B000B4O0009000B6O00083O00024O00098O000A00013O00122O000B00673O00122O000C00686O000A000C00022O000800090009000A0020360009000900664O0009000200024O0008000800094O0007000700084O000800156O000900023O00202O0009000900464O000B5O00202O000B000B000B4O0009000B4O005600083O00022O009E000900136O0008000800094O0007000700084O000800136O0006000800024O000700146O00088O000900013O00122O000A00643O00122O000B00654O00C10009000B00022O003E00080008000900202O0008000800664O0008000200024O000900156O000A00023O00202O000A000A00104O000C5O00202O000C000C000B4O000A000C6O00093O00022O00FE000A6O00F6000B00013O00122O000C00673O00122O000D00686O000B000D00024O000A000A000B00202O000A000A00664O000A000200024O00090009000A4O0008000800094O000900154O00FE000A00023O0020F3000A000A00464O000C5O00202O000C000C000B4O000A000C6O00093O00024O000A00136O00090009000A4O0008000800094O000900136O0007000900022O007E00060006000700063F00050054020100060004EC3O00540201001228010500014O00E3000600083O0026320005003C020100020004EC3O003C02012O00E3000800083O00263200060008020100170004EC3O000802012O00FE000900163O0020A60009000900692O00DA0009000100022O007D000800093O0006F80008005402013O0004EC3O005402012O0047000800023O0004EC3O0054020100262D0006000C020100020004EC3O000C0201002E1C006B00230201006A0004EC3O00230201001228010900013O000E8200020011020100090004EC3O00110201002E8B006C00130201006D0004EC3O00130201001228010600173O0004EC3O00230201002E1C006E000D0201006F0004EC3O000D02010026320009000D020100010004EC3O000D02012O00FE000A00174O00DA000A000100022O007D0007000A3O002E1C00700021020100710004EC3O0021020100067800070020020100010004EC3O00200201002E1C00730021020100720004EC3O002102012O0047000700023O001228010900023O0004EC3O000D0201002E8B007500FE2O0100740004EC3O00FE2O01000E28000100FE2O0100060004EC3O00FE2O01001228010900013O002E1C00770035020100760004EC3O0035020100263200090035020100010004EC3O003502012O00FE000A00184O00DA000A000100022O007D0007000A3O002E8B00780034020100790004EC3O003402010006F80007003402013O0004EC3O003402012O0047000700023O001228010900023O000E2800020028020100090004EC3O00280201001228010600023O0004EC3O00FE2O010004EC3O002802010004EC3O00FE2O010004EC3O00540201002E1C007B00400201007A0004EC3O0040020100262D00050042020100010004EC3O00420201002E8B007C00FB2O01007D0004EC3O00FB2O01001228010900013O00262D00090049020100020004EC3O00490201002E35007F00490201007E0004EC3O00490201002E8B0080004B020100810004EC3O004B0201001228010500023O0004EC3O00FB2O01002E1C00830043020100820004EC3O0043020100263200090043020100010004EC3O00430201001228010600014O00E3000700073O001228010900023O0004EC3O004302010004EC3O00FB2O01001228010400023O0026320004005D2O0100020004EC3O005D2O01001228010300023O0004EC3O005A02010004EC3O005D2O01002E8B008400582O0100850004EC3O00582O01002632000300582O0100020004EC3O00582O01002E8B008700F7020100860004EC3O00F702012O00FE00046O0004000500013O00122O000600883O00122O000700896O0005000700024O00040004000500202O00040004008A4O00040002000200062O000400F702013O0004EC3O00F702012O00FE000400113O000ED8000100F7020100040004EC3O00F702012O00FE000400114O0080000500126O00068O000700013O00122O0008008B3O00122O0009008C6O0007000900024O00060006000700202O0006000600664O0006000200024O000700126O000800156O000900023O00202O0009000900104O000B5O00202O000B000B000B4O0009000B6O00083O00024O00098O000A00013O00122O000B008D3O00122O000C008E6O000A000C00024O00090009000A00202O0009000900664O0009000200024O0008000800094O000900156O000A00023O00202O000A000A00464O000C5O00202O000C000C000B4O000A000C6O00093O00024O000A00136O00090009000A4O0007000900024O0006000600074O000700146O000800156O000900023O00202O0009000900104O000B5O00202O000B000B000B4O0009000B6O00083O00024O00098O000A00013O00122O000B008D3O00122O000C008E6O000A000C00024O00090009000A00202O0009000900664O0009000200024O0008000800094O000900156O000A00023O00202O000A000A00464O000C5O00202O000C000C000B4O000A000C6O00093O00024O000A00136O00090009000A4O0007000900024O0006000600074O000700136O0005000700024O000600146O00078O000800013O00122O0009008B3O00122O000A008C6O0008000A00024O00070007000800202O0007000700664O0007000200024O000800126O000900156O000A00023O00202O000A000A00102O00FE000C5O00207B000C000C000B4O000A000C6O00093O00024O000A8O000B00013O00122O000C008D3O00122O000D008E6O000B000D00024O000A000A000B00202O000A000A00664O000A000200024O00090009000A4O000A00156O000B00023O00202O000B000B00464O000D5O00202O000D000D000B4O000B000D6O000A3O00024O000B00136O000A000A000B4O0008000A00024O0007000700084O000800146O000900156O000A00023O00202O000A000A00104O000C5O00202O000C000C000B4O000A000C6O00093O00024O000A8O000B00013O00122O000C008D3O00122O000D008E6O000B000D00024O000A000A000B00202O000A000A00664O000A000200024O00090009000A4O000A00156O000B00023O00202O000B000B00464O000D5O00202O000D000D000B4O000B000D6O000A3O00024O000B00136O000A000A000B4O0008000A00024O0007000700084O000800136O0006000800024O00050005000600062O000400F9020100050004EC3O00F90201002E8B008F0005030100900004EC3O000503012O00FE000400054O009D00055O00202O0005000500914O000600196O00040006000200062O0004000503013O0004EC3O000503012O00FE000400013O001228010500923O001228010600934O0037000400064O007300045O001228010200023O0004EC3O000803010004EC3O00582O0100262D0002000E0301000C0004EC3O000E0301002E940094000E030100950004EC3O000E0301002E8B009700AB030100960004EC3O00AB0301002E8B00990048030100980004EC3O004803012O00FE00036O0004000400013O00122O0005009A3O00122O0006009B6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003004803013O0004EC3O004803012O00FE0003000E3O002606010300480301000C0004EC3O004803012O00FE000300023O0020ED0003000300464O00055O00202O00050005000B4O00030005000200062O0003004803013O0004EC3O004803012O00FE000300034O00DA00030001000200067800030036030100010004EC3O003603012O00FE00036O00BC000400013O00122O0005009C3O00122O0006009D6O0004000600024O00030003000400202O00030003000F4O00030002000200062O00030048030100010004EC3O004803012O00FE000300084O00DA0003000100020006F80003004803013O0004EC3O004803012O00FE000300054O001501045O00202O00040004009E4O000500066O0007000C3O00202O00070007002F4O00095O00202O00090009009E4O0007000900024O000700076O00030007000200062O0003004803013O0004EC3O004803012O00FE000300013O0012280104009F3O001228010500A04O0037000300054O007300036O00FE00036O0004000400013O00122O000500A13O00122O000600A26O0004000600024O00030003000400202O0003000300094O00030002000200062O0003007803013O0004EC3O007803012O00FE000300023O00200E01030003000A4O00055O00202O00050005000B4O00030005000200262O000300750301001D0004EC3O007503012O00FE000300114O001D010400126O00058O000600013O00122O000700A33O00122O000800A46O0006000800024O00050005000600202O0005000500664O0005000200024O000600133O00202O00060006001D4O0004000600024O000500146O00068O000700013O00122O000800A33O00122O000900A46O0007000900024O00060006000700202O0006000600664O0006000200024O000700133O00202O00070007001D4O0005000700024O00040004000500062O0004007A030100030004EC3O007A03012O00FE000300113O00262D0003007A030100010004EC3O007A0301002E8B00A50088030100A60004EC3O008803012O00FE000300054O004C00045O00202O0004000400144O000500066O00030005000200062O00030083030100010004EC3O00830301002E8B00A80088030100A70004EC3O008803012O00FE000300013O001228010400A93O001228010500AA4O0037000300054O007300036O00FE00036O00BC000400013O00122O000500AB3O00122O000600AC6O0004000600024O00030003000400202O00030003008A4O00030002000200062O00030094030100010004EC3O00940301002E1C00AE00D2040100AD0004EC3O00D20401002E1C00AF00A3030100B00004EC3O00A303012O00FE000300054O00AA00045O00202O00040004002E4O000500066O0007000C3O00202O00070007002F4O00095O00202O00090009002E4O0007000900024O000700076O00030007000200062O000300A5030100010004EC3O00A50301002E4300B1002F2O0100B20004EC3O00D204012O00FE000300013O00128C000400B33O00122O000500B46O000300056O00035O00044O00D20401002632000200090001001D0004EC3O00090001001228010300013O002632000300FF030100020004EC3O00FF03012O00FE00046O0004000500013O00122O000600B53O00122O000700B66O0005000700024O00040004000500202O0004000400094O00040002000200062O000400E703013O0004EC3O00E703012O00FE0004000E3O000ED8001700E7030100040004EC3O00E703012O00FE000400034O00DA000400010002000678000400CF030100010004EC3O00CF03012O00FE00046O00BC000500013O00122O000600B73O00122O000700B86O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400E7030100010004EC3O00E703012O00FE000400084O00DA0004000100020006F8000400E703013O0004EC3O00E703012O00FE0004000E3O000E34001700E9030100040004EC3O00E903012O00FE0004001A4O00190004000100024O000500126O000600133O00202O0006000600174O000700023O00202O0007000700B94O00070002000200102O0007001700074O0005000700024O000600146O000700133O00202O0007000700174O000800023O00202O0008000800B94O00080002000200102O0008001700084O0006000800024O00050005000600062O000400E9030100050004EC3O00E90301002E8B00BA00FD030100BB0004EC3O00FD0301002E1C00BD00FD030100BC0004EC3O00FD03012O00FE000400054O001501055O00202O00050005005F4O000600076O0008000C3O00202O00080008002F4O000A5O00202O000A000A005F4O0008000A00024O000800086O00040008000200062O000400FD03013O0004EC3O00FD03012O00FE000400013O001228010500BE3O001228010600BF4O0037000400064O007300045O0012280102000C3O0004EC3O00090001000E8200010003040100030004EC3O00030401002E8B00C100AE030100C00004EC3O00AE0301002E8B00C30067040100C20004EC3O006704012O00FE00046O0004000500013O00122O000600C43O00122O000700C56O0005000700024O00040004000500202O0004000400094O00040002000200062O0004006704013O0004EC3O006704012O00FE000400034O00DA00040001000200067800040046040100010004EC3O004604012O00FE00046O00BC000500013O00122O000600C63O00122O000700C76O0005000700024O00040004000500202O00040004000F4O00040002000200062O00040067040100010004EC3O006704012O00FE00046O0004000500013O00122O000600C83O00122O000700C96O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004003804013O0004EC3O003804012O00FE000400023O0020700004000400464O00065O00202O0006000600114O00040006000200062O00040038040100010004EC3O003804012O00FE00046O001B010500013O00122O000600CA3O00122O000700CB6O0005000700024O00040004000500202O0004000400494O000400020002000E2O002D0067040100040004EC3O006704012O00FE000400023O0020700004000400464O00065O00202O0006000600114O00040006000200062O00040046040100010004EC3O004604012O00FE000400094O00DA00040001000200067800040046040100010004EC3O004604012O00FE0004000E3O00263200040067040100360004EC3O006704012O00FE00046O0048000500013O00122O000600CC3O00122O000700CD6O0005000700024O00040004000500202O0004000400494O00040002000200262O00040067040100CE0004EC3O006704012O00FE000400103O0006F80004006704013O0004EC3O00670401002E8B00CF0067040100D00004EC3O006704012O00FE000400054O001501055O00202O0005000500D14O000600076O0008000C3O00202O00080008002F4O000A5O00202O000A000A00D14O0008000A00024O000800086O00040008000200062O0004006704013O0004EC3O006704012O00FE000400013O001228010500D23O001228010600D34O0037000400064O007300046O00FE00046O0004000500013O00122O000600D43O00122O000700D56O0005000700024O00040004000500202O0004000400094O00040002000200062O000400AB04013O0004EC3O00AB04012O00FE000400034O00DA000400010002000678000400AD040100010004EC3O00AD04012O00FE00046O00BC000500013O00122O000600D63O00122O000700D76O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400AB040100010004EC3O00AB04012O00FE00046O0004000500013O00122O000600D83O00122O000700D96O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004009A04013O0004EC3O009A04012O00FE000400023O0020700004000400464O00065O00202O0006000600114O00040006000200062O0004009A040100010004EC3O009A04012O00FE00046O001B010500013O00122O000600DA3O00122O000700DB6O0005000700024O00040004000500202O0004000400494O000400020002000E2O002D00AB040100040004EC3O00AB04012O00FE000400023O0020700004000400464O00065O00202O0006000600114O00040006000200062O000400A8040100010004EC3O00A804012O00FE000400084O00DA000400010002000678000400A8040100010004EC3O00A804012O00FE0004000E3O002632000400AB040100360004EC3O00AB04012O00FE000400103O000678000400AD040100010004EC3O00AD0401002E8B00DC00C4040100DD0004EC3O00C404012O00FE000400054O00E900055O00202O00050005002C4O0006001B6O000700076O0008000C3O00202O00080008002F4O000A5O00202O000A000A002C4O0008000A00024O000800084O00C1000400080002000678000400BF040100010004EC3O00BF0401002E3500DF00BF040100DE0004EC3O00BF0401002E8B00E100C4040100E00004EC3O00C404012O00FE000400013O001228010500E23O001228010600E34O0037000400064O007300045O001228010300023O0004EC3O00AE03010004EC3O000900010004EC3O00D204010004EC3O000600010004EC3O00D20401002E8B00E50002000100E40004EC3O00020001000E280001000200013O0004EC3O000200010012282O0100014O00E3000200023O001228012O00023O0004EC3O000200012O0014012O00017O00873O00028O00025O001EA940025O004AAF40026O00F03F025O00DEA240025O00C88440025O00909F40025O00D89E40025O000C9540025O00409540025O006DB140025O00E8AB40025O00049140025O003AA140026O003440025O0070A640025O00E07340025O00C4A040025O00A08340025O00AEAA40025O0061B140030F3O000AB3B824853781C935A3B3208F37B303083O00A059C6D549EA59D703073O0049735265616479025O00949B40025O00D6B040025O00C08140030F3O0053752O6D6F6E56696C656669656E64031C3O005B64B9F3CA464EA2F7C94D77BDFBCB4C31B2F7C240658BFBCB4C31E203053O00A52811D49E025O00508C40026O006940025O0068B040026O00A840025O00AAA040025O00408C40025O00E09540025O00BDB040025O00649540025O00708640025O002EAE40025O0080AB40025O002EB340025O0066A340025O005EA140025O00F49540025O00E88940025O0034A640025O0001B14003103O00845E8811B306B149A719B008B64D931803063O006FC32CE17CDC03103O004772696D6F69726546656C6775617264031D3O00DF54097EA4A2CA433F75AEA7DF530161AFEBDE4F077BBF94DD480433F903063O00CBB8266013CB03113O001A72754DEA2B767845DD2D72754ACB2B6003053O00AE59131921025O004EAD40025O00AC994003113O0043612O6C44726561647374616C6B657273030E3O0049735370652O6C496E52616E6765025O002FB340025O009CAB40031E3O002C135E42C883192A13565DE386072417405DB78102281A4671F2890F6F4603073O006B4F72322E97E7025O001AAA40030C3O00CBDC1C3B23F7E9072132E4D503053O004685B96853026O003E40026O00AE40025O00408F40030C3O004E6574686572506F7274616C03193O000A405022CC167A5425DB1044486ACF0D424C3EF6014B406A9103053O00A96425244A027O0040025O0072A740026O003040030B3O00B2DEB688ABB78BC1A982B703063O00E4E2B1C1EDD903093O0042752O66537461636B030F3O0044656D6F6E6963436F726542752O66026O000840025O00C8A440025O00D09D40025O0076A640025O006EA940030B3O00506F776572536970686F6E025O00E0A140025O009EA34003193O0024BF34E3268F30EF24B82CE874B62AE13CA41CE33AB463B76003043O008654D043026O007740025O009EB04003093O003AA196501CBF8F531D03043O003C73CCE6025O0010AC40025O0039B14003093O00496D706C6F73696F6E03093O004973496E52616E6765026O004440025O00E9B240025O005EA74003163O00EE37FB7CE829E27FE97AED79E032FF4FE234EF30B66C03043O0010875A8B025O0036A140025O005EA640025O00D8A340025O0035B240025O00408340025O005C9E40025O0030A540025O00E2A740025O00D6B240025O007BB040025O0080434003133O003392AF5D0F8986550D88AC5903B3BB420189B603043O003060E7C2030A3O0049734361737461626C65025O0050B240025O00449740025O00FEAE40025O00E2A14003133O0053752O6D6F6E44656D6F6E6963547972616E74026O008A40025O00A2B24003223O00DB4F032016D69087CD57012310DB9097D1480F230D98A98ACF521A121CD6ABC3990A03083O00E3A83A6E4D79B8CF025O00389E40030F3O005F39B24FBFD272966F2EBA4EB6CF7903083O00C51B5CDF20D1BB11026O002440030F3O0044656D6F6E6963537472656E677468031D3O00075ACEF40D56C0C4104BD1FE0D58D7F34359CAFC0B4BFCFE0D5B83AA5103043O009B633FA3025O00ACB140025O0074A4400083012O001228012O00014O00E3000100023O00262D3O0006000100010004EC3O00060001002E1C00030009000100020004EC3O000900010012282O0100014O00E3000200023O001228012O00043O0026323O0002000100040004EC3O00020001002E1C0006000B000100050004EC3O000B000100262D00010011000100010004EC3O00110001002E43000700FCFF2O00080004EC3O000B0001001228010200013O000E8200010016000100020004EC3O00160001002E43000900B60001000A0004EC3O00CA0001001228010300013O00262D0003001B000100040004EC3O001B0001002E43000B00040001000C0004EC3O001D0001001228010200043O0004EC3O00CA000100262D00030021000100010004EC3O00210001002E1C000E00170001000D0004EC3O001700012O00FE00045O002650000400280001000F0004EC3O00280001002E1600100028000100110004EC3O00280001002E8B001200AB000100130004EC3O00AB0001001228010400013O00262D0004002D000100040004EC3O002D0001002E8B00150047000100140004EC3O004700012O00FE000500014O00BC000600023O00122O000700163O00122O000800176O0006000800024O00050005000600202O0005000500184O00050002000200062O00050039000100010004EC3O00390001002E1C001A00AB000100190004EC3O00AB0001002E43001B00720001001B0004EC3O00AB00012O00FE000500034O00FE000600013O0020A600060006001C2O004B0005000200020006F8000500AB00013O0004EC3O00AB00012O00FE000500023O00128C0006001D3O00122O0007001E6O000500076O00055O00044O00AB0001002E1C002000290001001F0004EC3O00290001002E43002100E0FF2O00210004EC3O0029000100263200040029000100010004EC3O00290001001228010500014O00E3000600063O0026320005004F000100010004EC3O004F0001001228010600013O00262D00060056000100040004EC3O00560001002E8B00220058000100230004EC3O00580001001228010400043O0004EC3O00290001002E8B00240052000100250004EC3O00520001000E820001005E000100060004EC3O005E0001002E1C00260052000100270004EC3O00520001001228010700013O00262D00070063000100040004EC3O00630001002E1C00290065000100280004EC3O00650001001228010600043O0004EC3O0052000100262D0007006B000100010004EC3O006B0001002E35002B006B0001002A0004EC3O006B0001002E43002C00F6FF2O002D0004EC3O005F0001002E8B002F00850001002E0004EC3O00850001002E8B00300085000100310004EC3O008500012O00FE000800014O0004000900023O00122O000A00323O00122O000B00336O0009000B00024O00080008000900202O0008000800184O00080002000200062O0008008500013O0004EC3O008500012O00FE000800034O009D000900013O00202O0009000900344O000A00046O0008000A000200062O0008008500013O0004EC3O008500012O00FE000800023O001228010900353O001228010A00364O00370008000A4O007300086O00FE000800014O00BC000900023O00122O000A00373O00122O000B00386O0009000B00024O00080008000900202O0008000800184O00080002000200062O00080091000100010004EC3O00910001002E1C003900A50001003A0004EC3O00A500012O00FE000800034O00AA000900013O00202O00090009003B4O000A000B6O000C00053O00202O000C000C003C4O000E00013O00202O000E000E003B4O000C000E00024O000C000C6O0008000C000200062O000800A0000100010004EC3O00A00001002E43003D00070001003E0004EC3O00A500012O00FE000800023O0012280109003F3O001228010A00404O00370008000A4O007300085O001228010700043O0004EC3O005F00010004EC3O005200010004EC3O002900010004EC3O004F00010004EC3O00290001002E1C004100C8000100290004EC3O00C800012O00FE000400014O0004000500023O00122O000600423O00122O000700436O0005000700024O00040004000500202O0004000400184O00040002000200062O000400C800013O0004EC3O00C800012O00FE00045O002606010400C8000100440004EC3O00C80001002E1C004600C8000100450004EC3O00C800012O00FE000400034O009D000500013O00202O0005000500474O000600066O00040006000200062O000400C800013O0004EC3O00C800012O00FE000400023O001228010500483O001228010600494O0037000400064O007300045O001228010300043O0004EC3O001700010026320002001C2O01004A0004EC3O001C2O01002E1C004C00E20001004B0004EC3O00E200012O00FE000300014O0004000400023O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O0003000300184O00030002000200062O000300E200013O0004EC3O00E200012O00FE000300073O00200E01030003004F4O000500013O00202O0005000500504O00030005000200262O000300E2000100510004EC3O00E200012O00FE00035O002650000300E40001000F0004EC3O00E40001002E1C005200F4000100530004EC3O00F40001002E8B005400ED000100550004EC3O00ED00012O00FE000300034O004C000400013O00202O0004000400564O000500086O00030005000200062O000300EF000100010004EC3O00EF0001002E1C005800F4000100570004EC3O00F400012O00FE000300023O001228010400593O0012280105005A4O0037000300054O007300035O002E1C005B00052O01005C0004EC3O00052O012O00FE000300014O0004000400023O00122O0005005D3O00122O0006005E6O0004000600024O00030003000400202O0003000300184O00030002000200062O000300052O013O0004EC3O00052O012O00FE00036O00FE000400093O0010BF0004004A000400069C000300072O0100040004EC3O00072O01002E8B006000822O01005F0004EC3O00822O012O00FE000300034O0087000400013O00202O0004000400614O0005000A6O000600066O000700053O00202O00070007006200122O000900636O0007000900024O000700076O00030007000200062O000300162O0100010004EC3O00162O01002E1C006400822O0100650004EC3O00822O012O00FE000300023O00128C000400663O00122O000500676O000300056O00035O00044O00822O0100262D000200222O0100040004EC3O00222O01002E94006400222O0100680004EC3O00222O01002E8B006900120001006A0004EC3O00120001001228010300014O00E3000400043O002E1C006C00242O01006B0004EC3O00242O01002632000300242O0100010004EC3O00242O01001228010400013O00262D0004002D2O0100010004EC3O002D2O01002E43006D00490001006E0004EC3O00742O01001228010500013O002E8B006F00342O0100700004EC3O00342O01000E28000400342O0100050004EC3O00342O01001228010400043O0004EC3O00742O01002E8B0072002E2O0100710004EC3O002E2O01000E280001002E2O0100050004EC3O002E2O012O00FE000600014O0004000700023O00122O000800733O00122O000900746O0007000900024O00060006000700202O0006000600754O00060002000200062O000600452O013O0004EC3O00452O012O00FE00065O002650000600472O01000F0004EC3O00472O01002E1C007600572O0100770004EC3O00572O01002E1C007900502O0100780004EC3O00502O012O00FE000600034O004C000700013O00202O00070007007A4O0008000B6O00060008000200062O000600522O0100010004EC3O00522O01002E8B007C00572O01007B0004EC3O00572O012O00FE000600023O0012280107007D3O0012280108007E4O0037000600084O007300065O002E43007F001B0001007F0004EC3O00722O012O00FE000600014O0004000700023O00122O000800803O00122O000900816O0007000900024O00060006000700202O0006000600754O00060002000200062O000600722O013O0004EC3O00722O012O00FE00065O002606010600722O0100820004EC3O00722O012O00FE000600034O009D000700013O00202O0007000700834O0008000C6O00060008000200062O000600722O013O0004EC3O00722O012O00FE000600023O001228010700843O001228010800854O0037000600084O007300065O001228010500043O0004EC3O002E2O01000E82000400782O0100040004EC3O00782O01002E8B008600292O0100870004EC3O00292O010012280102004A3O0004EC3O001200010004EC3O00292O010004EC3O001200010004EC3O00242O010004EC3O001200010004EC3O00822O010004EC3O000B00010004EC3O00822O010004EC3O000200012O0014012O00017O0051022O00028O00025O0046B040025O0049B040025O001AAD40025O00805540030C3O004570696353652O74696E677303073O00607B013442516B03073O0018341466532E342O033O00CB202203053O006FA44F4144026O00F03F027O0040025O00988A40025O0056A740025O00D6B240025O00206340025O001DB340025O00E06040026O000840025O0018A840025O001CA94003113O00476574456E656D696573496E52616E6765026O004440025O00C4AA40025O00AEA440025O00609C40025O00EAA140025O00A09840025O0017B140025O000EA640025O001AA940025O005EB240025O00AAA040025O00D0A640025O0040A440025O000EAA40025O0002A94003173O00476574456E656D696573496E53706C61736852616E6765026O002040031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O00589140025O0006A640025O0026AA40025O00D09640025O00809C40025O0036A640025O00ECA740025O00608640025O00EEB040025O0053B240025O0013B140025O00488F40025O00B4A740025O00208340025O00E8B240025O004AB040030E3O005570646174655065745461626C65025O00089540025O0098A740025O007EA540025O00888E40025O00049D4003073O00F2D684D922EFD503063O008AA6B9E3BE4E2O033O00CA7BC003073O0079AB14A557324303073O00F237BE31B507D503063O0062A658D956D92O033O00F5F26A03063O00BC2O961961E6025O00E0AD40025O00A6AC40025O00208B40025O00088C40025O00D0A740025O00ECAD4003103O00557064617465536F756C536861726473030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O008AA040025O00689040025O002C9140025O00489C40025O001CB340025O00F8AC40025O00B2A240025O0048834003103O00426F2O73466967687452656D61696E73025O006C9140025O006DB240025O00209540025O00DCA240025O0068A540025O000BB040030B3O00536F756C536861726473502O033O00474344026O00D03F025O00C07140025O00E08540025O00C09840025O00D6A140025O0032A040025O003AA640025O00207840025O00206140024O0080B3C540030C3O00466967687452656D61696E73030A3O00436F6D62617454696D65025O00D88C40025O009CA640025O00BAA940026O001040025O00EC9340025O00708D4003093O00E99C520F03E3EA8C4B03063O008DBAE93F626C030A3O0049734361737461626C6503093O0049734D6F756E746564030B3O004973496E56656869636C6503083O004973416374697665025O004DB040025O00707640030D3O00D7EF20922AFCE322B731F8E52203053O0045918A4CD6025O00989240025O000CB040025O00E89A40030D3O0046656C446F6D696E6174696F6E03123O0076CA85B6BB197DC68788AB1F7FC1C986B01503063O007610AF2OE9DF025O00C8A240025O0056A34003093O0053752O6D6F6E506574030E3O00989138B6E185429B8121FBE1847E03073O001DEBE455DB8EEB025O0034AF40025O00D8AD40026O001440030F3O008C23308EBFFAD5B63A3885B9F1EDBB03073O0083DF565DE3D09403073O004973526561647903133O00D0502OBB12BBC740BBB913BCE071AFA41CBBF703063O00D583252OD67D030F3O00432O6F6C646F776E52656D61696E73030F3O0053752O6D6F6E56696C656669656E64025O0068A040025O00D8834003183O00353E28B2EE281433B6ED232D2CBAEF226B28BEE8286B71EF03053O0081464B45DF025O002EA740025O00806840025O00409740025O00A4994003043O0062C4FCE403063O008F26AB93891C025O00107B40025O0076A14003093O00436173744379636C6503043O00442O6F6D030E3O0049735370652O6C496E52616E6765030C3O00D48DB6FE43EED5D98CF9A75103073O00B4B0E2D9936383030A3O00E0B12E03DCAE0D08DFAD03043O0067B3D94F025O0051B240025O00CEA740030A3O00536861646F77426F6C74025O00B89C40025O004EA340025O00607A40025O00B0794003133O0059BF1DD14E9B9C48B810C10181A243B95C811503073O00C32AD77CB521EC025O0018A340025O00E2A940025O00CAAC40025O00206740025O0058A340025O002OA640025O00108740025O009C9E40030A3O00DB42F4595F75E85EF35003063O001A9C379D3533030B3O0042752O6652656D61696E7303103O004E6574686572506F7274616C42752O66030F3O00A8DD1BD6B6598FEB02CBBD5E8BCC1E03063O0030ECB876B9D8030C3O00432O6F6C646F776E446F776E030F3O00C1B85A3FC13DE68E4322CA3AE2A95F03063O005485DD3750AF030B3O004973417661696C61626C65025O00809440030A3O004775692O6C6F74696E6503093O004973496E52616E6765025O002O9440025O002AA84003123O00BAF22DAACB53A9EE2AA38751BCEE2AE6960A03063O003CDD8744C6A703113O00CDBCF48F66CBEBBCFC9056D8E2B6FD915103063O00B98EDD98E32203133O006BD05AF74C3DD35DC858F44A30C341D756F45703073O009738A5379A2353026O00394003063O0042752O665570025O0066A440025O0053B14003113O0043612O6C44726561647374616C6B657273025O005EAB40025O0098AA40031A3O00A34209E29F4717EBA14716FAA14F0EEBB25045E3A14A0BAEF11B03043O008EC02365025O00405D40025O003DB340025O00D8A140025O00A4B040030F3O00CC28A4407CB5C28BFC3FAC4175A8C903083O00D8884DC92F12DCA1025O00804F4003133O001EF926D707D2A628E124D401DFB634FE2AD41C03073O00E24D8C4BBA68BC025O0040514003133O008ADBDD3240B7EAD53240B7C7D30B56ABCFDE2B03053O002FD9AEB05F026O003E4003123O00526974656F6652757661722O616442752O6603133O008BC87B0FBD5A5C23B5D2780BB1606134B9D36203083O0046D8BD1662D2341803103O00FDCDAA8ADCD3CDA6A12OD6D8B686C1DE03053O00B3BABFC3E703073O0048617354696572025O00F08340025O00E09040025O00C05A40025O0029B340030F3O0044656D6F6E6963537472656E67746803183O00FD3A15EBF7361BDBEA2B0AE1F7380CECB93219EDF77F4AB003043O0084995F78030C3O0099B30029F8DC87A4BE0A2CF903073O00C0D1D26E4D97BA03113O00C3022EE5DBD6E50226FAEBC5EC0827FBEC03063O00A4806342899F03133O00339CE4B30F87CDBB0D86E7B703BDF0AC0187FD03043O00DE60E989026O003140030A3O008ABCB213BBE7E2B0B8A203073O0090D9D3C77FE893030A3O00CB202B24E651104DF32A03083O0024984F5E48B5256203133O00F0CA4631D3EF462DDBD74434C4FC422CDEDF4903043O005FB7B827025O0010A340025O002DB040030C3O0048616E646F6647756C64616E025O00608F40025O0086AF4003163O00BD3EE9226B8F048A38F22A50810CF532E62F5AC050E303073O0062D55F874634E0025O0018B140025O001EA740025O00E4A540025O0010774003093O00FF7839AFE89FA519D803083O0076B61549C387ECCC03083O00507265764743445003093O00496D706C6F73696F6E025O00109A4003113O0001310A4C0B1EF407325A4D0504F3486E4A03073O009D685C7A20646D03103O0090B3C2C73229BEA4B6AAC4CF383788B903083O00CBC3C6AFAA5D47ED03103O001D5E33D85E1FCF215E32DE5414EC2B5903073O009C4E2B5EB5317103053O00436F756E74026O00244003103O0053752O6D6F6E536F756C6B2O65706572025O003CAA40025O0028B34003133O0061E7D1AF34506D60E1CFA64B4E787BE684F15903073O00191288A4C36B23025O008AA640025O0078A640025O00649740025O0002A44003093O00497343617374696E67030C3O0049734368612O6E656C696E67025O00808940025O00C09A40025O00BAA340025O001AA740025O005AA540025O0036A740025O004EA440025O00A4AF40025O001EAF40025O00488440025O00F09D40025O0097B040025O0016AD4003093O00496E74652O7275707403093O005370652O6C4C6F636B03123O005370652O6C4C6F636B4D6F7573656F766572025O00C89F40025O00C0A740025O00B0B140025O00989640025O0072A740025O0058A040025O000AA040025O0068AA40025O00E06840025O00589740025O00D4B140025O0090A040025O00BFB24003073O00417865546F2O73025O00BAB140025O00507840025O00A0B040025O00507D40025O00E07040025O00D8984003113O00496E74652O72757074576974685374756E03103O00417865546F2O734D6F7573656F766572025O00649940025O00C49340025O00804940025O00C08C40025O001EAD40025O00C05540025O00088340025O0062AE40025O0030A740025O00389F40025O0088A440025O00FEA040025O006EA740030F3O0008DABFD3734729550FD1A9D27B582203083O00325DB4DABD172E4703103O004865616C746850657263656E74616765025O001AA840025O006CA540030F3O00556E656E64696E675265736F6C7665025O00807740025O0046A040031A3O00CBAA5E4240D546D99B2O4957D344C8A11B4841DA4DD0B7525A4103073O0028BEC43B2C24BC031A3O00492O6D6F7661626C6543612O6C44726561647374616C6B65727303083O0042752O66446F776E03123O0044656D6F6E696343612O6C696E6742752O6603093O0044656D6F6E626F6C74025O00C05140025O005FB040025O00409340025O00CAAA40025O0010AB40026O003640025O00849740025O0009B340025O0042A240025O00707A40025O0050AE40025O00B6B140025O00A7B240025O00588640025O0068AC40025O006C9C40025O0080A240025O00DAA34003133O0046A45647D97B955E47D97BB8587ECF67B0555E03053O00B615D13B2A026O002E40030F3O008442C8102EB0815EC91827B7B259C103063O00DED737A57D4103113O000FD0CA16D6D3E84B28C2D21BFECAE8583F03083O002A4CB1A67A92A18D03103O0082980CC3767FB78F23CB7571B08B17CA03063O0016C5EA65AE19030F3O00506F776572496E667573696F6E5570030F3O001E21A8D179A1E18F2131A3D573A1D303083O00E64D54C5BC16CFB703133O00CA01CBF183AFD430F41BC8F58F95E927F81AD203083O00559974A69CECC190030F3O0097F540BEEB0E92E941B6E209A1EE4903063O0060C4802DD38403113O00168C7753F6BDB1D9319E6F5EDEA4B1CA2603083O00B855ED1B3FB2CFD403103O002F4B005207501B5A2E5C05581D581B5B03043O003F683969025O00349140025O000C9540025O007DB240025O0007B040025O003EAD40025O0038A240025O00DC9240025O00B1B040025O0028A940025O007CB240025O00549F40025O00C2A340025O00D08E40025O000AAC4003133O003892A949048980410688AA4D08B3BD560A89B003043O00246BE7C4030F3O006EA0AF8A52BB948E51B0A48E58BBA603043O00E73DD5C203103O002EBF347E06A42F762FA831741CAC2F7703043O001369CD5D030A3O00432O6F6C646F776E5570025O0082B140025O0062B340025O0016AB40025O00FCA240025O005EA840025O00E07A40025O00708040025O00F07F40025O00D2A240025O0026A940030C3O001444D2B0F57B2A2949D8B5F403073O006D5C25BCD49A1D026O00E03F025O00C05740030E3O0036EAADC43F5502DBBDD130540AF603063O003A648FC4A351025O00108C40025O00BCA540025O00A4A040025O00309D4003153O0012432DA70046E3311D572FA73E47A5031B4B2DE36D03083O006E7A2243C35F2985025O0036AE40025O0094A140025O00909B40025O0024A840025O0028AC40025O00A88540025O0054AA40025O0039B040025O0024B040025O00607B40025O00C05640025O0078A540025O005C9B40025O000C964003133O009A1DD38C30A72CDB8C30A701DDB526BB09D09503053O005FC968BEE103103O0088D9C8C3A0C2D3CB89CECDC9BACAD3CA03043O00AECFABA1025O00805640025O003C9C40025O00F49A4003133O0053752O6D6F6E44656D6F6E6963547972616E74031C3O00FEEB00FEF7D9D2FA08FEF7D9E4FD32E7E1C5ECF019B3F5D6E4F04DA703063O00B78D9E6D9398025O0056B040030F3O001F1CEB012307D005200CE0052907E203043O006C4C698603133O00D8D0BCECC1E5E1B4ECC1E5CCB2D5D7F9C4BFF503053O00AE8BA5D181025O00804640025O00C88340025O0054A440025O00907740025O0031B24003173O00B0A6EFCCC90D4F6EAABFE7C7CF067E7CE3BEE32OC8432603083O0018C3D382A1A6631003093O006206E4235D14490FFD03063O00762663894C33030F3O0044656D6F6E6963436F726542752O66030A3O00CE29101E3A34EF2F0E1703063O00409D46657269030A3O0073A7B2EF2354BAAEE81503053O007020C8C783026O003F40025O0004B340025O0080904003103O00285551B7CDA92D20441CB5C2A22C6C0803073O00424C303CD8A3CB030B3O008A896EF64DFD2DAA8E76FD03073O0044DAE619933FAE030A3O00446562752O66446F776E030F3O00442O6F6D4272616E64446562752O66030C3O00852B5D48B9AB0D4640B2AC2403053O00D6CD4A332C03083O00496E466C69676874030D3O00446562752O6652656D61696E7303093O00DE49EFF379F843EEE803053O00179A2C829C030A3O0054726176656C54696D65030C3O0039A7A3AA391536B3A1AA371D03063O007371C6CDCE5603093O00A052F3558A55F1569003043O003AE4379E030B3O00506F776572536970686F6E025O003AB240025O00188340025O00709540025O00C8874003143O00A486C72B2E9226BD99D82132ED38B580DE6E6DFD03073O0055D4E9B04E5CCD025O0081B240025O00ADB140025O0080AD40025O00DCA940025O002EAF40030F3O006E5D85ED44518BD15E4A8DEC4D4C8003043O00822A38E803133O00D9A029EE4F31CEB029EC4E36E9813DF14131FE03063O005F8AD544832003133O00193DAC4E79240CA44E792421A2776F3829AF5703053O00164A48C12303133O001F6CE9552377C05D2176EA512F4DFD4A2D77F003043O00384C198403103O0079D3A22BC057D3AE00CA52C6BE27DD5A03053O00AF3EA1CB46025O00A4AB40025O00D2A940025O000FB140025O002EAD4003183O0038D8CE1C3B35DEFC00212ED8CD1421349DCE123C329D924103053O00555CBDA373025O00F4A24003123O000BA53C3D3AAF3F2D3BAB351A26A1323D3BBF03043O005849CC50026O003540025O00CC9E4003123O0042696C6573636F75726765426F6D62657273031B3O002C8A1C433AD9219602412CE52C8C1D442CC83DC31D4720D46ED24403063O00BA4EE3702649025O00D4A640025O00907B40025O00349240025O000C9140030C3O00D6A2C7735BF884DC7B50FFAD03053O00349EC3A91703133O005DAE337A82027A9976B3317F95117E9873BB3C03083O00EB1ADC5214E6551B025O008CAD40025O0050AC40025O00C0914003163O0080A0E7C64B87A7D6C56184A5E8CC3485A0E0CC34DAF903053O0014E8C189A2025O00EC9F4003093O0006DAC8A9E98E187D3603083O001142BFA5C687EC7703093O0042752O66537461636B030A3O003CA0BB1FCCFCFED804AA03083O00B16FCFCE739F888C030A3O0036860518E75B4D0C821503073O003F65E97074B42F03113O00C73EE01DF634CC37F952F537CA35AD41A803063O0056A35B8D729803093O00770E797C345104786703053O005A336B1413025O002CA640025O0060A540025O0086AC40030C3O0043617374546172676574496603023O00D0AD03053O005DED90E58F03113O0011F3FD1605441AFAE45906471CF8B04A5903063O0026759690796B025O00989540025O0028854003093O0009BEE33523B9E1363903043O005A4DDB8E025O00207640025O00F89740025O00388C40025O003EA540025O0068AD40025O000CB34003113O00E2012C36420575EA1061344D0E74A6577503073O001A866441592C6703093O00D5E63D2CAAF3EC3C3703053O00C491835043030B3O002EBF110D0ADB17A00E071603063O00887ED0666878025O00C2A040025O0067B24003113O007C8FC34CA150325D6CCAC342A65C7D022E03083O003118EAAE23CF325D025O00B8AC40025O00F88540030B3O003CFDEA8D633FFBED807E0203053O00116C929DE8025O00C6AD40025O00F07340025O00F0B240025O00DDB04003143O005BCC03E83D9758CA04E520A60BCE15E421E8189B03063O00C82BA3748D4F00320B2O001228012O00014O00E3000100013O00262D3O0006000100010004EC3O00060001002E8B00030002000100020004EC3O000200010012282O0100013O00262D0001000B000100010004EC3O000B0001002E1C0004001A000100050004EC3O001A00012O00FE00026O005C00020001000100122O000200066O000300023O00122O000400073O00122O000500086O0003000500024O0002000200034O000300023O00122O000400093O00122O0005000A4O00C10003000500022O00080002000200032O00F9000200013O0012282O01000B3O00262D000100200001000C0004EC3O00200001002E35000E00200001000D0004EC3O00200001002E8B000F00BB000100100004EC3O00BB0001001228010200013O002E8B00120027000100110004EC3O00270001002632000200270001000B0004EC3O002700010012282O0100133O0004EC3O00BB000100263200020021000100010004EC3O002100012O00FE000300033O0006F80003007F00013O0004EC3O007F0001001228010300014O00E3000400053O00262D000300320001000B0004EC3O00320001002E1C00150076000100140004EC3O00760001000E2800010032000100040004EC3O00320001001228010500013O0026320005003D0001000B0004EC3O003D00012O00FE000600053O00202500060006001600122O000800176O0006000800024O000600043O00044O00B6000100262D00050043000100010004EC3O00430001002E3500180043000100190004EC3O00430001002E1C001B00350001001A0004EC3O00350001001228010600014O00E3000700073O00262D0006004B000100010004EC3O004B0001002E16001C004B0001001D0004EC3O004B0001002E8B001F00450001001E0004EC3O00450001001228010700013O002E1C00210052000100200004EC3O00520001002632000700520001000B0004EC3O005200010012280105000B3O0004EC3O0035000100262D00070056000100010004EC3O00560001002E1C0022004C000100230004EC3O004C0001001228010800013O000E820001005B000100080004EC3O005B0001002E8B00240066000100250004EC3O006600012O00FE000900073O0020A000090009002600122O000B00276O0009000B00024O000900066O000900073O00202O00090009002800122O000B00276O0009000B00024O000900083O00122O0008000B3O00262D0008006C0001000B0004EC3O006C0001002E94002A006C000100290004EC3O006C0001002E1C002B00570001002C0004EC3O005700010012280107000B3O0004EC3O004C00010004EC3O005700010004EC3O004C00010004EC3O003500010004EC3O004500010004EC3O003500010004EC3O00B600010004EC3O003200010004EC3O00B60001002E8B002D002E0001002E0004EC3O002E00010026320003002E000100010004EC3O002E0001001228010400014O00E3000500053O0012280103000B3O0004EC3O002E00010004EC3O00B60001001228010300014O00E3000400053O002E43002F00070001002F0004EC3O0088000100263200030088000100010004EC3O00880001001228010400014O00E3000500053O0012280103000B3O002E8B00300081000100310004EC3O00810001002632000300810001000B0004EC3O0081000100262D00040090000100010004EC3O00900001002E1C0032008C000100330004EC3O008C0001001228010500013O002E1C00340098000100350004EC3O00980001002632000500980001000B0004EC3O009800012O006F00066O00F9000600043O0004EC3O00B60001002E43003600F9FF2O00360004EC3O0091000100263200050091000100010004EC3O00910001001228010600014O00E3000700073O00262D000600A2000100010004EC3O00A20001002E8B0037009E000100380004EC3O009E0001001228010700013O002632000700AA000100010004EC3O00AA00012O006F00086O00F9000800063O0012280108000B4O00F9000800083O0012280107000B3O002632000700A30001000B0004EC3O00A300010012280105000B3O0004EC3O009100010004EC3O00A300010004EC3O009100010004EC3O009E00010004EC3O009100010004EC3O00B600010004EC3O008C00010004EC3O00B600010004EC3O008100012O00FE000300093O0020A60003000300392O00640003000100010012280102000B3O0004EC3O00210001002E43003A00290001003A0004EC3O00E40001002632000100E40001000B0004EC3O00E40001001228010200013O00262D000200C40001000B0004EC3O00C40001002E8B003B00C60001003C0004EC3O00C600010012282O01000C3O0004EC3O00E40001000E82000100CA000100020004EC3O00CA0001002E1C003E00C00001003D0004EC3O00C0000100128E000300064O0096000400023O00122O0005003F3O00122O000600406O0004000600024O0003000300044O000400023O00122O000500413O00122O000600426O0004000600024O0003000300044O000300033O00122O000300066O000400023O00122O000500433O00122O000600446O0004000600024O0003000300044O000400023O00122O000500453O00122O000600466O0004000600024O0003000300044O0003000A3O00122O0002000B3O0004EC3O00C00001002E1C0048006D2O0100470004EC3O006D2O0100262D000100EA000100130004EC3O00EA0001002E1C004A006D2O0100490004EC3O006D2O01001228010200013O00262D000200EF000100010004EC3O00EF0001002E1C004C00662O01004B0004EC3O00662O012O00FE000300093O00209B00030003004D4O0003000100014O0003000B3O00202O00030003004E4O00030001000200062O000300FE000100010004EC3O00FE00012O00FE000300053O00209800030003004F2O004B000300020002000678000300FE000100010004EC3O00FE0001002E1C005000652O0100510004EC3O00652O01001228010300014O00E3000400043O00262D000300042O0100010004EC3O00042O01002E43005200FEFF2O00530004EC4O002O01001228010400013O002632000400282O0100010004EC3O00282O01001228010500013O00262D0005000C2O0100010004EC3O000C2O01002E4300540017000100550004EC3O00212O01001228010600013O002E1C0057001A2O0100560004EC3O001A2O01000E280001001A2O0100060004EC3O001A2O012O00FE0007000D3O0020320107000700584O000800086O000900016O0007000900024O0007000C6O0007000C6O0007000E3O00122O0006000B3O000E82000B001E2O0100060004EC3O001E2O01002E43005900F1FF2O005A0004EC3O000D2O010012280105000B3O0004EC3O00212O010004EC3O000D2O0100262D000500252O01000B0004EC3O00252O01002E1C005C00082O01005B0004EC3O00082O010012280104000B3O0004EC3O00282O010004EC3O00082O01002E1C005D003F2O01005E0004EC3O003F2O010026320004003F2O01000C0004EC3O003F2O012O00FE000500053O00209F00050005005F4O0005000200024O0005000F6O000500116O000600053O00202O0006000600604O00060002000200122O000700616O0005000700024O000600126O000700053O00202O0007000700604O00070002000200122O000800616O0006000800024O0005000500064O000500103O00044O00652O01002E1C006200432O0100630004EC3O00432O0100262D000400452O01000B0004EC3O00452O01002E43006400C2FF2O00650004EC3O00052O01001228010500013O002E1C0066005B2O0100670004EC3O005B2O01000E280001005B2O0100050004EC3O005B2O01002E8B006900502O0100680004EC3O00502O012O00FE0006000E3O00262D000600502O01006A0004EC3O00502O010004EC3O00562O012O00FE0006000D3O0020EA00060006006B4O000700066O00088O0006000800024O0006000E4O00FE0006000D3O0020A600060006006C2O00DA0006000100022O00F9000600133O0012280105000B3O002E43006D00EBFF2O006D0004EC3O00462O01002632000500462O01000B0004EC3O00462O010012280104000C3O0004EC3O00052O010004EC3O00462O010004EC3O00052O010004EC3O00652O010004EC4O002O010012280102000B3O002E8B006E00EB0001006F0004EC3O00EB0001000E28000B00EB000100020004EC3O00EB00010012282O0100703O0004EC3O006D2O010004EC3O00EB0001002E1C00720007000100710004EC3O0007000100263200010007000100700004EC3O000700012O00FE000200144O0004000300023O00122O000400733O00122O000500746O0003000500024O00020002000300202O0002000200754O00020002000200062O0002008D2O013O0004EC3O008D2O012O00FE000200053O0020980002000200762O004B0002000200020006780002008D2O0100010004EC3O008D2O012O00FE000200053O0020980002000200772O004B0002000200020006780002008D2O0100010004EC3O008D2O012O00FE000200153O0006F80002008D2O013O0004EC3O008D2O012O00FE000200163O0020980002000200782O004B0002000200020006F80002008F2O013O0004EC3O008F2O01002E43007900310001007A0004EC3O00BE2O01001228010200013O000E28000100902O0100020004EC3O00902O012O00FE000300144O0004000400023O00122O0005007B3O00122O0006007C6O0004000600024O00030003000400202O0003000300754O00030002000200062O000300AD2O013O0004EC3O00AD2O01002E1C007D00AD2O01007E0004EC3O00AD2O01002E43007F000F0001007F0004EC3O00AD2O012O00FE000300174O002C010400143O00202O0004000400804O000500066O000700016O00030007000200062O000300AD2O013O0004EC3O00AD2O012O00FE000300023O001228010400813O001228010500824O0037000300054O007300035O002E8B008300BE2O0100840004EC3O00BE2O012O00FE000300174O003A000400143O00202O0004000400854O00058O000600016O00030006000200062O000300BE2O013O0004EC3O00BE2O012O00FE000300023O00128C000400863O00122O000500876O000300056O00035O00044O00BE2O010004EC3O00902O012O00FE0002000B3O0020A600020002004E2O00DA000200010002000678000200C52O0100010004EC3O00C52O01002E8B008800310B0100890004EC3O00310B01001228010200014O00E3000300033O002632000200410201008A0004EC3O004102012O00FE000400144O0004000500023O00122O0006008B3O00122O0007008C6O0005000700024O00040004000500202O00040004008D4O00040002000200062O000400FA2O013O0004EC3O00FA2O012O00FE0004000E4O003C000500116O000600146O000700023O00122O0008008E3O00122O0009008F6O0007000900024O00060006000700202O0006000600904O00060002000200122O0007008A6O0005000700024O000600126O000700146O000800023O00122O0009008E3O00122O000A008F6O0008000A00024O00070007000800202O0007000700904O00070002000200122O0008008A6O0006000800024O00050005000600062O000400FA2O0100050004EC3O00FA2O012O00FE000400184O00FE000500143O0020A60005000500912O004B000400020002000678000400F52O0100010004EC3O00F52O01002E8B009200FA2O0100930004EC3O00FA2O012O00FE000400023O001228010500943O001228010600954O0037000400064O007300045O002E1C0097001E020100960004EC3O001E0201002E1C0098001E020100990004EC3O001E02012O00FE000400144O0004000500023O00122O0006009A3O00122O0007009B6O0005000700024O00040004000500202O00040004008D4O00040002000200062O0004001E02013O0004EC3O001E0201002E8B009C001E0201009D0004EC3O001E02012O00FE0004000B3O00201200040004009E4O000500143O00202O00050005009F4O000600046O000700196O000800073O00202O0008000800A04O000A00143O00202O000A000A009F4O0008000A00024O000800086O00040008000200062O0004001E02013O0004EC3O001E02012O00FE000400023O001228010500A13O001228010600A24O0037000400064O007300046O00FE000400144O00BC000500023O00122O000600A33O00122O000700A46O0005000700024O00040004000500202O0004000400754O00040002000200062O0004002A020100010004EC3O002A0201002E1C00A500310B0100A60004EC3O00310B012O00FE000400184O00AA000500143O00202O0005000500A74O000600076O000800073O00202O0008000800A04O000A00143O00202O000A000A00A74O0008000A00024O000800086O00040008000200062O0004003B020100010004EC3O003B0201002E3500A9003B020100A80004EC3O003B0201002E8B00AA00310B0100AB0004EC3O00310B012O00FE000400023O00128C000500AC3O00122O000600AD6O000400066O00045O00044O00310B01002E1C00AE00FC030100AF0004EC3O00FC0301002632000200FC030100130004EC3O00FC0301001228010400013O00262D0004004C020100130004EC3O004C0201002E9400B0004C020100B10004EC3O004C0201002E1C00B3004E020100B20004EC3O004E0201001228010200703O0004EC3O00FC0301002632000400C2020100010004EC3O00C20201002E8B00B4008D020100B50004EC3O008D02012O00FE000500144O0004000600023O00122O000700B63O00122O000800B76O0006000800024O00050005000600202O0005000500754O00050002000200062O0005008D02013O0004EC3O008D02012O00FE000500053O0020B60005000500B84O000700143O00202O0007000700B94O0005000700024O000600103O00062O0005008D020100060004EC3O008D02012O00FE000500144O00BC000600023O00122O000700BA3O00122O000800BB6O0006000800024O00050005000600202O0005000500BC4O00050002000200062O00050078020100010004EC3O007802012O00FE000500144O00BC000600023O00122O000700BD3O00122O000800BE6O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005008D020100010004EC3O008D0201002E4300C00015000100C00004EC3O008D02012O00FE000500184O00D4000600143O00202O0006000600C14O000700086O000900073O00202O0009000900C200122O000B00176O0009000B00024O000900096O00050009000200062O00050088020100010004EC3O00880201002E4300C30007000100C40004EC3O008D02012O00FE000500023O001228010600C53O001228010700C64O0037000500074O007300056O00FE000500144O0004000600023O00122O000700C73O00122O000800C86O0006000800024O00050005000600202O00050005008D4O00050002000200062O000500AB02013O0004EC3O00AB02012O00FE000500144O0057000600023O00122O000700C93O00122O000800CA6O0006000800024O00050005000600202O0005000500904O000500020002000E2O00CB00AD020100050004EC3O00AD02012O00FE0005001A3O000E3400CB00AD020100050004EC3O00AD02012O00FE000500053O0020700005000500CC4O000700143O00202O0007000700B94O00050007000200062O000500AD020100010004EC3O00AD0201002E8B00CE00C1020100CD0004EC3O00C102012O00FE000500184O00AA000600143O00202O0006000600CF4O000700086O000900073O00202O0009000900A04O000B00143O00202O000B000B00CF4O0009000B00024O000900096O00050009000200062O000500BC020100010004EC3O00BC0201002E4300D00007000100D10004EC3O00C102012O00FE000500023O001228010600D23O001228010700D34O0037000500074O007300055O0012280104000B3O00262D000400C60201000C0004EC3O00C60201002E1C00D50091030100D40004EC3O00910301002E1C00D6002E030100D70004EC3O002E03012O00FE000500144O0004000600023O00122O000700D83O00122O000800D96O0006000800024O00050005000600202O0005000500754O00050002000200062O0005002E03013O0004EC3O002E03012O00FE0005000E3O000ED800DA00EF020100050004EC3O00EF02012O00FE0005000E4O003C000600116O000700146O000800023O00122O000900DB3O00122O000A00DC6O0008000A00024O00070007000800202O0007000700904O00070002000200122O000800DD6O0006000800024O000700126O000800146O000900023O00122O000A00DB3O00122O000B00DC6O0009000B00024O00080008000900202O0008000800904O00080002000200122O000900DD6O0007000900024O00060006000700062O0006001E030100050004EC3O001E03012O00FE000500144O0057000600023O00122O000700DE3O00122O000800DF6O0006000800024O00050005000600202O0005000500904O000500020002000E2O00E0001E030100050004EC3O001E03012O00FE000500053O0020700005000500CC4O000700143O00202O0007000700E14O00050007000200062O0005001E030100010004EC3O001E03012O00FE0005001B3O0006780005001E030100010004EC3O001E03012O00FE000500144O0004000600023O00122O000700E23O00122O000800E36O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005001E03013O0004EC3O001E03012O00FE000500144O0004000600023O00122O000700E43O00122O000800E56O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005001E03013O0004EC3O001E03012O00FE000500053O0020C20005000500E600122O000700E03O00122O0008000C6O00050008000200062O0005002E030100010004EC3O002E0301002E8B00E7002E030100E80004EC3O002E0301002E8B00E9002E030100EA0004EC3O002E03012O00FE000500184O009D000600143O00202O0006000600EB4O0007001C6O00050007000200062O0005002E03013O0004EC3O002E03012O00FE000500023O001228010600EC3O001228010700ED4O0037000500074O007300056O00FE000500144O0004000600023O00122O000700EE3O00122O000800EF6O0006000800024O00050005000600202O00050005008D4O00050002000200062O0005007A03013O0004EC3O007A03012O00FE0005000F3O000ED8000C0051030100050004EC3O005103012O00FE000500144O0086000600023O00122O000700F03O00122O000800F16O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00202O00060006007000062O00060051030100050004EC3O005103012O00FE000500144O0057000600023O00122O000700F23O00122O000800F36O0006000800024O00050005000600202O0005000500904O000500020002000E2O00F4006D030100050004EC3O006D03012O00FE0005000F3O00262D0005006D0301008A0004EC3O006D03012O00FE0005000F3O0026320005007A030100700004EC3O007A03012O00FE000500144O0004000600023O00122O000700F53O00122O000800F66O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005007A03013O0004EC3O007A03012O00FE000500144O0086000600023O00122O000700F73O00122O000800F86O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00202O00060006000C00062O0005007A030100060004EC3O007A03012O00FE000500083O0026320005007A0301000B0004EC3O007A03012O00FE000500144O00BC000600023O00122O000700F93O00122O000800FA6O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005007C030100010004EC3O007C0301002E4300FB0016000100FC0004EC3O009003012O00FE000500184O00AA000600143O00202O0006000600FD4O000700086O000900073O00202O0009000900A04O000B00143O00202O000B000B00FD4O0009000B00024O000900096O00050009000200062O0005008B030100010004EC3O008B0301002E1C00FF0090030100FE0004EC3O009003012O00FE000500023O00122801062O00012O0012280107002O013O0037000500074O007300055O001228010400133O00122801050002012O00122801060003012O00063F00060046020100050004EC3O004602010012280105000B3O0006750004009C030100050004EC3O009C030100122801050004012O00122801060005012O00063F00050046020100060004EC3O004602012O00FE000500144O0004000600023O00122O00070006012O00122O00080007015O0006000800024O00050005000600202O00050005008D4O00050002000200062O000500D003013O0004EC3O00D003012O00FE0005001D3O0012280106000C4O004B000500020002001228010600013O00063F000600D0030100050004EC3O00D003012O00FE0005001E3O0006F8000500D003013O0004EC3O00D003012O00FE000500053O0012F100070008015O00050005000700122O0007000B6O000800143O00122O00090009015O0008000800094O00050008000200062O000500D0030100010004EC3O00D003010012280105000A012O0012280106000A012O00061E010500D0030100060004EC3O00D003012O00FE000500184O00C7000600143O00122O00070009015O0006000600074O0007001F6O000800086O000900073O00202O0009000900C200122O000B00176O0009000B00024O000900094O00C10005000900020006F8000500D003013O0004EC3O00D003012O00FE000500023O0012280106000B012O0012280107000C013O0037000500074O007300056O00FE000500144O0004000600023O00122O0007000D012O00122O0008000E015O0006000800024O00050005000600202O00050005008D4O00050002000200062O000500FA03013O0004EC3O00FA03012O00FE000500144O0071000600023O00122O0007000F012O00122O00080010015O0006000800024O00050005000600122O00070011015O0005000500074O00050002000200122O00060012012O00062O000500FA030100060004EC3O00FA03012O00FE000500083O0012280106000B3O00063F000600FA030100050004EC3O00FA03012O00FE000500184O0003010600143O00122O00070013015O0006000600074O00050002000200062O000500F5030100010004EC3O00F5030100122801050014012O00122801060015012O000621010600FA030100050004EC3O00FA03012O00FE000500023O00122801060016012O00122801070017013O0037000500074O007300055O0012280104000C3O0004EC3O00460201001228010400013O00061E010200BF050100040004EC3O00BF0501001228010400013O00122801050018012O00122801060019012O00063F00060052050100050004EC3O005205010012280105001A012O0012280106001B012O00062101050052050100060004EC3O005205010012280105000B3O00061E01040052050100050004EC3O005205012O00FE000500053O0012280107001C013O002A0105000500072O004B00050002000200067800050017040100010004EC3O001704012O00FE000500053O0012280107001D013O002A0105000500072O004B0005000200020006F80005001F04013O0004EC3O001F04010012280105001E012O0012280106001F012O00069C0006001F040100050004EC3O001F040100122801050020012O00122801060021012O00061E01050026050100060004EC3O00260501001228010500014O00E3000600083O001228010900013O00067500050028040100090004EC3O0028040100122801090022012O001228010A0023012O00061E0109002B0401000A0004EC3O002B0401001228010600014O00E3000700073O0012280105000B3O00122801090024012O001228010A0025012O00063F000900210401000A0004EC3O002104010012280109000B3O00061E01050021040100090004EC3O002104012O00E3000800083O00122801090026012O001228010A0027012O00063F000A003D040100090004EC3O003D0401001228010900013O00061E0106003D040100090004EC3O003D0401001228010700014O00E3000800083O0012280106000B3O00122801090028012O001228010A0028012O00061E010900330401000A0004EC3O003304010012280109000B3O00061E01060033040100090004EC3O0033040100122801090029012O001228010A002A012O000621010A0079040100090004EC3O00790401001228010900013O00061E01090079040100070004EC3O00790401001228010900013O001228010A000B3O00061E0109005F0401000A0004EC3O005F04012O00FE000A000B3O001295000B002B015O000A000A000B4O000B00143O00122O000C002C015O000B000B000C00122O000C00176O000D00016O000E00206O000F00213O00122O0010002D015O000F000F00104O000A000F00024O0008000A3O00122O0007000B3O00044O00790401001228010A002E012O001228010B002E012O00061E010A004C0401000B0004EC3O004C0401001228010A00013O00061E0109004C0401000A0004EC3O004C04012O00FE000A000B3O00121C010B002B015O000A000A000B4O000B00143O00122O000C002C015O000B000B000C00122O000C00176O000D00016O000A000D00024O0008000A3O00122O000A002F012O00122O000B0030012O00062O000A00770401000B0004EC3O007704010006F80008007704013O0004EC3O007704012O0047000800023O0012280109000B3O0004EC3O004C04010012280109000B3O00061E010700BC040100090004EC3O00BC0401001228010900014O00E3000A000A3O001228010B0031012O001228010C0032012O00063F000B007E0401000C0004EC3O007E0401001228010B00013O000675000900890401000B0004EC3O00890401001228010B0033012O001228010C0034012O000621010B007E0401000C0004EC3O007E0401001228010A00013O001228010B000B3O000675000A00910401000B0004EC3O00910401001228010B0035012O001228010C0036012O00063F000B00960401000C0004EC3O009604010006F80008009404013O0004EC3O009404012O0047000800023O0012280107000C3O0004EC3O00BC0401001228010B0037012O001228010C0038012O000621010B008A0401000C0004EC3O008A0401001228010B0039012O001228010C003A012O00063F000B008A0401000C0004EC3O008A0401001228010B00013O00061E010A008A0401000B0004EC3O008A0401001228010B00013O001228010C000B3O00061E010B00A70401000C0004EC3O00A70401001228010A000B3O0004EC3O008A0401001228010C00013O00061E010B00A20401000C0004EC3O00A204010006F8000800AD04013O0004EC3O00AD04012O0047000800024O00FE000C000B3O001260000D002B015O000C000C000D4O000D00143O00122O000E003B015O000D000D000E00122O000E00176O000F00016O000C000F00024O0008000C3O00122O000B000B3O0004EC3O00A204010004EC3O008A04010004EC3O00BC04010004EC3O007E0401001228010900133O000675000700C3040100090004EC3O00C304010012280109003C012O001228010A003D012O000621010900E40401000A0004EC3O00E404010012280109003E012O001228010A003F012O00063F000A00CE040100090004EC3O00CE040100122801090040012O001228010A0041012O000621010900CE0401000A0004EC3O00CE04010006F8000800CE04013O0004EC3O00CE04012O0047000800024O00FE0009000B3O001263000A0042015O00090009000A4O000A00143O00122O000B003B015O000A000A000B00122O000B00176O000C00016O000D00206O000E00213O00122O000F0043015O000E000E000F4O0009000E00024O000800093O00122O00090044012O00122O000A0045012O00062O000A0026050100090004EC3O002605010006F80008002605013O0004EC3O002605012O0047000800023O0004EC3O002605010012280109000C3O00061E01090044040100070004EC3O00440401001228010900013O001228010A000B3O000675000900F30401000A0004EC3O00F30401001228010A0046012O001228010B0047012O0006AD000B00050001000A0004EC3O00F30401001228010A0048012O001228010B0049012O00063F000A00FF0401000B0004EC3O00FF04012O00FE000A000B3O001260000B0042015O000A000A000B4O000B00143O00122O000C003B015O000B000B000C00122O000C00176O000D00016O000A000D00024O0008000A3O00122O000700133O0004EC3O00440401001228010A004A012O001228010B004B012O000621010A00E80401000B0004EC3O00E80401001228010A00013O000675000A000A050100090004EC3O000A0501001228010A004C012O001228010B004D012O000621010A00E80401000B0004EC3O00E804012O00FE000A000B3O001231010B002B015O000A000A000B4O000B00143O00122O000C003B015O000B000B000C00122O000C00176O000D00016O000E00206O000F00213O00122O00100043013O0008000F000F00102O00C1000A000F00022O007D0008000A3O0006780008001E050100010004EC3O001E0501001228010A004E012O001228010B004F012O00063F000A001F0501000B0004EC3O001F05012O0047000800023O0012280109000B3O0004EC3O00E804010004EC3O004404010004EC3O002605010004EC3O003304010004EC3O002605010004EC3O0021040100122801050050012O00122801060050012O00061E01050051050100060004EC3O005105012O00FE000500144O0004000600023O00122O00070051012O00122O00080052015O0006000800024O00050005000600202O00050005008D4O00050002000200062O0005003B05013O0004EC3O003B05012O00FE000500053O00122700070053015O0005000500074O0005000200024O000600223O00062O0005003F050100060004EC3O003F050100122801050054012O00122801060055012O00062101050051050100060004EC3O005105012O00FE000500174O001E000600143O00122O00070056015O0006000600074O000700086O000900016O00050009000200062O0005004C050100010004EC3O004C050100122801050057012O00122801060058012O00062101060051050100050004EC3O005105012O00FE000500023O00122801060059012O0012280107005A013O0037000500074O007300055O0012280104000C3O001228010500013O00061E01040080050100050004EC3O008005012O00FE000500053O0012200007005C015O0005000500074O000700143O00122O0008005D015O0007000700084O00050007000200122O0005005B015O000500053O00202O00050005004F4O00050002000200062O0005006E050100010004EC3O006E05012O00FE000500013O0006F80005006E05013O0004EC3O006E05012O00FE000500053O0012890007001C015O0005000500074O000700143O00122O0008005E015O0007000700084O00050007000200062O0005007205013O0004EC3O007205010012280105004C012O0012280106005F012O00061E0105007F050100060004EC3O007F0501001228010500014O00E3000600063O001228010700013O00061E01050074050100070004EC3O007405012O00FE000700234O00DA0007000100022O007D000600073O0006F80006007F05013O0004EC3O007F05012O0047000600023O0004EC3O007F05010004EC3O007405010012280104000B3O00122801050060012O00122801060061012O00063F00060089050100050004EC3O00890501001228010500133O00061E01040089050100050004EC3O008905010012280102000B3O0004EC3O00BF05010012280105000C3O00061E01042O00040100050004EC4O0004012O00FE000500244O006400050001000100122801050062012O00122801060063012O00063F000500BD050100060004EC3O00BD05012O00FE000500254O00DA0005000100020006780005009E050100010004EC3O009E05012O00FE0005000E3O00122801060064012O00069C0005009E050100060004EC3O009E050100122801050065012O00122801060066012O00063F000600BD050100050004EC3O00BD0501001228010500014O00E3000600063O001228010700013O000675000500A7050100070004EC3O00A7050100122801070067012O00122801080068012O000621010700A0050100080004EC3O00A005012O00FE000700264O00910007000100024O000600073O00122O00070069012O00122O0008006A012O00062O000700B6050100080004EC3O00B605010006F8000600B605013O0004EC3O00B605012O00FE000700273O0006F8000700B605013O0004EC3O00B605012O00FE0007000A3O000678000700BA050100010004EC3O00BA05010012280107006B012O0012280108006C012O00061E010700BD050100080004EC3O00BD05012O0047000600023O0004EC3O00BD05010004EC3O00A00501001228010400133O0004EC4O0004010012280104000B3O00061E0102008F070100040004EC3O008F0701001228010400013O0012280105006D012O0012280106006E012O00062101060005070100050004EC3O000507010012280105000C3O000675000400CE050100050004EC3O00CE05010012280105006F012O00122801060070012O00062101060005070100050004EC3O000507012O00FE000500144O00A4000600023O00122O00070071012O00122O00080072015O0006000800024O00050005000600202O0005000500904O00050002000200122O00060073012O00062O00050016060100060004EC3O001606012O00FE000500144O0069000600023O00122O00070074012O00122O00080075015O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00122O0007008A6O00060006000700062O00050016060100060004EC3O001606012O00FE000500144O0069000600023O00122O00070076012O00122O00080077015O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00122O0007008A6O00060006000700062O00050016060100060004EC3O001606012O00FE000500144O000C010600023O00122O00070078012O00122O00080079015O0006000800024O00050005000600202O0005000500904O00050002000200122O00060012012O00062O00050005060100060004EC3O000506012O00FE000500053O0020C20005000500E600122O000700E03O00122O0008000C6O00050008000200062O00050016060100010004EC3O001606012O00FE0005001B3O0006F80005006C06013O0004EC3O006C06012O00FE0005001A3O00122801060073012O00069C0005006C060100060004EC3O006C06012O00FE0005000E3O001228010600173O00069C0005006C060100060004EC3O006C06012O00FE000500053O0012280107007A013O002A0105000500072O004B0005000200020006780005006C060100010004EC3O006C06012O00FE000500144O0004000600023O00122O0007007B012O00122O0008007C015O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005006806013O0004EC3O006806012O00FE000500144O00A4000600023O00122O0007007D012O00122O0008007E015O0006000800024O00050005000600202O0005000500904O00050002000200122O00060073012O00062O00050068060100060004EC3O006806012O00FE000500144O0069000600023O00122O0007007F012O00122O00080080015O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00122O0007008A6O00060006000700062O00050068060100060004EC3O006806012O00FE000500144O0069000600023O00122O00070081012O00122O00080082015O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00122O0007008A6O00060006000700062O00050068060100060004EC3O006806012O00FE000500144O000C010600023O00122O00070083012O00122O00080084015O0006000800024O00050005000600202O0005000500904O00050002000200122O00060012012O00062O00050057060100060004EC3O005706012O00FE000500053O0020C20005000500E600122O000700E03O00122O0008000C6O00050008000200062O00050068060100010004EC3O006806012O00FE0005001B3O0006F80005006C06013O0004EC3O006C06012O00FE0005001A3O00122801060073012O00069C0005006C060100060004EC3O006C06012O00FE0005000E3O001228010600173O00069C0005006C060100060004EC3O006C06012O00FE000500053O0012280107007A013O002A0105000500072O004B0005000200020006780005006C060100010004EC3O006C060100122801050085012O001228010600563O0006210106009C060100050004EC3O009C0601001228010500014O00E3000600073O00122801080086012O00122801090086012O00061E01080095060100090004EC3O009506010012280108000B3O00067500050079060100080004EC3O0079060100122801080087012O00122801090088012O00062101080095060100090004EC3O0095060100122801080089012O0012280109008A012O00063F00090079060100080004EC3O00790601001228010800013O00067500080084060100060004EC3O008406010012280108008B012O0012280109008C012O00061E01080079060100090004EC3O007906012O00FE000800284O00D50008000100024O000700083O00122O0008008D012O00122O0009008E012O00062O0008009C060100090004EC3O009C060100067800070091060100010004EC3O009106010012280108008F012O00122801090090012O00061E0108009C060100090004EC3O009C06012O0047000700023O0004EC3O009C06010004EC3O007906010004EC3O009C0601001228010800013O00061E0105006E060100080004EC3O006E0601001228010600014O00E3000700073O0012280105000B3O0004EC3O006E060100122801050091012O00122801060092012O00063F00050004070100060004EC3O000407012O00FE000500144O00A4000600023O00122O00070093012O00122O00080094015O0006000800024O00050005000600202O0005000500904O00050002000200122O00060073012O00062O00050004070100060004EC3O000407012O00FE000500294O00DA000500010002000678000500CF060100010004EC3O00CF06012O00FE000500144O00BC000600023O00122O00070095012O00122O00080096015O0006000800024O00050005000600202O0005000500BF4O00050002000200062O00050004070100010004EC3O000407012O00FE0005002A4O00DA000500010002000678000500CF060100010004EC3O00CF06012O00FE000500144O0016010600023O00122O00070097012O00122O00080098015O0006000800024O00050005000600122O00070099015O0005000500074O00050002000200062O000500CF060100010004EC3O00CF06012O00FE000500053O0020C20005000500E600122O000700E03O00122O0008000C6O00050008000200062O00050004070100010004EC3O000407012O00FE0005001B3O0006F8000500E006013O0004EC3O00E006012O00FE0005001A3O00122801060073012O00069C000500E0060100060004EC3O00E006012O00FE0005000E3O001228010600173O00069C000500E0060100060004EC3O00E006012O00FE000500053O0012280107007A013O002A0105000500072O004B0005000200020006F80005000407013O0004EC3O00040701001228010500014O00E3000600073O001228010800013O00061E010500E8060100080004EC3O00E80601001228010600014O00E3000700073O0012280105000B3O0012280108000B3O000675000500EF060100080004EC3O00EF06010012280108009A012O0012280109009B012O000621010900E2060100080004EC3O00E206010012280108009C012O0012280109009D012O000621010900EF060100080004EC3O00EF0601001228010800013O00061E010800EF060100060004EC3O00EF06012O00FE000800284O00DA0008000100022O007D000700083O000678000700FF060100010004EC3O00FF06010012280108009E012O0012280109009F012O00061E01080004070100090004EC3O000407012O0047000700023O0004EC3O000407010004EC3O00EF06010004EC3O000407010004EC3O00E20601001228010400133O0012280105000B3O00061E0104006F070100050004EC3O006F07012O00FE0005000E3O001228010600E03O00063F0005002C070100060004EC3O002C0701001228010500014O00E3000600073O001228010800013O00061E01050014070100080004EC3O00140701001228010600014O00E3000700073O0012280105000B3O001228010800A0012O001228010900A1012O00063F0009000E070100080004EC3O000E07010012280108000B3O00061E0105000E070100080004EC3O000E0701001228010800A2012O001228010900A3012O0006210108001B070100090004EC3O001B0701001228010800013O00061E0106001B070100080004EC3O001B07012O00FE0008002B4O00DA0008000100022O007D000700083O0006F80007002C07013O0004EC3O002C07012O0047000700023O0004EC3O002C07010004EC3O001B07010004EC3O002C07010004EC3O000E07012O00FE000500144O0004000600023O00122O000700A4012O00122O000800A5015O0006000800024O00050005000600202O00050005008D4O00050002000200062O0005005407013O0004EC3O005407012O00FE000500133O001228010600A6012O00063F00050054070100060004EC3O005407012O00FE0005000E3O001228010600A7013O006E000500050006001228010600173O00069C00060046070100050004EC3O004607012O00FE0005000E3O001228010600A7013O006E00050005000600122801060073012O00063F00050054070100060004EC3O005407012O00FE000500144O00BC000600023O00122O000700A8012O00122O000800A9015O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005005C070100010004EC3O005C07012O00FE000500083O0012280106000C3O00069C0006005C070100050004EC3O005C0701001228010500AA012O001228010600AB012O00069C0006005C070100050004EC3O005C0701001228010500AC012O001228010600AD012O00061E0105006E070100060004EC3O006E07012O00FE000500184O0015010600143O00202O0006000600FD4O000700086O000900073O00202O0009000900A04O000B00143O00202O000B000B00FD4O0009000B00024O000900096O00050009000200062O0005006E07013O0004EC3O006E07012O00FE000500023O001228010600AE012O001228010700AF013O0037000500074O007300055O0012280104000C3O001228010500133O00067500040076070100050004EC3O0076070100122801050058012O001228010600B0012O00063F00060078070100050004EC3O007807010012280102000C3O0004EC3O008F0701001228010500013O00067500040083070100050004EC3O00830701001228010500B1012O001228010600B2012O0006AD00050005000100060004EC3O00830701001228010500B3012O001228010600B4012O000621010600C3050100050004EC3O00C305012O00FE0005002C4O00070105000100024O000300053O00122O000500B5012O00122O000600B5012O00062O0005008D070100060004EC3O008D07010006F80003008D07013O0004EC3O008D07012O0047000300023O0012280104000B3O0004EC3O00C30501001228010400B6012O001228010500B7012O00063F000400B2090100050004EC3O00B209010012280104000C3O00061E010200B2090100040004EC3O00B20901001228010400013O001228010500B8012O001228010600B8012O00061E010500A0070100060004EC3O00A00701001228010500133O00061E010400A0070100050004EC3O00A00701001228010200133O0004EC3O00B20901001228010500013O000675000400AB070100050004EC3O00AB070100122801050090012O001228010600B9012O000675000500AB070100060004EC3O00AB0701001228010500BA012O001228010600BB012O0006210106000A080100050004EC3O000A0801001228010500BC012O001228010600BD012O00063F000600DD070100050004EC3O00DD07012O00FE000500144O0004000600023O00122O000700BE012O00122O000800BF015O0006000800024O00050005000600202O0005000500754O00050002000200062O000500DD07013O0004EC3O00DD07012O00FE000500294O00DA000500010002000678000500CC070100010004EC3O00CC07012O00FE0005002A4O00DA000500010002000678000500CC070100010004EC3O00CC07012O00FE000500144O00A4000600023O00122O000700C0012O00122O000800C1015O0006000800024O00050005000600202O0005000500904O00050002000200122O000600C2012O00062O000600DD070100050004EC3O00DD0701001228010500C3012O001228010600C4012O000621010600DD070100050004EC3O00DD07012O00FE000500184O0005010600143O00122O000700C5015O0006000600074O0007002D6O00050007000200062O000500DD07013O0004EC3O00DD07012O00FE000500023O001228010600C6012O001228010700C7013O0037000500074O007300055O001228010500C8012O001228010600C8012O00061E010500F6070100060004EC3O00F607012O00FE000500144O0004000600023O00122O000700C9012O00122O000800CA015O0006000800024O00050005000600202O00050005008D4O00050002000200062O000500F607013O0004EC3O00F607012O00FE000500144O000C010600023O00122O000700CB012O00122O000800CC015O0006000800024O00050005000600202O0005000500904O00050002000200122O000600CD012O00062O000600FA070100050004EC3O00FA0701001228010500CE012O001228010600CF012O00062101060009080100050004EC3O000908012O00FE000500184O00FE000600143O0020A60006000600912O004B00050002000200067800050004080100010004EC3O00040801001228010500D0012O001228010600D1012O00062101060009080100050004EC3O000908012O00FE000500023O001228010600D2012O001228010700D3013O0037000500074O007300055O0012280104000B3O0012280105000B3O00061E0104002O090100050004EC3O002O09012O00FE000500144O0004000600023O00122O000700D4012O00122O000800D5015O0006000800024O00050005000600202O00050005008D4O00050002000200062O0005007208013O0004EC3O007208012O00FE000500053O0020100105000500CC4O000700143O00122O000800D6015O0007000700084O00050007000200062O0005007208013O0004EC3O007208012O00FE000500144O0004000600023O00122O000700D7012O00122O000800D8015O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005003608013O0004EC3O003608012O00FE000500144O0069000600023O00122O000700D9012O00122O000800DA015O0006000800024O00050005000600202O0005000500904O0005000200024O000600103O00122O0007000C6O00060006000700062O0006003A080100050004EC3O003A08012O00FE0005000F3O001228010600703O00069C00050047080100060004EC3O004708012O00FE0005000F4O00FE0006002E4O00FE000700083O0012280108000C3O00069C00080041080100070004EC3O004108012O008800076O0036010700014O004B000600020002001228010700704O006600060007000600063F00050072080100060004EC3O007208012O00FE000500053O0012F100070008015O00050005000700122O0007000B6O000800143O00122O0009005E015O0008000800094O00050008000200062O00050072080100010004EC3O007208012O00FE000500053O0020A80005000500E600122O000700DB012O00122O0008000C6O00050008000200062O0005007208013O0004EC3O00720801001228010500DC012O001228010600DD012O00063F00060072080100050004EC3O007208012O00FE0005000B3O0020A300050005009E4O000600143O00122O0007005E015O0006000600074O000700066O0008002F6O000900073O00202O0009000900A04O000B00143O00122O000C005E015O000B000B000C4O0009000B00024O000900096O00050009000200062O0005007208013O0004EC3O007208012O00FE000500023O001228010600DE012O001228010700DF013O0037000500074O007300056O00FE000500144O0004000600023O00122O000700E0012O00122O000800E1015O0006000800024O00050005000600202O00050005008D4O00050002000200062O0005000809013O0004EC3O000809012O00FE000500053O0012890007005C015O0005000500074O000700143O00122O000800D6015O0007000700084O00050007000200062O0005000809013O0004EC3O000809012O00FE000500073O0012BE000700E2015O0005000500074O000700143O00122O000800E3015O0007000700084O00050007000200062O000500EC080100010004EC3O00EC08012O00FE000500144O0016010600023O00122O000700E4012O00122O000800E5015O0006000800024O00050005000600122O000700E6015O0005000500074O00050002000200062O000500BB080100010004EC3O00BB08012O00FE000500073O0012C4000700E7015O0005000500074O000700143O00122O000800E3015O0007000700084O0005000700024O000600116O000700106O000800146O000900023O00122O000A00E8012O00122O000B00E9015O0009000B00024O00080008000900122O000A00EA015O00080008000A4O000800096O00063O00024O000700126O000800106O000900146O000A00023O00122O000B00E8012O00122O000C00E9015O000A000C00024O00090009000A00122O000B00EA015O00090009000B4O0009000A6O00073O00024O00060006000700062O000500EC080100060004EC3O00EC08012O00FE000500144O002E000600023O00122O000700EB012O00122O000800EC015O0006000800024O00050005000600122O000700E6015O0005000500074O00050002000200062O0005000809013O0004EC3O000809012O00FE000500073O0012B1000700E7015O0005000500074O000700143O00122O000800E3015O0007000700084O0005000700024O000600116O000700106O000800146O000900023O00122O000A00ED012O00122O000B00EE015O0009000B00024O00080008000900122O000A00EA015O00080008000A4O0008000200024O00070007000800122O000800136O0006000800024O000700126O000800106O000900146O000A00023O00122O000B00ED012O00122O000C00EE015O000A000C00024O00090009000A00122O000B00EA015O00090009000B4O0009000200024O00080008000900122O000900136O0007000900024O00060006000700062O00050008090100060004EC3O000809012O00FE000500053O0020A80005000500E600122O000700DB012O00122O0008000C6O00050008000200062O0005000809013O0004EC3O000809012O00FE000500184O000B000600143O00122O000700EF015O0006000600074O000700306O00050007000200062O00050003090100010004EC3O00030901001228010500F0012O001228010600F1012O0006AD00050005000100060004EC3O00030901001228010500F2012O001228010600F3012O00063F00050008090100060004EC3O000809012O00FE000500023O001228010600F4012O001228010700F5013O0037000500074O007300055O0012280104000C3O0012280105000C3O00067500040014090100050004EC3O00140901001228010500F6012O001228010600F7012O0006AD00050005000100060004EC3O00140901001228010500F8012O001228010600F9012O00063F00050097070100060004EC3O00970701001228010500FA012O001228010600FA012O00061E0105008C090100060004EC3O008C09012O00FE000500144O0004000600023O00122O000700FB012O00122O000800FC015O0006000800024O00050005000600202O0005000500754O00050002000200062O0005008C09013O0004EC3O008C09012O00FE000500053O0020B60005000500B84O000700143O00202O0007000700B94O0005000700024O000600103O00062O0005008C090100060004EC3O008C09012O00FE0005000E3O001228010600DA3O00063F00060048090100050004EC3O004809012O00FE0005000E4O003C000600116O000700146O000800023O00122O000900FD012O00122O000A00FE015O0008000A00024O00070007000800202O0007000700904O00070002000200122O000800DD6O0006000800024O000700126O000800146O000900023O00122O000A00FD012O00122O000B00FE015O0009000B00024O00080008000900202O0008000800904O00080002000200122O000900DD6O0007000900024O00060006000700062O00060078090100050004EC3O007809012O00FE000500144O000C010600023O00122O000700FF012O00122O00082O00025O0006000800024O00050005000600202O0005000500904O00050002000200122O000600E03O00062O00060078090100050004EC3O007809012O00FE0005001B3O00067800050078090100010004EC3O007809012O00FE000500053O0020700005000500CC4O000700143O00202O0007000700E14O00050007000200062O00050078090100010004EC3O007809012O00FE000500144O0004000600023O00122O00070001022O00122O0008002O025O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005007809013O0004EC3O007809012O00FE000500144O0004000600023O00122O00070003022O00122O00080004025O0006000800024O00050005000600202O0005000500BF4O00050002000200062O0005007809013O0004EC3O007809012O00FE000500053O0020C20005000500E600122O000700E03O00122O0008000C6O00050008000200062O0005008C090100010004EC3O008C090100122801050005022O00122801060006022O0006210106008C090100050004EC3O008C090100122801050007022O00122801060008022O0006210106008C090100050004EC3O008C09012O00FE000500184O009D000600143O00202O0006000600EB4O0007001C6O00050007000200062O0005008C09013O0004EC3O008C09012O00FE000500023O00122801060009022O0012280107000A023O0037000500074O007300055O0012280105000B022O0012280106000B022O00061E010500B0090100060004EC3O00B009012O00FE000500144O0004000600023O00122O0007000C022O00122O0008000D025O0006000800024O00050005000600202O00050005008D4O00050002000200062O000500B009013O0004EC3O00B009010012280105000E022O0012280106000F022O00063F000500B0090100060004EC3O00B009012O00FE000500184O00A7000600143O00122O00070010025O0006000600074O000700086O000900073O00202O0009000900C200122O000B00176O0009000B00024O000900096O00050009000200062O000500B009013O0004EC3O00B009012O00FE000500023O00122801060011022O00122801070012023O0037000500074O007300055O001228010400133O0004EC3O00970701001228010400703O000675000200BD090100040004EC3O00BD090100122801040013022O00122801050014022O0006AD00040005000100050004EC3O00BD090100122801040015022O00122801050016022O00063F000400C72O0100050004EC3O00C72O012O00FE000400144O0004000500023O00122O00060017022O00122O00070018025O0005000700024O00040004000500202O00040004008D4O00040002000200062O000400F309013O0004EC3O00F309012O00FE0004000F3O0012280105000C3O00063F000500F3090100040004EC3O00F309012O00FE000400083O0012280105000B3O00061E010400D9090100050004EC3O00D909012O00FE000400144O00BC000500023O00122O00060019022O00122O0007001A025O0005000700024O00040004000500202O0004000400BF4O00040002000200062O000400F3090100010004EC3O00F309010012280104001B022O0012280105001B022O00061E010400F3090100050004EC3O00F309010012280104001C022O0012280105001D022O000621010500F3090100040004EC3O00F309012O00FE000400184O0015010500143O00202O0005000500FD4O000600076O000800073O00202O0008000800A04O000A00143O00202O000A000A00FD4O0008000A00024O000800086O00040008000200062O000400F309013O0004EC3O00F309012O00FE000400023O0012280105001E022O0012280106001F023O0037000400064O007300045O00122801040020022O001228010500193O00063F000400430A0100050004EC3O00430A012O00FE000400144O0004000500023O00122O00060021022O00122O00070022025O0005000700024O00040004000500202O00040004008D4O00040002000200062O000400430A013O0004EC3O00430A012O00FE000400053O00121801060023025O0004000400064O000600143O00122O000700D6015O0006000600074O00040006000200122O0005000B3O00062O000500430A0100040004EC3O00430A012O00FE0004000F3O001228010500703O00063F000400190A0100050004EC3O00190A012O00FE000400144O0004000500023O00122O00060024022O00122O00070025025O0005000700024O00040004000500202O0004000400BF4O00040002000200062O0004002A0A013O0004EC3O002A0A012O00FE000400144O0002010500023O00122O00060026022O00122O00070027025O0005000700024O00040004000500202O0004000400904O0004000200024O000500103O00122O0006000C6O00050005000600062O0005002A0A0100040004EC3O002A0A012O00FE0004000F3O0012280105000C3O00063F000400430A0100050004EC3O00430A012O00FE000400313O000678000400430A0100010004EC3O00430A012O00FE0004000B3O0020A300040004009E4O000500143O00122O0006005E015O0005000500064O000600066O000700326O000800073O00202O0008000800A04O000A00143O00122O000B005E015O000A000A000B4O0008000A00024O000800086O00040008000200062O000400430A013O0004EC3O00430A012O00FE000400023O00122801050028022O00122801060029023O0037000400064O007300046O00FE000400144O0004000500023O00122O0006002A022O00122O0007002B025O0005000700024O00040004000500202O00040004008D4O00040002000200062O000400630A013O0004EC3O00630A012O00FE000400053O0020A80004000400E600122O000600DB012O00122O0007000C6O00040007000200062O000400630A013O0004EC3O00630A012O00FE000400053O0020100104000400CC4O000600143O00122O000700D6015O0006000600074O00040006000200062O000400630A013O0004EC3O00630A012O00FE0004000F3O001228010500703O00063F000400630A0100050004EC3O00630A012O00FE000400313O0006F8000400670A013O0004EC3O00670A010012280104002C022O0012280105002D022O00063F000400870A0100050004EC3O00870A010012280104002E022O0012280105002E022O00061E010400870A0100050004EC3O00870A012O00FE0004000B3O0012B80005002F025O0004000400054O000500143O00122O0006005E015O0005000500064O000600066O000700023O00122O00080030022O00122O00090031025O0007000900024O000800326O000900336O000A00073O00202O000A000A00A04O000C00143O00122O000D005E015O000C000C000D4O000A000C00024O000A000A6O0004000A000200062O000400870A013O0004EC3O00870A012O00FE000400023O00122801050032022O00122801060033023O0037000400064O007300045O00122801040034022O00122801050035022O00063F000500C10A0100040004EC3O00C10A012O00FE000400144O0004000500023O00122O00060036022O00122O00070037025O0005000700024O00040004000500202O00040004008D4O00040002000200062O000400A10A013O0004EC3O00A10A012O00FE0004000E4O0040000500053O00122O00070023025O0005000500074O000700143O00122O000800D6015O0007000700084O0005000700024O000600106O00050005000600062O000400A50A0100050004EC3O00A50A0100122801040038022O00122801050039022O000621010500C10A0100040004EC3O00C10A010012280104003A022O0012280105003B022O00063F000400C10A0100050004EC3O00C10A012O00FE000400184O0030010500143O00122O0006005E015O0005000500064O000600076O000800073O00202O0008000800A04O000A00143O00122O000B005E015O000A000A000B4O0008000A00024O000800086O00040008000200062O000400BC0A0100010004EC3O00BC0A010012280104003C022O0012280105003D022O000621010500C10A0100040004EC3O00C10A012O00FE000400023O0012280105003E022O0012280106003F023O0037000400064O007300046O00FE000400144O0004000500023O00122O00060040022O00122O00070041025O0005000700024O00040004000500202O00040004008D4O00040002000200062O000400FF0A013O0004EC3O00FF0A012O00FE000400053O0020100104000400CC4O000600143O00122O000700D6015O0006000600074O00040006000200062O000400FF0A013O0004EC3O00FF0A012O00FE000400144O00A4000500023O00122O00060042022O00122O00070043025O0005000700024O00040004000500202O0004000400904O00040002000200122O000500703O00062O000400FF0A0100050004EC3O00FF0A012O00FE0004000F3O001228010500703O00063F000400FF0A0100050004EC3O00FF0A012O00FE000400313O000678000400FF0A0100010004EC3O00FF0A012O00FE0004000B3O0020F000040004009E4O000500143O00122O0006005E015O0005000500064O000600066O000700326O000800073O00202O0008000800A04O000A00143O00122O000B005E015O000A000A000B4O0008000A00024O000800086O00040008000200062O000400FA0A0100010004EC3O00FA0A0100122801040044022O00122801050045022O00063F000500FF0A0100040004EC3O00FF0A012O00FE000400023O00122801050046022O00122801060047023O0037000400064O007300045O00122801040048022O00122801050049022O0006210105002B0B0100040004EC3O002B0B012O00FE000400144O0004000500023O00122O0006004A022O00122O0007004B025O0005000700024O00040004000500202O00040004008D4O00040002000200062O0004002B0B013O0004EC3O002B0B012O00FE000400053O0012890006005C015O0004000400064O000600143O00122O000700D6015O0006000600074O00040006000200062O0004002B0B013O0004EC3O002B0B010012280104004C022O0012280105004D022O00063F000500220B0100040004EC3O00220B012O00FE000400184O000B000500143O00122O000600EF015O0005000500064O000600306O00040006000200062O000400260B0100010004EC3O00260B010012280104004E022O0012280105004F022O0006210104002B0B0100050004EC3O002B0B012O00FE000400023O00122801050050022O00122801060051023O0037000400064O007300045O0012280102008A3O0004EC3O00C72O010004EC3O00310B010004EC3O000700010004EC3O00310B010004EC3O000200012O0014012O00017O00033O0003053O005072696E7403383O00295C3A312BF70156302765CF0C4B3B3126F34D4B382A24EC0456397E27E14D7C273726B64D6A222E35F71F4D323A65FA141910312FF11F5803063O00986D39575E4500084O00AF7O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

