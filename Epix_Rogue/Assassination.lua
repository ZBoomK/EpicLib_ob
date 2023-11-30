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
				if (Enum <= 168) then
					if (Enum <= 83) then
						if (Enum <= 41) then
							if (Enum <= 20) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local B = Inst[3];
												local K = Stk[B];
												for Idx = B + 1, Inst[4] do
													K = K .. Stk[Idx];
												end
												Stk[Inst[2]] = K;
											end
										elseif (Enum <= 2) then
											Stk[Inst[2]] = #Stk[Inst[3]];
										elseif (Enum > 3) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
										end
									elseif (Enum <= 6) then
										if (Enum == 5) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
									elseif (Enum <= 7) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									elseif (Enum == 8) then
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
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum > 10) then
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
									elseif (Enum <= 12) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 17) then
									if (Enum <= 15) then
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 16) then
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
								elseif (Enum <= 18) then
									local Edx;
									local Results, Limit;
									local A;
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
								elseif (Enum == 19) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum <= 30) then
								if (Enum <= 25) then
									if (Enum <= 22) then
										if (Enum == 21) then
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
											if (Stk[Inst[2]] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 23) then
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
									elseif (Enum > 24) then
										Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
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
								elseif (Enum <= 27) then
									if (Enum > 26) then
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
									else
										Upvalues[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 28) then
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
								elseif (Enum == 29) then
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
							elseif (Enum <= 35) then
								if (Enum <= 32) then
									if (Enum == 31) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 33) then
									local Edx;
									local Results, Limit;
									local A;
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
								elseif (Enum > 34) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								else
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
									end
								end
							elseif (Enum <= 38) then
								if (Enum <= 36) then
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
								elseif (Enum > 37) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 39) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 40) then
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
							end
						elseif (Enum <= 62) then
							if (Enum <= 51) then
								if (Enum <= 46) then
									if (Enum <= 43) then
										if (Enum > 42) then
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
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum <= 44) then
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 45) then
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
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 48) then
									if (Enum > 47) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 49) then
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
								elseif (Enum == 50) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 56) then
								if (Enum <= 53) then
									if (Enum == 52) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 54) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								elseif (Enum == 55) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 59) then
								if (Enum <= 57) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 58) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 60) then
								local B;
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 72) then
							if (Enum <= 67) then
								if (Enum <= 64) then
									if (Enum > 63) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 65) then
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
									A = Inst[2];
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
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								elseif (Enum == 66) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 69) then
								if (Enum == 68) then
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
							elseif (Enum <= 70) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 71) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 77) then
							if (Enum <= 74) then
								if (Enum == 73) then
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
							elseif (Enum <= 75) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 76) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 80) then
							if (Enum <= 78) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 79) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 81) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 82) then
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
							if (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 125) then
						if (Enum <= 104) then
							if (Enum <= 93) then
								if (Enum <= 88) then
									if (Enum <= 85) then
										if (Enum > 84) then
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
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 86) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 87) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
										end
									elseif (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 90) then
									if (Enum > 89) then
										Stk[Inst[2]] = Inst[3] ~= 0;
									else
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 91) then
									local A;
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
								elseif (Enum > 92) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 98) then
								if (Enum <= 95) then
									if (Enum > 94) then
										local B;
										local A;
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 96) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum > 97) then
									local A;
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 101) then
								if (Enum <= 99) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 100) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 102) then
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
							elseif (Enum == 103) then
								local A = Inst[2];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 114) then
							if (Enum <= 109) then
								if (Enum <= 106) then
									if (Enum > 105) then
										local B;
										local A;
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
								elseif (Enum <= 107) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 108) then
									if (Inst[2] ~= Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 111) then
								if (Enum > 110) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 112) then
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
							elseif (Enum == 113) then
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
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 119) then
							if (Enum <= 116) then
								if (Enum > 115) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local A;
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
								end
							elseif (Enum <= 117) then
								local A;
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
							elseif (Enum == 118) then
								Stk[Inst[2]] = -Stk[Inst[3]];
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
						elseif (Enum <= 122) then
							if (Enum <= 120) then
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
							elseif (Enum > 121) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Mvm[1] == 337) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 123) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 124) then
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						end
					elseif (Enum <= 146) then
						if (Enum <= 135) then
							if (Enum <= 130) then
								if (Enum <= 127) then
									if (Enum == 126) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 128) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									VIP = Inst[3];
								elseif (Enum == 129) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 132) then
								if (Enum == 131) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								end
							elseif (Enum <= 133) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							elseif (Enum == 134) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 140) then
							if (Enum <= 137) then
								if (Enum == 136) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 138) then
								local A;
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
							elseif (Enum > 139) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 143) then
							if (Enum <= 141) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							elseif (Enum > 142) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 144) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 145) then
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
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 157) then
						if (Enum <= 151) then
							if (Enum <= 148) then
								if (Enum > 147) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum > 150) then
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
						elseif (Enum <= 154) then
							if (Enum <= 152) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 153) then
								local A;
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
								Stk[A] = Stk[A]();
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
						elseif (Enum <= 155) then
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
						elseif (Enum == 156) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 162) then
						if (Enum <= 159) then
							if (Enum > 158) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 160) then
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
							A = Inst[2];
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
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 165) then
						if (Enum <= 163) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 166) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 167) then
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
					if (Enum <= 210) then
						if (Enum <= 189) then
							if (Enum <= 178) then
								if (Enum <= 173) then
									if (Enum <= 170) then
										if (Enum == 169) then
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
											Stk[Inst[2]] = Stk[Inst[3]];
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
											if (Inst[2] < Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 171) then
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
									elseif (Enum > 172) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
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
								elseif (Enum <= 175) then
									if (Enum == 174) then
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									else
										local B;
										local T;
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
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 176) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 177) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 183) then
								if (Enum <= 180) then
									if (Enum > 179) then
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
								elseif (Enum <= 181) then
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
								elseif (Enum > 182) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									A = Inst[2];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 186) then
								if (Enum <= 184) then
									local A;
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
								elseif (Enum > 185) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									Stk[Inst[2]]();
								end
							elseif (Enum <= 187) then
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
							elseif (Enum > 188) then
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 199) then
							if (Enum <= 194) then
								if (Enum <= 191) then
									if (Enum == 190) then
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
								elseif (Enum <= 192) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Enum > 193) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 197) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
						elseif (Enum <= 204) then
							if (Enum <= 201) then
								if (Enum == 200) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 202) then
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
							elseif (Enum == 203) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 207) then
							if (Enum <= 205) then
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 206) then
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
						elseif (Enum <= 208) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						elseif (Enum == 209) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 231) then
						if (Enum <= 220) then
							if (Enum <= 215) then
								if (Enum <= 212) then
									if (Enum == 211) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 213) then
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
								elseif (Enum > 214) then
									local Edx;
									local Results, Limit;
									local A;
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
								elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 217) then
								if (Enum > 216) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = {};
								end
							elseif (Enum <= 218) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 219) then
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								local Edx;
								local Results, Limit;
								local A;
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
							end
						elseif (Enum <= 225) then
							if (Enum <= 222) then
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
							elseif (Enum <= 223) then
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
							elseif (Enum == 224) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							else
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							end
						elseif (Enum <= 228) then
							if (Enum <= 226) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 227) then
								local Edx;
								local Results, Limit;
								local A;
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
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 229) then
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
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
						elseif (Enum == 230) then
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
							local B = Stk[Inst[4]];
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 242) then
						if (Enum <= 236) then
							if (Enum <= 233) then
								if (Enum > 232) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 234) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 235) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 239) then
							if (Enum <= 237) then
								Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
							elseif (Enum > 238) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 240) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 241) then
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
					elseif (Enum <= 247) then
						if (Enum <= 244) then
							if (Enum > 243) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								A = Inst[2];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 245) then
							local A;
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
						elseif (Enum == 246) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 250) then
						if (Enum <= 248) then
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
						elseif (Enum > 249) then
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
							if (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Inst[2] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 251) then
						local A = Inst[2];
						do
							return Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum == 252) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					end
				elseif (Enum <= 295) then
					if (Enum <= 274) then
						if (Enum <= 263) then
							if (Enum <= 258) then
								if (Enum <= 255) then
									if (Enum == 254) then
										local Edx;
										local Results;
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
								elseif (Enum <= 256) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 257) then
									local A = Inst[2];
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
							elseif (Enum <= 260) then
								if (Enum == 259) then
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
									Stk[Inst[2]] = {};
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
								end
							elseif (Enum <= 261) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 262) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 268) then
							if (Enum <= 265) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 267) then
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
						elseif (Enum <= 271) then
							if (Enum <= 269) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 270) then
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
						elseif (Enum <= 272) then
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
						elseif (Enum == 273) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						else
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 284) then
						if (Enum <= 279) then
							if (Enum <= 276) then
								if (Enum > 275) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								else
									local A = Inst[2];
									Stk[A] = Stk[A]();
								end
							elseif (Enum <= 277) then
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
							elseif (Enum == 278) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 281) then
							if (Enum == 280) then
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
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 282) then
							local B;
							local A;
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 283) then
							local B;
							local A;
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 289) then
						if (Enum <= 286) then
							if (Enum == 285) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							elseif (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 287) then
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
						elseif (Enum > 288) then
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
					elseif (Enum <= 292) then
						if (Enum <= 290) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 291) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 293) then
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
					elseif (Enum > 294) then
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
				elseif (Enum <= 316) then
					if (Enum <= 305) then
						if (Enum <= 300) then
							if (Enum <= 297) then
								if (Enum > 296) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									A = Inst[2];
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
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								end
							elseif (Enum <= 298) then
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							elseif (Enum == 299) then
								local B;
								local Edx;
								local Results, Limit;
								local A;
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
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 302) then
							if (Enum > 301) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 303) then
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
						elseif (Enum == 304) then
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
						end
					elseif (Enum <= 310) then
						if (Enum <= 307) then
							if (Enum == 306) then
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
						elseif (Enum <= 308) then
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
						elseif (Enum > 309) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 313) then
						if (Enum <= 311) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A]());
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 312) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 314) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 315) then
						local A;
						Stk[Inst[2]] = Stk[Inst[3]];
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
						Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Upvalues[Inst[3]] = Stk[Inst[2]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 327) then
					if (Enum <= 321) then
						if (Enum <= 318) then
							if (Enum > 317) then
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 319) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 320) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						else
							local Edx;
							local Results, Limit;
							local A;
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
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 324) then
						if (Enum <= 322) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 323) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
					elseif (Enum <= 325) then
						if (Inst[2] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 326) then
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
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						VIP = Inst[3];
					end
				elseif (Enum <= 332) then
					if (Enum <= 329) then
						if (Enum > 328) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 330) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 331) then
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						if (Stk[Inst[2]] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 335) then
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
					elseif (Enum > 334) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 336) then
					local A;
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					VIP = Inst[3];
				elseif (Enum == 337) then
					Stk[Inst[2]] = Stk[Inst[3]];
				else
					VIP = Inst[3];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD989C819C4C6E404F5A8C60DC2CAD524F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O00E6164ACA784C2BC41346ED666D37C21550DB497F30CA094D9C4B6B2503073O0044A36623B2271E002E3O0012E63O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001000452012O000A0001001260000300063O00201C010400030007001260000500083O00201C010500050009001260000600083O00201C01060006000A00067900073O000100062O0051012O00064O0051017O0051012O00044O0051012O00014O0051012O00024O0051012O00053O00201C01080003000B00201C01090003000C2O00D8000A5O001260000B000D3O000679000C0001000100022O0051012O000A4O0051012O000B4O0051010D00073O002O12010E000E3O002O12010F000F4O0002010D000F0002000679000E0002000100032O0051012O00074O0051012O00094O0051012O00084O0034000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O002D00025O00122O000300016O00045O00122O000500013O00042O0003002100012O001100076O0077000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0011000C00034O0018000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0091000C6O0067000A3O0002002085000A000A00022O00520009000A4O00E400073O000100040E0103000500012O0011000300054O0051010400024O00FB000300044O007200036O00293O00017O00143O00028O00025O00A06040025O00C89540026O00F03F026O007B40025O00F07E40025O00805040025O00C09640025O00708B40025O002CA940025O00C06F40025O00B2A940025O002EA540025O00088640025O0094A340025O004CAA40025O00C05E40025O00508740025O005CB140025O00F08B40014E3O002O12010200014O002C010300053O002E0F0002000900010003000452012O000900010026D20002000900010001000452012O00090001002O12010300014O002C010400043O002O12010200043O0026D20002000200010004000452012O000200012O002C010500053O0026D20003004300010004000452012O00430001002O12010600014O002C010700073O00262E0006001400010001000452012O00140001002E45010500FEFF2O0006000452012O00100001002O12010700013O002E0F0007001500010008000452012O001500010026D20007001500010001000452012O0015000100262E0004001D00010001000452012O001D0001002E57000A003500010009000452012O00350001002O12010800013O00262E0008002200010004000452012O00220001002E57000C00240001000B000452012O00240001002O12010400043O000452012O0035000100262E0008002800010001000452012O00280001002E57000D001E0001000E000452012O001E00012O001100096O0044000500093O00062C0005002E00013O000452012O002E0001002E57001000330001000F000452012O003300012O0011000900014O0051010A6O0022000B6O005800096O007200095O002O12010800043O000452012O001E0001000E6D0004003900010004000452012O00390001002E0F0012000E00010011000452012O000E00012O0051010800054O002200096O005800086O007200085O000452012O000E0001000452012O00150001000452012O000E0001000452012O00100001000452012O000E0001000452012O004D000100262E0003004700010001000452012O00470001002E570013000C00010014000452012O000C0001002O12010400014O002C010500053O002O12010300043O000452012O000C0001000452012O004D0001000452012O000200012O00293O00017O00623O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00CF47A24AF003043O00269C37C7030A3O008568703C1A47EA46A47103083O0023C81D1C4873149A03043O0030ABD4D203073O005479DFB1BFED4C03053O009657CAB23503083O00A1DB36A9C05A305003053O00795005365A03043O004529226003073O009FCCDA070D25AF03063O004BDCA3B76A6203083O0027AC8E25C00DB48E03053O00B962DAEB572O033O00C5292A03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D03043O000EC1517E03083O00876CAE3E121E179303043O006D6174682O033O00BBE02403083O00A7D6894AAB78CE532O033O008AF22103063O00C7EB90523D982O033O000A17A103043O004B6776D9030B3O00E45563008911C858791ABE03063O007EA7341074D903053O00706169727303053O00CE222F8FA603073O009CA84E40E0D47903073O00E18E1BF336E04B03073O0038A2E1769E598E03083O007913C5BD3BD7520003063O00B83C65A0CF4203073O00128D71B13E8C6F03043O00DC51E21C03053O0021DA85EEEF03063O00A773B5E29B8A03053O00D02DE0497E03073O00A68242873C1B11030D3O006559DD74235743C074244D45C003053O0050242AAE1503053O007C1F306F4B03043O001A2E7057030D3O009830B8752OAC4CBAB837A27BB103083O00D4D943CB142ODF2503053O008882AFC7BF03043O00B2DAEDC8030D3O0097A6F5D1A5A6EFDEB7A1EFDFB803043O00B0D6D58603113O00D5A1B1D1BC5E58E69DA3CEB25A5CD6A2AE03073O003994CDD6B4C83603133O0033EE3D31651DFB213C7337F037316401F2203803053O0016729D555403113O00F3C207CC58E4AAC5D918D77FE4A9CAC81B03073O00C8A4AB73A43D96030A3O005370652O6C4861737465027O0040026O00F03F028O00030C3O0047657445717569706D656E74026O002A40026O002C4003103O005265676973746572466F724576656E7403183O008ED8227CA68CCB2674B697C42E60AD8ACB206DA290D3266103053O00E3DE94632503053O00115E5BF8FD03053O0099532O329603163O007E7760083389415478775C3B82434973610E66BB591403073O002D3D16137C13CB030A3O00EA1B09FB07698AC91D1903073O00D9A1726D956210031C3O0031212B68FC5F1B243679A53421283768FC3C3B2E2C79AE6607302C3503063O00147240581CDC03073O00140FC4B1F6DFB003073O00DD5161B2D498B003153O00526567697374657244616D616765466F726D756C6103083O00A9D414B03330DC8103073O00A8E4A160D95F5103063O0053657441504C025O00307040004F023O001F2O0100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0004000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F4O00105O00122O0011001A3O00122O0012001B6O0010001200024O000F000F00104O00105O00122O0011001C3O00122O0012001D6O0010001200024O000F000F00104O00105O00122O0011001E3O00122O0012001F6O0010001200024O0010000400104O00115O00122O001200203O00122O001300216O0011001300024O0010001000114O00115O002O12011200223O0012EE001300236O0011001300024O00100010001100122O001100246O00125O00122O001300253O00122O001400266O0012001400024O00110011001200122O001200246O00135O00122O001400273O00122O001500286O0013001500024O00120012001300122O001300246O00145O00122O001500293O00122O0016002A6O0014001600024O0013001300144O00148O00158O00168O00175O00122O0018002B3O00122O0019002C6O0017001900024O00170004001700122O0018002D3O00122O001900246O001A5O00122O001B002E3O00122O001C002F6O001A001C00024O00190019001A4O001A00423O00067900433O000100242O0051012O001D4O00118O0051012O001E4O0051012O001A4O0051012O001C4O0051012O00384O0051012O00394O0051012O003A4O0051012O003B4O0051012O001F4O0051012O00204O0051012O00214O0051012O00224O0051012O00284O0051012O002D4O0051012O002E4O0051012O002F4O0051012O00234O0051012O00254O0051012O00264O0051012O00274O0051012O003C4O0051012O003D4O0051012O003E4O0051012O003F4O0051012O00304O0051012O00314O0051012O00324O0051012O00334O0051012O00404O0051012O00424O0051012O00414O0051012O00344O0051012O00354O0051012O00364O0051012O00374O002800445O00122O004500303O00122O004600316O0044004600024O0044000400444O00455O00122O004600323O00122O004700336O0045004700022O00440044004400452O002800455O00122O004600343O00122O004700356O0045004700024O0045000400454O00465O00122O004700363O00122O004800376O0046004800022O00440045004500462O002800465O00122O004700383O00122O004800396O0046004800024O0046000A00464O00475O00122O0048003A3O00122O0049003B6O0047004900022O00440046004600472O002800475O00122O0048003C3O00122O0049003D6O0047004900024O0047000D00474O00485O00122O0049003E3O00122O004A003F6O0048004A00022O00440047004700482O002800485O00122O004900403O00122O004A00416O0048004A00024O0048000C00484O00495O00122O004A00423O00122O004B00436O0049004B00022O00440048004800492O00D8004900034O0028004A5O00122O004B00443O00122O004C00456O004A004C00024O004A0048004A4O004B5O00122O004C00463O00122O004D00476O004B004D00022O00AF004B0048004B4O004C5O00122O004D00483O00122O004E00496O004C004E00024O004C0048004C4O0049000300012O002C014A00523O0020A000530008004A4O00530002000200102O0053004B005300202O00540008004A4O00540002000200102O0054004C00544O005500663O00122O0067004D3O00202O00680008004E4O00680002000200201C01690068004F00062C006900F100013O000452012O00F100012O00510169000C3O00201C016A0068004F2O00290169000200020006A9006900F400010001000452012O00F400012O00510169000C3O002O12016A004D4O002901690002000200201C016A0068005000062C006A00FC00013O000452012O00FC00012O0051016A000C3O00201C016B006800502O0029016A000200020006A9006A00FF00010001000452012O00FF00012O0051016A000C3O002O12016B004D4O0029016A00020002000679006B0001000100032O0051012O00694O0051012O006A4O0051012O00674O0051016C006B4O00B9006C00010001002065006C00040051000679006E0002000100062O0051012O00684O0051012O00084O0051012O00694O0051012O000C4O0051012O006A4O0051012O006B4O0003016F5O00122O007000523O00122O007100536O006F00716O006C3O00014O006C00026O006D00034O0028006E5O00122O006F00543O00122O007000556O006E007000024O006E0046006E4O006F5O00122O007000563O00122O007100576O006F00710002000219007000034O00DC006D000300012O00D8006E00034O0028006F5O00122O007000583O00122O007100596O006F007100024O006F0046006F4O00705O00122O0071005A3O00122O0072005B6O00700072000200067900710004000100012O0051012O00554O00DC006E000300012O00DC006C000200012O0011006D5O0012E8006E005C3O00122O006F005D6O006D006F00024O006D0046006D00202O006D006D005E000679006F0005000100072O0051012O00084O0051012O00554O0051012O00094O0051012O00464O00118O00113O00014O00113O00024O0059006D006F00012O0011006D5O0012E8006E005F3O00122O006F00606O006D006F00024O006D0046006D00202O006D006D005E000679006F0006000100032O00113O00014O0051012O00084O00113O00024O0059006D006F0001000679006D0007000100022O0051012O00084O0051012O00463O000679006E0008000100052O0051012O006D4O00113O00014O0051012O00084O00113O00024O0051012O00463O000679006F0009000100042O0051012O00084O0051012O00464O00113O00014O00113O00023O0006790070000A000100042O0051012O00084O0051012O00464O00113O00014O00113O00023O0006790071000B000100052O0051012O00504O0051012O00714O00118O0051012O00094O0051012O00083O0006790072000C000100052O0051012O00094O0051012O00464O0051012O00084O00118O0051012O00043O0006790073000D000100032O0051012O00464O00118O0051012O00043O0006790074000E000100052O0051012O00464O00118O0051012O00084O0051012O00114O0051012O00503O0002190075000F3O00067900760010000100062O0051012O00094O0051012O00184O0051012O00444O0051012O000E4O0051012O00274O0051012O004F3O00067900770011000100062O0051012O00274O0051012O004F4O0051012O00094O00118O0051012O00184O0051012O00513O00067900780012000100032O0051012O00094O0051012O00044O0051012O00193O00067900790013000100012O0051012O00463O000679007A0014000100012O0051012O00463O000679007B0015000100052O0051012O00464O00118O0051012O00044O0051012O00304O0051012O00093O000679007C00160001000C2O0051012O00464O00118O0051012O00094O0051012O00754O0051012O00564O0051012O00504O0051012O002C4O0051012O00084O0051012O000E4O0051012O00324O0051012O00314O0051012O00113O000679007D0017000100042O0051012O00524O0051012O00444O0051012O00494O0051012O00163O000679007E0018000100192O0051012O00464O00118O0051012O00094O0051012O00044O0051012O000E4O0051012O00524O0051012O007D4O0051012O00084O0051012O006F4O0051012O006E4O0051012O007C4O0051012O00554O0051012O00344O00113O00014O0051012O00624O00113O00024O0051012O00334O0051012O00304O0051012O007B4O0051012O00404O0051012O000F4O0051012O00604O0051012O00654O0051012O00324O0051012O003E3O000679007F00190001001A2O0051012O00554O0051012O00094O0051012O00464O0051012O00084O0051012O000E4O0051012O004C4O00118O0051012O003E4O0051012O00654O0051012O006D4O0051012O00154O0051012O00504O0051012O00184O0051012O004F4O0051012O00754O0051012O00584O0051012O006F4O0051012O00564O00113O00014O0051012O000F4O00113O00024O0051012O006E4O0051012O00454O0051012O00704O0051012O005A4O0051012O00773O0006790080001A0001001D2O0051012O00464O00118O0051012O00554O0051012O005B4O00113O00014O0051012O000F4O00113O00024O0051012O00644O0051012O00754O0051012O00574O0051012O00094O0051012O00454O0051012O00594O0051012O000E4O0051012O004C4O0051012O00154O0051012O00664O0051012O00764O0051012O00514O0051012O00564O0051012O006E4O0051012O00534O0051012O00504O0051012O00624O0051012O00184O0051012O004F4O0051012O00584O0051012O005A4O0051012O00173O0006790081001B0001001D2O0051012O00464O00118O0051012O00084O0051012O00094O0051012O00174O0051012O004C4O0051012O00504O0051012O00184O0051012O00514O0051012O000E4O0051012O00654O0051012O004D4O0051012O00154O0051012O00444O0051012O004E4O0051012O00794O0051012O007A4O0051012O006E4O0051012O00044O0051012O00554O0051012O005F4O0051012O00454O0051012O00564O0051012O00164O0051012O005E4O00113O00014O0051012O000F4O00113O00024O0051012O004F3O0006790082001C000100342O0051012O00434O0051012O00144O00118O0051012O00154O0051012O00524O0051012O00454O0051012O00084O0051012O00444O0051012O00464O0051012O00164O0051012O004C4O0051012O00094O0051012O004D4O0051012O00044O0051012O00354O0051012O00554O00113O00014O00113O00024O0051012O000E4O0051012O00504O0051012O006F4O0051012O006E4O0051012O007F4O0051012O007E4O0051012O00814O0051012O00804O0051012O00614O0051012O00624O0051012O00634O0051012O00644O0051012O001A4O0051012O005F4O0051012O00724O0051012O00604O0051012O00734O0051012O00664O0051012O00744O0051012O00654O0051012O004E4O0051012O004F4O0051012O00514O0051012O00534O0051012O00544O0051012O00594O0051012O00394O0051012O005A4O0051012O003A4O0051012O005E4O0051012O00714O0051012O00564O0051012O00574O0051012O00583O0006790083001D000100032O0051012O00464O00118O0051012O00043O0020FF00840004006100122O008500626O008600826O008700836O0084008700016O00013O001E3O00A93O00028O00025O00809540025O00388240026O00F03F025O00F6A240025O002EA340030C3O004570696353652O74696E677303083O008BECCFD0B1E7DCD703043O00A4D889BB03113O00FAE330BEAFF00CE2E925BBA9F025D3EB3403073O006BB28651D2C69E03083O002O0B96D2A336099103053O00CA586EE2A6030F3O00EB0A83FBC3CD08B2F8DECA008CDFFA03053O00AAA36FE297027O004003083O0034EBB1DA0EE0A2DD03043O00AE678EC5030A3O00633B5A0A245DF157244C03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E03103O006D4D000122EC1E5150021928F91B575003073O0072383E6549478D026O00184003083O0063BFD5AF59B4C6A803043O00DB30DAA1030A3O00D7657948D75BE8CB5E5F03073O008084111C29BB2F03083O003237122E540F351503053O003D6152665A03103O008920BD4EC958132D8109844DC1441B1D03083O0069CC4ECB2BA7377E03083O0096AF370A1A0AC04203083O0031C5CA437E7364A703113O001A4ECB208C574A327FF20EAF5058245ECB03073O003E573BBF49E03603083O00D407EEDDEE0CFDDA03043O00A987629A03143O00EA7B3355E420FBDE702351EE27EFCA65365BE93603073O00A8AB1744349D53026O001C40025O0082AA40025O0052A54003083O002235A62C47392E0203073O00497150D2582E57030E3O00B43FC83AE28020D91AF49523C31703053O0087E14CAD7203083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030D3O0085D811FC6CFEBEC91FFE7DDE9D03063O0096CDBD70901803083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FD1113D6A46E93C40B30DAA274B5C00A0903073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103163O0085A70541A4F9DABCBD3E4ABAF2F8A4A00541BAE2DCB803073O00AFCCC97124D68B026O000840025O004FB04003083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC03133O0009BC847CF170772EA69555D1766C3DBB8843ED03073O00185CCFE12C831903083O0078D6AC5812734CC003063O001D2BB3D82C7B030C3O008EED0D4A99F833688DEA036803043O002CDDB940026O001040025O00E8B140025O00789D4003083O0032E25C4B7A0FE05B03053O00136187283F03133O00855537352A289D543C2F063FBA5921293A21BA03063O0051CE3C535B4F03083O007DAEC46626CD4AB703083O00C42ECBB0124FA32D030A3O008A237D1725F7FC9F015A03073O008FD8421E7E449B03083O0074C921C80D49CB2603053O006427AC55BC03123O008476AD8521BF6DA99407A56ABC933BA274BD03053O0053CD18D9E003083O00D5C0D929EFCBCA2E03043O005D86A5AD030D3O008EFDC8D135C0807BB8E0C4D13203083O001EDE92A1A25AAED203083O00D64B641EEC40771903043O006A852E1003133O00682F7AEF554E6A2575EE5F5350037CF158414C03063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A92030E3O006B5745FA7082AA1E552O42D97AB203083O006B39362B9D15E6E7025O004C9040025O00D0A14003083O00C774E1B92C2380E703073O00E7941195CD454D03123O00B0A8D3F258F1B4BED7FE64FA8CA2C4EF52FB03063O009FE0C7A79B3703083O00C4F628C6FEFD3BC103043O00B297935C030F3O00A9E55F331C4B6F85F34D26176B59A803073O001AEC9D2C52722C025O00D88440025O00C05140026O002040025O0082B140025O00D2A54003083O00192BC14F2320D24803043O003B4A4EB5030C3O000ED8545DA027D0545F9406F503053O00D345B12O3A03083O0084E06DE1E0C5B0F603063O00ABD78519958903073O00D2C03BECC813D803083O002281A8529A8F509C025O00888140025O00A7B14003083O0099CD19DFCCADD0F203083O0081CAA86DABA5C3B7030D3O00105934D1DF18F50D5E31FFFD3003073O0086423857B8BE7403083O000F341DAF10E52O2603083O00555C5169DB798B41030C3O00CBB25E4C6FD7D2B556625FFB03063O00BF9DD330251C03083O00EC1AE00833D118E703053O005ABF7F947C03113O004B8F2F1377900A1676842B387E8109345C03043O007718E74E03083O00B128B15ED54E169103073O0071E24DC52ABC2003103O000E1EFDA62E1AF1813F17DBB33C31D79103043O00D55A7694026O00144003083O00B6B7271F41408E9603073O00E9E5D2536B282E030F3O00E54733C20DCC4320DD2AC74415F52103053O0065A12252B603083O00DB084DEAD2EC853D03083O004E886D399EBB82E2031B3O001731FDF82D3CEBF83336F7F02A3ADAF02C31F8F63B10FFF7191CDD03043O00915E5F9903083O00CEC800C147B9FADE03063O00D79DAD74B52E030A3O001EBD88F9F533B2ACD1FE03053O00BA55D4EB92025O00288540025O0068964003083O00682BA042445529A703053O002D3B4ED436030F3O0033592O8FA422A2FF1479858DA10D8903083O00907036E3EBE64ECD03083O00802D1BE8D955B43B03063O003BD3486F9CB003143O006386F1264B83E5225CA3E62C5A8FCC2B48A0C00903043O004D2EE78303083O008951A254B35AB15303043O0020DA34D6030D3O006D0538A5E2BF4B6C47163D80C103083O003A2E7751C891D02503083O00188924B8A0B3313803073O00564BEC50CCC9DD03073O0054447E8BEAA34203063O00EB122117E59E001B022O002O12012O00014O002C2O0100013O002E0F0003000200010002000452012O000200010026D23O000200010001000452012O00020001002O122O0100013O000EF90001004D00010001000452012O004D0001002O12010200013O000E6D0004000E00010002000452012O000E0001002E450105002100010006000452012O002D0001001260000300074O00B7000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400062O0003001C00010001000452012O001C0001002O12010300014O001A00035O001226010300076O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400062O0003002B00010001000452012O002B0001002O12010300014O001A000300023O002O12010200103O0026D20002003100010010000452012O00310001002O122O0100043O000452012O004D00010026D20002000A00010001000452012O000A0001001260000300074O00D3000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000300033O00122O000300076O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000300043O00122O000200043O000452012O000A0001000EF90019008600010001000452012O00860001001260000200074O0051000300013O00122O0004001A3O00122O0005001B6O0003000500024O0002000200034O000300013O00122O0004001C3O00122O0005001D6O0003000500024O0002000200034O000200053O00122O000200076O000300013O00122O0004001E3O00122O0005001F6O0003000500024O0002000200034O000300013O00122O000400203O00122O000500216O0003000500024O00020002000300062O0002006900010001000452012O00690001002O12010200044O001A000200063O001226010200076O000300013O00122O000400223O00122O000500236O0003000500024O0002000200034O000300013O00122O000400243O00122O000500256O0003000500024O00020002000300062O0002007800010001000452012O00780001002O12010200044O001A000200073O001293000200076O000300013O00122O000400263O00122O000500276O0003000500024O0002000200034O000300013O00122O000400283O00122O000500296O0003000500024O0002000200034O000200083O00122O0001002A3O002E57002C00C40001002B000452012O00C400010026D2000100C400010004000452012O00C40001001260000200074O0051000300013O00122O0004002D3O00122O0005002E6O0003000500024O0002000200034O000300013O00122O0004002F3O00122O000500306O0003000500024O0002000200034O000200093O00122O000200076O000300013O00122O000400313O00122O000500326O0003000500024O0002000200034O000300013O00122O000400333O00122O000500346O0003000500024O00020002000300062O000200A400010001000452012O00A40001002O12010200014O001A0002000A3O001226010200076O000300013O00122O000400353O00122O000500366O0003000500024O0002000200034O000300013O00122O000400373O00122O000500386O0003000500024O00020002000300062O000200B300010001000452012O00B30001002O12010200014O001A0002000B3O001226010200076O000300013O00122O000400393O00122O0005003A6O0003000500024O0002000200034O000300013O00122O0004003B3O00122O0005003C6O0003000500024O00020002000300062O000200C200010001000452012O00C20001002O12010200014O001A0002000C3O002O122O0100103O0026D2000100062O01003D000452012O00062O01002O12010200013O002E45013E001D0001003E000452012O00E400010026D2000200E400010001000452012O00E40001001260000300074O00D3000400013O00122O0005003F3O00122O000600406O0004000600024O0003000300044O000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O0003000D3O00122O000300076O000400013O00122O000500433O00122O000600446O0004000600024O0003000300044O000400013O00122O000500453O00122O000600466O0004000600024O0003000300044O0003000E3O00122O000200043O0026D2000200E800010010000452012O00E80001002O122O0100473O000452012O00062O01002E0F004900C700010048000452012O00C700010026D2000200C700010004000452012O00C70001001260000300074O00D3000400013O00122O0005004A3O00122O0006004B6O0004000600024O0003000300044O000400013O00122O0005004C3O00122O0006004D6O0004000600024O0003000300044O0003000F3O00122O000300076O000400013O00122O0005004E3O00122O0006004F6O0004000600024O0003000300044O000400013O00122O000500503O00122O000600516O0004000600024O0003000300044O000300103O00122O000200103O000452012O00C700010026D20001003C2O010010000452012O003C2O01001260000200074O00B7000300013O00122O000400523O00122O000500536O0003000500024O0002000200034O000300013O00122O000400543O00122O000500556O0003000500024O00020002000300062O000200162O010001000452012O00162O01002O12010200014O001A000200113O001260000200074O0028000300013O00122O000400563O00122O000500576O0003000500024O0002000200034O000300013O00122O000400583O00122O000500596O0003000500022O00440002000200032O001A000200123O001260000200074O00D3000300013O00122O0004005A3O00122O0005005B6O0003000500024O0002000200034O000300013O00122O0004005C3O00122O0005005D6O0003000500024O0002000200034O000200133O00122O000200076O000300013O00122O0004005E3O00122O0005005F6O0003000500024O0002000200034O000300013O00122O000400603O00122O000500616O0003000500024O0002000200034O000200143O00122O0001003D3O00262E000100402O01002A000452012O00402O01002E57006300802O010062000452012O00802O01002O12010200013O0026D20002005C2O010001000452012O005C2O01001260000300074O00D3000400013O00122O000500643O00122O000600656O0004000600024O0003000300044O000400013O00122O000500663O00122O000600676O0004000600024O0003000300044O000300153O00122O000300076O000400013O00122O000500683O00122O000600696O0004000600024O0003000300044O000400013O00122O0005006A3O00122O0006006B6O0004000600024O0003000300044O000300163O00122O000200043O000E6D001000602O010002000452012O00602O01002E0F006C00622O01006D000452012O00622O01002O122O01006E3O000452012O00802O0100262E000200662O010004000452012O00662O01002E0F006F00412O010070000452012O00412O01001260000300074O00D3000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000300173O00122O000300076O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000300183O00122O000200103O000452012O00412O01002E0F007900B52O01007A000452012O00B52O010026D2000100B52O010047000452012O00B52O01001260000200074O0086000300013O00122O0004007B3O00122O0005007C6O0003000500024O0002000200034O000300013O00122O0004007D3O00122O0005007E6O0003000500024O0002000200034O000200193O00122O000200076O000300013O00122O0004007F3O00122O000500806O0003000500024O0002000200034O000300013O00122O000400813O00122O000500826O0003000500024O0002000200034O0002001A3O00122O000200076O000300013O00122O000400833O00122O000500846O0003000500024O0002000200034O000300013O00122O000400853O00122O000500866O0003000500024O0002000200034O0002001B3O00122O000200076O000300013O00122O000400873O00122O000500886O0003000500024O0002000200034O000300013O00122O000400893O00122O0005008A6O0003000500024O0002000200034O0002001C3O00122O0001008B3O0026D2000100DC2O01006E000452012O00DC2O01001260000200074O0028000300013O00122O0004008C3O00122O0005008D6O0003000500024O0002000200034O000300013O00122O0004008E3O00122O0005008F6O0003000500022O00440002000200032O001A0002001D3O001260000200074O0028000300013O00122O000400903O00122O000500916O0003000500024O0002000200034O000300013O00122O000400923O00122O000500936O0003000500022O00440002000200032O001A0002001E3O001260000200074O0028000300013O00122O000400943O00122O000500956O0003000500024O0002000200034O000300013O00122O000400963O00122O000500976O0003000500022O00440002000200032O001A0002001F3O000452012O001A020100262E000100E02O01008B000452012O00E02O01002E4501980029FE2O0099000452012O00070001001260000200074O0028000300013O00122O0004009A3O00122O0005009B6O0003000500024O0002000200034O000300013O00122O0004009C3O00122O0005009D6O0003000500022O00440002000200032O001A000200203O001260000200074O0051000300013O00122O0004009E3O00122O0005009F6O0003000500024O0002000200034O000300013O00122O000400A03O00122O000500A16O0003000500024O0002000200034O000200213O00122O000200076O000300013O00122O000400A23O00122O000500A36O0003000500024O0002000200034O000300013O00122O000400A43O00122O000500A56O0003000500024O00020002000300062O0002000602010001000452012O00060201002O12010200044O001A000200223O001226010200076O000300013O00122O000400A63O00122O000500A76O0003000500024O0002000200034O000300013O00122O000400A83O00122O000500A96O0003000500024O00020002000300062O0002001502010001000452012O00150201002O12010200044O001A000200233O002O122O0100193O000452012O00070001000452012O001A0201000452012O000200012O00293O00017O00053O00030D3O0048617353746174416E7944707303083O00432O6F6C646F776E026O00F03F027O0040029O002D4O00117O0020655O00012O0029012O0002000200062C3O001500013O000452012O001500012O00113O00013O0020655O00012O0029012O0002000200062C3O001200013O000452012O001200012O00117O002017014O00026O000200024O000100013O00202O0001000100024O00010002000200062O0001001500013O000452012O00150001002O12012O00034O001A3O00023O000452012O002C00012O00113O00013O0020655O00012O0029012O0002000200062C3O002A00013O000452012O002A00012O00117O0020655O00012O0029012O0002000200062C3O002700013O000452012O002700012O00113O00013O00201D5O00026O000200024O00015O00202O0001000100024O00010002000200062O0001002A00013O000452012O002A0001002O12012O00044O001A3O00023O000452012O002C0001002O12012O00054O001A3O00024O00293O00017O000B3O00028O00026O00F03F025O0016A640025O00F8A340025O0044A840025O0044B340030C3O0047657445717569706D656E74026O002A40025O00049340025O00707F40026O002C40004A3O002O12012O00014O002C2O0100023O0026D23O000700010001000452012O00070001002O122O0100014O002C010200023O002O12012O00023O002E45010300FBFF2O0003000452012O000200010026D23O000200010002000452012O00020001002E4501043O00010004000452012O000B00010026D20001000B00010001000452012O000B0001002O12010200013O0026D20002002F00010001000452012O002F0001002O12010300013O00262E0003001700010001000452012O00170001002E570006002A00010005000452012O002A00012O0011000400013O0020320004000400074O0004000200024O00048O00045O00202O00040004000800062O0004002500013O000452012O002500012O0011000400034O001100055O00201C0105000500082O00290104000200020006A90004002800010001000452012O002800012O0011000400033O002O12010500014O00290104000200022O001A000400023O002O12010300023O0026D20003001300010002000452012O00130001002O12010200023O000452012O002F0001000452012O0013000100262E0002003300010002000452012O00330001002E57000900100001000A000452012O001000012O001100035O00201C01030003000B00062C0003003D00013O000452012O003D00012O0011000300034O001100045O00201C01040004000B2O00290103000200020006A90003004000010001000452012O004000012O0011000300033O002O12010400014O00290103000200022O001A000300044O0011000300054O00B9000300010001000452012O00490001000452012O00100001000452012O00490001000452012O000B0001000452012O00490001000452012O000200012O00293O00019O003O00034O005A3O00014O00973O00024O00293O00017O00013O00029O00074O00117O000EB20001000400013O000452012O000400012O00148O005A3O00014O00973O00024O00293O00017O000D3O0003143O00412O7461636B506F77657244616D6167654D6F6402295C8FC2F528CC3F026O00F03F03083O00446562752O665570030A3O0053686976446562752O6602CD5OCCF43F030F3O00E9E218EB1FDFD409E91BD9E61AFE1703053O007AAD877D9B030B3O004973417661696C61626C6502CD5OCCF03F030A3O004D617374657279506374026O00594003113O00566572736174696C697479446D6750637400444O00B67O00206O00016O000200024O000100019O00000100206O000200206O00034O000100023O0020C30001000100044O000300033O00202O0003000300054O00010003000200062O0001001100013O000452012O00110001002O122O0100063O0006A90001001200010001000452012O00120001002O122O0100034O00E15O00012O0050000100036O000200043O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O00010002000200062O0001002000013O000452012O00200001002O122O01000A3O0006A90001002100010001000452012O00210001002O122O0100034O00E15O00012O0041000100053O00122O000200036O00035O00202O00030003000B4O00030002000200202O00030003000C4O0001000300024O000200063O00122O000300036O00045O00202O00040004000B4O00040002000200202O00040004000C4O0002000400024O0001000100028O00014O000100053O00122O000200036O00035O00202O00030003000D4O00030002000200202O00030003000C4O0001000300024O000200063O00122O000300036O00045O00202O00040004000D4O00040002000200202O00040004000C4O0002000400024O0001000100028O00016O00028O00017O00053O0003143O00412O7461636B506F77657244616D6167654D6F64020AD7A3703D0ADF3F026O00F03F03113O00566572736174696C697479446D67506374026O00594000274O0028019O000100013O00202O0001000100014O0001000200024O000200013O00202O0002000200014O000400016O000200049O0000024O000100026O000200013O00202O0002000200014O0002000200024O000300013O00202O0003000300014O000500016O000300056O00013O00028O000100206O000200206O00034O00015O00122O000200036O000300013O00202O0003000300044O00030002000200202O0003000300054O0001000300024O000200023O00122O000300036O000400013O00202O0004000400044O00040002000200202O0004000400054O0002000400024O0001000100028O00016O00028O00017O00033O00030B3O0042752O6652656D61696E7303123O004D6173746572412O73612O73696E42752O66024O008087C340000B4O00FA7O00206O00014O000200013O00202O0002000200026O0002000200264O000800010003000452012O000800012O00148O005A3O00014O00973O00024O00293O00017O00113O00028O00026O00F03F025O00907B40025O0007B340025O004EAD40025O00D88640025O00A6A340025O00309C40025O0080A740025O00109E40025O00707240030A3O0047434452656D61696E73026O000840030B3O0042752O6652656D61696E7303123O004D6173746572412O73612O73696E42752O66025O00DCB240025O00F49A4000403O002O12012O00014O002C2O0100023O00262E3O000600010002000452012O00060001002E570004003700010003000452012O00370001002E0F0006000600010005000452012O00060001000EF90001000600010001000452012O00060001002O12010200013O00262E0002000F00010001000452012O000F0001002E0F0007000B00010008000452012O000B0001002O12010300013O0026D20003001000010001000452012O00100001002O12010400013O002E0F000A001300010009000452012O001300010026D20004001300010001000452012O00130001002E45010B00140001000B000452012O002B00012O001100056O001301050001000200062C0005002B00013O000452012O002B00012O0011000500014O00AB000600023O00202O00060006000C4O00060002000200122O0007000D6O0005000700024O000600036O000700023O00202O00070007000C4O00070002000200122O0008000D6O0006000800024O0005000500064O000500024O0011000500023O00208000050005000E4O000700043O00202O00070007000F4O000500076O00055O00044O00130001000452012O00100001000452012O000B0001000452012O003F0001000452012O00060001000452012O003F0001002E570011000200010010000452012O000200010026D23O000200010001000452012O00020001002O122O0100014O002C010200023O002O12012O00023O000452012O000200012O00293O00017O000B3O00028O00025O0069B040025O00CCA04003063O0042752O66557003133O00496D70726F76656447612O726F746541757261025O0008A840025O003AB240030A3O0047434452656D61696E73026O000840030B3O0042752O6652656D61696E7303133O00496D70726F76656447612O726F746542752O66002E3O002O12012O00014O002C2O0100013O00262E3O000600010001000452012O00060001002E0F0002000200010003000452012O00020001002O122O0100013O0026D20001000700010001000452012O00070001002O12010200013O0026D20002000A00010001000452012O000A00012O001100035O0020A10003000300044O000500013O00202O0005000500054O00030005000200062O0003001500010001000452012O00150001002E570007002300010006000452012O002300012O0011000300024O00AB00045O00202O0004000400084O00040002000200122O000500096O0003000500024O000400036O00055O00202O0005000500084O00050002000200122O000600096O0004000600024O0003000300044O000300024O001100035O00208000030003000A4O000500013O00202O00050005000B4O000300056O00035O00044O000A0001000452012O00070001000452012O002D0001000452012O000200012O00293O00017O00093O00028O0003063O0042752O66557003193O00496E6469736372696D696E6174654361726E61676541757261025O00AC9F40025O00ACA740030A3O0047434452656D61696E73026O002440030B3O0042752O6652656D61696E7303193O00496E6469736372696D696E6174654361726E61676542752O66002C3O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O000EF90001000500010001000452012O00050001002O12010200013O0026D20002000800010001000452012O000800012O001100035O0020A10003000300024O000500013O00202O0005000500034O00030005000200062O0003001300010001000452012O00130001002E570005002100010004000452012O002100012O0011000300024O00AB00045O00202O0004000400064O00040002000200122O000500076O0003000500024O000400036O00055O00202O0005000500064O00050002000200122O000600076O0004000600024O0003000300044O000300024O001100035O0020800003000300084O000500013O00202O0005000500094O000300056O00035O00044O00080001000452012O00050001000452012O002B0001000452012O000200012O00293O00017O001A3O00028O00025O005AA940025O00DCAB40026O00F03F025O0086A440025O00D07740025O00B07140025O00C0B140025O00508340025O00D8AD40025O00BFB040026O005F40027O004003063O00FADD395D364403063O0037BBB14E3C4F03093O0002C01FC949DC9328DD03073O00E04DAE3F8B26AF030C3O004973496E426F2O734C69737403043O00A5544C2103043O004EE4213803123O00496E7374616E636544692O666963756C7479026O00304003053O004E50434944024O00B8F60041025O0012A440025O009CAE40005E3O002O12012O00014O002C2O0100023O002E570002005500010003000452012O005500010026D23O005500010004000452012O00550001000E6D0001000A00010001000452012O000A0001002E570005000600010006000452012O00060001002O12010200013O0026D20002000B00010001000452012O000B0001002O12010300014O002C010400043O002E0F0007000F00010008000452012O000F00010026D20003000F00010001000452012O000F0001002O12010400013O002E0F000900140001000A000452012O001400010026D20004001400010001000452012O00140001002E57000C00200001000B000452012O002000012O001100055O002624010500200001000D000452012O002000012O005A00056O0097000500023O000452012O004C00012O0011000500014O0063000600023O00122O0007000E3O00122O0008000F6O00060008000200062O0005002A00010006000452012O002A00012O005A000500014O0097000500023O000452012O004C00012O0011000500014O0063000600023O00122O000700103O00122O000800116O00060008000200062O0005003900010006000452012O003900012O0011000500033O0020650005000500122O002901050002000200062C0005003900013O000452012O003900012O005A000500014O0097000500023O000452012O004C00012O0011000500014O0063000600023O00122O000700133O00122O000800146O00060008000200062O0005004C00010006000452012O004C00012O0011000500043O0020650005000500152O00290105000200020026D20005004C00010016000452012O004C00012O0011000500033O0020650005000500172O00290105000200020026D20005004C00010018000452012O004C00012O005A000500014O0097000500024O005A00056O0097000500023O000452012O00140001000452012O000B0001000452012O000F0001000452012O000B0001000452012O005D0001000452012O00060001000452012O005D0001002E57001900020001001A000452012O000200010026D23O000200010001000452012O00020001002O122O0100014O002C010200023O002O12012O00043O000452012O000200012O00293O00017O00223O00028O00025O00A4A840025O00B89F40026O00F03F025O0062AD40025O00508540025O002OA040025O00208A40025O0072A240025O009C904003083O00446562752O66557003093O0044656174686D61726B03093O004B696E677362616E6503063O0042752O665570030F3O00536861646F7744616E636542752O66030A3O0053686976446562752O66030A3O00FA76BB1091C27B86068403053O00E5AE1ED26303103O0046752O6C526563686172676554696D65026O00344003103O00456E6572677950657263656E74616765026O00544003073O0048617354696572026O003F40026O00104003073O00456E76656E6F6D030B3O0042752O6652656D61696E73027O004003183O00426F2O7346696C7465726564466967687452656D61696E7303023O0047B003073O00597B8DE6318D5D025O00805640025O00F89B40025O002AA94000763O002O12012O00014O002C2O0100023O00262E3O000600010001000452012O00060001002E570002000900010003000452012O00090001002O122O0100014O002C010200023O002O12012O00043O00262E3O000D00010004000452012O000D0001002E570005000200010006000452012O000200010026D20001000D00010001000452012O000D0001002O12010200013O0026D20002001000010001000452012O00100001002O12010300014O002C010400043O002E0F0008001400010007000452012O001400010026D20003001400010001000452012O00140001002O12010400013O00262E0004001D00010001000452012O001D0001002E57000900190001000A000452012O001900012O001100055O0020A100050005000B4O000700013O00202O00070007000C4O00050007000200062O0005006900010001000452012O006900012O001100055O0020A100050005000B4O000700013O00202O00070007000D4O00050007000200062O0005006900010001000452012O006900012O0011000500023O0020A100050005000E4O000700013O00202O00070007000F4O00050007000200062O0005006900010001000452012O006900012O001100055O0020A100050005000B4O000700013O00202O0007000700104O00050007000200062O0005006900010001000452012O006900012O0011000500014O0011000600033O0012E8000700113O00122O000800126O0006000800024O00050005000600202O0005000500132O00290105000200020026C20005006900010014000452012O006900012O0011000500023O0020650005000500152O0029010500020002000E1E0116006900010005000452012O006900012O0011000500023O0020F200050005001700122O000700183O00122O000800196O00050008000200062O0005006700013O000452012O006700012O0011000500023O0020C300050005000E4O000700013O00202O00070007001A4O00050007000200062O0005005D00013O000452012O005D00012O0011000500023O00201101050005001B4O000700013O00202O00070007001A4O00050007000200262O000500690001001C000452012O006900012O0011000500043O00200D01050005001D4O000600033O00122O0007001E3O00122O0008001F6O00060008000200122O000700206O00050007000200062O0005006900010001000452012O00690001002E570022006B00010021000452012O006B00012O005A000500014O0097000500024O005A00056O0097000500023O000452012O00190001000452012O00100001000452012O00140001000452012O00100001000452012O00750001000452012O000D0001000452012O00750001000452012O000200012O00293O00017O00153O00028O00025O006BB140025O0016AE40025O0032A740025O00109D4003093O00D774F72O1847F263FD03063O002A9311966C70030F3O00432O6F6C646F776E52656D61696E7303063O003CA33D6CEEFB03063O00886FC64D1F87031A3O00426F2O73466967687452656D61696E7349734E6F7456616C696403183O00426F2O7346696C7465726564466967687452656D61696E7303013O003E03093O00260CA642B5E916BB0903083O00C96269C736DD8477025O0096A040025O0080434003093O009D0982350A38ADAB0703073O00CCD96CE341625503063O006DC6E5F625D303063O00A03EA395854C004C3O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O002E570003000500010002000452012O000500010026D20001000500010001000452012O00050001002O12010200013O00262E0002000E00010001000452012O000E0001002E570004000A00010005000452012O000A00012O001100036O003E000400013O00122O000500063O00122O000600076O0004000600024O00030003000400202O0003000300084O0003000200024O00048O000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004003300010003000452012O003300012O0011000300023O00201C01030003000B2O00130103000100020006A90003003500010001000452012O003500012O0011000300023O00201C01030003000C002O120104000D4O001100056O0011000600013O0012E80007000E3O00122O0008000F6O0006000800024O00050005000600202O0005000500082O0052000500064O006700033O00020006A90003003500010001000452012O00350001002E450110000B00010011000452012O003E00012O001100036O0011000400013O0012E8000500123O00122O000600136O0004000600024O00030003000400202O0003000300082O00FB000300044O007200036O001100036O004D010400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300084O000300046O00035O00044O000A0001000452012O00050001000452012O004B0001000452012O000200012O00293O00017O000D3O00028O00025O00A8A040025O00206940030C3O00E5A30821D7F9A62F23CCD9A403053O00A3B6C06D4F030B3O004973417661696C61626C6503093O0042752O66537461636B03103O005363656E744F66426C2O6F6442752O66026O003440030C3O00072505CEE11B2022CCFA3B2203053O0095544660A0030A3O0054616C656E7452616E6B027O004000353O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O000EF90001000500010001000452012O00050001002O12010200013O00262E0002000C00010001000452012O000C0001002E570002000800010003000452012O000800012O001100036O0043010400013O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300064O00030002000200062O0003001800010001000452012O001800012O005A000300014O0097000300024O0011000300023O0020070003000300074O00055O00202O0005000500084O0003000500024O000400033O00122O000500096O00068O000700013O00122O0008000A3O00122O0009000B6O0007000900024O00060006000700202O00060006000C4O00060002000200202O00060006000D4O000700046O0006000600074O00040006000200062O0004000200010003000452012O002E00012O001400036O005A000300014O0097000300023O000452012O00080001000452012O00050001000452012O00340001000452012O000200012O00293O00017O000C3O00028O00026O00F03F025O00F2B040025O007DB140025O00109B40025O00B2AB40025O00949140026O005040025O001EA940025O004AAF4003113O0050616E64656D69635468726573686F6C6403113O00446562752O665265667265736861626C6503353O002O12010300014O002C010400063O0026D20003002E00010002000452012O002E00012O002C010600063O000E6D0001000900010004000452012O00090001002E570004000C00010003000452012O000C0001002O12010500014O002C010600063O002O12010400023O0026D20004000500010002000452012O0005000100262E0005001200010001000452012O00120001002E570006000E00010005000452012O000E0001002O12010700014O002C010800083O002E570008001400010007000452012O001400010026D20007001400010001000452012O00140001002O12010800013O00262E0008001D00010001000452012O001D0001002E0F000A001900010009000452012O001900010006A90006002200010001000452012O0022000100206500090001000B2O00290109000200022O0051010600093O00206500093O000C2O00BD000B00016O000C00066O0009000C6O00095O00044O00190001000452012O000E0001000452012O00140001000452012O000E0001000452012O00340001000452012O00050001000452012O003400010026D20003000200010001000452012O00020001002O12010400014O002C010500053O002O12010300023O000452012O000200012O00293O00017O00193O00028O00026O00F03F025O00DEA240025O00C88440027O0040025O00049140025O003AA14003043O004755494403103O00556E697449734379636C6556616C6964030D3O00446562752O6652656D61696E7303093O0054696D65546F446965025O00C4A040025O00A08340025O00AEAA40025O0061B140025O00949B40025O00D6B040025O00508C40026O006940026O00A840025O00AAA040025O00408C40025O00E09540025O00708640025O002EAE40049D3O002O12010400014O002C010500083O0026D20004000700010001000452012O00070001002O12010500014O002C010600063O002O12010400023O002E0F0004000D00010003000452012O000D00010026D20004000D00010002000452012O000D00012O002C010700083O002O12010400053O000EF90005000200010004000452012O00020001000E6D0001001300010005000452012O00130001002E0F0007001B00010006000452012O001B00012O002C010900094O002B000700026O000600096O00095O00202O0009000900084O0009000200024O000800093O00122O000500023O0026D20005000F00010002000452012O000F00012O0011000900014O0051010A00034O003001090002000B000452012O003A0001002065000E000D00082O0029010E00020002000632010E003A00010008000452012O003A00012O0011000E00023O002017000E000E00094O000F000D6O001000073O00202O0011000D000A4O00138O0011001300024O001100116O000E0011000200062O000E003A00013O000452012O003A00012O0051010E00014O0051010F000D4O0029010E0002000200062C000E003A00013O000452012O003A00012O0051010E000D3O002065000F000D000B2O0029010F000200022O00510107000F4O00510106000E3O00062F0109002100010002000452012O002100010006A90006004000010001000452012O00400001002E57000C00450001000D000452012O004500012O0011000900034O0051010A00064O0051010B6O00590009000B0001000452012O009C00012O0011000900043O00062C0009009C00013O000452012O009C0001002O12010900014O002C010A000A3O00262E0009004E00010001000452012O004E0001002E57000F004A0001000E000452012O004A0001002O12010A00013O00262E000A005300010002000452012O00530001002E0F0011005C00010010000452012O005C0001002E0F0013009C00010012000452012O009C000100062C0006009C00013O000452012O009C00012O0011000B00034O0051010C00064O0051010D6O0059000B000D0001000452012O009C00010026D2000A004F00010001000452012O004F0001002O12010B00014O002C010C000C3O00262E000B006400010001000452012O00640001002E570014006000010015000452012O00600001002O12010C00013O0026D2000C006900010002000452012O00690001002O12010A00023O000452012O004F0001002E570016006500010017000452012O006500010026D2000C006500010001000452012O006500012O002C010D000D4O00FE000700026O0006000D6O000D00016O000E00056O000D0002000F00044O008F00010020650012001100082O00290112000200020006320112008800010008000452012O008800012O0011001200023O0020170012001200094O001300116O001400073O00202O00150011000A4O00178O0015001700024O001500156O00120015000200062O0012008800013O000452012O008800012O0051011200014O0051011300114O00290112000200020006A90012008A00010001000452012O008A0001002E0F0019008F00010018000452012O008F00012O0051011200113O00206500130011000B2O00290113000200022O0051010700134O0051010600123O00062F010D007400010002000452012O00740001002O12010C00023O000452012O00650001000452012O004F0001000452012O00600001000452012O004F0001000452012O009C0001000452012O004A0001000452012O009C0001000452012O000F0001000452012O009C0001000452012O000200012O00293O00017O002B3O00028O00027O0040025O0066A340025O005EA140025O00F49540025O00E88940026O00F03F025O001AAA40025O002EAE40026O000840026O00AE40025O00408F40026O001040025O00C8A440025O00D09D40025O00E0A140025O009EA340025O0010AC40025O0039B140025O00E9B240025O005EA740025O005EA640025O00D8A34003053O003E0F1FFE2C03043O008D58666D025O00E2A740025O00D6B240025O0050B240025O00449740026O008A40025O00A2B240025O00389E40025O00ACB140025O0074A440025O0046B040025O0049B040025O001AAD40025O00805540025O00089540025O0098A740025O007EA540025O00E0AD40025O00A6AC4003E23O002O12010300014O002C010400083O0026D2000300C900010002000452012O00C900012O002C010800083O002O12010900014O002C010A000A3O00262E0009000B00010001000452012O000B0001002E45010300FEFF2O0004000452012O00070001002O12010A00013O0026D2000A006300010001000452012O00630001002O12010B00013O002E570006001500010005000452012O001500010026D2000B001500010007000452012O00150001002O12010A00073O000452012O006300010026D2000B000F00010001000452012O000F0001002E0F0008004100010009000452012O004100010026D2000400410001000A000452012O00410001002O12010C00013O002E0F000C00220001000B000452012O00220001000EF9000700220001000C000452012O00220001002O120104000D3O000452012O0041000100262E000C002600010001000452012O00260001002E0F000E001C0001000F000452012O001C0001002O12010D00013O0026D2000D003B00010001000452012O003B00012O0011000E5O00062C000E002F00013O000452012O002F00012O0051010E00084O0011000F00014O0089000E0002000100062C0006003A00013O000452012O003A00010006D60007003A00010005000452012O003A00012O0051010E00024O0011000F00024O0029010E0002000200062C000E003A00013O000452012O003A00012O0011000E00024O0097000E00023O002O12010D00073O0026D2000D002700010007000452012O00270001002O12010C00073O000452012O001C0001000452012O00270001000452012O001C000100262E000400450001000D000452012O00450001002E0F0011006100010010000452012O00610001002O12010C00014O002C010D000D3O00262E000C004B00010001000452012O004B0001002E570013004700010012000452012O00470001002O12010D00013O000E6D000100500001000D000452012O00500001002E0F0014004C00010015000452012O004C0001002O12010E00013O0026D2000E005100010001000452012O0051000100062C0006005B00013O000452012O005B00012O0051010F00024O0051011000064O0029010F0002000200062C000F005B00013O000452012O005B00012O0097000600024O002C010F000F4O0097000F00023O000452012O00510001000452012O004C0001000452012O00610001000452012O00470001002O12010B00073O000452012O000F00010026D2000A009E00010007000452012O009E0001002O12010B00013O00262E000B006A00010001000452012O006A0001002E570016009700010017000452012O009700010026D20004008300010001000452012O00830001002O12010C00013O000EF9000700710001000C000452012O00710001002O12010400073O000452012O008300010026D2000C006D00010001000452012O006D00012O0051010D00014O0011000E00024O0029010D000200022O00510105000D4O0063000D00033O00122O000E00183O00122O000F00196O000D000F000200064O00810001000D000452012O0081000100262E0005008100010001000452012O008100012O0011000D00024O0097000D00023O002O12010C00073O000452012O006D0001002E57001A00960001001B000452012O009600010026D20004009600010007000452012O00960001002O12010C00013O00262E000C008C00010001000452012O008C0001002E0F001C00910001001D000452012O009100012O002C010D000D3O002O12010700014O00510106000D4O002C010800083O002O12010C00073O0026D2000C008800010007000452012O00880001002O12010400023O000452012O00960001000452012O00880001002O12010B00073O00262E000B009B00010007000452012O009B0001002E57001F00660001001E000452012O00660001002O12010A00023O000452012O009E0001000452012O00660001002E450120006EFF2O0020000452012O000C00010026D2000A000C00010002000452012O000C00010026D20004000500010002000452012O00050001002O12010B00014O002C010C000C3O00262E000B00AA00010001000452012O00AA0001002E57002100A600010022000452012O00A60001002O12010C00013O00262E000C00AF00010007000452012O00AF0001002E57002400B100010023000452012O00B10001002O120104000A3O000452012O0005000100262E000C00B500010001000452012O00B50001002E0F002500AB00010026000452012O00AB000100067900083O000100062O00113O00044O0051012O00064O0051012O00074O0051012O00014O0051017O00113O00034O0050010D00086O000E00056O000D0002000100122O000C00073O00044O00AB0001000452012O00050001000452012O00A60001000452012O00050001000452012O000C0001000452012O00050001000452012O00070001000452012O00050001000452012O00E10001002E450127001100010027000452012O00DA0001000EF9000100DA00010003000452012O00DA0001002O12010900013O000E6D000100D200010009000452012O00D20001002E57002800D500010029000452012O00D50001002O12010400014O002C010500053O002O12010900073O0026D2000900CE00010007000452012O00CE0001002O12010300073O000452012O00DA0001000452012O00CE0001002E0F002B00020001002A000452012O00020001000EF90007000200010003000452012O000200012O002C010600073O002O12010300023O000452012O000200012O00293O00013O00013O001A3O00028O00025O00D6B240025O00206340026O00F03F03093O0054696D65546F446965025O00609C40025O00EAA140025O000EA640025O001AA940025O005EB240025O00AAA040025O000EAA40025O0002A94003053O00B55AD8630E03083O00A1D333AA107A5D35025O0026AA40025O00D096402O033O00F6A7BC03043O00489BCED2025O0053B240025O0013B140025O002083402O033O004B7B4C03053O0053261A346E025O00E8B240025O004AB04001824O001100016O005101026O00302O0100020003000452012O007F0001002O12010600014O002C010700083O00262E0006000A00010001000452012O000A0001002E570002000D00010003000452012O000D0001002O12010700014O002C010800083O002O12010600043O000EF90004000600010006000452012O000600010026D20007002400010004000452012O002400012O0011000900013O00062C0009001E00013O000452012O001E00012O0011000900023O0006D60008001E00010009000452012O001E00010020650009000500052O004E0109000200024O000A00013O00202O000A000A00054O000A0002000200062O000A002000010009000452012O00200001002E0F0007007F00010006000452012O007F00012O0051010900054O001A000800024O001A000900013O000452012O007F000100262E0007002800010001000452012O00280001002E570009000F00010008000452012O000F0001002O12010900013O002E0F000B00750001000A000452012O007500010026D20009007500010001000452012O00750001002O12010A00013O0026D2000A003200010004000452012O00320001002O12010900043O000452012O0075000100262E000A003600010001000452012O00360001002E57000C002E0001000D000452012O002E00012O0011000B00034O007F000C00056O000B000200024O0008000B6O000B00013O00062O000B004400010001000452012O004400012O0011000B00044O0049010C00053O00122O000D000E3O00122O000E000F6O000C000E000200062O000B00460001000C000452012O00460001002E0F0010004D00010011000452012O004D00010026D20008004900010001000452012O00490001000452012O007300012O0051010B00054O001A000800024O001A000B00013O000452012O007300012O0011000B00044O0049010C00053O00122O000D00123O00122O000E00136O000C000E000200062O000B00560001000C000452012O00560001002E0F0014006200010015000452012O00620001002E450116001D00010016000452012O007300012O0011000B00013O00062C000B005E00013O000452012O005E00012O0011000B00023O00066E000800730001000B000452012O007300012O0051010B00054O001A000800024O001A000B00013O000452012O007300012O0011000B00044O0049010C00053O00122O000D00173O00122O000E00186O000C000E000200062O000B006A0001000C000452012O006A0001000452012O007300012O0011000B00013O00062C000B007000013O000452012O007000012O0011000B00023O00066E000B007300010008000452012O007300012O0051010B00054O001A000800024O001A000B00013O002O12010A00043O000452012O002E000100262E0009007900010004000452012O00790001002E57001900290001001A000452012O00290001002O12010700043O000452012O000F0001000452012O00290001000452012O000F0001000452012O007F0001000452012O0006000100062F2O01000400010002000452012O000400012O00293O00017O00133O00028O00026O00F03F025O00D0A740025O00ECAD40025O008AA040025O0068904003093O0054696D65546F446965031A3O00426F2O73466967687452656D61696E7349734E6F7456616C696403103O00426F2O73466967687452656D61696E73025O002C9140025O00489C40025O001CB340025O00F8AC40025O00B2A240025O00488340025O00209540025O00DCA240025O00C09840025O00D6A14003643O002O12010300014O002C010400063O0026D20003005B00010002000452012O005B00012O002C010600063O000E6D0001000900010004000452012O00090001002E0F0004000C00010003000452012O000C0001002O12010500014O002C010600063O002O12010400023O00262E0004001000010002000452012O00100001002E0F0005000500010006000452012O00050001002O12010700013O0026D20007001100010001000452012O00110001000EF90001003300010005000452012O00330001002O12010800013O0026D20008002E00010001000452012O002E00012O001100095O0020040109000900074O0009000200024O000600096O000900013O00202O0009000900084O00090001000200062O0009002600010001000452012O002600012O0011000900013O00201C0109000900092O00130109000100022O0051010600093O000452012O002D000100062D0102000600010006000452012O002D0001002E45010A00030001000B000452012O002B0001000452012O002D00012O005A00096O0097000900023O002O12010800023O0026D20008001600010002000452012O00160001002O12010500023O000452012O00330001000452012O001600010026D20005001000010002000452012O00100001002O12010800014O002C010900093O00262E0008003B00010001000452012O003B0001002E45010C00FEFF2O000D000452012O00370001002O12010900013O002E0F000F003C0001000E000452012O003C00010026D20009003C00010001000452012O003C00012O0011000A00024O008A000B000600024O000B000B6O000A000200024O000B00026O000C000600024O000C000C00014O000C000C6O000B0002000200062O000A00060001000B000452012O00500001002E0F0011004E00010010000452012O004E0001000452012O005000012O005A000A00014O0097000A00024O005A000A6O0097000A00023O000452012O003C0001000452012O00100001000452012O00370001000452012O00100001000452012O00110001000452012O00100001000452012O00630001000452012O00050001000452012O0063000100262E0003005F00010001000452012O005F0001002E45011200A5FF2O0013000452012O00020001002O12010400014O002C010500053O002O12010300023O000452012O000200012O00293O00017O000E3O00028O00025O0032A040025O003AA640026O00F03F025O009CA640025O00BAA940025O00EC9340025O00708D4003083O00446562752O66557003173O0053652O7261746564426F6E655370696B65446562752O66024O0080842E4103093O0054696D65546F446965025O00989240025O000CB040012F3O002O122O0100014O002C010200033O002E0F0002002600010003000452012O00260001000EF90004002600010001000452012O002600010026D20002000600010001000452012O00060001002O12010300013O0026D20003000900010001000452012O00090001002O12010400013O002E570005000C00010006000452012O000C00010026D20004000C00010001000452012O000C0001002O12010500013O0026D20005001100010001000452012O00110001002E0F0008001D00010007000452012O001D000100206500063O00092O001100085O00201C01080008000A2O000201060008000200062C0006001D00013O000452012O001D0001002O120106000B4O0097000600023O00206500063O000C2O00FB000600074O007200065O000452012O00110001000452012O000C0001000452012O00090001000452012O002E0001000452012O00060001000452012O002E0001002E0F000D00020001000E000452012O00020001000EF90001000200010001000452012O00020001002O12010200014O002C010300033O002O122O0100043O000452012O000200012O00293O00017O00023O0003083O00446562752O66557003173O0053652O7261746564426F6E655370696B65446562752O6601073O0020CC00013O00014O00035O00202O0003000300024O0001000300024O000100016O000100028O00017O00343O00028O00025O00C8A240025O0056A340027O0040026O00F03F025O0068A040025O00D88340025O002EA740025O0080684003093O00AA3556E7510E83334003063O0062EC5C248233030A3O0049734361737461626C6503053O005072652O7303093O0046697265626C2O6F64030E3O0087181FAE058EBC22A11B00B54AAC03083O0050C4796CDA25C8D5030D3O00217D017A581A98017F217E470203073O00EA6013621F2B6E025O0051B240025O00CEA74003093O002D165CC0BF708A081A03073O00EB667F32A7CC12030B3O004973417661696C61626C6503083O00446562752O665570030A3O0053686976446562752O6603093O004B696E677362616E65030D3O00446562752O6652656D61696E73026O002040030D3O00416E6365737472616C43612O6C025O00607A40025O00B0794003133O0073A0E637040F5EA2F030503C51ADB50045225C03063O004E30C1954324025O0058A340025O002OA640025O0080944003093O007A1B28495C3132544103043O0026387747025O005EAB40025O0098AA4003093O00426C2O6F6446757279030F3O00D0EE4BC26574FFE057D26570E6FD4103063O0036938F38B645030A3O00F484ED5ADAC48AF647D803053O00BFB6E19F29025O00D8A140025O00A4B040030A3O004265727365726B696E67030F3O0008133B41CBA5C739012D47808ECC2C03073O00A24B724835EBE7025O00F08340025O00E0904000C03O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O002O12010200014O002C010300033O0026D20002000700010001000452012O00070001002O12010300013O0026D20003007300010001000452012O00730001002E570002001200010003000452012O001200010026D20001001200010004000452012O001200012O005A00046O0097000400023O000E6D0005001600010001000452012O00160001002E570006007200010007000452012O00720001002O12010400013O000EF90005001B00010004000452012O001B0001002O122O0100043O000452012O00720001002E0F0009001700010008000452012O001700010026D20004001700010001000452012O001700012O001100056O0056000600013O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005003600013O000452012O003600012O0011000500023O00203B00050005000D4O00065O00202O00060006000E4O000700036O00050007000200062O0005003600013O000452012O003600012O0011000500013O002O120106000F3O002O12010700104O00FB000500074O007200056O001100056O0043010600013O00122O000700113O00122O000800126O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005004200010001000452012O00420001002E0F0013007000010014000452012O007000012O001100056O0043010600013O00122O000700153O00122O000800166O0006000800024O00050005000600202O0005000500174O00050002000200062O0005005300010001000452012O005300012O0011000500043O0020A10005000500184O00075O00202O0007000700194O00050007000200062O0005006100010001000452012O006100012O0011000500043O0020C30005000500184O00075O00202O00070007001A4O00050007000200062O0005007000013O000452012O007000012O0011000500043O00208100050005001B4O00075O00202O00070007001A4O00050007000200262O000500700001001C000452012O007000012O0011000500023O00201C01050005000D2O002201065O00202O00060006001D4O000700036O00050007000200062O0005006B00010001000452012O006B0001002E57001E00700001001F000452012O007000012O0011000500013O002O12010600203O002O12010700214O00FB000500074O007200055O002O12010400053O000452012O00170001002O12010300053O00262E0003007700010005000452012O00770001002E0F0023000A00010022000452012O000A0001002E450124008EFF2O0024000452012O000500010026D20001000500010001000452012O00050001002O12010400013O0026D2000400B100010001000452012O00B100012O001100056O0043010600013O00122O000700253O00122O000800266O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005008A00010001000452012O008A0001002E450127000F00010028000452012O009700012O0011000500023O00203B00050005000D4O00065O00202O0006000600294O000700036O00050007000200062O0005009700013O000452012O009700012O0011000500013O002O120106002A3O002O120107002B4O00FB000500074O007200056O001100056O0056000600013O00122O0007002C3O00122O0008002D6O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500B000013O000452012O00B00001002E0F002E00B00001002F000452012O00B000012O0011000500023O00203B00050005000D4O00065O00202O0006000600304O000700036O00050007000200062O000500B000013O000452012O00B000012O0011000500013O002O12010600313O002O12010700324O00FB000500074O007200055O002O12010400053O002E570033007C00010034000452012O007C00010026D20004007C00010005000452012O007C0001002O122O0100053O000452012O00050001000452012O007C0001000452012O00050001000452012O000A0001000452012O00050001000452012O00070001000452012O00050001000452012O00BF0001000452012O000200012O00293O00017O00893O00028O00026O00F03F025O0010A340025O002DB040025O0018B140025O001EA740025O00109A40030B3O000316811C4E273A8116423503053O0021507EE078030A3O0049734361737461626C6503093O00C7A10DC34FEEA90DC103053O003C8CC863A4030B3O004973417661696C61626C65025O003CAA40025O0028B340030F3O00AEF91434AD91F10001A395E60B32A703053O00C2E794644603073O00614DD3B1F9DC4303063O00A8262CA1C396030A3O00432O6F6C646F776E5570030B3O00504D756C7469706C69657203073O0047612O726F746503093O00A4F9836238E5B7048B03083O0076E09CE2165088D6030B3O00416E79446562752O66557003093O0066EB58944AE358924903043O00E0228E39030F3O00432O6F6C646F776E52656D61696E73026O00284003093O00FAA2C4C97BFC5C1CD503083O006EBEC7A5BD13913D026O004E4003043O006D6174682O033O006D696E026O001040025O008AA640025O0078A640025O00BAA340025O001AA740025O001EAF40025O00488440030F3O00456E65726779507265646963746564025O00804640030A3O00502O6F6C456E65726779031F3O00EAE478E4CBC1D5F937DB83C6DEE460A8AFC6D4E872A8C3E0DBF965E79FC29303063O00A7BA8B1788EB030B3O00536861646F7744616E6365031B3O0039B49B195A86800C1EBA9F4D3EB4860E1FF5C02A1BA79A020EB0C103043O006D7AD5E8030F3O00C7FAB2222OE1A734C9F6B022E1E3A703043O00508E97C2030E3O002EC7645806D4565F10C7645F0AC803043O002C63A61703073O0052757074757265030D3O00446562752O6652656D61696E73026O00084003083O00446562752O66557003093O0044656174686D61726B03093O0058F228223BA97DE52203063O00C41C97495653030A3O0053686976446562752O6603063O00536570736973025O00F09D4003233O00D0023A04C26B1077F70C3E50A6591675F643613D834B0C73E143080391590B65FA0D6003083O001693634970E23878025O0097B040025O0016AD40025O00989640025O0072A74003063O008E74ECFC9EB003053O00EDD815829503093O00497354616E6B696E67025O0068AA40025O00E06840025O00589740025O00D4B140030F3O007E5514CC584E01DA705916CC584C0103043O00BE373864030E3O007BAE2F0A16F1D245BC3D0D00EAFD03073O009336CF5C7E738303063O0056616E697368031D3O002E3026694D480C3F3C6E053E451C346E197B1F71146E1E7F1E223C734403063O001E6D51551D6D025O00A0B040025O00507D40030F3O00AB434F4DBFDF5B86695E4DA2C64A8703073O003EE22E2O3FD0A9030E3O00C81846971A1F0E4DF6184690162O03083O003E857935E37F6D4F03073O00371520E7D9BAA703073O00C270745295B6CE025O001EAD40025O00C05540025O00088340025O0062AE4003153O0010A64811D3E11C30A54516C1F60B1AA95E16C1E50B03073O006E59C82C78A08203093O008FC64A524B473A5FA003083O002DCBA32B26232A5B03093O00F680DD378FA455C08E03073O0034B2E5BC43E7C9025O0088A440025O00FEA040025O006EA740025O0030A740025O00C0514003233O00114E5F08B75A2C33016605F9553029011823F64E312E2O5544D3592235495D05E5576A03073O004341213064973C031F3O00FCE6BDCCB3E9E6A0D1E0D7A7E6FFF2CDF5A1CCF69FC3ABD9E7D7EAAFCAF89603053O0093BF87CEB8025O00CAAA40025O0010AB4003153O00AD26A2C8CB50A08D25AFCFD947B7A729B4CFD954B703073O00D2E448C6A1B833027O0040025O0042A240025O00707A40025O00A7B240025O00588640025O0068AC40025O006C9C4003233O000646FC1C33C8395BB32672C03F5AFB503BE9375BE11F67CB766DF61167C63B48E11B3A03063O00AE5629937013025O00349140025O00B2A240031C3O0078019E1F653910A55213854B6D2810B9490F990E652C1DAE5A16884203083O00CB3B60ED6B456F71025O000C9540030E3O000917BFF534E2F63705ADF222F9D903073O00B74476CC81519003093O0025A47EE318800FA37503063O00E26ECD10846B03093O004B696E677362616E6503173O00C8C2F3CD01DDC2EED052E383A8F248E5C4F3DB40E5C6A903053O00218BA380B9025O003EAD40025O0038A24000AF022O002O12012O00014O002C2O0100023O00262E3O000600010002000452012O00060001002E45010300A402010004000452012O00A80201002E0F0006000600010005000452012O000600010026D20001000600010001000452012O00060001002O12010200013O002E4501073O00010007000452012O000B00010026D20002000B00010001000452012O000B00012O001100036O0056000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300192O013O000452012O00192O012O001100036O0043010400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300192O010001000452012O00192O01002O12010300014O002C010400053O00262E0003002900010002000452012O00290001002E57000F00112O01000E000452012O00112O010026D20004002900010001000452012O00290001002O12010500013O0026D20005002C00010001000452012O002C00012O001100066O0056000700013O00122O000800103O00122O000900116O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600AF00013O000452012O00AF00012O001100066O0056000700013O00122O000800123O00122O000900136O0007000900024O00060006000700202O0006000600144O00060002000200062O000600AF00013O000452012O00AF00012O0011000600023O0020110106000600154O00085O00202O0008000800164O00060008000200262O0006005000010002000452012O005000012O0011000600034O009E000700026O00085O00202O0008000800164O00060008000200062O000600AF00013O000452012O00AF00012O001100066O0043010700013O00122O000800173O00122O000900186O0007000900024O00060006000700202O0006000600194O00060002000200062O0006006E00010001000452012O006E00012O001100066O0011000700013O0012E80008001A3O00122O0009001B6O0007000900024O00060006000700202O00060006001C2O00290106000200020026C20006006E0001001D000452012O006E00012O001100066O0011000700013O0012E80008001E3O00122O0009001F6O0007000900024O00060006000700202O00060006001C2O0029010600020002000ECD002000AF00010006000452012O00AF00012O0011000600043O001206010700213O00202O0007000700224O000800053O00122O000900236O00070009000200062O000700AF00010006000452012O00AF0001002O12010600014O002C010700083O000EF90001007D00010006000452012O007D0001002O12010700014O002C010800083O002O12010600023O002E0F0025007800010024000452012O007800010026D20006007800010002000452012O007800010026D20007008100010001000452012O00810001002O12010800013O00262E0008008800010001000452012O00880001002E45012600FEFF2O0027000452012O00840001002E0F0029009D00010028000452012O009D00012O0011000900063O00062C0009009D00013O000452012O009D00012O0011000900073O00206500090009002A2O00290109000200020026240109009D0001002B000452012O009D00012O0011000900084O0011000A5O00201C010A000A002C2O002901090002000200062C0009009D00013O000452012O009D00012O0011000900013O002O12010A002D3O002O12010B002E4O00FB0009000B4O007200096O0011000900084O00EC000A5O00202O000A000A002F4O000B00096O0009000B000200062O000900AF00013O000452012O00AF00012O0011000900013O00129B000A00303O00122O000B00316O0009000B6O00095O00044O00AF0001000452012O00840001000452012O00AF0001000452012O00810001000452012O00AF0001000452012O007800012O001100066O0043010700013O00122O000800323O00122O000900336O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600192O010001000452012O00192O012O001100066O0056000700013O00122O000800343O00122O000900356O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600192O013O000452012O00192O012O0011000600034O0021010700026O00085O00202O0008000800364O00060008000200062O000600192O010001000452012O00192O012O0011000600023O0020BC0006000600374O00085O00202O0008000800164O000600080002000E2O003800192O010006000452012O00192O012O0011000600023O0020A10006000600394O00085O00202O00080008003A4O00060008000200062O000600E200010001000452012O00E200012O001100066O0011000700013O0012E80008003B3O00122O0009003C6O0007000900024O00060006000700202O00060006001C2O0029010600020002000ECD002000192O010006000452012O00192O012O0011000600023O0020A10006000600394O00085O00202O00080008003D4O00060008000200062O000600F700010001000452012O00F700012O0011000600023O0020680006000600374O00085O00202O00080008003A4O00060008000200262O000600F700010023000452012O00F700012O0011000600023O0020C30006000600394O00085O00202O00080008003E4O00060008000200062O000600192O013O000452012O00192O012O0011000600023O0020810006000600374O00085O00202O00080008003E4O00060008000200262O000600192O010038000452012O00192O01002E45013F001B0001003F000452012O00192O012O0011000600084O00EC00075O00202O00070007002F4O000800096O00060008000200062O000600192O013O000452012O00192O012O0011000600013O00129B000700403O00122O000800416O000600086O00065O00044O00192O01000452012O002C0001000452012O00192O01000452012O00290001000452012O00192O01002E570043002500010042000452012O002500010026D20003002500010001000452012O00250001002O12010400014O002C010500053O002O12010300023O000452012O00250001002E0F004400AE02010045000452012O00AE02012O001100036O0056000400013O00122O000500463O00122O000600476O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300AE02013O000452012O00AE02012O0011000300073O0020650003000300482O0011000500024O00020103000500020006A9000300AE02010001000452012O00AE0201002O12010300013O000E6D000200302O010003000452012O00302O01002E0F004900842O01004A000452012O00842O01002E57004B00AE0201004C000452012O00AE02012O001100046O0043010500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400AE02010001000452012O00AE02012O001100046O0056000500013O00122O0006004F3O00122O000700506O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400AE02013O000452012O00AE02012O0011000400034O0021010500026O00065O00202O0006000600364O00040006000200062O000400AE02010001000452012O00AE02012O0011000400023O0020BC0004000400374O00065O00202O0006000600164O000400060002000E2O003800AE02010004000452012O00AE02012O0011000400023O0020C30004000400394O00065O00202O00060006003A4O00040006000200062O000400AE02013O000452012O00AE02012O0011000400023O0020A10004000400394O00065O00202O00060006003D4O00040006000200062O000400702O010001000452012O00702O012O0011000400023O0020680004000400374O00065O00202O00060006003A4O00040006000200262O000400702O010023000452012O00702O012O0011000400023O0020C30004000400394O00065O00202O00060006003E4O00040006000200062O000400AE02013O000452012O00AE02012O0011000400023O0020810004000400374O00065O00202O00060006003E4O00040006000200262O000400AE02010038000452012O00AE02012O0011000400084O00EC00055O00202O0005000500514O0006000A6O00040006000200062O000400AE02013O000452012O00AE02012O0011000400013O00129B000500523O00122O000600536O000400066O00045O00044O00AE0201000EF90001002C2O010003000452012O002C2O01002O12010400013O002E0F0055009B02010054000452012O009B02010026D20004009B02010001000452012O009B02012O001100056O0056000600013O00122O000700563O00122O000800576O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500B72O013O000452012O00B72O012O001100056O0043010600013O00122O000700583O00122O000800596O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500B72O010001000452012O00B72O012O001100056O0056000600013O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O0005000500144O00050002000200062O000500B72O013O000452012O00B72O012O0011000500023O0020110105000500154O00075O00202O0007000700164O00050007000200262O000500B92O010002000452012O00B92O012O0011000500034O0021010600026O00075O00202O0007000700164O00050007000200062O000500B92O010001000452012O00B92O01002E0F005C005C0201005D000452012O005C0201002O12010500014O002C010600063O0026D2000500BB2O010001000452012O00BB2O01002O12010600013O002E57005E00BE2O01005F000452012O00BE2O010026D2000600BE2O010001000452012O00BE2O012O001100076O0043010800013O00122O000900603O00122O000A00616O0008000A00024O00070007000800202O00070007000D4O00070002000200062O000700E72O010001000452012O00E72O012O001100076O0043010800013O00122O000900623O00122O000A00636O0008000A00024O00070007000800202O0007000700194O00070002000200062O000700E02O010001000452012O00E02O012O001100076O0011000800013O0012E8000900643O00122O000A00656O0008000A00024O00070007000800202O00070007001C2O0029010700020002002624010700E72O010023000452012O00E72O012O0011000700044O004C0108000B6O000900053O00122O000A00236O0008000A000200062O0008000300010007000452012O00E92O01002E0F0066001702010067000452012O00170201002O12010700014O002C010800083O0026D2000700EB2O010001000452012O00EB2O01002O12010800013O0026D2000800EE2O010001000452012O00EE2O01002E450168001700010068000452012O000702012O0011000900063O00062C0009000702013O000452012O000702012O0011000900073O00206500090009002A2O0029010900020002002624010900070201002B000452012O000702012O0011000900084O0011000A5O00201C010A000A002C2O00290109000200020006A90009002O02010001000452012O002O0201002E45016900070001006A000452012O000702012O0011000900013O002O12010A006B3O002O12010B006C4O00FB0009000B4O007200096O0011000900084O00EC000A5O00202O000A000A00514O000B000A6O0009000B000200062O0009001702013O000452012O001702012O0011000900013O00129B000A006D3O00122O000B006E6O0009000B6O00095O00044O00170201000452012O00EE2O01000452012O00170201000452012O00EB2O01002E0F006F005C02010070000452012O005C02012O001100076O0056000800013O00122O000900713O00122O000A00726O0008000A00024O00070007000800202O00070007000D4O00070002000200062O0007005C02013O000452012O005C02012O0011000700053O000ECD0073005C02010007000452012O005C0201002O12010700014O002C010800083O00262E0007002C02010001000452012O002C0201002E570074002802010075000452012O00280201002O12010800013O00262E0008003102010001000452012O00310201002E45017600FEFF2O0077000452012O002D02012O0011000900063O00062C0009004602013O000452012O004602012O0011000900073O00206500090009002A2O0029010900020002002624010900460201002B000452012O00460201002E570079004602010078000452012O004602012O0011000900084O0011000A5O00201C010A000A002C2O002901090002000200062C0009004602013O000452012O004602012O0011000900013O002O12010A007A3O002O12010B007B4O00FB0009000B4O007200096O0011000900084O0022010A5O00202O000A000A00514O000B000A6O0009000B000200062O0009004F02010001000452012O004F0201002E57007D005C0201007C000452012O005C02012O0011000900013O00129B000A007E3O00122O000B007F6O0009000B6O00095O00044O005C0201000452012O002D0201000452012O005C0201000452012O00280201000452012O005C0201000452012O00BE2O01000452012O005C0201000452012O00BB2O01002E450180003E00010080000452012O009A02012O001100056O0056000600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005009A02013O000452012O009A02012O001100056O0056000600013O00122O000700833O00122O000800846O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005009A02013O000452012O009A02012O0011000500023O0020C30005000500394O00075O00202O0007000700854O00050007000200062O0005009A02013O000452012O009A02012O0011000500023O0020C80005000500374O00075O00202O0007000700854O00050007000200262O0005009A02010038000452012O009A02012O0011000500023O0020C30005000500394O00075O00202O00070007003A4O00050007000200062O0005009A02013O000452012O009A02012O0011000500023O0020C80005000500374O00075O00202O00070007003A4O00050007000200262O0005009A02010038000452012O009A02012O0011000500084O00EC00065O00202O0006000600514O0007000A6O00050007000200062O0005009A02013O000452012O009A02012O0011000500013O002O12010600863O002O12010700874O00FB000500074O007200055O002O12010400023O002E0F008900872O010088000452012O00872O010026D2000400872O010002000452012O00872O01002O12010300023O000452012O002C2O01000452012O00872O01000452012O002C2O01000452012O00AE0201000452012O000B0001000452012O00AE0201000452012O00060001000452012O00AE02010026D23O000200010001000452012O00020001002O122O0100014O002C010200023O002O12012O00023O000452012O000200012O00293O00017O00113O00028O00025O0028A940025O007CB24003103O0048616E646C65546F705472696E6B6574026O004440025O0082B140025O0062B340026O00F03F025O0016AB40025O00FCA240025O00708040025O00F07F40025O00A4A040025O00309D4003133O0048616E646C65426F2O746F6D5472696E6B6574025O0046A040025O0036AE4000453O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O0026D20001002D00010001000452012O002D0001002O12010200013O0026D20002002600010001000452012O00260001002O12010300013O002E570002001F00010003000452012O001F00010026D20003001F00010001000452012O001F00012O0011000400013O0020180104000400044O000500026O000600033O00122O000700056O000800086O0004000800024O00048O00045O00062O0004001C00010001000452012O001C0001002E570007001E00010006000452012O001E00012O001100046O0097000400023O002O12010300083O002E57000A000B00010009000452012O000B00010026D20003000B00010008000452012O000B0001002O12010200083O000452012O00260001000452012O000B0001002E0F000C00080001000B000452012O000800010026D20002000800010008000452012O00080001002O122O0100083O000452012O002D0001000452012O0008000100262E0001003100010008000452012O00310001002E45010D00D6FF2O000E000452012O000500012O0011000200013O00201801020002000F4O000300026O000400033O00122O000500056O000600066O0002000600024O00028O00025O00062O0002003E00010001000452012O003E0001002E0F0011004400010010000452012O004400012O001100026O0097000200023O000452012O00440001000452012O00050001000452012O00440001000452012O000200012O00293O00017O00E03O00028O00025O0024A840025O0028AC40026O00F03F025O0054AA40025O0039B040025O0024B040027O0040025O00C05640025O0078A540025O003C9C40025O00F49A4003063O00CC7444A53FCD03073O009C9F1134D656BE03073O0049735265616479030D3O00446562752O6652656D61696E7303073O0052757074757265026O003440030F3O0087E2ADAEA1F92OB889EEAFAEA1FBB803043O00DCCE8FDD030B3O004973417661696C61626C6503083O00446562752O66557003073O0047612O726F7465030F3O00AF703D05D7DAD7825A2C05CAC3C68303073O00B2E61D4D77B8AC03073O00D2BF180978ECF003063O009895DE6A7B17030A3O00432O6F6C646F776E5570030B3O00504D756C7469706C69657203113O0046696C746572656454696D65546F44696503013O003E026O00244003183O00426F2O7346696C7465726564466967687452656D61696E7303023O00817B03053O00D5BD46962303063O00536570736973030B3O006C54671C0F6671182O5C6703043O00682F3514025O00C88340025O0054A44003093O00537465616C7468557003063O0042752O66557003073O00456E76656E6F6D03093O0087498008B402A25E8A03063O006FC32CE17CDC030B3O00416E79446562752O665570030E3O00F5471367AEB9F95513722OB8D14803063O00CBB8266013CB03093O00127A7746DD3B72774403053O00AE5913192103093O00041B5C49E4850A211703073O006B4F72322E97E7030F3O00432O6F6C646F776E52656D61696E73025O00907740025O0031B240025O0004B340025O00809040025O00709540025O00C8874003093O000F06EA080E05E9032803043O006C4C6986030A3O00446562752O66446F776E03093O00436F6C64426C2O6F64026O001040025O0080AD40025O00DCA94003053O005072652O73030F3O00C8C4A2F58EC8CABDE58E2OC9BEEECA03053O00AE8BA5D181025O002EAF40030A3O000185724CC6A3B1EC308C03083O00B855ED1B3FB2CFD4030A3O0049734361737461626C65030A3O0054686973746C65546561030D3O00456E6572677944656669636974026O00594003093O00235007581B5B08510D03043O003F683969030A3O003F8FAD571F8BA1700E8603043O00246BE7C403073O004368617267657303093O004B696E677362616E65026O00184003093O0076BCAC804EB7A3895803043O00E73DD5C203093O002DA83C6701A03C610203043O001369CD5D03013O003C030A3O009D00D7922BA50DEA843E03053O005FC968BEE103043O004361737403103O008CCAD2DAEFFFC9C7BCDFCDCBEFFFC4CF03043O00AECFABA103093O00C9FB0CE7F0DA2OEC0603063O00B78D9E6D9398025O00A4AB40025O00D2A940026O000840025O00349240025O000C9140025O008CAD4003093O001DA3B43D8234B6D23203083O00A059C6D549EA59D703023O00142C03053O00A52811D49E025O002CA640025O0060A54003093O0044656174686D61726B030E3O00C6D81B2766C1DC09272EE8D81A3803053O004685B96853025O0086AC4003043O00372O4D3C03053O00A96425244A030A3O0053686976446562752O66025O00989540025O00288540025O00388C40025O003EA54003113O00EA66D132402A18C744D732512A0AC27BCB03073O0079AB14A557324303093O00E23DB822B10FC72AB203063O0062A658D956D92O033O00536869025O00C2A040025O0067B240031E3O00D5F76A15C6EFFEFF6F41CEFDE4E27C138FDDFAB6491383DFFFE5700E889503063O00BC2O961961E603093O00F18051051FEFDB875A03063O008DBAE93F626C03113O00D0F838B337F8EB208637F4E925A52CFEE403053O0045918A4CD6025O00F0B240025O00DDB040025O00088440025O00BBB24003063O0043CA999AB60503063O007610AF2OE9DF03043O00B88C3CAD03073O001DEBE455DB8EEB03113O00436861726765734672616374696F6E616C02CD5OCCEC3F030F3O0011DDBDD56359225B3ADCAEEE7F473103083O00325DB4DABD172E47026O00144003043O005368697603123O00FDA5485804EF40D7B21B0477D958CDAD480503073O0028BEC43B2C24BC030E3O001F57D5B9E972030840D1A4FF6E1903073O006D5C25BCD49A1D030E3O004372696D736F6E54656D7065737403093O0027EEB7D771690CE6B203063O003A648FC4A351025O00809240025O00C4AD40025O00A7B24003023O005CDA03043O003060E7C203043O00FB52073B03083O00E3A83A6E4D79B8CF026O002040025O0092AA40025O004EA14003183O00583DAC54F1E879AC6D7CF765BFDF31AA7D7C9949B6D365EC03083O00C51B5CDF20D1BB11025O00FAA34003093O002856CDFC105DC2F50603043O009B633FA3025O001CA240025O003C9E40025O00F2AA40030F3O00AED8A685AD9387D8A685ADB78AD8B703063O00E4E2B1C1EDD903093O001FB92DE127B222E83103043O008654D043026O003840030E3O0030BE8F5100A3886816A1965900B803043O003C73CCE6025O00149540025O0040954003153O00C43BF864A709E379F17AA35BEE34EC63E53BE575AE03043O0010875A8B025O00588840030F3O00787D013B5A437D5D730E277D5C714203073O0018341466532E3403093O00EF262F231CC62E2F2103053O006FA44F4144025O00EEA240025O00BC914003213O00E5D890CA6ED9CED0959E66C1CFD784CD2CEBC8DCC3F227EDCECD94DB27EDCECDCA03063O008AA6B9E3BE4E025O0068B240026O00A740025O00EAB140025O001EA040025O000AAC40025O005EA940030B3O00294A22A7305EC10F14412603083O006E7A2243C35F298503093O005EB8554DC577B0554F03053O00B615D13B2A03093O009352C40929B3B645CE03063O00DED737A57D41026O004940025O008C9B40025O006C9B40030B3O00536861646F7744616E6365025O00C6AA40025O00CEA04003223O000FD0D50EB2F2E54B28DED15AD6C0E34929918E31FBCFEA592ED0C81FB2F2F4442F9803083O002A4CB1A67A92A18D03093O008E830BC96A74A4840003063O0016C5EA65AE1903043O001E3CACCA03083O00E64D54C5BC16CFB703093O00DD11C7E884ACF127F203083O00559974A69CECC190025O00EAAD40025O00E8A740025O00406F40025O00307740030E3O0087E15EA7A42BADEE4AA0E601AAE503063O0060C4802DD384025O0016B140025O00689540002A042O002O12012O00014O002C2O0100023O00262E3O000600010001000452012O00060001002E570003000900010002000452012O00090001002O122O0100014O002C010200023O002O12012O00043O0026D23O000200010004000452012O00020001002O12010300013O0026D2000300C72O010004000452012O00C72O010026D2000100DD00010001000452012O00DD0001002O12010400014O002C010500053O002E0F0005001200010006000452012O001200010026D20004001200010001000452012O00120001002O12010500013O002E450107000600010007000452012O001D00010026D20005001D00010008000452012O001D0001002O122O0100043O000452012O00DD00010026D20005008C00010001000452012O008C0001002O12010600013O00262E0006002400010001000452012O00240001002E57000A008500010009000452012O00850001002E57000C00810001000B000452012O008100012O001100076O0056000800013O00122O0009000D3O00122O000A000E6O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007008100013O000452012O008100012O0011000700023O0020BC0007000700104O00095O00202O0009000900114O000700090002000E2O0012008100010007000452012O008100012O001100076O0043010800013O00122O000900133O00122O000A00146O0008000A00024O00070007000800202O0007000700154O00070002000200062O0007004800010001000452012O004800012O0011000700023O0020A10007000700164O00095O00202O0009000900174O00070009000200062O0007006300010001000452012O006300012O001100076O0056000800013O00122O000900183O00122O000A00196O0008000A00024O00070007000800202O0007000700154O00070002000200062O0007008100013O000452012O008100012O001100076O0056000800013O00122O0009001A3O00122O000A001B6O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007008100013O000452012O008100012O0011000700023O0020C800070007001D4O00095O00202O0009000900174O00070009000200262O0007008100010004000452012O008100012O0011000700023O00203100070007001E00122O0009001F3O00122O000A00206O0007000A000200062O0007007400010001000452012O007400012O0011000700033O00209D0007000700214O000800013O00122O000900223O00122O000A00236O0008000A000200122O000900206O00070009000200062O0007008100013O000452012O008100012O0011000700044O00E900085O00202O0008000800244O000900096O000A00016O0007000A000200062O0007008100013O000452012O008100012O0011000700013O002O12010800253O002O12010900264O00FB000700094O007200076O0011000700064O00130107000100022O001A000700053O002O12010600043O00262E0006008900010004000452012O00890001002E570028002000010027000452012O00200001002O12010500043O000452012O008C0001000452012O002000010026D20005001700010004000452012O001700012O0011000600053O00062C0006009300013O000452012O009300012O0011000600054O0097000600024O0011000600073O002O200006000600294O000800016O00098O00060009000200062O000600D700010001000452012O00D700012O0011000600023O0020D00006000600164O00085O00202O0008000800114O00060008000200062O000200D900010006000452012O00D900012O0011000600073O0020D000060006002A4O00085O00202O00080008002B4O00060008000200062O000200D900010006000452012O00D900012O001100066O0043010700013O00122O0008002C3O00122O0009002D6O0007000900024O00060006000700202O00060006002E4O00060002000200062O000600D700010001000452012O00D700012O001100066O0056000700013O00122O0008002F3O00122O000900306O0007000900024O00060006000700202O0006000600154O00060002000200062O000600C300013O000452012O00C300012O0011000600023O0020D00006000600164O00085O00202O0008000800174O00060008000200062O000200D900010006000452012O00D900012O001100066O0056000700013O00122O000800313O00122O000900326O0007000900024O00060006000700202O0006000600154O00060002000200062O000600D800013O000452012O00D800012O001100066O0005000700013O00122O000800333O00122O000900346O0007000900024O00060006000700202O0006000600354O00060002000200262O000600D800010008000452012O00D800012O001400026O005A000200013O002O12010500083O000452012O00170001000452012O00DD0001000452012O001200010026D20001000B00010008000452012O000B0001002O12010400014O002C010500053O00262E000400E500010001000452012O00E50001002E57003700E100010036000452012O00E10001002O12010500013O0026D20005002E2O010004000452012O002E2O01002E0F003900042O010038000452012O00042O012O0011000600073O002O200006000600294O000800016O000900016O00060009000200062O000600042O010001000452012O00042O012O0011000600084O0013010600010002002609010600042O010001000452012O00042O012O0011000600094O0013010600010002002609010600042O010001000452012O00042O012O0011000600053O0006A9000600FE00010001000452012O00FE0001002E0F003A003O01003B000452012O003O012O00110006000A4O00B9000600010001000452012O00042O012O00110006000A4O00130106000100022O001A000600054O001100066O0056000700013O00122O0008003C3O00122O0009003D6O0007000900024O00060006000700202O00060006000F4O00060002000200062O0006001E2O013O000452012O001E2O012O0011000600073O0020C300060006003E4O00085O00202O00080008003F4O00060008000200062O0006001E2O013O000452012O001E2O012O00110006000B3O000E150040001E2O010006000452012O001E2O012O00110006000C3O0006A9000600202O010001000452012O00202O012O0011000600053O00062C000600202O013O000452012O00202O01002E0F0041002D2O010042000452012O002D2O012O0011000600033O00203B0006000600434O00075O00202O00070007003F4O0008000C6O00060008000200062O0006002D2O013O000452012O002D2O012O0011000600013O002O12010700443O002O12010800454O00FB000600084O007200065O002O12010500083O000EF9000100BD2O010005000452012O00BD2O01002E450146007300010046000452012O00A32O012O001100066O0056000700013O00122O000800473O00122O000900486O0007000900024O00060006000700202O0006000600494O00060002000200062O000600A32O013O000452012O00A32O012O0011000600073O0020A100060006002A4O00085O00202O00080008004A4O00060008000200062O000600A32O010001000452012O00A32O012O0011000600073O00204300060006004B4O0006000200024O0007000D3O00122O0008004C6O0009000E6O0007000900024O0008000F3O00122O0009004C6O000A000E6O0008000A00024O00070007000800062O000700652O010006000452012O00652O012O001100066O0056000700013O00122O0008004D3O00122O0009004E6O0007000900024O00060006000700202O0006000600154O00060002000200062O000600962O013O000452012O00962O012O001100066O0053000700013O00122O0008004F3O00122O000900506O0007000900024O00060006000700202O0006000600514O000600020002000E2O000800962O010006000452012O00962O012O0011000600023O0020C30006000600164O00085O00202O0008000800524O00060008000200062O000600732O013O000452012O00732O012O0011000600023O0020680006000600104O00085O00202O0008000800524O00060008000200262O000600962O010053000452012O00962O012O001100066O0043010700013O00122O000800543O00122O000900556O0007000900024O00060006000700202O0006000600154O00060002000200062O000600872O010001000452012O00872O012O001100066O0043010700013O00122O000800563O00122O000900576O0007000900024O00060006000700202O00060006002E4O00060002000200062O000600962O010001000452012O00962O012O0011000600033O00201C010600060021002O12010700584O001100086O0011000900013O0012E8000A00593O00122O000B005A6O0009000B00024O00080008000900202O0008000800512O002901080002000200202A0108000800532O000201060008000200062C000600A32O013O000452012O00A32O012O0011000600033O00203B00060006005B4O00075O00202O00070007004A4O000800106O00060008000200062O000600A32O013O000452012O00A32O012O0011000600013O002O120107005C3O002O120108005D4O00FB000600084O007200066O001100066O0056000700013O00122O0008005E3O00122O0009005F6O0007000900024O00060006000700202O00060006002E4O00060002000200062O000600BC2O013O000452012O00BC2O012O0011000600053O00062C000600B32O013O000452012O00B32O012O0011000600113O00062C000600BC2O013O000452012O00BC2O012O0011000600053O00062C000600B92O013O000452012O00B92O012O0011000600124O00B9000600010001000452012O00BC2O012O0011000600124O00130106000100022O001A000600053O002O12010500043O002E57006100E600010060000452012O00E600010026D2000500E600010008000452012O00E60001002O122O0100623O000452012O000B0001000452012O00E60001000452012O000B0001000452012O00E10001000452012O000B000100262E000300CB2O010001000452012O00CB2O01002E0F0063000C00010064000452012O000C0001002E450165005302010065000452012O001E0401000EF90004001E04010001000452012O001E0401002O12010400013O0026D2000400D42O010008000452012O00D42O01002O122O0100083O000452012O001E04010026D20004009E03010001000452012O009E03012O001100056O0056000600013O00122O000700663O00122O000800676O0006000800024O00050005000600202O0005000500494O00050002000200062O000500EC2O013O000452012O00EC2O010006A9000200EE2O010001000452012O00EE2O012O0011000500033O00200D0105000500214O000600013O00122O000700683O00122O000800696O00060008000200122O000700126O00050007000200062O000500EE2O010001000452012O00EE2O01002E0F006A00FA2O01006B000452012O00FA2O012O0011000500044O00EC00065O00202O00060006006C4O000700136O00050007000200062O000500FA2O013O000452012O00FA2O012O0011000500013O002O120106006D3O002O120107006E4O00FB000500074O007200055O002E45016F00A32O01006F000452012O009D03012O001100056O0056000600013O00122O000700703O00122O000800716O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005009D03013O000452012O009D03012O0011000500023O0020A10005000500164O00075O00202O0007000700724O00050007000200062O0005009D03010001000452012O009D03012O0011000500023O0020C30005000500164O00075O00202O0007000700174O00050007000200062O0005009D03013O000452012O009D03012O0011000500023O0020C30005000500164O00075O00202O0007000700114O00050007000200062O0005009D03013O000452012O009D0301002O12010500014O002C010600063O002E0F0074001D02010073000452012O001D02010026D20005001D02010001000452012O001D0201002O12010600013O002E0F007500CB02010076000452012O00CB02010026D2000600CB02010004000452012O00CB02012O001100076O0056000800013O00122O000900773O00122O000A00786O0008000A00024O00070007000800202O0007000700154O00070002000200062O0007004702013O000452012O004702012O001100076O0056000800013O00122O000900793O00122O000A007A6O0008000A00024O00070007000800202O00070007002E4O00070002000200062O0007004702013O000452012O004702012O0011000700044O001100085O00201C01080008007B2O00290107000200020006A90007004202010001000452012O00420201002E0F007D00470201007C000452012O004702012O0011000700013O002O120108007E3O002O120109007F4O00FB000700094O007200076O001100076O0043010800013O00122O000900803O00122O000A00816O0008000A00024O00070007000800202O0007000700154O00070002000200062O0007005B02010001000452012O005B02012O001100076O0056000800013O00122O000900823O00122O000A00836O0008000A00024O00070007000800202O0007000700154O00070002000200062O0007005D02013O000452012O005D0201002E570084009D03010085000452012O009D0301002E0F008600AB02010087000452012O00AB02012O001100076O0056000800013O00122O000900883O00122O000A00896O0008000A00024O00070007000800202O0007000700154O00070002000200062O000700AB02013O000452012O00AB02012O001100076O0011000800013O0012E80009008A3O00122O000A008B6O0008000A00024O00070007000800202O00070007008C2O00620007000200024O0008000D3O00122O0009008D6O000A00146O000B8O000C00013O0012E8000D008E3O00122O000E008F6O000C000E00024O000B000B000C00202O000B000B00152O0003000B000C6O000A8O00083O00024O0009000F3O00122O000A008D6O000B00146O000C8O000D00013O0012E8000E008E3O00122O000F008F6O000D000F00024O000C000C000D00202O000C000C00152O0040010C000D6O000B8O00093O00024O00080008000900062O0008009102010007000452012O009102012O0011000700153O000EB20090009F02010007000452012O009F02012O0011000700023O0020A10007000700164O00095O00202O0009000900244O00070009000200062O0007009F02010001000452012O009F02012O0011000700023O0020C30007000700164O00095O00202O00090009006C4O00070009000200062O0007009D03013O000452012O009D03012O0011000700044O001100085O00201C0108000800912O002901070002000200062C0007009D03013O000452012O009D03012O0011000700013O00129B000800923O00122O000900936O000700096O00075O00044O009D03012O001100076O0056000800013O00122O000900943O00122O000A00956O0008000A00024O00070007000800202O0007000700154O00070002000200062O000700BF02013O000452012O00BF02012O0011000700163O0006A9000700BF02010001000452012O00BF02012O0011000700023O0020C30007000700164O00095O00202O0009000900964O00070009000200062O0007009D03013O000452012O009D03012O0011000700044O001100085O00201C0108000800912O002901070002000200062C0007009D03013O000452012O009D03012O0011000700013O00129B000800973O00122O000900986O000700096O00075O00044O009D03010026D20006002202010001000452012O00220201002O12010700014O002C010800083O0026D2000700CF02010001000452012O00CF0201002O12010800013O00262E000800D602010001000452012O00D60201002E570060009103010099000452012O00910301002O12010900013O00262E000900DB02010001000452012O00DB0201002E0F009B008A0301009A000452012O008A03012O0011000A00033O0020C9000A000A00214O000B00013O00122O000C009C3O00122O000D009D6O000B000D00024O000C8O000D00013O00122O000E009E3O00122O000F009F6O000D000F00024O000C000C000D00202O000C000C00514O000C0002000200202O000C000C00A04O000A000C000200062O000A00FA02013O000452012O00FA02012O0011000A00044O0011000B5O00201C010B000B00912O0029010A000200020006A9000A00F502010001000452012O00F50201002E5700A100FA020100A2000452012O00FA02012O0011000A00013O002O12010B00A33O002O12010C00A44O00FB000A000C4O0072000A5O002E4501A5008F000100A5000452012O008903012O0011000A6O0056000B00013O00122O000C00A63O00122O000D00A76O000B000D00024O000A000A000B00202O000A000A00154O000A0002000200062O000A008903013O000452012O008903012O0011000A00073O0020C3000A000A002A4O000C5O00202O000C000C002B4O000A000C000200062O000A008903013O000452012O00890301002O12010A00014O002C010B000B3O000E6D000100130301000A000452012O00130301002E5700A8000F030100A9000452012O000F0301002O12010B00013O002E4501AA3O000100AA000452012O00140301000EF9000100140301000B000452012O001403012O0011000C6O0043010D00013O00122O000E00AB3O00122O000F00AC6O000D000F00024O000C000C000D00202O000C000C00154O000C0002000200062O000C004E03010001000452012O004E03012O0011000C00023O0020C3000C000C00164O000E5O00202O000E000E00524O000C000E000200062O000C003003013O000452012O003003012O0011000C00023O002068000C000C00104O000E5O00202O000E000E00524O000C000E000200262O000C003A030100A0000452012O003A03012O0011000C6O005D000D00013O00122O000E00AD3O00122O000F00AE6O000D000F00024O000C000C000D00202O000C000C00354O000C00020002000E2O00AF004E0301000C000452012O004E03012O0011000C6O0056000D00013O00122O000E00B03O00122O000F00B16O000D000F00024O000C000C000D00202O000C000C00154O000C0002000200062O000C005003013O000452012O005003012O0011000C00163O0006A9000C005003010001000452012O005003012O0011000C00023O0020A1000C000C00164O000E5O00202O000E000E00964O000C000E000200062O000C005003010001000452012O00500301002E5700B3005B030100B2000452012O005B03012O0011000C00044O0011000D5O00201C010D000D00912O0029010C0002000200062C000C005B03013O000452012O005B03012O0011000C00013O002O12010D00B43O002O12010E00B54O00FB000C000E4O0072000C5O002E5700B600890301009A000452012O008903012O0011000C6O0056000D00013O00122O000E00B73O00122O000F00B86O000D000F00024O000C000C000D00202O000C000C00154O000C0002000200062O000C008903013O000452012O008903012O0011000C00023O0020A1000C000C00164O000E5O00202O000E000E00524O000C000E000200062O000C007803010001000452012O007803012O0011000C6O00E2000D00013O00122O000E00B93O00122O000F00BA6O000D000F00024O000C000C000D00202O000C000C00354O000C0002000200262O000C008903010004000452012O008903012O0011000C00044O0011000D5O00201C010D000D00912O0029010C000200020006A9000C008003010001000452012O00800301002E4501BB000B000100BC000452012O008903012O0011000C00013O00129B000D00BD3O00122O000E00BE6O000C000E6O000C5O00044O00890301000452012O00140301000452012O00890301000452012O000F0301002O12010900043O00262E0009008E03010004000452012O008E0301002E5700BF00D7020100C0000452012O00D70201002O12010800043O000452012O00910301000452012O00D7020100262E0008009503010004000452012O00950301002E5700C100D2020100C2000452012O00D20201002O12010600043O000452012O00220201000452012O00D20201000452012O00220201000452012O00CF0201000452012O00220201000452012O009D0301000452012O001D0201002O12010400043O000E6D000400A203010004000452012O00A20301002E5700C300D02O0100C4000452012O00D02O012O001100056O0056000600013O00122O000700C53O00122O000800C66O0006000800024O00050005000600202O0005000500494O00050002000200062O000500C903013O000452012O00C903012O001100056O0056000600013O00122O000700C73O00122O000800C86O0006000800024O00050005000600202O0005000500154O00050002000200062O000500C903013O000452012O00C903012O0011000500073O0020C300050005002A4O00075O00202O00070007002B4O00050007000200062O000500C903013O000452012O00C903012O001100056O0053000600013O00122O000700C93O00122O000800CA6O0006000800024O00050005000600202O0005000500354O000500020002000E2O00CB00CB03010005000452012O00CB03010006A9000200CB03010001000452012O00CB0301002E0F00CC00D9030100CD000452012O00D903012O0011000500044O002201065O00202O0006000600CE4O000700176O00050007000200062O000500D403010001000452012O00D40301002E0F00CF00D9030100D0000452012O00D903012O0011000500013O002O12010600D13O002O12010700D24O00FB000500074O007200056O001100056O0056000600013O00122O000700D33O00122O000800D46O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005000C04013O000452012O000C04012O0011000500023O0020A10005000500164O00075O00202O0007000700724O00050007000200062O000500F403010001000452012O00F403012O001100056O0011000600013O0012E8000700D53O00122O000800D66O0006000800024O00050005000600202O0005000500352O00290105000200020026240105000C04010053000452012O000C04012O0011000500073O0020C300050005002A4O00075O00202O00070007002B4O00050007000200062O0005000C04013O000452012O000C04012O001100056O0053000600013O00122O000700D73O00122O000800D86O0006000800024O00050005000600202O0005000500354O000500020002000E2O00CB000E04010005000452012O000E04012O0011000500023O0020A10005000500164O00075O00202O00070007006C4O00050007000200062O0005000E04010001000452012O000E0401002E4501D90010000100DA000452012O001C04012O0011000500044O002201065O00202O0006000600524O000700186O00050007000200062O0005001704010001000452012O00170401002E4501DB0007000100DC000452012O001C04012O0011000500013O002O12010600DD3O002O12010700DE4O00FB000500074O007200055O002O12010400083O000452012O00D02O01002E0F00E00024040100DF000452012O002404010026D20001002404010062000452012O002404012O0011000400054O0097000400023O002O12010300043O000452012O000C0001000452012O000B0001000452012O00290401000452012O000200012O00293O00017O007C3O00028O00025O007EAB40025O007AA840025O0084B340025O0071B240027O0040026O001040030B3O00504D756C7469706C69657203073O0052757074757265026O00F03F03063O0042752O665570030F3O00536861646F7744616E636542752O6603083O00446562752O66557003093O0044656174686D61726B025O006EAF40025O003EA540031B3O00DF56EE411348E947E940417FBC1FD35C5472E844E9545F71F945B403063O001A9C379D3533025O00606E40025O00A4B140025O003EAD40025O00389D4003093O0088BAECC6D5017176A603083O0018C3D382A1A66310030B3O004973417661696C61626C6503073O00456E76656E6F6D025O00A07240025O00ECA940025O00109240025O0040A94003043O00750BE03A03063O00762663894C3303073O004973526561647903093O004B696E677362616E6503093O00D62F0B151A22FC280003063O00409D46657269030A3O00432O6F6C646F776E5570030A3O00446562752O66446F776E030A3O0053686976446562752O66025O00488840025O00C4A34003043O0053686976031D3O0063A9B4F75073A0AEF550089BB3E6114CBCAFA33B49A6A0F01241A6A2AA03053O007020C8C783025O0042AD40025O0036A54003093O00075952BFD0A923225503073O00424C303CD8A3CB030B3O0042752O6652656D61696E7303163O0099876AE71FE52DB4816AF15EC021FACE5DF251CD21F303073O0044DAE619933FAE03203O008E2B4058F688244549B8A227130485B92F5240A2A56A7845B8AA39514DB8A86303053O00D6CD4A332C03083O0042752O66446F776E025O004EB340025O00CC9A40031E3O00D94DF1E837DF42F4F979F541A2B45AFB5FF6F965BA6DF1EF76E95FEBF23E03053O00179A2C829C025O003EA740025O0048B140025O00A4A640025O00F09040030E3O0032B4A4A3251C1F92A8A3261602B203063O007371C6CDCE56030C3O00AA5EF9529044EA5B885CFB4803043O003AE4379E026O00084003093O00908CD13A34A034A68203073O0055D4E9B04E5CCD025O00C05940025O00EEAF40025O00B8A740025O002CA440030E3O004372696D736F6E54656D7065737403113O0046696C746572656454696D65546F44696503013O003E026O001840030D3O00446562752O6652656D61696E73025O00E06F40026O008340031E3O0069599BF60A7B9AEB474B87EC0A6C8DEF5A5D9BF60A10BBF64F5984F6421103043O00822A38E803073O00CDB436F14F2BEF03063O005F8AD5448320030A3O0049734361737461626C6503133O000FD5D11C2038D8C72O203ADBCC103428D4CC1D03053O00555CBDA37303073O0047612O726F7465025O001CAF40025O00F8A640025O009EAD40025O004CB24003263O000AAD232C698B312A3BA3243D69E4193539BE3F2E2CA8701F28BE22373DA9701426BB701B19E503043O005849CC50026O002840025O00DEA640025O00388E4003283O000D82035269FD2F9102493DDF6ECB394B39C82195154269FD2F9102493DDF6EAF1F5169F91EC3420F03063O00BA4EE3702649025O00B88340025O00E2A640025O00507540025O00E8AE40025O00EAB240025O00689740025O00809440025O0056B340025O00408A40025O00EC92402O033O002170EA03043O00384C1984025O0093B140025O00C0984003043O0047554944025O00F8AC40025O007DB040031F3O007DC0B8328F79C0B934C04AC4EB6EE653D1B929D95BC5EB01CE4CD3A432CA1703053O00AF3EA1CB46025O00C0AC40025O00307E40025O00549640025O00F2A840025O008AA440025O00707E40007D022O002O12012O00014O002C2O0100013O002E0F0003000200010002000452012O000200010026D23O000200010001000452012O00020001002O122O0100013O002E0F0005003400010004000452012O003400010026D20001003400010006000452012O003400012O001100025O000E150007007C02010002000452012O007C02012O0011000200013O0020C80002000200084O000400023O00202O0004000400094O00020004000200262O0002007C0201000A000452012O007C02012O0011000200033O0020A100020002000B4O000400023O00202O00040004000C4O00020004000200062O0002002300010001000452012O002300012O0011000200013O0020C300020002000D4O000400023O00202O00040004000E4O00020004000200062O0002007C02013O000452012O007C0201002E570010007C0201000F000452012O007C02012O0011000200044O00C4000300023O00202O0003000300094O000400056O000600056O000600066O00020006000200062O0002007C02013O000452012O007C02012O0011000200063O00129B000300113O00122O000400126O000200046O00025O00044O007C02010026D2000100042O010001000452012O00042O01002O12010200013O002E57001300FF00010014000452012O00FF00010026D2000200FF00010001000452012O00FF0001002O12010300013O0026D2000300F800010001000452012O00F80001002E57001600AE00010015000452012O00AE00012O0011000400024O0056000500063O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400194O00040002000200062O000400AE00013O000452012O00AE00012O0011000400033O0020C300040004000B4O000600023O00202O00060006001A4O00040006000200062O000400AE00013O000452012O00AE0001002O12010400014O002C010500053O002E57001B00530001001C000452012O005300010026D20004005300010001000452012O00530001002O12010500013O0026D20005005800010001000452012O00580001002E0F001D008B0001001E000452012O008B00012O0011000600024O0056000700063O00122O0008001F3O00122O000900206O0007000900024O00060006000700202O0006000600214O00060002000200062O0006008B00013O000452012O008B00012O0011000600013O0020A100060006000D4O000800023O00202O0008000800224O00060008000200062O0006007700010001000452012O007700012O0011000600024O0056000700063O00122O000800233O00122O000900246O0007000900024O00060006000700202O0006000600254O00060002000200062O0006008B00013O000452012O008B00012O0011000600013O0020C30006000600264O000800023O00202O0008000800274O00060008000200062O0006008B00013O000452012O008B0001002E0F0028008B00010029000452012O008B00012O0011000600044O0011000700023O00201C01070007002A2O002901060002000200062C0006008B00013O000452012O008B00012O0011000600063O002O120107002B3O002O120108002C4O00FB000600084O007200065O002E57002E00AE0001002D000452012O00AE00012O0011000600024O0056000700063O00122O0008002F3O00122O000900306O0007000900024O00060006000700202O0006000600214O00060002000200062O000600AE00013O000452012O00AE00012O0011000600033O00204F0106000600314O000800023O00202O00080008000C4O000600080002000E2O000600AE00010006000452012O00AE00012O0011000600044O00EC000700023O00202O0007000700224O000800076O00060008000200062O000600AE00013O000452012O00AE00012O0011000600063O00129B000700323O00122O000800336O000600086O00065O00044O00AE0001000452012O00580001000452012O00AE0001000452012O005300012O001100045O002624010400B200010007000452012O00B20001000452012O00F70001002O12010400014O002C010500053O000EF9000100B400010004000452012O00B40001002O12010500013O0026D2000500B700010001000452012O00B700012O0011000600013O0020C300060006000D4O000800023O00202O0008000800224O00060008000200062O000600D500013O000452012O00D500012O0011000600033O0020C80006000600314O000800023O00202O00080008001A4O00060008000200262O000600D500010006000452012O00D500012O0011000600044O00C4000700023O00202O00070007001A4O000800096O000A00056O000A000A6O0006000A000200062O000600D500013O000452012O00D500012O0011000600063O002O12010700343O002O12010800354O00FB000600084O007200066O0011000600083O00062C000600F700013O000452012O00F700012O0011000600094O001301060001000200062C000600F700013O000452012O00F700012O0011000600033O0020C30006000600364O000800023O00202O00080008000C4O00060008000200062O000600F700013O000452012O00F700012O0011000600044O00F8000700023O00202O00070007001A4O000800096O000A00056O000A000A6O0006000A000200062O000600EE00010001000452012O00EE0001002E450137000B00010038000452012O00F700012O0011000600063O00129B000700393O00122O0008003A6O000600086O00065O00044O00F70001000452012O00B70001000452012O00F70001000452012O00B40001002O120103000A3O00262E000300FC0001000A000452012O00FC0001002E0F003C003C0001003B000452012O003C0001002O120102000A3O000452012O00FF0001000452012O003C00010026D2000200370001000A000452012O00370001002O122O01000A3O000452012O00042O01000452012O00370001002E57003E00070001003D000452012O000700010026D2000100070001000A000452012O00070001002O12010200013O0026D20002000D2O01000A000452012O000D2O01002O122O0100063O000452012O000700010026D2000200092O010001000452012O00092O012O00110003000A3O00062C000300362O013O000452012O00362O012O0011000300024O0056000400063O00122O0005003F3O00122O000600406O0004000600024O00030003000400202O0003000300214O00030002000200062O000300362O013O000452012O00362O012O0011000300024O0056000400063O00122O000500413O00122O000600426O0004000600024O00030003000400202O0003000300194O00030002000200062O000300362O013O000452012O00362O012O00110003000B3O000E15004300362O010003000452012O00362O012O001100035O000E15000700362O010003000452012O00362O012O0011000300024O0056000400063O00122O000500443O00122O000600456O0004000600024O00030003000400202O0003000300214O00030002000200062O000300382O013O000452012O00382O01002E450146002A00010047000452012O00602O012O00110003000C4O00110004000D4O0030010300020005000452012O005E2O01002E0F0049005E2O010048000452012O005E2O012O00110008000E4O0051010900074O00EC000A00023O00202O000A000A004A4O000B000F6O0008000B000200062O0008005E2O013O000452012O005E2O0100206500080007004B001219010A004C3O00122O000B004D3O00202O000C0007004E4O000E00023O00202O000E000E004A4O000C000E00024O000C000C6O0008000C000200062O0008005E2O013O000452012O005E2O012O0011000800044O0011000900023O00201C01090009004A2O00290108000200020006A9000800592O010001000452012O00592O01002E0F0050005E2O01004F000452012O005E2O012O0011000800063O002O12010900513O002O12010A00524O00FB0008000A4O007200085O00062F0103003C2O010002000452012O003C2O012O0011000300024O0056000400063O00122O000500533O00122O000600546O0004000600024O00030003000400202O0003000300554O00030002000200062O0003007702013O000452012O007702012O0011000300104O0013010300010002000ECD0001007702010003000452012O00770201002O12010300014O002C010400063O0026D2000300710201000A000452012O007102012O002C010600063O0026D2000400E42O010043000452012O00E42O012O0011000700114O0038010800123O00122O0009000A6O000A00136O000B00026O000C00063O00122O000D00563O00122O000E00576O000C000E00024O000B000B000C00202O000B000B00194O000B000C6O000A3O000200102O000A0006000A4O0008000A00024O000900143O00122O000A000A6O000B00136O000C00026O000D00063O00122O000E00563O00122O000F00576O000D000F00024O000C000C000D00202O000C000C00194O000C000D6O000B3O000200102O000B0006000B4O0009000B00024O00080008000900062O0008007702010007000452012O00770201002O12010700013O000EF9000100962O010007000452012O00962O012O0011000800033O0020C30008000800364O000A00023O00202O000A000A000C4O0008000A000200062O000800B12O013O000452012O00B12O012O0011000800013O0020110108000800084O000A00023O00202O000A000A00584O0008000A000200262O000800B32O01000A000452012O00B32O012O0011000800013O0020C300080008000D4O000A00023O00202O000A000A000E4O0008000A000200062O000800B12O013O000452012O00B12O012O0011000800154O00130108000100020026C2000800B32O010043000452012O00B32O01002E57005900C32O01005A000452012O00C32O012O0011000800044O00F8000900023O00202O0009000900584O000A000B6O000C00056O000C000C6O0008000C000200062O000800BE2O010001000452012O00BE2O01002E0F005C00C32O01005B000452012O00C32O012O0011000800063O002O120109005D3O002O12010A005E4O00FB0008000A4O007200086O0011000800013O0020110108000800084O000A00023O00202O000A000A00584O0008000A000200262O000800D32O01000A000452012O00D32O012O0011000800013O00206800080008004E4O000A00023O00202O000A000A00584O0008000A000200262O000800D32O01005F000452012O00D32O01002E570060007702010061000452012O007702012O0011000800044O00C4000900023O00202O0009000900584O000A000B6O000C00056O000C000C6O0008000C000200062O0008007702013O000452012O007702012O0011000800063O00129B000900623O00122O000A00636O0008000A6O00085O00044O00770201000452012O00962O01000452012O0077020100262E000400E82O01000A000452012O00E82O01002E0F006500FC2O010064000452012O00FC2O01002O12010700013O000E6D000100ED2O010007000452012O00ED2O01002E0F006700F72O010066000452012O00F72O012O002C010600063O00067900063O000100072O00113O00024O00113O00164O00113O00174O00113O00064O00113O000B4O00113O00084O00113O00183O002O120107000A3O0026D2000700E92O01000A000452012O00E92O01002O12010400063O000452012O00FC2O01000452012O00E92O0100262E00042O0002010006000452013O000201002E570068004F02010069000452012O004F0201002O12010700013O000EF90001004802010007000452012O004802012O00110008000A3O00062C0008003202013O000452012O00320201002O12010800014O002C0109000A3O00262E0008000C0201000A000452012O000C0201002E0F006B002C0201006A000452012O002C020100262E0009001002010001000452012O00100201002E45016C00FEFF2O006D000452012O000C02012O0011000B00194O00AA000C00063O00122O000D006E3O00122O000E006F6O000C000E00024O000D00056O000E00066O000B000E00024O000A000B3O002E2O0071003202010070000452012O0032020100062C000A003202013O000452012O00320201002065000B000A00722O003E010B000200024O000C00013O00202O000C000C00724O000C0002000200062O000B00320201000C000452012O003202012O0011000B00044O003B010C000A6O000D00023O00202O000D000D00584O000B000D000100044O00320201000452012O000C0201000452012O003202010026D20008000802010001000452012O00080201002O12010900014O002C010A000A3O002O120108000A3O000452012O00080201002E570073004702010074000452012O004702012O0051010800064O0011000900014O002901080002000200062C0008004702013O000452012O004702012O0011000800044O00C4000900023O00202O0009000900584O000A000B6O000C00056O000C000C6O0008000C000200062O0008004702013O000452012O004702012O0011000800063O002O12010900753O002O12010A00764O00FB0008000A4O007200085O002O120107000A3O00262E0007004C0201000A000452012O004C0201002E570077000102010078000452012O00010201002O12010400433O000452012O004F0201000452012O000102010026D2000400732O010001000452012O00732O01002O12010700014O002C010800083O000EF90001005302010007000452012O00530201002O12010800013O0026D20008005A0201000A000452012O005A0201002O120104000A3O000452012O00732O01002E57007900560201007A000452012O005602010026D20008005602010001000452012O00560201002O12010900013O0026D2000900630201000A000452012O00630201002O120108000A3O000452012O00560201002E0F007C005F0201007B000452012O005F02010026D20009005F02010001000452012O005F02012O002C010500053O00067900050001000100012O00113O00023O002O120109000A3O000452012O005F0201000452012O00560201000452012O00732O01000452012O00530201000452012O00732O01000452012O007702010026D2000300702O010001000452012O00702O01002O12010400014O002C010500053O002O120103000A3O000452012O00702O01002O120102000A3O000452012O00092O01000452012O00070001000452012O007C0201000452012O000200012O00293O00013O00023O000F3O00030B3O00504D756C7469706C69657203073O0047612O726F7465026O00F03F030D3O00446562752O6652656D61696E7303113O00457873616E6775696E6174656452617465026O002840028O0003073O000D29B351793E2D03053O00164A48C123030F3O0041757261416374697665436F756E7403113O0046696C746572656454696D65546F44696503013O003E027O004003133O0054696D65546F44696549734E6F7456616C6964030A3O0043616E446F54556E6974013E3O0020112O013O00014O00035O00202O0003000300024O00010003000200262O0001002200010003000452012O0022000100206500013O00042O00FD00035O00202O0003000300024O0001000300024O000200013O00202O0002000200054O00038O00045O00202O0004000400024O00020004000200102O00020006000200062O0001002200010002000452012O002200012O0011000100024O00132O0100010002000ECD0007003A00010001000452012O003A00012O001100016O0011000200033O0012E8000300083O00122O000400096O0002000400024O00010001000200202O00010001000A2O00292O01000200022O0011000200043O00066E0001003A00010002000452012O003A00012O0011000100053O0006A90001003A00010001000452012O003A000100206500013O000B00121B0103000C3O00122O0004000D3O00202O00053O00044O00075O00202O0007000700024O0005000700024O000500056O00010005000200062O0001003400010001000452012O0034000100206500013O000E2O00292O010002000200062C0001003C00013O000452012O003C00012O0011000100013O00206C00010001000F4O00028O000300066O00010003000200044O003C00012O001400016O005A000100014O0097000100024O00293O00017O00023O00030D3O00446562752O6652656D61696E7303073O0047612O726F746501063O00200A00013O00014O00035O00202O0003000300024O000100036O00019O0000017O00563O00028O00025O0014B140025O00B2A640026O00F03F027O0040025O00B89140025O0008804003073O00925615FAB5510003043O008EC0236503073O0049735265616479026O001040025O00D2AA40025O00ECA340025O00707940025O00349F4003103O00F2743AABEE82AB25D57A3CADE39EA91A03083O0076B61549C387ECCC030B3O004973417661696C61626C65026O00144003093O002C33154D0601FC0C3903073O009D685C7A20646D026O001840025O00BC9640025O0032A040025O0022AB40025O00E2B140025O00AEA340025O00F2A840030A3O0043616E446F54556E6974025O00F07C40025O0049B34003073O0052757074757265025O002EAF40025O005CAD40030C3O0080A7DCDE7D1598BBB7B3DDCF03083O00CBC3C6AFAA5D47ED025O0023B140025O00F8A14003073O00094A2CC75E05F903073O009C4E2B5EB53171030A3O0049734361737461626C65030B3O00504D756C7469706C69657203073O0047612O726F7465030D3O00446562752O6652656D61696E73026O00084003113O0046696C746572656454696D65546F44696503013O003E03133O0054696D65546F44696549734E6F7456616C6964025O00CDB040025O00C8A44003123O0055E9D6B104577C32A0E2A2074F7B73EBCFEA03073O00191288A4C36B23025O00D89840025O000AA840025O000BB040025O00149040025O00CC9C40025O0048AE40025O006BB240025O00189240030E3O00AFCA1FD4AB5F82EC13D4A8559FCC03063O0030ECB876B9D8026O00394003093O00C1B85624C739E4AF5C03063O005485DD3750AF030E3O004372696D736F6E54656D70657374025O00149F4003263O009EE637B2877FAFEE29B5C852FDD321ABD759AEF364EEE65398A70CAFC054FDC22AA3D55BA4AE03063O003CDD8744C6A703073O00C9BCEA914DCDEB03063O00B98EDD98E322025O00B4A840025O0007B040025O005EA940025O0030B140026O00284003153O0068CA58F60335F84A8570FB5121F84CC017B27007BE03073O009738A5379A2353025O0062AD40025O0072A540025O00208840025O0050B040025O009CA540025O00708440025O00DBB240025O0084A240002F022O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O002O12010200013O00262E0002000A00010001000452012O000A0001002E0F0002002102010003000452012O00210201000EF90004003A2O010001000452012O003A2O01002O12010300013O0026D20003001100010004000452012O00110001002O122O0100053O000452012O003A2O010026D20003000D00010001000452012O000D0001002E0F000700E700010006000452012O00E700012O001100046O0056000500013O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400E700013O000452012O00E700012O0011000400023O000E15000B00E700010004000452012O00E70001002O12010400014O002C010500063O000EF90001002900010004000452012O00290001002O12010500014O002C010600063O002O12010400043O000E6D0004002D00010004000452012O002D0001002E45010C00F9FF2O000D000452012O002400010026D20005009B00010001000452012O009B0001002O12010700013O002E57000E00360001000F000452012O00360001000EF90004003600010007000452012O00360001002O12010500043O000452012O009B00010026D20007003000010001000452012O003000012O0011000800044O001B000900043O00122O000A000B6O000B00056O000C8O000D00013O0012E8000E00103O00122O000F00116O000D000F00024O000C000C000D00202O000C000C00122O00D7000C000D6O000B3O000200202O000B000B00134O0009000B00024O000A00063O00122O000B000B6O000C00056O000D8O000E00013O0012E8000F00103O00122O001000116O000E001000024O000D000D000E00202O000D000D00122O0073000D000E6O000C3O000200202O000C000C00134O000A000C00024O00090009000A4O000A00056O000B8O000C00013O0012E8000D00143O00122O000E00156O000C000E00024O000B000B000C00202O000B000B00122O003F000B000C6O000A3O000200202O000A000A00134O00090009000A4O000A00056O000B00076O000A0002000200202O000A000A00164O0008000A00024O000900064O001B000A00043O00122O000B000B6O000C00056O000D8O000E00013O0012E8000F00103O00122O001000116O000E001000024O000D000D000E00202O000D000D00122O00D7000D000E6O000C3O000200202O000C000C00134O000A000C00024O000B00063O00122O000C000B6O000D00056O000E8O000F00013O0012E8001000103O00122O001100116O000F001100024O000E000E000F00202O000E000E00122O0073000E000F6O000D3O000200202O000D000D00134O000B000D00024O000A000A000B4O000B00056O000C8O000D00013O0012E8000E00143O00122O000F00156O000D000F00024O000C000C000D00202O000C000C00122O0012000C000D6O000B3O000200202O000B000B00134O000A000A000B4O000B00056O000C00076O000B0002000200202O000B000B00164O0009000B00024O0008000800092O001A000800034O002C010600063O002O12010700043O000452012O0030000100262E0005009F00010004000452012O009F0001002E57001800CF00010017000452012O00CF0001002O12010700013O00262E000700A400010004000452012O00A40001002E0F001A00A600010019000452012O00A60001002O12010500053O000452012O00CF0001002E0F001B00A00001001C000452012O00A00001000EF9000100A000010007000452012O00A0000100067900063O000100042O00113O00084O00118O00113O00094O00113O00034O0051010800064O00110009000A4O002901080002000200062C000800BB00013O000452012O00BB00012O00110008000B3O00202701080008001D4O0009000A6O000A000C6O0008000A000200062O000800BD00010001000452012O00BD0001002E57001F00CD0001001E000452012O00CD00012O00110008000D4O00F800095O00202O0009000900204O000A000B6O000C000E6O000C000C6O0008000C000200062O000800C800010001000452012O00C80001002E57002100CD00010022000452012O00CD00012O0011000800013O002O12010900233O002O12010A00244O00FB0008000A4O007200085O002O12010700043O000452012O00A000010026D20005002D00010005000452012O002D00012O00110007000F3O00062C000700DA00013O000452012O00DA00012O0011000700073O00062C000700DC00013O000452012O00DC00012O0011000700103O00062C000700DC00013O000452012O00DC0001002E57002500E700010026000452012O00E700012O0011000700114O004101085O00202O0008000800204O000900066O000A00036O000B00126O0007000B000100044O00E70001000452012O002D0001000452012O00E70001000452012O002400012O001100046O0056000500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O0004000400294O00040002000200062O000400382O013O000452012O00382O012O0011000400133O000E15000400382O010004000452012O00382O012O0011000400144O0013010400010002002609010400382O010001000452012O00382O012O00110004000A3O00201101040004002A4O00065O00202O00060006002B4O00040006000200262O0004000A2O010004000452012O000A2O012O00110004000A3O00207A00040004002C4O00065O00202O00060006002B4O0004000600024O000500153O00062O000400382O010005000452012O00382O012O0011000400163O000E15002D00382O010004000452012O00382O012O00110004000A3O00204C00040004002C4O00065O00202O00060006002B4O0004000600024O000500153O00202O00050005000500062O000400382O010005000452012O00382O012O0011000400163O000E15002D00382O010004000452012O00382O012O00110004000A3O00206500040004002E002O120106002F3O00121A0107000B6O0008000A3O00202O00080008002C4O000A5O00202O000A000A002B4O0008000A00024O000800086O00040008000200062O000400282O010001000452012O00282O012O00110004000A3O0020650004000400302O002901040002000200062C000400382O013O000452012O00382O012O00110004000D4O00F800055O00202O00050005002B4O000600076O0008000E6O000800086O00040008000200062O000400332O010001000452012O00332O01002E450131000700010032000452012O00382O012O0011000400013O002O12010500333O002O12010600344O00FB000400064O007200045O002O12010300043O000452012O000D0001002E570035002002010036000452012O002002010026D20001002002010001000452012O00200201002O12010300014O002C010400043O00262E000300442O010001000452012O00442O01002E57003700402O010038000452012O00402O01002O12010400013O000EF9000400492O010004000452012O00492O01002O122O0100043O000452012O002002010026D2000400452O010001000452012O00452O01002O12010500013O00262E000500502O010004000452012O00502O01002E45013900040001003A000452012O00522O01002O12010400043O000452012O00452O010026D20005004C2O010001000452012O004C2O01002E57003C00A22O01003B000452012O00A22O012O00110006000F3O00062C000600A22O013O000452012O00A22O012O001100066O0056000700013O00122O0008003D3O00122O0009003E6O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600A22O013O000452012O00A22O012O0011000600163O000E15000500A22O010006000452012O00A22O012O0011000600023O000E15000B00A22O010006000452012O00A22O012O0011000600173O000ECD003F00A22O010006000452012O00A22O012O001100066O0043010700013O00122O000800403O00122O000900416O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600A22O010001000452012O00A22O012O0011000600184O0011000700194O0030010600020008000452012O00A02O012O0011000B00084O0051010C000A4O00EC000D5O00202O000D000D00424O000E001A6O000B000E000200062O000B00A02O013O000452012O00A02O01002065000B000A002A2O0011000D5O00201C010D000D00422O0002010B000D0002002609010B00A02O010004000452012O00A02O01002065000B000A002E001219010D002F3O00122O000E00163O00202O000F000A002C4O00115O00202O0011001100424O000F001100024O000F000F6O000B000F000200062O000B00A02O013O000452012O00A02O01002E450143000D00010043000452012O00A02O012O0011000B000D4O0011000C5O00201C010C000C00422O0029010B0002000200062C000B00A02O013O000452012O00A02O012O0011000B00013O002O12010C00443O002O12010D00454O00FB000B000D4O0072000B5O00062F0106007A2O010002000452012O007A2O012O001100066O0056000700013O00122O000800463O00122O000900476O0007000900024O00060006000700202O0006000600294O00060002000200062O000600AF2O013O000452012O00AF2O012O0011000600133O000E1E010400B12O010006000452012O00B12O01002E450148006C00010049000452012O001B0201002O12010600014O002C010700083O00262E000600B72O010004000452012O00B72O01002E45014A00600001004B000452012O00150201000EF9000400F82O010007000452012O00F82O012O0051010900084O0011000A000A4O002901090002000200062C000900E52O013O000452012O00E52O012O00110009000B3O0020DF00090009001D4O000A000A6O000B001B6O0009000B000200062O000900E52O013O000452012O00E52O012O00110009000A3O00206500090009002E002O12010B002F3O00121A010C004C6O000D000A3O00202O000D000D002C4O000F5O00202O000F000F002B4O000D000F00024O000D000D6O0009000D000200062O000900D72O010001000452012O00D72O012O00110009000A3O0020650009000900302O002901090002000200062C000900E52O013O000452012O00E52O012O00110009001C4O00C4000A5O00202O000A000A002B4O000B000B6O000C000E6O000C000C6O0009000C000200062O000900E52O013O000452012O00E52O012O0011000900013O002O12010A004D3O002O12010B004E4O00FB0009000B4O007200095O002E0F0050001B0201004F000452012O001B02012O00110009000F3O00062C0009001B02013O000452012O001B02012O0011000900073O0006A90009001B02010001000452012O001B02012O0011000900163O000E150005001B02010009000452012O001B02012O0011000900114O0047010A5O00202O000A000A002B4O000B00083O00122O000C004C6O000D00126O0009000D000100044O001B0201002E0F005100B72O010052000452012O00B72O01000EF9000100B72O010007000452012O00B72O01002O12010900013O0026D20009000E02010001000452012O000E0201002O12010A00013O0026D2000A000402010004000452012O00040201002O12010900043O000452012O000E0201002E5700542O0002010053000452013O0002010026D2000A2O0002010001000452013O0002012O002C010800083O00067900080001000100022O00113O00084O00117O002O12010A00043O000452013O000201000EF9000400FD2O010009000452012O00FD2O01002O12010700043O000452012O00B72O01000452012O00FD2O01000452012O00B72O01000452012O001B02010026D2000600B32O010001000452012O00B32O01002O12010700014O002C010800083O002O12010600043O000452012O00B32O01002O12010500043O000452012O004C2O01000452012O00452O01000452012O00200201000452012O00402O01002O12010200043O0026D20002000600010004000452012O0006000100262E0001002702010005000452012O00270201002E45015500E0FD2O0056000452012O000500012O005A00036O0097000300023O000452012O00050001000452012O00060001000452012O00050001000452012O002E0201000452012O000200012O00293O00013O00023O00073O0003073O0052757074757265030B3O00504D756C7469706C696572026O00F03F03113O0046696C746572656454696D65546F44696503013O003E030D3O00446562752O6652656D61696E7303133O0054696D65546F44696549734E6F7456616C696401204O00B100018O00028O000300013O00202O0003000300014O000400026O00010004000200062O0001001E00013O000452012O001E000100206500013O00022O0011000300013O00201C0103000300012O00022O01000300020026092O01001C00010003000452012O001C000100206500013O000400121A010300056O000400033O00202O00053O00064O000700013O00202O0007000700014O0005000700024O000500056O00010005000200062O0001001E00010001000452012O001E000100206500013O00072O00292O0100020002000452012O001E00012O001400016O005A000100014O0097000100024O00293O00017O00033O0003073O0047612O726F7465030B3O00504D756C7469706C696572026O00F03F01114O008300018O00028O000300013O00202O0003000300014O00010003000200062O0001000F00013O000452012O000F000100206500013O00022O0011000300013O00201C0103000300012O00022O010003000200269F0001000E00010003000452012O000E00012O001400016O005A000100014O0097000100024O00293O00017O00A73O00028O00025O006CA340025O0046A640026O00F03F025O0020AF40025O00749940026O000840025O0052A340025O005EAA40025O0016B340025O00CC9E40026O001040025O0044A440025O0058964003063O0034FBF20C184E03063O0026759690796B030A3O0049734361737461626C65030E3O000CB6EC2F3EB3C12C28A9FC3329BE03043O005A4DDB8E03093O00537465616C7468557003063O0042752O665570030D3O00426C696E647369646542752O66030A3O0053657073697342752O66030A3O00446562752O66446F776E03093O004B696E677362616E6503093O0044656174686D61726B03063O00416D62757368030B3O00C505322D0C2677E411323103073O001A866441592C67025O00CDB240025O00C1B14003083O00DCF6242AA8F0F73503053O00C491835043027O004003123O00446561646C79506F69736F6E446562752O6603163O00416D706C696679696E67506F69736F6E446562752O66025O0033B340025O001DB34003043O0047554944025O002FB04003083O00446562752O66557003073O0047612O726F746503073O005275707475726503083O004D7574696C617465025O001C9340025O00ACAA40025O00207C40025O00AAA340030E3O009ACFC52C5BB0CDE32F4EADDAD52D03053O002FD9AEB05F030B3O004973417661696C61626C65030D3O00446562752O6652656D61696E7303143O00436175737469635370612O746572446562752O66025O0076A140025O00F88C4003083O0095C8620BBE556C2303083O0046D8BD1662D23418025O0032A040025O0015B04003173O00F9DEB02O93F7CAB78EDFDBCBA6C79BF9DEB092C7D3DCEA03053O00B3BABFC3E703063O00D8321AF1EA3703043O0084995F78030E3O0090BF0C38E4D28FA7B71C3FFEDEA503073O00C0D1D26E4D97BA025O008EA740025O003AB240025O003C9040025O00AEB04003153O00C30231FDBFE5ED0137FAF784A82023FCECD0E9006B03063O00A4806342899F03113O00338CFBAC019DECBA2286E7BB3399E0B50503043O00DE60E98903073O004973526561647903173O0053652O7261746564426F6E655370696B65446562752O66025O00405F40025O0042A04003113O0053652O7261746564426F6E655370696B6503183O009AB2B40BC8C0F5ABA1A60B8DF7B09BBCA91AC8C0E0B0B8A203073O0090D9D3C77FE893025O00349D40025O0024B340030C3O004361737454617267657449662O033O00F5263003083O0024984F5E48B5256203183O00F4D9542B97EB422DC5D9533AD3986530D9DD0777F6D7627603043O005FB7B827029A5O99E93F025O00C49B40025O00E0A94003103O00426F2O73466967687452656D61696E73026O00144003113O00863AF534559407B11DE82851B312BC34E203073O0062D55F874634E0030A3O004D61784368617267657303113O00CDA6DB6555EAA6CD555BF0A6FA675DF5A603053O00349EC3A91703113O00436861726765734672616374696F6E616C026O00D03F03263O0059BD2160C6067E9968BD26718275598474B97247963C708E3AF416618B253BA872BD2073837C03083O00EB1ADC5214E6551B030A3O0053686976446562752O66025O00489240025O00A49D40031F3O00ABA0FAD634BBA4FBD0759CA4ED825687AFEC824798A8E2C734C092E1CB62C103053O0014E8C189A2025O00C08B40025O00808740025O0022A840025O006EAF4003073O00CD23BF4A7CB3CC03083O00D8884DC92F12DCA1030B3O00446562752O66537461636B026O003440030A3O0043504D61785370656E64025O00F2B240025O0098964003073O00456E76656E6F6D030C3O000EED38CE48F98C3BE925D50503073O00E24D8C4BBA68BC025O0040A840025O00E88F40025O00C09840025O004CB140025O00B09440025O00209E4003083O0033A5120114E90AB503063O00887ED0666878025O0015B240030D3O005B8BDD57EF7F28457186CF57AA03083O003118EAAE23CF325D025O00BEA640025O007AAE40025O00B07740025O0034954003103O0007DCCDA9EE82104327CFD7AFEA8D197503083O001142BFA5C687EC7703103O004563686F696E6752657072696D616E64025O00C49540025O00A0764003163O002CAEBD07BFCDEFD900A6A014BFDAE9C11DA6A312F1EC03083O00B16FCFCE739F888C025O00D09640030B3O0023881E1BD264510C9F150703073O003F65E97074B42F025O0078AB40025O00409540025O00889D40025O00C05E40025O004C9A40025O0002A84003143O00E729EC15F738F73EE002FD24C63FCF1EF932C62803063O0056A35B8D7298025O00089E40025O00DAA440030B3O0046616E6F664B6E6976657303123O00700A2O677A750A7A3335554B5F7D33450E6703053O005A336B1413030C3O00446561646C79506F69736F6E025O00406040025O00A0A940025O0042B340025O005DB040031F3O00AEF196FB7DABF18BAF328BB0AEE1349BF596AF75A9C0C5DD388BE280FC35C403053O005DED90E58F025O003C9240025O004497400034032O002O12012O00014O002C2O0100013O00262E3O000600010001000452012O00060001002E0F0003000200010002000452012O00020001002O122O0100013O002O12010200013O00262E0002000C00010004000452012O000C0001002E45010500E22O010006000452012O00EC2O0100262E0001001000010007000452012O00100001002E0F000900C000010008000452012O00C00001002O12010300013O00262E0003001500010004000452012O00150001002E45010A00040001000B000452012O00170001002O122O01000C3O000452012O00C0000100262E0003001B00010001000452012O001B0001002E57000D00110001000E000452012O001100012O001100046O0043010500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O00040002000200062O0004002F00010001000452012O002F00012O001100046O0056000500013O00122O000600123O00122O000700136O0005000700024O00040004000500202O0004000400114O00040002000200062O0004006700013O000452012O006700012O0011000400023O002O200004000400144O000600016O000700016O00040007000200062O0004004400010001000452012O004400012O0011000400023O0020A10004000400154O00065O00202O0006000600164O00040006000200062O0004004400010001000452012O004400012O0011000400023O0020C30004000400154O00065O00202O0006000600174O00040006000200062O0004006700013O000452012O006700012O0011000400033O0020A10004000400184O00065O00202O0006000600194O00040006000200062O0004005900010001000452012O005900012O0011000400033O0020A10004000400184O00065O00202O00060006001A4O00040006000200062O0004005900010001000452012O005900012O0011000400023O0020C30004000400154O00065O00202O0006000600164O00040006000200062O0004006700013O000452012O006700012O0011000400044O00C400055O00202O00050005001B4O000600066O000700056O000700076O00040007000200062O0004006700013O000452012O006700012O0011000400013O002O120105001C3O002O120106001D4O00FB000400064O007200045O002E0F001F00BE0001001E000452012O00BE00012O001100046O0056000500013O00122O000600203O00122O000700216O0005000700024O00040004000500202O0004000400114O00040002000200062O000400BE00013O000452012O00BE00012O0011000400063O0026D2000400BE00010022000452012O00BE00012O0011000400033O0020DE0004000400184O00065O00202O0006000600234O000700016O00040007000200062O000400BE00013O000452012O00BE00012O0011000400033O0020DE0004000400184O00065O00202O0006000600244O000700016O00040007000200062O000400BE00013O000452012O00BE0001002O12010400014O002C010500053O00262E0004008C00010001000452012O008C0001002E0F0025008800010026000452012O008800012O0011000600033O0020660006000600274O0006000200024O000500066O000600076O000700086O00060002000800044O00BA0001002E450128002600010028000452012O00BA0001002065000B000A00272O0029010B00020002000632010B00BA00010005000452012O00BA0001002065000B000A00292O0011000D5O00201C010D000D002A2O0002010B000D00020006A9000B00A600010001000452012O00A60001002065000B000A00292O0011000D5O00201C010D000D002B2O0002010B000D000200062C000B00BA00013O000452012O00BA0001002065000B000A00292O00B8000D5O00202O000D000D00234O000E00016O000B000E000200062O000B00BA00010001000452012O00BA0001002065000B000A00292O00B8000D5O00202O000D000D00244O000E00016O000B000E000200062O000B00BA00010001000452012O00BA00012O0011000B00094O003B010C000A6O000D5O00202O000D000D002C4O000B000D000100044O00BE000100062F0106009400010002000452012O00940001000452012O00BE0001000452012O00880001002O12010300043O000452012O001100010026D2000100EB2O010004000452012O00EB2O01002O12010300013O002E0F002D00E42O01002E000452012O00E42O010026D2000300E42O010001000452012O00E42O01002O12010400013O002E0F002F00DF2O010030000452012O00DF2O010026D2000400DF2O010001000452012O00DF2O012O00110005000A3O0006A9000500442O010001000452012O00442O012O001100056O0056000600013O00122O000700313O00122O000800326O0006000800024O00050005000600202O0005000500334O00050002000200062O000500442O013O000452012O00442O012O0011000500033O0020C30005000500294O00075O00202O00070007002B4O00050007000200062O000500442O013O000452012O00442O012O0011000500033O0020C80005000500344O00075O00202O0007000700354O00050007000200262O000500442O010022000452012O00442O01002O12010500014O002C010600063O002E4501363O00010036000452012O00E900010026D2000500E900010001000452012O00E90001002O12010600013O0026D2000600EE00010001000452012O00EE0001002E570037000C2O010030000452012O000C2O012O001100076O0056000800013O00122O000900383O00122O000A00396O0008000A00024O00070007000800202O0007000700114O00070002000200062O0007000C2O013O000452012O000C2O012O0011000700094O00F800085O00202O00080008002C4O0009000A6O000B00056O000B000B6O0007000B000200062O000700072O010001000452012O00072O01002E0F003B000C2O01003A000452012O000C2O012O0011000700013O002O120108003C3O002O120109003D4O00FB000700094O007200076O001100076O0043010800013O00122O0009003E3O00122O000A003F6O0008000A00024O00070007000800202O0007000700114O00070002000200062O000700202O010001000452012O00202O012O001100076O0056000800013O00122O000900403O00122O000A00416O0008000A00024O00070007000800202O0007000700114O00070002000200062O0007002E2O013O000452012O002E2O012O0011000700023O002O200007000700144O000900016O000A00016O0007000A000200062O000700302O010001000452012O00302O012O0011000700023O0020A10007000700154O00095O00202O0009000900164O00070009000200062O000700302O010001000452012O00302O01002E0F004300442O010042000452012O00442O01002E0F004400442O010045000452012O00442O012O0011000700094O00C400085O00202O00080008001B4O0009000A6O000B00056O000B000B6O0007000B000200062O000700442O013O000452012O00442O012O0011000700013O00129B000800463O00122O000900476O000700096O00075O00044O00442O01000452012O00EE0001000452012O00442O01000452012O00E900012O001100056O0056000600013O00122O000700483O00122O000800496O0006000800024O00050005000600202O00050005004A4O00050002000200062O000500DE2O013O000452012O00DE2O012O0011000500033O0020A10005000500294O00075O00202O00070007004B4O00050007000200062O000500662O010001000452012O00662O01002E0F004C00DE2O01004D000452012O00DE2O012O0011000500094O00C400065O00202O00060006004E4O000700076O0008000B6O000800086O00050008000200062O000500DE2O013O000452012O00DE2O012O0011000500013O00129B0006004F3O00122O000700506O000500076O00055O00044O00DE2O01002O12010500014O002C010600073O0026D2000500D62O010004000452012O00D62O010026D20006006A2O010001000452012O006A2O01002O12010700013O0026D20007006D2O010001000452012O006D2O012O00110008000C3O0006A9000800742O010001000452012O00742O01002E450151001500010052000452012O00872O012O00110008000D3O0020710008000800534O00095O00202O00090009004E4O000A000E6O000B00013O00122O000C00543O00122O000D00556O000B000D00024O000C000F6O000D00106O0008000D000200062O000800872O013O000452012O00872O012O0011000800013O002O12010900563O002O12010A00574O00FB0008000A4O007200086O0011000800114O0013010800010002000E1E015800DE2O010008000452012O00DE2O01002E57005A008E2O010059000452012O008E2O01000452012O00DE2O012O0011000800123O00201C01080008005B2O001301080001000200269F000800A62O01005C000452012O00A62O012O001100086O000D000900013O00122O000A005D3O00122O000B005E6O0009000B00024O00080008000900202O00080008005F4O0008000200024O00098O000A00013O00122O000B00603O00122O000C00616O000A000C00024O00090009000A00202O0009000900624O0009000200024O00080008000900262O000800B62O010063000452012O00B62O012O0011000800094O004900095O00202O00090009004E4O000A000A6O000B00016O000C000B6O000C000C6O0008000C000200062O000800DE2O013O000452012O00DE2O012O0011000800013O00129B000900643O00122O000A00656O0008000A6O00085O00044O00DE2O012O00110008000A3O0006A9000800C02O010001000452012O00C02O012O0011000800033O0020A10008000800294O000A5O00202O000A000A00664O0008000A000200062O000800C22O010001000452012O00C22O01002E0F006800DE2O010067000452012O00DE2O012O0011000800094O004900095O00202O00090009004E4O000A000A6O000B00016O000C000B6O000C000C6O0008000C000200062O000800DE2O013O000452012O00DE2O012O0011000800013O00129B000900693O00122O000A006A6O0008000A6O00085O00044O00DE2O01000452012O006D2O01000452012O00DE2O01000452012O006A2O01000452012O00DE2O01002E57006C00682O01006B000452012O00682O010026D2000500682O010001000452012O00682O01002O12010600014O002C010700073O002O12010500043O000452012O00682O01002O12010400043O0026D2000400C800010004000452012O00C80001002O12010300043O000452012O00E42O01000452012O00C8000100262E000300E82O010004000452012O00E82O01002E0F006E00C30001006D000452012O00C30001002O122O0100223O000452012O00EB2O01000452012O00C30001002O12010200223O0026D20002005E02010001000452012O005E02010026D20001003702010001000452012O00370201002O12010300013O0026D2000300F52O010004000452012O00F52O01002O122O0100043O000452012O003702010026D2000300F12O010001000452012O00F12O012O001100046O0056000500013O00122O0006006F3O00122O000700706O0005000700024O00040004000500202O00040004004A4O00040002000200062O0004001702013O000452012O001702012O0011000400133O000E15000C001702010004000452012O001702012O0011000400143O0006A90004001902010001000452012O001902012O0011000400033O0020330004000400714O00065O00202O0006000600244O000400060002000E2O0072001902010004000452012O001902012O0011000400134O0011000500153O00201C0105000500732O00130105000100020006640005001902010004000452012O001902012O00110004000A3O00062C0004001902013O000452012O00190201002E450174001000010075000452012O002702012O0011000400094O00C400055O00202O0005000500764O000600076O000800056O000800086O00040008000200062O0004002702013O000452012O002702012O0011000400013O002O12010500773O002O12010600784O00FB000400064O007200046O0011000400163O000EB20004003102010004000452012O003102012O0011000400143O0006A90004003102010001000452012O003102012O00110004000A4O003A000400043O00062C0004003302013O000452012O00330201002E45017900040001007A000452012O003502012O005A00046O0097000400023O002O12010300043O000452012O00F12O01002E0F007B005D0201007C000452012O005D0201000EF9000C005D02010001000452012O005D0201002O12010300013O002E0F007D003C0201007E000452012O003C02010026D20003003C02010001000452012O003C02012O001100046O0056000500013O00122O0006007F3O00122O000700806O0005000700024O00040004000500202O0004000400114O00040002000200062O0004005A02013O000452012O005A0201002E450181001000010081000452012O005A02012O0011000400044O00C400055O00202O00050005002C4O000600066O000700056O000700076O00040007000200062O0004005A02013O000452012O005A02012O0011000400013O002O12010500823O002O12010600834O00FB000400064O007200046O005A00046O0097000400023O000452012O003C0201002O12010200043O000EF90022000800010002000452012O00080001002E0F0084000700010085000452012O000700010026D20001000700010022000452012O00070001002O12010300013O0026D20003002703010001000452012O00270301002E0F0086008602010087000452012O008602012O0011000400173O00062C0004008602013O000452012O008602012O001100046O0056000500013O00122O000600883O00122O000700896O0005000700024O00040004000500202O00040004004A4O00040002000200062O0004008602013O000452012O008602012O0011000400094O00F800055O00202O00050005008A4O000600066O000700056O000700076O00040007000200062O0004008102010001000452012O00810201002E57008B00860201008C000452012O008602012O0011000400013O002O120105008D3O002O120106008E4O00FB000400064O007200045O002E45018F00A00001008F000452012O002603012O001100046O0056000500013O00122O000600903O00122O000700916O0005000700024O00040004000500202O0004000400114O00040002000200062O0004002603013O000452012O00260301002O12010400014O002C010500063O00262E0004009802010001000452012O00980201002E570092009B02010093000452012O009B0201002O12010500014O002C010600063O002O12010400043O000EF90004009402010004000452012O0094020100262E000500A102010001000452012O00A10201002E570094009D02010095000452012O009D0201002O12010600013O00262E000600A602010001000452012O00A60201002E57009700A202010096000452012O00A202012O00110007000C3O00062C000700DB02013O000452012O00DB02012O0011000700063O000E15000400DB02010007000452012O00DB02012O0011000700183O0006A9000700DB02010001000452012O00DB02012O0011000700064O00E5000800196O0009001A6O000A00023O00202O000A000A00144O000C00016O000D8O000A000D6O00093O000200102O0009002200094O000A001A4O0011000B6O0011000C00013O0012E8000D00983O00122O000E00996O000C000E00024O000B000B000C00202O000B000B00332O002B010B000C6O000A8O00083O00024O0009001B6O000A001A6O000B00023O00202O000B000B00144O000D00016O000E8O000B000E4O0067000A3O000200101D010A0022000A2O0011000B001A4O0011000C6O0011000D00013O0012E8000E00983O00122O000F00996O000D000F00024O000C000C000D00202O000C000C00332O00E3000C000D6O000B8O00093O00024O00080008000900062O0008000300010007000452012O00DD0201002E57009B00E80201009A000452012O00E802012O0011000700044O001100085O00201C01080008009C2O002901070002000200062C000700E802013O000452012O00E802012O0011000700013O002O120108009D3O002O120109009E4O00FB000700094O007200076O00110007000C3O00062C0007002603013O000452012O002603012O0011000700023O0020C30007000700154O00095O00202O00090009009F4O00070009000200062O0007002603013O000452012O002603012O0011000700063O000E150007002603010007000452012O002603012O0011000700074O00110008001C4O0030010700020009000452012O001E0301002065000C000B00292O00B8000E5O00202O000E000E00234O000F00016O000C000F000200062O000C000F03010001000452012O000F03012O0011000C00183O00062C000C001103013O000452012O00110301002065000C000B00292O0011000E5O00201C010E000E002A2O0002010C000E00020006A9000C001103010001000452012O00110301002065000C000B00292O0011000E5O00201C010E000E002B2O0002010C000E00020006A9000C001103010001000452012O00110301002E4501A0000F000100A1000452012O001E03012O0011000C00044O0011000D5O00201C010D000D009C2O0029010C000200020006A9000C001903010001000452012O00190301002E5700A2001E030100A3000452012O001E03012O0011000C00013O002O12010D00A43O002O12010E00A54O00FB000C000E4O0072000C5O00062F010700F902010002000452012O00F90201000452012O00260301000452012O00A20201000452012O00260301000452012O009D0201000452012O00260301000452012O00940201002O12010300043O002E0F00A60065020100A7000452012O006502010026D20003006502010004000452012O00650201002O122O0100073O000452012O00070001000452012O00650201000452012O00070001000452012O00080001000452012O00070001000452012O00330301000452012O000200012O00293O00017O00FE3O00028O00030C3O004570696353652O74696E677303073O0038FDFA8F7D09E103053O00116C929DE82O033O0044CC1703063O00C82BA3748D4F03073O008B393A84BCF1F003073O0083DF565DE3D0942O033O00E24AB303063O00D583252OD67D026O00F03F026O001440030B3O004372696D736F6E5669616C03053O004665696E74026O001840025O00B0AF40025O00F08440025O00907440025O00E07C40030F3O00412O66656374696E67436F6D62617403093O0049734D6F756E746564030D3O00546172676574497356616C6964025O00A6A940025O00F4904003073O00537465616C746803083O00537465616C746832030F3O0079A319D44D98AB0AFF33FA62C5F90A03073O00C32AD77CB521EC03073O00506F69736F6E73026O001C40025O00B88740025O0018B04003073O00122422B8ED233803053O0081464B45DF2O033O0045CFE003063O008F26AB93891C030E3O004973496E4D656C2O6552616E6765026O002440027O0040025O00406940025O00EEA740025O000C9940025O00FCB140025O0040A440025O00E89840025O0026A140025O0084B34003063O0042752O665570030F3O0056616E69736842752O665370652O6C025O00108D40025O00508940025O00BAB240025O0014A540030C3O00537465616C74685370652O6C025O00588140025O00388140025O00507040025O003AAE40025O00E07440025O00D4A740025O008AAC40025O00C7B240025O004CAA40025O004EAC40030E3O002058253520FC0B56251A20F9195103063O00986D39575E45030A3O0049734361737461626C6503123O00436F6D626F506F696E747344656669636974030A3O0043504D61785370656E64025O0010B240025O00049E4003053O005072652O73030E3O004D61726B6564666F724465617468025O0050A040025O00789F40031B3O00DAD619B7FEFF55BAF2D20EE3B8DD46E8DDD20BB7B6921C87D6F44303083O00C899B76AC3DEB234030C3O00536C696365616E6444696365025O00C2A940025O0052B240025O00807840025O00B8A940030C3O0001EF813E4C5B3CE7AC344A5F03063O003A5283E85D2903073O0049735265616479025O00C05D40025O00B3B14003133O00A056C3011D0C8F5ED3101D3E8D539031543C8603063O005FE337B0753D030A3O004D6644536E6970696E67025O0056A340025O002EAE40025O001AA140025O00F49A40025O00D49A40025O009AAA40025O00805D40025O00609D40025O0040A940025O00089140026O000840025O0032A940025O00D09C40030C3O00C22944ECDCF02B49CBD0F22003053O00B991452D8F030B3O00436F6D626F506F696E747303083O00446562752O66557003073O0052757074757265030D3O00A90A0D92D3BE171C85D48B0C1C03053O00BCEA7F79C6030B3O004973417661696C61626C65026O001040030B3O0042752O6652656D61696E7302CD5OCCFC3F03133O001B33009778011F8A3B3753822O3653A72O311603043O00E3585273030D3O00600AAE930D474B1A99AF03604603063O0013237FDAC762025O0044A540025O00A5B240025O005C9B40025O00F0774003073O0039F51CE712F40703043O00827C9B6A03073O00456E76656E6F6D03133O00F6CAE5BBE3D372A9D0C5F9A2E3BE5FABC1E8BF03083O00DFB5AB96CFC3961C030D3O007C35EABD06423FE78507453CE603053O00692C5A83CE03093O004973496E52616E6765026O003E4003093O00537465616C74685570030F3O00456E6572677954696D65546F4D61782O033O00474344026O00F83F030D3O00506F69736F6E65644B6E69666503133O00DCE1A1AD480EF0E9A1B6063BFBA099B70138FA03063O005E9F80D2D968025O00C09340025O0083B040025O00208E40025O00F5B140025O004CA540025O00D4B040025O000FB240030C3O005836105FAE19723743AE1C3703053O00CB781E432B025O0092A140025O00108140025O0020A540025O0072AC40025O00B5B040025O00D09540025O0054B040025O00E07640025O00A06240025O0086B140025O00308440025O00349040025O001CAC40025O0034AD40030E3O00506F69736F6E6564426C2O656473030B3O00456E65726779526567656E030A3O005370652O6C4861737465025O00B88940025O00988C40030D3O00456E6572677944656669636974025O00804140025O0062B340025O000DB140030E3O0032E972C2FE9833C31AE778CFE49F03083O00B67E8015AA8AEB79030E3O004C69676874734A7564676D656E7403143O00A8DB26F2C63F390183CE26A6AC06340186DF3BF203083O0066EBBA5586E67350030B3O00750D395074E0305E0F354C03073O0042376C5E3F12B4025O00188440025O00449740030B3O004261676F66547269636B73025O00B07D40025O004FB04003123O00378C9623677B158AC5382119209F8C342C4A03063O003974EDE55747025O00C4A540025O00405E40025O00A09D40025O00FEA540025O0014A040025O0058A240025O0092AB40025O007C9B40030D3O0071EB05BE517ACD7542EB03B14B03083O001A309966DF3F1F99026O002E40030D3O00417263616E65546F2O72656E7403133O002141FEE74261FFF0034EE8B3364FFFE1074EF903043O009362208D030B3O003951E0CB08537B0D4FF0CF03073O002B782383AA6636025O00607640025O00649D40030B3O00417263616E6550756C7365025O004C9F40025O00A6A54003113O00770794A2E59196570789B3E5809158158203073O00E43466E7D6C5D003063O008BBCEFF264E603073O0027CAD18D87178E030E3O00DE3E0B1F21F0D0250C1820F1FB3603063O00989F53696A52025O004EA440025O0080A240025O008AA540025O0054A04003063O00416D62757368030B3O00A7CF5DFE897D8CC444E1C103063O003CE1A63192A9025O00B08640025O003C984003083O00020B3B230D063B1B03063O00674F7E4F4A61025O00A8A240025O00689E4003083O004D7574696C617465030D3O009C76DF7F1E37AF6BDA7F5F0EBF03063O007ADA1FB3133E025O00A3B240025O0050A940025O00689D40025O00805840025O00CAB040025O00C9B040025O0034A140025O0068B34003113O00476574456E656D696573496E52616E676503163O00476574456E656D696573496E4D656C2O6552616E6765025O00407840025O00E06440025O00788440025O0002A940025O0036AC40025O00F08D4003143O00452O66656374697665436F6D626F506F696E7473025O0046AC4003073O00F58CAFF60DECD903073O00B4B0E2D993638303063O0044616D61676503083O00FEAC3B0EDFB83B0203043O0067B3D94F025O00D2AD40025O009C9E40030E3O00436F6D626F506F696E74734D6178026O33D33F00A9042O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O0026D20001002200010001000452012O002200012O001100026O00B9000200010001001260000200024O00D3000300023O00122O000400033O00122O000500046O0003000500024O0002000200034O000300023O00122O000400053O00122O000500066O0003000500024O0002000200034O000200013O00122O000200026O000300023O00122O000400073O00122O000500086O0003000500024O0002000200034O000300023O00122O000400093O00122O0005000A6O0003000500024O0002000200034O000200033O00122O0001000B3O0026D2000100320001000C000452012O003200012O0011000200053O00200B00020002000D4O0002000100024O000200046O000200043O00062O0002002D00013O000452012O002D00012O0011000200044O0097000200024O0011000200053O00201C01020002000E2O00130102000100022O001A000200043O002O122O01000F3O002E570011007700010010000452012O007700010026D2000100770001000F000452012O007700012O0011000200043O00062C0002003B00013O000452012O003B00012O0011000200044O0097000200023O002E0F0012007300010013000452012O007300012O0011000200063O0020650002000200142O00290102000200020006A90002007300010001000452012O007300012O0011000200063O0020650002000200152O00290102000200020006A90002007300010001000452012O007300012O0011000200073O00201C0102000200162O001301020001000200062C0002007300013O000452012O00730001002O12010200014O002C010300043O0026D20002005300010001000452012O00530001002O12010300014O002C010400043O002O120102000B3O0026D20002004E0001000B000452012O004E0001002E0F0018005500010017000452012O005500010026D20003005500010001000452012O00550001002O12010400013O0026D20004005A00010001000452012O005A00012O0011000500053O00201C0005000500194O000600083O00202O00060006001A4O000700076O0005000700024O000500046O000500043O00062O0005007300013O000452012O007300012O0011000500023O0012CA0006001B3O00122O0007001C6O0005000700024O000600046O0005000500064O000500023O00044O00730001000452012O005A0001000452012O00730001000452012O00550001000452012O00730001000452012O004E00012O0011000200053O00201C01020002001D2O00B9000200010001002O122O01001E3O00262E0001007B0001000B000452012O007B0001002E0F002000920001001F000452012O00920001001260000200024O0028000300023O00122O000400213O00122O000500226O0003000500024O0002000200034O000300023O00122O000400233O00122O000500246O0003000500022O006A0002000200034O000200096O0002000B3O00202O00020002002500122O0004000C6O0002000400024O0002000A6O0002000B3O00202O00020002002500122O000400264O00020102000400022O001A0002000C3O002O122O0100273O002E0F0028000A04010029000452012O000A04010026D20001000A0401001E000452012O000A04012O0011000200063O0020650002000200142O002901020002000200062C0002009D00013O000452012O009D0001002E0F002B004F2O01002A000452012O004F2O01002O12010200014O002C010300033O000E6D000100A300010002000452012O00A30001002E57002C009F0001002D000452012O009F0001002O12010300013O00262E000300A800010001000452012O00A80001002E57002F00A40001002E000452012O00A400012O0011000400063O0020010004000400304O000600053O00202O0006000600314O000600016O00043O000200062O000400D600010001000452012O00D60001002O12010400014O002C010500063O00262E000400B60001000B000452012O00B60001002E57003200D000010033000452012O00D0000100262E000500BA00010001000452012O00BA0001002E0F003400B600010035000452012O00B60001002O12010600013O000EF9000100BB00010006000452012O00BB00012O0011000700053O0020130007000700194O000800053O00202O0008000800364O000800016O00073O00024O000700046O000700043O00062O000700C900010001000452012O00C90001002E57003700D600010038000452012O00D600012O0011000700044O0097000700023O000452012O00D60001000452012O00BB0001000452012O00D60001000452012O00B60001000452012O00D600010026D2000400B200010001000452012O00B20001002O12010500014O002C010600063O002O120104000B3O000452012O00B20001002E0F0039004F2O01003A000452012O004F2O012O0011000400073O00201C0104000400162O001301040001000200062C0004004F2O013O000452012O004F2O01002O12010400014O002C010500063O0026D2000400452O01000B000452012O00452O0100262E000500E500010001000452012O00E50001002E0F003C00E10001003B000452012O00E10001002O12010600013O002E57003D00E60001003E000452012O00E600010026D2000600E600010001000452012O00E60001002E57003F001A2O010040000452012O001A2O012O0011000700093O00062C0007001A2O013O000452012O001A2O012O0011000700013O00062C000700092O013O000452012O00092O012O0011000700084O0056000800023O00122O000900413O00122O000A00426O0008000A00024O00070007000800202O0007000700434O00070002000200062O000700092O013O000452012O00092O012O0011000700063O0020160007000700444O0007000200024O000800053O00202O0008000800454O00080001000200062O000800092O010007000452012O00092O012O0011000700073O00201C0107000700162O00130107000100020006A90007000B2O010001000452012O000B2O01002E450146001100010047000452012O001A2O012O00110007000D3O00201C0107000700482O0022010800083O00202O0008000800494O0009000E6O00070009000200062O000700152O010001000452012O00152O01002E0F004A001A2O01004B000452012O001A2O012O0011000700023O002O120108004C3O002O120109004D4O00FB000700094O007200076O0011000700063O0020C30007000700304O000900083O00202O00090009004E4O00070009000200062O000700232O013O000452012O00232O01002E0F0050004F2O01004F000452012O004F2O01002E570051004F2O010052000452012O004F2O012O0011000700084O0056000800023O00122O000900533O00122O000A00546O0008000A00024O00070007000800202O0007000700554O00070002000200062O0007004F2O013O000452012O004F2O012O00110007000F3O000E150027004F2O010007000452012O004F2O012O00110007000D3O0020990007000700484O000800083O00202O00080008004E4O00070002000200062O0007003B2O010001000452012O003B2O01002E570057004F2O010056000452012O004F2O012O0011000700023O00129B000800583O00122O000900596O000700096O00075O00044O004F2O01000452012O00E60001000452012O004F2O01000452012O00E10001000452012O004F2O010026D2000400DF00010001000452012O00DF0001002O12010500014O002C010600063O002O120104000B3O000452012O00DF0001000452012O004F2O01000452012O00A40001000452012O004F2O01000452012O009F00012O0011000200053O00205400020002005A4O000300083O00202O0003000300494O0002000200014O000200073O00202O0002000200164O00020001000200062O000200A804013O000452012O00A80401002O12010200014O002C010300043O00262E0002005F2O010001000452012O005F2O01002E0F005C00622O01005B000452012O00622O01002O12010300014O002C010400043O002O120102000B3O002E57005E005B2O01005D000452012O005B2O01000EF9000B005B2O010002000452012O005B2O01002E0F005F00662O010060000452012O00662O010026D2000300662O010001000452012O00662O01002O12010400013O00262E0004006F2O010027000452012O006F2O01002E45016100132O010062000452012O00800201002O12010500014O002C010600063O0026D2000500712O010001000452012O00712O01002O12010600013O002E0F0064007A2O010063000452012O007A2O010026D20006007A2O010027000452012O007A2O01002O12010400653O000452012O00800201002E0F0067003502010066000452012O003502010026D2000600350201000B000452012O003502012O0011000700043O00062C000700832O013O000452012O00832O012O0011000700044O0097000700024O0011000700063O0020A10007000700304O000900083O00202O00090009004E4O00070009000200062O000700D02O010001000452012O00D02O012O0011000700084O0056000800023O00122O000900683O00122O000A00696O0008000A00024O00070007000800202O0007000700554O00070002000200062O000700A02O013O000452012O00A02O012O0011000700063O00206500070007006A2O0029010700020002000E15002700A02O010007000452012O00A02O012O00110007000B3O0020A100070007006B4O000900083O00202O00090009006C4O00070009000200062O000700C42O010001000452012O00C42O012O0011000700084O0043010800023O00122O0009006D3O00122O000A006E6O0008000A00024O00070007000800202O00070007006F4O00070002000200062O0007003402010001000452012O003402012O0011000700063O00206500070007006A2O0029010700020002000E150070003402010007000452012O003402012O0011000700063O00204D0007000700714O000900083O00202O00090009004E4O0007000900024O000800103O00122O0009000B6O000A00063O00202O000A000A006A4O000A000B6O00083O00024O000900113O00122O000A000B6O000B00063O00202O000B000B006A4O000B000C6O00093O00024O00080008000900202O00080008007200062O0007003402010008000452012O003402012O0011000700124O0011000800083O00201C01080008004E2O002901070002000200062C0007003402013O000452012O003402012O0011000700023O00129B000800733O00122O000900746O000700096O00075O00044O003402012O00110007000C3O00062C000700DD2O013O000452012O00DD2O012O0011000700084O0043010800023O00122O000900753O00122O000A00766O0008000A00024O00070007000800202O00070007006F4O00070002000200062O000700DF2O010001000452012O00DF2O01002E570078000602010077000452012O00060201002E0F007A003402010079000452012O003402012O0011000700084O0056000800023O00122O0009007B3O00122O000A007C6O0008000A00024O00070007000800202O0007000700554O00070002000200062O0007003402013O000452012O003402012O0011000700063O0020810007000700714O000900083O00202O00090009004E4O00070009000200262O000700340201000C000452012O003402012O0011000700063O00206500070007006A2O0029010700020002000E150070003402010007000452012O003402012O0011000700124O00C4000800083O00202O00080008007D4O0009000A6O000B000A6O000B000B6O0007000B000200062O0007003402013O000452012O003402012O0011000700023O00129B0008007E3O00122O0009007F6O000700096O00075O00044O003402012O0011000700084O0056000800023O00122O000900803O00122O000A00816O0008000A00024O00070007000800202O0007000700434O00070002000200062O0007003402013O000452012O003402012O00110007000B3O002065000700070082002O12010900834O000201070009000200062C0007003402013O000452012O003402012O0011000700063O002O200007000700844O000900016O000A00016O0007000A000200062O0007003402010001000452012O003402012O0011000700133O0026D20007003402010001000452012O003402012O0011000700063O00200A0107000700854O0007000200024O000800063O00202O0008000800864O00080002000200202O00080008008700062O0007003402010008000452012O003402012O0011000700124O0011000800083O00201C0108000800882O002901070002000200062C0007003402013O000452012O003402012O0011000700023O002O12010800893O002O120109008A4O00FB000700094O007200075O002O12010600273O0026D2000600742O010001000452012O00742O01002O12010700013O002E0F008B00760201008C000452012O00760201000EF90001007602010007000452012O007602012O0011000800063O002O200008000800844O000A00016O000B8O0008000B000200062O0008004B02010001000452012O004B02012O0011000800144O0013010800010002000EB20001004B02010008000452012O004B02012O0011000800154O0013010800010002000ECD0001007202010008000452012O00720201002O12010800014O002C0109000A3O002E45018D00070001008D000452012O005402010026D20008005402010001000452012O00540201002O12010900014O002C010A000A3O002O120108000B3O0026D20008004D0201000B000452012O004D020100262E0009005A02010001000452012O005A0201002E45018E00FEFF2O008F000452012O00560201002O12010A00013O0026D2000A005B02010001000452012O005B02012O0011000B00164O0013010B000100022O001A000B00044O0011000B00043O0006A9000B006502010001000452012O00650201002E450190000F00010091000452012O007202012O0011000B00044O00BA000C00023O00122O000D00923O00122O000E00936O000C000E00024O000B000B000C4O000B00023O00044O00720201000452012O005B0201000452012O00720201000452012O00560201000452012O00720201000452012O004D02012O0011000800174O00130108000100022O001A000800043O002O120107000B3O002E0F0095003802010094000452012O003802010026D2000700380201000B000452012O00380201002O120106000B3O000452012O00742O01000452012O00380201000452012O00742O01000452012O00800201000452012O00712O010026D2000400B002010065000452012O00B00201002O12010500013O002E570096009202010097000452012O009202010026D2000500920201000B000452012O009202012O0011000600184O00130106000100022O001A000600044O0011000600043O0006A90006008F02010001000452012O008F0201002E570098009102010099000452012O009102012O0011000600044O0097000600023O002O12010500273O00262E0005009602010027000452012O00960201002E57009A00980201009B000452012O00980201002O12010400703O000452012O00B002010026D20005008302010001000452012O00830201002O12010600013O0026D2000600A802010001000452012O00A802012O0011000700194O00130107000100022O001A000700044O0011000700043O0006A9000700A502010001000452012O00A50201002E57009D00A70201009C000452012O00A702012O0011000700044O0097000700023O002O120106000B3O002E0F009E009B0201009F000452012O009B02010026D20006009B0201000B000452012O009B0201002O120105000B3O000452012O00830201000452012O009B0201000452012O008302010026D2000400EC02010001000452012O00EC0201002O12010500013O002E5700A000D6020100A1000452012O00D602010026D2000500D602010001000452012O00D602012O0011000600053O00203C0006000600A24O0006000100024O0006001A6O000600106O000700063O00202O0007000700A34O0007000200024O0008001A3O00202O00080008000F4O000900063O00202O0009000900A44O00090002000200102O0009002700094O0008000800094O0006000800024O000700116O000800063O00202O0008000800A34O0008000200024O0009001A3O00202O00090009000F4O000A00063O00202O000A000A00A44O000A0002000200102O000A0027000A4O00090009000A4O0007000900024O0006000600074O0006001B3O00122O0005000B3O0026D2000500DA02010027000452012O00DA0201002O120104000B3O000452012O00EC0201000E6D000B00DE02010005000452012O00DE0201002E5700A600B3020100A5000452012O00B302012O0011000600063O00203C0106000600A74O0006000200024O0007001B6O0006000600074O0006001C6O0006001B3O000E2O00A800E802010006000452012O00E802012O001400066O005A000600014O001A0006001D3O002O12010500273O000452012O00B302010026D2000400D303010070000452012O00D303012O0011000500093O0006A9000500F302010001000452012O00F30201002E5700A90090030100AA000452012O00900301002O12010500014O002C010600063O000EF9000100F502010005000452012O00F50201002O12010600013O0026D2000600310301000B000452012O003103012O0011000700084O0056000800023O00122O000900AB3O00122O000A00AC6O0008000A00024O00070007000800202O0007000700434O00070002000200062O0007001303013O000452012O001303012O00110007000A3O00062C0007001303013O000452012O001303012O0011000700124O00EC000800083O00202O0008000800AD4O0009001E6O00070009000200062O0007001303013O000452012O001303012O0011000700023O002O12010800AE3O002O12010900AF4O00FB000700094O007200076O0011000700084O0056000800023O00122O000900B03O00122O000A00B16O0008000A00024O00070007000800202O0007000700434O00070002000200062O0007002003013O000452012O002003012O00110007000A3O0006A90007002203010001000452012O00220301002E5700B30090030100B2000452012O009003012O0011000700124O0022010800083O00202O0008000800B44O0009001E6O00070009000200062O0007002B03010001000452012O002B0301002E4501B50067000100B6000452012O009003012O0011000700023O00129B000800B73O00122O000900B86O000700096O00075O00044O009003010026D2000600F802010001000452012O00F80201002O12010700014O002C010800083O00262E0007003903010001000452012O00390301002E0F00B90035030100BA000452012O00350301002O12010800013O002E5700BB0086030100BC000452012O008603010026D20008008603010001000452012O00860301002O12010900013O000E6D000B004303010009000452012O00430301002E4501BD0004000100BE000452012O00450301002O120108000B3O000452012O0086030100262E0009004903010001000452012O00490301002E5700BF003F030100C0000452012O003F03012O0011000A00084O0056000B00023O00122O000C00C13O00122O000D00C26O000B000D00024O000A000A000B00202O000A000A00434O000A0002000200062O000A006703013O000452012O006703012O0011000A000A3O00062C000A006703013O000452012O006703012O0011000A00063O002065000A000A00A72O0029010A00020002000ECD00C300670301000A000452012O006703012O0011000A00124O00EC000B00083O00202O000B000B00C44O000C001E6O000A000C000200062O000A006703013O000452012O006703012O0011000A00023O002O12010B00C53O002O12010C00C64O00FB000A000C4O0072000A6O0011000A00084O0056000B00023O00122O000C00C73O00122O000D00C86O000B000D00024O000A000A000B00202O000A000A00434O000A0002000200062O000A007403013O000452012O007403012O0011000A000A3O0006A9000A007603010001000452012O00760301002E4501C90010000100CA000452012O008403012O0011000A00124O0022010B00083O00202O000B000B00CB4O000C001E6O000A000C000200062O000A007F03010001000452012O007F0301002E4501CC0007000100CD000452012O008403012O0011000A00023O002O12010B00CE3O002O12010C00CF4O00FB000A000C4O0072000A5O002O120109000B3O000452012O003F03010026D20008003A0301000B000452012O003A0301002O120106000B3O000452012O00F80201000452012O003A0301000452012O00F80201000452012O00350301000452012O00F80201000452012O00900301000452012O00F502012O0011000500084O0043010600023O00122O000700D03O00122O000800D16O0006000800024O00050005000600202O0005000500434O00050002000200062O000500A403010001000452012O00A403012O0011000500084O0056000600023O00122O000700D23O00122O000800D36O0006000800024O00050005000600202O0005000500434O00050002000200062O000500A703013O000452012O00A703012O00110005000C3O0006A9000500A903010001000452012O00A90301002E0F00D400B6030100D5000452012O00B60301002E5700D700B6030100D6000452012O00B603012O0011000500124O0011000600083O00201C0106000600D82O002901050002000200062C000500B603013O000452012O00B603012O0011000500023O002O12010600D93O002O12010700DA4O00FB000500074O007200055O002E0F00DB00A8040100DC000452012O00A804012O0011000500084O0056000600023O00122O000700DD3O00122O000800DE6O0006000800024O00050005000600202O0005000500434O00050002000200062O000500A804013O000452012O00A804012O00110005000C3O00062C000500A804013O000452012O00A80401002E5700E000A8040100DF000452012O00A804012O0011000500124O0011000600083O00201C0106000600E12O002901050002000200062C000500A804013O000452012O00A804012O0011000500023O00129B000600E23O00122O000700E36O000500076O00055O00044O00A804010026D20004006B2O01000B000452012O006B2O01002O12010500013O000EF9000100E903010005000452012O00E90301002O12010600013O0026D2000600E203010001000452012O00E203012O0011000700204O009A0007000100024O0007001F6O000700226O0007000100024O000700213O00122O0006000B3O000E6D000B00E603010006000452012O00E60301002E4501E400F5FF2O00E5000452012O00D90301002O120105000B3O000452012O00E90301000452012O00D903010026D2000500FD0301000B000452012O00FD0301002O12010600013O0026D2000600F00301000B000452012O00F00301002O12010500273O000452012O00FD03010026D2000600EC03010001000452012O00EC03012O0011000700244O00130107000100022O001A000700234O0011000700133O0026C2000700F903010027000452012O00F903012O001400076O005A000700014O001A000700253O002O120106000B3O000452012O00EC0301000E6D0027000104010005000452012O00010401002E5700E600D6030100E7000452012O00D60301002O12010400273O000452012O006B2O01000452012O00D60301000452012O006B2O01000452012O00A80401000452012O00662O01000452012O00A80401000452012O005B2O01000452012O00A80401002E0F00E9006A040100E8000452012O006A04010026D20001006A04010027000452012O006A0401002E0F00EA0030040100EB000452012O003004012O0011000200033O00062C0002003004013O000452012O00300401002O12010200013O000EF90001002104010002000452012O002104012O0011000300063O0020B30003000300EC00122O000500836O0003000500024O000300266O000300063O00202O0003000300ED00122O000500266O0003000500024O000300273O00122O0002000B3O002E5700EF0014040100EE000452012O001404010026D2000200140401000B000452012O001404012O0011000300274O00A7000300036O000300136O000300063O00202O0003000300ED00122O0005000C6O0003000500024O000300283O00044O00580401000452012O00140401000452012O00580401002O12010200014O002C010300033O0026D20002003204010001000452012O00320401002O12010300013O00262E0003003904010001000452012O00390401002E4501F00017000100F1000452012O004E0401002O12010400014O002C010500053O0026D20004003B04010001000452012O003B0401002O12010500013O002E5700F30044040100F2000452012O00440401000EF9000B004404010005000452012O00440401002O120103000B3O000452012O004E04010026D20005003E04010001000452012O003E04012O00D800066O0034010600266O00068O000600273O00122O0005000B3O00044O003E0401000452012O004E0401000452012O003B04010026D2000300350401000B000452012O00350401002O120104000B4O001A000400134O00D800046O001A000400283O000452012O00580401000452012O00350401000452012O00580401000452012O003204012O0011000200063O0020F30002000200A44O00020002000200102O0002002700024O000300063O00202O0003000300A44O00030002000200102O0003000B00034O0003002A6O000200296O000200053O00202O0002000200F44O000300063O00202O00030003006A4O000300046O00023O00024O0002000F3O00122O000100653O002E4501F5001E000100F5000452012O008804010026D20001008804010070000452012O008804012O0011000200084O0011000300023O0012E8000400F63O00122O000500F76O0003000500024O00020002000300202O0002000200F82O00F50002000200024O0003002C6O0002000200034O0002002B6O000200086O000300023O0012E8000400F93O00122O000500FA6O0003000500024O00020002000300202O0002000200F82O002A0002000200024O0003002E6O0002000200034O0002002D6O000200306O0002000100024O0002002F3O00122O0001000C3O002E5700FC0005000100FB000452012O000500010026D20001000500010065000452012O000500012O0011000200063O0020BE0002000200FD4O0002000200024O0003000F6O0002000200034O000200316O000200103O00122O000300706O0004000F3O00202O0004000400704O0002000400024O000300113O00122O000400706O0005000F3O00202O0005000500704O0003000500024O00020002000300202O0002000200FE4O000200326O0002000F3O00202O00020002002700102O00020070000200202O0002000200FE4O000200333O00122O000100703O00044O00050001000452012O00A80401000452012O000200012O00293O00017O000E3O00028O00025O0010A740025O00AEAD4003093O0097D3CCD5C1AC44A1DD03073O0025D3B6ADA1A9C103143O00526567697374657241757261547261636B696E6703063O00C43F5DCA216803073O00D9975A2DB9481B026O00F03F03073O00E47DF50059D77903053O0036A31C877203053O005072696E7403303O0009C84E835D6C21D55C964770269B6F8D496A2D9B5F9B0E5A38D25ECC0E4C3DCB4D8D5C6B2DDF1D80573F0FD4578B5C7E03063O001F48BB3DE22E00303O002O12012O00014O002C2O0100013O0026D23O000200010001000452012O00020001002O122O0100013O00262E0001000900010001000452012O00090001002E0F0003001A00010002000452012O001A00012O001100026O0011000300013O0012E8000400043O00122O000500056O0003000500024O00020002000300202O0002000200062O00890002000200012O001100026O0011000300013O0012E8000400073O00122O000500086O0003000500024O00020002000300202O0002000200062O0089000200020001002O122O0100093O000EF90009000500010001000452012O000500012O001100026O000C000300013O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O0002000200064O0002000200014O000200023O00202O00020002000C4O000300013O00122O0004000D3O00122O0005000E6O000300056O00023O000100044O002F0001000452012O00050001000452012O002F0001000452012O000200012O00293O00017O00", GetFEnv(), ...);

