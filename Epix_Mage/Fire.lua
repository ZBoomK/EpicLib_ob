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
				if (Enum <= 185) then
					if (Enum <= 92) then
						if (Enum <= 45) then
							if (Enum <= 22) then
								if (Enum <= 10) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
										elseif (Enum <= 2) then
											local B;
											local A;
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											if (Stk[Inst[2]] > Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = VIP + Inst[3];
											end
										elseif (Enum == 3) then
											local B;
											local A;
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
										elseif (Enum == 6) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
										end
									elseif (Enum <= 8) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 9) then
										do
											return Stk[Inst[2]];
										end
									else
										local B;
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 16) then
									if (Enum <= 13) then
										if (Enum <= 11) then
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
										elseif (Enum == 12) then
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
											Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 15) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 19) then
									if (Enum <= 17) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 20) then
									Stk[Inst[2]]();
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
								elseif (Enum == 21) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 33) then
								if (Enum <= 27) then
									if (Enum <= 24) then
										if (Enum > 23) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 25) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									elseif (Enum > 26) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 30) then
									if (Enum <= 28) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 29) then
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
								elseif (Enum <= 31) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 32) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 39) then
								if (Enum <= 36) then
									if (Enum <= 34) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 35) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
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
								elseif (Enum <= 37) then
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
								elseif (Enum > 38) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 42) then
								if (Enum <= 40) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 41) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
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
							elseif (Enum > 44) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 68) then
							if (Enum <= 56) then
								if (Enum <= 50) then
									if (Enum <= 47) then
										if (Enum > 46) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 49) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if (Stk[Inst[2]] == Inst[4]) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 52) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 55) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 60) then
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
								elseif (Enum == 61) then
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
								elseif (Enum > 64) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 66) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 67) then
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
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 80) then
							if (Enum <= 74) then
								if (Enum <= 71) then
									if (Enum <= 69) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = {};
									else
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									end
								elseif (Enum <= 72) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum == 73) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 77) then
								if (Enum <= 75) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
								elseif (Enum > 76) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = #Stk[Inst[3]];
								end
							elseif (Enum <= 78) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 79) then
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
						elseif (Enum <= 86) then
							if (Enum <= 83) then
								if (Enum <= 81) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 82) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 84) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 85) then
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
						elseif (Enum <= 89) then
							if (Enum <= 87) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 88) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 90) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Stk[Inst[4]]];
						elseif (Enum == 91) then
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
					elseif (Enum <= 138) then
						if (Enum <= 115) then
							if (Enum <= 103) then
								if (Enum <= 97) then
									if (Enum <= 94) then
										if (Enum > 93) then
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											Stk[Inst[2]]();
										end
									elseif (Enum <= 95) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 96) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Top = (A + Varargsz) - 1;
										for Idx = A, Top do
											local VA = Vararg[Idx - A];
											Stk[Idx] = VA;
										end
									end
								elseif (Enum <= 100) then
									if (Enum <= 98) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum > 99) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Inst[3] ~= 0;
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 102) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 109) then
								if (Enum <= 106) then
									if (Enum <= 104) then
										local B;
										local A;
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
									elseif (Enum == 105) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 107) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
								elseif (Enum == 108) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 112) then
								if (Enum <= 110) then
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
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 111) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 126) then
							if (Enum <= 120) then
								if (Enum <= 117) then
									if (Enum > 116) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 118) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								elseif (Enum > 119) then
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
								else
									local B;
									local A;
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 123) then
								if (Enum <= 121) then
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 122) then
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								else
									local Edx;
									local Results, Limit;
									local B;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
								end
							elseif (Enum <= 124) then
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
							elseif (Enum > 125) then
								local A;
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							if (Enum <= 129) then
								if (Enum <= 127) then
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
								elseif (Enum == 128) then
									if (Inst[2] <= Inst[4]) then
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
							elseif (Enum <= 130) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 131) then
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
								if (Inst[2] <= Inst[4]) then
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
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 135) then
							if (Enum <= 133) then
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
							elseif (Enum == 134) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
							else
								local A;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 136) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 137) then
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
					elseif (Enum <= 161) then
						if (Enum <= 149) then
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
								elseif (Enum <= 141) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								elseif (Enum == 142) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 146) then
								if (Enum <= 144) then
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
								elseif (Enum > 145) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
									Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 147) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 148) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 155) then
							if (Enum <= 152) then
								if (Enum <= 150) then
									local B;
									local A;
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								elseif (Enum > 151) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 153) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum == 154) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 158) then
							if (Enum <= 156) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							elseif (Enum > 157) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								do
									return Stk[Inst[2]]();
								end
							end
						elseif (Enum <= 159) then
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
						elseif (Enum == 160) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 173) then
						if (Enum <= 167) then
							if (Enum <= 164) then
								if (Enum <= 162) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 163) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Inst[2] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 165) then
								VIP = Inst[3];
							elseif (Enum == 166) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 170) then
							if (Enum <= 168) then
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 169) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 171) then
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
						elseif (Enum > 172) then
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
					elseif (Enum <= 179) then
						if (Enum <= 176) then
							if (Enum <= 174) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 175) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 177) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum == 178) then
							local A = Inst[2];
							local B = Inst[3];
							for Idx = A, B do
								Stk[Idx] = Vararg[Idx - A];
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
					elseif (Enum <= 182) then
						if (Enum <= 180) then
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
						elseif (Enum == 181) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 183) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 184) then
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
				elseif (Enum <= 278) then
					if (Enum <= 231) then
						if (Enum <= 208) then
							if (Enum <= 196) then
								if (Enum <= 190) then
									if (Enum <= 187) then
										if (Enum == 186) then
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
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										end
									elseif (Enum <= 188) then
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 189) then
										local A;
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
								elseif (Enum <= 193) then
									if (Enum <= 191) then
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
										Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
									elseif (Enum > 192) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 194) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Enum > 195) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum <= 199) then
									if (Enum <= 197) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum == 198) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
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
								elseif (Enum <= 200) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 201) then
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 205) then
								if (Enum <= 203) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 204) then
									local A;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 206) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 207) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 219) then
							if (Enum <= 213) then
								if (Enum <= 210) then
									if (Enum == 209) then
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
									elseif (Stk[Inst[2]] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 211) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								elseif (Enum == 212) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 216) then
								if (Enum <= 214) then
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
								elseif (Enum == 215) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 217) then
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
							elseif (Enum > 218) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
							if (Enum <= 222) then
								if (Enum <= 220) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 221) then
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
							elseif (Enum <= 223) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum > 224) then
								if (Inst[2] < Inst[4]) then
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
						elseif (Enum <= 228) then
							if (Enum <= 226) then
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
									if (Mvm[1] == 353) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							elseif (Enum > 227) then
								local B;
								local A;
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 229) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 230) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 254) then
						if (Enum <= 242) then
							if (Enum <= 236) then
								if (Enum <= 233) then
									if (Enum > 232) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 234) then
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
								elseif (Enum > 235) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 239) then
								if (Enum <= 237) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
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
							elseif (Enum <= 240) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 241) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 248) then
							if (Enum <= 245) then
								if (Enum <= 243) then
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
								elseif (Enum > 244) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Env[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 246) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 247) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								B = Stk[Inst[4]];
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
						elseif (Enum <= 251) then
							if (Enum <= 249) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum == 250) then
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 252) then
							Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
						elseif (Enum > 253) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 266) then
						if (Enum <= 260) then
							if (Enum <= 257) then
								if (Enum <= 255) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 256) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 258) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							elseif (Enum == 259) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 263) then
							if (Enum <= 261) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 262) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 264) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A]());
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 265) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 269) then
							if (Enum <= 267) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 268) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 270) then
							if (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 271) then
							local Edx;
							local Results, Limit;
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						end
					elseif (Enum <= 275) then
						if (Enum <= 273) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 274) then
							if (Inst[2] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A;
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 276) then
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
					elseif (Enum > 277) then
						local A = Inst[2];
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
				elseif (Enum <= 324) then
					if (Enum <= 301) then
						if (Enum <= 289) then
							if (Enum <= 283) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
								elseif (Enum <= 281) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Enum == 282) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
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
							elseif (Enum > 288) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 295) then
							if (Enum <= 292) then
								if (Enum <= 290) then
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								elseif (Enum == 291) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 293) then
								local A;
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
							elseif (Enum == 294) then
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
						elseif (Enum <= 298) then
							if (Enum <= 296) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 297) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 299) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 300) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
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
					elseif (Enum <= 312) then
						if (Enum <= 306) then
							if (Enum <= 303) then
								if (Enum > 302) then
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
							elseif (Enum <= 304) then
								local A;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 305) then
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
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 309) then
							if (Enum <= 307) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 308) then
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
						elseif (Enum <= 310) then
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
						elseif (Enum == 311) then
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
					elseif (Enum <= 318) then
						if (Enum <= 315) then
							if (Enum <= 313) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 314) then
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
						elseif (Enum <= 316) then
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						elseif (Enum > 317) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 321) then
						if (Enum <= 319) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 320) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 322) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 323) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 347) then
					if (Enum <= 335) then
						if (Enum <= 329) then
							if (Enum <= 326) then
								if (Enum == 325) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								end
							elseif (Enum <= 327) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
							elseif (Enum > 328) then
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
								do
									return;
								end
							end
						elseif (Enum <= 332) then
							if (Enum <= 330) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 331) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 333) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 334) then
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
						elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
					elseif (Enum <= 341) then
						if (Enum <= 338) then
							if (Enum <= 336) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Enum > 337) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 339) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
						elseif (Enum > 340) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 344) then
						if (Enum <= 342) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 343) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 345) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 359) then
					if (Enum <= 353) then
						if (Enum <= 350) then
							if (Enum <= 348) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 349) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							end
						elseif (Enum <= 351) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum == 352) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]];
						end
					elseif (Enum <= 356) then
						if (Enum <= 354) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 355) then
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
					elseif (Enum <= 357) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 358) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 365) then
					if (Enum <= 362) then
						if (Enum <= 360) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum == 361) then
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
					elseif (Enum <= 363) then
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
					elseif (Enum > 364) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 368) then
					if (Enum <= 366) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
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
						Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
					end
				elseif (Enum <= 369) then
					Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
				elseif (Enum > 370) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503123O00F4D3D23DD996C619D4FCFD2CF4BE8912C4C203083O007EB1A3BB4586DBA703123O00D51C7B6E7AFEF10B774963DAE2093C7A50D203063O00B3906C121625002E3O0012D13O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004A53O000A000100124E010300063O00209C00040003000700124E010500083O00209C00050005000900124E010600083O00209C00060006000A0006E200073O000100062O0061012O00064O0061017O0061012O00044O0061012O00014O0061012O00024O0061012O00053O00209C00080003000B00209C00090003000C2O0046000A5O00124E010B000D3O0006E2000C0001000100022O0061012O000A4O0061012O000B4O0061010D00073O001250000E000E3O001250000F000F4O0050010D000F00020006E2000E0002000100032O0061012O00074O0061012O00094O0061012O00084O0067000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O009400025O00122O000300016O00045O00122O000500013O00042O0003002100012O005301076O009F000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0053010C00034O00AB000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00FA000C6O0076000A3O0002002007000A000A00022O004A0109000A4O001601073O00010004370103000500012O0053010300054O0061010400024O0048000300044O002701036O0048012O00017O00113O00028O00025O004C9540025O002BB040026O00F03F025O006EA740025O00FAA040025O00A88F40025O0030A740025O00C05140025O00DAB040025O00408040025O00CAAA40025O0010AB40025O00049A40025O0060AF40025O0042A240025O00707A4001423O001250000200014O008D000300043O002EA200020009000100030004A53O000900010026D800020009000100010004A53O00090001001250000300014O008D000400043O001250000200043O002EA300050004000100050004A53O000D000100265B0002000F000100040004A53O000F0001002EA200060002000100070004A53O00020001001250000500014O008D000600063O00265B00050017000100010004A53O00170001002E6901080017000100090004A53O00170001002E80000A00110001000B0004A53O00110001001250000600013O000E512O010018000100060004A53O00180001002EA2000C00320001000D0004A53O003200010026D800030032000100010004A53O00320001001250000700013O0026D80007002B000100010004A53O002B00012O005301086O00DF000400083O00066A0004002A000100010004A53O002A00012O0053010800014O006101096O0061000A6O00D700086O002701085O001250000700043O002E80000E001F0001000F0004A53O001F0001000E510104001F000100070004A53O001F0001001250000300043O0004A53O003200010004A53O001F000100265B00030036000100040004A53O00360001002E800010000F000100110004A53O000F00012O0061010700044O006100086O00D700076O002701075O0004A53O000F00010004A53O001800010004A53O000F00010004A53O001100010004A53O000F00010004A53O004100010004A53O000200012O0048012O00017O007B3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C2018852O033O00CC52B303043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A030A3O0034AADDCB841F241CB3DD03073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006A43133103043O004529226003053O008CD1D2191103063O004BDCA3B76A62030B3O0032A88E24CA21AF9924D61003053O00B962DAEB5703053O00E63D24F4D103063O00CAAB5C4786BE03043O000BC8228C03043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903043O006D6174682O033O00C52F3803073O009CA84E40E0D47903043O0004EBACC203043O00AE678EC503043O007B29583D03073O009836483F58453E03043O00F2CDFC5903043O003CB4A48E03043O00755F022C03073O0072383E6549478D03043O009EE0C9C103043O00A4D889BB03043O00FFE736B703073O006BB28651D2C69E03043O001E0790C303053O00CA586EE2A603073O00E0008FFAC5CD1C03053O00AAA36FE29703083O003426B72A5738271403073O00497150D2582E5703103O005265676973746572466F724576656E7403243O0004A78B6532AD2E2009A5866936B7222000A7966D28A12B3111AD90623BAB39310BA39A6803083O007045E4DF2C64E87103103O00E70A09F8BF7281C73D0BD6A56F8FDA1803073O00E6B47F67B3D61C030B3O004973417661696C61626C65030A3O00AA095E4BE171E198065703073O0080EC653F268421026O001040025O00388F40030B3O008ABC1448A2E3CA8AA0034103073O00AFCCC97124D68B026O000840030B3O0061D930D0104FC913D5164203053O006427AC55BC026O004440026O33D33F028O00026O001840026O00344003083O008671B7843FA476BE03053O0053CD18D9E0029A5O99D93F026O00F03F026O002040024O0080B3C54003183O00D6E9EC04C3F7F218D7F0E40DCBE0E309D9E6E51CC8E2E81903043O005D86A5AD03143O0091FC017E93FC04738EE9056091E6096282ED016E03043O002CDDB94003093O0031FE5A50710DE65B4B03053O00136187283F03103O005265676973746572496E466C6967687403083O008855213E2D30A25003063O0051CE3C535B4F03063O0063AEC47720D103083O00C42ECBB0124FA32D03163O005265676973746572496E466C69676874452O66656374024O00906E154103063O0095276A1B2BE903073O008FD8421E7E449B030D3O009AC002CECBAACFC7A6C900CED603083O0081CAA86DABA5C3B7024O0030700F41030D3O00125038DDD01DFE045436D5DB0703073O0086423857B8BE7403093O000C281BB41BE720262803083O00555C5169DB798B41030E3O00436F6D62757374696F6E42752O6603083O00DBBA42407EDEF1BF03063O00BF9DD330251C03143O00EF33D5251FED20C6391DFA31CB3914FE3DD8391E03053O005ABF7F947C030E3O00681E917A616811977E6C7509917203053O002D3B4ED43603143O003C73A2B9A80B89CF2366A6A7AA1184DE2F62A2A903083O00907036E3EBE64ECD03063O0053657441504C025O00804F40000B033O00312O0100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O001275000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O0012750009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O001275000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O001250000D00123O001250000E00134O0050010C000E00022O007F000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100174O00D6000F001100024O000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B4O00D60011001300024O0011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F4O00D60013001500024O0013000E00134O00145O00122O001500203O00122O001600216O0014001600024O0014000E00144O00155O00122O001600223O00122O001700234O00D60015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0014001400154O00155O00122O001600263O00122O001700274O00D60015001700024O0015000E00154O00165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00122O0017002A3O00122O0018002B4O00500116001800022O00DF00150015001600124E0116002C4O00CE00175O00122O0018002D3O00122O0019002E6O0017001900024O00160016001700122O0017002C6O00185O00122O0019002F3O00122O001A00306O0018001A00022O00DF0017001700182O008D001800184O001D01196O001D011A6O001D011B6O0063001C8O001D00506O00515O00122O005200313O00122O005300326O0051005300024O0051000B00514O00525O00122O005300333O00122O005400344O00D60052005400024O0051005100524O00525O00122O005300353O00122O005400366O0052005400024O0052000D00524O00535O00122O005400373O00122O005500384O00D60053005500024O0052005200534O00535O00122O005400393O00122O0055003A6O0053005500024O0053001200534O00545O00122O0055003B3O00122O0056003C4O00500154005600022O00DF0053005300542O004600546O002F00555O00122O0056003D3O00122O0057003E6O0055005700024O0055000E00554O00565O00122O0057003F3O00122O005800406O0056005800024O0055005500560006E200563O000100032O0061012O00514O0053017O0061012O00553O0020530057000400410006E200590001000100012O0061012O00564O002D015A5O00122O005B00423O00122O005C00436O005A005C6O00573O00014O0057001B6O00585O00122O005900443O00122O005A00456O0058005A00022O00DF0058005100580020530058005800462O005F0158000200022O001F01595O00122O005A00473O00122O005B00486O0059005B00024O00590051005900202O0059005900464O00590002000200062O005900C400013O0004A53O00C40001001250005900493O00066A005900C5000100010004A53O00C500010012500059004A3O001250005A004A4O000F015B00596O005C00016O005D00146O005E5O00122O005F004B3O00122O0060004C6O005E006000024O005E0051005E00202O005E005E00464O005E005F4O0019015D3O000200102O005D004D005D4O005E00146O005F5O00122O0060004E3O00122O0061004F6O005F006100024O005F0051005F00202O005F005F00464O005F000200022O0040005F005F4O005F015E000200020010E4005E004A005E4O005C005E00024O005D00026O005E00146O005F5O00122O0060004B3O00122O0061004C6O005F006100024O005F0051005F00202O005F005F00462O004A015F00604O0019015E3O000200102O005E004D005E4O005F00146O00605O00122O0061004E3O00122O0062004F6O0060006200024O00600051006000202O0060006000464O0060000200022O0040006000604O0027005F0002000200102O005F004A005F4O005D005F00024O005C005C005D00122O005D004A3O00122O005E00503O00122O005F004A3O00122O006000513O00122O006100523O00122O006200534O001D01635O00065E006300022O013O0004A53O00022O01001250006400543O00066A006400032O0100010004A53O00032O01001250006400524O008D006500654O001F01665O00122O006700553O00122O006800566O0066006800024O00660051006600202O0066006600464O00660002000200062O006600102O013O0004A53O00102O01001250006600573O00066A006600112O0100010004A53O00112O01001250006600584O001D01676O003D01688O00695O00122O006A00523O00122O006B00523O00122O006C00593O00122O006D004D6O006E00703O00122O0071004D3O00122O0072005A3O00122O0073005A4O008D0074007B3O002053007C000400410006E2007E0002000100022O0061012O00634O0061012O00644O0014017F5O00122O0080005B3O00122O0081005C6O007F00816O007C3O000100202O007C000400410006E2007E0003000100022O0061012O00514O0053017O000B007F5O00122O0080005D3O00122O0081005E6O007F00816O007C3O00014O007C5O00122O007D005F3O00122O007E00606O007C007E00024O007C0051007C002053007C007C00612O0003007C000200014O007C5O00122O007D00623O00122O007E00636O007C007E00024O007C0051007C00202O007C007C00614O007C000200014O007C5O00122O007D00643O001250007E00654O0019007C007E00024O007C0051007C00202O007C007C006600122O007E00676O007C007E00014O007C5O00122O007D00683O00122O007E00696O007C007E00024O007C0051007C002053007C007C00612O00D5007C000200014O007C5O00122O007D006A3O00122O007E006B6O007C007E00024O007C0051007C00202O007C007C006600122O007E006C6O007C007E00014O007C5O001250007D006D3O00125D017E006E6O007C007E00024O007C0051007C00202O007C007C00614O007C000200014O007C5O00122O007D006F3O00122O007E00706O007C007E00024O007C0051007C002053007C007C006100200A007E005100714O007C007E00014O007C5O00122O007D00723O00122O007E00736O007C007E00024O007C0051007C00202O007C007C006100202O007E005100714O007C007E0001002053007C000400410006E2007E0004000100022O0061012O00724O0061012O00734O0014017F5O00122O008000743O00122O008100756O007F00816O007C3O000100202O007C000400410006E2007E0005000100062O0061012O005B4O0061012O00594O0061012O00664O0061012O00514O0053017O0061012O00584O00E3007F5O00122O008000763O00122O008100776O007F008100024O00805O00122O008100783O00122O008200796O008000826O007C3O00010006E2007C0006000100032O0061012O00514O0053017O0061012O00093O0006E2007D0007000100032O0061012O00514O0053017O0061012O00093O0006E2007E0008000100032O0061012O00514O0053017O0061012O00093O0006E2007F0009000100032O0061012O00514O0053017O0061012O00093O0006E20080000A000100032O0061012O00714O0061012O00514O0053016O0006E20081000B000100082O0061012O007C4O0061012O00144O0061012O00514O0053017O0053012O00014O0061012O00084O0053012O00024O0061012O007F3O0006E20082000C000100012O0061012O00513O0006E20083000D000100042O0061012O00514O0053017O0053012O00014O0053012O00023O0006E20084000E000100042O0061012O00184O0061012O00554O0061012O00544O0061012O001B3O0006E20085000F000100062O0061012O00514O0053017O0061012O001C4O0061012O00554O0061012O00104O0061012O00533O0006E2008600100001001A2O0061012O00444O0061012O00084O0061012O00464O0061012O00484O0053017O0061012O00524O0061012O00104O0061012O00534O0061012O00514O0061012O00334O0061012O003A4O0061012O00304O0061012O00374O0061012O002E4O0061012O00354O0061012O00454O0061012O00474O0061012O00314O0061012O00384O0061012O00324O0061012O00394O0061012O002F4O0061012O00364O0061012O00344O0061012O00554O0061012O003B3O0006E2008700110001000B2O0061012O00514O0053017O0061012O001E4O0061012O00084O0061012O00554O0061012O00104O0061012O00334O0061012O004D4O0061012O00264O0061012O00094O0061012O00213O0006E200880012000100112O0061012O00514O0053017O0061012O001F4O0061012O006F4O0061012O00084O0061012O00044O0061012O007F4O0061012O007D4O0061012O00104O0061012O00234O0061012O00764O0061012O00654O0061012O00094O0061012O00244O0061012O00434O0061012O00734O0061012O00533O0006E200890013000100102O0061012O00494O0061012O004C4O0061012O001B4O0061012O00434O0061012O00734O0061012O00514O0053017O0061012O00104O0061012O006E4O0061012O004F4O0061012O00084O0061012O004A4O0061012O004B4O0061012O00184O0061012O00844O0061012O00553O0006E2008A00140001002D2O0061012O001A4O0061012O00514O0053017O0061012O00224O0061012O00084O0061012O006F4O0061012O00754O0061012O005C4O0061012O00104O0061012O00534O0061012O00094O0061012O00264O0061012O00214O0061012O007F4O0061012O00274O0061012O00254O0061012O00744O0061012O00184O0061012O00884O0061012O002A4O0061012O002C4O0061012O001B4O0061012O00434O0061012O00734O0061012O00834O0061012O00654O0061012O00604O0061012O005B4O0061012O006E4O0061012O002B4O0061012O002D4O0061012O005F4O0061012O00234O0061012O00764O0061012O00774O0053012O00014O0061012O00144O0053012O00024O0061012O00204O0061012O00814O0061012O00694O0061012O00494O0061012O004C4O0061012O00624O0061012O00893O0006E2008B0015000100142O0061012O00514O0053017O0061012O007C4O0061012O00084O0061012O00654O0061012O00164O0061012O006C4O0061012O00744O0061012O006A4O0061012O00144O0061012O00734O0061012O00664O0061012O006B4O0053012O00014O0061012O00754O0061012O005B4O0053012O00024O0061012O00604O0061012O00584O0061012O007D3O0006E2008C00160001000D2O0061012O00514O0053017O0061012O00204O0061012O00814O0061012O00694O0061012O00084O0053012O00014O0061012O00144O0061012O00834O0053012O00024O0061012O00744O0061012O00104O0061012O00093O0006E2008D0017000100222O0061012O00514O0053017O0061012O00254O0061012O00084O0061012O00684O0061012O00104O0061012O00094O0061012O00744O0061012O00274O0061012O007F4O0061012O006D4O0061012O001A4O0061012O001F4O0061012O00774O0061012O007E4O0061012O001D4O0061012O00784O0061012O005D4O0061012O005E4O0061012O00224O0061012O00754O0061012O00594O0061012O00814O0061012O00534O0061012O00264O0061012O005C4O0061012O00834O0061012O00184O0061012O00884O0061012O00204O0061012O007C4O0061012O00694O0061012O005A4O0061012O00213O0006E2008E00180001002B2O0061012O00514O0053017O0061012O00204O0061012O00814O0061012O00084O0061012O00714O0061012O00104O0061012O00094O0061012O00654O0061012O006F4O0061012O00184O0061012O008D4O0061012O007E4O0061012O00274O0061012O00574O0061012O008B4O0061012O001B4O0061012O004F4O0061012O007C4O0061012O00734O0061012O00434O0061012O004A4O0061012O004B4O0061012O00844O0061012O00674O0061012O00694O0061012O00744O0061012O002D4O0061012O002B4O0061012O007F4O0053012O00014O0061012O00804O0061012O00144O0053012O00024O0061012O00614O0061012O006E4O0061012O006B4O0061012O008A4O0061012O00754O0061012O005A4O0061012O008C4O0061012O005B4O0061012O00683O0006E2008F0019000100242O0061012O00344O0053017O0061012O00334O0061012O00314O0061012O00324O0061012O00254O0061012O00264O0061012O00274O0061012O00284O0061012O00214O0061012O00224O0061012O00234O0061012O00244O0061012O00394O0061012O003A4O0061012O003B4O0061012O004D4O0061012O002F4O0061012O00304O0061012O002D4O0061012O002E4O0061012O00294O0061012O002A4O0061012O002B4O0061012O002C4O0061012O00374O0061012O00384O0061012O00354O0061012O00364O0061012O004E4O0061012O004F4O0061012O00504O0061012O001F4O0061012O00204O0061012O001D4O0061012O001E3O0006E20090001A000100122O0061012O004B4O0053017O0061012O004C4O0061012O00454O0061012O00444O0061012O00414O0061012O00424O0061012O00434O0061012O00404O0061012O004A4O0061012O00494O0061012O003D4O0061012O003C4O0061012O003F4O0061012O00484O0061012O003E4O0061012O00474O0061012O00463O0006E20091001B000100292O0061012O00194O0053017O0061012O001A4O0061012O008F4O0061012O00904O0061012O00084O0061012O00184O0061012O00874O0061012O00554O0061012O00514O0061012O00104O0061012O00534O0061012O00094O0061012O008E4O0061012O003E4O0061012O00504O0061012O003D4O0061012O00854O0061012O00864O0061012O003F4O0061012O004E4O0061012O001C4O0061012O003C4O0061012O007A4O0061012O00794O0061012O00754O0061012O00164O0061012O00764O0061012O00774O0061012O00784O0061012O007B4O0061012O00824O0061012O00574O0061012O001B4O0061012O00724O0061012O00044O0061012O006E4O0061012O006F4O0061012O00654O0061012O00744O0061012O00733O0006E20092001C000100032O0061012O00564O0061012O000E4O0053016O0020340193000E007A00122O0094007B6O009500916O009600926O0093009600016O00013O001D3O00073O00030B3O00B329C01DF1840FD800F48403053O0087E14CAD72030B3O004973417661696C61626C6503123O003EE4ABA0A9B1AB1BEFB4B588B8A50FEBBEA303073O00C77A8DD8D0CCDD03173O0089D403E07DFAA1DC12FC7DD5B8CF03F55CF3AFC816F66B03063O0096CDBD70901800174O004B019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001600013O0004A53O001600012O0053012O00024O00152O0100013O00122O000200043O00122O000300056O0001000300024O000200026O000300013O00122O000400063O00122O000500076O0003000500024O0002000200032O0002012O000100022O0048012O00019O003O00034O0053017O005D3O000100012O0048012O00017O00023O00028O00026O00344000163O0012503O00014O008D000100013O000E512O01000200013O0004A53O00020001001250000100013O0026D800010005000100010004A53O000500012O001D01026O00DB00026O005301025O00065E0002000F00013O0004A53O000F0001001250000200023O00066A00020010000100010004A53O00100001001250000200014O00DB000200013O0004A53O001500010004A53O000500010004A53O001500010004A53O000200012O0048012O00017O003D3O00028O00025O00A7B240025O00588640025O00089140025O0044A940025O0068AC40025O006C9C40026O00F03F025O00B4A040025O00349140025O00B2A24003063O00752567F9555203063O00203840139C3A03163O005265676973746572496E466C69676874452O66656374024O00906E154103063O0077CDF15355E003073O00E03AA885363A9203103O005265676973746572496E466C69676874025O000C9540027O0040025O003EAD40025O0038A240025O0026A140025O00A2A340025O0028A940025O007CB240025O00A6A740025O00BAB040025O0082B140025O0062B340025O0006AA40025O00509D4003093O008EEBD3CD38C2B36DAA03083O001EDE92A1A25AAED203083O00C347620FE74F7C0603043O006A852E10025O00BCA740025O00D4A940025O0016AB40025O00FCA240025O00708040025O00F07F40026O000840025O00C09440025O0018824003093O000CB69343E175792FBB03073O00185CCFE12C8319030E3O00436F6D62757374696F6E42752O6603083O006DDAAA49197C47DF03063O001D2BB3D82C7B025O00406E40025O00249C40025O003CA540025O0088B240025O00A4A040025O00309D40030D3O00695E44F87B8F9F2D555746F86603083O006B39362B9D15E6E7024O0030700F41030D3O00EB831EF0B7D5D7FD8710F8BCCF03073O00AFBBEB7195D9BC00A73O0012503O00014O008D000100013O00265B3O0008000100010004A53O00080001002E6901020008000100030004A53O00080001002EA200050002000100040004A53O00020001001250000100013O002E8000070033000100060004A53O003300010026D800010033000100080004A53O00330001001250000200014O008D000300033O002EA300093O000100090004A53O000F000100265B00020015000100010004A53O00150001002E80000B000F0001000A0004A53O000F0001001250000300013O0026D80003002A000100010004A53O002A00012O005301046O00CF000500013O00122O0006000C3O00122O0007000D6O0005000700024O00040004000500202O00040004000E00122O0006000F6O0004000600014O00048O000500013O00122O000600103O00122O000700116O0005000700024O00040004000500202O0004000400124O00040002000100122O000300083O002EA3001300ECFF2O00130004A53O001600010026D800030016000100080004A53O00160001001250000100143O0004A53O003300010004A53O001600010004A53O003300010004A53O000F0001002EA200160037000100150004A53O0037000100265B00010039000100010004A53O00390001002EA200180066000100170004A53O00660001001250000200013O002E80001900400001001A0004A53O00400001000E5101080040000100020004A53O00400001001250000100083O0004A53O00660001002EA2001B003A0001001C0004A53O003A000100265B00020046000100010004A53O00460001002E80001E003A0001001D0004A53O003A0001001250000300013O00265B0003004B000100010004A53O004B0001002E80001F005C000100200004A53O005C00012O005301046O0010000500013O00122O000600213O00122O000700226O0005000700024O00040004000500202O0004000400124O0004000200014O00048O000500013O00122O000600233O001250000700244O00910005000700024O00040004000500202O0004000400124O00040002000100122O000300083O002EA200250047000100260004A53O00470001002E8000280047000100270004A53O004700010026D800030047000100080004A53O00470001001250000200083O0004A53O003A00010004A53O004700010004A53O003A0001002EA2002A006A000100290004A53O006A0001000E7D002B006C000100010004A53O006C0001002EA2002C00810001002D0004A53O008100012O005301026O0040010300013O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O0002000200124O00045O00202O0004000400304O0002000400014O00028O000300013O00122O000400313O00122O000500326O0003000500024O00020002000300202O0002000200124O00045O00202O0004000400304O00020004000100044O00A6000100265B00010085000100140004A53O00850001002EA200340009000100330004A53O00090001001250000200013O002E800035009E000100360004A53O009E000100265B0002008C000100010004A53O008C0001002EA300370014000100380004A53O009E00012O005301036O00CF000400013O00122O000500393O00122O0006003A6O0004000600024O00030003000400202O00030003000E00122O0005003B6O0003000500014O00038O000400013O00122O0005003C3O00122O0006003D6O0004000600024O00030003000400202O0003000300124O00030002000100122O000200083O0026D800020086000100080004A53O008600010012500001002B3O0004A53O000900010004A53O008600010004A53O000900010004A53O00A600010004A53O000200012O0048012O00017O00063O00028O00025O00088240025O005EA340025O0046A040025O0036AE40024O0080B3C54000143O0012503O00014O008D000100013O002E8000020002000100030004A53O0002000100265B3O0008000100010004A53O00080001002EA200050002000100040004A53O00020001001250000100013O0026D800010009000100010004A53O00090001001250000200064O00DB00025O001250000200064O00DB000200013O0004A53O001300010004A53O000900010004A53O001300010004A53O000200012O0048012O00017O00163O00028O00026O00F03F025O0024A840025O0028AC40025O00689F40025O0082AD4003083O00111FFAB1361FFAB203043O00D55A7694030B3O004973417661696C61626C650200A04O99D93F03103O004B92203C718929045A8B2B046B8E201003043O007718E74E030A3O00A421A447D97010962EAD03073O0071E24DC52ABC20026O000840025O00388F40025O0068A440025O00488A40025O0054AA40025O0039B040025O000CA140025O00E0994000583O0012503O00014O008D000100013O000E512O01000200013O0004A53O00020001001250000100013O000E7D0002000B000100010004A53O000B0001002E120104000B000100030004A53O000B0001002E800006001D000100050004A53O001D00012O0053010200014O00DB00026O004B010200036O000300043O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002001A00013O0004A53O001A00010012500002000A3O00066A0002001B000100010004A53O001B0001001250000200024O00DB000200023O0004A53O005700010026D800010005000100010004A53O00050001001250000200014O008D000300033O0026D800020021000100010004A53O00210001001250000300013O000E512O010049000100030004A53O00490001001250000400013O0026D800040042000100010004A53O004200012O0053010500034O00A6000600043O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O0005000500094O0005000200024O000500056O000500036O000600043O00122O0007000D3O00122O0008000E6O0006000800024O00050005000600202O0005000500094O00050002000200062O0005003F00013O0004A53O003F00010012500005000F3O00066A00050040000100010004A53O00400001001250000500104O00DB000500013O001250000400023O002EA200120027000100110004A53O002700010026D800040027000100020004A53O00270001001250000300023O0004A53O004900010004A53O00270001002EA20013004D000100140004A53O004D000100265B0003004F000100020004A53O004F0001002EA200150024000100160004A53O00240001001250000100023O0004A53O000500010004A53O002400010004A53O000500010004A53O002100010004A53O000500010004A53O005700010004A53O000200012O0048012O00017O00053O00030B3O0095211DF9C34FB23A1BF9C203063O003BD3486F9CB0030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765025O0080564000134O004B019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001100013O0004A53O001100012O0053012O00023O0020535O00042O005F012O00020002000EA70005001000013O0004A53O001000012O00868O001D012O00014O00093O00024O0048012O00017O00073O00030B3O00688EF1285D93E23F5A82F103043O004D2EE783030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765025O0080564003073O0054696D65546F58029O001B4O004B019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001800013O0004A53O001800012O0053012O00023O0020535O00042O005F012O00020002000E970005001500013O0004A53O001500012O0053012O00023O0020535O0006001250000200054O0050012O0002000200066A3O0019000100010004A53O001900010012503O00073O00066A3O0019000100010004A53O001900010012503O00074O00093O00024O0048012O00017O00053O00030C3O008951B752B35AB174B541B54803043O0020DA34D6030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765026O003E4000134O004B019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001100013O0004A53O001100012O0053012O00023O0020535O00042O005F012O0002000200260D012O0010000100050004A53O001000012O00868O001D012O00014O00093O00024O0048012O00017O00053O00030E3O00671A21BAFEA6405E7D143EBAF2B803083O003A2E7751C891D025030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765026O003E4000134O004B019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001100013O0004A53O001100012O0053012O00023O0020535O00042O005F012O0002000200260D012O0010000100050004A53O001000012O00868O001D012O00014O00093O00024O0048012O00017O00063O00030D3O00188439AABDB4382CBC3FBBACAF03073O00564BEC50CCC9DD030C3O00426173654475726174696F6E030D3O0041497E83EA827C46478AE98E6003063O00EB122117E59E030C3O00426173655469636B54696D6500154O0018019O000100016O000200023O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O0001000200028O00014O000100016O000200023O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O0001000200028O00016O00028O00017O00223O00028O00025O0024B040026O00F03F025O00588540025O00B0A040025O001CB240025O0072A440025O00C05640025O0078A540025O003C9C40025O00F49A40025O007FB240026O00384003093O0060A3D3B452B6C0A84403043O00DB30DAA103083O00496E466C6967687403083O00C2786E4CD94EECE803073O008084111C29BB2F030D3O00313A093F53082A20365C0C371503053O003D6152665A03083O005072657647434450030D3O0050686F656E6978466C616D6573025O00C88340025O0054A440025O00907740025O0031B24003063O0042752O665570030D3O00486F7453747265616B42752O6603103O004879706572746865726D696142752O66030D3O0048656174696E67557042752O6603093O00497343617374696E6703063O0053636F72636803083O004669726562612O6C03093O005079726F626C61737400B53O0012503O00014O008D000100023O002EA300020007000100020004A53O000900010026D83O0009000100010004A53O00090001001250000100014O008D000200023O0012503O00033O00265B3O000D000100030004A53O000D0001002EA3000400F7FF2O00050004A53O00020001001250000300013O000E512O01000E000100030004A53O000E000100265B00010014000100010004A53O00140001002E8000060074000100070004A53O00740001001250000400013O00265B00040019000100010004A53O00190001002E800009006F000100080004A53O006F0001001250000500013O002E80000B001E0001000A0004A53O001E000100265B00050020000100010004A53O00200001002EA3000C004A0001000D0004A53O006800012O005301066O000C01060001000200065E0006003B00013O0004A53O003B00012O0053010600014O00F9000700026O000800033O00122O0009000E3O00122O000A000F6O0008000A00024O00070007000800202O0007000700104O000700086O00063O00024O000700014O0053010800024O00F7000900033O00122O000A00113O00122O000B00126O0009000B00024O00080008000900202O0008000800104O000800096O00073O00024O00060006000700062O0002003C000100060004A53O003C0001001250000200014O0053010600044O0061010700024O0053010800014O0053010900024O00DC000A00033O00122O000B00133O00122O000C00146O000A000C00024O00090009000A00202O0009000900104O00090002000200062O0009004F000100010004A53O004F00012O0053010900053O0020EA00090009001500122O000B00036O000C00023O00202O000C000C00164O0009000C00022O004A010800094O00F100063O00024O000700066O000800026O000900016O000A00024O00DC000B00033O00122O000C00133O00122O000D00146O000B000D00024O000A000A000B00202O000A000A00104O000A0002000200062O000A0064000100010004A53O006400012O0053010A00053O0020EA000A000A001500122O000C00036O000D00023O00202O000D000D00164O000A000D00022O004A0109000A4O007600073O00022O0039000200060007001250000500033O00265B0005006C000100030004A53O006C0001002E800018001A000100170004A53O001A0001001250000400033O0004A53O006F00010004A53O001A00010026D800040015000100030004A53O00150001001250000100033O0004A53O007400010004A53O0015000100265B00010078000100030004A53O00780001002E80001A000D000100190004A53O000D00012O0053010400053O00201701040004001B4O000600023O00202O00060006001C4O00040006000200062O000400AE000100010004A53O00AE00012O0053010400053O00201701040004001B4O000600023O00202O00060006001D4O00040006000200062O000400AE000100010004A53O00AE00012O0053010400053O00206F01040004001B4O000600023O00202O00060006001E4O00040006000200062O000400AE00013O0004A53O00AE00012O0053010400074O000C01040001000200065E0004009800013O0004A53O009800012O0053010400053O00201701040004001F4O000600023O00202O0006000600204O00040006000200062O000400AE000100010004A53O00AE00012O005301046O000C01040001000200065E000400AE00013O0004A53O00AE00012O0053010400053O00201701040004001F4O000600023O00202O0006000600214O00040006000200062O000400AE000100010004A53O00AE00012O0053010400053O00201701040004001F4O000600023O00202O0006000600224O00040006000200062O000400AE000100010004A53O00AE0001000EA7000100AD000100020004A53O00AD00012O008600046O001D010400014O0009000400023O0004A53O000D00010004A53O000E00010004A53O000D00010004A53O00B400010004A53O000200012O0048012O00017O00133O00028O00025O00F88440025O00A8A340026O00F03F025O00F88340025O0004B340025O00809040025O00709540025O00C88740025O0069B340025O008AA440025O0080AD40025O00DCA94003053O007061697273025O002EAF4003083O00446562752O665570030C3O0049676E697465446562752O66025O00A4AB40025O00D2A940013F3O001250000100014O008D000200033O002EA200020038000100030004A53O003800010026D800010038000100040004A53O00380001001250000400013O002EA300053O000100050004A53O00070001002EA200070007000100060004A53O00070001000E512O010007000100040004A53O000700010026D80002002F000100010004A53O002F0001001250000500013O000E7D00040016000100050004A53O00160001002EE100080016000100090004A53O00160001002EA2000A00180001000B0004A53O00180001001250000200043O0004A53O002F000100265B0005001C000100010004A53O001C0001002EA2000C00100001000D0004A53O00100001001250000300013O00124E0106000E4O006101076O00A80006000200080004A53O002B0001002EA3000F000A0001000F0004A53O002B0001002053000B000A00102O0053010D5O00209C000D000D00112O0050010B000D000200065E000B002B00013O0004A53O002B000100203C010B0003000400203C0103000B000100068F00060021000100020004A53O00210001001250000500043O0004A53O00100001002E8000130006000100120004A53O000600010026D800020006000100040004A53O000600012O0009000300023O0004A53O000600010004A53O000700010004A53O000600010004A53O003E00010026D800010002000100010004A53O00020001001250000200014O008D000300033O001250000100043O0004A53O000200012O0048012O00017O001C3O00028O00026O00F03F025O00C08040025O00BEB040025O008AAB40026O007040025O00349240025O000C9140025O008CAD40025O00DEA540025O002CA640025O0060A540025O0086AC40025O00989540025O00288540025O00588240025O0096AB4003083O008A27B94EC556120503083O0069CC4ECB2BA7377E03083O00496E466C69676874030D3O0095A22C1B1D0DDF77A9AB2E1B0003083O0031C5CA437E7364A7025O00F88040025O00F0B240026O006540025O00BCA340025O00F07540025O0004A84000683O0012503O00014O008D000100033O00265B3O0006000100020004A53O00060001002E800004005F000100030004A53O005F00012O008D000300033O002EA200060010000100050004A53O0010000100265B0001000D000100010004A53O000D0001002EA200070010000100080004A53O00100001001250000200014O008D000300033O001250000100023O0026D800010007000100020004A53O00070001001250000400013O002EA300093O000100090004A53O001300010026D800040013000100010004A53O001300010026D80002001A000100020004A53O001A00012O0009000300023O002EA3000A00F8FF2O000A0004A53O00120001000E7D00010020000100020004A53O00200001002EA2000B00120001000C0004A53O00120001001250000500013O002EA3000D00310001000D0004A53O005200010026D800050052000100010004A53O00520001001250000600013O002EA2000F002C0001000E0004A53O002C00010026D80006002C000100020004A53O002C0001001250000500023O0004A53O0052000100265B00060030000100010004A53O00300001002EA200110026000100100004A53O00260001001250000300014O005301076O00DC000800013O00122O000900123O00122O000A00136O0008000A00024O00070007000800202O0007000700144O00070002000200062O00070047000100010004A53O004700012O005301076O00DC000800013O00122O000900153O00122O000A00166O0008000A00024O00070007000800202O0007000700144O00070002000200062O00070047000100010004A53O00470001002EA30017000B000100180004A53O005000012O0053010700024O0010010800033O00122O000900026O0007000900024O000800036O000900033O00122O000A00026O0008000A00024O000300070008001250000600023O0004A53O00260001002EA2001900210001001A0004A53O002100010026D800050021000100020004A53O00210001001250000200023O0004A53O001200010004A53O002100010004A53O001200010004A53O001300010004A53O001200010004A53O006700010004A53O000700010004A53O00670001002E80001B00020001001C0004A53O000200010026D83O0002000100010004A53O00020001001250000100014O008D000200023O0012503O00023O0004A53O000200012O0048012O00017O00093O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00388C40025O003EA540025O007EAB40025O00F0A94003103O0048616E646C65546F705472696E6B6574002D3O0012503O00014O008D000100013O0026D83O0002000100010004A53O00020001001250000100013O0026D800010019000100020004A53O001900012O0053010200013O00206E0002000200034O000300026O000400033O00122O000500046O000600066O0002000600024O00025O002E2O00050014000100060004A53O001400012O005301025O00066A00020016000100010004A53O00160001002E800007002C000100080004A53O002C00012O005301026O0009000200023O0004A53O002C0001000E512O010005000100010004A53O000500012O0053010200013O002O200002000200094O000300026O000400033O00122O000500046O000600066O0002000600024O00028O00025O00062O0002002800013O0004A53O002800012O005301026O0009000200023O001250000100023O0004A53O000500010004A53O002C00010004A53O000200012O0048012O00017O000A3O00025O00789840025O00BAA340030B3O00055ED22696537D2249CC2C03073O003E573BBF49E03603073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00344003103O0052656D6F76654375727365466F63757303133O00F507F7C6F107C5CAF210E9CCA706F3DAF707F603043O00A987629A00213O002EA200010020000100020004A53O002000012O0053017O001F2O0100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O002000013O0004A53O002000012O0053012O00023O00065E3O002000013O0004A53O002000012O0053012O00033O00209C5O0006001250000100074O005F012O0002000200065E3O002000013O0004A53O002000012O0053012O00044O00532O0100053O00209C0001000100082O005F012O0002000200065E3O002000013O0004A53O002000012O0053012O00013O001250000100093O0012500002000A4O00483O00024O0027017O0048012O00017O00863O00028O00026O00104003103O004865616C746850657263656E74616765025O0016A140025O00789340025O00C2A040025O0067B24003193O0003877AAE349174B53F853C94348370B53F853C8C3E9675B33F03043O00DC51E21C025O0030AE40025O00C07C4003173O0021D084E9EFD41BDC8CFC2OC212D98BF5EDF71CC18BF4E403063O00A773B5E29B8A03073O0049735265616479025O00F0B240025O00DDB040025O00F09940025O0014904003173O0052656672657368696E674865616C696E67506F74696F6E025O00C0AA40025O0040564003233O00F027E14E7E62CEEB2CE01C7374C7EE2BE95B3B61C9F62BE8523B75C3E427E94F7267C303073O00A68242873C1B11031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O00508940025O0095B140025O00088440025O00BBB24003193O006058CB743D534BC27E355659E670314843C072004B5EC77A3E03053O0050242AAE15025O00A4AB40025O00809240026O002A40025O00E06B4003253O004A02327B43073676451525690E18327B4219397D0E00386E471F393A4A15317F40033E6C4B03043O001A2E7057027O0040025O00C4AD40025O00A7B240026O00F03F025O001CA440025O0094A740026O000840025O0092AA40025O004EA140025O00FAA340030B3O00A8BB2119475CA088B3340E03073O00E9E5D2536B282E030A3O0049734361737461626C65030B3O004D692O726F72496D616765025O001CA240025O003C9E4003183O00CC4B20C40AD37D3BDB04C64772D200C7473CC50CD747728203053O0065A12252B603133O00CF1F5CFFCFE79007E61B50EDD2E08B22E1194003083O004E886D399EBB82E2025O00F2AA4003133O0047726561746572496E7669736962696C69747903203O00392DFCF02A3AEBCE3731EFF82D36FBF83236EDE87E3BFCF73B31EAF8283AB9A403043O00915E5F99025O00149540025O00409540025O00807340025O00A0724003093O00DCC100D05C83F4C01103063O00D79DAD74B52E03093O00416C74657254696D65025O00A06940025O004FB04003163O0034B89FF7C80AA082FFDF75B08EF4DF3BA782E4DF75E203053O00BA55D4EB92030B3O00EA8417F22DE64BD68E18FB03073O0038A2E1769E598E030B3O004865616C746873746F6E6503153O005400C1A336D04F11CFA127985800C6AA2CCB5513C503063O00B83C65A0CF42025O00588840025O00EEA240025O00BC9140025O005C9C40025O00F4994003083O00A5FE49101E43798703073O001AEC9D2C52722C03083O00496365426C6F636B025O0068B240026O00A740025O00E07240025O00F6A54003153O00232DD0642822DA58216ED15E2C2BDB482338D01B7903043O003B4A4EB5030D3O000CD25F79BC29D56E5BBF20DF4E03053O00D345B12O3A030B3O004973417661696C61626C65030E3O009EE67CD6E6C7B3C47BFCE5C2A3FC03063O00ABD785199589025O00EAB140025O001EA040025O00809D40025O00D88240030E3O00496365436F6C644162696C697479025O000AAC40025O005EA94003143O00E8CB37C5EC3FF046A1CC37FCEA3EEF4BF7CD72A903083O002281A8529A8F509C025O008C9B40025O006C9B40025O00A9B240025O0019B340025O0024AA40025O00309640025O00E4A240025O008EA140030E3O00E97B254EF43DCFE9763646F436DA03073O00A8AB1744349D5303083O0042752O66446F776E030E3O00426C617A696E6742612O72696572025O00C6AA40025O00CEA040025O00BEAA40025O00E6A740031B3O00F67DF4B72C2380CB73F4BF372482E631F1A8232889E778E3A8657C03073O00E7941195CD454D030B3O00ADA6D4E875FE92B5CEFE4503063O009FE0C7A79B37031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00EAAD40025O00E8A740025O0092A440025O00489140030B3O004D612O7342612O7269657203183O00FAF22FC1C8F13DC0E5FA39C0B7F739D4F2FD2FDBE1F67C8003043O00B297935C025O0030AF40025O00A0AA4000DB012O0012503O00014O008D000100013O0026D83O0002000100010004A53O00020001001250000100013O0026D800010066000100020004A53O006600012O005301025O00065E000200DA2O013O0004A53O00DA2O012O0053010200013O0020530002000200032O005F0102000200022O0053010300023O000679000200DA2O0100030004A53O00DA2O01001250000200014O008D000300033O00265B00020016000100010004A53O00160001002EA200040012000100050004A53O00120001001250000300013O000E7D0001001B000100030004A53O001B0001002EA200070017000100060004A53O001700012O0053010400034O000A010500043O00122O000600083O00122O000700096O00050007000200062O00040040000100050004A53O00400001002EA3000A00030001000B0004A53O002500010004A53O004000012O0053010400054O00DC000500043O00122O0006000C3O00122O0007000D6O0005000700024O00040004000500202O00040004000E4O00040002000200062O00040033000100010004A53O00330001002E12010F0033000100100004A53O00330001002EA200110040000100120004A53O004000012O0053010400064O0053010500073O00209C0005000500132O005F01040002000200066A0004003B000100010004A53O003B0001002EA200140040000100150004A53O004000012O0053010400043O001250000500163O001250000600174O0048000400064O002701046O0053010400033O00265B00040044000100180004A53O004400010004A53O00DA2O01002E80001900DA2O01001A0004A53O00DA2O01002EA2001B00DA2O01001C0004A53O00DA2O012O0053010400054O001F010500043O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400DA2O013O0004A53O00DA2O012O0053010400064O0053010500073O00209C0005000500132O005F01040002000200066A0004005C000100010004A53O005C0001002E12011F005C000100200004A53O005C0001002E80002200DA2O0100210004A53O00DA2O012O0053010400043O001205000500233O00122O000600246O000400066O00045O00044O00DA2O010004A53O001700010004A53O00DA2O010004A53O001200010004A53O00DA2O01000E7D0025006A000100010004A53O006A0001002EA2002700B9000100260004A53O00B90001001250000200013O00265B0002006F000100280004A53O006F0001002EA3002900040001002A0004A53O007100010012500001002B3O0004A53O00B9000100265B00020075000100010004A53O00750001002E80002C006B0001002D0004A53O006B0001002EA3002E00220001002E0004A53O009700012O0053010300084O001F010400043O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300314O00030002000200062O0003009700013O0004A53O009700012O0053010300093O00065E0003009700013O0004A53O009700012O0053010300013O0020530003000300032O005F0103000200022O00530104000A3O00067900030097000100040004A53O009700012O0053010300064O0053010400083O00209C0004000400322O005F01030002000200066A00030092000100010004A53O00920001002E8000330097000100340004A53O009700012O0053010300043O001250000400353O001250000500364O0048000300054O002701036O0053010300084O001F010400043O00122O000500373O00122O000600386O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300B700013O0004A53O00B700012O00530103000B3O00065E000300B700013O0004A53O00B700012O0053010300013O0020530003000300032O005F0103000200022O00530104000C3O000679000300B7000100040004A53O00B70001002EA30039000D000100390004A53O00B700012O0053010300064O0053010400083O00209C00040004003A2O005F01030002000200065E000300B700013O0004A53O00B700012O0053010300043O0012500004003B3O0012500005003C4O0048000300054O002701035O001250000200283O0004A53O006B000100265B000100BD0001002B0004A53O00BD0001002E80003E00062O01003D0004A53O00062O01001250000200013O00265B000200C2000100010004A53O00C20001002EA2003F003O0100400004A53O003O012O0053010300084O001F010400043O00122O000500413O00122O000600426O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300E200013O0004A53O00E200012O00530103000D3O00065E000300E200013O0004A53O00E200012O0053010300013O0020530003000300032O005F0103000200022O00530104000E3O000679000300E2000100040004A53O00E200012O0053010300064O0053010400083O00209C0004000400432O005F01030002000200066A000300DD000100010004A53O00DD0001002EA2004500E2000100440004A53O00E200012O0053010300043O001250000400463O001250000500474O0048000300054O002701036O0053010300054O001F010400043O00122O000500483O00122O000600496O0004000600024O00030003000400202O00030003000E4O00030002000200062O00032O002O013O0004A54O002O012O00530103000F3O00065E00032O002O013O0004A54O002O012O0053010300013O0020530003000300032O005F0103000200022O0053010400103O00067900032O002O0100040004A54O002O012O0053010300064O0053010400073O00209C00040004004A2O005F01030002000200065E00032O002O013O0004A54O002O012O0053010300043O0012500004004B3O0012500005004C4O0048000300054O002701035O001250000200283O0026D8000200BE000100280004A53O00BE0001001250000100023O0004A53O00062O010004A53O00BE0001002E80004D00672O0100260004A53O00672O01000E51012800672O0100010004A53O00672O01001250000200013O00265B000200112O0100010004A53O00112O01002E69014E00112O01004F0004A53O00112O01002EA300500053000100510004A53O00622O012O0053010300084O001F010400043O00122O000500523O00122O000600536O0004000600024O00030003000400202O0003000300314O00030002000200062O000300332O013O0004A53O00332O012O0053010300113O00065E000300332O013O0004A53O00332O012O0053010300013O0020530003000300032O005F0103000200022O0053010400123O000679000300332O0100040004A53O00332O012O0053010300064O0053010400083O00209C0004000400542O005F01030002000200066A0003002E2O0100010004A53O002E2O01002E120155002E2O0100560004A53O002E2O01002EA2005800332O0100570004A53O00332O012O0053010300043O001250000400593O0012500005005A4O0048000300054O002701036O0053010300084O001F010400043O00122O0005005B3O00122O0006005C6O0004000600024O00030003000400202O00030003005D4O00030002000200062O000300502O013O0004A53O00502O012O0053010300084O001F010400043O00122O0005005E3O00122O0006005F6O0004000600024O00030003000400202O0003000300314O00030002000200062O000300502O013O0004A53O00502O012O0053010300133O00065E000300502O013O0004A53O00502O012O0053010300013O0020530003000300032O005F0103000200022O0053010400143O00062900030003000100040004A53O00522O01002E80006000612O0100610004A53O00612O01002E80006300612O0100620004A53O00612O012O0053010300064O0053010400083O00209C0004000400642O005F01030002000200066A0003005C2O0100010004A53O005C2O01002E80006500612O0100660004A53O00612O012O0053010300043O001250000400673O001250000500684O0048000300054O002701035O001250000200283O0026D80002000B2O0100280004A53O000B2O01001250000100253O0004A53O00672O010004A53O000B2O01002EA3001C009EFE2O001C0004A53O0005000100265B0001006D2O0100010004A53O006D2O01002EA2006900050001006A0004A53O00050001001250000200014O008D000300033O00265B000200732O0100010004A53O00732O01002EA2006C006F2O01006B0004A53O006F2O01001250000300013O00265B000300782O0100010004A53O00782O01002EA2006D00CE2O01006E0004A53O00CE2O01002E80007000A32O01006F0004A53O00A32O012O0053010400084O001F010500043O00122O000600713O00122O000700726O0005000700024O00040004000500202O0004000400314O00040002000200062O000400942O013O0004A53O00942O012O0053010400153O00065E000400942O013O0004A53O00942O012O0053010400013O00206F0104000400734O000600083O00202O0006000600744O00040006000200062O000400942O013O0004A53O00942O012O0053010400013O0020530004000400032O005F0104000200022O0053010500163O00062900040003000100050004A53O00962O01002EA2007500A32O0100760004A53O00A32O01002E80007800A32O0100770004A53O00A32O012O0053010400064O0053010500083O00209C0005000500742O005F01040002000200065E000400A32O013O0004A53O00A32O012O0053010400043O001250000500793O0012500006007A4O0048000400064O002701046O0053010400084O001F010500043O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O0004000400314O00040002000200062O000400BE2O013O0004A53O00BE2O012O0053010400173O00065E000400BE2O013O0004A53O00BE2O012O0053010400013O00206F0104000400734O000600083O00202O0006000600744O00040006000200062O000400BE2O013O0004A53O00BE2O012O0053010400183O0020BA00040004007D4O000500193O00122O000600256O00040006000200062O000400C02O0100010004A53O00C02O01002EA3007E000F0001007F0004A53O00CD2O01002E80008100CD2O0100800004A53O00CD2O012O0053010400064O0053010500083O00209C0005000500822O005F01040002000200065E000400CD2O013O0004A53O00CD2O012O0053010400043O001250000500833O001250000600844O0048000400064O002701045O001250000300283O00265B000300D22O0100280004A53O00D22O01002EA2008500742O0100860004A53O00742O01001250000100283O0004A53O000500010004A53O00742O010004A53O000500010004A53O006F2O010004A53O000500010004A53O00DA2O010004A53O000200012O0048012O00017O00333O00028O00025O00AAAB40025O008EA040030F3O009831A875B1BA6CBAAD26A778BABC5103083O00D4D943CB142ODF25030A3O0049734361737461626C6503083O0042752O66446F776E030F3O00417263616E65496E74652O6C65637403103O0047726F757042752O664D692O73696E67031C3O00BB9FABD3B48897DBB499ADDEB688ABC6FA9DBAD7B982A5D0BB99E88003043O00B2DAEDC8030B3O009BBCF4C2B9A7CFDDB7B2E303043O00B0D6D586030D3O00546172676574497356616C6964025O00406F40025O00307740025O00D07E40025O00F6AC40025O00CDB140025O0058A740025O0016B140025O00689540030B3O004D692O726F72496D61676503183O00F92OA4C6A74466FDA0B7D3AD1649E6A8B5DBA55458E0EDE403073O003994CDD6B4C836026O00F03F025O007EAB40025O007AA84003093O0022E4273B741EFC262003053O0016729D555403073O004973526561647903093O00497343617374696E6703093O005079726F626C617374025O0084B340025O0071B240030E3O0049735370652O6C496E52616E6765025O0012A640025O0076A84003153O00D4D201CB5FFAA9D7DF53D44FF3ABCBC611C549B6FC03073O00C8A4AB73A43D96025O00ECAC40025O00709340025O006EAF40025O003EA54003083O0098FD114081BFF80F03053O00E3DE946325025O00749040025O00709F4003083O004669726562612O6C03143O00355B40F3FB322O5EB6E9215751F9F4315346B6AF03053O0099532O329600B13O0012503O00014O008D000100013O0026D83O0002000100010004A53O00020001001250000100013O00265B00010009000100010004A53O00090001002EA200020059000100030004A53O005900012O005301026O001F010300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O0002003000013O0004A53O003000012O0053010200023O00065E0002003000013O0004A53O003000012O0053010200033O0020810002000200074O00045O00202O0004000400084O000500016O00020005000200062O00020025000100010004A53O002500012O0053010200043O0020360102000200094O00035O00202O0003000300084O00020002000200062O0002003000013O0004A53O003000012O0053010200054O005301035O00209C0003000300082O005F01020002000200065E0002003000013O0004A53O003000012O0053010200013O0012500003000A3O0012500004000B4O0048000200044O002701026O005301026O001F010300013O00122O0004000C3O00122O0005000D6O0003000500024O00020002000300202O0002000200064O00020002000200062O0002004500013O0004A53O004500012O0053010200043O00209C00020002000E2O000C01020001000200065E0002004500013O0004A53O004500012O0053010200063O00065E0002004500013O0004A53O004500012O0053010200073O00066A00020049000100010004A53O00490001002E69010F0049000100100004A53O00490001002EA200120058000100110004A53O00580001002E8000140058000100130004A53O00580001002EA200160058000100150004A53O005800012O0053010200054O005301035O00209C0003000300172O005F01020002000200065E0002005800013O0004A53O005800012O0053010200013O001250000300183O001250000400194O0048000200044O002701025O0012500001001A3O0026D8000100050001001A0004A53O00050001002EA2001C00870001001B0004A53O008700012O005301026O001F010300013O00122O0004001D3O00122O0005001E6O0003000500024O00020002000300202O00020002001F4O00020002000200062O0002008700013O0004A53O008700012O0053010200083O00065E0002008700013O0004A53O008700012O0053010200033O0020170102000200204O00045O00202O0004000400214O00020004000200062O00020087000100010004A53O00870001002EA200230080000100220004A53O008000012O0053010200054O00AE00035O00202O0003000300214O000400093O00202O0004000400244O00065O00202O0006000600214O0004000600024O000400046O000500016O00020005000200062O00020082000100010004A53O00820001002EA300250007000100260004A53O008700012O0053010200013O001250000300273O001250000400284O0048000200044O002701025O002EA2002A00B0000100290004A53O00B00001002E80002C00B00001002B0004A53O00B000012O005301026O001F010300013O00122O0004002D3O00122O0005002E6O0003000500024O00020002000300202O00020002001F4O00020002000200062O000200B000013O0004A53O00B000012O00530102000A3O00065E000200B000013O0004A53O00B00001002E80002F00B0000100300004A53O00B000012O0053010200054O005501035O00202O0003000300314O000400093O00202O0004000400244O00065O00202O0006000600314O0004000600024O000400046O000500016O00020005000200065E000200B000013O0004A53O00B000012O0053010200013O001205000300323O00122O000400336O000200046O00025O00044O00B000010004A53O000500010004A53O00B000010004A53O000200012O0048012O00017O004A3O00028O00025O00606E40025O00A4B140026O00F03F025O0065B140025O0063B340025O0080AE40025O00D1B240025O003EAD40025O00389D40025O00A07240025O00ECA940030D3O0009DC5EEC49C1930FDC5AEA52C703073O00E04DAE3F8B26AF03073O004973526561647903103O00A54D5D3697554A2F975B593DA2544A3703043O004EE42138030B3O004973417661696C61626C6503083O0042752O66446F776E030D3O00486F7453747265616B42752O6603063O0042752O665570030F3O00462O656C7468654275726E42752O66030A3O00436F6D62617454696D65026O002E40030E3O00FA7BBF1380DC7BB62589CF73B71003053O00E5AE1ED263025O00DC9540025O00349840030D3O00447261676F6E73427265617468031F3O001FFF8756E2332A24EF9454EC29315BEC8545E42B3C24F9875DE8332D08ADD003073O00597B8DE6318D5D030D3O00D763F70B1F44E053E409115EFB03063O002A9311966C7003103O002EAA2867F4FC1DA73E65E6FB29B33F6603063O00886FC64D1F87030E3O00360CAA46B8F612AD2405A65BB8F703083O00C96269C736DD8477031F3O00BD1E82260D3BBF860E91240321A4F90D80350B23A98618822D073BB8AA4CDB03073O00CCD96CE3416255025O0048AE40030A3O00717F65157DAC6F527B7103073O002D3D16137C13CB030A3O00ED2O1BFC0C779BCE1F0F03073O00D9A1726D956210030F3O00432O6F6C646F776E52656D61696E73025O00E49140025O00B0A140025O00109240025O0040A940030A3O004C6976696E67426F6D62030E3O0049735370652O6C496E52616E6765031C3O001E292E75B2732D223771BE3413232C75AA712D343970B97A0633782E03063O00147240581CDC03063O001C04C6B1F7C203073O00DD5161B2D498B0030B3O0042752O6652656D61696E73030E3O00436F6D62757374696F6E42752O6603063O00E0E209FE15DF03053O007AAD877D9B030A3O0054726176656C54696D6503103O00B7D40E92363FCF97E30CBC2C22C18AC603073O00A8E4A160D95F51025O00804640025O00A2AB40025O00E5B140025O0035B040025O00E07F40030C3O004D6574656F72437572736F7203093O004973496E52616E6765026O00444003173O00D6D43A5920459BD02D482641DEEE3A5D2352D5C53D1C7B03063O0037BBB14E3C4F026O009740025O0048AB40003E012O0012503O00014O008D000100023O002E8000020006000100030004A53O0006000100265B3O0008000100040004A53O00080001002E80000600352O0100050004A53O00352O0100265B0001000C000100010004A53O000C0001002EA3000700FEFF2O00080004A53O00080001001250000200013O002E80000A00A6000100090004A53O00A600010026D8000200A6000100040004A53O00A60001002E80000B00520001000C0004A53O005200012O005301036O001F010400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003005200013O0004A53O005200012O0053010300023O00065E0003005200013O0004A53O005200012O005301036O001F010400013O00122O000500103O00122O000600116O0004000600024O00030003000400202O0003000300124O00030002000200062O0003005200013O0004A53O005200012O0053010300033O00065E0003005200013O0004A53O005200012O0053010300043O00206F0103000300134O00055O00202O0005000500144O00030005000200062O0003005200013O0004A53O005200012O0053010300043O0020170103000300154O00055O00202O0005000500164O00030005000200062O00030040000100010004A53O004000012O0053010300053O00209C0003000300172O000C010300010002000E9700180052000100030004A53O005200012O0053010300064O000C01030001000200066A00030052000100010004A53O005200012O0053010300074O000C0103000100020026D800030052000100010004A53O005200012O005301036O001F010400013O00122O000500193O00122O0006001A6O0004000600024O00030003000400202O0003000300124O00030002000200062O0003005400013O0004A53O00540001002EA2001C005F0001001B0004A53O005F00012O0053010300084O005301045O00209C00040004001D2O005F01030002000200065E0003005F00013O0004A53O005F00012O0053010300013O0012500004001E3O0012500005001F4O0048000300054O002701036O005301036O001F010400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003003D2O013O0004A53O003D2O012O0053010300023O00065E0003003D2O013O0004A53O003D2O012O005301036O001F010400013O00122O000500223O00122O000600236O0004000600024O00030003000400202O0003000300124O00030002000200062O0003003D2O013O0004A53O003D2O012O0053010300033O00065E0003003D2O013O0004A53O003D2O012O0053010300043O00206F0103000300134O00055O00202O0005000500144O00030005000200062O0003003D2O013O0004A53O003D2O012O0053010300043O0020170103000300154O00055O00202O0005000500164O00030005000200062O0003008C000100010004A53O008C00012O0053010300053O00209C0003000300172O000C010300010002000E970018003D2O0100030004A53O003D2O012O0053010300064O000C01030001000200066A0003003D2O0100010004A53O003D2O012O005301036O001F010400013O00122O000500243O00122O000600256O0004000600024O00030003000400202O0003000300124O00030002000200062O0003003D2O013O0004A53O003D2O012O0053010300084O005301045O00209C00040004001D2O005F01030002000200065E0003003D2O013O0004A53O003D2O012O0053010300013O001205000400263O00122O000500276O000300056O00035O00044O003D2O010026D80002000D000100010004A53O000D0001001250000300013O002EA300280083000100280004A53O002C2O010026D80003002C2O0100010004A53O002C2O012O005301046O001F010500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400CE00013O0004A53O00CE00012O0053010400093O00065E000400CE00013O0004A53O00CE00012O00530104000A3O000E97000400CE000100040004A53O00CE00012O0053010400033O00065E000400CE00013O0004A53O00CE00012O00530104000B4O002001058O000600013O00122O0007002B3O00122O0008002C6O0006000800024O00050005000600202O00050005002D4O00050002000200062O000500D0000100040004A53O00D000012O00530104000B3O0026D2000400D0000100010004A53O00D00001002EA2002F00E30001002E0004A53O00E30001002EA2003000E3000100310004A53O00E300012O0053010400084O007201055O00202O0005000500324O0006000C3O00202O0006000600334O00085O00202O0008000800324O0006000800024O000600066O00040006000200062O000400E300013O0004A53O00E300012O0053010400013O001250000500343O001250000600354O0048000400064O002701046O005301046O001F010500013O00122O000600363O00122O000700376O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400172O013O0004A53O00172O012O00530104000D3O00065E000400172O013O0004A53O00172O012O00530104000E4O00530105000F3O00063B010400172O0100050004A53O00172O012O00530104000B3O0026D2000400192O0100010004A53O00192O012O0053010400043O0020080004000400384O00065O00202O0006000600394O0004000600024O00058O000600013O00122O0007003A3O00122O0008003B6O0006000800024O00050005000600202O00050005003C4O00050002000200062O000500192O0100040004A53O00192O012O005301046O00DC000500013O00122O0006003D3O00122O0007003E6O0005000700024O00040004000500202O0004000400124O00040002000200062O000400172O0100010004A53O00172O012O00530104000B3O000EA7003F00192O0100040004A53O00192O012O00530104000F4O00530105000B3O00060C000400192O0100050004A53O00192O01002EA20041002B2O0100400004A53O002B2O01002E800043002B2O0100420004A53O002B2O012O0053010400084O0060000500103O00202O0005000500444O0006000C3O00202O00060006004500122O000800466O0006000800024O000600066O00040006000200062O0004002B2O013O0004A53O002B2O012O0053010400013O001250000500473O001250000600484O0048000400064O002701045O001250000300043O0026D8000300A9000100040004A53O00A90001001250000200043O0004A53O000D00010004A53O00A900010004A53O000D00010004A53O003D2O010004A53O000800010004A53O003D2O0100265B3O00392O0100010004A53O00392O01002E80004A0002000100490004A53O00020001001250000100014O008D000200023O0012503O00043O0004A53O000200012O0048012O00017O00673O00028O00026O00F03F025O00406040025O00B49D40025O00488840025O00C4A340025O0004A440025O006AAD40025O0042AD40025O0036A540025O002C9A40025O00507340025O00B2A640025O00308E40025O004EB340025O00CC9A40025O0094A140025O00889840025O003EA740025O0048B14003093O007CCFFAEA28E64BD1EC03063O00A03EA395854C030A3O0049734361737461626C6503093O00426C2O6F644675727903213O00D4AC0220C7E9A6183DDA96A30222C1C3B31926CCD89F0E20CCDAA40238CDC5E05903053O00A3B6C06D4F025O00A4A640025O00F09040030A3O00162312D3F0262D09CEF203053O0095544660A0025O0046A540030A3O004265727365726B696E67025O00C05940025O00EEAF4003213O003A031FFE3D1406E436014DEE370B0FF82B1204E236390EE2370A09E22F081EAD6E03043O008D58666D025O00B8A740025O002CA44003093O00955AD87518315ACEB703083O00A1D333AA107A5D35025O00E06F40026O008340025O00AEA040025O002O7040025O00909F4003093O0046697265626C2O6F6403203O00FDA7A02DF9A2BD27FFEEB127F6ACA73BEFA7BD26C4ADBD27F7AABD3FF5BDF27003043O00489BCED2030D3O006774570B20526855021047765803053O0053261A346E030D3O00416E6365737472616C43612O6C025O001CAF40025O00F8A640025O00606540025O003C904003263O00591924434B03354754282447541B6745571A25534B032E4956282449571B23494F193406094703043O002638774703083O00C7E655D31257E1FF03063O0036938F38B64503073O0049735265616479030C3O00E284F259D0C480F37EDEC49103053O00BFB6E19F29030B3O004973417661696C61626C6503123O00426C2O6F646C757374457868617573745570025O009EAD40025O004CB24003083O0054696D6557617270025O00DEA640025O00388E40025O0054A340025O0078A14003213O003F1B2550B490C339026856848AC03E013C5C8489FD281D27598F88D525016804D903073O00A24B724835EBE7025O00B88340025O00E2A640027O0040026O00A340025O00489240025O00507540025O00E8AE40025O00EAB240025O00689740025O00B49040025O0098B240025O00809440025O0056B340025O00B9B240025O00A4A940025O003EB340025O00B88040025O00408A40025O00EC9240025O0093B140025O00C09840025O00F8AC40025O007DB040030F3O0048616E646C65445053506F74696F6E03063O0042752O665570030E3O00436F6D62757374696F6E42752O66025O00C0AC40025O00307E40025O00A49B40025O00A7B2400062012O0012503O00014O008D000100033O0026D83O00592O0100020004A53O00592O012O008D000300033O0026D8000100522O0100020004A53O00522O0100265B0002000B000100020004A53O000B0001002E80000400EC000100030004A53O00EC0001001250000400013O0026D8000400E5000100010004A53O00E50001002EA200050020000100060004A53O002000012O005301055O00065E0005002000013O0004A53O002000012O0053010500013O00065E0005001900013O0004A53O001900012O0053010500023O00066A0005001C000100010004A53O001C00012O0053010500013O00066A00050020000100010004A53O002000012O0053010500034O0053010600043O00060C00050022000100060004A53O00220001002E80000800B5000100070004A53O00B50001001250000500014O008D000600063O0026D800050024000100010004A53O00240001001250000600013O002E80000A002B000100090004A53O002B000100265B0006002D000100010004A53O002D0001002EA2000B00790001000C0004A53O00790001001250000700013O0026D800070032000100020004A53O00320001001250000600023O0004A53O00790001002E80000E002E0001000D0004A53O002E000100265B00070038000100010004A53O00380001002EA3000F00F8FF2O00100004A53O002E0001001250000800013O0026D80008003D000100020004A53O003D0001001250000700023O0004A53O002E0001002EA200120039000100110004A53O0039000100265B00080043000100010004A53O00430001002EA200140039000100130004A53O003900012O0053010900054O001F010A00063O00122O000B00153O00122O000C00166O000A000C00024O00090009000A00202O0009000900174O00090002000200062O0009005800013O0004A53O005800012O0053010900074O0053010A00053O00209C000A000A00182O005F01090002000200065E0009005800013O0004A53O005800012O0053010900063O001250000A00193O001250000B001A4O00480009000B4O002701095O002E80001C00760001001B0004A53O007600012O0053010900054O001F010A00063O00122O000B001D3O00122O000C001E6O000A000C00024O00090009000A00202O0009000900174O00090002000200062O0009007600013O0004A53O007600012O0053010900083O00065E0009007600013O0004A53O00760001002EA3001F000F0001001F0004A53O007600012O0053010900074O0053010A00053O00209C000A000A00202O005F01090002000200066A00090071000100010004A53O00710001002EA300210007000100220004A53O007600012O0053010900063O001250000A00233O001250000B00244O00480009000B4O002701095O001250000800023O0004A53O003900010004A53O002E0001002EA200260027000100250004A53O002700010026D800060027000100020004A53O002700012O0053010700054O00DC000800063O00122O000900273O00122O000A00286O0008000A00024O00070007000800202O0007000700174O00070002000200062O0007008B000100010004A53O008B0001002EE1002A008B000100290004A53O008B0001002E80002B00980001002C0004A53O00980001002EA3002D000D0001002D0004A53O009800012O0053010700074O0053010800053O00209C00080008002E2O005F01070002000200065E0007009800013O0004A53O009800012O0053010700063O0012500008002F3O001250000900304O0048000700094O002701076O0053010700054O001F010800063O00122O000900313O00122O000A00326O0008000A00024O00070007000800202O0007000700174O00070002000200062O000700B500013O0004A53O00B500012O0053010700074O0053010800053O00209C0008000800332O005F01070002000200066A000700AC000100010004A53O00AC0001002E12013400AC000100350004A53O00AC0001002EA2003700B5000100360004A53O00B500012O0053010700063O001205000800383O00122O000900396O000700096O00075O00044O00B500010004A53O002700010004A53O00B500010004A53O002400012O0053010500093O00065E000500D100013O0004A53O00D100012O0053010500054O001F010600063O00122O0007003A3O00122O0008003B6O0006000800024O00050005000600202O00050005003C4O00050002000200062O000500D100013O0004A53O00D100012O0053010500054O001F010600063O00122O0007003D3O00122O0008003E6O0006000800024O00050005000600202O00050005003F4O00050002000200062O000500D100013O0004A53O00D100012O00530105000A3O0020530005000500402O005F01050002000200066A000500D3000100010004A53O00D30001002EA2004200E4000100410004A53O00E400012O0053010500074O0006010600053O00202O0006000600434O000700086O000900016O00050009000200062O000500DF000100010004A53O00DF0001002E12014400DF000100450004A53O00DF0001002E80004600E4000100470004A53O00E400012O0053010500063O001250000600483O001250000700494O0048000500074O002701055O001250000400023O000E7D000200E9000100040004A53O00E90001002EA2004B000C0001004A0004A53O000C00010012500002004C3O0004A53O00EC00010004A53O000C0001000E7D004C00F0000100020004A53O00F00001002EA2004D00292O01004E0004A53O00292O012O0053010400034O0053010500043O00060C000400F6000100050004A53O00F60001002EA2005000612O01004F0004A53O00612O012O00530104000B3O00065E000400612O013O0004A53O00612O012O0053010400023O00065E000400FF00013O0004A53O00FF00012O00530104000C3O00066A000400022O0100010004A53O00022O012O00530104000C3O00066A000400612O0100010004A53O00612O01001250000400014O008D000500063O00265B000400082O0100020004A53O00082O01002E80005100222O0100520004A53O00222O01002EA2005300082O0100540004A53O00082O0100265B0005000E2O0100010004A53O000E2O01002EA2005600082O0100550004A53O00082O01001250000600013O002EA20058000F2O0100570004A53O000F2O010026D80006000F2O0100010004A53O000F2O012O00530107000E4O000C0107000100022O00DB0007000D3O002EA2005A00612O0100590004A53O00612O012O00530107000D3O00065E000700612O013O0004A53O00612O012O00530107000D4O0009000700023O0004A53O00612O010004A53O000F2O010004A53O00612O010004A53O00082O010004A53O00612O010026D8000400042O0100010004A53O00042O01001250000500014O008D000600063O001250000400023O0004A53O00042O010004A53O00612O0100265B0002002D2O0100010004A53O002D2O01002EA3005B00DCFE2O005C0004A53O00070001001250000400013O0026D8000400322O0100020004A53O00322O01001250000200023O0004A53O00070001002EA2005E002E2O01005D0004A53O002E2O010026D80004002E2O0100010004A53O002E2O01001250000500013O0026D80005003B2O0100020004A53O003B2O01001250000400023O0004A53O002E2O01002E80005F00372O0100600004A53O00372O01000E512O0100372O0100050004A53O00372O012O00530106000F3O00207C0006000600614O0007000A3O00202O0007000700624O000900053O00202O0009000900634O000700096O00063O00024O000300063O00062O0003004C2O0100010004A53O004C2O01002E800064004D2O0100650004A53O004D2O012O0009000300023O001250000500023O0004A53O00372O010004A53O002E2O010004A53O000700010004A53O00612O01000E512O010005000100010004A53O00050001001250000200014O008D000300033O001250000100023O0004A53O000500010004A53O00612O0100265B3O005D2O0100010004A53O005D2O01002EA3006600A7FE2O00670004A53O00020001001250000100014O008D000200023O0012503O00023O0004A53O000200012O0048012O00017O005C012O00028O00025O0074B240027O0040025O002CA540025O00D08040025O00549640025O00F2A840030B3O00D50F281D874B0C64FA082C03083O001693634970E2387803073O004973526561647903093O00497343617374696E67030B3O00466C616D65737472696B6503063O0042752O66557003143O00467572796F6674686553756E4B696E6742752O66030B3O0042752O6652656D61696E73030B3O009E79E3F888AB61F0FC86BD03053O00EDD815829503083O004361737454696D65030A3O00A141525DA5DA4A8B415103073O003EE22E2O3FD0A9030F3O00432O6F6C646F776E52656D61696E73030B3O00C315548E1A1E3B4CEC125003083O003E857935E37F6D4F03113O00466C616D65737472696B65437572736F7203093O004973496E52616E6765026O004440031F3O00161833F8D3BDB6021D39F0962OAD1D1627E6C2A7AD1E2B22FDD7BDA750456003073O00C270745295B6CE03093O0009B15E17C2EE0F2ABC03073O006E59C82C78A08203093O005079726F626C61737403093O009BDA594941463A5EBF03083O002DCBA32B26232A5B030E3O0049735370652O6C496E52616E6765031D3O00C29CCE2C85A555C1919C2088A456C796C82A88A76BC28DDD3082E9058603073O0034B2E5BC43E7C903083O0007484201F55D2F2D03073O004341213064973C030A3O00FCE8A3DAE6CCF3A7D7FD03053O0093BF87CEB803083O00A221B4C4DA52BE8803073O00D2E448C6A1B833025O00908D40025O00DFB240025O0088854003083O004669726562612O6C031C3O003040E11571CF3A45B3137CC3345CE0047AC13876E31872DD3309A24603063O00AE562993701303063O0068038219260703083O00CB3B60ED6B456F71030A3O000719A1E324E3C32D19A203073O00B74476CC81519003063O003DAE7FF6088A03063O00E26ECD10846B025O008AA440025O00707E4003063O0053636F726368031A3O00F8C0EFCB42E383E3D64CE9D6F3CD48E4CDDFC949EAD0E59910B303053O00218BA380B9026O000840026O00F03F025O0014B140025O00B2A640030D3O00DCA00CC152E5B025C85DE1AD1003053O003C8CC863A4030A3O0049734361737461626C6503083O0042752O66446F776E030E3O00436F6D62757374696F6E42752O6603073O0048617354696572026O003E40030D3O00B7FC0B23AC8EEC222AA38AF11703053O00C2E794644603083O00496E466C69676874030D3O00446562752O6652656D61696E7303143O004368612O72696E67456D62657273446562752O66026O001040030D3O00486F7453747265616B42752O66025O00B89140025O00088040030D3O0050686F656E6978466C616D657303213O005644CEA6F8C15E73C7AFF7C5435F81A0F9C54459D2B7FFC74873D1ABF7DB430C9903063O00A8262CA1C396025O00D2AA40025O00ECA340030A3O00A3F38F7425FBA21F8FF203083O0076E09CE2165088D603063O0071ED569241E603043O00E0228E39030E3O004578656375746552656D61696E7303083O00F8AED7D871F0510203083O006EBEC7A5BD13913D03093O00EAF265E789CBDBF86303063O00A7BA8B1788EB030B3O003CB989001FA69C1F13BE8D03043O006D7AD5E803063O00C3F2B635E1E503043O00508E97C203063O002EC363490CD403043O002C63A617030F3O00496E466C6967687452656D61696E73025O00108B40025O0090A640025O00707940025O00349F40030A3O00436F6D62757374696F6E031E3O007FF8243426B768FE263873A773FA2B2320B075F8270923AC7DE42C7662F403063O00C41C97495653025O0064AE4003093O0093559313BE03A25F9503063O006FC32CE17CDC03083O005072657647434450030D3O0048656174696E67557042752O66025O00BC9640025O0032A040025O0022AB40025O00E2B140025O00C88040025O0060A740031D3O00C85F127CA9A7D9551433A8A4D5441560BFA2D7483F63A3AACB434021F303063O00CBB8266013CB030D3O000A7B7047DA307D7E71C12E766B03053O00AE5913192103093O00091B404BD58B0A3C0603073O006B4F72322E97E703073O0043686172676573030D3O0009AEBA2C8430AFE635A7B82C9903083O00A059C6D549EA59D7030D3O007879BBFBCB416992F2C44574A703053O00A52811D49E030A3O004D61784368617267657303103O00C4D50D2B35F1CB09203CE4CA2E2634FC03053O004685B96853030B3O004973417661696C61626C65025O00ACAF40025O00806040025O009C9840025O0046A240030D3O005368696674696E67506F77657203223O00172O4D2CDD0D4B4315D90B52413889074A4928DC17514D25C73B554C2BDA0105177A03053O00A96425244A025O0076A340025O009C9F40030B3O00268BA35D0594B642098CA703043O003060E7C2030B3O00EE560F201CCBBB91C1510B03083O00E3A83A6E4D79B8CF025O00AEA340025O00A2AC40025O0026AE40031F3O007D30BE4DB4C865B77237BA00B2D47CA76E2FAB49BED54EB5733DAC45F1882303083O00C51B5CDF20D1BB1103093O003346D1F40153C2E81703043O009B633FA303093O00B2C8B382BB8883C2B503063O00E4E2B1C1EDD9025O00F07C40025O0049B340025O00D8AD40025O00EAA940031D3O0024A931E936BC22F520F020E939B236F520B92CE80BA02BE727B563B56003043O008654D043026O001440026O00184003063O000ED7B5CF744603083O00325DB4DABD172E4703063O00EDA7545E47D403073O0028BEC43B2C24BC03063O000F46D3A6F97503073O006D5C25BCD49A1D025O002EAF40025O005CAD40025O00D07B40025O0034A840025O00708940025O00A4A840031A3O0017ECABD1325244ECABCE334F17FBADCC3F6514E7A5D0341A50BB03063O003A648FC4A35103083O003C4B31A63D48E90203083O006E7A2243C35F298503083O0053B8494FD474BD5703053O00B615D13B2A025O001EAB40025O00CCB140031C3O00B15ED71823BFBB5B851E2EB3B542D60928B1B968D51520ADB217914B03063O00DED737A57D41030A4O00D8D013FCC6CF4521D303083O002A4CB1A67A92A18D030A3O004C6976696E67426F6D62025O0023B140025O00F8A140031F3O00A98313C777719A880AC37B36A68508CC6C65B1830AC04666AD8B16CB3922FD03063O0016C5EA65AE19025O00CDB040025O00C8A440025O00E6A840025O00A1B240025O00D89840025O000AA84003063O0020AF894E10A403043O003C73CCE603143O00496D70726F76656453636F726368446562752O66025O00FCAB40025O00789C40031A3O00F439E462E432AB73E837E965F42EE27FE905FB78E629EE30B46C03043O0010875A8B025O00709B40025O00EC9640030D3O00647C0936405D607278073E4B4703073O0018341466532E34030D3O00F4272E2101CD3707280EC92A3203053O006FA44F4144030A3O0054726176656C54696D6503093O0042752O66537461636B030E3O00466C616D65734675727942752O66025O000BB040025O00149040025O00CC9C40025O0048AE40025O0010A240025O0070AD4003223O00D6D18CDB20E3DEE685D22FE7C3CAC3DD21E7C4CC90CA27E5C8E693D62FF9C399D08603063O008AA6B9E3BE4E025O006BB240025O0018924003083O00ED7DD732502215C703073O0079AB14A557324303083O00E031AB33BB03CA3403063O0062A658D956D903133O00466C616D65412O63656C6572616E7442752O66025O00149F40025O00E8B140025O0091B040031C3O00F0FF6B0484DD2OFA390289D1F4E36A158FD3F8C9690987CFF3B62D5103063O00BC2O961961E6030D3O00EA81500702E4C2AF530301E8C903063O008DBAE93F626C03103O00D0E629AE36E5F82DA53FF0F90AA337E803053O0045918A4CD6030D3O0040C7868CB11F68E98588B2136303063O007610AF2OE9DF025O00B4A840025O0007B040025O00DC9A40025O00049C40025O0060A240025O0030B24003223O009B8C3ABEE08265B48239BAE38E6ECB873AB6EC9E6E9F8D3AB5D19B758A9730FBBAD903073O001DEBE455DB8EEB025O005EA940025O0030B140025O0032A140025O00B4B240025O0062AD40025O0072A54003093O00715116DB755405CD4303043O00BE37386403103O004879706572746865726D696142752O66030A3O0047434452656D61696E73025O00A08340025O00208840025O0050B04003093O0046697265426C617374031E3O0050A62E1B2CE1FF57BC285E10ECFE54BA2F0A1AECFD69BF341F00E6B304FF03073O009336CF5C7E7383025O00C07440025O0044A840025O009CA540025O00708440030B3O002B3D3470086D19233C760803063O001E6D51551D6D030C3O00D76844B324CAF4FA6359BF3703073O009C9F1134D656BE025O00DBB240025O0084A240031F3O00A8E3BCB1ABFCA9AEA7E4B8FCADE0B0BEBBFCA9B5A1E182ACA6EEAEB9EEBDEF03043O00DCCE8FDD03093O00B6643F18DAC0D3956903073O00B2E61D4D77B8AC025O006CA340025O0046A640025O0020AF40025O00749940025O00909A40025O00489440031D3O00E5A71814752OF4AD1E5B74F7F8BC1F0863F1FAB0350B7FF9E6BB4A492303063O009895DE6A7B17025O0044A04003093O00ED3FE44CB7D127E55703053O00D5BD469623025O0052A340025O005EAA40025O0020A840025O0094A140025O0016B340025O00CC9E40031D3O005F4C66074D59751B5B1577074257611B5B5C7B0670457C095C50345A1903043O00682F3514025O0044A440025O00589640025O00CDB240025O00C1B140025O00F5B240025O00C08C40025O00749040025O0075B240030E3O00A03543EA4711A62940E55E07822803063O0062EC5C248233025O0033B340025O001DB340025O002FB040030E3O004C69676874734A7564676D656E74025O00F6A140025O00C08A4003223O00A8100BB251BB8A3AB11D0BB740A6A170A71601B850BBA139AB1733AA4DA9A635E44B03083O0050C4796CDA25C8D5025O001C9340025O00ACAA40030B3O00227205704D3A980970096C03073O00EA6013621F2B6E025O00B09540026O005B40025O004DB040025O008CA340030B3O004261676F66547269636B7303203O00041E55F8A374B4120D5BC4A761CB05105FC5B9619F0F105CF8BC7A8A151A129303073O00EB667F32A7CC12025O00207C40025O00AAA340025O00988A40025O004CA540025O0076A140030A3O007CA8E32A4A2972AEF82103063O004E30C1954324025O00F88C40031E3O003C1796114F372182174C325E83174C320B930C483F10BF0849310D85581703053O0021507EE078026O003440025O0015B040025O0010AB40025O00206D40025O00A07840025O00806F40025O008EA740025O003AB240025O003C9040025O00AEB040025O00405F40025O0042A0400056072O0012503O00013O002EA3000200102O0100020004A53O00112O010026D83O00112O0100030004A53O00112O01002EA20005005F000100040004A53O005F0001002E800006005F000100070004A53O005F00012O00532O015O00065E0001005F00013O0004A53O005F00012O00532O0100014O001F010200023O00122O000300083O00122O000400096O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001005F00013O0004A53O005F00012O00532O0100033O00065E0001005F00013O0004A53O005F00012O00532O0100043O0020172O010001000B4O000300013O00202O00030003000C4O00010003000200062O0001005F000100010004A53O005F00012O00532O0100053O00065E0001005F00013O0004A53O005F00012O00532O0100043O00206F2O010001000D4O000300013O00202O00030003000E4O00010003000200062O0001005F00013O0004A53O005F00012O00532O0100043O00204C2O010001000F4O000300013O00202O00030003000E4O0001000300024O000200016O000300023O00122O000400103O00122O000500116O0003000500024O00020002000300202O0002000200124O00020002000200062O0002005F000100010004A53O005F00012O00532O0100014O005A010200023O00122O000300133O00122O000400146O0002000400024O00010001000200202O0001000100154O0001000200024O000200016O000300023O00122O000400163O00122O000500176O0003000500024O00020002000300202O0002000200124O00020002000200062O0001005F000100020004A53O005F00012O00532O0100064O0053010200073O0006790002005F000100010004A53O005F00012O00532O0100084O0060000200093O00202O0002000200184O0003000A3O00202O00030003001900122O0005001A6O0003000500024O000300036O00010003000200062O0001005F00013O0004A53O005F00012O00532O0100023O0012500002001B3O0012500003001C4O0048000100034O00272O016O00532O0100014O001F010200023O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001009D00013O0004A53O009D00012O00532O01000B3O00065E0001009D00013O0004A53O009D00012O00532O0100043O0020172O010001000B4O000300013O00202O00030003001F4O00010003000200062O0001009D000100010004A53O009D00012O00532O0100053O00065E0001009D00013O0004A53O009D00012O00532O0100043O00206F2O010001000D4O000300013O00202O00030003000E4O00010003000200062O0001009D00013O0004A53O009D00012O00532O0100043O00204C2O010001000F4O000300013O00202O00030003000E4O0001000300024O000200016O000300023O00122O000400203O00122O000500216O0003000500024O00020002000300202O0002000200124O00020002000200062O0002009D000100010004A53O009D00012O00532O0100084O0072010200013O00202O00020002001F4O0003000A3O00202O0003000300224O000500013O00202O00050005001F4O0003000500024O000300036O00010003000200062O0001009D00013O0004A53O009D00012O00532O0100023O001250000200233O001250000300244O0048000100034O00272O016O00532O0100014O001F010200023O00122O000300253O00122O000400266O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100C600013O0004A53O00C600012O00532O01000C3O00065E000100C600013O0004A53O00C600012O00532O0100053O00065E000100C600013O0004A53O00C600012O00532O0100014O005A010200023O00122O000300273O00122O000400286O0002000400024O00010001000200202O0001000100154O0001000200024O000200016O000300023O00122O000400293O00122O0005002A6O0003000500024O00020002000300202O0002000200124O00020002000200062O000100C6000100020004A53O00C600012O00532O0100063O0026C9000100C6000100030004A53O00C600012O00532O01000D4O000C2O010001000200065E000100C800013O0004A53O00C80001002E80002C00DB0001002B0004A53O00DB0001002EA3002D00130001002D0004A53O00DB00012O00532O0100084O0072010200013O00202O00020002002E4O0003000A3O00202O0003000300224O000500013O00202O00050005002E4O0003000500024O000300036O00010003000200062O000100DB00013O0004A53O00DB00012O00532O0100023O0012500002002F3O001250000300304O0048000100034O00272O016O00532O0100014O001F010200023O00122O000300313O00122O000400326O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100102O013O0004A53O00102O012O00532O01000E3O00065E000100102O013O0004A53O00102O012O00532O0100053O00065E000100102O013O0004A53O00102O012O00532O0100014O005A010200023O00122O000300333O00122O000400346O0002000400024O00010001000200202O0001000100154O0001000200024O000200016O000300023O00122O000400353O00122O000500366O0003000500024O00020002000300202O0002000200124O00020002000200062O000100102O0100020004A53O00102O01002EA2003800102O0100370004A53O00102O012O00532O0100084O0072010200013O00202O0002000200394O0003000A3O00202O0003000300224O000500013O00202O0005000500394O0003000500024O000300036O00010003000200062O000100102O013O0004A53O00102O012O00532O0100023O0012500002003A3O0012500003003B4O0048000100034O00272O015O0012503O003C3O00265B3O00152O01003D0004A53O00152O01002EA2003E00FF2O01003F0004A53O00FF2O012O00532O0100014O001F010200023O00122O000300403O00122O000400416O0002000400024O00010001000200202O0001000100424O00010002000200062O0001005D2O013O0004A53O005D2O012O00532O01000F3O00065E0001005D2O013O0004A53O005D2O012O00532O0100043O00206F2O01000100434O000300013O00202O0003000300444O00010003000200062O0001005D2O013O0004A53O005D2O012O00532O0100043O00204F2O010001004500122O000300463O00122O000400036O00010004000200062O0001005D2O013O0004A53O005D2O012O00532O0100014O00DC000200023O00122O000300473O00122O000400486O0002000400024O00010001000200202O0001000100494O00010002000200062O0001005D2O0100010004A53O005D2O012O00532O01000A3O00209B00010001004A4O000300013O00202O00030003004B4O0001000300024O000200103O00102O0002004C000200062O0001005D2O0100020004A53O005D2O012O00532O0100043O00206F2O01000100434O000300013O00202O00030003004D4O00010003000200062O0001005D2O013O0004A53O005D2O01002EA2004F005D2O01004E0004A53O005D2O012O00532O0100084O0072010200013O00202O0002000200504O0003000A3O00202O0003000300224O000500013O00202O0005000500504O0003000500024O000300036O00010003000200062O0001005D2O013O0004A53O005D2O012O00532O0100023O001250000200513O001250000300524O0048000100034O00272O016O00532O0100124O000C2O01000100022O00DB000100114O00532O0100113O00066A000100652O0100010004A53O00652O01002EA300530004000100540004A53O00672O012O00532O0100114O0009000100024O00532O0100014O001F010200023O00122O000300553O00122O000400566O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100E82O013O0004A53O00E82O012O00532O0100133O00065E000100E82O013O0004A53O00E82O012O00532O0100143O00065E0001007A2O013O0004A53O007A2O012O00532O0100153O00066A0001007D2O0100010004A53O007D2O012O00532O0100143O00066A000100E82O0100010004A53O00E82O012O00532O0100164O0053010200173O00063B2O0100E82O0100020004A53O00E82O012O00532O0100184O000C2O01000100020026D8000100E82O0100010004A53O00E82O012O00532O0100053O00065E000100E82O013O0004A53O00E82O012O00532O0100193O00263A2O0100E82O0100010004A53O00E82O012O00532O0100043O00206F2O010001000B4O000300013O00202O0003000300394O00010003000200062O0001009D2O013O0004A53O009D2O012O00532O0100014O0062000200023O00122O000300573O00122O000400586O0002000400024O00010001000200202O0001000100594O0001000200024O0002001A3O00062O000100EA2O0100020004A53O00EA2O012O00532O0100043O00206F2O010001000B4O000300013O00202O00030003002E4O00010003000200062O000100AF2O013O0004A53O00AF2O012O00532O0100014O0062000200023O00122O0003005A3O00122O0004005B6O0002000400024O00010001000200202O0001000100594O0001000200024O0002001A3O00062O000100EA2O0100020004A53O00EA2O012O00532O0100043O00206F2O010001000B4O000300013O00202O00030003001F4O00010003000200062O000100C12O013O0004A53O00C12O012O00532O0100014O0062000200023O00122O0003005C3O00122O0004005D6O0002000400024O00010001000200202O0001000100594O0001000200024O0002001A3O00062O000100EA2O0100020004A53O00EA2O012O00532O0100043O00206F2O010001000B4O000300013O00202O00030003000C4O00010003000200062O000100D32O013O0004A53O00D32O012O00532O0100014O0062000200023O00122O0003005E3O00122O0004005F6O0002000400024O00010001000200202O0001000100594O0001000200024O0002001A3O00062O000100EA2O0100020004A53O00EA2O012O00532O0100014O001F010200023O00122O000300603O00122O000400616O0002000400024O00010001000200202O0001000100494O00010002000200062O000100E82O013O0004A53O00E82O012O00532O0100014O0062000200023O00122O000300623O00122O000400636O0002000400024O00010001000200202O0001000100644O0001000200024O0002001A3O00062O000100EA2O0100020004A53O00EA2O01002EA300650016000100660004A53O00FE2O01002E80006700FE2O0100680004A53O00FE2O012O00532O0100084O00E7000200013O00202O0002000200694O0003000A3O00202O00030003001900122O0005001A6O0003000500024O000300036O000400046O000500016O00010005000200062O000100FE2O013O0004A53O00FE2O012O00532O0100023O0012500002006A3O0012500003006B4O0048000100034O00272O015O0012503O00033O002EA3006C00202O01006C0004A53O001F03010026D83O001F0301004C0004A53O001F03012O00532O0100014O001F010200023O00122O0003006D3O00122O0004006E6O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001002602013O0004A53O002602012O00532O01000B3O00065E0001002602013O0004A53O002602012O00532O0100043O0020232O010001006F00122O0003003D6O000400013O00202O0004000400394O00010004000200062O0001002602013O0004A53O002602012O00532O0100043O00206F2O010001000D4O000300013O00202O0003000300704O00010003000200062O0001002602013O0004A53O002602012O00532O0100064O00530102001B3O00063B2O010026020100020004A53O002602012O00532O01001C3O00066A00010028020100010004A53O00280201002E800072003D020100710004A53O003D02012O00532O0100084O00C4000200013O00202O00020002001F4O0003000A3O00202O0003000300224O000500013O00202O00050005001F4O0003000500024O000300036O00010003000200062O00010038020100010004A53O00380201002EE100740038020100730004A53O00380201002EA20076003D020100750004A53O003D02012O00532O0100023O001250000200773O001250000300784O0048000100034O00272O016O00532O0100014O001F010200023O00122O000300793O00122O0004007A6O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001008402013O0004A53O008402012O00532O01001D3O00065E0001008402013O0004A53O008402012O00532O01001E3O00065E0001005002013O0004A53O005002012O00532O0100153O00066A00010053020100010004A53O005302012O00532O01001E3O00066A00010084020100010004A53O008402012O00532O0100164O0053010200173O00063B2O010084020100020004A53O008402012O00532O01001C3O00065E0001008402013O0004A53O008402012O00532O0100014O00C2000200023O00122O0003007B3O00122O0004007C6O0002000400024O00010001000200202O00010001007D4O0001000200020026D800010084020100010004A53O008402012O00532O0100014O00C2000200023O00122O0003007E3O00122O0004007F6O0002000400024O00010001000200202O00010001007D4O0001000200022O0020010200016O000300023O00122O000400803O00122O000500816O0003000500024O00020002000300202O0002000200824O00020002000200062O00010080020100020004A53O008002012O00532O0100014O001F010200023O00122O000300833O00122O000400846O0002000400024O00010001000200202O0001000100854O00010002000200062O0001008402013O0004A53O008402012O00532O01001F4O0053010200063O00062900010003000100020004A53O00860201002EA200860098020100870004A53O00980201002E8000880098020100890004A53O009802012O00532O0100084O0060000200013O00202O00020002008A4O0003000A3O00202O00030003001900122O0005001A6O0003000500024O000300036O00010003000200062O0001009802013O0004A53O009802012O00532O0100023O0012500002008B3O0012500003008C4O0048000100034O00272O015O002EA2008E00DF0201008D0004A53O00DF02012O00532O015O00065E000100DF02013O0004A53O00DF02012O00532O0100014O001F010200023O00122O0003008F3O00122O000400906O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100DF02013O0004A53O00DF02012O00532O0100033O00065E000100DF02013O0004A53O00DF02012O00532O0100043O0020172O010001000B4O000300013O00202O00030003000C4O00010003000200062O000100DF020100010004A53O00DF02012O00532O0100043O00206F2O010001000D4O000300013O00202O00030003000E4O00010003000200062O000100DF02013O0004A53O00DF02012O00532O0100043O00204C2O010001000F4O000300013O00202O00030003000E4O0001000300024O000200016O000300023O00122O000400913O00122O000500926O0003000500024O00020002000300202O0002000200124O00020002000200062O000200DF020100010004A53O00DF02012O00532O0100064O0053010200073O000679000200DF020100010004A53O00DF0201002EA2009300D8020100070004A53O00D802012O00532O0100084O0073000200093O00202O0002000200184O0003000A3O00202O00030003001900122O0005001A6O0003000500024O000300036O00010003000200062O000100DA020100010004A53O00DA0201002EA2009500DF020100940004A53O00DF02012O00532O0100023O001250000200963O001250000300974O0048000100034O00272O016O00532O0100014O001F010200023O00122O000300983O00122O000400996O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001001E03013O0004A53O001E03012O00532O01000B3O00065E0001001E03013O0004A53O001E03012O00532O0100043O0020172O010001000B4O000300013O00202O00030003001F4O00010003000200062O0001001E030100010004A53O001E03012O00532O0100043O00206F2O010001000D4O000300013O00202O00030003000E4O00010003000200062O0001001E03013O0004A53O001E03012O00532O0100043O00204C2O010001000F4O000300013O00202O00030003000E4O0001000300024O000200016O000300023O00122O0004009A3O00122O0005009B6O0003000500024O00020002000300202O0002000200124O00020002000200062O0002001E030100010004A53O001E03012O00532O0100084O00C4000200013O00202O00020002001F4O0003000A3O00202O0003000300224O000500013O00202O00050005001F4O0003000500024O000300036O00010003000200062O00010019030100010004A53O00190301002E12019D00190301009C0004A53O00190301002E80009E001E0301009F0004A53O001E03012O00532O0100023O001250000200A03O001250000300A14O0048000100034O00272O015O0012503O00A23O0026D83O00BC030100A30004A53O00BC03012O00532O0100014O001F010200023O00122O000300A43O00122O000400A56O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001004803013O0004A53O004803012O00532O01000E3O00065E0001004803013O0004A53O004803012O00532O0100043O00204C2O010001000F4O000300013O00202O0003000300444O0001000300024O000200016O000300023O00122O000400A63O00122O000500A76O0003000500024O00020002000300202O0002000200124O00020002000200062O00020048030100010004A53O004803012O00532O0100014O003F010200023O00122O000300A83O00122O000400A96O0002000400024O00010001000200202O0001000100124O0001000200024O000200103O00062O00020005000100010004A53O004C0301002E1201AA004C030100AB0004A53O004C0301002EA200AD005F030100AC0004A53O005F03012O00532O0100084O00C4000200013O00202O0002000200394O0003000A3O00202O0003000300224O000500013O00202O0005000500394O0003000500024O000300036O00010003000200062O0001005A030100010004A53O005A0301002EA300AE0007000100AF0004A53O005F03012O00532O0100023O001250000200B03O001250000300B14O0048000100034O00272O016O00532O0100014O001F010200023O00122O000300B23O00122O000400B36O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001008E03013O0004A53O008E03012O00532O01000C3O00065E0001008E03013O0004A53O008E03012O00532O0100043O00204C2O010001000F4O000300013O00202O0003000300444O0001000300024O000200016O000300023O00122O000400B43O00122O000500B56O0003000500024O00020002000300202O0002000200124O00020002000200062O0002008E030100010004A53O008E03012O00532O0100084O00C4000200013O00202O00020002002E4O0003000A3O00202O0003000300224O000500013O00202O00050005002E4O0003000500024O000300036O00010003000200062O00010089030100010004A53O00890301002E8000B7008E030100B60004A53O008E03012O00532O0100023O001250000200B83O001250000300B94O0048000100034O00272O015O002EA3000200C7030100020004A53O005507012O00532O0100014O001F010200023O00122O000300BA3O00122O000400BB6O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001005507013O0004A53O005507012O00532O0100203O00065E0001005507013O0004A53O005507012O00532O0100043O00204400010001000F4O000300013O00202O0003000300444O0001000300024O000200103O00062O00010055070100020004A53O005507012O00532O0100213O000E97003D0055070100010004A53O005507012O00532O0100084O00C4000200013O00202O0002000200BC4O0003000A3O00202O0003000300224O000500013O00202O0005000500BC4O0003000500024O000300036O00010003000200062O000100B6030100010004A53O00B60301002E8000BD0055070100BE0004A53O005507012O00532O0100023O001205000200BF3O00122O000300C06O000100036O00015O00044O0055070100265B3O00C2030100A20004A53O00C20301002E6901C100C2030100C20004A53O00C20301002EA300C3002C2O0100C40004A53O00EC0401002E8000C500E2030100C60004A53O00E203012O00532O0100014O001F010200023O00122O000300C73O00122O000400C86O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100E203013O0004A53O00E203012O00532O01000E3O00065E000100E203013O0004A53O00E203012O00532O01000D4O000C2O010001000200065E000100E203013O0004A53O00E203012O00532O01000A3O00209B00010001004A4O000300013O00202O0003000300C94O0001000300024O000200103O00102O0002004C000200062O000100E2030100020004A53O00E203012O00532O0100224O00530102001B3O00060C000100E4030100020004A53O00E40301002EA200CA00F5030100CB0004A53O00F503012O00532O0100084O0072010200013O00202O0002000200394O0003000A3O00202O0003000300224O000500013O00202O0005000500394O0003000500024O000300036O00010003000200062O000100F503013O0004A53O00F503012O00532O0100023O001250000200CC3O001250000300CD4O0048000100034O00272O015O002EA200CF0061040100CE0004A53O006104012O00532O0100014O001F010200023O00122O000300D03O00122O000400D16O0002000400024O00010001000200202O0001000100424O00010002000200062O0001004A04013O0004A53O004A04012O00532O01000F3O00065E0001004A04013O0004A53O004A04012O00532O0100043O00204F2O010001004500122O000300463O00122O000400036O00010004000200062O0001004A04013O0004A53O004A04012O00532O0100014O0072000200023O00122O000300D23O00122O000400D36O0002000400024O00010001000200202O0001000100D44O0001000200024O000200043O00202O00020002000F4O000400013O00202O0004000400444O00020004000200062O0001004A040100020004A53O004A04012O00532O0100234O006B000200246O000300043O00202O00030003000D4O000500013O00202O0005000500704O000300056O00023O00024O000300186O000300016O00013O00022O0053010200254O006B000300246O000400043O00202O00040004000D4O000600013O00202O0006000600704O000400066O00033O00024O000400186O000400016O00023O00022O00390001000100020026C90001004A040100030004A53O004A04012O00532O01000A3O00208800010001004A4O000300013O00202O00030003004B4O0001000300024O000200103O00102O0002004C000200062O0001004C040100020004A53O004C04012O00532O0100043O0020980001000100D54O000300013O00202O0003000300D64O000100030002000E2O003D004C040100010004A53O004C04012O00532O0100043O0020172O010001000D4O000300013O00202O0003000300D64O00010003000200062O0001004C040100010004A53O004C0401002E8000D70061040100D80004A53O006104012O00532O0100084O00C4000200013O00202O0002000200504O0003000A3O00202O0003000300224O000500013O00202O0005000500504O0003000500024O000300036O00010003000200062O0001005C040100010004A53O005C0401002E6901D9005C040100DA0004A53O005C0401002E8000DC0061040100DB0004A53O006104012O00532O0100023O001250000200DD3O001250000300DE4O0048000100034O00272O015O002E8000E0009B040100DF0004A53O009B04012O00532O0100014O001F010200023O00122O000300E13O00122O000400E26O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001009B04013O0004A53O009B04012O00532O01000C3O00065E0001009B04013O0004A53O009B04012O00532O0100043O00204C2O010001000F4O000300013O00202O0003000300444O0001000300024O000200016O000300023O00122O000400E33O00122O000500E46O0003000500024O00020002000300202O0002000200124O00020002000200062O0002009B040100010004A53O009B04012O00532O0100043O00206F2O010001000D4O000300013O00202O0003000300E54O00010003000200062O0001009B04013O0004A53O009B0401002EA300E6000E000100E60004A53O009404012O00532O0100084O00C4000200013O00202O00020002002E4O0003000A3O00202O0003000300224O000500013O00202O00050005002E4O0003000500024O000300036O00010003000200062O00010096040100010004A53O00960401002E8000E7009B040100E80004A53O009B04012O00532O0100023O001250000200E93O001250000300EA4O0048000100034O00272O016O00532O0100014O001F010200023O00122O000300EB3O00122O000400EC6O0002000400024O00010001000200202O0001000100424O00010002000200062O000100D404013O0004A53O00D404012O00532O01000F3O00065E000100D404013O0004A53O00D404012O00532O0100043O00201D00010001004500122O000300463O00122O000400036O00010004000200062O000100D4040100010004A53O00D404012O00532O0100014O00DC000200023O00122O000300ED3O00122O000400EE6O0002000400024O00010001000200202O0001000100854O00010002000200062O000100D4040100010004A53O00D404012O00532O0100014O0072000200023O00122O000300EF3O00122O000400F06O0002000400024O00010001000200202O0001000100D44O0001000200024O000200043O00202O00020002000F4O000400013O00202O0004000400444O00020004000200062O000100D4040100020004A53O00D404012O00532O0100244O00A4000200043O00202O00020002000D4O000400013O00202O0004000400704O000200046O00013O00024O000200186O0002000100024O00010001000200262O000100D8040100030004A53O00D80401002E6901F100D8040100F20004A53O00D80401002EA200F400EB040100F30004A53O00EB04012O00532O0100084O00C4000200013O00202O0002000200504O0003000A3O00202O0003000300224O000500013O00202O0005000500504O0003000500024O000300036O00010003000200062O000100E6040100010004A53O00E60401002EA300F50007000100F60004A53O00EB04012O00532O0100023O001250000200F73O001250000300F84O0048000100034O00272O015O0012503O00A33O00265B3O00F20401003C0004A53O00F20401002E6901F900F2040100FA0004A53O00F20401002E8000FC0045060100FB0004A53O00450601002EA200FE008C050100FD0004A53O008C05012O00532O0100014O001F010200023O00122O000300FF3O00122O00042O00015O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001008C05013O0004A53O008C05012O00532O0100263O00065E0001008C05013O0004A53O008C05012O00532O0100274O000C2O010001000200066A0001008C050100010004A53O008C05012O00532O0100283O00066A0001008C050100010004A53O008C05012O00532O01000D4O000C2O010001000200065E0001001D05013O0004A53O001D05012O00532O0100043O0020172O010001000B4O000300013O00202O0003000300394O00010003000200062O0001001D050100010004A53O001D05012O00532O01000A3O0020D400010001004A4O000300013O00202O0003000300C94O0001000300024O000200103O00122O0003004C6O00020003000200062O0002008C050100010004A53O008C05012O00532O0100043O0020172O01000100434O000300013O00202O00030003000E4O00010003000200062O0001002B050100010004A53O002B05012O00532O0100043O00206F2O010001000B4O000300013O00202O00030003001F4O00010003000200062O0001008C05013O0004A53O008C05012O00532O01001C3O00065E0001008C05013O0004A53O008C05012O00532O0100043O0020680001000100434O000300013O00122O0004002O015O0003000300044O00010003000200062O0001008C05013O0004A53O008C05012O00532O0100043O00206F2O01000100434O000300013O00202O00030003004D4O00010003000200062O0001008C05013O0004A53O008C05012O00532O0100234O007B000200186O0002000100024O000300246O000400043O00202O00040004000D4O000600013O00202O0006000600704O000400066O00033O00024O000400244O0053010500043O002O1200070002015O0005000500074O00050002000200122O000600013O00062O00060050050100050004A53O005005012O008600056O001D010500014O00240104000200024O0003000300044O0001000300024O000200256O000300186O0003000100024O000400246O000500043O00202O00050005000D4O000700013O00202O0007000700704O000500076O00043O00024O000500246O000600043O00122O00080002015O0006000600084O00060002000200122O000700013O00062O00070067050100060004A53O006705012O008600066O001D010600014O00300105000200024O0004000400054O0002000400024O00010001000200122O000200033O00062O0001008C050100020004A53O008C050100125000010003012O00125000020003012O0006262O01008C050100020004A53O008C050100125000010004012O00125000020005012O00063B2O01008C050100020004A53O008C05012O00532O0100084O00F8000200013O00122O00030006015O0002000200034O0003000A3O00202O0003000300224O000500013O00122O00060006015O0005000500064O0003000500024O000300036O000400046O000500016O00010005000200062O0001008C05013O0004A53O008C05012O00532O0100023O00125000020007012O00125000030008013O0048000100034O00272O015O00125000010009012O0012500002000A012O000679000100DA050100020004A53O00DA05010012500001000B012O0012500002000C012O000679000200DA050100010004A53O00DA05012O00532O015O00065E000100DA05013O0004A53O00DA05012O00532O0100014O001F010200023O00122O0003000D012O00122O0004000E015O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100DA05013O0004A53O00DA05012O00532O0100033O00065E000100DA05013O0004A53O00DA05012O00532O0100043O00206F2O010001000D4O000300013O00202O00030003004D4O00010003000200062O000100AF05013O0004A53O00AF05012O00532O0100064O00530102001B3O00062900020018000100010004A53O00C605012O00532O0100043O00206800010001000D4O000300013O00122O0004002O015O0003000300044O00010003000200062O000100DA05013O0004A53O00DA05012O00532O0100064O00BC0002001B6O000300246O000400016O000500023O00122O0006000F012O00122O00070010015O0005000700024O00040004000500202O0004000400854O000400056O00033O00024O00020002000300062O000200DA050100010004A53O00DA05012O00532O0100084O0073000200093O00202O0002000200184O0003000A3O00202O00030003001900122O0005001A6O0003000500024O000300036O00010003000200062O000100D5050100010004A53O00D5050100125000010011012O00125000020012012O0006262O0100DA050100020004A53O00DA05012O00532O0100023O00125000020013012O00125000030014013O0048000100034O00272O016O00532O0100014O001F010200023O00122O00030015012O00122O00040016015O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100EF05013O0004A53O00EF05012O00532O01000B3O00065E000100EF05013O0004A53O00EF05012O00532O0100043O0020382O010001000D4O000300013O00122O0004002O015O0003000300044O00010003000200062O000100F3050100010004A53O00F3050100125000010017012O00125000020018012O00063B0102000C060100010004A53O000C06012O00532O0100084O00C4000200013O00202O00020002001F4O0003000A3O00202O0003000300224O000500013O00202O00050005001F4O0003000500024O000300036O00010003000200062O00010007060100010004A53O0007060100125000010019012O0012500002001A012O00061600010007060100020004A53O000706010012500001001B012O0012500002001C012O00063B2O01000C060100020004A53O000C06012O00532O0100023O0012500002001D012O0012500003001E013O0048000100034O00272O015O0012500001001F012O0012500002001F012O0006262O010044060100020004A53O004406012O00532O0100014O001F010200023O00122O00030020012O00122O00040021015O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001002706013O0004A53O002706012O00532O01000B3O00065E0001002706013O0004A53O002706012O00532O0100043O00206F2O010001000D4O000300013O00202O00030003004D4O00010003000200062O0001002706013O0004A53O002706012O00532O01001C3O00066A0001002B060100010004A53O002B060100125000010022012O00125000020023012O00063B01020044060100010004A53O0044060100125000010024012O00125000020025012O00067900020044060100010004A53O004406012O00532O0100084O00C4000200013O00202O00020002001F4O0003000A3O00202O0003000300224O000500013O00202O00050005001F4O0003000500024O000300036O00010003000200062O0001003F060100010004A53O003F060100125000010026012O00125000020027012O0006262O010044060100020004A53O004406012O00532O0100023O00125000020028012O00125000030029013O0048000100034O00272O015O0012503O004C3O001250000100013O0006163O004C060100010004A53O004C06010012500001002A012O0012500002002B012O00067900010001000100020004A53O00010001001250000100013O0012500002002C012O0012500003002D012O00063B01030054060100020004A53O00540601001250000200013O00061600010058060100020004A53O005806010012500002002E012O0012500003002F012O00063B010200CE060100030004A53O00CE060100125000020030012O00125000030031012O00063B01020098060100030004A53O009806012O0053010200014O001F010300023O00122O00040032012O00122O00050033015O0003000500024O00020002000300202O0002000200424O00020002000200062O0002007906013O0004A53O007906012O0053010200293O00065E0002007906013O0004A53O007906012O00530102002A3O00065E0002006F06013O0004A53O006F06012O0053010200153O00066A00020072060100010004A53O007206012O00530102002A3O00066A00020079060100010004A53O007906012O0053010200164O0053010300173O00063B01020079060100030004A53O007906012O0053010200053O00066A0002007D060100010004A53O007D060100125000020034012O00125000030035012O00063B01020098060100030004A53O0098060100125000020036012O00125000030036012O0006260102008F060100030004A53O008F06012O0053010200084O002O010300013O00122O00040037015O0003000300044O0004000A3O00202O0004000400224O000600013O00122O00070037015O0006000600074O0004000600024O000400044O005001020004000200066A00020093060100010004A53O0093060100125000020038012O00125000030039012O00063B01020098060100030004A53O009806012O0053010200023O0012500003003A012O0012500004003B013O0048000200044O002701025O0012500002003C012O0012500003003D012O00063B010200B9060100030004A53O00B906012O0053010200014O001F010300023O00122O0004003E012O00122O0005003F015O0003000500024O00020002000300202O0002000200424O00020002000200062O000200B906013O0004A53O00B906012O0053010200293O00065E000200B906013O0004A53O00B906012O00530102002A3O00065E000200AF06013O0004A53O00AF06012O0053010200153O00066A000200B2060100010004A53O00B206012O00530102002A3O00066A000200B9060100010004A53O00B906012O0053010200164O0053010300173O00063B010200B9060100030004A53O00B906012O0053010200053O00066A000200BD060100010004A53O00BD060100125000020040012O00125000030041012O000626010200CD060100030004A53O00CD060100125000020042012O00125000030043012O00063B010300CD060100020004A53O00CD06012O0053010200084O00AC000300013O00122O00040044015O0003000300044O00020002000200062O000200CD06013O0004A53O00CD06012O0053010200023O00125000030045012O00125000040046013O0048000200044O002701025O0012500001003D3O00125000020047012O00125000030048012O00063B010200D5060100030004A53O00D506010012500002003D3O000616000100D9060100020004A53O00D9060100125000020049012O0012500003004A012O0006790003004A070100020004A53O004A07010012500002004B012O0012500003004B012O00062601020009070100030004A53O000907012O0053010200014O001F010300023O00122O0004004C012O00122O0005004D015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002000907013O0004A53O000907012O005301025O00065E0002000907013O0004A53O000907012O0053010200203O00065E0002000907013O0004A53O000907012O0053010200213O0012500003003D3O00063B01030009070100020004A53O000907012O0053010200053O00065E0002000907013O0004A53O000907010012500002004E012O00125000030048012O00067900020009070100030004A53O000907012O0053010200084O0072010300013O00202O0003000300BC4O0004000A3O00202O0004000400224O000600013O00202O0006000600BC4O0004000600024O000400046O00020004000200062O0002000907013O0004A53O000907012O0053010200023O0012500003004F012O00125000040050013O0048000200044O002701026O0053010200043O00203700020002000F4O000400013O00202O0004000400444O0002000400024O0003002B3O00062O0003001D070100020004A53O001D07012O0053010200173O00125000030051012O00060C0002001D070100030004A53O001D0701001250000200723O00125000030052012O00060C0003001D070100020004A53O001D070100125000020053012O00125000030054012O00063B01020049070100030004A53O00490701001250000200014O008D000300043O001250000500013O00061600020026070100050004A53O0026070100125000050055012O00125000060056012O00063B01050029070100060004A53O00290701001250000300014O008D000400043O0012500002003D3O0012500005003D3O0006260102001F070100050004A53O001F0701001250000500013O0006260103002C070100050004A53O002C0701001250000400013O001250000500013O00061600040037070100050004A53O0037070100125000050057012O00125000060058012O00063B01060030070100050004A53O003007012O00530105002C4O004B0005000100024O000500113O00122O00050059012O00122O0006005A012O00062O00050049070100060004A53O004907012O0053010500113O00065E0005004907013O0004A53O004907012O0053010500114O0009000500023O0004A53O004907010004A53O003007010004A53O004907010004A53O002C07010004A53O004907010004A53O001F0701001250000100033O0012500002005B012O0012500003005C012O00063B0102004D060100030004A53O004D0601001250000200033O0006262O01004D060100020004A53O004D06010012503O003D3O0004A53O000100010004A53O004D06010004A53O000100012O0048012O00017O00493O00028O00025O00CEAC40025O00488740026O00F03F025O00349D40025O0024B340025O0048A740025O00ECA340025O00608A40025O00B2AA40025O00C49B40025O00E0A940027O0040025O00489240025O00A49D40025O00A88340025O0092AD40025O00C08B40025O0080874003103O003B4C077401570E4C2A550C4C1B50075803043O003F683969030B3O004973417661696C61626C6503083O0042752O66446F776E03143O00467572796F6674686553756E4B696E6742752O6603093O0042752O66537461636B03143O0053756E4B696E6773426C652O73696E6742752O66026O000840030B3O0042752O6652656D61696E73030E3O00436F6D62757374696F6E42752O66025O004EA540025O00AEA240030B3O002D8EB6411893A5561F82B603043O00246BE7C4029A5O99C93F029A5O99D93F03083O0076BCAC8351BCAC8003043O00E73DD5C2026O005E40026O003440025O0022A840025O006EAF40025O001EAF40025O009C9440025O00BC9840025O00ACAA40026O006C40025O00DAA840030A3O000E3BA8DE63BCC38F223A03083O00E64D54C5BC16CFB7030F3O00432O6F6C646F776E52656D61696E7303083O00DF1DD4F98EA0FC3903083O00559974A69CECC19003083O004361737454696D65030B3O0082EC4CBEE113B0F244B8E103063O0060C4802DD384025O005EAD40025O006C9440025O00F2B240025O00989640025O00409440025O00C09B40025O0040A840025O00E88F40025O00409340025O0072A940025O000C9140025O00FAA240030B3O001384695AC1BBB5CA21886903083O00B855ED1B3FB2CFD4025O00389740025O00B8AE40025O00C09840025O004CB1400033012O0012503O00014O008D000100023O00265B3O0006000100010004A53O00060001002EA300020005000100030004A53O00090001001250000100014O008D000200023O0012503O00043O00265B3O000F000100040004A53O000F0001002E690105000F000100060004A53O000F0001002E8000070002000100080004A53O00020001002E800009000F0001000A0004A53O000F000100265B00010015000100010004A53O00150001002E80000C000F0001000B0004A53O000F0001001250000200013O00265B0002001A0001000D0004A53O001A0001002EA2000F005B0001000E0004A53O005B0001001250000300013O000E512O010056000100030004A53O00560001001250000400013O0026D800040022000100040004A53O00220001001250000300043O0004A53O00560001002E800010001E000100110004A53O001E0001002E800013001E000100120004A53O001E00010026D80004001E000100010004A53O001E00012O005301056O001F010600013O00122O000700143O00122O000800156O0006000800024O00050005000600202O0005000500164O00050002000200062O0005004B00013O0004A53O004B00012O0053010500024O000C01050001000200065E0005004B00013O0004A53O004B00012O0053010500033O00206F0105000500174O00075O00202O0007000700184O00050007000200062O0005004B00013O0004A53O004B00012O0053010500054O00D3000600066O000700033O00202O0007000700194O00095O00202O00090009001A4O0007000900024O00060006000700202O00060006001B4O000700076O0006000600074O000700046O0005000700024O000500044O0053010500054O0035010600033O00202O00060006001C4O00085O00202O00080008001D4O0006000800024O000700046O0005000700024O000500043O00122O000400043O00044O001E00010026D80003001B000100040004A53O001B00010012500002001B3O0004A53O005B00010004A53O001B0001002E80001F00850001001E0004A53O008500010026D8000200850001001B0004A53O008500012O0053010300084O008A000400096O00058O000600013O00122O000700203O00122O000800216O0006000800024O00050005000600202O0005000500164O000500066O00043O00020010B400040022000400100D0004002300044O000500096O00068O000700013O00122O000800243O00122O000900256O0007000900024O00060006000700202O0006000600164O000600074O007600053O00022O002F01040004000500102O00040004000400102O0004002600044O0003000300044O000400043O00062O00030006000100040004A53O008200012O0053010300044O00530104000A3O00207101040004002700063B010400322O0100030004A53O00322O012O0053010300084O00DB000300043O0004A53O00322O0100265B0002008B000100010004A53O008B0001002EE10029008B000100280004A53O008B0001002EA3002A00780001002B0004A53O003O01001250000300014O008D000400043O0026D80003008D000100010004A53O008D0001001250000400013O002EA2002C00F60001002D0004A53O00F600010026D8000400F6000100010004A53O00F60001001250000500013O0026D800050099000100040004A53O00990001001250000400043O0004A53O00F60001002E80002E00950001002F0004A53O009500010026D800050095000100010004A53O009500012O005301066O00C6000700013O00122O000800303O00122O000900316O0007000900024O00060006000700202O0006000600324O0006000200024O0007000B6O0006000600074O000600086O0006000D6O00078O000800013O00122O000900333O00122O000A00346O0008000A00024O00070007000800202O0007000700354O0007000200024O000800096O0009000E6O000A000F3O00062O000900B70001000A0004A53O00B700012O008600096O001D010900014O00020008000200024O0007000700084O00088O000900013O00122O000A00363O00122O000B00376O0009000B00024O00080008000900202O0008000800354O0008000200024O000900096O000A000E6O000B000F3O00062O000B00020001000A0004A53O00C800012O0086000A6O001D010A00014O006C0109000200024O0008000800094O0006000800024O000700106O00088O000900013O00122O000A00333O00122O000B00346O0009000B00024O00080008000900202O0008000800354O0008000200024O000900096O000A000E6O000B000F3O00062O000A00DB0001000B0004A53O00DB00012O0086000A6O001D010A00014O00020009000200024O0008000800094O00098O000A00013O00122O000B00363O00122O000C00376O000A000C00024O00090009000A00202O0009000900354O0009000200024O000A00096O000B000E6O000C000F3O00062O000C00020001000B0004A53O00EC00012O0086000B6O001D010B00014O00CC000A000200024O00090009000A4O0007000900024O0006000600074O000700116O0006000600074O0006000C3O00122O000500043O00044O00950001002EA200390090000100380004A53O0090000100265B000400FC000100040004A53O00FC0001002EA3003A0096FF2O003B0004A53O00900001001250000200043O0004A53O003O010004A53O009000010004A53O003O010004A53O008D000100265B000200052O0100040004A53O00052O01002E80003D00160001003C0004A53O00160001001250000300013O000E7D0001000C2O0100030004A53O000C2O01002E69013E000C2O01003F0004A53O000C2O01002E80004100242O0100400004A53O00242O012O0053010400084O00DB000400043O002EA2004200232O0100430004A53O00232O012O005301046O001F010500013O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400164O00040002000200062O000400232O013O0004A53O00232O012O0053010400123O00066A000400232O0100010004A53O00232O012O0053010400054O00F2000500136O0005000100024O000600046O0004000600024O000400043O001250000300043O002EA2004600062O0100470004A53O00062O01002EA2004800062O0100490004A53O00062O010026D8000300062O0100040004A53O00062O010012500002000D3O0004A53O001600010004A53O00062O010004A53O001600010004A53O00322O010004A53O000F00010004A53O00322O010004A53O000200012O0048012O00017O002D3O00028O00025O00208440025O00A0844003093O002FA42F762BA13C601D03043O001369CD5D03073O004973526561647903083O0042752O66446F776E030D3O00486F7453747265616B42752O6603063O0042752O665570030D3O0048656174696E67557042752O66026O00F03F030D3O009A00D7872BA006D9B130BE0DCC03053O005FC968BEE1030A3O00432O6F6C646F776E557003093O0089C2D3CB8DC7C0DDBB03043O00AECFABA103073O0043686172676573030B3O0042752O6652656D61696E73030F3O00462O656C7468654275726E42752O66027O0040025O00309240025O009C9040025O00CEB140025O00F07F40025O00B09440025O00209E4003093O0046697265426C617374030E3O0049735370652O6C496E52616E676503243O00EBF71FF6C7D5E1FF1EE7B8D1E4EC08E0ECD6FFEA08E1C7D1E4EC08CCFADBECED19E0B88503063O00B78D9E6D939803093O000A00F4090E05E71F3803043O006C4C6986030D3O00D8CDB8E7DAE2CBB6D1C1FCC0A303053O00AE8BA5D18103073O0048617354696572026O003E40030D3O00446562752O6652656D61696E7303143O004368612O72696E67456D62657273446562752O66025O003CA840026O005F40025O0060A140025O00207F40025O0015B24003243O00A5BAF0C4F9017C79B0A7A2C7CF11756BB7B2F0D5C3114F7EAAA1E7FEC40F716BB7A0A29503083O0018C3D382A1A6631000CB3O0012503O00014O008D000100013O002EA200020002000100030004A53O000200010026D83O0002000100010004A53O00020001001250000100013O0026D800010007000100010004A53O000700012O005301026O001F010300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O0002005A00013O0004A53O005A00012O0053010200023O00065E0002005A00013O0004A53O005A00012O0053010200034O000C01020001000200066A0002005A000100010004A53O005A00012O0053010200043O00066A0002005A000100010004A53O005A00012O0053010200053O00206F0102000200074O00045O00202O0004000400084O00020004000200062O0002005A00013O0004A53O005A00012O0053010200064O001F000300076O000400053O00202O0004000400094O00065O00202O00060006000A4O000400066O00033O00024O000400086O000400016O00023O00024O000300096O000400076O000500053O00202O0005000500094O00075O00202O00070007000A4O000500076O00043O00024O000500086O000500016O00033O00024O00020002000300262O0002005A0001000B0004A53O005A00012O005301026O00DC000300013O00122O0004000C3O00122O0005000D6O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002005C000100010004A53O005C00012O005301026O00FB000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200114O000200020002000E2O000B005C000100020004A53O005C00012O0053010200053O0020880002000200124O00045O00202O0004000400134O0002000400024O0003000A3O00102O00030014000300062O0002005C000100030004A53O005C0001002EA200150073000100160004A53O00730001002E8000180073000100170004A53O00730001002EA2001900730001001A0004A53O007300012O00530102000B4O001C00035O00202O00030003001B4O0004000C3O00202O00040004001C4O00065O00202O00060006001B4O0004000600024O000400046O000500056O000600016O00020006000200062O0002007300013O0004A53O007300012O0053010200013O0012500003001D3O0012500004001E4O0048000200044O002701026O005301026O001F010300013O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O0002000200064O00020002000200062O000200AD00013O0004A53O00AD00012O0053010200023O00065E000200AD00013O0004A53O00AD00012O0053010200034O000C01020001000200066A000200AD000100010004A53O00AD00012O0053010200043O00066A000200AD000100010004A53O00AD00012O0053010200074O0026000300053O00202O0003000300094O00055O00202O00050005000A4O000300056O00023O00024O000300086O0003000100024O00020002000300262O000200AD0001000B0004A53O00AD00012O005301026O001F010300013O00122O000400213O00122O000500226O0003000500024O00020002000300202O00020002000E4O00020002000200062O000200AD00013O0004A53O00AD00012O0053010200053O00204F01020002002300122O000400243O00122O000500146O00020005000200062O000200AF00013O0004A53O00AF00012O00530102000C3O0020880002000200254O00045O00202O0004000400264O0002000400024O0003000A3O00102O00030014000300062O000300AF000100020004A53O00AF0001002EA2002700CA000100280004A53O00CA0001002EA2002A00CA000100290004A53O00CA0001002EA3002B00190001002B0004A53O00CA00012O00530102000B4O001C00035O00202O00030003001B4O0004000C3O00202O00040004001C4O00065O00202O00060006001B4O0004000600024O000400046O000500056O000600016O00020006000200062O000200CA00013O0004A53O00CA00012O0053010200013O0012050003002C3O00122O0004002D6O000200046O00025O00044O00CA00010004A53O000700010004A53O00CA00010004A53O000200012O0048012O00017O000B012O00028O00025O00BEA640025O007AAE40026O00F03F025O00B88440025O00FEA640026O000840025O00B07740025O00349540025O005CA040025O0008A240030D3O00D825A64A7CB5D99EE42CA44A6103083O00D8884DC92F12DCA1030A3O0049734361737461626C6503103O000CE02EC21BC8902CFF31DB1BFA973FF503073O00E24D8C4BBA68BC030B3O004973417661696C61626C6503083O0042752O66446F776E030D3O00486F7453747265616B42752O6603063O0042752O665570030E3O00466C616D65734675727942752O66030D3O0050686F656E6978466C616D6573030E3O0049735370652O6C496E52616E676503233O00A9C6DF3A41B0D6EF3943B8C3D52C0FAADAD1314BB8DCD4005DB6DAD12B46B6C0906D1B03053O002FD9AEB05F026O001040025O00C49540025O00A07640025O00D09640030D3O00383415450A04E52E301B4D011E03073O009D685C7A20646D03073O0048617354696572026O003E40027O0040030D3O00446562752O6652656D61696E7303143O004368612O72696E67456D62657273446562752O66025O0078AB40025O00409540025O00249240025O00288240025O00889D40025O00C05E4003233O00B3AEC0CF332E9594A5AACEC73834CDB8B7A7C1CE3C358994B1A9DBCB292E82A5E3F49E03083O00CBC3C6AFAA5D47ED03063O001D4831C7521903073O009C4E2B5EB5317103073O0049735265616479030B3O00446562752O66537461636B03143O00496D70726F76656453636F726368446562752O6603063O0053636F726368025O004C9A40025O0002A840025O00EAAF40031B3O0061EBCBB1084B3961FCC5AD0F426B76D7D6AC1F426D7BE7CAE3591103073O00191288A4C36B23025O00E5B140025O00E6AC40026O001440025O00089E40025O00DAA440025O00B08840025O00BAAF40030D3O009DA1A61887FDE39BA1A21E9CFB03073O0090D9D3C77FE89303103O00D9233B30C6511045EB353F3BF350105D03083O0024984F5E48B52562030D3O00447261676F6E73427265617468025O00406040025O00A0A94003233O00D3CA4638D8D65400D5CA423EC3D0072CC3D9493BD6CA4300C5D7533EC3D14831978A1F03043O005FB7B82703063O00863CE834578803073O0062D55F874634E0025O0042B340025O005DB040025O00308540025O00B07140025O003C9240025O00449740025O0024B340025O00E2A240031B3O00EDA0C66557F6E3DA6355F0A7C86550C1B1C66355EAAAC67914ADF303053O00349EC3A917025O00609740025O008BB240025O00B0AF40025O00F08440030F3O005BAE317588305E936AB03D678F3A7503083O00EB1ADC5214E6551B030F3O004D616E6150657263656E7461676550025O00907440025O00E07C40030F3O00417263616E654578706C6F73696F6E03093O004973496E52616E6765025O001EA740025O0050A04003253O0089B3EAC37A8D9EECDA6484AEFACB7B86E1FAD67586A5E8D070B7B3E6D6759CA8E6CC34DBF303053O0014E8C189A2026O001840025O00BAA640025O005C9E40025O00A6A940025O00F49040025O00B88740025O0018B040025O00406940025O00EEA740030B3O00600FE82156055211E0275603063O00762663894C33025O00D0744003113O00466C616D65737472696B65437572736F72026O004440025O000C9940025O00FCB140031F3O00FB2A041F0C33E9340C190C60EE32041C0D21EF223A000634FC320C1D0760AF03063O00409D4665726903093O0070B1B5EC124CA9B4F703053O007020C8C783025O0040A440025O00E8984003093O005079726F626C617374031D3O003C494EB7C1A7233F441CABD7AA2C28514EBCFCB92D385148B1CCA5627803073O00424C303CD8A3CB030B3O009C8A78FE5ADD30A88F72F603073O0044DAE619933FAE03093O00497343617374696E67030B3O00466C616D65737472696B6503143O00467572796F6674686553756E4B696E6742752O6603203O00AB265241B3BE3E4145BDA86A4058B7A32E525EB292385C58B7B9235C42F6FC7803053O00D6CD4A332C025O0026A140025O0084B340025O00108D40025O00508940025O00B2A140025O00A09040025O00BAAC40025O0038B040030D3O0088D57907BC5D6000B4DC7B07A103083O0046D8BD1662D2341803103O00FBD3A69FC0CECDA294C9DBCC8592C1C303053O00B3BABFC3E7030D3O00C93717E1F73600C2F53E15E1EA03043O0084995F7803113O00436861726765734672616374696F6E616C026O000440030D3O0081BA0128F9D3B897BE0F20F2C903073O00C0D1D26E4D97BA026O00F83F030B3O00C60627E5EBCCE52137FBF103063O00A4806342899F030B3O0042752O6652656D61696E73030F3O00462O656C7468654275726E42752O66025O00BAB240025O0014A54003233O001081E6BB0E80F1810685E8B3059AA9AD1488E7BA019BED811286FDBF1480E6B040DBBF03043O00DE60E989025O008C9340025O002CA440025O00588140025O00388140025O00507040025O003AAE4003063O00C94FEDEE74F203053O00179A2C829C03093O00212OBFA1341F10B5B903063O007371C6CDCE5603083O004361737454696D65025O00E07440025O00D4A740025O00F6A840025O0063B140031B3O009754F148875FBE499056F05E8545FA659658EA5B905EF154C406AD03043O003AE4379E03093O008490C2213EA134A79D03073O0055D4E9B04E5CCD025O000DB240026O002A40025O008AAC40025O00C7B240025O006CA640026O009940031E3O005A419AED485489F15E189BF64B568CE3585CB7F0454C89F6435786A21B0C03043O00822A38E803093O00CCBC36E66233EBA63003063O005F8AD544832003083O004669726562612O6C03083O000C21B346742B24AD03053O00164A48C123030E3O004578656375746552656D61696E73026O00E03F030C3O000460F45D3E6DEC5D3E74ED5903043O00384C198403093O006ED8B929CD52C0B83203053O00AF3EA1CB46030C3O0014C4D3162728D5C6013835DC03053O00555CBDA373030D3O0048656174696E67557042752O6603093O000FA5223D0BA0312B3D03043O005849CC5003103O0046752O6C526563686172676554696D65025O004CAA40025O004EAC4003093O0046697265426C617374025O0087B040025O00889240031F3O00288A024316D82282035269C93A821E4228C82ABC02493DDB3A8A1F48698B7803063O00BA4EE3702649030D3O00DEB5F7864CD0F69BF4824FDCFD03063O00B98EDD98E32203103O0079C952E25027E559D64DFB5015E24ADC03073O009738A5379A2353030B3O00864600E2B44B00CCB5510B03043O008EC02365025O0010B240025O00049E40025O00BEAD40025O0018834003233O00C67D26A6E985B429D07928AEE29FEC05C27427A7E69EA829C47A3DA2F385A31896277903083O0076B61549C387ECCC03093O00CC4EEF5A5176FD44E903063O001A9C379D353303083O005072657647434450025O00789F40031E3O009CC104D6BA5C8DCB0299AB448DD612D8AA54B3CA19CDB94485D71899E90803063O0030ECB876B9D803063O00D6BE5822CC3C03063O005485DD3750AF025O0030A840025O0049B240031B3O00AEE42BB4C454FDF430A7C958BCF52099D553A9E630AFC852FDB67D03063O003CDD8744C6A7030B3O0004D3C4ABE29F03632BD4C003083O001142BFA5C687EC77025O00149A40025O0064984003203O0009A3AF1EFAFBF8C306A4AB53ECFCEDDF0BAEBC17C0FAE3C50EBBA71CF1A8BF8503083O00B16FCFCE739F888C03093O003590021BD6435E169D03073O003F65E97074B42F030E3O00F73EE002FD24C63FCB1EF93BC62803063O0056A35B8D729803133O00466C616D65412O63656C6572616E7442752O66025O0020AF40025O0046A240025O00D49540025O00D8AF40025O00C2A940025O0052B240031E3O004312667C385F0A2O677A401F757D3E5219704C285C1F7567335C0534206F03053O005A336B1413025O007CA540025O00A2A840025O00807840025O00B8A94003083O00ABF997EA3F8CFC8903053O005DED90E58F025O00C05D40025O00B3B140025O00406D40025O00A07C40031D3O0013FFE21C094719FAB00A1F471BF2F10B0F7907F9E4181F4F1AF8B04A5D03063O0026759690796B025O00DEB140025O00888440025O0056A340025O002EAE400018052O0012503O00014O008D000100023O002EA200020008050100030004A53O000805010026D83O0008050100040004A53O00080501002E8000050006000100060004A53O000600010026D800010006000100010004A53O00060001001250000200013O0026D8000200D0000100070004A53O00D00001001250000300014O008D000400043O002EA200080013000100090004A53O0013000100265B00030015000100010004A53O00150001002EA2000B000F0001000A0004A53O000F0001001250000400013O0026D800040053000100040004A53O005300012O005301056O001F010600013O00122O0007000C3O00122O0008000D6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005005100013O0004A53O005100012O0053010500023O00065E0005005100013O0004A53O005100012O005301056O00DC000600013O00122O0007000F3O00122O000800106O0006000800024O00050005000600202O0005000500114O00050002000200062O00050051000100010004A53O005100012O0053010500033O00206F0105000500124O00075O00202O0007000700134O00050007000200062O0005005100013O0004A53O005100012O0053010500043O00066A00050051000100010004A53O005100012O0053010500033O00206F0105000500144O00075O00202O0007000700154O00050007000200062O0005005100013O0004A53O005100012O0053010500054O007201065O00202O0006000600164O000700063O00202O0007000700174O00095O00202O0009000900164O0007000900024O000700076O00050007000200062O0005005100013O0004A53O005100012O0053010500013O001250000600183O001250000700194O0048000500074O002701055O0012500002001A3O0004A53O00D00001000E7D00010057000100040004A53O00570001002E80001B00160001001C0004A53O00160001001250000500013O002EA3001D006E0001001D0004A53O00C600010026D8000500C6000100010004A53O00C600012O005301066O001F010700013O00122O0008001E3O00122O0009001F6O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006008000013O0004A53O008000012O0053010600023O00065E0006008000013O0004A53O008000012O0053010600033O00204F01060006002000122O000800213O00122O000900226O00060009000200062O0006008000013O0004A53O008000012O0053010600063O00209B0006000600234O00085O00202O0008000800244O0006000800024O000700073O00102O00070022000700062O00060080000100070004A53O008000012O0053010600033O0020170106000600124O00085O00202O0008000800134O00060008000200062O00060082000100010004A53O00820001002E8000250097000100260004A53O00970001002E8000280097000100270004A53O009700012O0053010600054O00C400075O00202O0007000700164O000800063O00202O0008000800174O000A5O00202O000A000A00164O0008000A00024O000800086O00060008000200062O00060092000100010004A53O00920001002E80002900970001002A0004A53O009700012O0053010600013O0012500007002B3O0012500008002C4O0048000600084O002701066O005301066O001F010700013O00122O0008002D3O00122O0009002E6O0007000900024O00060006000700202O00060006002F4O00060002000200062O000600C500013O0004A53O00C500012O0053010600083O00065E000600C500013O0004A53O00C500012O0053010600094O000C01060001000200065E000600C500013O0004A53O00C500012O0053010600063O0020440006000600304O00085O00202O0008000800314O0006000800024O0007000A3O00062O000600C5000100070004A53O00C500012O0053010600054O00C400075O00202O0007000700324O000800063O00202O0008000800174O000A5O00202O000A000A00324O0008000A00024O000800086O00060008000200062O000600C0000100010004A53O00C00001002E12013400C0000100330004A53O00C00001002EA2003500C50001001B0004A53O00C500012O0053010600013O001250000700363O001250000800374O0048000600084O002701065O001250000500043O00265B000500CA000100040004A53O00CA0001002E8000380058000100390004A53O00580001001250000400043O0004A53O001600010004A53O005800010004A53O001600010004A53O00D000010004A53O000F000100265B000200D40001003A0004A53O00D40001002E80003C006D2O01003B0004A53O006D2O01001250000300013O0026D8000300382O0100010004A53O00382O01001250000400013O002E80003D00312O01003E0004A53O00312O010026D8000400312O0100010004A53O00312O012O00530105000B3O00065E000500062O013O0004A53O00062O012O005301056O001F010600013O00122O0007003F3O00122O000800406O0006000800024O00050005000600202O00050005002F4O00050002000200062O000500062O013O0004A53O00062O012O00530105000C3O00065E000500062O013O0004A53O00062O012O00530105000D3O000E97000400062O0100050004A53O00062O012O005301056O001F010600013O00122O000700413O00122O000800426O0006000800024O00050005000600202O0005000500114O00050002000200062O000500062O013O0004A53O00062O012O0053010500054O005301065O00209C0006000600432O005F01050002000200066A0005003O0100010004A53O003O01002EA300440007000100450004A53O00062O012O0053010500013O001250000600463O001250000700474O0048000500074O002701056O005301056O001F010600013O00122O000700483O00122O000800496O0006000800024O00050005000600202O00050005002F4O00050002000200062O000500172O013O0004A53O00172O012O0053010500083O00065E000500172O013O0004A53O00172O012O00530105000E4O000C01050001000200066A0005001B2O0100010004A53O001B2O01002E12014A001B2O01004B0004A53O001B2O01002E80004C00302O01004D0004A53O00302O01002EA2004E00292O01004F0004A53O00292O012O0053010500054O00C400065O00202O0006000600324O000700063O00202O0007000700174O00095O00202O0009000900324O0007000900024O000700076O00050007000200062O0005002B2O0100010004A53O002B2O01002E80005000302O0100510004A53O00302O012O0053010500013O001250000600523O001250000700534O0048000500074O002701055O001250000400043O002E80005400D8000100550004A53O00D800010026D8000400D8000100040004A53O00D80001001250000300043O0004A53O00382O010004A53O00D80001000E51010400D5000100030004A53O00D50001002E800057006A2O0100560004A53O006A2O012O00530104000B3O00065E0004006A2O013O0004A53O006A2O012O005301046O001F010500013O00122O000600583O00122O000700596O0005000700024O00040004000500202O00040004002F4O00040002000200062O0004006A2O013O0004A53O006A2O012O00530104000F3O00065E0004006A2O013O0004A53O006A2O012O0053010400104O0053010500113O0006790005006A2O0100040004A53O006A2O012O0053010400033O00205300040004005A2O005F0104000200022O0053010500123O0006790005006A2O0100040004A53O006A2O01002EA2005B00632O01005C0004A53O00632O012O0053010400054O007300055O00202O00050005005D4O000600063O00202O00060006005E00122O000800216O0006000800024O000600066O00040006000200062O000400652O0100010004A53O00652O01002EA3005F0007000100600004A53O006A2O012O0053010400013O001250000500613O001250000600624O0048000400064O002701045O001250000200633O0004A53O006D2O010004A53O00D50001002E8000650003020100640004A53O00030201002EA200670003020100660004A53O000302010026D800020003020100010004A53O00030201001250000300013O00265B000300782O0100010004A53O00782O01002EA2006900CC2O0100680004A53O00CC2O01002EA2006A00A62O01006B0004A53O00A62O012O00530104000B3O00065E000400A62O013O0004A53O00A62O012O005301046O001F010500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004002F4O00040002000200062O000400A62O013O0004A53O00A62O012O0053010400133O00065E000400A62O013O0004A53O00A62O012O0053010400144O0053010500153O000679000500A62O0100040004A53O00A62O012O0053010400164O000C01040001000200065E000400A62O013O0004A53O00A62O01002EA3006E00140001006E0004A53O00A62O012O0053010400054O0073000500173O00202O00050005006F4O000600063O00202O00060006005E00122O000800706O0006000800024O000600066O00040006000200062O000400A12O0100010004A53O00A12O01002EA2007200A62O0100710004A53O00A62O012O0053010400013O001250000500733O001250000600744O0048000400064O002701046O005301046O001F010500013O00122O000600753O00122O000700766O0005000700024O00040004000500202O00040004002F4O00040002000200062O000400B72O013O0004A53O00B72O012O0053010400183O00065E000400B72O013O0004A53O00B72O012O0053010400164O000C01040001000200066A000400B92O0100010004A53O00B92O01002E80007700CB2O0100780004A53O00CB2O012O0053010400054O005501055O00202O0005000500794O000600063O00202O0006000600174O00085O00202O0008000800794O0006000800024O000600066O000700016O00040007000200065E000400CB2O013O0004A53O00CB2O012O0053010400013O0012500005007A3O0012500006007B4O0048000400064O002701045O001250000300043O0026D8000300742O0100040004A53O00742O012O00530104000B3O00065E00042O0002013O0004A54O0002012O005301046O001F010500013O00122O0006007C3O00122O0007007D6O0005000700024O00040004000500202O00040004002F4O00040002000200062O00042O0002013O0004A54O0002012O0053010400133O00065E00042O0002013O0004A54O0002012O0053010400033O00201701040004007E4O00065O00202O00060006007F4O00040006000200062O00042O00020100010004A54O0002012O0053010400144O0053010500193O00067900052O00020100040004A54O0002012O0053010400033O00206F0104000400144O00065O00202O0006000600804O00040006000200062O00042O0002013O0004A54O0002012O0053010400054O0060000500173O00202O00050005006F4O000600063O00202O00060006005E00122O000800706O0006000800024O000600066O00040006000200062O00042O0002013O0004A54O0002012O0053010400013O001250000500813O001250000600824O0048000400064O002701045O001250000200043O0004A53O000302010004A53O00742O010026D80002008E0201001A0004A53O008E0201001250000300014O008D000400043O00265B0003000B020100010004A53O000B0201002E8000840007020100830004A53O00070201001250000400013O00265B00040012020100010004A53O00120201002E1201850012020100860004A53O00120201002E800087007E020100880004A53O007E0201002E800089007A0201008A0004A53O007A02012O005301056O001F010600013O00122O0007008B3O00122O0008008C6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005007A02013O0004A53O007A02012O0053010500023O00065E0005007A02013O0004A53O007A02012O005301056O001F010600013O00122O0007008D3O00122O0008008E6O0006000800024O00050005000600202O0005000500114O00050002000200062O0005007A02013O0004A53O007A02012O0053010500033O00206F0105000500124O00075O00202O0007000700134O00050007000200062O0005007A02013O0004A53O007A02012O00530105001A4O000C0105000100020026D80005007A020100010004A53O007A02012O0053010500043O00066A00050040020100010004A53O004002012O0053010500033O0020170105000500144O00075O00202O0007000700154O00050007000200062O00050067020100010004A53O006702012O005301056O00FB000600013O00122O0007008F3O00122O000800906O0006000800024O00050005000600202O0005000500914O000500020002000E2O00920067020100050004A53O006702012O005301056O00C2000600013O00122O000700933O00122O000800946O0006000800024O00050005000600202O0005000500914O000500020002000E970095007A020100050004A53O007A02012O005301056O001F010600013O00122O000700963O00122O000800976O0006000800024O00050005000600202O0005000500114O00050002000200062O0005006702013O0004A53O006702012O0053010500033O00209B0005000500984O00075O00202O0007000700994O0005000700024O000600073O00102O00060007000600062O0005007A020100060004A53O007A02012O0053010500054O00C400065O00202O0006000600164O000700063O00202O0007000700174O00095O00202O0009000900164O0007000900024O000700076O00050007000200062O00050075020100010004A53O00750201002EA2009A007A0201009B0004A53O007A02012O0053010500013O0012500006009C3O0012500007009D4O0048000500074O002701056O00530105001C4O000C0105000100022O00DB0005001B3O001250000400043O002EA2009E000C0201009F0004A53O000C02010026D80004000C020100040004A53O000C02012O00530105001B3O00066A00050087020100010004A53O00870201002E8000A00089020100A10004A53O008902012O00530105001B4O0009000500023O0012500002003A3O0004A53O008E02010004A53O000C02010004A53O008E02010004A53O00070201002EA200A200C0030100A30004A53O00C003010026D8000200C0030100040004A53O00C003012O005301036O001F010400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400202O00030003002F4O00030002000200062O000300C302013O0004A53O00C302012O0053010300083O00065E000300C302013O0004A53O00C302012O0053010300094O000C01030001000200065E000300C302013O0004A53O00C302012O0053010300063O0020C10003000300234O00055O00202O0005000500314O0003000500024O00048O000500013O00122O000600A63O00122O000700A76O0005000700024O0004000400050020530004000400A82O007E0004000200024O000500073O00102O0005003A00054O00040004000500062O000300C3020100040004A53O00C302012O0053010300033O00206F0103000300144O00055O00202O0005000500804O00030005000200062O000300C302013O0004A53O00C302012O0053010300033O00206F01030003007E4O00055O00202O0005000500324O00030005000200062O000300C702013O0004A53O00C70201002EE100AA00C7020100A90004A53O00C70201002EA200AC00D8020100AB0004A53O00D802012O0053010300054O007201045O00202O0004000400324O000500063O00202O0005000500174O00075O00202O0007000700324O0005000700024O000500056O00030005000200062O000300D802013O0004A53O00D802012O0053010300013O001250000400AD3O001250000500AE4O0048000300054O002701036O005301036O001F010400013O00122O000500AF3O00122O000600B06O0004000600024O00030003000400202O00030003002F4O00030002000200062O000300F302013O0004A53O00F302012O0053010300183O00065E000300F302013O0004A53O00F302012O0053010300033O00201701030003007E4O00055O00202O0005000500794O00030005000200062O000300F3020100010004A53O00F302012O0053010300033O0020170103000300144O00055O00202O0005000500804O00030005000200062O000300F5020100010004A53O00F50201002EA300B10018000100B20004A53O000B0301002E8000B30004030100B40004A53O000403012O0053010300054O00AE00045O00202O0004000400794O000500063O00202O0005000500174O00075O00202O0007000700794O0005000700024O000500056O000600016O00030006000200062O00030006030100010004A53O00060301002EA300B50007000100B60004A53O000B03012O0053010300013O001250000400B73O001250000500B84O0048000300054O002701036O005301036O001F010400013O00122O000500B93O00122O000600BA6O0004000600024O00030003000400202O00030003002F4O00030002000200062O000300BF03013O0004A53O00BF03012O00530103001D3O00065E000300BF03013O0004A53O00BF03012O0053010300164O000C01030001000200066A000300BF030100010004A53O00BF03012O00530103001E4O000C01030001000200066A000300BF030100010004A53O00BF03012O00530103001F3O00066A000300BF030100010004A53O00BF03012O0053010300033O00206F0103000300124O00055O00202O0005000500804O00030005000200062O000300BF03013O0004A53O00BF03012O0053010300033O00206F01030003007E4O00055O00202O0005000500BB4O00030005000200062O0003004503013O0004A53O004503012O005301036O00BB000400013O00122O000500BC3O00122O000600BD6O0004000600024O00030003000400202O0003000300BE4O00030002000200262O00030060030100BF0004A53O006003012O005301036O001F010400013O00122O000500C03O00122O000600C16O0004000600024O00030003000400202O0003000300114O00030002000200062O0003006003013O0004A53O006003012O0053010300033O00206F01030003007E4O00055O00202O0005000500794O00030005000200062O0003006703013O0004A53O006703012O005301036O00BB000400013O00122O000500C23O00122O000600C36O0004000600024O00030003000400202O0003000300BE4O00030002000200262O00030060030100BF0004A53O006003012O005301036O00DC000400013O00122O000500C43O00122O000600C56O0004000600024O00030003000400202O0003000300114O00030002000200062O00030067030100010004A53O006703012O0053010300033O0020170103000300144O00055O00202O0005000500C64O00030005000200062O000300A8030100010004A53O00A803012O00530103000E4O000C01030001000200065E000300BF03013O0004A53O00BF03012O0053010300094O000C01030001000200065E0003008103013O0004A53O008103012O0053010300063O00205F0003000300304O00055O00202O0005000500314O0003000500024O0004000A3O00062O00030081030100040004A53O008103012O005301036O00B3000400013O00122O000500C73O00122O000600C86O0004000600024O00030003000400202O0003000300C94O00030002000200262O000300BF030100070004A53O00BF03012O0053010300033O00206F0103000300144O00055O00202O0005000500C64O00030005000200062O0003008F03013O0004A53O008F03012O0053010300033O00206F01030003007E4O00055O00202O0005000500324O00030005000200062O000300A803013O0004A53O00A803012O0053010300033O00206F0103000300124O00055O00202O0005000500134O00030005000200062O000300BF03013O0004A53O00BF03012O0053010300033O00206F0103000300124O00055O00202O0005000500C64O00030005000200062O000300BF03013O0004A53O00BF03012O0053010300033O00206F01030003007E4O00055O00202O0005000500324O00030005000200062O000300BF03013O0004A53O00BF03012O00530103001A4O000C0103000100020026D8000300BF030100010004A53O00BF0301002E8000CA00B8030100CB0004A53O00B803012O0053010300054O008900045O00202O0004000400CC4O000500063O00202O0005000500174O00075O00202O0007000700CC4O0005000700024O000500056O000600066O000700016O00030007000200062O000300BA030100010004A53O00BA0301002EA200CD00BF030100CE0004A53O00BF03012O0053010300013O001250000400CF3O001250000500D04O0048000300054O002701035O001250000200223O0026D800020076040100220004A53O00760401001250000300013O0026D800030006040100040004A53O000604012O005301046O001F010500013O00122O000600D13O00122O000700D26O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004002O04013O0004A53O002O04012O0053010400023O00065E0004002O04013O0004A53O002O04012O005301046O001F010500013O00122O000600D33O00122O000700D46O0005000700024O00040004000500202O0004000400114O00040002000200062O0004002O04013O0004A53O002O04012O005301046O001F010500013O00122O000600D53O00122O000700D66O0005000700024O00040004000500202O0004000400114O00040002000200062O000400EF03013O0004A53O00EF03012O0053010400033O00209B0004000400984O00065O00202O0006000600994O0004000600024O000500073O00102O00050022000500062O0004002O040100050004A53O002O04012O0053010400054O00C400055O00202O0005000500164O000600063O00202O0006000600174O00085O00202O0008000800164O0006000800024O000600066O00040006000200062O000400FF030100010004A53O00FF0301002E6901D700FF030100D80004A53O00FF0301002EA200D9002O040100DA0004A53O002O04012O0053010400013O001250000500DB3O001250000600DC4O0048000400064O002701045O001250000200073O0004A53O00760401000E512O0100C3030100030004A53O00C303012O005301046O001F010500013O00122O000600DD3O00122O000700DE6O0005000700024O00040004000500202O00040004002F4O00040002000200062O0004003304013O0004A53O003304012O0053010400183O00065E0004003304013O0004A53O003304012O0053010400033O00201701040004007E4O00065O00202O0006000600324O00040006000200062O00040024040100010004A53O002404012O0053010400033O0020230104000400DF00122O000600046O00075O00202O0007000700324O00040007000200062O0004003304013O0004A53O003304012O0053010400033O00206F0104000400144O00065O00202O0006000600C64O00040006000200062O0004003304013O0004A53O003304012O00530104000E4O000C01040001000200065E0004003304013O0004A53O003304012O0053010400144O0053010500153O00060C00040035040100050004A53O00350401002EA200600047040100E00004A53O004704012O0053010400054O005501055O00202O0005000500794O000600063O00202O0006000600174O00085O00202O0008000800794O0006000800024O000600066O000700016O00040007000200065E0004004704013O0004A53O004704012O0053010400013O001250000500E13O001250000600E24O0048000400064O002701046O005301046O001F010500013O00122O000600E33O00122O000700E46O0005000700024O00040004000500202O00040004002F4O00040002000200062O0004007404013O0004A53O007404012O0053010400083O00065E0004007404013O0004A53O007404012O0053010400094O000C01040001000200065E0004007404013O0004A53O007404012O0053010400063O00209B0004000400234O00065O00202O0006000600314O0004000600024O000500073O00102O0005001A000500062O00040074040100050004A53O00740401002EA200E50074040100E60004A53O007404012O0053010400054O007201055O00202O0005000500324O000600063O00202O0006000600174O00085O00202O0008000800324O0006000800024O000600066O00040006000200062O0004007404013O0004A53O007404012O0053010400013O001250000500E73O001250000600E84O0048000400064O002701045O001250000300043O0004A53O00C30301000E510163000B000100020004A53O000B00012O00530103000B3O00065E0003009E04013O0004A53O009E04012O005301036O001F010400013O00122O000500E93O00122O000600EA6O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003009E04013O0004A53O009E04012O0053010300133O00065E0003009E04013O0004A53O009E04012O0053010300144O0053010400203O0006790004009E040100030004A53O009E0401002EA200EC009E040100EB0004A53O009E04012O0053010300054O0060000400173O00202O00040004006F4O000500063O00202O00050005005E00122O000700706O0005000700024O000500056O00030005000200062O0003009E04013O0004A53O009E04012O0053010300013O001250000400ED3O001250000500EE4O0048000300054O002701036O005301036O001F010400013O00122O000500EF3O00122O000600F06O0004000600024O00030003000400202O00030003002F4O00030002000200062O000300BC04013O0004A53O00BC04012O0053010300183O00065E000300BC04013O0004A53O00BC04012O005301036O001F010400013O00122O000500F13O00122O000600F26O0004000600024O00030003000400202O0003000300114O00030002000200062O000300BC04013O0004A53O00BC04012O0053010300033O0020170103000300124O00055O00202O0005000500F34O00030005000200062O000300BE040100010004A53O00BE0401002EA200F400D4040100F50004A53O00D40401002EA200F600D4040100F70004A53O00D404012O0053010300054O00AE00045O00202O0004000400794O000500063O00202O0005000500174O00075O00202O0007000700794O0005000700024O000500056O000600016O00030006000200062O000300CF040100010004A53O00CF0401002EA200F900D4040100F80004A53O00D404012O0053010300013O001250000400FA3O001250000500FB4O0048000300054O002701035O002EA200FC0017050100FD0004A53O00170501002E8000FE0017050100FF0004A53O001705012O005301036O001F010400013O00122O00052O00012O00122O0006002O015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003001705013O0004A53O001705012O0053010300213O00065E0003001705013O0004A53O001705012O0053010300164O000C01030001000200066A00030017050100010004A53O001705012O0053010300054O00AE00045O00202O0004000400BB4O000500063O00202O0005000500174O00075O00202O0007000700BB4O0005000700024O000500056O000600016O00030006000200062O000300FE040100010004A53O00FE040100125000030002012O00125000040003012O00062900040005000100030004A53O00FE040100125000030004012O00125000040005012O00062601030017050100040004A53O001705012O0053010300013O00120500040006012O00122O00050007015O000300056O00035O00044O001705010004A53O000B00010004A53O001705010004A53O000600010004A53O0017050100125000030008012O00125000040009012O00067900040002000100030004A53O00020001001250000300013O0006163O0013050100030004A53O001305010012500003000A012O0012500004000B012O00063B01040002000100030004A53O00020001001250000100014O008D000200023O0012503O00043O0004A53O000200012O0048012O00017O00CF3O00028O00025O001AA140025O00F49A40026O00084003093O002449FFF6204CECE01603043O009362208D03073O004973526561647903093O00497343617374696E67030D3O005368696674696E67506F77657203093O003E4AF1CF245A4A0B5703073O002B782383AA663603103O0046752O6C526563686172676554696D65025O001EA940025O00D4914003093O0046697265426C617374030E3O0049735370652O6C496E52616E6765025O00D09840025O0008AD4003123O00520F95B39AB288551593F6A8B18D5A46D6E003073O00E43466E7D6C5D0025O00D49A40025O009AAA40026O00F03F025O00207940025O00BAA340025O00805D40025O00609D40025O0040A940025O00089140025O003AB240025O00349140025O0032A940025O00D09C4003073O0037E370E4E59D1803083O00B67E8015AA8AEB79030A3O0049734361737461626C65030A3O005573654963654E6F766103073O004963654E6F7661025O0044A540025O00A5B240025O0062A840025O00FAA04003103O0082D930D9881C2607CBD734EF8853615E03083O0066EBBA5586E67350025O005C9B40025O00F0774003063O00640F314D71DC03073O0042376C5E3F12B4025O00C09340025O0083B04003063O0053636F726368030E3O00078E8A2524515480843E291946DD03063O003974EDE55747025O0066AB40025O00D0A740027O0040025O00208E40025O00F5B140025O004CA540025O00E49E40025O0026A34003083O0019B2E33F1ABAFC2A03043O005A4DDB8E03123O00426C2O6F646C757374457868617573745570030C3O00D2012C2943157BEA33202B5C03073O001A866441592C67030B3O004973417661696C61626C65026O00444003083O0054696D655761727003093O004973496E52616E6765025O00D4B040025O000FB240025O0022A240025O0010794003213O00E5EA3D269BE6E22233E4F2EC3D21B1E2F7392CAACEE03F2CA8F5EC272DB7B1B26203053O00C491835043025O0092A140025O00108140025O0020A540025O0072AC40025O005AAD40025O0096A240025O00408B40025O006C9A40025O0016AB40025O0028A340025O00C07040025O0044B340030D3O002DB80F0E0CE110B736070FED0C03063O00887ED0666878030F3O00432O6F6C646F776E52656D61696E73025O00A49740025O00C89D40025O0058A840025O00F3B24003103O0075DEFDC275E141D8D1E579FC55C2FDEE03063O008F26AB93891C025O00B5B040025O00D09540025O0096B140025O005EAC4003093O00F68BABF621EFD5C39603073O00B4B0E2D9936383030D3O00E0B12601C7B02100E3B63802C103043O0067B3D94F03093O006CBE0ED06380A259A303073O00C32AD77CB521EC03073O0043686172676573030D3O00446562752O6652656D61696E7303143O00496D70726F76656453636F726368446562752O66030D3O003E513E3831F1035E073132FD1F03063O00986D39575E4503083O004361737454696D6503063O00CAD405B1BDDA03083O00C899B76AC3DEB23403083O0042752O66446F776E03143O00467572796F6674686553756E4B696E6742752O66030D3O00486F7453747265616B42752O66025O00405F40025O0052AE40025O0054B040025O00E0764003163O0021EB813B5D533CE4B72D464D37F1C83048533CA3D96F03063O003A5283E85D2903093O005E83DC468D5E3C426C03083O003118EAAE23CF325D03113O00436861726765734672616374696F6E616C03093O002AFBEF8D5300F3EE9C03053O00116C929DE803083O00432O6F6C646F776E03093O006DCA06E80DA44AD00003063O00C82BA3748D4F030A3O004D61784368617267657303093O00993F2F8692F8E2AC2203073O0083DF565DE3D09403093O00C54CA4B33FB9E256A203063O00D583252OD67D026O002840030A3O00052428BDF4353F2CB0EF03053O0081464B45DF025O00A06240025O0086B140025O0033B240025O00F89040025O00C06040025O00E2A240025O007CAA40025O00EC9C40025O0014AD40025O001AA440025O00308440025O00349040025O001CAC40025O0034AD40025O00B88940025O00988C4003093O00F3C2E4AA81FA7DACC103083O00DFB5AB96CFC3961C03063O0042752O665570030D3O0048656174696E67557042752O66030B3O006A36E2A30C5F2EF1A7024903053O00692C5A83CE030E3O004578656375746552656D61696E73026O00E03F03093O00D9E9A0BC2A32FEF3A603063O005E9F80D2D96803123O0056F014BA607DF57B43ED46B25E76F73A01AD03083O001A309966DF3F1F99025O0062B340025O000DB140025O00188440025O00449740025O00B07D40025O004FB040025O0079B140025O00EAA940025O00209140025O00D89B40025O0072A240025O00B89840025O00C4A540025O00405E40025O00A09D40025O00FEA540025O004CA740025O0085B040025O006AA04003103O00B042DE3E54318444F219582C905EDE1203063O005FE337B0753D026O001C40030D3O0028762C4EA511660547AA157B3003053O00CB781E432B030D3O00C12D42EAD7F83D6BE3D8FC205E03053O00B991452D8F03103O00AB131CBECF9E0D18B5C68B0C3FB3CE9303053O00BCEA7F79C6025O00D6AA40025O0014A040025O0058A24003103O000B271DA8313C14901A3E16902B3B1D8403043O00E3585273030D3O007317B5A20C7A5B39B6A60F765003063O0013237FDAC76203103O003DF70FFA0FEF18E30FE10BF13AEE18FB03043O00827C9B6A025O0092AB40025O007C9B4000D6032O0012503O00013O002E80000300B6000100020004A53O00B600010026D83O00B6000100040004A53O00B600012O00532O016O001F010200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002800013O0004A53O002800012O00532O0100023O00065E0001002800013O0004A53O002800012O00532O0100034O000C2O010001000200066A00010028000100010004A53O002800012O00532O0100043O00206F2O01000100084O00035O00202O0003000300094O00010003000200062O0001002800013O0004A53O002800012O00532O016O0062000200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O0001000200024O000200053O00062O0001002A000100020004A53O002A0001002EA2000D003F0001000E0004A53O003F00012O00532O0100064O008900025O00202O00020002000F4O000300073O00202O0003000300104O00055O00202O00050005000F4O0003000500024O000300036O000400046O000500016O00010005000200062O0001003A000100010004A53O003A0001002EA300110007000100120004A53O003F00012O00532O0100013O001250000200133O001250000300144O0048000100034O00272O016O00532O0100083O000E970001006B000100010004A53O006B00012O00532O0100093O00065E0001006B00013O0004A53O006B0001001250000100014O008D000200033O002EA20015004E000100160004A53O004E00010026D80001004E000100010004A53O004E0001001250000200014O008D000300033O001250000100173O00265B00010052000100170004A53O00520001002EA200190047000100180004A53O0047000100265B00020056000100010004A53O00560001002EA3001A00FEFF2O001B0004A53O00520001001250000300013O000E512O010057000100030004A53O005700012O00530104000B4O000C0104000100022O00DB0004000A3O002EA2001D00610001001C0004A53O006100012O00530104000A3O00066A00040063000100010004A53O00630001002E80001E006B0001001F0004A53O006B00012O00530104000A4O0009000400023O0004A53O006B00010004A53O005700010004A53O006B00010004A53O005200010004A53O006B00010004A53O00470001002EA200210093000100200004A53O009300012O00532O016O001F010200013O00122O000300223O00122O000400236O0002000400024O00010001000200202O0001000100244O00010002000200062O0001009300013O0004A53O0093000100124E2O0100253O00065E0001009300013O0004A53O009300012O00532O01000C4O000C2O010001000200066A00010093000100010004A53O009300012O00532O0100064O00C400025O00202O0002000200264O000300073O00202O0003000300104O00055O00202O0005000500264O0003000500024O000300036O00010003000200062O0001008E000100010004A53O008E0001002E120128008E000100270004A53O008E0001002E80002900930001002A0004A53O009300012O00532O0100013O0012500002002B3O0012500003002C4O0048000100034O00272O015O002EA2002E00D50301002D0004A53O00D503012O00532O016O001F010200013O00122O0003002F3O00122O000400306O0002000400024O00010001000200202O0001000100074O00010002000200062O000100D503013O0004A53O00D503012O00532O01000D3O00065E000100D503013O0004A53O00D50301002EA2003100D5030100320004A53O00D503012O00532O0100064O007201025O00202O0002000200334O000300073O00202O0003000300104O00055O00202O0005000500334O0003000500024O000300036O00010003000200062O000100D503013O0004A53O00D503012O00532O0100013O001205000200343O00122O000300356O000100036O00015O00044O00D503010026D83O00522O0100010004A53O00522O01001250000100013O002EA2003700BF000100360004A53O00BF00010026D8000100BF000100380004A53O00BF00010012503O00173O0004A53O00522O01002EA300390048000100390004A53O00072O010026D8000100072O0100010004A53O00072O012O00530102000E3O00065E000200CA00013O0004A53O00CA0001002E69013A00CA0001003B0004A53O00CA0001002E80003D00CC0001003C0004A53O00CC00012O00530102000F4O005D0002000100012O0053010200103O00065E000200062O013O0004A53O00062O012O0053010200113O00065E000200062O013O0004A53O00062O012O005301026O001F010300013O00122O0004003E3O00122O0005003F6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200062O013O0004A53O00062O012O0053010200043O0020530002000200402O005F01020002000200065E000200062O013O0004A53O00062O012O005301026O001F010300013O00122O000400413O00122O000500426O0003000500024O00020002000300202O0002000200434O00020002000200062O000200062O013O0004A53O00062O012O0053010200124O000C01020001000200066A000200F2000100010004A53O00F200012O0053010200133O0026C9000200062O0100440004A53O00062O012O0053010200064O007300035O00202O0003000300454O000400073O00202O00040004004600122O000600446O0004000600024O000400046O00020004000200062O0002003O0100010004A53O003O01002E690147003O0100480004A53O003O01002E80004900062O01004A0004A53O00062O012O0053010200013O0012500003004B3O0012500004004C4O0048000200044O002701025O001250000100173O002EA2004E00B90001004D0004A53O00B900010026D8000100B9000100170004A53O00B90001001250000200013O0026D80002004A2O0100010004A53O004A2O01002E80004F003B2O0100500004A53O003B2O012O0053010300144O0053010400133O00063B0103003B2O0100040004A53O003B2O012O0053010300153O00065E000300202O013O0004A53O00202O012O0053010300103O00065E0003001D2O013O0004A53O001D2O012O0053010300163O00066A000300222O0100010004A53O00222O012O0053010300163O00065E000300222O013O0004A53O00222O01002EA20051003B2O0100520004A53O003B2O01001250000300014O008D000400043O00265B000300282O0100010004A53O00282O01002EA2005400242O0100530004A53O00242O01001250000400013O00265B0004002D2O0100010004A53O002D2O01002EA2005500292O0100560004A53O00292O012O0053010500174O000C0105000100022O00DB0005000A4O00530105000A3O00066A000500352O0100010004A53O00352O01002EA20058003B2O0100570004A53O003B2O012O00530105000A4O0009000500023O0004A53O003B2O010004A53O00292O010004A53O003B2O010004A53O00242O012O0053010300084O002001048O000500013O00122O000600593O00122O0007005A6O0005000700024O00040004000500202O00040004005B4O00040002000200062O000400472O0100030004A53O00472O012O008600036O001D010300014O00DB000300183O001250000200173O000E7D0017004E2O0100020004A53O004E2O01002E80005D000C2O01005C0004A53O000C2O01001250000100383O0004A53O00B900010004A53O000C2O010004A53O00B90001002E80005E00A70201005F0004A53O00A70201000E51011700A702013O0004A53O00A70201001250000100014O008D000200023O0026D8000100582O0100010004A53O00582O01001250000200013O0026D8000200EE2O0100170004A53O00EE2O012O0053010300193O00066A0003006A2O0100010004A53O006A2O012O005301036O00DC000400013O00122O000500603O00122O000600616O0004000600024O00030003000400202O0003000300434O00030002000200062O0003006E2O0100010004A53O006E2O01002E120162006E2O0100630004A53O006E2O01002EA300640015000100650004A53O00812O012O00530103000C4O000C01030001000200065E000300802O013O0004A53O00802O012O005301036O00C2000400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O00030003000C4O0003000200022O00530104001A3O0010B400040004000400060C0004007F2O0100030004A53O007F2O012O008600036O001D010300014O00DB000300194O005301036O001F010400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O0003000300074O00030002000200062O000300D82O013O0004A53O00D82O012O0053010300103O00065E000300912O013O0004A53O00912O012O00530103001B3O00066A000300942O0100010004A53O00942O012O00530103001B3O00066A000300D82O0100010004A53O00D82O012O00530103001C3O00065E000300D82O013O0004A53O00D82O012O0053010300144O0053010400133O00063B010300D82O0100040004A53O00D82O012O0053010300093O00065E000300D82O013O0004A53O00D82O012O005301036O0032010400013O00122O0005006A3O00122O0006006B6O0004000600024O00030003000400202O00030003006C4O00030002000200262O000300AB2O0100010004A53O00AB2O012O0053010300193O00065E000300D82O013O0004A53O00D82O012O00530103001D4O000C01030001000200065E000300CE2O013O0004A53O00CE2O012O0053010300073O0020C100030003006D4O00055O00202O00050005006E4O0003000500024O00048O000500013O00122O0006006F3O00122O000700706O0005000700024O0004000400050020530004000400712O00850004000200024O00058O000600013O00122O000700723O00122O000800736O0006000800024O00050005000600202O0005000500714O0005000200024O00040004000500063B010400D82O0100030004A53O00D82O012O0053010300043O00206F0103000300744O00055O00202O0005000500754O00030005000200062O000300D82O013O0004A53O00D82O012O0053010300043O00206F0103000300744O00055O00202O0005000500764O00030005000200062O000300D82O013O0004A53O00D82O012O0053010300183O00066A000300DA2O0100010004A53O00DA2O01002E80007800ED2O0100770004A53O00ED2O012O0053010300064O001B01045O00202O0004000400094O000500073O00202O00050005004600122O000700446O0005000700024O000500056O000600016O00030006000200062O000300E82O0100010004A53O00E82O01002E80007900ED2O01007A0004A53O00ED2O012O0053010300013O0012500004007B3O0012500005007C4O0048000300054O002701035O001250000200383O0026D80002009C020100010004A53O009C02012O0053010300093O00065E0003006702013O0004A53O006702012O00530103001E4O009200048O000500013O00122O0006007D3O00122O0007007E6O0005000700024O00040004000500202O00040004007F4O0004000200024O000500086O0006001F6O0006000100024O000700206O000800186O0007000200024O0006000600074O0005000500064O00068O000700013O00122O000800803O00122O000900816O0007000900024O00060006000700202O0006000600824O0006000200024O0005000500064O0003000500024O000400216O00058O000600013O00122O0007007D3O00122O0008007E6O0006000800024O00050005000600202O00050005007F4O0005000200024O000600086O0007001F6O0007000100024O000800206O000900186O0008000200024O0007000700084O0006000600074O00078O000800013O00122O000900803O00122O000A00816O0008000A00024O00070007000800202O0007000700824O0007000200024O0006000600074O0004000600024O00030003000400202O0003000300174O0004001E6O00058O000600013O00122O000700833O00122O000800846O0006000800024O00050005000600202O0005000500854O0005000200024O000600226O00078O000800013O00122O000900863O00122O000A00876O0008000A00024O00070007000800202O0007000700824O0007000200024O0006000600074O0004000600024O000500216O00068O000700013O00122O000800833O00122O000900844O002C0007000900024O00060006000700202O0006000600854O0006000200024O000700226O00088O000900013O00122O000A00863O00122O000B00876O0009000B00022O00DF0008000800090020830008000800824O0008000200024O0007000700084O0005000700024O0004000400054O00058O000600013O00122O000700883O00122O000800896O0006000800022O00DF0005000500060020BF0005000500824O00050002000200102O0005008A000500202O0005000500174O00040004000500062O00030065020100040004A53O006502012O0053010300084O0053010400133O00060C00030066020100040004A53O006602012O008600036O001D010300014O00DB000300194O00530103000E3O00066A00030080020100010004A53O008002012O0053010300083O0026D200030084020100010004A53O008402012O0053010300233O00066A00030084020100010004A53O008402012O0053010300084O0053010400243O00063B01030080020100040004A53O008002012O005301036O0062000400013O00122O0005008B3O00122O0006008C6O0004000600024O00030003000400202O00030003005B4O0003000200024O000400243O00062O00030084020100040004A53O00840201002E12018E00840201008D0004A53O00840201002EA3008F0019000100900004A53O009B0201001250000300014O008D000400043O00265B0003008A020100010004A53O008A0201002E8000920086020100910004A53O00860201001250000400013O0026D80004008B020100010004A53O008B02012O0053010500254O000C0105000100022O00DB0005000A4O00530105000A3O00066A00050095020100010004A53O00950201002EA20093009B020100940004A53O009B02012O00530105000A4O0009000500023O0004A53O009B02010004A53O008B02010004A53O009B02010004A53O00860201001250000200173O002E800096005B2O0100950004A53O005B2O01002EA20097005B2O0100980004A53O005B2O01000E510138005B2O0100020004A53O005B2O010012503O00383O0004A53O00A702010004A53O005B2O010004A53O00A702010004A53O00582O01002E80009900010001009A0004A53O000100010026D83O0001000100380004A53O00010001001250000100013O000E7D001700B0020100010004A53O00B00201002E80009C002A0301009B0004A53O002A03012O005301026O001F010300013O00122O0004009D3O00122O0005009E6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002000403013O0004A53O000403012O0053010200023O00065E0002000403013O0004A53O000403012O0053010200034O000C01020001000200066A00020004030100010004A53O000403012O0053010200193O00066A00020004030100010004A53O000403012O0053010200083O000E9700010004030100020004A53O000403012O0053010200264O0053010300273O00067900030004030100020004A53O000403012O0053010200124O000C01020001000200066A00020004030100010004A53O000403012O0053010200043O00206F0102000200744O00045O00202O0004000400764O00020004000200062O0002000403013O0004A53O000403012O0053010200043O00206F01020002009F4O00045O00202O0004000400A04O00020004000200062O000200E702013O0004A53O00E702012O005301026O00BB000300013O00122O000400A13O00122O000500A26O0003000500024O00020002000300202O0002000200A34O00020002000200262O000200F1020100A40004A53O00F102012O005301026O00C2000300013O00122O000400A53O00122O000500A66O0003000500024O00020002000300202O00020002007F4O000200020002002O0E01380004030100020004A53O000403012O0053010200064O001C00035O00202O00030003000F4O000400073O00202O0004000400104O00065O00202O00060006000F4O0004000600024O000400046O000500056O000600016O00020006000200062O0002000403013O0004A53O000403012O0053010200013O001250000300A73O001250000400A84O0048000200044O002701026O0053010200093O00065E0002000E03013O0004A53O000E03012O0053010200124O000C01020001000200065E0002000E03013O0004A53O000E03012O0053010200083O000EA700010010030100020004A53O00100301002E8000A90029030100AA0004A53O00290301001250000200014O008D000300033O00265B00020016030100010004A53O00160301002E8000AC0012030100AB0004A53O00120301001250000300013O00265B0003001D030100010004A53O001D0301002E6901AD001D030100AE0004A53O001D0301002E8000AF0017030100B00004A53O001703012O0053010400284O000C0104000100022O00DB0004000A4O00530104000A3O00065E0004002903013O0004A53O002903012O00530104000A4O0009000400023O0004A53O002903010004A53O001703010004A53O002903010004A53O00120301001250000100383O002E8000B10030030100B20004A53O003003010026D800010030030100380004A53O003003010012503O00043O0004A53O00010001002EA200B400AC020100B30004A53O00AC020100265B00010036030100010004A53O00360301002EA200B500AC020100B60004A53O00AC0201001250000200013O002E8000B7003B030100B80004A53O003B030100265B0002003D030100010004A53O003D0301002E8000BA00CC030100B90004A53O00CC0301002EA300BB0007000100BB0004A53O004403012O0053010300264O0053010400293O00067900040044030100030004A53O004403010004A53O009603012O005301036O00DC000400013O00122O000500BC3O00122O000600BD6O0004000600024O00030003000400202O0003000300434O00030002000200062O00030089030100010004A53O008903012O00530103001E4O00BD000400083O00122O000500BE6O0003000500024O000400216O000500083O00122O000600BE6O0004000600024O0003000300044O0004001E6O00056O00C2000600013O00122O000700BF3O00122O000800C06O0006000800024O00050005000600202O00050005000C4O0005000200022O00F900068O000700013O00122O000800C13O00122O000900C26O0007000900024O00060006000700202O0006000600824O000600076O00043O00024O000500214O005301066O00C2000700013O00122O000800BF3O00122O000900C06O0007000900024O00060006000700202O00060006000C4O0006000200022O005301076O0053010800013O001250000900C13O001250000A00C24O00500108000A00022O00DF0007000700080020530007000700822O004A010700084O007600053O00022O00130104000400054O0005001F6O0005000100024O000600206O000700186O0006000200024O0005000500064O00040004000500062O00030093030100040004A53O009303012O0053010300084O0053010400133O00063B01030093030100040004A53O009303012O005301036O0036000400013O00122O000500C33O00122O000600C46O0004000600024O00030003000400202O0003000300434O0003000200024O000300033O00044O009503012O008600036O001D010300014O00DB0003002A3O002EA300C50035000100C50004A53O00CB03012O0053010300264O0053010400293O00062900040003000100030004A53O009E0301002EA300C6002F000100C70004A53O00CB03012O005301036O00DC000400013O00122O000500C83O00122O000600C96O0004000600024O00030003000400202O0003000300434O00030002000200062O000300BE030100010004A53O00BE03012O0053010300084O006801048O000500013O00122O000600CA3O00122O000700CB6O0005000700024O00040004000500202O00040004000C4O0004000200024O0005001F6O0005000100024O000600206O000700186O0006000200024O0005000500064O00040004000500062O000300C8030100040004A53O00C803012O0053010300084O0053010400133O00063B010300C8030100040004A53O00C803012O005301036O0036000400013O00122O000500CC3O00122O000600CD6O0004000600024O00030003000400202O0003000300434O0003000200024O000300033O00044O00CA03012O008600036O001D010300014O00DB0003002A3O001250000200173O00265B000200D0030100170004A53O00D00301002E8000CE0037030100CF0004A53O00370301001250000100173O0004A53O00AC02010004A53O003703010004A53O00AC02010004A53O000100012O0048012O00017O00E23O00028O00025O0019B140025O00709440026O001440026O00F03F025O00607640025O00649D40025O007FB040025O00A6A040030C3O004570696353652O74696E677303083O000FFAF7D0D5AD3F2F03073O00585C9F83A4BCC3030E3O00953DBA66D6F8CEA22FAD59DEEECF03073O00BDE04EDF2BB78B03083O001DF99E02C820FB9903053O00A14E9CEA76030E3O00B2A4CCF1AEA5DBD3B59EC4DDA0B203043O00BCC7D7A9025O00B8AC40025O00C8A140027O0040025O00B89240025O0077B240025O004C9F40025O00A6A54003083O00D5FA9EB7D8E8F89903053O00B1869FEAC3030B3O00A8F83A89CAB8C933AFCAB603053O00A9DD8B5FC003083O00ED8E6B2O2B28D99803063O0046BEEB1F5F42030A3O00AFF11FCFE6BFC115EAE103053O0085DA827A86026O001840025O004EA440025O0080A240025O0020AA40025O0066B240026O000840025O0099B240025O008AA540025O0054A04003083O00F7C85328FB00F2D703073O0095A4AD275C926E03103O00E634152F1214F62919073C17F22A150C03063O007B9347707F7A03083O00FFC896654FC2CA9103053O0026ACADE211030C3O00580229DF540323ED41103FFB03043O008F2D714C03083O008BBD0828B1B61B2F03043O005C2OD87C03093O004E21A973FE5420AF4803053O009D3B52CC2003083O000B3BF7EEE0E4D4A203083O00D1585E839A898AB3030F3O003DB2C15F11363F362DB3D76C1B2F3D03083O004248C1A41C7E4351025O00907D40025O00FDB040025O0022AC40025O000EA740025O00B08640025O003C984003083O001BDE499647712FC803063O001F48BB3DE22E030B3O00D61546F44E6C21C1074FDE03073O0044A36623B2271E03083O008D75CED30ABB840203083O0071DE10BAA763D5E3030E3O003B1DFED0220FF6F33D1AE9FF250B03043O00964E6E9B03083O00B6C033F5AD10B85303083O0020E5A54781C47EDF030D3O00D69AC1AD88C3CA87C3A38ED8C103063O00B5A3E9A42OE103083O00638E2A635985396403043O001730EB5E03093O0069C9DD705227D773C803073O00B21CBAB83D3753025O0040A040025O0014B040026O001C40025O00A8A240025O00689E40025O00688940025O00606A4003083O006EE9509E54E2439903043O00EA3D8C2403093O0028DEBF51002DD9924203053O006F41BDDA1203083O00704E0F210252A85003073O00CF232B7B556B3C030D3O007DA3B2F8766283ADEB7E75829003053O001910CAC08A025O00508F40026O002040025O00B49740025O00B2AF4003083O002OCEB9F6A02OFAD803063O00949DABCD82C9030D3O002ED5673AF3F731C67D2CC3DE1303063O009643B41449B103083O00BE1D0E5984161D5E03043O002DED787A03153O00DAE1B03ED8FA8B21D6EFA70ED2EEAD3ED2D8B720DB03043O004CB788C2025O00ACAB40025O006FB240026O001040025O00A3B240025O0050A94003083O002419DB4AC1D7BD0403073O00DA777CAF3EA8B903113O00B0E34DE6A9F152CDABF76AC5B7E241C1B703043O00A4C5902803083O00B0F5BE9FD4B884E303063O00D6E390CAEBBD03163O00F8B6825C02B65228E8B7AE7506BA4035EFAC8B7204AA03083O005C8DC5E71B70D333025O00689D40025O00805840025O00CAB040025O00C9B040025O0034A140025O0068B340025O0063B240025O00B0AB40025O008EA040025O00FAAE4003083O0079FBB656782F4DED03063O00412A9EC2221103133O00092F5B0A39E415E92A2845093FDA12FA12047603083O008E7A47326C4D8D7B03083O0026A7EB0C321BA5EC03053O005B75C29F78030C3O000F0E3B2O39E521082937153003073O00447A7D5E785591025O00407840025O00E0644003083O00D429BC4C2F78E03F03063O0016874CC83846030C3O009823FD0651E09E24CF254BE403063O0081ED5098443D03083O0062AD10E715195F4203073O003831C864937C77030D3O00D92DBAD3C333BDE5DF2AB6FFC203043O0090AC5EDF03083O00170AB6532D01A55403043O0027446FC203103O00C3B5E2F471BED0B2EEC97E87D9B1E2D503063O00D7B6C687A71903083O00BE4CFE5C8447ED5B03043O0028ED298A03103O00C47BF7FA5FD460F3F744F07DEEF069E303053O002AA7149A98025O00788440025O0002A940025O0072B340025O0050A440025O00809C40025O0070994003083O001327F9B1F086E9FA03083O008940428DC599E88E03153O0004C227A79C06C20BA89E0AC32BA4810FD936BFA03303053O00E863B042C603083O00DF243C127283FE3F03083O004C8C4148661BED99030A3O0043D913F0DB0EBD41F22603073O00DE2ABA76B2B761025O0060AB40025O00B6B040025O0036AC40025O00F08D40025O0010B240025O0046AC4003083O00CF0C4B6FE1F20E4C03053O00889C693F1B030B3O001A806D3109B870391EA44903043O00547BEC1903083O00C38EBE03A5BBF79803063O00D590EBCA77CC03103O002114DF30212D4A0119CC3821265F0B2803073O002D4378BE4A4843025O00849240025O00207F4003083O0049E3F12C5941136903073O00741A868558302F03133O000BD2A5D7AD7712CD93F0B87312F5A1F6BA770A03063O00127EA1C084DD03083O006C2DBA105F512FBD03053O00363F48CE6403153O00DD4A404EEC76CD6E4468F54CC12O4D4EE477CD575103063O001BA839251A8503083O001EAF68BCDE23AD6F03053O00B74DCA1CC8031B3O0002208C3A123E861E12109C1A0436BE01033BA80E113F800B03368D03043O00687753E9025O00D2AD40025O009C9E40025O0010A740025O00AEAD4003083O00897AC7675714BD6C03063O007ADA1FB3133E03103O00A6C5C8E5DBA042BCD8DEE3DBA444A7DE03073O0025D3B6ADA1A9C103083O00C43F59CD2175BEE403073O00D9975A2DB9481B030C3O00D66FE2345FD179C51E57D06803053O0036A31C8772026O006640025O00E49940025O005BB340025O00BC9340025O00409940025O00ECAF40026O007D40025O00C2A84003083O0099B4F9F37EE040B903073O0027CAD18D87178E03123O00EA200C2B20FBFE3D0C2F2AE8F33C1A033DF603063O00989F53696A5203083O00B2C345E6C05286D503063O003CE1A63192A903123O003A0D2A0B13042E102A030F132A12232F021303063O00674F7E4F4A6100BD022O0012503O00014O008D000100013O0026D83O0002000100010004A53O00020001001250000100013O002EA200030057000100020004A53O005700010026D800010057000100040004A53O00570001001250000200013O00265B0002000E000100050004A53O000E0001002EA300060027000100070004A53O00330001001250000300013O002EA20009002C000100080004A53O002C00010026D80003002C000100010004A53O002C000100124E0104000A4O00E9000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O00045O00122O0004000A6O000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O000400023O00122O000300053O002EA20014000F000100130004A53O000F00010026D80003000F000100050004A53O000F0001001250000200153O0004A53O003300010004A53O000F0001002EA200160052000100170004A53O0052000100265B00020039000100010004A53O00390001002EA30018001B000100190004A53O0052000100124E0103000A4O00E9000400013O00122O0005001A3O00122O0006001B6O0004000600024O0003000300044O000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000300033O00122O0003000A6O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000300043O00122O000200053O0026D80002000A000100150004A53O000A0001001250000100223O0004A53O005700010004A53O000A000100265B0001005B000100150004A53O005B0001002EA2002300A3000100240004A53O00A30001001250000200014O008D000300033O0026D80002005D000100010004A53O005D0001001250000300013O002EA200250066000100260004A53O00660001000E5101150066000100030004A53O00660001001250000100273O0004A53O00A30001002EA30028001F000100280004A53O00850001002E80002A0085000100290004A53O008500010026D800030085000100010004A53O0085000100124E0104000A4O00E9000500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400054O000500013O00122O0006002D3O00122O0007002E6O0005000700024O0004000400054O000400053O00122O0004000A6O000500013O00122O0006002F3O00122O000700306O0005000700024O0004000400054O000500013O00122O000600313O00122O000700326O0005000700024O0004000400054O000400063O00122O000300053O0026D800030060000100050004A53O0060000100124E0104000A4O00E9000500013O00122O000600333O00122O000700346O0005000700024O0004000400054O000500013O00122O000600353O00122O000700366O0005000700024O0004000400054O000400073O00122O0004000A6O000500013O00122O000600373O00122O000700386O0005000700024O0004000400054O000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000400083O00122O000300153O0004A53O006000010004A53O00A300010004A53O005D00010026D8000100E7000100050004A53O00E70001001250000200013O00265B000200AA000100150004A53O00AA0001002EA2003C00AC0001003B0004A53O00AC0001001250000100153O0004A53O00E70001002EA2003E00CB0001003D0004A53O00CB0001002EA2003F00CB000100400004A53O00CB00010026D8000200CB000100010004A53O00CB000100124E0103000A4O00E9000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O000400013O00122O000500433O00122O000600446O0004000600024O0003000300044O000300093O00122O0003000A6O000400013O00122O000500453O00122O000600466O0004000600024O0003000300044O000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O0003000A3O00122O000200053O0026D8000200A6000100050004A53O00A6000100124E0103000A4O00E9000400013O00122O000500493O00122O0006004A6O0004000600024O0003000300044O000400013O00122O0005004B3O00122O0006004C6O0004000600024O0003000300044O0003000B3O00122O0003000A6O000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O000400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O0003000C3O00122O000200153O0004A53O00A60001002E800051003E2O0100520004A53O003E2O010026D80001003E2O0100530004A53O003E2O01001250000200014O008D000300033O002E80005500ED000100540004A53O00ED0001000E512O0100ED000100020004A53O00ED0001001250000300013O00265B000300F6000100010004A53O00F60001002E80005600152O0100570004A53O00152O0100124E0104000A4O002A010500013O00122O000600583O00122O000700596O0005000700024O0004000400054O000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500062O000400042O0100010004A53O00042O01001250000400014O00DB0004000D3O0012430004000A6O000500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000500013O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500062O000400132O0100010004A53O00132O01001250000400014O00DB0004000E3O001250000300053O002EA300600006000100600004A53O001B2O01000E510115001B2O0100030004A53O001B2O01001250000100613O0004A53O003E2O0100265B0003001F2O0100050004A53O001F2O01002EA2006300F2000100620004A53O00F2000100124E0104000A4O002A010500013O00122O000600643O00122O000700656O0005000700024O0004000400054O000500013O00122O000600663O00122O000700676O0005000700024O00040004000500062O0004002D2O0100010004A53O002D2O01001250000400014O00DB0004000F3O0012490104000A6O000500013O00122O000600683O00122O000700696O0005000700024O0004000400054O000500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000400103O00122O000300153O00044O00F200010004A53O003E2O010004A53O00ED0001002EA2006C00922O01006D0004A53O00922O010026D8000100922O01006E0004A53O00922O01001250000200013O00265B000200472O0100050004A53O00472O01002EA3006F001B000100700004A53O00602O0100124E0103000A4O00E9000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000300113O00122O0003000A6O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000300123O00122O000200153O00265B000200642O0100150004A53O00642O01002E80007900662O01007A0004A53O00662O01001250000100043O0004A53O00922O01002EA2007C00432O01007B0004A53O00432O010026D8000200432O0100010004A53O00432O01001250000300013O002EA2007D006F2O01007E0004A53O006F2O0100265B000300712O0100050004A53O00712O01002E80007F00732O0100800004A53O00732O01001250000200053O0004A53O00432O0100265B000300772O0100010004A53O00772O01002EA20082006B2O0100810004A53O006B2O0100124E0104000A4O00E9000500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000500013O00122O000600853O00122O000700866O0005000700024O0004000400054O000400133O00122O0004000A6O000500013O00122O000600873O00122O000700886O0005000700024O0004000400054O000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400054O000400143O00122O000300053O0004A53O006B2O010004A53O00432O01002E80008C00DC2O01008B0004A53O00DC2O010026D8000100DC2O0100270004A53O00DC2O01001250000200014O008D000300033O0026D8000200982O0100010004A53O00982O01001250000300013O0026D8000300B62O0100010004A53O00B62O0100124E0104000A4O00E9000500013O00122O0006008D3O00122O0007008E6O0005000700024O0004000400054O000500013O00122O0006008F3O00122O000700906O0005000700024O0004000400054O000400153O00122O0004000A6O000500013O00122O000600913O00122O000700926O0005000700024O0004000400054O000500013O00122O000600933O00122O000700946O0005000700024O0004000400054O000400163O00122O000300053O0026D8000300D12O0100050004A53O00D12O0100124E0104000A4O00E9000500013O00122O000600953O00122O000700966O0005000700024O0004000400054O000500013O00122O000600973O00122O000700986O0005000700024O0004000400054O000400173O00122O0004000A6O000500013O00122O000600993O00122O0007009A6O0005000700024O0004000400054O000500013O00122O0006009B3O00122O0007009C6O0005000700024O0004000400054O000400183O00122O000300153O00265B000300D72O0100150004A53O00D72O01002E69019D00D72O01009E0004A53O00D72O01002EA2009F009B2O0100A00004A53O009B2O010012500001006E3O0004A53O00DC2O010004A53O009B2O010004A53O00DC2O010004A53O00982O01000E7D002200E02O0100010004A53O00E02O01002EA300A1005A000100A20004A53O00380201001250000200013O0026D80002002O020100050004A53O002O020100124E0103000A4O002A010400013O00122O000500A33O00122O000600A46O0004000600024O0003000300044O000400013O00122O000500A53O00122O000600A66O0004000600024O00030003000400062O000300F12O0100010004A53O00F12O01001250000300014O00DB000300193O0012430003000A6O000400013O00122O000500A73O00122O000600A86O0004000600024O0003000300044O000400013O00122O000500A93O00122O000600AA6O0004000600024O00030003000400062O00032O00020100010004A54O000201001250000300014O00DB0003001A3O001250000200153O002EA200AB000A020100AC0004A53O000A0201002E8000AE000A020100AD0004A53O000A02010026D80002000A020100150004A53O000A0201001250000100533O0004A53O00380201002E80003C00E12O0100AF0004A53O00E12O01002EA300B000D5FF2O00B00004A53O00E12O010026D8000200E12O0100010004A53O00E12O01001250000300013O0026D800030015020100050004A53O00150201001250000200053O0004A53O00E12O010026D800030011020100010004A53O0011020100124E0104000A4O002A010500013O00122O000600B13O00122O000700B26O0005000700024O0004000400054O000500013O00122O000600B33O00122O000700B46O0005000700024O00040004000500062O00040025020100010004A53O00250201001250000400014O00DB0004001B3O0012430004000A6O000500013O00122O000600B53O00122O000700B66O0005000700024O0004000400054O000500013O00122O000600B73O00122O000700B86O0005000700024O00040004000500062O00040034020100010004A53O00340201001250000400014O00DB0004001C3O001250000300053O0004A53O001102010004A53O00E12O0100265B0001003C020100610004A53O003C0201002E8000B90061020100BA0004A53O0061020100124E0102000A4O00BE000300013O00122O000400BB3O00122O000500BC6O0003000500024O0002000200034O000300013O00122O000400BD3O00122O000500BE6O0003000500024O0002000200034O0002001D3O00122O0002000A6O000300013O00122O000400BF3O00122O000500C06O0003000500024O0002000200034O000300013O00122O000400C13O00122O000500C26O0003000500024O0002000200034O0002001E3O00122O0002000A6O000300013O00122O000400C33O00122O000500C46O0003000500024O0002000200034O000300013O00122O000400C53O00122O000500C66O0003000500024O0002000200034O0002001F3O00044O00BC0201002E8000C80005000100C70004A53O00050001000E512O010005000100010004A53O00050001001250000200014O008D000300033O0026D800020067020100010004A53O00670201001250000300013O0026D80003006E020100150004A53O006E0201001250000100053O0004A53O0005000100265B00030072020100050004A53O00720201002EA200CA008B020100C90004A53O008B020100124E0104000A4O00E9000500013O00122O000600CB3O00122O000700CC6O0005000700024O0004000400054O000500013O00122O000600CD3O00122O000700CE6O0005000700024O0004000400054O000400203O00122O0004000A6O000500013O00122O000600CF3O00122O000700D06O0005000700024O0004000400054O000500013O00122O000600D13O00122O000700D26O0005000700024O0004000400054O000400213O00122O000300153O002E8000D3008F020100D40004A53O008F020100265B00030091020100010004A53O00910201002E8000D5006A020100D60004A53O006A0201001250000400013O00265B00040098020100010004A53O00980201002E1201D80098020100D70004A53O00980201002EA300D9001B000100DA0004A53O00B1020100124E0105000A4O00E9000600013O00122O000700DB3O00122O000800DC6O0006000800024O0005000500064O000600013O00122O000700DD3O00122O000800DE6O0006000800024O0005000500064O000500223O00122O0005000A6O000600013O00122O000700DF3O00122O000800E06O0006000800024O0005000500064O000600013O00122O000700E13O00122O000800E26O0006000800024O0005000500064O000500233O00122O000400053O000E5101050092020100040004A53O00920201001250000300053O0004A53O006A02010004A53O009202010004A53O006A02010004A53O000500010004A53O006702010004A53O000500010004A53O00BC02010004A53O000200012O0048012O00017O007F3O00028O00025O0084B040026O00F03F025O00B4A440025O00A09840027O0040026O000840025O0028A040030C3O004570696353652O74696E677303083O006F753DF2AC2O1B2B03083O00583C104986C5757C030E3O0044F8F1C64A55FEEBFF4844E2DBEC03053O0021308A98A803083O0041132445C839750503063O005712765031A1030D3O005E1FD9A9B1400DEDA9A4443DFE03053O00D02C7EBAC0025O00D07340025O00E0AC40025O00A89140025O0064B34003083O00C41FB0D21DF2CE5D03083O002E977AC4A6749CA9030E3O00F0FE4332FEE4E15212E8F1E2481F03053O009B858D267A03083O00162FB8554671A23603073O00C5454ACC212F1F03103O00E55C5FAFF54E568EFE486A88E446558903043O00E7902F3A025O00B08340025O00C4A740025O0070AA40025O0024A340025O0096B24003083O00F2F09101EDB0D5D203073O00B2A195E57584DE03163O00A1D5C9A9B304B3339CF4D3A0B821AE2A9CDED1A5B20203083O0043E8BBBDCCC176C603083O00B82BA134320CE89803073O008FEB4ED5405B6203123O00A44690EC62A4985890DD78A4885B8CE67CB203063O00D6ED28E48910025O006CA340025O0023B340025O001EAD40025O00BCA040025O00E9B140025O00A09D4003083O00C6FD33364AFBFF3403053O00239598474203113O001FE145B82E2BED4FB13317FB61B83F1AE303053O005A798822D003083O00F40B410ACE00520D03043O007EA76E3503113O00141E3AFDCE2D28003ACFD52B35233AEDD203063O005F5D704E98BC025O00F89340025O00288440025O00409A40025O002EA440025O005BB340025O00709F40025O00E0A04003083O00D6A3AED3812OE2B503063O008C85C6DAA7E8030B3O00A03DB14996BC20BF7890A603053O00E4D54ED41D03083O00B449A211E2894BA503053O008BE72CD665030A3O00CCFC036C11B23817D5FC03083O0076B98F663E70D151025O004CA240025O00D6AC40025O00F6A840025O00804B40025O002AA94003083O00B6E6FBCD0AA882F003063O00C6E5838FB963030D3O007585BB6354808C765399AE754203043O001331ECC803083O00CD32E2A3EDB4F92403063O00DA9E5796D784030B3O00DF17CAF2332EEFEE18DFF103073O00AD9B7EB9825642025O008CA240025O00E8A640026O001040025O002OB240025O00C06D4003083O001D8EF7122785E41503043O00664EEB8303113O00D22F3A404B3C9E3AF9212654482BB235F603083O00549A4E54242759D7025O00B6B040025O00249940025O00CAB240025O00F4AA40025O00D3B140025O00607040025O002OA840025O0082AA40025O00D4B040025O007C9140025O00E88240025O000EA640025O0062B04003083O0038E537F323CB386C03083O001F6B8043874AA55F03113O00F0EDFD4148BFDFD8F35948BED6C6FD404403063O00D1B8889C2D21034O0003083O0034CD611CB109CF6603053O00D867A81568030F3O0070AC4DA074A862A27EA14AA76CA84703043O00C418CD23025O00309640025O0088834003083O0081DDCE611133C82A03083O0059D2B8BA15785DAF030D3O00B9567DD96D32A24773DB7C128103063O005AD1331CB51903083O00E37E43FAB6DE7C4403053O00DFB01B378E030F3O002CBECFB92DB5C9852BAFC7BA2A93FE03043O00D544DBAE025O008EA940025O0023B0400081012O0012503O00014O008D000100023O002EA300020007000100020004A53O000900010026D83O0009000100010004A53O00090001001250000100014O008D000200023O0012503O00033O0026D83O0002000100030004A53O00020001002E800005000B000100040004A53O000B00010026D80001000B000100010004A53O000B0001001250000200013O000E5101060054000100020004A53O00540001001250000300013O0026D800030017000100060004A53O00170001001250000200073O0004A53O00540001002EA30008001D000100080004A53O003400010026D800030034000100010004A53O0034000100124E010400094O00E9000500013O00122O0006000A3O00122O0007000B6O0005000700024O0004000400054O000500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400054O00045O00122O000400096O000500013O00122O0006000E3O00122O0007000F6O0005000700024O0004000400054O000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000400023O00122O000300033O002EA200120038000100130004A53O0038000100265B0003003A000100030004A53O003A0001002EA3001400DBFF2O00150004A53O0013000100124E010400094O00E9000500013O00122O000600163O00122O000700176O0005000700024O0004000400054O000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000400033O00122O000400096O000500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400054O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000400043O00122O000300063O0004A53O001300010026D8000200AF000100010004A53O00AF0001001250000300014O008D000400043O002EA2001E00580001001F0004A53O005800010026D800030058000100010004A53O00580001001250000400013O002EA300200006000100200004A53O006300010026D800040063000100060004A53O00630001001250000200033O0004A53O00AF000100265B00040067000100030004A53O00670001002EA30021001B000100220004A53O0080000100124E010500094O00E9000600013O00122O000700233O00122O000800246O0006000800024O0005000500064O000600013O00122O000700253O00122O000800266O0006000800024O0005000500064O000500053O00122O000500096O000600013O00122O000700273O00122O000800286O0006000800024O0005000500064O000600013O00122O000700293O00122O0008002A6O0006000800024O0005000500064O000500063O00122O000400063O000E7D00010084000100040004A53O00840001002E80002C005D0001002B0004A53O005D0001001250000500013O00265B00050089000100030004A53O00890001002EA2002D008B0001002E0004A53O008B0001001250000400033O0004A53O005D0001002E80003000850001002F0004A53O008500010026D800050085000100010004A53O0085000100124E010600094O002A010700013O00122O000800313O00122O000900326O0007000900024O0006000600074O000700013O00122O000800333O00122O000900346O0007000900024O00060006000700062O0006009D000100010004A53O009D0001001250000600014O00DB000600073O001249010600096O000700013O00122O000800353O00122O000900366O0007000900024O0006000600074O000700013O00122O000800373O00122O000900386O0007000900024O0006000600074O000600083O00122O000500033O00044O008500010004A53O005D00010004A53O00AF00010004A53O00580001002EA2003A003O0100390004A53O003O01002EA2003B003O01003C0004A53O003O010026D80002003O0100030004A53O003O01001250000300014O008D000400043O002EA3003D3O0001003D0004A53O00B700010026D8000300B7000100010004A53O00B70001001250000400013O002EA2003E00D90001003F0004A53O00D900010026D8000400D9000100030004A53O00D9000100124E010500094O00E9000600013O00122O000700403O00122O000800416O0006000800024O0005000500064O000600013O00122O000700423O00122O000800436O0006000800024O0005000500064O000500093O00122O000500096O000600013O00122O000700443O00122O000800456O0006000800024O0005000500064O000600013O00122O000700463O00122O000800476O0006000800024O0005000500064O0005000A3O00122O000400063O000E7D000600DF000100040004A53O00DF0001002E69014800DF000100490004A53O00DF0001002EA2004A00E10001004B0004A53O00E10001001250000200063O0004A53O003O01002EA3004C00DBFF2O004C0004A53O00BC00010026D8000400BC000100010004A53O00BC000100124E010500094O00E9000600013O00122O0007004D3O00122O0008004E6O0006000800024O0005000500064O000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O0005000B3O00122O000500096O000600013O00122O000700513O00122O000800526O0006000800024O0005000500064O000600013O00122O000700533O00122O000800546O0006000800024O0005000500064O0005000C3O00122O000400033O0004A53O00BC00010004A53O003O010004A53O00B70001002EA2005500142O0100560004A53O00142O0100265B000200072O0100570004A53O00072O01002E80005800142O0100590004A53O00142O0100124E010300094O002F000400013O00122O0005005A3O00122O0006005B6O0004000600024O0003000300044O000400013O00122O0005005C3O00122O0006005D6O0004000600024O0003000300042O00DB0003000D3O0004A53O00802O0100265B000200182O0100070004A53O00182O01002E80005E00100001005F0004A53O00100001001250000300014O008D000400043O002EA300603O000100600004A53O001A2O01002E800061001A2O0100620004A53O001A2O010026D80003001A2O0100010004A53O001A2O01001250000400013O002E80006300252O0100640004A53O00252O0100265B000400272O0100030004A53O00272O01002EA20066004F2O0100650004A53O004F2O01001250000500013O002EA20068002E2O0100670004A53O002E2O01000E510103002E2O0100050004A53O002E2O01001250000400063O0004A53O004F2O01002E80006900282O01006A0004A53O00282O01000E512O0100282O0100050004A53O00282O0100124E010600094O002A010700013O00122O0008006B3O00122O0009006C6O0007000900024O0006000600074O000700013O00122O0008006D3O00122O0009006E6O0007000900024O00060006000700062O000600402O0100010004A53O00402O010012500006006F4O00DB0006000E3O001249010600096O000700013O00122O000800703O00122O000900716O0007000900024O0006000600074O000700013O00122O000800723O00122O000900736O0007000900024O0006000600074O0006000F3O00122O000500033O00044O00282O01002EA2007500722O0100740004A53O00722O010026D8000400722O0100010004A53O00722O0100124E010500094O002A010600013O00122O000700763O00122O000800776O0006000800024O0005000500064O000600013O00122O000700783O00122O000800796O0006000800024O00050005000600062O000500612O0100010004A53O00612O01001250000500014O00DB000500103O001243000500096O000600013O00122O0007007A3O00122O0008007B6O0006000800024O0005000500064O000600013O00122O0007007C3O00122O0008007D6O0006000800024O00050005000600062O000500702O0100010004A53O00702O01001250000500014O00DB000500113O001250000400033O002EA2007E00212O01007F0004A53O00212O010026D8000400212O0100060004A53O00212O01001250000200573O0004A53O001000010004A53O00212O010004A53O001000010004A53O001A2O010004A53O001000010004A53O00802O010004A53O000B00010004A53O00802O010004A53O000200012O0048012O00017O000B012O00028O00025O0026AA40025O0014AC40025O00A0A240025O00E4AF40026O00F03F025O00208440025O00F49840025O00C49640025O00BEA040027O0040025O0022AE40025O00EEA040030C3O004570696353652O74696E677303073O00C9EE515F09F8F203053O00659D8136382O033O0012A68903063O00197DC9EACB4303073O004DFB1F0418220003073O00731994786374472O033O000D32BC03053O00216C5DD944025O0056B140025O00289E40025O00D49540025O004C9640025O00608A40025O00C07140026O000840025O00F4A340025O0004AD40025O005C9140025O00709340030F3O00412O66656374696E67436F6D626174025O00C09640025O00608C40025O0004AF40025O0032A240025O0046A840025O00907340025O00949240025O009AA740030D3O00546172676574497356616C6964025O0048B040025O005EAC40025O0006B040025O00E88240025O00449040025O00B09240025O00C8A640025O0076AF40025O00B88E40026O001040025O00909840025O00D6AF40025O001AA240025O00BC9940025O002O9040025O00188140025O00489C40026O00B340025O00209E40025O006DB34003093O00497343617374696E67030C3O0049734368612O6E656C696E6703063O0042752O665570030D3O00486F7453747265616B42752O66025O00E49740025O00A8B140030B3O0053746F7043617374696E67030E3O0049735370652O6C496E52616E676503093O005079726F626C617374030C3O00E23CD3E4910BDDE7C521D2F303043O0094B148BC025O0061B240025O00B88F40025O00F09E40025O00049640025O0022A040025O0088AA40025O00A88040025O00209A40025O00E8B140025O00B49340025O007C9040030F3O0048616E646C65412O666C6963746564030B3O0052656D6F7665437572736503143O0052656D6F766543757273654D6F7573656F766572026O003E40025O0066A440025O00A08740026O006440025O00BC9040025O00C1B140025O00406D4003053O00466F637573025O00788440025O00E07F40025O00D4A540025O00088D40025O0030B040025O0012A240025O004C9540026O007840025O0050A340025O006AA940025O00ABB040025O00C9B240025O0018AB40025O0018AF40025O00509840025O00F0A840025O00808E40025O0046B340025O0078AB40025O00606840025O00A7B240025O00D09640025O00B07F40025O00ECAA40025O0098A940025O001EA140025O00E88740025O00AC9D40025O00E2AA40025O0080AA40025O00388D40025O00608D40025O00149740025O0092A340025O00808540025O0024AD40025O00D6AE40025O00889740025O0002B040025O00B6A040025O00709E40025O00E2A54003113O0048616E646C65496E636F72706F7265616C03093O00506F6C796D6F72706803123O00506F6C796D6F7270684D6F7573654F766572025O00A4AF40025O00609F40025O00805840030A3O00F8CE2809FBD8CA2804FB03053O0097ABBE4D65030B3O004973417661696C61626C65030A3O00F63FFDA5F46E1FC02EF403073O006BA54F98C9981D03073O004973526561647903103O00556E69744861734D6167696342752O66025O00D2AF40025O00F08040025O00307840025O0060A840030A3O005370652O6C737465616C025O004AA040025O0032A34003113O00445EEDC7586C434BE9C7147B5643E9CC5103063O001F372E88AB34025O00807D40025O005EA040025O0034A940025O00BCAB40025O00A08540025O00A4A040025O00807A40025O0088A94003173O00476574456E656D696573496E53706C61736852616E6765026O00144003113O00476574456E656D696573496E52616E6765026O004440025O00207840025O00888C40025O00BBB240025O003C9140025O00AC9140025O009EAC40025O0014B340025O0040B240025O00B9B140025O006AA740025O000AB340025O00108340025O00E6B140031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O001CAC40025O0062A940025O00C2B240025O0095B240025O00A2B140025O00E5B140025O0028A640025O005EB140025O006CB140025O00188E40025O0032B140025O00B8AB40025O00088940025O0086AC40025O0078AD40025O00F08D40025O00588240025O00507D40025O00C06C40025O00A4AB40025O009CAC40025O00C2A340025O00FAA840025O00405140025O0022A640025O00F0A140025O007CB140025O005AAF40025O0040AA40025O0052AE40025O00508140025O00A06940025O00809540025O0010B240025O00F07340025O00889A40025O0002A540025O00AAA040025O001AA540025O0056AF40025O0036B240025O0087B340025O00907D40025O00E6A640025O006AAE40025O0054A840030B3O006ADB1C7507C7EE4DCC027F03073O00AD38BE711A71A203093O00466F637573556E6974026O003440025O0031B240025O0078904003103O00426F2O73466967687452656D61696E73025O00E49440025O0078A440030E3O00436F6D62757374696F6E42752O66025O00DC9840025O00C3B140025O00808640025O00E8A040024O00F069F8402O033O00474344025O00804B40024O0080B3C540030C3O00466967687452656D61696E73025O00107540025O001C9C4003073O00EF44A6AAD74EB203043O00CDBB2BC12O033O00FD761603043O00BF9E126503043O004B69636B03073O00F1CC80B0A3C0D003053O00CFA5A3E7D703043O00CDF0FA5D03063O0010A62O99364403073O00E6BCC7413824EA03073O0099B2D3A026544103063O008602493B870703043O004BE26B3A030D3O004973446561644F7247686F7374009B032O0012503O00014O008D000100023O002E800002000B000100030004A53O000B0001002EA20004000B000100050004A53O000B00010026D83O000B000100010004A53O000B0001001250000100014O008D000200023O0012503O00063O0026D83O0002000100060004A53O00020001002EA20007000D000100080004A53O000D0001000E512O01000D000100010004A53O000D0001001250000200013O0026D80002004E000100010004A53O004E0001001250000300013O002EA20009001D0001000A0004A53O001D000100265B0003001B0001000B0004A53O001B0001002EA2000C001D0001000D0004A53O001D0001001250000200063O0004A53O004E00010026D800030038000100060004A53O0038000100124E0104000E4O00E9000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O00045O00122O0004000E6O000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O000500013O00122O000600153O00122O000700166O0005000700024O0004000400054O000400023O00122O0003000B3O00265B0003003C000100010004A53O003C0001002EA3001700DBFF2O00180004A53O00150001001250000400013O00265B00040041000100060004A53O00410001002EA3001900040001001A0004A53O00430001001250000300063O0004A53O0015000100265B00040047000100010004A53O00470001002EA2001B003D0001001C0004A53O003D00012O0053010500034O00140005000100014O000500046O00050001000100122O000400063O00044O003D00010004A53O001500010026D8000200FC2O01001D0004A53O00FC2O01002EA2001E00750001001F0004A53O00750001002E8000200075000100210004A53O007500012O0053010300053O0020530003000300222O005F01030002000200066A00030075000100010004A53O007500012O005301035O00065E0003007500013O0004A53O00750001001250000300014O008D000400043O002E800024005E000100230004A53O005E000100265B00030064000100010004A53O00640001002E800025005E000100260004A53O005E0001001250000400013O00265B00040069000100010004A53O00690001002EA200270065000100280004A53O006500012O0053010500074O000C0105000100022O00DB000500064O0053010500063O00065E0005007500013O0004A53O007500012O0053010500064O0009000500023O0004A53O007500010004A53O006500010004A53O007500010004A53O005E0001002EA20029009A0301002A0004A53O009A03012O0053010300053O0020530003000300222O005F01030002000200065E0003009A03013O0004A53O009A03012O0053010300083O00209C00030003002B2O000C01030001000200065E0003009A03013O0004A53O009A0301001250000300014O008D000400053O000E512O010088000100030004A53O00880001001250000400014O008D000500053O001250000300063O002EA2002D00830001002C0004A53O008300010026D800030083000100060004A53O00830001002EA2002F008C0001002E0004A53O008C00010026D80004008C000100010004A53O008C0001001250000500013O002EA2003000DB000100310004A53O00DB0001002E80003200DB000100330004A53O00DB00010026D8000500DB0001001D0004A53O00DB0001001250000600013O002EA300340006000100340004A53O009E00010026D80006009E000100060004A53O009E0001001250000500353O0004A53O00DB0001002E80003600A2000100370004A53O00A2000100265B000600A4000100010004A53O00A40001002EA3003800F6FF2O00390004A53O00980001001250000700013O0026D8000700A9000100060004A53O00A90001001250000600063O0004A53O00980001002E80003B00A50001003A0004A53O00A50001000E7D000100AF000100070004A53O00AF0001002EA2003D00A50001003C0004A53O00A50001002EA2003E00D50001003F0004A53O00D500012O0053010800053O0020530008000800402O005F01080002000200066A000800BB000100010004A53O00BB00012O0053010800053O0020530008000800412O005F01080002000200065E000800D500013O0004A53O00D500012O0053010800053O00206F0108000800424O000A00093O00202O000A000A00434O0008000A000200062O000800D500013O0004A53O00D50001002EA2004400D5000100450004A53O00D500012O00530108000A4O00720109000B3O00202O0009000900464O000A000C3O00202O000A000A00474O000C00093O00202O000C000C00484O000A000C00024O000A000A6O0008000A000200062O000800D500013O0004A53O00D500012O0053010800013O001250000900493O001250000A004A4O00480008000A4O002701086O00530108000D4O000C0108000100022O00DB000800063O001250000700063O0004A53O00A500010004A53O009800010026D80005001E2O0100060004A53O001E2O01001250000600014O008D000700073O0026D8000600DF000100010004A53O00DF0001001250000700013O002E80004C00EA0001004B0004A53O00EA000100265B000700E8000100060004A53O00E80001002EA3004D00040001004E0004A53O00EA00010012500005000B3O0004A53O001E2O01002EA3004F00F8FF2O004F0004A53O00E200010026D8000700E2000100010004A53O00E200012O0053010800063O00066A000800F3000100010004A53O00F30001002EA2005000F5000100510004A53O00F500012O0053010800064O0009000800024O00530108000E3O00066A000800FA000100010004A53O00FA0001002E800053001A2O0100520004A53O001A2O012O00530108000F3O00066A000800FF000100010004A53O00FF0001002EA20054001A2O0100550004A53O001A2O01001250000800014O008D000900093O0026D80008003O0100010004A53O003O01001250000900013O0026D8000900042O0100010004A53O00042O012O0053010A00083O002084000A000A00564O000B00093O00202O000B000B00574O000C000B3O00202O000C000C005800122O000D00596O000A000D00024O000A00063O002E2O005B001A2O01005A0004A53O001A2O012O0053010A00063O00065E000A001A2O013O0004A53O001A2O012O0053010A00064O0009000A00023O0004A53O001A2O010004A53O00042O010004A53O001A2O010004A53O003O01001250000700063O0004A53O00E200010004A53O001E2O010004A53O00DF0001002EA2005C005B2O01005D0004A53O005B2O010026D80005005B2O0100010004A53O005B2O01001250000600013O0026D8000600522O0100010004A53O00522O01001250000700013O002EA2005F00492O01005E0004A53O00492O010026D8000700492O0100010004A53O00492O0100124E010800603O00066A0008002F2O0100010004A53O002F2O01002E80006100452O0100620004A53O00452O012O0053010800103O00066A000800342O0100010004A53O00342O01002EA2006300452O0100640004A53O00452O01001250000800013O002E80006600352O0100650004A53O00352O010026D8000800352O0100010004A53O00352O012O0053010900114O000C0109000100022O00DB000900064O0053010900063O00066A000900412O0100010004A53O00412O01002EA2006700452O0100680004A53O00452O012O0053010900064O0009000900023O0004A53O00452O010004A53O00352O012O0053010800124O000C0108000100022O00DB000800063O001250000700063O002E800069004D2O01006A0004A53O004D2O0100265B0007004F2O0100060004A53O004F2O01002EA3006B00D9FF2O006C0004A53O00262O01001250000600063O0004A53O00522O010004A53O00262O01002E80006D00232O01006E0004A53O00232O01002EA2006F00232O0100700004A53O00232O010026D8000600232O0100060004A53O00232O01001250000500063O0004A53O005B2O010004A53O00232O01002E80007100692O0100720004A53O00692O010026D8000500692O0100350004A53O00692O01002E800074009A030100730004A53O009A03012O0053010600063O00066A000600662O0100010004A53O00662O01002EA20075009A030100760004A53O009A03012O0053010600064O0009000600023O0004A53O009A0301000E7D000B006D2O0100050004A53O006D2O01002E8000780091000100770004A53O00910001001250000600013O00265B000600742O0100060004A53O00742O01002EE1007900742O01007A0004A53O00742O01002EA2007C00762O01007B0004A53O00762O010012500005001D3O0004A53O0091000100265B0006007A2O0100010004A53O007A2O01002E80007D006E2O01007E0004A53O006E2O01002EA2007F00B02O0100800004A53O00B02O012O0053010700133O00065E000700B02O013O0004A53O00B02O01001250000700014O008D000800093O002EA2008100852O0100820004A53O00852O0100265B000700872O0100010004A53O00872O01002EA300830005000100840004A53O008A2O01001250000800014O008D000900093O001250000700063O002EA2008600812O0100850004A53O00812O01000E51010600812O0100070004A53O00812O0100265B000800922O0100010004A53O00922O01002EA20087008E2O0100880004A53O008E2O01001250000900013O00265B000900972O0100010004A53O00972O01002EA2008A00932O0100890004A53O00932O012O0053010A00083O0020B5000A000A008B4O000B00093O00202O000B000B008C4O000C000B3O00202O000C000C008D00122O000D00596O000E00016O000A000E00024O000A00063O002E2O008F00B02O01008E0004A53O00B02O01002EA30090000D000100900004A53O00B02O012O0053010A00063O00065E000A00B02O013O0004A53O00B02O012O0053010A00064O0009000A00023O0004A53O00B02O010004A53O00932O010004A53O00B02O010004A53O008E2O010004A53O00B02O010004A53O00812O012O0053010700094O001F010800013O00122O000900913O00122O000A00926O0008000A00024O00070007000800202O0007000700934O00070002000200062O000700DD2O013O0004A53O00DD2O012O0053010700143O00065E000700DD2O013O0004A53O00DD2O012O0053010700094O001F010800013O00122O000900943O00122O000A00956O0008000A00024O00070007000800202O0007000700964O00070002000200062O000700DD2O013O0004A53O00DD2O012O0053010700153O00065E000700DD2O013O0004A53O00DD2O012O0053010700163O00065E000700DD2O013O0004A53O00DD2O012O0053010700053O0020530007000700402O005F01070002000200066A000700DD2O0100010004A53O00DD2O012O0053010700053O0020530007000700412O005F01070002000200066A000700DD2O0100010004A53O00DD2O012O0053010700083O00209C0007000700972O00530108000C4O005F01070002000200066A000700DF2O0100010004A53O00DF2O01002E80009800F42O0100990004A53O00F42O01002EA2009A00F42O01009B0004A53O00F42O012O00530107000A4O00C4000800093O00202O00080008009C4O0009000C3O00202O0009000900474O000B00093O00202O000B000B009C4O0009000B00024O000900096O00070009000200062O000700EF2O0100010004A53O00EF2O01002EA3009D00070001009E0004A53O00F42O012O0053010700013O0012500008009F3O001250000900A04O0048000700094O002701075O001250000600063O0004A53O006E2O010004A53O009100010004A53O009A03010004A53O008C00010004A53O009A03010004A53O008300010004A53O009A0301002EA200A10065030100A20004A53O006503010026D8000200650301000B0004A53O00650301001250000300013O002EA200A30005020100A40004A53O0005020100265B000300070201000B0004A53O00070201002E8000A60009020100A50004A53O000902010012500002001D3O0004A53O0065030100265B0003000D020100010004A53O000D0201002EA200A80018020100A70004A53O001802012O00530104000C3O0020590004000400A900122O000600AA6O0004000600024O000400176O000400053O00202O0004000400AB00122O000600AC6O0004000600024O000400183O00122O000300063O00265B0003001C020100060004A53O001C0201002EA200AE0001020100AD0004A53O00010201001250000400013O00265B00040021020100010004A53O00210201002EA200AF005F030100B00004A53O005F03012O0053010500023O00065E0005006702013O0004A53O00670201001250000500014O008D000600063O002EA200B10026020100B20004A53O002602010026D800050026020100010004A53O00260201001250000600013O00265B0006002F020100010004A53O002F0201002E8000B30050020100B40004A53O00500201001250000700013O002E8000B60034020100B50004A53O00340201000E7D00060036020100070004A53O00360201002EA200B70038020100B80004A53O00380201001250000600063O0004A53O0050020100265B0007003C020100010004A53O003C0201002E8000B900300201001B0004A53O003002012O00530108001A4O002A0009000C3O00202O0009000900BA00122O000B00AA6O0009000B00024O000A00186O000A000A6O0008000A00024O000800196O0008001A6O0009000C3O0020530009000900BA001287000B00AA6O0009000B00024O000A00186O000A000A6O0008000A00024O0008001B3O00122O000700063O00044O00300201002EA200BC002B020100BB0004A53O002B0201002EA300BD00D9FF2O00BD0004A53O002B02010026D80006002B020100060004A53O002B02012O00530107001A4O00900008000C3O00202O0008000800BA00122O000A00AA6O0008000A00024O000900186O000900096O0007000900024O0007001C6O000700186O000700076O0007001D3O00044O009E02010004A53O002B02010004A53O009E02010004A53O002602010004A53O009E0201001250000500014O008D000600073O0026D80005006E020100010004A53O006E0201001250000600014O008D000700073O001250000500063O002E8000BF0069020100BE0004A53O006902010026D800050069020100060004A53O0069020100265B00060076020100010004A53O00760201002EA200C00072020100C10004A53O00720201001250000700013O002E8000C2007B020100C30004A53O007B020100265B0007007D020100010004A53O007D0201002EA300C400130001001C0004A53O008E0201001250000800013O00265B00080082020100010004A53O00820201002EA300C50007000100C60004A53O00870201001250000900064O00DB000900193O001250000900064O00DB0009001B3O001250000800063O00265B0008008B020100060004A53O008B0201002EA300C700F5FF2O00C80004A53O007E0201001250000700063O0004A53O008E02010004A53O007E0201002EA200CA0077020100C90004A53O00770201002E8000CB00770201001B0004A53O007702010026D800070077020100060004A53O00770201001250000800064O00DB0008001C3O001250000800064O00DB0008001D3O0004A53O009E02010004A53O007702010004A53O009E02010004A53O007202010004A53O009E02010004A53O00690201002E8000CD005E030100CC0004A53O005E03012O0053010500083O00209C00050005002B2O000C01050001000200066A000500AA020100010004A53O00AA02012O0053010500053O0020530005000500222O005F01050002000200065E0005005E03013O0004A53O005E0301001250000500013O002E8000CE00C3020100CF0004A53O00C30201002EA200D000C3020100D10004A53O00C302010026D8000500C30201000B0004A53O00C30201001250000600013O00265B000600B6020100010004A53O00B60201002E8000D300BE020100D20004A53O00BE02012O00530107001F4O0023000800186O0007000200024O0007001E6O000700216O000700076O000700203O00122O000600063O0026D8000600B2020100060004A53O00B202010012500005001D3O0004A53O00C302010004A53O00B20201002EA200D4002C030100D50004A53O002C03010026D80005002C030100010004A53O002C03012O0053010600053O0020530006000600222O005F01060002000200066A000600CF020100010004A53O00CF02012O0053010600103O00065E0006002503013O0004A53O00250301001250000600014O008D000700093O00265B000600D7020100010004A53O00D70201002EE100D600D7020100D70004A53O00D70201002EA200D800DA020100D90004A53O00DA0201001250000700014O008D000800083O001250000600063O002EA300DA00F7FF2O00DA0004A53O00D1020100265B000600E0020100060004A53O00E00201002E8000DC00D1020100DB0004A53O00D102012O008D000900093O002E8000DD001D030100DE0004A53O001D03010026D80007001D030100060004A53O001D0301002E8000E00011030100DF0004A53O001103010026D800080011030100010004A53O00110301001250000A00013O002E8000E100F2020100E20004A53O00F2020100265B000A00F0020100060004A53O00F00201002EA200E400F2020100E30004A53O00F20201001250000800063O0004A53O00110301002EA200E500EA020100E60004A53O00EA020100265B000A00F8020100010004A53O00F80201002E8000E700EA020100E80004A53O00EA02012O0053010B00103O000655000900060301000B0004A53O000603012O0053010B00094O0066000C00013O00122O000D00E93O00122O000E00EA6O000C000E00024O000B000B000C00202O000B000B00964O000B0002000200062O000900060301000B0004A53O000603012O0053010900154O0053010B00083O0020AD000B000B00EB4O000C00096O000D000B3O00122O000E00EC6O000F000F3O00122O001000EC6O000B001000024O000B00063O00122O000A00063O00044O00EA0201002E8000EE00E5020100ED0004A53O00E502010026D8000800E5020100060004A53O00E502012O0053010A00063O00065E000A002503013O0004A53O002503012O0053010A00064O0009000A00023O0004A53O002503010004A53O00E502010004A53O002503010026D8000700E1020100010004A53O00E10201001250000800014O008D000900093O001250000700063O0004A53O00E102010004A53O002503010004A53O00D102012O0053010600233O0020B80006000600EF4O000700076O000800016O0006000800024O000600223O00122O000500063O00265B00050030030100350004A53O00300301002EA200F1003A030100F00004A53O003A03012O0053010600053O0020620106000600424O000800093O00202O0008000800F24O0006000800024O000600246O000600246O000600066O000600253O00044O005E030100265B0005003E0301001D0004A53O003E0301002EA300F3000E000100F40004A53O004A03012O0053010600203O00066A00060043030100010004A53O00430301002E8000F60045030100F50004A53O00450301001250000600F74O00DB000600264O0053010600053O0020530006000600F82O005F0106000200022O00DB000600273O001250000500353O002EA2002F00AB020100870004A53O00AB02010026D8000500AB020100060004A53O00AB02012O0053010600224O00DB000600283O002EA300F90006000100F90004A53O005603012O0053010600283O00265B00060056030100FA0004A53O005603010004A53O005C03012O0053010600233O00203C0006000600FB4O000700186O00088O0006000800024O000600283O0012500005000B3O0004A53O00AB0201001250000400063O0026D80004001D020100060004A53O001D02010012500003000B3O0004A53O000102010004A53O001D02010004A53O00010201002EA200FC0012000100FD0004A53O00120001000E5101060012000100020004A53O0012000100124E0103000E4O00EC000400013O00122O000500FE3O00122O000600FF6O0004000600024O0003000300044O000400013O00122O00052O00012O00122O0006002O015O0004000600024O0003000300044O000300213O00122O0003000E6O000400013O00122O00050003012O00122O00060004015O0004000600024O0003000300044O000400013O00122O00050005012O00122O00060006015O0004000600024O00030003000400122O00030002012O00122O0003000E6O000400013O00122O00050007012O00122O00060008015O0004000600024O0003000300044O000400013O00122O00050009012O00122O0006000A015O0004000600024O0003000300044O000300156O000300053O00122O0005000B015O0003000300054O00030002000200062O0003009403013O0004A53O009403012O0048012O00013O0012500002000B3O0004A53O001200010004A53O009A03010004A53O000D00010004A53O009A03010004A53O000200012O0048012O00017O00083O00028O00025O00A49040025O0008A240025O0028A340025O0090874003053O005072696E7403313O0080BF45D6E69B56D4A3F645DCB2B743DAA9B817D1BFF672C3AFB5199395A347C3A9A443D6A2F655CAE6AE7CD2A8B343DCE803043O00B3C6D63700193O0012503O00014O008D000100013O002EA200020006000100030004A53O0006000100265B3O0008000100010004A53O00080001002EA200040002000100050004A53O00020001001250000100013O0026D800010009000100010004A53O000900012O005301026O006B0102000100014O000200013O00202O0002000200064O000300023O00122O000400073O00122O000500086O000300056O00023O000100044O001800010004A53O000900010004A53O001800010004A53O000200012O0048012O00017O00", GetFEnv(), ...);

