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
				if (Enum <= 158) then
					if (Enum <= 78) then
						if (Enum <= 38) then
							if (Enum <= 18) then
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
										elseif (Enum == 2) then
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
											if (Inst[2] == Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Inst[2] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 6) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 7) then
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
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
											Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
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
									elseif (Enum <= 11) then
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
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum <= 15) then
									if (Enum > 14) then
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
										A = Inst[2];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 16) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 17) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 28) then
								if (Enum <= 23) then
									if (Enum <= 20) then
										if (Enum == 19) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											if (Inst[2] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 21) then
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
									elseif (Enum > 22) then
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
									elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 25) then
									if (Enum > 24) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum <= 26) then
									if (Inst[2] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 27) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								else
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								end
							elseif (Enum <= 33) then
								if (Enum <= 30) then
									if (Enum > 29) then
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
								elseif (Enum <= 31) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 32) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum == 34) then
									local Edx;
									local Results;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 36) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 37) then
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
						elseif (Enum <= 58) then
							if (Enum <= 48) then
								if (Enum <= 43) then
									if (Enum <= 40) then
										if (Enum > 39) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 41) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 42) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 45) then
									if (Enum == 44) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Inst[2] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 46) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 47) then
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
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 53) then
								if (Enum <= 50) then
									if (Enum > 49) then
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
								elseif (Enum <= 51) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 52) then
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
							elseif (Enum <= 55) then
								if (Enum > 54) then
									Stk[Inst[2]]();
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
							elseif (Enum <= 56) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 57) then
								local A = Inst[2];
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
						elseif (Enum <= 68) then
							if (Enum <= 63) then
								if (Enum <= 60) then
									if (Enum == 59) then
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
								elseif (Enum <= 61) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 62) then
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								else
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								end
							elseif (Enum <= 65) then
								if (Enum > 64) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local A = Inst[2];
									Stk[A] = Stk[A]();
								end
							elseif (Enum <= 66) then
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
							elseif (Enum > 67) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 73) then
							if (Enum <= 70) then
								if (Enum > 69) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 71) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 72) then
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
						elseif (Enum <= 75) then
							if (Enum > 74) then
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
						elseif (Enum <= 76) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 77) then
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
						end
					elseif (Enum <= 118) then
						if (Enum <= 98) then
							if (Enum <= 88) then
								if (Enum <= 83) then
									if (Enum <= 80) then
										if (Enum > 79) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum <= 81) then
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
									elseif (Enum == 82) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 85) then
									if (Enum > 84) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									end
								elseif (Enum <= 86) then
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
								elseif (Enum == 87) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 93) then
								if (Enum <= 90) then
									if (Enum == 89) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									end
								elseif (Enum <= 91) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 92) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 95) then
								if (Enum > 94) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 96) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							elseif (Enum == 97) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 108) then
							if (Enum <= 103) then
								if (Enum <= 100) then
									if (Enum > 99) then
										if (Stk[Inst[2]] <= Inst[4]) then
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
								elseif (Enum <= 101) then
									local A = Inst[2];
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								elseif (Enum == 102) then
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
							elseif (Enum <= 105) then
								if (Enum == 104) then
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
							elseif (Enum <= 106) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 107) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 113) then
							if (Enum <= 110) then
								if (Enum == 109) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								else
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								end
							elseif (Enum <= 111) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 112) then
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
						elseif (Enum <= 115) then
							if (Enum > 114) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 116) then
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
						elseif (Enum == 117) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 138) then
						if (Enum <= 128) then
							if (Enum <= 123) then
								if (Enum <= 120) then
									if (Enum > 119) then
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
								elseif (Enum <= 121) then
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								elseif (Enum == 122) then
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
							elseif (Enum <= 125) then
								if (Enum > 124) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 126) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 127) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 133) then
							if (Enum <= 130) then
								if (Enum == 129) then
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
							elseif (Enum <= 131) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 132) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								do
									return Stk[Inst[2]]();
								end
							end
						elseif (Enum <= 135) then
							if (Enum > 134) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 136) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 137) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 148) then
						if (Enum <= 143) then
							if (Enum <= 140) then
								if (Enum == 139) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									for Idx = A + 1, Top do
										Insert(T, Stk[Idx]);
									end
								end
							elseif (Enum <= 141) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 142) then
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
							else
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 145) then
							if (Enum > 144) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 146) then
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
						elseif (Enum > 147) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 153) then
						if (Enum <= 150) then
							if (Enum == 149) then
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
							end
						elseif (Enum <= 151) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 152) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 155) then
						if (Enum > 154) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 156) then
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
						if (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
						end
					elseif (Enum > 157) then
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 237) then
					if (Enum <= 197) then
						if (Enum <= 177) then
							if (Enum <= 167) then
								if (Enum <= 162) then
									if (Enum <= 160) then
										if (Enum == 159) then
											Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
										else
											local A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
											end
										end
									elseif (Enum > 161) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 164) then
									if (Enum == 163) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 165) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								elseif (Enum > 166) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 172) then
								if (Enum <= 169) then
									if (Enum > 168) then
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
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
								elseif (Enum <= 170) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 174) then
								if (Enum > 173) then
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
									if (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 175) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							elseif (Enum > 176) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum <= 187) then
							if (Enum <= 182) then
								if (Enum <= 179) then
									if (Enum > 178) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 180) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 181) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								end
							elseif (Enum <= 184) then
								if (Enum > 183) then
									local A = Inst[2];
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
							elseif (Enum <= 185) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 186) then
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
							end
						elseif (Enum <= 192) then
							if (Enum <= 189) then
								if (Enum == 188) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 191) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								VIP = Inst[3];
							end
						elseif (Enum <= 194) then
							if (Enum == 193) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							end
						elseif (Enum <= 195) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 196) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 217) then
						if (Enum <= 207) then
							if (Enum <= 202) then
								if (Enum <= 199) then
									if (Enum == 198) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
										Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
									end
								elseif (Enum <= 200) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 201) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 204) then
								if (Enum > 203) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 205) then
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
								A = Inst[2];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum == 206) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						elseif (Enum <= 212) then
							if (Enum <= 209) then
								if (Enum == 208) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 211) then
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
						elseif (Enum <= 214) then
							if (Enum == 213) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 215) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 216) then
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
								if (Mvm[1] == 253) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						end
					elseif (Enum <= 227) then
						if (Enum <= 222) then
							if (Enum <= 219) then
								if (Enum == 218) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 220) then
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							elseif (Enum > 221) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 224) then
							if (Enum > 223) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 225) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 226) then
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
					elseif (Enum <= 232) then
						if (Enum <= 229) then
							if (Enum == 228) then
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
						elseif (Enum <= 230) then
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
						elseif (Enum > 231) then
							if (Stk[Inst[2]] < Inst[4]) then
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
					elseif (Enum <= 234) then
						if (Enum > 233) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 235) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Enum > 236) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
					end
				elseif (Enum <= 277) then
					if (Enum <= 257) then
						if (Enum <= 247) then
							if (Enum <= 242) then
								if (Enum <= 239) then
									if (Enum > 238) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 240) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 241) then
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
							elseif (Enum <= 244) then
								if (Enum == 243) then
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
							elseif (Enum <= 245) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 246) then
								Stk[Inst[2]] = {};
							else
								local B;
								local A;
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 252) then
							if (Enum <= 249) then
								if (Enum == 248) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 250) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 251) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 254) then
							if (Enum == 253) then
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
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 255) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 256) then
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
					elseif (Enum <= 267) then
						if (Enum <= 262) then
							if (Enum <= 259) then
								if (Enum == 258) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 260) then
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							elseif (Enum == 261) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 264) then
							if (Enum == 263) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 265) then
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum > 266) then
							Stk[Inst[2]] = #Stk[Inst[3]];
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
					elseif (Enum <= 272) then
						if (Enum <= 269) then
							if (Enum == 268) then
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
						elseif (Enum <= 270) then
							do
								return;
							end
						elseif (Enum == 271) then
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
						end
					elseif (Enum <= 274) then
						if (Enum == 273) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 275) then
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
						if (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
						end
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
					end
				elseif (Enum <= 297) then
					if (Enum <= 287) then
						if (Enum <= 282) then
							if (Enum <= 279) then
								if (Enum > 278) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 284) then
							if (Enum == 283) then
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 285) then
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						elseif (Enum == 286) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 292) then
						if (Enum <= 289) then
							if (Enum == 288) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 290) then
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
						elseif (Enum == 291) then
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
						end
					elseif (Enum <= 294) then
						if (Enum == 293) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
						end
					elseif (Enum == 296) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 307) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 300) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 301) then
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
					elseif (Enum <= 304) then
						if (Enum == 303) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = #Stk[Inst[3]];
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
							VIP = Inst[3];
						end
					elseif (Enum <= 305) then
						if (Inst[2] <= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 306) then
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Stk[A + 1]));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					else
						Stk[Inst[2]] = Inst[3] ~= 0;
					end
				elseif (Enum <= 312) then
					if (Enum <= 309) then
						if (Enum == 308) then
							local B;
							local A;
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 310) then
						Stk[Inst[2]] = not Stk[Inst[3]];
					elseif (Enum > 311) then
						if (Inst[2] < Stk[Inst[4]]) then
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
				elseif (Enum <= 314) then
					if (Enum > 313) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 315) then
					local B;
					local A;
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
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = not Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum == 316) then
					if (Inst[2] == Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				else
					local A = Inst[2];
					Stk[A](Unpack(Stk, A + 1, Inst[3]));
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD99FC21FC5CBF02BEFBCCF0AEEF6D52DE9B7DE50DDD6DA03083O007EB1A3BB4586DBA7031B3O00A25CBF1DD4A349B711E3AC42BF02E39373830BE38840AF4BE7924D03053O008BE72CD665002E3O001222012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004BF3O000A00010012A9000300063O0020250004000300070012A9000500083O0020250005000500090012A9000600083O00202500060006000A0006D900073O000100062O00FD3O00064O00FD8O00FD3O00044O00FD3O00014O00FD3O00024O00FD3O00053O00202500080003000B00202500090003000C2O00F6000A5O0012A9000B000D3O0006D9000C0001000100022O00FD3O000A4O00FD3O000B4O00FD000D00073O00129E000E000E3O00129E000F000F4O0012010D000F00020006D9000E0002000100032O00FD3O00074O00FD3O00094O00FD3O00084O0002000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O007400025O00122O000300016O00045O00122O000500013O00042O0003002100012O00D400076O0051000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004190103000500012O00D4000300054O00FD000400024O0086000300044O004400036O000E012O00017O000D3O00028O00026O00F03F025O00907B40025O00E89240025O00A6A340025O00D0A140025O0080A740025O00707240025O00388840025O00DCB240025O0096A740025O001AA240025O00CCA04001403O00129E000200014O0008000300043O00261E00020006000100020004BF3O00060001002E0500030033000100040004BF3O0037000100129E000500013O0026FC00050007000100010004BF3O00070001002EAA00060011000100050004BF3O00110001000E3C01020011000100030004BF3O001100012O00FD000600044O007600076O006E00066O004400065O0026FC00030006000100010004BF3O0006000100129E000600013O0026FC00060018000100020004BF3O0018000100129E000300023O0004BF3O00060001002E05000700FCFF2O00070004BF3O001400010026FC00060014000100010004BF3O0014000100129E000700013O0026FC00070021000100020004BF3O0021000100129E000600023O0004BF3O00140001002EAA0008001D000100090004BF3O001D00010026FC0007001D000100010004BF3O001D00012O00D400086O0002010400083O0006850004002B00013O0004BF3O002B0001002E31010A00300001000B0004BF3O003000012O00D4000800014O00FD00096O0076000A6O006E00086O004400085O00129E000700023O0004BF3O001D00010004BF3O001400010004BF3O000600010004BF3O000700010004BF3O000600010004BF3O003F0001002E31010D00020001000C0004BF3O000200010026FC00020002000100010004BF3O0002000100129E000300014O0008000400043O00129E000200023O0004BF3O000200012O000E012O00017O00703O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503063O00C856B541F94303043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A030A3O0034AADDCB841F241CB3DD03073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O00644303374603043O004529226003073O009FCCDA070D25AF03063O004BDCA3B76A6203083O0027AC8E25C00DB48E03053O00B962DAEB572O033O00C5292A03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D03043O000EC1517E03083O00876CAE3E121E179303043O006D6174682O033O00BBE02403083O00A7D6894AAB78CE532O033O008AF22103063O00C7EB90523D982O033O000A17A103043O004B6776D903043O00E455630003063O007EA7341074D903053O007461626C6503063O00C1203385A60D03073O009CA84E40E0D47903073O0047657454696D65030B3O0081AF220A1B2FC9582OA23703083O0031C5CA437E7364A703063O000255D7268C4F03073O003E573BBF49E036030B3O00C307FBDDEF29F4C0E00AEE03043O00A987629A03063O00FE792C5BF12A03073O00A8AB1744349D53030B3O00D074F4B92D0689FD76FDB903073O00E7941195CD454D03063O00B5A9CFF45BE603063O009FE0C7A79B3703113O00D6FF3BD7E3FB3DC0C7E626C8FBF61EDDEF03043O00B297935C03023O004944030F3O00A5EF4536175969AAEF4D351F49749803073O001AEC9D2C52722C03133O001C27D4572528F4552O23D44F2F2AF7572521D103043O003B4A4EB5030C3O0047657445717569706D656E74026O002A40028O00026O002C4003073O0006DE2O57BC2BC203053O00D345B12O3A03083O0092F37CE7F0C4B9E003063O00ABD785199589030E3O00C2C433EDE63EFB71E9C936F5F82303083O002281A8529A8F509C030B3O004973417661696C61626C65030E3O00A6BE321C41408EB6BA320F47599A03073O00E9E5D2536B282E030D3O00F2413DC317C64701C217C8493703053O0065A12252B603063O00CC085FF7D7E703083O004E886D399EBB82E203063O001A3AFFF8323A03043O00915E5F99030D3O00D9C815C14696F3C930D04DB6E403063O00D79DAD74B52E03063O0011B18DFBD63003053O00BA55D4EB92030C3O00E68410F735EB68CE800FFB2B03073O0038A2E1769E598E03093O007804E49F2ED94500D203063O00B83C65A0CF42024O0080B3C540030A3O00168A73A93DB67DBE3D8703043O00DC51E21C030A3O0032C6922OF3DF1AD496FE03063O00A773B5E29B8A031B3O00C123F4483B50D5F22AFE447270D2E762AF2O7565C3F030F24C6F3803073O00A68242873C1B1103103O005265676973746572466F724576656E7403183O007466EF4C157675EB44056D7AE3501E7075ED5D116A6DEB5103053O0050242AAE1503143O007E3C16436B2208486B3712547135195B6C3C125E03043O001A2E7057030E3O00F22228D92E4386E23A2CDB25559D03073O00D9A1726D95621003143O003E05194E9251361F0B4C99583E1F11528340330203063O00147240581CDC03063O0053657441504C025O00806F4000AD023O00E4000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F4O00105O00122O0011001A3O00122O0012001B6O0010001200024O000F000F00104O00105O00122O0011001C3O00122O0012001D6O0010001200024O000F000F00104O00105O00122O0011001E3O00122O0012001F6O0010001200024O0010000400104O00115O00122O001200203O00122O001300216O0011001300024O0010001000114O00115O00129E001200223O0012B3001300236O0011001300024O00100010001100122O001100246O00125O00122O001300253O00122O001400266O0012001400024O00110011001200122O001200246O00135O00122O001400273O00122O001500286O0013001500024O00120012001300122O001300246O00145O00122O001500293O00122O0016002A6O0014001600024O0013001300144O00148O00158O00168O00175O00122O0018002B3O00122O0019002C6O0017001900024O00170004001700122O0018002D6O00195O00122O001A002E3O00122O001B002F6O0019001B00024O00180018001900122O001900306O001A00353O0006D900363O0001001B2O00FD3O00344O00D48O00FD3O00354O00FD3O00204O00FD3O001E4O00FD3O001F4O00FD3O002A4O00FD3O00284O00FD3O00294O00FD3O00254O00FD3O00264O00FD3O00274O00FD3O00334O00FD3O00314O00FD3O00324O00FD3O001A4O00FD3O001C4O00FD3O001D4O00FD3O00304O00FD3O002E4O00FD3O002F4O00FD3O00214O00FD3O00224O00FD3O00234O00FD3O002B4O00FD3O002C4O00FD3O002D4O00C600375O00122O003800313O00122O003900326O0037003900024O0037000B00372O00C600385O00122O003900333O00122O003A00346O0038003A00024O0037003700382O00C600385O00122O003900353O00122O003A00366O0038003A00024O0038000D00382O00C600395O00122O003A00373O00122O003B00386O0039003B00024O0038003800392O00C600395O00122O003A00393O00122O003B003A6O0039003B00024O0039000E00392O00C6003A5O00122O003B003B3O00122O003C003C6O003A003C00024O00390039003A2O00F6003A00024O00C6003B5O00122O003C003D3O00122O003D003E6O003B003D00024O003B0038003B0020B1003B003B003F2O0039003B000200022O00C6003C5O00122O003D00403O00122O003E00416O003C003E00024O003C0038003C0020B1003C003C003F2O0039003C000200022O00C6003D5O00122O003E00423O00122O003F00436O003D003F00024O003D0038003D0020B1003D003D003F2O0032013D003E4O008C003A3O00010020B1003B000800442O0039003B00020002002025003C003B0045000685003C00D100013O0004BF3O00D100012O00FD003C000D3O002025003D003B00452O0039003C0002000200064D003C00D4000100010004BF3O00D400012O00FD003C000D3O00129E003D00464O0039003C00020002002025003D003B0047000685003D00DC00013O0004BF3O00DC00012O00FD003D000D3O002025003E003B00472O0039003D0002000200064D003D00DF000100010004BF3O00DF00012O00FD003D000D3O00129E003E00464O0039003D000200022O0008003E003F4O00C600405O00122O004100483O00122O004200496O0040004200024O0040000400402O00C600415O00122O0042004A3O00122O0043004B6O0041004300024O0040004000412O00080041004F4O007200505O00122O0051004C3O00122O0052004D6O0050005200024O00500037005000202O00500050004E4O00500002000200062O005000FB00013O0004BF3O00FB00012O00D400505O0012490051004F3O00122O005200506O0050005200024O00500037005000062O00502O002O0100010004BF4O002O012O00D400505O00129E005100513O00129E005200524O00120150005200022O00020150003700502O00D400515O00128F005200533O00122O005300546O0051005300024O00510037005100202O00510051004E4O00510002000200062O005100102O013O0004BF3O00102O012O00D400515O001249005200553O00122O005300566O0051005300024O00510037005100062O005100152O0100010004BF3O00152O012O00D400515O00129E005200573O00129E005300584O00120151005300022O00020151003700512O00D400525O00128F005300593O00122O0054005A6O0052005400024O00520037005200202O00520052004E4O00520002000200062O005200252O013O0004BF3O00252O012O00D400525O0012490053005B3O00122O0054005C6O0052005400024O00520039005200062O0052002A2O0100010004BF3O002A2O012O00D400525O00129E0053005D3O00129E0054005E4O00120152005400022O00020152003900522O0008005300533O00129E0054005F3O00129E0055005F4O00C600565O00122O005700603O00122O005800616O0056005800024O0056000400562O00080057005B4O00F6005C00014O00F6005D00034O00C6005E5O00122O005F00623O00122O006000636O005E006000024O005E0037005E2O00D4005F5O00129E006000643O00129E006100654O0012015F00610002000204016000014O0065005D000300012O0065005C000100010020B1005D000400660006D9005F0002000100052O00FD3O003B4O00FD3O00084O00FD3O003C4O00FD3O000D4O00FD3O003D4O004200605O00122O006100673O00122O006200686O006000626O005D3O000100202O005D000400660006D9005F0003000100022O00FD3O00544O00FD3O00554O004200605O00122O006100693O00122O0062006A6O006000626O005D3O000100202O005D000400660006D9005F0004000100062O00FD3O00514O00FD3O00374O00D48O00FD3O00504O00FD3O00524O00FD3O00394O009600605O00122O0061006B3O00122O0062006C6O0060006200024O00615O00122O0062006D3O00122O0063006E6O006100636O005D3O00010006D9005D0005000100042O00FD3O00084O00FD3O00254O00FD3O00264O00FD3O00373O0006D9005E0006000100032O00FD3O00374O00D43O00014O00D43O00023O0006D9005F0007000100032O00FD3O00044O00FD3O00074O00FD3O00183O0006D900600008000100012O00FD3O00373O0006D900610009000100012O00FD3O00373O0006D90062000A000100032O00FD3O00374O00D48O00FD3O00083O0006D90063000B000100012O00FD3O00373O0006D90064000C000100012O00FD3O00373O0006D90065000D000100012O00FD3O00373O0006D90066000E000100012O00FD3O00373O0006D90067000F000100012O00FD3O00373O0006D900680010000100022O00FD3O00374O00FD3O00093O0006D900690011000100022O00FD3O00374O00FD3O00513O0006D9006A0012000100012O00FD3O00373O0006D9006B0013000100052O00FD3O00374O00D48O00D43O00014O00FD3O000F4O00D43O00023O0006D9006C0014000100062O00FD3O00374O00D48O00FD3O00094O00FD3O00044O00FD3O00164O00FD3O000A3O0006D9006D0015000100042O00FD3O003E4O00FD3O00404O00FD3O003A4O00FD3O00163O0006D9006E00160001000C2O00FD3O00374O00D48O00FD3O00474O00FD3O00554O00FD3O00044O00FD3O00314O00FD3O000A4O00FD3O00504O00FD3O00464O00FD3O00404O00FD3O00574O00FD3O00603O0006D9006F00170001000F2O00FD3O00504O00FD3O00044O00FD3O000A4O00D48O00FD3O00374O00FD3O00084O00FD3O00534O00FD3O00474O00FD3O00584O00FD3O00314O00FD3O00404O00FD3O00574O00FD3O00604O00FD3O006A4O00FD3O00553O0006D900700018000100152O00FD3O00374O00D48O00FD3O00084O00FD3O00534O00FD3O00044O00FD3O000A4O00FD3O00404O00FD3O00574O00FD3O00604O00FD3O00624O00FD3O00094O00FD3O00554O00FD3O002C4O00FD3O00514O00FD3O005A4O00FD3O00304O00FD3O002B4O00FD3O00684O00FD3O00334O00FD3O00694O00FD3O00323O0006D900710019000100102O00FD3O00374O00D48O00FD3O00474O00FD3O00554O00FD3O00044O00FD3O00314O00FD3O000A4O00FD3O005A4O00FD3O00404O00FD3O00574O00FD3O00604O00FD3O00444O00FD3O00644O00FD3O00514O00FD3O00524O00FD3O002A3O0006D90072001A000100182O00FD3O00374O00D48O00FD3O00484O00FD3O00404O00FD3O00574O00FD3O00604O00FD3O00334O00FD3O00584O00FD3O000A4O00FD3O00044O00FD3O00084O00FD3O00324O00FD3O00094O00FD3O00614O00FD3O00674O00FD3O004E4O00FD3O004F4O00FD3O004C4O00FD3O004A4O00FD3O00554O00FD3O002B4O00FD3O00304O00FD3O00634O00FD3O002F3O0006D90073001B000100122O00FD3O00164O00FD3O004E4O00FD3O004F4O00FD3O00374O00D48O00FD3O00044O00FD3O002B4O00FD3O00334O00FD3O00084O00FD3O00304O00FD3O00584O00FD3O000A4O00FD3O00324O00FD3O00514O00FD3O00534O00FD3O00524O00FD3O002A4O00FD3O002F3O0006D90074001C000100182O00FD3O00504O00FD3O00374O00D48O00D43O00014O00FD3O00444O00D43O00024O00FD3O00584O00FD3O00084O00FD3O00044O00FD3O000A4O00FD3O00484O00FD3O00494O00FD3O00554O00FD3O00344O00FD3O00274O00FD3O004E4O00FD3O00284O00FD3O00294O00FD3O00164O00FD3O005A4O00FD3O00314O00FD3O00404O00FD3O00574O00FD3O006B3O0006D90075001D000100122O00FD3O00374O00D48O00D43O00014O00D43O00024O00FD3O004F4O00FD3O004E4O00FD3O004C4O00FD3O004D4O00FD3O004A4O00FD3O004B4O00FD3O00584O00FD3O00084O00FD3O00554O00FD3O00044O00FD3O002E4O00FD3O000A4O00FD3O00574O00FD3O00533O0006D90076001E0001001D2O00FD3O00514O00FD3O00084O00FD3O00374O00FD3O00584O00D48O00FD3O004A4O00FD3O004B4O00FD3O004E4O00FD3O004F4O00FD3O004C4O00FD3O004D4O00FD3O00464O00FD3O00534O00FD3O00094O00FD3O00044O00FD3O00524O00FD3O002A4O00FD3O00504O00FD3O000A4O00FD3O00404O00FD3O00574O00FD3O00604O00FD3O00654O00FD3O00424O00FD3O00474O00FD3O00434O00FD3O00554O00FD3O00314O00FD3O00663O0006D90077001F000100022O00FD3O001B4O00FD3O006D3O0006D900780020000100152O00FD3O00444O00FD3O00374O00D48O00FD3O00534O00FD3O004E4O00FD3O00084O00FD3O00454O00FD3O000F4O00FD3O00424O00FD3O00584O00FD3O00414O00FD3O00044O00FD3O00464O00FD3O00484O00FD3O000A4O00FD3O00564O00FD3O00554O00FD3O00474O00FD3O00434O00FD3O00154O00FD3O00493O0006D9007900210001002F2O00FD3O00404O00FD3O00084O00FD3O004E4O00FD3O00564O00FD3O004F4O00FD3O00534O00FD3O000A4O00FD3O00374O00FD3O00544O00FD3O00044O00FD3O00554O00FD3O00574O00FD3O005B4O00FD3O005E4O00FD3O00594O00FD3O004C4O00D48O00FD3O004D4O00FD3O004A4O00FD3O004B4O00FD3O001B4O00FD3O00774O00FD3O00164O00FD3O00414O00FD3O00734O00FD3O00744O00FD3O00584O00FD3O00764O00FD3O00154O00FD3O00474O00FD3O00314O00FD3O00784O00FD3O006C4O00FD3O003F4O00FD3O00754O00FD3O00514O00FD3O00494O00FD3O006E4O00FD3O00714O00FD3O006F4O00FD3O00484O00FD3O00724O00FD3O00704O00FD3O005D4O00FD3O005A4O00FD3O00364O00FD3O00143O0006D9007A0022000100032O00FD3O00374O00D48O00FD3O00043O002089007B0004006F00122O007C00706O007D00796O007E007A6O007B007E00016O00013O00233O00923O00028O00026O002040025O0098A840025O00188740030C3O004570696353652O74696E677303083O0063BFD5AF59B4C6A803043O00DB30DAA1030F3O00D17F7446D756C2E8787B41CF68C3C003073O008084111C29BB2F03083O003237122E540F351503053O003D6152665A03103O009A27A74EE458101DAD29A244C9703D2D03083O0069CC4ECB2BA7377E026O00F03F025O00E0B140025O003AB24003083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030D3O0085D811FC6CFEBEC91FFE7DDE9D03063O0096CDBD709018027O0040025O0006AE40025O00ACA74003083O002O0B96D2A336099103053O00CA586EE2A6030F3O00EB0A83FBC3CD08B2F8DECA008CDFFA03053O00AAA36FE29703083O002235A62C47392E0203073O00497150D2582E57030E3O00B43FC83AE28020D91AF49523C31703053O0087E14CAD72026O001040025O00B4A340025O00C0984003083O0032E25C4B7A0FE05B03053O00136187283F03103O008A59322F2710A058173E2C30B77B101F03063O0051CE3C535B4F026O001440025O005AA94003083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC03113O001DA19545CE787F35ACB244E675741B8CA503073O00185CCFE12C831903083O0078D6AC5812734CC003063O001D2BB3D82C7B03103O009CD7344590D82745BEE32F42B8FE036803043O002CDDB940026O000840025O006AB140025O0014A740025O0040A040025O00307D40026O004D40025O0050834003083O00D5C0D929EFCBCA2E03043O005D86A5AD03103O008BE1C4E63FCFA6768DE6D3CB31CB9A4E03083O001EDE92A1A25AAED203083O00D64B641EEC40771903043O006A852E10030F3O006D3376D85B52531366FF594F4A084303063O00203840139C3A025O00D88B40025O008EAC4003083O0069CDF14253FC874903073O00E03AA885363A9203143O006C454EDC58B5A62663794DFB708894024F5347E403083O006B39362B9D15E6E7026O001C4003083O00188924B8A0B3313803073O00564BEC50CCC9DD03103O00474F7F8AF29253526484EB872O6654A103063O00EB122117E59E03083O00802D1BE8D955B43B03063O003BD3486F9CB0030B3O006B97EA294B8AEA2E69A4C703043O004D2EE78303083O008951A254B35AB15303043O0020DA34D603113O007D023CA5FEBE625B5C103EB1FDB562796A03083O003A2E7751C891D025025O00BFB040025O004CAC40026O004140025O0012A44003083O0034EBB1DA0EE0A2DD03043O00AE678EC5030A3O00633B5A0A245DF157244C03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E03103O006D4D000122EC1E5150021928F91B575003073O0072383E6549478D025O0078A640025O00AC944003083O008BECCFD0B1E7DCD703043O00A4D889BB03113O00FAE330BEAFF00CE2E925BBA9F025D3EB3403073O006BB28651D2C69E025O00B89F40026O001840025O00E09F40025O0050854003083O00682BA042445529A703053O002D3B4ED43603153O0034579180B23CACFE03508C998B2FB9F91F58A4A8A203083O00907036E3EBE64ECD025O00D07040025O009CA24003083O00EC1AE00833D118E703053O005ABF7F947C030D3O004A862D1E798B3D387E8109345C03043O007718E74E03083O00B128B15ED54E169103073O0071E24DC52ABC20030D3O001B06FBB63B1AEDA52913D3961E03043O00D55A7694025O00208A40025O0024B040025O005AA740025O009C904003083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FD1113D6A46E93C40B30DAA274B5C00A0903073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103163O0085A70541A4F9DABCBD3E4ABAF2F8A4A00541BAE2DCB803073O00AFCCC97124D68B03083O0074C921C80D49CB2603053O006427AC55BC03123O008476AD8521BF6DA99407A56ABC933BA274BD03053O0053CD18D9E003083O007DAEC46626CD4AB703083O00C42ECBB0124FA32D03143O009D2F6E1133FEFD8A37701B13FEEEA82D703907DF03073O008FD8421E7E449B03083O0099CD19DFCCADD0F203083O0081CAA86DABA5C3B703123O00115934CAD712EF215136D4EE15E5367F14FC03073O0086423857B8BE7403083O000F341DAF10E52O2603083O00555C5169DB798B4103103O00D0BA5E415ACDF8B64A4053D9FB94736103063O00BF9DD330251C0004022O00129E3O00014O0008000100013O0026FC3O0002000100010004BF3O0002000100129E000100013O00261E00010009000100020004BF3O00090001002E050003001B000100040004BF3O002200010012A9000200054O00C6000300013O00122O000400063O00122O000500076O0003000500024O0002000200032O00C6000300013O00122O000400083O00122O000500096O0003000500024O0002000200032O002300025O0012A9000200054O00C6000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200032O00C6000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200032O0023000200023O0004BF3O000302010026FC0001005B0001000E0004BF3O005B000100129E000200013O002EAA000F003A000100100004BF3O003A00010026FC0002003A0001000E0004BF3O003A00010012A9000300054O00C6000400013O00122O000500113O00122O000600126O0004000600024O0003000300042O00C6000400013O00122O000500133O00122O000600146O0004000600024O00030003000400064D00030037000100010004BF3O0037000100129E000300014O0023000300033O00129E000100153O0004BF3O005B0001000E162O01003E000100020004BF3O003E0001002E05001600E9FF2O00170004BF3O002500010012A9000300054O00C6000400013O00122O000500183O00122O000600196O0004000600024O0003000300042O00C6000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400064D0003004C000100010004BF3O004C000100129E000300014O0023000300043O00122E010300056O000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000300053O00122O0002000E3O00044O002500010026FC00010094000100200004BF3O0094000100129E000200014O0008000300033O002EAA0022005F000100210004BF3O005F00010026FC0002005F000100010004BF3O005F000100129E000300013O0026FC000300740001000E0004BF3O007400010012A9000400054O00C6000500013O00122O000600233O00122O000700246O0005000700024O0004000400052O00C6000500013O00122O000600253O00122O000700266O0005000700024O0004000400052O0023000400063O00129E000100273O0004BF3O00940001002E05002800F0FF2O00280004BF3O00640001000E3C2O010064000100030004BF3O006400010012A9000400054O00C6000500013O00122O000600293O00122O0007002A6O0005000700024O0004000400052O00C6000500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400052O0023000400073O00122E010400056O000500013O00122O0006002D3O00122O0007002E6O0005000700024O0004000400054O000500013O00122O0006002F3O00122O000700306O0005000700024O0004000400054O000400083O00122O0003000E3O00044O006400010004BF3O009400010004BF3O005F0001000E3C013100DF000100010004BF3O00DF000100129E000200014O0008000300033O00261E0002009C000100010004BF3O009C0001002E3101320098000100330004BF3O0098000100129E000300013O00261E000300A1000100010004BF3O00A10001002E31013400CA000100350004BF3O00CA000100129E000400013O0026FC000400A60001000E0004BF3O00A6000100129E0003000E3O0004BF3O00CA0001002EAA003600A2000100370004BF3O00A200010026FC000400A2000100010004BF3O00A200010012A9000500054O00C6000600013O00122O000700383O00122O000800396O0006000800024O0005000500062O00C6000600013O00122O0007003A3O00122O0008003B6O0006000800024O00050005000600064D000500B8000100010004BF3O00B8000100129E000500014O0023000500093O001235000500056O000600013O00122O0007003C3O00122O0008003D6O0006000800024O0005000500064O000600013O00122O0007003E3O00122O0008003F6O0006000800024O00050005000600062O000500C7000100010004BF3O00C7000100129E000500014O00230005000A3O00129E0004000E3O0004BF3O00A20001000E16010E00CE000100030004BF3O00CE0001002EAA0041009D000100400004BF3O009D00010012A9000400054O00C6000500013O00122O000600423O00122O000700436O0005000700024O0004000400052O00C6000500013O00122O000600443O00122O000700456O0005000700024O0004000400052O00230004000B3O00129E000100203O0004BF3O00DF00010004BF3O009D00010004BF3O00DF00010004BF3O009800010026FC0001000E2O0100460004BF3O000E2O0100129E000200013O0026FC000200F20001000E0004BF3O00F200010012A9000300054O00C6000400013O00122O000500473O00122O000600486O0004000600024O0003000300042O00C6000400013O00122O000500493O00122O0006004A6O0004000600024O0003000300042O00230003000C3O00129E000100023O0004BF3O000E2O010026FC000200E2000100010004BF3O00E200010012A9000300054O00C6000400013O00122O0005004B3O00122O0006004C6O0004000600024O0003000300042O00C6000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300042O00230003000D3O00122E010300056O000400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O000400013O00122O000500513O00122O000600526O0004000600024O0003000300044O0003000E3O00122O0002000E3O00044O00E2000100261E000100122O0100010004BF3O00122O01002EAA005300542O0100540004BF3O00542O0100129E000200014O0008000300033O002E31015500142O0100560004BF3O00142O01000E3C2O0100142O0100020004BF3O00142O0100129E000300013O0026FC0003003E2O0100010004BF3O003E2O0100129E000400013O0026FC000400372O0100010004BF3O00372O010012A9000500054O00C6000600013O00122O000700573O00122O000800586O0006000800024O0005000500062O00C6000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500062O00230005000F3O0012A9000500054O00C6000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500062O00C6000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500062O0023000500103O00129E0004000E3O00261E0004003B2O01000E0004BF3O003B2O01002E05005F00E3FF2O00600004BF3O001C2O0100129E0003000E3O0004BF3O003E2O010004BF3O001C2O010026FC000300192O01000E0004BF3O00192O010012A9000400054O00C6000500013O00122O000600613O00122O000700626O0005000700024O0004000400052O00C6000500013O00122O000600633O00122O000700646O0005000700024O00040004000500064D0004004E2O0100010004BF3O004E2O0100129E000400014O0023000400113O00129E0001000E3O0004BF3O00542O010004BF3O00192O010004BF3O00542O010004BF3O00142O01002E0500650035000100650004BF3O00892O010026FC000100892O0100660004BF3O00892O0100129E000200013O00261E0002005D2O01000E0004BF3O005D2O01002E0500670010000100680004BF3O006B2O010012A9000300054O00C6000400013O00122O000500693O00122O0006006A6O0004000600024O0003000300042O00C6000400013O00122O0005006B3O00122O0006006C6O0004000600024O0003000300042O0023000300123O00129E000100463O0004BF3O00892O0100261E0002006F2O0100010004BF3O006F2O01002EAA006E00592O01006D0004BF3O00592O010012A9000300054O00C6000400013O00122O0005006F3O00122O000600706O0004000600024O0003000300042O00C6000400013O00122O000500713O00122O000600726O0004000600024O0003000300042O0023000300133O00122E010300056O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000300143O00122O0002000E3O00044O00592O010026FC000100CB2O0100150004BF3O00CB2O0100129E000200014O0008000300033O002EAA0077008D2O0100780004BF3O008D2O010026FC0002008D2O0100010004BF3O008D2O0100129E000300013O002E31017A00B52O0100790004BF3O00B52O010026FC000300B52O0100010004BF3O00B52O010012A9000400054O00C6000500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400052O00C6000500013O00122O0006007D3O00122O0007007E6O0005000700024O00040004000500064D000400A42O0100010004BF3O00A42O0100129E000400014O0023000400153O001235000400056O000500013O00122O0006007F3O00122O000700806O0005000700024O0004000400054O000500013O00122O000600813O00122O000700826O0005000700024O00040004000500062O000400B32O0100010004BF3O00B32O0100129E000400014O0023000400163O00129E0003000E3O0026FC000300922O01000E0004BF3O00922O010012A9000400054O00C6000500013O00122O000600833O00122O000700846O0005000700024O0004000400052O00C6000500013O00122O000600853O00122O000700866O0005000700024O00040004000500064D000400C52O0100010004BF3O00C52O0100129E000400014O0023000400173O00129E000100313O0004BF3O00CB2O010004BF3O00922O010004BF3O00CB2O010004BF3O008D2O010026FC00010005000100270004BF3O0005000100129E000200014O0008000300033O0026FC000200CF2O0100010004BF3O00CF2O0100129E000300013O0026FC000300ED2O0100010004BF3O00ED2O010012A9000400054O00C6000500013O00122O000600873O00122O000700886O0005000700024O0004000400052O00C6000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400052O0023000400183O0012A9000400054O00C6000500013O00122O0006008B3O00122O0007008C6O0005000700024O0004000400052O00C6000500013O00122O0006008D3O00122O0007008E6O0005000700024O0004000400052O0023000400193O00129E0003000E3O0026FC000300D22O01000E0004BF3O00D22O010012A9000400054O00C6000500013O00122O0006008F3O00122O000700906O0005000700024O0004000400052O00C6000500013O00122O000600913O00122O000700926O0005000700024O0004000400052O00230004001A3O00129E000100663O0004BF3O000500010004BF3O00D22O010004BF3O000500010004BF3O00CF2O010004BF3O000500010004BF3O000302010004BF3O000200012O000E012O00019O003O00034O0033012O00014O006C3O00024O000E012O00017O000B3O00028O00025O00CCA240025O002AA940025O00DEAB40025O006BB140026O00F03F025O00109D40025O0022A040030C3O0047657445717569706D656E74026O002A40026O002C4000433O00129E3O00014O0008000100013O0026FC3O0002000100010004BF3O0002000100129E000100013O002E310102002E000100030004BF3O002E00010026FC0001002E000100010004BF3O002E000100129E000200014O0008000300033O0026FC0002000B000100010004BF3O000B000100129E000300013O002EAA00040014000100050004BF3O001400010026FC00030014000100060004BF3O0014000100129E000100063O0004BF3O002E000100261E00030018000100010004BF3O00180001002E310108000E000100070004BF3O000E00012O00D4000400013O0020260004000400094O0004000200024O00048O00045O00202O00040004000A00062O0004002600013O0004BF3O002600012O00D4000400034O00D400055O00202500050005000A2O003900040002000200064D00040029000100010004BF3O002900012O00D4000400033O00129E000500014O00390004000200022O0023000400023O00129E000300063O0004BF3O000E00010004BF3O002E00010004BF3O000B00010026FC00010005000100060004BF3O000500012O00D400025O00202500020002000B0006850002003A00013O0004BF3O003A00012O00D4000200034O00D400035O00202500030003000B2O003900020002000200064D0002003D000100010004BF3O003D00012O00D4000200033O00129E000300014O00390002000200022O0023000200043O0004BF3O004200010004BF3O000500010004BF3O004200010004BF3O000200012O000E012O00017O00023O00028O00024O0080B3C540000A3O00129E3O00013O0026FC3O0001000100010004BF3O0001000100129E000100024O002300015O00129E000100024O0023000100013O0004BF3O000900010004BF3O000100012O000E012O00017O001C3O00028O00026O00F03F025O0096A040025O001EB340025O0046AC4003063O009AF1054C8FBB03053O00E3DE946325030B3O004973417661696C61626C6503063O00175754FFF53603053O0099532O3296030D3O00797372087B8A435952761F72B203073O002D3D16137C13CB025O00A8A040025O000EAA40025O007DB140025O0022AC40030E3O009A2FAA63B6B14287B122AF7BA8AC03083O00D4D943CB142ODF25030E3O009981A9C5B383AFE1B28CACDDAD9E03043O00B2DAEDC8030D3O0085B6E9C5A4B22OE3A2A7EFDBB303043O00B0D6D58603063O00D0A8B0DDA45303073O003994CDD6B4C836030C3O0036F8333D7A17CD39356F17EF03053O0016729D555403093O00E0CA37F451F7B1C1D903073O00C8A4AB73A43D9600793O00129E3O00014O0008000100023O0026FC3O0007000100010004BF3O0007000100129E000100014O0008000200023O00129E3O00023O00261E3O000B000100020004BF3O000B0001002E3101040002000100030004BF3O00020001002E0500053O000100050004BF3O000B00010026FC0001000B000100010004BF3O000B000100129E000200013O0026FC0002002C000100020004BF3O002C00012O00D4000300014O0072000400023O00122O000500063O00122O000600076O0004000600024O00030003000400202O0003000300084O00030002000200062O0003002400013O0004BF3O002400012O00D4000300014O00C6000400023O00122O000500093O00122O0006000A6O0004000600024O00030003000400064D0003002A000100010004BF3O002A00012O00D4000300014O00C6000400023O00122O0005000B3O00122O0006000C6O0004000600024O0003000300042O002300035O0004BF3O00780001002EAA000D00100001000E0004BF3O001000010026FC00020010000100010004BF3O0010000100129E000300014O0008000400043O0026FC00030032000100010004BF3O0032000100129E000400013O00261E00040039000100020004BF3O00390001002E31010F003B000100100004BF3O003B000100129E000200023O0004BF3O00100001000E3C2O010035000100040004BF3O003500012O00D4000500014O0072000600023O00122O000700113O00122O000800126O0006000800024O00050005000600202O0005000500084O00050002000200062O0005004F00013O0004BF3O004F00012O00D4000500014O00C6000600023O00122O000700133O00122O000800146O0006000800024O00050005000600064D00050055000100010004BF3O005500012O00D4000500014O00C6000600023O00122O000700153O00122O000800166O0006000800024O0005000500062O0023000500034O00D4000500014O0072000600023O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500084O00050002000200062O0005006800013O0004BF3O006800012O00D4000500054O00C6000600023O00122O000700193O00122O0008001A6O0006000800024O00050005000600064D0005006E000100010004BF3O006E00012O00D4000500054O00C6000600023O00122O0007001B3O00122O0008001C6O0006000800024O0005000500062O0023000500043O00129E000400023O0004BF3O003500010004BF3O001000010004BF3O003200010004BF3O001000010004BF3O007800010004BF3O000B00010004BF3O007800010004BF3O000200012O000E012O00017O00033O0003103O004865616C746850657263656E7461676503063O0042752O665570030F3O004465617468537472696B6542752O6600164O0023016O00206O00016O000200024O000100013O00064O0013000100010004BF3O001300012O00D47O0020B15O00012O00393O000200022O00D4000100023O0006163O0012000100010004BF3O001200012O00D47O0020985O00024O000200033O00202O0002000200036O0002000200044O001400012O004E8O0033012O00014O006C3O00024O000E012O00017O00133O00028O00025O002CAB40025O00688240026O00F03F025O00109B40025O00406040025O00188B40025O001EA940025O00C88440025O00BDB140025O00049140025O00FEAA4003053O007061697273030A3O00446562752O66446F776E03143O00566972756C656E74506C61677565446562752O66025O0084AB40025O00C4A040025O0046AB40025O0074A94001443O00129E000100014O0008000200033O00261E00010006000100010004BF3O00060001002E0500020005000100030004BF3O0009000100129E000200014O0008000300033O00129E000100043O002E3101060002000100050004BF3O000200010026FC00010002000100040004BF3O0002000100129E000400013O00261E00040012000100010004BF3O00120001002EAA0008000E000100070004BF3O000E00010026FC00020015000100040004BF3O001500012O006C000300023O002E310109000D0001000A0004BF3O000D00010026FC0002000D000100010004BF3O000D000100129E000500013O002E31010B00370001000C0004BF3O003700010026FC00050037000100010004BF3O0037000100129E000300013O0012A90006000D4O00FD00076O003E0006000200080004BF3O003400010020B1000B000A000E2O00D4000D5O002025000D000D000F2O0012010B000D000200064D000B002B000100010004BF3O002B0001002EAA00100034000100110004BF3O003400012O00D4000B00014O001B010C00033O00122O000D00046O000B000D00024O000C00026O000D00033O00122O000E00046O000C000E00024O0003000B000C00068200060023000100020004BF3O0023000100129E000500043O00261E0005003B000100040004BF3O003B0001002E310112001A000100130004BF3O001A000100129E000200043O0004BF3O000D00010004BF3O001A00010004BF3O000D00010004BF3O000E00010004BF3O000D00010004BF3O004300010004BF3O000200012O000E012O00017O000E3O00028O00026O00F03F025O0061B140025O0078AC40030C3O00466967687452656D61696E73025O00206340025O007C9D4003053O007061697273025O00949B40026O008440030C3O004973496E426F2O734C69737403093O00556E69744E50434944026O006940025O00B6AF4001473O00129E000100014O0008000200033O0026FC00010040000100020004BF3O0040000100129E000400013O000E162O010009000100040004BF3O00090001002EAA00030005000100040004BF3O00050001000E3C01020010000100020004BF3O001000012O00D400055O0020250005000500052O00FD000600034O0086000500064O004400055O0026FC00020004000100010004BF3O0004000100129E000500013O0026FC00050035000100010004BF3O0035000100129E000600013O00261E0006001A000100020004BF3O001A0001002E310107001C000100060004BF3O001C000100129E000500023O0004BF3O003500010026FC00060016000100010004BF3O001600012O00F600076O0022000300073O00122O000700086O00088O00070002000900044O00310001002EAA000A0031000100090004BF3O003100012O00D4000B00013O00202A010B000B000B4O000D3O000A00202O000D000D000C4O000B000D000200062O000B0031000100010004BF3O003100012O00D4000B00024O00FD000C00034O0002010D3O000A2O003D010B000D000100068200070024000100010004BF3O0024000100129E000600023O0004BF3O00160001002EAA000D00130001000E0004BF3O001300010026FC00050013000100020004BF3O0013000100129E000200023O0004BF3O000400010004BF3O001300010004BF3O000400010004BF3O000500010004BF3O000400010004BF3O00460001000E3C2O010002000100010004BF3O0002000100129E000200014O0008000300033O00129E000100023O0004BF3O000200012O000E012O00017O00023O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O6601063O0020ED00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E73030A3O00536F756C52656170657201063O0020ED00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00153O00030D3O001314C0A7ECD9B33632DDA6FDC303073O00DD5161B2D498B0030B3O004973417661696C61626C6503083O00446562752O66557003143O00466573746572696E67576F756E64446562752O6603083O0042752O66446F776E03113O004465617468416E64446563617942752O66030D3O00E9E21CEF12ECE919DF1FCEE60403053O007AAD877D9B030C3O00432O6F6C646F776E446F776E03043O0052756E65026O00084003063O0042752O665570028O00030D3O00A6D412AA2B38C683F20FAB3A2203073O00A8E4A160D95F51030B3O00446562752O66537461636B026O00104003073O0048617354696572026O003F40027O004001524O00D400016O0072000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O00010002000200062O0001003200013O0004BF3O003200010020B100013O00042O00D400035O0020250003000300052O00122O01000300020006850001003200013O0004BF3O003200012O00D4000100023O0020EE0001000100064O00035O00202O0003000300074O00010003000200062O0001002600013O0004BF3O002600012O00D400016O0072000200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001002600013O0004BF3O002600012O00D4000100023O0020B100010001000B2O00390001000200020026180001004F0001000C0004BF3O004F00012O00D4000100023O0020EE00010001000D4O00035O00202O0003000300074O00010003000200062O0001003200013O0004BF3O003200012O00D4000100023O0020B100010001000B2O003900010002000200261E0001004F0001000E0004BF3O004F00012O00D400016O0031000200013O00122O0003000F3O00122O000400106O0002000400024O00010001000200202O0001000100034O00010002000200062O00010042000100010004BF3O004200010020B100013O00112O00D400035O0020250003000300052O00122O0100030002000E1A0012004F000100010004BF3O004F00012O00D4000100023O00203C00010001001300122O000300143O00122O000400156O00010004000200062O0001005000013O0004BF3O005000010020B100013O00042O00D400035O0020250003000300052O00122O01000300020004BF3O005000012O004E00016O00332O0100014O006C000100024O000E012O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O0020FA00013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004BF3O000700012O004E00016O00332O0100014O006C000100024O000E012O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O0020E500013O00014O00035O00202O0003000300024O00010003000200262O00010007000100030004BF3O000700012O004E00016O00332O0100014O006C000100024O000E012O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O0020E500013O00014O00035O00202O0003000300024O00010003000200262O00010007000100030004BF3O000700012O004E00016O00332O0100014O006C000100024O000E012O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O0020FA00013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004BF3O000700012O004E00016O00332O0100014O006C000100024O000E012O00017O00073O0003073O0054696D65546F58025O00804140026O00144003103O004865616C746850657263656E7461676503093O0054696D65546F446965030D3O00446562752O6652656D61696E73030A3O00536F756C52656170657201163O0020B100013O000100129E000300024O00122O010003000200261800010009000100030004BF3O000900010020B100013O00042O003900010002000200266400010012000100020004BF3O001200010020B100013O00052O00F700010002000200202O00023O00064O00045O00202O0004000400074O00020004000200202O00020002000300062O00020013000100010004BF3O001300012O004E00016O00332O0100014O006C000100024O000E012O00017O00053O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66027O004003063O0042752O66557003123O004461726B5472616E73666F726D6174696F6E01103O00209700013O00014O00035O00202O0003000300024O00010003000200262O0001000D000100030004BF3O000D00012O00D4000100013O0020980001000100044O00035O00202O0003000300054O00010003000200044O000E00012O004E00016O00332O0100014O006C000100024O000E012O00017O00053O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040030F3O00432O6F6C646F776E52656D61696E73026O000840010F3O0020A200013O00014O00035O00202O0003000300024O000100030002000E2O0003000B000100010004BF3O000B00012O00D4000100013O0020B10001000100042O00390001000200020026180001000C000100050004BF3O000C00012O004E00016O00332O0100014O006C000100024O000E012O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O00F03F010A3O0020FA00013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004BF3O000700012O004E00016O00332O0100014O006C000100024O000E012O00017O00193O0003093O0054696D65546F446965030D3O00446562752O6652656D61696E7303143O00566972756C656E74506C61677565446562752O6603113O00446562752O665265667265736861626C65030B3O00E8C43E593D44CFC32F552103063O0037BBB14E3C4F030B3O004973417661696C61626C6503103O0046726F73744665766572446562752O6603113O00426C2O6F64506C61677565446562752O66030C3O0018C057E44AD6A221C758E35203073O00E04DAE3F8B26AF030C3O00B14F502188587A228D46503A03043O004EE42138030C3O00FB70BA0C89D75CBE0A82C66A03053O00E5AE1ED263030F3O00432O6F6C646F776E52656D61696E73030B3O0028F89654FF2E2D09EC8F5F03073O00597B8DE6318D5D026O000840030D3O00C37DF70B054FF163FF02174FE103063O002A9311966C70027O004003093O002AA42271C1ED19A33F03063O00886FC64D1F87026O002E4001903O00200E00013O00014O00010002000200202O00023O00024O00045O00202O0004000400034O00020004000200062O0002008C000100010004BF3O008C00010020B100013O00042O00D400035O0020250003000300032O00122O010003000200064D00010024000100010004BF3O002400012O00D400016O0072000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008E00013O0004BF3O008E00010020B100013O00042O00D400035O0020250003000300082O00122O010003000200064D00010024000100010004BF3O002400010020B100013O00042O00D400035O0020250003000300092O00122O01000300020006850001008E00013O0004BF3O008E00012O00D400016O0072000200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008D00013O0004BF3O008D00012O00D400016O0072000200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008E00013O0004BF3O008E00012O00D400016O00C6000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100020020F30001000100104O0001000200024O000200026O000300036O00046O00C6000500013O00122O000600113O00122O000700126O0005000700024O00040004000500206D0004000400074O000400056O00033O000200202O0003000300134O000400036O00056O00C6000600013O00122O000700143O00122O000800156O0006000800024O0005000500060020100105000500074O000500066O00043O000200202O0004000400164O0003000300044O000400036O00056O00C6000600013O00122O000700173O00122O000800186O0006000800024O0005000500060020810005000500074O000500066O00043O000200202O0004000400164O0002000400024O000300046O000400036O00056O00C6000600013O00122O000700113O00122O000800126O0006000800024O00050005000600206D0005000500074O000500066O00043O000200202O0004000400134O000500036O00066O00C6000700013O00122O000800143O00122O000900156O0007000900024O0006000600070020100106000600074O000600076O00053O000200202O0005000500164O0004000400054O000500036O00066O00C6000700013O00122O000800173O00122O000900186O0007000900024O0006000600070020090006000600074O000600076O00053O000200202O0005000500164O0003000500024O00020002000300102O00020019000200062O0002008D000100010004BF3O008D00012O004E00016O00332O0100014O006C000100024O000E012O00017O00263O00028O00025O0014A940025O00E09540025O00909540025O002EAE4003093O003008AE45B8C012A80603083O00C96269C736DD8477030A3O0049734361737461626C65030D3O004973446561644F7247686F737403083O00497341637469766503053O005072652O7303093O0052616973654465616403233O00AB0D8A32070AA8BC0D87611227A9BA038E230321ECEB4C87281125A0B81590351B39A903073O00CCD96CE3416255025O00E06640025O001AAA40030D3O007FD1F8FC23C64ACBF0C129C15A03063O00A03EA395854C03073O0049735265616479030D3O0041726D796F6674686544656164031C3O00D7B20036FCD9A6323BCBD39F092AC2D2E01D3DC6D5AF002D2OC2E05903053O00A3B6C06D4F026O00F03F03083O001B3314C2E731270B03053O0095544660A003083O004F7574627265616B030E3O0049735370652O6C496E52616E6765025O00A07A40025O0098A94003143O00371319EF2A030CE678161FE83B0900EF39124DBB03043O008D58666D030F3O009556D9641F2F5CCFB460DE6213365003083O00A1D333AA107A5D35030F3O00466573746572696E67537472696B65025O0010AC40025O00F8AF40031C3O00FDABA13CFEBCBB26FC91A13CE9A7B92DBBBEA02DF8A1BF2AFABAF27003043O00489BCED200873O00129E3O00013O00261E3O0005000100010004BF3O00050001002E310102004A000100030004BF3O004A0001002EAA0004002D000100050004BF3O002D00012O00D400016O0072000200013O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O00010002000200062O0001002D00013O0004BF3O002D00012O00D4000100023O0020B10001000100092O003900010002000200064D00010020000100010004BF3O002000012O00D4000100023O0020B100010001000A2O00390001000200020006850001002000013O0004BF3O002000012O00D4000100023O0020B100010001000A2O003900010002000200064D0001002D000100010004BF3O002D00012O00D4000100033O0020E300010001000B4O00025O00202O00020002000C4O000300036O00010003000200062O0001002D00013O0004BF3O002D00012O00D4000100013O00129E0002000D3O00129E0003000E4O0086000100034O004400015O002E31010F0049000100100004BF3O004900012O00D400016O0072000200013O00122O000300113O00122O000400126O0002000400024O00010001000200202O0001000100134O00010002000200062O0001004900013O0004BF3O004900012O00D4000100043O0006850001004900013O0004BF3O004900012O00D4000100033O0020E300010001000B4O00025O00202O0002000200144O000300036O00010003000200062O0001004900013O0004BF3O004900012O00D4000100013O00129E000200153O00129E000300164O0086000100034O004400015O00129E3O00173O0026FC3O0001000100170004BF3O000100012O00D400016O0072000200013O00122O000300183O00122O000400196O0002000400024O00010001000200202O0001000100134O00010002000200062O0001006B00013O0004BF3O006B00012O00D4000100033O0020142O010001000B4O00025O00202O00020002001A4O000300046O000500053O00202O00050005001B4O00075O00202O00070007001A4O0005000700024O000500056O00010005000200062O00010066000100010004BF3O00660001002EAA001D006B0001001C0004BF3O006B00012O00D4000100013O00129E0002001E3O00129E0003001F4O0086000100034O004400016O00D400016O0072000200013O00122O000300203O00122O000400216O0002000400024O00010001000200202O0001000100134O00010002000200062O0001008600013O0004BF3O008600012O00D4000100033O0020A400010001000B4O00025O00202O0002000200224O000300046O00010004000200062O0001007F000100010004BF3O007F0001002E0500230009000100240004BF3O008600012O00D4000100013O00129D000200253O00122O000300266O000100036O00015O00044O008600010004BF3O000100012O000E012O00017O00093O00028O00025O0068AA4003103O0048616E646C65546F705472696E6B6574026O004440026O00F03F025O00E9B240025O00F5B14003133O0048616E646C65426F2O746F6D5472696E6B6574025O00F4AE4000313O00129E3O00013O002E050002001C000100020004BF3O001D00010026FC3O001D000100010004BF3O001D000100129E000100013O0026FC00010016000100010004BF3O001600012O00D4000200013O00200F0002000200034O000300026O000400033O00122O000500046O000600066O0002000600024O00028O00025O00062O0002001500013O0004BF3O001500012O00D400026O006C000200023O00129E000100053O002E3101070006000100060004BF3O000600010026FC00010006000100050004BF3O0006000100129E3O00053O0004BF3O001D00010004BF3O000600010026FC3O0001000100050004BF3O000100012O00D4000100013O0020AD0001000100084O000200026O000300033O00122O000400046O000500056O0001000500024O00015O002E2O00090009000100090004BF3O003000012O00D400015O0006850001003000013O0004BF3O003000012O00D400016O006C000100023O0004BF3O003000010004BF3O000100012O000E012O00017O002B3O00028O00025O00E2A740025O006AA04003083O00636A5D0A364B735703053O0053261A346E03073O0049735265616479026O002440025O0012AF40025O0050B24003053O005072652O7303083O0045706964656D696303093O004973496E52616E6765026O003E40030E3O005D072E425D1A2E4518162843184503043O0026387747030C3O004361737454617267657449662O033O00FEEE4003063O0036938F38B645030E3O0049735370652O6C496E52616E676503133O00C18EEA47DBE992EF4CD1D284ED09DED984BF1D03053O00BFB6E19F29026O00F03F030F3O000D173B418E95CB25151B41998EC92E03073O00A24B724835EBE7025O00308840025O00707C40030F3O00466573746572696E67537472696B652O033O00813D5C03063O0062EC5C24823303163O00A21C1FAE40BABC3EA3261FAE57A1BE35E41803BF05FE03083O0050C4796CDA25C8D503093O002476036B432D85097F03073O00EA6013621F2B6E03083O00230F5BC3A97F820503073O00EB667F32A7CC12030B3O004973417661696C61626C65026O008A40025O0056A24003093O004465617468436F696C025O00389E40025O00B2A54003103O0054A4F4374C1153AEFC2F042F5FA4B57B03063O004E30C195432400AD3O00129E3O00014O0008000100013O0026FC3O0002000100010004BF3O0002000100129E000100013O0026FC00010056000100010004BF3O0056000100129E000200013O00261E0002000C000100010004BF3O000C0001002E3101020051000100030004BF3O005100012O00D400036O0072000400013O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300064O00030002000200062O0003001C00013O0004BF3O001C00012O00D4000300023O0006850003001E00013O0004BF3O001E00012O00D4000300033O0026180003001E000100070004BF3O001E0001002E3101090031000100080004BF3O003100012O00D4000300043O00200A00030003000A4O00045O00202O00040004000B4O000500056O000600066O000700063O00202O00070007000C00122O0009000D6O0007000900024O000700076O00030007000200062O0003003100013O0004BF3O003100012O00D4000300013O00129E0004000E3O00129E0005000F4O0086000300054O004400036O00D4000300073O0020B10003000300062O00390003000200020006850003005000013O0004BF3O005000012O00D4000300083O0006850003005000013O0004BF3O005000012O00D4000300093O0020460003000300104O000400076O0005000A6O000600013O00122O000700113O00122O000800126O0006000800024O0007000B6O000800086O000900063O00202O0009000900134O000B00076O0009000B00024O000900096O00030009000200062O0003005000013O0004BF3O005000012O00D4000300013O00129E000400143O00129E000500154O0086000300054O004400035O00129E000200163O0026FC00020008000100160004BF3O0008000100129E000100163O0004BF3O005600010004BF3O000800010026FC00010005000100160004BF3O000500012O00D400026O0072000300013O00122O000400173O00122O000500186O0003000500024O00020002000300202O0002000200064O00020002000200062O0002006500013O0004BF3O006500012O00D4000200083O0006850002006700013O0004BF3O00670001002EAA0019007A0001001A0004BF3O007A00012O00D4000200093O0020B50002000200104O00035O00202O00030003001B4O0004000A6O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0006000B6O000700074O00120102000700020006850002007A00013O0004BF3O007A00012O00D4000200013O00129E0003001E3O00129E0004001F4O0086000200044O004400026O00D400026O0072000300013O00122O000400203O00122O000500216O0003000500024O00020002000300202O0002000200064O00020002000200062O0002009100013O0004BF3O009100012O00D4000200023O00064D00020091000100010004BF3O009100012O00D400026O0072000300013O00122O000400223O00122O000500236O0003000500024O00020002000300202O0002000200244O00020002000200062O0002009300013O0004BF3O00930001002E050025001B000100260004BF3O00AC00012O00D4000200043O00201401020002000A4O00035O00202O0003000300274O000400056O000600063O00202O0006000600134O00085O00202O0008000800274O0006000800024O000600066O00020006000200062O000200A3000100010004BF3O00A30001002E050028000B000100290004BF3O00AC00012O00D4000200013O00129D0003002A3O00122O0004002B6O000200046O00025O00044O00AC00010004BF3O000500010004BF3O00AC00010004BF3O000200012O000E012O00017O00423O00028O00025O00E08240025O003DB240027O004003073O0049735265616479025O0050A040025O00B6A24003053O005072652O73030E3O0049735370652O6C496E52616E6765031A3O006BF83C38379B6FE72C3837A16EB72839369B7EE23B2527E42DA703063O00C41C97495653025O00209F40025O0074A440025O00ECA940025O00207A4003083O00150E891C443D178303053O0021507EE078030D3O00CEBD11D748E5A604F753FEAD1003053O003C8CC863A4030B3O004973417661696C61626C6503043O0052756E65026O00F03F030D3O00A5E11635B68EFA0315AD95F11703053O00C2E7946446026O00184003113O0052756E6963506F77657244656669636974026O003E4003093O0042752O66537461636B030F3O004665737465726D6967687442752O66026O003440025O00C6AF40025O00D2A34003083O0045706964656D696303093O004973496E52616E6765025O0049B040025O00B8AF4003143O00435CC8A7F3C52O4F81A2F9CD794ED4B1E5DC061E03063O00A8262CA1C396025O00805540025O00F08240030C3O004361737454617267657449662O033O008DFD9A03083O0076E09CE2165088D603193O0055E14C8E46D14A9047E05D8550AE588F47D15B9550FD4DC01603043O00E0228E39025O00206340025O002AA340025O00E8A440025O0083B04003083O00FBB7CCD976FC540D03083O006EBEC7A5BD13913D026O002440025O00B07140025O000EA640025O0092B040025O00E0764003143O00DFFB7EEC8ECAD3E837E984C2E5E962FA98D39ABD03063O00A7BA8B1788EB025O0068B24003093O003EB08919129687041603043O006D7AD5E803083O00CBE7AB34EBFAAB3303043O00508E97C203093O004465617468436F696C03163O0007C376580BF974430ACA374D0CC3484E16D46458439E03043O002C63A617000A012O00129E3O00014O0008000100013O00261E3O0006000100010004BF3O00060001002E05000200FEFF2O00030004BF3O0002000100129E000100013O0026FC00010022000100040004BF3O002200012O00D400025O0020B10002000200052O003900020002000200064D00020010000100010004BF3O00100001002EAA000700092O0100060004BF3O00092O012O00D4000200013O0020210102000200084O00038O000400056O000600023O00202O0006000600094O00088O0006000800024O000600066O00020006000200062O000200092O013O0004BF3O00092O012O00D4000200033O00129D0003000A3O00122O0004000B6O000200046O00025O00044O00092O01002E31010C00A40001000D0004BF3O00A400010026FC000100A4000100010004BF3O00A4000100129E000200014O0008000300033O0026FC00020028000100010004BF3O0028000100129E000300013O000E162O01002F000100030004BF3O002F0001002E05000E00700001000F0004BF3O009D00012O00D4000400044O0072000500033O00122O000600103O00122O000700116O0005000700024O00040004000500202O0004000400054O00040002000200062O0004006700013O0004BF3O006700012O00D4000400044O0072000500033O00122O000600123O00122O000700136O0005000700024O00040004000500202O0004000400144O00040002000200062O0004005500013O0004BF3O005500012O00D4000400053O0020B10004000400152O003900040002000200261800040055000100160004BF3O005500012O00D4000400044O0072000500033O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400144O00040002000200062O0004006700013O0004BF3O006700012O00D4000400063O0026FC00040067000100010004BF3O006700012O00D4000400073O00064D00040067000100010004BF3O006700012O00D4000400083O000E1A00190069000100040004BF3O006900012O00D4000400053O0020B100040004001A2O0039000400020002002618000400690001001B0004BF3O006900012O00D4000400053O002O2001040004001C4O000600043O00202O00060006001D4O00040006000200262O000400690001001E0004BF3O00690001002E31011F007E000100200004BF3O007E00012O00D4000400013O0020C40004000400084O000500043O00202O0005000500214O000600096O000700076O000800023O00202O00080008002200122O000A001B6O0008000A00024O000800086O00040008000200062O00040079000100010004BF3O00790001002E310123007E000100240004BF3O007E00012O00D4000400033O00129E000500253O00129E000600264O0086000400064O004400046O00D400045O0020B10004000400052O003900040002000200064D00040085000100010004BF3O00850001002E310128009C000100270004BF3O009C00012O00D40004000A3O00202C0004000400294O00058O0006000B6O000700033O00122O0008002A3O00122O0009002B6O0007000900024O0008000C6O0009000D6O000A00023O0020B1000A000A00092O0021000C8O000A000C00024O000A000A6O0004000A000200062O0004009C00013O0004BF3O009C00012O00D4000400033O00129E0005002C3O00129E0006002D4O0086000400064O004400045O00129E000300163O0026FC0003002B000100160004BF3O002B000100129E000100163O0004BF3O00A400010004BF3O002B00010004BF3O00A400010004BF3O002800010026FC00010007000100160004BF3O0007000100129E000200013O00261E000200AB000100160004BF3O00AB0001002E31012F00AD0001002E0004BF3O00AD000100129E000100043O0004BF3O0007000100261E000200B1000100010004BF3O00B10001002E31013100A7000100300004BF3O00A700012O00D4000300044O0072000400033O00122O000500323O00122O000600336O0004000600024O00030003000400202O0003000300054O00030002000200062O000300C100013O0004BF3O00C100012O00D4000300073O000685000300C300013O0004BF3O00C300012O00D40003000E3O002618000300C3000100340004BF3O00C30001002E31013600D8000100350004BF3O00D80001002EAA003800D8000100370004BF3O00D800012O00D4000300013O00200A0003000300084O000400043O00202O0004000400214O000500096O000600066O000700023O00202O00070007002200122O0009001B6O0007000900024O000700076O00030007000200062O000300D800013O0004BF3O00D800012O00D4000300033O00129E000400393O00129E0005003A4O0086000300054O004400035O002E05003B002C0001003B0004BF3O00042O012O00D4000300044O0072000400033O00122O0005003C3O00122O0006003D6O0004000600024O00030003000400202O0003000300054O00030002000200062O000300042O013O0004BF3O00042O012O00D4000300073O00064D000300042O0100010004BF3O00042O012O00D4000300044O0031000400033O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O0003000300144O00030002000200062O000300042O0100010004BF3O00042O012O00D4000300013O0020570003000300084O000400043O00202O0004000400404O000500066O000700023O00202O0007000700094O000900043O00202O0009000900404O0007000900024O000700076O00030007000200062O000300042O013O0004BF3O00042O012O00D4000300033O00129E000400413O00129E000500424O0086000300054O004400035O00129E000200163O0004BF3O00A700010004BF3O000700010004BF3O00092O010004BF3O000200012O000E012O00017O007C3O00028O00025O000EAA40025O0060A740025O00289740025O00D09640026O00F03F025O00606540025O0053B240030F3O0018AA4315C9EC0F2DA14316ECEB033B03073O006E59C82C78A082030A3O0049734361737461626C6503043O0052756E65027O0040026O002440030B3O008DC6585246583644ACCB5F03083O002DCBA32B26232A5B030B3O004973417661696C61626C6503063O0042752O665570030F3O004665737465726D6967687442752O66030B3O0042752O6652656D61696E73026O002840025O00FAA040025O00E8B24003053O005072652O73030F3O0041626F6D696E6174696F6E4C696D6203093O004973496E52616E6765026O003440025O0058AE40025O0008954003203O00D387D32E8EA755C68CD32DB8A55DDF879C2288AC6BD18AD32F83A643DC969C7503073O0034B2E5BC43E7C9025O0040AA40030A4O00515F07F6503A31525503073O004341213064973C03073O0049735265616479030C3O00436173745461726765744966030A3O0041706F63616C797073652O033O00D2EEA003053O0093BF87CEB8031A3O008538A9C2D95FAB943BA381D95CB7BB2BA9CED457BD9326B5818003073O00D2E448C6A1B833025O00E89040026O00A640026O001040030F3O007C54771A46537D0B465478384E566003043O00682F351403083O0042752O66446F776E03123O004461726B5472616E73666F726D6174696F6E03123O00874D9317881DA242921AB31DAE4D9515B30103063O006FC32CE17CDC030F3O00432O6F6C646F776E52656D61696E73026O0018402O033O00474344025O00ECAD40025O00E8B040030F3O00536163726966696369616C5061637403213O00CB470361A2ADD1450972A794C8470367EBAAD7433F702OA4D4420F64A5B898175803063O00CBB8266013CB026O000840025O002C9140025O0092B240025O0007B340025O001CB34003123O00735916D5634A05D0445E0BCC5A5910D7585603043O00BE373864030D3O007FA13A1B10F7F6528C301F04F003073O009336CF5C7E738303143O002B342669086C043F324A026B033511780F6B0B3703063O001E6D51551D6D030F3O0041757261416374697665436F756E74030D3O00C97858B315D1F2EB7053BF39D003073O009C9F1134D656BE030D3O0087E1BBB9ADFB2OB88DE3BCABBD03043O00DCCE8FDD03243O00827C3F1CE7D8C087733E11D7DEDF87692418D68CD389781214D7C3DE82723A19CB8C83D203073O00B2E61D4D77B8AC03113O00D0B31A1460FDE78C1F1572CFF0BF1A147903063O009895DE6A7B17025O00B2A240025O0080994003113O00456D706F77657252756E65576561706F6E03243O00D82BE64CA2D834C951A0D323C954B0DC36F94DF5DC29F37CB6D229FA47BACA28E503E48B03053O00D5BD469623025O00DCA240025O00C09840030D3O000347FB1F7FD7175AE01166C22203063O00AE5629937013030D3O00556E686F6C79412O7361756C742O033O0056098303083O00CB3B60ED6B456F71031F3O003118A4EE3DE9E82505BFE024FCC36417A3E40EF3D82B1AA8EE26FEC46447FC03073O00B74476CC815190025O00DAA140025O0032A04003093O003CAC79F70EA60BAC7403063O00E26ECD10846B030D3O004973446561644F7247686F737403083O00497341637469766503093O00526169736544656164025O009CA640025O00DEA54003283O00F9C2E9CA44D4C7E5D845ABC2EFDC7EE8CCEFD545E4D4EECA01BA91A0DD48F8D3ECD858F8D7F9D54403053O00218BA380B9025O00EC9340025O002AAC40026O006E40025O00989240030D3O00C50A2515A1571662F204201F8C03083O001693634970E23878030D3O0056696C65436F6E746167696F6E2O033O00B574FA03053O00EDD8158295030E3O0049735370652O6C496E52616E6765025O00D88340025O00A2A140031E3O009447535A8FCA518C5A5E58B9C650C24F505A8FCA518D425B50A7C74DC21C03073O003EE22E2O3FD0A9025O00A49E40025O00B08040030E3O00D60C588E1003085FF71E5A9A130803083O003E857935E37F6D4F030E3O0053752O6D6F6E476172676F796C65031F3O0003013FF8D9A09D171520F2D9B7AE155433FAD391A11F1B3EF1D9B9AC03546603073O00C270745295B6CE00BE012O00129E3O00014O0008000100013O002E3101030002000100020004BF3O000200010026FC3O0002000100010004BF3O0002000100129E000100013O002E3101050077000100040004BF3O007700010026FC00010077000100060004BF3O0077000100129E000200013O00261E00020010000100010004BF3O00100001002E3101080070000100070004BF3O007000012O00D400036O0072000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003A00013O0004BF3O003A00012O00D4000300023O0020B100030003000C2O00390003000200020026180003003C0001000D0004BF3O003C00012O00D4000300033O000E38010E003C000100030004BF3O003C00012O00D400036O0072000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O0003003C00013O0004BF3O003C00012O00D4000300023O0020EE0003000300124O00055O00202O0005000500134O00030005000200062O0003003A00013O0004BF3O003A00012O00D4000300023O0020E50003000300144O00055O00202O0005000500134O00030005000200262O0003003C000100150004BF3O003C0001002EAA00170050000100160004BF3O005000012O00D4000300043O0020F20003000300184O00045O00202O0004000400194O000500056O000600053O00202O00060006001A00122O0008001B6O0006000800024O000600066O00030006000200064D0003004B000100010004BF3O004B0001002EAA001C00500001001D0004BF3O005000012O00D4000300013O00129E0004001E3O00129E0005001F4O0086000300054O004400035O002E050020001F000100200004BF3O006F00012O00D400036O0072000400013O00122O000500213O00122O000600226O0004000600024O00030003000400202O0003000300234O00030002000200062O0003006F00013O0004BF3O006F00012O00D4000300063O0020D80003000300244O00045O00202O0004000400254O000500076O000600013O00122O000700263O00122O000800276O0006000800024O000700086O000800096O00030008000200062O0003006F00013O0004BF3O006F00012O00D4000300013O00129E000400283O00129E000500294O0086000300054O004400035O00129E000200063O002E31012A000C0001002B0004BF3O000C00010026FC0002000C000100060004BF3O000C000100129E0001000D3O0004BF3O007700010004BF3O000C00010026FC000100AA0001002C0004BF3O00AA00012O00D400026O0072000300013O00122O0004002D3O00122O0005002E6O0003000500024O00020002000300202O0002000200234O00020002000200062O0002009A00013O0004BF3O009A00012O00D40002000A3O0020EE00020002002F4O00045O00202O0004000400304O00020004000200062O0002009400013O0004BF3O009400012O00D400026O00C6000300013O00122O000400313O00122O000500326O0003000500024O0002000200030020B10002000200332O0039000200020002000E380134009C000100020004BF3O009C00012O00D40002000B4O00D4000300023O0020B10003000300352O00390003000200020006030102009C000100030004BF3O009C0001002E31013700BD2O0100360004BF3O00BD2O012O00D4000200043O0020300002000200184O00035O00202O0003000300384O0004000C6O00020004000200062O000200BD2O013O0004BF3O00BD2O012O00D4000200013O00129D000300393O00122O0004003A6O000200046O00025O00044O00BD2O0100261E000100AE0001003B0004BF3O00AE0001002E31013D00162O01003C0004BF3O00162O01002E31013E00F50001003F0004BF3O00F500012O00D400026O0072000300013O00122O000400403O00122O000500416O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200F500013O0004BF3O00F500012O00D40002000D3O0020B10002000200332O00390002000200020026E8000200DE0001000E0004BF3O00DE00012O00D400026O0072000300013O00122O000400423O00122O000500436O0003000500024O00020002000300202O0002000200114O00020002000200062O000200DE00013O0004BF3O00DE00012O00D400026O00C6000300013O00122O000400443O00122O000500456O0003000500024O0002000200030020B10002000200462O00390002000200022O00D40003000E3O000603010200E8000100030004BF3O00E800012O00D400026O0072000300013O00122O000400473O00122O000500486O0003000500024O00020002000300202O0002000200114O00020002000200062O000200E800013O0004BF3O00E800012O00D400026O0031000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200F5000100010004BF3O00F500012O00D4000200043O0020300002000200184O00035O00202O0003000300304O0004000F6O00020004000200062O000200F500013O0004BF3O00F500012O00D4000200013O00129E0003004B3O00129E0004004C4O0086000200044O004400026O00D400026O0072000300013O00122O0004004D3O00122O0005004E6O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200062O013O0004BF3O00062O012O00D40002000A3O0020150102000200124O00045O00202O0004000400304O00020004000200062O000200082O0100010004BF3O00082O01002E31014F00152O0100500004BF3O00152O012O00D4000200043O0020300002000200184O00035O00202O0003000300514O000400106O00020004000200062O000200152O013O0004BF3O00152O012O00D4000200013O00129E000300523O00129E000400534O0086000200044O004400025O00129E0001002C3O0026FC000100682O01000D0004BF3O00682O0100129E000200013O002E0500540006000100540004BF3O001F2O01000E3C0106001F2O0100020004BF3O001F2O0100129E0001003B3O0004BF3O00682O01002E05005500FAFF2O00550004BF3O00192O01000E3C2O0100192O0100020004BF3O00192O012O00D400036O0072000400013O00122O000500563O00122O000600576O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300412O013O0004BF3O00412O012O00D4000300063O0020950003000300244O00045O00202O0004000400584O000500076O000600013O00122O000700593O00122O0008005A6O0006000800024O000700086O000800114O00D4000900124O0012010300090002000685000300412O013O0004BF3O00412O012O00D4000300013O00129E0004005B3O00129E0005005C4O0086000300054O004400035O002EAA005E00662O01005D0004BF3O00662O012O00D400036O0072000400013O00122O0005005F3O00122O000600606O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300662O013O0004BF3O00662O012O00D40003000A3O0020B10003000300612O003900030002000200064D000300572O0100010004BF3O00572O012O00D40003000A3O0020B10003000300622O003900030002000200064D000300662O0100010004BF3O00662O012O00D4000300043O0020A40003000300184O00045O00202O0004000400634O000500056O00030005000200062O000300612O0100010004BF3O00612O01002EAA006400662O0100650004BF3O00662O012O00D4000300013O00129E000400663O00129E000500674O0086000300054O004400035O00129E000200063O0004BF3O00192O0100261E0001006C2O0100010004BF3O006C2O01002EAA00690007000100680004BF3O0007000100129E000200013O0026FC000200712O0100060004BF3O00712O0100129E000100063O0004BF3O000700010026FC0002006D2O0100010004BF3O006D2O01002EAA006A009F2O01006B0004BF3O009F2O012O00D400036O0072000400013O00122O0005006C3O00122O0006006D6O0004000600024O00030003000400202O0003000300234O00030002000200062O0003009F2O013O0004BF3O009F2O012O00D40003000D3O0020B10003000300332O00390003000200020026E80003009F2O01003B0004BF3O009F2O012O00D4000300063O0020DF0003000300244O00045O00202O00040004006E4O000500076O000600013O00122O0007006F3O00122O000800706O0006000800024O000700086O000800136O000900053O00202O0009000900714O000B5O00202O000B000B006E4O0009000B00024O000900096O00030009000200062O0003009A2O0100010004BF3O009A2O01002EAA0073009F2O0100720004BF3O009F2O012O00D4000300013O00129E000400743O00129E000500754O0086000300054O004400035O002EAA007700B82O0100760004BF3O00B82O012O00D400036O0072000400013O00122O000500783O00122O000600796O0004000600024O00030003000400202O0003000300234O00030002000200062O000300B82O013O0004BF3O00B82O012O00D4000300043O0020300003000300184O00045O00202O00040004007A4O000500146O00030005000200062O000300B82O013O0004BF3O00B82O012O00D4000300013O00129E0004007B3O00129E0005007C4O0086000300054O004400035O00129E000200063O0004BF3O006D2O010004BF3O000700010004BF3O00BD2O010004BF3O000200012O000E012O00017O005A3O00028O00025O00806840025O009EA740026O00F03F026O00A040025O00CEA740025O00B07940025O0034A74003083O00264FCAFF0652CAF803043O009B633FA303073O0049735265616479026O002440025O00809440025O00D2A54003053O005072652O7303083O0045706964656D696303093O004973496E52616E6765026O003E4003143O0087C1A889BC898BD2E18CB681BDC2A499AC94C28703063O00E4E2B1C1EDD9030F3O0012B530F231A22AE8338337F43DBB2603043O008654D04303143O0035A9954816BE8F52149B89491DA8A25911B9805A03043O003C73CCE6030F3O0041757261416374697665436F756E74025O00E8A040025O0098AA40030C3O00436173745461726765744966030F3O00466573746572696E67537472696B652O033O00EA33E503043O0010875A8B031C3O00527115274B46715A7339205A46715F71463241512O477112265E142003073O0018341466532E34025O00E09040025O00CCA640027O0040030F3O00E22A32300AD6262F233CD03D282F0A03053O006FA44F4144030A3O00E7C98CDD2FE6DFC990DB03063O008AA6B9E3BE4E030F3O00432O6F6C646F776E52656D61696E732O033O00C675DD03073O0079AB14A5573243031D3O00C03DAA22BC10CF36BE09AA16D431B233F903C93D8625BC16D328F967E903063O0062A658D956D903093O00D2F378158EFFF9FF7503063O00BC2O961961E603083O00FF99560609E0D38A03063O008DBAE93F626C030B3O004973417661696C61626C65025O00C4AA40025O00D49B4003093O004465617468436F696C030E3O0049735370652O6C496E52616E6765025O0018B140025O00CCAF4003173O00F5EF2DA22DCEE923BF29B1EB23B31AE2EF38A335B1BB7E03053O0045918A4CD6025O00288940025O0042B040025O0028B340025O00BAA340025O0023B240030D3O001B666B52DA307D7E72C12B766A03053O00AE5913192103143O000917415AF2950221156541E2890F0B17505BF18103073O006B4F72322E97E703143O001FA3A63D8F2BBECE3E91BA3C843D93C53B2OB32F03083O00A059C6D549EA59D7026O002040025O001EAF40025O00F89140025O00C4AF40025O0097B04003133O00497FAD2OC14675F4FFCA4D4EA7FBD15D61F4AC03053O00A52811D49E030F3O00C3DC1B2723F7D0063415F1CB01382303053O004685B9685303143O002240573ECC164C4A2DFE0B504A2EED0147512CCF03053O00A96425244A030D3O002292B043148EAC573388B0551303043O003060E7C2025O00989640025O000881402O033O00C5530003083O00E3A83A6E4D79B8CF025O00408340025O00E06840031C3O007D39AC54B4C978AB7C03AC54A3D27AA03B3DB0458EC874B16E2CFF1403083O00C51B5CDF20D1BB11005B012O00129E3O00014O0008000100013O0026FC3O0002000100010004BF3O0002000100129E000100013O002E3101020075000100030004BF3O007500010026FC00010075000100040004BF3O0075000100129E000200014O0008000300033O0026FC0002000B000100010004BF3O000B000100129E000300013O002E310105006C000100060004BF3O006C00010026FC0003006C000100010004BF3O006C000100129E000400013O0026FC00040017000100040004BF3O0017000100129E000300043O0004BF3O006C000100261E0004001B000100010004BF3O001B0001002E3101080013000100070004BF3O001300012O00D400056O0072000600013O00122O000700093O00122O0008000A6O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005004000013O0004BF3O004000012O00D4000500023O0006850005002B00013O0004BF3O002B00012O00D4000500033O0026E8000500400001000C0004BF3O00400001002E31010D00400001000E0004BF3O004000012O00D4000500043O00200A00050005000F4O00065O00202O0006000600104O000700056O000800086O000900063O00202O00090009001100122O000B00126O0009000B00024O000900096O00050009000200062O0005004000013O0004BF3O004000012O00D4000500013O00129E000600133O00129E000700144O0086000500074O004400056O00D400056O0072000600013O00122O000700153O00122O000800166O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005005500013O0004BF3O005500012O00D400056O00C6000600013O00122O000700173O00122O000800186O0006000800024O0005000500060020B10005000500192O00390005000200022O00D4000600073O00060301050057000100060004BF3O00570001002E31011B006A0001001A0004BF3O006A00012O00D4000500083O0020B500050005001C4O00065O00202O00060006001D4O000700096O000800013O00122O0009001E3O00122O000A001F6O0008000A00024O0009000A6O000A000A4O00120105000A00020006850005006A00013O0004BF3O006A00012O00D4000500013O00129E000600203O00129E000700214O0086000500074O004400055O00129E000400043O0004BF3O00130001002E310122000E000100230004BF3O000E00010026FC0003000E000100040004BF3O000E000100129E000100243O0004BF3O007500010004BF3O000E00010004BF3O007500010004BF3O000B00010026FC000100CE000100240004BF3O00CE00012O00D400026O0072000300013O00122O000400253O00122O000500266O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002009F00013O0004BF3O009F00012O00D400026O00C6000300013O00122O000400273O00122O000500286O0003000500024O0002000200030020B10002000200292O00390002000200022O00D40003000B3O0006160002009F000100030004BF3O009F00012O00D4000200083O0020D800020002001C4O00035O00202O00030003001D4O000400096O000500013O00122O0006002A3O00122O0007002B6O0005000700024O0006000A6O0007000C6O00020007000200062O0002009F00013O0004BF3O009F00012O00D4000200013O00129E0003002C3O00129E0004002D4O0086000200044O004400026O00D400026O0072000300013O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200B600013O0004BF3O00B600012O00D4000200023O00064D000200B6000100010004BF3O00B600012O00D400026O0072000300013O00122O000400303O00122O000500316O0003000500024O00020002000300202O0002000200324O00020002000200062O000200B800013O0004BF3O00B80001002E310133005A2O0100340004BF3O005A2O012O00D4000200043O00201401020002000F4O00035O00202O0003000300354O000400056O000600063O00202O0006000600364O00085O00202O0008000800354O0006000800024O000600066O00020006000200062O000200C8000100010004BF3O00C80001002E310137005A2O0100380004BF3O005A2O012O00D4000200013O00129D000300393O00122O0004003A6O000200046O00025O00044O005A2O0100261E000100D2000100010004BF3O00D20001002EAA003C00050001003B0004BF3O0005000100129E000200014O0008000300033O0026FC000200D4000100010004BF3O00D4000100129E000300013O002E05003D00790001003D0004BF3O00502O010026FC000300502O0100010004BF3O00502O0100129E000400013O00261E000400E0000100040004BF3O00E00001002EAA003F00E20001003E0004BF3O00E2000100129E000300043O0004BF3O00502O010026FC000400DC000100010004BF3O00DC00012O00D40005000D3O0020B100050005000B2O0039000500020002000685000500082O013O0004BF3O00082O012O00D400056O0072000600013O00122O000700403O00122O000800416O0006000800024O00050005000600202O0005000500324O00050002000200062O0005000A2O013O0004BF3O000A2O012O00D400056O00C6000600013O00122O000700423O00122O000800436O0006000800024O0005000500060020B10005000500192O00390005000200022O00D4000600073O0006900005000A2O0100060004BF3O000A2O012O00D400056O00C6000600013O00122O000700443O00122O000800456O0006000800024O0005000500060020B10005000500192O0039000500020002000E1A0046000A2O0100050004BF3O000A2O01002EAA004700182O0100480004BF3O00182O01002EAA004900182O01004A0004BF3O00182O012O00D4000500043O0020DE00050005000F4O0006000E6O0007000F6O00050007000200062O000500182O013O0004BF3O00182O012O00D4000500013O00129E0006004B3O00129E0007004C4O0086000500074O004400056O00D400056O0072000600013O00122O0007004D3O00122O0008004E6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500372O013O0004BF3O00372O012O00D400056O00C6000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500060020B10005000500192O00390005000200022O00D4000600073O000616000500372O0100060004BF3O00372O012O00D400056O0031000600013O00122O000700513O00122O000800526O0006000800024O00050005000600202O0005000500324O00050002000200062O000500392O0100010004BF3O00392O01002EAA0053004E2O0100540004BF3O004E2O012O00D4000500083O00207100050005001C4O00065O00202O00060006001D4O000700096O000800013O00122O000900553O00122O000A00566O0008000A00024O0009000A6O000A000A6O0005000A000200062O000500492O0100010004BF3O00492O01002E0500570007000100580004BF3O004E2O012O00D4000500013O00129E000600593O00129E0007005A4O0086000500074O004400055O00129E000400043O0004BF3O00DC00010026FC000300D7000100040004BF3O00D7000100129E000100043O0004BF3O000500010004BF3O00D700010004BF3O000500010004BF3O00D400010004BF3O000500010004BF3O005A2O010004BF3O000200012O000E012O00017O00793O00028O00026O000840025O0020B140025O00D0A140025O00D4B140025O00B08240030D3O009AC5C9C1A3D2E0DDBCCAD4C2BB03043O00AECFABA103073O0049735265616479025O0046AD40030C3O00436173745461726765744966030D3O00556E686F6C79412O7361756C742O033O00E0F72O03063O00B78D9E6D9398031B3O003907EE032010D90D3F1AE719201DA60F2306EA08231EE81F6C58B203043O006C4C6986025O0062AE40025O009EB240030A3O00D8CAA4EDFCEEC4A1E4DC03053O00AE8BA5D181026O00F03F03073O0054696D65546F58025O00804140026O00144003103O004865616C746850657263656E7461676503093O0054696D65546F44696503053O005072652O73030A3O00536F756C526561706572030E3O0049735370652O6C496E52616E676503183O00B0BCF7CDF9117579B3B6F081C50C7F74A7BCF5CFD543212E03083O0018C3D382A1A66310025O0088A440025O0040A340026O001040025O00FAA840025O006EA740025O00C08D40025O00C05140030E3O0043DA2O84B01857CE9B8EB00F7CCA03063O007610AF2OE9DF030A3O0049734361737461626C6503063O0042752O66557003163O00436F2O6D616E6465726F667468654465616442752O6603123O00A88B38B6EF85798E963ABDFA8378AF8134BF03073O001DEBE455DB8EEB030B3O004973417661696C61626C65025O0056A240025O00707A40030E3O0053752O6D6F6E476172676F796C65031B3O002EC1B7D0784018553CC6BDD26E4222123EDBB5D17341305C2E94E803083O00325DB4DABD172E47025O0085B340025O00A7B24003093O00ECA5525F41F84DDFA003073O0028BEC43B2C24BC030D3O004973446561644F7247686F737403083O00497341637469766503093O0052616973654465616403233O002E44D5A7FF42093944D8F4F972023041D3A3F46E4D6805D8BDE96D013D5CCFA0E3710803073O006D5C25BCD49A1D025O000AAA40025O0068AC40030A3O00750CFC2061134713EC3E03063O00762663894C33027O0040025O00F4AC40025O00B2A2402O033O00F02F0B03063O00409D4665726903183O0053A7B2EF2F52ADA6F31552E8A4EC1F4CACA8F41E53E8F6BB03053O007020C8C78303113O000839B5D361AAC5B4383AA0EB73AEC7892303083O00E64D54C5BC16CFB7026O003740030E3O00CA01CBF183AFD734EB13C9E580A403083O00559974A69CECC190030F3O0085F240AAEB06B0E84897E50DAAE54903063O0060C4802DD384030E3O0006987652DDA193D9278A7446DEAA03083O00B855ED1B3FB2CFD4030F3O00294B0446075F1D570D7D0852065C0D03043O003F68396903123O004461726B5472616E73666F726D6174696F6E030E3O003892A949048983451980AB5D078203043O00246BE7C4026O00354003113O00456D706F77657252756E65576561706F6E03203O0058B8B2884A2OB0B84FA0AC8262A2A7864DBAACC75EBAAD8B59BAB5894EF5F3D703043O00E73DD5C2030F3O0028AF327E00A33C6700A2335F00A03F03043O001369CD5D03043O0052756E65030F3O0041626F6D696E6174696F6E4C696D62031D3O00A80AD18C36A709CA8830A737D28832AB48DD8E30A50CD19631BA488FD303053O005FC968BEE1025O00709B40025O003EAD40025O004CA440025O0028A94003123O0020EEB6C8054805E1B7C53E4809EEB0CA3E5403063O003A648FC4A351030A3O003B522CA03E45FC1E094703083O006E7A2243C35F2985030F3O00432O6F6C646F776E52656D61696E73025O0062B340025O00B8AC40031F3O0071B04941E961A35A44C573BE4947D761B854449676BE5446D27AA65559962303053O00B615D13B2A030A3O009647CA1E20B2AE47D61803063O00DED737A57D41025O0016AB40025O007AA940025O00D49640025O000AA240030A3O0041706F63616C797073652O033O0021D0DE03083O002A4CB1A67A92A18D03163O00A49A0ACD787ABC9A16CB3975AA8509CA7661AB99459603063O0016C5EA65AE19025O003DB240025O00F07F4000F2012O00129E3O00014O0008000100013O0026FC3O0002000100010004BF3O0002000100129E000100013O00261E00010009000100020004BF3O00090001002E3101030071000100040004BF3O0071000100129E000200014O0008000300033O0026FC0002000B000100010004BF3O000B000100129E000300013O002EAA00060068000100050004BF3O006800010026FC00030068000100010004BF3O006800012O00D400046O0072000500013O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O00040002000200062O0004003500013O0004BF3O003500012O00D4000400023O0006850004003500013O0004BF3O00350001002E05000A00160001000A0004BF3O003500012O00D4000400033O00203D00040004000B4O00055O00202O00050005000C4O000600046O000700013O00122O0008000D3O00122O0009000E6O0007000900024O000800056O000900096O000A00066O0004000A000200062O0004003500013O0004BF3O003500012O00D4000400013O00129E0005000F3O00129E000600104O0086000400064O004400045O002EAA00110067000100120004BF3O006700012O00D400046O0072000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O0004000400094O00040002000200062O0004006700013O0004BF3O006700012O00D4000400073O0026FC00040067000100150004BF3O006700012O00D4000400083O0020B100040004001600129E000600174O00120104000600020026180004004F000100180004BF3O004F00012O00D4000400083O0020B10004000400192O003900040002000200266400040067000100170004BF3O006700012O00D4000400083O0020B100040004001A2O0039000400020002000E7A00180067000100040004BF3O006700012O00D4000400093O00205700040004001B4O00055O00202O00050005001C4O000600076O000800083O00202O00080008001D4O000A5O00202O000A000A001C4O0008000A00024O000800086O00040008000200062O0004006700013O0004BF3O006700012O00D4000400013O00129E0005001E3O00129E0006001F4O0086000400064O004400045O00129E000300153O002EAA0021000E000100200004BF3O000E00010026FC0003000E000100150004BF3O000E000100129E000100223O0004BF3O007100010004BF3O000E00010004BF3O007100010004BF3O000B000100261E00010075000100010004BF3O00750001002E31012300CF000100240004BF3O00CF000100129E000200013O00261E0002007A000100010004BF3O007A0001002E31012500C8000100260004BF3O00C800012O00D400036O0072000400013O00122O000500273O00122O000600286O0004000600024O00030003000400202O0003000300294O00030002000200062O000300A400013O0004BF3O00A400012O00D40003000A3O00201501030003002A4O00055O00202O00050005002B4O00030005000200062O00030095000100010004BF3O009500012O00D400036O0031000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400202O00030003002E4O00030002000200062O000300A4000100010004BF3O00A40001002E31013000A40001002F0004BF3O00A400012O00D4000300093O00203000030003001B4O00045O00202O0004000400314O0005000B6O00030005000200062O000300A400013O0004BF3O00A400012O00D4000300013O00129E000400323O00129E000500334O0086000300054O004400035O002E31013500C7000100340004BF3O00C700012O00D400036O0072000400013O00122O000500363O00122O000600376O0004000600024O00030003000400202O0003000300294O00030002000200062O000300C700013O0004BF3O00C700012O00D40003000C3O0020B10003000300382O003900030002000200064D000300BA000100010004BF3O00BA00012O00D40003000C3O0020B10003000300392O003900030002000200064D000300C7000100010004BF3O00C700012O00D4000300093O0020E300030003001B4O00045O00202O00040004003A4O000500056O00030005000200062O000300C700013O0004BF3O00C700012O00D4000300013O00129E0004003B3O00129E0005003C4O0086000300054O004400035O00129E000200153O002EAA003D00760001003E0004BF3O007600010026FC00020076000100150004BF3O0076000100129E000100153O0004BF3O00CF00010004BF3O007600010026FC000100FA000100220004BF3O00FA00012O00D400026O0072000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300202O0002000200094O00020002000200062O000200F12O013O0004BF3O00F12O012O00D4000200073O000E04004100F12O0100020004BF3O00F12O01002E31014300F12O0100420004BF3O00F12O012O00D4000200033O0020B000020002000B4O00035O00202O00030003001C4O000400046O000500013O00122O000600443O00122O000700456O0005000700024O0006000D6O0007000E6O000800083O00202O00080008001D4O000A5O00202O000A000A001C4O0008000A00024O000800086O00020008000200062O000200F12O013O0004BF3O00F12O012O00D4000200013O00129D000300463O00122O000400476O000200046O00025O00044O00F12O01000E3C0141008D2O0100010004BF3O008D2O0100129E000200013O000E3C2O0100882O0100020004BF3O00882O012O00D400036O0072000400013O00122O000500483O00122O000600496O0004000600024O00030003000400202O0003000300294O00030002000200062O000300682O013O0004BF3O00682O012O00D4000300023O000685000300582O013O0004BF3O00582O012O00D40003000F3O000685000300122O013O0004BF3O00122O012O00D4000300103O0026350103005B2O01004A0004BF3O005B2O012O00D400036O0031000400013O00122O0005004B3O00122O0006004C6O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003002C2O0100010004BF3O002C2O012O00D400036O0072000400013O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003002C2O013O0004BF3O002C2O012O00D4000300113O0006850003002C2O013O0004BF3O002C2O012O00D4000300123O00064D0003005B2O0100010004BF3O005B2O012O00D400036O0031000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003002E4O00030002000200062O000300472O0100010004BF3O00472O012O00D400036O0031000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O00030003002E4O00030002000200062O000300472O0100010004BF3O00472O012O00D40003000C3O00201501030003002A4O00055O00202O0005000500534O00030005000200062O0003005B2O0100010004BF3O005B2O012O00D400036O0031000400013O00122O000500543O00122O000600556O0004000600024O00030003000400202O00030003002E4O00030002000200062O000300582O0100010004BF3O00582O012O00D40003000C3O00201501030003002A4O00055O00202O0005000500534O00030005000200062O0003005B2O0100010004BF3O005B2O012O00D4000300133O002664000300682O0100560004BF3O00682O012O00D4000300093O00203000030003001B4O00045O00202O0004000400574O000500146O00030005000200062O000300682O013O0004BF3O00682O012O00D4000300013O00129E000400583O00129E000500594O0086000300054O004400036O00D400036O0072000400013O00122O0005005A3O00122O0006005B6O0004000600024O00030003000400202O0003000300294O00030002000200062O000300872O013O0004BF3O00872O012O00D40003000A3O0020B100030003005C2O00390003000200020026E8000300872O0100020004BF3O00872O012O00D4000300023O000685000300872O013O0004BF3O00872O012O00D4000300093O0020E300030003001B4O00045O00202O00040004005D4O000500056O00030005000200062O000300872O013O0004BF3O00872O012O00D4000300013O00129E0004005E3O00129E0005005F4O0086000300054O004400035O00129E000200153O0026FC000200FD000100150004BF3O00FD000100129E000100023O0004BF3O008D2O010004BF3O00FD00010026FC00010005000100150004BF3O0005000100129E000200013O002EAA006000E92O0100610004BF3O00E92O01000E3C2O0100E92O0100020004BF3O00E92O0100129E000300013O002E31016200E22O0100630004BF3O00E22O01000E3C2O0100E22O0100030004BF3O00E22O012O00D400046O0072000500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O0004000400294O00040002000200062O000400AD2O013O0004BF3O00AD2O012O00D400046O00C6000500013O00122O000600663O00122O000700676O0005000700024O0004000400050020B10004000400682O0039000400020002002618000400AF2O0100180004BF3O00AF2O01002E31016900BC2O01006A0004BF3O00BC2O012O00D4000400093O00203000040004001B4O00055O00202O0005000500534O000600156O00040006000200062O000400BC2O013O0004BF3O00BC2O012O00D4000400013O00129E0005006B3O00129E0006006C4O0086000400064O004400046O00D400046O0072000500013O00122O0006006D3O00122O0007006E6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400C92O013O0004BF3O00C92O012O00D4000400023O00064D000400CB2O0100010004BF3O00CB2O01002EAA006F00E12O0100700004BF3O00E12O01002E31017100E12O0100720004BF3O00E12O012O00D4000400033O00209500040004000B4O00055O00202O0005000500734O000600046O000700013O00122O000800743O00122O000900756O0007000900024O000800056O000900164O00D4000A00174O00120104000A0002000685000400E12O013O0004BF3O00E12O012O00D4000400013O00129E000500763O00129E000600774O0086000400064O004400045O00129E000300153O00261E000300E62O0100150004BF3O00E62O01002EAA007800952O0100790004BF3O00952O0100129E000200153O0004BF3O00E92O010004BF3O00952O010026FC000200902O0100150004BF3O00902O0100129E000100413O0004BF3O000500010004BF3O00902O010004BF3O000500010004BF3O00F12O010004BF3O000200012O000E012O00017O00833O00028O00025O007EB040025O00309D40026O00F03F025O0024A840025O00805940025O0039B040025O00C49740027O0040026O000840025O00206F40025O00C05640025O0004B240025O003C9C40026O003740025O00C88340025O0066B14003113O00C0B0473FD831F78F423ECA03E0BC473FC103063O005485DD3750AF030A3O0049734361737461626C6503053O005072652O7303113O00456D706F77657252756E65576561706F6E025O0030A240025O0090774003213O00B8EA34A9D059AFD836B3C95982F021A7D753B3A723A7D55B82F421B2D24CFDB67403063O003CDD8744C6A7025O005EA940030D3O00DBB3F08C4EC0CFAEEB8257D5FA03063O00B98EDD98E322025O00709540025O002AAF40030D3O00556E686F6C79412O7361756C74031C3O004DCB5FF54F2AC859D644FB563FE318C256E8440CE45DD142EA0362A503073O009738A5379A2353025O0080AD40025O00A89C4003123O00844217E5945104E0B3450AFCAD4211E7AF4D03043O008EC0236503123O00F57A24AEE682A813C47A2FB7EF898813D77103083O0076B61549C387ECCC030B3O004973417661696C61626C65030A3O0052756E6963506F776572026O00444003123O002B33174D0503F90D2E15461005F82C391B4403073O009D685C7A20646D03123O004461726B5472616E73666F726D6174696F6E025O00109440025O002EAF4003213O002OA7DDC102339FAAADB5C9C52F2A8CBFAAA9C18A3A269FAC9CB5CADE2837CDFAF503083O00CBC3C6AFAA5D47ED030A3O000FD2D61F0739DCD3162703053O00555CBDA37303073O004973526561647903073O0054696D65546F58025O00804140026O00144003103O004865616C746850657263656E7461676503093O0054696D65546F446965030A3O00536F756C52656170657203183O003AA3253416BE352O39A922782EAD223F16BF352C3CBC706E03043O005849CC50030E3O001D961D4B26D40982024126C3228603063O00BA4EE370264903063O0042752O66557003163O00436F2O6D616E6465726F667468654465616442752O6603123O00DF58F0585274F852EF5A556EF452D950527E03063O001A9C379D3533030E3O0053752O6D6F6E476172676F796C65025O005BB040025O00D2A940031C3O009FCD1BD4B75EB3DF17CBBF5F95D41399BF519EDF29CABD4499C8568103063O0030ECB876B9D8025O000C9140026O00104003093O009DCBD12B479AC1D93303053O002FD9AEB05F03043O0052756E65025O008CAD40025O0016AE4003093O004465617468436F696C030E3O0049735370652O6C496E52616E676503183O00BCD87716BA6B7B29B1D13605B3467F19ABD86217A2142A7403083O0046D8BD1662D23418025O00288540025O00B4924003083O0042752O66446F776E03113O004465617468416E64446563617942752O6603153O002F4527EA551FF86E4C3FC7562EEF2B5F2BC51140A403073O009C4E2B5EB53171030F3O0054EDD7B70E51707CEFF7B7194A727703073O00191288A4C36B23030A3O00C93DA64C73B0D8A8FB2803083O00D8884DC92F12DCA1030F3O00466573746572696E67537472696B65031E3O002BE938CE0DCE8B23EB14C91CCE8B26E96BDD09CE8512FF2ECE1DCCC27FBC03073O00E24D8C4BBA68BC025O00DCAE40025O00F0B240025O00A06140030A3O000D4053BBC2A73B3C435903073O00424C303CD8A3CB03123O00998974FE5EC020BF9476F54BC6219E8378F703073O0044DAE619933FAE025O00A4AB40025O003EAE40030A3O0041706F63616C7970736503173O00AC3A5C4FB7A133435FB3ED2D525EB192395658A3BD6A0103053O00D6CD4A332C030D3O00DB5EEFE578FC58EAF953FF4DE603053O00179A2C829C03123O0032A9A0A3371D15A3BFA1300719A389AB371703063O007371C6CDCE5603123O00A056EC51B045FF549751F1488956EA538B5903043O003AE4379E030F3O00432O6F6C646F776E52656D61696E7303123O009786DD233DA331B19BDF2O28A530908CD12A03073O0055D4E9B04E5CCD030D3O007F5680ED4641A9F12O599DEE5E03043O00822A38E8030D3O00DFBB2CEC4C26CBA637E25533FE03063O005F8AD5448320026O002440030D3O001F26A94C7A3309B250773F24B503053O00164A48C12303123O000F76E9552D77E05D3E76E24C247CC05D2D7D03043O00384C1984025O00C4AD40025O00B8A840030D3O0041726D796F6674686544656164031D3O005FD3A63FF051C79432C75BFEAF23CE5A81AC27DD59FEB823DB4BD1EB7203053O00AF3EA1CB46005D022O00129E3O00014O0008000100023O00261E3O0006000100010004BF3O00060001002E3101020009000100030004BF3O0009000100129E000100014O0008000200023O00129E3O00043O0026FC3O0002000100040004BF3O00020001002E310106000B000100050004BF3O000B00010026FC0001000B000100010004BF3O000B000100129E000200013O002EAA000800AE000100070004BF3O00AE0001000E3C010900AE000100020004BF3O00AE000100129E000300014O0008000400043O0026FC00030016000100010004BF3O0016000100129E000400013O0026FC0004001D000100040004BF3O001D000100129E0002000A3O0004BF3O00AE000100261E00040021000100010004BF3O00210001002EAA000B00190001000C0004BF3O0019000100129E000500013O0026FC00050026000100040004BF3O0026000100129E000400043O0004BF3O0019000100261E0005002A000100010004BF3O002A0001002E05000D00FAFF2O000E0004BF3O002200012O00D400065O0006850006007500013O0004BF3O007500012O00D4000600013O0006850006007500013O0004BF3O007500012O00D4000600023O002664000600750001000F0004BF3O0075000100129E000600014O0008000700073O002E3101100035000100110004BF3O003500010026FC00060035000100010004BF3O0035000100129E000700013O0026FC0007003A000100010004BF3O003A00012O00D4000800034O0072000900043O00122O000A00123O00122O000B00136O0009000B00024O00080008000900202O0008000800144O00080002000200062O0008005500013O0004BF3O005500012O00D4000800053O00205A0008000800154O000900033O00202O0009000900164O000A00066O0008000A000200062O00080050000100010004BF3O00500001002EAA00170055000100180004BF3O005500012O00D4000800043O00129E000900193O00129E000A001A4O00860008000A4O004400085O002E05001B00200001001B0004BF3O007500012O00D4000800034O0072000900043O00122O000A001C3O00122O000B001D6O0009000B00024O00080008000900202O0008000800144O00080002000200062O0008007500013O0004BF3O00750001002EAA001E00750001001F0004BF3O007500012O00D4000800053O00204B0008000800154O000900033O00202O0009000900204O000A00076O000B000B6O0008000B000200062O0008007500013O0004BF3O007500012O00D4000800043O00129D000900213O00122O000A00226O0008000A6O00085O00044O007500010004BF3O003A00010004BF3O007500010004BF3O00350001002E31012400A9000100230004BF3O00A900012O00D4000600034O0072000700043O00122O000800253O00122O000900266O0007000900024O00060006000700202O0006000600144O00060002000200062O000600A900013O0004BF3O00A900012O00D4000600034O0072000700043O00122O000800273O00122O000900286O0007000900024O00060006000700202O0006000600294O00060002000200062O0006009000013O0004BF3O009000012O00D4000600083O0020B100060006002A2O0039000600020002000E38012B009A000100060004BF3O009A00012O00D4000600034O0031000700043O00122O0008002C3O00122O0009002D6O0007000900024O00060006000700202O0006000600294O00060002000200062O000600A9000100010004BF3O00A900012O00D4000600053O00205A0006000600154O000700033O00202O00070007002E4O000800096O00060008000200062O000600A4000100010004BF3O00A40001002E31013000A90001002F0004BF3O00A900012O00D4000600043O00129E000700313O00129E000800324O0086000600084O004400065O00129E000500043O0004BF3O002200010004BF3O001900010004BF3O00AE00010004BF3O00160001000E3C010400152O0100020004BF3O00152O0100129E000300013O0026FC000300B5000100040004BF3O00B5000100129E000200093O0004BF3O00152O01000E3C2O0100B1000100030004BF3O00B100012O00D4000400034O0072000500043O00122O000600333O00122O000700346O0005000700024O00040004000500202O0004000400354O00040002000200062O000400E100013O0004BF3O00E100012O00D40004000A3O0026FC000400E1000100040004BF3O00E100012O00D40004000B3O0020B100040004003600129E000600374O0012010400060002002618000400CF000100380004BF3O00CF00012O00D40004000B3O0020B10004000400392O0039000400020002002664000400E1000100370004BF3O00E100012O00D40004000B3O0020B100040004003A2O0039000400020002000E7A003800E1000100040004BF3O00E100012O00D4000400053O0020E30004000400154O000500033O00202O00050005003B4O000600076O00040007000200062O000400E100013O0004BF3O00E100012O00D4000400043O00129E0005003C3O00129E0006003D4O0086000400064O004400046O00D4000400034O0072000500043O00122O0006003E3O00122O0007003F6O0005000700024O00040004000500202O0004000400144O00040002000200062O000400132O013O0004BF3O00132O012O00D400045O000685000400132O013O0004BF3O00132O012O00D4000400083O0020150104000400404O000600033O00202O0006000600414O00040006000200062O000400042O0100010004BF3O00042O012O00D4000400034O0031000500043O00122O000600423O00122O000700436O0005000700024O00040004000500202O0004000400294O00040002000200062O000400132O0100010004BF3O00132O012O00D4000400083O0020B100040004002A2O0039000400020002000E04002B00132O0100040004BF3O00132O012O00D4000400053O00205A0004000400154O000500033O00202O0005000500444O0006000C6O00040006000200062O0004000E2O0100010004BF3O000E2O01002E31014500132O0100460004BF3O00132O012O00D4000400043O00129E000500473O00129E000600484O0086000400064O004400045O00129E000300043O0004BF3O00B10001002E0500490029000100490004BF3O003E2O010026FC0002003E2O01004A0004BF3O003E2O012O00D4000300034O0072000400043O00122O0005004B3O00122O0006004C6O0004000600024O00030003000400202O0003000300354O00030002000200062O0003005C02013O0004BF3O005C02012O00D4000300083O0020B100030003004D2O00390003000200020026640003005C020100040004BF3O005C0201002EAA004E005C0201004F0004BF3O005C02012O00D4000300053O0020570003000300154O000400033O00202O0004000400504O000500066O0007000B3O00202O0007000700514O000900033O00202O0009000900504O0007000900024O000700076O00030007000200062O0003005C02013O0004BF3O005C02012O00D4000300043O00129D000400523O00122O000500536O000300056O00035O00044O005C02010026FC000200A02O01000A0004BF3O00A02O0100129E000300014O0008000400043O002E31015400422O0100550004BF3O00422O010026FC000300422O0100010004BF3O00422O0100129E000400013O000E3C2O0100992O0100040004BF3O00992O0100129E000500013O0026FC000500942O0100010004BF3O00942O012O00D40006000D3O0020B10006000600352O0039000600020002000685000600672O013O0004BF3O00672O012O00D4000600083O0020EE0006000600564O000800033O00202O0008000800574O00060008000200062O000600672O013O0004BF3O00672O012O00D40006000E3O000E7A000100672O0100060004BF3O00672O012O00D4000600053O0020DE0006000600154O0007000F6O000800106O00060008000200062O000600672O013O0004BF3O00672O012O00D4000600043O00129E000700583O00129E000800594O0086000600084O004400066O00D4000600034O0072000700043O00122O0008005A3O00122O0009005B6O0007000900024O00060006000700202O0006000600354O00060002000200062O000600932O013O0004BF3O00932O012O00D40006000E3O00261E000600862O0100010004BF3O00862O012O00D4000600034O0072000700043O00122O0008005C3O00122O0009005D6O0007000900024O00060006000700202O0006000600294O00060002000200062O000600862O013O0004BF3O00862O012O00D4000600083O0020B100060006002A2O00390006000200020026E8000600932O01002B0004BF3O00932O012O00D4000600013O00064D000600932O0100010004BF3O00932O012O00D4000600053O0020E30006000600154O000700033O00202O00070007005E4O000800096O00060009000200062O000600932O013O0004BF3O00932O012O00D4000600043O00129E0007005F3O00129E000800604O0086000600084O004400065O00129E000500043O0026FC0005004A2O0100040004BF3O004A2O0100129E000400043O0004BF3O00992O010004BF3O004A2O010026FC000400472O0100040004BF3O00472O0100129E0002004A3O0004BF3O00A02O010004BF3O00472O010004BF3O00A02O010004BF3O00422O010026FC00020010000100010004BF3O0010000100129E000300014O0008000400043O0026FC000300A42O0100010004BF3O00A42O0100129E000400013O0026FC00040050020100010004BF3O0050020100129E000500013O002E0500610006000100610004BF3O00B02O010026FC000500B02O0100040004BF3O00B02O0100129E000400043O0004BF3O00500201002E31016300AA2O0100620004BF3O00AA2O010026FC000500AA2O0100010004BF3O00AA2O012O00D4000600034O0072000700043O00122O000800643O00122O000900656O0007000900024O00060006000700202O0006000600354O00060002000200062O000600E52O013O0004BF3O00E52O012O00D40006000E3O000E04004A00E52O0100060004BF3O00E52O012O00D4000600083O0020EE0006000600404O000800033O00202O0008000800414O00060008000200062O000600CB2O013O0004BF3O00CB2O012O00D4000600023O002618000600D52O01000F0004BF3O00D52O012O00D4000600034O0031000700043O00122O000800663O00122O000900676O0007000900024O00060006000700202O0006000600294O00060002000200062O000600E52O0100010004BF3O00E52O01002EAA006800E52O0100690004BF3O00E52O012O00D4000600053O00204B0006000600154O000700033O00202O00070007006A4O000800116O000900096O00060009000200062O000600E52O013O0004BF3O00E52O012O00D4000600043O00129E0007006B3O00129E0008006C4O0086000600084O004400066O00D4000600034O0072000700043O00122O0008006D3O00122O0009006E6O0007000900024O00060006000700202O0006000600354O00060002000200062O0006004E02013O0004BF3O004E02012O00D400065O0006850006004E02013O0004BF3O004E02012O00D4000600034O0072000700043O00122O0008006F3O00122O000900706O0007000900024O00060006000700202O0006000600294O00060002000200062O0006000D02013O0004BF3O000D02012O00D4000600034O00C6000700043O00122O000800713O00122O000900726O0007000900024O0006000600070020B10006000600732O00390006000200020026180006003F0201000A0004BF3O003F02012O00D4000600083O0020150106000600404O000800033O00202O0008000800414O00060008000200062O0006003F020100010004BF3O003F02012O00D4000600034O0031000700043O00122O000800743O00122O000900756O0007000900024O00060006000700202O0006000600294O00060002000200062O0006002B020100010004BF3O002B02012O00D4000600034O0072000700043O00122O000800763O00122O000900776O0007000900024O00060006000700202O0006000600294O00060002000200062O0006002B02013O0004BF3O002B02012O00D4000600034O00C6000700043O00122O000800783O00122O000900796O0007000900024O0006000600070020B10006000600732O00390006000200020026180006003F0201007A0004BF3O003F02012O00D4000600034O0031000700043O00122O0008007B3O00122O0009007C6O0007000900024O00060006000700202O0006000600294O00060002000200062O0006004E020100010004BF3O004E02012O00D4000600034O0031000700043O00122O0008007D3O00122O0009007E6O0007000900024O00060006000700202O0006000600294O00060002000200062O0006004E020100010004BF3O004E0201002EAA0080004E0201007F0004BF3O004E02012O00D4000600053O0020E30006000600154O000700033O00202O0007000700814O000800086O00060008000200062O0006004E02013O0004BF3O004E02012O00D4000600043O00129E000700823O00129E000800834O0086000600084O004400065O00129E000500043O0004BF3O00AA2O010026FC000400A72O0100040004BF3O00A72O0100129E000200043O0004BF3O001000010004BF3O00A72O010004BF3O001000010004BF3O00A42O010004BF3O001000010004BF3O005C02010004BF3O000B00010004BF3O005C02010004BF3O000200012O000E012O00017O00893O00028O00027O0040025O00FAA340025O0052A44003073O0049735265616479030A3O003FA0090B19E407A0150D03063O00887ED0666878030F3O00432O6F6C646F776E52656D61696E73026O000840030D3O004886CF44BA573F437184C946BD03083O003118EAAE23CF325D030B3O004973417661696C61626C65030B3O003FE7ED8D631FE6EF89780203053O00116C929DE8030C3O007ECD1CE223B169CF1DEA27BC03063O00C82BA3748D4F030B3O0042752O6652656D61696E7303113O00506C616775656272696E67657242752O662O033O0047434403053O005072652O73030E3O0049735370652O6C496E52616E676503223O00A839288DB4CBF0AF2O3387B5E6A3B73F3A8B8FE4F1B6390282B3E0EAB0382EC3E1A403073O0083DF565DE3D094025O001CA240025O00E89040030C3O00D64BBEB911ACC149BFB115A103063O00D583252OD67D030A3O00073B2ABCE02A3235ACE403053O0081464B45DF030A3O0067DBFCEA7DE35FDBE0EC03063O008F26AB93891C030C3O00432O6F6C646F776E446F776E03093O00FD8DABF10AE7DDC49B03073O00B4B0E2D993638303093O00FEB63D05DABD2613CA03043O0067B3D94F026O003540030C3O00556E686F6C79426C6967687403223O005FB914DA4D959C48BB15D24998E342BE1BDD7E9CB143B823D44298AA45B90F9510DE03073O00C32AD77CB521EC026O00F03F025O00AAA940025O00F2AA40025O00688040025O00149540025O00C4AD40025O003AB040025O00EEA240025O0068B240025O00CAAD40025O00206340025O001EA040030E3O00FBD1B78EFEDBD8AA84E0D2DAAF8B03053O00B3BABFC3E7030A3O0049734361737461626C6503113O0052756E6963506F77657244656669636974026O004440030E3O00CA2A15E9F6313FE5EB3817FDF53A03043O0084995F78030E3O0082A70320F8D487B0A00922EED6A503073O00C0D1D26E4D97BA030E3O00416E74694D616769635368652O6C025O0030A440025O005EA94003193O00E10D36E0F2C5E70A21D6ECCCE50F2EA9FEC9F33C23E4E584B203063O00A4806342899F030D3O002187FDB72D88EEB703B3E6B00503043O00DE60E989025O00805140030C3O0098A0B41685FAFCB8A7AE108603073O0090D9D3C77FE893030E3O00CB3A3325DA4B2545EA282O31D94003083O0024984F5E48B52562030D3O00416E74694D616769635A6F6E65025O006C9B40025O00A8854003183O002OD65336DAD94036D4E75D30D9DD073EDACB783EDAC2076B03043O005FB7B827025O002OAA40030D3O00942DEA3F5B8616BD3AC323558403073O0062D55F874634E0030E3O00CDB6C47A5BF084C86553F1BAC57203053O00349EC3A917030E3O0049A93F79893B5C8A68BB3D6D8A3003083O00EB1ADC5214E6551B030E3O00BBB4E4CF7B2O86E8D07387B8E5C703053O0014E8C189A2025O00804140030D3O0041726D796F6674686544656164025O00EFB140025O00E8A74003243O0023CDC8BFD883114E36D7C099E389167562D7CCA1EFB307632BD0FAA7E4981E7E2CCC85F203083O001142BFA5C687EC77025O00B8A940025O00EC9640025O00689540026O008340025O007AA840025O00389A4003093O002BAAAF07F7CBE3D82O03083O00B16FCFCE739F888C03083O0020991910D142560603073O003F65E97074B42F03123O00E034E01FF938C73EFF1DFE22CB3EC917F93203063O0056A35B8D729803063O0042752O66557003163O00436F2O6D616E6465726F667468654465616442752O66030A3O00721B7B703B5F1264603F03053O005A336B1413026O001440026O003B4003083O00446562752O665570030E3O004465617468526F74446562752O66030D3O00446562752O6652656D61696E73025O0071B240025O0038944003093O004465617468436F696C031E3O0089F584FB35B2F38AE631CDF88CE835B2E097E632B2F186FB3482FE96AF6B03053O005DED90E58F03083O0030E6F91D0E4B1CF503063O0026759690796B026O00104003123O000EB4E3372CB5EA2O3FB4E82E25BECA3F2CBF03043O005A4DDB8E030A3O00C7142E3A4D0B63F6172403073O001A866441592C6703083O0045706964656D696303093O004973496E52616E6765026O003E40031C3O00F4F33927A1FCEA3363ACF8E4381CB4E3EA3F1CA5F2F7392CAAE2A36803053O00C49183504303083O00224C233C37FD0C5203063O00986D39575E4503093O00436173744379636C6503083O004F7574627265616B031D3O00F6C21EA1ACD755A3B9DF03A4B6ED44BAF0D835A2BDC65DA7F7C44AF2EA03083O00C899B76AC3DEB2340071022O00129E3O00014O0008000100013O000E3C2O01000200013O0004BF3O0002000100129E000100013O0026FC000100B3000100020004BF3O00B3000100129E000200013O002E31010300AC000100040004BF3O00AC00010026FC000200AC000100010004BF3O00AC00012O00D400035O0020B10003000300052O00390003000200020006850003006000013O0004BF3O006000012O00D4000300014O003A010400023O00122O000500063O00122O000600076O0004000600024O00030003000400202O0003000300084O0003000200024O000400036O000500043O00122O000600096O0004000600024O000500056O000600043O00122O000700096O0005000700024O00040004000500062O00040027000100030004BF3O002700012O00D4000300063O000E0400090060000100030004BF3O006000012O00D4000300014O0072000400023O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003006000013O0004BF3O006000012O00D4000300014O0031000400023O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000C4O00030002000200062O00030045000100010004BF3O004500012O00D4000300014O0072000400023O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003006000013O0004BF3O006000012O00D4000300073O00201A0103000300114O000500013O00202O0005000500124O0003000500024O000400073O00202O0004000400134O00040002000200062O00030060000100040004BF3O006000012O00D4000300083O0020210103000300144O00048O000500066O000700093O00202O0007000700154O00098O0007000900024O000700076O00030007000200062O0003006000013O0004BF3O006000012O00D4000300023O00129E000400163O00129E000500174O0086000300054O004400035O002EAA001900AB000100180004BF3O00AB00012O00D4000300014O0072000400023O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O0003000300054O00030002000200062O000300AB00013O0004BF3O00AB00012O00D40003000A3O0006850003009700013O0004BF3O009700012O00D4000300014O0072000400023O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003008300013O0004BF3O008300012O00D4000300014O0072000400023O00122O0005001E3O00122O0006001F6O0004000600024O00030003000400202O0003000300204O00030002000200062O0003008D00013O0004BF3O008D00012O00D4000300014O0031000400023O00122O000500213O00122O000600226O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003009D000100010004BF3O009D00012O00D4000300014O0072000400023O00122O000500233O00122O000600246O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003009D00013O0004BF3O009D00012O00D40003000B3O00064D0003009D000100010004BF3O009D00012O00D40003000C3O0026E8000300AB000100250004BF3O00AB00012O00D4000300083O00204B0003000300144O000400013O00202O0004000400264O0005000D6O000600066O00030006000200062O000300AB00013O0004BF3O00AB00012O00D4000300023O00129E000400273O00129E000500284O0086000300054O004400035O00129E000200293O00261E000200B0000100290004BF3O00B00001002E31012B00080001002A0004BF3O0008000100129E000100093O0004BF3O00B300010004BF3O000800010026FC000100872O0100010004BF3O00872O0100129E000200013O000E3C012900BA000100020004BF3O00BA000100129E000100293O0004BF3O00872O0100261E000200BE000100010004BF3O00BE0001002EAA002D00B60001002C0004BF3O00B6000100129E000300013O000E162O0100C3000100030004BF3O00C30001002E31012F00812O01002E0004BF3O00812O01002E050030007E000100300004BF3O00412O012O00D40004000E3O000685000400412O013O0004BF3O00412O0100129E000400014O0008000500053O002E31013200CA000100310004BF3O00CA00010026FC000400CA000100010004BF3O00CA000100129E000500013O00261E000500D3000100010004BF3O00D30001002E05003300FEFF2O00340004BF3O00CF00012O00D4000600014O0072000700023O00122O000800353O00122O000900366O0007000900024O00060006000700202O0006000600374O00060002000200062O000600082O013O0004BF3O00082O012O00D4000600073O0020B10006000600382O0039000600020002000E7A003900082O0100060004BF3O00082O012O00D40006000F3O00064D000600F9000100010004BF3O00F900012O00D4000600014O0072000700023O00122O0008003A3O00122O0009003B6O0007000900024O00060006000700202O00060006000C4O00060002000200062O000600F900013O0004BF3O00F900012O00D4000600014O0005010700023O00122O0008003C3O00122O0009003D6O0007000900024O00060006000700202O0006000600084O000600020002000E2O003900082O0100060004BF3O00082O012O00D4000600083O00205A0006000600144O000700013O00202O00070007003E4O000800106O00060008000200062O000600032O0100010004BF3O00032O01002E05003F0007000100400004BF3O00082O012O00D4000600023O00129E000700413O00129E000800424O0086000600084O004400066O00D4000600014O0072000700023O00122O000800433O00122O000900446O0007000900024O00060006000700202O0006000600374O00060002000200062O000600412O013O0004BF3O00412O012O00D4000600073O0020B10006000600382O0039000600020002000E7A004500412O0100060004BF3O00412O012O00D4000600014O0072000700023O00122O000800463O00122O000900476O0007000900024O00060006000700202O00060006000C4O00060002000200062O000600412O013O0004BF3O00412O012O00D40006000F3O00064D0006002E2O0100010004BF3O002E2O012O00D4000600014O0031000700023O00122O000800483O00122O000900496O0007000900024O00060006000700202O00060006000C4O00060002000200062O000600412O0100010004BF3O00412O012O00D4000600083O00205A0006000600144O000700013O00202O00070007004A4O000800116O00060008000200062O000600382O0100010004BF3O00382O01002E31014B00412O01004C0004BF3O00412O012O00D4000600023O00129D0007004D3O00122O0008004E6O000600086O00065O00044O00412O010004BF3O00CF00010004BF3O00412O010004BF3O00CA0001002E05004F003F0001004F0004BF3O00802O012O00D4000400014O0072000500023O00122O000600503O00122O000700516O0005000700024O00040004000500202O0004000400054O00040002000200062O000400802O013O0004BF3O00802O012O00D4000400123O000685000400802O013O0004BF3O00802O012O00D4000400014O0072000500023O00122O000600523O00122O000700536O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400642O013O0004BF3O00642O012O00D4000400014O00C6000500023O00122O000600543O00122O000700556O0005000700024O0004000400050020B10004000400082O0039000400020002002618000400712O0100020004BF3O00712O012O00D4000400014O0072000500023O00122O000600563O00122O000700576O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400712O013O0004BF3O00712O012O00D40004000C3O0026E8000400802O0100580004BF3O00802O012O00D4000400083O0020A40004000400144O000500013O00202O0005000500594O000600066O00040006000200062O0004007B2O0100010004BF3O007B2O01002E31015A00802O01005B0004BF3O00802O012O00D4000400023O00129E0005005C3O00129E0006005D4O0086000400064O004400045O00129E000300293O0026FC000300BF000100290004BF3O00BF000100129E000200293O0004BF3O00B600010004BF3O00BF00010004BF3O00B600010026FC0001004C020100290004BF3O004C020100129E000200014O0008000300033O00261E0002008F2O0100010004BF3O008F2O01002EAA005E008B2O01005F0004BF3O008B2O0100129E000300013O00261E000300942O0100290004BF3O00942O01002E0500600004000100610004BF3O00962O0100129E000100023O0004BF3O004C02010026FC000300902O0100010004BF3O00902O01002E31016300FC2O0100620004BF3O00FC2O012O00D4000400014O0072000500023O00122O000600643O00122O000700656O0005000700024O00040004000500202O0004000400054O00040002000200062O000400FC2O013O0004BF3O00FC2O012O00D4000400063O002635010400B12O0100090004BF3O00B12O012O00D4000400014O0031000500023O00122O000600663O00122O000700676O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400FC2O0100010004BF3O00FC2O012O00D40004000F3O000685000400D62O013O0004BF3O00D62O012O00D4000400014O0072000500023O00122O000600683O00122O000700696O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400D62O013O0004BF3O00D62O012O00D4000400073O0020EE00040004006A4O000600013O00202O00060006006B4O00040006000200062O000400D62O013O0004BF3O00D62O012O00D4000400014O00C6000500023O00122O0006006C3O00122O0007006D6O0005000700024O0004000400050020B10004000400082O00390004000200020026E8000400D62O01006E0004BF3O00D62O012O00D4000400073O00204C0004000400114O000600013O00202O00060006006B4O000400060002000E2O006F00E72O0100040004BF3O00E72O012O00D4000400093O0020EE0004000400704O000600013O00202O0006000600714O00040006000200062O000400FC2O013O0004BF3O00FC2O012O00D4000400093O00201A0104000400724O000600013O00202O0006000600714O0004000600024O000500073O00202O0005000500134O00050002000200062O000400FC2O0100050004BF3O00FC2O01002EAA007400FC2O0100730004BF3O00FC2O012O00D4000400083O0020570004000400144O000500013O00202O0005000500754O000600076O000800093O00202O0008000800154O000A00013O00202O000A000A00754O0008000A00024O000800086O00040008000200062O000400FC2O013O0004BF3O00FC2O012O00D4000400023O00129E000500763O00129E000600774O0086000400064O004400046O00D4000400014O0072000500023O00122O000600783O00122O000700796O0005000700024O00040004000500202O0004000400054O00040002000200062O0004004802013O0004BF3O004802012O00D4000400133O000E04007A0048020100040004BF3O004802012O00D4000400014O0072000500023O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002402013O0004BF3O002402012O00D4000400073O0020EE00040004006A4O000600013O00202O00060006006B4O00040006000200062O0004002402013O0004BF3O002402012O00D4000400014O00C6000500023O00122O0006007D3O00122O0007007E6O0005000700024O0004000400050020B10004000400082O0039000400020002002618000400350201006E0004BF3O003502012O00D4000400093O0020EE0004000400704O000600013O00202O0006000600714O00040006000200062O0004004802013O0004BF3O004802012O00D4000400093O00201A0104000400724O000600013O00202O0006000600714O0004000600024O000500073O00202O0005000500134O00050002000200062O00040048020100050004BF3O004802012O00D4000400083O00200A0004000400144O000500013O00202O00050005007F4O000600146O000700076O000800093O00202O00080008008000122O000A00816O0008000A00024O000800086O00040008000200062O0004004802013O0004BF3O004802012O00D4000400023O00129E000500823O00129E000600834O0086000400064O004400045O00129E000300293O0004BF3O00902O010004BF3O004C02010004BF3O008B2O010026FC00010005000100090004BF3O000500012O00D4000200014O0072000300023O00122O000400843O00122O000500856O0003000500024O00020002000300202O0002000200054O00020002000200062O0002007002013O0004BF3O007002012O00D4000200153O0020AB0002000200864O000300013O00202O0003000300874O000400166O000500176O000600093O00202O0006000600154O000800013O00202O0008000800874O0006000800024O000600066O00020006000200062O0002007002013O0004BF3O007002012O00D4000200023O00129D000300883O00122O000400896O000200046O00025O00044O007002010004BF3O000500010004BF3O007002010004BF3O000200012O000E012O00017O00893O00028O00025O003EA540025O00207540026O00F03F025O00AEA140025O00F0B040027O0040030A3O002045FFE00752E6FA0C4703043O009362208D030A3O0049734361737461626C65030A3O003A46F1D9034440114DE403073O002B782383AA6636030C3O00426173654475726174696F6E026O000840030E3O0067138ABBAABEA3551480B92OBC8103073O00E43466E7D6C5D0030B3O004973417661696C61626C65030E3O002DF578C7E5853ED70CE77AD3E68E03083O00B67E8015AA8AEB79030F3O00432O6F6C646F776E52656D61696E73026O004E40030A3O00A9DF27F583013B0F85DD03083O0066EBBA5586E67350030A3O0075092C4C77C6295E023903073O0042376C5E3F12B403063O0042752O66557003113O004465617468416E64446563617942752O66030A3O0036889724224B1F848B3003063O003974EDE55747025O00109240025O0010784003053O005072652O73030A3O004265727365726B696E6703143O00A8B4FFF472FC4CA3BFEAA765EF44A3B0E1F437B803073O0027CAD18D87178E030E3O00D33A0E0226EBD5262O0D3FFDF12703063O00989F53696A5203123O00556E686F6C79537472656E67746842752O66030B3O00A7C342E6CC4E8CCF56FADD03063O003CE1A63192A9030B3O0042752O6652656D61696E73030F3O004665737465726D6967687442752O6603093O0054696D65546F446965025O009C9B40025O000CB040025O0078A840025O0042AD40030E3O004C69676874734A7564676D656E74030E3O0049735370652O6C496E52616E676503193O0023172822151410143A2E060A2A103B6A13062C172E2612477703063O00674F7E4F4A61025O00FAB240025O004EB34003093O009879C8C201B98C1EBA03083O0071DE10BAA763D5E303093O000807E9F32C02F4F92A03043O00964E6E9B030E3O00B6D02AECAB10984197C228F8A81B03083O0020E5A54781C47EDF030E3O00F09CC98C8EDBE488D6868ECCCF8C03063O00B5A3E9A42OE103093O0076822C72528731785403043O001730EB5E03093O005AD3CA58553FDD73DE03073O00B21CBAB83D375303093O00E2C45539F002FACBC903073O0095A4AD275C926E03093O0046697265626C2O6F6403143O00F52E021A1817FC28145F081AF02E1113095BA27303063O007B9347707F7A025O00C49940025O0018A440030B3O00EECC857E40F8DF8B724DDF03053O0026ACADE21103143O0046696C7465726564466967687452656D61696E7303013O003C026O001440030B3O004261676F66547269636B73025O0048B140025O0020A94003183O004F102BD0421713FB5F182FE45E513EEE4E182DE35E517DB903043O008F2D714C025O00709840025O006CAC40025O0014A340025O00CCAF40030D3O009B71D0764D0EA87EDF505F16B603063O007ADA1FB3133E026O003240030E3O0080C3C0CCC6AF62B2C4CACED0AD4003073O0025D3B6ADA1A9C1030E3O00C42F40D427759EF6284AD63177BC03073O00D9975A2DB9481B026O00AF40025O00F09040030D3O00416E6365737472616C43612O6C03193O00C272E41745D76EE61E69C07DEB1E16D17DE41B57CF6FA7430603053O0036A31C8772030B3O0009C95E83407A18CE51914B03063O001F48BB3DE22E03043O0052756E6503113O0052756E6963506F77657244656669636974030B3O00417263616E6550756C736503173O00C21440D3497B1BD3134FC1423E36C2054AD34B6D64925403073O0044A36623B2271E030D3O0013F18B3C475F06EC9A2F4C542603063O003A5283E85D29026O003440030E3O00B042DD185231A456C21252268F5203063O005FE337B0753D2O033O00474344030E3O002B6B2E46A416592259AC17672F4E03053O00CB781E432B030D3O00417263616E65546F2O72656E7403183O00F0374EEED7F41A59E0CBE32043FB99E3244EE6D8FD360DBD03053O00B991452D8F03093O00A81316A9D8AC0A0BBF03053O00BCEA7F79C603093O001A3E1C8C3C1406912103043O00E3585273030E3O00700AB7AA0D7D641EA8A00D6A4F1A03063O0013237FDAC762030E3O002FEE07EF13F52DE30EFC05FB10FE03043O00827C9B6A03093O00F7C7F9A0A7D069ADCC03083O00DFB5AB96CFC3961C03093O006E36ECA10D6A2FF1B703053O00692C5A83CE03093O00DDECBDB60C18EAF2AB03063O005E9F80D2D96803093O00426C2O6F6446757279025O0029B040025O003C9C4003143O0052F509B05B40FF6F42E046AD5E7CF07B5CEA46EB03083O001A309966DF3F1F99025O00B07B40025O00D096400021032O00129E3O00014O0008000100013O00261E3O0006000100010004BF3O00060001002E05000200FEFF2O00030004BF3O0002000100129E000100013O000E3C010400F5000100010004BF3O00F5000100129E000200013O002E3101050010000100060004BF3O001000010026FC00020010000100040004BF3O0010000100129E000100073O0004BF3O00F500010026FC0002000A000100010004BF3O000A00012O00D400036O0072000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003009D00013O0004BF3O009D00012O00D4000300024O00F000048O000500013O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000D4O00040002000200122O0005000E6O0003000500024O000400036O00058O000600013O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200122O0006000E6O0004000600024O0003000300044O000400043O00062O00040039000100030004BF3O003900012O00D4000300053O00064D0003009F000100010004BF3O009F00012O00D400036O0072000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O0003004D00013O0004BF3O004D00012O00D400036O0005010400013O00122O000500123O00122O000600136O0004000600024O00030003000400202O0003000300144O000300020002000E2O00150091000100030004BF3O009100012O00D4000300063O0006850003006A00013O0004BF3O006A00012O00D4000300074O00CE000400026O00058O000600013O00122O000700163O00122O000800176O0006000800024O00050005000600202O00050005000D4O00050002000200122O0006000E6O0004000600024O000500036O00068O000700013O00122O000800163O00122O000900176O0007000900024O00060006000700202O00060006000D4O00060002000200122O0007000E6O0005000700024O00040004000500062O00030036000100040004BF3O009F00012O00D4000300083O0006850003008700013O0004BF3O008700012O00D4000300094O00CE000400026O00058O000600013O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005000D4O00050002000200122O0006000E6O0004000600024O000500036O00068O000700013O00122O000800183O00122O000900196O0007000900024O00060006000700202O00060006000D4O00060002000200122O0007000E6O0005000700024O00040004000500062O00030019000100040004BF3O009F00012O00D40003000A3O000E0400070091000100030004BF3O009100012O00D40003000B3O00201501030003001A4O00055O00202O00050005001B4O00030005000200062O0003009F000100010004BF3O009F00012O00D40003000C4O005400048O000500013O00122O0006001C3O00122O0007001D6O0005000700024O00040004000500202O00040004000D4O00040002000200202O00040004000E00062O00030003000100040004BF3O009F0001002E31011E00AC0001001F0004BF3O00AC00012O00D40003000D3O0020300003000300204O00045O00202O0004000400214O0005000E6O00030005000200062O000300AC00013O0004BF3O00AC00012O00D4000300013O00129E000400223O00129E000500234O0086000300054O004400036O00D400036O0072000400013O00122O000500243O00122O000600256O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300DB00013O0004BF3O00DB00012O00D40003000B3O0020EE00030003001A4O00055O00202O0005000500264O00030005000200062O000300DB00013O0004BF3O00DB00012O00D400036O0072000400013O00122O000500273O00122O000600286O0004000600024O00030003000400202O0003000300114O00030002000200062O000300DD00013O0004BF3O00DD00012O00D40003000B3O0020100003000300294O00055O00202O00050005002A4O0003000500024O0004000F3O00202O00040004002B4O00040002000200062O000300DD000100040004BF3O00DD00012O00D40003000B3O0020100003000300294O00055O00202O0005000500264O0003000500024O0004000F3O00202O00040004002B4O00040002000200062O000300DD000100040004BF3O00DD0001002EAA002D00F30001002C0004BF3O00F30001002EAA002E00F30001002F0004BF3O00F300012O00D40003000D3O0020070003000300204O00045O00202O0004000400304O0005000E6O000600066O0007000F3O00202O0007000700314O00095O00202O0009000900304O0007000900024O000700076O00030007000200062O000300F300013O0004BF3O00F300012O00D4000300013O00129E000400323O00129E000500334O0086000300054O004400035O00129E000200043O0004BF3O000A0001000E16010E00F9000100010004BF3O00F90001002E05003400B3000100350004BF3O00AA2O012O00D400026O0072000300013O00122O000400363O00122O000500376O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200752O013O0004BF3O00752O012O00D400026O00CF000300013O00122O000400383O00122O000500396O0003000500024O00020002000300202O00020002000D4O00020002000200202O00020002000E4O000300043O00062O000300122O0100020004BF3O00122O012O00D4000200053O00064D000200682O0100010004BF3O00682O012O00D400026O0072000300013O00122O0004003A3O00122O0005003B6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200262O013O0004BF3O00262O012O00D400026O0005010300013O00122O0004003C3O00122O0005003D6O0003000500024O00020002000300202O0002000200144O000200020002000E2O0015004E2O0100020004BF3O004E2O012O00D4000200063O000685000200352O013O0004BF3O00352O012O00D4000200074O005400038O000400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O00030003000D4O00030002000200202O00030003000E00062O00020034000100030004BF3O00682O012O00D4000200083O000685000200442O013O0004BF3O00442O012O00D4000200094O005400038O000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O00030003000D4O00030002000200202O00030003000E00062O00020025000100030004BF3O00682O012O00D40002000A3O000E040007004E2O0100020004BF3O004E2O012O00D40002000B3O00201501020002001A4O00045O00202O00040004001B4O00020004000200062O000200682O0100010004BF3O00682O012O00D40002000C4O00D4000300024O00D400046O00C6000500013O00122O000600423O00122O000700436O0005000700024O00040004000500207C00040004000D4O00040002000200122O0005000E6O0003000500024O000400036O00056O00C6000600013O00122O000700423O00122O000800436O0006000800024O0005000500060020DB00050005000D4O00050002000200122O0006000E6O0004000600024O00030003000400062O000200752O0100030004BF3O00752O012O00D40002000D3O0020300002000200204O00035O00202O0003000300444O0004000E6O00020004000200062O000200752O013O0004BF3O00752O012O00D4000200013O00129E000300453O00129E000400464O0086000200044O004400025O002E3101470020030100480004BF3O002003012O00D400026O0072000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002002003013O0004BF3O002003012O00D40002000A3O0026FC00020020030100040004BF3O002003012O00D40002000B3O00201501020002001A4O00045O00202O0004000400264O00020004000200062O000200932O0100010004BF3O00932O012O00D40002000D3O00207800020002004B4O000300103O00122O0004004C3O00122O0005004D6O00020005000200062O0002002003013O0004BF3O002003012O00D40002000D3O0020800002000200204O00035O00202O00030003004E4O0004000E6O000500056O0006000F3O00202O0006000600314O00085O00202O00080008004E4O0006000800024O000600066O00020006000200062O000200A42O0100010004BF3O00A42O01002E31014F0020030100500004BF3O002003012O00D4000200013O00129D000300513O00122O000400526O000200046O00025O00044O00200301000E16010700AE2O0100010004BF3O00AE2O01002EAA00540030020100530004BF3O0030020100129E000200014O0008000300033O0026FC000200B02O0100010004BF3O00B02O0100129E000300013O002EAA005500B92O0100560004BF3O00B92O010026FC000300B92O0100040004BF3O00B92O0100129E0001000E3O0004BF3O003002010026FC000300B32O0100010004BF3O00B32O012O00D400046O0072000500013O00122O000600573O00122O000700586O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400F82O013O0004BF3O00F82O012O00D4000400043O002664000400CB2O0100590004BF3O00CB2O012O00D4000400053O00064D000400FA2O0100010004BF3O00FA2O012O00D400046O0072000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400114O00040002000200062O000400DF2O013O0004BF3O00DF2O012O00D400046O0005010500013O00122O0006005C3O00122O0007005D6O0005000700024O00040004000500202O0004000400144O000400020002000E2O001500F52O0100040004BF3O00F52O012O00D4000400063O000685000400E52O013O0004BF3O00E52O012O00D4000400073O002635010400FA2O0100590004BF3O00FA2O012O00D4000400083O000685000400EB2O013O0004BF3O00EB2O012O00D4000400093O002635010400FA2O0100590004BF3O00FA2O012O00D40004000A3O000E04000700F52O0100040004BF3O00F52O012O00D40004000B3O00201501040004001A4O00065O00202O00060006001B4O00040006000200062O000400FA2O0100010004BF3O00FA2O012O00D40004000C3O002635010400FA2O0100590004BF3O00FA2O01002E31015E00070201005F0004BF3O000702012O00D40004000D3O0020300004000400204O00055O00202O0005000500604O0006000E6O00040006000200062O0004000702013O0004BF3O000702012O00D4000400013O00129E000500613O00129E000600624O0086000400064O004400046O00D400046O0072000500013O00122O000600633O00122O000700646O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004002C02013O0004BF3O002C02012O00D40004000A3O000E1A0007001E020100040004BF3O001E02012O00D40004000B3O0020B10004000400652O00390004000200020026640004002C020100040004BF3O002C02012O00D40004000B3O0020B10004000400662O0039000400020002000E040015002C020100040004BF3O002C02012O00D40004000D3O00204B0004000400204O00055O00202O0005000500674O0006000E6O000700076O00040007000200062O0004002C02013O0004BF3O002C02012O00D4000400013O00129E000500683O00129E000600694O0086000400064O004400045O00129E000300043O0004BF3O00B32O010004BF3O003002010004BF3O00B02O010026FC00010007000100010004BF3O0007000100129E000200014O0008000300033O0026FC00020034020100010004BF3O0034020100129E000300013O0026FC00030014030100010004BF3O001403012O00D400046O0072000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004007802013O0004BF3O007802012O00D40004000B3O0020B10004000400662O0039000400020002000E7A006C0078020100040004BF3O007802012O00D400046O00C6000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400050020000104000400144O0004000200024O0005000B3O00202O00050005006F4O00050002000200062O0004006A020100050004BF3O006A02012O00D400046O0072000500013O00122O000600703O00122O000700716O0005000700024O00040004000500202O0004000400114O00040002000200062O0004006A02013O0004BF3O006A02012O00D4000400053O0006850004007802013O0004BF3O007802012O00D40004000B3O0020B10004000400652O00390004000200020026E800040078020100070004BF3O007802012O00D4000400113O0026E800040078020100040004BF3O007802012O00D40004000D3O00204B0004000400204O00055O00202O0005000500724O0006000E6O000700076O00040007000200062O0004007802013O0004BF3O007802012O00D4000400013O00129E000500733O00129E000600744O0086000400064O004400046O00D400046O0072000500013O00122O000600753O00122O000700766O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004001303013O0004BF3O001303012O00D4000400024O00F000058O000600013O00122O000700773O00122O000800786O0006000800024O00050005000600202O00050005000D4O00050002000200122O0006000E6O0004000600024O000500036O00068O000700013O00122O000800773O00122O000900786O0007000900024O00060006000700202O00060006000D4O00060002000200122O0007000E6O0005000700024O0004000400054O000500043O00062O0005009F020100040004BF3O009F02012O00D4000400053O00064D00040004030100010004BF3O000403012O00D400046O0072000500013O00122O000600793O00122O0007007A6O0005000700024O00040004000500202O0004000400114O00040002000200062O000400B302013O0004BF3O00B302012O00D400046O0005010500013O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O0004000400144O000400020002000E2O001500F7020100040004BF3O00F702012O00D4000400063O000685000400D002013O0004BF3O00D002012O00D4000400074O00CE000500026O00068O000700013O00122O0008007D3O00122O0009007E6O0007000900024O00060006000700202O00060006000D4O00060002000200122O0007000E6O0005000700024O000600036O00078O000800013O00122O0009007D3O00122O000A007E6O0008000A00024O00070007000800202O00070007000D4O00070002000200122O0008000E6O0006000800024O00050005000600062O00040035000100050004BF3O000403012O00D4000400083O000685000400ED02013O0004BF3O00ED02012O00D4000400094O00CE000500026O00068O000700013O00122O0008007F3O00122O000900806O0007000900024O00060006000700202O00060006000D4O00060002000200122O0007000E6O0005000700024O000600036O00078O000800013O00122O0009007F3O00122O000A00806O0008000A00024O00070007000800202O00070007000D4O00070002000200122O0008000E6O0006000800024O00050005000600062O00040018000100050004BF3O000403012O00D40004000A3O000E04000700F7020100040004BF3O00F702012O00D40004000B3O00201501040004001A4O00065O00202O00060006001B4O00040006000200062O00040004030100010004BF3O000403012O00D40004000C4O000F01058O000600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O00050005000D4O00050002000200202O00050005000400202O00050005000700062O00040013030100050004BF3O001303012O00D40004000D3O00205A0004000400204O00055O00202O0005000500834O0006000E6O00040006000200062O0004000E030100010004BF3O000E0301002EAA00840013030100850004BF3O001303012O00D4000400013O00129E000500863O00129E000600874O0086000400064O004400045O00129E000300043O00261E00030018030100040004BF3O00180301002E3101890037020100880004BF3O0037020100129E000100043O0004BF3O000700010004BF3O003702010004BF3O000700010004BF3O003402010004BF3O000700010004BF3O002003010004BF3O000200012O000E012O00017O00543O00028O00025O0026A540025O00E06F40026O00F03F025O001CAF40025O00F4B24003073O004973526561647903083O0042752O66446F776E03113O004465617468416E64446563617942752O66027O0040030C3O00D222A0572A6FC03EA74D287203063O0016874CC83846030B3O004973417661696C61626C65026O002A40026O002040026O00104003063O00A935FE2D51E403063O0081ED5098443D03063O0042752O66557003123O004461726B5472616E73666F726D6174696F6E03143O0077AD17E71905515FAF33FC09195C75AD06E61A1103073O003831C864937C77030F3O0041757261416374697665436F756E7403053O005072652O73030C3O00CD30A6CFC830BBB0DF2AFFA603043O0090AC5EDF025O0041B240030E3O0049735370652O6C496E52616E676503123O003300B7492030B1572101A642364FB153645703043O0027446FC2025O00DEA640025O00B6A740025O0053B140025O00A49E40026O000840030F3O00F0A3F4D37CA5DFA8E0F46DA5DFADE203063O00D7B6C687A719025O0058AB40025O00B88340030C3O00436173745461726765744966030F3O00466573746572696E67537472696B652O033O008040E403043O0028ED298A03163O00C171E9EC4FD57DF4FF75D460E8F141C234E9EC0A962403053O002AA7149A9803093O006EFBA356790245F7AE03063O00412A9EC22211025O00C89C40025O00E8AE4003093O004465617468436F696C03103O001E22531825D218E1132B121F39AD4ABC03083O008E7A47326C4D8D7B025O0096A040025O00689740025O00EC9E40025O00109E40025O00408A40025O00FCB040025O00E7B140025O0093B14003093O009CBD1D28B09B1335B403043O005C2OD87C026O002440025O007DB040025O0042B040030F3O005F37AD54F56431A349F11B21B800AF03053O009D3B52CC20025O0034A640025O00E3B24003083O001D2EEAFEECE7DAB203083O00D1585E839A898AB303083O0045706964656D696303093O004973496E52616E6765026O003E40030D3O002DB1CD781B2E382168B2D03C4A03083O004248C1A41C7E4351025O00549640025O0006AE40025O008AA440025O00CAA7402O033O0018A3E703053O005B75C29F7803133O000D122B1631CE370A18301C30E3642O097E496103073O00447A7D5E785591009E012O00129E3O00014O0008000100023O00261E3O0006000100010004BF3O00060001002EAA00020009000100030004BF3O0009000100129E000100014O0008000200023O00129E3O00043O0026FC3O0002000100040004BF3O000200010026FC0001000B000100010004BF3O000B000100129E000200013O002E31010500A7000100060004BF3O00A700010026FC000200A7000100040004BF3O00A7000100129E000300013O0026FC000300A0000100010004BF3O00A000012O00D400045O0020B10004000400072O00390004000200020006850004007A00013O0004BF3O007A00012O00D4000400013O0020EE0004000400084O000600023O00202O0006000600094O00040006000200062O0004007A00013O0004BF3O007A00012O00D4000400033O000E1A000A0060000100040004BF3O006000012O00D4000400024O0072000500043O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004004600013O0004BF3O004600012O00D4000400053O0006850004003400013O0004BF3O003400012O00D4000400063O000E1A000E0060000100040004BF3O006000012O00D4000400073O0006850004003A00013O0004BF3O003A00012O00D4000400083O000E38010F0060000100040004BF3O006000012O00D4000400093O0006850004004000013O0004BF3O004000012O00D40004000A3O000E38010F0060000100040004BF3O006000012O00D40004000B3O00064D00040046000100010004BF3O004600012O00D40004000C3O000E1A00100060000100040004BF3O006000012O00D4000400024O0072000500043O00122O000600113O00122O000700126O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004007A00013O0004BF3O007A00012O00D4000400073O00064D00040060000100010004BF3O006000012O00D4000400053O00064D00040060000100010004BF3O006000012O00D4000400093O00064D00040060000100010004BF3O006000012O00D40004000D3O0020EE0004000400134O000600023O00202O0006000600144O00040006000200062O0004007A00013O0004BF3O007A00012O00D4000400024O00C6000500043O00122O000600153O00122O000700166O0005000700024O0004000400050020B10004000400172O00390004000200022O00D4000500033O0006900004006E000100050004BF3O006E00012O00D4000400033O0026FC0004007A000100040004BF3O007A00012O00D40004000E3O0020DE0004000400184O0005000F6O000600106O00040006000200062O0004007A00013O0004BF3O007A00012O00D4000400043O00129E000500193O00129E0006001A4O0086000400064O004400045O002E05001B00250001001B0004BF3O009F00012O00D4000400113O0020B10004000400072O00390004000200020006850004009F00013O0004BF3O009F00012O00D40004000B3O00064D0004008E000100010004BF3O008E00012O00D4000400033O000E04000A009F000100040004BF3O009F00012O00D4000400013O0020EE0004000400134O000600023O00202O0006000600094O00040006000200062O0004009F00013O0004BF3O009F00012O00D40004000E3O0020210104000400184O000500116O000600076O000800123O00202O00080008001C4O000A00116O0008000A00024O000800086O00040008000200062O0004009F00013O0004BF3O009F00012O00D4000400043O00129E0005001D3O00129E0006001E4O0086000400064O004400045O00129E000300043O002EAA001F0013000100200004BF3O001300010026FC00030013000100040004BF3O0013000100129E0002000A3O0004BF3O00A700010004BF3O00130001002E31012200FB000100210004BF3O00FB0001000E3C010A00FB000100020004BF3O00FB000100129E000300014O0008000400043O0026FC000300AD000100010004BF3O00AD000100129E000400013O0026FC000400B4000100040004BF3O00B4000100129E000200233O0004BF3O00FB0001000E3C2O0100B0000100040004BF3O00B000012O00D4000500024O0072000600043O00122O000700243O00122O000800256O0006000800024O00050005000600202O0005000500074O00050002000200062O000500C300013O0004BF3O00C300012O00D40005000B3O000685000500C500013O0004BF3O00C50001002E31012600D8000100270004BF3O00D800012O00D4000500133O0020D80005000500284O000600023O00202O0006000600294O000700146O000800043O00122O0009002A3O00122O000A002B6O0008000A00024O000900156O000A00166O0005000A000200062O000500D800013O0004BF3O00D800012O00D4000500043O00129E0006002C3O00129E0007002D4O0086000500074O004400056O00D4000500024O0072000600043O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O0005000500074O00050002000200062O000500F700013O0004BF3O00F70001002EAA003000F7000100310004BF3O00F700012O00D40005000E3O0020570005000500184O000600023O00202O0006000600324O000700086O000900123O00202O00090009001C4O000B00023O00202O000B000B00324O0009000B00024O000900096O00050009000200062O000500F700013O0004BF3O00F700012O00D4000500043O00129E000600333O00129E000700344O0086000500074O004400055O00129E000400043O0004BF3O00B000010004BF3O00FB00010004BF3O00AD0001002E31013600742O0100350004BF3O00742O010026FC000200742O0100010004BF3O00742O0100129E000300014O0008000400043O0026FC0003003O0100010004BF3O003O0100129E000400013O00261E000400082O0100010004BF3O00082O01002E0500370067000100380004BF3O006D2O0100129E000500013O00261E0005000D2O0100010004BF3O000D2O01002EAA003A00662O0100390004BF3O00662O01002EAA003C003A2O01003B0004BF3O003A2O012O00D4000600024O0072000700043O00122O0008003D3O00122O0009003E6O0007000900024O00060006000700202O0006000600074O00060002000200062O0006003A2O013O0004BF3O003A2O012O00D4000600173O00064D0006003A2O0100010004BF3O003A2O012O00D4000600183O00064D000600222O0100010004BF3O00222O012O00D4000600193O00064D000600252O0100010004BF3O00252O012O00D40006001A3O0026E80006003A2O01003F0004BF3O003A2O01002EAA0041003A2O0100400004BF3O003A2O012O00D40006000E3O0020570006000600184O000700023O00202O0007000700324O000800096O000A00123O00202O000A000A001C4O000C00023O00202O000C000C00324O000A000C00024O000A000A6O0006000A000200062O0006003A2O013O0004BF3O003A2O012O00D4000600043O00129E000700423O00129E000800434O0086000600084O004400065O002EAA004400652O0100450004BF3O00652O012O00D4000600024O0072000700043O00122O000800463O00122O000900476O0007000900024O00060006000700202O0006000600074O00060002000200062O000600652O013O0004BF3O00652O012O00D4000600173O000685000600652O013O0004BF3O00652O012O00D4000600183O00064D0006004F2O0100010004BF3O004F2O012O00D4000600193O00064D000600522O0100010004BF3O00522O012O00D40006001A3O0026E8000600652O01003F0004BF3O00652O012O00D40006000E3O00200A0006000600184O000700023O00202O0007000700484O0008001B6O000900096O000A00123O00202O000A000A004900122O000C004A6O000A000C00024O000A000A6O0006000A000200062O000600652O013O0004BF3O00652O012O00D4000600043O00129E0007004B3O00129E0008004C4O0086000600084O004400065O00129E000500043O00261E0005006A2O0100040004BF3O006A2O01002E31014E00092O01004D0004BF3O00092O0100129E000400043O0004BF3O006D2O010004BF3O00092O01000E3C010400042O0100040004BF3O00042O0100129E000200043O0004BF3O00742O010004BF3O00042O010004BF3O00742O010004BF3O003O010026FC0002000E000100230004BF3O000E00012O00D4000300113O0020B10003000300072O00390003000200020006850003007E2O013O0004BF3O007E2O012O00D40003000B3O000685000300802O013O0004BF3O00802O01002EAA0050009D2O01004F0004BF3O009D2O012O00D4000300133O00202C0003000300284O000400116O000500146O000600043O00122O000700513O00122O000800526O0006000800024O000700156O0008001C6O000900123O0020B100090009001C2O0021000B00116O0009000B00024O000900096O00030009000200062O0003009D2O013O0004BF3O009D2O012O00D4000300043O00129D000400533O00122O000500546O000300056O00035O00044O009D2O010004BF3O000E00010004BF3O009D2O010004BF3O000B00010004BF3O009D2O010004BF3O000200012O000E012O00017O00043O00025O00EEAA40025O00B2A640025O0002A640025O00088040000D3O002E310102000C000100010004BF3O000C00012O00D47O0006853O000C00013O0004BF3O000C00012O00D43O00014O00403O0001000200064D3O000B000100010004BF3O000B0001002EAA0003000C000100040004BF3O000C00012O006C3O00024O000E012O00017O00593O00028O00026O00F03F030A3O001DEFECC7DDAF212CECE603073O00585C9F83A4BCC3030F3O00432O6F6C646F776E52656D61696E73026O002440026O001040030D3O00B520B744DBF2FC933DBE5EDBFF03073O00BDE04EDF2BB78B026O001C40027O0040030B3O0008F99902C43CF18311C93A03053O00A14E9CEA76030B3O004973417661696C61626C6503063O0042752O665570030F3O004665737465726D6967687442752O66030B3O0042752O6652656D61696E732O033O00474344026O001440025O00E08640025O00ECA340030D3O008EB9CFD9A4A3CCD884BBC8CBB403043O00BCC7D7A9026O000840025O0022A840025O00806440025O00BC9640025O00E4AE40025O00C0624003113O003E11DF4CC7CFBF1338CA5FDCD1991815C303073O00DA777CAF3EA8B903113O0086FF41C8AAF66CC1B3F15BD0A4E441CBAB03043O00A4C5902803113O00A0FFA387D2B0A7F5BC8ACEA282E4A384D303063O00D6E390CAEBBD03113O00C4A897691FA55638C9A0866F18905C35E103083O005C8DC5E71B70D333030E3O00D5EA87AEDEE8D88BB1D6E9E686A603053O00B1869FEAC3030A3O009CFB30A3C8B1F22FB3CC03053O00A9DD8B5FC0030A3O00FF9B703C232AC79B6C3A03063O0046BEEB1F5F42030E3O0089F717EBEAB4C51BF4E2B5FB16E303053O0085DA827A86030A3O00436F6D62617454696D65026O003440025O00F2A840025O009CAD40025O00F07C40025O0046AB40030A3O00DD195078E9F0104F68ED03053O00889C693F1B030A3O003A9C76371A806024088903043O00547BEC19030D3O00C585A218A0ACD198B9162OB9E403063O00D590EBCA77CC030D3O002O16D625243A6C300BDF3F243703073O002D4378BE4A484303083O00446562752O66557003113O00526F2O74656E546F756368446562752O6603073O0048617354696572026O003F40030F3O0041706F634D61677573416374697665030F3O0041726D794D61677573416374697665030D3O00162BE1A0DA87E0FD2125E4AAF703083O008940428DC599E88E030D3O0035D92EA3AB0CDE36A78F0ADF2C03053O00E863B042C6030A3O0052756E6963506F776572026O004E40025O00EAA340025O0018A040030B3O00DE2E3C127E83CD23F9222003083O004C8C4148661BED99030B3O0078D502C6D20F8A45CF15DA03073O00DE2ABA76B2B761030A3O00446562752O66446F776E03113O0052756E6963506F7765724465666963697403043O0052756E6503113O0074E1549852FA418E79E9459E55CF4B835103043O00EA3D8C2403113O0002D2B37E0027F9BF640E32C9BB66062ED303053O006F41BDDA12030E3O0053752O64656E442O6F6D42752O66030A3O00625B14360A50B653581E03073O00CF232B7B556B3C025O002EAF40025O00CCA840001B022O00129E3O00014O0008000100013O0026FC3O0002000100010004BF3O0002000100129E000100013O0026FC0001005E000100020004BF3O005E00012O00D4000200014O00C6000300023O00122O000400033O00122O000500046O0003000500024O0002000200030020B10002000200052O00390002000200020026E800020021000100060004BF3O002100012O00D4000200033O00266400020021000100070004BF3O002100012O00D4000200014O0005010300023O00122O000400083O00122O000500096O0003000500024O00020002000300202O0002000200054O000200020002000E2O00060021000100020004BF3O0021000100129E0002000A3O00064D00020022000100010004BF3O0022000100129E0002000B4O002300026O00D4000200043O00064D00020043000100010004BF3O004300012O00D4000200014O0072000300023O00122O0004000C3O00122O0005000D6O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002004300013O0004BF3O004300012O00D4000200053O0020EE00020002000F4O000400013O00202O0004000400104O00020004000200062O0002004300013O0004BF3O004300012O00D4000200053O00202D0002000200114O000400013O00202O0004000400104O0002000400024O000300053O00202O0003000300124O00030002000200102O0003001300034O000200020003000E2O00020045000100020004BF3O00450001002E310115004C000100140004BF3O004C00012O00D4000200033O000E1A00020049000100020004BF3O004900012O004E00026O0033010200014O0023000200063O0004BF3O005D00012O00D4000200034O00D4000300074O00D4000400014O00C6000500023O00122O000600163O00122O000700176O0005000700024O00040004000500202701040004000E4O000400056O00033O000200102O00030018000300062O00030002000100020004BF3O005B00012O004E00026O0033010200014O0023000200063O00129E0001000B3O002EAA001A00E4000100190004BF3O00E400010026FC000100E4000100010004BF3O00E4000100129E000200014O0008000300033O002E31011B00640001001C0004BF3O006400010026FC00020064000100010004BF3O0064000100129E000300013O0026FC0003006D000100020004BF3O006D000100129E000100023O0004BF3O00E400010026FC00030069000100010004BF3O0069000100129E000400013O002E05001D00060001001D0004BF3O007600010026FC00040076000100020004BF3O0076000100129E000300023O0004BF3O006900010026FC00040070000100010004BF3O007000012O00D4000500014O0072000600023O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005008F00013O0004BF3O008F00012O00D4000500014O0031000600023O00122O000700203O00122O000800216O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005008F000100010004BF3O008F00012O00D4000500093O000E1A001800AA000100050004BF3O00AA00012O00D4000500014O0072000600023O00122O000700223O00122O000800236O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005009C00013O0004BF3O009C00012O00D4000500093O000E1A000700AA000100050004BF3O00AA00012O00D4000500014O0031000600023O00122O000700243O00122O000800256O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500A9000100010004BF3O00A900012O00D4000500093O000E1A000B00AA000100050004BF3O00AA00012O004E00056O0033010500014O0023000500084O00D4000500093O000E1A001800DD000100050004BF3O00DD00012O00D4000500014O0005010600023O00122O000700263O00122O000800276O0006000800024O00050005000600202O0005000500054O000500020002000E2O000200CD000100050004BF3O00CD00012O00D4000500014O00C6000600023O00122O000700283O00122O000800296O0006000800024O0005000500060020B10005000500052O0039000500020002000E38010200DD000100050004BF3O00DD00012O00D4000500014O0072000600023O00122O0007002A3O00122O0008002B6O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500DD00013O0004BF3O00DD00012O00D4000500014O0072000600023O00122O0007002C3O00122O0008002D6O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500DD00013O0004BF3O00DD00012O00D40005000B3O00202500050005002E2O0040000500010002000E38012F00DD000100050004BF3O00DD00012O004E00056O0033010500014O00230005000A3O00129E000400023O0004BF3O007000010004BF3O006900010004BF3O00E400010004BF3O00640001002E31013000702O0100310004BF3O00702O01000E3C010B00702O0100010004BF3O00702O0100129E000200013O00261E000200ED000100010004BF3O00ED0001002E050032007E000100330004BF3O00692O012O00D4000300014O00C6000400023O00122O000500343O00122O000600356O0004000600024O0003000300040020B10003000300052O00390003000200022O00D400045O000603010400022O0100030004BF3O00022O012O00D4000300014O0031000400023O00122O000500363O00122O000600376O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300402O0100010004BF3O00402O012O00D4000300063O00064D000300482O0100010004BF3O00482O012O00D4000300033O000E040002001F2O0100030004BF3O001F2O012O00D4000300014O00C6000400023O00122O000500383O00122O000600396O0004000600024O0003000300040020B10003000300052O00390003000200020026E80003001F2O01002F0004BF3O001F2O012O00D4000300014O0072000400023O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003001F2O013O0004BF3O001F2O012O00D40003000D3O00064D000300482O0100010004BF3O00482O012O00D40003000E3O0020EE00030003003C4O000500013O00202O00050005003D4O00030005000200062O000300292O013O0004BF3O00292O012O00D4000300033O000E1A000200472O0100030004BF3O00472O012O00D4000300033O000E38010700472O0100030004BF3O00472O012O00D4000300053O00203C00030003003E00122O0005003F3O00122O000600076O00030006000200062O000300402O013O0004BF3O00402O012O00D40003000F3O0020B10003000300402O003900030002000200064D0003003D2O0100010004BF3O003D2O012O00D40003000F3O0020B10003000300412O0039000300020002000685000300402O013O0004BF3O00402O012O00D4000300033O000E1A000200472O0100030004BF3O00472O012O00D4000300103O0026E8000300462O0100130004BF3O00462O012O00D4000300033O000E1A000200472O0100030004BF3O00472O012O004E00036O0033010300014O00230003000C4O00D4000300014O0072000400023O00122O000500423O00122O000600436O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300672O013O0004BF3O00672O012O00D4000300014O00C6000400023O00122O000500443O00122O000600456O0004000600024O0003000300040020B10003000300052O00390003000200020026E8000300652O0100180004BF3O00652O012O00D4000300053O0020B10003000300462O00390003000200020026E8000300652O0100470004BF3O00652O012O00D40003000D4O0036010300033O0004BF3O00672O012O004E00036O0033010300014O0023000300113O00129E000200023O002E31014900E9000100480004BF3O00E90001000E3C010200E9000100020004BF3O00E9000100129E000100183O0004BF3O00702O010004BF3O00E900010026FC000100F12O0100070004BF3O00F12O012O00D4000200014O0072000300023O00122O0004004A3O00122O0005004B6O0003000500024O00020002000300202O00020002000E4O00020002000200062O000200922O013O0004BF3O00922O012O00D4000200014O0072000300023O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002008D2O013O0004BF3O008D2O012O00D40002000E3O00201501020002004E4O000400013O00202O00040004003D4O00020004000200062O000200922O0100010004BF3O00922O012O00D4000200053O0020B100020002004F2O00390002000200020026E8000200ED2O01002F0004BF3O00ED2O012O00D4000200053O00203C00020002003E00122O0004003F3O00122O000500076O00020005000200062O000200B42O013O0004BF3O00B42O012O00D4000200053O00203C00020002003E00122O0004003F3O00122O000500076O00020005000200062O000200AA2O013O0004BF3O00AA2O012O00D40002000F3O0020B10002000200402O003900020002000200064D000200AA2O0100010004BF3O00AA2O012O00D40002000F3O0020B10002000200412O0039000200020002000685000200B42O013O0004BF3O00B42O012O00D4000200053O0020B100020002004F2O0039000200020002002618000200B42O01002F0004BF3O00B42O012O00D4000200053O0020B10002000200502O00390002000200020026E8000200ED2O0100180004BF3O00ED2O012O00D4000200014O0072000300023O00122O000400513O00122O000500526O0003000500024O00020002000300202O00020002000E4O00020002000200062O000200CB2O013O0004BF3O00CB2O012O00D4000200093O00261E000200EE2O01000B0004BF3O00EE2O012O00D4000200014O0031000300023O00122O000400533O00122O000500546O0003000500024O00020002000300202O00020002000E4O00020002000200062O000200EF2O0100010004BF3O00EF2O012O00D4000200053O0020B10002000200502O0039000200020002002618000200EE2O0100180004BF3O00EE2O012O00D4000200043O00064D000200EF2O0100010004BF3O00EF2O012O00D4000200053O00201501020002000F4O000400013O00202O0004000400554O00020004000200062O000200EF2O0100010004BF3O00EF2O012O00D4000200014O00C6000300023O00122O000400563O00122O000500576O0003000500024O0002000200030020B10002000200052O00390002000200020026E8000200E72O0100060004BF3O00E72O012O00D4000200033O000E38011800EE2O0100020004BF3O00EE2O012O00D40002000C3O00064D000200ED2O0100010004BF3O00ED2O012O00D4000200033O000E1A000700EE2O0100020004BF3O00EE2O012O004E00026O0033010200014O0023000200123O0004BF3O001A02010026FC00010005000100180004BF3O0005000100129E000200013O0026FC000200F82O0100020004BF3O00F82O0100129E000100073O0004BF3O00050001002E31015900F42O0100580004BF3O00F42O010026FC000200F42O0100010004BF3O00F42O0100129E000300013O0026FC00030001020100020004BF3O0001020100129E000200023O0004BF3O00F42O010026FC000300FD2O0100010004BF3O00FD2O012O00D4000400093O00261E0004000A020100020004BF3O000A02012O00D4000400134O0036010400043O0004BF3O000B02012O004E00046O0033010400014O00230004000D4O00D4000400093O000E04000B0011020100040004BF3O001102012O00D4000400133O0004BF3O001302012O004E00046O0033010400014O0023000400143O00129E000300023O0004BF3O00FD2O010004BF3O00F42O010004BF3O000500010004BF3O001A02010004BF3O000200012O000E012O00017O00EE3O00028O00026O00F03F025O00A8A940025O00249C40025O007BB040025O00CDB040026O001040030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174027O0040025O0060AD40025O00206E40030A3O0047617267416374697665030B3O004761726752656D61696E73030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O6603103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E73025O00D89840025O00B08F40025O00149040025O0070A140025O00CC9C40025O0050B040025O00688540025O0075B240025O00B4A840030D3O00E94B4863EA7DDC51405EE07ACC03063O001BA839251A8503113O0054696D6553696E63654C61737443617374026O003E40030D3O000CB871B1D82BBE74ADF328AB7803053O00B74DCA1CC8025O0063B040025O005EA940025O0062AD40025O006EA040025O0074B040025O00805840030A3O003FD1AFE7BC7E07D1B3E103063O00127EA1C084DD026O002E40030A3O007E38A107575331BE175303053O00363F48CE64025O00708440025O0002A740025O0084A240025O00CCB140025O006CA340025O009CAA40025O00108040025O000EA240025O0044A440025O00BC9640025O00C1B140025O0098B040025O006C9A40025O00D88740025O002FB040025O001C9340025O001AA740025O00AAA340025O00788540025O0015B040025O00407240025O00889C40025O00AEB040025O009C9840025O00789F40025O00405F40025O004DB040025O00349D40025O00D07740025O00F8AD40025O00E0A940025O0012A940025O00489240026O002O40026O000840025O0050AA40025O00808740025O0034AE40030F3O007789BB67549EA17D56BFBC615887AD03043O001331ECC803073O0049735265616479025O00989640025O00D2AD4003053O005072652O73030F3O00466573746572696E67537472696B65025O008AA240025O004CB140031C3O00F832E5A3E1A8F739F188F7AEEC3EFDB2A4AAEC32F5B8E9B8FF23B6EF03063O00DA9E5796D784025O00C07F40025O001CB240025O00B09440025O00107A40025O0059B040025O00307C40025O0060A240025O00349540025O009EA540025O00D09640025O0064AA4003083O0036FD56B2281CE94903053O005A798822D003083O004F7574627265616B030E3O0049735370652O6C496E52616E6765025O00F8AA40025O0078AB4003153O00C81B411CD50B54158701400AF8015321D50F5B19C203043O007EA76E3503083O00180027FCD932341303063O005F5D704E98BC03143O00F7FC9700E8BBDCD5C58914E3ABD7E5F08700E2B803073O00B2A195E57584DE030F3O0041757261416374697665436F756E7403083O0045706964656D696303093O004973496E52616E676503153O008DCBD4A8A41BAF20C8D4C8B89E19A01C9ADAD3ABA403083O0043E8BBBDCCC176C6025O0052AE40025O00889D4003093O00AF2BB4343321E0822203073O008FEB4ED5405B6203143O00BB4196FC7CB3835CB4E571B1984DA0EC72A38B4E03063O00D6ED28E48910025O00C0A140025O0098AC4003093O004465617468436F696C03173O0081E6EECD0B9986ECE6D543A990F7D0D6059997E2E1DE0603063O00C6E5838FB963025O00DCA740025O00089E40025O005DB040025O00BCA340025O008C9340025O00449740030B3O003336881C1F009D1A1E388C03043O00687753E9030B3O004465617468537472696B65031B3O00F1FD26364BCAEB33304AFEFD672E4CE2B82F3203FAEA673251FAFB03053O002395984742025O00F08440025O00AC9B40025O00CC9640025O00907440025O00BCA640025O00609140025O00188240025O00FCB140025O00F89F40025O007AB040025O0070A340025O00508940025O00BAB240025O00D8AB40025O00507040025O00206140030F3O00432O6F6C646F776E52656D61696E73026O00244003083O0042752O66446F776E03113O004465617468416E64446563617942752O66025O00688440025O008C9A40025O00ACA340025O00D4A740025O00C7B240025O00206640025O009EAC40025O00F88A40025O0064AF40025O0052B240025O00807840025O00B8A040025O00B3B140025O0042A840025O002EAE4003063O0042752O665570025O0006A940025O001AA140025O00E88E40025O0095B040025O00607840025O00E2A340025O00D49A40025O001BB240025O00805D40025O00289340025O0040A940025O006EAD40025O00108640025O00B8A940025O000C9740025O00A5B240025O00FC944003163O00476574456E656D696573496E4D656C2O6552616E6765026O002040025O005C9B40025O00E09740025O00688D40025O00ABB04003173O00476574456E656D696573496E53706C61736852616E6765025O00D89740025O00C09340025O0048AB40025O00208E40025O004CA540025O00E2B140031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O000FB240025O00E09B40025O00108140025O00BC9040025O00FEB240025O0072AC40025O0044A640025O00288F40025O0054B040025O0096B140030C3O004570696353652O74696E677303073O0044A5A7ED2O75B903053O001910CAC08A2O033O00F2C4AE03063O00949DABCD82C9025O00A06240025O00E88B40025O00349040025O00489B4003073O0017DB732EDDF33003063O009643B41449B12O033O008C171F03043O002DED787A03073O00E3E7A52BDBEDB103043O004CB788C22O033O0079E2F603073O00741A868558302F00A2042O00129E3O00014O0008000100023O00261E3O0006000100020004BF3O00060001002E310103009B040100040004BF3O009B0401000E3C2O010006000100010004BF3O0006000100129E000200013O002E31010500BC030100060004BF3O00BC03010026FC000200BC030100070004BF3O00BC03012O00D400035O0020250003000300082O004000030001000200064D00030017000100010004BF3O001700012O00D4000300013O0020B10003000300092O0039000300020002000685000300BB00013O0004BF3O00BB000100129E000300013O00261E0003001C0001000A0004BF3O001C0001002EAA000B002B0001000C0004BF3O002B00012O00D4000400033O0020CD00040004000D4O0004000200024O000400026O000400033O00202O00040004000E4O0004000200024O000400046O000400063O00202O00040004000F4O000600073O0020250006000600102O00120104000600022O0023000400053O0004BF3O00BB00010026FC0003004C000100010004BF3O004C000100129E000400013O0026FC000400320001000A0004BF3O0032000100129E000300023O0004BF3O004C00010026FC0004003B000100010004BF3O003B00012O00D4000500093O0020AE0005000500114O0005000100024O000500086O000500086O0005000A3O00122O000400023O0026FC0004002E000100020004BF3O002E00012O00D40005000A3O0026FC00050046000100120004BF3O004600012O00D4000500093O0020240105000500134O0006000B6O00078O0005000700024O0005000A4O00D40005000D4O00DA0006000E6O0005000200024O0005000C3O00122O0004000A3O00044O002E000100261E00030050000100020004BF3O00500001002E3101140018000100150004BF3O0018000100129E000400014O0008000500053O00261E00040056000100010004BF3O00560001002E3101170052000100160004BF3O0052000100129E000500013O00261E0005005B000100020004BF3O005B0001002E3101190085000100180004BF3O0085000100129E000600013O000E1601020060000100060004BF3O00600001002EAA001B00620001001A0004BF3O0062000100129E0005000A3O0004BF3O00850001002E05001C00FAFF2O001C0004BF3O005C00010026FC0006005C000100010004BF3O005C00012O00D4000700074O00C6000800103O00122O0009001D3O00122O000A001E6O0008000A00024O0007000700080020B100070007001F2O003900070002000200263501070071000100200004BF3O007100012O004E00076O0033010700014O00230007000F4O00D40007000F3O0006850007008100013O0004BF3O008100012O00D4000700074O00C6000800103O00122O000900213O00122O000A00226O0008000A00024O0007000700080020B100070007001F2O00390007000200020010DC00070020000700064D00070082000100010004BF3O0082000100129E000700014O0023000700113O00129E000600023O0004BF3O005C00010026FC000500890001000A0004BF3O0089000100129E0003000A3O0004BF3O0018000100261E0005008D000100010004BF3O008D0001002E05002300CCFF2O00240004BF3O0057000100129E000600013O00261E00060092000100020004BF3O00920001002EAA00250094000100260004BF3O0094000100129E000500023O0004BF3O0057000100261E00060098000100010004BF3O00980001002E310127008E000100280004BF3O008E00012O00D4000700074O00C6000800103O00122O000900293O00122O000A002A6O0008000A00024O0007000700080020B100070007001F2O0039000700020002002635010700A30001002B0004BF3O00A300012O004E00076O0033010700014O0023000700124O00D4000700123O000685000700B300013O0004BF3O00B300012O00D4000700074O00C6000800103O00122O0009002C3O00122O000A002D6O0008000A00024O0007000700080020B100070007001F2O00390007000200020010DC0007002B000700064D000700B4000100010004BF3O00B4000100129E000700014O0023000700133O00129E000600023O0004BF3O008E00010004BF3O005700010004BF3O001800010004BF3O005200010004BF3O00180001002EAA002E00A10401002F0004BF3O00A104012O00D400035O0020250003000300082O0040000300010002000685000300A104013O0004BF3O00A1040100129E000300014O0008000400063O0026FC000300B5030100020004BF3O00B503012O0008000600063O00261E000400CB000100010004BF3O00CB0001002E050030000D000100310004BF3O00D6000100129E000700013O0026FC000700D0000100020004BF3O00D0000100129E000400023O0004BF3O00D600010026FC000700CC000100010004BF3O00CC000100129E000500014O0008000600063O00129E000700023O0004BF3O00CC0001002E31013200C7000100330004BF3O00C70001000E3C010200C7000100040004BF3O00C7000100261E000500DE000100020004BF3O00DE0001002E310135005F2O0100340004BF3O005F2O0100129E000700014O0008000800083O002EAA003700E0000100360004BF3O00E00001000E3C2O0100E0000100070004BF3O00E0000100129E000800013O0026FC000800412O0100020004BF3O00412O01002EAA0039001F2O0100380004BF3O001F2O012O00D4000900143O0006850009001F2O013O0004BF3O001F2O0100129E000900014O0008000A000C3O002E05003A00070001003A0004BF3O00F500010026FC000900F5000100010004BF3O00F5000100129E000A00014O0008000B000B3O00129E000900023O00261E000900F9000100020004BF3O00F90001002EAA003C00EE0001003B0004BF3O00EE00012O0008000C000C3O0026FC000A000B2O0100010004BF3O000B2O0100129E000D00013O002E05003D00070001003D0004BF3O00042O010026FC000D00042O0100010004BF3O00042O0100129E000B00014O0008000C000C3O00129E000D00023O000E16010200082O01000D0004BF3O00082O01002EAA003E00FD0001003F0004BF3O00FD000100129E000A00023O0004BF3O000B2O010004BF3O00FD0001002EAA004000FA000100410004BF3O00FA00010026FC000A00FA000100020004BF3O00FA0001000E3C2O01000F2O01000B0004BF3O000F2O012O00D4000D00154O0040000D000100022O00FD000C000D3O002E050042000B000100420004BF3O001F2O01000685000C001F2O013O0004BF3O001F2O012O006C000C00023O0004BF3O001F2O010004BF3O000F2O010004BF3O001F2O010004BF3O00FA00010004BF3O001F2O010004BF3O00EE0001002E0500430021000100430004BF3O00402O012O00D4000900163O000685000900402O013O0004BF3O00402O012O00D4000900173O00064D000900402O0100010004BF3O00402O0100129E000900014O0008000A000B3O0026FC0009003A2O0100020004BF3O003A2O01002EAA0045002B2O0100440004BF3O002B2O010026FC000A002B2O0100010004BF3O002B2O012O00D4000C00184O0040000C000100022O00FD000B000C3O002E31014700402O0100460004BF3O00402O01000685000B00402O013O0004BF3O00402O012O006C000B00023O0004BF3O00402O010004BF3O002B2O010004BF3O00402O010026FC000900292O0100010004BF3O00292O0100129E000A00014O0008000B000B3O00129E000900023O0004BF3O00292O0100129E0008000A3O0026FC000800452O01000A0004BF3O00452O0100129E0005000A3O0004BF3O005F2O01002E31014900E5000100480004BF3O00E50001000E3C2O0100E5000100080004BF3O00E5000100129E000900013O00261E0009004E2O0100020004BF3O004E2O01002E31014B00502O01004A0004BF3O00502O0100129E000800023O0004BF3O00E500010026FC0009004A2O0100010004BF3O004A2O012O00D4000A00194O0040000A000100022O00FD0006000A3O00064D000600592O0100010004BF3O00592O01002E31014C005A2O01004D0004BF3O005A2O012O006C000600023O00129E000900023O0004BF3O004A2O010004BF3O00E500010004BF3O005F2O010004BF3O00E00001002E31014F00922O01004E0004BF3O00922O010026FC000500922O0100500004BF3O00922O012O00D40007001A3O002635010700682O0100500004BF3O00682O01002E31015100762O0100520004BF3O00762O0100129E000700014O0008000800083O0026FC0007006A2O0100010004BF3O006A2O012O00D40009001B4O00400009000100022O00FD000800093O002E0500530007000100530004BF3O00762O01000685000800762O013O0004BF3O00762O012O006C000800023O0004BF3O00762O010004BF3O006A2O012O00D4000700074O0031000800103O00122O000900543O00122O000A00556O0008000A00024O00070007000800202O0007000700564O00070002000200062O000700822O0100010004BF3O00822O01002E0500570021030100580004BF3O00A104012O00D4000700093O0020A40007000700594O000800073O00202O00080008005A4O0009000A6O0007000A000200062O0007008C2O0100010004BF3O008C2O01002E31015C00A10401005B0004BF3O00A104012O00D4000700103O00129D0008005D3O00122O0009005E6O000700096O00075O00044O00A104010026FC00050091020100010004BF3O0091020100129E000700014O0008000800083O0026FC000700962O0100010004BF3O00962O0100129E000800013O002EAA005F004E020100600004BF3O004E02010026FC0008004E020100020004BF3O004E020100129E000900013O002E0500610006000100610004BF3O00A42O010026FC000900A42O0100020004BF3O00A42O0100129E0008000A3O0004BF3O004E02010026FC0009009E2O0100010004BF3O009E2O01002EAA0062004A020100630004BF3O004A02012O00D4000A001A3O0026FC000A004A020100010004BF3O004A020100129E000A00014O0008000B000B3O0026FC000A00AD2O0100010004BF3O00AD2O0100129E000B00013O002E3101640016020100650004BF3O00160201000E3C2O0100160201000B0004BF3O0016020100129E000C00014O0008000D000D3O002EAA006600B62O0100670004BF3O00B62O010026FC000C00B62O0100010004BF3O00B62O0100129E000D00013O002EAA0068000F020100690004BF3O000F0201000E3C2O01000F0201000D0004BF3O000F02012O00D4000E00074O0072000F00103O00122O0010006A3O00122O0011006B6O000F001100024O000E000E000F00202O000E000E00564O000E0002000200062O000E00E12O013O0004BF3O00E12O012O00D4000E000C3O000E7A000100E12O01000E0004BF3O00E12O012O00D4000E00093O002014010E000E00594O000F00073O00202O000F000F006C4O001000116O001200063O00202O00120012006D4O001400073O00202O00140014006C4O0012001400024O001200126O000E0012000200062O000E00DC2O0100010004BF3O00DC2O01002EAA006F00E12O01006E0004BF3O00E12O012O00D4000E00103O00129E000F00703O00129E001000714O0086000E00104O0044000E6O00D4000E00074O0072000F00103O00122O001000723O00122O001100736O000F001100024O000E000E000F00202O000E000E00564O000E0002000200062O000E000E02013O0004BF3O000E02012O00D4000E001C3O000685000E000E02013O0004BF3O000E02012O00D4000E00074O0005010F00103O00122O001000743O00122O001100756O000F001100024O000E000E000F00202O000E000E00764O000E00020002000E2O0002000E0201000E0004BF3O000E02012O00D4000E001D3O00064D000E000E020100010004BF3O000E02012O00D4000E00093O00200A000E000E00594O000F00073O00202O000F000F00774O0010001E6O001100116O001200063O00202O00120012007800122O001400206O0012001400024O001200126O000E0012000200062O000E000E02013O0004BF3O000E02012O00D4000E00103O00129E000F00793O00129E0010007A4O0086000E00104O0044000E5O00129E000D00023O0026FC000D00BB2O0100020004BF3O00BB2O0100129E000B00023O0004BF3O001602010004BF3O00BB2O010004BF3O001602010004BF3O00B62O0100261E000B001A020100020004BF3O001A0201002EAA007B00B02O01007C0004BF3O00B02O012O00D4000C00074O0072000D00103O00122O000E007D3O00122O000F007E6O000D000F00024O000C000C000D00202O000C000C00564O000C0002000200062O000C003102013O0004BF3O003102012O00D4000C00074O00C6000D00103O00122O000E007F3O00122O000F00806O000D000F00024O000C000C000D0020B1000C000C00762O0039000C000200020026E8000C00310201000A0004BF3O003102012O00D4000C001D3O000685000C003302013O0004BF3O00330201002E310182004A020100810004BF3O004A02012O00D4000C00093O002057000C000C00594O000D00073O00202O000D000D00834O000E000F6O001000063O00202O00100010006D4O001200073O00202O0012001200834O0010001200024O001000106O000C0010000200062O000C004A02013O0004BF3O004A02012O00D4000C00103O00129D000D00843O00122O000E00856O000C000E6O000C5O00044O004A02010004BF3O00B02O010004BF3O004A02010004BF3O00AD2O012O00D4000A001F4O0037000A0001000100129E000900023O0004BF3O009E2O0100261E000800520201000A0004BF3O00520201002E3101860054020100870004BF3O0054020100129E000500023O0004BF3O009102010026FC000800992O0100010004BF3O00992O012O00D4000900013O0020B10009000900092O003900090002000200064D00090074020100010004BF3O0074020100129E000900014O0008000A000B3O0026FC0009006C020100020004BF3O006C02010026FC000A005F020100010004BF3O005F02012O00D4000C00204O0040000C000100022O00FD000B000C3O00064D000B0068020100010004BF3O00680201002EAA00880074020100890004BF3O007402012O006C000B00023O0004BF3O007402010004BF3O005F02010004BF3O0074020100261E00090070020100010004BF3O00700201002EAA008B005D0201008A0004BF3O005D020100129E000A00014O0008000B000B3O00129E000900023O0004BF3O005D02012O00D4000900074O0072000A00103O00122O000B008C3O00122O000C008D6O000A000C00024O00090009000A00202O0009000900564O00090002000200062O0009008D02013O0004BF3O008D02012O00D4000900213O00064D0009008D020100010004BF3O008D02012O00D4000900093O00205D0009000900594O000A00073O00202O000A000A008E4O00090002000200062O0009008D02013O0004BF3O008D02012O00D4000900103O00129E000A008F3O00129E000B00904O00860009000B4O004400095O00129E000800023O0004BF3O00992O010004BF3O009102010004BF3O00962O010026FC000500DA0001000A0004BF3O00DA000100129E000700014O0008000800083O00261E00070099020100010004BF3O00990201002E05009100FEFF2O00920004BF3O0095020100129E000800013O0026FC00080070030100020004BF3O00700301002E31019400D2020100930004BF3O00D202012O00D4000900163O000685000900D202013O0004BF3O00D2020100129E000900014O0008000A000C3O002EAA009600AA020100950004BF3O00AA0201000E3C2O0100AA020100090004BF3O00AA020100129E000A00014O0008000B000B3O00129E000900023O0026FC000900A3020100020004BF3O00A302012O0008000C000C3O0026FC000A00BE020100010004BF3O00BE020100129E000D00013O002EAA009700B6020100980004BF3O00B602010026FC000D00B6020100020004BF3O00B6020100129E000A00023O0004BF3O00BE0201002E31019900B00201009A0004BF3O00B002010026FC000D00B0020100010004BF3O00B0020100129E000B00014O0008000C000C3O00129E000D00023O0004BF3O00B002010026FC000A00AD020100020004BF3O00AD0201002EAA009C00C00201009B0004BF3O00C002010026FC000B00C0020100010004BF3O00C002012O00D4000D00224O0040000D000100022O00FD000C000D3O002E31019E00D20201009D0004BF3O00D20201000685000C00D202013O0004BF3O00D202012O006C000C00023O0004BF3O00D202010004BF3O00C002010004BF3O00D202010004BF3O00AD02010004BF3O00D202010004BF3O00A302012O00D40009001C3O00064D000900D7020100010004BF3O00D70201002E31019F006F030100A00004BF3O006F030100129E000900014O0008000A000A3O0026FC000900D9020100010004BF3O00D9020100129E000A00013O0026FC000A0001030100020004BF3O000103012O00D4000B001A3O000E04000700F00201000B0004BF3O00F002012O00D4000B00233O0020B1000B000B00A12O0039000B00020002000E7A00A200ED0201000B0004BF3O00ED02012O00D4000B00013O002015010B000B00A34O000D00073O00202O000D000D00A44O000B000D000200062O000B00F2020100010004BF3O00F202012O00D4000B00243O000685000B00F202013O0004BF3O00F20201002E3101A6006F030100A50004BF3O006F030100129E000B00014O0008000C000C3O0026FC000B00F4020100010004BF3O00F402012O00D4000D00254O0040000D000100022O00FD000C000D3O002E3101A7006F030100A80004BF3O006F0301000685000C006F03013O0004BF3O006F03012O006C000C00023O0004BF3O006F03010004BF3O00F402010004BF3O006F03010026FC000A00DC020100010004BF3O00DC020100129E000B00014O0008000C000C3O000E3C2O0100050301000B0004BF3O0005030100129E000C00013O0026FC000C000C030100020004BF3O000C030100129E000A00023O0004BF3O00DC02010026FC000C0008030100010004BF3O0008030100129E000D00013O002EAA00AA0015030100A90004BF3O001503010026FC000D0015030100020004BF3O0015030100129E000C00023O0004BF3O000803010026FC000D000F030100010004BF3O000F0301002E3101AC004D030100AB0004BF3O004D03012O00D4000E00243O000685000E004D03013O0004BF3O004D03012O00D4000E00233O0020B1000E000E00A12O0039000E000200020026E8000E004D030100A20004BF3O004D03012O00D4000E00013O0020EE000E000E00A34O001000073O00202O0010001000A44O000E0010000200062O000E004D03013O0004BF3O004D030100129E000E00014O0008000F00113O002E3101AD0045030100AE0004BF3O004503010026FC000E0045030100020004BF3O004503012O0008001100113O0026FC000F003E030100020004BF3O003E030100261E00100035030100010004BF3O00350301002EAA00B00031030100AF0004BF3O003103012O00D4001200264O00400012000100022O00FD001100123O0006850011004D03013O0004BF3O004D03012O006C001100023O0004BF3O004D03010004BF3O003103010004BF3O004D03010026FC000F002F030100010004BF3O002F030100129E001000014O0008001100113O00129E000F00023O0004BF3O002F03010004BF3O004D030100261E000E0049030100010004BF3O00490301002E3101B1002A030100B20004BF3O002A030100129E000F00014O0008001000103O00129E000E00023O0004BF3O002A0301002E0500B3001A000100B30004BF3O006703012O00D4000E001A3O000E04000700670301000E0004BF3O006703012O00D4000E00013O0020EE000E000E00B44O001000073O00202O0010001000A44O000E0010000200062O000E006703013O0004BF3O0067030100129E000E00014O0008000F000F3O000E3C2O01005B0301000E0004BF3O005B03012O00D4001000274O00400010000100022O00FD000F00103O002EAA00B60067030100B50004BF3O00670301000685000F006703013O0004BF3O006703012O006C000F00023O0004BF3O006703010004BF3O005B030100129E000D00023O0004BF3O000F03010004BF3O000803010004BF3O00DC02010004BF3O000503010004BF3O00DC02010004BF3O006F03010004BF3O00D9020100129E0008000A3O002EAA00B700AA030100B80004BF3O00AA03010026FC000800AA030100010004BF3O00AA030100129E000900013O0026FC00090079030100020004BF3O0079030100129E000800023O0004BF3O00AA0301000E3C2O010075030100090004BF3O007503012O00D4000A00163O000685000A008F03013O0004BF3O008F03012O00D4000A00283O000685000A008F03013O0004BF3O008F030100129E000A00014O0008000B000B3O002E31012B0083030100B90004BF3O008303010026FC000A0083030100010004BF3O008303012O00D4000C00294O0040000C000100022O00FD000B000C3O000685000B008F03013O0004BF3O008F03012O006C000B00023O0004BF3O008F03010004BF3O00830301002E3101BB00A8030100BA0004BF3O00A803012O00D4000A001C3O000685000A00A803013O0004BF3O00A803012O00D4000A00163O000685000A00A803013O0004BF3O00A803012O00D4000A00243O000685000A00A803013O0004BF3O00A8030100129E000A00014O0008000B000B3O0026FC000A009C030100010004BF3O009C03012O00D4000C002A4O0040000C000100022O00FD000B000C3O00064D000B00A5030100010004BF3O00A50301002E0500BC0005000100BD0004BF3O00A803012O006C000B00023O0004BF3O00A803010004BF3O009C030100129E000900023O0004BF3O007503010026FC0008009A0201000A0004BF3O009A020100129E000500503O0004BF3O00DA00010004BF3O009A02010004BF3O00DA00010004BF3O009502010004BF3O00DA00010004BF3O00A104010004BF3O00C700010004BF3O00A104010026FC000300C4000100010004BF3O00C4000100129E000400014O0008000500053O00129E000300023O0004BF3O00C400010004BF3O00A10401002EAA00BE00E8030100BF0004BF3O00E803010026FC000200E80301000A0004BF3O00E8030100129E000300014O0008000400043O002EAA00C100C2030100C00004BF3O00C203010026FC000300C2030100010004BF3O00C2030100129E000400013O0026FC000400CB030100020004BF3O00CB030100129E000200503O0004BF3O00E80301002E3101C300C7030100C20004BF3O00C70301000E3C2O0100C7030100040004BF3O00C7030100129E000500013O000E162O0100D4030100050004BF3O00D40301002EAA00C400E0030100C50004BF3O00E003012O00D40006002B4O004F0006000100024O000600066O000600216O000600013O00202O0006000600C600122O000800C76O000900073O00202O00090009005A4O0006000900024O0006000B3O00122O000500023O0026FC000500D0030100020004BF3O00D0030100129E000400023O0004BF3O00C703010004BF3O00D003010004BF3O00C703010004BF3O00E803010004BF3O00C20301000E16015000EC030100020004BF3O00EC0301002EAA00C8003B040100C90004BF3O003B040100129E000300013O0026FC000300F1030100020004BF3O00F1030100129E000200073O0004BF3O003B0401002EAA00CA00ED030100CB0004BF3O00ED03010026FC000300ED030100010004BF3O00ED030100129E000400013O0026FC00040033040100010004BF3O003304012O00D4000500063O00200C0105000500CC00122O000700A26O0005000700024O0005000E6O0005001C3O00062O0005002304013O0004BF3O0023040100129E000500014O0008000600073O0026FC00050007040100010004BF3O0007040100129E000600014O0008000700073O00129E000500023O002E3101CE0002040100CD0004BF3O000204010026FC00050002040100020004BF3O0002040100261E0006000F040100010004BF3O000F0401002E3101CF000B040100D00004BF3O000B040100129E000700013O00261E00070014040100010004BF3O00140401002E0500D100FEFF2O00D20004BF3O001004012O00D40008000B4O0030010800086O0008001A6O000800063O00202O0008000800D300122O000A00A26O0008000A00024O0008002C3O00044O003204010004BF3O001004010004BF3O003204010004BF3O000B04010004BF3O003204010004BF3O000204010004BF3O0032040100129E000500014O0008000600063O0026FC00050025040100010004BF3O0025040100129E000600013O0026FC00060028040100010004BF3O0028040100129E000700024O00230007001A3O00129E000700024O00230007002C3O0004BF3O003204010004BF3O002804010004BF3O003204010004BF3O0025040100129E000400023O00261E00040037040100020004BF3O00370401002E0500D400C1FF2O00D50004BF3O00F6030100129E000300023O0004BF3O00ED03010004BF3O00F603010004BF3O00ED0301002E3101D6006C040100D70004BF3O006C04010026FC0002006C040100010004BF3O006C040100129E000300014O0008000400043O0026FC00030041040100010004BF3O0041040100129E000400013O00261E00040048040100020004BF3O00480401002E3101D8004A040100D90004BF3O004A040100129E000200023O0004BF3O006C0401002EAA00DB0044040100DA0004BF3O004404010026FC00040044040100010004BF3O0044040100129E000500013O002E3101DC0062040100DD0004BF3O006204010026FC00050062040100010004BF3O006204012O00D40006002D4O008E00060001000100122O000600DE6O000700103O00122O000800DF3O00122O000900E06O0007000900024O0006000600074O000700103O00122O000800E13O00122O000900E26O0007000900024O0006000600074O0006002E3O00122O000500023O00261E00050066040100020004BF3O00660401002E0500E300EBFF2O00E40004BF3O004F040100129E000400023O0004BF3O004404010004BF3O004F04010004BF3O004404010004BF3O006C04010004BF3O004104010026FC00020009000100020004BF3O0009000100129E000300014O0008000400043O002EAA00E50070040100E60004BF3O007004010026FC00030070040100010004BF3O0070040100129E000400013O0026FC00040079040100020004BF3O0079040100129E0002000A3O0004BF3O00090001000E3C2O010075040100040004BF3O007504010012A9000500DE4O00C6000600103O00122O000700E73O00122O000800E86O0006000800024O0005000500062O00C6000600103O00122O000700E93O00122O000800EA6O0006000800024O0005000500062O00230005001C3O00122E010500DE6O000600103O00122O000700EB3O00122O000800EC6O0006000800024O0005000500064O000600103O00122O000700ED3O00122O000800EE6O0006000800024O0005000500064O000500163O00122O000400023O00044O007504010004BF3O000900010004BF3O007004010004BF3O000900010004BF3O00A104010004BF3O000600010004BF3O00A104010026FC3O0002000100010004BF3O0002000100129E000100014O0008000200023O00129E3O00023O0004BF3O000200012O000E012O00017O00103O00028O00025O0034AD40025O00D8AC40026O00F03F025O00DCAD40025O00B88940025O0062B340025O0094A84003143O00CD17CBF73A27C3EF2ED5E33137C8DF1BDBF7302403073O00AD9B7EB982564203143O00526567697374657241757261547261636B696E6703143O00C3A3A9D38DFEECA8BDF087F9EBA29EC28AF9E3A003063O008C85C6DAA7E803053O005072696E74032A3O008020BC7288AC6E9056C4B737F45894BC2DFA3DB3BA3CBF3D8DBB6E846F8BB23CB16E97F509BB778DA72F03053O00E4D54ED41D003C3O00129E3O00013O0026FC3O0030000100010004BF3O0030000100129E000100014O0008000200023O002E3101030005000100020004BF3O000500010026FC00010005000100010004BF3O0005000100129E000200013O000E160104000E000100020004BF3O000E0001002EAA00050010000100060004BF3O0010000100129E3O00043O0004BF3O003000010026FC0002000A000100010004BF3O000A000100129E000300013O00261E00030017000100010004BF3O00170001002E0500070013000100080004BF3O002800012O00D400046O00C6000500013O00122O000600093O00122O0007000A6O0005000700024O0004000400050020B100040004000B2O00070104000200012O00D400046O00C6000500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400050020B100040004000B2O000701040002000100129E000300043O0026FC00030013000100040004BF3O0013000100129E000200043O0004BF3O000A00010004BF3O001300010004BF3O000A00010004BF3O003000010004BF3O00050001000E3C0104000100013O0004BF3O000100012O00D4000100023O00203B00010001000E4O000200013O00122O0003000F3O00122O000400106O000200046O00013O000100044O003B00010004BF3O000100012O000E012O00017O00", GetFEnv(), ...);

