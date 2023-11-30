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
				if (Enum <= 159) then
					if (Enum <= 79) then
						if (Enum <= 39) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
											else
												Stk[Inst[2]] = #Stk[Inst[3]];
											end
										elseif (Enum <= 2) then
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
										elseif (Enum == 3) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									elseif (Enum <= 6) then
										if (Enum == 5) then
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
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										end
									elseif (Enum <= 7) then
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									elseif (Enum == 8) then
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum > 10) then
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
									elseif (Enum <= 12) then
										if (Inst[2] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 13) then
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
								elseif (Enum <= 16) then
									if (Enum == 15) then
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
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
									end
								elseif (Enum <= 17) then
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
								elseif (Enum > 18) then
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
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum == 20) then
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
									elseif (Enum <= 22) then
										local A = Inst[2];
										local Results = {Stk[A](Stk[A + 1])};
										local Edx = 0;
										for Idx = A, Inst[4] do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif (Enum == 23) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 26) then
									if (Enum > 25) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
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
									end
								elseif (Enum <= 27) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
								end
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum == 30) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 32) then
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
								elseif (Enum == 33) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
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
							elseif (Enum <= 36) then
								if (Enum == 35) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 37) then
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
							elseif (Enum > 38) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 59) then
							if (Enum <= 49) then
								if (Enum <= 44) then
									if (Enum <= 41) then
										if (Enum == 40) then
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]];
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
											Stk[Inst[2]] = Stk[Inst[3]];
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
									elseif (Enum <= 42) then
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
									elseif (Enum == 43) then
										local A;
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
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 46) then
									if (Enum == 45) then
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 47) then
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
								elseif (Enum > 48) then
									do
										return Stk[Inst[2]]();
									end
								else
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 54) then
								if (Enum <= 51) then
									if (Enum == 50) then
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
								elseif (Enum <= 52) then
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
								elseif (Enum == 53) then
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
									VIP = Inst[3];
								end
							elseif (Enum <= 56) then
								if (Enum == 55) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
							elseif (Enum <= 57) then
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
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 58) then
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
						elseif (Enum <= 69) then
							if (Enum <= 64) then
								if (Enum <= 61) then
									if (Enum > 60) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 62) then
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
								elseif (Enum > 63) then
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								else
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 66) then
								if (Enum == 65) then
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
								else
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 68) then
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
						elseif (Enum <= 74) then
							if (Enum <= 71) then
								if (Enum == 70) then
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 72) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
								end
							elseif (Enum > 73) then
								if (Stk[Inst[2]] ~= Inst[4]) then
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
						elseif (Enum <= 76) then
							if (Enum == 75) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 77) then
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
						elseif (Enum > 78) then
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
						elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
						end
					elseif (Enum <= 119) then
						if (Enum <= 99) then
							if (Enum <= 89) then
								if (Enum <= 84) then
									if (Enum <= 81) then
										if (Enum > 80) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 82) then
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
									elseif (Enum == 83) then
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
									else
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
									end
								elseif (Enum <= 86) then
									if (Enum == 85) then
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 87) then
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
								elseif (Enum > 88) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								else
									local T;
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
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
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
									T = Stk[A];
									for Idx = A + 1, Top do
										Insert(T, Stk[Idx]);
									end
								end
							elseif (Enum <= 94) then
								if (Enum <= 91) then
									if (Enum > 90) then
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
								elseif (Enum <= 92) then
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								elseif (Enum == 93) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 96) then
								if (Enum > 95) then
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
							elseif (Enum <= 97) then
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
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 98) then
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
						elseif (Enum <= 109) then
							if (Enum <= 104) then
								if (Enum <= 101) then
									if (Enum == 100) then
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
										Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 103) then
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
							elseif (Enum <= 106) then
								if (Enum > 105) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								else
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 107) then
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
							elseif (Enum == 108) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 114) then
							if (Enum <= 111) then
								if (Enum == 110) then
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
							elseif (Enum <= 112) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 113) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 116) then
							if (Enum == 115) then
								do
									return Stk[Inst[2]];
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
						elseif (Enum <= 117) then
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
						elseif (Enum > 118) then
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
						elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 139) then
						if (Enum <= 129) then
							if (Enum <= 124) then
								if (Enum <= 121) then
									if (Enum == 120) then
										local A = Inst[2];
										local T = Stk[A];
										local B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									elseif (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 122) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								elseif (Enum > 123) then
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
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 126) then
								if (Enum > 125) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 127) then
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
							elseif (Enum == 128) then
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
						elseif (Enum <= 134) then
							if (Enum <= 131) then
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
									if Stk[Inst[2]] then
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
							elseif (Enum <= 132) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							elseif (Enum > 133) then
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 136) then
							if (Enum == 135) then
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
						elseif (Enum <= 137) then
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
						elseif (Enum == 138) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 149) then
						if (Enum <= 144) then
							if (Enum <= 141) then
								if (Enum > 140) then
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
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum <= 142) then
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
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 143) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 146) then
							if (Enum == 145) then
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
						elseif (Enum <= 147) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum > 148) then
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
					elseif (Enum <= 154) then
						if (Enum <= 151) then
							if (Enum == 150) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						elseif (Enum <= 152) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum == 153) then
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 156) then
						if (Enum > 155) then
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 158) then
						local A = Inst[2];
						Top = (A + Varargsz) - 1;
						for Idx = A, Top do
							local VA = Vararg[Idx - A];
							Stk[Idx] = VA;
						end
					elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
						Stk[Inst[2]] = Env;
					else
						Stk[Inst[2]] = Env[Inst[3]];
					end
				elseif (Enum <= 239) then
					if (Enum <= 199) then
						if (Enum <= 179) then
							if (Enum <= 169) then
								if (Enum <= 164) then
									if (Enum <= 161) then
										if (Enum > 160) then
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
											Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										end
									elseif (Enum <= 162) then
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
									elseif (Enum == 163) then
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
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]];
									end
								elseif (Enum <= 166) then
									if (Enum == 165) then
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
								elseif (Enum <= 167) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum == 168) then
									local B;
									local A;
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
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							elseif (Enum <= 174) then
								if (Enum <= 171) then
									if (Enum > 170) then
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
										local T;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 172) then
									if (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 173) then
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
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
								end
							elseif (Enum <= 176) then
								if (Enum > 175) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 177) then
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
							elseif (Enum == 178) then
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
									if (Mvm[1] == 164) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
						elseif (Enum <= 189) then
							if (Enum <= 184) then
								if (Enum <= 181) then
									if (Enum == 180) then
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
								elseif (Enum <= 182) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 183) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 186) then
								if (Enum > 185) then
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
									if Stk[Inst[2]] then
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
							elseif (Enum <= 187) then
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
							elseif (Enum == 188) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 194) then
							if (Enum <= 191) then
								if (Enum == 190) then
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 192) then
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
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 193) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 196) then
							if (Enum == 195) then
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
						elseif (Enum <= 197) then
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
						elseif (Enum == 198) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Top do
								Insert(T, Stk[Idx]);
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
					elseif (Enum <= 219) then
						if (Enum <= 209) then
							if (Enum <= 204) then
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
								elseif (Enum <= 202) then
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
								elseif (Enum == 203) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
								end
							elseif (Enum <= 206) then
								if (Enum == 205) then
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
							elseif (Enum <= 207) then
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
							elseif (Enum > 208) then
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
						elseif (Enum <= 214) then
							if (Enum <= 211) then
								if (Enum > 210) then
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
								elseif (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 212) then
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
							elseif (Enum == 213) then
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
							elseif (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 216) then
							if (Enum == 215) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 217) then
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
						elseif (Enum == 218) then
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
					elseif (Enum <= 229) then
						if (Enum <= 224) then
							if (Enum <= 221) then
								if (Enum == 220) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 222) then
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
							elseif (Enum > 223) then
								if (Stk[Inst[2]] < Inst[4]) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 226) then
							if (Enum > 225) then
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
								Stk[Inst[2]] = Inst[3];
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							else
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 227) then
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
						elseif (Enum == 228) then
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
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 234) then
						if (Enum <= 231) then
							if (Enum == 230) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							else
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 232) then
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
						elseif (Enum == 233) then
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
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						end
					elseif (Enum <= 236) then
						if (Enum > 235) then
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
					elseif (Enum <= 237) then
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
					elseif (Enum == 238) then
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
					elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 279) then
					if (Enum <= 259) then
						if (Enum <= 249) then
							if (Enum <= 244) then
								if (Enum <= 241) then
									if (Enum == 240) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									else
										local B;
										local T;
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
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 242) then
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
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 243) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 246) then
								if (Enum > 245) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 247) then
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
							elseif (Enum > 248) then
								local Edx;
								local Results, Limit;
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
						elseif (Enum <= 254) then
							if (Enum <= 251) then
								if (Enum > 250) then
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
							elseif (Enum <= 252) then
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
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 253) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 256) then
							if (Enum == 255) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							else
								Upvalues[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 257) then
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
						elseif (Enum == 258) then
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
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 269) then
						if (Enum <= 264) then
							if (Enum <= 261) then
								if (Enum == 260) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 262) then
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
							elseif (Enum > 263) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 266) then
							if (Enum > 265) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]]();
							end
						elseif (Enum <= 267) then
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
						elseif (Enum == 268) then
							if not Stk[Inst[2]] then
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
					elseif (Enum <= 274) then
						if (Enum <= 271) then
							if (Enum == 270) then
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
						elseif (Enum <= 272) then
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
						elseif (Enum > 273) then
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
					elseif (Enum <= 276) then
						if (Enum == 275) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 277) then
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
					elseif (Enum > 278) then
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
				elseif (Enum <= 299) then
					if (Enum <= 289) then
						if (Enum <= 284) then
							if (Enum <= 281) then
								if (Enum == 280) then
									Stk[Inst[2]] = not Stk[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
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
							elseif (Enum <= 282) then
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
							elseif (Enum == 283) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 286) then
							if (Enum == 285) then
								Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
						elseif (Enum <= 287) then
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
						elseif (Enum == 288) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 294) then
						if (Enum <= 291) then
							if (Enum > 290) then
								local B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
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
						elseif (Enum <= 292) then
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
						elseif (Enum > 293) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 296) then
						if (Enum == 295) then
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
					elseif (Enum <= 297) then
						Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
					elseif (Enum > 298) then
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
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 309) then
					if (Enum <= 304) then
						if (Enum <= 301) then
							if (Enum > 300) then
								do
									return;
								end
							else
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 302) then
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
						elseif (Enum == 303) then
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
					elseif (Enum <= 306) then
						if (Enum == 305) then
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
					elseif (Enum <= 307) then
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
					elseif (Enum == 308) then
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
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 314) then
					if (Enum <= 311) then
						if (Enum > 310) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 312) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 313) then
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
				elseif (Enum <= 316) then
					if (Enum > 315) then
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
				elseif (Enum <= 317) then
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
					Stk[A](Unpack(Stk, A + 1, Top));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
				elseif (Enum == 318) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503183O00F4D3D23DD993D210C5C6C91AD5AED508D8D5DA29A8B7D21F03083O007EB1A3BB4586DBA703183O00A53EB653E8C3C88E3ABA59E8D8C89238B65DD6E7938C3BBE03073O00BDE04EDF2BB78B002E3O0012193O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100045B3O000A000100129F000300063O0020F000040003000700129F000500083O0020F000050005000900129F000600083O0020F000060006000A0006B200073O000100062O00A43O00064O00A48O00A43O00044O00A43O00014O00A43O00024O00A43O00053O0020F000080003000B0020F000090003000C2O00FD000A5O00129F000B000D3O0006B2000C0001000100022O00A43O000A4O00A43O000B4O00A4000D00073O0012E7000E000E3O0012E7000F000F4O0093000D000F00020006B2000E0002000100032O00A43O00074O00A43O00094O00A43O00084O0028010A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O004500025O00122O000300016O00045O00122O000500013O00042O0003002100012O008A00076O0041000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O008A000C00034O0020000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O003E010C6O007B000A3O0002002007000A000A00022O002B0109000A4O002C01073O00010004B90003000500012O008A000300054O00A4000400024O0082000300044O007A00036O002D012O00017O000C3O00028O00025O001AB040026O00F03F025O00ADB240026O001840025O00809440025O0068AA40025O00349940025O00CCA640025O0064B040025O00A88F40025O0058804001403O0012E7000200014O003F000300043O002E0C0002002B0001000200045B3O002D000100260D0002002D0001000300045B3O002D00010012E7000500013O00264A0005000B0001000100045B3O000B0001002ED6000400070001000500045B3O00070001002E0C000600080001000600045B3O0013000100260D000300130001000300045B3O001300012O00A4000600044O009E00076O009800066O007A00065O00260D000300060001000100045B3O000600010012E7000600013O00264A0006001A0001000300045B3O001A0001002ED60007001C0001000800045B3O001C00010012E7000300033O00045B3O00060001000EB0000100160001000600045B3O001600012O008A00076O00A7000400073O00060C010400270001000100045B3O002700012O008A000700014O00A400086O009E00096O009800076O007A00075O0012E7000600033O00045B3O0016000100045B3O0006000100045B3O0007000100045B3O0006000100045B3O003F0001002ED2000900020001000A00045B3O0002000100260D000200020001000100045B3O000200010012E7000500013O00264A000500360001000300045B3O00360001002ED2000B00380001000C00045B3O003800010012E7000200033O00045B3O0002000100260D000500320001000100045B3O003200010012E7000300014O003F000400043O0012E7000500033O00045B3O0032000100045B3O000200012O002D012O00017O00773O0003073O00457069634C696203093O0045706963436163686503043O0016C323D103053O009C43AD4AA503063O0004BB480FB93403073O002654D72976DC4603063O0064173015FB4403053O009E3076427203053O008D2B13236003073O009BCB44705613C503093O006BD223EF4557F3FD5403083O009826BD569C2018852O033O00CC52B303043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A030A3O0034AADDCB841F241CB3DD03073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003053O0091C2D4180D03063O004BDCA3B76A6203053O0023B5AE18F703053O00B962DAEB5703053O00E81834C9F003063O00CAAB5C4786BE03043O000AC03F9C03043O00E849A14C03053O008BCB474E0D03053O007EDBB9223D03073O002FC1537F7179E003083O00876CAE3E121E179303083O0093FF2FD901A13DC203083O00A7D6894AAB78CE532O033O0085E53F03063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D903043O00CA212F8C03073O009CA84E40E0D47903073O00902702F1DF55A003063O003BD3486F9CB003083O006B91E63F5788ED2803043O004D2EE78303063O009241B854BF4603043O0020DA34D603083O007D0223BEF8A6445603083O003A2E7751C891D02503063O0003993EB8ACAF03073O00564BEC50CCC9DD03083O0041546593F79D734D03063O00EB122117E59E03113O0071B6C6BE44B2C0A960AFDBA15CBFE3B44803043O00DB30DAA103023O004944030F3O00C9707240D868F2ED747A5DD45DE3EC03073O008084111C29BB2F03063O002927082E581303053O003D6152665A03083O009F3BB95DCE411F0503083O0069CC4ECB2BA7377E030C3O0047657445717569706D656E74026O002A40028O00026O002C4003103O005265676973746572466F724576656E7403183O00958602272O36F874949F0A2E3E21E9659A890B3F3D23E27503083O0031C5CA437E7364A703093O00044ED2248F586E324F03073O003E573BBF49E036030A3O00D417F7C4E80CCACCF35003043O00A987629A030A3O00F8622959F23DF8CE637703073O00A8AB1744349D53030A3O00C764F8A02A23B7F165A103073O00E7941195CD454D030A3O00B3B2CAF658F1B0A2D3AE03063O009FE0C7A79B37024O0080B3C540030C3O00DAFC32D5F8FC2FD7D5FA28D703043O00B297935C030B3O004973417661696C61626C65030C3O00A1F242351D436989DF45261703073O001AEC9D2C52722C03043O00436F7374030C3O00182FC54F253CE64F3827DE5E03043O003B4A4EB503053O0009C4545DB603053O00D345B12O3A026O002040026O001440030E3O00DB3D7CD2F7D1BD0DC02C77D9FEC603083O004E886D399EBB82E203143O00121AD8C3101ADDCE0D0FDCDD1200D0DF010BD8D303043O00915E5F9903143O00CDE135EC6B85C2FF31F26B99C2E83AF46C9BD8E903063O00D79DAD74B52E030C3O0002BD87F6DC3CA68ED0D538B603053O00BA55D4EB92030C3O00F18904FF29E05DCEA319F33B03073O0038A2E1769E598E030D3O006C0DC5BD2DD5530BC58D2DD55E03063O00B83C65A0CF42030C3O00078D70BD258B70B9138D71BE03043O00DC51E21C03123O0024DC8EFFECCE01D0A0F4E7C537D080EEECC103063O00A773B5E29B8A03123O00D12AF55D6B7FC3EE00E8517955C3E037E15A03073O00A68242873C1B1103133O007442CB673F4945C070124B47CC5135465FC87303053O0050242AAE1503123O00781F3B7B5A193B7F6C1F3A786A15356F481603043O001A2E705703063O0053657441504C025O00E06F40002O023O00B6000100033O00122O000300013O00122O000400026O00055O00122O000600033O00122O000700046O0005000700024O0005000300054O00065O00122O000700053O00122O000800066O0006000800024O0006000500064O00075O00122O000800073O00122O000900086O0007000900024O0007000500074O00085O00122O000900093O00122O000A000A6O0008000A00024O0008000500084O00095O00122O000A000B3O00122O000B000C6O0009000B00024O0009000500094O000A5O00122O000B000D3O00122O000C000E6O000A000C00024O000A0005000A4O000B5O00122O000C000F3O00122O000D00106O000B000D00024O000B0003000B4O000C5O00122O000D00113O00122O000E00126O000C000E00024O000C0003000C4O000D5O00122O000E00133O00122O000F00146O000D000F00024O000D0003000D4O000E5O00122O000F00153O00122O001000166O000E001000024O000E0003000E4O000F5O00122O001000173O00122O001100186O000F001100024O000F0003000F4O00105O00122O001100193O00122O0012001A6O0010001200024O0010000300104O00115O00122O0012001B3O00122O0013001C6O0011001300024O0011000300114O00125O00122O0013001D3O00122O0014001E6O0012001400024O0012000300124O00135O00122O0014001F3O00122O001500206O0013001500024O0013000300134O00145O00122O001500213O001242001600226O0014001600024O0014000300144O00155O00122O001600233O00122O001700246O0015001700024O0014001400154O00155O00122O001600253O001242001700266O0015001700024O0014001400154O00155O00122O001600273O00122O001700286O0015001700024O0015000300154O00165O00122O001700293O0012E70018002A4O00930016001800022O00670015001500164O00165O00122O0017002B3O00122O0018002C6O0016001800024O0015001500164O00168O00178O00188O0019002E3O0006B2002F3O000100162O00A43O00194O008A8O00A43O001B4O00A43O001C4O00A43O001D4O00A43O00264O00A43O00274O00A43O00284O00A43O00294O00A43O00244O00A43O00254O00A43O00224O00A43O00234O00A43O001E4O00A43O001F4O00A43O00204O00A43O00214O00A43O002A4O00A43O002B4O00A43O002C4O00A43O002D4O00A43O002E4O005800305O00122O0031002D3O00122O0032002E6O0030003200024O0030000300304O00315O00122O0032002F3O00122O003300306O0031003300024O0030003000314O00315O00122O003200313O00122O003300326O0031003300024O0031000B00314O00325O00122O003300333O00122O003400346O0032003400024O0031003100324O00325O00122O003300353O00122O003400366O0032003400024O0032000D00324O00335O00122O003400373O00122O003500386O0033003500024O0032003200334O003300016O00345O00122O003500393O00122O0036003A6O0034003600024O00340032003400202O00340034003B4O0034000200024O00355O00122O0036003C3O00122O0037003D6O0035003700024O00350032003500202O00350035003B4O003500366O00333O00012O008A00345O0012E70035003E3O0012E70036003F4O00930034003600022O00A70034000F00342O001400355O00122O003600403O00122O003700416O0035003700024O00340034003500202O0035000600424O0035000200020020F0003600350043000670003600C900013O00045B3O00C900012O00A40036000D3O0020F00037003500432O001000360002000200060C013600CC0001000100045B3O00CC00012O00A40036000D3O0012E7003700444O00100036000200020020F0003700350045000670003700D400013O00045B3O00D400012O00A40037000D3O0020F00038003500452O001000370002000200060C013700D70001000100045B3O00D700012O00A40037000D3O0012E7003800444O00100037000200020020EA0038000300460006B2003A0001000100052O00A43O00354O00A43O00064O00A43O00364O00A43O000D4O00A43O00374O00F1003B5O00122O003C00473O00122O003D00486O003B003D6O00383O00014O003800056O00395O00122O003A00493O00122O003B004A6O0039003B00024O0039003100394O003A5O00122O003B004B3O00122O003C004C6O003A003C00024O003A0031003A4O003B5O00122O003C004D3O00122O003D004E6O003B003D00024O003B0031003B4O003C5O00122O003D004F3O00122O003E00506O003C003E00024O003C0031003C4O003D5O00122O003E00513O00122O003F00526O003D003F00024O003D0031003D4O0038000500012O003F0039003A3O0012E7003B00533O0012E7003C00534O0014013D5O00122O003E00543O00122O003F00556O003D003F00024O003D0031003D00202O003D003D00564O003D0002000200062O003D00132O013O00045B3O00132O012O008A003D5O0012E8003E00573O00122O003F00586O003D003F00024O003D0031003D00202O003D003D00594O003D0002000200062O003D001A2O01000100045B3O001A2O012O008A003D5O001259003E005A3O00122O003F005B6O003D003F00024O003D0031003D00202O003D003D00594O003D000200022O008A003E5O001259003F005C3O00122O0040005D6O003E004000024O003E0031003E00202O003E003E00564O003E00020002000670003E00262O013O00045B3O00262O010012E7003E005E3O00060C013E00272O01000100045B3O00272O010012E7003E005F3O0020EA003F000300460006B200410002000100042O00A43O003D4O00A43O00314O008A8O00A43O003E4O003D01425O00122O004300603O00122O004400616O0042004400024O00435O00122O004400623O00122O004500636O004300456O003F3O000100202O003F000300460006B200410003000100022O00A43O003B4O00A43O003C4O00D800425O00122O004300643O00122O004400656O004200446O003F3O00014O003F00044O00AA00405O00122O004100663O00122O004200676O0040004200024O0040003100404O00415O00122O004200683O00122O004300696O0041004300024O0041003100414O00425O00122O0043006A3O00122O0044006B6O0042004400024O0042003100424O00435O00122O0044006C3O00122O0045006D6O0043004500024O0043003100434O003F000400012O00FD004000044O00AA00415O00122O0042006E3O00122O0043006F6O0041004300024O0041003100414O00425O00122O004300703O00122O004400716O0042004400024O0042003100424O00435O00122O004400723O00122O004500736O0043004500024O0043003100434O00445O00122O004500743O00122O004600756O0044004600024O0044003100444O0040000400010006B200410004000100032O008A3O00014O00A43O00064O008A3O00023O0006B200420005000100012O00A43O00313O0006B200430006000100012O00A43O00313O0006B200440007000100012O00A43O00313O0006B200450008000100012O00A43O00313O0006B200460009000100042O00A43O00314O008A8O00A43O00064O00A43O00413O0006B20047000A000100012O00A43O00313O0006B20048000B000100012O00A43O00313O0006B20049000C000100022O00A43O00314O008A7O0006B2004A000D000100012O00A43O00313O0006B2004B000E000100012O00A43O00313O0006B2004C000F0001000A2O00A43O00074O00A43O003E4O00A43O00064O00A43O00314O008A8O00A43O00134O00A43O002C4O00A43O00084O00A43O00344O00A43O00323O0006B2004D0010000100072O00A43O00324O008A8O00A43O00064O00A43O00134O00A43O00344O00A43O00314O00A43O00333O0006B2004E00110001000B2O00A43O00064O00A43O00314O008A8O00A43O00134O00A43O00074O00A43O001A4O00A43O004D4O00A43O002E4O00A43O003E4O00A43O002C4O00A43O003C3O0006B2004F0012000100122O00A43O00314O008A8O00A43O00134O00A43O00074O00A43O00184O00A43O00064O00A43O003F4O00A43O00394O00A43O003E4O00A43O00304O00A43O003A4O00A43O00444O00A43O00484O00A43O00414O00A43O00434O00A43O00404O00A43O00424O00A43O00493O0006B200500013000100192O00A43O00314O008A8O00A43O00064O00A43O003D4O00A43O00394O00A43O00134O00A43O00074O00A43O003E4O00A43O00414O00A43O00304O00A43O003A4O00A43O00424O00A43O004A4O00A43O00184O00A43O00434O008A3O00014O008A3O00024O00A43O00474O00A43O003F4O00A43O003C4O00A43O00454O00A43O00404O00A43O00444O00A43O00464O00A43O004B3O0006B200510014000100252O00A43O00304O00A43O00064O00A43O003C4O00A43O00034O00A43O003A4O00A43O003B4O00A43O00234O00A43O00314O008A8O00A43O00134O00A43O00264O00A43O000A4O00A43O00384O00A43O00244O00A43O00274O00A43O00284O00A43O00184O00A43O00074O00A43O00394O00A43O004F4O00A43O004E4O00A43O00174O00A43O00504O00A43O00164O00A43O004C4O00A43O002A4O00A43O001F4O00A43O00324O00A43O00344O00A43O002E4O00A43O002C4O00A43O00094O00A43O002B4O00A43O003E4O008A3O00014O008A3O00024O00A43O002F3O0006B200520015000100022O00A43O00034O008A7O0020A900530003007600122O005400776O005500516O005600526O0053005600016O00013O00163O007A3O00028O00025O009EAF40027O0040026O00F03F030C3O004570696353652O74696E677303083O0034EBB1DA0EE0A2DD03043O00AE678EC5030A3O00633B5A0A245DF157244C03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E03103O006D4D000122EC1E5150021928F91B575003073O0072383E6549478D03083O008BECCFD0B1E7DCD703043O00A4D889BB03113O00FAE330BEAFF00CE2E925BBA9F025D3EB3403073O006BB28651D2C69E03083O002O0B96D2A336099103053O00CA586EE2A6030F3O00EB0A83FBC3CD08B2F8DECA008CDFFA03053O00AAA36FE297026O000840025O00A4AF40025O00749540026O001040025O00349040025O0026B14003083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC03093O0009BC847EE66F712AAA03073O00185CCFE12C831903083O0078D6AC5812734CC003063O001D2BB3D82C7B030A3O0088CA2561B8D7247CB8CD03043O002CDDB940025O00FC9540025O00FC9D40025O00BCA340025O00D49A4003083O0032E25C4B7A0FE05B03053O00136187283F03093O0083593D3F1F34BA742O03063O0051CE3C535B4F03083O007DAEC46626CD4AB703083O00C42ECBB0124FA32D030F3O008D317B3B3CF3E6B4236C1F30F2E0B603073O008FD8421E7E449B025O0048AC40025O005CA040025O00EC9A40025O001EA340025O00BC9240025O00AEAB4003083O00D64B641EEC40771903043O006A852E10030D3O006B357EF1554E682567CF564F4C03063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A92030C3O006C454ECE618382076D444AED03083O006B39362B9D15E6E7025O00449940025O008EA940025O001AA840025O0038924003083O0074C921C80D49CB2603053O006427AC55BC03123O008476AD8521BF6DA99407A56ABC933BA274BD03053O0053CD18D9E003083O00D5C0D929EFCBCA2E03043O005D86A5AD03063O008BE1C4F23FDA03083O001EDE92A1A25AAED2025O008DB140025O0026AC40025O0036A640025O003EA740025O00149F40025O00C06540025O00206A40025O00D2A040025O00909F40025O00D89E4003083O002235A62C47392E0203073O00497150D2582E57030E3O00B43FC83AE28020D91AF49523C31703053O0087E14CAD7203083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030D3O0085D811FC6CFEBEC91FFE7DDE9D03063O0096CDBD709018025O000C9540025O0040954003083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FD1113D6A46E93C40B30DAA274B5C00A0903073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103163O0085A70541A4F9DABCBD3E4ABAF2F8A4A00541BAE2DCB803073O00AFCCC97124D68B03083O0099CD19DFCCADD0F203083O0081CAA86DABA5C3B7030E3O0007403FD1D215F4234C3ED7D03CD603073O0086423857B8BE7403083O000F341DAF10E52O2603083O00555C5169DB798B4103083O00C8A055716EDEF3A203063O00BF9DD330251C03083O00EC1AE00833D118E703053O005ABF7F947C030A3O004D942B3F79953E18778903043O007718E74E03083O00B128B15ED54E169103073O0071E24DC52ABC20030C3O000F05F19D3B04E4BA3518D99A03043O00D55A7694026O00144003083O00682BA042445529A703053O002D3B4ED43603133O00254586AA953EA8F30459859F8E2B88F1175A8603083O00907036E3EBE64ECD009A012O0012E73O00013O002E0C000200460001000200045B3O0047000100260D3O00470001000100045B3O004700010012E7000100013O00260D0001000A0001000300045B3O000A00010012E73O00043O00045B3O0047000100260D000100250001000100045B3O0025000100129F000200054O002E010300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O00025O00122O000200056O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200034O000200023O00122O000100043O00260D000100060001000400045B3O0006000100129F000200054O00B1000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000300013O00122O000400103O00122O000500116O0003000500024O00020002000300062O000200350001000100045B3O003500010012E7000200015O00010200033O0012DA000200056O000300013O00122O000400123O00122O000500136O0003000500024O0002000200034O000300013O00122O000400143O00122O000500156O0003000500024O00020002000300062O000200440001000100045B3O004400010012E7000200015O00010200043O0012E7000100033O00045B3O0006000100260D3O009E0001001600045B3O009E00010012E7000100014O003F000200023O002ED20018004B0001001700045B3O004B000100260D0001004B0001000100045B3O004B00010012E7000200013O00260D000200540001000300045B3O005400010012E73O00193O00045B3O009E000100260D0002007B0001000100045B3O007B00010012E7000300013O000E790001005B0001000300045B3O005B0001002ED2001B00740001001A00045B3O0074000100129F000400054O002E010500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000400053O00122O000400056O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000400063O00122O000300043O002ED6002400570001002500045B3O0057000100260D000300570001000400045B3O005700010012E7000200043O00045B3O007B000100045B3O00570001002ED6002700500001002600045B3O0050000100260D000200500001000400045B3O0050000100129F000300054O00B1000400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400062O0003008D0001000100045B3O008D00010012E7000300015O00010300073O00123C010300056O000400013O00122O0005002C3O00122O0006002D6O0004000600024O0003000300044O000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000300083O00122O000200033O00045B3O0050000100045B3O009E000100045B3O004B000100264A3O00A20001000300045B3O00A20001002ED6003000FC0001003100045B3O00FC00010012E7000100014O003F000200023O00264A000100A80001000100045B3O00A80001002ED6003300A40001003200045B3O00A400010012E7000200013O00260D000200D30001000400045B3O00D300010012E7000300013O00264A000300B00001000100045B3O00B00001002ED2003500CC0001003400045B3O00CC000100129F000400054O00B1000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000500013O00122O000600383O00122O000700396O0005000700024O00040004000500062O000400BE0001000100045B3O00BE00010012E7000400015O00010400093O00123C010400056O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000500013O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O0004000A3O00122O000300043O002ED2003E00AC0001003F00045B3O00AC0001000EB0000400AC0001000300045B3O00AC00010012E7000200033O00045B3O00D3000100045B3O00AC0001002ED2004100F30001004000045B3O00F3000100260D000200F30001000100045B3O00F3000100129F000300054O00B1000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O000400013O00122O000500443O00122O000600456O0004000600024O00030003000400062O000300E50001000100045B3O00E500010012E7000300015O000103000B3O00123C010300056O000400013O00122O000500463O00122O000600476O0004000600024O0003000300044O000400013O00122O000500483O00122O000600496O0004000600024O0003000300044O0003000C3O00122O000200043O002ED6004B00A90001004A00045B3O00A9000100260D000200A90001000300045B3O00A900010012E73O00163O00045B3O00FC000100045B3O00A9000100045B3O00FC000100045B3O00A40001002ED6004C00532O01004D00045B3O00532O01000EB0000400532O013O00045B3O00532O010012E7000100014O003F000200023O00264A000100062O01000100045B3O00062O01002ED6004E00022O01004F00045B3O00022O010012E7000200013O000E790003000B2O01000200045B3O000B2O01002ED20051000D2O01005000045B3O000D2O010012E73O00033O00045B3O00532O0100264A000200112O01000100045B3O00112O01002E0C0052001E0001005300045B3O002D2O0100129F000300054O0025010400013O00122O000500543O00122O000600556O0004000600024O0003000300044O000400013O00122O000500563O00122O000600576O0004000600024O0003000300044O0003000D3O00122O000300056O000400013O00122O000500583O00122O000600596O0004000600024O0003000300044O000400013O00122O0005005A3O00122O0006005B6O0004000600024O00030003000400062O0003002B2O01000100045B3O002B2O010012E7000300015O000103000E3O0012E7000200043O00264A000200312O01000400045B3O00312O01002E0C005C00D8FF2O005D00045B3O00072O0100129F000300054O00B1000400013O00122O0005005E3O00122O0006005F6O0004000600024O0003000300044O000400013O00122O000500603O00122O000600616O0004000600024O00030003000400062O0003003F2O01000100045B3O003F2O010012E7000300015O000103000F3O0012DA000300056O000400013O00122O000500623O00122O000600636O0004000600024O0003000300044O000400013O00122O000500643O00122O000600656O0004000600024O00030003000400062O0003004E2O01000100045B3O004E2O010012E7000300015O00010300103O0012E7000200033O00045B3O00072O0100045B3O00532O0100045B3O00022O0100260D3O00892O01001900045B3O00892O0100129F000100054O00B1000200013O00122O000300663O00122O000400676O0002000400024O0001000100024O000200013O00122O000300683O00122O000400696O0002000400024O00010001000200062O000100632O01000100045B3O00632O010012E7000100015O002O0100113O00128D000100056O000200013O00122O0003006A3O00122O0004006B6O0002000400024O0001000100024O000200013O00122O0003006C3O00122O0004006D6O0002000400024O0001000100024O000100123O00122O000100056O000200013O00122O0003006E3O00122O0004006F6O0002000400024O0001000100024O000200013O00122O000300703O00122O000400716O0002000400024O0001000100024O000100133O00122O000100056O000200013O00122O000300723O00122O000400736O0002000400024O0001000100024O000200013O00122O000300743O00122O000400756O0002000400024O0001000100024O000100143O00124O00763O00260D3O00010001007600045B3O0001000100129F000100054O001E010200013O00122O000300773O00122O000400786O0002000400024O0001000100024O000200013O00122O000300793O00122O0004007A6O0002000400024O0001000100023O002O0100153O00045B3O00992O0100045B3O000100012O002D012O00017O000D3O00028O00026O00F03F025O006DB140025O00E8AB40025O0070A640025O00E07340025O00C08140025O0068B040030C3O0047657445717569706D656E74026O002A40026O002C40025O00BDB040025O00649540004A3O0012E73O00014O003F000100023O00264A3O00060001000200045B3O00060001002E0C0003003D0001000400045B3O0041000100264A0001000A0001000100045B3O000A0001002E0C000500FEFF2O000600045B3O000600010012E7000200013O002E0C000700210001000700045B3O002C0001000EB00001002C0001000200045B3O002C00010012E7000300013O00260D000300140001000200045B3O001400010012E7000200023O00045B3O002C0001002E0C000800FCFF2O000800045B3O0010000100260D000300100001000100045B3O001000012O008A000400013O00202A0104000400094O0004000200024O00048O00045O00202O00040004000A00062O0004002600013O00045B3O002600012O008A000400034O008A00055O0020F000050005000A2O001000040002000200060C010400290001000100045B3O002900012O008A000400033O0012E7000500014O00100004000200023O00010400023O0012E7000300023O00045B3O0010000100260D0002000B0001000200045B3O000B00012O008A00035O0020F000030003000B0006700003003800013O00045B3O003800012O008A000300034O008A00045O0020F000040004000B2O001000030002000200060C0103003B0001000100045B3O003B00012O008A000300033O0012E7000400014O00100003000200023O00010300043O00045B3O0049000100045B3O000B000100045B3O0049000100045B3O0006000100045B3O0049000100264A3O00450001000100045B3O00450001002ED2000C00020001000D00045B3O000200010012E7000100014O003F000200023O0012E73O00023O00045B3O000200012O002D012O00017O000D3O00028O00030C3O009AEA77F2E6C4A4E05BFCFDCE03063O00ABD785199589030B3O004973417661696C61626C65030C3O00CCC73CFDE03FEF47C3C126FF03083O002281A8529A8F509C03043O00436F7374030C3O00B7B3231F475CBA91A03A004D03073O00E9E5D2536B282E03053O00ED573CD10003053O0065A12252B6026O002040026O00144000323O0012E73O00013O00260D3O00010001000100045B3O000100012O008A000100014O0014010200023O00122O000300023O00122O000400036O0002000400024O00010001000200202O0001000100044O00010002000200062O0001001700013O00045B3O001700012O008A000100014O0034000200023O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001001F0001000100045B3O001F00012O008A000100014O0014000200023O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100074O0001000200023O002O016O008A000100014O0014010200023O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O0001000100044O00010002000200062O0001002D00013O00045B3O002D00010012E70001000C3O00060C2O01002E0001000100045B3O002E00010012E70001000D5O002O0100033O00045B3O0031000100045B3O000100012O002D012O00017O00063O00028O00025O0080AB40025O002EB340025O0034A640025O0001B140024O0080B3C54000143O0012E73O00014O003F000100013O000E790001000600013O00045B3O00060001002ED2000300020001000200045B3O000200010012E7000100013O002ED6000400070001000500045B3O00070001000EB0000100070001000100045B3O000700010012E7000200065O0001025O0012E7000200065O00010200013O00045B3O0013000100045B3O0007000100045B3O0013000100045B3O000200012O002D012O00017O000D3O00028O00026O00F03F025O004EAD40025O00AC9940025O002FB340025O009CAB40025O0072A740026O003040025O0076A640025O006EA94003053O00466F637573030E3O00466F63757343617374526567656E03083O00466F6375734D617802493O0012E7000200014O003F000300043O00260D0002000F0001000100045B3O000F00010012E7000500013O000EB00001000A0001000500045B3O000A00010012E7000300014O003F000400043O0012E7000500023O00260D000500050001000200045B3O000500010012E7000200023O00045B3O000F000100045B3O0005000100264A000200130001000200045B3O00130001002ED2000300020001000400045B3O0002000100264A000300170001000100045B3O00170001002E0C000500FEFF2O000600045B3O001300010012E7000500013O002ED2000800180001000700045B3O0018000100260D000500180001000100045B3O001800010012E7000600013O002ED60009001D0001000A00045B3O001D000100260D0006001D0001000100045B3O001D0001000623010400240001000100045B3O002400010012E7000400014O008A00076O006A000800013O00202O00080008000B4O0008000200024O000900013O00202O00090009000C4O000B8O0009000B00024O0008000800094O000900046O0007000900024O000800026O000900013O00202O00090009000B4O0009000200024O000A00013O00202O000A000A000C4O000C8O000A000C00024O00090009000A4O000A00046O0008000A00024O0007000700084O000800013O00202O00080008000D4O00080002000200062O000700410001000800045B3O004100014O00076O00D7000700014O0073000700023O00045B3O001D000100045B3O0018000100045B3O0013000100045B3O0048000100045B3O000200012O002D012O00017O00023O00030D3O00446562752O6652656D61696E7303123O0053657270656E745374696E67446562752O6601063O00207500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303113O00426C2O6F64732O656B6572446562752O6601063O00207500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030B3O00446562752O66537461636B03123O004C6174656E74506F69736F6E446562752O6601063O00207500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030A3O00446562752O66446F776E03133O00536872652O64656441726D6F72446562752O6601063O00207500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O000E3O00030B3O00922AA7789CB048B9B82DAF03083O00D4D943CB142ODF2503103O0046752O6C526563686172676554696D652O033O00474344030B3O009184A4DE9982A5DFBB83AC03043O00B2DAEDC8030B3O004578656375746554696D65026O003540030E3O0090B9E7DEBDBCE8D785A1F4D9BDB003043O00B0D6D586030C3O00432O6F6C646F776E446F776E030E3O00D2A1B7DAA35F57F39EA2C6A15D5C03073O003994CDD6B4C836030B3O004973417661696C61626C6501324O008A00016O000B000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O0001000200024O000200023O00202O0002000200044O00020002000200062O0001002E0001000200045B3O002E00012O008A000100034O00BA00028O000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200122O000300086O00010003000200062O0001003000013O00045B3O003000012O008A00016O0034000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200202O00010001000B4O00010002000200062O000100300001000100045B3O003000012O008A00016O0021000200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200202O00010001000E4O0001000200024O000100013O00044O003000014O00016O00D7000100014O0073000100024O002D012O00017O00023O00030A3O00446562752O66446F776E03133O00536872652O64656441726D6F72446562752O6601063O00207500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030B3O00446562752O66537461636B03123O004C6174656E74506F69736F6E446562752O66026O002040010A3O0020BC00013O00014O00035O00202O0003000300024O000100030002000E2O000300070001000100045B3O000700014O00016O00D7000100014O0073000100024O002D012O00017O00093O0003113O00446562752O665265667265736861626C6503123O0053657270656E745374696E67446562752O6603093O0054696D65546F446965026O002840030B3O0024F425316401CB303A791F03053O0016729D5554030B3O004973417661696C61626C65030A3O00ECD217D65CE58ACDDF1603073O00C8A4AB73A43D9601213O00208800013O00014O00035O00202O0003000300024O00010003000200062O0001001F00013O00045B3O001F00010020EA00013O00032O0010000100020002000E850004001D0001000100045B3O001D00012O008A00016O0014010200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001001E00013O00045B3O001E00012O008A00016O0014000200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100074O00010002000200045B3O001F00014O00016O00D7000100014O0073000100024O002D012O00017O00043O00030A3O00446562752O66446F776E03123O0053657270656E745374696E67446562752O6603093O0054696D65546F446965026O001C40010E3O00208800013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O00045B3O000C00010020EA00013O00032O0010000100020002000ECB0004000B0001000100045B3O000B00014O00016O00D7000100014O0073000100024O002D012O00017O00023O0003113O00446562752O665265667265736861626C6503123O0053657270656E745374696E67446562752O6601063O00207500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00433O00028O00026O007740025O009EB040027O0040030E3O004973496E4D656C2O6552616E676503063O0042752O66557003103O004173706563746F667468654561676C6503093O004973496E52616E6765026O004440030C3O00F6DE205B2058C8D40C553B5203063O0037BBB14E3C4F03073O0049735265616479025O00E9B240025O0036A140025O0035B240025O00408340030C3O004D6F6E672O6F73654269746503193O0020C151EC49C09328F15DE252CAC03DDC5AE849C2822CDA1FBD03073O00E04DAE3F8B26AF030C3O00B640483A8B536B3A9648532B03043O004EE42138025O005C9E40025O0030A540030C3O00526170746F72537472696B6503193O00DC7FA2178ADC41A11797C775B74395DC7BB10C88CC7FA643DD03053O00E5AE1ED263026O00F03F03093O0021343D79B04000212803063O00147240581CDC030A3O0049734361737461626C65030A3O00446562752O66446F776E030F3O0053742O656C54726170446562752O6603093O0053742O656C5472617003163O002215D7B1F4EFA92300C2F4E8C2B8320EDFB6F9C4FD6303073O00DD5161B2D498B0025O007BB040025O0080434003073O00E5E60FEB15C2E903053O007AAD877D9B03083O0042752O66446F776E026O003E4003073O00486172702O6F6E030E3O0049735370652O6C496E52616E676503133O008CC012A9303EC6C4D112BC3C3EC586C014F96B03073O00A8E4A160D95F51025O00FEAE40025O00E2A140025O00988A40025O0056A740025O001DB340025O00E0604003063O00457869737473030C3O0093FD10418AACF100518AB1FA03053O00E3DE946325025O0018A840025O001CA94003113O004D6973646972656374696F6E466F63757303183O003E5B41F2F0215751E2F03C5C12E6EB36515D2OFB324612A603053O0099532O329603113O007C7A741967A34C4F46660669A7487F796B03073O002D3D16137C13CB03123O004973457175692O706564416E64526561647903113O00416C67657468617250752O7A6C65426F78031F3O00C01E0AF01678B8D32D1DE0186AB5C42D0FFA1A30A9D3170EFA0F72B8D5525C03073O00D9A1726D956210025O00C4AA40025O00AEA44000F13O0012E73O00014O003F000100013O00260D3O00020001000100045B3O000200010012E7000100013O002ED20002004E0001000300045B3O004E000100260D0001004E0001000400045B3O004E00012O008A00025O0020EA0002000200052O008A000400014O009300020004000200060C0102001C0001000100045B3O001C00012O008A000200023O0020880002000200064O000400033O00202O0004000400074O00020004000200062O000200F000013O00045B3O00F000012O008A00025O0020EA0002000200080012E7000400094O0093000200040002000670000200F000013O00045B3O00F000012O008A000200034O0034000300043O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200280001000100045B3O00280001002ED6000D00360001000E00045B3O00360001002ED2001000F00001000F00045B3O00F000012O008A000200054O008A000300033O0020F00003000300112O0010000200020002000670000200F000013O00045B3O00F000012O008A000200043O0012D9000300123O00122O000400136O000200046O00025O00044O00F000012O008A000200034O0034000300043O00122O000400143O00122O000500156O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200420001000100045B3O00420001002E0C001600B00001001700045B3O00F000012O008A000200054O008A000300033O0020F00003000300182O0010000200020002000670000200F000013O00045B3O00F000012O008A000200043O0012D9000300193O00122O0004001A6O000200046O00025O00044O00F0000100260D0001009F0001001B00045B3O009F00012O008A000200034O0014010300043O00122O0004001C3O00122O0005001D6O0003000500024O00020002000300202O00020002001E4O00020002000200062O0002007100013O00045B3O007100012O008A00025O00208800020002001F4O000400033O00202O0004000400204O00020004000200062O0002007100013O00045B3O007100012O008A000200054O00FB000300033O00202O0003000300214O00045O00202O00040004000800122O000600096O0004000600024O000400046O00020004000200062O0002007100013O00045B3O007100012O008A000200043O0012E7000300223O0012E7000400234O0082000200044O007A00025O002ED60025009E0001002400045B3O009E00012O008A000200034O0014010300043O00122O000400263O00122O000500276O0003000500024O00020002000300202O00020002001E4O00020002000200062O0002009E00013O00045B3O009E00012O008A000200063O0006700002009E00013O00045B3O009E00012O008A000200023O00203D0002000200284O000400033O00202O0004000400074O00020004000200062O0002008D0001000100045B3O008D00012O008A00025O0020EA0002000200080012E7000400294O009300020004000200060C0102009E0001000100045B3O009E00012O008A000200054O0060000300033O00202O00030003002A4O00045O00202O00040004002B4O000600033O00202O00060006002A4O0004000600024O000400046O00020004000200062O0002009E00013O00045B3O009E00012O008A000200043O0012E70003002C3O0012E70004002D4O0082000200044O007A00025O0012E7000100043O00260D000100050001000100045B3O000500010012E7000200013O002ED2002F00A80001002E00045B3O00A8000100260D000200A80001001B00045B3O00A800010012E70001001B3O00045B3O0005000100264A000200AC0001000100045B3O00AC0001002ED2003100A20001003000045B3O00A200010012E7000300013O002ED6003300E50001003200045B3O00E50001000EB0000100E50001000300045B3O00E500012O008A000400073O0020EA0004000400342O0010000400020002000670000400C000013O00045B3O00C000012O008A000400034O0034000500043O00122O000600353O00122O000700366O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400C20001000100045B3O00C20001002ED2003800CD0001003700045B3O00CD00012O008A000400054O008A000500083O0020F00005000500392O0010000400020002000670000400CD00013O00045B3O00CD00012O008A000400043O0012E70005003A3O0012E70006003B4O0082000400064O007A00046O008A000400094O0014010500043O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500202O00040004003E4O00040002000200062O000400E400013O00045B3O00E400012O008A000400054O00CA000500083O00202O00050005003F4O000600066O000700016O00040007000200062O000400E400013O00045B3O00E400012O008A000400043O0012E7000500403O0012E7000600414O0082000400064O007A00045O0012E70003001B3O00264A000300E90001001B00045B3O00E90001002ED2004200AD0001004300045B3O00AD00010012E70002001B3O00045B3O00A2000100045B3O00AD000100045B3O00A2000100045B3O0005000100045B3O00F0000100045B3O000200012O002D012O00017O002A3O00028O00025O00A09840025O0017B140026O00F03F025O00D0A640025O0040A440025O00589140025O0006A640025O00809C40025O0036A64003113O003AE18154F9353809DD934BF7313C39E29E03073O00597B8DE6318D5D03123O004973457175692O706564416E645265616479030A3O0047434452656D61696E732O033O004743440200304O33E33F03113O00416C67657468617250752O7A6C65426F78031A3O00F27DF1090442F263C91C0550E97DF3331245EB31F508030AA22603063O002A9311966C70030F3O0022A72376E4CF1DAF2879F3E71DA52503063O00886FC64D1F87026O33E33F03083O0042752O66446F776E030D3O0053706561726865616442752O66030F3O004D616E69634772696566746F72636803173O000F08A95FBEDB10BB0B0CA142B2F614A1420AA345FDB54F03083O00C96269C736DD8477027O0040030F3O0047657455736561626C654974656D73026O002C40025O00ECA74003083O005472696E6B65743203123O004AD1FCEB27C54A91B5F13EC950C8F0F16C9403063O00A03EA395854C025O00608640025O00EEB040025O00488F40025O00B4A740026O002A4003083O005472696E6B65743103123O00AD1E8A2F0930B8E84C97330B3BA7BC18C37303073O00CCD96CE341625500AC3O0012E73O00014O003F000100033O00264A3O00060001000100045B3O00060001002E0C000200050001000300045B3O000900010012E7000100014O003F000200023O0012E73O00043O00260D3O00020001000400045B3O000200012O003F000300033O00264A000100100001000100045B3O00100001002ED2000500640001000600045B3O006400010012E7000400013O00264A000400150001000100045B3O00150001002ED60008005F0001000700045B3O005F0001002ED6000900370001000A00045B3O003700012O008A00056O0014010600013O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005003700013O00045B3O003700012O008A000500023O00206400050005000E4O0005000200024O000600023O00202O00060006000F4O00060002000200202O00060006001000062O000600370001000500045B3O003700012O008A000500034O00CA000600043O00202O0006000600114O000700076O000800016O00050008000200062O0005003700013O00045B3O003700012O008A000500013O0012E7000600123O0012E7000700134O0082000500074O007A00056O008A00056O0014010600013O00122O000700143O00122O000800156O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005005E00013O00045B3O005E00012O008A000500023O00206400050005000E4O0005000200024O000600023O00202O00060006000F4O00060002000200202O00060006001600062O0006005E0001000500045B3O005E00012O008A000500023O0020880005000500174O000700053O00202O0007000700184O00050007000200062O0005005E00013O00045B3O005E00012O008A000500034O00CA000600043O00202O0006000600194O000700076O000800016O00050008000200062O0005005E00013O00045B3O005E00012O008A000500013O0012E70006001A3O0012E70007001B4O0082000500074O007A00055O0012E7000400043O00260D000400110001000400045B3O001100010012E7000100043O00045B3O0064000100045B3O0011000100260D0001007E0001001C00045B3O007E00012O008A000400023O00206600040004001D4O000600063O00122O0007001E6O0004000700024O000300043O00062O000300AB00013O00045B3O00AB0001002E0C001F003D0001001F00045B3O00AB00012O008A000400034O00CA000500043O00202O0005000500204O000600076O000800016O00040008000200062O000400AB00013O00045B3O00AB00012O008A000400013O0012D9000500213O00122O000600226O000400066O00045O00044O00AB0001002ED60023000C0001002400045B3O000C000100260D0001000C0001000400045B3O000C00010012E7000400014O003F000500053O00260D000400840001000100045B3O008400010012E7000500013O002ED2002500A10001002600045B3O00A1000100260D000500A10001000100045B3O00A100012O008A000600023O00206600060006001D4O000800063O00122O000900276O0006000900024O000200063O00062O000200A000013O00045B3O00A000012O008A000600034O00CA000700043O00202O0007000700284O000800096O000A00016O0006000A000200062O000600A000013O00045B3O00A000012O008A000600013O0012E7000700293O0012E70008002A4O0082000600084O007A00065O0012E7000500043O00260D000500870001000400045B3O008700010012E70001001C3O00045B3O000C000100045B3O0087000100045B3O000C000100045B3O0084000100045B3O000C000100045B3O00AB000100045B3O000200012O002D012O00017O00703O00028O00026O00F03F025O00888E40025O00049D4003063O0042752O66557003163O00432O6F7264696E61746564412O7361756C7442752O66030D3O0053706561726865616442752O6603093O00C0FF5DD7375EF6EE5C03063O0036938F38B645030B3O004973417661696C61626C6503123O00F58EF05BDBDF8FFE5DDAD2A0EC5ADEC38DEB03053O00BFB6E19F29025O00208B40025O00088C40030D3O000A1C2B509893D02A1E0B54878B03073O00A24B724835EBE7030A3O0049734361737461626C65030D3O00416E6365737472616C43612O6C025O006C9140025O006DB24003143O008D3247E740169E3D48DD5003803004E15711CC6A03063O0062EC5C248233025O0068A540025O000BB04003093O0082101EBF47A4BA3FA003083O0050C4796CDA25C8D503093O0046697265626C2O6F64030F3O00067A107A4902850F77427C4F1DCA5803073O00EA6013621F2B6E025O00C07140025O00E08540030E3O002A1655CFB861A1131B55CAA97C9F03073O00EB667F32A7CC12025O00207840025O00206140030E3O004C69676874734A7564676D656E74030E3O0049735370652O6C496E52616E676503163O005CA8F22B503D6FABE027432355AFE163472A43E1A47303063O004E30C1954324027O0040025O00D88C40026O000840025O004DB040025O00707640025O00E89A4003103O00FBF867ED88D3D5ED63E08EE2DBEC7BED03063O00A7BA8B1788EB03093O004973496E52616E6765025O0034AF40025O00D8AD40025O00409740025O00A4994003103O004173706563746F667468654561676C65031A3O001BA6980819A1B7021C8A9C051F8A8D0C1DB98D4D19B19B4D4BEC03043O006D7AD5E8025O00107B40025O0076A140025O00B89C40025O004EA34003093O00F4AC0220C7F0B51F3603053O00A3B6C06D4F03093O00073605C1E73C2301C403053O0095544660A003123O001B0902FF3C0F03EC2C0309CC2B150CF8341203043O008D58666D03093O00426C2O6F644675727903103O00B15FC57F1E0253D4A14A8A731E2E159303083O00A1D333AA107A5D3503073O00D3AFA038F4A1BC03043O00489BCED203113O00727F460320497C710034477D510336486E03053O0053261A346E03053O00466F63757303083O00466F6375734D6178025O0018A340025O00E2A94003073O00486172702O6F6E030D3O0050163556571829065B1334060A03043O0026387747025O00CAAC40025O00206740025O00108740025O009C9E40030B3O00121F871747040C891B4A2303053O0021507EE078030B3O00C7A10FC87FE3A50EC552E803053O003C8CC863A403103O0046752O6C526563686172676554696D652O033O00474344025O002O9440025O002AA840030B3O004261676F66547269636B7303143O0085F50319AD81CB1034AB84FF1766A183E74477F003053O00C2E7946446030A3O006449D3B0F3DA4D45CFA403063O00A8262CA1C39603093O00B3EC877722E0B3178403083O0076E09CE2165088D603123O0061E1569246E7578156EB5DA151FD58954EFA03043O00E0228E39026O002A40025O0066A440025O0053B140030A3O004265727365726B696E67025O00405D40025O003DB34003113O00DCA2D7CE76E35607D0A085DE77E21D5F8A03083O006EBEC7A5BD13913D025O00C05A40025O0029B340025O00608F40025O0086AF4000DF012O0012E73O00014O003F000100013O00260D3O00020001000100045B3O000200010012E7000100013O00264A000100090001000200045B3O00090001002ED20004008F0001000300045B3O008F00012O008A00025O00203D0002000200054O000400013O00202O0004000400064O00020004000200062O0002002B0001000100045B3O002B00012O008A00025O00203D0002000200054O000400013O00202O0004000400074O00020004000200062O0002002B0001000100045B3O002B00012O008A000200014O0034000300023O00122O000400083O00122O000500096O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002006F0001000100045B3O006F00012O008A000200014O0034000300023O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002006F0001000100045B3O006F00010012E7000200014O003F000300043O00264A000200310001000100045B3O00310001002ED2000E00340001000D00045B3O003400010012E7000300014O003F000400043O0012E7000200023O00260D0002002D0001000200045B3O002D000100260D000300360001000100045B3O003600010012E7000400013O000EB0000100390001000400045B3O003900012O008A000500014O0014010600023O00122O0007000F3O00122O000800106O0006000800024O00050005000600202O0005000500114O00050002000200062O0005005200013O00045B3O005200012O008A000500034O008A000600013O0020F00006000600122O001000050002000200060C0105004D0001000100045B3O004D0001002E0C001300070001001400045B3O005200012O008A000500023O0012E7000600153O0012E7000700164O0082000500074O007A00055O002ED20017006F0001001800045B3O006F00012O008A000500014O0014010600023O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O0005000500114O00050002000200062O0005006F00013O00045B3O006F00012O008A000500034O008A000600013O0020F000060006001B2O00100005000200020006700005006F00013O00045B3O006F00012O008A000500023O0012D90006001C3O00122O0007001D6O000500076O00055O00044O006F000100045B3O0039000100045B3O006F000100045B3O0036000100045B3O006F000100045B3O002D0001002ED2001E008E0001001F00045B3O008E00012O008A000200014O0014010300023O00122O000400203O00122O000500216O0003000500024O00020002000300202O0002000200114O00020002000200062O0002008E00013O00045B3O008E0001002ED60023008E0001002200045B3O008E00012O008A000200034O0060000300013O00202O0003000300244O000400043O00202O0004000400254O000600013O00202O0006000600244O0004000600024O000400046O00020004000200062O0002008E00013O00045B3O008E00012O008A000200023O0012E7000300263O0012E7000400274O0082000200044O007A00025O0012E7000100283O002E0C0029004B0001002900045B3O00DA000100260D000100DA0001002A00045B3O00DA00012O008A000200053O00060C010200980001000100045B3O00980001002E0C002B00210001002C00045B3O00B700010012E7000200014O003F000300043O000EB0000200A90001000200045B3O00A90001002E0C002D3O0001002D00045B3O009C000100260D0003009C0001000100045B3O009C00012O008A000500064O00840005000100022O00A4000400053O000670000400B700013O00045B3O00B700012O0073000400023O00045B3O00B7000100045B3O009C000100045B3O00B7000100260D0002009A0001000100045B3O009A00010012E7000500013O000EB0000200B00001000500045B3O00B000010012E7000200023O00045B3O009A000100260D000500AC0001000100045B3O00AC00010012E7000300014O003F000400043O0012E7000500023O00045B3O00AC000100045B3O009A00012O008A000200014O0014010300023O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200CA00013O00045B3O00CA00012O008A000200073O000670000200CA00013O00045B3O00CA00012O008A000200043O0020EA0002000200302O008A000400084O0093000200040002000670000200CC00013O00045B3O00CC0001002ED6003100DE2O01003200045B3O00DE2O01002ED2003300DE2O01003400045B3O00DE2O012O008A000200034O008A000300013O0020F00003000300352O0010000200020002000670000200DE2O013O00045B3O00DE2O012O008A000200023O0012D9000300363O00122O000400376O000200046O00025O00044O00DE2O01002ED6003800522O01003900045B3O00522O0100260D000100522O01000100045B3O00522O010012E7000200013O00264A000200E30001000100045B3O00E30001002ED2003B004D2O01003A00045B3O004D2O012O008A000300014O0014010400023O00122O0005003C3O00122O0006003D6O0004000600024O00030003000400202O0003000300114O00030002000200062O0003001A2O013O00045B3O001A2O012O008A00035O00203D0003000300054O000500013O00202O0005000500064O00030005000200062O0003000F2O01000100045B3O000F2O012O008A00035O00203D0003000300054O000500013O00202O0005000500074O00030005000200062O0003000F2O01000100045B3O000F2O012O008A000300014O0034000400023O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003001A2O01000100045B3O001A2O012O008A000300014O0034000400023O00122O000500403O00122O000600416O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003001A2O01000100045B3O001A2O012O008A000300034O008A000400013O0020F00004000400422O00100003000200020006700003001A2O013O00045B3O001A2O012O008A000300023O0012E7000400433O0012E7000500444O0082000300054O007A00036O008A000300014O0014010400023O00122O000500453O00122O000600466O0004000600024O00030003000400202O0003000300114O00030002000200062O0003004C2O013O00045B3O004C2O012O008A000300093O0006700003004C2O013O00045B3O004C2O012O008A000300014O0014010400023O00122O000500473O00122O000600486O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004C2O013O00045B3O004C2O012O008A00035O0020CD0003000300494O0003000200024O00045O00202O00040004004A4O00040002000200062O0003004C2O01000400045B3O004C2O01002ED2004B004C2O01004C00045B3O004C2O012O008A000300034O0060000400013O00202O00040004004D4O000500043O00202O0005000500254O000700013O00202O00070007004D4O0005000700024O000500056O00030005000200062O0003004C2O013O00045B3O004C2O012O008A000300023O0012E70004004E3O0012E70005004F4O0082000300054O007A00035O0012E7000200023O00260D000200DF0001000200045B3O00DF00010012E7000100023O00045B3O00522O0100045B3O00DF000100260D000100050001002800045B3O000500010012E7000200014O003F000300033O00264A0002005A2O01000100045B3O005A2O01002ED6005000562O01005100045B3O00562O010012E7000300013O00260D000300D22O01000100045B3O00D22O010012E7000400013O002ED6005200CB2O01005300045B3O00CB2O0100260D000400CB2O01000100045B3O00CB2O012O008A000500014O0014010600023O00122O000700543O00122O000800556O0006000800024O00050005000600202O0005000500114O00050002000200062O000500792O013O00045B3O00792O012O008A000500014O0065000600023O00122O000700563O00122O000800576O0006000800024O00050005000600202O0005000500584O0005000200024O00065O00202O0006000600594O00060002000200062O0006007B2O01000500045B3O007B2O01002E0C005A00130001005B00045B3O008C2O012O008A000500034O0060000600013O00202O00060006005C4O000700043O00202O0007000700254O000900013O00202O00090009005C4O0007000900024O000700076O00050007000200062O0005008C2O013O00045B3O008C2O012O008A000500023O0012E70006005D3O0012E70007005E4O0082000500074O007A00056O008A000500014O0014010600023O00122O0007005F3O00122O000800606O0006000800024O00050005000600202O0005000500114O00050002000200062O000500BB2O013O00045B3O00BB2O012O008A00055O00203D0005000500054O000700013O00202O0007000700064O00050007000200062O000500BD2O01000100045B3O00BD2O012O008A00055O00203D0005000500054O000700013O00202O0007000700074O00050007000200062O000500BD2O01000100045B3O00BD2O012O008A000500014O0034000600023O00122O000700613O00122O000800626O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500B82O01000100045B3O00B82O012O008A000500014O0014010600023O00122O000700633O00122O000800646O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500BD2O013O00045B3O00BD2O012O008A0005000A3O0026E6000500BD2O01006500045B3O00BD2O01002ED6006700CA2O01006600045B3O00CA2O012O008A000500034O008A000600013O0020F00006000600682O001000050002000200060C010500C52O01000100045B3O00C52O01002ED2006A00CA2O01006900045B3O00CA2O012O008A000500023O0012E70006006B3O0012E70007006C4O0082000500074O007A00055O0012E7000400023O002ED6006D005E2O01006E00045B3O005E2O0100260D0004005E2O01000200045B3O005E2O010012E7000300023O00045B3O00D22O0100045B3O005E2O0100264A000300D62O01000200045B3O00D62O01002ED20070005B2O01006F00045B3O005B2O010012E70001002A3O00045B3O0005000100045B3O005B2O0100045B3O0005000100045B3O00562O0100045B3O0005000100045B3O00DE2O0100045B3O000200012O002D012O00017O001F012O00028O00026O00F03F025O00E4A540025O00107740025O00649740025O0002A440025O00808940025O00C09A40027O0040030C3O00F680DD378F8A5CD38ECE228A03073O0034B2E5BC43E7C9030A3O0049734361737461626C65025O005AA540025O0036A740030C3O0044656174684368616B72616D030E3O0049735370652O6C496E52616E676503163O0025445110FF632029405B16F65163224D5505E159637503073O004341213064973C03083O00ECF3AFD5E3DAE3AB03053O0093BF87CEB803083O005374616D7065646503113O00973CA7CCC856B68168A5CDDD52A48168F003073O00D2E448C6A1B833025O004EA440025O00A4AF40025O00C89F4003083O00C5FEAE3CDDFFAD2403043O00508E97C203073O004973526561647903063O0042752O665570031D3O00432O6F7264696E61746564412O7361756C74456D706F77657242752O6603163O00432O6F7264696E61746564412O7361756C7442752O6603043O0021CF634903043O002C63A61703043O005FFB282103063O00C41C9749565303053O00C00E28138903083O001693634970E23878030B3O009A7CF0F19EB773D2E788A103053O00EDD8158295030B3O004973417661696C61626C6503083O004B692O6C53686F7403103O0089472O538FDA568D5A1F5CBCCC5F944B03073O003EE22E2O3FD0A9030C3O00D210598719043D5BC716588103083O003E857935E37F6D4F03103O0046752O6C526563686172676554696D652O033O0047434403123O00331B3DE7D2A7AC110037F1F7BDB111013EE103073O00C270745295B6CE030A3O00432O6F6C646F776E557003083O0042752O66446F776E030A3O001BA7411AC1F00A30AD5E03073O006E59C82C78A08203053O007061697273025O00C0A740025O00B0B140025O0058A040025O000AA04003163O00BCCA47424543294894C1444B410A3841AEC25D43031803083O002DCBA32B26232A5B025O0090A040025O00BFB24003053O0075AE2E081603073O009336CF5C7E7383030C3O003A3839790B771F341772007C03063O001E6D51551D6D025O00BAB140025O00507840025O00E07040025O00D8984003053O004361727665030E3O004973496E4D656C2O6552616E6765030F3O00FC7046A0339EFFF37455A0339EADAB03073O009C9F1134D656BE025O00649940025O00C4934003083O008CFAA9BFA6EAAFA503043O00DCCE8FDD03083O00A4683914D0C9C09F03073O00B2E61D4D77B8AC03083O00446562752O66557003123O0053687261706E656C426F6D62446562752O66030B3O00446562752O66537461636B03163O00496E7465726E616C426C2O6564696E67446562752O66030D3O00446562752O6652656D61696E7303083O004275746368657279025O00804940025O00C08C4003123O00F7AB1E187FFDE7A74A187BFDF4A80F5B26AE03063O009895DE6A7B17025O0030A740025O00389F40025O001AA840025O006CA54003123O001546FC0277C73848E71577EF255AF2057FDA03063O00AE5629937013030E3O007D159F122A0905A35E258C0C290A03083O00CB3B60ED6B456F71030C3O00432O6F6C646F776E446F776E030E3O000203BEF83EF6C32C1389E036FCD203073O00B74476CC815190025O00807740025O0046A04003123O00432O6F7264696E61746564412O7361756C74031C3O000DA27FF60F8B00AC64E10FBD0FBE63E51E8E1AED73E80E8318A830BC03063O00E26ECD10846B030D3O00CEDBF0D54EF8CAF6DC72E3CCF403053O00218BA380B9030D3O004578706C6F7369766553686F7403183O00524014D2584B0DC8526717D6584C44DD5B5D05C85218558C03043O00BE373864026O000840025O005FB040025O00409340026O001040030C3O0006B133F23BA210F226B928E303043O008654D043025O00849740025O0009B340025O0050AE40025O00B6B140030C3O00436173745461726765744966030C3O00526170746F72537472696B652O033O001EAD9E03043O003C73CCE603173O00F53BFB64E828D463F328E27BE27AE87CE23BFD75A769B903043O0010875A8B030B3O007F7D0A3F6D5B755975083703073O0018341466532E34030B3O00EF262D282CCB222C2501C003053O006FA44F4144030B3O004578656375746554696D65030B3O00EDD08FD20DE5CBD482D02A03063O008AA6B9E3BE4E025O0080A240025O00DAA340030B3O004B692O6C436F2O6D616E642O033O00C67DCB03073O0079AB14A557324303163O00CD31B53A8601C935B437B706863BB533B814C378EA6203063O0062A658D956D9025O007DB240025O0007B04003083O00C7CC1C302EE0CB1103053O004685B96853030C3O00374D562BD90A404808C6094703053O00A96425244A03103O00378EAE54068EB0552989A445138EAD5E03043O003060E7C2025O00DC9240025O00B1B040025O00549F40025O00C2A34003123O00CA4F1A2E11DDBD9A8859022818CEAAC39A0203083O00E3A83A6E4D79B8CF025O00D08E40025O000AAC40030C3O005633B147BED462A05935AB4503083O00C51B5CDF20D1BB11030C3O004D6F6E672O6F7365426974652O033O000E5EDB03043O009B633FA3025O005EA840025O00E07A4003173O008FDEAF8AB68B91D49E8FB0908791A281BC8594D4E1DEE903063O00E4E2B1C1EDD9025O00D2A240025O0026A940025O00108C40025O00BCA540025O0094A140025O00909B40025O00A88540030A3O00446562752O66446F776E025O00607B4003173O00CA2FFA47B3D434F37CB7D22BF403B6D123F755B09D77AE03053O00D5BD469623025O005C9B40025O000C9640030E3O0069406611405360004A70750F435003043O00682F3514025O0056B040030E3O00467572796F667468654561676C65031B3O00A55993058300A5739514B930A64D8610B94FA040841DAA0AE31ED303063O006FC32CE17CDC025O003AB240025O00188340025O0081B240025O00ADB14003053O00FB471265AE03063O00CBB8266013CB025O000FB140025O002EAD40030F3O003A726B57CB79707544CF2F7639139A03053O00AE59131921025O00F4A240030E3O00091E5340FC8E052821465CFE8C0E03073O006B4F72322E97E7030E3O001FAAB4278130B9C70AB2A720813C03083O00A059C6D549EA59D7026O003E40030E3O00466C616E6B696E67537472696B6503193O004E7DB5F0CE417FB3C1D65C63BDF5C00872B8FBC45E74F4AC9303053O00A52811D49E026O003540025O00CC9E40026O001440030C3O00374D2DA43046F60B384B37A603083O006E7A2243C35F2985030D3O0053706561726865616442752O662O033O0078B85503053O00B615D13B2A025O00D4A640025O00907B4003173O00BA58CB1A2EB1A452FA1F28AAB217C61124BFA15285497303063O00DED737A57D41030C3O001F2OD40AF7CFF97938D8C81D03083O002A4CB1A67A92A18D030C3O0053657270656E745374696E672O033O00A8830B03063O0016C5EA65AE1903173O003E31B7CC73A1C3B93E20ACD271EFD48A2835B3D936FB8503083O00E64D54C5BC16CFB7030E3O00DF18C7F287A8FE32CA00D4F587A403083O00559974A69CECC190030E3O0082EC4CBDEF09AAE77EA7F609AFE503063O0060C4802DD384025O0050AC40025O00C09140031B3O0033817A51D9A6BADF0A9E6F4DDBA4B19836817E5EC4AAF48C66C32E03083O00B855ED1B3FB2CFD4030C3O002556075807561A5A2A501D5A03043O003F6839692O033O00068EAA03043O00246BE7C403173O0050BAAC8052BAB18262B7AB9358F5A18B582OB4821DE1F603043O00E73DD5C2026O001840025O00EC9F40025O00AEA440030C3O003BAC2D6706BF0E671BA4367603043O001369CD5D2O033O00A401D003053O005FC968BEE103173O00BDCAD1DAA0D9FEDDBBD9C8C5AA8B2OC2AACAD7CBEF9F9703043O00AECFABA1030E3O00CBF20CFDF3DEE3F93EE7EADEE6FB03063O00B78D9E6D939803193O002A05E7022700E80B131AF21E2502E34C2F05E30D3A0CA6587403043O006C4C6986025O00207640025O00F89740025O0068AD40025O000CB340025O00B8AC40025O00F8854003093O00B89030BEE2BF6F8A9403073O001DEBE455DB8EEB03093O000EC0BFD87B7A35532D03083O00325DB4DABD172E4703093O0053742O656C5472617003093O004973496E52616E6765026O00444003143O00CDB05E4948E35CCCA54B0C47D04DDFB25E0C108C03073O0028BEC43B2C24BC03093O000F55D9B5E875083D4103073O006D5C25BCD49A1D03093O0053706561726865616403133O0017FFA1C2235201EEA083325601EEB2C6710E5503063O003A648FC4A351025O00C6AD40025O00F07340025O00804740025O0008914003053O00D5F76B178303063O00BC2O961961E6025O006C9540025O00A8A640030F3O00D9884D1409ADD9855A031AE89ADA0903063O008DBAE93F626C03083O00DAE320BA16F9E53803053O0045918A4CD6025O00989140025O00807F4003133O007BC62O85800578C09DC9BC1A75CE9F8CFF452803063O007610AF2OE9DF00EE042O0012E73O00014O003F000100023O000E790002000600013O00045B3O00060001002ED2000300E60401000400045B3O00E6040100260D000100060001000100045B3O000600010012E7000200013O002ED6000500FF0001000600045B3O00FF000100260D000200FF0001000100045B3O00FF00010012E7000300013O000EB0000200560001000300045B3O005600010012E7000400013O00264A000400150001000200045B3O00150001002ED2000800170001000700045B3O001700010012E7000300093O00045B3O00560001000EB0000100110001000400045B3O001100012O008A00056O0034000600013O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500250001000100045B3O00250001002E0C000D00130001000E00045B3O003600012O008A000500024O006000065O00202O00060006000F4O000700033O00202O0007000700104O00095O00202O00090009000F4O0007000900024O000700076O00050007000200062O0005003600013O00045B3O003600012O008A000500013O0012E7000600113O0012E7000700124O0082000500074O007A00056O008A00056O0014010600013O00122O000700133O00122O000800146O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005005400013O00045B3O005400012O008A000500043O0006700005005400013O00045B3O005400012O008A000500024O006000065O00202O0006000600154O000700033O00202O0007000700104O00095O00202O0009000900154O0007000900024O000700076O00050007000200062O0005005400013O00045B3O005400012O008A000500013O0012E7000600163O0012E7000700174O0082000500074O007A00055O0012E7000400023O00045B3O00110001002ED20018005C0001001900045B3O005C000100260D0003005C0001000900045B3O005C00010012E7000200023O00045B3O00FF0001002E0C001A00B2FF2O001A00045B3O000E000100260D0003000E0001000100045B3O000E00012O008A00046O0014010500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400B100013O00045B3O00B100012O008A000400053O00208800040004001E4O00065O00202O00060006001F4O00040006000200062O000400B100013O00045B3O00B100012O008A000400053O00208800040004001E4O00065O00202O0006000600204O00040006000200062O000400B100013O00045B3O00B100012O008A00046O0034000500013O00122O000600213O00122O000700226O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400960001000100045B3O009600012O008A00046O0034000500013O00122O000600233O00122O000700246O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400960001000100045B3O009600012O008A00046O0014010500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400B100013O00045B3O00B100012O008A00046O0014010500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O0004000400294O00040002000200062O000400B100013O00045B3O00B100012O008A000400024O006000055O00202O00050005002A4O000600033O00202O0006000600104O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400B100013O00045B3O00B100012O008A000400013O0012E70005002B3O0012E70006002C4O0082000400064O007A00046O008A00046O0065000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O00040004002F4O0004000200024O000500053O00202O0005000500304O00050002000200062O000400E00001000500045B3O00E000012O008A00046O0034000500013O00122O000600313O00122O000700326O0005000700024O00040004000500202O0004000400334O00040002000200062O000400E00001000100045B3O00E000012O008A000400053O00208800040004001E4O00065O00202O0006000600204O00040006000200062O000400D600013O00045B3O00D600012O008A000400053O00203D0004000400344O00065O00202O00060006001F4O00040006000200062O000400E00001000100045B3O00E000012O008A00046O0014010500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O0004000400294O00040002000200062O000400FD00013O00045B3O00FD000100129F000400374O008A000500064O001600040002000600045B3O00FB0001002ED2003800FB0001003900045B3O00FB00010020EA00090008000C2O0010000900020002000670000900FB00013O00045B3O00FB00012O008A000900024O0028000A00086O000B00033O00202O000B000B00104O000D00086O000B000D00024O000B000B6O0009000B000200062O000900F60001000100045B3O00F60001002ED6003A00FB0001003B00045B3O00FB00012O008A000900013O0012E7000A003C3O0012E7000B003D4O00820009000B4O007A00095O0006D1000400E40001000200045B3O00E400010012E7000300023O00045B3O000E0001002ED2003E00D62O01003F00045B3O00D62O0100260D000200D62O01000200045B3O00D62O010012E7000300013O000EB00002007C2O01000300045B3O007C2O010012E7000400013O00260D0004000B2O01000200045B3O000B2O010012E7000300093O00045B3O007C2O0100260D000400072O01000100045B3O00072O012O008A00056O0014010600013O00122O000700403O00122O000800416O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500232O013O00045B3O00232O012O008A00056O00FC000600013O00122O000700423O00122O000800436O0006000800024O00050005000600202O00050005002F4O0005000200024O000600073O00202O00060006000900062O000600252O01000500045B3O00252O01002ED6004400372O01004500045B3O00372O01002ED6004600372O01004700045B3O00372O012O008A000500024O00B500065O00202O0006000600484O000700033O00202O0007000700494O000900086O0007000900024O000700076O00050007000200062O000500372O013O00045B3O00372O012O008A000500013O0012E70006004A3O0012E70007004B4O0082000500074O007A00055O002ED2004D007A2O01004C00045B3O007A2O012O008A00056O0014010600013O00122O0007004E3O00122O0008004F6O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005007A2O013O00045B3O007A2O012O008A00056O0065000600013O00122O000700503O00122O000800516O0006000800024O00050005000600202O00050005002F4O0005000200024O000600053O00202O0006000600304O00060002000200062O000500682O01000600045B3O00682O012O008A000500033O0020880005000500524O00075O00202O0007000700534O00050007000200062O0005007A2O013O00045B3O007A2O012O008A000500033O00202C0005000500544O00075O00202O0007000700554O00050007000200262O000500682O01000900045B3O00682O012O008A000500033O0020C90005000500564O00075O00202O0007000700534O0005000700024O000600053O00202O0006000600304O00060002000200062O0005007A2O01000600045B3O007A2O012O008A000500024O005300065O00202O0006000600574O000700033O00202O0007000700494O000900086O0007000900024O000700076O00050007000200062O000500752O01000100045B3O00752O01002ED60059007A2O01005800045B3O007A2O012O008A000500013O0012E70006005A3O0012E70007005B4O0082000500074O007A00055O0012E7000400023O00045B3O00072O0100264A000300802O01000900045B3O00802O01002ED6005C00822O01005D00045B3O00822O010012E7000200093O00045B3O00D62O0100264A000300862O01000100045B3O00862O01002ED6005E00042O01005F00045B3O00042O012O008A00046O0014010500013O00122O000600603O00122O000700616O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400A72O013O00045B3O00A72O012O008A000400043O000670000400A72O013O00045B3O00A72O012O008A00046O0034000500013O00122O000600623O00122O000700636O0005000700024O00040004000500202O0004000400644O00040002000200062O000400A92O01000100045B3O00A92O012O008A00046O0014010500013O00122O000600653O00122O000700666O0005000700024O00040004000500202O0004000400294O00040002000200062O000400A92O013O00045B3O00A92O01002ED6006800B92O01006700045B3O00B92O012O008A000400024O00B500055O00202O0005000500694O000600033O00202O0006000600494O000800086O0006000800024O000600066O00040006000200062O000400B92O013O00045B3O00B92O012O008A000400013O0012E70005006A3O0012E70006006B4O0082000400064O007A00046O008A00046O0014010500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400D42O013O00045B3O00D42O012O008A000400024O006000055O00202O00050005006E4O000600033O00202O0006000600104O00085O00202O00080008006E4O0006000800024O000600066O00040006000200062O000400D42O013O00045B3O00D42O012O008A000400013O0012E70005006F3O0012E7000600704O0082000400064O007A00045O0012E7000300023O00045B3O00042O01000EB0007100AA0201000200045B3O00AA02010012E7000300014O003F000400043O002ED2007300DA2O01007200045B3O00DA2O0100260D000300DA2O01000100045B3O00DA2O010012E7000400013O00260D000400E32O01000900045B3O00E32O010012E7000200743O00045B3O00AA020100260D0004004A0201000200045B3O004A02012O008A00056O0034000600013O00122O000700753O00122O000800766O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500F12O01000100045B3O00F12O01002ED20078000B0201007700045B3O000B0201002ED20079000B0201007A00045B3O000B02012O008A000500093O00206D00050005007B4O00065O00202O00060006007C4O0007000A6O000800013O00122O0009007D3O00122O000A007E6O0008000A00024O0009000B6O000A000C4O00F8000B00033O00202O000B000B00494O000D00086O000B000D00024O000B000B6O0005000B000200062O0005000B02013O00045B3O000B02012O008A000500013O0012E70006007F3O0012E7000700804O0082000500074O007A00056O008A00056O0014010600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002E02013O00045B3O002E02012O008A0005000D4O001E00068O000700013O00122O000800833O00122O000900846O0007000900024O00060006000700202O0006000600854O000600076O00053O000200062O0005002E02013O00045B3O002E02012O008A00056O0065000600013O00122O000700863O00122O000800876O0006000800024O00050005000600202O00050005002F4O0005000200024O000600053O00202O0006000600304O00060002000200062O000500300201000600045B3O00300201002ED6008900490201008800045B3O004902012O008A000500093O00200800050005007B4O00065O00202O00060006008A4O0007000A6O000800013O00122O0009008B3O00122O000A008C6O0008000A00024O0009000E6O000A000A6O000B00033O00202O000B000B00104O000D5O00202O000D000D008A4O000B000D00024O000B000B6O0005000B000200062O0005004902013O00045B3O004902012O008A000500013O0012E70006008D3O0012E70007008E4O0082000500074O007A00055O0012E7000400093O00264A0004004E0201000100045B3O004E0201002ED6008F00DF2O01009000045B3O00DF2O012O008A00056O0014010600013O00122O000700913O00122O000800926O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005006C02013O00045B3O006C02012O008A00056O0014010600013O00122O000700933O00122O000800946O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005006E02013O00045B3O006E02012O008A00056O0014010600013O00122O000700953O00122O000800966O0006000800024O00050005000600202O0005000500294O00050002000200062O0005006E02013O00045B3O006E0201002E0C009700140001009800045B3O008002012O008A000500024O005300065O00202O0006000600574O000700033O00202O0007000700494O000900086O0007000900024O000700076O00050007000200062O0005007B0201000100045B3O007B0201002E0C009900070001009A00045B3O008002012O008A000500013O0012E70006009B3O0012E70007009C4O0082000500074O007A00055O002ED2009D00A60201009E00045B3O00A602012O008A00056O0014010600013O00122O0007009F3O00122O000800A06O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500A602013O00045B3O00A602012O008A000500093O0020A300050005007B4O00065O00202O0006000600A14O0007000A6O000800013O00122O000900A23O00122O000A00A36O0008000A00024O0009000B6O000A000C6O000B00033O00202O000B000B00494O000D00086O000B000D00024O000B000B6O0005000B000200062O000500A10201000100045B3O00A10201002E0C00A40007000100A500045B3O00A602012O008A000500013O0012E7000600A63O0012E7000700A74O0082000500074O007A00055O0012E7000400023O00045B3O00DF2O0100045B3O00AA020100045B3O00DA2O01002ED600A80058030100A900045B3O0058030100260D000200580301000900045B3O005803010012E7000300013O00264A000300B30201000100045B3O00B30201002ED200AB2O00030100AA00045B4O0003010012E7000400013O00264A000400B80201000200045B3O00B80201002ED600AC00BA020100AD00045B3O00BA02010012E7000300023O00045B4O000301002E0C00AE00FAFF2O00AE00045B3O00B4020100260D000400B40201000100045B3O00B4020100129F000500374O008A000600064O001600050002000700045B3O00DE02010020EA000A0009000C2O0010000A00020002000670000A00DE02013O00045B3O00DE02012O008A000A00033O002052000A000A00AF4O000C000F6O000C000C00084O000A000C000200062O000A00DE02013O00045B3O00DE02012O008A000A00024O0028000B00096O000C00033O00202O000C000C00104O000E00096O000C000E00024O000C000C6O000A000C000200062O000A00D90201000100045B3O00D90201002E0C009A0007000100B000045B3O00DE02012O008A000A00013O0012E7000B00B13O0012E7000C00B24O0082000A000C4O007A000A5O0006D1000500C20201000200045B3O00C20201002ED200B400FE020100B300045B3O00FE02012O008A00056O0014010600013O00122O000700B53O00122O000800B66O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500FE02013O00045B3O00FE0201002E0C00B70012000100B700045B3O00FE02012O008A000500024O00B500065O00202O0006000600B84O000700033O00202O0007000700494O000900086O0007000900024O000700076O00050007000200062O000500FE02013O00045B3O00FE02012O008A000500013O0012E7000600B93O0012E7000700BA4O0082000500074O007A00055O0012E7000400023O00045B3O00B40201000E79000900040301000300045B3O00040301002ED600BB0006030100BC00045B3O000603010012E7000200713O00045B3O00580301000E790002000A0301000300045B3O000A0301002ED600BD00AF020100BE00045B3O00AF02012O008A00046O0014010500013O00122O000600BF3O00122O000700C06O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004002D03013O00045B3O002D03012O008A000400033O0020880004000400524O00065O00202O0006000600534O00040006000200062O0004002D03013O00045B3O002D0301002ED600C2002D030100C100045B3O002D03012O008A000400024O00B500055O00202O0005000500484O000600033O00202O0006000600494O000800086O0006000800024O000600066O00040006000200062O0004002D03013O00045B3O002D03012O008A000400013O0012E7000500C33O0012E7000600C44O0082000400064O007A00045O002E0C00C50029000100C500045B3O005603012O008A00046O0014010500013O00122O000600C63O00122O000700C76O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005603013O00045B3O005603012O008A0004000D4O00BA00058O000600013O00122O000700C83O00122O000800C96O0006000800024O00050005000600202O0005000500854O00050002000200122O000600CA6O00040006000200062O0004005603013O00045B3O005603012O008A000400024O00B500055O00202O0005000500CB4O000600033O00202O0006000600494O000800086O0006000800024O000600066O00040006000200062O0004005603013O00045B3O005603012O008A000400013O0012E7000500CC3O0012E7000600CD4O0082000400064O007A00045O0012E7000300093O00045B3O00AF0201002ED200CE00F6030100CF00045B3O00F6030100260D000200F6030100D000045B3O00F603012O008A00036O0014010400013O00122O000500D13O00122O000600D26O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003008703013O00045B3O008703012O008A000300053O00208800030003001E4O00055O00202O0005000500D34O00030005000200062O0003008703013O00045B3O008703012O008A000300093O0020E200030003007B4O00045O00202O0004000400A14O0005000A6O000600013O00122O000700D43O00122O000800D56O0006000800024O000700106O000800084O008A000900033O00202A0009000900494O000B00086O0009000B00024O000900096O00030009000200062O000300820301000100045B3O00820301002ED600D60087030100D700045B3O008703012O008A000300013O0012E7000400D83O0012E7000500D94O0082000300054O007A00036O008A00036O0014010400013O00122O000500DA3O00122O000600DB6O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300AA03013O00045B3O00AA03012O008A000300093O00205600030003007B4O00045O00202O0004000400DC4O0005000A6O000600013O00122O000700DD3O00122O000800DE6O0006000800024O000700106O000800116O000900033O00202O0009000900104O000B5O00202O000B000B00DC4O0009000B00024O000900096O00030009000200062O000300AA03013O00045B3O00AA03012O008A000300013O0012E7000400DF3O0012E7000500E04O0082000300054O007A00036O008A00036O0014010400013O00122O000500E13O00122O000600E26O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300D303013O00045B3O00D303012O008A0003000D4O001E00048O000500013O00122O000600E33O00122O000700E46O0005000700024O00040004000500202O0004000400854O000400056O00033O000200062O000300D303013O00045B3O00D30301002ED600E600D3030100E500045B3O00D303012O008A000300024O006000045O00202O0004000400CB4O000500033O00202O0005000500104O00075O00202O0007000700CB4O0005000700024O000500056O00030005000200062O000300D303013O00045B3O00D303012O008A000300013O0012E7000400E73O0012E7000500E84O0082000300054O007A00036O008A00036O0014010400013O00122O000500E93O00122O000600EA6O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300F503013O00045B3O00F503012O008A000300093O00208E00030003007B4O00045O00202O0004000400A14O0005000A6O000600013O00122O000700EB3O00122O000800EC6O0006000800024O000700106O000800086O000900033O00202O0009000900494O000B00086O0009000B00024O000900096O00030009000200062O000300F503013O00045B3O00F503012O008A000300013O0012E7000400ED3O0012E7000500EE4O0082000300054O007A00035O0012E7000200EF3O002ED200F00038040100F100045B3O0038040100260D00020038040100EF00045B3O003804012O008A00036O0014010400013O00122O000500F23O00122O000600F36O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003001C04013O00045B3O001C04012O008A000300093O00208E00030003007B4O00045O00202O00040004007C4O0005000A6O000600013O00122O000700F43O00122O000800F56O0006000800024O000700106O000800086O000900033O00202O0009000900494O000B00086O0009000B00024O000900096O00030009000200062O0003001C04013O00045B3O001C04012O008A000300013O0012E7000400F63O0012E7000500F74O0082000300054O007A00036O008A00036O0014010400013O00122O000500F83O00122O000600F96O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300ED04013O00045B3O00ED04012O008A000300024O006000045O00202O0004000400CB4O000500033O00202O0005000500104O00075O00202O0007000700CB4O0005000700024O000500056O00030005000200062O000300ED04013O00045B3O00ED04012O008A000300013O0012D9000400FA3O00122O000500FB6O000300056O00035O00044O00ED0401000EB0007400090001000200045B3O000900010012E7000300013O00264A0003003F0401000900045B3O003F0401002ED600FD0041040100FC00045B3O004104010012E7000200D03O00045B3O0009000100264A000300450401000200045B3O00450401002ED600FF0091040100FE00045B3O009104010012E70004002O012O0026AC0004007004012O0001045B3O007004012O008A00046O0014010500013O00122O00060002012O00122O00070003015O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007004013O00045B3O007004012O008A0004000D4O001E00058O000600013O00122O00070004012O00122O00080005015O0006000800024O00050005000600202O0005000500854O000500066O00043O000200062O0004007004013O00045B3O007004012O008A000400024O002700055O00122O00060006015O0005000500064O000600033O00122O00080007015O00060006000800122O00080008015O0006000800024O000600066O00040006000200062O0004007004013O00045B3O007004012O008A000400013O0012E700050009012O0012E70006000A013O0082000400064O007A00046O008A00046O0014010500013O00122O0006000B012O00122O0007000C015O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004009004013O00045B3O009004012O008A000400043O0006700004009004013O00045B3O009004012O008A000400024O002601055O00122O0006000D015O0005000500064O000600033O00202O0006000600104O00085O00122O0009000D015O0008000800094O0006000800024O000600066O00040006000200062O0004009004013O00045B3O009004012O008A000400013O0012E70005000E012O0012E70006000F013O0082000400064O007A00045O0012E7000300093O0012E700040010012O0012E700050011012O00066C0005003B0401000400045B3O003B04010012E7000400013O00069C0003003B0401000400045B3O003B04010012E700040012012O0012E700050013012O00066C000400BA0401000500045B3O00BA04012O008A00046O0014010500013O00122O00060014012O00122O00070015015O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400BA04013O00045B3O00BA04012O008A000400024O005300055O00202O0005000500484O000600033O00202O0006000600494O000800086O0006000800024O000600066O00040006000200062O000400B50401000100045B3O00B504010012E700040016012O0012E700050017012O000676000500BA0401000400045B3O00BA04012O008A000400013O0012E700050018012O0012E700060019013O0082000400064O007A00046O008A00046O0014010500013O00122O0006001A012O00122O0007001B015O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400CB04013O00045B3O00CB04012O008A000400053O00203D0004000400344O00065O00202O0006000600204O00040006000200062O000400CF0401000100045B3O00CF04010012E70004001C012O0012E70005001D012O000676000400E00401000500045B3O00E004012O008A000400024O006000055O00202O00050005002A4O000600033O00202O0006000600104O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400E004013O00045B3O00E004012O008A000400013O0012E70005001E012O0012E70006001F013O0082000400064O007A00045O0012E7000300023O00045B3O003B040100045B3O0009000100045B3O00ED040100045B3O0006000100045B3O00ED04010012E7000300013O00069C3O00020001000300045B3O000200010012E7000100014O003F000200023O0012E73O00023O00045B3O000200012O002D012O00017O007D012O00028O00026O00F03F025O0028AD40025O00206840025O0020AA40025O00D2A940027O0040030C3O00A0FF8BE83282E380CD3499F503053O005DED90E58F03073O0049735265616479030D3O0034FAE0110A7607F3F4181F490703063O0026759690796B030B3O004973417661696C61626C6503063O0042752O66557003103O004D6F6E672O6F73654675727942752O66030B3O0042752O6652656D61696E7303053O00466F637573030E3O00466F63757343617374526567656E030C4O00B4E03D22B4FD3F0FB2FA3F03043O005A4DDB8E030B3O004578656375746554696D652O033O0047434403103O00532O657468696E675261676542752O66025O008AA640025O00149E40030C3O004D6F6E672O6F736542697465030E3O004973496E4D656C2O6552616E6765025O00BEB140025O00E8984003133O00EB0B2F3E430869E33B233058023AF510616B1C03073O001A866441592C67025O00207540025O0062AB40030E3O00D7EF312DAFF8ED3710B0E3EA3B2603053O00C491835043030A3O0049734361737461626C65030E3O0038BC070613E110B7351C0AE115B503063O00887ED0666878026O003E40030E3O00466C616E6B696E67537472696B6503153O007E86CF4DA45B33564799DA51A65938116B9E8E11FD03083O003118EAAE23CF325D025O00405140030C3O00BBA4FBD27186B5DAD67D86A603053O0014E8C189A2030B3O0014D6D5A3F59F21742CD0C803083O001142BFA5C687EC77026O008540026O007740030C3O00436173745461726765744966030C3O0053657270656E745374696E672O033O0002A6A003083O00B16FCFCE739F888C030E3O0049735370652O6C496E52616E676503133O00168C0204D1414B3A9A041DDA481F169D50458C03073O003F65E97074B42F025O00D88F40030E3O00E52EFF0BF730D733E837F931CF3E03063O0056A35B8D7298026O000840030E3O00467572796F667468654561676C6503153O00551E666A055C0D4B6732563471723D5F0E34602E1303053O005A336B1413025O00207240025O0074A540025O000C9E40025O00F9B14003083O003FE6FC856109F6F803053O00116C929DE8025O00EAAE40025O0066A04003083O005374616D70656465030E3O0058D715E03FAD4FC654FE3BE8199003063O00C82BA3748D4F03123O009C393291B4FDEDBE22388791E7F0BE23319703073O0083DF565DE3D094030F3O00C04AB9A419BCED44A2B3199EEA49BA03063O00D583252OD67D03103O004865616C746850657263656E74616765026O00344003083O0042752O66446F776E030D3O0053706561726865616442752O6603093O00153B20BEF32O2E24BB03053O0081464B45DF030C3O00432O6F6C646F776E446F776E03093O0075DBF6E86EE743CAF703063O008F26AB93891C030F3O00F38DB6E107EADAD196BCF728EAD8DC03073O00B4B0E2D993638303093O00E0A92A06C1B12A06D703043O0067B3D94F03093O0079A719D45384A64BB303073O00C32AD77CB521EC025O004CAF40025O0028874003123O00432O6F7264696E61746564412O7361756C7403193O000E56382C21F10358233B21C70C4A243F30F42O19242A65AA5903063O00986D39575E45026O001440025O006EA240025O002AAD40030B3O000507F7FA0D01F6FB2F00FF03043O00964E6E9B030B3O00AECC2BED8711B24D84CB2303083O0020E5A54781C47EDF026O003540030B3O004B692O6C436F2O6D616E642O033O00CE80CA03063O00B5A3E9A42OE103123O005B82327B6F88317A5D8A307310982A3705D903043O001730EB5E03123O005FD5D74F533ADC7DCEDD597620C17DCFD44903073O00B21CBAB83D3753030F3O00E7C2482EF607FBC5D94238D907F9C803073O0095A4AD275C926E03093O0054696D65546F446965025O00806140025O00F4B140025O00C4A24003193O00F0281F0D1E12FD26041A1E24F234031E0F17E767030B5A4EA703063O007B9347707F7A025O003CA040025O00606440025O0014B040025O00088740030C3O00DE49E3E87FD944E3F765FB4103053O00179A2C829C030C3O0035A3ACBA3E3019A7A6BC371E03063O007371C6CDCE5603093O00B747FB5B965FFB5B8003043O003AE4379E03093O008799D52F2EA530B58D03073O0055D4E9B04E5CCD030A3O00432O6F6C646F776E5570025O005C9240025O00D4AF40030C3O0044656174684368616B72616D025O00449540025O0086B24003123O004E5D89F642678BEA4B539AE347189BF62O0A03043O00822A38E803093O00D9A521E25237EFB42003063O005F8AD5448320030B3O000121AD4F552O25AC42782E03053O00164A48C12303083O00466F6375734D6178026O002440030C3O00087CE54C245AEC59276BE55503043O00384C1984030C3O007AC4AA32C77DC9AA2DDD5FCC03053O00AF3EA1CB4603093O00537065617268656164030E3O002FCDC6122734D8C217752FC9834703053O00555CBDA373030B3O00C0CCBD2OEDE4C8BCE0C0EF03053O00AE8BA5D18103093O0090A3E7C0D40B7579A703083O0018C3D382A1A6631003093O007513EC2D411E4302ED03063O00762663894C33030F3O00432O6F6C646F776E52656D61696E732O033O00F02F0B03063O00409D4665726903113O004BA1ABEF2F43A7AAEE114EACE7F00400FA03053O007020C8C78303093O001F4059B9D1A3272D5403073O00424C303CD8A3CB03093O0089967CF24DC621BB8203073O0044DAE619933FAE03083O00446562752O66557003133O00536872652O64656441726D6F72446562752O66025O0058AF40025O00D0AF4003053O00706169727303123O00BA235F48B0A4385673B4A227510CA5B96A0703053O00D6CD4A332C025O00BEAD40025O00F09340025O0058A140025O0009B14003083O0002A53C341AA43F2C03043O005849CC50031D3O00432O6F7264696E61746564412O7361756C74456D706F77657242752O6603043O000C8A044303063O00BA4EE370264903043O00DF5BFC4203063O001A9C379D353303053O00BFD517DAB303063O0030ECB876B9D8025O00806C4003083O004B692O6C53686F74030E3O00EEB45B3CF027EDB24370DC20A5EB03063O005485DD3750AF030C3O008AEE28A2C155AFE206A9CA5E03063O003CDD8744C6A703103O0046752O6C526563686172676554696D65030A3O00CCB2F58143CBEAB4FD9103063O00B98EDD98E32203123O007BCA58E8473AF959D152FE6220E459D05BEE03073O009738A5379A2353030A3O00824C08ECA15101E7A55103043O008EC0236503163O00432O6F7264696E61746564412O7361756C7442752O66026O001C40025O0016B040025O00F4AB4003123O00C17C25A7E185BE13E97726AEE5CCBF02962203083O0076B61549C387ECCC025O00C6A640025O00D49D40030B3O002335164C2702F0053D144403073O009D685C7A20646D030B3O0088AFC3C61E2880A6A2A8CB03083O00CBC3C6AFAA5D47ED030B3O00054232D9721EF1234A30D103073O009C4E2B5EB5317103093O0042752O66537461636B030D3O00446561646C7944756F42752O66030D3O00446562752O6652656D61696E7303133O00506865726F6D6F6E65426F6D62446562752O66025O00D08340025O00C6A1402O033O007FE1CA03073O00191288A4C36B2303113O00E324A5434DBFCEB5E52CA74B32AFD5F8B003083O00D8884DC92F12DCA1030B3O0006E527D62BD38F20ED25DE03073O00E24D8C4BBA68BC030C3O008EC7DC3B49B0DCD51D40B4CC03053O002FD9AEB05F03073O0048617354696572026O0010402O033O00B5D47803083O0046D8BD1662D2341803113O00D1D6AF8BECD9D0AE8AD2D4DBE394C79A8603053O00B3BABFC3E7025O000C9140025O00C2A540030C3O00D43016E3F6300BE1DB360CE103043O0084995F7803133O00BCBD002AF8D5B3B48D0C24E3DFE0A2A64E7CA703073O00C0D1D26E4D97BA030C3O00CD0C2CEEF0CBF30600E0EBC103063O00A4806342899F030C3O002D86E7B90F86FABB2280FDBB03043O00DE60E989025O001EB240025O0030A64003133O00B4BCA91887FCE3BC8CA5169CF6B0AAA7E74EDA03073O0090D9D3C77FE89303083O00D3263224E64D0D5003083O0024984F5E48B52562030F3O00DCD14B33E8CB4F30C398542B97891303043O005FB7B827030C3O00873EF7325B9231A12DEE2D5103073O0062D55F874634E0030C3O00CCA2D9635BEC90DD655DF5A603053O00349EC3A917030C3O00526170746F72537472696B65025O00309440025O003EB14003133O0068BD2260892744986EAE3B7F8375689F3AED6403083O00EB1ADC5214E6551B025O006EAB40025O00A8A040025O00208D40025O0008AF40025O00D0B140025O000CA540030A3O00446562752O66446F776E025O00C6A340025O0002AF4003113O00E8E9BEBD0E37EDE58DBB0733FDA0A1AD4803063O005E9F80D2D968030C3O007DF608B85070EA7F72F012BA03083O001A309966DF3F1F99025O00108740025O0022A140025O00FEB140025O008CAA402O033O000F41F503043O009362208D03133O00154CEDCD0959581D7CE1C312532O0B57A3995003073O002B782383AA6636025O00F49C40025O00389B40030B3O00D2DE06AF9DDD59A5F8D90E03083O00C899B76AC3DEB2342O033O003FEA8603063O003A5283E85D29025O0014A340025O0008A44003123O00885EDC19623C8C5ADD14533BC344C4550F6703063O005FE337B0753D030C3O002B7B315BAE166A105FA2167903053O00CB781E432B030B3O00C72C5DEACBE21348E1D6FC03053O00B991452D8F2O033O0087161703053O00BCEA7F79C603133O002B3701933D3C07BC2B261A8D3F72009778614103043O00E3585273025O0016B140025O0048B040030C3O007416B6A3047A511A98A80F7103063O0013237FDAC762025O00E0B140025O004AB340025O00E4A640025O0048844003133O000BF206E61AF218E723F905EF1EBB19F65CA85E03043O00827C9B6A030C3O00F8C4F8A8ACF96FBAF7C2E2AA03083O00DFB5AB96CFC3961C03123O0053687261706E656C426F6D62446562752O66025O00C89540025O00A0604003133O004135EDA9064329E6910B452EE6EE1A587AB0FE03053O00692C5A83CE026O007B40025O00F07E4003093O001BCF5887424B3ADA4D03063O001F48BB3DE22E025O00805040025O00C0964003093O0053742O656C5472617003093O004973496E52616E6765026O00444003103O00D01246D74B4130D1075392546A64975E03073O0044A36623B2271E025O00708B40025O002CA940025O00C06F40025O00B2A94003133O00A979D6C305BC91148172D5CA01F59005FE258A03083O0071DE10BAA763D5E3025O002EA540025O00088640025O0094A340025O004CAA40025O00C05E40025O00508740025O005CB140025O00F08B40030C3O00D23C070D3DF7EC362B0326FD03063O00989F53696A52030B3O00AACF5DFEEA538CCB50FCCD03063O003CE1A63192A92O033O00221F3703063O00674F7E4F4A6103133O00B770DD745115A97AEC71570EBF3FC0671E4EEA03063O007ADA1FB3133E030C3O0081D7DDD5C6B376A72OC4CACC03073O0025D3B6ADA1A9C12O033O00FA3B5503073O00D9975A2DB9481B03133O00D17DF70659D143F40644CA77E25245D73CB34403053O0036A31C8772025O00809540025O00388240030D3O00711E97BAAAA38D4203B4BEAAA403073O00E43466E7D6C5D003063O002CE17BCDEF9903083O00B67E8015AA8AEB79025O00F6A240025O002EA340025O0082AA40025O0052A540030D3O004578706C6F7369766553686F7403143O008EC225EA890039108EE526EE890770159F9A66B103083O0066EBBA5586E67350030E3O0071192C467DD2365F091B5E75D82703073O0042376C5E3F12B4025O0040504003103O002698913F2B5C079EA83635580189802503063O003974EDE55747025O004FB04003153O00ACA4FFFE48E14195A5E5E248EB46ADBDE8A764FA0703073O0027CAD18D87178E025O00E8B140025O00789D4000F8072O0012E73O00014O003F000100023O00260D3O00F00701000200045B3O00F0070100264A000100080001000100045B3O00080001002E0C000300FEFF2O000400045B3O000400010012E7000200013O002ED60006008B2O01000500045B3O008B2O0100260D0002008B2O01000700045B3O008B2O010012E7000300013O00260D0003008F0001000200045B3O008F00012O008A00046O0014010500013O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004005100013O00045B3O005100012O008A00046O0014010500013O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004004700013O00045B3O004700012O008A000400023O00208800040004000E4O00065O00202O00060006000F4O00040006000200062O0004004700013O00045B3O004700012O008A000400023O0020710004000400104O00065O00202O00060006000F4O0004000600024O000500023O00202O0005000500114O0005000200024O000600036O000700023O00202O0007000700122O008A00096O000F000A00013O00122O000B00133O00122O000C00146O000A000C00024O00090009000A00202O0009000900154O0009000A6O00073O00024O0006000600074O0005000500062O008A000600023O0020EA0006000600162O00100006000200022O002901050005000600064C000400530001000500045B3O005300012O008A000400023O00208800040004000E4O00065O00202O0006000600174O00040006000200062O0004005100013O00045B3O005100012O008A000400043O00264A000400530001000200045B3O00530001002ED2001800650001001900045B3O006500012O008A000400054O005300055O00202O00050005001A4O000600063O00202O00060006001B4O000800076O0006000800024O000600066O00040006000200062O000400600001000100045B3O00600001002ED6001C00650001001D00045B3O006500012O008A000400013O0012E70005001E3O0012E70006001F4O0082000400064O007A00045O002ED60020008E0001002100045B3O008E00012O008A00046O0014010500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O0004000400244O00040002000200062O0004008E00013O00045B3O008E00012O008A000400084O00BA00058O000600013O00122O000700253O00122O000800266O0006000800024O00050005000600202O0005000500154O00050002000200122O000600276O00040006000200062O0004008E00013O00045B3O008E00012O008A000400054O00B500055O00202O0005000500284O000600063O00202O00060006001B4O000800076O0006000800024O000600066O00040006000200062O0004008E00013O00045B3O008E00012O008A000400013O0012E7000500293O0012E70006002A4O0082000400064O007A00045O0012E7000300073O002E0C002B00620001002B00045B3O00F1000100260D000300F10001000100045B3O00F100012O008A00046O0014010500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400A700013O00045B3O00A700012O008A00046O0014010500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400A900013O00045B3O00A90001002E0C0030001B0001003100045B3O00C200012O008A000400093O0020560004000400324O00055O00202O0005000500334O0006000A6O000700013O00122O000800343O00122O000900356O0007000900024O0008000B6O0009000C6O000A00063O00202O000A000A00364O000C5O00202O000C000C00334O000A000C00024O000A000A6O0004000A000200062O000400C200013O00045B3O00C200012O008A000400013O0012E7000500373O0012E7000600384O0082000400064O007A00045O002E0C0039002E0001003900045B3O00F000012O008A00046O0014010500013O00122O0006003A3O00122O0007003B6O0005000700024O00040004000500202O0004000400244O00040002000200062O000400F000013O00045B3O00F000012O008A000400023O00208800040004000E4O00065O00202O0006000600174O00040006000200062O000400F000013O00045B3O00F000012O008A000400023O00207E0004000400104O00065O00202O0006000600174O0004000600024O000500023O00202O0005000500164O00050002000200102O0005003C000500062O000400F00001000500045B3O00F000012O008A000400054O00B500055O00202O00050005003D4O000600063O00202O00060006001B4O000800076O0006000800024O000600066O00040006000200062O000400F000013O00045B3O00F000012O008A000400013O0012E70005003E3O0012E70006003F4O0082000400064O007A00045O0012E7000300023O00264A000300F50001003C00045B3O00F50001002ED2004100F70001004000045B3O00F700010012E70002003C3O00045B3O008B2O01002ED20042000E0001004300045B3O000E000100260D0003000E0001000700045B3O000E00012O008A00046O0014010500013O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400244O00040002000200062O000400082O013O00045B3O00082O012O008A0004000D3O00060C0104000A2O01000100045B3O000A2O01002E0C004600130001004700045B3O001B2O012O008A000400054O006000055O00202O0005000500484O000600063O00202O0006000600364O00085O00202O0008000800484O0006000800024O000600066O00040006000200062O0004001B2O013O00045B3O001B2O012O008A000400013O0012E7000500493O0012E70006004A4O0082000400064O007A00046O008A00046O0014010500013O00122O0006004B3O00122O0007004C6O0005000700024O00040004000500202O0004000400244O00040002000200062O000400892O013O00045B3O00892O012O008A0004000D3O000670000400892O013O00045B3O00892O012O008A00046O0034000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400522O01000100045B3O00522O012O008A000400063O0020EA00040004004F2O00100004000200020026E0000400522O01005000045B3O00522O012O008A000400023O0020880004000400514O00065O00202O0006000600524O00040006000200062O000400482O013O00045B3O00482O012O008A00046O0034000500013O00122O000600533O00122O000700546O0005000700024O00040004000500202O0004000400554O00040002000200062O000400772O01000100045B3O00772O012O008A00046O0014010500013O00122O000600563O00122O000700576O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400772O013O00045B3O00772O012O008A00046O0014010500013O00122O000600583O00122O000700596O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400892O013O00045B3O00892O012O008A000400023O0020880004000400514O00065O00202O0006000600524O00040006000200062O0004006D2O013O00045B3O006D2O012O008A00046O0034000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400554O00040002000200062O000400772O01000100045B3O00772O012O008A00046O0034000500013O00122O0006005C3O00122O0007005D6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400892O01000100045B3O00892O01002ED2005F00892O01005E00045B3O00892O012O008A000400054O00B500055O00202O0005000500604O000600063O00202O00060006001B4O000800076O0006000800024O000600066O00040006000200062O000400892O013O00045B3O00892O012O008A000400013O0012E7000500613O0012E7000600624O0082000400064O007A00045O0012E70003003C3O00045B3O000E000100260D000200EB2O01006300045B3O00EB2O01002ED6006400BF2O01006500045B3O00BF2O012O008A00036O0014010400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O0003000300244O00030002000200062O000300BF2O013O00045B3O00BF2O012O008A000300084O00BA00048O000500013O00122O000600683O00122O000700696O0005000700024O00040004000500202O0004000400154O00040002000200122O0005006A6O00030005000200062O000300BF2O013O00045B3O00BF2O012O008A000300093O0020080003000300324O00045O00202O00040004006B4O0005000A6O000600013O00122O0007006C3O00122O0008006D6O0006000800024O0007000E6O000800086O000900063O00202O0009000900364O000B5O00202O000B000B006B4O0009000B00024O000900096O00030009000200062O000300BF2O013O00045B3O00BF2O012O008A000300013O0012E70004006E3O0012E70005006F4O0082000300054O007A00036O008A00036O0014010400013O00122O000500703O00122O000600716O0004000600024O00030003000400202O0003000300244O00030002000200062O000300D82O013O00045B3O00D82O012O008A00036O0034000400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300D82O01000100045B3O00D82O012O008A000300063O0020EA0003000300742O0010000300020002000ECB007500DA2O01000300045B3O00DA2O01002ED6007600F70701007700045B3O00F707012O008A000300054O00B500045O00202O0004000400604O000500063O00202O00050005001B4O000700076O0005000700024O000500056O00030005000200062O000300F707013O00045B3O00F707012O008A000300013O0012D9000400783O00122O000500796O000300056O00035O00044O00F70701002ED2007B00C20301007A00045B3O00C2030100260D000200C20301000100045B3O00C203010012E7000300013O002ED2007D00990201007C00045B3O0099020100260D000300990201000200045B3O009902010012E7000400013O00260D000400F92O01000200045B3O00F92O010012E7000300073O00045B3O0099020100260D000400F52O01000100045B3O00F52O012O008A00056O0014010600013O00122O0007007E3O00122O0008007F6O0006000800024O00050005000600202O0005000500244O00050002000200062O0005002502013O00045B3O002502012O008A000500084O005100068O000700013O00122O000800803O00122O000900816O0007000900024O00060006000700202O0006000600154O000600076O00053O000200062O000500270201000100045B3O002702012O008A00056O0014010600013O00122O000700823O00122O000800836O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005002502013O00045B3O002502012O008A00056O0034000600013O00122O000700843O00122O000800856O0006000800024O00050005000600202O0005000500864O00050002000200062O000500270201000100045B3O00270201002ED20088003A0201008700045B3O003A02012O008A000500054O001C01065O00202O0006000600894O000700063O00202O0007000700364O00095O00202O0009000900894O0007000900024O000700076O00050007000200062O000500350201000100045B3O00350201002E0C008A00070001008B00045B3O003A02012O008A000500013O0012E70006008C3O0012E70007008D4O0082000500074O007A00056O008A00056O0014010600013O00122O0007008E3O00122O0008008F6O0006000800024O00050005000600202O0005000500244O00050002000200062O0005009702013O00045B3O009702012O008A0005000D3O0006700005009702013O00045B3O009702012O008A0005000F4O0019010600023O00202O0006000600114O0006000200024O000700023O00202O0007000700124O00098O000A00013O00122O000B00903O00122O000C00916O000A000C00022O00A700090009000A0020C50009000900154O0009000A6O00073O00024O00060006000700122O0007006A6O0005000700024O000600106O000700023O00202O0007000700114O0007000200022O008A000800023O00209B0008000800124O000A8O000B00013O00122O000C00903O00122O000D00916O000B000D00024O000A000A000B00202O000A000A00154O000A000B6O00083O00022O005C0007000700080012A80008006A6O0006000800024O0005000500064O000600023O00202O0006000600924O00060002000200202O00060006009300062O000600970201000500045B3O009702012O008A00056O0034000600013O00122O000700943O00122O000800956O0006000800024O00050005000600202O0005000500554O00050002000200062O000500860201000100045B3O008602012O008A00056O0034000600013O00122O000700963O00122O000800976O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500970201000100045B3O009702012O008A000500054O006000065O00202O0006000600984O000700063O00202O0007000700364O00095O00202O0009000900984O0007000900024O000700076O00050007000200062O0005009702013O00045B3O009702012O008A000500013O0012E7000600993O0012E70007009A4O0082000500074O007A00055O0012E7000400023O00045B3O00F52O0100260D000300110301000100045B3O001103012O008A00046O0014010500013O00122O0006009B3O00122O0007009C6O0005000700024O00040004000500202O0004000400244O00040002000200062O000400D602013O00045B3O00D602012O008A00046O0014010500013O00122O0006009D3O00122O0007009E6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400D602013O00045B3O00D602012O008A00046O0014000500013O00122O0006009F3O00122O000700A06O0005000700024O00040004000500202O0004000400A14O0004000200022O0003010500023O00202O0005000500164O00050002000200102O00050007000500062O000400D60201000500045B3O00D602012O008A000400093O0020560004000400324O00055O00202O00050005006B4O0006000A6O000700013O00122O000800A23O00122O000900A36O0007000900024O0008000E6O000900116O000A00063O00202O000A000A00364O000C5O00202O000C000C006B4O000A000C00024O000A000A6O0004000A000200062O000400D602013O00045B3O00D602012O008A000400013O0012E7000500A43O0012E7000600A54O0082000400064O007A00046O008A00046O0014010500013O00122O000600A63O00122O000700A76O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400F502013O00045B3O00F502012O008A00046O0014000500013O00122O000600A83O00122O000700A96O0005000700024O00040004000500202O0004000400A14O0004000200022O0003010500023O00202O0005000500164O00050002000200102O00050007000500062O000400F50201000500045B3O00F502012O008A000400063O00203D0004000400AA4O00065O00202O0006000600AB4O00040006000200062O000400F70201000100045B3O00F70201002ED600AD0010030100AC00045B3O0010030100129F000400AE4O008A000500124O001600040002000600045B3O000E03010020EA0009000800242O00100009000200020006700009000E03013O00045B3O000E03012O008A000900054O00B8000A00086O000B00063O00202O000B000B00364O000D00086O000B000D00024O000B000B6O0009000B000200062O0009000E03013O00045B3O000E03012O008A000900013O0012E7000A00AF3O0012E7000B00B04O00820009000B4O007A00095O0006D1000400FB0201000200045B3O00FB02010012E7000300023O002ED600B20017030100B100045B3O0017030100260D000300170301003C00045B3O001703010012E7000200023O00045B3O00C20301002ED600B300F02O0100B400045B3O00F02O0100260D000300F02O01000700045B3O00F02O012O008A00046O0014010500013O00122O000600B53O00122O000700B66O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004005D03013O00045B3O005D03012O008A000400023O00208800040004000E4O00065O00202O0006000600B74O00040006000200062O0004005D03013O00045B3O005D03012O008A00046O0034000500013O00122O000600B83O00122O000700B96O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004004A0301000100045B3O004A03012O008A00046O0034000500013O00122O000600BA3O00122O000700BB6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004004A0301000100045B3O004A03012O008A00046O0014010500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004005D03013O00045B3O005D0301002E0C00BE0013000100BE00045B3O005D03012O008A000400054O006000055O00202O0005000500BF4O000600063O00202O0006000600364O00085O00202O0008000800BF4O0006000800024O000600066O00040006000200062O0004005D03013O00045B3O005D03012O008A000400013O0012E7000500C03O0012E7000600C14O0082000400064O007A00046O008A000400063O0020880004000400AA4O00065O00202O0006000600AB4O00040006000200062O000400A203013O00045B3O00A203012O008A00046O00F5000500013O00122O000600C23O00122O000700C36O0005000700024O00040004000500202O0004000400C44O0004000200024O000500023O00202O0005000500164O00050002000200102O00050007000500062O000400A50301000500045B3O00A503012O008A00046O0014010500013O00122O000600C53O00122O000700C66O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004008603013O00045B3O008603012O008A00046O0034000500013O00122O000600C73O00122O000700C86O0005000700024O00040004000500202O0004000400864O00040002000200062O000400A50301000100045B3O00A503012O008A00046O0014010500013O00122O000600C93O00122O000700CA6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400A203013O00045B3O00A203012O008A000400023O00208800040004000E4O00065O00202O0006000600CB4O00040006000200062O000400A203013O00045B3O00A203012O008A000400023O0020A00004000400104O00065O00202O0006000600CB4O0004000600024O000500023O00202O0005000500164O00050002000200102O00050007000500062O000400A50301000500045B3O00A503012O008A000400133O0026E0000400C0030100CC00045B3O00C0030100129F000400AE4O008A000500124O001600040002000600045B3O00BE03010020EA0009000800242O0010000900020002000670000900BE03013O00045B3O00BE03012O008A000900054O0028000A00086O000B00063O00202O000B000B00364O000D00086O000B000D00024O000B000B6O0009000B000200062O000900B90301000100045B3O00B90301002ED600CD00BE030100CE00045B3O00BE03012O008A000900013O0012E7000A00CF3O0012E7000B00D04O00820009000B4O007A00095O0006D1000400A90301000200045B3O00A903010012E70003003C3O00045B3O00F02O01000E79000200C60301000200045B3O00C60301002ED200D10026050100D200045B3O002605012O008A00036O0014010400013O00122O000500D33O00122O000600D46O0004000600024O00030003000400202O0003000300244O00030002000200062O0003001A04013O00045B3O001A04012O008A00036O000B000400013O00122O000500D53O00122O000600D66O0004000600024O00030003000400202O0003000300C44O0003000200024O000400023O00202O0004000400164O00040002000200062O0003001A0401000400045B3O001A04012O008A000300084O00BA00048O000500013O00122O000600D73O00122O000700D86O0005000700024O00040004000500202O0004000400154O00040002000200122O0005006A6O00030005000200062O0003001A04013O00045B3O001A04012O008A000300023O0020BC0003000300D94O00055O00202O0005000500DA4O000300050002000E2O000700FF0301000300045B3O00FF03012O008A000300023O00208800030003000E4O00055O00202O0005000500524O00030005000200062O0003001A04013O00045B3O001A04012O008A000300063O0020880003000300DB4O00055O00202O0005000500DC4O00030005000200062O0003001A04013O00045B3O001A0401002ED600DD001A040100DE00045B3O001A04012O008A000300093O0020080003000300324O00045O00202O00040004006B4O0005000A6O000600013O00122O000700DF3O00122O000800E06O0006000800024O0007000E6O000800086O000900063O00202O0009000900364O000B5O00202O000B000B006B4O0009000B00024O000900096O00030009000200062O0003001A04013O00045B3O001A04012O008A000300013O0012E7000400E13O0012E7000500E24O0082000300054O007A00036O008A00036O0014010400013O00122O000500E33O00122O000600E46O0004000600024O00030003000400202O0003000300244O00030002000200062O0003005904013O00045B3O005904012O008A00036O0014000400013O00122O000500E53O00122O000600E66O0004000600024O00030003000400202O0003000300C44O0003000200022O0003010400023O00202O0004000400164O00040002000200102O0004003C000400062O000300590401000400045B3O005904012O008A000300023O0020330103000300E700122O000500273O00122O000600E86O00030006000200062O0003005904013O00045B3O005904012O008A000300023O0020880003000300514O00055O00202O0005000500524O00030005000200062O0003005904013O00045B3O005904012O008A000300093O0020560003000300324O00045O00202O00040004006B4O0005000A6O000600013O00122O000700E93O00122O000800EA6O0006000800024O0007000E6O000800146O000900063O00202O0009000900364O000B5O00202O000B000B006B4O0009000B00024O000900096O00030009000200062O0003005904013O00045B3O005904012O008A000300013O0012E7000400EB3O0012E7000500EC4O0082000300054O007A00035O002ED600ED007C040100EE00045B3O007C04012O008A00036O0014010400013O00122O000500EF3O00122O000600F06O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003007C04013O00045B3O007C04012O008A000300023O00208800030003000E4O00055O00202O0005000500524O00030005000200062O0003007C04013O00045B3O007C04012O008A000300054O00B500045O00202O00040004001A4O000500063O00202O00050005001B4O000700076O0005000700024O000500056O00030005000200062O0003007C04013O00045B3O007C04012O008A000300013O0012E7000400F13O0012E7000500F24O0082000300054O007A00036O008A00036O0014010400013O00122O000500F33O00122O000600F46O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300C604013O00045B3O00C604012O008A000300043O00260D000300A30401000200045B3O00A304012O008A000300063O0020040103000300744O0003000200024O000400023O00202O0004000400114O0004000200024O000500036O000600023O00202O0006000600124O00088O000900013O0012E7000A00F53O0012F9000B00F66O0009000B00024O00080008000900202O0008000800154O000800096O00063O00024O0005000500064O0004000400054O000500023O00202O0005000500162O00100005000200022O002901040004000500064C000300B40401000400045B3O00B404012O008A000300023O00208800030003000E4O00055O00202O00050005000F4O00030005000200062O000300C604013O00045B3O00C604012O008A000300023O0020C90003000300104O00055O00202O00050005000F4O0003000500024O000400023O00202O0004000400164O00040002000200062O000300C60401000400045B3O00C60401002ED600F800C6040100F700045B3O00C604012O008A000300054O00B500045O00202O00040004001A4O000500063O00202O00050005001B4O000700076O0005000700024O000500056O00030005000200062O000300C604013O00045B3O00C604012O008A000300013O0012E7000400F93O0012E7000500FA4O0082000300054O007A00036O008A00036O0014010400013O00122O000500FB3O00122O000600FC6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300E804013O00045B3O00E804012O008A000300023O0020880003000300514O00055O00202O0005000500CB4O00030005000200062O000300E804013O00045B3O00E804012O008A000300054O006000045O00202O0004000400BF4O000500063O00202O0005000500364O00075O00202O0007000700BF4O0005000700024O000500056O00030005000200062O000300E804013O00045B3O00E804012O008A000300013O0012E7000400FD3O0012E7000500FE4O0082000300054O007A00036O008A00036O0014010400013O00122O000500FF3O00122O00062O00015O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003002505013O00045B3O002505012O008A000300043O0012E7000400023O00069C000300250501000400045B3O002505012O008A000300063O0020170003000300744O0003000200024O000400023O00202O0004000400114O0004000200024O000500036O000600023O00202O0006000600124O00088O000900013O00122O000A002O012O00122O000B0002015O0009000B00024O00080008000900202O0008000800154O000800096O00063O00024O0005000500064O0004000400054O000500023O00202O0005000500164O0005000200024O00040004000500062O000300250501000400045B3O002505012O008A000300054O008700045O00122O00050003015O0004000400054O000500063O00202O00050005001B4O000700076O0005000700024O000500056O00030005000200062O000300200501000100045B3O002005010012E700030004012O0012E700040005012O00066C000400250501000300045B3O002505012O008A000300013O0012E700040006012O0012E700050007013O0082000300054O007A00035O0012E7000200073O0012E700030008012O0012E700040008012O00069C0003007E0601000400045B3O007E06010012E70003003C3O00069C0002007E0601000300045B3O007E06010012E7000300014O003F000400043O0012E700050009012O0012E700060009012O00069C0005002F0501000600045B3O002F05010012E7000500013O00069C0003002F0501000500045B3O002F05010012E7000400013O0012E70005000A012O0012E70006000B012O000676000500B10501000600045B3O00B105010012E7000500073O00069C000400B10501000500045B3O00B105012O008A000500023O0020860005000500E700122O000700273O00122O000800E86O00050008000200062O000500490501000100045B3O004905010012E70005000C012O0012E70006000D012O0006760005007F0501000600045B3O007F050100129F000500AE4O008A000600124O001600050002000700045B3O007D05010020EA000A000900242O0010000A00020002000670000A007D05013O00045B3O007D05012O008A000A00063O001221010C000E015O000A000A000C4O000C00156O000C000C00084O000A000C000200062O000A006605013O00045B3O006605012O008A000A00063O002088000A000A00AA4O000C5O00202O000C000C00AB4O000A000C000200062O000A006605013O00045B3O006605012O008A000A00083O0020EA000B000900152O002B010B000C4O007B000A3O000200060C010A006A0501000100045B3O006A05012O008A000A00043O0012E7000B00023O00066C000B007D0501000A00045B3O007D05012O008A000A00054O0028000B00096O000C00063O00202O000C000C00364O000E00096O000C000E00024O000C000C6O000A000C000200062O000A00780501000100045B3O007805010012E7000A000F012O0012E7000B0010012O000676000B007D0501000A00045B3O007D05012O008A000A00013O0012E7000B0011012O0012E7000C0012013O0082000A000C4O007A000A5O0006D10005004D0501000200045B3O004D05012O008A00056O0014010600013O00122O00070013012O00122O00080014015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009005013O00045B3O009005012O008A000500023O00203D00050005000E4O00075O00202O00070007000F4O00050007000200062O000500940501000100045B3O009405010012E700050015012O0012E700060016012O00066C000600B00501000500045B3O00B005010012E700050017012O0012E700060018012O000676000600B00501000500045B3O00B005012O008A000500093O00208E0005000500324O00065O00202O00060006001A4O0007000A6O000800013O00122O00090019012O00122O000A001A015O0008000A00024O000900166O000A000A6O000B00063O00202O000B000B001B4O000D00076O000B000D00024O000B000B6O0005000B000200062O000500B005013O00045B3O00B005012O008A000500013O0012E70006001B012O0012E70007001C013O0082000500074O007A00055O0012E70004003C3O0012E7000500013O00069C0004000D0601000500045B3O000D06010012E70005001D012O0012E70006001E012O00066C000600DF0501000500045B3O00DF05012O008A00056O0014010600013O00122O0007001F012O00122O00080020015O0006000800024O00050005000600202O0005000500244O00050002000200062O000500DF05013O00045B3O00DF05012O008A000500093O00206D0005000500324O00065O00202O00060006006B4O0007000A6O000800013O00122O00090021012O00122O000A0022015O0008000A00024O0009000E6O000A00174O008A000B00063O002037010B000B00364O000D5O00202O000D000D006B4O000B000D00024O000B000B6O0005000B000200062O000500DA0501000100045B3O00DA05010012E700050023012O0012E700060024012O00066C000600DF0501000500045B3O00DF05012O008A000500013O0012E700060025012O0012E700070026013O0082000500074O007A00056O008A00056O0014010600013O00122O00070027012O00122O00080028015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005000C06013O00045B3O000C06012O008A00056O0034000600013O00122O00070029012O00122O0008002A015O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005000C0601000100045B3O000C06012O008A000500093O0020560005000500324O00065O00202O0006000600334O0007000A6O000800013O00122O0009002B012O00122O000A002C015O0008000A00024O0009000B6O000A00186O000B00063O00202O000B000B00364O000D5O00202O000D000D00334O000B000D00024O000B000B6O0005000B000200062O0005000C06013O00045B3O000C06012O008A000500013O0012E70006002D012O0012E70007002E013O0082000500074O007A00055O0012E7000400023O0012E70005002F012O0012E700060030012O000676000600760601000500045B3O007606010012E7000500023O00069C000400760601000500045B3O007606010012E7000500013O0012E7000600013O00069C000500700601000600045B3O007006012O008A00066O0014000700013O00122O00080031012O00122O00090032015O0007000900024O00060006000700202O0006000600C44O0006000200022O00C2000700023O00202O0007000700164O00070002000200122O000800076O00070008000700062O000700280601000600045B3O0028060100045B3O0049060100129F000600AE4O008A000700124O001600060002000800045B3O004706010020EA000B000A00242O0010000B0002000200060C010B00340601000100045B3O003406010012E7000B0033012O0012E7000C0034012O00066C000C00470601000B00045B3O004706010012E7000B0035012O0012E7000C0036012O00066C000C00470601000B00045B3O004706012O008A000B00054O00B8000C000A6O000D00063O00202O000D000D00364O000F000A6O000D000F00024O000D000D6O000B000D000200062O000B004706013O00045B3O004706012O008A000B00013O0012E7000C0037012O0012E7000D0038013O0082000B000D4O007A000B5O0006D10006002C0601000200045B3O002C06012O008A00066O0014010700013O00122O00080039012O00122O0009003A015O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006005B06013O00045B3O005B06012O008A000600063O0020920006000600AA4O00085O00122O0009003B015O0008000800094O00060008000200062O0006005F0601000100045B3O005F06010012E70006003C012O0012E70007003D012O00066C0006006F0601000700045B3O006F06012O008A000600054O00B500075O00202O00070007001A4O000800063O00202O00080008001B4O000A00076O0008000A00024O000800086O00060008000200062O0006006F06013O00045B3O006F06012O008A000600013O0012E70007003E012O0012E70008003F013O0082000600084O007A00065O0012E7000500023O0012E7000600023O00069C000500150601000600045B3O001506010012E7000400073O00045B3O0076060100045B3O001506010012E70005003C3O00069C000400370501000500045B3O003705010012E7000200E83O00045B3O007E060100045B3O0037050100045B3O007E060100045B3O002F05010012E7000300E83O00069C000200090001000300045B3O000900010012E7000300013O0012E7000400073O00069C000300E10601000400045B3O00E106010012E7000400013O0012E7000500013O0006EF0004008D0601000500045B3O008D06010012E700050040012O0012E700060041012O00069C000500D70601000600045B3O00D706012O008A00056O0014010600013O00122O00070042012O00122O00080043015O0006000800024O00050005000600202O0005000500244O00050002000200062O000500AD06013O00045B3O00AD06010012E700050044012O0012E700060045012O00066C000500AD0601000600045B3O00AD06012O008A000500054O002700065O00122O00070046015O0006000600074O000700063O00122O00090047015O00070007000900122O00090048015O0007000900024O000700076O00050007000200062O000500AD06013O00045B3O00AD06012O008A000500013O0012E700060049012O0012E70007004A013O0082000500074O007A00055O00129F000500AE4O008A000600124O001600050002000700045B3O00D406010020EA000A000900242O0010000A00020002000670000A00BD06013O00045B3O00BD06012O008A000A00063O001297000C000E015O000A000A000C4O000C00156O000C000C00084O000A000C000200062O000A00C10601000100045B3O00C106010012E7000A004B012O0012E7000B004C012O000676000B00D40601000A00045B3O00D406012O008A000A00054O0028000B00096O000C00063O00202O000C000C00364O000E00096O000C000E00024O000C000C6O000A000C000200062O000A00CF0601000100045B3O00CF06010012E7000A004D012O0012E7000B004E012O000676000B00D40601000A00045B3O00D406012O008A000A00013O0012E7000B004F012O0012E7000C0050013O0082000A000C4O007A000A5O0006D1000500B10601000200045B3O00B106010012E7000400023O0012E7000500023O0006EF000500DE0601000400045B3O00DE06010012E700050051012O0012E700060052012O000676000500860601000600045B3O008606010012E70003003C3O00045B3O00E1060100045B3O008606010012E70004003C3O00069C000300E60601000400045B3O00E606010012E7000200633O00045B3O000900010012E7000400023O0006EF000300ED0601000400045B3O00ED06010012E700040053012O0012E700050054012O000676000500780701000400045B3O007807010012E7000400013O0012E7000500023O0006EF000400F50601000500045B3O00F506010012E700050055012O0012E700060056012O00066C000600F70601000500045B3O00F706010012E7000300073O00045B3O007807010012E7000500013O0006EF000400FE0601000500045B3O00FE06010012E700050057012O0012E700060058012O000676000500EE0601000600045B3O00EE06012O008A00056O0014010600013O00122O00070059012O00122O0008005A015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005307013O00045B3O005307012O008A0005000F4O0037000600023O00202O0006000600114O0006000200024O000700023O00202O0007000700124O00098O000A00013O00122O000B005B012O00122O000C005C015O000A000C00024O00090009000A00202O0009000900154O0009000A6O00073O00024O00060006000700122O0007006A6O0005000700024O000600106O000700023O00202O0007000700114O0007000200024O000800023O00202O0008000800124O000A8O000B00013O00122O000C005B012O00122O000D005C015O000B000D00024O000A000A000B00202O000A000A00154O000A000B6O00083O00024O00070007000800122O0008006A6O0006000800024O0005000500064O000600023O00202O0006000600924O00060002000200122O000700936O00060006000700062O0006003B0701000500045B3O003B07012O008A000500023O0020330105000500E700122O000700273O00122O000800E86O00050008000200062O0005005307013O00045B3O005307012O008A000500093O00208E0005000500324O00065O00202O00060006001A4O0007000A6O000800013O00122O0009005D012O00122O000A005E015O0008000A00024O000900166O000A000A6O000B00063O00202O000B000B001B4O000D00076O000B000D00024O000B000B6O0005000B000200062O0005005307013O00045B3O005307012O008A000500013O0012E70006005F012O0012E700070060013O0082000500074O007A00056O008A00056O0014010600013O00122O00070061012O00122O00080062015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005007607013O00045B3O007607012O008A000500093O0020610005000500324O00065O00122O00070003015O0006000600074O0007000A6O000800013O00122O00090063012O00122O000A0064015O0008000A00024O000900164O003F000A000A4O00F8000B00063O00202O000B000B001B4O000D00076O000B000D00024O000B000B6O0005000B000200062O0005007607013O00045B3O007607012O008A000500013O0012E700060065012O0012E700070066013O0082000500074O007A00055O0012E7000400023O00045B3O00EE06010012E700040067012O0012E700050068012O00066C000500820601000400045B3O008206010012E7000400013O00069C000300820601000400045B3O008206010012E7000400013O0012E7000500013O00069C000400E10701000500045B3O00E107012O008A00056O0014010600013O00122O00070069012O00122O0008006A015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009707013O00045B3O009707012O008A00056O0034000600013O00122O0007006B012O00122O0008006C015O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005009B0701000100045B3O009B07010012E70005006D012O0012E70006006E012O00069C000500B20701000600045B3O00B207010012E70005006F012O0012E700060070012O000676000600B20701000500045B3O00B207012O008A000500054O002601065O00122O00070071015O0006000600074O000700063O00202O0007000700364O00095O00122O000A0071015O00090009000A4O0007000900024O000700076O00050007000200062O000500B207013O00045B3O00B207012O008A000500013O0012E700060072012O0012E700070073013O0082000500074O007A00056O008A00056O0014010600013O00122O00070074012O00122O00080075015O0006000800024O00050005000600202O0005000500244O00050002000200062O000500E007013O00045B3O00E007012O008A000500063O0020EA00050005004F2O00100005000200020012E700060076012O00066C000500E00701000600045B3O00E007012O008A00056O0014010600013O00122O00070077012O00122O00080078015O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500E007013O00045B3O00E007010012E700050079012O0012E700060079012O00069C000500E00701000600045B3O00E007012O008A000500054O00B500065O00202O00060006003D4O000700063O00202O00070007001B4O000900076O0007000900024O000700076O00050007000200062O000500E007013O00045B3O00E007012O008A000500013O0012E70006007A012O0012E70007007B013O0082000500074O007A00055O0012E7000400023O0012E70005007C012O0012E70006007D012O00066C000600800701000500045B3O008007010012E7000500023O00069C000400800701000500045B3O008007010012E7000300023O00045B3O0082060100045B3O0080070100045B3O0082060100045B3O0009000100045B3O00F7070100045B3O0004000100045B3O00F707010012E7000300013O00069C3O00020001000300045B3O000200010012E7000100014O003F000200023O0012E73O00023O00045B3O000200012O002D012O00017O00C33O00028O00026O00F03F025O004C9040025O00D0A140026O000840025O00D88440025O00C05140030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O0082B140025O00D2A540025O00888140025O00A7B140025O00288540025O00689640025O0016A640024O0080B3C540030C3O00466967687452656D61696E73025O00F8A34003103O00426F2O73466967687452656D61696E7303093O0049734D6F756E746564030B3O004973496E56656869636C65025O0044A840025O0044B340025O00049340025O00707F4003093O00BF35EE2D4BE4BD35EC03063O0081ED5098443D030A3O0049734361737461626C65025O00907B40025O0007B340025O004EAD40025O00D8864003093O00526576697665506574030A3O0063AD12FA0A121861AD1003073O003831C864937C7703093O00FF2BB2FDC3308FF5D803043O0090AC5EDF030D3O004973446561644F7247686F7374025O00A6A340025O00309C40030A3O00171AAF4A2B01E277211B03043O0027446FC2025O0080A740025O00109E4003073O00FBA3E9C349B2C203063O00D7B6C687A71903103O004865616C746850657263656E7461676503073O004D656E6450657403083O00A04CE44CCD79EF5C03043O0028ED298A025O00707240025O00DCB240025O00F49A40030D3O009CF93CA1C7B8DF30B2DBB8E52B03053O00A9DD8B5FC0030D3O00417263616E65546F2O72656E7403093O004973496E52616E6765026O002040025O0069B040025O00CCA04003173O00DF997C3E2C23E19F702D3023D09F3F32232FD0CB27677A03063O0046BEEB1F5F4203093O00502O6F6C466F637573030D3O008AED15EAECB4E55AC0EAB9F70903053O0085DA827A86027O0040025O0008A840025O003AB240025O00AC9F40025O00ACA740025O005AA940025O00DCAB40025O0086A440025O00D07740025O00B07140025O00C0B140025O00508340025O00D8AD40025O00BFB040026O005F40025O0012A440025O009CAE40025O00A4A840025O00B89F40025O0062AD40025O00508540025O002OA040025O00208A40025O0072A240025O009C9040025O00F89B40025O002AA940025O006BB140025O0016AE40030C3O00E26CF2F146C666FBEC43C87A03053O002AA7149A9803073O0049735265616479025O0032A740025O00109D40030C3O00457868696C61726174696F6E030C3O004FE6AA4B7D2058FFB64B7E2F03063O00412A9EC22211025O0096A040025O00804340030B3O003222530039E508FA15295703083O008E7A47326C4D8D7B030B3O004865616C746873746F6E65025O00A8A040025O00206940030B3O001DA7FE142F1DB1EB17351003053O005B75C29F78025O00F2B040025O007DB140030E3O004973496E4D656C2O6552616E6765025O00109B40025O00B2AB40025O00949140026O00504003103O0084E358C1A6E447C2B1F84DE1A4F744C103043O00A4C5902803103O004173706563746F667468654561676C6503173O0082E3BA8EDEA2BCFFACB4C9BE86CFAF8ADABA86B0A584CF03063O00D6E390CAEBBD03073O00C5A4956B1FBC5D03083O005C8DC5E71B70D33303073O00486172702O6F6E030E3O0049735370652O6C496E52616E6765030B3O00EEFE98B3DEE9F1CAACDEF403053O00B1869FEAC3025O001EA940025O004AAF40025O00DEA240025O00C8844003093O00497343617374696E67030C3O0049734368612O6E656C696E67025O00049140025O003AA140025O00C4A040025O00A08340025O00AEAA40025O0061B14003113O00496E74652O72757074576974685374756E030C3O00496E74696D69646174696F6E026O00444003093O00496E74652O7275707403063O004D752O7A6C65026O001440030F3O004D752O7A6C654D6F7573656F766572025O00949B40025O00D6B040025O00508C40026O006940026O00A840025O00AAA04003153O00496E74696D69646174696F6E4D6F7573656F766572025O00408C40025O00E09540025O00708640025O002EAE4003113O002E0F3F1624E42D161424113BF6172O122A03073O00447A7D5E78559103113O00556E6974486173456E7261676542752O6603103O00556E69744861734D6167696342752O6603113O005472616E7175696C697A696E6753686F74025O0066A340025O005EA14003063O001315DC4ECDD503073O00DA777CAF3EA8B9025O00F49540025O00E88940025O001AAA4003113O00476574456E656D696573496E52616E6765026O00AE40025O00408F40031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74030C3O004570696353652O74696E677303073O008CB71B3BB4BD0F03043O005C2OD87C2O033O005A3DA903053O009D3B52CC20025O00C8A440025O00D09D4003073O00F8C285764AC9DE03053O0026ACADE2112O033O00421E2F03043O008F2D714C03073O000C31E4FDE5EFC003083O00D1585E839A898AB32O033O002BA5D703083O004248C1A41C7E435103063O0042752O66557003053O00CB39A65F2303063O0016874CC83846030B3O004973417661696C61626C6500D1032O0012E73O00014O003F000100033O00260D3O00070001000100045B3O000700010012E7000100014O003F000200023O0012E73O00023O00264A3O000B0001000200045B3O000B0001002ED6000400020001000300045B3O000200012O003F000300033O00264A000100100001000500045B3O00100001002ED20006003C0301000700045B3O003C03012O008A00045O0020F00004000400082O008400040001000200060C0104001A0001000100045B3O001A00012O008A000400013O0020EA0004000400092O00100004000200020006700004005500013O00045B3O005500010012E7000400014O003F000500063O00264A000400200001000100045B3O00200001002ED2000A00230001000B00045B3O002300010012E7000500014O003F000600063O0012E7000400023O000EB00002001C0001000400045B3O001C0001002ED2000C00250001000D00045B3O0025000100260D000500250001000100045B3O002500010012E7000600013O00264A0006002E0001000200045B3O002E0001002E0C000E000F0001000F00045B3O003B0001002E0C001000060001001000045B3O003400012O008A000700023O00264A000700340001001100045B3O0034000100045B3O005500012O008A000700033O0020540007000700124O000800046O00098O0007000900024O000700023O00044O0055000100260D0006002A0001000100045B3O002A00010012E7000700013O002E0C001300060001001300045B3O0044000100260D000700440001000200045B3O004400010012E7000600023O00045B3O002A000100260D0007003E0001000100045B3O003E00012O008A000800033O00209A0008000800144O000900096O000A00016O0008000A00024O000800056O000800056O000800023O00122O000700023O00044O003E000100045B3O002A000100045B3O0055000100045B3O0025000100045B3O0055000100045B3O001C00012O008A000400013O0020EA0004000400152O001000040002000200060C010400DD0001000100045B3O00DD00012O008A000400013O0020EA0004000400162O001000040002000200060C010400DD0001000100045B3O00DD00012O008A000400063O000670000400DD00013O00045B3O00DD00010012E7000400014O003F000500053O00260D000400640001000100045B3O006400010012E7000500013O00260D000500B70001000100045B3O00B700010012E7000600014O003F000700073O00260D0006006B0001000100045B3O006B00010012E7000700013O00264A000700720001000200045B3O00720001002ED6001800740001001700045B3O007400010012E7000500023O00045B3O00B7000100264A000700780001000100045B3O00780001002ED60019006E0001001A00045B3O006E00012O008A000800074O0034000900083O00122O000A001B3O00122O000B001C6O0009000B00024O00080008000900202O00080008001D4O00080002000200062O000800840001000100045B3O00840001002ED6001F00930001001E00045B3O00930001002ED2002100930001002000045B3O009300012O008A000800094O00CA000900073O00202O0009000900224O000A000A6O000B00016O0008000B000200062O0008009300013O00045B3O009300012O008A000800083O0012E7000900233O0012E7000A00244O00820008000A4O007A00086O008A000800074O0014010900083O00122O000A00253O00122O000B00266O0009000B00024O00080008000900202O00080008001D4O00080002000200062O000800B300013O00045B3O00B300012O008A0008000A3O000670000800B300013O00045B3O00B300012O008A0008000B3O0020EA0008000800272O0010000800020002000670000800B300013O00045B3O00B300012O008A000800094O00130109000C6O000A000D6O00090009000A4O00080002000200062O000800AE0001000100045B3O00AE0001002ED2002800B30001002900045B3O00B300012O008A000800083O0012E70009002A3O0012E7000A002B4O00820008000A4O007A00085O0012E7000700023O00045B3O006E000100045B3O00B7000100045B3O006B000100260D000500670001000200045B3O00670001002ED2002D00DD0001002C00045B3O00DD00012O008A000600074O0014010700083O00122O0008002E3O00122O0009002F6O0007000900024O00060006000700202O00060006001D4O00060002000200062O000600DD00013O00045B3O00DD00012O008A0006000E3O000670000600DD00013O00045B3O00DD00012O008A0006000B3O0020EA0006000600302O00100006000200022O008A0007000F3O00066C000600DD0001000700045B3O00DD00012O008A000600094O008A000700073O0020F00007000700312O0010000600020002000670000600DD00013O00045B3O00DD00012O008A000600083O0012D9000700323O00122O000800336O000600086O00065O00044O00DD000100045B3O0067000100045B3O00DD000100045B3O00640001002E0C003400F30201003400045B3O00D003012O008A00045O0020F00004000400082O0084000400010002000670000400D003013O00045B3O00D003010012E7000400013O002ED6003600142O01003500045B3O00142O0100260D000400142O01000500045B3O00142O012O008A000500074O0014010600083O00122O000700373O00122O000800386O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500082O013O00045B3O00082O012O008A000500103O000670000500082O013O00045B3O00082O012O008A000500094O00FA000600073O00202O0006000600394O000700113O00202O00070007003A00122O0009003B6O0007000900024O000700076O00050007000200062O000500032O01000100045B3O00032O01002ED2003C00082O01003D00045B3O00082O012O008A000500083O0012E70006003E3O0012E70007003F4O0082000500074O007A00056O008A000500094O008A000600073O0020F00006000600402O0010000500020002000670000500D003013O00045B3O00D003012O008A000500083O0012D9000600413O00122O000700426O000500076O00055O00044O00D0030100260D000400812O01004300045B3O00812O010012E7000500013O00264A0005001B2O01000200045B3O001B2O01002ED6004500382O01004400045B3O00382O012O008A000600123O0026AC0006001F2O01004300045B3O001F2O0100045B3O00362O010012E7000600014O003F000700083O00260D000600262O01000100045B3O00262O010012E7000700014O003F000800083O0012E7000600023O000EB0000200212O01000600045B3O00212O0100260D000700282O01000100045B3O00282O012O008A000900134O00840009000100022O00A4000800093O00060C010800312O01000100045B3O00312O01002ED6004700362O01004600045B3O00362O012O0073000800023O00045B3O00362O0100045B3O00282O0100045B3O00362O0100045B3O00212O010012E7000400053O00045B3O00812O01000EB0000100172O01000500045B3O00172O010012E7000600013O00260D0006007B2O01000100045B3O007B2O01002ED6004800592O01004900045B3O00592O012O008A000700103O000670000700592O013O00045B3O00592O010012E7000700014O003F000800093O00260D000700492O01000100045B3O00492O010012E7000800014O003F000900093O0012E7000700023O000EB0000200442O01000700045B3O00442O0100260D0008004B2O01000100045B3O004B2O012O008A000A00144O0084000A000100022O00A40009000A3O00060C010900542O01000100045B3O00542O01002ED6004A00592O01004B00045B3O00592O012O0073000900023O00045B3O00592O0100045B3O004B2O0100045B3O00592O0100045B3O00442O012O008A000700123O0026E60007005F2O01000500045B3O005F2O012O008A000700153O00060C0107007A2O01000100045B3O007A2O010012E7000700014O003F000800093O002ED2004C00722O01004D00045B3O00722O0100260D000700722O01000200045B3O00722O01002ED2004E00652O01004F00045B3O00652O0100260D000800652O01000100045B3O00652O012O008A000A00164O0084000A000100022O00A40009000A3O0006700009007A2O013O00045B3O007A2O012O0073000900023O00045B3O007A2O0100045B3O00652O0100045B3O007A2O01002ED6005100612O01005000045B3O00612O0100260D000700612O01000100045B3O00612O010012E7000800014O003F000900093O0012E7000700023O00045B3O00612O010012E7000600023O000EB00002003B2O01000600045B3O003B2O010012E7000500023O00045B3O00172O0100045B3O003B2O0100045B3O00172O01002ED6005200070201005300045B3O0007020100260D000400070201000100045B3O000702010012E7000500013O000E790001008A2O01000500045B3O008A2O01002ED6005400E12O01005500045B3O00E12O012O008A000600013O0020EA0006000600092O001000060002000200060C010600922O01000100045B3O00922O012O008A000600173O000670000600942O013O00045B3O00942O01002ED6005600C32O01005700045B3O00C32O010012E7000600014O003F000700093O002ED20059009D2O01005800045B3O009D2O0100260D0006009D2O01000100045B3O009D2O010012E7000700014O003F000800083O0012E7000600023O00264A000600A12O01000200045B3O00A12O01002ED6005A00962O01005B00045B3O00962O012O003F000900093O00260D000700B12O01000100045B3O00B12O010012E7000A00013O00260D000A00AA2O01000100045B3O00AA2O010012E7000800014O003F000900093O0012E7000A00023O00264A000A00AE2O01000200045B3O00AE2O01002ED6005D00A52O01005C00045B3O00A52O010012E7000700023O00045B3O00B12O0100045B3O00A52O01002ED6005F00A22O01005E00045B3O00A22O0100260D000700A22O01000200045B3O00A22O0100260D000800B52O01000100045B3O00B52O012O008A000A00184O0084000A000100022O00A40009000A3O000670000900C32O013O00045B3O00C32O012O0073000900023O00045B3O00C32O0100045B3O00B52O0100045B3O00C32O0100045B3O00A22O0100045B3O00C32O0100045B3O00962O012O008A000600074O0014010700083O00122O000800603O00122O000900616O0007000900024O00060006000700202O0006000600624O00060002000200062O000600D32O013O00045B3O00D32O012O008A000600013O0020EA0006000600302O00100006000200022O008A000700193O00064E000600030001000700045B3O00D52O01002ED6006300E02O01006400045B3O00E02O012O008A000600094O008A000700073O0020F00007000700652O0010000600020002000670000600E02O013O00045B3O00E02O012O008A000600083O0012E7000700663O0012E7000800674O0082000600084O007A00065O0012E7000500023O00264A000500E52O01000200045B3O00E52O01002E0C006800A3FF2O006900045B3O00862O012O008A000600013O0020EA0006000600302O00100006000200022O008A0007001A3O000676000600040201000700045B3O000402012O008A0006001B4O0014010700083O00122O0008006A3O00122O0009006B6O0007000900024O00060006000700202O0006000600624O00060002000200062O0006000402013O00045B3O000402012O008A000600094O00DF0007001C3O00202O00070007006C4O000800096O000A00016O0006000A000200062O000600FF2O01000100045B3O00FF2O01002ED6006D00040201006E00045B3O000402012O008A000600083O0012E70007006F3O0012E7000800704O0082000600084O007A00065O0012E7000400023O00045B3O0007020100045B3O00862O0100260D000400E50001000200045B3O00E500010012E7000500013O00264A0005000E0201000200045B3O000E0201002ED60072005D0201007100045B3O005D020100060C010200160201000100045B3O001602012O008A000600113O0020EA0006000600730012E70008003B4O00930006000800020006700006001802013O00045B3O00180201002ED60075005B0201007400045B3O005B02010012E7000600014O003F000700073O00260D0006001A0201000100045B3O001A02010012E7000700013O000EB00001001D0201000700045B3O001D0201002ED6007700390201007600045B3O003902012O008A000800074O0014010900083O00122O000A00783O00122O000B00796O0009000B00024O00080008000900202O00080008001D4O00080002000200062O0008003902013O00045B3O003902012O008A0008001D3O0006700008003902013O00045B3O003902012O008A000800094O008A000900073O0020F000090009007A2O00100008000200020006700008003902013O00045B3O003902012O008A000800083O0012E70009007B3O0012E7000A007C4O00820008000A4O007A00086O008A000800074O0014010900083O00122O000A007D3O00122O000B007E6O0009000B00024O00080008000900202O00080008001D4O00080002000200062O0008005B02013O00045B3O005B02012O008A0008001E3O0006700008005B02013O00045B3O005B02012O008A000800094O0060000900073O00202O00090009007F4O000A00113O00202O000A000A00804O000C00073O00202O000C000C007F4O000A000C00024O000A000A6O0008000A000200062O0008005B02013O00045B3O005B02012O008A000800083O0012D9000900813O00122O000A00826O0008000A6O00085O00044O005B020100045B3O001D020100045B3O005B020100045B3O001A02010012E7000400433O00045B3O00E5000100264A000500610201000100045B3O00610201002ED20084000A0201008300045B3O000A0201002ED2008600020301008500045B3O000203012O008A000600013O0020EA0006000600872O001000060002000200060C010600020301000100045B3O000203012O008A000600013O0020EA0006000600882O001000060002000200060C010600020301000100045B3O000203010012E7000600014O003F000700093O00260D000600FC0201000200045B3O00FC02012O003F000900093O00264A000700760201000200045B3O00760201002ED2008A00F30201008900045B3O00F3020100260D0008009D0201000200045B3O009D02010012E7000A00014O003F000B000B3O000EB00001007A0201000A00045B3O007A02010012E7000B00013O00264A000B00810201000100045B3O00810201002ED6008B00960201008C00045B3O009602010012E7000C00013O00264A000C00860201000100045B3O00860201002ED6008E00910201008D00045B3O009102012O008A000D5O002023000D000D008F4O000E00073O00202O000E000E009000122O000F00916O000D000F00024O0009000D3O00062O0009009002013O00045B3O009002012O0073000900023O0012E7000C00023O00260D000C00820201000200045B3O008202010012E7000B00023O00045B3O0096020100045B3O0082020100260D000B007D0201000200045B3O007D02010012E7000800433O00045B3O009D020100045B3O007D020100045B3O009D020100045B3O007A020100260D000800BE0201004300045B3O00BE02010012E7000A00014O003F000B000B3O000EB0000100A10201000A00045B3O00A102010012E7000B00013O00260D000B00B70201000100045B3O00B702012O008A000C5O002035010C000C00924O000D00073O00202O000D000D009300122O000E00946O000F00016O0010001F6O0011001C3O00202O0011001100954O000C001100024O0009000C3O00062O000900B50201000100045B3O00B50201002ED2009700B60201009600045B3O00B602012O0073000900023O0012E7000B00023O00260D000B00A40201000200045B3O00A402010012E7000800053O00045B3O00BE020100045B3O00A4020100045B3O00BE020100045B3O00A1020100260D000800DC0201000100045B3O00DC02010012E7000A00014O003F000B000B3O00260D000A00C20201000100045B3O00C202010012E7000B00013O002ED2009900CB0201009800045B3O00CB020100260D000B00CB0201000200045B3O00CB02010012E7000800023O00045B3O00DC0201000EB0000100C50201000B00045B3O00C502012O008A000C5O00201D000C000C00924O000D00073O00202O000D000D009300122O000E00946O000F00016O000C000F00024O0009000C3O00062O000900D802013O00045B3O00D802012O0073000900023O0012E7000B00023O00045B3O00C5020100045B3O00DC020100045B3O00C2020100264A000800E00201000500045B3O00E00201002ED6009A00760201009B00045B3O007602012O008A000A5O00208C000A000A008F4O000B00073O00202O000B000B009000122O000C00916O000D000D6O000E001F6O000F001C3O00202O000F000F009C4O000A000F00024O0009000A3O002ED6009D00020301009E00045B3O000203010006700009000203013O00045B3O000203012O0073000900023O00045B3O0002030100045B3O0076020100045B3O0002030100264A000700F70201000100045B3O00F70201002ED200A000720201009F00045B3O007202010012E7000800014O003F000900093O0012E7000700023O00045B3O0072020100045B3O0002030100260D0006006F0201000100045B3O006F02010012E7000700014O003F000800083O0012E7000600023O00045B3O006F02012O008A000600203O0006700006003803013O00045B3O003803012O008A000600074O0014010700083O00122O000800A13O00122O000900A26O0007000900024O00060006000700202O0006000600624O00060002000200062O0006003803013O00045B3O003803012O008A000600013O0020EA0006000600872O001000060002000200060C010600380301000100045B3O003803012O008A000600013O0020EA0006000600882O001000060002000200060C010600380301000100045B3O003803012O008A00065O0020F00006000600A32O008A000700114O001000060002000200060C010600250301000100045B3O002503012O008A00065O0020F00006000600A42O008A000700114O00100006000200020006700006003803013O00045B3O003803012O008A000600094O001C010700073O00202O0007000700A54O000800113O00202O0008000800804O000A00073O00202O000A000A00A54O0008000A00024O000800086O00060008000200062O000600330301000100045B3O00330301002E0C00A60007000100A700045B3O003803012O008A000600083O0012E7000700A83O0012E7000800A94O0082000600084O007A00065O0012E7000500023O00045B3O000A020100045B3O00E5000100045B3O00D0030100260D000100830301004300045B3O008303010012E7000400013O002ED600AB0054030100AA00045B3O0054030100260D000400540301000200045B3O00540301002ED200AC004D030100A000045B3O004D03010006700002004D03013O00045B3O004D03012O008A000500013O00203F0105000500AD00122O000700916O0005000700024O000500043O00044O005203012O008A000500013O0020EA0005000500AD0012E70007003B4O00930005000700023O00010500043O0012E7000100053O00045B3O00830301002ED200AF003F030100AE00045B3O003F030100260D0004003F0301000100045B3O003F03010006700002005D03013O00045B3O005D03010010FF00050091000300060C010500660301000100045B3O006603012O008A000500223O00122B000600946O000700036O0005000700024O000600233O00122O000700946O000800036O0006000800024O0005000500063O00010500214O008A000500153O0006700005007F03013O00045B3O007F03010006700002007803013O00045B3O007803012O008A000500113O0020EA0005000500730012E70007003B4O009300050007000200060C010500780301000100045B3O007803012O008A000500113O00203F0105000500B000122O0007003B6O0005000700024O000500123O00044O008103012O008A000500013O0020040005000500AD00122O0007003B6O0005000700024O000500056O000500123O00044O008103010012E7000500025O00010500123O0012E7000400023O00045B3O003F030100260D000100AA0301000100045B3O00AA03010012E7000400013O00260D000400960301000200045B3O0096030100129F000500B14O006B000600083O00122O000700B23O00122O000800B36O0006000800024O0005000500064O000600083O00122O000700B43O00122O000800B56O0006000800024O0005000500064O000500153O00122O000100023O00044O00AA030100264A0004009A0301000100045B3O009A0301002ED200B60086030100B700045B3O008603012O008A000500244O000901050001000100123C010500B16O000600083O00122O000700B83O00122O000800B96O0006000800024O0005000500064O000600083O00122O000700BA3O00122O000800BB6O0006000800024O0005000500064O000500173O00122O000400023O00045B3O0086030100260D0001000C0001000200045B3O000C000100129F000400B14O00F4000500083O00122O000600BC3O00122O000700BD6O0005000700024O0004000400054O000500083O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000400106O000400013O00202O0004000400C04O000600073O00202O00060006007A4O0004000600024O000200046O000400076O000500083O00122O000600C13O00122O000700C26O0005000700024O00040004000500202O0004000400C34O00040002000200062O000400CB03013O00045B3O00CB03010012E7000400053O000623010300CC0301000400045B3O00CC03010012E7000300013O0012E7000100433O00045B3O000C000100045B3O00D0030100045B3O000200012O002D012O00017O00033O0003053O005072696E7403353O000FEAF1D2D5B53930BFCBD1D2B73D2EBFF1CBC8A22C35F0ED84DEBA7819EFEAC792E30B29EFF3CBCEB73D38BFE1DD9C843736F6F1C503073O00585C9F83A4BCC300084O000D016O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

