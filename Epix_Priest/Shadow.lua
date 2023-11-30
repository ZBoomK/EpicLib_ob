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
				if (Enum <= 174) then
					if (Enum <= 86) then
						if (Enum <= 42) then
							if (Enum <= 20) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
										elseif (Enum <= 2) then
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
											Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] > Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = VIP + Inst[3];
											end
										elseif (Enum > 3) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 6) then
										if (Enum > 5) then
											local A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									elseif (Enum <= 7) then
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
									elseif (Enum == 8) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									end
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum > 10) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 12) then
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 13) then
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
									end
								elseif (Enum <= 17) then
									if (Enum <= 15) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Inst[3]));
										end
									elseif (Enum == 16) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 18) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 19) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 31) then
								if (Enum <= 25) then
									if (Enum <= 22) then
										if (Enum > 21) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 23) then
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
									elseif (Enum > 24) then
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
								elseif (Enum <= 28) then
									if (Enum <= 26) then
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
									elseif (Enum > 27) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 29) then
									local B;
									local A;
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								else
									local A;
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
								if (Enum <= 33) then
									if (Enum > 32) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 34) then
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
								elseif (Enum > 35) then
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
							elseif (Enum <= 39) then
								if (Enum <= 37) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
							elseif (Enum <= 40) then
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 41) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 64) then
							if (Enum <= 53) then
								if (Enum <= 47) then
									if (Enum <= 44) then
										if (Enum == 43) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 45) then
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
									elseif (Enum > 46) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
								elseif (Enum <= 50) then
									if (Enum <= 48) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 49) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									end
								elseif (Enum <= 51) then
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
								elseif (Enum > 52) then
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
							elseif (Enum <= 58) then
								if (Enum <= 55) then
									if (Enum == 54) then
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 56) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 57) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 61) then
								if (Enum <= 59) then
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 60) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 62) then
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
							elseif (Enum > 63) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 69) then
								if (Enum <= 66) then
									if (Enum > 65) then
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
								elseif (Enum <= 67) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 72) then
								if (Enum <= 70) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif (Enum == 71) then
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
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
							elseif (Enum <= 73) then
								if (Inst[2] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 74) then
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
							end
						elseif (Enum <= 80) then
							if (Enum <= 77) then
								if (Enum > 76) then
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
						elseif (Enum <= 83) then
							if (Enum <= 81) then
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum > 82) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
								if (Inst[2] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 85) then
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
					elseif (Enum <= 130) then
						if (Enum <= 108) then
							if (Enum <= 97) then
								if (Enum <= 91) then
									if (Enum <= 88) then
										if (Enum == 87) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
									elseif (Enum <= 89) then
										local B;
										local A;
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
									elseif (Enum == 90) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 94) then
									if (Enum <= 92) then
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
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									elseif (Enum == 93) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = not Stk[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum <= 95) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 96) then
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
							elseif (Enum <= 102) then
								if (Enum <= 99) then
									if (Enum > 98) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
									local A = Inst[2];
									Stk[A] = Stk[A]();
								elseif (Enum == 101) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 105) then
								if (Enum <= 103) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 104) then
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
								elseif (Inst[2] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 119) then
							if (Enum <= 113) then
								if (Enum <= 110) then
									if (Enum > 109) then
										if (Stk[Inst[2]] > Inst[4]) then
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
								elseif (Enum == 112) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 116) then
								if (Enum <= 114) then
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
								elseif (Enum == 115) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								else
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 117) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							elseif (Enum > 118) then
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
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							end
						elseif (Enum <= 124) then
							if (Enum <= 121) then
								if (Enum > 120) then
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
							elseif (Enum <= 122) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 123) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 127) then
							if (Enum <= 125) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 126) then
								local A;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 128) then
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
							Stk[Inst[2]] = not Stk[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
						elseif (Enum > 129) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 152) then
						if (Enum <= 141) then
							if (Enum <= 135) then
								if (Enum <= 132) then
									if (Enum == 131) then
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 133) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 134) then
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
									Stk[Inst[2]] = Inst[3];
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 138) then
								if (Enum <= 136) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 137) then
									Stk[Inst[2]] = #Stk[Inst[3]];
								else
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 139) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 140) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 146) then
							if (Enum <= 143) then
								if (Enum > 142) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 144) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 145) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						elseif (Enum <= 149) then
							if (Enum <= 147) then
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
							elseif (Enum > 148) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 150) then
							local A;
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
						elseif (Enum > 151) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 157) then
							if (Enum <= 154) then
								if (Enum > 153) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Inst[4]) then
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
							elseif (Enum <= 155) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum == 156) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
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
						elseif (Enum <= 160) then
							if (Enum <= 158) then
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
									if (Mvm[1] == 275) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							elseif (Enum == 159) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Inst[2] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 162) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
							Stk[Inst[2]] = Inst[3] ~= 0;
						end
					elseif (Enum <= 168) then
						if (Enum <= 165) then
							if (Enum == 164) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 166) then
							Stk[Inst[2]]();
						elseif (Enum > 167) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
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
					elseif (Enum <= 171) then
						if (Enum <= 169) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum == 170) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 172) then
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
					elseif (Enum > 173) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					end
				elseif (Enum <= 261) then
					if (Enum <= 217) then
						if (Enum <= 195) then
							if (Enum <= 184) then
								if (Enum <= 179) then
									if (Enum <= 176) then
										if (Enum == 175) then
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
									elseif (Enum <= 177) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
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
									elseif (Enum > 178) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 181) then
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
								elseif (Enum <= 182) then
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
								elseif (Enum > 183) then
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 189) then
								if (Enum <= 186) then
									if (Enum == 185) then
										local A;
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
									elseif (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 187) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 188) then
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
							elseif (Enum <= 192) then
								if (Enum <= 190) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								elseif (Enum > 191) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 193) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 194) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 206) then
							if (Enum <= 200) then
								if (Enum <= 197) then
									if (Enum > 196) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
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
								elseif (Enum == 202) then
									if (Inst[2] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 204) then
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
							elseif (Enum > 205) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 211) then
							if (Enum <= 208) then
								if (Enum == 207) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 209) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Env[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 210) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 214) then
							if (Enum <= 212) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 213) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 215) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 216) then
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 239) then
						if (Enum <= 228) then
							if (Enum <= 222) then
								if (Enum <= 219) then
									if (Enum > 218) then
										if (Inst[2] ~= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Upvalues[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 220) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 221) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 225) then
								if (Enum <= 223) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 226) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 227) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 233) then
							if (Enum <= 230) then
								if (Enum > 229) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 231) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 232) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 236) then
							if (Enum <= 234) then
								Stk[Inst[2]] = {};
							elseif (Enum == 235) then
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
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
							end
						elseif (Enum <= 237) then
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
						elseif (Enum > 238) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 250) then
						if (Enum <= 244) then
							if (Enum <= 241) then
								if (Enum > 240) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 242) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 243) then
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
						elseif (Enum <= 247) then
							if (Enum <= 245) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 246) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 248) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 249) then
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
						else
							local A;
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 255) then
						if (Enum <= 252) then
							if (Enum == 251) then
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
								A = Inst[2];
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
							end
						elseif (Enum <= 253) then
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 254) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
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
					elseif (Enum <= 259) then
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
					elseif (Enum == 260) then
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
					if (Enum <= 283) then
						if (Enum <= 272) then
							if (Enum <= 266) then
								if (Enum <= 263) then
									if (Enum > 262) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 264) then
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
								elseif (Enum > 265) then
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
								elseif (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 269) then
								if (Enum <= 267) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 268) then
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
							elseif (Enum <= 270) then
								if (Inst[2] == Inst[4]) then
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
							else
								Env[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 277) then
							if (Enum <= 274) then
								if (Enum == 273) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 275) then
								Stk[Inst[2]] = Stk[Inst[3]];
							elseif (Enum == 276) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 280) then
							if (Enum <= 278) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 279) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 281) then
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
						elseif (Enum == 282) then
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
					elseif (Enum <= 294) then
						if (Enum <= 288) then
							if (Enum <= 285) then
								if (Enum > 284) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 286) then
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
							elseif (Enum == 287) then
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
						elseif (Enum <= 291) then
							if (Enum <= 289) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
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
							elseif (Enum > 290) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum == 293) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
						end
					elseif (Enum <= 299) then
						if (Enum <= 296) then
							if (Enum > 295) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
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
						elseif (Enum <= 297) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum > 298) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 300) then
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
						elseif (Enum > 301) then
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
						end
					elseif (Enum <= 303) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 304) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 327) then
					if (Enum <= 316) then
						if (Enum <= 310) then
							if (Enum <= 307) then
								if (Enum > 306) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
								end
							elseif (Enum <= 308) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 309) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 313) then
							if (Enum <= 311) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 312) then
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
						elseif (Enum <= 314) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						elseif (Enum == 315) then
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
						end
					elseif (Enum <= 321) then
						if (Enum <= 318) then
							if (Enum == 317) then
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
						elseif (Enum <= 319) then
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum > 320) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 324) then
						if (Enum <= 322) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 323) then
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
					elseif (Enum <= 325) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 326) then
						Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
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
				elseif (Enum <= 338) then
					if (Enum <= 332) then
						if (Enum <= 329) then
							if (Enum > 328) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
									return Stk[Inst[2]]();
								end
							end
						elseif (Enum <= 330) then
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 331) then
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 334) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 336) then
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
					elseif (Enum == 337) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
					elseif (Inst[2] > Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 343) then
					if (Enum <= 340) then
						if (Enum == 339) then
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						end
					elseif (Enum <= 341) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 342) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
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
					end
				elseif (Enum <= 346) then
					if (Enum <= 344) then
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum == 345) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						do
							return Stk[Inst[2]];
						end
					end
				elseif (Enum <= 347) then
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
				elseif (Enum > 348) then
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503163O00F4D3D23DD98BD517D4D0CF1AD5B3C61ADED49529F3BA03083O007EB1A3BB4586DBA703163O00AFF3BF2D21BAF1BF300D9EDC853D1F8EECA17B129FE203053O007EEA83D655002E3O0012993O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004CD3O000A0001001204000300063O002089000400030007001204000500083O002089000500050009001204000600083O00208900060006000A00069E00073O000100062O0013012O00064O0013017O0013012O00044O0013012O00014O0013012O00024O0013012O00053O00208900080003000B00208900090003000C2O00EA000A5O001204000B000D3O00069E000C0001000100022O0013012O000A4O0013012O000B4O0013010D00073O00123A000E000E3O00123A000F000F4O0006000D000F000200069E000E0002000100032O0013012O00074O0013012O00094O0013012O00084O0034000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00CC00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00CB00076O0033000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00CB000C00034O0060000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O002E010C6O0003010A3O0002002054010A000A00022O00A90009000A4O003700073O000100044D0003000500012O00CB000300054O0013010400024O000F000300044O004B00036O00013O00017O00163O00028O00026O00F03F025O00B8AD40025O0080AA40025O0052B340025O00804340025O00B07140025O00206940025O00388D40025O00406440025O00E07940025O007C9240025O00ACA940025O00E0A640025O0002B040025O00F08740025O007DB140025O0022AC40025O0080AE40025O00805840025O002CAB40025O0068824001483O00123A000200014O009C000300043O00267900020007000100010004CD3O0007000100123A000300014O009C000400043O00123A000200023O002EDC00040002000100030004CD3O00020001000E4900020002000100020004CD3O0002000100123A000500013O000EA000010010000100050004CD3O00100001002EA40005000C000100060004CD3O000C0001002EA400080014000100070004CD3O0014000100262800030016000100010004CD3O00160001002EA40009003A0001000A0004CD3O003A000100123A000600013O002EDC000B00350001000C0004CD3O00350001002EA4000E00350001000D0004CD3O0035000100267900060035000100010004CD3O0035000100123A000700013O00267900070022000100020004CD3O0022000100123A000600023O0004CD3O00350001002EDC0010001E0001000F0004CD3O001E000100262800070028000100010004CD3O00280001002EDC0011001E000100120004CD3O001E00012O00CB00086O001A010400083O0006F50004002E00013O0004CD3O002E0001002EA400130033000100140004CD3O003300012O00CB000800014O001301096O0013000A6O001801086O004B00085O00123A000700023O0004CD3O001E000100267900060017000100020004CD3O0017000100123A000300023O0004CD3O003A00010004CD3O001700010026280003003E000100020004CD3O003E0001002E0E011500CFFF2O00160004CD3O000B00012O0013010600044O001300076O001801066O004B00065O0004CD3O000B00010004CD3O000C00010004CD3O000B00010004CD3O004700010004CD3O000200012O00013O00017O005D3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703093O008572693B165BEC46BA03083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O00644303374603043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O0032A88E24CA03053O00B962DAEB57030B3O00FB2E22F5CD89DE2E34E9CC03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D903043O006D6174682O033O00CA5D7E03063O007EA7341074D9028O0003063O00F83C2985A70D03073O009CA84E40E0D47903063O0034E6A4CA08F903043O00AE678EC503063O00663A563D364A03073O009836483F58453E03063O00E7CCEF58DBD303043O003CB4A48E03063O00684C0C2C34F903073O0072383E6549478D03063O008BE1DAC0B7FE03043O00A4D889BB03073O00F1E93CBFA9F01803073O006BB28651D2C69E03083O001D1887D4B337008703053O00CA586EE2A6024O0080B3C540030A3O00EE068CF3C8C60186F2D803053O00AAA36FE297030B3O004973417661696C61626C65030A3O003C39BC3C4C32271535A003073O00497150D2582E57030B3O00B224CC16E8962AC417E98503053O0087E14CAD7203103O005265676973746572466F724576656E7403143O002AC1992O898F9828C89F953O8234CC9A9C899903073O00C77A8DD8D0CCDD03243O00F53C33FA8059B9E43326EA934EB9E72F22F09F5DAAFD2526E79F53A8EB3C2FF2985BA3F003073O00E6B47F67B3D61C030E3O009E489CAC1F9E479AA812835F9CA403053O0053CD18D9E003143O00CAE0EC0FC8E0E902D5F5E811CAFAE413D9F1EC1F03043O005D86A5AD03143O00740552CE74657C1F40CC7F6C741F5AD26574790203063O00203840139C3A030B3O0069C0E45255E5A348C9F65E03073O00E03AA885363A9203163O005265676973746572496E466C69676874452O66656374024O0050120941030B3O006A5E4AF97A91A41958454303083O006B39362B9D15E6E703103O005265676973746572496E466C69676874030F3O006FD6AE430E6F42DDBF7C177C4CC6BD03063O001D2BB3D82C7B03133O005265676973746572504D756C7469706C69657203153O004465766F7572696E67506C61677565446562752O6603063O0053657441504C025O00207040009C023O0075000100033O001204000300014O006200045O00122O000500023O00122O000600036O0004000600024O000300030004001204000400043O001204000500054O006200065O00122O000700063O00122O000800076O0006000800024O0006000400062O006200075O00122O000800083O00122O000900096O0007000900024O0007000600072O006200085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600082O006200095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600092O0062000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A2O0062000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B2O0062000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C2O0062000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D001204000E00044O0062000F5O00122O001000163O00122O001100176O000F001100024O000F000E000F2O006200105O00122O001100183O00122O001200196O0010001200024O0010000E00102O006200115O00122O0012001A3O00122O0013001B6O0011001300024O0011000E00112O006200125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00122O006200135O00122O0014001E3O00122O0015001F6O0013001500024O0013000E00132O006200145O00122O001500203O00122O001600216O0014001600024O0013001300142O006200145O00122O001500223O00122O001600236O0014001600024O0013001300142O006200145O00122O001500243O00122O001600256O0014001600024O0014000E00142O006200155O00122O001600263O00122O001700276O0015001700024O0014001400152O006200155O00122O001600283O00122O001700296O0015001700024O0014001400150012040015002A4O006200165O00122O0017002B3O00122O0018002C6O0016001800024O0015001500160012740016002D6O00178O00188O00198O001A8O001B00494O0062004A5O00122O004B002E3O00122O004C002F6O004A004C00024O004A000C004A2O0062004B5O00122O004C00303O00122O004D00316O004B004D00024O004A004A004B2O0062004B5O00122O004C00323O00122O004D00336O004B004D00024O004B000D004B2O0062004C5O00122O004D00343O00122O004E00356O004C004E00024O004B004B004C2O0062004C5O00122O004D00363O00122O004E00376O004C004E00024O004C000F004C2O0062004D5O00122O004E00383O00122O004F00396O004D004F00024O004C004C004D2O00EA004D6O009C004E00524O006200535O00122O0054003A3O00122O0055003B6O0053005500024O0053000E00532O006200545O00122O0055003C3O00122O0056003D6O0054005600024O0053005300542O00EC005400543O00122O0055003E3O00122O0056003E6O00578O00585O00122O0059002D6O005A8O005B6O001D005C8O005D8O005E8O005F5O00122O0060003F3O00122O006100406O005F006100024O005F004A005F00202O005F005F00414O005F0002000200062O005F00B500013O0004CD3O00B500012O00CB005F5O0012ED006000423O00122O006100436O005F006100024O005F004A005F00062O005F00BA000100010004CD3O00BA00012O00CB005F5O00123A006000443O00123A006100454O0006005F006100022O001A015F004A005F2O00A300605O00123A0061002D4O00A300626O009C006300653O00205701660004004600069E00683O0001000E2O0013012O00554O0013012O00564O0013012O00574O0013012O005B4O0013012O00594O0013012O005A4O0013012O00634O0013012O00604O0013012O00614O0013012O00624O0013012O00584O0013012O005E4O0013012O005C4O0013012O005D4O002C01695O00122O006A00473O00122O006B00486O0069006B6O00663O000100069E00660001000100022O0013012O00534O00CB7O00205701670004004600069E00690002000100012O0013012O00664O00DE006A5O00122O006B00493O00122O006C004A6O006A006C6O00673O000100202O00670004004600069E00690003000100032O0013012O005F4O0013012O004A4O00CB8O00D6006A5O00122O006B004B3O00122O006C004C6O006A006C00024O006B5O00122O006C004D3O00122O006D004E6O006B006D6O00673O000100202O00670004004600069E00690004000100022O0013012O004A4O00CB8O00AD006A5O00122O006B004F3O00122O006C00506O006A006C6O00673O00014O00675O00122O006800513O00122O006900526O0067006900024O0067004A006700202O00670067005300122O006900546O0067006900014O00675O00122O006800553O00122O006900566O0067006900024O0067004A006700202O0067006700574O00670002000100069E00670005000100052O0013012O00074O0013012O004A4O00CB8O00CB3O00014O00CB3O00024O006200685O00122O006900583O00122O006A00596O0068006A00024O0068004A006800205701680068005A002089006A004A005B2O0013016B00674O000A0068006B000100069E00680006000100012O0013012O004A3O00069E00690007000100022O0013012O00134O0013012O004A3O00069E006A0008000100012O0013012O004A3O000247016B00093O00069E006C000A000100012O0013012O004A3O00069E006D000B000100032O0013012O004A4O00CB8O0013012O005C3O00069E006E000C000100042O0013012O004A4O00CB8O0013012O00524O0013012O00653O00069E006F000D000100032O0013012O004A4O0013012O00654O00CB7O00069E0070000E000100062O0013012O004A4O00CB8O00CB3O00014O0013012O00654O00CB3O00024O0013012O00613O00069E0071000F000100032O0013012O00684O0013012O004A4O00CB7O00069E00720010000100022O0013012O004A4O0013012O00073O00069E00730011000100052O0013012O005F4O0013012O004A4O00CB8O0013012O00604O0013012O00073O00069E00740012000100022O0013012O00074O0013012O004A3O000247017500133O00069E00760014000100052O0013012O004A4O0013012O00614O0013012O00604O00CB8O0013012O00523O00069E00770015000100012O0013012O004A3O00069E00780016000100022O0013012O00684O0013012O004A3O00069E00790017000100022O0013012O004A4O0013012O005B3O00069E007A0018000100042O0013012O004A4O00CB8O0013012O005C4O0013012O005B3O00069E007B0019000100012O0013012O00683O00069E007C001A0001000A2O0013012O00634O0013012O00084O0013012O004A4O00CB8O0013012O00184O0013012O00114O0013012O00074O0013012O00474O0013012O000B4O0013012O004C3O00069E007D001B000100082O0013012O005E4O0013012O004A4O00CB8O0013012O00074O0013012O00574O0013012O00684O0013012O00084O0013012O00583O00069E007E001C0001000F2O0013012O005D4O00CB3O00014O0013012O004A4O00CB8O0013012O00134O0013012O005C4O00CB3O00024O0013012O00594O0013012O005A4O0013012O00694O0013012O00504O0013012O00154O0013012O00524O0013012O00494O0013012O005B3O00069E007F001D000100062O0013012O00074O0013012O004A4O0013012O00564O0013012O00544O0013012O00534O0013012O004D3O00069E0080001E0001000C2O0013012O004A4O00CB8O0013012O00114O0013012O00074O0013012O00084O0013012O00474O0013012O000B4O0013012O004C4O0013012O005F4O0013012O00184O0013012O00544O0013012O007F3O00069E0081001F000100162O0013012O004A4O00CB8O0013012O00534O0013012O004F4O0013012O00754O0013012O00084O0013012O004C4O0013012O00074O0013012O00114O0013012O00774O0013012O00644O0013012O00474O0013012O000B4O0013012O000A4O0013012O003C4O0013012O00394O0013012O003A4O0013012O003B4O0013012O00604O0013012O006B4O0013012O006C4O0013012O00743O00069E008200200001000C2O0013012O00184O0013012O00544O0013012O007F4O0013012O004A4O00CB8O0013012O00074O0013012O00564O0013012O00114O0013012O005F4O0013012O00604O0013012O00524O0013012O00043O00069E00830021000100202O0013012O004A4O00CB8O0013012O00574O0013012O00074O0013012O00114O0013012O00084O0013012O005C4O0013012O00534O0013012O004F4O0013012O00784O0013012O004C4O0013012O00544O0013012O00814O0013012O006C4O0013012O006D4O0013012O00644O0013012O00604O0013012O00614O0013012O00524O0013012O00704O0013012O00764O0013012O00564O00CB3O00014O00CB3O00024O0013012O006E4O0013012O00474O0013012O000B4O0013012O005F4O0013012O00654O0013012O007D4O0013012O00184O0013012O00823O00069E00840022000100062O0013012O004A4O00CB8O0013012O00114O0013012O00084O0013012O00074O0013012O00683O00069E00850023000100232O0013012O00644O0013012O00074O0013012O004A4O0013012O00574O00CB8O0013012O00114O0013012O00084O0013012O005B4O0013012O00594O0013012O00534O0013012O004F4O0013012O007A4O0013012O004C4O0013012O005C4O0013012O00524O0013012O00544O0013012O00844O0013012O007B4O0013012O00814O0013012O005F4O0013012O00564O0013012O00654O00CB3O00014O00CB3O00024O0013012O00614O0013012O00604O0013012O005E4O0013012O006F4O0013012O007E4O0013012O005D4O0013012O00794O0013012O00474O0013012O000B4O0013012O00184O0013012O00823O00069E008600240001001D2O0013012O004A4O00CB8O0013012O002E4O0013012O00074O0013012O002F4O0013012O00114O0013012O002C4O0013012O002D4O0013012O002B4O0013012O002A4O0013012O00534O0013012O00084O0013012O00444O0013012O00454O0013012O00464O0013012O001A4O0013012O00424O0013012O00414O0013012O004C4O0013012O003E4O0013012O003D4O0013012O00404O0013012O003F4O0013012O004B4O0013012O00304O0013012O00314O0013012O001C4O0013012O001E4O0013012O001D3O00069E00870025000100092O0013012O00164O0013012O00224O0013012O004A4O00CB8O0013012O00214O0013012O00074O0013012O00114O0013012O004C4O0013012O00203O00069E00880026000100062O0013012O004A4O00CB8O0013012O00194O0013012O00534O0013012O00114O0013012O004C3O00069E00890027000100302O0013012O00234O00CB8O0013012O00244O0013012O00254O0013012O00264O0013012O003B4O0013012O003C4O0013012O003D4O0013012O003E4O0013012O00374O0013012O00384O0013012O00394O0013012O003A4O0013012O001D4O0013012O001E4O0013012O001B4O0013012O001C4O0013012O00214O0013012O00224O0013012O001F4O0013012O00204O0013012O00354O0013012O00364O0013012O00334O0013012O00344O0013012O00434O0013012O00444O0013012O00454O0013012O00464O0013012O00474O0013012O00484O0013012O00494O0013012O003F4O0013012O00404O0013012O00414O0013012O00424O0013012O00294O0013012O002A4O0013012O00274O0013012O00284O0013012O002F4O0013012O00304O0013012O00314O0013012O00324O0013012O002B4O0013012O002C4O0013012O002D4O0013012O002E3O00069E008A0028000100312O0013012O00074O0013012O00174O0013012O00084O0013012O00114O0013012O004A4O00CB8O0013012O001F4O0013012O00534O0013012O004C4O0013012O00254O0013012O00544O0013012O00434O0013012O00874O0013012O00564O0013012O00044O0013012O00504O0013012O00604O0013012O005F4O0013012O00554O0013012O00644O0013012O00654O00CB3O00014O00CB3O00024O0013012O00614O0013012O007C4O0013012O00834O0013012O00264O0013012O005C4O0013012O005E4O0013012O00634O0013012O00194O0013012O00244O0013012O00524O0013012O00514O0013012O00854O0013012O00624O0013012O00684O0013012O00804O0013012O000A4O0013012O00234O0013012O00884O0013012O00864O0013012O000B4O0013012O004E4O0013012O00164O0013012O00184O0013012O00894O0013012O004F4O0013012O001A3O00069E008B0029000100042O0013012O00664O0013012O004A4O00CB8O0013012O000E3O0020DF008C000E005C00122O008D005D6O008E008A6O008F008B6O008C008F00016O00013O002A3O00283O00028O00025O00109B40025O00406040025O00188B40025O001EA940025O009FB040025O00288140024O0080B3C540026O00F03F025O00C88440025O00BDB140025O00807D40025O00208040025O00049140025O00FEAA40027O0040025O0084AB40025O00C4A040026O000840025O00A8B040025O00B88E40026O001440025O0046AB40025O0074A940025O00207840025O009FB140026O001040025O0061B140025O0078AC40025O00BBB240025O00F2A740030D3O00566172502O6F6C416D6F756E74026O004E4003113O005661724D696E64536561724375746F2O66025O00206340025O007C9D40025O00949B40026O008440025O0014B340025O00C49B4000793O00123A3O00014O009C000100013O002EA400030002000100020004CD3O000200010026793O0002000100010004CD3O0002000100123A000100013O0026280001000D000100010004CD3O000D0001002E690005000D000100040004CD3O000D0001002EA400060020000100070004CD3O0020000100123A000200013O000E4900010015000100020004CD3O0015000100123A000300084O00DA00035O00123A000300084O00DA000300013O00123A000200093O002EA4000A00190001000B0004CD3O001900010026280002001B000100090004CD3O001B0001002EDC000D000E0001000C0004CD3O000E00012O00A300036O00DA000300023O00123A000100093O0004CD3O002000010004CD3O000E0001002EA4000E00370001000F0004CD3O0037000100267900010037000100100004CD3O0037000100123A000200013O00262800020029000100090004CD3O00290001002EDC0011002D000100120004CD3O002D00012O00A300036O00DA000300033O00123A000100133O0004CD3O00370001002EDC00150025000100140004CD3O0025000100267900020025000100010004CD3O0025000100123A000300014O0027000300046O00038O000300053O00122O000200093O00044O002500010026280001003B000100160004CD3O003B0001002EA40017003E000100180004CD3O003E00012O009C000200024O00DA000200063O0004CD3O00780001002EDC0019004B0001001A0004CD3O004B0001002628000100440001001B0004CD3O00440001002EDC001C004B0001001D0004CD3O004B00012O00A300026O002B010200073O00122O000200016O000200086O00028O000200093O00122O000100163O0026790001005E000100090004CD3O005E000100123A000200013O002EDC001F00560001001E0004CD3O00560001000E4900090056000100020004CD3O0056000100123A000300213O001210010300203O00123A000100103O0004CD3O005E00010026790002004E000100010004CD3O004E00012O00A300036O00D10003000A3O00122O000300103O00122O000300223O00122O000200093O00044O004E000100262800010062000100130004CD3O00620001002EA400240007000100230004CD3O0007000100123A000200013O002EDC00260067000100250004CD3O0067000100262800020069000100090004CD3O00690001002E0E01270006000100280004CD3O006D00012O00A300036O00DA0003000B3O00123A0001001B3O0004CD3O0007000100267900020063000100010004CD3O006300012O00A300036O00270003000C6O00038O0003000D3O00122O000200093O00044O006300010004CD3O000700010004CD3O007800010004CD3O000200012O00013O00017O00043O0003123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD70901803193O00018DAC5C01841D112788BA680D9B141136819B49069D17163603083O007045E4DF2C64E871000D4O0051019O000100013O00122O000200013O00122O000300026O0001000300024O00026O0062000300013O00122O000400033O00122O000500046O0003000500024O0002000200032O00573O000100022O00013O00019O003O00034O00CB8O00A63O000100012O00013O00017O00073O00030A3O00A10C5142E644EE88004D03073O0080EC653F268421030B3O004973417661696C61626C65030A3O0081A01F40B4EEC1A8AC2O03073O00AFCCC97124D68B030B3O0074C434D80B50CA3CD90A4303053O006427AC55BC001A4O002O012O00016O000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001200013O0004CD3O001200012O00CB3O00014O0062000100023O00122O000200043O00122O000300056O0001000300028O0001000653012O0018000100010004CD3O001800012O00CB3O00014O0062000100023O00122O000200063O00122O000300076O0001000300028O00012O00DA8O00013O00017O000A3O00028O00026O006940025O00B6AF40030B3O008DFAC0C635D9916CBFE1C903083O001EDE92A1A25AAED203163O005265676973746572496E466C69676874452O66656374024O0050120941030B3O00D646710EEA595318E45D7803043O006A852E1003103O005265676973746572496E466C69676874001F3O00123A3O00014O009C000100013O002EDC00020002000100030004CD3O000200010026793O0002000100010004CD3O0002000100123A000100013O00267900010007000100010004CD3O000700012O00CB00026O00E3000300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O00020002000600122O000400076O0002000400014O00028O000300013O00122O000400083O00122O000500096O0003000500024O00020002000300202O00020002000A4O00020002000100044O001E00010004CD3O000700010004CD3O001E00010004CD3O000200012O00013O00017O00383O00028O00026O00F03F025O0014A940025O00E09540025O006AA740025O0008A840025O00909540025O002EAE40025O00E06640025O001AAA40025O00A07A40025O0098A94003063O0042752O66557003113O004461726B417363656E73696F6E42752O66025O00189240025O009DB240026O00F43F025O0010AC40025O00F8AF40026O000840025O00608A40025O00406F40025O0068AA40030B3O000AA08848F7766D3FA7844803073O00185CCFE12C8319030B3O004973417661696C61626C6502F6285C8FC2F5F03F025O0095B240025O0008AC40025O00E9B240025O00F5B140027O0040025O00F4AE4003103O00FF8202E1B6CEDBDE8F23F0B8D0C6CF9203073O00AFBBEB7195D9BC025O00A06840025O006CB140026O33F33F03103O004D696E644465766F7572657242752O66025O00E2A740025O006AA040025O00B07D40025O00C06C40025O00405140025O0020614003123O004461726B4576616E67656C69736D42752O66025O0012AF40025O0050B24003093O0042752O66537461636B027B14AE47E17A843F025O00F0A14003103O004465766F757265644665617242752O6603113O004465766F75726564507269646542752O6602CD5OCCF03F025O00A08040025O0080954000B43O00123A3O00014O009C000100023O000EA00002000800013O0004CD3O00080001002ECA00030008000100040004CD3O00080001002E0E010500A5000100060004CD3O00AB000100123A000300013O002EDC00070040000100080004CD3O0040000100267900030040000100010004CD3O00400001002EA4000900290001000A0004CD3O0029000100267900010029000100010004CD3O0029000100123A000400013O00262800040016000100010004CD3O00160001002EDC000C00220001000B0004CD3O0022000100123A000200024O00CB00055O00204400050005000D4O000700013O00202O00070007000E4O00050007000200062O00050020000100010004CD3O00200001002EA4001000210001000F0004CD3O002100010020E800020002001100123A000400023O00262800040026000100020004CD3O00260001002E0E011200EEFF2O00130004CD3O0012000100123A000100023O0004CD3O002900010004CD3O001200010026280001002D000100140004CD3O002D0001002E0E01150014000100160004CD3O003F000100123A000400013O000E490001002E000100040004CD3O002E0001002E0E0117000D000100170004CD3O003D00012O00CB000500015O00010600023O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005001A4O00050002000200062O0005003D00013O0004CD3O003D00010020E800020002001B2O005A010200023O0004CD3O002E000100123A000300023O00262800030044000100020004CD3O00440001002EDC001C00090001001D0004CD3O00090001002EA4001F00680001001E0004CD3O0068000100267900010068000100200004CD3O0068000100123A000400013O002E0E01210006000100210004CD3O004F00010026790004004F000100020004CD3O004F000100123A000100143O0004CD3O0068000100267900040049000100010004CD3O004900012O00CB000500014O0040010600023O00122O000700223O00122O000800236O0006000800024O00050005000600202O00050005001A4O00050002000200062O0005005D000100010004CD3O005D0001002EDC0025005E000100240004CD3O005E00010020E80002000200262O00CB00055O0020F100050005000D4O000700013O00202O0007000700274O00050007000200062O0005006600013O0004CD3O006600010020E800020002002600123A000400023O0004CD3O0049000100267900010008000100020004CD3O0008000100123A000400013O00262800040071000100010004CD3O00710001002ECA00280071000100290004CD3O00710001002EDC002A00A20001002B0004CD3O00A20001002EA4002C00900001002D0004CD3O009000012O00CB00055O00204400050005000D4O000700013O00202O00070007002E4O00050007000200062O0005007C000100010004CD3O007C0001002EA4003000900001002F0004CD3O009000012O00CB000500033O00121F000600026O00075O00202O0007000700314O000900013O00202O00090009002E4O00070009000200102O0007003200074O0005000700024O000600043O00122O000700026O00085O00202O0008000800314O000A00013O00202O000A000A002E4O0008000A000200102O0008003200084O0006000800024O0005000500064O000200020005002E0E01330011000100330004CD3O00A100012O00CB00055O00204400050005000D4O000700013O00202O0007000700344O00050007000200062O000500A0000100010004CD3O00A000012O00CB00055O0020F100050005000D4O000700013O00202O0007000700354O00050007000200062O000500A100013O0004CD3O00A100010020E800020002003600123A000400023O0026790004006B000100020004CD3O006B000100123A000100203O0004CD3O000800010004CD3O006B00010004CD3O000800010004CD3O000900010004CD3O000800010004CD3O00B30001000EA0000100AF00013O0004CD3O00AF0001002EA400380002000100370004CD3O0002000100123A000100014O009C000200023O00123A3O00023O0004CD3O000200012O00013O00017O00063O00025O00889A40025O004AA54003083O00446562752O66557003143O00536861646F77576F72645061696E446562752O6603133O0056616D7069726963546F756368446562752O6603153O004465766F7572696E67506C61677565446562752O6602223O002EDC00010016000100020004CD3O001600010006F50001001600013O0004CD3O0016000100205701023O00032O00CB00045O0020890004000400042O00060002000400020006F50002001400013O0004CD3O0014000100205701023O00032O00CB00045O0020890004000400052O00060002000400020006F50002001400013O0004CD3O0014000100205701023O00032O00CB00045O0020890004000400062O00060002000400022O005A010200023O0004CD3O0021000100205701023O00032O00CB00045O0020890004000400042O00060002000400020006F50002002000013O0004CD3O0020000100205701023O00032O00CB00045O0020890004000400052O00060002000400022O005A010200024O00013O00017O00343O00028O00026O00F03F025O00C0AF40025O00308840025O00707C40026O008A40025O0056A240025O00389E40025O00B2A540025O00BCA140025O0054A84003053O007061697273025O00709840025O00CEA94003093O0054696D65546F446965025O00E08240025O003DB24003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66025O0050A040025O00B6A240025O00209F40025O0074A440025O00ECA940025O00207A40025O00E8A040025O0094A840025O00708540025O0066A140025O00C6AF40025O00D2A340025O00E88240025O0049B040025O00B8AF40025O00805540025O00F08240025O007CA640025O00A06140025O00A07D40025O00A49040027O0040025O002BB040025O00CAA840025O00206340025O002AA340025O0028B140025O00A88F40025O00E8A440025O0083B040025O00408040025O00B4AB40025O008EA54002AE3O00123A000200014O009C000300053O002679000200A5000100020004CD3O00A500012O009C000500053O00123A000600013O002E0E01030074000100030004CD3O007A00010026280006000C000100020004CD3O000C0001002EDC0004007A000100050004CD3O007A000100262800030010000100020004CD3O00100001002E0E010600F7FF2O00070004CD3O0005000100123A000700013O00262800070017000100010004CD3O00170001002EDB00080017000100090004CD3O00170001002E0E010A005F0001000B0004CD3O007400012O009C000500053O0012040008000C4O001301096O004B01080002000A0004CD3O0071000100123A000D00014O009C000E000F3O002628000D0022000100020004CD3O00220001002EDC000E00690001000D0004CD3O00690001002679000E0022000100010004CD3O002200010020570110000C000F2O00290110000200022O0013010F00103O0006532O01002B000100010004CD3O002B0001002E0E01100022000100110004CD3O004B00012O00CB00105O0020090011000C00124O001300013O00202O0013001300134O001100136O00103O00024O0010000F001000062O0010003E000100040004CD3O00710001002EDC00150037000100140004CD3O003700010004CD3O0071000100123A001000014O009C001100113O002EA400160039000100170004CD3O0039000100267900100039000100010004CD3O0039000100123A001100013O00262800110044000100010004CD3O00440001002EDB00180044000100190004CD3O00440001002EDC001B003E0001001A0004CD3O003E00012O00130104000F4O00130105000C3O0004CD3O007100010004CD3O003E00010004CD3O007100010004CD3O003900010004CD3O00710001002EDC001C00710001001D0004CD3O00710001000686000400510001000F0004CD3O00510001002EA4001E00710001001F0004CD3O0071000100123A001000014O009C001100113O002E0E01203O000100200004CD3O0053000100262800100059000100010004CD3O00590001002EA400210053000100220004CD3O0053000100123A001100013O000EA000010060000100110004CD3O00600001002ECA00240060000100230004CD3O00600001002EDC0025005A000100260004CD3O005A00012O00130104000F4O00130105000C3O0004CD3O007100010004CD3O005A00010004CD3O007100010004CD3O005300010004CD3O007100010004CD3O002200010004CD3O00710001002EDC0027001E000100280004CD3O001E0001002679000D001E000100010004CD3O001E000100123A000E00014O009C000F000F3O00123A000D00023O0004CD3O001E00010006630008001C000100020004CD3O001C000100123A000700023O00267900070011000100020004CD3O0011000100123A000300293O0004CD3O000500010004CD3O001100010004CD3O00050001002EDC002B00060001002A0004CD3O0006000100262800060080000100010004CD3O00800001002EA4002D00060001002C0004CD3O000600010026790003009E000100010004CD3O009E000100123A000700014O009C000800083O002E0E012E3O0001002E0004CD3O0084000100267900070084000100010004CD3O0084000100123A000800013O000E490002008D000100080004CD3O008D000100123A000300023O0004CD3O009E0001002E0E012F00FCFF2O002F0004CD3O0089000100262800080093000100010004CD3O00930001002EA400310089000100300004CD3O00890001002E0E01320006000100320004CD3O00990001000653012O0099000100010004CD3O009900012O009C000900094O005A010900023O00123A000400013O00123A000800023O0004CD3O008900010004CD3O009E00010004CD3O00840001002679000300A1000100290004CD3O00A100012O005A010500023O00123A000600023O0004CD3O000600010004CD3O000500010004CD3O00AD0001002628000200A9000100010004CD3O00A90001002EA400330002000100340004CD3O0002000100123A000300014O009C000400043O00123A000200023O0004CD3O000200012O00013O00017O00023O00030D3O00446562752O6652656D61696E7303143O00536861646F77576F72645061696E446562752O6601063O0020592O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00013O0003093O0054696D65546F44696501043O0020572O013O00012O00292O01000200022O005A2O0100024O00013O00017O00023O00030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O6601063O0020592O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O000E3O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603093O0054696D65546F446965026O002840030B3O008ED12148B2CE035EBCCA2803043O002CDDB940030F3O00432O6F6C646F776E52656D61696E73030D3O00446562752O6652656D61696E73030B3O0032EF495B7C16C45A5E600903053O00136187283F03083O00496E466C6967687403113O0099543A283F34BC553D3C1C39AF583C2C3C03063O0051CE3C535B4F030B3O004973417661696C61626C6501333O0020F100013O00014O00035O00202O0003000300024O00010003000200062O0001003100013O0004CD3O003100010020572O013O00032O00292O0100020002000E090104002F000100010004CD3O002F00012O00CB00016O0062000200013O00122O000300053O00122O000400066O0002000400024O0001000100020020352O01000100074O00010002000200202O00023O00084O00045O00202O0004000400024O00020004000200062O00020022000100010004CD3O002200012O00CB00017O00010200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200202O00010001000B4O00010002000200062O0001003000013O0004CD3O003000012O00CB000100023O0006532O010031000100010004CD3O003100012O00CB00016O00C8000200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200202O00010001000E4O0001000200024O000100013O00044O003100012O00322O016O00A3000100014O005A2O0100024O00013O00017O00063O0003103O006AA2C36620D159A14A99D57323CA59BD03083O00C42ECBB0124FA32D030B3O004973417661696C61626C65026O00F03F030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6601184O003O018O000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O00010002000200062O0001001500013O0004CD3O001500012O00CB000100023O00262800010015000100040004CD3O001500010020572O013O00052O005100035O00202O0003000300064O0001000300024O000200033O00062O00010002000100020004CD3O001500012O00322O016O00A3000100014O005A2O0100024O00013O00017O00053O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603103O009C2B6D0A2BE9FBBD264C1B25F7E6AC3B03073O008FD8421E7E449B030B3O004973417661696C61626C6501153O0020572O013O00012O005100035O00202O0003000300024O0001000300024O000200013O00062O0001000C000100020004CD3O001200012O00CB00016O00C8000200023O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O0001000200024O000100013O00044O001300012O00322O016O00A3000100014O005A2O0100024O00013O00017O000C3O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603093O0087C103CFE7AFD6F2BE03083O0081CAA86DABA5C3B7030B3O004578656375746554696D6503093O000F5139DCFC18E7314C03073O0086423857B8BE7403103O0046752O6C526563686172676554696D6503093O00113807BF3BE720262803083O00555C5169DB798B4103093O00D0BA5E415ED3FCA04403063O00BF9DD330251C014D3O0020572O013O00012O00CB00035O0020890003000300022O00060001000300022O00CE00028O000300013O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062O0002002F000100010004CD3O002F00012O00CB00016O0062000200013O00122O000300063O00122O000400076O0002000400024O0001000100020020262O01000100084O0001000200024O000200026O000300036O00046O0062000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500209B0004000400054O000400056O00023O00024O000300046O000400036O00056O0062000600013O00122O000700093O00122O0008000A6O0006000800024O0005000500060020020005000500054O000500066O00033O00024O00020002000300062O0001001C000100020004CD3O004A00012O00CB000100054O008F000200026O00038O000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O0003000300054O0003000200024O000400036O0002000400024O000300046O00048O000500013O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O0004000400054O0004000200024O000500036O0003000500024O00020002000300062O00010002000100020004CD3O004A00012O00322O016O00A3000100014O005A2O0100024O00013O00017O00053O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603093O00F216FA183DDE12F10F03053O005ABF7F947C03083O004361737454696D6501184O00B100018O00028O000300016O00010003000200062O0001001600013O0004CD3O001600010020572O013O00012O00CB000300013O0020890003000300022O00060001000300022O00CB000200014O0062000300023O00122O000400033O00122O000500046O0003000500024O0002000200030020570102000200052O002901020002000200064700020002000100010004CD3O001500012O00322O016O00A3000100014O005A2O0100024O00013O00017O00063O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F44696503083O0042752O66446F776E030C3O00566F6964666F726D42752O6601183O00204400013O00014O00035O00202O0003000300024O00010003000200062O00010016000100010004CD3O001600010020572O013O00032O00DD00035O00202O0003000300024O00010003000200202O00023O00044O00020002000200062O00010014000100020004CD3O001400012O00CB000100013O00207C0001000100054O00035O00202O0003000300064O00010003000200044O001600012O00322O016O00A3000100014O005A2O0100024O00013O00017O000B3O0003103O004865616C746850657263656E74616765026O003440030F3O00432O6F6C646F776E52656D61696E73026O00244003123O0051892B047B863E167A8B2B2377952312769303043O007718E74E030B3O004973417661696C61626C6503123O00AB23A059DF4101832FA94FE84F038F28AB5E03073O0071E24DC52ABC2003063O0042752O66557003103O004465617468737065616B657242752O66012A3O0020572O013O00012O00292O010002000200263B00010013000100020004CD3O001300012O00CB00015O0020572O01000100032O00292O0100020002000E5201040027000100010004CD3O002700012O00CB000100015O00010200023O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002700013O0004CD3O002700012O00CB000100033O0006F50001002000013O0004CD3O002000012O00CB000100014O0040010200023O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100074O00010002000200062O00010028000100010004CD3O002800012O00CB000100043O00207C00010001000A4O000300013O00202O00030003000B4O00010003000200044O002800012O00322O016O00A3000100014O005A2O0100024O00013O00017O00043O0003103O004865616C746850657263656E74616765026O00344003063O0042752O66557003103O004465617468737065616B657242752O66010E3O0020572O013O00012O00292O01000200020026162O01000B000100020004CD3O000B00012O00CB00015O00207C0001000100034O000300013O00202O0003000300044O00010003000200044O000C00012O00322O016O00A3000100014O005A2O0100024O00013O00017O00023O0003103O004865616C746850657263656E74616765026O00344001083O0020572O013O00012O00292O01000200020026162O010005000100020004CD3O000500012O00322O016O00A3000100014O005A2O0100024O00013O00017O00073O0003083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O66027O004003123O001318F1A63917E4B4381AF1813504F9B0340203043O00D55A7694030B3O004973417661696C61626C65026O001C40011D3O0020F100013O00014O00035O00202O0003000300024O00010003000200062O0001001B00013O0004CD3O001B00012O00CB000100013O0026BA00010019000100030004CD3O001900012O00CB000100023O0006F50001001B00013O0004CD3O001B00012O00CB00017O00010200033O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O00010002000200062O0001001B00013O0004CD3O001B00012O00CB000100043O00266E0001001A000100070004CD3O001A00012O00322O016O00A3000100014O005A2O0100024O00013O00017O00023O00030D3O00446562752O6652656D61696E7303143O00536861646F77576F72645061696E446562752O6601063O0020592O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O66027O0040010F4O00CB00016O001301026O00292O01000200020006F50001000D00013O0004CD3O000D00010020572O013O00012O00CB000300013O0020890003000300022O0006000100030002000E520103000C000100010004CD3O000C00012O00322O016O00A3000100014O005A2O0100024O00013O00017O00053O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603093O0054696D65546F446965026O00324003083O00446562752O66557001173O0020F100013O00014O00035O00202O0003000300024O00010003000200062O0001001500013O0004CD3O001500010020572O013O00032O00292O0100020002000E0901040013000100010004CD3O001300010020572O013O00052O00CB00035O0020890003000300022O00060001000300020006532O010015000100010004CD3O001500012O00CB000100014O00FB000100013O0004CD3O001500012O00322O016O00A3000100014O005A2O0100024O00013O00017O00123O00028O00025O00B07140025O000EA640025O0092B040025O00E07640025O0060AF40025O00D2AB40025O00049D40025O0044A940030B3O006826B552424C0DA6575E5303053O002D3B4ED436030F3O00432O6F6C646F776E52656D61696E73030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O6603113O00446562752O665265667265736861626C6503093O0054696D65546F446965026O00324003083O00446562752O665570013E3O00123A000100013O00262800010005000100010004CD3O00050001002EA400030001000100020004CD3O0001000100123A000200013O002EDC00050006000100040004CD3O00060001000E4900010006000100020004CD3O0006000100123A000300013O002EDC0007000B000100060004CD3O000B00010026790003000B000100010004CD3O000B0001002EDC00080038000100090004CD3O003800012O00CB00046O0062000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500203F01040004000C4O00040002000200202O00053O000D4O00075O00202O00070007000E4O00050007000200062O00050004000100040004CD3O002200012O00CB000400023O0006F50004003800013O0004CD3O0038000100205701043O000F2O00CB00065O00208900060006000E2O00060004000600020006F50004003700013O0004CD3O0037000100205701043O00102O0029010400020002000E0901110035000100040004CD3O0035000100205701043O00122O00CB00065O00208900060006000E2O000600040006000200065301040037000100010004CD3O003700012O00CB000400034O00FB000400043O0004CD3O003700012O003201046O00A3000400014O005A010400024O009C000400044O005A010400023O0004CD3O000B00010004CD3O000600010004CD3O000100012O00013O00019O002O0001064O005300018O00028O00038O0001000300024O000100028O00017O00583O00028O00025O00C8AF40025O00709240026O00F03F03043O0047554944025O00A2A340025O0068B240030D3O003144808A882B99FF024486859203083O00907036E3EBE64ECD030A3O0049734361737461626C65025O0006AA40026O009440030D3O00417263616E65546F2O72656E74030E3O0049735370652O6C496E52616E6765031A3O00B23A0CFDDE5E8C3C00EEC25EBD3C4FECC25EB02702FED14FF37E03063O003BD3486F9CB0025O0056A240025O00188240025O000EAA40025O0060A740025O00D2A24003093O004973496E506172747903083O004973496E52616964030B3O007D8FE2294190C03F4F94EB03043O004D2EE78303073O00995BB846B346BB03043O0020DA34D6025O00108E40025O0014AD40030B3O00536861646F77437261736803093O004973496E52616E6765026O00444003183O005D1F30ACFEA77A595C1622A0B1A0575F4D183CAAF0A4050203083O003A2E7751C891D02503123O000E8235A1B0FD03258835BEE99E23399F3FBE03073O00564BEC50CCC9DD025O00B6A240025O00B2A440025O00289740025O00D0964003063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F72025O00606540025O0053B240025O00749540025O0088B24003183O0061497681F19C4D426584ED8332516580FD847F437691BED303063O00EB122117E59E03093O0071AE819845A8D2B44203043O00DB30DAA1025O00FAA040025O00E8B240025O0058AE40025O0008954003183O00F7797D4DD458DFE7637D5AD30FF0F6747F46D64DE1F0312403073O008084111C29BB2F025O005EA340025O00D8A740025O0040AA40027O0040025O0082AD40025O00A49140030D3O0037330B2A54133B050E5214310E03053O003D6152665A030B3O009F26AA4FC8403D1BAD3DA303083O0069CC4ECB2BA7377E030B3O004973417661696C61626C65030B3O0096A2221A1C13E443A4B92B03083O0031C5CA437E7364A7030C3O00432O6F6C646F776E446F776E030B3O000453DE2D8F417D255ACC2103073O003E573BBF49E03603083O00496E466C69676874025O00849240025O0068A440030D3O0056616D7069726963546F756368031B3O00F103F7D9EE10F3CAD816F5DCE40ABAD9F507F9C6EA00FBDDA753AE03043O00A987629A025O0080B140025O00588540030E3O00F87F2550F224FFC4652064FC3AC603073O00A8AB1744349D5303063O00D978E6A8373403073O00E7941195CD454D030E3O00536861646F77576F72645061696E031D3O0093AFC6FF58E8BFB0C8E953C090A6CEF517EF92A2C4F45AFD81B387AA0103063O009FE0C7A79B37002D012O00123A3O00014O009C000100013O002EDC00030037000100020004CD3O003700010026793O0037000100010004CD3O0037000100123A000200013O0026790002000B000100040004CD3O000B000100123A3O00043O0004CD3O0037000100267900020007000100010004CD3O000700012O00CB000300013O0020570103000300052O00290103000200022O00DA00035O002E0E01060024000100060004CD3O00350001002E0E01070022000100070004CD3O003500012O00CB000300025O00010400033O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003500013O0004CD3O003500012O00CB000300043O0006F50003003500013O0004CD3O00350001002EDC000C00350001000B0004CD3O003500012O00CB000300054O0044010400023O00202O00040004000D4O000500013O00202O00050005000E4O000700023O00202O00070007000D4O0005000700024O000500056O00030005000200062O0003003500013O0004CD3O003500012O00CB000300033O00123A0004000F3O00123A000500104O000F000300054O004B00035O00123A000200043O0004CD3O00070001002EA4001200C1000100110004CD3O00C10001002EA4001400C1000100130004CD3O00C100010026793O00C1000100040004CD3O00C1000100123A000200013O002E0E0115007A000100150004CD3O00B80001002679000200B8000100010004CD3O00B800012O00CB000300063O0020570103000300162O00290103000200020006412O01004B000100030004CD3O004B00012O00CB000300063O0020570103000300172O00290103000200022O00FB000100034O00CB000300025O00010400033O00122O000500183O00122O000600196O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300B700013O0004CD3O00B700010006532O0100B7000100010004CD3O00B700012O00CB000300074O000D010400033O00122O0005001A3O00122O0006001B6O00040006000200062O00030060000100040004CD3O00600001002EA4001D00710001001C0004CD3O007100012O00CB000300054O0078000400023O00202O00040004001E4O000500013O00202O00050005001F00122O000700206O0005000700024O000500056O00030005000200062O000300B700013O0004CD3O00B700012O00CB000300033O001218000400213O00122O000500226O000300056O00035O00044O00B700012O00CB000300074O0020000400033O00122O000500233O00122O000600246O00040006000200062O0003009C000100040004CD3O009C0001002EDC002500B7000100260004CD3O00B70001002EA4002800B7000100270004CD3O00B700012O00CB000300083O0020570103000300292O00290103000200020006F5000300B700013O0004CD3O00B700012O00CB000300063O00205701030003002A2O00CB000500084O00060003000500020006F5000300B700013O0004CD3O00B700012O00CB000300054O005D010400093O00202O00040004002B4O000500013O00202O00050005001F00122O000700206O0005000700024O000500056O00030005000200062O00030096000100010004CD3O00960001002ECA002D00960001002C0004CD3O00960001002EDC002F00B70001002E0004CD3O00B700012O00CB000300033O001218000400303O00122O000500316O000300056O00035O00044O00B700012O00CB000300074O000D010400033O00122O000500323O00122O000600336O00040006000200062O000300A5000100040004CD3O00A50001002EDC003500B7000100340004CD3O00B700012O00CB000300054O005D010400093O00202O00040004002B4O000500013O00202O00050005001F00122O000700206O0005000700024O000500056O00030005000200062O000300B2000100010004CD3O00B20001002EDC003600B7000100370004CD3O00B700012O00CB000300033O00123A000400383O00123A000500394O000F000300054O004B00035O00123A000200043O002EDC003A003E0001003B0004CD3O003E0001002E0E013C0084FF2O003C0004CD3O003E0001000E490004003E000100020004CD3O003E000100123A3O003D3O0004CD3O00C100010004CD3O003E00010026283O00C50001003D0004CD3O00C50001002EDC003E00020001003F0004CD3O000200012O00CB000200025O00010300033O00122O000400403O00122O000500416O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200032O013O0004CD3O00032O012O00CB000200025O00010300033O00122O000400423O00122O000500436O0003000500024O00020002000300202O0002000200444O00020002000200062O000200EF00013O0004CD3O00EF00012O00CB000200025O00010300033O00122O000400453O00122O000500466O0003000500024O00020002000300202O0002000200474O00020002000200062O000200ED00013O0004CD3O00ED00012O00CB000200025O00010300033O00122O000400483O00122O000500496O0003000500024O00020002000300202O00020002004A4O00020002000200062O000200EF00013O0004CD3O00EF00010006F5000100032O013O0004CD3O00032O01002EDC004B00032O01004C0004CD3O00032O012O00CB000200054O006C000300023O00202O00030003004D4O000400013O00202O00040004000E4O000600023O00202O00060006004D4O0004000600024O000400046O000500016O00020005000200062O000200032O013O0004CD3O00032O012O00CB000200033O00123A0003004E3O00123A0004004F4O000F000200044O004B00025O002EA40051002C2O0100500004CD3O002C2O012O00CB000200025O00010300033O00122O000400523O00122O000500536O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002002C2O013O0004CD3O002C2O012O00CB000200024O0040010300033O00122O000400543O00122O000500556O0003000500024O00020002000300202O0002000200444O00020002000200062O0002002C2O0100010004CD3O002C2O012O00CB000200054O0044010300023O00202O0003000300564O000400013O00202O00040004000E4O000600023O00202O0006000600564O0004000600024O000400046O00020004000200062O0002002C2O013O0004CD3O002C2O012O00CB000200033O001218000300573O00122O000400586O000200046O00025O00044O002C2O010004CD3O000200012O00013O00017O00253O00028O00025O00E89040026O00A640026O00F03F030C3O001C21DC5F0F3CC04B3E27DA5503043O003B4A4EB5030F3O00432O6F6C646F776E52656D61696E732O033O00474344026O000840030C3O0013DE535E9637C44A4EBA2ADF03053O00D345B12O3A030B3O004973417661696C61626C65030D3O0093E46BFEC8D8B4E077E6E0C4B903063O00ABD785199589030A3O00432O6F6C646F776E5570030D3O00C5C920F1CE23FF47EFDB3BF5E103083O002281A8529A8F509C030B3O00B3BD3A0F7C419B97B73D1F03073O00E9E5D2536B282E030B3O00F1512BD50DC8411EDF0BCA03053O0065A12252B6030B3O00DE0250FAEFED903CED034D03083O004E886D399EBB82E2026O00104003083O0042752O66446F776E030C3O00566F6964666F726D42752O66025O00D8A540025O0080A340025O00ECAD40025O00E8B040025O002C9140025O0092B240030B3O00C4FB3DD6F8E41FC0F6E03403043O00B297935C03083O00496E466C6967687403113O00BBF5452102496885F34B011A4D7E83EA5F03073O001AEC9D2C52722C008A3O00123A3O00013O002EA400020059000100030004CD3O00590001000E490004005900013O0004CD3O005900012O00CB000100014O0062000200023O00122O000300053O00122O000400066O0002000400024O0001000100020020BD0001000100074O0001000200024O000200033O00202O0002000200084O00020002000200202O00020002000900062O0001001D000100020004CD3O001D00012O00CB000100014O0040010200023O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O00010002000200062O00010057000100010004CD3O005700012O00CB000100015O00010200023O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O00010001000F4O00010002000200062O0001003100013O0004CD3O003100012O00CB000100014O0040010200023O00122O000300103O00122O000400116O0002000400024O00010001000200202O00010001000C4O00010002000200062O00010057000100010004CD3O005700012O00CB000100015O00010200023O00122O000300123O00122O000400136O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001005700013O0004CD3O005700012O00CB000100015O00010200023O00122O000300143O00122O000400156O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001005700013O0004CD3O005700012O00CB000100014O0062000200023O00122O000300163O00122O000400176O0002000400024O0001000100020020572O01000100072O00292O01000200020026BA00010055000100180004CD3O005500012O00CB000100033O00207C0001000100194O000300013O00202O00030003001A4O00010003000200044O005700012O00322O016O00A3000100014O00DA00015O0004CD3O00890001002EA4001C00010001001B0004CD3O000100010026793O0001000100010004CD3O0001000100123A000100013O000EA000040062000100010004CD3O00620001002EA4001E00640001001D0004CD3O0064000100123A3O00043O0004CD3O0001000100262800010068000100010004CD3O00680001002EA40020005E0001001F0004CD3O005E00012O00CB000200054O00CB000300064O00A300046O000600020004000200065301020080000100010004CD3O008000012O00CB000200015O00010300023O00122O000400213O00122O000500226O0003000500024O00020002000300202O0002000200234O00020002000200062O0002008000013O0004CD3O008000012O00CB000200014O0062000300023O00122O000400243O00122O000500256O0003000500024O00020002000300205701020002000C2O00290102000200022O00DA000200044O001C000200056O000300066O000400016O0002000400024O000200073O00122O000100043O00044O005E00010004CD3O000100012O00013O00017O002B3O00028O00025O001CB240025O0034AC40026O00084003133O00078371AC389075BF058D69BF39A679BE24847A03043O00DC51E21C030F3O0041757261416374697665436F756E74026O002040026O00F03F026O003840025O00A09E40025O0007B340025O001CB340025O00F88340025O0026AA40025O00B2A240025O00809940025O00DCA24003093O0054696D65546F446965026O003240025O0047B040025O00BEB040027O0040025O00E2AA40025O008AAB40025O00C09840025O00DAA140025O0032A04003133O00083EF4E1372DF0F20A30ECF2361BFCF32B39FF03043O00915E5F99030B3O00CEC515D141A0DEDF15C64603063O00D79DAD74B52E03083O00496E466C6967687403113O0002BC82E1CA30A682FCDD06BC8AF6D522A703053O00BA55D4EB92030B3O004973417661696C61626C65025O0012B040025O0064B34003113O00F5891FED29EB4ACB8F11CD31EF5CCD960503073O0038A2E1769E598E03133O006A04CDBF2BCA5506F4A037DB5421C5AD37DE5A03063O00B83C65A0CF42026O00104000DE3O00123A3O00014O009C000100013O002EDC0003002F000100020004CD3O002F0001000E490004002F00013O0004CD3O002F00012O00CB000200014O00CB000300024O0062000400033O00122O000500053O00122O000600066O0004000600024O00030003000400205E0003000300074O0003000200024O000400046O000500056O000500056O00040002000200102O0004000800044O0002000400024O000300066O000400024O0062000500033O00122O000600053O00122O000700066O0005000700024O0004000400050020800004000400074O0004000200024O000500046O000600056O000600066O00050002000200102O0005000800054O0003000500024O0002000200034O000300073O00064700030005000100020004CD3O002C00012O00CB000200084O00FB000200023O0004CD3O002D00012O003201026O00A3000200014O00DA00025O0004CD3O00DD00010026283O0033000100090004CD3O00330001002E0E010A002A0001000B0004CD3O005B000100123A000200013O002EA4000C00540001000D0004CD3O0054000100267900020054000100010004CD3O0054000100123A000300013O002EDC000E004F0001000F0004CD3O004F00010026280003003F000100010004CD3O003F0001002EA40010004F000100110004CD3O004F00012O00CB000400094O00520005000A6O000600016O0004000600024O000100043O002E2O0012000A000100120004CD3O004E00010006F50001004E00013O0004CD3O004E00010020570104000100132O0029010400020002000E090114004E000100040004CD3O004E00012O00A3000400014O00DA000400083O00123A000300093O00267900030039000100090004CD3O0039000100123A000200093O0004CD3O005400010004CD3O00390001002EA400150034000100160004CD3O0034000100267900020034000100090004CD3O0034000100123A3O00173O0004CD3O005B00010004CD3O00340001002EDC00180067000100190004CD3O006700010026793O0067000100010004CD3O006700012O00CB0002000B4O00960003000C6O0004000D6O0002000400024O000200076O00028O000200083O00124O00093O0026793O0002000100170004CD3O0002000100123A000200013O002E0E011A00060001001A0004CD3O0070000100267900020070000100090004CD3O0070000100123A3O00043O0004CD3O00020001002EDC001C006A0001001B0004CD3O006A0001000E490001006A000100020004CD3O006A00012O00CB000300014O0006010400026O000500033O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O0004000400074O0004000200024O000500046O000600026O000700033O00122O0008001F3O00122O000900206O0007000900024O00060006000700202O0006000600214O00060002000200062O0006009000013O0004CD3O009000012O00CB000600024O0062000700033O00122O000800223O00122O000900236O0007000900024O0006000600070020570106000600242O00290106000200022O00290105000200020010BE0005000800052O00060003000500022O00CB000400064O0006010500026O000600033O00122O0007001D3O00122O0008001E6O0006000800024O00050005000600202O0005000500074O0005000200024O000600046O000700026O000800033O00122O0009001F3O00122O000A00206O0008000A00024O00070007000800202O0007000700214O00070002000200062O000700AF00013O0004CD3O00AF00012O00CB000700024O0062000800033O00122O000900223O00122O000A00236O0008000A00024O0007000700080020570107000700242O00290107000200022O002901060002000200107F0006000800064O0004000600024O0003000300044O000400073O00062O00040005000100030004CD3O00BA00012O00CB000300084O00FB000300033O0004CD3O00BB00012O003201036O00A3000300014O00DA0003000E3O002EDC002500DA000100260004CD3O00DA00012O00CB000300053O0006F5000300DA00013O0004CD3O00DA00012O00CB000300025O00010400033O00122O000500273O00122O000600286O0004000600024O00030003000400202O0003000300244O00030002000200062O000300DA00013O0004CD3O00DA00012O00CB000300074O00CB000400024O0062000500033O00122O000600293O00122O0007002A6O0005000700024O0004000400050020570104000400072O00290104000200022O00D8000300030004002616010300D80001002B0004CD3O00D800012O003201036O00A3000300014O00DA000300053O00123A000200093O0004CD3O006A00010004CD3O000200012O00013O00017O00263O0003063O0042752O665570030C3O00566F6964666F726D42752O6603113O00506F776572496E667573696F6E42752O6603113O004461726B417363656E73696F6E42752O66026O003440025O009CA640025O00DEA540028O00026O00F03F025O00EC9340025O002AAC40025O00249240025O001EA440026O006E40025O00989240025O0096AB40025O00AEAB40025O00F88040025O00D88340025O00A2A14003103O0048616E646C65546F705472696E6B65742O033O00434473026O004440025O00A49E40025O00B08040025O0098AD40026O004640025O00806840025O009EA740025O00B6B240025O00A0A54003133O0048616E646C65426F2O746F6D5472696E6B6574026O00A040025O00CEA740025O00C5B240025O0004A840025O00B07940025O0034A740006E4O00CB7O0020445O00014O000200013O00202O0002000200026O0002000200064O001A000100010004CD3O001A00012O00CB7O0020445O00014O000200013O00202O0002000200036O0002000200064O001A000100010004CD3O001A00012O00CB7O0020445O00014O000200013O00202O0002000200046O0002000200064O001A000100010004CD3O001A00012O00CB3O00023O002616012O001A000100050004CD3O001A0001002EDC0006006D000100070004CD3O006D000100123A3O00084O009C000100023O0026283O0022000100090004CD3O00220001002E69000B00220001000A0004CD3O00220001002E0E010C00450001000D0004CD3O00650001002EDC000E00260001000F0004CD3O0026000100262800010028000100080004CD3O00280001002EDC00110022000100100004CD3O0022000100123A000200083O002E0E01120020000100120004CD3O0049000100267900020049000100080004CD3O0049000100123A000300083O00262800030032000100080004CD3O00320001002EDC00140040000100130004CD3O004000012O00CB000400043O0020A70004000400154O000500053O00122O000600163O00122O000700176O000800086O0004000800024O000400036O000400033O00062O0004003F00013O0004CD3O003F00012O00CB000400034O005A010400023O00123A000300093O002EDC00190044000100180004CD3O0044000100262800030046000100090004CD3O00460001002EDC001A002E0001001B0004CD3O002E000100123A000200093O0004CD3O004900010004CD3O002E0001002EA4001C004D0001001D0004CD3O004D00010026280002004F000100090004CD3O004F0001002EDC001E00290001001F0004CD3O002900012O00CB000300043O0020830003000300204O000400053O00122O000500163O00122O000600176O000700076O0003000700024O000300033O002E2O0021005C000100220004CD3O005C00012O00CB000300033O0006530103005E000100010004CD3O005E0001002EDC0023006D000100240004CD3O006D00012O00CB000300034O005A010300023O0004CD3O006D00010004CD3O002900010004CD3O006D00010004CD3O002200010004CD3O006D00010026283O0069000100080004CD3O00690001002EA40026001C000100250004CD3O001C000100123A000100084O009C000200023O00123A3O00093O0004CD3O001C00012O00013O00017O009B3O00028O00025O00809440025O00D2A540027O0040025O0048A040025O007EAB40026O00F03F030D3O0036FC273F5701FE303A651BF23B03053O0016729D5554030A3O0049734361737461626C65025O00F7B240025O0030AE40030D3O004461726B417363656E73696F6E03173O00C0CA01CF62F7BBC7CE1DD754F9A684C403C153F3BA849D03073O00C8A4AB73A43D96030C3O0088FB0A41A6ACE113518AB1FA03053O00E3DE946325030B3O004973417661696C61626C65025O00B2B040030F4O005A53F2F624655DE4FD175753E2F103053O0099532O329603123O007478760F70AA5D5C747F1947A45F50737D0803073O002D3D16137C13CB03083O00507265764743445003093O004D696E64426C617374030F3O00F21A0CF10D678ECE0009D10771ADC903073O00D9A1726D95621003113O0054696D6553696E63654C61737443617374026O003440025O00E8A040025O0098AA40030F3O00536861646F77576F72644465617468030E3O0049735370652O6C496E52616E6765031A3O0001283978B3632D2O376EB84B16253968B4341D303D72B966527803063O00147240581CDC025O0014904003093O001C08DCB0DADCBC221503073O00DD5161B2D498B003143O00C0EE13FF25CFEB1CE80E8DE80DFE14C8F55DAA4A03053O007AAD877D9B025O00405640025O00E09040025O00CCA640030C3O00B2CE09BD1A23DD94D509B63103073O00A8E4A160D95F51030C3O00566F69644572757074696F6E03093O004973496E52616E6765026O004440025O00C4AA40025O00D49B40025O00508940025O00808D4003173O00CDDE27581052C9C43E482658D591214C2A59DEC36E0D7D03063O0037BBB14E3C4F025O005EAB40026O002A40030B3O0020DD83FFE5D030C783E8E203063O00A773B5E29B8A030A3O00446562752O66446F776E03133O0056616D7069726963546F756368446562752O6603073O00C12DE95A7263CB03073O00A68242873C1B11025O0018B140025O00CCAF40030B3O00536861646F774372617368025O00288940025O0042B040025O0055B340025O0094A74003153O005742CF713F5375CD673157428E7A204144CB67701603053O0050242AAE15025O00089940025O00A0724003123O006B1E3277575002744A15253A6D052569410203043O001A2E705703063O0045786973747303093O0043616E412O7461636B025O005DB040025O004FB04003113O00536861646F774372617368437572736F7203153O00AA2BAA70B0A87AB7AB22B87CFFB055B1B726B934ED03083O00D4D943CB142ODF25025O000DB240025O005C9C4003093O009B99E8F1AF9FBBDDA803043O00B2DAEDC803153O00A5BDE7D4B9A2D9D3A4B4F5D8F6BAF6D5B8B0F490E403043O00B0D6D586025O00A49D40025O0060744003133O00F9A4B8D0AA5357F0A8A494A7465CFAA8A494FC03073O003994CDD6B4C836025O0028B340025O00F6A540025O001CA54003093O00DE78F8083246F262E203063O002A9311966C70025O00A6AB40025O00809D40025O00BAA340025O0023B24003143O0002AF237BD8EA03A73E6BA7E71FA3237AF5A85DF603063O00886FC64D1F87025O00C88E40025O005AA64003093O002F00A9528EF41EA20703083O00C96269C736DD847703093O004D696E645370696B65025O001EAF40025O00F89140025O00A9B240025O009AB24003143O00B4058D253D26BCB00786610D25A9B7099161506703073O00CCD96CE3416255025O00A09B40025O00C4AF40025O0097B04003083O0073CAFBE10ACC5FDA03063O00A03EA395854C025O0024AA40025O00A0964003083O004D696E64466C6179025O00989640025O0008814003133O00DBA9032BFCD0AC0C3683D9B00821C6C4E05F7B03053O00A3B6C06D4F025O00408340025O00E06840025O0020B140025O00D0A140025O00E4A240025O0050B140025O00789B40025O00BEAA40025O00D4B140025O00B0824003083O001BC156EF64C08C3903073O00E04DAE3F8B26AF025O0056A040025O00D4A74003083O00566F6964426F6C74025O0022B140025O0048914003133O00924E512ABB4357229001573E814F5D3CC4100E03043O004EE42138025O0030AF40025O009AAB40030F3O00EA7BA40C90DC77BC04B5C27FB5168003053O00E5AE1ED26303073O0049735265616479025O00AAAB40025O003BB040030F3O004465766F7572696E67506C61677565031A3O001FE8905EF82F3015EAB941E13C3E0EE8C65EFD38371EFFC600B503073O00597B8DE6318D5D0007022O00123A3O00013O000E49000100352O013O0004CD3O00352O0100123A000100013O002EA400020008000100030004CD3O000800010026280001000A000100040004CD3O000A0001002EA40006000C000100050004CD3O000C000100123A3O00073O0004CD3O00352O01002679000100AC000100070004CD3O00AC00012O00CB00027O00010300013O00122O000400083O00122O000500096O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002002500013O0004CD3O00250001002EDC000C00250001000B0004CD3O002500012O00CB000200024O00CB00035O00208900030003000D2O00290102000200020006F50002002500013O0004CD3O002500012O00CB000200013O00123A0003000E3O00123A0004000F4O000F000200044O004B00026O00CB00027O00010300013O00122O000400103O00122O000500116O0003000500024O00020002000300202O0002000200124O00020002000200062O000200AB00013O0004CD3O00AB0001002E0E0113003B000100130004CD3O006A00012O00CB00027O00010300013O00122O000400143O00122O000500156O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002005700013O0004CD3O005700012O00CB00027O00010300013O00122O000400163O00122O000500176O0003000500024O00020002000300202O0002000200124O00020002000200062O0002005700013O0004CD3O005700012O00CB000200033O00203B01020002001800122O000400076O00055O00202O0005000500194O00020005000200062O0002005700013O0004CD3O005700012O00CB00026O0062000300013O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300205701020002001C2O0029010200020002000E58011D0059000100020004CD3O00590001002EA4001F006A0001001E0004CD3O006A00012O00CB000200024O004401035O00202O0003000300204O000400043O00202O0004000400214O00065O00202O0006000600204O0004000600024O000400046O00020004000200062O0002006A00013O0004CD3O006A00012O00CB000200013O00123A000300223O00123A000400234O000F000200044O004B00025O002E0E0124001E000100240004CD3O008800012O00CB00027O00010300013O00122O000400253O00122O000500266O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002008800013O0004CD3O008800012O00CB000200024O006C00035O00202O0003000300194O000400043O00202O0004000400214O00065O00202O0006000600194O0004000600024O000400046O000500016O00020005000200062O0002008800013O0004CD3O008800012O00CB000200013O00123A000300273O00123A000400284O000F000200044O004B00025O002E0E01290023000100290004CD3O00AB0001002EA4002A00AB0001002B0004CD3O00AB00012O00CB00027O00010300013O00122O0004002C3O00122O0005002D6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200AB00013O0004CD3O00AB00012O00CB000200024O001000035O00202O00030003002E4O000400043O00202O00040004002F00122O000600306O0004000600024O000400046O000500016O00020005000200062O000200A6000100010004CD3O00A60001002ECA003100A6000100320004CD3O00A60001002EDC003400AB000100330004CD3O00AB00012O00CB000200013O00123A000300353O00123A000400364O000F000200044O004B00025O00123A000100043O002628000100B0000100010004CD3O00B00001002EA400370004000100380004CD3O000400012O00CB00027O00010300013O00122O000400393O00122O0005003A6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002001F2O013O0004CD3O001F2O012O00CB000200043O0020F100020002003B4O00045O00202O00040004003C4O00020004000200062O0002001F2O013O0004CD3O001F2O012O00CB000200054O000D010300013O00122O0004003D3O00122O0005003E6O00030005000200062O000200CA000100030004CD3O00CA0001002EA4003F00DF000100400004CD3O00DF00012O00CB000200024O005D01035O00202O0003000300414O000400043O00202O00040004002F00122O000600306O0004000600024O000400046O00020004000200062O000200D9000100010004CD3O00D90001002E69004300D9000100420004CD3O00D90001002EA40044001F2O0100450004CD3O001F2O012O00CB000200013O001218000300463O00122O000400476O000200046O00025O00044O001F2O01002EA4004900062O0100480004CD3O00062O012O00CB000200054O0020000300013O00122O0004004A3O00122O0005004B6O00030005000200062O000200062O0100030004CD3O00062O012O00CB000200063O00205701020002004C2O00290102000200020006F50002001F2O013O0004CD3O001F2O012O00CB000200033O00205701020002004D2O00CB000400064O00060002000400020006F50002001F2O013O0004CD3O001F2O01002EA4004F001F2O01004E0004CD3O001F2O012O00CB000200024O0078000300073O00202O0003000300504O000400043O00202O00040004002F00122O000600306O0004000600024O000400046O00020004000200062O0002001F2O013O0004CD3O001F2O012O00CB000200013O001218000300513O00122O000400526O000200046O00025O00044O001F2O01002EA40054001F2O0100530004CD3O001F2O012O00CB000200054O0020000300013O00122O000400553O00122O000500566O00030005000200062O0002001F2O0100030004CD3O001F2O012O00CB000200024O0078000300073O00202O0003000300504O000400043O00202O00040004002F00122O000600306O0004000600024O000400046O00020004000200062O0002001F2O013O0004CD3O001F2O012O00CB000200013O00123A000300573O00123A000400584O000F000200044O004B00025O002EA4005A00332O0100590004CD3O00332O012O00CB000200083O00205701020002000A2O00290102000200020006F5000200332O013O0004CD3O00332O012O00CB000200093O0006F5000200332O013O0004CD3O00332O012O00CB000200024O00CB000300084O00290102000200020006F5000200332O013O0004CD3O00332O012O00CB000200013O00123A0003005B3O00123A0004005C4O000F000200044O004B00025O00123A000100073O0004CD3O00040001002E0E015D00040001005D0004CD3O00392O010026283O003B2O0100040004CD3O003B2O01002EDC005E00A22O01005F0004CD3O00A22O012O00CB00017O00010200013O00122O000300603O00122O000400616O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001005B2O013O0004CD3O005B2O01002EDC0063005B2O0100620004CD3O005B2O012O00CB000100024O003801025O00202O0002000200194O000300043O00202O0003000300214O00055O00202O0005000500194O0003000500024O000300036O000400016O00010004000200062O000100562O0100010004CD3O00562O01002EDC0065005B2O0100640004CD3O005B2O012O00CB000100013O00123A000200663O00123A000300674O000F000100034O004B00015O002EDC0068007D2O0100690004CD3O007D2O012O00CB00017O00010200013O00122O0003006A3O00122O0004006B6O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001007D2O013O0004CD3O007D2O012O00CB000100024O003801025O00202O00020002006C4O000300043O00202O0003000300214O00055O00202O00050005006C4O0003000500024O000300036O000400016O00010004000200062O000100782O0100010004CD3O00782O01002E69006D00782O01006E0004CD3O00782O01002E0E016F0007000100700004CD3O007D2O012O00CB000100013O00123A000200713O00123A000300724O000F000100034O004B00015O002E0E01730089000100730004CD3O00060201002EDC00740006020100750004CD3O000602012O00CB00017O00010200013O00122O000300763O00122O000400776O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001000602013O0004CD3O00060201002EDC00790006020100780004CD3O000602012O00CB000100024O003801025O00202O00020002007A4O000300043O00202O0003000300214O00055O00202O00050005007A4O0003000500024O000300036O000400016O00010004000200062O0001009C2O0100010004CD3O009C2O01002EDC007B00060201007C0004CD3O000602012O00CB000100013O0012180002007D3O00122O0003007E6O000100036O00015O00044O000602010026283O00A62O0100070004CD3O00A62O01002E0E017F005DFE2O00800004CD3O0001000100123A000100014O009C000200023O002679000100A82O0100010004CD3O00A82O0100123A000200013O000E49000400AF2O0100020004CD3O00AF2O0100123A3O00043O0004CD3O00010001000E49000100BE2O0100020004CD3O00BE2O012O00CB0003000B4O00640003000100022O00DA0003000A4O00CB0003000A3O000653010300BB2O0100010004CD3O00BB2O01002ECA008100BB2O0100820004CD3O00BB2O01002EDC008400BD2O0100830004CD3O00BD2O012O00CB0003000A4O005A010300023O00123A000200073O002EA4008500AB2O0100860004CD3O00AB2O01002EDC008800AB2O0100870004CD3O00AB2O01002679000200AB2O0100070004CD3O00AB2O012O00CB00036O0040010400013O00122O000500893O00122O0006008A6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300D02O0100010004CD3O00D02O01002EDC008C00E22O01008B0004CD3O00E22O012O00CB000300024O005D01045O00202O00040004008D4O000500043O00202O00050005002F00122O000700306O0005000700024O000500056O00030005000200062O000300DD2O0100010004CD3O00DD2O01002EA4008E00E22O01008F0004CD3O00E22O012O00CB000300013O00123A000400903O00123A000500914O000F000300054O004B00035O002EA400930001020100920004CD3O000102012O00CB00037O00010400013O00122O000500943O00122O000600956O0004000600024O00030003000400202O0003000300964O00030002000200062O0003000102013O0004CD3O00010201002EA400970001020100980004CD3O000102012O00CB000300024O004401045O00202O0004000400994O000500043O00202O0005000500214O00075O00202O0007000700994O0005000700024O000500056O00030005000200062O0003000102013O0004CD3O000102012O00CB000300013O00123A0004009A3O00123A0005009B4O000F000300054O004B00035O00123A000200043O0004CD3O00AB2O010004CD3O000100010004CD3O00A82O010004CD3O000100012O00013O00017O00D73O00028O00025O000DB140025O0012A640026O001040025O00749040025O0028AC40025O0012B340025O0080AE40030F3O000AA04D1CCFF53936BA483CC5E31A3103073O006E59C82C78A08203073O0049735265616479025O0046AD4003093O00436173744379636C65030F3O00536861646F77576F72644465617468030E3O0049735370652O6C496E52616E676503183O00536861646F77576F726444656174684D6F7573656F766572031B3O00B8CB4A424C5D045AA4D14F79474F3A59A3834D2O4F463E5FEB911F03083O002DCBA32B26232A5B030F3O00E18DDD2788BE63DD97D80782A840DA03073O0034B2E5BC43E7C903083O0049734D6F76696E67025O00FC9840025O0030AD40025O0062AE40025O009EB240025O005EA740025O0052B14003243O0032495100F84B1C364E4200C8582620555844FA5335244C550AE31C25284D5C01E51C717703073O004341213064973C025O0088A440025O0040A340030E3O00ECEFAFDCFCC8D0A1CAF7EFE6A7D603053O0093BF87CEB8030C3O00436173745461726765744966030E3O00536861646F77576F72645061696E2O033O008921A803073O00D2E448C6A1B833025O00FAA840025O006EA740025O00309A40025O00A09A40031A3O002541F2147CD9095EFC0277F12648FA1E33C83F45FF15618E641103063O00AE5629937013026O000840025O00C08D40025O00C05140025O00E49140025O00DEA540025O0056A240025O00707A4003093O00F7E279ECB8D7D3E07203063O00A7BA8B1788EB030A3O0049734361737461626C65025O00E49D40025O0085B340025O00A7B24003093O004D696E645370696B6503143O0017BC860925A6980411B0C80B13B9842O08F5D95503043O006D7AD5E8025O000AAA40025O0068AC40025O00F4AC40025O00B2A24003133O00E3FEAC34D1F1AE31F7B7A439E2FBA722AEA5F203043O00508E97C2025O00709B40025O003EAD40030B3O0030CE76480CD1545E02D57F03043O002C63A617025O004CA040025O00E09F4003073O005FF827303AB67103063O00C41C97495653025O00E07F40025O0032B140030B3O00536861646F77437261736803093O004973496E52616E6765026O00444003163O00E00B28148D4F2775E1023A18C25E117AFF063B50D00A03083O001693634970E2387803123O009D7BE7F894F840ECF188AA35C1E09FAB7AF003053O00EDD815829503063O0045786973747303093O0043616E412O7461636B025O00B49D40025O0058AE40025O0019B140025O0050734003113O00536861646F774372617368437572736F7203163O0091465E5BBFDE61815C5E4CB889588B42535AA2890CD003073O003EE22E2O3FD0A903093O00C40D15A00A1F3C51F703083O003E857935E37F6D4F025O004CA440025O0028A94003163O00031C33F1D9B99D130633E6DEEEA419183EF0C4EEF04203073O00C270745295B6CE025O00F07640025O00B2A640027O0040025O00849A40025O00D2A240026O00F03F030F3O0066EB4F8F57FC508E45DE558145FB5C03043O00E0228E3903063O0042752O665570030C3O00566F6964666F726D42752O66025O0062B340025O00B8AC40030F3O004465766F7572696E67506C61677565031A3O00DAA2D3D266E35400D998D5D172F6480B9EA1CCD17FF44F4E8FF103083O006EBEC7A5BD13913D025O0016AB40025O007AA940025O004AAE40025O0046A540025O00D49640025O000AA240030A3O00C8A115CD52E99B17C54E03053O003C8CC863A403103O004865616C746850657263656E74616765030C3O00446976696E65537461724850025O007AA340025O00AEA04003103O00446976696E6553746172506C61796572026O003840025O003C9040025O00C8984003103O0083FD122FAC82CB1732A395B40C23A38B03053O00C2E7946446025O0054A340025O00B3B14003043O006E4DCDAC03063O00A8262CA1C396030D3O00546172676574497356616C6964026O003E40031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503043O0048616C6F03093O0088FD8E7970E0B3178C03083O0076E09CE2165088D6026O00A340025O00A08E40025O003DB240025O00F07F4003083O00FB88F14DF9DA80E603053O00BFB6E19F2903143O004D696E64466C6179496E73616E69747942752O66025O007EB040025O00309D40025O00B49040025O0024A840025O0080594003123O00261B2651B481CE2A0B6853828BCE2E00680D03073O00A24B724835EBE703093O00A1354AE6540381395703063O0062EC5C248233025O00B9B240025O003AA240025O0039B040025O00C4974003093O004D696E6467616D657303133O00A91002BE42A9B835B7590AB349A4B022E4485C03083O0050C4796CDA25C8D5030F3O00337B037B4419BD0F61065B4E0F9E0803073O00EA6013621F2B6E03123O002F1157D4AF739B071D5EC2987D990B1A5CD303073O00EB667F32A7CC12030B3O004973417661696C61626C65025O00206F40025O00C05640025O003EB340025O00A094402O033O005DA8FB03063O004E30C1954324025O0004B240025O003C9C40031B3O002316811C4E27219717533421841D402416C01E483C12850A01614C03053O0021507EE078025O00A49B40025O00C88340025O0066B140025O00C09C40025O00949640030D3O0002270DD0FC262F03F4FA21250803053O0095544660A003153O00556E6675726C696E674461726B6E652O7342752O66025O0030A240025O00907740025O005EA940030D3O0056616D7069726963546F7563682O033O00350F2O03043O008D58666D025O0068A940025O00D0804003173O00A552C760132F5CC28C47C565193515C7BA5FC675087D0703083O00A1D333AA107A5D35030F3O00C8A6B32CF4B98527E9AA962DFA2OBA03043O00489BCED2025O002C9440025O00AAA740025O00908D40025O0042A140031A3O005572550A3C51454301214245500B32527214083A4A76511C731203053O0053261A346E025O00108B40025O0020B140025O00709540025O002AAF4003113O00751E29426B072E4D5D3E295559192E524103043O0026387747025O0080AD40025O00A89C4003113O004D696E645370696B65496E73616E697479031C3O00FEE656D21A45E3E653D31A5FFDFC59D82C42EAAF5EDF295AF6FD188003063O0036938F38B64500D3022O00123A3O00014O009C000100013O002EA400030002000100020004CD3O000200010026793O0002000100010004CD3O0002000100123A000100013O000EA00004000B000100010004CD3O000B0001002EDC00060085000100050004CD3O00850001002EA400080030000100070004CD3O003000012O00CB00027O00010300013O00122O000400093O00122O0005000A6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002003000013O0004CD3O00300001002E0E010C00190001000C0004CD3O003000012O00CB000200023O00201E01020002000D4O00035O00202O00030003000E4O000400036O000500046O000600053O00202O00060006000F4O00085O00202O00080008000E4O0006000800022O00FB000600064O0005010700086O000900063O00202O0009000900104O00020009000200062O0002003000013O0004CD3O003000012O00CB000200013O00123A000300113O00123A000400124O000F000200044O004B00026O00CB00027O00010300013O00122O000400133O00122O000500146O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002003F00013O0004CD3O003F00012O00CB000200073O0020570102000200152O002901020002000200065301020041000100010004CD3O00410001002E0E01160017000100170004CD3O00560001002EDC0018004F000100190004CD3O004F00012O00CB000200084O00F300035O00202O00030003000E4O000400053O00202O00040004000F4O00065O00202O00060006000E4O0004000600024O000400046O00020004000200062O00020051000100010004CD3O00510001002EDC001B00560001001A0004CD3O005600012O00CB000200013O00123A0003001C3O00123A0004001D4O000F000200044O004B00025O002EDC001F00D20201001E0004CD3O00D202012O00CB00027O00010300013O00122O000400203O00122O000500216O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200D202013O0004CD3O00D202012O00CB000200073O0020570102000200152O00290102000200020006F5000200D202013O0004CD3O00D202012O00CB000200023O00203E0102000200224O00035O00202O0003000300234O000400036O000500013O00122O000600243O00122O000700256O0005000700024O000600096O000700074O00CB000800053O0020A800080008000F4O000A5O00202O000A000A00234O0008000A00024O000800086O00020008000200062O0002007F000100010004CD3O007F0001002ECA0026007F000100270004CD3O007F0001002E0E01280055020100290004CD3O00D202012O00CB000200013O0012180003002A3O00122O0004002B6O000200046O00025O00044O00D20201002628000100890001002C0004CD3O00890001002EA4002D002F2O01002E0004CD3O002F2O01002EA4002F00AD000100300004CD3O00AD0001002EA4003200AD000100310004CD3O00AD00012O00CB00027O00010300013O00122O000400333O00122O000500346O0003000500024O00020002000300202O0002000200354O00020002000200062O000200AD00013O0004CD3O00AD0001002E0E01360016000100360004CD3O00AD0001002EA4003800AD000100370004CD3O00AD00012O00CB000200084O006C00035O00202O0003000300394O000400053O00202O00040004000F4O00065O00202O0006000600394O0004000600024O000400046O000500016O00020005000200062O000200AD00013O0004CD3O00AD00012O00CB000200013O00123A0003003A3O00123A0004003B4O000F000200044O004B00025O002EDC003C00C60001003D0004CD3O00C600012O00CB0002000A3O0020570102000200352O00290102000200020006F5000200C600013O0004CD3O00C60001002EA4003F00C60001003E0004CD3O00C600012O00CB000200084O002D0003000A6O000400053O00202O00040004000F4O0006000A6O0004000600024O000400046O000500016O00020005000200062O000200C600013O0004CD3O00C600012O00CB000200013O00123A000300403O00123A000400414O000F000200044O004B00025O002EDC004200D2000100430004CD3O00D200012O00CB00026O0040010300013O00122O000400443O00122O000500456O0003000500024O00020002000300202O0002000200354O00020002000200062O000200D4000100010004CD3O00D40001002EDC0046002E2O0100470004CD3O002E2O012O00CB0002000B4O000D010300013O00122O000400483O00122O000500496O00030005000200062O000200DD000100030004CD3O00DD0001002E0E014A00130001004B0004CD3O00EE00012O00CB000200084O007800035O00202O00030003004C4O000400053O00202O00040004004D00122O0006004E6O0004000600024O000400046O00020004000200062O0002002E2O013O0004CD3O002E2O012O00CB000200013O0012180003004F3O00122O000400506O000200046O00025O00044O002E2O012O00CB0002000B4O0020000300013O00122O000400513O00122O000500526O00030005000200062O000200152O0100030004CD3O00152O012O00CB0002000C3O0020570102000200532O00290102000200020006F500022O002O013O0004CD4O002O012O00CB000200073O0020570102000200542O00CB0004000C4O0006000200040002000653010200022O0100010004CD3O00022O01002EA40056002E2O0100550004CD3O002E2O01002EA40058002E2O0100570004CD3O002E2O012O00CB000200084O0078000300063O00202O0003000300594O000400053O00202O00040004004D00122O0006004E6O0004000600024O000400046O00020004000200062O0002002E2O013O0004CD3O002E2O012O00CB000200013O0012180003005A3O00122O0004005B6O000200046O00025O00044O002E2O012O00CB0002000B4O0020000300013O00122O0004005C3O00122O0005005D6O00030005000200062O0002002E2O0100030004CD3O002E2O01002EA4005E002E2O01005F0004CD3O002E2O012O00CB000200084O0078000300063O00202O0003000300594O000400053O00202O00040004004D00122O0006004E6O0004000600024O000400046O00020004000200062O0002002E2O013O0004CD3O002E2O012O00CB000200013O00123A000300603O00123A000400614O000F000200044O004B00025O00123A000100043O002EDC006200BD2O0100630004CD3O00BD2O01002679000100BD2O0100640004CD3O00BD2O0100123A000200013O002EDC0065005E2O0100660004CD3O005E2O010026790002005E2O0100670004CD3O005E2O012O00CB00037O00010400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300492O013O0004CD3O00492O012O00CB000300073O00204400030003006A4O00055O00202O00050005006B4O00030005000200062O0003004B2O0100010004CD3O004B2O01002EA4006C005C2O01006D0004CD3O005C2O012O00CB000300084O004401045O00202O00040004006E4O000500053O00202O00050005000F4O00075O00202O00070007006E4O0005000700024O000500056O00030005000200062O0003005C2O013O0004CD3O005C2O012O00CB000300013O00123A0004006F3O00123A000500704O000F000300054O004B00035O00123A0001002C3O0004CD3O00BD2O01002628000200642O0100010004CD3O00642O01002E69007100642O0100720004CD3O00642O01002EA4007300342O0100740004CD3O00342O01002EA4007500792O0100760004CD3O00792O012O00CB00037O00010400013O00122O000500773O00122O000600786O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300792O013O0004CD3O00792O012O00CB0003000D3O0020570103000300792O00290103000200020012040004007A3O0006D2000300792O0100040004CD3O00792O012O00CB0003000E3O0006530103007B2O0100010004CD3O007B2O01002EDC007B008D2O01007C0004CD3O008D2O012O00CB000300084O005D010400063O00202O00040004007D4O0005000D3O00202O00050005004D00122O0007007E6O0005000700024O000500056O00030005000200062O000300882O0100010004CD3O00882O01002EA40080008D2O01007F0004CD3O008D2O012O00CB000300013O00123A000400813O00123A000500824O000F000300054O004B00035O002EA4008300BB2O0100840004CD3O00BB2O012O00CB00037O00010400013O00122O000500853O00122O000600866O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300BB2O013O0004CD3O00BB2O012O00CB000300023O0020890003000300872O00640003000100020006F5000300BB2O013O0004CD3O00BB2O012O00CB000300053O00205701030003004D00123A000500884O00060003000500020006F5000300BB2O013O0004CD3O00BB2O012O00CB0003000F3O0006F5000300BB2O013O0004CD3O00BB2O012O00CB000300023O0020150003000300894O000400106O000500116O00030005000200062O000300BB2O013O0004CD3O00BB2O012O00CB000300084O008D00045O00202O00040004008A4O000500056O000600016O00030006000200062O000300BB2O013O0004CD3O00BB2O012O00CB000300013O00123A0004008B3O00123A0005008C4O000F000300054O004B00035O00123A000200673O0004CD3O00342O01002EDC008E00450201008D0004CD3O00450201002628000100C32O0100670004CD3O00C32O01002EDC008F0045020100900004CD3O004502012O00CB00027O00010300013O00122O000400913O00122O000500926O0003000500024O00020002000300202O0002000200354O00020002000200062O000200D42O013O0004CD3O00D42O012O00CB000200073O00204400020002006A4O00045O00202O0004000400934O00020004000200062O000200D62O0100010004CD3O00D62O01002EA4009400EC2O0100950004CD3O00EC2O01002E0E01960016000100960004CD3O00EC2O01002EA4009800EC2O0100970004CD3O00EC2O012O00CB000200084O006C00035O00202O0003000300394O000400053O00202O00040004000F4O00065O00202O0006000600394O0004000600024O000400046O000500016O00020005000200062O000200EC2O013O0004CD3O00EC2O012O00CB000200013O00123A000300993O00123A0004009A4O000F000200044O004B00026O00CB00026O0040010300013O00122O0004009B3O00122O0005009C6O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200F82O0100010004CD3O00F82O01002EDC009D000B0201009E0004CD3O000B0201002EDC00A0000B0201009F0004CD3O000B02012O00CB000200084O001100035O00202O0003000300A14O000400053O00202O00040004004D00122O0006004E6O0004000600024O000400046O000500016O00020005000200062O0002000B02013O0004CD3O000B02012O00CB000200013O00123A000300A23O00123A000400A34O000F000200044O004B00026O00CB00027O00010300013O00122O000400A43O00122O000500A56O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002002202013O0004CD3O002202012O00CB00027O00010300013O00122O000400A63O00122O000500A76O0003000500024O00020002000300202O0002000200A84O00020002000200062O0002002202013O0004CD3O002202012O00CB000200123O00065301020026020100010004CD3O00260201002E6900A90026020100AA0004CD3O00260201002EDC00AB0044020100AC0004CD3O004402012O00CB000200023O00203E0102000200224O00035O00202O00030003000E4O000400036O000500013O00122O000600AD3O00122O000700AE6O0005000700024O000600136O000700074O00CB000800053O00201B00080008000F4O000A5O00202O000A000A000E4O0008000A00024O000800086O0009000A6O000B00063O00202O000B000B00104O0002000B000200062O0002003F020100010004CD3O003F0201002E0E01AF0007000100B00004CD3O004402012O00CB000200013O00123A000300B13O00123A000400B24O000F000200044O004B00025O00123A000100643O002E0E01B300C2FD2O00B30004CD3O0007000100267900010007000100010004CD3O0007000100123A000200013O002EA400B4004E020100B50004CD3O004E020100262800020050020100010004CD3O00500201002EA400B600A8020100B70004CD3O00A802012O00CB00037O00010400013O00122O000500B83O00122O000600B96O0004000600024O00030003000400202O0003000300354O00030002000200062O0003006102013O0004CD3O006102012O00CB000300073O00204400030003006A4O00055O00202O0005000500BA4O00030005000200062O00030063020100010004CD3O00630201002EDC00BB0082020100BC0004CD3O00820201002E0E01BD0018000100BD0004CD3O007B02012O00CB000300023O00203E0103000300224O00045O00202O0004000400BE4O000500036O000600013O00122O000700BF3O00122O000800C06O0006000800024O000700146O000800084O00CB000900053O00202C00090009000F4O000B5O00202O000B000B00BE4O0009000B00024O000900096O000A000C6O000D00016O0003000D000200062O0003007D020100010004CD3O007D0201002EA400C10082020100C20004CD3O008202012O00CB000300013O00123A000400C33O00123A000500C44O000F000300054O004B00036O00CB00036O0040010400013O00122O000500C53O00122O000600C66O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003008E020100010004CD3O008E0201002EDC00C800A7020100C70004CD3O00A702012O00CB000300023O00200C00030003000D4O00045O00202O00040004000E4O000500036O000600156O000700053O00202O00070007000F4O00095O00202O00090009000E4O0007000900024O000700076O000800096O000A00063O00202O000A000A00104O0003000A000200062O000300A2020100010004CD3O00A20201002E0E01C90007000100CA0004CD3O00A702012O00CB000300013O00123A000400CB3O00123A000500CC4O000F000300054O004B00035O00123A000200673O002628000200AC020100670004CD3O00AC0201002EDC00CE004A020100CD0004CD3O004A0201002EDC00CF00CC020100D00004CD3O00CC02012O00CB00037O00010400013O00122O000500D13O00122O000600D26O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300CC02013O0004CD3O00CC0201002EA400D400CC020100D30004CD3O00CC02012O00CB000300084O006C00045O00202O0004000400D54O000500053O00202O00050005000F4O00075O00202O0007000700D54O0005000700024O000500056O000600016O00030006000200062O000300CC02013O0004CD3O00CC02012O00CB000300013O00123A000400D63O00123A000500D74O000F000300054O004B00035O00123A000100673O0004CD3O000700010004CD3O004A02010004CD3O000700010004CD3O00D202010004CD3O000200012O00013O00017O00743O00028O00025O00109440025O002EAF40026O000840025O0060A740025O00689540025O00D1B240025O005BB040025O00D2A940025O00A08840025O00E2AF40025O0046A240026O003D40025O000C9140025O008CAD40025O0016AE40025O009C9F40025O0006AD40025O00288540025O00B49240025O007AAB40025O0026AE4003093O007D099F0E27031EA45F03083O00CB3B60ED6B456F71030A3O0049734361737461626C6503063O0042752O66557003113O00506F776572496E667573696F6E42752O66026O002040025O00DCAE4003093O0046697265626C2O6F64025O0008A140025O00EAA940030F3O00221FBEE433FCD82B12ECE235E3977003073O00B74476CC815190030A3O002CA862F70E9005A47EE303063O00E26ECD10846B026O002840025O0034A840025O00509240025O00F0B240025O00A06140030A3O004265727365726B696E6703103O00E9C6F2CA44F9C8E9D746ABC0E4CA01BD03053O00218BA380B9026O00F03F025O0078B040025O00708940025O00A4AB40025O003EAE40025O000EAF40025O00CCB140025O00C4AD40025O00B8A840025O00FAA340025O0052A440025O00789C40025O00488E4003093O0075540BD1537E11CC4E03043O00BE373864026O002E40025O00709B40025O00549440025O0070AD40025O001CA240025O00E8904003093O00426C2O6F644675727903103O0054A3331117DCF543BD255E10E7E016F703073O009336CF5C7E7383030D3O002C3F36781E6A1F30395E0C720103063O001E6D51551D6D025O002CA140025O00249340030D3O00416E6365737472616C43612O6C03153O00FE7F57B325CAEEFE7D6BB537D2F0BF7250A5768FAC03073O009C9F1134D656BE027O0040025O00AAA940025O00F2AA40025O0042A840025O00688040025O00149540030C3O0098E0B4B88BFDA8ACBAE62OB203043O00DCCE8FDD030C3O00432O6F6C646F776E446F776E030F3O00432O6F6C646F776E52656D61696E73026O001040030A3O00AB742313DAC9DC82783F03073O00B2E61D4D77B8AC030B3O004973417661696C61626C6503123O00DCB00F0874F9E5BF081772CCFAAC071E79EC03063O009895DE6A7B1703093O00F02FF84797D127E55703053O00D5BD46962303073O0043686172676573030A3O00436F6D62617454696D65030C3O00566F69644572757074696F6E025O003AB04003143O00595A7D0C7050661D5F417D074115770C5C15255C03043O00682F3514025O00EEA240030D3O00874D93179D1CA0498F0FB500AD03063O006FC32CE17CDC03093O00497343617374696E67030D3O004461726B417363656E73696F6E030A3O00F54F0E77A9AED642056103063O00CBB8266013CB03123O00107D7C52CD38637843C23C477653C33C7D6D03053O00AE59131921025O0068B240025O00CAAD4003153O002B134045C886182C175C5DFE88056F11565DB7D65D03073O006B4F72322E97E7025O00DC9A40025O001AA940025O00206340025O001EA040009D012O00123A3O00014O009C000100013O0026283O0006000100010004CD3O00060001002EA400030002000100020004CD3O0002000100123A000100013O0026280001000B000100040004CD3O000B0001002EA40005002C000100060004CD3O002C0001002E0E010700912O0100070004CD3O009C2O012O00CB00025O00065301020012000100010004CD3O00120001002EA40008009C2O0100090004CD3O009C2O0100123A000200014O009C000300033O002EDC000A00140001000B0004CD3O0014000100267900020014000100010004CD3O0014000100123A000300013O002EDC000D00190001000C0004CD3O0019000100267900030019000100010004CD3O001900012O00CB000400024O00640004000100022O00DA000400013O002E0E010E007C2O01000E0004CD3O009C2O012O00CB000400013O0006F50004009C2O013O0004CD3O009C2O012O00CB000400014O005A010400023O0004CD3O009C2O010004CD3O001900010004CD3O009C2O010004CD3O001400010004CD3O009C2O01002EDC000F0093000100100004CD3O0093000100267900010093000100010004CD3O0093000100123A000200013O002EDC0011008A000100120004CD3O008A00010026790002008A000100010004CD3O008A000100123A000300013O002EA400130083000100140004CD3O0083000100267900030083000100010004CD3O00830001002EDC0015005F000100160004CD3O005F00012O00CB000400035O00010500043O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400194O00040002000200062O0004005F00013O0004CD3O005F00012O00CB000400053O00204400040004001A4O000600033O00202O00060006001B4O00040006000200062O00040050000100010004CD3O005000012O00CB000400063O0026BA0004005F0001001C0004CD3O005F0001002E0E011D00080001001D0004CD3O005800012O00CB000400074O00CB000500033O00208900050005001E2O00290104000200020006530104005A000100010004CD3O005A0001002E0E011F0007000100200004CD3O005F00012O00CB000400043O00123A000500213O00123A000600224O000F000400064O004B00046O00CB000400035O00010500043O00122O000600233O00122O000700246O0005000700024O00040004000500202O0004000400194O00040002000200062O0004007300013O0004CD3O007300012O00CB000400053O00204400040004001A4O000600033O00202O00060006001B4O00040006000200062O00040075000100010004CD3O007500012O00CB000400063O00266E00040075000100250004CD3O00750001002EA400260082000100270004CD3O00820001002EA400290082000100280004CD3O008200012O00CB000400074O00CB000500033O00208900050005002A2O00290104000200020006F50004008200013O0004CD3O008200012O00CB000400043O00123A0005002B3O00123A0006002C4O000F000400064O004B00045O00123A0003002D3O002EA4002F00360001002E0004CD3O00360001002679000300360001002D0004CD3O0036000100123A0002002D3O0004CD3O008A00010004CD3O00360001002EDC0030008E000100310004CD3O008E0001002628000200900001002D0004CD3O00900001002E0E013200A3FF2O00330004CD3O0031000100123A0001002D3O0004CD3O009300010004CD3O00310001002EDC003500F0000100340004CD3O00F00001002679000100F00001002D0004CD3O00F0000100123A000200014O009C000300033O002EA400360099000100370004CD3O0099000100267900020099000100010004CD3O0099000100123A000300013O002628000300A2000100010004CD3O00A20001002EDC003800E9000100390004CD3O00E900012O00CB000400035O00010500043O00122O0006003A3O00122O0007003B6O0005000700024O00040004000500202O0004000400194O00040002000200062O000400B600013O0004CD3O00B600012O00CB000400053O00204400040004001A4O000600033O00202O00060006001B4O00040006000200062O000400B8000100010004CD3O00B800012O00CB000400063O00266E000400B80001003C0004CD3O00B80001002EDC003D00C70001003E0004CD3O00C70001002E0E013F000F0001003F0004CD3O00C70001002EDC004100C7000100400004CD3O00C700012O00CB000400074O00CB000500033O0020890005000500422O00290104000200020006F5000400C700013O0004CD3O00C700012O00CB000400043O00123A000500433O00123A000600444O000F000400064O004B00046O00CB000400035O00010500043O00122O000600453O00122O000700466O0005000700024O00040004000500202O0004000400194O00040002000200062O000400E800013O0004CD3O00E800012O00CB000400053O00204400040004001A4O000600033O00202O00060006001B4O00040006000200062O000400DB000100010004CD3O00DB00012O00CB000400063O0026BA000400E80001003C0004CD3O00E80001002EA4004800E8000100470004CD3O00E800012O00CB000400074O00CB000500033O0020890005000500492O00290104000200020006F5000400E800013O0004CD3O00E800012O00CB000400043O00123A0005004A3O00123A0006004B4O000F000400064O004B00045O00123A0003002D3O0026790003009E0001002D0004CD3O009E000100123A0001004C3O0004CD3O00F000010004CD3O009E00010004CD3O00F000010004CD3O00990001002628000100F40001004C0004CD3O00F40001002EA4004E00070001004D0004CD3O0007000100123A000200014O009C000300033O002E0E014F3O0001004F0004CD3O00F60001000EA0000100FC000100020004CD3O00FC0001002EDC005100F6000100500004CD3O00F6000100123A000300013O0026790003008E2O0100010004CD3O008E2O012O00CB000400035O00010500043O00122O000600523O00122O000700536O0005000700024O00040004000500202O0004000400194O00040002000200062O000400492O013O0004CD3O00492O012O00CB000400083O0020570104000400542O00290104000200020006F5000400492O013O0004CD3O00492O012O00CB000400093O0006F5000400162O013O0004CD3O00162O012O00CB000400083O0020570104000400552O0029010400020002000E520156002D2O0100040004CD3O002D2O012O00CB000400035O00010500043O00122O000600573O00122O000700586O0005000700024O00040004000500202O0004000400594O00040002000200062O0004002D2O013O0004CD3O002D2O012O00CB0004000A3O000E2A004C00492O0100040004CD3O00492O012O00CB000400034O0040010500043O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400594O00040002000200062O000400492O0100010004CD3O00492O012O00CB000400034O0062000500043O00122O0006005C3O00122O0007005D6O0005000700024O00040004000500205701040004005E2O00290104000200020026280004003C2O0100010004CD3O003C2O012O00CB0004000B3O00208900040004005F2O0064000400010002000E2A003C00492O0100040004CD3O00492O012O00CB000400074O00CB000500033O0020890005000500602O0029010400020002000653010400442O0100010004CD3O00442O01002EA4006100492O0100340004CD3O00492O012O00CB000400043O00123A000500623O00123A000600634O000F000400064O004B00045O002E0E01640044000100640004CD3O008D2O012O00CB000400035O00010500043O00122O000600653O00122O000700666O0005000700024O00040004000500202O0004000400194O00040002000200062O0004008D2O013O0004CD3O008D2O012O00CB000400053O0020440004000400674O000600033O00202O0006000600684O00040006000200062O0004008D2O0100010004CD3O008D2O012O00CB000400093O0006F5000400642O013O0004CD3O00642O012O00CB000400083O0020570104000400552O0029010400020002000E52015600802O0100040004CD3O00802O012O00CB000400034O0040010500043O00122O000600693O00122O0007006A6O0005000700024O00040004000500202O0004000400594O00040002000200062O000400732O0100010004CD3O00732O012O00CB000400083O0020570104000400542O0029010400020002000653010400802O0100010004CD3O00802O012O00CB0004000A3O000E2A004C008D2O0100040004CD3O008D2O012O00CB000400034O0040010500043O00122O0006006B3O00122O0007006C6O0005000700024O00040004000500202O0004000400594O00040002000200062O0004008D2O0100010004CD3O008D2O01002EA4006E008D2O01006D0004CD3O008D2O012O00CB000400074O00CB000500033O0020890005000500682O00290104000200020006F50004008D2O013O0004CD3O008D2O012O00CB000400043O00123A0005006F3O00123A000600704O000F000400064O004B00045O00123A0003002D3O002EA4007100FD000100720004CD3O00FD0001002628000300942O01002D0004CD3O00942O01002E0E0173006BFF2O00740004CD3O00FD000100123A000100043O0004CD3O000700010004CD3O00FD00010004CD3O000700010004CD3O00F600010004CD3O000700010004CD3O009C2O010004CD3O000200012O00013O00017O00FF3O00028O00025O0030A440025O005EA940026O00F03F025O006C9B40025O00A88540025O0078A740025O007CA640025O002OAA40026O001040025O00EFB140025O00E8A740025O00B8A940025O00EC9640025O00689540026O00834003093O008401D0851DA509CD9503053O005FC968BEE1030A3O0049734361737461626C6503083O0042752O66446F776E03103O004D696E644465766F7572657242752O66030C3O0099C4C8CA8AD9D4DEBBC2CEC003043O00AECFABA1030A3O00432O6F6C646F776E5570030C3O00DBF104F7DDC5F8EE19FAF7D903063O00B78D9E6D9398030B3O004973417661696C61626C6503093O004D696E64426C617374030E3O0049735370652O6C496E52616E6765025O00A3B140025O00B4B24003123O002100E808130BEA0D3F1DA6012D00E84C7E5F03043O006C4C6986030B3O00DDCAB8E5FAE4D7A3E4C0FF03053O00AE8BA5D181025O007AA840025O00389A4003093O00436173744379636C65030B3O00566F6964546F2O72656E7403143O00566F6964546F2O72656E744D6F7573656F76657203143O00B5BCEBC5F9177F6AB1B6ECD5860E2O71ADF3B09903083O0018C3D382A1A66310025O0071B240025O00389440025O0044A840025O0072A840025O003EA540025O00207540026O001440025O00804740025O00489440026O000840025O0094A140025O0012B040030D3O0032EEA9D338480DEC90CC24590C03063O003A648FC4A351025O00AEA140025O00F0B040030C3O00436173745461726765744966030D3O0056616D7069726963546F7563682O033O00174B2D03083O006E7A2243C35F298503163O0063B0565ADF67B85875C27AA458429678B052449624E303053O00B615D13B2A025O00607040025O0061B04003113O009A5ECB1912AEBE5CC0342FADB659CC093803063O00DED737A57D4103073O004973526561647903093O0001D8C81ED0CDEC593803083O002A4CB1A67A92A18D03103O0046752O6C526563686172676554696D652O033O00474344030B3O008C8E0AC25670869E0DDB7703063O0016C5EA65AE19030B3O001B3BACD842A0C594283AB103083O00E64D54C5BC16CFB7030C3O00432O6F6C646F776E446F776E030B3O00CF1BCFF8B8AEE227FC1AD203083O00559974A69CECC19003113O004D696E645370696B65496E73616E69747903093O004973496E52616E6765026O004440025O00109240025O00107840031B3O00A9E943B7DB13B4E946B6DB09AAF34CBDED14BDA040B2ED0EE4B21F03063O0060C4802DD384025O0020A740025O00C08A40025O009C9B40025O000CB040025O0078A840025O0042AD4003063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O6603093O001884755BF0A3B5CB2103083O00B855ED1B3FB2CFD4030B3O00215D0653275F2A4B004C0703043O003F683969030B3O003D88AD403F88B6560E89B003043O00246BE7C4030B3O006BBAAB8369BAB09558BBB603043O00E73DD5C2025O00FAB240025O004EB34003113O0004A4337736AB317210ED307200A37D215D03043O001369CD5D025O00C49940025O0018A440025O00B09540025O0048B140025O0020A940025O00BAAE40026O007A4003083O0002BF2AE216BF2FF203043O008654D04303083O00566F6964426F6C74025O00806F40025O00B8874003103O0005A38F582CAE895007EC8B5D1AA2C60A03043O003C73CCE6027O0040025O00488740025O00EAA34003093O00294C4A2EEB0844573E03053O00A96425244A03123O002989A7430386B251028BA7640F95AF550E9303043O003060E7C203093O00E55300293BD4AE90DC03083O00E3A83A6E4D79B8CF030B3O004578656375746554696D65026O001C40025O00709840025O006CAC4003123O004D696E64426C6173744D6F7573656F76657203113O007635B1448ED97DA46828FF4DB0D27FE52F03083O00C51B5CDF20D1BB11025O0074A540025O00EDB240030F3O003057C2FF0C482OF4115BE7FE024BCB03043O009B633FA3025O00AEA240025O003EA440025O0014A340025O00CCAF40030F3O00536861646F77576F7264446561746803183O00536861646F77576F726444656174684D6F7573656F76657203183O0091D9A089B693BDC6AE9FBDBB86D4A099B1C48FD0A883F9D103063O00E4E2B1C1EDD9025O00AC9240025O009C9440025O00ACAA40025O0096A140030F3O00C33FFD7FF228E27EE00AE771E02FEE03043O0010875A8B03153O007071103C5B46715A73363F4F536D515003315B527E03073O0018341466532E34030C3O00426173654475726174696F6E026O00AF40025O00F09040025O0008A640026O006C40030F3O004465766F7572696E67506C61677565025O0029B040025O003C9C4003163O00C02A372B1AD6262F2330D42320231AC16F2C2506CA6F03053O006FA44F4144030F3O00E2DC95D13BF8CFD784EE22EBC1CC8603063O008AA6B9E3BE4E030F3O00496E73616E69747944656669636974026O003440030C3O00566F6964666F726D42752O6603083O00FD7BCC33702C15DF03073O0079AB14A5573243030F3O00432O6F6C646F776E52656D61696E73030B3O0042752O6652656D61696E7303083O00F037B0329B0DCA2C03063O0062A658D956D9030B3O00504D756C7469706C696572026O33F33F025O00B07B40025O00D0964003183O004465766F7572696E67506C616775654D6F7573656F766572025O0026A540025O00E06F40025O005EAD40025O00C4904003173O00F2F36F0E93CEFFF87E3E96D0F7F16C04C6D1F7FF7741DE03063O00BC2O961961E6025O001CAF40025O00F4B240025O0041B240030B3O00E9815E0603FAF99B5E110403063O008DBAE93F626C03113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66025O00DEA640025O00B6A74003073O00D2E522B02CE3E703053O0045918A4CD6025O0024AE40025O00C09B40025O0053B140025O00A49E40030B3O00536861646F77437261736803143O0063C7888DB0014FCC9B88AC1E30C28880B156219F03063O007610AF2OE9DF025O0054AA40025O0072A94003123O00AE8A30B6F7CB48858030A9AEA86899973AA903073O001DEBE455DB8EEB025O00FAA240025O003C924003063O0045786973747303093O0043616E412O7461636B025O00B8AE40025O00E88D4003113O00536861646F774372617368437572736F7203143O002EDCBBD9785918512FD5A9D53743265B3394EB8D03083O00325DB4DABD172E4703093O00FFB01B6F51CE5BD1B603073O0028BEC43B2C24BC025O0020844003143O002F4DDDB0F56A323F57DDA7F23D003D4CD2F4AB2D03073O006D5C25BCD49A1D025O00A3B240026O003E4003093O0054696D65546F446965026O002E40030D3O001D2OA722AB2AB4C537B5BC268403083O00A059C6D549EA59D7030D3O006C70A6F5E45B72B1F0D6417EBA03053O00A52811D49E025O0058AB40025O00B88340025O00309240025O001C914003113O00E8D0063724E0D70C3634A5D4093A28A58B03053O004685B96853025O00C89C40025O00E8AE40025O0096A040025O00689740025O00EC9E40025O00109E40025O00408A40025O00FCB040025O00F07F40025O002FB240025O002EAB40025O0094A240025O002AA040025O00FAB040025O00E7B140025O0093B14000C7032O00123A3O00014O009C000100023O0026283O0006000100010004CD3O00060001002E0E01020005000100030004CD3O0009000100123A000100014O009C000200023O00123A3O00043O000EA00004000F00013O0004CD3O000F0001002ECA0005000F000100060004CD3O000F0001002EA400070002000100080004CD3O00020001002E0E01093O000100090004CD3O000F00010026790001000F000100010004CD3O000F000100123A000200013O002628000200180001000A0004CD3O00180001002EA4000B00990001000C0004CD3O0099000100123A000300013O0026280003001D000100010004CD3O001D0001002EDC000D008D0001000E0004CD3O008D000100123A000400013O00262800040022000100010004CD3O00220001002E0E010F0066000100100004CD3O008600012O00CB00057O00010600013O00122O000700113O00122O000800126O0006000800024O00050005000600202O0005000500134O00050002000200062O0005005E00013O0004CD3O005E00012O00CB000500023O0006F50005005E00013O0004CD3O005E00012O00CB000500033O0020440005000500144O00075O00202O0007000700154O00050007000200062O0005004A000100010004CD3O004A00012O00CB00057O00010600013O00122O000700163O00122O000800176O0006000800024O00050005000600202O0005000500184O00050002000200062O0005005E00013O0004CD3O005E00012O00CB00057O00010600013O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005005E00013O0004CD3O005E00012O00CB000500044O003801065O00202O00060006001C4O000700053O00202O00070007001D4O00095O00202O00090009001C4O0007000900024O000700076O000800016O00050008000200062O00050059000100010004CD3O00590001002E0E011E00070001001F0004CD3O005E00012O00CB000500013O00123A000600203O00123A000700214O000F000500074O004B00056O00CB00057O00010600013O00122O000700223O00122O000800236O0006000800024O00050005000600202O0005000500134O00050002000200062O0005008500013O0004CD3O008500012O00CB000500063O00065301050085000100010004CD3O00850001002EA400250085000100240004CD3O008500012O00CB000500073O0020EB0005000500264O00065O00202O0006000600274O000700086O000800096O000900053O00202O00090009001D4O000B5O00202O000B000B00274O0009000B00024O000900096O000A000B6O000C000A3O00202O000C000C00284O000D00016O0005000D000200062O0005008500013O0004CD3O008500012O00CB000500013O00123A000600293O00123A0007002A4O000F000500074O004B00055O00123A000400043O002EDC002C001E0001002B0004CD3O001E00010026790004001E000100040004CD3O001E000100123A000300043O0004CD3O008D00010004CD3O001E0001002EA4002D00190001002E0004CD3O0019000100262800030093000100040004CD3O00930001002E0E012F0088FF2O00300004CD3O001900012O00CB0004000C4O00640004000100022O00DA0004000B3O00123A000200313O0004CD3O009900010004CD3O00190001002EDC003200762O0100330004CD3O00762O01002679000200762O0100340004CD3O00762O0100123A000300013O000E49000100202O0100030004CD3O00202O0100123A000400013O002EA4003500192O0100360004CD3O00192O01000E49000100192O0100040004CD3O00192O012O00CB00057O00010600013O00122O000700373O00122O000800386O0006000800024O00050005000600202O0005000500134O00050002000200062O000500CA00013O0004CD3O00CA0001002EA4003900CA0001003A0004CD3O00CA00012O00CB000500073O0020D900050005003B4O00065O00202O00060006003C4O000700086O000800013O00122O0009003D3O00122O000A003E6O0008000A00024O0009000D6O000A000E4O00CB000B00053O002038000B000B001D4O000D5O00202O000D000D003C4O000B000D00024O000B000B6O0005000B000200062O000500CA00013O0004CD3O00CA00012O00CB000500013O00123A0006003F3O00123A000700404O000F000500074O004B00055O002EDC004100182O0100420004CD3O00182O012O00CB00057O00010600013O00122O000700433O00122O000800446O0006000800024O00050005000600202O0005000500454O00050002000200062O000500182O013O0004CD3O00182O012O00CB000500023O0006F5000500182O013O0004CD3O00182O012O00CB00056O0062000600013O00122O000700463O00122O000800476O0006000800024O0005000500060020BD0005000500484O0005000200024O000600033O00202O0006000600494O00060002000200202O00060006003400062O000600182O0100050004CD3O00182O012O00CB00057O00010600013O00122O0007004A3O00122O0008004B6O0006000800024O00050005000600202O00050005001B4O00050002000200062O000500182O013O0004CD3O00182O012O00CB00056O0040010600013O00122O0007004C3O00122O0008004D6O0006000800024O00050005000600202O00050005004E4O00050002000200062O000500052O0100010004CD3O00052O012O00CB00056O0040010600013O00122O0007004F3O00122O000800506O0006000800024O00050005000600202O00050005001B4O00050002000200062O000500182O0100010004CD3O00182O012O00CB000500044O001000065O00202O0006000600514O000700053O00202O00070007005200122O000900536O0007000900024O000700076O000800016O00050008000200062O000500132O0100010004CD3O00132O01002EA4005400182O0100550004CD3O00182O012O00CB000500013O00123A000600563O00123A000700574O000F000500074O004B00055O00123A000400043O002EDC005900A1000100580004CD3O00A10001002679000400A1000100040004CD3O00A1000100123A000300043O0004CD3O00202O010004CD3O00A10001002628000300242O0100040004CD3O00242O01002EDC005B009E0001005A0004CD3O009E0001002EDC005C00732O01005D0004CD3O00732O012O00CB0004000F3O0020570104000400132O00290104000200020006F5000400732O013O0004CD3O00732O012O00CB000400033O0020F100040004005E4O00065O00202O00060006005F4O00040006000200062O000400732O013O0004CD3O00732O012O00CB000400023O0006F5000400732O013O0004CD3O00732O012O00CB00046O0062000500013O00122O000600603O00122O000700616O0005000700024O0004000400050020BD0004000400484O0004000200024O000500033O00202O0005000500494O00050002000200202O00050005003400062O000500732O0100040004CD3O00732O012O00CB00047O00010500013O00122O000600623O00122O000700636O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400732O013O0004CD3O00732O012O00CB00046O0040010500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O00040004004E4O00040002000200062O000400612O0100010004CD3O00612O012O00CB00046O0040010500013O00122O000600663O00122O000700676O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400732O0100010004CD3O00732O012O00CB000400044O00970005000F6O000600053O00202O00060006001D4O0008000F6O0006000800024O000600066O000700016O00040007000200062O0004006E2O0100010004CD3O006E2O01002E0E01680007000100690004CD3O00732O012O00CB000400013O00123A0005006A3O00123A0006006B4O000F000400064O004B00045O00123A0002000A3O0004CD3O00762O010004CD3O009E0001002EA4006C00100201006D0004CD3O0010020100267900020010020100040004CD3O0010020100123A000300013O002E0E016E00290001006E0004CD3O00A42O01002628000300812O0100040004CD3O00812O01002EA4006F00A42O0100700004CD3O00A42O01002EDC007200A22O0100710004CD3O00A22O012O00CB00047O00010500013O00122O000600733O00122O000700746O0005000700024O00040004000500202O0004000400134O00040002000200062O000400A22O013O0004CD3O00A22O012O00CB000400023O0006F5000400A22O013O0004CD3O00A22O012O00CB000400044O005D01055O00202O0005000500754O000600053O00202O00060006005200122O000800536O0006000800024O000600066O00040006000200062O0004009D2O0100010004CD3O009D2O01002EDC007700A22O0100760004CD3O00A22O012O00CB000400013O00123A000500783O00123A000600794O000F000400064O004B00045O00123A0002007A3O0004CD3O001002010026790003007B2O0100010004CD3O007B2O01002EA4007B00E72O01007C0004CD3O00E72O012O00CB00047O00010500013O00122O0006007D3O00122O0007007E6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400CD2O013O0004CD3O00CD2O012O00CB000400103O0006F5000400CD2O013O0004CD3O00CD2O012O00CB00047O00010500013O00122O0006007F3O00122O000700806O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400CD2O013O0004CD3O00CD2O012O00CB000400114O00CE00058O000600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O0005000500834O00050002000200062O000500CD2O0100040004CD3O00CD2O012O00CB000400123O00266E000400CF2O0100840004CD3O00CF2O01002EDC008600E72O0100850004CD3O00E72O012O00CB000400073O0020EB0004000400264O00055O00202O00050005001C4O000600086O000700136O000800053O00202O00080008001D4O000A5O00202O000A000A001C4O0008000A00024O000800086O0009000A6O000B000A3O00202O000B000B00874O000C00016O0004000C000200062O000400E72O013O0004CD3O00E72O012O00CB000400013O00123A000500883O00123A000600894O000F000400064O004B00045O002EA4008A000E0201008B0004CD3O000E02012O00CB00047O00010500013O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O0004000400454O00040002000200062O0004000E02013O0004CD3O000E0201002EDC008E000E0201008F0004CD3O000E0201002EDC0090000E020100910004CD3O000E02012O00CB000400073O00201E0104000400264O00055O00202O0005000500924O000600086O000700146O000800053O00202O00080008001D4O000A5O00202O000A000A00924O0008000A00022O00FB000800084O00050109000A6O000B000A3O00202O000B000B00934O0004000B000200062O0004000E02013O0004CD3O000E02012O00CB000400013O00123A000500943O00123A000600954O000F000400064O004B00045O00123A000300043O0004CD3O007B2O01002628000200140201007A0004CD3O00140201002EA40097002F030100960004CD3O002F030100123A000300013O002EDC009900B2020100980004CD3O00B20201002679000300B2020100010004CD3O00B202012O00CB00047O00010500013O00122O0006009A3O00122O0007009B6O0005000700024O00040004000500202O0004000400454O00040002000200062O0004002F02013O0004CD3O002F02012O00CB000400154O00CB00056O0062000600013O00122O0007009C3O00122O0008009D6O0006000800024O00050005000600205701050005009E2O002901050002000200209100050005000A00064700040003000100050004CD3O00310201002EA4009F0046020100A00004CD3O00460201002EDC00A20046020100A10004CD3O004602012O00CB000400044O00F300055O00202O0005000500A34O000600053O00202O00060006001D4O00085O00202O0008000800A34O0006000800024O000600066O00040006000200062O00040041020100010004CD3O00410201002EDC00A40046020100A50004CD3O004602012O00CB000400013O00123A000500A63O00123A000600A74O000F000400064O004B00046O00CB00047O00010500013O00122O000600A83O00122O000700A96O0005000700024O00040004000500202O0004000400454O00040002000200062O0004009402013O0004CD3O009402012O00CB000400033O0020570104000400AA2O002901040002000200266E00040096020100AB0004CD3O009602012O00CB000400033O0020F100040004005E4O00065O00202O0006000600AC4O00040006000200062O0004008602013O0004CD3O008602012O00CB00046O0062000500013O00122O000600AD3O00122O000700AE6O0005000700024O00040004000500200F0104000400AF4O0004000200024O000500033O00202O0005000500B04O00075O00202O0007000700AC4O00050007000200062O00050086020100040004CD3O008602012O00CB00046O00A1000500013O00122O000600B13O00122O000700B26O0005000700024O00040004000500202O0004000400AF4O0004000200024O000500166O000600033O00202O0006000600B04O00085O00202O0008000800AC4O00060008000200122O0007007A6O0005000700024O000600176O000700033O00202O0007000700B04O00095O00202O0009000900AC4O00070009000200122O0008007A6O0006000800024O00050005000600062O00040011000100050004CD3O009602012O00CB000400033O0020F100040004005E4O00065O00202O0006000600154O00040006000200062O0004009402013O0004CD3O009402012O00CB000400033O0020450104000400B34O00065O00202O0006000600A34O00040006000200262O00040096020100B40004CD3O00960201002EA400B600B1020100B50004CD3O00B102012O00CB000400073O00200C0004000400264O00055O00202O0005000500A34O000600086O000700186O000800053O00202O00080008001D4O000A5O00202O000A000A00A34O0008000A00024O000800086O0009000A6O000B000A3O00202O000B000B00B74O0004000B000200062O000400AC020100010004CD3O00AC0201002E6900B800AC020100B90004CD3O00AC0201002EDC00BA00B1020100BB0004CD3O00B102012O00CB000400013O00123A000500BC3O00123A000600BD4O000F000400064O004B00045O00123A000300043O002EA400BE0015020100BF0004CD3O0015020100267900030015020100040004CD3O00150201002E0E01C00076000100C00004CD3O002C03012O00CB00047O00010500013O00122O000600C13O00122O000700C26O0005000700024O00040004000500202O0004000400134O00040002000200062O0004002C03013O0004CD3O002C03012O00CB000400063O0006530104002C030100010004CD3O002C03012O00CB000400053O0020F10004000400C34O00065O00202O0006000600C44O00040006000200062O0004002C03013O0004CD3O002C0301002EDC00C500EA020100C60004CD3O00EA02012O00CB000400194O0020000500013O00122O000600C73O00122O000700C86O00050007000200062O000400EA020100050004CD3O00EA0201002EA400CA002C030100C90004CD3O002C0301002EA400CC002C030100CB0004CD3O002C03012O00CB000400044O007800055O00202O0005000500CD4O000600053O00202O00060006005200122O000800536O0006000800024O000600066O00040006000200062O0004002C03013O0004CD3O002C03012O00CB000400013O001218000500CE3O00122O000600CF6O000400066O00045O00044O002C0301002EA400D10013030100D00004CD3O001303012O00CB000400194O0020000500013O00122O000600D23O00122O000700D36O00050007000200062O00040013030100050004CD3O00130301002EDC00D5002C030100D40004CD3O002C03012O00CB0004001A3O0020570104000400D62O00290104000200020006F50004002C03013O0004CD3O002C03012O00CB000400033O0020570104000400D72O00CB0006001A4O00060004000600020006F50004002C03013O0004CD3O002C0301002EDC00D9002C030100D80004CD3O002C03012O00CB000400044O00780005000A3O00202O0005000500DA4O000600053O00202O00060006005200122O000800536O0006000800024O000600066O00040006000200062O0004002C03013O0004CD3O002C03012O00CB000400013O001218000500DB3O00122O000600DC6O000400066O00045O00044O002C03012O00CB000400194O0020000500013O00122O000600DD3O00122O000700DE6O00050007000200062O0004002C030100050004CD3O002C0301002E0E01DF0012000100DF0004CD3O002C03012O00CB000400044O00780005000A3O00202O0005000500DA4O000600053O00202O00060006005200122O000800536O0006000800024O000600066O00040006000200062O0004002C03013O0004CD3O002C03012O00CB000400013O00123A000500E03O00123A000600E14O000F000400064O004B00045O00123A000200343O0004CD3O002F03010004CD3O00150201002E0E01E20086000100E20004CD3O00B50301002679000200B5030100010004CD3O00B5030100123A000300013O0026790003006E030100040004CD3O006E03012O00CB0004001B3O0020570104000400132O00290104000200020006F50004005E03013O0004CD3O005E03012O00CB000400023O0006F50004005E03013O0004CD3O005E03012O00CB000400153O00261601040046030100E30004CD3O004603012O00CB000400053O0020570104000400E42O0029010400020002000E2A00E5005E030100040004CD3O005E03012O00CB00047O00010500013O00122O000600E63O00122O000700E76O0005000700024O00040004000500202O00040004001B4O00040002000200062O0004006003013O0004CD3O006003012O00CB00046O0062000500013O00122O000600E83O00122O000700E96O0005000700024O0004000400050020570104000400AF2O00290104000200022O00CB0005001C3O00068600040060030100050004CD3O006003012O00CB000400153O00261601040060030100E50004CD3O00600301002EA400EA006C030100EB0004CD3O006C0301002EDC00ED006C030100EC0004CD3O006C03012O00CB000400044O00CB0005001B4O00290104000200020006F50004006C03013O0004CD3O006C03012O00CB000400013O00123A000500EE3O00123A000600EF4O000F000400064O004B00045O00123A000200043O0004CD3O00B50301002EDC00F00034030100F10004CD3O0034030100267900030034030100010004CD3O0034030100123A000400013O002EA400F30079030100F20004CD3O0079030100267900040079030100040004CD3O0079030100123A000300043O0004CD3O0034030100267900040073030100010004CD3O007303012O00CB0005001D4O00A60005000100012O00CB0005001E3O0006F50005008E03013O0004CD3O008E03012O00CB000500153O00261601050090030100E30004CD3O009003012O00CB000500053O0020570105000500E42O0029010500020002000E2A00E5008E030100050004CD3O008E03012O00CB000500063O0006F50005009003013O0004CD3O009003012O00CB000500123O000E58017A0090030100050004CD3O00900301002E0E01F40024000100F50004CD3O00B2030100123A000500014O009C000600073O000EA000010098030100050004CD3O00980301002E6900F70098030100F60004CD3O00980301002E0E01F80005000100F90004CD3O009B030100123A000600014O009C000700073O00123A000500043O00267900050092030100040004CD3O00920301002EA400FB009D030100FA0004CD3O009D03010026790006009D030100010004CD3O009D030100123A000700013O000E49000100A2030100070004CD3O00A203012O00CB0008001F4O00640008000100022O00DA0008000B4O00CB0008000B3O0006F5000800B203013O0004CD3O00B203012O00CB0008000B4O005A010800023O0004CD3O00B203010004CD3O00A203010004CD3O00B203010004CD3O009D03010004CD3O00B203010004CD3O0092030100123A000400043O0004CD3O007303010004CD3O00340301002EA400FC0014000100FD0004CD3O00140001002EDC00FF0014000100FE0004CD3O0014000100267900020014000100310004CD3O001400012O00CB0003000B3O0006F5000300C603013O0004CD3O00C603012O00CB0003000B4O005A010300023O0004CD3O00C603010004CD3O001400010004CD3O00C603010004CD3O000F00010004CD3O00C603010004CD3O000200012O00013O00017O004F3O00028O00025O007DB040025O0042B040026O005F40025O00E06740025O0034A640025O00E3B240025O00B88440025O008AA140026O00F03F025O00549640025O0006AE40025O00209940025O00D0974003083O00700CE02871194A1703063O00762663894C33030A3O0049734361737461626C6503083O00566F6964426F6C7403093O004973496E52616E6765026O00444003163O00EB290C163622F22A1152192CC2320A001B25F332454003063O00409D46657269030D3O0076A9AAF31952A1A4D71F55ABAF03053O007020C8C783030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O66026O001840030B3O001A5F55BCF7A4303E5552AC03073O00424C303CD8A3CB030F3O00432O6F6C646F776E52656D61696E732O033O00474344027O0040030D3O0056616D7069726963546F756368030E3O0049735370652O6C496E52616E6765025O008AA440025O00CAA740031B3O00AC8774E356DC2D2OB96DFC4ACD2CFA9675CC4BC136A88377E71F9A03073O0044DAE619933FAE025O00288240025O00ACA540025O00EEAA40025O00B2A640025O00EEAB40025O00849440030F3O00892F4543A3BF235D4B86A12B5459B303053O00D6CD4A332C03073O004973526561647903153O004465766F7572696E67506C61677565446562752O66026O001040030B3O00CC43EBF843F55EF0F979EE03053O00179A2C829C025O0002A640025O00088040030F3O004465766F7572696E67506C61677565031D3O0015A3BBA1230118A8AA91261F10A1B8AB76031D99B9A1240114A8B9EE6003063O007371C6CDCE56025O00E5B140025O006C924003093O00A95EF05EA65BFF499003043O003AE4379E03073O005072657647434403093O004D696E64426C617374025O00E08640025O00ECA34003173O00B980DE2A03AF39B59AC46E2CA10AA086C23C39A321F4D103073O0055D4E9B04E5CCD025O00C4B240025O00B08840025O0022A840025O00806440030B3O007C5781E67E579AF04F569C03043O00822A38E803063O0042752O665570030C3O00566F6964666F726D42752O66025O00BC9640025O00E4AE40030B3O00566F6964546F2O72656E74031A3O00FCBA2DE77F2BE5A736E64E2BAAA528DC5430F8A721ED547FBBE503063O005F8AD54483200012012O00123A3O00013O002EDC00030005000100020004CD3O000500010026283O0007000100010004CD3O00070001002EDC0005006D000100040004CD3O006D000100123A000100013O002EDC0006000C000100070004CD3O000C00010026280001000E000100010004CD3O000E0001002EDC00090068000100080004CD3O0068000100123A000200013O002628000200130001000A0004CD3O00130001002EA4000C00150001000B0004CD3O0015000100123A0001000A3O0004CD3O0068000100262800020019000100010004CD3O00190001002E0E010D00F8FF2O000E0004CD3O000F00012O00CB00037O00010400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O0003003300013O0004CD3O003300012O00CB000300024O007800045O00202O0004000400124O000500033O00202O00050005001300122O000700146O0005000700024O000500056O00030005000200062O0003003300013O0004CD3O003300012O00CB000300013O00123A000400153O00123A000500164O000F000300054O004B00036O00CB00037O00010400013O00122O000500173O00122O000600186O0004000600024O00030003000400202O0003000300114O00030002000200062O0003006600013O0004CD3O006600012O00CB000300033O00203D0003000300194O00055O00202O00050005001A4O00030005000200262O000300660001001B0004CD3O006600012O00CB00036O0062000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400201901030003001E4O0003000200024O000400043O00202O00040004001F4O00040002000200202O00040004002000062O00030066000100040004CD3O006600012O00CB000300024O003801045O00202O0004000400214O000500033O00202O0005000500224O00075O00202O0007000700214O0005000700024O000500056O000600016O00030006000200062O00030061000100010004CD3O00610001002EDC00240066000100230004CD3O006600012O00CB000300013O00123A000400253O00123A000500264O000F000300054O004B00035O00123A0002000A3O0004CD3O000F0001002679000100080001000A0004CD3O0008000100123A3O000A3O0004CD3O006D00010004CD3O000800010026793O00DE0001000A0004CD3O00DE000100123A000100014O009C000200023O002EA400270071000100280004CD3O00710001002EA4002A0071000100290004CD3O0071000100267900010071000100010004CD3O0071000100123A000200013O002EDC002C007E0001002B0004CD3O007E00010026790002007E0001000A0004CD3O007E000100123A3O00203O0004CD3O00DE0001000E4900010078000100020004CD3O007800012O00CB00037O00010400013O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003009F00013O0004CD3O009F00012O00CB000300033O00203D0003000300194O00055O00202O0005000500304O00030005000200262O0003009F000100310004CD3O009F00012O00CB00036O0062000400013O00122O000500323O00122O000600336O0004000600024O00030003000400205C00030003001E4O0003000200024O000400043O00202O00040004001F4O00040002000200202O00040004002000062O000300A1000100040004CD3O00A10001002EDC003400B2000100350004CD3O00B200012O00CB000300024O004401045O00202O0004000400364O000500033O00202O0005000500224O00075O00202O0007000700364O0005000700024O000500056O00030005000200062O000300B200013O0004CD3O00B200012O00CB000300013O00123A000400373O00123A000500384O000F000300054O004B00035O002EA4003A00DA000100390004CD3O00DA00012O00CB00037O00010400013O00122O0005003B3O00122O0006003C6O0004000600024O00030003000400202O0003000300114O00030002000200062O000300DA00013O0004CD3O00DA00012O00CB000300043O0020EE00030003003D00122O0005000A6O00065O00202O00060006003E4O00030006000200062O000300DA000100010004CD3O00DA00012O00CB000300024O003801045O00202O00040004003E4O000500033O00202O0005000500224O00075O00202O00070007003E4O0005000700024O000500056O000600016O00030006000200062O000300D5000100010004CD3O00D50001002EA4004000DA0001003F0004CD3O00DA00012O00CB000300013O00123A000400413O00123A000500424O000F000300054O004B00035O00123A0002000A3O0004CD3O007800010004CD3O00DE00010004CD3O007100010026283O00E2000100200004CD3O00E20001002E0E01430021FF2O00440004CD3O00010001002EDC004600112O0100450004CD3O00112O012O00CB00017O00010200013O00122O000300473O00122O000400486O0002000400024O00010001000200202O0001000100114O00010002000200062O000100112O013O0004CD3O00112O012O00CB000100054O00CB000200034O00A300036O00060001000300020006532O0100FB000100010004CD3O00FB00012O00CB000100043O0020F10001000100494O00035O00202O00030003004A4O00010003000200062O000100112O013O0004CD3O00112O01002EA4004B00112O01004C0004CD3O00112O012O00CB000100024O006C00025O00202O00020002004D4O000300033O00202O0003000300224O00055O00202O00050005004D4O0003000500024O000300036O000400016O00010004000200062O000100112O013O0004CD3O00112O012O00CB000100013O0012180002004E3O00122O0003004F6O000100036O00015O00044O00112O010004CD3O000100012O00013O00017O0016012O00028O00025O00C06240025O00F2A840025O009CAD40027O0040026O00F03F030A3O0049734361737461626C6503063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O6603093O00A0F98BEB1F81F196FB03053O005DED90E58F03103O0046752O6C526563686172676554696D652O033O00474344026O000840030B3O003CF2FF15244036E2F80C0503063O0026759690796B030B3O004973417661696C61626C65030B3O001BB4E73E19B4FC2O28B5FA03043O005A4DDB8E030C3O00432O6F6C646F776E446F776E030B3O00D00B283D780868F4012F2D03073O001A866441592C67025O00B07140025O00D4A240030E3O0049735370652O6C496E52616E676503103O00FCEA3E279BF7EF313AE4F0EC3563F6A103053O00C491835043025O00C4A340025O008C9E4003093O0033B9080C3AE41FA31203063O00887ED066687803083O0042752O66446F776E03103O004D696E644465766F7572657242752O66030C3O004E85C7478A4028416C83C14D03083O003118EAAE23CF325D030A3O00432O6F6C646F776E5570030C3O003AFDF48C541EE7ED9C7803FC03053O00116C929DE8025O00309E4003093O004D696E64426C61737403113O0046CA1AE910AA47C207F96FA944C654BF7D03063O00C82BA3748D4F025O00F07C40025O0046AB40025O00C88B40025O00E2A240030D3O00E1D94A2FDECA4E3CE3D7523CDF03043O005FB7B827030B3O008637E6225B9721A73EF42E03073O0062D55F874634E003083O00496E466C6967687403113O00C9ABC06444FBB1C07953CDABC8735BE9B003053O00349EC3A917025O00609740025O0092A14003093O00436173744379636C65030D3O0056616D7069726963546F75636803163O0056616D7069726963546F7563684D6F7573656F766572025O004AA740025O00D0744003153O006CBD3F648F27728845A83D61853D3B8A75B97225D203083O00EB1ADC5214E6551B025O00C07640025O004CB34003113O00A5A8E7C64798A8E2C75D86B2E8CC7D9CB803053O0014E8C189A203073O004973526561647903093O000FD6CBA2C58016623603083O001142BFA5C687EC77030B3O0026ABA11FD0EECFC507BAA003083O00B16FCFCE739F888C030B3O0033861910E0404D178C1E0003073O003F65E97074B42F030B3O00F534E416CC39D129E81CEC03063O0056A35B8D7298025O00B2A140025O0050804003113O004D696E645370696B65496E73616E69747903093O004973496E52616E6765026O004440031A3O005E027A7705401B7D783F6C027A603B5D02606A7A520471336B0B03053O005A336B1413025O00EAA340025O0018A040030B3O008939348784FBF1AD2O339703073O0083DF565DE3D094030B3O00D356AFB515BCE069BFB81603063O00D583252OD67D030B3O0010242CBBD5293937BAEF3203053O0081464B45DF030F3O00432O6F6C646F776E52656D61696E7303133O0070CAFEF975FD4FC8C7E669EC4EEFF6EB69E94003063O008F26AB93891C030F3O0041757261416374697665436F756E74026O00F83F03083O00496E73616E697479026O00494003083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O6603103O004461726B526576657269657342752O66030C3O00566F6964666F726D42752O6603113O004461726B417363656E73696F6E42752O66025O002EAF40025O00CCA840025O0038B040025O00AC9940025O00A8A940025O00249C40025O00F4A540025O00EAA040025O007BB040025O00CDB040025O0055B240025O006CA640025O0060AD40025O00206E40025O00507640025O00C8AD40030B3O00E68DB0F737ECC6C287B7E703073O00B4B0E2D9936383030B3O00E3AA3604DBB02C2BDAB72403043O0067B3D94F025O00D89840025O00B08F40030B3O00566F6964546F2O72656E7403143O00566F6964546F2O72656E744D6F7573656F76657203133O005CB815D17E98AC58A519DB55CCA245B25C871703073O00C32AD77CB521EC030B3O00245D38320AFE2E4D3F2O2B03063O00986D39575E45025O00149040025O0070A140025O00CC9C40025O0050B04003103O00F4DE04A781D458A9E0970BACBB9206F003083O00C899B76AC3DEB234026O001040025O00688540025O0075B240025O00889240025O00B4A840025O00508240025O00188340025O0063B040025O005EA940025O00AAB240025O00C0584003143O00536861646F77576F72645061696E446562752O66030B3O006BCD56FE4C24D44AC444F203073O009738A5379A235303113O00974B0CFDB04617E7AE4436E6A1470AF9B303043O008EC02365026O003E4003093O0054696D65546F446965026O002E40030D3O00F2743BA8C69FAF13D86620ACE903083O0076B61549C387ECCC030D3O002C3D084B251EFE0D3209490B2O03073O009D685C7A20646D025O0062AD40025O006EA040025O00A49F40025O0049B24003103O00AEAFC1CE3F2283AFA6B48FCB3222CDFD03083O00CBC3C6AFAA5D47ED03093O00034230D1731DFD3D5F03073O009C4E2B5EB5317103093O005FE1CAA7294F7861FC03073O00191288A4C36B2303093O00C524A74B50B0C0ABFC03083O00D8884DC92F12DCA103083O004361737454696D6503094O00E525DE2AD0833EF803073O00E24D8C4BBA68BC03123O0090C0D52C4CB8DED13D43BCFADF2D42BCC0C403053O002FD9AEB05F03093O0095D4780690587935AC03083O0046D8BD1662D23418026O001C40025O00649840025O00A8A440025O0074B040025O0080584003103O00D7D6AD83ECD8D3A294C79ADEAC82938203053O00B3BABFC3E7026O004640025O008CA840025O00708440025O0002A74003083O00CF3011E0DB3014F003043O0084995F78025O0084A240025O00CCB140025O00649C40025O00D8AF40025O00AAB140025O00406D40025O006CA340025O009CAA4003083O00566F6964426F6C7403103O00A7BD0729C8D8AFBDA64E2CF8DF2OE0E203073O00C0D1D26E4D97BA030F3O00C40634E6EAD6E90D25D9F3C5E7162703063O00A4806342899F030F3O00496E73616E69747944656669636974026O00344003083O003686E0BA2286E5AA03043O00DE60E989030B3O0042752O6652656D61696E7303083O008FBCAE1BAA2OFCAD03073O0090D9D3C77FE893025O0010B240025O00D09840030F3O004465766F7572696E67506C6167756503183O004465766F7572696E67506C616775654D6F7573656F766572025O00108040025O000EA24003173O00FC2A2827C0570B4AFF102E24D4421741B82E312D95145003083O0024984F5E48B52562025O0044A440025O00BC9640025O00C1B140025O0098B040025O00349140025O0026A040030D3O001C29AC537F3821A277793F2BA903053O00164A48C123030B3O001F71E55C236EC74A2D6AEC03043O00384C198403113O0069C9A235DF5BD3A228C86DC9AA22C049D203053O00AF3EA1CB46025O006C9A4003143O002ADCCE033C2ED4C02C2133C8C01B753DD2C6536703053O00555CBDA373030B3O001AA4313C26BB132A28BF3803043O005849CC50025O00805E40025O000AA740025O0036AF4003073O000D8C1E4020C82303063O00BA4EE3702649025O00D88740025O002FB040030B3O00536861646F774372617368025O00A8A240025O00689D4003123O00EF5FFC515C6DC354EF544072BC56F250132E03063O001A9C379D353303123O00A9D613D4A110B9D612DCAA10AFCD04CAB74203063O0030ECB876B9D8025O0066AB40025O006AA34003063O0045786973747303093O0043616E412O7461636B025O00288D40025O003AA84003113O00536861646F774372617368437572736F7203123O00F6B55634C023DABE4531DC3CA5BC58358F6003063O005485DD3750AF025O00E49E40025O005EA840025O001C934003093O009CF36485D24EAEE83603063O003CDD8744C6A703123O00FDB5F9874DCED1BEEA8251D1AEBCF786028D03063O00B98EDD98E322025O0022A240025O00BCAA40025O001AA740025O00AAA340025O005AAD40025O0027B340025O00788540025O0015B040025O00407240025O00408B40025O007CB040025O00889C40008E042O00123A3O00014O009C000100013O002E0E01023O000100020004CD3O000200010026793O0002000100010004CD3O0002000100123A000100013O002EA4000300312O0100040004CD3O00312O01000E49000500312O0100010004CD3O00312O0100123A000200013O0026790002009A000100060004CD3O009A00012O00CB00035O0020570103000300072O00290103000200020006F50003004900013O0004CD3O004900012O00CB000300013O0020F10003000300084O000500023O00202O0005000500094O00030005000200062O0003004900013O0004CD3O004900012O00CB000300033O0006F50003004900013O0004CD3O004900012O00CB000300024O0062000400043O00122O0005000A3O00122O0006000B6O0004000600024O0003000300040020BD00030003000C4O0003000200024O000400013O00202O00040004000D4O00040002000200202O00040004000E00062O00040049000100030004CD3O004900012O00CB000300025O00010400043O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O0003004900013O0004CD3O004900012O00CB000300024O0040010400043O00122O000500123O00122O000600136O0004000600024O00030003000400202O0003000300144O00030002000200062O0003004B000100010004CD3O004B00012O00CB000300025O00010400043O00122O000500153O00122O000600166O0004000600024O00030003000400202O0003000300114O00030002000200062O0003004B00013O0004CD3O004B0001002EA40018005B000100170004CD3O005B00012O00CB000300054O002D00048O000500063O00202O0005000500194O00078O0005000700024O000500056O000600016O00030006000200062O0003005B00013O0004CD3O005B00012O00CB000300043O00123A0004001A3O00123A0005001B4O000F000300054O004B00035O002EA4001D00990001001C0004CD3O009900012O00CB000300025O00010400043O00122O0005001E3O00122O0006001F6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003009900013O0004CD3O009900012O00CB000300073O0006F50003009900013O0004CD3O009900012O00CB000300013O0020440003000300204O000500023O00202O0005000500214O00030005000200062O00030085000100010004CD3O008500012O00CB000300025O00010400043O00122O000500223O00122O000600236O0004000600024O00030003000400202O0003000300244O00030002000200062O0003009900013O0004CD3O009900012O00CB000300025O00010400043O00122O000500253O00122O000600266O0004000600024O00030003000400202O0003000300114O00030002000200062O0003009900013O0004CD3O00990001002E0E01270014000100270004CD3O009900012O00CB000300054O006C000400023O00202O0004000400284O000500063O00202O0005000500194O000700023O00202O0007000700284O0005000700024O000500056O000600016O00030006000200062O0003009900013O0004CD3O009900012O00CB000300043O00123A000400293O00123A0005002A4O000F000300054O004B00035O00123A000200053O0026280002009E000100050004CD3O009E0001002E0E012B00040001002C0004CD3O00A0000100123A0001000E3O0004CD3O00312O01002EA4002D000C0001002E0004CD3O000C00010026790002000C000100010004CD3O000C00012O00CB000300025O00010400043O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300074O00030002000200062O000300C500013O0004CD3O00C500012O00CB000300083O000E2A000100BB000100030004CD3O00BB00012O00CB000300025O00010400043O00122O000500313O00122O000600326O0004000600024O00030003000400202O0003000300334O00030002000200062O000300C700013O0004CD3O00C700012O00CB000300025O00010400043O00122O000500343O00122O000600356O0004000600024O00030003000400202O0003000300114O00030002000200062O000300C700013O0004CD3O00C70001002EDC003700E1000100360004CD3O00E100012O00CB000300093O00201E0103000300384O000400023O00202O0004000400394O0005000A6O0006000B6O000700063O00202O0007000700194O000900023O00202O0009000900394O0007000900022O00FB000700074O00B9000800096O000A000C3O00202O000A000A003A4O000B00016O0003000B000200062O000300DC000100010004CD3O00DC0001002EA4003B00E10001003C0004CD3O00E100012O00CB000300043O00123A0004003D3O00123A0005003E4O000F000300054O004B00035O002EA4003F002F2O0100400004CD3O002F2O012O00CB000300025O00010400043O00122O000500413O00122O000600426O0004000600024O00030003000400202O0003000300434O00030002000200062O0003002F2O013O0004CD3O002F2O012O00CB000300033O0006F50003002F2O013O0004CD3O002F2O012O00CB000300024O0062000400043O00122O000500443O00122O000600456O0004000600024O0003000300040020BD00030003000C4O0003000200024O000400013O00202O00040004000D4O00040002000200202O00040004000E00062O0004002F2O0100030004CD3O002F2O012O00CB000300025O00010400043O00122O000500463O00122O000600476O0004000600024O00030003000400202O0003000300114O00030002000200062O0003002F2O013O0004CD3O002F2O012O00CB000300024O0040010400043O00122O000500483O00122O000600496O0004000600024O00030003000400202O0003000300144O00030002000200062O0003001C2O0100010004CD3O001C2O012O00CB000300024O0040010400043O00122O0005004A3O00122O0006004B6O0004000600024O00030003000400202O0003000300114O00030002000200062O0003002F2O0100010004CD3O002F2O01002EDC004D002F2O01004C0004CD3O002F2O012O00CB000300054O0011000400023O00202O00040004004E4O000500063O00202O00050005004F00122O000700506O0005000700024O000500056O000600016O00030006000200062O0003002F2O013O0004CD3O002F2O012O00CB000300043O00123A000400513O00123A000500524O000F000300054O004B00035O00123A000200063O0004CD3O000C00010026790001000D0201000E0004CD3O000D0201002EA4005400AF2O0100530004CD3O00AF2O012O00CB000200025O00010300043O00122O000400553O00122O000500566O0003000500024O00020002000300202O0002000200114O00020002000200062O000200AF2O013O0004CD3O00AF2O012O00CB000200025O00010300043O00122O000400573O00122O000500586O0003000500024O00020002000300202O0002000200114O00020002000200062O000200AF2O013O0004CD3O00AF2O012O00CB000200024O0062000300043O00122O000400593O00122O0005005A6O0003000500024O00020002000300205701020002005B2O00290102000200020026BA000200AF2O01000E0004CD3O00AF2O012O00CB0002000D3O0006F5000200642O013O0004CD3O00642O012O00CB0002000E4O009A000300026O000400043O00122O0005005C3O00122O0006005D6O0004000600024O00030003000400202O00030003005E4O0003000200024O0004000E6O0003000300044O00020002000300262O000200AF2O01005F0004CD3O00AF2O012O00CB000200013O0020570102000200602O0029010200020002000E52016100852O0100020004CD3O00852O012O00CB000200063O0020440002000200624O000400023O00202O0004000400634O00020004000200062O000200852O0100010004CD3O00852O012O00CB000200013O0020440002000200084O000400023O00202O0004000400644O00020004000200062O000200852O0100010004CD3O00852O012O00CB000200013O0020440002000200084O000400023O00202O0004000400654O00020004000200062O000200852O0100010004CD3O00852O012O00CB000200013O0020F10002000200084O000400023O00202O0004000400664O00020004000200062O000200AF2O013O0004CD3O00AF2O0100123A000200014O009C000300043O002EA4006800A52O0100670004CD3O00A52O01002679000200A52O0100060004CD3O00A52O01002EA4006A008B2O0100690004CD3O008B2O01002628000300912O0100010004CD3O00912O01002EA4006B008B2O01006C0004CD3O008B2O0100123A000400013O002EA4006E00922O01006D0004CD3O00922O01002679000400922O0100010004CD3O00922O012O00CB000500104O00640005000100022O00DA0005000F3O002EA4006F00AF2O0100700004CD3O00AF2O012O00CB0005000F3O0006F5000500AF2O013O0004CD3O00AF2O012O00CB0005000F4O005A010500023O0004CD3O00AF2O010004CD3O00922O010004CD3O00AF2O010004CD3O008B2O010004CD3O00AF2O01002EDC007200872O0100710004CD3O00872O01000EA0000100AB2O0100020004CD3O00AB2O01002EDC007300872O0100740004CD3O00872O0100123A000300014O009C000400043O00123A000200063O0004CD3O00872O01002EA4007500DF2O0100760004CD3O00DF2O012O00CB000200025O00010300043O00122O000400773O00122O000500786O0003000500024O00020002000300202O0002000200074O00020002000200062O000200C52O013O0004CD3O00C52O012O00CB000200025O00010300043O00122O000400793O00122O0005007A6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200C72O013O0004CD3O00C72O01002EA4007B00DF2O01007C0004CD3O00DF2O012O00CB000200093O0020EB0002000200384O000300023O00202O00030003007D4O0004000A6O000500116O000600063O00202O0006000600194O000800023O00202O00080008007D4O0006000800024O000600066O000700086O0009000C3O00202O00090009007E4O000A00016O0002000A000200062O000200DF2O013O0004CD3O00DF2O012O00CB000200043O00123A0003007F3O00123A000400804O000F000200044O004B00026O00CB00025O0020570102000200072O00290102000200020006F5000200F52O013O0004CD3O00F52O012O00CB000200013O0020F10002000200084O000400023O00202O0004000400094O00020004000200062O000200F52O013O0004CD3O00F52O012O00CB000200024O0040010300043O00122O000400813O00122O000500826O0003000500024O00020002000300202O0002000200114O00020002000200062O000200F72O0100010004CD3O00F72O01002EA400840009020100830004CD3O000902012O00CB000200054O009700038O000400063O00202O0004000400194O00068O0004000600024O000400046O000500016O00020005000200062O00020004020100010004CD3O00040201002EA400860009020100850004CD3O000902012O00CB000200043O00123A000300873O00123A000400884O000F000200044O004B00026O00CB000200124O00640002000100022O00DA0002000F3O00123A000100893O00262800010011020100060004CD3O00110201002EDC008B00720301008A0004CD3O0072030100123A000200014O009C000300033O002E0E018C3O0001008C0004CD3O0013020100267900020013020100010004CD3O0013020100123A000300013O002E0E018D00040001008D0004CD3O001C0201000EA00005001E020100030004CD3O001E0201002E0E018E00040001008F0004CD3O0020020100123A000100053O0004CD3O0072030100262800030026020100010004CD3O00260201002EDB00900026020100910004CD3O00260201002EDC009200E8020100930004CD3O00E802012O00CB000400133O0020570104000400072O00290104000200020006F50004007702013O0004CD3O007702012O00CB000400063O0020F10004000400624O000600023O00202O0006000600944O00040006000200062O0004003502013O0004CD3O003502012O00CB000400073O00065301040049020100010004CD3O004902012O00CB000400025O00010500043O00122O000600953O00122O000700966O0005000700024O00040004000500202O0004000400334O00040002000200062O0004007702013O0004CD3O007702012O00CB000400025O00010500043O00122O000600973O00122O000700986O0005000700024O00040004000500202O0004000400114O00040002000200062O0004007702013O0004CD3O007702012O00CB000400143O00261601040051020100990004CD3O005102012O00CB000400063O00205701040004009A2O0029010400020002000E2A009B0077020100040004CD3O007702012O00CB000400025O00010500043O00122O0006009C3O00122O0007009D6O0005000700024O00040004000500202O0004000400114O00040002000200062O0004006902013O0004CD3O006902012O00CB000400024O0062000500043O00122O0006009E3O00122O0007009F6O0005000700024O00040004000500205701040004005B2O00290104000200022O00CB000500153O00068600040069020100050004CD3O006902012O00CB000400143O00263B000400770201009B0004CD3O007702012O00CB000400054O00CB000500134O002901040002000200065301040072020100010004CD3O00720201002E6900A00072020100A10004CD3O00720201002EA400A30077020100A20004CD3O007702012O00CB000400043O00123A000500A43O00123A000600A54O000F000400064O004B00046O00CB000400025O00010500043O00122O000600A63O00122O000700A76O0005000700024O00040004000500202O0004000400074O00040002000200062O000400E702013O0004CD3O00E702012O00CB000400024O0062000500043O00122O000600A83O00122O000700A96O0005000700024O00040004000500202601040004000C4O0004000200024O000500166O000600156O000700024O0062000800043O00122O000900AA3O00122O000A00AB6O0008000A00024O00070007000800209B0007000700AC4O000700086O00053O00024O000600176O000700156O000800024O0062000900043O00122O000A00AA3O00122O000B00AB6O0009000B00024O0008000800090020020008000800AC4O000800096O00063O00024O00050005000600062O0004000E000100050004CD3O00AF02012O00CB000400184O0026000500026O000600043O00122O000700AD3O00122O000800AE6O0006000800024O00050005000600202O0005000500AC4O0005000200024O000600156O00050005000600062O000400E7020100050004CD3O00E702012O00CB000400193O0006F5000400E702013O0004CD3O00E702012O00CB000400025O00010500043O00122O000600AF3O00122O000700B06O0005000700024O00040004000500202O0004000400114O00040002000200062O000400E702013O0004CD3O00E702012O00CB000400184O00CE000500026O000600043O00122O000700B13O00122O000800B26O0006000800024O00050005000600202O0005000500AC4O00050002000200062O000500E7020100040004CD3O00E702012O00CB0004000E3O0026BA000400E7020100B30004CD3O00E702012O00CB000400013O0020F10004000400204O000600023O00202O0006000600214O00040006000200062O000400E702013O0004CD3O00E70201002EDC00B400E7020100B50004CD3O00E702012O00CB000400054O0038010500023O00202O0005000500284O000600063O00202O0006000600194O000800023O00202O0008000800284O0006000800024O000600066O000700016O00040007000200062O000400E2020100010004CD3O00E20201002EA400B600E7020100B70004CD3O00E702012O00CB000400043O00123A000500B83O00123A000600B94O000F000400064O004B00045O00123A000300063O002EA400BA0018020100BB0004CD3O00180201002EDC00BC0018020100BD0004CD3O0018020100267900030018020100060004CD3O001802012O00CB000400024O0040010500043O00122O000600BE3O00122O000700BF6O0005000700024O00040004000500202O0004000400074O00040002000200062O000400FC020100010004CD3O00FC0201002EDB00C000FC020100C10004CD3O00FC0201002EA400C30010030100C20004CD3O00100301002EA400C50010030100C40004CD3O00100301002EA400C60010030100C70004CD3O001003012O00CB000400054O0078000500023O00202O0005000500C84O000600063O00202O00060006004F00122O000800506O0006000800024O000600066O00040006000200062O0004001003013O0004CD3O001003012O00CB000400043O00123A000500C93O00123A000600CA4O000F000400064O004B00046O00CB000400025O00010500043O00122O000600CB3O00122O000700CC6O0005000700024O00040004000500202O0004000400434O00040002000200062O0004006E03013O0004CD3O006E03012O00CB0004001A3O0006F50004005303013O0004CD3O005303012O00CB000400013O0020570104000400CD2O002901040002000200266E00040053030100CE0004CD3O005303012O00CB000400013O0020F10004000400084O000600023O00202O0006000600654O00040006000200062O0004006E03013O0004CD3O006E03012O00CB000400024O0062000500043O00122O000600CF3O00122O000700D06O0005000700024O00040004000500200F01040004005B4O0004000200024O000500013O00202O0005000500D14O000700023O00202O0007000700654O00050007000200062O0005006E030100040004CD3O006E03012O00CB000400024O0062000500043O00122O000600D23O00122O000700D36O0005000700024O00040004000500207300040004005B4O0004000200024O000500166O000600013O00202O0006000600D14O000800023O00202O0008000800654O00060008000200122O000700056O0005000700022O00CB000600174O0003000700013O00202O0007000700D14O000900023O00202O0009000900654O00070009000200122O000800056O0006000800024O00050005000600062O0004006E030100050004CD3O006E0301002EDC00D5006E030100D40004CD3O006E03012O00CB000400093O00200C0004000400384O000500023O00202O0005000500D64O0006000A6O0007001B6O000800063O00202O0008000800194O000A00023O00202O000A000A00D64O0008000A00024O000800086O0009000A6O000B000C3O00202O000B000B00D74O0004000B000200062O00040069030100010004CD3O00690301002EA400D9006E030100D80004CD3O006E03012O00CB000400043O00123A000500DA3O00123A000600DB4O000F000400064O004B00045O00123A000300053O0004CD3O001802010004CD3O007203010004CD3O00130201002EDC00DD0079040100DC0004CD3O00790401000E4900010079040100010004CD3O0079040100123A000200013O002EDC00DF007D030100DE0004CD3O007D03010026790002007D030100050004CD3O007D030100123A000100063O0004CD3O0079040100262800020081030100010004CD3O00810301002EA400E100C2030100E00004CD3O00C203012O00CB0003001C4O00A60003000100012O002O010300026O000400043O00122O000500E23O00122O000600E36O0004000600024O00030003000400202O0003000300074O00030002000200062O000300C103013O0004CD3O00C103012O00CB000300083O000E2A0001009D030100030004CD3O009D03012O00CB0003001D3O0006530103009D030100010004CD3O009D03012O00CB000300025O00010400043O00122O000500E43O00122O000600E56O0004000600024O00030003000400202O0003000300334O00030002000200062O000300A703013O0004CD3O00A703012O00CB000300024O0040010400043O00122O000500E63O00122O000600E76O0004000600024O00030003000400202O0003000300114O00030002000200062O000300C1030100010004CD3O00C10301002E0E01E8001A000100E80004CD3O00C103012O00CB000300093O0020EB0003000300384O000400023O00202O0004000400394O0005000A6O0006001E6O000700063O00202O0007000700194O000900023O00202O0009000900394O0007000900024O000700076O000800096O000A000C3O00202O000A000A003A4O000B00016O0003000B000200062O000300C103013O0004CD3O00C103012O00CB000300043O00123A000400E93O00123A000500EA4O000F000300054O004B00035O00123A000200063O00267900020077030100060004CD3O007703012O00CB000300025O00010400043O00122O000500EB3O00122O000600EC6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300D103013O0004CD3O00D103012O00CB0003000D3O0006F5000300D303013O0004CD3O00D30301002EA400EE003A040100ED0004CD3O003A0401002E0E01EF001E000100EF0004CD3O00F103012O00CB0003001F4O000D010400043O00122O000500F03O00122O000600F16O00040006000200062O000300DE030100040004CD3O00DE0301002EDC00F300F1030100F20004CD3O00F103012O00CB000300054O005D010400023O00202O0004000400F44O000500063O00202O00050005004F00122O000700506O0005000700024O000500056O00030005000200062O000300EB030100010004CD3O00EB0301002EA400F5003A040100F60004CD3O003A04012O00CB000300043O001218000400F73O00122O000500F86O000300056O00035O00044O003A04012O00CB0003001F4O000D010400043O00122O000500F93O00122O000600FA6O00040006000200062O000300FA030100040004CD3O00FA0301002EDC00FB0019040100FC0004CD3O001904012O00CB000300203O0020570103000300FD2O00290103000200020006F50003000504013O0004CD3O000504012O00CB000300013O0020570103000300FE2O00CB000500204O000600030005000200065301030007040100010004CD3O00070401002EA42O00013A040100FF0004CD3O003A04012O00CB000300054O00240104000C3O00122O0005002O015O0004000400054O000500063O00202O00050005004F00122O000700506O0005000700024O000500056O00030005000200062O0003003A04013O0004CD3O003A04012O00CB000300043O00121800040002012O00122O00050003015O000300056O00035O00044O003A040100123A00030004012O00123A00040005012O0006FD00030029040100040004CD3O0029040100123A00030006012O00123A00040006012O0006E400030029040100040004CD3O002904012O00CB0003001F4O000D010400043O00122O00050007012O00122O00060008015O00040006000200062O00030029040100040004CD3O002904010004CD3O003A04012O00CB000300054O00240104000C3O00122O0005002O015O0004000400054O000500063O00202O00050005004F00122O000700506O0005000700024O000500056O00030005000200062O0003003A04013O0004CD3O003A04012O00CB000300043O00123A00040009012O00123A0005000A013O000F000300054O004B00036O00CB000300213O0006F50003007704013O0004CD3O007704012O00CB000300143O00123A000400993O0006860003004E040100040004CD3O004E04012O00CB000300063O00205701030003009A2O002901030002000200123A0004009B3O0006D200040077040100030004CD3O007704012O00CB0003000D3O0006F50003004E04013O0004CD3O004E04012O00CB0003000E3O00123A000400053O0006D200040077040100030004CD3O0077040100123A000300014O009C000400043O00123A0005000B012O00123A0006000C012O0006D200050050040100060004CD3O0050040100123A000500013O00064A0103005B040100050004CD3O005B040100123A0005000D012O00123A0006000E012O0006D200050050040100060004CD3O0050040100123A000400013O00123A0005000F012O00123A00060010012O0006FD0005005C040100060004CD3O005C040100123A00050011012O00123A00060012012O0006D20005005C040100060004CD3O005C040100123A000500013O0006E40004005C040100050004CD3O005C04012O00CB000500224O00C40005000100024O0005000F3O00122O00050013012O00122O00060013012O00062O00050077040100060004CD3O007704012O00CB0005000F3O0006F50005007704013O0004CD3O007704012O00CB0005000F4O005A010500023O0004CD3O007704010004CD3O005C04010004CD3O007704010004CD3O0050040100123A000200053O0004CD3O0077030100123A00020014012O00123A00030015012O0006D200020007000100030004CD3O0007000100123A00020016012O00123A00030016012O0006E400020007000100030004CD3O0007000100123A000200893O0006E400020007000100010004CD3O000700012O00CB0002000F3O0006F50002008D04013O0004CD3O008D04012O00CB0002000F4O005A010200023O0004CD3O008D04010004CD3O000700010004CD3O008D04010004CD3O000200012O00013O00017O007E3O00028O00025O00549540025O008EB040026O00F03F025O00AEB040025O009C984003043O0014E28C3803063O003A5283E85D2903073O004973526561647903103O004865616C746850657263656E74616765025O00789F40025O00405F4003043O0046616465030E3O008556D4101D3B8651D51B4E36955203063O005FE337B0753D025O004DB040025O00349D40030A3O003C77305BAE0A6D2A44A503053O00CB781E432B030A3O0049734361737461626C65025O00C07040025O00CEAB40030A3O0044697370657273696F6E025O00D8A440025O00949F4003143O00F52C5EFFDCE33644E0D7B12148E9DCFF3644F9DC03053O00B991452D8F025O00BC9940025O0058A840030F3O00AE1A0AB6D9981E0DA3EC981E00A3CE03053O00BCEA7F79C6025O00D07740025O00F8AD40025O0065B240025O0096B140030F3O00446573706572617465507261796572025O00789E40025O0006AE40031A3O003C3700933D2012973D0D0391392B1691783616853D3C008A2E3703043O00E3585273030F3O00751E2OB70B614A1C9FAA0061421CBF03063O0013237FDAC762030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00E0A940025O0012A940025O00E2A240025O00CEAC40025O00C2A240025O00EC9C40025O00489240026O002O40030F3O0056616D7069726963456D6272616365031A3O000AFA07F215E903E123FE07E00EFA09E75CFF0FE419F519EB0AFE03043O00827C9B6A027O0040025O0050AA40025O00808740025O00649B40025O0074AB40025O00189D40025O0028AD40025O0034AE40030F3O00324FFAF61077E2E10673E5FA074CE903043O009362208D03153O00506F776572576F7264536869656C64506C61796572025O00989640025O00D2AD40031B3O00084CF4CF14695C1751E7F5155E421D4FE78A02534D1D4DF0C3105303073O002B782383AA6636025O008AA240025O004CB140025O00C07F40025O001CB240025O00B0944003093O00F3C7F7BCABDE79BED903083O00DFB5AB96CFC3961C025O0079B140025O00789A40025O00107A40025O0059B040030F3O00466C6173684865616C506C6179657203143O004A36E2BD017332E6AF050C3EE6A80C4229EAB80C03053O00692C5A83CE03053O00CDE52OBC1F03063O005E9F80D2D968025O000C9140025O004CA740030B3O0052656E6577506C61796572025O006AA040025O00D09B40030F3O0042FC08BA483FFD7F56FC08AC5669FC03083O001A309966DF3F1F99025O00307C40025O0060A240030B3O007C0386BAB1B897400989B303073O00E43466E7D6C5D0025O00349540025O009EA540030B3O004865616C746873746F6E6503173O0016E574C6FE830AC211EE708AEE8E1FD310F37CDCEFCB4A03083O00B67E8015AA8AEB79025O0019B140025O00709E40026O000840026O008D40025O007FB040025O00D09640025O0064AA40025O00C09440025O00609C4003193O00B9DF33F48300380F85DD75CE83123C0F85DD75D6890739098503083O0066EBBA5586E6735003173O006509384D77C72A5E02392O77D52E5E02396F7DC02B580203073O0042376C5E3F12B4025O00F8AA40025O0078AB40025O00689440025O00C8A140025O0077B240025O0004924003173O0052656672657368696E674865616C696E67506F74696F6E03253O0006888325224A1C848B306751118C893E295E549D8A232E561ACD8132215C1A9E8C2122194003063O003974EDE5574700B4012O00123A3O00014O009C000100013O002EA400020002000100030004CD3O000200010026793O0002000100010004CD3O0002000100123A000100013O0026790001005A000100010004CD3O005A000100123A000200013O0026790002000E000100040004CD3O000E000100123A000100043O0004CD3O005A00010026790002000A000100010004CD3O000A0001002EDC00060034000100050004CD3O003400012O00CB00037O00010400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003003400013O0004CD3O003400012O00CB000300023O0006F50003003400013O0004CD3O003400012O00CB000300033O00205701030003000A2O00290103000200022O00CB000400043O0006FD00030034000100040004CD3O00340001002EA4000C00340001000B0004CD3O003400012O00CB000300054O008D00045O00202O00040004000D4O000500066O000700016O00030007000200062O0003003400013O0004CD3O003400012O00CB000300013O00123A0004000E3O00123A0005000F4O000F000300054O004B00035O002EA400110049000100100004CD3O004900012O00CB00037O00010400013O00122O000500123O00122O000600136O0004000600024O00030003000400202O0003000300144O00030002000200062O0003004900013O0004CD3O004900012O00CB000300033O00205701030003000A2O00290103000200022O00CB000400063O0006D200030049000100040004CD3O004900012O00CB000300073O0006530103004B000100010004CD3O004B0001002E0E0115000F000100160004CD3O005800012O00CB000300054O00CB00045O0020890004000400172O002901030002000200065301030053000100010004CD3O00530001002EDC00180058000100190004CD3O005800012O00CB000300013O00123A0004001A3O00123A0005001B4O000F000300054O004B00035O00123A000200043O0004CD3O000A0001002EA4001C00B70001001D0004CD3O00B70001000E49000400B7000100010004CD3O00B700012O00CB00027O00010300013O00122O0004001E3O00122O0005001F6O0003000500024O00020002000300202O0002000200144O00020002000200062O0002007100013O0004CD3O007100012O00CB000200033O00205701020002000A2O00290102000200022O00CB000300083O0006FD00020071000100030004CD3O007100012O00CB000200093O00065301020075000100010004CD3O00750001002ECA00210075000100200004CD3O00750001002E0E0122000F000100230004CD3O008200012O00CB000200054O00CB00035O0020890003000300242O00290102000200020006530102007D000100010004CD3O007D0001002EA400260082000100250004CD3O008200012O00CB000200013O00123A000300273O00123A000400284O000F000200044O004B00026O00CB00027O00010300013O00122O000400293O00122O0005002A6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200A100013O0004CD3O00A100012O00CB0002000A3O00208900020002002B2O00640002000100020006F5000200A100013O0004CD3O00A100012O00CB0002000B3O00205701020002002C00123A0004002D4O00060002000400020006F5000200A100013O0004CD3O00A100012O00CB0002000C3O0006F5000200A100013O0004CD3O00A100012O00CB0002000A3O00205A00020002002E4O0003000D6O0004000E6O00020004000200062O000200A5000100010004CD3O00A50001002ECA002F00A5000100300004CD3O00A50001002EDC003200B6000100310004CD3O00B60001002EA4003400B6000100330004CD3O00B60001002EA4003600B6000100350004CD3O00B600012O00CB000200054O008D00035O00202O0003000300374O000400046O000500016O00020005000200062O000200B600013O0004CD3O00B600012O00CB000200013O00123A000300383O00123A000400394O000F000200044O004B00025O00123A0001003A3O000E49003A00792O0100010004CD3O00792O0100123A000200013O002628000200C0000100010004CD3O00C00001002ECA003B00C00001003C0004CD3O00C00001002EDC003E00722O01003D0004CD3O00722O012O00CB0003000F3O000653010300C5000100010004CD3O00C50001002EA40040004D2O01003F0004CD3O004D2O0100123A000300014O009C000400043O002E0E01413O000100410004CD3O00C70001000E49000100C7000100030004CD3O00C7000100123A000400013O000E49000400EF000100040004CD3O00EF00012O00CB00057O00010600013O00122O000700423O00122O000800436O0006000800024O00050005000600202O0005000500144O00050002000200062O0005004D2O013O0004CD3O004D2O012O00CB000500033O00205701050005000A2O00290105000200022O00CB000600103O0006FD0005004D2O0100060004CD3O004D2O012O00CB000500113O0006F50005004D2O013O0004CD3O004D2O012O00CB000500054O00CB000600123O0020890006000600442O0029010500020002000653010500E9000100010004CD3O00E90001002E0E01450066000100460004CD3O004D2O012O00CB000500013O001218000600473O00122O000700486O000500076O00055O00044O004D2O01002679000400CC000100010004CD3O00CC000100123A000500014O009C000600063O002628000500F7000100010004CD3O00F70001002EA4004A00F3000100490004CD3O00F3000100123A000600013O000E49000400FC000100060004CD3O00FC000100123A000400043O0004CD3O00CC0001002EDC004B00F80001004C0004CD3O00F80001000E49000100F8000100060004CD3O00F80001002E0E014D00240001004D0004CD3O00242O012O00CB00077O00010800013O00122O0009004E3O00122O000A004F6O0008000A00024O00070007000800202O0007000700144O00070002000200062O000700242O013O0004CD3O00242O012O00CB000700033O00205701070007000A2O00290107000200022O00CB000800133O0006FD000700242O0100080004CD3O00242O012O00CB000700143O0006F5000700242O013O0004CD3O00242O01002EDC005100242O0100500004CD3O00242O01002EDC005200242O0100530004CD3O00242O012O00CB000700054O00CB000800123O0020890008000800542O00290107000200020006F5000700242O013O0004CD3O00242O012O00CB000700013O00123A000800553O00123A000900564O000F000700094O004B00076O00CB00077O00010800013O00122O000900573O00122O000A00586O0008000A00024O00070007000800202O0007000700144O00070002000200062O000700372O013O0004CD3O00372O012O00CB000700033O00205701070007000A2O00290107000200022O00CB000800153O0006FD000700372O0100080004CD3O00372O012O00CB000700163O000653010700392O0100010004CD3O00392O01002EDC005A00462O0100590004CD3O00462O012O00CB000700054O00CB000800123O00208900080008005B2O0029010700020002000653010700412O0100010004CD3O00412O01002E0E015C00070001005D0004CD3O00462O012O00CB000700013O00123A0008005E3O00123A0009005F4O000F000700094O004B00075O00123A000600043O0004CD3O00F800010004CD3O00CC00010004CD3O00F300010004CD3O00CC00010004CD3O004D2O010004CD3O00C70001002EA4006000712O0100610004CD3O00712O012O00CB000300175O00010400013O00122O000500623O00122O000600636O0004000600024O00030003000400202O0003000300094O00030002000200062O000300712O013O0004CD3O00712O012O00CB000300183O0006F5000300712O013O0004CD3O00712O012O00CB000300033O00205701030003000A2O00290103000200022O00CB000400193O0006FD000300712O0100040004CD3O00712O01002EDC006400712O0100650004CD3O00712O012O00CB000300054O008D000400123O00202O0004000400664O000500066O000700016O00030007000200062O000300712O013O0004CD3O00712O012O00CB000300013O00123A000400673O00123A000500684O000F000300054O004B00035O00123A000200043O002628000200762O0100040004CD3O00762O01002EA4006900BA0001006A0004CD3O00BA000100123A0001006B3O0004CD3O00792O010004CD3O00BA0001002EA4006C00070001006D0004CD3O00070001002679000100070001006B0004CD3O00070001002EDC006E00B32O01006F0004CD3O00B32O012O00CB0002001A3O0006F5000200B32O013O0004CD3O00B32O012O00CB000200033O00205701020002000A2O00290102000200022O00CB0003001B3O0006FD000200B32O0100030004CD3O00B32O01002EA4007000922O0100710004CD3O00922O012O00CB0002001C4O000D010300013O00122O000400723O00122O000500736O00030005000200062O000200922O0100030004CD3O00922O010004CD3O00B32O012O00CB000200174O0040010300013O00122O000400743O00122O000500756O0003000500024O00020002000300202O0002000200094O00020002000200062O000200A02O0100010004CD3O00A02O01002E69007700A02O0100760004CD3O00A02O01002EA4007900B32O0100780004CD3O00B32O01002EDC007B00B32O01007A0004CD3O00B32O012O00CB000200054O008D000300123O00202O00030003007C4O000400056O000600016O00020006000200062O000200B32O013O0004CD3O00B32O012O00CB000200013O0012180003007D3O00122O0004007E6O000200046O00025O00044O00B32O010004CD3O000700010004CD3O00B32O010004CD3O000200012O00013O00017O00203O0003073O0047657454696D65028O00025O0020AA40025O0052AE40025O00889D40030B3O0088BEE9FE76E04399BEF8EB03073O0027CAD18D87178E030B3O004973417661696C61626C65030F3O00CF3C1E0F20CFF0210D393AF1FA3F0D03063O00989F53696A5203073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O66025O00C0A140025O0098AC40025O006CAE40025O0058B14003153O00506F776572576F7264536869656C64506C61796572025O00BAA040025O0012B340031D3O0091C946F7DB6396C9432OF64F89CF54FECD6391CA50EBCC4EC1CB5EE4CC03063O003CE1A63192A9030E3O000E10282F0D0E2C382A2B150F2A0C03063O00674F7E4F4A61025O00DCA740025O00089E4003143O00416E67656C696346656174686572506C61796572025O005DB040025O00BCA340031B3O00BB71D4765213B940D5765F0EB27AC14C4E16BB66D6611E17B569D603063O007ADA1FB3133E007E3O0012403O00018O000100024O00019O003O00014O000100013O00062O0001007D00013O0004CD3O007D000100123A3O00024O009C000100013O002E0E01033O000100030004CD3O000900010026283O000F000100020004CD3O000F0001002EDC00040009000100050004CD3O0009000100123A000100023O00267900010010000100020004CD3O001000012O00CB000200025O00010300033O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002003700013O0004CD3O003700012O00CB000200025O00010300033O00122O000400093O00122O0005000A6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002003700013O0004CD3O003700012O00CB000200043O0006F50002003700013O0004CD3O003700012O00CB000200053O0020F100020002000C4O000400023O00202O00040004000D4O00020004000200062O0002003700013O0004CD3O003700012O00CB000200053O00204400020002000C4O000400023O00202O00040004000E4O00020004000200062O0002003B000100010004CD3O003B0001002ECA0010003B0001000F0004CD3O003B0001002EDC00120048000100110004CD3O004800012O00CB000200064O00CB000300073O0020890003000300132O002901020002000200065301020043000100010004CD3O00430001002EA400150048000100140004CD3O004800012O00CB000200033O00123A000300163O00123A000400174O000F000200044O004B00026O00CB000200025O00010300033O00122O000400183O00122O000500196O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002006A00013O0004CD3O006A00012O00CB000200083O0006F50002006A00013O0004CD3O006A00012O00CB000200053O0020F100020002000C4O000400023O00202O00040004000D4O00020004000200062O0002006A00013O0004CD3O006A00012O00CB000200053O0020F100020002000C4O000400023O00202O00040004000E4O00020004000200062O0002006A00013O0004CD3O006A00012O00CB000200053O00204400020002000C4O000400023O00202O00040004000D4O00020004000200062O0002006C000100010004CD3O006C0001002EA4001A007D0001001B0004CD3O007D00012O00CB000200064O00CB000300073O00208900030003001C2O002901020002000200065301020074000100010004CD3O00740001002EDC001D007D0001001E0004CD3O007D00012O00CB000200033O0012180003001F3O00122O000400206O000200046O00025O00044O007D00010004CD3O001000010004CD3O007D00010004CD3O000900012O00013O00017O000D3O00030D3O0083C3DFC8CFB861BAC5C8C0DAA403073O0025D3B6ADA1A9C103073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974025O008C9340025O00449740025O00FDB040025O00B4B24003123O0050757269667944697365617365466F637573025O00F08440025O00AC9B4003153O00E72F5FD02E6286F3335EDC2968BCB73E44CA387EB503073O00D9975A2DB9481B00244O002O019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001200013O0004CD3O001200012O00CB3O00023O0006F53O001200013O0004CD3O001200012O00CB3O00033O0020895O00042O00643O00010002000653012O0016000100010004CD3O00160001002E6900060016000100050004CD3O00160001002EA400080023000100070004CD3O002300012O00CB3O00044O00CB000100053O0020890001000100092O0029012O00020002000653012O001E000100010004CD3O001E0001002E0E010A00070001000B0004CD3O002300012O00CB3O00013O00123A0001000C3O00123A0002000D4O000F3O00024O004B8O00013O00017O0037012O00028O00025O00D6A240025O00C88F40025O00CC9640025O00907440026O00F03F025O00608440025O00289C40025O00BCA640025O00609140025O0022AC40025O00B89A40027O0040025O00C49F40025O00688940026O000840025O00888640025O00B49740030C3O004570696353652O74696E677303083O001BA4D068172D363103083O004248C1A41C7E4351030D3O00C325BB48237AC329AA4D2070F403063O0016874CC8384603083O00BE35EC3054EF8A2303063O0081ED5098443D030B3O0075A117E3191B7A44AE02E003073O003831C864937C77025O00188240025O00FCB14003083O00FF3BABE4C530B8E303043O0090AC5EDF030F3O000C0EAC43280A83412203AB44300AA603043O0027446FC203083O00E5A3F3D370B9D1B503063O00D7B6C687A71903113O00A548E44C814CC3468E46F858825BEF498103043O0028ED298A025O00F89F40025O007AB040026O00204003083O002AED56A43317EF5103053O005A798822D003093O00EF0F5911E01C5A0BD703043O007EA76E3503083O000E153AECD5313A2O03063O005F5D704E98BC030D3O00F4E68031EDA8DBCFF0B601E5AC03073O00B2A195E57584DE03083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C6030C3O00BE3DB0063703FC8306B0213703073O008FEB4ED5405B6203083O00BE4D90FD79B88A5B03063O00D6ED28E48910030B3O00A3EFEECA0B8E80E2E3F13303063O00C6E5838FB963026O002240026O001C40025O006FB240025O00FAA540025O0070A340025O0050894003083O00E4EDB638DEE6A53F03043O004CB788C203073O004ACFCB395D4A4603073O00741A868558302F034O0003083O002DC4B4F0B47C19D203063O00127EA1C084DD03073O006F0180055B5A7B03053O00363F48CE64025O00B0AB40025O00BAB240025O00D8AB4003083O00FB5C516EEC75CF4A03063O001BA839251A8503073O0018B97980D621A503053O00B74DCA1CC803083O0024369D1C1E3D8E1B03043O00687753E903063O00DDF92B2D6BC503053O002395984742025O00D4A440025O0072B340025O00507040025O00206140025O00607040025O0070994003083O001D0BEFE22700FCE503043O00964E6E9B03113O00ADC026EDAD10B8708AD12EEEAA30BE4D8003083O0020E5A54781C47EDF03083O00F08CD09588DBC49A03063O00B5A3E9A42OE1030F3O00788E3F7B598539475F9F37785EA30E03043O001730EB5E03083O00F079F3065FCD7BF403053O0036A31C8772030A3O001DC858B04F7C21DA519103063O001F48BB3DE22E03083O00F00357C64E7023D003073O0044A36623B2271E03103O008B63DFEF06B48F18B077EAC817BC8C1F03083O0071DE10BAA763D5E3025O000CB040025O00688440025O008C9A40025O002EB240025O00ACA340025O00D4A740025O00C7B240025O00206640025O00B6B040025O00E88E40025O009EAC40025O00F88A4003083O007E1438FB441F2BFC03043O008F2D714C030E3O008DAB191EB7BC051DB6BC2F33ADB403043O005C2OD87C03083O006837B854F45535BF03053O009D3B52CC20030D3O001531F5FFE4EFDDA51C3BEFFBF003083O00D1585E839A898AB3025O0064AF40025O0052B240025O0006A440025O00FDB040025O00B4A340025O0051B040025O00807840025O00B8A04003083O004FDFCC495E3DD56F03073O00B21CBAB83D375303153O00F1DE420CFD19F0D6FA482EF628FAD6D94E28E70AF003073O0095A4AD275C926E03083O00C022040B1315F43403063O007B9347707F7A03113O00F9DE875048CBC88E7845EAC883654EC9DF03053O0026ACADE211025O00849240025O00B0A840025O00B3B140025O0042A840025O00BC9340026O001840025O00F8AF40026O007D4003083O0043AFB4FE707EADB303053O001910CAC08A03123O00CDC4BAE7BBDDF3CDB8F1A0FBF3ECBFEDBCE403063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B103073O00BD31344C801D4B03043O002DED787A025O002EAE4003083O0079DF02C6DE0FB95903073O00DE2ABA76B2B76103133O006DE3538F4FC54A8C48FF4D8553D845985AE95003043O00EA3D8C2403083O0012D8AE66062FDAA903053O006F41BDDA12030F3O0073440C301975A1455E083C0452877303073O00CF232B7B556B3C025O0006A940025O001AA140026O002440025O0018A640025O0028A04003083O0063EFECDC485EEDEB03053O0021308A98A8030D3O0047053562C93676192757CE257F03063O005712765031A103083O007F1BCEB4B94219C903053O00D02C7EBAC003123O00C209A1F015F1D947E513A7E319FEDB4FF41F03083O002E977AC4A6749CA903083O00D6E8520EF2EBEA5503053O009B858D267A03113O00132BA151466DAC260FA1435D7EA620029C03073O00C5454ACC212F1F03083O00C34A4E93F9415D9403043O00E7902F3A03143O0084D9D765112FC63A97D5D867193ECA1EA0D7CF6503083O0059D2B8BA15785DAF026O002640025O0095B040025O006C9040025O0064B34003083O00825668C17034B64003063O005AD1331CB51903103O00E37356EAB0C75845EFACD84E44EFB8D503053O00DFB01B378E03083O0017BEDAA12DB5C9A603043O00D544DBAE03123O003DE12EF723D7367C3FEF36E422F02C7E0CE503083O001F6B8043874AA55F03083O00EBEDE85948BFDFFB03063O00D1B8889C2D2103103O0031C97818B115C1763CB712CB7D25B91F03053O00D867A81568025O00C4A740025O0084B040025O0023B340025O00BCA34003083O006289BC675882AF6003043O001331ECC803083O00CB24F385E1B4FB2003063O00DA9E5796D78403083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203073O00D7A3B4C29FC4D503063O008C85C6DAA7E8026O002E40025O0060784003083O00862BA0698DBB29A703053O00E4D54ED41D03123O00B25FB335E49049A432E49548850DE28240B203053O008BE72CD66503083O002OEA124A19BF360503083O0076B98F663E70D15103113O006C7F3EE3B722132A584321EFA01918106C03083O00583C104986C5757C025O00BAAB40025O00E9B140025O00609340025O0088A140025O00E2A340025O00D49A40025O00307C40025O0002B34003083O0029182A0C3CFF230903073O00447A7D5E78559103123O003E12DB5BDACBAF0708FB56DADCA91F13C35A03073O00DA777CAF3EA8B903083O0096F55CD0ACFE4FD703043O00A4C5902803123O00B6E32OAFD8A593F5B88AC92OB3E2AB92D8A403063O00D6E390CAEBBD025O001BB240025O00805D40025O00A89940026O00104003083O00F471EEEC43C973E903053O002AA7149A9803113O0063F0B64763335FEEB675783542CDB6577F03063O00412A9EC2221103083O002922461824E31CFD03083O008E7A47326C4D8D7B03163O003CACEB1D2907B7EF0C141BAEE62F331CB6FA143206B603053O005B75C29F78025O00289340025O0040A940026O001440025O00AEA340025O006EAD40025O00108640025O00E8A640025O003BB140025O00B8A940025O000C9740025O0080594003083O0094B2DDC8AEB9CECF03043O00BCC7D7A903063O00DA085B7EC0CC03053O00889C693F1B03083O0028896D2012827E2703043O00547BEC19030E3O00C598AF3FA9B4FC9FA204B8BAFE8E03063O00D590EBCA77CC025O00A5B240025O00FC9440025O00949B40025O00B49240025O00D4B040025O0030A44003083O00101DCA3E212D4A3003073O002D4378BE4A4843030D3O000827ECA9ED802OFD2F2CE88DC903083O008940428DC599E88E03083O0030D536B2810DD73103053O00E863B042C603123O00DC2E3F0369A4F72AF932210975B8EA2DEB2403083O004C8C4148661BED99025O005C9B40025O00E09740025O00688D40025O00ABB040025O006AA640025O00CC984003083O00DEA0936F19BD542F03083O005C8DC5E71B70D33303113O00C2FA99B3D4F4FE9EA6E1F4FE93A6C3CECF03053O00B1869FEAC303083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC0030C3O00FA826C2F2734CD8270310A1603063O0046BEEB1F5F42025O00D89740025O00C09340025O00C06F40025O0062B04003083O0089E70EF2ECB4E50903053O0085DA827A86030D3O0009ECE6E0D5B02839EDF0CDD3AD03073O00585C9F83A4BCC303083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B03073O001BEF8F30C02AF903053O00A14E9CEA7600F0032O00123A3O00014O009C000100023O002EDC0003000B000100020004CD3O000B0001002EA40005000B000100040004CD3O000B00010026793O000B000100010004CD3O000B000100123A000100014O009C000200023O00123A3O00063O000EA00006000F00013O0004CD3O000F0001002EDC00080002000100070004CD3O00020001002EDC000A0013000100090004CD3O0013000100262800010015000100010004CD3O00150001002EDC000B000F0001000C0004CD3O000F000100123A000200013O0026790002005A0001000D0004CD3O005A000100123A000300013O0026280003001D0001000D0004CD3O001D0001002EA4000E001F0001000F0004CD3O001F000100123A000200103O0004CD3O005A000100262800030023000100010004CD3O00230001002EA40012003C000100110004CD3O003C0001001204000400134O0062000500013O00122O000600143O00122O000700156O0005000700024O0004000400052O0062000500013O00122O000600163O00122O000700176O0005000700024O0004000400052O00DA00045O001204000400134O0062000500013O00122O000600183O00122O000700196O0005000700024O0004000400052O0062000500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400052O00DA000400023O00123A000300063O002EDC001C00190001001D0004CD3O00190001000E4900060019000100030004CD3O00190001001204000400134O0015010500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000400033O00122O000400136O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000400043O00122O0003000D3O00044O00190001002EA400260095000100270004CD3O0095000100267900020095000100280004CD3O00950001001204000300134O0062000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300042O0062000400013O00122O0005002B3O00122O0006002C6O0004000600024O0003000300040006530103006C000100010004CD3O006C000100123A000300014O00DA000300053O001204000300134O0062000400013O00122O0005002D3O00122O0006002E6O0004000600024O0003000300042O0062000400013O00122O0005002F3O00122O000600306O0004000600024O0003000300042O00DA000300063O001204000300134O0062000400013O00122O000500313O00122O000600326O0004000600024O0003000300042O0062000400013O00122O000500333O00122O000600346O0004000600024O0003000300042O00DA000300073O0012F7000300136O000400013O00122O000500353O00122O000600366O0004000600024O0003000300044O000400013O00122O000500373O00122O000600386O0004000600024O00030003000400062O00030093000100010004CD3O0093000100123A000300014O00DA000300083O00123A000200393O002679000200F20001003A0004CD3O00F2000100123A000300014O009C000400043O002EA4003C00990001003B0004CD3O00990001002EDC003E00990001003D0004CD3O0099000100267900030099000100010004CD3O0099000100123A000400013O002679000400CD000100010004CD3O00CD000100123A000500013O002679000500C4000100010004CD3O00C40001001204000600134O0062000700013O00122O0008003F3O00122O000900406O0007000900024O0006000600072O0062000700013O00122O000800413O00122O000900426O0007000900024O000600060007000653010600B3000100010004CD3O00B3000100123A000600434O00DA000600093O0012F7000600136O000700013O00122O000800443O00122O000900456O0007000900024O0006000600074O000700013O00122O000800463O00122O000900476O0007000900024O00060006000700062O000600C2000100010004CD3O00C2000100123A000600434O00DA0006000A3O00123A000500063O002E0E014800DFFF2O00480004CD3O00A30001002EA4004A00A3000100490004CD3O00A30001002679000500A3000100060004CD3O00A3000100123A000400063O0004CD3O00CD00010004CD3O00A30001002679000400EB000100060004CD3O00EB0001001204000500134O0062000600013O00122O0007004B3O00122O0008004C6O0006000800024O0005000500062O0062000600013O00122O0007004D3O00122O0008004E6O0006000800024O0005000500062O00DA0005000B3O0012F7000500136O000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O000600013O00122O000700513O00122O000800526O0006000800024O00050005000600062O000500E9000100010004CD3O00E9000100123A000500014O00DA0005000C3O00123A0004000D3O002679000400A00001000D0004CD3O00A0000100123A000200283O0004CD3O00F200010004CD3O00A000010004CD3O00F200010004CD3O00990001002628000200F6000100010004CD3O00F60001002EA4005400442O0100530004CD3O00442O0100123A000300014O009C000400043O002628000300FE000100010004CD3O00FE0001002ECA005500FE000100560004CD3O00FE0001002EDC005800F8000100570004CD3O00F8000100123A000400013O002679000400202O0100060004CD3O00202O01001204000500134O0062000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500062O0062000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500060006530105000F2O0100010004CD3O000F2O0100123A000500434O00DA0005000D3O0012F7000500136O000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O000600013O00122O0007005F3O00122O000800606O0006000800024O00050005000600062O0005001E2O0100010004CD3O001E2O0100123A000500014O00DA0005000E3O00123A0004000D3O0026790004003B2O0100010004CD3O003B2O01001204000500134O0062000600013O00122O000700613O00122O000800626O0006000800024O0005000500062O0062000600013O00122O000700633O00122O000800646O0006000800024O0005000500062O00DA0005000F3O001204000500134O0062000600013O00122O000700653O00122O000800666O0006000800024O0005000500062O0062000600013O00122O000700673O00122O000800686O0006000800024O0005000500062O00DA000500103O00123A000400063O002E0E016900C4FF2O00690004CD3O00FF0001002679000400FF0001000D0004CD3O00FF000100123A000200063O0004CD3O00442O010004CD3O00FF00010004CD3O00442O010004CD3O00F80001002628000200482O0100060004CD3O00482O01002EA4006B00B32O01006A0004CD3O00B32O0100123A000300014O009C000400043O002E0E016C3O0001006C0004CD3O004A2O01002EA4006D004A2O01006E0004CD3O004A2O01000E490001004A2O0100030004CD3O004A2O0100123A000400013O002EDC0070007D2O01006F0004CD3O007D2O010026790004007D2O0100060004CD3O007D2O0100123A000500013O002EA40072005E2O0100710004CD3O005E2O01002EA40074005E2O0100730004CD3O005E2O01000E490006005E2O0100050004CD3O005E2O0100123A0004000D3O0004CD3O007D2O01002679000500562O0100010004CD3O00562O01001204000600134O0062000700013O00122O000800753O00122O000900766O0007000900024O0006000600072O0062000700013O00122O000800773O00122O000900786O0007000900024O0006000600072O00DA000600113O0012F7000600136O000700013O00122O000800793O00122O0009007A6O0007000900024O0006000600074O000700013O00122O0008007B3O00122O0009007C6O0007000900024O00060006000700062O0006007A2O0100010004CD3O007A2O0100123A000600014O00DA000600123O00123A000500063O0004CD3O00562O01002EA4007D00812O01007E0004CD3O00812O01002628000400832O0100010004CD3O00832O01002E0E017F0027000100800004CD3O00A82O0100123A000500013O002628000500882O0100060004CD3O00882O01002E0E01810004000100820004CD3O008A2O0100123A000400063O0004CD3O00A82O010026280005008E2O0100010004CD3O008E2O01002EDC008400842O0100830004CD3O00842O01001204000600134O0015010700013O00122O000800853O00122O000900866O0007000900024O0006000600074O000700013O00122O000800873O00122O000900886O0007000900024O0006000600074O000600133O00122O000600136O000700013O00122O000800893O00122O0009008A6O0007000900024O0006000600074O000700013O00122O0008008B3O00122O0009008C6O0007000900024O0006000600074O000600143O00122O000500063O00044O00842O01002EA4008D00512O01008E0004CD3O00512O01002628000400AE2O01000D0004CD3O00AE2O01002EA4008F00512O0100900004CD3O00512O0100123A0002000D3O0004CD3O00B32O010004CD3O00512O010004CD3O00B32O010004CD3O004A2O01002E0E01910052000100910004CD3O0005020100267900020005020100920004CD3O0005020100123A000300013O002628000300BC2O0100060004CD3O00BC2O01002E0E01930021000100940004CD3O00DB2O01001204000400134O0062000500013O00122O000600953O00122O000700966O0005000700024O0004000400052O0062000500013O00122O000600973O00122O000700986O0005000700024O000400040005000653010400CA2O0100010004CD3O00CA2O0100123A000400014O00DA000400153O0012F7000400136O000500013O00122O000600993O00122O0007009A6O0005000700024O0004000400054O000500013O00122O0006009B3O00122O0007009C6O0005000700024O00040004000500062O000400D92O0100010004CD3O00D92O0100123A000400434O00DA000400163O00123A0003000D3O002E0E019D00230001009D0004CD3O00FE2O01000E49000100FE2O0100030004CD3O00FE2O01001204000400134O0062000500013O00122O0006009E3O00122O0007009F6O0005000700024O0004000400052O0062000500013O00122O000600A03O00122O000700A16O0005000700024O000400040005000653010400ED2O0100010004CD3O00ED2O0100123A000400434O00DA000400173O0012F7000400136O000500013O00122O000600A23O00122O000700A36O0005000700024O0004000400054O000500013O00122O000600A43O00122O000700A56O0005000700024O00040004000500062O000400FC2O0100010004CD3O00FC2O0100123A000400014O00DA000400183O00123A000300063O002EDC00A700B82O0100A60004CD3O00B82O01002679000300B82O01000D0004CD3O00B82O0100123A0002003A3O0004CD3O000502010004CD3O00B82O0100262800020009020100A80004CD3O00090201002EDC00A90040020100AA0004CD3O00400201001204000300134O0062000400013O00122O000500AB3O00122O000600AC6O0004000600024O0003000300042O0062000400013O00122O000500AD3O00122O000600AE6O0004000600024O0003000300042O00DA000300193O001204000300134O0062000400013O00122O000500AF3O00122O000600B06O0004000600024O0003000300042O0062000400013O00122O000500B13O00122O000600B26O0004000600024O0003000300042O00DA0003001A3O0012F7000300136O000400013O00122O000500B33O00122O000600B46O0004000600024O0003000300044O000400013O00122O000500B53O00122O000600B66O0004000600024O00030003000400062O0003002F020100010004CD3O002F020100123A000300014O00DA0003001B3O0012F7000300136O000400013O00122O000500B73O00122O000600B86O0004000600024O0003000300044O000400013O00122O000500B93O00122O000600BA6O0004000600024O00030003000400062O0003003E020100010004CD3O003E020100123A000300014O00DA0003001C3O00123A000200BB3O002EDC00720044020100BC0004CD3O0044020100262800020046020100BB0004CD3O00460201002EDC00BE0074020100BD0004CD3O00740201001204000300134O0062000400013O00122O000500BF3O00122O000600C06O0004000600024O0003000300042O0062000400013O00122O000500C13O00122O000600C26O0004000600024O00030003000400065301030054020100010004CD3O0054020100123A000300434O00DA0003001D3O0012F7000300136O000400013O00122O000500C33O00122O000600C46O0004000600024O0003000300044O000400013O00122O000500C53O00122O000600C66O0004000600024O00030003000400062O00030063020100010004CD3O0063020100123A000300434O00DA0003001E3O0012F7000300136O000400013O00122O000500C73O00122O000600C86O0004000600024O0003000300044O000400013O00122O000500C93O00122O000600CA6O0004000600024O00030003000400062O00030072020100010004CD3O0072020100123A000300014O00DA0003001F3O0004CD3O00EF0301002EDC00CB00C4020100CC0004CD3O00C40201002679000200C4020100390004CD3O00C4020100123A000300014O009C000400043O0026280003007E020100010004CD3O007E0201002EA400CD007A020100CE0004CD3O007A020100123A000400013O002679000400830201000D0004CD3O0083020100123A000200A83O0004CD3O00C40201002679000400A1020100010004CD3O00A10201001204000500134O0062000600013O00122O000700CF3O00122O000800D06O0006000800024O0005000500062O0062000600013O00122O000700D13O00122O000800D26O0006000800024O0005000500062O00DA000500203O0012F7000500136O000600013O00122O000700D33O00122O000800D46O0006000800024O0005000500064O000600013O00122O000700D53O00122O000800D66O0006000800024O00050005000600062O0005009F020100010004CD3O009F020100123A000500014O00DA000500213O00123A000400063O002EA400D7007F020100D80004CD3O007F02010026790004007F020100060004CD3O007F0201001204000500134O0062000600013O00122O000700D93O00122O000800DA6O0006000800024O0005000500062O0062000600013O00122O000700DB3O00122O000800DC6O0006000800024O0005000500062O00DA000500223O0012F7000500136O000600013O00122O000700DD3O00122O000800DE6O0006000800024O0005000500064O000600013O00122O000700DF3O00122O000800E06O0006000800024O00050005000600062O000500BF020100010004CD3O00BF020100123A000500014O00DA000500233O00123A0004000D3O0004CD3O007F02010004CD3O00C402010004CD3O007A0201002EDC00E10019030100E20004CD3O0019030100267900020019030100100004CD3O0019030100123A000300013O002EA400E300F9020100E40004CD3O00F90201002679000300F9020100060004CD3O00F9020100123A000400013O002EA400E600D2020100E50004CD3O00D20201002628000400D4020100010004CD3O00D40201002EDC00E800F0020100E70004CD3O00F00201001204000500134O0062000600013O00122O000700E93O00122O000800EA6O0006000800024O0005000500062O0062000600013O00122O000700EB3O00122O000800EC6O0006000800024O000500050006000653010500E2020100010004CD3O00E2020100123A000500014O00DA000500243O001204000500134O0062000600013O00122O000700ED3O00122O000800EE6O0006000800024O0005000500062O0062000600013O00122O000700EF3O00122O000800F06O0006000800024O0005000500062O00DA000500253O00123A000400063O000EA0000600F6020100040004CD3O00F60201002EDB00F100F6020100F20004CD3O00F60201002EA400F300CE020100830004CD3O00CE020100123A0003000D3O0004CD3O00F902010004CD3O00CE0201002679000300FD0201000D0004CD3O00FD020100123A000200F43O0004CD3O00190301002679000300C9020100010004CD3O00C90201001204000400134O0015010500013O00122O000600F53O00122O000700F66O0005000700024O0004000400054O000500013O00122O000600F73O00122O000700F86O0005000700024O0004000400054O000400263O00122O000400136O000500013O00122O000600F93O00122O000700FA6O0005000700024O0004000400054O000500013O00122O000600FB3O00122O000700FC6O0005000700024O0004000400054O000400273O00122O000300063O00044O00C90201002EDC00FD008E030100FE0004CD3O008E03010026790002008E030100FF0004CD3O008E030100123A000300013O00123A00042O00012O000E492O00015A030100040004CD3O005A030100123A0004002O012O00123A00050002012O0006D20005005A030100040004CD3O005A030100123A000400013O0006E40003005A030100040004CD3O005A030100123A000400013O00123A00050003012O00123A00060004012O0006FD00050036030100060004CD3O0036030100123A00050005012O00123A00060006012O0006FD00060036030100050004CD3O0036030100123A000500063O0006E400040036030100050004CD3O0036030100123A000300063O0004CD3O005A030100123A000500013O00064A0104003D030100050004CD3O003D030100123A00050007012O00123A000600713O0006D200060029030100050004CD3O00290301001204000500134O0062000600013O00122O00070008012O00122O00080009015O0006000800024O0005000500062O0062000600013O00122O0007000A012O00122O0008000B015O0006000800024O0005000500060006530105004B030100010004CD3O004B030100123A000500014O00DA000500283O001207010500136O000600013O00122O0007000C012O00122O0008000D015O0006000800024O0005000500064O000600013O00122O0007000E012O00122O0008000F015O0006000800024O0005000500064O000500293O00122O000400063O00044O0029030100123A0004000D3O00064A01030065030100040004CD3O0065030100123A00040010012O00123A00050011012O00068600040065030100050004CD3O0065030100123A00040012012O00123A00050013012O0006FD00040067030100050004CD3O0067030100123A000200923O0004CD3O008E030100123A000400063O00064A0103006E030100040004CD3O006E030100123A00040014012O00123A00050015012O0006FD0004001E030100050004CD3O001E0301001204000400134O0062000500013O00122O00060016012O00122O00070017015O0005000700024O0004000400052O0062000500013O00122O00060018012O00122O00070019015O0005000700024O0004000400050006530104007C030100010004CD3O007C030100123A000400014O00DA0004002A3O0012F7000400136O000500013O00122O0006001A012O00122O0007001B015O0005000700024O0004000400054O000500013O00122O0006001C012O00122O0007001D015O0005000700024O00040004000500062O0004008B030100010004CD3O008B030100123A000400434O00DA0004002B3O00123A0003000D3O0004CD3O001E030100123A000300F43O00064A01020095030100030004CD3O0095030100123A0003001E012O00123A0004001F012O0006D200030016000100040004CD3O0016000100123A000300013O00123A00040020012O00123A00050021012O0006D20004009D030100050004CD3O009D030100123A000400013O00064A010300A1030100040004CD3O00A1030100123A00040022012O00123A00050023012O0006D2000400C0030100050004CD3O00C00301001204000400134O0062000500013O00122O00060024012O00122O00070025015O0005000700024O0004000400052O0062000500013O00122O00060026012O00122O00070027015O0005000700024O000400040005000653010400AF030100010004CD3O00AF030100123A000400014O00DA0004002C3O0012F7000400136O000500013O00122O00060028012O00122O00070029015O0005000700024O0004000400054O000500013O00122O0006002A012O00122O0007002B015O0005000700024O00040004000500062O000400BE030100010004CD3O00BE030100123A000400014O00DA0004002D3O00123A000300063O00123A0004002C012O00123A0005002D012O0006FD000500C7030100040004CD3O00C7030100123A000400063O00064A010300CB030100040004CD3O00CB030100123A0004002E012O00123A0005002F012O0006D2000500E4030100040004CD3O00E40301001204000400134O0062000500013O00122O00060030012O00122O00070031015O0005000700024O0004000400052O0062000500013O00122O00060032012O00122O00070033015O0005000700024O0004000400052O00DA0004002E3O001204000400134O0062000500013O00122O00060034012O00122O00070035015O0005000700024O0004000400052O0062000500013O00122O00060036012O00122O00070037015O0005000700024O0004000400052O00DA0004002F3O00123A0003000D3O00123A0004000D3O0006E400030096030100040004CD3O0096030100123A000200FF3O0004CD3O001600010004CD3O009603010004CD3O001600010004CD3O00EF03010004CD3O000F00010004CD3O00EF03010004CD3O000200012O00013O00017O007B012O00028O00026O00F03F025O0048AB40025O00208E40025O0023B040025O00707C40026O000840030F3O00412O66656374696E67436F6D626174025O004CA540025O00E2B140025O000FB240025O00E09B40025O00108140025O00BC9040025O00FEB240025O0072AC40025O00308640025O0014AC40025O00707540025O00C49640027O0040025O0044A640025O00288F4003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B025O00B4AF40025O00D49540030C3O00526573752O72656374696F6E030C3O00D72AEBBCEA6F0EC63BF1A6F603073O006BA54F98C9981D025O0054B040025O0096B140025O00A06240025O00E88B40025O00208D40025O00F4A34003123O00F5CC90B2BDF2CC95B389CAD193BEBBD0C78203053O00CFA5A3E7D7030A3O0049734361737461626C6503083O0042752O66446F776E03163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E67025O00349040025O00489B4003183O00506F776572576F7264466F72746974756465506C61796572025O00509940025O00BEAD4003143O00D6F6EE53364FD1F6EB521B76C9EBED5F3065C2FC03063O0010A62O993644025O0034AD40025O00D8AC40025O00DCAD40025O00B88940025O00907340025O00788C40030F3O0048616E646C65412O666C6963746564030D3O005075726966794469736561736503163O00507572696679446973656173654D6F7573656F766572026O004440025O0062B340025O0094A840025O008EA740025O0002A040025O00E88240025O00608840025O00B07D40025O0032B040025O00B09240025O0080734003123O00E2BCD7432616F6C0B7E6492635F0C6A6C44303073O0099B2D3A0265441025O00405E40025O0020604003143O0092044D2E90344D24900F652D8D194E22961E5E2E03043O004BE26B3A030A3O006BD6107E1ED5CB57CC1C03073O00AD38BE711A71A2030E3O00536861646F77666F726D42752O66025O0014A040025O005EB340025O007C9B40030A3O00536861646F77666F726D025O00B88E40025O00C8A940030A3O00D8D62C01F8DCD82217FA03053O0097ABBE4D65025O00BFB140025O00607640025O002O9C40025O00188140025O006DB340025O0090954003083O0049734D6F76696E67025O004C9F40025O00E08540025O00A07F40025O0010AC40025O0080A240025O00A88040025O008AA540026O00AF40025O00608940025O00389D40030D3O00546172676574497356616C6964025O00B08840025O00A08740025O0062AE40024O0080B3C540030C3O00466967687452656D61696E7303113O0054696D6553696E63654C61737443617374026O002E4003103O00426F2O73466967687452656D61696E73025O000C9640025O00A8A24003063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O6603103O007A47E6CF72735657C1C5477E5947FCD203063O001F372E88AB3403083O00FC21D2F0F724DDED03043O0094B148BC2O033O00474344026O00D03F025O00406D40025O0012AE40025O003AAC40025O00D4A540025O0022AE40025O00C9B240025O00249F40025O00A3B240025O009FB040025O00CC9040025O0018AB4003043O00502O6F6C030F3O00EC50C3BD6F1DE8F39C72CDB82153AE03083O0081BC3FACD14F7B87025O00805840025O0052A240025O00AEB240025O00606840025O00C9B040025O006C9340025O00E88740025O00AAAB40025O00E06440025O006CB140025O00C8AD40025O0012A840025O00D6AE40025O00FC9140025O00EC9B40025O00F2A140025O0036AC40025O0011B340025O00688040025O0010A640025O0016A140025O00D2AD40025O0082A340025O00709E40025O0086AD40025O00F08040025O00C07A40025O00C88E40025O0010A740025O00F88F40025O0050B040025O0060A840025O00508140025O0034AB40025O003EB240025O00A08540025O00F89740025O00AC9140025O00805240025O009AAB40025O00405240025O00108340025O00E49940025O00EEA940025O00E09540025O00F89C4003113O0048616E646C65496E636F72706F7265616C030C3O00446F6D696E6174654D696E6403153O00446F6D696E6174654D696E644D6F7573656F766572026O003E40025O00409940025O00588F40030D3O00536861636B6C65556E6465616403163O00536861636B6C65556E646561644D6F7573656F766572025O0028A640025O002AAA40030C3O0090B95ED783A442C3B2BF58DD03043O00B3C6D637030F3O00432O6F6C646F776E52656D61696E73030C3O00C6037B7260C1E51C667F4ADD03063O00B3906C121625030B3O004973417661696C61626C65030D3O00E2A20982EED5A01E87DCCFAC1503053O00AFA6C37BE9030A3O00432O6F6C646F776E5570030D3O00CBC34F42D1FCC15847E3E6CD5303053O00908FA23D29030B3O00D6DC1454468821F2D6134403073O005380B37D3012E7030B3O006DA4EADE4F175E9BFAD34C03063O007E3DD793BD27030B3O004EF014414CF00F577DF10903043O0025189F7D026O001040030C3O00566F6964666F726D42752O6600025O00B0AC40025O00F88A40025O00FEAF40025O00188E4003043O0047554944025O00F1B240025O0032B140025O00208340025O00E89040030B3O00DC01D64DC7F425C45ACBFB03053O00A29868A53D03073O004973526561647903093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66025O0078AD40025O00689540025O00A4A540025O00A4AB40030B3O0044697370656C4D61676963030E3O0049735370652O6C496E52616E676503133O00C926A16D75E9F222B37A79E68D2BB37071E2C803063O0085AD4FD21D10025O00A6A940026O007340025O00A06940025O00989440025O00BCA040025O00409A40025O00688740025O00709F40025O00A06A40025O001AA540025O00CC9F40025O00A4B140025O004CA240025O00907D40025O00C88740025O00C4A240025O00EAAA40026O006440025O00BCAB40025O00789640025O0060AA40030E3O00BD73E227CD7AE239CD5DE20EC53503043O004BED1C8D025O00E09C40025O00BEAB40025O00CBB240025O00E49440025O00F4AA4003113O00EAA97A4E9AA07A509A896547D4A3670A9303043O0022BAC615025O009CAA40025O00C6A440025O00688940025O00C3B140025O00804B40025O00DAAF40025O0028A340025O007AAC40025O0007B340025O00A0A240025O00E08940025O0044AB40025O0024B240025O004EB240025O005AA140025O0034A140025O00289E4003093O00496E74652O7275707403073O0053696C656E6365025O00C0714003103O0053696C656E63654D6F7573656F766572025O0020A340025O00C4984003113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O002040025O004CAC40025O00B8B040025O0004AF40025O00107240025O0079B240025O00949240025O00C89F40025O00C08E40025O0048B040025O00D89A40025O00FCAE40025O00D081402O033O00414F45025O0096A240025O002CA840025O00D6AF40025O006DB240031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74026O002440025O009EA840025O00049D40026O00974003073O0047657454696D65025O00DEA440025O00A8B140025O0086B140025O00708340025O00049640025O00188040025O0022A040025O002EB240025O001C9140025O0038814003063O00CE6717D6F86B03043O00BF9E126503093O00466F637573556E6974025O003AAA40025O00388240025O00E8B140025O005EA340025O009AA040025O00C6A340025O00649B40025O007C9040025O00C49E40025O00DAB240025O0020B040025O0046AE40025O00849440025O00F4B140025O00B0A040025O00E07F40025O0039B040025O00588D40025O0092A240025O0050A340030C3O004570696353652O74696E677303073O00CE2133434B3CA403083O00549A4E54242759D72O033O00FEE54503053O00659D81363803073O0029A68DAC2F7C0E03063O00197DC9EACB4303063O007DFD0B13112B03073O0073199478637447025O0090A340025O0030AC4003073O004CA244A374A85003043O00C418CD232O033O002184E003043O00664EEB83025O0098A540025O0018A740025O00F0A84003113O00476574456E656D696573496E52616E676503173O00476574456E656D696573496E53706C61736852616E6765025O00A7B240025O0012AB40025O00FEAC40025O00B07F4003073O003832BE234D092E03053O00216C5DD94403043O00D34EA0A103043O00CDBB2BC1025O00949040025O00C055400046062O00123A3O00014O009C000100023O000E490002003A06013O0004CD3O003A060100262800010008000100010004CD3O00080001002EA400030004000100040004CD3O0004000100123A000200013O002EDC000600C7040100050004CD3O00C70401002679000200C7040100070004CD3O00C704012O00CB00035O0020570103000300082O002901030002000200065301030015000100010004CD3O001500012O00CB000300013O00065301030017000100010004CD3O00170001002E0E010900052O01000A0004CD3O001A2O0100123A000300014O009C000400053O0026280003001D000100010004CD3O001D0001002E0E010B00050001000C0004CD3O0020000100123A000400014O009C000500053O00123A000300023O002EA4000D00190001000E0004CD3O0019000100267900030019000100020004CD3O001900010026280004002A000100010004CD3O002A0001002ECA000F002A000100100004CD3O002A0001002EA400120024000100110004CD3O0024000100123A000500013O002EDC00130059000100140004CD3O0059000100267900050059000100150004CD3O00590001002EDC0017001A2O0100160004CD3O001A2O012O00CB000600023O0006F50006001A2O013O0004CD3O001A2O012O00CB000600023O0020570106000600182O00290106000200020006F50006001A2O013O0004CD3O001A2O012O00CB000600023O0020570106000600192O00290106000200020006F50006001A2O013O0004CD3O001A2O012O00CB000600023O00205701060006001A2O00290106000200020006F50006001A2O013O0004CD3O001A2O012O00CB00065O00205701060006001B2O00CB000800024O00060006000800020006530106001A2O0100010004CD3O001A2O01002EA4001D001A2O01001C0004CD3O001A2O012O00CB000600034O008D000700043O00202O00070007001E4O000800086O000900016O00060009000200062O0006001A2O013O0004CD3O001A2O012O00CB000600053O0012180007001F3O00122O000800206O000600086O00065O00044O001A2O01002EA4002100B5000100220004CD3O00B50001000E49000100B5000100050004CD3O00B5000100123A000600013O00267900060062000100020004CD3O0062000100123A000500023O0004CD3O00B5000100262800060066000100010004CD3O00660001002E0E012300FAFF2O00240004CD3O005E0001002EDC00250093000100260004CD3O009300012O00CB000700045O00010800053O00122O000900273O00122O000A00286O0008000A00024O00070007000800202O0007000700294O00070002000200062O0007009300013O0004CD3O009300012O00CB000700063O0006F50007009300013O0004CD3O009300012O00CB00075O0020B700070007002A4O000900043O00202O00090009002B4O000A00016O0007000A000200062O00070084000100010004CD3O008400012O00CB000700073O00207200070007002C4O000800043O00202O00080008002B4O00070002000200062O0007009300013O0004CD3O00930001002EDC002D008C0001002E0004CD3O008C00012O00CB000700034O00CB000800083O00208900080008002F2O00290107000200020006530107008E000100010004CD3O008E0001002EDC00310093000100300004CD3O009300012O00CB000700053O00123A000800323O00123A000900334O000F000700094O004B00075O002EA4003500B3000100340004CD3O00B300012O00CB000700093O0006F5000700B300013O0004CD3O00B3000100123A000700013O000EA00001009F000100070004CD3O009F0001002E690036009F000100370004CD3O009F0001002EDC00390099000100380004CD3O009900012O00CB000800073O0020FF00080008003A4O000900043O00202O00090009003B4O000A00083O00202O000A000A003C00122O000B003D6O0008000B00024O0008000A6O0008000A3O00062O000800AF000100010004CD3O00AF0001002EDB003E00AF0001003F0004CD3O00AF0001002EA4004000B3000100410004CD3O00B300012O00CB0008000A4O005A010800023O0004CD3O00B300010004CD3O0099000100123A000600023O0004CD3O005E0001002628000500B9000100020004CD3O00B90001002E0E01420074FF2O00430004CD3O002B000100123A000600013O002628000600BE000100010004CD3O00BE0001002EDC0045000C2O0100440004CD3O000C2O01002EDC004700E6000100460004CD3O00E600012O00CB000700045O00010800053O00122O000900483O00122O000A00496O0008000A00024O00070007000800202O0007000700294O00070002000200062O000700D900013O0004CD3O00D900012O00CB00075O0020B700070007002A4O000900043O00202O00090009002B4O000A00016O0007000A000200062O000700DB000100010004CD3O00DB00012O00CB000700073O00208100070007002C4O000800043O00202O00080008002B4O00070002000200062O000700DB000100010004CD3O00DB0001002EA4004B00E60001004A0004CD3O00E600012O00CB000700034O00CB000800083O00208900080008002F2O00290107000200020006F5000700E600013O0004CD3O00E600012O00CB000700053O00123A0008004C3O00123A0009004D4O000F000700094O004B00076O00CB000700045O00010800053O00122O0009004E3O00122O000A004F6O0008000A00024O00070007000800202O0007000700294O00070002000200062O000700FA00013O0004CD3O00FA00012O00CB00075O0020F100070007002A4O000900043O00202O0009000900504O00070009000200062O000700FA00013O0004CD3O00FA00012O00CB0007000B3O000653010700FC000100010004CD3O00FC0001002EDC0052000B2O0100510004CD3O000B2O01002E0E01530008000100530004CD3O00042O012O00CB000700034O00CB000800043O0020890008000800542O0029010700020002000653010700062O0100010004CD3O00062O01002E0E01550007000100560004CD3O000B2O012O00CB000700053O00123A000800573O00123A000900584O000F000700094O004B00075O00123A000600023O002628000600122O0100020004CD3O00122O01002EDB005900122O01005A0004CD3O00122O01002EA4005B00BA0001005C0004CD3O00BA000100123A000500153O0004CD3O002B00010004CD3O00BA00010004CD3O002B00010004CD3O001A2O010004CD3O002400010004CD3O001A2O010004CD3O00190001002EDC005E00482O01005D0004CD3O00482O012O00CB00035O00205701030003005F2O00290103000200020006F5000300482O013O0004CD3O00482O012O00CB00035O0020570103000300082O0029010300020002000653010300292O0100010004CD3O00292O012O00CB000300013O0006F5000300482O013O0004CD3O00482O0100123A000300014O009C000400043O002E0E01600004000100600004CD3O002F2O01002628000300312O0100010004CD3O00312O01002EDC0061002B2O0100620004CD3O002B2O0100123A000400013O002E0E01633O000100630004CD3O00322O01000EA0000100382O0100040004CD3O00382O01002E0E010700FCFF2O00640004CD3O00322O012O00CB0005000C4O00640005000100022O00DA0005000A3O002E0E0165000D000100650004CD3O00482O012O00CB0005000A3O000653010500422O0100010004CD3O00422O01002EDC006700482O0100660004CD3O00482O012O00CB0005000A4O005A010500023O0004CD3O00482O010004CD3O00322O010004CD3O00482O010004CD3O002B2O01002EA4006800CF2O0100690004CD3O00CF2O012O00CB000300073O00208900030003006A2O0064000300010002000653010300542O0100010004CD3O00542O012O00CB00035O0020570103000300082O00290103000200020006F5000300CF2O013O0004CD3O00CF2O0100123A000300013O002679000300752O0100020004CD3O00752O0100123A000400013O0026280004005C2O0100020004CD3O005C2O01002EA4006B005E2O01006C0004CD3O005E2O0100123A000300153O0004CD3O00752O01002679000400582O0100010004CD3O00582O01002E0E016D000B0001006D0004CD3O006B2O012O00CB0005000D3O0026790005006B2O01006E0004CD3O006B2O012O00CB0005000E3O00202200050005006F4O0006000F6O00078O0005000700024O0005000D4O00CB000500113O0020570105000500702O002901050002000200266E000500712O0100710004CD3O00712O012O003201056O00A3000500014O00DA000500103O00123A000400023O0004CD3O00582O01002679000300802O0100010004CD3O00802O012O00CB0004000E3O00200C0104000400724O000500056O000600016O0004000600024O000400126O000400126O0004000D3O00122O000300023O002EDC007300A92O0100740004CD3O00A92O01002679000300A92O0100070004CD3O00A92O012O00CB00045O0020F10004000400754O000600043O00202O0006000600764O00040006000200062O000400932O013O0004CD3O00932O012O00CB000400044O0062000500053O00122O000600773O00122O000700786O0005000700024O000400040005000653010400992O0100010004CD3O00992O012O00CB000400044O0062000500053O00122O000600793O00122O0007007A6O0005000700024O0004000400052O00DA000400134O0036000400156O00055O00202O00050005007B4O00050002000200122O0006007C6O0004000600024O000500166O00065O00202O00060006007B4O00060002000200122O0007007C6O0005000700024O0004000400054O000400143O00044O00CF2O01000E49001500552O0100030004CD3O00552O0100123A000400013O002EDC007D00C72O01007E0004CD3O00C72O01002679000400C72O0100010004CD3O00C72O0100123A000500013O002E0E017F00110001007F0004CD3O00C22O01002679000500C22O0100010004CD3O00C22O012O00CB000600113O00202E0006000600704O00060002000200102O0006007100064O000600173O002E2O008000C12O0100810004CD3O00C12O012O00CB000600173O00263B000600C12O0100010004CD3O00C12O0100123A000600014O00DA000600173O00123A000500023O002679000500B12O0100020004CD3O00B12O0100123A000400023O0004CD3O00C72O010004CD3O00B12O01002EDC008300AC2O0100820004CD3O00AC2O01000E49000200AC2O0100040004CD3O00AC2O0100123A000300073O0004CD3O00552O010004CD3O00AC2O010004CD3O00552O012O00CB000300073O00208900030003006A2O00640003000100020006F50003004506013O0004CD3O0045060100123A000300014O009C000400043O002E0E01840004000100840004CD3O00DA2O01002628000300DC2O0100010004CD3O00DC2O01002EA4008500D62O0100860004CD3O00D62O0100123A000400013O002E0E01870010000100870004CD3O00ED2O01002679000400ED2O0100020004CD3O00ED2O012O00CB000500034O00CB000600043O0020890006000600882O00290105000200020006F50005004506013O0004CD3O004506012O00CB000500053O001218000600893O00122O0007008A6O000500076O00055O00044O00450601002628000400F32O0100010004CD3O00F32O01002ECA008C00F32O01008B0004CD3O00F32O01002EDC008D00DD2O01008E0004CD3O00DD2O0100123A000500013O002EDC009000FA2O01008F0004CD3O00FA2O01002679000500FA2O0100020004CD3O00FA2O0100123A000400023O0004CD3O00DD2O01002EA4009100F42O0100920004CD3O00F42O01002679000500F42O0100010004CD3O00F42O0100123A000600013O002679000600B8040100010004CD3O00B80401002EA40093002D020100940004CD3O002D02012O00CB00075O0020570107000700082O00290107000200020006530107002D020100010004CD3O002D02012O00CB000700013O0006F50007002D02013O0004CD3O002D020100123A000700014O009C000800093O00262800070013020100010004CD3O00130201002E6900950013020100960004CD3O00130201002EDC00970016020100980004CD3O0016020100123A000800014O009C000900093O00123A000700023O0026790007000D020100020004CD3O000D020100267900080018020100010004CD3O0018020100123A000900013O002EA40099001B0201009A0004CD3O001B02010026790009001B020100010004CD3O001B02012O00CB000A00184O0064000A000100022O00DA000A000A4O00CB000A000A3O0006F5000A002D02013O0004CD3O002D02012O00CB000A000A4O005A010A00023O0004CD3O002D02010004CD3O001B02010004CD3O002D02010004CD3O001802010004CD3O002D02010004CD3O000D02012O00CB00075O0020570107000700082O002901070002000200065301070039020100010004CD3O003902012O00CB000700013O00065301070039020100010004CD3O00390201002E69009C00390201009B0004CD3O00390201002EDC009E00B70401009D0004CD3O00B7040100123A000700014O009C000800083O002EDC009F003F020100A00004CD3O003F020100262800070041020100010004CD3O00410201002EA400A1003B020100A20004CD3O003B020100123A000800013O002E0E01A30011000100A30004CD3O0053020100267900080053020100070004CD3O005302012O00CB000900194O00640009000100022O00DA0009000A3O002E0E01A4006E020100A40004CD3O00B70401002EA400A500B7040100A60004CD3O00B704012O00CB0009000A3O0006F5000900B704013O0004CD3O00B704012O00CB0009000A4O005A010900023O0004CD3O00B70401000E490002000E030100080004CD3O000E030100123A000900013O0026790009005A020100150004CD3O005A020100123A000800153O0004CD3O000E0301002EA400A8005E020100A70004CD3O005E020100262800090060020100010004CD3O00600201002EDC00A900AC020100AA0004CD3O00AC0201002EA400AB00A9020100AC0004CD3O00A902012O00CB000A001A3O0006F5000A00A902013O0004CD3O00A9020100123A000A00014O009C000B000B3O002628000A006B020100010004CD3O006B0201002EA400AD0067020100AE0004CD3O0067020100123A000B00013O002EA400B00090020100AF0004CD3O00900201002679000B0090020100010004CD3O0090020100123A000C00013O002EA400B10075020100B20004CD3O00750201002628000C0077020100020004CD3O00770201002E0E01B30004000100B40004CD3O0079020100123A000B00023O0004CD3O00900201002EDC00B5007D020100B60004CD3O007D0201002628000C007F020100010004CD3O007F0201002EDC00B80071020100B70004CD3O007102012O00CB000D00073O002068000D000D00B94O000E00043O00202O000E000E00BA4O000F00083O00202O000F000F00BB00122O001000BC6O001100016O000D001100024O000D000A6O000D000A3O00062O000D008E02013O0004CD3O008E02012O00CB000D000A4O005A010D00023O00123A000C00023O0004CD3O00710201000EA0000200940201000B0004CD3O00940201002E0E01BD00DAFF2O00BE0004CD3O006C02012O00CB000C00073O002022010C000C00B94O000D00043O00202O000D000D00BF4O000E00083O00202O000E000E00C000122O000F00BC6O001000016O000C001000024O000C000A6O000C000A3O000653010C00A3020100010004CD3O00A30201002EA400C200A9020100C10004CD3O00A902012O00CB000C000A4O005A010C00023O0004CD3O00A902010004CD3O006C02010004CD3O00A902010004CD3O006702012O00A3000A6O00DA000A001B3O00123A000900023O00267900090056020100020004CD3O005602012O00CB000A00044O0062000B00053O00122O000C00C33O00122O000D00C46O000B000D00024O000A000A000B0020BD000A000A00C54O000A000200024O000B5O00202O000B000B007B4O000B0002000200202O000B000B000700062O000A00C60201000B0004CD3O00C602012O00CB000A00044O0040010B00053O00122O000C00C63O00122O000D00C76O000B000D00024O000A000A000B00202O000A000A00C84O000A0002000200062O000A2O00030100010004CD4O0003012O00CB000A00045O00010B00053O00122O000C00C93O00122O000D00CA6O000B000D00024O000A000A000B00202O000A000A00CB4O000A0002000200062O000A00DA02013O0004CD3O00DA02012O00CB000A00044O0040010B00053O00122O000C00CC3O00122O000D00CD6O000B000D00024O000A000A000B00202O000A000A00C84O000A0002000200062O000A2O00030100010004CD4O0003012O00CB000A00045O00010B00053O00122O000C00CE3O00122O000D00CF6O000B000D00024O000A000A000B00202O000A000A00C84O000A0002000200062O000A2O0003013O0004CD4O0003012O00CB000A00045O00010B00053O00122O000C00D03O00122O000D00D16O000B000D00024O000A000A000B00202O000A000A00C84O000A0002000200062O000A2O0003013O0004CD4O0003012O00CB000A00044O0062000B00053O00122O000C00D23O00122O000D00D36O000B000D00024O000A000A000B002057010A000A00C52O0029010A000200020026BA000A00FE020100D40004CD3O00FE02012O00CB000A5O00207C000A000A002A4O000C00043O00202O000C000C00D54O000A000C000200045O0003012O0032010A6O00A3000A00014O00DA000A001C4O00CB000A001D3O002628000A0008030100D60004CD3O00080301002ECA00D70008030100D80004CD3O00080301002E0E01D90006000100DA0004CD3O000C03012O00CB000A00023O002057010A000A00DB2O0029010A000200022O00DA000A001D3O00123A000900153O0004CD3O00560201002EA400DD0024040100DC0004CD3O00240401002EDC00DE0024040100DF0004CD3O0024040100267900080024040100150004CD3O0024040100123A000900013O00267900090099030100020004CD3O009903012O00CB000A00045O00010B00053O00122O000C00E03O00122O000D00E16O000B000D00024O000A000A000B00202O000A000A00E24O000A0002000200062O000A003703013O0004CD3O003703012O00CB000A001E3O0006F5000A003703013O0004CD3O003703012O00CB000A001F3O0006F5000A003703013O0004CD3O003703012O00CB000A5O002057010A000A00E32O0029010A00020002000653010A0037030100010004CD3O003703012O00CB000A5O002057010A000A00E42O0029010A00020002000653010A0037030100010004CD3O003703012O00CB000A00073O002089000A000A00E52O00CB000B00024O0029010A00020002000653010A0039030100010004CD3O00390301002EA400E6004C030100E70004CD3O004C0301002EDC00E8004C030100E90004CD3O004C03012O00CB000A00034O0044010B00043O00202O000B000B00EA4O000C00023O00202O000C000C00EB4O000E00043O00202O000E000E00EA4O000C000E00024O000C000C6O000A000C000200062O000A004C03013O0004CD3O004C03012O00CB000A00053O00123A000B00EC3O00123A000C00ED4O000F000A000C4O004B000A6O00CB000A00203O000E58011500590301000A0004CD3O005903012O00CB000A00213O000E2A000700570301000A0004CD3O005703012O00CB000A5O002057010A000A00082O0029010A00020002000653010A0059030100010004CD3O00590301002EA400EE0098030100EF0004CD3O0098030100123A000A00014O009C000B000B3O002EDC00F0005B030100F10004CD3O005B0301002E0E01F200FEFF2O00F20004CD3O005B0301002679000A005B030100010004CD3O005B030100123A000B00013O002628000B0066030100010004CD3O00660301002EDC00F3007F030100F40004CD3O007F030100123A000C00013O002679000C0076030100010004CD3O007603012O00CB000D00224O0064000D000100022O00DA000D000A4O00CB000D000A3O000653010D0073030100010004CD3O00730301002E6900F50073030100F60004CD3O00730301002EA400F70075030100F80004CD3O007503012O00CB000D000A4O005A010D00023O00123A000C00023O002EA400FA007A030100F90004CD3O007A0301000EA00002007C0301000C0004CD3O007C0301002EDC00FC0067030100FB0004CD3O0067030100123A000B00023O0004CD3O007F03010004CD3O00670301002628000B0083030100020004CD3O00830301002E0E01FD00E1FF2O00FE0004CD3O00620301002EA400FF008B03012O000104CD3O008B03012O00CB000C00034O00CB000D00043O002089000D000D00882O0029010C00020002000653010C008F030100010004CD3O008F030100123A000C002O012O00123A000D0002012O0006E4000C00980301000D0004CD3O009803012O00CB000C00053O001218000D0003012O00122O000E0004015O000C000E6O000C5O00044O009803010004CD3O006203010004CD3O009803010004CD3O005B030100123A000900153O00123A000A00013O0006E40009001A0401000A0004CD3O001A04012O00CB000A00234O00A3000B5O0006E4000A00AF0301000B0004CD3O00AF03012O00CB000A00013O0006F5000A00AF03013O0004CD3O00AF03012O00CB000A00023O002057010A000A00DB2O0029010A000200022O00CB000B001D3O0006E4000A00AF0301000B0004CD3O00AF03012O00CB000A00244O00CB000B00024O00A3000C00014O0006000A000C00020006F5000A00B303013O0004CD3O00B3030100123A000A0005012O00123A000B0006012O0006D2000B00EC0301000A0004CD3O00EC030100123A000A00014O009C000B000B3O00123A000C00013O00064A010A00BC0301000C0004CD3O00BC030100123A000C0007012O00123A000D0008012O0006FD000C00B50301000D0004CD3O00B5030100123A000B00013O00123A000C00233O00123A000D0009012O0006D2000C00D00301000D0004CD3O00D0030100123A000C00023O0006E4000B00D00301000C0004CD3O00D003012O00CB000C00034O00CB000D00043O002089000D000D00882O0029010C000200020006F5000C00EE03013O0004CD3O00EE03012O00CB000C00053O001218000D000A012O00122O000E000B015O000C000E6O000C5O00044O00EE030100123A000C00013O00064A010B00DB0301000C0004CD3O00DB030100123A000C000C012O00123A000D000D012O000686000C00DB0301000D0004CD3O00DB030100123A000C000E012O00123A000D000F012O0006D2000D00BD0301000C0004CD3O00BD03012O00CB000C00254O0064000C000100022O00DA000C000A4O00CB000C000A3O000653010C00E5030100010004CD3O00E5030100123A000C0010012O00123A000D0011012O0006E4000C00E70301000D0004CD3O00E703012O00CB000C000A4O005A010C00023O00123A000B00023O0004CD3O00BD03010004CD3O00EE03010004CD3O00B503010004CD3O00EE03012O00A3000A00014O00DA000A00233O00123A000A0012012O00123A000B0013012O0006D2000A00190401000B0004CD3O0019040100123A000A00FE3O00123A000B00FE3O0006E4000A00190401000B0004CD3O001904012O00CB000A00263O0006F5000A001904013O0004CD3O001904012O00CB000A00273O0006F5000A001904013O0004CD3O0019040100123A000A00014O009C000B000B3O00123A000C0014012O00123A000D0014012O0006E4000C00FE0301000D0004CD3O00FE030100123A000C00013O0006E4000A00FE0301000C0004CD3O00FE030100123A000B00013O00123A000C00013O0006E4000B00060401000C0004CD3O000604012O00CB000C00284O0064000C000100022O00DA000C000A4O00CB000C000A3O000653010C0013040100010004CD3O0013040100123A000C0015012O00123A000D0016012O0006D2000C00190401000D0004CD3O001904012O00CB000C000A4O005A010C00023O0004CD3O001904010004CD3O000604010004CD3O001904010004CD3O00FE030100123A000900023O00123A000A00153O00064A010900210401000A0004CD3O0021040100123A000A0017012O00123A000B00813O0006FD000B00150301000A0004CD3O0015030100123A000800073O0004CD3O002404010004CD3O0015030100123A000900013O0006E400080042020100090004CD3O004202012O00CB000900294O00240009000100024O0009000A3O00122O00090018012O00122O000A0019012O00062O000900330401000A0004CD3O003304012O00CB0009000A3O0006F50009003304013O0004CD3O003304012O00CB0009000A4O005A010900023O00123A0009001A012O00123A000A001B012O0006FD000A0085040100090004CD3O008504012O00CB00095O0020570109000900E32O002901090002000200065301090041040100010004CD3O004104012O00CB00095O0020570109000900E42O00290109000200020006F50009004504013O0004CD3O0045040100123A0009001C012O00123A000A0017012O0006E4000900850401000A0004CD3O008504012O00CB000900073O0012CF000A001D015O00090009000A4O000A00043O00122O000B001E015O000A000A000B00122O000B00BC6O000C00016O0009000C00024O0009000A3O00122O0009001F012O00123A000A001F012O0006E4000900580401000A0004CD3O005804012O00CB0009000A3O0006F50009005804013O0004CD3O005804012O00CB0009000A4O005A010900024O00CB000900073O001287000A001D015O00090009000A4O000A00043O00122O000B001E015O000A000A000B00122O000B00BC6O000C00016O000D002A6O000E00083O00122O000F0020013O001A010E000E000F2O00FA0009000E00024O0009000A3O00122O00090021012O00122O000A0022012O00062O000A006F040100090004CD3O006F04012O00CB0009000A3O0006F50009006F04013O0004CD3O006F04012O00CB0009000A4O005A010900024O00CB000900073O001271000A0023015O00090009000A4O000A00043O00122O000B0024015O000A000A000B00122O000B0025015O0009000B00024O0009000A3O00122O00090026012O00122O000A0027012O00062O000900850401000A0004CD3O0085040100123A00090028012O00123A000A0029012O0006D2000A0085040100090004CD3O008504012O00CB0009000A3O0006F50009008504013O0004CD3O008504012O00CB0009000A4O005A010900023O00123A0009002A012O00123A000A002A012O0006E4000900B30401000A0004CD3O00B304012O00CB000900093O0006F5000900B304013O0004CD3O00B3040100123A000900014O009C000A000A3O00123A000B002B012O00123A000C002B012O0006E4000B008E0401000C0004CD3O008E040100123A000B00013O0006E40009008E0401000B0004CD3O008E040100123A000A00013O00123A000B002C012O00123A000C002D012O0006D2000C00960401000B0004CD3O0096040100123A000B00013O0006E4000A00960401000B0004CD3O009604012O00CB000B00073O0020FF000B000B003A4O000C00043O00202O000C000C003B4O000D00083O00202O000D000D003C00122O000E003D6O000B000E00024O000B000A6O000B000A3O00062O000B00AD040100010004CD3O00AD040100123A000B002E012O00123A000C002F012O0006FD000B00B30401000C0004CD3O00B304012O00CB000B000A4O005A010B00023O0004CD3O00B304010004CD3O009604010004CD3O00B304010004CD3O008E040100123A000800023O0004CD3O004202010004CD3O00B704010004CD3O003B020100123A000600023O00123A00070030012O00123A00080031012O0006FD000800FF2O0100070004CD3O00FF2O0100123A000700023O0006E4000600FF2O0100070004CD3O00FF2O0100123A000500023O0004CD3O00F42O010004CD3O00FF2O010004CD3O00F42O010004CD3O00DD2O010004CD3O004506010004CD3O00D62O010004CD3O0045060100123A000300153O0006E40002008A050100030004CD3O008A050100120400030032012O000653010300D1040100010004CD3O00D1040100123A00030033012O00123A00040034012O0006D2000400E5040100030004CD3O00E5040100123A000300013O00123A00040035012O00123A00050036012O0006FD000400D2040100050004CD3O00D2040100123A000400013O0006E4000300D2040100040004CD3O00D204012O00CB0004002B4O005D000400046O000400216O000400023O00122O00060037015O00040004000600122O00060038015O0004000600024O000400203O00044O00F304010004CD3O00D204010004CD3O00F3040100123A000300013O00123A000400013O00064A010300ED040100040004CD3O00ED040100123A00040039012O00123A0005003A012O0006FD000400E6040100050004CD3O00E6040100123A000400024O00DA000400213O00123A000400024O00DA000400203O0004CD3O00F304010004CD3O00E604012O00CB00035O00205701030003001A2O00290103000200020006F5000300F904013O0004CD3O00F904012O00013O00013O00123A0003003B012O00123A0004003B012O0006E40003002O050100040004CD3O002O05012O00CB00035O00205701030003005F2O00290103000200020006530103002O050100010004CD3O002O05010012040003003C013O00640003000100022O00DA0003002C3O00123A0003003D012O00123A0004003D012O0006E400030089050100040004CD3O0089050100123A0003003E012O00123A0004003F012O0006D200040089050100030004CD3O008905012O00CB00035O0020570103000300082O002901030002000200065301030015050100010004CD3O001505012O00CB000300273O0006F50003008905013O0004CD3O0089050100123A000300014O009C000400063O00123A000700023O00064A0103001E050100070004CD3O001E050100123A00070040012O00123A00080041012O0006D200080082050100070004CD3O008205012O009C000600063O00123A00070042012O00123A00080042012O0006E40007003B050100080004CD3O003B050100123A000700013O0006E40007003B050100040004CD3O003B050100123A000700013O00123A000800013O0006E40007002D050100080004CD3O002D050100123A000500014O009C000600063O00123A000700023O00123A000800023O00064A01070038050100080004CD3O0038050100123A00080043012O00123A00090044012O00064A01080038050100090004CD3O0038050100123A00080045012O00123A00090046012O0006FD00080027050100090004CD3O0027050100123A000400023O0004CD3O003B05010004CD3O0027050100123A000700023O0006E40007001F050100040004CD3O001F050100123A000700013O0006E400050071050100070004CD3O0071050100123A000700013O00123A000800013O0006E400080067050100070004CD3O0067050100123A000800013O00123A000900013O0006E40008005D050100090004CD3O005D05012O00CB000900273O00064101060055050100090004CD3O005505012O00CB000900044O0062000A00053O00122O000B0047012O00122O000C0048015O000A000C00024O00090009000A0020570109000900E22O00290109000200022O0013010600094O00CB000900073O0012F9000A0049015O00090009000A4O000A00066O000B000D6O0009000D00024O0009000A3O00122O000800023O00123A000900023O00064A01080064050100090004CD3O0064050100123A0009004A012O00123A000A004B012O0006FD000900460501000A0004CD3O0046050100123A000700023O0004CD3O006705010004CD3O0046050100123A000800023O00064A0107006E050100080004CD3O006E050100123A0008004C012O00123A0009004D012O0006D200080042050100090004CD3O0042050100123A000500023O0004CD3O007105010004CD3O0042050100123A000700023O0006E40005003E050100070004CD3O003E050100123A0007004E012O00123A0008004F012O0006D200070089050100080004CD3O008905012O00CB0007000A3O0006F50007008905013O0004CD3O008905012O00CB0007000A4O005A010700023O0004CD3O008905010004CD3O003E05010004CD3O008905010004CD3O001F05010004CD3O0089050100123A000700013O0006E400030017050100070004CD3O0017050100123A000400014O009C000500053O00123A000300023O0004CD3O0017050100123A000200073O00123A00030050012O00123A00040051012O0006FD00040091050100030004CD3O0091050100123A000300013O00064A01020095050100030004CD3O0095050100123A00030052012O00123A00040053012O0006FD000400EC050100030004CD3O00EC050100123A000300013O00123A00040054012O00123A00050055012O0006D20005009F050100040004CD3O009F050100123A000400153O0006E40003009F050100040004CD3O009F050100123A000200023O0004CD3O00EC050100123A00040056012O00123A00050057012O0006FD000400D5050100050004CD3O00D5050100123A000400023O0006E4000400D5050100030004CD3O00D5050100123A000400013O00123A00050058012O00123A00060059012O0006FD000600AE050100050004CD3O00AE050100123A000500023O00064A010400B2050100050004CD3O00B2050100123A0005005A012O00123A0006005B012O0006E4000500B4050100060004CD3O00B4050100123A000300153O0004CD3O00D5050100123A0005005C012O00123A0006005D012O0006D2000500A7050100060004CD3O00A7050100123A000500013O0006E4000400A7050100050004CD3O00A705010012040005005E013O0015010600053O00122O0007005F012O00122O00080060015O0006000800024O0005000500064O000600053O00122O00070061012O00122O00080062015O0006000800024O0005000500064O0005002D3O00122O0005005E015O000600053O00122O00070063012O00122O00080064015O0006000800024O0005000500064O000600053O00122O00070065012O00122O00080066015O0006000800024O0005000500064O0005001E3O00122O000400023O00044O00A7050100123A000400013O00064A010300DC050100040004CD3O00DC050100123A00040067012O00123A00050068012O0006FD00050096050100040004CD3O009605012O00CB0004002E4O001F01040001000100122O0004005E015O000500053O00122O00060069012O00122O0007006A015O0005000700024O0004000400054O000500053O00122O0006006B012O00122O0007006C015O0005000700024O0004000400054O000400013O00122O000300023O00044O0096050100123A000300023O00064A010300F3050100020004CD3O00F3050100123A0003006D012O00123A0004006E012O0006D200040009000100030004CD3O0009000100123A000300013O00123A0004006F012O00123A000500FE3O0006FD000400FD050100050004CD3O00FD050100123A000400153O0006E4000300FD050100040004CD3O00FD050100123A000200153O0004CD3O0009000100123A000400023O0006E40004000D060100030004CD3O000D06012O00CB00045O0012AC00060070015O00040004000600122O0006003D6O0004000600024O0004002F6O000400023O00122O00060071015O00040004000600122O00060038015O0004000600024O0004000F3O00122O000300153O00123A00040072012O00123A00050073012O0006D2000500F4050100040004CD3O00F4050100123A000400013O0006E4000300F4050100040004CD3O00F4050100123A000400013O00123A000500023O0006E40005001A060100040004CD3O001A060100123A000300023O0004CD3O00F4050100123A000500013O00064A01040021060100050004CD3O0021060100123A00050074012O00123A00060075012O0006D200050015060100060004CD3O001506010012040005005E013O0062000600053O00122O00070076012O00122O00080077015O0006000800024O0005000500062O0062000600053O00122O00070078012O00122O00080079015O0006000800024O0005000500062O0059000500306O00055O00122O00070070015O00050005000700122O000700BC6O0005000700024O0005002B3O00122O000400023O00044O001506010004CD3O00F405010004CD3O000900010004CD3O004506010004CD3O000400010004CD3O0045060100123A0003007A012O00123A0004007B012O0006FD00040002000100030004CD3O0002000100123A000300013O0006E43O0002000100030004CD3O0002000100123A000100014O009C000200023O00123A3O00023O0004CD3O000200012O00013O00017O00203O00028O00025O00B89840025O0072A940025O00C09540025O0066A340025O0098A940025O0045B240025O00A07640025O0009B240025O00F49540025O00608C40026O00F03F025O006CA940025O00F0944003133O0076E5EBDD49F6EFCE74EBF3CE48C0E3CF55E2E003043O00AD20848603143O00526567697374657241757261547261636B696E67025O00EEA240025O006CB040025O00C0A140025O004C9140025O00E3B040025O00649140025O00788C40025O0048804003053O005072696E74031B3O007D1309EBA1268D7E0901EABD258D4C0248CABE38CE0E3907E0A31A03073O00AD2E7B688FCE51030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03203O008715238E4A9441840F2B8F569741A25D73DA0BD14FE44C62A85CC323BB122FA103073O0061D47D42EA25E300513O00123A3O00014O009C000100013O0026283O0006000100010004CD3O00060001002EA400030002000100020004CD3O0002000100123A000100013O002EA400040038000100050004CD3O00380001002EA400060038000100070004CD3O0038000100267900010038000100010004CD3O0038000100123A000200014O009C000300033O00262800020013000100010004CD3O00130001002EA40009000F000100080004CD3O000F000100123A000300013O00262800030018000100010004CD3O00180001002EA4000A002D0001000B0004CD3O002D000100123A000400013O0026280004001D0001000C0004CD3O001D0001002EDC000D001F0001000E0004CD3O001F000100123A0003000C3O0004CD3O002D000100267900040019000100010004CD3O001900012O00CB00056O00A60005000100012O00CB000500014O0062000600023O00122O0007000F3O00122O000800106O0006000800024O0005000500060020570105000500112O00B800050002000100123A0004000C3O0004CD3O00190001002EA400120014000100130004CD3O00140001002EA400150014000100140004CD3O00140001002679000300140001000C0004CD3O0014000100123A0001000C3O0004CD3O003800010004CD3O001400010004CD3O003800010004CD3O000F0001002EA400170007000100160004CD3O00070001002EA400190007000100180004CD3O00070001002679000100070001000C0004CD3O000700012O00CB000200033O00204301020002001A4O000300023O00122O0004001B3O00122O0005001C6O000300056O00023O000100122O0002001D3O00202O00020002001E4O000300023O00122O0004001F3O00122O000500206O000300056O00023O000100044O005000010004CD3O000700010004CD3O005000010004CD3O000200012O00013O00017O00", GetFEnv(), ...);

