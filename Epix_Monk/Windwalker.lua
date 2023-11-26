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
				if (Enum <= 162) then
					if (Enum <= 80) then
						if (Enum <= 39) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
												if Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 2) then
											if (Stk[Inst[2]] <= Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 3) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 6) then
										if (Enum == 5) then
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
									elseif (Enum <= 7) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 8) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										do
											return;
										end
									end
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum == 10) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										end
									elseif (Enum <= 12) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum == 13) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Inst[2] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 16) then
									if (Enum > 15) then
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
									end
								elseif (Enum <= 17) then
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
								elseif (Enum == 18) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum > 20) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 22) then
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
									elseif (Enum == 23) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local T;
										local Edx;
										local Results, Limit;
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
										T = Stk[A];
										for Idx = A + 1, Top do
											Insert(T, Stk[Idx]);
										end
									end
								elseif (Enum <= 26) then
									if (Enum == 25) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 27) then
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 28) then
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum == 30) then
										local B;
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
										A = Inst[2];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
									end
								elseif (Enum <= 32) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 33) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 36) then
								if (Enum == 35) then
									do
										return;
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
							elseif (Enum <= 37) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 38) then
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
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							end
						elseif (Enum <= 59) then
							if (Enum <= 49) then
								if (Enum <= 44) then
									if (Enum <= 41) then
										if (Enum > 40) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										end
									elseif (Enum <= 42) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 43) then
										local A = Inst[2];
										Stk[A] = Stk[A]();
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
								elseif (Enum <= 46) then
									if (Enum == 45) then
										local A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 47) then
									local B;
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
									A = Inst[2];
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
									do
										return;
									end
								elseif (Enum == 48) then
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
							elseif (Enum <= 54) then
								if (Enum <= 51) then
									if (Enum == 50) then
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
									end
								elseif (Enum <= 52) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 53) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 56) then
								if (Enum > 55) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								end
							elseif (Enum <= 57) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 58) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
						elseif (Enum <= 69) then
							if (Enum <= 64) then
								if (Enum <= 61) then
									if (Enum == 60) then
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
								elseif (Enum <= 62) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 63) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								end
							elseif (Enum <= 66) then
								if (Enum > 65) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								elseif (Stk[Inst[2]] == Inst[4]) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 68) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							end
						elseif (Enum <= 74) then
							if (Enum <= 71) then
								if (Enum > 70) then
									local B = Stk[Inst[4]];
									if B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
							elseif (Enum <= 72) then
								if (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 73) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 77) then
							if (Enum <= 75) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 76) then
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
									if (Mvm[1] == 168) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 78) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 79) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							do
								return;
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
					elseif (Enum <= 121) then
						if (Enum <= 100) then
							if (Enum <= 90) then
								if (Enum <= 85) then
									if (Enum <= 82) then
										if (Enum > 81) then
											local A = Inst[2];
											local T = Stk[A];
											for Idx = A + 1, Inst[3] do
												Insert(T, Stk[Idx]);
											end
										else
											local A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Top));
										end
									elseif (Enum <= 83) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 84) then
										local A;
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
									end
								elseif (Enum <= 87) then
									if (Enum == 86) then
										local B;
										local A;
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									end
								elseif (Enum <= 88) then
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
								elseif (Enum > 89) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 95) then
								if (Enum <= 92) then
									if (Enum > 91) then
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
								elseif (Enum <= 93) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 94) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 97) then
								if (Enum > 96) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									do
										return;
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
							elseif (Enum <= 98) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 99) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 110) then
							if (Enum <= 105) then
								if (Enum <= 102) then
									if (Enum > 101) then
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 103) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 104) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 107) then
								if (Enum > 106) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 108) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 109) then
								Stk[Inst[2]] = {};
							else
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 115) then
							if (Enum <= 112) then
								if (Enum == 111) then
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
									do
										return;
									end
								end
							elseif (Enum <= 113) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							elseif (Enum > 114) then
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 118) then
							if (Enum <= 116) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
							elseif (Enum == 117) then
								local Edx;
								local Results;
								local A;
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
						elseif (Enum <= 119) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 120) then
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
						end
					elseif (Enum <= 141) then
						if (Enum <= 131) then
							if (Enum <= 126) then
								if (Enum <= 123) then
									if (Enum == 122) then
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
									end
								elseif (Enum <= 124) then
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
								elseif (Enum > 125) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 128) then
								if (Enum == 127) then
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
							elseif (Enum <= 129) then
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
							elseif (Enum > 130) then
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
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 136) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 134) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 138) then
							if (Enum > 137) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
						elseif (Enum == 140) then
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
					elseif (Enum <= 151) then
						if (Enum <= 146) then
							if (Enum <= 143) then
								if (Enum > 142) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum <= 144) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 145) then
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
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 148) then
							if (Enum > 147) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							else
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							end
						elseif (Enum <= 149) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 150) then
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
					elseif (Enum <= 156) then
						if (Enum <= 153) then
							if (Enum == 152) then
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
							end
						elseif (Enum <= 154) then
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
						elseif (Enum > 155) then
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
					elseif (Enum <= 159) then
						if (Enum <= 157) then
							Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
						elseif (Enum > 158) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[A] = Stk[A]();
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
							Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 160) then
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
					elseif (Enum > 161) then
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
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 244) then
					if (Enum <= 203) then
						if (Enum <= 182) then
							if (Enum <= 172) then
								if (Enum <= 167) then
									if (Enum <= 164) then
										if (Enum > 163) then
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
											do
												return Stk[Inst[2]];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											do
												return;
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										end
									elseif (Enum <= 165) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 166) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 169) then
									if (Enum > 168) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]];
									end
								elseif (Enum <= 170) then
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif (Enum == 171) then
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
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 177) then
								if (Enum <= 174) then
									if (Enum == 173) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 175) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
								elseif (Enum == 176) then
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
							elseif (Enum <= 179) then
								if (Enum == 178) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									do
										return;
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
							elseif (Enum <= 180) then
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
							elseif (Enum > 181) then
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							end
						elseif (Enum <= 192) then
							if (Enum <= 187) then
								if (Enum <= 184) then
									if (Enum > 183) then
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
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
								elseif (Enum <= 185) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif (Enum == 186) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
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
							elseif (Enum <= 189) then
								if (Enum > 188) then
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
							elseif (Enum <= 190) then
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
							elseif (Enum == 191) then
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
							end
						elseif (Enum <= 197) then
							if (Enum <= 194) then
								if (Enum == 193) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 195) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 196) then
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
						elseif (Enum <= 200) then
							if (Enum <= 198) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum > 199) then
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
						elseif (Enum > 202) then
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 223) then
						if (Enum <= 213) then
							if (Enum <= 208) then
								if (Enum <= 205) then
									if (Enum == 204) then
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
									end
								elseif (Enum <= 206) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 207) then
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
								else
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 210) then
								if (Enum == 209) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								end
							elseif (Enum <= 211) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
							elseif (Enum > 212) then
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
						elseif (Enum <= 218) then
							if (Enum <= 215) then
								if (Enum > 214) then
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
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
								end
							elseif (Enum <= 216) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 217) then
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
							end
						elseif (Enum <= 220) then
							if (Enum > 219) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Top do
									Insert(T, Stk[Idx]);
								end
							end
						elseif (Enum <= 221) then
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
						elseif (Enum == 222) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 233) then
						if (Enum <= 228) then
							if (Enum <= 225) then
								if (Enum == 224) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
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
							elseif (Enum <= 226) then
								Env[Inst[3]] = Stk[Inst[2]];
							elseif (Enum == 227) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 230) then
							if (Enum == 229) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 231) then
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
						elseif (Enum > 232) then
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
							Stk[Inst[2]] = Inst[3] ~= 0;
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 238) then
						if (Enum <= 235) then
							if (Enum > 234) then
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
						elseif (Enum <= 236) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 241) then
						if (Enum <= 239) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 240) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 242) then
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
					elseif (Enum > 243) then
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
				elseif (Enum <= 285) then
					if (Enum <= 264) then
						if (Enum <= 254) then
							if (Enum <= 249) then
								if (Enum <= 246) then
									if (Enum == 245) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 247) then
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
								elseif (Enum > 248) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 251) then
								if (Enum == 250) then
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
								end
							elseif (Enum <= 252) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 253) then
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
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 259) then
							if (Enum <= 256) then
								if (Enum == 255) then
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
							elseif (Enum <= 257) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 258) then
								local Edx;
								local Results, Limit;
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 261) then
							if (Enum == 260) then
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
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 262) then
							local B;
							local A;
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
						elseif (Enum > 263) then
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
					elseif (Enum <= 274) then
						if (Enum <= 269) then
							if (Enum <= 266) then
								if (Enum == 265) then
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
							elseif (Enum <= 267) then
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
							elseif (Enum > 268) then
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
						elseif (Enum <= 271) then
							if (Enum > 270) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 273) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						else
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
						end
					elseif (Enum <= 279) then
						if (Enum <= 276) then
							if (Enum == 275) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 277) then
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
							if Stk[Inst[2]] then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Stk[Inst[2]] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 282) then
						if (Enum <= 280) then
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 281) then
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
					elseif (Enum <= 283) then
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
					elseif (Enum == 284) then
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
				elseif (Enum <= 305) then
					if (Enum <= 295) then
						if (Enum <= 290) then
							if (Enum <= 287) then
								if (Enum == 286) then
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
							elseif (Enum <= 288) then
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
							elseif (Enum > 289) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 292) then
							if (Enum > 291) then
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							local B;
							local A;
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 294) then
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
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 300) then
						if (Enum <= 297) then
							if (Enum == 296) then
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							end
						elseif (Enum <= 298) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A]());
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 299) then
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
					elseif (Enum <= 302) then
						if (Enum > 301) then
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
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 303) then
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
					elseif (Enum > 304) then
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
					end
				elseif (Enum <= 315) then
					if (Enum <= 310) then
						if (Enum <= 307) then
							if (Enum > 306) then
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 308) then
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
						elseif (Enum == 309) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Inst[2] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 312) then
						if (Enum == 311) then
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 313) then
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 314) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					end
				elseif (Enum <= 320) then
					if (Enum <= 317) then
						if (Enum > 316) then
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
					elseif (Enum <= 318) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 319) then
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
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 323) then
					if (Enum <= 321) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 322) then
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
				elseif (Enum <= 324) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum == 325) then
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
					A = Inst[2];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!493O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403063O00506C6179657203063O0054617267657403053O00466F63757303093O004D6F7573656F7665722O033O0050657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03043O004361737403053O004D6163726F03053O005072652O7303053O005574696C7303053O00706169727303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03043O004D6F6E6B030A3O0057696E6477616C6B657203113O00416C67657468617250752O7A6C65426F7803023O00494403113O00426561636F6E746F7468654265796F6E6403073O00446A61722O756E03173O00447261676F6E66697265426F6D6244697370656E73657203153O004572757074696E675370656172467261676D656E74030F3O0049726964657573467261676D656E74030F3O004D616E69634772696566746F726368024O0080B3C54003083O00536572656E697479030B3O004973417661696C61626C65026O00F03F027O004003083O004C656753772O657003153O005FBDECA97850B9F8FD0B6BB9FAAD78348FEBA8363503053O00581CDC9FDD030B3O0052696E674F66506561636503193O00F1B5EBC441E0BDF6D741FDB2B8E004D3B7FD9049E1A0EDDE4803053O0061B2D498B003093O00506172616C7973697303153O00EEE60EEF5AFDE60FFA16D4F414E85A85D409EE148403053O007AAD877D9B028O00030C3O0047657445717569706D656E74026O002A40026O002C4003103O005265676973746572466F724576656E7403243O00A5E234900914F7B4ED21801A03F7B7F1259A1610E4ADFB218D161EE6BBE228981116EDA003073O00A8E4A160D95F5103143O00EBFD0F650A65E4E30B7B0A79E4F4007D0D7BFEF503063O0037BBB14E3C4F030E3O001EFE7AC76AFCBF0EE67EC561EAA403073O00E04DAE3F8B26AF03143O00A864791CAA647C11B7717D02A87E7100BB75790C03043O004EE4213803183O00FE52933AA0FC419732B0E74E9F26ABFA41912BA4E059972703053O00E5AE1ED26303063O0053657441504C025O00D07040009C022O00129B3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004A23O000A00010012E0000300063O0020350004000300070012E0000500083O0020350005000500090012E0000600083O00203500060006000A00064C00073O000100062O00A83O00064O00A88O00A83O00044O00A83O00014O00A83O00024O00A83O00054O00180008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000D001000202O000F000D001100202O0010000D001200202O0011000D001300202O0012000D001400202O0013000B001500202O0014000B001600202O0015000B001700122O0016000D3O00202O00170016001800202O00180016001900202O00190016001A00202O001A000B001B00122O001B001C3O00202O001C0016001D00202O001C001C001E00202O001C001C001F00202O001D0016001D00202O001D001D001E00202O001D001D00204O001E8O001F8O00208O00218O00228O0023003C3O00202O003D0013002100202O003D003D002200202O003E0015002100202O003E003E002200202O003F0018002100202O003F003F00224O004000063O00202O0041003E002300202O0041004100244O00410002000200202O0042003E002500202O0042004200244O00420002000200202O0043003E002600202O0043004300244O00430002000200202O0044003E002700202O0044004400244O00440002000200202O0045003E002800202O0045004500244O00450002000200202O0046003E002900202O0046004600244O00460002000200202O0047003E002A00202O0047004700244O004700486O00403O00012O00B8004100433O0012E90044002B3O00122O0045002B6O004600466O00478O00488O00498O004A8O004B8O004C5O00202O004D003D002C002011014D004D002D2O002D004D00020002000639014D006500013O0004A23O00650001001232004D002E3O000692004D0066000100010004A23O00660001001232004D002F4O006D004E00034O000B004F00033O00202O0050003D00304O005100073O00122O005200313O00122O005300326O005100530002000293005200014O0087004F000300012O006D005000033O0020280051003D00334O005200073O00122O005300343O00122O005400356O005200540002000293005300024O00870050000300012O006D005100033O0020280052003D00364O005300073O00122O005400373O00122O005500386O005300550002000293005400034O00870051000300012O0087004E000300012O0004014F5O001291005000393O00202O0051000E003A4O00510002000200202O00520051003B00062O0052008C00013O0004A23O008C00012O00A8005200153O00203500530051003B2O002D0052000200020006920052008F000100010004A23O008F00012O00A8005200153O001232005300394O002D00520002000200203500530051003C0006390153009700013O0004A23O009700012O00A8005300153O00203500540051003C2O002D0053000200020006920053009A000100010004A23O009A00012O00A8005300153O001232005400394O002D00530002000200203500540016001D00203500540054001E00203500550016001D00203500550055002100064C00560004000100022O00A83O00544O00A83O001A3O0020110157000B003D00064C00590005000100012O00A83O00564O000D015A00073O00122O005B003E3O00122O005C003F6O005A005C6O00573O00010020110157000B003D00064C00590006000100032O00A83O00454O00A83O00504O00A83O00444O000D015A00073O00122O005B00403O00122O005C00416O005A005C6O00573O00010020110157000B003D00064C00590007000100022O00A83O004D4O00A83O003D4O00F2005A00073O00122O005B00423O00122O005C00436O005A005C00024O005B00073O00122O005C00443O00122O005D00456O005B005D6O00573O000100202O0057000B003D00064C00590008000100052O00A83O00534O00A83O00514O00A83O00154O00A83O000E4O00A83O00524O000D015A00073O00122O005B00463O00122O005C00476O005A005C6O00573O000100064C00570009000100012O00A83O000E3O00064C0058000A000100012O00A83O000E3O00064C0059000B000100012O00A83O000E3O00064C005A000C000100032O00A83O001B4O00A83O00424O00A83O003D3O00064C005B000D000100042O00A83O003D4O00A83O005A4O00A83O001C4O00A83O000E3O00064C005C000E000100032O00A83O00434O00A83O003D4O00A83O005A3O00064C005D000F000100072O00A83O001B4O00A83O00414O00A83O003D4O00A83O000E4O00A83O001A4O00A83O00074O00A83O000F3O00064C005E0010000100042O00A83O001B4O00A83O00424O00A83O001A4O00A83O00073O00064C005F0011000100012O00A83O003D3O00064C00600012000100022O00A83O003D4O00A83O001C3O00064C00610013000100032O00A83O003D4O00A83O001C4O00A83O000F3O00064C00620014000100032O00A83O003D4O00A83O001C4O00A83O005C3O00064C00630015000100012O00A83O003D3O000293006400163O00064C00650017000100012O00A83O003D3O00064C00660018000100012O00A83O003D3O00064C00670019000100022O00A83O003D4O00A83O000E3O00064C0068001A000100012O00A83O003D3O00064C0069001B000100092O00A83O003D4O00A83O00214O00A83O003C4O00A83O00074O00A83O00194O00A83O003F4O00A83O000F4O00A83O000E4O00A83O00173O00064C006A001C000100132O00A83O003D4O00A83O00334O00A83O000E4O00A83O00344O00A83O00194O00A83O00074O00A83O00394O00A83O003A4O00A83O003E4O00A83O002B4O00A83O002C4O00A83O003F4O00A83O00284O00A83O002A4O00A83O00294O00A83O00354O00A83O00364O00A83O00374O00A83O00383O00064C006B001D000100102O00A83O004D4O00A83O00464O00A83O003D4O00A83O000E4O00A83O00544O00A83O00404O00A83O00214O00A83O000F4O00A83O003E4O00A83O00524O00A83O00534O00A83O00454O00A83O00194O00A83O003F4O00A83O00074O00A83O00243O00064C006C001E000100092O00A83O003D4O00A83O000E4O00A83O00194O00A83O000F4O00A83O00074O00A83O00214O00A83O003C4O00A83O003F4O00A83O00173O00064C006D001F000100102O00A83O003D4O00A83O00434O00A83O00544O00A83O00414O00A83O00074O00A83O00654O00A83O000F4O00A83O005C4O00A83O000E4O00A83O003B4O00A83O00194O00A83O003F4O00A83O00114O00A83O00594O00A83O00624O00A83O00603O00064C006E00200001001A2O00A83O003D4O00A83O00434O00A83O00454O00A83O003C4O00A83O00074O00A83O00194O00A83O003F4O00A83O000F4O00A83O00484O00A83O000E4O00A83O00174O00A83O005C4O00A83O00464O00A83O005B4O00A83O003B4O00A83O00114O00A83O006D4O00A83O00324O00A83O001F4O00A83O00204O00A83O005D4O00A83O00594O00A83O00544O00A83O00234O00A83O00184O00A83O00313O00064C006F0021000100162O00A83O00314O00A83O003D4O00A83O00454O00A83O00174O00A83O00074O00A83O000E4O00A83O00434O00A83O003C4O00A83O00194O00A83O003F4O00A83O000F4O00A83O00484O00A83O003B4O00A83O00114O00A83O00324O00A83O001F4O00A83O00204O00A83O005D4O00A83O00594O00A83O00544O00A83O00234O00A83O00183O00064C007000220001000D2O00A83O003D4O00A83O000F4O00A83O00174O00A83O00074O00A83O000E4O00A83O00544O00A83O00424O00A83O00654O00A83O00414O00A83O00594O00A83O00624O00A83O00194O00A83O003F3O00064C00710023000100112O00A83O003D4O00A83O00434O00A83O00594O00A83O000E4O00A83O00544O00A83O00414O00A83O00074O00A83O00624O00A83O000F4O00A83O005C4O00A83O00174O00A83O00614O00A83O00424O00A83O00654O00A83O00194O00A83O003F4O00A83O00673O00064C007200240001000F2O00A83O003D4O00A83O00544O00A83O00414O00A83O00074O00A83O00654O00A83O000F4O00A83O00594O00A83O00174O00A83O000E4O00A83O00194O00A83O003F4O00A83O00614O00A83O00624O00A83O005C4O00A83O00673O00064C00730025000100112O00A83O003D4O00A83O000E4O00A83O00544O00A83O00414O00A83O00074O00A83O00624O00A83O000F4O00A83O00594O00A83O00174O00A83O00654O00A83O00614O00A83O00424O00A83O00194O00A83O003F4O00A83O005C4O00A83O00674O00A83O00683O00064C00740026000100102O00A83O003D4O00A83O000F4O00A83O00174O00A83O00074O00A83O00594O00A83O00544O00A83O00414O00A83O00614O00A83O000E4O00A83O00624O00A83O00654O00A83O00684O00A83O00424O00A83O00194O00A83O003F4O00A83O00673O00064C00750027000100082O00A83O003D4O00A83O000F4O00A83O00174O00A83O00074O00A83O000E4O00A83O00194O00A83O003F4O00A83O00593O00064C007600280001000D2O00A83O003D4O00A83O000E4O00A83O00594O00A83O005C4O00A83O00174O00A83O000F4O00A83O00074O00A83O00544O00A83O00414O00A83O00624O00A83O00434O00A83O00654O00A83O00193O00064C007700290001000C2O00A83O003D4O00A83O000E4O00A83O00544O00A83O00414O00A83O00074O00A83O00624O00A83O000F4O00A83O00174O00A83O00594O00A83O00194O00A83O005C4O00A83O00653O00064C0078002A0001000E2O00A83O003D4O00A83O000E4O00A83O00174O00A83O000F4O00A83O00074O00A83O00544O00A83O00414O00A83O00624O00A83O00654O00A83O00594O00A83O00194O00A83O005C4O00A83O00454O00A83O00423O00064C0079002B0001000E2O00A83O003D4O00A83O00544O00A83O00414O00A83O00074O00A83O00654O00A83O000F4O00A83O000E4O00A83O00624O00A83O00174O00A83O00454O00A83O00594O00A83O00194O00A83O005B4O00A83O005F3O00064C007A002C000100092O00A83O003D4O00A83O000E4O00A83O00174O00A83O000F4O00A83O00074O00A83O00454O00A83O00194O00A83O00594O00A83O005B3O00064C007B002D0001000F2O00A83O003D4O00A83O000E4O00A83O00574O00A83O00454O00A83O00174O00A83O000F4O00A83O00074O00A83O00594O00A83O001C4O00A83O00544O00A83O00414O00A83O00604O00A83O00434O00A83O00194O00A83O00623O00064C007C002E000100112O00A83O003D4O00A83O00544O00A83O00414O00A83O00074O00A83O005F4O00A83O000F4O00A83O00594O00A83O000E4O00A83O00174O00A83O00434O00A83O005E4O00A83O00194O00A83O00204O00A83O00234O00A83O00184O00A83O005C4O00A83O005B3O00064C007D002F0001001B2O00A83O00274O00A83O00074O00A83O00284O00A83O00294O00A83O00244O00A83O00254O00A83O00264O00A83O00394O00A83O003A4O00A83O003B4O00A83O002D4O00A83O002E4O00A83O002F4O00A83O003C4O00A83O00234O00A83O00364O00A83O00374O00A83O00384O00A83O00304O00A83O00314O00A83O00324O00A83O002A4O00A83O002B4O00A83O002C4O00A83O00334O00A83O00344O00A83O00353O00064C007E0030000100332O00A83O000E4O00A83O002D4O00A83O003D4O00A83O00224O00A83O00544O00A83O001E4O00A83O00694O00A83O00114O00A83O003F4O00A83O00104O00A83O00194O00A83O00074O00A83O002F4O00A83O00304O00A83O00484O00A83O00454O00A83O00494O00A83O000F4O00A83O00464O00A83O007B4O00A83O00434O00A83O00774O00A83O00784O00A83O00794O00A83O007A4O00A83O000B4O00A83O006C4O00A83O006B4O00A83O006A4O00A83O00214O00A83O006E4O00A83O006F4O00A83O00704O00A83O00714O00A83O00744O00A83O00754O00A83O00724O00A83O00734O00A83O00764O00A83O00594O00A83O00424O00A83O00634O00A83O00664O00A83O001C4O00A83O00414O00A83O00604O00A83O00174O00A83O00204O00A83O00444O00A83O001F4O00A83O007D3O00064C007F0031000100032O00A83O00074O00A83O00564O00A83O00163O0020DD00800016004800122O008100496O0082007E6O0083007F6O0080008300016O00013O00323O00023O00026O00F03F026O00704002264O001001025O00122O000300016O00045O00122O000500013O00042O0003002100012O008400076O0009000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004270003000500012O0084000300054O00A8000400024O0040000300044O00F300036O00233O00019O003O00034O0004012O00014O008E3O00024O00233O00019O003O00034O0004012O00014O008E3O00024O00233O00019O003O00034O0004012O00014O008E3O00024O00233O00017O00043O0003123O0044697370652O6C61626C65446562752O6673030A3O004D657267655461626C6503183O0044697370652O6C61626C65506F69736F6E446562752O667303193O0044697370652O6C61626C6544697365617365446562752O6673000A4O00089O00000100013O00202O0001000100024O00025O00202O0002000200034O00035O00202O0003000300044O00010003000200104O000100016O00019O003O00034O00848O00F03O000100012O00233O00017O00033O00028O00026O00F03F024O0080B3C540000F3O0012323O00013O0026413O0006000100020004A23O00060001001232000100034O00AF00015O0004A23O000E00010026413O0001000100010004A23O00010001001232000100014O00CF000100013O00122O000100036O000100023O00124O00023O00044O000100012O00233O00017O00043O0003083O00536572656E697479030B3O004973417661696C61626C65026O00F03F027O0040000C4O00F73O00013O00206O000100206O00026O0002000200064O000900013O0004A23O000900010012323O00033O0006923O000A000100010004A23O000A00010012323O00044O00AF8O00233O00017O00053O00028O00026O00F03F026O002C40030C3O0047657445717569706D656E74026O002A4000293O0012323O00013O0026413O0012000100020004A23O001200012O0084000100013O0020350001000100030006392O01000D00013O0004A23O000D00012O0084000100024O0084000200013O0020350002000200032O002D00010002000200069200010010000100010004A23O001000012O0084000100023O001232000200014O002D0001000200022O00AF00015O0004A23O002800010026413O0001000100010004A23O000100012O0084000100033O00200C2O01000100044O0001000200024O000100016O000100013O00202O00010001000500062O0001002200013O0004A23O002200012O0084000100024O0084000200013O0020350002000200052O002D00010002000200069200010025000100010004A23O002500012O0084000100023O001232000200014O002D0001000200022O00AF000100043O0012323O00023O0004A23O000100012O00233O00017O00063O0003043O006D61746803053O00666C2O6F7203183O00456E6572677954696D65546F4D6178507265646963746564026O002440026O00E03F029O000C3O00121E3O00013O00206O00024O00015O00202O0001000100034O00010002000200202O00010001000400202O00010001000500202O0001000100066O0002000200206O00042O008E3O00024O00233O00017O00043O0003043O006D61746803053O00666C2O6F72030F3O00456E65726779507265646963746564026O00E03F00093O00122F3O00013O00206O00024O00015O00202O0001000100034O00010002000200202O0001000100046O00019O008O00017O00023O0003073O0050726576474344026O00F03F01084O00A400015O00202O00010001000100122O000300026O00048O0001000400024O000100016O000100028O00017O00063O00028O00026O00F03F03083O00446562752O66557003143O004D61726B6F667468654372616E65446562752O66030E3O004D61726B6F667468654372616E65030B3O004973417661696C61626C6500203O0012323O00014O00B8000100013O0026413O0012000100020004A23O001200012O008400026O0084000300014O00820002000200040004A23O000F00010020110107000600032O0084000900023O0020350009000900042O00420107000900020006390107000F00013O0004A23O000F000100203700010001000200063800020008000100020004A23O000800012O008E000100023O0026413O0002000100010004A23O000200012O0084000200023O0020350002000200050020110102000200062O002D0002000200020006920002001C000100010004A23O001C0001001232000200014O008E000200023O001232000100013O0012323O00023O0004A23O000200012O00233O00017O00103O00028O00027O0040026O00F03F030B3O004372616E65566F72746578030A3O0054616C656E7452616E6B029A5O99B93F026O000840030E3O004D61726B6F667468654372616E65030B3O004973417661696C61626C650200E0A3703D0AC73F03063O0042752O665570031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O66026O33D33F03083O0046617374462O6574029A5O99A93F026O001040003D3O0012323O00014O00B8000100033O000E360102001100013O0004A23O00110001000E1C00010009000100010004A23O000900012O00D20004000100030010940004000300042O00D20002000200042O008400045O00203F00040004000400202O0004000400054O00040002000200102O00040006000400102O0004000300044O00020002000400124O00073O0026413O001F000100010004A23O001F00012O008400045O0020350004000400080020110104000400092O002D0004000200020006920004001B000100010004A23O001B0001001232000400014O008E000400024O0084000400014O002B0004000100022O00A8000100043O0012323O00033O0026413O0024000100030004A23O00240001001232000200033O0012320003000A3O0012323O00023O0026413O0038000100070004A23O003800012O0084000400024O00AA000500033O00202O00050005000B4O00075O00202O00070007000C4O000500076O00043O000200102O0004000D000400102O0004000300044O0002000200044O00045O00203F00040004000E00202O0004000400054O00040002000200102O0004000F000400102O0004000300044O00020002000400124O00103O000E360110000200013O0004A23O000200012O008E000200023O0004A23O000200012O00233O00017O00053O00028O00026O00F03F026O001440030E3O004D61726B6F667468654372616E65030B3O004973417661696C61626C65001D3O0012323O00014O00B8000100013O0026413O000D000100020004A23O000D00012O008400025O00063C00020009000100010004A23O00090001000E480003000B000100010004A23O000B00012O0004010200014O008E000200024O000401026O008E000200023O000E362O01000200013O0004A23O000200012O0084000200013O0020350002000200040020110102000200052O002D00020002000200069200020017000100010004A23O001700012O0004010200014O008E000200024O0084000200024O002B0002000100022O00A8000100023O0012323O00023O0004A23O000200012O00233O00017O00143O00028O00026O00F03F03133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564030F3O00412O66656374696E67436F6D62617403073O00497344752O6D79030F3O00496D70546F7563686F664465617468030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765026O002E4003063O004865616C7468030B3O00436F6D70617265546869732O033O0016EC9E03073O00597B8DE6318D5D030C3O00546F7563686F66446561746803073O0049735265616479027O0040030A3O00432O6F6C646F776E557003063O0042752O665570031F3O0048692O64656E4D617374657273466F7262692O64656E546F75636842752O6600663O0012323O00014O00B8000100023O0026413O004C000100020004A23O004C00012O008400036O0084000400014O00820003000200050004A23O003C00010020110108000700032O002D0008000200020006920008003C000100010004A23O003C00010020110108000700042O002D0008000200020006920008003C000100010004A23O003C00010020110108000700052O002D00080002000200069200080018000100010004A23O001800010020110108000700062O002D0008000200020006390108003C00013O0004A23O003C00012O0084000800023O0020350008000800070020110108000800082O002D0008000200020006390108002200013O0004A23O002200010020110108000700092O002D000800020002002616010800290001000A0004A23O0029000100201101080007000B2O00060108000200024O000900033O00202O00090009000B4O00090002000200062O0008003C000100090004A23O003C00010006390102003700013O0004A23O003700012O0084000800043O0020F500080008000C4O000900053O00122O000A000D3O00122O000B000E6O0009000B000200202O000A0007000B4O000A000200024O000B00026O0008000B000200062O0008003C00013O0004A23O003C00012O00A8000800073O00201101090007000B2O002D0009000200022O00A8000200094O00A8000100083O00063800030008000100020004A23O000800010006392O01004B00013O0004A23O004B00012O0084000300063O0006CC0001004B000100030004A23O004B00012O0084000300023O00203500030003000F0020110103000300102O002D0003000200020006920003004B000100010004A23O004B00012O00B8000300034O008E000300023O0012323O00113O000E360111004F00013O0004A23O004F00012O008E000100023O0026413O0002000100010004A23O000200012O0084000300023O00203500030003000F0020110103000300122O002D00030002000200069200030060000100010004A23O006000012O0084000300033O0020EE0003000300134O000500023O00202O0005000500144O00030005000200062O00030060000100010004A23O006000012O00B8000300034O008E000300024O00B8000300034O00B8000200024O00A8000100033O0012323O00023O0004A23O000200012O00233O00017O000A3O00028O0003133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564030F3O00412O66656374696E67436F6D62617403073O00497344752O6D79030B3O00436F6D70617265546869732O033O00FE70EE03063O002A9311966C7003093O0054696D65546F446965026O00F03F00363O0012323O00014O00B8000100023O0026413O0031000100010004A23O003100012O00B8000300034O0075000200026O000100036O00038O000400016O00030002000500044O002E00010020110108000700022O002D0008000200020006920008002E000100010004A23O002E00010020110108000700032O002D0008000200020006920008002E000100010004A23O002E00010020110108000700042O002D0008000200020006920008001B000100010004A23O001B00010020110108000700052O002D0008000200020006390108002E00013O0004A23O002E00010006390102002900013O0004A23O002900012O0084000800023O0020F50008000800064O000900033O00122O000A00073O00122O000B00086O0009000B000200202O000A000700094O000A000200024O000B00026O0008000B000200062O0008002E00013O0004A23O002E00012O00A8000800073O0020110109000700092O002D0009000200022O00A8000200094O00A8000100083O0006380003000B000100020004A23O000B00010012323O000A3O0026413O00020001000A0004A23O000200012O008E000100023O0004A23O000200012O00233O00017O00023O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O6601063O00206100013O00014O00035O00202O0003000300024O000100036O00019O0000017O00053O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O6603083O00446562752O66557003183O00536B79726561636845786861757374696F6E446562752O66026O003440010E3O00207400013O00014O00035O00202O0003000300024O0001000300024O000200013O00202O00033O00034O00055O00202O0005000500044O000300056O00023O00020020570002000200052O00A30001000100022O008E000100024O00233O00017O00053O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O66030A3O00446562752O66446F776E03183O00536B79726561636845786861757374696F6E446562752O66026O003440010F3O0020CB00013O00014O00035O00202O0003000300024O0001000300024O000200016O000300023O00202O0003000300034O00055O00202O0005000500044O000300054O00C600023O00020020570002000200052O00A30001000100022O008E000100024O00233O00017O00053O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O6603093O0054696D65546F44696503123O00536B79726561636843726974446562752O66026O00344001143O00203A00013O00014O00035O00202O0003000300024O0001000300024O000200016O000300026O000300016O00023O000200202O00033O00034O00030002000200202O00043O00014O00065O00202O0006000600044O00040006000200202O0004000400054O0003000300044O0002000200034O0001000100024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O6601063O00206100013O00014O00035O00202O0003000300024O000100036O00019O0000017O00013O0003093O0054696D65546F44696501043O0020112O013O00012O0040000100024O00F300016O00233O00017O00023O00030D3O00446562752O6652656D61696E7303123O00536B79726561636843726974446562752O6601063O00206100013O00014O00035O00202O0003000300024O000100036O00019O0000017O00023O00030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O6601063O00206100013O00014O00035O00202O0003000300024O000100036O00019O0000017O00043O00030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66030B3O0042752O6652656D61696E7303133O0043612O6C746F446F6D696E616E636542752O66010F3O00207200013O00014O00035O00202O0003000300024O0001000300024O000200013O00202O0002000200034O00045O00202O0004000400044O00020004000200062O0002000C000100010004A23O000C00012O007800016O00042O0100014O008E000100024O00233O00017O00033O00030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66025O00804B40010A3O00203E2O013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004A23O000700012O007800016O00042O0100014O008E000100024O00233O00017O00213O00028O0003163O0053752O6D6F6E57686974655469676572537461747565030A3O0049734361737461626C6503063O003FAA2C66E2FA03063O00886FC64D1F87031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572030E3O004973496E4D656C2O6552616E6765026O00144003253O00111CAA5BB2EA28BE0A00B35382F01EAE071B9845A9E503BC0749B744B8E718A40008B316EF03083O00C96269C736DD847703063O009A1991320D2703073O00CCD96CE3416255031C3O0053752O6D6F6E57686974655469676572537461747565437572736F7203253O004DD6F8E823CE61D4FDEC38C561D7FCE229D261D0E1E438D55B83E5F729C351CEF7E438800C03063O00A03EA395854C03093O00457870656C4861726D03073O00497352656164792O033O0043686903063O004368694D6178026O00204003163O00D3B81D2ACFE9A80C3DCE96B01F2AC0D9AD0F2ED796F403053O00A3B6C06D4F026O00F03F03083O004368694275727374030C3O004661656C696E6553746F6D70030B3O004973417661696C61626C6503093O004973496E52616E6765026O00444003153O00372E09FFF7213413D4B5243405C3FA392401D4B56203053O0095544660A003073O004368695761766503143O003B0E04D22F071BE878161FE83B0900EF39124DB503043O008D58666D008F3O0012323O00013O0026413O0056000100010004A23O005600012O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O01003600013O0004A23O003600012O0084000100013O0006392O01003600013O0004A23O003600012O0084000100024O0013010200033O00122O000300043O00122O000400056O00020004000200062O00010024000100020004A23O002400012O0084000100044O002F010200053O00202O0002000200064O000300063O00202O00030003000700122O000500086O0003000500024O000300036O00010003000200062O0001003600013O0004A23O003600012O0084000100033O00123B000200093O00122O0003000A6O000100036O00015O00044O003600012O0084000100024O0013010200033O00122O0003000B3O00122O0004000C6O00020004000200062O00010036000100020004A23O003600012O0084000100044O0084000200053O00203500020002000D2O002D0001000200020006392O01003600013O0004A23O003600012O0084000100033O0012320002000E3O0012320003000F4O0040000100034O00F300016O008400015O0020350001000100100020112O01000100112O002D0001000200020006392O01005500013O0004A23O005500012O0084000100073O0020C80001000100124O0001000200024O000200073O00202O0002000200134O00020002000200062O00010055000100020004A23O005500012O0084000100084O009900025O00202O0002000200104O000300046O000500063O00202O00050005000700122O000700146O0005000700024O000500056O00010005000200062O0001005500013O0004A23O005500012O0084000100033O001232000200153O001232000300164O0040000100034O00F300015O0012323O00173O0026413O0001000100170004A23O000100012O008400015O0020350001000100180020112O01000100112O002D0001000200020006392O01007500013O0004A23O007500012O008400015O0020350001000100190020112O010001001A2O002D00010002000200069200010075000100010004A23O007500012O0084000100044O001D00025O00202O0002000200184O000300063O00202O00030003001B00122O0005001C6O0003000500024O000300036O000400016O00010004000200062O0001007500013O0004A23O007500012O0084000100033O0012320002001D3O0012320003001E4O0040000100034O00F300016O008400015O00203500010001001F0020112O01000100112O002D0001000200020006392O01008E00013O0004A23O008E00012O0084000100084O009900025O00202O00020002001F4O000300046O000500063O00202O00050005001B00122O0007001C6O0005000700024O000500056O00010005000200062O0001008E00013O0004A23O008E00012O0084000100033O00123B000200203O00122O000300216O000100036O00015O00044O008E00010004A23O000100012O00233O00017O001D3O00028O00026O00F03F030E3O00466F7274696679696E6742726577030A3O0049734361737461626C6503083O0042752O66446F776E030E3O0044616D70656E4861726D42752O6603103O004865616C746850657263656E74616765030F3O00955CD864133B4CC8BD548A5208384203083O00A1D333AA107A5D35030C3O0044692O667573654D61676963030D3O00DFA7B42EEEBDB768D6AFB521F803043O00489BCED2027O0040030B3O004865616C746873746F6E6503073O004973526561647903173O004E7F5502274E6940013D433A500B354374470725433A0703053O0053261A346E03193O006A1221545D042F4F5610676E5D162B4F5610677657032E495603043O002638774703173O0052656672657368696E674865616C696E67506F74696F6E03253O00E1EA5EC42045FBE656D1655EF6EE54DF2B51B3FF57C22C59FDAF5CD32353FDFC51C02016A703063O0036938F38B64503093O00457870656C4861726D030A3O00F399EF4CD396A9FE5BD203053O00BFB6E19F29030A3O0044616D70656E4861726D03123O00466F7274696679696E674272657742752O66030B3O000F1325458E898203133A5803073O00A24B724835EBE700C13O0012323O00013O0026413O003F000100020004A23O003F00012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002400013O0004A23O002400012O0084000100013O0006392O01002400013O0004A23O002400012O0084000100023O0020460001000100054O00035O00202O0003000300064O00010003000200062O0001002400013O0004A23O002400012O0084000100023O0020112O01000100072O002D0001000200022O0084000200033O00067A00010024000100020004A23O002400012O0084000100044O008400025O0020350002000200032O002D0001000200020006392O01002400013O0004A23O002400012O0084000100053O001232000200083O001232000300094O0040000100034O00F300016O008400015O00203500010001000A0020112O01000100042O002D0001000200020006392O01003E00013O0004A23O003E00012O0084000100063O0006392O01003E00013O0004A23O003E00012O0084000100023O0020112O01000100072O002D0001000200022O0084000200073O00067A0001003E000100020004A23O003E00012O0084000100044O008400025O00203500020002000A2O002D0001000200020006392O01003E00013O0004A23O003E00012O0084000100053O0012320002000B3O0012320003000C4O0040000100034O00F300015O0012323O000D3O0026413O00810001000D0004A23O008100012O0084000100083O00203500010001000E0020112O010001000F2O002D0001000200020006392O01005D00013O0004A23O005D00012O0084000100093O0006392O01005D00013O0004A23O005D00012O0084000100023O0020112O01000100072O002D0001000200022O00840002000A3O00067A0001005D000100020004A23O005D00012O0084000100044O00600002000B3O00202O00020002000E4O000300046O000500016O00010005000200062O0001005D00013O0004A23O005D00012O0084000100053O001232000200103O001232000300114O0040000100034O00F300016O00840001000C3O0006392O0100C000013O0004A23O00C000012O0084000100023O0020112O01000100072O002D0001000200022O00840002000D3O00067A000100C0000100020004A23O00C000012O00840001000E4O0013010200053O00122O000300123O00122O000400136O00020004000200062O000100C0000100020004A23O00C000012O0084000100083O0020350001000100140020112O010001000F2O002D0001000200020006392O0100C000013O0004A23O00C000012O0084000100044O00600002000B3O00202O0002000200144O000300046O000500016O00010005000200062O000100C000013O0004A23O00C000012O0084000100053O00123B000200153O00122O000300166O000100036O00015O00044O00C000010026413O0001000100010004A23O000100012O008400015O0020350001000100170020112O01000100042O002D0001000200020006392O01009D00013O0004A23O009D00012O00840001000F3O0006392O01009D00013O0004A23O009D00012O0084000100023O0020112O01000100072O002D0001000200022O0084000200103O00067A0001009D000100020004A23O009D00012O0084000100044O008400025O0020350002000200172O002D0001000200020006392O01009D00013O0004A23O009D00012O0084000100053O001232000200183O001232000300194O0040000100034O00F300016O008400015O00203500010001001A0020112O01000100042O002D0001000200020006392O0100BE00013O0004A23O00BE00012O0084000100113O0006392O0100BE00013O0004A23O00BE00012O0084000100023O0020460001000100054O00035O00202O00030003001B4O00010003000200062O000100BE00013O0004A23O00BE00012O0084000100023O0020112O01000100072O002D0001000200022O0084000200123O00067A000100BE000100020004A23O00BE00012O0084000100044O008400025O00203500020002001A2O002D0001000200020006392O0100BE00013O0004A23O00BE00012O0084000100053O0012320002001C3O0012320003001D4O0040000100034O00F300015O0012323O00023O0004A23O000100012O00233O00017O00693O00028O00026O00F03F03173O00496E766F6B655875656E54686557686974655469676572030B3O004973417661696C61626C6503063O0042752O665570030C3O00536572656E69747942752O66030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B6574030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66026O001440030E3O004661656C696E654861726D6F6E79030F3O00432O6F6C646F776E52656D61696E73026O003E4003083O00536572656E697479030C3O00432O6F6C646F776E446F776E03173O00447261676F6E66697265426F6D6244697370656E73657203123O004973457175692O706564416E645265616479030A3O0048617355736542752O6603083O00446562752O665570026O00244003023O004944030A3O005472696E6B6574546F7003093O004973496E52616E6765026O00474003253O00882E45E55C0C8A3556E76C00833146DD570B9F2C41EC40079E7C50F05A0C873950F11353D803063O0062EC5C248233030D3O005472696E6B6574426F2O746F6D03253O00A00B0DBD4AA6B339B61C33B84AA5B70FA0101FAA402OA635B65918A84CA6BE35B00A4CEB1103083O0050C4796CDA25C8D5030F3O0049726964657573467261676D656E74026O003940031C3O0009610B7B4E1B993F75107E4C038F0E67426B5907840B76166C0B5FDF03073O00EA6013621F2B6E031C3O000F0D5BC3A96798391940C6AB7F8E080B12D3BE7B850D1A46D4EC23DE03073O00EB667F32A7CC1203113O00416C67657468617250752O7A6C65426F7803083O0042752O66446F776E03273O0051ADF226502651B3CA3351344AADF01C462148E1E626562B5EA8E13A7B3A42A8FB28413A43E1A103063O004E30C195432403273O003112871D55381F92275125049A14440F1C8F0001231B921D4F390A99275522178E1344240DC04C03053O0021507EE07803153O004572757074696E675370656172467261676D656E74032B3O00E9BA16D448E5A604FB4FFCAD02D663EABA02C351E9A617844FE9BA06CA55F8B13CD04EE5A608C148FFE85503053O003C8CC863A4032B3O0082E61136B68EFA0319B197F105349D81E60521AF82FA1066B182E60128AB93ED3B32B08EFA0F23B694B45203053O00C2E7946446030F3O004D616E69634772696566746F726368026O000840027O004003243O004B4DCFAAF5F7415EC8A6F0DC495EC2ABB6DB435EC4ADFFDC5F73D5B1FFC64D49D5B0B69003063O00A8262CA1C39603243O008DFD8C7F33D7B10489F984623FFAB51EC0EF876435E6BF0299C3966439E6BD1394EFC22E03083O0076E09CE2165088D603113O00426561636F6E746F7468654265796F6E64025O0080464003283O0040EB58834DE066944DD14D8847D15B855BE1578402FD5C9247E050945BD14D924BE0528556FD19D803043O00E0228E3903283O00DCA2C4DE7CFF621AD198D1D576CE5F0BC7A8CBD933E2581CDBA9CCC96ACE491CD7A9CED867E21D5603083O006EBEC7A5BD13913D03073O00446A61722O756E030B3O0046697374736F6646757279026O002840026O00204003363O00DEE176FA9ED22OD467E187CBDBF948E78DF8CEE372D78ECBDEEE65D78DCBDBE672A898C2C8EE79E19FDEE5FF65E185CCDFFF64A8DA9503063O00A7BA8B1788EB03293O001EA7890A15BB8E0408B0B70F15B88A321EBC9B1D1FBB9B2O08F59B081C8A9C1F13BB83080EA6C85F4C03043O006D7AD5E803293O00EAE5A337E1F9A439FCF29D32E1FAA00FEAFEB120EBF9B135FCB7B135E8C8B622E7F9A935FAE4E262B803043O00508E97C203153O0053746F726D4561727468416E644669726542752O66031C3O000AD47E4806D3647305D4764B0EC3795843D265450DCD72581086251403043O002C63A617031C3O0075E5203236B16FC82F2432A371F2272273B06EFE273D36B06FB77B6E03063O00C41C9749565303233O00F20F2E1596501964CC133C0A98541D49F10C3150915D1E49E711201E895D0C65B3527F03083O001693634970E2387803233O00B979E5F099B074F0CA9DAD6FF8F98887772OEDCDAB70E4CA99AA7CECFE88AC66A2A4DB03053O00EDD815829503133O00496E766F6B65727344656C6967687442752O6603273O00875C4A4FA4C05085714C4FB5C84CBD484D5EB7C45B8C5A1F4CB5CF61965C5651BBCC4A912O0E0703073O003EE22E2O3FD0A903273O00E00B40930B042159DA0A45861E1F1058F718528E1A033B1EF61C53BC0B1F2650EE1C41905F5C7703083O003E857935E37F6D4F03203O001D153CFCD591A5021D37F3C2A1B0131C72E6D3A89D04063BFBDDABB6035460A503073O00C270745295B6CE03203O0034A94211C3DD092BA1491ED4ED1C3AA00C0BC5E4312DBA4516CBE71A2AE81E4803073O006E59C82C78A08203243O00A9C64A454C440459A4FC5F4E46753948B2CC454203593E4B94D7594F4D413E59B883191403083O002DCBA32B26232A5B03243O00D080DD2088A76BC68AE3378FAC6BD080C52C89AD14C180DA1C93BB5DDC8ED93794E9068003073O0034B2E5BC43E7C903313O00254B5116E2492D1E515908FB5D311E4E563BE354261E445C00F24E1C274D5109F21C3024476F10E5552D2A2O4417B70E7703073O004341213064973C030C3O004570696353652O74696E677303083O0053652O74696E677303133O00EBE8BEECE1D6E9A5DDE7FCE8A0DCFACBEEA1D603053O0093BF87CEB803093O00446F6E277420557365031B3O008929A8C8DB6CB59621A3C7CC5CA08720E6D5CA5ABC8F2DB2D2980103073O00D2E448C6A1B833031B3O003B48FD1970F1315BFA1575DA395BF01833DA2440FD1B76DA2509A103063O00AE5629937013007E062O0012323O00014O00B8000100013O0026413O0025060100020004A23O002506012O008400025O00264100020036030100020004A23O00360301001232000200013O0026410002004F2O0100020004A23O004F2O010006392O01007D06013O0004A23O007D0601001232000300013O0026410003008A000100020004A23O008A00012O0084000400013O00069200040018000100010004A23O001800012O0084000400023O0020350004000400030020110104000400042O002D00040002000200069200040041000100010004A23O004100012O0084000400033O0020460004000400054O000600023O00202O0006000600064O00040006000200062O0004004100013O0004A23O00410001001232000400013O000E3601020030000100040004A23O003000012O0084000500043O0020620005000500084O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005004100013O0004A23O004100010012E0000500074O008E000500023O0004A23O0041000100264100040020000100010004A23O002000012O0084000500043O00206200050005000A4O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005003F00013O0004A23O003F00010012E0000500074O008E000500023O001232000400023O0004A23O002000012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O000D0067000100040004A23O006700012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104006700013O0004A23O006700012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C0010007D060100040004A23O007D06012O0084000400023O0020350004000400110020110104000400122O002D0004000200020006390104007D06013O0004A23O007D06012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O000D0067000100040004A23O006700012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006920004007D060100010004A23O007D0601001232000400013O000E362O010078000100040004A23O007800012O0084000500043O00206200050005000A4O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005007700013O0004A23O007700010012E0000500074O008E000500023O001232000400023O000E3601020068000100040004A23O006800012O0084000500043O0020620005000500084O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005007D06013O0004A23O007D06010012E0000500074O008E000500023O0004A23O007D06010004A23O006800010004A23O007D06010026410003000D000100010004A23O000D00012O0084000400083O0020350004000400130020110104000400142O002D000400020002000639010400062O013O0004A23O00062O012O0084000400093O0020110104000400152O002D000400020002000692000400A9000100010004A23O00A900012O00840004000A3O0020110104000400152O002D000400020002000692000400A9000100010004A23O00A900012O0084000400073O0020EE0004000400164O000600023O00202O00060006000C4O00040006000200062O000400CF000100010004A23O00CF00012O0084000400023O00203500040004000E0020110104000400042O002D000400020002000639010400CF00013O0004A23O00CF00012O0084000400093O0020110104000400152O002D000400020002000692000400B3000100010004A23O00B300012O00840004000A3O0020110104000400152O002D000400020002000639010400CC00013O0004A23O00CC00012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C001700CC000100040004A23O00CC00012O0084000400023O0020350004000400110020110104000400122O002D000400020002000639010400CC00013O0004A23O00CC00012O0084000400073O0020EE0004000400164O000600023O00202O00060006000C4O00040006000200062O000400CF000100010004A23O00CF00012O0084000400023O00203500040004000E0020110104000400042O002D000400020002000639010400CF00013O0004A23O00CF00012O00840004000B3O00261B000400062O0100170004A23O00062O01001232000400013O002641000400D0000100010004A23O00D000012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006001300202O0006000600184O00060002000200062O000500EB000100060004A23O00EB00012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O0009001B6O0007000900024O000700076O00050007000200062O000500EB00013O0004A23O00EB00012O00840005000E3O0012320006001C3O0012320007001D4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006001300202O0006000600184O00060002000200062O000500062O0100060004A23O00062O012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O0009001B6O0007000900024O000700076O00050007000200062O000500062O013O0004A23O00062O012O00840005000E3O00123B0006001F3O00122O000700206O000500076O00055O00044O00062O010004A23O00D000012O0084000400083O0020350004000400210020110104000400142O002D0004000200020006390104004C2O013O0004A23O004C2O012O0084000400013O000692000400152O0100010004A23O00152O012O0084000400023O0020350004000400030020110104000400042O002D0004000200020006920004001C2O0100010004A23O001C2O012O0084000400033O0020EE0004000400054O000600023O00202O0006000600064O00040006000200062O0004001F2O0100010004A23O001F2O012O00840004000B3O00261B0004004C2O0100220004A23O004C2O01001232000400013O002641000400202O0100010004A23O00202O012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006002100202O0006000600184O00060002000200062O000500362O0100060004A23O00362O012O00840005000C4O00840006000D3O0020350006000600192O002D000500020002000639010500362O013O0004A23O00362O012O00840005000E3O001232000600233O001232000700244O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006002100202O0006000600184O00060002000200062O0005004C2O0100060004A23O004C2O012O00840005000C4O00840006000D3O00203500060006001E2O002D0005000200020006390105004C2O013O0004A23O004C2O012O00840005000E3O00123B000600253O00122O000700266O000500076O00055O00044O004C2O010004A23O00202O01001232000300023O0004A23O000D00010004A23O007D060100264100020008000100010004A23O000800010006392O01000B03013O0004A23O000B0301001232000300013O002641000300FF2O0100010004A23O00FF2O012O0084000400083O0020350004000400270020110104000400142O002D000400020002000639010400B02O013O0004A23O00B02O012O0084000400013O000692000400652O0100010004A23O00652O012O0084000400023O0020350004000400030020110104000400042O002D0004000200020006920004006C2O0100010004A23O006C2O012O0084000400033O0020EE0004000400284O000600023O00202O0006000600064O00040006000200062O0004006F2O0100010004A23O006F2O012O00840004000B3O00261B000400B02O0100220004A23O00B02O01001232000400013O002641000400702O0100010004A23O00702O012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006002700202O0006000600184O00060002000200062O000500902O0100060004A23O00902O012O00840005000A3O0020110105000500152O002D000500020002000692000500902O0100010004A23O00902O012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O000500902O013O0004A23O00902O012O00840005000E3O001232000600293O0012320007002A4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006002700202O0006000600184O00060002000200062O000500B02O0100060004A23O00B02O012O0084000500093O0020110105000500152O002D000500020002000692000500B02O0100010004A23O00B02O012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O000500B02O013O0004A23O00B02O012O00840005000E3O00123B0006002B3O00122O0007002C6O000500076O00055O00044O00B02O010004A23O00702O012O0084000400083O00203500040004002D0020110104000400142O002D000400020002000639010400FE2O013O0004A23O00FE2O012O0084000400033O0020460004000400054O000600023O00202O0006000600064O00040006000200062O000400FE2O013O0004A23O00FE2O01001232000400013O000E362O0100BE2O0100040004A23O00BE2O012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006002D00202O0006000600184O00060002000200062O000500DE2O0100060004A23O00DE2O012O00840005000A3O0020110105000500152O002D000500020002000692000500DE2O0100010004A23O00DE2O012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O000500DE2O013O0004A23O00DE2O012O00840005000E3O0012320006002E3O0012320007002F4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006002D00202O0006000600184O00060002000200062O000500FE2O0100060004A23O00FE2O012O0084000500093O0020110105000500152O002D000500020002000692000500FE2O0100010004A23O00FE2O012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O000500FE2O013O0004A23O00FE2O012O00840005000E3O00123B000600303O00122O000700316O000500076O00055O00044O00FE2O010004A23O00BE2O01001232000300023O002641000300542O0100020004A23O00542O012O0084000400083O0020350004000400320020110104000400142O002D0004000200020006390104008502013O0004A23O008502012O0084000400093O0020110104000400152O002D00040002000200069200040028020100010004A23O002802012O00840004000A3O0020110104000400152O002D00040002000200069200040028020100010004A23O002802012O0084000400033O0020460004000400284O000600023O00202O0006000600064O00040006000200062O0004002802013O0004A23O002802012O0084000400013O00069200040028020100010004A23O002802012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O0033004E020100040004A23O004E02012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104004E02013O0004A23O004E02012O0084000400093O0020110104000400152O002D00040002000200069200040032020100010004A23O003202012O00840004000A3O0020110104000400152O002D0004000200020006390104004B02013O0004A23O004B02012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C0010004B020100040004A23O004B02012O0084000400023O0020350004000400110020110104000400122O002D0004000200020006390104004B02013O0004A23O004B02012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O0034004E020100040004A23O004E02012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104004E02013O0004A23O004E02012O00840004000B3O00261B000400850201000D0004A23O00850201001232000400013O0026410004004F020100010004A23O004F02012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006003200202O0006000600184O00060002000200062O0005006A020100060004A23O006A02012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O0005006A02013O0004A23O006A02012O00840005000E3O001232000600353O001232000700364O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006003200202O0006000600184O00060002000200062O00050085020100060004A23O008502012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O0005008502013O0004A23O008502012O00840005000E3O00123B000600373O00122O000700386O000500076O00055O00044O008502010004A23O004F02012O0084000400083O0020350004000400390020110104000400142O002D0004000200020006390104000B03013O0004A23O000B03012O0084000400093O0020110104000400152O002D000400020002000692000400AC020100010004A23O00AC02012O00840004000A3O0020110104000400152O002D000400020002000692000400AC020100010004A23O00AC02012O0084000400033O0020460004000400284O000600023O00202O0006000600064O00040006000200062O000400AC02013O0004A23O00AC02012O0084000400013O000692000400AC020100010004A23O00AC02012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O003400D2020100040004A23O00D202012O0084000400023O00203500040004000E0020110104000400042O002D000400020002000639010400D202013O0004A23O00D202012O0084000400093O0020110104000400152O002D000400020002000692000400B6020100010004A23O00B602012O00840004000A3O0020110104000400152O002D000400020002000639010400CF02013O0004A23O00CF02012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C001000CF020100040004A23O00CF02012O0084000400023O0020350004000400110020110104000400122O002D000400020002000639010400CF02013O0004A23O00CF02012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O003400D2020100040004A23O00D202012O0084000400023O00203500040004000E0020110104000400042O002D000400020002000639010400D202013O0004A23O00D202012O00840004000B3O00261B0004000B030100170004A23O000B0301001232000400013O002641000400D3020100010004A23O00D302012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006003900202O0006000600184O00060002000200062O000500EE020100060004A23O00EE02012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O0009003A6O0007000900024O000700076O00050007000200062O000500EE02013O0004A23O00EE02012O00840005000E3O0012320006003B3O0012320007003C4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006003900202O0006000600184O00060002000200062O0005000B030100060004A23O000B03012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O0009003A6O0007000900024O000700076O00050007000200062O0005000B03013O0004A23O000B03012O00840005000E3O00123B0006003D3O00122O0007003E6O000500076O00055O00044O000B03010004A23O00D302010004A23O000B03010004A23O00542O012O00840003000F3O0006390103003303013O0004A23O003303012O0084000300083O00203500030003003F0020110103000300142O002D0003000200020006390103003303013O0004A23O003303012O0084000300023O00203500030003004000201101030003000F2O002D00030002000200261B00030020030100340004A23O002003012O0084000300023O00203500030003000300201101030003000F2O002D000300020002000E3101170023030100030004A23O002303012O00840003000B3O00261B00030033030100410004A23O003303012O00840003000C4O002F0104000D3O00202O00040004003F4O000500073O00202O00050005001A00122O000700426O0005000700024O000500056O00030005000200062O0003003303013O0004A23O003303012O00840003000E3O001232000400433O001232000500444O0040000300054O00F300035O001232000200023O0004A23O000800010004A23O007D0601001232000200013O000E3601020072040100020004A23O007204010006392O01007D06013O0004A23O007D0601001232000300013O002641000300F9030100010004A23O00F903012O0084000400083O0020350004000400130020110104000400142O002D000400020002000639010400B203013O0004A23O00B203012O0084000400093O0020110104000400152O002D0004000200020006920004005B030100010004A23O005B03012O00840004000A3O0020110104000400152O002D0004000200020006920004005B030100010004A23O005B03012O0084000400073O0020EE0004000400164O000600023O00202O00060006000C4O00040006000200062O0004007B030100010004A23O007B03012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104007B03013O0004A23O007B03012O0084000400093O0020110104000400152O002D00040002000200069200040065030100010004A23O006503012O00840004000A3O0020110104000400152O002D0004000200020006390104007803013O0004A23O007803012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C00170078030100040004A23O007803012O0084000400073O0020EE0004000400164O000600023O00202O00060006000C4O00040006000200062O0004007B030100010004A23O007B03012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104007B03013O0004A23O007B03012O00840004000B3O00261B000400B2030100170004A23O00B20301001232000400013O0026410004007C030100010004A23O007C03012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006001300202O0006000600184O00060002000200062O00050097030100060004A23O009703012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O0009001B6O0007000900024O000700076O00050007000200062O0005009703013O0004A23O009703012O00840005000E3O001232000600453O001232000700464O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006001300202O0006000600184O00060002000200062O000500B2030100060004A23O00B203012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O0009001B6O0007000900024O000700076O00050007000200062O000500B203013O0004A23O00B203012O00840005000E3O00123B000600473O00122O000700486O000500076O00055O00044O00B203010004A23O007C03012O0084000400083O0020350004000400210020110104000400142O002D000400020002000639010400F803013O0004A23O00F803012O0084000400013O000692000400C1030100010004A23O00C103012O0084000400023O0020350004000400030020110104000400042O002D000400020002000692000400C8030100010004A23O00C803012O0084000400033O0020EE0004000400054O000600023O00202O0006000600494O00040006000200062O000400CB030100010004A23O00CB03012O00840004000B3O00261B000400F8030100220004A23O00F80301001232000400013O002641000400CC030100010004A23O00CC03012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006002100202O0006000600184O00060002000200062O000500E2030100060004A23O00E203012O00840005000C4O00840006000D3O0020350006000600192O002D000500020002000639010500E203013O0004A23O00E203012O00840005000E3O0012320006004A3O0012320007004B4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006002100202O0006000600184O00060002000200062O000500F8030100060004A23O00F803012O00840005000C4O00840006000D3O00203500060006001E2O002D000500020002000639010500F803013O0004A23O00F803012O00840005000E3O00123B0006004C3O00122O0007004D6O000500076O00055O00044O00F803010004A23O00CC0301001232000300023O000E360102003C030100030004A23O003C03012O0084000400013O0006920004002O040100010004A23O002O04012O0084000400023O0020350004000400030020110104000400042O002D0004000200020006920004002D040100010004A23O002D04012O0084000400033O0020460004000400054O000600023O00202O0006000600494O00040006000200062O0004002D04013O0004A23O002D0401001232000400013O0026410004001C040100010004A23O001C04012O0084000500043O00206200050005000A4O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005001B04013O0004A23O001B04010012E0000500074O008E000500023O001232000400023O0026410004000C040100020004A23O000C04012O0084000500043O0020620005000500084O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005002D04013O0004A23O002D04010012E0000500074O008E000500023O0004A23O002D04010004A23O000C04012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O000D004D040100040004A23O004D04012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104004D04013O0004A23O004D04012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C0010007D060100040004A23O007D06012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O000D004D040100040004A23O004D04012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006920004007D060100010004A23O007D0601001232000400013O0026410004005E040100010004A23O005E04012O0084000500043O00206200050005000A4O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005005D04013O0004A23O005D04010012E0000500074O008E000500023O001232000400023O0026410004004E040100020004A23O004E04012O0084000500043O0020620005000500084O000600056O000700063O00122O000800096O000900096O00050009000200122O000500073O00122O000500073O00062O0005007D06013O0004A23O007D06010012E0000500074O008E000500023O0004A23O007D06010004A23O004E04010004A23O007D06010004A23O003C03010004A23O007D060100264100020037030100010004A23O003703010006392O0100FA05013O0004A23O00FA0501001232000300013O00264100030004050100010004A23O000405012O0084000400083O0020350004000400270020110104000400142O002D000400020002000639010400BF04013O0004A23O00BF04012O0084000400013O00069200040088040100010004A23O008804012O0084000400023O0020350004000400030020110104000400042O002D0004000200020006920004008F040100010004A23O008F04012O0084000400033O0020EE0004000400284O000600023O00202O0006000600494O00040006000200062O00040092040100010004A23O009204012O00840004000B3O00261B000400BF040100220004A23O00BF0401001232000400013O00264100040093040100010004A23O009304012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006002700202O0006000600184O00060002000200062O000500A9040100060004A23O00A904012O00840005000C4O00840006000D3O0020350006000600192O002D000500020002000639010500A904013O0004A23O00A904012O00840005000E3O0012320006004E3O0012320007004F4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006002700202O0006000600184O00060002000200062O000500BF040100060004A23O00BF04012O00840005000C4O00840006000D3O00203500060006001E2O002D000500020002000639010500BF04013O0004A23O00BF04012O00840005000E3O00123B000600503O00122O000700516O000500076O00055O00044O00BF04010004A23O009304012O0084000400083O00203500040004002D0020110104000400142O002D0004000200020006390104000305013O0004A23O000305012O0084000400033O0020460004000400054O000600023O00202O0006000600524O00040006000200062O0004000305013O0004A23O00030501001232000400013O002641000400CD040100010004A23O00CD04012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006002D00202O0006000600184O00060002000200062O000500E8040100060004A23O00E804012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O000500E804013O0004A23O00E804012O00840005000E3O001232000600533O001232000700544O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006002D00202O0006000600184O00060002000200062O00050003050100060004A23O000305012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O000900096O0007000900024O000700076O00050007000200062O0005000305013O0004A23O000305012O00840005000E3O00123B000600553O00122O000700566O000500076O00055O00044O000305010004A23O00CD0401001232000300023O00264100030077040100020004A23O007704012O0084000400083O0020350004000400320020110104000400142O002D0004000200020006390104007A05013O0004A23O007A05012O0084000400093O0020110104000400152O002D0004000200020006920004002D050100010004A23O002D05012O00840004000A3O0020110104000400152O002D0004000200020006920004002D050100010004A23O002D05012O0084000400033O0020460004000400284O000600023O00202O0006000600494O00040006000200062O0004002D05013O0004A23O002D05012O0084000400013O0006920004002D050100010004A23O002D05012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O0033004D050100040004A23O004D05012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104004D05013O0004A23O004D05012O0084000400093O0020110104000400152O002D00040002000200069200040037050100010004A23O003705012O00840004000A3O0020110104000400152O002D0004000200020006390104004A05013O0004A23O004A05012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C0010004A050100040004A23O004A05012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O0034004D050100040004A23O004D05012O0084000400023O00203500040004000E0020110104000400042O002D0004000200020006390104004D05013O0004A23O004D05012O00840004000B3O00261B0004007A0501000D0004A23O007A0501001232000400013O0026410004004E050100010004A23O004E05012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006003200202O0006000600184O00060002000200062O00050064050100060004A23O006405012O00840005000C4O00840006000D3O0020350006000600192O002D0005000200020006390105006405013O0004A23O006405012O00840005000E3O001232000600573O001232000700584O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006003200202O0006000600184O00060002000200062O0005007A050100060004A23O007A05012O00840005000C4O00840006000D3O00203500060006001E2O002D0005000200020006390105007A05013O0004A23O007A05012O00840005000E3O00123B000600593O00122O0007005A6O000500076O00055O00044O007A05010004A23O004E05012O0084000400083O0020350004000400390020110104000400142O002D000400020002000639010400FA05013O0004A23O00FA05012O0084000400093O0020110104000400152O002D000400020002000692000400A1050100010004A23O00A105012O00840004000A3O0020110104000400152O002D000400020002000692000400A1050100010004A23O00A105012O0084000400033O0020460004000400284O000600023O00202O0006000600494O00040006000200062O000400A105013O0004A23O00A105012O0084000400013O000692000400A1050100010004A23O00A105012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O003400C1050100040004A23O00C105012O0084000400023O00203500040004000E0020110104000400042O002D000400020002000639010400C105013O0004A23O00C105012O0084000400093O0020110104000400152O002D000400020002000692000400AB050100010004A23O00AB05012O00840004000A3O0020110104000400152O002D000400020002000639010400BE05013O0004A23O00BE05012O0084000400023O00203500040004000300201101040004000F2O002D000400020002000E1C001000BE050100040004A23O00BE05012O0084000400073O00203E01040004000B4O000600023O00202O00060006000C4O000400060002000E2O003400C1050100040004A23O00C105012O0084000400023O00203500040004000E0020110104000400042O002D000400020002000639010400C105013O0004A23O00C105012O00840004000B3O00261B000400FA050100170004A23O00FA0501001232000400013O002641000400C2050100010004A23O00C205012O0084000500093O0020180105000500184O0005000200024O000600083O00202O00060006003900202O0006000600184O00060002000200062O000500DD050100060004A23O00DD05012O00840005000C4O002F0106000D3O00202O0006000600194O000700073O00202O00070007001A00122O0009003A6O0007000900024O000700076O00050007000200062O000500DD05013O0004A23O00DD05012O00840005000E3O0012320006005B3O0012320007005C4O0040000500074O00F300056O00840005000A3O0020180105000500184O0005000200024O000600083O00202O00060006003900202O0006000600184O00060002000200062O000500FA050100060004A23O00FA05012O00840005000C4O002F0106000D3O00202O00060006001E4O000700073O00202O00070007001A00122O0009003A6O0007000900024O000700076O00050007000200062O000500FA05013O0004A23O00FA05012O00840005000E3O00123B0006005D3O00122O0007005E6O000500076O00055O00044O00FA05010004A23O00C205010004A23O00FA05010004A23O007704012O00840003000F3O0006390103002206013O0004A23O002206012O0084000300083O00203500030003003F0020110103000300142O002D0003000200020006390103002206013O0004A23O002206012O0084000300023O00203500030003004000201101030003000F2O002D00030002000200261B0003000F060100340004A23O000F06012O0084000300023O00203500030003000300201101030003000F2O002D000300020002000E3101170012060100030004A23O001206012O00840003000B3O00261B00030022060100410004A23O002206012O00840003000C4O002F0104000D3O00202O00040004003F4O000500073O00202O00050005001A00122O000700426O0005000700024O000500056O00030005000200062O0003002206013O0004A23O002206012O00840003000E3O0012320004005F3O001232000500604O0040000300054O00F300035O001232000200023O0004A23O003703010004A23O007D06010026413O0002000100010004A23O000200010012E0000200613O0020AC0002000200624O0003000E3O00122O000400633O00122O000500646O0003000500024O00020002000300262O00020031060100650004A23O003106012O007800016O00042O0100013O0006392O01007B06013O0004A23O007B06012O0084000200083O0020350002000200320020110102000200142O002D0002000200020006390102007B06013O0004A23O007B0601001232000200013O0026410002003B060100010004A23O003B06012O0084000300093O0020180103000300184O0003000200024O000400083O00202O00040004003200202O0004000400184O00040002000200062O0003005B060100040004A23O005B06012O00840003000A3O0020110103000300152O002D0003000200020006920003005B060100010004A23O005B06012O00840003000C4O002F0104000D3O00202O0004000400194O000500073O00202O00050005001A00122O000700096O0005000700024O000500056O00030005000200062O0003005B06013O0004A23O005B06012O00840003000E3O001232000400663O001232000500674O0040000300054O00F300036O00840003000A3O0020180103000300184O0003000200024O000400083O00202O00040004003200202O0004000400184O00040002000200062O0003007B060100040004A23O007B06012O0084000300093O0020110103000300152O002D0003000200020006920003007B060100010004A23O007B06012O00840003000C4O002F0104000D3O00202O00040004001E4O000500073O00202O00050005001A00122O000700096O0005000700024O000500056O00030005000200062O0003007B06013O0004A23O007B06012O00840003000E3O00123B000400683O00122O000500696O000300056O00035O00044O007B06010004A23O003B06010012323O00023O0004A23O000200012O00233O00017O002D3O00028O00026O00084003083O00436869427572737403073O00497352656164792O033O00436869026O00F03F030A3O0043686944656669636974027O004003093O004973496E52616E6765026O00444003133O0058088434271A03B84F40821B200114B91B51D903083O00CB3B60ED6B456F7103163O0053752O6D6F6E57686974655469676572537461747565030A3O0049734361737461626C6503063O00141AADF834E203073O00B74476CC815190031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572030E3O004973496E4D656C2O6552616E6765026O00144003223O001DB87DE9048C31BA78ED1F8731B979E30E9031BE64E51F970BED7FF40E8C0BBF30B603063O00E26ECD10846B03063O00C8D6F2CA4EF903053O00218BA380B9031C3O0053752O6D6F6E57686974655469676572537461747565437572736F7203223O00444D09D358563BC95F5110DB684C0DD9524A3BCD435910CB52180BCE525601CC170A03043O00BE37386403093O00457870656C4861726D030B3O004973417661696C61626C65026O00204003133O0053B72C1B1FDCFB57BD315E1CF3F658AA2E5E4703073O009336CF5C7E738303073O004368695761766503123O000E393C421A7F1B3475721D7B0334273D5C2E03063O001E6D51551D6D03143O00FA6944B33AE1F4FE6359F639CEF9F17446F6678C03073O009C9F1134D656BE030C3O004661656C696E6553746F6D70030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66030A3O00446562752O66446F776E03183O00536B79726561636845786861757374696F6E446562752O6603133O00BAE6BAB9BCD0ADBDA2E2FDB3BEEAB3B9BCAFEB03043O00DCCE8FDD03133O0083653D12D4F3DA876F2057D7DCD788783F578003073O00B2E61D4D77B8AC00FF3O0012323O00013O0026413O0025000100020004A23O002500012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100FE00013O0004A23O00FE00012O0084000100013O0020112O01000100052O002D000100020002000E1C000600FE000100010004A23O00FE00012O0084000100013O0020112O01000100072O002D000100020002000E48000800FE000100010004A23O00FE00012O0084000100024O001D00025O00202O0002000200034O000300033O00202O00030003000900122O0005000A6O0003000500024O000300036O000400016O00010004000200062O000100FE00013O0004A23O00FE00012O0084000100043O00123B0002000B3O00122O0003000C6O000100036O00015O00044O00FE0001000E362O01007D00013O0004A23O007D00012O008400015O00203500010001000D0020112O010001000E2O002D0001000200020006392O01005A00013O0004A23O005A00012O0084000100053O0006392O01005A00013O0004A23O005A00012O0084000100064O0013010200043O00122O0003000F3O00122O000400106O00020004000200062O00010048000100020004A23O004800012O0084000100024O002F010200073O00202O0002000200114O000300033O00202O00030003001200122O000500136O0003000500024O000300036O00010003000200062O0001005A00013O0004A23O005A00012O0084000100043O00123B000200143O00122O000300156O000100036O00015O00044O005A00012O0084000100064O0013010200043O00122O000300163O00122O000400176O00020004000200062O0001005A000100020004A23O005A00012O0084000100024O0084000200073O0020350002000200182O002D0001000200020006392O01005A00013O0004A23O005A00012O0084000100043O001232000200193O0012320003001A4O0040000100034O00F300016O008400015O00203500010001001B0020112O01000100042O002D0001000200020006392O01007C00013O0004A23O007C00012O008400015O0020350001000100030020112O010001001C2O002D0001000200020006392O01007C00013O0004A23O007C00012O0084000100013O0020112O01000100072O002D000100020002000E480002007C000100010004A23O007C00012O0084000100084O009900025O00202O00020002001B4O000300046O000500033O00202O00050005001200122O0007001D6O0005000700024O000500056O00010005000200062O0001007C00013O0004A23O007C00012O0084000100043O0012320002001E3O0012320003001F4O0040000100034O00F300015O0012323O00063O0026413O00B3000100080004A23O00B300012O008400015O0020350001000100200020112O01000100042O002D0001000200020006392O01009B00013O0004A23O009B00012O0084000100013O0020112O01000100072O002D000100020002000E480008009B000100010004A23O009B00012O0084000100084O009900025O00202O0002000200204O000300046O000500033O00202O00050005000900122O0007000A6O0005000700024O000500056O00010005000200062O0001009B00013O0004A23O009B00012O0084000100043O001232000200213O001232000300224O0040000100034O00F300016O008400015O00203500010001001B0020112O01000100042O002D0001000200020006392O0100B200013O0004A23O00B200012O0084000100084O009900025O00202O00020002001B4O000300046O000500033O00202O00050005001200122O0007001D6O0005000700024O000500056O00010005000200062O000100B200013O0004A23O00B200012O0084000100043O001232000200233O001232000300244O0040000100034O00F300015O0012323O00023O0026413O0001000100060004A23O000100012O008400015O0020350001000100250020112O010001000E2O002D0001000200020006392O0100DA00013O0004A23O00DA00012O0084000100033O00204B0001000100264O00035O00202O0003000300274O00010003000200262O000100DA000100080004A23O00DA00012O0084000100033O0020460001000100284O00035O00202O0003000300294O00010003000200062O000100DA00013O0004A23O00DA00012O0084000100084O009900025O00202O0002000200254O000300046O000500033O00202O00050005001200122O000700136O0005000700024O000500056O00010005000200062O000100DA00013O0004A23O00DA00012O0084000100043O0012320002002A3O0012320003002B4O0040000100034O00F300016O008400015O00203500010001001B0020112O01000100042O002D0001000200020006392O0100FC00013O0004A23O00FC00012O008400015O0020350001000100030020112O010001001C2O002D0001000200020006392O0100FC00013O0004A23O00FC00012O0084000100013O0020112O01000100052O002D000100020002002641000100FC000100020004A23O00FC00012O0084000100084O009900025O00202O00020002001B4O000300046O000500033O00202O00050005001200122O0007001D6O0005000700024O000500056O00010005000200062O000100FC00013O0004A23O00FC00012O0084000100043O0012320002002C3O0012320003002D4O0040000100034O00F300015O0012323O00083O0004A23O000100012O00233O00017O00413O00028O0003133O00537472696B656F6674686557696E646C6F726403073O0049735265616479030B3O005468756E64657266697374030B3O004973417661696C61626C65026O000840030C3O004361737454617267657449662O033O00F8BF1203063O009895DE6A7B17030E3O004973496E4D656C2O6552616E6765026O00144003223O00CE32E44ABED819F9458AC92EF37CA2D428F24FBACF22B641B1DF19E546A1C836B61103053O00D5BD469623030C3O00426F6E656475737442726577030A3O0049734361737461626C652O033O00436869026O00104003063O007F5975114A4703043O00682F351403123O00426F6E656475737442726577506C6179657203093O004973496E52616E6765026O00204003193O00A1438F19B81AB058BE1EAE0AB40C8318BE30B0499509AC4FF703063O006FC32CE17CDC030C3O00FB490E75A2B9D547147AA4A503063O00CBB8266013CB026O00444003193O003B7C7744CA2C606D7ECC2B766E01CC3D714652CB2D6669019A03053O00AE5913192103063O000C07405DF89503073O006B4F72322E97E703123O00426F6E656475737442726577437572736F7203193O003BA9BB2C8E2CA4D406A4A72C9D79B5C43B99A62C9E2CA7806D03083O00A059C6D549EA59D703123O006D7FB1F3DC0864BAFAC05A3197EBD75B7EA603053O00A52811D49E03063O0045786973747303093O0043616E412O7461636B03193O00E7D6063622F0CA1C0C24F7DC1F7324E1DB372023F1CC18737203053O004685B96853026O00F03F027O0040030C3O00426C61636B6F75744B69636B03133O00576869726C696E67447261676F6E50756E63682O033O00094C4A03053O00A96425244A03193O00028BA3530B88B7443F8CAB530BC7A05402B8B1551492B2105803043O003060E7C203093O00546967657250616C6D030A3O004368694465666963697403063O0042752O66557003153O0053746F726D4561727468416E644669726542752O662O033O00C5530003083O00E3A83A6E4D79B8CF03163O006F35B845A3E461A47731FF42B5D94EB67E28AA50F18D03083O00C51B5CDF20D1BB11030D3O00526973696E6753756E4B69636B2O033O000E56CD03043O009B633FA3031C3O0090D8B284B783BDC2B483868F8BD2AACDBB2O80EEB288AD919291F0DD03063O00E4E2B1C1EDD92O033O0039B92D03043O008654D043031C3O0001A595551DABB94F06A2B9571AAF8D1C11A8846300A9924903ECD70E03043O003C73CCE60069012O0012323O00013O0026413O00A7000100010004A23O00A700012O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O01002A00013O0004A23O002A00012O008400015O0020350001000100040020112O01000100052O002D0001000200020006392O01002A00013O0004A23O002A00012O0084000100013O000E1C0006002A000100010004A23O002A00012O0084000100023O0020A00001000100074O00025O00202O0002000200024O000300036O000400043O00122O000500083O00122O000600096O0004000600024O000500056O000600066O000700063O00202O00070007000A00122O0009000B6O0007000900024O000700076O00010007000200062O0001002A00013O0004A23O002A00012O0084000100043O0012320002000C3O0012320003000D4O0040000100034O00F300016O008400015O00203500010001000E0020112O010001000F2O002D0001000200020006392O0100A600013O0004A23O00A600012O0084000100074O002B0001000100020006392O0100A600013O0004A23O00A600012O0084000100083O0020112O01000100102O002D000100020002000E48001100A6000100010004A23O00A600012O0084000100094O0013010200043O00122O000300123O00122O000400136O00020004000200062O00010051000100020004A23O005100012O00840001000A4O002F0102000B3O00202O0002000200144O000300063O00202O00030003001500122O000500166O0003000500024O000300036O00010003000200062O000100A600013O0004A23O00A600012O0084000100043O00123B000200173O00122O000300186O000100036O00015O00044O00A600012O0084000100094O0013010200043O00122O000300193O00122O0004001A6O00020004000200062O00010069000100020004A23O006900012O00840001000A4O002F01025O00202O00020002000E4O000300063O00202O00030003001500122O0005001B6O0003000500024O000300036O00010003000200062O000100A600013O0004A23O00A600012O0084000100043O00123B0002001C3O00122O0003001D6O000100036O00015O00044O00A600012O0084000100094O0013010200043O00122O0003001E3O00122O0004001F6O00020004000200062O00010081000100020004A23O008100012O00840001000A4O002F0102000B3O00202O0002000200204O000300063O00202O00030003001500122O0005001B6O0003000500024O000300036O00010003000200062O000100A600013O0004A23O00A600012O0084000100043O00123B000200213O00122O000300226O000100036O00015O00044O00A600012O0084000100094O0013010200043O00122O000300233O00122O000400246O00020004000200062O000100A6000100020004A23O00A600012O00840001000C3O0006392O0100A600013O0004A23O00A600012O00840001000C3O0020112O01000100252O002D0001000200020006392O0100A600013O0004A23O00A600012O0084000100083O0020112O01000100262O00840003000C4O00422O01000300020006392O0100A600013O0004A23O00A600012O00840001000A4O002F0102000B3O00202O0002000200204O000300063O00202O00030003001500122O0005001B6O0003000500024O000300036O00010003000200062O000100A600013O0004A23O00A600012O0084000100043O001232000200273O001232000300284O0040000100034O00F300015O0012323O00293O0026413O00082O01002A0004A23O00082O012O008400015O00203500010001002B0020112O01000100032O002D0001000200020006392O0100D700013O0004A23O00D700012O00840001000D4O008400025O00203500020002002B2O002D0001000200020006392O0100D700013O0004A23O00D700012O008400015O00203500010001002C0020112O01000100052O002D000100020002000692000100D7000100010004A23O00D700012O0084000100074O002B000100010002000692000100D7000100010004A23O00D700012O0084000100023O0020A00001000100074O00025O00202O00020002002B4O000300036O000400043O00122O0005002D3O00122O0006002E6O0004000600024O0005000E6O000600066O000700063O00202O00070007000A00122O0009000B6O0007000900024O000700076O00010007000200062O000100D700013O0004A23O00D700012O0084000100043O0012320002002F3O001232000300304O0040000100034O00F300016O008400015O0020350001000100310020112O01000100032O002D0001000200020006392O0100682O013O0004A23O00682O012O00840001000D4O008400025O0020350002000200312O002D0001000200020006392O0100682O013O0004A23O00682O012O0084000100083O0020112O01000100322O002D000100020002000E48002A00682O0100010004A23O00682O012O0084000100083O0020460001000100334O00035O00202O0003000300344O00010003000200062O000100682O013O0004A23O00682O012O0084000100023O0020A00001000100074O00025O00202O0002000200314O000300036O000400043O00122O000500353O00122O000600366O0004000600024O0005000F6O000600066O000700063O00202O00070007000A00122O0009000B6O0007000900024O000700076O00010007000200062O000100682O013O0004A23O00682O012O0084000100043O00123B000200373O00122O000300386O000100036O00015O00044O00682O01000E360129000100013O0004A23O000100012O008400015O0020350001000100390020112O01000100032O002D0001000200020006392O0100392O013O0004A23O00392O012O00840001000D4O008400025O0020350002000200392O002D0001000200020006392O0100392O013O0004A23O00392O012O0084000100083O0020112O01000100102O002D000100020002000E48000B00392O0100010004A23O00392O012O008400015O00203500010001002C0020112O01000100052O002D0001000200020006392O0100392O013O0004A23O00392O012O0084000100023O0020A00001000100074O00025O00202O0002000200394O000300036O000400043O00122O0005003A3O00122O0006003B6O0004000600024O0005000E6O000600066O000700063O00202O00070007000A00122O0009000B6O0007000900024O000700076O00010007000200062O000100392O013O0004A23O00392O012O0084000100043O0012320002003C3O0012320003003D4O0040000100034O00F300016O008400015O0020350001000100390020112O01000100032O002D0001000200020006392O0100662O013O0004A23O00662O012O00840001000D4O008400025O0020350002000200392O002D0001000200020006392O0100662O013O0004A23O00662O012O0084000100013O000E48002A00662O0100010004A23O00662O012O008400015O00203500010001002C0020112O01000100052O002D0001000200020006392O0100662O013O0004A23O00662O012O0084000100023O0020A00001000100074O00025O00202O0002000200394O000300036O000400043O00122O0005003E3O00122O0006003F6O0004000600024O0005000E6O000600066O000700063O00202O00070007000A00122O0009000B6O0007000900024O000700076O00010007000200062O000100662O013O0004A23O00662O012O0084000100043O001232000200403O001232000300414O0040000100034O00F300015O0012323O002A3O0004A23O000100012O00233O00017O008A3O00028O0003163O0053752O6D6F6E57686974655469676572537461747565030A3O0049734361737461626C6503173O00496E766F6B655875656E54686557686974655469676572030A3O00432O6F6C646F776E5570026O001040030F3O00432O6F6C646F776E52656D61696E73026O004940026O003E4003063O00D736EA69E22803043O0010875A8B031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572030E3O004973496E4D656C2O6552616E6765026O00144003223O0047610B3E415A47437C0F274B6B6C5D73032171476C556013360E577C6B6703350E0603073O0018341466532E3403063O00E73A333700D603053O006FA44F4144031C3O0053752O6D6F6E57686974655469676572537461747565437572736F7203223O00D5CC8ED321E4F9CE8BD73AEFF9CD8AD92BF8F9CA97DF3AFFC39980DA11F9C3DFC38C03063O008AA6B9E3BE4E03093O0054696D65546F446965026O003940030C3O00426F6E656475737442726577030B3O004973417661696C61626C65026O0008402O033O00436869027O004003093O004973496E52616E6765026O00444003243O00C27AD338592O26D361C0396D3711CE4BD23F5B371CF460CC30573159C870FA245725599F03073O0079AB14A5573243026O005E40026O004E40030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66025O00804B4003083O00536572656E697479030B3O00426C2O6F646C7573745570026O00374003243O00CF36AF39B207F920AC33B73DD230BC09AE0ACF2CBC09AD0BC13DAB76BA06F92BBC30F95403063O0062A658D956D9026O00F03F03093O0046697265626C2O6F64026O00244003133O00F0FF6B0484D02OF97D4185D8C9E57C07C68EA003063O00BC2O961961E6030A3O004265727365726B696E67026O002E4003143O00D88C4D1109FFD18051054CEEDEB64C070AAD88D103063O008DBAE93F626C030B3O004261676F66547269636B7303083O0042752O66446F776E03153O0053746F726D4561727468416E644669726542752O6603173O00F3EB2B892AF7D538A42CF2E13FF626F5D53FB323B1B97C03053O0045918A4CD603113O0053746F726D4561727468416E644669726503063O0042752O66557003103O00426F6E65647573744272657742752O6603103O0046752O6C526563686172676554696D65031D3O0063DB869BB22975CE9B9DB72971C18DB6B91F62CAC98ABB2963CA8FC9E703063O007610AF2OE9DF031D3O0098903AA9E3B4788A9621B3D18A738FBB33B2FC8E3D88800AA8EB8D3DD203073O001DEBE455DB8EEB030B3O0042752O6652656D61696E73026O002640030A3O00446562752O66446F776E03063O000DD8BBC4725C03083O00325DB4DABD172E4703123O00426F6E656475737442726577506C61796572026O00204003173O00DCAB554940C95BCA9B595E41CB08DDA0645F41DA088FF403073O0028BEC43B2C24BC030C3O001F4AD2B2F36F003D51D5BBF403073O006D5C25BCD49A1D03173O0006E0AAC6354F17FB9BC1235F13AFA7C70E4901E9E4926103063O003A648FC4A35103063O00395731B0305B03083O006E7A2243C35F298503123O00426F6E656475737442726577437572736F7203173O0077BE554FD260A24F75D467B44C0AD5718E484FD035E00B03053O00B615D13B2A03123O009259C01038FEA259C11833FE9442D70E2EAC03063O00DED737A57D4103063O0045786973747303093O0043616E412O7461636B03173O002EDEC81FF6D4FE5E13D3D41FE581EE4E13C2C31CB290BD03083O002A4CB1A67A92A18D03073O0043686172676573026O002A40026O003440030B3O0046697374736F6646757279026O00224003133O00576869726C696E67447261676F6E50756E6368026O002840031E3O00B69E0ADC7449A08B17DA7149A48401F12O7FB78F45CD7D49B68F038E282403063O0016C5EA65AE19030C3O00546F7563686F66446561746803093O004973496E506172747903083O004973496E5261696403073O0049735265616479030C3O00536572656E69747942752O6603063O004865616C7468031F3O0048692O64656E4D617374657273466F7262692O64656E546F75636842752O6603043O004755494403243O00393BB0DF7E90D8801230A0DD62A79785290BB6D970EFDA87243AE8C877BDD0833974F48803083O00E64D54C5BC16CFB703073O0047657454696D65030E3O004C61737454617267657453776170025O00408F40026O00594003233O00ED1BD3FF849EFF33C610C3FD98A9B036FD2BD5F98AE1FF33FF59D2FD9EA6F521B9459203083O00559974A69CECC19003083O00446562752O66557003123O00426F6E656475737442726577446562752O6603243O00B0EF58B0EC3FABE672B7E101B0E80DB0E03FB7E54BF3E901ADEE00A7E512A3E559F3B55603063O0060C4802DD38403233O0021826E5CDA90BBDE0A897E5EC6A7F4DB31B2685AD4EFBBDE33C06F5EC0A8B1CC75DC2D03083O00B855ED1B3FB2CFD403243O001C561C5C00660659375D0C5E1C51495C0C661A5A0E19045E0157444B094B0E5A1C19580703043O003F68396903233O001F88B14703B8AB423483A1451F8FE4470FB8B7410DC7AB420DCAB0451980A1504BD6FC03043O00246BE7C4030C3O00546F7563686F664B61726D61025O00805640026O003040025O00E0634003183O0049BAB784558AAD8162BEA39550B4E284598AB1825BF5F0D703043O00E73DD5C2030D3O00416E6365737472616C43612O6C03183O0008A33E761AB92F7205923E7205A17D700D922E760FED6F2103043O001369CD5D03093O00426C2O6F644675727903143O00AB04D18E3B960ECB9326E90BDABE2CAC0E9ED36B03053O005FC968BEE1030E3O004C69676874734A7564676D656E7403193O00A3C22OC6BBD8FEC4BACFC6C3AAC5D58EACCFFEDDAACD819DFD03043O00AECFABA10085042O0012323O00013O000E362O0100C500013O0004A23O00C500012O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O01004500013O0004A23O004500012O008400015O0020350001000100040020112O01000100052O002D0001000200020006920001001B000100010004A23O001B00012O0084000100013O000E310106001B000100010004A23O001B00012O008400015O0020350001000100040020112O01000100072O002D000100020002000E310108001B000100010004A23O001B00012O0084000100023O00260200010045000100090004A23O004500012O0084000100034O0013010200043O00122O0003000A3O00122O0004000B6O00020004000200062O00010033000100020004A23O003300012O0084000100054O002F010200063O00202O00020002000C4O000300073O00202O00030003000D00122O0005000E6O0003000500024O000300036O00010003000200062O0001004500013O0004A23O004500012O0084000100043O00123B0002000F3O00122O000300106O000100036O00015O00044O004500012O0084000100034O0013010200043O00122O000300113O00122O000400126O00020004000200062O00010045000100020004A23O004500012O0084000100054O0084000200063O0020350002000200132O002D0001000200020006392O01004500013O0004A23O004500012O0084000100043O001232000200143O001232000300154O0040000100034O00F300016O008400015O0020350001000100040020112O01000100032O002D0001000200020006392O01008300013O0004A23O008300012O0084000100083O0006920001006F000100010004A23O006F00012O0084000100073O0020112O01000100162O002D000100020002000E1C0017006F000100010004A23O006F00012O008400015O0020350001000100180020112O01000100192O002D0001000200020006392O01006F00013O0004A23O006F00012O008400015O0020350001000100180020112O01000100072O002D0001000200020026020001006F0001000E0004A23O006F00012O0084000100013O00261B000100670001001A0004A23O006700012O0084000100093O0020112O010001001B2O002D000100020002002O0E001A0072000100010004A23O007200012O0084000100013O000E48001A006F000100010004A23O006F00012O0084000100093O0020112O010001001B2O002D000100020002002O0E001C0072000100010004A23O007200012O0084000100023O00261B00010083000100170004A23O008300012O00840001000A4O009900025O00202O0002000200044O000300046O000500073O00202O00050005001D00122O0007001E6O0005000700024O000500056O00010005000200062O0001008300013O0004A23O008300012O0084000100043O0012320002001F3O001232000300204O0040000100034O00F300016O008400015O0020350001000100040020112O01000100032O002D0001000200020006392O0100C400013O0004A23O00C400012O0084000100073O0020112O01000100162O002D000100020002000E1C00170091000100010004A23O009100012O0084000100023O000E31012100B3000100010004A23O00B300012O0084000100023O00261B000100AB000100220004A23O00AB00012O0084000100073O0020030001000100234O00035O00202O0003000300244O00010003000200262O000100A20001001C0004A23O00A200012O0084000100073O0020352O01000100234O00035O00202O0003000300244O000100030002000E2O002500AB000100010004A23O00AB00012O008400015O0020350001000100260020112O01000100052O002D0001000200020006392O0100AB00013O0004A23O00AB00012O0084000100013O00267E000100B30001001A0004A23O00B300012O0084000100093O0020112O01000100272O002D000100020002000692000100B3000100010004A23O00B300012O0084000100023O00261B000100C4000100280004A23O00C400012O00840001000A4O009900025O00202O0002000200044O000300046O000500073O00202O00050005001D00122O0007001E6O0005000700024O000500056O00010005000200062O000100C400013O0004A23O00C400012O0084000100043O001232000200293O0012320003002A4O0040000100034O00F300015O0012323O002B3O0026413O001D2O0100060004A23O001D2O012O008400015O00203500010001002C0020112O01000100032O002D0001000200020006392O0100E500013O0004A23O00E500012O008400015O0020350001000100040020112O01000100072O002D000100020002000E31010900D9000100010004A23O00D900012O0084000100083O000692000100D9000100010004A23O00D900012O0084000100023O00261B000100E50001002D0004A23O00E500012O00840001000A4O002301025O00202O00020002002C4O000300036O00010003000200062O000100E500013O0004A23O00E500012O0084000100043O0012320002002E3O0012320003002F4O0040000100034O00F300016O008400015O0020350001000100300020112O01000100032O002D0001000200020006392O0100032O013O0004A23O00032O012O008400015O0020350001000100040020112O01000100072O002D000100020002000E31010900F7000100010004A23O00F700012O0084000100083O000692000100F7000100010004A23O00F700012O0084000100023O00261B000100032O0100310004A23O00032O012O00840001000A4O002301025O00202O0002000200304O000300036O00010003000200062O000100032O013O0004A23O00032O012O0084000100043O001232000200323O001232000300334O0040000100034O00F300016O008400015O0020350001000100340020112O01000100032O002D0001000200020006392O01001C2O013O0004A23O001C2O012O0084000100093O0020460001000100354O00035O00202O0003000300364O00010003000200062O0001001C2O013O0004A23O001C2O012O00840001000A4O002301025O00202O0002000200344O000300036O00010003000200062O0001001C2O013O0004A23O001C2O012O0084000100043O001232000200373O001232000300384O0040000100034O00F300015O0012323O000E3O0026413O00530201002B0004A23O005302012O008400015O0020350001000100390020112O01000100032O002D0001000200020006392O01006B2O013O0004A23O006B2O012O008400015O0020350001000100180020112O01000100192O002D0001000200020006392O01006B2O013O0004A23O006B2O012O0084000100023O00261B000100392O0100090004A23O00392O012O008400015O0020350001000100180020112O01000100072O002D00010002000200261B000100392O0100060004A23O00392O012O0084000100093O0020112O010001001B2O002D000100020002002O0E000600522O0100010004A23O00522O012O0084000100093O0020EE00010001003A4O00035O00202O00030003003B4O00010003000200062O000100522O0100010004A23O00522O012O00840001000B4O002B0001000100020006920001006B2O0100010004A23O006B2O012O0084000100013O000E48001A006B2O0100010004A23O006B2O012O008400015O0020350001000100180020112O01000100072O002D0001000200020026020001006B2O01001C0004A23O006B2O012O0084000100093O0020112O010001001B2O002D000100020002000E48001C006B2O0100010004A23O006B2O012O00840001000C3O0006920001005F2O0100010004A23O005F2O012O008400015O0020402O010001000400202O0001000100074O0001000200024O00025O00202O00020002003900202O00020002003C4O00020002000200062O0002006B2O0100010004A23O006B2O012O00840001000A4O002301025O00202O0002000200394O000300036O00010003000200062O0001006B2O013O0004A23O006B2O012O0084000100043O0012320002003D3O0012320003003E4O0040000100034O00F300016O008400015O0020350001000100390020112O01000100032O002D0001000200020006392O0100952O013O0004A23O00952O012O008400015O0020350001000100180020112O01000100192O002D000100020002000692000100952O0100010004A23O00952O012O00840001000C3O000692000100892O0100010004A23O00892O012O0084000100073O0020112O01000100162O002D000100020002000E1C003100952O0100010004A23O00952O012O008400015O0020402O010001003900202O00010001003C4O0001000200024O00025O00202O00020002000400202O0002000200074O00020002000200062O000100952O0100020004A23O00952O012O00840001000A4O002301025O00202O0002000200394O000300036O00010003000200062O000100952O013O0004A23O00952O012O0084000100043O0012320002003F3O001232000300404O0040000100034O00F300016O008400015O0020350001000100180020112O01000100032O002D0001000200020006392O01005202013O0004A23O005202012O0084000100093O0020460001000100354O00035O00202O00030003003B4O00010003000200062O000100B42O013O0004A23O00B42O012O0084000100093O00204600010001003A4O00035O00202O0003000300364O00010003000200062O000100B42O013O0004A23O00B42O012O0084000100093O00204B0001000100414O00035O00202O0003000300364O00010003000200262O000100B42O0100420004A23O00B42O012O00840001000B4O002B000100010002000692000100E52O0100010004A23O00E52O012O0084000100093O0020460001000100354O00035O00202O00030003003B4O00010003000200062O000100CA2O013O0004A23O00CA2O012O0084000100023O00261B000100CA2O0100090004A23O00CA2O012O0084000100023O000E1C002D00CA2O0100010004A23O00CA2O012O00840001000B4O002B0001000100020006392O0100CA2O013O0004A23O00CA2O012O0084000100093O0020112O010001001B2O002D000100020002002O0E000600E52O0100010004A23O00E52O012O0084000100023O00267E000100E52O01002D0004A23O00E52O012O0084000100073O0020460001000100434O00035O00202O0003000300244O00010003000200062O000100DB2O013O0004A23O00DB2O012O0084000100013O000E48000600DB2O0100010004A23O00DB2O012O00840001000D4O002B000100010002002O0E001C00E52O0100010004A23O00E52O012O00840001000C3O0006392O01005202013O0004A23O005202012O00840001000B4O002B0001000100020006392O01005202013O0004A23O005202012O0084000100013O000E4800060052020100010004A23O005202012O00840001000E4O0013010200043O00122O000300443O00122O000400456O00020004000200062O000100FD2O0100020004A23O00FD2O012O0084000100054O002F010200063O00202O0002000200464O000300073O00202O00030003001D00122O000500476O0003000500024O000300036O00010003000200062O0001005202013O0004A23O005202012O0084000100043O00123B000200483O00122O000300496O000100036O00015O00044O005202012O00840001000E4O0013010200043O00122O0003004A3O00122O0004004B6O00020004000200062O00010015020100020004A23O001502012O0084000100054O002F01025O00202O0002000200184O000300073O00202O00030003001D00122O0005001E6O0003000500024O000300036O00010003000200062O0001005202013O0004A23O005202012O0084000100043O00123B0002004C3O00122O0003004D6O000100036O00015O00044O005202012O00840001000E4O0013010200043O00122O0003004E3O00122O0004004F6O00020004000200062O0001002D020100020004A23O002D02012O0084000100054O002F010200063O00202O0002000200504O000300073O00202O00030003001D00122O0005001E6O0003000500024O000300036O00010003000200062O0001005202013O0004A23O005202012O0084000100043O00123B000200513O00122O000300526O000100036O00015O00044O005202012O00840001000E4O0013010200043O00122O000300533O00122O000400546O00020004000200062O00010052020100020004A23O005202012O00840001000F3O0006392O01005202013O0004A23O005202012O00840001000F3O0020112O01000100552O002D0001000200020006392O01005202013O0004A23O005202012O0084000100093O0020112O01000100562O00840003000F4O00422O01000300020006392O01005202013O0004A23O005202012O0084000100054O002F010200063O00202O0002000200504O000300073O00202O00030003001D00122O0005001E6O0003000500024O000300036O00010003000200062O0001005202013O0004A23O005202012O0084000100043O001232000200573O001232000300584O0040000100034O00F300015O0012323O001C3O0026413O00F70301001C0004A23O00F703012O0084000100093O0020460001000100354O00035O00202O00030003003B4O00010003000200062O000100AB02013O0004A23O00AB02012O008400015O0020350001000100180020112O01000100192O002D0001000200020006392O0100AB02013O0004A23O00AB02012O008400015O0020350001000100180020112O01000100072O002D000100020002002602000100AB0201001C0004A23O00AB02012O0084000100023O000E1C00220083020100010004A23O008302012O008400015O0020350001000100390020112O01000100592O002D000100020002000E312O010077020100010004A23O007702012O008400015O0020350001000100390020112O01000100072O002D000100020002000E1C002D0083020100010004A23O008302012O00840001000C3O0006920001009F020100010004A23O009F02012O008400015O0020350001000100040020112O01000100072O002D000100020002000E31012D009F020100010004A23O009F02012O0084000100083O0006920001009F020100010004A23O009F02012O00840001000C3O0006920001008C020100010004A23O008C02012O008400015O0020350001000100040020112O01000100072O002D000100020002000E1C005A00AB020100010004A23O00AB02012O008400015O0020350001000100390020112O01000100592O002D000100020002000E312O01009F020100010004A23O009F02012O008400015O0020350001000100390020112O01000100072O002D000100020002000E31015A009F020100010004A23O009F02012O0084000100093O00204600010001003A4O00035O00202O0003000300364O00010003000200062O000100AB02013O0004A23O00AB0201001232000100014O00B8000200023O002641000100A1020100010004A23O00A102012O0084000300104O002B0003000100022O00A8000200033O000639010200AB02013O0004A23O00AB02012O008E000200023O0004A23O00AB02010004A23O00A102012O008400015O0020350001000100390020112O01000100032O002D0001000200020006392O0100E102013O0004A23O00E102012O0084000100023O00267E000100D50201005B0004A23O00D502012O008400015O0020350001000100390020112O01000100592O002D000100020002002641000100E10201001C0004A23O00E102012O008400015O0020402O010001000400202O0001000100074O0001000200024O00025O00202O00020002003900202O00020002003C4O00020002000200062O000200E1020100010004A23O00E102012O008400015O00203500010001005C0020112O01000100072O002D000100020002002602000100E10201005D0004A23O00E102012O0084000100093O0020112O010001001B2O002D000100020002000E48001C00E1020100010004A23O00E102012O008400015O00203500010001005E0020112O01000100072O002D000100020002002602000100E10201005F0004A23O00E102012O00840001000A4O002301025O00202O0002000200394O000300036O00010003000200062O000100E102013O0004A23O00E102012O0084000100043O001232000200603O001232000300614O0040000100034O00F300016O008400015O0020350001000100620020112O01000100052O002D0001000200020006392O0100F603013O0004A23O00F603012O0084000100113O0006392O0100F603013O0004A23O00F60301001232000100014O00B8000200033O002641000100F9020100010004A23O00F902012O0084000400093O0020110104000400632O002D000400020002000647000200F7020100040004A23O00F702012O0084000400093O0020110104000400642O002D0004000200022O00F8000200044O00B8000300033O0012320001002B3O000E36012B006C030100010004A23O006C03012O0084000400123O0006390104000503013O0004A23O000503012O0084000400133O0006390104000503013O0004A23O000503012O0084000400144O002B0004000100022O00A8000300043O0004A23O000C03012O008400045O0020350004000400620020110104000400652O002D0004000200020006390104000C03013O0004A23O000C03012O0084000300073O0006390103006B03013O0004A23O006B03010006390102002403013O0004A23O002403012O0084000400093O0020460004000400354O00065O00202O0006000600664O00040006000200062O0004002403013O0004A23O002403012O0084000400154O008400055O0020350005000500622O002D0004000200020006390104002403013O0004A23O002403010020110104000300672O001A0004000200024O000500093O00202O0005000500674O00050002000200062O00040034030100050004A23O003403012O0084000400093O0020030004000400414O00065O00202O0006000600684O00040006000200262O000400340301001C0004A23O003403012O0084000400093O0020460104000400414O00065O00202O0006000600684O00040006000200202O0005000300164O00050002000200062O0005006B030100040004A23O006B03010020110104000300692O00560004000200024O000500073O00202O0005000500694O00050002000200062O0004004D030100050004A23O004D03012O00840004000A4O009900055O00202O0005000500624O000600076O000800073O00202O00080008000D00122O000A000E6O0008000A00024O000800086O00040008000200062O0004006B03013O0004A23O006B03012O0084000400043O00123B0005006A3O00122O0006006B6O000400066O00045O00044O006B03010012E00004006C4O00540004000100024O000500163O00202O00050005006D4O00040004000500202O00040004006E4O000500173O00062O0005006B030100040004A23O006B0301001232000400013O00264100040057030100010004A23O005703012O0084000500163O0012D60006006C6O00060001000200102O0005006D00064O000500056O000600183O00122O0007006F6O000600076O00053O000200062O0005006B03013O0004A23O006B03012O0084000500043O00123B000600703O00122O000700716O000500076O00055O00044O006B03010004A23O005703010012320001001C3O002641000100EC0201001C0004A23O00EC0201000639010300F603013O0004A23O00F603012O0084000400154O008400055O0020350005000500622O002D000400020002000639010400F603013O0004A23O00F60301000639010200BD03013O0004A23O00BD03010020110104000300162O002D000400020002000E3101220085030100040004A23O008503010020110104000300722O008400065O0020350006000600732O004201040006000200069200040085030100010004A23O008503012O0084000400023O00261B000400F60301002D0004A23O00F603010020110104000300692O00560004000200024O000500073O00202O0005000500694O00050002000200062O0004009E030100050004A23O009E03012O00840004000A4O009900055O00202O0005000500624O000600076O000800073O00202O00080008000D00122O000A000E6O0008000A00024O000800086O00040008000200062O000400F603013O0004A23O00F603012O0084000400043O00123B000500743O00122O000600756O000400066O00045O00044O00F603010012E00004006C4O00540004000100024O000500163O00202O00050005006D4O00040004000500202O00040004006E4O000500173O00062O000500F6030100040004A23O00F60301001232000400013O002641000400A8030100010004A23O00A803012O0084000500163O0012D60006006C6O00060001000200102O0005006D00064O000500056O000600183O00122O0007006F6O000600076O00053O000200062O000500F603013O0004A23O00F603012O0084000500043O00123B000600763O00122O000700776O000500076O00055O00044O00F603010004A23O00A803010004A23O00F603010020110104000300692O00560004000200024O000500073O00202O0005000500694O00050002000200062O000400D6030100050004A23O00D603012O00840004000A4O009900055O00202O0005000500624O000600076O000800073O00202O00080008000D00122O000A000E6O0008000A00024O000800086O00040008000200062O000400F603013O0004A23O00F603012O0084000400043O00123B000500783O00122O000600796O000400066O00045O00044O00F603010012E00004006C4O00540004000100024O000500163O00202O00050005006D4O00040004000500202O00040004006E4O000500173O00062O000500F6030100040004A23O00F60301001232000400013O002641000400E0030100010004A23O00E003012O0084000500163O0012D60006006C6O00060001000200102O0005006D00064O000500056O000600183O00122O0007006F6O000600076O00053O000200062O000500F603013O0004A23O00F603012O0084000500043O00123B0006007A3O00122O0007007B6O000500076O00055O00044O00F603010004A23O00E003010004A23O00F603010004A23O00EC02010012323O001A3O0026413O006E0401001A0004A23O006E04012O008400015O00203500010001007C0020112O01000100032O002D0001000200020006392O01003104013O0004A23O003104012O0084000100193O0006392O01003104013O0004A23O003104012O008400015O0020350001000100040020112O01000100192O002D0001000200020006392O01001404013O0004A23O001404012O0084000100023O000E31017D0020040100010004A23O002004012O00840001000C3O00069200010020040100010004A23O002004012O0084000100083O00069200010020040100010004A23O002004012O0084000100023O00267E000100200401007E0004A23O002004012O008400015O0020350001000100040020112O01000100192O002D00010002000200069200010031040100010004A23O003104012O0084000100023O000E31017F0020040100010004A23O002004012O0084000100083O0006392O01003104013O0004A23O003104012O00840001000A4O009900025O00202O00020002007C4O000300046O000500073O00202O00050005001D00122O0007005B6O0005000700024O000500056O00010005000200062O0001003104013O0004A23O003104012O0084000100043O001232000200803O001232000300814O0040000100034O00F300016O008400015O0020350001000100820020112O01000100032O002D0001000200020006392O01004F04013O0004A23O004F04012O008400015O0020350001000100040020112O01000100072O002D000100020002000E3101090043040100010004A23O004304012O0084000100083O00069200010043040100010004A23O004304012O0084000100023O00261B0001004F0401005B0004A23O004F04012O00840001000A4O002301025O00202O0002000200824O000300036O00010003000200062O0001004F04013O0004A23O004F04012O0084000100043O001232000200833O001232000300844O0040000100034O00F300016O008400015O0020350001000100850020112O01000100032O002D0001000200020006392O01006D04013O0004A23O006D04012O008400015O0020350001000100040020112O01000100072O002D000100020002000E3101090061040100010004A23O006104012O0084000100083O00069200010061040100010004A23O006104012O0084000100023O00261B0001006D0401005B0004A23O006D04012O00840001000A4O002301025O00202O0002000200854O000300036O00010003000200062O0001006D04013O0004A23O006D04012O0084000100043O001232000200863O001232000300874O0040000100034O00F300015O0012323O00063O0026413O00010001000E0004A23O000100012O008400015O0020350001000100880020112O01000100032O002D0001000200020006392O01008404013O0004A23O008404012O00840001000A4O002301025O00202O0002000200884O000300036O00010003000200062O0001008404013O0004A23O008404012O0084000100043O00123B000200893O00122O0003008A6O000100036O00015O00044O008404010004A23O000100012O00233O00017O007B3O00028O00026O000840030C3O00546F7563686F664B61726D61030A3O0049734361737461626C65025O00805640026O002440031D3O00F9F1182OF0E8E2F832F8F9C5E0FF4DF0FCE8FEFB1F2OF6DEF9E74DA2A003063O00B78D9E6D939803063O0042752O665570030C3O00536572656E69747942752O66026O003440030D3O00416E6365737472616C43612O6C031D3O002D07E5093F1DF40D2036E50D2005A60F2836F5093E0CE8053810A65E7C03043O006C4C698603093O00426C2O6F644675727903193O00E9C9BEEECAD4C3A4F3D7ABC6B5DEDDEED7B4EFC7FFDCF1B39C03053O00AE8BA5D181026O00F03F03093O0046697265626C2O6F6403183O00A5BAF02OC40F7F77A7F3E1C5F910756AA6BDEBD5DF43222C03083O0018C3D382A1A66310030A3O004265727365726B696E6703193O004406FB3F56044D0AE72B1315423CFA294113480AFD3513441003063O00762663894C33027O0040030B3O004261676F66547269636B73031C3O00FF27022D0626C232171B0A2BEE6606163633F834001C0034E466574A03063O00409D46657269026O00104003163O0053752O6D6F6E5768697465546967657253746174756503173O00496E766F6B655875656E54686557686974655469676572030A3O00432O6F6C646F776E5570030F3O00432O6F6C646F776E52656D61696E73026O004940026O003E4003063O0070A4A6FA155203053O007020C8C783031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572030E3O004973496E4D656C2O6552616E6765026O00144003273O003F4551B5CCA51D3B5855ACC69436255759AAFCB8362D4449BD83A826134359AAC6A52B38491CEA03073O00424C303CD8A3CB03063O0099936BE050DC03073O0044DAE619933FAE031C3O0053752O6D6F6E57686974655469676572537461747565437572736F7203273O00BE3F5E41B9A3152O44BFB92F6C58BFAA2F4173A5B92B4759B3ED295773A5A8385642BFB933131E03053O00D6CD4A332C030C3O00426F6E656475737442726577030B3O004973417661696C61626C6503093O0054696D65546F446965026O003940030B3O00426C2O6F646C757374557003093O004973496E52616E6765026O00444003293O00F342F4F37CFF73FAE972F473F6F472C55BEAF563FF73F6F570FF5EA2FF73C55FE7EE72F445F6E537AE03053O00179A2C829C026O005E40026O004E40030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66025O00804B4003083O00536572656E697479026O00374003293O0018A8BBA13D162EBEB8AB382C05AEA891211B18B2A891221A16A3BFEE35172EB5A8BC331D18B2B4EE6003063O007371C6CDCE5603083O0042752O66446F776E03103O00426F6E65647573744272657742752O66026O002E4003063O00B45BFF43814503043O003AE4379E03123O00426F6E656475737442726577506C61796572026O002040031B3O00B686DE2B38B826A0B6D23C39BA75B78DEF3D39BF30BA80C4377CF503073O0055D4E9B04E5CCD030C3O00695786E4434A85E35E5187EC03043O00822A38E8031B3O00E8BA2AE6442AF9A11BE1523AFDF527E77F2CEFA721ED492BF3F57C03063O005F8AD544832003063O00093DB350793803053O00164A48C12303123O00426F6E656475737442726577437572736F72031B3O002E76EA5D286CF74C137BF65D3B39E75C136AE14A2977ED4C3539BC03043O00384C198403123O007BCFAE2BD61ED4A522CA4C818833DD4DCEB903053O00AF3EA1CB4603063O0045786973747303093O0043616E412O7461636B031B3O003ED2CD163129CED72C372ED8D4533638E2D0162739D3CA072C7C8503053O00555CBDA373030E3O004C69676874734A7564676D656E74031E3O0025A537303DBF0F323CA837352CA224782AA80F2B2CBE353620B829787AFC03043O005849CC5003133O00496E766F6B65727344656C6967687442752O6603113O004472696E6B696E67486F726E436F766572025O00405A4003173O003D86024327D33A9A50452DE53D86024327D33A9A50177903063O00BA4EE3702649030C3O00546F7563686F66446561746803073O004973526561647903063O004865616C7468030B3O0042752O6652656D61696E73031F3O0048692O64656E4D617374657273466F7262692O64656E546F75636842752O6603043O004755494403243O00E858E8565B45F351C251567BE85FBD565745EF52FB155E7BF559B0415268FB52E915022803063O001A9C379D353303073O0047657454696D65030E3O004C61737454617267657453776170025O00408F40026O00594003233O0098D703DAB06F83DE29DDBD5198D056DABC6F9FDD1099B7568A9502D8AA5789CC5688EA03063O0030ECB876B9D803083O00446562752O66557003123O00426F6E656475737442726577446562752O6603243O00F1B24233C70BEABB6834CA35F1B51733CB0BF6B85170C235ECB31A24CE26E2B843709E6003063O005485DD3750AF03233O00A9E831A5CF63B2E11BA2C25DA9EF64A5C363AEE222E6C85ABBAA30A7D55BB8F364F79303063O003CDD8744C6A703243O00FAB2ED804AE6E1BBC78747D8FAB5B88046E6FDB8FEC34FD8E7B3B59743CBE9B8ECC3138F03063O00B98EDD98E32203233O004CCA42F94B0CF85EFA53FF4227FF18C653C55036F118CA51FC0E27F64AC252EE0362A103073O009738A5379A235303093O004973496E506172747903083O004973496E526169640044032O0012323O00013O0026413O008E000100020004A23O008E00012O008400015O0006392O01001E00013O0004A23O001E00012O0084000100013O0020350001000100030020112O01000100042O002D0001000200020006392O01001E00013O0004A23O001E00012O0084000100023O000E3101050012000100010004A23O001200012O0084000100023O00261B0001001E000100060004A23O001E00012O0084000100034O0023010200013O00202O0002000200034O000300036O00010003000200062O0001001E00013O0004A23O001E00012O0084000100043O001232000200073O001232000300084O0040000100034O00F300016O0084000100053O0020EE0001000100094O000300013O00202O00030003000A4O00010003000200062O00010028000100010004A23O002800012O0084000100023O00261B0001008D0001000B0004A23O008D0001001232000100013O00264100010050000100010004A23O005000012O0084000200013O00203500020002000C0020110102000200042O002D0002000200020006390102003D00013O0004A23O003D00012O0084000200034O0023010300013O00202O00030003000C4O000400046O00020004000200062O0002003D00013O0004A23O003D00012O0084000200043O0012320003000D3O0012320004000E4O0040000200044O00F300026O0084000200013O00203500020002000F0020110102000200042O002D0002000200020006390102004F00013O0004A23O004F00012O0084000200034O0023010300013O00202O00030003000F4O000400046O00020004000200062O0002004F00013O0004A23O004F00012O0084000200043O001232000300103O001232000400114O0040000200044O00F300025O001232000100123O00264100010077000100120004A23O007700012O0084000200013O0020350002000200130020110102000200042O002D0002000200020006390102006400013O0004A23O006400012O0084000200034O0023010300013O00202O0003000300134O000400046O00020004000200062O0002006400013O0004A23O006400012O0084000200043O001232000300143O001232000400154O0040000200044O00F300026O0084000200013O0020350002000200160020110102000200042O002D0002000200020006390102007600013O0004A23O007600012O0084000200034O0023010300013O00202O0003000300164O000400046O00020004000200062O0002007600013O0004A23O007600012O0084000200043O001232000300173O001232000400184O0040000200044O00F300025O001232000100193O00264100010029000100190004A23O002900012O0084000200013O00203500020002001A0020110102000200042O002D0002000200020006390102008D00013O0004A23O008D00012O0084000200034O0023010300013O00202O00030003001A4O000400046O00020004000200062O0002008D00013O0004A23O008D00012O0084000200043O00123B0003001B3O00122O0004001C6O000200046O00025O00044O008D00010004A23O002900010012323O001D3O0026413O00062O0100010004A23O00062O012O0084000100013O00203500010001001E0020112O01000100042O002D0001000200020006392O0100D200013O0004A23O00D200012O0084000100013O00203500010001001F0020112O01000100202O002D000100020002000692000100A8000100010004A23O00A800012O0084000100063O000E31011D00A8000100010004A23O00A800012O0084000100013O00203500010001001F0020112O01000100212O002D000100020002000E31012200A8000100010004A23O00A800012O0084000100023O002602000100D2000100230004A23O00D200012O0084000100074O0013010200043O00122O000300243O00122O000400256O00020004000200062O000100C0000100020004A23O00C000012O0084000100084O002F010200093O00202O0002000200264O0003000A3O00202O00030003002700122O000500286O0003000500024O000300036O00010003000200062O000100D200013O0004A23O00D200012O0084000100043O00123B000200293O00122O0003002A6O000100036O00015O00044O00D200012O0084000100074O0013010200043O00122O0003002B3O00122O0004002C6O00020004000200062O000100D2000100020004A23O00D200012O0084000100084O0084000200093O00203500020002002D2O002D0001000200020006392O0100D200013O0004A23O00D200012O0084000100043O0012320002002E3O0012320003002F4O0040000100034O00F300016O0084000100013O00203500010001001F0020112O01000100042O002D0001000200020006392O0100052O013O0004A23O00052O012O00840001000B3O000692000100EC000100010004A23O00EC00012O0084000100013O0020350001000100300020112O01000100312O002D0001000200020006392O0100EC00013O0004A23O00EC00012O0084000100013O0020350001000100300020112O01000100212O002D000100020002002602000100EC000100280004A23O00EC00012O00840001000A3O0020112O01000100322O002D000100020002000E31013300F4000100010004A23O00F400012O0084000100053O0020112O01000100342O002D000100020002000692000100F4000100010004A23O00F400012O0084000100023O00261B000100052O0100330004A23O00052O012O0084000100034O0099000200013O00202O00020002001F4O000300046O0005000A3O00202O00050005003500122O000700366O0005000700024O000500056O00010005000200062O000100052O013O0004A23O00052O012O0084000100043O001232000200373O001232000300384O0040000100034O00F300015O0012323O00123O0026413O00D92O0100120004A23O00D92O012O0084000100013O00203500010001001F0020112O01000100042O002D0001000200020006392O0100492O013O0004A23O00492O012O00840001000A3O0020112O01000100322O002D000100020002000E1C003300162O0100010004A23O00162O012O0084000100023O000E31013900382O0100010004A23O00382O012O0084000100023O00261B000100302O01003A0004A23O00302O012O00840001000A3O00200300010001003B4O000300013O00202O00030003003C4O00010003000200262O000100272O0100190004A23O00272O012O00840001000A3O0020352O010001003B4O000300013O00202O00030003003C4O000100030002000E2O003D00302O0100010004A23O00302O012O0084000100013O00203500010001003E0020112O01000100202O002D0001000200020006392O0100302O013O0004A23O00302O012O0084000100063O00267E000100382O0100020004A23O00382O012O0084000100053O0020112O01000100342O002D000100020002000692000100382O0100010004A23O00382O012O0084000100023O00261B000100492O01003F0004A23O00492O012O0084000100034O0099000200013O00202O00020002001F4O000300046O0005000A3O00202O00050005003500122O000700366O0005000700024O000500056O00010005000200062O000100492O013O0004A23O00492O012O0084000100043O001232000200403O001232000300414O0040000100034O00F300016O0084000100013O0020350001000100300020112O01000100042O002D0001000200020006392O0100D82O013O0004A23O00D82O012O0084000100053O0020460001000100424O000300013O00202O0003000300434O00010003000200062O000100682O013O0004A23O00682O012O0084000100013O00203500010001003E0020112O01000100202O002D0001000200020006920001006B2O0100010004A23O006B2O012O0084000100013O00203500010001003E0020112O01000100212O002D000100020002000E310144006B2O0100010004A23O006B2O012O0084000100023O00261B000100682O0100230004A23O00682O012O0084000100023O000E310106006B2O0100010004A23O006B2O012O0084000100023O00261B000100D82O0100060004A23O00D82O012O00840001000C4O0013010200043O00122O000300453O00122O000400466O00020004000200062O000100832O0100020004A23O00832O012O0084000100084O002F010200093O00202O0002000200474O0003000A3O00202O00030003003500122O000500486O0003000500024O000300036O00010003000200062O000100D82O013O0004A23O00D82O012O0084000100043O00123B000200493O00122O0003004A6O000100036O00015O00044O00D82O012O00840001000C4O0013010200043O00122O0003004B3O00122O0004004C6O00020004000200062O0001009B2O0100020004A23O009B2O012O0084000100084O002F010200013O00202O0002000200304O0003000A3O00202O00030003003500122O000500366O0003000500024O000300036O00010003000200062O000100D82O013O0004A23O00D82O012O0084000100043O00123B0002004D3O00122O0003004E6O000100036O00015O00044O00D82O012O00840001000C4O0013010200043O00122O0003004F3O00122O000400506O00020004000200062O000100B32O0100020004A23O00B32O012O0084000100084O002F010200093O00202O0002000200514O0003000A3O00202O00030003003500122O000500366O0003000500024O000300036O00010003000200062O000100D82O013O0004A23O00D82O012O0084000100043O00123B000200523O00122O000300536O000100036O00015O00044O00D82O012O00840001000C4O0013010200043O00122O000300543O00122O000400556O00020004000200062O000100D82O0100020004A23O00D82O012O00840001000D3O0006392O0100D82O013O0004A23O00D82O012O00840001000D3O0020112O01000100562O002D0001000200020006392O0100D82O013O0004A23O00D82O012O0084000100053O0020112O01000100572O00840003000D4O00422O01000300020006392O0100D82O013O0004A23O00D82O012O0084000100084O002F010200093O00202O0002000200514O0003000A3O00202O00030003003500122O000500366O0003000500024O000300036O00010003000200062O000100D82O013O0004A23O00D82O012O0084000100043O001232000200583O001232000300594O0040000100034O00F300015O0012323O00193O0026413O00EE2O01001D0004A23O00EE2O012O0084000100013O00203500010001005A0020112O01000100042O002D0001000200020006392O01004303013O0004A23O004303012O0084000100034O0023010200013O00202O00020002005A4O000300036O00010003000200062O0001004303013O0004A23O004303012O0084000100043O00123B0002005B3O00122O0003005C6O000100036O00015O00044O004303010026413O0001000100190004A23O000100012O0084000100013O00203500010001003E0020112O01000100042O002D0001000200020006392O01001E02013O0004A23O001E02012O0084000100053O0020EE0001000100094O000300013O00202O00030003005D4O00010003000200062O00010012020100010004A23O001202012O00840001000B3O0006392O01000902013O0004A23O000902012O0084000100013O00203500010001005E0020112O01000100312O002D0001000200020006392O01000902013O0004A23O000902012O0084000100023O000E31015F0012020100010004A23O001202012O0084000100013O00203500010001001F0020112O01000100312O002D0001000200020006392O01001202013O0004A23O001202012O0084000100023O00261B0001001E020100440004A23O001E02012O0084000100034O0023010200013O00202O00020002003E4O000300036O00010003000200062O0001001E02013O0004A23O001E02012O0084000100043O001232000200603O001232000300614O0040000100034O00F300016O0084000100013O0020350001000100620020112O01000100202O002D0001000200020006392O01004103013O0004A23O004103012O00840001000E3O0006392O01004103013O0004A23O00410301001232000100014O00B8000200033O0026410001009C020100120004A23O009C02012O00840004000F3O0006390104003502013O0004A23O003502012O0084000400103O0006390104003502013O0004A23O003502012O0084000400114O002B0004000100022O00A8000300043O0004A23O003C02012O0084000400013O0020350004000400620020110104000400632O002D0004000200020006390104003C02013O0004A23O003C02012O00840003000A3O0006390103009B02013O0004A23O009B02010006390102005402013O0004A23O005402012O0084000400053O0020460004000400424O000600013O00202O00060006000A4O00040006000200062O0004005402013O0004A23O005402012O0084000400124O0084000500013O0020350005000500622O002D0004000200020006390104005402013O0004A23O005402010020110104000300642O001A0004000200024O000500053O00202O0005000500644O00050002000200062O00040064020100050004A23O006402012O0084000400053O0020030004000400654O000600013O00202O0006000600664O00040006000200262O00040064020100190004A23O006402012O0084000400053O0020460104000400654O000600013O00202O0006000600664O00040006000200202O0005000300324O00050002000200062O0005009B020100040004A23O009B02010020110104000300672O00560004000200024O0005000A3O00202O0005000500674O00050002000200062O0004007D020100050004A23O007D02012O0084000400034O0099000500013O00202O0005000500624O000600076O0008000A3O00202O00080008002700122O000A00286O0008000A00024O000800086O00040008000200062O0004009B02013O0004A23O009B02012O0084000400043O00123B000500683O00122O000600696O000400066O00045O00044O009B02010012E00004006A4O00540004000100024O000500133O00202O00050005006B4O00040004000500202O00040004006C4O000500143O00062O0005009B020100040004A23O009B0201001232000400013O00264100040087020100010004A23O008702012O0084000500133O0012D60006006A6O00060001000200102O0005006B00064O000500086O000600153O00122O0007006D6O000600076O00053O000200062O0005009B02013O0004A23O009B02012O0084000500043O00123B0006006E3O00122O0007006F6O000500076O00055O00044O009B02010004A23O00870201001232000100193O00264100010033030100190004A23O003303010006390103004103013O0004A23O004103012O0084000400124O0084000500013O0020350005000500622O002D0004000200020006390104004103013O0004A23O00410301000639010200F402013O0004A23O00F402010020110104000300322O002D000400020002000E31013A00B5020100040004A23O00B502010020110104000300702O0084000600013O0020350006000600712O0042010400060002000692000400B5020100010004A23O00B502012O0084000400023O00261B00040041030100060004A23O004103012O0084000400053O0020460004000400424O000600013O00202O00060006000A4O00040006000200062O0004004103013O0004A23O004103010020110104000300672O00560004000200024O0005000A3O00202O0005000500674O00050002000200062O000400D5020100050004A23O00D502012O0084000400034O0099000500013O00202O0005000500624O000600076O0008000A3O00202O00080008002700122O000A00286O0008000A00024O000800086O00040008000200062O0004004103013O0004A23O004103012O0084000400043O00123B000500723O00122O000600736O000400066O00045O00044O004103010012E00004006A4O00540004000100024O000500133O00202O00050005006B4O00040004000500202O00040004006C4O000500143O00062O00050041030100040004A23O00410301001232000400013O002641000400DF020100010004A23O00DF02012O0084000500133O0012D60006006A6O00060001000200102O0005006B00064O000500086O000600153O00122O0007006D6O000600076O00053O000200062O0005004103013O0004A23O004103012O0084000500043O00123B000600743O00122O000700756O000500076O00055O00044O004103010004A23O00DF02010004A23O004103012O0084000400053O0020460004000400424O000600013O00202O00060006000A4O00040006000200062O0004004103013O0004A23O004103010020110104000300672O00560004000200024O0005000A3O00202O0005000500674O00050002000200062O00040014030100050004A23O001403012O0084000400034O0099000500013O00202O0005000500624O000600076O0008000A3O00202O00080008002700122O000A00286O0008000A00024O000800086O00040008000200062O0004004103013O0004A23O004103012O0084000400043O00123B000500763O00122O000600776O000400066O00045O00044O004103010012E00004006A4O00540004000100024O000500133O00202O00050005006B4O00040004000500202O00040004006C4O000500143O00062O00050041030100040004A23O00410301001232000400013O0026410004001E030100010004A23O001E03012O0084000500133O0012D60006006A6O00060001000200102O0005006B00064O000500086O000600153O00122O0007006D6O000600076O00053O000200062O0005004103013O0004A23O004103012O0084000500043O00123B000600783O00122O000700796O000500076O00055O00044O004103010004A23O001E03010004A23O0041030100264100010029020100010004A23O002902012O0084000400053O00201101040004007A2O002D0004000200020006470002003E030100040004A23O003E03012O0084000400053O00201101040004007B2O002D0004000200022O00F8000200044O00B8000300033O001232000100123O0004A23O002902010012323O00023O0004A23O000100012O00233O00017O00493O00028O00030C3O004661656C696E6553746F6D70030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66026O00F03F03093O004973496E52616E6765026O003E40031D3O00A64200E2A94D00D1B3570AE3B00316EBB2460BE7B45A3AE2B55011AEF203043O008EC02365030B3O0046697374736F664675727903073O0049735265616479030B3O0042752O6652656D61696E73030C3O00536572656E69747942752O66030C3O004361737454617267657449662O033O00DB743103083O0076B61549C387ECCC030E3O004973496E4D656C2O6552616E6765026O002040031D3O000E3509541732F20E031C551614BD1B3908450A04E9110316551719BD5C03073O009D685C7A20646D030D3O00526973696E6753756E4B69636B2O033O00AEA7D703083O00CBC3C6AFAA5D47ED026O001440031F3O003C422DDC5F16C33D5E30EA5A18FF250B2DD04314F2275F27EA5D04EF3A0B6603073O009C4E2B5EB53171030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O0008402O033O007FE1CA03073O00191288A4C36B23031D3O00EA21A84C79B3D4ACD726A04C79FCD2BDFA28A74666A5FEB4FD3EBD0F2403083O00D8884DC92F12DCA1027O004003113O005370692O6E696E674372616E654B69636B03063O0042752O66557003103O0044616E63656F664368696A6942752O6603243O003EFC22D406D58C2AD328C809D28712E722D9039C9128FE2ED401C89B12E03EC91C9CD37503073O00E24D8C4BBA68BC2O033O00B4CFC803053O002FD9AEB05F031E3O00BAD17701B95B6D3287D67F01B9146B23AAD8780BA64D472AADCE6242E00403083O0046D8BD1662D2341803133O00576869726C696E67447261676F6E50756E636803263O00CDD7AA95DFD3D1A4B8D7C8DEA488DDE5CFB689D0D29FB082C1DFD1AA93CAE5D3B694C79A8DF103053O00B3BABFC3E703093O00546967657250616C6D03173O005465616368696E67736F667468654D6F6E617374657279030B3O004973417661696C61626C65031B3O00ED361FE1EB0008E5F53258F7FC2D1DEAF02B01DBF52A0BF0B96D4C03043O0084995F7803133O00537472696B656F6674686557696E646C6F7264030B3O005468756E646572666973742O033O00BCB31603073O00C0D1D26E4D97BA03273O00F31730E0F4C1DF0C24D6EBCCE53C35E0F1C0EC0C30EDBFD7E51127E7F6D0F93C2EFCECD0A0527203063O00A4806342899F03133O00496E766F6B65727344656C6967687442752O662O033O000D88F103043O00DE60E989031E3O00BFBAB40B9BCCFFBF8CA10A9AEAB0AAB6B51A86FAE4A08CAB0A9BE7B0E8E103073O0090D9D3C77FE89303093O00497343617374696E6703073O0053746F70466F4603253O00FE262D3CC67A0D42C7292B3ACC7A0145F62C3B2495560756FD21373CCC7A0E51EB3B7E798103083O0024984F5E48B5256203073O00486173546965722O033O00DAD14903043O005FB7B827031E3O00B733E6255F8F17A100EC2F578B42A63AF5235A8916AC00EB33479442E46903073O0062D55F874634E000A8012O0012323O00013O0026413O0097000100010004A23O009700012O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O01002100013O0004A23O002100012O0084000100013O00204B0001000100044O00035O00202O0003000300054O00010003000200262O00010021000100060004A23O002100012O0084000100024O009900025O00202O0002000200024O000300046O000500013O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002100013O0004A23O002100012O0084000100033O001232000200093O0012320003000A4O0040000100034O00F300016O008400015O00203500010001000B0020112O010001000C2O002D0001000200020006392O01004600013O0004A23O004600012O0084000100043O00204B00010001000D4O00035O00202O00030003000E4O00010003000200262O00010046000100060004A23O004600012O0084000100053O0020A000010001000F4O00025O00202O00020002000B4O000300066O000400033O00122O000500103O00122O000600116O0004000600024O000500076O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O0001004600013O0004A23O004600012O0084000100033O001232000200143O001232000300154O0040000100034O00F300016O008400015O0020350001000100160020112O010001000C2O002D0001000200020006392O01006400013O0004A23O006400012O0084000100053O0020A000010001000F4O00025O00202O0002000200164O000300086O000400033O00122O000500173O00122O000600186O0004000600024O000500076O000600066O000700013O00202O00070007001200122O000900196O0007000900024O000700076O00010007000200062O0001006400013O0004A23O006400012O0084000100033O0012320002001A3O0012320003001B4O0040000100034O00F300016O008400015O00203500010001001C0020112O010001000C2O002D0001000200020006392O01009600013O0004A23O009600012O0084000100094O008400025O00203500020002001C2O002D0001000200020006392O01009600013O0004A23O009600012O0084000100043O0020A100010001001D4O00035O00202O00030003001E4O00010003000200262O000100960001001F0004A23O009600012O0084000100043O00204B00010001000D4O00035O00202O00030003001E4O00010003000200262O00010096000100060004A23O009600012O0084000100053O0020A000010001000F4O00025O00202O00020002001C4O000300086O000400033O00122O000500203O00122O000600216O0004000600024O0005000A6O000600066O000700013O00202O00070007001200122O000900196O0007000900024O000700076O00010007000200062O0001009600013O0004A23O009600012O0084000100033O001232000200223O001232000300234O0040000100034O00F300015O0012323O00063O000E360124001D2O013O0004A23O001D2O012O008400015O0020350001000100250020112O010001000C2O002D0001000200020006392O0100BD00013O0004A23O00BD00012O0084000100094O008400025O0020350002000200252O002D0001000200020006392O0100BD00013O0004A23O00BD00012O0084000100043O0020460001000100264O00035O00202O0003000300274O00010003000200062O000100BD00013O0004A23O00BD00012O0084000100024O009900025O00202O0002000200254O000300046O000500013O00202O00050005001200122O000700136O0005000700024O000500056O00010005000200062O000100BD00013O0004A23O00BD00012O0084000100033O001232000200283O001232000300294O0040000100034O00F300016O008400015O00203500010001001C0020112O010001000C2O002D0001000200020006392O0100E100013O0004A23O00E100012O0084000100094O008400025O00203500020002001C2O002D0001000200020006392O0100E100013O0004A23O00E100012O0084000100053O0020A000010001000F4O00025O00202O00020002001C4O000300086O000400033O00122O0005002A3O00122O0006002B6O0004000600024O000500076O000600066O000700013O00202O00070007001200122O000900196O0007000900024O000700076O00010007000200062O000100E100013O0004A23O00E100012O0084000100033O0012320002002C3O0012320003002D4O0040000100034O00F300016O008400015O00203500010001002E0020112O010001000C2O002D0001000200020006392O0100F800013O0004A23O00F800012O0084000100024O009900025O00202O00020002002E4O000300046O000500013O00202O00050005001200122O000700196O0005000700024O000500056O00010005000200062O000100F800013O0004A23O00F800012O0084000100033O0012320002002F3O001232000300304O0040000100034O00F300016O008400015O0020350001000100310020112O010001000C2O002D0001000200020006392O0100A72O013O0004A23O00A72O012O008400015O0020350001000100320020112O01000100332O002D0001000200020006392O0100A72O013O0004A23O00A72O012O0084000100043O00204B00010001001D4O00035O00202O00030003001E4O00010003000200262O000100A72O01001F0004A23O00A72O012O0084000100024O009900025O00202O0002000200314O000300046O000500013O00202O00050005001200122O000700196O0005000700024O000500056O00010005000200062O000100A72O013O0004A23O00A72O012O0084000100033O00123B000200343O00122O000300356O000100036O00015O00044O00A72O010026413O0001000100060004A23O000100012O008400015O0020350001000100360020112O010001000C2O002D0001000200020006392O0100432O013O0004A23O00432O012O008400015O0020350001000100370020112O01000100332O002D0001000200020006392O0100432O013O0004A23O00432O012O0084000100053O0020A000010001000F4O00025O00202O0002000200364O000300086O000400033O00122O000500383O00122O000600396O0004000600024O000500076O000600066O000700013O00202O00070007001200122O000900196O0007000900024O000700076O00010007000200062O000100432O013O0004A23O00432O012O0084000100033O0012320002003A3O0012320003003B4O0040000100034O00F300016O008400015O00203500010001000B0020112O010001000C2O002D0001000200020006392O0100682O013O0004A23O00682O012O0084000100043O0020460001000100264O00035O00202O00030003003C4O00010003000200062O000100682O013O0004A23O00682O012O0084000100053O0020A000010001000F4O00025O00202O00020002000B4O000300066O000400033O00122O0005003D3O00122O0006003E6O0004000600024O000500076O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100682O013O0004A23O00682O012O0084000100033O0012320002003F3O001232000300404O0040000100034O00F300016O0084000100043O0020460001000100414O00035O00202O00030003000B4O00010003000200062O0001007A2O013O0004A23O007A2O012O00840001000B4O00840002000C3O0020350002000200422O002D0001000200020006392O01007A2O013O0004A23O007A2O012O0084000100033O001232000200433O001232000300444O0040000100034O00F300016O008400015O00203500010001001C0020112O010001000C2O002D0001000200020006392O0100A52O013O0004A23O00A52O012O0084000100094O008400025O00203500020002001C2O002D0001000200020006392O0100A52O013O0004A23O00A52O012O0084000100043O00202E2O010001004500122O000300083O00122O000400246O00010004000200062O000100A52O013O0004A23O00A52O012O0084000100053O0020A000010001000F4O00025O00202O00020002001C4O000300086O000400033O00122O000500463O00122O000600476O0004000600024O0005000A6O000600066O000700013O00202O00070007001200122O000900196O0007000900024O000700076O00010007000200062O000100A52O013O0004A23O00A52O012O0084000100033O001232000200483O001232000300494O0040000100034O00F300015O0012323O00243O0004A23O000100012O00233O00017O006F3O00028O00026O000840030C3O00426C61636B6F75744B69636B03073O0049735265616479026O00184003073O0048617354696572026O003E40027O0040030C3O004361737454617267657449662O033O00F3AAC703053O00349EC3A917030E3O004973496E4D656C2O6552616E6765026O001440031D3O0078B033778D3A6E9F45B73B778D75688E68B93C7D922C448A75B97226D003083O00EB1ADC5214E6551B03113O005370692O6E696E674372616E654B69636B026O00204003233O009BB1E0CC7A81AFEEFD779AA0E7C74B83A8EAC9349BA4FBC77A81B5F0FD7587A4A9902C03053O0014E8C189A203093O00546967657250616C6D2O033O002FD6CB03083O001142BFA5C687EC77031A3O001BA6A916EDD7FCD003A2EE002OFAE9DF06BBB72CFEE7E9915CFF03083O00B16FCFCE739F888C030F3O0052757368696E674A61646557696E6403083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O6603213O00179C031CDD41583A831110D170480C871454C74A4D00871900CD705E0A8C50478603073O003F65E97074B42F026O001040030B3O0046697374736F664675727903063O0042752O66557003133O00496E766F6B65727344656C6967687442752O662O033O00CE3AF503063O0056A35B8D7298031D3O0055022O67296C04724C3C46196D33295619717D3347124B7235564B252B03053O005A336B141303093O00497343617374696E6703073O0053746F70466F4603243O008BF996FB2EB2FF83D03B98E29CD03E8CFE86EA31CDE380FD3883F991F6028CFF80AF6FDD03053O005DED90E58F03133O00537472696B656F6674686557696E646C6F7264030B3O005468756E64657266697374030B3O004973417661696C61626C652O033O0018F7E803063O0026759690796B03263O003EAFFC3326BED1352B84FA322884F93323BFE2353FBFAE2928A9EB3424AFF7052CB4EB7A7FE903043O005A4DDB8E03103O0044616E63656F664368696A6942752O6603233O00F5142837420E74E13B222B4D097FD90F283A2O4769E3162437451363D9052E3C0C552E03073O001A866441592C6703123O00536861646F77626F78696E675472656164732O033O00FCEA3E03053O00C491835043031D3O001CBC070B13E70BA4390311EB15F0150D0AED10B9121127E911B5465B4C03063O00887ED06668782O033O00758BD603083O003118EAAE23CF325D03263O001FE6EF817A09CDF28E4E18FAF8B76605FCF9847E1EF6BD9B741EF7F3816515CDFC87744CA1AB03053O00116C929DE803233O0058D31DE321A145C42BEE3DA945C62BE626AB408307E83DAD45CA00F410A944C654BE7703063O00C82BA3748D4F03133O00576869726C696E67447261676F6E50756E636803253O00A83E3491BCFDEDB8093991B1F3ECB1092D96BEF7EBFF253891B5FAEAAB2F0282BFF1A3EB6603073O0083DF565DE3D094030C3O004661656C696E6553746F6D70030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66026O00F03F03093O004973496E52616E6765031C3O00E544B3BA14BBE67AA5A212B8F305A5B30FB0ED4CA2AF22B4EC40F6E403063O00D583252OD67D03223O00353B2CB1EF2F252280E2342A2BBADE2D2226B4A1352E37BAEF2F3F3C80E0292E65E703053O0081464B45DF030D3O00526973696E6753756E4B69636B03113O005072652O73757265506F696E7442752O662O033O004BC2FD03063O008F26AB93891C031F3O00C28BAAFA0DE4EBC397B7CC08EAD7DBC2AAF611E6DAD996A0CC02ECD190D3E903073O00B4B0E2D99363832O033O00DEB02103043O0067B3D94F031F3O0058BE0FDC4F8B9C59A212EA4A85A041F70FD05389AD43A305EA4083A60AE64E03073O00C32AD77CB521EC2O034O00582F03063O00986D39575E45031D3O00FBDB0BA0B5DD41BCC6DC03A0B59247ADEBD2042OAACB6BA9F6D24AF7EC03083O00C899B76AC3DEB23403173O005465616368696E67736F667468654D6F6E61737465727903093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66031A3O0026EA8F385B6522E28430094937F18D33404E2BDC89324C1A66B703063O003A5283E85D29030B3O0042752O6652656D61696E732O033O008E5EDE03063O005FE337B0753D031C3O001A722248A0176B3774A0117D280BB81D6C2645A20C671C4AA41D3E7503053O00CB781E432B2O033O00FC2C4303053O00B991452D8F031C3O00881318A5D7850A0D99D7831C12E6CF8F0D1CA8D59E0626A7D38F5F4D03053O00BCEA7F79C603133O0043612O6C746F446F6D696E616E636542752O66026O0024402O033O0035330B03043O00E358527303263O00500BA8AE09767C10BC98167B4620ADAE0C774F10A8A34260460DBFA90B675A20BBA80733124B03063O0013237FDAC762031D3O001AFA0FEE15F50FDD0FEF05EF0CBB19E70EFE04EB08E235E313FE4AB34A03043O00827C9B6A002E032O0012323O00013O0026413O0098000100020004A23O009800012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01003100013O0004A23O003100012O0084000100013O00261B00010031000100050004A23O003100012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O01003100013O0004A23O003100012O0084000100033O00202E2O010001000600122O000300073O00122O000400086O00010004000200062O0001003100013O0004A23O003100012O0084000100043O0020A00001000100094O00025O00202O0002000200034O000300056O000400063O00122O0005000A3O00122O0006000B6O0004000600024O000500076O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O0001003100013O0004A23O003100012O0084000100063O0012320002000E3O0012320003000F4O0040000100034O00F300016O008400015O0020350001000100100020112O01000100042O002D0001000200020006392O01005200013O0004A23O005200012O0084000100024O008400025O0020350002000200102O002D0001000200020006392O01005200013O0004A23O005200012O0084000100094O002B0001000100020006392O01005200013O0004A23O005200012O00840001000A4O009900025O00202O0002000200104O000300046O000500083O00202O00050005000C00122O000700116O0005000700024O000500056O00010005000200062O0001005200013O0004A23O005200012O0084000100063O001232000200123O001232000300134O0040000100034O00F300016O008400015O0020350001000100140020112O01000100042O002D0001000200020006392O01007900013O0004A23O007900012O0084000100024O008400025O0020350002000200142O002D0001000200020006392O01007900013O0004A23O007900012O0084000100013O002641000100790001000D0004A23O007900012O0084000100043O0020A00001000100094O00025O00202O0002000200144O000300056O000400063O00122O000500153O00122O000600166O0004000600024O0005000B6O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O0001007900013O0004A23O007900012O0084000100063O001232000200173O001232000300184O0040000100034O00F300016O008400015O0020350001000100190020112O01000100042O002D0001000200020006392O01009700013O0004A23O009700012O0084000100033O00204600010001001A4O00035O00202O00030003001B4O00010003000200062O0001009700013O0004A23O009700012O00840001000A4O009900025O00202O0002000200194O000300046O000500083O00202O00050005000C00122O000700116O0005000700024O000500056O00010005000200062O0001009700013O0004A23O009700012O0084000100063O0012320002001C3O0012320003001D4O0040000100034O00F300015O0012323O001E3O000E360108001A2O013O0004A23O001A2O012O008400015O00203500010001001F0020112O01000100042O002D0001000200020006392O0100BF00013O0004A23O00BF00012O0084000100033O0020460001000100204O00035O00202O0003000300214O00010003000200062O000100BF00013O0004A23O00BF00012O0084000100043O0020A00001000100094O00025O00202O00020002001F4O0003000C6O000400063O00122O000500223O00122O000600236O0004000600024O0005000D6O000600066O000700083O00202O00070007000C00122O000900116O0007000900024O000700076O00010007000200062O000100BF00013O0004A23O00BF00012O0084000100063O001232000200243O001232000300254O0040000100034O00F300016O0084000100033O0020460001000100264O00035O00202O00030003001F4O00010003000200062O000100D100013O0004A23O00D100012O00840001000E4O00840002000F3O0020350002000200272O002D0001000200020006392O0100D100013O0004A23O00D100012O0084000100063O001232000200283O001232000300294O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O0100F500013O0004A23O00F500012O008400015O00203500010001002B0020112O010001002C2O002D0001000200020006392O0100F500013O0004A23O00F500012O0084000100043O0020A00001000100094O00025O00202O00020002002A4O000300056O000400063O00122O0005002D3O00122O0006002E6O0004000600024O0005000D6O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O000100F500013O0004A23O00F500012O0084000100063O0012320002002F3O001232000300304O0040000100034O00F300016O008400015O0020350001000100100020112O01000100042O002D0001000200020006392O0100192O013O0004A23O00192O012O0084000100024O008400025O0020350002000200102O002D0001000200020006392O0100192O013O0004A23O00192O012O0084000100033O0020460001000100204O00035O00202O0003000300314O00010003000200062O000100192O013O0004A23O00192O012O00840001000A4O009900025O00202O0002000200104O000300046O000500083O00202O00050005000C00122O000700116O0005000700024O000500056O00010005000200062O000100192O013O0004A23O00192O012O0084000100063O001232000200323O001232000300334O0040000100034O00F300015O0012323O00023O0026413O009C2O01001E0004A23O009C2O012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100492O013O0004A23O00492O012O008400015O0020350001000100340020112O010001002C2O002D0001000200020006392O0100492O013O0004A23O00492O012O0084000100013O000E48000200492O0100010004A23O00492O012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O0100492O013O0004A23O00492O012O0084000100043O0020A00001000100094O00025O00202O0002000200034O000300056O000400063O00122O000500353O00122O000600366O0004000600024O000500076O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O000100492O013O0004A23O00492O012O0084000100063O001232000200373O001232000300384O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O0100672O013O0004A23O00672O012O0084000100043O0020A00001000100094O00025O00202O00020002002A4O000300056O000400063O00122O000500393O00122O0006003A6O0004000600024O0005000D6O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O000100672O013O0004A23O00672O012O0084000100063O0012320002003B3O0012320003003C4O0040000100034O00F300016O008400015O0020350001000100100020112O01000100042O002D0001000200020006392O0100842O013O0004A23O00842O012O0084000100024O008400025O0020350002000200102O002D0001000200020006392O0100842O013O0004A23O00842O012O00840001000A4O009900025O00202O0002000200104O000300046O000500083O00202O00050005000C00122O000700116O0005000700024O000500056O00010005000200062O000100842O013O0004A23O00842O012O0084000100063O0012320002003D3O0012320003003E4O0040000100034O00F300016O008400015O00203500010001003F0020112O01000100042O002D0001000200020006392O01009B2O013O0004A23O009B2O012O00840001000A4O009900025O00202O00020002003F4O000300046O000500083O00202O00050005000C00122O0007000D6O0005000700024O000500056O00010005000200062O0001009B2O013O0004A23O009B2O012O0084000100063O001232000200403O001232000300414O0040000100034O00F300015O0012323O000D3O0026413O0032020100010004A23O003202012O008400015O0020350001000100420020112O01000100432O002D0001000200020006392O0100BC2O013O0004A23O00BC2O012O0084000100083O00204B0001000100444O00035O00202O0003000300454O00010003000200262O000100BC2O0100460004A23O00BC2O012O00840001000A4O009900025O00202O0002000200424O000300046O000500083O00202O00050005004700122O000700076O0005000700024O000500056O00010005000200062O000100BC2O013O0004A23O00BC2O012O0084000100063O001232000200483O001232000300494O0040000100034O00F300016O008400015O0020350001000100100020112O01000100042O002D0001000200020006392O0100E02O013O0004A23O00E02O012O0084000100024O008400025O0020350002000200102O002D0001000200020006392O0100E02O013O0004A23O00E02O012O0084000100033O0020460001000100204O00035O00202O0003000300314O00010003000200062O000100E02O013O0004A23O00E02O012O00840001000A4O009900025O00202O0002000200104O000300046O000500083O00202O00050005000C00122O000700116O0005000700024O000500056O00010005000200062O000100E02O013O0004A23O00E02O012O0084000100063O0012320002004A3O0012320003004B4O0040000100034O00F300016O008400015O00203500010001004C0020112O01000100042O002D0001000200020006392O01000C02013O0004A23O000C02012O0084000100033O0020460001000100204O00035O00202O00030003004D4O00010003000200062O0001000C02013O0004A23O000C02012O0084000100033O00202E2O010001000600122O000300073O00122O000400086O00010004000200062O0001000C02013O0004A23O000C02012O0084000100043O0020A00001000100094O00025O00202O00020002004C4O000300056O000400063O00122O0005004E3O00122O0006004F6O0004000600024O000500076O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O0001000C02013O0004A23O000C02012O0084000100063O001232000200503O001232000300514O0040000100034O00F300016O008400015O00203500010001004C0020112O01000100042O002D0001000200020006392O01003102013O0004A23O003102012O0084000100033O00202E2O010001000600122O000300073O00122O000400086O00010004000200062O0001003102013O0004A23O003102012O0084000100043O0020A00001000100094O00025O00202O00020002004C4O000300056O000400063O00122O000500523O00122O000600536O0004000600024O000500076O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O0001003102013O0004A23O003102012O0084000100063O001232000200543O001232000300554O0040000100034O00F300015O0012323O00463O0026413O007D0201000D0004A23O007D02012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01005802013O0004A23O005802012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O01005802013O0004A23O005802012O0084000100043O0020A00001000100094O00025O00202O0002000200034O000300056O000400063O00122O000500563O00122O000600576O0004000600024O0005000D6O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O0001005802013O0004A23O005802012O0084000100063O001232000200583O001232000300594O0040000100034O00F300016O008400015O0020350001000100140020112O01000100042O002D0001000200020006392O01002D03013O0004A23O002D03012O008400015O00203500010001005A0020112O010001002C2O002D0001000200020006392O01002D03013O0004A23O002D03012O0084000100033O00204B00010001005B4O00035O00202O00030003005C4O00010003000200262O0001002D030100020004A23O002D03012O00840001000A4O009900025O00202O0002000200144O000300046O000500083O00202O00050005000C00122O0007000D6O0005000700024O000500056O00010005000200062O0001002D03013O0004A23O002D03012O0084000100063O00123B0002005D3O00122O0003005E6O000100036O00015O00044O002D03010026413O0001000100460004A23O000100012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100B102013O0004A23O00B102012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O0100B102013O0004A23O00B102012O0084000100033O0020A100010001005B4O00035O00202O00030003005C4O00010003000200262O000100B1020100020004A23O00B102012O0084000100033O00204B00010001005F4O00035O00202O00030003005C4O00010003000200262O000100B1020100460004A23O00B102012O0084000100043O0020A00001000100094O00025O00202O0002000200034O000300056O000400063O00122O000500603O00122O000600616O0004000600024O000500076O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O000100B102013O0004A23O00B102012O0084000100063O001232000200623O001232000300634O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100DF02013O0004A23O00DF02012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O0100DF02013O0004A23O00DF02012O0084000100094O002B000100010002000692000100DF020100010004A23O00DF02012O008400015O0020350001000100340020112O010001002C2O002D0001000200020006392O0100DF02013O0004A23O00DF02012O0084000100043O0020A00001000100094O00025O00202O0002000200034O000300056O000400063O00122O000500643O00122O000600656O0004000600024O000500076O000600066O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O000100DF02013O0004A23O00DF02012O0084000100063O001232000200663O001232000300674O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O01000D03013O0004A23O000D03012O008400015O00203500010001002B0020112O010001002C2O002D0001000200020006392O01000D03013O0004A23O000D03012O0084000100033O0020460001000100204O00035O00202O0003000300684O00010003000200062O0001000D03013O0004A23O000D03012O0084000100013O00261B0001000D030100690004A23O000D03012O0084000100043O0020B00001000100094O00025O00202O00020002002A4O000300056O000400063O00122O0005006A3O00122O0006006B6O0004000600024O0005000D6O000600106O000700083O00202O00070007000C00122O0009000D6O0007000900024O000700076O00010007000200062O0001000D03013O0004A23O000D03012O0084000100063O0012320002006C3O0012320003006D4O0040000100034O00F300016O008400015O0020350001000100420020112O01000100432O002D0001000200020006392O01002B03013O0004A23O002B03012O0084000100083O00204B0001000100444O00035O00202O0003000300454O00010003000200262O0001002B030100080004A23O002B03012O00840001000A4O009900025O00202O0002000200424O000300046O000500083O00202O00050005004700122O000700076O0005000700024O000500056O00010005000200062O0001002B03013O0004A23O002B03012O0084000100063O0012320002006E3O0012320003006F4O0040000100034O00F300015O0012323O00083O0004A23O000100012O00233O00017O00703O00028O00026O00104003133O00537472696B656F6674686557696E646C6F726403073O0049735265616479030C3O004361737454617267657449662O033O00D8CAEE03083O00DFB5AB96CFC3961C030E3O004973496E4D656C2O6552616E6765026O00144003253O005F2EF1A7024905ECA8365832E6911E4534E7A2065E3EA3BD0C5E3FEDA71D5505B7BA491F6E03053O00692C5A83CE03113O005370692O6E696E674372616E654B69636B026O00204003223O00ECF0BBB70637F1E78DBA1A3FF1E58DB2013DF4A0A1BC1A3BF1E9A6A0376AEBA0E1EF03063O005E9F80D2D96803133O00576869726C696E67447261676F6E50756E636803243O0047F10FAD5376F77D6FFD14BE5870F74540EC08BC573FEA7F42FC08B64B66C62E44B955E703083O001A309966DF3F1F99030F3O0052757368696E674A61646557696E6403083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O6603203O001055FEFB0B4EEACC0841E9F63D57E4FD0600FEF61045E3FA1659D2A71600B9A303043O009362208D027O0040030B3O0046697374736F664675727903063O0042752O66557003133O00496E766F6B65727344656C6967687442752O662O033O001542FB03073O002B782383AA6636031C3O00520F94A2B68F8B523981A3B7A9C4470395B3ABB9904D39D3A2E5E1DC03073O00E43466E7D6C5D003093O00497343617374696E6703073O0053746F70466F4603233O0018E966DEF9B416D021E660D8F3B41AD710E370C6AA981CC41BEE7CDEF3B44DC25EB22503083O00B67E8015AA8AEB79030B3O005468756E64657266697374030B3O004973417661696C61626C652O033O0086DB2D03083O0066EBBA5586E6735003253O0044182C5679D11D580A014B7AD11D4005305B7EDB30534C2D5A60D12C5E18276026C062055E03073O0042376C5E3F12B403103O0044616E63656F664368696A6942752O6603223O00079D8C3929501A8ABA3435581A88BA3C2E5A1FCD9632355C1A84912E180D00CDD76303063O003974EDE55747026O000840030C3O00426C61636B6F75744B69636B2O033O00A7B0F503073O0027CAD18D87178E031C3O00FD3F080939F7EA2736013BFBF4731A0F20FDF13A1D130DACEB735D5803063O00989F53696A5203093O00546967657250616C6D03173O005465616368696E67736F667468654D6F6E61737465727903093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O6603193O0095CF56F7DB6391C75DFF894F84D454FCC04898F905E68908D503063O003CE1A63192A9030C3O004661656C696E6553746F6D70030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66026O00F03F03093O004973496E52616E6765026O003E40031B3O00291F2A2608092A213C3E0E0A3F5E3C2F130221173B333E533B5E7D03063O00674F7E4F4A612O033O00B776DD03063O007ADA1FB3133E03183O00A7DFCAC4DB9E55B2DAC081DAA457B6D8C4D5D09E11A7969903073O0025D3B6ADA1A9C1030D3O00526973696E6753756E4B69636B03113O005072652O73757265506F696E7442752O66030C3O00426F6E6564757374427265772O033O00FA334303073O00D9975A2DB9481B031D3O00D175F41B58C443F40758FC77EE115D836FE20053CD75F30B699768A74A03053O0036A31C877203073O00486173546965722O033O0025D25303063O001F48BB3DE22E031E3O00D10F50DB49791BD0134DED4C7727C84650D7557B2ACA125AED136A64925603073O0044A36623B2271E2O033O00B379D403083O0071DE10BAA763D5E3031E3O003C07E8FF2009C4E53B00C4FD270DF0B63D0BE9F320072OEF115AEFB67C5803043O00964E6E9B2O033O0088CC2903083O0020E5A54781C47EDF031C3O00C185C5828ADAD69DFB8A88D6C8C9D78493D0CD80D098BE81D7C996D903063O00B5A3E9A42OE103223O00439B37795E8230706F882C765E8E017C59883537438E2C725E822A6E6FDF2A3703DB03043O001730EB5E03123O00536861646F77626F78696E675472656164732O033O0071D3D603073O00B21CBAB83D3753031C3O00C6C1463FF901E0D0F24C35F105B5D7C85539FC07E1DDF21328B25DA703073O0095A4AD275C926E2O033O00FE2E1E03063O007B9347707F7A031E3O00DEC4917848CBF2916448F3C68B724D8CDE876343C2C496687998D9C2201403053O0026ACADE211030B3O0042752O6652656D61696E732O033O0040182203043O008F2D714C031B3O00BAB41D3FB3B7092887B3153FB3F80F39AABD1235ACA12368ACF84A03043O005C2OD87C03133O0043612O6C746F446F6D696E616E636542752O662O033O005633B403053O009D3B52CC2003253O002B2AF1F3E2EFECBE3E01F7F2ECD5C4B8363AEFF5FBEE93A23D2CE6F4E0FECA8E6C2AA3ABBD03083O00D1585E839A898AB3031C3O002EA0C170172D341D3BB5CB710E6322273AA4CA750A3A0E763CE1952A03083O004248C1A41C7E43510020032O0012323O00013O000E360102007400013O0004A23O007400012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002100013O0004A23O002100012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500063O00122O000600076O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001002100013O0004A23O002100012O0084000100033O0012320002000A3O0012320003000B4O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01003E00013O0004A23O003E00012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O01003E00013O0004A23O003E00012O0084000100074O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000D6O0005000700024O000500056O00010005000200062O0001003E00013O0004A23O003E00012O0084000100033O0012320002000E3O0012320003000F4O0040000100034O00F300016O008400015O0020350001000100100020112O01000100042O002D0001000200020006392O01005500013O0004A23O005500012O0084000100074O009900025O00202O0002000200104O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O0001005500013O0004A23O005500012O0084000100033O001232000200113O001232000300124O0040000100034O00F300016O008400015O0020350001000100130020112O01000100042O002D0001000200020006392O01007300013O0004A23O007300012O0084000100083O0020460001000100144O00035O00202O0003000300154O00010003000200062O0001007300013O0004A23O007300012O0084000100074O009900025O00202O0002000200134O000300046O000500053O00202O00050005000800122O0007000D6O0005000700024O000500056O00010005000200062O0001007300013O0004A23O007300012O0084000100033O001232000200163O001232000300174O0040000100034O00F300015O0012323O00093O0026413O00F6000100180004A23O00F600012O008400015O0020350001000100190020112O01000100042O002D0001000200020006392O01009B00013O0004A23O009B00012O0084000100083O00204600010001001A4O00035O00202O00030003001B4O00010003000200062O0001009B00013O0004A23O009B00012O0084000100013O0020A00001000100054O00025O00202O0002000200194O000300026O000400033O00122O0005001C3O00122O0006001D6O0004000600024O000500046O000600066O000700053O00202O00070007000800122O0009000D6O0007000900024O000700076O00010007000200062O0001009B00013O0004A23O009B00012O0084000100033O0012320002001E3O0012320003001F4O0040000100034O00F300016O0084000100083O0020460001000100204O00035O00202O0003000300194O00010003000200062O000100AD00013O0004A23O00AD00012O0084000100094O00840002000A3O0020350002000200212O002D0001000200020006392O0100AD00013O0004A23O00AD00012O0084000100033O001232000200223O001232000300234O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100D100013O0004A23O00D100012O008400015O0020350001000100240020112O01000100252O002D0001000200020006392O0100D100013O0004A23O00D100012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500263O00122O000600276O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100D100013O0004A23O00D100012O0084000100033O001232000200283O001232000300294O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100F500013O0004A23O00F500012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O0100F500013O0004A23O00F500012O0084000100083O00204600010001001A4O00035O00202O00030003002A4O00010003000200062O000100F500013O0004A23O00F500012O0084000100074O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000D6O0005000700024O000500056O00010005000200062O000100F500013O0004A23O00F500012O0084000100033O0012320002002B3O0012320003002C4O0040000100034O00F300015O0012323O002D3O000E36010900412O013O0004A23O00412O012O008400015O00203500010001002E0020112O01000100042O002D0001000200020006392O01001C2O013O0004A23O001C2O012O0084000100064O008400025O00203500020002002E2O002D0001000200020006392O01001C2O013O0004A23O001C2O012O0084000100013O0020A00001000100054O00025O00202O00020002002E4O000300026O000400033O00122O0005002F3O00122O000600306O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001001C2O013O0004A23O001C2O012O0084000100033O001232000200313O001232000300324O0040000100034O00F300016O008400015O0020350001000100330020112O01000100042O002D0001000200020006392O01001F03013O0004A23O001F03012O008400015O0020350001000100340020112O01000100252O002D0001000200020006392O01001F03013O0004A23O001F03012O0084000100083O00204B0001000100354O00035O00202O0003000300364O00010003000200262O0001001F0301002D0004A23O001F03012O0084000100074O009900025O00202O0002000200334O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O0001001F03013O0004A23O001F03012O0084000100033O00123B000200373O00122O000300386O000100036O00015O00044O001F0301000E362O0100DD2O013O0004A23O00DD2O012O008400015O0020350001000100390020112O010001003A2O002D0001000200020006392O0100612O013O0004A23O00612O012O0084000100053O00204B00010001003B4O00035O00202O00030003003C4O00010003000200262O000100612O01003D0004A23O00612O012O0084000100074O009900025O00202O0002000200394O000300046O000500053O00202O00050005003E00122O0007003F6O0005000700024O000500056O00010005000200062O000100612O013O0004A23O00612O012O0084000100033O001232000200403O001232000300414O0040000100034O00F300016O008400015O0020350001000100330020112O01000100042O002D0001000200020006392O0100852O013O0004A23O00852O012O0084000100064O008400025O0020350002000200332O002D0001000200020006392O0100852O013O0004A23O00852O012O0084000100013O0020A00001000100054O00025O00202O0002000200334O000300026O000400033O00122O000500423O00122O000600436O0004000600024O0005000B6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100852O013O0004A23O00852O012O0084000100033O001232000200443O001232000300454O0040000100034O00F300016O008400015O0020350001000100460020112O01000100042O002D0001000200020006392O0100B02O013O0004A23O00B02O012O0084000100083O00204600010001001A4O00035O00202O0003000300474O00010003000200062O000100B02O013O0004A23O00B02O012O008400015O0020350001000100480020112O01000100252O002D000100020002000692000100B02O0100010004A23O00B02O012O0084000100013O0020A00001000100054O00025O00202O0002000200464O000300026O000400033O00122O000500493O00122O0006004A6O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100B02O013O0004A23O00B02O012O0084000100033O0012320002004B3O0012320003004C4O0040000100034O00F300016O008400015O0020350001000100460020112O01000100042O002D0001000200020006392O0100DC2O013O0004A23O00DC2O012O0084000100083O00204600010001001A4O00035O00202O0003000300474O00010003000200062O000100DC2O013O0004A23O00DC2O012O0084000100083O00202E2O010001004D00122O0003003F3O00122O000400186O00010004000200062O000100DC2O013O0004A23O00DC2O012O0084000100013O0020A00001000100054O00025O00202O0002000200464O000300026O000400033O00122O0005004E3O00122O0006004F6O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100DC2O013O0004A23O00DC2O012O0084000100033O001232000200503O001232000300514O0040000100034O00F300015O0012323O003D3O0026413O007B0201002D0004A23O007B02012O008400015O0020350001000100460020112O01000100042O002D0001000200020006392O01000402013O0004A23O000402012O0084000100083O00204600010001001A4O00035O00202O0003000300474O00010003000200062O0001000402013O0004A23O000402012O0084000100013O0020A00001000100054O00025O00202O0002000200464O000300026O000400033O00122O000500523O00122O000600536O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001000402013O0004A23O000402012O0084000100033O001232000200543O001232000300554O0040000100034O00F300016O008400015O00203500010001002E0020112O01000100042O002D0001000200020006392O01002F02013O0004A23O002F02012O0084000100064O008400025O00203500020002002E2O002D0001000200020006392O01002F02013O0004A23O002F02012O0084000100083O00202E2O010001004D00122O0003003F3O00122O000400186O00010004000200062O0001002F02013O0004A23O002F02012O0084000100013O0020A00001000100054O00025O00202O00020002002E4O000300026O000400033O00122O000500563O00122O000600576O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001002F02013O0004A23O002F02012O0084000100033O001232000200583O001232000300594O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01005002013O0004A23O005002012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O01005002013O0004A23O005002012O00840001000D4O002B0001000100020006392O01005002013O0004A23O005002012O0084000100074O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000D6O0005000700024O000500056O00010005000200062O0001005002013O0004A23O005002012O0084000100033O0012320002005A3O0012320003005B4O0040000100034O00F300016O008400015O00203500010001002E0020112O01000100042O002D0001000200020006392O01007A02013O0004A23O007A02012O008400015O00203500010001005C0020112O01000100252O002D0001000200020006392O01007A02013O0004A23O007A02012O0084000100064O008400025O00203500020002002E2O002D0001000200020006392O01007A02013O0004A23O007A02012O0084000100013O0020A00001000100054O00025O00202O00020002002E4O000300026O000400033O00122O0005005D3O00122O0006005E6O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001007A02013O0004A23O007A02012O0084000100033O0012320002005F3O001232000300604O0040000100034O00F300015O0012323O00023O0026413O00010001003D0004A23O000100012O008400015O0020350001000100460020112O01000100042O002D0001000200020006392O0100A202013O0004A23O00A202012O0084000100083O00202E2O010001004D00122O0003003F3O00122O000400186O00010004000200062O000100A202013O0004A23O00A202012O0084000100013O0020A00001000100054O00025O00202O0002000200464O000300026O000400033O00122O000500613O00122O000600626O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100A202013O0004A23O00A202012O0084000100033O001232000200633O001232000300644O0040000100034O00F300016O008400015O00203500010001002E0020112O01000100042O002D0001000200020006392O0100D402013O0004A23O00D402012O0084000100064O008400025O00203500020002002E2O002D0001000200020006392O0100D402013O0004A23O00D402012O0084000100083O0020A10001000100354O00035O00202O0003000300364O00010003000200262O000100D40201002D0004A23O00D402012O0084000100083O00204B0001000100654O00035O00202O0003000300364O00010003000200262O000100D40201003D0004A23O00D402012O0084000100013O0020A00001000100054O00025O00202O00020002002E4O000300026O000400033O00122O000500663O00122O000600676O0004000600024O0005000C6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100D402013O0004A23O00D402012O0084000100033O001232000200683O001232000300694O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100FF02013O0004A23O00FF02012O008400015O0020350001000100240020112O01000100252O002D0001000200020006392O0100FF02013O0004A23O00FF02012O0084000100083O00204600010001001A4O00035O00202O00030003006A4O00010003000200062O000100FF02013O0004A23O00FF02012O0084000100013O0020B00001000100054O00025O00202O0002000200034O000300026O000400033O00122O0005006B3O00122O0006006C6O0004000600024O000500046O0006000E6O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100FF02013O0004A23O00FF02012O0084000100033O0012320002006D3O0012320003006E4O0040000100034O00F300016O008400015O0020350001000100390020112O010001003A2O002D0001000200020006392O01001D03013O0004A23O001D03012O0084000100053O00204B00010001003B4O00035O00202O00030003003C4O00010003000200262O0001001D030100180004A23O001D03012O0084000100074O009900025O00202O0002000200394O000300046O000500053O00202O00050005003E00122O0007003F6O0005000700024O000500056O00010005000200062O0001001D03013O0004A23O001D03012O0084000100033O0012320002006F3O001232000300704O0040000100034O00F300015O0012323O00183O0004A23O000100012O00233O00017O00733O00028O00026O00F03F030D3O00526973696E6753756E4B69636B03073O004973526561647903063O0042752O66557003113O005072652O73757265506F696E7442752O6603073O0048617354696572026O003E40027O0040030C3O004361737454617267657449662O033O00EA25A603063O0016874CC83846030E3O004973496E4D656C2O6552616E6765026O001440031E3O009F39EB2D53E6B223ED2A62EA8433F3644EE49F35F62D49F8B263EC640CB103063O0081ED5098443D2O033O005CA10A03073O003831C864937C77031E3O00DE37ACF9C23980E3D93080FBC53DB4B0DF3BADF5C237ABE9F36DABB09D6C03043O0090AC5EDF030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O000840030B3O0042752O6652656D61696E732O033O002906AC03043O0027446FC2031B3O00D4AAE6C472B8C3B2D8CC70B4DDE6F4C26BB2D8AFF3DE46E4C2E6B103063O00D7B6C687A719026O00184003133O00576869726C696E67447261676F6E50756E636803243O009A41E35A8140E44FB24DF8498A46E4779D5CE44B8509F94D9F4CE4419950D51B9909B91003043O0028ED298A030F3O0052757368696E674A61646557696E6403083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66026O00204003203O00D561E9F043C973C5F24BC371C5EF43C970BAEB4FD571F4F15EDE4BA9EC0A932403053O002AA7149A982O033O0047FFBA03063O00412A9EC22211031C3O00182B530F26E20EFA252C5B0F26AD08EB08225C0539F424BD0E67065E03083O008E7A47326C4D8D7B026O001C40030C3O004661656C696E6553746F6D70030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O6603093O004973496E52616E6765031B3O0013A3FA14321BA7C00B2F1AAFEF582810B0FA163201BBC04B2F55F003053O005B75C29F7803093O00546967657250616C6D2O033O0017143003073O00447A7D5E78559103183O000315C85BDAE6AA1610C21EDBDCA82O12C64AD1E6E9035C9B03073O00DA777CAF3EA8B92O033O00A8F94603043O00A4C59028031D3O0091F9B982D3B1BCE3BF85E2BD8AF3A1CBCEB391F5A482C9AFBCA3BECB8503063O00D6E390CAEBBD030B3O0046697374736F664675727903133O00496E766F6B65727344656C6967687442752O662O033O00E0A49F03083O005C8DC5E71B70D333031C3O00E0F699B7C2D9F08C9CD7F3ED93E3C2E3ED8FADD8F2E6B5F0C5A6ADDA03053O00B1869FEAC303093O00497343617374696E6703073O0053746F70466F4603233O00BBE22CB4DA82E4399FCFA8F9269FCABCE53CA5C5FDF83AB2CCB3E22BB9F6EEFF7FF29B03053O00A9DD8B5FC003133O00537472696B656F6674686557696E646C6F7264030B3O005468756E64657266697374030B3O004973417661696C61626C652O033O00D38A6703063O0046BEEB1F5F4203253O00A9F608EFEEBFDD15E0DAAEEA1FD9F2B3EC1E2OEAA8E65AF5E0A8E714EFF1A3DD49F2A5E8B603053O0085DA827A86026O00104003173O005465616368696E67736F667468654D6F6E61737465727903193O0028F6E4C1CE9C283DF3EE84CFA62A39F1EAD0C59C6B28BFB79003073O00585C9F83A4BCC303113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O6603223O00933EB645D9E2D38711BC59D6E5D8BF25B648DCABCE853CBA45DEFFC4BF7DAB0B85BD03073O00BDE04EDF2BB78B2O033O0023F58403053O00A14E9CEA76031C3O00A5BBC8DFACB8DCC898BCC0DFACF7DAD9B5B2C7D5B3AEF68FB3F79B8403043O00BCC7D7A903223O00EF195675E6F5075844EBEE08517ED7F7005C70A8EF0C4D7EE6F51D4644BBE8490C2B03053O00889C693F1B2O033O0016857703043O00547BEC19031C3O00F287AB14A7BAE59F951CA5B6FBCBB912BEB0FE82BE0E93E6E4CBF94503063O00D590EBCA77CC03123O00536861646F77626F78696E675472656164732O033O002E11D003073O002D4378BE4A4843031C3O00222EECA6F287FBFD1F29E4A6F2C8FDEC3227E3ACED91D1BA3462BEF103083O008940428DC599E88E2O033O000ED13A03053O00E863B042C603253O00FF353A0F7088C623EA1E3C0E7EB2EE25E22524096989B93FE9332D087299E013BF3568552D03083O004C8C4148661BED99031C3O004CDB132ODE0FBB75C902DDDA11FE59DF04D7D908AA53E545C69750EA03073O00DE2ABA76B2B76103133O0043612O6C746F446F6D696E616E636542752O662O033O0050ED5C03043O00EA3D8C2403253O0032C9A87B0424E2B5743035D5BF4D1828D3BE7E0033D9FA610A33D8B47B1B38E2E9664F708B03053O006F41BDDA122O033O004E4A2O03073O00CF232B7B556B3C03253O0063BEB2E3727595AFEC4664A2A5D56E792OA4E67662AEE0F97C62AFAEE36D6995F3FE3921F203053O001910CAC08A002D032O0012323O00013O000E360102008700013O0004A23O008700012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002F00013O0004A23O002F00012O0084000100013O0020460001000100054O00035O00202O0003000300064O00010003000200062O0001002F00013O0004A23O002F00012O0084000100013O00202E2O010001000700122O000300083O00122O000400096O00010004000200062O0001002F00013O0004A23O002F00012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O0005000B3O00122O0006000C6O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001002F00013O0004A23O002F00012O0084000100043O0012320002000F3O001232000300104O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01005400013O0004A23O005400012O0084000100013O00202E2O010001000700122O000300083O00122O000400096O00010004000200062O0001005400013O0004A23O005400012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O000500113O00122O000600126O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001005400013O0004A23O005400012O0084000100043O001232000200133O001232000300144O0040000100034O00F300016O008400015O0020350001000100150020112O01000100042O002D0001000200020006392O01008600013O0004A23O008600012O0084000100074O008400025O0020350002000200152O002D0001000200020006392O01008600013O0004A23O008600012O0084000100013O0020A10001000100164O00035O00202O0003000300174O00010003000200262O00010086000100180004A23O008600012O0084000100013O00204B0001000100194O00035O00202O0003000300174O00010003000200262O00010086000100020004A23O008600012O0084000100023O0020A000010001000A4O00025O00202O0002000200154O000300036O000400043O00122O0005001A3O00122O0006001B6O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001008600013O0004A23O008600012O0084000100043O0012320002001C3O0012320003001D4O0040000100034O00F300015O0012323O00093O0026413O00E30001001E0004A23O00E300012O008400015O00203500010001001F0020112O01000100042O002D0001000200020006392O0100A000013O0004A23O00A000012O0084000100084O009900025O00202O00020002001F4O000300046O000500063O00202O00050005000D00122O0007000E6O0005000700024O000500056O00010005000200062O000100A000013O0004A23O00A000012O0084000100043O001232000200203O001232000300214O0040000100034O00F300016O008400015O0020350001000100220020112O01000100042O002D0001000200020006392O0100BE00013O0004A23O00BE00012O0084000100013O0020460001000100234O00035O00202O0003000300244O00010003000200062O000100BE00013O0004A23O00BE00012O0084000100084O009900025O00202O0002000200224O000300046O000500063O00202O00050005000D00122O000700256O0005000700024O000500056O00010005000200062O000100BE00013O0004A23O00BE00012O0084000100043O001232000200263O001232000300274O0040000100034O00F300016O008400015O0020350001000100150020112O01000100042O002D0001000200020006392O0100E200013O0004A23O00E200012O0084000100074O008400025O0020350002000200152O002D0001000200020006392O0100E200013O0004A23O00E200012O0084000100023O0020A000010001000A4O00025O00202O0002000200154O000300036O000400043O00122O000500283O00122O000600296O0004000600024O000500096O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100E200013O0004A23O00E200012O0084000100043O0012320002002A3O0012320003002B4O0040000100034O00F300015O0012323O002C3O0026413O004D2O0100010004A23O004D2O012O008400015O00203500010001002D0020112O010001002E2O002D0001000200020006392O0100032O013O0004A23O00032O012O0084000100063O00204B00010001002F4O00035O00202O0003000300304O00010003000200262O000100032O0100020004A23O00032O012O0084000100084O009900025O00202O00020002002D4O000300046O000500063O00202O00050005003100122O000700086O0005000700024O000500056O00010005000200062O000100032O013O0004A23O00032O012O0084000100043O001232000200323O001232000300334O0040000100034O00F300016O008400015O0020350001000100340020112O01000100042O002D0001000200020006392O0100272O013O0004A23O00272O012O0084000100074O008400025O0020350002000200342O002D0001000200020006392O0100272O013O0004A23O00272O012O0084000100023O0020A000010001000A4O00025O00202O0002000200344O000300036O000400043O00122O000500353O00122O000600366O0004000600024O0005000A6O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100272O013O0004A23O00272O012O0084000100043O001232000200373O001232000300384O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01004C2O013O0004A23O004C2O012O0084000100013O0020460001000100054O00035O00202O0003000300064O00010003000200062O0001004C2O013O0004A23O004C2O012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O000500393O00122O0006003A6O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001004C2O013O0004A23O004C2O012O0084000100043O0012320002003B3O0012320003003C4O0040000100034O00F300015O0012323O00023O0026413O00AB2O0100180004A23O00AB2O012O008400015O00203500010001003D0020112O01000100042O002D0001000200020006392O0100742O013O0004A23O00742O012O0084000100013O0020460001000100054O00035O00202O00030003003E4O00010003000200062O000100742O013O0004A23O00742O012O0084000100023O0020A000010001000A4O00025O00202O00020002003D4O0003000B6O000400043O00122O0005003F3O00122O000600406O0004000600024O000500096O000600066O000700063O00202O00070007000D00122O000900256O0007000900024O000700076O00010007000200062O000100742O013O0004A23O00742O012O0084000100043O001232000200413O001232000300424O0040000100034O00F300016O0084000100013O0020460001000100434O00035O00202O00030003003D4O00010003000200062O000100862O013O0004A23O00862O012O00840001000C4O00840002000D3O0020350002000200442O002D0001000200020006392O0100862O013O0004A23O00862O012O0084000100043O001232000200453O001232000300464O0040000100034O00F300016O008400015O0020350001000100470020112O01000100042O002D0001000200020006392O0100AA2O013O0004A23O00AA2O012O008400015O0020350001000100480020112O01000100492O002D0001000200020006392O0100AA2O013O0004A23O00AA2O012O0084000100023O0020A000010001000A4O00025O00202O0002000200474O000300036O000400043O00122O0005004A3O00122O0006004B6O0004000600024O000500096O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100AA2O013O0004A23O00AA2O012O0084000100043O0012320002004C3O0012320003004D4O0040000100034O00F300015O0012323O004E3O0026413O00D22O01002C0004A23O00D22O012O008400015O0020350001000100340020112O01000100042O002D0001000200020006392O01002C03013O0004A23O002C03012O008400015O00203500010001004F0020112O01000100492O002D0001000200020006392O01002C03013O0004A23O002C03012O0084000100013O00204B0001000100164O00035O00202O0003000300174O00010003000200262O0001002C030100180004A23O002C03012O0084000100084O009900025O00202O0002000200344O000300046O000500063O00202O00050005000D00122O0007000E6O0005000700024O000500056O00010005000200062O0001002C03013O0004A23O002C03012O0084000100043O00123B000200503O00122O000300516O000100036O00015O00044O002C03010026413O00450201004E0004A23O004502012O008400015O0020350001000100520020112O01000100042O002D0001000200020006392O0100FC2O013O0004A23O00FC2O012O0084000100074O008400025O0020350002000200522O002D0001000200020006392O0100FC2O013O0004A23O00FC2O012O0084000100013O0020460001000100054O00035O00202O0003000300534O00010003000200062O000100FC2O013O0004A23O00FC2O012O00840001000E4O002B0001000100020006392O0100FC2O013O0004A23O00FC2O012O0084000100084O009900025O00202O0002000200524O000300046O000500063O00202O00050005000D00122O000700256O0005000700024O000500056O00010005000200062O000100FC2O013O0004A23O00FC2O012O0084000100043O001232000200543O001232000300554O0040000100034O00F300016O008400015O0020350001000100150020112O01000100042O002D0001000200020006392O01002702013O0004A23O002702012O0084000100074O008400025O0020350002000200152O002D0001000200020006392O01002702013O0004A23O002702012O0084000100013O00202E2O010001000700122O000300083O00122O000400096O00010004000200062O0001002702013O0004A23O002702012O0084000100023O0020A000010001000A4O00025O00202O0002000200154O000300036O000400043O00122O000500563O00122O000600576O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001002702013O0004A23O002702012O0084000100043O001232000200583O001232000300594O0040000100034O00F300016O008400015O0020350001000100520020112O01000100042O002D0001000200020006392O01004402013O0004A23O004402012O0084000100074O008400025O0020350002000200522O002D0001000200020006392O01004402013O0004A23O004402012O0084000100084O009900025O00202O0002000200524O000300046O000500063O00202O00050005000D00122O000700256O0005000700024O000500056O00010005000200062O0001004402013O0004A23O004402012O0084000100043O0012320002005A3O0012320003005B4O0040000100034O00F300015O0012323O000E3O0026413O00BB0201000E0004A23O00BB02012O008400015O0020350001000100150020112O01000100042O002D0001000200020006392O01007202013O0004A23O007202012O0084000100074O008400025O0020350002000200152O002D0001000200020006392O01007202013O0004A23O007202012O0084000100013O0020A10001000100164O00035O00202O0003000300174O00010003000200262O00010072020100090004A23O007202012O0084000100023O0020A000010001000A4O00025O00202O0002000200154O000300036O000400043O00122O0005005C3O00122O0006005D6O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001007202013O0004A23O007202012O0084000100043O0012320002005E3O0012320003005F4O0040000100034O00F300016O008400015O0020350001000100150020112O01000100042O002D0001000200020006392O01009C02013O0004A23O009C02012O008400015O0020350001000100600020112O01000100492O002D0001000200020006392O01009C02013O0004A23O009C02012O0084000100074O008400025O0020350002000200152O002D0001000200020006392O01009C02013O0004A23O009C02012O0084000100023O0020A000010001000A4O00025O00202O0002000200154O000300036O000400043O00122O000500613O00122O000600626O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001009C02013O0004A23O009C02012O0084000100043O001232000200633O001232000300644O0040000100034O00F300016O008400015O0020350001000100470020112O01000100042O002D0001000200020006392O0100BA02013O0004A23O00BA02012O0084000100023O0020A000010001000A4O00025O00202O0002000200474O000300036O000400043O00122O000500653O00122O000600666O0004000600024O000500096O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100BA02013O0004A23O00BA02012O0084000100043O001232000200673O001232000300684O0040000100034O00F300015O0012323O001E3O000E360109000100013O0004A23O000100012O008400015O00203500010001002D0020112O010001002E2O002D0001000200020006392O0100DB02013O0004A23O00DB02012O0084000100063O00204B00010001002F4O00035O00202O0003000300304O00010003000200262O000100DB020100090004A23O00DB02012O0084000100084O009900025O00202O00020002002D4O000300046O000500063O00202O00050005003100122O000700086O0005000700024O000500056O00010005000200062O000100DB02013O0004A23O00DB02012O0084000100043O001232000200693O0012320003006A4O0040000100034O00F300016O008400015O0020350001000100470020112O01000100042O002D0001000200020006392O01000603013O0004A23O000603012O008400015O0020350001000100480020112O01000100492O002D0001000200020006392O01000603013O0004A23O000603012O0084000100013O0020460001000100054O00035O00202O00030003006B4O00010003000200062O0001000603013O0004A23O000603012O0084000100023O0020B000010001000A4O00025O00202O0002000200474O000300036O000400043O00122O0005006C3O00122O0006006D6O0004000600024O000500096O0006000F6O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001000603013O0004A23O000603012O0084000100043O0012320002006E3O0012320003006F4O0040000100034O00F300016O008400015O0020350001000100470020112O01000100042O002D0001000200020006392O01002A03013O0004A23O002A03012O008400015O0020350001000100480020112O01000100492O002D0001000200020006392O01002A03013O0004A23O002A03012O0084000100023O0020B000010001000A4O00025O00202O0002000200474O000300036O000400043O00122O000500703O00122O000600716O0004000600024O000500096O000600106O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001002A03013O0004A23O002A03012O0084000100043O001232000200723O001232000300734O0040000100034O00F300015O0012323O00183O0004A23O000100012O00233O00017O006B3O00028O00030C3O004661656C696E6553746F6D70030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66027O004003183O00536B79726561636845786861757374696F6E446562752O66030A3O00446562752O66446F776E03093O004973496E52616E6765026O003E40031B3O00FBCAA8EEA0FAF8F4BEF6A6F9ED8BBEE7BBF1F3C2B9FB96A6E98BFF03063O00949DABCD82C903093O00546967657250616C6D03073O0049735265616479030C3O004361737454617267657449662O033O002EDD7A03063O009643B41449B1030E3O004973496E4D656C2O6552616E6765026O00144003183O0099111D489F270A4C81155A5E880A1F43840C0372DF0C5A1903043O002DED787A030D3O00526973696E6753756E4B69636B03063O0042752O66557003113O005072652O73757265506F696E7442752O662O033O00DAE1AC03043O004CB788C2031D3O0068EFF6315E482B69F3EB075B461771A6F63D424A1A73F2FC07025B542203073O00741A868558302F03073O00486173546965722O033O0013C8AE03063O00127EA1C084DD031E3O004D21BD0D2O5817BD11586023A7075D1F3BAB16535121BA1D690D3CEE550603053O00363F48CE64026O00F03F026O000840030C3O00426C61636B6F75744B69636B2O033O00C5504B03063O001BA839251A85031C3O002FA67DABDC22BF6897DC24A977E8C428B879A6DE39B343FAC36DF82A03053O00B74DCA1CC803093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O662O033O001A3A8703043O00687753E9031C3O00F7F4262148FAED331D48FCFB2C6250F0EA222C4A2OE1187057B5AA7F03053O002395984742030B3O0046697374736F6646757279030F3O00432O6F6C646F776E52656D61696E7303123O00536861646F77626F78696E67547265616473030B3O004973417661696C61626C652O033O0014E14C03053O005A798822D0031C3O00C502541DCC01400AF8055C1DCC4E461BD50B5B17D3176A4CD34E064E03043O007EA76E3503113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O66026O00204003223O002E0027F6D236331711FBCE3E331511F3D53C36503DFDCE3A33193AE1E36D29507DAA03063O005F5D704E98BC026O00104003133O00537472696B656F6674686557696E646C6F7264030B3O005468756E646572666973742O033O00CCF49D03073O00B2A195E57584DE03253O009B2OCFA5AA13992C8EE4C92OA429B12A86DFD1A3B312E6308DC9D8A2A802BF1CDACF9DFDF903083O0043E8BBBDCCC176C603133O00496E766F6B65727344656C6967687442752O662O033O00862FAD03073O008FEB4ED5405B62031C3O008B4197FD6389824EBBEF65A4940897EC62B3834190F04FE49908D6B903063O00D6ED28E4891003093O00497343617374696E6703073O0053746F70466F4603233O0083EAFCCD10998AE5D0DF16B49CDCECD80DA580EFAFCA06B480EDE6CD1A99D7F7AF8B5103063O00C6E5838FB9632O033O005C8DB003043O001331ECC803253O00ED23E4BEEFBFC138F088F0B2FB08E1BEEABEF238E4B3A4A9FB25F3B9EDAEE708A4A3A4E8AA03063O00DA9E5796D78403223O00E80ED0EC382BC3FC21DAF0372CC8C415D0E13D62DEFE0CDCEC3F36D4C44CCDA2657603073O00AD9B7EB982564203133O00576869726C696E67447261676F6E50756E636803243O00F2AEB3D584E5EBA185C39AEDE2A9B4F898F9EBA5B2879BE9F7A3B4CE9CF5DAF4AE87DBBA03063O008C85C6DAA7E82O033O00B82FAC03053O00E4D54ED41D031C3O008540B706E08859A23AE08E4FBD45F8825EB30BE293558957FFC71FEE03053O008BE72CD66503173O005465616368696E67736F667468654D6F6E61737465727903193O00CDE6015B028E2117D5E2464D15A33418D0FB1F6142A571428903083O0076B98F663E70D1512O033O0051792703083O00583C104986C5757C031E3O0042E3EBC14F57D5EBDD4F6FE1F1CB4A10F9FDDA445EE3ECD17E02FEB8991303053O0021308A98A8030B3O0042752O6652656D61696E732O033O007F1F3E03063O005712765031A1031B3O004E12DBA3BB430BCE9FBB451DD1E0A3490CDFAEB95807E5F2A40C4803053O00D02C7EBAC0031C3O00F11BA1CA1DF2CC71E40EABCB04BCDA4BE51FAACF00E5F61CE35AF59203083O002E977AC4A6749CA903133O0043612O6C746F446F6D696E616E636542752O662O033O00E8EC5E03053O009B858D267A03253O00363EBE48447A9A2A2C9355477A9A3223A2454370B7216ABF445D7AAB2C3EB57E1D6BE5747C03073O00C5454ACC212F1F2O00032O0012323O00013O0026413O00A6000100010004A23O00A600012O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O01003000013O0004A23O003000012O0084000100013O00204B0001000100044O00035O00202O0003000300054O00010003000200262O00010030000100060004A23O003000012O0084000100013O00204A0001000100044O00035O00202O0003000300074O0001000300024O000100013O00262O00010030000100060004A23O003000012O0084000100013O0020460001000100084O00035O00202O0003000300074O00010003000200062O0001003000013O0004A23O003000012O0084000100024O009900025O00202O0002000200024O000300046O000500013O00202O00050005000900122O0007000A6O0005000700024O000500056O00010005000200062O0001003000013O0004A23O003000012O0084000100033O0012320002000B3O0012320003000C4O0040000100034O00F300016O008400015O00203500010001000D0020112O010001000E2O002D0001000200020006392O01005400013O0004A23O005400012O0084000100044O008400025O00203500020002000D2O002D0001000200020006392O01005400013O0004A23O005400012O0084000100053O0020A000010001000F4O00025O00202O00020002000D4O000300066O000400033O00122O000500103O00122O000600116O0004000600024O000500076O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O0001005400013O0004A23O005400012O0084000100033O001232000200143O001232000300154O0040000100034O00F300016O008400015O0020350001000100160020112O010001000E2O002D0001000200020006392O01007900013O0004A23O007900012O0084000100083O0020460001000100174O00035O00202O0003000300184O00010003000200062O0001007900013O0004A23O007900012O0084000100053O0020A000010001000F4O00025O00202O0002000200164O000300066O000400033O00122O000500193O00122O0006001A6O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O0001007900013O0004A23O007900012O0084000100033O0012320002001B3O0012320003001C4O0040000100034O00F300016O008400015O0020350001000100160020112O010001000E2O002D0001000200020006392O0100A500013O0004A23O00A500012O0084000100083O0020460001000100174O00035O00202O0003000300184O00010003000200062O000100A500013O0004A23O00A500012O0084000100083O00202E2O010001001D00122O0003000A3O00122O000400066O00010004000200062O000100A500013O0004A23O00A500012O0084000100053O0020A000010001000F4O00025O00202O0002000200164O000300066O000400033O00122O0005001E3O00122O0006001F6O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100A500013O0004A23O00A500012O0084000100033O001232000200203O001232000300214O0040000100034O00F300015O0012323O00223O0026413O005A2O0100230004A23O005A2O012O008400015O0020350001000100240020112O010001000E2O002D0001000200020006392O0100D300013O0004A23O00D300012O0084000100044O008400025O0020350002000200242O002D0001000200020006392O0100D300013O0004A23O00D300012O0084000100083O00202E2O010001001D00122O0003000A3O00122O000400066O00010004000200062O000100D300013O0004A23O00D300012O0084000100053O0020A000010001000F4O00025O00202O0002000200244O000300066O000400033O00122O000500253O00122O000600266O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100D300013O0004A23O00D300012O0084000100033O001232000200273O001232000300284O0040000100034O00F300016O008400015O0020350001000100240020112O010001000E2O002D0001000200020006392O0100FE00013O0004A23O00FE00012O0084000100044O008400025O0020350002000200242O002D0001000200020006392O0100FE00013O0004A23O00FE00012O0084000100083O0020A10001000100294O00035O00202O00030003002A4O00010003000200262O000100FE000100060004A23O00FE00012O0084000100053O0020A000010001000F4O00025O00202O0002000200244O000300066O000400033O00122O0005002B3O00122O0006002C6O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100FE00013O0004A23O00FE00012O0084000100033O0012320002002D3O0012320003002E4O0040000100034O00F300016O008400015O0020350001000100240020112O010001000E2O002D0001000200020006392O0100352O013O0004A23O00352O012O0084000100044O008400025O0020350002000200242O002D0001000200020006392O0100352O013O0004A23O00352O012O008400015O00203500010001002F0020112O01000100302O002D000100020002000E1C001300352O0100010004A23O00352O012O008400015O0020350001000100310020112O01000100322O002D0001000200020006392O0100352O013O0004A23O00352O012O0084000100083O0020A10001000100294O00035O00202O00030003002A4O00010003000200262O000100352O0100220004A23O00352O012O0084000100053O0020A000010001000F4O00025O00202O0002000200244O000300066O000400033O00122O000500333O00122O000600346O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100352O013O0004A23O00352O012O0084000100033O001232000200353O001232000300364O0040000100034O00F300016O008400015O0020350001000100370020112O010001000E2O002D0001000200020006392O0100592O013O0004A23O00592O012O0084000100044O008400025O0020350002000200372O002D0001000200020006392O0100592O013O0004A23O00592O012O0084000100083O0020460001000100174O00035O00202O0003000300384O00010003000200062O000100592O013O0004A23O00592O012O0084000100024O009900025O00202O0002000200374O000300046O000500013O00202O00050005001200122O000700396O0005000700024O000500056O00010005000200062O000100592O013O0004A23O00592O012O0084000100033O0012320002003A3O0012320003003B4O0040000100034O00F300015O0012323O003C3O0026413O00DC2O0100060004A23O00DC2O012O008400015O00203500010001003D0020112O010001000E2O002D0001000200020006392O0100802O013O0004A23O00802O012O008400015O00203500010001003E0020112O01000100322O002D0001000200020006392O0100802O013O0004A23O00802O012O0084000100053O0020B000010001000F4O00025O00202O00020002003D4O000300066O000400033O00122O0005003F3O00122O000600406O0004000600024O0005000A6O0006000B6O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100802O013O0004A23O00802O012O0084000100033O001232000200413O001232000300424O0040000100034O00F300016O008400015O00203500010001002F0020112O010001000E2O002D0001000200020006392O0100A52O013O0004A23O00A52O012O0084000100083O0020460001000100174O00035O00202O0003000300434O00010003000200062O000100A52O013O0004A23O00A52O012O0084000100053O0020A000010001000F4O00025O00202O00020002002F4O0003000C6O000400033O00122O000500443O00122O000600456O0004000600024O0005000A6O000600066O000700013O00202O00070007001200122O000900396O0007000900024O000700076O00010007000200062O000100A52O013O0004A23O00A52O012O0084000100033O001232000200463O001232000300474O0040000100034O00F300016O0084000100083O0020460001000100484O00035O00202O00030003002F4O00010003000200062O000100B72O013O0004A23O00B72O012O00840001000D4O00840002000E3O0020350002000200492O002D0001000200020006392O0100B72O013O0004A23O00B72O012O0084000100033O0012320002004A3O0012320003004B4O0040000100034O00F300016O008400015O00203500010001003D0020112O010001000E2O002D0001000200020006392O0100DB2O013O0004A23O00DB2O012O008400015O00203500010001003E0020112O01000100322O002D0001000200020006392O0100DB2O013O0004A23O00DB2O012O0084000100053O0020A000010001000F4O00025O00202O00020002003D4O000300066O000400033O00122O0005004C3O00122O0006004D6O0004000600024O0005000A6O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100DB2O013O0004A23O00DB2O012O0084000100033O0012320002004E3O0012320003004F4O0040000100034O00F300015O0012323O00233O000E36013C005B02013O0004A23O005B02012O008400015O0020350001000100370020112O010001000E2O002D0001000200020006392O0100FB2O013O0004A23O00FB2O012O0084000100044O008400025O0020350002000200372O002D0001000200020006392O0100FB2O013O0004A23O00FB2O012O0084000100024O009900025O00202O0002000200374O000300046O000500013O00202O00050005001200122O000700396O0005000700024O000500056O00010005000200062O000100FB2O013O0004A23O00FB2O012O0084000100033O001232000200503O001232000300514O0040000100034O00F300016O008400015O0020350001000100520020112O010001000E2O002D0001000200020006392O01001202013O0004A23O001202012O0084000100024O009900025O00202O0002000200524O000300046O000500013O00202O00050005001200122O000700136O0005000700024O000500056O00010005000200062O0001001202013O0004A23O001202012O0084000100033O001232000200533O001232000300544O0040000100034O00F300016O008400015O0020350001000100240020112O010001000E2O002D0001000200020006392O01003602013O0004A23O003602012O0084000100044O008400025O0020350002000200242O002D0001000200020006392O01003602013O0004A23O003602012O0084000100053O0020A000010001000F4O00025O00202O0002000200244O000300066O000400033O00122O000500553O00122O000600566O0004000600024O0005000A6O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O0001003602013O0004A23O003602012O0084000100033O001232000200573O001232000300584O0040000100034O00F300016O008400015O00203500010001000D0020112O010001000E2O002D0001000200020006392O0100FF02013O0004A23O00FF02012O008400015O0020350001000100590020112O01000100322O002D0001000200020006392O0100FF02013O0004A23O00FF02012O0084000100083O00204B0001000100294O00035O00202O00030003002A4O00010003000200262O000100FF020100230004A23O00FF02012O0084000100024O009900025O00202O00020002000D4O000300046O000500013O00202O00050005001200122O000700136O0005000700024O000500056O00010005000200062O000100FF02013O0004A23O00FF02012O0084000100033O00123B0002005A3O00122O0003005B6O000100036O00015O00044O00FF02010026413O0001000100220004A23O000100012O008400015O0020350001000100160020112O010001000E2O002D0001000200020006392O01008202013O0004A23O008202012O0084000100083O00202E2O010001001D00122O0003000A3O00122O000400066O00010004000200062O0001008202013O0004A23O008202012O0084000100053O0020A000010001000F4O00025O00202O0002000200164O000300066O000400033O00122O0005005C3O00122O0006005D6O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O0001008202013O0004A23O008202012O0084000100033O0012320002005E3O0012320003005F4O0040000100034O00F300016O008400015O0020350001000100240020112O010001000E2O002D0001000200020006392O0100B402013O0004A23O00B402012O0084000100044O008400025O0020350002000200242O002D0001000200020006392O0100B402013O0004A23O00B402012O0084000100083O0020A10001000100294O00035O00202O00030003002A4O00010003000200262O000100B4020100230004A23O00B402012O0084000100083O00204B0001000100604O00035O00202O00030003002A4O00010003000200262O000100B4020100220004A23O00B402012O0084000100053O0020A000010001000F4O00025O00202O0002000200244O000300066O000400033O00122O000500613O00122O000600626O0004000600024O000500096O000600066O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100B402013O0004A23O00B402012O0084000100033O001232000200633O001232000300644O0040000100034O00F300016O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O0100D202013O0004A23O00D202012O0084000100013O00204B0001000100044O00035O00202O0003000300054O00010003000200262O000100D2020100060004A23O00D202012O0084000100024O009900025O00202O0002000200024O000300046O000500013O00202O00050005000900122O0007000A6O0005000700024O000500056O00010005000200062O000100D202013O0004A23O00D202012O0084000100033O001232000200653O001232000300664O0040000100034O00F300016O008400015O00203500010001003D0020112O010001000E2O002D0001000200020006392O0100FD02013O0004A23O00FD02012O008400015O00203500010001003E0020112O01000100322O002D0001000200020006392O0100FD02013O0004A23O00FD02012O0084000100083O0020460001000100174O00035O00202O0003000300674O00010003000200062O000100FD02013O0004A23O00FD02012O0084000100053O0020B000010001000F4O00025O00202O00020002003D4O000300066O000400033O00122O000500683O00122O000600696O0004000600024O0005000A6O0006000F6O000700013O00202O00070007001200122O000900136O0007000900024O000700076O00010007000200062O000100FD02013O0004A23O00FD02012O0084000100033O0012320002006A3O0012320003006B4O0040000100034O00F300015O0012323O00063O0004A23O000100012O00233O00017O00443O00028O00027O004003133O00537472696B656F6674686557696E646C6F726403073O0049735265616479030B3O005468756E64657266697374030B3O004973417661696C61626C65030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66025O00804B40030E3O004973496E4D656C2O6552616E6765026O00144003253O00E35B488EFB4A6588F6704E8FF5704D8EFE4B5688E24B1A94F55D5F89F95B43B8E35B1AD6A403043O00E7902F3A030B3O0046697374736F664675727903063O0042752O66557003133O00496E766F6B65727344656C6967687442752O66026O002040031C3O00B4D1C9610B02C03F8DDECF67017DDC3CA0DDD47C0C24F02AA6988B2303083O0059D2B8BA15785DAF03093O00497343617374696E6703073O0053746F70466F4603233O00B75A6FC16A05BE5543D36C28A86C7FD47739B45F3CC67C28B45D75C16005A2473C842103063O005AD1331CB519026O000840026O00F03F030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66030B3O0042752O6652656D61696E73031B3O00D27756EDB4DF6E43D1B4D9785CAEACD56952E0B6C46268FDAB902D03053O00DFB01B378E030C3O004661656C696E6553746F6D70030A3O0049734361737461626C6503113O004661654578706F73757265446562752O6603093O004973496E52616E6765026O003E40031C3O0022BACBB92DB5CB8A37AFC1B834FBDDB036BEC0BC30A2F1A630FB9FE503043O00D544DBAE03133O0043612O6C746F446F6D696E616E636542752O6603253O0018F431EE21C000700DDF37EF2FFA287605E42FE838C17F6C0EF226E923D1264018F463B67803083O001F6B8043874AA55F026O001040031C3O00DAE4FD4E4ABECDFCC34648B2D3A8EF4853B4D6E1E8547EA2CCA8AE1B03063O00D1B8889C2D2103133O00576869726C696E67447261676F6E50756E636803243O0010C07C1AB40EC67237BC15C97207B638D86006BB0F88660DAA02C67C1CA138DB6148EA5F03053O00D867A8156803093O00546967657250616C6D03173O005465616368696E67736F667468654D6F6E61737465727903193O006CA444A16A9253A574A003B77DBF46AA71B95A9B6BB903F72803043O00C418CD23030A3O00446562752O66446F776E031B3O00288AE60A2785E6393D9FEC0B3ECBF0033C8EED0F3A92DC153ACBB103043O00664EEB8303183O00EE2733415506A735F6237457422BB23AF33A2D7B542DF76003083O00549A4E54242759D7030D3O00526973696E6753756E4B69636B031D3O00EFE845510BFADE454D0BC2EA5F5B0EBDF2534A00F3E842413AEEF5160003053O00659D81363803253O000EBD98A2287C22A68C94377118969DA22D7D11A698AF636A18BB8FA52A6D049699BF632B4D03063O00197DC9EACB4303073O0048617354696572031C3O007BF819001F28066DCB130A172C536AF10A061A2E0760CB0B1754754103073O007319947863744703113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O6603223O001F2DB02A4F0533BE1B421E3CB7217E0734BA2F011F38AB214F0529A01B52187DEB7003053O00216C5DD944002O022O0012323O00013O0026413O0058000100020004A23O005800012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002700013O0004A23O002700012O008400015O0020350001000100050020112O01000100062O002D0001000200020006392O01002700013O0004A23O002700012O0084000100013O0020352O01000100074O00035O00202O0003000300084O000100030002000E2O00090027000100010004A23O002700012O0084000100024O009900025O00202O0002000200034O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001002700013O0004A23O002700012O0084000100033O0012320002000C3O0012320003000D4O0040000100034O00F300016O008400015O00203500010001000E0020112O01000100042O002D0001000200020006392O01004500013O0004A23O004500012O0084000100043O00204600010001000F4O00035O00202O0003000300104O00010003000200062O0001004500013O0004A23O004500012O0084000100024O009900025O00202O00020002000E4O000300046O000500013O00202O00050005000A00122O000700116O0005000700024O000500056O00010005000200062O0001004500013O0004A23O004500012O0084000100033O001232000200123O001232000300134O0040000100034O00F300016O0084000100043O0020460001000100144O00035O00202O00030003000E4O00010003000200062O0001005700013O0004A23O005700012O0084000100054O0084000200063O0020350002000200152O002D0001000200020006392O01005700013O0004A23O005700012O0084000100033O001232000200163O001232000300174O0040000100034O00F300015O0012323O00183O0026413O00D4000100190004A23O00D400012O008400015O00203500010001001A0020112O01000100042O002D0001000200020006392O01008500013O0004A23O008500012O0084000100074O008400025O00203500020002001A2O002D0001000200020006392O01008500013O0004A23O008500012O0084000100043O0020A100010001001B4O00035O00202O00030003001C4O00010003000200262O00010085000100180004A23O008500012O0084000100043O00204B00010001001D4O00035O00202O00030003001C4O00010003000200262O00010085000100190004A23O008500012O0084000100024O009900025O00202O00020002001A4O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001008500013O0004A23O008500012O0084000100033O0012320002001E3O0012320003001F4O0040000100034O00F300016O008400015O0020350001000100200020112O01000100212O002D0001000200020006392O0100A300013O0004A23O00A300012O0084000100013O00204B0001000100074O00035O00202O0003000300224O00010003000200262O000100A3000100020004A23O00A300012O0084000100024O009900025O00202O0002000200204O000300046O000500013O00202O00050005002300122O000700246O0005000700024O000500056O00010005000200062O000100A300013O0004A23O00A300012O0084000100033O001232000200253O001232000300264O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100D300013O0004A23O00D300012O008400015O0020350001000100050020112O01000100062O002D0001000200020006392O0100D300013O0004A23O00D300012O0084000100043O00204600010001000F4O00035O00202O0003000300274O00010003000200062O000100D300013O0004A23O00D300012O0084000100013O0020F60001000100074O00035O00202O0003000300084O0001000300024O000200043O00202O00020002001D4O00045O00202O0004000400274O00020004000200062O000200D3000100010004A23O00D300012O0084000100024O009900025O00202O0002000200034O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100D300013O0004A23O00D300012O0084000100033O001232000200283O001232000300294O0040000100034O00F300015O0012323O00023O0026413O002F2O01002A0004A23O002F2O012O008400015O00203500010001001A0020112O01000100042O002D0001000200020006392O0100F300013O0004A23O00F300012O0084000100074O008400025O00203500020002001A2O002D0001000200020006392O0100F300013O0004A23O00F300012O0084000100024O009900025O00202O00020002001A4O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100F300013O0004A23O00F300012O0084000100033O0012320002002B3O0012320003002C4O0040000100034O00F300016O008400015O00203500010001002D0020112O01000100042O002D0001000200020006392O01000A2O013O0004A23O000A2O012O0084000100024O009900025O00202O00020002002D4O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001000A2O013O0004A23O000A2O012O0084000100033O0012320002002E3O0012320003002F4O0040000100034O00F300016O008400015O0020350001000100300020112O01000100042O002D0001000200020006392O01000102013O0004A23O000102012O008400015O0020350001000100310020112O01000100062O002D0001000200020006392O01000102013O0004A23O000102012O0084000100043O00204B00010001001B4O00035O00202O00030003001C4O00010003000200262O00010001020100180004A23O000102012O0084000100024O009900025O00202O0002000200304O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001000102013O0004A23O000102012O0084000100033O00123B000200323O00122O000300336O000100036O00015O00044O00010201000E362O0100922O013O0004A23O00922O012O008400015O0020350001000100200020112O01000100212O002D0001000200020006392O0100562O013O0004A23O00562O012O0084000100013O00204B0001000100074O00035O00202O0003000300224O00010003000200262O000100562O0100020004A23O00562O012O0084000100013O0020460001000100344O00035O00202O0003000300084O00010003000200062O000100562O013O0004A23O00562O012O0084000100024O009900025O00202O0002000200204O000300046O000500013O00202O00050005002300122O000700246O0005000700024O000500056O00010005000200062O000100562O013O0004A23O00562O012O0084000100033O001232000200353O001232000300364O0040000100034O00F300016O008400015O0020350001000100300020112O01000100042O002D0001000200020006392O01007A2O013O0004A23O007A2O012O0084000100013O0020460001000100344O00035O00202O0003000300084O00010003000200062O0001007A2O013O0004A23O007A2O012O0084000100074O008400025O0020350002000200302O002D0001000200020006392O01007A2O013O0004A23O007A2O012O0084000100024O009900025O00202O0002000200304O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001007A2O013O0004A23O007A2O012O0084000100033O001232000200373O001232000300384O0040000100034O00F300016O008400015O0020350001000100390020112O01000100042O002D0001000200020006392O0100912O013O0004A23O00912O012O0084000100024O009900025O00202O0002000200394O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100912O013O0004A23O00912O012O0084000100033O0012320002003A3O0012320003003B4O0040000100034O00F300015O0012323O00193O0026413O0001000100180004A23O000100012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100B72O013O0004A23O00B72O012O0084000100013O0020F60001000100074O00035O00202O0003000300084O0001000300024O000200043O00202O00020002001D4O00045O00202O0004000400274O00020004000200062O000200B72O0100010004A23O00B72O012O0084000100024O009900025O00202O0002000200034O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100B72O013O0004A23O00B72O012O0084000100033O0012320002003C3O0012320003003D4O0040000100034O00F300016O008400015O00203500010001001A0020112O01000100042O002D0001000200020006392O0100DB2O013O0004A23O00DB2O012O0084000100074O008400025O00203500020002001A2O002D0001000200020006392O0100DB2O013O0004A23O00DB2O012O0084000100043O00202E2O010001003E00122O000300243O00122O000400026O00010004000200062O000100DB2O013O0004A23O00DB2O012O0084000100024O009900025O00202O00020002001A4O000300046O000500013O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100DB2O013O0004A23O00DB2O012O0084000100033O0012320002003F3O001232000300404O0040000100034O00F300016O008400015O0020350001000100410020112O01000100042O002D0001000200020006392O0100FF2O013O0004A23O00FF2O012O0084000100074O008400025O0020350002000200412O002D0001000200020006392O0100FF2O013O0004A23O00FF2O012O0084000100043O00204600010001000F4O00035O00202O0003000300424O00010003000200062O000100FF2O013O0004A23O00FF2O012O0084000100024O009900025O00202O0002000200414O000300046O000500013O00202O00050005000A00122O000700116O0005000700024O000500056O00010005000200062O000100FF2O013O0004A23O00FF2O012O0084000100033O001232000200433O001232000300444O0040000100034O00F300015O0012323O002A3O0004A23O000100012O00233O00017O006A3O00028O00026O00F03F03113O005370692O6E696E674372616E654B69636B03073O004973526561647903063O0042752O66557003103O00426F6E65647573744272657742752O66030E3O004973496E4D656C2O6552616E6765026O00204003223O00C85BA8A3D542AFAAE448B3ACD54E9EA6D248AAEDDF4EA7ACCE47B592DA44A4ED8A1B03043O00CDBB2BC1030D3O00526973696E6753756E4B69636B03113O005072652O73757265506F696E7442752O6603073O0048617354696572026O003E40027O0040030C3O004361737454617267657449662O033O00F37B0B03043O00BF9E1265026O001440031E3O00D7CA94BEA1C2FC94A2A1FAC88EB4A485C782B1AED0CF9388AECAC6C7E6FD03053O00CFA5A3E7D7030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O00084003123O00536861646F77626F78696E67547265616473030B3O004973417661696C61626C652O033O00CBF0F703063O0010A62O993644031C3O00D0BFC1453F2EECC68CCB4F372AB9D6B6C647212D2OEDB2CF437470AD03073O0099B2D3A026544103133O00576869726C696E67447261676F6E50756E636803243O00950353398E02542CBD0F482A85045414921E54288A4B5E2E840A4F2796345B24874B0B7D03043O004BE26B3A03103O0044616E63656F664368696A6942752O6603213O004BCE18741FCBC35FE1126810CCC867D518791A82C95DD8106F1DD6F259D1143A4303073O00AD38BE711A71A203133O00537472696B656F6674686557696E646C6F7264030B3O005468756E646572666973742O033O00C6DF3503053O0097ABBE4D6503243O00D63BEAA0F37834CA29C7BDF07834D226F6ADF47219C16FFCACFE7C1EC93BC7A8F7784B9103073O006BA54F98C9981D03233O004046E1D958765949D7CF467E5041E6F4446A594DE08B507A514FFDC72O405641ED8B0203063O001F372E88AB34030B3O0046697374736F66467572792O033O00DC29C403043O0094B148BC031B3O00A0BF44C7B58958D599B042C1BFF653D6A0B742DFB28956DCA3F60F03043O00B3C6D637030F3O00432O6F6C646F776E52656D61696E7303083O0042752O66446F776E031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O662O033O00FD057C03063O00B3906C121625031E3O00D4AA08802OC19C089CC1F9A8128AC486A71E8FCED3AF0FB6CEC9A65BD89703053O00AFA6C37BE903093O00457870656C4861726D2O033O00436869030A3O00432O6F6C646F776E557003193O00EADA4D4CFCD0CA5C5BFDAFC6584FF1FACE4976F1E0C71D1BA003053O00908FA23D29030D3O00436869456E6572677942752O66026O00244003223O00F3C3145E7C8E3DE7EC1E42738936DFD8145379C737E5D51C457E930CE1DC181020D503073O005380B37D3012E703083O004368694275727374030A3O0049734361737461626C65030B3O00426C2O6F646C757374557003063O00456E65726779026O00494003093O004973496E52616E6765026O00444003183O005EBFFAE2450B4FA4E79D431B5BB6E6D153215CB8F69D154A03063O007E3DD793BD2703133O00496E766F6B65727344656C6967687442752O6603223O006BEF144B76F6134247FC0F4476FA224E71FC16057CFA1B446DF3097A79F018052AA903043O0025189F7D026O002E40030B3O004372616E65566F727465782O033O00D7AF7B03043O0022BAC615031C3O00FA04C45EC9F71DD162C9F10BCE1DC6FD0EC448CEEC37C452C7B85A9D03053O00A29868A53D026O00104003223O00DE3FBB737EECC3288D7E62E4C32A8D7679E6C66FB67876E4D823A64271EAC86FE12D03063O0085AD4FD21D10030F3O0052757368696E674A61646557696E6403133O0052757368696E674A61646557696E6442752O6603203O009F69FE238472EA14877DE92EB26BE425893CE92E8B7DF8279943EC24883CBE7903043O004BED1C8D2O033O00D156C203083O0081BC3FACD14F7B87031C3O0042E8E7CE4BEBF3D97F2OEFCE4BA4E2C846E5F3C154DBE7C245A4B59903043O00AD2084862O033O00431A1003073O00AD2E7B688FCE5103253O00A70930834E863EBB1B1D9E4D863EA3142C8E498C13B05D268F438214B8091D8B4A8641E74B03073O0061D47D42EA25E32O033O0087EAB803053O007EEA83D655031C3O0086D94859448BC05D65448DD6421A4B81D3484F4390EA48554AC4861103053O002FE4B5293A030A3O004368694465666963697403183O00A5F4D00401250DB5E8993F06361EB3F0CD04023F1AE6A88903073O007FC69CB95B63500052032O0012323O00013O0026413O00A4000100020004A23O00A400012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002B00013O0004A23O002B00012O0084000100013O0020460001000100054O00035O00202O0003000300064O00010003000200062O0001002B00013O0004A23O002B00012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O01002B00013O0004A23O002B00012O0084000100034O002B0001000100020006392O01002B00013O0004A23O002B00012O0084000100044O009900025O00202O0002000200034O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002B00013O0004A23O002B00012O0084000100063O001232000200093O0012320003000A4O0040000100034O00F300016O008400015O00203500010001000B0020112O01000100042O002D0001000200020006392O01005E00013O0004A23O005E00012O0084000100013O0020460001000100054O00035O00202O0003000300064O00010003000200062O0001005E00013O0004A23O005E00012O0084000100013O0020460001000100054O00035O00202O00030003000C4O00010003000200062O0001005E00013O0004A23O005E00012O0084000100013O00202E2O010001000D00122O0003000E3O00122O0004000F6O00010004000200062O0001005E00013O0004A23O005E00012O0084000100073O0020A00001000100104O00025O00202O00020002000B4O000300086O000400063O00122O000500113O00122O000600126O0004000600024O000500096O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O0001005E00013O0004A23O005E00012O0084000100063O001232000200143O001232000300154O0040000100034O00F300016O008400015O0020350001000100160020112O01000100042O002D0001000200020006392O01008900013O0004A23O008900012O0084000100013O0020A10001000100174O00035O00202O0003000300184O00010003000200262O00010089000100190004A23O008900012O008400015O00203500010001001A0020112O010001001B2O002D0001000200020006392O01008900013O0004A23O008900012O0084000100073O0020A00001000100104O00025O00202O0002000200164O000300086O000400063O00122O0005001C3O00122O0006001D6O0004000600024O000500096O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O0001008900013O0004A23O008900012O0084000100063O0012320002001E3O0012320003001F4O0040000100034O00F300016O008400015O0020350001000100200020112O01000100042O002D0001000200020006392O0100A300013O0004A23O00A300012O00840001000A3O000E48001300A3000100010004A23O00A300012O0084000100044O009900025O00202O0002000200204O000300046O000500053O00202O00050005000700122O000700136O0005000700024O000500056O00010005000200062O000100A300013O0004A23O00A300012O0084000100063O001232000200213O001232000300224O0040000100034O00F300015O0012323O000F3O0026413O002B2O0100010004A23O002B2O012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100CE00013O0004A23O00CE00012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O0100CE00013O0004A23O00CE00012O0084000100013O0020460001000100054O00035O00202O0003000300234O00010003000200062O000100CE00013O0004A23O00CE00012O0084000100034O002B0001000100020006392O0100CE00013O0004A23O00CE00012O0084000100044O009900025O00202O0002000200034O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O000100CE00013O0004A23O00CE00012O0084000100063O001232000200243O001232000300254O0040000100034O00F300016O008400015O0020350001000100260020112O01000100042O002D0001000200020006392O0100F200013O0004A23O00F200012O008400015O0020350001000100270020112O010001001B2O002D0001000200020006392O0100F200013O0004A23O00F200012O0084000100073O0020A00001000100104O00025O00202O0002000200264O000300086O000400063O00122O000500283O00122O000600296O0004000600024O0005000B6O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O000100F200013O0004A23O00F200012O0084000100063O0012320002002A3O0012320003002B4O0040000100034O00F300016O008400015O0020350001000100200020112O01000100042O002D0001000200020006392O01000C2O013O0004A23O000C2O012O00840001000A3O000E1C0008000C2O0100010004A23O000C2O012O0084000100044O009900025O00202O0002000200204O000300046O000500053O00202O00050005000700122O000700136O0005000700024O000500056O00010005000200062O0001000C2O013O0004A23O000C2O012O0084000100063O0012320002002C3O0012320003002D4O0040000100034O00F300016O008400015O00203500010001002E0020112O01000100042O002D0001000200020006392O01002A2O013O0004A23O002A2O012O0084000100073O0020A00001000100104O00025O00202O00020002002E4O000300086O000400063O00122O0005002F3O00122O000600306O0004000600024O0005000B6O000600066O000700053O00202O00070007000700122O000900086O0007000900024O000700076O00010007000200062O0001002A2O013O0004A23O002A2O012O0084000100063O001232000200313O001232000300324O0040000100034O00F300015O0012323O00023O0026413O00EF2O01000F0004A23O00EF2O012O008400015O00203500010001000B0020112O01000100042O002D0001000200020006392O01006B2O013O0004A23O006B2O012O0084000100013O00205900010001000D00122O0003000E3O00122O0004000F6O00010004000200062O000100532O0100010004A23O00532O012O008400015O0020350001000100200020112O010001001B2O002D0001000200020006392O01006B2O013O0004A23O006B2O012O008400015O0020350001000100200020112O01000100332O002D00010002000200261B0001006B2O0100190004A23O006B2O012O008400015O00203500010001002E0020112O01000100332O002D000100020002000E1C0019006B2O0100010004A23O006B2O012O0084000100013O0020460001000100344O00035O00202O0003000300354O00010003000200062O0001006B2O013O0004A23O006B2O012O0084000100073O0020A00001000100104O00025O00202O00020002000B4O000300086O000400063O00122O000500363O00122O000600376O0004000600024O000500096O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O0001006B2O013O0004A23O006B2O012O0084000100063O001232000200383O001232000300394O0040000100034O00F300016O008400015O00203500010001003A0020112O01000100042O002D0001000200020006392O01009E2O013O0004A23O009E2O012O0084000100013O0020112O010001003B2O002D000100020002002641000100822O0100020004A23O00822O012O008400015O00203500010001000B0020112O010001003C2O002D0001000200020006920001008D2O0100010004A23O008D2O012O008400015O0020350001000100260020112O010001003C2O002D0001000200020006920001008D2O0100010004A23O008D2O012O0084000100013O0020112O010001003B2O002D0001000200020026410001009E2O01000F0004A23O009E2O012O008400015O00203500010001002E0020112O010001003C2O002D0001000200020006392O01009E2O013O0004A23O009E2O012O0084000100044O009900025O00202O00020002003A4O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001009E2O013O0004A23O009E2O012O0084000100063O0012320002003D3O0012320003003E4O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100C82O013O0004A23O00C82O012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O0100C82O013O0004A23O00C82O012O008400015O00203500010001002E0020112O01000100332O002D00010002000200261B000100C82O0100130004A23O00C82O012O0084000100013O0020352O01000100174O00035O00202O00030003003F4O000100030002000E2O004000C82O0100010004A23O00C82O012O0084000100044O009900025O00202O0002000200034O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O000100C82O013O0004A23O00C82O012O0084000100063O001232000200413O001232000300424O0040000100034O00F300016O008400015O0020350001000100430020112O01000100442O002D0001000200020006392O0100EE2O013O0004A23O00EE2O012O0084000100013O0020112O010001003B2O002D00010002000200261B000100EE2O0100130004A23O00EE2O012O0084000100013O0020112O01000100452O002D000100020002000692000100DD2O0100010004A23O00DD2O012O0084000100013O0020112O01000100462O002D00010002000200261B000100EE2O0100470004A23O00EE2O012O00840001000C4O001D00025O00202O0002000200434O000300053O00202O00030003004800122O000500496O0003000500024O000300036O000400016O00010004000200062O000100EE2O013O0004A23O00EE2O012O0084000100063O0012320002004A3O0012320003004B4O0040000100034O00F300015O0012323O00193O0026413O00B8020100190004A23O00B802012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002902013O0004A23O002902012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O01002902013O0004A23O002902012O008400015O00203500010001002E0020112O01000100332O002D000100020002000E3101190008020100010004A23O000802012O0084000100013O0020112O010001003B2O002D000100020002000E1C000F0029020100010004A23O002902012O0084000100034O002B0001000100020006392O01002902013O0004A23O002902012O0084000100013O0020112O01000100452O002D00010002000200069200010018020100010004A23O001802012O0084000100013O0020460001000100054O00035O00202O00030003004C4O00010003000200062O0001002902013O0004A23O002902012O0084000100044O009900025O00202O0002000200034O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002902013O0004A23O002902012O0084000100063O0012320002004D3O0012320003004E4O0040000100034O00F300016O008400015O0020350001000100160020112O01000100042O002D0001000200020006392O01006D02013O0004A23O006D02012O008400015O00203500010001001A0020112O010001001B2O002D0001000200020006392O01006D02013O0004A23O006D02012O0084000100024O008400025O0020350002000200162O002D0001000200020006392O01006D02013O0004A23O006D02012O0084000100013O00202E2O010001000D00122O0003000E3O00122O0004000F6O00010004000200062O0001006D02013O0004A23O006D02012O0084000100013O0020460001000100344O00035O00202O0003000300064O00010003000200062O0001006D02013O0004A23O006D02012O00840001000A3O00261B000100520201004F0004A23O005202012O008400015O0020350001000100500020112O010001001B2O002D0001000200020006392O01005502013O0004A23O005502012O00840001000A3O00261B0001006D020100080004A23O006D02012O0084000100073O0020A00001000100104O00025O00202O0002000200164O000300086O000400063O00122O000500513O00122O000600526O0004000600024O000500096O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O0001006D02013O0004A23O006D02012O0084000100063O001232000200533O001232000300544O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01009902013O0004A23O009902012O0084000100024O008400025O0020350002000200032O002D0001000200020006392O01009902013O0004A23O009902012O008400015O00203500010001002E0020112O01000100332O002D000100020002000E3101190084020100010004A23O008402012O0084000100013O0020112O010001003B2O002D000100020002000E1C00550099020100010004A23O009902012O0084000100034O002B0001000100020006392O01009902013O0004A23O009902012O0084000100044O009900025O00202O0002000200034O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001009902013O0004A23O009902012O0084000100063O001232000200563O001232000300574O0040000100034O00F300016O008400015O0020350001000100580020112O01000100042O002D0001000200020006392O0100B702013O0004A23O00B702012O0084000100013O0020460001000100344O00035O00202O0003000300594O00010003000200062O000100B702013O0004A23O00B702012O0084000100044O009900025O00202O0002000200584O000300046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O000100B702013O0004A23O00B702012O0084000100063O0012320002005A3O0012320003005B4O0040000100034O00F300015O0012323O00553O0026413O0001000100550004A23O000100012O008400015O0020350001000100160020112O01000100042O002D0001000200020006392O0100DF02013O0004A23O00DF02012O0084000100013O0020A10001000100174O00035O00202O0003000300184O00010003000200262O000100DF020100190004A23O00DF02012O0084000100073O0020A00001000100104O00025O00202O0002000200164O000300086O000400063O00122O0005005C3O00122O0006005D6O0004000600024O000500096O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O000100DF02013O0004A23O00DF02012O0084000100063O0012320002005E3O0012320003005F4O0040000100034O00F300016O008400015O0020350001000100260020112O01000100042O002D0001000200020006392O0100FD02013O0004A23O00FD02012O0084000100073O0020A00001000100104O00025O00202O0002000200264O000300086O000400063O00122O000500603O00122O000600616O0004000600024O0005000B6O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O000100FD02013O0004A23O00FD02012O0084000100063O001232000200623O001232000300634O0040000100034O00F300016O008400015O0020350001000100160020112O01000100042O002D0001000200020006392O01002B03013O0004A23O002B03012O008400015O00203500010001001A0020112O010001001B2O002D0001000200020006392O01002B03013O0004A23O002B03012O0084000100024O008400025O0020350002000200162O002D0001000200020006392O01002B03013O0004A23O002B03012O0084000100034O002B0001000100020006920001002B030100010004A23O002B03012O0084000100073O0020A00001000100104O00025O00202O0002000200164O000300086O000400063O00122O000500643O00122O000600656O0004000600024O000500096O000600066O000700053O00202O00070007000700122O000900136O0007000900024O000700076O00010007000200062O0001002B03013O0004A23O002B03012O0084000100063O001232000200663O001232000300674O0040000100034O00F300016O008400015O0020350001000100430020112O01000100042O002D0001000200020006392O01005103013O0004A23O005103012O0084000100013O0020112O01000100682O002D000100020002000E4800020039030100010004A23O003903012O00840001000A3O0026212O01003E030100020004A23O003E03012O0084000100013O0020112O01000100682O002D000100020002000E48000F0051030100010004A23O005103012O00840001000C4O001D00025O00202O0002000200434O000300053O00202O00030003004800122O000500496O0003000500024O000300036O000400016O00010004000200062O0001005103013O0004A23O005103012O0084000100063O00123B000200693O00122O0003006A6O000100036O00015O00044O005103010004A23O000100012O00233O00017O00663O00028O00027O0040030C3O00426C61636B6F75744B69636B03073O004973526561647903093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O00084003123O00536861646F77626F78696E67547265616473030B3O004973417661696C61626C65030C3O004361737454617267657449662O033O00F813C203083O00BE957AAC90C76B59030E3O004973496E4D656C2O6552616E6765026O001440031B3O003009F0FDF53D10E5C1F53B06FABEFA3703F0EBF2263AA5EABE635103053O009E5265919E030D3O00526973696E6753756E4B69636B03073O0048617354696572026O003E402O033O007DF70C03053O0024109E6276031D3O00D21FD0F256EF18F6D518FCF051EB2CA5C413C5FA4DE433DA940283AA0E03083O0085A076A39B38884703093O00457870656C4861726D2O033O00436869026O00F03F030A3O00432O6F6C646F776E557003133O00537472696B656F6674686557696E646C6F7264030B3O0046697374736F6646757279026O00204003183O00F3BA61F7BA20BDF7B07C2OB21AB3F7B77DE6894BA1B6F32903073O00D596C21192D67F03113O005370692O6E696E674372616E654B69636B030F3O00432O6F6C646F776E52656D61696E73030D3O00436869456E6572677942752O66026O00244003213O0008B9ADDA48ADAC3124AAB6D548A19D3D12AAAF9442A1A4370EA5B0EB12B0E2644B03083O00567BC9C4B426C4C22O033O00FAE1D703043O00CF9788B9031B3O00AA8F29817F77642OBC238B777331AC862E8361746597D73CC2262A03073O0011C8E348E2141803083O004368694275727374030A3O0049734361737461626C65030B3O00426C2O6F646C757374557003063O00456E65726779026O00494003093O004973496E52616E6765026O00444003173O00B34912E8CBE4FDECA4011FD2CFF0FAF3A47E4FC389A3BB03083O009FD0217BB7A9918F026O00104003063O0042752O66557003103O00426F6E65647573744272657742752O6603113O005072652O73757265506F696E7442752O662O033O00FF533603043O0056923A58031C3O004AD6F9C9A0EE09E94DD1D5CBA7EA3DBA5CDAECC1BBE522C50CCBAA9803083O009A38BF8AA0CE895603213O009549FC8972338FCBB95AE786723FBEC78F5AFEC7783F87CD9355E1B8282EC19DD603083O00ACE63995E71C5AE103083O0042752O66446F776E2O033O000FA38803063O00BB62CAE6B248031D3O0033E8B7394426DEB725441EEAAD334161E5A1364B34EDB00F1E35A1F56203053O002A4181C45003213O00115A54D4190E0CE93D494FDB19023DE50B49569A130204EF174649E5431342BC5403083O008E622A3DBA77676203133O00576869726C696E67447261676F6E50756E636803233O002FB70B1A34B60C0F07BB10093FB00C3728AA0C0B30FF060D3EBE17042C80561C78ED5A03043O006858DF622O033O0049FEEC03063O008D249782AE62031B3O008676C30E8F75D719BB71CB0E8F3AC608827BD70190459619C4299203043O006DE41AA203103O0044616E63656F664368696A6942752O6603203O004DF5F476EEEF50E2C27BF2E750E0C273E9E555A5F97DE6E74B2OE947B4F21EB703063O00863E859D1880030B3O005468756E646572666973742O033O000AA40203073O00B667C57AB94FD103233O00E093F37E0B4DCC88E7481440F6B8F67E0E4CFF88F373404CF681E0620C5CCCD3F5375403063O002893E78117602O033O0078F99403073O00BC1598EC25DBCC031A3O0046E0241853D6380A7FEF221E59A9330946E8220054D6631800BF03043O006C208957030F3O0052757368696E674A61646557696E6403133O0052757368696E674A61646557696E6442752O66031F3O00B8FD13AE26F74C66A0E904A310EE4257AEA804A329F85E55BED754B26FAA1903083O0039CA8860C64F992B2O033O00A622B203073O0098CB43CAC7EDC703243O00E957B206147046E9FC7CB4071A4A6EEFF447AC000D7139E2FF45A11A136146B2EE03F35B03083O00869A23C06F7F151903213O00AB3600042EDBB621360932D3B623360129D1B3660D0F26D3AD2A1D3574C6F8755F03063O00B2D846696A40026O0018402O033O0032227403083O00E05F4B1A96A9B5B4031B3O0009D6D92B4FA3631FE5D32147A7360FDFDE2951A062348ECC6817F403073O00166BBAB84824CC00FD022O0012323O00013O0026413O0087000100020004A23O008700012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002E00013O0004A23O002E00012O0084000100013O0020A10001000100054O00035O00202O0003000300064O00010003000200262O0001002E000100070004A23O002E00012O008400015O0020350001000100080020112O01000100092O002D0001000200020006392O01002E00013O0004A23O002E00012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O0005000B3O00122O0006000C6O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001002E00013O0004A23O002E00012O0084000100043O0012320002000F3O001232000300104O0040000100034O00F300016O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O01005300013O0004A23O005300012O0084000100013O00202E2O010001001200122O000300133O00122O000400026O00010004000200062O0001005300013O0004A23O005300012O0084000100023O0020A000010001000A4O00025O00202O0002000200114O000300036O000400043O00122O000500143O00122O000600156O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001005300013O0004A23O005300012O0084000100043O001232000200163O001232000300174O0040000100034O00F300016O008400015O0020350001000100180020112O01000100042O002D0001000200020006392O01008600013O0004A23O008600012O0084000100013O0020112O01000100192O002D0001000200020026410001006A0001001A0004A23O006A00012O008400015O0020350001000100110020112O010001001B2O002D00010002000200069200010075000100010004A23O007500012O008400015O00203500010001001C0020112O010001001B2O002D00010002000200069200010075000100010004A23O007500012O0084000100013O0020112O01000100192O002D00010002000200264100010086000100020004A23O008600012O008400015O00203500010001001D0020112O010001001B2O002D0001000200020006392O01008600013O0004A23O008600012O0084000100074O009900025O00202O0002000200184O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O0001008600013O0004A23O008600012O0084000100043O0012320002001F3O001232000300204O0040000100034O00F300015O0012323O00073O0026413O00052O0100070004A23O00052O012O008400015O0020350001000100210020112O01000100042O002D0001000200020006392O0100B300013O0004A23O00B300012O0084000100084O008400025O0020350002000200212O002D0001000200020006392O0100B300013O0004A23O00B300012O008400015O00203500010001001D0020112O01000100222O002D000100020002000E1C000700B3000100010004A23O00B300012O0084000100013O0020352O01000100054O00035O00202O0003000300234O000100030002000E2O002400B3000100010004A23O00B300012O0084000100074O009900025O00202O0002000200214O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O000100B300013O0004A23O00B300012O0084000100043O001232000200253O001232000300264O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100DE00013O0004A23O00DE00012O0084000100084O008400025O0020350002000200032O002D0001000200020006392O0100DE00013O0004A23O00DE00012O0084000100013O00202E2O010001001200122O000300133O00122O000400026O00010004000200062O000100DE00013O0004A23O00DE00012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O000500273O00122O000600286O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100DE00013O0004A23O00DE00012O0084000100043O001232000200293O0012320003002A4O0040000100034O00F300016O008400015O00203500010001002B0020112O010001002C2O002D0001000200020006392O0100042O013O0004A23O00042O012O0084000100013O0020112O01000100192O002D00010002000200261B000100042O01000E0004A23O00042O012O0084000100013O0020112O010001002D2O002D000100020002000692000100F3000100010004A23O00F300012O0084000100013O0020112O010001002E2O002D00010002000200261B000100042O01002F0004A23O00042O012O0084000100094O001D00025O00202O00020002002B4O000300063O00202O00030003003000122O000500316O0003000500024O000300036O000400016O00010004000200062O000100042O013O0004A23O00042O012O0084000100043O001232000200323O001232000300334O0040000100034O00F300015O0012323O00343O0026413O00952O01001A0004A23O00952O012O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O01003A2O013O0004A23O003A2O012O0084000100013O0020460001000100354O00035O00202O0003000300364O00010003000200062O0001003A2O013O0004A23O003A2O012O0084000100013O0020460001000100354O00035O00202O0003000300374O00010003000200062O0001003A2O013O0004A23O003A2O012O0084000100013O00202E2O010001001200122O000300133O00122O000400026O00010004000200062O0001003A2O013O0004A23O003A2O012O0084000100023O0020A000010001000A4O00025O00202O0002000200114O000300036O000400043O00122O000500383O00122O000600396O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001003A2O013O0004A23O003A2O012O0084000100043O0012320002003A3O0012320003003B4O0040000100034O00F300016O008400015O0020350001000100210020112O01000100042O002D0001000200020006392O0100622O013O0004A23O00622O012O0084000100013O0020460001000100354O00035O00202O0003000300364O00010003000200062O000100622O013O0004A23O00622O012O0084000100084O008400025O0020350002000200212O002D0001000200020006392O0100622O013O0004A23O00622O012O00840001000A4O002B0001000100020006392O0100622O013O0004A23O00622O012O0084000100074O009900025O00202O0002000200214O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O000100622O013O0004A23O00622O012O0084000100043O0012320002003C3O0012320003003D4O0040000100034O00F300016O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O0100942O013O0004A23O00942O012O0084000100013O00204600010001003E4O00035O00202O0003000300364O00010003000200062O000100942O013O0004A23O00942O012O0084000100013O0020460001000100354O00035O00202O0003000300374O00010003000200062O000100942O013O0004A23O00942O012O008400015O00203500010001001D0020112O01000100222O002D000100020002000E1C000E00942O0100010004A23O00942O012O0084000100023O0020A000010001000A4O00025O00202O0002000200114O000300036O000400043O00122O0005003F3O00122O000600406O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100942O013O0004A23O00942O012O0084000100043O001232000200413O001232000300424O0040000100034O00F300015O0012323O00023O0026414O00020100340004A24O0002012O008400015O0020350001000100210020112O01000100042O002D0001000200020006392O0100C32O013O0004A23O00C32O012O0084000100084O008400025O0020350002000200212O002D0001000200020006392O0100C32O013O0004A23O00C32O012O008400015O00203500010001001D0020112O01000100222O002D000100020002000E31010700AE2O0100010004A23O00AE2O012O0084000100013O0020112O01000100192O002D000100020002000E1C003400C32O0100010004A23O00C32O012O00840001000A4O002B0001000100020006392O0100C32O013O0004A23O00C32O012O0084000100074O009900025O00202O0002000200214O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O000100C32O013O0004A23O00C32O012O0084000100043O001232000200433O001232000300444O0040000100034O00F300016O008400015O0020350001000100450020112O01000100042O002D0001000200020006392O0100DA2O013O0004A23O00DA2O012O0084000100074O009900025O00202O0002000200454O000300046O000500063O00202O00050005000D00122O0007000E6O0005000700024O000500056O00010005000200062O000100DA2O013O0004A23O00DA2O012O0084000100043O001232000200463O001232000300474O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100FF2O013O0004A23O00FF2O012O0084000100013O0020A10001000100054O00035O00202O0003000300064O00010003000200262O000100FF2O0100070004A23O00FF2O012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O000500483O00122O000600496O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100FF2O013O0004A23O00FF2O012O0084000100043O0012320002004A3O0012320003004B4O0040000100034O00F300015O0012323O000E3O0026413O006D020100010004A23O006D02012O008400015O0020350001000100210020112O01000100042O002D0001000200020006392O01002A02013O0004A23O002A02012O0084000100084O008400025O0020350002000200212O002D0001000200020006392O01002A02013O0004A23O002A02012O0084000100013O0020460001000100354O00035O00202O00030003004C4O00010003000200062O0001002A02013O0004A23O002A02012O00840001000A4O002B0001000100020006392O01002A02013O0004A23O002A02012O0084000100074O009900025O00202O0002000200214O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O0001002A02013O0004A23O002A02012O0084000100043O0012320002004D3O0012320003004E4O0040000100034O00F300016O008400015O00203500010001001C0020112O01000100042O002D0001000200020006392O01004E02013O0004A23O004E02012O008400015O00203500010001004F0020112O01000100092O002D0001000200020006392O01004E02013O0004A23O004E02012O0084000100023O0020A000010001000A4O00025O00202O00020002001C4O000300036O000400043O00122O000500503O00122O000600516O0004000600024O0005000B6O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001004E02013O0004A23O004E02012O0084000100043O001232000200523O001232000300534O0040000100034O00F300016O008400015O00203500010001001D0020112O01000100042O002D0001000200020006392O01006C02013O0004A23O006C02012O0084000100023O0020A000010001000A4O00025O00202O00020002001D4O000300036O000400043O00122O000500543O00122O000600556O0004000600024O0005000B6O000600066O000700063O00202O00070007000D00122O0009001E6O0007000900024O000700076O00010007000200062O0001006C02013O0004A23O006C02012O0084000100043O001232000200563O001232000300574O0040000100034O00F300015O0012323O001A3O000E36010E00D402013O0004A23O00D402012O008400015O0020350001000100580020112O01000100042O002D0001000200020006392O01008D02013O0004A23O008D02012O0084000100013O00204600010001003E4O00035O00202O0003000300594O00010003000200062O0001008D02013O0004A23O008D02012O0084000100074O009900025O00202O0002000200584O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O0001008D02013O0004A23O008D02012O0084000100043O0012320002005A3O0012320003005B4O0040000100034O00F300016O008400015O00203500010001001C0020112O01000100042O002D0001000200020006392O0100AB02013O0004A23O00AB02012O0084000100023O0020A000010001000A4O00025O00202O00020002001C4O000300036O000400043O00122O0005005C3O00122O0006005D6O0004000600024O0005000B6O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100AB02013O0004A23O00AB02012O0084000100043O0012320002005E3O0012320003005F4O0040000100034O00F300016O008400015O0020350001000100210020112O01000100042O002D0001000200020006392O0100D302013O0004A23O00D302012O0084000100084O008400025O0020350002000200212O002D0001000200020006392O0100D302013O0004A23O00D302012O008400015O00203500010001001D0020112O01000100222O002D000100020002000E31010700C2020100010004A23O00C202012O0084000100013O0020112O01000100192O002D000100020002000E1C003400D3020100010004A23O00D302012O0084000100074O009900025O00202O0002000200214O000300046O000500063O00202O00050005000D00122O0007001E6O0005000700024O000500056O00010005000200062O000100D302013O0004A23O00D302012O0084000100043O001232000200603O001232000300614O0040000100034O00F300015O0012323O00623O0026413O0001000100620004A23O000100012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100FC02013O0004A23O00FC02012O0084000100084O008400025O0020350002000200032O002D0001000200020006392O0100FC02013O0004A23O00FC02012O0084000100023O0020A000010001000A4O00025O00202O0002000200034O000300036O000400043O00122O000500633O00122O000600646O0004000600024O000500056O000600066O000700063O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100FC02013O0004A23O00FC02012O0084000100043O00123B000200653O00122O000300666O000100036O00015O00044O00FC02010004A23O000100012O00233O00017O00773O00028O00027O004003093O00457870656C4861726D03073O00497352656164792O033O00436869026O00F03F030D3O00526973696E6753756E4B69636B030A3O00432O6F6C646F776E557003133O00537472696B656F6674686557696E646C6F7264030B3O0046697374736F6646757279030E3O004973496E4D656C2O6552616E6765026O00204003183O00E2A5344B02D8B5255C03A7B921480FF2B130715DF3FD751603053O006E87DD442E030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66030C3O004361737454617267657449662O033O00EE3F0203073O005B83566C8BAED3026O001440031B3O00F927B91456F43EAC2856F228B35759FE2DB90251EF14EB031DA97B03053O003D9B4BD8772O033O00092OAA03073O00BD64CBD25C386903243O003C45EF212454C227296EE9202A6EEA2O2155F1273D55BD2C2A57FC3D2345C27B3B11AF7A03043O00484F319D03063O0042752O66557003123O00536861646F77626F78696E67547265616473030B3O004973417661696C61626C65030F3O00432O6F6C646F776E52656D61696E732O033O0085B93F03043O00DCE8D051031B3O00F7B2E4332755B4E181EE392F51E1F1BBE3313956B5CAEDF1707E0E03073O00C195DE85504C3A026O000840026O0010402O033O00CB544103043O00B2A63D2F031B3O00F946E979C131EE5ED771C33DF00AEC7FCC3FEE46FC45992ABB19B803063O005E9B2A881AAA03113O005370692O6E696E674372616E654B69636B030C3O00432O6F6C646F776E446F776E03113O0053746F726D4561727468416E6446697265030C3O00426F6E65647573744272657703083O00536572656E69747903213O00972O2FBB8A3628B2BB3C34B48A3A19BE8D3C2DF5803A20B49133328AD72B66E6D203043O00D5E45F462O033O0027B2CC03053O00174ADBA2E4031B3O003BEA47AC3036F352902O30E54DEF3F3CE047BA372DD915BB7B6ABE03053O005B598626CF030F3O0052757368696E674A61646557696E6403083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66031F3O0056FBDB3E1ADE207BE4C93216EF304DE0CC7617D52145FBC4222C833304BA9803073O0047248EA85673B003103O00426F6E65647573744272657742752O6603113O005072652O73757265506F696E7442752O6603073O0048617354696572026O003E402O033O00D2A87C03083O0029BFC112DF63DE36031D3O00B92FD423A4AC19D43FA4942DCE29A1EB22C22CABBE2AD315F9BF66967A03053O00CACB46A74A03213O003F11D53D7F250FDB0C723E00D2364E2708DF38312804DA32642015E360656C508E03053O00114C61BC532O033O00882ED703083O00C3E547B95750E32B031D3O00F2F51359E1E7C31345E1DFF70953E4A0F80556EEF5F0146FBCF4BC510403053O008F809C60302O033O00B5D8FE03053O0077D8B19072031D3O00DB20EA4BC72EC651DC27C649C02AF202CD2CFF43DC25ED7D9A3DB9139F03043O0022A9499903133O00576869726C696E67447261676F6E50756E636803233O00BDE40299A6E5058C95E8198AADE305B4BAF90588A2AC0F8EACED1E87BED3589FEABE5D03043O00EBCA8C6B03083O004368694275727374030A3O0049734361737461626C65030B3O00426C2O6F646C757374557003063O00456E65726779026O00494003093O004973496E52616E6765026O00444003173O000F7C3D97EB32E5D6183430ADEF26E2C9184B67BCA975AF03083O00A56C1454C8894797030D3O00436869456E6572677942752O66026O002E4003213O0069A4228674BD258F45B7398974B1148373B720C87EB12D896FB83FB729A06BDB2803043O00E81AD44B2O033O003A407C03053O009757291288031D3O0049A62OD9F05C90D9C5F064A4C3D3F51BABCFD6FF4EA3DEEFAD4FEF998403053O009E3BCFAAB02O033O0042573D03053O00EC2F3E5329031B3O00F8A52138A18DEFBD1F30A381F1E9243EAC83EFA53404F996BAFD7203063O00E29AC9405BCA03213O00D259141644B5CF4E221B58BDCF4C221343BFCA09191D4CBDD445092719A8811D4903063O00DCA1297D782A2O033O00B178AE03043O006EDC11C0031A3O0076753519E038E4B34B723D19E077F5A272782116FF08A2B3342B03083O00C71419547A8B579103103O0044616E63656F664368696A6942752O6603203O005419D4A015E3490EE2AD09EB490CE2A512E94C49D9AB1DEB5205C99148FE075D03063O008A2769BDCE7B030B3O005468756E6465726669737403173O00496E766F6B655875656E54686557686974655469676572026O0034402O033O0012069103083O009F7F67E94D9399AF03233O0014E4F6A34BCE38FFE29554C302CFF3A34ECF0BFFF6AE00CF02F6E5BF4CDF38A3F0EA1603063O00AB679084CA202O033O001D2EF103043O006C704F89031A3O0039CB673CBE3EE63300C4613AB441ED3039C36124B93EBA217F9A03083O00555FA21448CD6189009C032O0012323O00013O0026413O00AB000100020004A23O00AB00012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01003600013O0004A23O003600012O0084000100013O0020112O01000100052O002D0001000200020026410001001A000100060004A23O001A00012O008400015O0020350001000100070020112O01000100082O002D00010002000200069200010025000100010004A23O002500012O008400015O0020350001000100090020112O01000100082O002D00010002000200069200010025000100010004A23O002500012O0084000100013O0020112O01000100052O002D00010002000200264100010036000100020004A23O003600012O008400015O00203500010001000A0020112O01000100082O002D0001000200020006392O01003600013O0004A23O003600012O0084000100024O009900025O00202O0002000200034O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001003600013O0004A23O003600012O0084000100043O0012320002000D3O0012320003000E4O0040000100034O00F300016O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O01005B00013O0004A23O005B00012O0084000100013O0020A10001000100104O00035O00202O0003000300114O00010003000200262O0001005B000100020004A23O005B00012O0084000100053O0020A00001000100124O00025O00202O00020002000F4O000300066O000400043O00122O000500133O00122O000600146O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001005B00013O0004A23O005B00012O0084000100043O001232000200163O001232000300174O0040000100034O00F300016O008400015O0020350001000100090020112O01000100042O002D0001000200020006392O01007900013O0004A23O007900012O0084000100053O0020A00001000100124O00025O00202O0002000200094O000300066O000400043O00122O000500183O00122O000600196O0004000600024O000500086O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001007900013O0004A23O007900012O0084000100043O0012320002001A3O0012320003001B4O0040000100034O00F300016O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O0100AA00013O0004A23O00AA00012O0084000100013O00204600010001001C4O00035O00202O0003000300114O00010003000200062O000100AA00013O0004A23O00AA00012O008400015O00203500010001001D0020112O010001001E2O002D00010002000200069200010092000100010004A23O009200012O008400015O0020350001000100070020112O010001001F2O002D000100020002000E1C000600AA000100010004A23O00AA00012O0084000100053O0020A00001000100124O00025O00202O00020002000F4O000300066O000400043O00122O000500203O00122O000600216O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O000100AA00013O0004A23O00AA00012O0084000100043O001232000200223O001232000300234O0040000100034O00F300015O0012323O00243O0026413O005B2O0100250004A23O005B2O012O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O0100D200013O0004A23O00D200012O0084000100013O0020A10001000100104O00035O00202O0003000300114O00010003000200262O000100D2000100240004A23O00D200012O0084000100053O0020A00001000100124O00025O00202O00020002000F4O000300066O000400043O00122O000500263O00122O000600276O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O000100D200013O0004A23O00D200012O0084000100043O001232000200283O001232000300294O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O0100122O013O0004A23O00122O012O0084000100094O008400025O00203500020002002A2O002D0001000200020006392O0100122O013O0004A23O00122O012O008400015O0020350001000100070020112O010001002B2O002D0001000200020006392O0100122O013O0004A23O00122O012O008400015O00203500010001000A0020112O010001002B2O002D0001000200020006392O0100122O013O0004A23O00122O012O0084000100013O0020112O01000100052O002D000100020002000E1C002500122O0100010004A23O00122O012O008400015O00203500010001002C0020112O010001001E2O002D0001000200020006392O0100FB00013O0004A23O00FB00012O008400015O00203500010001002D0020112O010001001E2O002D0001000200020006392O01003O013O0004A23O003O012O008400015O00203500010001002E0020112O010001001E2O002D0001000200020006392O0100122O013O0004A23O00122O012O0084000100024O009900025O00202O00020002002A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100122O013O0004A23O00122O012O0084000100043O0012320002002F3O001232000300304O0040000100034O00F300016O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O01003C2O013O0004A23O003C2O012O0084000100094O008400025O00203500020002000F2O002D0001000200020006392O01003C2O013O0004A23O003C2O012O008400015O00203500010001000A0020112O010001002B2O002D0001000200020006392O01003C2O013O0004A23O003C2O012O0084000100053O0020A00001000100124O00025O00202O00020002000F4O000300066O000400043O00122O000500313O00122O000600326O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001003C2O013O0004A23O003C2O012O0084000100043O001232000200333O001232000300344O0040000100034O00F300016O008400015O0020350001000100350020112O01000100042O002D0001000200020006392O01005A2O013O0004A23O005A2O012O0084000100013O0020460001000100364O00035O00202O0003000300374O00010003000200062O0001005A2O013O0004A23O005A2O012O0084000100024O009900025O00202O0002000200354O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001005A2O013O0004A23O005A2O012O0084000100043O001232000200383O001232000300394O0040000100034O00F300015O0012323O00153O0026413O0006020100060004A23O000602012O008400015O0020350001000100070020112O01000100042O002D0001000200020006392O0100902O013O0004A23O00902O012O0084000100013O00204600010001001C4O00035O00202O00030003003A4O00010003000200062O000100902O013O0004A23O00902O012O0084000100013O00204600010001001C4O00035O00202O00030003003B4O00010003000200062O000100902O013O0004A23O00902O012O0084000100013O00202E2O010001003C00122O0003003D3O00122O000400026O00010004000200062O000100902O013O0004A23O00902O012O0084000100053O0020A00001000100124O00025O00202O0002000200074O000300066O000400043O00122O0005003E3O00122O0006003F6O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O000100902O013O0004A23O00902O012O0084000100043O001232000200403O001232000300414O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O0100B42O013O0004A23O00B42O012O0084000100013O00204600010001001C4O00035O00202O00030003003A4O00010003000200062O000100B42O013O0004A23O00B42O012O0084000100094O008400025O00203500020002002A2O002D0001000200020006392O0100B42O013O0004A23O00B42O012O0084000100024O009900025O00202O00020002002A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100B42O013O0004A23O00B42O012O0084000100043O001232000200423O001232000300434O0040000100034O00F300016O008400015O0020350001000100070020112O01000100042O002D0001000200020006392O0100E02O013O0004A23O00E02O012O0084000100013O0020460001000100364O00035O00202O00030003003A4O00010003000200062O000100E02O013O0004A23O00E02O012O0084000100013O00204600010001001C4O00035O00202O00030003003B4O00010003000200062O000100E02O013O0004A23O00E02O012O0084000100053O0020A00001000100124O00025O00202O0002000200074O000300066O000400043O00122O000500443O00122O000600456O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O000100E02O013O0004A23O00E02O012O0084000100043O001232000200463O001232000300474O0040000100034O00F300016O008400015O0020350001000100070020112O01000100042O002D0001000200020006392O01000502013O0004A23O000502012O0084000100013O00202E2O010001003C00122O0003003D3O00122O000400026O00010004000200062O0001000502013O0004A23O000502012O0084000100053O0020A00001000100124O00025O00202O0002000200074O000300066O000400043O00122O000500483O00122O000600496O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001000502013O0004A23O000502012O0084000100043O0012320002004A3O0012320003004B4O0040000100034O00F300015O0012323O00023O000E360124009902013O0004A23O009902012O008400015O00203500010001004C0020112O01000100042O002D0001000200020006392O01001F02013O0004A23O001F02012O0084000100024O009900025O00202O00020002004C4O000300046O000500033O00202O00050005000B00122O000700156O0005000700024O000500056O00010005000200062O0001001F02013O0004A23O001F02012O0084000100043O0012320002004D3O0012320003004E4O0040000100034O00F300016O008400015O00203500010001004F0020112O01000100502O002D0001000200020006392O01004502013O0004A23O004502012O0084000100013O0020112O01000100052O002D00010002000200261B00010045020100150004A23O004502012O0084000100013O0020112O01000100512O002D00010002000200069200010034020100010004A23O003402012O0084000100013O0020112O01000100522O002D00010002000200261B00010045020100530004A23O004502012O00840001000A4O001D00025O00202O00020002004F4O000300033O00202O00030003005400122O000500556O0003000500024O000300036O000400016O00010004000200062O0001004502013O0004A23O004502012O0084000100043O001232000200563O001232000300574O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O01006F02013O0004A23O006F02012O0084000100094O008400025O00203500020002002A2O002D0001000200020006392O01006F02013O0004A23O006F02012O008400015O00203500010001000A0020112O010001001F2O002D00010002000200261B0001006F020100240004A23O006F02012O0084000100013O0020352O01000100104O00035O00202O0003000300584O000100030002000E2O0059006F020100010004A23O006F02012O0084000100024O009900025O00202O00020002002A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001006F02013O0004A23O006F02012O0084000100043O0012320002005A3O0012320003005B4O0040000100034O00F300016O008400015O0020350001000100070020112O01000100042O002D0001000200020006392O01009802013O0004A23O009802012O008400015O00203500010001000A0020112O010001001F2O002D000100020002000E1C00250098020100010004A23O009802012O0084000100013O0020112O01000100052O002D000100020002000E1C00240098020100010004A23O009802012O0084000100053O0020A00001000100124O00025O00202O0002000200074O000300066O000400043O00122O0005005C3O00122O0006005D6O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001009802013O0004A23O009802012O0084000100043O0012320002005E3O0012320003005F4O0040000100034O00F300015O0012323O00253O000E36011500FD02013O0004A23O00FD02012O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O0100C902013O0004A23O00C902012O0084000100094O008400025O00203500020002000F2O002D0001000200020006392O0100C902013O0004A23O00C902012O008400015O00203500010001001D0020112O010001001E2O002D0001000200020006392O0100C902013O0004A23O00C902012O00840001000B4O002B000100010002000692000100C9020100010004A23O00C902012O0084000100053O0020A00001000100124O00025O00202O00020002000F4O000300066O000400043O00122O000500603O00122O000600616O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O000100C902013O0004A23O00C902012O0084000100043O001232000200623O001232000300634O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O01009B03013O0004A23O009B03012O0084000100094O008400025O00203500020002002A2O002D0001000200020006392O01009B03013O0004A23O009B03012O0084000100013O0020112O01000100052O002D000100020002000E1C001500E0020100010004A23O00E002012O008400015O00203500010001002C0020112O010001001E2O002D000100020002000692000100EB020100010004A23O00EB02012O0084000100013O0020112O01000100052O002D000100020002000E1C0025009B030100010004A23O009B03012O008400015O00203500010001002E0020112O010001001E2O002D0001000200020006392O01009B03013O0004A23O009B03012O0084000100024O009900025O00202O00020002002A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001009B03013O0004A23O009B03012O0084000100043O00123B000200643O00122O000300656O000100036O00015O00044O009B03010026413O0001000100010004A23O000100012O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O01002A03013O0004A23O002A03012O0084000100013O0020A10001000100104O00035O00202O0003000300114O00010003000200262O0001002A030100240004A23O002A03012O008400015O00203500010001001D0020112O010001001E2O002D0001000200020006392O01002A03013O0004A23O002A03012O0084000100053O0020A00001000100124O00025O00202O00020002000F4O000300066O000400043O00122O000500663O00122O000600676O0004000600024O000500076O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001002A03013O0004A23O002A03012O0084000100043O001232000200683O001232000300694O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O01004E03013O0004A23O004E03012O0084000100094O008400025O00203500020002002A2O002D0001000200020006392O01004E03013O0004A23O004E03012O0084000100013O00204600010001001C4O00035O00202O00030003006A4O00010003000200062O0001004E03013O0004A23O004E03012O0084000100024O009900025O00202O00020002002A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001004E03013O0004A23O004E03012O0084000100043O0012320002006B3O0012320003006C4O0040000100034O00F300016O008400015O0020350001000100090020112O01000100042O002D0001000200020006392O01007B03013O0004A23O007B03012O008400015O00203500010001006D0020112O010001001E2O002D0001000200020006392O01007B03013O0004A23O007B03012O008400015O00203500010001006E0020112O010001001F2O002D000100020002000E31016F0063030100010004A23O006303012O00840001000C3O00261B0001007B030100150004A23O007B03012O0084000100053O0020A00001000100124O00025O00202O0002000200094O000300066O000400043O00122O000500703O00122O000600716O0004000600024O000500086O000600066O000700033O00202O00070007000B00122O000900156O0007000900024O000700076O00010007000200062O0001007B03013O0004A23O007B03012O0084000100043O001232000200723O001232000300734O0040000100034O00F300016O008400015O00203500010001000A0020112O01000100042O002D0001000200020006392O01009903013O0004A23O009903012O0084000100053O0020A00001000100124O00025O00202O00020002000A4O0003000D6O000400043O00122O000500743O00122O000600756O0004000600024O000500086O000600066O000700033O00202O00070007000B00122O0009000C6O0007000900024O000700076O00010007000200062O0001009903013O0004A23O009903012O0084000100043O001232000200763O001232000300774O0040000100034O00F300015O0012323O00063O0004A23O000100012O00233O00017O00803O00028O00026O00084003133O00537472696B656F6674686557696E646C6F726403073O0049735265616479030C3O004361737454617267657449662O033O00FAFC3203073O00AD979D4ABC6D98030E3O004973496E4D656C2O6552616E6765026O00144003243O00371C2AD4D751EAFC22372CD5D96BC2FA2A0C34D2CE5095F7210E39C8D040EAA130486A8B03083O0093446858BDBC34B5030C3O00426C61636B6F75744B69636B03063O0042752O665570031B3O005465616368696E67736F667468654D6F6E61737465727942752O6603123O00536861646F77626F78696E67547265616473030B3O004973417661696C61626C65030D3O00526973696E6753756E4B69636B030F3O00432O6F6C646F776E52656D61696E73026O00F03F2O033O0017818503043O00B07AE8EB031B3O0082793B4CE58F602E70E58976310FEA85733B5AE2944A685BAED22D03053O008EE0155A2F03133O00576869726C696E67447261676F6E50756E636803233O0063DC2E44A8828B73EB2344A58C8A7AEB3743AA888D34D02250A59E8960EB7542E4D8D503073O00E514B44736C4EB030B3O0046697374736F6646757279026O001040030F3O005875656E7342612O746C65676561722O033O002477CF03073O00E0491EA18395CA031D3O00E3ECE259FFE2CE43E4EBCE5BF8E6FA10F5E0F751E4E9E56FA3F1B103A503043O003091859103093O0042752O66537461636B2O033O005745BB03063O004C3A2CD58EB1031A3O00C928132E73C431061273C227196D7CCE22133874DF1B4039389903053O0018AB44724D030B3O005468756E6465726669737403173O00496E766F6B655875656E54686557686974655469676572026O0034402O033O00E21C4803083O00CD8F7D3032E7BE6403233O00D2B3060CEAE6E0ADC798000DE4DCC8ABCFA3180AF3E79FA6C4A11510EDF7E0F0D5E74003083O00C2A1C774658183BF030A3O00432O6F6C646F776E5570031C3O00FE2DDBA1F9A5D337DDA6C8A9E527C3E8F3A7EA25DDA4E39DBE3088FE03063O00C28C44A8C8972O033O004FFACD03053O0095229BB545026O002040031A3O0005F4C6EE10C2DAFC3CFBC0E81ABDD1FF05FCC0F617C287EE43A503043O009A639DB5027O00402O033O008006E203053O008CED6F8CC0031B3O0004157C1B0D16680C3912741B0D59791D0018681412262F0C46482503043O007866791D03113O005072652O73757265506F696E7442752O662O033O0043686903073O00507265764743442O033O00A1EAB703043O005BCC83D9031B3O00CCF354D7B8D2EBDAC05EDDB0D6BECAFA53D5A6D1EAF1AD4194E18D03073O009EAE9F35B4D3BD03113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O6603213O0041EDE4D379BC5CFAD2DE65B45CF8D2D67EB659BDE9D871B447F1F9E225A112AFBF03063O00D5329D8DBD1703083O004368694275727374030A3O0049734361737461626C6503063O00456E65726779026O00494003093O004973496E52616E6765026O00444003173O00FD2E8D9F70B1EC3590E076A1F82791AC669BAC32C4F22603063O00C49E46E4C0122O033O0047561F03053O00B92A3F712E031B3O00D6D1203A10DBC8350610DDDE2A791FD1DB202C17C0E2732D5B878F03053O007BB4BD4159030C3O00432O6F6C646F776E446F776E03083O0042752O66446F776E03103O00426F6E65647573744272657742752O66026O00F83F2O033O00CF85FE03053O00E9A2EC9084031B3O00B0C8FF19B2F94AA6FBF513BAFD1FB6C1F81BACFA4B8D96EA5AEAA003073O003FD2A49E7AD996030F3O0052757368696E674A61646557696E6403133O0052757368696E674A61646557696E6442752O66031F3O0021DEE5E440F634F4FCED4DFD0CDCFFE24DB837CEF0ED5CF427F4A4F809AB6B03063O009853AB968C29029A5O99054003213O0091F58A3DDA120685DA8021D5150DBDEE8A30DF5B0C87E38226D80F37D0F1C3678403073O0068E285E353B47B2O033O000E022D03043O0030636B43031D3O00CCAF6ED9237CE1B568DE1270D7A57690297ED8A768DC39448CB23D847F03063O001BBEC61DB04D2O033O00E242F303063O002E8F2B9D54C9031B3O00557457C1541CDD43475DCB5C1888537D50C34A1FDC682A42820B4703073O00A8371836A23F73030C3O004661656C696E6553746F6D70026O003E40031B3O0011FB258CDBC012C53394DDC307BA2485D4CF02F634BF80DA57AE7603063O00AE779A40E0B203113O0053746F726D4561727468416E644669726503083O00536572656E69747903213O00396ECC750BAE14E3157DD77A0BA225EF237DCE3B01A21CE53F72D14457B35AB07203083O00844A1EA51B65C77A03073O00486173546965722O033O0022EEF103073O00D44F879F2OC7D5031D3O006BA9A64E52D0276AB5BB7857DE1B72E0B1425AD60D75B48A154897492903073O007819C0D5273CB7031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O662O033O0015493103043O002878205F031D3O0028A22A73A11805B82C74901433A8323AAB1A3CAA2C76BB2068BF792BFD03063O007F5ACB591ACF03093O00457870656C4861726D03183O00D82DBFCE05C2D534BDC649F9D833AEDE05E9E267BB8B58A903063O009DBD55CFAB69030B3O00426C2O6F646C757374557003173O00C5A9D18A01D3B3CBA143C2A4DEB416CAB52OE71786F08E03053O0063A6C1B8D500B7032O0012323O00013O0026413O009A000100020004A23O009A00012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002100013O0004A23O002100012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500063O00122O000600076O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001002100013O0004A23O002100012O0084000100033O0012320002000A3O0012320003000B4O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01005200013O0004A23O005200012O0084000100063O00204600010001000D4O00035O00202O00030003000E4O00010003000200062O0001005200013O0004A23O005200012O008400015O00203500010001000F0020112O01000100102O002D0001000200020006920001003A000100010004A23O003A00012O008400015O0020350001000100110020112O01000100122O002D000100020002000E1C00130052000100010004A23O005200012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O000500143O00122O000600156O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001005200013O0004A23O005200012O0084000100033O001232000200163O001232000300174O0040000100034O00F300016O008400015O0020350001000100180020112O01000100042O002D0001000200020006392O01006900013O0004A23O006900012O0084000100084O009900025O00202O0002000200184O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O0001006900013O0004A23O006900012O0084000100033O001232000200193O0012320003001A4O0040000100034O00F300016O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O01009900013O0004A23O009900012O008400015O00203500010001000F0020112O01000100102O002D00010002000200069200010099000100010004A23O009900012O008400015O00203500010001001B0020112O01000100122O002D000100020002000E1C001C0099000100010004A23O009900012O008400015O00203500010001001D0020112O01000100102O002D0001000200020006392O01009900013O0004A23O009900012O0084000100013O0020A00001000100054O00025O00202O0002000200114O000300026O000400033O00122O0005001E3O00122O0006001F6O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001009900013O0004A23O009900012O0084000100033O001232000200203O001232000300214O0040000100034O00F300015O0012323O001C3O0026413O00302O0100010004A23O00302O012O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100C700013O0004A23O00C700012O0084000100063O0020A10001000100224O00035O00202O00030003000E4O00010003000200262O000100C7000100020004A23O00C700012O008400015O00203500010001000F0020112O01000100102O002D0001000200020006392O0100C700013O0004A23O00C700012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O000500233O00122O000600246O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100C700013O0004A23O00C700012O0084000100033O001232000200253O001232000300264O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100F400013O0004A23O00F400012O008400015O0020350001000100270020112O01000100102O002D0001000200020006392O0100F400013O0004A23O00F400012O008400015O0020350001000100280020112O01000100122O002D000100020002000E31012900DC000100010004A23O00DC00012O0084000100093O00261B000100F4000100090004A23O00F400012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O0005002A3O00122O0006002B6O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100F400013O0004A23O00F400012O0084000100033O0012320002002C3O0012320003002D4O0040000100034O00F300016O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O0100112O013O0004A23O00112O012O008400015O00203500010001001B0020112O010001002E2O002D0001000200020006392O0100112O013O0004A23O00112O012O0084000100084O009900025O00202O0002000200114O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O000100112O013O0004A23O00112O012O0084000100033O0012320002002F3O001232000300304O0040000100034O00F300016O008400015O00203500010001001B0020112O01000100042O002D0001000200020006392O01002F2O013O0004A23O002F2O012O0084000100013O0020A00001000100054O00025O00202O00020002001B4O000300026O000400033O00122O000500313O00122O000600326O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900336O0007000900024O000700076O00010007000200062O0001002F2O013O0004A23O002F2O012O0084000100033O001232000200343O001232000300354O0040000100034O00F300015O0012323O00133O000E36013600CF2O013O0004A23O00CF2O012O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100572O013O0004A23O00572O012O0084000100063O0020A10001000100224O00035O00202O00030003000E4O00010003000200262O000100572O0100360004A23O00572O012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O000500373O00122O000600386O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100572O013O0004A23O00572O012O0084000100033O001232000200393O0012320003003A4O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100892O013O0004A23O00892O012O0084000100063O00204600010001000D4O00035O00202O00030003003B4O00010003000200062O000100892O013O0004A23O00892O012O0084000100063O0020112O010001003C2O002D000100020002000E1C003600892O0100010004A23O00892O012O0084000100063O00201B2O010001003D00122O000300136O00045O00202O0004000400114O00010004000200062O000100892O013O0004A23O00892O012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O0005003E3O00122O0006003F6O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100892O013O0004A23O00892O012O0084000100033O001232000200403O001232000300414O0040000100034O00F300016O008400015O0020350001000100420020112O01000100042O002D0001000200020006392O0100AD2O013O0004A23O00AD2O012O00840001000A4O008400025O0020350002000200422O002D0001000200020006392O0100AD2O013O0004A23O00AD2O012O0084000100063O00204600010001000D4O00035O00202O0003000300434O00010003000200062O000100AD2O013O0004A23O00AD2O012O0084000100084O009900025O00202O0002000200424O000300046O000500053O00202O00050005000800122O000700336O0005000700024O000500056O00010005000200062O000100AD2O013O0004A23O00AD2O012O0084000100033O001232000200443O001232000300454O0040000100034O00F300016O008400015O0020350001000100460020112O01000100472O002D0001000200020006392O0100CE2O013O0004A23O00CE2O012O0084000100063O0020112O010001003C2O002D00010002000200261B000100CE2O0100090004A23O00CE2O012O0084000100063O0020112O01000100482O002D00010002000200261B000100CE2O0100490004A23O00CE2O012O00840001000B4O001D00025O00202O0002000200464O000300053O00202O00030003004A00122O0005004B6O0003000500024O000300036O000400016O00010004000200062O000100CE2O013O0004A23O00CE2O012O0084000100033O0012320002004C3O0012320003004D4O0040000100034O00F300015O0012323O00023O0026413O00780201001C0004A23O007802012O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100F62O013O0004A23O00F62O012O0084000100063O0020A10001000100224O00035O00202O00030003000E4O00010003000200262O000100F62O0100020004A23O00F62O012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O0005004E3O00122O0006004F6O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100F62O013O0004A23O00F62O012O0084000100033O001232000200503O001232000300514O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01003102013O0004A23O003102012O00840001000A4O008400025O00203500020002000C2O002D0001000200020006392O01003102013O0004A23O003102012O008400015O0020350001000100110020112O01000100522O002D0001000200020006392O01003102013O0004A23O003102012O008400015O00203500010001001B0020112O01000100522O002D0001000200020006392O01003102013O0004A23O003102012O0084000100063O0020EE0001000100534O00035O00202O0003000300544O00010003000200062O00010019020100010004A23O001902012O00840001000C4O002B00010001000200261B00010031020100550004A23O003102012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O000500563O00122O000600576O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001003102013O0004A23O003102012O0084000100033O001232000200583O001232000300594O0040000100034O00F300016O008400015O00203500010001005A0020112O01000100042O002D0001000200020006392O01004F02013O0004A23O004F02012O0084000100063O0020460001000100534O00035O00202O00030003005B4O00010003000200062O0001004F02013O0004A23O004F02012O0084000100084O009900025O00202O00020002005A4O000300046O000500053O00202O00050005000800122O000700336O0005000700024O000500056O00010005000200062O0001004F02013O0004A23O004F02012O0084000100033O0012320002005C3O0012320003005D4O0040000100034O00F300016O008400015O0020350001000100420020112O01000100042O002D0001000200020006392O01007702013O0004A23O007702012O0084000100063O00204600010001000D4O00035O00202O0003000300544O00010003000200062O0001007702013O0004A23O007702012O00840001000A4O008400025O0020350002000200422O002D0001000200020006392O01007702013O0004A23O007702012O00840001000C4O002B000100010002000E48005E0077020100010004A23O007702012O0084000100084O009900025O00202O0002000200424O000300046O000500053O00202O00050005000800122O000700336O0005000700024O000500056O00010005000200062O0001007702013O0004A23O007702012O0084000100033O0012320002005F3O001232000300604O0040000100034O00F300015O0012323O00093O0026413O000D030100090004A23O000D03012O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O01009802013O0004A23O009802012O0084000100013O0020A00001000100054O00025O00202O0002000200114O000300026O000400033O00122O000500613O00122O000600626O0004000600024O0005000D6O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001009802013O0004A23O009802012O0084000100033O001232000200633O001232000300644O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100BC02013O0004A23O00BC02012O00840001000A4O008400025O00203500020002000C2O002D0001000200020006392O0100BC02013O0004A23O00BC02012O0084000100013O0020A00001000100054O00025O00202O00020002000C4O000300026O000400033O00122O000500653O00122O000600666O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100BC02013O0004A23O00BC02012O0084000100033O001232000200673O001232000300684O0040000100034O00F300016O008400015O0020350001000100690020112O01000100472O002D0001000200020006392O0100D902013O0004A23O00D902012O00840001000A4O008400025O0020350002000200692O002D0001000200020006392O0100D902013O0004A23O00D902012O0084000100084O009900025O00202O0002000200694O000300046O000500053O00202O00050005004A00122O0007006A6O0005000700024O000500056O00010005000200062O000100D902013O0004A23O00D902012O0084000100033O0012320002006B3O0012320003006C4O0040000100034O00F300016O008400015O0020350001000100420020112O01000100042O002D0001000200020006392O0100B603013O0004A23O00B603012O00840001000A4O008400025O0020350002000200422O002D0001000200020006392O0100B603013O0004A23O00B603012O0084000100063O0020112O010001003C2O002D000100020002000E1C000900F0020100010004A23O00F002012O008400015O00203500010001006D0020112O01000100102O002D000100020002000692000100FB020100010004A23O00FB02012O0084000100063O0020112O010001003C2O002D000100020002000E1C001C00B6030100010004A23O00B603012O008400015O00203500010001006E0020112O01000100102O002D0001000200020006392O0100B603013O0004A23O00B603012O0084000100084O009900025O00202O0002000200424O000300046O000500053O00202O00050005000800122O000700336O0005000700024O000500056O00010005000200062O000100B603013O0004A23O00B603012O0084000100033O00123B0002006F3O00122O000300706O000100036O00015O00044O00B603010026413O0001000100130004A23O000100012O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O01003403013O0004A23O003403012O0084000100063O00202E2O010001007100122O0003006A3O00122O000400366O00010004000200062O0001003403013O0004A23O003403012O0084000100013O0020A00001000100054O00025O00202O0002000200114O000300026O000400033O00122O000500723O00122O000600736O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001003403013O0004A23O003403012O0084000100033O001232000200743O001232000300754O0040000100034O00F300016O008400015O0020350001000100110020112O01000100042O002D0001000200020006392O01006003013O0004A23O006003012O0084000100063O0020EE00010001000D4O00035O00202O0003000300764O00010003000200062O00010048030100010004A23O004803012O0084000100063O00204600010001000D4O00035O00202O00030003003B4O00010003000200062O0001006003013O0004A23O006003012O0084000100013O0020A00001000100054O00025O00202O0002000200114O000300026O000400033O00122O000500773O00122O000600786O0004000600024O000500076O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001006003013O0004A23O006003012O0084000100033O001232000200793O0012320003007A4O0040000100034O00F300016O008400015O00203500010001007B0020112O01000100042O002D0001000200020006392O01009303013O0004A23O009303012O0084000100063O0020112O010001003C2O002D00010002000200264100010077030100130004A23O007703012O008400015O0020350001000100110020112O010001002E2O002D00010002000200069200010082030100010004A23O008203012O008400015O0020350001000100030020112O010001002E2O002D00010002000200069200010082030100010004A23O008203012O0084000100063O0020112O010001003C2O002D00010002000200264100010093030100360004A23O009303012O008400015O00203500010001001B0020112O010001002E2O002D0001000200020006392O01009303013O0004A23O009303012O0084000100084O009900025O00202O00020002007B4O000300046O000500053O00202O00050005000800122O000700336O0005000700024O000500056O00010005000200062O0001009303013O0004A23O009303012O0084000100033O0012320002007C3O0012320003007D4O0040000100034O00F300016O008400015O0020350001000100460020112O01000100472O002D0001000200020006392O0100B403013O0004A23O00B403012O0084000100063O0020112O010001007E2O002D0001000200020006392O0100B403013O0004A23O00B403012O0084000100063O0020112O010001003C2O002D00010002000200261B000100B4030100090004A23O00B403012O00840001000B4O001D00025O00202O0002000200464O000300053O00202O00030003004A00122O0005004B6O0003000500024O000300036O000400016O00010004000200062O000100B403013O0004A23O00B403012O0084000100033O0012320002007F3O001232000300804O0040000100034O00F300015O0012323O00363O0004A23O000100012O00233O00017O005C3O00028O00026O00F03F030C3O00426C61636B6F75744B69636B03073O004973526561647903063O0042752O66557003113O005072652O73757265506F696E7442752O662O033O00436869027O004003073O0050726576474344030D3O00526973696E6753756E4B69636B030E3O004973496E4D656C2O6552616E6765026O001440031B3O00D4BB81B80785C3A3BFB00589DDF784BE0A8BC3BB94841F9E96E6D003063O00EAB6D7E0DB6C03133O00537472696B656F6674686557696E646C6F7264030B3O005468756E64657266697374030B3O004973417661696C61626C6503083O00536572656E69747903173O00496E766F6B655875656E54686557686974655469676572030F3O00432O6F6C646F776E52656D61696E73026O003440030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66025O0080414003243O00D395A93CCB2O843AC6BEAF3DC5BEAC3CCE85B73AD285FB31C587BA20CC958426D4C1EA6703043O0055A0E1DB031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O66025O00804B40031D3O004E0C90C038DB744F108DF63DD548574587CC30DD5E5011BCDA229C1A0803073O002B3C65E3A956BC03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O000840031B3O0072C4D0BC51C3AC234FC3D8BC518CBD3276C9C4B34EF3AA2330998703083O005710A8B1DF3AACD9030B3O0046697374736F6646757279026O002040031B3O0032C44AC9280BC25FE23D21DF409D3F31CB58C83720F24AC97B659403053O005B54AD39BD031D3O0002B01FF5AED12FAA19F29FDD19BA07BCA4D316B819F0B4E903AD4CAEF003063O00B670D96C9CC003093O00457870656C4861726D030A3O00432O6F6C646F776E557003183O00AF1058EA87950049FD86EA0C4DE98ABF045CD098BE481ABD03053O00EBCA68288F03083O004368694275727374030A3O0049734361737461626C65030B3O00426C2O6F646C757374557003093O004973496E52616E6765026O00444003173O000E8312860F9E09AA19CB1FBC0B8A0EB519B408AD4DD94F03043O00D96DEB7B031B3O0025857F557BDFD8A9188277557B90C9B821886B5A64EFDEA967DD2C03083O00DD47E91E3610B0AD031C3O0026F54DB63AFB61AC21F261B43DFF55FF30F958BE21F04A8027E81EED03043O00DF549C3E03083O0042752O66446F776E031A3O00D0F5F1C9A404D9FADDDBA229CFBCE6D8B13AC3F0F6E2A42F96A803063O005BB69C82BDD7030C3O004661656C696E6553746F6D7003113O004661654578706F73757265446562752O66026O003E40031A3O007872A959777DA96A6D67A3586E33A8507872B9596A4CBF413E2503043O00351E13CC031C3O00EBE9638DA9FEDF6391A9C6EB7987ACB9E47582A62OEC64BBB4EDA02803053O00C7998010E4031B3O00D326E41AACDE3FF126ACD829EE59A3D42CE40CABC515F60DE7837C03053O00C7B14A857903063O00456E65726779026O00494003173O00BBC1B5C135D338ABDDFCFA32C02BADC5A8C124D26AEA9103073O004AD8A9DC9E57A603243O00FB37012551ED2O1C2A65FC2B16134DE12D172055FA2753285FEE2206204ED730076C09B803053O003A8843734C03113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O6603213O00E2BAD1578B29A55ACEA9CA588B259456F8A9D3198125AD5CE4A6CC669634EB0EA303083O003D91CAB839E540CB026O001040031B3O002O5E8844575D9C536359804457128D425A539C4B486D9A531C01DD03043O00273C32E903103O00426F6E65647573744272657742752O66029A5O99054003213O000923AA228C21BCA42530B12D8C2D8DA81330A86C862DB4A20F3FB713913CF2F04C03083O00C37A53C34CE248D203133O00576869726C696E67447261676F6E50756E636803233O00F3DC32EC2DEDDA3CC125F6D53CF12FDBC42EF022EC943FFB27E5C137EA1EF7C07BAD7903053O004184B45B9E030F3O0052757368696E674A61646557696E6403133O0052757368696E674A61646557696E6442752O66031F3O001769C2260C72D6110F7DD52B3A6BD820013CD52B037DC4221143C23A45288103043O004E651CB100FA022O0012323O00013O0026413O00B2000100020004A23O00B200012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002E00013O0004A23O002E00012O0084000100013O0020460001000100054O00035O00202O0003000300064O00010003000200062O0001002E00013O0004A23O002E00012O0084000100013O0020112O01000100072O002D000100020002000E1C0008002E000100010004A23O002E00012O0084000100013O00201B2O010001000900122O000300026O00045O00202O00040004000A4O00010004000200062O0001002E00013O0004A23O002E00012O0084000100024O009900025O00202O0002000200034O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001002E00013O0004A23O002E00012O0084000100043O0012320002000D3O0012320003000E4O0040000100034O00F300016O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O01006700013O0004A23O006700012O008400015O0020350001000100100020112O01000100112O002D0001000200020006392O01004600013O0004A23O004600012O008400015O0020350001000100120020112O01000100112O002D0001000200020006392O01004600013O0004A23O004600012O008400015O0020350001000100130020112O01000100142O002D000100020002000E3101150056000100010004A23O005600012O0084000100053O00267E000100560001000C0004A23O005600012O008400015O0020350001000100100020112O01000100112O002D0001000200020006392O01006700013O0004A23O006700012O0084000100033O0020352O01000100164O00035O00202O0003000300174O000100030002000E2O00180067000100010004A23O006700012O0084000100024O009900025O00202O00020002000F4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001006700013O0004A23O006700012O0084000100043O001232000200193O0012320003001A4O0040000100034O00F300016O008400015O00203500010001000A0020112O01000100042O002D0001000200020006392O01009300013O0004A23O009300012O0084000100013O0020EE0001000100054O00035O00202O00030003001B4O00010003000200062O00010082000100010004A23O008200012O0084000100013O0020EE0001000100054O00035O00202O0003000300064O00010003000200062O00010082000100010004A23O008200012O0084000100033O0020352O01000100164O00035O00202O0003000300174O000100030002000E2O001C0093000100010004A23O009300012O0084000100024O009900025O00202O00020002000A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001009300013O0004A23O009300012O0084000100043O0012320002001D3O0012320003001E4O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100B100013O0004A23O00B100012O0084000100013O0020A100010001001F4O00035O00202O0003000300204O00010003000200262O000100B1000100210004A23O00B100012O0084000100024O009900025O00202O0002000200034O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100B100013O0004A23O00B100012O0084000100043O001232000200223O001232000300234O0040000100034O00F300015O0012323O00083O0026413O00372O0100080004A23O00372O012O008400015O0020350001000100240020112O01000100042O002D0001000200020006392O0100CB00013O0004A23O00CB00012O0084000100024O009900025O00202O0002000200244O000300046O000500033O00202O00050005000B00122O000700256O0005000700024O000500056O00010005000200062O000100CB00013O0004A23O00CB00012O0084000100043O001232000200263O001232000300274O0040000100034O00F300016O008400015O00203500010001000A0020112O01000100042O002D0001000200020006392O0100E200013O0004A23O00E200012O0084000100024O009900025O00202O00020002000A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100E200013O0004A23O00E200012O0084000100043O001232000200283O001232000300294O0040000100034O00F300016O008400015O00203500010001002A0020112O01000100042O002D0001000200020006392O0100152O013O0004A23O00152O012O0084000100013O0020112O01000100072O002D000100020002002641000100F9000100020004A23O00F900012O008400015O00203500010001000A0020112O010001002B2O002D000100020002000692000100042O0100010004A23O00042O012O008400015O00203500010001000F0020112O010001002B2O002D000100020002000692000100042O0100010004A23O00042O012O0084000100013O0020112O01000100072O002D000100020002002641000100152O0100080004A23O00152O012O008400015O0020350001000100240020112O010001002B2O002D0001000200020006392O0100152O013O0004A23O00152O012O0084000100024O009900025O00202O00020002002A4O000300046O000500033O00202O00050005000B00122O000700256O0005000700024O000500056O00010005000200062O000100152O013O0004A23O00152O012O0084000100043O0012320002002C3O0012320003002D4O0040000100034O00F300016O008400015O00203500010001002E0020112O010001002F2O002D0001000200020006392O0100362O013O0004A23O00362O012O0084000100013O0020112O01000100302O002D0001000200020006392O0100362O013O0004A23O00362O012O0084000100013O0020112O01000100072O002D00010002000200261B000100362O01000C0004A23O00362O012O0084000100064O001D00025O00202O00020002002E4O000300033O00202O00030003003100122O000500326O0003000500024O000300036O000400016O00010004000200062O000100362O013O0004A23O00362O012O0084000100043O001232000200333O001232000300344O0040000100034O00F300015O0012323O00213O0026413O00572O01000C0004A23O00572O012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O0100F902013O0004A23O00F902012O0084000100074O008400025O0020350002000200032O002D0001000200020006392O0100F902013O0004A23O00F902012O0084000100024O009900025O00202O0002000200034O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100F902013O0004A23O00F902012O0084000100043O00123B000200353O00122O000300366O000100036O00015O00044O00F902010026413O00E62O0100010004A23O00E62O012O008400015O00203500010001000A0020112O01000100042O002D0001000200020006392O0100762O013O0004A23O00762O012O008400015O0020350001000100240020112O010001002B2O002D0001000200020006392O0100762O013O0004A23O00762O012O0084000100024O009900025O00202O00020002000A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100762O013O0004A23O00762O012O0084000100043O001232000200373O001232000300384O0040000100034O00F300016O008400015O0020350001000100240020112O01000100042O002D0001000200020006392O01009B2O013O0004A23O009B2O012O0084000100013O0020460001000100394O00035O00202O0003000300064O00010003000200062O0001009B2O013O0004A23O009B2O012O0084000100033O00204B0001000100164O00035O00202O0003000300174O00010003000200262O0001009B2O01001C0004A23O009B2O012O0084000100024O009900025O00202O0002000200244O000300046O000500033O00202O00050005000B00122O000700256O0005000700024O000500056O00010005000200062O0001009B2O013O0004A23O009B2O012O0084000100043O0012320002003A3O0012320003003B4O0040000100034O00F300016O008400015O00203500010001003C0020112O010001002F2O002D0001000200020006392O0100C02O013O0004A23O00C02O012O0084000100033O00204B0001000100164O00035O00202O0003000300174O00010003000200262O000100C02O0100020004A23O00C02O012O0084000100033O00204B0001000100164O00035O00202O00030003003D4O00010003000200262O000100C02O0100210004A23O00C02O012O0084000100024O009900025O00202O00020002003C4O000300046O000500033O00202O00050005003100122O0007003E6O0005000700024O000500056O00010005000200062O000100C02O013O0004A23O00C02O012O0084000100043O0012320002003F3O001232000300404O0040000100034O00F300016O008400015O00203500010001000A0020112O01000100042O002D0001000200020006392O0100E52O013O0004A23O00E52O012O0084000100013O0020EE0001000100054O00035O00202O0003000300064O00010003000200062O000100D42O0100010004A23O00D42O012O0084000100033O0020352O01000100164O00035O00202O0003000300174O000100030002000E2O001C00E52O0100010004A23O00E52O012O0084000100024O009900025O00202O00020002000A4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100E52O013O0004A23O00E52O012O0084000100043O001232000200413O001232000300424O0040000100034O00F300015O0012323O00023O000E360121007402013O0004A23O007402012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01000D02013O0004A23O000D02012O0084000100013O0020A100010001001F4O00035O00202O0003000300204O00010003000200262O0001000D020100080004A23O000D02012O0084000100033O0020352O01000100164O00035O00202O0003000300174O000100030002000E2O0002000D020100010004A23O000D02012O0084000100024O009900025O00202O0002000200034O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001000D02013O0004A23O000D02012O0084000100043O001232000200433O001232000300444O0040000100034O00F300016O008400015O00203500010001002E0020112O010001002F2O002D0001000200020006392O01002E02013O0004A23O002E02012O0084000100013O0020112O01000100072O002D00010002000200261B0001002E0201000C0004A23O002E02012O0084000100013O0020112O01000100452O002D00010002000200261B0001002E020100460004A23O002E02012O0084000100064O001D00025O00202O00020002002E4O000300033O00202O00030003003100122O000500326O0003000500024O000300036O000400016O00010004000200062O0001002E02013O0004A23O002E02012O0084000100043O001232000200473O001232000300484O0040000100034O00F300016O008400015O00203500010001000F0020112O01000100042O002D0001000200020006392O01004F02013O0004A23O004F02012O0084000100033O00203E2O01000100164O00035O00202O0003000300174O000100030002000E2O003E003E020100010004A23O003E02012O0084000100053O00261B0001004F0201000C0004A23O004F02012O0084000100024O009900025O00202O00020002000F4O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001004F02013O0004A23O004F02012O0084000100043O001232000200493O0012320003004A4O0040000100034O00F300016O008400015O00203500010001004B0020112O01000100042O002D0001000200020006392O01007302013O0004A23O007302012O0084000100074O008400025O00203500020002004B2O002D0001000200020006392O01007302013O0004A23O007302012O0084000100013O0020460001000100054O00035O00202O00030003004C4O00010003000200062O0001007302013O0004A23O007302012O0084000100024O009900025O00202O00020002004B4O000300046O000500033O00202O00050005000B00122O000700256O0005000700024O000500056O00010005000200062O0001007302013O0004A23O007302012O0084000100043O0012320002004D3O0012320003004E4O0040000100034O00F300015O0012323O004F3O0026413O00010001004F0004A23O000100012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01009A02013O0004A23O009A02012O0084000100013O0020460001000100054O00035O00202O0003000300204O00010003000200062O0001009A02013O0004A23O009A02012O008400015O00203500010001000A0020112O01000100142O002D000100020002000E1C0002009A020100010004A23O009A02012O0084000100024O009900025O00202O0002000200034O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O0001009A02013O0004A23O009A02012O0084000100043O001232000200503O001232000300514O0040000100034O00F300016O008400015O00203500010001004B0020112O01000100042O002D0001000200020006392O0100C202013O0004A23O00C202012O0084000100013O0020460001000100054O00035O00202O0003000300524O00010003000200062O000100C202013O0004A23O00C202012O0084000100074O008400025O00203500020002004B2O002D0001000200020006392O0100C202013O0004A23O00C202012O0084000100084O002B000100010002000E48005300C2020100010004A23O00C202012O0084000100024O009900025O00202O00020002004B4O000300046O000500033O00202O00050005000B00122O000700256O0005000700024O000500056O00010005000200062O000100C202013O0004A23O00C202012O0084000100043O001232000200543O001232000300554O0040000100034O00F300016O008400015O0020350001000100560020112O01000100042O002D0001000200020006392O0100D902013O0004A23O00D902012O0084000100024O009900025O00202O0002000200564O000300046O000500033O00202O00050005000B00122O0007000C6O0005000700024O000500056O00010005000200062O000100D902013O0004A23O00D902012O0084000100043O001232000200573O001232000300584O0040000100034O00F300016O008400015O0020350001000100590020112O01000100042O002D0001000200020006392O0100F702013O0004A23O00F702012O0084000100013O0020460001000100394O00035O00202O00030003005A4O00010003000200062O000100F702013O0004A23O00F702012O0084000100024O009900025O00202O0002000200594O000300046O000500033O00202O00050005000B00122O000700256O0005000700024O000500056O00010005000200062O000100F702013O0004A23O00F702012O0084000100043O0012320002005B3O0012320003005C4O0040000100034O00F300015O0012323O000C3O0004A23O000100012O00233O00017O00453O00028O0003163O00437261636B6C696E674A6164654C696768746E696E6703073O004973526561647903093O0042752O66537461636B03183O00546865456D7065726F7273436170616369746F7242752O66026O003340030B3O004578656375746554696D65026O00F03F030D3O00526973696E6753756E4B69636B030F3O00432O6F6C646F776E52656D61696E73026O002C4003083O00536572656E697479026O001440030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503233O0026A6E1522EB8E95F228BEA5021B1DF5D2CB3E8452BBDEE5665B2E15D29A0E84330F4B203043O003145D480030C3O004661656C696E6553746F6D70030A3O0049734361737461626C6503093O004973496E52616E6765026O003E4003183O00110DD5FEE81909EFE1F51801C0B2E71600DCE6E9051990A603053O0081776CB09203093O00546967657250616C6D030A3O004368694465666963697403063O0042752O66557003103O00506F776572537472696B657342752O66027O0040030C3O004361737454617267657449662O033O0031C60903073O007C5CAF67AD456E030E3O004973496E4D656C2O6552616E676503153O00D5310432D3071336CD354331C0340F23C92A16779703043O0057A1586303093O00457870656C4861726D026O00204003153O0017E1FFC9BBEF2B13EBE28CB1D12F1EEDE7DEA2907B03073O004372998FACD7B003083O004368694275727374026O00444003153O00BDAAE731BCB7FC1DAAE2E80FB2AEFA06ACB7AE5FEE03043O006EDEC28E03073O004368695761766503143O0014D1129645A001DC5BAF53AD1BCD13BB47E1468B03063O00C177B97BC93203163O007210E923034617761AF4660978137B1CF1341A394E2303073O007F176899466F19030C3O00426C61636B6F75744B69636B2O033O00040EA803083O00D36967C6CF4B4CD703193O00CCABB1EC7503AFA2F1ACB9EC754CBCB7C2ABA4E76C19FAE79803083O00D6AEC7D08F1E6CDA03113O005370692O6E696E674372616E654B69636B030D3O00436869456E6572677942752O6603083O0042752O66446F776E03153O0053746F726D4561727468416E644669726542752O66030B3O0046697374736F6646757279026O0008402O033O00436869026O001040026O002440026O001C40031F3O00029402A4AB5FD64E2E87192OAB53E742188700EAA357D445058C19BFE5078003083O002971E46BCAC536B8030D3O00417263616E65546F2O72656E74031A3O007B9F3B5D74880748759F2A597499785A7B813448729F2D1C28DD03043O003C1AED5803163O00CC2373E3BCE73A75EAA3982C75EAA2CC2266F3EE8A7E03053O00CEB84A148600DF012O0012323O00013O000E362O0100B900013O0004A23O00B900012O008400015O0020350001000100020020112O01000100032O002D0001000200020006392O01004B00013O0004A23O004B00012O0084000100013O0020352O01000100044O00035O00202O0003000300054O000100030002000E2O00060023000100010004A23O002300012O0084000100024O009E0001000100024O00025O00202O00020002000200202O0002000200074O00020002000200202O00020002000800062O00020023000100010004A23O002300012O008400015O0020B100010001000900202O00010001000A4O0001000200024O00025O00202O00020002000200202O0002000200074O00020002000200062O00020039000100010004A23O003900012O0084000100013O0020352O01000100044O00035O00202O0003000300054O000100030002000E2O000B004B000100010004A23O004B00012O008400015O00203500010001000C0020112O010001000A2O002D00010002000200261B000100360001000D0004A23O003600012O008400015O00203500010001000C0020112O010001000E2O002D00010002000200069200010039000100010004A23O003900012O0084000100033O00261B0001004B0001000D0004A23O004B00012O0084000100044O008100025O00202O0002000200024O000300046O000500053O00202O00050005000F4O00075O00202O0007000700024O0005000700024O000500056O0001000500020006392O01004B00013O0004A23O004B00012O0084000100063O001232000200103O001232000300114O0040000100034O00F300016O008400015O0020350001000100120020112O01000100132O002D0001000200020006392O01006800013O0004A23O006800012O0084000100074O008400025O0020350002000200122O002D0001000200020006392O01006800013O0004A23O006800012O0084000100044O009900025O00202O0002000200124O000300046O000500053O00202O00050005001400122O000700156O0005000700024O000500056O00010005000200062O0001006800013O0004A23O006800012O0084000100063O001232000200163O001232000300174O0040000100034O00F300016O008400015O0020350001000100180020112O01000100032O002D0001000200020006392O01009900013O0004A23O009900012O0084000100074O008400025O0020350002000200182O002D0001000200020006392O01009900013O0004A23O009900012O0084000100013O0020AD0001000100194O0001000200024O000200086O000300013O00202O00030003001A4O00055O00202O00050005001B4O000300056O00023O000200102O0002001C000200062O00020099000100010004A23O009900012O0084000100093O0020A000010001001D4O00025O00202O0002000200184O0003000A6O000400063O00122O0005001E3O00122O0006001F6O0004000600024O0005000B6O000600066O000700053O00202O00070007002000122O0009000D6O0007000900024O000700076O00010007000200062O0001009900013O0004A23O009900012O0084000100063O001232000200213O001232000300224O0040000100034O00F300016O008400015O0020350001000100230020112O01000100032O002D0001000200020006392O0100B800013O0004A23O00B800012O0084000100013O0020112O01000100192O002D000100020002000E48000800B8000100010004A23O00B800012O00840001000C3O000E1C001C00B8000100010004A23O00B800012O0084000100044O009900025O00202O0002000200234O000300046O000500053O00202O00050005002000122O000700246O0005000700024O000500056O00010005000200062O000100B800013O0004A23O00B800012O0084000100063O001232000200253O001232000300264O0040000100034O00F300015O0012323O00083O0026413O003D2O0100080004A23O003D2O012O008400015O0020350001000100270020112O01000100132O002D0001000200020006392O0100E200013O0004A23O00E200012O0084000100013O0020112O01000100192O002D000100020002000E48000800C9000100010004A23O00C900012O00840001000C3O0026212O0100D1000100080004A23O00D100012O0084000100013O0020112O01000100192O002D000100020002000E48001C00E2000100010004A23O00E200012O00840001000C3O000E48001C00E2000100010004A23O00E200012O00840001000D4O001D00025O00202O0002000200274O000300053O00202O00030003001400122O000500286O0003000500024O000300036O000400016O00010004000200062O000100E200013O0004A23O00E200012O0084000100063O001232000200293O0012320003002A4O0040000100034O00F300016O008400015O00203500010001002B0020112O01000100132O002D0001000200020006392O0100F900013O0004A23O00F900012O0084000100044O009900025O00202O00020002002B4O000300046O000500053O00202O00050005001400122O000700286O0005000700024O000500056O00010005000200062O000100F900013O0004A23O00F900012O0084000100063O0012320002002C3O0012320003002D4O0040000100034O00F300016O008400015O0020350001000100230020112O01000100032O002D0001000200020006392O0100152O013O0004A23O00152O012O0084000100013O0020112O01000100192O002D000100020002000E48000800152O0100010004A23O00152O012O0084000100044O009900025O00202O0002000200234O000300046O000500053O00202O00050005002000122O000700246O0005000700024O000500056O00010005000200062O000100152O013O0004A23O00152O012O0084000100063O0012320002002E3O0012320003002F4O0040000100034O00F300016O008400015O0020350001000100300020112O01000100032O002D0001000200020006392O01003C2O013O0004A23O003C2O012O0084000100074O008400025O0020350002000200302O002D0001000200020006392O01003C2O013O0004A23O003C2O012O00840001000C3O000E48000D003C2O0100010004A23O003C2O012O0084000100093O0020A000010001001D4O00025O00202O0002000200304O0003000A6O000400063O00122O000500313O00122O000600326O0004000600024O0005000E6O000600066O000700053O00202O00070007002000122O0009000D6O0007000900024O000700076O00010007000200062O0001003C2O013O0004A23O003C2O012O0084000100063O001232000200333O001232000300344O0040000100034O00F300015O0012323O001C3O0026413O00010001001C0004A23O000100012O008400015O0020350001000100350020112O01000100032O002D0001000200020006392O0100AE2O013O0004A23O00AE2O012O0084000100074O008400025O0020350002000200352O002D0001000200020006392O0100932O013O0004A23O00932O012O0084000100013O0020D30001000100044O00035O00202O0003000300364O0001000300024O0002000C3O00102O0002000D000200102O00020015000200062O000200932O0100010004A23O00932O012O0084000100013O0020460001000100374O00035O00202O0003000300384O00010003000200062O000100932O013O0004A23O00932O012O008400015O0020350001000100090020112O010001000A2O002D000100020002000E1C001C00682O0100010004A23O00682O012O008400015O0020350001000100390020112O010001000A2O002D000100020002000E31011C009D2O0100010004A23O009D2O012O008400015O0020350001000100090020112O010001000A2O002D00010002000200261B000100792O01003A0004A23O00792O012O008400015O0020350001000100390020112O010001000A2O002D000100020002000E1C003A00792O0100010004A23O00792O012O0084000100013O0020112O010001003B2O002D000100020002000E31013A009D2O0100010004A23O009D2O012O008400015O0020350001000100090020112O010001000A2O002D000100020002000E1C003A008A2O0100010004A23O008A2O012O008400015O0020350001000100390020112O010001000A2O002D00010002000200261B0001008A2O01003A0004A23O008A2O012O0084000100013O0020112O010001003B2O002D000100020002000E31013C009D2O0100010004A23O009D2O012O0084000100013O0020112O01000100192O002D000100020002002602000100932O0100080004A23O00932O012O0084000100024O002B00010001000200267E0001009D2O01001C0004A23O009D2O012O0084000100013O0020352O01000100044O00035O00202O0003000300364O000100030002000E2O003D00AE2O0100010004A23O00AE2O012O0084000100033O00261B000100AE2O01003E0004A23O00AE2O012O0084000100044O009900025O00202O0002000200354O000300046O000500053O00202O00050005002000122O000700246O0005000700024O000500056O00010005000200062O000100AE2O013O0004A23O00AE2O012O0084000100063O0012320002003F3O001232000300404O0040000100034O00F300016O008400015O0020350001000100410020112O01000100132O002D0001000200020006392O0100C52O013O0004A23O00C52O012O0084000100013O0020112O01000100192O002D000100020002000E48000800C52O0100010004A23O00C52O012O0084000100044O002301025O00202O0002000200414O000300036O00010003000200062O000100C52O013O0004A23O00C52O012O0084000100063O001232000200423O001232000300434O0040000100034O00F300016O008400015O0020350001000100180020112O01000100032O002D0001000200020006392O0100DE2O013O0004A23O00DE2O012O0084000100044O009900025O00202O0002000200184O000300046O000500053O00202O00050005002000122O0007000D6O0005000700024O000500056O00010005000200062O000100DE2O013O0004A23O00DE2O012O0084000100063O00123B000200443O00122O000300456O000100036O00015O00044O00DE2O010004A23O000100012O00233O00017O00793O00028O00026O001C40030D3O00526973696E6753756E4B69636B03073O0049735265616479030C3O004361737454617267657449662O033O0035EDE003083O00AC58848ED1932A58030E3O004973496E4D656C2O6552616E6765026O001440031B3O009583DF0438F281949FC2323DFCBD8CCADF0824F0B08E9ED54D62A503073O00DEE7EAAC6D569503113O005370692O6E696E674372616E654B69636B03063O0042752O66557003103O0044616E63656F664368696A6942752O66026O002040031F3O00FEFFC916E3E6CE1FD2ECD219E3EAFF13E4ECCB58FEEAD21DE3E6D401ADBB9203043O00788D8FA0030C3O00426C61636B6F75744B69636B03193O0042A0B7514B2OA3467FA7BF514BECA55752A9B85B54B5F6061403043O003220CCD6026O001840026O00F03F031F3O0095573C77BD1888400A7AA11088420A72BA128D07267CA114884E2160F342D203063O0071E6275519D303133O00576869726C696E67447261676F6E50756E636803213O00C9B30FFA2BC2A54CE1BF14E920C4A574CEAE08EB2F8BB84ECCBE08E133D2EB188803083O002BBEDB668847ABCB030F3O0052757368696E674A61646557696E6403083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66026O000840031D3O00306B23512B703766287F345C1D693957263E235C307B3E503667700A7A03043O0039421E5003213O003ED0A9078830FA8316DCB2148336FABB39CDAE168C79E7813BDDAE1C9020B4D07F03083O00E449B8C075E4599403093O00546967657250616C6D03173O005465616368696E67736F667468654D6F6E617374657279030B3O004973417661696C61626C6503093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O6603163O00DB807211DDB66515C3843507CA9B701AC69D6C549BD103043O0074AFE915027O004003133O00537472696B656F6674686557696E646C6F7264030B3O005468756E64657266697374026O00224003213O00EDECAC4FD03400F1FE8152D33400E9F1B042D73E2DFAB8AD43C93431F7ECA7068903073O005F9E98DE26BB51031F3O00EBAD3CBCADC1F6BA0A2OB1C9F6B80AB9AACBF3FD26B7B1CDF6B421ABE399AC03063O00A898DD55D2C3026O00104003113O005072652O73757265506F696E7442752O662O033O00A6D7FB03043O00E7CBBE95031B3O00DF34F0F8B2F224DE28EDCEB7FC18C67DF0F4AEF015C429FAB1EDA303073O007BAD5D8391DC95030B3O0042752O6652656D61696E732O033O001BCDE303063O009976A48D411403183O00EC3E87E1FC0FFB26B9E9FE03E57295E7E505E03B92FBB75603063O00608E52E68297030B3O0046697374736F664675727903133O00496E766F6B65727344656C6967687442752O66030C3O004A61646549676E6974696F6E030B3O00426C2O6F646C757374557003193O0049B95C56F7D140B67044F1FC56F05C47F6EB41B92O5BA4BF1F03063O008E2FD02F228403043O004755494403213O00F0B717164863F9B83B042O4EEFFE0B0C5E63F1BD00424859E4BB0A0B4F45B6EF5003063O003C96DE64623B03073O0047657454696D65030E3O004C61737454617267657453776170025O00408F40026O005940032C3O0043354442C8853E43035143C9A3714A325269DCB9350533515096AE30573B52429BA9345739595FCFA371146803073O0051255C3736BBDA03073O0048617354696572026O003E402O033O000D4DA303053O00E16024CD5703173O00EBAA437A77401CFD9949707F4449FAA3507C72461DF0E603073O006989C622191C2F031F3O0002B94878CE18A74649C303A84F73FF1AA0427D8002AC5373CE18BD5836924103053O00A071C921162O033O00D951A203063O00CDB438CCC7C903193O0081D23D1B88D1290CBCD5351B889E2F1D91DB321197C77C49DB03043O0078E3BE5C031D3O002F490C732A52DEDD375D1B7E1C4BD0EC391C0C7E3159D7EB29455F297103083O00825D3C7F1B433CB903123O00536861646F77626F78696E675472656164732O033O00453B3603073O001D2852582E802303193O003949D51E0AB72E51EB1608BB3005C71813BD354CC00441EA6F03063O00D85B25B47D6102005O660240031F3O00366615CD592C781BFC54377712C6682E7F1FC81736730EC6592C620583057303053O003745167CA303223O006BC74EE1D4746FFB7EEC48E0DA4E47FD76D750E7CD7510E77DC159E6D66549B42A8B03083O009418B33C88BF1130030F3O00432O6F6C646F776E52656D61696E732O033O00BF23F703053O0096D24A99C0031B3O00F1C12B837B7D8BF0DD36B57E73B7E8882B8F677FBAEADC21CA262A03073O00D483A858EA151A2O033O00487D8703063O00472514E9EC5803193O00CF4AB1154BE35948F24DB9154BAC5F59DF43BE1F54F50C0F9F03083O003CAD26D076208C2C030C3O00536572656E69747942752O6603183O00473BF2C733F04E34DED535DD5872F2D632CA4F3BF5CA609D03063O00AF215281B3402O033O00E3E63E03063O00D28E8F50AF5C03183O00BBE5F2C5B22OE6D286E2FAC5B2A9E0C3ABECFDCFADF0B39203043O00A6D98993030C3O00426F6E6564757374427265772O033O00EEAA7C03063O002683C312C691031A3O0041DF29E236536CC52FE5075F5AD531AB2B5141D334E22C4D138E03063O003433B65A8B580033042O0012323O00013O0026413O0063000100020004A23O006300012O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01002100013O0004A23O002100012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500063O00122O000600076O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001002100013O0004A23O002100012O0084000100033O0012320002000A3O0012320003000B4O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01004500013O0004A23O004500012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O01004500013O0004A23O004500012O0084000100073O00204600010001000D4O00035O00202O00030003000E4O00010003000200062O0001004500013O0004A23O004500012O0084000100084O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O0001004500013O0004A23O004500012O0084000100033O001232000200103O001232000300114O0040000100034O00F300016O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O01006200013O0004A23O006200012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O01006200013O0004A23O006200012O0084000100084O009900025O00202O0002000200124O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O0001006200013O0004A23O006200012O0084000100033O001232000200133O001232000300144O0040000100034O00F300015O0012323O000F3O0026413O00C1000100150004A23O00C100012O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01008500013O0004A23O008500012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O01008500013O0004A23O008500012O0084000100093O000E1C00160085000100010004A23O008500012O0084000100084O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O0001008500013O0004A23O008500012O0084000100033O001232000200173O001232000300184O0040000100034O00F300016O008400015O0020350001000100190020112O01000100042O002D0001000200020006392O01009F00013O0004A23O009F00012O0084000100093O000E1C0016009F000100010004A23O009F00012O0084000100084O009900025O00202O0002000200194O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O0001009F00013O0004A23O009F00012O0084000100033O0012320002001A3O0012320003001B4O0040000100034O00F300016O008400015O00203500010001001C0020112O01000100042O002D0001000200020006392O0100C000013O0004A23O00C000012O0084000100073O00204600010001001D4O00035O00202O00030003001E4O00010003000200062O000100C000013O0004A23O00C000012O0084000100093O000E48001F00C0000100010004A23O00C000012O0084000100084O009900025O00202O00020002001C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O000100C000013O0004A23O00C000012O0084000100033O001232000200203O001232000300214O0040000100034O00F300015O0012323O00023O0026413O00FF0001000F0004A23O00FF00012O008400015O0020350001000100190020112O01000100042O002D0001000200020006392O0100DA00013O0004A23O00DA00012O0084000100084O009900025O00202O0002000200194O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O000100DA00013O0004A23O00DA00012O0084000100033O001232000200223O001232000300234O0040000100034O00F300016O008400015O0020350001000100240020112O01000100042O002D0001000200020006392O01003204013O0004A23O003204012O008400015O0020350001000100250020112O01000100262O002D0001000200020006392O01003204013O0004A23O003204012O0084000100073O00204B0001000100274O00035O00202O0003000300284O00010003000200262O000100320401001F0004A23O003204012O0084000100084O009900025O00202O0002000200244O000300046O000500053O00202O00050005000800122O000700096O0005000700024O000500056O00010005000200062O0001003204013O0004A23O003204012O0084000100033O00123B000200293O00122O0003002A6O000100036O00015O00044O003204010026413O006E2O01002B0004A23O006E2O012O008400015O00203500010001002C0020112O01000100042O002D0001000200020006392O01001E2O013O0004A23O001E2O012O008400015O00203500010001002D0020112O01000100262O002D0001000200020006392O01001E2O013O0004A23O001E2O012O0084000100084O009900025O00202O00020002002C4O000300046O000500053O00202O00050005000800122O0007002E6O0005000700024O000500056O00010005000200062O0001001E2O013O0004A23O001E2O012O0084000100033O0012320002002F3O001232000300304O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O0100452O013O0004A23O00452O012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O0100452O013O0004A23O00452O012O0084000100073O00204600010001000D4O00035O00202O00030003000E4O00010003000200062O000100452O013O0004A23O00452O012O0084000100093O000E48002B00452O0100010004A23O00452O012O0084000100084O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O000100452O013O0004A23O00452O012O0084000100033O001232000200313O001232000300324O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01006D2O013O0004A23O006D2O012O0084000100093O0026410001006D2O0100330004A23O006D2O012O0084000100073O00204600010001000D4O00035O00202O0003000300344O00010003000200062O0001006D2O013O0004A23O006D2O012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500353O00122O000600366O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001006D2O013O0004A23O006D2O012O0084000100033O001232000200373O001232000300384O0040000100034O00F300015O0012323O001F3O0026413O001A020100160004A23O001A02012O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O0100A22O013O0004A23O00A22O012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O0100A22O013O0004A23O00A22O012O0084000100073O0020A10001000100274O00035O00202O0003000300284O00010003000200262O000100A22O01001F0004A23O00A22O012O0084000100073O00204B0001000100394O00035O00202O0003000300284O00010003000200262O000100A22O0100160004A23O00A22O012O0084000100013O0020A00001000100054O00025O00202O0002000200124O000300026O000400033O00122O0005003A3O00122O0006003B6O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100A22O013O0004A23O00A22O012O0084000100033O0012320002003C3O0012320003003D4O0040000100034O00F300016O008400015O00203500010001003E0020112O01000100042O002D0001000200020006392O0100D42O013O0004A23O00D42O012O0084000100073O00204600010001000D4O00035O00202O00030003003F4O00010003000200062O000100BB2O013O0004A23O00BB2O012O0084000100093O00261B000100B82O01001F0004A23O00B82O012O008400015O0020350001000100400020112O01000100262O002D000100020002000692000100C32O0100010004A23O00C32O012O0084000100093O000E31013300C32O0100010004A23O00C32O012O0084000100073O0020112O01000100412O002D000100020002000692000100C32O0100010004A23O00C32O012O0084000100093O002641000100D42O01002B0004A23O00D42O012O0084000100084O009900025O00202O00020002003E4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O000100D42O013O0004A23O00D42O012O0084000100033O001232000200423O001232000300434O0040000100034O00F300016O008400015O00203500010001003E0020112O01000100042O002D0001000200020006392O01001902013O0004A23O00190201001232000100014O00B8000200023O002641000100DC2O0100010004A23O00DC2O012O00840003000A4O002B0003000100022O00A8000200033O0006390102001902013O0004A23O001902010020110103000200442O00560003000200024O000400053O00202O0004000400444O00040002000200062O000300F62O0100040004A23O00F62O012O00840003000B4O008400045O00203500040004003E2O002D0003000200020006390103001902013O0004A23O001902012O0084000300033O00123B000400453O00122O000500466O000300056O00035O00044O001902012O00840003000C3O0006390103001902013O0004A23O001902010012E0000300474O00540003000100024O000400013O00202O0004000400484O00030003000400202O0003000300494O0004000D3O00062O00040019020100030004A23O00190201001232000300013O00264100030003020100010004A23O000302012O0084000400013O0012D6000500476O00050001000200102O0004004800054O0004000B6O0005000E3O00122O0006004A6O000500066O00043O000200062O0004001902013O0004A23O001902012O0084000400033O00123B0005004B3O00122O0006004C6O000400066O00045O00044O001902010004A23O000302010004A23O001902010004A23O00DC2O010012323O002B3O0026413O00A00201001F0004A23O00A002012O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O01004A02013O0004A23O004A02012O0084000100093O0026410001004A0201001F0004A23O004A02012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O01004A02013O0004A23O004A02012O0084000100073O00202E2O010001004D00122O0003004E3O00122O0004002B6O00010004000200062O0001004A02013O0004A23O004A02012O0084000100013O0020A00001000100054O00025O00202O0002000200124O000300026O000400033O00122O0005004F3O00122O000600506O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001004A02013O0004A23O004A02012O0084000100033O001232000200513O001232000300524O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01006E02013O0004A23O006E02012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O01006E02013O0004A23O006E02012O0084000100093O000E48001F006E020100010004A23O006E02012O00840001000F4O002B0001000100020006392O01006E02013O0004A23O006E02012O0084000100084O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O0001006E02013O0004A23O006E02012O0084000100033O001232000200533O001232000300544O0040000100034O00F300016O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O01009F02013O0004A23O009F02012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O01009F02013O0004A23O009F02012O0084000100093O000E1C0016009F020100010004A23O009F02012O0084000100093O00261B0001009F020100330004A23O009F02012O0084000100073O0020A10001000100274O00035O00202O0003000300284O00010003000200262O0001009F0201002B0004A23O009F02012O0084000100013O0020A00001000100054O00025O00202O0002000200124O000300026O000400033O00122O000500553O00122O000600566O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001009F02013O0004A23O009F02012O0084000100033O001232000200573O001232000300584O0040000100034O00F300015O0012323O00333O0026413O0018030100330004A23O001803012O008400015O00203500010001001C0020112O01000100042O002D0001000200020006392O0100C302013O0004A23O00C302012O0084000100073O00204600010001001D4O00035O00202O00030003001E4O00010003000200062O000100C302013O0004A23O00C302012O0084000100093O000E48000900C3020100010004A23O00C302012O0084000100084O009900025O00202O00020002001C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O000100C302013O0004A23O00C302012O0084000100033O001232000200593O0012320003005A4O0040000100034O00F300016O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O0100F002013O0004A23O00F002012O008400015O00203500010001005B0020112O01000100262O002D0001000200020006392O0100F002013O0004A23O00F002012O0084000100093O000E48001F00F0020100010004A23O00F002012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O0100F002013O0004A23O00F002012O0084000100013O0020A00001000100054O00025O00202O0002000200124O000300026O000400033O00122O0005005C3O00122O0006005D6O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100F002013O0004A23O00F002012O0084000100033O0012320002005E3O0012320003005F4O0040000100034O00F300016O008400015O00203500010001000C0020112O01000100042O002D0001000200020006392O01001703013O0004A23O001703012O0084000100064O008400025O00203500020002000C2O002D0001000200020006392O01001703013O0004A23O001703012O0084000100093O000E31011F0006030100010004A23O000603012O0084000100093O000E1C002B0017030100010004A23O001703012O0084000100104O002B000100010002000E4800600017030100010004A23O001703012O0084000100084O009900025O00202O00020002000C4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O0001001703013O0004A23O001703012O0084000100033O001232000200613O001232000300624O0040000100034O00F300015O0012323O00093O0026413O0096030100090004A23O009603012O008400015O00203500010001002C0020112O01000100042O002D0001000200020006392O01003403013O0004A23O003403012O0084000100093O000E48001F0034030100010004A23O003403012O0084000100084O009900025O00202O00020002002C4O000300046O000500053O00202O00050005000800122O0007002E6O0005000700024O000500056O00010005000200062O0001003403013O0004A23O003403012O0084000100033O001232000200633O001232000300644O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01005B03013O0004A23O005B03012O0084000100093O0026410001005B0301002B0004A23O005B03012O008400015O00203500010001003E0020112O01000100652O002D000100020002000E1C0009005B030100010004A23O005B03012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500663O00122O000600676O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001005B03013O0004A23O005B03012O0084000100033O001232000200683O001232000300694O0040000100034O00F300016O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O01009503013O0004A23O009503012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O01009503013O0004A23O009503012O0084000100093O002641000100950301002B0004A23O009503012O008400015O00203500010001003E0020112O01000100652O002D000100020002000E1C00090095030100010004A23O009503012O008400015O00203500010001005B0020112O01000100262O002D0001000200020006392O01009503013O0004A23O009503012O0084000100073O0020A10001000100274O00035O00202O0003000300284O00010003000200262O00010095030100160004A23O009503012O0084000100013O0020A00001000100054O00025O00202O0002000200124O000300026O000400033O00122O0005006A3O00122O0006006B6O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001009503013O0004A23O009503012O0084000100033O0012320002006C3O0012320003006D4O0040000100034O00F300015O0012323O00153O0026413O0001000100010004A23O000100012O008400015O00203500010001003E0020112O01000100042O002D0001000200020006392O0100B603013O0004A23O00B603012O0084000100073O00204B0001000100394O00035O00202O00030003006E4O00010003000200262O000100B6030100160004A23O00B603012O0084000100084O009900025O00202O00020002003E4O000300046O000500053O00202O00050005000800122O0007000F6O0005000700024O000500056O00010005000200062O000100B603013O0004A23O00B603012O0084000100033O0012320002006F3O001232000300704O0040000100034O00F300016O008400015O0020350001000100120020112O01000100042O002D0001000200020006392O0100E703013O0004A23O00E703012O0084000100064O008400025O0020350002000200122O002D0001000200020006392O0100E703013O0004A23O00E703012O00840001000F4O002B000100010002000692000100E7030100010004A23O00E703012O0084000100093O000E1C003300E7030100010004A23O00E703012O008400015O00203500010001005B0020112O01000100262O002D0001000200020006392O0100E703013O0004A23O00E703012O0084000100013O0020A00001000100054O00025O00202O0002000200124O000300026O000400033O00122O000500713O00122O000600726O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O000100E703013O0004A23O00E703012O0084000100033O001232000200733O001232000300744O0040000100034O00F300016O008400015O0020350001000100030020112O01000100042O002D0001000200020006392O01003004013O0004A23O003004012O0084000100093O002641000100FD030100330004A23O00FD03012O0084000100073O00204600010001000D4O00035O00202O0003000300344O00010003000200062O000100FD03013O0004A23O00FD03012O008400015O0020350001000100750020112O01000100262O002D0001000200020006392O01001804013O0004A23O001804012O0084000100093O0026212O010018040100160004A23O001804012O0084000100093O0026020001000A0401001F0004A23O000A04012O0084000100073O0020EE00010001000D4O00035O00202O0003000300344O00010003000200062O00010018040100010004A23O001804012O0084000100073O00204600010001000D4O00035O00202O0003000300344O00010003000200062O0001003004013O0004A23O003004012O0084000100073O00202E2O010001004D00122O0003004E3O00122O0004002B6O00010004000200062O0001003004013O0004A23O003004012O0084000100013O0020A00001000100054O00025O00202O0002000200034O000300026O000400033O00122O000500763O00122O000600776O0004000600024O000500046O000600066O000700053O00202O00070007000800122O000900096O0007000900024O000700076O00010007000200062O0001003004013O0004A23O003004012O0084000100033O001232000200783O001232000300794O0040000100034O00F300015O0012323O00163O0004A23O000100012O00233O00017O00403O00028O00026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E677303123O00DFB7C4E251E4ACC0F377FEABD5F44BF9B5D403053O002396D9B08703103O00CC430E2472427AF05E0C3C78577FF65E03073O001699306B6C172303113O002680BA16767B46D90191B215715B40E40B03083O00896EE5DB7A1F1521034O00027O0040030A3O002FAE3D5F3C4A366B0FB303083O001E7ADD581B562B4403113O001126FF832A3AFE962C1FE292301BFF933603043O00E658488B03163O005BBA021E111A4D62A039150F116F7ABD021E0F014B6603073O003812D4767B6368026O001C40030F3O002BFAFDF7D6D818FCEBD6F2DF19E0FB03063O00BE7E8998B3BF030E3O000C0B74CDBF532D2F73CCA343003203063O0020486212ABCA03113O0026873C71F3119B2656E5019F0767F6038D03053O009764E85214026O002040026O000840030D3O005BD0E5187AD5D20D7DCCF00E6C03043O00681FB996030B3O00F8B0E0E7E2C0C2D5DABFE003083O00A0BCD9939787AC80030F3O0027DC1EF436CC2EDB16FC33CA1BD81403063O00A96FBD70905A026O001040031B3O00FE9628A0B08E3E8AC4972099B6870C90FE9724B9AA853C91CC842003083O00E2ADE345CDDFE069030A3O005B272157CA3F5D32234203063O007B385E423BAF026O001840030B3O00DF5B63E416D680E84E5BD103073O00E19A2313817A9E030D3O006F13EE73F4EAC0315428EA45F803083O00543A608B379587B0030C3O00373EAE104BC116122DAE287E03073O005E735FC3602EAF03113O006B4A31392228AEEE40442O2D213F82E14F03083O0080232B5F5D4E4DE7030F3O00910E3300186BAAAC32301F166CA4A503073O00C9C47D5654771E030F3O00F6FD018BCCFB07B7ECE820BAC2FA0C03043O00DFA38E64026O001440030F3O00AA13C2BDB18C11F3BEAC8B19CD998803053O00D8E276A3D1030E3O008BE31E29527133AAF80815587E3A03073O005FDE907B613710030D3O003181BB4FF71197AE4CED1CAC8A03053O008379E4DA2303113O00ECC32O277609CDD924187015DEF230046E03063O007BB9B042611903103O00EE000B451C294138C6083B431038700103083O0051A86F7931754F38030C3O00F219E093DF1AE0BAEF0BF7BB03043O00D6A76A85000C012O0012323O00013O0026413O001F000100020004A23O001F00010012E0000100033O0020C00001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O0020550001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200062O0001001D000100010004A23O001D00010012320001000B4O00AF000100033O0012323O000C3O0026413O003A000100010004A23O003A00010012E0000100033O0020072O01000100044O000200013O00122O0003000D3O00122O0004000E6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00124O00023O0026413O005B000100130004A23O005B00010012E0000100033O0020550001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O00010001000200062O0001004E000100010004A23O004E0001001232000100014O00AF000100083O00127C000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O00010001000200062O00010059000100010004A23O005900010012320001000B4O00AF000100093O0012323O001A3O000E36011B007600013O0004A23O007600010012E0000100033O0020072O01000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000C3O00124O00223O0026413O008F0001001A0004A23O008F00010012E0000100033O00206A0001000100044O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O00010082000100010004A23O008200010012320001000B4O00AF0001000D3O00127C000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O0001008D000100010004A23O008D00010012320001000B4O00AF0001000E3O0004A23O000B2O01000E36012700B000013O0004A23O00B000010012E0000100033O00206A0001000100044O000200013O00122O000300283O00122O000400296O0002000400024O00010001000200062O0001009B000100010004A23O009B0001001232000100014O00AF0001000F3O0012E0000100033O0020550001000100044O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200062O000100AE000100010004A23O00AE0001001232000100014O00AF000100113O0012323O00133O000E36012200CB00013O0004A23O00CB00010012E0000100033O0020072O01000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100143O00124O00343O0026413O00EC0001000C0004A23O00EC00010012E0000100033O00206A0001000100044O000200013O00122O000300353O00122O000400366O0002000400024O00010001000200062O000100D7000100010004A23O00D70001001232000100014O00AF000100153O0012E0000100033O0020550001000100044O000200013O00122O000300373O00122O000400386O0002000400024O0001000100024O000100163O00122O000100033O00202O0001000100044O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100EA000100010004A23O00EA0001001232000100014O00AF000100173O0012323O001B3O0026413O0001000100340004A23O000100010012E0000100033O0020550001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100183O00122O000100033O00202O0001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200062O00012O002O0100010004A24O002O01001232000100014O00AF000100193O0012BA000100033O00202O0001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O0001000100024O0001001A3O00124O00273O00044O000100012O00233O00017O00613O00028O00026O001040030F3O00412O66656374696E67436F6D62617403053O004465746F7803073O0049735265616479030C3O0053686F756C6452657475726E03093O00466F637573556E6974030D3O00546172676574497356616C696403093O00497343617374696E67030C3O0049734368612O6E656C696E67026O00F03F03113O00496E74652O72757074576974685374756E03083O004C656753772O6570026O002040027O004003093O00496E74652O72757074030F3O00537065617248616E64537472696B65026O00444003183O00537065617248616E64537472696B654D6F7573656F76657203173O0044697370652O6C61626C65467269656E646C79556E6974030A3O004465746F78466F637573030A3O002D3D58402C3FD428314203073O00B949582C2F541F030F3O0048616E646C65412O666C6963746564030E3O004465746F784D6F7573656F76657203113O0048616E646C65496E636F72706F7265616C03093O00506172616C7973697303123O00506172616C797369734D6F7573656F766572026O00344003173O00496E766F6B655875656E54686557686974655469676572030B3O004973417661696C61626C65026O005E40030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66030D3O00526973696E6753756E4B69636B030F3O00432O6F6C646F776E52656D61696E73030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003103O00426F6E65647573744272657742752O6603083O00536572656E697479030C3O004661656C696E6553746F6D70026O001840026O001440025O00804540026O000840030A3O00436F6D62617454696D652O033O00436869030C3O00536572656E69747942752O66030B3O00426C2O6F646C7573745570030A3O0049734361737461626C65030E3O004661656C696E654861726D6F6E79030C3O004361737454617267657449662O033O0085DE1403063O009FE8B77AC0B303093O004973496E52616E6765026O003E4003143O002233AD2O2D3CAD1E3726A72C3472A5202D3CE87903043O00414452C803093O00546967657250616C6D03083O0042752O66446F776E03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66030A3O004368694465666963697403103O00506F776572537472696B657342752O6603083O00536B79726561636803083O00536B79746F7563682O033O0028597C03073O001E453012402OAF030E3O004973496E4D656C2O6552616E676503123O00E42518E929CF3C1EE036B0211EE535B07D4F03053O005B904C7F8C03083O004368694275727374030C3O00432O6F6C646F776E446F776E03113O00E3004F1ED1AFC7C3F4484B20DAB49581B403083O00B080682641B3DAB5030A3O00502O6F6C456E65726779030B3O00E0CBCD1990E1CC10C2C3DB03043O0075B0A4A2030C3O004570696353652O74696E677303073O00546F2O676C657303053O0087DB06FCDF03063O0019E4A26590BA2O033O004B32AA03063O00842856D96E9203063O007AC234ACA27F03083O003E1EAB47DCC7139C030D3O004973446561644F7247686F7374024O0080B3C540030C3O00466967687452656D61696E7303103O00426F2O73466967687452656D61696E7303113O0054696D6553696E63654C61737443617374026O00384003163O00476574456E656D696573496E4D656C2O6552616E67652O033O004F4AAF03083O002D2025CC563DA94F2O033O00545A0003063O001C2O3565DCD5008E032O0012323O00013O0026413O0009030100020004A23O000903012O008400015O0020112O01000100032O002D0001000200020006392O01002400013O0004A23O002400012O0084000100013O0006392O01002400013O0004A23O002400012O0084000100023O0020350001000100040020112O01000100052O002D0001000200020006392O01002400013O0004A23O002400012O0084000100033O0006392O01002400013O0004A23O00240001001232000100013O00264100010015000100010004A23O001500012O0084000200043O00202D0102000200074O000300016O000400066O00020006000200122O000200063O00122O000200063O00062O0002002400013O0004A23O002400010012E0000200064O008E000200023O0004A23O002400010004A23O001500012O0084000100043O0020350001000100082O002B0001000100020006392O01008D03013O0004A23O008D0301001232000100013O002641000100F9020100010004A23O00F902012O008400025O0020110102000200032O002D00020002000200069200020040000100010004A23O004000012O0084000200053O0006390102004000013O0004A23O00400001001232000200014O00B8000300033O00264100020036000100010004A23O003600012O0084000400064O002B0004000100022O00A8000300043O0006390103004000013O0004A23O004000012O008E000300023O0004A23O004000010004A23O003600012O008400025O0020110102000200032O002D00020002000200069200020048000100010004A23O004800012O0084000200053O000639010200F802013O0004A23O00F80201001232000200014O00B8000300043O002641000200CD000100010004A23O00CD00012O008400055O0020110105000500092O002D00050002000200069200050085000100010004A23O008500012O008400055O00201101050005000A2O002D00050002000200069200050085000100010004A23O00850001001232000500014O00B8000600063O002641000500650001000B0004A23O006500012O0084000700043O002O2001070007000C4O000800023O00202O00080008000D00122O0009000E6O0007000900024O000600073O00062O0006006400013O0004A23O006400012O008E000600023O0012320005000F3O000E36010F0076000100050004A23O007600012O0084000700043O0020FD0007000700104O000800023O00202O00080008001100122O000900126O000A00016O000B00076O000C00083O00202O000C000C00134O0007000C00024O000600073O0006390106008500013O0004A23O008500012O008E000600023O0004A23O0085000100264100050058000100010004A23O005800012O0084000700043O0020BE0007000700104O000800023O00202O00080008001100122O0009000E6O000A00016O0007000A00024O000600073O00062O0006008300013O0004A23O008300012O008E000600023O0012320005000B3O0004A23O005800012O0084000500093O000639010500A400013O0004A23O00A400012O0084000500013O000639010500A400013O0004A23O00A400012O0084000500033O000639010500A400013O0004A23O00A400012O0084000500023O0020350005000500040020110105000500052O002D000500020002000639010500A400013O0004A23O00A400012O0084000500043O0020350005000500142O002B000500010002000639010500A400013O0004A23O00A400012O00840005000A4O0084000600083O0020350006000600152O002D000500020002000639010500A400013O0004A23O00A400012O00840005000B3O001232000600163O001232000700174O0040000500074O00F300056O00840005000C3O000639010500B800013O0004A23O00B80001001232000500013O002641000500A8000100010004A23O00A800012O0084000600043O0020BF0006000600184O000700023O00202O0007000700044O000800083O00202O00080008001900122O000900126O0006000900024O000400063O00062O000400B800013O0004A23O00B800012O008E000400023O0004A23O00B800010004A23O00A800012O00840005000D3O000639010500CC00013O0004A23O00CC0001001232000500013O002641000500BC000100010004A23O00BC00012O0084000600043O0020BF00060006001A4O000700023O00202O00070007001B4O000800083O00202O00080008001C00122O0009001D6O0006000900024O000400063O00062O000400CC00013O0004A23O00CC00012O008E000400023O0004A23O00CC00010004A23O00BC00010012320002000B3O002641000200092O01000B0004A23O00092O012O0084000500023O00203500050005001E00201101050005001F2O002D000500020002000639010500D900013O0004A23O00D900012O00840005000F3O00267E000500D9000100200004A23O00D900012O007800056O0004010500014O00250105000E6O000500113O00202O0005000500214O000700023O00202O0007000700224O00050007000200262O000500E80001000B0004A23O00E800012O0084000500023O0020350005000500230020110105000500242O002D00050002000200267E000500E90001000B0004A23O00E900012O007800056O0004010500014O0096000500106O000500043O00202O0005000500254O00065O00202O0006000600264O000800023O00202O0008000800274O00060008000200062O000600032O0100010004A23O00032O012O008400065O0020EE0006000600264O000800023O00202O0008000800284O00060008000200062O000600032O0100010004A23O00032O012O008400065O0020EE0006000600264O000800023O00202O0008000800294O00060008000200062O000600032O0100010004A23O00032O012O0084000600124O002D0005000200022O00A8000300053O000639010300082O013O0004A23O00082O012O008E000300023O0012320002000F3O000E36012A00122O0100020004A23O00122O012O0084000500134O002B0005000100022O00A8000400053O000639010400F802013O0004A23O00F802012O008E000400023O0004A23O00F80201002641000200512O01002B0004A23O00512O012O0084000500143O002641000500232O01002C0004A23O00232O01001232000500014O00B8000600063O002641000500192O0100010004A23O00192O012O0084000700154O002B0007000100022O00A8000600073O000639010600232O013O0004A23O00232O012O008E000600023O0004A23O00232O010004A23O00192O012O0084000500143O002641000500322O01002D0004A23O00322O01001232000500014O00B8000600063O002641000500282O0100010004A23O00282O012O0084000700164O002B0007000100022O00A8000600073O000639010600322O013O0004A23O00322O012O008E000600023O0004A23O00322O010004A23O00282O012O0084000500143O002641000500412O01000F0004A23O00412O01001232000500014O00B8000600063O000E362O0100372O0100050004A23O00372O012O0084000700174O002B0007000100022O00A8000600073O000639010600412O013O0004A23O00412O012O008E000600023O0004A23O00412O010004A23O00372O012O0084000500143O002641000500502O01000B0004A23O00502O01001232000500014O00B8000600063O002641000500462O0100010004A23O00462O012O0084000700184O002B0007000100022O00A8000600073O000639010600502O013O0004A23O00502O012O008E000600023O0004A23O00502O010004A23O00462O010012320002002A3O002641000200822O01000F0004A23O00822O012O0084000500193O00203500050005002E2O002B00050001000200261B000500782O0100020004A23O00782O012O008400055O00201101050005002F2O002D00050002000200261B000500782O01002B0004A23O00782O012O0084000500023O00203500050005002800201101050005001F2O002D000500020002000692000500782O0100010004A23O00782O012O0084000500123O0006390105006C2O013O0004A23O006C2O012O0084000500023O00203500050005001E00201101050005001F2O002D000500020002000692000500782O0100010004A23O00782O01001232000500014O00B8000600063O000E362O01006E2O0100050004A23O006E2O012O00840007001A4O002B0007000100022O00A8000600073O000639010600782O013O0004A23O00782O012O008E000600023O0004A23O00782O010004A23O006E2O012O00840005001B4O002B0005000100022O00A8000400053O0006390104007E2O013O0004A23O007E2O012O008E000400024O00840005001C4O002B0005000100022O00A8000400053O0012320002002D3O000E360102002C020100020004A23O002C02012O00840005001D3O000639010500992O013O0004A23O00992O012O0084000500023O00203500050005002800201101050005001F2O002D000500020002000692000500992O0100010004A23O00992O01001232000500014O00B8000600063O000E362O01008F2O0100050004A23O008F2O012O00840007001E4O002B0007000100022O00A8000600073O000639010600992O013O0004A23O00992O012O008E000600023O0004A23O00992O010004A23O008F2O012O00840005001D3O000639010500AE2O013O0004A23O00AE2O012O0084000500023O00203500050005002800201101050005001F2O002D000500020002000639010500AE2O013O0004A23O00AE2O01001232000500014O00B8000600063O000E362O0100A42O0100050004A23O00A42O012O00840007001F4O002B0007000100022O00A8000600073O000639010600AE2O013O0004A23O00AE2O012O008E000600023O0004A23O00AE2O010004A23O00A42O012O008400055O0020460005000500264O000700023O00202O0007000700304O00050007000200062O0005001C02013O0004A23O001C0201001232000500013O002641000500D92O0100010004A23O00D92O012O008400065O0020110106000600312O002D000600020002000639010600C92O013O0004A23O00C92O01001232000600014O00B8000700073O000E362O0100BF2O0100060004A23O00BF2O012O0084000800204O002B0008000100022O00A8000700083O000639010700C92O013O0004A23O00C92O012O008E000700023O0004A23O00C92O010004A23O00BF2O012O0084000600143O000E1C000200D82O0100060004A23O00D82O01001232000600014O00B8000700073O002641000600CE2O0100010004A23O00CE2O012O0084000800214O002B0008000100022O00A8000700083O000639010700D82O013O0004A23O00D82O012O008E000700023O0004A23O00D82O010004A23O00CE2O010012320005000B3O000E36010F00FA2O0100050004A23O00FA2O012O0084000600143O002641000600EA2O01000F0004A23O00EA2O01001232000600014O00B8000700073O002641000600E02O0100010004A23O00E02O012O0084000800224O002B0008000100022O00A8000700083O000639010700EA2O013O0004A23O00EA2O012O008E000700023O0004A23O00EA2O010004A23O00E02O012O0084000600143O0026410006001C0201000B0004A23O001C0201001232000600014O00B8000700073O002641000600EF2O0100010004A23O00EF2O012O0084000800234O002B0008000100022O00A8000700083O0006390107001C02013O0004A23O001C02012O008E000700023O0004A23O001C02010004A23O00EF2O010004A23O001C0201002641000500B62O01000B0004A23O00B62O012O0084000600143O0026410006000B020100020004A23O000B0201001232000600014O00B8000700073O00264100060001020100010004A23O000102012O0084000800244O002B0008000100022O00A8000700083O0006390107000B02013O0004A23O000B02012O008E000700023O0004A23O000B02010004A23O000102012O0084000600143O0026410006001A0201002D0004A23O001A0201001232000600014O00B8000700073O00264100060010020100010004A23O001002012O0084000800254O002B0008000100022O00A8000700083O0006390107001A02013O0004A23O001A02012O008E000700023O0004A23O001A02010004A23O001002010012320005000F3O0004A23O00B62O012O0084000500143O000E1C0002002B020100050004A23O002B0201001232000500014O00B8000600063O00264100050021020100010004A23O002102012O0084000700264O002B0007000100022O00A8000600073O0006390106002B02013O0004A23O002B02012O008E000600023O0004A23O002B02010004A23O002102010012320002002B3O000E36012D004A000100020004A23O004A00010006390104003102013O0004A23O003102012O008E000400024O0084000500023O0020350005000500290020110105000500322O002D0005000200020006390105005B02013O0004A23O005B02012O0084000500274O0084000600023O0020350006000600292O002D0005000200020006390105005B02013O0004A23O005B02012O0084000500023O00203500050005003300201101050005001F2O002D0005000200020006390105005B02013O0004A23O005B02012O0084000500043O0020B00005000500344O000600023O00202O0006000600294O000700286O0008000B3O00122O000900353O00122O000A00366O0008000A00024O000900296O000A002A6O000B00113O00202O000B000B003700122O000D00386O000B000D00024O000B000B6O0005000B000200062O0005005B02013O0004A23O005B02012O00840005000B3O001232000600393O0012320007003A4O0040000500074O00F300056O0084000500023O00203500050005003B0020110105000500052O002D000500020002000639010500BD02013O0004A23O00BD02012O008400055O00204600050005003C4O000700023O00202O0007000700304O00050007000200062O000500BD02013O0004A23O00BD02012O008400055O00204B00050005003D4O000700023O00202O00070007003E4O00050007000200262O000500BD0201002D0004A23O00BD02012O0084000500274O0084000600023O00203500060006003B2O002D000500020002000639010500BD02013O0004A23O00BD02012O008400055O0020AD00050005003F4O0005000200024O0006002B6O00075O00202O0007000700264O000900023O00202O0009000900404O000700096O00063O000200102O0006000F000600062O000600BD020100050004A23O00BD02012O0084000500023O00203500050005001E00201101050005001F2O002D0005000200020006920005008E020100010004A23O008E02012O0084000500023O00203500050005002800201101050005001F2O002D000500020002000639010500A202013O0004A23O00A202012O0084000500023O00203500050005004100201101050005001F2O002D0005000200020006920005009A020100010004A23O009A02012O0084000500023O00203500050005004200201101050005001F2O002D000500020002000639010500A202013O0004A23O00A202012O0084000500193O00203500050005002E2O002B000500010002000E31012B00A2020100050004A23O00A202012O0084000500123O000639010500BD02013O0004A23O00BD02012O0084000500103O000692000500BD020100010004A23O00BD02012O0084000500043O0020A00005000500344O000600023O00202O00060006003B4O0007002C6O0008000B3O00122O000900433O00122O000A00446O0008000A00024O0009002D6O000A000A6O000B00113O00202O000B000B004500122O000D002B6O000B000D00024O000B000B6O0005000B000200062O000500BD02013O0004A23O00BD02012O00840005000B3O001232000600463O001232000700474O0040000500074O00F300056O0084000500023O0020350005000500480020110105000500322O002D000500020002000639010500F602013O0004A23O00F602012O0084000500023O00203500050005002900201101050005001F2O002D000500020002000639010500F602013O0004A23O00F602012O0084000500023O0020350005000500290020110105000500492O002D000500020002000639010500F602013O0004A23O00F602012O008400055O00201101050005003F2O002D000500020002000E48000B00D7020100050004A23O00D702012O0084000500143O002621010500DF0201000B0004A23O00DF02012O008400055O00201101050005003F2O002D000500020002000E48000F00F6020100050004A23O00F602012O0084000500143O000E48000F00F6020100050004A23O00F602012O0084000500023O00203500050005003300201101050005001F2O002D000500020002000692000500F6020100010004A23O00F602012O00840005000A4O001D000600023O00202O0006000600484O000700113O00202O00070007003700122O000900126O0007000900024O000700076O000800016O00050008000200062O000500F602013O0004A23O00F602012O00840005000B3O0012320006004A3O0012320007004B4O0040000500074O00F300055O001232000200023O0004A23O004A00010012320001000B3O000E36010B002A000100010004A23O002A00012O00840002002E4O0084000300023O00203500030003004C2O002D0002000200020006390102008D03013O0004A23O008D03012O00840002000B3O00123B0003004D3O00122O0004004E6O000200046O00025O00044O008D03010004A23O002A00010004A23O008D0301000E36010B002403013O0004A23O002403010012E00001004F3O0020072O01000100504O0002000B3O00122O000300513O00122O000400526O0002000400024O0001000100024O0001002F3O00122O0001004F3O00202O0001000100504O0002000B3O00122O000300533O00122O000400546O0002000400024O0001000100024O0001001D3O00122O0001004F3O00202O0001000100504O0002000B3O00122O000300553O00122O000400566O0002000400024O0001000100024O000100033O00124O000F3O0026413O00610301002D0004A23O006103012O008400015O0020112O01000100572O002D0001000200020006392O01002C03013O0004A23O002C03012O00233O00014O0084000100043O0020350001000100082O002B00010001000200069200010036030100010004A23O003603012O008400015O0020112O01000100032O002D0001000200020006392O01004D03013O0004A23O004D0301001232000100013O002641000100430301000B0004A23O004303012O00840002000F3O0026410002004D030100580004A23O004D03012O0084000200193O0020E10002000200594O000300286O00048O0002000400024O0002000F3O00044O004D030100264100010037030100010004A23O003703012O0084000200193O0020B600020002005A4O0002000100024O000200306O000200306O0002000F3O00122O0001000B3O00044O003703012O0084000100043O0020350001000100082O002B00010001000200069200010057030100010004A23O005703012O008400015O0020112O01000100032O002D0001000200020006392O01006003013O0004A23O006003012O0084000100023O00203500010001001E0020112O010001005B2O002D0001000200020026162O01005E0301005C0004A23O005E03012O007800016O00042O0100014O00AF000100123O0012323O00023O0026413O00770301000F0004A23O007703012O008400015O0020B900010001005D00122O0003002B6O0001000300024O0001002C6O00015O00202O00010001005D00122O0003000E6O0001000300024O000100286O000100313O0006392O01007403013O0004A23O007403012O0084000100284O0044000100014O00AF000100143O0004A23O007603010012320001000B4O00AF000100143O0012323O002D3O0026413O0001000100010004A23O000100012O0084000100324O007F00010001000100122O0001004F3O00202O0001000100504O0002000B3O00122O0003005E3O00122O0004005F6O0002000400024O0001000100024O000100053O00122O0001004F3O00202O0001000100504O0002000B3O00122O000300603O00122O000400616O0002000400024O0001000100024O000100313O00124O000B3O00044O000100012O00233O00017O00093O00028O00026O00F03F030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03223O003A5506454DA05CD4084E486C55AF5B9F1B1C591114F31E8F5D1C2A581A835FD0007703083O00BF6D3C68213AC13003053O005072696E7403263O00B0DE16E390D614EC82C558CA88D913A795D80CE693DE17E9C7D501A7A2C711E4C7F517E88AFC03043O0087E7B77800193O0012323O00013O0026413O000B000100020004A23O000B00010012E0000100033O0020EB0001000100044O00025O00122O000300053O00122O000400066O000200046O00013O000100044O001800010026413O0001000100010004A23O000100012O0084000100014O002E0001000100014O000100023O00202O0001000100074O00025O00122O000300083O00122O000400096O000200046O00013O000100124O00023O00044O000100012O00233O00017O00", GetFEnv(), ...);
