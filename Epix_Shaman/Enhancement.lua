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
				if (Enum <= 183) then
					if (Enum <= 91) then
						if (Enum <= 45) then
							if (Enum <= 22) then
								if (Enum <= 10) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if (Stk[Inst[2]] == Stk[Inst[4]]) then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 2) then
											local A = Inst[2];
											do
												return Stk[A](Unpack(Stk, A + 1, Inst[3]));
											end
										elseif (Enum > 3) then
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
									elseif (Enum <= 7) then
										if (Enum <= 5) then
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
										elseif (Enum > 6) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 8) then
										local B = Stk[Inst[4]];
										if B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									elseif (Enum == 9) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
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
										if (Inst[2] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 16) then
									if (Enum <= 13) then
										if (Enum <= 11) then
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
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
									elseif (Enum <= 14) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 15) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Stk[Inst[4]]];
									end
								elseif (Enum <= 19) then
									if (Enum <= 17) then
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									elseif (Enum == 18) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 20) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 33) then
								if (Enum <= 27) then
									if (Enum <= 24) then
										if (Enum == 23) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 25) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 26) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 30) then
									if (Enum <= 28) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 31) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 32) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 39) then
								if (Enum <= 36) then
									if (Enum <= 34) then
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
										Stk[Inst[2]] = Inst[3];
									elseif (Enum > 35) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 38) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 42) then
								if (Enum <= 40) then
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
								elseif (Enum > 41) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
								else
									do
										return;
									end
								end
							elseif (Enum <= 43) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 44) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 56) then
								if (Enum <= 50) then
									if (Enum <= 47) then
										if (Enum > 46) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										else
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
										end
									elseif (Enum <= 48) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									elseif (Enum == 49) then
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
								elseif (Enum <= 53) then
									if (Enum <= 51) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									elseif (Enum > 52) then
										local Edx;
										local Results, Limit;
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum <= 54) then
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
								elseif (Enum > 55) then
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
							elseif (Enum <= 62) then
								if (Enum <= 59) then
									if (Enum <= 57) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 58) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
									end
								elseif (Enum <= 60) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 61) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 65) then
								if (Enum <= 63) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 64) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
							elseif (Enum <= 66) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 67) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 79) then
							if (Enum <= 73) then
								if (Enum <= 70) then
									if (Enum > 69) then
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
										if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 71) then
									if (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 72) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 76) then
								if (Enum <= 74) then
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
								elseif (Enum == 75) then
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
								end
							elseif (Enum <= 77) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 85) then
							if (Enum <= 82) then
								if (Enum <= 80) then
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
								elseif (Enum > 81) then
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
								elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 84) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 86) then
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
							elseif (Enum > 87) then
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
							end
						elseif (Enum <= 89) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 90) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 137) then
						if (Enum <= 114) then
							if (Enum <= 102) then
								if (Enum <= 96) then
									if (Enum <= 93) then
										if (Enum == 92) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 94) then
										local A = Inst[2];
										local B = Inst[3];
										for Idx = A, B do
											Stk[Idx] = Vararg[Idx - A];
										end
									elseif (Enum > 95) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 99) then
									if (Enum <= 97) then
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
									elseif (Enum > 98) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 100) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 101) then
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
							elseif (Enum <= 108) then
								if (Enum <= 105) then
									if (Enum <= 103) then
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									elseif (Enum == 104) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 106) then
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 111) then
								if (Enum <= 109) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 110) then
									VIP = Inst[3];
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
							elseif (Enum <= 112) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 113) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
							end
						elseif (Enum <= 125) then
							if (Enum <= 119) then
								if (Enum <= 116) then
									if (Enum > 115) then
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 118) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[A] = Stk[A]();
								end
							elseif (Enum <= 122) then
								if (Enum <= 120) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								elseif (Enum > 121) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 123) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 124) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 131) then
							if (Enum <= 128) then
								if (Enum <= 126) then
									Stk[Inst[2]]();
								elseif (Enum == 127) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum <= 129) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 130) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 134) then
							if (Enum <= 132) then
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
							elseif (Enum == 133) then
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
							end
						elseif (Enum <= 135) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 136) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 160) then
						if (Enum <= 148) then
							if (Enum <= 142) then
								if (Enum <= 139) then
									if (Enum == 138) then
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
										local Edx;
										local Results, Limit;
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 140) then
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
								elseif (Enum > 141) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 145) then
								if (Enum <= 143) then
									Env[Inst[3]] = Stk[Inst[2]];
								elseif (Enum == 144) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 146) then
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
							elseif (Enum == 147) then
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
							if (Enum <= 151) then
								if (Enum <= 149) then
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
								elseif (Enum == 150) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 152) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 153) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 157) then
							if (Enum <= 155) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 156) then
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
									if (Mvm[1] == 114) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
						elseif (Enum <= 158) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 159) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 171) then
						if (Enum <= 165) then
							if (Enum <= 162) then
								if (Enum == 161) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 163) then
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
							elseif (Enum > 164) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							end
						elseif (Enum <= 168) then
							if (Enum <= 166) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 167) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							end
						elseif (Enum <= 169) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 170) then
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
					elseif (Enum <= 177) then
						if (Enum <= 174) then
							if (Enum <= 172) then
								local A = Inst[2];
								local Results = {Stk[A]()};
								local Limit = Inst[4];
								local Edx = 0;
								for Idx = A, Limit do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 173) then
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
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 175) then
							local A = Inst[2];
							Stk[A](Stk[A + 1]);
						elseif (Enum == 176) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 180) then
						if (Enum <= 178) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 179) then
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
						elseif (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 181) then
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
					elseif (Enum > 182) then
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
				elseif (Enum <= 275) then
					if (Enum <= 229) then
						if (Enum <= 206) then
							if (Enum <= 194) then
								if (Enum <= 188) then
									if (Enum <= 185) then
										if (Enum == 184) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
										end
									elseif (Enum <= 186) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 187) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = {};
									end
								elseif (Enum <= 191) then
									if (Enum <= 189) then
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									elseif (Enum == 190) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum > 193) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 200) then
								if (Enum <= 197) then
									if (Enum <= 195) then
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
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 198) then
									local A;
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
								elseif (Enum > 199) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 203) then
								if (Enum <= 201) then
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
								elseif (Enum > 202) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 205) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 217) then
							if (Enum <= 211) then
								if (Enum <= 208) then
									if (Enum > 207) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 209) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 210) then
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
							elseif (Enum <= 214) then
								if (Enum <= 212) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum > 213) then
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
							elseif (Enum <= 215) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 216) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 223) then
							if (Enum <= 220) then
								if (Enum <= 218) then
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
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								end
							elseif (Enum <= 221) then
								local B;
								local A;
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
							elseif (Enum > 222) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 226) then
							if (Enum <= 224) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 225) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Inst[2] <= Stk[Inst[4]]) then
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
					elseif (Enum <= 252) then
						if (Enum <= 240) then
							if (Enum <= 234) then
								if (Enum <= 231) then
									if (Enum > 230) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 232) then
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
								elseif (Enum > 233) then
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
							elseif (Enum <= 237) then
								if (Enum <= 235) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 236) then
									local B;
									local A;
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
							elseif (Enum <= 238) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 239) then
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
						elseif (Enum <= 246) then
							if (Enum <= 243) then
								if (Enum <= 241) then
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
								elseif (Enum > 242) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								end
							elseif (Enum <= 244) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 245) then
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
							end
						elseif (Enum <= 249) then
							if (Enum <= 247) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 248) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 250) then
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
						elseif (Enum == 251) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 263) then
						if (Enum <= 257) then
							if (Enum <= 254) then
								if (Enum == 253) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 255) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 260) then
							if (Enum <= 258) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							elseif (Enum == 259) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 261) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 262) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 269) then
						if (Enum <= 266) then
							if (Enum <= 264) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 265) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
						elseif (Enum > 268) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						end
					elseif (Enum <= 272) then
						if (Enum <= 270) then
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 271) then
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
						end
					elseif (Enum <= 273) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 274) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 321) then
					if (Enum <= 298) then
						if (Enum <= 286) then
							if (Enum <= 280) then
								if (Enum <= 277) then
									if (Enum == 276) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 278) then
									local Edx;
									local Results, Limit;
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 283) then
								if (Enum <= 281) then
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
								elseif (Enum > 282) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 284) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 285) then
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
						elseif (Enum <= 292) then
							if (Enum <= 289) then
								if (Enum <= 287) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 288) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 290) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 291) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
							end
						elseif (Enum <= 295) then
							if (Enum <= 293) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 294) then
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							end
						elseif (Enum <= 296) then
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 297) then
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
					elseif (Enum <= 309) then
						if (Enum <= 303) then
							if (Enum <= 300) then
								if (Enum == 299) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								end
							elseif (Enum <= 301) then
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
							elseif (Enum == 302) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
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
						elseif (Enum <= 306) then
							if (Enum <= 304) then
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
							elseif (Enum > 305) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 307) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 308) then
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
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 315) then
						if (Enum <= 312) then
							if (Enum <= 310) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 311) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 313) then
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 314) then
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
						elseif (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 318) then
						if (Enum <= 316) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 317) then
							Stk[Inst[2]] = Inst[3] ~= 0;
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
						end
					elseif (Enum <= 319) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 320) then
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
				elseif (Enum <= 344) then
					if (Enum <= 332) then
						if (Enum <= 326) then
							if (Enum <= 323) then
								if (Enum == 322) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[A] = Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 324) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 325) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 329) then
							if (Enum <= 327) then
								do
									return Stk[Inst[2]];
								end
							elseif (Enum > 328) then
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
						elseif (Enum <= 330) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 331) then
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 338) then
						if (Enum <= 335) then
							if (Enum <= 333) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 334) then
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
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
						elseif (Enum <= 336) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 337) then
							Stk[Inst[2]] = #Stk[Inst[3]];
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
					elseif (Enum <= 341) then
						if (Enum <= 339) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							B = Stk[Inst[4]];
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						elseif (Enum > 340) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						else
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 342) then
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
					elseif (Enum == 343) then
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
				elseif (Enum <= 356) then
					if (Enum <= 350) then
						if (Enum <= 347) then
							if (Enum <= 345) then
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
								Stk[Inst[2]] = Inst[3];
							elseif (Enum > 346) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								VIP = Inst[3];
							end
						elseif (Enum <= 348) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 349) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 353) then
						if (Enum <= 351) then
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
						elseif (Enum == 352) then
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
					elseif (Enum <= 354) then
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
					elseif (Enum == 355) then
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
						if (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 362) then
					if (Enum <= 359) then
						if (Enum <= 357) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 358) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						end
					elseif (Enum <= 360) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 361) then
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
					elseif (Stk[Inst[2]] > Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 365) then
					if (Enum <= 363) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 364) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						if (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 366) then
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
				elseif (Enum == 367) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD988CF1FDCC2D51AC3B5CF1FDFC0DE28E3B5D350DDD6DA03083O007EB1A3BB4586DBA7031B3O005B63A54D4140A4547372A26A5B7DA4542O70A9587B7DB81B7266AD03043O00351E13CC002E3O0012343O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100046F3O000A00010012D4000300063O00201B0004000300070012D4000500083O00201B0005000500090012D4000600083O00201B00060006000A00069C00073O000100062O00723O00064O00728O00723O00044O00723O00014O00723O00024O00723O00053O00201B00080003000B00201B00090003000C2O00BB000A5O0012D4000B000D3O00069C000C0001000100022O00723O000A4O00723O000B4O0072000D00073O00120E010E000E3O00120E010F000F4O0050010D000F000200069C000E0002000100032O00723O00074O00723O00094O00723O00084O009D000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O004100025O00122O000300016O00045O00122O000500013O00042O0003002100012O00B900076O0043000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004610103000500012O00B9000300054O0072000400024O0002000300044O000701036O00293O00017O000A3O00028O00026O00F03F025O00389440025O005CA840025O00449F40025O00207540025O00A4B140025O00606E40025O003EAD40025O00389D40014C3O00120E010200014O0067000300053O00261C010200070001000100046F3O0007000100120E010300014O0067000400043O00120E010200023O00261C010200020001000200046F3O000200012O0067000500053O000E41010200410001000300046F3O0041000100120E010600013O00261C0106000D0001000100046F3O000D0001002665000400130001000100046F3O00130001002E47000300260001000400046F3O0037000100120E010700014O0067000800083O00261C010700150001000100046F3O0015000100120E010800013O00261C0108001C0001000200046F3O001C000100120E010400023O00046F3O00370001002665000800200001000100046F3O00200001002E82000500180001000600046F3O0018000100120E010900013O00261C0109002D0001000100046F3O002D00012O00B9000A6O00F90005000A3O0006A20005002C0001000100046F3O002C00012O00B9000A00014O0072000B6O00F3000C6O00A4000A6O0007010A5O00120E010900023O002665000900310001000200046F3O00310001002E39010700210001000800046F3O0021000100120E010800023O00046F3O0018000100046F3O0021000100046F3O0018000100046F3O0037000100046F3O0015000100261C0104000C0001000200046F3O000C00012O0072000700054O00F300086O00A400076O000701075O00046F3O000C000100046F3O000D000100046F3O000C000100046F3O004B0001002E82000A000A0001000900046F3O000A000100261C0103000A0001000100046F3O000A000100120E010400014O0067000500053O00120E010300023O00046F3O000A000100046F3O004B000100046F3O000200012O00293O00017O004F3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00CF47A24AF003043O00269C37C7030A3O008568703C1A47EA46A47103083O0023C81D1C4873149A03043O0030ABD4D203073O005479DFB1BFED4C03043O009857DAB403083O00A1DB36A9C05A305003053O00644303374603043O004529226003053O008CD1D2191103063O004BDCA3B76A6203073O0021B5863AD60CA903053O00B962DAEB5703083O00EE2A22F4C7A5C53903063O00CAAB5C4786BE2O033O0027D42103043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E179303043O00B4E625C703083O00A7D6894AAB78CE5303143O00476574576561706F6E456E6368616E74496E666F03043O006D6174682O033O0086F12A03063O00C7EB90523D9803063O00737472696E6703053O000A17AD280F03043O004B6776D903063O00F45C7119B81003063O007EA7341074D9030B3O00ED202881BA1AF9C52B2E9403073O009CA84E40E0D47903063O0034E6A4C306E003043O00AE678EC5030B3O00732657392B5DFD5B2D512C03073O009836483F58453E03063O00E7CCEF51D5CA03043O003CB4A48E030B3O007D500D2829EE17555B0B3D03073O0072383E6549478D03093O0094E8CDC59AFCC9D7AC03043O00A4D889BB030B3O004973417661696C61626C65027O0040026O00F03F030E3O00FEEF36BAB2F002DCE17190A9F21F03073O006BB28651D2C69E024O0080B3C54003103O005265676973746572466F724576656E74030E3O00F03FA7DBE6F030A1DFEBED28A7D303053O00AAA36FE29703143O003D15930A60120D2E03821D621B16381E8D0C6F1503073O00497150D2582E5703143O002AC1992O898F9828C89F953O8234CC9A9C899903073O00C77A8DD8D0CCDD03073O008ED21DFD77F8BE03063O0096CDBD70901803084O0092BA5E1D871F1503083O007045E4DF2C64E87103243O0066EF01F53262F305F0257EE907E33777E916F5256BE50FFD306EE31BE3276FED1BFB216303053O006427AC55BC03063O0053657441504C025O002O7040004B023O0092000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O001218000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O0012180009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O001218000B000E3O00122O000C000F6O000A000C00024O000A0004000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00120E010D00123O00120E010E00134O0050010C000E00022O00F9000C0004000C001250000D00046O000E5O00122O000F00143O00122O001000156O000E001000024O000E000D000E4O000F5O00122O001000163O00122O001100176O000F001100022O0074000F000D000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000D00104O00115O00122O0012001A3O00122O0013001B6O0011001300022O00740011000D00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0011001100124O00125O00122O0013001E3O00122O0014001F6O0012001400022O00740011001100124O00125O00122O001300203O00122O001400216O0012001400024O0012000D00124O00135O00122O001400223O00122O001500236O0013001500022O00F90012001200132O00B900135O00120E011400243O00120E011500254O003A0013001500024O00120012001300122O001300263O00122O001400276O00155O00122O001600283O00122O001700296O0015001700024O00140014001500122O0015002A4O00B900165O0012860017002B3O00122O0018002C6O0016001800024O0015001500164O001600166O00178O00188O00198O001A8O001B6O0067001C005C4O00FF005D5O00122O005E002D3O00122O005F002E6O005D005F00024O005D000A005D4O005E5O00122O005F002F3O00122O006000306O005E006000024O005D005D005E2O00FF005E5O00122O005F00313O00122O006000326O005E006000024O005E000C005E4O005F5O00122O006000333O00122O006100346O005F006100024O005E005E005F2O00FF005F5O00122O006000353O00122O006100366O005F006100024O005F000F005F4O00605O00122O006100373O00122O006200386O0060006200024O005F005F00602O00BB00606O0067006100684O00E400695O00122O006A00393O00122O006B003A6O0069006B00024O0069005D006900202O00690069003B4O00690002000200062O0069009A00013O00046F3O009A000100120E0169003C3O0006A20069009B0001000100046F3O009B000100120E0169003D4O00B9006A5O001260006B003E3O00122O006C003F6O006A006C000200122O006B00403O00122O006C00403O00202O006D0004004100069C006F3O000100032O00723O00694O00723O005D4O00B98O00D200705O00122O007100423O00122O007200436O0070007200024O00715O00122O007200443O00122O007300456O007100736O006D3O000100202O006D0004004100069C006F0001000100042O00723O006A4O00B98O00723O006B4O00723O006C4O00F100705O00122O007100463O00122O007200476O007000726O006D3O00014O006D5O00122O006E00483O00122O006F00496O006D006F00024O006D000D006D4O006E5O00122O006F004A3O00122O0070004B6O006E007000024O006D006D006E00069C006E0002000100032O00723O005D4O00B98O00723O006D3O002002016F0004004100069C00710003000100012O00723O006E4O00AA00725O00122O0073004C3O00122O0074004D6O007200746O006F3O000100069C006F0004000100032O00723O00154O00723O00084O00B97O00069C00700005000100032O00723O005D4O00B98O00723O00083O00069C00710006000100012O00723O005D3O00069C00720007000100012O00723O005D3O00069C00730008000100012O00723O005D3O00069C00740009000100022O00723O00084O00723O005D3O00069C0075000A000100022O00723O00094O00723O005D3O00069C0076000B000100022O00723O005D4O00B97O00069C0077000C000100032O00723O005D4O00B98O00723O00673O00069C0078000D000100062O00723O005D4O00B98O00723O001B4O00723O006D4O00723O00104O00723O005F3O00069C0079000E000100072O00723O004A4O00723O00404O00723O005D4O00B98O00723O00084O00723O00104O00723O005F3O00069C007A000F000100052O00723O00084O00723O004E4O00723O005D4O00B98O00723O00103O00069C007B0010000100162O00723O005D4O00B98O00723O003F4O00723O006D4O00723O00484O00723O00494O00723O00104O00723O00404O00723O00084O00723O004A4O00723O005E4O00723O00414O00723O004B4O00723O005F4O00723O00424O00723O004C4O00723O00574O00723O003D4O00723O00454O00723O003E4O00723O00464O00723O00473O00069C007C0011000100042O00723O00164O00723O006D4O00723O00604O00723O00193O00069C007D00120001000F2O00723O005D4O00B98O00723O002F4O00723O00344O00723O00194O00723O00104O00723O00094O00723O00294O00723O00354O00723O001A4O00723O00284O00723O002A4O00723O00084O00723O002E4O00723O00333O00069C007E0013000100222O00723O005D4O00B98O00723O00274O00723O00364O00723O001A4O00723O005B4O00723O006C4O00723O00094O00723O00104O00723O00214O00723O001F4O00723O00084O00723O00294O00723O00354O00723O00264O00723O006A4O00B93O00014O00B93O00024O00723O00284O00723O00254O00723O002A4O00723O00694O00723O001D4O00723O00244O00723O001E4O00723O00704O00723O00234O00723O00224O00723O002B4O00723O00314O00723O00384O00723O00194O00723O00204O00723O00113O00069C007F0014000100222O00723O005D4O00B98O00723O00214O00723O00094O00723O00674O00723O006D4O00723O00664O00723O00714O00723O00204O00723O00104O00723O00284O00723O00084O00723O001E4O00723O00234O00723O00224O00723O00294O00723O00354O00723O001A4O00723O005B4O00723O006C4O00723O00264O00B93O00014O00723O00114O00B93O00024O00723O00254O00723O00274O00723O00364O00723O001F4O00723O00694O00723O001D4O00723O002B4O00723O002A4O00723O00724O00723O00703O00069C00800015000100222O00723O005D4O00B98O00723O002A4O00723O00084O00723O00104O00723O00214O00723O00094O00723O00224O00723O00284O00723O00234O00723O001E4O00723O00674O00723O002B4O00723O00254O00723O00264O00B93O00014O00723O00114O00B93O00024O00723O001D4O00723O00244O00723O00704O00723O00294O00723O00354O00723O001A4O00723O005B4O00723O006C4O00723O00204O00723O00274O00723O00364O00723O006D4O00723O00664O00723O00714O00723O001F4O00723O00693O00069C00810016000100122O00723O00434O00723O005D4O00B98O00723O00084O00723O00444O00723O00104O00723O00614O00723O00634O00723O002C4O00723O00094O00723O006D4O00723O00174O00723O007D4O00723O00624O00723O00644O00723O004D4O00723O00164O00723O007A3O00069C008200170001002D2O00723O00554O00723O00514O00723O00164O00723O006D4O00723O005D4O00723O00084O00723O00524O00723O005F4O00723O004F4O00723O00504O00723O00564O00723O00544O00723O00784O00B98O00723O005C4O00723O001B4O00723O00534O00723O00094O00723O00104O00723O002F4O00723O00344O00723O00194O00723O005B4O00723O006C4O00723O00674O00723O007E4O00723O00184O00723O007F4O00723O000D4O00723O00304O00723O00374O00723O007C4O00723O00314O00723O00384O00723O002E4O00723O00334O00723O002D4O00723O00324O00723O006A4O00723O002B4O00723O00274O00723O00364O00723O001A4O00723O00794O00723O007B3O00069C00830018000100192O00723O002C4O00B98O00723O00324O00723O00344O00723O00254O00723O00234O00723O00244O00723O00294O00723O002B4O00723O002A4O00723O00224O00723O00204O00723O00214O00723O001F4O00723O001D4O00723O001E4O00723O00264O00723O00274O00723O00284O00723O002D4O00723O002F4O00723O002E4O00723O00334O00723O00364O00723O00353O00069C00840019000100172O00723O00524O00B98O00723O003F4O00723O00464O00723O00474O00723O00394O00723O003A4O00723O003B4O00723O004A4O00723O00434O00723O00444O00723O005C4O00723O004D4O00723O004E4O00723O003E4O00723O003D4O00723O00404O00723O004F4O00723O00504O00723O00514O00723O00454O00723O00484O00723O00493O00069C0085001A000100122O00723O00594O00B98O00723O005B4O00723O00584O00723O00554O00723O00564O00723O005A4O00723O00544O00723O00534O00723O004B4O00723O004C4O00723O00574O00723O00374O00723O00304O00723O00314O00723O00424O00723O00384O00723O00413O00069C0086001B000100242O00723O00844O00723O00834O00723O00854O00723O00174O00B98O00723O00654O00723O00084O00723O00664O00723O00614O00723O00634O00723O00624O00723O00644O00723O00134O00723O00544O00723O00164O00723O00784O00723O00554O00723O00514O00723O006D4O00723O005D4O00723O00524O00723O005F4O00723O004F4O00723O00504O00723O00824O00723O00814O00723O00184O00723O00684O00723O00674O00723O001B4O00723O006B4O00723O00044O00723O006C4O00723O006A4O00723O001A4O00723O00193O00069C0087001C000100042O00723O005D4O00B98O00723O006E4O00723O000D3O0020560088000D004E00122O0089004F6O008A00866O008B00876O0088008B00016O00013O001D3O00053O0003093O00140F94C7882D1C91D203053O00CA586EE2A6030B3O004973417661696C61626C65027O0040026O00F03F00104O00893O00016O000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000D00013O00046F3O000D000100120E012O00043O0006A23O000E0001000100046F3O000E000100120E012O00054O002A8O00293O00017O00093O00028O00025O00A07240025O00ECA940030E3O00AD25CA1AF38F25C315A7A323C10603053O0087E14CAD72024O0080B3C540026O00F03F025O00109240025O0040A940001C3O00120E012O00014O0067000100013O002E82000200020001000300046F3O0002000100261C012O00020001000100046F3O0002000100120E2O0100013O00261C2O0100110001000100046F3O001100012O00B9000200013O001228000300043O00122O000400056O0002000400024O00025O00122O000200066O000200023O00122O000100073O002E39010800070001000900046F3O00070001000E41010700070001000100046F3O0007000100120E010200064O002A000200033O00046F3O001B000100046F3O0007000100046F3O001B000100046F3O000200012O00293O00017O00073O00030D3O00F71302D2B86F83E70F0EC1BF6803073O00E6B47F67B3D61C030B3O004973417661696C61626C6503123O00A80C4C56E14DEC8D075343C044E29903595503073O0080EC653F26842103173O0088A00254B3E7C3ADAB1D4195FEDDBFAC3541B4FEC9AABA03073O00AFCCC97124D68B00174O00899O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001600013O00046F3O001600012O00B93O00024O0080000100013O00122O000200043O00122O000300056O0001000300024O000200026O000300013O00122O000400063O00122O000500076O0003000500024O0002000200036O000100022O00293O00019O003O00034O00B98O007E3O000100012O00293O00017O00073O00026O00F03F026O001840025O00488840025O00C4A34003093O00546F74656D4E616D6503053O009977AD853E03053O0053CD18D9E000153O00120E012O00013O00120E2O0100023O00120E010200013O00041A012O00140001002E39010300130001000400046F3O001300012O00B900046O00D8000500013O00202O0005000500054O000700036O0005000700024O000600023O00122O000700063O00122O000800076O000600086O00043O000200062O0004001300013O00046F3O001300012O0047010300023O000461012O000400012O00293O00017O001E3O00028O00025O0042AD40025O0036A540026O00F03F025O004EB340025O00CC9A4003093O00C7C9DD35E7F2C231E003043O005D86A5AD030B3O004973417661696C61626C6503083O0042752O66446F776E030F3O00466572616C53706972697442752O66025O003EA740025O0048B14003073O006D6174686D696E030E3O009DE0C0D132E2BB79B6E6CFCB34C903083O001EDE92A1A25AAED203113O0054696D6553696E63654C61737443617374030E3O00C6467103EB62790DED5A7E03EB4903043O006A852E10025O00A4A640025O00F09040026O002040030B3O007E2561FD5673482961F54E03063O00203840139C3A025O00C05940025O00EEAF40025O00B8A740025O002CA440025O00E06F40026O00834000673O00120E012O00014O0067000100023O002E82000300540001000200046F3O0054000100261C012O00540001000400046F3O0054000100120E010300013O0026650003000B0001000100046F3O000B0001002E47000500FEFF2O000600046F3O0007000100261C2O0100360001000100046F3O003600012O00B900046O00E4000500013O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O00040002000200062O0004002000013O00046F3O002000012O00B9000400023O0020BC00040004000A4O00065O00202O00060006000B4O00040006000200062O000400200001000100046F3O00200001002E39010D00220001000C00046F3O0022000100120E010400014O0047010400023O0012D40004000E4O003300058O000600013O00122O0007000F3O00122O000800106O0006000800024O00050005000600202O0005000500114O0005000200024O00068O000700013O00120E010800123O0012A7000900136O0007000900024O00060006000700202O0006000600114O000600076O00043O00024O000200043O00122O000100043O00261C2O0100060001000400046F3O0006000100120E010400013O002E82001500390001001400046F3O0039000100261C010400390001000100046F3O00390001000EA80016004B0001000200046F3O004B00012O00B900056O000D010600013O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500114O00050002000200062O0005004B0001000200046F3O004B0001002E47001900040001001A00046F3O004D000100120E010500014O0047010500023O00106A0005001600022O0047010500023O00046F3O0039000100046F3O0006000100046F3O0007000100046F3O0006000100046F3O00660001002E39011C00020001001B00046F3O0002000100261C012O00020001000100046F3O0002000100120E010300013O00261C0103005E0001000100046F3O005E000100120E2O0100014O0067000200023O00120E010300043O002665000300620001000400046F3O00620001002E39011E00590001001D00046F3O0059000100120E012O00043O00046F3O0002000100046F3O0059000100046F3O000200012O00293O00017O00023O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O6601063O00206300013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O0003113O00446562752O665265667265736861626C6503133O004C617368696E67466C616D6573446562752O6601063O00206300013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O6601063O00206300013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O0003083O0042752O66446F776E03123O005072696D6F726469616C5761766542752O6601074O00DE00015O00202O0001000100014O000300013O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303133O004C617368696E67466C616D6573446562752O6601074O00DE00015O00202O0001000100014O000300013O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O0076C9F65E53FC877CC4E45B5FE103073O00E03AA885363A92030B3O004973417661696C61626C65010A4O00DB00018O000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O0001000200024O000100028O00017O00083O0003083O00446562752O66557003103O00466C616D6553686F636B446562752O6603103O007F5A4AF070B58F045A5D6FF87793810D03083O006B39362B9D15E6E7030F3O0041757261416374697665436F756E7403103O00FD8710F8BCEFC7D4881AD1BCDEDADD8D03073O00AFBBEB7195D9BC026O001840011F3O0020EE00013O00014O00035O00202O0003000300024O00010003000200062O0001001D00013O00046F3O001D00012O00B900016O0025010200013O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O0001000200024O000200023O00062O0001001B0001000200046F3O001B00012O00B900016O004C010200013O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100054O00010002000200262O0001001C0001000800046F3O001C00012O00092O016O003E2O0100014O00472O0100024O00293O00017O000C3O00030D3O001FA3844DED6A7D0FBF885EEA6D03073O00185CCFE12C831903073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O003940025O001CAF40025O00F8A64003123O00436C65616E7365537069726974466F637573025O009EAD40025O004CB24003153O0048DFBD4D156E4EECAB5C126F42C7F848126E5BD6B403063O001D2BB3D82C7B00234O00899O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001300013O00046F3O001300012O00B93O00023O000635012O001300013O00046F3O001300012O00B93O00033O00201B5O000400120E2O0100054O0043012O000200020006A23O00150001000100046F3O00150001002E82000600220001000700046F3O002200012O00B93O00044O00B9000100053O00201B0001000100082O0043012O000200020006A23O001D0001000100046F3O001D0001002E39010A00220001000900046F3O002200012O00B93O00013O00120E2O01000B3O00120E0102000C4O00023O00024O0007017O00293O00017O00193O00028O00025O00DEA640025O00388E40025O00B88340025O00E2A64003053O00466F63757303063O0045786973747303093O004973496E52616E6765026O004440025O00507540025O00E8AE4003103O004865616C746850657263656E74616765030C3O0095DC2140B4D7277FA8CB274903043O002CDDB94003073O004973526561647903093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O001440025O00EAB240025O0068974003113O004865616C696E675375726765466F637573025O00809440025O0056B34003183O0009E249537A0FE0774C6613E04D1F7B04E6441F750EE45D4C03053O00136187283F004D3O00120E012O00014O0067000100013O000E152O01000600013O00046F3O00060001002E82000200020001000300046F3O0002000100120E2O0100013O000E152O01000B0001000100046F3O000B0001002E39010500070001000400046F3O000700010012D4000200063O0006350102001900013O00046F3O001900010012D4000200063O0020020102000200072O00430102000200020006350102001900013O00046F3O001900010012D4000200063O00200201020002000800120E010400094O00500102000400020006A20002001A0001000100046F3O001A00012O00293O00013O0012D4000200063O0006A20002001F0001000100046F3O001F0001002E39010B004C0001000A00046F3O004C00010012D4000200063O00200201020002000C2O00430102000200022O00B900035O000651000200390001000300046F3O003900012O00B9000200013O0006350102003900013O00046F3O003900012O00B9000200024O00E4000300033O00122O0004000D3O00122O0005000E6O0003000500024O00020002000300202O00020002000F4O00020002000200062O0002003900013O00046F3O003900012O00B9000200043O00201E0002000200104O000400023O00202O0004000400114O000200040002000E2O0012003B0001000200046F3O003B0001002E820013004C0001001400046F3O004C00012O00B9000200054O00B9000300063O00201B0003000300152O00430102000200020006A2000200430001000100046F3O00430001002E390117004C0001001600046F3O004C00012O00B9000200033O0012E9000300183O00122O000400196O000200046O00025O00044O004C000100046F3O0007000100046F3O004C000100046F3O000200012O00293O00017O000B3O0003103O004865616C746850657263656E74616765025O00408A40025O00EC9240025O0093B140025O00C09840030C3O0086593237263FA96F2629283403063O0051CE3C535B4F03073O0049735265616479030C3O004865616C696E67537572676503163O0046AED17E26CD4A9B5DBEC2752A8345A14FA7907D20C003083O00C42ECBB0124FA32D00204O004E016O00206O00016O000200024O000100013O00064O00030001000100046F3O00080001002E47000200190001000300046F3O001F0001002E390105001F0001000400046F3O001F00012O00B93O00024O00E4000100033O00122O000200063O00122O000300076O0001000300028O000100206O00086O0002000200064O001F00013O00046F3O001F00012O00B93O00044O00B9000100023O00201B0001000100092O0043012O00020002000635012O001F00013O00046F3O001F00012O00B93O00033O00120E2O01000A3O00120E0102000B4O00023O00024O0007017O00293O00017O00473O00028O00025O00F8AC40025O007DB040026O00F03F025O00C0AC40025O00307E40027O0040025O00549640025O00F2A84003123O00D5B6514975D1FA80445779DEF0875F5179D203063O00BF9DD330251C03073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503123O004865616C696E6753747265616D546F74656D03203O00D71AF51033D118CB0F2ECD1AF51105CB10E019379F1BF11A3FD10CFD0A3F9F4C03053O005ABF7F947C030C3O0050822F1B718929246D95291203043O007718E74E03103O004865616C746850657263656E7461676503093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O001440030C3O004865616C696E67537572676503193O008A28A446D54E16BD3EB058DB45518628A34FD253189428E51E03073O0071E24DC52ABC20030B3O001213F5B92E1EE7A13518F103043O00D55A7694025O008AA440025O00707E40030B3O004865616C746873746F6E6503173O00532BB55A59533DA059435E6EB0534B5E20A75F5B5E6EE703053O002D3B4ED436025O0014B140025O00B2A64003193O0022538599833DA5F91E51C3A3832FA1F91E51C3BB893AA4FF1E03083O00907036E3EBE64ECD03173O00812D09EED548BB2101FBF85EB22406F2D76BBC3C06F3DE03063O003BD3486F9CB003173O0052656672657368696E674865616C696E67506F74696F6E03253O005C82E53F4B94EB244080A3254B86EF244080A33D4193EA2240C7E7284882ED3E4791E66D1A03043O004D2EE783025O00B89140025O00088040031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O009E46B341B743B74CB151A4539251B74CB35AB170B540BF4FB403043O0020DA34D6025O00D2AA40025O00ECA340025O00707940025O00349F4003253O004A0534A9FCA74456451223BBB1B8405B421E3FAFB1A04A4E47183FE8F5B5435F400438BEF403083O003A2E7751C891D025025O00BC9640025O0032A040025O0022AB40025O00E2B140030B3O0099316A0C25F7DCB02B780A03073O008FD8421E7E449B025O00AEA340030B3O0041737472616C536869667403183O00ABDB19D9C4AFE8F2A2C10BDF85A7D2E7AFC61EC2D3A697B003083O0081CAA86DABA5C3B703113O00035634DDCD00F4235410CDD710E72C5B3203073O0086423857B8BE74025O00F07C40025O0049B34003113O00416E6365737472616C47756964616E6365031E3O003D3F0ABE0AFF3334302O0EAE10EF203B3F3449BF1CED243B2F381FBE59B903083O00555C5169DB798B41025O002EAF40025O005CAD400036012O00120E012O00014O0067000100023O002E82000200090001000300046F3O0009000100261C012O00090001000100046F3O0009000100120E2O0100014O0067000200023O00120E012O00043O00261C012O00020001000400046F3O00020001000E412O01000B0001000100046F3O000B000100120E010200013O002665000200120001000400046F3O00120001002E82000500610001000600046F3O0061000100120E010300013O00261C010300170001000400046F3O0017000100120E010200073O00046F3O0061000100261C010300130001000100046F3O00130001002E820008003A0001000900046F3O003A00012O00B900046O00E4000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004003A00013O00046F3O003A00012O00B9000400023O0006350104003A00013O00046F3O003A00012O00B9000400033O00204C00040004000D4O000500046O000600056O00040006000200062O0004003A00013O00046F3O003A00012O00B9000400064O00B900055O00201B00050005000E2O00430104000200020006350104003A00013O00046F3O003A00012O00B9000400013O00120E0105000F3O00120E010600104O0002000400064O000701046O00B900046O00E4000500013O00122O000600113O00122O000700126O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005F00013O00046F3O005F00012O00B9000400073O0006350104005F00013O00046F3O005F00012O00B9000400083O0020020104000400132O00430104000200022O00B9000500093O0006510004005F0001000500046F3O005F00012O00B9000400083O0020E30004000400144O00065O00202O0006000600154O000400060002000E2O0016005F0001000400046F3O005F00012O00B9000400064O00B900055O00201B0005000500172O00430104000200020006350104005F00013O00046F3O005F00012O00B9000400013O00120E010500183O00120E010600194O0002000400064O000701045O00120E010300043O00046F3O00130001000E41010700D60001000200046F3O00D600012O00B90003000A4O00E4000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003008300013O00046F3O008300012O00B90003000B3O0006350103008300013O00046F3O008300012O00B9000300083O0020020103000300132O00430103000200022O00B90004000C3O000651000300830001000400046F3O00830001002E39011D00830001001C00046F3O008300012O00B9000300064O00B90004000D3O00201B00040004001E2O00430103000200020006350103008300013O00046F3O008300012O00B9000300013O00120E0104001F3O00120E010500204O0002000300054O000701036O00B90003000E3O000635010300352O013O00046F3O00352O012O00B9000300083O0020020103000300132O00430103000200022O00B90004000F3O000651000300352O01000400046F3O00352O0100120E010300014O0067000400043O00261C0103008E0001000100046F3O008E000100120E010400013O002665000400950001000100046F3O00950001002E39012100910001002200046F3O009100012O00B9000500104O0003010600013O00122O000700233O00122O000800246O00060008000200062O0005009D0001000600046F3O009D000100046F3O00B200012O00B90005000A4O00E4000600013O00122O000700253O00122O000800266O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500B200013O00046F3O00B200012O00B9000500064O00B90006000D3O00201B0006000600272O0043010500020002000635010500B200013O00046F3O00B200012O00B9000500013O00120E010600283O00120E010700294O0002000500074O000701055O002E39012B00B80001002A00046F3O00B800012O00B9000500103O002665000500B80001002C00046F3O00B8000100046F3O00352O012O00B90005000A4O000C000600013O00122O0007002D3O00122O0008002E6O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500C40001000100046F3O00C40001002E47002F00730001003000046F3O00352O01002E82003100352O01003200046F3O00352O012O00B9000500064O00B90006000D3O00201B0006000600272O0043010500020002000635010500352O013O00046F3O00352O012O00B9000500013O0012E9000600333O00122O000700346O000500076O00055O00044O00352O0100046F3O0091000100046F3O00352O0100046F3O008E000100046F3O00352O0100261C0102000E0001000100046F3O000E000100120E010300013O00261C010300DD0001000400046F3O00DD000100120E010200043O00046F3O000E0001002665000300E10001000100046F3O00E10001002E82003600D90001003500046F3O00D9000100120E010400013O002665000400E60001000100046F3O00E60001002E39013800282O01003700046F3O00282O012O00B900056O00E4000600013O00122O000700393O00122O0008003A6O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500062O013O00046F3O00062O012O00B9000500113O000635010500062O013O00046F3O00062O012O00B9000500083O0020020105000500132O00430105000200022O00B9000600123O000651000500062O01000600046F3O00062O01002E39013B00062O01000900046F3O00062O012O00B9000500064O00B900065O00201B00060006003C2O0043010500020002000635010500062O013O00046F3O00062O012O00B9000500013O00120E0106003D3O00120E0107003E4O0002000500074O000701056O00B900056O00E4000600013O00122O0007003F3O00122O000800406O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005001A2O013O00046F3O001A2O012O00B9000500133O0006350105001A2O013O00046F3O001A2O012O00B9000500033O0020D700050005000D4O000600146O000700156O00050007000200062O0005001C2O01000100046F3O001C2O01002E82004200272O01004100046F3O00272O012O00B9000500064O00B900065O00201B0006000600432O0043010500020002000635010500272O013O00046F3O00272O012O00B9000500013O00120E010600443O00120E010700454O0002000500074O000701055O00120E010400043O0026650004002C2O01000400046F3O002C2O01002E82004600E20001004700046F3O00E2000100120E010300043O00046F3O00D9000100046F3O00E2000100046F3O00D9000100046F3O000E000100046F3O00352O0100046F3O000B000100046F3O00352O0100046F3O000200012O00293O00017O00163O00028O00025O0023B140025O00F8A140026O00F03F025O00CDB040025O00C8A440025O00D89840025O000AA840025O000BB040025O0014904003133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00CC9C40025O0048AE40025O006BB240025O00189240025O00149F40025O00B4A840025O0007B04003103O0048616E646C65546F705472696E6B6574025O005EA940025O0030B140004C3O00120E012O00014O0067000100023O0026653O00060001000100046F3O00060001002E82000200090001000300046F3O0009000100120E2O0100014O0067000200023O00120E012O00043O0026653O000D0001000400046F3O000D0001002E47000500F7FF2O000600046F3O00020001002E820007000D0001000800046F3O000D000100261C2O01000D0001000100046F3O000D000100120E010200013O002665000200160001000400046F3O00160001002E82000900260001000A00046F3O002600012O00B9000300013O00202101030003000B4O000400026O000500033O00122O0006000C6O000700076O0003000700024O00038O00035O00062O000300230001000100046F3O00230001002E47000D002A0001000E00046F3O004B00012O00B900036O0047010300023O00046F3O004B0001002E82001000120001000F00046F3O0012000100261C010200120001000100046F3O0012000100120E010300013O002E47001100060001001100046F3O0031000100261C010300310001000400046F3O0031000100120E010200043O00046F3O00120001000E152O0100350001000300046F3O00350001002E47001200F8FF2O001300046F3O002B00012O00B9000400013O0020210104000400144O000500026O000600033O00122O0007000C6O000800086O0004000800024O00048O00045O00062O000400420001000100046F3O00420001002E47001500040001001600046F3O004400012O00B900046O0047010400023O00120E010300043O00046F3O002B000100046F3O0012000100046F3O004B000100046F3O000D000100046F3O004B000100046F3O000200012O00293O00017O003D3O00028O00025O0062AD40025O0072A540025O00208840025O0050B040026O00F03F025O009CA540025O0070844003093O008821A446F05E100DBF03083O0069CC4ECB2BA7377E030A3O0049734361737461626C6503093O00442O6F6D57696E6473030E3O0049735370652O6C496E52616E676503163O00A1A52C132C13CE5FA1B9630E2O01C45E2OA8220A535C03083O0031C5CA437E7364A703093O00044ED12D854457395C03073O003E573BBF49E03603073O0049735265616479025O00DBB240025O0084A24003093O0053756E646572696E6703093O004973496E52616E6765026O00144003163O00F417F4CDE210F3C7E042EADBE201F5C4E503EE89B65203043O00A987629A025O006CA340025O0046A640027O0040025O0020AF40025O00749940030B3O00F8632B46F020DCD97E2F5103073O00A8AB1744349D53025O0052A340025O005EAA40030B3O0053746F726D737472696B6503183O00E765FABF283E93E678FEA8653D95F172FAA0272C93B420A703073O00E7941195CD454D025O0016B340025O00CC9E40025O0044A440025O00589640030D3O001C853EA8AFA82432B83FB8ACB003073O00564BEC50CCC9DD03083O0042752O66446F776E03113O0057696E6466757279546F74656D42752O66030D3O0045487981F89E6058438AEA8E7F03063O00EB122117E59E03113O0054696D6553696E63654C61737443617374025O00805640030D3O0057696E6466757279546F74656D031A3O0047B3CFBF56AFD3A26FAECEAF55B781AB42BFC2B45DB8C0AF10EE03043O00DB30DAA1025O00CDB240025O00C1B140030B3O00C2746E48D77CF0ED63755D03073O008084111C29BB2F030B3O00466572616C53706972697403183O000737143B513E2116334F0826462A4F043109375F0026466C03053O003D6152665A025O0033B340025O001DB34000FC3O00120E012O00014O0067000100013O002E39010300020001000200046F3O00020001000E412O01000200013O00046F3O0002000100120E2O0100013O002E390104006F0001000500046F3O006F000100261C2O01006F0001000600046F3O006F000100120E010200013O00261C010200680001000100046F3O0068000100120E010300013O00261C010300630001000100046F3O00630001002E820008003A0001000700046F3O003A00012O00B900046O00E4000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004003A00013O00046F3O003A00012O00B9000400023O0006350104003A00013O00046F3O003A00012O00B9000400033O0006350104002600013O00046F3O002600012O00B9000400043O0006A2000400290001000100046F3O002900012O00B9000400033O0006A20004003A0001000100046F3O003A00012O00B9000400054O00B700055O00202O00050005000C4O000600063O00202O00060006000D4O00085O00202O00080008000C4O0006000800024O000600066O00040006000200062O0004003A00013O00046F3O003A00012O00B9000400013O00120E0105000E3O00120E0106000F4O0002000400064O000701046O00B900046O00E4000500013O00122O000600103O00122O000700116O0005000700024O00040004000500202O0004000400124O00040002000200062O0004005000013O00046F3O005000012O00B9000400073O0006350104005000013O00046F3O005000012O00B9000400083O0006350104004D00013O00046F3O004D00012O00B9000400093O0006A2000400520001000100046F3O005200012O00B9000400083O0006350104005200013O00046F3O00520001002E47001300120001001400046F3O006200012O00B9000400054O008C00055O00202O0005000500154O000600063O00202O00060006001600122O000800176O0006000800024O000600066O00040006000200062O0004006200013O00046F3O006200012O00B9000400013O00120E010500183O00120E010600194O0002000400064O000701045O00120E010300063O000E410106000F0001000300046F3O000F000100120E010200063O00046F3O0068000100046F3O000F00010026650002006C0001000600046F3O006C0001002E39011B000C0001001A00046F3O000C000100120E2O01001C3O00046F3O006F000100046F3O000C0001002665000100730001001C00046F3O00730001002E47001D00230001001E00046F3O009400012O00B900026O00E4000300013O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O0002000200124O00020002000200062O0002008000013O00046F3O008000012O00B90002000A3O0006A2000200820001000100046F3O00820001002E39012200FB0001002100046F3O00FB00012O00B9000200054O00B700035O00202O0003000300234O000400063O00202O00040004000D4O00065O00202O0006000600234O0004000600024O000400046O00020004000200062O000200FB00013O00046F3O00FB00012O00B9000200013O0012E9000300243O00122O000400256O000200046O00025O00044O00FB000100261C2O0100070001000100046F3O0007000100120E010200014O0067000300033O000E152O01009C0001000200046F3O009C0001002E47002600FEFF2O002700046F3O0098000100120E010300013O002665000300A10001000100046F3O00A10001002E82002800EF0001002900046F3O00EF00012O00B900046O00E4000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O0004000400124O00040002000200062O000400CB00013O00046F3O00CB00012O00B90004000B3O000635010400CB00013O00046F3O00CB00012O00B90004000C3O00200900040004002C4O00065O00202O00060006002D4O000700016O00040007000200062O000400C00001000100046F3O00C000012O00B900046O007F000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O0004000400304O000400020002000E2O003100CB0001000400046F3O00CB00012O00B9000400054O00B900055O00201B0005000500322O0043010400020002000635010400CB00013O00046F3O00CB00012O00B9000400013O00120E010500333O00120E010600344O0002000400064O000701045O002E39013600EE0001003500046F3O00EE00012O00B900046O00E4000500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400EE00013O00046F3O00EE00012O00B90004000D3O000635010400EE00013O00046F3O00EE00012O00B90004000E3O000635010400E000013O00046F3O00E000012O00B9000400043O0006A2000400E30001000100046F3O00E300012O00B90004000E3O0006A2000400EE0001000100046F3O00EE00012O00B9000400054O00B900055O00201B0005000500392O0043010400020002000635010400EE00013O00046F3O00EE00012O00B9000400013O00120E0105003A3O00120E0106003B4O0002000400064O000701045O00120E010300063O002665000300F30001000600046F3O00F30001002E39013C009D0001003D00046F3O009D000100120E2O0100063O00046F3O0007000100046F3O009D000100046F3O0007000100046F3O0098000100046F3O0007000100046F3O00FB000100046F3O000200012O00293O00017O004A012O00030E3O00B0B5CEF658ED84AEC6F760FE96A203063O009FE0C7A79B37030A3O0049734361737461626C65030A3O00446562752O66446F776E03103O00466C616D6553686F636B446562752O66030D3O00DBF22FDAFEFD3BF4FBF231D7E403043O00B297935C030B3O004973417661696C61626C65025O002FB040030E3O005072696D6F726469616C57617665030E3O0049735370652O6C496E52616E676503183O009CEF453F1D5E7E85FC400D054D6C89BD5F3B1C4B7689BD1D03073O001AEC9D2C52722C025O001C9340025O00ACAA40030A3O000C22D4562F1DDD54292503043O003B4A4EB503073O0049735265616479030D3O0009D04952BA2BD67C56B228D44903053O00D345B12O3A030A3O00466C616D6553686F636B03143O00B1E978F8ECF4A4ED76F6E28BA4EC77F2E5CEF7B703063O00ABD785199589030E3O002OC437F7EA3EE843EDEA3EFBFC2403083O002281A8529A8F509C03093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O00144003103O00A0BE36064D409D84BE001B415C8091A103073O00E9E5D2536B282E03063O0042752O665570030F3O00466572616C53706972697442752O66025O00207C40025O00AAA340030E3O00456C656D656E74616C426C61737403183O00C44E37DB00CF5633DA3AC34E33C51181513BD802CD47728503053O0065A12252B6025O0076A14003093O00DB1857FADEF08B20EF03083O004E886D399EBB82E203073O0048617354696572026O003E40027O004003093O0053756E646572696E6703093O004973496E52616E676503123O002D2AF7F53B2DF0FF397FEAF83038F5F47E6B03043O00915E5F99030D3O00D1C413DD5AB9F4C313F741BBE903063O00D79DAD74B52E03083O0042752O66446F776E03143O00437261636B6C696E675468756E64657242752O66030E3O00417363656E64616E636542752O66030F3O0016BC8AFBD4759882F5D221BA82FCDD03053O00BA55D4EB92030B3O0042752O6652656D61696E73030E3O00E18917F737C251C58902F030E05F03073O0038A2E1769E598E030F3O00432O6F6C646F776E52656D61696E732O033O00474344025O00F88C40030D3O004C696768746E696E67426F6C7403173O00500CC7A736D6550BC79020D7501180BC2BD65B09C5EF7703063O00B83C65A0CF42030B3O00029673AE3C9168AE38897903043O00DC51E21C030D3O00442O6F6D57696E647342752O6603143O0037D087EBE6DE21DA8D2OEFC336D987F6EFC907C603063O00A773B5E29B8A030A3O00D136E84E7673CAE331F303073O00A68242873C1B1103103O0053746F726D6272696E67657242752O66025O0032A040025O0015B040030B3O0053746F726D737472696B65025O008EA740025O003AB24003143O00575EC1673D575EDC7C3B410ADD7C3E4346CB356603053O0050242AAE15025O003C9040025O00AEB04003083O006211217B6211247203043O001A2E7057030B3O00486F7448616E6442752O66025O00405F40025O0042A04003083O004C6176614C61736803123O00B522BD7580B344A7B163B87DB1B849B1F97403083O00D4D943CB142ODF25030D3O008D84A6D6BC98BACB8E82BCD7B703043O00B2DAEDC803113O0057696E6466757279546F74656D42752O66025O00349D40025O0024B340030D3O0057696E6466757279546F74656D03173O00A1BCE8D4B0A0F4C989A1E9C4B3B8A6C3BFBBE1DCB3F5BE03043O00B0D6D586030E3O00D1A1B3D9AD584DF5A194D8A9454D03073O003994CDD6B4C836030E3O0037F13039731CE93438541EFC262003053O0016729D555403073O0043686172676573025O00C49B40025O00E0A94003183O00C1C716C958F8BCC5C72CC651F7BBD08B00CD53F1A4C18B4A03073O00C8A4AB73A43D96030D3O0092FD044D97B0FD0D42A1B1F81703053O00E3DE946325026O00204003123O005072696D6F726469616C5761766542752O6603163O0053706C696E7465726564456C656D656E747342752O66026O002840025O00489240025O00A49D40025O00C08B40025O0080874003183O003F5B55FEED3D5B5CF1C6315D5EE2B9205B5CF1F5361203A603053O0099532O3296030E3O002O7E72157D87445A7E67127AA54A03073O002D3D16137C13CB03103O00E41E08F8077EADC01E3EE50B62B0D50103073O00D9A1726D956210030E3O00436861696E4C696768746E696E6703193O0011283975B24B1E293F74A87A1B2E3F3CAF7D1C273479FC254303063O00147240581CDC030E3O00140DD7B9FDDEA9300DF0B8F9C3A903073O00DD5161B2D498B003103O00E8EB18F61FC3F31CF729DDEE0FF20EDE03053O007AAD877D9B025O0022A840025O006EAF40025O00F2B240025O0098964003193O0081CD05B43A3FDC85CD3FBB3330DB908113B03136C42O8151EB03073O00A8E4A160D95F5103093O00F7D0385D0D42C9C23A03063O0037BBB14E3C4F03113O0019C650F94FC29304C049E445CE9424C15103073O00E04DAE3F8B26AF025O0040A840025O00E88F4003093O004C617661427572737403143O0088404E2FBB434D3C9755183D8D4F5F228101097D03043O004EE42138025O00C09840025O004CB140030D3O00E277B50B91C077BC04A7C172A603053O00E5AE1ED26303123O0028F98745E43E2O18EE935CF831380FE4895F03073O00597B8DE6318D5D03183O00FF78F12O0444FA7FF1331245FF65B61F1944F47DF34C411E03063O002A9311966C70025O00B09440025O00209E40030E3O002CB42C6CEFC406A1256BE9E101A103063O00886FC64D1F8703093O002305B75EBCD318A50403083O00C96269C736DD8477028O00025O0015B240030E3O0043726173684C696768746E696E67030E3O004973496E4D656C2O6552616E676503193O00BA1E82322O0AA0B00B8B350C3CA2BE4C90280C32A0BC4CD27403073O00CCD96CE3416255025O00BEA640025O007AAE40030E3O006ED1FCE823D25ACAF4E91BC148C603063O00A03EA395854C03193O00C6B20422CCC4A4042ECFE9B70C39C696B30421C4DAA54D7E9503053O00A3B6C06D4F025O00B07740025O00349540030A3O00122A01CDF0072E0FC3FE03053O0095544660A003153O003E0A0CE03D391EE5370506AD2B0F03EA34034DBC6F03043O008D58666D03093O009A50CF430E2F5CCAB603083O00A1D333AA107A5D3503103O00DEA2B725FEA0A629F78FA13BFABBBE3C03043O00489BCED203113O00756D5D1C3F4F745323324376471A21497703053O0053261A346E025O00C49540025O00A0764003093O00496365537472696B6503143O00511422794B03354F531267555119204A5D57761E03043O002638774703083O00DFEE4ED70957E0E703063O0036938F38B645030D3O00FA80EC41D6D886D945DEDB84EC03053O00BFB6E19F29025O00D0964003133O0027133E54B48BC3381A68468289C527176804D203073O00A24B724835EBE703093O00A53F41D1471085374103063O0062EC5C248233030D3O00496365537472696B6542752O66025O0078AB40025O0040954003143O00AD1A098556BCA739AF1C4CA94CA6B23CA1595EEA03083O0050C4796CDA25C8D5030A3O0026610D6C5F3D820F700903073O00EA6013621F2B6E030D3O004861696C73746F726D42752O66025O00889D40025O00C05E40030A3O0046726F737453686F636B025O004C9A40025O0002A84003154O000D5DD4B84D980E1051CCEC618208185EC2EC20DA03073O00EB667F32A7CC1203083O007CA0E322682F43A903063O004E30C195432403133O003C1F96197E3C1F93100123178E1F4D355ED24A03053O0021507EE07803093O00C5AB06F748FEA108C103053O003C8CC863A4025O00089E40025O00DAA440025O00406040025O00A0A94003143O008EF70119B193E60D2DA7C7E70D28A58BF14474F103053O00C2E7946446030A3O007145CFA7E5DC5445CAA603063O00A8262CA1C396025O0042B340025O005DB040030A3O0057696E64737472696B6503143O0097F58C7223FCA41F8BF9C26539E6B11A85BCD02203083O0076E09CE2165088D6025O003C9240025O00449740030B3O0071FA56924FFD4D924BE55C03043O00E0228E39025O00B0AF40025O00F0844003153O00CDB3CACF7EE2491CD7ACC09D60F85309D2A2858F2603083O006EBEC7A5BD13913D025O00907440025O00E07C4003093O00E9FE79EC8ED5D3E57003063O00A7BA8B1788EB03133O0009A086091FA781031DF59B0414B284085AE7DE03043O006D7AD5E8030B3O00CCF6A53FE8C3B039EDFCB103043O00508E97C2025O00A6A940025O00F49040030B3O004261676F66547269636B7303173O0001C770730CC0485811CF7447108664450DC17B4943942003043O002C63A61703083O005AFE3B331DAB6AF603063O00C41C9749565303113O00C01420028E511671DE022C1C914C0A79FE03083O001693634970E2387803083O00446562752O66557003143O0097632OE78BB47AF5FC83BF58E3F081AB61F0FA8003053O00EDD8158295025O00B88740025O0018B040025O00406940025O00EEA74003083O00466972654E6F766103133O0084474D5A8FC751944F1F4CB9C7598E4B1F0DE803073O003EE22E2O3FD0A9030D3O00C910528B0B032650E23B5A8F0B03083O003E857935E37F6D4F03093O0038153BF9C5BAAD021903073O00C270745295B6CE025O000C9940025O00FCB140025O0040A440025O00E8984003183O0035A14B10D4EC0737AF731ACFEE1A79BB4516C7EE0B79FA1503073O006E59C82C78A082030A3O008DD1445557793342A8C803083O002DCBA32B26232A5B025O0026A140025O0084B340025O00108D40025O0050894003153O00D497D330939647DA8ADF28C7BA5DDC82D026C7FA0403073O0034B2E5BC43E7C9030E3O0002535117FF702A2649440AFE522403073O004341213064973C025O00BAB240025O0014A540025O00588140025O0038814003193O00DCF5AFCBFBE0EBA7DFFBCBE9A7D6F49FF4A7D6F4D3E2EE8BA203053O0093BF87CEB8025O00507040025O003AAE4003083O00A221B4C4F65CA48503073O00D2E448C6A1B833025O00E07440025O00D4A74003133O003040E1154CC0395FF25060C7384EFF15339D6403063O00AE5629937013030A3O007D0C8C06203C19A4580B03083O00CB3B60ED6B456F71025O008AAC40025O00C7B24003153O00221AADEC34CFC42C19AFEA71E3DE2A11A0E471A38403073O00B74476CC815190025O004CAA40025O004EAC40030E3O002DA571ED05AE07AA78F0058B00AA03063O00E26ECD10846B03103O00CECFE5D444E5D7E1D572FBCAF2D055F803053O00218BA380B9025O0010B240025O00049E4003193O00545005D7596708D72O5010D05E56039E44510AD95B5D448D2O03043O00BE373864030D3O007AA63B1607EDFA58A81E111FF703073O009336CF5C7E7383025O0050A040025O00789F4003183O00013832751970043F32420F710125756E04700A3D303D5E2B03063O001E6D51551D6D030D3O00C8785AB230CBEEE6455BA233D303073O009C9F1134D656BE030D3O0099E6B3B8A8FAAFA59AE0A9B9A303043O00DCCE8FDD03113O0054696D6553696E63654C61737443617374025O00805640025O00C2A940025O0052B24003183O0091742313DED9C09F423918CCC9DFC66E2419DFC0D7C62E7B03073O00B2E61D4D77B8AC00E6063O00899O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O003E00013O00046F3O003E00012O00B93O00023O000635012O003E00013O00046F3O003E00012O00B93O00033O000635012O001300013O00046F3O001300012O00B93O00043O0006A23O00160001000100046F3O001600012O00B93O00033O0006A23O003E0001000100046F3O003E00012O00B93O00054O00B9000100063O0006703O003E0001000100046F3O003E00012O00B93O00073O0020EE5O00044O00025O00202O0002000200056O0002000200064O003E00013O00046F3O003E00012O00B98O00E4000100013O00122O000200063O00122O000300076O0001000300028O000100206O00086O0002000200064O003E00013O00046F3O003E0001002E47000900130001000900046F3O003E00012O00B93O00084O00B700015O00202O00010001000A4O000200073O00202O00020002000B4O00045O00202O00040004000A4O0002000400024O000200028O0002000200064O003E00013O00046F3O003E00012O00B93O00013O00120E2O01000C3O00120E0102000D4O00023O00024O0007016O002E39010E006F0001000F00046F3O006F00012O00B98O00E4000100013O00122O000200103O00122O000300116O0001000300028O000100206O00126O0002000200064O006F00013O00046F3O006F00012O00B93O00093O000635012O006F00013O00046F3O006F00012O00B93O00073O0020EE5O00044O00025O00202O0002000200056O0002000200064O006F00013O00046F3O006F00012O00B98O00E4000100013O00122O000200133O00122O000300146O0001000300028O000100206O00086O0002000200064O006F00013O00046F3O006F00012O00B93O00084O00B700015O00202O0001000100154O000200073O00202O00020002000B4O00045O00202O0004000400154O0002000400024O000200028O0002000200064O006F00013O00046F3O006F00012O00B93O00013O00120E2O0100163O00120E010200174O00023O00024O0007017O00B98O00E4000100013O00122O000200183O00122O000300196O0001000300028O000100206O00126O0002000200064O00A700013O00046F3O00A700012O00B93O000A3O000635012O00A700013O00046F3O00A700012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O001C00A700013O00046F3O00A700012O00B98O00E4000100013O00122O0002001D3O00122O0003001E6O0001000300028O000100206O00086O0002000200064O00A700013O00046F3O00A700012O00B93O000B3O0020EE5O001F4O00025O00202O0002000200206O0002000200064O00A700013O00046F3O00A70001002E39012100A70001002200046F3O00A700012O00B93O00084O00B700015O00202O0001000100234O000200073O00202O00020002000B4O00045O00202O0004000400234O0002000400024O000200028O0002000200064O00A700013O00046F3O00A700012O00B93O00013O00120E2O0100243O00120E010200254O00023O00024O0007016O002E47002600330001002600046F3O00DA00012O00B98O00E4000100013O00122O000200273O00122O000300286O0001000300028O000100206O00126O0002000200064O00DA00013O00046F3O00DA00012O00B93O000C3O000635012O00DA00013O00046F3O00DA00012O00B93O000D3O000635012O00BC00013O00046F3O00BC00012O00B93O00043O0006A23O00BF0001000100046F3O00BF00012O00B93O000D3O0006A23O00DA0001000100046F3O00DA00012O00B93O00054O00B9000100063O0006703O00DA0001000100046F3O00DA00012O00B93O000B3O002062014O002900122O0002002A3O00122O0003002B8O0003000200064O00DA00013O00046F3O00DA00012O00B93O00084O008C00015O00202O00010001002C4O000200073O00202O00020002002D00122O0004001C6O0002000400024O000200028O0002000200064O00DA00013O00046F3O00DA00012O00B93O00013O00120E2O01002E3O00120E0102002F4O00023O00024O0007017O00B98O00E4000100013O00122O000200303O00122O000300316O0001000300028O000100206O00126O0002000200064O00382O013O00046F3O00382O012O00B93O000E3O000635012O00382O013O00046F3O00382O012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O001C00382O013O00046F3O00382O012O00B93O000B3O0020EE5O00324O00025O00202O0002000200336O0002000200064O00382O013O00046F3O00382O012O00B93O000B3O0020EE5O001F4O00025O00202O0002000200346O0002000200064O00382O013O00046F3O00382O012O00B93O000F4O00A1000100013O00122O000200353O00122O000300366O00010003000200064O00382O01000100046F3O00382O012O00B93O000B3O0020305O00374O00025O00202O0002000200346O000200024O000100106O00028O000300013O00122O000400383O00122O000500396O0003000500022O00F900020002000300202200020002003A4O0002000200024O0003000B3O00202O00030003003B4O000300046O00013O00024O000200116O00038O000400013O00122O000500383O00120E010600394O00350004000600024O00030003000400202O00030003003A4O0003000200024O0004000B3O00202O00040004003B4O000400056O00023O00024O00010001000200062O000100382O013O00046F3O00382O01002E82003C00382O01002200046F3O00382O012O00B93O00084O00B700015O00202O00010001003D4O000200073O00202O00020002000B4O00045O00202O00040004003D4O0002000400024O000200028O0002000200064O00382O013O00046F3O00382O012O00B93O00013O00120E2O01003E3O00120E0102003F4O00023O00024O0007017O00B98O00E4000100013O00122O000200403O00122O000300416O0001000300028O000100206O00126O0002000200064O00672O013O00046F3O00672O012O00B93O00123O000635012O00672O013O00046F3O00672O012O00B93O000B3O0020BC5O001F4O00025O00202O0002000200426O0002000200064O00692O01000100046F3O00692O012O00B98O000C000100013O00122O000200433O00122O000300446O0001000300028O000100206O00086O0002000200064O00692O01000100046F3O00692O012O00B98O00E4000100013O00122O000200453O00122O000300466O0001000300028O000100206O00086O0002000200064O00672O013O00046F3O00672O012O00B93O000B3O0020BC5O001F4O00025O00202O0002000200476O0002000200064O00692O01000100046F3O00692O01002E390149007C2O01004800046F3O007C2O012O00B93O00084O00D500015O00202O00010001004A4O000200073O00202O00020002000B4O00045O00202O00040004004A4O0002000400024O000200028O0002000200064O00772O01000100046F3O00772O01002E39014C007C2O01004B00046F3O007C2O012O00B93O00013O00120E2O01004D3O00120E0102004E4O00023O00024O0007016O002E39014F00A52O01005000046F3O00A52O012O00B98O00E4000100013O00122O000200513O00122O000300526O0001000300028O000100206O00126O0002000200064O00A52O013O00046F3O00A52O012O00B93O00133O000635012O00A52O013O00046F3O00A52O012O00B93O000B3O0020EE5O001F4O00025O00202O0002000200536O0002000200064O00A52O013O00046F3O00A52O01002E39015400A52O01005500046F3O00A52O012O00B93O00084O00B700015O00202O0001000100564O000200073O00202O00020002000B4O00045O00202O0004000400564O0002000400024O000200028O0002000200064O00A52O013O00046F3O00A52O012O00B93O00013O00120E2O0100573O00120E010200584O00023O00024O0007017O00B98O00E4000100013O00122O000200593O00122O0003005A6O0001000300028O000100206O00126O0002000200064O00BA2O013O00046F3O00BA2O012O00B93O00143O000635012O00BA2O013O00046F3O00BA2O012O00B93O000B3O0020095O00324O00025O00202O00020002005B4O000300018O0003000200064O00BC2O01000100046F3O00BC2O01002E47005C000D0001005D00046F3O00C72O012O00B93O00084O00B900015O00201B00010001005E2O0043012O00020002000635012O00C72O013O00046F3O00C72O012O00B93O00013O00120E2O01005F3O00120E010200604O00023O00024O0007017O00B98O00E4000100013O00122O000200613O00122O000300626O0001000300028O000100206O00126O0002000200064O00F92O013O00046F3O00F92O012O00B93O000A3O000635012O00F92O013O00046F3O00F92O012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O001C00F92O013O00046F3O00F92O012O00B98O004A2O0100013O00122O000200633O00122O000300646O0001000300028O000100206O00656O000200024O000100153O00064O00F92O01000100046F3O00F92O012O00B93O00084O00D500015O00202O0001000100234O000200073O00202O00020002000B4O00045O00202O0004000400234O0002000400024O000200028O0002000200064O00F42O01000100046F3O00F42O01002E82006700F92O01006600046F3O00F92O012O00B93O00013O00120E2O0100683O00120E010200694O00023O00024O0007017O00B98O00E4000100013O00122O0002006A3O00122O0003006B6O0001000300028O000100206O00126O0002000200064O001E02013O00046F3O001E02012O00B93O000E3O000635012O001E02013O00046F3O001E02012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O006C001E02013O00046F3O001E02012O00B93O000B3O0020EE5O001F4O00025O00202O00020002006D6O0002000200064O001E02013O00046F3O001E02012O00B93O000B3O0020BC5O00324O00025O00202O00020002006E6O0002000200064O00200201000100046F3O002002012O00B93O00063O002669012O00200201006F00046F3O00200201002E39017100330201007000046F3O00330201002E82007300330201007200046F3O003302012O00B93O00084O00B700015O00202O00010001003D4O000200073O00202O00020002000B4O00045O00202O00040004003D4O0002000400024O000200028O0002000200064O003302013O00046F3O003302012O00B93O00013O00120E2O0100743O00120E010200754O00023O00024O0007017O00B98O00E4000100013O00122O000200763O00122O000300776O0001000300028O000100206O00126O0002000200064O006902013O00046F3O006902012O00B93O00163O000635012O006902013O00046F3O006902012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O006C006902013O00046F3O006902012O00B93O000B3O0020EE5O001F4O00025O00202O0002000200336O0002000200064O006902013O00046F3O006902012O00B98O00E4000100013O00122O000200783O00122O000300796O0001000300028O000100206O00086O0002000200064O006902013O00046F3O006902012O00B93O00084O00B700015O00202O00010001007A4O000200073O00202O00020002000B4O00045O00202O00040004007A4O0002000400024O000200028O0002000200064O006902013O00046F3O006902012O00B93O00013O00120E2O01007B3O00120E0102007C4O00023O00024O0007017O00B98O00E4000100013O00122O0002007D3O00122O0003007E6O0001000300028O000100206O00126O0002000200064O008E02013O00046F3O008E02012O00B93O000A3O000635012O008E02013O00046F3O008E02012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O006C008E02013O00046F3O008E02012O00B93O000B3O0020BC5O001F4O00025O00202O0002000200206O0002000200064O00900201000100046F3O009002012O00B98O00E4000100013O00122O0002007F3O00122O000300806O0001000300028O000100206O00086O0002000200064O009002013O00046F3O00900201002E39018200A30201008100046F3O00A302012O00B93O00084O00D500015O00202O0001000100234O000200073O00202O00020002000B4O00045O00202O0004000400234O0002000400024O000200028O0002000200064O009E0201000100046F3O009E0201002E47008300070001008400046F3O00A302012O00B93O00013O00120E2O0100853O00120E010200864O00023O00024O0007017O00B98O00E4000100013O00122O000200873O00122O000300886O0001000300028O000100206O00126O0002000200064O00C102013O00046F3O00C102012O00B93O00173O000635012O00C102013O00046F3O00C102012O00B98O000C000100013O00122O000200893O00122O0003008A6O0001000300028O000100206O00086O0002000200064O00C10201000100046F3O00C102012O00B93O000B3O00201E5O001A4O00025O00202O00020002001B6O00020002000E2O001C00C302013O00046F3O00C30201002E47008B00130001008C00046F3O00D402012O00B93O00084O00B700015O00202O00010001008D4O000200073O00202O00020002000B4O00045O00202O00040004008D4O0002000400024O000200028O0002000200064O00D402013O00046F3O00D402012O00B93O00013O00120E2O01008E3O00120E0102008F4O00023O00024O0007016O002E39019000130301009100046F3O001303012O00B98O00E4000100013O00122O000200923O00122O000300936O0001000300028O000100206O00126O0002000200064O001303013O00046F3O001303012O00B93O000E3O000635012O001303013O00046F3O001303012O00B93O000B3O00201E5O001A4O00025O00202O00020002001B6O00020002000E2O006C00FB02013O00046F3O00FB02012O00B98O00E4000100013O00122O000200943O00122O000300956O0001000300028O000100206O00086O0002000200064O001303013O00046F3O001303012O00B93O000B3O0020E35O001A4O00025O00202O00020002001B6O00020002000E2O001C001303013O00046F3O001303012O00B93O000B3O0020EE5O00324O00025O00202O00020002006D6O0002000200064O001303013O00046F3O001303012O00B93O00084O00B700015O00202O00010001003D4O000200073O00202O00020002000B4O00045O00202O00040004003D4O0002000400024O000200028O0002000200064O001303013O00046F3O001303012O00B93O00013O00120E2O0100963O00120E010200974O00023O00024O0007016O002E39019800490301009900046F3O004903012O00B98O00E4000100013O00122O0002009A3O00122O0003009B6O0001000300028O000100206O00126O0002000200064O004903013O00046F3O004903012O00B93O00183O000635012O004903013O00046F3O004903012O00B98O00E4000100013O00122O0002009C3O00122O0003009D6O0001000300028O000100206O00086O0002000200064O004903013O00046F3O004903012O00B93O000B3O0020EE5O001F4O00025O00202O0002000200206O0002000200064O004903013O00046F3O004903012O00B93O00194O00773O0001000200261C012O00490301009E00046F3O00490301002E47009F00120001009F00046F3O004903012O00B93O00084O008C00015O00202O0001000100A04O000200073O00202O0002000200A100122O0004001C6O0002000400024O000200028O0002000200064O004903013O00046F3O004903012O00B93O00013O00120E2O0100A23O00120E010200A34O00023O00024O0007016O002E3901A40076030100A500046F3O007603012O00B98O00E4000100013O00122O000200A63O00122O000300A76O0001000300028O000100206O00036O0002000200064O007603013O00046F3O007603012O00B93O00023O000635012O007603013O00046F3O007603012O00B93O00033O000635012O005E03013O00046F3O005E03012O00B93O00043O0006A23O00610301000100046F3O006103012O00B93O00033O0006A23O00760301000100046F3O007603012O00B93O00054O00B9000100063O0006703O00760301000100046F3O007603012O00B93O00084O00B700015O00202O00010001000A4O000200073O00202O00020002000B4O00045O00202O00040004000A4O0002000400024O000200028O0002000200064O007603013O00046F3O007603012O00B93O00013O00120E2O0100A83O00120E010200A94O00023O00024O0007016O002E3901AA009D030100AB00046F3O009D03012O00B98O00E4000100013O00122O000200AC3O00122O000300AD6O0001000300028O000100206O00126O0002000200064O009D03013O00046F3O009D03012O00B93O00093O000635012O009D03013O00046F3O009D03012O00B93O00073O0020EE5O00044O00025O00202O0002000200056O0002000200064O009D03013O00046F3O009D03012O00B93O00084O00B700015O00202O0001000100154O000200073O00202O00020002000B4O00045O00202O0004000400154O0002000400024O000200028O0002000200064O009D03013O00046F3O009D03012O00B93O00013O00120E2O0100AE3O00120E010200AF4O00023O00024O0007017O00B98O00E4000100013O00122O000200B03O00122O000300B16O0001000300028O000100206O00126O0002000200064O00BE03013O00046F3O00BE03012O00B93O001A3O000635012O00BE03013O00046F3O00BE03012O00B98O00E4000100013O00122O000200B23O00122O000300B36O0001000300028O000100206O00086O0002000200064O00BE03013O00046F3O00BE03012O00B98O000C000100013O00122O000200B43O00122O000300B56O0001000300028O000100206O00086O0002000200064O00C00301000100046F3O00C00301002E8200B600D0030100B700046F3O00D003012O00B93O00084O008C00015O00202O0001000100B84O000200073O00202O0002000200A100122O0004001C6O0002000400024O000200028O0002000200064O00D003013O00046F3O00D003012O00B93O00013O00120E2O0100B93O00120E010200BA4O00023O00024O0007017O00B98O00E4000100013O00122O000200BB3O00122O000300BC6O0001000300028O000100206O00126O0002000200064O00FA03013O00046F3O00FA03012O00B93O00133O000635012O00FA03013O00046F3O00FA03012O00B98O00E4000100013O00122O000200BD3O00122O000300BE6O0001000300028O000100206O00086O0002000200064O00FA03013O00046F3O00FA0301002E4700BF0013000100BF00046F3O00FA03012O00B93O00084O00B700015O00202O0001000100564O000200073O00202O00020002000B4O00045O00202O0004000400564O0002000400024O000200028O0002000200064O00FA03013O00046F3O00FA03012O00B93O00013O00120E2O0100C03O00120E010200C14O00023O00024O0007017O00B98O00E4000100013O00122O000200C23O00122O000300C36O0001000300028O000100206O00126O0002000200064O000E04013O00046F3O000E04012O00B93O001A3O000635012O000E04013O00046F3O000E04012O00B93O000B3O0020BC5O00324O00025O00202O0002000200C46O0002000200064O00100401000100046F3O00100401002E8200C50020040100C600046F3O002004012O00B93O00084O008C00015O00202O0001000100B84O000200073O00202O0002000200A100122O0004001C6O0002000400024O000200028O0002000200064O002004013O00046F3O002004012O00B93O00013O00120E2O0100C73O00120E010200C84O00023O00024O0007017O00B98O00E4000100013O00122O000200C93O00122O000300CA6O0001000300028O000100206O00126O0002000200064O003404013O00046F3O003404012O00B93O001B3O000635012O003404013O00046F3O003404012O00B93O000B3O0020BC5O001F4O00025O00202O0002000200CB6O0002000200064O00360401000100046F3O00360401002E8200CC0049040100CD00046F3O004904012O00B93O00084O00D500015O00202O0001000100CE4O000200073O00202O00020002000B4O00045O00202O0004000400CE4O0002000400024O000200028O0002000200064O00440401000100046F3O00440401002E8200D00049040100CF00046F3O004904012O00B93O00013O00120E2O0100D13O00120E010200D24O00023O00024O0007017O00B98O00E4000100013O00122O000200D33O00122O000300D46O0001000300028O000100206O00126O0002000200064O006704013O00046F3O006704012O00B93O00133O000635012O006704013O00046F3O006704012O00B93O00084O00B700015O00202O0001000100564O000200073O00202O00020002000B4O00045O00202O0004000400564O0002000400024O000200028O0002000200064O006704013O00046F3O006704012O00B93O00013O00120E2O0100D53O00120E010200D64O00023O00024O0007017O00B98O00E4000100013O00122O000200D73O00122O000300D86O0001000300028O000100206O00126O0002000200064O007404013O00046F3O007404012O00B93O001A3O0006A23O00760401000100046F3O00760401002E8200DA0088040100D900046F3O008804012O00B93O00084O005800015O00202O0001000100B84O000200073O00202O0002000200A100122O0004001C6O0002000400024O000200028O0002000200064O00830401000100046F3O00830401002E4700DB0007000100DC00046F3O008804012O00B93O00013O00120E2O0100DD3O00120E010200DE4O00023O00024O0007017O00B98O00E4000100013O00122O000200DF3O00122O000300E06O0001000300028O000100206O00036O0002000200064O009504013O00046F3O009504012O00B93O001C3O0006A23O00970401000100046F3O00970401002E8200E100A8040100E200046F3O00A804012O00B93O00084O00B700015O00202O0001000100E34O000200073O00202O00020002000B4O00045O00202O0004000400E34O0002000400024O000200028O0002000200064O00A804013O00046F3O00A804012O00B93O00013O00120E2O0100E43O00120E010200E54O00023O00024O0007016O002E3901E600CA040100E700046F3O00CA04012O00B98O00E4000100013O00122O000200E83O00122O000300E96O0001000300028O000100206O00126O0002000200064O00CA04013O00046F3O00CA04012O00B93O00123O000635012O00CA04013O00046F3O00CA0401002E8200EB00CA040100EA00046F3O00CA04012O00B93O00084O00B700015O00202O00010001004A4O000200073O00202O00020002000B4O00045O00202O00040004004A4O0002000400024O000200028O0002000200064O00CA04013O00046F3O00CA04012O00B93O00013O00120E2O0100EC3O00120E010200ED4O00023O00024O0007016O002E3901EE00F6040100EF00046F3O00F604012O00B98O00E4000100013O00122O000200F03O00122O000300F16O0001000300028O000100206O00126O0002000200064O00F604013O00046F3O00F604012O00B93O000C3O000635012O00F604013O00046F3O00F604012O00B93O000D3O000635012O00DF04013O00046F3O00DF04012O00B93O00043O0006A23O00E20401000100046F3O00E204012O00B93O000D3O0006A23O00F60401000100046F3O00F604012O00B93O00054O00B9000100063O0006703O00F60401000100046F3O00F604012O00B93O00084O008C00015O00202O00010001002C4O000200073O00202O00020002002D00122O0004001C6O0002000400024O000200028O0002000200064O00F604013O00046F3O00F604012O00B93O00013O00120E2O0100F23O00120E010200F34O00023O00024O0007017O00B98O00E4000100013O00122O000200F43O00122O000300F56O0001000300028O000100206O00126O0002000200064O001905013O00046F3O001905012O00B93O001D3O000635012O001905013O00046F3O001905012O00B93O001E3O000635012O000905013O00046F3O000905012O00B93O001F3O0006A23O000C0501000100046F3O000C05012O00B93O001E3O0006A23O00190501000100046F3O00190501002E3901F70019050100F600046F3O001905012O00B93O00084O00B900015O00201B0001000100F82O0043012O00020002000635012O001905013O00046F3O001905012O00B93O00013O00120E2O0100F93O00120E010200FA4O00023O00024O0007017O00B98O00E4000100013O00122O000200FB3O00122O000300FC6O0001000300028O000100206O00126O0002000200064O005D05013O00046F3O005D05012O00B93O00203O000635012O005D05013O00046F3O005D05012O00B98O00E4000100013O00122O000200FD3O00122O000300FE6O0001000300028O000100206O00086O0002000200064O005D05013O00046F3O005D05012O00B93O00073O0020EE5O00FF4O00025O00202O0002000200056O0002000200064O005D05013O00046F3O005D05012O00B93O000B3O00201F5O001A4O00025O00202O00020002001B6O000200024O000100103O00122O0002001C6O000300216O00048O000500013O00122O00062O00012O00120E0107002O013O008B0005000700024O00040004000500202O0004000400084O000400056O00033O000200122O0004001C6O0003000400034O0001000300024O000200113O00122O0003001C4O00B9000400214O005901058O000600013O00122O00072O00012O00122O0008002O015O0006000800024O00050005000600202O0005000500084O000500066O00043O000200122O0005001C4O00D60004000500042O00500102000400022O00CB0001000100020006A63O00610501000100046F3O0061050100120E012O0002012O00120E2O010003012O0006700001007105013O00046F3O0071050100120E012O0004012O00120E2O010005012O0006703O00710501000100046F3O007105012O00B93O00084O00572O015O00122O00020006015O0001000100026O0002000200064O007105013O00046F3O007105012O00B93O00013O00120E2O010007012O00120E01020008013O00023O00024O0007017O00B98O00E4000100013O00122O00020009012O00122O0003000A015O0001000300028O000100206O00126O0002000200064O009705013O00046F3O009705012O00B93O000E3O000635012O009705013O00046F3O009705012O00B98O00E4000100013O00122O0002000B012O00122O0003000C015O0001000300028O000100206O00086O0002000200064O009705013O00046F3O009705012O00B93O000B3O0020755O001A4O00025O00202O00020002001B6O0002000200122O0001001C3O00062O0001009705013O00046F3O009705012O00B93O000B3O0020BC5O00324O00025O00202O00020002006D6O0002000200064O009B0501000100046F3O009B050100120E012O000D012O00120E2O01000E012O000670000100B005013O00046F3O00B005012O00B93O00084O00D500015O00202O00010001003D4O000200073O00202O00020002000B4O00045O00202O00040004003D4O0002000400024O000200028O0002000200064O00AB0501000100046F3O00AB050100120E012O000F012O00120E2O010010012O0006513O00B00501000100046F3O00B005012O00B93O00013O00120E2O010011012O00120E01020012013O00023O00024O0007017O00B98O00E4000100013O00122O00020013012O00122O00030014015O0001000300028O000100206O00126O0002000200064O00BD05013O00046F3O00BD05012O00B93O001B3O0006A23O00C10501000100046F3O00C1050100120E012O0015012O00120E2O010016012O000651000100D605013O00046F3O00D605012O00B93O00084O00D500015O00202O0001000100CE4O000200073O00202O00020002000B4O00045O00202O0004000400CE4O0002000400024O000200028O0002000200064O00D10501000100046F3O00D1050100120E012O0017012O00120E2O010018012O0006513O00D60501000100046F3O00D605012O00B93O00013O00120E2O010019012O00120E0102001A013O00023O00024O0007017O00B98O00E4000100013O00122O0002001B012O00122O0003001C015O0001000300028O000100206O00126O0002000200064O00E305013O00046F3O00E305012O00B93O00183O0006A23O00E70501000100046F3O00E7050100120E012O001D012O00120E2O01001E012O0006703O00FB0501000100046F3O00FB05012O00B93O00084O005800015O00202O0001000100A04O000200073O00202O0002000200A100122O0004001C6O0002000400024O000200028O0002000200064O00F60501000100046F3O00F6050100120E012O001F012O00120E2O010020012O0006513O00FB0501000100046F3O00FB05012O00B93O00013O00120E2O010021012O00120E01020022013O00023O00024O0007016O00120E012O0023012O00120E2O010024012O0006703O00230601000100046F3O002306012O00B98O00E4000100013O00122O00020025012O00122O00030026015O0001000300028O000100206O00126O0002000200064O002306013O00046F3O002306012O00B93O00203O000635012O002306013O00046F3O002306012O00B93O00073O0020EE5O00FF4O00025O00202O0002000200056O0002000200064O002306013O00046F3O002306012O00B93O00084O00702O015O00122O00020006015O0001000100026O0002000200064O001E0601000100046F3O001E060100120E012O0027012O00120E2O010028012O0006700001002306013O00046F3O002306012O00B93O00013O00120E2O010029012O00120E0102002A013O00023O00024O0007017O00B98O00E4000100013O00122O0002002B012O00122O0003002C015O0001000300028O000100206O00126O0002000200064O004506013O00046F3O004506012O00B93O00093O000635012O004506013O00046F3O0045060100120E012O002D012O00120E2O01002E012O0006513O00450601000100046F3O004506012O00B93O00084O00B700015O00202O0001000100154O000200073O00202O00020002000B4O00045O00202O0004000400154O0002000400024O000200028O0002000200064O004506013O00046F3O004506012O00B93O00013O00120E2O01002F012O00120E01020030013O00023O00024O0007016O00120E012O0031012O00120E2O010032012O0006513O00840601000100046F3O008406012O00B98O00E4000100013O00122O00020033012O00122O00030034015O0001000300028O000100206O00126O0002000200064O008406013O00046F3O008406012O00B93O00163O000635012O008406013O00046F3O008406012O00B93O000B3O0020755O001A4O00025O00202O00020002001B6O0002000200122O0001001C3O00062O0001008406013O00046F3O008406012O00B93O000B3O0020EE5O001F4O00025O00202O0002000200336O0002000200064O008406013O00046F3O008406012O00B98O00E4000100013O00122O00020035012O00122O00030036015O0001000300028O000100206O00086O0002000200064O008406013O00046F3O008406012O00B93O00084O00D500015O00202O00010001007A4O000200073O00202O00020002000B4O00045O00202O00040004007A4O0002000400024O000200028O0002000200064O007F0601000100046F3O007F060100120E012O0037012O00120E2O010038012O0006AD3O00840601000100046F3O008406012O00B93O00013O00120E2O010039012O00120E0102003A013O00023O00024O0007017O00B98O00E4000100013O00122O0002003B012O00122O0003003C015O0001000300028O000100206O00126O0002000200064O00A006013O00046F3O00A006012O00B93O000E3O000635012O00A006013O00046F3O00A006012O00B93O000B3O0020755O001A4O00025O00202O00020002001B6O0002000200122O0001001C3O00062O000100A006013O00046F3O00A006012O00B93O000B3O0020BC5O00324O00025O00202O00020002006D6O0002000200064O00A40601000100046F3O00A4060100120E012O003D012O00120E2O01003E012O0006703O00B50601000100046F3O00B506012O00B93O00084O00B700015O00202O00010001003D4O000200073O00202O00020002000B4O00045O00202O00040004003D4O0002000400024O000200028O0002000200064O00B506013O00046F3O00B506012O00B93O00013O00120E2O01003F012O00120E01020040013O00023O00024O0007017O00B98O00E4000100013O00122O00020041012O00122O00030042015O0001000300028O000100206O00126O0002000200064O00E506013O00046F3O00E506012O00B93O00143O000635012O00E506013O00046F3O00E506012O00B93O000B3O0020095O00324O00025O00202O00020002005B4O000300018O0003000200064O00D60601000100046F3O00D606012O00B98O00552O0100013O00122O00020043012O00122O00030044015O0001000300028O000100122O00020045019O00026O0002000200122O00010046012O00062O000100E506013O00046F3O00E506012O00B93O00084O00B900015O00201B00010001005E2O0043012O000200020006A23O00E00601000100046F3O00E0060100120E012O0047012O00120E2O010048012O000670000100E506013O00046F3O00E506012O00B93O00013O00120E2O010049012O00120E0102004A013O00023O00024O0007017O00293O00017O0064012O00028O00025O00807840025O00B8A940026O001040030A3O00DC40E3F172C944EDFF7C03053O00179A2C829C03073O004973526561647903113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O6603083O0037AFBFAB181C07A703063O007371C6CDCE56030B3O004973417661696C61626C65030E3O00B445F7578B45FA53855BC95B925203043O003AE4379E03103O009285D123399E3DBB8ADB0A39AF20B28F03073O0055D4E9B04E5CCD030F3O0041757261416374697665436F756E7403103O006C5489EF4F6B80ED4953ACE7484D8EE403043O00822A38E8026O001840025O00C05D40025O00B3B14003093O00436173744379636C65030A3O00466C616D6553686F636B030E3O0049735370652O6C496E52616E6765025O0056A340025O002EAE4003123O00ECB925EE4500F9BD2BE04B7FEBBA21A3116803063O005F8AD5448320025O001AA140025O00F49A4003083O000C21B34658253EA003053O00164A48C12303103O000A75E555294AEC572F72C05D2E6CE25E03043O00384C1984026O000840025O00D49A40025O009AAA4003083O00466972654E6F766103103O0058C8B923F050CEBD278F5FCEAE669E0603053O00AF3EA1CB46030B3O000FC9CC01382FC9D11A3E3903053O00555CBDA37303063O0042752O66557003123O0043726173684C696768746E696E6742752O6603143O000DA9352825B5023726B8353C0CA02O352CA2242B03043O005849CC5003093O0042752O66537461636B03143O00436F6E76657267696E6753746F726D7342752O66030B3O0053746F726D737472696B65025O00805D40025O00609D4003123O003D971F5424C93A91194D2C9A2F8C1506788303063O00BA4EE3702649025O0040A940025O00089140030E3O00DF45FC465B56F550F5415D73F25003063O001A9C379D3533030E3O00AFCA17CAB05982DF25CDB74281CB03063O0030ECB876B9D803143O00434C43726173684C696768746E696E6742752O66030E3O0043726173684C696768746E696E67030E3O004973496E4D656C2O6552616E6765026O00144003163O00E6AF5623C70BE9B45038DB3AECB35070CE3BE0FD056003063O005485DD3750AF025O0032A940025O00D09C40027O004003093O0086C8C4FDBBD9C8C5AA03043O00AECFABA103093O00C5FF04FFEBC3E2EC0003063O00B78D9E6D9398025O0044A540025O00A5B24003093O00496365537472696B6503113O00250AE3333F1DF405270CA60D230CA65D7F03043O006C4C6986030A3O00CDD7BEF2DAD8CDBEE2C503053O00AE8BA5D18103093O008BB2EBCDD5177F6AAE03083O0018C3D382A1A66310030D3O004861696C73746F726D42752O66025O005C9B40025O00F07740030A3O0046726F737453686F636B03123O004011E63F4729550BE62F5856470CEC6C024203063O00762663894C33026O00F03F03093O00CE330B160C32F4280203063O00409D4665726903093O0053756E646572696E6703093O004973496E52616E676503103O0053BDA9E71552A1A9E45041A7A2A3411503053O007020C8C783025O00C09340025O0083B040030A3O000A5C5DB5C6982A23535703073O00424C303CD8A3CB030D3O00978975E75AC005A99578E653DA03073O0044DAE619933FAE030A3O00446562752O66446F776E03123O00AB265241B392395B43B5A66A5243B3ED7B0503053O00D6CD4A332C025O00208E40030E3O00D6AC0B087FD4FCB9020F79F1FBB903063O009895DE6A7B17030E3O00FE34F750BDD428F170A1D234FB5003053O00D5BD469623030B3O007A5B661D434C430141516703043O00682F3514026O002440026O002E40025O00F5B140025O004CA540025O00D4B040025O000FB24003153O00A05E800FB430AF458614A801AA42865CBD00A60CD003063O006FC32CE17CDC025O0092A140025O00108140030D3O00F44F077BBFA5D1480751A4A7CC03063O00CBB8266013CB030B3O00446562752O66537461636B03123O005072696D6F726469616C5761766542752O6603133O004D61656C7374726F6D576561706F6E42752O6603143O0016657C53C8357C6E48C03E5E7844C22A676B4EC303053O00AE5913192103083O0042752O66446F776E03163O0053706C696E7465726564456C656D656E747342752O66026O0028402O033O00474344030D3O004C696768746E696E67426F6C7403143O00231B5546E3890221156D4CF88B1F6F135D4BB7D503073O006B4F72322E97E703083O0015A7A328A638A4C803083O00A059C6D549EA59D7030D3O00657EB8EAC04650A7EDC45D7DA003053O00A52811D49E030E3O00D5CB013E29F7DD01322AD2D81E3603053O004685B9685303083O00224C562FE70B534503053O00A96425244A03083O00446562752O66557003103O00268BA35D05B4AA5F038C86550292A45603043O003060E7C203103O00EE560F201CEBA78CCB512A281BCDA98503083O00E3A83A6E4D79B8CF025O0020A540025O0072AC4003083O004C6176614C617368030F3O00773DA9418ED770B6737CBE4FB49B2203083O00C51B5CDF20D1BB11030E3O00334DCAF60C4DC7F20253F4FA155A03043O009B633FA3030A3O0049734361737461626C65025O00B5B040025O00D09540030E3O005072696D6F726469616C5761766503153O0092C3A880B69686D8A081869383C7A4CDB88B8791F503063O00E4E2B1C1EDD9025O0054B040025O00E07640030E3O0051FAC5B0036F7075E0D0AD024D7E03073O00191288A4C36B23025O00A06240025O0086B140025O00308440025O0034904003163O00EB3FA85C7A83CDB1EF25BD417BB2C6F8E922AC0F20E903083O00D8884DC92F12DCA103083O000BE539DF26D3942C03073O00E24D8C4BBA68BC03103O009FC2D1324A8AC6DF3C449DCBD22A49BF03053O002FD9AEB05F025O001CAC40025O0034AD4003103O00BED464078D5A7730B99D770DB7142A7003083O0046D8BD1662D23418030E3O00FFD3A68AD6D4CBA28BF1D6DEB09303053O00B3BABFC3E703103O00DC331DE9FC310CE5F50C08EDEB360CF703043O0084995F7803103O0094BE0B20F2D4B4B0BE2O3DFEC8A9A5A103073O00C0D1D26E4D97BA030E3O00C50F27E4FACAF4022ECBF3C5F31703063O00A4806342899F03073O0043686172676573030F3O00466572616C53706972697442752O66030E3O00456C656D656E74616C426C617374025O00B88940025O00988C4003163O000585ECB30587FDBF0CB6EBB2019AFDFE0186ECFE52DE03043O00DE60E989030E3O009ABBA61686DFF9BEBBB31181FDF703073O0090D9D3C77FE893025O0062B340025O000DB140030E3O00436861696E4C696768746E696E6703163O00FB273F21DB7A0E4DFF272A26DC4B0504F9203B68871D03083O0024984F5E48B52562026O001C40025O00188440025O00449740025O00B07D40025O004FB040025O00C4A540025O00405E40025O00A09D40025O00FEA540030A3O008AEE2AA2D448AFEE2FA303063O003CDD8744C6A7030A3O0057696E64737472696B6503113O00F9B4F68751CDFCB4F38602D8E12OB8D11303063O00B98EDD98E322030B3O006BD158E84E20E34ACC5CFF03073O009738A5379A2353025O0014A040025O0058A24003123O00B3570AFCAD5011FCA94800AEA14C00AEF21103043O008EC02365025O0092AB40025O007C9B4003093O00FF762C90F39EA51DD303083O0076B61549C387ECCC025O00607640025O00649D4003113O00013F1F7F1719EF01371F000502F8486E4903073O009D685C7A20646D03083O008FA7D9CB11269EA303083O00CBC3C6AFAA5D47ED025O004C9F40025O00A6A54003103O00224A28D46E1DFD3D437ED45E14BC7C1F03073O009C4E2B5EB53171025O004EA440025O0080A240025O008AA540025O0054A040030D3O00E0D1493BD1CD5526E3D7533ADA03043O005FB7B82703113O0057696E6466757279546F74656D42752O66030D3O008236E922529510AC0BE832518D03073O0062D55F874634E003113O0054696D6553696E63654C61737443617374025O00805640025O00B08640025O003C9840030D3O0057696E6466757279546F74656D03153O00E9AAC77352EBB1D04840F1B7CC7A14FFACCC3706A703053O00349EC3A917030A3O005CB033798306738479B703083O00EB1ADC5214E6551B03123O008EADE8CF71B7B2E1CD7783E1E8CD71C8F2B903053O0014E8C189A2030A3O0004CDCAB5F3BF1F7E21D403083O001142BFA5C687EC7703093O0027AEA71FECFCE3C30203083O00B16FCFCE739F888C025O00A8A240025O00689E4003123O00039B1F07C0704C0D86131F944E5000C9434503073O003F65E97074B42F03093O000F50D2B0FF6F04324203073O006D5C25BCD49A1D030D3O00442O6F6D57696E647342752O6603073O0048617354696572026O003E40025O00A3B240025O0050A940025O00689D40025O00805840030F3O0017FAAAC734480DE1A383305501AFFD03063O003A648FC4A351025O00CAB040025O00C9B04003083O003C4B31A61146F30F03083O006E7A2243C35F298503103O0053BD5A47D346B95449DD51B4595FD07303053O00B615D13B2A03103O00915BC410248DBF58C61605BBB542C31B03063O00DED737A57D4103103O000ADDC717F7F2E5452FDAE21FF0D4EB4C03083O002A4CB1A67A92A18D025O0034A140025O0068B34003103O00A38317CB4678AA9C048E7879A0CA549E03063O0016C5EA65AE1903083O000135B3DD5AAEC48E03083O00E64D54C5BC16CFB7030D3O00D515D5F485AFF713F515CBF99F03083O00559974A69CECC190025O00407840025O00E0644003103O00A8E15BB2DB0CA5F345F3E50FA1A01CE203063O0060C4802DD38403083O00198C6D5EFEAEA7D003083O00B855ED1B3FB2CFD4030D3O002556054B0D57284C1B581C531C03043O003F68396903103O002D8BA5490EB4AC4B088C80410992A24203043O00246BE7C403103O007BB9A38A5886AA885EBE86825FA0A48103043O00E73DD5C2030D3O0028BE3576078E3C6708A124601D03043O001369CD5D03113O00417368656E436174616C79737442752O66025O00788440025O0002A94003103O00A509C88000A509CD897FA807DBC16EFB03053O005FC968BEE1025O0036AC40025O00F08D40030A3O0012BC22EB31832BE937BB03043O008654D043030E3O0023BE8F511CBE825512A0B15D05A903043O003C73CCE603083O00C133F975C935FD7103043O0010875A8B03113O005278073E4B2O6B5C7B05380E557751345303073O0018341466532E34025O0046AC40030E3O00E12324290ACA3B20282DC82E323003053O006FA44F414403103O00E3D586D32BE4D2D88FED3EE3D4D097CD03063O008AA6B9E3BE4E03103O00EE78C03A572D0DCA78F6275B3110DF6703073O0079AB14A5573243030E3O00E334BC3BBC0CD239B514B503D52C03063O0062A658D956D9025O00D2AD40025O009C9E4003153O00F3FA7C0C83D2E2F7753E84D0F7E56D4187D3F3B62F03063O00BC2O961961E6025O0010A740025O00AEAD40026O006640025O00E49940030E3O00F9815E0B02C1D38E571602E4D48E03063O008DBAE93F626C03143O00DEFC29A423FDE53BBF2BF6C72DB329E2FE3EB92803053O0045918A4CD6025O00409940025O00ECAF4003153O0073C78880B1297CC68E81AB1879C18EC9BE19758FDE03063O007610AF2OE9DF025O00B4A440025O00A09840030E3O00A89634A8E6A7742O8C21B5E7857A03073O001DEBE455DB8EEB03093O001CD8AAD57679285E3B03083O00325DB4DABD172E47025O00D07340025O00E0AC4003153O00DDB65A5F4CE344D7A353584AD546D9E45A43419C1003073O0028BEC43B2C24BC0015072O00120E012O00013O002E82000200EC0001000300046F3O00EC000100261C012O00EC0001000400046F3O00EC00012O00B900016O00E4000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001004200013O00046F3O004200012O00B9000100023O0006352O01004200013O00046F3O004200012O00B9000100033O0020EE0001000100084O00035O00202O0003000300094O00010003000200062O0001004200013O00046F3O004200012O00B900016O000C000200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001002D0001000100046F3O002D00012O00B900016O00E4000200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001004200013O00046F3O004200012O00B900016O0025010200013O00122O0003000F3O00122O000400106O0002000400024O00010001000200202O0001000100114O0001000200024O000200043O00062O000100420001000200046F3O004200012O00B900016O004C010200013O00122O000300123O00122O000400136O0002000400024O00010001000200202O0001000100114O00010002000200262O000100440001001400046F3O00440001002E820016005A0001001500046F3O005A00012O00B9000100053O00200F2O01000100174O00025O00202O0002000200184O000300066O000400076O000500033O00202O0005000500194O00075O00202O0007000700184O0005000700022O0054010500054O00502O01000500020006A2000100550001000100046F3O00550001002E39011B005A0001001A00046F3O005A00012O00B9000100013O00120E0102001C3O00120E0103001D4O0002000100034O00072O015O002E82001F00800001001E00046F3O008000012O00B900016O00E4000200013O00122O000300203O00122O000400216O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008000013O00046F3O008000012O00B9000100083O0006352O01008000013O00046F3O008000012O00B900016O006C010200013O00122O000300223O00122O000400236O0002000400024O00010001000200202O0001000100114O000100020002000E2O002400800001000100046F3O00800001002E39012500800001002600046F3O008000012O00B9000100094O00B900025O00201B0002000200272O00432O01000200020006352O01008000013O00046F3O008000012O00B9000100013O00120E010200283O00120E010300294O0002000100034O00072O016O00B900016O00E4000200013O00122O0003002A3O00122O0004002B6O0002000400024O00010001000200202O0001000100074O00010002000200062O000100B800013O00046F3O00B800012O00B90001000A3O0006352O0100B800013O00046F3O00B800012O00B90001000B3O0020EE00010001002C4O00035O00202O00030003002D4O00010003000200062O000100B800013O00046F3O00B800012O00B900016O000C000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100A50001000100046F3O00A500012O00B90001000B3O00206C0001000100304O00035O00202O0003000300314O00010003000200262O000100B80001001400046F3O00B800012O00B9000100094O00D500025O00202O0002000200324O000300033O00202O0003000300194O00055O00202O0005000500324O0003000500024O000300036O00010003000200062O000100B30001000100046F3O00B30001002E47003300070001003400046F3O00B800012O00B9000100013O00120E010200353O00120E010300364O0002000100034O00072O015O002E39013800EB0001003700046F3O00EB00012O00B900016O00E4000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200202O0001000100074O00010002000200062O000100EB00013O00046F3O00EB00012O00B90001000C3O0006352O0100EB00013O00046F3O00EB00012O00B900016O00E4000200013O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100EB00013O00046F3O00EB00012O00B90001000B3O0020EE00010001002C4O00035O00202O00030003003D4O00010003000200062O000100EB00013O00046F3O00EB00012O00B9000100043O000E3B010400EB0001000100046F3O00EB00012O00B9000100094O008C00025O00202O00020002003E4O000300033O00202O00030003003F00122O000500406O0003000500024O000300036O00010003000200062O000100EB00013O00046F3O00EB00012O00B9000100013O00120E010200413O00120E010300424O0002000100034O00072O015O00120E012O00403O002E39014400B12O01004300046F3O00B12O0100261C012O00B12O01002400046F3O00B12O0100120E2O0100013O000E41014500F50001000100046F3O00F5000100120E012O00043O00046F3O00B12O0100261C2O0100522O01000100046F3O00522O012O00B900026O00E4000300013O00122O000400463O00122O000500476O0003000500024O00020002000300202O0002000200074O00020002000200062O0002000E2O013O00046F3O000E2O012O00B90002000D3O0006350102000E2O013O00046F3O000E2O012O00B900026O000C000300013O00122O000400483O00122O000500496O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200102O01000100046F3O00102O01002E82004B00202O01004A00046F3O00202O012O00B9000200094O008C00035O00202O00030003004C4O000400033O00202O00040004003F00122O000600406O0004000600024O000400046O00020004000200062O000200202O013O00046F3O00202O012O00B9000200013O00120E0103004D3O00120E0104004E4O0002000200044O000701026O00B900026O00E4000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200074O00020002000200062O000200512O013O00046F3O00512O012O00B90002000E3O000635010200512O013O00046F3O00512O012O00B900026O00E4000300013O00122O000400513O00122O000500526O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200512O013O00046F3O00512O012O00B90002000B3O0020EE00020002002C4O00045O00202O0004000400534O00020004000200062O000200512O013O00046F3O00512O01002E39015500512O01005400046F3O00512O012O00B9000200094O00B700035O00202O0003000300564O000400033O00202O0004000400194O00065O00202O0006000600564O0004000600024O000400046O00020004000200062O000200512O013O00046F3O00512O012O00B9000200013O00120E010300573O00120E010400584O0002000200044O000701025O00120E2O0100593O000E41015900F10001000100046F3O00F100012O00B900026O00E4000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002007E2O013O00046F3O007E2O012O00B90002000F3O0006350102007E2O013O00046F3O007E2O012O00B9000200103O000635010200672O013O00046F3O00672O012O00B9000200113O0006A20002006A2O01000100046F3O006A2O012O00B9000200103O0006A20002007E2O01000100046F3O007E2O012O00B9000200124O00B9000300133O0006700002007E2O01000300046F3O007E2O012O00B9000200094O008C00035O00202O00030003005C4O000400033O00202O00040004005D00122O000600406O0004000600024O000400046O00020004000200062O0002007E2O013O00046F3O007E2O012O00B9000200013O00120E0103005E3O00120E0104005F4O0002000200044O000701025O002E39016000AF2O01006100046F3O00AF2O012O00B900026O00E4000300013O00122O000400623O00122O000500636O0003000500024O00020002000300202O0002000200074O00020002000200062O000200AF2O013O00046F3O00AF2O012O00B9000200023O000635010200AF2O013O00046F3O00AF2O012O00B900026O00E4000300013O00122O000400643O00122O000500656O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200AF2O013O00046F3O00AF2O012O00B9000200033O0020EE0002000200664O00045O00202O0004000400094O00020004000200062O000200AF2O013O00046F3O00AF2O012O00B9000200094O00B700035O00202O0003000300184O000400033O00202O0004000400194O00065O00202O0006000600184O0004000600024O000400046O00020004000200062O000200AF2O013O00046F3O00AF2O012O00B9000200013O00120E010300673O00120E010400684O0002000200044O000701025O00120E2O0100453O00046F3O00F10001002E470069003B2O01006900046F3O00EC020100261C012O00EC0201000100046F3O00EC02012O00B900016O00E4000200013O00122O0003006A3O00122O0004006B6O0002000400024O00010001000200202O0001000100074O00010002000200062O000100DC2O013O00046F3O00DC2O012O00B90001000C3O0006352O0100DC2O013O00046F3O00DC2O012O00B900016O00E4000200013O00122O0003006C3O00122O0004006D6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100DC2O013O00046F3O00DC2O012O00B900016O00E4000200013O00122O0003006E3O00122O0004006F6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100D92O013O00046F3O00D92O012O00B9000100043O000E4E007000DE2O01000100046F3O00DE2O012O00B9000100043O000E4E007100DE2O01000100046F3O00DE2O01002E47007200140001007300046F3O00F02O012O00B9000100094O005800025O00202O00020002003E4O000300033O00202O00030003003F00122O000500406O0003000500024O000300036O00010003000200062O000100EB2O01000100046F3O00EB2O01002E47007400070001007500046F3O00F02O012O00B9000100013O00120E010200763O00120E010300774O0002000100034O00072O015O002E390179005A0201007800046F3O005A02012O00B900016O00E4000200013O00122O0003007A3O00122O0004007B6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001005A02013O00046F3O005A02012O00B9000100143O0006352O01005A02013O00046F3O005A02012O00B9000100033O0020222O010001007C4O00035O00202O0003000300094O0001000300024O000200043O00062O000200080001000100046F3O000E02012O00B9000100033O0020E300010001007C4O00035O00202O0003000300094O000100030002000E2O0014005A0201000100046F3O005A02012O00B90001000B3O0020EE00010001002C4O00035O00202O00030003007D4O00010003000200062O0001005A02013O00046F3O005A02012O00B90001000B3O0020010001000100304O00035O00202O00030003007E4O0001000300024O000200153O00122O000300406O000400166O00058O000600013O00122O0007007F3O00122O000800806O0006000800024O00050005000600202O00050005000C4O000500066O00043O000200102O0004004000044O0002000400024O000300173O00122O000400406O000500166O00068O000700013O00122O0008007F3O00122O000900806O0007000900024O00060006000700202O00060006000C4O000600076O00053O000200102O0005004000054O0003000500024O00020002000300062O0001005A0201000200046F3O005A02012O00B90001000B3O0020BC0001000100814O00035O00202O0003000300824O00010003000200062O000100490201000100046F3O004902012O00B9000100133O0026692O0100490201008300046F3O004902012O00B9000100124O00B90002000B3O0020020102000200842O00430102000200020006510001005A0201000200046F3O005A02012O00B9000100094O00B700025O00202O0002000200854O000300033O00202O0003000300194O00055O00202O0005000500854O0003000500024O000300036O00010003000200062O0001005A02013O00046F3O005A02012O00B9000100013O00120E010200863O00120E010300874O0002000100034O00072O016O00B900016O00E4000200013O00122O000300883O00122O000400896O0002000400024O00010001000200202O0001000100074O00010002000200062O000100B402013O00046F3O00B402012O00B9000100183O0006352O0100B402013O00046F3O00B402012O00B900016O00E4000200013O00122O0003008A3O00122O0004008B6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100B402013O00046F3O00B402012O00B900016O000C000200013O00122O0003008C3O00122O0004008D6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100850201000100046F3O008502012O00B900016O00E4000200013O00122O0003008E3O00122O0004008F6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100B402013O00046F3O00B402012O00B9000100033O0020EE0001000100904O00035O00202O0003000300094O00010003000200062O000100B402013O00046F3O00B402012O00B900016O0025010200013O00122O000300913O00122O000400926O0002000400024O00010001000200202O0001000100114O0001000200024O000200043O00062O000100B40201000200046F3O00B402012O00B900016O00FD000200013O00122O000300933O00122O000400946O0002000400024O00010001000200202O0001000100114O00010002000200262O000100B40201001400046F3O00B40201002E82009500B40201009600046F3O00B402012O00B9000100094O00B700025O00202O0002000200974O000300033O00202O0003000300194O00055O00202O0005000500974O0003000500024O000300036O00010003000200062O000100B402013O00046F3O00B402012O00B9000100013O00120E010200983O00120E010300994O0002000100034O00072O016O00B900016O00E4000200013O00122O0003009A3O00122O0004009B6O0002000400024O00010001000200202O00010001009C4O00010002000200062O000100D502013O00046F3O00D502012O00B9000100193O0006352O0100D502013O00046F3O00D502012O00B90001001A3O0006352O0100C702013O00046F3O00C702012O00B9000100113O0006A2000100CA0201000100046F3O00CA02012O00B90001001A3O0006A2000100D50201000100046F3O00D502012O00B9000100124O00B9000200133O000670000100D50201000200046F3O00D502012O00B90001000B3O0020BC0001000100814O00035O00202O00030003007D4O00010003000200062O000100D70201000100046F3O00D70201002E82009D00EB0201009E00046F3O00EB02012O00B9000100053O0020550001000100174O00025O00202O00020002009F4O000300066O000400076O000500033O00202O0005000500194O00075O00202O00070007009F4O0005000700024O000500056O00010005000200062O000100EB02013O00046F3O00EB02012O00B9000100013O00120E010200A03O00120E010300A14O0002000100034O00072O015O00120E012O00593O0026653O00F00201001400046F3O00F00201002E8200A200A3030100A300046F3O00A303012O00B900016O00E4000200013O00122O000300A43O00122O000400A56O0002000400024O00010001000200202O0001000100074O00010002000200062O000100FD02013O00046F3O00FD02012O00B90001000C3O0006A2000100FF0201000100046F3O00FF0201002E8200A70011030100A600046F3O00110301002E3901A80011030100A900046F3O001103012O00B9000100094O008C00025O00202O00020002003E4O000300033O00202O00030003003F00122O000500406O0003000500024O000300036O00010003000200062O0001001103013O00046F3O001103012O00B9000100013O00120E010200AA3O00120E010300AB4O0002000100034O00072O016O00B900016O00E4000200013O00122O000300AC3O00122O000400AD6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001003503013O00046F3O003503012O00B9000100083O0006352O01003503013O00046F3O003503012O00B900016O006C010200013O00122O000300AE3O00122O000400AF6O0002000400024O00010001000200202O0001000100114O000100020002000E2O004500350301000100046F3O00350301002E8200B00035030100B100046F3O003503012O00B9000100094O00B900025O00201B0002000200272O00432O01000200020006352O01003503013O00046F3O003503012O00B9000100013O00120E010200B23O00120E010300B34O0002000100034O00072O016O00B900016O00E4000200013O00122O000300B43O00122O000400B56O0002000400024O00010001000200202O0001000100074O00010002000200062O0001007B03013O00046F3O007B03012O00B90001001B3O0006352O01007B03013O00046F3O007B03012O00B900016O00E4000200013O00122O000300B63O00122O000400B76O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001006803013O00046F3O006803012O00B900016O00E4000200013O00122O000300B83O00122O000400B96O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001007B03013O00046F3O007B03012O00B900016O0045000200013O00122O000300BA3O00122O000400BB6O0002000400024O00010001000200202O0001000100BC4O0001000200024O0002001C3O00062O000100680301000200046F3O006803012O00B90001000B3O0020EE00010001002C4O00035O00202O0003000300BD4O00010003000200062O0001007B03013O00046F3O007B03012O00B9000100094O00D500025O00202O0002000200BE4O000300033O00202O0003000300194O00055O00202O0005000500BE4O0003000500024O000300036O00010003000200062O000100760301000100046F3O00760301002E8200C0007B030100BF00046F3O007B03012O00B9000100013O00120E010200C13O00120E010300C24O0002000100034O00072O016O00B900016O00E4000200013O00122O000300C33O00122O000400C46O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008F03013O00046F3O008F03012O00B90001001D3O0006352O01008F03013O00046F3O008F03012O00B90001000B3O00201E0001000100304O00035O00202O00030003007E4O000100030002000E2O004000910301000100046F3O00910301002E8200C500A2030100C600046F3O00A203012O00B9000100094O00B700025O00202O0002000200C74O000300033O00202O0003000300194O00055O00202O0005000500C74O0003000500024O000300036O00010003000200062O000100A203013O00046F3O00A203012O00B9000100013O00120E010200C83O00120E010300C94O0002000100034O00072O015O00120E012O00CA3O0026653O00A70301004000046F3O00A70301002E8200CC004A040100CB00046F3O004A040100120E2O0100013O000E152O0100AC0301000100046F3O00AC0301002E4700CD004D000100CE00046F3O00F7030100120E010200013O002665000200B10301000100046F3O00B10301002E3901CF00F2030100D000046F3O00F20301002E8200D100D1030100D200046F3O00D103012O00B900036O00E4000400013O00122O000500D33O00122O000600D46O0004000600024O00030003000400202O00030003009C4O00030002000200062O000300D103013O00046F3O00D103012O00B90003001E3O000635010300D103013O00046F3O00D103012O00B9000300094O00B700045O00202O0004000400D54O000500033O00202O0005000500194O00075O00202O0007000700D54O0005000700024O000500056O00030005000200062O000300D103013O00046F3O00D103012O00B9000300013O00120E010400D63O00120E010500D74O0002000300054O000701036O00B900036O00E4000400013O00122O000500D83O00122O000600D96O0004000600024O00030003000400202O0003000300074O00030002000200062O000300F103013O00046F3O00F103012O00B90003000A3O000635010300F103013O00046F3O00F103012O00B9000300094O00D500045O00202O0004000400324O000500033O00202O0005000500194O00075O00202O0007000700324O0005000700024O000500056O00030005000200062O000300EC0301000100046F3O00EC0301002E4700DA0007000100DB00046F3O00F103012O00B9000300013O00120E010400DC3O00120E010500DD4O0002000300054O000701035O00120E010200593O00261C010200AD0301005900046F3O00AD030100120E2O0100593O00046F3O00F7030100046F3O00AD0301000E15014500FB0301000100046F3O00FB0301002E8200DE00FD030100DF00046F3O00FD030100120E012O00143O00046F3O004A0401000E41015900A80301000100046F3O00A8030100120E010200013O00261C010200420401000100046F3O004204012O00B900036O00E4000400013O00122O000500E03O00122O000600E16O0004000600024O00030003000400202O0003000300074O00030002000200062O0003000F04013O00046F3O000F04012O00B90003000D3O0006A2000300110401000100046F3O00110401002E4700E20012000100E300046F3O002104012O00B9000300094O008C00045O00202O00040004004C4O000500033O00202O00050005003F00122O000700406O0005000700024O000500056O00030005000200062O0003002104013O00046F3O002104012O00B9000300013O00120E010400E43O00120E010500E54O0002000300054O000701036O00B900036O00E4000400013O00122O000500E63O00122O000600E76O0004000600024O00030003000400202O0003000300074O00030002000200062O0003002E04013O00046F3O002E04012O00B9000300183O0006A2000300300401000100046F3O00300401002E4700E80013000100E900046F3O004104012O00B9000300094O00B700045O00202O0004000400974O000500033O00202O0005000500194O00075O00202O0007000700974O0005000700024O000500056O00030005000200062O0003004104013O00046F3O004104012O00B9000300013O00120E010400EA3O00120E010500EB4O0002000300054O000701035O00120E010200593O002665000200460401005900046F3O00460401002E3901EC2O00040100ED00046F4O00040100120E2O0100453O00046F3O00A8030100046F4O00040100046F3O00A8030100261C012O00CC040100CA00046F3O00CC0401002E8200EF007A040100EE00046F3O007A04012O00B900016O00E4000200013O00122O000300F03O00122O000400F16O0002000400024O00010001000200202O0001000100074O00010002000200062O0001007A04013O00046F3O007A04012O00B90001001F3O0006352O01007A04013O00046F3O007A04012O00B90001000B3O0020090001000100814O00035O00202O0003000300F24O000400016O00010004000200062O0001006D0401000100046F3O006D04012O00B900016O007F000200013O00122O000300F33O00122O000400F46O0002000400024O00010001000200202O0001000100F54O000100020002000E2O00F6007A0401000100046F3O007A0401002E3901F7007A040100F800046F3O007A04012O00B9000100094O00B900025O00201B0002000200F92O00432O01000200020006352O01007A04013O00046F3O007A04012O00B9000100013O00120E010200FA3O00120E010300FB4O0002000100034O00072O016O00B900016O00E4000200013O00122O000300FC3O00122O000400FD6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001009F04013O00046F3O009F04012O00B9000100023O0006352O01009F04013O00046F3O009F04012O00B9000100033O0020EE0001000100664O00035O00202O0003000300094O00010003000200062O0001009F04013O00046F3O009F04012O00B9000100094O00B700025O00202O0002000200184O000300033O00202O0003000300194O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O0001009F04013O00046F3O009F04012O00B9000100013O00120E010200FE3O00120E010300FF4O0002000100034O00072O016O00B900016O00E4000200013O00122O00032O00012O00122O0004002O015O0002000400024O00010001000200202O0001000100074O00010002000200062O0001001407013O00046F3O001407012O00B90001000E3O0006352O01001407013O00046F3O001407012O00B900016O000C000200013O00122O00030002012O00122O00040003015O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100140701000100046F3O0014070100120E2O010004012O00120E01020005012O000651000200140701000100046F3O001407012O00B9000100094O00B700025O00202O0002000200564O000300033O00202O0003000300194O00055O00202O0005000500564O0003000500024O000300036O00010003000200062O0001001407013O00046F3O001407012O00B9000100013O0012E900020006012O00122O00030007015O000100036O00015O00044O0014070100120E2O0100453O0006AD3O00DE0501000100046F3O00DE05012O00B900016O00E4000200013O00122O00030008012O00122O00040009015O0002000400024O00010001000200202O0001000100074O00010002000200062O000100F904013O00046F3O00F904012O00B90001000F3O0006352O0100F904013O00046F3O00F904012O00B9000100103O0006352O0100E204013O00046F3O00E204012O00B9000100113O0006A2000100E50401000100046F3O00E504012O00B9000100103O0006A2000100F90401000100046F3O00F904012O00B9000100124O00B9000200133O000670000100F90401000200046F3O00F904012O00B90001000B3O0020DD00010001002C4O00035O00122O0004000A015O0003000300044O00010003000200062O000100FD0401000100046F3O00FD04012O00B90001000B3O00123E0003000B015O00010001000300122O0003000C012O00122O000400456O00010004000200062O000100FD0401000100046F3O00FD040100120E2O01000D012O00120E0102000E012O0006AD000100110501000200046F3O001105012O00B9000100094O005800025O00202O00020002005C4O000300033O00202O00030003005D00122O000500406O0003000500024O000300036O00010003000200062O0001000C0501000100046F3O000C050100120E2O01000F012O00120E01020010012O000651000100110501000200046F3O001105012O00B9000100013O00120E01020011012O00120E01030012013O0002000100034O00072O015O00120E2O010013012O00120E01020014012O000670000200520501000100046F3O005205012O00B900016O00E4000200013O00122O00030015012O00122O00040016015O0002000400024O00010001000200202O0001000100074O00010002000200062O0001005205013O00046F3O005205012O00B9000100083O0006352O01005205013O00046F3O005205012O00B900016O00C8000200013O00122O00030017012O00122O00040018015O0002000400024O00010001000200202O0001000100114O00010002000200122O000200143O00062O000200170001000100046F3O004305012O00B900016O000A010200013O00122O00030019012O00122O0004001A015O0002000400024O00010001000200202O0001000100114O00010002000200122O000200043O00062O000200520501000100046F3O005205012O00B900016O003D000200013O00122O0003001B012O00122O0004001C015O0002000400024O00010001000200202O0001000100114O0001000200024O000200043O00062O000200520501000100046F3O0052050100120E2O01001D012O00120E0102001E012O000670000100520501000200046F3O005205012O00B9000100094O00B900025O00201B0002000200272O00432O01000200020006352O01005205013O00046F3O005205012O00B9000100013O00120E0102001F012O00120E01030020013O0002000100034O00072O016O00B900016O00E4000200013O00122O00030021012O00122O00040022015O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008105013O00046F3O008105012O00B9000100183O0006352O01008105013O00046F3O008105012O00B900016O00E4000200013O00122O00030023012O00122O00040024015O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001008105013O00046F3O0081050100120E2O010025012O00120E01020026012O000651000200810501000100046F3O008105012O00B9000100053O0020550001000100174O00025O00202O0002000200974O000300066O000400206O000500033O00202O0005000500194O00075O00202O0007000700974O0005000700024O000500056O00010005000200062O0001008105013O00046F3O008105012O00B9000100013O00120E01020027012O00120E01030028013O0002000100034O00072O016O00B900016O00E4000200013O00122O00030029012O00122O0004002A015O0002000400024O00010001000200202O0001000100074O00010002000200062O000100DD05013O00046F3O00DD05012O00B9000100183O0006352O0100DD05013O00046F3O00DD05012O00B900016O00E4000200013O00122O0003002B012O00122O0004002C015O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100B505013O00046F3O00B505012O00B9000100033O0020EE0001000100904O00035O00202O0003000300094O00010003000200062O000100B505013O00046F3O00B505012O00B900016O0025010200013O00122O0003002D012O00122O0004002E015O0002000400024O00010001000200202O0001000100114O0001000200024O000200043O00062O000100B50501000200046F3O00B505012O00B900016O0006010200013O00122O0003002F012O00122O00040030015O0002000400024O00010001000200202O0001000100114O00010002000200122O000200143O00062O000100C80501000200046F3O00C805012O00B900016O00E4000200013O00122O00030031012O00122O00040032015O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100DD05013O00046F3O00DD05012O00B90001000B3O0020EC0001000100304O00035O00122O00040033015O0003000300044O00010003000200122O000200403O00062O000100DD0501000200046F3O00DD05012O00B9000100094O00D500025O00202O0002000200974O000300033O00202O0003000300194O00055O00202O0005000500974O0003000500024O000300036O00010003000200062O000100D80501000100046F3O00D8050100120E2O010034012O00120E01020035012O0006AD000100DD0501000200046F3O00DD05012O00B9000100013O00120E01020036012O00120E01030037013O0002000100034O00072O015O00120E012O00243O00120E2O0100593O0006AD3O00010001000100046F3O0001000100120E2O0100013O00120E01020038012O00120E01030039012O0006510003006F0601000200046F3O006F060100120E010200013O0006AD0001006F0601000200046F3O006F06012O00B900026O00E4000300013O00122O0004003A012O00122O0005003B015O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002206013O00046F3O002206012O00B9000200023O0006350102002206013O00046F3O002206012O00B900026O000C000300013O00122O0004003C012O00122O0005003D015O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002000A0601000100046F3O000A06012O00B900026O00E4000300013O00122O0004003E012O00122O0005003F015O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002002206013O00046F3O002206012O00B9000200033O0020EE0002000200664O00045O00202O0004000400094O00020004000200062O0002002206013O00046F3O002206012O00B9000200094O00B700035O00202O0003000300184O000400033O00202O0004000400194O00065O00202O0006000600184O0004000600024O000400046O00020004000200062O0002002206013O00046F3O002206012O00B9000200013O00120E01030040012O00120E01040041013O0002000200044O000701025O00120E01020042012O00120E01030042012O0006AD0002006E0601000300046F3O006E06012O00B900026O00E4000300013O00122O00040043012O00122O00050044015O0003000500024O00020002000300202O0002000200074O00020002000200062O0002006E06013O00046F3O006E06012O00B90002001B3O0006350102006E06013O00046F3O006E06012O00B900026O00E4000300013O00122O00040045012O00122O00050046015O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002005906013O00046F3O005906012O00B900026O00E4000300013O00122O00040047012O00122O00050048015O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002006E06013O00046F3O006E06012O00B900026O0045000300013O00122O00040049012O00122O0005004A015O0003000500024O00020002000300202O0002000200BC4O0002000200024O0003001C3O00062O000200590601000300046F3O005906012O00B90002000B3O0020EE00020002002C4O00045O00202O0004000400BD4O00020004000200062O0002006E06013O00046F3O006E060100120E0102004B012O00120E0103004C012O0006510003006E0601000200046F3O006E06012O00B9000200094O00B700035O00202O0003000300BE4O000400033O00202O0004000400194O00065O00202O0006000600BE4O0004000600024O000400046O00020004000200062O0002006E06013O00046F3O006E06012O00B9000200013O00120E0103004D012O00120E0104004E013O0002000200044O000701025O00120E2O0100593O00120E010200453O0006AD000100740601000200046F3O0074060100120E012O00453O00046F3O0001000100120E010200593O00067D0001007B0601000200046F3O007B060100120E0102004F012O00120E01030050012O000670000300E20501000200046F3O00E2050100120E01020051012O00120E01030052012O000651000200C70601000300046F3O00C706012O00B900026O00E4000300013O00122O00040053012O00122O00050054015O0003000500024O00020002000300202O0002000200074O00020002000200062O000200C706013O00046F3O00C706012O00B90002001D3O000635010200C706013O00046F3O00C706012O00B90002000B3O00201F0002000200304O00045O00202O00040004007E4O0002000400024O000300153O00122O000400406O000500166O00068O000700013O00122O00080055012O00120E01090056013O008B0007000900024O00060006000700202O00060006000C4O000600076O00053O000200122O000600406O0005000600054O0003000500024O000400173O00122O000500404O00B9000600164O005901078O000800013O00122O00090055012O00122O000A0056015O0008000A00024O00070007000800202O00070007000C4O000700086O00063O000200122O000700404O00D60006000700062O00500104000600022O00CB0003000300040006AD000200C70601000300046F3O00C706012O00B9000200094O00D500035O00202O0003000300C74O000400033O00202O0004000400194O00065O00202O0006000600C74O0004000600024O000400046O00020004000200062O000200C20601000100046F3O00C2060100120E01020057012O00120E01030058012O000651000300C70601000200046F3O00C706012O00B9000200013O00120E01030059012O00120E0104005A013O0002000200044O000701025O00120E0102005B012O00120E0103005C012O000651000300110701000200046F3O001107012O00B900026O00E4000300013O00122O0004005D012O00122O0005005E015O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001107013O00046F3O001107012O00B90002000C3O0006350102001107013O00046F3O001107012O00B90002000B3O0020DD00020002002C4O00045O00122O0005000A015O0004000400054O00020004000200062O000200FD0601000100046F3O00FD06012O00B90002000B3O0020BC0002000200814O00045O00202O00040004002D4O00020004000200062O000200FD0601000100046F3O00FD06012O00B900026O00E4000300013O00122O0004005F012O00122O00050060015O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002001107013O00046F3O001107012O00B90002000B3O0020EE00020002002C4O00045O00202O0004000400BD4O00020004000200062O0002001107013O00046F3O001107012O00B9000200214O007700020001000200120E010300013O0006AD000200110701000300046F3O0011070100120E01020061012O00120E01030062012O000670000200110701000300046F3O001107012O00B9000200094O008C00035O00202O00030003003E4O000400033O00202O00040004003F00122O000600406O0004000600024O000400046O00020004000200062O0002001107013O00046F3O001107012O00B9000200013O00120E01030063012O00120E01040064013O0002000200044O000701025O00120E2O0100453O00046F3O00E2050100046F3O000100012O00293O00017O0072012O00028O00025O0070AA40026O001840025O001EAD40025O00BCA040030D3O00DB2826027D98EB35D82E3C037603083O004C8C4148661BED9903073O004973526561647903083O0042752O66446F776E03113O0057696E6466757279546F74656D42752O66030D3O007DD318D6D114AC53EE19C6D20C03073O00DE2ABA76B2B76103113O0054696D6553696E63654C61737443617374025O00805640030D3O0057696E6466757279546F74656D03183O004AE54A8E5BF9569362F84B9E58E1048C48E24A8F51AC17DB03043O00EA3D8C24025O00409A40025O002EA440030A3O0007D1BB7F0A12D5B5710403053O006F41BDDA12030A3O00446562752O66446F776E03103O00466C616D6553686F636B446562752O66030A3O00466C616D6553686F636B030E3O0049735370652O6C496E52616E676503153O0045471A380E63BC4B44183E4B5ABA4D451E394B0FFD03073O00CF232B7B556B3C030A3O0056B8AFF96D43A2AFE97203053O001910CAC08A03093O00D5CAA4EEBAE0F2D9A003063O00949DABCD82C9030B3O004973417661696C61626C65025O00709F40025O00E0A040030A3O0046726F737453686F636B03153O0025C67B3AC5C930DC7B2ADAB625C17A27D4FA63872703063O009643B41449B1026O001040026O00F03F025O004CA240025O00D6AC40030B3O0026B6F00A3606B6ED11301003053O005B75C29F78025O002OB240025O00C06D40025O00F4AA40025O00D3B140030B3O0053746F726D737472696B6503153O002O09310A38E2300814351D75F73114133B1475A37703073O00447A7D5E78559103093O003E1FCA6DDCCBB31C1903073O00DA777CAF3EA8B9025O00607040025O002OA84003093O00496365537472696B65030E3O004973496E4D656C2O6552616E6765026O00144003143O00ACF34DFBB6E45ACDAEF508C2B0FE46C1A9B01A9003043O00A4C59028025O00A0A240025O00E4AF40027O0040025O0022AE40025O00EEA040030E3O00F5B4E6D4719BDFA1EFD377BED8A103063O00D7B6C687A719030E3O00AE5BEB5B8540E44FBE5DE55A805A03043O0028ED298A03063O0042752O66557003143O00434C43726173684C696768746E696E6742752O66025O0056B140025O00289E40030E3O0043726173684C696768746E696E6703193O00C466FBEB42F878F3FF42D37AF3F64D8772EFF644C278BAAA1B03053O002AA7149A98030A3O007DF7AC46623558F7A94703063O00412A9EC22211030A3O0049734361737461626C65030A3O0057696E64737472696B65025O00608A40025O00C0714003143O000D2E5C083EF909E71122120A38E315EB1667005E03083O008E7A47326C4D8D7B03083O00AFF1BC8AF1B790F803063O00D6E390CAEBBD03083O004C6176614C61736803133O00E1A4917A2FBF522F2OE5816E1EBD5630ADF7D203083O005C8DC5E71B70D333025O005C9140025O00709340025O0004AF40025O0032A240025O00949240025O009AA740025O0048B040025O005EAC40030A3O0005EA86395A4E20EA833803063O003A5283E85D2903113O00B75FDF075432907EDE03523C8243D91A5303063O005FE337B0753D03093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O6603143O00436F6E76657267696E6753746F726D7342752O6603133O000F772D4FB80C6C2A40AE58783645A51D72631D03053O00CB781E432B030B3O00C23142FDD4E2315FE6D2F403053O00B991452D8F025O00C8A640025O0076AF4003143O00990B16B4D1992O0BAFD78F5F1FB3D2841A15E68B03053O00BCEA7F79C6025O00909840025O00D6AF40025O00489C40026O00B340025O00E49740025O00A8B140030D3O007CF001B74B71F07457DB09B34B03083O001A309966DF3F1F9903143O002D56E8E1044CE2E40B4EEADE0345E1E01652E2FE03043O009362208D030D3O004C696768746E696E67426F6C74025O00F09E40025O0004964003183O00144AE4C21258421644DCC8095A5F5845F6C40853475812B303073O002B782383AA6636030E3O001B3A128A361E1A8430261D8A363503043O00E358527303143O006C09BFB5047F4C08B3A9055E421AB6B416614C1203063O0013237FDAC76203143O00437261636B6C696E675468756E64657242752O66030E3O00436861696E4C696768746E696E6703183O001FF30BEB12C406EB1BF31EEC15F50DA21AEE04EC19F74ABA03043O00827C9B6A03093O00F9CAE0AE81E36EACC103083O00DFB5AB96CFC3961C03103O004D6F6C74656E576561706F6E42752O6603143O00566F6C63616E6963537472656E67746842752O6603123O00437261636B6C696E67537572676542752O6603143O00632CE6BC0F4035F4A7074B17E2AB055F2EF1A10403053O00692C5A83CE03093O004C617661427572737403133O00F3E1A4B8373CEAF2A1AD4838EAEE2OBC047EA603063O005E9F80D2D968025O0022A040025O00209A40025O00E8B140025O00B49340025O007C9040025O00788440025O00E07F40030E3O00771486A5AD9C8D530E93B8ACBE8303073O00E43466E7D6C5D0030D3O00442O6F6D57696E647342752O6603123O0043726173684C696768746E696E6742752O6603093O003FEC65C2EBBC16DA1803083O00B67E8015AA8AEB79030F3O00466572616C53706972697442752O6603103O00A8D53BF08301370F85DD06F289013D1503083O0066EBBA5586E67350025O0030B040025O0012A24003193O00541E3F4C7AEB2E5E0B364B7CDD2C504C384A7CDA275B4C6F0E03073O0042376C5E3F12B4025O0050A340025O006AA94003093O0027988B33224B1D838203063O003974EDE5574703073O0048617354696572026O003E4003093O0053756E646572696E6703093O004973496E52616E676503133O00B9A42OE372FC4EA4B6ADE162E049AFBDADB62503073O0027CAD18D87178E025O00509840025O00F0A840030A3O00E5144CC1534D2CCC054803073O0044A36623B2271E03093O009671D3CB10A18C03B303083O0071DE10BAA763D5E3030D3O004861696C73746F726D42752O66025O00A7B240025O00D0964003153O00281CF4E53A31E8FE210DF0B6281BF5F82B02BBA77B03043O00964E6E9B026O000840025O00B07F40025O00ECAA4003083O00D93A1B0F1CF7E93203063O00989F53696A5203103O00A7CA50FFCC6F89C952F9ED5983D357F403063O003CE1A63192A9030F3O0041757261416374697665436F756E7403103O0009122E27043427112C2125022D0B292C03063O00674F7E4F4A6103103O009C73D27E5B29B270D0787A1FB86AD57503063O007ADA1FB3133E025O0098A940025O001EA14003083O00466972654E6F7661025O00E2AA40025O0080AA4003133O00B52ODFC4F6AF4AA5D78DC7DCAF4BB6DA8D909A03073O0025D3B6ADA1A9C1025O00388D40025O00608D4003093O00DE3948EA3C69B0FC3F03073O00D9975A2DB9481B03093O00EB7DEE1E45D773F51F03053O0036A31C8772030D3O00496365537472696B6542752O66025O00149740025O0092A34003143O0021D858BD5D6B3AD256870E793DD55387423F798F03063O001F48BB3DE22E025O0002B040025O00B6A040025O00805840030D3O00EF32EA1AEC38CA35EA30F73AD703063O0056A35B8D7298030B3O00446562752O66537461636B03123O005072696D6F726469616C5761766542752O6603143O007C1D71613C5F04637A345426757636401F667C3703053O005A336B141303163O0053706C696E7465726564456C656D656E747342752O66026O0028402O033O0047434403173O0081F982E72983F98BE8028FFF89FB7D8BE58BE13881B0D403053O005DED90E58F03083O0039F7E618274706FE03063O0026759690796B030D4O00B4E22E28B5CF293EBAFB363903043O005A4DDB8E03083O00446562752O66557003103O00C0082034493472E9072A1D49056FE00203073O001A866441592C6703103O00D7EF312EA1C2EB3F20AFD5E63236A2F703053O00C491835043030D3O003FA30E0D16CB1FA4070401FB0A03063O00887ED066687803113O00417368656E436174616C79737442752O66025O004AA040025O0032A340025O00807D40025O005EA04003123O00748BD842905E3C4270CAC856A15C385D38D803083O003118EAAE23CF325D030E3O003CE0F4857E1EF6F4897D3BF3EB8D03053O00116C929DE803093O00436173744379636C65030E3O005072696D6F726469616C5761766503183O005BD11DE020BA4FCA15E110BF4AD511AD29BD45CD11E16FFB03063O00C82BA3748D4F030A3O00993A3C8EB5C7EBB0353603073O0083DF565DE3D094030E3O00D357BFBB12A7E74CB7BA2AB4F54003063O00D583252OD67D03084O002237BACF293D2403053O0081464B45DF03143O0040C7F2E479D055C3FCEA77AF40DEFDE779E3069F03063O008F26AB93891C025O0034A940025O00BCAB40030E3O00F58EBCFE06EDC0D18E9BFF02F0C003073O00B4B0E2D993638303103O00F6B52A0AD6B73B06DF8A3F0EC1B03B1403043O0067B3D94F03103O006FBB19D84482B74BBB2FC5489EAA5EA403073O00C32AD77CB521EC030E3O002855323320F619583B1C29F91E4D03063O00986D39575E4503073O0043686172676573030E3O00456C656D656E74616C426C617374025O00207840025O00888C4003183O00FCDB0FAEBBDC40A9F5E808AFBFC140E8FFC204ADBBDE14FD03083O00C899B76AC3DEB234030E3O00C5ED8BB0D9CAF68DABC5E8F684A403053O00B1869FEAC303193O00BEF93EB3C182E736A7C1A9E536AECEFDED2AAEC7B8E77FF29F03053O00A9DD8B5FC003083O00F8826D3A0C29C88A03063O0046BEEB1F5F4203103O009CEE1BEBE089EA15E5EE9EE718F3E3BC03053O0085DA827A86025O00BBB240025O003C914003133O003AF6F1C1E3AD372AFEA3C2C9AD3639F3A3968B03073O00585C9F83A4BCC3030D3O000C2BEAADED862OE72700E2A9ED03083O008940428DC599E88E025O0014B340025O0040B240025O00B9B140025O006AA74003183O000FD925AE9C0DD92CA1B701DF2EB2C805C52CA88D0F9071F603053O00E863B042C6030E3O00A522BA46D2E5C981229D47D6F8C903073O00BDE04EDF2BB78B03103O000BF08F1BC420E88B1AF23EF5981FD53D03053O00A14E9CEA7603103O0082BBCCD1A2B92ODDAB84D9D5B5BEDDCF03043O00BCC7D7A9030E3O00D9055A76EDF21D5E77CAF0084C6F03053O00889C693F1B025O00E6B14003193O001E807C391E826D3517B37B381A9F6D741D99773A1E8039664303043O00547BEC19025O00C2B24003093O00DC8ABC168EA0E298BE03063O00D590EBCA77CC03143O002F19C82B172158310BCA6A2E36432D1DD26A2O7A03073O002D4378BE4A4843025O0095B240025O00A2B140025O005EB140025O006CB140025O0058824003093O00B6D029E5A10CB64E8203083O0020E5A54781C47EDF025O00507D40025O00C06C4003133O00D09CCA8584C7CA87C3C187C0CD87C18DC1849503063O00B5A3E9A42OE1025O00C2A340025O00FAA840030A3O0076873F7A55B83678538003043O001730EB5E030D3O0051D5D449523DF36FC9D9485B2703073O00B21CBAB83D3753025O00405140025O0022A64003153O00C2C14631F731E6CCC24437B208E0CAC34230B25FA203073O0095A4AD275C926E025O00F0A140025O007CB140030A3O00D52B11121F28FB28131403063O007B9347707F7A03083O00EAC4907468C3DB8303053O0026ACADE211030E3O007D0325E2420328E64C1D1BEE5B1403043O008F2D714C03103O009EB41D31BD8B1433BBB33839BAAD1A3A03043O005C2OD87C03103O007D3EAD4DF8683AA343F67F37AE55FB5D03053O009D3B52CC20025O005AAF40025O0040AA4003153O003E32E2F7ECD5C0B9373DE8BAEFFFDDBF3D32A3ABB103083O00D1585E839A898AB303083O000EA8D679302C272303083O004248C1A41C7E435103103O00C120A9552345EF23AB530273E539AE5E03063O0016874CC83846025O00809540025O0010B24003133O008B39EA2162EF8226F9645BF4833EFD281DB0D403063O0081ED5098443D025O00F07340025O00889A40030B3O0062BC0BE111044C43A10FF603073O003831C864937C7703143O00E83BBAE0C0278DFFC32ABAF4E932BAFDC930ABE303043O0090AC5EDF025O0036B240025O0087B340025O006AAE40025O0054A84003153O00371BAD55291CB6552D04A707221AAC492103E2157403043O0027446FC20009082O00120E012O00014O0067000100013O002E4700023O0001000200046F3O0002000100261C012O00020001000100046F3O0002000100120E2O0100013O0026650001000B0001000300046F3O000B0001002E39010400870001000500046F3O008700012O00B900026O00E4000300013O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002003500013O00046F3O003500012O00B9000200023O0006350102003500013O00046F3O003500012O00B9000200033O0020090002000200094O00045O00202O00040004000A4O000500016O00020005000200062O0002002A0001000100046F3O002A00012O00B900026O007F000300013O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000D4O000200020002000E2O000E00350001000200046F3O003500012O00B9000200044O00B900035O00201B00030003000F2O00430102000200020006350102003500013O00046F3O003500012O00B9000200013O00120E010300103O00120E010400114O0002000200044O000701025O002E390112005C0001001300046F3O005C00012O00B900026O00E4000300013O00122O000400143O00122O000500156O0003000500024O00020002000300202O0002000200084O00020002000200062O0002005C00013O00046F3O005C00012O00B9000200053O0006350102005C00013O00046F3O005C00012O00B9000200063O0020EE0002000200164O00045O00202O0004000400174O00020004000200062O0002005C00013O00046F3O005C00012O00B9000200044O00B700035O00202O0003000300184O000400063O00202O0004000400194O00065O00202O0006000600184O0004000600024O000400046O00020004000200062O0002005C00013O00046F3O005C00012O00B9000200013O00120E0103001A3O00120E0104001B4O0002000200044O000701026O00B900026O00E4000300013O00122O0004001C3O00122O0005001D6O0003000500024O00020002000300202O0002000200084O00020002000200062O0002002O08013O00046F3O002O08012O00B9000200073O0006350102002O08013O00046F3O002O08012O00B900026O000C000300013O00122O0004001E3O00122O0005001F6O0003000500024O00020002000300202O0002000200204O00020002000200062O0002002O0801000100046F3O002O0801002E390121002O0801002200046F3O002O08012O00B9000200044O00B700035O00202O0003000300234O000400063O00202O0004000400194O00065O00202O0006000600234O0004000600024O000400046O00020004000200062O0002002O08013O00046F3O002O08012O00B9000200013O0012E9000300243O00122O000400256O000200046O00025O00044O002O080100261C2O01005B2O01002600046F3O005B2O0100120E010200014O0067000300033O00261C0102008B0001000100046F3O008B000100120E010300013O002665000300920001002700046F3O00920001002E470028004E0001002900046F3O00DE000100120E010400013O00261C010400D70001000100046F3O00D700012O00B900056O00E4000600013O00122O0007002A3O00122O0008002B6O0006000800024O00050005000600202O0005000500084O00050002000200062O000500A200013O00046F3O00A200012O00B9000500083O0006A2000500A40001000100046F3O00A40001002E82002C00B70001002D00046F3O00B70001002E82002E00B70001002F00046F3O00B700012O00B9000500044O00B700065O00202O0006000600304O000700063O00202O0007000700194O00095O00202O0009000900304O0007000900024O000700076O00050007000200062O000500B700013O00046F3O00B700012O00B9000500013O00120E010600313O00120E010700324O0002000500074O000701056O00B900056O00E4000600013O00122O000700333O00122O000800346O0006000800024O00050005000600202O0005000500084O00050002000200062O000500D600013O00046F3O00D600012O00B9000500093O000635010500D600013O00046F3O00D60001002E82003500D60001003600046F3O00D600012O00B9000500044O008C00065O00202O0006000600374O000700063O00202O00070007003800122O000900396O0007000900024O000700076O00050007000200062O000500D600013O00046F3O00D600012O00B9000500013O00120E0106003A3O00120E0107003B4O0002000500074O000701055O00120E010400273O002E39013C00930001003D00046F3O0093000100261C010400930001002700046F3O0093000100120E0103003E3O00046F3O00DE000100046F3O00930001002665000300E20001000100046F3O00E20001002E39013F00362O01004000046F3O00362O012O00B900046O00E4000500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O0004000400084O00040002000200062O000400032O013O00046F3O00032O012O00B90004000A3O000635010400032O013O00046F3O00032O012O00B900046O00E4000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400204O00040002000200062O000400032O013O00046F3O00032O012O00B9000400033O0020EE0004000400454O00065O00202O0006000600464O00040006000200062O000400032O013O00046F3O00032O012O00B90004000B3O000E4E002600052O01000400046F3O00052O01002E47004700120001004800046F3O00152O012O00B9000400044O008C00055O00202O0005000500494O000600063O00202O00060006003800122O000800396O0006000800024O000600066O00040006000200062O000400152O013O00046F3O00152O012O00B9000400013O00120E0105004A3O00120E0106004B4O0002000400064O000701046O00B900046O00E4000500013O00122O0006004C3O00122O0007004D6O0005000700024O00040004000500202O00040004004E4O00040002000200062O000400352O013O00046F3O00352O012O00B90004000C3O000635010400352O013O00046F3O00352O012O00B9000400044O00D500055O00202O00050005004F4O000600063O00202O0006000600194O00085O00202O00080008004F4O0006000800024O000600066O00040006000200062O000400302O01000100046F3O00302O01002E39015000352O01005100046F3O00352O012O00B9000400013O00120E010500523O00120E010600534O0002000400064O000701045O00120E010300273O00261C0103008E0001003E00046F3O008E00012O00B900046O00E4000500013O00122O000600543O00122O000700556O0005000700024O00040004000500202O0004000400084O00040002000200062O000400562O013O00046F3O00562O012O00B90004000D3O000635010400562O013O00046F3O00562O012O00B9000400044O00B700055O00202O0005000500564O000600063O00202O0006000600194O00085O00202O0008000800564O0006000800024O000600066O00040006000200062O000400562O013O00046F3O00562O012O00B9000400013O00120E010500573O00120E010600584O0002000400064O000701045O00120E2O0100393O00046F3O005B2O0100046F3O008E000100046F3O005B2O0100046F3O008B0001002E82005900C40201005A00046F3O00C40201000E41012700C40201000100046F3O00C4020100120E010200014O0067000300033O00261C010200612O01000100046F3O00612O0100120E010300013O000E152O0100682O01000300046F3O00682O01002E82005B00D42O01005C00046F3O00D42O0100120E010400013O002E39015D00CD2O01005E00046F3O00CD2O0100261C010400CD2O01000100046F3O00CD2O01002E39016000A52O01005F00046F3O00A52O012O00B900056O00E4000600013O00122O000700613O00122O000800626O0006000800024O00050005000600202O00050005004E4O00050002000200062O000500A52O013O00046F3O00A52O012O00B90005000C3O000635010500A52O013O00046F3O00A52O012O00B900056O00E4000600013O00122O000700633O00122O000800646O0006000800024O00050005000600202O0005000500204O00050002000200062O0005008D2O013O00046F3O008D2O012O00B9000500033O0020C40005000500654O00075O00202O0007000700664O000500070002000E2O002700942O01000500046F3O00942O012O00B9000500033O00206C0005000500654O00075O00202O0007000700674O00050007000200262O000500A52O01000300046F3O00A52O012O00B9000500044O00B700065O00202O00060006004F4O000700063O00202O0007000700194O00095O00202O00090009004F4O0007000900024O000700076O00050007000200062O000500A52O013O00046F3O00A52O012O00B9000500013O00120E010600683O00120E010700694O0002000500074O000701056O00B900056O00E4000600013O00122O0007006A3O00122O0008006B6O0006000800024O00050005000600202O0005000500084O00050002000200062O000500CC2O013O00046F3O00CC2O012O00B9000500083O000635010500CC2O013O00046F3O00CC2O012O00B9000500033O00206C0005000500654O00075O00202O0007000700674O00050007000200262O000500CC2O01000300046F3O00CC2O01002E82006C00CC2O01006D00046F3O00CC2O012O00B9000500044O00B700065O00202O0006000600304O000700063O00202O0007000700194O00095O00202O0009000900304O0007000900024O000700076O00050007000200062O000500CC2O013O00046F3O00CC2O012O00B9000500013O00120E0106006E3O00120E0107006F4O0002000500074O000701055O00120E010400273O002E82007000692O01007100046F3O00692O0100261C010400692O01002700046F3O00692O0100120E010300273O00046F3O00D42O0100046F3O00692O01002665000300D82O01003E00046F3O00D82O01002E39017300200201007200046F3O00200201002E390174001E0201007500046F3O001E02012O00B900046O00E4000500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O0004000400084O00040002000200062O0004001E02013O00046F3O001E02012O00B90004000E3O0006350104001E02013O00046F3O001E02012O00B9000400033O0020010004000400654O00065O00202O0006000600664O0004000600024O0005000F3O00122O000600396O000700106O00088O000900013O00122O000A00783O00122O000B00796O0009000B00024O00080008000900202O0008000800204O000800096O00073O000200102O0007003900074O0005000700024O000600113O00122O000700396O000800106O00098O000A00013O00122O000B00783O00122O000C00796O000A000C00024O00090009000A00202O0009000900204O0009000A6O00083O000200102O0008003900084O0006000800024O00050005000600062O0004001E0201000500046F3O001E02012O00B9000400044O00D500055O00202O00050005007A4O000600063O00202O0006000600194O00085O00202O00080008007A4O0006000800024O000600066O00040006000200062O000400190201000100046F3O00190201002E47007B00070001007C00046F3O001E02012O00B9000400013O00120E0105007D3O00120E0106007E4O0002000400064O000701045O00120E2O01003E3O00046F3O00C40201000E41012700642O01000300046F3O00642O012O00B900046O00E4000500013O00122O0006007F3O00122O000700806O0005000700024O00040004000500202O0004000400084O00040002000200062O0004005A02013O00046F3O005A02012O00B9000400123O0006350104005A02013O00046F3O005A02012O00B9000400033O0020300004000400654O00065O00202O0006000600664O0004000600024O000500106O00068O000700013O00122O000800813O00122O000900826O0007000900022O00F900060006000700201E0106000600204O000600076O00053O000200102O00050039000500102O00050039000500062O0004005A0201000500046F3O005A02012O00B9000400033O0020EE0004000400454O00065O00202O0006000600834O00040006000200062O0004005A02013O00046F3O005A02012O00B9000400044O00B700055O00202O0005000500844O000600063O00202O0006000600194O00085O00202O0008000800844O0006000800024O000600066O00040006000200062O0004005A02013O00046F3O005A02012O00B9000400013O00120E010500853O00120E010600864O0002000400064O000701046O00B900046O00E4000500013O00122O000600873O00122O000700886O0005000700024O00040004000500202O0004000400084O00040002000200062O000400C002013O00046F3O00C002012O00B9000400133O000635010400C002013O00046F3O00C002012O00B90004000F4O0031010500033O00202O0005000500654O00075O00202O0007000700894O0005000700024O000600106O000700033O00202O0007000700454O00095O00202O00090009008A4O000700096O00068O00043O00024O000500116O000600033O00202O0006000600654O00085O00202O0008000800894O0006000800024O000700106O000800033O00202O0008000800454O000A5O00202O000A000A008A4O0008000A6O00078O00053O00024O0004000400054O000500033O00202O0005000500654O00075O00202O00070007008B4O00050007000200062O000500C00201000400046F3O00C002012O00B9000400033O0020010004000400654O00065O00202O0006000600664O0004000600024O0005000F3O00122O000600396O000700106O00088O000900013O00122O000A008C3O00122O000B008D6O0009000B00024O00080008000900202O0008000800204O000800096O00073O000200102O0007003900074O0005000700024O000600113O00122O000700396O000800106O00098O000A00013O00122O000B008C3O00122O000C008D6O000A000C00024O00090009000A00202O0009000900204O0009000A6O00083O000200102O0008003900084O0006000800024O00050005000600062O000400C00201000500046F3O00C002012O00B9000400044O00B700055O00202O00050005008E4O000600063O00202O0006000600194O00085O00202O00080008008E4O0006000800024O000600066O00040006000200062O000400C002013O00046F3O00C002012O00B9000400013O00120E0105008F3O00120E010600904O0002000400064O000701045O00120E0103003E3O00046F3O00642O0100046F3O00C4020100046F3O00612O01002E47009100532O01009100046F3O0017040100261C2O0100170401003E00046F3O0017040100120E010200014O0067000300033O00261C010200CA0201000100046F3O00CA020100120E010300013O002665000300D10201000100046F3O00D10201002E820093006B0301009200046F3O006B030100120E010400013O002665000400D60201002700046F3O00D60201002E39019400D80201009500046F3O00D8020100120E010300273O00046F3O006B0301002665000400DC0201000100046F3O00DC0201002E82009600D20201009700046F3O00D202012O00B900056O00E4000600013O00122O000700983O00122O000800996O0006000800024O00050005000600202O0005000500084O00050002000200062O0005002F03013O00046F3O002F03012O00B90005000A3O0006350105002F03013O00046F3O002F03012O00B9000500033O0020BC0005000500454O00075O00202O00070007009A4O00050007000200062O0005001D0301000100046F3O001D03012O00B9000500033O0020BC0005000500094O00075O00202O00070007009B4O00050007000200062O0005001D0301000100046F3O001D03012O00B900056O00E4000600013O00122O0007009C3O00122O0008009D6O0006000800024O00050005000600202O0005000500204O00050002000200062O0005000C03013O00046F3O000C03012O00B9000500033O0020EE0005000500454O00075O00202O00070007009E4O00050007000200062O0005000C03013O00046F3O000C03012O00B9000500144O00770005000100020026650005001D0301000100046F3O001D03012O00B900056O00E4000600013O00122O0007009F3O00122O000800A06O0006000800024O00050005000600202O0005000500204O00050002000200062O0005002F03013O00046F3O002F03012O00B9000500033O0020960005000500654O00075O00202O0007000700674O00050007000200262O0005002F0301000300046F3O002F0301002E8200A2002F030100A100046F3O002F03012O00B9000500044O008C00065O00202O0006000600494O000700063O00202O00070007003800122O000900396O0007000900024O000700076O00050007000200062O0005002F03013O00046F3O002F03012O00B9000500013O00120E010600A33O00120E010700A44O0002000500074O000701055O002E8200A50069030100A600046F3O006903012O00B900056O00E4000600013O00122O000700A73O00122O000800A86O0006000800024O00050005000600202O0005000500084O00050002000200062O0005006903013O00046F3O006903012O00B9000500153O0006350105006903013O00046F3O006903012O00B9000500163O0006350105004403013O00046F3O004403012O00B9000500173O0006A2000500470301000100046F3O004703012O00B9000500163O0006A2000500690301000100046F3O006903012O00B9000500184O00B9000600193O000670000500690301000600046F3O006903012O00B9000500033O0020BC0005000500454O00075O00202O00070007009A4O00050007000200062O000500590301000100046F3O005903012O00B9000500033O0020620105000500A900122O000700AA3O00122O0008003E6O00050008000200062O0005006903013O00046F3O006903012O00B9000500044O008C00065O00202O0006000600AB4O000700063O00202O0007000700AC00122O000900396O0007000900024O000700076O00050007000200062O0005006903013O00046F3O006903012O00B9000500013O00120E010600AD3O00120E010700AE4O0002000500074O000701055O00120E010400273O00046F3O00D2020100261C010300A20301003E00046F3O00A20301002E3901AF00A0030100B000046F3O00A003012O00B900046O00E4000500013O00122O000600B13O00122O000700B26O0005000700024O00040004000500202O0004000400084O00040002000200062O000400A003013O00046F3O00A003012O00B9000400073O000635010400A003013O00046F3O00A003012O00B900046O00E4000500013O00122O000600B33O00122O000700B46O0005000700024O00040004000500202O0004000400204O00040002000200062O000400A003013O00046F3O00A003012O00B9000400033O0020EE0004000400454O00065O00202O0006000600B54O00040006000200062O000400A003013O00046F3O00A003012O00B9000400044O00D500055O00202O0005000500234O000600063O00202O0006000600194O00085O00202O0008000800234O0006000800024O000600066O00040006000200062O0004009B0301000100046F3O009B0301002E3901B600A0030100B700046F3O00A003012O00B9000400013O00120E010500B83O00120E010600B94O0002000400064O000701045O00120E2O0100BA3O00046F3O00170401002665000300A60301002700046F3O00A60301002E8200BC00CD020100BB00046F3O00CD02012O00B900046O00E4000500013O00122O000600BD3O00122O000700BE6O0005000700024O00040004000500202O0004000400084O00040002000200062O000400D203013O00046F3O00D203012O00B90004001A3O000635010400D203013O00046F3O00D203012O00B900046O0018010500013O00122O000600BF3O00122O000700C06O0005000700024O00040004000500202O0004000400C14O00040002000200262O000400D40301000300046F3O00D403012O00B900046O006C010500013O00122O000600C23O00122O000700C36O0005000700024O00040004000500202O0004000400C14O000400020002000E2O002600D20301000400046F3O00D203012O00B900046O0099000500013O00122O000600C43O00122O000700C56O0005000700024O00040004000500202O0004000400C14O0004000200024O0005000B3O00062O000500030001000400046F3O00D40301002E3901C600E1030100C700046F3O00E103012O00B9000400044O00B900055O00201B0005000500C82O00430104000200020006A2000400DC0301000100046F3O00DC0301002E8200C900E1030100CA00046F3O00E103012O00B9000400013O00120E010500CB3O00120E010600CC4O0002000400064O000701045O002E3901CD0013040100CE00046F3O001304012O00B900046O00E4000500013O00122O000600CF3O00122O000700D06O0005000700024O00040004000500202O0004000400084O00040002000200062O0004001304013O00046F3O001304012O00B9000400093O0006350104001304013O00046F3O001304012O00B900046O00E4000500013O00122O000600D13O00122O000700D26O0005000700024O00040004000500202O0004000400204O00040002000200062O0004001304013O00046F3O001304012O00B9000400033O0020EE0004000400094O00065O00202O0006000600D34O00040006000200062O0004001304013O00046F3O00130401002E3901D40013040100D500046F3O001304012O00B9000400044O008C00055O00202O0005000500374O000600063O00202O00060006003800122O000800396O0006000800024O000600066O00040006000200062O0004001304013O00046F3O001304012O00B9000400013O00120E010500D63O00120E010600D74O0002000400064O000701045O00120E0103003E3O00046F3O00CD020100046F3O0017040100046F3O00CA02010026650001001B0401000100046F3O001B0401002E3901D8009C050100D900046F3O009C0501002E4700DA006A000100DA00046F3O008504012O00B900026O00E4000300013O00122O000400DB3O00122O000500DC6O0003000500024O00020002000300202O0002000200084O00020002000200062O0002008504013O00046F3O008504012O00B90002000E3O0006350102008504013O00046F3O008504012O00B9000200063O0020220102000200DD4O00045O00202O0004000400174O0002000400024O0003000B3O00062O000300080001000200046F3O003904012O00B9000200063O00206C0002000200DD4O00045O00202O0004000400174O00020004000200262O000200850401000300046F3O008504012O00B9000200033O0020EE0002000200454O00045O00202O0004000400DE4O00020004000200062O0002008504013O00046F3O008504012O00B9000200033O0020010002000200654O00045O00202O0004000400664O0002000400024O0003000F3O00122O000400396O000500106O00068O000700013O00122O000800DF3O00122O000900E06O0007000900024O00060006000700202O0006000600204O000600076O00053O000200102O0005003900054O0003000500024O000400113O00122O000500396O000600106O00078O000800013O00122O000900DF3O00122O000A00E06O0008000A00024O00070007000800202O0007000700204O000700086O00063O000200102O0006003900064O0004000600024O00030003000400062O000200850401000300046F3O008504012O00B9000200033O0020BC0002000200094O00045O00202O0004000400E14O00020004000200062O000200740401000100046F3O007404012O00B9000200193O00266901020074040100E200046F3O007404012O00B9000200184O00B9000300033O0020020103000300E32O0043010300020002000651000200850401000300046F3O008504012O00B9000200044O00B700035O00202O00030003007A4O000400063O00202O0004000400194O00065O00202O00060006007A4O0004000600024O000400046O00020004000200062O0002008504013O00046F3O008504012O00B9000200013O00120E010300E43O00120E010400E54O0002000200044O000701026O00B900026O00E4000300013O00122O000400E63O00122O000500E76O0003000500024O00020002000300202O0002000200084O00020002000200062O000200C904013O00046F3O00C904012O00B90002000D3O000635010200C904013O00046F3O00C904012O00B900026O00E4000300013O00122O000400E83O00122O000500E96O0003000500024O00020002000300202O0002000200204O00020002000200062O000200B804013O00046F3O00B804012O00B9000200063O0020EE0002000200EA4O00045O00202O0004000400174O00020004000200062O000200B804013O00046F3O00B804012O00B900026O0025010300013O00122O000400EB3O00122O000500EC6O0003000500024O00020002000300202O0002000200C14O0002000200024O0003000B3O00062O000200B80401000300046F3O00B804012O00B900026O004C010300013O00122O000400ED3O00122O000500EE6O0003000500024O00020002000300202O0002000200C14O00020002000200262O000200CB0401000300046F3O00CB04012O00B900026O00E4000300013O00122O000400EF3O00122O000500F06O0003000500024O00020002000300202O0002000200204O00020002000200062O000200C904013O00046F3O00C904012O00B9000200033O0020880002000200654O00045O00202O0004000400F14O00020004000200262O000200CB0401003900046F3O00CB0401002E4700F20015000100F300046F3O00DE0401002E3901F400DE040100F500046F3O00DE04012O00B9000200044O00B700035O00202O0003000300564O000400063O00202O0004000400194O00065O00202O0006000600564O0004000600024O000400046O00020004000200062O000200DE04013O00046F3O00DE04012O00B9000200013O00120E010300F63O00120E010400F74O0002000200044O000701026O00B900026O00E4000300013O00122O000400F83O00122O000500F96O0003000500024O00020002000300202O00020002004E4O00020002000200062O0002001305013O00046F3O001305012O00B90002001B3O0006350102001305013O00046F3O001305012O00B90002001C3O000635010200F104013O00046F3O00F104012O00B9000200173O0006A2000200F40401000100046F3O00F404012O00B90002001C3O0006A2000200130501000100046F3O001305012O00B9000200184O00B9000300193O000670000200130501000300046F3O001305012O00B9000200033O0020EE0002000200094O00045O00202O0004000400DE4O00020004000200062O0002001305013O00046F3O001305012O00B90002001D3O0020550002000200FA4O00035O00202O0003000300FB4O0004001E6O0005001F6O000600063O00202O0006000600194O00085O00202O0008000800FB4O0006000800024O000600066O00020006000200062O0002001305013O00046F3O001305012O00B9000200013O00120E010300FC3O00120E010400FD4O0002000200044O000701026O00B900026O00E4000300013O00122O000400FE3O00122O000500FF6O0003000500024O00020002000300202O0002000200084O00020002000200062O0002004C05013O00046F3O004C05012O00B9000200053O0006350102004C05013O00046F3O004C05012O00B900026O000C000300013O00122O00042O00012O00122O0005002O015O0003000500024O00020002000300202O0002000200204O00020002000200062O000200340501000100046F3O003405012O00B900026O00E4000300013O00122O00040002012O00122O00050003015O0003000500024O00020002000300202O0002000200204O00020002000200062O0002004C05013O00046F3O004C05012O00B9000200063O0020EE0002000200164O00045O00202O0004000400174O00020004000200062O0002004C05013O00046F3O004C05012O00B9000200044O00B700035O00202O0003000300184O000400063O00202O0004000400194O00065O00202O0006000600184O0004000600024O000400046O00020004000200062O0002004C05013O00046F3O004C05012O00B9000200013O00120E01030004012O00120E01040005013O0002000200044O000701025O00120E01020006012O00120E01030007012O0006700002009B0501000300046F3O009B05012O00B900026O00E4000300013O00122O00040008012O00122O00050009015O0003000500024O00020002000300202O0002000200084O00020002000200062O0002009B05013O00046F3O009B05012O00B9000200203O0006350102009B05013O00046F3O009B05012O00B900026O00E4000300013O00122O0004000A012O00122O0005000B015O0003000500024O00020002000300202O0002000200204O00020002000200062O0002008405013O00046F3O008405012O00B900026O00E4000300013O00122O0004000C012O00122O0005000D015O0003000500024O00020002000300202O0002000200204O00020002000200062O0002009B05013O00046F3O009B05012O00B900026O0023010300013O00122O0004000E012O00122O0005000F015O0003000500024O00020002000300122O00040010015O0002000200044O0002000200024O000300213O00062O000200840501000300046F3O008405012O00B9000200033O0020EE0002000200454O00045O00202O00040004009E4O00020004000200062O0002009B05013O00046F3O009B05012O00B9000200044O004600035O00122O00040011015O0003000300044O000400063O00202O0004000400194O00065O00122O00070011015O0006000600074O0004000600024O000400044O00500102000400020006A2000200960501000100046F3O0096050100120E01020012012O00120E01030013012O0006700003009B0501000200046F3O009B05012O00B9000200013O00120E01030014012O00120E01040015013O0002000200044O000701025O00120E2O0100273O00120E010200393O0006AD000100B90601000200046F3O00B9060100120E010200013O00120E010300013O0006AD000200E80501000300046F3O00E805012O00B900036O00E4000400013O00122O00050016012O00122O00060017015O0004000600024O00030003000400202O0003000300084O00030002000200062O000300C005013O00046F3O00C005012O00B90003000A3O000635010300C005013O00046F3O00C005012O00B9000300044O008C00045O00202O0004000400494O000500063O00202O00050005003800122O000700396O0005000700024O000500056O00030005000200062O000300C005013O00046F3O00C005012O00B9000300013O00120E01040018012O00120E01050019013O0002000300054O000701036O00B900036O00E4000400013O00122O0005001A012O00122O0006001B015O0004000600024O00030003000400202O0003000300084O00030002000200062O000300E705013O00046F3O00E705012O00B90003001A3O000635010300E705013O00046F3O00E705012O00B900036O000A010400013O00122O0005001C012O00122O0006001D015O0004000600024O00030003000400202O0003000300C14O00030002000200122O0004003E3O00062O000400E70501000300046F3O00E705012O00B9000300044O00B900045O00201B0004000400C82O00430103000200020006A2000300E20501000100046F3O00E2050100120E0103001E012O00120E0104001F012O000670000300E70501000400046F3O00E705012O00B9000300013O00120E01040020012O00120E01050021013O0002000300054O000701035O00120E010200273O00120E0103003E3O0006AD0002001B0601000300046F3O001B06012O00B900036O00E4000400013O00122O00050022012O00122O00060023015O0004000600024O00030003000400202O0003000300084O00030002000200062O00032O0006013O00046F4O0006012O00B90003000E3O00063501032O0006013O00046F4O0006012O00B9000300033O00202E0103000300654O00055O00202O0005000500664O00030005000200122O000400393O00062O000400050001000300046F3O0004060100120E01030024012O00120E01040025012O000651000300190601000400046F3O0019060100120E01030026012O00120E01040027012O000651000400190601000300046F3O001906012O00B9000300044O00B700045O00202O00040004007A4O000500063O00202O0005000500194O00075O00202O00070007007A4O0005000700024O000500056O00030005000200062O0003001906013O00046F3O001906012O00B9000300013O00120E01040028012O00120E01050029013O0002000300054O000701035O00120E2O0100033O00046F3O00B9060100120E010300273O0006AD000200A00501000300046F3O00A005012O00B900036O00E4000400013O00122O0005002A012O00122O0006002B015O0004000600024O00030003000400202O0003000300084O00030002000200062O0003006906013O00046F3O006906012O00B9000300203O0006350103006906013O00046F3O006906012O00B900036O00E4000400013O00122O0005002C012O00122O0006002D015O0004000600024O00030003000400202O0003000300204O00030002000200062O0003005206013O00046F3O005206012O00B900036O00E4000400013O00122O0005002E012O00122O0006002F015O0004000600024O00030003000400202O0003000300204O00030002000200062O0003006906013O00046F3O006906012O00B900036O0023010400013O00122O00050030012O00122O00060031015O0004000600024O00030003000400122O00050010015O0003000300054O0003000200024O000400213O00062O000300520601000400046F3O005206012O00B9000300033O0020EE0003000300454O00055O00202O00050005009E4O00030005000200062O0003006906013O00046F3O006906012O00B9000300044O004600045O00122O00050011015O0004000400054O000500063O00202O0005000500194O00075O00122O00080011015O0007000700084O0005000700024O000500054O00500103000500020006A2000300640601000100046F3O0064060100120E010300503O00120E01040032012O000651000400690601000300046F3O006906012O00B9000300013O00120E01040033012O00120E01050034013O0002000300054O000701035O00120E01030035012O00120E01040035012O0006AD000300B70601000400046F3O00B706012O00B900036O00E4000400013O00122O00050036012O00122O00060037015O0004000600024O00030003000400202O0003000300084O00030002000200062O000300B706013O00046F3O00B706012O00B9000300133O000635010300B706013O00046F3O00B706012O00B90003000F4O0031010400033O00202O0004000400654O00065O00202O0006000600894O0004000600024O000500106O000600033O00202O0006000600454O00085O00202O00080008008A4O000600086O00058O00033O00024O000400116O000500033O00202O0005000500654O00075O00202O0007000700894O0005000700024O000600106O000700033O00202O0007000700454O00095O00202O00090009008A4O000700096O00068O00043O00024O0003000300044O000400033O00202O0004000400654O00065O00202O00060006008B4O00040006000200062O000400B70601000300046F3O00B706012O00B9000300033O0020750003000300654O00055O00202O0005000500664O00030005000200122O000400393O00062O000400B70601000300046F3O00B706012O00B9000300044O00B700045O00202O00040004008E4O000500063O00202O0005000500194O00075O00202O00070007008E4O0005000700024O000500056O00030005000200062O000300B706013O00046F3O00B706012O00B9000300013O00120E01040038012O00120E01050039013O0002000300054O000701035O00120E0102003E3O00046F3O00A0050100120E0102003A012O00120E0103003B012O000651000300070001000200046F3O0007000100120E010200BA3O0006AD000100070001000200046F3O0007000100120E010200013O00120E010300013O0006AD0002003C0701000300046F3O003C070100120E010300013O00120E0104003C012O00120E0105003D012O000651000400CE0601000500046F3O00CE060100120E010400273O0006AD000300CE0601000400046F3O00CE060100120E010200273O00046F3O003C070100120E010400013O0006AD000300C50601000400046F3O00C5060100120E010400503O00120E0105003E012O000651000500030701000400046F3O000307012O00B900046O00E4000500013O00122O0006003F012O00122O00070040015O0005000700024O00040004000500202O0004000400084O00040002000200062O0004000307013O00046F3O000307012O00B9000400153O0006350104000307013O00046F3O000307012O00B9000400163O000635010400E806013O00046F3O00E806012O00B9000400173O0006A2000400EB0601000100046F3O00EB06012O00B9000400163O0006A2000400030701000100046F3O000307012O00B9000400184O00B9000500193O000670000400030701000500046F3O0003070100120E01040041012O00120E01050042012O000651000500030701000400046F3O000307012O00B9000400044O008C00055O00202O0005000500AB4O000600063O00202O0006000600AC00122O000800396O0006000800024O000600066O00040006000200062O0004000307013O00046F3O000307012O00B9000400013O00120E01050043012O00120E01060044013O0002000400064O000701045O00120E01040045012O00120E01050046012O0006700004003A0701000500046F3O003A07012O00B900046O00E4000500013O00122O00060047012O00122O00070048015O0005000700024O00040004000500202O0004000400084O00040002000200062O0004003A07013O00046F3O003A07012O00B9000400053O0006350104003A07013O00046F3O003A07012O00B900046O00E4000500013O00122O00060049012O00122O0007004A015O0005000700024O00040004000500202O0004000400204O00040002000200062O0004003A07013O00046F3O003A07012O00B9000400063O0020EE0004000400164O00065O00202O0006000600174O00040006000200062O0004003A07013O00046F3O003A07012O00B9000400044O00D500055O00202O0005000500184O000600063O00202O0006000600194O00085O00202O0008000800184O0006000800024O000600066O00040006000200062O000400350701000100046F3O0035070100120E0104004B012O00120E0105004C012O0006510005003A0701000400046F3O003A07012O00B9000400013O00120E0105004D012O00120E0106004E013O0002000400064O000701045O00120E010300273O00046F3O00C5060100120E010300273O0006AD000200C80701000300046F3O00C8070100120E010300013O00120E0104004F012O00120E01050050012O000670000400BE0701000500046F3O00BE070100120E010400013O0006AD000300BE0701000400046F3O00BE07012O00B900046O00E4000500013O00122O00060051012O00122O00070052015O0005000700024O00040004000500202O0004000400084O00040002000200062O0004009607013O00046F3O009607012O00B9000400053O0006350104009607013O00046F3O009607012O00B900046O000C000500013O00122O00060053012O00122O00070054015O0005000700024O00040004000500202O0004000400204O00040002000200062O000400680701000100046F3O006807012O00B900046O00E4000500013O00122O00060055012O00122O00070056015O0005000700024O00040004000500202O0004000400204O00040002000200062O0004009607013O00046F3O009607012O00B900046O0025010500013O00122O00060057012O00122O00070058015O0005000700024O00040004000500202O0004000400C14O0004000200024O0005000B3O00062O000400960701000500046F3O009607012O00B900046O0053000500013O00122O00060059012O00122O0007005A015O0005000700024O00040004000500202O0004000400C14O00040002000200122O000500033O00062O000400960701000500046F3O009607012O00B90004001D3O00200F0104000400FA4O00055O00202O0005000500184O0006001E6O0007001F6O000800063O00202O0008000800194O000A5O00202O000A000A00184O0008000A00022O0054010800084O00500104000800020006A2000400910701000100046F3O0091070100120E0104005B012O00120E0105005C012O000670000400960701000500046F3O009607012O00B9000400013O00120E0105005D012O00120E0106005E013O0002000400064O000701046O00B900046O00E4000500013O00122O0006005F012O00122O00070060015O0005000700024O00040004000500202O0004000400084O00040002000200062O000400BD07013O00046F3O00BD07012O00B90004001A3O000635010400BD07013O00046F3O00BD07012O00B900046O000A010500013O00122O00060061012O00122O00070062015O0005000700024O00040004000500202O0004000400C14O00040002000200122O000500BA3O00062O000500BD0701000400046F3O00BD07012O00B9000400044O00B900055O00201B0005000500C82O00430104000200020006A2000400B80701000100046F3O00B8070100120E01040063012O00120E01050064012O000651000500BD0701000400046F3O00BD07012O00B9000400013O00120E01050065012O00120E01060066013O0002000400064O000701045O00120E010300273O00120E01040067012O00120E01050068012O000651000400400701000500046F3O0040070100120E010400273O0006AD000300400701000400046F3O0040070100120E0102003E3O00046F3O00C8070100046F3O0040070100120E0103003E3O0006AD000200C10601000300046F3O00C106012O00B900036O00E4000400013O00122O00050069012O00122O0006006A015O0004000600024O00030003000400202O0003000300084O00030002000200062O000300E907013O00046F3O00E907012O00B9000300083O000635010300E907013O00046F3O00E907012O00B9000300033O0020EE0003000300454O00055O00202O00050005009B4O00030005000200062O000300E907013O00046F3O00E907012O00B900036O000C000400013O00122O0005006B012O00122O0006006C015O0004000600024O00030003000400202O0003000300204O00030002000200062O000300ED0701000100046F3O00ED070100120E0103006D012O00120E0104006E012O000670000400020801000300046F3O000208012O00B9000300044O00D500045O00202O0004000400304O000500063O00202O0005000500194O00075O00202O0007000700304O0005000700024O000500056O00030005000200062O000300FD0701000100046F3O00FD070100120E0103006F012O00120E01040070012O000651000300020801000400046F3O000208012O00B9000300013O00120E01040071012O00120E01050072013O0002000300054O000701035O00120E2O0100263O00046F3O0007000100046F3O00C1060100046F3O0007000100046F3O002O080100046F3O000200012O00293O00017O00463O00028O00025O0031B240025O00789040026O00F03F025O00808640025O00E8A040025O00E88240025O0002B040025O00107540025O001C9C40030B3O00A8190859852B124488141E03043O002DED787A030A3O0049734361737461626C6503083O0042752O66446F776E030F3O004561727468536869656C6442752O66030C3O00F2E9B038DFA89124DEEDAE2803043O004CB788C2030E3O005FEAE0355541007BEACA2A52460003073O00741A868558302F030B3O004973417661696C61626C6503063O0042752O665570030F3O004C696768746E696E67536869656C64030B3O004561727468536869656C6403133O001BC0B2F0B54D0DC9A9E1B1765ECCA1EDB3324C03063O00127EA1C084DD030F3O007321A90C425121A003655721AB085203053O00363F48CE6403133O004C696768746E696E67536869656C6442752O6603103O00E4504272F175C157423AD673C15C497E03063O001BA839251A85030E3O0008A679A5D223BE7DA4F83FA875BC03053O00B74DCA1CC803173O001B3A8E00033D8006100C9A001E36850C573E88011973DB03043O00687753E9025O00A49040025O0008A240024O00804F2241030E3O00C2F1292645E0EA3E1546F4E8282C03053O002395984742030E3O0057696E6466757279576561706F6E03173O000EE14CB43C0CFA5B8F2D1CE952BF3459ED4CB33218E65603053O005A798822D0027O004003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B025O004C9540025O002BB040030F3O00416E6365737472616C537069726974030C3O00D3F09600F6ACD7C2E18C1AEA03073O00B2A195E57584DE030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O00FAA040025O00A88F40025O00DAB040025O00408040025O00049A40025O0060AF40025O00089140025O0044A940025O00B4A04003123O00E1025413C2004111C909401BF00B540EC80003043O007EA76E35025O0026A140025O00A2A34003123O00466C616D656E746F6E677565576561706F6E031A3O003B1C2FF5D92B321E29EDD9002A152FE8D3317D1520FBD43E330403063O005F5D704E98BC0054012O00120E012O00013O002E82000300A90001000200046F3O00A9000100261C012O00A90001000100046F3O00A9000100120E2O0100014O0067000200023O00261C2O0100070001000100046F3O0007000100120E010200013O0026650002000E0001000400046F3O000E0001002E82000600100001000500046F3O0010000100120E012O00043O00046F3O00A90001002E390107000A0001000800046F3O000A000100261C0102000A0001000100046F3O000A0001002E390109004E0001000A00046F3O004E00012O00B900035O0006350103004E00013O00046F3O004E00012O00B9000300014O00E4000400023O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003004E00013O00046F3O004E00012O00B9000300033O0020EE00030003000E4O000500013O00202O00050005000F4O00030005000200062O0003004E00013O00046F3O004E00012O00B9000300044O0003010400023O00122O000500103O00122O000600116O00040006000200062O000300420001000400046F3O004200012O00B9000300014O00E4000400023O00122O000500123O00122O000600136O0004000600024O00030003000400202O0003000300144O00030002000200062O0003004E00013O00046F3O004E00012O00B9000300033O0020EE0003000300154O000500013O00202O0005000500164O00030005000200062O0003004E00013O00046F3O004E00012O00B9000300054O00B9000400013O00201B0004000400172O00430103000200020006350103008500013O00046F3O008500012O00B9000300023O0012E9000400183O00122O000500196O000300056O00035O00044O008500012O00B900035O0006350103008500013O00046F3O008500012O00B9000300014O00E4000400023O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003008500013O00046F3O008500012O00B9000300033O0020EE00030003000E4O000500013O00202O00050005001C4O00030005000200062O0003008500013O00046F3O008500012O00B9000300044O0003010400023O00122O0005001D3O00122O0006001E6O00040006000200062O0003007A0001000400046F3O007A00012O00B9000300014O00E4000400023O00122O0005001F3O00122O000600206O0004000600024O00030003000400202O0003000300144O00030002000200062O0003008500013O00046F3O008500012O00B9000300033O0020EE0003000300154O000500013O00202O0005000500174O00030005000200062O0003008500013O00046F3O008500012O00B9000300054O00B9000400013O00201B0004000400162O00430103000200020006350103008500013O00046F3O008500012O00B9000300023O00120E010400213O00120E010500224O0002000300054O000701035O002E39012300A50001002400046F3O00A500012O00B9000300063O0006350103008D00013O00046F3O008D00012O00B9000300073O002628010300A50001002500046F3O00A500012O00B9000300083O000635010300A500013O00046F3O00A500012O00B9000300014O00E4000400023O00122O000500263O00122O000600276O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300A500013O00046F3O00A500012O00B9000300054O00B9000400013O00201B0004000400282O0043010300020002000635010300A500013O00046F3O00A500012O00B9000300023O00120E010400293O00120E0105002A4O0002000300054O000701035O00120E010200043O00046F3O000A000100046F3O00A9000100046F3O0007000100261C012O00052O01002B00046F3O00052O012O00B9000100093O0006352O0100D200013O00046F3O00D200012O00B9000100093O0020022O010001002C2O00432O01000200020006352O0100D200013O00046F3O00D200012O00B9000100093O0020022O010001002D2O00432O01000200020006352O0100D200013O00046F3O00D200012O00B9000100093O0020022O010001002E2O00432O01000200020006352O0100D200013O00046F3O00D200012O00B9000100033O0020022O010001002F2O00B9000300094O00502O01000300020006A2000100D20001000100046F3O00D20001002E39013000D20001003100046F3O00D200012O00B9000100054O00ED000200013O00202O0002000200324O000300036O000400016O00010004000200062O000100D200013O00046F3O00D200012O00B9000100023O00120E010200333O00120E010300344O0002000100034O00072O016O00B90001000A3O00201B0001000100352O00770001000100020006352O0100532O013O00046F3O00532O012O00B90001000B3O0006352O0100532O013O00046F3O00532O012O00B9000100033O0020022O01000100362O00432O01000200020006A2000100532O01000100046F3O00532O0100120E2O0100014O0067000200043O00261C2O0100FC0001000400046F3O00FC00012O0067000400043O002665000200E80001000400046F3O00E80001002E39013700F50001003800046F3O00F5000100261C010300E80001000100046F3O00E800012O00B90005000C4O00770005000100022O0072000400053O0006A2000400F10001000100046F3O00F10001002E82003900532O01003A00046F3O00532O012O0047010400023O00046F3O00532O0100046F3O00E8000100046F3O00532O0100261C010200E40001000100046F3O00E4000100120E010300014O0067000400043O00120E010200043O00046F3O00E4000100046F3O00532O01002E82003B00E10001003C00046F3O00E10001000E412O0100E10001000100046F3O00E1000100120E010200014O0067000300033O00120E2O0100043O00046F3O00E1000100046F3O00532O010026653O00092O01000400046F3O00092O01002E39013E00010001003D00046F3O0001000100120E2O0100013O00261C2O01000E2O01000400046F3O000E2O0100120E012O002B3O00046F3O00010001002E47003F00FCFF2O003F00046F3O000A2O0100261C2O01000A2O01000100046F3O000A2O0100120E010200013O00261C0102004C2O01000100046F3O004C2O012O00B90003000D3O0006350103001B2O013O00046F3O001B2O012O00B90003000E3O002628010300282O01002500046F3O00282O012O00B9000300083O000635010300282O013O00046F3O00282O012O00B9000300014O000C000400023O00122O000500403O00122O000600416O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003002A2O01000100046F3O002A2O01002E39014300352O01004200046F3O00352O012O00B9000300054O00B9000400013O00201B0004000400442O0043010300020002000635010300352O013O00046F3O00352O012O00B9000300023O00120E010400453O00120E010500464O0002000300054O000701036O00B90003000F3O0006350103004B2O013O00046F3O004B2O0100120E010300014O0067000400043O00261C0103003A2O01000100046F3O003A2O0100120E010400013O000E412O01003D2O01000400046F3O003D2O012O00B9000500114O00770005000100022O002A000500104O00B9000500103O0006350105004B2O013O00046F3O004B2O012O00B9000500104O0047010500023O00046F3O004B2O0100046F3O003D2O0100046F3O004B2O0100046F3O003A2O0100120E010200043O000E41010400132O01000200046F3O00132O0100120E2O0100043O00046F3O000A2O0100046F3O00132O0100046F3O000A2O0100046F3O000100012O00293O00017O00EA3O00028O00025O00A6A740025O00BAB040026O00F03F025O0006AA40025O00509D40025O00BCA740025O00D4A940025O00C09440025O00188240030F3O0048616E646C65412O666C696374656403143O00506F69736F6E436C65616E73696E67546F74656D026O003E40025O00406E40025O00249C4003093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O001440025O003CA540025O0088B240025O00088240025O005EA340025O00689F40025O0082AD40030C3O004865616C696E67537572676503153O004865616C696E6753757267654D6F7573656F766572026O004440025O0068A440025O00488A40025O000CA140025O00E09940030D3O00436C65616E736553706972697403163O00436C65616E73655370697269744D6F7573656F766572030B3O005472656D6F72546F74656D025O00588540025O00B0A040025O001CB240025O0072A440025O007FB240026O003840025O00F88440025O00A8A34003113O0048616E646C65496E636F72706F7265616C2O033O00486578030C3O004865784D6F7573654F766572025O00F88340025O0069B340025O008AA440027O0040025O00C08040025O00BEB040026O000840025O008AAB40026O007040025O00DEA54003053O00466F637573025O00588240025O0096AB40025O00F88040025O00F0B240026O006540025O00BCA340025O00F07540025O0004A840030C3O00AFC9D8ADB513B4139DC9DAA903083O0043E8BBBDCCC176C6030B3O004973417661696C61626C65030C3O00AC3CB0212F07FDBB3BA7273E03073O008FEB4ED5405B6203073O004973526561647903093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030C3O00477265617465725075726765030E3O0049735370652O6C496E52616E676503143O008A5A81E864B39F7794FC62B1880880E87DB78A4D03063O00D6ED28E48910026O001040025O007EAB40025O00F0A940025O00789840025O00BAA340030D3O00546172676574497356616C6964025O0016A140025O0078934003093O0039A685A6147013AD9903063O00197DC9EACB43030A3O0049734361737461626C65025O0030AE40025O00C07C4003093O00442O6F6D57696E6473030E3O004973496E4D656C2O6552616E676503113O007DFB170E2B301A77F00B4319261A77B44D03073O0073199478637447025O00F09940025O00149040025O00C0AA40025O00405640025O00508940025O0095B140026O002A40025O00E06B40025O001CA440025O0094A740025O00807340025O00A07240030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O003B1C901003053O00216C5DD94403133O00576169742F502O6F6C205265736F7572636573025O00A06940025O004FB040025O005C9C40025O00F49940025O00E07240025O00F6A540025O00809D40025O00D88240025O00BBB240025O00A9B240025O0019B34003093O00DC3BF9B8E09CEB25EF03063O00DA9E5796D784030A3O00DA0DDAE73826CCF51DDC03073O00AD9B7EB982564203063O0042752O665570030E3O00417363656E64616E636542752O66030A3O00C4B5B9C286E8E4A8B9C203063O008C85C6DAA7E8030F3O00432O6F6C646F776E52656D61696E73026O004940025O0024AA40025O00309640025O00E4A240025O008EA14003093O00426C2O6F644675727903113O00B722BB72808A28A16F9DF53CB57E8DB42203053O00E4D54ED41D025O00BEAA40025O00E6A740030A3O00A549A416EE9547BF0BEC03053O008BE72CD665030A3O00F8FC055B1EB53018DAEA03083O0076B98F663E70D151025O0092A440025O00489140030A3O004265727365726B696E6703113O005E753BF5A0071731527769F4A41615395003083O00583C104986C5757C03093O0076E3EACD435CE5F7CC03053O0021308A98A8030A3O0053053354CF337318335403063O005712765031A1030A3O006D0DD9A5BE481FD4A3B503053O00D02C7EBAC003093O0046697265626C2O6F64025O0030AF40025O00A0AA4003103O00F113B6C316F0C641F35AB6C717F5C84203083O002E977AC4A6749CA9030D3O00C4E3451FE8F1FF4716D8E4E14A03053O009B858D267A030A3O000439AF44417BA42B29A903073O00C5454ACC212F1F030A3O00D15C5982FE4B5B89F34A03043O00E7902F3A025O00AAAB40025O008EA040030D3O00416E6365737472616C43612O6C03153O00B3D6D9700B29DD38BEE7D97414318F2BB3DBD3741403083O0059D2B8BA15785DAF025O00D07E40025O00F6AC40025O00CDB140025O0058A740030F3O0048616E646C65445053506F74696F6E030F3O00466572616C53706972697442752O66025O0012A640025O0076A840030B3O00FEEDEE4C4D82C8E1EE445503063O00D1B8889C2D21025O00ECAC40025O00709340030B3O00466572616C53706972697403133O0001CD6709B438DB6501AA0EDC3505B90EC6355B03053O00D867A81568030A3O0059BE40A176A942AA7BA803043O00C418CD2303083O00446562752O66557003103O00466C616D6553686F636B446562752O66030E3O000282E40E3A85EA0829CBC109229F03043O00664EEB83030F3O00D926354D49799B3DFD26204A4E37B003083O00549A4E54242759D7025O00749040025O00709F40030A3O00417363656E64616E636503113O00FCF2555D0BF9E0585B00BDEC57510BBDB503053O00659D813638025O0065B140025O0063B340030A3O00865A72D16A2EA35A77D003063O005AD1331CB519030A3O0057696E64737472696B6503113O00C77259EAACC4695EE5BA907656E7B1902A03053O00DFB01B378E030E3O0014A9C7B82BA9CABC25B7F9B432BE03043O00D544DBAE03073O0048617354696572026O003F40025O0080AE40025O00D1B240030E3O005072696D6F726469616C57617665025O00DC9540025O0034984003163O001BF22AEA25D73B760AEC1CF02BD33A3F06E12AE96A9703083O001F6B8043874AA55F025O0048AE40025O00E49140025O00B0A14003053O00B5F6FDDE0603063O00C6E5838FB963025O00A2AB40025O00E5B14003053O005075726765030C3O004199BA7454CCAC725C8DAF7603043O001331ECC8025O0035B040025O00E07F40026O009740025O0048AB40025O00406040025O00B49D400071042O00120E012O00014O0067000100013O002E39010200020001000300046F3O0002000100261C012O00020001000100046F3O0002000100120E2O0100013O00261C2O0100F10001000400046F3O00F1000100120E010200013O00261C010200EA0001000100046F3O00EA00012O00B900035O000635010300BB00013O00046F3O00BB000100120E010300014O0067000400053O00261C010300160001000100046F3O0016000100120E010400014O0067000500053O00120E010300043O0026650003001A0001000400046F3O001A0001002E82000500110001000600046F3O0011000100261C0104001A0001000100046F3O001A000100120E010500013O002E39010700770001000800046F3O0077000100261C010500770001000400046F3O007700012O00B9000600013O0006A2000600260001000100046F3O00260001002E39010900410001000A00046F3O0041000100120E010600014O0067000700073O00261C010600280001000100046F3O0028000100120E010700013O000E412O01002B0001000700046F3O002B00012O00B9000800033O00203800080008000B4O000900043O00202O00090009000C4O000A00043O00202O000A000A000C00122O000B000D6O0008000B00024O000800026O000800023O00062O0008003B0001000100046F3O003B0001002E39010F00410001000E00046F3O004100012O00B9000800024O0047010800023O00046F3O0041000100046F3O002B000100046F3O0041000100046F3O002800012O00B9000600053O0020E30006000600104O000800043O00202O0008000800114O000600080002000E2O001200BB0001000600046F3O00BB00012O00B9000600063O000635010600BB00013O00046F3O00BB000100120E010600014O0067000700083O002E820013006E0001001400046F3O006E000100261C0106006E0001000400046F3O006E0001002E82001500510001001600046F3O0051000100261C010700510001000100046F3O0051000100120E010800013O0026650008005A0001000100046F3O005A0001002E82001800560001001700046F3O005600012O00B9000900033O00200B00090009000B4O000A00043O00202O000A000A00194O000B00073O00202O000B000B001A00122O000C001B6O000D00016O0009000D00024O000900026O000900023O00062O000900BB00013O00046F3O00BB00012O00B9000900024O0047010900023O00046F3O00BB000100046F3O0056000100046F3O00BB000100046F3O0051000100046F3O00BB0001002E39011D004D0001001C00046F3O004D0001000E412O01004D0001000600046F3O004D000100120E010700014O0067000800083O00120E010600043O00046F3O004D000100046F3O00BB000100261C0105001D0001000100046F3O001D00012O00B9000600083O0006A20006007E0001000100046F3O007E0001002E39011E00970001001F00046F3O0097000100120E010600014O0067000700073O00261C010600800001000100046F3O0080000100120E010700013O00261C010700830001000100046F3O008300012O00B9000800033O00202C00080008000B4O000900043O00202O0009000900204O000A00073O00202O000A000A002100122O000B001B6O0008000B00024O000800026O000800023O00062O0008009700013O00046F3O009700012O00B9000800024O0047010800023O00046F3O0097000100046F3O0083000100046F3O0097000100046F3O008000012O00B9000600093O000635010600B500013O00046F3O00B5000100120E010600014O0067000700073O00261C0106009C0001000100046F3O009C000100120E010700013O00261C0107009F0001000100046F3O009F00012O00B9000800033O00203800080008000B4O000900043O00202O0009000900224O000A00043O00202O000A000A002200122O000B000D6O0008000B00024O000800026O000800023O00062O000800AF0001000100046F3O00AF0001002E47002300080001002400046F3O00B500012O00B9000800024O0047010800023O00046F3O00B5000100046F3O009F000100046F3O00B5000100046F3O009C000100120E010500043O00046F3O001D000100046F3O00BB000100046F3O001A000100046F3O00BB000100046F3O001100012O00B90003000A3O0006A2000300C00001000100046F3O00C00001002E82002500E90001002600046F3O00E9000100120E010300014O0067000400053O00261C010300E30001000400046F3O00E30001002665000400C80001000100046F3O00C80001002E47002700FEFF2O002800046F3O00C4000100120E010500013O002E39012900C90001002A00046F3O00C9000100261C010500C90001000100046F3O00C900012O00B9000600033O00203401060006002B4O000700043O00202O00070007002C4O000800073O00202O00080008002D00122O0009000D6O000A00016O0006000A00024O000600023O002E2O002E00120001002E00046F3O00E900012O00B9000600023O000635010600E900013O00046F3O00E900012O00B9000600024O0047010600023O00046F3O00E9000100046F3O00C9000100046F3O00E9000100046F3O00C4000100046F3O00E90001000E412O0100C20001000300046F3O00C2000100120E010400014O0067000500053O00120E010300043O00046F3O00C2000100120E010200043O000E15010400EE0001000200046F3O00EE0001002E39012F000A0001003000046F3O000A000100120E2O0100313O00046F3O00F1000100046F3O000A0001002665000100F50001003100046F3O00F50001002E82003300692O01003200046F3O00692O0100120E010200013O00261C010200FA0001000400046F3O00FA000100120E2O0100343O00046F3O00692O01002E39013600F60001003500046F3O00F6000100261C010200F60001000100046F3O00F6000100120E010300013O002E47003700060001003700046F3O00052O01000E41010400052O01000300046F3O00052O0100120E010200043O00046F3O00F6000100261C010300FF0001000100046F3O00FF00010012D4000400383O000635010400262O013O00046F3O00262O012O00B90004000B3O0006A20004000F2O01000100046F3O000F2O01002E39013A00262O01003900046F3O00262O0100120E010400014O0067000500053O002665000400152O01000100046F3O00152O01002E47003B00FEFF2O003C00046F3O00112O0100120E010500013O000E412O0100162O01000500046F3O00162O012O00B90006000C4O00770006000100022O002A000600023O002E39013D00262O01003E00046F3O00262O012O00B9000600023O000635010600262O013O00046F3O00262O012O00B9000600024O0047010600023O00046F3O00262O0100046F3O00162O0100046F3O00262O0100046F3O00112O01002E82003F00662O01004000046F3O00662O012O00B9000400044O00E40005000D3O00122O000600413O00122O000700426O0005000700024O00040004000500202O0004000400434O00040002000200062O000400662O013O00046F3O00662O012O00B90004000E3O000635010400662O013O00046F3O00662O012O00B9000400044O00E40005000D3O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400464O00040002000200062O000400662O013O00046F3O00662O012O00B90004000F3O000635010400662O013O00046F3O00662O012O00B9000400103O000635010400662O013O00046F3O00662O012O00B9000400053O0020020104000400472O00430104000200020006A2000400662O01000100046F3O00662O012O00B9000400053O0020020104000400482O00430104000200020006A2000400662O01000100046F3O00662O012O00B9000400033O00201B0004000400492O00B9000500114O0043010400020002000635010400662O013O00046F3O00662O012O00B9000400124O00B7000500043O00202O00050005004A4O000600113O00202O00060006004B4O000800043O00202O00080008004A4O0006000800024O000600066O00040006000200062O000400662O013O00046F3O00662O012O00B90004000D3O00120E0105004C3O00120E0106004D4O0002000400064O000701045O00120E010300043O00046F3O00FF000100046F3O00F600010026650001006D2O01004E00046F3O006D2O01002E82004F000C0401005000046F3O000C0401002E39015100742O01005200046F3O00742O012O00B9000200023O000635010200742O013O00046F3O00742O012O00B9000200024O0047010200024O00B9000200033O00201B0002000200532O00770002000100020006350102007004013O00046F3O0070040100120E010200014O0067000300043O0026650002007F2O01000400046F3O007F2O01002E39015400050401005500046F3O00050401000E41013100FD2O01000300046F3O00FD2O012O00B9000500044O00E40006000D3O00122O000700563O00122O000800576O0006000800024O00050005000600202O0005000500584O00050002000200062O0005009B2O013O00046F3O009B2O012O00B9000500133O0006350105009B2O013O00046F3O009B2O012O00B9000500143O000635010500942O013O00046F3O00942O012O00B9000500153O0006A2000500972O01000100046F3O00972O012O00B9000500143O0006A20005009B2O01000100046F3O009B2O012O00B9000500164O00B9000600173O0006A60005009D2O01000600046F3O009D2O01002E47005900120001005A00046F3O00AD2O012O00B9000500124O008C000600043O00202O00060006005B4O000700113O00202O00070007005C00122O000900126O0007000900024O000700076O00050007000200062O000500AD2O013O00046F3O00AD2O012O00B90005000D3O00120E0106005D3O00120E0107005E4O0002000500074O000701056O00B9000500183O00261C010500D82O01000400046F3O00D82O01002E39015F00B32O01006000046F3O00B32O0100046F3O00D82O0100120E010500014O0067000600083O002665000500B92O01000100046F3O00B92O01002E39016100BC2O01006200046F3O00BC2O0100120E010600014O0067000700073O00120E010500043O00261C010500B52O01000400046F3O00B52O012O0067000800083O00261C010600CE2O01000400046F3O00CE2O0100261C010700C12O01000100046F3O00C12O012O00B9000900194O00770009000100022O0072000800093O002E82006300D82O01006400046F3O00D82O01000635010800D82O013O00046F3O00D82O012O0047010800023O00046F3O00D82O0100046F3O00C12O0100046F3O00D82O01002665000600D22O01000100046F3O00D22O01002E82006600BF2O01006500046F3O00BF2O0100120E010700014O0067000800083O00120E010600043O00046F3O00BF2O0100046F3O00D82O0100046F3O00B52O012O00B90005001A3O000635010500DE2O013O00046F3O00DE2O012O00B9000500183O000EA8000400E02O01000500046F3O00E02O01002E47006700100001006800046F3O00EE2O0100120E010500014O0067000600063O00261C010500E22O01000100046F3O00E22O012O00B90007001B4O00770007000100022O0072000600073O0006A2000600EB2O01000100046F3O00EB2O01002E39016900EE2O01006A00046F3O00EE2O012O0047010600023O00046F3O00EE2O0100046F3O00E22O012O00B90005001C3O00204F01050005006B4O000600043O00202O00060006006C4O00078O0008000D3O00122O0009006D3O00122O000A006E6O0008000A6O00053O000200062O0005007004013O00046F3O0070040100120E0105006F4O0047010500023O00046F3O0070040100261C010300300301000100046F3O0030030100120E010500013O002665000500040201000400046F3O00040201002E390171000E0301007000046F3O000E03012O00B9000600164O00B9000700173O0006BD000700320001000600046F3O00390201002E47007200030001007300046F3O000B020100046F3O003902012O00B90006001D3O0006350106001702013O00046F3O001702012O00B9000600153O0006350106001402013O00046F3O001402012O00B90006001E3O0006A2000600190201000100046F3O001902012O00B90006001E3O0006350106001902013O00046F3O00190201002E39017500390201007400046F3O0039020100120E010600014O0067000700083O00261C010600310201000400046F3O0031020100261C0107001D0201000100046F3O001D020100120E010800013O000E412O0100200201000800046F3O002002012O00B90009001F4O00770009000100022O002A000900023O002E82007700390201007600046F3O003902012O00B9000900023O0006350109003902013O00046F3O003902012O00B9000900024O0047010900023O00046F3O0039020100046F3O0020020100046F3O0039020100046F3O001D020100046F3O00390201002E47007800EAFF2O007800046F3O001B020100261C0106001B0201000100046F3O001B020100120E010700014O0067000800083O00120E010600043O00046F3O001B02012O00B9000600164O00B9000700173O000670000600490201000700046F3O004902012O00B9000600203O0006350106004902013O00046F3O004902012O00B9000600213O0006350106004602013O00046F3O004602012O00B9000600153O0006A20006004B0201000100046F3O004B02012O00B9000600213O0006350106004B02013O00046F3O004B0201002E39017A000D0301007900046F3O000D03012O00B9000600044O00E40007000D3O00122O0008007B3O00122O0009007C6O0007000900024O00060006000700202O0006000600584O00060002000200062O0006007002013O00046F3O007002012O00B9000600044O00E40007000D3O00122O0008007D3O00122O0009007E6O0007000900024O00060006000700202O0006000600434O00060002000200062O0006007202013O00046F3O007202012O00B9000600053O0020BC00060006007F4O000800043O00202O0008000800804O00060008000200062O000600720201000100046F3O007202012O00B9000600044O00050107000D3O00122O000800813O00122O000900826O0007000900024O00060006000700202O0006000600834O000600020002000E2O008400720201000600046F3O00720201002E390185007F0201008600046F3O007F0201002E820088007F0201008700046F3O007F02012O00B9000600124O00B9000700043O00201B0007000700892O00430106000200020006350106007F02013O00046F3O007F02012O00B90006000D3O00120E0107008A3O00120E0108008B4O0002000600084O000701065O002E82008D00A90201008C00046F3O00A902012O00B9000600044O00E40007000D3O00122O0008008E3O00122O0009008F6O0007000900024O00060006000700202O0006000600584O00060002000200062O000600A902013O00046F3O00A902012O00B9000600044O00E40007000D3O00122O000800903O00122O000900916O0007000900024O00060006000700202O0006000600434O00060002000200062O0006009C02013O00046F3O009C02012O00B9000600053O0020EE00060006007F4O000800043O00202O0008000800804O00060008000200062O000600A902013O00046F3O00A90201002E82009300A90201009200046F3O00A902012O00B9000600124O00B9000700043O00201B0007000700942O0043010600020002000635010600A902013O00046F3O00A902012O00B90006000D3O00120E010700953O00120E010800964O0002000600084O000701066O00B9000600044O00E40007000D3O00122O000800973O00122O000900986O0007000900024O00060006000700202O0006000600584O00060002000200062O000600DB02013O00046F3O00DB02012O00B9000600044O00E40007000D3O00122O000800993O00122O0009009A6O0007000900024O00060006000700202O0006000600434O00060002000200062O000600CE02013O00046F3O00CE02012O00B9000600053O0020BC00060006007F4O000800043O00202O0008000800804O00060008000200062O000600CE0201000100046F3O00CE02012O00B9000600044O007F0007000D3O00122O0008009B3O00122O0009009C6O0007000900024O00060006000700202O0006000600834O000600020002000E2O008400DB0201000600046F3O00DB02012O00B9000600124O00B9000700043O00201B00070007009D2O00430106000200020006A2000600D60201000100046F3O00D60201002E39019E00DB0201009F00046F3O00DB02012O00B90006000D3O00120E010700A03O00120E010800A14O0002000600084O000701066O00B9000600044O00E40007000D3O00122O000800A23O00122O000900A36O0007000900024O00060006000700202O0006000600584O00060002000200062O00062O0003013O00046F4O0003012O00B9000600044O00E40007000D3O00122O000800A43O00122O000900A56O0007000900024O00060006000700202O0006000600434O00060002000200062O0006000203013O00046F3O000203012O00B9000600053O0020BC00060006007F4O000800043O00202O0008000800804O00060008000200062O000600020301000100046F3O000203012O00B9000600044O00050107000D3O00122O000800A63O00122O000900A76O0007000900024O00060006000700202O0006000600834O000600020002000E2O008400020301000600046F3O00020301002E3901A8000D030100A900046F3O000D03012O00B9000600124O00B9000700043O00201B0007000700AA2O00430106000200020006350106000D03013O00046F3O000D03012O00B90006000D3O00120E010700AB3O00120E010800AC4O0002000600084O000701065O00120E010500313O002665000500120301003100046F3O00120301002E3901AE0014030100AD00046F3O0014030100120E010300043O00046F3O00300301002E8200B02O00020100AF00046F4O00020100261C01052O000201000100046F4O00020100120E010600013O000E412O0100280301000600046F3O002803012O00B9000700033O00201A0007000700B14O000800053O00202O00080008007F4O000A00043O00202O000A000A00B24O0008000A6O00073O00024O000400073O00062O0004002703013O00046F3O002703012O0047010400023O00120E010600043O000E150104002C0301000600046F3O002C0301002E4700B300EFFF2O00B400046F3O0019030100120E010500043O00046F4O00020100046F3O0019030100046F4O000201000E410104007F2O01000300046F3O007F2O0100120E010500014O0067000600063O00261C010500340301000100046F3O0034030100120E010600013O00261C0106003B0301003100046F3O003B030100120E010300313O00046F3O007F2O0100261C010600A70301000400046F3O00A703012O00B9000700044O00E40008000D3O00122O000900B53O00122O000A00B66O0008000A00024O00070007000800202O0007000700584O00070002000200062O0007006403013O00046F3O006403012O00B9000700223O0006350107006403013O00046F3O006403012O00B9000700233O0006350107005003013O00046F3O005003012O00B9000700153O0006A2000700530301000100046F3O005303012O00B9000700233O0006A2000700640301000100046F3O006403012O00B9000700164O00B9000800173O000670000700640301000800046F3O00640301002E3901B80064030100B700046F3O006403012O00B9000700124O00B9000800043O00201B0008000800B92O00430107000200020006350107006403013O00046F3O006403012O00B90007000D3O00120E010800BA3O00120E010900BB4O0002000700094O000701076O00B9000700044O00E40008000D3O00122O000900BC3O00122O000A00BD6O0008000A00024O00070007000800202O0007000700584O00070002000200062O000700A603013O00046F3O00A603012O00B9000700243O000635010700A603013O00046F3O00A603012O00B9000700253O0006350107007703013O00046F3O007703012O00B9000700153O0006A20007007A0301000100046F3O007A03012O00B9000700253O0006A2000700A60301000100046F3O00A603012O00B9000700164O00B9000800173O000670000700A60301000800046F3O00A603012O00B9000700113O0020EE0007000700BE4O000900043O00202O0009000900BF4O00070009000200062O000700A603013O00046F3O00A603012O00B9000700264O00A10008000D3O00122O000900C03O00122O000A00C16O0008000A000200062O0007008F0301000800046F3O008F03012O00B9000700183O002665000700990301000400046F3O009903012O00B9000700264O00A10008000D3O00122O000900C23O00122O000A00C36O0008000A000200062O000700A60301000800046F3O00A603012O00B9000700183O000EB4000400A60301000700046F3O00A60301002E8200C400A6030100C500046F3O00A603012O00B9000700124O00B9000800043O00201B0008000800C62O0043010700020002000635010700A603013O00046F3O00A603012O00B90007000D3O00120E010800C73O00120E010900C84O0002000700094O000701075O00120E010600313O002665000600AB0301000100046F3O00AB0301002E8200CA0037030100C900046F3O003703012O00B9000700044O00E40008000D3O00122O000900CB3O00122O000A00CC6O0008000A00024O00070007000800202O0007000700584O00070002000200062O000700C903013O00046F3O00C903012O00B9000700273O000635010700C903013O00046F3O00C903012O00B9000700124O00B7000800043O00202O0008000800CD4O000900113O00202O00090009004B4O000B00043O00202O000B000B00CD4O0009000B00024O000900096O00070009000200062O000700C903013O00046F3O00C903012O00B90007000D3O00120E010800CE3O00120E010900CF4O0002000700094O000701076O00B9000700044O00E40008000D3O00122O000900D03O00122O000A00D16O0008000A00024O00070007000800202O0007000700584O00070002000200062O000700EA03013O00046F3O00EA03012O00B9000700283O000635010700EA03013O00046F3O00EA03012O00B9000700293O000635010700DC03013O00046F3O00DC03012O00B90007002A3O0006A2000700DF0301000100046F3O00DF03012O00B9000700293O0006A2000700EA0301000100046F3O00EA03012O00B9000700164O00B9000800173O000670000700EA0301000800046F3O00EA03012O00B9000700053O00205E0107000700D200122O000900D33O00122O000A00316O0007000A000200062O000700EC0301000100046F3O00EC0301002E4700D40015000100D500046F3O00FF03012O00B9000700124O00D5000800043O00202O0008000800D64O000900113O00202O00090009004B4O000B00043O00202O000B000B00D64O0009000B00024O000900096O00070009000200062O000700FA0301000100046F3O00FA0301002E3901D800FF030100D700046F3O00FF03012O00B90007000D3O00120E010800D93O00120E010900DA4O0002000700094O000701075O00120E010600043O00046F3O0037030100046F3O007F2O0100046F3O0034030100046F3O007F2O0100046F3O0070040100261C0102007B2O01000100046F3O007B2O0100120E010300014O0067000400043O00120E010200043O00046F3O007B2O0100046F3O00700401002E4700DB004A000100DB00046F3O0056040100261C2O0100560401003400046F3O0056040100120E010200013O002665000200150401000100046F3O00150401002E3901DD004F040100DC00046F3O004F04012O00B9000300044O00E40004000D3O00122O000500DE3O00122O000600DF6O0004000600024O00030003000400202O0003000300464O00030002000200062O0003003804013O00046F3O003804012O00B90003000E3O0006350103003804013O00046F3O003804012O00B90003000F3O0006350103003804013O00046F3O003804012O00B9000300103O0006350103003804013O00046F3O003804012O00B9000300053O0020020103000300472O00430103000200020006A2000300380401000100046F3O003804012O00B9000300053O0020020103000300482O00430103000200020006A2000300380401000100046F3O003804012O00B9000300033O00201B0003000300492O00B9000400114O00430103000200020006A20003003A0401000100046F3O003A0401002E3901E1004B040100E000046F3O004B04012O00B9000300124O00B7000400043O00202O0004000400E24O000500113O00202O00050005004B4O000700043O00202O0007000700E24O0005000700024O000500056O00030005000200062O0003004B04013O00046F3O004B04012O00B90003000D3O00120E010400E33O00120E010500E44O0002000300054O000701036O00B90003002B4O00770003000100022O002A000300023O00120E010200043O002E8200E60011040100E500046F3O0011040100261C010200110401000400046F3O0011040100120E2O01004E3O00046F3O0056040100046F3O001104010026650001005A0401000100046F3O005A0401002E8200E80007000100E700046F3O0007000100120E010200013O00261C010200680401000100046F3O006804012O00B90003002C4O00770003000100022O002A000300024O00B9000300023O0006A2000300650401000100046F3O00650401002E8200EA0067040100E900046F3O006704012O00B9000300024O0047010300023O00120E010200043O00261C0102005B0401000400046F3O005B040100120E2O0100043O00046F3O0007000100046F3O005B040100046F3O0007000100046F3O0070040100046F3O000200012O00293O00017O00923O00028O00026O00F03F025O0004A440025O006AAD40026O001840025O002C9A40025O00507340025O00B2A640025O00308E40030C3O004570696353652O74696E677303083O009B863C967D2O76BB03073O0011C8E348E2141803103O00A5521EE0CCF0FFF0BE6415D4C1F0E1EB03083O009FD0217BB7A9918F03083O00C15F2C22FB543F2503043O0056923A5803103O0059CCE9C5A0ED37F45BDADDC9BAE115DE03083O009A38BF8AA0CE8956025O0094A140025O0088984003083O00B55CE193753486DF03083O00ACE63995E71C5AE1030F3O0006A589DF1FD20CAE95E521CF0A89A203063O00BB62CAE6B248026O001C40025O0046A540026O000840025O00AEA040025O002O7040025O00909F4003083O00EF5AD8A52615E0F203083O0081BC3FACD14F7B87030B3O0055F7E3E141F2E7E141F7EE03043O00AD208486026O001040025O00606540025O003C9040025O0054A340025O0078A140026O00A340025O0048924003083O00E9A36156D3A8725103043O0022BAC615030C3O00ED1BC074C1FD3BD14FCBF30D03053O00A29868A53D03083O00FE2AA66979EBCA3C03063O0085AD4FD21D10030C3O00986FE8078C6AEC09986EFE3F03043O004BED1C8D025O00B49040025O0098B240026O001440025O00B9B240025O00A4A94003083O000100E5EAF73C02E203053O009E5265919E030C3O0065ED0725517EFA07044D7EF903053O0024109E627603083O00F313D7EF51E620F603083O0085A076A39B388847030D3O00E3B174C5BF11B1E5B663FBBD1A03073O00D596C21192D67F03083O0028ACB0C04FAAA52503083O00567BC9C4B426C4C203103O00E2FBDC98FEE6DDA9E2FAC09BF8FCDCA203043O00CF9788B9027O0040025O003EB340025O00B8804003083O006EB2E7C94E105AA403063O007E3DD793BD27030D3O006DEC18636AF00E514BF712467303043O0025189F7D025O00A49B40025O00A7B24003083O00C30966624CDDF71F03063O00B3906C121625030B3O00D3B01EAFC6D4A63586D9C703053O00AFA6C37BE903083O00DCC7495DF9E1C54E03053O00908FA23D29030D3O00F5C018767E863EE5E0155F718C03073O005380B37D3012E7025O0074B240025O002CA540025O00D08040025O00908D40025O00DFB24003083O00E22DC8E0D826DBE703043O0094B148BC03113O00B3A552F6AAB35AD6A8A256DF84BA56C0B203043O00B3C6D63703083O006BDB056E18CCCA4B03073O00AD38BE711A71A203113O00DECD2826FFCAD72309FECCD6390BFEC5D903053O0097ABBE4D6503083O00F62AECBDF1730CD603073O006BA54F98C9981D03113O00425DEDE8467E4446C4C253774340E1C55303063O001F372E88AB34025O00888540025O00108B40025O0090A640025O0064AE4003083O007D1E1CFBA73FCA5D03073O00AD2E7B688FCE5103103O00A10E27A64C8409A0132B8442A10EB80903073O0061D47D42EA25E303083O00B9E6A2211784E4A503053O007EEA83D65503113O0091C64C6A5D8DD846484B8DD4456D4E92D003053O002FE4B5293A03083O0095F9CD2F0A3E18B503073O007FC69CB95B6350030E3O00E009C9C3B3042BD3C60EDEF9AC0E03083O00BE957AAC90C76B59025O00C88040025O0060A740025O00ACAF40025O0080604003083O00E84EB5B9D245A6BE03043O00CDBB2BC1030D3O00EB6100FEED7100D1FA730BDCFB03043O00BF9E126503083O00F6C693A3A6CBC49403053O00CFA5A3E7D7030C3O00D3EAFC722B7FCBCEF058206303063O0010A62O99364403083O00E1B6D4523D2FFEC103073O0099B2D3A0265441030E3O0097185F0D87195B27B11B53398B1F03043O004BE26B3A025O009C9840025O0046A24003083O0012E4B024432FE6B703053O002A4181C45003113O00042O4FDB1B3412E7104349ED1E130ACD2603083O008E622A3DBA77676203083O000BBA161C31B1051B03043O006858DF6203183O0054E5EBC30DFF40FEE3C235EC52F2D5C716E569FEECC721C903063O008D249782AE6203083O00B77FD6198D74C51E03043O006DE41AA203133O004DF0F37CE5F457EBFA4FE9F256C8F476E9C57A03063O00863E859D188000F0012O00120E012O00014O0067000100023O00261C012O00070001000100046F3O0007000100120E2O0100014O0067000200023O00120E012O00023O0026653O000B0001000200046F3O000B0001002E82000400020001000300046F3O0002000100261C2O01000B0001000100046F3O000B000100120E010200013O002665000200120001000500046F3O00120001002E39010600510001000700046F3O0051000100120E010300014O0067000400043O00261C010300140001000100046F3O0014000100120E010400013O00261C0104003C0001000100046F3O003C000100120E010500013O002E82000900370001000800046F3O0037000100261C010500370001000100046F3O003700010012D40006000A4O00FF000700013O00122O0008000B3O00122O0009000C6O0007000900024O0006000600074O000700013O00122O0008000D3O00122O0009000E6O0007000900024O0006000600072O00C600065O00122O0006000A6O000700013O00122O0008000F3O00122O000900106O0007000900024O0006000600074O000700013O00122O000800113O00122O000900124O00500107000900022O00F90006000600072O002A000600023O00120E010500023O00261C0105001A0001000200046F3O001A000100120E010400023O00046F3O003C000100046F3O001A0001002E39011400170001001300046F3O0017000100261C010400170001000200046F3O001700010012D40005000A4O0059000600013O00122O000700153O00122O000800166O0006000800024O0005000500064O000600013O00122O000700173O00122O000800186O0006000800024O0005000500064O000500033O00122O000200193O00044O0051000100046F3O0017000100046F3O0051000100046F3O00140001002E47001A00490001001A00046F3O009A000100261C0102009A0001001B00046F3O009A000100120E010300014O0067000400043O0026650003005B0001000100046F3O005B0001002E82001C00570001001D00046F3O0057000100120E010400013O002E47001E00120001001E00046F3O006E000100261C0104006E0001000200046F3O006E00010012D40005000A4O0059000600013O00122O0007001F3O00122O000800206O0006000800024O0005000500064O000600013O00122O000700213O00122O000800226O0006000800024O0005000500064O000500043O00122O000200233O00044O009A0001000E152O0100720001000400046F3O00720001002E390125005C0001002400046F3O005C000100120E010500013O000E15010200770001000500046F3O00770001002E82002600790001002700046F3O0079000100120E010400023O00046F3O005C00010026650005007D0001000100046F3O007D0001002E39012800730001002900046F3O007300010012D40006000A4O0011010700013O00122O0008002A3O00122O0009002B6O0007000900024O0006000600074O000700013O00122O0008002C3O00122O0009002D6O0007000900024O0006000600074O000600053O00122O0006000A6O000700013O00122O0008002E3O00122O0009002F6O0007000900024O0006000600074O000700013O00122O000800303O00122O000900316O0007000900024O0006000600074O000600063O00122O000500023O00044O0073000100046F3O005C000100046F3O009A000100046F3O00570001002E39013200D50001003300046F3O00D5000100261C010200D50001003400046F3O00D5000100120E010300013O002E39013600C40001003500046F3O00C4000100261C010300C40001000100046F3O00C4000100120E010400013O000E41010200A80001000400046F3O00A8000100120E010300023O00046F3O00C4000100261C010400A40001000100046F3O00A400010012D40005000A4O0011010600013O00122O000700373O00122O000800386O0006000800024O0005000500064O000600013O00122O000700393O00122O0008003A6O0006000800024O0005000500064O000500073O00122O0005000A6O000600013O00122O0007003B3O00122O0008003C6O0006000800024O0005000500064O000600013O00122O0007003D3O00122O0008003E6O0006000800024O0005000500064O000500083O00122O000400023O00044O00A4000100261C0103009F0001000200046F3O009F00010012D40004000A4O0059000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000500013O00122O000600413O00122O000700426O0005000700024O0004000400054O000400093O00122O000200053O00044O00D5000100046F3O009F000100261C010200122O01004300046F3O00122O0100120E010300013O002E39014500EA0001004400046F3O00EA000100261C010300EA0001000200046F3O00EA00010012D40004000A4O0059000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O0004000A3O00122O0002001B3O00044O00122O0100261C010300D80001000100046F3O00D8000100120E010400013O000E152O0100F10001000400046F3O00F10001002E47004A001B0001004B00046F3O000A2O010012D40005000A4O00FF000600013O00122O0007004C3O00122O0008004D6O0006000800024O0005000500064O000600013O00122O0007004E3O00122O0008004F6O0006000800024O0005000500062O00C60005000B3O00122O0005000A6O000600013O00122O000700503O00122O000800516O0006000800024O0005000500064O000600013O00122O000700523O00122O000800534O00500106000800022O00F90005000500062O002A0005000C3O00120E010400023O002E47005400E3FF2O005400046F3O00ED000100261C010400ED0001000200046F3O00ED000100120E010300023O00046F3O00D8000100046F3O00ED000100046F3O00D80001002E390156004B2O01005500046F3O004B2O0100261C0102004B2O01000200046F3O004B2O0100120E010300014O0067000400043O00261C010300182O01000100046F3O00182O0100120E010400013O0026650004001F2O01000200046F3O001F2O01002E820058002D2O01005700046F3O002D2O010012D40005000A4O0059000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500064O000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500064O0005000D3O00122O000200433O00044O004B2O0100261C0104001B2O01000100046F3O001B2O010012D40005000A4O0011010600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O000600013O00122O0007005F3O00122O000800606O0006000800024O0005000500064O0005000E3O00122O0005000A6O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000600013O00122O000700633O00122O000800646O0006000800024O0005000500064O0005000F3O00122O000400023O00044O001B2O0100046F3O004B2O0100046F3O00182O0100261C0102008E2O01002300046F3O008E2O0100120E010300014O0067000400043O002E4700653O0001006500046F3O004F2O01000E412O01004F2O01000300046F3O004F2O0100120E010400013O002665000400582O01000100046F3O00582O01002E47006600250001006700046F3O007B2O0100120E010500013O002E47006800060001006800046F3O005F2O0100261C0105005F2O01000200046F3O005F2O0100120E010400023O00046F3O007B2O0100261C010500592O01000100046F3O00592O010012D40006000A4O0011010700013O00122O000800693O00122O0009006A6O0007000900024O0006000600074O000700013O00122O0008006B3O00122O0009006C6O0007000900024O0006000600074O000600103O00122O0006000A6O000700013O00122O0008006D3O00122O0009006E6O0007000900024O0006000600074O000700013O00122O0008006F3O00122O000900706O0007000900024O0006000600074O000600113O00122O000500023O00044O00592O0100261C010400542O01000200046F3O00542O010012D40005000A4O0059000600013O00122O000700713O00122O000800726O0006000800024O0005000500064O000600013O00122O000700733O00122O000800746O0006000800024O0005000500064O000500123O00122O000200343O00044O008E2O0100046F3O00542O0100046F3O008E2O0100046F3O004F2O01002665000200922O01000100046F3O00922O01002E39017600C12O01007500046F3O00C12O0100120E010300013O002665000300972O01000100046F3O00972O01002E39017700B02O01007800046F3O00B02O010012D40004000A4O00FF000500013O00122O000600793O00122O0007007A6O0005000700024O0004000400054O000500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400052O00C6000400133O00122O0004000A6O000500013O00122O0006007D3O00122O0007007E6O0005000700024O0004000400054O000500013O00122O0006007F3O00122O000700804O00500105000700022O00F90004000400052O002A000400143O00120E010300023O000E41010200932O01000300046F3O00932O010012D40004000A4O0059000500013O00122O000600813O00122O000700826O0005000700024O0004000400054O000500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000400153O00122O000200023O00044O00C12O0100046F3O00932O01002E820085000E0001008600046F3O000E000100261C0102000E0001001900046F3O000E00010012D40003000A4O00FF000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000400013O00122O000500893O00122O0006008A6O0004000600024O0003000300042O00C6000300163O00122O0003000A6O000400013O00122O0005008B3O00122O0006008C6O0004000600024O0003000300044O000400013O00122O0005008D3O00122O0006008E4O00500104000600022O00F90003000300042O002A000300173O0012D40003000A4O005A010400013O00122O0005008F3O00122O000600906O0004000600024O0003000300044O000400013O00122O000500913O00122O000600926O0004000600024O0003000300044O000300183O00044O00EF2O0100046F3O000E000100046F3O00EF2O0100046F3O000B000100046F3O00EF2O0100046F3O000200012O00293O00017O00763O00028O00025O0076A340025O009C9F40026O001C40025O00A2AC40025O0026AE40030C3O004570696353652O74696E677303083O00232AFD181921EE1F03043O006C704F8903253O002AD17105AC04E5262BD07B258504E83936CC731BB813EE3008CB60208C07EF3936C1602DA903083O00555FA21448CD6189027O0040025O00D8AD40025O00EAA94003083O00C82EAC0354F52CAB03053O003D9B4BD87703153O0011B8B7145D08D10DA5B50F4C1BD805A686334C0CD003073O00BD64CBD25C386903083O001C54E93C265FFA3B03043O00484F319D03133O0089BE32B99BA423BD849724B58CB13FBF8D980103043O00DCE8D05103083O00C6BBF1242554A6E603073O00C195DE85504C3A03163O00C7534CD7D5495DD3CA7A5ADBC25C41D1C37A5DDDD34D03043O00B2A63D2F026O00084003083O0034A00ECD26BFD11403073O00B667C57AB94FD1030C3O00E694E4400946F7B4E972015A03063O002893E781176003083O0046FD9851B2A2DB6603073O00BC1598EC25DBCC03113O0055FA322F41F9360F49FD381E74E623094D03043O006C208957026O00F03F025O00D07B40025O0034A84003083O0099ED14B226F74C4A03083O0039CA8860C64F992B030F3O00BE30AF9385B2F6AF26B8B499A8EAA603073O0098CB43CAC7EDC7026O001040025O00708940025O00A4A84003083O009823D33EA3A521D403053O00CACB46A74A031F3O002100D93F623813D33E592900D03A7F2B32C921762922CE3A652502DD3F591C03053O00114C61BC5303083O00B622CD23398D4CB003083O00C3E547B95750E32B030A3O00E1E9145FDCE8F5055CEB03053O008F809C6030025O001EAB40025O00CCB14003083O008BD4E4061EB6D6E303053O0077D8B1907203093O00DA21F047C52DCC51CC03043O0022A9499903103O0086E50C83BEE20285ADAC3883A3E9078F03043O00EBCA8C6B026O00144003083O007C5B275D8541592003053O00EC2F3E5329030E3O00EFBA250BBF90FDAC143AB885FFBD03063O00E29AC9405BCA026O001840025O0074B24003083O003F7120BCE029F0D603083O00A56C1454C889479703073O0072B12A84559B0803043O00E81AD44B03083O00044C66FCFE394E6103053O00975729128803093O0053AACBDCD1748CE2E003053O009E3BCFAAB0025O00E6A840025O00A1B24003083O00C946B41B167B7EF503083O00869A23C06F7F151903143O00AD350C2B2ED1BD351D1821DE9F33000E21DCBB2303063O00B2D846696A4003083O000C2E6EE2C0DBD39303083O00E05F4B1A96A9B5B4030E3O001EC9DD0957B8640AD6EB204DAA6203073O00166BBAB84824CC03083O00D4B8305A07E9BA3703053O006E87DD442E03183O00F62509C6CFB637F0221EE4C39B3EE23A05E5C9802EF1310903073O005B83566C8BAED3025O00FCAB40025O00789C4003083O00F24C090C43B2C65A03063O00DCA1297D782A031D3O00A962A52DB074A100AF74931EB563A91A8B78B4069D77A602B572B40BB803043O006EDC11C003083O00477C200EE239F6B403083O00C71419547A8B5791031B3O00521AD89A09EF4A06CF9A14FE4204EAA70FE2660FDBA212E9530CD903063O008A2769BDCE7B025O00709B40025O00EC964003083O002C029D39FAF7C8EC03083O009F7F67E94D9399AF03243O0012E3E19A4FC214FFEA894CCE06FEF7A34ECC33FFF0AF4DFC0EE4EC8B46CD0BF9E7BE45CF03063O00AB679084CA2003083O00C84FFC6EC330FC5903063O005E9B2A881AAA030D3O00852C32A7853315BD8D39329DB403043O00D5E45F4603083O0019BED6907E24BCD103053O00174ADBA2E403143O0031E347A33237E175BB293CE74B9B342DE34B870B03053O005B598626CF03083O0077EBDC221ADE205703073O0047248EA85673B003173O00D7A473B30AB0517ACBB377BE0E8A595DDAAC55AD0CAB4603083O0029BFC112DF63DE360078012O00120E012O00014O0067000100013O002E39010300020001000200046F3O0002000100261C012O00020001000100046F3O0002000100120E2O0100013O0026650001000B0001000400046F3O000B0001002E39010600180001000500046F3O001800010012D4000200074O005A010300013O00122O000400083O00122O000500096O0003000500024O0002000200034O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O00025O00044O00772O010026650001001C0001000C00046F3O001C0001002E82000D00470001000E00046F3O004700010012D4000200074O00F8000300013O00122O0004000F3O00122O000500106O0003000500024O0002000200034O000300013O00122O000400113O00122O000500126O0003000500024O0002000200034O000200023O00122O000200076O000300013O00122O000400133O00122O000500146O0003000500024O0002000200034O000300013O00122O000400153O00122O000500166O0003000500024O00020002000300062O000200360001000100046F3O0036000100120E010200014O002A000200033O001229010200076O000300013O00122O000400173O00122O000500186O0003000500024O0002000200034O000300013O00122O000400193O00122O0005001A6O0003000500024O00020002000300062O000200450001000100046F3O0045000100120E010200014O002A000200043O00120E2O01001B3O00261C2O0100780001000100046F3O0078000100120E010200013O00261C010200650001000100046F3O006500010012D4000300074O00FF000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300042O00C6000300053O00122O000300076O000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000400013O00122O000500223O00122O000600234O00500104000600022O00F90003000300042O002A000300063O00120E010200243O002665000200690001002400046F3O00690001002E390126004A0001002500046F3O004A00010012D4000300074O0059000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000300073O00122O000100243O00044O0078000100046F3O004A000100261C2O0100B40001002B00046F3O00B4000100120E010200013O0026650002007F0001000100046F3O007F0001002E47002C001E0001002D00046F3O009B00010012D4000300074O0020000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000400013O00122O000500303O00122O000600316O0004000600024O00030003000400062O0003008D0001000100046F3O008D000100120E010300014O002A000300083O001250000300076O000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600022O00F90003000300042O002A000300093O00120E010200243O0026650002009F0001002400046F3O009F0001002E820037007B0001003600046F3O007B00010012D4000300074O0020000400013O00122O000500383O00122O000600396O0004000600024O0003000300044O000400013O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400062O000300B00001000100046F3O00B000012O00B9000300013O00120E0104003C3O00120E0105003D4O00500103000500022O002A0003000A3O00120E2O01003E3O00046F3O00B4000100046F3O007B000100261C2O0100E80001003E00046F3O00E8000100120E010200013O000E41012400C70001000200046F3O00C700010012D4000300074O0059000400013O00122O0005003F3O00122O000600406O0004000600024O0003000300044O000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O0003000B3O00122O000100433O00044O00E80001002E47004400F0FF2O004400046F3O00B7000100261C010200B70001000100046F3O00B700010012D4000300074O00F8000400013O00122O000500453O00122O000600466O0004000600024O0003000300044O000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O0003000C3O00122O000300076O000400013O00122O000500493O00122O0006004A6O0004000600024O0003000300044O000400013O00122O0005004B3O00122O0006004C6O0004000600024O00030003000400062O000300E50001000100046F3O00E5000100120E010300014O002A0003000D3O00120E010200243O00046F3O00B70001002665000100EC0001002400046F3O00EC0001002E47004D00270001004E00046F3O00112O010012D4000200074O00FF000300013O00122O0004004F3O00122O000500506O0003000500024O0002000200034O000300013O00122O000400513O00122O000500526O0003000500024O0002000200032O00C60002000E3O00122O000200076O000300013O00122O000400533O00122O000500546O0003000500024O0002000200034O000300013O00122O000400553O00122O000500564O00500103000500022O00F90002000200032O00C60002000F3O00122O000200076O000300013O00122O000400573O00122O000500586O0003000500024O0002000200034O000300013O00122O000400593O00122O0005005A4O00500103000500022O00F90002000200032O002A000200103O00120E2O01000C3O002665000100152O01004300046F3O00152O01002E39015B00442O01005C00046F3O00442O0100120E010200013O00261C010200312O01000100046F3O00312O010012D4000300074O00FF000400013O00122O0005005D3O00122O0006005E6O0004000600024O0003000300044O000400013O00122O0005005F3O00122O000600606O0004000600024O0003000300042O00C6000300113O00122O000300076O000400013O00122O000500613O00122O000600626O0004000600024O0003000300044O000400013O00122O000500633O00122O000600644O00500104000600022O00F90003000300042O002A000300123O00120E010200243O002E39016600162O01006500046F3O00162O01000E41012400162O01000200046F3O00162O010012D4000300074O0059000400013O00122O000500673O00122O000600686O0004000600024O0003000300044O000400013O00122O000500693O00122O0006006A6O0004000600024O0003000300044O000300133O00122O000100043O00044O00442O0100046F3O00162O0100261C2O0100070001001B00046F3O000700010012D4000200074O0020000300013O00122O0004006B3O00122O0005006C6O0003000500024O0002000200034O000300013O00122O0004006D3O00122O0005006E6O0003000500024O00020002000300062O000200542O01000100046F3O00542O0100120E010200014O002A000200143O001229010200076O000300013O00122O0004006F3O00122O000500706O0003000500024O0002000200034O000300013O00122O000400713O00122O000500726O0003000500024O00020002000300062O000200632O01000100046F3O00632O0100120E010200014O002A000200153O001229010200076O000300013O00122O000400733O00122O000500746O0003000500024O0002000200034O000300013O00122O000400753O00122O000500766O0003000500024O00020002000300062O000200722O01000100046F3O00722O0100120E010200014O002A000200163O00120E2O01002B3O00046F3O0007000100046F3O00772O0100046F3O000200012O00293O00017O00663O00028O00025O0010A240025O0070AD40025O00E8B140025O0091B040026O00F03F025O00DC9A40025O00049C40030C3O004570696353652O74696E677303083O0047D13342AD85826703073O00E514B44736C4EB03164O0070D5E6E7B895396AEEEDF9B3B72177D5E6F9A3933D03073O00E0491EA18395CA03083O00C4F83EC804F6CAE403073O00AD979D4ABC6D9803113O0022013FD5C866D0FE250136CEFF5CD0F02F03083O0093446858BDBC34B503083O00298D9FC413868CC303043O00B07AE8EB03113O00A97B2E4AFC92602A5BD98961327CFA957B03053O008EE0155A2F026O00144003083O0024FF3494DBC010E903063O00AE779A40E0B2030F3O00227FCB7F09A23BE22C72CC7811A21E03083O00844A1EA51B65C77A03083O001CE2EBB3AEBBB33C03073O00D44F879F2OC7D503113O0051A1BB4350D23177A3BA554CD80A7CA1B903073O007819C0D5273CB7025O0060A240025O0030B24003083O00C2E0E544F8EBF64303043O003091859103123O007342A1EBC33E4F5CA1DAD93E2O5FBDE1DD2803063O004C3A2CD58EB103083O00F821063971C5230103053O0018AB44724D030D3O00CB14434282D220A8ED0856549403083O00CD8F7D3032E7BE64025O0032A140025O00B4B24003083O00F2A20011E8EDD8B103083O00C2A1C774658183BF030B3O00C82DDBB8F2AECE31CEAEE403063O00C28C44A8C897027O0040025O00A08340026O001040025O00C07440025O0044A84003084O00CEE2F840F634D803063O009853AB968C29030D3O008AE0823FC0131B96EA8D36FC2B03073O0068E285E353B47B03083O00300E37440A05244303043O0030636B43030F3O00D6A37CDC2475D99672C42474D08E4D03063O001BBEC61DB04D025O00909A40025O0048944003083O00DC4EE920A040E85803063O002E8F2B9D54C903113O007F7D57CE561DCF677742CB501DE656755303073O00A8371836A23F73034O00025O0044A040025O0020A840025O0094A14003083O009FE6AD2FA5EDBE2803043O005BCC83D9030E3O00DAED5CDAB8D8EADDC85CC0BBFEDA03073O009EAE9F35B4D3BD026O000840025O00F5B240025O00C08C40025O00749040025O0075B24003083O0071FEC131FC4CFCC603053O0095229BB545030B3O0016EED0CE11F4DBF106E9C603043O009A639DB503083O00BE0AF8B4E58308FF03053O008CED6F8CC0030A3O00130A782A071A74192O0A03043O007866791D025O00F6A140025O00C08A4003083O00F189E4F080CC8BE303053O00E9A2EC908403103O00A7D7FB32BCF753BBCAF92AB6E256BDCA03073O003FD2A49E7AD996025O00B09540026O005B4003083O0061F8F9C97EBB55EE03063O00D5329D8DBD17030D3O00EC2787A973A8ED118DB47A87DA03063O00C49E46E4C01203083O00795A055AD044580203053O00B92A3F712E030E3O00C1CE24111ED5D1353108C0D22F3C03053O007BB4BD4159003F012O00120E012O00013O0026653O00050001000100046F3O00050001002E820003003F0001000200046F3O003F000100120E2O0100014O0067000200023O000E152O01000B0001000100046F3O000B0001002E82000400070001000500046F3O0007000100120E010200013O002665000200100001000600046F3O00100001002E390108001E0001000700046F3O001E00010012D4000300094O0059000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O00035O00124O00063O00044O003F000100261C0102000C0001000100046F3O000C00010012D4000300094O0020000400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000400013O00122O000500103O00122O000600116O0004000600024O00030003000400062O0003002E0001000100046F3O002E000100120E010300014O002A000300023O0012D4000300094O0059000400013O00122O000500123O00122O000600136O0004000600024O0003000300044O000400013O00122O000500143O00122O000600156O0004000600024O0003000300044O000300033O00122O000200063O00044O000C000100046F3O003F000100046F3O0007000100261C012O005A0001001600046F3O005A00010012D4000100094O00FF000200013O00122O000300173O00122O000400186O0002000400024O0001000100024O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100022O002A000100043O0012D4000100094O005A010200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O000100053O00044O003E2O010026653O005E0001000600046F3O005E0001002E47001F00310001002000046F3O008D000100120E2O0100013O00261C2O01007A0001000100046F3O007A00010012D4000200094O00FF000300013O00122O000400213O00122O000500226O0003000500024O0002000200034O000300013O00122O000400233O00122O000500246O0003000500024O0002000200032O00C6000200063O00122O000200096O000300013O00122O000400253O00122O000500266O0003000500024O0002000200034O000300013O00122O000400273O00122O000500284O00500103000500022O00F90002000200032O002A000200073O00120E2O0100063O0026650001007E0001000600046F3O007E0001002E82002A005F0001002900046F3O005F00010012D4000200094O0059000300013O00122O0004002B3O00122O0005002C6O0003000500024O0002000200034O000300013O00122O0004002D3O00122O0005002E6O0003000500024O0002000200034O000200083O00124O002F3O00044O008D000100046F3O005F0001002E470030003E0001003000046F3O00CB0001000E41013100CB00013O00046F3O00CB000100120E2O0100013O002E82003200B50001003300046F3O00B5000100261C2O0100B50001000100046F3O00B500010012D4000200094O0020000300013O00122O000400343O00122O000500356O0003000500024O0002000200034O000300013O00122O000400363O00122O000500376O0003000500024O00020002000300062O000200A40001000100046F3O00A4000100120E010200014O002A000200093O001229010200096O000300013O00122O000400383O00122O000500396O0003000500024O0002000200034O000300013O00122O0004003A3O00122O0005003B6O0003000500024O00020002000300062O000200B30001000100046F3O00B3000100120E010200014O002A0002000A3O00120E2O0100063O002665000100B90001000600046F3O00B90001002E39013C00920001003D00046F3O009200010012D4000200094O0020000300013O00122O0004003E3O00122O0005003F6O0003000500024O0002000200034O000300013O00122O000400403O00122O000500416O0003000500024O00020002000300062O000200C70001000100046F3O00C7000100120E010200424O002A0002000B3O00120E012O00163O00046F3O00CB000100046F3O00920001002E470043003F0001004300046F3O000A2O01000E41012F000A2O013O00046F3O000A2O0100120E2O0100013O002E82004500E20001004400046F3O00E20001000E41010600E20001000100046F3O00E200010012D4000200094O0059000300013O00122O000400463O00122O000500476O0003000500024O0002000200034O000300013O00122O000400483O00122O000500496O0003000500024O0002000200034O0002000C3O00124O004A3O00044O000A2O01002665000100E60001000100046F3O00E60001002E39014B00D00001004C00046F3O00D0000100120E010200013O002E39014D00ED0001004E00046F3O00ED000100261C010200ED0001000600046F3O00ED000100120E2O0100063O00046F3O00D0000100261C010200E70001000100046F3O00E700010012D4000300094O0011010400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O000400013O00122O000500513O00122O000600526O0004000600024O0003000300044O0003000D3O00122O000300096O000400013O00122O000500533O00122O000600546O0004000600024O0003000300044O000400013O00122O000500553O00122O000600566O0004000600024O0003000300044O0003000E3O00122O000200063O00044O00E7000100046F3O00D000010026653O000E2O01004A00046F3O000E2O01002E39015700010001005800046F3O0001000100120E2O0100013O00261C2O01001F2O01000600046F3O001F2O010012D4000200094O0059000300013O00122O000400593O00122O0005005A6O0003000500024O0002000200034O000300013O00122O0004005B3O00122O0005005C6O0003000500024O0002000200034O0002000F3O00124O00313O00044O00010001002665000100232O01000100046F3O00232O01002E47005D00EEFF2O005E00046F3O000F2O010012D4000200094O0011010300013O00122O0004005F3O00122O000500606O0003000500024O0002000200034O000300013O00122O000400613O00122O000500626O0003000500024O0002000200034O000200103O00122O000200096O000300013O00122O000400633O00122O000500646O0003000500024O0002000200034O000300013O00122O000400653O00122O000500666O0003000500024O0002000200034O000200113O00122O000100063O00044O000F2O0100046F3O000100012O00293O00017O007A3O00028O00025O004DB040025O008CA340026O00F03F027O0040030C3O004570696353652O74696E677303073O002C4F384F14452C03043O002878205F2O033O0035A43A03063O007F5ACB591ACF025O00988A40025O004CA540025O0010AB40025O00206D40026O00084003113O00476574456E656D696573496E52616E6765026O00444003163O00476574456E656D696573496E4D656C2O6552616E6765026O001440030D3O004973446561644F7247686F7374025O00A07840025O00806F4003013O005F026O001040030C3O0049734368612O6E656C696E6703053O00466F637573025O00CEAC40025O00488740025O0048A740025O00ECA340025O00608A40025O00B2AA40025O00A88340025O0092AD40025O004EA540025O00AEA240030F3O0048616E646C65412O666C696374656403143O00506F69736F6E436C65616E73696E67546F74656D026O003E40025O001EAF40025O009C9440025O00BC9840025O00ACAA4003093O0042752O66537461636B03133O004D61656C7374726F6D576561706F6E42752O66026O006C40025O00DAA840030C3O004865616C696E67537572676503153O004865616C696E6753757267654D6F7573656F766572025O005EAD40025O006C9440025O00409440025O00C09B40030D3O00436C65616E736553706972697403163O00436C65616E73655370697269744D6F7573656F766572030B3O005472656D6F72546F74656D025O00409340025O0072A940025O000C9140025O00FAA240030F3O00412O66656374696E67436F6D626174025O00389740025O00B8AE40025O00208440025O00A08440025O00309240025O009C9040025O00CEB140025O00F07F40025O003CA840026O005F40025O0060A140025O00207F40025O00B88440025O00FEA640025O005CA040025O0008A240025O00249240025O00288240025O00EAAF40025O00C49540030D3O0089044DEE85B90D7BFF82B8015C03053O00EBCA68288F03073O004973526561647903093O00466F637573556E6974026O003440026O003940030D3O00546172676574497356616C696403103O00426F2O73466967687452656D61696E73025O00E5B140025O00E6AC40024O0080B3C540030C3O00466967687452656D61696E7303073O0050726576474344030E3O00436861696E4C696768746E696E67030F3O002E831AB003CB37B00A830FB704851C03043O00D96DEB7B025O00B08840025O00BAAF40030D3O004C696768746E696E67426F6C74030E3O000B80795E64DEC4B320C95C597CC403083O00DD47E91E3610B0AD025O00308540025O00B07140025O0024B340025O00E2A24003073O00680A84CE3AD95803073O002B3C65E3A956BC03063O0074C1C2AF5FC003083O005710A8B1DF3AACD903074O00C25EDA3731DE03053O005B54AD39BD03073O001DB002F5A3D22O03063O00B670D96C9CC003073O00E93AA8CC05F8CE03063O009DBD55CFAB692O033O00C7AEDD03053O0063A6C1B8D503073O00E2B887BC008FC503063O00EAB6D7E0DB6C2O033O00C385A803043O0055A0E1DB006C022O00120E012O00013O00261C012O002B0001000100046F3O002B000100120E2O0100013O00261C2O0100150001000100046F3O0015000100120E010200013O002E39010300100001000200046F3O0010000100261C010200100001000100046F3O001000012O00B900036O007E0003000100012O00B9000300014O007E00030001000100120E010200043O00261C010200070001000400046F3O0007000100120E2O0100043O00046F3O0015000100046F3O0007000100261C2O0100190001000500046F3O0019000100120E012O00043O00046F3O002B000100261C2O0100040001000400046F3O000400012O00B9000200024O007E0002000100010012D4000200064O0059000300043O00122O000400073O00122O000500086O0003000500024O0002000200034O000300043O00122O000400093O00122O0005000A6O0003000500024O0002000200034O000200033O00122O000100053O00044O000400010026653O002F0001000500046F3O002F0001002E82000C005D0001000B00046F3O005D000100120E2O0100014O0067000200023O000E412O0100310001000100046F3O0031000100120E010200013O002665000200380001000500046F3O00380001002E39010D003A0001000E00046F3O003A000100120E012O000F3O00046F3O005D000100261C010200470001000400046F3O004700012O00B9000300063O00205F01030003001000122O000500116O0003000500024O000300056O000300063O00202O00030003001200122O000500136O0003000500024O000300073O00122O000200053O00261C010200340001000100046F3O003400012O00B9000300063O0020020103000300142O00430103000200020006A2000300500001000100046F3O00500001002E39011500510001001600046F3O005100012O00293O00014O00B90003000C4O00650103000100084O0008000B6O0007000A3O00122O000600173O00122O000500176O000400096O000300083O00122O000200043O00044O0034000100046F3O005D000100046F3O0031000100261C012O003F2O01001800046F3O003F2O012O00B9000100063O0020022O01000100192O00432O01000200020006A20001006B0201000100046F3O006B02012O00B9000100063O0020022O01000100192O00432O01000200020006A20001006B0201000100046F3O006B020100120E2O0100013O00261C2O0100132O01000100046F3O00132O010012D40002001A3O0006A2000200710001000100046F3O00710001002E47001B001A0001001C00046F3O008900012O00B90002000D3O0006350102008900013O00046F3O0089000100120E010200014O0067000300033O000E152O01007A0001000200046F3O007A0001002E82001D00760001001E00046F3O0076000100120E010300013O00261C0103007B0001000100046F3O007B00012O00B90004000F4O00770004000100022O002A0004000E4O00B90004000E3O0006350104008900013O00046F3O008900012O00B90004000E4O0047010400023O00046F3O0089000100046F3O007B000100046F3O0089000100046F3O007600012O00B9000200103O000635010200122O013O00046F3O00122O0100120E010200013O002E82001F00D60001002000046F3O00D6000100261C010200D60001000400046F3O00D60001002E82002100B30001002200046F3O00B300012O00B9000300113O000635010300B300013O00046F3O00B3000100120E010300014O0067000400043O00261C010300980001000100046F3O0098000100120E010400013O002E820024009B0001002300046F3O009B0001000E412O01009B0001000400046F3O009B00012O00B9000500123O0020380005000500254O000600133O00202O0006000600264O000700133O00202O00070007002600122O000800276O0005000800024O0005000E6O0005000E3O00062O000500AD0001000100046F3O00AD0001002E47002800080001002900046F3O00B300012O00B90005000E4O0047010500023O00046F3O00B3000100046F3O009B000100046F3O00B3000100046F3O00980001002E39012A00122O01002B00046F3O00122O012O00B9000300063O0020E300030003002C4O000500133O00202O00050005002D4O000300050002000E2O001300122O01000300046F3O00122O012O00B9000300143O000635010300122O013O00046F3O00122O0100120E010300013O002E82002E00C00001002F00046F3O00C0000100261C010300C00001000100046F3O00C000012O00B9000400123O00200B0004000400254O000500133O00202O0005000500304O000600153O00202O00060006003100122O000700116O000800016O0004000800024O0004000E6O0004000E3O00062O000400122O013O00046F3O00122O012O00B90004000E4O0047010400023O00046F3O00122O0100046F3O00C0000100046F3O00122O01002E390133008D0001003200046F3O008D000100261C0102008D0001000100046F3O008D00012O00B9000300163O0006A2000300DF0001000100046F3O00DF0001002E82003500F20001003400046F3O00F2000100120E010300013O00261C010300E00001000100046F3O00E000012O00B9000400123O00202C0004000400254O000500133O00202O0005000500364O000600153O00202O00060006003700122O000700116O0004000700024O0004000E6O0004000E3O00062O000400F200013O00046F3O00F200012O00B90004000E4O0047010400023O00046F3O00F2000100046F3O00E000012O00B9000300173O000635010300102O013O00046F3O00102O0100120E010300014O0067000400043O000E412O0100F70001000300046F3O00F7000100120E010400013O00261C010400FA0001000100046F3O00FA00012O00B9000500123O0020380005000500254O000600133O00202O0006000600384O000700133O00202O00070007003800122O000800276O0005000800024O0005000E6O0005000E3O00062O0005000A2O01000100046F3O000A2O01002E82003A00102O01003900046F3O00102O012O00B90005000E4O0047010500023O00046F3O00102O0100046F3O00FA000100046F3O00102O0100046F3O00F7000100120E010200043O00046F3O008D000100120E2O0100043O002E39013B006A0001003C00046F3O006A000100261C2O01006A0001000400046F3O006A00012O00B9000200063O00200201020002003D2O0043010200020002000635010200272O013O00046F3O00272O012O00B9000200184O00770002000100022O002A0002000E3O002E39013E006B0201003F00046F3O006B02012O00B90002000E3O0006350102006B02013O00046F3O006B02012O00B90002000E4O0047010200023O00046F3O006B020100120E010200014O0067000300033O00261C010200292O01000100046F3O00292O0100120E010300013O000E412O01002C2O01000300046F3O002C2O012O00B9000400194O00770004000100022O002A0004000E3O002E390140006B0201004100046F3O006B02012O00B90004000E3O0006350104006B02013O00046F3O006B02012O00B90004000E4O0047010400023O00046F3O006B020100046F3O002C2O0100046F3O006B020100046F3O00292O0100046F3O006B020100046F3O006A000100046F3O006B020100261C012O00280201000F00046F3O0028020100120E2O0100014O0067000200023O00261C2O0100432O01000100046F3O00432O0100120E010200013O00261C0102004A2O01000500046F3O004A2O0100120E012O00183O00046F3O0028020100261C010200CD2O01000100046F3O00CD2O012O00B90003001A3O0006A2000300512O01000100046F3O00512O01002E39014200672O01004300046F3O00672O0100120E010300014O0067000400043O002E82004500532O01004400046F3O00532O0100261C010300532O01000100046F3O00532O0100120E010400013O000E152O01005C2O01000400046F3O005C2O01002E39014600582O01004700046F3O00582O012O00B9000500054O0061000500056O0005001B6O000500076O000500056O0005001C3O00044O007A2O0100046F3O00582O0100046F3O007A2O0100046F3O00532O0100046F3O007A2O0100120E010300014O0067000400043O002E39014900692O01004800046F3O00692O0100261C010300692O01000100046F3O00692O0100120E010400013O002E82004A006E2O01004B00046F3O006E2O0100261C0104006E2O01000100046F3O006E2O0100120E010500044O002A0005001B3O00120E010500044O002A0005001C3O00046F3O007A2O0100046F3O006E2O0100046F3O007A2O0100046F3O00692O012O00B9000300063O00200201030003003D2O00430103000200020006A2000300842O01000100046F3O00842O012O00B90003000D3O0006A2000300842O01000100046F3O00842O01002E39014D00CC2O01004C00046F3O00CC2O0100120E010300014O0067000400053O00261C010300C62O01000400046F3O00C62O0100261C010400BC2O01000100046F3O00BC2O0100120E010600014O0067000700073O002E82004F008C2O01004E00046F3O008C2O0100261C0106008C2O01000100046F3O008C2O0100120E010700013O00261C010700B52O01000100046F3O00B52O0100120E010800013O002665000800982O01000400046F3O00982O01002E390150009A2O01005100046F3O009A2O0100120E010700043O00046F3O00B52O0100261C010800942O01000100046F3O00942O012O00B90009000D3O000608000500AA2O01000900046F3O00AA2O012O00B9000900134O0053010A00043O00122O000B00523O00122O000C00536O000A000C00024O00090009000A00202O0009000900544O00090002000200062O000500AA2O01000900046F3O00AA2O012O00B90005001D4O00B9000900123O00202E0009000900554O000A00056O000B00153O00122O000C00566O000D000D3O00122O000E00576O0009000E00024O0009000E3O00122O000800043O00044O00942O0100261C010700912O01000400046F3O00912O0100120E010400043O00046F3O00BC2O0100046F3O00912O0100046F3O00BC2O0100046F3O008C2O0100261C010400882O01000400046F3O00882O012O00B90006000E3O000635010600CC2O013O00046F3O00CC2O012O00B90006000E4O0047010600023O00046F3O00CC2O0100046F3O00882O0100046F3O00CC2O0100261C010300862O01000100046F3O00862O0100120E010400014O0067000500053O00120E010300043O00046F3O00862O0100120E010200043O00261C010200462O01000400046F3O00462O012O00B9000300123O00201B0003000300582O00770003000100020006A2000300D92O01000100046F3O00D92O012O00B9000300063O00200201030003003D2O00430103000200020006350103002O02013O00046F3O002O020100120E010300014O0067000400043O000E412O0100DB2O01000300046F3O00DB2O0100120E010400013O00261C010400F12O01000100046F3O00F12O0100120E010500013O00261C010500E52O01000400046F3O00E52O0100120E010400043O00046F3O00F12O0100261C010500E12O01000100046F3O00E12O012O00B90006001F3O00203A0106000600594O000700076O000800016O0006000800024O0006001E6O0006001E6O000600203O00122O000500043O00044O00E12O01002665000400F52O01000400046F3O00F52O01002E82005A00DE2O01005B00046F3O00DE2O012O00B9000500203O00261C0105002O0201005C00046F3O002O02012O00B90005001F3O0020F600050005005D4O000600076O00078O0005000700024O000500203O00044O002O020100046F3O00DE2O0100046F3O002O020100046F3O00DB2O012O00B9000300063O00200201030003003D2O00430103000200020006350103002402013O00046F3O002402012O00B9000300063O00203201030003005E00122O000500046O000600133O00202O00060006005F4O00030006000200062O0003001502013O00046F3O001502012O00B9000300043O00127A000400603O00122O000500616O0003000500024O000300213O00044O00240201002E82006200240201006300046F3O002402012O00B9000300063O00203201030003005E00122O000500046O000600133O00202O0006000600644O00030006000200062O0003002402013O00046F3O002402012O00B9000300043O00120E010400653O00120E010500664O00500103000500022O002A000300213O00120E010200053O00046F3O00462O0100046F3O0028020100046F3O00432O010026653O002C0201000400046F3O002C0201002E82006700010001006800046F3O0001000100120E2O0100013O002665000100310201000400046F3O00310201002E820069004A0201006A00046F3O004A02010012D4000200064O00FF000300043O00122O0004006B3O00122O0005006C6O0003000500024O0002000200034O000300043O00122O0004006D3O00122O0005006E6O0003000500024O0002000200032O00C60002001D3O00122O000200066O000300043O00122O0004006F3O00122O000500706O0003000500024O0002000200034O000300043O00122O000400713O00122O000500724O00500103000500022O00F90002000200032O002A000200223O00120E2O0100053O00261C2O01004E0201000500046F3O004E020100120E012O00053O00046F3O0001000100261C2O01002D0201000100046F3O002D02010012D4000200064O0011010300043O00122O000400733O00122O000500746O0003000500024O0002000200034O000300043O00122O000400753O00122O000500766O0003000500024O0002000200034O0002001A3O00122O000200066O000300043O00122O000400773O00122O000500786O0003000500024O0002000200034O000300043O00122O000400793O00122O0005007A6O0003000500024O0002000200034O000200233O00122O000100043O00044O002D020100046F3O000100012O00293O00017O000E3O00028O00026O00F03F025O00609740025O008BB240025O001EA740025O0050A04003103O0012F05FB231CF56B037F77ABA36E958B903043O00DF549C3E03143O00526567697374657241757261547261636B696E67025O00BAA640025O005C9E4003053O005072696E7403313O00F3F2EADCB938D3F1E7D3A37BE5F4E3D0B63596FEFB9D922BDFFFAC9D842EC6ECEDCFA33ED2BCE0C4F7232OFDECD8A3349803063O005BB69C82BDD700363O00120E012O00013O00261C012O00280001000100046F3O0028000100120E2O0100014O0067000200023O00261C2O0100050001000100046F3O0005000100120E010200013O00261C0102000C0001000200046F3O000C000100120E012O00023O00046F3O00280001002E82000300080001000400046F3O0008000100261C010200080001000100046F3O0008000100120E010300013O002665000300150001000200046F3O00150001002E47000500040001000600046F3O0017000100120E010200023O00046F3O0008000100261C010300110001000100046F3O001100012O00B900046O00F2000500013O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O0004000200014O000400026O00040001000100122O000300023O00046F3O0011000100046F3O0008000100046F3O0028000100046F3O00050001002E82000B00010001000A00046F3O00010001000E410102000100013O00046F3O000100012O00B9000100033O00201B00010001000C2O00AA000200013O00122O0003000D3O00122O0004000E6O000200046O00013O000100046F3O0035000100046F3O000100012O00293O00017O00", GetFEnv(), ...);

