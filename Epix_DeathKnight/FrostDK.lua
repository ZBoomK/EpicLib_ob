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
											end
										elseif (Enum == 2) then
											local Edx;
											local Results, Limit;
											local B;
											local A;
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
											Results, Limit = _R(Stk[A](Stk[A + 1]));
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
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 7) then
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
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum > 9) then
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
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 11) then
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
								elseif (Enum <= 14) then
									if (Enum == 13) then
										if (Stk[Inst[2]] <= Inst[4]) then
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
								elseif (Enum <= 15) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 16) then
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
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum == 18) then
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
									elseif (Enum == 20) then
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
										local A = Inst[2];
										do
											return Unpack(Stk, A, A + Inst[3]);
										end
									end
								elseif (Enum <= 23) then
									if (Enum > 22) then
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
									else
										Stk[Inst[2]] = #Stk[Inst[3]];
									end
								elseif (Enum <= 24) then
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
								elseif (Enum > 25) then
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
									local A = Inst[2];
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum > 27) then
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
											if (Mvm[1] == 176) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 29) then
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
								elseif (Enum > 30) then
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
							elseif (Enum <= 33) then
								if (Enum > 32) then
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
							elseif (Enum <= 34) then
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
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							end
						elseif (Enum <= 55) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum > 37) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum > 39) then
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
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 42) then
									if (Enum == 41) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 43) then
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
								elseif (Enum == 44) then
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
							elseif (Enum <= 50) then
								if (Enum <= 47) then
									if (Enum == 46) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 48) then
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
								elseif (Enum > 49) then
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
							elseif (Enum <= 52) then
								if (Enum == 51) then
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
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 53) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 54) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 64) then
							if (Enum <= 59) then
								if (Enum <= 57) then
									if (Enum > 56) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									local B;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
							elseif (Enum <= 61) then
								if (Enum == 60) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 63) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 69) then
							if (Enum <= 66) then
								if (Enum > 65) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 68) then
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
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum <= 71) then
							if (Enum == 70) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 112) then
						if (Enum <= 93) then
							if (Enum <= 83) then
								if (Enum <= 78) then
									if (Enum <= 76) then
										if (Enum == 75) then
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
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										end
									elseif (Enum > 77) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 80) then
									if (Enum == 79) then
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
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									end
								elseif (Enum <= 81) then
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 82) then
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
							elseif (Enum <= 88) then
								if (Enum <= 85) then
									if (Enum > 84) then
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
								elseif (Enum <= 86) then
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
								elseif (Enum > 87) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 90) then
								if (Enum > 89) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
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
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 92) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 96) then
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
								end
							elseif (Enum <= 99) then
								if (Enum == 98) then
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
							elseif (Enum <= 100) then
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
							elseif (Enum > 101) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 107) then
							if (Enum <= 104) then
								if (Enum > 103) then
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
							elseif (Enum <= 105) then
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
							elseif (Enum > 106) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 109) then
							if (Enum > 108) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							end
						elseif (Enum <= 110) then
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
						elseif (Enum > 111) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 131) then
						if (Enum <= 121) then
							if (Enum <= 116) then
								if (Enum <= 114) then
									if (Enum == 113) then
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
								elseif (Enum == 115) then
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 118) then
								if (Enum > 117) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 119) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 120) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 126) then
							if (Enum <= 123) then
								if (Enum > 122) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 124) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum == 125) then
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
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 128) then
							if (Enum == 127) then
								if (Stk[Inst[2]] ~= Inst[4]) then
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
						elseif (Enum <= 129) then
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
						elseif (Enum > 130) then
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
							Stk[Inst[2]] = {};
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 140) then
						if (Enum <= 135) then
							if (Enum <= 133) then
								if (Enum > 132) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 137) then
							if (Enum == 136) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 138) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						elseif (Enum == 139) then
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
					elseif (Enum <= 145) then
						if (Enum <= 142) then
							if (Enum == 141) then
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
						elseif (Enum <= 143) then
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
						elseif (Enum > 144) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 147) then
						if (Enum > 146) then
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
					elseif (Enum <= 148) then
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
					elseif (Enum == 149) then
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
				elseif (Enum <= 225) then
					if (Enum <= 187) then
						if (Enum <= 168) then
							if (Enum <= 159) then
								if (Enum <= 154) then
									if (Enum <= 152) then
										if (Enum == 151) then
											Upvalues[Inst[3]] = Stk[Inst[2]];
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 156) then
									if (Enum == 155) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 158) then
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
							elseif (Enum <= 163) then
								if (Enum <= 161) then
									if (Enum == 160) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 162) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							elseif (Enum <= 165) then
								if (Enum > 164) then
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
							elseif (Enum <= 166) then
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
							elseif (Enum > 167) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 177) then
							if (Enum <= 172) then
								if (Enum <= 170) then
									if (Enum > 169) then
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
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] ~= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 171) then
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								else
									Stk[Inst[2]] = {};
								end
							elseif (Enum <= 174) then
								if (Enum == 173) then
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
							elseif (Enum <= 175) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum > 176) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
							end
						elseif (Enum <= 182) then
							if (Enum <= 179) then
								if (Enum == 178) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 181) then
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
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 185) then
							Stk[Inst[2]]();
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
							A = Inst[2];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 206) then
						if (Enum <= 196) then
							if (Enum <= 191) then
								if (Enum <= 189) then
									if (Enum > 188) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local Edx;
										local Results;
										local A;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
										Edx = 0;
										for Idx = A, Inst[4] do
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
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
										A = Inst[2];
										Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
										Edx = 0;
										for Idx = A, Inst[4] do
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 193) then
								if (Enum > 192) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							elseif (Enum <= 194) then
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
							elseif (Enum > 195) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 201) then
							if (Enum <= 198) then
								if (Enum == 197) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									A = Inst[2];
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
									local Edx;
									local Results;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 199) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 200) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 203) then
							if (Enum > 202) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 204) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 205) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 215) then
						if (Enum <= 210) then
							if (Enum <= 208) then
								if (Enum > 207) then
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
							end
						elseif (Enum <= 212) then
							if (Enum == 211) then
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 213) then
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
						elseif (Enum > 214) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local T = Stk[A];
							for Idx = A + 1, Top do
								Insert(T, Stk[Idx]);
							end
						end
					elseif (Enum <= 220) then
						if (Enum <= 217) then
							if (Enum > 216) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 218) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 219) then
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						else
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
						end
					elseif (Enum <= 223) then
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum > 224) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, Top);
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
				elseif (Enum <= 263) then
					if (Enum <= 244) then
						if (Enum <= 234) then
							if (Enum <= 229) then
								if (Enum <= 227) then
									if (Enum == 226) then
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
							elseif (Enum <= 231) then
								if (Enum > 230) then
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
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 232) then
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
							elseif (Enum > 233) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 239) then
							if (Enum <= 236) then
								if (Enum > 235) then
									Stk[Inst[2]] = #Stk[Inst[3]];
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
							elseif (Enum <= 237) then
								do
									return;
								end
							elseif (Enum > 238) then
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
						elseif (Enum <= 241) then
							if (Enum == 240) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 242) then
							VIP = Inst[3];
						elseif (Enum > 243) then
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
						elseif (Enum <= 250) then
							if (Enum == 249) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 251) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 252) then
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
						end
					elseif (Enum <= 258) then
						if (Enum <= 255) then
							if (Enum > 254) then
								do
									return Stk[Inst[2]];
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
						elseif (Enum <= 256) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 257) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Enum > 259) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 261) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 262) then
						if (Stk[Inst[2]] == Inst[4]) then
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
				elseif (Enum <= 282) then
					if (Enum <= 272) then
						if (Enum <= 267) then
							if (Enum <= 265) then
								if (Enum > 264) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 266) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
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
						elseif (Enum <= 269) then
							if (Enum == 268) then
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
							end
						elseif (Enum <= 270) then
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
						elseif (Enum == 271) then
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 277) then
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
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 275) then
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
						elseif (Enum > 276) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 279) then
						if (Enum == 278) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
					elseif (Enum <= 280) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 281) then
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 291) then
					if (Enum <= 286) then
						if (Enum <= 284) then
							if (Enum > 283) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 285) then
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
						end
					elseif (Enum <= 288) then
						if (Enum == 287) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 289) then
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
					elseif (Enum == 290) then
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
				elseif (Enum <= 296) then
					if (Enum <= 293) then
						if (Enum > 292) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 294) then
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
					elseif (Enum > 295) then
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
					elseif Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 298) then
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
				elseif (Enum <= 299) then
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
				elseif (Enum > 300) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!583O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503053O005574696C7303043O00556E697403063O00506C6179657203063O0054617267657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D2O033O0050657403053O004D6163726F03073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03043O006D6174682O033O006D696E2O033O006162732O033O006D617803043O004361737403073O0047657454696D6503083O0073747273706C697403143O00476574496E76656E746F72794974656D4C696E6B028O00030B3O0044656174684B6E6967687403053O0046726F737403113O00416C67657468617250752O7A6C65426F7803023O004944030E3O00476174686572696E6753746F726D030B3O004973417661696C61626C6503093O004576657266726F7374025O00804D40026O003940025O00804640024O0080B3C540030A3O0047686F756C5461626C6503103O005265676973746572466F724576656E7403143O009C028A72E265213B89098E65F87230288E028E6F03083O0069CC4ECB2BA7377E030E3O00969A06323F37F8728D8B0D39362003083O0031C5CA437E7364A703143O001B7EFE1BAE737A0868EF0CAC7A611E75E01DA17403073O003E573BBF49E036030A3O0041737068797869617465031B3O00C403E9DDA723E9D9EF1BE2C0E616FF89AF2BF4DDE210E8DCF716B303043O00A987629A03063O00DB7B254DF82103073O00A8AB1744349D53026O003040034O0003063O00E47DF4B4203F03073O00E7941195CD454D026O00314003013O003A03043O00D3F490AB03063O009FE0C7A79B3703043O00A4A06B8203043O00B297935C03043O00DFAE1A6A03073O001AEC9D2C52722C03043O00797D832O03043O003B4A4EB503043O0073830E0903053O00D345B12O3A03043O00E1B72DA603063O00ABD78519958903123O004973457175692O7065644974656D5479706503083O00D5DF3DB7C731F24603083O002281A8529A8F509C030C3O0047657445717569706D656E74026O002A40026O002C4003183O006C29E19607EA6320F19A0BE87120EE9B1DFB7424EE8807FC03063O00B83C65A0CF4203063O0053657441504C025O00606F4000F4012O00129F3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004F23O000A00010012FC000300063O0020820004000300070012FC000500083O0020820005000500090012FC000600083O00208200060006000A00061C00073O000100062O00B03O00064O00B08O00B03O00044O00B03O00014O00B03O00024O00B03O00054O00330008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000E001100202O0010000E001200202O0011000B00130020820012000B00140020210013000B001500202O0014000B001600202O0015000B001700202O0016000B001800202O00160016001900202O00160016001A00202O0017000B001800202O00170017001900202O00170017001B00122O0018001C3O00208200180018001D0012E70019001C3O00202O00190019001E00122O001A001C3O00202O001A001A001F4O001B8O001C8O001D5O00202O001E000B002000122O001F00083O00202O001F001F000A0012FC002000213O001232002100223O00122O002200236O002300263O00122O002700246O002800283O00122O002900246O002A002D3O00122O002E00243O00122O002F00246O003000383O0012C8003900244O000F013A003F3O00061C004000010001001C2O00B03O00234O00B03O00074O00B03O00254O00B03O00264O00B03O00374O00B03O00384O00B03O00394O00B03O003D4O00B03O003E4O00B03O003F4O00B03O00314O00B03O00324O00B03O00334O00B03O002A4O00B03O002B4O00B03O002C4O00B03O003A4O00B03O003B4O00B03O003C4O00B03O002E4O00B03O002F4O00B03O00304O00B03O00274O00B03O00284O00B03O00294O00B03O00344O00B03O00354O00B03O00363O00200200410011002500202O00410041002600202O00420013002500202O00420042002600202O00430015002500202O0043004300264O00445O00202O00450042002700202O0045004500284O004500464O00D600443O00010020820045000B00180020C50045004500194O004600483O00202O00490041002900202O00490049002A4O00490002000200062O00490076000100010004F23O0076000100208200490041002B00205000490049002A2O00D4004900020002000E24012C007B000100390004F23O007B00010012C8004A002D3O000651004A007C000100010004F23O007C00010012C8004A002E4O000F014B00593O00123B005A002F3O00122O005B002F3O00202O005C000B00304O005D00633O00202O0064000B003100061C00660002000100022O00B03O005A4O00B03O005B4O008E006700073O00122O006800323O00122O006900336O006700696O00643O00010020500064000B003100061C00660003000100022O00B03O00494O00B03O00414O0083006700073O00122O006800343O00122O006900356O0067006900024O006800073O00122O006900363O00122O006A00376O0068006A6O00643O00014O006400014O00AC006500033O00205D0066004100384O006700073O00122O006800393O00122O0069003A6O006700690002000223006800044O00190065000300012O00190064000100012O00B0006500224O0092006600073O00122O0067003B3O00122O0068003C6O00660068000200122O0067003D6O00650067000200062O006500AB000100010004F23O00AB00010012C80065003E4O00B0006600224O0092006700073O00122O0068003F3O00122O006900406O00670069000200122O006800416O00660068000200062O006600B5000100010004F23O00B500010012C80066003E4O00B0006700213O0012C6006800426O006900656O0067006900694O006A00213O00122O006B00426O006C00666O006A006C006C4O006D00073O00122O006E00433O00122O006F00444O00E6006D006F0002000628006900CA0001006D0004F23O00CA00012O00B0006D00073O0012C8006E00453O0012C8006F00464O00E6006D006F0002000628006C00CA0001006D0004F23O00CA00012O0059006D6O001F016D00014O00D3006E00073O00122O006F00473O00122O007000486O006E0070000200062O006900D80001006E0004F23O00D800012O00B0006E00073O0012C8006F00493O0012C80070004A4O00E6006E00700002000628006C00D80001006E0004F23O00D800012O0059006E6O001F016E00014O00D3006F00073O00122O0070004B3O00122O0071004C6O006F0071000200062O006900E60001006F0004F23O00E600012O00B0006F00073O0012C80070004D3O0012C80071004E4O00E6006F00710002000628006C00E60001006F0004F23O00E600012O0059006F6O001F016F00013O0012C30070004F6O007100073O00122O007200503O00122O007300516O007100736O00703O000200202O0071000F00524O00710002000200202O00720071005300062O007200F700013O0004F23O00F700012O00B0007200133O0020820073007100532O00D4007200020002000651007200FA000100010004F23O00FA00012O00B0007200133O0012C8007300244O00D4007200020002002082007300710054000627017300022O013O0004F23O00022O012O00B0007300133O0020820074007100542O00D4007300020002000651007300052O0100010004F23O00052O012O00B0007300133O0012C8007400244O00D40073000200020020500074000B003100061C00760005000100102O00B03O00724O00B03O00714O00B03O00134O00B03O00734O00B03O006B4O00B03O00694O00B03O00214O00B03O00654O00B03O006C4O00B03O00664O00B03O006D4O00B03O00074O00B03O006E4O00B03O00224O00B03O00704O00B03O000F4O008E007700073O00122O007800553O00122O007900566O007700796O00743O000100061C00740006000100042O00B03O000F4O00B03O002E4O00B03O002F4O00B03O00413O00061C00750007000100032O00B03O00414O00B03O00164O00B03O006D3O00061C00760008000100012O00B03O00413O00061C00770009000100062O00B03O00414O00B03O00104O00B03O001E4O00B03O00074O00B03O004A4O00B03O00393O00061C0078000A000100032O00B03O00454O00B03O00444O00B03O001D3O00061C0079000B0001000C2O00B03O00414O00B03O000F4O00B03O001E4O00B03O003D4O00B03O00074O00B03O001D4O00B03O00374O00B03O00594O00B03O00104O00B03O00554O00B03O003B4O00B03O00533O00061C007A000C000100112O00B03O00414O00B03O000F4O00B03O00554O00B03O001E4O00B03O00104O00B03O00074O00B03O00454O00B03O00624O00B03O00754O00B03O00434O00B03O00334O00B03O00494O00B03O00514O00B03O00524O00B03O00164O00B03O003D4O00B03O00373O00061C007B000D0001000B2O00B03O00414O00B03O000F4O00B03O001E4O00B03O003D4O00B03O00074O00B03O00374O00B03O00104O00B03O00554O00B03O00454O00B03O00624O00B03O00753O00061C007C000E000100092O00B03O00414O00B03O000F4O00B03O001E4O00B03O00104O00B03O00074O00B03O005B4O00B03O00704O00B03O00164O00B03O006E3O00061C007D000F000100152O00B03O00414O00B03O000F4O00B03O001E4O00B03O00104O00B03O00074O00B03O005F4O00B03O00514O00B03O00504O00B03O005B4O00B03O003F4O00B03O005C4O00B03O00354O00B03O003C4O00B03O00704O00B03O006D4O00B03O00344O00B03O000B4O00B03O004A4O00B03O003A4O00B03O00434O00B03O00333O00061C007E00100001000E2O00B03O00414O00B03O005F4O00B03O00534O00B03O000F4O00B03O00574O00B03O001E4O00B03O00104O00B03O00074O00B03O00494O00B03O00514O00B03O00304O00B03O001D4O00B03O00314O00B03O00323O00061C007F0011000100112O00B03O00414O00B03O005F4O00B03O001E4O00B03O00104O00B03O00074O00B03O000F4O00B03O003B4O00B03O00454O00B03O00624O00B03O00754O00B03O001D4O00B03O00374O00B03O00594O00B03O00534O00B03O00554O00B03O006D4O00B03O005E3O00061C00800012000100072O00B03O00414O00B03O000F4O00B03O001E4O00B03O00374O00B03O00104O00B03O00074O00B03O00543O00061C00810013000100122O00B03O001D4O00B03O00414O00B03O000F4O00B03O001E4O00B03O00374O00B03O00074O00B03O00594O00B03O003B4O00B03O00104O00B03O00494O00B03O00514O00B03O00704O00B03O00554O00B03O003D4O00B03O00534O00B03O00524O00B03O006D4O00B03O00583O00061C008200140001000F2O00B03O00534O00B03O00414O00B03O000F4O00B03O00544O00B03O005E4O00B03O00554O00B03O005F4O00B03O00564O00B03O00574O00B03O00584O00B03O00594O00B03O00504O00B03O001C4O00B03O00514O00B03O00523O00061C00830015000100202O00B03O00404O00B03O001B4O00B03O00074O00B03O001C4O00B03O001D4O00B03O00464O00B03O00744O00B03O005F4O00B03O00624O00B03O005E4O00B03O005D4O00B03O000F4O00B03O00454O00B03O005B4O00B03O000B4O00B03O005A4O00B03O00784O00B03O00804O00B03O00414O00B03O00104O00B03O006D4O00B03O007C4O00B03O001E4O00B03O007B4O00B03O00774O00B03O00824O00B03O007E4O00B03O007D4O00B03O007A4O00B03O007F4O00B03O00794O00B03O00813O00061C00840016000100032O00B03O00404O00B03O000B4O00B03O00073O0020E40085000B005700122O008600586O008700836O008800846O0085008800016O00013O00173O00023O00026O00F03F026O00704002264O00D000025O00122O000300016O00045O00122O000500013O00042O0003002100012O00D900076O00B2000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004200003000500012O00D9000300054O00B0000400024O00AF000300044O00E100036O00ED3O00017O00413O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030A3O00B394FFFDDA887C878BE903073O0015E6E79AAFBBEB03103O008CCFCB5039F4B5D5C07F0CFAADD5C17603063O0095D9BCAE185C03113O0064E678EF7445D4B143F770EC7365D28C4903083O00E12C8319831D2BB3026O00F03F026O001840030D3O00294E4FB4D82O2C631D496B9EFD03083O002C7B2F2CDDB9405F03113O00C3414C00E5445A23E87B6F0EE844560FE003043O006187283F03103O008F71001A2D22A14E310B2A23AD593D2F03063O0051CE3C535B4F026O001C40026O002040030F3O0066A4C27C00C57AAD40BFD56008E06903083O00C42ECBB0124FA32D03163O00903B6E1130F3EAAA2F771D14E9EAAB27701D21DCCC9C03073O008FD8421E7E449B03103O009AC101C7C4B1F8E78CDA02D8D184F4C503083O0081CAA86DABA5C3B7026O00104003113O00035623D1F315E12B5B04D0DB18EA057B1303073O0086423857B8BE7403103O001D3F1DB234EA263C3F0B06B51CCC021103083O00555C5169DB798B4103103O00D9B62O5174FEF3B774407FDEE494736103063O00BF9DD330251C026O001440027O004003113O00F611E01928CD0AE4080DD60BFC2F2ECA1103053O005ABF7F947C03163O0051893A126A953B076CA8201B61B0261E6C82221E6B9303043O007718E74E03123O00AB23B14FCE520492399142CE45028A22A94E03073O0071E24DC52ABC20026O00084003153O001804F1B42E1EDBB3091FFAB12817F3BA2917D3961E03043O00D55A7694030E3O007D3CBB4559683AA65F465E09977203053O002D3B4ED43603113O0036448C989239B4E21D45A59E94378AD33403083O00907036E3EBE64ECD03103O00863B0AD8D55AA7203CE8C252B82D27CC03063O003BD3486F9CB0030F3O007B94E6094F95E81E5B84E0225CAFD303043O004D2EE78303143O008F47B3619767976D807BB046BF5AA549AC51BA5903043O0020DA34D6030F3O00661230A4F8BE426A410338A7FF987503083O003A2E7751C891D025030E3O001E9F3584ACBC3A3F8423B8A6B33303073O00564BEC50CCC9DD030D3O005A447689EA836155788BFBA34203063O00EB122117E59E03143O0075B7D1B447BFD38945B4C48C55BBD1B45E9DE29F03043O00DB30DAA103123O00D7707F5BD249E9E7787D45EB4EE3F0565F6D03073O008084111C29BB2F03103O002C3B083E7B13370320582E34001D7E2503053O003D6152665A0011012O0012C83O00013O002606012O001F000100010004F23O001F00010012FC000100023O0020110001000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O001222000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122F000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O00010001000200062O0001001D000100010004F23O001D00010012C8000100014O0097000100033O0012C83O000A3O002606012O003D0001000B0004F23O003D00010012FC000100023O0020110001000100034O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100043O001222000100023O00202O0001000100034O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122F000100023O00202O0001000100034O000200013O00122O000300103O00122O000400116O0002000400024O00010001000200062O0001003B000100010004F23O003B00010012C8000100014O0097000100063O0012C83O00123O002606012O0058000100130004F23O005800010012FC000100023O0020110001000100034O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O001222000100023O00202O0001000100034O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100083O001222000100023O00202O0001000100034O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O0004F23O00102O01002606012O00730001001A0004F23O007300010012FC000100023O0020720001000100034O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100023O00202O0001000100034O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00122O000100023O00202O0001000100034O000200013O00122O0003001F3O00122O000400206O0002000400024O0001000100024O0001000C3O00124O00213O002606012O0097000100220004F23O009700010012FC000100023O0020D50001000100034O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O0001007F000100010004F23O007F00010012C8000100014O00970001000D3O00122F000100023O00202O0001000100034O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O0001008A000100010004F23O008A00010012C8000100014O00970001000E3O00122F000100023O00202O0001000100034O000200013O00122O000300273O00122O000400286O0002000400024O00010001000200062O00010095000100010004F23O009500010012C8000100014O00970001000F3O0012C83O00293O002606012O00B2000100120004F23O00B200010012FC000100023O0020720001000100034O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100103O00122O000100023O00202O0001000100034O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100113O00122O000100023O00202O0001000100034O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000100123O00124O00133O002606012O00D3000100290004F23O00D300010012FC000100023O0020D50001000100034O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100BE000100010004F23O00BE00010012C8000100014O0097000100133O00122F000100023O00202O0001000100034O000200013O00122O000300323O00122O000400336O0002000400024O00010001000200062O000100C9000100010004F23O00C900010012C8000100014O0097000100143O0012132O0100023O00202O0001000100034O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100153O00124O001A3O002606012O00F40001000A0004F23O00F400010012FC000100023O0020D50001000100034O000200013O00122O000300363O00122O000400376O0002000400024O00010001000200062O000100DF000100010004F23O00DF00010012C8000100014O0097000100163O001222000100023O00202O0001000100034O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000100173O00122F000100023O00202O0001000100034O000200013O00122O0003003A3O00122O0004003B6O0002000400024O00010001000200062O000100F2000100010004F23O00F200010012C8000100014O0097000100183O0012C83O00223O002606012O0001000100210004F23O000100010012FC000100023O0020720001000100034O000200013O00122O0003003C3O00122O0004003D6O0002000400024O0001000100024O000100193O00122O000100023O00202O0001000100034O000200013O00122O0003003E3O00122O0004003F6O0002000400024O0001000100024O0001001A3O00122O000100023O00202O0001000100034O000200013O00122O000300403O00122O000400416O0002000400024O0001000100024O0001001B3O00124O000B3O0004F23O000100012O00ED3O00017O00023O00028O00024O0080B3C540000A3O0012C83O00013O000EF80001000100013O0004F23O000100010012C8000100024O009700015O0012C8000100024O0097000100013O0004F23O000900010004F23O000100012O00ED3O00017O00033O00030E3O00476174686572696E6753746F726D030B3O004973417661696C61626C6503093O004576657266726F7374000C4O00EF3O00013O00206O000100206O00026O0002000200064O000A000100010004F23O000A00012O00D93O00013O0020825O00030020505O00022O00D43O000200022O00978O00ED3O00019O003O00034O001F012O00014O00FF3O00024O00ED3O00017O001B3O00028O00026O001040026O002A40026O002C40026O00F03F03013O003A027O004003043O00D6E1645B03073O00E9E5D2536B282E03043O009211658603053O0065A12252B603043O00BB5E0FA603083O004E886D399EBB82E203043O006D6CAFA903043O00915E5F99026O00084003063O00EDC115CC4BA503063O00D79DAD74B52E026O003040034O0003063O0025B88AEBDF2703053O00BA55D4EB92026O00314003123O004973457175692O7065644974656D5479706503083O00F69619B311EF56C603073O0038A2E1769E598E030C3O0047657445717569706D656E74007F3O0012C83O00013O002606012O0020000100020004F23O002000012O00D9000100013O0020820001000100030006272O01000D00013O0004F23O000D00012O00D9000100024O00D9000200013O0020820002000200032O00D400010002000200065100010010000100010004F23O001000012O00D9000100023O0012C8000200014O00D40001000200022O009700016O00D9000100013O0020820001000100040006272O01001B00013O0004F23O001B00012O00D9000100024O00D9000200013O0020820002000200042O00D40001000200020006510001001E000100010004F23O001E00012O00D9000100023O0012C8000200014O00D40001000200022O0097000100033O0004F23O007E0001002606012O0031000100050004F23O003100012O00D9000100063O0012BC000200066O000300076O0001000300034O000300056O000200046O000100046O000100063O00122O000200066O000300096O0001000300034O000300086O000200046O000100043O00124O00073O000EF80007005600013O0004F23O005600012O00D9000100054O00CC0002000B3O00122O000300083O00122O000400096O00020004000200062O00010042000100020004F23O004200012O00D9000100084O00CC0002000B3O00122O0003000A3O00122O0004000B6O00020004000200062O00010042000100020004F23O004200012O005900016O001F2O0100014O00970001000A4O00D9000100054O00CC0002000B3O00122O0003000C3O00122O0004000D6O00020004000200062O00010053000100020004F23O005300012O00D9000100084O00CC0002000B3O00122O0003000E3O00122O0004000F6O00020004000200062O00010053000100020004F23O005300012O005900016O001F2O0100014O00970001000C3O0012C83O00103O002606012O006F000100010004F23O006F00012O00D90001000D4O00400002000B3O00122O000300113O00122O000400126O00020004000200122O000300136O00010003000200062O00010062000100010004F23O006200010012C8000100144O0097000100074O00370001000D6O0002000B3O00122O000300153O00122O000400166O00020004000200122O000300176O00010003000200062O0001006D000100010004F23O006D00010012C8000100144O0097000100093O0012C83O00053O002606012O0001000100100004F23O000100010012FC000100184O006A0002000B3O00122O000300193O00122O0004001A6O000200046O00013O00024O0001000E6O0001000F3O00202O00010001001B4O0001000200024O000100013O00124O00023O00044O000100012O00ED3O00017O00033O0003103O004865616C746850657263656E7461676503063O0042752O665570030F3O004465617468537472696B6542752O6600164O00DF7O00206O00016O000200024O000100013O00064O0013000100010004F23O001300012O00D97O0020505O00012O00D43O000200022O00D9000100023O00062A3O0012000100010004F23O001200012O00D97O0020F95O00024O000200033O00202O0002000200036O0002000200044O001400012O00598O001F012O00014O00FF3O00024O00ED3O00017O00053O00030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66026O00F03F030D3O00446562752O6652656D61696E73028O0001123O0020C000013O00014O00035O00202O0003000300024O00010003000200202O00010001000300202O00023O00044O00045O00202O0004000400024O00020004000200202O00020002000300202O0002000200054O0001000100024O000200016O000300026O0002000200024O0001000100024O000100028O00017O00023O00030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O6601063O00202E00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O000F3O00028O00026O00F03F03113O0052656D6F7273656C652O7357696E74657203073O004973526561647903093O004973496E52616E6765026O002040031E3O00238771B3239179B034916F83268B72A834903CAC23877FB33C807DA871D603043O00DC51E21C025O00804D40026O003940025O00804640030C3O00486F776C696E67426C617374030E3O0049735370652O6C496E52616E676503193O001BDA95F7E3C914EA80F7EBD4079592E9EFC41CD880FAFE874103063O00A773B5E29B8A00463O0012C83O00013O002606012O001B000100020004F23O001B00012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01004500013O0004F23O004500012O00D9000100013O0020500001000100050012C8000300064O00E60001000300020006272O01004500013O0004F23O004500012O00D9000100024O00D900025O0020820002000200032O00D40001000200020006272O01004500013O0004F23O004500012O00D9000100033O001231000200073O00122O000300086O000100036O00015O00044O00450001000EF80001000100013O0004F23O000100012O00D9000100053O000E2401090023000100010004F23O002300010012C80001000A3O00065100010024000100010004F23O002400010012C80001000B4O0097000100044O001700015O00202O00010001000C00202O0001000100044O00010002000200062O0001004300013O0004F23O004300012O00D9000100013O0020500001000100050012C8000300064O00E600010003000200065100010043000100010004F23O004300012O00D9000100024O00D800025O00202O00020002000C4O000300046O000500013O00202O00050005000D4O00075O00202O00070007000C4O0005000700024O000500056O00010005000200062O0001004300013O0004F23O004300012O00D9000100033O0012C80002000E3O0012C80003000F4O00AF000100034O00E100015O0012C83O00023O0004F23O000100012O00ED3O00017O00053O00028O0003103O0048616E646C65546F705472696E6B6574026O004440026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B657400203O0012C83O00014O000F2O0100013O002606012O0010000100010004F23O001000012O00D900025O0020710002000200024O000300016O000400023O00122O000500036O000600066O0002000600024O000100023O00062O0001000F00013O0004F23O000F00012O00FF000100023O0012C83O00043O002606012O0002000100040004F23O000200012O00D900025O0020710002000200054O000300016O000400023O00122O000500036O000600066O0002000600024O000100023O00062O0001001F00013O0004F23O001F00012O00FF000100023O0004F23O001F00010004F23O000200012O00ED3O00017O00343O00028O00026O001040030C3O00486F726E6F6657696E746572030A3O0049734361737461626C6503043O0052756E65027O004003113O0052756E6963506F77657244656669636974026O00394003153O00EA2DF552447EC0DD35EE526F74D4A223E8593B209E03073O00A68242873C1B11030D3O00417263616E65546F2O72656E7403073O004973526561647903153O004558CD743E4175DA7A22564FC061702O45CB35621403053O0050242AAE15030E3O00476C616369616C416476616E636503093O004973496E52616E6765026O00594003163O00491C367947113B454F14217B4013323A4F1F323A1F4003043O001A2E7057030B3O0046726F7374736379746865030E3O004973496E4D656C2O6552616E6765026O00204003123O00BF31A467ABAC462OAD2BAE34BEB040F4E87103083O00D4D943CB142ODF25026O000840030A3O004F626C69746572617465026O00144003113O00B58FA4DBAE88BAD3AE88E8D3B588E883EE03043O00B2DAEDC8030B3O0046726F7374537472696B65030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503133O00B0A7E9C3A28AF5C4A4BCEDD5F6B4E9D5F6E4B003043O00B0D6D58603113O0052656D6F7273656C652O7357696E74657203183O00E6A8BBDBBA455CF8A8A5C7974150FAB9B3C6E85756F1EDE403073O003994CDD6B4C836030C3O00486F776C696E67426C61737403063O0042752O66557003083O0052696D6542752O66030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O6603133O001AF222387F1CFA0A367A13EE2174771DF8756003053O0016729D5554026O00F03F03153O00C3C712C754F7A4FBCA17D25CF8ABC18B12CB58B6FE03073O00C8A4AB73A43D9603123O004B692O6C696E674D616368696E6542752O66030F3O00436C656176696E67537472696B657303113O004465617468416E64446563617942752O6603103O00B1F60F4C97BBE6025186FEF50C40C3E603053O00E3DE9463250040012O0012C83O00013O002606012O003A000100020004F23O003A00012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01001F00013O0004F23O001F00012O00D9000100013O0020500001000100052O00D40001000200020026112O01001F000100060004F23O001F00012O00D9000100013O0020500001000100072O00D4000100020002000E240108001F000100010004F23O001F00012O00D9000100024O000B00025O00202O0002000200034O000300036O00010003000200062O0001001F00013O0004F23O001F00012O00D9000100043O0012C8000200093O0012C80003000A4O00AF000100034O00E100016O00D9000100053O0006272O01003F2O013O0004F23O003F2O012O00D900015O00208200010001000B00205000010001000C2O00D40001000200020006272O01003F2O013O0004F23O003F2O012O00D9000100013O0020500001000100072O00D4000100020002000E240108003F2O0100010004F23O003F2O012O00D9000100024O000B00025O00202O00020002000B4O000300066O00010003000200062O0001003F2O013O0004F23O003F2O012O00D9000100043O0012310002000D3O00122O0003000E6O000100036O00015O00044O003F2O01002606012O0071000100060004F23O007100012O00D900015O00208200010001000F00205000010001000C2O00D40001000200020006272O01005600013O0004F23O005600012O00D9000100073O00065100010056000100010004F23O005600012O00D9000100024O001201025O00202O00020002000F4O000300046O000500083O00202O00050005001000122O000700116O0005000700024O000500056O00010005000200062O0001005600013O0004F23O005600012O00D9000100043O0012C8000200123O0012C8000300134O00AF000100034O00E100016O00D900015O00208200010001001400205000010001000C2O00D40001000200020006272O01007000013O0004F23O007000012O00D9000100093O0006272O01007000013O0004F23O007000012O00D9000100024O001201025O00202O0002000200144O000300046O000500083O00202O00050005001500122O000700166O0005000700024O000500056O00010005000200062O0001007000013O0004F23O007000012O00D9000100043O0012C8000200173O0012C8000300184O00AF000100034O00E100015O0012C83O00193O002606012O00B0000100190004F23O00B000012O00D900015O00208200010001001A00205000010001000C2O00D40001000200020006272O01008D00013O0004F23O008D00012O00D9000100093O0006510001008D000100010004F23O008D00012O00D9000100024O001201025O00202O00020002001A4O000300046O000500083O00202O00050005001500122O0007001B6O0005000700024O000500056O00010005000200062O0001008D00013O0004F23O008D00012O00D9000100043O0012C80002001C3O0012C80003001D4O00AF000100034O00E100016O00D900015O00208200010001001E00205000010001000C2O00D40001000200020006272O0100AF00013O0004F23O00AF00012O00D9000100073O000651000100AF000100010004F23O00AF00012O00D900015O00208200010001000F00205000010001001F2O00D4000100020002000651000100AF000100010004F23O00AF00012O00D9000100024O006600025O00202O00020002001E4O0003000A6O000400046O000500083O00202O0005000500204O00075O00202O00070007001E4O0005000700024O000500056O00010005000200062O000100AF00013O0004F23O00AF00012O00D9000100043O0012C8000200213O0012C8000300224O00AF000100034O00E100015O0012C83O00023O002606012O00F0000100010004F23O00F000012O00D900015O00208200010001002300205000010001000C2O00D40001000200020006272O0100C900013O0004F23O00C900012O00D9000100024O001201025O00202O0002000200234O000300046O000500083O00202O00050005001500122O000700166O0005000700024O000500056O00010005000200062O000100C900013O0004F23O00C900012O00D9000100043O0012C8000200243O0012C8000300254O00AF000100034O00E100016O00D900015O00208200010001002600205000010001000C2O00D40001000200020006272O0100EF00013O0004F23O00EF00012O00D9000100013O0020100001000100274O00035O00202O0003000300284O00010003000200062O000100DD000100010004F23O00DD00012O00D9000100083O00200A2O01000100294O00035O00202O00030003002A4O00010003000200062O000100EF00013O0004F23O00EF00012O00D9000100024O00D800025O00202O0002000200264O000300046O000500083O00202O0005000500204O00075O00202O0007000700264O0005000700024O000500056O00010005000200062O000100EF00013O0004F23O00EF00012O00D9000100043O0012C80002002B3O0012C80003002C4O00AF000100034O00E100015O0012C83O002D3O002606012O00010001002D0004F23O000100012O00D900015O00208200010001000F00205000010001000C2O00D40001000200020006272O01000F2O013O0004F23O000F2O012O00D9000100073O0006510001000F2O0100010004F23O000F2O012O00D90001000B3O0006272O01000F2O013O0004F23O000F2O012O00D9000100024O001201025O00202O00020002000F4O000300046O000500083O00202O00050005001000122O000700116O0005000700024O000500056O00010005000200062O0001000F2O013O0004F23O000F2O012O00D9000100043O0012C80002002E3O0012C80003002F4O00AF000100034O00E100016O00D900015O00208200010001001A00205000010001000C2O00D40001000200020006272O01003D2O013O0004F23O003D2O012O00D9000100013O00200A2O01000100274O00035O00202O0003000300304O00010003000200062O0001003D2O013O0004F23O003D2O012O00D900015O00208200010001003100205000010001001F2O00D40001000200020006272O01003D2O013O0004F23O003D2O012O00D9000100013O00200A2O01000100274O00035O00202O0003000300324O00010003000200062O0001003D2O013O0004F23O003D2O012O00D9000100093O0006510001003D2O0100010004F23O003D2O012O00D9000100024O001201025O00202O00020002001A4O000300046O000500083O00202O00050005001500122O0007001B6O0005000700024O000500056O00010005000200062O0001003D2O013O0004F23O003D2O012O00D9000100043O0012C8000200333O0012C8000300344O00AF000100034O00E100015O0012C83O00063O0004F23O000100012O00ED3O00017O00433O00028O00026O00F03F030B3O0046726F737473637974686503073O004973526561647903063O0042752O66557003123O004B692O6C696E674D616368696E6542752O66030E3O004973496E4D656C2O6552616E6765026O00204003153O0035405DE5ED20514BE2F1361250E4FC32465AB6A86303053O0099532O3296030A3O0052756E6963506F776572025O0080464003153O005B647C0F67B84E44627B1933A95F5877671433FA1F03073O002D3D16137C13CB030A3O004F626C6974657261746503113O0052756E6963506F77657244656669636974026O00444003113O0050692O6C61726F6646726F737442752O66026O003140030C3O004361737454617267657449662O033O00CC131503073O00D9A1726D956210026O00144003143O001D223475A87100212C79FC7600253968B434437403063O00147240581CDC030D3O004465617468416E644465636179026O004240030B3O0052756E6554696D65546F58027O0040026O00324003093O00446144506C61796572030E3O0049735370652O6C496E52616E676503193O003504D3A0F0EFBC3F05EDB0FDD3BC2841D0A6FDD1A9394183E203073O00DD5161B2D498B003113O0052656D6F7273656C652O7357696E746572031C3O00DFE210F408DEE211FE09DED80AF214D9E20FBB18DFE21CEF128DB64503053O007AAD877D9B030C3O00486F776C696E67426C61737403173O008CCE17B5363FCFBBC30CB82C258886D305B82B3988D69103073O00A8E4A160D95F51026O0039402O033O00D6D03603063O0037BBB14E3C4F03143O0022CC53E252CA922CDA5AAB44DD852CDA57AB149D03073O00E04DAE3F8B26AF03083O0052696D6542752O6603173O008C4E4F228D4F5F11864D593D90015A3C81404C26C4130C03043O004EE42138026O000840031B3O00DC7BBF0C97DD7BBE0696DD41A50A8BDA7BA04387DC7BB3178D8E2C03053O00E5AE1ED26303173O00526167656F6674686546726F7A656E4368616D70696F6E030B3O004973417661696C61626C6503163O0013E2915DE4333E24EF8A50FE297919FF8350F935794F03073O00597B8DE6318D5D030C3O00486F726E6F6657696E74657203043O0052756E6503173O00FB7EE4022F45F54EE1051E5EF663B60E024FF265FE4C4603063O002A9311966C702O033O0002A73503063O00886FC64D1F8703133O000D0BAB5FA9E105A8160CE754AFE116BD0A49FF03083O00C96269C736DD8477030D3O00417263616E65546F2O72656E74026O004E4003183O00B81E80200C3093AD039133073BB8F90E91240321A4F95ED503073O00CCD96CE341625500D5012O0012C83O00013O002606012O009B000100020004F23O009B00012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01002400013O0004F23O002400012O00D9000100013O00200A2O01000100054O00035O00202O0003000300064O00010003000200062O0001002400013O0004F23O002400012O00D9000100023O0006272O01002400013O0004F23O002400012O00D9000100034O001201025O00202O0002000200034O000300046O000500043O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002400013O0004F23O002400012O00D9000100053O0012C8000200093O0012C80003000A4O00AF000100034O00E100016O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01004300013O0004F23O004300012O00D9000100023O0006272O01004300013O0004F23O004300012O00D9000100013O00205000010001000B2O00D4000100020002000E24010C0043000100010004F23O004300012O00D9000100034O001201025O00202O0002000200034O000300046O000500043O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001004300013O0004F23O004300012O00D9000100053O0012C80002000D3O0012C80003000E4O00AF000100034O00E100016O00D900015O00208200010001000F0020500001000100042O00D40001000200020006272O01007200013O0004F23O007200012O00D9000100013O0020500001000100102O00D4000100020002000E890011005A000100010004F23O005A00012O00D9000100013O00200A2O01000100054O00035O00202O0003000300124O00010003000200062O0001007200013O0004F23O007200012O00D9000100013O0020500001000100102O00D4000100020002000E2401130072000100010004F23O007200012O00D9000100063O0020490001000100144O00025O00202O00020002000F4O000300076O000400053O00122O000500153O00122O000600166O0004000600024O000500086O000600066O000700043O00202O00070007000700122O000900176O0007000900024O000700076O00010007000200062O0001007200013O0004F23O007200012O00D9000100053O0012C8000200183O0012C8000300194O00AF000100034O00E100016O00D900015O00208200010001001A0020500001000100042O00D40001000200020006272O01009A00013O0004F23O009A00012O00D9000100013O00205000010001000B2O00D40001000200020026112O01009A0001001B0004F23O009A00012O00D9000100013O0020BB00010001001C00122O0003001D6O0001000300024O000200013O00202O00020002000B4O00020002000200202O00020002001E00062O0002009A000100010004F23O009A00012O00D9000100034O0066000200093O00202O00020002001F4O0003000A6O000400046O000500043O00202O0005000500204O00075O00202O00070007001A4O0005000700024O000500056O00010005000200062O0001009A00013O0004F23O009A00012O00D9000100053O0012C8000200213O0012C8000300224O00AF000100034O00E100015O0012C83O001D3O002606012O002D2O01001D0004F23O002D2O012O00D900015O0020820001000100230020500001000100042O00D40001000200020006272O0100C300013O0004F23O00C300012O00D9000100013O00205000010001000B2O00D40001000200020026112O0100C30001001B0004F23O00C300012O00D9000100013O0020BB00010001001C00122O0003001D6O0001000300024O000200013O00202O00020002000B4O00020002000200202O00020002001E00062O000200C3000100010004F23O00C300012O00D9000100034O001201025O00202O0002000200234O000300046O000500043O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O000100C300013O0004F23O00C300012O00D9000100053O0012C8000200243O0012C8000300254O00AF000100034O00E100016O00D900015O0020820001000100260020500001000100042O00D40001000200020006272O0100EA00013O0004F23O00EA00012O00D9000100013O00205000010001000B2O00D40001000200020026112O0100EA0001001B0004F23O00EA00012O00D9000100013O0020BB00010001001C00122O0003001D6O0001000300024O000200013O00202O00020002000B4O00020002000200202O00020002001E00062O000200EA000100010004F23O00EA00012O00D9000100034O00D800025O00202O0002000200264O000300046O000500043O00202O0005000500204O00075O00202O0007000700264O0005000700024O000500056O00010005000200062O000100EA00013O0004F23O00EA00012O00D9000100053O0012C8000200273O0012C8000300284O00AF000100034O00E100016O00D900015O00208200010001000F0020500001000100042O00D40001000200020006272O01000D2O013O0004F23O000D2O012O00D9000100013O0020500001000100102O00D4000100020002000E240129000D2O0100010004F23O000D2O012O00D9000100063O0020490001000100144O00025O00202O00020002000F4O000300076O000400053O00122O0005002A3O00122O0006002B6O0004000600024O000500086O000600066O000700043O00202O00070007000700122O000900176O0007000900024O000700076O00010007000200062O0001000D2O013O0004F23O000D2O012O00D9000100053O0012C80002002C3O0012C80003002D4O00AF000100034O00E100016O00D900015O0020820001000100260020500001000100042O00D40001000200020006272O01002C2O013O0004F23O002C2O012O00D9000100013O00200A2O01000100054O00035O00202O00030003002E4O00010003000200062O0001002C2O013O0004F23O002C2O012O00D9000100034O00D800025O00202O0002000200264O000300046O000500043O00202O0005000500204O00075O00202O0007000700264O0005000700024O000500056O00010005000200062O0001002C2O013O0004F23O002C2O012O00D9000100053O0012C80002002F3O0012C8000300304O00AF000100034O00E100015O0012C83O00313O002606012O00B92O0100010004F23O00B92O012O00D900015O0020820001000100230020500001000100042O00D40001000200020006272O01004C2O013O0004F23O004C2O012O00D90001000B3O0006510001003B2O0100010004F23O003B2O012O00D90001000C3O0006272O01004C2O013O0004F23O004C2O012O00D9000100034O001201025O00202O0002000200234O000300046O000500043O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001004C2O013O0004F23O004C2O012O00D9000100053O0012C8000200323O0012C8000300334O00AF000100034O00E100016O00D900015O0020820001000100260020500001000100042O00D40001000200020006272O0100742O013O0004F23O00742O012O00D90001000D3O0006272O0100742O013O0004F23O00742O012O00D9000100013O00201D2O010001000B4O0001000200024O0002000E6O00035O00202O00030003003400202O0003000300354O000300046O00023O000200202O00020002000800102O0002000C000200062A000200742O0100010004F23O00742O012O00D9000100034O00D800025O00202O0002000200264O000300046O000500043O00202O0005000500204O00075O00202O0007000700264O0005000700024O000500056O00010005000200062O000100742O013O0004F23O00742O012O00D9000100053O0012C8000200363O0012C8000300374O00AF000100034O00E100016O00D900015O0020820001000100380020500001000100042O00D40001000200020006272O0100902O013O0004F23O00902O012O00D9000100013O0020500001000100392O00D40001000200020026112O0100902O01001D0004F23O00902O012O00D9000100013O0020500001000100102O00D4000100020002000E24012900902O0100010004F23O00902O012O00D9000100034O000B00025O00202O0002000200384O0003000F6O00010003000200062O000100902O013O0004F23O00902O012O00D9000100053O0012C80002003A3O0012C80003003B4O00AF000100034O00E100016O00D900015O00208200010001000F0020500001000100042O00D40001000200020006272O0100B82O013O0004F23O00B82O012O00D9000100013O00200A2O01000100054O00035O00202O0003000300064O00010003000200062O000100B82O013O0004F23O00B82O012O00D9000100023O000651000100B82O0100010004F23O00B82O012O00D9000100063O0020490001000100144O00025O00202O00020002000F4O000300076O000400053O00122O0005003C3O00122O0006003D6O0004000600024O000500086O000600066O000700043O00202O00070007000700122O000900176O0007000900024O000700076O00010007000200062O000100B82O013O0004F23O00B82O012O00D9000100053O0012C80002003E3O0012C80003003F4O00AF000100034O00E100015O0012C83O00023O000EF80031000100013O0004F23O000100012O00D900015O0020820001000100400020500001000100042O00D40001000200020006272O0100D42O013O0004F23O00D42O012O00D9000100013O00205000010001000B2O00D40001000200020026112O0100D42O0100410004F23O00D42O012O00D9000100034O000B00025O00202O0002000200404O000300106O00010003000200062O000100D42O013O0004F23O00D42O012O00D9000100053O001231000200423O00122O000300436O000100036O00015O00044O00D42O010004F23O000100012O00ED3O00017O00233O00028O00027O0040030C3O00486F726E6F6657696E74657203073O004973526561647903113O0052756E6963506F77657244656669636974026O003940031E3O0056CCE7EB13CF58FCE2EC22D45BD1B5E73EC55FD7FDDA23C252CAE1A57D9003063O00A03EA395854C030D3O00417263616E65546F2O72656E74026O003440031E3O00D7B20E2ECDD39F1920D1C4A5033B83D4B2082ED7DE9F022DCFDFB44D7E9103053O00A3B6C06D4F026O00F03F030C3O00486F776C696E67426C61737403063O0042752O66557003083O0052696D6542752O66030E3O0049735370652O6C496E52616E6765031C3O003C2917CCFC3A213FC2F92O351480F7262301D4FD0B2902CCFC20665603053O0095544660A003083O0042752O66446F776E03123O004B692O6C696E674D616368696E6542752O66031C3O0030091AE131080AD23A0A0CFE2C460FFF3D0719E507090FE131124DB503043O008D58666D030B3O0046726F7374736379746865030E3O004973496E4D656C2O6552616E6765026O002040031A3O00B541C5630E2E56D8A75BCF30182F50C0A75BF57F18315CD5F30103083O00A1D333AA107A5D35030A3O004F626C69746572617465030C3O004361737454617267657449662O033O00F6AFAA03043O00489BCED2026O00144003193O0049785807274368551A360678460B3252726B01314A73404E6703053O0053261A346E00BE3O0012C83O00013O002606012O0032000100020004F23O003200012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01001A00013O0004F23O001A00012O00D9000100013O0020500001000100052O00D4000100020002000E240106001A000100010004F23O001A00012O00D9000100024O000B00025O00202O0002000200034O000300036O00010003000200062O0001001A00013O0004F23O001A00012O00D9000100043O0012C8000200073O0012C8000300084O00AF000100034O00E100016O00D900015O0020820001000100090020500001000100042O00D40001000200020006272O0100BD00013O0004F23O00BD00012O00D9000100013O0020500001000100052O00D4000100020002000E24010A00BD000100010004F23O00BD00012O00D9000100024O000B00025O00202O0002000200094O000300056O00010003000200062O000100BD00013O0004F23O00BD00012O00D9000100043O0012310002000B3O00122O0003000C6O000100036O00015O00044O00BD0001002606012O00730001000D0004F23O007300012O00D900015O00208200010001000E0020500001000100042O00D40001000200020006272O01005300013O0004F23O005300012O00D9000100013O00200A2O010001000F4O00035O00202O0003000300104O00010003000200062O0001005300013O0004F23O005300012O00D9000100024O00D800025O00202O00020002000E4O000300046O000500063O00202O0005000500114O00075O00202O00070007000E4O0005000700024O000500056O00010005000200062O0001005300013O0004F23O005300012O00D9000100043O0012C8000200123O0012C8000300134O00AF000100034O00E100016O00D900015O00208200010001000E0020500001000100042O00D40001000200020006272O01007200013O0004F23O007200012O00D9000100013O00200A2O01000100144O00035O00202O0003000300154O00010003000200062O0001007200013O0004F23O007200012O00D9000100024O00D800025O00202O00020002000E4O000300046O000500063O00202O0005000500114O00075O00202O00070007000E4O0005000700024O000500056O00010005000200062O0001007200013O0004F23O007200012O00D9000100043O0012C8000200163O0012C8000300174O00AF000100034O00E100015O0012C83O00023O002606012O0001000100010004F23O000100012O00D900015O0020820001000100180020500001000100042O00D40001000200020006272O01009600013O0004F23O009600012O00D9000100013O00200A2O010001000F4O00035O00202O0003000300154O00010003000200062O0001009600013O0004F23O009600012O00D9000100073O0006272O01009600013O0004F23O009600012O00D9000100024O001201025O00202O0002000200184O000300046O000500063O00202O00050005001900122O0007001A6O0005000700024O000500056O00010005000200062O0001009600013O0004F23O009600012O00D9000100043O0012C80002001B3O0012C80003001C4O00AF000100034O00E100016O00D900015O00208200010001001D0020500001000100042O00D40001000200020006272O0100BB00013O0004F23O00BB00012O00D9000100013O00200A2O010001000F4O00035O00202O0003000300154O00010003000200062O000100BB00013O0004F23O00BB00012O00D9000100083O00204900010001001E4O00025O00202O00020002001D4O000300096O000400043O00122O0005001F3O00122O000600206O0004000600024O0005000A6O000600066O000700063O00202O00070007001900122O000900216O0007000900024O000700076O00010007000200062O000100BB00013O0004F23O00BB00012O00D9000100043O0012C8000200223O0012C8000300234O00AF000100034O00E100015O0012C83O000D3O0004F23O000100012O00ED3O00017O00283O00028O00027O0040030B3O00436861696E736F6649636503073O0049735265616479030C3O004F626C697465726174696F6E030B3O004973417661696C61626C6503083O0042752O66446F776E03113O0050692O6C61726F6646726F737442752O6603093O0042752O66537461636B030D3O00436F6C64486561727442752O66026O002C4003063O0042752O66557003123O00556E686F6C79537472656E67746842752O66026O003340030D3O0050692O6C61726F6646726F7374030F3O00432O6F6C646F776E52656D61696E73026O000840030E3O0049735370652O6C496E52616E6765031B3O005B1F264F560418495E282E455D5724495413184E5D16355218467703043O00263877472O033O0047434403043O0052756E6503123O004B692O6C696E674D616368696E6542752O66026O001040026O002040026O002440031A3O00F0E759DF2B45CCE05EE92C55F6AF5BD92952CCE75DD73742B3BD03063O0036938F38B645030B3O0042752O6652656D61696E73030E3O0046726F73747779726D7346757279026O00F03F031A3O00D589FE40D1C5BEF04FE0DF82FA09DCD98DFB76D7D380ED5D9F8203053O00BFB6E19F29026O002E40026O002A40031A3O00281A295C8594FD2414175C882O82281D2451B48FC72A003C15DD03073O00A24B724835EBE7026O003440031A3O008F3445EB5D11B33342DD5A01897C47ED5F06B33441E34116CC6403063O0062EC5C2482330079012O0012C83O00013O000EF80002004B00013O0004F23O004B00012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100782O013O0004F23O00782O012O00D900015O0020820001000100050020500001000100062O00D40001000200020006272O0100782O013O0004F23O00782O012O00D9000100013O00200A2O01000100074O00035O00202O0003000300084O00010003000200062O000100782O013O0004F23O00782O012O00D9000100013O00201B0001000100094O00035O00202O00030003000A4O000100030002000E2O000B0024000100010004F23O002400012O00D9000100013O00201000010001000C4O00035O00202O00030003000D4O00010003000200062O00010038000100010004F23O003800012O00D9000100013O00205B0001000100094O00035O00202O00030003000A4O000100030002000E2O000E0038000100010004F23O003800012O00D900015O00208200010001000F0020500001000100102O00D40001000200020026112O0100782O0100110004F23O00782O012O00D9000100013O00201B0001000100094O00035O00202O00030003000A4O000100030002000E2O000B00782O0100010004F23O00782O012O00D9000100024O00D800025O00202O0002000200034O000300036O000400033O00202O0004000400124O00065O00202O0006000600034O0004000600024O000400046O00010004000200062O000100782O013O0004F23O00782O012O00D9000100043O001231000200133O00122O000300146O000100036O00015O00044O00782O01002606012O00FC000100010004F23O00FC00012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100A600013O0004F23O00A600012O00D9000100054O00D9000200013O0020500002000200152O00D400020002000200062A000100A6000100020004F23O00A600012O00D9000100013O0020500001000100162O00D400010002000200269D00010094000100020004F23O009400012O00D9000100013O00200A2O01000100074O00035O00202O0003000300174O00010003000200062O0001007900013O0004F23O007900012O00D9000100063O0006510001006F000100010004F23O006F00012O00D9000100013O00205B0001000100094O00035O00202O00030003000A4O000100030002000E2O00180094000100010004F23O009400012O00D9000100063O0006272O01007900013O0004F23O007900012O00D9000100013O0020052O01000100094O00035O00202O00030003000A4O000100030002000E2O00190094000100010004F23O009400012O00D9000100013O00200A2O010001000C4O00035O00202O0003000300174O00010003000200062O000100A600013O0004F23O00A600012O00D9000100063O0006510001008A000100010004F23O008A00012O00D9000100013O0020052O01000100094O00035O00202O00030003000A4O000100030002000E2O00190094000100010004F23O009400012O00D9000100063O0006272O0100A600013O0004F23O00A600012O00D9000100013O0020F70001000100094O00035O00202O00030003000A4O000100030002000E2O001A00A6000100010004F23O00A600012O00D9000100024O00D800025O00202O0002000200034O000300036O000400033O00202O0004000400124O00065O00202O0006000600034O0004000600024O000400046O00010004000200062O000100A600013O0004F23O00A600012O00D9000100043O0012C80002001B3O0012C80003001C4O00AF000100034O00E100016O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100FB00013O0004F23O00FB00012O00D900015O0020820001000100050020500001000100062O00D4000100020002000651000100FB000100010004F23O00FB00012O00D9000100013O00200A2O010001000C4O00035O00202O0003000300084O00010003000200062O000100FB00013O0004F23O00FB00012O00D9000100013O00201B0001000100094O00035O00202O00030003000A4O000100030002000E2O001A00FB000100010004F23O00FB00012O00D9000100013O0020D200010001001D4O00035O00202O0003000300084O0001000300024O000200013O00202O0002000200154O0002000200024O000300076O00045O00202O00040004001E00202O0004000400064O00040002000200062O000400D300013O0004F23O00D300012O00D900045O00208200040004001E0020500004000400042O00D40004000200022O00D40003000200020010F00003001F00032O00550002000200030006AA000100E9000100020004F23O00E900012O00D9000100013O00200A2O010001000C4O00035O00202O00030003000D4O00010003000200062O000100FB00013O0004F23O00FB00012O00D9000100013O00207900010001001D4O00035O00202O00030003000D4O0001000300024O000200013O00202O0002000200154O00020002000200062O000100FB000100020004F23O00FB00012O00D9000100024O00D800025O00202O0002000200034O000300036O000400033O00202O0004000400124O00065O00202O0006000600034O0004000600024O000400046O00010004000200062O000100FB00013O0004F23O00FB00012O00D9000100043O0012C8000200203O0012C8000300214O00AF000100034O00E100015O0012C83O001F3O000EF8001F000100013O0004F23O000100012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100412O013O0004F23O00412O012O00D900015O0020820001000100050020500001000100062O00D4000100020002000651000100412O0100010004F23O00412O012O00D9000100083O0006272O0100412O013O0004F23O00412O012O00D9000100013O00200A2O01000100074O00035O00202O0003000300084O00010003000200062O000100412O013O0004F23O00412O012O00D900015O00208200010001000F0020500001000100102O00D4000100020002000E24012200412O0100010004F23O00412O012O00D9000100013O00201B0001000100094O00035O00202O00030003000A4O000100030002000E2O001A00282O0100010004F23O00282O012O00D9000100013O00201000010001000C4O00035O00202O00030003000D4O00010003000200062O0001002F2O0100010004F23O002F2O012O00D9000100013O00201B0001000100094O00035O00202O00030003000A4O000100030002000E2O002300412O0100010004F23O00412O012O00D9000100024O00D800025O00202O0002000200034O000300036O000400033O00202O0004000400124O00065O00202O0006000600034O0004000600024O000400046O00010004000200062O000100412O013O0004F23O00412O012O00D9000100043O0012C8000200243O0012C8000300254O00AF000100034O00E100016O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100762O013O0004F23O00762O012O00D900015O0020820001000100050020500001000100062O00D4000100020002000651000100762O0100010004F23O00762O012O00D9000100083O000651000100762O0100010004F23O00762O012O00D9000100013O00201B0001000100094O00035O00202O00030003000A4O000100030002000E2O001A00762O0100010004F23O00762O012O00D9000100013O00200A2O01000100074O00035O00202O0003000300084O00010003000200062O000100762O013O0004F23O00762O012O00D900015O00208200010001000F0020500001000100102O00D4000100020002000E24012600762O0100010004F23O00762O012O00D9000100024O00D800025O00202O0002000200034O000300036O000400033O00202O0004000400124O00065O00202O0006000600034O0004000600024O000400046O00010004000200062O000100762O013O0004F23O00762O012O00D9000100043O0012C8000200273O0012C8000300284O00AF000100034O00E100015O0012C83O00023O0004F23O000100012O00ED3O00017O00633O00028O00027O0040030B3O004368692O6C53747265616B03073O004973526561647903073O0048617354696572026O003F40030E3O0049735370652O6C496E52616E676503193O00A71105B64997A624B61C0DB105ABBA3FA81D03AD4BBBF561F103083O0050C4796CDA25C8D503083O0042752O66446F776E03113O004465617468416E64446563617942752O66030F3O00436C656176696E67537472696B6573030B3O004973417661696C61626C65026O00144003193O00037B0B734731991461077E404E890F7C0E7B4419841333532903073O00EA6013621F2B6E030D3O0050692O6C61726F6646726F7374030A3O0049734361737461626C65030C3O004F626C697465726174696F6E03063O0042752O66557003153O00456D706F77657252756E65576561706F6E42752O6603113O00456D706F77657252756E65576561706F6E030F3O00432O6F6C646F776E52656D61696E73026O002840031C3O002O165ECBAD60B409196DC1BE7D98125F51C8A37E8F09085CD4EC23D303073O00EB667F32A7CC12026O00084003093O0052616973654465616403173O0042A0FC30411154A4F427042D5FAEF9274B395EB2B5701603063O004E30C1954324030A3O00536F756C52656170657203073O0054696D65546F58025O0080414003103O004865616C746850657263656E7461676503113O0050692O6C61726F6646726F737442752O6603123O004B692O6C696E674D616368696E6542752O6603123O004272656174686F6653696E647261676F7361030A3O0052756E6963506F776572026O004440030E3O004973496E4D656C2O6552616E676503183O00231195147E221B810844225E83174E3C1A8F0F4F235ED34C03053O0021507EE078030F3O00536163726966696369616C50616374030E3O00476C616369616C416476616E6365030C3O0047686F756C52656D61696E732O033O00474344031D3O00FFA900D655EAA100CD5DE09713C55FF8E800CB53E0AC0CD352FFE8509203053O003C8CC863A4026O001840026O001040030E3O0046726F73747779726D7346757279026O00F03F030B3O0042752O6652656D61696E7303093O004973496E52616E6765031C3O0081E60B35B690ED162BB1B8F21134BBC7F70B29AE83FB1328B1C7A65203053O00C2E7946446031C3O00405ECEB0E2DF5F5ECCB0C9CE535ED8E3F5C74940C5ACE1C6550C93FB03063O00A8262CA1C396030C3O00432O6F6C646F776E446F776E03123O00556E686F6C79537472656E67746842752O66030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66031C3O0086EE8D6524FFAF048DEFBD7025FAAF5683F38D7A34E7A11893BCD12603083O0076E09CE2165088D603043O0052756E65026O001C40026O003440031F3O0047E3498F55EB4BBF50FB57857DF95C8152E157C041E1568C46E14E8E51AE0D03043O00E0228E39030A3O00436F6D62617454696D65026O002440030B3O00426C2O6F646C7573745570025O0080514003103O0046752O6C526563686172676554696D65031F3O00DBAAD5D264F44F31CCB2CBD84CE6580FCEA8CB9D70FE5202DAA8D2D360B10B03083O006EBEC7A5BD13913D031F3O00DFE667E79CC2C8D465FD85C2E5FC72E99BC8D4AB74E784CBDEE460E698878203063O00A7BA8B1788EB030F3O0041626F6D696E6174696F6E4C696D6203243O001BB7870013BB891913BA863216BC850F25A189011FBB9C4D19BA87011EBA9F0309F5D95D03043O006D7AD5E803243O00EFF5AD3DE7F9A324E7F8AC0FE2FEAF32D1E3A33CEBF9B670EDF8AD3CEAF8B53EFDB7F36203043O00508E97C203243O0002C478410AC876580AC979730FCF7A4E3CD2764006C8630C00C9784007C960421086261803043O002C63A61703063O00496365636170031C3O006CFE253A32B643F82F0935B673E43D7630AB73FB2D3924AA6FB77B6603063O00C41C97495653031C3O00E30A251C834A2779F53C2F028D4B0C36F00C261C86570F78E0437B4203083O001693634970E23878026O004E40026O003E4003213O00BA67E7F499B04AEDF3B2AB7CECF19FB972EDE68CF876EDFA81BC7AF5FB9EF827B603053O00EDD8158295030D3O004465617468416E644465636179026O00264003093O00446144506C61796572031C3O00864B5E4BB8F65F8C4A605BB5CA5F9B0E5C50BFC55A8D59514CF09A0603073O003EE22E2O3FD0A90043042O0012C83O00013O000EF80002008900013O0004F23O008900012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01002200013O0004F23O002200012O00D9000100013O0020A800010001000500122O000300063O00122O000400026O00010004000200062O0001002200013O0004F23O002200012O00D9000100024O00D800025O00202O0002000200034O000300046O000500033O00202O0005000500074O00075O00202O0007000700034O0005000700024O000500056O00010005000200062O0001002200013O0004F23O002200012O00D9000100043O0012C8000200083O0012C8000300094O00AF000100034O00E100016O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01005A00013O0004F23O005A00012O00D9000100013O0020B500010001000500122O000300063O00122O000400026O00010004000200062O0001005A000100010004F23O005A00012O00D9000100053O000E8B0002005A000100010004F23O005A00012O00D9000100013O00200A2O010001000A4O00035O00202O00030003000B4O00010003000200062O0001003F00013O0004F23O003F00012O00D900015O00208200010001000C00205000010001000D2O00D400010002000200065100010048000100010004F23O004800012O00D900015O00208200010001000C00205000010001000D2O00D40001000200020006272O01004800013O0004F23O004800012O00D9000100053O00260D0001005A0001000E0004F23O005A00012O00D9000100024O00D800025O00202O0002000200034O000300046O000500033O00202O0005000500074O00075O00202O0007000700034O0005000700024O000500056O00010005000200062O0001005A00013O0004F23O005A00012O00D9000100043O0012C80002000F3O0012C8000300104O00AF000100034O00E100016O00D900015O0020820001000100110020500001000100122O00D40001000200020006272O01008800013O0004F23O008800012O00D900015O00208200010001001300205000010001000D2O00D40001000200020006272O01007900013O0004F23O007900012O00D9000100063O0006510001006C000100010004F23O006C00012O00D9000100073O0006272O01007900013O0004F23O007900012O00D9000100013O0020100001000100144O00035O00202O0003000300154O00010003000200062O0001007C000100010004F23O007C00012O00D900015O0020820001000100160020500001000100172O00D4000100020002000E890001007C000100010004F23O007C00012O00D9000100083O0026112O010088000100180004F23O008800012O00D9000100024O000B00025O00202O0002000200114O000300096O00010003000200062O0001008800013O0004F23O008800012O00D9000100043O0012C8000200193O0012C80003001A4O00AF000100034O00E100015O0012C83O001B3O002606012O00312O01000E0004F23O00312O012O00D900015O00208200010001001C0020500001000100122O00D40001000200020006272O01009D00013O0004F23O009D00012O00D9000100024O00EB00025O00202O00020002001C4O000300036O00010003000200062O0001009D00013O0004F23O009D00012O00D9000100043O0012C80002001D3O0012C80003001E4O00AF000100034O00E100016O00D900015O00208200010001001F0020500001000100042O00D40001000200020006272O0100052O013O0004F23O00052O012O00D9000100083O000E24010E00052O0100010004F23O00052O012O00D9000100033O0020500001000100200012C8000300214O00E600010003000200269D000100B10001000E0004F23O00B100012O00D9000100033O0020500001000100222O00D400010002000200260D000100052O0100210004F23O00052O012O00D9000100053O00260D000100052O0100020004F23O00052O012O00D900015O00208200010001001300205000010001000D2O00D40001000200020006272O0100CF00013O0004F23O00CF00012O00D9000100013O00200A2O01000100144O00035O00202O0003000300234O00010003000200062O000100C800013O0004F23O00C800012O00D9000100013O00201000010001000A4O00035O00202O0003000300244O00010003000200062O000100F4000100010004F23O00F400012O00D9000100013O00201000010001000A4O00035O00202O0003000300234O00010003000200062O000100F4000100010004F23O00F400012O00D900015O00208200010001002500205000010001000D2O00D40001000200020006272O0100E800013O0004F23O00E800012O00D9000100013O00200A2O01000100144O00035O00202O0003000300254O00010003000200062O000100E100013O0004F23O00E100012O00D9000100013O0020500001000100262O00D4000100020002000E89002700F4000100010004F23O00F400012O00D9000100013O00201000010001000A4O00035O00202O0003000300254O00010003000200062O000100F4000100010004F23O00F400012O00D900015O00208200010001002500205000010001000D2O00D4000100020002000651000100052O0100010004F23O00052O012O00D900015O00208200010001001300205000010001000D2O00D4000100020002000651000100052O0100010004F23O00052O012O00D9000100024O001201025O00202O00020002001F4O000300046O000500033O00202O00050005002800122O0007000E6O0005000700024O000500056O00010005000200062O000100052O013O0004F23O00052O012O00D9000100043O0012C8000200293O0012C80003002A4O00AF000100034O00E100016O00D900015O00208200010001002B0020500001000100042O00D40001000200020006272O0100302O013O0004F23O00302O012O00D900015O00208200010001002C00205000010001000D2O00D4000100020002000651000100302O0100010004F23O00302O012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300254O00010003000200062O000100302O013O0004F23O00302O012O00D90001000A3O0020A000010001002D4O0001000200024O000200013O00202O00020002002E4O00020002000200202O00020002000200062O000100302O0100020004F23O00302O012O00D9000100053O000E24011B00302O0100010004F23O00302O012O00D9000100024O000B00025O00202O00020002002B4O0003000B6O00010003000200062O000100302O013O0004F23O00302O012O00D9000100043O0012C80002002F3O0012C8000300304O00AF000100034O00E100015O0012C83O00313O002606012O0018020100320004F23O001802012O00D900015O0020820001000100330020500001000100122O00D40001000200020006272O0100752O013O0004F23O00752O012O00D9000100053O0026062O0100602O0100340004F23O00602O012O00D900015O00208200010001001100205000010001000D2O00D40001000200020006272O01005A2O013O0004F23O005A2O012O00D9000100013O0020B30001000100354O00035O00202O0003000300234O0001000300024O000200013O00202O00020002002E4O00020002000200202O00020002000200062O0001005A2O0100020004F23O005A2O012O00D9000100013O00200A2O01000100144O00035O00202O0003000300234O00010003000200062O0001005A2O013O0004F23O005A2O012O00D900015O00208200010001001300205000010001000D2O00D40001000200020006272O0100632O013O0004F23O00632O012O00D900015O00208200010001001100205000010001000D2O00D40001000200020006272O0100632O013O0004F23O00632O012O00D9000100083O0026112O0100752O01001B0004F23O00752O012O00D9000100024O00FE00025O00202O0002000200334O0003000C6O000400046O000500033O00202O00050005003600122O000700276O0005000700024O000500056O00010005000200062O000100752O013O0004F23O00752O012O00D9000100043O0012C8000200373O0012C8000300384O00AF000100034O00E100016O00D900015O0020820001000100330020500001000100122O00D40001000200020006272O0100A82O013O0004F23O00A82O012O00D9000100053O000E8B000200A82O0100010004F23O00A82O012O00D900015O00208200010001001100205000010001000D2O00D40001000200020006272O0100A82O013O0004F23O00A82O012O00D9000100013O00200A2O01000100144O00035O00202O0003000300234O00010003000200062O000100A82O013O0004F23O00A82O012O00D9000100013O0020B30001000100354O00035O00202O0003000300234O0001000300024O000200013O00202O00020002002E4O00020002000200202O00020002000200062O000100A82O0100020004F23O00A82O012O00D9000100024O00FE00025O00202O0002000200334O0003000C6O000400046O000500033O00202O00050005003600122O000700276O0005000700024O000500056O00010005000200062O000100A82O013O0004F23O00A82O012O00D9000100043O0012C8000200393O0012C80003003A4O00AF000100034O00E100016O00D900015O0020820001000100330020500001000100122O00D40001000200020006272O01001702013O0004F23O001702012O00D900015O00208200010001001300205000010001000D2O00D40001000200020006272O01001702013O0004F23O001702012O00D900015O00208200010001001100205000010001000D2O00D40001000200020006272O0100C42O013O0004F23O00C42O012O00D9000100013O00200A2O01000100144O00035O00202O0003000300234O00010003000200062O000100C42O013O0004F23O00C42O012O00D90001000D3O0006272O0100DA2O013O0004F23O00DA2O012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300234O00010003000200062O000100D42O013O0004F23O00D42O012O00D90001000D3O0006272O0100D42O013O0004F23O00D42O012O00D900015O00208200010001001100205000010001003B2O00D4000100020002000651000100DA2O0100010004F23O00DA2O012O00D900015O00208200010001001100205000010001000D2O00D400010002000200065100010017020100010004F23O001702012O00D9000100013O00200F0001000100354O00035O00202O0003000300234O0001000300024O000200013O00202O00020002002E4O00020002000200062O000100F52O0100020004F23O00F52O012O00D9000100013O00200A2O01000100144O00035O00202O00030003003C4O00010003000200062O0001001702013O0004F23O001702012O00D9000100013O0020790001000100354O00035O00202O00030003003C4O0001000300024O000200013O00202O00020002002E4O00020002000200062O00010017020100020004F23O001702012O00D9000100033O00200100010001003D4O00035O00202O00030003003E4O00010003000200262O000100050201000E0004F23O000502012O00D90001000E3O00065100010017020100010004F23O001702012O00D900015O00208200010001002C00205000010001000D2O00D400010002000200065100010017020100010004F23O001702012O00D9000100024O00FE00025O00202O0002000200334O0003000C6O000400046O000500033O00202O00050005003600122O000700276O0005000700024O000500056O00010005000200062O0001001702013O0004F23O001702012O00D9000100043O0012C80002003F3O0012C8000300404O00AF000100034O00E100015O0012C83O000E3O000EF8000100D302013O0004F23O00D302012O00D900015O0020820001000100160020500001000100122O00D40001000200020006272O01005402013O0004F23O005402012O00D900015O00208200010001001300205000010001000D2O00D40001000200020006272O01004502013O0004F23O004502012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300154O00010003000200062O0001004502013O0004F23O004502012O00D9000100013O0020500001000100412O00D40001000200020026112O010045020100310004F23O004502012O00D900015O0020820001000100110020500001000100172O00D40001000200020026112O01003E020100420004F23O003E02012O00D9000100063O00065100010048020100010004F23O004802012O00D9000100073O00065100010048020100010004F23O004802012O00D9000100013O0020100001000100144O00035O00202O0003000300234O00010003000200062O00010048020100010004F23O004802012O00D9000100083O0026112O010054020100430004F23O005402012O00D9000100024O000B00025O00202O0002000200164O0003000F6O00010003000200062O0001005402013O0004F23O005402012O00D9000100043O0012C8000200443O0012C8000300454O00AF000100034O00E100016O00D900015O0020820001000100160020500001000100122O00D40001000200020006272O01009502013O0004F23O009502012O00D9000100013O00200A2O01000100144O00035O00202O0003000300254O00010003000200062O0001007202013O0004F23O007202012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300154O00010003000200062O0001007202013O0004F23O007202012O00D9000100103O0020820001000100462O008A0001000100020026112O010072020100470004F23O007202012O00D9000100013O0020500001000100482O00D400010002000200065100010089020100010004F23O008902012O00D9000100013O0020500001000100262O00D40001000200020026112O010095020100490004F23O009502012O00D9000100013O0020500001000100412O00D40001000200020026112O0100950201001B0004F23O009502012O00D900015O0020F100010001002500202O0001000100174O0001000200024O000200113O00062O00020089020100010004F23O008902012O00D900015O00208200010001001600205000010001004A2O00D40001000200020026112O010095020100470004F23O009502012O00D9000100024O000B00025O00202O0002000200164O0003000F6O00010003000200062O0001009502013O0004F23O009502012O00D9000100043O0012C80002004B3O0012C80003004C4O00AF000100034O00E100016O00D900015O0020820001000100160020500001000100122O00D40001000200020006272O0100D202013O0004F23O00D202012O00D900015O00208200010001002500205000010001000D2O00D4000100020002000651000100D2020100010004F23O00D202012O00D900015O00208200010001001300205000010001000D2O00D4000100020002000651000100D2020100010004F23O00D202012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300154O00010003000200062O000100D202013O0004F23O00D202012O00D9000100013O0020500001000100412O00D40001000200020026112O0100D20201000E0004F23O00D202012O00D900015O0020820001000100110020500001000100172O00D400010002000200269D000100C6020100420004F23O00C602012O00D9000100013O0020100001000100144O00035O00202O0003000300234O00010003000200062O000100C6020100010004F23O00C602012O00D900015O00208200010001001100205000010001000D2O00D4000100020002000651000100D2020100010004F23O00D202012O00D9000100024O000B00025O00202O0002000200164O0003000F6O00010003000200062O000100D202013O0004F23O00D202012O00D9000100043O0012C80002004D3O0012C80003004E4O00AF000100034O00E100015O0012C83O00343O000EF80034005503013O0004F23O005503012O00D900015O00208200010001004F0020500001000100122O00D40001000200020006272O01000803013O0004F23O000803012O00D900015O00208200010001001300205000010001000D2O00D40001000200020006272O0100F402013O0004F23O00F402012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300234O00010003000200062O000100F402013O0004F23O00F402012O00D900015O0020820001000100110020500001000100172O00D40001000200020026112O0100F40201001B0004F23O00F402012O00D9000100063O000651000100F7020100010004F23O00F702012O00D9000100073O000651000100F7020100010004F23O00F702012O00D9000100083O0026112O010008030100180004F23O000803012O00D9000100024O001201025O00202O00020002004F4O000300036O000400033O00202O00040004003600122O000600436O0004000600024O000400046O00010004000200062O0001000803013O0004F23O000803012O00D9000100043O0012C8000200503O0012C8000300514O00AF000100034O00E100016O00D900015O00208200010001004F0020500001000100122O00D40001000200020006272O01002B03013O0004F23O002B03012O00D900015O00208200010001002500205000010001000D2O00D40001000200020006272O01002B03013O0004F23O002B03012O00D9000100063O0006510001001A030100010004F23O001A03012O00D9000100073O0006272O01002B03013O0004F23O002B03012O00D9000100024O001201025O00202O00020002004F4O000300036O000400033O00202O00040004003600122O000600436O0004000600024O000400046O00010004000200062O0001002B03013O0004F23O002B03012O00D9000100043O0012C8000200523O0012C8000300534O00AF000100034O00E100016O00D900015O00208200010001004F0020500001000100122O00D40001000200020006272O01005403013O0004F23O005403012O00D900015O00208200010001002500205000010001000D2O00D400010002000200065100010054030100010004F23O005403012O00D900015O00208200010001001300205000010001000D2O00D400010002000200065100010054030100010004F23O005403012O00D9000100063O00065100010043030100010004F23O004303012O00D9000100073O0006272O01005403013O0004F23O005403012O00D9000100024O001201025O00202O00020002004F4O000300036O000400033O00202O00040004003600122O000600436O0004000600024O000400046O00010004000200062O0001005403013O0004F23O005403012O00D9000100043O0012C8000200543O0012C8000300554O00AF000100034O00E100015O0012C83O00023O002606012O00F10301001B0004F23O00F103012O00D900015O0020820001000100110020500001000100122O00D40001000200020006272O01009903013O0004F23O009903012O00D900015O00208200010001002500205000010001000D2O00D40001000200020006272O01009903013O0004F23O009903012O00D9000100063O00065100010069030100010004F23O006903012O00D9000100073O0006272O01009903013O0004F23O009903012O00D900015O00208200010001005600205000010001000D2O00D40001000200020006510001007A030100010004F23O007A03012O00D9000100013O0020500001000100262O00D4000100020002000E890049008D030100010004F23O008D03012O00D900015O0020820001000100250020500001000100172O00D4000100020002000E890027008D030100010004F23O008D03012O00D900015O00208200010001005600205000010001000D2O00D40001000200020006272O01009903013O0004F23O009903012O00D900015O0020820001000100250020500001000100172O00D4000100020002000E890047008D030100010004F23O008D03012O00D9000100013O00200A2O01000100144O00035O00202O0003000300254O00010003000200062O0001009903013O0004F23O009903012O00D9000100024O000B00025O00202O0002000200114O000300096O00010003000200062O0001009903013O0004F23O009903012O00D9000100043O0012C8000200573O0012C8000300584O00AF000100034O00E100016O00D900015O0020820001000100110020500001000100122O00D40001000200020006272O0100C303013O0004F23O00C303012O00D900015O00208200010001005600205000010001000D2O00D40001000200020006272O0100C303013O0004F23O00C303012O00D900015O00208200010001001300205000010001000D2O00D4000100020002000651000100C3030100010004F23O00C303012O00D900015O00208200010001002500205000010001000D2O00D4000100020002000651000100C3030100010004F23O00C303012O00D9000100063O000651000100B7030100010004F23O00B703012O00D9000100073O0006272O0100C303013O0004F23O00C303012O00D9000100024O000B00025O00202O0002000200114O000300096O00010003000200062O000100C303013O0004F23O00C303012O00D9000100043O0012C8000200593O0012C80003005A4O00AF000100034O00E100016O00D900015O0020820001000100250020500001000100042O00D40001000200020006272O0100F003013O0004F23O00F003012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300254O00010003000200062O000100DB03013O0004F23O00DB03012O00D9000100013O0020500001000100262O00D4000100020002000E24015B00DB030100010004F23O00DB03012O00D9000100063O000651000100DE030100010004F23O00DE03012O00D9000100073O000651000100DE030100010004F23O00DE03012O00D9000100083O0026112O0100F00301005C0004F23O00F003012O00D9000100024O00FE00025O00202O0002000200254O000300126O000400046O000500033O00202O00050005003600122O000700186O0005000700024O000500056O00010005000200062O000100F003013O0004F23O00F003012O00D9000100043O0012C80002005D3O0012C80003005E4O00AF000100034O00E100015O0012C83O00323O002606012O0001000100310004F23O000100012O00D900015O00208200010001005F0020500001000100042O00D40001000200020006272O01004204013O0004F23O004204012O00D9000100013O00200A2O010001000A4O00035O00202O00030003000B4O00010003000200062O0001004204013O0004F23O004204012O00D9000100063O0006272O01004204013O0004F23O004204012O00D9000100013O00200A2O01000100144O00035O00202O0003000300234O00010003000200062O0001001804013O0004F23O001804012O00D9000100013O0020F70001000100354O00035O00202O0003000300234O000100030002000E2O000E0018040100010004F23O001804012O00D9000100013O0020142O01000100354O00035O00202O0003000300234O00010003000200262O00010028040100600004F23O002804012O00D9000100013O00200A2O010001000A4O00035O00202O0003000300234O00010003000200062O0001002504013O0004F23O002504012O00D900015O0020820001000100110020500001000100172O00D4000100020002000E8900470028040100010004F23O002804012O00D9000100083O0026112O010042040100600004F23O004204012O00D9000100053O000E89000E0034040100010004F23O003404012O00D900015O00208200010001000C00205000010001000D2O00D40001000200020006272O01004204013O0004F23O004204012O00D9000100053O000E8B00020042040100010004F23O004204012O00D9000100024O000B000200133O00202O0002000200614O000300146O00010003000200062O0001004204013O0004F23O004204012O00D9000100043O001231000200623O00122O000300636O000100036O00015O00044O004204010004F23O000100012O00ED3O00017O003A3O00028O00026O00F03F030E3O00476C616369616C416476616E636503073O0049735265616479027O0040030C3O004F626C697465726174696F6E030B3O004973417661696C61626C6503123O004272656174686F6653696E647261676F736103083O0042752O66446F776E03113O0050692O6C61726F6646726F737442752O66030F3O00432O6F6C646F776E52656D61696E7303093O004973496E52616E6765026O00594003233O00E2155480160C2361E41D4382110E2A1EED10528B201D3D57EA2654800B042050F6590D03083O003E857935E37F6D4F03243O00171833F6DFAFAE2F1536E3D7A0A115543AFCD1A69D00063BFAE9AFA1041D3DFBC5EEF34003073O00C270745295B6CE026O00104003113O0052656D6F7273656C652O7357696E746572030E3O004973496E4D656C2O6552616E6765026O00204003273O002BAD4117D2F10B35AD5F0BFFF50737BC490A80EA073EA07308D2EB0106A94F0CC9ED002AE81E4803073O006E59C82C78A082026O00084003273O00B9C6464951593E41AED0587954433559AED10B4E4A4D3372BBD142497C4B3859A2CC455503186903083O002DCBA32B26232A5B030E3O00416E74694D616769635368652O6C030A3O0049734361737461626C6503113O0052756E6963506F77657244656669636974026O00444003233O00D38BC82A8AA853DB86E3308FAC58DEC5D42A80A16BC297D52CB8A857C68CD32D94E90603073O0034B2E5BC43E7C9030D3O00416E74694D616769635A6F6E65025O00805140030C3O00412O73696D696C6174696F6E03063O0042752O66557003113O00456D706F77657252756E65576561706F6E03073O004368617267657303223O00204F440DFA5D2428426F1EF8522661495903FF632O33485F3BF65F37284E5E17B70803073O004341213064973C030C3O00486F776C696E67426C617374030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O66030D3O0050692O6C61726F6646726F7374030C3O00432O6F6C646F776E446F776E03123O004B692O6C696E674D616368696E6542752O66030E3O0049735370652O6C496E52616E676503213O00D7E8B9D4FAD1E091DAFFDEF4BA98FBD6E0A6E7E3CDEEA1E7F2DCF3A7D7FDCCA7F803053O0093BF87CEB803243O008324A7C2D152BEBB29A2D7D95DB18168AEC8DF5B8D943AAFCEE752B19021A9CFCB13E3D603073O00D2E448C6A1B833030B3O0046726F7374537472696B6503213O00305BFC0367F1255DE11978CB7641FA177BF1265BFA1F4CCF355DFA1F7DDD7618A703063O00AE562993701303213O005D128218313002BF4909860E650718AC533F9D192C002EAA581484042B1C51FA0D03083O00CB3B60ED6B456F7103213O002204A3F225CFC43004A5EA34B0DF2D11A4DE21E2DE2B29ADE225F9D82A05ECB06903073O00B74476CC8151900037022O0012C83O00013O002606012O0073000100020004F23O007300012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01004100013O0004F23O004100012O00D9000100013O000E8B00050041000100010004F23O004100012O00D9000100023O0006272O01004100013O0004F23O004100012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O01004100013O0004F23O004100012O00D900015O0020820001000100080020500001000100072O00D40001000200020006272O01004100013O0004F23O004100012O00D9000100033O00200A2O01000100094O00035O00202O00030003000A4O00010003000200062O0001004100013O0004F23O004100012O00D9000100033O00200A2O01000100094O00035O00202O0003000300084O00010003000200062O0001004100013O0004F23O004100012O00D900015O00209300010001000800202O00010001000B4O0001000200024O000200043O00062O00020041000100010004F23O004100012O00D9000100054O001201025O00202O0002000200034O000300046O000500063O00202O00050005000C00122O0007000D6O0005000700024O000500056O00010005000200062O0001004100013O0004F23O004100012O00D9000100073O0012C80002000E3O0012C80003000F4O00AF000100034O00E100016O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01007200013O0004F23O007200012O00D9000100013O000E8B00050072000100010004F23O007200012O00D9000100023O0006272O01007200013O0004F23O007200012O00D900015O0020820001000100080020500001000100072O00D40001000200020006272O01007200013O0004F23O007200012O00D9000100033O00200A2O01000100094O00035O00202O0003000300084O00010003000200062O0001007200013O0004F23O007200012O00D900015O00209300010001000800202O00010001000B4O0001000200024O000200043O00062O00020072000100010004F23O007200012O00D9000100054O001201025O00202O0002000200034O000300046O000500063O00202O00050005000C00122O0007000D6O0005000700024O000500056O00010005000200062O0001007200013O0004F23O007200012O00D9000100073O0012C8000200103O0012C8000300114O00AF000100034O00E100015O0012C83O00053O002606012O00BF000100120004F23O00BF00012O00D900015O0020820001000100130020500001000100042O00D40001000200020006272O01009B00013O0004F23O009B00012O00D900015O0020820001000100080020500001000100072O00D40001000200020006510001009B000100010004F23O009B00012O00D900015O0020820001000100060020500001000100072O00D40001000200020006510001009B000100010004F23O009B00012O00D9000100083O0006272O01009B00013O0004F23O009B00012O00D9000100054O001201025O00202O0002000200134O000300046O000500063O00202O00050005001400122O000700156O0005000700024O000500056O00010005000200062O0001009B00013O0004F23O009B00012O00D9000100073O0012C8000200163O0012C8000300174O00AF000100034O00E100016O00D900015O0020820001000100130020500001000100042O00D40001000200020006272O01003602013O0004F23O003602012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O01003602013O0004F23O003602012O00D9000100013O000E8B00180036020100010004F23O003602012O00D9000100093O0006272O01003602013O0004F23O003602012O00D9000100054O001201025O00202O0002000200134O000300046O000500063O00202O00050005001400122O000700156O0005000700024O000500056O00010005000200062O0001003602013O0004F23O003602012O00D9000100073O001231000200193O00122O0003001A6O000100036O00015O00044O00360201000EF80001005D2O013O0004F23O005D2O012O00D90001000A3O0006272O01001A2O013O0004F23O001A2O012O00D90001000B3O0006272O01001A2O013O0004F23O001A2O010012C8000100013O0026062O0100C8000100010004F23O00C800012O00D900025O00208200020002001B00205000020002001C2O00D4000200020002000627010200E100013O0004F23O00E100012O00D9000200033O00205000020002001D2O00D4000200020002000E24011E00E1000100020004F23O00E100012O00D9000200054O000B00035O00202O00030003001B4O0004000C6O00020004000200062O000200E100013O0004F23O00E100012O00D9000200073O0012C80003001F3O0012C8000400204O00AF000200044O00E100026O00D900025O00208200020002002100205000020002001C2O00D40002000200020006270102001A2O013O0004F23O001A2O012O00D9000200033O00205000020002001D2O00D4000200020002000E240122001A2O0100020004F23O001A2O012O00D900025O0020820002000200230020500002000200072O00D40002000200020006270102001A2O013O0004F23O001A2O012O00D9000200033O00200A0102000200244O00045O00202O0004000400084O00020004000200062O000200FF00013O0004F23O00FF00012O00D900025O0020820002000200250020500002000200262O00D400020002000200269D0002000C2O0100050004F23O000C2O012O00D900025O0020820002000200080020500002000200072O00D40002000200020006510002001A2O0100010004F23O001A2O012O00D9000200033O00200A0102000200094O00045O00202O00040004000A4O00020004000200062O0002001A2O013O0004F23O001A2O012O00D9000200054O000B00035O00202O0003000300214O0004000D6O00020004000200062O0002001A2O013O0004F23O001A2O012O00D9000200073O001231000300273O00122O000400286O000200046O00025O00044O001A2O010004F23O00C800012O00D900015O0020820001000100290020500001000100042O00D40001000200020006272O01005C2O013O0004F23O005C2O012O00D9000100063O00200A2O010001002A4O00035O00202O00030003002B4O00010003000200062O0001005C2O013O0004F23O005C2O012O00D9000100013O000E8B0005005C2O0100010004F23O005C2O012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O01004A2O013O0004F23O004A2O012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O01005C2O013O0004F23O005C2O012O00D900015O00208200010001002C00205000010001002D2O00D40001000200020006510001004A2O0100010004F23O004A2O012O00D9000100033O00200A2O01000100244O00035O00202O00030003000A4O00010003000200062O0001005C2O013O0004F23O005C2O012O00D9000100033O00200A2O01000100094O00035O00202O00030003002E4O00010003000200062O0001005C2O013O0004F23O005C2O012O00D9000100054O00D800025O00202O0002000200294O000300046O000500063O00202O00050005002F4O00075O00202O0007000700294O0005000700024O000500056O00010005000200062O0001005C2O013O0004F23O005C2O012O00D9000100073O0012C8000200303O0012C8000300314O00AF000100034O00E100015O0012C83O00023O002606012O00CF2O0100050004F23O00CF2O012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O01008F2O013O0004F23O008F2O012O00D9000100013O000E8B0005008F2O0100010004F23O008F2O012O00D9000100023O0006272O01008F2O013O0004F23O008F2O012O00D900015O0020820001000100080020500001000100072O00D40001000200020006510001008F2O0100010004F23O008F2O012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O01008F2O013O0004F23O008F2O012O00D9000100033O00200A2O01000100094O00035O00202O00030003000A4O00010003000200062O0001008F2O013O0004F23O008F2O012O00D9000100054O001201025O00202O0002000200034O000300046O000500063O00202O00050005000C00122O0007000D6O0005000700024O000500056O00010005000200062O0001008F2O013O0004F23O008F2O012O00D9000100073O0012C8000200323O0012C8000300334O00AF000100034O00E100016O00D900015O0020820001000100340020500001000100042O00D40001000200020006272O0100CE2O013O0004F23O00CE2O012O00D9000100013O0026062O0100CE2O0100020004F23O00CE2O012O00D9000100023O0006272O0100CE2O013O0004F23O00CE2O012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O0100CE2O013O0004F23O00CE2O012O00D900015O0020820001000100080020500001000100072O00D40001000200020006272O0100CE2O013O0004F23O00CE2O012O00D9000100033O00200A2O01000100094O00035O00202O00030003000A4O00010003000200062O000100CE2O013O0004F23O00CE2O012O00D9000100033O00200A2O01000100094O00035O00202O0003000300084O00010003000200062O000100CE2O013O0004F23O00CE2O012O00D900015O00209300010001000800202O00010001000B4O0001000200024O000200043O00062O000200CE2O0100010004F23O00CE2O012O00D9000100054O00D800025O00202O0002000200344O000300046O000500063O00202O00050005002F4O00075O00202O0007000700344O0005000700024O000500056O00010005000200062O000100CE2O013O0004F23O00CE2O012O00D9000100073O0012C8000200353O0012C8000300364O00AF000100034O00E100015O0012C83O00183O002606012O0001000100180004F23O000100012O00D900015O0020820001000100340020500001000100042O00D40001000200020006272O01000302013O0004F23O000302012O00D9000100013O0026062O010003020100020004F23O000302012O00D9000100023O0006272O01000302013O0004F23O000302012O00D900015O0020820001000100080020500001000100072O00D40001000200020006272O01000302013O0004F23O000302012O00D9000100033O00200A2O01000100094O00035O00202O0003000300084O00010003000200062O0001000302013O0004F23O000302012O00D900015O00209300010001000800202O00010001000B4O0001000200024O000200043O00062O00020003020100010004F23O000302012O00D9000100054O00D800025O00202O0002000200344O000300046O000500063O00202O00050005002F4O00075O00202O0007000700344O0005000700024O000500056O00010005000200062O0001000302013O0004F23O000302012O00D9000100073O0012C8000200373O0012C8000300384O00AF000100034O00E100016O00D900015O0020820001000100340020500001000100042O00D40001000200020006272O01003402013O0004F23O003402012O00D9000100013O0026062O010034020100020004F23O003402012O00D9000100023O0006272O01003402013O0004F23O003402012O00D900015O0020820001000100080020500001000100072O00D400010002000200065100010034020100010004F23O003402012O00D900015O0020820001000100060020500001000100072O00D40001000200020006272O01003402013O0004F23O003402012O00D9000100033O00200A2O01000100094O00035O00202O00030003000A4O00010003000200062O0001003402013O0004F23O003402012O00D9000100054O00D800025O00202O0002000200344O000300046O000500063O00202O00050005002F4O00075O00202O0007000700344O0005000700024O000500056O00010005000200062O0001003402013O0004F23O003402012O00D9000100073O0012C8000200393O0012C80003003A4O00AF000100034O00E100015O0012C83O00123O0004F23O000100012O00ED3O00017O00553O00028O0003113O0052656D6F7273656C652O7357696E74657203073O0049735265616479026O000840030E3O00476174686572696E6753746F726D030B3O004973417661696C61626C65030E3O004973496E4D656C2O6552616E6765026O00204003213O001CA87DEB19910BA175F718BD19A47EF00E904EA272E802960BBF71F0028D00ED2203063O00E26ECD10846B030C3O00486F776C696E67426C61737403093O0042752O66537461636B03123O004B692O6C696E674D616368696E6542752O66027O0040030B3O0042752O6652656D61696E7303113O0050692O6C61726F6646726F737442752O662O033O0047434403063O0042752O66557003083O0052696D6542752O66030E3O0049735370652O6C496E52616E6765031C3O00E3CCF7D548E5C4DFDB4DEAD0F4994EE9CFE9CD44F9C2F4D04EE583B403053O00218BA380B9030B3O0046726F7374537472696B6503083O0042752O66446F776E03113O004465617468416E64446563617942752O66026O001440031B3O00514A0BCD436717CA45510FDB175706D25E4C01CC564C0DD159185203043O00BE373864030E3O00476C616369616C416476616E636503093O004973496E52616E6765026O005940031E3O0051A33D1D1AE2FF69AE380812EDF053EF331C1FEAE753BD3D0A1AECFD16F703073O009336CF5C7E7383026O00F03F026O001040031D3O00053E227104700A0E37710C6D19713A7F01771934277C1977023F752E5903063O001E6D51551D6D030A3O004F626C69746572617465030C3O004361737454617267657449662O033O00F2704C03073O009C9F1134D656BE031A3O00A1EDB1B5BAEAAFBDBAEAFDB3ACE3B4A8ABFDBCA8A7E0B3FCFDB903043O00DCCE8FDD030A3O0052756E6963506F776572026O003940031D3O008E723A1BD1C2D5B97F2116CBD892897F211ECCC9C087692418D68C80D003073O00B2E61D4D77B8AC030D3O00417263616E65546F2O72656E7403043O0052756E65031E3O00F4AC091A79FDCAAA050965FDFBAA4A1475F4FCAA0F0976ECFCB1045B25A003063O009895DE6A7B17031F3O00DA2AF740BCDC2AC942B1CB27F840B09D29F44FBCC923E442A1D429F803E68D03053O00D5BD4696232O033O0042546C03043O00682F3514031C3O00A55E8E0FA830B0589315B70AE3438310B51BA65E8008B500AD0CD24E03063O006FC32CE17CDC030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66030F3O005368612O746572696E67426C616465031C3O00DE540F60BF94CB52127AA0AE9849027FA2BFDD540167A2A4D606512B03063O00CBB8266013CB031D3O00317C6E4DC737744643C238606D01C13B7F7055CB2B726D48C137332B1103053O00AE59131921031F3O00281E534DFE860710135658F689082A525D4CFB8E1F2A00535AFE88056F400003073O006B4F72322E97E7031C3O003FB4BA3A9E06A4D42BAFBE2CCA36B5CC30B2B03B8B2DBECF37E6E77D03083O00A059C6D549EA59D72O033O004570AC03053O00A52811D49E031A3O00EADB043A32E0CB092723A5D60A3F2FF1DC1A2O32ECD6067377B503053O004685B96853030B3O0046726F7374736379746865031B3O0002574B39DD17465D3EC101054B28C50D514138C8104C4B2489551703053O00A96425244A030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O6603073O0048617354696572026O003E40031D3O000888B55C0989A56F028BA34314C7AD520C8EB6551286B6590F89E2015403043O003060E7C203093O004176616C616E636865030D3O00446562752O6652656D61696E73031F3O00CF560F2E10D9A3BCC95E182C17DBAAC3C75802240DDDBD82DC5301235989F903083O00E3A83A6E4D79B8CF00FF022O0012C83O00013O002606012O00B3000100010004F23O00B300012O00D900015O0020820001000100020020500001000100032O00D40001000200020006272O01002300013O0004F23O002300012O00D9000100013O000E8900040012000100010004F23O001200012O00D900015O0020820001000100050020500001000100062O00D40001000200020006272O01002300013O0004F23O002300012O00D9000100024O001201025O00202O0002000200024O000300046O000500033O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002300013O0004F23O002300012O00D9000100043O0012C8000200093O0012C80003000A4O00AF000100034O00E100016O00D900015O00208200010001000B0020500001000100032O00D40001000200020006272O01005300013O0004F23O005300012O00D9000100053O00204600010001000C4O00035O00202O00030003000D4O00010003000200262O000100530001000E0004F23O005300012O00D9000100053O00207900010001000F4O00035O00202O0003000300104O0001000300024O000200053O00202O0002000200114O00020002000200062O00010053000100020004F23O005300012O00D9000100053O00200A2O01000100124O00035O00202O0003000300134O00010003000200062O0001005300013O0004F23O005300012O00D9000100024O00D800025O00202O00020002000B4O000300046O000500033O00202O0005000500144O00075O00202O00070007000B4O0005000700024O000500056O00010005000200062O0001005300013O0004F23O005300012O00D9000100043O0012C8000200153O0012C8000300164O00AF000100034O00E100016O00D900015O0020820001000100170020500001000100032O00D40001000200020006272O01008300013O0004F23O008300012O00D9000100053O00204600010001000C4O00035O00202O00030003000D4O00010003000200262O000100830001000E0004F23O008300012O00D9000100053O00207900010001000F4O00035O00202O0003000300104O0001000300024O000200053O00202O0002000200114O00020002000200062O00010083000100020004F23O008300012O00D9000100053O00200A2O01000100184O00035O00202O0003000300194O00010003000200062O0001008300013O0004F23O008300012O00D9000100024O00FE00025O00202O0002000200174O000300066O000400046O000500033O00202O00050005000700122O0007001A6O0005000700024O000500056O00010005000200062O0001008300013O0004F23O008300012O00D9000100043O0012C80002001B3O0012C80003001C4O00AF000100034O00E100016O00D900015O00208200010001001D0020500001000100032O00D40001000200020006272O0100B200013O0004F23O00B200012O00D9000100053O00204600010001000C4O00035O00202O00030003000D4O00010003000200262O000100B20001000E0004F23O00B200012O00D9000100053O00207900010001000F4O00035O00202O0003000300104O0001000300024O000200053O00202O0002000200114O00020002000200062O000100B2000100020004F23O00B200012O00D9000100053O00200A2O01000100184O00035O00202O0003000300194O00010003000200062O000100B200013O0004F23O00B200012O00D9000100024O001201025O00202O00020002001D4O000300046O000500033O00202O00050005001E00122O0007001F6O0005000700024O000500056O00010005000200062O000100B200013O0004F23O00B200012O00D9000100043O0012C8000200203O0012C8000300214O00AF000100034O00E100015O0012C83O00223O002606012O00F3000100230004F23O00F300012O00D900015O00208200010001000B0020500001000100032O00D40001000200020006272O0100D400013O0004F23O00D400012O00D9000100053O00200A2O01000100124O00035O00202O0003000300134O00010003000200062O000100D400013O0004F23O00D400012O00D9000100024O00D800025O00202O00020002000B4O000300046O000500033O00202O0005000500144O00075O00202O00070007000B4O0005000700024O000500056O00010005000200062O000100D400013O0004F23O00D400012O00D9000100043O0012C8000200243O0012C8000300254O00AF000100034O00E100016O00D900015O0020820001000100260020500001000100032O00D40001000200020006272O0100FE02013O0004F23O00FE02012O00D9000100073O0020490001000100274O00025O00202O0002000200264O000300086O000400043O00122O000500283O00122O000600296O0004000600024O000500096O000600066O000700033O00202O00070007000700122O0009001A6O0007000900024O000700076O00010007000200062O000100FE02013O0004F23O00FE02012O00D9000100043O0012310002002A3O00122O0003002B6O000100036O00015O00044O00FE0201002606012O00802O0100040004F23O00802O012O00D900015O00208200010001000B0020500001000100032O00D40001000200020006272O0100192O013O0004F23O00192O012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O000100192O013O0004F23O00192O012O00D9000100053O00205000010001002C2O00D40001000200020026112O0100192O01002D0004F23O00192O012O00D9000100024O00D800025O00202O00020002000B4O000300046O000500033O00202O0005000500144O00075O00202O00070007000B4O0005000700024O000500056O00010005000200062O000100192O013O0004F23O00192O012O00D9000100043O0012C80002002E3O0012C80003002F4O00AF000100034O00E100016O00D90001000A3O0006272O0100382O013O0004F23O00382O012O00D900015O0020820001000100300020500001000100032O00D40001000200020006272O0100382O013O0004F23O00382O012O00D9000100053O0020500001000100312O00D40001000200020026112O0100382O0100220004F23O00382O012O00D9000100053O00205000010001002C2O00D40001000200020026112O0100382O01002D0004F23O00382O012O00D9000100024O000B00025O00202O0002000200304O0003000B6O00010003000200062O000100382O013O0004F23O00382O012O00D9000100043O0012C8000200323O0012C8000300334O00AF000100034O00E100016O00D900015O00208200010001001D0020500001000100032O00D40001000200020006272O0100552O013O0004F23O00552O012O00D90001000C3O000651000100552O0100010004F23O00552O012O00D9000100013O000E8B000E00552O0100010004F23O00552O012O00D9000100024O001201025O00202O00020002001D4O000300046O000500033O00202O00050005001E00122O0007001F6O0005000700024O000500056O00010005000200062O000100552O013O0004F23O00552O012O00D9000100043O0012C8000200343O0012C8000300354O00AF000100034O00E100016O00D900015O0020820001000100170020500001000100032O00D40001000200020006272O01007F2O013O0004F23O007F2O012O00D90001000C3O0006510001007F2O0100010004F23O007F2O012O00D900015O00208200010001001D0020500001000100062O00D40001000200020006272O0100672O013O0004F23O00672O012O00D9000100013O0026062O01007F2O0100220004F23O007F2O012O00D9000100073O0020490001000100274O00025O00202O0002000200174O000300086O000400043O00122O000500363O00122O000600376O0004000600024O000500096O000600066O000700033O00202O00070007000700122O0009001A6O0007000900024O000700076O00010007000200062O0001007F2O013O0004F23O007F2O012O00D9000100043O0012C8000200383O0012C8000300394O00AF000100034O00E100015O0012C83O00233O002606012O003B0201000E0004F23O003B02012O00D900015O0020820001000100170020500001000100032O00D40001000200020006272O0100C22O013O0004F23O00C22O012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O000100C22O013O0004F23O00C22O012O00D9000100053O0020500001000100312O00D400010002000200269D000100A42O01000E0004F23O00A42O012O00D90001000D3O000651000100A42O0100010004F23O00A42O012O00D9000100033O00207E00010001003A4O00035O00202O00030003003B4O00010003000200262O000100C22O01001A0004F23O00C22O012O00D900015O00208200010001003C0020500001000100062O00D40001000200020006272O0100C22O013O0004F23O00C22O012O00D90001000C3O000651000100C22O0100010004F23O00C22O012O00D900015O00208200010001001D0020500001000100062O00D40001000200020006272O0100B02O013O0004F23O00B02O012O00D9000100013O0026062O0100C22O0100220004F23O00C22O012O00D9000100024O00FE00025O00202O0002000200174O000300066O000400046O000500033O00202O00050005000700122O0007001A6O0005000700024O000500056O00010005000200062O000100C22O013O0004F23O00C22O012O00D9000100043O0012C80002003D3O0012C80003003E4O00AF000100034O00E100016O00D900015O00208200010001000B0020500001000100032O00D40001000200020006272O0100E82O013O0004F23O00E82O012O00D9000100053O00200A2O01000100124O00035O00202O0003000300134O00010003000200062O000100E82O013O0004F23O00E82O012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O000100E82O013O0004F23O00E82O012O00D9000100024O00D800025O00202O00020002000B4O000300046O000500033O00202O0005000500144O00075O00202O00070007000B4O0005000700024O000500056O00010005000200062O000100E82O013O0004F23O00E82O012O00D9000100043O0012C80002003F3O0012C8000300404O00AF000100034O00E100016O00D900015O00208200010001001D0020500001000100032O00D40001000200020006272O01000F02013O0004F23O000F02012O00D90001000C3O0006510001000F020100010004F23O000F02012O00D90001000D3O0006272O01000F02013O0004F23O000F02012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O0001000F02013O0004F23O000F02012O00D9000100013O000E8B000E000F020100010004F23O000F02012O00D9000100024O001201025O00202O00020002001D4O000300046O000500033O00202O00050005001E00122O0007001F6O0005000700024O000500056O00010005000200062O0001000F02013O0004F23O000F02012O00D9000100043O0012C8000200413O0012C8000300424O00AF000100034O00E100016O00D900015O0020820001000100170020500001000100032O00D40001000200020006272O01003A02013O0004F23O003A02012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O0001003A02013O0004F23O003A02012O00D90001000C3O0006510001003A020100010004F23O003A02012O00D900015O00208200010001001D0020500001000100062O00D40001000200020006272O01002802013O0004F23O002802012O00D9000100013O0026062O01003A020100220004F23O003A02012O00D9000100024O00FE00025O00202O0002000200174O000300066O000400046O000500033O00202O00050005000700122O0007001A6O0005000700024O000500056O00010005000200062O0001003A02013O0004F23O003A02012O00D9000100043O0012C8000200433O0012C8000300444O00AF000100034O00E100015O0012C83O00043O002606012O0001000100220004F23O000100012O00D900015O0020820001000100260020500001000100032O00D40001000200020006272O01006502013O0004F23O006502012O00D9000100053O00200A2O01000100124O00035O00202O00030003000D4O00010003000200062O0001006502013O0004F23O006502012O00D90001000E3O00065100010065020100010004F23O006502012O00D9000100073O0020490001000100274O00025O00202O0002000200264O000300086O000400043O00122O000500453O00122O000600466O0004000600024O000500096O000600066O000700033O00202O00070007000700122O0009001A6O0007000900024O000700076O00010007000200062O0001006502013O0004F23O006502012O00D9000100043O0012C8000200473O0012C8000300484O00AF000100034O00E100016O00D900015O0020820001000100490020500001000100032O00D40001000200020006272O01008602013O0004F23O008602012O00D9000100053O00200A2O01000100124O00035O00202O00030003000D4O00010003000200062O0001008602013O0004F23O008602012O00D90001000E3O0006272O01008602013O0004F23O008602012O00D9000100024O001201025O00202O0002000200494O000300046O000500033O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001008602013O0004F23O008602012O00D9000100043O0012C80002004A3O0012C80003004B4O00AF000100034O00E100016O00D900015O00208200010001000B0020500001000100032O00D40001000200020006272O0100BD02013O0004F23O00BD02012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O000100BD02013O0004F23O00BD02012O00D9000100033O00201000010001004C4O00035O00202O00030003004D4O00010003000200062O000100AB020100010004F23O00AB02012O00D9000100053O00200A2O01000100124O00035O00202O0003000300134O00010003000200062O000100BD02013O0004F23O00BD02012O00D9000100053O0020A800010001004E00122O0003004F3O00122O0004000E6O00010004000200062O000100BD02013O0004F23O00BD02012O00D90001000D3O000651000100BD020100010004F23O00BD02012O00D9000100024O00D800025O00202O00020002000B4O000300046O000500033O00202O0005000500144O00075O00202O00070007000B4O0005000700024O000500056O00010005000200062O000100BD02013O0004F23O00BD02012O00D9000100043O0012C8000200503O0012C8000300514O00AF000100034O00E100016O00D900015O00208200010001001D0020500001000100032O00D40001000200020006272O0100FC02013O0004F23O00FC02012O00D9000100053O00200A2O01000100184O00035O00202O00030003000D4O00010003000200062O000100FC02013O0004F23O00FC02012O00D90001000F3O000651000100E5020100010004F23O00E502012O00D900015O0020820001000100520020500001000100062O00D40001000200020006272O0100EB02013O0004F23O00EB02012O00D9000100033O0020142O010001003A4O00035O00202O00030003003B4O00010003000200262O000100EB0201001A0004F23O00EB02012O00D9000100033O0020162O01000100534O00035O00202O00030003003B4O0001000300024O000200053O00202O0002000200114O00020002000200202O00020002000400062O000100EB020100020004F23O00EB02012O00D90001000D3O0006272O0100FC02013O0004F23O00FC02012O00D9000100103O000E24012200FC020100010004F23O00FC02012O00D9000100024O001201025O00202O00020002001D4O000300046O000500033O00202O00050005001E00122O0007001F6O0005000700024O000500056O00010005000200062O000100FC02013O0004F23O00FC02012O00D9000100043O0012C8000200543O0012C8000300554O00AF000100034O00E100015O0012C83O000E3O0004F23O000100012O00ED3O00017O00283O00028O00026O00F03F030B3O004261676F66547269636B73030A3O0049734361737461626C65030C3O004F626C697465726174696F6E030B3O004973417661696C61626C6503063O0042752O66557003113O0050692O6C61726F6646726F737442752O6603123O00556E686F6C79537472656E67746842752O66030B3O0042752O6652656D61696E732O033O00474344026O00084003093O004973496E52616E6765026O00444003183O00793DB87FBEDD4EB16935BC4BA29B63A47835BE4CA29B20F303083O00C51B5CDF20D1BB1103093O00426C2O6F644675727903143O000153CCF40760C5EE114683E9025CCAFA0F4C83A903043O009B633FA3030A3O004265727365726B696E6703143O0080D4B39EBC9689D8AF8AF99683D2A88CB597C28503063O00E4E2B1C1EDD9030B3O00417263616E6550756C7365026O00204003163O0035A220E73AB51CF621BC30E374A222E53DB12FF574E603043O008654D043030E3O004C69676874734A7564676D656E74030E3O0049735370652O6C496E52616E676503193O001FA5815407BFB95606A8815116A2921C01AD855512A0951C4B03043O003C73CCE6027O0040030D3O00416E6365737472616C43612O6C03193O00E634E875F42EF971EB05E871EB36AB62E639E271EB29AB21B703043O0010875A8B03093O0046697265626C2O6F6403143O00527D14364C58775B7046214F5771557815731F0603073O0018341466532E3403083O0042752O66446F776E03183O00C62E261B00C210353606C72432641DC52C282503D76F2O7003053O006FA44F414400FE3O0012C83O00013O002606012O0046000100020004F23O004600012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100FD00013O0004F23O00FD00012O00D900015O0020820001000100050020500001000100062O00D4000100020002000651000100FD000100010004F23O00FD00012O00D9000100013O00200A2O01000100074O00035O00202O0003000300084O00010003000200062O000100FD00013O0004F23O00FD00012O00D9000100013O00200A2O01000100074O00035O00202O0003000300094O00010003000200062O0001002800013O0004F23O002800012O00D9000100013O0020162O010001000A4O00035O00202O0003000300094O0001000300024O000200013O00202O00020002000B4O00020002000200202O00020002000C00062O00010033000100020004F23O003300012O00D9000100013O0020B300010001000A4O00035O00202O0003000300084O0001000300024O000200013O00202O00020002000B4O00020002000200202O00020002000C00062O000100FD000100020004F23O00FD00012O00D9000100024O00FE00025O00202O0002000200034O000300036O000400046O000500043O00202O00050005000D00122O0007000E6O0005000700024O000500056O00010005000200062O000100FD00013O0004F23O00FD00012O00D9000100053O0012310002000F3O00122O000300106O000100036O00015O00044O00FD0001002606012O0001000100010004F23O000100012O00D9000100063O0006272O0100CF00013O0004F23O00CF00010012C8000100013O000EF800010073000100010004F23O007300012O00D900025O0020820002000200110020500002000200042O00D40002000200020006270102006000013O0004F23O006000012O00D9000200024O000B00035O00202O0003000300114O000400036O00020004000200062O0002006000013O0004F23O006000012O00D9000200053O0012C8000300123O0012C8000400134O00AF000200044O00E100026O00D900025O0020820002000200140020500002000200042O00D40002000200020006270102007200013O0004F23O007200012O00D9000200024O000B00035O00202O0003000300144O000400036O00020004000200062O0002007200013O0004F23O007200012O00D9000200053O0012C8000300153O0012C8000400164O00AF000200044O00E100025O0012C8000100023O0026062O0100A7000100020004F23O00A700012O00D900025O0020820002000200170020500002000200042O00D40002000200020006270102008D00013O0004F23O008D00012O00D9000200024O00FE00035O00202O0003000300174O000400036O000500056O000600043O00202O00060006000D00122O000800186O0006000800024O000600066O00020006000200062O0002008D00013O0004F23O008D00012O00D9000200053O0012C8000300193O0012C80004001A4O00AF000200044O00E100026O00D900025O00208200020002001B0020500002000200042O00D4000200020002000627010200A600013O0004F23O00A600012O00D9000200024O006600035O00202O00030003001B4O000400036O000500056O000600043O00202O00060006001C4O00085O00202O00080008001B4O0006000800024O000600066O00020006000200062O000200A600013O0004F23O00A600012O00D9000200053O0012C80003001D3O0012C80004001E4O00AF000200044O00E100025O0012C80001001F3O0026062O01004C0001001F0004F23O004C00012O00D900025O0020820002000200200020500002000200042O00D4000200020002000627010200BB00013O0004F23O00BB00012O00D9000200024O000B00035O00202O0003000300204O000400036O00020004000200062O000200BB00013O0004F23O00BB00012O00D9000200053O0012C8000300213O0012C8000400224O00AF000200044O00E100026O00D900025O0020820002000200230020500002000200042O00D4000200020002000627010200CF00013O0004F23O00CF00012O00D9000200024O000B00035O00202O0003000300234O000400036O00020004000200062O000200CF00013O0004F23O00CF00012O00D9000200053O001231000300243O00122O000400256O000200046O00025O00044O00CF00010004F23O004C00012O00D900015O0020820001000100030020500001000100042O00D40001000200020006272O0100FB00013O0004F23O00FB00012O00D900015O0020820001000100050020500001000100062O00D40001000200020006272O0100FB00013O0004F23O00FB00012O00D9000100013O00200A2O01000100264O00035O00202O0003000300084O00010003000200062O000100FB00013O0004F23O00FB00012O00D9000100013O00200A2O01000100074O00035O00202O0003000300094O00010003000200062O000100FB00013O0004F23O00FB00012O00D9000100024O00FE00025O00202O0002000200034O000300036O000400046O000500043O00202O00050005000D00122O0007000E6O0005000700024O000500056O00010005000200062O000100FB00013O0004F23O00FB00012O00D9000100053O0012C8000200273O0012C8000300284O00AF000100034O00E100015O0012C83O00023O0004F23O000100012O00ED3O00017O00463O00028O00026O000840030D3O00417263616E65546F2O72656E7403073O004973526561647903113O0052756E6963506F77657244656669636974026O003440031F3O00C7CB80DF20EFF9CD8CCC3CEFC8CDC3CD27E4C1D586E13AEBD4DE86CA6EB89003063O008AA6B9E3BE4E030B3O0046726F7374537472696B65030E3O004973496E4D656C2O6552616E6765026O001440031D3O00CD66CA24461C0ADF66CC3C57630AC27AC23B571C0DCA66C23246634B9303073O0079AB14A557324303113O0052656D6F7273656C652O7357696E746572026O00204003223O00D43DB439AB11C334BC25AA3DD131B722BC10862BB038BE0EC307AD37AB05C32CF96403063O0062A658D956D903093O0042752O66537461636B03123O004B692O6C696E674D616368696E6542752O66027O0040031C3O00F0E4761292E3E5E26B088DD9B6E5700F81D0F3C96D0094DBF3E2395503063O00BC2O961961E6030C3O00486F776C696E67426C61737403063O0042752O66557003083O0052696D6542752O6603073O0048617354696572026O003E40030E3O0049735370652O6C496E52616E6765031D3O00D286480E05E3DDB65D0E0DFECEC94C0B02EAD68C60160DFFDD8C4B425A03063O008DBAE93F626C030B3O0046726F7374736379746865031B3O00F7F823A531E2E935A22DF4AA3FBF2BF6E6298931F0F82BB331B1B203053O0045918A4CD6026O00F03F030A3O004F626C69746572617465031B3O007FCD8580AB1362CE9D8CFF0579C18E85BA2964CE9B8EBA02309ED903063O007610AF2OE9DF030A3O00496365627265616B6572030A3O0054616C656E7452616E6B031E3O00838B22B7E7857AB48639BAFD9F3D988D3BBCE28E429F8527BCEB9F3DDAD603073O001DEBE455DB8EEB030C3O00486F726E6F6657696E74657203043O0052756E65026O001040026O003940030C3O004F626C697465726174696F6E030B3O004973417661696C61626C6503123O004272656174686F6653696E647261676F7361031F3O0035DBA8D34841216D2ADDB4C9725C674134DABDD1727133532FD3BFC9371F7303083O00325DB4DABD172E47030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66030F3O005368612O746572696E67426C616465031D3O00D8B6545F50E35BCAB65247419C5BD7AA5C4041E35CDFB65C49509C198803073O0028BEC43B2C24BC031E3O00344ACBB8F3730A0347D0B5E9694D2F4CD2B3F678322844CEB3FF694D6D1D03073O006D5C25BCD49A1D030E3O00476C616369616C416476616E6365030D3O00446562752O6652656D61696E732O033O0047434403093O004973496E52616E6765026O00594003203O0003E3A5C0385B08D0A5C7275B0AECA18322530AE8A8C60E4E05FDA3C6251A56BF03063O003A648FC4A351031B3O0015402FAA2B4CF70F0E4763B03647E2021F7D37A22D4EE01A5A107103083O006E7A2243C35F2985030F3O00432O6F6C646F776E52656D61696E73025O00804640031F3O007DBE4944E97AB7645DDF7BA55E589666B8554DDA708E4F4BC472B44F0A842103053O00B615D13B2A00FD012O0012C83O00013O002606012O0039000100020004F23O003900012O00D900015O0006272O01001D00013O0004F23O001D00012O00D9000100013O0020820001000100030020500001000100042O00D40001000200020006272O01001D00013O0004F23O001D00012O00D9000100023O0020500001000100052O00D4000100020002000E240106001D000100010004F23O001D00012O00D9000100034O000B000200013O00202O0002000200034O000300046O00010003000200062O0001001D00013O0004F23O001D00012O00D9000100053O0012C8000200073O0012C8000300084O00AF000100034O00E100016O00D9000100013O0020820001000100090020500001000100042O00D40001000200020006272O0100FC2O013O0004F23O00FC2O012O00D9000100063O000651000100FC2O0100010004F23O00FC2O012O00D9000100034O00FE000200013O00202O0002000200094O000300076O000400046O000500083O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100FC2O013O0004F23O00FC2O012O00D9000100053O0012310002000C3O00122O0003000D6O000100036O00015O00044O00FC2O01002606012O00CE000100010004F23O00CE00012O00D9000100013O00208200010001000E0020500001000100042O00D40001000200020006272O01005800013O0004F23O005800012O00D9000100093O00065100010047000100010004F23O004700012O00D90001000A3O0006272O01005800013O0004F23O005800012O00D9000100034O0012010200013O00202O00020002000E4O000300046O000500083O00202O00050005000A00122O0007000F6O0005000700024O000500056O00010005000200062O0001005800013O0004F23O005800012O00D9000100053O0012C8000200103O0012C8000300114O00AF000100034O00E100016O00D9000100013O0020820001000100090020500001000100042O00D40001000200020006272O01007F00013O0004F23O007F00012O00D9000100023O0020460001000100124O000300013O00202O0003000300134O00010003000200262O0001007F000100140004F23O007F00012O00D9000100023O0020500001000100052O00D40001000200020026112O01007F000100060004F23O007F00012O00D90001000B3O0006510001007F000100010004F23O007F00012O00D9000100034O00FE000200013O00202O0002000200094O000300076O000400046O000500083O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001007F00013O0004F23O007F00012O00D9000100053O0012C8000200153O0012C8000300164O00AF000100034O00E100016O00D9000100013O0020820001000100170020500001000100042O00D40001000200020006272O0100AC00013O0004F23O00AC00012O00D9000100023O00200A2O01000100184O000300013O00202O0003000300194O00010003000200062O000100AC00013O0004F23O00AC00012O00D9000100023O0020A800010001001A00122O0003001B3O00122O000400146O00010004000200062O000100AC00013O0004F23O00AC00012O00D9000100023O0020460001000100124O000300013O00202O0003000300134O00010003000200262O000100AC000100140004F23O00AC00012O00D9000100034O00D8000200013O00202O0002000200174O000300046O000500083O00202O00050005001C4O000700013O00202O0007000700174O0005000700024O000500056O00010005000200062O000100AC00013O0004F23O00AC00012O00D9000100053O0012C80002001D3O0012C80003001E4O00AF000100034O00E100016O00D9000100013O00208200010001001F0020500001000100042O00D40001000200020006272O0100CD00013O0004F23O00CD00012O00D9000100023O00200A2O01000100184O000300013O00202O0003000300134O00010003000200062O000100CD00013O0004F23O00CD00012O00D90001000C3O0006272O0100CD00013O0004F23O00CD00012O00D9000100034O0012010200013O00202O00020002001F4O000300046O000500083O00202O00050005000A00122O0007000F6O0005000700024O000500056O00010005000200062O000100CD00013O0004F23O00CD00012O00D9000100053O0012C8000200203O0012C8000300214O00AF000100034O00E100015O0012C83O00223O002606012O006C2O0100220004F23O006C2O012O00D9000100013O0020820001000100230020500001000100042O00D40001000200020006272O0100EE00013O0004F23O00EE00012O00D9000100023O00200A2O01000100184O000300013O00202O0003000300134O00010003000200062O000100EE00013O0004F23O00EE00012O00D9000100034O0012010200013O00202O0002000200234O000300046O000500083O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100EE00013O0004F23O00EE00012O00D9000100053O0012C8000200243O0012C8000300254O00AF000100034O00E100016O00D9000100013O0020820001000100170020500001000100042O00D40001000200020006272O0100132O013O0004F23O00132O012O00D9000100023O00200A2O01000100184O000300013O00202O0003000300194O00010003000200062O000100132O013O0004F23O00132O012O00D9000100013O0020820001000100260020500001000100272O00D40001000200020026062O0100132O0100140004F23O00132O012O00D9000100034O00D8000200013O00202O0002000200174O000300046O000500083O00202O00050005001C4O000700013O00202O0007000700174O0005000700024O000500056O00010005000200062O000100132O013O0004F23O00132O012O00D9000100053O0012C8000200283O0012C8000300294O00AF000100034O00E100016O00D9000100013O00208200010001002A0020500001000100042O00D40001000200020006272O01003B2O013O0004F23O003B2O012O00D9000100023O00205000010001002B2O00D40001000200020026112O01003B2O01002C0004F23O003B2O012O00D9000100023O0020500001000100052O00D4000100020002000E24012D003B2O0100010004F23O003B2O012O00D9000100013O00208200010001002E00205000010001002F2O00D40001000200020006272O01003B2O013O0004F23O003B2O012O00D9000100013O00208200010001003000205000010001002F2O00D40001000200020006272O01003B2O013O0004F23O003B2O012O00D9000100034O000B000200013O00202O00020002002A4O0003000D6O00010003000200062O0001003B2O013O0004F23O003B2O012O00D9000100053O0012C8000200313O0012C8000300324O00AF000100034O00E100016O00D9000100013O0020820001000100090020500001000100042O00D40001000200020006272O01006B2O013O0004F23O006B2O012O00D9000100063O0006510001006B2O0100010004F23O006B2O012O00D90001000E3O000651000100592O0100010004F23O00592O012O00D9000100023O0020500001000100052O00D400010002000200269D000100592O01002D0004F23O00592O012O00D9000100083O00207E0001000100334O000300013O00202O0003000300344O00010003000200262O0001006B2O01000B0004F23O006B2O012O00D9000100013O00208200010001003500205000010001002F2O00D40001000200020006272O01006B2O013O0004F23O006B2O012O00D9000100034O00FE000200013O00202O0002000200094O000300076O000400046O000500083O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O0001006B2O013O0004F23O006B2O012O00D9000100053O0012C8000200363O0012C8000300374O00AF000100034O00E100015O0012C83O00143O002606012O0001000100140004F23O000100012O00D9000100013O0020820001000100170020500001000100042O00D40001000200020006272O0100892O013O0004F23O00892O012O00D90001000F3O0006272O0100892O013O0004F23O00892O012O00D9000100034O00D8000200013O00202O0002000200174O000300046O000500083O00202O00050005001C4O000700013O00202O0007000700174O0005000700024O000500056O00010005000200062O000100892O013O0004F23O00892O012O00D9000100053O0012C8000200383O0012C8000300394O00AF000100034O00E100016O00D9000100013O00208200010001003A0020500001000100042O00D40001000200020006272O0100B82O013O0004F23O00B82O012O00D9000100063O000651000100B82O0100010004F23O00B82O012O00D9000100103O000651000100B82O0100010004F23O00B82O012O00D9000100083O0020142O01000100334O000300013O00202O0003000300344O00010003000200262O000100A72O01000B0004F23O00A72O012O00D9000100083O0020B300010001003B4O000300013O00202O0003000300344O0001000300024O000200023O00202O00020002003C4O00020002000200202O00020002000200062O000100B82O0100020004F23O00B82O012O00D9000100034O0012010200013O00202O00020002003A4O000300046O000500083O00202O00050005003D00122O0007003E6O0005000700024O000500056O00010005000200062O000100B82O013O0004F23O00B82O012O00D9000100053O0012C80002003F3O0012C8000300404O00AF000100034O00E100016O00D9000100013O0020820001000100230020500001000100042O00D40001000200020006272O0100D22O013O0004F23O00D22O012O00D9000100113O000651000100D22O0100010004F23O00D22O012O00D9000100034O0012010200013O00202O0002000200234O000300046O000500083O00202O00050005000A00122O0007000B6O0005000700024O000500056O00010005000200062O000100D22O013O0004F23O00D22O012O00D9000100053O0012C8000200413O0012C8000300424O00AF000100034O00E100016O00D9000100013O00208200010001002A0020500001000100042O00D40001000200020006272O0100FA2O013O0004F23O00FA2O012O00D9000100023O00205000010001002B2O00D40001000200020026112O0100FA2O01002C0004F23O00FA2O012O00D9000100023O0020500001000100052O00D4000100020002000E24012D00FA2O0100010004F23O00FA2O012O00D9000100013O00208200010001003000205000010001002F2O00D40001000200020006272O0100EE2O013O0004F23O00EE2O012O00D9000100013O0020820001000100300020500001000100432O00D4000100020002000E24014400FA2O0100010004F23O00FA2O012O00D9000100034O000B000200013O00202O00020002002A4O0003000D6O00010003000200062O000100FA2O013O0004F23O00FA2O012O00D9000100053O0012C8000200453O0012C8000300464O00AF000100034O00E100015O0012C83O00023O0004F23O000100012O00ED3O00017O002C3O00028O00026O00F03F030F3O00556E6C6561736865644672656E7A79030B3O004973417661696C61626C65030B3O0042752O6652656D61696E7303133O00556E6C6561736865644672656E7A7942752O66026O00084003093O0042752O66537461636B03093O0049637954616C6F6E73030D3O0049637954616C6F6E7342752O66030D3O0050692O6C61726F6646726F737403063O0042752O66557003113O0050692O6C61726F6646726F737442752O66030C3O004F626C697465726174696F6E026O00184003153O00456D706F77657252756E65576561706F6E42752O6603113O00456D706F77657252756E65576561706F6E027O0040030B3O0046726F737473637974686503123O004B692O6C696E674D616368696E6542752O6603123O00496D70726F7665644F626C6974657261746503113O00467269676964457865637574696F6E6572030B3O0046726F737472656170657203163O004D696768746F6674686546726F7A656E576173746573030F3O00436C656176696E67537472696B657303083O0042752O66446F776E03113O004465617468416E64446563617942752O66030A3O0052756E6963506F776572025O0080414003043O0052756E65030F3O00432O6F6C646F776E52656D61696E73026O002440026O001440026O00594003113O0052756E6963506F7765724465666963697403123O004272656174686F6653696E647261676F7361026O003440026O0010402O033O00474344026O00D03F03083O0052696D6542752O6603173O00526167656F6674686546726F7A656E4368616D70696F6E03093O004176616C616E636865030A3O00496365627265616B6572006D012O0012C83O00014O000F2O0100013O000EF8000200E000013O0004F23O00E000012O00D9000200013O0020820002000200030020500002000200042O00D40002000200020006270102001900013O0004F23O001900012O00D9000200023O0020C70002000200054O000400013O00202O0004000400064O00020004000200202O00030001000700062O0002002F000100030004F23O002F00012O00D9000200023O0020140102000200084O000400013O00202O0004000400064O00020004000200262O0002002F000100070004F23O002F00012O00D9000200013O0020820002000200090020500002000200042O00D40002000200020006270102003000013O0004F23O003000012O00D9000200023O0020C70002000200054O000400013O00202O00040004000A4O00020004000200202O00030001000700062O0002002F000100030004F23O002F00012O00D9000200023O0020140102000200084O000400013O00202O00040004000A4O00020004000200262O0002002F000100070004F23O002F00012O005900026O001F010200014O009700026O0017000200013O00202O00020002000B00202O0002000200044O00020002000200062O0002005100013O0004F23O005100012O00D9000200023O00200A01020002000C4O000400013O00202O00040004000D4O00020004000200062O0002005100013O0004F23O005100012O00D9000200013O00208200020002000E0020500002000200042O00D40002000200020006270102004B00013O0004F23O004B00012O00D9000200023O0020140102000200054O000400013O00202O00040004000D4O00020004000200262O000200740001000F0004F23O007400012O00D9000200013O00208200020002000E0020500002000200042O00D40002000200020006270102007400013O0004F23O007400012O00D9000200013O00208200020002000B0020500002000200042O00D40002000200020006510002005E000100010004F23O005E00012O00D9000200023O00201000020002000C4O000400013O00202O0004000400104O00020004000200062O00020075000100010004F23O007500012O00D9000200013O00208200020002000B0020500002000200042O00D40002000200020006510002006A000100010004F23O006A00012O00D9000200013O0020820002000200110020500002000200042O00D40002000200020006270102007400013O0004F23O007400012O00D9000200043O000E8B00120073000100020004F23O007300012O00D9000200023O0020F900020002000C4O000400013O00202O00040004000D4O00020004000200044O007500012O005900026O001F010200014O0097000200034O0017000200013O00202O00020002001300202O0002000200044O00020002000200062O000200B900013O0004F23O00B900012O00D9000200023O00201000020002000C4O000400013O00202O0004000400144O00020004000200062O00020086000100010004F23O008600012O00D9000200063O000E8B000700B7000100020004F23O00B700012O00D9000200013O0020820002000200150020500002000200042O00D40002000200020006510002009E000100010004F23O009E00012O00D9000200013O0020820002000200160020500002000200042O00D40002000200020006510002009E000100010004F23O009E00012O00D9000200013O0020820002000200170020500002000200042O00D40002000200020006510002009E000100010004F23O009E00012O00D9000200013O0020820002000200180020500002000200042O00D4000200020002000627010200B800013O0004F23O00B800012O00D9000200013O0020820002000200190020500002000200042O00D4000200020002000627010200B800013O0004F23O00B800012O00D9000200013O0020820002000200190020500002000200042O00D4000200020002000627010200B900013O0004F23O00B900012O00D9000200063O000E89000F00B8000100020004F23O00B800012O00D9000200023O00200A01020002001A4O000400013O00202O00040004001B4O00020004000200062O000200B900013O0004F23O00B900012O00D9000200063O000E89000700B8000100020004F23O00B800012O005900026O001F010200014O0097000200054O00D9000200023O00205000020002001C2O00D4000200020002002611010200DD0001001D0004F23O00DD00012O00D9000200023O00205000020002001E2O00D4000200020002002611010200DD000100120004F23O00DD00012O00D9000200013O00208200020002000B00205000020002001F2O00D4000200020002002611010200DD000100200004F23O00DD00012O00D9000200013O0020FD00020002000B00202O00020002001F4O00020002000200202O0002000200024O0002000200014O000300023O00202O00030003001E4O00030002000200202O0003000300074O000400023O00205000040004001C2O002500040002000200202O0004000400214O0003000300044O00020002000300202O0002000200224O000200073O00044O00DF00010012C8000200074O0097000200073O0012C83O00123O002606012O003B2O0100120004F23O003B2O012O00D9000200023O0020500002000200232O00D4000200020002000E240120003O0100020004F23O003O012O00D9000200013O00208200020002002400205000020002001F2O00D40002000200020026110102003O0100200004F23O003O012O00D9000200013O00205800020002002400202O00020002001F4O00020002000200202O00020002000200202O0002000200014O0002000200014O000300023O00202O00030003001E4O00030002000200202O0003000300024O000400023O00202O00040004001C4O00040002000200202O0004000400254O0003000300044O00020002000300202O0002000200224O000200083O00044O00032O010012C8000200074O0097000200084O00D9000200023O00205000020002001E2O00D4000200020002002611010200152O0100260004F23O00152O012O00D9000200013O00208200020002000E0020500002000200042O00D4000200020002000627010200172O013O0004F23O00172O012O00D9000200013O0020F100020002000B00202O00020002001F4O0002000200024O000300073O00062O000200162O0100030004F23O00162O012O005900026O001F010200014O0097000200094O0017000200013O00202O00020002002400202O0002000200044O00020002000200062O000200252O013O0004F23O00252O012O00D9000200013O0020F100020002002400202O00020002001F4O0002000200024O000300083O00062O000200382O0100030004F23O00382O012O00D9000200013O00208200020002000E0020500002000200042O00D4000200020002000627010200392O013O0004F23O00392O012O00D9000200023O00205000020002001C2O00D4000200020002002611010200372O01001D0004F23O00372O012O00D9000200013O0020F100020002000B00202O00020002001F4O0002000200024O000300073O00062O000200382O0100030004F23O00382O012O005900026O001F010200014O00970002000A3O0004F23O006C2O01002606012O0002000100010004F23O000200012O00D9000200023O0020A90002000200274O00020002000200202O0001000200284O000200063O00262O000200482O0100020004F23O00482O012O00D90002000C4O0002010200023O0004F23O00492O012O005900026O001F010200014O00970002000B4O00D9000200063O000E8B0012004F2O0100020004F23O004F2O012O00D90002000C3O0004F23O00512O012O005900026O001F010200014O00970002000D4O005C000200023O00202O00020002000C4O000400013O00202O0004000400294O00020004000200062O000200692O013O0004F23O00692O012O00D9000200013O00208200020002002A0020500002000200042O00D4000200020002000651000200692O0100010004F23O00692O012O00D9000200013O00208200020002002B0020500002000200042O00D4000200020002000651000200692O0100010004F23O00692O012O00D9000200013O00208200020002002C0020500002000200042O00D40002000200022O00970002000E3O0012C83O00023O0004F23O000200012O00ED3O00017O00343O00028O00030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00B858C603063O00DED737A57D41026O00F03F2O033O002DDEC303083O002A4CB1A67A92A18D2O033O00A68E1603063O0016C5EA65AE19027O004003163O00476574456E656D696573496E4D656C2O6552616E6765026O002040026O002440026O000840030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174024O0080B3C540030C3O00466967687452656D61696E7303103O00426F2O73466967687452656D61696E7303093O00436F6C644865617274030B3O004973417661696C61626C6503083O0042752O66446F776E03123O004B692O6C696E674D616368696E6542752O6603123O004272656174686F6653696E647261676F7361030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66026O001440030E3O00476C616369616C416476616E636503093O004176616C616E6368652O033O00474344026O00E03F03063O0042752O665570030C3O004F626C697465726174696F6E03113O0050692O6C61726F6646726F737442752O6603043O00502O6F6C03163O003D3BAAD036A9D8946D16B7D977BBDFA92F38ACC83EE603083O00E64D54C5BC16CFB7030B3O004465617468537472696B6503073O0049735265616479030E3O004973496E4D656C2O6552616E6765031B3O00FD11C7E8849EE321EB1DCDF9CCADFF22B91CD6BC83B3B025EB1BC503083O00559974A69CECC19003113O00B4EF42BFA406ABF20D91F605A5F445FBAD03063O0060C4802DD38403173O002582745392A9BBCA75A27953DBBBB1CA34997250DCE7FD03083O00B855ED1B3FB2CFD4026O001040030D3O0043617374412O6E6F746174656403043O003F78206B03043O003F68396903133O00576169742F502O6F6C205265736F757263657300EA012O0012C83O00013O002606012O000E000100010004F23O000E00012O00D900016O007000010001000100122O000100023O00202O0001000100034O000200023O00122O000300043O00122O000400056O0002000400024O0001000100024O000100013O00124O00063O002606012O0021000100060004F23O002100010012FC000100023O0020110001000100034O000200023O00122O000300073O00122O000400086O0002000400024O0001000100024O000100033O0012132O0100023O00202O0001000100034O000200023O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100043O00124O000B3O002606012O00540001000B0004F23O005400012O00D9000100064O00450001000100024O000100016O000100056O000100033O00062O0001004300013O0004F23O004300010012C8000100013O0026062O010034000100060004F23O003400012O00D9000200084O00EC000200026O000200076O0002000A6O000200026O000200093O00044O005300010026062O01002B000100010004F23O002B00012O00D90002000B3O00208500020002000C00122O0004000D6O0002000400024O0002000A6O0002000B3O00202O00020002000C00122O0004000E6O0002000400024O000200083O00122O000100063O00044O002B00010004F23O005300010012C8000100013O0026062O01004B000100060004F23O004B00010012C8000200064O0097000200073O0012C8000200064O0097000200093O0004F23O005300010026062O010044000100010004F23O004400012O00AC00026O000B0102000A6O00028O000200083O00122O000100063O00044O004400010012C83O000F3O000EF8000F000100013O0004F23O000100012O00D90001000C3O0020820001000100102O008A00010001000200065100010060000100010004F23O006000012O00D90001000B3O0020500001000100112O00D40001000200020006272O01007700013O0004F23O007700010012C8000100013O0026062O01006D000100060004F23O006D00012O00D90002000D3O00260601020077000100120004F23O007700012O00D90002000E3O0020AE0002000200134O000300086O00048O0002000400024O0002000D3O00044O007700010026062O010061000100010004F23O006100012O00D90002000E3O0020600002000200144O0002000100024O0002000F6O0002000F6O0002000D3O00122O000100063O00044O006100012O00D90001000C3O0020820001000100102O008A0001000100020006272O0100E92O013O0004F23O00E92O010012C8000100014O000F010200023O0026062O0100042O01000B0004F23O00042O012O00D9000300043O0006270103009800013O0004F23O009800010012C8000300014O000F010400043O0026060103008E000100060004F23O008E00012O00D9000500104O008A0005000100022O00B0000400053O0006270104009800013O0004F23O009800012O00FF000400023O0004F23O00980001000EF800010085000100030004F23O008500012O00D9000500114O008A0005000100022O00B0000400053O0006270104009600013O0004F23O009600012O00FF000400023O0012C8000300063O0004F23O008500012O00D9000300123O0020820003000300150020500003000300162O00D4000300020002000627010300D500013O0004F23O00D500012O00D90003000B3O0020100003000300174O000500123O00202O0005000500184O00030005000200062O000300AB000100010004F23O00AB00012O00D9000300123O0020820003000300190020500003000300162O00D4000300020002000627010300D500013O0004F23O00D500012O00D9000300133O00200100030003001A4O000500123O00202O00050005001B4O00030005000200262O000300C90001001C0004F23O00C900012O00D9000300143O000651000300C1000100010004F23O00C100012O00D9000300123O00208200030003001D0020500003000300162O00D4000300020002000651000300C1000100010004F23O00C100012O00D9000300123O00208200030003001E0020500003000300162O00D4000300020002000627010300C900013O0004F23O00C900012O00D90003000D4O00190104000B3O00202O00040004001F4O00040002000200202O00040004002000202O00040004000100062O000300D5000100040004F23O00D500010012C8000300014O000F010400043O002606010300CB000100010004F23O00CB00012O00D9000500154O008A0005000100022O00B0000400053O000627010400D500013O0004F23O00D500012O00FF000400023O0004F23O00D500010004F23O00CB00012O00D90003000B3O00200A0103000300214O000500123O00202O0005000500194O00030005000200062O000300032O013O0004F23O00032O012O00D9000300123O0020820003000300220020500003000300162O00D4000300020002000627010300032O013O0004F23O00032O012O00D90003000B3O00200A0103000300214O000500123O00202O0005000500234O00030005000200062O000300032O013O0004F23O00032O010012C8000300014O000F010400043O002606010300F9000100060004F23O00F900012O00D9000500164O00D9000600123O0020820006000600242O00D4000500020002000627010500032O013O0004F23O00032O012O00D9000500023O001231000600253O00122O000700266O000500076O00055O00044O00032O01002606010300EB000100010004F23O00EB00012O00D9000500174O008A0005000100022O00B0000400053O0006270104003O013O0004F23O003O012O00FF000400023O0012C8000300063O0004F23O00EB00010012C80001000F3O0026062O0100342O0100010004F23O00342O012O00D90003000B3O0020500003000300112O00D4000300020002000651000300172O0100010004F23O00172O010012C8000300014O000F010400043O0026060103000D2O0100010004F23O000D2O012O00D9000500184O008A0005000100022O00B0000400053O000627010400172O013O0004F23O00172O012O00FF000400023O0004F23O00172O010004F23O000D2O012O00D9000300123O0020820003000300270020500003000300282O00D4000300020002000627010300312O013O0004F23O00312O012O00D9000300053O000651000300312O0100010004F23O00312O012O00D9000300164O0012010400123O00202O0004000400274O000500066O000700133O00202O00070007002900122O0009001C6O0007000900024O000700076O00030007000200062O000300312O013O0004F23O00312O012O00D9000300023O0012C80004002A3O0012C80005002B4O00AF000300054O00E100036O00D9000300194O00B90003000100010012C8000100063O0026062O01004C2O0100060004F23O004C2O012O00D90003001A4O008A0003000100022O00B0000200033O0006270102003C2O013O0004F23O003C2O012O00FF000200024O00D9000300043O0006270103004B2O013O0004F23O004B2O010012C8000300014O000F010400043O002606010300412O0100010004F23O00412O012O00D90005001B4O008A0005000100022O00B0000400053O0006270104004B2O013O0004F23O004B2O012O00FF000400023O0004F23O004B2O010004F23O00412O010012C80001000B3O000EF8000F00C32O0100010004F23O00C32O012O00D90003000B3O00200A0103000300214O000500123O00202O0005000500194O00030005000200062O000300822O013O0004F23O00822O012O00D9000300123O0020820003000300220020500003000300162O00D4000300020002000627010300682O013O0004F23O00682O012O00D9000300123O0020820003000300220020500003000300162O00D4000300020002000627010300822O013O0004F23O00822O012O00D90003000B3O00200A0103000300174O000500123O00202O0005000500234O00030005000200062O000300822O013O0004F23O00822O010012C8000300014O000F010400043O002606010300782O0100060004F23O00782O012O00D9000500164O00D9000600123O0020820006000600242O00D4000500020002000627010500822O013O0004F23O00822O012O00D9000500023O0012310006002C3O00122O0007002D6O000500076O00055O00044O00822O010026060103006A2O0100010004F23O006A2O012O00D90005001C4O008A0005000100022O00B0000400053O000627010400802O013O0004F23O00802O012O00FF000400023O0012C8000300063O0004F23O006A2O012O00D9000300123O0020820003000300220020500003000300162O00D4000300020002000627010300B02O013O0004F23O00B02O012O00D90003000B3O00200A0103000300214O000500123O00202O0005000500234O00030005000200062O000300B02O013O0004F23O00B02O012O00D90003000B3O00200A0103000300174O000500123O00202O0005000500194O00030005000200062O000300B02O013O0004F23O00B02O010012C8000300014O000F010400043O002606010300A62O0100060004F23O00A62O012O00D9000500164O00D9000600123O0020820006000600242O00D4000500020002000627010500B02O013O0004F23O00B02O012O00D9000500023O0012310006002E3O00122O0007002F6O000500076O00055O00044O00B02O01002606010300982O0100010004F23O00982O012O00D90005001D4O008A0005000100022O00B0000400053O000627010400AE2O013O0004F23O00AE2O012O00FF000400023O0012C8000300063O0004F23O00982O012O00D9000300073O000E8B000B00C22O0100030004F23O00C22O012O00D9000300033O000627010300C22O013O0004F23O00C22O010012C8000300014O000F010400043O002606010300B82O0100010004F23O00B82O012O00D90005001E4O008A0005000100022O00B0000400053O000627010400C22O013O0004F23O00C22O012O00FF000400023O0004F23O00C22O010004F23O00B82O010012C8000100303O0026062O01007E000100300004F23O007E00012O00D9000300073O00267F000300CB2O0100060004F23O00CB2O012O00D9000300033O000651000300D72O0100010004F23O00D72O010012C8000300014O000F010400043O002606010300CD2O0100010004F23O00CD2O012O00D90005001F4O008A0005000100022O00B0000400053O000627010400D72O013O0004F23O00D72O012O00FF000400023O0004F23O00D72O010004F23O00CD2O012O00D90003000E3O00200A0003000300314O000400123O00202O0004000400244O00058O000600023O00122O000700323O00122O000800336O000600086O00033O000200062O000300E92O013O0004F23O00E92O010012C8000300344O00FF000300023O0004F23O00E92O010004F23O007E00010004F23O00E92O010004F23O000100012O00ED3O00017O00043O00028O0003053O005072696E7403323O002D95AB571FC7806F4B95AB500A93AD4B05C7A65D4BA2B44D08C9E4730495AF040289E4541988A3560E94B7042C88AE4D198603043O00246BE7C4000F3O0012C83O00013O002606012O0001000100010004F23O000100012O00D900016O00BE0001000100014O000100013O00202O0001000100024O000200023O00122O000300033O00122O000400046O000200046O00013O000100044O000E00010004F23O000100012O00ED3O00017O00", GetFEnv(), ...);
