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
				if (Enum <= 140) then
					if (Enum <= 69) then
						if (Enum <= 34) then
							if (Enum <= 16) then
								if (Enum <= 7) then
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
												if (Stk[Inst[2]] == Inst[4]) then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 2) then
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
									elseif (Enum == 6) then
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
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
									elseif (Enum > 10) then
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
									elseif (Stk[Inst[2]] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 13) then
									if (Enum > 12) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 14) then
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								elseif (Enum > 15) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 25) then
								if (Enum <= 20) then
									if (Enum <= 18) then
										if (Enum == 17) then
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
									elseif (Enum > 19) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 22) then
									if (Enum > 21) then
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
										if (Inst[2] > Stk[Inst[4]]) then
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
								elseif (Enum <= 23) then
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 24) then
									Stk[Inst[2]] = Stk[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 29) then
								if (Enum <= 27) then
									if (Enum > 26) then
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
								elseif (Enum > 28) then
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
							elseif (Enum <= 31) then
								if (Enum > 30) then
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
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								end
							elseif (Enum <= 32) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							elseif (Enum == 33) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						elseif (Enum <= 51) then
							if (Enum <= 42) then
								if (Enum <= 38) then
									if (Enum <= 36) then
										if (Enum == 35) then
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
									elseif (Enum == 37) then
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
								elseif (Enum <= 40) then
									if (Enum > 39) then
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
								elseif (Enum == 41) then
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
							elseif (Enum <= 46) then
								if (Enum <= 44) then
									if (Enum > 43) then
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
									end
								elseif (Enum == 45) then
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
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
									if (Inst[2] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 48) then
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
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								end
							elseif (Enum <= 49) then
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
							elseif (Enum > 50) then
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
						elseif (Enum <= 60) then
							if (Enum <= 55) then
								if (Enum <= 53) then
									if (Enum > 52) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
									end
								elseif (Enum == 54) then
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 57) then
								if (Enum == 56) then
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
							elseif (Enum <= 58) then
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
							elseif (Enum > 59) then
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
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
							end
						elseif (Enum <= 64) then
							if (Enum <= 62) then
								if (Enum > 61) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								else
									Stk[Inst[2]]();
								end
							elseif (Enum > 63) then
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
						elseif (Enum <= 66) then
							if (Enum == 65) then
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
							elseif (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 67) then
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
						elseif (Enum == 68) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 104) then
						if (Enum <= 86) then
							if (Enum <= 77) then
								if (Enum <= 73) then
									if (Enum <= 71) then
										if (Enum > 70) then
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
									elseif (Enum > 72) then
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
								elseif (Enum <= 75) then
									if (Enum == 74) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 76) then
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
							elseif (Enum <= 81) then
								if (Enum <= 79) then
									if (Enum == 78) then
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
								elseif (Enum == 80) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								else
									local Edx;
									local Results, Limit;
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
							elseif (Enum <= 83) then
								if (Enum == 82) then
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
							elseif (Enum <= 84) then
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
							elseif (Enum > 85) then
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
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
						elseif (Enum <= 95) then
							if (Enum <= 90) then
								if (Enum <= 88) then
									if (Enum > 87) then
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									end
								elseif (Enum == 89) then
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
										if (Mvm[1] == 24) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								end
							elseif (Enum <= 92) then
								if (Enum == 91) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
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
							elseif (Enum <= 93) then
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
							elseif (Enum == 94) then
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
						elseif (Enum <= 99) then
							if (Enum <= 97) then
								if (Enum == 96) then
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 98) then
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
						elseif (Enum <= 101) then
							if (Enum == 100) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 102) then
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
						elseif (Enum > 103) then
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
					elseif (Enum <= 122) then
						if (Enum <= 113) then
							if (Enum <= 108) then
								if (Enum <= 106) then
									if (Enum > 105) then
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
								elseif (Enum == 107) then
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
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 110) then
								if (Enum > 109) then
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
							elseif (Enum == 112) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						elseif (Enum <= 117) then
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
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum == 116) then
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
								Stk[Inst[2]] = #Stk[Inst[3]];
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
						elseif (Enum <= 119) then
							if (Enum > 118) then
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
						elseif (Enum <= 120) then
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
						elseif (Enum > 121) then
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
					elseif (Enum <= 131) then
						if (Enum <= 126) then
							if (Enum <= 124) then
								if (Enum > 123) then
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
							elseif (Enum > 125) then
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
						elseif (Enum <= 128) then
							if (Enum == 127) then
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
							if (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 130) then
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 135) then
						if (Enum <= 133) then
							if (Enum > 132) then
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
						elseif (Enum == 134) then
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
					elseif (Enum <= 137) then
						if (Enum == 136) then
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
					elseif (Enum <= 138) then
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
					elseif (Enum == 139) then
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
				elseif (Enum <= 210) then
					if (Enum <= 175) then
						if (Enum <= 157) then
							if (Enum <= 148) then
								if (Enum <= 144) then
									if (Enum <= 142) then
										if (Enum > 141) then
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
											local Edx;
											local Limit;
											local Results;
											local A;
											A = Inst[2];
											Results = {Stk[A]()};
											Limit = Inst[4];
											Edx = 0;
											for Idx = A, Limit do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Env[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Env[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
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
									elseif (Enum > 143) then
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
								elseif (Enum <= 146) then
									if (Enum > 145) then
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
								elseif (Enum > 147) then
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
								elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum <= 152) then
								if (Enum <= 150) then
									if (Enum == 149) then
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
										VIP = Inst[3];
									else
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum > 151) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
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
							elseif (Enum <= 154) then
								if (Enum == 153) then
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
							elseif (Enum <= 155) then
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
							elseif (Enum == 156) then
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
						elseif (Enum <= 166) then
							if (Enum <= 161) then
								if (Enum <= 159) then
									if (Enum > 158) then
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
								elseif (Enum > 160) then
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
							elseif (Enum <= 163) then
								if (Enum == 162) then
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
							elseif (Enum == 165) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 170) then
							if (Enum <= 168) then
								if (Enum == 167) then
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
							elseif (Enum == 169) then
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
						elseif (Enum <= 172) then
							if (Enum > 171) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 173) then
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
						elseif (Enum == 174) then
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
					elseif (Enum <= 192) then
						if (Enum <= 183) then
							if (Enum <= 179) then
								if (Enum <= 177) then
									if (Enum == 176) then
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
										local B = Stk[Inst[4]];
										if B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									end
								elseif (Enum > 178) then
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
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								end
							elseif (Enum <= 181) then
								if (Enum == 180) then
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
								end
							elseif (Enum > 182) then
								if (Inst[2] < Stk[Inst[4]]) then
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
						elseif (Enum <= 187) then
							if (Enum <= 185) then
								if (Enum == 184) then
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
								end
							elseif (Enum > 186) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							end
						elseif (Enum <= 189) then
							if (Enum == 188) then
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 190) then
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						elseif (Enum > 191) then
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
					elseif (Enum <= 201) then
						if (Enum <= 196) then
							if (Enum <= 194) then
								if (Enum > 193) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 195) then
								do
									return;
								end
							else
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 198) then
							if (Enum == 197) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 199) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						elseif (Enum > 200) then
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
							do
								return Stk[Inst[2]];
							end
						end
					elseif (Enum <= 205) then
						if (Enum <= 203) then
							if (Enum == 202) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum == 204) then
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 207) then
						if (Enum == 206) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
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
					elseif (Enum <= 208) then
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
					elseif (Enum == 209) then
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
						Stk[Inst[2]] = #Stk[Inst[3]];
					end
				elseif (Enum <= 245) then
					if (Enum <= 227) then
						if (Enum <= 218) then
							if (Enum <= 214) then
								if (Enum <= 212) then
									if (Enum > 211) then
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
									end
								elseif (Enum > 213) then
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
								else
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 216) then
								if (Enum > 215) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
							elseif (Enum == 217) then
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
						elseif (Enum <= 222) then
							if (Enum <= 220) then
								if (Enum == 219) then
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
							elseif (Enum == 221) then
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
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 224) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 225) then
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
						elseif (Enum > 226) then
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
						elseif (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 236) then
						if (Enum <= 231) then
							if (Enum <= 229) then
								if (Enum > 228) then
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
							elseif (Enum > 230) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 233) then
							if (Enum == 232) then
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
						elseif (Enum <= 234) then
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
						elseif (Enum > 235) then
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
					elseif (Enum <= 240) then
						if (Enum <= 238) then
							if (Enum == 237) then
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
						elseif (Enum == 239) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
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
					elseif (Enum <= 242) then
						if (Enum == 241) then
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
					elseif (Enum <= 243) then
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
					elseif (Enum > 244) then
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
					end
				elseif (Enum <= 263) then
					if (Enum <= 254) then
						if (Enum <= 249) then
							if (Enum <= 247) then
								if (Enum == 246) then
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
							elseif (Enum > 248) then
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
						elseif (Enum <= 251) then
							if (Enum == 250) then
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
						elseif (Enum <= 252) then
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
						elseif (Enum == 253) then
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
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 258) then
						if (Enum <= 256) then
							if (Enum == 255) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
						elseif (Enum == 257) then
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
					elseif (Enum <= 260) then
						if (Enum == 259) then
							if (Inst[2] == Stk[Inst[4]]) then
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
					elseif (Enum <= 261) then
						local Edx;
						local Results, Limit;
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
					elseif (Enum > 262) then
						Stk[Inst[2]] = not Stk[Inst[3]];
					else
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
					end
				elseif (Enum <= 272) then
					if (Enum <= 267) then
						if (Enum <= 265) then
							if (Enum == 264) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 266) then
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
					elseif (Enum <= 269) then
						if (Enum == 268) then
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
					elseif (Enum <= 270) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 271) then
						local A = Inst[2];
						local Results = {Stk[A]()};
						local Limit = Inst[4];
						local Edx = 0;
						for Idx = A, Limit do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					else
						Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
					end
				elseif (Enum <= 276) then
					if (Enum <= 274) then
						if (Enum > 273) then
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
							Stk[Inst[2]] = {};
						end
					elseif (Enum == 275) then
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
						VIP = Inst[3];
					end
				elseif (Enum <= 278) then
					if (Enum > 277) then
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
				elseif (Enum > 280) then
					Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
				else
					Env[Inst[3]] = Stk[Inst[2]];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!333O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403053O005574696C7303063O00506C6179657203063O0054617267657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03043O004361737403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03143O00476574576561706F6E456E6368616E74496E666F03043O006D6174682O033O006D617803053O006D6174636803063O005368616D616E030B3O00456E68616E63656D656E7403093O004C6176614275727374030B3O004973417661696C61626C65027O0040026O00F03F030D3O004C696768746E696E67426F6C74024O0080B3C54003103O005265676973746572466F724576656E74030E3O00114E3B08D78B1D5D3605D59F075A03063O00D8421E7E449B03143O0086ED2CF9EB86F3DE99F828E7E99CFECF95FC2CE903083O0081CAA86DABA5C3B703143O00127416E1FB26D9107D10FDF02BC30C7915F4FB3003073O0086423857B8BE7403243O001D123D922FCE1E052O10309E2BD412051912209A35C21B140818269526C8091412162C9F03083O00555C5169DB798B4103063O0053657441504C025O002O704000DF012O0012233O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001000414012O000A0001001293000300063O0020BE000400030007001293000500083O0020BE000500050009001293000600083O0020BE00060006000A00065A00073O000100062O00183O00064O00188O00183O00044O00183O00014O00183O00024O00183O00054O00D30008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000D001100202O0010000D001200202O0011000B00130020BE0012000B001400200C0013000B001500122O0014000D3O00202O00150014001600202O00160014001700202O00170014001800202O00180014001900202O00180018001A00202O00180018001B00202O00190014001900202O00190019001A0020BE00190019001C001233001A001D3O00122O001B001E3O00202O001B001B001F00122O001C00013O00202O001C001C00204O001D001D6O001E8O001F8O00208O00216O003400226O001F002300613O00202O00620011002100202O00620062002200202O00630013002100202O00630063002200202O00640016002100202O0064006400224O00658O0066006D3O00202O006E006200230020C7006E006E00242O0080006E00020002000609016E004800013O000414012O004800010012ED006E00253O0006A8006E004900010001000414012O004900010012ED006E00263O0020BE006F006200270012ED007000283O0012ED007100283O0020C70072000B002900065A00740001000100022O00183O006E4O00183O00624O005F007500073O00122O0076002A3O00122O0077002B6O0075007700024O007600073O00122O0077002C3O00122O0078002D6O007600786O00723O000100202O0072000B002900065A00740002000100042O00183O00714O00183O006F4O00183O00624O00183O00704O0013007500073O00122O0076002E3O00122O0077002F6O007500776O00723O000100202O00720014001900202O00720072001A00065A00730003000100022O00183O00624O00183O00723O0020C70074000B002900065A00760004000100012O00183O00734O000B017700073O00122O007800303O00122O007900316O007700796O00743O000100065A00740005000100032O00183O001C4O00183O000F4O00183O00073O00065A00750006000100022O00183O00624O00183O000F3O00065A00760007000100012O00183O00623O00065A00770008000100012O00183O00623O00065A00780009000100012O00183O00623O00065A0079000A000100022O00183O000F4O00183O00623O00065A007A000B000100022O00183O00104O00183O00623O00065A007B000C000100012O00183O00623O00065A007C000D000100022O00183O00624O00183O006C3O00065A007D000E000100062O00183O00624O00183O00224O00183O00724O00183O00174O00183O00644O00183O00073O00065A007E000F000100072O00183O004F4O00183O00474O00183O00624O00183O000F4O00183O00174O00183O00644O00183O00073O00065A007F0010000100052O00183O000F4O00183O00534O00183O00624O00183O00174O00183O00073O00065A00800011000100162O00183O00624O00183O00444O00183O000F4O00183O004A4O00183O00174O00183O00074O00183O00454O00183O00724O00183O004B4O00183O004C4O00183O00464O00183O004D4O00183O004E4O00183O00474O00183O004F4O00183O00634O00183O00484O00183O00504O00183O00644O00183O00494O00183O00514O00183O005C3O00065A00810012000100042O00183O001D4O00183O00724O00183O00654O00183O00203O00065A008200130001000F2O00183O00624O00183O000F4O00183O00314O00183O00174O00183O00074O00183O00354O00183O003A4O00183O00204O00183O00364O00183O003B4O00183O00104O00183O00304O00183O003C4O00183O00214O00183O002F3O00065A00830014000100202O00183O00624O00183O00294O00183O000F4O00183O00174O00183O00104O00183O00074O00183O002C4O00183O002A4O00183O00324O00183O00284O00183O00244O00183O002D4O00183O00314O00183O002B4O00183O00254O00183O00754O00183O002E4O00183O003D4O00183O00214O00183O00604O00183O00714O00183O00264O00183O00304O00183O003C4O00183O002F4O00183O00384O00183O003F4O00183O00204O00183O00274O00183O00184O00183O006F4O00183O006E3O00065A00840015000100202O00183O00624O00183O00304O00183O003C4O00183O00214O00183O00604O00183O00714O00183O000F4O00183O00174O00183O00104O00183O00074O00183O00274O00183O006C4O00183O002C4O00183O00724O00183O006B4O00183O00774O00183O00254O00183O00264O00183O006E4O00183O00244O00183O002A4O00183O00294O00183O00284O00183O00184O00183O00754O00183O00314O00183O002D4O00183O002E4O00183O003D4O00183O00764O00183O00324O00183O002F3O00065A00850016000100202O00183O00624O00183O00274O00183O006C4O00183O00174O00183O00074O00183O002A4O00183O000F4O00183O00104O00183O00294O00183O00304O00183O003C4O00183O00214O00183O00604O00183O00714O00183O00284O00183O00724O00183O006B4O00183O00764O00183O002D4O00183O00184O00183O002C4O00183O002E4O00183O003D4O00183O00264O00183O006E4O00183O00324O00183O002F4O00183O00244O00183O002B4O00183O00254O00183O00754O00183O00313O00065A00860017000100102O00183O00674O00183O00694O00183O00334O00183O00624O00183O00174O00183O00074O00183O00524O00183O001D4O00183O007F4O00183O00104O00183O000F4O00183O00724O00183O001E4O00183O00824O00183O00664O00183O00683O00065A008700180001002D2O00183O005A4O00183O00564O00183O001D4O00183O00724O00183O00624O00183O000F4O00183O00574O00183O00644O00183O00544O00183O00554O00183O005B4O00183O00614O00183O00224O00183O00584O00183O00104O00183O00174O00183O00074O00183O007E4O00183O00604O00183O00714O00183O00374O00183O00204O00183O003E4O00183O00814O00183O00384O00183O003F4O00183O00324O00183O006C4O00183O006F4O00183O002E4O00183O003D4O00183O00214O00183O00354O00183O003A4O00183O00344O00183O00394O00183O00364O00183O003B4O00183O00834O00183O001F4O00183O00844O00183O00144O00183O00804O00183O00594O00183O007D3O00065A00880019000100192O00183O00294O00183O00074O00183O002A4O00183O002B4O00183O002C4O00183O002D4O00183O002E4O00183O002F4O00183O00304O00183O003B4O00183O003A4O00183O003D4O00183O003C4O00183O00254O00183O00264O00183O00274O00183O00284O00183O00324O00183O00314O00183O00334O00183O00394O00183O00344O00183O00364O00183O00354O00183O00243O00065A0089001A000100152O00183O00454O00183O00074O00183O00444O00183O00474O00183O00544O00183O00554O00183O00564O00183O00464O00183O004B4O00183O004C4O00183O00524O00183O00534O00183O00614O00183O004A4O00183O004D4O00183O004E4O00183O00574O00183O00404O00183O00414O00183O00424O00183O004F3O00065A008A001B000100122O00183O00594O00183O00074O00183O00584O00183O00374O00183O00384O00183O003E4O00183O003F4O00183O00484O00183O00494O00183O00604O00183O005D4O00183O005E4O00183O005F4O00183O00504O00183O00514O00183O005C4O00183O005A4O00183O005B3O00065A008B001C000100242O00183O001F4O00183O00074O00183O00204O00183O00224O00183O00214O00183O000F4O00183O00664O00183O00684O00183O00674O00183O00694O00183O001A4O00183O006B4O00183O006C4O00183O006A4O00183O006D4O00183O00594O00183O001D4O00183O00624O00183O00724O00183O00644O00183O00894O00183O00884O00183O008A4O00183O001E4O00183O00704O00183O000B4O00183O00714O00183O006F4O00183O007D4O00183O005A4O00183O00564O00183O00574O00183O00544O00183O00554O00183O00874O00183O00863O00065A008C001D000100042O00183O00144O00183O00074O00183O00624O00183O00733O002002008D0014003200122O008E00336O008F008B6O0090008C6O008D009000016O00013O001E3O00023O00026O00F03F026O00704002264O00F400025O00122O000300016O00045O00122O000500013O00042O0003002100012O009600076O006D000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004D70003000500012O0096000300054O0018000400024O0010000300044O002000036O00C43O00017O00043O0003093O004C6176614275727374030B3O004973417661696C61626C65027O0040026O00F03F000C4O009D3O00013O00206O000100206O00026O0002000200064O000900013O000414012O000900010012ED3O00033O0006A83O000A00010001000414012O000A00010012ED3O00044O007A8O00C43O00017O00043O00028O00026O00F03F024O0080B3C540030D3O004C696768746E696E67426F6C7400103O0012ED3O00013O0026E23O000600010002000414012O000600010012ED000100034O007A00015O000414012O000F00010026E23O000100010001000414012O000100012O0096000100023O0020CD0001000100044O000100013O00122O000100036O000100033O00124O00023O00044O000100012O00C43O00017O00043O00030D3O00436C65616E7365537069726974030B3O004973417661696C61626C6503123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O6673000B4O009D7O00206O000100206O00026O0002000200064O000A00013O000414012O000A00012O00963O00014O0096000100013O0020BE0001000100040010883O000300012O00C43O00019O003O00034O00968O003D3O000100012O00C43O00017O00053O00026O00F03F026O00184003093O00546F74656D4E616D6503053O00C9BC44407103063O00BF9DD330251C00133O0012ED3O00013O0012ED000100023O0012ED000200013O0004FB3O001200012O009600046O0004000500013O00202O0005000500034O000700036O0005000700024O000600023O00122O000700043O00122O000800056O000600086O00043O000200062O0004001100013O000414012O001100012O00C8000300023O0004D73O000400012O00C43O00017O000C3O00028O00026O00F03F026O002040030B3O00466572616C53706972697403113O0054696D6553696E63654C6173744361737403093O00416C706861576F6C66030B3O004973417661696C61626C6503083O0042752O66446F776E030F3O00466572616C53706972697442752O6603073O006D6174686D696E030E3O0043726173684C696768746E696E67030E3O00436861696E4C696768746E696E67002F3O0012ED3O00014O00D5000100013O0026E23O001000010002000414012O00100001000EC20003000C00010001000414012O000C00012O009600025O0020BE0002000200040020C70002000200052O00800002000200020006FE0002000E00010001000414012O000E00010012ED000200014O00C8000200023O00100F0102000300012O00C8000200023O0026E23O000200010001000414012O000200012O009600025O0020BE0002000200060020C70002000200072O00800002000200020006090102001F00013O000414012O001F00012O0096000200013O0020900002000200084O00045O00202O0004000400094O00020004000200062O0002002100013O000414012O002100010012ED000200014O00C8000200023O0012930002000A4O000501035O00202O00030003000B00202O0003000300054O0003000200024O00045O00202O00040004000C00202O0004000400054O000400056O00023O00024O000100023O0012ED3O00023O000414012O000200012O00C43O00017O00023O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O6601063O00203C00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O0003113O00446562752O665265667265736861626C6503133O004C617368696E67466C616D6573446562752O6601063O00203C00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O6601063O00203C00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O0003083O0042752O66446F776E03123O005072696D6F726469616C5761766542752O6601074O00E800015O00202O0001000100014O000300013O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303133O004C617368696E67466C616D6573446562752O6601074O00E800015O00202O0001000100014O000300013O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O004C617368696E67466C616D6573030B3O004973417661696C61626C6501064O003000015O00202O00010001000100202O0001000100024O0001000200024O000100028O00017O00043O0003083O00446562752O66557003103O00466C616D6553686F636B446562752O66030F3O0041757261416374697665436F756E74026O00184001173O00209000013O00014O00035O00202O0003000300024O00010003000200062O0001001500013O000414012O001500012O009600015O00205900010001000200202O0001000100034O0001000200024O000200013O00062O0001001300010002000414012O001300012O009600015O0020BE0001000100020020C70001000100032O00800001000200020026C50001001400010004000414012O001400012O003B00016O0034000100014O00C8000100024O00C43O00017O00073O00030D3O00436C65616E736553706972697403073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00394003123O00436C65616E7365537069726974466F63757303153O00DC13F11D34CC1ACB0F2AD60DFD087ADB16E70C3FD303053O005ABF7F947C001B4O009D7O00206O000100206O00026O0002000200064O001A00013O000414012O001A00012O00963O00013O000609012O001A00013O000414012O001A00012O00963O00023O0020BE5O00030012ED000100044O00803O00020002000609012O001A00013O000414012O001A00012O00963O00034O0096000100043O0020BE0001000100052O00803O00020002000609012O001A00013O000414012O001A00012O00963O00053O0012ED000100063O0012ED000200074O00103O00024O00208O00C43O00017O000E3O00028O0003053O00466F63757303063O0045786973747303093O004973496E52616E6765026O00444003103O004865616C746850657263656E74616765030C3O004865616C696E67537572676503073O004973526561647903093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O00144003113O004865616C696E675375726765466F63757303183O0070822F1B718929286B923C107DC72612798B6E1177843B0403043O007718E74E00393O0012ED3O00013O0026E23O000100010001000414012O00010001001293000100023O0006092O01001100013O000414012O00110001001293000100023O0020C70001000100032O00800001000200020006092O01001100013O000414012O00110001001293000100023O0020C70001000100040012ED000300054O00DE0001000300020006A80001001200010001000414012O001200012O00C43O00013O001293000100023O0006092O01003800013O000414012O00380001001293000100023O0020C70001000100062O00800001000200022O009600025O0006010001003800010002000414012O003800012O0096000100013O0006092O01003800013O000414012O003800012O0096000100023O0020BE0001000100070020C70001000100082O00800001000200020006092O01003800013O000414012O003800012O0096000100033O00207E0001000100094O000300023O00202O00030003000A4O000100030002000E2O000B003800010001000414012O003800012O0096000100044O0096000200053O0020BE00020002000C2O00800001000200020006092O01003800013O000414012O003800012O0096000100063O0012A00002000D3O00122O0003000E6O000100036O00015O00044O00380001000414012O000100012O00C43O00017O00053O0003103O004865616C746850657263656E74616765030C3O004865616C696E67537572676503073O004973526561647903163O008A28A446D54E16BD3EB058DB45518A28A4469C4F1E8103073O0071E24DC52ABC2000184O00367O00206O00016O000200024O000100013O00064O001700010001000414012O001700012O00963O00023O0020BE5O00020020C75O00032O00803O00020002000609012O001700013O000414012O001700012O00963O00034O0096000100023O0020BE0001000100022O00803O00020002000609012O001700013O000414012O001700012O00963O00043O0012ED000100043O0012ED000200054O00103O00024O00208O00C43O00017O00213O00028O00030B3O0041737472616C536869667403073O004973526561647903103O004865616C746850657263656E7461676503183O003B05E0A73B1ACBA6321FF2A17A12F1B33F18E7BC2C13B4E403043O00D55A769403113O00416E6365737472616C47756964616E6365031D3O00417265556E69747342656C6F774865616C746850657263656E74616765031E3O005A20B7535E4F3CB55A725C3BBD524C552DB116495E28B1585E5238B1161F03053O002D3B4ED436026O00F03F03123O004865616C696E6753747265616D546F74656D03203O00185382878F20AACF0342918E872392E41F422O86C62AA8F615589082902BEDA303083O00907036E3EBE64ECD030C3O004865616C696E67537572676503093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O00144003193O00BB2D0EF0D955B4171CE9C25CB6680BF9D65EBD3B06EAD51BE703063O003BD3486F9CB0027O0040030B3O004865616C746873746F6E6503173O004682E2215A8FF0394189E66D4A82E5284094EA3B4BC7B003043O004D2EE78303193O008851B052BF47BE49B453F668BF55BA49B453F670B540BF4FB403043O0020DA34D603173O0052656672657368696E674865616C696E67506F74696F6E03253O005C1237BAF4A34D53401071A0F4B14953401071B8FEA44C55405735ADF7B54B49470134E8A503083O003A2E7751C891D025031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O002F9E35ADA4AA37278735BEBAFD3E2E8D3CA5A7BA763B8324A5A6B3762F8936A9A7AE3F3D8903073O00564BEC50CCC9DD00D13O0012ED3O00013O0026E23O003900010001000414012O003900012O009600015O0020BE0001000100020020C70001000100032O00800001000200020006092O01001D00013O000414012O001D00012O0096000100013O0006092O01001D00013O000414012O001D00012O0096000100023O0020C70001000100042O00800001000200022O0096000200033O0006010001001D00010002000414012O001D00012O0096000100044O009600025O0020BE0002000200022O00800001000200020006092O01001D00013O000414012O001D00012O0096000100053O0012ED000200053O0012ED000300064O0010000100034O002000016O009600015O0020BE0001000100070020C70001000100032O00800001000200020006092O01003800013O000414012O003800012O0096000100063O0006092O01003800013O000414012O003800012O0096000100073O00204C0001000100084O000200086O000300096O00010003000200062O0001003800013O000414012O003800012O0096000100044O009600025O0020BE0002000200072O00800001000200020006092O01003800013O000414012O003800012O0096000100053O0012ED000200093O0012ED0003000A4O0010000100034O002000015O0012ED3O000B3O0026E23O00780001000B000414012O007800012O009600015O0020BE00010001000C0020C70001000100032O00800001000200020006092O01005600013O000414012O005600012O00960001000A3O0006092O01005600013O000414012O005600012O0096000100073O00204C0001000100084O0002000B6O0003000C6O00010003000200062O0001005600013O000414012O005600012O0096000100044O009600025O0020BE00020002000C2O00800001000200020006092O01005600013O000414012O005600012O0096000100053O0012ED0002000D3O0012ED0003000E4O0010000100034O002000016O009600015O0020BE00010001000F0020C70001000100032O00800001000200020006092O01007700013O000414012O007700012O00960001000D3O0006092O01007700013O000414012O007700012O0096000100023O0020C70001000100042O00800001000200022O00960002000E3O0006010001007700010002000414012O007700012O0096000100023O00207E0001000100104O00035O00202O0003000300114O000100030002000E2O0012007700010001000414012O007700012O0096000100044O009600025O0020BE00020002000F2O00800001000200020006092O01007700013O000414012O007700012O0096000100053O0012ED000200133O0012ED000300144O0010000100034O002000015O0012ED3O00153O0026E23O000100010015000414012O000100012O00960001000F3O0020BE0001000100160020C70001000100032O00800001000200020006092O01009400013O000414012O009400012O0096000100103O0006092O01009400013O000414012O009400012O0096000100023O0020C70001000100042O00800001000200022O0096000200113O0006010001009400010002000414012O009400012O0096000100044O0096000200123O0020BE0002000200162O00800001000200020006092O01009400013O000414012O009400012O0096000100053O0012ED000200173O0012ED000300184O0010000100034O002000016O0096000100133O0006092O0100D000013O000414012O00D000012O0096000100023O0020C70001000100042O00800001000200022O0096000200143O000601000100D000010002000414012O00D000010012ED000100013O0026E20001009E00010001000414012O009E00012O0096000200154O009C000300053O00122O000400193O00122O0005001A6O00030005000200062O000200B800010003000414012O00B800012O00960002000F3O0020BE00020002001B0020C70002000200032O0080000200020002000609010200B800013O000414012O00B800012O0096000200044O0096000300123O0020BE00030003001B2O0080000200020002000609010200B800013O000414012O00B800012O0096000200053O0012ED0003001C3O0012ED0004001D4O0010000200044O002000026O0096000200153O0026E2000200D00001001E000414012O00D000012O00960002000F3O0020BE00020002001F0020C70002000200032O0080000200020002000609010200D000013O000414012O00D000012O0096000200044O0096000300123O0020BE00030003001B2O0080000200020002000609010200D000013O000414012O00D000012O0096000200053O0012A0000300203O00122O000400216O000200046O00025O00044O00D00001000414012O009E0001000414012O00D00001000414012O000100012O00C43O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O0012ED3O00013O0026E23O001100010002000414012O001100012O0096000100013O0020250001000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O000414012O002200012O009600016O00C8000100023O000414012O002200010026E23O000100010001000414012O000100012O0096000100013O0020250001000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O000414012O002000012O009600016O00C8000100023O0012ED3O00023O000414012O000100012O00C43O00017O001B3O00028O00030D3O0057696E6466757279546F74656D03073O004973526561647903083O0042752O66446F776E03113O0057696E6466757279546F74656D42752O6603113O0054696D6553696E63654C61737443617374025O00805640031A3O0065487981F89E60584891F19F774C3795EC8E714E7A87FF9F321503063O00EB122117E59E030B3O00466572616C537069726974030A3O0049734361737461626C6503183O0056BFD3BA5C85D2AB59A8C8AF10AAD3BE53B5CCB951AE81ED03043O00DB30DAA1026O00F03F03093O00442O6F6D57696E6473030E3O0049735370652O6C496E52616E676503163O00E07E7344E458E9EA756F09CB5DE5E77E714BDA5BA0BC03073O008084111C29BB2F03093O0053756E646572696E6703093O004973496E52616E6765026O00144003163O001227083E58133B083D1D11200339520C30072E1D506203053O003D6152665A027O0040030B3O0053746F726D737472696B6503183O00BF3AA459CA440A1BA525AE0BD7451B0AA323A94AD3174F5B03083O0069CC4ECB2BA7377E00AA3O0012ED3O00013O0026E23O004300010001000414012O004300012O009600015O0020BE0001000100020020C70001000100032O00800001000200020006092O01002500013O000414012O002500012O0096000100013O0020070001000100044O00035O00202O0003000300054O000400016O00010004000200062O0001001A00010001000414012O001A00012O009600015O0020BE0001000100020020C70001000100062O0080000100020002000EB70007002500010001000414012O002500012O0096000100023O0006092O01002500013O000414012O002500012O0096000100034O009600025O0020BE0002000200022O00800001000200020006092O01002500013O000414012O002500012O0096000100043O0012ED000200083O0012ED000300094O0010000100034O002000016O009600015O0020BE00010001000A0020C700010001000B2O00800001000200020006092O01004200013O000414012O004200012O0096000100053O0006092O01004200013O000414012O004200012O0096000100063O0006092O01003400013O000414012O003400012O0096000100073O0006A80001003700010001000414012O003700012O0096000100063O0006A80001004200010001000414012O004200012O0096000100034O009600025O0020BE00020002000A2O00800001000200020006092O01004200013O000414012O004200012O0096000100043O0012ED0002000C3O0012ED0003000D4O0010000100034O002000015O0012ED3O000E3O0026E23O008B0001000E000414012O008B00012O009600015O0020BE00010001000F0020C700010001000B2O00800001000200020006092O01006800013O000414012O006800012O0096000100083O0006092O01006800013O000414012O006800012O0096000100093O0006092O01005400013O000414012O005400012O0096000100073O0006A80001005700010001000414012O005700012O0096000100093O0006A80001006800010001000414012O006800012O0096000100034O00C900025O00202O00020002000F4O0003000A3O00202O0003000300104O00055O00202O00050005000F4O0003000500024O000300036O00010003000200062O0001006800013O000414012O006800012O0096000100043O0012ED000200113O0012ED000300124O0010000100034O002000016O009600015O0020BE0001000100130020C70001000100032O00800001000200020006092O01008A00013O000414012O008A00012O00960001000B3O0006092O01008A00013O000414012O008A00012O00960001000C3O0006092O01007700013O000414012O007700012O00960001000D3O0006A80001007A00010001000414012O007A00012O00960001000C3O0006A80001008A00010001000414012O008A00012O0096000100034O00F200025O00202O0002000200134O0003000A3O00202O00030003001400122O000500156O0003000500024O000300036O00010003000200062O0001008A00013O000414012O008A00012O0096000100043O0012ED000200163O0012ED000300174O0010000100034O002000015O0012ED3O00183O0026E23O000100010018000414012O000100012O009600015O0020BE0001000100190020C70001000100032O00800001000200020006092O0100A900013O000414012O00A900012O00960001000E3O0006092O0100A900013O000414012O00A900012O0096000100034O00C900025O00202O0002000200194O0003000A3O00202O0003000300104O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100A900013O000414012O00A900012O0096000100043O0012A00002001A3O00122O0003001B6O000100036O00015O00044O00A90001000414012O000100012O00C43O00017O008D3O00028O00026O001440030A3O0046726F737453686F636B03073O004973526561647903063O0042752O665570030D3O004861696C73746F726D42752O66030E3O0049735370652O6C496E52616E676503153O00A3B82C0D073BD459AAA9285E000DC956A9AF634C4203083O0031C5CA437E7364A703083O004C6176614C61736803133O003B5AC928BF5A5F24539F3A8958593B5E9F7BD203073O003E573BBF49E03603093O00496365537472696B65030E3O004973496E4D656C2O6552616E676503143O00EE01FFF6F416E8C0EC07BADAEE0CFDC5E242A89A03043O00A987629A030A3O0057696E64737472696B6503143O00DC7E2A50EE27DAC27C2114EE3AC6CC7B2114AF6703073O00A8AB1744349D53026O001840026O002040030A3O00466C616D6553686F636B03153O00F27DF4A0201294FC7EF6A6653E8EFA76F9A8657ED403073O00E7941195CD454D030E3O00436861696E4C696768746E696E6703093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O6603143O00437261636B6C696E675468756E64657242752O6603103O00456C656D656E74616C53706972697473030B3O004973417661696C61626C6503193O0083AFC6F259C08CAEC0F343F189A9C0BB44F68EA0CBFE17ACD403063O009FE0C7A79B37030D3O004C696768746E696E67426F6C7403083O0042752O66446F776E03123O005072696D6F726469616C5761766542752O6603183O00FBFA3BDAE3FD35DCF0CC3EDDFBE77CC1FEFD3BDEF2B36F8703043O00B297935C030D3O0057696E6466757279546F74656D03113O0057696E6466757279546F74656D42752O6603113O0054696D6553696E63654C61737443617374025O0080564003183O009BF4423614596895C2583D064977CCEE453C15407FCCAE1A03073O001AEC9D2C52722C026O00084003093O004C617661427572737403113O0054686F72696D73496E766F636174696F6E03143O00262FC35A152CC049393A95482320D2572F6E840803043O003B4A4EB503123O00537461746963412O63756D756C6174696F6E03183O0029D85D52A72BD8545D8C27DE564EF336D8545DBF20910B0E03053O00D345B12O3A030E3O0043726173684C696768746E696E6703093O00416C706861576F6C66030F3O00466572616C53706972697442752O6603193O00B4F778E6E1F4BBEC7E2OFDC5BEEB7EB5FAC2B9E275F0A99AE203063O00ABD785199589030E3O005072696D6F726469616C57617665030A3O0049734361737461626C6503193O00F1DA3BF7E022F84BE0C40DEDEE26F902F2C13CFDE335BC13B703083O002281A8529A8F509C026O001040030A3O00446562752O66446F776E03103O00466C616D6553686F636B446562752O6603153O0083BE32064D719A8DBD3000085D808BB53F0E081FDE03073O00E9E5D2536B282E03103O00456C656D656E74616C412O7361756C7403113O00537769726C696E674D61656C7374726F6D03143O00C84137E916D5503BDD0081513BD802CD4772875D03053O0065A12252B6030D3O004C617368696E67466C616D657303133O00E40C4FFFE4EE833DE04D4AF7D5E58E2BA85C0003083O004E886D399EBB82E2030D3O00496365537472696B6542752O6603143O00373CFCCE2D2BEBF8353AB9E23731FEFD3B7FABA103043O00915E5F9903183O00EDDF1DD841A5F9C415D971A0FCDB11955DBEF3CA18D00EE603063O00D79DAD74B52E03143O0033B88AFFDF0AA783FDD93EF498FBD432B88EB28803053O00BA55D4EB92030E3O00456C656D656E74616C426C61737403183O00C78D13F33CE04CC38D29FC35EF4BD6C105F737E954C7C14503073O0038A2E1769E598E03093O0053756E646572696E6703073O0048617354696572026O003E40027O004003093O004973496E52616E676503123O004F10CEAB27CA550BC7EF31D15202CCAA628C03063O00B83C65A0CF42026O00F03F030B3O0053746F726D737472696B6503153O00229673AE3C9168AE388979FC228B72BB3D873CEE6403043O00DC51E21C03134O00C08CFFEFD51ADB85BBF9CE1DD28EFEAA954503063O00A773B5E29B8A030B3O004261676F66547269636B7303173O00E023E0637477F9F630EE5F706286F12BE95B777486B07503073O00A68242873C1B1103083O00466972654E6F766103083O00446562752O66557003143O004F766572666C6F77696E674D61656C7374726F6D03133O004243DC700F4A45D874705743C0723C410A9C2D03053O0050242AAE15026O001C40030E3O00417363656E64616E636542752O66030B3O0042752O6652656D61696E73030F3O00432O6F6C646F776E52656D61696E732O033O0047434403173O00421930725A1E3E74492F357542047769471E30764B506203043O001A2E7057030D3O00442O6F6D57696E647342752O6603143O00442O65706C79522O6F746564456C656D656E7473030A3O0053746F726D626C61737403103O0053746F726D6272696E67657242752O6603143O00AA37A466B2AC51A6B028AE34ACB64BB3B526EB2203083O00D4D943CB142ODF25030B3O00486F7448616E6442752O6603123O00B68CBED38581A9C1B2CDBBDBB48AA4D7FADA03043O00B2DAEDC803173O00A1BCE8D4B0A0F4C989A1E9C4B3B8A6C3BFBBE1DCB3F5BE03043O00B0D6D58603073O004368617267657303183O00F1A1B3D9AD584DF5A189D6A4574AE0EDA5DDA65155F1EDEF03073O003994CDD6B4C83603163O0053706C696E7465726564456C656D656E747342752O66026O00284003183O001EF4323C621CF43B334910F239203601F43B337A17BD2O6403053O0016729D555403193O00C7C312CD53C9A4CDCC1BD053FFA6C38B00CD53F1A4C18B429503073O00C8A4AB73A43D9603193O00BBF8064886B0E002492OBCF8025697FEE70A4B84B2F14314D103053O00E3DE94632503093O004861696C73746F726D03183O003F5B55FEED3D5B5CF1C6315D5EE2B9205B5CF1F5361200AF03053O0099532O329603153O005B647C0F67945E5579701733B84453717F1933F81D03073O002D3D16137C13CB03193O00C2000CE60A4FB5C81505E10C79B7C6521EFC0C77B5C4525EA403073O00D9A1726D95621003133O0014292A79837A1D36393CAF7D1C273479FC274003063O00147240581CDC0080052O0012ED3O00013O0026E23O007200010002000414012O007200012O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O01002400013O000414012O002400012O0096000100013O0006092O01002400013O000414012O002400012O0096000100023O0020900001000100054O00035O00202O0003000300064O00010003000200062O0001002400013O000414012O002400012O0096000100034O00C900025O00202O0002000200034O000300043O00202O0003000300074O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001002400013O000414012O002400012O0096000100053O0012ED000200083O0012ED000300094O0010000100034O002000016O009600015O0020BE00010001000A0020C70001000100042O00800001000200020006092O01003E00013O000414012O003E00012O0096000100063O0006092O01003E00013O000414012O003E00012O0096000100034O00C900025O00202O00020002000A4O000300043O00202O0003000300074O00055O00202O00050005000A4O0003000500024O000300036O00010003000200062O0001003E00013O000414012O003E00012O0096000100053O0012ED0002000B3O0012ED0003000C4O0010000100034O002000016O009600015O0020BE00010001000D0020C70001000100042O00800001000200020006092O01005700013O000414012O005700012O0096000100073O0006092O01005700013O000414012O005700012O0096000100034O00F200025O00202O00020002000D4O000300043O00202O00030003000E00122O000500026O0003000500024O000300036O00010003000200062O0001005700013O000414012O005700012O0096000100053O0012ED0002000F3O0012ED000300104O0010000100034O002000016O009600015O0020BE0001000100110020C70001000100042O00800001000200020006092O01007100013O000414012O007100012O0096000100083O0006092O01007100013O000414012O007100012O0096000100034O00C900025O00202O0002000200114O000300043O00202O0003000300074O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001007100013O000414012O007100012O0096000100053O0012ED000200123O0012ED000300134O0010000100034O002000015O0012ED3O00143O0026E23O00072O010015000414012O00072O012O009600015O0020BE0001000100160020C70001000100042O00800001000200020006092O01008E00013O000414012O008E00012O0096000100093O0006092O01008E00013O000414012O008E00012O0096000100034O00C900025O00202O0002000200164O000300043O00202O0003000300074O00055O00202O0005000500164O0003000500024O000300036O00010003000200062O0001008E00013O000414012O008E00012O0096000100053O0012ED000200173O0012ED000300184O0010000100034O002000016O009600015O0020BE0001000100190020C70001000100042O00800001000200020006092O0100BC00013O000414012O00BC00012O00960001000A3O0006092O0100BC00013O000414012O00BC00012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O000200BC00010001000414012O00BC00012O0096000100023O0020900001000100054O00035O00202O00030003001C4O00010003000200062O000100BC00013O000414012O00BC00012O009600015O0020BE00010001001D0020C700010001001E2O00800001000200020006092O0100BC00013O000414012O00BC00012O0096000100034O00C900025O00202O0002000200194O000300043O00202O0003000300074O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100BC00013O000414012O00BC00012O0096000100053O0012ED0002001F3O0012ED000300204O0010000100034O002000016O009600015O0020BE0001000100210020C70001000100042O00800001000200020006092O0100E400013O000414012O00E400012O00960001000B3O0006092O0100E400013O000414012O00E400012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O000200E400010001000414012O00E400012O0096000100023O0020900001000100224O00035O00202O0003000300234O00010003000200062O000100E400013O000414012O00E400012O0096000100034O00C900025O00202O0002000200214O000300043O00202O0003000300074O00055O00202O0005000500214O0003000500024O000300036O00010003000200062O000100E400013O000414012O00E400012O0096000100053O0012ED000200243O0012ED000300254O0010000100034O002000016O009600015O0020BE0001000100260020C70001000100042O00800001000200020006092O01007F05013O000414012O007F05012O00960001000C3O0006092O01007F05013O000414012O007F05012O0096000100023O0020070001000100224O00035O00202O0003000300274O000400016O00010004000200062O000100FB00010001000414012O00FB00012O009600015O0020BE0001000100260020C70001000100282O0080000100020002000EB70029007F05010001000414012O007F05012O0096000100034O009600025O0020BE0002000200262O00800001000200020006092O01007F05013O000414012O007F05012O0096000100053O0012A00002002A3O00122O0003002B6O000100036O00015O00044O007F05010026E23O00B72O01002C000414012O00B72O012O009600015O0020BE00010001002D0020C70001000100042O00800001000200020006092O0100302O013O000414012O00302O012O00960001000D3O0006092O0100302O013O000414012O00302O012O009600015O0020BE00010001002E0020C700010001001E2O00800001000200020006A8000100302O010001000414012O00302O012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O000200302O010001000414012O00302O012O0096000100034O00C900025O00202O00020002002D4O000300043O00202O0003000300074O00055O00202O00050005002D4O0003000500024O000300036O00010003000200062O000100302O013O000414012O00302O012O0096000100053O0012ED0002002F3O0012ED000300304O0010000100034O002000016O009600015O0020BE0001000100210020C70001000100042O00800001000200020006092O0100652O013O000414012O00652O012O00960001000B3O0006092O0100652O013O000414012O00652O012O0096000100023O00201600010001001A4O00035O00202O00030003001B4O000100030002000E2O0015004D2O010001000414012O004D2O012O009600015O0020BE0001000100310020C700010001001E2O00800001000200020006092O0100652O013O000414012O00652O012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O000200652O010001000414012O00652O012O0096000100023O0020900001000100224O00035O00202O0003000300234O00010003000200062O000100652O013O000414012O00652O012O0096000100034O00C900025O00202O0002000200214O000300043O00202O0003000300074O00055O00202O0005000500214O0003000500024O000300036O00010003000200062O000100652O013O000414012O00652O012O0096000100053O0012ED000200323O0012ED000300334O0010000100034O002000016O009600015O0020BE0001000100340020C70001000100042O00800001000200020006092O01008F2O013O000414012O008F2O012O00960001000E3O0006092O01008F2O013O000414012O008F2O012O009600015O0020BE0001000100350020C700010001001E2O00800001000200020006092O01008F2O013O000414012O008F2O012O0096000100023O0020900001000100054O00035O00202O0003000300364O00010003000200062O0001008F2O013O000414012O008F2O012O00960001000F4O00CE0001000100020026E20001008F2O010001000414012O008F2O012O0096000100034O00F200025O00202O0002000200344O000300043O00202O00030003000E00122O000500026O0003000500024O000300036O00010003000200062O0001008F2O013O000414012O008F2O012O0096000100053O0012ED000200373O0012ED000300384O0010000100034O002000016O009600015O0020BE0001000100390020C700010001003A2O00800001000200020006092O0100B62O013O000414012O00B62O012O0096000100103O0006092O0100B62O013O000414012O00B62O012O0096000100113O0006092O01009E2O013O000414012O009E2O012O0096000100123O0006A8000100A12O010001000414012O00A12O012O0096000100113O0006A8000100B62O010001000414012O00B62O012O0096000100134O0096000200143O0006FE000100B62O010002000414012O00B62O012O0096000100034O00C900025O00202O0002000200394O000300043O00202O0003000300074O00055O00202O0005000500394O0003000500024O000300036O00010003000200062O000100B62O013O000414012O00B62O012O0096000100053O0012ED0002003B3O0012ED0003003C4O0010000100034O002000015O0012ED3O003D3O0026E23O00400201003D000414012O004002012O009600015O0020BE0001000100160020C70001000100042O00800001000200020006092O0100DA2O013O000414012O00DA2O012O0096000100093O0006092O0100DA2O013O000414012O00DA2O012O0096000100043O00209000010001003E4O00035O00202O00030003003F4O00010003000200062O000100DA2O013O000414012O00DA2O012O0096000100034O00C900025O00202O0002000200164O000300043O00202O0003000300074O00055O00202O0005000500164O0003000500024O000300036O00010003000200062O000100DA2O013O000414012O00DA2O012O0096000100053O0012ED000200403O0012ED000300414O0010000100034O002000016O009600015O0020BE00010001000D0020C70001000100042O00800001000200020006092O0100FF2O013O000414012O00FF2O012O0096000100073O0006092O0100FF2O013O000414012O00FF2O012O009600015O0020BE0001000100420020C700010001001E2O00800001000200020006092O0100FF2O013O000414012O00FF2O012O009600015O0020BE0001000100430020C700010001001E2O00800001000200020006092O0100FF2O013O000414012O00FF2O012O0096000100034O00F200025O00202O00020002000D4O000300043O00202O00030003000E00122O000500026O0003000500024O000300036O00010003000200062O000100FF2O013O000414012O00FF2O012O0096000100053O0012ED000200443O0012ED000300454O0010000100034O002000016O009600015O0020BE00010001000A0020C70001000100042O00800001000200020006092O01001F02013O000414012O001F02012O0096000100063O0006092O01001F02013O000414012O001F02012O009600015O0020BE0001000100460020C700010001001E2O00800001000200020006092O01001F02013O000414012O001F02012O0096000100034O00C900025O00202O00020002000A4O000300043O00202O0003000300074O00055O00202O00050005000A4O0003000500024O000300036O00010003000200062O0001001F02013O000414012O001F02012O0096000100053O0012ED000200473O0012ED000300484O0010000100034O002000016O009600015O0020BE00010001000D0020C70001000100042O00800001000200020006092O01003F02013O000414012O003F02012O0096000100073O0006092O01003F02013O000414012O003F02012O0096000100023O0020900001000100224O00035O00202O0003000300494O00010003000200062O0001003F02013O000414012O003F02012O0096000100034O00F200025O00202O00020002000D4O000300043O00202O00030003000E00122O000500026O0003000500024O000300036O00010003000200062O0001003F02013O000414012O003F02012O0096000100053O0012ED0002004A3O0012ED0003004B4O0010000100034O002000015O0012ED3O00023O0026E23O00F902010001000414012O00F902012O009600015O0020BE0001000100390020C700010001003A2O00800001000200020006092O01007602013O000414012O007602012O0096000100103O0006092O01007602013O000414012O007602012O0096000100113O0006092O01005102013O000414012O005102012O0096000100123O0006A80001005402010001000414012O005402012O0096000100113O0006A80001007602010001000414012O007602012O0096000100134O0096000200143O0006FE0001007602010002000414012O007602012O0096000100043O00209000010001003E4O00035O00202O00030003003F4O00010003000200062O0001007602013O000414012O007602012O009600015O0020BE0001000100460020C700010001001E2O00800001000200020006092O01007602013O000414012O007602012O0096000100034O00C900025O00202O0002000200394O000300043O00202O0003000300074O00055O00202O0005000500394O0003000500024O000300036O00010003000200062O0001007602013O000414012O007602012O0096000100053O0012ED0002004C3O0012ED0003004D4O0010000100034O002000016O009600015O0020BE0001000100160020C70001000100042O00800001000200020006092O01009D02013O000414012O009D02012O0096000100093O0006092O01009D02013O000414012O009D02012O0096000100043O00209000010001003E4O00035O00202O00030003003F4O00010003000200062O0001009D02013O000414012O009D02012O009600015O0020BE0001000100460020C700010001001E2O00800001000200020006092O01009D02013O000414012O009D02012O0096000100034O00C900025O00202O0002000200164O000300043O00202O0003000300074O00055O00202O0005000500164O0003000500024O000300036O00010003000200062O0001009D02013O000414012O009D02012O0096000100053O0012ED0002004E3O0012ED0003004F4O0010000100034O002000016O009600015O0020BE0001000100500020C70001000100042O00800001000200020006092O0100CB02013O000414012O00CB02012O0096000100153O0006092O0100CB02013O000414012O00CB02012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O000200CB02010001000414012O00CB02012O009600015O0020BE00010001001D0020C700010001001E2O00800001000200020006092O0100CB02013O000414012O00CB02012O0096000100023O0020900001000100054O00035O00202O0003000300364O00010003000200062O000100CB02013O000414012O00CB02012O0096000100034O00C900025O00202O0002000200504O000300043O00202O0003000300074O00055O00202O0005000500504O0003000500024O000300036O00010003000200062O000100CB02013O000414012O00CB02012O0096000100053O0012ED000200513O0012ED000300524O0010000100034O002000016O009600015O0020BE0001000100530020C70001000100042O00800001000200020006092O0100F802013O000414012O00F802012O0096000100163O0006092O0100F802013O000414012O00F802012O0096000100173O0006092O0100DA02013O000414012O00DA02012O0096000100123O0006A8000100DD02010001000414012O00DD02012O0096000100173O0006A8000100F802010001000414012O00F802012O0096000100134O0096000200143O0006FE000100F802010002000414012O00F802012O0096000100023O00206300010001005400122O000300553O00122O000400566O00010004000200062O000100F802013O000414012O00F802012O0096000100034O00F200025O00202O0002000200534O000300043O00202O00030003005700122O000500026O0003000500024O000300036O00010003000200062O000100F802013O000414012O00F802012O0096000100053O0012ED000200583O0012ED000300594O0010000100034O002000015O0012ED3O005A3O0026E23O008903010014000414012O008903012O009600015O0020BE00010001005B0020C70001000100042O00800001000200020006092O01001503013O000414012O001503012O0096000100183O0006092O01001503013O000414012O001503012O0096000100034O00C900025O00202O00020002005B4O000300043O00202O0003000300074O00055O00202O00050005005B4O0003000500024O000300036O00010003000200062O0001001503013O000414012O001503012O0096000100053O0012ED0002005C3O0012ED0003005D4O0010000100034O002000016O009600015O0020BE0001000100530020C70001000100042O00800001000200020006092O01003B03013O000414012O003B03012O0096000100163O0006092O01003B03013O000414012O003B03012O0096000100173O0006092O01002403013O000414012O002403012O0096000100123O0006A80001002703010001000414012O002703012O0096000100173O0006A80001003B03010001000414012O003B03012O0096000100134O0096000200143O0006FE0001003B03010002000414012O003B03012O0096000100034O00F200025O00202O0002000200534O000300043O00202O00030003005700122O000500026O0003000500024O000300036O00010003000200062O0001003B03013O000414012O003B03012O0096000100053O0012ED0002005E3O0012ED0003005F4O0010000100034O002000016O009600015O0020BE0001000100600020C70001000100042O00800001000200020006092O01005803013O000414012O005803012O0096000100193O0006092O01005803013O000414012O005803012O00960001001A3O0006092O01004A03013O000414012O004A03012O00960001001B3O0006A80001004D03010001000414012O004D03012O00960001001A3O0006A80001005803010001000414012O005803012O0096000100034O009600025O0020BE0002000200602O00800001000200020006092O01005803013O000414012O005803012O0096000100053O0012ED000200613O0012ED000300624O0010000100034O002000016O009600015O0020BE0001000100630020C70001000100042O00800001000200020006092O01008803013O000414012O008803012O00960001001C3O0006092O01008803013O000414012O008803012O009600015O0020BE0001000100430020C700010001001E2O00800001000200020006092O01008803013O000414012O008803012O0096000100043O0020900001000100644O00035O00202O00030003003F4O00010003000200062O0001008803013O000414012O008803012O0096000100023O0020FF00010001001A4O00035O00202O00030003001B4O0001000300024O0002001D6O00035O00202O00030003006500202O00030003001E4O000300046O00023O000200102O00020002000200102O00020002000200062O0001008803010002000414012O008803012O0096000100034O009600025O0020BE0002000200632O00800001000200020006092O01008803013O000414012O008803012O0096000100053O0012ED000200663O0012ED000300674O0010000100034O002000015O0012ED3O00683O000E03015A004604013O000414012O004604012O009600015O0020BE0001000100210020C70001000100042O00800001000200020006092O0100CE03013O000414012O00CE03012O00960001000B3O0006092O0100CE03013O000414012O00CE03012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O000200CE03010001000414012O00CE03012O0096000100023O0020900001000100224O00035O00202O00030003001C4O00010003000200062O000100CE03013O000414012O00CE03012O0096000100023O0020900001000100054O00035O00202O0003000300694O00010003000200062O000100CE03013O000414012O00CE03012O00960001001E4O009600025O0020BE0002000200190006F9000100CE03010002000414012O00CE03012O0096000100023O0020A600010001006A4O00035O00202O0003000300694O0001000300024O00025O00202O00020002001900202O00020002006B4O0002000200024O000300023O00202O00030003006C2O00800003000200022O00210002000200030006FE000200CE03010001000414012O00CE03012O0096000100034O00C900025O00202O0002000200214O000300043O00202O0003000300074O00055O00202O0005000500214O0003000500024O000300036O00010003000200062O000100CE03013O000414012O00CE03012O0096000100053O0012ED0002006D3O0012ED0003006E4O0010000100034O002000016O009600015O0020BE00010001005B0020C70001000100042O00800001000200020006092O01000204013O000414012O000204012O0096000100183O0006092O01000204013O000414012O000204012O0096000100023O0020F10001000100054O00035O00202O00030003006F4O00010003000200062O000100F103010001000414012O00F103012O009600015O0020BE0001000100700020C700010001001E2O00800001000200020006A8000100F103010001000414012O00F103012O009600015O0020BE0001000100710020C700010001001E2O00800001000200020006092O01000204013O000414012O000204012O0096000100023O0020900001000100054O00035O00202O0003000300724O00010003000200062O0001000204013O000414012O000204012O0096000100034O00C900025O00202O00020002005B4O000300043O00202O0003000300074O00055O00202O00050005005B4O0003000500024O000300036O00010003000200062O0001000204013O000414012O000204012O0096000100053O0012ED000200733O0012ED000300744O0010000100034O002000016O009600015O0020BE00010001000A0020C70001000100042O00800001000200020006092O01002304013O000414012O002304012O0096000100063O0006092O01002304013O000414012O002304012O0096000100023O0020900001000100054O00035O00202O0003000300754O00010003000200062O0001002304013O000414012O002304012O0096000100034O00C900025O00202O00020002000A4O000300043O00202O0003000300074O00055O00202O00050005000A4O0003000500024O000300036O00010003000200062O0001002304013O000414012O002304012O0096000100053O0012ED000200763O0012ED000300774O0010000100034O002000016O009600015O0020BE0001000100260020C70001000100042O00800001000200020006092O01004504013O000414012O004504012O00960001000C3O0006092O01004504013O000414012O004504012O0096000100023O0020070001000100224O00035O00202O0003000300274O000400016O00010004000200062O0001003A04010001000414012O003A04012O009600015O0020BE0001000100260020C70001000100282O0080000100020002000EB70029004504010001000414012O004504012O0096000100034O009600025O0020BE0002000200262O00800001000200020006092O01004504013O000414012O004504012O0096000100053O0012ED000200783O0012ED000300794O0010000100034O002000015O0012ED3O00563O0026E23O00FF04010056000414012O00FF04012O009600015O0020BE0001000100500020C70001000100042O00800001000200020006092O01007004013O000414012O007004012O0096000100153O0006092O01007004013O000414012O007004012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O0002007004010001000414012O007004012O009600015O0020E600010001005000202O00010001007A4O0001000200024O0002001F3O00062O0001007004010002000414012O007004012O0096000100034O00C900025O00202O0002000200504O000300043O00202O0003000300074O00055O00202O0005000500504O0003000500024O000300036O00010003000200062O0001007004013O000414012O007004012O0096000100053O0012ED0002007B3O0012ED0003007C4O0010000100034O002000016O009600015O0020BE0001000100210020C70001000100042O00800001000200020006092O0100A204013O000414012O00A204012O00960001000B3O0006092O0100A204013O000414012O00A204012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O001500A204010001000414012O00A204012O0096000100023O0020900001000100054O00035O00202O0003000300234O00010003000200062O000100A204013O000414012O00A204012O0096000100023O0020F10001000100224O00035O00202O00030003007D4O00010003000200062O0001009104010001000414012O009104012O0096000100143O002642000100A20401007E000414012O00A204012O0096000100034O00C900025O00202O0002000200214O000300043O00202O0003000300074O00055O00202O0005000500214O0003000500024O000300036O00010003000200062O000100A204013O000414012O00A204012O0096000100053O0012ED0002007F3O0012ED000300804O0010000100034O002000016O009600015O0020BE0001000100190020C70001000100042O00800001000200020006092O0100D004013O000414012O00D004012O00960001000A3O0006092O0100D004013O000414012O00D004012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O001500D004010001000414012O00D004012O0096000100023O0020900001000100054O00035O00202O00030003001C4O00010003000200062O000100D004013O000414012O00D004012O009600015O0020BE00010001001D0020C700010001001E2O00800001000200020006092O0100D004013O000414012O00D004012O0096000100034O00C900025O00202O0002000200194O000300043O00202O0003000300074O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100D004013O000414012O00D004012O0096000100053O0012ED000200813O0012ED000300824O0010000100034O002000016O009600015O0020BE0001000100500020C70001000100042O00800001000200020006092O0100FE04013O000414012O00FE04012O0096000100153O0006092O0100FE04013O000414012O00FE04012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O001500FE04010001000414012O00FE04012O0096000100023O0020F10001000100054O00035O00202O0003000300364O00010003000200062O000100ED04010001000414012O00ED04012O009600015O0020BE00010001001D0020C700010001001E2O00800001000200020006A8000100FE04010001000414012O00FE04012O0096000100034O00C900025O00202O0002000200504O000300043O00202O0003000300074O00055O00202O0005000500504O0003000500024O000300036O00010003000200062O000100FE04013O000414012O00FE04012O0096000100053O0012ED000200833O0012ED000300844O0010000100034O002000015O0012ED3O002C3O0026E23O000100010068000414012O000100012O009600015O0020BE0001000100210020C70001000100042O00800001000200020006092O01002F05013O000414012O002F05012O00960001000B3O0006092O01002F05013O000414012O002F05012O009600015O0020BE0001000100850020C700010001001E2O00800001000200020006092O01002F05013O000414012O002F05012O0096000100023O00207E00010001001A4O00035O00202O00030003001B4O000100030002000E2O0002002F05010001000414012O002F05012O0096000100023O0020900001000100224O00035O00202O0003000300234O00010003000200062O0001002F05013O000414012O002F05012O0096000100034O00C900025O00202O0002000200214O000300043O00202O0003000300074O00055O00202O0005000500214O0003000500024O000300036O00010003000200062O0001002F05013O000414012O002F05012O0096000100053O0012ED000200863O0012ED000300874O0010000100034O002000016O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O01004905013O000414012O004905012O0096000100013O0006092O01004905013O000414012O004905012O0096000100034O00C900025O00202O0002000200034O000300043O00202O0003000300074O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001004905013O000414012O004905012O0096000100053O0012ED000200883O0012ED000300894O0010000100034O002000016O009600015O0020BE0001000100340020C70001000100042O00800001000200020006092O01006205013O000414012O006205012O00960001000E3O0006092O01006205013O000414012O006205012O0096000100034O00F200025O00202O0002000200344O000300043O00202O00030003000E00122O000500026O0003000500024O000300036O00010003000200062O0001006205013O000414012O006205012O0096000100053O0012ED0002008A3O0012ED0003008B4O0010000100034O002000016O009600015O0020BE0001000100630020C70001000100042O00800001000200020006092O01007D05013O000414012O007D05012O00960001001C3O0006092O01007D05013O000414012O007D05012O0096000100043O0020900001000100644O00035O00202O00030003003F4O00010003000200062O0001007D05013O000414012O007D05012O0096000100034O009600025O0020BE0002000200632O00800001000200020006092O01007D05013O000414012O007D05012O0096000100053O0012ED0002008C3O0012ED0003008D4O0010000100034O002000015O0012ED3O00153O000414012O000100012O00C43O00017O00823O00028O00027O004003093O0053756E646572696E6703073O004973526561647903063O0042752O665570030D3O00442O6F6D57696E647342752O6603073O0048617354696572026O003E4003093O004973496E52616E6765026O001440030F3O002214DCB0FDC2B43F0692B5F7D5FD6803073O00DD5161B2D498B003083O00466972654E6F766103103O00466C616D6553686F636B446562752O66030F3O0041757261416374697665436F756E74026O001840026O00104003103O00CBEE0FFE25C3E80BFA5ACCE818BB4B9D03053O007AAD877D9B03083O004C6176614C617368030D3O004C617368696E67466C616D6573030B3O004973417661696C61626C6503093O00436173744379636C65030E3O0049735370652O6C496E52616E676503103O0088C016B8003DC997C940B8303488D59003073O00A8E4A160D95F51030D3O004D6F6C74656E412O7361756C7403083O00446562752O665570030D3O00417368656E436174616C79737403093O0042752O66537461636B03113O00417368656E436174616C79737442752O6603103O00D7D0385D105BDAC2261C2E58DE917F0E03063O0037BBB14E3C4F026O000840030E3O0043726173684C696768746E696E67030E3O004973496E4D656C2O6552616E676503163O002EDC5EF84EF08C24C957FF48C68E2A8E5EE4438FD27803073O00E04DAE3F8B26AF03103O0082484A2BBB4F57388501592181010A7803043O004EE42138030E3O00456C656D656E74616C426C61737403103O00456C656D656E74616C5370697269747303073O0043686172676573030F3O00466572616C53706972697442752O6603163O00CB72B70E80C06AB30FBACC72B310918E7FBD06C59C2903053O00E5AE1ED263030E3O00436861696E4C696768746E696E6703133O004D61656C7374726F6D576561706F6E42752O6603163O0018E58758E3023512EA8E45E334371CAD875EE87D6B4303073O00597B8DE6318D5D026O001C4003093O00496365537472696B6503093O004861696C73746F726D03113O00FA72F333035EE178FD09504BFC74B65D4303063O002A9311966C70030A3O0046726F737453686F636B030D3O004861696C73746F726D42752O6603123O0009B4226CF3D71CAE227CECA80EA9283FB6BC03063O00886FC64D1F8703103O00111CA952B8F61EA70549A659B8A446FC03083O00C96269C736DD8477030A3O00466C616D6553686F636B030A3O00446562752O66446F776E03123O00BF00822C070ABFB103802A4234A3BC4CD27703073O00CCD96CE3416255026O00F03F030E3O005072696D6F726469616C5761766503113O0058CFF4E829FF4DCBFAE627805FCCF0A57903063O00A03EA395854C03153O00D3AC0822C6D8B40C23FCD4AC0C3CD796A1022A838003053O00A3B6C06D4F03143O004F766572666C6F77696E674D61656C7374726F6D03153O00372E01C9FB0B2A09C7FD202809CEF274270FC5B56303053O0095544660A003083O0042752O66446F776E03123O0043726173684C696768746E696E6742752O6603093O00416C706861576F6C6603153O003B140CFE303901E43F0E19E331080AAD390908AD6003043O008D58666D030D3O0057696E6466757279546F74656D03113O0057696E6466757279546F74656D42752O6603113O0054696D6553696E63654C61737443617374025O0080564003153O00A45AC4741C2847D88C47C5641F3015C0BC568A224303083O00A1D333AA107A5D3503123O00FDA2B325FE91A120F4ADB968FAA1B768A8FE03043O00489BCED203123O0040685B1D2779695C01304D3A55013606290503053O0053261A346E030E3O004372617368696E6753746F726D73030B3O00556E72756C7957696E6473026O002440026O002E4003153O005B05265550282B4F5F1F334851192006591822060903043O0026387747030D3O004C696768746E696E67426F6C74030B3O00446562752O66537461636B03123O005072696D6F726469616C5761766542752O6603163O0053706C696E7465726564456C656D656E747342752O66026O0028402O033O0047434403143O00FFE65FDE3158FAE15FE92759FFFB18D72A53B3BD03063O0036938F38B645030F3O00DA80E948E0DA80EC419FD78EFA098C03053O00BFB6E19F29030A3O0049734361737461626C6503153O003B0021588495C62213246A9C86D42E52295A8EC79603073O00A24B724835EBE7030A3O0057696E64737472696B6503113O009B354AE640169E354FE71303833904B00203063O0062EC5C248233030B3O0053746F726D737472696B6503123O00B70D03A848BBA122AD1209FA44A7B070F64B03083O0050C4796CDA25C8D503113O0009700740581A980978073F4A018F40215103073O00EA6013621F2B6E03103O000A1E44C6937E8A151712C6A377CB544B03073O00EB667F32A7CC1203113O00446562752O665265667265736861626C6503123O0056ADF42E411143A9FA204F6E51AEF063157903063O004E30C195432403103O003617921D7E3E1196190131118558106803053O0021507EE07803143O00442O65706C79522O6F746564456C656D656E747303143O00436F6E76657267696E6753746F726D7342752O6603123O00FFBC0CD651FFBC11CD57E9E802CB59ACF95A03053O003C8CC863A403143O00434C43726173684C696768746E696E6742752O6603163O0084E60535AAB8F80D21AA93FA0D28A5C7F50B23E2D5A403053O00C2E7946446001A052O0012ED3O00013O0026E23O00C300010002000414012O00C300012O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O01003700013O000414012O003700012O0096000100013O0006092O01003700013O000414012O003700012O0096000100023O0006092O01001200013O000414012O001200012O0096000100033O0006A80001001500010001000414012O001500012O0096000100023O0006A80001003700010001000414012O003700012O0096000100044O0096000200053O0006FE0001003700010002000414012O003700012O0096000100063O0020F10001000100054O00035O00202O0003000300064O00010003000200062O0001002700010001000414012O002700012O0096000100063O00206300010001000700122O000300083O00122O000400026O00010004000200062O0001003700013O000414012O003700012O0096000100074O00F200025O00202O0002000200034O000300083O00202O00030003000900122O0005000A6O0003000500024O000300036O00010003000200062O0001003700013O000414012O003700012O0096000100093O0012ED0002000B3O0012ED0003000C4O0010000100034O002000016O009600015O0020BE00010001000D0020C70001000100042O00800001000200020006092O01005E00013O000414012O005E00012O00960001000A3O0006092O01005E00013O000414012O005E00012O009600015O0020BE00010001000E0020C700010001000F2O0080000100020002000E7C0010005300010001000414012O005300012O009600015O0020BE00010001000E0020C700010001000F2O0080000100020002000E920011005E00010001000414012O005E00012O009600015O0020B900010001000E00202O00010001000F4O0001000200024O0002000B3O00062O0002005E00010001000414012O005E00012O0096000100074O009600025O0020BE00020002000D2O00800001000200020006092O01005E00013O000414012O005E00012O0096000100093O0012ED000200123O0012ED000300134O0010000100034O002000016O009600015O0020BE0001000100140020C70001000100042O00800001000200020006092O01008100013O000414012O008100012O00960001000C3O0006092O01008100013O000414012O008100012O009600015O0020BE0001000100150020C70001000100162O00800001000200020006092O01008100013O000414012O008100012O00960001000D3O00206E0001000100174O00025O00202O0002000200144O0003000E6O0004000F6O000500083O00202O0005000500184O00075O00202O0007000700144O0005000700024O000500056O00010005000200062O0001008100013O000414012O008100012O0096000100093O0012ED000200193O0012ED0003001A4O0010000100034O002000016O009600015O0020BE0001000100140020C70001000100042O00800001000200020006092O0100C200013O000414012O00C200012O00960001000C3O0006092O0100C200013O000414012O00C200012O009600015O0020BE00010001001B0020C70001000100162O00800001000200020006092O0100A400013O000414012O00A400012O0096000100083O00209000010001001C4O00035O00202O00030003000E4O00010003000200062O000100A400013O000414012O00A400012O009600015O00205900010001000E00202O00010001000F4O0001000200024O0002000B3O00062O000100A400010002000414012O00A400012O009600015O0020BE00010001000E0020C700010001000F2O00800001000200020026C5000100B100010010000414012O00B100012O009600015O0020BE00010001001D0020C70001000100162O00800001000200020006092O0100C200013O000414012O00C200012O0096000100063O00208100010001001E4O00035O00202O00030003001F4O00010003000200262O000100C20001000A000414012O00C200012O0096000100074O00C900025O00202O0002000200144O000300083O00202O0003000300184O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O000100C200013O000414012O00C200012O0096000100093O0012ED000200203O0012ED000300214O0010000100034O002000015O0012ED3O00223O0026E23O004E2O010010000414012O004E2O012O009600015O0020BE0001000100230020C70001000100042O00800001000200020006092O0100DE00013O000414012O00DE00012O0096000100103O0006092O0100DE00013O000414012O00DE00012O0096000100074O00F200025O00202O0002000200234O000300083O00202O00030003002400122O0005000A6O0003000500024O000300036O00010003000200062O000100DE00013O000414012O00DE00012O0096000100093O0012ED000200253O0012ED000300264O0010000100034O002000016O009600015O0020BE00010001000D0020C70001000100042O00800001000200020006092O0100F800013O000414012O00F800012O00960001000A3O0006092O0100F800013O000414012O00F800012O009600015O0020BE00010001000E0020C700010001000F2O0080000100020002000E92000200F800010001000414012O00F800012O0096000100074O009600025O0020BE00020002000D2O00800001000200020006092O0100F800013O000414012O00F800012O0096000100093O0012ED000200273O0012ED000300284O0010000100034O002000016O009600015O0020BE0001000100290020C70001000100042O00800001000200020006092O01002C2O013O000414012O002C2O012O0096000100113O0006092O01002C2O013O000414012O002C2O012O009600015O0020BE00010001002A0020C70001000100162O00800001000200020006092O01001B2O013O000414012O001B2O012O009600015O0020BE00010001002A0020C70001000100162O00800001000200020006092O01002C2O013O000414012O002C2O012O009600015O00207F00010001002900202O00010001002B4O0001000200024O000200123O00062O0001001B2O010002000414012O001B2O012O0096000100063O0020900001000100054O00035O00202O00030003002C4O00010003000200062O0001002C2O013O000414012O002C2O012O0096000100074O00C900025O00202O0002000200294O000300083O00202O0003000300184O00055O00202O0005000500294O0003000500024O000300036O00010003000200062O0001002C2O013O000414012O002C2O012O0096000100093O0012ED0002002D3O0012ED0003002E4O0010000100034O002000016O009600015O0020BE00010001002F0020C70001000100042O00800001000200020006092O01004D2O013O000414012O004D2O012O0096000100133O0006092O01004D2O013O000414012O004D2O012O0096000100063O00207E00010001001E4O00035O00202O0003000300304O000100030002000E2O000A004D2O010001000414012O004D2O012O0096000100074O00C900025O00202O00020002002F4O000300083O00202O0003000300184O00055O00202O00050005002F4O0003000500024O000300036O00010003000200062O0001004D2O013O000414012O004D2O012O0096000100093O0012ED000200313O0012ED000300324O0010000100034O002000015O0012ED3O00333O0026E23O00E42O010022000414012O00E42O012O009600015O0020BE0001000100340020C70001000100042O00800001000200020006092O01006F2O013O000414012O006F2O012O0096000100143O0006092O01006F2O013O000414012O006F2O012O009600015O0020BE0001000100350020C70001000100162O00800001000200020006092O01006F2O013O000414012O006F2O012O0096000100074O00F200025O00202O0002000200344O000300083O00202O00030003002400122O0005000A6O0003000500024O000300036O00010003000200062O0001006F2O013O000414012O006F2O012O0096000100093O0012ED000200363O0012ED000300374O0010000100034O002000016O009600015O0020BE0001000100380020C70001000100042O00800001000200020006092O0100962O013O000414012O00962O012O0096000100153O0006092O0100962O013O000414012O00962O012O009600015O0020BE0001000100350020C70001000100162O00800001000200020006092O0100962O013O000414012O00962O012O0096000100063O0020900001000100054O00035O00202O0003000300394O00010003000200062O000100962O013O000414012O00962O012O0096000100074O00C900025O00202O0002000200384O000300083O00202O0003000300184O00055O00202O0005000500384O0003000500024O000300036O00010003000200062O000100962O013O000414012O00962O012O0096000100093O0012ED0002003A3O0012ED0003003B4O0010000100034O002000016O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O0100BC2O013O000414012O00BC2O012O0096000100013O0006092O0100BC2O013O000414012O00BC2O012O0096000100023O0006092O0100A52O013O000414012O00A52O012O0096000100033O0006A8000100A82O010001000414012O00A82O012O0096000100023O0006A8000100BC2O010001000414012O00BC2O012O0096000100044O0096000200053O0006FE000100BC2O010002000414012O00BC2O012O0096000100074O00F200025O00202O0002000200034O000300083O00202O00030003000900122O0005000A6O0003000500024O000300036O00010003000200062O000100BC2O013O000414012O00BC2O012O0096000100093O0012ED0002003C3O0012ED0003003D4O0010000100034O002000016O009600015O0020BE00010001003E0020C70001000100042O00800001000200020006092O0100E32O013O000414012O00E32O012O0096000100163O0006092O0100E32O013O000414012O00E32O012O009600015O0020BE00010001001B0020C70001000100162O00800001000200020006092O0100E32O013O000414012O00E32O012O0096000100083O00209000010001003F4O00035O00202O00030003000E4O00010003000200062O000100E32O013O000414012O00E32O012O0096000100074O00C900025O00202O00020002003E4O000300083O00202O0003000300184O00055O00202O00050005003E4O0003000500024O000300036O00010003000200062O000100E32O013O000414012O00E32O012O0096000100093O0012ED000200403O0012ED000300414O0010000100034O002000015O0012ED3O00113O0026E23O00A902010042000414012O00A902012O009600015O0020BE00010001003E0020C70001000100042O00800001000200020006092O01001302013O000414012O001302012O0096000100163O0006092O01001302013O000414012O001302012O009600015O0020BE0001000100430020C70001000100162O00800001000200020006A8000100FB2O010001000414012O00FB2O012O009600015O0020BE00010001000D0020C70001000100162O00800001000200020006092O01001302013O000414012O001302012O0096000100083O00209000010001003F4O00035O00202O00030003000E4O00010003000200062O0001001302013O000414012O001302012O0096000100074O00C900025O00202O00020002003E4O000300083O00202O0003000300184O00055O00202O00050005003E4O0003000500024O000300036O00010003000200062O0001001302013O000414012O001302012O0096000100093O0012ED000200443O0012ED000300454O0010000100034O002000016O009600015O0020BE0001000100290020C70001000100042O00800001000200020006092O01004702013O000414012O004702012O0096000100113O0006092O01004702013O000414012O004702012O009600015O0020BE00010001002A0020C70001000100162O00800001000200020006092O01003602013O000414012O003602012O009600015O0020BE00010001002A0020C70001000100162O00800001000200020006092O01004702013O000414012O004702012O009600015O00207F00010001002900202O00010001002B4O0001000200024O000200123O00062O0001003602010002000414012O003602012O0096000100063O0020900001000100054O00035O00202O00030003002C4O00010003000200062O0001004702013O000414012O004702012O0096000100074O00C900025O00202O0002000200294O000300083O00202O0003000300184O00055O00202O0005000500294O0003000500024O000300036O00010003000200062O0001004702013O000414012O004702012O0096000100093O0012ED000200463O0012ED000300474O0010000100034O002000016O009600015O0020BE00010001002F0020C70001000100042O00800001000200020006092O01007002013O000414012O007002012O0096000100133O0006092O01007002013O000414012O007002012O0096000100063O00208300010001001E4O00035O00202O0003000300304O0001000300024O000200176O00035O00202O00030003004800202O0003000300164O000300046O00023O000200102O0002000A000200102O0002000A000200062O0001007002010002000414012O007002012O0096000100074O00C900025O00202O00020002002F4O000300083O00202O0003000300184O00055O00202O00050005002F4O0003000500024O000300036O00010003000200062O0001007002013O000414012O007002012O0096000100093O0012ED000200493O0012ED0003004A4O0010000100034O002000016O009600015O0020BE0001000100230020C70001000100042O00800001000200020006092O0100A802013O000414012O00A802012O0096000100103O0006092O0100A802013O000414012O00A802012O0096000100063O0020F10001000100054O00035O00202O0003000300064O00010003000200062O0001009802010001000414012O009802012O0096000100063O0020F100010001004B4O00035O00202O00030003004C4O00010003000200062O0001009802010001000414012O009802012O009600015O0020BE00010001004D0020C70001000100162O00800001000200020006092O0100A802013O000414012O00A802012O0096000100063O0020900001000100054O00035O00202O00030003002C4O00010003000200062O000100A802013O000414012O00A802012O0096000100184O00CE0001000100020026E2000100A802010001000414012O00A802012O0096000100074O00F200025O00202O0002000200234O000300083O00202O00030003002400122O0005000A6O0003000500024O000300036O00010003000200062O000100A802013O000414012O00A802012O0096000100093O0012ED0002004E3O0012ED0003004F4O0010000100034O002000015O0012ED3O00023O0026E23O000F03010033000414012O000F03012O009600015O0020BE0001000100500020C70001000100042O00800001000200020006092O0100CD02013O000414012O00CD02012O0096000100193O0006092O0100CD02013O000414012O00CD02012O0096000100063O00200700010001004B4O00035O00202O0003000300514O000400016O00010004000200062O000100C202010001000414012O00C202012O009600015O0020BE0001000100500020C70001000100522O0080000100020002000EB7005300CD02010001000414012O00CD02012O0096000100074O009600025O0020BE0002000200502O00800001000200020006092O0100CD02013O000414012O00CD02012O0096000100093O0012ED000200543O0012ED000300554O0010000100034O002000016O009600015O0020BE00010001003E0020C70001000100042O00800001000200020006092O0100EE02013O000414012O00EE02012O0096000100163O0006092O0100EE02013O000414012O00EE02012O0096000100083O00209000010001003F4O00035O00202O00030003000E4O00010003000200062O000100EE02013O000414012O00EE02012O0096000100074O00C900025O00202O00020002003E4O000300083O00202O0003000300184O00055O00202O00050005003E4O0003000500024O000300036O00010003000200062O000100EE02013O000414012O00EE02012O0096000100093O0012ED000200563O0012ED000300574O0010000100034O002000016O009600015O0020BE0001000100380020C70001000100042O00800001000200020006092O01001905013O000414012O001905012O0096000100153O0006092O01001905013O000414012O001905012O009600015O0020BE0001000100350020C70001000100162O00800001000200020006A80001001905010001000414012O001905012O0096000100074O00C900025O00202O0002000200384O000300083O00202O0003000300184O00055O00202O0005000500384O0003000500024O000300036O00010003000200062O0001001905013O000414012O001905012O0096000100093O0012A0000200583O00122O000300596O000100036O00015O00044O001905010026E23O00FD03010001000414012O00FD03012O009600015O0020BE0001000100230020C70001000100042O00800001000200020006092O01003C03013O000414012O003C03012O0096000100103O0006092O01003C03013O000414012O003C03012O009600015O0020BE00010001005A0020C70001000100162O00800001000200020006092O01003C03013O000414012O003C03012O009600015O0020BE00010001005B0020C70001000100162O00800001000200020006092O01002903013O000414012O002903012O00960001000B3O000E7C005C002C03010001000414012O002C03012O00960001000B3O000E92005D003C03010001000414012O003C03012O0096000100074O00F200025O00202O0002000200234O000300083O00202O00030003002400122O0005000A6O0003000500024O000300036O00010003000200062O0001003C03013O000414012O003C03012O0096000100093O0012ED0002005E3O0012ED0003005F4O0010000100034O002000016O009600015O0020BE0001000100600020C70001000100042O00800001000200020006092O01008B03013O000414012O008B03012O00960001001A3O0006092O01008B03013O000414012O008B03012O0096000100083O00200E0001000100614O00035O00202O00030003000E4O0001000300024O0002000B3O00062O0002000800010001000414012O005403012O0096000100083O00207E0001000100614O00035O00202O00030003000E4O000100030002000E2O0010008B03010001000414012O008B03012O0096000100063O0020900001000100054O00035O00202O0003000300624O00010003000200062O0001008B03013O000414012O008B03012O0096000100063O00208300010001001E4O00035O00202O0003000300304O0001000300024O000200176O00035O00202O00030003004800202O0003000300164O000300046O00023O000200102O0002000A000200102O0002000A000200062O0001008B03010002000414012O008B03012O0096000100063O0020F100010001004B4O00035O00202O0003000300634O00010003000200062O0001007A03010001000414012O007A03012O0096000100053O00260A0001007A03010064000414012O007A03012O0096000100044O0096000200063O0020C70002000200652O00800002000200020006010001008B03010002000414012O008B03012O0096000100074O00C900025O00202O0002000200604O000300083O00202O0003000300184O00055O00202O0005000500604O0003000500024O000300036O00010003000200062O0001008B03013O000414012O008B03012O0096000100093O0012ED000200663O0012ED000300674O0010000100034O002000016O009600015O0020BE0001000100140020C70001000100042O00800001000200020006092O0100CB03013O000414012O00CB03012O00960001000C3O0006092O0100CB03013O000414012O00CB03012O009600015O0020BE00010001001B0020C70001000100162O00800001000200020006092O0100CB03013O000414012O00CB03012O009600015O0020BE0001000100430020C70001000100162O00800001000200020006A8000100A603010001000414012O00A603012O009600015O0020BE00010001000D0020C70001000100162O00800001000200020006092O0100CB03013O000414012O00CB03012O0096000100083O00209000010001001C4O00035O00202O00030003000E4O00010003000200062O000100CB03013O000414012O00CB03012O009600015O00205900010001000E00202O00010001000F4O0001000200024O0002000B3O00062O000100CB03010002000414012O00CB03012O009600015O0020BE00010001000E0020C700010001000F2O0080000100020002002617000100CB03010010000414012O00CB03012O0096000100074O00C900025O00202O0002000200144O000300083O00202O0003000300184O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O000100CB03013O000414012O00CB03012O0096000100093O0012ED000200683O0012ED000300694O0010000100034O002000016O009600015O0020BE0001000100430020C700010001006A2O00800001000200020006092O0100FC03013O000414012O00FC03012O00960001001B3O0006092O0100FC03013O000414012O00FC03012O00960001001C3O0006092O0100DA03013O000414012O00DA03012O0096000100033O0006A8000100DD03010001000414012O00DD03012O00960001001C3O0006A8000100FC03010001000414012O00FC03012O0096000100044O0096000200053O0006FE000100FC03010002000414012O00FC03012O0096000100063O00209000010001004B4O00035O00202O0003000300624O00010003000200062O000100FC03013O000414012O00FC03012O00960001000D3O00206E0001000100174O00025O00202O0002000200434O0003000E6O0004001D6O000500083O00202O0005000500184O00075O00202O0007000700434O0005000700024O000500056O00010005000200062O000100FC03013O000414012O00FC03012O0096000100093O0012ED0002006B3O0012ED0003006C4O0010000100034O002000015O0012ED3O00423O0026E23O00670401000A000414012O006704012O009600015O0020BE00010001006D0020C70001000100042O00800001000200020006092O01001904013O000414012O001904012O00960001001E3O0006092O01001904013O000414012O001904012O0096000100074O00C900025O00202O00020002006D4O000300083O00202O0003000300184O00055O00202O00050005006D4O0003000500024O000300036O00010003000200062O0001001904013O000414012O001904012O0096000100093O0012ED0002006E3O0012ED0003006F4O0010000100034O002000016O009600015O0020BE0001000100700020C70001000100042O00800001000200020006092O01003304013O000414012O003304012O00960001001F3O0006092O01003304013O000414012O003304012O0096000100074O00C900025O00202O0002000200704O000300083O00202O0003000300184O00055O00202O0005000500704O0003000500024O000300036O00010003000200062O0001003304013O000414012O003304012O0096000100093O0012ED000200713O0012ED000300724O0010000100034O002000016O009600015O0020BE0001000100340020C70001000100042O00800001000200020006092O01004C04013O000414012O004C04012O0096000100143O0006092O01004C04013O000414012O004C04012O0096000100074O00F200025O00202O0002000200344O000300083O00202O00030003002400122O0005000A6O0003000500024O000300036O00010003000200062O0001004C04013O000414012O004C04012O0096000100093O0012ED000200733O0012ED000300744O0010000100034O002000016O009600015O0020BE0001000100140020C70001000100042O00800001000200020006092O01006604013O000414012O006604012O00960001000C3O0006092O01006604013O000414012O006604012O0096000100074O00C900025O00202O0002000200144O000300083O00202O0003000300184O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O0001006604013O000414012O006604012O0096000100093O0012ED000200753O0012ED000300764O0010000100034O002000015O0012ED3O00103O0026E23O000100010011000414012O000100012O009600015O0020BE00010001003E0020C70001000100042O00800001000200020006092O0100A604013O000414012O00A604012O0096000100163O0006092O0100A604013O000414012O00A604012O0096000100083O0020900001000100774O00035O00202O00030003000E4O00010003000200062O000100A604013O000414012O00A604012O009600015O0020BE00010001000D0020C70001000100162O00800001000200020006A80001008504010001000414012O008504012O009600015O0020BE0001000100430020C70001000100162O00800001000200020006092O0100A604013O000414012O00A604012O009600015O00205900010001000E00202O00010001000F4O0001000200024O0002000B3O00062O000100A604010002000414012O00A604012O009600015O0020BE00010001000E0020C700010001000F2O0080000100020002002617000100A604010010000414012O00A604012O00960001000D3O00206E0001000100174O00025O00202O00020002003E4O0003000E6O0004001D6O000500083O00202O0005000500184O00075O00202O00070007003E4O0005000700024O000500056O00010005000200062O000100A604013O000414012O00A604012O0096000100093O0012ED000200783O0012ED000300794O0010000100034O002000016O009600015O0020BE00010001000D0020C70001000100042O00800001000200020006092O0100C004013O000414012O00C004012O00960001000A3O0006092O0100C004013O000414012O00C004012O009600015O0020BE00010001000E0020C700010001000F2O0080000100020002000E92002200C004010001000414012O00C004012O0096000100074O009600025O0020BE00020002000D2O00800001000200020006092O0100C004013O000414012O00C004012O0096000100093O0012ED0002007A3O0012ED0003007B4O0010000100034O002000016O009600015O0020BE0001000100700020C70001000100042O00800001000200020006092O0100EE04013O000414012O00EE04012O00960001001F3O0006092O0100EE04013O000414012O00EE04012O0096000100063O0020900001000100054O00035O00202O00030003004C4O00010003000200062O000100EE04013O000414012O00EE04012O009600015O0020BE00010001007C0020C70001000100162O00800001000200020006A8000100DD04010001000414012O00DD04012O0096000100063O00208100010001001E4O00035O00202O00030003007D4O00010003000200262O000100EE04010010000414012O00EE04012O0096000100074O00C900025O00202O0002000200704O000300083O00202O0003000300184O00055O00202O0005000500704O0003000500024O000300036O00010003000200062O000100EE04013O000414012O00EE04012O0096000100093O0012ED0002007E3O0012ED0003007F4O0010000100034O002000016O009600015O0020BE0001000100230020C70001000100042O00800001000200020006092O01001705013O000414012O001705012O0096000100103O0006092O01001705013O000414012O001705012O009600015O0020BE00010001005A0020C70001000100162O00800001000200020006092O01001705013O000414012O001705012O0096000100063O0020900001000100054O00035O00202O0003000300804O00010003000200062O0001001705013O000414012O001705012O00960001000B3O000E920011001705010001000414012O001705012O0096000100074O00F200025O00202O0002000200234O000300083O00202O00030003002400122O0005000A6O0003000500024O000300036O00010003000200062O0001001705013O000414012O001705012O0096000100093O0012ED000200813O0012ED000300824O0010000100034O002000015O0012ED3O000A3O000414012O000100012O00C43O00017O00883O00028O00027O004003083O00466972654E6F766103073O004973526561647903103O00466C616D6553686F636B446562752O66030F3O0041757261416374697665436F756E74026O001840026O00104003133O004045D3A6C9C6495AC0E3F0DD4842C4AFB6991503063O00A8262CA1C39603093O00496365537472696B6503093O004861696C73746F726D030B3O004973417661696C61626C6503083O0042752O66446F776E030D3O00496365537472696B6542752O66030E3O004973496E4D656C2O6552616E6765026O00144003143O0089FF874923FCA41F8BF9C27025E6B8138CBCD32203083O0076E09CE2165088D6030A3O0046726F737453686F636B03063O0042752O665570030D3O004861696C73746F726D42752O66030E3O0049735370652O6C496E52616E676503153O0044FC569356D14A884DED52C044FB578E47E219D11703043O00E0228E3903093O0053756E646572696E6703093O004973496E52616E676503133O00CDB2CBD976E35400D9E7C3C87DFF58029EF69303083O006EBEC7A5BD13913D030A3O00466C616D6553686F636B030D3O004D6F6C74656E412O7361756C74030A3O00446562752O66446F776E03153O00DCE776E58EF8C9E378EB8087DCFE79E68ECB9ABA2003063O00A7BA8B1788EB030E3O005072696D6F726469616C5761766503093O00436173744379636C6503153O001CB989001F8A9B0515B6834D1CA086031FB9C85C4203043O006D7AD5E8026O000840030D3O004C696768746E696E67426F6C74030B3O00446562752O66537461636B03123O005072696D6F726469616C5761766542752O6603093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O6603143O004F766572666C6F77696E674D61656C7374726F6D03163O0053706C696E7465726564456C656D656E747342752O66026O0028402O033O0047434403173O00E2FEA538FAF9AB3EE9C8A03FE2E3E236FBF9AC35E2B7F303043O00508E97C203083O004C6176614C61736803083O00446562752O665570030D3O00417368656E436174616C79737403113O00417368656E436174616C79737442752O6603123O000FC7614D3CCA765F0B8671590DC87240439403043O002C63A617030A3O0049734361737461626C6503183O006CE5203B3CB678FE283A0CB37DE12C7635B172F92C3A73F703063O00C41C9749565303143O00F50F281D87670B7EFC002250844D1678F60F694403083O001693634970E23878030E3O00456C656D656E74616C426C61737403103O00456C656D656E74616C5370697269747303073O0043686172676573030F3O00466572616C53706972697442752O6603183O00BD79E7F888B661E3F9B2BA79E3E699F873F7FB83BD79A2A003053O00EDD8158295030A3O0057696E64737472696B6503113O0054686F72696D73496E766F636174696F6E026O00F03F03143O00436F6E76657267696E6753746F726D7342752O6603133O009547515BA3DD4C8B455A1FB6DC508C4B531FE603073O003EE22E2O3FD0A9030B3O0053746F726D737472696B6503143O00F60D5A91121E3B4CEC1250C319182150E02O15D403083O003E857935E37F6D4F030E3O00436861696E4C696768746E696E6703143O00437261636B6C696E675468756E64657242752O6603183O00131C33FCD891AE19133AE1D8A7AC175434E0D8A0A71C546A03073O00C270745295B6CE03093O004C617661427572737403103O004D6F6C74656E576561706F6E42752O6603143O00566F6C63616E6963537472656E67746842752O6603123O00437261636B6C696E67537572676542752O6603133O0035A95A19FFE01B2BBB2O58C6F70037AD40589903073O006E59C82C78A08203183O00A7CA4C4E57443243ACFC2O494F5E7B4BBECD45434F0A6A1D03083O002DCBA32B26232A5B030E3O0043726173684C696768746E696E67030D3O00442O6F6D57696E647342752O6603123O0043726173684C696768746E696E6742752O6603093O00416C706861576F6C6603103O00436F6E76657267696E6753746F726D7303193O00D197DD308F9658DB82D43789A05AD5C5DA3689A751DEC58D7203073O0034B2E5BC43E7C903073O0048617354696572026O003E4003133O0032545E00F24E2A2F461002E2522D244D1055A503073O004341213064973C03133O00D3E6B8D9CCD3E6BDD0B3D9F2A0D6F6D3A7FC8D03053O0093BF87CEB803193O00873AA7D2D06CBE8D2FAED5D65ABC8368A0D4D65DB78868F49703073O00D2E448C6A1B83303133O003040E1154CC0395FF25075DB3847F61C339C6103063O00AE562993701303193O005E0C8806200105AA573F8F07241C05EB5D158305200351F92O03083O00CB3B60ED6B456F7103143O002817BAE00EF2C23605B8A137E5D92A13A0A163A903073O00B74476CC81519003183O0002A477EC1F8C07A377DB098D02B930E21E8C00A87CA458D203063O00E26ECD10846B03133O00EDCAF2DC7EE5CCF6D801EDD6EED744E783B18003053O00218BA380B903143O00442O65706C79522O6F746564456C656D656E747303153O00444C0BCC5A4B10CC5E53019E514D0AD05254448C0703043O00BE373864030E3O004372617368696E6753746F726D7303143O00434C43726173684C696768746E696E6742752O6603193O0055BD3D0D1BDCFF5FA8340A1DEAFD51EF3A0B1DEDF65AEF6E4F03073O009336CF5C7E738303143O001A383B791E6A1F383E784D78183F3B78013E5F6303063O001E6D51551D6D03153O00EC655BA43BCDE8ED785FB376D8E9F17F51BA768CAF03073O009C9F1134D656BE03143O00A7ECB883BDFBAFB5A5EAFDBABBE1B3B9A2AFEFE803043O00DCCE8FDD030D3O0057696E6466757279546F74656D03113O0057696E6466757279546F74656D42752O6603113O0054696D6553696E63654C61737443617374025O0080564003183O0091742313DED9C09F423918CCC9DFC67B3819D6C9DEC62E7C03073O00B2E61D4D77B8AC03153O00F3B20B1672C7E6B605187CB8F3AB041572F4B5ED5803063O009895DE6A7B1703153O00DB34F950A1E235FE4CB6D666F056BBD323FA03E68E03053O00D5BD469623007D052O0012ED3O00013O0026E23O00FB00010002000414012O00FB00012O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O01002A00013O000414012O002A00012O0096000100013O0006092O01002A00013O000414012O002A00012O009600015O0020BE0001000100050020C70001000100062O00800001000200020026A70001001F00010007000414012O001F00012O009600015O0020BE0001000100050020C70001000100062O0080000100020002000E920008002A00010001000414012O002A00012O009600015O0020B900010001000500202O0001000100064O0001000200024O000200023O00062O0002002A00010001000414012O002A00012O0096000100034O009600025O0020BE0002000200032O00800001000200020006092O01002A00013O000414012O002A00012O0096000100043O0012ED000200093O0012ED0003000A4O0010000100034O002000016O009600015O0020BE00010001000B0020C70001000100042O00800001000200020006092O01005000013O000414012O005000012O0096000100053O0006092O01005000013O000414012O005000012O009600015O0020BE00010001000C0020C700010001000D2O00800001000200020006092O01005000013O000414012O005000012O0096000100063O00209000010001000E4O00035O00202O00030003000F4O00010003000200062O0001005000013O000414012O005000012O0096000100034O00F200025O00202O00020002000B4O000300073O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O0001005000013O000414012O005000012O0096000100043O0012ED000200123O0012ED000300134O0010000100034O002000016O009600015O0020BE0001000100140020C70001000100042O00800001000200020006092O01007700013O000414012O007700012O0096000100083O0006092O01007700013O000414012O007700012O009600015O0020BE00010001000C0020C700010001000D2O00800001000200020006092O01007700013O000414012O007700012O0096000100063O0020900001000100154O00035O00202O0003000300164O00010003000200062O0001007700013O000414012O007700012O0096000100034O00C900025O00202O0002000200144O000300073O00202O0003000300174O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O0001007700013O000414012O007700012O0096000100043O0012ED000200183O0012ED000300194O0010000100034O002000016O009600015O0020BE00010001001A0020C70001000100042O00800001000200020006092O01009D00013O000414012O009D00012O0096000100093O0006092O01009D00013O000414012O009D00012O00960001000A3O0006092O01008600013O000414012O008600012O00960001000B3O0006A80001008900010001000414012O008900012O00960001000A3O0006A80001009D00010001000414012O009D00012O00960001000C4O00960002000D3O0006FE0001009D00010002000414012O009D00012O0096000100034O00F200025O00202O00020002001A4O000300073O00202O00030003001B00122O000500116O0003000500024O000300036O00010003000200062O0001009D00013O000414012O009D00012O0096000100043O0012ED0002001C3O0012ED0003001D4O0010000100034O002000016O009600015O0020BE00010001001E0020C70001000100042O00800001000200020006092O0100C400013O000414012O00C400012O00960001000E3O0006092O0100C400013O000414012O00C400012O009600015O0020BE00010001001F0020C700010001000D2O00800001000200020006092O0100C400013O000414012O00C400012O0096000100073O0020900001000100204O00035O00202O0003000300054O00010003000200062O000100C400013O000414012O00C400012O0096000100034O00C900025O00202O00020002001E4O000300073O00202O0003000300174O00055O00202O00050005001E4O0003000500024O000300036O00010003000200062O000100C400013O000414012O00C400012O0096000100043O0012ED000200213O0012ED000300224O0010000100034O002000016O009600015O0020BE00010001001E0020C70001000100042O00800001000200020006092O0100FA00013O000414012O00FA00012O00960001000E3O0006092O0100FA00013O000414012O00FA00012O009600015O0020BE0001000100030020C700010001000D2O00800001000200020006A8000100D900010001000414012O00D900012O009600015O0020BE0001000100230020C700010001000D2O00800001000200020006092O0100FA00013O000414012O00FA00012O009600015O00205900010001000500202O0001000100064O0001000200024O000200023O00062O000100FA00010002000414012O00FA00012O009600015O0020BE0001000100050020C70001000100062O0080000100020002002617000100FA00010007000414012O00FA00012O00960001000F3O00206E0001000100244O00025O00202O00020002001E4O000300106O000400116O000500073O00202O0005000500174O00075O00202O00070007001E4O0005000700024O000500056O00010005000200062O000100FA00013O000414012O00FA00012O0096000100043O0012ED000200253O0012ED000300264O0010000100034O002000015O0012ED3O00273O000E032O01004E02013O000414012O004E02012O009600015O0020BE0001000100280020C70001000100042O00800001000200020006092O01004C2O013O000414012O004C2O012O0096000100123O0006092O01004C2O013O000414012O004C2O012O0096000100073O00200E0001000100294O00035O00202O0003000300054O0001000300024O000200023O00062O0002000800010001000414012O00152O012O0096000100073O0020810001000100294O00035O00202O0003000300054O00010003000200262O0001004C2O010007000414012O004C2O012O0096000100063O0020900001000100154O00035O00202O00030003002A4O00010003000200062O0001004C2O013O000414012O004C2O012O0096000100063O00208300010001002B4O00035O00202O00030003002C4O0001000300024O000200136O00035O00202O00030003002D00202O00030003000D4O000300046O00023O000200102O00020011000200102O00020011000200062O0001004C2O010002000414012O004C2O012O0096000100063O0020F100010001000E4O00035O00202O00030003002E4O00010003000200062O0001003B2O010001000414012O003B2O012O00960001000D3O00260A0001003B2O01002F000414012O003B2O012O00960001000C4O0096000200063O0020C70002000200302O00800002000200020006010001004C2O010002000414012O004C2O012O0096000100034O00C900025O00202O0002000200284O000300073O00202O0003000300174O00055O00202O0005000500284O0003000500024O000300036O00010003000200062O0001004C2O013O000414012O004C2O012O0096000100043O0012ED000200313O0012ED000300324O0010000100034O002000016O009600015O0020BE0001000100330020C70001000100042O00800001000200020006092O01008D2O013O000414012O008D2O012O0096000100143O0006092O01008D2O013O000414012O008D2O012O009600015O0020BE00010001001F0020C700010001000D2O00800001000200020006092O01006F2O013O000414012O006F2O012O0096000100073O0020900001000100344O00035O00202O0003000300054O00010003000200062O0001006F2O013O000414012O006F2O012O009600015O00205900010001000500202O0001000100064O0001000200024O000200023O00062O0001006F2O010002000414012O006F2O012O009600015O0020BE0001000100050020C70001000100062O00800001000200020026C50001007C2O010007000414012O007C2O012O009600015O0020BE0001000100350020C700010001000D2O00800001000200020006092O01008D2O013O000414012O008D2O012O0096000100063O00208100010001002B4O00035O00202O0003000300364O00010003000200262O0001008D2O010011000414012O008D2O012O0096000100034O00C900025O00202O0002000200334O000300073O00202O0003000300174O00055O00202O0005000500334O0003000500024O000300036O00010003000200062O0001008D2O013O000414012O008D2O012O0096000100043O0012ED000200373O0012ED000300384O0010000100034O002000016O009600015O0020BE0001000100230020C70001000100392O00800001000200020006092O0100BE2O013O000414012O00BE2O012O0096000100153O0006092O0100BE2O013O000414012O00BE2O012O0096000100163O0006092O01009C2O013O000414012O009C2O012O00960001000B3O0006A80001009F2O010001000414012O009F2O012O0096000100163O0006A8000100BE2O010001000414012O00BE2O012O00960001000C4O00960002000D3O0006FE000100BE2O010002000414012O00BE2O012O0096000100063O00209000010001000E4O00035O00202O00030003002A4O00010003000200062O000100BE2O013O000414012O00BE2O012O00960001000F3O00206E0001000100244O00025O00202O0002000200234O000300106O000400116O000500073O00202O0005000500174O00075O00202O0007000700234O0005000700024O000500056O00010005000200062O000100BE2O013O000414012O00BE2O012O0096000100043O0012ED0002003A3O0012ED0003003B4O0010000100034O002000016O009600015O0020BE00010001001E0020C70001000100042O00800001000200020006092O0100EB2O013O000414012O00EB2O012O00960001000E3O0006092O0100EB2O013O000414012O00EB2O012O009600015O0020BE0001000100230020C700010001000D2O00800001000200020006A8000100D32O010001000414012O00D32O012O009600015O0020BE0001000100030020C700010001000D2O00800001000200020006092O0100EB2O013O000414012O00EB2O012O0096000100073O0020900001000100204O00035O00202O0003000300054O00010003000200062O000100EB2O013O000414012O00EB2O012O0096000100034O00C900025O00202O00020002001E4O000300073O00202O0003000300174O00055O00202O00050005001E4O0003000500024O000300036O00010003000200062O000100EB2O013O000414012O00EB2O012O0096000100043O0012ED0002003C3O0012ED0003003D4O0010000100034O002000016O009600015O0020BE00010001003E0020C70001000100042O00800001000200020006092O01001F02013O000414012O001F02012O0096000100173O0006092O01001F02013O000414012O001F02012O009600015O0020BE00010001003F0020C700010001000D2O00800001000200020006092O01000E02013O000414012O000E02012O009600015O0020BE00010001003F0020C700010001000D2O00800001000200020006092O01001F02013O000414012O001F02012O009600015O00207F00010001003E00202O0001000100404O0001000200024O000200183O00062O0001000E02010002000414012O000E02012O0096000100063O0020900001000100154O00035O00202O0003000300414O00010003000200062O0001001F02013O000414012O001F02012O0096000100034O00C900025O00202O00020002003E4O000300073O00202O0003000300174O00055O00202O00050005003E4O0003000500024O000300036O00010003000200062O0001001F02013O000414012O001F02012O0096000100043O0012ED000200423O0012ED000300434O0010000100034O002000016O009600015O0020BE0001000100440020C70001000100042O00800001000200020006092O01004D02013O000414012O004D02012O0096000100193O0006092O01004D02013O000414012O004D02012O009600015O0020BE0001000100450020C700010001000D2O00800001000200020006092O01003502013O000414012O003502012O0096000100063O00209A00010001002B4O00035O00202O00030003002C4O000100030002000E2O0046003C02010001000414012O003C02012O0096000100063O00208100010001002B4O00035O00202O0003000300474O00010003000200262O0001004D02010007000414012O004D02012O0096000100034O00C900025O00202O0002000200444O000300073O00202O0003000300174O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O0001004D02013O000414012O004D02012O0096000100043O0012ED000200483O0012ED000300494O0010000100034O002000015O0012ED3O00463O000E030146008103013O000414012O008103012O009600015O0020BE00010001004A0020C70001000100042O00800001000200020006092O01007102013O000414012O007102012O00960001001A3O0006092O01007102013O000414012O007102012O0096000100063O00208100010001002B4O00035O00202O0003000300474O00010003000200262O0001007102010007000414012O007102012O0096000100034O00C900025O00202O00020002004A4O000300073O00202O0003000300174O00055O00202O00050005004A4O0003000500024O000300036O00010003000200062O0001007102013O000414012O007102012O0096000100043O0012ED0002004B3O0012ED0003004C4O0010000100034O002000016O009600015O0020BE00010001004D0020C70001000100042O00800001000200020006092O0100A102013O000414012O00A102012O00960001001B3O0006092O0100A102013O000414012O00A102012O0096000100063O00208300010001002B4O00035O00202O00030003002C4O0001000300024O000200136O00035O00202O00030003002D00202O00030003000D4O000300046O00023O000200102O00020011000200102O00020011000200062O000100A102010002000414012O00A102012O0096000100063O0020900001000100154O00035O00202O00030003004E4O00010003000200062O000100A102013O000414012O00A102012O0096000100034O00C900025O00202O00020002004D4O000300073O00202O0003000300174O00055O00202O00050005004D4O0003000500024O000300036O00010003000200062O000100A102013O000414012O00A102012O0096000100043O0012ED0002004F3O0012ED000300504O0010000100034O002000016O009600015O0020BE0001000100510020C70001000100042O00800001000200020006092O0100DE02013O000414012O00DE02012O00960001001C3O0006092O0100DE02013O000414012O00DE02012O0096000100063O00207000010001002B4O00035O00202O0003000300524O0001000300024O000200136O000300063O00202O0003000300154O00055O00202O0005000500534O000300056O00023O00024O0001000100024O000200063O00202O00020002002B4O00045O00202O0004000400544O00020004000200062O000200DE02010001000414012O00DE02012O0096000100063O00208300010001002B4O00035O00202O00030003002C4O0001000300024O000200136O00035O00202O00030003002D00202O00030003000D4O000300046O00023O000200102O00020011000200102O00020011000200062O000100DE02010002000414012O00DE02012O0096000100034O00C900025O00202O0002000200514O000300073O00202O0003000300174O00055O00202O0005000500514O0003000500024O000300036O00010003000200062O000100DE02013O000414012O00DE02012O0096000100043O0012ED000200553O0012ED000300564O0010000100034O002000016O009600015O0020BE0001000100280020C70001000100042O00800001000200020006092O01000703013O000414012O000703012O0096000100123O0006092O01000703013O000414012O000703012O0096000100063O00208300010001002B4O00035O00202O00030003002C4O0001000300024O000200136O00035O00202O00030003002D00202O00030003000D4O000300046O00023O000200102O00020011000200102O00020011000200062O0001000703010002000414012O000703012O0096000100034O00C900025O00202O0002000200284O000300073O00202O0003000300174O00055O00202O0005000500284O0003000500024O000300036O00010003000200062O0001000703013O000414012O000703012O0096000100043O0012ED000200573O0012ED000300584O0010000100034O002000016O009600015O0020BE0001000100590020C70001000100042O00800001000200020006092O01004C03013O000414012O004C03012O00960001001D3O0006092O01004C03013O000414012O004C03012O0096000100063O0020F10001000100154O00035O00202O00030003005A4O00010003000200062O0001003C03010001000414012O003C03012O0096000100063O0020F100010001000E4O00035O00202O00030003005B4O00010003000200062O0001003C03010001000414012O003C03012O009600015O0020BE00010001005C0020C700010001000D2O00800001000200020006092O01002F03013O000414012O002F03012O0096000100063O0020900001000100154O00035O00202O0003000300414O00010003000200062O0001002F03013O000414012O002F03012O00960001001E4O00CE0001000100020026A70001003C03010001000414012O003C03012O009600015O0020BE00010001005D0020C700010001000D2O00800001000200020006092O01004C03013O000414012O004C03012O0096000100063O00200B00010001002B4O00035O00202O0003000300474O00010003000200262O0001004C03010007000414012O004C03012O0096000100034O00F200025O00202O0002000200594O000300073O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O0001004C03013O000414012O004C03012O0096000100043O0012ED0002005E3O0012ED0003005F4O0010000100034O002000016O009600015O0020BE00010001001A0020C70001000100042O00800001000200020006092O01008003013O000414012O008003012O0096000100093O0006092O01008003013O000414012O008003012O00960001000A3O0006092O01005B03013O000414012O005B03012O00960001000B3O0006A80001005E03010001000414012O005E03012O00960001000A3O0006A80001008003010001000414012O008003012O00960001000C4O00960002000D3O0006FE0001008003010002000414012O008003012O0096000100063O0020F10001000100154O00035O00202O00030003005A4O00010003000200062O0001007003010001000414012O007003012O0096000100063O00206300010001006000122O000300613O00122O000400026O00010004000200062O0001008003013O000414012O008003012O0096000100034O00F200025O00202O00020002001A4O000300073O00202O00030003001B00122O000500116O0003000500024O000300036O00010003000200062O0001008003013O000414012O008003012O0096000100043O0012ED000200623O0012ED000300634O0010000100034O002000015O0012ED3O00023O000E030108005B04013O000414012O005B04012O009600015O0020BE0001000100330020C70001000100042O00800001000200020006092O01009D03013O000414012O009D03012O0096000100143O0006092O01009D03013O000414012O009D03012O0096000100034O00C900025O00202O0002000200334O000300073O00202O0003000300174O00055O00202O0005000500334O0003000500024O000300036O00010003000200062O0001009D03013O000414012O009D03012O0096000100043O0012ED000200643O0012ED000300654O0010000100034O002000016O009600015O0020BE0001000100590020C70001000100042O00800001000200020006092O0100B603013O000414012O00B603012O00960001001D3O0006092O0100B603013O000414012O00B603012O0096000100034O00F200025O00202O0002000200594O000300073O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O000100B603013O000414012O00B603012O0096000100043O0012ED000200663O0012ED000300674O0010000100034O002000016O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O0100D003013O000414012O00D003012O0096000100013O0006092O0100D003013O000414012O00D003012O009600015O0020BE0001000100050020C70001000100062O0080000100020002000E92000200D003010001000414012O00D003012O0096000100034O009600025O0020BE0002000200032O00800001000200020006092O0100D003013O000414012O00D003012O0096000100043O0012ED000200683O0012ED000300694O0010000100034O002000016O009600015O0020BE00010001003E0020C70001000100042O00800001000200020006092O01002O04013O000414012O002O04012O0096000100173O0006092O01002O04013O000414012O002O04012O009600015O0020BE00010001003F0020C700010001000D2O00800001000200020006092O0100F303013O000414012O00F303012O009600015O0020BE00010001003F0020C700010001000D2O00800001000200020006092O01002O04013O000414012O002O04012O009600015O00207F00010001003E00202O0001000100404O0001000200024O000200183O00062O000100F303010002000414012O00F303012O0096000100063O0020900001000100154O00035O00202O0003000300414O00010003000200062O0001002O04013O000414012O002O04012O0096000100034O00C900025O00202O00020002003E4O000300073O00202O0003000300174O00055O00202O00050005003E4O0003000500024O000300036O00010003000200062O0001002O04013O000414012O002O04012O0096000100043O0012ED0002006A3O0012ED0003006B4O0010000100034O002000016O009600015O0020BE0001000100510020C70001000100042O00800001000200020006092O01003904013O000414012O003904012O00960001001C3O0006092O01003904013O000414012O003904012O0096000100063O00207000010001002B4O00035O00202O0003000300524O0001000300024O000200136O000300063O00202O0003000300154O00055O00202O0005000500534O000300056O00023O00024O0001000100024O000200063O00202O00020002002B4O00045O00202O0004000400544O00020004000200062O0002003904010001000414012O003904012O0096000100063O00207E00010001002B4O00035O00202O00030003002C4O000100030002000E2O0011003904010001000414012O003904012O0096000100034O00C900025O00202O0002000200514O000300073O00202O0003000300174O00055O00202O0005000500514O0003000500024O000300036O00010003000200062O0001003904013O000414012O003904012O0096000100043O0012ED0002006C3O0012ED0003006D4O0010000100034O002000016O009600015O0020BE0001000100280020C70001000100042O00800001000200020006092O01005A04013O000414012O005A04012O0096000100123O0006092O01005A04013O000414012O005A04012O0096000100063O00207E00010001002B4O00035O00202O00030003002C4O000100030002000E2O0011005A04010001000414012O005A04012O0096000100034O00C900025O00202O0002000200284O000300073O00202O0003000300174O00055O00202O0005000500284O0003000500024O000300036O00010003000200062O0001005A04013O000414012O005A04012O0096000100043O0012ED0002006E3O0012ED0003006F4O0010000100034O002000015O0012ED3O00113O0026E23O001505010027000414012O001505012O009600015O0020BE0001000100030020C70001000100042O00800001000200020006092O01007704013O000414012O007704012O0096000100013O0006092O01007704013O000414012O007704012O009600015O0020BE0001000100050020C70001000100062O0080000100020002000E920027007704010001000414012O007704012O0096000100034O009600025O0020BE0002000200032O00800001000200020006092O01007704013O000414012O007704012O0096000100043O0012ED000200703O0012ED000300714O0010000100034O002000016O009600015O0020BE00010001004A0020C70001000100042O00800001000200020006092O01009E04013O000414012O009E04012O00960001001A3O0006092O01009E04013O000414012O009E04012O0096000100063O0020900001000100154O00035O00202O00030003005B4O00010003000200062O0001009E04013O000414012O009E04012O009600015O0020BE0001000100720020C700010001000D2O00800001000200020006092O01009E04013O000414012O009E04012O0096000100034O00C900025O00202O00020002004A4O000300073O00202O0003000300174O00055O00202O00050005004A4O0003000500024O000300036O00010003000200062O0001009E04013O000414012O009E04012O0096000100043O0012ED000200733O0012ED000300744O0010000100034O002000016O009600015O0020BE0001000100590020C70001000100042O00800001000200020006092O0100C704013O000414012O00C704012O00960001001D3O0006092O0100C704013O000414012O00C704012O009600015O0020BE0001000100750020C700010001000D2O00800001000200020006092O0100C704013O000414012O00C704012O0096000100063O0020900001000100154O00035O00202O0003000300764O00010003000200062O000100C704013O000414012O00C704012O0096000100023O000E92000800C704010001000414012O00C704012O0096000100034O00F200025O00202O0002000200594O000300073O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O000100C704013O000414012O00C704012O0096000100043O0012ED000200773O0012ED000300784O0010000100034O002000016O009600015O0020BE0001000100440020C70001000100042O00800001000200020006092O0100E104013O000414012O00E104012O0096000100193O0006092O0100E104013O000414012O00E104012O0096000100034O00C900025O00202O0002000200444O000300073O00202O0003000300174O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O000100E104013O000414012O00E104012O0096000100043O0012ED000200793O0012ED0003007A4O0010000100034O002000016O009600015O0020BE00010001004A0020C70001000100042O00800001000200020006092O0100FB04013O000414012O00FB04012O00960001001A3O0006092O0100FB04013O000414012O00FB04012O0096000100034O00C900025O00202O00020002004A4O000300073O00202O0003000300174O00055O00202O00050005004A4O0003000500024O000300036O00010003000200062O000100FB04013O000414012O00FB04012O0096000100043O0012ED0002007B3O0012ED0003007C4O0010000100034O002000016O009600015O0020BE00010001000B0020C70001000100042O00800001000200020006092O01001405013O000414012O001405012O0096000100053O0006092O01001405013O000414012O001405012O0096000100034O00F200025O00202O00020002000B4O000300073O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O0001001405013O000414012O001405012O0096000100043O0012ED0002007D3O0012ED0003007E4O0010000100034O002000015O0012ED3O00083O0026E23O000100010011000414012O000100012O009600015O0020BE00010001007F0020C70001000100042O00800001000200020006092O01003905013O000414012O003905012O00960001001F3O0006092O01003905013O000414012O003905012O0096000100063O00200700010001000E4O00035O00202O0003000300804O000400016O00010004000200062O0001002E05010001000414012O002E05012O009600015O0020BE00010001007F0020C70001000100812O0080000100020002000EB70082003905010001000414012O003905012O0096000100034O009600025O0020BE00020002007F2O00800001000200020006092O01003905013O000414012O003905012O0096000100043O0012ED000200833O0012ED000300844O0010000100034O002000016O009600015O0020BE00010001001E0020C70001000100042O00800001000200020006092O01005A05013O000414012O005A05012O00960001000E3O0006092O01005A05013O000414012O005A05012O0096000100073O0020900001000100204O00035O00202O0003000300054O00010003000200062O0001005A05013O000414012O005A05012O0096000100034O00C900025O00202O00020002001E4O000300073O00202O0003000300174O00055O00202O00050005001E4O0003000500024O000300036O00010003000200062O0001005A05013O000414012O005A05012O0096000100043O0012ED000200853O0012ED000300864O0010000100034O002000016O009600015O0020BE0001000100140020C70001000100042O00800001000200020006092O01007C05013O000414012O007C05012O0096000100083O0006092O01007C05013O000414012O007C05012O009600015O0020BE00010001000C0020C700010001000D2O00800001000200020006A80001007C05010001000414012O007C05012O0096000100034O00C900025O00202O0002000200144O000300073O00202O0003000300174O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O0001007C05013O000414012O007C05012O0096000100043O0012A0000200873O00122O000300886O000100036O00015O00044O007C0501000414012O000100012O00C43O00017O00263O00028O00026O00F03F024O00804F224103123O00466C616D656E746F6E677565576561706F6E030A3O0049734361737461626C65031A3O00495975054A417B064840713758507518405B340D41567C092O4103043O00682F3514027O004003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B030F3O00416E6365737472616C537069726974030C3O00B1499209AE1DA64F9515B30103063O006FC32CE17CDC030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174030A3O004175746F536869656C64030B3O004561727468536869656C6403083O0042752O66446F776E030F3O004561727468536869656C6442752O6603093O00536869656C64557365030C3O00FD471267A32OEB4E0976A7AF03063O00CBB8266013CB030E3O00456C656D656E74616C4F72626974030B3O004973417661696C61626C6503063O0042752O665570030F3O004C696768746E696E67536869656C6403133O003C726B55C606607148CB3577394CCF307D391303053O00AE5913192103133O004C696768746E696E67536869656C6442752O6603103O00031B5546E389022115127DFF8E0E231603073O006B4F72322E97E703173O0035AFB2219E37BECE3E99A621833CBBC479ABB4208479E503083O00A059C6D549EA59D7030E3O0057696E6466757279576561706F6E03173O005F78BAFAC35D63ADC1D24D70A4F1CB0874BAFDCD497FA003053O00A52811D49E00ED3O0012ED3O00013O0026E23O002E00010002000414012O002E00012O009600015O0006092O01000900013O000414012O000900012O0096000100013O0026170001001D00010003000414012O001D00012O0096000100023O0006092O01001D00013O000414012O001D00012O0096000100033O0020BE0001000100040020C70001000100052O00800001000200020006092O01001D00013O000414012O001D00012O0096000100044O0096000200033O0020BE0002000200042O00800001000200020006092O01001D00013O000414012O001D00012O0096000100053O0012ED000200063O0012ED000300074O0010000100034O002000016O0096000100063O0006092O01002D00013O000414012O002D00010012ED000100013O0026E20001002100010001000414012O002100012O0096000200084O00CE0002000100022O007A000200074O0096000200073O0006090102002D00013O000414012O002D00012O0096000200074O00C8000200023O000414012O002D0001000414012O002100010012ED3O00083O0026E23O006F00010008000414012O006F00012O0096000100093O0006092O01005500013O000414012O005500012O0096000100093O0020C70001000100092O00800001000200020006092O01005500013O000414012O005500012O0096000100093O0020C700010001000A2O00800001000200020006092O01005500013O000414012O005500012O0096000100093O0020C700010001000B2O00800001000200020006092O01005500013O000414012O005500012O00960001000A3O0020C700010001000C2O0096000300094O00DE0001000300020006A80001005500010001000414012O005500012O0096000100044O0052000200033O00202O00020002000D4O000300036O000400016O00010004000200062O0001005500013O000414012O005500012O0096000100053O0012ED0002000E3O0012ED0003000F4O0010000100034O002000016O00960001000B3O0020BE0001000100102O00CE0001000100020006092O0100EC00013O000414012O00EC00012O00960001000C3O0006092O0100EC00013O000414012O00EC00012O00960001000A3O0020C70001000100112O00800001000200020006A8000100EC00010001000414012O00EC00010012ED000100014O00D5000200023O0026E20001006400010001000414012O006400012O00960003000D4O00CE0003000100022O0018000200033O000609010200EC00013O000414012O00EC00012O00C8000200023O000414012O00EC0001000414012O00640001000414012O00EC00010026E23O000100010001000414012O00010001001293000100123O0006092O0100A100013O000414012O00A100012O0096000100033O0020BE0001000100130020C70001000100052O00800001000200020006092O0100A100013O000414012O00A100012O00960001000A3O0020900001000100144O000300033O00202O0003000300154O00010003000200062O000100A100013O000414012O00A10001001293000100164O00C6000200053O00122O000300173O00122O000400186O00020004000200062O0001009500010002000414012O009500012O0096000100033O0020BE0001000100190020C700010001001A2O00800001000200020006092O0100A100013O000414012O00A100012O00960001000A3O00209000010001001B4O000300033O00202O00030003001C4O00010003000200062O000100A100013O000414012O00A100012O0096000100044O0096000200033O0020BE0002000200132O00800001000200020006092O0100D000013O000414012O00D000012O0096000100053O0012A00002001D3O00122O0003001E6O000100036O00015O00044O00D00001001293000100123O0006092O0100D000013O000414012O00D000012O0096000100033O0020BE00010001001C0020C70001000100052O00800001000200020006092O0100D000013O000414012O00D000012O00960001000A3O0020900001000100144O000300033O00202O00030003001F4O00010003000200062O000100D000013O000414012O00D00001001293000100164O00C6000200053O00122O000300203O00122O000400216O00020004000200062O000100C500010002000414012O00C500012O0096000100033O0020BE0001000100190020C700010001001A2O00800001000200020006092O0100D000013O000414012O00D000012O00960001000A3O00209000010001001B4O000300033O00202O0003000300134O00010003000200062O000100D000013O000414012O00D000012O0096000100044O0096000200033O0020BE00020002001C2O00800001000200020006092O0100D000013O000414012O00D000012O0096000100053O0012ED000200223O0012ED000300234O0010000100034O002000016O00960001000E3O0006092O0100D600013O000414012O00D600012O00960001000F3O002617000100EA00010003000414012O00EA00012O0096000100023O0006092O0100EA00013O000414012O00EA00012O0096000100033O0020BE0001000100240020C70001000100052O00800001000200020006092O0100EA00013O000414012O00EA00012O0096000100044O0096000200033O0020BE0002000200242O00800001000200020006092O0100EA00013O000414012O00EA00012O0096000100053O0012ED000200253O0012ED000300264O0010000100034O002000015O0012ED3O00023O000414012O000100012O00C43O00017O00513O00028O00026O00F03F030F3O0048616E646C65412O666C696374656403143O00506F69736F6E436C65616E73696E67546F74656D026O003E4003093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O001440030C3O004865616C696E67537572676503153O004865616C696E6753757267654D6F7573656F766572026O004440030D3O00436C65616E736553706972697403163O00436C65616E73655370697269744D6F7573656F766572030B3O005472656D6F72546F74656D03113O0048616E646C65496E636F72706F7265616C2O033O00486578030C3O004865784D6F7573654F766572027O0040026O00084003053O00507572676503073O004973526561647903093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030E3O0049735370652O6C496E52616E6765030C3O00F5CC1A3423A5DD093E27E2DC03053O004685B96853026O001040030D3O00546172676574497356616C6964030F3O0048616E646C65445053506F74696F6E03063O0042752O665570030F3O00466572616C53706972697442752O6603093O00426C2O6F6446757279030A3O0049734361737461626C65030A3O00417363656E64616E6365030B3O004973417661696C61626C65030E3O00417363656E64616E636542752O66030F3O00432O6F6C646F776E52656D61696E73026O00494003113O0006494B25CD3B435138D044574529C0054903053O00A96425244A030A3O004265727365726B696E6703113O000282B0430595A9590E80E2420184AB510C03043O003060E7C203093O0046697265626C2O6F6403103O00CE531C281BD4A08CCC1A1C2C1AD1AE8F03083O00E3A83A6E4D79B8CF030D3O00416E6365737472616C43612O6C03153O007A32BC45A2CF63A47703BC41BDD731B77A3FB641BD03083O00C51B5CDF20D1BB11030A3O0057696E64737472696B6503113O0054686F72696D73496E766F636174696F6E030D3O004C696768746E696E67426F6C74030E3O00436861696E4C696768746E696E6703113O001456CDFF104BD1F2085A83F60256CDBB5203043O009B633FA3030E3O005072696D6F726469616C5761766503073O0048617354696572026O003F4003163O0092C3A880B69686D8A081869383C7A4CDB4858BDFE1DF03063O00E4E2B1C1EDD9030B3O00466572616C53706972697403133O0032B531E7388F30F63DA22AF274BD22EF3AF07003043O008654D04303083O00446562752O66557003103O00466C616D6553686F636B446562752O6603113O0012BF85591DA8875210A9C65112A5881C4703043O003C73CCE603093O00442O6F6D57696E6473030E3O004973496E4D656C2O6552616E676503113O00E335E47DD82DE27EE329AB7DE633E530B203043O0010875A8B030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O0063552F0703073O0018341466532E3403133O00576169742F502O6F6C205265736F757263657303053O00466F637573030C3O0047726561746572507572676503143O00C33D24251BC13D1E341AD62824640BC52220230A03053O006FA44F4144000C032O0012ED3O00013O0026E23O008600010002000414012O008600012O009600015O0006092O01006E00013O000414012O006E00010012ED000100013O0026E20001003E00010002000414012O003E00012O0096000200013O0006090102001F00013O000414012O001F00010012ED000200013O0026E20002000D00010001000414012O000D00012O0096000300033O00209F0003000300034O000400043O00202O0004000400044O000500043O00202O00050005000400122O000600056O0003000600024O000300026O000300023O00062O0003001F00013O000414012O001F00012O0096000300024O00C8000300023O000414012O001F0001000414012O000D00012O0096000200053O00207E0002000200064O000400043O00202O0004000400074O000200040002000E2O0008006E00010002000414012O006E00012O0096000200063O0006090102006E00013O000414012O006E00010012ED000200013O0026E20002002A00010001000414012O002A00012O0096000300033O00201D0003000300034O000400043O00202O0004000400094O000500073O00202O00050005000A00122O0006000B6O000700016O0003000700024O000300026O000300023O00062O0003006E00013O000414012O006E00012O0096000300024O00C8000300023O000414012O006E0001000414012O002A0001000414012O006E00010026E20001000700010001000414012O000700012O0096000200083O0006090102005600013O000414012O005600010012ED000200013O0026E20002004400010001000414012O004400012O0096000300033O00209F0003000300034O000400043O00202O00040004000C4O000500073O00202O00050005000D00122O0006000B6O0003000600024O000300026O000300023O00062O0003005600013O000414012O005600012O0096000300024O00C8000300023O000414012O00560001000414012O004400012O0096000200093O0006090102006C00013O000414012O006C00010012ED000200013O0026E20002005A00010001000414012O005A00012O0096000300033O00209F0003000300034O000400043O00202O00040004000E4O000500043O00202O00050005000E00122O000600056O0003000600024O000300026O000300023O00062O0003006C00013O000414012O006C00012O0096000300024O00C8000300023O000414012O006C0001000414012O005A00010012ED000100023O000414012O000700012O00960001000A3O0006092O01008500013O000414012O008500010012ED000100013O0026E20001007200010001000414012O007200012O0096000200033O00201D00020002000F4O000300043O00202O0003000300104O000400073O00202O00040004001100122O000500056O000600016O0002000600024O000200026O000200023O00062O0002008500013O000414012O008500012O0096000200024O00C8000200023O000414012O00850001000414012O007200010012ED3O00123O0026E23O00BC00010013000414012O00BC00012O0096000100043O0020BE0001000100140020C70001000100152O00800001000200020006092O0100B800013O000414012O00B800012O00960001000B3O0006092O0100B800013O000414012O00B800012O00960001000C3O0006092O0100B800013O000414012O00B800012O00960001000D3O0006092O0100B800013O000414012O00B800012O0096000100053O0020C70001000100162O00800001000200020006A8000100B800010001000414012O00B800012O0096000100053O0020C70001000100172O00800001000200020006A8000100B800010001000414012O00B800012O0096000100033O0020BE0001000100182O00960002000E4O00800001000200020006092O0100B800013O000414012O00B800012O00960001000F4O00C9000200043O00202O0002000200144O0003000E3O00202O0003000300194O000500043O00202O0005000500144O0003000500024O000300036O00010003000200062O000100B800013O000414012O00B800012O0096000100103O0012ED0002001A3O0012ED0003001B4O0010000100034O002000016O0096000100114O00CE0001000100022O007A000100023O0012ED3O001C3O000E03011C00B302013O000414012O00B302012O0096000100023O0006092O0100C300013O000414012O00C300012O0096000100024O00C8000100024O0096000100033O0020BE00010001001D2O00CE0001000100020006092O01000B03013O000414012O000B03010012ED000100014O00D5000200023O0026E2000100982O010001000414012O00982O012O0096000300033O0020BB00030003001E4O000400053O00202O00040004001F4O000600043O00202O0006000600204O000400066O00033O00024O000200033O00062O000200D800013O000414012O00D800012O00C8000200024O0096000300124O0096000400133O0006FE000300F500010004000414012O00F500012O0096000300143O000609010300F500013O000414012O00F500012O0096000300153O000609010300E500013O000414012O00E500012O0096000300163O0006A8000300E800010001000414012O00E800012O0096000300163O0006A8000300F500010001000414012O00F500010012ED000300013O0026E2000300E900010001000414012O00E900012O0096000400174O00CE0004000100022O007A000400024O0096000400023O000609010400F500013O000414012O00F500012O0096000400024O00C8000400023O000414012O00F50001000414012O00E900012O0096000300124O0096000400133O0006FE000300972O010004000414012O00972O012O0096000300183O000609010300972O013O000414012O00972O012O0096000300193O000609010300022O013O000414012O00022O012O0096000300153O0006A8000300052O010001000414012O00052O012O0096000300193O0006A8000300972O010001000414012O00972O010012ED000300013O0026E20003004B2O010001000414012O004B2O012O0096000400043O0020BE0004000400210020C70004000400222O00800004000200020006090104002C2O013O000414012O002C2O012O0096000400043O0020BE0004000400230020C70004000400242O0080000400020002000609010400212O013O000414012O00212O012O0096000400053O0020F100040004001F4O000600043O00202O0006000600254O00040006000200062O000400212O010001000414012O00212O012O0096000400043O0020BE0004000400230020C70004000400262O0080000400020002000EB70027002C2O010004000414012O002C2O012O00960004000F4O0096000500043O0020BE0005000500212O00800004000200020006090104002C2O013O000414012O002C2O012O0096000400103O0012ED000500283O0012ED000600294O0010000400064O002000046O0096000400043O0020BE00040004002A0020C70004000400222O00800004000200020006090104004A2O013O000414012O004A2O012O0096000400043O0020BE0004000400230020C70004000400242O00800004000200020006090104003F2O013O000414012O003F2O012O0096000400053O00209000040004001F4O000600043O00202O0006000600254O00040006000200062O0004004A2O013O000414012O004A2O012O00960004000F4O0096000500043O0020BE00050005002A2O00800004000200020006090104004A2O013O000414012O004A2O012O0096000400103O0012ED0005002B3O0012ED0006002C4O0010000400064O002000045O0012ED000300023O0026E2000300062O010002000414012O00062O012O0096000400043O0020BE00040004002D0020C70004000400222O0080000400020002000609010400712O013O000414012O00712O012O0096000400043O0020BE0004000400230020C70004000400242O0080000400020002000609010400662O013O000414012O00662O012O0096000400053O0020F100040004001F4O000600043O00202O0006000600254O00040006000200062O000400662O010001000414012O00662O012O0096000400043O0020BE0004000400230020C70004000400262O0080000400020002000EB7002700712O010004000414012O00712O012O00960004000F4O0096000500043O0020BE00050005002D2O0080000400020002000609010400712O013O000414012O00712O012O0096000400103O0012ED0005002E3O0012ED0006002F4O0010000400064O002000046O0096000400043O0020BE0004000400300020C70004000400222O0080000400020002000609010400972O013O000414012O00972O012O0096000400043O0020BE0004000400230020C70004000400242O00800004000200020006090104008A2O013O000414012O008A2O012O0096000400053O0020F100040004001F4O000600043O00202O0006000600254O00040006000200062O0004008A2O010001000414012O008A2O012O0096000400043O0020BE0004000400230020C70004000400262O0080000400020002000EB7002700972O010004000414012O00972O012O00960004000F4O0096000500043O0020BE0005000500302O0080000400020002000609010400972O013O000414012O00972O012O0096000400103O0012A0000500313O00122O000600326O000400066O00045O00044O00972O01000414012O00062O010012ED000100023O000E030102005902010001000414012O005902012O0096000300043O0020BE0003000300330020C70003000300152O0080000300020002000609010300D12O013O000414012O00D12O012O00960003001A3O000609010300D12O013O000414012O00D12O012O0096000300043O0020BE0003000300340020C70003000300242O0080000300020002000609010300D12O013O000414012O00D12O012O0096000300053O0020370003000300064O000500043O00202O0005000500074O000300050002000E2O000200D12O010003000414012O00D12O012O00960003001B3O0026E2000300B82O010002000414012O00B82O012O00960003001C4O0096000400043O0020BE0004000400350006CC000300C02O010004000414012O00C02O012O00960003001B3O000EB7000200D12O010003000414012O00D12O012O00960003001C4O0096000400043O0020BE0004000400360006F9000300D12O010004000414012O00D12O012O00960003000F4O00C9000400043O00202O0004000400334O0005000E3O00202O0005000500194O000700043O00202O0007000700334O0005000700024O000500056O00030005000200062O000300D12O013O000414012O00D12O012O0096000300103O0012ED000400373O0012ED000500384O0010000300054O002000036O0096000300043O0020BE0003000300390020C70003000300222O0080000300020002000609010300FF2O013O000414012O00FF2O012O00960003001D3O000609010300FF2O013O000414012O00FF2O012O00960003001E3O000609010300E02O013O000414012O00E02O012O00960003001F3O0006A8000300E32O010001000414012O00E32O012O00960003001E3O0006A8000300FF2O010001000414012O00FF2O012O0096000300124O0096000400133O0006FE000300FF2O010004000414012O00FF2O012O0096000300053O00206300030003003A00122O0005003B3O00122O000600126O00030006000200062O000300FF2O013O000414012O00FF2O012O00960003000F4O00C9000400043O00202O0004000400394O0005000E3O00202O0005000500194O000700043O00202O0007000700394O0005000700024O000500056O00030005000200062O000300FF2O013O000414012O00FF2O012O0096000300103O0012ED0004003C3O0012ED0005003D4O0010000300054O002000036O0096000300043O0020BE00030003003E0020C70003000300222O00800003000200020006090103002002013O000414012O002002012O0096000300203O0006090103002002013O000414012O002002012O0096000300213O0006090103000E02013O000414012O000E02012O0096000300153O0006A80003001102010001000414012O001102012O0096000300213O0006A80003002002010001000414012O002002012O0096000300124O0096000400133O0006FE0003002002010004000414012O002002012O00960003000F4O0096000400043O0020BE00040004003E2O00800003000200020006090103002002013O000414012O002002012O0096000300103O0012ED0004003F3O0012ED000500404O0010000300054O002000036O0096000300043O0020BE0003000300230020C70003000300222O00800003000200020006090103005802013O000414012O005802012O0096000300223O0006090103005802013O000414012O005802012O0096000300233O0006090103002F02013O000414012O002F02012O0096000300153O0006A80003003202010001000414012O003202012O0096000300233O0006A80003005802010001000414012O005802012O0096000300124O0096000400133O0006FE0003005802010004000414012O005802012O00960003000E3O0020900003000300414O000500043O00202O0005000500424O00030005000200062O0003005802013O000414012O005802012O00960003001C4O0096000400043O0020BE0004000400350006F90003004502010004000414012O004502012O00960003001B3O0026A70003004D02010002000414012O004D02012O00960003001C4O0096000400043O0020BE0004000400360006F90003005802010004000414012O005802012O00960003001B3O000EB70002005802010003000414012O005802012O00960003000F4O0096000400043O0020BE0004000400232O00800003000200020006090103005802013O000414012O005802012O0096000300103O0012ED000400433O0012ED000500444O0010000300054O002000035O0012ED000100123O0026E2000100CA00010012000414012O00CA00012O0096000300043O0020BE0003000300450020C70003000300222O00800003000200020006090103008102013O000414012O008102012O0096000300243O0006090103008102013O000414012O008102012O0096000300253O0006090103006A02013O000414012O006A02012O0096000300153O0006A80003006D02010001000414012O006D02012O0096000300253O0006A80003008102010001000414012O008102012O0096000300124O0096000400133O0006FE0003008102010004000414012O008102012O00960003000F4O00F2000400043O00202O0004000400454O0005000E3O00202O00050005004600122O000700086O0005000700024O000500056O00030005000200062O0003008102013O000414012O008102012O0096000300103O0012ED000400473O0012ED000500484O0010000300054O002000036O00960003001B3O0026E20003009002010002000414012O009002010012ED000300014O00D5000400043O0026E20003008602010001000414012O008602012O0096000500264O00CE0005000100022O0018000400053O0006090104009002013O000414012O009002012O00C8000400023O000414012O00900201000414012O008602012O0096000300273O000609010300A202013O000414012O00A202012O00960003001B3O000EB7000200A202010003000414012O00A202010012ED000300014O00D5000400043O0026E20003009802010001000414012O009802012O0096000500284O00CE0005000100022O0018000400053O000609010400A202013O000414012O00A202012O00C8000400023O000414012O00A20201000414012O009802012O0096000300293O0020060103000300494O000400043O00202O00040004004A4O00058O000600103O00122O0007004B3O00122O0008004C6O000600086O00033O000200062O0003000B03013O000414012O000B03010012ED0003004D4O00C8000300023O000414012O000B0301000414012O00CA0001000414012O000B03010026E23O00BE02010001000414012O00BE02012O00960001002A4O00CE0001000100022O007A000100024O0096000100023O0006092O0100BD02013O000414012O00BD02012O0096000100024O00C8000100023O0012ED3O00023O0026E23O000100010012000414012O000100010012930001004E3O0006092O0100D302013O000414012O00D302012O00960001002B3O0006092O0100D302013O000414012O00D302010012ED000100013O0026E2000100C702010001000414012O00C702012O00960002002C4O00CE0002000100022O007A000200024O0096000200023O000609010200D302013O000414012O00D302012O0096000200024O00C8000200023O000414012O00D30201000414012O00C702012O0096000100043O0020BE00010001004F0020C70001000100242O00800001000200020006092O01000903013O000414012O000903012O00960001000B3O0006092O01000903013O000414012O000903012O0096000100043O0020BE00010001004F0020C70001000100152O00800001000200020006092O01000903013O000414012O000903012O00960001000C3O0006092O01000903013O000414012O000903012O00960001000D3O0006092O01000903013O000414012O000903012O0096000100053O0020C70001000100162O00800001000200020006A80001000903010001000414012O000903012O0096000100053O0020C70001000100172O00800001000200020006A80001000903010001000414012O000903012O0096000100033O0020BE0001000100182O00960002000E4O00800001000200020006092O01000903013O000414012O000903012O00960001000F4O00C9000200043O00202O00020002004F4O0003000E3O00202O0003000300194O000500043O00202O00050005004F4O0003000500024O000300036O00010003000200062O0001000903013O000414012O000903012O0096000100103O0012ED000200503O0012ED000300514O0010000100034O002000015O0012ED3O00133O000414012O000100012O00C43O00017O00383O00028O00027O0040030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O00D3CA86F83CE5D5CDB0D621E9CD03063O008AA6B9E3BE4E030C3O00DE67C01E51262ADF66CC3C5703073O0079AB14A5573243030C3O00D32BBC1AB814C71AAC24AA1603063O0062A658D956D9030B3O00E3E57C2D87CAF7DA78128E03063O00BC2O961961E6026O00084003103O00CF9A5A2E05EAD29D510B02EAF886531603063O008DBAE93F626C03113O00E4F9298637F8E723A421F8EB208124E7EF03053O0045918A4CD6030E3O0065DC8CBAAB1962C2BA9DAD1F7BCA03063O007610AF2OE9DF030C3O009E973088FB85798E963CB5E903073O001DEBE455DB8EEB026O001040026O001440030F3O0039DBB5D0404729562EE3B3C97F6D2O03083O00325DB4DABD172E4703113O00D8A1494D48EF58D7B6525873D55CD6877F03073O0028BEC43B2C24BC03183O002C57D5B9F56F093544D083FB6B080B4CC8BCD774033566F803073O006D5C25BCD49A1D03133O0017FAAAC734480DE1A3F4384E0CC2ADCD38792003063O003A648FC4A351026O00F03F03113O000F5126802D48F606364B24AB2B47EC001D03083O006E7A2243C35F298503113O0060A25E6FDA70BC5E44C274BD7946D766A503053O00B615D13B2A030B3O00A244C03B28ACB279CA0B2003063O00DED737A57D41030D3O0039C2C33CFEC0E04F1FD9C919F903083O002A4CB1A67A92A18D030D3O00B09900F97078A19911DC707DA003063O0016C5EA65AE1903103O003827A0EB7FA1D3803826BCE879BBD28B03083O00E64D54C5BC16CFB703103O00EC07C3CB89A0E03AF731C8FF84A0FE2103083O00559974A69CECC19003103O00A5F34EB6EA04A5EE4EB6D309B0E86E9703063O0060C4802DD384030D3O00209E2O7EC1ACB1D6318C755CD703083O00B855ED1B3FB2CFD4030C3O001D4A0C7B0756046801570D4C03043O003F683969030E3O001E94A1620E95A5483897AD56029303043O00246BE7C403113O0048A6A7A455B4AB8951BCA58F49BBAB895A03043O00E73DD5C200D53O0012ED3O00013O0026E23O002400010002000414012O00240001001293000100033O0020CF0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O0026E23O00470001000D000414012O00470001001293000100033O0020CF0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100083O00124O00163O0026E23O006A00010017000414012O006A0001001293000100033O0020950001000100044O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00044O00D40001000E030120008D00013O000414012O008D0001001293000100033O0020CF0001000100044O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O000100103O00124O00023O0026E23O00B000010016000414012O00B00001001293000100033O0020CF0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O0003002F3O00122O000400306O0002000400024O0001000100024O000100143O00124O00173O0026E23O000100010001000414012O00010001001293000100033O0020CF0001000100044O000200013O00122O000300313O00122O000400326O0002000400024O0001000100024O000100153O00122O000100033O00202O0001000100044O000200013O00122O000300333O00122O000400346O0002000400024O0001000100024O000100163O00122O000100033O00202O0001000100044O000200013O00122O000300353O00122O000400366O0002000400024O0001000100024O000100173O00122O000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O0001000100024O000100183O00124O00203O000414012O000100012O00C43O00017O003A3O00028O00026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E677303143O001CBE385207AE38601DBF3C7F2EB8347708A33E7603043O001369CD5D030E3O00BC1BDBA02CBD1ADF8D0CA101D89503053O005FC968BEE103183O00BAD8C4E3AECECDDDBBD9CEC387CEC0C2A6C5C6FDBAD9C6CB03043O00AECFABA1027O0040026O001840031D3O00F8ED08D0F4D2ECF01EF6CBC7E4EC04E7CFDEF9F62CF5FEDBE4FD19F6FC03063O00B78D9E6D9398031B3O00391AE3383E0CEB033E3DE9182904D1053801C70A2A05EF0F380CE203043O006C4C698603243O00FED6B4D1C1E2D6BEEFEDE7C0B0EFDDE2CBB6D5C1FFC0BCD6C7FFCD90E7C8E7CCB2F5CBEF03053O00AE8BA5D181026O001C4003153O00B6A0E7E9C3027C71ADB4D1D5D406717597BCF6C4CB03083O0018C3D382A1A6631003133O00470DEA2940025402E50B461F4202E72F563E7603063O00762663894C3303163O00FC2806171A34EF2709351C29F9270B110C07EF29100203063O00409D46657269026O000840026O00144003073O0048ADA6EF3F6F8B03053O007020C8C78303093O0024555DB4EC8401046003073O00424C303CD8A3CB030E3O00AF957CC34ADC23BFB278E158CB3003073O0044DAE619933FAE030D3O00AC39475EB7A1195B45B0B9026303053O00D6CD4A332C03143O00F249E3F07EF44BD1E865FF4DEFC878EE49EFD44703053O00179A2C829C03173O0019A3ACA23F1D1695B9BC33121C92A2BA331E36B4A2BB2603063O007371C6CDCE56026O00104003253O009144FB778552F2499045F157AC52FF568D59F9699145F95FB35EEA52A551F8568D54EA5F8003043O003AE4379E030C3O00A19AD51935A3318781D52F2E03073O0055D4E9B04E5CCD03113O005F4B8DC14B4889E1434C87F07E579CE74703043O00822A38E8030F3O00FFA621D7482AE4B121F1532BE5A72903063O005F8AD5448320031F3O002729A44F653E3AAE4E5E2F29AD4A782D1BB451712F0BB34A62232BA04F5E1A03053O00164A48C123030A3O004175746F536869656C64030A3O002D6CF0571F71ED5D207D03043O00384C198403093O00536869656C6455736503093O004DC9A223C35AF4B82303053O00AF3EA1CB4603103O0010D4C41B2132D4CD14750FD5CA16393803053O00555CBDA37300E63O0012ED3O00013O0026E23O001C00010002000414012O001C0001001293000100033O0020760001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00124O000B3O0026E23O00370001000C000414012O00370001001293000100033O0020760001000100044O000200013O00122O0003000D3O00122O0004000E6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00124O00133O0026E23O00580001000B000414012O00580001001293000100033O0020AE0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O00010001000200062O0001004B00010001000414012O004B00010012ED000100014O007A000100083O0012A1000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O00010001000200062O0001005600010001000414012O005600010012ED000100014O007A000100093O0012ED3O001A3O0026E23O00760001001B000414012O00760001001293000100033O0020AE0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200062O0001006C00010001000414012O006C00010012ED000100014O007A0001000B3O001229000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000C3O00124O000C3O0026E23O009A0001001A000414012O009A0001001293000100033O0020F30001000100044O000200013O00122O000300223O00122O000400236O0002000400024O00010001000200062O0001008200010001000414012O008200010012ED000100014O007A0001000D3O0012A1000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O00010001000200062O0001008D00010001000414012O008D00010012ED000100014O007A0001000E3O0012A1000100033O00202O0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O00010001000200062O0001009800010001000414012O009800010012ED000100014O007A0001000F3O0012ED3O00283O0026E23O00A500010013000414012O00A50001001293000100033O0020FA0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100103O00044O00E500010026E23O00C000010001000414012O00C00001001293000100033O0020760001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O0003002F3O00122O000400306O0002000400024O0001000100024O000100133O00124O00023O000E030128000100013O000414012O00010001001293000100033O0020F30001000100044O000200013O00122O000300313O00122O000400326O0002000400024O00010001000200062O000100CC00010001000414012O00CC00010012ED000100014O007A000100143O00120A2O0100033O00202O0001000100044O000200013O00122O000300343O00122O000400356O0002000400024O00010001000200122O000100333O00122O000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O00010001000200062O000100E200010001000414012O00E200012O0096000100013O0012ED000200393O0012ED0003003A4O00DE0001000300020012182O0100363O0012ED3O001B3O000414012O000100012O00C43O00017O002A3O00028O00026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O000DA523282CA0143D2BB9363E3A03043O005849CC50030B3O000A8A03562CD60C9616403A03063O00BA4EE3702649030B3O00E944F8614173F25CF8414003063O001A9C379D3533030A3O0099CB13EBB95385D91ACA03063O0030ECB876B9D8027O0040030E3O00F1AF5E3EC431F1AE6039DB3CC69903063O005485DD3750AF030D3O00AFE627AFC650AED02DB2CF7F9903063O003CDD8744C6A7030E3O00FBAEFDAB47D8E2A9F09056D6E0B803063O00B98EDD98E32203103O004DD652D24632FB51CB50CA4C27FE57CB03073O009738A5379A2353026O00084003113O00A64A02E6B47100E3A14A0BFD834B00EDAB03043O008EC0236503113O00FF7B3DA6F59EB906C24220B7EFBFB803D803083O0076B61549C387ECCC03163O0021320E45161FE81828354E0814CA00350E450804EE1C03073O009D685C7A20646D03123O008AA8DBCF2F3598BBB792C7D8383485A4AFA203083O00CBC3C6AFAA5D47ED030D3O00264E3FD94519EF3A4430D0792103073O009C4E2B5EB53171030F3O007AEDC5AF024D7E42E7D0AA044D514203073O00191288A4C36B2303113O00C028A8437BB2C688E739A0407C92C0B5ED03083O00D8884DC92F12DCA1034O00030F3O0025ED25DE04D9A32BEA27D30BC8872903073O00E24D8C4BBA68BC026O00104003113O0091CFDE3B43BCE7DE3C40ABDEDF2D4AB8C203053O002FD9AEB05F00A63O0012ED3O00013O0026E23O002400010002000414012O00240001001293000100033O0020CF0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O0026E23O00470001000D000414012O00470001001293000100033O0020CF0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100083O00124O00163O0026E23O006D00010001000414012O006D0001001293000100033O0020F30001000100044O000200013O00122O000300173O00122O000400186O0002000400024O00010001000200062O0001005300010001000414012O005300010012ED000100014O007A000100093O001282000100033O00202O0001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000C3O00124O00023O0026E23O009900010016000414012O00990001001293000100033O0020F30001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O00010001000200062O0001007900010001000414012O007900010012ED000100014O007A0001000D3O0012A1000100033O00202O0001000100044O000200013O00122O000300213O00122O000400226O0002000400024O00010001000200062O0001008400010001000414012O008400010012ED000100014O007A0001000E3O0012A1000100033O00202O0001000100044O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O0001008F00010001000414012O008F00010012ED000100254O007A0001000F3O001229000100033O00202O0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O000100103O00124O00283O000E030128000100013O000414012O00010001001293000100033O0020FA0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00044O00A50001000414012O000100012O00C43O00017O00303O00028O00026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00B9D27303083O0046D8BD1662D234182O033O00D9DBB003053O00B3BABFC3E703063O00FD360BF4FC3303043O0084995F7803073O00BCBB0024F4DEB303073O00C0D1D26E4D97BA027O0040030D3O004973446561644F7247686F737403013O005F03163O00476574456E656D696573496E4D656C2O6552616E6765026O00144003113O00476574456E656D696573496E52616E6765026O004440030F3O00412O66656374696E67436F6D626174030D3O00436C65616E736553706972697403073O004973526561647903093O00466F637573556E6974026O003440026O003940026O0008402O033O00EF0C2103063O00A4806342899F030D3O00546172676574497356616C696403103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E7303063O0042752O665570030E3O00417363656E64616E636542752O6603073O0050726576474344030E3O00436861696E4C696768746E696E67030D3O004C696768746E696E67426F6C74030C3O0049734368612O6E656C696E6703053O00466F637573030F3O0048616E646C65412O666C696374656403143O00506F69736F6E436C65616E73696E67546F74656D026O003E4003093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66030C3O004865616C696E67537572676503153O004865616C696E6753757267654D6F7573656F76657203163O00436C65616E73655370697269744D6F7573656F766572030B3O005472656D6F72546F74656D0096012O0012ED3O00013O0026E23O002400010002000414012O00240001001293000100033O0020CF0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O0026E23O008A0001000D000414012O008A00012O0096000100053O0020C700010001000E2O00800001000200020006092O01002C00013O000414012O002C00012O00C43O00014O00960001000A4O008D0001000100064O000600096O000500083O00122O0004000F3O00122O0003000F6O000200076O000100066O00015O00062O0001005000013O000414012O005000010012ED000100013O0026E20001004300010002000414012O004300012O0096000200053O0020EF00020002001000122O000400116O0002000400024O0002000B6O0002000B6O000200026O0002000C3O00044O006000010026E20001003800010001000414012O003800012O0096000200053O00207500020002001200122O000400136O0002000400024O0002000D6O0002000D6O000200026O0002000E3O00122O000100023O00044O00380001000414012O006000010012ED000100013O0026E20001005800010001000414012O005800012O001101026O007A0002000D3O0012ED000200024O007A0002000E3O0012ED000100023O0026E20001005100010002000414012O005100012O001101026O007A0002000B3O0012ED000200024O007A0002000C3O000414012O00600001000414012O005100012O0096000100053O0020C70001000100142O00800001000200020006A80001006800010001000414012O006800012O00960001000F3O0006092O01008900013O000414012O008900010012ED000100014O00D5000200023O0026E20001007200010002000414012O007200012O0096000300103O0006090103008900013O000414012O008900012O0096000300104O00C8000300023O000414012O008900010026E20001006A00010001000414012O006A00012O00960003000F3O0006B10002007E00010003000414012O007E00012O0096000300113O0020BE0003000300150020C70003000300162O00800003000200020006B10002007E00010003000414012O007E00012O0096000200034O0096000300123O0020380003000300174O000400026O000500133O00122O000600186O000700073O00122O000800196O0003000800024O000300103O00122O000100023O00044O006A00010012ED3O001A3O000E032O01009B00013O000414012O009B00012O0096000100144O00730001000100014O000100156O0001000100014O000100166O00010001000100122O000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O000100173O00124O00023O0026E23O00010001001A000414012O000100012O0096000100123O0020BE00010001001D2O00CE0001000100020006A8000100A700010001000414012O00A700012O0096000100053O0020C70001000100142O00800001000200020006092O0100C000013O000414012O00C000010012ED000100013O000E032O0100B300010001000414012O00B300012O0096000200193O0020FC00020002001E4O000300036O000400016O0002000400024O000200186O000200186O0002001A3O00122O000100023O0026E2000100A800010002000414012O00A800012O00960002001A3O0026E2000200C00001001F000414012O00C000012O0096000200193O0020400002000200204O0003000B6O00048O0002000400024O0002001A3O00044O00C00001000414012O00A800012O0096000100053O0020C70001000100142O00800001000200020006092O0100E300013O000414012O00E300012O0096000100053O0020900001000100214O000300113O00202O0003000300224O00010003000200062O000100E300013O000414012O00E300012O0096000100053O00208C00010001002300122O000300026O000400113O00202O0004000400244O00010004000200062O000100D800013O000414012O00D800012O0096000100113O0020BE0001000100242O007A0001001B3O000414012O00E300012O0096000100053O00208C00010001002300122O000300026O000400113O00202O0004000400254O00010004000200062O000100E300013O000414012O00E300012O0096000100113O0020BE0001000100252O007A0001001B4O0096000100053O0020C70001000100262O00800001000200020006A8000100952O010001000414012O00952O012O0096000100053O0020C70001000100262O00800001000200020006A8000100952O010001000414012O00952O010012ED000100013O0026E20001006F2O010001000414012O006F2O01001293000200273O000609010200032O013O000414012O00032O012O00960002000F3O000609010200032O013O000414012O00032O010012ED000200013O000E032O0100F700010002000414012O00F700012O00960003001C4O00CE0003000100022O007A000300104O0096000300103O000609010300032O013O000414012O00032O012O0096000300104O00C8000300023O000414012O00032O01000414012O00F700012O00960002001D3O0006090102006E2O013O000414012O006E2O010012ED000200013O000E030102003E2O010002000414012O003E2O012O00960003001E3O0006090103001F2O013O000414012O001F2O010012ED000300013O0026E20003000D2O010001000414012O000D2O012O0096000400123O00209F0004000400284O000500113O00202O0005000500294O000600113O00202O00060006002900122O0007002A6O0004000700024O000400106O000400103O00062O0004001F2O013O000414012O001F2O012O0096000400104O00C8000400023O000414012O001F2O01000414012O000D2O012O0096000300053O00207E00030003002B4O000500113O00202O00050005002C4O000300050002000E2O0011006E2O010003000414012O006E2O012O00960003001F3O0006090103006E2O013O000414012O006E2O010012ED000300013O0026E20003002A2O010001000414012O002A2O012O0096000400123O00201D0004000400284O000500113O00202O00050005002D4O000600133O00202O00060006002E00122O000700136O000800016O0004000800024O000400106O000400103O00062O0004006E2O013O000414012O006E2O012O0096000400104O00C8000400023O000414012O006E2O01000414012O002A2O01000414012O006E2O01000E032O0100072O010002000414012O00072O012O0096000300203O000609010300562O013O000414012O00562O010012ED000300013O0026E2000300442O010001000414012O00442O012O0096000400123O00209F0004000400284O000500113O00202O0005000500154O000600133O00202O00060006002F00122O000700136O0004000700024O000400106O000400103O00062O000400562O013O000414012O00562O012O0096000400104O00C8000400023O000414012O00562O01000414012O00442O012O0096000300213O0006090103006C2O013O000414012O006C2O010012ED000300013O0026E20003005A2O010001000414012O005A2O012O0096000400123O00209F0004000400284O000500113O00202O0005000500304O000600113O00202O00060006003000122O0007002A6O0004000700024O000400106O000400103O00062O0004006C2O013O000414012O006C2O012O0096000400104O00C8000400023O000414012O006C2O01000414012O005A2O010012ED000200023O000414012O00072O010012ED000100023O000E03010200EE00010001000414012O00EE00012O0096000200053O0020C70002000200142O0080000200020002000609010200842O013O000414012O00842O010012ED000200013O0026E2000200772O010001000414012O00772O012O0096000300224O00CE0003000100022O007A000300104O0096000300103O000609010300952O013O000414012O00952O012O0096000300104O00C8000300023O000414012O00952O01000414012O00772O01000414012O00952O010012ED000200013O0026E2000200852O010001000414012O00852O012O0096000300234O00CE0003000100022O007A000300104O0096000300103O000609010300952O013O000414012O00952O012O0096000300104O00C8000300023O000414012O00952O01000414012O00852O01000414012O00952O01000414012O00EE0001000414012O00952O01000414012O000100012O00C43O00017O00073O00028O00026O00F03F03053O005072696E7403313O002587E1BF0E8AECB30587FDFE3381E8B30187A9BC19C9CCAE098AA7FE339CF9AE0F9BFDBB04C9EBA74091C2BF0E8CFDB14E03043O00DE60E98903103O00466C616D6553686F636B446562752O6603143O00526567697374657241757261547261636B696E6700163O0012ED3O00013O0026E23O000B00010002000414012O000B00012O009600015O0020510001000100034O000200013O00122O000300043O00122O000400056O000200046O00013O000100044O00150001000E032O01000100013O000414012O000100012O0096000100023O0020CB00010001000600202O0001000100074O0001000200014O000100036O00010001000100124O00023O00044O000100012O00C43O00017O00", GetFEnv(), ...);
