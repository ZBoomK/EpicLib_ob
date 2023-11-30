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
				if (Enum <= 165) then
					if (Enum <= 82) then
						if (Enum <= 40) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 3) then
											Upvalues[Inst[3]] = Stk[Inst[2]];
										elseif (Inst[2] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 6) then
										if (Enum > 5) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 7) then
										Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
									elseif (Enum == 8) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum == 10) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum > 13) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 16) then
									if (Enum > 15) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum > 20) then
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
									elseif (Enum <= 22) then
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
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									elseif (Enum == 23) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 26) then
									if (Enum > 25) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 27) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum > 30) then
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
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									end
								elseif (Enum <= 32) then
									if (Inst[2] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 37) then
								if (Enum <= 35) then
									Stk[Inst[2]] = Stk[Inst[3]];
								elseif (Enum == 36) then
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								else
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 38) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 39) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 61) then
							if (Enum <= 50) then
								if (Enum <= 45) then
									if (Enum <= 42) then
										if (Enum > 41) then
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
									elseif (Enum <= 43) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 44) then
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
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 47) then
									if (Enum > 46) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 49) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 55) then
								if (Enum <= 52) then
									if (Enum > 51) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 53) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 54) then
									Stk[Inst[2]] = not Stk[Inst[3]];
								else
									Env[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 58) then
								if (Enum <= 56) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 57) then
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
									if (Stk[Inst[2]] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 59) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 71) then
							if (Enum <= 66) then
								if (Enum <= 63) then
									if (Enum == 62) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 65) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 68) then
								if (Enum > 67) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 69) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 70) then
								do
									return Stk[Inst[2]]();
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
						elseif (Enum <= 76) then
							if (Enum <= 73) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 74) then
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
							elseif (Enum > 75) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 79) then
							if (Enum <= 77) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum > 78) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 80) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
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
					elseif (Enum <= 123) then
						if (Enum <= 102) then
							if (Enum <= 92) then
								if (Enum <= 87) then
									if (Enum <= 84) then
										if (Enum == 83) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 85) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 86) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									else
										local B;
										local A;
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
									end
								elseif (Enum <= 89) then
									if (Enum == 88) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local Edx;
										local Results;
										local A;
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
									end
								elseif (Enum <= 90) then
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
								elseif (Enum > 91) then
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
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum <= 97) then
								if (Enum <= 94) then
									if (Enum > 93) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
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
								elseif (Enum <= 95) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum > 96) then
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
							elseif (Enum <= 99) then
								if (Enum == 98) then
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
							elseif (Enum <= 100) then
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							elseif (Enum > 101) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 107) then
								if (Enum <= 104) then
									if (Enum == 103) then
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
									else
										local A;
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum <= 105) then
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
								elseif (Enum > 106) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 109) then
								if (Enum == 108) then
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								else
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								end
							elseif (Enum <= 110) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 111) then
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
						elseif (Enum <= 117) then
							if (Enum <= 114) then
								if (Enum > 113) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
								do
									return Stk[Inst[2]];
								end
							elseif (Enum > 116) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 120) then
							if (Enum <= 118) then
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
							elseif (Enum > 119) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 121) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 122) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 144) then
						if (Enum <= 133) then
							if (Enum <= 128) then
								if (Enum <= 125) then
									if (Enum == 124) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 126) then
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 127) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 130) then
								if (Enum > 129) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
							elseif (Enum > 132) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 138) then
							if (Enum <= 135) then
								if (Enum == 134) then
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 136) then
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 137) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
								Stk[Inst[2]]();
							end
						elseif (Enum <= 141) then
							if (Enum <= 139) then
								Stk[Inst[2]] = #Stk[Inst[3]];
							elseif (Enum == 140) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 142) then
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
						elseif (Enum > 143) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						end
					elseif (Enum <= 154) then
						if (Enum <= 149) then
							if (Enum <= 146) then
								if (Enum == 145) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 147) then
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
							elseif (Enum == 148) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 151) then
							if (Enum > 150) then
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
						elseif (Enum > 153) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 159) then
						if (Enum <= 156) then
							if (Enum == 155) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 157) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						elseif (Enum > 158) then
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 162) then
						if (Enum <= 160) then
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 161) then
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
					elseif (Enum <= 163) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 164) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 248) then
					if (Enum <= 206) then
						if (Enum <= 185) then
							if (Enum <= 175) then
								if (Enum <= 170) then
									if (Enum <= 167) then
										if (Enum > 166) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
									elseif (Enum <= 168) then
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
									elseif (Enum > 169) then
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
								elseif (Enum <= 172) then
									if (Enum == 171) then
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
										local B;
										local A;
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
								elseif (Enum <= 173) then
									do
										return;
									end
								elseif (Enum == 174) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 180) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 178) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 179) then
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
							elseif (Enum <= 182) then
								if (Enum > 181) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 183) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 184) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3] ~= 0;
							end
						elseif (Enum <= 195) then
							if (Enum <= 190) then
								if (Enum <= 187) then
									if (Enum == 186) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 188) then
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
								elseif (Enum > 189) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 192) then
								if (Enum == 191) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 193) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 194) then
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
						elseif (Enum <= 200) then
							if (Enum <= 197) then
								if (Enum > 196) then
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
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
							elseif (Enum <= 198) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 199) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 203) then
							if (Enum <= 201) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 202) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						elseif (Enum == 205) then
							local Edx;
							local Results, Limit;
							local B;
							local A;
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
					elseif (Enum <= 227) then
						if (Enum <= 216) then
							if (Enum <= 211) then
								if (Enum <= 208) then
									if (Enum == 207) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum > 210) then
									local A;
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 213) then
								if (Enum == 212) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								end
							elseif (Enum <= 214) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
								local B;
								local A;
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
							end
						elseif (Enum <= 221) then
							if (Enum <= 218) then
								if (Enum > 217) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									local Edx;
									local Results;
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
								end
							elseif (Enum <= 219) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							elseif (Enum == 220) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 224) then
							if (Enum <= 222) then
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 223) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 225) then
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
						elseif (Enum == 226) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 237) then
						if (Enum <= 232) then
							if (Enum <= 229) then
								if (Enum == 228) then
									local B;
									local A;
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
							elseif (Enum <= 230) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum > 231) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 234) then
							if (Enum == 233) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum > 236) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
					elseif (Enum <= 242) then
						if (Enum <= 239) then
							if (Enum > 238) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							else
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							end
						elseif (Enum <= 240) then
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
						elseif (Enum == 241) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							local Results;
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
						end
					elseif (Enum <= 245) then
						if (Enum <= 243) then
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
						elseif (Enum == 244) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 246) then
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
					elseif (Enum == 247) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
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
							if (Mvm[1] == 35) then
								Indexes[Idx - 1] = {Stk,Mvm[3]};
							else
								Indexes[Idx - 1] = {Upvalues,Mvm[3]};
							end
							Lupvals[#Lupvals + 1] = Indexes;
						end
						Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
					end
				elseif (Enum <= 289) then
					if (Enum <= 268) then
						if (Enum <= 258) then
							if (Enum <= 253) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 251) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 252) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 255) then
								if (Enum > 254) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 256) then
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 257) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 263) then
							if (Enum <= 260) then
								if (Enum > 259) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								else
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 262) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum > 264) then
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
						elseif (Enum <= 266) then
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
						elseif (Enum == 267) then
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
					elseif (Enum <= 278) then
						if (Enum <= 273) then
							if (Enum <= 270) then
								if (Enum == 269) then
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
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 271) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 272) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 275) then
							if (Enum > 274) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 276) then
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
						elseif (Enum == 277) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 283) then
						if (Enum <= 280) then
							if (Enum == 279) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 281) then
							local A = Inst[2];
							do
								return Stk[A], Stk[A + 1];
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 286) then
						if (Enum <= 284) then
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
						elseif (Enum > 285) then
							local B;
							local A;
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
					elseif (Enum <= 287) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 310) then
					if (Enum <= 299) then
						if (Enum <= 294) then
							if (Enum <= 291) then
								if (Enum == 290) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 296) then
							if (Enum > 295) then
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 297) then
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
						elseif (Enum == 298) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local Results;
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
						end
					elseif (Enum <= 304) then
						if (Enum <= 301) then
							if (Enum == 300) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
					elseif (Enum <= 307) then
						if (Enum <= 305) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 306) then
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
					elseif (Enum <= 308) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 309) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
				elseif (Enum <= 320) then
					if (Enum <= 315) then
						if (Enum <= 312) then
							if (Enum > 311) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 313) then
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
						elseif (Enum == 314) then
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
							do
								return Unpack(Stk, A, Top);
							end
						end
					elseif (Enum <= 317) then
						if (Enum == 316) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
						end
					elseif (Enum <= 318) then
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					elseif (Enum > 319) then
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 325) then
					if (Enum <= 322) then
						if (Enum == 321) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 323) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 324) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 328) then
					if (Enum <= 326) then
						Stk[Inst[2]] = Inst[3] ~= 0;
						VIP = VIP + 1;
					elseif (Enum > 327) then
						if (Inst[2] == Stk[Inst[4]]) then
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
				elseif (Enum <= 329) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
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
				elseif (Enum > 330) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD98CC60CDDCCD82ED99FC20DC5D1CE26F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O00A8081355B22F1B5F81171946B23C1F5E990A0F4E99111543C3140F4C03043O002DED787A002E3O001247012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004623O000A00010012A6000300063O0020950004000300070012A6000500083O0020950005000500090012A6000600083O00209500060006000A0006F800073O000100062O00233O00064O00238O00233O00044O00233O00014O00233O00024O00233O00053O00209500080003000B00209500090003000C2O0001000A5O0012A6000B000D3O0006F8000C0001000100022O00233O000A4O00233O000B4O0023000D00073O001286000E000E3O001286000F000F4O0027010D000F00020006F8000E0002000100032O00233O00074O00233O00094O00233O00084O0099000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O007F00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00EF00076O0009000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00EF000C00034O005C000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0078000C6O00FD000A3O000200201E000A000A00022O00CE0009000A4O000E01073O000100040D0103000500012O00EF000300054O0023000400024O00DD000300044O003B01036O00AD3O00017O00093O00028O00026O00F03F025O0024AC40025O00C49640025O0076AA40025O00BBB140025O00A4AF40025O004EA440025O00C89F4001353O001286000200014O0050000300043O00264301020007000100010004623O00070001001286000300014O0050000400043O001286000200023O00262D0002000B000100020004623O000B0001002E9100030002000100040004623O00020001002E1601050029000100060004623O0029000100264301030029000100010004623O00290001001286000500014O0050000600063O00262D00050015000100010004623O00150001002E9100070011000100080004623O00110001001286000600013O00264301060022000100010004623O002200012O00EF00076O006D000400073O00067E00040021000100010004623O002100012O00EF000700014O002300086O006400096O005E00076O003B01075O001286000600023O00264301060016000100020004623O00160001001286000300023O0004623O002900010004623O001600010004623O002900010004623O00110001002E19000900E2FF2O00090004623O000B0001000E480102000B000100030004623O000B00012O0023000500044O006400066O005E00056O003B01055O0004623O000B00010004623O003400010004623O000200012O00AD3O00017O004B3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E307642722O033O009B210403073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703093O008572693B165BEC46BA03083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003053O0091C2D4180D03063O004BDCA3B76A6203053O0023B5AE18F703053O00B962DAEB5703053O00E81834C9F003063O00CAAB5C4786BE03043O000AC03F9C03043O00E849A14C03053O008BCB474E0D03053O007EDBB9223D03073O002FC1537F7179E003083O00876CAE3E121E179303083O0093FF2FD901A13DC203083O00A7D6894AAB78CE532O033O0085E53F03063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D903043O00CA212F8C03073O009CA84E40E0D47903073O00F8841CF8B6D2DC03073O00AFBBEB7195D9BC03083O0019B9845EFA2O763903073O00185CCFE12C831903073O007CD2AA40147E4003063O001D2BB3D82C7B030B3O0099DC3358AFCC2358B4D62E03043O002CDDB94003073O0036E65A537C02EC03053O00136187283F030B3O008A59202F3D24AD483A342103063O0051CE3C535B4F03073O0079AAC27E20C04603083O00C42ECBB0124FA32D030B3O009C276D0A36EEECAC2B711003073O008FD8421E7E449B028O00024O0080B3C54003103O005265676973746572466F724576656E7403143O009AE42CF2E091E8D38FEF28E5FA86F9C088E428EF03083O0081CAA86DABA5C3B7030E3O00114D3AD5D11ACF2C5E32CAD015EA03073O0086423857B8BE7403103O005265676973746572496E466C6967687403093O001F3908B40AC92E392803083O00555C5169DB798B41030A3O00D4BD534C72DAEFB2444003063O00BF9DD330251C03063O0053657441504C025O00B07040006E013O00B3000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100176O000F001100024O000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000E00134O00145O00122O001500203O00122O001600216O0014001600024O0014000E00142O00EF00155O001226011600223O00122O001700236O0015001700024O0015000E00154O00165O00122O001700243O00122O001800256O0016001800024O0015001500164O00165O00122O001700263O00122O001800276O0016001800024O0015001500164O00165O00122O001700283O00122O001800296O0016001800024O0016000E00164O00175O00122O0018002A3O00122O0019002B6O0017001900024O0016001600174O00175O00122O0018002C3O00122O0019002D6O0017001900024O0016001600174O00178O00188O00198O001A002A3O0006F8002B3O0001000D2O00233O00254O00EF8O00233O00264O00233O002A4O00233O00234O00233O00214O00233O00224O00233O001D4O00233O001A4O00233O001C4O00233O00204O00233O001E4O00233O001F4O00CC002C5O00122O002D002E3O00122O002E002F6O002C002E00024O002C000E002C4O002D5O00122O002E00303O00122O002F00316O002D002F00024O002C002C002D4O002D5O00122O002E00323O00122O002F00336O002D002F00024O002D000C002D4O002E5O00122O002F00343O00122O003000356O002E003000024O002D002D002E4O002E5O00122O002F00363O00122O003000376O002E003000024O002E000D002E4O002F5O00122O003000383O00122O003100396O002F003100024O002E002E002F4O002F8O00305O00122O0031003A3O00122O0032003B6O0030003200024O0030001000304O00315O00122O0032003C3O00122O0033003D6O0031003300024O0030003000314O003100326O00338O00348O00355O00122O0036003E3O00122O0037003F3O00122O0038003F3O00202O0039000400400006F8003B0001000100062O00233O00354O00233O00364O00233O00374O00233O00384O00233O00334O00233O00344O00E6003C5O00122O003D00413O00122O003E00426O003C003E6O00393O00014O00395O00122O003A00433O00122O003B00446O0039003B00024O0039002D003900202O0039003900454O0039000200014O00395O00122O003A00463O00122O003B00476O0039003B00024O0039002D003900202O0039003900454O0039000200014O00395O00122O003A00483O00122O003B00496O0039003B00024O0039002D003900202O0039003900454O0039000200010006F800390002000100012O00233O002D3O0006F8003A0003000100032O00233O00044O00EF8O00233O002D3O0006F8003B0004000100022O00233O00044O00EF7O0006F8003C0005000100032O00233O002D4O00233O00364O00233O00073O0006F8003D0006000100052O00233O002D4O00EF8O00EF3O00014O00233O00154O00EF3O00023O0006F8003E0007000100022O00233O002D4O00EF7O0006F8003F0008000100062O00233O002D4O00EF8O00233O00074O00233O00144O00233O00094O00233O00343O0006F800400009000100022O00233O002C4O00233O00193O0006F80041000A000100072O00233O002E4O00EF8O00233O00074O00233O002D4O00233O00144O00233O00304O00233O00403O0006F80042000B000100082O00233O003A4O00233O002D4O00EF8O00233O002C4O00233O00384O00EF3O00014O00EF3O00024O00233O00143O0006F80043000C0001000F2O00233O002D4O00EF8O00233O00074O00233O00144O00233O00094O00233O00364O00233O00324O00233O002C4O00233O00314O00233O003C4O00233O00304O00233O000B4O00EF3O00014O00233O00154O00EF3O00023O0006F80044000D000100172O00233O00334O00233O002D4O00EF8O00233O00094O00233O00144O00233O00194O00233O00074O00233O00384O00EF3O00014O00EF3O00024O00233O000B4O00233O00304O00233O003A4O00233O003B4O00233O002C4O00233O00314O00233O003D4O00233O001B4O00233O00414O00233O00424O00233O00354O00233O00364O00233O00433O0006F80045000E000100172O00233O002D4O00EF8O00233O00094O00233O00314O00233O000B4O00233O00144O00233O00304O00233O00384O00233O002C4O00233O003E4O00233O00074O00233O00194O00233O00424O00233O001B4O00233O00414O00233O00354O00233O00364O00233O00324O00EF3O00014O00233O00154O00EF3O00024O00233O00434O00233O003A3O0006F80046000F000100202O00233O00314O00233O00074O00233O00094O00233O00184O00233O00324O00233O00354O00233O00364O00233O00394O00233O002C4O00233O00374O00233O00044O00233O00384O00233O002D4O00EF8O00233O00144O00233O00194O00EF3O00014O00EF3O00024O00233O00304O00233O002A4O00233O003A4O00233O003B4O00233O000B4O00233O00414O00233O00424O00233O00454O00233O00174O00233O003F4O00233O00154O00233O00344O00233O00444O00233O002B3O0006F800470010000100032O00233O002D4O00EF8O00233O000E3O0020D00048000E004A00122O0049004B6O004A00466O004B00476O0048004B00016O00013O00113O00413O00028O00025O00C0A740025O00B0B140026O00F03F026O000840030C3O004570696353652O74696E677303083O00D5C0D929EFCBCA2E03043O005D86A5AD03093O008DE7CCCF35C0827BAA03083O001EDE92A1A25AAED203083O00D64B641EEC40771903043O006A852E10030A3O007C2161F76A415B345BCC03063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A92030B3O00705145F26783AF0A4F594803083O006B39362B9D15E6E7027O0040025O0058A040025O000AA04003083O0074C921C80D49CB2603053O006427AC55BC03123O008476AD8521BF6DA99407A56ABC933BA274BD03053O0053CD18D9E003083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FD1113D6A46E93C40B30DAA274B5C00A0903073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103163O0085A70541A4F9DABCBD3E4ABAF2F8A4A00541BAE2DCB803073O00AFCCC97124D68B03083O008BECCFD0B1E7DCD703043O00A4D889BB03113O00FAE330BEAFF00CE2E925BBA9F025D3EB3403073O006BB28651D2C69E03083O0034EBB1DA0EE0A2DD03043O00AE678EC5030A3O00633B5A0A245DF157244C03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E03103O006D4D000122EC1E5150021928F91B575003073O0072383E6549478D025O0090A040025O00BFB24003083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030D3O0085D811FC6CFEBEC91FFE7DDE9D03063O0096CDBD709018025O00BAB140025O00507840025O00E07040025O00D8984003083O002O0B96D2A336099103053O00CA586EE2A6030F3O00EB0A83FBC3CD08B2F8DECA008CDFFA03053O00AAA36FE29703083O002235A62C47392E0203073O00497150D2582E57030E3O00B43FC83AE28020D91AF49523C31703053O0087E14CAD72025O00649940025O00C4934000F53O0012863O00014O0050000100023O002E16010200EE000100030004623O00EE0001002643012O00EE000100040004623O00EE00010026432O010006000100010004623O00060001001286000200013O00264301020033000100050004623O003300010012A6000300064O005F000400013O00122O000500073O00122O000600086O0004000600024O0003000300044O000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300042O000300035O0012B4000300066O000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400062O00030025000100010004623O00250001001286000300014O0003000300023O00122O010300066O000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000400013O00122O000500113O00122O000600126O0004000600022O006D0003000300042O0003000300033O0004623O00F400010026430102006D000100130004623O006D0001001286000300013O00262D0003003A000100040004623O003A0001002E910014004B000100150004623O004B00010012A6000400064O005F000500013O00122O000600163O00122O000700176O0005000700024O0004000400054O000500013O00122O000600183O00122O000700196O0005000700024O00040004000500067E00040048000100010004623O00480001001286000400014O0003000400043O001286000200053O0004623O006D000100264301030036000100010004623O003600010012A6000400064O005F000500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400054O000500013O00122O0006001C3O00122O0007001D6O0005000700024O00040004000500067E0004005B000100010004623O005B0001001286000400014O0003000400053O0012B4000400066O000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O00040004000500062O0004006A000100010004623O006A0001001286000400014O0003000400063O001286000300043O0004623O003600010026430102009F000100010004623O009F0001001286000300013O00264301030083000100040004623O008300010012A6000400064O005F000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000500013O00122O000600243O00122O000700256O0005000700024O00040004000500067E00040080000100010004623O00800001001286000400014O0003000400073O001286000200043O0004623O009F000100264301030070000100010004623O007000010012A6000400064O002E010500013O00122O000600263O00122O000700276O0005000700024O0004000400054O000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000400083O00122O000400066O000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000400093O00122O000300043O0004623O00700001002E16012E00090001002F0004623O0009000100264301020009000100040004623O00090001001286000300014O0050000400043O002643010300A5000100010004623O00A50001001286000400013O002643010400BB000100040004623O00BB00010012A6000500064O005F000600013O00122O000700303O00122O000800316O0006000800024O0005000500064O000600013O00122O000700323O00122O000800336O0006000800024O00050005000600067E000500B8000100010004623O00B80001001286000500014O00030005000A3O001286000200133O0004623O0009000100262D000400BF000100010004623O00BF0001002E91003400A8000100350004623O00A80001001286000500013O002E91003600E0000100370004623O00E00001002643010500E0000100010004623O00E000010012A6000600064O005F000700013O00122O000800383O00122O000900396O0007000900024O0006000600074O000700013O00122O0008003A3O00122O0009003B6O0007000900024O00060006000700067E000600D2000100010004623O00D20001001286000600014O00030006000B3O00122O010600066O000700013O00122O0008003C3O00122O0009003D6O0007000900024O0006000600074O000700013O00122O0008003E3O00122O0009003F6O0007000900022O006D0006000600072O00030006000C3O001286000500043O002E16014100C0000100400004623O00C00001002643010500C0000100040004623O00C00001001286000400043O0004623O00A800010004623O00C000010004623O00A800010004623O000900010004623O00A500010004623O000900010004623O00F400010004623O000600010004623O00F40001002643012O0002000100010004623O00020001001286000100014O0050000200023O0012863O00043O0004623O000200012O00AD3O00017O000A3O00028O00026O00F03F025O00804940025O00C08C40025O0030A740025O00389F40027O0040025O001AA840025O006CA540024O0080B3C540002C3O0012863O00014O0050000100013O002643012O0002000100010004623O00020001001286000100013O00262D00010009000100020004623O00090001002E9100040018000100030004623O00180001001286000200013O00264301020011000100010004623O001100012O00B800036O000300035O001286000300014O0003000300013O001286000200023O00262D00020015000100020004623O00150001002E910005000A000100060004623O000A0001001286000100073O0004623O001800010004623O000A000100262D0001001C000100070004623O001C0001002E9100080021000100090004623O002100010012860002000A4O0003000200023O0012860002000A4O0003000200033O0004623O002B0001000E482O010005000100010004623O000500012O00B800026O0032010200046O00028O000200053O00122O000100023O00044O000500010004623O002B00010004623O000200012O00AD3O00017O000B3O00028O00025O00807740025O0046A040025O005FB040025O0040934003053O007061697273025O00849740025O0009B34003083O00446562752O66557003053O004861766F63030D3O00446562752O6652656D61696E7301373O001286000100014O0050000200023O000E0400010006000100010004623O00060001002E9100030002000100020004623O00020001001286000200013O00264301020007000100010004623O00070001001286000300014O0050000400043O0026430103000B000100010004623O000B0001001286000400013O002E160105000E000100040004623O000E00010026430104000E000100010004623O000E00010012A6000500064O002300066O00880005000200070004623O002B0001001286000900014O0050000A000A3O00262D0009001C000100010004623O001C0001002E1601080018000100070004623O001800012O006D000A3O00080020E7000B000A00094O000D5O00202O000D000D000A4O000B000D000200062O000B002B00013O0004623O002B00012O00B8000B00013O00202F010C000A000B4O000E5O00202O000E000E000A4O000C000E6O000B5O00044O002B00010004623O0018000100061D01050016000100010004623O001600012O00B800055O001286000600014O0019010500033O0004623O000E00010004623O000700010004623O000B00010004623O000700010004623O003600010004623O000200012O00AD3O00017O00093O00030E3O00F80AF50E3ED61EFA0F0EDE1DF81903053O005ABF7F947C03103O00518928126A892F1B5C923C166C8E211903043O007718E74E030E3O00B138A847D34E388C2BA058D2411D03073O0071E24DC52ABC2003083O00496E466C69676874026O003E40029O001D4O00BB9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O001B000100010004623O001B00012O00EF3O00024O002C2O0100013O00122O000200053O00122O000300066O0001000300028O000100206O00076O0002000200064O001A00013O0004623O001A00010012863O00083O00067E3O001B000100010004623O001B00010012863O00094O00733O00024O00AD3O00017O00053O00030E3O001D03F5A73E1FF5BB2922F5B7361303043O00D55A769403113O007922B5455D532BB94F694E3CB54244542003053O002D3B4ED436029O00104O00BB9O00000100013O00122O000200013O00122O000300026O0001000300028O00014O000100013O00122O000200033O00122O000300046O0001000300028O000100064O000E000100010004623O000E00010012863O00054O00733O00024O00AD3O00017O00073O0003113O00446562752O665265667265736861626C65030E3O00492O6D6F6C617465446562752O66030D3O00446562752O6652656D61696E73030B3O00536F756C53686172647350026O001240030A3O00446562752O66446F776E030B3O004861766F63446562752O6601213O0020E700013O00014O00035O00202O0003000300024O00010003000200062O0001001F00013O0004623O001F00010020A500013O00032O007A00035O00202O0003000300024O0001000300024O000200013O00062O0001001D000100020004623O001D00012O00EF000100023O0020A50001000100042O00610001000200020026E90001001D000100050004623O001D00010020A500013O00062O00EF00035O0020950003000300072O00272O010003000200067E0001001F000100010004623O001F00010020A500013O00062O00EF00035O0020950003000300022O00272O01000300020004623O001F00012O00462O016O00B8000100014O0073000100024O00AD3O00017O00153O0003123O003958978E9420ACFC33598E89933DB9F91F5803083O00907036E3EBE64ECD030B3O004973417661696C61626C6503113O00446562752O665265667265736861626C65030E3O00492O6D6F6C617465446562752O66030D3O00446562752O6652656D61696E73026O00084003093O0090291BFDD357AA3B0203063O003BD3486F9CB003093O006D86F72C4D8BFA3E4303043O004D2EE783030F3O00432O6F6C646F776E52656D61696E7303083O00895BA34C9C5DA44503043O0020DA34D603083O007D1824A4D7B9575F03083O003A2E7751C891D02503063O00068D29A4ACB003073O00564BEC50CCC9DD03083O00414E6289D882604403063O00EB122117E59E03083O004361737454696D65017F4O007000018O000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O00010002000200062O0001001000013O0004623O001000010020A500013O00042O00EF00035O0020950003000300052O00272O010003000200067E00010016000100010004623O001600010020A500013O00062O00EF00035O0020950003000300052O00272O01000300020026E90001007B000100070004623O007B00012O00EF00016O002C010200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100034O00010002000200062O0001002E00013O0004623O002E00012O00EF00016O0041010200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O00010002000200202O00023O00064O00045O00202O0004000400054O00020004000200062O0002007B000100010004623O007B00012O00EF00016O002C010200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O0001000100034O00010002000200062O0001007C00013O0004623O007C00012O00EF000100024O001001028O000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O00020002000C4O0002000200024O000300036O00048O000500013O00122O000600113O00122O000700126O0005000700024O00040004000500202O0004000400034O0004000200024O000400046O0003000200024O00048O000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O0004000400154O0004000200024O0003000300044O0001000300024O000200046O00038O000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O00030003000C4O0003000200024O000400036O00058O000600013O00122O000700113O00122O000800126O0006000800024O00050005000600202O0005000500034O0005000200024O000500056O0004000200024O00058O000600013O00122O000700133O00122O000800146O0006000800024O00050005000600202O0005000500154O0005000200024O0004000400054O0002000400024O00010001000200202O00023O00064O00045O00202O0004000400054O00020004000200062O0002007C000100010004623O007C00012O00462O016O00B8000100014O0073000100024O00AD3O00017O000D3O00030D3O00446562752O6652656D61696E73030E3O00492O6D6F6C617465446562752O66026O00144003093O0073BBD5BA53B6D8A85D03043O00DB30DAA1030B3O004973417661696C61626C6503093O00C7706848D843F9F77C03073O008084111C29BB2F030F3O00432O6F6C646F776E52656D61696E73030F3O002O3301335306160337520F340F285803053O003D6152665A03103O008F26AA45C952122DA923A445C15E2O0C03083O0069CC4ECB2BA7377E013A3O00204A2O013O00014O00035O00202O0003000300024O00010003000200262O00010036000100030004623O003600012O00EF00016O002C010200013O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O00010002000200062O0001001E00013O0004623O001E00012O00EF00016O0041010200013O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O00010002000200202O00023O00014O00045O00202O0004000400024O00020004000200062O00020036000100010004623O003600012O00EF00016O002C010200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O0001000100064O00010002000200062O0001003700013O0004623O003700012O00EF00018O000200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200202O0001000100094O00010002000200202O00023O00014O00045O00202O0004000400024O00020004000200062O00020037000100010004623O003700012O00462O016O00B8000100014O0073000100024O00AD3O00017O002D3O00028O00025O0050AE40025O00B6B140026O00F03F03083O00D40DEFC5C10BE8CC03043O00A987629A03073O004973526561647903093O00497343617374696E6703083O00536F756C46697265030E3O0049735370652O6C496E52616E6765025O0080A240025O00DAA34003153O00D8783158C235C1D9726444EF36CBC47A2655E9739C03073O00A8AB1744349D5303093O00D770E1AC26219EE77C03073O00E7941195CD454D030A3O0049734361737461626C65025O007DB240025O0007B04003093O0043617461636C79736D03093O004973496E52616E6765026O004440025O00DC9240025O00B1B04003153O0083A6D3FA54F399B4CABB47ED85A4C8F655FE94E79103063O009FE0C7A79B37027O0040025O00549F40025O00C2A340030A3O00DEFD3FDBF9F62ED3E3F603043O00B297935C030A3O00496E63696E657261746503163O0085F34F3B1C49688DE94972025E7F8FF2413013583AD403073O001AEC9D2C52722C025O00D08E40025O000AAC40025O005EA840025O00E07A4003133O0082B82A131C0DD554AAAC101F1016CE57ACA92603083O0031C5CA437E7364A7025O00D2A240025O0026A94003133O004772696D6F6972656F6653616372696669636503213O003049D6248F5F4C3264D02FBF455F3449D62F89555B774BCD2C835953355ACB69D203073O003E573BBF49E03600A23O0012863O00014O0050000100013O002E1601020002000100030004623O00020001002643012O0002000100010004623O00020001001286000100013O000E480104004E000100010004623O004E00012O00EF00026O002C010300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002E00013O0004623O002E00012O00EF000200023O00201F0102000200084O00045O00202O0004000400094O00020004000200062O0002002E000100010004623O002E00012O00EF000200034O005800035O00202O0003000300094O000400043O00202O00040004000A4O00065O00202O0006000600094O0004000600024O000400046O000500016O00020005000200062O00020029000100010004623O00290001002E91000C002E0001000B0004623O002E00012O00EF000200013O0012860003000D3O0012860004000E4O00DD000200044O003B01026O00EF00026O0002000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200114O00020002000200062O0002003A000100010004623O003A0001002E910012004D000100130004623O004D00012O00EF000200034O00C100035O00202O0003000300144O000400043O00202O00040004001500122O000600166O0004000600024O000400046O000500016O00020005000200062O00020048000100010004623O00480001002E1900170007000100180004623O004D00012O00EF000200013O001286000300193O0012860004001A4O00DD000200044O003B01025O0012860001001B3O00262D000100520001001B0004623O00520001002E19001C00260001001D0004623O007600012O00EF00026O002C010300013O00122O0004001E3O00122O0005001F6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200A100013O0004623O00A100012O00EF000200023O00201F0102000200084O00045O00202O0004000400204O00020004000200062O000200A1000100010004623O00A100012O00EF000200034O00F900035O00202O0003000300204O000400043O00202O00040004000A4O00065O00202O0006000600204O0004000600024O000400046O000500016O00020005000200062O000200A100013O0004623O00A100012O00EF000200013O00129C000300213O00122O000400226O000200046O00025O00044O00A10001002E1601230007000100240004623O000700010026432O010007000100010004623O00070001001286000200013O00262D0002007F000100040004623O007F0001002E1900250004000100260004623O00810001001286000100043O0004623O000700010026430102007B000100010004623O007B00012O00B800036O0040010300056O00038O000400013O00122O000500273O00122O000600286O0004000600024O00030003000400202O0003000300074O00030002000200062O0003009C00013O0004623O009C0001002E910029009C0001002A0004623O009C00012O00EF000300034O00EF00045O00209500040004002B2O006100030002000200063A0003009C00013O0004623O009C00012O00EF000300013O0012860004002C3O0012860005002D4O00DD000300054O003B01035O001286000200043O0004623O007B00010004623O000700010004623O00A100010004623O000200012O00AD3O00017O000C3O00028O00025O00108C40025O00BCA540030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574030D3O004F6E5573654578636C75646573026O004440026O00F03F025O0094A140025O00909B4003133O0048616E646C65426F2O746F6D5472696E6B6574025O00A8854000313O0012863O00013O000E482O01001B00013O0004623O001B0001001286000100013O000E0400010008000100010004623O00080001002E1601030016000100020004623O001600012O00EF00025O00201C00020002000500122O000300066O000400013O00122O000500076O000600066O00020006000200122O000200043O00122O000200043O00062O0002001500013O0004623O001500010012A6000200044O0073000200023O001286000100083O0026432O010004000100080004623O000400010012863O00083O0004623O001B00010004623O0004000100262D3O001F000100080004623O001F0001002E91000900010001000A0004623O000100012O00EF00015O0020E300010001000B00122O000200066O000300013O00122O000400076O000500056O00010005000200122O000100043O002E2O000C00090001000C0004623O003000010012A6000100043O00063A0001003000013O0004623O003000010012A6000100044O0073000100023O0004623O003000010004623O000100012O00AD3O00017O001D3O00028O00026O00F03F025O00C2A340025O00607B40025O005C9B40025O000C964003123O001E27D85E283CD05A2926DC552D1AD457252003043O003B4A4EB503123O004973457175692O706564416E64526561647903063O0042752O66557003103O0044656D6F6E6963506F77657242752O6603133O0016C42O57BC2BF55F57BC2BD8596EAA37D0544E03053O00D345B12O3A030B3O004973417661696C61626C6503103O004E6574686572506F7274616C42752O66030C3O0099E06DFDECD987EA6BE1E8C703063O00ABD78519958903123O0054696D65627265616368696E6754616C6F6E031B3O00F5C13FFFED22F943E2C03BF4E80FE843EDC73CBAE624F94FF2886003083O002281A8529A8F509C025O0056B04003133O00B6A73E064740AD80BF3C05414DBD9CA032055C03073O00E9E5D2536B282E025O003AB240025O00188340025O0081B240025O00ADB140025O000FB140025O002EAD4000883O0012863O00014O0050000100023O00262D3O0006000100020004623O00060001002E190003007D000100040004623O00810001000E482O010006000100010004623O00060001001286000200013O00264301020009000100010004623O00090001002E1601060044000100050004623O004400012O00EF00036O002C010400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003004400013O0004623O004400012O00EF000300023O00201F01030003000A4O000500033O00202O00050005000B4O00030005000200062O00030039000100010004623O003900012O00EF000300034O0002000400013O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O00030003000E4O00030002000200062O00030044000100010004623O004400012O00EF000300023O00201F01030003000A4O000500033O00202O00050005000F4O00030005000200062O00030039000100010004623O003900012O00EF000300034O0002000400013O00122O000500103O00122O000600116O0004000600024O00030003000400202O00030003000E4O00030002000200062O00030044000100010004623O004400012O00EF000300044O00EF000400053O0020950004000400122O006100030002000200063A0003004400013O0004623O004400012O00EF000300013O001286000400133O001286000500144O00DD000300054O003B01035O002E1900150043000100150004623O008700012O00EF000300034O002C010400013O00122O000500163O00122O000600176O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003005700013O0004623O005700012O00EF000300023O0020E700030003000A4O000500033O00202O00050005000B4O00030005000200062O0003008700013O0004623O00870001001286000300014O0050000400063O00262D0003005D000100010004623O005D0001002E9100180060000100190004623O00600001001286000400014O0050000500053O001286000300023O00262D00030064000100020004623O00640001002E91001A00590001001B0004623O005900012O0050000600063O002E91001D00740001001C0004623O00740001000E4801020074000100040004623O0074000100264301050069000100010004623O006900012O00EF000700064O00DB0007000100022O0023000600073O00063A0006008700013O0004623O008700012O0073000600023O0004623O008700010004623O006900010004623O0087000100264301040065000100010004623O00650001001286000500014O0050000600063O001286000400023O0004623O006500010004623O008700010004623O005900010004623O008700010004623O000900010004623O008700010004623O000600010004623O00870001002643012O0002000100010004623O00020001001286000100014O0050000200023O0012863O00023O0004623O000200012O00AD3O00017O00313O00028O00030E3O00F2573FDB0ACF6B3CD000D34C33DA03053O0065A12252B6030B3O004973417661696C61626C65030F3O0048616E646C65445053506F74696F6E025O00F4A240026O00F03F027O0040026O003540025O00CC9E4003093O00C42BF559797DC9ED2603073O00A68242873C1B11030A3O0049734361737461626C65030E3O00775FC3783F4A63C073355644CF7903053O0050242AAE15030F3O00432O6F6C646F776E52656D61696E73026O002440026O002040030E3O007D053A77412O1E74481525744F1C03043O001A2E705703093O0046697265626C2O6F6403103O00BF2AB971BDB34ABBBD63A870ACFF14E003083O00D4D943CB142ODF25030A3O00CA084BEDDEF08927E60A03083O004E886D399EBB82E2030E3O000D2AF4FC2O31D0FF383AEBFF3F3303043O00915E5F99026O002840030E3O00CED819D841B9D4C312D05CB9FCC103063O00D79DAD74B52E030A3O004265727365726B696E67025O00D4A640025O00907B4003113O0037B199E1DF27BF82FCDD75B78FE19A64E403053O00BA55D4EB92025O0050AC40025O00C0914003093O00E08D19F13DC84DD09803073O0038A2E1769E598E030E3O006F10CDA22DD6750BC6AA30D65D0903063O00B83C65A0CF42026O002E40030E3O00029771B13E8C55B237876EB2308E03043O00DC51E21C03093O00426C2O6F644675727903113O0011D98DF4EEF815C090E2AAC417C6C2AAB803063O00A773B5E29B8A025O00EC9F40025O00AEA44000FD4O00EF8O00DB3O00010002000EDA0001000E00013O0004623O000E00012O00EF3O00014O0002000100023O00122O000200023O00122O000300036O0001000300028O000100206O00046O0002000200064O00FC000100010004623O00FC00010012863O00014O0050000100013O002643012O0024000100010004623O00240001001286000200013O0026430102001F000100010004623O001F00012O00EF000300033O0020950003000300052O00DB0003000100022O0023000100033O002E1900060005000100060004623O001E000100063A0001001E00013O0004623O001E00012O0073000100023O001286000200073O00264301020013000100070004623O001300010012863O00073O0004623O002400010004623O00130001000E480108006A00013O0004623O006A0001002E16010900FC0001000A0004623O00FC00012O00EF000200014O002C010300023O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000D4O00020002000200062O000200FC00013O0004623O00FC00012O00EF000200044O004F000300056O000400016O000500023O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500202O0004000400104O00040002000200202O00040004001100122O000500126O0003000500024O000400066O000500016O000600023O00122O0007000E3O00122O0008000F6O0006000800024O00050005000600202O0005000500104O00050002000200202O00050005001100122O000600126O0004000600024O00030003000400062O00020051000100030004623O005100012O00EF000200043O000EDA0012005C000100020004623O005C00012O00EF000200044O00A1000300016O000400023O00122O000500133O00122O000600146O0004000600024O00030003000400202O0003000300104O00030002000200062O000200FC000100030004623O00FC00012O00EF000200074O007B000300013O00202O0003000300154O000400056O000600016O00020006000200062O000200FC00013O0004623O00FC00012O00EF000200023O00129C000300163O00122O000400176O000200046O00025O00044O00FC0001000E480107001000013O0004623O00100001001286000200013O002643010200F4000100010004623O00F400012O00EF000300014O002C010400023O00122O000500183O00122O000600196O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300B000013O0004623O00B000012O00EF000300044O0027000400056O000500016O000600023O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600202O0005000500104O00050002000200122O0006001C6O0004000600024O000500066O000600016O000700023O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O0006000600104O00060002000200122O0007001C6O0005000700024O00040004000500062O00030096000100040004623O009600012O00EF000300043O000EDA001C00A1000100030004623O00A100012O00EF000300044O00A1000400016O000500023O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O0004000400104O00040002000200062O000300B0000100040004623O00B000012O00EF000300074O006F000400013O00202O00040004001F4O000500066O000700016O00030007000200062O000300AB000100010004623O00AB0001002E91002000B0000100210004623O00B000012O00EF000300023O001286000400223O001286000500234O00DD000300054O003B01035O002E91002500F3000100240004623O00F300012O00EF000300014O002C010400023O00122O000500263O00122O000600276O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300F300013O0004623O00F300012O00EF000300044O004F000400056O000500016O000600023O00122O000700283O00122O000800296O0006000800024O00050005000600202O0005000500104O00050002000200202O00050005001100122O0006002A6O0004000600024O000500066O000600016O000700023O00122O000800283O00122O000900296O0007000900024O00060006000700202O0006000600104O00060002000200202O00060006001100122O0007002A6O0005000700024O00040004000500062O000300DB000100040004623O00DB00012O00EF000300043O000EDA002A00E6000100030004623O00E600012O00EF000300044O00A1000400016O000500023O00122O0006002B3O00122O0007002C6O0005000700024O00040004000500202O0004000400104O00040002000200062O000300F3000100040004623O00F300012O00EF000300074O007B000400013O00202O00040004002D4O000500066O000700016O00030007000200062O000300F300013O0004623O00F300012O00EF000300023O0012860004002E3O0012860005002F4O00DD000300054O003B01035O001286000200073O002E160130006D000100310004623O006D00010026430102006D000100070004623O006D00010012863O00083O0004623O001000010004623O006D00010004623O001000012O00AD3O00017O00993O00028O00025O00207640025O00F89740025O0068AD40025O000CB340025O00B8AC40025O00F88540030B3O009982A6D4B68CAFC0BB99AD03043O00B2DAEDC8030A3O0049734361737461626C6503093O0094B4E5DBB2A7E7D6A203043O00B0D6D586030B3O004973417661696C61626C6503083O0042752O66446F776E030D3O004261636B647261667442752O66030B3O00536F756C53686172647350026O00F03F026O001040030B3O00436F6E666C616772617465030E3O0049735370652O6C496E52616E676503133O00F7A2B8D2A4575EE6ACA2D1E85E58E2A2B594FA03073O003994CDD6B4C836025O00C6AD40025O00F0734003083O0021F22038501BEF3003053O0016729D555403083O00F7C406C87BFFBAC103073O00C8A4AB73A43D9603083O004361737454696D65026O000440025O00804740025O0008914003083O00536F756C4669726503113O00ADFB1649BCB8FD1140C3B6F5154A80FEA003053O00E3DE946325025O006C9540025O00A8A640030B3O00AF334AE45F038B2E45F65603063O0062EC5C24823303093O0086180FB141BAB436B003083O0050C4796CDA25C8D5025O00989140025O00807F4003143O00037C0C79470F8D1272167A0B068B167C013F1A5A03073O00EA6013621F2B6E030A3O002F1151CEA27799070B5703073O00EB667F32A7CC12030A3O0079AFF62A4A2B42A0E12603063O004E30C1954324030A3O00496E63696E6572617465025O0028AD40025O0020684003133O00391083114F350C810C447016810E4E335ED14E03053O0021507EE078025O0020AA40025O00D2A940027O004003103O00105A53F8F7365E76F3F43C5C54FFEB3603053O0099532O3296026O001240030F3O006F7774157DAC69587B7C1275A25F5803073O002D3D16137C13CB030A3O0054616C656E7452616E6B025O008AA640025O00149E4003103O004368612O6E656C44656D6F6E6669726503093O004973496E52616E6765026O004440025O00BEB140025O00E8984003193O00C21A0CFB0C75B5FE1608F80D7EBFC80008B50A71AFCE114DA303073O00D9A1726D956210025O00207540025O0062AB4003083O003B2D3573B075062503063O00147240581CDC025O0040514003093O00436173744379636C6503083O00492O6D6F6C61746503113O00492O6D6F6C6174654D6F7573656F76657203103O00380CDFBBF4D1A93441DAB5EEDFBE715903073O00DD5161B2D498B0026O000840026O008540026O007740025O00D88F40030A3O00062709CEFA320009D2F003053O0095544660A003073O004973526561647903063O0045786973747303043O004755494403073O0011080BE82A080203043O008D58666D03133O009E52CE7E1F2E46CEB547C2753B275FE0A25AD803083O00A1D333AA107A5D35025O00207240025O0074A540025O000C9E40025O00F9B14003103O005261696E6F6646697265437572736F7203153O00E9AFBB26C4A1B417FDA7A02DBBA6B33EF4ADF279A903043O00489BCED2030A3O00747B5D003C405C5D1C3603053O0053261A346E03133O0079012652590528407C1234524A02245251182903043O0026387747030B3O00C1EE51D82A50D0E759D93603063O0036938F38B64503063O0042752O665570030F3O005261696E6F664368616F7342752O6603073O00FF8FF94CCDD88E03053O00BFB6E19F29025O00EAAE40025O0066A04003153O003913215BB488C42O1421478EC7CA2A042756CBD69103073O00A24B724835EBE7025O004CAF40025O00288740025O006EA240025O002AAD40025O00F4B140025O00C4A240025O003CA040025O00606440025O0014B040025O0008874003093O00EEEF1CF409EFE811EF03053O007AAD877D9B03083O00A7D319913E27C78703073O00A8E4A160D95F5103073O00F2DF28593D59D403063O0037BBB14E3C4F03093O000EC65EE455ED8F21DA03073O00E04DAE3F8B26AF03093O004368616F73426F6C7403123O0087495921977E5A2188551826852O572DC41803043O004EE4213803093O00ED76B30C96EC71BE1703053O00E5AE1ED26303093O0038E5875EFE1F3617F903073O00597B8DE6318D5D03073O00DA7FF0090244FC03063O002A9311966C7003133O0022A72971E2FB1CA92B6BEFED2EBC275EF6E11D03063O00886FC64D1F8703073O002B07A153AFEA1803083O00C96269C736DD8477030B3O008B0D8A2F0D338FB10D8C3203073O00CCD96CE341625503133O007FD5F4F12DD251C5D1E03FD44CD6F6F125CF5003063O00A03EA395854C03133O00D5A80C20D0E9A20223D796A80C39CCD5E05C7F03053O00A3B6C06D4F00E5022O0012863O00014O0050000100013O002643012O0002000100010004623O00020001001286000100013O00262D00010009000100010004623O00090001002E9100030084000100020004623O00840001001286000200013O00262D0002000E000100010004623O000E0001002E910005007F000100040004623O007F0001001286000300013O002E910007007A000100060004623O007A00010026430103007A000100010004623O007A00012O00EF00046O002C010500013O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004004900013O0004623O004900012O00EF00046O002C010500013O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004004900013O0004623O004900012O00EF000400023O0020E700040004000E4O00065O00202O00060006000F4O00040006000200062O0004004900013O0004623O004900012O00EF000400023O0020A50004000400102O0061000400020002000E2000110049000100040004623O004900012O00EF000400023O0020A50004000400102O006100040002000200260901040049000100120004623O004900012O00EF000400034O001F00055O00202O0005000500134O000600043O00202O0006000600144O00085O00202O0008000800134O0006000800024O000600066O00040006000200062O0004004900013O0004623O004900012O00EF000400013O001286000500153O001286000600164O00DD000400064O003B01045O002E1601180079000100170004623O007900012O00EF00046O002C010500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004007900013O0004623O007900012O00EF00046O00CF000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004001D4O0004000200024O000500053O00062O00040079000100050004623O007900012O00EF000400023O0020A50004000400102O00610004000200020026E9000400790001001E0004623O00790001002E16011F0079000100200004623O007900012O00EF000400034O00F900055O00202O0005000500214O000600043O00202O0006000600144O00085O00202O0008000800214O0006000800024O000600066O000700016O00040007000200062O0004007900013O0004623O007900012O00EF000400013O001286000500223O001286000600234O00DD000400064O003B01045O001286000300113O0026430103000F000100110004623O000F0001001286000200113O0004623O007F00010004623O000F00010026430102000A000100110004623O000A0001001286000100113O0004623O008400010004623O000A000100262D00010088000100120004623O00880001002E91002500D9000100240004623O00D900012O00EF00026O002C010300013O00122O000400263O00122O000500276O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200AF00013O0004623O00AF00012O00EF00026O0002000300013O00122O000400283O00122O000500296O0003000500024O00020002000300202O00020002000D4O00020002000200062O000200AF000100010004623O00AF00012O00EF000200034O005100035O00202O0003000300134O000400043O00202O0004000400144O00065O00202O0006000600134O0004000600024O000400046O00020004000200062O000200AA000100010004623O00AA0001002E91002A00AF0001002B0004623O00AF00012O00EF000200013O0012860003002C3O0012860004002D4O00DD000200044O003B01026O00EF00026O002C010300013O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200E402013O0004623O00E402012O00EF00026O00CF000300013O00122O000400303O00122O000500316O0003000500024O00020002000300202O00020002001D4O0002000200024O000300053O00062O000200E4020100030004623O00E402012O00EF000200034O005800035O00202O0003000300324O000400043O00202O0004000400144O00065O00202O0006000600324O0004000600024O000400046O000500016O00020005000200062O000200D3000100010004623O00D30001002E1900330013020100340004623O00E402012O00EF000200013O00129C000300353O00122O000400366O000200046O00025O00044O00E402010026432O01003D2O0100110004623O003D2O01001286000200013O002E91003800E2000100370004623O00E20001002643010200E2000100110004623O00E20001001286000100393O0004623O003D2O01002643010200DC000100010004623O00DC00012O00EF00036O002C010400013O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400202O00030003000A4O00030002000200062O00032O002O013O0004624O002O012O00EF000300023O0020A50003000300102O00610003000200020026E900032O002O01003C0004624O002O012O00EF00036O0004010400013O00122O0005003D3O00122O0006003E6O0004000600024O00030003000400202O00030003003F4O00030002000200262O00032O002O0100390004624O002O012O00EF000300063O000EDA003900022O0100030004623O00022O01002E16014000152O0100410004623O00152O012O00EF000300034O00C100045O00202O0004000400424O000500043O00202O00050005004300122O000700446O0005000700024O000500056O000600016O00030006000200062O000300102O0100010004623O00102O01002E91004500152O0100460004623O00152O012O00EF000300013O001286000400473O001286000500484O00DD000300054O003B01035O002E910049003B2O01004A0004623O003B2O012O00EF00036O002C010400013O00122O0005004B3O00122O0006004C6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003B2O013O0004623O003B2O01002E19004D001A0001004D0004623O003B2O012O00EF000300073O00204C00030003004E4O00045O00202O00040004004F4O000500086O000600096O000700043O00202O0007000700144O00095O00202O00090009004F4O0007000900024O000700076O000800096O000A000A3O00202O000A000A00504O000B00016O0003000B000200062O0003003B2O013O0004623O003B2O012O00EF000300013O001286000400513O001286000500524O00DD000300054O003B01035O001286000200113O0004623O00DC000100262D000100412O0100530004623O00412O01002E19005400CF000100550004623O000E0201001286000200013O002643010200462O0100110004623O00462O01001286000100123O0004623O000E0201002E19005600FCFF2O00560004623O00422O01000E482O0100422O0100020004623O00422O01001286000300013O000E482O010006020100030004623O000602012O00EF00046O002C010500013O00122O000600573O00122O000700586O0005000700024O00040004000500202O0004000400594O00040002000200062O000400992O013O0004623O00992O012O00EF0004000B3O00063A000400992O013O0004623O00992O012O00EF0004000B3O0020A500040004005A2O006100040002000200063A000400992O013O0004623O00992O012O00EF0004000B3O00203001040004005B4O0004000200024O000500043O00202O00050005005B4O00050002000200062O000400992O0100050004623O00992O012O00EF000400064O00160005000C6O0006000D6O00078O000800013O00122O0009005C3O00122O000A005D6O0008000A00024O00070007000800202O00070007000D4O000700086O00063O000200102O0006001200064O0007000D6O00088O000900013O00122O000A005E3O00122O000B005F6O0009000B00024O00080008000900202O00080008000D4O000800096O00078O00053O00024O0006000E6O0007000D6O00088O000900013O00122O000A005C3O00122O000B005D6O0009000B00024O00080008000900202O00080008000D4O000800096O00073O000200102O0007001200074O0008000D6O00098O000A00013O00122O000B005E3O00122O000C005F6O000A000C00024O00090009000A00202O00090009000D4O0009000A6O00088O00063O00024O00050005000600062O00050003000100040004623O009B2O01002E16016100AF2O0100600004623O00AF2O01002E16016200AF2O0100630004623O00AF2O012O00EF000400034O00F90005000A3O00202O0005000500644O000600043O00202O0006000600144O00085O00202O0008000800134O0006000800024O000600066O000700016O00040007000200062O000400AF2O013O0004623O00AF2O012O00EF000400013O001286000500653O001286000600664O00DD000400064O003B01046O00EF00046O002C010500013O00122O000600673O00122O000700686O0005000700024O00040004000500202O0004000400594O00040002000200062O0004000502013O0004623O000502012O00EF0004000B3O00063A0004000502013O0004623O000502012O00EF0004000B3O0020A500040004005A2O006100040002000200063A0004000502013O0004623O000502012O00EF0004000B3O00203001040004005B4O0004000200024O000500043O00202O00050005005B4O00050002000200062O00040005020100050004623O000502012O00EF000400063O000E4E00110005020100040004623O000502012O00EF00046O0002000500013O00122O000600693O00122O0007006A6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400E72O0100010004623O00E72O012O00EF00046O002C010500013O00122O0006006B3O00122O0007006C6O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004000502013O0004623O000502012O00EF000400023O0020E700040004006D4O00065O00202O00060006006E4O00040006000200062O0004000502013O0004623O000502012O00EF00046O002C010500013O00122O0006006F3O00122O000700706O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004000502013O0004623O000502012O00EF000400034O00580005000A3O00202O0005000500644O000600043O00202O0006000600144O00085O00202O0008000800134O0006000800024O000600066O000700016O00040007000200062O00042O00020100010004624O000201002E1900710007000100720004623O000502012O00EF000400013O001286000500733O001286000600744O00DD000400064O003B01045O001286000300113O002E160176004B2O0100750004623O004B2O010026430103004B2O0100110004623O004B2O01001286000200113O0004623O00422O010004623O004B2O010004623O00422O01002E9100770005000100780004623O000500010026432O010005000100390004623O00050001001286000200014O0050000300033O00262D00020018020100010004623O00180201002E91007900140201007A0004623O00140201001286000300013O002E16017C001F0201007B0004623O001F02010026430103001F020100110004623O001F0201001286000100533O0004623O0005000100264301030019020100010004623O00190201002E16017E005E0201007D0004623O005E02012O00EF00046O002C010500013O00122O0006007F3O00122O000700806O0005000700024O00040004000500202O0004000400594O00040002000200062O0004005E02013O0004623O005E02012O00EF00046O002C010500013O00122O000600813O00122O000700826O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004005E02013O0004623O005E02012O00EF00046O0002000500013O00122O000600833O00122O000700846O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004005E020100010004623O005E02012O00EF00046O00CF000500013O00122O000600853O00122O000700866O0005000700024O00040004000500202O00040004001D4O0004000200024O000500053O00062O0004005E020100050004623O005E02012O00EF000400034O00F900055O00202O0005000500874O000600043O00202O0006000600144O00085O00202O0008000800874O0006000800024O000600066O000700016O00040007000200062O0004005E02013O0004623O005E02012O00EF000400013O001286000500883O001286000600894O00DD000400064O003B01046O00EF00046O002C010500013O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500202O0004000400594O00040002000200062O000400DD02013O0004623O00DD02012O00EF00046O00CF000500013O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O00040004001D4O0004000200024O000500053O00062O000400DD020100050004623O00DD02012O00EF000400064O00200105000C6O0006000D6O00078O000800013O00122O0009008E3O00122O000A008F6O0008000A00024O00070007000800202O00070007000D4O000700084O001000063O000200102O0006001200064O0007000D6O00088O000900013O00122O000A00903O00122O000B00916O0009000B00024O00080008000900202O00080008000D2O00CE000800094O007800076O00D700053O00024O0006000E6O0007000D6O00088O000900013O00122O000A008E3O00122O000B008F6O0009000B00024O00080008000900202O00080008000D2O00CE000800094O001000073O000200102O0007001200074O0008000D6O00098O000A00013O00122O000B00903O00122O000C00916O000A000C00024O00090009000A00202O00090009000D2O00CE0009000A4O007800086O00FD00063O00022O00EE0005000500062O00EF0006000D4O007000078O000800013O00122O000900923O00122O000A00936O0008000A00024O00070007000800202O00070007000D4O00070002000200062O000700C702013O0004623O00C702012O00EF00076O0002000800013O00122O000900943O00122O000A00956O0008000A00024O00070007000800202O00070007000D4O00070002000200062O000700C2020100010004623O00C202012O00EF00076O002C010800013O00122O000900963O00122O000A00976O0008000A00024O00070007000800202O00070007000D4O00070002000200062O000700C702013O0004623O00C702012O00EF000700023O0020A500070007006D2O00EF00095O00209500090009006E2O00270107000900022O00610006000200022O0097000500050006000681000400DD020100050004623O00DD02012O00EF000400034O00F900055O00202O0005000500874O000600043O00202O0006000600144O00085O00202O0008000800874O0006000800024O000600066O000700016O00040007000200062O000400DD02013O0004623O00DD02012O00EF000400013O001286000500983O001286000600994O00DD000400064O003B01045O001286000300113O0004623O001902010004623O000500010004623O001402010004623O000500010004623O00E402010004623O000200012O00AD3O00017O005D012O00028O00026O00F03F025O005C9240025O00D4AF40025O00449540025O0086B24003053O00C4A915CB5F03053O003C8CC863A4030F3O00432O6F6C646F776E52656D61696E73026O00244003063O00AAF51D2EA78A03053O00C2E7946446030B3O004973417661696C61626C65030B3O006543CFA5FAC9415EC0B7F303063O00A8262CA1C396030A3O0049734361737461626C65030C3O00B2F3836439E6B1348CFD987303083O0076E09CE2165088D6030D3O00446562752O6652656D61696E7303123O00526F6172696E67426C617A65446562752O66026O00F83F030B3O0061E157864EEF5E9243FA5C03043O00E0228E3903073O0043686172676573030B3O00FDA8CBDB7FF05A1CDFB3C003083O006EBEC7A5BD13913D030A3O004D617843686172676573025O0058AF40025O00D0AF40025O00BEAD40025O00F09340030B3O00436F6E666C616772617465030E3O0049735370652O6C496E52616E676503143O00D9E479EE87C6DDF976FC8E87D9E772E99DC29AB903063O00A7BA8B1788EB025O0058A140025O0009B140030F3O003EBC850814A6810214B4843F13B39C03043O006D7AD5E8030B3O00536F756C5368617264735002CD5OCC1240030F3O00CAFEAF35E0E4AB3FE0F6AE02E7F1B603043O00508E97C2027O0040030F3O0027CF7A490DD57E430DC77B7E0AC06303043O002C63A61703083O00432O6F6C646F776E030F3O0044696D656E73696F6E616C5269667403193O0078FE24333DB775F827373F9B6EFE2F2273A770F2282036E42803063O00C41C97495653026O002040025O00806C40030B3O002AA2337505AC3A6108B93803043O001369CD5D030B3O008A07D08733A80FCC802BAC03053O005FC968BEE1030B3O008CC4CFC8A3CAC6DCAEDFC403043O00AECFABA12O033O00474344030B3O00CEF103F5F4D6EAEC0CE7FD03063O00B78D9E6D9398025O0016B040025O00F4AB4003153O002F06E80A2008E11E2D1DE34C2F05E30D3A0CA6587803043O006C4C6986026O00224003093O000FD9C715E1E3E2463803083O002A4CB1A67A92A18D03073O0049735265616479030B3O00968510C25A79AB8E10C76D03063O0016C5EA65AE1903134O0035A1D273BCC4892B20ADD957B5DDA73C3DB703083O00E64D54C5BC16CFB703093O00DB15C5F788B3F133ED03083O00559974A69CECC19003093O004368616F73426F6C74025O00C6A640025O00D49D4003143O00A7E84CBCF73FA6EF41A7A403A8E54CA5E140F0B003063O0060C4802DD384025O00D08340025O00C6A14003093O0016857A50C18DBBD42103083O00B855ED1B3FB2CFD4026O00164003093O002B5108501B7B06531C03043O003F68396903083O004361737454696D6503093O00288FA54B18A5AB481F03043O00246BE7C4030A3O0054726176656C54696D65026O00E03F025O000C9140025O00C2A54003143O005EBDA3884E8AA08851A1E28451B0A39158F5F6D503043O00E73DD5C2026O001C4003103O00D2E22DB82BF4E608B328FEE42ABF37F403053O0045918A4CD6030E3O0054C6888BB01A79CCAC84BD1362DC03063O007610AF2OE9DF03133O00AA9234AFEF99728DA030A8FA996888903CB4E003073O001DEBE455DB8EEB030B3O001FC1A8D36341064135D1A903083O00325DB4DABD172E47030E3O00FDAC5A4357F546DDA5494245C84D03073O0028BEC43B2C24BC03103O004368612O6E656C44656D6F6E6669726503093O004973496E52616E6765026O004440031B3O003F4DDDBAF478010341D9B9F5730B3557D9F4F971083D53D9F4A92903073O006D5C25BCD49A1D030F3O0020E6A9C63F490DE0AAC23D680DE9B003063O003A648FC4A351031A3O001E4B2EA6315AEC0114432F9C2D40E31A5A412FA63E5FE04E491403083O006E7A2243C35F2985025O001EB240025O0030A64003093O0056B95A45C557BE575E03053O00B615D13B2A026O000C40025O00309440025O003EB14003143O00B45FC4123281B558C90961BDBB52C40B24FEE40F03063O00DED737A57D41026O001040025O006EAB40025O00A8A040030E3O003E2438700270243F33781F700C3D03063O001E6D51551D6D03063O0045786973747303043O004755494403143O0053752O6D6F6E496E6665726E616C437572736F7203193O00EC6459BB39D0C3F67F52B324D0FDF33157BA33DFEAFA3105EE03073O009C9F1134D656BE025O00208D40025O0008AF4003103O008DE7BCB2A0EAB198ABE22OB2A8E6AFB903043O00DCCE8FDD03043O00B468241903073O00B2E61D4D77B8AC030A3O0054616C656E7452616E6B030E3O00D1B70B1978F4FCBD2F1675FDE7AD03063O009895DE6A7B1703133O00FC30F757B4CF29F067B0CE32E456B6C92FF94D03053O00D5BD469623030B3O006D4066065B5A551B47506703043O00682F3514030E3O0080448013AF26AD4F800EB20EB74903063O006FC32CE17CDC025O00D0B140025O000CA540031B3O00DB4E017DA5AED4790476A6A4D6400961AEEBDB4A0572BDAE98145003063O00CBB8266013CB030B3O001A7C7747C238746B40DA3C03053O00AE5913192103083O0042752O66446F776E030D3O004261636B647261667442752O66025O00C6A340025O0002AF4003153O002C1D5C48FB860C3D13464BB784072A13444BB7D55903073O006B4F72322E97E7026O001440025O00108740025O0022A140025O00FEB140025O008CAA40025O00F49C40025O00389B40025O0014A340025O0008A44003093O00D0023D1181540165FE03083O001693634970E2387803093O0043617461636C79736D03123O00BB74F6F48EB46CF1F8CDBB79E7F49BBD35B403053O00EDD8158295025O0016B140025O0048B04003103O00A1465E51BECC52A64B5250BECF57904B03073O003EE22E2O3FD0A9030F3O00D718528A110A0B5BE8165B85161F2A03083O003E857935E37F6D4F025O00E0B140025O004AB340031A3O00131C33FBD8ABAE2F1037F8D9A0A4190637B5D5A2A7110237B58E03073O00C270745295B6CE025O00E4A640025O0048844003083O000AA75914E6EB1C3C03073O006E59C82C78A08203083O0098CC5E4A6543294803083O002DCBA32B26232A5B03083O00E18AC92FA1A046D703073O0034B2E5BC43E7C9030C3O00134E5116FE5224034D511EF203073O004341213064973C03063O0042752O66557003083O00536F756C4669726503133O00CCE8BBD4CCD9EEBCDDB3DCEBABD9E5DAA7FF8803053O0093BF87CEB8026O000840026O00184003093O0017B822E927922CEA2003043O008654D043030B3O0036BE87581AAF87481AA38803043O003C73CCE603113O004572616469636174696F6E446562752O6603093O00C432EA7FF418E47CF303043O0010875A8B03093O00777C073C5D7677586003073O0018341466532E3403083O00496E466C69676874025O00C89540025O00A06040026O007B40025O00F07E4003143O00C727202B1CFB2D2E281B842C2D210ED22A61765703053O006FA44F414403093O00E5D182D13DC8C9D59703063O008AA6B9E3BE4E030D3O004D61646E652O73432O42752O66025O00805040025O00C0964003143O00C87CC438411C1BC478D177512F1CCA62C077017303073O0079AB14A5573243025O00708B40025O002CA94003083O00F537AC3A9F0BD43D03063O0062A658D956D903063O00DBF7600983D103063O00BC2O961961E603133O00C9864A0E33EBD39B5A420FE1DF8849074CBE8803063O008DBAE93F626C025O00C06F40025O00B2A940030A3O00C2CBB2E8C0EED7B0F5CB03053O00AE8BA5D181025O002EA540025O00088640030A3O00496E63696E657261746503143O00AABDE12OC8066279B7B6A2C2CA06716EA6F3B69703083O0018C3D382A1A66310025O0094A340025O004CAA4003093O00745005D1447A0BD24303043O00BE373864025O00C05E40025O00508740025O005CB140025O00F08B4003143O0055A73D1100DCF159A3285E10EFF657B9395E42B503073O009336CF5C7E7383025O00809540025O0038824003083O00AD25ABCED452A68103073O00D2E448C6A1B83303093O00436173744379636C6503083O00492O6D6F6C61746503113O00492O6D6F6C6174654D6F7573656F766572025O00F6A240025O002EA34003123O003F44FE1F7FCF224CB3137FCB375FF650229C03063O00AE5629937013025O0082AA40025O0052A54003053O0073019B042603083O00CB3B60ED6B456F71030E3O001703A1EC3E2OFE2A10A9F33FF1DB03073O00B74476CC815190030C3O00432O6F6C646F776E446F776E030E3O003DB87DE9048C27A376E1198C0FA103063O00E26ECD10846B03053O007061697273025O004FB04003133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564030E3O004861766F634D6F7573656F766572030F3O00E3C2F6D642ABC0ECDC40FDC6A0881503053O00218BA380B9025O00E8B140025O00789D40025O004C9040025O00D0A140025O00D88440025O00C05140025O0082B140025O00D2A540025O00888140025O00A7B140025O00288540025O00689640025O0016A640025O00F8A340025O0044A840025O0044B340025O00049340025O00707F40025O00907B40025O0007B340025O004EAD40025O00D88640025O00A6A340025O00309C40025O0080A740025O00109E40025O00707240025O00DCB240025O00F49A40025O0069B040025O00CCA040025O0008A840025O003AB240025O00AC9F40025O00ACA740025O005AA940025O00DCAB40025O0086A440025O00D07740025O00B07140025O00C0B140030A3O0010A8B620843CA5C12DA303083O00A059C6D549EA59D7030F3O004275726E746F417368657342752O66030A3O00617FB7F7CB4D63B5EAC003053O00A52811D49E03093O00C6D1093C35C7D6042703053O004685B96853030B3O0042752O6652656D61696E73025O00508340025O00D8AD4003143O000D4B4723C70157453ECC4446482FC8124004789A03053O00A96425244A025O00BFB040026O005F4003093O00238FA35F13A5AD5C1403043O003060E7C2030F3O005261696E6F664368616F7342752O6603093O00EB520F220AFAA08FDC03083O00E3A83A6E4D79B8CF025O0012A440025O009CAE4003143O007834BE4FA2E473AA7728FF43BDDE70B37E7CED1403083O00C51B5CDF20D1BB1103093O002057C2F4107DCCF71703043O009B633FA3025O00A4A840025O00B89F4003143O0081D9A082AABB80DEAD99F9878ED4A09BBCC4D08703063O00E4E2B1C1EDD900BA062O0012863O00014O0050000100013O000E482O01000200013O0004623O00020001001286000100013O000E0400020009000100010004623O00090001002E16010400AC000100030004623O00AC0001001286000200014O0050000300033O00262D0002000F000100010004623O000F0001002E19000500FEFF2O00060004623O000B0001001286000300013O0026430103006B000100010004623O006B00012O00EF000400014O0039000500023O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O00040002000200262O000400260001000A0004623O002600012O00EF000400014O00BE000500023O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000D4O00040002000200044O002700012O004601046O00B8000400014O000300046O0070000400016O000500023O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500202O0004000400104O00040002000200062O0004005500013O0004623O005500012O00EF000400014O002C010500023O00122O000600113O00122O000700126O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004004300013O0004623O004300012O00EF000400033O0020260004000400134O000600013O00202O0006000600144O00040006000200262O00040057000100150004623O005700012O00EF000400014O0012010500023O00122O000600163O00122O000700176O0005000700024O00040004000500202O0004000400184O0004000200024O000500016O000600023O00122O000700193O0012860008001A4O00150006000800024O00050005000600202O00050005001B4O00050002000200062O00040057000100050004623O00570001002E91001D006A0001001C0004623O006A0001002E91001F006A0001001E0004623O006A00012O00EF000400044O001F000500013O00202O0005000500204O000600033O00202O0006000600214O000800013O00202O0008000800204O0006000800024O000600066O00040006000200062O0004006A00013O0004623O006A00012O00EF000400023O001286000500223O001286000600234O00DD000400064O003B01045O001286000300023O00264301030010000100020004623O00100001002E91002400A7000100250004623O00A700012O00EF000400053O00063A000400A700013O0004623O00A700012O00EF000400014O002C010500023O00122O000600263O00122O000700276O0005000700024O00040004000500202O0004000400104O00040002000200062O000400A700013O0004623O00A700012O00EF000400063O0020A50004000400282O00610004000200020026E9000400A7000100290004623O00A700012O00EF000400014O0013000500023O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O0004000400184O000400020002000E2O002C0096000100040004623O009600012O00EF000400074O00A1000500016O000600023O00122O0007002D3O00122O0008002E6O0006000800024O00050005000600202O00050005002F4O00050002000200062O000400A7000100050004623O00A700012O00EF000400044O001F000500013O00202O0005000500304O000600033O00202O0006000600214O000800013O00202O0008000800304O0006000800024O000600066O00040006000200062O000400A700013O0004623O00A700012O00EF000400023O001286000500313O001286000600324O00DD000400064O003B01045O0012860001002C3O0004623O00AC00010004623O001000010004623O00AC00010004623O000B00010026432O0100862O0100330004623O00862O01001286000200013O002643010200F4000100020004623O00F40001002E1900340041000100340004623O00F200012O00EF000300014O002C010400023O00122O000500353O00122O000600366O0004000600024O00030003000400202O0003000300104O00030002000200062O000300F200013O0004623O00F200012O00EF000300014O0035010400023O00122O000500373O00122O000600386O0004000600024O00030003000400202O0003000300184O0003000200024O000400016O000500023O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O00040004001B4O00040002000200202O00040004000200062O000400DF000100030004623O00DF00012O00EF000300074O0008000400063O00202O00040004003B4O0004000200024O000500016O000600023O00122O0007003C3O00122O0008003D6O0006000800024O00050005000600202O0005000500182O00610005000200022O0024000400040005000681000300F2000100040004623O00F200012O00EF000300044O0051000400013O00202O0004000400204O000500033O00202O0005000500214O000700013O00202O0007000700204O0005000700024O000500056O00030005000200062O000300ED000100010004623O00ED0001002E91003E00F20001003F0004623O00F200012O00EF000300023O001286000400403O001286000500414O00DD000300054O003B01035O001286000100423O0004623O00862O01002643010200AF000100010004623O00AF00012O00EF000300014O002C010400023O00122O000500433O00122O000600446O0004000600024O00030003000400202O0003000300454O00030002000200062O000300352O013O0004623O00352O012O00EF00035O00067E000300352O0100010004623O00352O012O00EF000300014O002C010400023O00122O000500463O00122O000600476O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300172O013O0004623O00172O012O00EF000300014O002C010400023O00122O000500483O00122O000600496O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300212O013O0004623O00212O012O00EF000300014O0002000400023O00122O0005004A3O00122O0006004B6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300352O0100010004623O00352O012O00EF000300044O0058000400013O00202O00040004004C4O000500033O00202O0005000500214O000700013O00202O00070007004C4O0005000700024O000500056O000600016O00030006000200062O000300302O0100010004623O00302O01002E16014D00352O01004E0004623O00352O012O00EF000300023O0012860004004F3O001286000500504O00DD000300054O003B01035O002E91005100842O0100520004623O00842O012O00EF000300014O002C010400023O00122O000500533O00122O000600546O0004000600024O00030003000400202O0003000300454O00030002000200062O000300842O013O0004623O00842O012O00EF000300073O0026E9000300842O0100550004623O00842O012O00EF000300074O009F000400086O000500016O000600023O00122O000700563O00122O000800576O0006000800024O00050005000600202O0005000500584O0005000200024O000600014O00EF000700023O0012F6000800593O00122O0009005A6O0007000900024O00060006000700202O00060006005B4O0006000200024O00050005000600122O0006005C6O0004000600024O000500094O00EF000600014O0012010700023O00122O000800563O00122O000900576O0007000900024O00060006000700202O0006000600584O0006000200024O000700016O000800023O00122O000900593O001286000A005A4O000B0108000A00024O00070007000800202O00070007005B4O0007000200024O00060006000700122O0007005C6O0005000700024O00040004000500062O000400842O0100030004623O00842O01002E91005D00842O01005E0004623O00842O012O00EF000300044O00F9000400013O00202O00040004004C4O000500033O00202O0005000500214O000700013O00202O00070007004C4O0005000700024O000500056O000600016O00030006000200062O000300842O013O0004623O00842O012O00EF000300023O0012860004005F3O001286000500604O00DD000300054O003B01035O001286000200023O0004623O00AF00010026432O010017020100610004623O00170201001286000200013O002643010200ED2O0100010004623O00ED2O012O00EF000300014O002C010400023O00122O000500623O00122O000600636O0004000600024O00030003000400202O0003000300104O00030002000200062O000300CE2O013O0004623O00CE2O012O00EF000300014O002C010400023O00122O000500643O00122O000600656O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300BD2O013O0004623O00BD2O012O00EF000300014O002C010400023O00122O000500663O00122O000600676O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300BD2O013O0004623O00BD2O012O00EF000300014O0002000400023O00122O000500683O00122O000600696O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300CE2O0100010004623O00CE2O012O00EF000300014O0002000400023O00122O0005006A3O00122O0006006B6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300CE2O0100010004623O00CE2O012O00EF000300044O008E000400013O00202O00040004006C4O000500033O00202O00050005006D00122O0007006E6O0005000700024O000500056O000600016O00030006000200062O000300CE2O013O0004623O00CE2O012O00EF000300023O0012860004006F3O001286000500704O00DD000300054O003B01036O00EF000300053O00063A000300EC2O013O0004623O00EC2O012O00EF000300014O002C010400023O00122O000500713O00122O000600726O0004000600024O00030003000400202O0003000300104O00030002000200062O000300EC2O013O0004623O00EC2O012O00EF000300044O001F000400013O00202O0004000400304O000500033O00202O0005000500214O000700013O00202O0007000700304O0005000700024O000500056O00030005000200062O000300EC2O013O0004623O00EC2O012O00EF000300023O001286000400733O001286000500744O00DD000300054O003B01035O001286000200023O002E91007600892O0100750004623O00892O01002643010200892O0100020004623O00892O012O00EF000300014O002C010400023O00122O000500773O00122O000600786O0004000600024O00030003000400202O0003000300454O00030002000200062O00032O0002013O0004624O0002012O00EF000300063O0020A50003000300282O0061000300020002000EDA0079002O020100030004623O002O0201002E16017B00140201007A0004623O001402012O00EF000300044O00F9000400013O00202O00040004004C4O000500033O00202O0005000500214O000700013O00202O00070007004C4O0005000700024O000500056O000600016O00030006000200062O0003001402013O0004623O001402012O00EF000300023O0012860004007C3O0012860005007D4O00DD000300054O003B01035O001286000100333O0004623O001702010004623O00892O010026432O0100D10201007E0004623O00D10201001286000200014O0050000300033O000E482O01001B020100020004623O001B0201001286000300013O002E19007F00800001007F0004623O009E02010026430103009E020100010004623O009E0201002E190080002A000100800004623O004C02012O00EF000400053O00063A0004004C02013O0004623O004C02012O00EF000400014O002C010500023O00122O000600813O00122O000700826O0005000700024O00040004000500202O0004000400104O00040002000200062O0004004C02013O0004623O004C02012O00EF0004000A3O00063A0004004C02013O0004623O004C02012O00EF0004000A3O0020A50004000400832O006100040002000200063A0004004C02013O0004623O004C02012O00EF0004000A3O0020300104000400844O0004000200024O000500033O00202O0005000500844O00050002000200062O0004004C020100050004623O004C02012O00EF000400044O00EF0005000B3O0020950005000500852O006100040002000200063A0004004C02013O0004623O004C02012O00EF000400023O001286000500863O001286000600874O00DD000400064O003B01045O002E910088009D020100890004623O009D02012O00EF000400014O002C010500023O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500202O0004000400104O00040002000200062O0004009D02013O0004623O009D02012O00EF000400014O000C000500023O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O00040004008E4O000400020002000E2O0002009D020100040004623O009D02012O00EF000400014O002C010500023O00122O0006008F3O00122O000700906O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004008A02013O0004623O008A02012O00EF000400014O002C010500023O00122O000600913O00122O000700926O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004008A02013O0004623O008A02012O00EF000400014O0002000500023O00122O000600933O00122O000700946O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004009D020100010004623O009D02012O00EF000400014O0002000500023O00122O000600953O00122O000700966O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004009D020100010004623O009D02012O00EF000400044O00C1000500013O00202O00050005006C4O000600033O00202O00060006006D00122O0008006E6O0006000800024O000600066O000700016O00040007000200062O00040098020100010004623O00980201002E910097009D020100980004623O009D02012O00EF000400023O001286000500993O0012860006009A4O00DD000400064O003B01045O001286000300023O0026430103001E020100020004623O001E02012O00EF000400014O002C010500023O00122O0006009B3O00122O0007009C6O0005000700024O00040004000500202O0004000400104O00040002000200062O000400CC02013O0004623O00CC02012O00EF000400063O0020E700040004009D4O000600013O00202O00060006009E4O00040006000200062O000400CC02013O0004623O00CC02012O00EF000400063O0020A50004000400282O0061000400020002000E20001500CC020100040004623O00CC02012O00EF00045O00067E000400CC020100010004623O00CC02012O00EF000400044O0051000500013O00202O0005000500204O000600033O00202O0006000600214O000800013O00202O0008000800204O0006000800024O000600066O00040006000200062O000400C7020100010004623O00C70201002E9100A000CC0201009F0004623O00CC02012O00EF000400023O001286000500A13O001286000600A24O00DD000400064O003B01045O001286000100A33O0004623O00D102010004623O001E02010004623O00D102010004623O001B020100262D000100D50201002C0004623O00D50201002E1601A50088030100A40004623O00880301001286000200014O0050000300033O002E9100A700D7020100A60004623O00D70201002643010200D7020100010004623O00D70201001286000300013O002E1601A90032030100A80004623O0032030100264301030032030100010004623O00320301001286000400013O002643010400E5020100020004623O00E50201001286000300023O0004623O0032030100262D000400E9020100010004623O00E90201002E1601AB00E1020100AA0004623O00E102012O00EF000500053O00063A0005000703013O0004623O000703012O00EF000500014O002C010600023O00122O000700AC3O00122O000800AD6O0006000800024O00050005000600202O0005000500104O00050002000200062O0005000703013O0004623O000703012O00EF000500044O001F000600013O00202O0006000600AE4O000700033O00202O0007000700214O000900013O00202O0009000900AE4O0007000900024O000700076O00050007000200062O0005000703013O0004623O000703012O00EF000500023O001286000600AF3O001286000700B04O00DD000500074O003B01055O002E9100B20030030100B10004623O003003012O00EF000500014O002C010600023O00122O000700B33O00122O000800B46O0006000800024O00050005000600202O0005000500104O00050002000200062O0005003003013O0004623O003003012O00EF000500014O002C010600023O00122O000700B53O00122O000800B66O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005003003013O0004623O003003012O00EF000500044O00C1000600013O00202O00060006006C4O000700033O00202O00070007006D00122O0009006E6O0007000900024O000700076O000800016O00050008000200062O0005002B030100010004623O002B0301002E1601B80030030100B70004623O003003012O00EF000500023O001286000600B93O001286000700BA4O00DD000500074O003B01055O001286000400023O0004623O00E10201002E1601BC00DC020100BB0004623O00DC0201002643010300DC020100020004623O00DC02012O00EF000400014O002C010500023O00122O000600BD3O00122O000700BE6O0005000700024O00040004000500202O0004000400104O00040002000200062O0004008303013O0004623O008303012O00EF000400063O0020A50004000400282O006100040002000200260901040083030100790004623O008303012O00EF000400033O00203F0004000400134O000600013O00202O0006000600144O0004000600024O000500016O000600023O00122O000700BF3O00122O000800C06O0006000800024O0005000500060020A50005000500582O00D50005000200024O000600016O000700023O00122O000800C13O00122O000900C26O0007000900024O00060006000700202O00060006005B4O0006000200024O0005000500060006220005006E030100040004623O006E03012O00EF000400014O0002000500023O00122O000600C33O00122O000700C46O0005000700024O00040004000500202O00040004000D4O00040002000200062O00040083030100010004623O008303012O00EF000400063O0020E70004000400C54O000600013O00202O00060006009E4O00040006000200062O0004008303013O0004623O008303012O00EF00045O00067E00040083030100010004623O008303012O00EF000400044O00F9000500013O00202O0005000500C64O000600033O00202O0006000600214O000800013O00202O0008000800C64O0006000800024O000600066O000700016O00040007000200062O0004008303013O0004623O008303012O00EF000400023O001286000500C73O001286000600C84O00DD000400064O003B01045O001286000100C93O0004623O008803010004623O00DC02010004623O008803010004623O00D702010026432O01002B040100CA0004623O002B0401001286000200013O002643010200F9030100010004623O00F903012O00EF000300014O002C010400023O00122O000500CB3O00122O000600CC6O0004000600024O00030003000400202O0003000300454O00030002000200062O000300BD03013O0004623O00BD03012O00EF000300014O002C010400023O00122O000500CD3O00122O000600CE6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300BD03013O0004623O00BD03012O00EF00035O00067E000300BD030100010004623O00BD03012O00EF000300033O0020D40003000300134O000500013O00202O0005000500CF4O0003000500024O000400016O000500023O00122O000600D03O00122O000700D16O0005000700024O00040004000500202O0004000400584O00040002000200062O000300BD030100040004623O00BD03012O00EF000300014O002C010400023O00122O000500D23O00122O000600D36O0004000600024O00030003000400202O0003000300D44O00030002000200062O000300BF03013O0004623O00BF0301002E1601D500D3030100D60004623O00D303012O00EF000300044O0058000400013O00202O00040004004C4O000500033O00202O0005000500214O000700013O00202O00070007004C4O0005000700024O000500056O000600016O00030006000200062O000300CE030100010004623O00CE0301002E1900D70007000100D80004623O00D303012O00EF000300023O001286000400D93O001286000500DA4O00DD000300054O003B01036O00EF000300014O002C010400023O00122O000500DB3O00122O000600DC6O0004000600024O00030003000400202O0003000300454O00030002000200062O000300F803013O0004623O00F803012O00EF000300063O0020E70003000300C54O000500013O00202O0005000500DD4O00030005000200062O000300F803013O0004623O00F80301002E1601DE00F8030100DF0004623O00F803012O00EF000300044O00F9000400013O00202O00040004004C4O000500033O00202O0005000500214O000700013O00202O00070007004C4O0005000700024O000500056O000600016O00030006000200062O000300F803013O0004623O00F803012O00EF000300023O001286000400E03O001286000500E14O00DD000300054O003B01035O001286000200023O00262D000200FD030100020004623O00FD0301002E9100E3008B030100E20004623O008B03012O00EF000300014O002C010400023O00122O000500E43O00122O000600E56O0004000600024O00030003000400202O0003000300104O00030002000200062O0003002804013O0004623O002804012O00EF000300063O0020A50003000300282O0061000300020002002609010300280401007E0004623O002804012O00EF000300014O002C010400023O00122O000500E63O00122O000600E76O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003002804013O0004623O002804012O00EF000300044O00F9000400013O00202O0004000400C64O000500033O00202O0005000500214O000700013O00202O0007000700C64O0005000700024O000500056O000600016O00030006000200062O0003002804013O0004623O002804012O00EF000300023O001286000400E83O001286000500E94O00DD000300054O003B01035O001286000100613O0004623O002B04010004623O008B030100262D0001002F040100420004623O002F0401002E9100EB004E040100EA0004623O004E04012O00EF000200014O0002000300023O00122O000400EC3O00122O000500ED6O0003000500024O00020002000300202O0002000200104O00020002000200062O0002003B040100010004623O003B0401002E9100EE00B9060100EF0004623O00B906012O00EF000200044O00F9000300013O00202O0003000300F04O000400033O00202O0004000400214O000600013O00202O0006000600F04O0004000600024O000400046O000500016O00020005000200062O000200B906013O0004623O00B906012O00EF000200023O00129C000300F13O00122O000400F26O000200046O00025O00044O00B9060100262D00010052040100C90004623O00520401002E9100F4001B050100F30004623O001B0501001286000200014O0050000300033O000E482O010054040100020004623O00540401001286000300013O00264301030088040100020004623O008804012O00EF000400014O002C010500023O00122O000600F53O00122O000700F66O0005000700024O00040004000500202O0004000400454O00040002000200062O0004007004013O0004623O007004012O00EF0004000C4O00DB000400010002000EDA00010072040100040004623O007204012O00EF0004000D4O00DB000400010002000EDA00010072040100040004623O007204012O00EF000400063O0020A50004000400282O0061000400020002000ED6007E0072040100040004623O00720401002E1601F80086040100F70004623O008604012O00EF000400044O0058000500013O00202O00050005004C4O000600033O00202O0006000600214O000800013O00202O00080008004C4O0006000800024O000600066O000700016O00040007000200062O00040081040100010004623O00810401002E9100F90086040100FA0004623O008604012O00EF000400023O001286000500FB3O001286000600FC4O00DD000400064O003B01045O0012860001007E3O0004623O001B0501002E1601FE0057040100FD0004623O0057040100264301030057040100010004623O005704012O00EF000400014O002C010500023O00122O000600FF3O00122O00072O00015O0005000700024O00040004000500202O0004000400104O00040002000200062O000400B604013O0004623O00B604012O00EF0004000E3O0012B50005002O015O0004000400054O000500013O00122O00060002015O0005000500064O0006000F6O000700106O000800033O00202O0008000800214O000A00013O001286000B0002013O0068000A000A000B4O0008000A00024O000800086O0009000A6O000B000B3O00122O000C0003015O000B000B000C4O000C00016O0004000C000200062O000400B1040100010004623O00B1040100128600040004012O00128600050005012O000600010400B6040100050004623O00B604012O00EF000400023O00128600050006012O00128600060007013O00DD000400064O003B01045O00128600040008012O00128600050009012O00064501050017050100040004623O001705012O00EF000400014O002C010500023O00122O0006000A012O00122O0007000B015O0005000700024O00040004000500202O0004000400104O00040002000200062O0004001705013O0004623O001705012O00EF000400014O0083000500023O00122O0006000C012O00122O0007000D015O0005000700024O00040004000500122O0006000E015O0004000400064O00040002000200062O000400D9040100010004623O00D904012O00EF000400014O0002000500023O00122O0006000F012O00122O00070010015O0005000700024O00040004000500202O00040004000D4O00040002000200062O00040017050100010004623O00170501001286000400014O0050000500053O001286000600013O000600010400DB040100060004623O00DB04012O00EF000600033O0020F20006000600844O0006000200024O000500063O00122O00060011015O0007000F6O00060002000800044O00130501001286000B0012012O001286000C0012012O000600010B00130501000C0004623O001305010020A5000B000A00842O0061000B0002000200066B000B0013050100050004623O001305012O00EF000B000A3O00063A000B001305013O0004623O001305012O00EF000B000A3O0020A5000B000B00832O0061000B0002000200063A000B001305013O0004623O001305010020A5000B000A00842O002C000B000200024O000C000A3O00202O000C000C00844O000C0002000200062O000B00130501000C0004623O00130501001286000D0013013O00C5000B000A000D2O0061000B0002000200067E000B0013050100010004623O00130501001286000D0014013O00C5000B000A000D2O0061000B0002000200067E000B0013050100010004623O001305012O00EF000B00044O000E000C000B3O00122O000D0015015O000C000C000D4O000B0002000200062O000B001305013O0004623O001305012O00EF000B00023O001286000C0016012O001286000D0017013O00DD000B000D4O003B010B5O00061D010600E6040100020004623O00E604010004623O001705010004623O00DB0401001286000300023O0004623O005704010004623O001B05010004623O0054040100128600020018012O00128600030019012O000681000300F6050100020004623O00F60501001286000200013O0006002O0100F6050100020004623O00F60501001286000200013O001286000300013O00066B0002002A050100030004623O002A05010012860003001A012O0012860004001B012O000645010400A1050100030004623O00A10501001286000300013O001286000400023O00066B00030032050100040004623O003205010012860004001C012O0012860005001D012O00068100040034050100050004623O00340501001286000200023O0004623O00A10501001286000400013O00066B0003003B050100040004623O003B05010012860004001E012O0012860005001F012O0006810004002B050100050004623O002B050100128600040020012O00128600050021012O0006810004004E050100050004623O004E05012O00EF000400053O00063A0004004E05013O0004623O004E05012O00EF000400113O00063A0004004E05013O0004623O004E05012O00EF000400124O00DB00040001000200067E0004004D050100010004623O004D050100128600050022012O00128600060023012O0006000105004E050100060004623O004E05012O0073000400023O00128600040024012O00128600050024012O0006000104009F050100050004623O009F05012O00EF000400053O00063A0004009F05013O0004623O009F0501001286000400014O0050000500073O00128600080025012O00128600090025012O00060001080094050100090004623O00940501001286000800023O00060001040094050100080004623O009405012O0050000700073O001286000800023O00066B00050066050100080004623O0066050100128600080026012O00128600090027012O0006450109007A050100080004623O007A0501001286000800013O00066B0006006D050100080004623O006D050100128600080028012O00128600090029012O00064501080066050100090004623O006605012O00EF000800134O00DB0008000100022O0023000700083O00067E00070076050100010004623O007605010012860008002A012O0012860009002B012O0006450109009F050100080004623O009F05012O0073000700023O0004623O009F05010004623O006605010004623O009F0501001286000800013O0006000108005F050100050004623O005F0501001286000800013O0012860009002C012O001286000A002D012O000681000A0087050100090004623O00870501001286000900023O00060001080087050100090004623O00870501001286000500023O0004623O005F0501001286000900013O00066B0008008E050100090004623O008E05010012860009002E012O001286000A002F012O0006810009007E0501000A0004623O007E0501001286000600014O0050000700073O001286000800023O0004623O007E05010004623O005F05010004623O009F050100128600080030012O00128600090031012O00068100090057050100080004623O00570501001286000800013O00060001040057050100080004623O00570501001286000500014O0050000600063O001286000400023O0004623O00570501001286000300023O0004623O002B050100128600030032012O00128600040032012O00060001030023050100040004623O00230501001286000300023O00060001020023050100030004623O0023050100128600030033012O00128600040034012O000645010400F3050100030004623O00F305012O00EF000300143O00063A000300F305013O0004623O00F305012O00EF000300154O00EF000400063O0020A500040004003B2O0061000400020002000681000400F3050100030004623O00F30501001286000300014O0050000400063O001286000700013O00066B000300BE050100070004623O00BE050100128600070035012O00128600080036012O000681000700C1050100080004623O00C10501001286000400014O0050000500053O001286000300023O001286000700023O000600010300B7050100070004623O00B705012O0050000600063O001286000700013O000600010700D9050100040004623O00D90501001286000700013O001286000800023O00066B000700D0050100080004623O00D0050100128600080037012O00128600090038012O000645010900D2050100080004623O00D20501001286000400023O0004623O00D90501001286000800013O000600010800C9050100070004623O00C90501001286000500014O0050000600063O001286000700023O0004623O00C90501001286000700023O000600010400C5050100070004623O00C50501001286000700013O00066B000500E3050100070004623O00E3050100128600070039012O0012860008003A012O000645010800DC050100070004623O00DC05012O00EF000700164O00210107000100024O000600073O00122O0007003B012O00122O0008003C012O00062O000700F3050100080004623O00F3050100063A000600F305013O0004623O00F305012O0073000600023O0004623O00F305010004623O00DC05010004623O00F305010004623O00C505010004623O00F305010004623O00B70501001286000100023O0004623O00F605010004623O00230501001286000200A33O00066B000200FD050100010004623O00FD05010012860002003D012O0012860003003E012O00064501020005000100030004623O000500010012860002003F012O00128600030040012O00068100020056060100030004623O005606012O00EF000200014O002C010300023O00122O00040041012O00122O00050042015O0003000500024O00020002000300202O0002000200104O00020002000200062O0002005606013O0004623O005606012O00EF000200063O0020E40002000200C54O000400013O00122O00050043015O0004000400054O00020004000200062O0002005606013O0004623O005606012O00EF000200084O0022010300016O000400023O00122O00050044012O00122O00060045015O0004000600024O00030003000400202O0003000300584O0003000200024O000400016O000500023O00122O00060046012O00122O00070047015O0005000700024O00040004000500202O0004000400584O000400056O00023O00024O000300096O000400016O000500023O00122O00060044012O00122O00070045015O0005000700024O00040004000500202O0004000400584O0004000200024O000500016O000600023O00122O00070046012O00122O00080047015O0006000800024O00050005000600202O0005000500584O000500066O00033O00024O0002000200034O000300063O00122O00050048015O0003000300054O000500013O00202O0005000500DD4O00030005000200062O00020056060100030004623O0056060100128600020049012O0012860003004A012O00068100020056060100030004623O005606012O00EF000200044O00F9000300013O00202O0003000300F04O000400033O00202O0004000400214O000600013O00202O0006000600F04O0004000600024O000400046O000500016O00020005000200062O0002005606013O0004623O005606012O00EF000200023O0012860003004B012O0012860004004C013O00DD000200044O003B01025O0012860002004D012O0012860003004E012O0006450103008B060100020004623O008B06012O00EF000200014O002C010300023O00122O0004004F012O00122O00050050015O0003000500024O00020002000300202O0002000200454O00020002000200062O0002008B06013O0004623O008B06012O00EF000200063O00126700040048015O0002000200044O000400013O00122O00050051015O0004000400054O0002000400022O00A1000300016O000400023O00122O00050052012O00122O00060053015O0004000600024O00030003000400202O0003000300584O00030002000200062O0003008B060100020004623O008B060100128600020054012O00128600030055012O0006450102008B060100030004623O008B06012O00EF000200044O00F9000300013O00202O00030003004C4O000400033O00202O0004000400214O000600013O00202O00060006004C4O0004000600024O000400046O000500016O00020005000200062O0002008B06013O0004623O008B06012O00EF000200023O00128600030056012O00128600040057013O00DD000200044O003B01026O00EF000200014O002C010300023O00122O00040058012O00122O00050059015O0003000500024O00020002000300202O0002000200454O00020002000200062O000200B506013O0004623O00B506012O00EF000200063O0020E70002000200C54O000400013O00202O00040004009E4O00020004000200062O000200B506013O0004623O00B506012O00EF00025O00067E000200B5060100010004623O00B506012O00EF000200044O0058000300013O00202O00030003004C4O000400033O00202O0004000400214O000600013O00202O00060006004C4O0004000600024O000400046O000500016O00020005000200062O000200B0060100010004623O00B006010012860002005A012O0012860003005B012O000645010200B5060100030004623O00B506012O00EF000200023O0012860003005C012O0012860004005D013O00DD000200044O003B01025O001286000100CA3O0004623O000500010004623O00B906010004623O000200012O00AD3O00017O001F012O00028O00025O0062AD40025O00508540027O0040025O002OA040025O00208A40026O00F03F025O0072A240025O009C904003053O0095E632A9C403063O003CDD8744C6A7030A3O0049734361737461626C65030A3O00DCBCF18D4DDFC8B4EA8603063O00B98EDD98E322030B3O004973417661696C61626C65025O00F89B40025O002AA940025O006BB140025O0016AE40025O0032A740025O00109D4003043O004755494403053O00706169727303063O0045786973747303133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564025O0096A040025O00804340030E3O004861766F634D6F7573656F766572030F3O0050C441F54073F454C056EC4673A60C03073O009738A5379A2353025O00A8A040025O0020694003103O00935608E3AF4D36E1B54F0EEBA55300FC03043O008EC0236503103O00E56024AEE8829F19C37922A6E29CA90403083O0076B61549C387ECCC03053O00436F756E74026O00244003103O003B29174D0B03CE0729164B0108ED0D2E03073O009D685C7A20646D026O00084003103O0053752O6D6F6E536F756C6B2O6570657203183O00B0B3C2C73229B2B8ACB3C3C138229DAEB1E6CEC53867DCF903083O00CBC3C6AFAA5D47ED025O00F2B040025O007DB140025O00109B40025O00B2AB40025O00949140026O00504003103O007DC9AA28C15BCD8F23C251CFAD2FDD5B03053O00AF3EA1CB46030D3O00446562752O6652656D61696E73030E3O00492O6D6F6C617465446562752O6603103O001FD5C21D3B39D1E7163833D3C51A273903053O00555CBDA37303083O004361737454696D65030F3O001BAD373127AB143D24A32O3E20BE3503043O005849CC5003103O004368612O6E656C44656D6F6E6669726503093O004973496E52616E6765026O004440025O001EA940025O004AAF4003183O002D8B114827DF22BC144324D5208519542C9A2F8C1506788803063O00BA4EE3702649025O00DEA240025O00C8844003083O00D55AF05A5F7BE85203063O001A9C379D3533030E3O00A5D51BD6B45198DD32DCBA458ADE03063O0030ECB876B9D8030F3O0041757261416374697665436F756E74026O00184003093O00436173744379636C6503083O00492O6D6F6C617465030E3O0049735370652O6C496E52616E676503113O00492O6D6F6C6174654D6F7573656F766572025O00049140025O003AA140030F3O00ECB05A3FC335F1B81731C031A5EC0703063O005485DD3750AF026O001440025O00C4A040025O00A08340030B3O0059B33C728A347C997BA83703083O00EB1ADC5214E6551B03083O0042752O66446F776E03093O004261636B647261667403093O00AAA0EAC9709AA0EFD603053O0014E8C189A2025O00AEAA40025O0061B140030B3O00436F6E666C616772617465025O00949B40025O00D6B04003123O0021D0CBA0EB8D106323CBC02OE6831231708B03083O001142BFA5C687EC77025O00508C40026O006940030F3O002BA6A316F1FBE5DE01AEA221F6EEF803083O00B16FCFCE739F888C030F3O0044696D656E73696F6E616C5269667403173O0001801D11DA5C560A871118EB5D56039D5015DB4A1F57DF03073O003F65E97074B42F03083O00EA36E01DF437D73E03063O0056A35B8D729803113O00446562752O665265667265736861626C65026O00A840025O00AAA040025O00408C40025O00E0954003113O00492O6D6F6C617465506574412O7461636B030F3O005A06797C36521F71333B5C0E34216203053O005A336B1413030A3O00A4FE86E63388E284FB3803053O005DED90E58F025O00708640025O002EAE40030A3O00496E63696E657261746503113O001CF8F310054307F7E41C4B471AF3B04A5B03063O0026759690796B025O0066A340025O005EA140025O00F49540025O00E88940025O001AAA40026O00AE40025O00408F40025O00C8A440025O00D09D40025O00E0A140025O009EA340025O0010AC40025O0039B140025O00E9B240025O005EA740025O005EA640025O00D8A340025O00E2A740025O00D6B2402O033O0047434403083O006511F0045200490003063O00762663894C3303073O00D42803171B2EF203063O00409D46657269025O0050B240025O00449740026O008A40025O00A2B240025O00389E40025O00ACB140025O0074A440025O0046B040025O0049B040025O001AAD40025O00805540025O00206340030A3O0072A9AEED1F468EAEF11503053O007020C8C78303073O0049735265616479025O00609C40025O00EAA14003103O005261696E6F6646697265437572736F7203123O003E5155B6FCA424135655AAC6EB2O23551CEA03073O00424C303CD8A3CB025O000EA640025O001AA940025O005EB240025O000EAA40025O0002A940030E3O001D5E33D85E1FD5204D3BC75F10F003073O009C4E2B5EB5317103143O0053752O6D6F6E496E6665726E616C437572736F72025O0026AA40025O00D0964003163O0061FDC9AE044D467BE6C2A6194D787EA8C5AC0E03282603073O00191288A4C36B23025O0053B240025O0013B140025O00208340030A3O00DA2CA0417DBAE7B1FA2803083O00D8884DC92F12DCA103133O003FED22D437D38412EA22C80D9C8322E96B8B5E03073O00E24D8C4BBA68BC03053O0091CFC6304C03053O002FD9AEB05F025O00E8B240025O004AB040025O00089540025O0098A740025O007EA540025O00E0AD40025O00A6AC40025O00D0A740025O00ECAD40030F3O00B0DC600DB1147B2ABDDC6007F2052C03083O0046D8BD1662D23418025O008AA040025O00689040025O002C9140025O00489C40026O001040025O001CB340025O00F8AC40025O00B2A240025O0048834003103O00F9D7A289DDDFD38782DED5D1A58EC1DF03053O00B3BABFC3E703103O00DA3719EAF73A14C0FC3217EAFF360AE103043O0084995F78025O00209540025O00DCA240025O00C09840025O00D6A14003183O00B2BA0F23F9DFAC8EB60B20F8D4A6B8A00B6DF6D5A5F1E35903073O00C0D1D26E4D97BA025O0032A040025O003AA64003083O00C90E2FE6F3C5F40603063O00A4806342899F025O009CA640025O00BAA940030F3O000984E4B10C88FDBB4088E6BB40D8B103043O00DE60E989025O00EC9340025O00708D4003083O008ABCB213AEFAE2BC03073O0090D9D3C77FE89303063O0042752O665570030D3O004261636B647261667442752O66025O00989240025O000CB04003083O00536F756C4669726503103O00EB202B24EA430B56FD6F3F27D005501403083O0024984F5E48B52562025O00C8A240025O0056A340030A3O00FED64436D9DD553EC3DD03043O005FB7B82703103O009336F523558E06972DEE2B47940DBB3A03073O0062D55F874634E0025O0068A040025O00D8834003113O00F7ADCA7E5AFBB1C86351BEA2C67214ACF103053O00349EC3A917025O002EA740025O00806840025O0051B240025O00CEA740030A3O00888770FD50C802B3947C03073O0044DAE619933FAE03133O008C3C5258B7BF255568B3BE3E4159B5B9235C4203053O00D6CD4A332C025O00607A40025O00B07940025O0058A340025O002OA64003123O00E84DEBF248F54ADDFA7EE849A2FD78FF0CB603053O00179A2C829C030A3O0023A7A4A0391537AFBFAB03063O007371C6CDCE56030B3O00536F756C5368617264735003123O009656F754BB58F865825EEC5FC456F15FC40103043O003AE4379E025O0080944003093O009781D1212F8F3AB89D03073O0055D4E9B04E5CCD029A5O99B93F026O000C40030A3O00785981EC455EAEEB585D03043O00822A38E8025O005EAB40025O0098AA40025O00D8A140025O00A4B04003093O004368616F73426F6C7403103O00E9BD25EC5300E8BA28F7003EE5B064BB03063O005F8AD544832003093O000929B542752631B24E03053O00164A48C123025O00F08340025O00E0904003093O0043617461636C79736D03103O002F78F0592F75FD4B2139E5572939B50803043O00384C19840073052O0012863O00014O0050000100013O00262D3O0006000100010004623O00060001002E9100020002000100030004623O00020001001286000100013O0026432O0100262O0100040004623O00262O01001286000200014O0050000300033O002E160106000B000100050004623O000B00010026430102000B000100010004623O000B0001001286000300013O000E0400070014000100030004623O00140001002E91000800B0000100090004623O00B00001001286000400013O002643010400AB000100010004623O00AB00012O00EF00056O002C010600013O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002B00013O0004623O002B00012O00EF00056O002C010600013O00122O0007000D3O00122O0008000E6O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005002D00013O0004623O002D0001002E910011007E000100100004623O007E0001001286000500014O0050000600083O002E9100130036000100120004623O0036000100264301050036000100010004623O00360001001286000600014O0050000700073O001286000500073O0026430105002F000100070004623O002F00012O0050000800083O00262D0006003D000100070004623O003D0001002E9100140074000100150004623O007400010026430107003D000100010004623O003D00012O00EF000900023O0020F20009000900164O0009000200024O000800093O00122O000900176O000A00036O00090002000B00044O006F00010020A5000E000D00162O0061000E0002000200066B000E0062000100080004623O006200012O00EF000E00043O00063A000E006200013O0004623O006200012O00EF000E00043O0020A5000E000E00182O0061000E0002000200063A000E006200013O0004623O006200010020A5000E000D00162O002C000E000200024O000F00043O00202O000F000F00164O000F0002000200062O000E00620001000F0004623O006200010020A5000E000D00192O0061000E0002000200067E000E0062000100010004623O006200010020A5000E000D001A2O0061000E0002000200063A000E006400013O0004623O00640001002E19001B000D0001001C0004623O006F00012O00EF000E00054O00EF000F00063O002095000F000F001D2O0061000E0002000200063A000E006F00013O0004623O006F00012O00EF000E00013O001286000F001E3O0012860010001F4O00DD000E00104O003B010E5O00061D01090047000100020004623O004700010004623O007E00010004623O003D00010004623O007E0001000E0400010078000100060004623O00780001002E9100200039000100210004623O00390001001286000700014O0050000800083O001286000600073O0004623O003900010004623O007E00010004623O002F00012O00EF00056O002C010600013O00122O000700223O00122O000800236O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500AA00013O0004623O00AA00012O00EF00056O0028000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O0005000500264O00050002000200262O0005009F000100270004623O009F00012O00EF00056O000C000600013O00122O000700283O00122O000800296O0006000800024O00050005000600202O0005000500264O000500020002000E2O002A00AA000100050004623O00AA00012O00EF000500073O0026E9000500AA000100270004623O00AA00012O00EF000500054O00EF00065O00209500060006002B2O006100050002000200063A000500AA00013O0004623O00AA00012O00EF000500013O0012860006002C3O0012860007002D4O00DD000500074O003B01055O001286000400073O00264301040015000100070004623O00150001001286000300043O0004623O00B000010004623O00150001000E04000400B4000100030004623O00B40001002E91002F00B60001002E0004623O00B600010012860001002A3O0004623O00262O0100262D000300BA000100010004623O00BA0001002E9100310010000100300004623O00100001002E91003300F2000100320004623O00F200012O00EF00046O002C010500013O00122O000600343O00122O000700356O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400F200013O0004623O00F200012O00EF000400023O0020D40004000400364O00065O00202O0006000600374O0004000600024O00058O000600013O00122O000700383O00122O000800396O0006000800024O00050005000600202O00050005003A4O00050002000200062O000500F2000100040004623O00F200012O00EF00046O002C010500013O00122O0006003B3O00122O0007003C6O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400F200013O0004623O00F200012O00EF000400054O00C100055O00202O00050005003D4O000600023O00202O00060006003E00122O0008003F6O0006000800024O000600066O000700016O00040007000200062O000400ED000100010004623O00ED0001002E16014100F2000100400004623O00F200012O00EF000400013O001286000500423O001286000600434O00DD000400064O003B01045O002E16014500222O0100440004623O00222O012O00EF00046O002C010500013O00122O000600463O00122O000700476O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400222O013O0004623O00222O012O00EF00046O007D000500013O00122O000600483O00122O000700496O0005000700024O00040004000500202O00040004004A4O00040002000200262O000400222O01004B0004623O00222O012O00EF000400083O00208A00040004004C4O00055O00202O00050005004D4O000600036O000700096O000800023O00202O00080008004E4O000A5O00202O000A000A004D4O0008000A00024O000800086O0009000A6O000B00063O00202O000B000B004F4O000C00016O0004000C000200062O0004001D2O0100010004623O001D2O01002E16015100222O0100500004623O00222O012O00EF000400013O001286000500523O001286000600534O00DD000400064O003B01045O001286000300073O0004623O001000010004623O00262O010004623O000B000100262D0001002A2O0100540004623O002A2O01002E91005500C02O0100560004623O00C02O012O00EF00026O002C010300013O00122O000400573O00122O000500586O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200452O013O0004623O00452O012O00EF0002000A3O00201F0102000200594O00045O00202O00040004005A4O00020004000200062O000200472O0100010004623O00472O012O00EF00026O002C010300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O00020002000F4O00020002000200062O000200472O013O0004623O00472O01002E91005E005A2O01005D0004623O005A2O012O00EF000200054O005100035O00202O00030003005F4O000400023O00202O00040004004E4O00065O00202O00060006005F4O0004000600024O000400046O00020004000200062O000200552O0100010004623O00552O01002E160161005A2O0100600004623O005A2O012O00EF000200013O001286000300623O001286000400634O00DD000200044O003B01025O002E160165007A2O0100640004623O007A2O012O00EF0002000B3O00063A0002007A2O013O0004623O007A2O012O00EF00026O002C010300013O00122O000400663O00122O000500676O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002007A2O013O0004623O007A2O012O00EF000200054O001F00035O00202O0003000300684O000400023O00202O00040004004E4O00065O00202O0006000600684O0004000600024O000400046O00020004000200062O0002007A2O013O0004623O007A2O012O00EF000200013O001286000300693O0012860004006A4O00DD000200044O003B01026O00EF00026O002C010300013O00122O0004006B3O00122O0005006C6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002008B2O013O0004623O008B2O012O00EF000200023O00201F01020002006D4O00045O00202O0004000400374O00020004000200062O0002008D2O0100010004623O008D2O01002E91006E00A12O01006F0004623O00A12O01002E91007000A12O0100710004623O00A12O012O00EF000200054O00F9000300063O00202O0003000300724O000400023O00202O00040004004E4O00065O00202O00060006004D4O0004000600024O000400046O000500016O00020005000200062O000200A12O013O0004623O00A12O012O00EF000200013O001286000300733O001286000400744O00DD000200044O003B01026O00EF00026O0002000300013O00122O000400753O00122O000500766O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200AD2O0100010004623O00AD2O01002E1601780072050100770004623O007205012O00EF000200054O00F900035O00202O0003000300794O000400023O00202O00040004004E4O00065O00202O0006000600794O0004000600024O000400046O000500016O00020005000200062O0002007205013O0004623O007205012O00EF000200013O00129C0003007A3O00122O0004007B6O000200046O00025O00044O0072050100262D000100C42O0100010004623O00C42O01002E19007C00F70001007D0004623O00B90201001286000200013O00264301020011020100010004623O00110201002E91007F00E72O01007E0004623O00E72O012O00EF0003000B3O00063A000300E72O013O0004623O00E72O01001286000300014O0050000400053O002E16018000DF2O0100780004623O00DF2O01002643010300DF2O0100070004623O00DF2O01002643010400D22O0100010004623O00D22O012O00EF0006000C4O00DB0006000100022O0023000500063O002E16018200E72O0100810004623O00E72O0100063A000500E72O013O0004623O00E72O012O0073000500023O0004623O00E72O010004623O00D22O010004623O00E72O0100262D000300E32O0100010004623O00E32O01002E16018300CE2O0100840004623O00CE2O01001286000400014O0050000500053O001286000300073O0004623O00CE2O012O00EF0003000B3O00063A000300ED2O013O0004623O00ED2O012O00EF0003000D3O00067E000300EF2O0100010004623O00EF2O01002E1601860010020100850004623O00100201001286000300014O0050000400053O00264301032O00020100010004624O000201001286000600013O00262D000600F82O0100010004623O00F82O01002E91008800FB2O0100870004623O00FB2O01001286000400014O0050000500053O001286000600073O000E48010700F42O0100060004623O00F42O01001286000300073O0004624O0002010004623O00F42O01002643010300F12O0100070004623O00F12O0100262D00040006020100010004623O00060201002E160189002O0201008A0004623O002O02012O00EF0006000E4O00DB0006000100022O0023000500063O00063A0005001002013O0004623O001002012O0073000500023O0004623O001002010004623O002O02010004623O001002010004623O00F12O01001286000200073O000E0400040015020100020004623O00150201002E91008B00170201008C0004623O00170201001286000100073O0004623O00B90201002E91008D00C52O01008E0004623O00C52O01002643010200C52O0100070004623O00C52O012O00EF0003000F3O00063A0003005802013O0004623O005802012O00EF000300104O00EF0004000A3O0020A500040004008F2O006100040002000200068100040058020100030004623O005802012O00EF000300114O00A0000400123O00122O000500546O000600136O00078O000800013O00122O000900903O00122O000A00916O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007003B02013O0004623O003B02012O00EF00076O0037010800013O00122O000900923O00122O000A00936O0008000A00024O00070007000800202O00070007000F4O0007000200024O000700074O00CE000600074O00FD00043O00022O00A0000500143O00122O000600546O000700136O00088O000900013O00122O000A00903O00122O000B00916O0009000B00024O00080008000900202O00080008000F4O00080002000200062O0008005302013O0004623O005302012O00EF00086O0037010900013O00122O000A00923O00122O000B00936O0009000B00024O00080008000900202O00080008000F4O0008000200024O000800084O00CE000700084O00FD00053O00022O00EE0004000400050006220003005A020100040004623O005A0201002E1601940085020100950004623O00850201001286000300014O0050000400063O00262D00030060020100010004623O00600201002E9100970063020100960004623O00630201001286000400014O0050000500053O001286000300073O002E19009800F9FF2O00980004623O005C02010026430103005C020100070004623O005C02012O0050000600063O00262D0004006C020100010004623O006C0201002E910099006F0201009A0004623O006F0201001286000500014O0050000600063O001286000400073O00262D00040073020100070004623O00730201002E91009C00680201009B0004623O0068020100262D00050077020100010004623O00770201002E16019D00730201009E0004623O007302012O00EF000700154O00DB0007000100022O0023000600073O00067E0006007E020100010004623O007E0201002E91008E00850201009F0004623O008502012O0073000600023O0004623O008502010004623O007302010004623O008502010004623O006802010004623O008502010004623O005C02012O00EF00036O002C010400013O00122O000500A03O00122O000600A16O0004000600024O00030003000400202O0003000300A24O00030002000200062O000300A302013O0004623O00A302012O00EF000300043O00063A000300A302013O0004623O00A302012O00EF000300043O0020A50003000300182O006100030002000200063A000300A302013O0004623O00A302012O00EF000300043O0020300103000300164O0003000200024O000400023O00202O0004000400164O00040002000200062O000300A3020100040004623O00A302012O00EF000300164O00DB000300010002000EDA000100A5020100030004623O00A50201002E1601A400B7020100A30004623O00B702012O00EF000300054O00F9000400063O00202O0004000400A54O000500023O00202O00050005004E4O00075O00202O00070007005F4O0005000700024O000500056O000600016O00030006000200062O000300B702013O0004623O00B702012O00EF000300013O001286000400A63O001286000500A74O00DD000300054O003B01035O001286000200043O0004623O00C52O010026432O0100AF0301002A0004623O00AF0301001286000200013O0026430102000F030100010004623O000F03012O00EF0003000B3O00063A000300E402013O0004623O00E40201001286000300014O0050000400053O00262D000300C7020100070004623O00C70201002E9100A900D4020100A80004623O00D40201002643010400C7020100010004623O00C702012O00EF0006000C4O00DB0006000100022O0023000500063O002E16016F00E4020100AA0004623O00E4020100063A000500E402013O0004623O00E402012O0073000500023O0004623O00E402010004623O00C702010004623O00E40201002643010300C3020100010004623O00C30201001286000600013O002643010600DC020100010004623O00DC0201001286000400014O0050000500053O001286000600073O00262D000600E0020100070004623O00E00201002E9100AB00D7020100AC0004623O00D70201001286000300073O0004623O00C302010004623O00D702010004623O00C302012O00EF0003000B3O00063A0003000E03013O0004623O000E03012O00EF00036O002C010400013O00122O000500AD3O00122O000600AE6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003000E03013O0004623O000E03012O00EF000300043O00063A0003000E03013O0004623O000E03012O00EF000300043O0020A50003000300182O006100030002000200063A0003000E03013O0004623O000E03012O00EF000300043O0020300103000300164O0003000200024O000400023O00202O0004000400164O00040002000200062O0003000E030100040004623O000E03012O00EF000300054O00EF000400063O0020950004000400AF2O006100030002000200067E00030009030100010004623O00090301002E1601B0000E030100B10004623O000E03012O00EF000300013O001286000400B23O001286000500B34O00DD000300054O003B01035O001286000200073O000E0400070013030100020004623O00130301002E1601B400AA030100B50004623O00AA0301002E1900B6002D000100B60004623O004003012O00EF00036O002C010400013O00122O000500B73O00122O000600B86O0004000600024O00030003000400202O0003000300A24O00030002000200062O0003004003013O0004623O004003012O00EF000300043O00063A0003004003013O0004623O004003012O00EF000300043O0020A50003000300182O006100030002000200063A0003004003013O0004623O004003012O00EF000300043O0020300103000300164O0003000200024O000400023O00202O0004000400164O00040002000200062O00030040030100040004623O004003012O00EF000300054O001F000400063O00202O0004000400A54O000500023O00202O00050005004E4O00075O00202O00070007005F4O0005000700024O000500056O00030005000200062O0003004003013O0004623O004003012O00EF000300013O001286000400B93O001286000500BA4O00DD000300054O003B01036O00EF00036O0002000400013O00122O000500BB3O00122O000600BC6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003004C030100010004623O004C0301002E9100BD00A9030100BE0004623O00A90301001286000300014O0050000400063O002E1900BF0053000100BF0004623O00A10301002643010300A1030100070004623O00A103012O0050000600063O00264301040090030100070004623O00900301000E0400010059030100050004623O00590301002E9100C00055030100C10004623O005503012O00EF000700023O0020F20007000700164O0007000200024O000600073O00122O000700176O000800036O00070002000900044O008B0301002E1601C3008B030100C20004623O008B03010020A5000C000B00162O0061000C0002000200066B000C008B030100060004623O008B03012O00EF000C00043O00063A000C008B03013O0004623O008B03012O00EF000C00043O0020A5000C000C00182O0061000C0002000200063A000C008B03013O0004623O008B03010020A5000C000B00162O002C000C000200024O000D00043O00202O000D000D00164O000D0002000200062O000C008B0301000D0004623O008B03010020A5000C000B00192O0061000C0002000200067E000C008B030100010004623O008B03010020A5000C000B001A2O0061000C0002000200067E000C008B030100010004623O008B03012O00EF000C00054O00EF000D00063O002095000D000D001D2O0061000C0002000200067E000C0086030100010004623O00860301002E1601C5008B030100C40004623O008B03012O00EF000C00013O001286000D00C63O001286000E00C74O00DD000C000E4O003B010C5O00061D01070061030100020004623O006103010004623O00A903010004623O005503010004623O00A90301000E0400010094030100040004623O00940301002E1601C80053030100C90004623O00530301001286000700013O00264301070099030100070004623O00990301001286000400073O0004623O0053030100264301070095030100010004623O00950301001286000500014O0050000600063O001286000700073O0004623O009503010004623O005303010004623O00A9030100262D000300A5030100010004623O00A50301002E1900CA00ABFF2O00CB0004623O004E0301001286000400014O0050000500053O001286000300073O0004623O004E0301001286000200043O000E48010400BC020100020004623O00BC0201001286000100CC3O0004623O00AF03010004623O00BC0201000E4801CC0076040100010004623O00760401001286000200013O00262D000200B6030100040004623O00B60301002E1900CD0004000100CE0004623O00B80301001286000100543O0004623O00760401002E1601D00012040100CF0004623O0012040100264301020012040100010004623O001204012O00EF00036O002C010400013O00122O000500D13O00122O000600D26O0004000600024O00030003000400202O0003000300A24O00030002000200062O000300D503013O0004623O00D503012O00EF000300023O00201A0103000300364O00055O00202O0005000500374O0003000500024O00048O000500013O00122O000600D33O00122O000700D46O0005000700024O00040004000500202O00040004003A4O00040002000200062O000400D7030100030004623O00D70301002E1601D600EB030100D50004623O00EB03012O00EF000300054O005800045O00202O00040004003D4O000500023O00202O00050005004E4O00075O00202O00070007003D4O0005000700024O000500056O000600016O00030006000200062O000300E6030100010004623O00E60301002E1900D70007000100D80004623O00EB03012O00EF000300013O001286000400D93O001286000500DA4O00DD000300054O003B01035O002E1601DB0011040100DC0004623O001104012O00EF00036O002C010400013O00122O000500DD3O00122O000600DE6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003001104013O0004623O00110401002E9100DF0011040100E00004623O001104012O00EF000300083O00204C00030003004C4O00045O00202O00040004004D4O000500036O000600096O000700023O00202O00070007004E4O00095O00202O00090009004D4O0007000900024O000700076O000800096O000A00063O00202O000A000A004F4O000B00016O0003000B000200062O0003001104013O0004623O001104012O00EF000300013O001286000400E13O001286000500E24O00DD000300054O003B01035O001286000200073O002643010200B2030100070004623O00B20301001286000300013O002E1601E4001B040100E30004623O001B04010026430103001B040100070004623O001B0401001286000200043O0004623O00B20301000E482O010015040100030004623O001504012O00EF00046O002C010500013O00122O000600E53O00122O000700E66O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004004204013O0004623O004204012O00EF0004000A3O0020E70004000400E74O00065O00202O0006000600E84O00040006000200062O0004004204013O0004623O00420401002E1601E90042040100EA0004623O004204012O00EF000400054O00F900055O00202O0005000500EB4O000600023O00202O00060006004E4O00085O00202O0008000800EB4O0006000800024O000600066O000700016O00040007000200062O0004004204013O0004623O004204012O00EF000400013O001286000500EC3O001286000600ED4O00DD000400064O003B01045O002E9100EE0073040100EF0004623O007304012O00EF00046O002C010500013O00122O000600F03O00122O000700F16O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007304013O0004623O007304012O00EF00046O002C010500013O00122O000600F23O00122O000700F36O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004007304013O0004623O007304012O00EF0004000A3O0020E70004000400E74O00065O00202O00060006005A4O00040006000200062O0004007304013O0004623O007304012O00EF000400054O005800055O00202O0005000500794O000600023O00202O00060006004E4O00085O00202O0008000800794O0006000800024O000600066O000700016O00040007000200062O0004006E040100010004623O006E0401002E9100F40073040100F50004623O007304012O00EF000400013O001286000500F63O001286000600F74O00DD000400064O003B01045O001286000300073O0004623O001504010004623O00B203010026432O010007000100070004623O00070001001286000200013O002E1601F9007F040100F80004623O007F04010026430102007F040100040004623O007F0401001286000100043O0004623O0007000100262D00020083040100010004623O00830401002E1601FA00FD040100FB0004623O00FD0401001286000300013O002643010300F7040100010004623O00F704012O00EF00046O002C010500013O00122O000600FC3O00122O000700FD6O0005000700024O00040004000500202O0004000400A24O00040002000200062O000400AA04013O0004623O00AA04012O00EF000400043O00063A000400AA04013O0004623O00AA04012O00EF000400043O0020A50004000400182O006100040002000200063A000400AA04013O0004623O00AA04012O00EF000400043O0020300104000400164O0004000200024O000500023O00202O0005000500164O00050002000200062O000400AA040100050004623O00AA04012O00EF00046O0002000500013O00122O000600FE3O00122O000700FF6O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400AD040100010004623O00AD04010012860004002O012O000E202O0001C3040100040004623O00C304012O00EF000400054O0058000500063O00202O0005000500A54O000600023O00202O00060006004E4O00085O00202O00080008005F4O0006000800024O000600066O000700016O00040007000200062O000400BE040100010004623O00BE040100128600040002012O00128600050003012O000681000500C3040100040004623O00C304012O00EF000400013O00128600050004012O00128600060005013O00DD000400064O003B01046O00EF00046O002C010500013O00122O00060006012O00122O00070007015O0005000700024O00040004000500202O0004000400A24O00040002000200062O000400F604013O0004623O00F604012O00EF000400043O00063A000400F604013O0004623O00F604012O00EF000400043O0020A50004000400182O006100040002000200063A000400F604013O0004623O00F604012O00EF000400043O0020300104000400164O0004000200024O000500023O00202O0005000500164O00050002000200062O000400F6040100050004623O00F604012O00EF0004000A3O00123500060008015O0004000400064O00040002000200122O000500543O00062O000400F6040100050004623O00F604012O00EF000400054O00F9000500063O00202O0005000500A54O000600023O00202O00060006004E4O00085O00202O00080008005F4O0006000800024O000600066O000700016O00040007000200062O000400F604013O0004623O00F604012O00EF000400013O00128600050009012O0012860006000A013O00DD000400064O003B01045O001286000300073O001286000400073O00060001030084040100040004623O00840401001286000200073O0004623O00FD04010004623O00840401001286000300073O00060001020079040100030004623O00790401001286000300013O0012860004000B012O0012860005000B012O00060001040068050100050004623O00680501001286000400013O00060001030068050100040004623O006805012O00EF00046O002C010500013O00122O0006000C012O00122O0007000D015O0005000700024O00040004000500202O0004000400A24O00040002000200062O0004002705013O0004623O002705012O00EF0004000A3O0012AA00060008015O0004000400064O0004000200024O000500113O00122O0006000E015O00050006000500122O0006000F015O00050006000500062O00050027050100040004623O002705012O00EF00046O002C010500013O00122O00060010012O00122O00070011015O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004002B05013O0004623O002B050100128600040012012O00128600050013012O00060001040043050100050004623O0043050100128600040014012O00128600050015012O00068100040043050100050004623O004305012O00EF000400054O009300055O00122O00060016015O0005000500064O000600023O00202O00060006004E4O00085O00122O00090016015O0008000800094O0006000800024O000600066O000700016O00040007000200062O0004004305013O0004623O004305012O00EF000400013O00128600050017012O00128600060018013O00DD000400064O003B01046O00EF0004000B3O00063A0004006705013O0004623O006705012O00EF00046O002C010500013O00122O00060019012O00122O0007001A015O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004006705013O0004623O006705010012860004001B012O0012860005001C012O00064501040067050100050004623O006705012O00EF000400054O002100055O00122O0006001D015O0005000500064O000600023O00202O00060006004E4O00085O00122O0009001D015O0008000800094O0006000800024O000600064O002701040006000200063A0004006705013O0004623O006705012O00EF000400013O0012860005001E012O0012860006001F013O00DD000400064O003B01045O001286000300073O001286000400073O00060001030001050100040004623O00010501001286000200043O0004623O007904010004623O000105010004623O007904010004623O000700010004623O007205010004623O000200012O00AD3O00017O0082012O00028O00027O0040025O0010A340025O002DB040026O00F03F026O000840025O0018B140025O001EA74003113O00476574456E656D696573496E52616E6765026O004440030F3O00456E656D696573387953706C61736803173O00476574456E656D696573496E53706C61736852616E6765026O002840025O00109A40025O003CAA40025O0028B340026O001040025O008AA640025O0078A640025O00BAA340025O001AA740025O001EAF40025O00488440030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O00F09D4003103O00426F2O73466967687452656D61696E73025O0097B040025O0016AD40025O00989640025O0072A740024O0080B3C540030C3O00466967687452656D61696E73025O0068AA40025O00E06840025O00589740025O00D4B140025O00A0B040025O00507D40025O001EAD40025O00C05540025O00088340025O0062AE40030B3O0005242BB9ED272C37BEF52303053O0081464B45DF03073O0049735265616479030C3O0074C4F2FB75E141E9FFE866EA03063O008F26AB93891C030B3O004973417661696C61626C65030D3O00446562752O6652656D61696E7303123O00526F6172696E67426C617A65446562752O66026O00F83F030B3O00F38DB7F50FE2D3C283ADF603073O00B4B0E2D993638303073O0043686172676573030B3O00F0B62101DFB82815D2AD2A03043O0067B3D94F030A3O004D617843686172676573030B3O00436F6E666C616772617465030E3O0049735370652O6C496E52616E6765025O0088A440025O00FEA04003123O0049B812D34D8DA458B608D00181A243B95C8703073O00C32AD77CB521EC025O006EA740030F3O0029503A3B2BEB0456393F29CA045F2303063O00986D39575E45030A3O0049734361737461626C65030B3O00536F756C5368617264735002CD5OCC1240030F3O00DDDE07A6B0C15DA7F7D60691B7D44003083O00C899B76AC3DEB234030F3O0016EA853847493BEC863C45683BE59C03063O003A5283E85D2903083O00432O6F6C646F776E030F3O0044696D656E73696F6E616C52696674025O0030A740025O00C0514003173O00875EDD10532C8A58DE145100915ED6011D32825EDE550903063O005FE337B0753D025O00CAAA40025O0010AB4003093O003B7F374AA81467304603053O00CB781E432B03093O0043617461636C79736D03093O004973496E52616E676503103O00F22459EEDAFD3C5EE299FC2444E199A703053O00B991452D8F026O002040025O0042A240025O00707A40030B3O00CF2E2600778CFE3EED352D03083O004C8C4148661BED99030B3O0069D518D4DB00B958DB02D703073O00DE2ABA76B2B761030B3O007EE34A8C51ED43985CF84103043O00EA3D8C242O033O00474344026O00E03F03133O0022D2B4740320DAA8731B249DB773062F9DEE2A03053O006F41BDDA12026O00224003093O00A326BE44C4C9D28C3A03073O00BDE04EDF2BB78B030B3O001DF39F1AE221F28E03C83A03053O00A14E9CEA7603133O008AB6CDD2A2A4DAD3A1A3C1D986ADC3FDB6BEDB03043O00BCC7D7A903093O00DE085C70ECEE08596F03053O00889C693F1B025O00A7B240025O0058864003093O004368616F73426F6C7403123O001884783B08B37B3B17982O391A8577744FD803043O00547BEC19025O0068AC40025O006C9C4003093O00D383AB18BF97FF87BE03063O00D590EBCA77CC026O00164003094O0010DF253B01422F0C03073O002D4378BE4A484303083O004361737454696D6503093O00032AECAAEAAAE1E53403083O008940428DC599E88E030A3O0054726176656C54696D65025O00349140025O00B2A24003124O00D823A99B3CD22DAA9C43DD23AF8643847403053O00E863B042C6025O000C9540026O001840025O003EAD40025O0038A240025O0028A940025O007CB240025O0082B140025O0062B340025O0016AB40025O00FCA24003093O00AE38F92B4EC3823CEC03063O0081ED5098443D030B3O0042752O6652656D61696E73030F3O005261696E6F664368616F7342752O6603093O0072A005FC0F35575DBC03073O003831C864937C77025O00708040025O00F07F4003123O00CF36BEFFDF01BDFFC02AFFFDCD37B1B09F6E03043O0090AC5EDF03093O002O07A348372DAD4B3003043O0027446FC203063O0042752O66557003093O004261636B6472616674030B3O00F3B4E6C370B4D7B2EEC87703063O00D7B6C687A71903133O00A048EE46885AF9478B5DE24DAC53E0699C40F803043O0028ED298A025O00A4A040025O00309D4003123O00C47CFBF759F876F5F45E8779FBF1448727A803053O002AA7149A98025O0046A040025O0036AE4003093O0069F6A34D620345F2B603063O00412A9EC22211030D3O004D61646E652O73432O42752O66025O0024A840025O0028AC4003143O00192F53033ED219E11633120F21E81AF81F67015A03083O008E7A47326C4D8D7B026O001C40025O0054AA40025O0039B04003083O002B4DE0FC0E41F9F603043O009362208D03113O00446562752O665265667265736861626C65030E3O00492O6D6F6C617465446562752O6603123O00314DF7CF14584A1460ECC70443580C4AECC403073O002B782383AA663603093O00770793B7A6BC9D470B03073O00E43466E7D6C5D003093O003DE161CBE98700C51303083O00B67E8015AA8AEB79030F3O00432O6F6C646F776E52656D61696E7303083O00B8D520EAA01A222O03083O0066EBBA5586E6735003083O0064032B5354DD305203073O0042376C5E3F12B403083O002782903B0150068803063O003974EDE55747025O0024B04003113O00492O6D6F6C617465506574412O7461636B03083O00492O6D6F6C61746503103O00A3BCE0E87BEF53AFF1E0E67EE007FBE103073O0027CAD18D87178E025O00C05640025O0078A540025O003C9C40025O00F49A4003103O00A91718A8D28F133DA3D185111FAFCE8F03053O00BCEA7F79C6030F3O000A33148A36353786353D1D8531201603043O00E358527303103O004368612O6E656C44656D6F6E6669726503183O004017BBA90C764F20BEA20F7C4D19B3B507334E1EB3A9422403063O0013237FDAC76203083O002FF41FEE3AF218E703043O00827C9B6A026O000C4003083O00E6C4E3A385FF6EBA03083O00DFB5AB96CFC3961C03083O007F35F6A22F4528E603053O00692C5A83CE030C3O00CDEFB3AB0130F8C2BEB8123B03063O005E9F80D2D968030D3O004261636B647261667442752O66025O00C88340025O0054A44003083O00536F756C4669726503103O0043F613B36079F06855B90BBE5671B92203083O001A309966DF3F1F99026O00144003103O009D78DBC90DB08F35BB7DD5C905BC911403083O0071DE10BAA763D5E303043O001C1BF2F803043O00964E6E9B030A3O0054616C656E7452616E6B030E3O00A1CC26E3AB12B643A0C825E4B60D03083O0020E5A54781C47EDF03133O00E29FC59580C7CC8FE08492C1D19CC79588DACD03063O00B5A3E9A42OE1030B3O00729E2C7944841F64588E2D03043O001730EB5E030E3O005FD2D952441ADC7FDBCA535627D703073O00B21CBAB83D375303103O00E7C54632FC0BF9E0C84A33FC08FCD6C803073O0095A4AD275C926E025O00907740025O0031B240025O0004B340025O0080904003193O00F02F2O11141EFF18141A1714FD21190D1F5BFE2619115A4AA503063O007B9347707F7A030B3O00EFC28C774ACDCA907052C903053O0026ACADE21103083O0042752O66446F776E030C3O007F1E2DFD441F2BCD411036EA03043O008F2D714C025O00709540025O00C8874003133O00BBB7123AB4B91B2EB9AC197CB5B91532F8EA4403043O005C2OD87C030A3O00723CAF49F35E20AD54F803053O009D3B52CC20030F3O004275726E746F417368657342752O66030A3O001130E0F3E7EFC1B02C3B03083O00D1585E839A898AB303093O000BA9C5730D013E2E3C03083O004248C1A41C7E4351030A3O00496E63696E657261746503113O00EE22AB512873F52DBC5D6677E829E80A7F03063O0016874CC83846025O0080AD40025O00DCA940030A3O006A45183C0559BD425F1E03073O00CF232B7B556B3C025O002EAF4003123O0079A4A3E37775B8A1FE7C30A7A1E37730FFF003053O001910CAC08A025O00A4AB40025O00D2A940025O00349240025O000C9140025O008CAD4003053O00D7321F053103063O00989F53696A5203083O00A2D448DAC84A8EC503063O003CE1A63192A903103O0052697475616C6F665275696E42752O66030B3O000D0B3D2415080E0D272F1203063O00674F7E4F4A61030B3O00986AC17D4A159B6CDB764D03063O007ADA1FB3133E03053O004861766F6303123O00BBD7DBCECAE10DA0C28481C4A04CBD969C9003073O0025D3B6ADA1A9C103093O00D4324CD63B59B6FB2E03073O00D9975A2DB9481B03123O00C074E61D45FC7EE81E428371E61B58832DB503053O0036A31C8772030E3O001BCE508F417101D55B875C7129D703063O001F48BB3DE22E03063O0045786973747303043O004755494403143O0053752O6D6F6E496E6665726E616C437572736F7203173O00D0134EDF48701BCA0845D7557025CF464ED34E7064925203073O0044A36623B2271E025O002CA640025O0060A540025O0086AC4003093O0099EA1BE9F698ED16F203053O0085DA827A8603123O003FF7E2CBCF9C3A33F3F784D1A23132BFB79603073O00585C9F83A4BCC3025O00989540025O0028854003103O0036AAFE163510AEDB1D361AACF911291003053O005B75C29F78030E3O003E143F1A3AFD2D1938331A30E33703073O00447A7D5E78559103133O00360ACE4AC9CBB51138CA4DDCCBAF1408C651C603073O00DA777CAF3EA8B9030B3O0087E55ACAB1FF69D7ADF55B03043O00A4C59028030E3O00A0F8AB84CE9F8DF3AB99D3B797F503063O00D6E390CAEBBD03103O00CEAD86751EB65F18E8A8887516BA413903083O005C8DC5E71B70D333031B3O00E5F78BADDFE3F3B5A7D4EBF084A5D8F4FACAA0DDE3FE9CA691B5A703053O00B1869FEAC3030F3O0099E232A5C7AEE230AEC8B1D936A6DD03053O00A9DD8B5FC0025O00388C40025O003EA540031A3O00DA82723A2C35D784713E2E19CC82792B6225D28E7E2927668ADB03063O0046BEEB1F5F42025O00C2A040025O0067B240025O00F0B240025O00DDB040025O00088440025O00BBB240025O00809240025O00C4AD40025O0092AA40025O004EA140025O00FAA340025O001CA240025O003C9E40025O00F2AA40025O00149540025O00409540025O00588840025O00EEA240025O00BC9140025O0068B240026O00A74003073O0062CD12E83DA64403063O00C82BA3748D4F03133O009237398DB5E7F0B030298BB5D5F9B5172C8AA203073O0083DF565DE3D094030C3O00C256BEB31387E648B7BF13A603063O00D583252OD67D025O00EAB140025O001EA040025O000AAC40025O005EA940025O008C9B40025O006C9B40025O00C6AA40025O00CEA040025O00EAAD40025O00E8A740025O00406F40025O00307740025O0016B140025O00689540030C3O004570696353652O74696E677303073O0019B4E93D21BEFD03043O005A4DDB8E2O033O00E90B2203073O001A866441592C67025O007EAB40025O007AA840025O0084B340025O0071B24003073O00C5EC3724A8F4F003053O00C4918350432O033O001FBF2O03063O00887ED066687803073O004C85C944A3572E03083O003118EAAE23CF325D2O033O000FF6EE03053O00116C929DE8025O006EAF400071082O0012863O00014O0050000100013O002643012O0002000100010004623O00020001001286000100013O0026432O01002E000100020004623O002E0001001286000200014O0050000300033O00262D0002000D000100010004623O000D0001002E19000300FEFF2O00040004623O00090001001286000300013O00264301030012000100050004623O00120001001286000100063O0004623O002E00010026430103000E000100010004623O000E0001001286000400013O002E1601080024000100070004623O00240001000E482O010024000100040004623O002400012O00EF000500013O00203E00050005000900122O0007000A6O0005000700024O00058O000500023O00202O00050005000C00122O0007000D6O00050007000200122O0005000B3O00122O000400053O002E19000E00F1FF2O000E0004623O0015000100264301040015000100050004623O00150001001286000300053O0004623O000E00010004623O001500010004623O000E00010004623O002E00010004623O000900010026432O01004B000100060004623O004B0001001286000200013O00262D00020035000100050004623O00350001002E91001000370001000F0004623O00370001001286000100113O0004623O004B000100264301020031000100010004623O00310001002E1601130042000100120004623O004200012O00EF000300033O00063A0003004200013O0004623O004200010012A60003000B4O008B000300034O0003000300043O0004623O00440001001286000300054O0003000300044O00EF000300074O005900048O0003000200044O000400066O000300053O00122O000200053O00044O0031000100262D0001004F000100110004623O004F0001002E19001400B6070100150004623O00030801002E1601170092000100160004623O009200012O00EF000200083O0020950002000200182O00DB00020001000200067E0002005B000100010004623O005B00012O00EF000200013O0020A50002000200192O006100020002000200063A0002009200013O0004623O00920001001286000200014O0050000300043O00264301020062000100010004623O00620001001286000300014O0050000400043O001286000200053O0026430102005D000100050004623O005D000100264301030064000100010004623O00640001001286000400013O000E482O01007C000100040004623O007C0001001286000500013O002E19001A00060001001A0004623O0070000100264301050070000100050004623O00700001001286000400053O0004623O007C0001000E482O01006A000100050004623O006A00012O00EF0006000A3O00202A00060006001B4O000700076O000800016O0006000800024O000600096O000600096O0006000B3O00122O000500053O00044O006A0001002E91001D00670001001C0004623O0067000100264301040067000100050004623O00670001002E16011E00860001001F0004623O008600012O00EF0005000B3O00262D00050086000100200004623O008600010004623O009200012O00EF0005000A3O00202900050005002100122O0006000B6O00078O0005000700024O0005000B3O00044O009200010004623O006700010004623O009200010004623O006400010004623O009200010004623O005D00012O00EF000200083O0020950002000200182O00DB00020001000200063A0002007008013O0004623O00700801001286000200014O0050000300053O002643010200F7070100050004623O00F707012O0050000500053O00262D000300A0000100050004623O00A00001002E16012200EF070100230004623O00EF0701002E91002400562O0100250004623O00562O01002643010400562O0100020004623O00562O01001286000600013O002E16012700322O0100260004623O00322O01000E482O0100322O0100060004623O00322O01001286000700013O00262D000700AE000100050004623O00AE0001002E16012800B0000100290004623O00B00001001286000600053O0004623O00322O01002E91002A00AA0001002B0004623O00AA0001002643010700AA000100010004623O00AA00012O00EF0008000C4O002C0109000D3O00122O000A002C3O00122O000B002D6O0009000B00024O00080008000900202O00080008002E4O00080002000200062O000800F400013O0004623O00F400012O00EF0008000C4O002C0109000D3O00122O000A002F3O00122O000B00306O0009000B00024O00080008000900202O0008000800314O00080002000200062O000800CF00013O0004623O00CF00012O00EF000800023O0020260008000800324O000A000C3O00202O000A000A00334O0008000A000200262O000800E1000100340004623O00E100012O00EF0008000C4O00120109000D3O00122O000A00353O00122O000B00366O0009000B00024O00080008000900202O0008000800374O0008000200024O0009000C6O000A000D3O00122O000B00383O001286000C00394O0066000A000C00024O00090009000A00202O00090009003A4O00090002000200062O000800F4000100090004623O00F400012O00EF0008000E4O00510009000C3O00202O00090009003B4O000A00023O00202O000A000A003C4O000C000C3O00202O000C000C003B4O000A000C00024O000A000A6O0008000A000200062O000800EF000100010004623O00EF0001002E16013D00F40001003E0004623O00F400012O00EF0008000D3O0012860009003F3O001286000A00404O00DD0008000A4O003B01085O002E190041003C000100410004623O00302O012O00EF0008000F3O00063A000800302O013O0004623O00302O012O00EF0008000C4O002C0109000D3O00122O000A00423O00122O000B00436O0009000B00024O00080008000900202O0008000800444O00080002000200062O000800302O013O0004623O00302O012O00EF000800013O0020A50008000800452O00610008000200020026E9000800302O0100460004623O00302O012O00EF0008000C4O00130009000D3O00122O000A00473O00122O000B00486O0009000B00024O00080008000900202O0008000800374O000800020002000E2O0002001D2O0100080004623O001D2O012O00EF0008000B4O00A10009000C6O000A000D3O00122O000B00493O00122O000C004A6O000A000C00024O00090009000A00202O00090009004B4O00090002000200062O000800302O0100090004623O00302O012O00EF0008000E4O00510009000C3O00202O00090009004C4O000A00023O00202O000A000A003C4O000C000C3O00202O000C000C004C4O000A000C00024O000A000A6O0008000A000200062O0008002B2O0100010004623O002B2O01002E19004D00070001004E0004623O00302O012O00EF0008000D3O0012860009004F3O001286000A00504O00DD0008000A4O003B01085O001286000700053O0004623O00AA0001000E48010500A5000100060004623O00A50001002E16015100532O0100520004623O00532O012O00EF0007000F3O00063A000700532O013O0004623O00532O012O00EF0007000C4O002C0108000D3O00122O000900533O00122O000A00546O0008000A00024O00070007000800202O00070007002E4O00070002000200062O000700532O013O0004623O00532O012O00EF0007000E4O00540008000C3O00202O0008000800554O000900023O00202O00090009005600122O000B000A6O0009000B00024O000900096O00070009000200062O000700532O013O0004623O00532O012O00EF0007000D3O001286000800573O001286000900584O00DD000700094O003B01075O001286000400063O0004623O00562O010004623O00A50001000E040059005A2O0100040004623O005A2O01002E91005A00340201005B0004623O00340201001286000600013O0026430106009D2O0100050004623O009D2O012O00EF0007000C4O002C0108000D3O00122O0009005C3O00122O000A005D6O0008000A00024O00070007000800202O0007000700444O00070002000200062O0007009B2O013O0004623O009B2O012O00EF0007000C4O00350108000D3O00122O0009005E3O00122O000A005F6O0008000A00024O00070007000800202O0007000700374O0007000200024O0008000C6O0009000D3O00122O000A00603O00122O000B00616O0009000B00024O00080008000900202O00080008003A4O00080002000200202O00080008000500062O0008008A2O0100070004623O008A2O012O00EF0007000B4O0056000800106O000900013O00202O0009000900624O00090002000200122O000A00636O0008000A00024O000900116O000A00013O00202O000A000A00624O000A00020002001286000B00634O00270109000B00022O00EE0008000800090006810007009B2O0100080004623O009B2O012O00EF0007000E4O001F0008000C3O00202O00080008003B4O000900023O00202O00090009003C4O000B000C3O00202O000B000B003B4O0009000B00024O000900096O00070009000200062O0007009B2O013O0004623O009B2O012O00EF0007000D3O001286000800643O001286000900654O00DD000700094O003B01075O001286000400663O0004623O00340201000E482O01005B2O0100060004623O005B2O01001286000700013O002643010700A42O0100050004623O00A42O01001286000600053O0004623O005B2O01002643010700A02O0100010004623O00A02O012O00EF0008000C4O002C0109000D3O00122O000A00673O00122O000B00686O0009000B00024O00080008000900202O00080008002E4O00080002000200062O000800CE2O013O0004623O00CE2O012O00EF0008000C4O002C0109000D3O00122O000A00693O00122O000B006A6O0009000B00024O00080008000900202O0008000800314O00080002000200062O000800C42O013O0004623O00C42O012O00EF0008000C4O002C0109000D3O00122O000A006B3O00122O000B006C6O0009000B00024O00080008000900202O0008000800314O00080002000200062O000800D02O013O0004623O00D02O012O00EF0008000C4O002C0109000D3O00122O000A006D3O00122O000B006E6O0009000B00024O00080008000900202O0008000800314O00080002000200062O000800D02O013O0004623O00D02O01002E19006F0014000100700004623O00E22O012O00EF0008000E4O00F90009000C3O00202O0009000900714O000A00023O00202O000A000A003C4O000C000C3O00202O000C000C00714O000A000C00024O000A000A6O000B00016O0008000B000200062O000800E22O013O0004623O00E22O012O00EF0008000D3O001286000900723O001286000A00734O00DD0008000A4O003B01085O002E9100750031020100740004623O003102012O00EF0008000C4O002C0109000D3O00122O000A00763O00122O000B00776O0009000B00024O00080008000900202O00080008002E4O00080002000200062O0008003102013O0004623O003102012O00EF0008000B3O0026E900080031020100780004623O003102012O00EF0008000B4O009F000900106O000A000C6O000B000D3O00122O000C00793O00122O000D007A6O000B000D00024O000A000A000B00202O000A000A007B4O000A000200024O000B000C4O00EF000C000D3O0012F6000D007C3O00122O000E007D6O000C000E00024O000B000B000C00202O000B000B007E4O000B000200024O000A000A000B00122O000B00636O0009000B00024O000A00114O00EF000B000C4O0012010C000D3O00122O000D00793O00122O000E007A6O000C000E00024O000B000B000C00202O000B000B007B4O000B000200024O000C000C6O000D000D3O00122O000E007C3O001286000F007D4O000B010D000F00024O000C000C000D00202O000C000C007E4O000C000200024O000B000B000C00122O000C00636O000A000C00024O00090009000A00062O00090031020100080004623O003102012O00EF0008000E4O00580009000C3O00202O0009000900714O000A00023O00202O000A000A003C4O000C000C3O00202O000C000C00714O000A000C00024O000A000A6O000B00016O0008000B000200062O0008002C020100010004623O002C0201002E91008000310201007F0004623O003102012O00EF0008000D3O001286000900813O001286000A00824O00DD0008000A4O003B01085O001286000700053O0004623O00A02O010004623O005B2O01002E19008300B0000100830004623O00E40201002643010400E4020100840004623O00E40201001286000600014O0050000700073O002E160186003A020100850004623O003A0201000E482O01003A020100060004623O003A0201001286000700013O000E482O0100B6020100070004623O00B60201001286000800013O002E9100870048020100880004623O00480201000E4801050048020100080004623O00480201001286000700053O0004623O00B6020100262D0008004C020100010004623O004C0201002E91008A0042020100890004623O00420201002E91008C007B0201008B0004623O007B02012O00EF0009000C4O002C010A000D3O00122O000B008D3O00122O000C008E6O000A000C00024O00090009000A00202O00090009002E4O00090002000200062O0009007B02013O0004623O007B02012O00EF000900013O0020D400090009008F4O000B000C3O00202O000B000B00904O0009000B00024O000A000C6O000B000D3O00122O000C00913O00122O000D00926O000B000D00024O000A000A000B00202O000A000A007B4O000A0002000200062O000A007B020100090004623O007B0201002E160194007B020100930004623O007B02012O00EF0009000E4O00F9000A000C3O00202O000A000A00714O000B00023O00202O000B000B003C4O000D000C3O00202O000D000D00714O000B000D00024O000B000B6O000C00016O0009000C000200062O0009007B02013O0004623O007B02012O00EF0009000D3O001286000A00953O001286000B00964O00DD0009000B4O003B01096O00EF0009000C4O002C010A000D3O00122O000B00973O00122O000C00986O000A000C00024O00090009000A00202O00090009002E4O00090002000200062O000900B402013O0004623O00B402012O00EF000900013O0020E70009000900994O000B000C3O00202O000B000B009A4O0009000B000200062O000900B402013O0004623O00B402012O00EF0009000C4O0002000A000D3O00122O000B009B3O00122O000C009C6O000A000C00024O00090009000A00202O0009000900314O00090002000200062O000900B4020100010004623O00B402012O00EF0009000C4O0002000A000D3O00122O000B009D3O00122O000C009E6O000A000C00024O00090009000A00202O0009000900314O00090002000200062O000900B4020100010004623O00B402012O00EF0009000E4O0058000A000C3O00202O000A000A00714O000B00023O00202O000B000B003C4O000D000C3O00202O000D000D00714O000B000D00024O000B000B6O000C00016O0009000C000200062O000900AF020100010004623O00AF0201002E19009F0007000100A00004623O00B402012O00EF0009000D3O001286000A00A13O001286000B00A24O00DD0009000B4O003B01095O001286000800053O0004623O0042020100262D000700BA020100050004623O00BA0201002E1601A4003F020100A30004623O003F02012O00EF0008000C4O002C0109000D3O00122O000A00A53O00122O000B00A66O0009000B00024O00080008000900202O00080008002E4O00080002000200062O000800CB02013O0004623O00CB02012O00EF000800013O00201F0108000800994O000A000C3O00202O000A000A00A74O0008000A000200062O000800CD020100010004623O00CD0201002E9100A900DF020100A80004623O00DF02012O00EF0008000E4O00F90009000C3O00202O0009000900714O000A00023O00202O000A000A003C4O000C000C3O00202O000C000C00714O000A000C00024O000A000A6O000B00016O0008000B000200062O000800DF02013O0004623O00DF02012O00EF0008000D3O001286000900AA3O001286000A00AB4O00DD0008000A4O003B01085O001286000400AC3O0004623O00E402010004623O003F02010004623O00E402010004623O003A020100264301040007040100060004623O00070401001286000600013O002E1601AD0072030100AE0004623O0072030100264301060072030100050004623O007203012O00EF0007000C4O002C0108000D3O00122O000900AF3O00122O000A00B06O0008000A00024O00070007000800202O0007000700444O00070002000200062O0007007003013O0004623O007003012O00EF000700023O0020E70007000700B14O0009000C3O00202O0009000900B24O00070009000200062O0007000603013O0004623O000603012O00EF0007000C4O00020008000D3O00122O000900B33O00122O000A00B46O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007000D030100010004623O000D03012O00EF000700023O00204A0107000700324O0009000C3O00202O0009000900B24O00070009000200262O00070070030100060004623O007003012O00EF0007000C4O002C0108000D3O00122O000900B53O00122O000A00B66O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007002603013O0004623O002603012O00EF0007000C4O00480008000D3O00122O000900B73O00122O000A00B86O0008000A00024O00070007000800202O0007000700B94O0007000200024O000800023O00202O0008000800324O000A000C3O002095000A000A00B22O00270108000A000200068100080070030100070004623O007003012O00EF0007000C4O002C0108000D3O00122O000900BA3O00122O000A00BB6O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007005C03013O0004623O005C03012O00EF000700104O009E0008000C6O0009000D3O00122O000A00BC3O00122O000B00BD6O0009000B00024O00080008000900202O0008000800B94O0008000200024O0009000C6O000A000D3O00122O000B00BE3O00122O000C00BF6O000A000C00024O00090009000A00202O00090009007B4O0009000A6O00073O00024O000800116O0009000C6O000A000D3O00122O000B00BC3O00122O000C00BD6O000A000C00024O00090009000A00202O0009000900B94O0009000200024O000A000C6O000B000D3O00122O000C00BE3O00122O000D00BF6O000B000D00024O000A000A000B00202O000A000A007B4O000A000B6O00083O00024O0007000700084O000800023O00202O0008000800324O000A000C3O00202O000A000A00B24O0008000A000200062O00080070030100070004623O00700301002E1900C00014000100C00004623O007003012O00EF0007000E4O00F9000800123O00202O0008000800C14O000900023O00202O00090009003C4O000B000C3O00202O000B000B00C24O0009000B00024O000900096O000A00016O0007000A000200062O0007007003013O0004623O007003012O00EF0007000D3O001286000800C33O001286000900C44O00DD000700094O003B01075O001286000400113O0004623O00070401002643010600E7020100010004623O00E70201001286000700013O00262D00070079030100050004623O00790301002E9100C6007B030100C50004623O007B0301001286000600053O0004623O00E70201002E9100C80075030100C70004623O0075030100264301070075030100010004623O007503012O00EF0008000C4O002C0109000D3O00122O000A00C93O00122O000B00CA6O0009000B00024O00080008000900202O00080008002E4O00080002000200062O000800A403013O0004623O00A403012O00EF0008000C4O002C0109000D3O00122O000A00CB3O00122O000B00CC6O0009000B00024O00080008000900202O0008000800314O00080002000200062O000800A403013O0004623O00A403012O00EF0008000E4O008E0009000C3O00202O0009000900CD4O000A00023O00202O000A000A005600122O000C000A6O000A000C00024O000A000A6O000B00016O0008000B000200062O000800A403013O0004623O00A403012O00EF0008000D3O001286000900CE3O001286000A00CF4O00DD0008000A4O003B01086O00EF0008000C4O002C0109000D3O00122O000A00D03O00122O000B00D16O0009000B00024O00080008000900202O0008000800444O00080002000200062O000800F003013O0004623O00F003012O00EF000800013O0020A50008000800452O0061000800020002002609010800F0030100D20004623O00F003012O00EF000800023O0020CA0008000800324O000A000C3O00202O000A000A00334O0008000A00024O000900106O000A000C6O000B000D3O00122O000C00D33O00122O000D00D46O000B000D00024O000A000A000B00202O000A000A007B4O000A000200024O000B000C6O000C000D3O00122O000D00D53O00122O000E00D66O000C000E00024O000B000B000C00202O000B000B007E4O000B000C6O00093O00024O000A00116O000B000C6O000C000D3O00122O000D00D33O00122O000E00D46O000C000E00024O000B000B000C00202O000B000B007B4O000B000200024O000C000C6O000D000D3O00122O000E00D53O00122O000F00D66O000D000F00024O000C000C000D00202O000C000C007E4O000C000D6O000A3O00024O00090009000A00062O000900F2030100080004623O00F203012O00EF0008000C4O00020009000D3O00122O000A00D73O00122O000B00D86O0009000B00024O00080008000900202O0008000800314O00080002000200062O000800F0030100010004623O00F003012O00EF000800013O00201F0108000800994O000A000C3O00202O000A000A00D94O0008000A000200062O000800F2030100010004623O00F20301002E9100DB002O040100DA0004623O002O04012O00EF0008000E4O00F90009000C3O00202O0009000900DC4O000A00023O00202O000A000A003C4O000C000C3O00202O000C000C00DC4O000A000C00024O000A000A6O000B00016O0008000B000200062O0008002O04013O0004623O002O04012O00EF0008000D3O001286000900DD3O001286000A00DE4O00DD0008000A4O003B01085O001286000700053O0004623O007503010004623O00E70201002643010400EE040100DF0004623O00EE04012O00EF0006000C4O002C0107000D3O00122O000800E03O00122O000900E16O0007000900024O00060006000700202O0006000600444O00060002000200062O0006005404013O0004623O005404012O00EF0006000C4O000C0007000D3O00122O000800E23O00122O000900E36O0007000900024O00060006000700202O0006000600E44O000600020002000E2O00050054040100060004623O005404012O00EF0006000C4O002C0107000D3O00122O000800E53O00122O000900E66O0007000900024O00060006000700202O0006000600314O00060002000200062O0006004504013O0004623O004504012O00EF0006000C4O002C0107000D3O00122O000800E73O00122O000900E86O0007000900024O00060006000700202O0006000600314O00060002000200062O0006004504013O0004623O004504012O00EF0006000C4O00020007000D3O00122O000800E93O00122O000900EA6O0007000900024O00060006000700202O0006000600314O00060002000200062O00060054040100010004623O005404012O00EF0006000C4O00020007000D3O00122O000800EB3O00122O000900EC6O0007000900024O00060006000700202O0006000600314O00060002000200062O00060054040100010004623O005404012O00EF000600023O00201A0106000600324O0008000C3O00202O0008000800B24O0006000800024O0007000C6O0008000D3O00122O000900ED3O00122O000A00EE6O0008000A00024O00070007000800202O00070007007B4O00070002000200062O00070056040100060004623O00560401002E9100F00069040100EF0004623O00690401002E1601F20069040100F10004623O006904012O00EF0006000E4O008E0007000C3O00202O0007000700CD4O000800023O00202O00080008005600122O000A000A6O0008000A00024O000800086O000900016O00060009000200062O0006006904013O0004623O006904012O00EF0006000D3O001286000700F33O001286000800F44O00DD000600084O003B01066O00EF0006000C4O002C0107000D3O00122O000800F53O00122O000900F66O0007000900024O00060006000700202O0006000600444O00060002000200062O0006009C04013O0004623O009C04012O00EF000600013O0020E70006000600F74O0008000C3O00202O00080008009A4O00060008000200062O0006009C04013O0004623O009C04012O00EF000600013O0020A50006000600452O0061000600020002000E200034009C040100060004623O009C04012O00EF0006000C4O00020007000D3O00122O000800F83O00122O000900F96O0007000900024O00060006000700202O0006000600314O00060002000200062O0006009C040100010004623O009C04012O00EF0006000E4O00510007000C3O00202O00070007003B4O000800023O00202O00080008003C4O000A000C3O00202O000A000A003B4O0008000A00024O000800086O00060008000200062O00060097040100010004623O00970401002E1601FA009C040100FB0004623O009C04012O00EF0006000D3O001286000700FC3O001286000800FD4O00DD000600084O003B01066O00EF0006000C4O002C0107000D3O00122O000800FE3O00122O000900FF6O0007000900024O00060006000700202O0006000600444O00060002000200062O000600ED04013O0004623O00ED04012O00EF000600013O0020E70006000600994O0008000C3O00202O000800082O00013O00060008000200062O000600ED04013O0004623O00ED04012O00EF000600104O009E0007000C6O0008000D3O00122O0009002O012O00122O000A0002015O0008000A00024O00070007000800202O00070007007B4O0007000200024O0008000C6O0009000D3O00122O000A0003012O00122O000B0004015O0009000B00024O00080008000900202O00080008007B4O000800096O00063O00024O000700116O0008000C6O0009000D3O00122O000A002O012O00122O000B0002015O0009000B00024O00080008000900202O00080008007B4O0008000200024O0009000C6O000A000D3O00122O000B0003012O00122O000C0004015O000A000C00024O00090009000A00202O00090009007B4O0009000A6O00073O00024O0006000600074O000700013O00202O00070007008F4O0009000C3O00202O0009000900A74O00070009000200062O000600ED040100070004623O00ED04012O00EF0006000E4O00930007000C3O00122O00080005015O0007000700084O000800023O00202O00080008003C4O000A000C3O00122O000B0005015O000A000A000B4O0008000A00024O000800086O000900016O00060009000200062O000600ED04013O0004623O00ED04012O00EF0006000D3O00128600070006012O00128600080007013O00DD000600084O003B01065O001286000400843O001286000600663O00066B000400F5040100060004623O00F5040100128600060008012O00128600070009012O00068100060018050100070004623O001805012O00EF0006000C4O002C0107000D3O00122O0008000A012O00122O0009000B015O0007000900024O00060006000700202O0006000600444O00060002000200062O0006007008013O0004623O007008010012860006000C012O0012860007000C012O00060001060070080100070004623O007008012O00EF0006000E4O00930007000C3O00122O00080005015O0007000700084O000800023O00202O00080008003C4O000A000C3O00122O000B0005015O000A000A000B4O0008000A00024O000800086O000900016O00060009000200062O0006007008013O0004623O007008012O00EF0006000D3O00129C0007000D012O00122O0008000E015O000600086O00065O00044O007008010012860006000F012O00128600070010012O000645010700F3050100060004623O00F30501001286000600113O000600010400F3050100060004623O00F30501001286000600014O0050000700073O001286000800013O00066B00060028050100080004623O0028050100128600080011012O00128600090012012O00068100080021050100090004623O00210501001286000700013O001286000800013O000600010800BF050100070004623O00BF0501001286000800013O001286000900053O00060001080032050100090004623O00320501001286000700053O0004623O00BF0501001286000900013O0006000108002D050100090004623O002D050100128600090013012O001286000A0013012O000600010900910501000A0004623O009105012O00EF0009000C4O002C010A000D3O00122O000B0014012O00122O000C0015015O000A000C00024O00090009000A00202O0009000900444O00090002000200062O0009009105013O0004623O009105012O00EF000900133O00067E00090091050100010004623O009105012O00EF0009000C4O002C010A000D3O00122O000B0016012O00122O000C0017015O000A000C00024O00090009000A00202O0009000900314O00090002000200062O0009009105013O0004623O009105012O00EF000900013O0020AC0009000900994O000B000C3O00122O000C0018015O000B000B000C4O0009000B000200062O0009007E050100010004623O007E05012O00EF000900144O00DB000900010002001286000A00013O000681000A0067050100090004623O006705012O00EF0009000C4O0002000A000D3O00122O000B0019012O00122O000C001A015O000A000C00024O00090009000A00202O0009000900314O00090002000200062O0009007E050100010004623O007E05012O00EF000900013O0020AC0009000900994O000B000C3O00122O000C0018015O000B000B000C4O0009000B000200062O00090074050100010004623O007405012O00EF000900144O00DB000900010002001286000A00013O000681000A0091050100090004623O009105012O00EF0009000C4O0002000A000D3O00122O000B001B012O00122O000C001C015O000A000C00024O00090009000A00202O0009000900314O00090002000200062O00090091050100010004623O009105012O00EF0009000E4O0021000A000C3O00122O000B001D015O000A000A000B4O000B00023O00202O000B000B003C4O000D000C3O00122O000E001D015O000D000D000E4O000B000D00024O000B000B4O00270109000B000200063A0009009105013O0004623O009105012O00EF0009000D3O001286000A001E012O001286000B001F013O00DD0009000B4O003B01096O00EF0009000C4O002C010A000D3O00122O000B0020012O00122O000C0021015O000A000C00024O00090009000A00202O00090009002E4O00090002000200062O000900BD05013O0004623O00BD05012O00EF000900144O00DB000900010002001286000A00013O000622000A00AB050100090004623O00AB05012O00EF000900154O00DB000900010002001286000A00013O000622000A00AB050100090004623O00AB05012O00EF000900013O0020A50009000900452O0061000900020002001286000A00113O000645010A00BD050100090004623O00BD05012O00EF0009000E4O00F9000A000C3O00202O000A000A00714O000B00023O00202O000B000B003C4O000D000C3O00202O000D000D00714O000B000D00024O000B000B6O000C00016O0009000C000200062O000900BD05013O0004623O00BD05012O00EF0009000D3O001286000A0022012O001286000B0023013O00DD0009000B4O003B01095O001286000800053O0004623O002D0501001286000800053O00060001070029050100080004623O002905012O00EF0008000F3O00063A000800EE05013O0004623O00EE05012O00EF0008000C4O002C0109000D3O00122O000A0024012O00122O000B0025015O0009000B00024O00080008000900202O0008000800444O00080002000200062O000800EE05013O0004623O00EE05012O00EF000800163O00063A000800EE05013O0004623O00EE05012O00EF000800163O001286000A0026013O00C500080008000A2O006100080002000200063A000800EE05013O0004623O00EE05012O00EF000800163O0012CB000A0027015O00080008000A4O0008000200024O000900023O00122O000B0027015O00090009000B4O00090002000200062O000800EE050100090004623O00EE05012O00EF0008000E4O000E000900123O00122O000A0028015O00090009000A4O00080002000200062O000800EE05013O0004623O00EE05012O00EF0008000D3O00128600090029012O001286000A002A013O00DD0008000A4O003B01085O001286000400DF3O0004623O00F305010004623O002905010004623O00F305010004623O00210501001286000600AC3O00066B000400FA050100060004623O00FA05010012860006002B012O0012860007002C012O000681000600A3060100070004623O00A30601001286000600013O001286000700053O00060001060026060100070004623O002606010012860007002D012O0012860008002D012O00060001070024060100080004623O002406012O00EF0007000C4O002C0108000D3O00122O0009002E012O00122O000A002F015O0008000A00024O00070007000800202O00070007002E4O00070002000200062O0007002406013O0004623O002406012O00EF000700013O0020A50007000700452O0061000700020002001286000800D23O00064501080024060100070004623O002406012O00EF0007000E4O00F90008000C3O00202O0008000800714O000900023O00202O00090009003C4O000B000C3O00202O000B000B00714O0009000B00024O000900096O000A00016O0007000A000200062O0007002406013O0004623O002406012O00EF0007000D3O00128600080030012O00128600090031013O00DD000700094O003B01075O001286000400593O0004623O00A3060100128600070032012O00128600080033012O000681000800FB050100070004623O00FB0501001286000700013O000600010600FB050100070004623O00FB05012O00EF0007000C4O002C0108000D3O00122O00090034012O00122O000A0035015O0008000A00024O00070007000800202O0007000700444O00070002000200062O0007007F06013O0004623O007F06012O00EF0007000C4O002C0108000D3O00122O00090036012O00122O000A0037015O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007005F06013O0004623O005F06012O00EF0007000C4O002C0108000D3O00122O00090038012O00122O000A0039015O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007005F06013O0004623O005F06012O00EF0007000C4O00020008000D3O00122O0009003A012O00122O000A003B015O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007007F060100010004623O007F06012O00EF0007000C4O00020008000D3O00122O0009003C012O00122O000A003D015O0008000A00024O00070007000800202O0007000700314O00070002000200062O0007007F060100010004623O007F06012O00EF000700023O0020D40007000700324O0009000C3O00202O0009000900B24O0007000900024O0008000C6O0009000D3O00122O000A003E012O00122O000B003F015O0009000B00024O00080008000900202O00080008007B4O00080002000200062O0008007F060100070004623O007F06012O00EF0007000E4O008E0008000C3O00202O0008000800CD4O000900023O00202O00090009005600122O000B000A6O0009000B00024O000900096O000A00016O0007000A000200062O0007007F06013O0004623O007F06012O00EF0007000D3O00128600080040012O00128600090041013O00DD000700094O003B01076O00EF0007000F3O00063A000700A106013O0004623O00A106012O00EF0007000C4O002C0108000D3O00122O00090042012O00122O000A0043015O0008000A00024O00070007000800202O0007000700444O00070002000200062O000700A106013O0004623O00A1060100128600070044012O00128600080045012O000681000700A1060100080004623O00A106012O00EF0007000E4O001F0008000C3O00202O00080008004C4O000900023O00202O00090009003C4O000B000C3O00202O000B000B004C4O0009000B00024O000900096O00070009000200062O000700A106013O0004623O00A106012O00EF0007000D3O00128600080046012O00128600090047013O00DD000700094O003B01075O001286000600053O0004623O00FB0501001286000600053O00066B000400AA060100060004623O00AA060100128600060048012O00128600070049012O0006810007000E070100060004623O000E0701001286000600013O001286000700013O000600010600C3060100070004623O00C30601001286000700013O001286000800053O000600010700B4060100080004623O00B40601001286000600053O0004623O00C30601001286000800013O00066B000700BB060100080004623O00BB06010012860008004A012O0012860009004B012O000645010800AF060100090004623O00AF06012O00EF000800174O00DB0008000100022O0023000500083O00063A000500C106013O0004623O00C106012O0073000500023O001286000700053O0004623O00AF0601001286000700053O000600010600AB060100070004623O00AB06012O00EF0007000F3O00063A0007000B07013O0004623O000B0701001286000700014O00500008000A3O001286000B004C012O001286000C004D012O000681000B00040701000C0004623O00040701001286000B00053O000600010700040701000B0004623O000407012O0050000A000A3O001286000B00013O00066B000800DA0601000B0004623O00DA0601001286000B000F012O001286000C004E012O000645010B00E70601000C0004623O00E70601001286000B00013O001286000C00053O000600010B00E00601000C0004623O00E00601001286000800053O0004623O00E70601001286000C00013O000600010B00DB0601000C0004623O00DB0601001286000900014O0050000A000A3O001286000B00053O0004623O00DB0601001286000B00053O00066B000800EE0601000B0004623O00EE0601001286000B004F012O001286000C006F3O000681000C00D30601000B0004623O00D30601001286000B00013O00066B000900F50601000B0004623O00F50601001286000B0050012O001286000C0051012O000645010B00EE0601000C0004623O00EE06012O00EF000B00184O0038010B000100024O000A000B3O00122O000B0052012O00122O000C0052012O00062O000B000B0701000C0004623O000B070100063A000A000B07013O0004623O000B07012O0073000A00023O0004623O000B07010004623O00EE06010004623O000B07010004623O00D306010004623O000B0701001286000B00013O000600010700CB0601000B0004623O00CB0601001286000800014O0050000900093O001286000700053O0004623O00CB0601001286000400023O0004623O000E07010004623O00AB0601001286000600013O000600010400A0000100060004623O00A00001001286000600013O001286000700053O00066B00060019070100070004623O0019070100128600070053012O00128600080054012O00064501070050070100080004623O005007012O00EF000700043O001286000800063O0006810007001E070100080004623O001E07010004623O004E0701001286000700014O00500008000A3O001286000B00013O000600010700260701000B0004623O00260701001286000800014O0050000900093O001286000700053O001286000B0055012O001286000C0055012O000600010B00200701000C0004623O00200701001286000B00053O000600010700200701000B0004623O002007012O0050000A000A3O001286000B00053O00066B000800350701000B0004623O00350701001286000B0056012O001286000C0057012O000645010C00410701000B0004623O00410701001286000B00013O000600010900350701000B0004623O003507012O00EF000B00194O00DB000B000100022O0023000A000B3O00063A000A004E07013O0004623O004E07012O0073000A00023O0004623O004E07010004623O003507010004623O004E0701001286000B004F012O001286000C0058012O000645010C002E0701000B0004623O002E0701001286000B00013O0006000108002E0701000B0004623O002E0701001286000900014O0050000A000A3O001286000800053O0004623O002E07010004623O004E07010004623O00200701001286000400053O0004623O00A00001001286000700013O00060001060012070100070004623O001207012O00EF000700013O0020A50007000700192O006100070002000200067E00070070070100010004623O007007012O00EF0007001A3O00063A0007007007013O0004623O00700701001286000700014O0050000800083O001286000900013O00066B00070064070100090004623O0064070100128600090059012O001286000A005A012O0006000109005D0701000A0004623O005D07012O00EF0009001B4O00DB0009000100022O0023000800093O00067E0008006D070100010004623O006D07010012860009005B012O001286000A005C012O000645010900700701000A0004623O007007012O0073000800023O0004623O007007010004623O005D07012O00EF000700043O001286000800053O000681000800C0070100070004623O00C007012O00EF000700044O00EF000800103O001286000900024O00EF000A001C4O00EF000B000C4O0002000C000D3O00122O000D005D012O00122O000E005E015O000C000E00024O000B000B000C00202O000B000B00314O000B0002000200062O000B0095070100010004623O009507012O00EF000B000C4O002C010C000D3O00122O000D005F012O00122O000E0060015O000C000E00024O000B000B000C00202O000B000B00314O000B0002000200062O000B009707013O0004623O009707012O00EF000B000C4O00BE000C000D3O00122O000D0061012O00122O000E0062015O000C000E00024O000B000B000C00202O000B000B00314O000B0002000200044O009707012O0046010B6O00B8000B00014O00CE000A000B4O00D300083O00024O000900113O00122O000A00026O000B001C6O000C000C4O0002000D000D3O00122O000E005D012O00122O000F005E015O000D000F00024O000C000C000D00202O000C000C00314O000C0002000200062O000C00B9070100010004623O00B907012O00EF000C000C4O002C010D000D3O00122O000E005F012O00122O000F0060015O000D000F00024O000C000C000D00202O000C000C00314O000C0002000200062O000C00BB07013O0004623O00BB07012O00EF000C000C4O00BE000D000D3O00122O000E0061012O00122O000F0062015O000D000F00024O000C000C000D00202O000C000C00314O000C0002000200044O00BB07012O0046010C6O00B8000C00014O00CE000B000C4O00FD00093O00022O00EE00080008000900065B00070008000100080004623O00C707012O00EF0007001D3O00067E000700C7070100010004623O00C7070100128600070063012O00128600080064012O000645010700EB070100080004623O00EB0701001286000700014O0050000800093O001286000A00053O000600010700E00701000A0004623O00E00701001286000A00013O00066B000800D30701000A0004623O00D30701001286000A0065012O001286000B0066012O000645010A00CC0701000B0004623O00CC07012O00EF000A001E4O00DB000A000100022O00230009000A3O00067E000900DC070100010004623O00DC0701001286000A0067012O001286000B0068012O000681000A00EB0701000B0004623O00EB07012O0073000900023O0004623O00EB07010004623O00CC07010004623O00EB0701001286000A00013O00066B000700E70701000A0004623O00E70701001286000A0069012O001286000B006A012O000681000A00C90701000B0004623O00C90701001286000800014O0050000900093O001286000700053O0004623O00C90701001286000600053O0004623O001207010004623O00A000010004623O00700801001286000600013O0006000103009C000100060004623O009C0001001286000400014O0050000500053O001286000300053O0004623O009C00010004623O00700801001286000600013O00066B000200FE070100060004623O00FE07010012860006006B012O0012860007006C012O00060001060099000100070004623O00990001001286000300014O0050000400043O001286000200053O0004623O009900010004623O00700801001286000200013O00066B0001000A080100020004623O000A08010012860002006D012O0012860003006E012O00060001020031080100030004623O00310801001286000200013O001286000300053O00060001020010080100030004623O00100801001286000100053O0004623O003108010012860003006F012O00128600040070012O0006810004000B080100030004623O000B0801001286000300013O0006000102000B080100030004623O000B0801001286000300013O001286000400013O0006000104002A080100030004623O002A08012O00EF0004001F4O000C01040001000100122O00040071015O0005000D3O00122O00060072012O00122O00070073015O0005000700024O0004000400054O0005000D3O00122O00060074012O00122O00070075013O00270105000700022O006D0004000400052O00030004001A3O001286000300053O001286000400053O00060001030018080100040004623O00180801001286000200053O0004623O000B08010004623O001808010004623O000B0801001286000200053O0006002O010005000100020004623O00050001001286000200013O001286000300053O0006000102003A080100030004623O003A0801001286000100023O0004623O0005000100128600030076012O00128600040077012O00068100040035080100030004623O00350801001286000300013O00060001020035080100030004623O00350801001286000300013O00128600040078012O00128600050079012O00068100050062080100040004623O00620801001286000400013O00060001030062080100040004623O006208010012A600040071013O002E0105000D3O00122O0006007A012O00122O0007007B015O0005000700024O0004000400054O0005000D3O00122O0006007C012O00122O0007007D015O0005000700024O0004000400054O000400033O00122O00040071015O0005000D3O00122O0006007E012O00122O0007007F015O0005000700024O0004000400054O0005000D3O00122O00060080012O00122O00070081015O0005000700024O0004000400054O0004000F3O00122O000300053O00128600040082012O00128600050045012O00064501050042080100040004623O00420801001286000400053O00060001030042080100040004623O00420801001286000200053O0004623O003508010004623O004208010004623O003508010004623O000500010004623O007008010004623O000200012O00AD3O00017O00093O00028O00025O00606E40025O00A4B140030E3O00D4C6A0EDA5F5E9CE89E7ABE1FBCD03063O00949DABCD82C903143O00526567697374657241757261547261636B696E6703053O005072696E7403393O0007D1673DC3E320C07D26DFB614D56625DEF528946626C5F737DD7B2791F43A945139D8F56D94473CC1E62CC6602CD5B621CD340EDEFC2AC67503063O009643B41449B1001D3O0012863O00014O0050000100013O002643012O0002000100010004623O00020001001286000100013O002E9100020005000100030004623O00050001000E482O010005000100010004623O000500012O00EF00026O0039010300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O0002000200014O000200023O00202O0002000200074O000300013O00122O000400083O00122O000500096O000300056O00023O000100044O001C00010004623O000500010004623O001C00010004623O000200012O00AD3O00017O00", GetFEnv(), ...);

