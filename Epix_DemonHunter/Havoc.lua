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
				if (Enum <= 169) then
					if (Enum <= 84) then
						if (Enum <= 41) then
							if (Enum <= 20) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												if Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 2) then
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
										elseif (Enum > 3) then
											Stk[Inst[2]] = #Stk[Inst[3]];
										else
											local A = Inst[2];
											local Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											local Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
										end
									elseif (Enum <= 6) then
										if (Enum > 5) then
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										else
											local B;
											local T;
											local A;
											Stk[Inst[2]] = {};
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
											T = Stk[A];
											B = Inst[3];
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
										end
									elseif (Enum <= 7) then
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
									elseif (Enum == 8) then
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
										if (Enum == 10) then
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
									elseif (Enum <= 12) then
										Stk[Inst[2]] = Inst[3] ~= 0;
									elseif (Enum > 13) then
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
								elseif (Enum <= 17) then
									if (Enum <= 15) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
									elseif (Enum == 16) then
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
									elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum <= 18) then
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 19) then
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
							elseif (Enum <= 30) then
								if (Enum <= 25) then
									if (Enum <= 22) then
										if (Enum == 21) then
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
											Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										end
									elseif (Enum <= 23) then
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
									elseif (Enum == 24) then
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
										Stk[Inst[2]]();
									end
								elseif (Enum <= 27) then
									if (Enum == 26) then
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
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 28) then
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
								elseif (Enum == 29) then
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 35) then
								if (Enum <= 32) then
									if (Enum > 31) then
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
								elseif (Enum <= 33) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 34) then
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
							elseif (Enum <= 38) then
								if (Enum <= 36) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								elseif (Enum == 37) then
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
								end
							elseif (Enum <= 39) then
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
							elseif (Enum > 40) then
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
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 62) then
							if (Enum <= 51) then
								if (Enum <= 46) then
									if (Enum <= 43) then
										if (Enum == 42) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 44) then
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
									elseif (Enum == 45) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 48) then
									if (Enum == 47) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 49) then
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
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 50) then
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
							elseif (Enum <= 56) then
								if (Enum <= 53) then
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
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 54) then
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 55) then
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
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 59) then
								if (Enum <= 57) then
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
								elseif (Enum == 58) then
									do
										return;
									end
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum <= 60) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 61) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum <= 73) then
							if (Enum <= 67) then
								if (Enum <= 64) then
									if (Enum == 63) then
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
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
									end
								elseif (Enum <= 65) then
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
								elseif (Enum > 66) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									A = Inst[2];
									Stk[A] = Stk[A]();
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 70) then
								if (Enum <= 68) then
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
								elseif (Enum == 69) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 71) then
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
						elseif (Enum <= 78) then
							if (Enum <= 75) then
								if (Enum > 74) then
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
							elseif (Enum <= 76) then
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
							elseif (Enum > 77) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 81) then
							if (Enum <= 79) then
								local B;
								local A;
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
							elseif (Enum == 80) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 83) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 126) then
						if (Enum <= 105) then
							if (Enum <= 94) then
								if (Enum <= 89) then
									if (Enum <= 86) then
										if (Enum == 85) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
									elseif (Enum <= 87) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 88) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 91) then
									if (Enum == 90) then
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
								elseif (Enum <= 92) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 93) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 99) then
								if (Enum <= 96) then
									if (Enum > 95) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 97) then
									local A;
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 98) then
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
							elseif (Enum <= 102) then
								if (Enum <= 100) then
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
								elseif (Enum == 101) then
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
							elseif (Enum > 104) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 115) then
							if (Enum <= 110) then
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
										local A = Inst[2];
										do
											return Unpack(Stk, A, Top);
										end
									end
								elseif (Enum <= 108) then
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
								elseif (Enum > 109) then
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
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								end
							elseif (Enum <= 112) then
								if (Enum > 111) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 113) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 114) then
								local B;
								local A;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 120) then
							if (Enum <= 117) then
								if (Enum == 116) then
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
								end
							elseif (Enum <= 118) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 119) then
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
						elseif (Enum <= 123) then
							if (Enum <= 121) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 122) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 125) then
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
					elseif (Enum <= 147) then
						if (Enum <= 136) then
							if (Enum <= 131) then
								if (Enum <= 128) then
									if (Enum > 127) then
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
										Stk[Inst[2]] = {};
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 130) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 133) then
								if (Enum == 132) then
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
								else
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								end
							elseif (Enum <= 134) then
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
							elseif (Enum > 135) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 141) then
							if (Enum <= 138) then
								if (Enum == 137) then
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
							elseif (Enum <= 139) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 140) then
								local A;
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
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 144) then
							if (Enum <= 142) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 143) then
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
						elseif (Enum <= 145) then
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 158) then
						if (Enum <= 152) then
							if (Enum <= 149) then
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
							elseif (Enum <= 150) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 151) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 155) then
							if (Enum <= 153) then
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
							elseif (Enum > 154) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 156) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						elseif (Enum > 157) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 163) then
						if (Enum <= 160) then
							if (Enum == 159) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Inst[2] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 166) then
						if (Enum <= 164) then
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
						elseif (Enum == 165) then
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
					elseif (Enum <= 167) then
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
					elseif (Enum > 168) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 254) then
					if (Enum <= 211) then
						if (Enum <= 190) then
							if (Enum <= 179) then
								if (Enum <= 174) then
									if (Enum <= 171) then
										if (Enum == 170) then
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
											Stk[A](Unpack(Stk, A + 1, Top));
										end
									elseif (Enum <= 172) then
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
									elseif (Enum > 173) then
										local A;
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
								elseif (Enum <= 176) then
									if (Enum > 175) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 177) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 178) then
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
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 184) then
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
								elseif (Enum <= 182) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								elseif (Enum > 183) then
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								elseif (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 187) then
								if (Enum <= 185) then
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
								elseif (Enum == 186) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							elseif (Enum <= 188) then
								Stk[Inst[2]] = not Stk[Inst[3]];
							elseif (Enum == 189) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 200) then
							if (Enum <= 195) then
								if (Enum <= 192) then
									if (Enum == 191) then
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
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									end
								elseif (Enum <= 193) then
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
								elseif (Enum == 194) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 197) then
								if (Enum == 196) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 198) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 199) then
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
						elseif (Enum <= 205) then
							if (Enum <= 202) then
								if (Enum == 201) then
									local B;
									local A;
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
							elseif (Enum <= 203) then
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
							elseif (Enum > 204) then
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
						elseif (Enum <= 208) then
							if (Enum <= 206) then
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
							elseif (Enum == 207) then
								if (Stk[Inst[2]] < Inst[4]) then
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
						elseif (Enum <= 209) then
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						elseif (Enum == 210) then
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
					elseif (Enum <= 232) then
						if (Enum <= 221) then
							if (Enum <= 216) then
								if (Enum <= 213) then
									if (Enum > 212) then
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
								elseif (Enum <= 214) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
								elseif (Enum > 215) then
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
							elseif (Enum <= 218) then
								if (Enum > 217) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
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
							elseif (Enum <= 219) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 220) then
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
						elseif (Enum <= 226) then
							if (Enum <= 223) then
								if (Enum == 222) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 224) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 225) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 229) then
							if (Enum <= 227) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 228) then
								Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum == 231) then
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
					elseif (Enum <= 243) then
						if (Enum <= 237) then
							if (Enum <= 234) then
								if (Enum > 233) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
								end
							elseif (Enum <= 235) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 236) then
								if (Inst[2] < Stk[Inst[4]]) then
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
						elseif (Enum <= 240) then
							if (Enum <= 238) then
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 239) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 241) then
							do
								return Stk[Inst[2]]();
							end
						elseif (Enum == 242) then
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
					elseif (Enum <= 248) then
						if (Enum <= 245) then
							if (Enum == 244) then
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 246) then
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
						elseif (Enum == 247) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 251) then
						if (Enum <= 249) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 250) then
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 252) then
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
					elseif (Enum == 253) then
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
				elseif (Enum <= 297) then
					if (Enum <= 275) then
						if (Enum <= 264) then
							if (Enum <= 259) then
								if (Enum <= 256) then
									if (Enum == 255) then
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
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 257) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum > 258) then
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
								else
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
							elseif (Enum <= 261) then
								if (Enum == 260) then
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
							elseif (Enum <= 262) then
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
							elseif (Enum == 263) then
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
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 269) then
							if (Enum <= 266) then
								if (Enum > 265) then
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
							elseif (Enum <= 267) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							elseif (Enum == 268) then
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
						elseif (Enum <= 272) then
							if (Enum <= 270) then
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
							elseif (Enum == 271) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 273) then
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
						elseif (Enum > 274) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
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
								if (Mvm[1] == 229) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						end
					elseif (Enum <= 286) then
						if (Enum <= 280) then
							if (Enum <= 277) then
								if (Enum == 276) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 278) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 279) then
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
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 283) then
							if (Enum <= 281) then
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							elseif (Enum > 282) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum <= 284) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 285) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						else
							local A = Inst[2];
							Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 291) then
						if (Enum <= 288) then
							if (Enum > 287) then
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
							elseif (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 290) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 294) then
						if (Enum <= 292) then
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
						elseif (Enum == 293) then
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
					elseif (Enum <= 295) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Enum == 296) then
						VIP = Inst[3];
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
					end
				elseif (Enum <= 318) then
					if (Enum <= 307) then
						if (Enum <= 302) then
							if (Enum <= 299) then
								if (Enum == 298) then
									local B;
									local A;
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
							elseif (Enum <= 300) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 301) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
						elseif (Enum <= 304) then
							if (Enum > 303) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum <= 305) then
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
						elseif (Enum == 306) then
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
							Stk[Inst[2]] = {};
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
					elseif (Enum <= 312) then
						if (Enum <= 309) then
							if (Enum == 308) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 310) then
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
						elseif (Enum > 311) then
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
						elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 315) then
						if (Enum <= 313) then
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
						elseif (Enum > 314) then
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 316) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, A + Inst[3]);
						end
					elseif (Enum == 317) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Stk[Inst[4]]];
					end
				elseif (Enum <= 329) then
					if (Enum <= 323) then
						if (Enum <= 320) then
							if (Enum == 319) then
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
						elseif (Enum <= 321) then
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
						elseif (Enum > 322) then
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
					elseif (Enum <= 326) then
						if (Enum <= 324) then
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
						elseif (Enum > 325) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 327) then
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
					elseif (Enum > 328) then
						if (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
						end
					else
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
					end
				elseif (Enum <= 334) then
					if (Enum <= 331) then
						if (Enum > 330) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 332) then
						local B;
						local A;
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
					elseif (Enum > 333) then
						local B;
						local A;
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
					elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 337) then
					if (Enum <= 335) then
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 336) then
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
					end
				elseif (Enum <= 338) then
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
				elseif (Enum == 339) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
					Stk[Inst[2]] = {};
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
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					T = Stk[A];
					B = Inst[3];
					for Idx = 1, B do
						T[Idx] = Stk[A + Idx];
					end
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031A3O00F4D3D23DD99FC213DECDF330E8AFC20CEEEBDA33E9B88912C4C203083O007EB1A3BB4586DBA7031A3O00A86CE433B258E8268272C53E8368E839B254EC3D827FA327987D03043O004BED1C8D002E3O0012893O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001000428012O000A00010012F4000300063O0020450004000300070012F4000500083O0020450005000500090012F4000600083O00204500060006000A00061201073O000100062O00E53O00064O00E58O00E53O00044O00E53O00014O00E53O00024O00E53O00053O00204500080003000B00204500090003000C2O007F000A5O0012F4000B000D3O000612010C0001000100022O00E53O000A4O00E53O000B4O00E5000D00073O0012CD000E000E3O0012CD000F000F4O0024000D000F0002000612010E0002000100032O00E53O00074O00E53O00094O00E53O00084O00C3000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O004A00025O00122O000300016O00045O00122O000500013O00042O0003002100012O007A00076O0050000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004D70003000500012O007A000300054O00E5000400024O0028000300044O006A00036O003A3O00017O00093O00028O00025O0084A440025O00408440026O00F03F025O00EC9840025O003CA040025O008C9940025O00688440025O0034AD40013C3O0012CD000200014O00DA000300043O0026790002001100010001000428012O001100010012CD000500013O000EA30001000900010005000428012O00090001002E120002000C00010003000428012O000C00010012CD000300014O00DA000400043O0012CD000500043O0026790005000500010004000428012O000500010012CD000200043O000428012O00110001000428012O000500010026790002000200010004000428012O000200010012CD000500013O002E120005001400010006000428012O001400010026790005001400010001000428012O00140001000E2F0001002E00010003000428012O002E00010012CD000600013O0026790006002900010001000428012O002900012O007A00076O00FA000400073O002EB70008002800010007000428012O002800010006360004002800010001000428012O002800012O007A000700014O00E500086O003B01096O002O01076O006A00075O0012CD000600043O0026790006001B00010004000428012O001B00010012CD000300043O000428012O002E0001000428012O001B0001002EF5000900E5FF2O0009000428012O001300010026790003001300010004000428012O001300012O00E5000600044O003B01076O002O01066O006A00065O000428012O00130001000428012O00140001000428012O00130001000428012O003B0001000428012O000200012O003A3O00017O005A3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003043O009FC2C41E03063O004BDCA3B76A62030D3O0021BB9823EA17BD8C32CA16BF8F03053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303043O0089FF3D5103063O00C7EB90523D9803043O006D6174682O033O000A1FB703043O004B6776D92O033O00CA556803063O007EA7341074D9026O001440030B3O00EC2B2D8FBA31E9C63A259203073O009CA84E40E0D47903053O002FEFB3C10403043O00AE678EC5030B3O00722D52372B76ED583C5A2A03073O009836483F58453E03053O00FCC5F853D703043O003CB4A48E030B3O007C5B082629C507564A003B03073O0072383E6549478D03053O0090E8CDCBBB03043O00A4D889BB030C3O0047657445717569706D656E74026O002A40028O00026O002C40030B3O00F4E33D97B4EB1BC6EF3EBC03073O006BB28651D2C69E03093O001B0683C9B9160194C703053O00CA586EE2A6030B3O00E2298BE5CFEA0191FECEC603053O00AAA36FE297030B3O004973417661696C61626C65026O00F03F2O033O00474344026O00D03F024O0080B3C540024O0068AE0441024O0088AE0441024O00209F0441024O0090AE0441024O00A8AE0441024O00A0AE0441024O00B0AE044103103O005265676973746572466F724576656E7403143O00211C93016B05162315951D60080C3F1190146B1303073O00497150D2582E5703183O00B100EC2BC2B313E823D2A81CE037C9B513EE3AC6AF0BE83603053O0087E14CAD72030E3O009EED35DC54C592FE38D156D188F903063O0096CDBD70901803143O0009A19E7E2AAD352F16B49A6028B7383E1AB09E6E03083O007045E4DF2C64E87103063O0053657441504C025O0008824000ED013O00292O0100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100176O000F001100024O000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000E00134O00145O00122O001500203O00122O001600216O0014001600024O0014000E00142O001C01155O00122O001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0015001400152O007A00165O00124C001700263O00122O001800276O0016001800024O00160014001600122O001700286O00185O00122O001900293O00122O001A002A6O0018001A00024O0017001700180012F4001800284O001D01195O00122O001A002B3O00122O001B002C6O0019001B00024O00180018001900122O0019002D6O001A001A6O001B8O001C8O001D6O000C001E6O008C001F004E6O004F5O00122O0050002E3O00122O0051002F6O004F005100024O004F000C004F4O00505O00122O005100303O00122O005200316O0050005200022O00FA004F004F00502O001C01505O00122O005100323O00122O005200336O0050005200024O0050000D00504O00515O00122O005200343O00122O005300356O0051005300024O0050005000512O001C01515O00122O005200363O00122O005300376O0051005300024O0051001300514O00525O00122O005300383O00122O005400396O0052005400024O0051005100522O007F00525O0020C000530008003A2O004501530002000200204500540053003B00060A0054009B00013O000428012O009B00012O00E50054000D3O00204500550053003B2O00450154000200020006360054009E00010001000428012O009E00012O00E50054000D3O0012CD0055003C4O004501540002000200204500550053003D00060A005500A600013O000428012O00A600012O00E50055000D3O00204500560053003D2O0045015500020002000636005500A900010001000428012O00A900012O00E50055000D3O0012CD0056003C4O00450155000200022O00DA005600594O0005005A00026O005B00016O005C5O00122O005D003E3O00122O005E003F6O005C005E00024O005C004F005C4O005B000100012O007F005C00014O001B005D5O00122O005E00403O00122O005F00416O005D005F00024O005D004F005D4O005C000100012O0038005A000200012O000C005B6O00CB005C8O005D8O005E8O005F8O00606O002500615O00122O006200423O00122O006300436O0061006300024O0061004F006100202O0061006100444O00610002000200062O006100CC00013O000428012O00CC00010012CD0061002D3O000636006100CD00010001000428012O00CD00010012CD006100453O0020C00062000800462O005401620002000200202O00620062004700122O0063003C6O00645O00122O006500483O00122O006600486O006700073O00122O006800493O00122O0069004A3O00122O006A004B3O00122O006B004C3O00122O006C004D3O00122O006D004E3O00122O006E004F6O0067000700010020C0006800040050000612016A3O000100072O00E53O00664O00E53O005B4O00E53O005C4O00E53O005F4O00E53O00654O00E53O005D4O00E53O005E4O0033006B5O00122O006C00513O00122O006D00526O006B006D6O00683O000100202O006800040050000612016A0001000100052O00E53O00534O00E53O00084O00E53O00544O00E53O000D4O00E53O00554O0033006B5O00122O006C00533O00122O006D00546O006B006D6O00683O000100202O006800040050000612016A0002000100032O00E53O00614O00E53O004F4O007A8O0011016B5O00122O006C00553O00122O006D00566O006B006D00024O006C5O00122O006D00573O00122O006E00586O006C006E6O00683O000100061201680003000100012O00E53O004F3O00061201690004000100042O00E53O004F4O007A8O00E53O00174O00E53O00583O000612016A0005000100042O00E53O001A4O00E53O00144O00E53O00524O00E53O001D3O000612016B00060001000F2O00E53O00504O007A8O00E53O004A4O00E53O00084O00E53O004C4O00E53O00124O00E53O00514O00E53O00494O00E53O004B4O00E53O004D4O00E53O004F4O00E53O003B4O00E53O003D4O00E53O003C4O00E53O003E3O000612016C00070001000E2O00E53O004F4O007A8O00E53O002B4O00E53O00124O00E53O00094O00E53O00194O00E53O002C4O00E53O00084O00E53O00584O00E53O004E4O00E53O00514O00E53O001E4O00E53O00294O00E53O00243O000612016D0008000100082O00E53O00084O00E53O004F4O007A8O00E53O00234O00E53O00124O00E53O00094O00E53O00194O00E53O001F3O000612016E00090001001A2O00E53O00144O00E53O00084O00E53O004F4O00E53O00464O00E53O00664O00E53O001D4O00E53O00374O007A8O00E53O00344O00E53O00124O00E53O00514O00E53O00094O00E53O00194O00E53O005B4O007A3O00014O00E53O00154O007A3O00024O00E53O00334O00E53O00364O00E53O00584O00E53O003A4O00E53O00394O00E53O00474O00E53O00484O00E53O001A4O00E53O006A3O000612016F000A000100292O00E53O004F4O007A8O00E53O00284O00E53O00084O00E53O00124O00E53O00094O00E53O001E4O00E53O00294O00E53O00214O00E53O005C4O00E53O005D4O00E53O002C4O00E53O004E4O00E53O00514O00E53O00194O00E53O00244O00E53O00354O00E53O00464O00E53O00664O00E53O001D4O00E53O00384O00E53O00044O00E53O00584O00E53O00254O00E53O00624O00E53O00234O00E53O005B4O00E53O002D4O00E53O00154O00E53O002B4O00E53O001F4O00E53O00204O00E53O00264O00E53O002E4O00E53O00274O00E53O002A4O00E53O00604O007A3O00014O007A3O00024O00E53O00594O00E53O00613O0006120170000B000100192O00E53O00224O007A8O00E53O00234O00E53O00244O00E53O002E4O00E53O00334O00E53O00344O00E53O002A4O00E53O00284O00E53O00294O00E53O00274O00E53O00254O00E53O00264O00E53O002D4O00E53O002B4O00E53O002C4O00E53O00374O00E53O00354O00E53O00364O00E53O001F4O00E53O00204O00E53O00214O00E53O00384O00E53O00394O00E53O003A3O0006120171000C0001000A2O00E53O004E4O007A8O00E53O003B4O00E53O003C4O00E53O00314O00E53O00324O00E53O003D4O00E53O003E4O00E53O002F4O00E53O00303O0006120172000D0001000E2O00E53O00464O007A8O00E53O003F4O00E53O00434O00E53O00424O00E53O00494O00E53O00484O00E53O004A4O00E53O00474O00E53O00444O00E53O00454O00E53O004C4O00E53O004B4O00E53O004D3O0006120173000E000100302O00E53O001A4O00E53O00424O00E53O00144O00E53O004F4O00E53O00514O00E53O00084O007A8O00E53O001E4O00E53O00294O007A3O00014O007A3O00024O00E53O00124O00E53O00094O00E53O002B4O00E53O00624O00E53O00194O00E53O006E4O00E53O00584O00E53O006D4O00E53O006F4O00E53O005F4O00E53O00184O00E53O00604O00E53O00664O00E53O00154O00E53O002D4O00E53O00074O00E53O00674O00E53O000A4O00E53O005B4O00E53O005C4O00E53O005D4O00E53O006C4O00E53O00224O00E53O003F4O00E53O00044O00E53O00104O00E53O001C4O00E53O00564O00E53O00594O00E53O00574O00E53O00654O00E53O006B4O00E53O00714O00E53O00704O00E53O00724O00E53O001B4O00E53O001D3O0006120174000F000100032O00E53O004F4O007A8O00E53O000E3O0020410075000E005900122O0076005A6O007700736O007800746O0075007800016O00013O00103O00103O00028O00026O000840024O0080B3C540026O00F03F027O0040025O00F6AE40025O0086B240025O00D0AF40025O0057B240025O0058A140025O0092A640025O0032B340025O002FB140025O0098AC40025O00C6A640025O00806840004F3O0012CD3O00014O00DA000100013O0026793O000200010001000428012O000200010012CD000100013O0026790001000A00010002000428012O000A00010012CD000200034O003C00025O000428012O004E00010026790001002100010001000428012O002100010012CD000200013O0026790002001C00010001000428012O001C00010012CD000300013O0026790003001400010004000428012O001400010012CD000200043O000428012O001C00010026790003001000010001000428012O001000012O000C00046O00F3000400016O00048O000400023O00122O000300043O00044O001000010026790002000D00010004000428012O000D00010012CD000100043O000428012O00210001000428012O000D0001000EA30005002500010001000428012O00250001002EB70007003600010006000428012O003600010012CD000200013O0026E10002002A00010004000428012O002A0001002EB70009002C00010008000428012O002C00010012CD000100023O000428012O003600010026E10002003000010001000428012O00300001002EB7000B00260001000A000428012O002600012O000C00036O0002010300033O00122O000300036O000300043O00122O000200043O00044O002600010026E10001003A00010004000428012O003A0001002EB7000C00050001000D000428012O000500010012CD000200013O002EF5000E00060001000E000428012O004100010026790002004100010004000428012O004100010012CD000100053O000428012O00050001002E120010003B0001000F000428012O003B0001000E2F0001003B00010002000428012O003B00012O000C00036O00F3000300056O00038O000300063O00122O000200043O00044O003B0001000428012O00050001000428012O004E0001000428012O000200012O003A3O00017O00093O00028O00026O00F03F025O001EB240025O007CAE40025O00309140025O00309440030C3O0047657445717569706D656E74026O002A40026O002C40003B3O0012CD3O00014O00DA000100013O0026793O000200010001000428012O000200010012CD000100013O0026790001002600010001000428012O002600010012CD000200013O0026E10002000C00010002000428012O000C0001002EB70003000E00010004000428012O000E00010012CD000100023O000428012O002600010026E10002001200010001000428012O00120001002E120006000800010005000428012O000800012O007A000300013O0020BD0003000300074O0003000200024O00038O00035O00202O00030003000800062O0003002000013O000428012O002000012O007A000300034O007A00045O0020450004000400082O00450103000200020006360003002300010001000428012O002300012O007A000300033O0012CD000400014O00450103000200022O003C000300023O0012CD000200023O000428012O000800010026790001000500010002000428012O000500012O007A00025O00204500020002000900060A0002003200013O000428012O003200012O007A000200034O007A00035O0020450003000300092O00450102000200020006360002003500010001000428012O003500012O007A000200033O0012CD000300014O00450102000200022O003C000200043O000428012O003A0001000428012O00050001000428012O003A0001000428012O000200012O003A3O00017O00053O00030B3O003BCBB1A2A994A909E4BCB503073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65026O001440026O00F03F00104O00C53O00016O000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000D00013O000428012O000D00010012CD3O00043O0006363O000E00010001000428012O000E00010012CD3O00054O003C8O003A3O00017O00033O00030D3O00446562752O6652656D61696E7303123O004275726E696E67576F756E64446562752O6603153O004275726E696E67576F756E644C6567446562752O66010C3O0020152O013O00014O00035O00202O0003000300024O00010003000200062O0001000A00010001000428012O000A00010020C000013O00012O007A00035O0020450003000300032O00240001000300024O000100024O003A3O00017O000A3O00030C3O00F60A15DDBF7281E31012DDB203073O00E6B47F67B3D61C030B3O004973417661696C61626C65030D3O00446562752O6652656D61696E7303123O004275726E696E67576F756E64446562752O66026O00104003123O00AE104D48ED4FE7BB0A4A48E065E58E10594003073O0080EC653F268421030F3O0041757261416374697665436F756E74026O00084001224O00C500018O000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O00010002000200062O0001002000013O000428012O002000010020C000013O00042O007A00035O0020450003000300052O00240001000300020026150001001E00010006000428012O001E00012O007A00016O0054000200013O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O0001000200024O000200026O000300033O00122O0004000A4O00240002000400020006110001001F00010002000428012O001F00012O003B00016O000C000100016O000100024O003A3O00017O00123O00028O00025O00188140025O006EAB40025O00A07340025O00A8A040025O00208D4003103O0048616E646C65546F705472696E6B6574026O004440025O00F6A640025O000EB140026O00F03F025O0002AF40025O0092AC40025O008C9540025O00D8964003133O0048616E646C65426F2O746F6D5472696E6B6574025O00FEB140025O002OAE4000453O0012CD3O00014O00DA000100013O0026E13O000600010001000428012O00060001002EB70003000200010002000428012O000200010012CD000100013O0026E10001000B00010001000428012O000B0001002EB70005002D00010004000428012O002D00010012CD000200014O00DA000300033O000E2F0001000D00010002000428012O000D00010012CD000300013O002EF50006001400010006000428012O00240001000E2F0001002400010003000428012O002400012O007A000400013O0020FB0004000400074O000500026O000600033O00122O000700086O000800086O0004000800024O00048O00045O00062O0004002100010001000428012O00210001002EF5000900040001000A000428012O002300012O007A00048O000400023O0012CD0003000B3O0026E1000300280001000B000428012O00280001002E12000C00100001000D000428012O001000010012CD0001000B3O000428012O002D0001000428012O00100001000428012O002D0001000428012O000D00010026E1000100310001000B000428012O00310001002EF5000E00D8FF2O000F000428012O000700012O007A000200013O0020FB0002000200104O000300026O000400033O00122O000500086O000600066O0002000600024O00028O00025O00062O0002003E00010001000428012O003E0001002E120011004400010012000428012O004400012O007A00028O000200023O000428012O00440001000428012O00070001000428012O00440001000428012O000200012O003A3O00017O00333O00028O00026O00F03F025O00A89840025O00A08F40030B3O0096F7C0CE2EC6A16AB1FCC403083O001EDE92A1A25AAED203073O004973526561647903103O004865616C746850657263656E74616765025O00BEA240025O0074AA40030B3O004865616C746873746F6E6503153O00ED4B7106F146631EEA40754AE14B760FEB5D791CE003043O006A852E10025O0028AB40025O005DB240025O0016B140025O0022AD40025O004AB340025O00B4944003193O006A2575EE5F5350297DFB1A685D217FF5544718107CE8534F5603063O00203840139C3A025O00E4A640025O002EB04003173O0068CDE3445FE18853C6E27E5FF38C53C6E26655E68955C603073O00E03AA885363A9203173O0052656672657368696E674865616C696E67506F74696F6E03233O004B534DEF70958F0257510BF570878B0257510BED7A928E0457164FF87383891850404E03083O006B39362B9D15E6E7025O00388240025O00A06040031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E026O007B4003193O00FF9914F4B4CBCED78014E7AAF4CADA8718FBBEECC0CF821EFB03073O00AFBBEB7195D9BC03253O0038BD844DEE6E7930A4845EF0397039AE8D45ED7E382CA09545EC772O38AA8749ED6A712AAA03073O00185CCFE12C831903043O008EA5045603073O00AFCCC97124D68B030A3O0049734361737461626C6503043O00426C7572030E3O0045C020CE4443C933D90A54C523D903053O006427AC55BC025O00C09640025O0080B040030A3O00837DAD8836BF6FB88C3803053O0053CD18D9E0030A3O004E657468657277616C6B025O00889A40025O00A0A24003143O00E8C0D935E3D7DA3CEACE8D39E3C3C833F5CCDB3803043O005D86A5AD00C93O0012CD3O00013O0026E13O000500010002000428012O00050001002E120003008400010004000428012O008400012O007A00016O0025000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001001800013O000428012O001800012O007A000100023O00060A0001001800013O000428012O001800012O007A000100033O0020C00001000100082O00452O01000200022O007A000200043O0006492O01000300010002000428012O001A0001002EB7000A002500010009000428012O002500012O007A000100054O007A000200063O00204500020002000B2O00452O010002000200060A0001002500013O000428012O002500012O007A000100013O0012CD0002000C3O0012CD0003000D4O0028000100034O006A00016O007A000100073O00060A000100C800013O000428012O00C800012O007A000100033O0020C00001000100082O00452O01000200022O007A000200083O00064D2O0100C800010002000428012O00C800010012CD000100014O00DA000200033O0026790001003500010001000428012O003500010012CD000200014O00DA000300033O0012CD000100023O0026E10001003900010002000428012O00390001002EB7000F00300001000E000428012O003000010026E10002003D00010001000428012O003D0001002E120010003900010011000428012O003900010012CD000300013O0026E10003004200010001000428012O00420001002E120012003E00010013000428012O003E00012O007A000400094O00DF000500013O00122O000600143O00122O000700156O00050007000200062O0004006100010005000428012O00610001002EB70017004C00010016000428012O004C0001000428012O006100012O007A00046O0025000500013O00122O000600183O00122O000700196O0005000700024O00040004000500202O0004000400074O00040002000200062O0004006100013O000428012O006100012O007A000400054O007A000500063O00204500050005001A2O004501040002000200060A0004006100013O000428012O006100012O007A000400013O0012CD0005001B3O0012CD0006001C4O0028000400064O006A00045O002E12001E00C80001001D000428012O00C800012O007A000400093O002679000400C80001001F000428012O00C80001002EF50020006200010020000428012O00C800012O007A00046O0025000500013O00122O000600213O00122O000700226O0005000700024O00040004000500202O0004000400074O00040002000200062O000400C800013O000428012O00C800012O007A000400054O007A000500063O00204500050005001A2O004501040002000200060A000400C800013O000428012O00C800012O007A000400013O0012D9000500233O00122O000600246O000400066O00045O00044O00C80001000428012O003E0001000428012O00C80001000428012O00390001000428012O00C80001000428012O00300001000428012O00C800010026793O000100010001000428012O000100012O007A0001000A4O0025000200013O00122O000300253O00122O000400266O0002000400024O00010001000200202O0001000100274O00010002000200062O000100A400013O000428012O00A400012O007A0001000B3O00060A000100A400013O000428012O00A400012O007A000100033O0020C00001000100082O00452O01000200022O007A0002000C3O00064D2O0100A400010002000428012O00A400012O007A000100054O007A0002000A3O0020450002000200282O00452O010002000200060A000100A400013O000428012O00A400012O007A000100013O0012CD000200293O0012CD0003002A4O0028000100034O006A00015O002E12002B00C60001002C000428012O00C600012O007A0001000A4O0025000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200202O0001000100274O00010002000200062O000100C600013O000428012O00C600012O007A0001000D3O00060A000100C600013O000428012O00C600012O007A000100033O0020C00001000100082O00452O01000200022O007A0002000E3O00064D2O0100C600010002000428012O00C600012O007A000100054O007A0002000A3O00204500020002002F2O00452O0100020002000636000100C100010001000428012O00C10001002E12003100C600010030000428012O00C600012O007A000100013O0012CD000200323O0012CD000300334O0028000100034O006A00015O0012CD3O00023O000428012O000100012O003A3O00017O003F3O00025O002EA540025O00C8AD40030E3O0062DEB543177C5FDAB7423A6859D203063O001D2BB3D82C7B030A3O0049734361737461626C65030E3O00492O6D6F6C6174696F6E4175726103093O004973496E52616E6765031B3O00B4D42D43B1D83445B2D71F4DA8CB210CADCB254FB2D4224DA9997803043O002CDDB94003083O0049734D6F76696E67026O00F03F030C3O0032EE4F567F2EE16E53720CE203053O00136187283F03063O00BE5032222A2303063O0051CE3C535B4F03123O006DA4DE712ACD59B64FBFD5761CCA4AAD42B803083O00C42ECBB0124FA32D030B3O004973417661696C61626C65025O00508740025O0046A24003123O00536967696C4F66466C616D65506C61796572031A3O00AB2B791728C4E0BE1D781225F6EAF8326C1B27F4E2BA236A5E7D03073O008FD8421E7E449B03063O00A9DD1FD8CAB103083O0081CAA86DABA5C3B703123O00536967696C4F66466C616D65437572736F72026O004440031A3O00315130D1D22BE9246731D4DF19E36248252ODD1BEB205923988703073O0086423857B8BE74030E3O004973496E4D656C2O6552616E6765026O00144003083O001A3405B915EA253003083O00555C5169DB798B4103083O0046656C626C616465030E3O0049735370652O6C496E52616E676503143O00FBB65C4770DEF9B610556EDAFEBC5D477DCBBDEA03063O00BF9DD330251C025O0074A740025O00F08B4003073O00F91AF82E2FCC1703053O005ABF7F947C03083O005E82221574862A1203043O007718E74E03083O00A428A948D041158703073O0071E24DC52ABC20030C3O00432O6F6C646F776E446F776E03083O00507265764743445003073O0046656C52757368026O002E40025O00809540025O0020904003153O003C13F88A2803E7BD7A06E6B03919F9B73B02B4E46A03043O00D55A7694025O00F6A240030A3O007F2BB95943480CBD424803053O002D3B4ED436030B3O0034538E84880CA1F114539003083O00907036E3EBE64ECD025O0046AB40025O0082AA40030A3O0044656D6F6E734269746503283O00B72D02F3DE488C2A06E8D51BBC3A4FF8D556BC2630FEDC5AB72D1CBCC049B62B00F1D25AA7685EAE03063O003BD3486F9CB00009012O002EB70001001F00010002000428012O001F00012O007A8O0025000100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O001F00013O000428012O001F00012O007A3O00023O00060A3O001F00013O000428012O001F00012O007A3O00034O00C800015O00202O0001000100064O000200043O00202O0002000200074O000400056O0002000400024O000200028O0002000200064O001F00013O000428012O001F00012O007A3O00013O0012CD000100083O0012CD000200094O00283O00024O006A8O007A3O00063O00060A3O007000013O000428012O007000012O007A3O00073O0020C05O000A2O0045012O000200020006363O007000010001000428012O007000012O007A3O00083O000E30010B007000013O000428012O007000012O007A8O0025000100013O00122O0002000C3O00122O0003000D6O0001000300028O000100206O00056O0002000200064O007000013O000428012O007000012O007A3O00094O0046000100013O00122O0002000E3O00122O0003000F6O00010003000200064O004700010001000428012O004700012O007A8O0063000100013O00122O000200103O00122O000300116O0001000300028O000100206O00126O0002000200064O004700010001000428012O00470001002E120014005800010013000428012O005800012O007A3O00034O00C80001000A3O00202O0001000100154O000200043O00202O0002000200074O000400056O0002000400024O000200028O0002000200064O007000013O000428012O007000012O007A3O00013O0012D9000100163O00122O000200178O00029O003O00044O007000012O007A3O00094O0046000100013O00122O000200183O00122O000300196O00010003000200064O006000010001000428012O00600001000428012O007000012O007A3O00034O002B2O01000A3O00202O00010001001A4O000200043O00202O00020002000700122O0004001B6O0002000400024O000200028O0002000200064O007000013O000428012O007000012O007A3O00013O0012CD0001001C3O0012CD0002001D4O00283O00024O006A8O007A3O00043O0020C05O001E0012CD0002001F4O00243O000200020006363O009100010001000428012O009100012O007A8O0025000100013O00122O000200203O00122O000300216O0001000300028O000100206O00056O0002000200064O009100013O000428012O009100012O007A3O00034O009000015O00202O0001000100224O000200043O00202O0002000200234O00045O00202O0004000400224O0002000400024O000200028O0002000200064O009100013O000428012O009100012O007A3O00013O0012CD000100243O0012CD000200254O00283O00024O006A7O002E12002700D700010026000428012O00D700012O007A3O00043O0020C05O001E0012CD0002001F4O00243O000200020006363O00D700010001000428012O00D700012O007A8O0025000100013O00122O000200283O00122O000300296O0001000300028O000100206O00056O0002000200064O00D700013O000428012O00D700012O007A8O0025000100013O00122O0002002A3O00122O0003002B6O0001000300028O000100206O00126O0002000200064O00BF00013O000428012O00BF00012O007A8O0025000100013O00122O0002002C3O00122O0003002D6O0001000300028O000100206O002E6O0002000200064O00D700013O000428012O00D700012O007A3O00073O0020F75O002F00122O0002000B6O00035O00202O0003000300226O0003000200064O00D700010001000428012O00D700012O007A3O000B3O00060A3O00D700013O000428012O00D700012O007A3O000C3O00060A3O00D700013O000428012O00D700012O007A3O00034O008300015O00202O0001000100304O000200043O00202O00020002000700122O000400316O0002000400024O000200028O0002000200064O00D200010001000428012O00D20001002E12003200D700010033000428012O00D700012O007A3O00013O0012CD000100343O0012CD000200354O00283O00024O006A7O002EF50036003100010036000428012O00082O012O007A3O00043O0020C05O001E0012CD0002001F4O00243O0002000200060A3O00082O013O000428012O00082O012O007A3O000D3O00060A3O00082O013O000428012O00082O012O007A8O0063000100013O00122O000200373O00122O000300386O0001000300028O000100206O00056O0002000200064O00F600010001000428012O00F600012O007A8O0025000100013O00122O000200393O00122O0003003A6O0001000300028O000100206O00126O0002000200064O00082O013O000428012O00082O01002EB7003C00082O01003B000428012O00082O012O007A3O00034O002B2O015O00202O00010001003D4O000200043O00202O00020002001E00122O0004001F6O0002000400024O000200028O0002000200064O00082O013O000428012O00082O012O007A3O00013O0012CD0001003E3O0012CD0002003F4O00283O00024O006A8O003A3O00017O00183O0003083O0042752O66446F776E030A3O0046656C42612O72616765028O00025O005AAE40025O00D8B040030A3O006A82E23946B4F4284B9703043O004D2EE78303073O0049735265616479025O002OA040025O00689B40030A3O00446561746853772O657003093O004973496E52616E676503163O00BE51B754B26BA557BF51A600B751A2418551B844FA0603043O0020DA34D6030C3O006F193FA1F9B9495B5A1E3EA603083O003A2E7751C891D025025O00E8B140025O0090A940025O004C9040025O00CCAB40030C3O00412O6E6968696C6174696F6E030E3O0049735370652O6C496E52616E676503173O002A823EA5A1B43A2A9839A3A7FD3B2E983193ACB3326BD803073O00564BEC50CCC9DD00564O007A7O00205C5O00014O000200013O00202O0002000200026O0002000200064O005500013O000428012O005500010012CD3O00034O00DA000100013O0026E13O000D00010003000428012O000D0001002EB70005000900010004000428012O000900010012CD000100033O0026790001000E00010003000428012O000E00012O007A000200014O0025000300023O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002001D00013O000428012O001D00012O007A000200033O0006360002001F00010001000428012O001F0001002EB70009002F0001000A000428012O002F00012O007A000200044O00C8000300013O00202O00030003000B4O000400053O00202O00040004000C4O000600066O0004000600024O000400046O00020004000200062O0002002F00013O000428012O002F00012O007A000200023O0012CD0003000D3O0012CD0004000E4O0028000200044O006A00026O007A000200014O0025000300023O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200084O00020002000200062O0002003C00013O000428012O003C00012O007A000200073O0006360002003E00010001000428012O003E0001002E120011005500010012000428012O00550001002E120013005500010014000428012O005500012O007A000200044O0090000300013O00202O0003000300154O000400053O00202O0004000400164O000600013O00202O0006000600154O0004000600024O000400046O00020004000200062O0002005500013O000428012O005500012O007A000200023O0012D9000300173O00122O000400186O000200046O00025O00044O00550001000428012O000E0001000428012O00550001000428012O000900012O003A3O00017O00553O00028O00025O00C05140026O00F03F025O00D2A540025O00888140025O00788C40030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003113O004D6574616D6F7270686F73697342752O66025O00288540025O002FB040027O0040025O0046B140025O00E8A140025O0074AA40025O00F8A340030D3O005F446384F38460517F8AED826103063O00EB122117E59E030A3O0049734361737461626C6503073O0074BFCCB45EB3C203043O00DB30DAA1030B3O004973417661696C61626C65025O0044B340025O00308C4003133O004D6574616D6F7270686F736973506C6179657203093O004973496E52616E676503183O00E9746848D640F2F479735AD25CA0E77E7345DF40F7EA312803073O008084111C29BB2F030D3O002C37123B500E20163252123B1503053O003D6152665A03073O00882BA644C95E1D03083O0069CC4ECB2BA7377E03153O0086A22211070DC465B7AB2D0D150BD55CA4BE2A111D03083O0031C5CA437E7364A703073O001242DA0B85575303073O003E573BBF49E036030C3O00432O6F6C646F776E446F776E03073O00C21BFFEBE203F703043O00A987629A030F3O00432O6F6C646F776E52656D61696E73026O00344003083O005072657647434450030A3O00446561746853772O6570026O00394003103O00F87F2540E936DACE730051EE27C1C56E03073O00A8AB1744349D53025O0080514003073O00D168F08F202C8A03073O00E7941195CD454D030A3O00A2ABC6FF52DB81A9C4FE03063O009FE0C7A79B3703083O0042752O66446F776E030E3O00492O6E657244656D6F6E42752O6603183O00FAF628D3FAFC2EC2FFFC2FDBE4B33FDDF8FF38DDE0FD7C8403043O00B297935C025O00707F40025O00449640025O0007B34003083O0049734D6F76696E67030D3O00A9F155211B4D74A8F84F20174903073O001AEC9D2C52722C030A3O00446562752O66446F776E03123O00452O73656E6365427265616B446562752O6603063O003A22D4422F3C03043O003B4A4EB503133O00456C797369616E446563722O65506C6179657203223O0020DD4349BA24DF655EB626C32O5FF326DE5556B72AC6541AEB65996A56B23CD4481303053O00D345B12O3A025O00A6A340025O00D0A14003063O00B4F06B2OE6D903063O00ABD785199589025O0080A74003133O00456C797369616E446563722O65437572736F72026O003E4003223O00E4C42BE9E631F27DE5CD31E8EA35BC41EEC73EFEE027F202B9887AD9FA22EF4DF38103083O002281A8529A8F509C025O00707240025O00388840025O00DCB240025O0096A740025O001AA240025O00CCA040025O0098A840025O0018874000AC012O0012CD3O00014O00DA000100033O002EF5000200A12O010002000428012O00A32O010026793O00A32O010003000428012O00A32O012O00DA000300033O002EF50004000700010004000428012O000E0001000E2F0001000E00010001000428012O000E00010012CD000200014O00DA000300033O0012CD000100033O0026E10001001200010003000428012O00120001002EB70006000700010005000428012O000700010026790002002300010003000428012O002300012O007A00045O0020DB0004000400074O000500013O00202O0005000500084O000700023O00202O0007000700094O000500076O00043O00024O000300043O00062O0003002100010001000428012O00210001002E12000B00220001000A000428012O002200014O000300023O0012CD0002000C3O002679000200102O010001000428012O00102O010012CD000400013O0026790004000B2O010001000428012O000B2O010012CD000500013O002EB7000E002F0001000D000428012O002F00010026790005002F00010003000428012O002F00010012CD000400033O000428012O000B2O010026E10005003300010001000428012O00330001002E12000F002900010010000428012O002900012O007A000600034O007A000700043O00064F0106005700010007000428012O005700012O007A000600053O00060A0006003D00013O000428012O003D00012O007A000600063O0006360006004000010001000428012O004000012O007A000600063O0006360006005700010001000428012O005700012O007A000600024O0025000700073O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600134O00060002000200062O0006005700013O000428012O005700012O007A000600083O00060A0006005700013O000428012O005700012O007A000600024O0025000700073O00122O000800143O00122O000900156O0007000900024O00060006000700202O0006000600164O00060002000200062O0006005900013O000428012O00590001002EB70017006900010018000428012O006900012O007A000600094O00C80007000A3O00202O0007000700194O0008000B3O00202O00080008001A4O000A000C6O0008000A00024O000800086O00060008000200062O0006006900013O000428012O006900012O007A000600073O0012CD0007001B3O0012CD0008001C4O0028000600084O006A00066O007A000600034O007A000700043O00064F010600092O010007000428012O00092O012O007A000600053O00060A0006007300013O000428012O007300012O007A000600063O0006360006007600010001000428012O007600012O007A000600063O000636000600092O010001000428012O00092O012O007A000600024O0025000700073O00122O0008001D3O00122O0009001E6O0007000900024O00060006000700202O0006000600134O00060002000200062O000600092O013O000428012O00092O012O007A000600083O00060A000600092O013O000428012O00092O012O007A000600024O0025000700073O00122O0008001F3O00122O000900206O0007000900024O00060006000700202O0006000600164O00060002000200062O000600092O013O000428012O00092O012O007A000600024O0063000700073O00122O000800213O00122O000900226O0007000900024O00060006000700202O0006000600164O00060002000200062O000600A100010001000428012O00A100012O007A000600024O0063000700073O00122O000800233O00122O000900246O0007000900024O00060006000700202O0006000600254O00060002000200062O000600F200010001000428012O00F200012O007A000600024O0025010700073O00122O000800263O00122O000900276O0007000900024O00060006000700202O0006000600284O000600020002000E2O002900BE00010006000428012O00BE00012O007A0006000D3O00060A000600F200013O000428012O00F200012O007A000600013O0020F700060006002A00122O000800036O000900023O00202O00090009002B4O00060009000200062O000600F200010001000428012O00F200012O007A000600013O0020F700060006002A00122O0008000C6O000900023O00202O00090009002B4O00060009000200062O000600F200010001000428012O00F200012O007A000600044O004F0007000E3O00122O0008002C6O0009000F6O000A00026O000B00073O00122O000C002D3O00122O000D002E6O000B000D00024O000A000A000B00202O000A000A00162O0003000A000B4O00D600093O000200202O00090009002F4O0007000900024O000800103O00122O0009002C6O000A000F6O000B00026O000C00073O00122O000D002D3O00122O000E002E4O0024000C000E00022O00C7000B000B000C00202O000B000B00164O000B000C6O000A3O000200202O000A000A002F4O0008000A00024O00070007000800062O000600092O010007000428012O00092O012O007A000600024O0025000700073O00122O000800303O00122O000900316O0007000900024O00060006000700202O0006000600254O00060002000200062O000600092O013O000428012O00092O012O007A000600024O0025000700073O00122O000800323O00122O000900336O0007000900024O00060006000700202O0006000600254O00060002000200062O000600092O013O000428012O00092O012O007A000600013O00205C0006000600344O000800023O00202O0008000800354O00060008000200062O000600092O013O000428012O00092O012O007A000600094O00C80007000A3O00202O0007000700194O0008000B3O00202O00080008001A4O000A000C6O0008000A00024O000800086O00060008000200062O000600092O013O000428012O00092O012O007A000600073O0012CD000700363O0012CD000800374O0028000600084O006A00065O0012CD000500033O000428012O002900010026790004002600010003000428012O002600010012CD000200033O000428012O00102O01000428012O002600010026E1000200142O01000C000428012O00142O01002E120039001200010038000428012O00120001002EF5003A00600001003A000428012O00742O012O007A000400034O007A000500043O00064F010400742O010005000428012O00742O012O007A000400113O00060A000400742O013O000428012O00742O012O007A000400013O0020C000040004003B2O0045010400020002000636000400742O010001000428012O00742O012O007A000400053O00060A000400282O013O000428012O00282O012O007A000400123O0006360004002B2O010001000428012O002B2O012O007A000400123O000636000400742O010001000428012O00742O012O007A000400024O0025000500073O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400742O013O000428012O00742O012O007A0004000B3O00205C00040004003E4O000600023O00202O00060006003F4O00040006000200062O000400742O013O000428012O00742O012O007A000400134O007A000500143O00064F010500742O010004000428012O00742O012O007A000400154O00DF000500073O00122O000600403O00122O000700416O00050007000200062O000400582O010005000428012O00582O012O007A000400094O00C80005000A3O00202O0005000500424O0006000B3O00202O00060006001A4O0008000C6O0006000800024O000600066O00040006000200062O000400742O013O000428012O00742O012O007A000400073O0012D9000500433O00122O000600446O000400066O00045O00044O00742O01002EB7004600622O010045000428012O00622O012O007A000400154O0046000500073O00122O000600473O00122O000700486O00050007000200062O000400622O010005000428012O00622O01000428012O00742O01002EF50049001200010049000428012O00742O012O007A000400094O002B0105000A3O00202O00050005004A4O0006000B3O00202O00060006001A00122O0008004B6O0006000800024O000600066O00040006000200062O000400742O013O000428012O00742O012O007A000400073O0012CD0005004C3O0012CD0006004D4O0028000400064O006A00046O007A000400034O007A000500043O00064D010500792O010004000428012O00792O01000428012O00AB2O01002EB7004E00AB2O01004F000428012O00AB2O012O007A000400163O00060A000400AB2O013O000428012O00AB2O012O007A000400053O00060A000400842O013O000428012O00842O012O007A000400173O000636000400872O010001000428012O00872O012O007A000400173O000636000400AB2O010001000428012O00AB2O010012CD000400014O00DA000500053O0026E10004008D2O010001000428012O008D2O01002E12005000892O010051000428012O00892O010012CD000500013O002E120053008E2O010052000428012O008E2O010026790005008E2O010001000428012O008E2O012O007A000600194O008D0006000100022O003C000600184O007A000600183O00060A000600AB2O013O000428012O00AB2O012O007A000600186O000600023O000428012O00AB2O01000428012O008E2O01000428012O00AB2O01000428012O00892O01000428012O00AB2O01000428012O00120001000428012O00AB2O01000428012O00070001000428012O00AB2O010026E13O00A72O010001000428012O00A72O01002EF50054005DFE2O0055000428012O000200010012CD000100014O00DA000200023O0012CD3O00033O000428012O000200012O003A3O00017O0038022O00028O00025O00E0B140025O003AB240026O001440026O00F03F025O0006AE40025O00ACA74003083O00DC49EEFE7BFB48E703053O00179A2C829C030A3O0049734361737461626C65030B3O004675727944656669636974026O00444003083O005072657647434450030F3O0056656E676566756C5265747265617403083O0046656C626C616465030E3O0049735370652O6C496E52616E676503143O0017A3A1AC3A1215A3EDBC390710B2A4A1385344F603063O007371C6CDCE56025O00B4A340025O00C0984003073O00A252F2689144F603043O003AE4379E03083O009986DD2B32B920B903073O0055D4E9B04E5CCD030B3O004973417661696C61626C65030B3O006E5D85ED447A84E34E5D9B03043O00822A38E803073O00CFAC21C1453EE703063O005F8AD5448320030C3O00432O6F6C646F776E446F776E03083O0042752O66446F776E03103O00556E626F756E644368616F7342752O6603073O000C2DAD7163392003053O00164A48C12303083O005265636861726765030C3O00096AF75D227AE17A3E7CE55303043O00384C1984030F3O00432O6F6C646F776E52656D61696E73030C3O007BD2B823C15DC48934CA5FCA03053O00AF3EA1CB4603073O0046656C52757368030B3O005468726F77476C6169766503143O003AD8CF2C2729CECB532733C9C2073C33D383466703053O00555CBDA373027O0040025O005AA940030B3O00C8CDB0EEDDD8D1A3E8C5EE03053O00AE8BA5D18103073O0049735265616479030A3O0046656C42612O72616765030B3O004368616F73537472696B65025O006AB140025O0014A74003183O00A0BBE3CED53C636CB1BAE9C486117F6CA2A7EBCEC843242E03083O0018C3D382A1A66310030C3O00750AEE255F394025E52D5E1303063O00762663894C3303083O0049734D6F76696E67026O003E40025O0040A040025O00307D40026O004D40025O0050834003063O00ED2A040B0C3203063O00409D4665726903123O0063A7A9E0154EBCB5E20445AC94EA1749A4B403053O007020C8C78303123O00536967696C4F66466C616D65506C6179657203093O004973496E52616E676503213O003F595BB1CF942D2A6F5AB4C2A6276C4253ACC2BF2B235E1CA8CFAA3B29421CEC9B03073O00424C303CD8A3CB03063O00B9936BE050DC03073O0044DAE619933FAE025O00D88B40025O008EAC4003123O00536967696C4F66466C616D65437572736F7203213O00BE235445BA92255573B0A12B5E49F6BF25474DA2A4255D0CB5B8384043A4ED7E0B03053O00D6CD4A332C030A3O000DA93D3727BF12313DA903043O005849CC50030C3O000C96024820D429B41F5327DE03063O00BA4EE3702649030D3O00446562752O6652656D61696E7303123O004275726E696E67576F756E64446562752O66026O001040030A3O0044656D6F6E734269746503173O00F852F05A5D69C355F441563AEE58E9544773F359BD000703063O001A9C379D3533026O001840025O00BFB040025O004CAC40026O004140025O0012A440025O0078A640025O00AC944003073O002EBD8D250FBB9C03043O006D7AD5E8030A3O00446562752O66446F776E03123O00452O73656E6365427265616B446562752O66030A3O00436F6D62617454696D65026O002440030D3O00C3F2B631E3F8B020E6F8B139FD03043O00508E97C2026O000840030B3O0025D365450CD3646B02DC7203043O002C63A61703063O0042752O665570030F3O00467572696F757347617A6542752O6603073O0048617354696572026O003F4003073O0054686548756E7403103O0068FF2C093BB172E3693B32AD72B7786403063O00C41C97495653025O00B89F40030C3O0075B2E6264A2D5583E726452503063O004E30C1954324030B3O0042752O6652656D61696E7303113O004D6574616D6F7270686F73697342752O6603073O001507853A44311303053O0021507EE078030F3O00D8A900D055EFA90FF659F8BA06C54803053O003C8CC863A403133O00546163746963616C5265747265617442752O66030A3O00A5F80522A7A3F50A25A703053O00C2E794644602CD5OCC0840030C3O00452O73656E6365427265616B025O00E09F40025O0050854003193O00435FD2A6F8CB4373C3B1F3C94D0CD3ACE2C95245CEADB6991503063O00A8262CA1C396030A3O00A4F9836238DBA11385EC03083O0076E09CE2165088D6030C3O0067FD4A854CED5CA250EB588B03043O00E0228E39030C3O00FBB4D6D87DF2582CCCA2C4D603083O006EBEC7A5BD13913D025O00D07040025O009CA240025O00208A40025O0024B040030A3O00446561746853772O657003173O00DEEE76FC83F8C9FC72ED9B87C8E463E99FCED5E537B9DF03063O00A7BA8B1788EB025O005AA740025O009C9040025O00CCA240025O002AA940025O00DEAB40025O006BB14003073O001E0301DF2D150503043O008D58666D03083O009E5CC775142940CC03083O00A1D333AA107A5D35030C3O004D6F6D656E74756D42752O6603073O00DE2OB70AFEAFBF03043O00489BCED2030A3O006476550A36627B5A0D3603053O0053261A346E025O00109D40025O0022A04003143O005E122B794A02344E1805285259032E495657761603043O002638774703073O00D5EA54E43045FB03063O0036938F38B64503073O00FF8FFA5BCBDF8003053O00BFB6E19F29030B3O00496E657274696142752O6603073O000E0B2D778E86CF03073O00A24B724835EBE7030E3O00A53149ED5F0398354BEC72179E3D03063O0062EC5C24823303073O008100099840A9B803083O0050C4796CDA25C8D5030A3O00227F037B4E2A8B0E700703073O00EA6013621F2B6E025O0096A040025O001EB340025O0046AC4003144O001A5EF8BE67980E5F40C8B8739F0F105C87FD2303073O00EB667F32A7CC12025O00A8A040025O000EAA40025O007DB140025O0022AC40030B3O00348FB05F17A0AE510991A703043O003060E7C203083O00FB551B210ADBAE9103083O00E3A83A6E4D79B8CF030D3O005D29AD49BECE6291732EB057A203083O00C51B5CDF20D1BB11030B3O003757D1F41478CFFA0A49C603043O009B633FA303103O0046752O6C526563686172676554696D65025O002CAB40025O0068824003183O0096D9B382AEBB85DDA084AF81C2C3AE99B8908BDEAFCDEAD603063O00E4E2B1C1EDD9030E3O001DBD2EE938B137EF3BBE02F326B103043O008654D04303043O0046757279025O00805140025O00109B40025O00406040030E3O00492O6D6F6C6174696F6E41757261031B3O001AA18B531FAD92551CA2B95D06BE871C01A3925D07A5895253FFD203043O003C73CCE6030C3O00C634E579EF33E771F333E47E03043O0010875A8B030C3O007167153640577D766603324503073O0018341466532E34030C3O00E13C322101C72A03360AC52403053O006FA44F4144030C3O00412O6E6968696C6174696F6E025O00188B40025O001EA94003183O00C7D78DD726E3CAD897D721E486CB8CCA2FFECFD68D9E7DBC03063O008AA6B9E3BE4E025O00C88440025O00BDB140030A3O00D7B20B1F72DCF4B0091E03063O009895DE6A7B1703073O00F83FF361B0DC2B03053O00D5BD46962303073O006B507907415C7703043O00682F3514025O00049140025O00FEAA40030A3O00426C61646544616E636503173O00A1408018B930A74D8F1FB94FB143951DA806AC42C14EE403063O006FC32CE17CDC030C3O00EB4F077AA784DE600C72A6AE03063O00CBB8266013CB03113O00187D606CCB387D6A6FCB3A766A52CF2B6A03053O00AE59131921025O0084AB40025O00C4A04003063O003F1E5357F29503073O006B4F72322E97E703123O001AA9BB2A8F37A3D238B2B02DB930B0C935B503083O00A059C6D549EA59D7025O0046AB40025O0074A94003213O005B78B3F7C9777EB2C1C34470B9FB855A7EA0FFD1417EBABED54470ADFBD70822E403053O00A52811D49E03063O00E6CC1A2029F703053O004685B96853025O0061B140025O0078AC4003213O00174C4323C53B4A4215CF0844492F89164A502BDD0D2O4A6ACA112O5725DB44161403053O00A96425244A025O00206340025O007C9D40025O00949B40026O008440026O006940025O00B6AF4003073O001350F63276CF3B03063O00AE5629937013030D3O007605990A280003BB530F9E023603083O00CB3B60ED6B456F71030D3O00070FAFED34DFD10C17B8F334F403073O00B74476CC815190026O002E40030D3O0023A864E5068D1CBD78EB188B1D03063O00E26ECD10846B030C3O00CED0F3DC4FE8C6C2CB44EAC803053O00218BA380B9030C3O00724B17DB595B01FC455D05D503043O00BE373864026O00F83F030E3O0064AA2F0A1FE6E04587291007E6E103073O009336CF5C7E7383030D3O002E28367108510B1934691F7B0903063O001E6D51551D6D030A3O00D67F5DA23FDFE8F6675103073O009C9F1134D656BE030F3O0098EAB3BBABE9A8B09CEAA9AEABEEA903043O00DCCE8FDD030E3O00492O6E657244656D6F6E42752O6603073O004579654265616D03143O0083642O28DAC9D38B3D3F18CCCDC68F7223578A9A03073O00B2E61D4D77B8AC025O0014A940025O00E09540030A3O00D5062532834A0A77F40603083O001693634970E23878026O00344003173O00BE70EECA8FB967F0F48ABD35F0FA99B961EBFA83F824B403053O00EDD8158295030D3O00A5425E56A6CC6A87434F5AA3DD03073O003EE22E2O3FD0A9030D3O00476C6169766554656D70657374031A3O00E215548A0908104AE01445860C196F4CEA0D54971602211EB44103083O003E857935E37F6D4F025O00909540025O002EAE40030C3O00311A3CFCDEA7AE11003BFAD803073O00C270745295B6CE03073O001CB1493AC5E32O03073O006E59C82C78A0822O033O00474344025O00E06640025O001AAA4003183O00AACD454F4B43374CBFCA444803583459AAD742494D0A691D03083O002DCBA32B26232A5B03073O00F480D01192BA5C03073O0034B2E5BC43E7C903083O000C4E5D01F948362C03073O004341213064973C03073O00FAFEABFAF6DEEA03053O0093BF87CEB8025O00A07A40025O0098A940025O0010AC40025O00F8AF4003143O00822DAAFECA46A18C68B4CECC52A68D27A8818A0103073O00D2E448C6A1B833030F3O0025D08CFCEFC106D9B02OFED516D49603063O00A773B5E29B8A03073O00C427EB2O6E62CE03073O00A68242873C1B1103073O0043686172676573030A3O006D44C76139455EC7633503053O0050242AAE15030C3O006B03247F401332585C15367103043O001A2E7057030C3O009C30B871B1BC4096AB26AA7F03083O00D4D943CB142ODF25030C3O009F9EBBD7B48EADF0A888A9D903043O00B2DAEDC803073O0092B0EBDFB8BCE503043O00B0D6D58603073O00D1B4B3F6AD575403073O003994CDD6B4C836030D3O0031E43638733DFB1D356200F83103053O0016729D5554030A3O0047434452656D61696E73030A3O00EDC51AD054F7BCCDDD1603073O00C8A4AB73A43D96030E3O00496E697469617469766542752O66031B3O00A8F10D4286B8E10F7A91BBE0114082AAB4114A97BFE00A4A8DFEA003053O00E3DE946325025O0068AA40030F3O0005575CF1FC35475EC4FC274057F7ED03053O0099532O329603073O007B737F2E66B84503073O002D3D16137C13CB030A3O00E81C04E10B71ADC8040803073O00D9A1726D956210030C3O0037332B79B27717022A79BD7F03063O00147240581CDC030C3O001412C1B1F6D3B82O13D7B5F303073O00DD5161B2D498B0030C3O00E8F40EFE14CEE23FE91FCCEC03053O007AAD877D9B03073O00A1D8059B3A30C503073O00A8E4A160D95F5103073O00FFD42353215ED803063O0037BBB14E3C4F03073O0008D75AC943CE8D03073O00E04DAE3F8B26AF030D3O00A7585B22814E5E0685554A2B8003043O004EE42138025O00E9B240025O00F5B140031B3O00D87BBC0480C86BBE3C97CB6AA00684DA3EA00C91CF6ABB0C8B8E2803053O00E5AE1ED263025O00F4AE40030F3O002DE88856E83B2C17DF8345FF2O380F03073O00597B8DE6318D5D03073O00D574FA3E0559FB03063O002A9311966C70030A3O0026A8246BEEE91BAF3B7A03063O00886FC64D1F87030C3O00271AB453B3E7128B100CA65D03083O00C96269C736DD8477030D3O00940997200F3ABEA9048C320B2603073O00CCD96CE3416255030A3O00432O6F6C646F776E557003153O007DCBF4EA38C95DF7E7E422D358CCE7E82DD457CCFB03063O00A03EA395854C030A3O00FFAE043BCAD7B40439C603053O00A3B6C06D4F025O00E2A740025O006AA040031B3O0022230EC7F032330CFFE7313212C5F4206612CFE1353209CFFB747E03053O0095544660A0025O0012AF40025O0050B240030C3O00A4BC3D0240478584A63A044603073O00E9E5D2536B282E030D3O00EC4726D708CE5022DE0AD24B2103053O0065A12252B603173O00E90357F7D3EB8E2FFC0456F09BF08D3AE91950F1D5A2D003083O004E886D399EBB82E2030F3O00083AF7F63B39ECFD0C3AEDE33B3EED03043O00915E5F9903073O00DBC818E75BA4F503063O00D79DAD74B52E03073O0010AD8ED0DF34B903053O00BA55D4EB92026O33D33F030C3O00E79205FB37ED5DE09313FF3203073O0038A2E1769E598E03073O00750BC5BD36D15D03063O00B83C65A0CF42025O00308840025O00707C40031B3O00278772BB348469B00E9079A823877DA8719073A8309675B33FC22F03043O00DC51E21C026O008A40025O0056A240025O00389E40025O00B2A540030A3O0056EDC9AC05505B7BFCC103073O00191288A4C36B2303173O00EC28A4407CAFFEBAE139AC0F60B3D5B9FC24A64132E99603083O00D8884DC92F12DCA103073O000BE927E81DCF8A03073O00E24D8C4BBA68BC03083O0094C1DD3A41ADDBDD03053O002FD9AEB05F025O00E08240025O003DB240025O0050A040025O00B6A24003143O00BED87A3DA0416B2EF8CF7916B3407129B69D235A03083O0046D8BD1662D23418025O00209F40025O0074A44003073O00FCDAAFB5C6C9D703053O00B3BABFC3E703083O00D43015E1F72B0DE903043O0084995F78025O00ECA940025O00207A4003143O002OB70212E5CFB3B9F21C22E3DBB4B8BD006DA28303073O00C0D1D26E4D97BA026O001C40025O00C6AF40025O00D2A34003073O00AADD1AEBAD438403063O0030ECB876B9D803083O00C8B25A35C120F0B003063O005485DD3750AF030B3O0099E229A9C97EB1E620A3D403063O003CDD8744C6A7025O0049B040025O00B8AF4003143O00E8B8F4BC50CCFDB5B8914DCDEFA9F18C4C99BBEB03063O00B98EDD98E322030C3O006BCC50F34F1CF17EC956F74603073O009738A5379A235303063O00B04F04F7A55103043O008EC0236503123O00F57A27A0E282B804D7612CA7D485AB1FDA6603083O0076B61549C387ECCC025O00805540025O00F0824003213O001B351D490832F20E031C4C0500F8482E15540519F407325A50080CE40D2E5A155C03073O009D685C7A20646D03063O00A0B3DDD9323503083O00CBC3C6AFAA5D47ED03213O003D4239DC5D2EF3287438D9501CF96E5931C15005F521457ED64403EF21597E800903073O009C4E2B5EB53171025O002AA340025O00E8A440025O0083B040025O00B07140025O000EA640025O0092B040025O00E07640030B3O003DA52F7C1E8A317200BB3803043O001369CD5D03083O009A07CB8D2CAA09CC03053O005FC968BEE1030B3O009BC3D3C1B8ECCDCFA6DDC403043O00AECFABA1030A3O00CFF20CF7FDF3ECF00EF603063O00B78D9E6D9398025O0068B24003183O003801F4033B36E1002D00F0096C1BE9182D1DEF032249B25803043O006C4C6986025O0060A740030B3O002E4A31AC286EE90F13542603083O006E7A2243C35F298503083O0046BE4E46C576B04903053O00B615D13B2A030D3O009142D7142EABA463CD0F2EA9A403063O00DED737A57D4103183O0038D9D415E5FEEA462DD8D01FB2D3E25E2DC5CF15FC81B91A03083O002A4CB1A67A92A18D025O00289740025O00D09640030E3O008C8708C17577B1830AC05863B78B03063O0016C5EA65AE1903093O0042752O66537461636B03123O00492O6D6F6C6174696F6E4175726142752O66026O002040030C3O00183AA7D363A1D3A52535AACF03083O00E64D54C5BC16CFB7030E3O00D019CBF380A0E43CF61AE7E99EA003083O00559974A69CECC190030C3O0081F35EB6EA03A1C25FB6E50B03063O0060C4802DD384030C3O00109E685ADCACB1FA27887A5403083O00B855ED1B3FB2CFD403073O002D400C7D0D580403043O003F683969030E3O00228AA94B0786B04D04898551198603043O00246BE7C4025O00606540025O0053B240031B3O0054B8AF8851B4B68E52BB9D8648A7A3C74FBAB68649BCAD891DE1F003043O00E73DD5C203083O00ED71C9355E221DCE03073O0079AB14A557324303113O00E736A01BBC03C82B9733BA07D52BB824A003063O0062A658D956D903113O00D7F8602C83DDF8E5570485D92OE578139F03063O00BC2O961961E6025O00FAA040025O00E8B24003143O00DC8C532O00ECDE8C1F1003F9DB9D560D02AD89D103063O008DBAE93F626C030C3O00C2E32BBF29DEEC0ABA24FCEF03053O0045918A4CD603113O0051C190A4BA177EDCA78CBC1363DC889BA603063O007610AF2OE9DF03063O009B8834A2EB9903073O001DEBE455DB8EEB03123O001EDBB4DE724033403CC0BFD94447205B31C703083O00325DB4DABD172E47025O0058AE40025O0008954003213O00CDAD5C4548E347D89B5D4045D14D9EB6545845C841D1AA1B5C48DD51DBB61B1F1D03073O0028BEC43B2C24BC025O0040AA4003063O003F50CEA7F56F03073O006D5C25BCD49A1D025O00E89040026O00A64003213O0017E6A3CA3D650BE99BC53D5B09EAE4D13E4E05FBADCC3F1A07FAB6D03E4844BCFD03063O003A648FC4A351025O00ECAD40025O00E8B040030F3O00D6062CEEFAC2F50F10ECEBD6E5023603063O00A4806342899F03073O00268CE58C159AE103043O00DE60E989030A3O0090BDAE0B81F2E4B0A5A203073O0090D9D3C77FE893025O002C9140025O0092B240025O0007B340025O001CB340031C3O00EE2A302FD0431748C73D3B3CC7400350B83D313CD4510B4BF66F687803083O0024984F5E48B52562030B3O00E3D05530C0FF4B3EDECE4203043O005FB7B827030B3O00913AEA295AA20EB43BE23503073O0062D55F874634E0026O002840025O00B2A240025O0080994003183O00EAABDB7843C1A4C5765DE8A689655BEAA2DD7E5BF0E39F2503053O00349EC3A91700710D2O0012CD3O00014O00DA000100013O000E2F0001000200013O000428012O000200010012CD000100013O002EB70002005B2O010003000428012O005B2O010026790001005B2O010004000428012O005B2O010012CD000200013O0026E10002000E00010005000428012O000E0001002EF50006009200010007000428012O009E00012O007A00036O0025000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003900013O000428012O003900012O007A000300023O00060A0003003900013O000428012O003900012O007A000300033O0020C000030003000B2O0045010300020002000E04010C003900010003000428012O003900012O007A000300033O0020F700030003000D00122O000500056O00065O00202O00060006000E4O00030006000200062O0003003900010001000428012O003900012O007A000300044O009000045O00202O00040004000F4O000500053O00202O0005000500104O00075O00202O00070007000F4O0005000700024O000500056O00030005000200062O0003003900013O000428012O003900012O007A000300013O0012CD000400113O0012CD000500124O0028000300054O006A00035O002EB70014009D00010013000428012O009D00012O007A00036O0025000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003009D00013O000428012O009D00012O007A000300063O00060A0003009D00013O000428012O009D00012O007A000300073O00060A0003009D00013O000428012O009D00012O007A00036O0063000400013O00122O000500173O00122O000600186O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009D00010001000428012O009D00012O007A00036O0025000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009D00013O000428012O009D00012O007A00036O0025000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003001E4O00030002000200062O0003009D00013O000428012O009D00012O007A000300033O00205C00030003001F4O00055O00202O0005000500204O00030005000200062O0003009D00013O000428012O009D00012O007A00036O0027010400013O00122O000500213O00122O000600226O0004000600024O00030003000400202O0003000300234O0003000200024O00048O000500013O00122O000600243O00122O000700256O0005000700024O00040004000500202O0004000400264O00040002000200062O0003008C00010004000428012O008C00012O007A00036O0063000400013O00122O000500273O00122O000600286O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009D00010001000428012O009D00012O007A000300044O009000045O00202O0004000400294O000500053O00202O0005000500104O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O0003009D00013O000428012O009D00012O007A000300013O0012CD0004002B3O0012CD0005002C4O0028000300054O006A00035O0012CD0002002D3O002EF5002E00890001002E000428012O00272O01002679000200272O010001000428012O00272O012O007A00036O0025000400013O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300314O00030002000200062O000300CF00013O000428012O00CF00012O007A000300083O00060A000300CF00013O000428012O00CF00012O007A000300093O000636000300CF00010001000428012O00CF00012O007A0003000A3O000636000300CF00010001000428012O00CF00012O007A000300033O00205C00030003001F4O00055O00202O0005000500324O00030005000200062O000300CF00013O000428012O00CF00012O007A000300044O008F00045O00202O0004000400334O000500053O00202O0005000500104O00075O00202O0007000700334O0005000700024O000500056O00030005000200062O000300CA00010001000428012O00CA0001002E12003400CF00010035000428012O00CF00012O007A000300013O0012CD000400363O0012CD000500374O0028000300054O006A00036O007A00036O0025000400013O00122O000500383O00122O000600396O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300E600013O000428012O00E600012O007A000300033O0020C000030003003A2O0045010300020002000636000300E600010001000428012O00E600012O007A0003000B3O00060A000300E600013O000428012O00E600012O007A000300033O0020C000030003000B2O0045010300020002000E1F013B00E800010003000428012O00E80001002E12003C00262O01003D000428012O00262O01002EB7003E000C2O01003F000428012O000C2O012O007A0003000C4O0046000400013O00122O000500403O00122O000600416O00040006000200062O000300FB00010004000428012O00FB00012O007A00036O0025000400013O00122O000500423O00122O000600436O0004000600024O00030003000400202O0003000300194O00030002000200062O0003000C2O013O000428012O000C2O012O007A000300044O00C80004000D3O00202O0004000400444O000500053O00202O0005000500454O0007000E6O0005000700024O000500056O00030005000200062O000300262O013O000428012O00262O012O007A000300013O0012D9000400463O00122O000500476O000300056O00035O00044O00262O012O007A0003000C4O00DF000400013O00122O000500483O00122O000600496O00040006000200062O000300262O010004000428012O00262O01002EB7004B00162O01004A000428012O00162O01000428012O00262O012O007A000300044O002B0104000D3O00202O00040004004C4O000500053O00202O00050005004500122O0007003B6O0005000700024O000500056O00030005000200062O000300262O013O000428012O00262O012O007A000300013O0012CD0004004D3O0012CD0005004E4O0028000300054O006A00035O0012CD000200053O0026790002000A0001002D000428012O000A00012O007A00036O0025000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300582O013O000428012O00582O012O007A0003000F3O00060A000300582O013O000428012O00582O012O007A00036O0025000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O0003000300194O00030002000200062O000300582O013O000428012O00582O012O007A000300053O0020080103000300534O00055O00202O0005000500544O00030005000200262O000300582O010055000428012O00582O012O007A000300044O009000045O00202O0004000400564O000500053O00202O0005000500104O00075O00202O0007000700564O0005000700024O000500056O00030005000200062O000300582O013O000428012O00582O012O007A000300013O0012CD000400573O0012CD000500584O0028000300054O006A00035O0012CD000100593O000428012O005B2O01000428012O000A00010026E10001005F2O010005000428012O005F2O01002EB7005A00600301005B000428012O006003010012CD000200014O00DA000300033O002E12005C00612O01005D000428012O00612O01002679000200612O010001000428012O00612O010012CD000300013O0026E10003006A2O01002D000428012O006A2O01002EF5005E007C0001005F000428012O00E42O012O007A00046O0025000500013O00122O000600603O00122O000700616O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400E22O013O000428012O00E22O012O007A000400063O00060A000400E22O013O000428012O00E22O012O007A000400103O00060A000400E22O013O000428012O00E22O012O007A000400114O007A000500123O00064F010400E22O010005000428012O00E22O012O007A000400133O00060A000400842O013O000428012O00842O012O007A000400143O000636000400872O010001000428012O00872O012O007A000400143O000636000400E22O010001000428012O00E22O012O007A000400053O00205C0004000400624O00065O00202O0006000600634O00040006000200062O000400E22O013O000428012O00E22O012O007A000400153O0020450004000400642O008D0004000100020026CF0004009D2O010065000428012O009D2O012O007A00046O0025010500013O00122O000600663O00122O000700676O0005000700024O00040004000500202O0004000400264O000400020002000E2O006500E22O010004000428012O00E22O012O007A000400163O0026E1000400A62O010005000428012O00A62O012O007A000400163O000EEC006800A62O010004000428012O00A62O012O007A000400123O002615000400E22O010065000428012O00E22O012O007A000400053O00205C0004000400624O00065O00202O0006000600634O00040006000200062O000400C52O013O000428012O00C52O012O007A00046O0025000500013O00122O000600693O00122O0007006A6O0005000700024O00040004000500202O0004000400194O00040002000200062O000400CC2O013O000428012O00CC2O012O007A000400033O00201501040004006B4O00065O00202O00060006006C4O00040006000200062O000400CC2O010001000428012O00CC2O012O007A000400033O00206200040004006D00122O0006006E3O00122O000700556O00040007000200062O000400CC2O010001000428012O00CC2O012O007A000400033O00206200040004006D00122O0006003B3O00122O0007002D6O00040007000200062O000400E22O010001000428012O00E22O012O007A000400153O0020450004000400642O008D000400010002000E30016500E22O010004000428012O00E22O012O007A000400044O009000055O00202O00050005006F4O000600053O00202O0006000600104O00085O00202O00080008006F4O0006000800024O000600066O00040006000200062O000400E22O013O000428012O00E22O012O007A000400013O0012CD000500703O0012CD000600714O0028000400064O006A00045O0012CD0001002D3O000428012O006003010026790003008902010005000428012O008902010012CD000400013O002EF50072009D00010072000428012O008402010026790004008402010001000428012O008402012O007A00056O0025000600013O00122O000700733O00122O000800746O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005004202013O000428012O004202012O007A000500173O00060A0005004202013O000428012O004202012O007A000500033O0020BA0005000500754O00075O00202O0007000700764O0005000700024O000600183O00202O00060006006800062O0006000B02010005000428012O000B02012O007A00056O0025010600013O00122O000700773O00122O000800786O0006000800024O00050005000600202O0005000500264O000500020002000E2O0065002D02010005000428012O002D02012O007A00056O0025000600013O00122O000700793O00122O0008007A6O0006000800024O00050005000600202O0005000500194O00050002000200062O0005002102013O000428012O002102012O007A000500033O00201501050005006B4O00075O00202O00070007007B4O00050007000200062O0005002102010001000428012O002102012O007A000500153O0020450005000500642O008D0005000100020026150005002D02010065000428012O002D02012O007A00056O002F010600013O00122O0007007C3O00122O0008007D6O0006000800024O00050005000600202O0005000500264O0005000200024O000600183O00102O0006007E000600062O0005000400010006000428012O003002012O007A000500123O0026150005004202010059000428012O004202012O007A000500044O008800065O00202O00060006007F4O000700053O00202O0007000700454O0009000E6O0007000900024O000700076O00050007000200062O0005003D02010001000428012O003D0201002EF50080000700010081000428012O004202012O007A000500013O0012CD000600823O0012CD000700834O0028000500074O006A00056O007A00056O0025000600013O00122O000700843O00122O000800856O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005006F02013O000428012O006F02012O007A000500193O00060A0005006F02013O000428012O006F02012O007A0005001A3O00060A0005006F02013O000428012O006F02012O007A00056O0025000600013O00122O000700863O00122O000800876O0006000800024O00050005000600202O0005000500194O00050002000200062O0005006802013O000428012O006802012O007A00056O002D010600013O00122O000700883O00122O000800896O0006000800024O00050005000600202O0005000500264O0005000200024O000600183O00202O00060006002D00062O0006006F02010005000428012O006F02012O007A000500033O00201501050005001F4O00075O00202O0007000700324O00050007000200062O0005007102010001000428012O00710201002EB7008B00830201008A000428012O00830201002EB7008C00830201008D000428012O008302012O007A000500044O00C800065O00202O00060006008E4O000700053O00202O0007000700454O0009000E6O0007000900024O000700076O00050007000200062O0005008302013O000428012O008302012O007A000500013O0012CD0006008F3O0012CD000700904O0028000500074O006A00055O0012CD000400053O002679000400E72O010005000428012O00E72O010012CD0003002D3O000428012O00890201000428012O00E72O01002E12009200662O010091000428012O00662O01002679000300662O010001000428012O00662O010012CD000400013O002E120093005803010094000428012O00580301000E2F0001005803010004000428012O00580301002EB7009500E602010096000428012O00E602012O007A00056O0025000600013O00122O000700973O00122O000800986O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500E602013O000428012O00E602012O007A000500063O00060A000500E602013O000428012O00E602012O007A000500073O00060A000500E602013O000428012O00E602012O007A00056O0025000600013O00122O000700993O00122O0008009A6O0006000800024O00050005000600202O0005000500194O00050002000200062O000500E602013O000428012O00E602012O007A000500033O0020950005000500754O00075O00202O00070007009B4O0005000700024O000600183O00202O00060006002D00062O000500E602010006000428012O00E602012O007A00056O0013000600013O00122O0007009C3O00122O0008009D6O0006000800024O00050005000600202O0005000500264O0005000200024O000600183O00062O000500E602010006000428012O00E602012O007A000500053O00205C0005000500624O00075O00202O0007000700634O00050007000200062O000500E602013O000428012O00E602012O007A00056O0025000600013O00122O0007009E3O00122O0008009F6O0006000800024O00050005000600202O00050005001E4O00050002000200062O000500E602013O000428012O00E602012O007A000500044O008F00065O00202O0006000600294O000700053O00202O0007000700104O00095O00202O00090009002A4O0007000900024O000700076O00050007000200062O000500E102010001000428012O00E10201002E1200A100E6020100A0000428012O00E602012O007A000500013O0012CD000600A23O0012CD000700A34O0028000500074O006A00056O007A00056O0025000600013O00122O000700A43O00122O000800A56O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005004203013O000428012O004203012O007A000500063O00060A0005004203013O000428012O004203012O007A000500073O00060A0005004203013O000428012O004203012O007A00056O0025000600013O00122O000700A63O00122O000800A76O0006000800024O00050005000600202O0005000500194O00050002000200062O0005004203013O000428012O004203012O007A000500033O00205C00050005001F4O00075O00202O0007000700A84O00050007000200062O0005004203013O000428012O004203012O007A000500033O00205C00050005006B4O00075O00202O0007000700204O00050007000200062O0005004203013O000428012O004203012O007A000500033O00201501050005006B4O00075O00202O0007000700764O00050007000200062O0005003103010001000428012O003103012O007A00056O0021000600013O00122O000700A93O00122O000800AA6O0006000800024O00050005000600202O0005000500264O0005000200024O00068O000700013O00122O000800AB3O00122O000900AC6O0007000900024O00060006000700202O0006000600234O00060002000200062O0006004203010005000428012O004203012O007A00056O0025010600013O00122O000700AD3O00122O000800AE6O0006000800024O00050005000600202O0005000500264O000500020002000E2O0055004203010005000428012O004203012O007A000500053O00205C0005000500624O00075O00202O0007000700634O00050007000200062O0005004203013O000428012O004203012O007A00056O0063000600013O00122O000700AF3O00122O000800B06O0006000800024O00050005000600202O00050005001E4O00050002000200062O0005004403010001000428012O00440301002E1200B20057030100B1000428012O00570301002EF500B30013000100B3000428012O005703012O007A000500044O009000065O00202O0006000600294O000700053O00202O0007000700104O00095O00202O00090009002A4O0007000900024O000700076O00050007000200062O0005005703013O000428012O005703012O007A000500013O0012CD000600B43O0012CD000700B54O0028000500074O006A00055O0012CD000400053O0026790004008E02010005000428012O008E02010012CD000300053O000428012O00662O01000428012O008E0201000428012O00662O01000428012O00600301000428012O00612O01002EB700B600EB040100B7000428012O00EB0401002679000100EB04010068000428012O00EB04010012CD000200013O0026E10002006903010005000428012O00690301002E1200B800FA030100B9000428012O00FA03012O007A00036O0025000400013O00122O000500BA3O00122O000600BB6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300B803013O000428012O00B803012O007A0003001B3O00060A000300B803013O000428012O00B803012O007A000300033O0020F700030003000D00122O000500056O00065O00202O00060006000E4O00030006000200062O000300B803010001000428012O00B803012O007A000300033O0020C000030003003A2O0045010300020002000636000300B803010001000428012O00B803012O007A00036O0025000400013O00122O000500BC3O00122O000600BD6O0004000600024O00030003000400202O0003000300194O00030002000200062O000300B803013O000428012O00B803012O007A000300164O00070104001C6O00058O000600013O00122O000700BE3O00122O000800BF6O0006000800024O00050005000600202O0005000500194O000500066O00043O000200102O0004002D000400062O000400B803010003000428012O00B803012O007A000300053O00205C0003000300624O00055O00202O0005000500634O00030005000200062O000300B803013O000428012O00B803012O007A00036O0017000400013O00122O000500C03O00122O000600C16O0004000600024O00030003000400202O0003000300C24O0003000200024O000400183O00202O00040004006800062O000300B103010004000428012O00B103012O007A000300163O000E30010500B803010003000428012O00B803012O007A000300033O00207B00030003006D00122O0005006E3O00122O0006002D6O00030006000200062O000300BA03013O000428012O00BA0301002EF500C30013000100C4000428012O00CB03012O007A000300044O009000045O00202O00040004002A4O000500053O00202O0005000500104O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300CB03013O000428012O00CB03012O007A000300013O0012CD000400C53O0012CD000500C64O0028000300054O006A00036O007A00036O0025000400013O00122O000500C73O00122O000600C86O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300F903013O000428012O00F903012O007A0003001D3O00060A000300F903013O000428012O00F903012O007A000300163O000E04012D00F903010003000428012O00F903012O007A000300033O0020C00003000300C92O0045010300020002002615000300F9030100CA000428012O00F903012O007A000300053O00205C0003000300624O00055O00202O0005000500634O00030005000200062O000300F903013O000428012O00F90301002E1200CC00F9030100CB000428012O00F903012O007A000300044O00C800045O00202O0004000400CD4O000500053O00202O0005000500454O0007000E6O0005000700024O000500056O00030005000200062O000300F903013O000428012O00F903012O007A000300013O0012CD000400CE3O0012CD000500CF4O0028000300054O006A00035O0012CD0002002D3O002679000200430401002D000428012O004304012O007A00036O0025000400013O00122O000500D03O00122O000600D16O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003002704013O000428012O002704012O007A0003001E3O00060A0003002704013O000428012O002704012O007A000300093O0006360003002704010001000428012O002704012O007A00036O005A000400013O00122O000500D23O00122O000600D36O0004000600024O00030003000400202O0003000300264O000300020002000E2O0001002004010003000428012O002004012O007A00036O0063000400013O00122O000500D43O00122O000600D56O0004000600024O00030003000400202O0003000300194O00030002000200062O0003002704010001000428012O002704012O007A000300033O00201501030003001F4O00055O00202O0005000500324O00030005000200062O0003002E04010001000428012O002E04012O007A000300033O00207B00030003006D00122O0005003B3O00122O0006002D6O00030006000200062O0003004104013O000428012O004104012O007A000300044O008F00045O00202O0004000400D64O000500053O00202O0005000500104O00075O00202O0007000700D64O0005000700024O000500056O00030005000200062O0003003C04010001000428012O003C0401002EB700D80041040100D7000428012O004104012O007A000300013O0012CD000400D93O0012CD000500DA4O0028000300054O006A00035O0012CD000100553O000428012O00EB0401002E1200DB0065030100DC000428012O006503010026790002006503010001000428012O006503012O007A00036O0025000400013O00122O000500DD3O00122O000600DE6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003008404013O000428012O008404012O007A0003001F3O00060A0003008404013O000428012O008404012O007A0003001A3O00060A0003008404013O000428012O008404012O007A00036O005A000400013O00122O000500DF3O00122O000600E06O0004000600024O00030003000400202O0003000300264O000300020002000E2O0004007204010003000428012O007204012O007A00036O0025000400013O00122O000500E13O00122O000600E26O0004000600024O00030003000400202O0003000300194O00030002000200062O0003007204013O000428012O007204012O007A000300033O00207B00030003006D00122O0005006E3O00122O0006002D6O00030006000200062O0003008404013O000428012O00840401002E1200E30084040100E4000428012O008404012O007A000300044O00C800045O00202O0004000400E54O000500053O00202O0005000500454O0007000E6O0005000700024O000500056O00030005000200062O0003008404013O000428012O008404012O007A000300013O0012CD000400E63O0012CD000500E74O0028000300054O006A00036O007A00036O0025000400013O00122O000500E83O00122O000600E96O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300AA04013O000428012O00AA04012O007A000300033O0020C000030003003A2O0045010300020002000636000300AA04010001000428012O00AA04012O007A0003000B3O00060A000300AA04013O000428012O00AA04012O007A00036O0025000400013O00122O000500EA3O00122O000600EB6O0004000600024O00030003000400202O0003000300194O00030002000200062O000300AA04013O000428012O00AA04012O007A000300053O00205C0003000300624O00055O00202O0005000500634O00030005000200062O000300AA04013O000428012O00AA04012O007A000300163O000E1F015500AC04010003000428012O00AC0401002EB700EC00E9040100ED000428012O00E904012O007A0003000C4O0046000400013O00122O000500EE3O00122O000600EF6O00040006000200062O000300BF04010004000428012O00BF04012O007A00036O0063000400013O00122O000500F03O00122O000600F16O0004000600024O00030003000400202O0003000300194O00030002000200062O000300BF04010001000428012O00BF0401002E1200F200D0040100F3000428012O00D004012O007A000300044O00C80004000D3O00202O0004000400444O000500053O00202O0005000500454O0007000E6O0005000700024O000500056O00030005000200062O000300E904013O000428012O00E904012O007A000300013O0012D9000400F43O00122O000500F56O000300056O00035O00044O00E904012O007A0003000C4O00DF000400013O00122O000500F63O00122O000600F76O00040006000200062O000300E904010004000428012O00E904012O007A000300044O00830004000D3O00202O00040004004C4O000500053O00202O00050005004500122O0007000C6O0005000700024O000500056O00030005000200062O000300E404010001000428012O00E40401002EB700F800E9040100F9000428012O00E904012O007A000300013O0012CD000400FA3O0012CD000500FB4O0028000300054O006A00035O0012CD000200053O000428012O006503010026E1000100EF0401002D000428012O00EF0401002E1200FD00BA060100FC000428012O00BA06010012CD000200013O002EB700FF00AF050100FE000428012O00AF0501002679000200AF0501002D000428012O00AF05010012CD0003002O012O000E30010001AD05010003000428012O00AD05012O007A00036O0025000400013O00122O00050002012O00122O00060003015O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300AD05013O000428012O00AD05012O007A000300203O00060A000300AD05013O000428012O00AD05012O007A000300033O0020F700030003000D00122O000500056O00065O00202O00060006000E4O00030006000200062O000300AD05010001000428012O00AD05012O007A000300053O00205C0003000300624O00055O00202O0005000500634O00030005000200062O0003009805013O000428012O009805012O007A00036O00EF000400013O00122O00050004012O00122O00060005015O0004000600024O00030003000400202O0003000300264O0003000200024O0004001C6O00058O000600013O00122O00070006012O00122O00080007015O0006000800024O00050005000600202O0005000500194O000500066O00043O000200122O00050008015O00040004000500122O0005003B6O00040005000400062O0004004F05010003000428012O004F05012O007A00036O0067000400013O00122O00050009012O00122O0006000A015O0004000600024O00030003000400202O0003000300264O0003000200024O000400183O00122O0005002D6O00040004000500062O0003009805010004000428012O009805012O007A00036O0025000400013O00122O0005000B012O00122O0006000C015O0004000600024O00030003000400202O0003000300194O00030002000200062O0003004F05013O000428012O004F05012O007A00036O0067000400013O00122O0005000D012O00122O0006000E015O0004000600024O00030003000400202O0003000300264O0003000200024O000400183O00122O0005000F015O00040004000500062O0003009805010004000428012O009805012O007A000300033O00201501030003001F4O00055O00202O0005000500764O00030005000200062O0003006805010001000428012O006805012O007A000300033O00208B0003000300754O00055O00202O0005000500764O0003000500024O000400183O00062O0004006805010003000428012O006805012O007A00036O0063000400013O00122O00050010012O00122O00060011015O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009805010001000428012O009805012O007A00036O0063000400013O00122O00050012012O00122O00060013015O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009005010001000428012O009005012O007A00036O0025000400013O00122O00050014012O00122O00060015015O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009005013O000428012O009005012O007A00036O00F0000400013O00122O00050016012O00122O00060017015O0004000600024O00030003000400202O0003000300264O00030002000200122O000400043O00062O0004009005010003000428012O009005012O007A000300213O00060A0003009005013O000428012O009005012O007A000300153O0020450003000300642O008D0003000100020012CD000400653O00064F0103009805010004000428012O009805012O007A000300033O0020C900030003001F4O00055O00122O00060018015O0005000500064O00030005000200062O0003009C05010001000428012O009C05012O007A000300123O0012CD00040008012O00064F010300AD05010004000428012O00AD05012O007A000300044O003A01045O00122O00050019015O0004000400054O000500053O00202O0005000500454O0007000E6O0005000700024O000500056O00030005000200062O000300AD05013O000428012O00AD05012O007A000300013O0012CD0004001A012O0012CD0005001B013O0028000300054O006A00035O0012CD000100683O000428012O00BA06010012CD000300013O0006FF000200B605010003000428012O00B605010012CD0003001C012O0012CD0004001D012O00064D0103002706010004000428012O002706010012CD000300013O0012CD000400013O0006370103001D06010004000428012O001D06012O007A00046O0025000500013O00122O0006001E012O00122O0007001F015O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400EC05013O000428012O00EC05012O007A000400223O00060A000400EC05013O000428012O00EC05012O007A000400163O0012CD000500053O000611000500DC05010004000428012O00DC05012O007A000400163O0012CD000500053O000637010400EC05010005000428012O00EC05012O007A000400033O0020C000040004000B2O00450104000200020012CD00050020012O00064F010400EC05010005000428012O00EC05012O007A000400033O00205C00040004001F4O00065O00202O0006000600764O00040006000200062O000400EC05013O000428012O00EC05012O007A000400044O00C800055O00202O0005000500324O000600053O00202O0006000600454O0008000E6O0006000800024O000600066O00040006000200062O000400EC05013O000428012O00EC05012O007A000400013O0012CD00050021012O0012CD00060022013O0028000400064O006A00046O007A00046O0025000500013O00122O00060023012O00122O00070024015O0005000700024O00040004000500202O0004000400314O00040002000200062O0004001C06013O000428012O001C06012O007A000400233O00060A0004001C06013O000428012O001C06012O007A000400053O0020150104000400624O00065O00202O0006000600634O00040006000200062O0004000406010001000428012O000406012O007A000400163O0012CD000500053O00064F0105001C06010004000428012O001C06012O007A000400033O00205C00040004001F4O00065O00202O0006000600324O00040006000200062O0004001C06013O000428012O001C06012O007A000400044O003A01055O00122O00060025015O0005000500064O000600053O00202O0006000600454O0008000E6O0006000800024O000600066O00040006000200062O0004001C06013O000428012O001C06012O007A000400013O0012CD00050026012O0012CD00060027013O0028000400064O006A00045O0012CD000300053O0012CD00040028012O0012CD00050029012O00064F010400B705010005000428012O00B705010012CD000400053O000637010400B705010003000428012O00B705010012CD000200053O000428012O00270601000428012O00B705010012CD000300053O000637010200F004010003000428012O00F004012O007A00036O0025000400013O00122O0005002A012O00122O0006002B015O0004000600024O00030003000400202O0003000300314O00030002000200062O0003006906013O000428012O006906012O007A0003001E3O00060A0003006906013O000428012O006906012O007A000300033O00200901030003006B4O00055O00122O00060018015O0005000500064O00030005000200062O0003006906013O000428012O006906012O007A00036O00E9000400013O00122O0005002C012O00122O0006002D015O0004000600024O00030003000400202O0003000300264O0003000200024O000400033O00122O0006002E015O0004000400062O004501040002000200064D0103006906010004000428012O006906012O007A000300033O00205C00030003001F4O00055O00202O0005000500324O00030005000200062O0003006906013O000428012O006906010012CD0003002F012O0012CD00040030012O00064D0103006906010004000428012O006906012O007A000300044O009000045O00202O0004000400D64O000500053O00202O0005000500104O00075O00202O0007000700D64O0005000700024O000500056O00030005000200062O0003006906013O000428012O006906012O007A000300013O0012CD00040031012O0012CD00050032013O0028000300054O006A00036O007A00036O0025000400013O00122O00050033012O00122O00060034015O0004000600024O00030003000400202O0003000300314O00030002000200062O0003009F06013O000428012O009F06012O007A000300063O00060A0003009F06013O000428012O009F06012O007A000300073O00060A0003009F06013O000428012O009F06012O007A00036O0025000400013O00122O00050035012O00122O00060036015O0004000600024O00030003000400202O0003000300194O00030002000200062O0003009F06013O000428012O009F06012O007A00036O0067000400013O00122O00050037012O00122O00060038015O0004000600024O00030003000400202O0003000300264O0003000200024O000400183O00122O000500686O00040004000500062O0003009F06010004000428012O009F06012O007A000300033O00205F0003000300754O00055O00202O00050005009B4O00030005000200122O000400043O00062O0003009F06010004000428012O009F06012O007A000300033O00201501030003001F4O00055O00202O0005000500764O00030005000200062O000300A306010001000428012O00A306010012CD00030039012O0012CD0004003A012O00064F010400B806010003000428012O00B806012O007A000300044O008F00045O00202O0004000400294O000500053O00202O0005000500104O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300B306010001000428012O00B306010012CD0003003B012O0012CD0004003C012O000637010300B806010004000428012O00B806012O007A000300013O0012CD0004003D012O0012CD0005003E013O0028000300054O006A00035O0012CD0002002D3O000428012O00F004010012CD000200013O0006372O01007509010002000428012O007509010012CD000200014O00DA000300033O0012CD000400013O000637010200BF06010004000428012O00BF06010012CD000300013O0012CD000400053O0006370103005008010004000428012O005008010012CD000400013O0012CD000500013O0006370105004A08010004000428012O004A08012O007A00056O0025000600013O00122O0007003F012O00122O00080040015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005007907013O000428012O007907012O007A000500063O00060A0005007907013O000428012O007907012O007A000500213O00060A0005007907013O000428012O007907012O007A00056O001E000600013O00122O00070041012O00122O00080042015O0006000800024O00050005000600122O00070043015O0005000500074O00050002000200122O000600013O00062O0006007907010005000428012O007907012O007A00056O0025000600013O00122O00070044012O00122O00080045015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005007907013O000428012O007907012O007A00056O0025000600013O00122O00070046012O00122O00080047015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005007907013O000428012O007907012O007A000500153O0020450005000500642O008D0005000100020012CD000600053O00064F0106007907010005000428012O007907012O007A00056O00F0000600013O00122O00070048012O00122O00080049015O0006000800024O00050005000600202O0005000500264O00050002000200122O00060008012O00062O0006003F07010005000428012O003F07012O007A00056O00E3000600013O00122O0007004A012O00122O0008004B015O0006000800024O00050005000600202O0005000500264O0005000200024O000600183O00062O0005007907010006000428012O007907012O007A00056O0025000600013O00122O0007004C012O00122O0008004D015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005003F07013O000428012O003F07012O007A000500033O00201501050005006B4O00075O00202O0007000700764O00050007000200062O0005003F07010001000428012O003F07012O007A00056O0052000600013O00122O0007004E012O00122O0008004F015O0006000800024O00050005000600202O0005000500264O0005000200024O0006001C6O00078O000800013O00122O00090050012O00122O000A0051015O0008000A00024O00070007000800202O0007000700194O000700086O00063O000200122O000700656O00060007000600122O00070008015O00060007000600062O0006007907010005000428012O007907012O007A000500153O0020450005000500642O008D0005000100020012CD0006003B3O0006110005004E07010006000428012O004E07012O007A000500033O00129B00070052015O0005000500074O00050002000200122O000600056O00050005000600122O000600013O00062O0005007907010006000428012O007907012O007A00056O0025000600013O00122O00070053012O00122O00080054015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005006707013O000428012O006707012O007A000500033O00209A0005000500754O00075O00122O00080055015O0007000700084O0005000700024O000600183O00062O0005006707010006000428012O006707012O007A000500153O0020450005000500642O008D0005000100020012CD000600553O00064F0106007907010005000428012O007907012O007A000500044O007700065O00202O00060006000E4O000700053O00202O0007000700454O0009000E6O0007000900024O000700076O000800086O000900016O00050009000200062O0005007907013O000428012O007907012O007A000500013O0012CD00060056012O0012CD00070057013O0028000500074O006A00055O0012CD00050058012O0012CD00060058012O0006370105004908010006000428012O004908012O007A00056O0025000600013O00122O00070059012O00122O0008005A015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005004908013O000428012O004908012O007A000500063O00060A0005004908013O000428012O004908012O007A000500213O00060A0005004908013O000428012O004908012O007A00056O001E000600013O00122O0007005B012O00122O0008005C015O0006000800024O00050005000600122O00070043015O0005000500074O00050002000200122O000600013O00062O0006004908010005000428012O004908012O007A00056O0025000600013O00122O0007005D012O00122O0008005E015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005004908013O000428012O004908012O007A00056O0025000600013O00122O0007005F012O00122O00080060015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005004908013O000428012O004908012O007A000500153O0020450005000500642O008D0005000100020012CD000600053O00064F0106004908010005000428012O004908012O007A00056O00F0000600013O00122O00070061012O00122O00080062015O0006000800024O00050005000600202O0005000500264O00050002000200122O00060008012O00062O0006002508010005000428012O002508012O007A00056O0067000600013O00122O00070063012O00122O00080064015O0006000800024O00050005000600202O0005000500264O0005000200024O000600183O00122O0007002D6O00060006000700062O0005004908010006000428012O004908012O007A000500033O0020730005000500754O00075O00122O00080055015O0007000700084O0005000700024O000600183O00062O000500EB07010006000428012O00EB07012O007A000500243O000636000500EB07010001000428012O00EB07012O007A00056O00E9000600013O00122O00070065012O00122O00080066015O0006000800024O00050005000600202O0005000500264O0005000200024O000600033O00122O00080052015O0006000600082O004501060002000200064D010500EB07010006000428012O00EB07012O007A000500033O0020C00005000500C92O00450105000200020012CD0006003B3O0006110006002508010005000428012O002508012O007A00056O0025000600013O00122O00070067012O00122O00080068015O0006000800024O00050005000600202O0005000500194O00050002000200062O0005002508013O000428012O002508012O007A000500033O00201501050005006B4O00075O00202O0007000700764O00050007000200062O0005002508010001000428012O002508012O007A00056O004D000600013O00122O00070069012O00122O0008006A015O0006000800024O00050005000600202O0005000500264O0005000200024O000600253O00122O00070008015O0008001C4O007A00096O001B010A00013O00122O000B006B012O00122O000C006C015O000A000C00024O00090009000A00202O0009000900194O0009000A6O00083O000200122O000900656O0008000900082O00240006000800022O004F000700263O00122O00080008015O0009001C6O000A8O000B00013O00122O000C006B012O00122O000D006C015O000B000D00024O000A000A000B00202O000A000A00192O0003000A000B4O000D00093O000200122O000A00656O0009000A00094O0007000900024O00060006000700062O0006004908010005000428012O004908012O007A000500033O00201501050005001F4O00075O00202O0007000700204O00050007000200062O0005003308010001000428012O003308012O007A000500033O00205C00050005006B4O00075O00202O0007000700A84O00050007000200062O0005004908013O000428012O004908010012CD0005006D012O0012CD0006006E012O00064D0106004908010005000428012O004908012O007A000500044O007700065O00202O00060006000E4O000700053O00202O0007000700454O0009000E6O0007000900024O000700076O000800086O000900016O00050009000200062O0005004908013O000428012O004908012O007A000500013O0012CD0006006F012O0012CD00070070013O0028000500074O006A00055O0012CD000400053O0012CD000500053O000637010500C706010004000428012O00C706010012CD0003002D3O000428012O00500801000428012O00C706010012CD0004002D3O000637010300D408010004000428012O00D408010012CD00040071012O0012CD00050071012O000637010400D208010005000428012O00D208012O007A00046O0025000500013O00122O00060072012O00122O00070073015O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400D208013O000428012O00D208012O007A000400063O00060A000400D208013O000428012O00D208012O007A000400213O00060A000400D208013O000428012O00D208012O007A00046O001E000500013O00122O00060074012O00122O00070075015O0005000700024O00040004000500122O00060043015O0004000400064O00040002000200122O000500013O00062O000500D208010004000428012O00D208012O007A00046O0025000500013O00122O00060076012O00122O00070077015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400D208013O000428012O00D208012O007A00046O0063000500013O00122O00060078012O00122O00070079015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400D208010001000428012O00D208012O007A000400153O0020450004000400642O008D0004000100020012CD000500053O00064F010500D208010004000428012O00D208012O007A000400033O0020C900040004001F4O00065O00122O00070055015O0006000600074O00040006000200062O000400B208010001000428012O00B208012O007A000400033O00200F01040004000D00122O000600056O00075O00202O00070007008E4O00040007000200062O000400D208013O000428012O00D208012O007A00046O0051010500013O00122O0006007A012O00122O0007007B015O0005000700024O00040004000500122O0006007C015O0004000400064O00040002000200062O000400D208013O000428012O00D208012O007A00046O0025000500013O00122O0006007D012O00122O0007007E015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400D208013O000428012O00D208012O007A00046O0025000500013O00122O0006007F012O00122O00070080015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400D208013O000428012O00D208012O007A000400044O002600055O00202O00050005000E4O000600053O00202O0006000600454O0008000E6O0006000800024O000600066O000700076O000800016O000400080002000636000400CD08010001000428012O00CD08010012CD00040081012O0012CD00050082012O00064D010400D208010005000428012O00D208012O007A000400013O0012CD00050083012O0012CD00060084013O0028000400064O006A00045O0012CD000100053O000428012O007509010012CD000400013O0006FF000400DB08010003000428012O00DB08010012CD00040085012O0012CD00050086012O00064D010500C306010004000428012O00C306012O007A00046O0025000500013O00122O00060087012O00122O00070088015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004001109013O000428012O001109012O007A0004001E3O00060A0004001109013O000428012O001109012O007A000400033O00200901040004006B4O00065O00122O00070018015O0006000600074O00040006000200062O0004001109013O000428012O001109012O007A00046O00E9000500013O00122O00060089012O00122O0007008A015O0005000700024O00040004000500202O0004000400264O0004000200024O000500033O00122O0007002E015O0005000500072O00450105000200020012CD000600684O001D00050005000600064D0104001109010005000428012O001109012O007A000400044O009000055O00202O0005000500D64O000600053O00202O0006000600104O00085O00202O0008000800D64O0006000800024O000600066O00040006000200062O0004001109013O000428012O001109012O007A000400013O0012CD0005008B012O0012CD0006008C013O0028000400064O006A00046O007A00046O0025000500013O00122O0006008D012O00122O0007008E015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004007109013O000428012O007109012O007A000400063O00060A0004007109013O000428012O007109012O007A000400213O00060A0004007109013O000428012O007109012O007A00046O001E000500013O00122O0006008F012O00122O00070090015O0005000700024O00040004000500122O00060043015O0004000400064O00040002000200122O000500013O00062O0005007109010004000428012O007109012O007A00046O00DE000500013O00122O00060091012O00122O00070092015O0005000700024O00040004000500202O0004000400264O00040002000200122O00050093012O00062O0004007109010005000428012O007109012O007A00046O0067000500013O00122O00060094012O00122O00070095015O0005000700024O00040004000500202O0004000400264O0004000200024O000500183O00122O0006002D6O00050005000600062O0004007109010005000428012O007109012O007A000400153O0020450004000400642O008D0004000100020012CD000500043O00064F0105007109010004000428012O007109012O007A000400033O0020C00004000400C92O00450104000200020012CD0005003B3O00064D0105007109010004000428012O007109012O007A00046O0025000500013O00122O00060096012O00122O00070097015O0005000700024O00040004000500202O0004000400194O00040002000200062O0004007109013O000428012O007109012O007A000400044O002600055O00202O00050005000E4O000600053O00202O0006000600454O0008000E6O0006000800024O000600066O000700076O000800016O0004000800020006360004006C09010001000428012O006C09010012CD00040098012O0012CD00050099012O00064F0104007109010005000428012O007109012O007A000400013O0012CD0005009A012O0012CD0006009B013O0028000400064O006A00045O0012CD000300053O000428012O00C30601000428012O00750901000428012O00BF06010012CD000200593O0006FF0001007C09010002000428012O007C09010012CD0002009C012O0012CD0003009D012O000637010200C20A010003000428012O00C20A010012CD000200013O0012CD000300053O0006FF0002008409010003000428012O008409010012CD0003009E012O0012CD0004009F012O000637010300DE09010004000428012O00DE09012O007A00036O0025000400013O00122O000500A0012O00122O000600A1015O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300A209013O000428012O00A209012O007A0003000F3O00060A000300A209013O000428012O00A209012O007A000300044O009000045O00202O0004000400564O000500053O00202O0005000500104O00075O00202O0007000700564O0005000700024O000500056O00030005000200062O000300A209013O000428012O00A209012O007A000300013O0012CD000400A2012O0012CD000500A3013O0028000300054O006A00036O007A00036O0025000400013O00122O000500A4012O00122O000600A5015O0004000600024O00030003000400202O0003000300314O00030002000200062O000300C409013O000428012O00C409012O007A000300063O00060A000300C409013O000428012O00C409012O007A000300073O00060A000300C409013O000428012O00C409012O007A00036O0063000400013O00122O000500A6012O00122O000600A7015O0004000600024O00030003000400202O0003000300194O00030002000200062O000300C409010001000428012O00C409012O007A000300033O00205E0003000300754O00055O00202O00050005009B4O00030005000200122O00040020012O00062O0003000500010004000428012O00C809010012CD000300A8012O0012CD000400A9012O000637010300DD09010004000428012O00DD09012O007A000300044O008F00045O00202O0004000400294O000500053O00202O0005000500104O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300D809010001000428012O00D809010012CD000300AA012O0012CD000400AB012O00064F010400DD09010003000428012O00DD09012O007A000300013O0012CD000400AC012O0012CD000500AD013O0028000300054O006A00035O0012CD0002002D3O0012CD000300AE012O0012CD000400AF012O00064D0103001C0A010004000428012O001C0A010012CD0003002D3O0006370102001C0A010003000428012O001C0A012O007A00036O0025000400013O00122O000500B0012O00122O000600B1015O0004000600024O00030003000400202O0003000300314O00030002000200062O0003001A0A013O000428012O001A0A012O007A000300063O00060A0003001A0A013O000428012O001A0A012O007A000300073O00060A0003001A0A013O000428012O001A0A012O007A000300053O0020C00003000300452O007A0005000E4O00240003000500020006360003001A0A010001000428012O001A0A012O007A00036O0063000400013O00122O000500B2012O00122O000600B3015O0004000600024O00030003000400202O0003000300194O00030002000200062O0003001A0A010001000428012O001A0A012O007A000300044O008F00045O00202O0004000400294O000500053O00202O0005000500104O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300150A010001000428012O00150A010012CD000300B4012O0012CD000400B5012O0006370103001A0A010004000428012O001A0A012O007A000300013O0012CD000400B6012O0012CD000500B7013O0028000300054O006A00035O0012CD000100B8012O000428012O00C20A010012CD000300013O0006FF000200230A010003000428012O00230A010012CD000300B9012O0012CD000400BA012O00064D0103007D09010004000428012O007D09012O007A00036O0025000400013O00122O000500BB012O00122O000600BC015O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300520A013O000428012O00520A012O007A000300063O00060A000300520A013O000428012O00520A012O007A000300073O00060A000300520A013O000428012O00520A012O007A00036O0063000400013O00122O000500BD012O00122O000600BE015O0004000600024O00030003000400202O0003000300194O00030002000200062O000300520A010001000428012O00520A012O007A00036O0063000400013O00122O000500BF012O00122O000600C0015O0004000600024O00030003000400202O0003000300194O00030002000200062O000300520A010001000428012O00520A012O007A000300163O0012CD000400053O00064F010400520A010003000428012O00520A012O007A000300033O00201501030003001F4O00055O00202O0005000500204O00030005000200062O000300560A010001000428012O00560A010012CD000300C1012O0012CD000400C2012O00064D010300670A010004000428012O00670A012O007A000300044O009000045O00202O0004000400294O000500053O00202O0005000500104O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300670A013O000428012O00670A012O007A000300013O0012CD000400C3012O0012CD000500C4013O0028000300054O006A00036O007A00036O0025000400013O00122O000500C5012O00122O000600C6015O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300C00A013O000428012O00C00A012O007A000300033O0020C000030003003A2O0045010300020002000636000300C00A010001000428012O00C00A012O007A000300033O0020C000030003000B2O00450103000200020012CD0004003B3O00064D010400C00A010003000428012O00C00A012O007A000300053O0020C00003000300450012CD0005003B4O002400030005000200060A000300C00A013O000428012O00C00A012O007A0003000C4O0046000400013O00122O000500C7012O00122O000600C8015O00040006000200062O000300970A010004000428012O00970A012O007A00036O0063000400013O00122O000500C9012O00122O000600CA015O0004000600024O00030003000400202O0003000300194O00030002000200062O000300970A010001000428012O00970A010012CD000300CB012O0012CD000400CC012O00064D010400A80A010003000428012O00A80A012O007A000300044O00C80004000D3O00202O0004000400444O000500053O00202O0005000500454O0007000E6O0005000700024O000500056O00030005000200062O000300C00A013O000428012O00C00A012O007A000300013O0012D9000400CD012O00122O000500CE015O000300056O00035O00044O00C00A012O007A0003000C4O0046000400013O00122O000500CF012O00122O000600D0015O00040006000200062O000300B00A010004000428012O00B00A01000428012O00C00A012O007A000300044O002B0104000D3O00202O00040004004C4O000500053O00202O00050005004500122O0007003B6O0005000700024O000500056O00030005000200062O000300C00A013O000428012O00C00A012O007A000300013O0012CD000400D1012O0012CD000500D2013O0028000300054O006A00035O0012CD000200053O000428012O007D09010012CD000200553O0006FF000100C90A010002000428012O00C90A010012CD000200FC3O0012CD000300D3012O00064D010300CB0C010002000428012O00CB0C010012CD000200014O00DA000300033O0012CD000400013O0006FF000400D20A010002000428012O00D20A010012CD000400D4012O0012CD000500D5012O00064D010500CB0A010004000428012O00CB0A010012CD000300013O0012CD0004002D3O0006FF000300DA0A010004000428012O00DA0A010012CD000400D6012O0012CD000500D7012O00064D0105003C0B010004000428012O003C0B010012CD000400D8012O0012CD000500D9012O00064F0105003A0B010004000428012O003A0B012O007A00046O0025000500013O00122O000600DA012O00122O000700DB015O0005000700024O00040004000500202O0004000400314O00040002000200062O0004003A0B013O000428012O003A0B012O007A0004001B3O00060A0004003A0B013O000428012O003A0B012O007A000400033O0020F700040004000D00122O000600056O00075O00202O00070007000E4O00040007000200062O0004003A0B010001000428012O003A0B012O007A000400033O0020C000040004003A2O00450104000200020006360004003A0B010001000428012O003A0B012O007A00046O0025000500013O00122O000600DC012O00122O000700DD015O0005000700024O00040004000500202O0004000400194O00040002000200062O0004003A0B013O000428012O003A0B012O007A00046O0021000500013O00122O000600DE012O00122O000700DF015O0005000700024O00040004000500202O0004000400C24O0004000200024O00058O000600013O00122O000700E0012O00122O000800E1015O0006000800024O00050005000600202O0005000500264O00050002000200062O0004003A0B010005000428012O003A0B012O007A000400033O00207B00040004006D00122O0006006E3O00122O0007002D6O00040007000200062O0004003A0B013O000428012O003A0B012O007A000400033O00205C00040004001F4O00065O00202O0006000600324O00040006000200062O0004003A0B013O000428012O003A0B012O007A0004000A3O0006360004003A0B010001000428012O003A0B010012CD000400E2012O0012CD000500E2012O0006370104003A0B010005000428012O003A0B012O007A000400044O009000055O00202O00050005002A4O000600053O00202O0006000600104O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O0004003A0B013O000428012O003A0B012O007A000400013O0012CD000500E3012O0012CD000600E4013O0028000400064O006A00045O0012CD000100043O000428012O00CB0C010012CD000400B73O0012CD000500E5012O00064D0105000A0C010004000428012O000A0C010012CD000400053O0006370103000A0C010004000428012O000A0C012O007A00046O0025000500013O00122O000600E6012O00122O000700E7015O0005000700024O00040004000500202O0004000400314O00040002000200062O000400950B013O000428012O00950B012O007A0004001B3O00060A000400950B013O000428012O00950B012O007A000400033O0020F700040004000D00122O000600056O00075O00202O00070007000E4O00040007000200062O000400950B010001000428012O00950B012O007A000400033O0020C000040004003A2O0045010400020002000636000400950B010001000428012O00950B012O007A00046O0025000500013O00122O000600E8012O00122O000700E9015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400950B013O000428012O00950B012O007A000400274O00060105001C6O00068O000700013O00122O000800EA012O00122O000900EB015O0007000900024O00060006000700202O0006000600194O000600076O00053O00020012CD0006002D4O00D100050006000500064D010500950B010004000428012O00950B012O007A000400053O00205C0004000400624O00065O00202O0006000600634O00040006000200062O000400950B013O000428012O00950B012O007A000400033O00206200040004006D00122O0006006E3O00122O0007002D6O00040007000200062O000400950B010001000428012O00950B012O007A000400044O009000055O00202O00050005002A4O000600053O00202O0006000600104O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400950B013O000428012O00950B012O007A000400013O0012CD000500EC012O0012CD000600ED013O0028000400064O006A00045O0012CD000400EE012O0012CD000500EF012O00064D010500090C010004000428012O00090C012O007A00046O0025000500013O00122O000600F0012O00122O000700F1015O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400090C013O000428012O00090C012O007A0004001D3O00060A000400090C013O000428012O00090C012O007A000400033O001216010600F2015O0004000400064O00065O00122O000700F3015O0006000600074O0004000600024O000500283O00062O000400090C010005000428012O00090C012O007A000400053O0020C00004000400450012CD000600F4013O002400040006000200060A000400090C013O000428012O00090C012O007A000400033O00201501040004001F4O00065O00202O0006000600204O00040006000200062O000400C70B010001000428012O00C70B012O007A00046O0063000500013O00122O000600F5012O00122O000700F6015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400090C010001000428012O00090C012O007A00046O0027010500013O00122O000600F7012O00122O000700F8015O0005000700024O00040004000500202O0004000400234O0004000200024O00058O000600013O00122O000700F9012O00122O000800FA015O0006000800024O00050005000600202O0005000500264O00050002000200062O000400F50B010005000428012O00F50B012O007A00046O0063000500013O00122O000600FB012O00122O000700FC015O0005000700024O00040004000500202O0004000400194O00040002000200062O000400090C010001000428012O00090C012O007A00046O0021000500013O00122O000600FD012O00122O000700FE015O0005000700024O00040004000500202O0004000400264O0004000200024O00058O000600013O00122O000700FF012O00122O00082O00025O0006000800024O00050005000600202O0005000500234O00050002000200062O000500090C010004000428012O00090C012O007A000400044O008800055O00202O0005000500CD4O000600053O00202O0006000600454O0008000E6O0006000800024O000600066O00040006000200062O000400040C010001000428012O00040C010012CD00040001022O0012CD0005002O022O00064D010500090C010004000428012O00090C012O007A000400013O0012CD00050003022O0012CD00060004023O0028000400064O006A00045O0012CD0003002D3O0012CD000400013O000637010300D30A010004000428012O00D30A012O007A00046O0025000500013O00122O00060005022O00122O00070006025O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004005F0C013O000428012O005F0C012O007A000400023O00060A0004005F0C013O000428012O005F0C012O007A000400033O0020F700040004000D00122O000600056O00075O00202O00070007000E4O00040007000200062O0004005F0C010001000428012O005F0C012O007A000400033O0020C000040004000B2O00450104000200020012CD0005000C3O00064D010500390C010004000428012O00390C012O007A00046O0025000500013O00122O00060007022O00122O00070008025O0005000700024O00040004000500202O0004000400194O00040002000200062O000400390C013O000428012O00390C012O007A000400053O0020150104000400624O00065O00202O0006000600634O00040006000200062O0004004A0C010001000428012O004A0C012O007A00046O0025000500013O00122O00060009022O00122O0007000A025O0005000700024O00040004000500202O0004000400194O00040002000200062O0004005F0C013O000428012O005F0C012O007A000400053O00205C0004000400624O00065O00202O0006000600634O00040006000200062O0004005F0C013O000428012O005F0C012O007A000400044O008F00055O00202O00050005000F4O000600053O00202O0006000600104O00085O00202O00080008000F4O0006000800024O000600066O00040006000200062O0004005A0C010001000428012O005A0C010012CD0004000B022O0012CD0005000C022O00064F0105005F0C010004000428012O005F0C012O007A000400013O0012CD0005000D022O0012CD0006000E023O0028000400064O006A00046O007A00046O0025000500013O00122O0006000F022O00122O00070010025O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400C70C013O000428012O00C70C012O007A000400033O0020C000040004003A2O0045010400020002000636000400C70C010001000428012O00C70C012O007A0004000B3O00060A000400C70C013O000428012O00C70C012O007A00046O0025000500013O00122O00060011022O00122O00070012025O0005000700024O00040004000500202O0004000400194O00040002000200062O000400C70C013O000428012O00C70C012O007A000400033O0020C000040004000B2O00450104000200020012CD0005003B3O00064D010500C70C010004000428012O00C70C012O007A0004000C4O0046000500013O00122O00060013022O00122O00070014025O00050007000200062O000400920C010005000428012O00920C012O007A00046O0025000500013O00122O00060015022O00122O00070016025O0005000700024O00040004000500202O0004000400194O00040002000200062O000400A70C013O000428012O00A70C012O007A000400044O00880005000D3O00202O0005000500444O000600053O00202O0006000600454O0008000E6O0006000800024O000600066O00040006000200062O000400A10C010001000428012O00A10C010012CD00040017022O0012CD00050018022O00064F010400C70C010005000428012O00C70C012O007A000400013O0012D900050019022O00122O0006001A025O000400066O00045O00044O00C70C010012CD0004001B022O0012CD0005001B022O000637010400B30C010005000428012O00B30C012O007A0004000C4O0046000500013O00122O0006001C022O00122O0007001D025O00050007000200062O000400B30C010005000428012O00B30C01000428012O00C70C010012CD0004001E022O0012CD0005001F022O00064D010400C70C010005000428012O00C70C012O007A000400044O002B0105000D3O00202O00050005004C4O000600053O00202O00060006004500122O0008000C6O0006000800024O000600066O00040006000200062O000400C70C013O000428012O00C70C012O007A000400013O0012CD00050020022O0012CD00060021023O0028000400064O006A00045O0012CD000300053O000428012O00D30A01000428012O00CB0C01000428012O00CB0A010012CD000200B8012O0006FF000100D20C010002000428012O00D20C010012CD00020022022O0012CD00030023022O00064D0103000500010002000428012O000500012O007A00026O0025000300013O00122O00040024022O00122O00050025025O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200FE0C013O000428012O00FE0C012O007A000200063O00060A000200FE0C013O000428012O00FE0C012O007A000200213O00060A000200FE0C013O000428012O00FE0C012O007A00026O001E000300013O00122O00040026022O00122O00050027025O0003000500024O00020002000300122O00040043015O0002000200044O00020002000200122O000300013O00062O000300FE0C010002000428012O00FE0C012O007A00026O0063000300013O00122O00040028022O00122O00050029025O0003000500024O00020002000300202O0002000200194O00020002000200062O000200FE0C010001000428012O00FE0C012O007A000200053O0020C00002000200452O007A0004000E4O002400020004000200060A000200020D013O000428012O00020D010012CD0002002A022O0012CD0003002B022O00064D010300180D010002000428012O00180D010012CD0002002C022O0012CD0003002D022O00064D010200180D010003000428012O00180D012O007A000200044O007700035O00202O00030003000E4O000400053O00202O0004000400454O0006000E6O0004000600024O000400046O000500056O000600016O00020006000200062O000200180D013O000428012O00180D012O007A000200013O0012CD0003002E022O0012CD0004002F023O0028000200044O006A00026O007A00026O0025000300013O00122O00040030022O00122O00050031025O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200700D013O000428012O00700D012O007A0002001B3O00060A000200700D013O000428012O00700D012O007A000200033O0020F700020002000D00122O000400056O00055O00202O00050005000E4O00020005000200062O000200700D010001000428012O00700D012O007A000200033O0020C000020002003A2O0045010200020002000636000200700D010001000428012O00700D012O007A00026O0063000300013O00122O00040032022O00122O00050033025O0003000500024O00020002000300202O0002000200194O00020002000200062O000200420D010001000428012O00420D012O007A000200053O0020C00002000200450012CD00040034023O0024000200040002000636000200700D010001000428012O00700D012O007A000200053O00205C0002000200624O00045O00202O0004000400634O00020004000200062O000200700D013O000428012O00700D012O007A000200053O00205C0002000200104O00045O00202O00040004002A4O00020004000200062O000200700D013O000428012O00700D012O007A000200033O00206200020002006D00122O0004006E3O00122O0005002D6O00020005000200062O000200700D010001000428012O00700D012O007A000200044O008F00035O00202O00030003002A4O000400053O00202O0004000400104O00065O00202O00060006002A4O0004000600024O000400046O00020004000200062O000200670D010001000428012O00670D010012CD00020035022O0012CD00030036022O00064D010200700D010003000428012O00700D012O007A000200013O0012D900030037022O00122O00040038025O000200046O00025O00044O00700D01000428012O00050001000428012O00700D01000428012O000200012O003A3O00017O008E3O00028O00025O00DCA240026O00F03F030C3O004570696353652O74696E677303083O00600E6067335D0C6703053O005A336B1413030F3O0098E380CC3283E390E238A0F182E63E03053O005DED90E58F03083O0026F3E40D024812E503063O0026759690796B030D3O0038A8EB1E28BAFA321EACEB3F3D03043O005A4DDB8E025O00C0984003083O00D501352D45097DF503073O001A866441592C67030D3O00E4F03507A1FCEC3E3086F8F73503053O00C491835043027O0040025O00DAA140025O0032A040026O001440025O009CA640025O00DEA54003083O000B370797313C149003043O00E358527303123O00560CBF91077D441ABCB20E41460BA8A2036703063O0013237FDAC76203083O002FFE1EF615F50DF103043O00827C9B6A03103O00C0D8F38AAFEF6FB6D4C5D2AAA0E479BA03083O00DFB5AB96CFC3961C03083O007F3FF7BA00423DF003053O00692C5A83CE03103O00EAF3B7940D2AFEEDBDAB1836F0F3BBAA03063O005E9F80D2D968026O001840026O00084003083O0079B208C14882A45903073O00C32AD77CB521EC03103O00184A321929F9044F320A20F51D5C242A03063O00986D39575E45026O001040025O00EC9340025O002AAC4003083O00152E31ABE8282C3603053O0081464B45DF030B3O0053D8F6CF79E344C7F2ED7903063O008F26AB93891C03083O00E387ADE70AEDD3C303073O00B4B0E2D9936383030A3O00C6AA2A21D6B51D12C0B103043O0067B3D94F026O006E40025O00989240025O00D88340025O00A2A14003083O008C332997B9FAE4AC03073O0083DF565DE3D094030D3O00F656B39018B9C1442OA41CB2E603063O00D583252OD67D025O00A49E40025O00B0804003083O002DB5121C11E619A303063O00887ED0666878030F3O006D99CB66BC41385F7B8FEC51AA533603083O003118EAAE23CF325D03083O003FF7E99C7802F5EE03053O00116C929DE8030A3O005ED011C836AD69C615E003063O00C82BA3748D4F025O00806840025O009EA740026O00A040025O00CEA740025O00B07940025O0034A740025O00809440025O00D2A54003083O00C22059FBD0FF225E03053O00B991452D8F030E3O009F0C1C92D498100E81D08B160FA303053O00BCEA7F79C6025O00E8A040025O0098AA4003083O00CAD21E2OB7DC53BB03083O00C899B76AC3DEB23403113O0027F08D1444573DEF892940553CC29D2F4803063O003A5283E85D2903083O00B052C4015431844403063O005FE337B0753D030F3O000D6D2678A21F772F64AD3E722246AE03053O00CB781E432B03083O002DE561DEE3851EC503083O00B67E8015AA8AEB7903133O0086DF21E78B1C221683D526EF9524391283F91103083O0066EBBA5586E67350026O001C40025O00E09040025O00CCA64003083O0063FC12AB5671FE6903083O001A309966DF3F1F99030A3O001753E8C70A45C5E60C5403043O009362208D03083O002B46F7DE0F584C0B03073O002B782383AA663603133O00510A9EA5ACB18A700384A4A0B5B35D128F958103073O00E43466E7D6C5D0025O00C4AA40025O00D49B40025O0018B140025O00CCAF4003083O0049B926608F3B7C9803083O00EB1ADC5214E6551B030F3O009DB2ECE37A86A8E1CB7889B5E0CD7A03053O0014E8C189A203083O0011DAD1B2EE82106203083O001142BFA5C687EC77030D3O001ABCAB31F3E9E8D42BAEA010FA03083O00B16FCFCE739F888C025O00288940025O0042B04003083O00368C0400DD41581603073O003F65E97074B42F030E3O00D628E831F037CC28DE06EA3FC83E03063O0056A35B8D7298025O0028B34003083O0064092A4B7BDA254403073O0042376C5E3F12B4030D4O0085801F325700BA8C232F7A3003063O003974EDE5574703083O0099B4F9F37EE040B903073O0027CAD18D87178E03143O00FA3F10193BF9F1170C0920FDFA000C1E262OF13403063O00989F53696A5203063O0091CA50EBCC4E03063O003CE1A63192A903083O001C1B3B3E0809280D03063O00674F7E4F4A6103133O00BF73CA60571BB45BD6704C1FBF4CDF7A5A1FA803063O007ADA1FB3133E025O00BAA340025O0023B24000D5012O0012CD3O00014O00DA000100023O002EF5000200CA2O010002000428012O00CC2O010026793O00CC2O010003000428012O00CC2O010026790001000600010001000428012O000600010012CD000200013O0026790002003A00010003000428012O003A00010012CD000300013O000E2F0001002700010003000428012O002700010012F4000400044O0057000500013O00122O000600053O00122O000700066O0005000700024O0004000400054O000500013O00122O000600073O00122O000700086O0005000700024O0004000400054O00045O00122O000400046O000500013O00122O000600093O00122O0007000A6O0005000700024O0004000400054O000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O000400023O00122O000300033O002EF5000D00E5FF2O000D000428012O000C00010026790003000C00010003000428012O000C00010012F4000400044O00F8000500013O00122O0006000E3O00122O0007000F6O0005000700024O0004000400054O000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000400033O00122O000200123O00044O003A0001000428012O000C0001002EB70014007500010013000428012O007500010026790002007500010015000428012O007500010012CD000300013O0026E10003004300010001000428012O00430001002EB70016006400010017000428012O006400010012CD000400013O0026790004004800010003000428012O004800010012CD000300033O000428012O006400010026790004004400010001000428012O004400010012F4000500044O003D010600013O00122O000700183O00122O000800196O0006000800024O0005000500064O000600013O00122O0007001A3O00122O0008001B6O0006000800024O0005000500064O000500043O00122O000500046O000600013O00122O0007001C3O00122O0008001D6O0006000800024O0005000500064O000600013O00122O0007001E3O00122O0008001F6O0006000800024O0005000500064O000500053O00122O000400033O00044O004400010026790003003F00010003000428012O003F00010012F4000400044O00F8000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000400063O00122O000200243O00044O00750001000428012O003F0001000E2F002500B000010002000428012O00B000010012CD000300013O000E2F0003008800010003000428012O008800010012F4000400044O00F8000500013O00122O000600263O00122O000700276O0005000700024O0004000400054O000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000400073O00122O0002002A3O00044O00B000010026E10003008C00010001000428012O008C0001002EB7002C00780001002B000428012O007800010012CD000400013O002679000400A800010001000428012O00A800010012F4000500044O0057000600013O00122O0007002D3O00122O0008002E6O0006000800024O0005000500064O000600013O00122O0007002F3O00122O000800306O0006000800024O0005000500064O000500083O00122O000500046O000600013O00122O000700313O00122O000800326O0006000800024O0005000500064O000600013O00122O000700333O00122O000800346O0006000800024O0005000500064O000500093O00122O000400033O002EB70035008D00010036000428012O008D00010026790004008D00010003000428012O008D00010012CD000300033O000428012O00780001000428012O008D0001000428012O00780001002679000200ED00010012000428012O00ED00010012CD000300013O0026E1000300B700010003000428012O00B70001002EB7003800C500010037000428012O00C500010012F4000400044O00F8000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400054O0004000A3O00122O000200253O00044O00ED0001002679000300B300010001000428012O00B300010012CD000400013O002EB7003E00E50001003D000428012O00E50001002679000400E500010001000428012O00E500010012F4000500044O0057000600013O00122O0007003F3O00122O000800406O0006000800024O0005000500064O000600013O00122O000700413O00122O000800426O0006000800024O0005000500064O0005000B3O00122O000500046O000600013O00122O000700433O00122O000800446O0006000800024O0005000500064O000600013O00122O000700453O00122O000800466O0006000800024O0005000500064O0005000C3O00122O000400033O002E12004700C800010048000428012O00C80001002679000400C800010003000428012O00C800010012CD000300033O000428012O00B30001000428012O00C80001000428012O00B30001002E120049002A2O01004A000428012O002A2O010026790002002A2O01002A000428012O002A2O010012CD000300014O00DA000400043O0026E1000300F700010001000428012O00F70001002E12004C00F30001004B000428012O00F300010012CD000400013O002E12004D000A2O01004E000428012O000A2O010026790004000A2O010003000428012O000A2O010012F4000500044O00F8000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O000600013O00122O000700513O00122O000800526O0006000800024O0005000500064O0005000D3O00122O000200153O00044O002A2O01000EA30001000E2O010004000428012O000E2O01002E12005400F800010053000428012O00F800010012F4000500044O003D010600013O00122O000700553O00122O000800566O0006000800024O0005000500064O000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O0005000E3O00122O000500046O000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500064O000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500064O0005000F3O00122O000400033O00044O00F80001000428012O002A2O01000428012O00F300010026790002005B2O010024000428012O005B2O010012CD000300013O000E2F0003003D2O010003000428012O003D2O010012F4000400044O00F8000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000400103O00122O000200613O00044O005B2O01002E120062002D2O010063000428012O002D2O010026790003002D2O010001000428012O002D2O010012F4000400044O003D010500013O00122O000600643O00122O000700656O0005000700024O0004000400054O000500013O00122O000600663O00122O000700676O0005000700024O0004000400054O000400113O00122O000400046O000500013O00122O000600683O00122O000700696O0005000700024O0004000400054O000500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000400123O00122O000300033O00044O002D2O010026E10002005F2O010001000428012O005F2O01002E12006C00962O01006D000428012O00962O010012CD000300014O00DA000400043O0026E1000300652O010001000428012O00652O01002E12006E00612O01006F000428012O00612O010012CD000400013O002679000400812O010001000428012O00812O010012F4000500044O0057000600013O00122O000700703O00122O000800716O0006000800024O0005000500064O000600013O00122O000700723O00122O000800736O0006000800024O0005000500064O000500133O00122O000500046O000600013O00122O000700743O00122O000800756O0006000800024O0005000500064O000600013O00122O000700763O00122O000800776O0006000800024O0005000500064O000500143O00122O000400033O0026E1000400852O010003000428012O00852O01002EB7007900662O010078000428012O00662O010012F4000500044O00F8000600013O00122O0007007A3O00122O0008007B6O0006000800024O0005000500064O000600013O00122O0007007C3O00122O0008007D6O0006000800024O0005000500064O000500153O00122O000200033O00044O00962O01000428012O00662O01000428012O00962O01000428012O00612O01002EF5007E0073FE2O007E000428012O000900010026790002000900010061000428012O000900010012F4000300044O0082000400013O00122O0005007F3O00122O000600806O0004000600024O0003000300044O000400013O00122O000500813O00122O000600826O0004000600024O0003000300044O000300163O00122O000300046O000400013O00122O000500833O00122O000600846O0004000600024O0003000300044O000400013O00122O000500853O00122O000600866O0004000600024O00030003000400062O000300B72O010001000428012O00B72O012O007A000300013O0012CD000400873O0012CD000500884O00240003000500022O003C000300173O00122B000300046O000400013O00122O000500893O00122O0006008A6O0004000600024O0003000300044O000400013O00122O0005008B3O00122O0006008C6O0004000600024O00030003000400062O000300C62O010001000428012O00C62O010012CD000300014O003C000300183O000428012O00D42O01000428012O00090001000428012O00D42O01000428012O00060001000428012O00D42O010026E13O00D02O010001000428012O00D02O01002EB7008E00020001008D000428012O000200010012CD000100014O00DA000200023O0012CD3O00033O000428012O000200012O003A3O00017O00403O00028O00025O001EAF40025O00F89140026O00F03F025O00C4AF40025O0097B040026O001040030C3O004570696353652O74696E677303083O006837B854F45535BF03053O009D3B52CC20030C3O002B37E4F3E5D9D6A52C37EDFD03083O00D1585E839A898AB3034O00027O004003083O00F08CD09588DBC49A03063O00B5A3E9A42OE103073O0045983B555C9E2C03043O001730EB5E03083O004FDFCC495E3DD56F03073O00B21CBAB83D3753030D3O00D1DE4212F71AFDC1DF503DFE0503073O0095A4AD275C926E026O000840025O00989640025O00088140025O00408340025O00E06840025O0020B140025O00D0A14003083O00F00357C64E7023D003073O0044A36623B2271E030E3O00AB63DFE106B9A603AB602OCE0CBB03083O0071DE10BAA763D5E303083O001D0BEFE22700FCE503043O00964E6E9B03103O0090D622D2AD19B64CAAC30AE8B71BAD5903083O0020E5A54781C47EDF025O00D4B140025O00B08240025O0046AD40025O0062AE40025O009EB24003083O00C022040B1315F43403063O007B9347707F7A03063O00CEC197636EFC03053O0026ACADE21103083O007E1438FB441F2BFC03043O008F2D714C030C3O00B6BD0834BDAA0B3DB4B3340C03043O005C2OD87C025O0088A440025O0040A340025O00FAA840025O006EA740025O00C08D40025O00C0514003083O0080D3D9D5C0AF42A003073O0025D3B6ADA1A9C1030C3O00E22948FA207AB6E41442CF2903073O00D9975A2DB9481B03083O00F079F3065FCD7BF403053O0036A31C8772030A3O003DC858A6476C3ACE4D9603063O001F48BB3DE22E00CC3O0012CD3O00014O00DA000100023O000EA30001000600013O000428012O00060001002EB70002000900010003000428012O000900010012CD000100014O00DA000200023O0012CD3O00043O0026793O000200010004000428012O00020001002EB70005000B00010006000428012O000B00010026790001000B00010001000428012O000B00010012CD000200013O0026790002002200010007000428012O002200010012F4000300084O0046010400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400062O0003002000010001000428012O002000010012CD0003000D4O003C00035O000428012O00CB0001002679000200450001000E000428012O004500010012CD000300013O0026790003004000010001000428012O004000010012F4000400084O0057000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O000400023O00122O000400086O000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O000500013O00122O000600153O00122O000700166O0005000700024O0004000400054O000400033O00122O000300043O0026790003002500010004000428012O002500010012CD000200173O000428012O00450001000428012O00250001000EA30004004900010002000428012O00490001002EB70018006E00010019000428012O006E00010012CD000300013O0026E10003004E00010004000428012O004E0001002EF5001A00040001001B000428012O005000010012CD0002000E3O000428012O006E00010026E10003005400010001000428012O00540001002E12001C004A0001001D000428012O004A00010012F4000400084O003D010500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000400043O00122O000400086O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000400053O00122O000300043O00044O004A0001002EB70027009D00010026000428012O009D00010026790002009D00010017000428012O009D00010012CD000300013O002EF50028000600010028000428012O007900010026790003007900010004000428012O007900010012CD000200073O000428012O009D0001002EB7002900730001002A000428012O007300010026790003007300010001000428012O007300010012F4000400084O0046010500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400054O000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500062O0004008B00010001000428012O008B00010012CD000400014O003C000400063O00122B000400086O000500013O00122O0006002F3O00122O000700306O0005000700024O0004000400054O000500013O00122O000600313O00122O000700326O0005000700024O00040004000500062O0004009A00010001000428012O009A00010012CD000400014O003C000400073O0012CD000300043O000428012O00730001002EB70034001000010033000428012O001000010026790002001000010001000428012O001000010012CD000300013O0026E1000300A600010004000428012O00A60001002E12003500A800010036000428012O00A800010012CD000200043O000428012O001000010026E1000300AC00010001000428012O00AC0001002E12003700A200010038000428012O00A200010012F4000400084O003D010500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400054O000400083O00122O000400086O000500013O00122O0006003D3O00122O0007003E6O0005000700024O0004000400054O000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000400093O00122O000300043O00044O00A20001000428012O00100001000428012O00CB0001000428012O000B0001000428012O00CB0001000428012O000200012O003A3O00017O00493O00028O00025O0056A240025O00707A40030C3O004570696353652O74696E677303083O001BA4D068172D363103083O004248C1A41C7E435103113O00E125AF503244E221A9512865C424AD5B2D03063O0016874CC8384603083O00BE35EC3054EF8A2303063O0081ED5098443D030B3O0055A117E3191B7A44AE02E003073O003831C864937C77026O00F03F03083O00FF3BABE4C530B8E303043O0090AC5EDF03113O000D01B642361DB7573038AB532C3CB6522A03043O0027446FC2025O0085B340025O00A7B240026O00104003083O0094B2DDC8AEB9CECF03043O00BCC7D7A903113O00D408517FE4F9205178E7EE195069EDFD0503053O00889C693F1B027O0040025O000AAA40025O0068AC4003083O00DEA0936F19BD542F03083O005C8DC5E71B70D33303103O00F3EC8F8BD4E7F383AD2OD6F09EAADEE803053O00B1869FEAC3026O000840025O00F4AC40025O00B2A240025O00709B40025O003EAD4003083O0029182A0C3CFF230903073O00447A7D5E785591030E3O00030EC650C3DCAE042BC64AC0FA9E03073O00DA777CAF3EA8B903083O0096F55CD0ACFE4FD703043O00A4C59028030E3O0096E3AFA3D8B78FE4A298C9B98DF503063O00D6E390CAEBBD025O004CA440025O0028A94003083O002922461824E31CFD03083O008E7A47326C4D8D7B030B4O00B1FA2C291CACF41D2F0603053O005B75C29F7803083O00E5A3F3D370B9D1B503063O00D7B6C687A71903163O00A447FE4D9F5BFF589966E444947EE241994CE6419E5D03043O0028ED298A03083O00F471EEEC43C973E903053O002AA7149A9803123O0063F0B64763335FEEB67679334FEDAA4D7D2503063O00412A9EC22211025O0062B340025O00B8AC4003083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC0030D3O00D68E7E33362ECD9F7031270EEE03063O0046BEEB1F5F4203083O0089E70EF2ECB4E50903053O0085DA827A86030F3O0034FAE2C8D5AD3F0CF0F7CDD3AD100C03073O00585C9F83A4BCC303083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B03113O0006F98B1AC820FBBA19D527F38438C023F903053O00A14E9CEA76035O00F63O0012CD3O00014O00DA000100013O002E120003000200010002000428012O000200010026793O000200010001000428012O000200010012CD000100013O0026790001003900010001000428012O003900010012CD000200013O000E2F0001002800010002000428012O002800010012F4000300044O0046010400013O00122O000500053O00122O000600066O0004000600024O0003000300044O000400013O00122O000500073O00122O000600086O0004000600024O00030003000400062O0003001A00010001000428012O001A00010012CD000300014O003C00035O0012DD000300046O000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000300023O00122O0002000D3O0026790002000A0001000D000428012O000A00010012F4000300044O00F8000400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000300033O00122O0001000D3O00044O00390001000428012O000A0001002E120013004A00010012000428012O004A00010026790001004A00010014000428012O004A00010012F4000200044O001C010300013O00122O000400153O00122O000500166O0003000500024O0002000200034O000300013O00122O000400173O00122O000500186O0003000500024O0002000200032O003C000200043O000428012O00F500010026790001008900010019000428012O008900010012CD000200013O002EB7001A005F0001001B000428012O005F00010026790002005F0001000D000428012O005F00010012F4000300044O00F8000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000300053O00122O000100203O00044O00890001002E120022004D00010021000428012O004D00010026790002004D00010001000428012O004D00010012CD000300013O002EB70023008100010024000428012O008100010026790003008100010001000428012O008100010012F4000400044O0057000500013O00122O000600253O00122O000700266O0005000700024O0004000400054O000500013O00122O000600273O00122O000700286O0005000700024O0004000400054O000400063O00122O000400046O000500013O00122O000600293O00122O0007002A6O0005000700024O0004000400054O000500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400054O000400073O00122O0003000D3O002E12002D00640001002E000428012O00640001002679000300640001000D000428012O006400010012CD0002000D3O000428012O004D0001000428012O00640001000428012O004D0001002679000100C20001000D000428012O00C200010012CD000200013O000E2F000D009C00010002000428012O009C00010012F4000300044O00F8000400013O00122O0005002F3O00122O000600306O0004000600024O0003000300044O000400013O00122O000500313O00122O000600326O0004000600024O0003000300044O000300083O00122O000100193O00044O00C200010026790002008C00010001000428012O008C00010012CD000300013O000E2F000100BA00010003000428012O00BA00010012F4000400044O0057000500013O00122O000600333O00122O000700346O0005000700024O0004000400054O000500013O00122O000600353O00122O000700366O0005000700024O0004000400054O000400093O00122O000400046O000500013O00122O000600373O00122O000700386O0005000700024O0004000400054O000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O0004000A3O00122O0003000D3O0026E1000300BE0001000D000428012O00BE0001002E12003B009F0001003C000428012O009F00010012CD0002000D3O000428012O008C0001000428012O009F0001000428012O008C00010026790001000700010020000428012O000700010012F4000200044O0046010300013O00122O0004003D3O00122O0005003E6O0003000500024O0002000200034O000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300062O000200D200010001000428012O00D200010012CD000200014O003C0002000B3O00122B000200046O000300013O00122O000400413O00122O000500426O0003000500024O0002000200034O000300013O00122O000400433O00122O000500446O0003000500024O00020002000300062O000200E100010001000428012O00E100010012CD000200014O003C0002000C3O00122B000200046O000300013O00122O000400453O00122O000500466O0003000500024O0002000200034O000300013O00122O000400473O00122O000500486O0003000500024O00020002000300062O000200F000010001000428012O00F000010012CD000200494O003C0002000D3O0012CD000100143O000428012O00070001000428012O00F50001000428012O000200012O003A3O00017O004F012O00028O00026O00F03F025O0016AB40025O007AA940025O00D49640025O000AA240026O001440025O003DB240025O00F07F40025O007EB040025O00309D40025O0024A840025O00805940025O0039B040025O00C4974003113O0048616E646C65496E636F72706F7265616C03083O00496D707269736F6E03113O00496D707269736F6E4D6F7573656F766572026O003E40030D3O00546172676574497356616C6964030C3O0049734368612O6E656C696E6703093O00497343617374696E67025O00206F40025O00C05640025O0004B240025O003C9C40026O001040027O0040025O00C88340025O0066B14003073O00EDDB2137E2D8D603053O0097ABBE4D65030A3O0049734361737461626C6503073O00EC21FDBBEC740A03073O006BA54F98C9981D030B3O004973417661696C61626C6503083O0042752O66446F776E030B3O00496E657274696142752O6603063O0042752O66557003103O00556E626F756E644368616F7342752O6603073O007257EDE9517E5A03063O001F372E88AB34030F3O00432O6F6C646F776E52656D61696E73026O000840030B3O0042752O6652656D61696E73030A3O00F324DDF0D40CDDFAD22D03043O0094B148BC030C3O00432O6F6C646F776E446F776E030C3O0083A544D6A8B552F1B4B356D803043O00B3C6D637030A3O00432O6F6C646F776E557003073O0046656C52757368030E3O0049735370652O6C496E52616E6765030B3O005468726F77476C61697665030F3O00F6097E4957C6E304327B44DAFE4C2B03063O00B3906C12162503073O00E0A617BBDAD5AB03053O00AFA6C37BE903073O00C6CC585BE4E6C303053O00908FA23D2903113O004D6574616D6F7270686F73697342752O66030C3O00C5C00E557C8436C2C118517903073O005380B37D3012E7026O002440025O0030A240025O0090774003103O005BB2FFE2550B4EBFB3D0461753F7A28D03063O007E3DD793BD27025O005EA940030E3O0034A487A42F7809A085A5026C0FA803063O00197DC9EACB4303073O0050FA1D11002E1203073O0073199478637447030E3O002530B42B4D0D29B02B4F2D28AB2503053O00216C5DD94403103O0046752O6C526563686172676554696D65030C3O00FE58B2A8D548A48FC94EA0A603043O00CDBB2BC1030C3O00DB6116DAF07100FDEC7704D403043O00BF9E1265030A3O00446562752O66446F776E03123O00452O73656E6365427265616B446562752O66026O001840030A3O00E7CF86B3AAE1C289B4AA03053O00CFA5A3E7D703043O0046757279025O00C05240030A3O00E4F5F8522154C7F7FA5303063O0010A62O993644025O00709540025O002AAF40030E3O00492O6D6F6C6174696F6E4175726103093O004973496E52616E676503163O00DBBECD493820EDDBBCCE793534EBD3F3CD473D2FB98403073O0099B2D3A026544103073O00A40E561997185203043O004BE26B3A03093O0054696D65546F446965025O0080AD40025O00A89C40030F3O005EDB1D4503D7DE509E1C7B18CC8D0003073O00AD38BE711A71A2025O00109440025O002EAF40025O005BB040025O00D2A940025O000C9140025O008CAD40025O0016AE40025O00288540025O00B49240025O00DCAE40025O00F0B240025O00A06140025O00A4AB40025O003EAE4003083O00A5D4D0A9AF02B32E03083O0043E8BBBDCCC176C6030C3O004D6F6D656E74756D42752O6603073O00A220B0322F0BEE03073O008FEB4ED5405B6203073O00A85181CB75B78003063O00D6ED28E48910030C3O00426173654475726174696F6E2O033O0047434403073O00A1E6E2D60DAF8603063O00C6E5838FB963030C3O00749FBB765F8FAD514389A97803043O001331ECC8030E3O00566172334D696E5472696E6B6574030D3O00D332E2B6E9B5EC27FEB8F7B3ED03063O00DA9E5796D78403103O00C816D8F62227DFFE1AFDE72536C4F50703073O00AD9B7EB9825642026O004E40030D3O00C8A3AEC685E3F7B6B2C89BE5F603063O008C85C6DAA7E8026O003440030D3O00982BA07C89BA3CA4758BA627A703053O00E4D54ED41D030A3O00AE42B800F9A349BB0AE503053O008BE72CD665025O00C4AD40025O00B8A840030E3O00F0E20B511CB0251FD6E1274B02B003083O0076B98F663E70D15103083O006E712EE3A31C0E3D03083O00583C104986C5757C030A3O0072E6F9CC4474EBF6CB4403053O0021308A98A8025O00FAA340025O0052A44003163O007B1B3D5ECD36661F3F5FFE3667043111CC367B18702O03063O005712765031A1025O001CA240025O00E89040030B3O002AC9B2EBAA5512C0A9F2B803063O00127EA1C084DD03073O0049735265616479030E3O0056616C75654973496E412O72617903053O004E5043494403143O005468726F77476C616976654D6F7573656F76657203283O005927AA00534D68BA0B164B20AB44505329A301451F3AAB05554B68BE01441F25A111455A27B8014403053O00363F48CE64030A3O00EE505769F159C4564A7E03063O001BA839251A85030B3O0019B87DA1DB22AC4EBDDE2303053O00B74DCA1CC8030B3O00343B88070407810D18219003043O00687753E9030F3O004368616F735468656F727942752O66030B3O00D1FD2A2D4DD7F42O2646E603053O002395984742030A3O003BE443B43F3DE94CB33F03053O005A798822D003073O00E30B5811C9075603043O007EA76E3503093O001F1C27F6D81928023703063O005F5D704E98BC03073O00E4EC8037E1BFDF03073O00B2A195E57584DE030B3O00467572794465666963697403073O0005D1781BC4E52B03063O009643B41449B1025O00AAA940025O00F2AA40031A3O008B1D16729F0D0945CD0A15598C0C134283580D4588165A62A22A03043O002DED787A030B3O00E3E0B023C0CFAE2DDEFEA703043O004CB788C2025O00688040025O0014954003253O007CE9E13C555D546EE9A52C584A547CEAE435555C5468E3E43B440F047FF4A52C515D137FF203073O00741A868558302F025O003AB040025O00EEA240030F3O00412O66656374696E67436F6D626174025O0068B240025O00CAAD40030C3O00604415261E51AA6E4A1C3C0803073O00CF232B7B556B3C030C3O0053A5AEF96C7DAF8DEB7E79A903053O001910CAC08A03103O00556E69744861734D6167696342752O66025O00206340025O001EA040030C3O00436F6E73756D654D6167696303143O00FAD9A8E3BDF1EFF4BDF7BBF3F88BA9E3A4F5FACE03063O00949DABCD82C9025O0030A440030E3O006513D7AFBC4D0AD3AFBE6D0BC8A103053O00D02C7EBAC0030B3O00D63CADD411D5C75DFE1EA103083O002E977AC4A6749CA903073O00CCE34308EF2OEC03053O009B858D267A030E3O000C27A14E437EB12C25A2605A6DA403073O00C5454ACC212F1F03163O00F9425788FC2O4E8EFF416586E55D5BC7FD4E5389B01C03043O00E7902F3A03073O0094DDD6470D2EC703083O0059D2B8BA15785DAF030E3O00985E71DA753BA55A73DB582FA35203063O005AD1331CB51903073O004368617267657303083O00507265764743445003073O004579654265616D025O006C9B40025O00A88540030F3O00D67E5BD1ADC5685FAEB2D17259AEEB03053O00DFB01B378E03073O0010B3CB9D31B5DA03043O00D544DBAE030A3O00436F6D62617454696D6503073O0022EE26F53ECC3E03083O001F6B8043874AA55F025O002OAA4003073O0054686548756E74030F3O00CCE0F97249A4D6FCBC2O40B8D6A8AA03063O00D1B8889C2D21030E3O002EC57807B406DC7C07B626DD670903053O00D867A8156803073O0051A346B66CA44203043O00C418CD2303073O000B92E6242B8AEE03043O00664EEB83030C3O00DF3D2741493AB216E82B354F03083O00549A4E54242759D7025O00EFB140025O00E8A74003163O00F4EC5B5709FCF55F570BC2E0434A04BDEC57510BBDB403053O00659D813638025O00B8A940025O00EC9640025O00689540026O008340025O007AA840025O00389A40030B3O005CFA104A76DD11447CFA0E03043O0025189F7D03043O00502O6F6C03113O00CAA97A4E9AA2704FD5A84A40D6A77147C903043O0022BAC615025O0071B240025O00389440025O003EA540025O00207540025O00AEA140025O00F0B040025O00109240025O00107840025O009C9B40025O000CB040025O0078A840025O0042AD4003163O00476574456E656D696573496E4D656C2O6552616E6765025O00FAB240025O004EB340029A5O99A93F025O00C49940025O0018A440024O0080B3C540030C3O00466967687452656D61696E7303093O00456E656D6965733879025O0048B140025O0020A940025O00709840025O006CAC4003103O00426F2O73466967687452656D61696E73025O0014A340025O00CCAF40026O00AF40025O00F09040025O0029B040025O00B07B40025O00D09640025O0026A540025O00E06F40030C3O004570696353652O74696E677303073O002F837E3317896A03043O00547BEC192O033O00FF84A903063O00D590EBCA77CC03073O002O17D92D24265E03073O002D4378BE4A48432O033O00212DE803083O008940428DC599E88E025O001CAF40025O00F4B240025O0041B24003073O0037DF25A18406C303053O00E863B042C62O033O00EF253B03083O004C8C4148661BED99025O00DEA640025O00B6A740025O0053B140025O00A49E40025O0058AB40025O00B88340030F3O0008D0AA600037D8BE560632CFAF621B03053O006F41BDDA12025O00C89C40025O00E8AE40025O0096A040025O0068974003073O007ED511D5DB04AD03073O00DE2ABA76B2B76103083O0050E3528F50E94A9E03043O00EA3D8C24030D3O004973446561644F7247686F7374025O00EC9E40025O00109E40025O00408A40025O00FCB040008F072O0012CD3O00014O00DA000100023O0026E13O000600010002000428012O00060001002EB70003008307010004000428012O00830701002E120005000600010006000428012O000600010026790001000600010001000428012O000600010012CD000200013O0026E10002000F00010007000428012O000F0001002EB7000800D105010009000428012O00D105012O007A00035O0006360003001400010001000428012O00140001002E12000A00160001000B000428012O001600012O007A00038O000300023O002E12000D00370001000C000428012O003700012O007A000300013O00060A0003003700013O000428012O003700010012CD000300014O00DA000400043O002EB7000F001D0001000E000428012O001D00010026790003001D00010001000428012O001D00010012CD000400013O0026790004002200010001000428012O002200012O007A000500023O0020980005000500104O000600033O00202O0006000600114O000700043O00202O00070007001200122O000800136O000900016O0005000900024O00058O00055O00062O0005003700013O000428012O003700012O007A00058O000500023O000428012O00370001000428012O00220001000428012O00370001000428012O001D00012O007A000300023O0020450003000300142O008D00030001000200060A0003004600013O000428012O004600012O007A000300053O0020C00003000300152O00450103000200020006360003004600010001000428012O004600012O007A000300053O0020C00003000300162O004501030002000200060A0003004800013O000428012O00480001002EB70017008E07010018000428012O008E07010012CD000300014O00DA000400053O0026E10003004E00010002000428012O004E0001002EF5001900790501001A000428012O00C50501002679000400C62O01001B000428012O00C62O010012CD000600013O002679000600550001001C000428012O005500010012CD000400073O000428012O00C62O01002E12001D00112O01001E000428012O00112O01002679000600112O010002000428012O00112O012O007A000700034O0025000800063O00122O0009001F3O00122O000A00206O0008000A00024O00070007000800202O0007000700214O00070002000200062O000700C400013O000428012O00C400012O007A000700073O00060A000700C400013O000428012O00C400012O007A000700083O00060A000700C400013O000428012O00C400012O007A000700034O0025000800063O00122O000900223O00122O000A00236O0008000A00024O00070007000800202O0007000700244O00070002000200062O000700C400013O000428012O00C400012O007A000700053O00205C0007000700254O000900033O00202O0009000900264O00070009000200062O000700C400013O000428012O00C400012O007A000700053O00205C0007000700274O000900033O00202O0009000900284O00070009000200062O000700C400013O000428012O00C400012O007A000700094O0003010800036O000900063O00122O000A00293O00122O000B002A6O0009000B00024O00080008000900202O00080008002B4O00080002000200122O0009002C6O0007000900022O007A0008000A4O0003010900036O000A00063O00122O000B00293O00122O000C002A6O000A000C00024O00090009000A00202O00090009002B4O00090002000200122O000A002C6O0008000A00022O00FC0007000700082O0060000800053O00202O00080008002D4O000A00033O00202O000A000A00284O0008000A000200062O000800C400010007000428012O00C400012O007A000700034O0063000800063O00122O0009002E3O00122O000A002F6O0008000A00024O00070007000800202O0007000700304O00070002000200062O000700B300010001000428012O00B300012O007A000700034O0025000800063O00122O000900313O00122O000A00326O0008000A00024O00070007000800202O0007000700334O00070002000200062O000700C400013O000428012O00C400012O007A0007000B4O0090000800033O00202O0008000800344O0009000C3O00202O0009000900354O000B00033O00202O000B000B00364O0009000B00024O000900096O00070009000200062O000700C400013O000428012O00C400012O007A000700063O0012CD000800373O0012CD000900384O0028000700094O006A00076O007A000700034O0025000800063O00122O000900393O00122O000A003A6O0008000A00024O00070007000800202O0007000700214O00070002000200062O000700102O013O000428012O00102O012O007A000700073O00060A000700102O013O000428012O00102O012O007A000700083O00060A000700102O013O000428012O00102O012O007A000700053O00205C0007000700274O000900033O00202O0009000900284O00070009000200062O000700102O013O000428012O00102O012O007A000700034O0025000800063O00122O0009003B3O00122O000A003C6O0008000A00024O00070007000800202O0007000700244O00070002000200062O000700102O013O000428012O00102O012O007A000700053O00205C0007000700254O000900033O00202O0009000900264O00070009000200062O000700102O013O000428012O00102O012O007A000700053O0020150107000700274O000900033O00202O00090009003D4O00070009000200062O000700FD00010001000428012O00FD00012O007A000700034O0025010800063O00122O0009003E3O00122O000A003F6O0008000A00024O00070007000800202O00070007002B4O000700020002000E2O004000102O010007000428012O00102O012O007A0007000B4O008F000800033O00202O0008000800344O0009000C3O00202O0009000900354O000B00033O00202O000B000B00364O0009000B00024O000900096O00070009000200062O0007000B2O010001000428012O000B2O01002EB7004100102O010042000428012O00102O012O007A000700063O0012CD000800433O0012CD000900444O0028000700094O006A00075O0012CD0006001C3O0026790006005100010001000428012O00510001002EF50045007E00010045000428012O00912O012O007A000700034O0025000800063O00122O000900463O00122O000A00476O0008000A00024O00070007000800202O0007000700214O00070002000200062O000700912O013O000428012O00912O012O007A0007000D3O00060A000700912O013O000428012O00912O012O007A000700034O0025000800063O00122O000900483O00122O000A00496O0008000A00024O00070007000800202O0007000700244O00070002000200062O000700912O013O000428012O00912O012O007A000700053O00205C0007000700254O000900033O00202O0009000900284O00070009000200062O000700912O013O000428012O00912O012O007A000700034O0027010800063O00122O0009004A3O00122O000A004B6O0008000A00024O00070007000800202O00070007004C4O0007000200024O000800036O000900063O00122O000A004D3O00122O000B004E6O0009000B00024O00080008000900202O00080008002B4O00080002000200062O0007004F2O010008000428012O004F2O012O007A000700034O0063000800063O00122O0009004F3O00122O000A00506O0008000A00024O00070007000800202O0007000700244O00070002000200062O000700912O010001000428012O00912O012O007A0007000C3O00205C0007000700514O000900033O00202O0009000900524O00070009000200062O000700912O013O000428012O00912O012O007A000700053O0020150107000700254O000900033O00202O00090009003D4O00070009000200062O000700642O010001000428012O00642O012O007A000700053O00200001070007002D4O000900033O00202O00090009003D4O000700090002000E2O005300912O010007000428012O00912O012O007A000700034O0025000800063O00122O000900543O00122O000A00556O0008000A00024O00070007000800202O0007000700304O00070002000200062O000700912O013O000428012O00912O012O007A000700053O0020C00007000700562O00450107000200020026CF0007007F2O010057000428012O007F2O012O007A000700034O002D010800063O00122O000900583O00122O000A00596O0008000A00024O00070007000800202O00070007002B4O0007000200024O0008000E3O00202O00080008001C00062O000700912O010008000428012O00912O01002EB7005A00912O01005B000428012O00912O012O007A0007000B4O00C8000800033O00202O00080008005C4O0009000C3O00202O00090009005D4O000B000F6O0009000B00024O000900096O00070009000200062O000700912O013O000428012O00912O012O007A000700063O0012CD0008005E3O0012CD0009005F4O0028000700094O006A00076O007A000700034O0025000800063O00122O000900603O00122O000A00616O0008000A00024O00070007000800202O0007000700214O00070002000200062O000700C42O013O000428012O00C42O012O007A000700073O00060A000700C42O013O000428012O00C42O012O007A000700083O00060A000700C42O013O000428012O00C42O012O007A000700053O0020BA00070007002D4O000900033O00202O0009000900284O0007000900024O0008000E3O00202O00080008001C00062O000700B12O010008000428012O00B12O012O007A0007000C3O0020500107000700624O0007000200024O0008000E3O00202O00080008001C00062O000700C42O010008000428012O00C42O01002E12006400C42O010063000428012O00C42O012O007A0007000B4O0090000800033O00202O0008000800344O0009000C3O00202O0009000900354O000B00033O00202O000B000B00364O0009000B00024O000900096O00070009000200062O000700C42O013O000428012O00C42O012O007A000700063O0012CD000800653O0012CD000900664O0028000700094O006A00075O0012CD000600023O000428012O005100010026E1000400CA2O010007000428012O00CA2O01002E120068001802010067000428012O001802010012CD000600014O00DA000700073O000EA3000100D02O010006000428012O00D02O01002E12006900CC2O01006A000428012O00CC2O010012CD000700013O002EF5006B000F0001006B000428012O00E02O01002679000700E02O010001000428012O00E02O012O007A000800104O008D0008000100022O003C00085O002EB7006C00DF2O01006D000428012O00DF2O012O007A00085O00060A000800DF2O013O000428012O00DF2O012O007A00088O000800023O0012CD000700023O002E12006E00E62O01006F000428012O00E62O01002679000700E62O01001C000428012O00E62O010012CD000400533O000428012O00180201002679000700D12O010002000428012O00D12O01002EF50070002900010070000428012O001102012O007A000800053O00205C0008000800274O000A00033O00202O000A000A003D4O0008000A000200062O0008001102013O000428012O001102012O007A000800053O00206900080008002D4O000A00033O00202O000A000A003D4O0008000A00024O0009000E3O00062O0008001102010009000428012O001102012O007A000800113O002615000800110201002C000428012O001102010012CD000800014O00DA000900093O002E12007200FE2O010071000428012O00FE2O01002679000800FE2O010001000428012O00FE2O010012CD000900013O0026790009000302010001000428012O000302012O007A000A00124O008D000A000100022O003C000A6O007A000A5O00060A000A001102013O000428012O001102012O007A000A8O000A00023O000428012O00110201000428012O00030201000428012O00110201000428012O00FE2O012O007A000800134O008D0008000100022O003C00085O0012CD0007001C3O000428012O00D12O01000428012O00180201000428012O00CC2O01002EB70073000703010074000428012O00070301002679000400070301001C000428012O000703012O007A000600034O0025000700063O00122O000800753O00122O000900766O0007000900024O00060006000700202O0006000600244O00060002000200062O0006002D02013O000428012O002D02012O007A000600053O0020150106000600254O000800033O00202O0008000800774O00060008000200062O0006003C02010001000428012O003C02012O007A000600034O0025000700063O00122O000800783O00122O000900796O0007000900024O00060006000700202O0006000600244O00060002000200062O0006003C02013O000428012O003C02012O007A000600053O0020C00006000600252O007A000800033O0020450008000800262O00240006000800022O003C000600144O00CA000600156O000700036O000800063O00122O0009007A3O00122O000A007B6O0008000A00024O00070007000800202O00070007007C4O0007000200024O000800053O00202O00080008007D4O000800096O00063O00024O000500066O000600036O000700063O00122O0008007E3O00122O0009007F6O0007000900024O00060006000700202O0006000600244O00060002000200062O000600C602013O000428012O00C602012O007A000600034O0025000700063O00122O000800803O00122O000900816O0007000900024O00060006000700202O0006000600244O00060002000200062O000600C602013O000428012O00C602010012F4000600823O00060A000600C602013O000428012O00C602012O007A000600174O003D000700096O000800036O000900063O00122O000A00833O00122O000B00846O0009000B00024O00080008000900202O00080008002B4O00080002000200202O0008000800132O0006010900186O000A00036O000B00063O00122O000C00853O00122O000D00866O000B000D00024O000A000A000B00202O000A000A00244O000A000B6O00093O00020020480109000900872O00240007000900022O003D0008000A6O000900036O000A00063O00122O000B00833O00122O000C00846O000A000C00024O00090009000A00202O00090009002B4O00090002000200202O0009000900132O0006010A00186O000B00036O000C00063O00122O000D00853O00122O000E00866O000C000E00024O000B000B000C00202O000B000B00244O000B000C6O000A3O0002002048010A000A00872O00240008000A00022O00FC00070007000800064F010700C402010006000428012O00C402012O007A000600034O0034000700063O00122O000800883O00122O000900896O0007000900024O00060006000700202O00060006002B4O00060002000200262O000600C40201008A000428012O00C402012O007A000600034O000F000700063O00122O0008008B3O00122O0009008C6O0007000900024O00060006000700202O00060006002B4O0006000200024O0007000E6O000800096O000900186O000A00036O000B00063O00122O000C008D3O00122O000D008E6O000B000D00024O000A000A000B00202O000A000A00244O000A000B6O00093O000200122O000A001C6O0008000A00024O0009000A6O000A00186O000B00036O000C00063O00122O000D008D3O00122O000E008E6O000C000E00024O000B000B000C00202O000B000B00244O000B000C6O000A3O000200122O000B001C6O0009000B00024O0008000800094O0007000700084O00070005000700062O000700C502010006000428012O00C502012O003B00066O000C000600014O003C000600163O002EB7009000060301008F000428012O000603012O007A000600034O0025000700063O00122O000800913O00122O000900926O0007000900024O00060006000700202O0006000600214O00060002000200062O0006000603013O000428012O000603012O007A0006000D3O00060A0006000603013O000428012O000603012O007A000600034O0025000700063O00122O000800933O00122O000900946O0007000900024O00060006000700202O0006000600244O00060002000200062O0006000603013O000428012O000603012O007A000600113O000E04012C000603010006000428012O000603012O007A000600034O0063000700063O00122O000800953O00122O000900966O0007000900024O00060006000700202O0006000600304O00060002000200062O000600F402010001000428012O00F402012O007A0006000C3O00205C0006000600514O000800033O00202O0008000800524O00060008000200062O0006000603013O000428012O00060301002E120097000603010098000428012O000603012O007A0006000B4O00C8000700033O00202O00070007005C4O0008000C3O00202O00080008005D4O000A000F6O0008000A00024O000800086O00060008000200062O0006000603013O000428012O000603012O007A000600063O0012CD000700993O0012CD0008009A4O0028000600084O006A00065O0012CD0004002C3O002EB7009C00A80301009B000428012O00A80301002679000400A803010002000428012O00A803012O007A000600034O0025000700063O00122O0008009D3O00122O0009009E6O0007000900024O00060006000700202O00060006009F4O00060002000200062O0006003203013O000428012O003203012O007A000600193O00060A0006003203013O000428012O003203012O007A0006001A3O0020860006000600A04O0007001B6O0008001C3O00202O0008000800A14O000800096O00063O000200062O0006003203013O000428012O003203012O007A0006000B4O0090000700043O00202O0007000700A24O0008000C3O00202O0008000800354O000A00033O00202O000A000A00364O0008000A00024O000800086O00060008000200062O0006003203013O000428012O003203012O007A000600063O0012CD000700A33O0012CD000800A44O0028000600084O006A00066O007A000600034O0063000700063O00122O000800A53O00122O000900A66O0007000900024O00060006000700202O0006000600244O00060002000200062O0006005C03010001000428012O005C03012O007A000600034O0063000700063O00122O000800A73O00122O000900A86O0007000900024O00060006000700202O0006000600244O00060002000200062O0006005C03010001000428012O005C03012O007A000600034O0025000700063O00122O000800A93O00122O000900AA6O0007000900024O00060006000700202O0006000600244O00060002000200062O0006005703013O000428012O005703012O007A000600053O0020150106000600254O000800033O00202O0008000800AB4O00060008000200062O0006005C03010001000428012O005C03012O007A000600113O000EEC0002005B03010006000428012O005B03012O003B00066O000C000600014O003C0006001D4O007A0006001D3O00060A0006007E03013O000428012O007E03012O007A000600053O0020910006000600564O0006000200024O000700186O000800036O000900063O00122O000A00AC3O00122O000B00AD6O0009000B00024O00080008000900202O0008000800244O000800096O00073O000200202O00070007008A00102O00070057000700062O0006007C03010007000428012O007C03012O007A000600034O0035010700063O00122O000800AE3O00122O000900AF6O0007000900024O00060006000700202O00060006002B4O0006000200024O0007000E3O00062O0006007D03010007000428012O007D03012O003B00066O000C000600014O003C0006001E4O00C5000600036O000700063O00122O000800B03O00122O000900B16O0007000900024O00060006000700202O0006000600244O00060002000200062O000600A603013O000428012O00A603012O007A000600034O0063000700063O00122O000800B23O00122O000900B36O0007000900024O00060006000700202O0006000600244O00060002000200062O000600A403010001000428012O00A403012O007A000600034O002D010700063O00122O000800B43O00122O000900B56O0007000900024O00060006000700202O00060006002B4O0006000200024O0007000E3O00202O00070007001C00062O000600A403010007000428012O00A403012O007A000600053O0020C00006000600B62O0045010600020002000EEC001300A503010006000428012O00A503012O003B00066O000C000600014O003C0006001F3O0012CD0004001C3O000E2F0001006504010004000428012O006504010012CD000600013O0026790006000A04010002000428012O000A04010012CD000700013O0026790007000304010001000428012O000304012O007A000800034O0025000900063O00122O000A00B73O00122O000B00B86O0009000B00024O00080008000900202O00080008009F4O00080002000200062O000800D903013O000428012O00D903012O007A000800073O00060A000800D903013O000428012O00D903012O007A000800083O00060A000800D903013O000428012O00D903012O007A0008000C3O0020C000080008005D2O007A000A000F4O00240008000A0002000636000800D903010001000428012O00D903012O007A0008000B4O008F000900033O00202O0009000900344O000A000C3O00202O000A000A00354O000C00033O00202O000C000C00364O000A000C00024O000A000A6O0008000A000200062O000800D403010001000428012O00D40301002E1200BA00D9030100B9000428012O00D903012O007A000800063O0012CD000900BB3O0012CD000A00BC4O00280008000A4O006A00086O007A000800034O0025000900063O00122O000A00BD3O00122O000B00BE6O0009000B00024O00080008000900202O00080008009F4O00080002000200062O0008000204013O000428012O000204012O007A000800193O00060A0008000204013O000428012O000204012O007A0008001A3O0020860008000800A04O0009001B6O000A000C3O00202O000A000A00A14O000A000B6O00083O000200062O0008000204013O000428012O000204012O007A0008000B4O008F000900033O00202O0009000900364O000A000C3O00202O000A000A00354O000C00033O00202O000C000C00364O000A000C00024O000A000A6O0008000A000200062O000800FD03010001000428012O00FD0301002EB700C00002040100BF000428012O000204012O007A000800063O0012CD000900C13O0012CD000A00C24O00280008000A4O006A00085O0012CD000700023O0026E10007000704010002000428012O00070401002E1200C300AE0301008F000428012O00AE03010012CD0006001C3O000428012O000A0401000428012O00AE03010026790006006004010001000428012O00600401002EF500C40016000100C4000428012O002204012O007A000700053O0020C00007000700C52O00450107000200020006360007002204010001000428012O002204010012CD000700013O002E1200C70014040100C6000428012O00140401000E2F0001001404010007000428012O001404012O007A000800204O008D0008000100022O003C00086O007A00085O00060A0008002204013O000428012O002204012O007A00088O000800023O000428012O00220401000428012O001404012O007A000700034O0025000800063O00122O000900C83O00122O000A00C96O0008000A00024O00070007000800202O0007000700244O00070002000200062O0007004C04013O000428012O004C04012O007A000700213O00060A0007004C04013O000428012O004C04012O007A000700034O0025000800063O00122O000900CA3O00122O000A00CB6O0008000A00024O00070007000800202O00070007009F4O00070002000200062O0007004C04013O000428012O004C04012O007A000700223O00060A0007004C04013O000428012O004C04012O007A000700053O0020C00007000700162O00450107000200020006360007004C04010001000428012O004C04012O007A000700053O0020C00007000700152O00450107000200020006360007004C04010001000428012O004C04012O007A000700023O0020450007000700CC2O007A0008000C4O00450107000200020006360007004E04010001000428012O004E0401002EF500CD0013000100CE000428012O005F04012O007A0007000B4O0090000800033O00202O0008000800CF4O0009000C3O00202O0009000900354O000B00033O00202O000B000B00CF4O0009000B00024O000900096O00070009000200062O0007005F04013O000428012O005F04012O007A000700063O0012CD000800D03O0012CD000900D14O0028000700094O006A00075O0012CD000600023O002679000600AB0301001C000428012O00AB03010012CD000400023O000428012O00650401000428012O00AB03010026E1000400690401002C000428012O00690401002EF500D200362O010045000428012O009D05012O007A000600034O0025000700063O00122O000800D33O00122O000900D46O0007000900024O00060006000700202O0006000600214O00060002000200062O000600B404013O000428012O00B404012O007A0006000D3O00060A000600B404013O000428012O00B404012O007A000600034O0025000700063O00122O000800D53O00122O000900D66O0007000900024O00060006000700202O0006000600244O00060002000200062O000600B404013O000428012O00B404012O007A000600034O0025000700063O00122O000800D73O00122O000900D86O0007000900024O00060006000700202O0006000600244O00060002000200062O000600B404013O000428012O00B404012O007A000600053O00205C0006000600254O000800033O00202O0008000800284O00060008000200062O000600B404013O000428012O00B404012O007A000600034O002D010700063O00122O000800D93O00122O000900DA6O0007000900024O00060006000700202O00060006004C4O0006000200024O0007000E3O00202O00070007001C00062O000600B404010007000428012O00B404012O007A0006000C3O00205C0006000600514O000800033O00202O0008000800524O00060008000200062O000600B404013O000428012O00B404012O007A0006000B4O00C8000700033O00202O00070007005C4O0008000C3O00202O00080008005D4O000A000F6O0008000A00024O000800086O00060008000200062O000600B404013O000428012O00B404012O007A000600063O0012CD000700DB3O0012CD000800DC4O0028000600084O006A00066O007A000600034O0025000700063O00122O000800DD3O00122O000900DE6O0007000900024O00060006000700202O0006000600214O00060002000200062O000600F204013O000428012O00F204012O007A000600073O00060A000600F204013O000428012O00F204012O007A000600083O00060A000600F204013O000428012O00F204012O007A000600053O00205C0006000600274O000800033O00202O0008000800284O00060008000200062O000600F204013O000428012O00F204012O007A000600034O0031000700063O00122O000800DF3O00122O000900E06O0007000900024O00060006000700202O0006000600E14O00060002000200262O000600DC0401001C000428012O00DC04012O007A0006000C3O0020150106000600514O000800033O00202O0008000800524O00060008000200062O000600F404010001000428012O00F404012O007A000600053O00200F0106000600E200122O000800026O000900033O00202O0009000900E34O00060009000200062O000600F204013O000428012O00F204012O007A000600053O00205C0006000600274O000800033O00202O0008000800264O00060008000200062O000600F204013O000428012O00F204012O007A000600053O0020F900060006002D4O000800033O00202O0008000800264O00060008000200262O000600F40401002C000428012O00F40401002E1200E4002O050100E5000428012O002O05012O007A0006000B4O0090000700033O00202O0007000700344O0008000C3O00202O0008000800354O000A00033O00202O000A000A00364O0008000A00024O000800086O00060008000200062O0006002O05013O000428012O002O05012O007A000600063O0012CD000700E63O0012CD000800E74O0028000600084O006A00066O007A000600034O0025000700063O00122O000800E83O00122O000900E96O0007000900024O00060006000700202O0006000600214O00060002000200062O0006003F05013O000428012O003F05012O007A000600233O0020450006000600EA2O008D0006000100020026150006003F05010040000428012O003F05012O007A000600034O0025000700063O00122O000800EB3O00122O000900EC6O0007000900024O00060006000700202O0006000600244O00060002000200062O0006002C05013O000428012O002C05012O007A000600053O00205C0006000600274O000800033O00202O00080008003D4O00060008000200062O0006003F05013O000428012O003F05012O007A0006000C3O00205C0006000600514O000800033O00202O0008000800524O00060008000200062O0006003F05013O000428012O003F0501002EF500ED0013000100ED000428012O003F05012O007A000600244O0090000700033O00202O0007000700EE4O0008000C3O00202O0008000800354O000A00033O00202O000A000A00EE4O0008000A00024O000800086O00060008000200062O0006003F05013O000428012O003F05012O007A000600063O0012CD000700EF3O0012CD000800F04O0028000600084O006A00066O007A000600034O0025000700063O00122O000800F13O00122O000900F26O0007000900024O00060006000700202O0006000600214O00060002000200062O0006009C05013O000428012O009C05012O007A0006000D3O00060A0006009C05013O000428012O009C05012O007A000600034O0025000700063O00122O000800F33O00122O000900F46O0007000900024O00060006000700202O0006000600244O00060002000200062O0006009C05013O000428012O009C05012O007A000600034O0017000700063O00122O000800F53O00122O000900F66O0007000900024O00060006000700202O00060006002B4O0006000200024O0007000E3O00202O00070007001C00062O0006006905010007000428012O006905012O007A000600053O00205C0006000600274O000800033O00202O00080008003D4O00060008000200062O0006009C05013O000428012O009C05012O007A000600034O002D010700063O00122O000800F73O00122O000900F86O0007000900024O00060006000700202O00060006002B4O0006000200024O0007000E3O00202O00070007002C00062O0006009C05010007000428012O009C05012O007A000600053O00205C0006000600254O000800033O00202O0008000800284O00060008000200062O0006009C05013O000428012O009C05012O007A000600053O00205C0006000600254O000800033O00202O0008000800264O00060008000200062O0006009C05013O000428012O009C05012O007A0006000C3O00205C0006000600514O000800033O00202O0008000800524O00060008000200062O0006009C05013O000428012O009C05012O007A0006000B4O0088000700033O00202O00070007005C4O0008000C3O00202O00080008005D4O000A000F6O0008000A00024O000800086O00060008000200062O0006009705010001000428012O00970501002E1200F9009C050100FA000428012O009C05012O007A000600063O0012CD000700FB3O0012CD000800FC4O0028000600084O006A00065O0012CD0004001B3O0026E1000400A105010053000428012O00A10501002EB700FD004E000100FE000428012O004E00012O007A00065O000636000600A605010001000428012O00A60501002EF500FF000400012O00010428012O00A805012O007A00068O000600023O0012CD0006002O012O0012CD00070002012O00064D0107008E07010006000428012O008E07012O007A000600034O0025000700063O00122O00080003012O00122O00090004015O0007000900024O00060006000700202O0006000600244O00060002000200062O0006008E07013O000428012O008E07012O007A0006000B4O00AF000700033O00122O00080005015O0007000700084O00060002000200062O0006008E07013O000428012O008E07012O007A000600063O0012D900070006012O00122O00080007015O000600086O00065O00044O008E0701000428012O004E0001000428012O008E07010012CD00060008012O0012CD00070009012O00064F0107004A00010006000428012O004A00010012CD000600013O0006370103004A00010006000428012O004A00010012CD000400014O00DA000500053O0012CD000300023O000428012O004A0001000428012O008E07010012CD0003002C3O0006FF000200D805010003000428012O00D805010012CD0003000A012O0012CD0004000B012O0006370103003906010004000428012O003906010012CD000300013O0012CD000400023O0006370103001606010004000428012O001606012O007A000400253O00060A000400FF05013O000428012O00FF05010012CD000400014O00DA000500053O0012CD000600013O000637010600E105010004000428012O00E105010012CD000500013O0012CD0006000C012O0012CD0007000D012O00064D010600E505010007000428012O00E505010012CD000600013O000637010500E505010006000428012O00E505012O007A000600264O0004000600063O0012CD000700013O00064F010700F505010006000428012O00F505012O007A000600264O0004000600063O000636000600F605010001000428012O00F605010012CD000600024O003C000600114O007A000600284O0004000600064O003C000600273O000428012O00140601000428012O00E50501000428012O00140601000428012O00E10501000428012O001406010012CD000400014O00DA000500053O0012CD000600013O0006370104000106010006000428012O000106010012CD000500013O0012CD000600013O0006FF0005000C06010006000428012O000C06010012CD0006000E012O0012CD0007000F012O00064D0106000506010007000428012O000506010012CD000600024O003C000600113O0012CD000600024O003C000600273O000428012O00140601000428012O00050601000428012O00140601000428012O000106010012CD0002001B3O000428012O003906010012CD000400013O000637010300D905010004000428012O00D905010012CD000400013O0012CD000500023O0006FF0004002106010005000428012O002106010012CD00050010012O0012CD00060011012O00064F0106002306010005000428012O002306010012CD000300023O000428012O00D905010012CD00050012012O0012CD00060013012O00064F0105001A06010006000428012O001A06010012CD000500013O0006370104001A06010005000428012O001A06012O007A000500053O0012EE00070014015O0005000500074O0007000F6O0005000700024O000500266O000500053O00122O00070014015O00050005000700122O0007008A6O0005000700024O000500283O00122O000400023O00044O001A0601000428012O00D905010012CD0003001B3O000637010200BE06010003000428012O00BE06010012CD000300013O0012CD000400013O000637010300B106010004000428012O00B106010012CD000400013O0012CD000500013O0006FF0004004806010005000428012O004806010012CD00050015012O0012CD00060016012O000637010500A706010006000428012O00A706012O007A000500094O00F6000600053O00202O00060006007D4O00060002000200122O00070017015O0005000700024O0006000A6O000700053O00202O00070007007D4O00070002000200122O00080017013O00240006000800022O00430005000500064O0005000E6O000500023O00202O0005000500144O00050001000200062O0005006006010001000428012O006006012O007A000500053O0020C00005000500C52O004501050002000200060A000500A606013O000428012O00A606010012CD000500014O00DA000600063O0012CD00070018012O0012CD00080019012O00064D0107006206010008000428012O006206010012CD000700013O0006370105006206010007000428012O006206010012CD000600013O0012CD000700023O0006370106007A06010007000428012O007A06012O007A000700173O0012CD0008001A012O0006FF0007007206010008000428012O00720601000428012O00A606012O007A000700233O0012610008001B015O00070007000800122O0008001C015O00098O0007000900024O000700173O00044O00A606010012CD000700013O0006FF0006008106010007000428012O008106010012CD0007001D012O0012CD0008001E012O00064D0107006A06010008000428012O006A06010012CD000700013O0012CD000800023O0006370107008706010008000428012O008706010012CD000600023O000428012O006A06010012CD000800013O0006370107008206010008000428012O008206010012CD000800013O0012CD000900023O0006FF0008009206010009000428012O009206010012CD0009001F012O0012CD000A0020012O00064F010A009406010009000428012O009406010012CD000700023O000428012O008206010012CD000900013O0006370108008B06010009000428012O008B06012O007A000900233O0012AE000A0021015O00090009000A4O000A000A6O000B00016O0009000B00024O000900296O000900296O000900173O00122O000800023O00044O008B0601000428012O00820601000428012O006A0601000428012O00A60601000428012O006206010012CD000400023O0012CD00050022012O0012CD00060023012O00064F0105004106010006000428012O004106010012CD000500023O0006370104004106010005000428012O004106010012CD000300023O000428012O00B10601000428012O004106010012CD000400023O0006FF000300B806010004000428012O00B806010012CD00040024012O0012CD00050025012O00064D0104003D06010005000428012O003D06012O007A0004002A4O008D0004000100022O003C00045O0012CD000200073O000428012O00BE0601000428012O003D06010012CD000300013O000637010200E106010003000428012O00E106010012CD000300014O00DA000400043O0012CD000500013O0006FF000300CA06010005000428012O00CA06010012CD00050026012O0012CD0006001A3O00064F010500C306010006000428012O00C306010012CD000400013O0012CD000500013O000637010400D306010005000428012O00D306012O007A0005002B4O00190005000100012O007A0005002C4O00190005000100010012CD000400023O0012CD000500023O0006FF000400DA06010005000428012O00DA06010012CD00050027012O0012CD00060028012O00064D010600CB06010005000428012O00CB06012O007A0005002D4O00190005000100010012CD000200023O000428012O00E10601000428012O00CB0601000428012O00E10601000428012O00C306010012CD000300023O0006370102002907010003000428012O002907010012CD000300013O0012CD000400013O0006370104001307010003000428012O001307010012CD000400013O0012CD000500013O0006FF000400F006010005000428012O00F006010012CD00050029012O0012CD0006002A012O00064F0105000907010006000428012O000907010012F40005002B013O0057000600063O00122O0007002C012O00122O0008002D015O0006000800024O0005000500064O000600063O00122O0007002E012O00122O0008002F015O0006000800024O0005000500064O0005002E3O00122O0005002B015O000600063O00122O00070030012O00122O00080031015O0006000800024O0005000500064O000600063O00122O00070032012O00122O00080033015O0006000800024O0005000500064O000500253O00122O000400023O0012CD00050034012O0012CD00060035012O00064D010500E906010006000428012O00E906010012CD000500023O000637010400E906010005000428012O00E906010012CD000300023O000428012O00130701000428012O00E906010012CD00040036012O0012CD00050036012O000637010400E506010005000428012O00E506010012CD000400023O000637010300E506010004000428012O00E506010012F40004002B013O00F8000500063O00122O00060037012O00122O00070038015O0005000700024O0004000400054O000500063O00122O00060039012O00122O0007003A015O0005000700024O0004000400054O0004002F3O00122O0002001C3O00044O00290701000428012O00E506010012CD0003003B012O0012CD0004003C012O00064F0103000B00010004000428012O000B00010012CD0003001C3O0006370102000B00010003000428012O000B00010012CD000300014O00DA000400043O0012CD0005003D012O0012CD0006003E012O00064D0106003207010005000428012O003207010012CD000500013O0006370103003207010005000428012O003207010012CD000400013O0012CD000500023O0006FF0004004107010005000428012O004107010012CD0005003F012O0012CD00060040012O00064D0105004F07010006000428012O004F07012O007A000500034O0025000600063O00122O00070041012O00122O00080042015O0006000800024O00050005000600202O0005000500244O00050002000200062O0005004D07013O000428012O004D07010012CD000500404O003C0005000F3O0012CD0002002C3O000428012O000B00010012CD00050043012O0012CD00060044012O00064F0105003A07010006000428012O003A07010012CD000500013O0006370104003A07010005000428012O003A07010012CD000500013O0012CD00060045012O0012CD00070046012O00064D0107006007010006000428012O006007010012CD000600023O0006370106006007010005000428012O006007010012CD000400023O000428012O003A07010012CD000600013O0006370105005707010006000428012O005707010012F40006002B013O001C010700063O00122O00080047012O00122O00090048015O0007000900024O0006000600074O000700063O00122O00080049012O00122O0009004A015O0007000900024O0006000600072O003C000600074O0020000600053O00122O0008004B015O0006000600084O00060002000200062O0006007907010001000428012O007907010012CD0006004C012O0012CD0007004D012O0006370106007A07010007000428012O007A07012O003A3O00013O0012CD000500023O000428012O00570701000428012O003A0701000428012O000B0001000428012O00320701000428012O000B0001000428012O008E0701000428012O00060001000428012O008E07010012CD000300013O0006FF3O008A07010003000428012O008A07010012CD0003004E012O0012CD0004004F012O00064F0104000200010003000428012O000200010012CD000100014O00DA000200023O0012CD3O00023O000428012O000200012O003A3O00017O00093O00028O00025O00E7B140025O0093B14003123O00DA1DD753CBF60FF252D7F60CE158C0ED0EC303053O00A29868A53D03143O00526567697374657241757261547261636B696E6703053O005072696E7403313O00E52EA47273A5E92ABF727EA5E53ABC6975F78D2DAB3D55F5C42CFC3D43F0DD3FBD6F64E0C96FB06430FDE62EBC7864EA8303063O0085AD4FD21D10001D3O0012CD3O00014O00DA000100013O002EB70003000200010002000428012O000200010026793O000200010001000428012O000200010012CD000100013O0026790001000700010001000428012O000700012O007A00026O0072000300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O0002000200014O000200023O00202O0002000200074O000300013O00122O000400083O00122O000500096O000300056O00023O000100044O001C0001000428012O00070001000428012O001C0001000428012O000200012O003A3O00017O00", GetFEnv(), ...);

