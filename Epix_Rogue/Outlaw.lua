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
				if (Enum <= 175) then
					if (Enum <= 87) then
						if (Enum <= 43) then
							if (Enum <= 21) then
								if (Enum <= 10) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
												for Idx = Inst[2], Inst[3] do
													Stk[Idx] = nil;
												end
											end
										elseif (Enum <= 2) then
											local Edx;
											local Results, Limit;
											local B;
											local A;
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
										elseif (Enum > 3) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
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
									elseif (Enum <= 7) then
										if (Enum <= 5) then
											Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
										elseif (Enum > 6) then
											Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
										else
											local Edx;
											local Results, Limit;
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A]();
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
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 8) then
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
									elseif (Enum == 9) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if (Inst[2] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 15) then
									if (Enum <= 12) then
										if (Enum == 11) then
											local A = Inst[2];
											local T = Stk[A];
											for Idx = A + 1, Top do
												Insert(T, Stk[Idx]);
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
									elseif (Enum <= 13) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									elseif (Enum == 14) then
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
								elseif (Enum <= 18) then
									if (Enum <= 16) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A;
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									end
								elseif (Enum <= 19) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 20) then
									Stk[Inst[2]] = Inst[3];
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
								end
							elseif (Enum <= 32) then
								if (Enum <= 26) then
									if (Enum <= 23) then
										if (Enum == 22) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
									elseif (Enum <= 24) then
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
									elseif (Enum == 25) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 29) then
									if (Enum <= 27) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum == 28) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 30) then
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
								elseif (Enum > 31) then
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
								if (Enum <= 34) then
									if (Enum > 33) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum <= 35) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 36) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 40) then
								if (Enum <= 38) then
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
								elseif (Enum == 39) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 41) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 42) then
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
							end
						elseif (Enum <= 65) then
							if (Enum <= 54) then
								if (Enum <= 48) then
									if (Enum <= 45) then
										if (Enum > 44) then
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										else
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
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 51) then
									if (Enum <= 49) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 50) then
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 52) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 53) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 59) then
								if (Enum <= 56) then
									if (Enum > 55) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 57) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 58) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 62) then
								if (Enum <= 60) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
								elseif (Enum == 61) then
									local B;
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
							elseif (Enum <= 63) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 64) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 76) then
							if (Enum <= 70) then
								if (Enum <= 67) then
									if (Enum == 66) then
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
									else
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
									end
								elseif (Enum <= 68) then
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
								elseif (Enum > 69) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
							elseif (Enum <= 73) then
								if (Enum <= 71) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
									end
								elseif (Enum == 72) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 74) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 75) then
								Stk[Inst[2]]();
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
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 81) then
							if (Enum <= 78) then
								if (Enum > 77) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 79) then
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
							elseif (Enum > 80) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
						elseif (Enum <= 84) then
							if (Enum <= 82) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 83) then
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
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 86) then
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
							VIP = Inst[3];
						end
					elseif (Enum <= 131) then
						if (Enum <= 109) then
							if (Enum <= 98) then
								if (Enum <= 92) then
									if (Enum <= 89) then
										if (Enum > 88) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 90) then
										if (Inst[2] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 91) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 95) then
									if (Enum <= 93) then
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 94) then
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
								elseif (Enum <= 96) then
									local Edx;
									local Results, Limit;
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A]();
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
								elseif (Enum == 97) then
									if (Stk[Inst[2]] < Inst[4]) then
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
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 103) then
								if (Enum <= 100) then
									if (Enum > 99) then
										if (Inst[2] <= Inst[4]) then
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
								elseif (Enum <= 101) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 102) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 106) then
								if (Enum <= 104) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum > 105) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								else
									Stk[Inst[2]] = {};
								end
							elseif (Enum <= 107) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum > 108) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 120) then
							if (Enum <= 114) then
								if (Enum <= 111) then
									if (Enum == 110) then
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
								elseif (Enum <= 112) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 113) then
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
								end
							elseif (Enum <= 117) then
								if (Enum <= 115) then
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 116) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 118) then
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							elseif (Enum > 119) then
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
						elseif (Enum <= 125) then
							if (Enum <= 122) then
								if (Enum == 121) then
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
								end
							elseif (Enum <= 123) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
								end
							elseif (Enum > 124) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 128) then
							if (Enum <= 126) then
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
						elseif (Enum <= 129) then
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
						elseif (Enum > 130) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 153) then
						if (Enum <= 142) then
							if (Enum <= 136) then
								if (Enum <= 133) then
									if (Enum == 132) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 134) then
									if (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 135) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 139) then
								if (Enum <= 137) then
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
								elseif (Enum > 138) then
									local B;
									local T;
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
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 140) then
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
							elseif (Enum == 141) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 147) then
							if (Enum <= 144) then
								if (Enum == 143) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
							elseif (Enum <= 145) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							elseif (Enum > 146) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 150) then
							if (Enum <= 148) then
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 149) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 152) then
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
					elseif (Enum <= 164) then
						if (Enum <= 158) then
							if (Enum <= 155) then
								if (Enum == 154) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 157) then
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
						elseif (Enum <= 161) then
							if (Enum <= 159) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 160) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 162) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
						elseif (Enum == 163) then
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
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
							end
						end
					elseif (Enum <= 169) then
						if (Enum <= 166) then
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
								local Edx;
								local Results, Limit;
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 167) then
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
								if (Mvm[1] == 225) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						elseif (Enum == 168) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 172) then
						if (Enum <= 170) then
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
						elseif (Enum == 171) then
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
					elseif (Enum <= 173) then
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
					elseif (Enum == 174) then
						if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
				elseif (Enum <= 263) then
					if (Enum <= 219) then
						if (Enum <= 197) then
							if (Enum <= 186) then
								if (Enum <= 180) then
									if (Enum <= 177) then
										if (Enum > 176) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 178) then
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
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum > 179) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Inst[3];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 182) then
										local B;
										local A;
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
										Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
									end
								elseif (Enum <= 184) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum > 185) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 191) then
								if (Enum <= 188) then
									if (Enum > 187) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 189) then
									local B;
									local A;
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
							elseif (Enum <= 194) then
								if (Enum <= 192) then
									local B = Inst[3];
									local K = Stk[B];
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
								elseif (Enum > 193) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 195) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum > 196) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 208) then
							if (Enum <= 202) then
								if (Enum <= 199) then
									if (Enum > 198) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 205) then
								if (Enum <= 203) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 204) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 206) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 207) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 213) then
							if (Enum <= 210) then
								if (Enum > 209) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 211) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 212) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 216) then
							if (Enum <= 214) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 215) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum <= 217) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 218) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 241) then
						if (Enum <= 230) then
							if (Enum <= 224) then
								if (Enum <= 221) then
									if (Enum == 220) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
										A = Inst[2];
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
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 223) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								end
							elseif (Enum <= 227) then
								if (Enum <= 225) then
									Stk[Inst[2]] = Stk[Inst[3]];
								elseif (Enum > 226) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 228) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum == 229) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 235) then
							if (Enum <= 232) then
								if (Enum == 231) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 233) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Enum == 234) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 238) then
							if (Enum <= 236) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 237) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
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
						elseif (Enum <= 239) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 240) then
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
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
					elseif (Enum <= 252) then
						if (Enum <= 246) then
							if (Enum <= 243) then
								if (Enum > 242) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 244) then
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
							elseif (Enum > 245) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
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
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 249) then
							if (Enum <= 247) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 248) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Inst[2] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 250) then
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
						elseif (Enum == 251) then
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
					elseif (Enum <= 257) then
						if (Enum <= 254) then
							if (Enum > 253) then
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
						elseif (Enum <= 255) then
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Enum == 256) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 260) then
						if (Enum <= 258) then
							if (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 259) then
							if (Inst[2] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						else
							Stk[Inst[2]] = #Stk[Inst[3]];
						end
					elseif (Enum <= 261) then
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
					elseif (Enum == 262) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 307) then
					if (Enum <= 285) then
						if (Enum <= 274) then
							if (Enum <= 268) then
								if (Enum <= 265) then
									if (Enum > 264) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 267) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							elseif (Enum <= 271) then
								if (Enum <= 269) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum == 270) then
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
							elseif (Enum <= 272) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 273) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return Stk[Inst[2]];
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
						elseif (Enum <= 279) then
							if (Enum <= 276) then
								if (Enum > 275) then
									Stk[Inst[2]] = Inst[3] ~= 0;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 278) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 282) then
							if (Enum <= 280) then
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 281) then
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
						elseif (Enum <= 283) then
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						elseif (Enum == 284) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							local Results, Limit = _R(Stk[A]());
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 296) then
						if (Enum <= 290) then
							if (Enum <= 287) then
								if (Enum == 286) then
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
								elseif (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 288) then
								local Edx;
								local Results, Limit;
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 289) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 293) then
							if (Enum <= 291) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum > 292) then
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
						elseif (Enum <= 294) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						elseif (Enum == 295) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 301) then
						if (Enum <= 298) then
							if (Enum > 297) then
								local A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 300) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
						end
					elseif (Enum <= 304) then
						if (Enum <= 302) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 305) then
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
					elseif (Enum > 306) then
						if (Inst[2] > Inst[4]) then
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
				elseif (Enum <= 329) then
					if (Enum <= 318) then
						if (Enum <= 312) then
							if (Enum <= 309) then
								if (Enum == 308) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = #Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 310) then
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
								if not Stk[Inst[2]] then
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
						elseif (Enum <= 315) then
							if (Enum <= 313) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 314) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 316) then
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
						elseif (Enum > 317) then
							local Edx;
							local Results, Limit;
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
					elseif (Enum <= 323) then
						if (Enum <= 320) then
							if (Enum == 319) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 321) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 322) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 326) then
						if (Enum <= 324) then
							do
								return Stk[Inst[2]];
							end
						elseif (Enum == 325) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 327) then
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
						A = Inst[2];
						Stk[A] = Stk[A]();
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
					elseif (Enum == 328) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 340) then
					if (Enum <= 334) then
						if (Enum <= 331) then
							if (Enum == 330) then
								local B;
								local A;
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] <= Inst[4]) then
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
						elseif (Enum <= 332) then
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
						elseif (Enum == 333) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 337) then
						if (Enum <= 335) then
							do
								return Stk[Inst[2]]();
							end
						elseif (Enum == 336) then
							local B;
							local A;
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
						else
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
							end
						end
					elseif (Enum <= 338) then
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
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 339) then
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
				elseif (Enum <= 345) then
					if (Enum <= 342) then
						if (Enum > 341) then
							Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
					elseif (Enum <= 343) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 344) then
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
				elseif (Enum <= 348) then
					if (Enum <= 346) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Enum > 347) then
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
						local Step;
						local Index;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
				elseif (Enum <= 349) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum == 350) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503153O00F4D3D23DD989C819C4C6E40AF3AFCB1FC68DD730E703083O007EB1A3BB4586DBA703153O00DB620CC7C1400AD8EB773AF0EB6609DEE93C09CAFF03043O00BF9E1265002E3O0012AA3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004563O000A0001001268000300063O00201D000400030007001268000500083O00201D000500050009001268000600083O00201D00060006000A0006A700073O000100062O00E13O00064O00E18O00E13O00044O00E13O00014O00E13O00024O00E13O00053O00201D00080003000B00201D00090003000C2O0069000A5O001268000B000D3O0006A7000C0001000100022O00E13O000A4O00E13O000B4O00E1000D00073O001215000E000E3O001215000F000F4O002A010D000F00020006A7000E0002000100032O00E13O00074O00E13O00094O00E13O00084O00FD000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O002401025O00122O000300016O00045O00122O000500013O00042O0003002100012O004601076O003A010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004790003000500012O0046010300054O00E1000400024O006A000300044O005101036O00713O00017O000E3O00028O00025O00A8A640025O006C9540025O0004B340025O00809040026O00F03F025O00989140025O00807F40025O00709540025O00C88740025O0028AD40025O00206840025O0080AD40025O00DCA94001403O001215000200014O0058010300043O002EDE00030013000100020004563O001300010026B000020013000100010004563O00130001001215000500013O002EDE0005000E000100040004563O000E00010026B00005000E000100010004563O000E0001001215000300014O0058010400043O001215000500063O0026B000050007000100060004563O00070001001215000200063O0004563O001300010004563O000700010026B000020002000100060004563O00020001001215000500013O0026280005001A000100010004563O001A0001002E6400070016000100080004563O00160001000E5A0001001E000100030004563O001E0001002EDE000900320001000A0004563O00320001001215000600013O0026B00006002D000100010004563O002D00012O004601076O000D000400073O0006250104002700013O0004563O00270001002E86000B00070001000C0004563O002C00012O0046010700014O00E100086O00A400096O00C500076O005101075O001215000600063O0026B00006001F000100060004563O001F0001001215000300063O0004563O003200010004563O001F0001000E5A00060036000100030004563O00360001002EDE000D00150001000E0004563O001500012O00E1000600044O00A400076O00C500066O005101065O0004563O001500010004563O001600010004563O001500010004563O003F00010004563O000200012O00713O00017O00603O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00CF47A24AF003043O00269C37C7030A3O008568703C1A47EA46A47103083O0023C81D1C4873149A03043O0030ABD4D203073O005479DFB1BFED4C03053O009657CAB23503083O00A1DB36A9C05A305003073O006A4D0D28464C1303043O004529226003083O0099D5D2181B24B2C603063O004BDCA3B76A622O033O000CAF8603053O00B962DAEB5703073O00E8332AEBD1A4D803063O00CAAB5C4786BE03083O000CD7299A30CE228D03043O00E849A14C03043O00B9D64D5103053O007EDBB9223D03043O006D6174682O033O0001C75003083O00876CAE3E121E17932O033O00B7EB3903083O00A7D6894AAB78CE532O033O0086F12A03063O00C7EB90523D9803073O008F21A646C8590D03083O0069CC4ECB2BA7377E03083O0080BC260C0A0BC95403083O0031C5CA437E7364A703073O001454D2248F584D03073O003E573BBF49E03603053O00D50DFDDCE203043O00A987629A03053O00F9782341F803073O00A8AB1744349D5303063O00DB64E1A1243A03073O00E7941195CD454D03053O00B2A8C0EE5203063O009FE0C7A79B3703063O00D8E628DEF6E403043O00B297935C03053O00BEF24B271703073O001AEC9D2C52722C03063O00053BC1572B3903043O003B4A4EB5030F3O0008D05453B002C3535FB531DE4859BB03053O00D345B12O3A03023O00494403173O0093F778F2E6C5B1EC6BF0CBC4BAE75DFCFADBB2EB6AF0FB03063O00ABD78519958903113O00C3CD33F9E03EC84DD5C037D8EA29F34CE503083O002281A8529A8F509C030C3O0047657445717569706D656E74026O002A40028O00026O002C4003103O005265676973746572466F724576656E7403183O00B59E12326D7CB6A08306227863ACAB860C28606FA7A2971703073O00E9E5D2536B282E03083O00E54B21C604D5413A03053O0065A12252B603153O00526567697374657244616D616765466F726D756C61026O00184003053O00CA0150F0DF03083O004E886D399EBB82E203163O001D3EEAE57E1DF5F8303B2OB91731EDF42C2DECE12A7603043O00915E5F9903093O002ODF1BD44AA4F4C91103063O00D79DAD74B52E030E3O0017A199FBDF318099F7DB26A199F703053O00BA55D4EB92030A3O00E59317F03DC35DCE841303073O0038A2E1769E598E03113O006E10D4A72EDD4F16F0BD27DB5516C9A02C03063O00B83C65A0CF4203123O00028969B03D8372B8129073AF228073B2349103043O00DC51E21C030B3O0027C797FEC8C212C78BF5ED03063O00A773B5E29B8A03063O0053657441504C025O004070400003023O00C6000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0004000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000E000E000F4O000F5O00122O0010001A3O00122O0011001B6O000F001100024O000E000E000F4O000F5O00122O0010001C3O00122O0011001D6O000F001100024O000F0004000F4O00105O00122O0011001E3O00122O0012001F6O0010001200024O000F000F00104O00105O00122O001100203O00122O001200216O0010001200024O000F000F001000122O001000224O004601115O001201001200233O00122O001300246O0011001300024O00100010001100122O001100226O00125O00122O001300253O00122O001400266O0012001400024O00110011001200122O001200226O00135O00122O001400273O00122O001500286O0013001500024O0012001200134O00138O00148O00158O001600473O0006A700483O0001001C2O00E13O00454O0046017O00E13O00464O00E13O00474O00E13O001B4O00E13O001C4O00E13O001D4O00E13O001E4O00E13O00434O00E13O00444O00E13O00404O00E13O00414O00E13O003C4O00E13O003F4O00E13O00344O00E13O00394O00E13O001F4O00E13O002D4O00E13O002E4O00E13O002F4O00E13O00194O00E13O001A4O00E13O00164O00E13O00184O00E13O00324O00E13O00334O00E13O00304O00E13O00314O004D00495O00122O004A00293O00122O004B002A6O0049004B00024O0049000400494O004A5O00122O004B002B3O00122O004C002C6O004A004C00024O00490049004A4O004A5O00122O004B002D3O00122O004C002E6O004A004C00024O004A0004004A4O004B5O00122O004C002F3O00122O004D00306O004B004D00024O004A004A004B4O004B5O00122O004C00313O00122O004D00326O004B004D00024O004B000A004B4O004C5O00122O004D00333O00122O004E00346O004C004E00024O004B004B004C4O004C5O00122O004D00353O00122O004E00366O004C004E00024O004C000C004C4O004D5O00122O004E00373O00122O004F00386O004D004F00024O004C004C004D4O004D5O00122O004E00393O00122O004F003A6O004D004F00024O004D000D004D4O004E5O00122O004F003B3O00122O0050003C6O004E005000024O004D004D004E4O004E00026O004F5O00122O0050003D3O00122O0051003E6O004F005100024O004F004C004F00202O004F004F003F4O004F000200024O00505O00122O005100403O00122O005200416O0050005200024O0050004C005000202O00500050003F4O0050000200024O00515O00122O005200423O00122O005300436O0051005300024O0051004C005100202O00510051003F4O005100526O004E3O00010020F5004F000800442O006C004F0002000200201D0050004F0045000625015000D500013O0004563O00D500012O00E10050000C3O00201D0051004F00452O006C005000020002000618015000D8000100010004563O00D800012O00E10050000C3O001215005100464O006C00500002000200201D0051004F0047000625015100E000013O0004563O00E000012O00E10051000C3O00201D0052004F00472O006C005100020002000618015100E3000100010004563O00E300012O00E10051000C3O001215005200464O006C0051000200020020F50052000400480006A700540001000100052O00E13O004F4O00E13O00084O00E13O00504O00E13O000C4O00E13O00514O000300555O00122O005600493O00122O0057004A6O005500576O00523O00014O00525O00122O0053004B3O00122O0054004C6O0052005400024O0052004B00520020F500520052004D0006A700540002000100062O00E13O00084O00E13O004A4O0046012O00014O0046012O00024O00E13O00094O00E13O004B4O00110052005400014O005200553O00122O0056004E6O0057005F6O006000016O006100036O00625O00122O0063004F3O00122O006400506O0062006400022O000D0062004B00622O004601635O001215006400513O001215006500524O002A016300650002000205006400034O00FF0061000300012O00FF006000010001001215006100463O001215006200463O0006A700630004000100022O00E13O00614O00E13O00083O0006A700640005000100022O00E13O00624O00E13O00084O002B006500066O00665O00122O006700533O00122O006800546O0066006800024O0066004B00664O00675O00122O006800553O00122O006900566O0067006900022O000D0067004B00672O008F00685O00122O006900573O00122O006A00586O0068006A00024O0068004B00684O00695O00122O006A00593O00122O006B005A6O0069006B00024O0069004B00692O008F006A5O00122O006B005B3O00122O006C005C6O006A006C00024O006A004B006A4O006B5O00122O006C005D3O00122O006D005E6O006B006D00024O006B004B006B2O00FF0065000600010006A700660006000100062O00E13O00054O0046017O00E13O00084O00E13O00654O0046012O00014O0046012O00023O0006A700670007000100072O00E13O00054O0046017O00E13O00654O00E13O00084O0046012O00014O0046012O00024O00E13O004A3O0006A7006800080001000D2O00E13O00054O0046017O00E13O00394O00E13O00674O00E13O00084O00E13O004B4O00E13O00544O00E13O004A4O00E13O00094O00E13O00044O0046012O00014O00E13O000E4O0046012O00023O0006A700690009000100062O00E13O00584O00E13O004A4O00E13O000E4O00E13O00084O00E13O004B4O0046016O0006A7006A000A000100082O00E13O004B4O0046017O00E13O005A4O0046012O00014O00E13O000E4O00E13O00084O0046012O00024O00E13O005B3O0006A7006B000B000100082O00E13O00144O00E13O00544O00E13O00084O00E13O004B4O0046012O00014O00E13O000E4O0046017O0046012O00023O0006A7006C000C000100042O00E13O003C4O00E13O00084O00E13O00094O00E13O00463O0006A7006D000D000100052O00E13O004B4O0046017O0046012O00014O00E13O000E4O0046012O00023O0006A7006E000E000100032O00E13O00084O00E13O004B4O0046016O0006A7006F000F0001000C2O00E13O004B4O0046017O00E13O006E4O00E13O00694O00E13O00044O00E13O002E4O00E13O00164O00E13O006C4O00E13O00084O00E13O006D4O00E13O006A4O00E13O003C3O0006A700700010000100042O00E13O00554O00E13O00494O00E13O004E4O00E13O00153O0006A7007100110001001B2O00E13O004B4O0046017O00E13O00044O00E13O00164O00E13O00154O00E13O00084O00E13O005D4O00E13O005E4O00E13O00404O00E13O00554O00E13O006F4O00E13O00414O00E13O00694O00E13O00094O00E13O00474O00E13O00704O00E13O00684O00E13O004A4O0046012O00014O00E13O000E4O0046012O00024O00E13O00674O00E13O00434O00E13O00594O00E13O00444O00E13O00544O00E13O003F3O0006A7007200120001000B2O00E13O004B4O0046017O00E13O00144O00E13O00544O00E13O00084O00E13O003F4O00E13O00044O00E13O00094O00E13O00694O00E13O00304O00E13O00593O0006A7007300130001000A2O00E13O004B4O0046017O00E13O00094O00E13O00084O00E13O00044O00E13O00534O0046012O00014O00E13O00594O0046012O00024O00E13O00303O0006A7007400140001000C2O00E13O004B4O0046017O00E13O00084O00E13O005E4O00E13O005A4O0046012O00014O00E13O000E4O0046012O00024O00E13O00044O00E13O00094O00E13O00154O00E13O00453O0006A7007500150001002C2O00E13O005F4O00E13O00084O00E13O004B4O00E13O005B4O00E13O00644O00E13O005C4O00E13O00554O00E13O004A4O00E13O005E4O00E13O00634O00E13O005D4O00E13O00144O00E13O00524O00E13O00534O00E13O00564O00E13O00544O00E13O00484O00E13O00134O0046017O00E13O00334O00E13O00044O00E13O004C4O00E13O001C4O00E13O004D4O00E13O001A4O00E13O00154O00E13O00574O00E13O00344O00E13O00094O00E13O00494O00E13O00594O00E13O00674O00E13O00684O0046012O00014O0046012O00024O00E13O00724O00E13O00694O00E13O00734O00E13O00124O00E13O005A4O00E13O00584O00E13O00714O00E13O00164O00E13O00743O0006A700760016000100022O00E13O00044O0046016O00204201770004005F00122O007800606O007900756O007A00766O0077007A00016O00013O00173O00A73O00028O00025O0020AA40025O00D2A940026O001840030C3O004570696353652O74696E677303083O007D1225BCF8BE424903083O003A2E7751C891D02503103O000E8F38A3A0B331198920BEA0B037258803073O00564BEC50CCC9DD03083O0041446391F785755203063O00EB122117E59E030D3O0065A9C4885FB6CE8D51B4C8A85803043O00DB30DAA103083O00D774685DD241E7F703073O008084111C29BB2F03063O0012371629541203053O003D6152665A026O00F03F025O008AA640025O00149E40025O002EAF40025O00BEB140025O00E8984003083O00E1E325A6AFF00CC103073O006BB28651D2C69E030E3O000D1D87EEAF390296CEB92C018CC303053O00CA586EE2A603083O00F00A96E3C3CD089103053O00AAA36FE297030D3O003935B3345A3F3A053FBC3D660703073O00497150D2582E57027O004003083O00B229D906EE8F2BDE03053O0087E14CAD7203113O0033E3ACB5BEAFB20AF98FB9B8B5940EF8B603073O00C77A8DD8D0CCDD03083O009ED804E471F8AACE03063O0096CDBD70901803163O000C8AAB49169A040031ABB1401DBF2O193181B345179C03083O007045E4DF2C64E871025O00A4AB40025O00207540025O0062AB40026O001440025O00349240025O000C9140025O008CAD40025O00405140025O002CA640025O0060A54003083O002353979F8F20AAE303083O00907036E3EBE64ECD03103O00982D0AECF94F812703F0D955B40F2CD803063O003BD3486F9CB003083O007D82F7394789E43E03043O004D2EE78303143O009B50A445B455BA49B4518455A95C9946BC73956403043O0020DA34D6025O0086AC4003083O004B823A037189290403043O007718E74E030C3O00A021A44ED9720491258269F803073O0071E24DC52ABC2003083O000913E0A13318F3A603043O00D55A769403103O007C26BB4559573787425F5225B1716E7F03053O002D3B4ED436025O00989540025O00288540026O001040026O008540026O00774003083O00115D23CCD71AE13103073O0086423857B8BE74030C3O0009220C9F29D8173432381AB303083O00555C5169DB798B4103083O00CEB6445175D1FAA003063O00BF9DD330251C030E3O00FD13F5183FF913E10E28C638D73803053O005ABF7F947C03083O009D59272F263FA94F03063O0051CE3C535B4F030A3O007DBFD57323D7458B618803083O00C42ECBB0124FA32D03083O008B276A0A2DF5E8AB03073O008FD8421E7E449B03113O0098C701C7D1ABD2C3A5C608D8E9ACD0E8A903083O0081CAA86DABA5C3B7025O00388C40025O003EA540025O00D88F40025O00207240025O0074A54003083O00E71A13C7BF7281C703073O00E6B47F67B3D61C03123O00A50B4B43F653F59C116B4EF644F3840A534203073O0080EC653F26842103083O009FAC0550BFE5C8BF03073O00AFCCC97124D68B030C3O0071CD3BD5174FE333DA2364E803053O006427AC55BC03083O009E7DAD943AA37FAA03053O0053CD18D9E003113O00D5CDCC39E9D2E93CE8C6C812E0C3EA1EC203043O005D86A5AD03083O008DF7D5D633C0B56D03083O001EDE92A1A25AAED203103O00D1467919F142753EE04F5F0CE369532E03043O006A852E10025O000C9E40025O00F9B140026O000840025O00EAAE40025O0066A040025O00C2A040025O0067B240025O00F0B240025O00DDB040025O00088440025O00BBB240025O004CAF40025O0028874003083O00652D4B2O2C50FF4503073O009836483F58453E03113O00FCC1EF50DDCAE96CDBD0E753DAEAEF51D103043O003CB4A48E03083O006B5B113D2EE3154B03073O0072383E6549478D030F3O0090ECDAC8B1E7DCF4B7FDD2CBB6C1EB03043O00A4D889BB025O006EA240025O002AAD4003083O003413AD3F0E18BE3803043O004B6776D9030A3O00F2477526B81DCE557C0703063O007EA7341074D903083O00FB2B3494BD17FBDB03073O009CA84E40E0D47903103O0032FDA0E602EFA9C709E995C113E7AAC003043O00AE678EC5025O00F4B140025O00C4A240025O003CA040025O00606440025O00809240025O0014B040025O0008874003083O000FAA9558EA777F2F03073O00185CCFE12C8319030D3O0068C1B141087245E5B14D17557B03063O001D2BB3D82C7B03083O008EDC3458B4D7275F03043O002CDDB94003073O0027E241516729D703053O00136187283F025O005C9240025O00D4AF40025O00449540025O0086B24003083O006B2567E8534E5F3303063O00203840139C3A030F3O0079C7E95278FE8F55CCCA505CD5A37E03073O00E03AA885363A9203083O006A535FE97C88801803083O006B39362B9D15E6E703143O00F68A03FEBCD8C9D49935F0B8C8C7F48D17D29AF803073O00AFBBEB7195D9BC002E022O0012153O00014O00582O0100013O0026B03O0002000100010004563O00020001001215000100013O002E640003002E000100020004563O002E00010026B00001002E000100040004563O002E0001001268000200054O008F000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O0002000200032O008800025O00122O000200056O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000300013O00122O0004000C3O00122O0005000D4O002A0103000500022O000D0002000200032O0088000200023O00122O000200056O000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000300013O00122O000400103O00122O000500114O002A0103000500022O000D0002000200032O00A2000200033O0004563O002D020100262800010032000100120004563O00320001002EDE0013008D000100140004563O008D0001001215000200014O0058010300033O002E8600153O000100150004563O003400010026280002003A000100010004563O003A0001002E6400160034000100170004563O00340001001215000300013O000E2100010059000100030004563O00590001001268000400054O0033000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400054O000400043O00122O000400056O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000500013O00122O0006001E3O00122O0007001F6O0005000700024O00040004000500062O00040057000100010004563O00570001001215000400014O00A2000400053O001215000300123O0026B000030082000100120004563O00820001001215000400013O0026B000040060000100120004563O00600001001215000300203O0004563O008200010026B00004005C000100010004563O005C0001001268000500054O003B010600013O00122O000700213O00122O000800226O0006000800024O0005000500064O000600013O00122O000700233O00122O000800246O0006000800024O00050005000600062O00050070000100010004563O00700001001215000500014O00A2000500063O001236000500056O000600013O00122O000700253O00122O000800266O0006000800024O0005000500064O000600013O00122O000700273O00122O000800286O0006000800024O00050005000600062O0005007F000100010004563O007F0001001215000500014O00A2000500073O001215000400123O0004563O005C0001002E640003003B000100290004563O003B0001002E64002A003B0001002B0004563O003B00010026B00003003B000100200004563O003B0001001215000100203O0004563O008D00010004563O003B00010004563O008D00010004563O00340001002628000100910001002C0004563O00910001002EDE002D00DD0001002E0004563O00DD0001001215000200014O0058010300033O002E86002F3O0001002F0004563O009300010026B000020093000100010004563O00930001001215000300013O002E8600300004000100300004563O009C00010026280003009E000100120004563O009E0001002EDE003100B7000100320004563O00B70001001268000400054O00AF000500013O00122O000600333O00122O000700346O0005000700024O0004000400054O000500013O00122O000600353O00122O000700366O0005000700024O0004000400054O000400083O00122O000400056O000500013O00122O000600373O00122O000700386O0005000700024O0004000400054O000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000400093O00122O000300203O002E86003B001D0001003B0004563O00D40001000E21000100D4000100030004563O00D40001001268000400054O00AF000500013O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O000500013O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O0004000A3O00122O000400056O000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O000500013O00122O000600423O00122O000700436O0005000700024O0004000400054O0004000B3O00122O000300123O002EDE00450098000100440004563O009800010026B000030098000100200004563O00980001001215000100043O0004563O00DD00010004563O009800010004563O00DD00010004563O009300010026B00001002B2O0100460004563O002B2O01001215000200014O0058010300033O0026B0000200E1000100010004563O00E10001001215000300013O002628000300E8000100200004563O00E80001002E8600470004000100480004563O00EA00010012150001002C3O0004563O002B2O01000E210012000D2O0100030004563O000D2O01001215000400013O0026B0000400F1000100120004563O00F10001001215000300203O0004563O000D2O010026B0000400ED000100010004563O00ED0001001268000500054O0019000600013O00122O000700493O00122O0008004A6O0006000800024O0005000500064O000600013O00122O0007004B3O00122O0008004C6O0006000800024O0005000500064O0005000C3O00122O000500056O000600013O00122O0007004D3O00122O0008004E6O0006000800024O0005000500064O000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O0005000D3O00122O000400123O00044O00ED00010026B0000300E4000100010004563O00E40001001268000400054O0019000500013O00122O000600513O00122O000700526O0005000700024O0004000400054O000500013O00122O000600533O00122O000700546O0005000700024O0004000400054O0004000E3O00122O000400056O000500013O00122O000600553O00122O000700566O0005000700024O0004000400054O000500013O00122O000600573O00122O000700586O0005000700024O0004000400054O0004000F3O00122O000300123O00044O00E400010004563O002B2O010004563O00E10001002EDE005900742O01005A0004563O00742O01002E86005B00470001005B0004563O00742O010026B0000100742O0100200004563O00742O01001215000200013O002628000200362O0100010004563O00362O01002EDE005D00522O01005C0004563O00522O01001268000300054O003B010400013O00122O0005005E3O00122O0006005F6O0004000600024O0003000300044O000400013O00122O000500603O00122O000600616O0004000600024O00030003000400062O000300442O0100010004563O00442O01001215000300014O00A2000300103O001244000300056O000400013O00122O000500623O00122O000600636O0004000600024O0003000300044O000400013O00122O000500643O00122O000600656O0004000600024O0003000300044O000300113O00122O000200123O000E210012006D2O0100020004563O006D2O01001268000300054O00AF000400013O00122O000500663O00122O000600676O0004000600024O0003000300044O000400013O00122O000500683O00122O000600696O0004000600024O0003000300044O000300123O00122O000300056O000400013O00122O0005006A3O00122O0006006B6O0004000600024O0003000300044O000400013O00122O0005006C3O00122O0006006D6O0004000600024O0003000300044O000300133O00122O000200203O002EDE006E00322O01006F0004563O00322O010026B0000200322O0100200004563O00322O01001215000100703O0004563O00742O010004563O00322O010026B0000100D22O0100010004563O00D22O01001215000200014O0058010300033O0026280002007E2O0100010004563O007E2O01002EF80071007E2O0100720004563O007E2O01002EDE007400782O0100730004563O00782O01001215000300013O002628000300832O0100200004563O00832O01002E64007500852O0100760004563O00852O01001215000100123O0004563O00D22O01002EDE007700AA2O0100780004563O00AA2O01002EDE007A00AA2O0100790004563O00AA2O010026B0000300AA2O0100120004563O00AA2O01001268000400054O003B010500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400054O000500013O00122O0006007D3O00122O0007007E6O0005000700024O00040004000500062O000400992O0100010004563O00992O01001215000400014O00A2000400143O001236000400056O000500013O00122O0006007F3O00122O000700806O0005000700024O0004000400054O000500013O00122O000600813O00122O000700826O0005000700024O00040004000500062O000400A82O0100010004563O00A82O01001215000400014O00A2000400153O001215000300203O0026B00003007F2O0100010004563O007F2O01001215000400013O002E64008300CA2O0100840004563O00CA2O010026B0000400CA2O0100010004563O00CA2O01001268000500054O00AF000600013O00122O000700853O00122O000800866O0006000800024O0005000500064O000600013O00122O000700873O00122O000800886O0006000800024O0005000500064O000500163O00122O000500056O000600013O00122O000700893O00122O0008008A6O0006000800024O0005000500064O000600013O00122O0007008B3O00122O0008008C6O0006000800024O0005000500064O000500173O00122O000400123O0026B0000400AD2O0100120004563O00AD2O01001215000300123O0004563O007F2O010004563O00AD2O010004563O007F2O010004563O00D22O010004563O00782O01002628000100D62O0100700004563O00D62O01002E64008D00050001008E0004563O00050001001215000200013O002EDE009000DB2O01008F0004563O00DB2O01002628000200DD2O0100200004563O00DD2O01002E64002900DF2O0100910004563O00DF2O01001215000100463O0004563O00050001002EDE0093002O020100920004563O002O02010026B00002002O020100120004563O002O0201001268000300054O003B010400013O00122O000500943O00122O000600956O0004000600024O0003000300044O000400013O00122O000500963O00122O000600976O0004000600024O00030003000400062O000300F12O0100010004563O00F12O01001215000300014O00A2000300183O001236000300056O000400013O00122O000500983O00122O000600996O0004000600024O0003000300044O000400013O00122O0005009A3O00122O0006009B6O0004000600024O00030003000400062O00032O00020100010004564O000201001215000300014O00A2000300193O001215000200203O00262800020006020100010004563O00060201002EDE009D00D72O01009C0004563O00D72O01001215000300013O0026B00003000B020100120004563O000B0201001215000200123O0004563O00D72O01000E5A0001000F020100030004563O000F0201002E86009E00FAFF2O009F0004563O00070201001268000400054O0019000500013O00122O000600A03O00122O000700A16O0005000700024O0004000400054O000500013O00122O000600A23O00122O000700A36O0005000700024O0004000400054O0004001A3O00122O000400056O000500013O00122O000600A43O00122O000700A56O0005000700024O0004000400054O000500013O00122O000600A63O00122O000700A76O0005000700024O0004000400054O0004001B3O00122O000300123O00044O000702010004563O00D72O010004563O000500010004563O002D02010004563O000200012O00713O00017O00123O00028O00025O00C4AD40025O00A7B240025O0058AF40025O00D0AF40025O0092AA40025O004EA140025O00FAA340030C3O0047657445717569706D656E74026O002A40026O00F03F025O00BEAD40025O00F09340025O001CA240025O003C9E40025O0058A140025O0009B140026O002C4000453O0012153O00014O00582O0100013O0026283O0006000100010004563O00060001002EDE00030002000100020004563O00020001001215000100013O0026280001000D000100010004563O000D0001002E330105000D000100040004563O000D0001002E640006002E000100070004563O002E0001001215000200013O002E8600080017000100080004563O00250001000E2100010025000100020004563O002500012O0046010300013O00200E0003000300094O0003000200024O00038O00035O00202O00030003000A00062O0003002000013O0004563O002000012O0046010300034O004601045O00201D00040004000A2O006C00030002000200061801030023000100010004563O002300012O0046010300033O001215000400014O006C0003000200022O00A2000300023O0012150002000B3O002E64000D00290001000C0004563O002900010026280002002B0001000B0004563O002B0001002E64000E000E0001000F0004563O000E00010012150001000B3O0004563O002E00010004563O000E0001002E6400100007000100110004563O000700010026B0000100070001000B0004563O000700012O004601025O00201D0002000200120006250102003C00013O0004563O003C00012O0046010200034O004601035O00201D0003000300122O006C0002000200020006180102003F000100010004563O003F00012O0046010200033O001215000300014O006C0002000200022O00A2000200043O0004563O004400010004563O000700010004563O004400010004563O000200012O00713O00017O00093O0003143O00412O7461636B506F77657244616D6167654D6F6403073O0043505370656E64026O33D33F026O00F03F03113O00566572736174696C697479446D67506374026O00594003083O00446562752O665570030D3O0047686F73746C79537472696B65029A5O99F13F00274O00DD7O00206O00016O000200024O000100013O00202O0001000100024O0001000100028O000100206O000300206O00044O000100023O00122O000200046O00035O00202O0003000300054O00030002000200202O0003000300064O0001000300024O000200033O00122O000300046O00045O00202O0004000400054O00040002000200202O0004000400064O0002000400024O0001000100028O00014O000100043O00202O0001000100074O000300053O00202O0003000300084O00010003000200062O0001002300013O0004563O00230001001215000100093O0006182O010024000100010004563O00240001001215000100044O00E05O00012O0044012O00024O00713O00019O003O00034O0014012O00014O0044012O00024O00713O00017O000C3O00028O00025O00F2AA40026O00F03F025O00806C40025O0016B040025O00F4AB4003183O00456E6572677954696D65546F4D6178507265646963746564026O00E03F025O00C6A640025O00D49D40025O00149540025O0040954001343O001215000100014O0058010200033O002E8600020007000100020004563O000900010026B000010009000100010004563O00090001001215000200014O0058010300033O001215000100033O002E86000400F9FF2O00040004563O000200010026B000010002000100030004563O000200010026B000020011000100030004563O001100012O004601046O0044010400023O000E5A00010015000100020004563O00150001002E640005000D000100060004563O000D0001001215000400013O0026B000040029000100010004563O002900012O0046010500013O0020410005000500074O000700076O00088O0005000800024O000300056O00055O00062O00030027000100050004563O002700012O004601056O008A000500030005000E1300080027000100050004563O00270001002EDE000900280001000A0004563O002800012O00A200035O001215000400033O0026280004002D000100030004563O002D0001002E64000C00160001000B0004563O00160001001215000200033O0004563O000D00010004563O001600010004563O000D00010004563O003300010004563O000200012O00713O00017O00143O00028O00025O00C4AD40025O00588840026O00F03F025O00D08340025O00C6A140025O000C9140025O00C2A540025O00EEA240025O00BC9140025O001EB240025O0030A640025O00309440025O003EB140025O0068B240026O00A740025O00EAB140025O001EA040030F3O00456E65726779507265646963746564026O002240003C3O0012153O00014O00582O0100013O001215000200013O002E6400030003000100020004563O000300010026B000020003000100010004563O000300010026B03O000B000100040004563O000B00012O004601036O0044010300023O002E6400050002000100060004563O000200010026B03O0002000100010004563O00020001001215000300013O002E6400070014000100080004563O0014000100262800030016000100040004563O00160001002E86000900040001000A0004563O001800010012153O00043O0004563O00020001002E64000C00100001000B0004563O001000010026B000030010000100010004563O00100001001215000400013O00262800040023000100040004563O00230001002E03010E00230001000D0004563O00230001002E64000F0025000100100004563O00250001001215000300043O0004563O0010000100262800040029000100010004563O00290001002E640011001D000100120004563O001D00012O0046010500013O0020390005000500134O0005000200024O000100056O00055O00062O00050034000100010004563O003400012O004601056O008A000500010005000E1C01140035000100050004563O003500012O00A200015O001215000400043O0004563O001D00010004563O001000010004563O000200010004563O000300010004563O000200012O00713O00017O00483O00028O00025O006EAB40025O00A8A04003063O00C312CB6A7A6303073O00A68242873C1B1103083O00765EEC4A1C4D59DA03053O0050242AAE1503063O006F201B4C4F0203043O001A2E705703083O008B37894B93B656A003083O00D4D943CB142ODF25025O00208D40025O0008AF4003063O009BBD84E4BB9F03043O00B2DAEDC803083O0084A1C4EF9ABCF5C403043O00B0D6D58603063O00D59D9AE2A94403073O003994CDD6B4C83603083O0020E9170B5A1BEE2103053O0016729D5554026O00F03F027O0040025O000AAC40025O005EA94003063O00A5717418855303043O004EE4213803083O00FC6A903CA9C76DA603053O00E5AE1ED263025O00D0B140025O000CA54003053O007461626C6503063O00636F6E6361742O033O00E5C71F03073O00C8A4AB73A43D9603063O009FC42F7382AC03053O00E3DE94632503083O00014670C9D53A414603053O0099532O3296025O008C9B40025O006C9B4003063O007C465F2A72B903073O002D3D16137C13CB03083O00F3062FCA2E79AAD503073O00D9A1726D956210025O00C6AA40025O00CEA04003063O0042752O665570025O00C6A340025O0002AF40025O00EAAD40025O00E8A74003063O003310144ABD6603063O00147240581CDC03083O000315F08BD4D9AE2503073O00DD5161B2D498B0025O00108740025O0022A140025O00406F40025O0030774003063O00ECD731CD1BDF03053O007AAD877D9B03083O00B6D522861338DB9003073O00A8E4A160D95F510100025O0016B140025O0068954003063O00FAE1026A2E4503063O0037BBB14E3C4F03083O001FDA7DD46AC6933903073O00E04DAE3F8B26AF2O0102F43O001215000200014O0058010300033O002E860002003D000100020004563O003F00010026B00002003F000100010004563O003F0001002E860003001B000100030004563O002100012O004601046O003B010500013O00122O000600043O00122O000700056O0005000700024O0004000400054O000500013O00122O000600063O00122O000700076O0005000700024O00040004000500062O00040021000100010004563O002100012O004601046O00EE000500013O00122O000600083O00122O000700096O0005000700024O0004000400054O000500013O00122O0006000A3O00122O0007000B6O0005000700024O00066O0091000400050006002E64000C003E0001000D0004563O003E00012O004601046O008F000500013O00122O0006000E3O00122O0007000F6O0005000700024O0004000400054O000500013O00122O000600103O00122O000700116O0005000700024O0004000400052O000D000400043O0006180104003E000100010004563O003E00012O004601046O008F000500013O00122O000600123O00122O000700136O0005000700024O0004000400054O000500013O00122O000600143O00122O000700156O0005000700024O0004000400052O006900056O009100043O0005001215000200163O00262800020043000100170004563O00430001002E6400180051000100190004563O005100012O004601046O0011010500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400054O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000400046O0004000400034O000400023O0026B000020002000100160004563O00020001001215000400013O00262800040058000100010004563O00580001002E64001E00ED0001001F0004563O00ED0001001268000500203O00201D0005000500212O00E1000600014O006C0005000200022O00E1000300054O00E3000500013O00122O000600223O00122O000700236O00050007000200064O00AF000100050004563O00AF00012O004601056O00D7000600013O00122O000700243O00122O000800256O0006000800024O0005000500064O000600013O00122O000700263O00122O000800276O0006000800024O0005000500064O000500056O00050005000300062O0005007400013O0004563O00740001002EDE002800EC000100290004563O00EC0001001215000500014O0058010600063O0026B00005008D000100160004563O008D00012O004601076O0035010800013O00122O0009002A3O00122O000A002B6O0008000A00024O0007000700084O000800013O00122O0009002C3O00122O000A002D6O0008000A00024O0007000700084O000700076O000800013O00062O0006008A000100080004563O008A00012O0014010800013O0006180108008B000100010004563O008B00012O001401086O00910007000300080004563O00EC000100262800050091000100010004563O00910001002EDE002E00760001002F0004563O00760001001215000600013O001215000700164O0004010800013O001215000900163O0004A0000700AC00012O0046010B00023O0020B6000B000B00304O000D00036O000E0001000A4O000D000D000E4O000B000D000200062O000B00A2000100010004563O00A20001002E33013200A2000100310004563O00A20001002E860033000B000100340004563O00AB00012O0046010B00044O0048000C00063O00122O000D00166O000B000D00024O000C00056O000D00063O00122O000E00166O000C000E00024O0006000B000C000479000700960001001215000500163O0004563O007600010004563O00EC00012O004601056O00D7000600013O00122O000700353O00122O000800366O0006000800024O0005000500064O000600013O00122O000700373O00122O000800386O0006000800024O0005000500064O000500056O00050005000300062O000500C200013O0004563O00C20001002E03013A00C2000100390004563O00C20001002E86003B002C0001003C0004563O00EC00012O004601056O005B010600013O00122O0007003D3O00122O0008003E6O0006000800024O0005000500064O000600013O00122O0007003F3O00122O000800406O0006000800024O0005000500064O000500053O00202O00050003004100122O000500166O000600013O00122O000700163O00042O000500EC0001002EDE004300EB000100420004563O00EB00012O0046010900023O0020BD0009000900304O000B00036O000C000100084O000B000B000C4O0009000B000200062O000900EB00013O0004563O00EB00012O004601096O008F000A00013O00122O000B00443O00122O000C00456O000A000C00024O00090009000A4O000A00013O00122O000B00463O00122O000C00476O000A000C00024O00090009000A2O000D000900093O0020B70009000300480004563O00EC0001000479000500D30001001215000400163O0026B000040054000100160004563O00540001001215000200173O0004563O000200010004563O005400010004563O000200012O00713O00017O008A3O00028O00025O007EAB40025O007AA840025O00FEB140025O008CAA40025O0084B340025O0071B240025O00F49C40025O00389B40025O006EAF40025O003EA540025O00606E40025O00A4B140025O003EAD40025O00389D4003063O003ADDAA67EC2F03073O00597B8DE6318D5D03093O00C165D433325FF577E503063O002A9311966C70025O0014A340025O0008A440025O0016B140025O0048B040025O00A07240025O00ECA940025O00E0B140025O004AB34003063O002E960149E6FA03063O00886FC64D1F8703093O00301D85699FF111AF1103083O00C96269C736DD847703063O00983CAF17032703073O00CCD96CE341625503093O006C2OD7DA0ED558C5E603063O00A03EA395854C03053O00E2AF192ECF03053O00A3B6C06D4F026O00F03F025O00E4A640025O00488440025O00109240025O0040A940025O00488840025O00C4A340025O00C89540025O00A06040026O007B40025O00F07E4003063O0015162CF6F42603053O0095544660A003093O000A122FD21A130BEB2B03043O008D58666D03063O009D5CD87D1B3103083O00A1D333AA107A5D3503063O00DA2O9E1EFABC03043O00489BCED203093O00746E763111537C521D03053O0053261A346E03073O006B1F28544C123503043O0026387747025O0042AD40025O0036A540027O0040026O000840025O004EB340025O00CC9A40025O00805040025O00C09640025O003EA740025O0048B140030B3O0042752O6652656D61696E73025O00A4A640025O00F0904003063O00AD0C68D4521003063O0062EC5C24823303093O00960D2E8567BDB336B703083O0050C4796CDA25C8D503053O00347C167E4703073O00EA6013621F2B6E03063O00272F7EF1AD6003073O00EB667F32A7CC1203093O0062B5D71C663B56A7E603063O004E30C195432403053O00041194194D03053O0021507EE078025O00C05940025O00EEAF4003063O00CD982FF25DFE03053O003C8CC863A403093O00B5E026198092F2023503053O00C2E794644603063O006843D3AEF7C403063O00A8262CA1C39603063O00A1CCAE4031FA03083O0076E09CE2165088D603093O0070FA7BBF60FB5F865103043O00E0228E3903063O00F0A8D7D072FD03083O006EBEC7A5BD13913D03063O00FBDB5BDE8AD503063O00A7BA8B1788EB03093O0028A1AA3238A08E0B0903043O006D7AD5E803063O00C2F8AC37EBE503043O00508E97C203063O0022F65B7A02D403043O002C63A61703093O004EE30B0911B17AF13A03063O00C41C9749565303063O00DF0C2717874A03083O001693634970E2387803063O009945CEC38CAA03053O00EDD815829503093O00B05A7D6092DC58845D03073O003EE22E2O3FD0A903073O00D6115A910B083D03083O003E857935E37F6D4F03063O0031241EC3D7BC03073O00C270745295B6CE03093O000BBC6E27E2F7083FBB03073O006E59C82C78A08203073O0098CB4454574F2903083O002DCBA32B26232A5B025O00708B40025O002CA94003063O00D2DF74E0244403063O0036938F38B64503093O00E495DD76FDC387F95A03053O00BFB6E19F2903063O00071D26528E9503073O00A24B724835EBE7030A3O0052744252656D61696E7303063O00F3B5F01586BB03073O0034B2E5BC43E7C903093O001355723BD54925275203073O004341213064973C03053O00EBE8BAD9FF03053O0093BF87CEB800E9012O0012153O00014O00582O0100013O002EDE00030002000100020004563O00020001002E6400050002000100040004563O000200010026B03O0002000100010004563O00020001001215000100013O002EDE00070009000100060004563O00090001002EDE00090009000100080004563O000900010026B000010009000100010004563O00090001001215000200013O002E64000B00100001000A0004563O001000010026B000020010000100010004563O00100001001215000300013O002E64000C00150001000D0004563O001500010026B000030015000100010004563O00150001002E64000F00D22O01000E0004563O00D22O012O004601046O003A000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000500013O00122O000600123O00122O000700136O0005000700024O00040004000500062O0004002A00013O0004563O002A0001002EDE001500D22O0100140004563O00D22O01001215000400014O0058010500053O0026B000040069000100010004563O00690001001215000600014O0058010700073O002E6400170030000100160004563O003000010026B000060030000100010004563O00300001001215000700013O0026B000070060000100010004563O00600001001215000800013O002E640018005B000100190004563O005B00010026280008003E000100010004563O003E0001002EDE001B005B0001001A0004563O005B00012O004601096O0054000A00013O00122O000B001C3O00122O000C001D6O000A000C00024O00090009000A4O000A00013O00122O000B001E3O00122O000C001F6O000A000C00024O000B8O0009000A000B4O00098O000A00013O00122O000B00203O00122O000C00216O000A000C00024O00090009000A4O000A00013O00122O000B00223O00122O000C00236O000A000C00024O00090009000A4O000A00013O00122O000B00243O00122O000C00256O000A000C000200202O0009000A000100122O000800263O000E2100260038000100080004563O00380001001215000700263O0004563O006000010004563O00380001002EDE00280035000100270004563O003500010026B000070035000100260004563O00350001001215000400263O0004563O006900010004563O003500010004563O006900010004563O00300001002EDE002900A40001002A0004563O00A400010026B0000400A4000100260004563O00A40001001215000600014O0058010700073O002EDE002B006F0001002C0004563O006F0001000E5A00010075000100060004563O00750001002EDE002D006F0001002E0004563O006F0001001215000700013O0026280007007A000100010004563O007A0001002E86002F0023000100300004563O009B00012O004601086O00D0000900013O00122O000A00313O00122O000B00326O0009000B00024O0008000800092O002C010900013O00122O000A00333O00122O000B00346O0009000B00024O0008000800094O000900013O00122O000A00353O00122O000B00366O0009000B000200202O0008000900012O001E00088O000900013O00122O000A00373O00122O000B00386O0009000B00024O0008000800092O002C010900013O00122O000A00393O00122O000B003A6O0009000B00024O0008000800094O000900013O00122O000A003B3O00122O000B003C6O0009000B000200202O000800090001001215000700263O002E64003E00760001003D0004563O007600010026B000070076000100260004563O007600010012150004003F3O0004563O00A400010004563O007600010004563O00A400010004563O006F0001002628000400A8000100400004563O00A80001002E860041000A2O0100420004563O00B02O01001215000600264O0046010700024O0004010700073O001215000800263O0004A0000600AF2O01001215000A00014O0058010B000D3O0026B0000A00A82O0100260004563O00A82O012O0058010D000D3O002EDE004300A12O0100440004563O00A12O010026B0000B00A12O0100260004563O00A12O01002628000C00BA000100010004563O00BA0001002EDE004600B6000100450004563O00B600012O0046010E00033O00204A010E000E00474O001000026O0010001000094O000E001000024O000D000E3O00262O000D00C3000100010004563O00C300010004563O00AE2O01001215000E00014O0058010F000F3O0026B0000E00C5000100010004563O00C50001001215000F00013O002E64004900C8000100480004563O00C800010026B0000F00C8000100010004563O00C800012O004601106O008F001100013O00122O0012004A3O00122O0013004B6O0011001300024O0010001000114O001100013O00122O0012004C3O00122O0013004D6O0011001300024O0010001000112O0046011100013O0012CD0012004E3O00122O0013004F6O0011001300024O001200046O00138O001400013O00122O001500503O00122O001600516O0014001600024O0013001300142O008F001400013O00122O001500523O00122O001600536O0014001600024O0013001300144O001400013O00122O001500543O00122O001600556O0014001600024O001300130014001215001400264O002A0112001400022O0019011300056O00148O001500013O00122O001600503O00122O001700516O0015001700024O0014001400154O001500013O00122O001600523O00122O001700534O002A0115001700022O002C0014001400154O001500013O00122O001600543O00122O001700556O0015001700024O00140014001500122O001500266O0013001500024O0012001200134O0010001100120006AE000D00072O0100050004563O00072O01002E860056003A000100570004563O003F2O012O004601106O000D011100013O00122O001200583O00122O001300596O0011001300024O0010001000114O001100013O00122O0012005A3O00122O0013005B6O0011001300024O0010001000114O001100013O00122O0012005C3O00122O0013005D6O0011001300024O001200046O00138O001400013O00122O0015005E3O00122O0016005F6O0014001600024O0013001300144O001400013O00122O001500603O00122O001600616O0014001600024O0013001300144O001400013O00122O001500623O00122O001600636O0014001600024O00130013001400122O001400266O0012001400024O001300056O00148O001500013O00122O0016005E3O00122O0017005F6O0015001700024O0014001400154O001500013O00122O001600603O00122O001700616O0015001700024O0014001400154O001500013O00122O001600623O00122O001700636O0015001700024O00140014001500122O001500266O0013001500024O0012001200134O00100011001200044O00AE2O01000610010500632O01000D0004563O00632O012O004601106O0025001100013O00122O001200643O00122O001300656O0011001300024O0010001000114O001100013O00122O001200663O00122O001300676O0011001300024O0010001000114O001100013O00122O001200683O00122O001300696O0011001300024O00128O001300013O00122O0014006A3O00122O0015006B6O0013001500024O0012001200134O001300013O00122O0014006C3O00122O0015006D6O0013001500024O0012001200134O001300013O00122O0014006E3O00122O0015006F6O0013001500024O00120012001300202O0012001200264O00100011001200044O00AE2O012O004601106O000D011100013O00122O001200703O00122O001300716O0011001300024O0010001000114O001100013O00122O001200723O00122O001300736O0011001300024O0010001000114O001100013O00122O001200743O00122O001300756O0011001300024O001200046O00138O001400013O00122O001500763O00122O001600776O0014001600024O0013001300144O001400013O00122O001500783O00122O001600796O0014001600024O0013001300144O001400013O00122O0015007A3O00122O0016007B6O0014001600024O00130013001400122O001400266O0012001400024O001300056O00148O001500013O00122O001600763O00122O001700776O0015001700024O0014001400154O001500013O00122O001600783O00122O001700796O0015001700024O0014001400154O001500013O00122O0016007A3O00122O0017007B6O0015001700024O00140014001500122O001500266O0013001500024O0012001200134O00100011001200044O00AE2O010004563O00C800010004563O00AE2O010004563O00C500010004563O00AE2O010004563O00B600010004563O00AE2O01000E21000100B20001000B0004563O00B20001001215000C00014O0058010D000D3O001215000B00263O0004563O00B200010004563O00AE2O010026B0000A00AF000100010004563O00AF0001001215000B00014O0058010C000C3O001215000A00263O0004563O00AF0001000479000600AD00010004563O00D22O010026B00004002C0001003F0004563O002C0001001215000600013O002628000600B72O0100010004563O00B72O01002E64007D00CC2O01007C0004563O00CC2O012O004601076O0030010800013O00122O0009007E3O00122O000A007F6O0008000A00024O0007000700084O000800013O00122O000900803O00122O000A00816O0008000A00024O0007000700084O000800013O00122O000900823O00122O000A00836O0008000A000200202O0007000800014O000700063O00202O0007000700844O0007000100024O000500073O00122O000600263O000E21002600B32O0100060004563O00B32O01001215000400403O0004563O002C00010004563O00B32O010004563O002C00012O004601046O008F000500013O00122O000600853O00122O000700866O0005000700024O0004000400054O000500013O00122O000600873O00122O000700886O0005000700024O0004000400052O00D0000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400052O0044010400023O0004563O001500010004563O001000010004563O000900010004563O00E82O010004563O000200012O00713O00017O00D13O00028O00025O00C06F40025O00B2A940026O00F03F025O00B8A740025O002CA440025O002EA540025O00088640025O0094A340025O004CAA4003063O00A5188AF7D94103073O00D2E448C6A1B833030A3O00045DD12F41CB2446FF1C03063O00AE562993701303073O000A4BCD2930091703083O00CB3B60ED6B456F71025O00C05E40025O0050874003063O00052680D730E203073O00B74476CC815190030A3O003CB952DB39871CA27CE803063O00E26ECD10846B03093O00C9D1EFD845F8CAE4DC03053O00218BA380B9025O00E06F40026O00834003063O00766828E8564A03043O00BE373864030A3O0064BB1E2O21E6E159A33003073O009336CF5C7E738303063O0042752O66557003093O0042726F616473696465030F3O002F242774087A4D0527780C6D18233003063O001E6D51551D6D025O005CB140025O00F08B40025O001CAF40025O00F8A64003063O00DE41788037CC03073O009C9F1134D656BE030A3O009CFB9F839CEAAFB3A2E303043O00DCCE8FDD030E3O004275726965645472656173757265025O00809540025O00388240030B3O00A16F2C19DC8CFF8371281203073O00B2E61D4D77B8AC03063O00D48E262D76EA03063O009895DE6A7B17030A3O00EF32D47C87D834F94FB903053O00D5BD469623030A3O004772616E644D656C2O6503143O007C5E6104431575064B15571A4046670A405B711B03043O00682F3514025O00F6A240025O002EA34003063O00827CAD2ABD1D03063O006FC32CE17CDC030A3O00EA52224C99AECA490C7F03063O00CBB8266013CB03123O00536B752O6C616E6443726F2O73626F6E657303123O000B666D49C23C606A01FE2B767A48DD307C7703053O00AE59131921025O009EAD40025O004CB24003063O000E227E78F69503073O006B4F72322E97E7030A3O000BB29716B83CA5CF35AA03083O00A059C6D549EA59D703113O00527574686C652O73507265636973696F6E025O0082AA40025O0052A540030C3O007C63A1FB856A74B5ECCC467603053O00A52811D49E025O00DEA640025O00388E4003063O00C4E9240527F703053O004685B96853030A3O0036516615FB01574B26C503053O00A96425244A030B3O005472756542656172696E67025O00B88340025O00E2A640025O004FB040027O004003083O0042752O66446F776E03063O005A0C9376B0C903083O00C51B5CDF20D1BB11030A3O00314BE1C4315AD1F40F5303043O009B633FA32O01025O00E8B140025O00789D4003093O00A1C3A08EB2978ADEB503063O00E4E2B1C1EDD9030B3O004973417661696C61626C6503113O001CB927E231BE0CF624BF31F221BE2AF22D03043O008654D04303073O0048617354696572026O003F40026O00104003113O003BA5825816A2A94C03A3944806A28F480A03043O003C73CCE603113O00CF33EF74E234C460F735F964F234E264FE03043O0010875A8B025O00507540025O00E8AE4003063O0075442A054F4603073O0018341466532E34030A3O00F63B031B3DC13D2E282O03053O006FA44F4144025O004C9040025O00D0A140025O00EAB240025O00689740025O00D88440025O00C05140025O00809440025O0056B340025O0082B140025O00D2A54003063O0021B78E66019503043O003060E7C2030A3O00FA4E2C122BDDBD8CC45603083O00E3A83A6E4D79B8CF0100025O00408A40025O00EC9240025O0093B140025O00C09840026O000840025O00F8AC40025O007DB040025O00888140025O00A7B14003063O001CE496EB765C03083O00325DB4DABD172E47030A3O00ECB0797376D95AD1A85703073O0028BEC43B2C24BC03063O001D75F082FB6F03073O006D5C25BCD49A1D03093O0036FB86FC134F02E9B703063O003A648FC4A35103063O00344D31AE3E4503083O006E7A2243C35F298503063O005481777CD76703053O00B615D13B2A03093O008543E72203ABB151D603063O00DED737A57D4103064O00DEC81DF7D303083O002A4CB1A67A92A18D026O001440030A3O0052744252656D61696E73025O0080434003063O0084BA29F8786403063O0016C5EA65AE19030A3O001F2087E344AAC589213803083O00E64D54C5BC16CFB703113O0046696C746572656454696D65546F44696503013O003C026O00284003183O00426F2O7346696C7465726564466967687452656D61696E73025O00288540025O00689640025O00C0AC40025O00307E4003063O00D824EACA8DB303083O00559974A69CECC190030A3O0096F46F8CD605B6EF41BF03063O0060C4802DD384025O0016A640025O00549640025O00F2A840025O00F8A340025O008AA440025O00707E40025O0044A840025O0044B340025O0014B140025O00B2A640025O00B89140025O0008804003093O00E5CB82DD25F9CED69703063O008AA6B9E3BE4E030E3O004C6F616465644469636542752O6603113O00E37DC133572D36DB64CA25463617C260DC03073O0079AB14A5573243025O00049340025O00707F4003063O00E7089500B81003063O0062A658D956D9030A3O00C4E25B3EB4D9E4F9750D03063O00BC2O961961E603093O00F99B5E0107FED2864B03063O008DBAE93F626C03113O00D9E328B220FFC53CA62AE3FE39B82CE5F303053O0045918A4CD6025O00907B40025O0007B340025O00D2AA40025O00ECA34003063O0051FFA5BFBE0403063O007610AF2OE9DF030A3O00B9901784DC8E6F84883903073O001DEBE455DB8EEB03063O0014BD5769D3BD03083O00B855ED1B3FB2CFD4030A3O003A4D2B603A5C1B50045503043O003F68396900D9022O0012153O00014O00582O0100023O0026283O0006000100010004563O00060001002E6400030009000100020004563O00090001001215000100014O0058010200023O0012153O00043O002EDE00060002000100050004563O00020001000E5A0004000F00013O0004563O000F0001002E6400070002000100080004563O0002000100262800010013000100010004563O00130001002E64000A000F000100090004563O000F0001001215000200013O0026B000020014000100010004563O001400012O004601036O003B010400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400062O000300C7020100010004563O00C702012O0046010300024O00D6000400013O00122O0005000F3O00122O000600106O00040006000200062O0003002C000100040004563O002C0001002EDE00120040000100110004563O004000012O004601036O002B010400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O000500036O00050001000200262O0005003D000100010004563O003D00012O0014010500013O0006180105003E000100010004563O003E00012O001401056O00910003000400050004563O00C702012O0046010300024O00D6000400013O00122O000500173O00122O000600186O00040006000200062O00030049000100040004563O00490001002EDE001A0060000100190004563O006000012O004601036O0087000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000400013O00122O0005001D3O00122O0006001E6O0004000600024O000500043O00202O00050005001F4O000700053O00202O0007000700204O00050007000200062O0005005D000100010004563O005D00012O0014010500013O0006180105005E000100010004563O005E00012O001401056O00910003000400050004563O00C702012O0046010300024O00D6000400013O00122O000500213O00122O000600226O00040006000200062O0003006B000100040004563O006B0001002E330123006B000100240004563O006B0001002E6400250082000100260004563O008200012O004601036O0087000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000400013O00122O000500293O00122O0006002A6O0004000600024O000500043O00202O00050005001F4O000700053O00202O00070007002B4O00050007000200062O0005007F000100010004563O007F00012O0014010500013O00061801050080000100010004563O008000012O001401056O00910003000400050004563O00C70201002EDE002D00A20001002C0004563O00A200012O0046010300024O00E3000400013O00122O0005002E3O00122O0006002F6O00040006000200062O000300A2000100040004563O00A200012O004601036O0087000400013O00122O000500303O00122O000600316O0004000600024O0003000300044O000400013O00122O000500323O00122O000600336O0004000600024O000500043O00202O00050005001F4O000700053O00202O0007000700344O00050007000200062O0005009F000100010004563O009F00012O0014010500013O000618010500A0000100010004563O00A000012O001401056O00910003000400050004563O00C702012O0046010300024O00D6000400013O00122O000500353O00122O000600366O00040006000200062O000300AB000100040004563O00AB0001002E8600370019000100380004563O00C200012O004601036O0087000400013O00122O000500393O00122O0006003A6O0004000600024O0003000300044O000400013O00122O0005003B3O00122O0006003C6O0004000600024O000500043O00202O00050005001F4O000700053O00202O00070007003D4O00050007000200062O000500BF000100010004563O00BF00012O0014010500013O000618010500C0000100010004563O00C000012O001401056O00910003000400050004563O00C702012O0046010300024O00D6000400013O00122O0005003E3O00122O0006003F6O00040006000200062O000300CB000100040004563O00CB0001002EDE004100E2000100400004563O00E200012O004601036O0087000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O000400013O00122O000500443O00122O000600456O0004000600024O000500043O00202O00050005001F4O000700053O00202O0007000700464O00050007000200062O000500DF000100010004563O00DF00012O0014010500013O000618010500E0000100010004563O00E000012O001401056O00910003000400050004563O00C70201002E64004800EB000100470004563O00EB00012O0046010300024O00D6000400013O00122O000500493O00122O0006004A6O00040006000200062O000300ED000100040004563O00ED0001002E64004B00042O01004C0004563O00042O012O004601036O0087000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O000400013O00122O0005004F3O00122O000600506O0004000600024O000500043O00202O00050005001F4O000700053O00202O0007000700514O00050007000200062O0005003O0100010004563O003O012O0014010500013O000618010500022O0100010004563O00022O012O001401056O00910003000400050004563O00C70201001215000300014O0058010400043O0026B0000300062O0100010004563O00062O01001215000400013O0026280004000D2O0100040004563O000D2O01002EDE005300802O0100520004563O00802O01002E8600540022000100540004563O002F2O012O0046010500034O00260105000100020026480105002F2O0100550004563O002F2O012O0046010500043O00205000050005001F4O000700053O00202O00070007002B4O00050007000200062O0005002F2O013O0004563O002F2O012O0046010500043O0020500005000500564O000700053O00202O0007000700344O00050007000200062O0005002F2O013O0004563O002F2O012O0046010500063O0026E80005002F2O0100550004563O002F2O012O004601056O002C010600013O00122O000700573O00122O000800586O0006000800024O0005000500064O000600013O00122O000700593O00122O0008005A6O00060008000200202O00050006005B002EDE005D00722O01005C0004563O00722O012O0046010500054O001A010600013O00122O0007005E3O00122O0008005F6O0006000800024O00050005000600202O0005000500604O00050002000200062O000500722O013O0004563O00722O012O0046010500054O001A010600013O00122O000700613O00122O000800626O0006000800024O00050005000600202O0005000500604O00050002000200062O000500722O013O0004563O00722O012O0046010500043O00201700050005006300122O000700643O00122O000800656O00050008000200062O000500722O0100010004563O00722O012O0046010500043O0020EF00050005001F4O000700053O00202O0007000700514O00050007000200062O0005005D2O0100010004563O005D2O012O0046010500054O0055000600013O00122O000700663O00122O000800676O0006000800024O00050005000600202O0005000500604O00050002000200062O0005006E2O0100010004563O006E2O012O0046010500043O0020EF00050005001F4O000700053O00202O0007000700204O00050007000200062O000500722O0100010004563O00722O012O0046010500054O0055000600013O00122O000700683O00122O000800696O0006000800024O00050005000600202O0005000500604O00050002000200062O000500722O0100010004563O00722O012O0046010500034O002601050001000200261F010500742O0100040004563O00742O01002EDE006B007F2O01006A0004563O007F2O012O004601056O002C010600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000600013O00122O0007006E3O00122O0008006F6O00060008000200202O00050006005B001215000400553O002628000400862O0100010004563O00862O01002E33017100862O0100700004563O00862O01002E64007200AE2O0100730004563O00AE2O01001215000500013O0026280005008D2O0100010004563O008D2O01002E030174008D2O0100750004563O008D2O01002EDE007700A72O0100760004563O00A72O01001215000600013O002628000600922O0100010004563O00922O01002EDE007800A02O0100790004563O00A02O012O004601076O002C010800013O00122O0009007A3O00122O000A007B6O0008000A00024O0007000700084O000800013O00122O0009007C3O00122O000A007D6O0008000A000200202O00070008007E2O0046010700034O004C000700010001001215000600043O002628000600A42O0100040004563O00A42O01002E86007F00ECFF2O00800004563O008E2O01001215000500043O0004563O00A72O010004563O008E2O01002EDE008200872O0100810004563O00872O010026B0000500872O0100040004563O00872O01001215000400043O0004563O00AE2O010004563O00872O010026B000040017020100830004563O00170201002E64008400F92O0100850004563O00F92O01002EDE008600F92O0100870004563O00F92O012O004601056O003B010600013O00122O000700883O00122O000800896O0006000800024O0005000500064O000600013O00122O0007008A3O00122O0008008B6O0006000800024O00050005000600062O000500EE2O0100010004563O00EE2O012O004601056O008F000600013O00122O0007008C3O00122O0008008D6O0006000800024O0005000500064O000600013O00122O0007008E3O00122O0008008F6O0006000800024O0005000500062O00D0000600013O00122O000700903O00122O000800916O0006000800024O0005000500060026B0000500F92O0100010004563O00F92O012O004601056O00E6000600013O00122O000700923O00122O000800936O0006000800024O0005000500064O000600013O00122O000700943O00122O000800956O0006000800024O0005000500064O000600013O00122O000700963O00122O000800976O0006000800024O000500050006000E2O000400F92O0100050004563O00F92O012O0046010500034O00260105000100020026E8000500F92O0100980004563O00F92O012O0046010500073O00201D0005000500992O0026010500010002002648010500F92O01009A0004563O00F92O012O004601056O002C010600013O00122O0007009B3O00122O0008009C6O0006000800024O0005000500064O000600013O00122O0007009D3O00122O0008009E6O00060008000200202O00050006005B2O0046010500083O00201700050005009F00122O000700A03O00122O000800A16O00050008000200062O0005000B020100010004563O000B02012O0046010500093O0020B30005000500A200122O000600A03O00122O000700A16O00050007000200062O0005000B020100010004563O000B0201002EF800A3000B020100A40004563O000B0201002E6400A500C7020100A60004563O00C702012O004601056O002C010600013O00122O000700A73O00122O000800A86O0006000800024O0005000500064O000600013O00122O000700A93O00122O000800AA6O00060008000200202O00050006007E0004563O00C70201002E8600AB00F2FE2O00AB0004563O00092O010026B0000400092O0100550004563O00092O01001215000500014O0058010600063O002E6400AC001D020100AD0004563O001D0201002E8600AE00FEFF2O00AE0004563O001D02010026B00005001D020100010004563O001D0201001215000600013O002EDE00B0002A020100AF0004563O002A02010026B00006002A020100040004563O002A0201001215000400833O0004563O00092O0100262800060030020100010004563O00300201002E3301B20030020100B10004563O00300201002EDE00B30024020100B40004563O00240201002EDE00B6007A020100B50004563O007A02012O0046010700054O001A010800013O00122O000900B73O00122O000A00B86O0008000A00024O00070007000800202O0007000700604O00070002000200062O0007006D02013O0004563O006D02012O0046010700043O00209800070007006300122O000900643O00122O000A00656O0007000A000200062O0007006D02013O0004563O006D02012O0046010700034O00600007000100024O0008000A3O00122O000900046O000A000B6O000B00043O00202O000B000B001F4O000D00053O00202O000D000D00B94O000B000D6O000A6O00C300083O00022O00240009000C3O00122O000A00046O000B000B6O000C00043O00202O000C000C001F4O000E00053O00202O000E000E00B94O000C000E6O000B8O00093O00022O00780008000800090006940007006D020100080004563O006D02012O0046010700054O0055000800013O00122O000900BA3O00122O000A00BB6O0008000A00024O00070007000800202O0007000700604O00070002000200062O0007006F020100010004563O006F02012O0046010700043O0020EF0007000700564O000900053O00202O0009000900204O00070009000200062O0007006F020100010004563O006F0201002E6400BC007A020100BD0004563O007A02012O004601076O002C010800013O00122O000900BE3O00122O000A00BF6O0008000A00024O0007000700084O000800013O00122O000900C03O00122O000A00C16O0008000A000200202O00070008005B2O0046010700054O0055000800013O00122O000900C23O00122O000A00C36O0008000A00024O00070007000800202O0007000700604O00070002000200062O000700B1020100010004563O00B102012O0046010700054O001A010800013O00122O000900C43O00122O000A00C56O0008000A00024O00070007000800202O0007000700604O00070002000200062O000700B102013O0004563O00B102012O0046010700043O0020EF00070007001F4O000900053O00202O00090009003D4O00070009000200062O000700B1020100010004563O00B102012O0046010700034O00060007000100024O0008000A3O00122O000900556O000A000B6O000B00043O00202O000B000B001F4O000D00053O00202O000D000D00344O000B000D6O000A8O00083O00024O0009000C3O00122O000A00556O000B000B6O000C00043O00202O000C000C001F4O000E00053O00202O000E000E00344O000C000E6O000B8O00093O00024O00080008000900062O000700B1020100080004563O00B102012O0046010700063O002661000700B5020100550004563O00B50201002E3301C700B5020100C60004563O00B50201002E8600C8000D000100C90004563O00C002012O004601076O002C010800013O00122O000900CA3O00122O000A00CB6O0008000A00024O0007000700084O000800013O00122O000900CC3O00122O000A00CD6O0008000A000200202O00070008005B001215000600043O0004563O002402010004563O00092O010004563O001D02010004563O00092O010004563O00C702010004563O00062O012O004601036O008F000400013O00122O000500CE3O00122O000600CF6O0004000600024O0003000300044O000400013O00122O000500D03O00122O000600D16O0004000600024O0003000300042O0044010300023O0004563O001400010004563O00D802010004563O000F00010004563O00D802010004563O000200012O00713O00017O00063O00030A3O0043504D61785370656E64026O00F03F03093O00537465616C7468557003093O002895A5470094AC4B1F03043O00246BE7C4030B3O004973417661696C61626C65001D4O0047019O000100013O00202O0001000100014O00010001000200202O0001000100024O000200026O000300033O00204C0103000300034O000500016O000600016O00030006000200062O0003001500013O0004563O001500012O0046010300044O00F6000400053O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300064O0003000200022O006C0002000200022O008A00010001000200063B0001000200013O0004563O001A00012O00F08O0014012O00014O0044012O00024O00713O00017O00093O0003113O0075BCA68358BB8D974DBAB09348BBAB934403043O00E73DD5C2030B3O004973417661696C61626C65030E3O0020A02D6106BB387728A03F661AA503043O001369CD5D027O004003063O0042752O66557003093O0042726F616473696465026O004940003D4O0036019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O0036000100010004563O003600012O0046012O00024O004B000100036O000200046O00038O000400013O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300034O000300046O00023O000200102O0002000600024O000300046O000400053O00202O0004000400074O00065O00202O0006000600084O000400066O00038O00013O00024O000200066O000300046O00048O000500013O00122O000600043O00122O000700056O0005000700024O00040004000500202O0004000400034O000400056O00033O000200102O0003000600034O000400046O000500053O00202O0005000500074O00075O00202O0007000700084O000500076O00048O00023O00024O00010001000200062O0001003900013O0004563O003900012O0046012O00073O000ED50009003A00013O0004563O003A00012O00F08O0014012O00014O0044012O00024O00713O00017O00073O00027O0040030B3O0042752O6652656D61696E73030B3O00426C616465466C752O7279026O00F03F030C3O008201D28D36A70FED912DAC0D03053O005FC968BEE1030B3O004973417661696C61626C65002C4O0046016O000625012O002900013O0004563O002900012O0046012O00013O0026613O0029000100010004563O002900012O0046012O00023O0020345O00024O000200033O00202O0002000200036O000200024O000100043O00122O000200046O000300056O000400036O000500063O00122O000600053O001215000700064O00400005000700024O00040004000500202O0004000400074O000400056O00038O00013O00024O000200073O00122O000300046O000400056O000500034O00D0000600063O00122O000700053O00122O000800066O0006000800024O0005000500060020F30005000500074O000500066O00048O00023O00024O00010001000200062O0001002900013O0004563O002900012O00F08O0014012O00014O0044012O00024O00713O00017O00013O0003093O00497354616E6B696E67000F4O0046016O000625012O000D00013O0004563O000D00012O0046012O00013O0020F55O00012O0046010200024O002A012O00020002000625012O000C00013O0004563O000C00012O0046012O00033O0004563O000D00012O00F08O0014012O00014O0044012O00024O00713O00017O000E3O0003113O009CC3C0CAA0DCE5CFA1C8C4FAAEC7C4C0BB03043O00AECFABA1030B3O004973417661696C61626C65030C3O00CBFF03C7F0D2C5FF00FEFDC503063O00B78D9E6D9398030A3O0054616C656E7452616E6B03093O001D1CEF0F272DF40D3B03043O006C4C698603083O00CAD0B5E0CDE2D1A803053O00AE8BA5D181030C3O0080BCF7CFD237787D8CB7E6D203083O0018C3D382A1A66310030D3O006D06EC3C7A02740CE5205A184103063O00762663894C33007C4O0036019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O0078000100010004563O007800012O0046012O00024O00DA00018O000200013O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O0001000200024O000200036O00038O000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300034O000300046O00023O00024O0001000100024O000200036O00038O000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O0003000300034O000300046O00029O003O00024O000100046O00028O000300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O0002000200024O000300036O00048O000500013O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400034O000400056O00033O00024O0002000200034O000300036O00048O000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O0004000400034O000400056O00038O00013O00028O00014O000100026O000200036O00038O000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O0003000300034O000300046O00023O00024O000300036O00048O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400050020F40004000400034O000400056O00038O00013O00024O000200046O000300036O00048O000500013O00122O0006000B3O00122O0007000C4O002A0105000700022O004300040004000500202O0004000400034O000400056O00033O00024O000400036O00058O000600013O00122O0007000D3O00122O0008000E6O0006000800022O000D0005000500060020F30005000500034O000500066O00048O00023O00024O00010001000200064O0079000100010004563O007900012O00F08O0014012O00014O0044012O00024O00713O00017O000E3O0003063O0042752O665570030E3O00426574772O656E7468654579657303113O00D52F01160C2ED236151D1B34E8280C061003063O00409D46657269030B3O004973417661696C61626C6503083O0042752O66446F776E030C3O00417564616369747942752O66030C3O00662OA9D7184580A6EE1D45BA03053O007020C8C783030A3O0054616C656E7452616E6B027O0040030B3O004F2O706F7274756E69747903093O000F425DBBC8B82A234403073O00424C303CD8A3CB00344O0046016O0020505O00014O000200013O00202O0002000200026O0002000200064O003200013O0004563O003200012O0046012O00014O001A2O0100023O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O002900013O0004563O002900012O0046016O0020505O00064O000200013O00202O0002000200076O0002000200064O003200013O0004563O003200012O0046012O00014O00282O0100023O00122O000200083O00122O000300096O0001000300028O000100206O000A6O0002000200264O00290001000B0004563O002900012O0046016O0020505O00064O000200013O00202O00020002000C6O0002000200064O003200013O0004563O003200012O0046012O00014O0052000100023O00122O0002000D3O00122O0003000E6O0001000300028O000100206O00056O000200029O002O0044012O00024O00713O00017O007A3O00028O00025O00707940025O00349F40027O0040030B3O00E57D28A7E89B8817D8762C03083O0076B61549C387ECCC030B3O004973417661696C61626C65030B3O003B341B440B1AD90932194503073O009D685C7A20646D030A3O0049734361737461626C65030D3O0088A3CADA1433BFA4AFAAC6C43A03083O00CBC3C6AFAA5D47ED030D3O00054E3BC57805CE214732DC5F1603073O009C4E2B5EB53171030F3O00432O6F6C646F776E52656D61696E73026O003E40030D3O0059EDC1B322574B7DE4C8AA054403073O00191288A4C36B23026O005E4003113O00C024AD4B77B2EEA8F822BB5B67B2C8ACF103083O00D8884DC92F12DCA103043O0043617374030B3O00536861646F7744616E6365025O00BC9640025O0032A04003113O000EED38CE48EF8A2CE824CD48F88323EF2E03073O00E24D8C4BBA68BC025O004EAD40025O00D88640030A3O008AC6D13B40AEC3D5334B03053O002FD9AEB05F030A3O008BD57706BD437523B4D903083O0046D8BD1662D2341803073O0049735265616479025O0022AB40025O00E2B140025O00AEA340025O00F2A84003093O00F9CDA284D8C9D7AC9303053O00B3BABFC3E703093O00DA2D19E7F22C10EBED03043O0084995F78030C3O0092BD1B23E3EEA8B49D0A29E403073O00C0D1D26E4D97BA03113O00C80A26EDFACACF1332E6EDD0F50D2BFDE603063O00A4806342899F025O00A6A340025O00309C40025O0080A740025O00109E40030A3O00536861646F776D656C64030F3O002388FAAA40BAE1BF0486FEB30585ED03043O00DE60E989025O00707240025O00F07C40025O0049B34003063O008C8777FA4CC603073O0044DAE619933FAE03063O009B2B5D452OA503053O00D6CD4A332C03113O00D245E6F872F463F2EC78E858F7F27EEE5503053O00179A2C829C03093O0032B4ACAD3D0019A9B903063O007371C6CDCE5603063O0042752O66557003083O00417564616369747903093O0042752O66537461636B030B3O004F2O706F7274756E697479026O001840025O002EAF40025O005CAD4003063O0056616E69736803103O00A756ED4EC461FF548D44F61ACC7FD11303043O003AE4379E03063O008288DE272FA503073O0055D4E9B04E5CCD03063O007C5986EB595003043O00822A38E803113O00C2BC20E74531C5A534EC522BFFBB2DF75903063O005F8AD544832003093O00093AA0407D3920AE5703053O00164A48C12303143O000F78F74C6C4FE556256AEC18645FED56256AEC1103043O00384C1984026O00F03F025O0023B140025O00F8A140025O00DCB240025O00F49A40025O00CDB040025O00C8A440025O00D89840025O000AA840030B3O006DC9AA22C049E5AA28CC5B03053O00AF3EA1CB46030B3O000FD5C2173A2BF9C21D363903053O00555CBDA37303093O000ABE313B22BF38373D03043O005849CC50025O000BB040025O0014904003113O000D82035269E9268214493E9A0A821E452C03063O00BA4EE3702649030B3O00CF5FFC515C6DD856F32O5603063O001A9C379D3533030B3O00BFD017DDB747A8D918DABD03063O0030ECB876B9D8030D3O00CEB85220E620D7B25B3CC63AE203063O005485DD3750AF030C3O00536C696365616E644469636503113O0095EE20A2C25292F734A9D548A8E92DB2DE03063O003CDD8744C6A703113O00C6B4FC8747D7C1ADE88C50CDFBB3F1975B03063O00B98EDD98E32203063O006EC459F3503B03073O009738A5379A2353025O0069B040025O00CCA040025O0008A840025O003AB24003113O00834216FAE0700DEFA44C12AE84420BEDA503043O008EC0236500F3012O0012153O00013O002E64000200B4000100030004563O00B400010026B03O00B4000100040004563O00B400012O00462O016O001A010200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001005800013O0004563O005800012O00462O016O001A010200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001005800013O0004563O005800012O00462O016O001A010200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001005800013O0004563O005800012O00462O0100024O00262O01000100020006252O01005800013O0004563O005800012O00462O016O00F6000200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O00010001000F4O00010002000200261F2O010049000100100004563O004900012O00462O016O007C000200013O00122O000300113O00122O000400126O0002000400024O00010001000200202O00010001000F4O000100020002000E2O00130058000100010004563O005800012O00462O0100034O00262O01000100020006182O010049000100010004563O004900012O00462O016O001A010200013O00122O000300143O00122O000400156O0002000400024O00010001000200202O0001000100074O00010002000200062O0001005800013O0004563O005800012O00462O0100043O0020172O01000100164O00025O00202O0002000200174O000300056O00010003000200062O00010053000100010004563O00530001002E6400190058000100180004563O005800012O00462O0100013O0012150002001A3O0012150003001B4O006A000100034O00512O015O002EDE001D006E0001001C0004563O006E00012O00462O016O001A010200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001006E00013O0004563O006E00012O00462O016O0055000200013O00122O000300203O00122O000400216O0002000400024O00010001000200202O0001000100224O00010002000200062O00010070000100010004563O00700001002EDE002400F22O0100230004563O00F22O01002EDE002500F22O0100260004563O00F22O012O00462O016O001A010200013O00122O000300273O00122O000400286O0002000400024O00010001000200202O0001000100074O00010002000200062O0001008000013O0004563O008000012O00462O0100034O00262O01000100020006182O0100A4000100010004563O00A400012O00462O016O0055000200013O00122O000300293O00122O0004002A6O0002000400024O00010001000200202O0001000100074O00010002000200062O000100A2000100010004563O00A200012O00462O016O001A010200013O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200202O0001000100074O00010002000200062O0001009800013O0004563O009800012O00462O0100034O00262O01000100020006182O0100A4000100010004563O00A400012O00462O016O0055000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200202O0001000100074O00010002000200062O000100A4000100010004563O00A40001002EDE002F00F22O0100300004563O00F22O01002EDE003200F22O0100310004563O00F22O012O00462O0100043O0020AC0001000100164O00025O00202O0002000200334O000300066O00010003000200062O000100F22O013O0004563O00F22O012O00462O0100013O001289000200343O00122O000300356O000100036O00015O00044O00F22O010026B03O00532O0100010004563O00532O01001215000100013O002E8600360004000100360004563O00BB0001002628000100BD000100010004563O00BD0001002E640038004C2O0100370004563O004C2O012O004601026O001A010300013O00122O000400393O00122O0005003A6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200FF00013O0004563O00FF00012O004601026O001A010300013O00122O0004003B3O00122O0005003C6O0003000500024O00020002000300202O0002000200224O00020002000200062O000200FF00013O0004563O00FF00012O0046010200074O0026010200010002000625010200FF00013O0004563O00FF00012O004601026O001A010300013O00122O0004003D3O00122O0005003E6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200FF00013O0004563O00FF00012O004601026O0055000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300202O0002000200074O00020002000200062O000200FF000100010004563O00FF00012O0046010200083O0020EF0002000200414O00045O00202O0004000400424O00020004000200062O000200FF000100010004563O00FF00012O0046010200094O0026010200010002000618010200FB000100010004563O00FB00012O0046010200083O0020590102000200434O00045O00202O0004000400444O00020004000200262O000200FF000100450004563O00FF00012O00460102000A4O00260102000100020006180102003O0100010004563O003O01002E640046000E2O0100470004563O000E2O012O0046010200043O0020AC0002000200164O00035O00202O0003000300484O0004000B6O00020004000200062O0002000E2O013O0004563O000E2O012O0046010200013O001215000300493O0012150004004A4O006A000200044O005101026O004601026O001A010300013O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002004B2O013O0004563O004B2O012O004601026O001A010300013O00122O0004004D3O00122O0005004E6O0003000500024O00020002000300202O0002000200224O00020002000200062O0002004B2O013O0004563O004B2O012O0046010200074O00260102000100020006250102004B2O013O0004563O004B2O012O004601026O001A010300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200074O00020002000200062O0002003A2O013O0004563O003A2O012O004601026O001A010300013O00122O000400513O00122O000500526O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004B2O013O0004563O004B2O012O0046010200034O00260102000100020006250102004B2O013O0004563O004B2O012O0046010200043O0020AC0002000200164O00035O00202O0003000300484O0004000B6O00020004000200062O0002004B2O013O0004563O004B2O012O0046010200013O001215000300533O001215000400544O006A000200044O005101025O001215000100553O002628000100502O0100550004563O00502O01002E64005600B7000100570004563O00B700010012153O00553O0004563O00532O010004563O00B70001002E6400590001000100580004563O00010001000E210055000100013O0004563O00010001001215000100013O0026280001005C2O0100550004563O005C2O01002E86005A00040001005B0004563O005E2O010012153O00043O0004563O00010001002E64005C00582O01005D0004563O00582O010026B0000100582O0100010004563O00582O012O004601026O001A010300013O00122O0004005E3O00122O0005005F6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200842O013O0004563O00842O012O004601026O001A010300013O00122O000400603O00122O000500616O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200842O013O0004563O00842O012O004601026O001A010300013O00122O000400623O00122O000500636O0003000500024O00020002000300202O0002000200074O00020002000200062O000200842O013O0004563O00842O012O0046010200034O0026010200010002000618010200862O0100010004563O00862O01002E64006400932O0100650004563O00932O012O0046010200043O0020AC0002000200164O00035O00202O0003000300174O000400056O00020004000200062O000200932O013O0004563O00932O012O0046010200013O001215000300663O001215000400674O006A000200044O005101026O004601026O001A010300013O00122O000400683O00122O000500696O0003000500024O00020002000300202O0002000200074O00020002000200062O000200DE2O013O0004563O00DE2O012O004601026O001A010300013O00122O0004006A3O00122O0005006B6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200DE2O013O0004563O00DE2O012O004601026O0055000300013O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200DE2O0100010004563O00DE2O012O0046010200024O0026010200010002000625010200DE2O013O0004563O00DE2O012O0046010200083O0020500002000200414O00045O00202O00040004006E4O00020004000200062O000200DE2O013O0004563O00DE2O012O0046010200034O0026010200010002000618010200CA2O0100010004563O00CA2O012O004601026O001A010300013O00122O0004006F3O00122O000500706O0003000500024O00020002000300202O0002000200074O00020002000200062O000200DE2O013O0004563O00DE2O012O004601026O001A010300013O00122O000400713O00122O000500726O0003000500024O00020002000300202O0002000200074O00020002000200062O000200E02O013O0004563O00E02O012O004601026O001A010300013O00122O000400733O00122O000500746O0003000500024O00020002000300202O0002000200224O00020002000200062O000200E02O013O0004563O00E02O01002EDE007500EF2O0100760004563O00EF2O012O0046010200043O0020170102000200164O00035O00202O0003000300174O000400056O00020004000200062O000200EA2O0100010004563O00EA2O01002E64007800EF2O0100770004563O00EF2O012O0046010200013O001215000300793O0012150004007A4O006A000200044O005101025O001215000100553O0004563O00582O010004563O000100012O00713O00017O00113O00028O00025O00AC9F40025O00ACA740025O005AA940025O00DCAB4003103O0048616E646C65546F705472696E6B6574026O004440025O0086A440025O00D07740026O00F03F025O00B07140025O00C0B140025O00CC9C40025O0048AE4003133O0048616E646C65426F2O746F6D5472696E6B6574025O006BB240025O0018924000353O0012153O00014O00582O0100013O0026283O0006000100010004563O00060001002E6400030002000100020004563O00020001001215000100013O002E640004001B000100050004563O001B00010026B00001001B000100010004563O001B00012O0046010200013O00202E0102000200064O000300026O000400033O00122O000500076O000600066O0002000600024O00028O00025O00062O00020018000100010004563O00180001002E640008001A000100090004563O001A00012O004601026O0044010200023O0012150001000A3O002EDE000B001F0001000C0004563O001F0001002628000100210001000A0004563O00210001002E86000D00E8FF2O000E0004563O000700012O0046010200013O00206200020002000F4O000300026O000400033O00122O000500076O000600066O0002000600024O00025O002E2O00110034000100100004563O003400012O004601025O0006250102003400013O0004563O003400012O004601026O0044010200023O0004563O003400010004563O000700010004563O003400010004563O000200012O00713O00017O00E03O00028O00025O00508340025O00D8AD40025O00149F40025O00BFB040026O005F40027O0040026O00F03F025O00B4A840025O0007B040025O0012A440025O009CAE40030A3O003A7B3158AE0A752A45AC03053O00CB781E432B030A3O0049734361737461626C65025O005EA940025O0030B140025O0062AD40025O0072A54003043O0043617374030A3O004265727365726B696E67025O00A4A840025O00B89F40030F3O00D2245EFB99D3205FFCDCE32E44E1DE03053O00B991452D8F03093O00AC160BA3DE861016A203053O00BCEA7F79C6025O00508540025O00208840025O0050B040025O002OA040025O00208A4003093O0046697265626C2O6F64030E3O001B33009778141A913D301F8C373603043O00E3585273025O0072A240025O009C9040025O00F89B40025O002AA940030A3O00E7B12614C7B52A33D6B803043O0067B3D94F030B3O004973417661696C61626C65030A3O007EBF15C65580A67EB21D03073O00C32AD77CB521EC03063O0042752O665570030A3O0054686973746C65546561026O00594003183O00426F2O7346696C7465726564466967687452656D61696E7303013O003C030A3O0039513E2D31F4086D323F03063O00986D39575E4503073O0043686172676573026O00184003103O00DAD619B7FEE65CA1EAC306A6FEE651A903083O00C899B76AC3DEB234025O006BB140025O0016AE4003093O0010EF87324D7C27F19103063O003A5283E85D2903093O00426C2O6F6446757279025O0032A740025O00109D40030F3O00A056C3012O1D8F58DF111D199645C903063O005FE337B0753D025O009CA540025O00708440026O000840025O00DBB240025O0084A240025O0096A040025O0080434003093O0064C7F2ED79DD53D8FB03063O008F26AB93891C03073O0049735265616479026O00104003093O00537465616C7468557003093O00426C61646552757368025O00A8A040025O00206940025O006CA340025O0046A640030F3O00F383AAE743C1D8D186BCB331F6C7D803073O00B4B0E2D9936383025O00F2B040025O007DB140025O0020AF40025O00749940025O00109B40025O00B2AB40025O0052A340025O005EAA40030D3O00C10C2E2A580B63D5103330470203073O001A866441592C67030D3O00D6EB3F30B0FDFA0337B6F8E83503053O00C491835043025O0016B340025O00CC9E40030D3O0047686F73746C79537472696B6503133O003DB1151C58CF16BF151C14F15E83121A11E31B03063O00887ED066687803063O004B8FDE50A64103083O003118EAAE23CF325D03063O003FF7ED9B781F03053O00116C929DE803093O0068D115EE24BB43CC0003063O00C82BA3748D4F030E3O009D332994B5F1EDAB3E38A6A9F1F003073O0083DF565DE3D09403093O00C057B7B516A6EB4AA203063O00D583252OD67D03113O0046696C746572656454696D65546F44696503013O003E026O002640030E3O00426574772O656E74686545796573025O0044A440025O00589640025O00CDB240025O00C1B140025O00949140026O00504003063O00536570736973030B3O00052A36ABA1152E35ACE83503053O0081464B45DF025O001EA940025O004AAF40025O0033B340025O001DB340025O002FB040025O00DEA240025O00C88440025O001C9340025O00ACAA40030D3O006211B9A21167511EB684037F4F03063O0013237FDAC762025O00049140025O003AA140025O00207C40025O00AAA340030D3O00416E6365737472616C43612O6C03133O003FFA19F65CDA04E119E81EF01DF74AC11DF70603043O00827C9B6A025O0076A140025O00C4A040025O00A08340025O00AEAA40025O0061B140025O00949B40025O00D6B040025O00F88C40030C3O0037861C18C0475A27861E11C703073O003F65E97074B42F025O00508C40026O006940030A3O0052744252656D61696E7303073O0048617354696572026O003F40030B3O00F033EC16F721E73AE311FD03063O0056A35B8D7298030F3O00432O6F6C646F776E52656D61696E7303063O00650A2O7A295B03053O005A336B1413030C3O00526F2O6C746865426F6E6573026O00A840025O00AAA040025O0032A040025O0015B04003133O00AEF196FB7DBFFF89E37D99F880AF1F82FE80FC03053O005DED90E58F030D3O003EF3F509225227F9FC1502481203063O0026759690796B03083O0042752O66446F776E030B3O00536861646F7744616E6365025O008EA740025O003AB240025O00408C40025O00E09540030D3O004B2O65704974526F2O6C696E6703143O000EBAFD2E6D90EB3F3DFBE72E6D89E13621B2E03D03043O005A4DDB8E025O003C9040025O00AEB040025O00708640025O002EAE40025O0066A340025O005EA140025O00405F40025O0042A040030E3O0098B7B51A86F2FCB0BDA22D9DE0F803073O0090D9D3C77FE893030E3O00416472656E616C696E655275736803093O00DB3D3F2BDE560A4BEC03083O0024984F5E48B5256203163O00FED5572DD8CE423BF6DC553A2OD94B36D9DD752AC4D003043O005FB7B82703163O009C32F7345B9607B11EE334518E03B936E923669511BD03073O0062D55F874634E0025O00349D40025O0024B340025O00F49540025O00E8894003143O00DDA2DA6314DFA7DB725AFFAFC07951BE91DC645C03053O00349EC3A917030B3O0058B033708313779E68AE2B03083O00EB1ADC5214E6551B03143O00BDAFEDC76680A0E7C6718C94F9D2719AA9E8CC7003053O0014E8C189A2030B3O0042752O6652656D61696E73030B3O00426C616465466C752O7279030A3O0047434452656D61696E73030D3O0006DAC3B2CA8D197437C9C0B4F403083O001142BFA5C687EC77026O001440025O001AAA40025O00C49B40025O00E0A940030D3O004361737453752O676573746564025O00489240025O00A49D4003113O002CAEBD07BFCAE0D00BAAEE35F3FDFEC31603083O00B16FCFCE739F888C025O00C08B40025O00808740026O00AE40025O00408F400048032O0012153O00014O00582O0100013O002EDE00020002000100030004563O00020001000E210001000200013O0004563O00020001001215000100013O002E86000400BB000100040004563O00C20001002E64000600C2000100050004563O00C200010026B0000100C2000100070004563O00C20001001215000200014O0058010300033O0026B00002000F000100010004563O000F0001001215000300013O00262800030016000100080004563O00160001002E86000900490001000A0004563O005D0001001215000400013O002E64000B00560001000C0004563O005600010026B000040056000100010004563O005600012O004601056O0055000600013O00122O0007000D3O00122O0008000E6O0006000800024O00050005000600202O00050005000F4O00050002000200062O00050027000100010004563O00270001002E8600100013000100110004563O00380001002EDE00130038000100120004563O003800012O0046010500023O0020170105000500144O00065O00202O0006000600154O000700036O00050007000200062O00050033000100010004563O00330001002E6400160038000100170004563O003800012O0046010500013O001215000600183O001215000700194O006A000500074O005101056O004601056O0055000600013O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600202O00050005000F4O00050002000200062O00050044000100010004563O00440001002E64001200550001001C0004563O00550001002EDE001D00550001001E0004563O00550001002EDE002000550001001F0004563O005500012O0046010500023O0020AC0005000500144O00065O00202O0006000600214O000700036O00050007000200062O0005005500013O0004563O005500012O0046010500013O001215000600223O001215000700234O006A000500074O005101055O001215000400083O0026280004005A000100080004563O005A0001002E6400240017000100250004563O00170001001215000300073O0004563O005D00010004563O0017000100262800030061000100010004563O00610001002E64002700B9000100260004563O00B900012O0046010400043O0006250104009D00013O0004563O009D00012O004601046O001A010500013O00122O000600283O00122O000700296O0005000700024O00040004000500202O00040004002A4O00040002000200062O0004009D00013O0004563O009D00012O004601046O001A010500013O00122O0006002B3O00122O0007002C6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004009D00013O0004563O009D00012O0046010400053O0020EF00040004002D4O00065O00202O00060006002E4O00040006000200062O0004009D000100010004563O009D00012O0046010400063O000ED5002F0091000100040004563O009100012O0046010400023O0020FB00040004003000122O000500316O00068O000700013O00122O000800323O00122O000900336O0007000900024O00060006000700202O0006000600344O00060002000200202O0006000600354O00040006000200062O0004009D00013O0004563O009D00012O0046010400023O0020080004000400144O00055O00202O00050005002E4O00040002000200062O0004009D00013O0004563O009D00012O0046010400013O001215000500363O001215000600374O006A000400064O005101045O002E64003900B8000100380004563O00B800012O004601046O001A010500013O00122O0006003A3O00122O0007003B6O0005000700024O00040004000500202O00040004000F4O00040002000200062O000400B800013O0004563O00B800012O0046010400023O0020170104000400144O00055O00202O00050005003C4O000600036O00040006000200062O000400B3000100010004563O00B30001002E64003D00B80001003E0004563O00B800012O0046010400013O0012150005003F3O001215000600404O006A000400064O005101045O001215000300083O002E6400420012000100410004563O001200010026B000030012000100070004563O00120001001215000100433O0004563O00C200010004563O001200010004563O00C200010004563O000F0001000E5A000800C6000100010004563O00C60001002E86004400E7000100450004563O00AB2O01001215000200013O002628000200CB000100080004563O00CB0001002E8600460049000100470004563O00122O012O004601036O001A010400013O00122O000500483O00122O000600496O0004000600024O00030003000400202O00030003004A4O00030002000200062O000300F000013O0004563O00F000012O0046010300073O000E1C014B00F0000100030004563O00F000012O0046010300053O0020A300030003004C4O000500016O000600016O00030006000200062O000300F0000100010004563O00F000012O0046010300023O0020170103000300144O00045O00202O00040004004D4O000500086O00030005000200062O000300EB000100010004563O00EB0001002E33014E00EB0001004F0004563O00EB0001002EDE005100F0000100500004563O00F000012O0046010300013O001215000400523O001215000500534O006A000300054O005101036O0046010300053O00205E01030003004C4O000500016O000600016O000700016O00030007000200062O000300112O0100010004563O00112O01001215000300014O0058010400043O000E5A00012O002O0100030004564O002O01002E3301552O002O0100540004564O002O01002E86005600FCFF2O00570004563O00FA0001001215000400013O0026B00004003O0100010004563O003O012O00460105000A4O00260105000100022O00A2000500094O0046010500093O0006180105000B2O0100010004563O000B2O01002E64005900112O0100580004563O00112O012O0046010500094O0044010500023O0004563O00112O010004563O003O010004563O00112O010004563O00FA0001001215000200073O002628000200162O0100010004563O00162O01002EDE005B00A22O01005A0004563O00A22O012O004601036O001A010400013O00122O0005005C3O00122O0006005D6O0004000600024O00030003000400202O00030003002A4O00030002000200062O0003002A2O013O0004563O002A2O012O004601036O0055000400013O00122O0005005E3O00122O0006005F6O0004000600024O00030003000400202O00030003004A4O00030002000200062O0003002C2O0100010004563O002C2O01002E860060000F000100610004563O00392O012O0046010300023O0020AC0003000300144O00045O00202O0004000400624O0005000B6O00030005000200062O000300392O013O0004563O00392O012O0046010300013O001215000400633O001215000500644O006A000300054O005101036O0046010300043O000625010300A12O013O0004563O00A12O012O004601036O001A010400013O00122O000500653O00122O000600666O0004000600024O00030003000400202O00030003002A4O00030002000200062O000300A12O013O0004563O00A12O012O004601036O001A010400013O00122O000500673O00122O000600686O0004000600024O00030003000400202O00030003004A4O00030002000200062O000300A12O013O0004563O00A12O012O004601036O001A010400013O00122O000500693O00122O0006006A6O0004000600024O00030003000400202O00030003002A4O00030002000200062O0003006F2O013O0004563O006F2O012O004601036O001A010400013O00122O0005006B3O00122O0006006C6O0004000600024O00030003000400202O00030003004A4O00030002000200062O0003006F2O013O0004563O006F2O012O00460103000C4O00260103000100020006250103006F2O013O0004563O006F2O012O0046010300053O00204C01030003004C4O000500016O000600016O00030006000200062O000300902O013O0004563O00902O012O004601036O0055000400013O00122O0005006D3O00122O0006006E6O0004000600024O00030003000400202O00030003002A4O00030002000200062O000300872O0100010004563O00872O012O00460103000D3O00209800030003006F00122O000500703O00122O000600716O00030006000200062O000300872O013O0004563O00872O012O0046010300053O0020EF00030003002D4O00055O00202O0005000500724O00030005000200062O000300902O0100010004563O00902O012O0046010300023O0020B300030003003000122O000400313O00122O000500716O00030005000200062O000300902O0100010004563O00902O01002E64007300A12O0100740004563O00A12O01002EDE007600A12O0100750004563O00A12O01002E64007800A12O0100770004563O00A12O012O0046010300023O0020AC0003000300144O00045O00202O0004000400794O0005000E6O00030005000200062O000300A12O013O0004563O00A12O012O0046010300013O0012150004007A3O0012150005007B4O006A000300054O005101035O001215000200083O002628000200A82O0100070004563O00A82O01002E03017D00A82O01007C0004563O00A82O01002EDE007E00C70001007F0004563O00C70001001215000100073O0004563O00AB2O010004563O00C70001002E8600800030000100800004563O00DB2O01002EDE008200DB2O0100810004563O00DB2O01000E21004300DB2O0100010004563O00DB2O01002EDE008300CE2O0100840004563O00CE2O012O004601026O0055000300013O00122O000400853O00122O000500866O0003000500024O00020002000300202O00020002000F4O00020002000200062O000200BF2O0100010004563O00BF2O01002EDE008800CE2O0100870004563O00CE2O01002EDE008900CE2O01008A0004563O00CE2O012O0046010200023O0020AC0002000200144O00035O00202O00030003008B4O000400036O00020004000200062O000200CE2O013O0004563O00CE2O012O0046010200013O0012150003008C3O0012150004008D4O006A000200044O005101026O00460102000F4O00260102000100022O00A2000200093O002E86008E00762O01008E0004563O004703012O0046010200093O000618010200D82O0100010004563O00D82O01002E64008F0047030100900004563O004703012O0046010200094O0044010200023O0004563O00470301002628000100DF2O0100010004563O00DF2O01002E6400920007000100910004563O00070001001215000200014O0058010300033O0026B0000200E12O0100010004563O00E12O01001215000300013O002628000300E82O0100080004563O00E82O01002EDE0094008B020100930004563O008B0201002E64009500540201008A0004563O005402012O004601046O001A010500013O00122O000600963O00122O000700976O0005000700024O00040004000500202O00040004004A4O00040002000200062O0004005402013O0004563O00540201002EDE00990054020100980004563O005402012O0046010400104O002601040001000200061801040044020100010004563O004402012O0046010400113O00203E01040004009A4O0004000100024O000500126O000600136O000700053O00202O00070007009B00122O0009009C3O00122O000A004B6O0007000A6O00063O00022O0046010700134O004601086O00F6000900013O00122O000A009D3O00122O000B009E6O0009000B00024O00080008000900202O00080008009F4O00080002000200261F0108001B020100080004563O001B02012O004601086O00F6000900013O00122O000A00A03O00122O000B00A16O0009000B00024O00080008000900202O00080008009F4O00080002000200261F0108001B020100080004563O001B02012O00F000086O0014010800014O003000070002000200202O0007000700354O0005000700024O000600146O000700136O000800053O00202O00080008009B00122O000A009C3O00122O000B004B6O0008000B4O00C300073O00022O0046010800134O004601096O00F6000A00013O00122O000B009D3O00122O000C009E6O000A000C00024O00090009000A00202O00090009009F4O00090002000200261F0109003D020100080004563O003D02012O004601096O00F6000A00013O00122O000B00A03O00122O000C00A16O000A000C00024O00090009000A00202O00090009009F4O00090002000200261F0109003D020100080004563O003D02012O00F000096O0014010900016O00080002000200202O0008000800354O0006000800024O00050005000600062O00040054020100050004563O005402012O0046010400023O00207E0004000400144O00055O00202O0005000500A24O00040002000200062O0004004F020100010004563O004F0201002E3301A3004F020100A40004563O004F0201002EDE00A60054020100A50004563O005402012O0046010400013O001215000500A73O001215000600A84O006A000400064O005101046O004601046O001A010500013O00122O000600A93O00122O000700AA6O0005000700024O00040004000500202O00040004004A4O00040002000200062O0004007902013O0004563O007902012O0046010400104O002601040001000200061801040079020100010004563O007902012O0046010400154O00B90004000100024O000500136O000600053O00202O00060006009B00122O0008009C3O00122O0009004B6O000600096O00053O000200102O00050043000500062O00050079020100040004563O007902012O0046010400053O0020EF0004000400AB4O00065O00202O0006000600AC4O00040006000200062O0004007B020100010004563O007B02012O0046010400154O0026010400010002000ED50035007B020100040004563O007B0201002EDE00AE008A020100AD0004563O008A0201002E6400AF008A020100B00004563O008A02012O0046010400023O0020AC0004000400144O00055O00202O0005000500B14O000600166O00040006000200062O0004008A02013O0004563O008A02012O0046010400013O001215000500B23O001215000600B34O006A000400064O005101045O001215000300073O002EDE00B40093020100B50004563O0093020100262800030091020100070004563O00910201002EDE00B70093020100B60004563O00930201001215000100083O0004563O00070001000E5A00010097020100030004563O00970201002E8600B8004FFF2O00B90004563O00E42O01001215000400013O002EDE00BA0038030100BB0004563O003803010026B000040038030100010004563O003803012O0046010500043O000625010500D802013O0004563O00D802012O004601056O001A010600013O00122O000700BC3O00122O000800BD6O0006000800024O00050005000600202O00050005000F4O00050002000200062O000500D802013O0004563O00D802012O0046010500053O00205000050005002D4O00075O00202O0007000700BE4O00050007000200062O000500CB02013O0004563O00CB02012O0046010500053O00204C01050005004C4O000700016O000800016O00050008000200062O000500D802013O0004563O00D802012O004601056O001A010600013O00122O000700BF3O00122O000800C06O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500D802013O0004563O00D802012O004601056O001A010600013O00122O000700C13O00122O000800C26O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500D802013O0004563O00D802012O0046010500173O00261F010500DA020100070004563O00DA02012O004601056O001A010600013O00122O000700C33O00122O000800C46O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500DA02013O0004563O00DA0201002E8600C50011000100C60004563O00E90201002E6400C800E9020100C70004563O00E902012O0046010500023O0020AC0005000500144O00065O00202O0006000600BE4O000700186O00050007000200062O000500E902013O0004563O00E902012O0046010500013O001215000600C93O001215000700CA4O006A000500074O005101056O004601056O001A010600013O00122O000700CB3O00122O000800CC6O0006000800024O00050005000600202O00050005004A4O00050002000200062O0005000B03013O0004563O000B03012O0046010500194O0093000600136O00078O000800013O00122O000900CD3O00122O000A00CE6O0008000A00024O00070007000800202O00070007002A4O000700086O00063O00020010760006000700060006940006000B030100050004563O000B03012O0046010500053O00202F0005000500CF4O00075O00202O0007000700D04O0005000700024O000600053O00202O0006000600D14O00060002000200062O0005001C030100060004563O001C03012O004601056O001A010600013O00122O000700D23O00122O000800D36O0006000800024O00050005000600202O00050005002A4O00050002000200062O0005003703013O0004563O003703012O0046010500193O000E0201D40037030100050004563O003703012O00460105000C4O002601050001000200061801050037030100010004563O00370301002EDE00D50021030100B70004563O002103012O00460105001A3O00061801050023030100010004563O00230301002E6400D70029030100D60004563O002903012O0046010500023O0020B20005000500D84O00065O00202O0006000600D04O00050002000100044O003703012O0046010500023O00207E0005000500144O00065O00202O0006000600D04O00050002000200062O00050032030100010004563O00320301002EDE00DA0037030100D90004563O003703012O0046010500013O001215000600DB3O001215000700DC4O006A000500074O005101055O001215000400083O002E6400DE0098020100DD0004563O00980201002EDE00E00098020100DF0004563O009802010026B000040098020100080004563O00980201001215000300083O0004563O00E42O010004563O009802010004563O00E42O010004563O000700010004563O00E12O010004563O000700010004563O004703010004563O000200012O00713O00017O00673O00028O00025O0022A840025O006EAF40030B3O00F7C7F7ABA6D070AAC7D9EF03083O00DFB5AB96CFC3961C03073O0049735265616479030B3O006E36E2AA0C6A36F6BC1B5503053O00692C5A83CE030A3O0049734361737461626C65030A3O00CCF5B0AD0D2CF9F5B5BC03063O005E9F80D2D968030B3O004973417661696C61626C6503113O0078F002BB5A71D66A40F614AB4A71F06E4903083O001A309966DF3F1F99027O0040030B3O0042752O6652656D61696E73030B3O00426C616465466C752O7279030A3O0047434452656D61696E73025O00C8A440025O00D09D40025O00F2B240025O00989640025O00E0A140025O009EA340030D3O004361737453752O67657374656403043O004361737403113O002141FEE74262E1F20645ADD50E55FFE11B03043O009362208D03093O003B4CEFCE245A44174703073O002B782383AA663603083O0042752O66446F776E03093O00436F6C64426C2O6F64030E3O0049735370652O6C496E52616E676503083O004469737061746368025O0010AC40025O0039B140025O0040A840025O00E88F40030F3O00770794A2E5938B5802C794A9BF8B5003073O00E43466E7D6C5D0026O00F03F025O00C09840025O004CB140025O00E9B240025O005EA740025O00B09440025O00209E40030E3O003CE561DDEF8E17C216E550D3EF9803083O00B67E8015AA8AEB79030E3O00426574772O656E7468654579657303093O00A8C834E58D0038099F03083O0066EBBA5586E67350025O005EA640025O00D8A340025O0015B24003053O005072652O7303153O00740D2D4B32F627431B3B5A7C94365F097E7A6BD13103073O0042376C5E3F12B4025O00E2A740025O00D6B24003083O0030849627264D178503063O003974EDE55747030D3O0089B0FEF337CA4EB9A1ECF374E603073O0027CAD18D87178E025O0050B240025O00449740025O00BEA640025O007AAE40026O008A40025O00A2B240025O00B07740025O00349540030A3O00CF3A1A1E3DF4CC3B061E03063O00989F53696A52030A3O00506973746F6C53686F7403093O00A2D450F1C24F89C94503063O003CE1A63192A9030C3O00091F211E0902071F2227041503063O00674F7E4F4A61030A3O0054616C656E7452616E6B03093O0042752O66537461636B030B3O004F2O706F7274756E697479026O00184003063O0042752O66557003093O0042726F61647369646503153O0047722O656E736B696E735769636B65727342752O66025O00389E40025O00C49540025O00A0764003103O00997EC0671E2AB36CC77C525A8977DC6703063O007ADA1FB3133E025O00D0964003063O0092DBCFD4DAA903073O0025D3B6ADA1A9C103063O00416D6275736803113O00DF3349DD2D7596E72A42CB3C6EB7FE2E5403073O00D9975A2DB9481B025O00ACB140025O0074A440025O0046B040025O0049B040030B3O00E07DF40616E271E50745CB03053O0036A31C87720070012O0012153O00013O0026283O0005000100010004563O00050001002EDE00030086000100020004563O008600012O00462O016O001A010200013O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O00010002000200062O0001003D00013O0004563O003D00012O00462O016O001A010200013O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O00010002000200062O0001003D00013O0004563O003D00012O00462O0100023O0006252O01003D00013O0004563O003D00012O00462O016O001A010200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001003D00013O0004563O003D00012O00462O016O001A010200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001003D00013O0004563O003D00012O00462O0100033O000E02010F003D000100010004563O003D00012O00462O0100043O0020D80001000100104O00035O00202O0003000300114O0001000300024O000200043O00202O0002000200124O00020002000200062O00010005000100020004563O00410001002E0301130041000100140004563O00410001002E8600150019000100160004563O005800012O00462O0100053O0006182O010046000100010004563O00460001002EDE0018004C000100170004563O004C00012O00462O0100063O0020B20001000100194O00025O00202O0002000200114O00010002000100044O005800012O00462O0100063O00200800010001001A4O00025O00202O0002000200114O00010002000200062O0001005800013O0004563O005800012O00462O0100013O0012150002001B3O0012150003001C4O006A000100034O00512O016O00462O016O001A010200013O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200202O0001000100094O00010002000200062O0001007400013O0004563O007400012O00462O0100043O00205000010001001F4O00035O00202O0003000300204O00010003000200062O0001007400013O0004563O007400012O00462O0100073O0020500001000100214O00035O00202O0003000300224O00010003000200062O0001007400013O0004563O007400012O00462O0100084O00262O01000100020006182O010078000100010004563O00780001002E3301240078000100230004563O00780001002E860025000F000100260004563O008500012O00462O0100063O0020AC00010001001A4O00025O00202O0002000200204O000300096O00010003000200062O0001008500013O0004563O008500012O00462O0100013O001215000200273O001215000300284O006A000100034O00512O015O0012153O00293O002EDE002A00EB0001002B0004563O00EB0001000E5A0029008C00013O0004563O008C0001002EDE002C00EB0001002D0004563O00EB0001001215000100013O0026B0000100E4000100010004563O00E40001002EDE002E00C00001002F0004563O00C000012O004601026O001A010300013O00122O000400303O00122O000500316O0003000500024O00020002000300202O0002000200094O00020002000200062O000200B000013O0004563O00B000012O0046010200073O0020500002000200214O00045O00202O0004000400324O00020004000200062O000200B000013O0004563O00B000012O0046010200084O0026010200010002000625010200B000013O0004563O00B000012O004601026O0055000300013O00122O000400333O00122O000500346O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200B2000100010004563O00B20001002E64003500C0000100360004563O00C00001002E860037000E000100370004563O00C000012O0046010200063O0020080002000200384O00035O00202O0003000300324O00020002000200062O000200C000013O0004563O00C000012O0046010200013O001215000300393O0012150004003A4O006A000200044O005101025O002E64003B00E30001003C0004563O00E300012O004601026O001A010300013O00122O0004003D3O00122O0005003E6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200E300013O0004563O00E300012O0046010200073O0020500002000200214O00045O00202O0004000400224O00020004000200062O000200E300013O0004563O00E300012O0046010200084O0026010200010002000625010200E300013O0004563O00E300012O0046010200063O0020080002000200384O00035O00202O0003000300224O00020002000200062O000200E300013O0004563O00E300012O0046010200013O0012150003003F3O001215000400404O006A000200044O005101025O001215000100293O002628000100E8000100290004563O00E80001002EDE0041008D000100420004563O008D00010012153O000F3O0004563O00EB00010004563O008D0001002EDE00430001000100440004563O000100010026283O00F10001000F0004563O00F10001002E6400460001000100450004563O00010001002EDE004700402O0100480004563O00402O012O00462O016O001A010200013O00122O000300493O00122O0004004A6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100402O013O0004563O00402O012O00462O0100073O0020500001000100214O00035O00202O00030003004B4O00010003000200062O000100402O013O0004563O00402O012O00462O016O001A010200013O00122O0003004C3O00122O0004004D6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100402O013O0004563O00402O012O00462O016O007C000200013O00122O0003004E3O00122O0004004F6O0002000400024O00010001000200202O0001000100504O000100020002000E2O000F00402O0100010004563O00402O012O00462O0100043O00200A0001000100514O00035O00202O0003000300524O000100030002000E2O005300402O0100010004563O00402O012O00462O0100043O0020500001000100544O00035O00202O0003000300554O00010003000200062O000100292O013O0004563O00292O012O00462O01000A3O00261F2O0100302O0100290004563O00302O012O00462O0100043O0020500001000100544O00035O00202O0003000300564O00010003000200062O000100402O013O0004563O00402O01002E8600570009000100570004563O00392O012O00462O0100063O00207E0001000100384O00025O00202O00020002004B4O00010002000200062O0001003B2O0100010004563O003B2O01002E64005800402O0100590004563O00402O012O00462O0100013O0012150002005A3O0012150003005B4O006A000100034O00512O015O002E86005C002F0001005C0004563O006F2O012O00462O016O001A010200013O00122O0003005D3O00122O0004005E6O0002000400024O00010001000200202O0001000100094O00010002000200062O0001005D2O013O0004563O005D2O012O00462O0100073O0020500001000100214O00035O00202O00030003005F4O00010003000200062O0001005D2O013O0004563O005D2O012O00462O016O0055000200013O00122O000300603O00122O000400616O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001005F2O0100010004563O005F2O01002E640062006F2O0100630004563O006F2O012O00462O0100063O00207E0001000100384O00025O00202O00020002005F4O00010002000200062O000100682O0100010004563O00682O01002E640065006F2O0100640004563O006F2O012O00462O0100013O001289000200663O00122O000300676O000100036O00015O00044O006F2O010004563O000100012O00713O00017O00543O00030E3O000ADE49954B7A26CF55876B662DC803063O001F48BB3DE22E030A3O0049734361737461626C65030E3O0049735370652O6C496E52616E6765030E3O00426574772O656E7468654579657303093O00E01442D14C6D2CCC1203073O0044A36623B2271E030B3O004973417661696C61626C65030B3O0042752O6652656D61696E73026O00104003163O00977DCAD50CA386159C75CED006B08D25B675FFDE06A603083O0071DE10BAA763D5E303113O00091CFEF3201DF0FF201DCCFF2D05FEE43D03043O00964E6E9B03073O0048617354696572026O003E4003083O0042752O66446F776E03113O0047722O656E736B696E735769636B657273025O0078AB40025O0040954003053O005072652O73025O001AAD40025O0080554003153O00A6C434F5E43CBA5492C022EFE40AB745C5E03EE4B703083O0020E5A54781C47EDF030E3O00E18CD09684D0CD9DCC84A4CCC69A03063O00B5A3E9A42OE103093O0073993F745B9836784403043O001730EB5E03063O004ADBD654443B03073O00B21CBAB83D3753030F3O00432O6F6C646F776E52656D61696E73025O00804640030B3O00F7C54638FD19D1C5C3443903073O0095A4AD275C926E026O002840025O00889D40025O00C05E4003153O00D026030B5A39F633071A1F15B333181A5A3EEA222O03063O007B9347707F7A030C3O00FFC18B7243CDC386554FCFC803053O0026ACADE21103143O0046696C7465726564466967687452656D61696E7303013O003E030C3O00536C696365616E6444696365028O00026O00F03F02CD5OCCFC3F025O004C9A40025O0002A84003133O006E103FFB0D2220E64E146CEE43156CCB44122903043O008F2D714C030C3O0093B11030B1B61B0FA8AA193903043O005C2OD87C030C3O004B692O6C696E675370722O6503083O00446562752O665570030D3O0047686F73746C79537472696B65030D3O007C3AA353E9572B9F54EF5239A903053O009D3B52CC20025O00089E40025O00DAA44003043O004361737403123O001B3FF0EEA9C1DABD3437EDFDA9D9C3A33D3B03083O00D1585E839A898AB303093O000BAEC8783C2F3E2D2C03083O004248C1A41C7E435103093O00436F6C64426C2O6F6403083O004469737061746368025O00406040025O00A0A940025O0042B340025O005DB040030F3O00C42DBB4C6655E820AC18047AE823AC03063O0016874CC8384603083O00A939EB345CF58E3803063O0081ED5098443D025O00D6B240025O00206340025O003C9240025O00449740025O00609C40025O00EAA140030D3O0072A917E75C335142B805E72O1F03073O003831C864937C77004B013O0046017O001A2O0100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O004400013O0004563O004400012O0046012O00023O0020505O00044O00025O00202O0002000200056O0002000200064O004400013O0004563O004400012O0046017O0055000100013O00122O000200063O00122O000300076O0001000300028O000100206O00086O0002000200064O0044000100010004563O004400012O0046012O00033O00204A5O00094O00025O00202O0002000200056O0002000200264O003D0001000A0004563O003D00012O0046017O0055000100013O00122O0002000B3O00122O0003000C6O0001000300028O000100206O00086O0002000200064O003D000100010004563O003D00012O0046017O0055000100013O00122O0002000D3O00122O0003000E6O0001000300028O000100206O00086O0002000200064O003D000100010004563O003D00012O0046012O00033O0020985O000F00122O000200103O00122O0003000A8O0003000200064O004400013O0004563O004400012O0046012O00033O0020EF5O00114O00025O00202O0002000200126O0002000200064O0046000100010004563O00460001002E6400130054000100140004563O005400012O0046012O00043O00207E5O00154O00015O00202O0001000100056O0002000200064O004F000100010004563O004F0001002EDE00160054000100170004563O005400012O0046012O00013O001215000100183O001215000200194O006A3O00024O0051017O0046017O001A2O0100013O00122O0002001A3O00122O0003001B6O0001000300028O000100206O00036O0002000200064O009100013O0004563O009100012O0046012O00023O0020505O00044O00025O00202O0002000200056O0002000200064O009100013O0004563O009100012O0046017O001A2O0100013O00122O0002001C3O00122O0003001D6O0001000300028O000100206O00086O0002000200064O009100013O0004563O009100012O0046017O00152O0100013O00122O0002001E3O00122O0003001F6O0001000300028O000100206O00206O00020002000E2O0021009100013O0004563O009100012O0046017O00152O0100013O00122O000200223O00122O000300236O0001000300028O000100206O00206O00020002000E2O0024009100013O0004563O009100012O0046012O00043O00207E5O00154O00015O00202O0001000100056O0002000200064O008C000100010004563O008C0001002E6400250091000100260004563O009100012O0046012O00013O001215000100273O001215000200284O006A3O00024O0051017O0046017O001A2O0100013O00122O000200293O00122O0003002A6O0001000300028O000100206O00036O0002000200064O00CE00013O0004563O00CE00012O0046012O00043O0020665O002B4O000100053O00122O0002002C6O000300033O00202O0003000300094O00055O00202O00050005002D4O0003000500024O000400018O0004000200064O00AF000100010004563O00AF00012O0046012O00033O00201C5O00094O00025O00202O00020002002D6O0002000200264O00CE0001002E0004563O00CE00012O0046012O00033O0020C15O00094O00025O00202O00020002002D6O000200024O000100063O00122O0002002F6O000300076O0001000300024O000200083O00122O0003002F4O0046010400074O002A0102000400022O007800010001000200201B2O0100010030000610012O00CE000100010004563O00CE00012O0046012O00043O00207E5O00154O00015O00202O00010001002D6O0002000200064O00C9000100010004563O00C90001002E64003200CE000100310004563O00CE00012O0046012O00013O001215000100333O001215000200344O006A3O00024O0051017O0046017O001A2O0100013O00122O000200353O00122O000300366O0001000300028O000100206O00036O0002000200064O00F000013O0004563O00F000012O0046012O00023O0020505O00044O00025O00202O0002000200376O0002000200064O00F000013O0004563O00F000012O0046012O00023O0020EF5O00384O00025O00202O0002000200396O0002000200064O00F2000100010004563O00F200012O0046017O001A2O0100013O00122O0002003A3O00122O0003003B6O0001000300028O000100206O00086O0002000200064O00F200013O0004563O00F20001002E64003D00FE0001003C0004563O00FE00012O0046012O00043O0020085O003E4O00015O00202O0001000100376O0002000200064O00FE00013O0004563O00FE00012O0046012O00013O0012150001003F3O001215000200404O006A3O00024O0051017O0046017O001A2O0100013O00122O000200413O00122O000300426O0001000300028O000100206O00036O0002000200064O00162O013O0004563O00162O012O0046012O00033O0020505O00114O00025O00202O0002000200436O0002000200064O00162O013O0004563O00162O012O0046012O00023O0020EF5O00044O00025O00202O0002000200446O0002000200064O00182O0100010004563O00182O01002E8600450011000100460004563O00272O012O0046012O00043O002017014O003E4O00015O00202O0001000100434O000200098O0002000200064O00222O0100010004563O00222O01002E64004700272O0100480004563O00272O012O0046012O00013O001215000100493O0012150002004A4O006A3O00024O0051017O0046017O001A2O0100013O00122O0002004B3O00122O0003004C6O0001000300028O000100206O00036O0002000200064O00382O013O0004563O00382O012O0046012O00023O0020EF5O00044O00025O00202O0002000200446O0002000200064O003A2O0100010004563O003A2O01002E64004D004A2O01004E0004563O004A2O01002EDE004F004A2O0100500004563O004A2O012O0046012O00043O00207E5O00154O00015O00202O0001000100446O0002000200064O00452O0100010004563O00452O01002EDE0052004A2O0100510004563O004A2O012O0046012O00013O001215000100533O001215000200544O006A3O00024O0051017O00713O00017O007A3O00028O00025O00B0AF40025O00F08440026O000840025O000EA640025O001AA940030C3O00DA08514FE0F9215E76E5F91B03053O00889C693F1B030B3O004973417661696C61626C6503063O0042752O665570030B3O004F2O706F7274756E697479026O00F83F026O00F03F03093O0042726F61647369646503093O002A99703710A86B350C03043O00547BEC1903083O00D19EAE16AFBCE49203063O00D590EBCA77CC03083O0042752O66446F776E030C3O00417564616369747942752O66025O00907440025O00E07C40025O005EB240025O00AAA04003053O005072652O73030A3O00506973746F6C53686F7403104O0019CD3E681344300CD1266810452C0C03073O002D4378BE4A4843030E3O00132BE3ACEA9CEBFB1336FFACF28D03083O008940428DC599E88E030A3O0049734361737461626C65030E3O0049735370652O6C496E52616E6765030E3O0053696E6973746572537472696B65025O000EAA40025O0002A940025O0026AA40025O00D0964003143O0020D131B2C830D92CAF9B17D530E6BB17C22BAD8D03053O00E863B042C6025O00A6A940025O00F49040030C3O006CFFAC76792462FFAF4F743303063O00412A9EC2221103083O003B32560D2EE40FF703083O008E7A47326C4D8D7B03113O003DABFB1C3E1B8DEF083407B6EA163201BB03053O005B75C29F78025O0053B240025O0013B140025O00208340031B3O00391C2D0C75C12D2O09311475C22C15097E5014E4201B1E370C2CB803073O00447A7D5E78559103153O0047722O656E736B696E735769636B65727342752O66030C3O00311DC16AC0DC921611C25BDA03073O00DA777CAF3EA8B9030B3O0042752O6652656D61696E73025O00E8B240025O004AB040025O00B88740025O0018B040025O00406940025O00EEA740031B3O0086F15BD0E5C041D7B1FF448496F847D0E5B86FF792B06CD1A8E00103043O00A4C59028027O0040025O0008954003103O00E93DB7FFC530B8C2C92EADF9C13FB1F403043O0090AC5EDF03073O004973526561647903043O004361737403103O004563686F696E6752657072696D616E64025O0098A740025O007EA54003163O00070EB153642AA14F2B06AC40643DA7573606AF462A0B03043O0027446FC203063O00F7ABE5D26ABF03063O00D7B6C687A71903113O00A540EE4C8847C5589D46F85C9847E35C9403043O0028ED298A025O00E0AD40025O00A6AC4003063O00416D62757368025O000C9940025O00FCB140031E3O00E475E9EC0AE679F8ED59CF34B2D043C07CB7C858CE7BBADA5FC172FFFC2O03053O002AA7149A98025O00D0A740025O00ECAD40025O0040A440025O00E89840030C3O00A5F1A4BFD5B3ABF1A786D8A403063O00D6E390CAEBBD03093O0042752O66537461636B026O001840025O0026A140025O0084B340025O008AA040025O00689040031B3O00CEA4946F50835A2FF9AA8B3B23BB5C28ADEDA16F38F37729E0B5CE03083O005C8DC5E71B70D333030C3O00C0FE8497D9E3D78BAEDCE3ED03053O00B1869FEAC303093O008CFE36A3C299F93EB703053O00A9DD8B5FC0030C3O00F88A710B2A23F68A7232273403063O0046BEEB1F5F42030A3O0054616C656E7452616E6B03063O008CE314EFF6B203053O0085DA827A86030B3O000FF7E2C0D3B41C3DF1E0C103073O00585C9F83A4BCC303093O00537465616C7468557003093O00A33CBE48DCF8D58F3A03073O00BDE04EDF2BB78B030C3O0008FD8422C92BD48B1BCC2BEE03053O00A14E9CEA76025O00108D40025O00508940025O00BAB240025O0014A54003103O0084B6DAC8E787C0CFB3B8C59C94BFC6C803043O00BCC7D7A900FD012O0012153O00014O00582O0100013O002E6400030002000100020004563O000200010026B03O0002000100010004563O00020001001215000100013O0026280001000B000100040004563O000B0001002E6400060084000100050004563O008400012O004601026O0055000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O00020062000100010004563O006200012O0046010200023O00205000020002000A4O00045O00202O00040004000B4O00020004000200062O0002006200013O0004563O006200012O0046010200033O000E13000C0052000100020004563O005200012O0046010200044O0024000300053O00122O0004000D6O000500066O000600023O00202O00060006000A4O00085O00202O00080008000E4O000600086O00058O00033O00022O0024000400073O00122O0005000D6O000600066O000700023O00202O00070007000A4O00095O00202O00090009000E4O000700096O00068O00043O00022O007800030003000400063B0002001C000100030004563O005200012O004601026O0055000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200094O00020002000200062O00020052000100010004563O005200012O004601026O001A010300013O00122O000400113O00122O000500126O0003000500024O00020002000300202O0002000200094O00020002000200062O0002006200013O0004563O006200012O0046010200023O0020500002000200134O00045O00202O0004000400144O00020004000200062O0002006200013O0004563O00620001002EDE00150062000100160004563O00620001002EDE00180062000100170004563O006200012O0046010200083O0020080002000200194O00035O00202O00030003001A4O00020002000200062O0002006200013O0004563O006200012O0046010200013O0012150003001B3O0012150004001C4O006A000200044O005101026O004601026O001A010300013O00122O0004001D3O00122O0005001E6O0003000500024O00020002000300202O00020002001F4O00020002000200062O0002007300013O0004563O007300012O0046010200093O0020EF0002000200204O00045O00202O0004000400214O00020004000200062O00020075000100010004563O00750001002E64002200FC2O0100230004563O00FC2O012O0046010200083O00207E0002000200194O00035O00202O0003000300214O00020002000200062O0002007E000100010004563O007E0001002EDE002400FC2O0100250004563O00FC2O012O0046010200013O001289000300263O00122O000400276O000200046O00025O00044O00FC2O01002EDE002900F6000100280004563O00F600010026B0000100F60001000D0004563O00F600012O004601026O001A010300013O00122O0004002A3O00122O0005002B6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200B400013O0004563O00B400012O004601026O001A010300013O00122O0004002C3O00122O0005002D6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200B400013O0004563O00B400012O004601026O001A010300013O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200B400013O0004563O00B400012O0046010200023O00205000020002000A4O00045O00202O00040004000B4O00020004000200062O000200B400013O0004563O00B400012O0046010200023O0020EF0002000200134O00045O00202O0004000400144O00020004000200062O000200B6000100010004563O00B60001002EDE003000C4000100310004563O00C40001002E860032000E000100320004563O00C400012O0046010200083O0020080002000200194O00035O00202O00030003001A4O00020002000200062O000200C400013O0004563O00C400012O0046010200013O001215000300333O001215000400344O006A000200044O005101026O0046010200023O00205000020002000A4O00045O00202O0004000400354O00020004000200062O000200E300013O0004563O00E300012O004601026O0055000300013O00122O000400363O00122O000500376O0003000500024O00020002000300202O0002000200094O00020002000200062O000200DC000100010004563O00DC00012O0046010200023O0020EF00020002000A4O00045O00202O00040004000B4O00020004000200062O000200E7000100010004563O00E700012O0046010200023O00204A0002000200384O00045O00202O0004000400354O00020004000200262O000200E70001000C0004563O00E70001002E33013900E70001003A0004563O00E70001002EDE003C00F50001003B0004563O00F50001002EDE003D00F50001003E0004563O00F500012O0046010200083O0020080002000200194O00035O00202O00030003001A4O00020002000200062O000200F500013O0004563O00F500012O0046010200013O0012150003003F3O001215000400404O006A000200044O005101025O001215000100413O002E860042004D000100420004563O00432O010026B0000100432O0100010004563O00432O012O00460102000A3O000625010200172O013O0004563O00172O012O004601026O001A010300013O00122O000400433O00122O000500446O0003000500024O00020002000300202O0002000200454O00020002000200062O000200172O013O0004563O00172O012O0046010200083O00205D0002000200464O00035O00202O0003000300474O000400046O0005000B6O00020005000200062O000200122O0100010004563O00122O01002E64004800172O0100490004563O00172O012O0046010200013O0012150003004A3O0012150004004B4O006A000200044O005101026O004601026O001A010300013O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300202O00020002001F4O00020002000200062O000200422O013O0004563O00422O012O004601026O001A010300013O00122O0004004E3O00122O0005004F6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200422O013O0004563O00422O012O0046010200023O00205000020002000A4O00045O00202O0004000400144O00020004000200062O000200422O013O0004563O00422O01002EDE0051003B2O0100500004563O003B2O012O0046010200083O00207E0002000200194O00035O00202O0003000300524O00020002000200062O0002003D2O0100010004563O003D2O01002EDE005400422O0100530004563O00422O012O0046010200013O001215000300553O001215000400564O006A000200044O005101025O0012150001000D3O002628000100492O0100410004563O00492O01002E03015800492O0100570004563O00492O01002E64005900070001005A0004563O000700012O004601026O001A010300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200682O013O0004563O00682O012O0046010200023O00205000020002000A4O00045O00202O00040004000B4O00020004000200062O000200682O013O0004563O00682O012O0046010200023O00201201020002005D4O00045O00202O00040004000B4O000200040002000E2O005E006A2O0100020004563O006A2O012O0046010200023O00204A0002000200384O00045O00202O00040004000B4O00020004000200262O0002006A2O0100410004563O006A2O01002E64006000782O01005F0004563O00782O012O0046010200083O00207E0002000200194O00035O00202O00030003001A4O00020002000200062O000200732O0100010004563O00732O01002EDE006100782O0100620004563O00782O012O0046010200013O001215000300633O001215000400644O006A000200044O005101026O004601026O001A010300013O00122O000400653O00122O000500666O0003000500024O00020002000300202O0002000200094O00020002000200062O000200E82O013O0004563O00E82O012O0046010200023O00205000020002000A4O00045O00202O00040004000B4O00020004000200062O000200E82O013O0004563O00E82O012O0046010200044O0092000300053O00122O0004000D6O000500066O00068O000700013O00122O000800673O00122O000900686O0007000900024O00060006000700202O0006000600094O000600076O00053O00024O00068O000700013O00122O000800693O00122O0009006A6O0007000900024O00060006000700202O00060006006B4O0006000200024O0005000500064O0003000500024O000400073O00122O0005000D6O000600066O00078O000800013O00122O000900673O00122O000A00686O0008000A00024O00070007000800202O0007000700094O000700086O00063O00024O00078O000800013O00122O000900693O00122O000A006A6O0008000A00024O00070007000800202O00070007006B4O0007000200024O0006000600074O0004000600024O00030003000400062O000300E82O0100020004563O00E82O012O004601026O0055000300013O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300202O0002000200454O00020002000200062O000200CD2O0100010004563O00CD2O012O004601026O001A010300013O00122O0004006E3O00122O0005006F6O0003000500024O00020002000300202O0002000200454O00020002000200062O000200EA2O013O0004563O00EA2O012O0046010200023O0020A30002000200704O000400016O000500016O00020005000200062O000200EA2O0100010004563O00EA2O012O004601026O001A010300013O00122O000400713O00122O000500726O0003000500024O00020002000300202O0002000200094O00020002000200062O000200EA2O013O0004563O00EA2O012O004601026O00F6000300013O00122O000400733O00122O000500746O0003000500024O00020002000300202O00020002006B4O00020002000200261F010200EA2O01000D0004563O00EA2O01002E64007500F82O0100760004563O00F82O012O0046010200083O00207E0002000200194O00035O00202O00030003001A4O00020002000200062O000200F32O0100010004563O00F32O01002EDE007700F82O0100780004563O00F82O012O0046010200013O001215000300793O0012150004007A4O006A000200044O005101025O001215000100043O0004563O000700010004563O00FC2O010004563O000200012O00713O00017O0096012O00028O00026O000840025O002C9140025O00489C40025O00588140025O0038814003063O0042752O665570030E3O00416472656E616C696E6552757368026O0049C0030B3O00456E65726779526567656E026O001040025O00507040025O003AAE40026O001440030B3O004372696D736F6E5669616C025O001CB340025O00F8AC4003073O00506F69736F6E73026O001840025O00B2A240025O00488340025O00E07440025O00D4A74003163O00456E6572677944656669636974507265646963746564025O00209540025O00DCA240025O008AAC40025O00C7B240025O004CAA40025O004EAC40026O00F03F025O00C09840025O00D6A140025O0010B240025O00049E40025O0032A040025O003AA640025O0050A040025O00789F4003113O00476574456E656D696573496E52616E6765026O003E40030C3O004570696353652O74696E677303073O00D82E2F017788EA03083O004C8C4148661BED992O033O0045D51503073O00DE2ABA76B2B76103073O0069E3438D51E95703043O00EA3D8C242O033O0020D2BF03053O006F41BDDA12025O009CA640025O00BAA940025O00C2A940025O0052B24003053O00792DA70A4203053O00363F48CE64030A3O0049734361737461626C6503103O004865616C746850657263656E74616765030C3O0049734368612O6E656C696E6703093O00497343617374696E6703043O004361737403053O004665696E7403173O00EB58566EA55DCD504B6EA533EC5C437FEB68C14F4069AC03063O001BA839251A85026O001C40025O00807840025O00B8A940025O00EC9340025O00708D40025O00989240025O000CB040030B3O00A51D1B419910095982161F03043O002DED787A03073O0049735265616479025O00C8A240025O0056A340030B3O004865616C746873746F6E65025O00C05D40025O00B3B140030C3O00FFEDA320C3E0B138D8E6A76C03043O004CB788C203173O00482OE32A555C1C73E8E210554E1873E8E2085F5B1D75E803073O00741A868558302F03173O0052656672657368696E674865616C696E67506F74696F6E025O0068A040025O00D88340025O002EAE4003183O002CC4A6F6B86116C8AEE395771FCDA9EABA4211D5A9EBB33203063O00127EA1C084DD025O002EA740025O0080684003073O0077441C320759BC03073O00CF232B7B556B3C2O033O0073AEB303053O001910CAC08A03103O00DCC8BFEDABF5E9C2AED1BDE6F4C0A8F103063O00949DABCD82C9030B3O004973417661696C61626C65026O00224003083O0007DD6739D0E220DC03063O009643B41449B103063O0044616D616765026O00F43F027O0040025O0051B240025O00CEA740025O001AA140025O00F49A40025O00607A40025O00B07940025O00D49A40025O009AAA40030F3O00412O66656374696E67436F6D62617403093O0049734D6F756E746564025O0058A340025O002OA640025O00805D40025O00609D4003073O00537465616C746803083O00537465616C746832025O0040A940025O00089140030F3O001EBE79A9DB39A23CE0F8028935F29703053O00B74DCA1CC8025O0032A940025O00D09C40025O0080944003063O0021328701043B03043O00687753E903113O0054696D6553696E63654C6173744361737403093O004973496E52616E6765026O002040030D3O00546172676574497356616C6964026O002440025O005EAB40025O0098AA40025O0044A540025O00A5B240025O005C9B40025O00F07740025O00D8A140025O00A4B040025O00F08340025O00E09040030B3O00D7F42O2646D3F4323051EC03053O00239598474203083O0042752O66446F776E030B3O00426C616465466C752O727903143O002CE646B52811E94CB43F1DDD52A03F0BE043BE3E03053O005A798822D003093O00537465616C74685570025O00C09340025O0083B040025O0010A340025O002DB04003153O00E502541AC24E7312D21C470787467A0EC200500C8E03043O007EA76E35025O00208E40025O0018B140025O001EA740025O00109A40030C3O00537465616C74685370652O6C025O00F5B140025O004CA540025O003CAA40025O0028B340025O00D4B040025O000FB240025O0092A140025O00108140025O008AA640025O0078A640025O0020A540025O0072AC40025O00BAA340025O001AA740025O00B5B040025O00D09540030E3O001C143CFDD23E311920FDEE2A2E1803063O005F5D704E98BC03163O00E8F89507EBA8D7C5D48107E1B0D3CDFC8B10D6ABC1C903073O00B2A195E57584DE025O001EAF40025O00488440031D3O00ABDACEB8E137A2318DD5DCA0A818A363BA2OCEA4E15E89338DD5D8BEE803083O0043E8BBBDCCC176C6025O00F09D40030C3O00B921B92C2F0AEAA921BB252803073O008FEB4ED5405B6203083O00446562752O665570030B3O004472656164626C61646573025O0054B040025O00E07640025O0097B040025O0016AD40030C3O00526F2O6C746865426F6E6573025O00A06240025O0086B140031C3O00AE4997FD3084824488A964BE8808A6E67EB39E08CCC660B3834D96A003063O00D6ED28E48910025O00308440025O00349040030E3O00411F3E58D22377040345D33E791303063O005712765031A1025O00989640025O0072A740030E3O0053696E6973746572537472696B65031D3O006F1FC9B4F07F17D4A9A3581BC8E083580CD3ABB50C56F5B0B5421BC8E903053O00D02C7EBAC0025O0068AA40025O00E06840025O001CAC40025O0034AD40025O00589740025O00D4B140030C3O00B6EFE6DA06A78BE7CBD000A303063O00C6E5838FB963030B3O0042752O6652656D61696E73030C3O00536C696365616E644469636502CD5OCCFC3F03053O005072652O73025O00B88940025O00988C40031C3O00728DBB6711BFA47A5289E8725F88E857588FAD3319A3B8765F89BA3A03043O001331ECC8025O00A0B040025O00507D40025O0062B340025O000DB140025O00188440025O00449740025O00B07D40025O004FB040030D3O00D01BDCF21F36FFF412D5EB382503073O00AD9B7EB9825642030D3O00C2AEB5D49CE0FC95AED581E7E003063O008C85C6DAA7E803103O00902DBC728DBB29867894A727B97C8AB103053O00E4D54ED41D030D3O0047686F73746C79537472696B65025O00C4A540025O00405E4003203O00A44DA511ABA044B916FF8B55F636FF9545BD00ABAC458445A3A85CB30BEE950503053O008BE72CD665025O00A09D40025O00FEA54003063O00F8E2044B03B903083O0076B98F663E70D15103063O00416D62757368025O001EAD40025O00C0554003143O007F713AF2E534113A496321A6ED3A0C3D52753BAF03083O00583C104986C5757C025O00088340025O0062AE40025O0014A040025O0058A240025O0088A440025O00FEA040025O006EA740025O0092AB40025O007C9B4003123O00CD23F3B6E8AEF677BE98F4BFF032E4FEBEFA03063O00DA9E5796D784025O00607640025O00649D40025O004C9F40025O00A6A540025O004EA440025O0080A24003113O0076E3F6C15258AAB0E75155E4FDDA080AAA03053O0021308A98A8025O008AA540025O0054A040025O0030A740025O00C05140025O00B08640025O003C9840030C3O00D11BAAF21CF9E14FFA17A1D403083O002E977AC4A6749CA9030A3O00D5E4550EF4E9DE4E15EF03053O009B858D267A030A3O0047434452656D61696E73030E3O0046616E54686548612O6D65724350025O00A8A240025O00689E4003123O00436F6D626F506F696E747344656669636974025O00CAAA40025O0010AB40025O00A3B240025O0050A940030B3O00436F6D626F506F696E747303143O00452O66656374697665436F6D626F506F696E7473025O0042A240025O00707A40025O00689D40025O00805840025O00A7B240025O00588640025O00CAB040025O00C9B040025O0068AC40025O006C9C40025O0034A140025O0068B340025O00349140025O000C954003053O00060EBF1B0F03073O00C5454ACC212F1F030A3O00536861646F776D656C64025O00407840025O00E0644003093O00C35B5F86FC5B52DDB003043O00E7902F3A025O00788440025O0002A940025O0036AC40025O00F08D40025O0046AC40025O00D2AD40025O009C9E40025O0010A740025O00AEAD4003083O0094D1D47C0B35957903083O0059D2B8BA15785DAF025O003EAD40025O0038A240026O006640025O00E49940025O0028A940025O007CB240030E3O002BC17200AC14E2600CBF0ACD7B1C03053O00D867A81568030E3O004973496E4D656C2O6552616E6765025O00409940025O00ECAF40025O00B4A440025O00A09840030E3O004C69676874734A7564676D656E74025O0082B14003143O005BAC50B038814AA370B950E452B847A375A84DB003043O00C418CD23025O00D07340025O00E0AC40025O0016AB40025O00FCA240030B3O000C8AE40928BFF10F2D80F003043O00664EEB83030B3O004261676F66547269636B7303123O00D92F2750071BB633BA213204732BBE37F13D03083O00549A4E54242759D7030A3O00CDE8454C0AF1D25E571103053O00659D813638030E3O0049735370652O6C496E52616E6765030A3O00506973746F6C53686F74026O003940026O33F33F025O0070AA40025O00708040025O00F07F4003163O003EA899BF634914BA9EA42F392EA185BF63313286B8E203063O00197DC9EACB43030E3O004AFD160A0733166BC70C111D2C1603073O0073199478637447025O00A4A040025O00309D40025O00BCA040025O0046A040025O0036AE40031B3O002F3CAA30013F34B72D521838AB6472182FB02F444C1BB0284D092F03053O00216C5DD944025O00409A40025O002EA440025O0024A840025O0028AC40025O00709F40025O00E0A040025O0054AA40025O0039B040030D3O00F16954EFB1D54F58FCADD5754303053O00DFB01B378E026O002E40025O004CA240025O00D6AC40025O0024B040030D3O00417263616E65546F2O72656E74025O002OB240025O00C06D4003133O0007BADDA1649ADCB625B5CBF510B4DCA721B5DA03043O00D544DBAE025O00F4AA40025O00D3B140030B3O002AF220E624C00F6A07F32603083O001F6B8043874AA55F025O00C05640025O0078A540025O003C9C40030B3O00417263616E6550756C736503113O00FBE9EF590190CAEBFD4344F1E8FDF05E4403063O00D1B8889C2D21025O00C88340025O0054A440025O00907740025O0031B24003073O00934675D97D60F103063O005AD1331CB519003A062O0012153O00013O0026283O0007000100020004563O00070001002EF800030007000100040004563O00070001002E640005001D000100060004563O001D00012O00462O0100013O00200F2O01000100074O000300023O00202O0003000300084O000400046O000500016O00010005000200062O0001001300013O0004563O00130001001215000100093O0006182O010014000100010004563O00140001001215000100014O00A200016O00502O0100046O0001000100024O000100036O000100013O00202O00010001000A4O0001000200024O000100053O00124O000B3O002EDE000C00300001000D0004563O003000010026B03O00300001000E0004563O003000012O00462O0100073O0020E200010001000F4O0001000100024O000100066O000100063O00062O0001002A000100010004563O002A0001002E8600100004000100110004563O002C00012O00462O0100064O00442O0100024O00462O0100073O00201D0001000100122O004C0001000100010012153O00133O002EDE00150034000100140004563O00340001000E5A000B003600013O0004563O00360001002EDE00170078000100160004563O007800012O00462O0100094O003D00028O0001000200024O000100086O000100013O00202O0001000100184O000300036O00048O0001000400024O0001000A6O0001000B3O0006182O010045000100010004563O00450001002EDE001A0075000100190004563O00750001001215000100014O0058010200023O002E64001B00470001001C0004563O004700010026B000010047000100010004563O00470001001215000200013O002E64001D006B0001001E0004563O006B00010026B00002006B000100010004563O006B0001001215000300013O002628000300570001001F0004563O00570001002EF800200057000100210004563O00570001002E8600220004000100230004563O005900010012150002001F3O0004563O006B0001002EDE0024005D000100250004563O005D00010026280003005F000100010004563O005F0001002EDE00260051000100270004563O005100012O0046010400013O00207A00040004002800122O000600296O0004000600024O0004000C6O000400013O00202O0004000400284O0006000E6O0004000600024O0004000D3O00122O0003001F3O0004563O00510001000E21001F004C000100020004563O004C00012O00460103000D4O0004010300034O00A20003000F3O0004563O007700010004563O004C00010004563O007700010004563O004700010004563O007700010012150001001F4O00A20001000F3O0012153O000E3O0026B03O0095000100010004563O009500012O00462O0100104O004C0001000100010012680001002A4O00AF000200123O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000200123O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O000100113O00122O0001002A6O000200123O00122O0003002F3O00122O000400306O0002000400024O0001000100024O000200123O00122O000300313O00122O000400326O0002000400024O0001000100024O0001000B3O00124O001F3O0026B03O00242O0100130004563O00242O01001215000100013O002E640033009C000100340004563O009C00010026280001009E0001001F0004563O009E0001002EDE003600C6000100350004563O00C600012O0046010200024O001A010300123O00122O000400373O00122O000500386O0003000500024O00020002000300202O0002000200394O00020002000200062O000200C400013O0004563O00C400012O0046010200013O0020F500020002003A2O006C0002000200022O0046010300133O000694000200C4000100030004563O00C400012O0046010200013O0020F500020002003B2O006C000200020002000618010200C4000100010004563O00C400012O0046010200013O0020F500020002003C2O006C000200020002000618010200C4000100010004563O00C400012O0046010200143O00200800020002003D4O000300023O00202O00030003003E4O00020002000200062O000200C400013O0004563O00C400012O0046010200123O0012150003003F3O001215000400404O006A000200044O005101025O0012153O00413O0004563O00242O01002E6400420098000100430004563O00980001002EDE00450098000100440004563O009800010026B000010098000100010004563O00980001002EDE004600F8000100470004563O00F800012O0046010200154O001A010300123O00122O000400483O00122O000500496O0003000500024O00020002000300202O00020002004A4O00020002000200062O000200F800013O0004563O00F800012O0046010200013O0020F500020002003A2O006C0002000200022O0046010300163O000610010200F8000100030004563O00F800012O0046010200013O0020F500020002003B2O006C000200020002000618010200F8000100010004563O00F800012O0046010200013O0020F500020002003C2O006C000200020002000618010200F8000100010004563O00F80001002E64004B00F10001004C0004563O00F100012O0046010200143O00207E00020002003D4O000300173O00202O00030003004D4O00020002000200062O000200F3000100010004563O00F30001002E64004F00F80001004E0004563O00F800012O0046010200123O001215000300503O001215000400514O006A000200044O005101026O0046010200154O001A010300123O00122O000400523O00122O000500536O0003000500024O00020002000300202O00020002004A4O00020002000200062O000200222O013O0004563O00222O012O0046010200013O0020F500020002003A2O006C0002000200022O0046010300183O000610010200222O0100030004563O00222O012O0046010200013O0020F500020002003B2O006C000200020002000618010200222O0100010004563O00222O012O0046010200013O0020F500020002003C2O006C000200020002000618010200222O0100010004563O00222O012O0046010200143O00207E00020002003D4O000300173O00202O0003000300544O00020002000200062O0002001D2O0100010004563O001D2O01002E330155001D2O0100560004563O001D2O01002EDE005700222O01004C0004563O00222O012O0046010200123O001215000300583O001215000400594O006A000200044O005101025O0012150001001F3O0004563O00980001002EDE005B004E2O01005A0004563O004E2O010026B03O004E2O01001F0004563O004E2O010012680001002A4O0034010200123O00122O0003005C3O00122O0004005D6O0002000400024O0001000100024O000200123O00122O0003005E3O00122O0004005F6O0002000400024O0001000100024O000100196O000100026O000200123O00122O000300603O00122O000400616O0002000400024O00010001000200202O0001000100624O00010002000200062O000100412O013O0004563O00412O01001215000100633O0006182O0100422O0100010004563O00422O01001215000100134O00A20001000E4O00462O0100024O00F6000200123O00122O000300643O00122O000400656O0002000400024O00010001000200202O0001000100664O00010002000200201B2O01000100672O00A20001001A3O0012153O00683O0026283O00522O0100410004563O00522O01002EDE006900F40301006A0004563O00F40301001215000100013O002E64006C00C60301006B0004563O00C60301002628000100592O0100010004563O00592O01002E64006D00C60301006E0004563O00C60301002EDE006F008A2O0100700004563O008A2O012O0046010200013O0020F50002000200712O006C0002000200020006180102008A2O0100010004563O008A2O012O0046010200013O0020F50002000200722O006C0002000200020006180102008A2O0100010004563O008A2O012O00460102001B3O0006250102008A2O013O0004563O008A2O01001215000200014O0058010300033O0026280002006E2O0100010004563O006E2O01002EDE0074006A2O0100730004563O006A2O01001215000300013O002628000300732O0100010004563O00732O01002E86007500FEFF2O00760004563O006F2O012O0046010400073O0020A90004000400774O000500023O00202O0005000500784O000600066O0004000600024O000400063O002E2O007A008A2O0100790004563O008A2O012O0046010400063O0006250104008A2O013O0004563O008A2O012O0046010400123O0012200005007B3O00122O0006007C6O0004000600024O000500066O0004000400054O000400023O00044O008A2O010004563O006F2O010004563O008A2O010004563O006A2O01002EDE007E00C50301007D0004563O00C50301002E86007F00390201007F0004563O00C503012O0046010200013O0020F50002000200712O006C000200020002000618010200C5030100010004563O00C503012O0046010200024O0015010300123O00122O000400803O00122O000500816O0003000500024O00020002000300202O0002000200824O000200020002000E2O001F00C5030100020004563O00C503012O00460102001C3O0020F5000200020083001215000400844O002A010200040002000625010200C503013O0004563O00C503012O0046010200113O000625010200C503013O0004563O00C503012O00460102001D3O00201D0002000200852O0026010200010002000625010200BB2O013O0004563O00BB2O012O00460102001C3O0020F5000200020083001215000400864O002A010200040002000625010200BB2O013O0004563O00BB2O012O0046010200013O0020F500020002003B2O006C000200020002000618010200BB2O0100010004563O00BB2O012O0046010200013O0020F500020002003C2O006C000200020002000625010200BF2O013O0004563O00BF2O01002EF8008700BF2O0100880004563O00BF2O01002E64008A00C5030100890004563O00C50301001215000200014O0058010300033O002EDE008C00C12O01008B0004563O00C12O010026B0000200C12O0100010004563O00C12O01001215000300013O0026B000030035020100010004563O00350201001215000400013O0026B00004002E020100010004563O002E0201001215000500013O002EDE008D00250201008E0004563O002502010026B000050025020100010004563O00250201002E64008F0004020100900004563O000402012O0046010600024O001A010700123O00122O000800913O00122O000900926O0007000900024O00060006000700202O00060006004A4O00060002000200062O0006000402013O0004563O000402012O0046010600013O0020500006000600934O000800023O00202O0008000800944O00060008000200062O0006000402013O0004563O000402012O0046010600024O001A010700123O00122O000800953O00122O000900966O0007000900024O00060006000700202O0006000600624O00060002000200062O0006000402013O0004563O000402012O0046010600013O0020A30006000600974O000800016O000900016O00060009000200062O00060004020100010004563O00040201002EDE00980004020100990004563O000402012O0046010600143O00207E00060006003D4O000700023O00202O0007000700944O00060002000200062O000600FF2O0100010004563O00FF2O01002E86009A00070001009B0004563O000402012O0046010600123O0012150007009C3O0012150008009D4O006A000600084O005101065O002E86009E00200001009E0004563O00240201002EDE00A000240201009F0004563O002402012O0046010600013O0020A30006000600974O000800016O00098O00060009000200062O00060024020100010004563O00240201001215000600013O002E8600A13O000100A10004563O001002010026B000060010020100010004563O001002012O0046010700073O00208D0007000700774O000800073O00202O0008000800A24O000800016O00073O00024O000700066O000700063O00062O00070020020100010004563O00200201002E8600A30006000100A40004563O002402012O0046010700064O0044010700023O0004563O002402010004563O001002010012150005001F3O000E5A001F002B020100050004563O002B0201002E3301A6002B020100A50004563O002B0201002E8600A700A3FF2O00A80004563O00CC2O010012150004001F3O0004563O002E02010004563O00CC2O01002EDE00AA00C92O0100A90004563O00C92O010026B0000400C92O01001F0004563O00C92O010012150003001F3O0004563O003502010004563O00C92O01002EDE00AC00C62O0100AB0004563O00C62O01000E21001F00C62O0100030004563O00C62O01001215000400013O002E6400AD003A020100AE0004563O003A020100262800040040020100010004563O00400201002E8600AF00FCFF2O00B00004563O003A0201001215000500013O00262800050045020100010004563O00450201002E6400B10041020100B20004563O004102012O00460106001D3O00201D0006000600852O0026010600010002000625010600BF03013O0004563O00BF0301001215000600013O0026B0000600A0020100010004563O00A002012O0046010700024O001A010800123O00122O000900B33O00122O000A00B46O0008000A00024O00070007000800202O00070007004A4O00070002000200062O0007007202013O0004563O007202012O0046010700024O001A010800123O00122O000900B53O00122O000A00B66O0008000A00024O00070007000800202O0007000700624O00070002000200062O0007007202013O0004563O007202012O00460107001E3O00264801070072020100680004563O00720201002EDE00B80072020100B70004563O007202012O0046010700143O00200800070007003D4O000800023O00202O0008000800084O00070002000200062O0007007202013O0004563O007202012O0046010700123O001215000800B93O001215000900BA4O006A000700094O005101075O002E8600BB001B000100BB0004563O008D02012O0046010700024O001A010800123O00122O000900BC3O00122O000A00BD6O0008000A00024O00070007000800202O00070007004A4O00070002000200062O0007008D02013O0004563O008D02012O0046010700013O0020EF0007000700BE4O000900023O00202O0009000900BF4O00070009000200062O0007008D020100010004563O008D02012O00460107001F4O00260107000100020026280007008F020100010004563O008F02012O0046010700204O00260107000100020006180107008F020100010004563O008F0201002E6400C0009F020100C10004563O009F0201002E6400C30098020100C20004563O009802012O0046010700143O00207E00070007003D4O000800023O00202O0008000800C44O00070002000200062O0007009A020100010004563O009A0201002E6400C6009F020100C50004563O009F02012O0046010700123O001215000800C73O001215000900C84O006A000700094O005101075O0012150006001F3O002EDE00C900BD020100CA0004563O00BD02010026B0000600BD020100680004563O00BD02012O0046010700024O001A010800123O00122O000900CB3O00122O000A00CC6O0008000A00024O00070007000800202O0007000700394O00070002000200062O000700BF03013O0004563O00BF0301002EDE00CD00BF030100CE0004563O00BF03012O0046010700143O00200800070007003D4O000800023O00202O0008000800CF4O00070002000200062O000700BF03013O0004563O00BF03012O0046010700123O001289000800D03O00122O000900D16O000700096O00075O00044O00BF0301000E5A001F00C1020100060004563O00C10201002EDE00D2004B020100D30004563O004B0201001215000700014O0058010800083O0026B0000700C3020100010004563O00C30201001215000800013O002E6400D400B2030100D50004563O00B20301002E6400D600B2030100D70004563O00B203010026B0000800B2030100010004563O00B203012O0046010900024O001A010A00123O00122O000B00D83O00122O000C00D96O000A000C00024O00090009000A00202O00090009004A4O00090002000200062O000900F502013O0004563O00F502012O0046010900013O0020C10009000900DA4O000B00023O00202O000B000B00DB4O0009000B00024O000A00213O00122O000B001F6O000C001E6O000A000C00024O000B00223O00122O000C001F4O0046010D001E4O002A010B000D00022O0078000A000A000B00201B010A000A00DC000610010900F50201000A0004563O00F502012O0046010900143O00207E0009000900DD4O000A00023O00202O000A000A00DB4O00090002000200062O000900F0020100010004563O00F00201002E6400DF00F5020100DE0004563O00F502012O0046010900123O001215000A00E03O001215000B00E14O006A0009000B4O005101095O002EDE00E300FE020100E20004563O00FE02012O0046010900013O0020A30009000900974O000B00016O000C8O0009000C000200062O00092O00030100010004564O000301002E6400E40087030100E50004563O00870301001215000900014O0058010A000A3O00262800090006030100010004563O00060301002E6400E70002030100E60004563O00020301001215000A00013O002628000A000B0301001F0004563O000B0301002E8600E80049000100E90004563O005203012O0046010B00024O001A010C00123O00122O000D00EA3O00122O000E00EB6O000C000E00024O000B000B000C00202O000B000B00624O000B0002000200062O000B003703013O0004563O003703012O0046010B00024O001A010C00123O00122O000D00EC3O00122O000E00ED6O000C000E00024O000B000B000C00202O000B000B00624O000B0002000200062O000B003703013O0004563O003703012O0046010B00024O001A010C00123O00122O000D00EE3O00122O000E00EF6O000C000E00024O000B000B000C00202O000B000B00624O000B0002000200062O000B003703013O0004563O003703012O0046010B00143O00207E000B000B003D4O000C00023O00202O000C000C00F04O000B0002000200062O000B0032030100010004563O00320301002EDE00F10037030100F20004563O003703012O0046010B00123O001215000C00F33O001215000D00F44O006A000B000D4O0051010B5O002E6400F500B1030100F60004563O00B103012O0046010B00024O001A010C00123O00122O000D00F73O00122O000E00F86O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B00B103013O0004563O00B103012O0046010B00143O00207E000B000B003D4O000C00023O00202O000C000C00F94O000B0002000200062O000B004C030100010004563O004C0301002EDE00FA00B1030100FB0004563O00B103012O0046010B00123O001289000C00FC3O00122O000D00FD6O000B000D6O000B5O00044O00B10301002E6400FE0007030100FF0004563O000703010026B0000A0007030100010004563O00070301001215000B00014O0058010C000C3O002628000B005D030100010004563O005D0301001215000D002O012O000E212O0001580301000D0004563O00580301001215000C00013O001215000D001F3O0006AE000C00650301000D0004563O00650301001215000D0002012O001215000E0003012O000610010D00670301000E0004563O00670301001215000A001F3O0004563O00070301001215000D0004012O001215000E0004012O000673000D006E0301000E0004563O006E0301001215000D00013O0006AE000D00720301000C0004563O00720301001215000D0005012O001215000E0006012O000694000D005E0301000E0004563O005E03012O0046010D00234O0026010D000100022O00A2000D00064O0046010D00063O000625010D007F03013O0004563O007F03012O0046010D00123O001290000E0007012O00122O000F0008015O000D000F00024O000E00066O000D000D000E4O000D00023O001215000C001F3O0004563O005E03010004563O000703010004563O005803010004563O000703010004563O00B103010004563O000203010004563O00B103012O0046010900244O00260109000100020006180109008F030100010004563O008F030100121500090009012O001215000A000A012O000673000900B10301000A0004563O00B10301001215000900014O0058010A000A3O001215000B00013O0006AE000900980301000B0004563O00980301001215000B000B012O001215000C000C012O000673000B00910301000C0004563O00910301001215000A00013O001215000B00013O0006AE000A00A00301000B0004563O00A00301001215000B000D012O001215000C000E012O000610010B00990301000C0004563O009903012O0046010B00254O0026010B000100022O00A2000B00064O0046010B00063O000625010B00B103013O0004563O00B103012O0046010B00123O001220000C000F012O00122O000D0010015O000B000D00024O000C00066O000B000B000C4O000B00023O00044O00B103010004563O009903010004563O00B103010004563O009103010012150008001F3O00121500090011012O001215000A0012012O000694000A00C6020100090004563O00C602010012150009001F3O000673000800C6020100090004563O00C60201001215000600683O0004563O004B02010004563O00C602010004563O004B02010004563O00C302010004563O004B02012O00713O00013O0004563O004102010004563O003A02010004563O00C62O010004563O00C503010004563O00C12O010012150001001F3O0012150002001F3O0006AE000100CD030100020004563O00CD030100121500020013012O00121500030014012O000673000200532O0100030004563O00532O0100121500020015012O00121500030016012O000610010200F1030100030004563O00F103012O0046010200024O001A010300123O00122O00040017012O00122O00050018015O0003000500024O00020002000300202O0002000200624O00020002000200062O000200F103013O0004563O00F103012O0046010200024O00F6000300123O00122O00040019012O00122O0005001A015O0003000500024O00020002000300202O0002000200824O0002000200022O0038000300013O00122O0005001B015O0003000300054O00030002000200062O000200F1030100030004563O00F103012O0046010200264O00200103001E6O000400073O00122O0005001C015O0004000400054O000400016O00023O00024O0002001E3O0012153O00843O0004563O00F403010004563O00532O010012150001001D012O0012150002001E012O0006940002001E040100010004563O001E0401001215000100683O0006733O001E040100010004563O001E0401001215000100013O0012150002001F3O00067300010006040100020004563O000604012O0046010200013O00124E0104001F015O0002000200044O0002000200024O000200273O00124O00023O00044O001E040100121500020020012O00121500030021012O0006100102000D040100030004563O000D0401001215000200013O0006AE00010011040100020004563O0011040100121500020022012O00121500030023012O000673000200FC030100030004563O00FC03012O0046010200013O00123C00040024015O0002000200044O0002000200024O0002001E6O000200073O00122O00030025015O0002000200034O0003001E6O0002000200024O000200283O00122O0001001F3O00044O00FC0301001215000100843O0006733O0001000100010004563O000100012O00462O01001D3O00201D0001000100852O00262O01000100020006182O01002E040100010004563O002E040100121500010026012O00121500020027012O00063B00010005000100020004563O002E040100121500010028012O00121500020029012O00069400010039060100020004563O00390601001215000100014O0058010200033O001215000400013O0006AE00010037040100040004563O003704010012150004002A012O0012150005002B012O0006730004003A040100050004563O003A0401001215000200014O0058010300033O0012150001001F3O0012150004002C012O0012150005002D012O00061001050030040100040004563O003004010012150004002E012O0012150005002F012O00069400050030040100040004563O003004010012150004001F3O00067300010030040100040004563O00300401001215000400013O00067300020045040100040004563O00450401001215000300013O00121500040030012O00121500050031012O000610010400CD040100050004563O00CD0401001215000400013O0006AE00030054040100040004563O0054040100121500040032012O001215000500143O000694000500CD040100040004563O00CD04012O0046010400294O00AB0004000100024O000400063O00122O00040033012O00122O00050033012O00062O00040065040100050004563O006504012O0046010400063O0006250104006504013O0004563O006504012O0046010400123O00129000050034012O00122O00060035015O0004000600024O000500066O0004000400054O000400024O0046010400013O0020A30004000400974O000600016O000700016O00040007000200062O00040074040100010004563O007404012O0046010400013O00209D0004000400074O000600023O00122O00070036015O0006000600074O00040006000200062O0004008B04013O0004563O008B0401001215000400013O001215000500013O00067300050075040100040004563O007504012O0046010500234O00230005000100024O000500063O00122O00050037012O00122O00060038012O00062O0006008B040100050004563O008B04012O0046010500063O0006250105008B04013O0004563O008B04012O0046010500123O00122000060039012O00122O0007003A015O0005000700024O000600066O0005000500064O000500023O00044O008B04010004563O007504012O0046010400244O002601040001000200061801040093040100010004563O009304010012150004003B012O0012150005003C012O000673000400CC040100050004563O00CC0401001215000400014O0058010500063O0012150007003D012O0012150008003E012O000694000800C1040100070004563O00C104010012150007001F3O000673000700C1040100040004563O00C104010012150007003F012O0012150008003F012O0006730007009C040100080004563O009C0401001215000700013O0006730005009C040100070004563O009C0401001215000600013O00121500070040012O00121500080041012O000694000800A4040100070004563O00A40401001215000700013O000673000600A4040100070004563O00A404012O0046010700254O00260107000100022O00A2000700064O0046010700063O000618010700B5040100010004563O00B5040100121500070042012O00121500080043012O000610010800CC040100070004563O00CC04012O0046010700123O00122000080044012O00122O00090045015O0007000900024O000800066O0007000700084O000700023O00044O00CC04010004563O00A404010004563O00CC04010004563O009C04010004563O00CC040100121500070046012O00121500080047012O00061001080095040100070004563O00950401001215000700013O00067300040095040100070004563O00950401001215000500014O0058010600063O0012150004001F3O0004563O009504010012150003001F3O00121500040048012O00121500050049012O0006940004008E050100050004563O008E05010012150004004A012O0012150005004B012O0006940004008E050100050004563O008E0501001215000400683O0006730003008E050100040004563O008E05012O0046010400024O001A010500123O00122O0006004C012O00122O0007004D015O0005000700024O00040004000500202O0004000400394O00040002000200062O000400E904013O0004563O00E904012O00460104001C3O0012D30006004E015O00040004000600122O0006000E6O00040006000200062O000400ED040100010004563O00ED04010012150004004F012O00121500050050012O00069400050003050100040004563O0003050100121500040051012O00121500050052012O00069400050003050100040004563O000305012O0046010400143O00205301040004003D4O000500023O00122O00060053015O0005000500064O0006002A6O00040006000200062O000400FE040100010004563O00FE040100121500040054012O001215000500E43O00069400050003050100040004563O000305012O0046010400123O00121500050055012O00121500060056013O006A000400064O005101045O00121500040057012O00121500050058012O0006100104002A050100050004563O002A050100121500040059012O0012150005005A012O0006940005002A050100040004563O002A05012O0046010400024O001A010500123O00122O0006005B012O00122O0007005C015O0005000700024O00040004000500202O0004000400394O00040002000200062O0004002A05013O0004563O002A05012O00460104001C3O00129F0006004E015O00040004000600122O0006000E6O00040006000200062O0004002A05013O0004563O002A05012O0046010400143O00201800040004003D4O000500023O00122O0006005D015O0005000500064O0006002A6O00040006000200062O0004002A05013O0004563O002A05012O0046010400123O0012150005005E012O0012150006005F013O006A000400064O005101046O0046010400024O001A010500123O00122O00060060012O00122O00070061015O0005000700024O00040004000500202O0004000400394O00040002000200062O0004006B05013O0004563O006B05012O00460104001C3O00128200060062015O0004000400064O000600023O00122O00070063015O0006000600074O00040006000200062O0004006B05013O0004563O006B05012O00460104001C3O0020F50004000400832O00460106000E4O002A0104000600020006180104006B050100010004563O006B05012O0046010400013O0020A30004000400974O000600016O000700016O00040007000200062O0004006B050100010004563O006B05012O00460104000A3O00121500050064012O0006100104006B050100050004563O006B05012O0046010400273O0012150005001F3O00063B00050005000100040004563O005605012O0046010400083O00121500050065012O0006940004006B050100050004563O006B050100121500040066012O00121500050066012O0006730004006B050100050004563O006B050100121500040067012O00121500050068012O0006100105006B050100040004563O006B05012O0046010400143O00206E00040004003D4O000500023O00122O00060063015O0005000500064O00040002000200062O0004006B05013O0004563O006B05012O0046010400123O00121500050069012O0012150006006A013O006A000400064O005101046O0046010400024O0055000500123O00122O0006006B012O00122O0007006C015O0005000700024O00040004000500202O0004000400394O00040002000200062O0004007D050100010004563O007D05010012150004006D012O0012150005006E012O0006AE0004007D050100050004563O007D0501001215000400FA3O0012150005006F012O00061001040039060100050004563O003906012O0046010400143O00207E00040004003D4O000500023O00202O0005000500CF4O00040002000200062O00040088050100010004563O0088050100121500040070012O00121500050071012O00061001050039060100040004563O003906012O0046010400123O00128900050072012O00122O00060073015O000400066O00045O00044O003906010012150004001F3O00067300030049040100040004563O00490401001215000400013O00121500050074012O00121500060075012O00061001050013060100060004563O001306010012150005001F3O00067300040013060100050004563O00130601001215000500013O0012150006001F3O0006AE000500A1050100060004563O00A1050100121500060076012O00121500070077012O000694000700A3050100060004563O00A30501001215000400683O0004563O0013060100121500060078012O00121500070079012O0006100106009A050100070004563O009A05010012150006007A012O0012150007007B012O0006100106009A050100070004563O009A0501001215000600013O0006730005009A050100060004563O009A05012O0046010600024O001A010700123O00122O0008007C012O00122O0009007D015O0007000900024O00060006000700202O0006000600394O00060002000200062O000600CC05013O0004563O00CC05012O00460106001C3O00124001080062015O0006000600084O000800023O00202O0008000800CF4O00060008000200062O000600CC05013O0004563O00CC05012O00460106000A4O004D010700213O00122O0008007E015O000900056O0007000900024O000800223O00122O0009007E015O000A00056O0008000A00024O00070007000800062O000700D0050100060004563O00D005010012150006007F012O00121500070080012O000673000600E6050100070004563O00E6050100121500060081012O00121500070081012O000673000600DD050100070004563O00DD05012O0046010600143O00205301060006003D4O000700023O00122O00080082015O0007000700084O0008002A6O00060008000200062O000600E1050100010004563O00E1050100121500060083012O00121500070084012O000694000600E6050100070004563O00E605012O0046010600123O00121500070085012O00121500080086013O006A000600084O005101065O00121500060087012O00121500070088012O00069400060011060100070004563O001106012O0046010600024O001A010700123O00122O00080089012O00122O0009008A015O0007000900024O00060006000700202O0006000600394O00060002000200062O000600FC05013O0004563O00FC05012O00460106001C3O00125300080062015O0006000600084O000800023O00202O0008000800CF4O00060008000200062O00062O00060100010004564O0006010012150006008B012O0012150007008C012O00069400070011060100060004563O001106010012150006008D012O0012150007006C3O00069400070011060100060004563O001106012O0046010600143O00206E00060006003D4O000700023O00122O0008008E015O0007000700084O00060002000200062O0006001106013O0004563O001106012O0046010600123O0012150007008F012O00121500080090013O006A000600084O005101065O0012150005001F3O0004563O009A0501001215000500683O00067300040018060100050004563O00180601001215000300683O0004563O00490401001215000500013O0006AE0005001F060100040004563O001F060100121500050091012O00121500060092012O00069400060092050100050004563O009205012O00460105002B4O00260105000100022O00A2000500064O0046010500063O00061801050029060100010004563O0029060100121500050093012O00121500060094012O00069400060030060100050004563O003006012O0046010500123O00129000060095012O00122O00070096015O0005000700024O000600066O0005000500064O000500023O0012150004001F3O0004563O009205010004563O004904010004563O003906010004563O004504010004563O003906010004563O003004010004563O003906010004563O000100012O00713O00017O00033O0003053O005072696E7403293O00F45EB5A1DA5CE19FD44CB4A89B49B8EDFE5BA8AE950B92B8CB5BAEBFCF4EA5EDD952E18AD441A8BFDA03043O00CDBB2BC100084O005C016O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

