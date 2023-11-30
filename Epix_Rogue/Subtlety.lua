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
				if (Enum <= 199) then
					if (Enum <= 99) then
						if (Enum <= 49) then
							if (Enum <= 24) then
								if (Enum <= 11) then
									if (Enum <= 5) then
										if (Enum <= 2) then
											if (Enum <= 0) then
												local B;
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
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
											elseif (Enum > 1) then
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
										elseif (Enum <= 3) then
											local B = Inst[3];
											local K = Stk[B];
											for Idx = B + 1, Inst[4] do
												K = K .. Stk[Idx];
											end
											Stk[Inst[2]] = K;
										elseif (Enum == 4) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
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
										end
									elseif (Enum <= 8) then
										if (Enum <= 6) then
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
											Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
										elseif (Enum > 7) then
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
										end
									elseif (Enum <= 9) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum > 10) then
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
										local A;
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum <= 17) then
									if (Enum <= 14) then
										if (Enum <= 12) then
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
										else
											Stk[Inst[2]] = Upvalues[Inst[3]];
										end
									elseif (Enum <= 15) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 16) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
								elseif (Enum <= 20) then
									if (Enum <= 18) then
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
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
										Stk[Inst[2]] = Inst[3];
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
									elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum <= 22) then
									if (Enum > 21) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
											return Stk[Inst[2]];
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
								elseif (Enum == 23) then
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
								if (Enum <= 30) then
									if (Enum <= 27) then
										if (Enum <= 25) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
												return Stk[Inst[2]];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										elseif (Enum > 26) then
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
											Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 28) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 29) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A]());
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 33) then
									if (Enum <= 31) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 32) then
										local A;
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
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
								elseif (Enum <= 34) then
									local B;
									local A;
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
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 35) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3];
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
									A = Inst[2];
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
								if (Enum <= 39) then
									if (Enum <= 37) then
										local B = Stk[Inst[4]];
										if not B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									elseif (Enum == 38) then
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
									elseif Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 40) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 41) then
									Stk[Inst[2]] = -Stk[Inst[3]];
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								end
							elseif (Enum <= 45) then
								if (Enum <= 43) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 44) then
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
								else
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
								end
							elseif (Enum <= 47) then
								if (Enum > 46) then
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
							elseif (Enum > 48) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 74) then
							if (Enum <= 61) then
								if (Enum <= 55) then
									if (Enum <= 52) then
										if (Enum <= 50) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
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
										elseif (Enum == 51) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										elseif (Stk[Inst[2]] > Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 53) then
										if (Inst[2] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 54) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
											return Stk[Inst[2]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
										do
											return Stk[Inst[2]]();
										end
									end
								elseif (Enum <= 58) then
									if (Enum <= 56) then
										local A;
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
									elseif (Enum == 57) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
								elseif (Enum <= 59) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 60) then
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
								end
							elseif (Enum <= 67) then
								if (Enum <= 64) then
									if (Enum <= 62) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum > 63) then
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
								elseif (Enum <= 65) then
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
								elseif (Enum == 66) then
									local B;
									local T;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
								end
							elseif (Enum <= 70) then
								if (Enum <= 68) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								elseif (Enum > 69) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local K;
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									B = Inst[3];
									K = Stk[B];
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum <= 72) then
								if (Enum > 71) then
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
								else
									local Edx;
									local Results, Limit;
									local A;
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
								end
							elseif (Enum > 73) then
								if (Stk[Inst[2]] <= Inst[4]) then
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
						elseif (Enum <= 86) then
							if (Enum <= 80) then
								if (Enum <= 77) then
									if (Enum <= 75) then
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
									elseif (Enum == 76) then
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
								elseif (Enum <= 78) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum == 79) then
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
							elseif (Enum <= 83) then
								if (Enum <= 81) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 82) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 84) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 85) then
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
								A = Inst[2];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							end
						elseif (Enum <= 92) then
							if (Enum <= 89) then
								if (Enum <= 87) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 88) then
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 90) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum > 91) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 95) then
							if (Enum <= 93) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 94) then
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
							end
						elseif (Enum <= 97) then
							if (Enum == 96) then
								local A;
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
						elseif (Enum == 98) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = -Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						end
					elseif (Enum <= 149) then
						if (Enum <= 124) then
							if (Enum <= 111) then
								if (Enum <= 105) then
									if (Enum <= 102) then
										if (Enum <= 100) then
											local K;
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											B = Inst[3];
											K = Stk[B];
											for Idx = B + 1, Inst[4] do
												K = K .. Stk[Idx];
											end
											Stk[Inst[2]] = K;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											do
												return Stk[Inst[2]];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										elseif (Enum > 101) then
											local A = Inst[2];
											local B = Inst[3];
											for Idx = A, B do
												Stk[Idx] = Vararg[Idx - A];
											end
										else
											local A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
											end
										end
									elseif (Enum <= 103) then
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 104) then
										local B;
										local A;
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 108) then
									if (Enum <= 106) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 107) then
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
									end
								elseif (Enum <= 109) then
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
								elseif (Enum == 110) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
										return Stk[Inst[2]];
									end
								else
									local Edx;
									local Results, Limit;
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
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
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
							elseif (Enum <= 117) then
								if (Enum <= 114) then
									if (Enum <= 112) then
										if (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 113) then
										if (Inst[2] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 115) then
									local Edx;
									local Results, Limit;
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum > 116) then
									local A;
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
								elseif (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 120) then
								if (Enum <= 118) then
									Stk[Inst[2]] = Inst[3] ~= 0;
								elseif (Enum > 119) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 122) then
								if (Enum > 121) then
									local A;
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 123) then
								local A;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 136) then
							if (Enum <= 130) then
								if (Enum <= 127) then
									if (Enum <= 125) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									elseif (Enum > 126) then
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
									else
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									end
								elseif (Enum <= 128) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 129) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 133) then
								if (Enum <= 131) then
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
									Stk[A] = Stk[A]();
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
								elseif (Enum > 132) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 134) then
								Env[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 135) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 142) then
							if (Enum <= 139) then
								if (Enum <= 137) then
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
								elseif (Enum == 138) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 140) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 141) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 145) then
							if (Enum <= 143) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 144) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 147) then
							if (Enum == 146) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							else
								local K;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								B = Inst[3];
								K = Stk[B];
								for Idx = B + 1, Inst[4] do
									K = K .. Stk[Idx];
								end
								Stk[Inst[2]] = K;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum > 148) then
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
					elseif (Enum <= 174) then
						if (Enum <= 161) then
							if (Enum <= 155) then
								if (Enum <= 152) then
									if (Enum <= 150) then
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									elseif (Enum == 151) then
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
									end
								elseif (Enum <= 153) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum > 154) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 158) then
								if (Enum <= 156) then
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								elseif (Enum > 157) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
							elseif (Enum <= 159) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							elseif (Enum == 160) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 167) then
							if (Enum <= 164) then
								if (Enum <= 162) then
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
								elseif (Enum == 163) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 165) then
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
								VIP = Inst[3];
							elseif (Enum > 166) then
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
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
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 170) then
							if (Enum <= 168) then
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
							elseif (Enum == 169) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum <= 172) then
							if (Enum > 171) then
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
							end
						elseif (Enum > 173) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 186) then
						if (Enum <= 180) then
							if (Enum <= 177) then
								if (Enum <= 175) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 176) then
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
									B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum > 179) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 183) then
							if (Enum <= 181) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 182) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 184) then
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Enum == 185) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
						end
					elseif (Enum <= 192) then
						if (Enum <= 189) then
							if (Enum <= 187) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 188) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 191) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 195) then
						if (Enum <= 193) then
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
						elseif (Enum == 194) then
							local Edx;
							local Results, Limit;
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
							Stk[Inst[2]] = Stk[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 197) then
						if (Enum == 196) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 198) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						if (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 299) then
					if (Enum <= 249) then
						if (Enum <= 224) then
							if (Enum <= 211) then
								if (Enum <= 205) then
									if (Enum <= 202) then
										if (Enum <= 200) then
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] > Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = VIP + Inst[3];
											end
										elseif (Enum > 201) then
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
									elseif (Enum <= 203) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 204) then
										Stk[Inst[2]] = {};
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 208) then
									if (Enum <= 206) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
											if (Mvm[1] == 246) then
												Indexes[Idx - 1] = {Stk,Mvm[3]};
											else
												Indexes[Idx - 1] = {Upvalues,Mvm[3]};
											end
											Lupvals[#Lupvals + 1] = Indexes;
										end
										Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
								elseif (Enum <= 209) then
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
								elseif (Enum > 210) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 217) then
								if (Enum <= 214) then
									if (Enum <= 212) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 213) then
										local A;
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
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
									Stk[Inst[2]] = Stk[Inst[3]];
								elseif (Enum > 216) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 220) then
								if (Enum <= 218) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 219) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
								end
							elseif (Enum <= 222) then
								if (Enum > 221) then
									local B;
									local T;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum > 223) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 236) then
							if (Enum <= 230) then
								if (Enum <= 227) then
									if (Enum <= 225) then
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
									elseif (Enum > 226) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 228) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum > 229) then
									local B;
									local A;
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
							elseif (Enum <= 233) then
								if (Enum <= 231) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 232) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								end
							elseif (Enum <= 234) then
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
							elseif (Enum > 235) then
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
						elseif (Enum <= 242) then
							if (Enum <= 239) then
								if (Enum <= 237) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 240) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 241) then
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
							if (Enum <= 243) then
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 244) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							else
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							end
						elseif (Enum <= 247) then
							if (Enum == 246) then
								Stk[Inst[2]] = Stk[Inst[3]];
							else
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum == 248) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local K;
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							B = Inst[3];
							K = Stk[B];
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 274) then
						if (Enum <= 261) then
							if (Enum <= 255) then
								if (Enum <= 252) then
									if (Enum <= 250) then
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
									elseif (Enum > 251) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 253) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								elseif (Enum == 254) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 258) then
								if (Enum <= 256) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 257) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 259) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 260) then
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
						elseif (Enum <= 267) then
							if (Enum <= 264) then
								if (Enum <= 262) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 263) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 265) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
									return Stk[Inst[2]];
								end
							elseif (Enum == 266) then
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
						elseif (Enum <= 270) then
							if (Enum <= 268) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 269) then
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
						elseif (Enum <= 272) then
							if (Enum > 271) then
								if (Inst[2] == Inst[4]) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 273) then
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
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
							end
						end
					elseif (Enum <= 286) then
						if (Enum <= 280) then
							if (Enum <= 277) then
								if (Enum <= 275) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 276) then
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
							elseif (Enum <= 278) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum > 279) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 283) then
							if (Enum <= 281) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
								A = Inst[2];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							elseif (Enum == 282) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 284) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 285) then
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 292) then
						if (Enum <= 289) then
							if (Enum <= 287) then
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							elseif (Enum > 288) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 290) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 291) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 295) then
						if (Enum <= 293) then
							local Edx;
							local Results, Limit;
							local B;
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 294) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 297) then
						if (Enum == 296) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						elseif (Inst[2] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 298) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
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
						A = Inst[2];
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
				elseif (Enum <= 349) then
					if (Enum <= 324) then
						if (Enum <= 311) then
							if (Enum <= 305) then
								if (Enum <= 302) then
									if (Enum <= 300) then
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
									elseif (Enum > 301) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									else
										local K;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										do
											return Stk[Inst[2]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 303) then
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 304) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								end
							elseif (Enum <= 308) then
								if (Enum <= 306) then
									Stk[Inst[2]] = #Stk[Inst[3]];
								elseif (Enum > 307) then
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
									if (Inst[2] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 309) then
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
							elseif (Enum > 310) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 317) then
							if (Enum <= 314) then
								if (Enum <= 312) then
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
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 313) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 315) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 316) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 320) then
							if (Enum <= 318) then
								do
									return;
								end
							elseif (Enum > 319) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 322) then
							if (Enum > 321) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
								Stk[Inst[2]] = -Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum > 323) then
							local B;
							local A;
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = -Stk[Inst[3]];
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
					elseif (Enum <= 336) then
						if (Enum <= 330) then
							if (Enum <= 327) then
								if (Enum <= 325) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 326) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 328) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 329) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 333) then
							if (Enum <= 331) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							elseif (Enum == 332) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 334) then
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
						elseif (Enum > 335) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 342) then
						if (Enum <= 339) then
							if (Enum <= 337) then
								local A;
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum == 338) then
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
						elseif (Enum <= 340) then
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 341) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 345) then
						if (Enum <= 343) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 344) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]]();
						end
					elseif (Enum <= 347) then
						if (Enum == 346) then
							local A;
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
					elseif (Enum > 348) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = VIP + Inst[3];
					end
				elseif (Enum <= 374) then
					if (Enum <= 361) then
						if (Enum <= 355) then
							if (Enum <= 352) then
								if (Enum <= 350) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 351) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
							elseif (Enum <= 353) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							elseif (Enum == 354) then
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
						elseif (Enum <= 358) then
							if (Enum <= 356) then
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
							elseif (Enum == 357) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 359) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 360) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
					elseif (Enum <= 367) then
						if (Enum <= 364) then
							if (Enum <= 362) then
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
							elseif (Enum > 363) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							else
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 365) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 366) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 370) then
						if (Enum <= 368) then
							Stk[Inst[2]] = Inst[3];
						elseif (Enum == 369) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 372) then
						if (Enum > 371) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 373) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						Stk[Inst[2]] = not Stk[Inst[3]];
					end
				elseif (Enum <= 387) then
					if (Enum <= 380) then
						if (Enum <= 377) then
							if (Enum <= 375) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 376) then
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
						elseif (Enum <= 378) then
							do
								return Stk[Inst[2]];
							end
						elseif (Enum == 379) then
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
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						end
					elseif (Enum <= 383) then
						if (Enum <= 381) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 382) then
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
						else
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 385) then
						if (Enum == 384) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum == 386) then
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 393) then
					if (Enum <= 390) then
						if (Enum <= 388) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 389) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 391) then
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
					elseif (Enum > 392) then
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
					else
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Stk[Inst[4]]];
					end
				elseif (Enum <= 396) then
					if (Enum <= 394) then
						Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
					elseif (Enum == 395) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 398) then
					if (Enum > 397) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
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
					else
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
				elseif (Enum == 399) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503173O00F4D3D23DD989C819C4C6E416F3B9D312D4D7C26BEAAEC603083O007EB1A3BB4586DBA703173O00FCFF0F462F833E11CCEA396D05B3251ADCFB1F101CA43003083O0076B98F663E70D151002E3O0012213O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004813O000A0001001213000300063O002085000400030007001213000500083O002085000500050009001213000600083O00208500060006000A0006CF00073O000100062O00F63O00064O00F68O00F63O00044O00F63O00014O00F63O00024O00F63O00053O00208500080003000B00208500090003000C2O00CD000A5O001213000B000D3O0006CF000C0001000100022O00F63O000A4O00F63O000B4O00F6000D00073O001270010E000E3O001270010F000F4O0071000D000F00020006CF000E0002000100032O00F63O00074O00F63O00094O00F63O00084O0035010A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O004900025O00122O000300016O00045O00122O000500013O00042O0003002100012O000E00076O002C010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O000E000C00034O0007000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O003D000C6O00D8000A3O00020020A9000A000A00022O00710109000A4O00B700073O00010004260003000500012O000E000300054O00F6000400024O006B000300044O001201036O003E012O00017O00063O00028O00026O00F03F025O00BFB040026O005F40025O0012A440025O009CAE40012A3O001270010200014O003D010300033O00267601020008000100020004813O000800012O00F6000400034O00F500056O009900046O001201045O00267601020002000100010004813O00020001001270010400013O0026760104000F000100020004813O000F0001001270010200023O0004813O000200010026760104000B000100010004813O000B0001001270010500013O002E3F01040018000100030004813O0018000100267601050018000100020004813O00180001001270010400023O0004813O000B000100267601050012000100010004813O001200012O000E00066O0063000300063O002E3F01050025000100060004813O0025000100064000030025000100010004813O002500012O000E000600014O00F600076O00F500086O009900066O001201065O001270010500023O0004813O001200010004813O000B00010004813O000200012O003E012O00017O00583O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A030A3O0034AADDCB841F241CB3DD03073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O007C5609295A03043O004529226003053O0089D7DE061103063O004BDCA3B76A6203093O0020B5843BED0D93852303053O00B962DAEB5703053O00EA3302C9F003063O00CAAB5C4786BE03053O000AE53FA70703043O00E849A14C03043O0099D04C5903053O007EDBB9223D03053O0021CF5D607103083O00876CAE3E121E179303053O0086FB2FD80B03083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D92O033O00C9417D03063O007EA7341074D903073O00EB212D8DBB17EF03073O009CA84E40E0D47903083O0022F8A0DC1EE1ABCB03043O00AE678EC503043O005427503403073O009836483F58453E03053O00706169727303053O007461626C6503063O00DDCAFD59C6D003043O003CB4A48E03043O006D6174682O033O0055570B03073O0072383E6549478D2O033O00B5E8C303043O00A4D889BB2O033O00D3E42203073O006BB28651D2C69E03073O00E21D00F80D7EAA03073O00D9A1726D95621003083O0037363D6EA57B1C2503063O00147240581CDC03073O00120EDFB9F7DEAE03073O00DD5161B2D498B003053O00FFE81AEE1F03053O007AAD877D9B03053O00B6CE07AC3A03073O00A8E4A160D95F5103083O00E8C42C482352CFC803063O0037BBB14E3C4F03053O001FC158FE4303073O00E04DAE3F8B26AF03083O00B7545A3A88444C3703043O004EE4213803053O00FC71B5168003053O00E5AE1ED26303083O0028F88445E1382D0203073O00597B8DE6318D5D030A3O00D667FF1F134FE170E20903063O002A9311966C7003153O00526567697374657244616D616765466F726D756C6103073O006CD6E5F139D25B03063O00A03EA395854C03133O005265676973746572504D756C7469706C69657203063O0053657441504C025O005070400006023O003C000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00124F000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00124F0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00124F000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00124F000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00124F000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F4O00105O00124F0011001A3O00122O0012001B6O0010001200024O000F000F00104O00105O00122O0011001C3O00122O0012001D6O0010001200024O0010000400104O00115O00124F0012001E3O00122O0013001F6O0011001300024O0011000400114O00125O00122O001300203O00122O001400216O0012001400024O0012000400124O00135O00124F001400223O00122O001500236O0013001500024O0013000400134O00145O00122O001500243O00122O001600256O0014001600024O0014000400144O00155O00124F001600263O00122O001700276O0015001700024O0015000400154O00165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00124F0017002A3O00122O0018002B6O0016001800024O0015001500164O00165O00122O0017002C3O00122O0018002D6O0016001800024O0016000400164O00175O0012550018002E3O00122O0019002F6O0017001900024O0016001600174O00175O00122O001800303O00122O001900316O0017001900024O00160016001700122O001700323O001241011800336O00195O00122O001A00343O00122O001B00356O0019001B00024O00180018001900122O001900366O001A5O00122O001B00373O00122O001C00384O0071001A001C00022O006300190019001A001241011A00366O001B5O00122O001C00393O00122O001D003A6O001B001D00024O001A001A001B00122O001B00366O001C5O00122O001D003B3O00122O001E003C4O0071001C001E00022O008D011B001B001C4O001C8O001D8O001E8O001F004C3O0006CF004D3O000100292O00F63O00474O000E8O00F63O00484O00F63O00494O00F63O004A4O00F63O004B4O00F63O00234O00F63O00244O00F63O00274O00F63O00254O00F63O00264O00F63O001F4O00F63O002D4O00F63O00204O00F63O00214O00F63O00224O00F63O003F4O00F63O00404O00F63O003D4O00F63O003E4O00F63O00414O00F63O00334O00F63O00344O00F63O00354O00F63O00364O00F63O00374O00F63O00324O00F63O00294O00F63O002A4O00F63O002B4O00F63O002C4O00F63O003A4O00F63O003B4O00F63O00384O00F63O00394O00F63O003C4O00F63O00424O00F63O00434O00F63O00464O00F63O00444O00F63O00454O00FD004E5O00122O004F003D3O00122O0050003E6O004E005000024O004E0004004E4O004F5O00122O0050003F3O00122O005100406O004F005100024O004E004E004F4O004F5O00122O005000413O00122O005100426O004F005100024O004F0004004F4O00505O00122O005100433O00122O005200446O0050005200024O004F004F00504O00505O00122O005100453O00122O005200466O0050005200024O0050000B00504O00515O00122O005200473O00122O005300486O0051005300024O0050005000514O00515O00122O005200493O00122O0053004A6O0051005300024O0051000D00514O00525O00122O0053004B3O00122O0054004C6O0052005400024O0051005100524O00525O00122O0053004D3O00122O0054004E6O0052005400024O0052001300524O00535O00122O0054004F3O00122O005500506O0053005500024O0052005200534O00538O005400676O00685O00122O006900513O00122O006A00526O0068006A00024O00680050006800202O0068006800530006CF006A0001000100072O00F63O00074O00F63O00634O00F63O00504O000E8O000E3O00014O000E3O00024O00F63O00084O00980068006A00014O00685O00122O006900543O00122O006A00556O0068006A00024O00680050006800202O0068006800560006CF006A0002000100022O00F63O00074O00F63O00504O00770068006A00010006CF00680003000100012O00F63O00603O0006CF00690004000100042O00F63O00444O000E8O00F63O00074O00F63O00083O0006CF006A0005000100052O00F63O005A4O00F63O002C4O000E8O00F63O00084O00F63O00073O0006CF006B0006000100062O00F63O00174O00F63O004E4O00F63O00084O00F63O00144O000E8O00F63O000A3O0006CF006C0007000100062O000E3O00014O00F63O00154O00F63O00504O000E8O000E3O00024O00F63O005A3O0006CF006D0008000100052O00F63O00504O000E8O000E3O00014O00F63O000F4O000E3O00023O0006CF006E0009000100082O00F63O005A4O00F63O00154O00F63O00504O000E8O00F63O000F4O00F63O00674O00F63O00654O00F63O00643O0006CF006F000A000100042O00F63O00074O00F63O00504O00F63O005A4O00F63O004F3O0006CF0070000B000100042O00F63O00074O00F63O00504O00F63O005A4O00F63O00083O0006CF0071000C000100042O00F63O00074O00F63O00504O00F63O005A4O000E7O0006CF0072000D000100042O00F63O00074O00F63O00504O00F63O005A4O00F63O00643O0006CF0073000E000100042O00F63O00074O00F63O00504O000E8O00F63O005A3O0006CF0074000F000100032O00F63O00074O00F63O00504O000E7O0006CF007500100001001B2O00F63O00074O00F63O00504O000E8O000E3O00014O000E3O00024O00F63O00194O00F63O00644O00F63O001A4O00F63O00044O00F63O00594O00F63O005A4O00F63O00704O00F63O00674O00F63O00084O00F63O00614O00F63O00564O00F63O004F4O00F63O00624O00F63O00734O00F63O00524O00F63O00144O00F63O001D4O00F63O005D4O00F63O006B4O00F63O005B4O00F63O004E4O00F63O00743O0006CF00760011000100122O00F63O004F4O00F63O00754O00F63O00504O000E8O00F63O00744O00F63O005A4O00F63O00074O00F63O00644O00F63O00654O00F63O00084O00F63O00564O00F63O00674O00F63O001D4O000E3O00014O00F63O000F4O000E3O00024O00F63O00154O00F63O00193O0006CF007700120001000B2O00F63O00504O000E8O00F63O001E4O00F63O005D4O00F63O00044O00F63O00524O00F63O00764O00F63O00074O00F63O00494O00F63O004A4O00F63O004B3O0006CF00780013000100042O00F63O005D4O00F63O004E4O00F63O00534O00F63O001E3O0006CF00790014000100172O00F63O00564O00F63O001E4O00F63O00504O000E8O00F63O00074O00F63O00644O00F63O00084O00F63O00044O00F63O005A4O00F63O00144O00F63O00354O00F63O00654O00F63O00674O00F63O006F4O00F63O00694O00F63O005D4O00F63O00774O00F63O002D4O00F63O00784O00F63O00714O00F63O003A4O00F63O004F4O00F63O00323O0006CF007A0015000100112O00F63O001E4O00F63O00504O000E8O00F63O00074O00F63O00084O00F63O005A4O00F63O006D4O00F63O00654O00F63O00044O00F63O005D4O00F63O00774O00F63O00564O00F63O00434O00F63O006E4O00F63O000F4O00F63O00724O00F63O00693O0006CF007B00160001000C2O00F63O00074O00F63O001D4O00F63O00504O000E8O00F63O005A4O000E3O00014O00F63O000F4O000E3O00024O00F63O00044O00F63O00564O00F63O00644O00F63O004F3O0006CF007C0017000100332O00F63O00074O00F63O004E4O00F63O00094O00F63O00504O000E8O00F63O00144O00F63O00524O00F63O005D4O00F63O004F4O00F63O00664O00F63O006C4O00F63O00654O00F63O00674O00F63O006A4O00F63O00634O00F63O00644O00F63O001D4O00F63O005A4O00F63O00594O00F63O005B4O00F63O00544O00F63O00584O00F63O00554O000E3O00014O00F63O001A4O000E3O00024O00F63O001B4O00F63O00154O00F63O00194O00F63O00614O00F63O00084O00F63O00564O00F63O00764O00F63O00044O00F63O00754O00F63O001C4O00F63O004C4O00F63O001E4O00F63O007A4O00F63O007B4O00F63O00794O00F63O00604O00F63O005F4O00F63O00574O00F63O00624O00F63O00424O00F63O00514O00F63O00244O00F63O00224O00F63O004D4O00F63O005E3O0006CF007D0018000100022O00F63O00044O000E7O002069007E0004005700122O007F00586O0080007C6O0081007D6O007E008100016O00013O00193O00C93O00028O00026O00F03F026O001C40030C3O004570696353652O74696E677303083O007D15236E471E306903043O001A2E705703143O008A3AA676B0B356BBBF07AE75ABB76AB2BF04885003083O00D4D943CB142ODF2503083O008988BCC6B383AFC103043O00B2DAEDC803123O0085BDE7D4B9A2C4DCB7B1E3C399B3E0F7959103043O00B0D6D58603083O00C7A8A2C0A1585EE703073O003994CDD6B4C83603123O0024FC3B3D651ACE2131771EE93D197711EF3A03053O0016729D555403083O00F7CE07D054F8AFD703073O00C8A4AB73A43D9603163O008DFC02418CA9F90649878DE006448FAAFC2E4480ACFB03053O00E3DE94632503084O005746E2F03D554103053O0099532O329603173O006E7E72187CBC695C78701940BF485C7A67145EAA4E4F7903073O002D3D16137C13CB025O00A4A840025O00B89F4003083O0074C921C80D49CB2603053O006427AC55BC030E3O00986BBCA836AC74AD8820B977B78503053O0053CD18D9E003083O00D5C0D929EFCBCA2E03043O005D86A5AD030D3O0096F7C0CE2EC6A16AB1FCC4EA0A03083O001EDE92A1A25AAED2027O004003083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC03123O0015A19549F16B6D2CBBB544F17C6B34A08D4803073O00185CCFE12C831903083O00D64B641EEC40771903043O006A852E1003113O00712E67F948524D3067CB5354501367E95403063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A9203163O0070585FF86794921B4D7945F16CB18F024D5347F4669203083O006B39362B9D15E6E7025O0062AD40025O0050854003083O002O0B96D2A336099103053O00CA586EE2A6030A3O00F61C87C5CBC00683FBD903053O00AAA36FE29703083O002235A62C47392E0203073O00497150D2582E57030B3O00B43FC826F58822C617F39203053O0087E14CAD72025O002OA040025O00208A4003083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD03103O0098CE15D87DF7A1D41EF748F9B9D41FFE03063O0096CDBD70901803083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FC1A06DFBF7281E41013DAB972A8D5120203073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F268421030F3O0084AC1048BFE5C89CA6054DB9E5E79C03073O00AFCCC97124D68B026O001440025O0072A240025O009C9040025O00F89B40025O002AA94003083O00192BC14F2320D24803043O003B4A4EB503083O0003D45354A702F27E03053O00D345B12O3A03083O0084E06DE1E0C5B0F603063O00ABD785199589030A3O00CAC131F1C036FA65C2EC03083O002281A8529A8F509C025O006BB140025O0016AE4003083O00C774E1B92C2380E703073O00E7941195CD454D030A3O002OB3C2FA5BEB2O88E8D803063O009FE0C7A79B3703083O00C4F628C6FEFD3BC103043O00B297935C030E3O00AFEF453F014374BAF44D3E356F5E03073O001AEC9D2C52722C03083O00B6B7271F41408E9603073O00E9E5D2536B282E030D3O00F25637D709D54A1DD003E6611603053O0065A12252B6026O001840026O000840025O0032A740025O00109D4003083O00EC1AE00833D118E703053O005ABF7F947C03133O00538E2A197D9E1D1F779307196C823C056D973A03043O007718E74E03083O00B128B15ED54E169103073O0071E24DC52ABC20030A3O000817F7BC3B1AE792193203043O00D55A769403083O00682BA042445529A703053O002D3B4ED436030D3O00225780828722BEDF1650A4A8A203083O00907036E3EBE64ECD03083O00802D1BE8D955B43B03063O003BD3486F9CB0030C3O007886ED245D8FCC2B48A0C00903043O004D2EE783025O0096A040025O00804340025O00A8A040025O0020694003083O008951A254B35AB15303043O0020DA34D603113O007D1F30ACFEA7615B40143487F7B662796A03083O003A2E7751C891D025026O001040025O00F2B040025O007DB14003083O000F341DAF10E52O2603083O00555C5169DB798B41030C3O00CE877D4358FEEE9760765FFB03063O00BF9DD330251C025O00109B40025O00B2AB4003083O0078D6AC5812734CC003063O001D2BB3D82C7B030D3O008DD6295FB2D71249BBCB255FB503043O002CDDB94003083O0032E25C4B7A0FE05B03053O00136187283F03133O009E533A28203F9C5935292A22A67F3C362D30BA03063O0051CE3C535B4F025O00949140026O005040025O001EA940025O004AAF4003083O007DAEC46626CD4AB703083O00C42ECBB0124FA32D030E3O008A23701921FFC2AD2E6A1700F4DB03073O008FD8421E7E449B03083O0099CD19DFCCADD0F203083O0081CAA86DABA5C3B703133O00174B32E8CC1DE9305123C1EC1BF2234C3ED7D003073O0086423857B8BE74025O00DEA240025O00C8844003083O003237122E540F351503053O003D6152665A03143O00812FB940C2531806BE0AAE4AD35F310FAA09886F03083O0069CC4ECB2BA7377E03083O0096AF370A1A0AC04203083O0031C5CA437E7364A7030D3O001449D6249359500152DE25A86603073O003E573BBF49E036025O00049140025O003AA14003083O00188924B8A0B3313803073O00564BEC50CCC9DD03103O0046497E96EA8777757284D18D746654A103063O00EB122117E59E03083O0063BFD5AF59B4C6A803043O00DB30DAA1030F3O00C77E704DF943EFEB75534FDD68C3C003073O008084111C29BB2F03083O00D407EEDDEE0CFDDA03043O00A987629A03073O00ED722D5AE91BF803073O00A8AB1744349D53025O00C4A040025O00A0834003083O00DB084DEAD2EC853D03083O004E886D399EBB82E203133O001B29F0E23D3AEBF02A3ADDDC1910FFF72D3AED03043O00915E5F9903083O00CEC800C147B9FADE03063O00D79DAD74B52E030C3O0006BCAFD7D93A9783F3C832B103053O00BA55D4EB9203083O00D127F348727FC1F103073O00A68242873C1B1103123O007742DB67392O4FC0413F5644CF713F6369EA03053O0050242AAE1503083O00F18402EA30E05FD103073O0038A2E1769E598E030F3O007E10D2A111D05D01CFB806D95206C503063O00B83C65A0CF4203083O00028768A8388C7BAF03043O00DC51E21C031A3O0023DA96F2E5C927CC92FED9C21FD0812OEFC320C080EFE6C207CC03063O00A773B5E29B8A00BC022O001270012O00014O003D2O0100023O002676012O0007000100010004813O000700010012702O0100014O003D010200023O001270012O00023O000E700002000200013O0004813O000200010026762O010009000100010004813O00090001001270010200013O0026760102004B000100030004813O004B0001001213000300044O005A000400013O00122O000500053O00122O000600066O0004000600024O0003000300044O000400013O00122O000500073O00122O000600086O0004000600024O0003000300042O005F00035O00122O000300046O000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C4O00750004000600024O0003000300044O000300023O00122O000300046O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300044O000400013O0012700105000F3O001270010600104O00750004000600024O0003000300044O000300033O00122O000300046O000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O000400013O001270010500133O001270010600144O00750004000600024O0003000300044O000300043O00122O000300046O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000400013O001270010500173O0012A5000600186O0004000600024O0003000300044O000300053O00044O00BB0201002676010200AB000100020004813O00AB0001001270010300013O0026F300030052000100010004813O00520001002E3F0119006E0001001A0004813O006E0001001213000400044O0018010500013O00122O0006001B3O00122O0007001C6O0005000700024O0004000400054O000500013O00122O0006001D3O00122O0007001E6O0005000700024O0004000400054O000400063O00122O000400046O000500013O00122O0006001F3O00122O000700206O0005000700024O0004000400054O000500013O00122O000600213O00122O000700226O0005000700024O00040004000500062O0004006C000100010004813O006C0001001270010400014O00BB000400073O001270010300023O000E7000230081000100030004813O00810001001213000400044O0040010500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000500013O00122O000600263O00122O000700276O0005000700024O00040004000500062O0004007E000100010004813O007E0001001270010400014O00BB000400083O001270010200233O0004813O00AB00010026760103004E000100020004813O004E0001001270010400013O002676010400A5000100010004813O00A50001001213000500044O0040010600013O00122O000700283O00122O000800296O0006000800024O0005000500064O000600013O00122O0007002A3O00122O0008002B6O0006000800024O00050005000600062O00050094000100010004813O00940001001270010500014O00BB000500093O0012C5000500046O000600013O00122O0007002C3O00122O0008002D6O0006000800024O0005000500064O000600013O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600062O000500A3000100010004813O00A30001001270010500014O00BB0005000A3O001270010400023O00267601040084000100020004813O00840001001270010300233O0004813O004E00010004813O008400010004813O004E0001000E74000100AF000100020004813O00AF0001002E3F013000072O0100310004813O00072O01001270010300013O002676010300CB000100010004813O00CB0001001213000400044O00D3000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O0004000B3O00122O000400046O000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000500013O00122O000600383O00122O000700396O0005000700024O0004000400054O0004000C3O00122O000300023O002676010300F3000100020004813O00F30001001270010400013O002EAC003B00D40001003A0004813O00D40001002676010400D4000100020004813O00D40001001270010300233O0004813O00F30001000E70000100CE000100040004813O00CE0001001213000500044O0018010600013O00122O0007003C3O00122O0008003D6O0006000800024O0005000500064O000600013O00122O0007003E3O00122O0008003F6O0006000800024O0005000500064O0005000D3O00122O000500046O000600013O00122O000700403O00122O000800416O0006000800024O0005000500064O000600013O00122O000700423O00122O000800436O0006000800024O00050005000600062O000500F0000100010004813O00F00001001270010500014O00BB0005000E3O001270010400023O0004813O00CE0001002676010300B0000100230004813O00B00001001213000400044O0040010500013O00122O000600443O00122O000700456O0005000700024O0004000400054O000500013O00122O000600463O00122O000700476O0005000700024O00040004000500062O000400032O0100010004813O00032O01001270010400014O00BB0004000F3O001270010200023O0004813O00072O010004813O00B000010026F30002000B2O0100480004813O000B2O01002E3F0149005F2O01004A0004813O005F2O01001270010300013O002676010300332O0100020004813O00332O01001270010400013O0026F3000400132O0100010004813O00132O01002E3F014C002C2O01004B0004813O002C2O01001213000500044O00D3000600013O00122O0007004D3O00122O0008004E6O0006000800024O0005000500064O000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O000500103O00122O000500046O000600013O00122O000700513O00122O000800526O0006000800024O0005000500064O000600013O00122O000700533O00122O000800546O0006000800024O0005000500064O000500113O00122O000400023O002E3F0156000F2O0100550004813O000F2O010026760104000F2O0100020004813O000F2O01001270010300233O0004813O00332O010004813O000F2O010026760103004E2O0100010004813O004E2O01001213000400044O00D3000500013O00122O000600573O00122O000700586O0005000700024O0004000400054O000500013O00122O000600593O00122O0007005A6O0005000700024O0004000400054O000400123O00122O000400046O000500013O00122O0006005B3O00122O0007005C6O0005000700024O0004000400054O000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O000400133O00122O000300023O0026760103000C2O0100230004813O000C2O01001213000400044O00F2000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000500013O00122O000600613O00122O000700626O0005000700024O0004000400054O000400143O00122O000200633O00044O005F2O010004813O000C2O01000E74006400632O0100020004813O00632O01002E3F016500B72O0100660004813O00B72O01001270010300013O0026760103007F2O0100010004813O007F2O01001213000400044O00D3000500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O000400153O00122O000400046O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400054O000400163O00122O000300023O000E70000200A42O0100030004813O00A42O01001270010400013O0026760104009D2O0100010004813O009D2O01001213000500044O00D3000600013O00122O0007006F3O00122O000800706O0006000800024O0005000500064O000600013O00122O000700713O00122O000800726O0006000800024O0005000500064O000500173O00122O000500046O000600013O00122O000700733O00122O000800746O0006000800024O0005000500064O000600013O00122O000700753O00122O000800766O0006000800024O0005000500064O000500183O00122O000400023O0026F3000400A12O0100020004813O00A12O01002E10017700E3FF2O00780004813O00822O01001270010300233O0004813O00A42O010004813O00822O010026F3000300A82O0100230004813O00A82O01002E3F017900642O01007A0004813O00642O01001213000400044O00F2000500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400054O000500013O00122O0006007D3O00122O0007007E6O0005000700024O0004000400054O000400193O00122O0002007F3O00044O00B72O010004813O00642O0100267601020019020100230004813O00190201001270010300013O000E74002300BE2O0100030004813O00BE2O01002E3F018100CC2O0100800004813O00CC2O01001213000400044O00F2000500013O00122O000600823O00122O000700836O0005000700024O0004000400054O000500013O00122O000600843O00122O000700856O0005000700024O0004000400054O0004001A3O00122O000200643O00044O001902010026F3000300D02O0100010004813O00D02O01002E3F018700F32O0100860004813O00F32O01001270010400013O002676010400EC2O0100010004813O00EC2O01001213000500044O00D3000600013O00122O000700883O00122O000800896O0006000800024O0005000500064O000600013O00122O0007008A3O00122O0008008B6O0006000800024O0005000500064O0005001B3O00122O000500046O000600013O00122O0007008C3O00122O0008008D6O0006000800024O0005000500064O000600013O00122O0007008E3O00122O0008008F6O0006000800024O0005000500064O0005001C3O00122O000400023O002E3F019100D12O0100900004813O00D12O01002676010400D12O0100020004813O00D12O01001270010300023O0004813O00F32O010004813O00D12O01002676010300BA2O0100020004813O00BA2O01001270010400013O0026F3000400FA2O0100010004813O00FA2O01002EAC00930013020100920004813O00130201001213000500044O00D3000600013O00122O000700943O00122O000800956O0006000800024O0005000500064O000600013O00122O000700963O00122O000800976O0006000800024O0005000500064O0005001D3O00122O000500046O000600013O00122O000700983O00122O000800996O0006000800024O0005000500064O000600013O00122O0007009A3O00122O0008009B6O0006000800024O0005000500064O0005001E3O00122O000400023O002676010400F62O0100020004813O00F62O01001270010300233O0004813O00BA2O010004813O00F62O010004813O00BA2O01002EAC009D00670201009C0004813O00670201002676010200670201007F0004813O00670201001270010300013O00267601030039020100020004813O00390201001213000400044O00D3000500013O00122O0006009E3O00122O0007009F6O0005000700024O0004000400054O000500013O00122O000600A03O00122O000700A16O0005000700024O0004000400054O0004001F3O00122O000400046O000500013O00122O000600A23O00122O000700A36O0005000700024O0004000400054O000500013O00122O000600A43O00122O000700A56O0005000700024O0004000400054O000400203O00122O000300233O000E740001003D020100030004813O003D0201002EAC00A70056020100A60004813O00560201001213000400044O00D3000500013O00122O000600A83O00122O000700A96O0005000700024O0004000400054O000500013O00122O000600AA3O00122O000700AB6O0005000700024O0004000400054O000400213O00122O000400046O000500013O00122O000600AC3O00122O000700AD6O0005000700024O0004000400054O000500013O00122O000600AE3O00122O000700AF6O0005000700024O0004000400054O000400223O00122O000300023O0026760103001E020100230004813O001E0201001213000400044O00F2000500013O00122O000600B03O00122O000700B16O0005000700024O0004000400054O000500013O00122O000600B23O00122O000700B36O0005000700024O0004000400054O000400233O00122O000200483O00044O006702010004813O001E02010026760102000C000100630004813O000C0001001270010300013O000E740001006E020100030004813O006E0201002E3F01B4008A020100B50004813O008A0201001213000400044O0040010500013O00122O000600B63O00122O000700B76O0005000700024O0004000400054O000500013O00122O000600B83O00122O000700B96O0005000700024O00040004000500062O0004007C020100010004813O007C02012O0076000400014O00BB000400243O001201000400046O000500013O00122O000600BA3O00122O000700BB6O0005000700024O0004000400054O000500013O00122O000600BC3O00122O000700BD6O0005000700022O00630004000400052O00BB000400253O001270010300023O0026760103009A020100230004813O009A0201001213000400044O00F2000500013O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000500013O00122O000600C03O00122O000700C16O0005000700024O0004000400054O000400263O00122O000200033O00044O000C00010026760103006A020100020004813O006A0201001213000400044O00D3000500013O00122O000600C23O00122O000700C36O0005000700024O0004000400054O000500013O00122O000600C43O00122O000700C56O0005000700024O0004000400054O000400273O00122O000400046O000500013O00122O000600C63O00122O000700C76O0005000700024O0004000400054O000500013O00122O000600C83O00122O000700C96O0005000700024O0004000400054O000400283O00122O000300233O0004813O006A02010004813O000C00010004813O00BB02010004813O000900010004813O00BB02010004813O000200012O003E012O00017O001A3O0003143O00412O7461636B506F77657244616D6167654D6F6402BA490C022B87C63F025C8FC2F5285CF33F030C3O0021AF2A77F3FB1BA72174E2FA03063O00886FC64D1F87030B3O004973417661696C61626C6503093O00537465616C746855700248E17A14AE47F13F026O00F03F030F3O00260CA246B8F624BD1008B357BAE11A03083O00C96269C736DD847702CD5OCCF03F030A3O009D0D912A313DADBD039403073O00CCD96CE341625503063O0042752O665570030F3O00536861646F7744616E636542752O6602CD5OCCF43F030E3O0053796D626F6C736F66446561746802009A4O99F13F03163O0046696E616C6974794576697363657261746542752O66030A3O004D617374657279506374026O00594003113O00566572736174696C697479446D6750637403083O00446562752O66557003123O0046696E645765616B6E652O73446562752O66026O00F83F007E4O00567O00206O00016O000200024O000100019O00000100206O000200206O00032O00392O0100026O000200033O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O00010002000200062O0001001B00013O0004813O001B00012O000E00015O00205F2O01000100074O000300016O00048O00010004000200062O0001001B00013O0004813O001B00010012702O0100083O0006400001001C000100010004813O001C00010012702O0100094O00955O00012O00392O0100026O000200033O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O0001000100064O00010002000200062O0001002A00013O0004813O002A00010012702O01000C3O0006400001002B000100010004813O002B00010012702O0100094O00955O00012O00392O0100026O000200033O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O0001000100064O00010002000200062O0001004000013O0004813O004000012O000E00015O0020652O010001000F4O000300023O00202O0003000300104O00010003000200062O0001004000013O0004813O004000010012702O0100113O00064000010041000100010004813O004100010012702O0100094O00955O00012O00662O015O00202O00010001000F4O000300023O00202O0003000300124O00010003000200062O0001004C00013O0004813O004C00010012702O0100133O0006400001004D000100010004813O004D00010012702O0100094O00955O00012O00662O015O00202O00010001000F4O000300023O00202O0003000300144O00010003000200062O0001005800013O0004813O005800010012702O0100113O00064000010059000100010004813O005900010012702O0100094O00955O00012O007C2O015O00202O0001000100154O00010002000200202O00010001001600102O0001000900018O00014O000100043O00122O000200096O00035O00202O0003000300172O00160103000200020020190103000300164O0001000300024O000200053O00122O000300096O00045O00202O0004000400174O00040002000200202O0004000400164O0002000400024O0001000100022O00955O00012O00662O0100063O00202O0001000100184O000300023O00202O0003000300194O00010003000200062O0001007A00013O0004813O007A00010012702O01001A3O0006400001007B000100010004813O007B00010012702O0100094O00955O00012O007A012O00024O003E012O00017O00043O0003063O0042752O66557003133O0046696E616C6974795275707475726542752O6602CD5OCCF43F026O00F03F000D4O0066016O00206O00014O000200013O00202O0002000200026O0002000200064O000A00013O0004813O000A0001001270012O00033O0006403O000B000100010004813O000B0001001270012O00044O007A012O00024O003E012O00017O00023O00025O00AEAA40025O0061B14001074O000E00015O0006270001000500013O0004813O00050001002E3F01020006000100010004813O000600012O00BB8O003E012O00017O00083O0003193O00F9AE4D0DCCC5B3083C83D8AF196FCAD8E0293ACDD1A50221D003053O00A3B6C06D4F030F3O004973496E44756E67656F6E41726561025O00949B40025O00D6B04003063O00152A17C1EC2703053O0095544660A0030C3O004973496E426F2O734C69737400234O000E8O006A000100013O00122O000200013O00122O000300026O00010003000200064O000C000100010004813O000C00012O000E3O00023O002069014O00032O0016012O000200020006403O000E000100010004813O000E0001002EAC00050011000100040004813O001100012O00768O007A012O00023O0004813O002200012O000E8O0078000100013O00122O000200063O00122O000300076O00010003000200064O0020000100010004813O002000012O000E3O00033O002069014O00082O0016012O000200020006403O0020000100010004813O002000012O00768O007A012O00023O0004813O002200012O00763O00014O007A012O00024O003E012O00017O001A3O00028O00025O00508C40026O006940027O004003063O00190A1AEC211503043O008D58666D026O00A840025O00AAA040025O00408C40025O00E0954003093O009C5D8A52152E46C4A003083O00A1D333AA107A5D35030C3O004973496E426F2O734C69737403043O00DABBA62703043O00489BCED2025O00708640025O002EAE4003123O00496E7374616E636544692O666963756C7479026O00304003053O004E50434944024O00B8F60041024O00C8610441024O00D8610441024O00D0610441024O0038650641024O00B86B0641006A3O001270012O00014O003D2O0100013O002676012O0002000100010004813O000200010012702O0100013O0026762O010005000100010004813O00050001001270010200013O002EAC00030008000100020004813O0008000100267601020008000100010004813O000800012O000E00035O00266700030012000100040004813O001200012O007600036O007A010300023O0004813O006300012O000E000300014O0078000400023O00122O000500053O00122O000600066O00040006000200062O0003001B000100040004813O001B0001002E3F0107001E000100080004813O001E00012O0076000300014O007A010300023O0004813O00630001002E3F0109002F0001000A0004813O002F00012O000E000300014O006A000400023O00122O0005000B3O00122O0006000C6O00040006000200062O0003002F000100040004813O002F00012O000E000300033O00206901030003000D2O00160103000200020006270003002F00013O0004813O002F00012O0076000300014O007A010300023O0004813O006300012O000E000300014O0078000400023O00122O0005000E3O00122O0006000F6O00040006000200062O00030038000100040004813O00380001002EAC00110063000100100004813O006300012O000E000300043O0020690103000300122O001601030002000200267601030045000100130004813O004500012O000E000300033O0020690103000300142O001601030002000200267601030045000100150004813O004500012O0076000300014O007A010300023O0004813O006300012O000E000300033O0020690103000300142O00160103000200020026F300030054000100160004813O005400012O000E000300033O0020690103000300142O00160103000200020026F300030054000100170004813O005400012O000E000300033O0020690103000300142O001601030002000200267601030057000100180004813O005700012O0076000300014O007A010300023O0004813O006300012O000E000300033O0020690103000300142O00160103000200020026F300030061000100190004813O006100012O000E000300033O0020690103000300142O0016010300020002002676010300630001001A0004813O006300012O0076000300014O007A010300024O007600036O007A010300023O0004813O000800010004813O000500010004813O006900010004813O000200012O003E012O00017O00183O00028O00026O00F03F027O0040025O0066A340025O005EA14003043O004755494403103O00556E697449734379636C6556616C6964030D3O00446562752O6652656D61696E7303093O0054696D65546F44696503063O00457869737473025O00F49540025O00E8894003103O004275404E20567F580273527B4609365203053O0053261A346E025O001AAA40025O002EAE4003133O005C1833064B07224A54572A494D0422494E123503043O0026387747026O00AE40025O00408F40025O00C8A440025O00D09D40025O00E0A140025O009EA34005883O001270010500014O003D010600093O00267601050006000100020004813O000600012O003D010800093O001270010500033O0026F30005000A000100010004813O000A0001002E1001040005000100050004813O000D0001001270010600014O003D010700073O001270010500023O00267601050002000100030004813O00020001000E700002006C000100060004813O006C00012O000E000A6O00F6000B00034O00A7000A0002000C0004813O002E0001002069010F000E00062O0016010F00020002000602000F002E000100090004813O002E00012O000E000F00013O002042010F000F00074O0010000E6O001100083O00202O0012000E00084O00148O0012001400024O001200126O000F0012000200062O000F002E00013O0004813O002E00012O00F6000F00014O00F60010000E4O0016010F00020002000627000F002E00013O0004813O002E00012O00F6000F000E3O0020690110000E00092O00160110000200022O00F6000800104O00F60007000F3O0006D1000A0015000100020004813O001500010006270007004E00013O0004813O004E00012O000E000A00023O000627000A004E00013O0004813O004E00012O000E000A00023O002069010A000A000A2O0016010A00020002000627000A004E00013O0004813O004E0001002069010A000700062O00C0000A000200024O000B00023O00202O000B000B00064O000B0002000200062O000A004E0001000B0004813O004E0001002E3F010C00870001000B0004813O008700012O000E000A00034O00F6000B6O0016010A00020002000627000A008700013O0004813O008700012O000E000A00043O001227010B000D3O00122O000C000E6O000A000C6O000A5O00044O008700010006270007008700013O0004813O008700012O000E000A00053O000627000A008700013O0004813O008700012O000E000A00053O002069010A000A000A2O0016010A00020002000627000A008700013O0004813O00870001002069010A000700062O00C0000A000200024O000B00053O00202O000B000B00064O000B0002000200062O000A00870001000B0004813O00870001002EAC000F0087000100100004813O008700012O000E000A00034O00F6000B00044O0016010A00020002000627000A008700013O0004813O008700012O000E000A00043O001227010B00113O00122O000C00126O000A000C6O000A5O00044O00870001002EAC0014000F000100130004813O000F00010026760106000F000100010004813O000F0001001270010A00013O0026F3000A0075000100010004813O00750001002EAC0015007D000100160004813O007D00012O003D010B000B4O0068000800026O0007000B6O000B00023O00202O000B000B00064O000B000200024O0009000B3O00122O000A00023O0026F3000A0081000100020004813O00810001002EAC00180071000100170004813O00710001001270010600023O0004813O000F00010004813O007100010004813O000F00010004813O008700010004813O000200012O003E012O00017O000C3O00026O00394003053O00C5E65FD93703063O0036938F38B645030B3O004973417661696C61626C65026O003440030F3O00FB80EC5DDAC48EF97A2OD785F05ECC03053O00BFB6E19F29030B3O00181A29518490E424113D4603073O00A24B724835EBE703083O00AD3045E1410B982503063O0062EC5C248233026O0010400009013O0036019O00018O00025O00122O000300016O000400016O000500026O000600033O00122O000700023O00122O000800036O0006000800024O00050005000600202O0005000500044O000500066O00043O000200202O0004000400054O0002000400024O000300043O00122O000400016O000500016O000600026O000700033O00122O000800023O00122O000900036O0007000900024O00060006000700202O0006000600044O000600076O00053O000200202O0005000500054O0003000500024O0002000200034O000300016O000400026O000500033O00122O000600063O00122O000700076O0005000700024O00040004000500202O0004000400044O000400056O00033O000200202O0003000300054O0002000200034O000300016O000400026O000500033O00122O000600083O00122O000700096O0005000700024O00040004000500202O0004000400044O000400056O00033O000200202O0003000300014O0001000300024O000200046O00035O00122O000400016O000500016O000600026O000700033O00122O000800023O00122O000900036O0007000900024O00060006000700202O0006000600044O000600076O00053O000200202O0005000500054O0003000500024O000400043O00122O000500016O000600016O000700026O000800033O00122O000900023O00122O000A00036O0008000A00024O00070007000800202O0007000700042O0071010700084O002501063O000200202O0006000600054O0004000600024O0003000300044O000400016O000500026O000600033O00122O000700063O00122O000800076O0006000800024O00050005000600202O0005000500044O000500066O00043O000200202O0004000400054O0003000300044O000400016O000500026O000600033O00122O000700083O00122O000800096O0006000800024O00050005000600202O0005000500044O000500066O00043O000200202O0004000400014O0002000400024O0001000100024O000200016O000300026O000400033O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O0003000300044O000300046O00023O000200202O0002000200054O0001000100024O000200016O000300053O000E2O000C007F000100030004813O007F00012O009C00036O0076000300014O007300020002000200202O0002000200016O000200024O000100046O00028O00035O00122O000400016O000500016O000600026O000700033O00122O000800023O00122O000900036O0007000900024O00060006000700202O0006000600044O000600076O00053O000200202O0005000500054O0003000500024O000400043O00122O000500016O000600016O000700026O000800033O00122O000900023O00122O000A00036O0008000A00024O00070007000800202O0007000700044O000700086O00063O000200202O0006000600054O0004000600024O0003000300044O000400016O000500026O000600033O00122O000700063O00122O000800076O0006000800024O00050005000600202O0005000500044O000500066O00043O000200202O0004000400054O0003000300044O000400016O000500026O000600033O00122O000700083O00122O000800096O0006000800024O00050005000600202O0005000500044O000500066O00043O000200202O0004000400014O0002000400024O000300046O00045O00122O000500016O000600016O000700026O000800033O00122O000900023O00122O000A00036O0008000A00024O00070007000800202O0007000700044O000700086O00063O000200202O0006000600054O0004000600024O000500043O00122O000600016O000700016O000800026O000900033O00122O000A00023O00122O000B00034O00710009000B00022O00630008000800090020690108000800042O0071010800094O002501073O000200202O0007000700054O0005000700024O0004000400054O000500016O000600026O000700033O00122O000800063O00122O000900076O0007000900024O00060006000700202O0006000600044O000600076O00053O000200202O0005000500054O0004000400054O000500016O000600026O000700033O00122O000800083O00122O000900096O0007000900024O00060006000700202O0006000600044O000600076O00053O000200202O0005000500014O0003000500024O0002000200034O000300016O000400026O000500033O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O0004000400044O000400056O00033O000200202O0003000300054O0002000200034O000300016O000400053O000E2O000C00022O0100040004813O00022O012O009C00046O0076000400014O002601030002000200202O0003000300014O0001000300028O00016O00028O00017O00073O00030B3O0097110DBE4ABF9131AA1A0903083O0050C4796CDA25C8D503113O00436861726765734672616374696F6E616C026O00E83F03113O00337B037B4419AE017D017A7F0F86057D1603073O00EA6013621F2B6E030B3O004973417661696C61626C6500294O000E8O006C000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O000200022O00522O0100023O00122O000200046O000300036O00048O000500013O00122O000600053O00122O000700066O0005000700024O00040004000500202O0004000400072O0071010400054O004700038O00013O00024O000200043O00122O000300046O000400036O00058O000600013O00122O000700053O00122O000800066O0006000800022O006300050005000600207F0105000500074O000500066O00048O00023O00024O00010001000200062O0001000200013O0004813O002600012O009C8O00763O00014O007A012O00024O003E012O00017O000A3O0003083O00351A53CB8A739F2O03073O00EB667F32A7CC12030B3O004973417661696C61626C65026O001040025O0010AC40025O0039B140030F3O0063A9E0314D2555AFC12C562051A5FA03063O004E30C1954324027O0040026O00F03F00364O001A9O00000100016O000200026O000300033O00122O000400013O00122O000500026O0003000500024O00020002000300202O0002000200034O000200036O00013O000200102O00010004000100064O0010000100010004813O00100001002E3F01060013000100050004813O001300012O00763O00014O007A012O00023O0004813O003500012O000E8O0006000100046O000200026O000300033O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200034O000200036O00013O000200102O00010009000100102O00010004000100062O0001002800013O0004813O002800012O000E3O00053O0006273O002F00013O0004813O002F00012O000E7O000EB30004002F00013O0004813O002F00012O000E3O00063O0026343O002C0001000A0004813O002C00012O009C8O00763O00014O007A012O00023O0004813O003500012O000E3O00073O0026343O00330001000A0004813O003300012O009C8O00763O00014O007A012O00024O003E012O00017O00033O0003063O0042752O665570030C3O00536C696365616E6444696365030A3O0043504D61785370656E6400114O0022016O00206O00014O000200013O00202O0002000200026O0002000200064O000F000100010004813O000F00012O000E3O00024O000E000100033O0020850001000100032O00B600010001000200065C2O01000200013O0004813O000E00012O009C8O00763O00014O007A012O00024O003E012O00017O00063O0003063O0042752O665570030A3O0054686973746C65546561026O00F03F03083O00446562752O66557003073O0052757074757265027O0040011D4O00662O015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O0001000A00013O0004813O000A00012O000E000100023O0026F30001001A000100030004813O001A000100061D2O01001B00013O0004813O001B00012O000E000100023O0026F30001001A000100030004813O001A00012O000E000100033O0020652O01000100044O000300013O00202O0003000300054O00010003000200062O0001001B00013O0004813O001B00012O000E000100023O000E290106001A000100010004813O001A00012O009C00016O0076000100014O007A2O0100024O003E012O00017O00063O0003063O0042752O665570030D3O005072656D656469746174696F6E026O00F03F03093O000416852A4E240A851603053O0021507EE078030B3O004973417661696C61626C65001B4O0022016O00206O00014O000200013O00202O0002000200026O0002000200064O000A000100010004813O000A00012O000E3O00023O0026F33O0018000100030004813O001800012O000E3O00014O00502O0100033O00122O000200043O00122O000300056O0001000300028O000100206O00066O0002000200064O001800013O0004813O001800012O000E3O00023O000E720003001800013O0004813O001800012O009C8O00763O00014O007A012O00024O003E012O00017O00083O0003083O0042752O66446F776E03113O005072656D656469746174696F6E42752O66026O00F03F027O004003063O0042752O665570030D3O00546865526F2O74656E42752O6603073O0048617354696572026O003E40001F4O0022016O00206O00014O000200013O00202O0002000200026O0002000200064O001D000100010004813O001D00012O000E3O00023O000E720003001C00013O0004813O001C00012O000E3O00033O00264A3O001B000100040004813O001B00012O000E7O002065014O00054O000200013O00202O0002000200066O0002000200064O001D00013O0004813O001D00012O000E7O0020E45O000700122O000200083O00122O000300048O000300029O0000044O001D00012O009C8O00763O00014O007A012O00024O003E012O00017O00073O0003093O0042752O66537461636B03103O0044616E73654D61636162726542752O66026O000840030C3O00C8A90DD759C1A900C55EFEAD03053O003C8CC863A4030B3O004973417661696C61626C65027O0040021C3O00061D0102001A00013O0004813O001A00012O000E00025O0020550102000200014O000400013O00202O0004000400024O000200040002000E2O00030013000100020004813O001300012O000E000200014O003E000300023O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O00020018000100010004813O001800010006270001001900013O0004813O001900012O000E000200033O00267601020019000100070004813O001900012O009C00026O0076000200014O007A010200024O003E012O00017O00053O0003063O0042752O665570030F3O00536861646F7744616E636542752O6603113O0054696D6553696E63654C61737443617374030B3O00B4FC0522AD90D00528A18203053O00C2E794644601174O00662O015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O0001001500013O0004813O001500010020692O013O00032O00162O01000200022O000E000200014O006C000300023O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200034O0002000200020006842O010014000100020004813O001400012O009C00016O0076000100014O007A2O0100024O003E012O00017O00E43O00028O00025O00E9B240025O005EA740026O00F03F027O0040025O005EA640025O00D8A340025O00E2A740025O00D6B240026O000840025O0050B240025O00449740026O008A40025O00A2B240025O00389E4003063O0042752O66557003113O005072656D656469746174696F6E42752O66030D3O00765EC4AEF3CC4F58C0B7FFC74803063O00A8262CA1C396030B3O004973417661696C61626C6503023O004944030B3O00B3F483723FFF92178EFF8703083O0076E09CE2165088D6025O00ACB140025O0074A440025O0046B040025O0049B040026O00204003133O006BE349924DF85C8471E658844DF97D814CED5C03043O00E0228E39030A3O0054616C656E7452616E6B025O001AAD40025O00805540030D3O00EAAFC0FB7AE34E1AFAA6CBDE7603083O006EBEC7A5BD13913D025O00206340030E3O00436F6D626F506F696E74734D6178026O00104003073O0048617354696572026O003E40026O001840030C3O00E9E77EEB8EC6D4EF53E188C203063O00A7BA8B1788EB030A3O0049734361737461626C6503143O0046696C7465726564466967687452656D61696E7303013O003E030B3O0042752O6652656D61696E73030C3O00536C696365616E6444696365025O00609C40025O00EAA140030D3O002AA78D001FB181191BA181021403043O006D7AD5E8026O001440030B3O00DDFFA334E1E08631E0F4A703043O00508E97C203113O00436861726765734672616374696F6E616C026O00FC3F030E3O0030DF7A4E0CCA644305E2724D17CE03043O002C63A617030F3O00432O6F6C646F776E52656D61696E73030B3O004FFF28323CB358F627353603063O00C41C9749565303073O0043686172676573026O33F33F030C3O00C00F201387591672D70A2A1503083O001693634970E23878030C3O008B79EBF688B97BE6D184BB7003053O00EDD815829503073O004973526561647903043O0043617374031C3O00A14F4C4BF0FA528B4D5A1FB1C75AC26A565CB58916B25C5A52B5CD1703073O003EE22E2O3FD0A902CD5OCCFC3F030C3O00D6155C801A0C215AC110568603083O003E857935E37F6D4F030C3O0023183BF6D3AFAC14303BF6D303073O00C270745295B6CE03133O001AA95F0C80D10230AB4958C1EC0A798C451BC503073O006E59C82C78A082025O000EA640025O001AA940030E3O0053796D626F6C736F664465617468025O005EB240025O00AAA040030F3O00536861646F7744616E636542752O66025O000EAA40025O0002A940025O0026AA40025O00D09640025O0053B240025O0013B140025O00208340025O00E8B240025O004AB04003073O0099D65B5256583E03083O002DCBA32B26232A5B03113O00446562752O665265667265736861626C6503073O005275707475726503113O0046696C746572656454696D65546F446965030D3O00446562752O6652656D61696E7303133O0054696D65546F44696549734E6F7456616C6964030A3O0043616E446F54556E697403073O00E090CC3792BB5103073O0034B2E5BC43E7C9025O0008954003073O0013544010E24E2603073O004341213064973C030E3O00FCE6BDCCB3EDF2BECCE6CDE2EE8903053O0093BF87CEB803073O00B63DB6D5CD41B703073O00D2E448C6A1B833025O0098A740025O007EA54003133O0046696E616C6974795275707475726542752O6603083O001248E11B51DC335E03063O00AE5629937013030C3O007F018318202210A85A029F0E03083O00CB3B60ED6B456F71030B3O00171EADE53EE7F32518AFE403073O00B74476CC815190026O002840030B3O003DA571E004952AAC7EE70E03063O00E26ECD10846B03073O00D9D6F0CD54F9C603053O00218BA380B903073O00654D14CA424A0103043O00BE37386403173O0075AE2F0A53D1E646BB290C16A3BB70A6322O1FEAE74FE603073O009336CF5C7E7383025O00E0AD40025O00A6AC40025O00D0A740025O00ECAD4003093O002E3E39792F72023E3103063O001E6D51551D6D030F3O00CC7457A433CAC8FA725CB83FCFE9FA03073O009C9F1134D656BE025O008AA040025O00689040030F3O009DEABEAEABFB89B9ADE7B3B5BFFAB803043O00DCCE8FDD030F3O00536563726574546563686E69717565025O002C9140025O00489C40030F3O00A57C3E0398EFDD8A796D35D4C3DD8203073O00B2E61D4D77B8AC030F3O00C6BB2O0972ECC1BB091379F1E4AB0F03063O009895DE6A7B1703093O00FE29FA4797D129F94703053O00D5BD46962303093O006C5A780C6D597B074B03043O00682F351403093O00436F6C64426C2O6F6403093O0080438D189E03AC438503063O006FC32CE17CDC025O001CB340025O00F8AC40025O00B2A240025O00488340030F3O00EB430361AEBFEC43037BA5A2C9530503063O00CBB8266013CB03153O001A726A558E0A767A53CB2D334D44CD317D7050DB3C03053O00AE59131921025O00209540025O00DCA240025O00C09840025O00D6A140025O0032A040025O003AA640030A3O00C22CE263E43FF971F33F03043O0010875A8B030A3O0071620F204D516A55602O03073O0018341466532E34025O009CA640025O00BAA940030A3O00E13928370CC13D20300A03053O006FA44F4144030A3O0045766973636572617465030F3O00E5D890CA6ECF2OD090DD2BF8C7CD8603063O008AA6B9E3BE4E03073O001D07425AE2950E03073O006B4F72322E97E7025O00EC9340025O00708D40025O00989240025O000CB040025O00C8A240025O0056A340025O0068A040025O00D88340025O002EA740025O0080684003103O00527570747572654D6F7573656F766572025O0051B240025O00CEA740030E3O000ABFB82B8535A4CF3F82B0289E3103083O00A059C6D549EA59D7026O002440030E3O007B68B9FCCA4462BBF8E14D70A0F603053O00A52811D49E030E3O00D6C0053129E9CA073502E0D81C3B03053O004685B96853025O00607A40025O00B0794003073O003650543EDC164003053O00A96425244A03073O003292B2441595A703043O003060E7C2025O0058A340025O002OA640030E3O00EB5B1D3959EABA93DC4F1C28598A03083O00E3A83A6E4D79B8CF025O00809440030B3O005930BE43BAEB7EB27F39AD03083O00C51B5CDF20D1BB11030C3O00275ECDE80672C2F8025DD1FE03043O009B633FA3030B3O00426C61636B506F77646572025O005EAB40025O0098AA40030B3O00A0DDA08EB2B48DC6A588AB03063O00E4E2B1C1EDD9025O00D8A140025O00A4B040030B3O0016BC22E53F802CF130B53103043O008654D04303113O0030AD9548538E8A5D10A7C66C1CBB82590103043O003C73CCE60259042O001270010200014O003D010300093O0026F300020006000100010004813O00060001002EAC00020009000100030004813O00090001001270010300014O003D010400043O001270010200043O0026F30002000D000100050004813O000D0001002E3F01060019000100070004813O00190001001270010A00013O002E3F01080014000100090004813O00140001002676010A0014000100010004813O001400012O003D010700083O001270010A00043O002676010A000E000100040004813O000E00010012700102000A3O0004813O001900010004813O000E00010026F30002001D000100040004813O001D0001002EAC000B001F0001000C0004813O001F00012O003D010500063O001270010200053O002676010200020001000A0004813O000200012O003D010900093O001270010A00013O002676010A00772O0100040004813O00772O010026F300030029000100040004813O00290001002E3F010E004F2O01000D0004813O004F2O01001270010B00013O002E10010F00780001000F0004813O00A20001002676010B00A2000100010004813O00A200012O000E000C5O00203C010C000C00104O000E00013O00202O000E000E00114O000C000E000200062O000800400001000C0004813O0040000100061D01080040000100010004813O004000012O000E000C00014O006C000D00023O00122O000E00123O00122O000F00136O000D000F00024O000C000C000D00202O000C000C00144O000C000200022O00F60008000C3O000627000100A100013O0004813O00A10001002069010C000100152O00DB000C000200024O000D00016O000E00023O00122O000F00163O00122O001000176O000E001000024O000D000D000E00202O000D000D00154O000D0002000200062O000C00A10001000D0004813O00A10001001270010C00014O003D010D000D3O000E74000100540001000C0004813O00540001002E3F01180050000100190004813O00500001001270010D00013O000E74000100590001000D0004813O00590001002E3F011B00720001001A0004813O007200012O0076000400014O004C000E00033O00122O000F001C6O001000016O001100023O00122O0012001D3O00122O0013001E6O0011001300024O00100010001100202O00100010001F4O001000114O00D8000E3O00022O004C000F00043O00122O0010001C6O001100016O001200023O00122O0013001D3O00122O0014001E6O0012001400024O00110011001200202O00110011001F4O001100124O00D8000F3O00022O004B0105000E000F001270010D00043O000E74000400760001000D0004813O00760001002EAC00200055000100210004813O005500012O000E000E00014O003E000F00023O00122O001000223O00122O001100236O000F001100024O000E000E000F00202O000E000E00144O000E0002000200062O000E0082000100010004813O00820001002E3F01090091000100240004813O009100012O000E000E00054O007F000F5O00202O000F000F00254O000F000200024O001000036O001100063O00122O001200266O0010001200024O001100046O001200063O00122O001300264O00710011001300022O004B0110001000112O0071000E001000022O00F60007000E4O000E000E5O002017000E000E002700122O001000283O00122O001100056O000E0011000200062O000E00A100013O0004813O00A100012O000E000E00074O004D010F00063O00122O001000296O000E001000024O0006000E3O00044O00A100010004813O005500010004813O00A100010004813O00500001001270010B00043O002676010B00A6000100050004813O00A60001001270010300053O0004813O004F2O01002676010B002A000100040004813O002A00012O000E000C00014O0050010D00023O00122O000E002A3O00122O000F002B6O000D000F00024O000C000C000D00202O000C000C002C4O000C0002000200062O000C00BE00013O0004813O00BE00012O000E000C00083O002057000C000C002D4O000D00093O00122O000E002E6O000F5O00202O000F000F002F4O001100013O00202O0011001100304O000F00116O000C3O000200062O000C00C0000100010004813O00C00001002EAC003200492O0100310004813O00492O012O000E000C00014O0050010D00023O00122O000E00333O00122O000F00346O000D000F00024O000C000C000D00202O000C000C00144O000C0002000200062O000C00142O013O0004813O00142O012O000E000C000A3O002667000C00142O0100350004813O00142O012O000E000C00014O00B5000D00023O00122O000E00363O00122O000F00376O000D000F00024O000C000C000D00202O000C000C00384O000C0002000200262O000C00492O0100390004813O00492O012O000E000C5O0020B4000C000C002F4O000E00013O00202O000E000E00304O000C000E00024O000D00016O000E00023O00122O000F003A3O00122O0010003B6O000E001000024O000D000D000E00202O000D000D003C4O000D0002000200062O000C00492O01000D0004813O00492O012O000E000C00014O0009000D00023O00122O000E003D3O00122O000F003E6O000D000F00024O000C000C000D00202O000C000C003F4O000C00020002000E2O000400492O01000C0004813O00492O012O001F010C00060005002667000C00492O0100400004813O00492O010006273O00FD00013O0004813O00FD00012O000E000C00014O00BF000D00023O00122O000E00413O00122O000F00426O000D000F00024O000C000C000D4O000C00023O00044O00492O012O000E000C00014O0050010D00023O00122O000E00433O00122O000F00446O000D000F00024O000C000C000D00202O000C000C00454O000C0002000200062O000C00492O013O0004813O00492O012O000E000C00083O0020F1000C000C00464O000D00013O00202O000D000D00304O000C0002000200062O000C00492O013O0004813O00492O012O000E000C00023O001227010D00473O00122O000E00486O000C000E6O000C5O00044O00492O012O000E000C000A3O002667000C00492O0100290004813O00492O01000640000400492O0100010004813O00492O012O000E000C5O002045010C000C002F4O000E00013O00202O000E000E00304O000C000E00024O000D00033O00122O000E00043O00202O000F000700494O000D000F00024O000E00043O00122O000F00043O00202O0010000700494O000E001000024O000D000D000E00062O000C00492O01000D0004813O00492O010006273O00332O013O0004813O00332O012O000E000C00014O00BF000D00023O00122O000E004A3O00122O000F004B6O000D000F00024O000C000C000D4O000C00023O00044O00492O012O000E000C00014O0050010D00023O00122O000E004C3O00122O000F004D6O000D000F00024O000C000C000D00202O000C000C00454O000C0002000200062O000C00492O013O0004813O00492O012O000E000C00083O0020F1000C000C00464O000D00013O00202O000D000D00304O000C0002000200062O000C00492O013O0004813O00492O012O000E000C00023O001270010D004E3O001270010E004F4O006B000C000E4O0012010C6O000E000C000B4O0020000D00046O000C000200024O0009000C3O00122O000B00053O00044O002A000100267601030022000100010004813O00220001001270010B00013O000E74000400562O01000B0004813O00562O01002E3F0151005E2O0100500004813O005E2O012O000E000C5O0020D7000C000C002F4O000E00013O00202O000E000E00524O000C000E00024O0006000C4O000E000700063O001270010B00053O002EAC0054006F2O0100530004813O006F2O01002676010B006F2O0100010004813O006F2O012O000E000C5O00205B000C000C00104O000E00013O00202O000E000E00554O000C000E00024O0004000C6O000C5O00202O000C000C002F4O000E00013O00202O000E000E00554O000C000E00024O0005000C3O00122O000B00043O0026F3000B00732O0100050004813O00732O01002E3F015600522O0100570004813O00522O01001270010300043O0004813O002200010004813O00522O010004813O002200010026F3000A007B2O0100010004813O007B2O01002EAC00580023000100590004813O00230001000E7000050002030100030004813O00020301001270010B00014O003D010C000C3O0026F3000B00832O0100010004813O00832O01002EAC005A007F2O01005B0004813O007F2O01001270010C00013O002676010C00882O0100050004813O00882O010012700103000A3O0004813O00020301002E10015C00D40001005C0004813O005C0201002676010C005C020100010004813O005C0201001270010D00013O0026F3000D00912O0100010004813O00912O01002E3F015D00550201005E0004813O00550201000627000900962O013O0004813O00962O012O000E000E000C3O000627000E00F12O013O0004813O00F12O012O000E000E00014O0050010F00023O00122O0010005F3O00122O001100606O000F001100024O000E000E000F00202O000E000E002C4O000E0002000200062O000E00F12O013O0004813O00F12O012O000E000E000D3O00208A000E000E00614O001000013O00202O0010001000624O0011000E6O000E0011000200062O000E00F12O013O0004813O00F12O012O000E000E00063O000E35000100F12O01000E0004813O00F12O012O000E000E000F3O000627000E00F12O013O0004813O00F12O012O000E000E000D3O002062000E000E006300122O0010002E3O00122O001100296O0012000D3O00202O0012001200644O001400013O00202O0014001400624O0012001400024O001200126O000E00120002000640000E00C02O0100010004813O00C02O012O000E000E000D3O002069010E000E00652O0016010E00020002000627000E00F12O013O0004813O00F12O012O000E000E00103O002015000E000E00664O000F000D6O001000116O000E0010000200062O000E00F12O013O0004813O00F12O012O000E000E000D3O00208A000E000E00614O001000013O00202O0010001000624O0011000E6O000E0011000200062O000E00F12O013O0004813O00F12O010006273O00D92O013O0004813O00D92O012O000E000E00014O00BF000F00023O00122O001000673O00122O001100686O000F001100024O000E000E000F4O000E00023O00044O00F12O01002E1001690018000100690004813O00F12O012O000E000E00014O0050010F00023O00122O0010006A3O00122O0011006B6O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E00F12O013O0004813O00F12O012O000E000E00083O0020F1000E000E00464O000F00013O00202O000F000F00624O000E0002000200062O000E00F12O013O0004813O00F12O012O000E000E00023O001270010F006C3O0012700110006D4O006B000E00104O0012010E5O00064000092O00020100010004814O0002012O000E000E00014O0050010F00023O00122O0010006E3O00122O0011006F6O000F001100024O000E000E000F00202O000E000E002C4O000E0002000200062O000E2O0002013O0004814O0002012O000E000E00063O000E720001002O0201000E0004813O002O0201002E3F01700054020100710004813O005402012O000E000E000A3O002676010E0054020100040004813O005402012O000E000E5O002065010E000E00104O001000013O00202O0010001000724O000E0010000200062O000E005402013O0004813O005402012O000E000E00014O003E000F00023O00122O001000733O00122O001100746O000F001100024O000E000E000F00202O000E000E00144O000E0002000200062O000E0020020100010004813O002002012O000E000E00014O0050010F00023O00122O001000753O00122O001100766O000F001100024O000E000E000F00202O000E000E00144O000E0002000200062O000E005402013O0004813O005402012O000E000E00014O00B5000F00023O00122O001000773O00122O001100786O000F001100024O000E000E000F00202O000E000E003C4O000E0002000200262O000E0054020100790004813O005402012O000E000E00014O001C010F00023O00122O0010007A3O00122O0011007B6O000F001100024O000E000E000F00202O000E000E00384O000E0002000200262O000E0054020100040004813O005402010006273O003E02013O0004813O003E02012O000E000E00014O00BF000F00023O00122O0010007C3O00122O0011007D6O000F001100024O000E000E000F4O000E00023O00044O005402012O000E000E00014O0050010F00023O00122O0010007E3O00122O0011007F6O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E005402013O0004813O005402012O000E000E00083O0020F1000E000E00464O000F00013O00202O000F000F00624O000E0002000200062O000E005402013O0004813O005402012O000E000E00023O001270010F00803O001270011000814O006B000E00104O0012010E5O001270010D00043O002EAC0083008D2O0100820004813O008D2O01002676010D008D2O0100040004813O008D2O01001270010C00043O0004813O005C02010004813O008D2O01002676010C00842O0100040004813O00842O01001270010D00013O0026F3000D0063020100040004813O00630201002EAC00850065020100840004813O00650201001270010C00053O0004813O00842O01000E700001005F0201000D0004813O005F02012O000E000E00014O0050010F00023O00122O001000863O00122O001100876O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E00A402013O0004813O00A402012O000E000E00124O00F6000F00044O00F6001000084O0071000E00100002000627000E00A402013O0004813O00A402012O000E000E00014O0050010F00023O00122O001000883O00122O001100896O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E00A402013O0004813O00A40201001270010E00014O003D010F000F3O002676010E0083020100010004813O00830201001270010F00013O0026F3000F008A020100010004813O008A0201002EAC008A00860201008B0004813O008602010006273O009302013O0004813O009302012O000E001000134O006E001100023O00122O0012008C3O00122O0013008D6O0011001300024O0010001000114O001000024O000E001000144O000E001100133O00208500110011008E2O00160110000200020006400010009B020100010004813O009B0201002E10018F000B000100900004813O00A402012O000E001000023O001227011100913O00122O001200926O001000126O00105O00044O00A402010004813O008602010004813O00A402010004813O008302012O000E000E00014O0050010F00023O00122O001000933O00122O001100946O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E00DA02013O0004813O00DA02012O000E000E00124O00F6000F00044O00F6001000084O0071000E00100002000627000E00DA02013O0004813O00DA02012O000E000E00014O0050010F00023O00122O001000953O00122O001100966O000F001100024O000E000E000F00202O000E000E00144O000E0002000200062O000E00DC02013O0004813O00DC02012O000E000E00014O003E000F00023O00122O001000973O00122O001100986O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E00DC020100010004813O00DC02012O000E000E5O002072010E000E00104O001000013O00202O0010001000994O000E0010000200062O000E00DC020100010004813O00DC02012O000E000E00014O006C000F00023O00122O0010009A3O00122O0011009B6O000F001100024O000E000E000F00202O000E000E003C4O000E000200020020DC000F00050005000684010F00DC0201000E0004813O00DC0201002E10019C00230001009D0004813O00FD0201001270010E00014O003D010F000F3O002676010E00DE020100010004813O00DE0201001270010F00013O002EAC009F00E10201009E0004813O00E10201000E70000100E10201000F0004813O00E102010006273O00EE02013O0004813O00EE02012O000E001000134O006E001100023O00122O001200A03O00122O001300A16O0011001300024O0010001000114O001000024O000E001000144O000E001100133O00208500110011008E2O0016011000020002000627001000FD02013O0004813O00FD02012O000E001000023O001227011100A23O00122O001200A36O001000126O00105O00044O00FD02010004813O00E102010004813O00FD02010004813O00DE0201001270010D00043O0004813O005F02010004813O00842O010004813O000203010004813O007F2O010026F3000300060301000A0004813O00060301002EAC00A50053040100A40004813O00530401001270010B00013O000E740004000B0301000B0004813O000B0301002E1001A60037000100A70004813O00400301002EAC00A8003E030100A90004813O003E03012O000E000C00014O0050010D00023O00122O000E00AA3O00122O000F00AB6O000D000F00024O000C000C000D00202O000C000C002C4O000C0002000200062O000C003E03013O0004813O003E03012O000E000C000F3O000627000C003E03013O0004813O003E03012O000E000C00063O000E350004003E0301000C0004813O003E03010006273O002703013O0004813O002703012O000E000C00014O00BF000D00023O00122O000E00AC3O00122O000F00AD6O000D000F00024O000C000C000D4O000C00023O00044O003E0301002E3F01AE003E030100AF0004813O003E03012O000E000C00014O0050010D00023O00122O000E00B03O00122O000F00B16O000D000F00024O000C000C000D00202O000C000C00454O000C0002000200062O000C003E03013O0004813O003E03012O000E000C00144O000E000D00013O002085000D000D00B22O0016010C00020002000627000C003E03013O0004813O003E03012O000E000C00023O001270010D00B33O001270010E00B44O006B000C000E4O0012010C6O0076000C6O007A010C00023O002676010B0007030100010004813O0007030100064000090007040100010004813O000704012O000E000C00014O0050010D00023O00122O000E00B53O00122O000F00B66O000D000F00024O000C000C000D00202O000C000C002C4O000C0002000200062O000C000704013O0004813O00070401001270010C00014O003D010D000D3O002EAC00B80050030100B70004813O00500301000E70000100500301000C0004813O00500301001270010D00013O002EAC00B90055030100BA0004813O00550301002676010D0055030100010004813O005503010006403O00A3030100010004813O00A303012O000E000E00153O000627000E00A303013O0004813O00A303012O000E000E000C3O000640000E00A3030100010004813O00A303012O000E000E000A3O000EB3000500A30301000E0004813O00A30301001270010E00014O003D010F00103O002E3F01BB0077030100BC0004813O00770301000E70000100770301000E0004813O00770301001270011100013O0026F30011006F030100040004813O006F0301002E3F01BD0071030100BE0004813O00710301001270010E00043O0004813O007703010026760111006B030100010004813O006B0301001270010F00014O003D011000103O001270011100043O0004813O006B0301002EAC00C00066030100BF0004813O00660301002676010E0066030100040004813O00660301002676010F008D030100040004813O008D03012O000E001100174O003A001200013O00202O0012001200624O001300103O00102O0014000500074O001500186O001600133O00202O0016001600C14O0011001600024O001100166O001100163O00062O001100A303013O0004813O00A303012O000E001100164O007A011100023O0004813O00A30301002676010F007B030100010004813O007B0301001270011100013O00267601110099030100010004813O009903012O003D011000103O0006CF00103O000100042O000E3O00194O000E3O00114O000E3O00014O000E3O000E3O001270011100043O000E740004009D030100110004813O009D0301002EAC00C20090030100C30004813O00900301001270010F00043O0004813O007B03010004813O009003010004813O007B03010004813O00A303010004813O006603012O000E000E000F3O000627000E00DF03013O0004813O00DF03012O000E000E000D3O002O20010E000E00644O001000013O00202O0010001000624O000E001000024O000F00014O006C001000023O00122O001100C43O00122O001200C56O0010001200024O000F000F001000202O000F000F003C4O000F000200020020F4000F000F00C600065E010E00DF0301000F0004813O00DF03012O000E000E00063O000E35000100DF0301000E0004813O00DF03012O000E000E00014O001C010F00023O00122O001000C73O00122O001100C86O000F001100024O000E000E000F00202O000E000E003C4O000E0002000200262O000E00DF030100350004813O00DF03012O000E000E00103O002015000E000E00664O000F000D6O001000116O000E0010000200062O000E00DF03013O0004813O00DF03012O000E000E000D3O002069010E000E00630012700110002E4O000E001100014O006C001200023O00122O001300C93O00122O001400CA6O0012001400024O00110011001200202O00110011003C4O0011000200020010440111003500114O0012000D3O00202O0012001200644O001400013O00202O0014001400624O0012001400024O001200126O000E0012000200062O000E00E1030100010004813O00E10301002E3F01CB0007040100CC0004813O000704010006273O00EB03013O0004813O00EB03012O000E000E00014O00BF000F00023O00122O001000CD3O00122O001100CE6O000F001100024O000E000E000F4O000E00023O00044O000704012O000E000E00014O0050010F00023O00122O001000CF3O00122O001100D06O000F001100024O000E000E000F00202O000E000E00454O000E0002000200062O000E00FC03013O0004813O00FC03012O000E000E00083O002002010E000E00464O000F00013O00202O000F000F00624O000E0002000200062O000E00FE030100010004813O00FE0301002EAC00D20007040100D10004813O000704012O000E000E00023O001227010F00D33O00122O001000D46O000E00106O000E5O00044O000704010004813O005503010004813O000704010004813O00500301002E1001D5004A000100D50004813O005104012O000E000C00014O0050010D00023O00122O000E00D63O00122O000F00D76O000D000F00024O000C000C000D00202O000C000C002C4O000C0002000200062O000C005104013O0004813O005104012O000E000C000C3O000640000C0019040100010004813O001904012O000E000C000A3O000E29010A002E0401000C0004813O002E04012O000E000C000A3O002676010C0051040100050004813O005104010006270004005104013O0004813O005104012O000E000C00014O0050010D00023O00122O000E00D83O00122O000F00D96O000D000F00024O000C000C000D00202O000C000C00144O000C0002000200062O000C005104013O0004813O005104012O000E000C001A4O000E000D00013O002085000D000D00DA2O0016010C00020002000640000C0051040100010004813O005104010006403O0032040100010004813O00320401002E1001DB000A000100DC0004813O003A04012O000E000C00014O00BF000D00023O00122O000E00DD3O00122O000F00DE6O000D000F00024O000C000C000D4O000C00023O00044O00510401002EAC00DF0051040100E00004813O005104012O000E000C00014O0050010D00023O00122O000E00E13O00122O000F00E26O000D000F00024O000C000C000D00202O000C000C00454O000C0002000200062O000C005104013O0004813O005104012O000E000C00144O000E000D00013O002085000D000D00DA2O0016010C00020002000627000C005104013O0004813O005104012O000E000C00023O001270010D00E33O001270010E00E44O006B000C000E4O0012010C5O001270010B00043O0004813O00070301001270010A00043O0004813O002300010004813O002200010004813O005804010004813O000200012O003E012O00013O00013O00033O00030A3O0043616E446F54556E697403113O00446562752O665265667265736861626C6503073O0052757074757265010E4O00F700015O00202O0001000100014O00028O000300016O00010003000200062O0001000C00013O0004813O000C00010020692O013O00022O000E000300023O0020850003000300032O000E000400034O00710001000400022O007A2O0100024O003E012O00017O00D43O00028O00025O00F08340025O00E09040026O00F03F025O0010A340025O002DB040027O0040025O0018B140025O001EA740026O001440025O00109A40030A3O0043504D61785370656E64026O001840030A3O00905BCA122CBCBB56C11803063O00DED737A57D41030A3O0049734361737461626C65030A3O00476C2O6F6D626C616465026O000840025O003CAA40025O0028B340030A3O000BDDC915FFC3E14B28D403083O002A4CB1A67A92A18D030A3O0082860AC12O74A98B01CB03063O0016C5EA65AE1903073O001E20A0DD7ABBDF03083O00E64D54C5BC16CFB7025O008AA640025O0078A64003083O00DB15C5F79FB5F13703083O00559974A69CECC190030C3O0080E143A0E12DA5E34CB1F60503063O0060C4802DD384030B3O004973417661696C61626C6503083O004261636B7374616203093O0042752O66537461636B03103O0044616E73654D61636162726542752O66025O00BAA340025O001AA74003083O00178C7854C1BBB5DA03083O00B855ED1B3FB2CFD403083O002A580A541B4D085D03043O003F68396903073O003893A1450793AC03043O00246BE7C4025O001EAF40025O0048844003063O0042752O665570030F3O0053696C656E7453746F726D42752O66030B3O00F531B533B716F52CB624B403063O0062A658D956D903113O005072656D656469746174696F6E42752O66030D3O00FB66C03A572710DF75D13E5D2D03073O0079AB14A5573243025O00F09D40026O00104003143O00452O66656374697665436F6D626F506F696E7473030C3O000EDCBBD9785934462FDDB1D803083O00325DB4DABD172E47030A3O0053657073697342752O66025O0097B040025O0016AD4003093O004973496E52616E6765026O003940025O00989640025O0072A740030A3O00446562752O66446F776E03123O0046696E645765616B6E652O73446562752O6603153O002DE2B4D13E4C01EB97CB24480DE4A1CD024E0BFDA903063O003A648FC4A351030C3O003E432DB03A64E40D1B4031A603083O006E7A2243C35F2985030D3O0053687572696B656E53746F726D025O0068AA40025O00E06840025O00589740025O00D4B140030D3O0046B94E58DF7EB45579C27AA35603053O00B615D13B2A025O00A0B040025O00507D40025O001EAD40025O00C05540025O00088340025O0062AE40030C3O00EDAC5A484BCB5BCAB652474103073O0028BEC43B2C24BC026O001C40026O002040030F3O00104CD2B3FF6F043242EFBCFB79022B03073O006D5C25BCD49A1D025O0088A440025O00FEA040025O006EA740030D3O00446562752O6652656D61696E73030E3O0022BFA0AC391F02A9AB8A331205AE03063O007371C6CDCE56030F3O00432O6F6C646F776E52656D61696E73026O003240030E3O00B74EF3588B5BED558273FB5B905F03043O003AE4379E025O0030A740025O00C05140025O00CAAA40025O0010AB40030C3O008781D12A33BA26A09BD9253903073O0055D4E9B04E5CCD025O0042A240025O00707A40025O00A7B240025O00588640030C3O00795089E6454F9BF6585183E703043O00822A38E8025O0068AC40025O006C9C40025O00349140025O00B2A240025O000C9540025O003EAD40025O0038A240025O0028A940025O007CB240030D3O009E22465EBFA62F5D7F2OA2385E03053O00D6CD4A332C025O0082B140025O0062B340030D3O00C944F7EE7EF149ECCF63F55EEF03053O00179A2C829C025O0016AB40025O00FCA240025O00708040025O00F07F4003133O00506572666F72617465645665696E7342752O66030A3O00CAF202FCF5D5E1FF09F603063O00B78D9E6D9398025O00A4A040025O00309D40025O0046A040025O0036AE40025O0024A840025O0028AC40030A3O000B05E903210BEA0D280C03043O006C4C6986030A3O00CCC9BEEEC3E9C9B0E5CB03053O00AE8BA5D181030F3O0093B6F0C7C911716CA6B7D4C4CF0D6303083O0018C3D382A1A6631003083O006402EA274002470103063O00762663894C3303083O00DF2706191A34FC2403063O00409D4665726903083O0062A9A4E80354A9A503053O007020C8C783030F3O001C554EBECCB9233855588EC6A22C3F03073O00424C303CD8A3CB025O0054AA40025O0039B04003093O00537465616C74685570025O0024B040030C3O00898E78F750D937AE9470F85A03073O0044DAE619933FAE025O00C05640025O0078A540030D3O00546865526F2O74656E42752O66025O003C9C40025O00F49A40030F3O00536861646F7744616E636542752O66030B3O0042752O6652656D61696E73025O00C88340025O0054A440025O00907740025O0031B24003083O003AA83C7F2FAC297603043O001369CD5D030F3O008D0DDB913ABB3BCA933EBD09D9843203053O005FC968BEE1030F3O009CCEC2DCAADFF2DABDCAD5CFA8CECC03043O00AECFABA1025O0004B340025O00809040030F3O0053687572696B656E546F726E61646F03083O006EB0A38B7BB4B68203043O00E73DD5C2025O00709540025O00C88740025O0080AD40025O00DCA940030C3O00537465616C74685370652O6C03023O004944030F3O0056616E69736842752O665370652O6C03063O00C0F7770895D403063O00BC2O961961E6030B3O00E9815E0603FAFE8851010903063O008DBAE93F626C025O002EAF4003093O0044C78CBBB00264CA8703063O007610AF2OE9DF03073O0048617354696572026O003E40025O00A4AB40025O00D2A940030D3O00BF8C309DE7996E9FA034B5ED8E03073O001DEBE455DB8EEB025O00349240025O000C9140025O008CAD40025O002CA640025O0060A540030E3O00436F6D626F506F696E74734D6178025O0086AC4003133O00D8E73CA42AE7EF28852DF0EE23A101F0E42FB303053O0045918A4CD6030A3O0054616C656E7452616E6B0254042O001270010200014O003D0103000E3O001270010F00013O002E3F010200E4000100030004813O00E40001002676010F00E4000100040004813O00E40001001270011000013O0026F30010000C000100040004813O000C0001002E1001050004000100060004813O000E0001001270010F00073O0004813O00E4000100267601100008000100010004813O00080001002EAC000900AE000100080004813O00AE0001002676010200AE0001000A0004813O00AE0001001270011100014O003D011200123O002E10010B3O0001000B0004813O0016000100267601110016000100010004813O00160001001270011200013O0026760112002A000100040004813O002A00012O000E00135O00208500130013000C2O00B600130001000200065E010C0023000100130004813O002300010004813O002800012O000E001300014O00F600146O00F6001500014O006B001300154O001201135O0012700102000D3O0004813O00AE00010026760112001B000100010004813O001B00012O000E001300024O0050011400033O00122O0015000E3O00122O0016000F6O0014001600024O00130013001400202O0013001300104O00130002000200062O0013006500013O0004813O00650001000627000E004100013O0004813O004100012O000E001300044O000E001400023O0020850014001400112O00160113000200020006270013004800013O0004813O004800012O000E001300053O00267601130048000100070004813O0048000100264A00060065000100070004813O006500010006270005006500013O0004813O006500012O000E001300053O00264A00130065000100120004813O006500010006403O004C000100010004813O004C0001002E3F01140065000100130004813O006500010006270001005600013O0004813O005600012O000E001300024O00BF001400033O00122O001500153O00122O001600166O0014001600024O0013001300144O001300023O00044O006500012O00CD001300024O0042001400026O001500033O00122O001600173O00122O001700186O0015001700024O0014001400154O001500026O001600033O00122O001700193O00122O0018001A6O0016001800024O0015001500164O0013000200012O007A011300023O002EAC001C00AA0001001B0004813O00AA00012O000E001300024O0050011400033O00122O0015001D3O00122O0016001E6O0014001600024O00130013001400202O0013001300104O00130002000200062O001300AA00013O0004813O00AA0001000627000E00AA00013O0004813O00AA00012O000E001300024O0050011400033O00122O0015001F3O00122O001600206O0014001600024O00130013001400202O0013001300214O00130002000200062O001300AA00013O0004813O00AA00012O000E001300044O000E001400023O0020850014001400222O0016011300020002000640001300AA000100010004813O00AA00012O000E001300063O0020A60013001300234O001500023O00202O0015001500244O00130015000200262O001300AA000100070004813O00AA00012O000E001300053O00264A001300AA000100070004813O00AA00010006403O0091000100010004813O00910001002E100125001B000100260004813O00AA00010006270001009B00013O0004813O009B00012O000E001300024O00BF001400033O00122O001500273O00122O001600286O0014001600024O0013001300144O001300023O00044O00AA00012O00CD001300024O0042001400026O001500033O00122O001600293O00122O0017002A6O0015001700024O0014001400154O001500026O001600033O00122O0017002B3O00122O0018002C6O0016001800024O0015001500164O0013000200012O007A011300023O001270011200043O0004813O001B00010004813O00AE00010004813O00160001002EAC002E00E20001002D0004813O00E20001002676010200E2000100040004813O00E20001001270011100013O000E70000400C9000100110004813O00C900012O000E001200063O00203C01120012002F4O001400023O00202O0014001400304O00120014000200062O000900C7000100120004813O00C7000100061D010900C7000100010004813O00C700012O000E001200024O006C001300033O00122O001400313O00122O001500326O0013001500024O00120012001300202O0012001200214O0012000200022O00F6000900123O001270010200073O0004813O00E20001002676011100B3000100010004813O00B300012O000E001200074O000E000700084O00F6000600124O000E001200063O00203C01120012002F4O001400023O00202O0014001400334O00120014000200062O000800E0000100120004813O00E0000100061D010800E0000100010004813O00E000012O000E001200024O006C001300033O00122O001400343O00122O001500356O0013001500024O00120012001300202O0012001200214O0012000200022O00F6000800123O001270011100043O0004813O00B30001001270011000043O0004813O00080001002E100136003C000100360004813O00202O01002676010F00202O0100370004813O00202O01000E7000120002000100020004813O00020001001270011000013O002676011000092O0100010004813O00092O012O000E00115O0020C40011001100384O001200066O0011000200024O000C00116O001100024O006C001200033O00122O001300393O00122O0014003A6O0012001400024O00110011001200202O0011001100104O001100020002000625000D00082O0100110004813O00082O01000625000D00082O01000A0004813O00082O01000625000D00082O01000B0004813O00082O01000625000D00082O0100030004813O00082O012O000E001100063O0020D700110011002F4O001300023O00202O00130013003B4O0011001300024O000D00113O001270011000043O002676011000EB000100040004813O00EB0001002E3F013D00192O01003C0004813O00192O01000640000A00112O0100010004813O00112O01000627000B00192O013O0004813O00192O01000627000D00182O013O0004813O00182O012O000E001100093O00206901110011003E0012700113003F4O00710011001300022O00F6000D00113O0004813O001C2O01000627000D001C2O013O0004813O001C2O012O000E000D000A3O001270010200373O0004813O000200010004813O00EB00010004813O00020001002676010F00FB2O0100070004813O00FB2O01002EAC004000AD2O0100410004813O00AD2O01002676010200AD2O0100370004813O00AD2O01001270011000014O003D011100113O000E70000100282O0100100004813O00282O01001270011100013O002676011100662O0100040004813O00662O01000627000E00422O013O0004813O00422O01000627000900422O013O0004813O00422O012O000E001200093O0020650112001200424O001400023O00202O0014001400434O00120014000200062O001200422O013O0004813O00422O012O000E001200024O003E001300033O00122O001400443O00122O001500456O0013001500024O00120012001300202O0012001200214O00120002000200062O001200592O0100010004813O00592O012O000E001200024O0050011300033O00122O001400463O00122O001500476O0013001500024O00120012001300202O0012001200214O00120002000200062O001200572O013O0004813O00572O0100264A000600572O0100040004813O00572O012O000E001200053O002676011200572O0100070004813O00572O012O000E001200044O000E001300023O0020850013001300482O0016011200020002000627001200592O013O0004813O00592O01002EAC004900642O01004A0004813O00642O01002E3F014B00642O01004C0004813O00642O010006273O00642O013O0004813O00642O012O000E001200024O006E001300033O00122O0014004D3O00122O0015004E6O0013001500024O0012001200134O001200023O0012700102000A3O0004813O00AD2O010026760111002B2O0100010004813O002B2O01001270011200013O002EAC0050006F2O01004F0004813O006F2O010026760112006F2O0100040004813O006F2O01001270011100043O0004813O002B2O010026F3001200732O0100010004813O00732O01002EAC005100692O0100520004813O00692O01002E3F0153008A2O0100540004813O008A2O01000627000D008A2O013O0004813O008A2O01000640000A007B2O0100010004813O007B2O01000627000B008A2O013O0004813O008A2O012O000E001300053O002639001300812O0100370004813O00812O012O000E0013000B3O0006270013008A2O013O0004813O008A2O010006273O008A2O013O0004813O008A2O012O000E001300024O006E001400033O00122O001500553O00122O001600566O0014001600024O0013001300144O001300024O000E001300063O0020C30013001300234O001500023O00202O0015001500244O00130015000200262O001300A62O01000A0004813O00A62O010026F3000700952O0100070004813O00952O01002676010700A62O0100120004813O00A62O01000640000800992O0100010004813O00992O01002667000C00A62O0100570004813O00A62O012O000E001300053O002634001300A72O0100580004813O00A72O012O000E001300024O0049011400033O00122O001500593O00122O0016005A6O0014001600024O00130013001400202O0013001300214O0013000200024O000E00133O00044O00A82O012O009C000E6O0076000E00013O001270011200043O0004813O00692O010004813O002B2O010004813O00AD2O010004813O00282O01000E74005800B12O0100020004813O00B12O01002EAC005B00FA2O01005C0004813O00FA2O01001270011000013O002676011000B62O0100040004813O00B62O012O007600116O007A011100023O002E10015D00FCFF2O005D0004813O00B22O01002676011000B22O0100010004813O00B22O01000627000D00DC2O013O0004813O00DC2O012O000E001100093O00209400110011005E4O001300023O00202O0013001300434O00110013000200262O001100DE2O0100040004813O00DE2O012O000E001100024O00B5001200033O00122O0013005F3O00122O001400606O0012001400024O00110011001200202O0011001100614O00110002000200262O001100DC2O0100620004813O00DC2O012O000E001100093O00206C01110011005E4O001300023O00202O0013001300434O0011001300024O001200026O001300033O00122O001400633O00122O001500646O0013001500024O00120012001300202O0012001200614O00120002000200062O001100DE2O0100120004813O00DE2O01002E100165000D000100660004813O00E92O01002EAC006700E92O0100680004813O00E92O010006273O00E92O013O0004813O00E92O012O000E001100024O006E001200033O00122O001300693O00122O0014006A6O0012001400024O0011001100124O001100023O000640000D00ED2O0100010004813O00ED2O01002E3F016B00F82O01006C0004813O00F82O010006403O00F12O0100010004813O00F12O01002E10016D00090001006E0004813O00F82O012O000E001100024O006E001200033O00122O0013006F3O00122O001400706O0012001400024O0011001100124O001100023O001270011000043O0004813O00B22O01001270010F00123O002676010F002O030100010004813O002O0301001270011000013O002E3F01720004020100710004813O0004020100267601100004020100040004813O00040201001270010F00043O0004813O002O03010026F300100008020100010004813O00080201002E3F017400FE2O0100730004813O00FE2O01000E70005700D8020100020004813O00D80201001270011100014O003D011200123O002E1001753O000100750004813O000C02010026760111000C020100010004813O000C0201001270011200013O002EAC00770049020100760004813O00490201000E7000040049020100120004813O00490201002E3F01780047020100790004813O004702012O000E0013000C3O0006270013004702013O0004813O004702012O000E001300024O0050011400033O00122O0015007A3O00122O0016007B6O0014001600024O00130013001400202O0013001300104O00130002000200062O0013004702013O0004813O004702012O000E001300054O00C20014000D3O00122O001500126O0016000E6O001700056O001600176O00143O00024O0015000F3O00122O001600126O0017000E6O001800056O001700186O00153O00024O00140014001500062O00140047020100130004813O004702010006270008003C02013O0004813O003C02012O000E001300053O000EB300570047020100130004813O004702012O000E0013000B3O00064000130047020100010004813O004702010006403O0040020100010004813O00400201002E3F017D00470201007C0004813O004702012O000E001300024O006E001400033O00122O0015007E3O00122O0016007F6O0014001600024O0013001300144O001300023O001270010200583O0004813O00D80201002E3F01810011020100800004813O0011020100267601120011020100010004813O00110201001270011300013O002EAC00830054020100820004813O0054020100267601130054020100040004813O00540201001270011200043O0004813O001102010026760113004E020100010004813O004E02012O000E001400063O0020C60014001400234O001600023O00202O0016001600844O001400160002000E2O000A00B1020100140004813O00B102012O000E001400053O002667001400B1020100120004813O00B102012O000E001400024O003E001500033O00122O001600853O00122O001700866O0015001700024O00140014001500202O0014001400104O00140002000200062O0014006C020100010004813O006C0201002E1001870022000100880004813O008C02010006403O0070020100010004813O00700201002EAC008A00B1020100890004813O00B1020100064000010074020100010004813O00740201002E3F018C007C0201008B0004813O007C02012O000E001400024O00BF001500033O00122O0016008D3O00122O0017008E6O0015001700024O0014001400154O001400023O00044O00B102012O00CD001400024O0042001500026O001600033O00122O0017008F3O00122O001800906O0016001800024O0015001500164O001600026O001700033O00122O001800913O00122O001900926O0017001900024O0016001600174O0014000200012O007A011400023O0004813O00B102012O000E001400024O0050011500033O00122O001600933O00122O001700946O0015001700024O00140014001500202O0014001400104O00140002000200062O001400B102013O0004813O00B102010006273O00B102013O0004813O00B10201000627000100A202013O0004813O00A202012O000E001400024O00BF001500033O00122O001600953O00122O001700966O0015001700024O0014001400154O001400023O00044O00B102012O00CD001400024O0042001500026O001600033O00122O001700973O00122O001800986O0016001800024O0015001500164O001600026O001700033O00122O001800993O00122O0019009A6O0017001900024O0016001600174O0014000200012O007A011400023O002EAC009B00D30201009C0004813O00D30201000627000D00D302013O0004813O00D302012O000E001400063O00204600140014009D4O001600016O00178O00140017000200062O001400D3020100010004813O00D30201000640000100D3020100010004813O00D302012O000E001400063O00206501140014002F4O001600023O00202O00160016003B4O00140016000200062O001400D302013O0004813O00D302012O000E001400053O002667001400D3020100370004813O00D30201002E10019E000B0001009E0004813O00D302010006273O00D302013O0004813O00D302012O000E001400024O006E001500033O00122O0016009F3O00122O001700A06O0015001700024O0014001400154O001400023O001270011300043O0004813O004E02010004813O001102010004813O00D802010004813O000C020100267601020001030100010004813O00010301001270011100013O0026F3001100DF020100040004813O00DF0201002E3F01A200E7020100A10004813O00E702012O000E001200063O0020A400120012002F4O001400023O00202O0014001400A34O0012001400024O000500123O00122O000200043O00044O00010301002676011100DB020100010004813O00DB0201001270011200013O002E3F01A500FB020100A40004813O00FB0201002676011200FB020100010004813O00FB02012O000E001300063O00205B00130013002F4O001500023O00202O0015001500A64O0013001500024O000300136O001300063O00202O0013001300A74O001500023O00202O0015001500A64O0013001500024O000400133O00122O001200043O002676011200EA020100040004813O00EA0201001270011100043O0004813O00DB02010004813O00EA02010004813O00DB0201001270011000043O0004813O00FE2O010026F3000F0007030100120004813O00070301002E3F01A90003000100A80004813O00030001001270011000013O0026760110000C030100040004813O000C0301001270010F00373O0004813O0003000100267601100008030100010004813O00080301002676010200920301000D0004813O00920301001270011100014O003D011200123O0026F300110016030100010004813O00160301002E3F01AB0012030100AA0004813O00120301001270011200013O000E7000040065030100120004813O006503012O000E0013000D3O001270011400044O000E001500104O000E001600024O003E001700033O00122O001800AC3O00122O001900AD6O0017001900024O00160016001700202O0016001600214O00160002000200062O00160038030100010004813O003803012O000E001600024O003E001700033O00122O001800AE3O00122O001900AF6O0017001900024O00160016001700202O0016001600214O00160002000200062O00160038030100010004813O003803012O000E001600024O006C001700033O00122O001800B03O00122O001900B16O0017001900024O00160016001700202O0016001600214O0016000200022O0071011500164O00CC00133O00024O0014000F3O00122O001500046O001600106O001700026O001800033O00122O001900AC3O00122O001A00AD6O0018001A00024O00170017001800202O0017001700214O00170002000200062O00170059030100010004813O005903012O000E001700024O003E001800033O00122O001900AE3O00122O001A00AF6O0018001A00024O00170017001800202O0017001700214O00170002000200062O00170059030100010004813O005903012O000E001700024O006C001800033O00122O001900B03O00122O001A00B16O0018001A00024O00170017001800202O0017001700214O0017000200022O0071011600174O00D800143O00022O004B01130013001400061200070063030100130004813O006303012O000E001300014O00F600146O00F6001500014O006B001300154O001201135O001270010200573O0004813O00920301002EAC00B30017030100B20004813O0017030100267601120017030100010004813O001703012O000E001300063O00206501130013002F4O001500023O00202O0015001500B44O00130015000200062O0013007703013O0004813O0077030100264A00070077030100070004813O007703012O000E001300014O00F600146O00F6001500014O006B001300154O001201136O000E001300054O00970014000E6O001500026O001600033O00122O001700B53O00122O001800B66O0016001800024O00150015001600202O0015001500214O001500166O00143O000200108A01140037001400061200140087030100130004813O00870301000E29013700890301000C0004813O00890301002EAC00B7008E030100B80004813O008E03012O000E001300014O00F600146O00F6001500014O006B001300154O001201135O001270011200043O0004813O001703010004813O009203010004813O00120301000E700007004F040100020004813O004F0401001270011100013O000E7400010099030100110004813O00990301002EAC00B900C7030100BA0004813O00C703012O000E001200063O0020B100120012002F4O00145O00202O0014001400BB4O001400016O00123O000200062O000A00AE030100120004813O00AE030100061D010A00AE030100010004813O00AE03010020690112000100BC2O00220012000200024O00135O00202O0013001300BB4O00130001000200202O0013001300BC4O00130002000200062O001200AD030100130004813O00AD03012O009C000A6O0076000A00014O000E001200063O0020B100120012002F4O00145O00202O0014001400BD4O001400016O00123O000200062O000B00C6030100120004813O00C6030100061D010B00C6030100010004813O00C603010020690112000100BC2O002F0012000200024O001300026O001400033O00122O001500BE3O00122O001600BF6O0014001600024O00130013001400202O0013001300BC4O00130002000200062O001200C5030100130004813O00C503012O009C000B6O0076000B00013O001270011100043O00267601110095030100040004813O009503010006270001004C04013O0004813O004C04010020690112000100BC2O00DB0012000200024O001300026O001400033O00122O001500C03O00122O001600C16O0014001600024O00130013001400202O0013001300BC4O00130002000200062O0012004C040100130004813O004C0401001270011200014O003D011300133O002676011200D9030100010004813O00D90301001270011300013O0026760113002E040100040004813O002E0401002E1001C20014000100C20004813O00F203012O000E001400024O0050011500033O00122O001600C33O00122O001700C46O0015001700024O00140014001500202O0014001400214O00140002000200062O001400F203013O0004813O00F203012O000E001400063O0020170014001400C500122O001600C63O00122O001700076O00140017000200062O001400F203013O0004813O00F203012O0076000500013O002E3F01C8004C040100C70004813O004C04012O000E001400024O0050011500033O00122O001600C93O00122O001700CA6O0015001700024O00140014001500202O0014001400214O00140002000200062O0014004C04013O0004813O004C0401001270011400014O003D011500163O0026F30014002O040100040004813O002O0401002EAC00CB0025040100CC0004813O00250401002E1001CD3O000100CD0004813O002O04010026760115002O040100010004813O002O0401001270011600013O0026F30016000D040100010004813O000D0401002EAC00CE0009040100CF0004813O000904012O000E001700114O007F001800063O00202O0018001800D04O0018000200024O0019000D6O001A00073O00122O001B00376O0019001B00024O001A000F6O001B00073O00122O001C00374O0071001A001C00022O00B200190019001A4O0017001900024O000600176O001700063O00202O0017001700D04O0017000200024O00070017000600044O004C04010004813O000904010004813O004C04010004813O002O04010004813O004C0401002E1001D100DBFF2O00D10004814O00040100267601142O00040100010004814O000401001270011500014O003D011600163O001270011400043O0004814O0004010004813O004C0401002676011300DC030100010004813O00DC03012O0076000300014O004C0014000D3O00122O001500586O001600026O001700033O00122O001800D23O00122O001900D36O0017001900024O00160016001700202O0016001600D44O001600174O00D800143O00022O004C0015000F3O00122O001600586O001700026O001800033O00122O001900D23O00122O001A00D36O0018001A00024O00170017001800202O0017001700D44O001700184O00D800153O00022O004B010400140015001270011300043O0004813O00DC03010004813O004C04010004813O00D90301001270010200123O0004813O004F04010004813O00950301001270011000043O0004813O000803010004813O000300010004813O000200012O003E012O00017O00463O00028O00025O00989540025O00288540026O00F03F025O00388C40025O003EA540027O0040025O00C2A040025O0067B240026O000840025O00F0B240025O00DDB040025O00088440025O00BBB240030B3O00CF5FFC515C6DD856F32O5603063O001A9C379D3533025O00A4AB40025O00809240025O00C4AD40025O00A7B24003043O0043617374030B3O00536861646F7744616E636503013O007C03063O00BAD918D0AB5803063O0030ECB876B9D8025O0092AA40025O004EA140025O00FAA34003063O0056616E69736803023O00F9FD03063O005485DD3750AF025O001CA240025O003C9E40025O00F2AA40025O00149540025O00409540025O00588840025O00EEA240025O00BC9140025O0068B240026O00A74003053O00506F776572025O00EAB140025O001EA04003073O00DABA2BEF4931ED03063O005F8AD544832003023O00494403063O001C29AF4A652203053O00164A48C123025O000AAC40025O005EA940030B3O000F78F74C6C4FE556256AEC03043O00384C1984030A3O006DC9AA22C049CCAE2ACB03053O00AF3EA1CB46030A3O00536861646F776D656C64025O008C9B40025O006C9B40030F3O001FDCD007750FD5C2173A2BD0C61F3103053O00555CBDA373030B3O001AA4313C26BB143927AF3503043O005849CC50025O00C6AA40025O00CEA040025O00EAAD40025O00E8A740025O00406F40025O0030774003113O000D82035269E9268214493E9A0A821E452C03063O00BA4EE37026490249012O001270010200014O003D010300053O002EAC000300422O0100020004813O00422O01002676010200422O0100040004813O00422O012O003D010500053O001270010600013O0026760106007C000100040004813O007C0001002EAC00050077000100060004813O0077000100267601030077000100070004813O00770001001270010700014O003D010800083O0026F300070014000100010004813O00140001002EAC00090010000100080004813O00100001001270010800013O000E7000040019000100080004813O001900010012700103000A3O0004813O007700010026F30008001D000100010004813O001D0001002E3F010B00150001000C0004813O001500012O00CD000900024O00F6000A6O00F6000B00044O00B80009000200012O00F6000500093O002EAC000D004C0001000E0004813O004C00010020850009000500042O0090000A8O000B00013O00122O000C000F3O00122O000D00106O000B000D00024O000A000A000B00062O0009004C0001000A0004813O004C00012O000E000900023O0006270009004C00013O0004813O004C0001001270010900014O003D010A000A3O000E7400010036000100090004813O00360001002E3F01110032000100120004813O00320001001270010A00013O0026F3000A003B000100010004813O003B0001002EAC00140037000100130004813O003700012O000E000B00043O002062010B000B00154O000C00053O00202O000C000C00164O000D00016O000B000D00024O000B00036O000B00033O00062O000B007300013O0004813O00730001001270010B00174O007A010B00023O0004813O007300010004813O003700010004813O007300010004813O003200010004813O007300010020850009000500042O0090000A8O000B00013O00122O000C00183O00122O000D00196O000B000D00024O000A000A000B00062O000900730001000A0004813O00730001002E3F011A00580001001B0004813O005800010004813O00730001001270010900014O003D010A000A3O002E10011C3O0001001C0004813O005A00010026760109005A000100010004813O005A0001001270010A00013O002676010A005F000100010004813O005F00012O000E000B00043O00200D010B000B00154O000C5O00202O000C000C001D4O000B000200024O000B00036O000B00033O00062O000B007300013O0004813O007300012O000E000B00013O001227010C001E3O00122O000D001F6O000B000D6O000B5O00044O007300010004813O005F00010004813O007300010004813O005A0001001270010800043O0004813O001500010004813O007700010004813O00100001002676010300070001000A0004813O000700012O007600076O007A010700023O0004813O000700010026F300060080000100010004813O00800001002E3F01200008000100210004813O00080001002E1001220019000100220004813O0099000100267601030099000100010004813O00990001001270010700013O0026F300070089000100010004813O00890001002E3F01240092000100230004813O009200012O000E000800064O0051010900016O000A8O0008000A00024O000400083O00062O00010091000100010004813O009100010012702O0100043O001270010700043O002E3F01250085000100130004813O00850001000E7000040085000100070004813O00850001001270010300043O0004813O009900010004813O008500010026760103003E2O0100040004813O003E2O01001270010700013O0026F3000700A0000100040004813O00A00001002E1001260004000100270004813O00A20001001270010300073O0004813O003E2O010026F3000700A6000100010004813O00A60001002E3F0128009C000100290004813O009C0001001270010800013O002676010800382O0100010004813O00382O012O000E000900073O00206901090009002A2O001601090002000200065C2O010009000100090004813O00B60001002E3F012B00B10001002C0004813O00B100010004813O00B600012O000E000900013O001270010A002D3O001270010B002E4O006B0009000B4O001201095O00206901093O002F2O00DB0009000200024O000A8O000B00013O00122O000C00303O00122O000D00316O000B000D00024O000A000A000B00202O000A000A002F4O000A0002000200062O000900C70001000A0004813O00C700012O000E000900083O000627000900C900013O0004813O00C90001000627000400C900013O0004813O00C90001002E3F013200D9000100330004813O00D900012O000E000900043O0020310109000900154O000A5O00202O000A000A001D4O000B00016O0009000B000200062O000900D600013O0004813O00D600012O000E000900013O001270010A00343O001270010B00354O006B0009000B4O001201096O007600096O007A010900023O0004813O00372O0100206901093O002F2O00DB0009000200024O000A8O000B00013O00122O000C00363O00122O000D00376O000B000D00024O000A000A000B00202O000A000A002F4O000A0002000200062O00092O002O01000A0004814O002O012O000E000900093O000627000900EA00013O0004813O00EA000100064000042O002O0100010004814O002O01001270010900013O002676010900EB000100010004813O00EB00012O000E000A00043O002079010A000A00154O000B5O00202O000B000B00384O000C00016O000A000C000200062O000A00F7000100010004813O00F70001002EAC003900FC0001003A0004813O00FC00012O000E000A00013O001270010B003B3O001270010C003C4O006B000A000C4O0012010A6O0076000A6O007A010A00023O0004813O00EB00010004813O00372O0100206901093O002F2O00DB0009000200024O000A8O000B00013O00122O000C003D3O00122O000D003E6O000B000D00024O000A000A000B00202O000A000A002F4O000A0002000200062O000900372O01000A0004813O00372O012O000E0009000A3O000627000900112O013O0004813O00112O01000640000400372O0100010004813O00372O012O000E000900023O000627000900372O013O0004813O00372O01001270010900013O000E74000100192O0100090004813O00192O01002EAC003F00152O0100400004813O00152O01001270010A00014O003D010B000B3O0026F3000A001F2O0100010004813O001F2O01002E10014100FEFF2O00420004813O001B2O01001270010B00013O000E70000100202O01000B0004813O00202O012O000E000C00043O002079010C000C00154O000D00053O00202O000D000D00164O000E00016O000C000E000200062O000C002C2O0100010004813O002C2O01002E1001430007000100440004813O00312O012O000E000C00013O001270010D00453O001270010E00464O006B000C000E4O0012010C6O0076000C6O007A010C00023O0004813O00202O010004813O00152O010004813O001B2O010004813O00152O01001270010800043O002676010800A7000100040004813O00A70001001270010700043O0004813O009C00010004813O00A700010004813O009C0001001270010600043O0004813O000800010004813O000700010004813O00482O0100267601020002000100010004813O00020001001270010300014O003D010400043O001270010200043O0004813O000200012O003E012O00017O00053O0003103O0048616E646C65546F705472696E6B6574026O00444003133O0048616E646C65426F2O746F6D5472696E6B6574025O0016B140025O00689540001D4O005A012O00013O00206O00014O000100026O000200033O00122O000300026O000400048O000400029O009O0000064O000D00013O0004813O000D00012O000E8O007A012O00024O000E3O00013O002004014O00034O000100026O000200033O00122O000300026O000400048O000400029O00002E2O0005001C000100040004813O001C00012O000E7O0006273O001C00013O0004813O001C00012O000E8O007A012O00024O003E012O00017O0036012O00028O00026O00F03F025O007EAB40025O007AA840027O0040025O0084B340025O0071B240026O000840025O006EAF40025O003EA540025O00606E40025O00A4B140030C3O000BE02ADD0DD08E2CF822D50603073O00E24D8C4BBA68BC03073O004973526561647903093O00537465616C74685570026O00144003113O0046696C746572656454696D65546F44696503013O003E026O002440025O003EAD40025O00389D4003043O0043617374030C3O00466C6167652O6C6174696F6E03113O009ACFC32B0F9FC2D1384AB5C2D12B46B6C003053O002FD9AEB05F025O00A07240025O00ECA940030F3O008BD56310BB5F7D288CD2640CB3507703083O0046D8BD1662D23418030A3O0049734361737461626C65030E3O00E9C6AE85DCD6CCAC81F7DFDEB78F03053O00B3BABFC3E7030A3O00432O6F6C646F776E5570030B3O00CA3719E0F6283CE5F73C1D03043O0084995F7803073O0043686172676573030C3O0097BE0F2AF2D6ACB0A60722F903073O00C0D1D26E4D97BA030B3O004973417661696C61626C6503063O0042752O66557003113O005072656D656469746174696F6E42752O66025O00109240025O0040A94003063O00456E65726779026O004E40025O00488840025O00C4A340030F3O0053687572696B656E546F726E61646F03153O00C30231FDBFF7E81630E0F4C1EE4316E6EDCAE1072D03063O00A4806342899F025O0042AD40025O0036A540030B3O003381E8BA0F9ECFB1039CFA03043O00DE60E989030B3O0043617374502O6F6C696E6703193O0089BCA813C8F5FFABF394179DE1F9B2B6A95FBCFCE2B7B2A31003073O0090D9D3C77FE893025O004EB340025O00CC9A4003013O0031025O003EA740025O0048B140025O00A4A640025O00F09040026O001040025O00C05940025O00EEAF40025O00B8A740025O002CA440025O00E06F40026O008340030A3O002C762A58BF147B174EAA03053O00CB781E432B025O001CAF40025O00F8A640030E3O00C23C40EDD6FD3642E9FDF42459E703053O00B991452D8F030F3O00432O6F6C646F776E52656D61696E73030E3O0053796D626F6C736F664465617468030A3O0054686973746C6554656103163O00456E6572677944656669636974507265646963746564026O00594003123O00436F6D626F506F696E747344656669636974030A3O00BE1710B5C8861A2DA3DD03053O00BCEA7F79C603113O00436861726765734672616374696F6E616C026O000640030F3O00536861646F7744616E636542752O66030B3O0042752O6652656D61696E7303183O00426F2O7346696C7465726564466967687452656D61696E7303023O00646F03043O00E3585273030A3O007717B3B4167F462BBFA603063O0013237FDAC762026O001840030B3O0028F303F108F70FA228FE0B03043O00827C9B6A025O009EAD40025O004CB240025O00DEA640025O00388E40025O00B88340025O00E2A64003093O00F7C7F9A0A7D069ADCC03083O00DFB5AB96CFC3961C025O00507540025O00E8AE4003093O00426C2O6F6446757279025O00EAB240025O00689740030F3O006F3BF0BA496E36ECA10D0C1CF6BC1003053O00692C5A83CE030A3O00DDE5A0AA0D2CF4E9BCBE03063O005E9F80D2D968025O00809440025O0056B340030A3O004265727365726B696E67030F3O0073F815AB1F5DFC6843FC14B45671FE03083O001A309966DF3F1F99025O00408A40025O00EC9240025O0093B140025O00C0984003093O002449FFF6004CE2FC0603043O009362208D025O00F8AC40025O007DB04003093O0046697265626C2O6F64030E3O003B42F0DE4670420A46E1C609594F03073O002B782383AA6636030D3O00750884B3B6A496550AA4B7A9BC03073O00E43466E7D6C5D0025O00C0AC40025O00307E40025O00549640025O00F2A840030D3O00416E6365737472616C43612O6C03133O003DE166DE2OAA17D51BF361D8EB8759F51FEC7903083O00B67E8015AA8AEB79025O008AA440025O00707E40025O0014B140025O00B2A640025O00B89140025O00088040030C3O0026FEF11D045137FAF11D0E5503063O0026759690796B030B3O001EB3EF3E22ACCA3B23B8EB03043O005A4DDB8E03023O00B85903073O001A866441592C6703063O00C2E62030ADE203053O00C49183504303063O002DB5161B11FB03063O00887ED0666878026O00204003083O00446562752O66557003063O0053657073697303023O0024D703083O003118EAAE23CF325D026O003440030C3O00536861646F77426C6164657303123O002FF3EE9C313FFAFC8C7E1BB2DF847008F7EE03053O00116C929DE803103O006EC01CE226A64CF111FD3DA146C21AE903063O00C82BA3748D4F03113O008D332E8CA5FAE7B6383AA0BCF5F1B6222403073O0083DF565DE3D094030C3O00C744B8A51898E246B7B40FB003063O00D583252OD67D03103O004563686F696E6752657072696D616E64025O00D2AA40025O00ECA34003163O00052A36ABA103282DB0E8282C658DE436392CB2E0282F03053O0081464B45DF025O00707940025O00349F40030F3O0075C3E6FB75E443C5C7E66EE147CFFC03063O008F26AB93891C025O00BC9640025O0032A040025O0022AB40025O00E2B140031B3O00F383AAE743D0DCC590B0F806ED94E48DABFD02E7DB90CA8AFC27AA03073O00B4B0E2D9936383030C3O00F5B52E00D6B52306C7B0200903043O0067B3D94F030B3O0079BF1DD14E9B874BB91FD003073O00C32AD77CB521EC025O00AEA340031D3O002E58242A65CB054C25372EFD0319033137F60C5D387E6DDC0C57343B6C03063O00986D39575E45030B3O00CADF0BA7B1C570A9F7D40F03083O00C899B76AC3DEB23403023O006EBE03063O003A5283E85D29030B3O00536861646F7744616E6365025O00F07C40025O0049B340031D3O00B05FD1115228C373D11B5E3AC37AD1164F30C31FFC1A4A7FB763F45C1D03063O005FE337B0753D025O002EAF40025O005CAD40025O0023B140025O00F8A140025O00CDB040025O00C8A440025O00D89840025O000AA840025O000BB040025O00149040025O00CC9C40025O0048AE40025O006BB240025O00189240025O00149F40030E3O008EFE29A4C850AEE82282C25DA9EF03063O003CDD8744C6A7030B3O00DDB5F9874DCECABCF6804703063O00B98EDD98E322025O00B4A840025O0007B040025O005EA940025O0030B14003203O007CC459F94673BC18F64EF7413CFB4B851FFE5621FE56C217CE4C21F959C158B303073O009738A5379A2353025O0062AD40025O0072A540025O00208840025O0050B04003063O00CB2A2E3BDC5603083O0024984F5E48B5256203013O003C026O003040025O009CA540025O00708440030B3O00F4D9542B97EB422FC4D15403043O005FB7B827030E3O008626EA245B8C11BA39C32355940A03073O0062D55F874634E0025O00DBB240025O0084A240030B3O00CDABC8735BE987C87957FB03053O00349EC3A91703073O0048617354696572026O003E40030C3O005CB033738339778A6EB53D7A03083O00EB1ADC5214E6551B03093O00BCA9ECF07B9CB5ECCC03053O0014E8C189A2030C3O0004D3C4A1E2801B7036D6CAA803083O001142BFA5C687EC77030C3O0029A3AF14FAE4E0D01BA6A11D03083O00B16FCFCE739F888C025O006CA340025O0046A64003153O0026880300947C46088B1F18C70F5003C93411D55B5703073O003F65E97074B42F030E3O00EE3AFF19FD32C534FF36FD37D73303063O0056A35B8D7298025O0020AF40025O00749940025O0052A340025O005EAA40025O0016B340025O00CC9E40030E3O004D61726B6564666F724465617468025O0044A440025O0058964003153O00700A2O677A7E0A66783F574B727C28132F71722E5B03053O005A336B1413030A3O0043504D61785370656E64025O00CDB240025O00C1B140030D3O004361737453752O676573746564025O0033B340025O001DB340025O002FB04003153O00AEF196FB7DA0F197E43889B083E02FCDD480EE298503053O005DED90E58F025O001C9340025O00ACAA40025O00207C40025O00AAA340025O0076A14003063O0096420BE7B34B03043O008EC0236503093O0042752O66537461636B03103O0044616E73654D61636162726542752O66030F3O00E5702AB1E22O9813D57D27AAF699A903083O0076B61549C387ECCC030F3O003B3919520119C90D3F124E0D1CE80D03073O009D685C7A20646D03063O0056616E69736803123O0095A7C1C32E2FCD86A2A5DDC57D6FA986EAE603083O00CBC3C6AFAA5D47ED025O00F88C4003093O000D4432D1731DF3214F03073O009C4E2B5EB53171030F3O0041EDC7B10E574D77EBCCAD02526C7703073O00191288A4C36B2303093O00436F6C64426C2O6F64025O0015B040030F3O00CB2CBA5B329FCEB4EC6D8B437DB3C503083O00D8884DC92F12DCA1025O008EA740025O003AB240025O003C9040025O00AEB04000C0052O001270012O00014O003D2O0100023O002676012O00B4050100020004813O00B40501001270010300014O003D010400043O002EAC00040006000100030004813O00060001000E7000010006000100030004813O00060001001270010400013O000E7000020089030100040004813O008903010026762O0100E0000100050004813O00E00001001270010500013O002EAC00070016000100060004813O0016000100267601050016000100020004813O001600010012702O0100083O0004813O00E0000100267601050010000100010004813O00100001001270010600013O002E3F010A00D8000100090004813O00D80001000E70000100D8000100060004813O00D80001002E3F010B00510001000C0004813O005100012O000E00075O0006270007005100013O0004813O005100012O000E000700013O0006270007005100013O0004813O005100012O000E000700024O0050010800033O00122O0009000D3O00122O000A000E6O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007005100013O0004813O005100010006270002005100013O0004813O005100012O000E000700043O0020460007000700104O00098O000A8O0007000A000200062O00070051000100010004813O005100012O000E000700053O000EB300110051000100070004813O005100012O000E000700063O00201700070007001200122O000900133O00122O000A00146O0007000A000200062O0007005100013O0004813O00510001002E3F01160051000100150004813O005100012O000E000700073O0020A80007000700174O000800023O00202O0008000800184O000900096O00070009000200062O0007005100013O0004813O005100012O000E000700033O001270010800193O0012700109001A4O006B000700094O001201075O002E3F011B00D70001001C0004813O00D700012O000E000700024O0050010800033O00122O0009001D3O00122O000A001E6O0008000A00024O00070007000800202O00070007001F4O00070002000200062O000700D700013O0004813O00D700012O000E000700083O00264A000700D7000100020004813O00D70001000627000200D700013O0004813O00D700012O000E000700024O0050010800033O00122O000900203O00122O000A00216O0008000A00024O00070007000800202O0007000700224O00070002000200062O000700D700013O0004813O00D700012O000E000700024O0009000800033O00122O000900233O00122O000A00246O0008000A00024O00070007000800202O0007000700254O000700020002000E2O000200D7000100070004813O00D700012O000E000700024O0050010800033O00122O000900263O00122O000A00276O0008000A00024O00070007000800202O0007000700284O00070002000200062O0007008A00013O0004813O008A00012O000E000700043O0020720107000700294O000900023O00202O0009000900184O00070009000200062O0007008A000100010004813O008A00012O000E000700083O000EB3001100D7000100070004813O00D700012O000E000700053O00264A000700D7000100050004813O00D700012O000E000700043O0020720107000700294O000900023O00202O00090009002A4O00070009000200062O000700D7000100010004813O00D70001002EAC002B00AA0001002C0004813O00AA00012O000E000700043O00206901070007002D2O0016010700020002000EB3002E00AA000100070004813O00AA0001002EAC002F00D7000100300004813O00D700012O000E000700073O0020F10007000700174O000800023O00202O0008000800314O00070002000200062O000700D700013O0004813O00D700012O000E000700033O001227010800323O00122O000900336O000700096O00075O00044O00D70001002E3F013500D7000100340004813O00D700012O000E000700024O003E000800033O00122O000900363O00122O000A00376O0008000A00024O00070007000800202O0007000700284O00070002000200062O000700D7000100010004813O00D70001001270010700014O003D010800083O002676010700B8000100010004813O00B80001001270010800013O002676010800BB000100010004813O00BB00012O000E000900073O0020F10009000900384O000A00023O00202O000A000A00314O00090002000200062O000900C900013O0004813O00C900012O000E000900033O001270010A00393O001270010B003A4O006B0009000B4O001201096O000E000900043O00206901090009002D2O0016010900020002002639000900D70001002E0004813O00D70001002E10013B00030001003C0004813O00D100010004813O00D700010012700109003D4O007A010900023O0004813O00D700010004813O00BB00010004813O00D700010004813O00B80001001270010600023O0026F3000600DC000100020004813O00DC0001002EAC003F00190001003E0004813O00190001001270010500023O0004813O001000010004813O001900010004813O00100001002E3F01410088030100400004813O00880301000E7000420088030100010004813O008803012O000E000500013O000640000500E9000100010004813O00E90001002E100143009F020100440004813O00860301001270010500014O003D010600073O000E7000020080030100050004813O00800301002676010600ED000100010004813O00ED0001001270010700013O002EAC0046000C020100450004813O000C02010026760107000C020100050004813O000C0201001270010800014O003D010900093O0026F3000800FA000100010004813O00FA0001002EAC004800F6000100470004813O00F60001001270010900013O00267601090003020100010004813O000302012O000E000A00013O000627000A000A2O013O0004813O000A2O012O000E000A00024O003E000B00033O00122O000C00493O00122O000D004A6O000B000D00024O000A000A000B00202O000A000A000F4O000A0002000200062O000A000C2O0100010004813O000C2O01002E3F014B00792O01004C0004813O00792O012O000E000A00024O00D2000B00033O00122O000C004D3O00122O000D004E6O000B000D00024O000A000A000B00202O000A000A004F4O000A00020002000E2O0008001D2O01000A0004813O001D2O012O000E000A00043O002065010A000A00294O000C00023O00202O000C000C00504O000A000C000200062O000A00422O013O0004813O00422O012O000E000A00043O002072010A000A00294O000C00023O00202O000C000C00514O000A000C000200062O000A00422O0100010004813O00422O012O000E000A00043O002069010A000A00522O0016010A00020002000EB3005300312O01000A0004813O00312O012O000E000A00043O002069010A000A00542O0016010A00020002000E290105006C2O01000A0004813O006C2O012O000E000A00083O000E290108006C2O01000A0004813O006C2O012O000E000A00024O0009000B00033O00122O000C00553O00122O000D00566O000B000D00024O000A000A000B00202O000A000A00574O000A00020002000E2O005800422O01000A0004813O00422O012O000E000A00043O002072010A000A00294O000C00023O00202O000C000C00594O000A000C000200062O000A006C2O0100010004813O006C2O012O000E000A00043O0020C6000A000A005A4O000C00023O00202O000C000C00594O000A000C0002000E2O004200532O01000A0004813O00532O012O000E000A00043O002072010A000A00294O000C00023O00202O000C000C00514O000A000C000200062O000A00532O0100010004813O00532O012O000E000A00083O000E290108006C2O01000A0004813O006C2O012O000E000A00043O002072010A000A00294O000C00023O00202O000C000C00514O000A000C000200062O000A00792O0100010004813O00792O012O000E000A00073O00202B010A000A005B4O000B00033O00122O000C005C3O00122O000D005D6O000B000D00024O000C00026O000D00033O00122O000E005E3O00122O000F005F6O000D000F00024O000C000C000D00202O000C000C00254O000C0002000200102O000C0060000C4O000A000C000200062O000A00792O013O0004813O00792O012O000E000A00094O00AE000B00023O00202O000B000B00514O000C000D6O000E00016O000A000E000200062O000A00792O013O0004813O00792O012O000E000A00033O001270010B00613O001270010C00624O006B000A000C4O0012010A6O000E000A00043O002072010A000A00294O000C00023O00202O000C000C00504O000A000C000200062O000A00822O0100010004813O00822O01002EAC0064002O020100630004813O002O0201001270010A00013O0026F3000A00872O0100010004813O00872O01002E3F016500C62O0100660004813O00C62O01001270010B00013O002676010B008C2O0100020004813O008C2O01001270010A00023O0004813O00C62O010026F3000B00902O0100010004813O00902O01002EAC006800882O0100670004813O00882O012O000E000C00024O003E000D00033O00122O000E00693O00122O000F006A6O000D000F00024O000C000C000D00202O000C000C001F4O000C0002000200062O000C009C2O0100010004813O009C2O01002EAC006C00AB2O01006B0004813O00AB2O012O000E000C00073O002078010C000C00174O000D00023O00202O000D000D006D4O000E000A6O000C000E000200062O000C00A62O0100010004813O00A62O01002E3F016E00AB2O01006F0004813O00AB2O012O000E000C00033O001270010D00703O001270010E00714O006B000C000E4O0012010C6O000E000C00024O003E000D00033O00122O000E00723O00122O000F00736O000D000F00024O000C000C000D00202O000C000C001F4O000C0002000200062O000C00B72O0100010004813O00B72O01002EAC007500C42O0100740004813O00C42O012O000E000C00073O002090010C000C00174O000D00023O00202O000D000D00764O000E000A6O000C000E000200062O000C00C42O013O0004813O00C42O012O000E000C00033O001270010D00773O001270010E00784O006B000C000E4O0012010C5O001270010B00023O0004813O00882O010026F3000A00CA2O0100020004813O00CA2O01002E10017900BBFF2O007A0004813O00832O01002EAC007C00E52O01007B0004813O00E52O012O000E000B00024O0050010C00033O00122O000D007D3O00122O000E007E6O000C000E00024O000B000B000C00202O000B000B001F4O000B0002000200062O000B00E52O013O0004813O00E52O01002E3F017F00E52O0100800004813O00E52O012O000E000B00073O002090010B000B00174O000C00023O00202O000C000C00814O000D000A6O000B000D000200062O000B00E52O013O0004813O00E52O012O000E000B00033O001270010C00823O001270010D00834O006B000B000D4O0012010B6O000E000B00024O003E000C00033O00122O000D00843O00122O000E00856O000C000E00024O000B000B000C00202O000B000B001F4O000B0002000200062O000B00F12O0100010004813O00F12O01002E3F0186002O020100870004813O002O0201002E3F0188002O020100890004813O002O02012O000E000B00073O002090010B000B00174O000C00023O00202O000C000C008A4O000D000A6O000B000D000200062O000B002O02013O0004813O002O02012O000E000B00033O001227010C008B3O00122O000D008C6O000B000D6O000B5O00044O002O02010004813O00832O01001270010900023O002EAC008E00FB0001008D0004813O00FB0001002676010900FB000100020004813O00FB0001001270010700083O0004813O000C02010004813O00FB00010004813O000C02010004813O00F600010026F300070010020100010004813O00100201002EAC008F00AF020100900004813O00AF0201002EAC0092006E020100910004813O006E02012O000E000800024O0050010900033O00122O000A00933O00122O000B00946O0009000B00024O00080008000900202O00080008001F4O00080002000200062O0008006E02013O0004813O006E02012O000E000800043O0020720108000800294O000A00023O00202O000A000A00594O0008000A000200062O0008002D020100010004813O002D02012O000E000800024O00B5000900033O00122O000A00953O00122O000B00966O0009000B00024O00080008000900202O00080008004F4O00080002000200262O0008006E020100140004813O006E02010006270002005702013O0004813O005702012O000E0008000B3O000EB300050057020100080004813O005702012O000E000800063O0020E60008000800124O000A00033O00122O000B00973O00122O000C00986O000A000C000200122O000B00146O0008000B000200062O0008005702013O0004813O005702012O000E000800024O0050010900033O00122O000A00993O00122O000B009A6O0009000B00024O00080008000900202O0008000800284O00080002000200062O0008006102013O0004813O006102012O000E000800024O00E3000900033O00122O000A009B3O00122O000B009C6O0009000B00024O00080008000900202O00080008004F4O00080002000200262O000800610201009D0004813O006102012O000E000800063O00207201080008009E4O000A00023O00202O000A000A009F4O0008000A000200062O00080061020100010004813O006102012O000E000800073O00206A01080008005B4O000900033O00122O000A00A03O00122O000B00A16O0009000B000200122O000A00A26O0008000A000200062O0008006E02013O0004813O006E02012O000E000800073O0020310108000800174O000900023O00202O0009000900A34O000A00016O0008000A000200062O0008006E02013O0004813O006E02012O000E000800033O001270010900A43O001270010A00A54O006B0008000A4O001201086O000E000800024O0050010900033O00122O000A00A63O00122O000B00A76O0009000B00024O00080008000900202O00080008000F4O00080002000200062O000800AE02013O0004813O00AE02012O000E00085O000627000800AE02013O0004813O00AE02012O000E0008000B3O000EB3000800AE020100080004813O00AE02012O000E0008000C3O0006400008008E020100010004813O008E02012O000E000800083O0026340008008E020100420004813O008E02012O000E000800024O0050010900033O00122O000A00A83O00122O000B00A96O0009000B00024O00080008000900202O0008000800284O00080002000200062O000800AE02013O0004813O00AE02012O000E000800043O0020720108000800294O000A00023O00202O000A000A00594O0008000A000200062O0008009F020100010004813O009F02012O000E000800024O003E000900033O00122O000A00AA3O00122O000B00AB6O0009000B00024O00080008000900202O0008000800284O00080002000200062O000800AE020100010004813O00AE02012O000E000800073O0020370108000800174O000900023O00202O0009000900AC4O000A000A6O0008000A000200062O000800A9020100010004813O00A90201002E1001AD0007000100AE0004813O00AE02012O000E000800033O001270010900AF3O001270010A00B04O006B0008000A4O001201085O001270010700023O0026760107005C030100020004813O005C0301001270010800014O003D010900093O000E70000100B3020100080004813O00B30201001270010900013O002E3F01B10055030100B20004813O0055030100267601090055030100010004813O005503012O000E000A00024O003E000B00033O00122O000C00B33O00122O000D00B46O000B000D00024O000A000A000B00202O000A000A000F4O000A0002000200062O000A00C6020100010004813O00C60201002E3F01B6001C030100B50004813O001C0301001270010A00013O0026F3000A00CB020100010004813O00CB0201002EAC00B800C7020100B70004813O00C702012O000E000B000D3O000627000B00EE02013O0004813O00EE02012O000E000B00043O002065010B000B00294O000D00023O00202O000D000D00504O000B000D000200062O000B00EE02013O0004813O00EE02012O000E000B00053O00264A000B00EE020100050004813O00EE02012O000E000B00043O002065010B000B00294O000D00023O00202O000D000D002A4O000B000D000200062O000B00E202013O0004813O00E202012O000E000B00083O000E35004200EE0201000B0004813O00EE02012O000E000B00073O0020F1000B000B00174O000C00023O00202O000C000C00314O000B0002000200062O000B00EE02013O0004813O00EE02012O000E000B00033O001270010C00B93O001270010D00BA4O006B000B000D4O0012010B6O000E000B00024O003E000C00033O00122O000D00BB3O00122O000E00BC6O000C000E00024O000B000B000C00202O000B000B00284O000B0002000200062O000B001C030100010004813O001C03012O000E000B00083O000EB30008001C0301000B0004813O001C03012O000E000B00024O0009000C00033O00122O000D00BD3O00122O000E00BE6O000C000E00024O000B000B000C00202O000B000B00254O000B00020002000E2O0002001C0301000B0004813O001C03012O000E000B00043O002046000B000B00104O000D00016O000E00016O000B000E000200062O000B001C030100010004813O001C0301002EAC00BF001C030100890004813O001C03012O000E000B00073O0020F1000B000B00174O000C00023O00202O000C000C00314O000B0002000200062O000B001C03013O0004813O001C03012O000E000B00033O001227010C00C03O00122O000D00C16O000B000D6O000B5O00044O001C03010004813O00C702012O000E000A00024O0050010B00033O00122O000C00C23O00122O000D00C36O000B000D00024O000A000A000B00202O000A000A001F4O000A0002000200062O000A005403013O0004813O005403012O000E000A000E4O00B6000A00010002000627000A005403013O0004813O005403012O000E000A00043O002072010A000A00294O000C00023O00202O000C000C00594O000A000C000200062O000A0054030100010004813O005403012O000E000A00073O00206A010A000A005B4O000B00033O00122O000C00C43O00122O000D00C56O000B000D000200122O000C009D6O000A000C000200062O000A005403013O0004813O005403012O000E000A00013O000627000A005403013O0004813O00540301001270010A00013O002676010A003F030100010004813O003F03012O000E000B00104O007C000C00023O00202O000C000C00C64O000B000200024O000B000F6O000B000F3O00062O000B004B030100010004813O004B0301002E3F01C80054030100C70004813O005403012O000E000B00033O001264000C00C93O00122O000D00CA6O000B000D00024O000C000F6O000B000B000C4O000B00023O00044O005403010004813O003F0301001270010900023O002676010900B6020100020004813O00B60201001270010700053O0004813O005C03010004813O00B602010004813O005C03010004813O00B302010026F300070060030100080004813O00600301002E3F01CB00F0000100CC0004813O00F000012O000E000800113O0006270008006603013O0004813O006603012O000E000800013O00064000080068030100010004813O00680301002E3F01CD0086030100CE0004813O00860301001270010800014O003D010900093O0026760108006A030100010004813O006A0301001270010900013O0026760109006D030100010004813O006D03012O000E000A00124O00B6000A000100022O00BB000A000F4O000E000A000F3O000627000A008603013O0004813O008603012O000E000A000F4O007A010A00023O0004813O008603010004813O006D03010004813O008603010004813O006A03010004813O008603010004813O00F000010004813O008603010004813O00ED00010004813O00860301000E70000100EB000100050004813O00EB0001001270010600014O003D010700073O001270010500023O0004813O00EB00012O007600056O007A010500023O001270010400053O0026F30004008D030100010004813O008D0301002E1001CF00792O0100D00004813O00040501002E3F01D100ED030100D20004813O00ED0301000E70000100ED030100010004813O00ED0301001270010500014O003D010600063O0026F300050097030100010004813O00970301002E3F01D30093030100D40004813O00930301001270010600013O0026F30006009C030100010004813O009C0301002E1001D5004C000100D60004813O00E60301001270010700013O002E3F01D800A3030100D70004813O00A30301002676010700A3030100020004813O00A30301001270010600023O0004813O00E60301002E1001D900FAFF2O00D90004813O009D0301000E700001009D030100070004813O009D03012O000E000800043O0020650108000800294O000A00023O00202O000A000A00314O0008000A000200062O000800E103013O0004813O00E103012O000E000800024O0050010900033O00122O000A00DA3O00122O000B00DB6O0009000B00024O00080008000900202O00080008001F4O00080002000200062O000800D003013O0004813O00D003012O000E000800024O0050010900033O00122O000A00DC3O00122O000B00DD6O0009000B00024O00080008000900202O00080008001F4O00080002000200062O000800D003013O0004813O00D003012O000E000800043O0020720108000800294O000A00023O00202O000A000A00504O0008000A000200062O000800D0030100010004813O00D003012O000E000800043O0020650108000800294O000A00023O00202O000A000A00594O0008000A000200062O000800D203013O0004813O00D20301002E1001DE0011000100DF0004813O00E103012O000E000800073O0020790108000800174O000900023O00202O0009000900504O000A00016O0008000A000200062O000800DC030100010004813O00DC0301002E1001E00007000100E10004813O00E103012O000E000800033O001270010900E23O001270010A00E34O006B0008000A4O001201086O000E0008000D4O00B60008000100022O00F6000200083O001270010700023O0004813O009D0301000E7000020098030100060004813O009803010012702O0100023O0004813O00ED03010004813O009803010004813O00ED03010004813O009303010026762O010003050100080004813O00030501001270010500013O002EAC00E500F6030100E40004813O00F60301002676010500F6030100020004813O00F603010012702O0100423O0004813O00030501002676010500F0030100010004813O00F003012O000E00065O0006270006008F04013O0004813O008F0401001270010600013O002EAC00E600FC030100E70004813O00FC0301002676010600FC030100010004813O00FC03012O000E000700013O0006270007002704013O0004813O002704012O000E000700024O0050010800033O00122O000900E83O00122O000A00E96O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007002704013O0004813O002704010006270002002704013O0004813O002704012O000E0007000B3O000EB300020027040100070004813O002704012O000E000700063O00204A01070007001200122O000900EA3O00122O000A00EB6O0007000A000200062O00070027040100010004813O00270401002E3F01ED0027040100EC0004813O002704012O000E000700073O0020F10007000700174O000800023O00202O00080008009F4O00070002000200062O0007002704013O0004813O002704012O000E000700033O001270010800EE3O001270010900EF4O006B000700094O001201076O000E000700024O003E000800033O00122O000900F03O00122O000A00F16O0008000A00024O00070007000800202O00070007001F4O00070002000200062O00070033040100010004813O00330401002E1001F2005E000100F30004813O008F04012O000E000700043O0020A600070007005A4O000900023O00202O0009000900504O00070009000200262O00070044040100080004813O004404012O000E000700024O0050010800033O00122O000900F43O00122O000A00F56O0008000A00024O00070007000800202O0007000700224O00070002000200062O0007004B04013O0004813O004B04012O000E000700043O00204A0107000700F600122O000900F73O00122O000A00056O0007000A000200062O0007007F040100010004813O007F04012O000E000700134O00B60007000100020006270007007F04013O0004813O007F04010006270002007F04013O0004813O007F04012O000E000700024O003E000800033O00122O000900F83O00122O000A00F96O0008000A00024O00070007000800202O0007000700284O00070002000200062O00070068040100010004813O006804012O000E000700053O00263400070082040100020004813O008204012O000E000700024O0050010800033O00122O000900FA3O00122O000A00FB6O0008000A00024O00070007000800202O0007000700284O00070002000200062O0007008204013O0004813O008204012O000E000700024O006C000800033O00122O000900FC3O00122O000A00FD6O0008000A00024O00070007000800202O00070007004F4O000700020002000E7200140082040100070004813O008204012O000E000700024O0050010800033O00122O000900FE3O00122O000A00FF6O0008000A00024O00070007000800202O0007000700224O00070002000200062O0007007F04013O0004813O007F04012O000E000700053O000E2901110082040100070004813O008204010012700107002O012O0026670007008F04012O000104813O008F04012O000E000700094O000E000800023O0020850008000800502O00160107000200020006270007008F04013O0004813O008F04012O000E000700033O00122701080002012O00122O00090003015O000700096O00075O00044O008F04010004813O00FC03012O000E000600024O003E000700033O00122O00080004012O00122O00090005015O0007000900024O00060006000700202O00060006001F4O00060002000200062O0006009D040100010004813O009D040100127001060006012O00127001070007012O0006BC00060001050100070004813O00010501001270010600014O003D010700073O001270010800013O0006BC0006009F040100080004813O009F0401001270010700013O001270010800013O000602000700AA040100080004813O00AA040100127001080008012O00127001090009012O00065E010900A3040100080004813O00A304012O000E000800063O00201400080008001200122O000A00EA6O000B000B6O0008000B000200062O000800B5040100010004813O00B504010012700108000A012O0012700109000B012O0006BC000800C7040100090004813O00C704012O000E000800073O0020D50008000800174O000900023O00122O000A000C015O00090009000A4O000A00146O0008000A000200062O000800C2040100010004813O00C204010012700108000D012O0012700109000E012O000612000800C7040100090004813O00C704012O000E000800033O0012700109000F012O001270010A0010013O006B0008000A4O001201086O000E000800043O0020460008000800104O000A00016O000B00016O0008000B000200062O00080001050100010004813O000105012O000E0008000B4O0081010900153O00122O000A0011015O00090009000A4O00090001000200062O00090001050100080004813O0001050100127001080012012O00127001090013012O00065E010900E4040100080004813O00E404012O000E000800163O000640000800E4040100010004813O00E404012O000E000800073O00124601090014015O0008000800094O000900023O00122O000A000C015O00090009000A4O00080002000100044O000105012O000E000800013O000640000800EB040100010004813O00EB040100127001080015012O00127001090016012O00065E01080001050100090004813O0001050100127001080017012O00127001090017012O0006BC00080001050100090004813O000105012O000E000800073O0020630108000800174O000900023O00122O000A000C015O00090009000A4O000A00146O0008000A000200062O0008000105013O0004813O000105012O000E000800033O00122701090018012O00122O000A0019015O0008000A6O00085O00044O000105010004813O00A304010004813O000105010004813O009F0401001270010500023O0004813O00F00301001270010400023O001270010500053O0006BC0004000B000100050004813O000B00010012700105001A012O0012700106001B012O00065E01050004000100060004813O00040001001270010500023O0006BC00010004000100050004813O00040001001270010500014O003D010600063O0012700107001C012O0012700108001D012O00065E01070010050100080004813O00100501001270010700013O0006BC00050010050100070004813O00100501001270010600013O0012700107001E012O0012700108001E012O0006BC000700A2050100080004813O00A20501001270010700013O0006BC000600A2050100070004813O00A20501001270010700013O001270010800023O0006BC00070025050100080004813O00250501001270010600023O0004813O00A20501001270010800013O0006BC00070020050100080004813O002005012O000E000800024O0050010900033O00122O000A001F012O00122O000B0020015O0009000B00024O00080008000900202O00080008001F4O00080002000200062O0008007205013O0004813O007205012O000E000800053O001270010900053O00061200080072050100090004813O007205012O000E000800043O00124B000A0021015O00080008000A4O000A00023O00122O000B0022015O000A000A000B4O0008000A000200122O000900083O00062O00090072050100080004813O007205012O000E000800024O0029000900033O00122O000A0023012O00122O000B0024015O0009000B00024O00080008000900202O00080008004F4O00080002000200122O000900F73O00062O0009000B000100080004813O005505012O000E000800024O003E000900033O00122O000A0025012O00122O000B0026015O0009000B00024O00080008000900202O0008000800284O00080002000200062O00080072050100010004813O00720501001270010800014O003D010900093O001270010A00013O0006BC000800570501000A0004813O00570501001270010900013O001270010A00013O0006BC0009005B0501000A0004813O005B05012O000E000A00104O0086010B00023O00122O000C0027015O000B000B000C4O000A000200024O000A000F6O000A000F3O00062O000A007205013O0004813O007205012O000E000A00033O001264000B0028012O00122O000C0029015O000A000C00024O000B000F6O000A000A000B4O000A00023O00044O007205010004813O005B05010004813O007205010004813O005705010012700108002A012O0012700109001D012O000612000800A0050100090004813O00A005012O000E000800024O0050010900033O00122O000A002B012O00122O000B002C015O0009000B00024O00080008000900202O00080008000F4O00080002000200062O000800A005013O0004813O00A005012O000E000800024O003E000900033O00122O000A002D012O00122O000B002E015O0009000B00024O00080008000900202O0008000800284O00080002000200062O000800A0050100010004813O00A005012O000E000800053O001270010900113O000612000900A0050100080004813O00A005012O000E000800073O00200B0008000800174O000900023O00122O000A002F015O00090009000A4O000A00016O0008000A000200062O0008009B050100010004813O009B0501001270010800B63O00127001090030012O00065E010900A0050100080004813O00A005012O000E000800033O00127001090031012O001270010A0032013O006B0008000A4O001201085O001270010700023O0004813O00200501001270010700023O000602000600A9050100070004813O00A9050100127001070033012O00127001080034012O00065E01080018050100070004813O001805010012702O0100053O0004813O000400010004813O001805010004813O000400010004813O001005010004813O000400010004813O000B00010004813O000400010004813O000600010004813O000400010004813O00BF050100127001030035012O00127001040036012O00065E01030002000100040004813O00020001001270010300013O0006BC0003000200013O0004813O000200010012702O0100014O003D010200023O001270012O00023O0004813O000200012O003E012O00017O00693O00028O00025O00405F40025O0042A040026O00F03F025O00349D40025O0024B340025O00C49B40025O00E0A940030B3O00B8D234E28904140785D93003083O0066EBBA5586E6735003143O0054696D6553696E63654C617374446973706C6179026O33D33F030A3O0064043F5B7DC32F52003A03073O0042376C5E3F12B403093O00497354616E6B696E67025O00489240025O00A49D4003063O00228C8B3E345103063O003974EDE55747030A3O0049734361737461626C65030C3O008EB0E3F472C346A9B0EFF57203073O0027CAD18D87178E030B3O004973417661696C61626C65026O000840030C3O00D93F080D37F4F3321D033DF603063O00989F53696A52030F3O00432O6F6C646F776E52656D61696E73026O004E40030C3O00A7CA50F5CC508DC745FBC65203063O003CE1A63192A903183O00426F2O7346696C7465726564466967687452656D61696E7303023O00734303063O00674F7E4F4A6103063O008C7EDD7A4D1203063O007ADA1FB3133E03073O0043686172676573026O003E40025O00C08B40025O0080874003063O0056616E697368025O0022A840025O006EAF40030D3O0085D7C3C8DAA9059ED7CED3C6E103073O0025D3B6ADA1A9C1030B3O00C4324CDD276C9DF6344EDC03073O00D9975A2DB9481B030B3O00F074E61659D458E61C55C603053O0036A31C877203063O001EDA538B5D7703063O001F48BB3DE22E030A3O00F00E42D6486929C60A4703073O0044A36623B2271E030B3O008D78DBC30CA2A710B073DF03083O0071DE10BAA763D5E303113O00436861726765734672616374696F6E616C03113O001D06FAF22119DFF7200DFEC22F02FEF83A03043O00964E6E9B026O00E83F03113O00B6CD26E5AB099B418BC622D5A512BA4E9103083O0020E5A54781C47EDF030B3O0042752O6652656D61696E73030E3O0053796D626F6C736F664465617468030C3O00E585C58684D9CF88D0888EDB03063O00B5A3E9A42OE1029A5O99014003113O0063833F735F9C1A765E883B4351873B794403043O001730EB5E030F3O004FDFDB4F5227E679D9D0535E22C77903073O00B21CBAB83D3753026O002240030C3O00E0CC492FF723F4C7CC452EF703073O0095A4AD275C926E03173O00466C6167652O6C6174696F6E5065727369737442752O66026O001840026O001040030E3O00C03E2O1D1517E028163B1F1AE72F03063O007B9347707F7A026O002440025O00F2B240025O00989640025O0040A840025O00E88F40030B3O00536861646F7744616E6365025O00C09840025O004CB14003143O00FFC5837549DBE9837F45C98DAF7045DE2OC2200603053O0026ACADE211025O00B09440025O00209E4003013O003C030E3O007E0821ED421D3FE04B3529EE591903043O008F2D714C03113O008BB01D38B7AF383DB6BB1908B9B41932AC03043O005C2OD87C03083O00446562752O66557003073O0052757074757265025O0015B240025O00BEA640025O007AAE40025O00B07740025O0034954003143O00683AAD44F24C16AD4EFE5E728141FE493DEC12BD03053O009D3B52CC20025O00C49540025O00A0764001C8012O0012702O0100013O001270010200013O002EAC00020002000100030004813O0002000100267601020002000100010004813O000200010026762O0100C02O0100010004813O00C02O01001270010300013O002676010300B92O0100010004813O00B92O01001270010400013O0026F300040010000100040004813O00100001002E1001050004000100060004813O00120001001270010300043O0004813O00B92O010026F300040016000100010004813O00160001002E3F0108000C000100070004813O000C00012O000E00055O0006270005003300013O0004813O003300012O000E000500014O00E8000600023O00122O000700093O00122O0008000A6O0006000800024O00050005000600202O00050005000B4O000500020002000E2O000C0033000100050004813O003300012O000E000500014O00E8000600023O00122O0007000D3O00122O0008000E6O0006000800024O00050005000600202O00050005000B4O000500020002000E2O000C0033000100050004813O003300012O000E000500033O00206901050005000F2O000E000700044O00710005000700020006270005003500013O0004813O00350001002EAC00110098000100100004813O009800012O000E000500014O0050010600023O00122O000700123O00122O000800136O0006000800024O00050005000600202O0005000500144O00050002000200062O0005009800013O0004813O009800012O000E000500014O0050010600023O00122O000700153O00122O000800166O0006000800024O00050005000600202O0005000500174O00050002000200062O0005004C00013O0004813O004C00012O000E000500053O000EB300180098000100050004813O009800012O000E000500064O00B600050001000200064000050098000100010004813O009800012O000E000500073O000E3500040098000100050004813O009800012O000E000500014O00D2000600023O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O00050005001B4O000500020002000E2O001C0079000100050004813O007900012O000E000500014O0050010600023O00122O0007001D3O00122O0008001E6O0006000800024O00050005000600202O0005000500174O00050002000200062O0005007900013O0004813O007900012O000E000500083O00202B01050005001F4O000600023O00122O000700203O00122O000800216O0006000800024O000700016O000800023O00122O000900223O00122O000A00236O0008000A00024O00070007000800202O0007000700244O00070002000200102O0007002500074O00050007000200062O0005009800013O0004813O00980001001270010500014O003D010600063O002E3F0127007B000100260004813O007B00010026760105007B000100010004813O007B0001001270010600013O00267601060080000100010004813O008000012O000E0007000A4O0032000800013O00202O0008000800284O00098O0007000900024O000700096O000700093O00062O0007008D000100010004813O008D0001002EAC002A0098000100290004813O009800012O000E000700023O0012640008002B3O00122O0009002C6O0007000900024O000800096O0007000700084O000700023O00044O009800010004813O008000010004813O009800010004813O007B00012O000E0005000B3O000627000500B72O013O0004813O00B72O012O000E00055O000627000500B72O013O0004813O00B72O012O000E000500014O0050010600023O00122O0007002D3O00122O0008002E6O0006000800024O00050005000600202O0005000500144O00050002000200062O000500B72O013O0004813O00B72O012O000E000500014O0009000600023O00122O0007002F3O00122O000800306O0006000800024O00050005000600202O0005000500244O000500020002000E2O000400B72O0100050004813O00B72O012O000E000500014O00E8000600023O00122O000700313O00122O000800326O0006000800024O00050005000600202O00050005000B4O000500020002000E2O000C00B72O0100050004813O00B72O012O000E000500014O00E8000600023O00122O000700333O00122O000800346O0006000800024O00050005000600202O00050005000B4O000500020002000E2O000C00B72O0100050004813O00B72O012O000E00055O000640000500E3000100010004813O00E300012O000E000500014O006C000600023O00122O000700353O00122O000800366O0006000800024O00050005000600202O0005000500374O0005000200022O000E0006000C4O000E000700014O003E000800023O00122O000900383O00122O000A00396O0008000A00024O00070007000800202O0007000700174O00070002000200062O000700DF000100010004813O00DF00010012700107003A3O000640000700E0000100010004813O00E00001001270010700014O001F010600060007000612000600B72O0100050004813O00B72O01001270010500013O000E70000100E4000100050004813O00E400012O000E0006000D4O00B60006000100020006270006000A2O013O0004813O000A2O012O000E000600014O003E000700023O00122O0008003B3O00122O0009003C6O0007000900024O00060006000700202O0006000600174O00060002000200062O000600062O0100010004813O00062O012O000E000600033O00203B00060006003D4O000800013O00202O00080008003E4O0006000800024O0007000E6O000800016O000900023O00122O000A003F3O00122O000B00406O0009000B00022O00630008000800090020AA0008000800174O000800096O00073O000200102O00070041000700062O0007003A000100060004813O003F2O012O000E000600064O00B60006000100020006400006003F2O0100010004813O003F2O012O000E000600014O0050010700023O00122O000800423O00122O000900436O0007000900024O00060006000700202O0006000600174O00060002000200062O0006002B2O013O0004813O002B2O012O000E000600014O001C010700023O00122O000800443O00122O000900456O0007000900024O00060006000700202O00060006001B4O00060002000200262O0006002B2O0100460004813O002B2O012O000E000600053O0026340006003F2O0100180004813O003F2O012O000E000600014O003E000700023O00122O000800473O00122O000900486O0007000900024O00060006000700202O0006000600174O00060002000200062O0006003F2O0100010004813O003F2O012O000E000600033O00205501060006003D4O000800013O00202O0008000800494O000600080002000E2O004A003F2O0100060004813O003F2O012O000E000600053O000EB3004B00642O0100060004813O00642O012O000E000600014O00E8000700023O00122O0008004C3O00122O0009004D6O0007000900024O00060006000700202O00060006001B4O000600020002000E2O004E00642O0100060004813O00642O012O000E0006000F4O00B6000600010002000627000600642O013O0004813O00642O01001270010600014O003D010700073O0026F3000600492O0100010004813O00492O01002E10014F00FEFF2O00500004813O00452O01001270010700013O0026F30007004E2O0100010004813O004E2O01002E10015100FEFF2O00520004813O004A2O012O000E0008000A4O00A3000900013O00202O0009000900534O000A8O0008000A00024O000800093O002E2O005400642O0100550004813O00642O012O000E000800093O000627000800642O013O0004813O00642O012O000E000800023O001264000900563O00122O000A00576O0008000A00024O000900096O0008000800094O000800023O00044O00642O010004813O004A2O010004813O00642O010004813O00452O01002EAC005800B72O0100590004813O00B72O012O000E000600104O00B6000600010002000627000600B72O013O0004813O00B72O012O000E0006000D4O00B60006000100020006270006007C2O013O0004813O007C2O012O000E000600083O00203001060006001F00122O0007005A6O000800016O000900023O00122O000A005B3O00122O000B005C6O0009000B00024O00080008000900202O00080008001B4O000800096O00063O000200062O000600942O0100010004813O00942O012O000E000600014O003E000700023O00122O0008005D3O00122O0009005E6O0007000900024O00060006000700202O0006000600174O00060002000200062O000600B72O0100010004813O00B72O012O000E000600043O00206501060006005F4O000800013O00202O0008000800604O00060008000200062O000600B72O013O0004813O00B72O012O000E000600053O00264A000600B72O01004B0004813O00B72O012O000E0006000F4O00B6000600010002000627000600B72O013O0004813O00B72O01001270010600014O003D010700073O002E1001613O000100610004813O00962O01000E70000100962O0100060004813O00962O01001270010700013O002EAC0062009B2O0100630004813O009B2O01000E700001009B2O0100070004813O009B2O012O000E0008000A4O00A3000900013O00202O0009000900534O000A8O0008000A00024O000800093O002E2O006400B72O0100650004813O00B72O012O000E000800093O000627000800B72O013O0004813O00B72O012O000E000800023O001264000900663O00122O000A00676O0008000A00024O000900096O0008000800094O000800023O00044O00B72O010004813O009B2O010004813O00B72O010004813O00962O010004813O00B72O010004813O00E40001001270010400043O0004813O000C00010026F3000300BD2O0100040004813O00BD2O01002E3F01680009000100690004813O000900010012702O0100043O0004813O00C02O010004813O00090001000E7000040001000100010004813O000100012O007600036O007A010300023O0004813O000100010004813O000200010004813O000100012O003E012O00017O00463O00028O00025O00D09640026O00F03F025O0078AB40025O00409540025O00889D40025O00C05E40025O004C9A40025O0002A840030F3O00456E65726779507265646963746564030D3O000B36F6E8E0E1D6BF0B2AECE8E403083O00D1585E839A898AB3030A3O0049734361737461626C65027O0040030A3O000FADCB7313213D232CA403083O004248C1A41C7E4351030B3O004973417661696C61626C65030B3O0042752O6652656D61696E7303133O004C696E676572696E67536861646F7742752O66026O00184003063O0042752O66557003133O00506572666F72617465645665696E7342752O66025O00089E40025O00DAA44003043O0043617374030D3O0053687572696B656E53746F726D025O00406040025O00A0A94003133O00C42DBB4C6645EF39BA512D73E96C9B4C2964EA03063O0016874CC83846025O0042B340025O005DB040025O003C9240025O00449740025O00B0AF40025O00F08440025O00907440025O00E07C40025O00A6A940025O00F4904003103O00A833F02B54EF8A02FD344FE88031F62003063O0081ED5098443D03063O00456E65726779026O004E4003113O004563686F696E6752657072696D616E6433026O00084003113O004563686F696E6752657072696D616E6434026O00104003113O004563686F696E6752657072696D616E643503093O0054696D65546F536874026O00E03F026O001440025O00B88740025O0018B04003143O00748444D42O195D43A910FC0E57685EA708FA121003073O003831C864937C77030A3O00EB32B0FFC13CB3F1C83B03043O0090AC5EDF030A3O00476C2O6F6D626C616465030F3O00070EB1536428AE482B02A04B250BA703043O0027446FC2025O00406940025O00EEA74003083O00F4A7E4CC6AA3D7A403063O00D7B6C687A71903083O004261636B73746162025O000C9940025O00FCB140030D3O00AE48F95CCD6BEB4B865AFE498F03043O0028ED298A013F012O0012702O0100014O003D010200033O002E100102000F000100020004813O001100010026762O010011000100010004813O00110001001270010400013O000E700001000C000100040004813O000C0001001270010200014O003D010300033O001270010400033O000E7000030007000100040004813O000700010012702O0100033O0004813O001100010004813O000700010026762O010002000100030004813O00020001001270010400014O003D010500053O0026F300040019000100010004813O00190001002E3F01040015000100050004813O00150001001270010500013O000E740001001E000100050004813O001E0001002E3F0106001A000100070004813O001A000100267601020093000100010004813O00930001001270010600013O0026F300060025000100030004813O00250001002E3F01090027000100080004813O00270001001270010200033O0004813O0093000100267601060021000100010004813O002100010006273O003100013O0004813O003100012O000E00075O00206901070007000A2O001601070002000200065C012O0002000100070004813O003100012O009C00036O0076000300014O000E000700013O0006270007007F00013O0004813O007F00012O000E000700024O0050010800033O00122O0009000B3O00122O000A000C6O0008000A00024O00070007000800202O00070007000D4O00070002000200062O0007007F00013O0004813O007F00012O000E000700044O000E000800053O0012700109000E4O000E000A00064O0039010B00026O000C00033O00122O000D000F3O00122O000E00106O000C000E00024O000B000B000C00202O000B000B00114O000B0002000200062O000B005400013O0004813O005400012O000E000B5O002055010B000B00124O000D00023O00202O000D000D00134O000B000D0002000E2O0014005B0001000B0004813O005B00012O000E000B5O002087000B000B00154O000D00023O00202O000D000D00164O000B000D000200044O005C00012O009C000B6O0076000B00014O0071010A000B4O001800083O00024O000900073O00122O000A000E6O000B00066O000C00026O000D00033O00122O000E000F3O00122O000F00106O000D000F00024O000C000C000D00202O000C000C00114O000C0002000200062O000C007200013O0004813O007200012O000E000C5O002055010C000C00124O000E00023O00202O000E000E00134O000C000E0002000E2O001400790001000C0004813O007900012O000E000C5O002087000C000C00154O000E00023O00202O000E000E00164O000C000E000200044O007A00012O009C000C6O0076000C00014O0071010B000C4O00D800093O00022O004B01080008000900065C01080003000100070004813O00810001002E3F01180091000100170004813O009100010006270003008A00013O0004813O008A00012O000E000700083O0020020107000700194O000800023O00202O00080008001A4O00070002000200062O0007008C000100010004813O008C0001002E10011B00070001001C0004813O009100012O000E000700033O0012700108001D3O0012700109001E4O006B000700094O001201075O001270010600033O0004813O002100010026F300020097000100030004813O00970001002E3F011F0013000100200004813O00130001001270010600013O00267601060098000100010004813O00980001002EAC002100342O0100220004813O00342O012O000E000700093O000627000700342O013O0004813O00342O01001270010700014O003D010800093O002E3F012400A8000100230004813O00A80001002676010700A8000100010004813O00A80001001270010800014O003D010900093O001270010700033O002EAC002500A1000100260004813O00A10001002676010700A1000100030004813O00A10001002676010800AC000100010004813O00AC0001001270010900013O002EAC002800AF000100270004813O00AF0001002676010900AF000100010004813O00AF00012O000E000A00024O0050010B00033O00122O000C00293O00122O000D002A6O000B000D00024O000A000A000B00202O000A000A00114O000A0002000200062O000A00F200013O0004813O00F200012O000E000A5O002069010A000A002B2O0016010A00020002002667000A00F20001002C0004813O00F200012O000E000A000A3O002676010A00CC0001000E0004813O00CC00012O000E000A5O002072010A000A00154O000C00023O00202O000C000C002D4O000A000C000200062O000A00E0000100010004813O00E000012O000E000A000A3O002676010A00D60001002E0004813O00D600012O000E000A5O002072010A000A00154O000C00023O00202O000C000C002F4O000A000C000200062O000A00E0000100010004813O00E000012O000E000A000A3O002676010A00F2000100300004813O00F200012O000E000A5O002065010A000A00154O000C00023O00202O000C000C00314O000A000C000200062O000A00F200013O0004813O00F200012O000E000A000B3O002085000A000A0032001270010B002E4O0016010A00020002002639000A00F4000100330004813O00F400012O000E000A000B3O002085000A000A0032001270010B00304O0016010A00020002002639000A00F4000100030004813O00F400012O000E000A000B3O002085000A000A0032001270010B00344O0016010A00020002002639000A00F4000100030004813O00F40001002EAC003600F9000100350004813O00F900012O000E000A00033O001270010B00373O001270010C00384O006B000A000C4O0012010A6O000E000A00024O0050010B00033O00122O000C00393O00122O000D003A6O000B000D00024O000A000A000B00202O000A000A000D4O000A0002000200062O000A00122O013O0004813O00122O01000627000300342O013O0004813O00342O012O000E000A00083O0020F1000A000A00194O000B00023O00202O000B000B003B4O000A0002000200062O000A00342O013O0004813O00342O012O000E000A00033O001227010B003C3O00122O000C003D6O000A000C6O000A5O00044O00342O01002EAC003E00342O01003F0004813O00342O012O000E000A00024O0050010B00033O00122O000C00403O00122O000D00416O000B000D00024O000A000A000B00202O000A000A000D4O000A0002000200062O000A00342O013O0004813O00342O01000627000300272O013O0004813O00272O012O000E000A00083O002002010A000A00194O000B00023O00202O000B000B00424O000A0002000200062O000A00292O0100010004813O00292O01002EAC004400342O0100430004813O00342O012O000E000A00033O001227010B00453O00122O000C00466O000A000C6O000A5O00044O00342O010004813O00AF00010004813O00342O010004813O00AC00010004813O00342O010004813O00A100012O007600076O007A010700023O0004813O009800010004813O001300010004813O001A00010004813O001300010004813O001500010004813O001300010004813O003E2O010004813O000200012O003E012O00017O00033O0003073O00435F54696D657203053O004166746572026O00D03F00393O0012133O00013O0020855O00020012702O0100033O0006CF00023O000100332O000E8O000E3O00014O000E3O00024O000E3O00034O000E3O00044O000E3O00054O000E3O00064O000E3O00074O000E3O00084O000E3O00094O000E3O000A4O000E3O000B4O000E3O000C4O000E3O000D4O000E3O000E4O000E3O000F4O000E3O00104O000E3O00114O000E3O00124O000E3O00134O000E3O00144O000E3O00154O000E3O00164O000E3O00174O000E3O00184O000E3O00194O000E3O001A4O000E3O001B4O000E3O001C4O000E3O001D4O000E3O001E4O000E3O001F4O000E3O00204O000E3O00214O000E3O00224O000E3O00234O000E3O00244O000E3O00254O000E3O00264O000E3O00274O000E3O00284O000E3O00294O000E3O002A4O000E3O002B4O000E3O002C4O000E3O002D4O000E3O002E4O000E3O002F4O000E3O00304O000E3O00314O000E3O00324O00773O000200012O003E012O00013O00013O006F012O00028O00026O002040025O0040A440025O00E89840026O00F03F025O0026A140025O0084B340030F3O00412O66656374696E67436F6D626174025O00108D40025O00508940025O00BAB240025O0014A540025O00588140025O00388140025O00507040025O003AAE40030D3O00546172676574497356616C6964025O00E07440025O00D4A74003063O0045786973747303103O001AEE8315CA3DF38C02C92BC89817C52B03053O00A14E9CEA7603073O0049735265616479025O008AAC40025O00C7B24003153O00547269636B736F667468655472616465466F637573031D3O00B7A5CCDFA8BACBDDB3F7DDCEAEB4C2CF98B8CFE3B3BFCCE3B3A5C8D8A203043O00BCC7D7A903073O00506F69736F6E73026O002240030B3O004372696D736F6E5669616C025O004CAA40025O004EAC40025O0010B240025O00049E40026O00144003093O00456E657267794D6178026O001840025O0050A040025O00789F4003123O00436F6D626F506F696E747344656669636974026O00104003143O00452O66656374697665436F6D626F506F696E747303163O00476574456E656D696573496E4D656C2O6552616E6765025O00C2A940025O0052B240025O00807840025O00B8A94003113O00476574456E656D696573496E52616E6765026O003E40025O00C05D40025O00B3B140025O0056A340025O002EAE40025O001AA140025O00F49A40030B3O00436F6D626F506F696E7473025O00D49A40025O009AAA40027O0040025O00805D40025O00609D40025O0040A940025O0008914003063O0042752O66557003113O004563686F696E6752657072696D616E6433026O00084003113O004563686F696E6752657072696D616E643403113O004563686F696E6752657072696D616E6435025O0032A940025O00D09C40030D3O00456E6572677954696D65546F58025O00804140030A3O0047434452656D61696E73026O00E03F025O0044A540025O00A5B240025O005C9B40025O00F0774003093O0054696D65546F536874025O00C09340025O0083B040025O00208E40030F3O0053687572696B656E546F726E61646F030A3O0043504D61785370656E64025O00F5B140025O004CA54003113O0054696D65546F4E657874546F726E61646F026O00D03F025O00D4B040025O000FB240025O0092A140025O00108140030C3O00536861646F77426C61646573025O0020A540025O0072AC40025O00B5B040025O00D09540025O0054B040025O00E07640025O00A06240025O0086B140025O00308440025O00349040026O33D33F026O001C4003093O0049734D6F756E746564025O001CAC40025O0034AD4003073O00537465616C746803083O00537465616C746832030F3O00CF1D5A7AE4E8011F33C7D32A1621A803053O00889C693F1B030C3O0049734368612O6E656C696E67030A3O00546F2O676C654D61696E025O00B88940025O00988C4003063O002D8D773D088403043O00547BEC1903113O0054696D6553696E63654C61737443617374025O0062B340025O000DB140025O00188440025O00449740030E3O0049735370652O6C496E52616E6765030C3O00536861646F77737472696B65025O00B07D40025O004FB04003093O00537465616C74685570030B3O00436173744162696C697479025O00C4A540025O00405E40025O00A09D40025O00FEA54003043O007479706503053O00E48AA81BA903063O00D590EBCA77CC03043O004361737403063O00756E7061636B03243O00100CDB2B243745261C9E0729205F2C58FD2B3B370D2C0A9E1A272C416350F1050B6A176303073O002D4378BE4A4843025O0014A040025O0058A240031E3O001336E8A4F59CE6EC2462CEA4EA9CAEE63262DDAAF684AEA10F0DCEECA3C803083O008940428DC599E88E025O0092AB40025O007C9B4003063O0043980D89AB4A03053O00E863B042C6025O00607640025O00649D4003043O00DF29211003083O004C8C4148661BED9903093O00497343617374696E6703113O00556E6974486173456E7261676542752O66025O004C9F40025O00A6A54003043O0053686976025O004EA440025O0080A24003063O004ED305C2D20D03073O00DE2ABA76B2B761030A3O00436F6D62617454696D65026O002440030B3O006EE4458E52FB608B53EF4103043O00EA3D8C24030A3O00432O6F6C646F776E557003063O0017DCB47B1C2903053O006F41BDDA12026O002640025O008AA540025O0054A04003093O006C5B1E3B0E4EEF707803073O00CF232B7B556B3C030E3O0043B3ADE8767CB9AFEC5D75ABB4E203053O001910CAC08A030A3O0049734361737461626C6503083O0042752O66446F776E030E3O0053796D626F6C736F66446561746803153O00D2DBA8ECACE6BDF8B4EFABFBF1D8A2E48DF1FCDFA503063O00949DABCD82C9025O00B08640025O003C9840030A3O0039CDAFEBB07012C0A4E103063O00127EA1C084DD030A3O00476C2O6F6D626C61646503113O007038AB0A534D688908595025AC08575B2D03053O00363F48CE64025O00A8A240025O00689E40030A3O00446562752O66446F776E03073O0052757074757265025O00A3B240025O0050A940030E3O00E7494074E069886B506AF16EDA5C03063O001BA839251A85025O00689D40025O00805840025O00CAB040025O00C9B040030C3O0010DC752DDEE101D8752DD4E503063O009643B41449B1025O0034A140025O0068B34003133O00A2081F43880A5A7E85191E429A3A164C891D0903043O002DED787A025O00407840025O00E06440030D3O00E4E0B73EDEE3A722E4FCAD3EDA03043O004CB788C2030D3O0053687572696B656E53746F726D03173O0055F6E036555D5449EEF02A59441174A6D1374241157EE903073O00741A868558302F025O00788440025O0002A940030B3O001EA27DACD83A8E7DA6D42803053O00B74DCA1CC8030B3O00536861646F7744616E636503123O0038238C061221C93B1F328D0700178806143603043O00687753E9025O0036AC40025O00F08D40025O0046AC40030C3O002AE44BB33F18E64694331AED03053O005A798822D003143O0046696C7465726564466967687452656D61696E7303013O003E030B3O0042752O6652656D61696E73030C3O00536C696365616E64446963652O033O00474344025O00D2AD40025O009C9E40030C3O00F4025C1DC20F5B1AE307561B03043O007EA76E3503223O001E113DEC9C0C31192DFD9C3E33146EDCD53C385066D4D3287D343BEADD2B341F20B103063O005F5D704E98BC03053O00506F776572026O00344003073O00F1FA8A19EDB0D503073O00B2A195E57584DE025O0010A740025O00AEAD40026O006640025O00E49940025O00409940025O00ECAF4003113O00B6F7EAD80FB28DE6EB9933A98AEFE6D70403063O00C6E5838FB963025O00B4A440025O00A09840025O00D07340025O00E0AC40025O0070AA4003053O009CDADFA0A403083O0043E8BBBDCCC176C6025O001EAD40025O00BCA040025O00409A40025O002EA44003243O00B83AB0213716E78E2AF50D3A01FD846E96212816AF843CF510340DE3CB669A0F184BB5CB03073O008FEB4ED5405B62025O00709F40025O00E0A040031E3O00BE5C81E87CA2854D80A953B79E5CC4E662F6BD478BE530FEA267A7A02AF603063O00D6ED28E48910025O004CA240025O00D6AC40030F3O00456E65726779507265646963746564025O002OB240025O00C06D40025O00F4AA40025O00D3B140030D3O006298AD725D98A03372A8BB291103043O001331ECC8025O00607040025O002OA840030D3O00546865526F2O74656E42752O6603183O00426F2O7346696C7465726564466967687452656D61696E7303013O003C03083O00CD32F7BBC2BBEA3203063O00DA9E5796D784030B3O004973417661696C61626C65025O00A0A240025O00E4AF40025O0022AE40025O00EEA040025O0056B140025O00289E4003083O00DD17D7EB252A97BB03073O00AD9B7EB9825642025O00608A40025O00C07140025O005C9140025O00709340025O0004AF40025O0032A240030D3O00D6B2BFC684F8EDE699E39BB6A503063O008C85C6DAA7E8025O00949240025O009AA74003073O00973BBD7180EF6E03053O00E4D54ED41D025O0048B040025O005EAC4003053O00D6DC34782O03053O002395984742025O00C8A640025O0076AF40025O00909840025O00D6AF40025O00489C40026O00B34003103O00CCA6957412B24735EE96936919B8562F03083O005C8DC5E71B70D333030E3O004973496E4D656C2O6552616E676503103O00C7FC98ACD3E7EB83A0E2F2ED83A8D4F503053O00B1869FEAC3026O002A40030A3O0098FD36B3CAB8F93EB4CC03053O00A9DD8B5FC003063O0044616D616765030B3O00F68E7E33362ECD9F70312703063O0046BEEB1F5F4203103O004865616C746850657263656E74616765025O00E49740025O00A8B140030B3O004865616C746873746F6E65030C3O0092E71BEAF1B2F10EE9EBBFA203053O0085DA827A8603173O000EFAE5D6D9B03035F1E4ECD9A23435F1E4F4D3B73133F103073O00585C9F83A4BCC3025O00F09E40025O00049640025O0022A04003173O0052656672657368696E674865616C696E67506F74696F6E03183O00B22BB959D2F8D58920B863D2EAD18920B87BD8FFD48F20FF03073O00BDE04EDF2BB78B025O00209A40025O00E8B140025O00B49340025O007C9040030C3O004570696353652O74696E677303073O002E28550B21E80803083O008E7A47326C4D8D7B2O033O0014ADFA03053O005B75C29F78025O00E07F4003073O00F37BFDFF46C26703053O002AA7149A982O033O0045F1A103063O00412A9EC22211025O0030B040025O0012A240025O0050A340025O006AA940025O00509840025O00F0A84003073O002E12391F39F43703073O00447A7D5E7855912O033O001418DC03073O00DA777CAF3EA8B903073O0091FF4FC3A9F55B03043O00A4C5902803063O0097FFAD8CD1B303063O00D6E390CAEBBD025O00A7B240025O00D096400087072O001270012O00013O0026F33O0005000100020004813O00050001002E3F01030083000100040004813O008300010012702O0100014O003D010200023O0026762O010007000100010004813O00070001001270010200013O000E740005000E000100020004813O000E0001002E3F01070068000100060004813O006800012O000E00035O0020690103000300082O00160103000200020006270003001500013O0004813O00150001002E3F010900660001000A0004813O00660001001270010300014O003D010400053O0026F30003001B000100010004813O001B0001002EAC000B001E0001000C0004813O001E0001001270010400014O003D010500053O001270010300053O0026F300030022000100050004813O00220001002E3F010D00170001000E0004813O0017000100267601040022000100010004813O00220001001270010500013O002EAC000F004D000100100004813O004D00010026760105004D000100050004813O004D00012O000E000600013O0020850006000600112O00B600060001000200064000060030000100010004813O00300001002EAC00130066000100120004813O006600012O000E000600023O0020690106000600142O00160106000200020006270006006600013O0004813O006600012O000E000600034O0050010700043O00122O000800153O00122O000900166O0007000900024O00060006000700202O0006000600174O00060002000200062O0006006600013O0004813O00660001002E3F01180066000100190004813O006600012O000E000600054O000E000700063O00208500070007001A2O00160106000200020006270006006600013O0004813O006600012O000E000600043O0012270107001B3O00122O0008001C6O000600086O00065O00044O0066000100267601050025000100010004813O00250001001270010600013O0026760106005C000100010004813O005C00012O000E000700083O00209A00070007001D4O0007000100024O000700076O000700073O00062O0007005B00013O0004813O005B00012O000E000700074O007A010700023O001270010600053O00267601060050000100050004813O00500001001270010500053O0004813O002500010004813O005000010004813O002500010004813O006600010004813O002200010004813O006600010004813O00170001001270012O001E3O0004813O008300010026760102000A000100010004813O000A0001001270010300013O00267601030079000100010004813O007900012O000E000400083O00208500040004001F2O00B60004000100022O00BB000400073O002E3F01200078000100210004813O007800012O000E000400073O0006270004007800013O0004813O007800012O000E000400074O007A010400023O001270010300053O0026F30003007D000100050004813O007D0001002E10012200F0FF2O00230004813O006B0001001270010200053O0004813O000A00010004813O006B00010004813O000A00010004813O008300010004813O00070001002676012O00A6000100240004813O00A600010012702O0100013O0026762O010091000100050004813O009100012O000E00025O0020830002000200254O0002000200024O0003000A6O0003000100024O0002000200034O000200093O00124O00263O00044O00A600010026F300010095000100010004813O00950001002EAC00270086000100280004813O00860001001270010200013O002676010200A0000100010004813O00A000012O000E00035O0020380103000300294O0003000200024O0003000B6O0003000D6O0003000100024O0003000C3O00122O000200053O00267601020096000100050004813O009600010012702O0100053O0004813O008600010004813O009600010004813O00860001002676012O000A2O01002A0004813O000A2O010012702O0100013O000E70000500B2000100010004813O00B200012O000E000200083O00208B00020002002B4O0003000F6O0002000200024O0002000E3O00124O00243O00044O000A2O010026762O0100A9000100010004813O00A900012O000E000200103O000627000200DE00013O0004813O00DE0001001270010200013O002676010200C3000100050004813O00C300012O000E000300124O0014010300036O000300116O00035O00202O00030003002C4O000500146O0003000500024O000300133O00044O00042O01000E74000100C7000100020004813O00C70001002EAC002E00B80001002D0004813O00B80001001270010300013O002E3F012F00D7000100300004813O00D70001002676010300D7000100010004813O00D700012O000E00045O00202D00040004003100122O000600326O0004000600024O000400156O00045O00202O00040004002C4O000600166O0004000600024O000400123O00122O000300053O002676010300C8000100050004813O00C80001001270010200053O0004813O00B800010004813O00C800010004813O00B800010004813O00042O01001270010200013O000E70000100FC000100020004813O00FC0001001270010300013O0026F3000300E6000100010004813O00E60001002E3F013400F5000100330004813O00F50001001270010400013O002676010400EE000100010004813O00EE00012O00CD00056O00BB000500154O00CD00056O00BB000500123O001270010400053O0026F3000400F2000100050004813O00F20001002EAC003600E7000100350004813O00E70001001270010300053O0004813O00F500010004813O00E70001002E3F013800E2000100370004813O00E20001002676010300E2000100050004813O00E20001001270010200053O0004813O00FC00010004813O00E20001002676010200DF000100050004813O00DF0001001270010300054O00BB000300114O00CD00036O00BB000300133O0004813O00042O010004813O00DF00012O000E00025O0020330002000200394O0002000200024O0002000F3O00122O000100053O00044O00A90001002676012O0046020100260004813O004602010012702O0100013O002EAC003A00320201003B0004813O003202010026762O010032020100010004813O00320201001270010200013O002676010200162O0100050004813O00162O010012702O0100053O0004813O00320201002676010200122O0100010004813O00122O012O000E0003000E4O000E0004000F3O00065E010400242O0100030004813O00242O012O000E0003000B3O000E35003C00242O0100030004813O00242O012O000E00035O0020690103000300082O0016010300020002000640000300262O0100010004813O00262O01002E10013D00830001003E0004813O00A72O01002EAC004000A72O01003F0004813O00A72O012O000E0003000F3O002676010300322O01003C0004813O00322O012O000E00035O0020650103000300414O000500033O00202O0005000500424O00030005000200062O000300462O013O0004813O00462O012O000E0003000F3O0026760103003C2O0100430004813O003C2O012O000E00035O0020650103000300414O000500033O00202O0005000500444O00030005000200062O000300462O013O0004813O00462O012O000E0003000F3O002676010300A72O01002A0004813O00A72O012O000E00035O0020720103000300414O000500033O00202O0005000500454O00030005000200062O000300A72O0100010004813O00A72O01001270010300014O003D010400063O0026760103009F2O0100050004813O009F2O012O003D010600063O000E70000500962O0100040004813O00962O01002EAC004700702O0100460004813O00702O01002676010500702O0100050004813O00702O012O000E000700174O0041000800186O00095O00202O00090009004800122O000B00496O0009000B00024O000A5O00202O000A000A004A4O000A000B6O00083O000200122O0009004B4O00710007000900022O0052000800196O000900186O000A5O00202O000A000A004800122O000C00496O000A000C00024O000B5O00202O000B000B004A4O000B000C6O00093O0002001270010A004B4O00710008000A00022O004B0107000700080006120007006D2O0100060004813O006D2O010004813O00A72O012O000E0007000F4O00BB0007000E3O0004813O00A72O010026F3000500742O0100010004813O00742O01002E3F014D004D2O01004C0004813O004D2O01001270010700013O0026760107008F2O0100010004813O008F2O01001270010800013O000E700005007C2O0100080004813O007C2O01001270010700053O0004813O008F2O01002EAC004F00782O01004E0004813O00782O01002676010800782O0100010004813O00782O012O000E000900083O00207E01090009005000122O000A002A6O0009000200024O000600093O00262O000600882O0100010004813O00882O010004813O008D2O012O000E000900083O002085000900090050001270010A00244O00160109000200022O00F6000600093O001270010800053O0004813O00782O01002676010700752O0100050004813O00752O01001270010500053O0004813O004D2O010004813O00752O010004813O004D2O010004813O00A72O01002EAC0051004B2O0100520004813O004B2O010026760104004B2O0100010004813O004B2O01001270010500014O003D010600063O001270010400053O0004813O004B2O010004813O00A72O01002E10015300A9FF2O00530004813O00482O01002676010300482O0100010004813O00482O01001270010400014O003D010500053O001270010300053O0004813O00482O012O000E00035O0020150103000300414O000500033O00202O0005000500544O000600066O000700016O00030007000200062O000300B62O013O0004813O00B62O012O000E0003000F4O000E000400083O0020850004000400552O00B6000400010002000684010300B82O0100040004813O00B82O01002E100156007A000100570004813O00300201001270010300014O003D010400053O00267601030020020100050004813O00200201002676010400BC2O0100010004813O00BC2O012O000E000600083O0020C80006000600584O0006000100024O000500066O00065O00202O00060006004A4O00060002000200062O0005000B000100060004813O00D12O012O000E0006001A4O009D00075O00202O00070007004A4O0007000200024O0007000700054O00060002000200262O000600D12O0100590004813O00D12O01002E10015A00610001005B0004813O00300201001270010600014O003D010700073O002EAC005D00060201005C0004813O0006020100267601060006020100010004813O00060201001270010800013O002676010800FF2O0100010004813O00FF2O012O000E000900174O0005000A00116O000B001B6O000C5O00202O000C000C00414O000E00033O00202O000E000E005E4O000C000E6O000B8O00093O00024O000A00194O000E000B00114O00E9000C001B6O000D5O00202O000D000D00414O000F00033O00202O000F000F005E4O000D000F6O000C8O000A3O00024O00070009000A4O0009001C4O000E000A00174O0061010B000F6O000C00076O000A000C00024O000B00196O000C000F6O000D00076O000B000D00024O000A000A000B4O000B00083O00202O000B000B00552O001E000B00014O00D800093O00022O00BB0009000F3O001270010800053O002E3F015F00D82O0100600004813O00D82O01002676010800D82O0100050004813O00D82O01001270010600053O0004813O000602010004813O00D82O010026F30006000A020100050004813O000A0201002E3F016100D32O0100620004813O00D32O012O000E000800184O007D0009000B6O00090009000700122O000A00016O0008000A00024O0008000B6O0008000E6O000900083O00202O0009000900554O00090001000200062O0009001B000100080004813O00300201002E3F01630019020100640004813O001902010004813O003002012O000E0008000F4O00BB0008000E3O0004813O003002010004813O00D32O010004813O003002010004813O00BC2O010004813O00300201000E70000100BA2O0100030004813O00BA2O01001270010600013O000E7400010027020100060004813O00270201002E3F0166002A020100650004813O002A0201001270010400014O003D010500053O001270010600053O00267601060023020100050004813O00230201001270010300053O0004813O00BA2O010004813O002302010004813O00BA2O01001270010200053O0004813O00122O01002EAC0067000D2O0100680004813O000D2O010026762O01000D2O0100050004813O000D2O012O000E000200173O00127A0003002A6O0004000E3O00202O00040004002A4O0002000400024O000300193O00122O0004002A6O0005000E3O00202O00050005002A4O0003000500024O00020002000300207E0002000200692O00BB0002001D3O001270012O006A3O0004813O004602010004813O000D2O01002676012O003A0601001E0004813O003A06012O000E00015O0020692O01000100082O00162O010002000200064000010075020100010004813O007502012O000E00015O0020692O010001006B2O00162O010002000200064000010075020100010004813O007502012O000E000100013O0020850001000100112O00B60001000100020006270001007502013O0004813O007502010012702O0100014O003D010200023O0026762O010059020100010004813O00590201001270010200013O002E3F016C005C0201006D0004813O005C02010026760102005C020100010004813O005C02012O000E000300083O00205E00030003006E4O000400033O00202O00040004006F4O000500056O0003000500024O000300076O000300073O00062O0003007502013O0004813O007502012O000E000300043O001264000400703O00122O000500716O0003000500024O000400076O0003000300044O000300023O00044O007502010004813O005C02010004813O007502010004813O005902012O000E00015O0020692O01000100722O00162O01000200020006400001007D020100010004813O007D0201001213000100733O0006400001007F020100010004813O007F0201002E3F01750086070100740004813O008607010012702O0100014O003D010200023O0026762O010081020100010004813O00810201001270010200013O00267601020084020100010004813O008402012O000E00035O0020690103000300082O00160103000200020006400003000D030100010004813O000D03012O000E0003001E3O0020690103000300082O00160103000200020006270003000D03013O0004813O000D03012O000E000300034O00E8000400043O00122O000500763O00122O000600776O0004000600024O00030003000400202O0003000300784O000300020002000E2O0005000D030100030004813O000D0301001270010300014O003D010400043O0026F3000300A0020100010004813O00A00201002E3F0179009C0201007A0004813O009C0201001270010400013O0026F3000400A5020100010004813O00A50201002E3F017C00A10201007B0004813O00A102012O000E000500013O0020850005000500112O00B6000500010002000627000500B402013O0004813O00B402012O000E0005001E3O00207201050005007D4O000700033O00202O00070007007E4O00050007000200062O000500B6020100010004813O00B602012O000E0005001F3O000640000500B6020100010004813O00B60201002E10017F0055000100800004813O000903012O000E00055O00205F0105000500814O000700016O000800016O00050008000200062O000500F602013O0004813O00F60201001270010500013O002676010500BE020100010004813O00BE02012O000E000600204O0038000700016O00060002000200122O000600823O00122O000600823O00062O000600C9020100010004813O00C90201002EAC00830009030100840004813O00090301002E3F018500E6020100860004813O00E60201001213000600873O0012D6000700826O0006000200024O000700043O00122O000800883O00122O000900896O00070009000200062O000600E6020100070004813O00E60201001213000600824O0032010600063O000E35000500E6020100060004813O00E602012O000E000600213O00206F00060006008A00122O0007008B3O00122O000800826O000700086O00063O000200062O0006000903013O0004813O000903012O000E000600043O0012270107008C3O00122O0008008D6O000600086O00065O00044O000903012O000E000600213O00208500060006008A001213000700824O0016010600020002000640000600EE020100010004813O00EE0201002E10018E001D0001008F0004813O000903012O000E000600043O001227010700903O00122O000800916O000600086O00065O00044O000903010004813O00BE02010004813O000903012O000E0005000F3O002667000500FA020100240004813O00FA02010004813O000903012O000E000500224O00B60005000100022O00BB000500074O000E000500073O00064000050002030100010004813O00020301002E3F01920009030100930004813O000903012O000E000500074O0045000600043O00122O000700943O00122O000800956O0006000800024O0005000500064O000500024O003E012O00013O0004813O00A102010004813O000D03010004813O009C02012O000E000300013O0020850003000300112O00B60003000100020006270003001A03013O0004813O001A03012O000E000300233O0006400003001C030100010004813O001C03012O000E00035O0020690103000300082O00160103000200020006400003001C030100010004813O001C0301002E100196006C040100970004813O00860701001270010300013O00267601030067040100010004813O006704012O000E000400243O0006270004003C03013O0004813O003C03012O000E000400034O0050010500043O00122O000600983O00122O000700996O0005000700024O00040004000500202O0004000400174O00040002000200062O0004003C03013O0004813O003C03012O000E00045O00206901040004009A2O00160104000200020006400004003C030100010004813O003C03012O000E00045O0020690104000400722O00160104000200020006400004003C030100010004813O003C03012O000E000400013O00208500040004009B2O000E0005001E4O00160104000200020006400004003E030100010004813O003E0301002E10019C00110001009D0004813O004D03012O000E000400054O0091000500033O00202O00050005009E4O0006001F6O000600066O00040006000200062O00040048030100010004813O00480301002EAC009F004D030100A00004813O004D03012O000E000400043O001270010500A13O001270010600A24O006B000400064O001201046O000E000400213O0020850004000400A32O00B600040001000200266700040066040100A40004813O006604012O000E000400213O0020850004000400A32O00B6000400010002000E3500010066040100040004813O006604012O000E000400034O0050010500043O00122O000600A53O00122O000700A66O0005000700024O00040004000500202O0004000400A74O00040002000200062O0004006604013O0004813O006604012O000E000400034O00E8000500043O00122O000600A83O00122O000700A96O0005000700024O00040004000500202O0004000400784O000400020002000E2O00AA0066040100040004813O00660401001270010400014O003D010500063O000E7000010072030100040004813O00720301001270010500014O003D010600063O001270010400053O0026760104006D030100050004813O006D030100267601050074030100010004813O00740301001270010600013O002676010600B5030100010004813O00B50301001270010700013O002E3F01AC0080030100AB0004813O0080030100267601070080030100050004813O00800301001270010600053O0004813O00B503010026760107007A030100010004813O007A03012O000E00085O00205F0108000800814O000A00016O000B00016O0008000B000200062O0008009503013O0004813O009503012O000E000800213O0020F100080008008A4O000900033O00202O00090009007E4O00080002000200062O0008009503013O0004813O009503012O000E000800043O001270010900AD3O001270010A00AE4O006B0008000A4O001201086O000E000800034O0050010900043O00122O000A00AF3O00122O000B00B06O0009000B00024O00080008000900202O0008000800B14O00080002000200062O000800B303013O0004813O00B303012O000E00085O0020650108000800B24O000A00033O00202O000A000A00B34O0008000A000200062O000800B303013O0004813O00B303012O000E000800213O00203101080008008A4O000900033O00202O0009000900B34O000A00016O0008000A000200062O000800B303013O0004813O00B303012O000E000800043O001270010900B43O001270010A00B54O006B0008000A4O001201085O001270010700053O0004813O007A0301002EAC00B600F8030100B70004813O00F80301002676010600F80301003C0004813O00F80301001270010700013O002676010700BE030100050004813O00BE0301001270010600433O0004813O00F80301002676010700BA030100010004813O00BA03012O000E000800034O00E8000900043O00122O000A00B83O00122O000B00B96O0009000B00024O00080008000900202O0008000800784O000800020002000E2O004300D9030100080004813O00D903012O000E000800113O00264A000800D9030100050004813O00D903012O000E000800213O0020F100080008008A4O000900033O00202O0009000900BA4O00080002000200062O000800D903013O0004813O00D903012O000E000800043O001270010900BB3O001270010A00BC4O006B0008000A4O001201085O002E3F01BE00F6030100BD0004813O00F603012O000E0008001E3O0020650108000800BF4O000A00033O00202O000A000A00C04O0008000A000200062O000800F603013O0004813O00F603012O000E000800113O00264A000800F6030100050004813O00F603012O000E0008000F3O000E35000100F6030100080004813O00F603012O000E000800213O00200201080008008A4O000900033O00202O0009000900C04O00080002000200062O000800F1030100010004813O00F10301002E1001C10007000100C20004813O00F603012O000E000800043O001270010900C33O001270010A00C44O006B0008000A4O001201085O001270010700053O0004813O00BA030100267601060042040100050004813O00420401001270010700013O000E74000500FF030100070004813O00FF0301002E3F01C50001040100C60004813O000104010012700106003C3O0004813O00420401002676010700FB030100010004813O00FB0301002EAC00C80025040100C70004813O002504012O000E000800034O0050010900043O00122O000A00C93O00122O000B00CA6O0009000B00024O00080008000900202O0008000800B14O00080002000200062O0008002504013O0004813O002504012O000E00085O0020650108000800B24O000A00033O00202O000A000A005E4O0008000A000200062O0008002504013O0004813O00250401002EAC00CB0025040100CC0004813O002504012O000E000800213O00203101080008008A4O000900033O00202O00090009005E4O000A00016O0008000A000200062O0008002504013O0004813O002504012O000E000800043O001270010900CD3O001270010A00CE4O006B0008000A4O001201085O002E3F01D00040040100CF0004813O004004012O000E000800034O0050010900043O00122O000A00D13O00122O000B00D26O0009000B00024O00080008000900202O0008000800B14O00080002000200062O0008004004013O0004813O004004012O000E000800113O000EB3003C0040040100080004813O004004012O000E000800213O0020F100080008008A4O000900033O00202O0009000900D34O00080002000200062O0008004004013O0004813O004004012O000E000800043O001270010900D43O001270010A00D54O006B0008000A4O001201085O001270010700053O0004813O00FB03010026F300060046040100430004813O00460401002E1001D60033FF2O00D70004813O007703012O000E000700034O0050010800043O00122O000900D83O00122O000A00D96O0008000A00024O00070007000800202O0007000700B14O00070002000200062O0007006604013O0004813O006604012O000E000700253O0006270007006604013O0004813O006604012O000E000700213O00203101070007008A4O000800063O00202O0008000800DA4O000900016O00070009000200062O0007006604013O0004813O006604012O000E000700043O001227010800DB3O00122O000900DC6O000700096O00075O00044O006604010004813O007703010004813O006604010004813O007403010004813O006604010004813O006D0301001270010300053O002676010300320501003C0004813O00320501001270010400013O002E3F01DE0028050100DD0004813O00280501000E7000010028050100040004813O00280501002E1001DF004F000100DF0004813O00BD04012O000E000500034O0050010600043O00122O000700E03O00122O000800E16O0006000800024O00050005000600202O0005000500B14O00050002000200062O000500BD04013O0004813O00BD04012O000E000500114O000E000600083O0020850006000600552O00B600060001000200065E010500BD040100060004813O00BD04012O000E000500213O0020EA0005000500E24O000600123O00122O000700E33O00122O000800266O00050008000200062O000500BD04013O0004813O00BD04012O000E00055O0020500005000500E44O000700033O00202O0007000700E54O0005000700024O00065O00202O0006000600E64O00060002000200062O000500BD040100060004813O00BD04012O000E0005000F3O000EB3002A00BD040100050004813O00BD0401002E3F01E800BD040100E70004813O00BD04012O000E000500034O0050010600043O00122O000700E93O00122O000800EA6O0006000800024O00050005000600202O0005000500174O00050002000200062O000500BD04013O0004813O00BD0401001270010500013O002676010500A2040100010004813O00A204012O000E000600213O0020F100060006008A4O000700033O00202O0007000700E54O00060002000200062O000600B004013O0004813O00B004012O000E000600043O001270010700EB3O001270010800EC4O006B000600084O001201066O000E00065O0020690106000600ED2O0016010600020002000EB300EE00B6040100060004813O00B604010004813O00BD04012O000E000600043O001227010700EF3O00122O000800F06O000600086O00065O00044O00BD04010004813O00A204012O000E00055O0020460005000500814O000700016O000800016O00050008000200062O000500C6040100010004813O00C60401002EAC00F20027050100F10004813O00270501001270010500014O003D010600063O002676010500C8040100010004813O00C80401001270010600013O001270010700013O002E3F01F300CC040100F40004813O00CC0401002676010700CC040100010004813O00CC04010026F3000600D4040100050004813O00D40401002E3F01F600D9040100F50004813O00D904012O000E000800043O001270010900F73O001270010A00F84O006B0008000A4O001201085O002E3F01FA00CB040100F90004813O00CB0401002676010600CB040100010004813O00CB0401001270010800013O002EAC00FB00E4040100FC0004813O00E40401000E70000500E4040100080004813O00E40401001270010600053O0004813O00CB0401002E1001FD00FAFF2O00FD0004813O00DE0401002676010800DE040100010004813O00DE04012O000E000900204O000A000A00016O00090002000200122O000900823O00122O000900823O00062O0009002005013O0004813O00200501001213000900873O0012D6000A00826O0009000200024O000A00043O00122O000B00FE3O00122O000C00FF6O000A000C000200062O000900FC0401000A0004813O00FC0401001213000900824O0032010900093O000E72000500FF040100090004813O00FF04010012700109002O012O000E352O000111050100090004813O0011050100127001090002012O001270010A0003012O00065E010900200501000A0004813O002005012O000E000900213O00206F00090009008A00122O000A008B3O00122O000B00826O000A000B6O00093O000200062O0009002005013O0004813O002005012O000E000900043O001227010A0004012O00122O000B0005015O0009000B6O00095O00044O0020050100127001090006012O001270010A0007012O00065E010900200501000A0004813O002005012O000E000900213O00208500090009008A001213000A00824O00160109000200020006270009002005013O0004813O002005012O000E000900043O001270010A0008012O001270010B0009013O006B0009000B4O001201095O001270010800053O0004813O00DE04010004813O00CB04010004813O00CC04010004813O00CB04010004813O002705010004813O00C80401001270010400053O001270010500053O0006020004002F050100050004813O002F05010012700105000A012O0012700106000B012O0006BC0005006A040100060004813O006A0401001270010300433O0004813O003205010004813O006A0401001270010400433O0006BC0003001F060100040004813O001F06012O000E00045O0012FF0006000C015O0004000400064O0004000200024O000500093O00062O0004003D050100050004813O003D05010004813O00600501001270010400014O003D010500053O001270010600013O00060200040046050100060004813O004605010012700106000D012O0012700107000E012O0006120006003F050100070004813O003F0501001270010500013O001270010600013O0006BC00050047050100060004813O004705012O000E000600264O0059000700096O0006000200024O000600073O00122O0006000F012O00122O00070010012O00062O00060060050100070004813O006005012O000E000600073O0006270006006005013O0004813O006005012O000E000600043O00126400070011012O00122O00080012015O0006000800024O000700076O0006000600074O000600023O00044O006005010004813O004705010004813O006005010004813O003F050100127001040013012O00127001050014012O000612000400D6050100050004813O00D605012O000E0004000E4O000E000500083O0020850005000500552O00B600050001000200065C0105003B000100040004813O00A405012O000E0004000B4O00A0000500173O00122O000600056O0007001B6O00085O00202O0008000800414O000A00033O00122O000B0015015O000A000A000B4O0008000A6O00078O00053O00024O000600193O00122O000700056O0008001B6O00095O00202O0009000900414O000B00033O00122O000C0015015O000B000B000C4O0009000B6O00088O00063O00024O00050005000600062O00040021000100050004813O00A405012O000E000400213O00125601050016015O00040004000500122O00050017012O00122O0006003C6O00040006000200062O0004009005013O0004813O009005012O000E0004000E3O001270010500433O00065C01050015000100040004813O00A405012O000E000400114O00300005001B6O000600036O000700043O00122O00080018012O00122O00090019015O0007000900024O00060006000700122O0008001A015O0006000600084O000600076O00053O000200122O0006002A6O00050006000500062O000500D6050100040004813O00D605012O000E0004000E3O0012700105002A3O000612000500D6050100040004813O00D60501001270010400014O003D010500063O0012700107001B012O0012700108001C012O00065E010700B0050100080004813O00B00501001270010700013O0006BC000400B0050100070004813O00B00501001270010500014O003D010600063O001270010400053O001270010700053O000602000400B7050100070004813O00B705010012700107001D012O0012700108001E012O00065E010700A6050100080004813O00A60501001270010700013O0006BC000500B7050100070004813O00B70501001270010600013O001270010700013O0006BC000600BB050100070004813O00BB05012O000E000700224O00B60007000100022O00BB000700074O000E000700073O000640000700C8050100010004813O00C805010012700107001F012O00127001080020012O0006BC00070086070100080004813O008607012O000E000700043O00126400080021012O00122O00090022015O0007000900024O000800076O0007000700084O000700023O00044O008607010004813O00BB05010004813O008607010004813O00B705010004813O008607010004813O00A605010004813O00860701001270010400014O003D010500063O001270010700013O000602000400DF050100070004813O00DF050100127001070023012O00127001080024012O00065E010700E2050100080004813O00E20501001270010500014O003D010600063O001270010400053O00127001070025012O00127001080026012O000612000700D8050100080004813O00D80501001270010700053O0006BC000400D8050100070004813O00D80501001270010700013O000602000500F0050100070004813O00F0050100127001070027012O00127001080028012O000612000700E9050100080004813O00E90501001270010600013O001270010700013O0006BC00060003060100070004813O000306012O000E000700264O0034010800096O0007000200024O000700076O000700073O00062O0007000206013O0004813O000206012O000E000700043O00129300080029012O00122O0009002A015O0007000900024O000800076O0007000700084O000700023O001270010600053O0012700107002B012O0012700108002C012O00065E010700F1050100080004813O00F10501001270010700053O0006BC000600F1050100070004813O00F105012O000E000700274O0034010800096O0007000200024O000700076O000700073O00062O0007008607013O0004813O008607012O000E000700043O0012640008002D012O00122O0009002E015O0007000900024O000800076O0007000700084O000700023O00044O008607010004813O00F105010004813O008607010004813O00E905010004813O008607010004813O00D805010004813O008607010012700104002F012O00127001050030012O00065E0105001D030100040004813O001D0301001270010400053O0006BC0003001D030100040004813O001D03012O000E000400284O00B60004000100022O00BB000400074O000E000400073O0006270004003306013O0004813O003306012O000E000400043O00129300050031012O00122O00060032015O0004000600024O000500076O0004000400054O000400023O0012700103003C3O0004813O001D03010004813O008607010004813O008402010004813O008607010004813O008102010004813O008607010012702O010033012O00127001020034012O00061200010072060100020004813O007206010012702O01003C3O0006BC3O0072060100010004813O007206010012702O0100013O00127001020035012O00127001030036012O0006120002005C060100030004813O005C0601001270010200013O0006BC0001005C060100020004813O005C0601001270010200013O001270010300013O00060200020051060100030004813O0051060100127001030037012O00127001040038012O00065E01040056060100030004813O005606012O003D010300034O00BB000300293O001270010300014O00BB0003002A3O001270010200053O001270010300053O0006BC0002004A060100030004813O004A06010012702O0100053O0004813O005C06010004813O004A0601001270010200053O0006BC00010042060100020004813O004206012O000E000200034O002E010300043O00122O00040039012O00122O0005003A015O0003000500024O00020002000300122O0004001A015O0002000200044O00020002000200062O0002006D06013O0004813O006D0601001270010200023O0006400002006E060100010004813O006E0601001270010200244O00BB000200143O001270012O00433O0004813O007206010004813O004206010012702O0100433O0006BC3O009C060100010004813O009C06010012702O0100013O001270010200053O0006BC00010081060100020004813O008106012O000E0002001E3O0012EC0004003B015O0002000200044O000400166O0002000400024O0002002B3O00124O002A3O00044O009C0601001270010200013O0006BC00020076060100010004813O007606012O000E000200034O002E010300043O00122O0004003C012O00122O0005003D015O0003000500024O00020002000300122O0004001A015O0002000200044O00020002000200062O0002009206013O0004813O009206010012700102003E012O00064000020093060100010004813O00930601001270010200A44O00BB000200164O004D0002001E3O00122O0004003B015O0002000200044O000400146O0002000400024O0002001F3O00122O000100053O00044O007606010012702O01006A3O0006BC3O0008070100010004813O000807012O000E000100034O00FE000200043O00122O0003003F012O00122O00040040015O0002000400024O00010001000200122O00030041015O0001000100034O0001000200024O0002002D6O0001000100024O0001002C6O0001002E6O000200043O00122O00030042012O00122O00040043015O0002000400024O00010001000200202O0001000100174O00010002000200062O000100D706013O0004813O00D706012O000E00015O0012FF00030044015O0001000100034O0001000200024O0002002F3O00062O000100D7060100020004813O00D706012O000E00015O0020692O01000100722O00162O0100020002000640000100D7060100010004813O00D706012O000E00015O0020692O010001009A2O00162O0100020002000640000100D7060100010004813O00D706010012702O010045012O00127001020046012O00065E2O0100D7060100020004813O00D706012O000E000100213O0020732O010001008A4O000200063O00122O00030047015O0002000200034O00010002000200062O000100D706013O0004813O00D706012O000E000100043O00127001020048012O00127001030049013O006B000100034O00122O016O000E0001002E4O0050010200043O00122O0003004A012O00122O0004004B015O0002000400024O00010001000200202O0001000100174O00010002000200062O000100F206013O0004813O00F206012O000E00015O0012FF00030044015O0001000100034O0001000200024O000200303O00062O000100F2060100020004813O00F206012O000E00015O0020692O01000100722O00162O0100020002000640000100F2060100010004813O00F206012O000E00015O0020692O010001009A2O00162O0100020002000627000100F606013O0004813O00F606010012702O01004C012O0012700102004D012O0006BC0001002O070100020004813O002O07010012702O01004E012O0012700102004E012O0006BC0001002O070100020004813O002O07012O000E000100213O0020732O010001008A4O000200063O00122O0003004F015O0002000200034O00010002000200062O0001002O07013O0004813O002O07012O000E000100043O00127001020050012O00127001030051013O006B000100034O00122O015O001270012O00023O0012702O0100013O0006020001000F07013O0004813O000F07010012702O010052012O00127001020053012O0006120002003C070100010004813O003C07010012702O0100013O001270010200053O00060200010017070100020004813O0017070100127001020054012O00127001030055012O00065E01020025070100030004813O0025070100121300020056013O00F2000300043O00122O00040057012O00122O00050058015O0003000500024O0002000200034O000300043O00122O00040059012O00122O0005005A015O0003000500024O0002000200034O000200103O00124O00053O00044O003C0701001270010200013O0006020002002C070100010004813O002C0701001270010200D63O0012700103005B012O00061200020010070100030004813O001007012O000E000200314O005801020001000100121300020056013O00F2000300043O00122O0004005C012O00122O0005005D015O0003000500024O0002000200034O000300043O00122O0004005E012O00122O0005005F015O0003000500024O0002000200034O000200233O00122O000100053O00044O001007010012702O010060012O00127001020061012O00061200020001000100010004813O000100010012702O0100053O0006BC3O0001000100010004813O000100010012702O0100014O003D010200023O001270010300013O0006BC00010045070100030004813O00450701001270010200013O00127001030062012O00127001040063012O00061200030077070100040004813O00770701001270010300013O0006BC00020077070100030004813O00770701001270010300013O001270010400053O0006BC00040056070100030004813O00560701001270010200053O0004813O0077070100127001040064012O00127001050065012O00065E01040051070100050004813O00510701001270010400013O0006BC00030051070100040004813O0051070100121300040056013O005A000500043O00122O00060066012O00122O00070067015O0005000700024O0004000400054O000500043O00122O00060068012O00122O00070069015O0005000700024O0004000400052O005F000400253O00122O00040056015O000500043O00122O0006006A012O00122O0007006B015O0005000700024O0004000400054O000500043O00122O0006006C012O00122O0007006D013O00710005000700022O0063000400040005001286000400733O001270010300053O0004813O00510701001270010300053O0006020002007E070100030004813O007E07010012700103006E012O0012700104006F012O00065E01030049070100040004813O004907012O003D010300034O00BB000300323O001270012O003C3O0004813O000100010004813O004907010004813O000100010004813O004507010004813O000100012O003E012O00017O00033O0003053O005072696E74032B3O00B459B411E78258AF45D9884BA300AB8555F620FB8E4FF845D8925CA60AF99349B245E99E0C910AE18E5EB703053O008BE72CD66500084O00CA7O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

