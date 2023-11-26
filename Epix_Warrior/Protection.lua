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
				if (Enum <= 110) then
					if (Enum <= 54) then
						if (Enum <= 26) then
							if (Enum <= 12) then
								if (Enum <= 5) then
									if (Enum <= 2) then
										if (Enum <= 0) then
											local Edx;
											local Results, Limit;
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 1) then
											local B;
											local A;
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 3) then
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
									elseif (Enum == 4) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 8) then
									if (Enum <= 6) then
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
									elseif (Enum == 7) then
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
								elseif (Enum <= 10) then
									if (Enum > 9) then
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
								elseif (Enum == 11) then
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
							elseif (Enum <= 19) then
								if (Enum <= 15) then
									if (Enum <= 13) then
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
									elseif (Enum == 14) then
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
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
								elseif (Enum <= 17) then
									if (Enum > 16) then
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								elseif (Enum > 18) then
									if (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum <= 22) then
								if (Enum <= 20) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 21) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 24) then
								if (Enum == 23) then
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
								end
							elseif (Enum > 25) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = Inst[3];
							end
						elseif (Enum <= 40) then
							if (Enum <= 33) then
								if (Enum <= 29) then
									if (Enum <= 27) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif (Enum > 28) then
										local A = Inst[2];
										Stk[A] = Stk[A]();
									elseif Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 31) then
									if (Enum > 30) then
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
								elseif (Enum > 32) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 36) then
								if (Enum <= 34) then
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 35) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 38) then
								if (Enum == 37) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 39) then
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
							end
						elseif (Enum <= 47) then
							if (Enum <= 43) then
								if (Enum <= 41) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 42) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 45) then
								if (Enum > 44) then
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
								end
							elseif (Enum > 46) then
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
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							end
						elseif (Enum <= 50) then
							if (Enum <= 48) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 49) then
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
							else
								local A;
								Stk[Inst[2]] = Inst[3];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 52) then
							if (Enum == 51) then
								local B;
								local A;
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 53) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Mvm[1] == 18) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						end
					elseif (Enum <= 82) then
						if (Enum <= 68) then
							if (Enum <= 61) then
								if (Enum <= 57) then
									if (Enum <= 55) then
										if (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 56) then
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
								elseif (Enum <= 59) then
									if (Enum == 58) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
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
										Stk[Inst[2]] = Stk[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 60) then
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
							elseif (Enum <= 64) then
								if (Enum <= 62) then
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
								elseif (Enum > 63) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									do
										return;
									end
								end
							elseif (Enum <= 66) then
								if (Enum > 65) then
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 67) then
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 75) then
							if (Enum <= 71) then
								if (Enum <= 69) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 70) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								end
							elseif (Enum <= 73) then
								if (Enum == 72) then
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
									Stk[Inst[2]] = Inst[3];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum == 74) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 78) then
							if (Enum <= 76) then
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
							elseif (Enum == 77) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 80) then
							if (Enum == 79) then
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
						elseif (Enum == 81) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 96) then
						if (Enum <= 89) then
							if (Enum <= 85) then
								if (Enum <= 83) then
									if (Inst[2] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 84) then
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
							elseif (Enum <= 87) then
								if (Enum > 86) then
									local B;
									local A;
									Stk[Inst[2]] = Inst[3];
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
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum == 88) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 92) then
							if (Enum <= 90) then
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
								VIP = Inst[3];
							elseif (Enum > 91) then
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
							else
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 94) then
							if (Enum == 93) then
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
						elseif (Enum > 95) then
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
					elseif (Enum <= 103) then
						if (Enum <= 99) then
							if (Enum <= 97) then
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
						elseif (Enum <= 101) then
							if (Enum == 100) then
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
						elseif (Enum > 102) then
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
					elseif (Enum <= 106) then
						if (Enum <= 104) then
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
						elseif (Enum > 105) then
							local B;
							local A;
							Stk[Inst[2]] = Inst[3];
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
						if (Enum == 107) then
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
					elseif (Enum == 109) then
						Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
					else
						Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
					end
				elseif (Enum <= 166) then
					if (Enum <= 138) then
						if (Enum <= 124) then
							if (Enum <= 117) then
								if (Enum <= 113) then
									if (Enum <= 111) then
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
									elseif (Enum > 112) then
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
								elseif (Enum <= 115) then
									if (Enum > 114) then
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
								elseif (Enum > 116) then
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
							elseif (Enum <= 120) then
								if (Enum <= 118) then
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
								elseif (Enum == 119) then
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
							elseif (Enum <= 122) then
								if (Enum == 121) then
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
							elseif (Enum > 123) then
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
						elseif (Enum <= 131) then
							if (Enum <= 127) then
								if (Enum <= 125) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum == 126) then
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
							elseif (Enum <= 129) then
								if (Enum == 128) then
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							elseif (Enum == 130) then
								local A;
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 134) then
							if (Enum <= 132) then
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
							elseif (Enum == 133) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 136) then
							if (Enum == 135) then
								local A;
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 137) then
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						else
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
						end
					elseif (Enum <= 152) then
						if (Enum <= 145) then
							if (Enum <= 141) then
								if (Enum <= 139) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 140) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 143) then
								if (Enum == 142) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum == 144) then
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
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 148) then
							if (Enum <= 146) then
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
							elseif (Enum > 147) then
								local B;
								local A;
								Stk[Inst[2]] = Inst[3];
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
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 150) then
							if (Enum == 149) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum > 151) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 159) then
						if (Enum <= 155) then
							if (Enum <= 153) then
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
							elseif (Enum > 154) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Enum > 156) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 158) then
							Stk[Inst[2]] = not Stk[Inst[3]];
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
					elseif (Enum <= 162) then
						if (Enum <= 160) then
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						elseif (Enum == 161) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 164) then
						if (Enum > 163) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum == 165) then
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
				elseif (Enum <= 194) then
					if (Enum <= 180) then
						if (Enum <= 173) then
							if (Enum <= 169) then
								if (Enum <= 167) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 168) then
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
							elseif (Enum <= 171) then
								if (Enum == 170) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							else
								local A;
								Stk[Inst[2]] = Inst[3];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 176) then
							if (Enum <= 174) then
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
							elseif (Enum == 175) then
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
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 178) then
							if (Enum == 177) then
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
						elseif (Enum > 179) then
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
					elseif (Enum <= 187) then
						if (Enum <= 183) then
							if (Enum <= 181) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 182) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 185) then
							if (Enum == 184) then
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							end
						elseif (Enum > 186) then
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
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
					elseif (Enum <= 190) then
						if (Enum <= 188) then
							local B;
							local A;
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 189) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
					elseif (Enum <= 192) then
						if (Enum == 191) then
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
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum == 193) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 208) then
					if (Enum <= 201) then
						if (Enum <= 197) then
							if (Enum <= 195) then
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
							elseif (Enum == 196) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 199) then
							if (Enum == 198) then
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
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum > 200) then
							local A;
							Stk[Inst[2]] = Inst[3];
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
							Stk[A](Stk[A + 1]);
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
					elseif (Enum <= 204) then
						if (Enum <= 202) then
							local A;
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 203) then
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
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
					elseif (Enum <= 206) then
						if (Enum == 205) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum == 207) then
						Stk[Inst[2]] = Inst[3];
					else
						local A;
						Stk[Inst[2]] = Inst[3];
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 215) then
					if (Enum <= 211) then
						if (Enum <= 209) then
							if (Stk[Inst[2]] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 210) then
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
					elseif (Enum <= 213) then
						if (Enum > 212) then
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
						else
							Stk[Inst[2]]();
						end
					elseif (Enum == 214) then
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
				elseif (Enum <= 218) then
					if (Enum <= 216) then
						local A = Inst[2];
						do
							return Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum > 217) then
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
				elseif (Enum <= 220) then
					if (Enum == 219) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[A] = Stk[A](Stk[A + 1]);
					end
				elseif (Enum > 221) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!273O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203043O00556E697403053O005574696C7303063O00506C6179657203063O00546172676574030C3O0054617267657454617267657403053O00466F63757303053O005370652O6C03043O004974656D03043O0042696E6403043O004361737403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C030A3O00556E69744973556E697403043O006D61746803053O00666C2O6F72026O001440024O0080B3C54003073O0057612O72696F72030A3O0050726F74656374696F6E030F3O005370652O6C5265666C65637449447303063O0053657441504C025O00405240004A012O0012343O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004593O000A000100120E000300063O0020A300040003000700120E000500083O0020A300050005000900120E000600083O0020A300060006000A00063600073O000100062O00123O00064O00128O00123O00044O00123O00014O00123O00024O00123O00054O00840008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00202O000C000B000E00202O000D000B000F00202O000E000C001000202O000F000C001100202O0010000C001200202O0011000C00130020A30012000B001400208E0013000B001500122O0014000D3O00202O00150014001600202O00160014001700202O00170014001800202O00180014001900202O00190014001A00202O00190019001B00202O00190019001C00202O001A0014001A0020A3001A001A001B002071001A001A001D00122O001B001E3O00122O001C001F3O00202O001C001C002000122O001D00216O001E001E6O001F8O00208O00218O00226O00960023005E3O0012DA005F00223O00122O006000226O006100613O00202O00620014001A00202O00620062001B00202O00630012002300202O00630063002400202O00640013002300202O00640064002400202O0065001700230020A30065006500240020A30066006200252O004400676O00960068006A3O000636006B0001000100012O00123O000F3O000636006C0002000100022O00123O000E4O00123O000F3O000636006D0003000100022O00123O000E4O00123O00633O000636006E0004000100022O00123O000E4O00123O00633O000636006F0005000100032O00123O006C4O00123O00634O00123O000E3O00063600700006000100062O00123O000D4O00123O00664O00123O000F4O00123O00104O00123O001B4O00123O000E3O00063600710007000100082O00123O000E4O00123O00634O00123O006C4O00123O006D4O00123O00184O00123O00074O00123O00684O00123O006F3O000636007200080001001A2O00123O00644O00123O00474O00123O000E4O00123O00534O00123O00184O00123O00654O00123O00074O00123O00484O00123O00544O00123O005A4O00123O00634O00123O00424O00123O004D4O00123O00434O00123O004E4O00123O006D4O00123O00704O00123O003F4O00123O004A4O00123O00444O00123O004F4O00123O00624O00123O00504O00123O00454O00123O00114O00123O00513O00063600730009000100042O00123O001E4O00123O00624O00123O00674O00123O00213O0006360074000A000100072O00123O000F4O00123O001D4O00123O00634O00123O00304O00123O00184O00123O00074O00123O00253O0006360075000B0001000C2O00123O00634O00123O00304O00123O000F4O00123O00714O00123O00184O00123O001D4O00123O00074O00123O002D4O00123O000E4O00123O006A4O00123O00684O00123O002B3O0006360076000C0001000E2O00123O00634O00123O00284O00123O006A4O00123O000E4O00123O00184O00123O00684O00123O00074O00123O00304O00123O00714O00123O000F4O00123O001D4O00123O002D4O00123O002B4O00123O00273O0006360077000D000100092O00123O000E4O00123O00634O00123O00244O00123O00624O00123O00184O00123O00074O00123O001F4O00123O001E4O00123O00743O0006360078000E000100362O00123O001E4O00123O00724O00123O00594O00123O00624O00123O00634O00123O00654O00123O006A4O00123O00144O00123O00074O00123O00754O00123O00764O00123O00294O00123O000F4O00123O00184O00123O00324O00123O006B4O00123O005E4O00123O00604O00123O00234O00123O00354O00123O00214O00123O002E4O00123O000E4O00123O00714O00123O001D4O00123O002C4O00123O00374O00123O006F4O00123O00414O00123O00254O00123O00684O00123O00564O00123O00494O00123O00334O00123O003A4O00123O00734O00123O00614O00123O00524O00123O00434O00123O006D4O00123O006C4O00123O00424O00123O002A4O00123O00364O00123O00574O00123O002F4O00123O00384O00123O00584O00123O00314O00123O00394O00123O002D4O00123O00264O00123O00344O00123O003B3O0006360079000F000100162O00123O002E4O00123O00074O00123O00304O00123O00324O00123O00234O00123O00354O00123O00364O00123O00374O00123O00384O00123O00284O00123O00294O00123O002B4O00123O002D4O00123O00394O00123O00244O00123O00254O00123O00264O00123O00274O00123O002A4O00123O002C4O00123O002F4O00123O00313O000636007A0010000100192O00123O004D4O00123O00074O00123O00504O00123O004F4O00123O003F4O00123O00434O00123O00454O00123O004A4O00123O004E4O00123O00514O00123O00424O00123O00444O00123O00414O00123O004C4O00123O004B4O00123O00564O00123O00524O00123O00574O00123O00584O00123O00404O00123O00494O00123O00614O00123O003C4O00123O003D4O00123O003E3O000636007B00110001000F2O00123O005A4O00123O00074O00123O00594O00123O005E4O00123O005B4O00123O005C4O00123O005D4O00123O00474O00123O00484O00123O00534O00123O00544O00123O00334O00123O00344O00123O003A4O00123O003B3O000636007C0012000100162O00123O000E4O00123O001E4O00123O00784O00123O00774O00123O007A4O00123O00794O00123O007B4O00123O00204O00123O00694O00123O001D4O00123O006A4O00123O00684O00123O000F4O00123O00624O00123O00604O00123O000B4O00123O005F4O00123O00224O00123O00074O00123O00634O00123O001F4O00123O00213O000636007D0013000100022O00123O00144O00123O00073O002088007E0014002600122O007F00276O0080007C6O0081007D6O007E008100016O00013O00143O00023O00026O00F03F026O00704002264O005800025O00122O000300016O00045O00122O000500013O00042O0003002100012O008D00076O0054000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004AE0003000500012O008D000300054O0012000400024O00D8000300044O00BB00036O003F3O00017O00023O00028O0003133O00556E6974476574546F74616C4162736F72627300123O0012CF3O00014O0096000100013O0026223O0002000100010004593O0002000100120E000200024O008D00036O00DC0002000200022O0012000100023O000E140001000D000100010004593O000D00012O009D000200014O0056000200023O0004593O001100012O009D00026O0056000200023O0004593O001100010004593O000200012O003F3O00017O00043O00030C3O00497354616E6B696E67416F45026O00304003093O00497354616E6B696E6703073O00497344752O6D7900114O00477O00206O000100122O000200028O0002000200064O000F000100010004593O000F00012O008D7O00205B5O00032O008D000200014O00B63O000200020006793O000F000100010004593O000F00012O008D3O00013O00205B5O00042O00DC3O000200022O00563O00024O003F3O00017O000A3O0003063O0042752O665570030A3O0049676E6F72655061696E028O00026O00F03F03063O00706F696E747303143O00412O7461636B506F77657244616D6167654D6F64026O000C4003113O00566572736174696C697479446D67506374026O00594003083O0041757261496E666F002C4O00557O00206O00014O000200013O00202O0002000200026O0002000200064O002900013O0004593O002900010012CF3O00034O0096000100033O0026223O0012000100040004593O001200010020A30004000200050020A300030004000400069500030010000100010004593O001000012O008900046O009D000400014O0056000400023O0026223O0009000100030004593O000900012O008D00045O00203A0004000400064O00040002000200202O0004000400074O00055O00202O0005000500084O00050002000200202O00050005000900102O0005000400054O0001000400054O00045O00202O00040004000A4O000600013O00202O0006000600024O000700076O000800016O0004000800024O000200043O00124O00043O00044O000900010004593O002B00012O009D3O00014O00563O00024O003F3O00017O00063O0003063O0042752O665570030A3O0049676E6F72655061696E028O0003083O0042752O66496E666F03063O00706F696E7473026O00F03F001B4O00557O00206O00014O000200013O00202O0002000200026O0002000200064O001800013O0004593O001800010012CF3O00034O0096000100013O0026223O0009000100030004593O000900012O008D00025O00207D0002000200044O000400013O00202O0004000400024O000500056O000600016O0002000600024O000100023O00202O00020001000500202O0002000200064O000200023O00044O000900010004593O001A00010012CF3O00034O00563O00024O003F3O00017O00083O00030B3O00536869656C64426C6F636B03073O0049735265616479030B3O0042752O6652656D61696E73030F3O00536869656C64426C6F636B42752O66026O00324003103O00456E647572696E67446566656E736573030B3O004973417661696C61626C65026O00284000224O008D8O001D3O0001000200061C3O002000013O0004593O002000012O008D3O00013O0020A35O000100205B5O00022O00DC3O0002000200061C3O002000013O0004593O002000012O008D3O00023O0020C05O00034O000200013O00202O0002000200046O0002000200264O0017000100050004593O001700012O008D3O00013O0020A35O000600205B5O00072O00DC3O000200020006793O0020000100010004593O002000012O008D3O00023O00201A5O00034O000200013O00202O0002000200046O0002000200264O001F000100080004593O001F00012O00898O009D3O00014O00563O00024O003F3O00017O00043O00030E3O0056616C75654973496E412O726179030B3O00436173745370652O6C494403063O0045786973747303023O00494400189O003O00206O00014O000100016O000200023O00202O0002000200024O000200039O00000200064O001600013O0004593O001600012O008D3O00033O00205B5O00032O00DC3O0002000200061C3O001600013O0004593O001600012O008D3O00044O0018000100033O00202O0001000100044O0001000200024O000200053O00202O0002000200044O000200039O0000022O00563O00024O003F3O00017O000E3O00028O00027O004003043O005261676503113O0044656D6F72616C697A696E6753686F757403073O0049735265616479030A3O0049676E6F72655061696E03173O005F4CF37A945C695BFC7C8819444AFA70C65A575BED708203063O0039362B9D15E603073O00526576656E676503133O00DDDE9D14FBBED9BADDDA8C14B5BADDEADFDE8F03083O009AAFBBEB7195D9BC026O005440025O00804140026O00F03F01573O0012CF000100014O0096000200043O00262200010039000100020004593O0039000100061C0004001300013O0004593O001300012O008D00055O00205B0005000500032O00DC0005000200022O0011000500053O00062000020007000100050004593O001200012O008D000500013O0020A300050005000400205B0005000500052O00DC00050002000200061C0005001300013O0004593O001300012O009D000300013O00061C0003005600013O0004593O005600012O008D000500024O001D00050001000200061C0005002B00013O0004593O002B00012O008D000500034O001D00050001000200061C0005002B00013O0004593O002B00012O008D000500044O0068000600013O00202O0006000600064O000700086O000900016O00050009000200062O0005005600013O0004593O005600012O008D000500053O0012B4000600073O00122O000700086O000500076O00055O00044O005600012O008D000500044O0067000600013O00202O0006000600094O000700066O000700076O00050007000200062O0005005600013O0004593O005600012O008D000500053O0012B40006000A3O00122O0007000B6O000500076O00055O00044O0056000100262200010046000100010004593O004600010012CF0002000C3O002693000200430001000D0004593O004300012O008D00055O00205B0005000500032O00DC00050002000200261F000500450001000D0004593O004500012O009D00056O0056000500023O0012CF0001000E3O002622000100020001000E0004593O000200012O009D00036O008D00055O00205B0005000500032O00DC000500020002000EB7000D0052000100050004593O005200012O008D000500074O001D0005000100022O009F000400053O0004593O005400012O008900046O009D000400013O0012CF000100023O0004593O000200012O003F3O00017O002C3O00028O00026O000840030B3O004865616C746873746F6E6503073O004973526561647903103O004865616C746850657263656E7461676503173O0034AA8040F7716B28A08F49A32O7D3AAA8F5FEA6F7D7CFC03073O00185CCFE12C831903193O0079D6BE5E1E6E43DAB64B5B554ED2B445157A0BE3B75812724503063O001D2BB3D82C7B03173O0052656672657368696E674865616C696E67506F74696F6E03253O00AFDC265EB8CA2845B3DE6044B8D82C45B3DE605CB2CD2943B3992449BBDC2E5FB4CF250CE903043O002CDDB940031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O0005F54D5E7E16E644547613F408577600EB41517441F7474B7A0EE9085B7607E2464C7A17E203053O00136187283F026O00F03F03093O004C6173745374616E64030A3O0049734361737461626C6503163O004163746976654D697469676174696F6E4E2O6564656403143O00A25D202F1022BA5D3D3F6F35AB5A36353C38B85903063O0051CE3C535B4F030A3O0049676E6F72655061696E03153O0047ACDE7D3DC672B44FA2DE322BC64BA140B8D9642A03083O00C42ECBB0124FA32D027O0040030F3O005370652O6C5265666C656374696F6E031A3O00AB327B1228C4FDBD24721B27EFE6B72C3E1A21FDEAB63177082103073O008FD8421E7E449B030E3O0042692O746572492O6D756E69747903193O00A8C119DFC0B12OE8A7C518C5CCB7CEA1AECD0BCECBB0DEF7AF03083O0081CAA86DABA5C3B7030B3O0052612O6C79696E6743727903083O0042752O66446F776E03103O00417370656374734661766F7242752O66030A3O004973536F6C6F4D6F6465031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503163O0030593BD4C71DE8256734CAC754E2275E32D6CD1DF02703073O0086423857B8BE7403093O00496E74657276656E6503083O00556E69744E616D65030E3O00496E74657276656E65466F63757303133O00353F1DBE0BFD243B39710DBE1FEE2F2635270C03083O00555C5169DB798B410027012O0012CF3O00013O0026223O0058000100020004593O005800012O008D00015O0020A300010001000300205B0001000100042O00DC00010002000200061C0001001D00013O0004593O001D00012O008D000100013O00061C0001001D00013O0004593O001D00012O008D000100023O00205B0001000100052O00DC0001000200022O008D000200033O00060A0001001D000100020004593O001D00012O008D000100044O008D000200053O0020A30002000200032O00DC00010002000200061C0001001D00013O0004593O001D00012O008D000100063O0012CF000200063O0012CF000300074O00D8000100034O00BB00016O008D000100073O00061C000100262O013O0004593O00262O012O008D000100023O00205B0001000100052O00DC0001000200022O008D000200083O00060A000100262O0100020004593O00262O010012CF000100013O000E3700010027000100010004593O002700012O008D000200094O009B000300063O00122O000400083O00122O000500096O00030005000200062O00020041000100030004593O004100012O008D00025O0020A300020002000A00205B0002000200042O00DC00020002000200061C0002004100013O0004593O004100012O008D000200044O008D000300053O0020A300030003000A2O00DC00020002000200061C0002004100013O0004593O004100012O008D000200063O0012CF0003000B3O0012CF0004000C4O00D8000200044O00BB00026O008D000200093O002622000200262O01000D0004593O00262O012O008D00025O0020A300020002000E00205B0002000200042O00DC00020002000200061C000200262O013O0004593O00262O012O008D000200044O008D000300053O0020A300030003000A2O00DC00020002000200061C000200262O013O0004593O00262O012O008D000200063O0012B40003000F3O00122O000400106O000200046O00025O00044O00262O010004593O002700010004593O00262O010026223O009A000100110004593O009A00012O008D0001000A3O0020A300010001001200205B0001000100132O00DC00010002000200061C0001007900013O0004593O007900012O008D0001000B3O00061C0001007900013O0004593O007900012O008D000100023O00205B0001000100052O00DC0001000200022O008D0002000C3O00062000010006000100020004593O006E00012O008D000100023O00205B0001000100142O00DC00010002000200061C0001007900013O0004593O007900012O008D000100044O008D0002000A3O0020A30002000200122O00DC00010002000200061C0001007900013O0004593O007900012O008D000100063O0012CF000200153O0012CF000300164O00D8000100034O00BB00016O008D0001000A3O0020A300010001001700205B0001000100042O00DC00010002000200061C0001009900013O0004593O009900012O008D0001000D3O00061C0001009900013O0004593O009900012O008D000100023O00205B0001000100052O00DC0001000200022O008D0002000E3O00060A00010099000100020004593O009900012O008D0001000F4O001D00010001000200061C0001009900013O0004593O009900012O008D000100044O00680002000A3O00202O0002000200174O000300046O000500016O00010005000200062O0001009900013O0004593O009900012O008D000100063O0012CF000200183O0012CF000300194O00D8000100034O00BB00015O0012CF3O001A3O000E37000100CC00013O0004593O00CC00012O008D0001000A3O0020A300010001001B00205B0001000100042O00DC00010002000200061C000100B100013O0004593O00B100012O008D000100104O001D00010001000200061C000100B100013O0004593O00B100012O008D000100044O008D0002000A3O0020A300020002001B2O00DC00010002000200061C000100B100013O0004593O00B100012O008D000100063O0012CF0002001C3O0012CF0003001D4O00D8000100034O00BB00016O008D0001000A3O0020A300010001001E00205B0001000100042O00DC00010002000200061C000100CB00013O0004593O00CB00012O008D000100113O00061C000100CB00013O0004593O00CB00012O008D000100023O00205B0001000100052O00DC0001000200022O008D000200123O00060A000100CB000100020004593O00CB00012O008D000100044O008D0002000A3O0020A300020002001E2O00DC00010002000200061C000100CB00013O0004593O00CB00012O008D000100063O0012CF0002001F3O0012CF000300204O00D8000100034O00BB00015O0012CF3O00113O000E37001A000100013O0004593O000100012O008D0001000A3O0020A300010001002100205B0001000100042O00DC00010002000200061C000100022O013O0004593O00022O012O008D000100133O00061C000100022O013O0004593O00022O012O008D000100023O0020630001000100224O0003000A3O00202O0003000300234O00010003000200062O000100022O013O0004593O00022O012O008D000100023O0020630001000100224O0003000A3O00202O0003000300214O00010003000200062O000100022O013O0004593O00022O012O008D000100023O00205B0001000100052O00DC0001000200022O008D000200143O00060A000100F0000100020004593O00F000012O008D000100153O0020A30001000100242O001D000100010002000679000100F7000100010004593O00F700012O008D000100153O0020920001000100254O000200146O000300166O00010003000200062O000100022O013O0004593O00022O012O008D000100044O008D0002000A3O0020A30002000200212O00DC00010002000200061C000100022O013O0004593O00022O012O008D000100063O0012CF000200263O0012CF000300274O00D8000100034O00BB00016O008D0001000A3O0020A300010001002800205B0001000100042O00DC00010002000200061C000100242O013O0004593O00242O012O008D000100173O00061C000100242O013O0004593O00242O012O008D000100183O00205B0001000100052O00DC0001000200022O008D000200193O00060A000100242O0100020004593O00242O012O008D000100183O0020CC0001000100294O0001000200024O000200023O00202O0002000200294O00020002000200062O000100242O0100020004593O00242O012O008D000100044O008D000200053O0020A300020002002A2O00DC00010002000200061C000100242O013O0004593O00242O012O008D000100063O0012CF0002002B3O0012CF0003002C4O00D8000100034O00BB00015O0012CF3O00023O0004593O000100012O003F3O00017O00053O00028O0003103O0048616E646C65546F705472696E6B6574026O004440026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B657400233O0012CF3O00013O0026223O0011000100010004593O001100012O008D000100013O0020A20001000100024O000200026O000300033O00122O000400036O000500056O0001000500024O00018O00015O00062O0001001000013O0004593O001000012O008D00016O0056000100023O0012CF3O00043O0026223O0001000100040004593O000100012O008D000100013O0020A20001000100054O000200026O000300033O00122O000400036O000500056O0001000500024O00018O00015O00062O0001002200013O0004593O002200012O008D00016O0056000100023O0004593O002200010004593O000100012O003F3O00017O000B3O00030E3O004973496E4D656C2O6552616E6765030B3O005468756E646572436C6170030A3O0049734361737461626C6503163O00E9BB454B78DAEF8C53497DCFBDA342407FD0F0B12O5103063O00BF9DD330251C03063O0043686172676503093O004973496E52616E6765026O002040030E3O0049735370652O6C496E52616E676503103O00DC17F50E3DDA5FE40E3FDC10F91E3BCB03053O005ABF7F947C003C4O00D67O00206O00014O000200018O0002000200064O001B00013O0004593O001B00012O008D3O00023O0020A35O000200205B5O00032O00DC3O0002000200061C3O003B00013O0004593O003B00012O008D3O00033O00061C3O003B00013O0004593O003B00012O008D3O00044O008D000100023O0020A30001000100022O00DC3O0002000200061C3O003B00013O0004593O003B00012O008D3O00053O0012B4000100043O00122O000200058O00029O003O00044O003B00012O008D3O00063O00061C3O003B00013O0004593O003B00012O008D3O00023O0020A35O000600205B5O00032O00DC3O0002000200061C3O003B00013O0004593O003B00012O008D7O00205B5O00070012CF000200084O00B63O000200020006793O003B000100010004593O003B00012O008D3O00044O00C5000100023O00202O0001000100064O00025O00202O0002000200094O000400023O00202O0004000400064O0002000400024O000200028O0002000200064O003B00013O0004593O003B00012O008D3O00053O0012CF0001000A3O0012CF0002000B4O00D83O00024O00BB8O003F3O00017O002B3O00028O00030B3O005468756E646572436C6170030A3O0049734361737461626C65030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O66026O00F03F026O001440030E3O004973496E4D656C2O6552616E676503123O006C8F3B197C823C287B8B2F073886211238D503043O007718E74E030A3O00536869656C64536C616D03073O0048617354696572026O003E40027O0040026O001C4003063O0042752O66557003133O004561727468656E54656E616369747942752O6603113O009125AC4FD0442E9121A4479C411E876DF603073O0071E24DC52ABC20026O00084003073O00526576656E676503073O004973526561647903043O0052616765026O00444003103O004261726261726963547261696E696E67030B3O004973417661696C61626C65030E3O002813E2B03411F1F53B19F1F56B4403043O00D55A7694026O004E4003133O0056696F6C656E744F7574627572737442752O66026O00344003113O004826BD53415F11A75A4C566EB559481B7603053O002D3B4ED43603133O00045E9685822BBFCF135A829BC62FA2F55007D303083O00907036E3EBE64ECD030A3O0041766174617242752O6603103O00556E73746F2O7061626C65466F72636503123O00A7201AF2D45EA1170CF0D14BF32900F9900F03063O003BD3486F9CB0025O0080514003143O00536569736D696352657665726265726174696F6E030D3O005C82F5284080E66D4F88E66D1803043O004D2EE783002E012O0012CF3O00013O000E370001005300013O0004593O005300012O008D00015O0020A300010001000200205B0001000100032O00DC00010002000200061C0001002B00013O0004593O002B00012O008D000100013O00061C0001002B00013O0004593O002B00012O008D000100023O0020C00001000100044O00035O00202O0003000300054O00010003000200262O0001002B000100060004593O002B00010012CF000100013O00262200010014000100010004593O001400012O008D000200033O0012BC000300076O0002000200014O000200046O00035O00202O0003000300024O000400023O00202O0004000400084O000600056O0004000600024O000400046O00020004000200062O0002002B00013O0004593O002B00012O008D000200063O0012B4000300093O00122O0004000A6O000200046O00025O00044O002B00010004593O001400012O008D00015O0020A300010001000B00205B0001000100032O00DC00010002000200061C0001005200013O0004593O005200012O008D000100073O00061C0001005200013O0004593O005200012O008D000100083O00202D00010001000C00122O0003000D3O00122O0004000E6O00010004000200062O0001003E00013O0004593O003E00012O008D000100093O0026D1000100450001000F0004593O004500012O008D000100083O0020630001000100104O00035O00202O0003000300114O00010003000200062O0001005200013O0004593O005200012O008D000100044O006700025O00202O00020002000B4O0003000A6O000300036O00010003000200062O0001005200013O0004593O005200012O008D000100063O0012CF000200123O0012CF000300134O00D8000100034O00BB00015O0012CF3O00063O0026223O007C000100140004593O007C00012O008D00015O0020A300010001001500205B0001000100162O00DC00010002000200061C0001002D2O013O0004593O002D2O012O008D0001000B3O00061C0001002D2O013O0004593O002D2O012O008D000100083O00205B0001000100172O00DC000100020002000E53000D006E000100010004593O006E00012O008D000100083O00205B0001000100172O00DC000100020002000EB70018002D2O0100010004593O002D2O012O008D00015O0020A300010001001900205B00010001001A2O00DC00010002000200061C0001002D2O013O0004593O002D2O012O008D000100044O006700025O00202O0002000200154O0003000A6O000300036O00010003000200062O0001002D2O013O0004593O002D2O012O008D000100063O0012B40002001B3O00122O0003001C6O000100036O00015O00044O002D2O010026223O00CD0001000E0004593O00CD00012O008D00015O0020A300010001000B00205B0001000100032O00DC00010002000200061C000100AB00013O0004593O00AB00012O008D000100073O00061C000100AB00013O0004593O00AB00012O008D000100083O00205B0001000100172O00DC0001000200020026D1000100960001001D0004593O009600012O008D000100083O0020630001000100104O00035O00202O00030003001E4O00010003000200062O000100AB00013O0004593O00AB00012O008D000100093O002613000100AB0001000F0004593O00AB00010012CF000100013O00262200010097000100010004593O009700012O008D000200033O0012320003001F6O0002000200014O000200046O00035O00202O00030003000B4O0004000A6O000400046O00020004000200062O000200AB00013O0004593O00AB00012O008D000200063O0012B4000300203O00122O000400216O000200046O00025O00044O00AB00010004593O009700012O008D00015O0020A300010001000200205B0001000100032O00DC00010002000200061C000100CC00013O0004593O00CC00012O008D000100013O00061C000100CC00013O0004593O00CC00010012CF000100013O002622000100B5000100010004593O00B500012O008D000200033O0012BC000300076O0002000200014O000200046O00035O00202O0003000300024O000400023O00202O0004000400084O000600056O0004000600024O000400046O00020004000200062O000200CC00013O0004593O00CC00012O008D000200063O0012B4000300223O00122O000400236O000200046O00025O00044O00CC00010004593O00B500010012CF3O00143O0026223O0001000100060004593O000100012O008D00015O0020A300010001000200205B0001000100032O00DC00010002000200061C000100072O013O0004593O00072O012O008D000100013O00061C000100072O013O0004593O00072O012O008D000100083O0020630001000100104O00035O00202O00030003001E4O00010003000200062O000100072O013O0004593O00072O012O008D000100093O000E14000700072O0100010004593O00072O012O008D000100083O0020630001000100104O00035O00202O0003000300244O00010003000200062O000100072O013O0004593O00072O012O008D00015O0020A300010001002500205B00010001001A2O00DC00010002000200061C000100072O013O0004593O00072O010012CF000100013O002622000100F0000100010004593O00F000012O008D000200033O0012BC000300076O0002000200014O000200046O00035O00202O0003000300024O000400023O00202O0004000400084O000600056O0004000600024O000400046O00020004000200062O000200072O013O0004593O00072O012O008D000200063O0012B4000300263O00122O000400276O000200046O00025O00044O00072O010004593O00F000012O008D00015O0020A300010001001500205B0001000100162O00DC00010002000200061C0001002B2O013O0004593O002B2O012O008D0001000B3O00061C0001002B2O013O0004593O002B2O012O008D000100083O00205B0001000100172O00DC000100020002000EB70028002B2O0100010004593O002B2O012O008D00015O0020A300010001002900205B00010001001A2O00DC00010002000200061C0001002B2O013O0004593O002B2O012O008D000100093O000EB70014002B2O0100010004593O002B2O012O008D000100044O006700025O00202O0002000200154O0003000A6O000300036O00010003000200062O0001002B2O013O0004593O002B2O012O008D000100063O0012CF0002002A3O0012CF0003002B4O00D8000100034O00BB00015O0012CF3O000E3O0004593O000100012O003F3O00017O00363O00028O00026O00F03F03073O004578656375746503073O004973526561647903083O004D612O7361637265030B3O004973417661696C61626C65030A3O004A752O6765726E61757403043O0052616765026O00494003113O00BF4CB343AF40B300BD51B845A85DB500EC03043O0020DA34D603123O004B0F34ABE4A4401A49123FADE3B9461A1F4703083O003A2E7751C891D025030B3O005468756E646572436C6170030A3O0049734361737461626C65030A3O00536869656C64536C616D030C3O00432O6F6C646F776E446F776E03063O0042752O66557003133O0056696F6C656E744F7574627572737442752O66026O001440030E3O004973496E4D656C2O6552616E676503173O003F8425A2ADB824148F3CADB9FD312E8235BEA0BE767ADE03073O00564BEC50CCC9DD027O0040026O00344003153O0061497E80F28F4D527B84F3CB75447980EC8271012503063O00EB122117E59E030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O6603083O0042752O66446F776E03163O0044B2D4B554BFD38453B6C0AB10BDC4B555A8C8B810EE03043O00DB30DAA1030F3O0053752O64656E446561746842752O66030B3O0053752O64656E446561746803113O00E169794ACE5BE5A4767947DE5DE9E7312A03073O008084111C29BB2F03073O00526576656E6765026O004E4003103O004865616C746850657263656E74616765030B3O00526576656E676542752O66026O003240025O0080414003123O001337103F530637463D580F3714335E41635203053O003D6152665A03123O00A936AE48D2431B49AB2BA54ED55E1D49FD7803083O0069CC4ECB2BA7377E03123O00B7AF351B1D03C211A2AF2D1B010DC411F4F203083O0031C5CA437E7364A7026O00084003173O002353CA2784534C0858D3289016593255DA3B89551E650B03073O003E573BBF49E03603093O0044657661737461746503143O00E307ECC8F416FBDDE242FDCCE907E8C0E442A89B03043O00A987629A00E9012O0012CF3O00013O0026223O007D000100020004593O007D00012O008D00015O0020A300010001000300205B0001000100042O00DC00010002000200061C0001002D00013O0004593O002D00012O008D000100013O00061C0001002D00013O0004593O002D00012O008D000100023O0026220001002D000100020004593O002D00012O008D00015O0020A300010001000500205B0001000100062O00DC0001000200020006790001001B000100010004593O001B00012O008D00015O0020A300010001000700205B0001000100062O00DC00010002000200061C0001002D00013O0004593O002D00012O008D000100033O00205B0001000100082O00DC000100020002000EB70009002D000100010004593O002D00012O008D000100044O006700025O00202O0002000200034O000300056O000300036O00010003000200062O0001002D00013O0004593O002D00012O008D000100063O0012CF0002000A3O0012CF0003000B4O00D8000100034O00BB00016O008D00015O0020A300010001000300205B0001000100042O00DC00010002000200061C0001004B00013O0004593O004B00012O008D000100013O00061C0001004B00013O0004593O004B00012O008D000100023O0026220001004B000100020004593O004B00012O008D000100033O00205B0001000100082O00DC000100020002000EB70009004B000100010004593O004B00012O008D000100044O006700025O00202O0002000200034O000300056O000300036O00010003000200062O0001004B00013O0004593O004B00012O008D000100063O0012CF0002000C3O0012CF0003000D4O00D8000100034O00BB00016O008D00015O0020A300010001000E00205B00010001000F2O00DC00010002000200061C0001007C00013O0004593O007C00012O008D000100073O00061C0001007C00013O0004593O007C00012O008D000100023O000E4100020064000100010004593O006400012O008D00015O0020A300010001001000205B0001000100112O00DC00010002000200061C0001007C00013O0004593O007C00012O008D000100033O0020C40001000100124O00035O00202O0003000300134O00010003000200062O0001007C000100010004593O007C00010012CF000100013O00262200010065000100010004593O006500012O008D000200083O0012BC000300146O0002000200014O000200046O00035O00202O00030003000E4O000400093O00202O0004000400154O0006000A6O0004000600024O000400046O00020004000200062O0002007C00013O0004593O007C00012O008D000200063O0012B4000300163O00122O000400176O000200046O00025O00044O007C00010004593O006500010012CF3O00183O0026223O00F0000100010004593O00F000012O008D00015O0020A300010001001000205B00010001000F2O00DC00010002000200061C0001009D00013O0004593O009D00012O008D0001000B3O00061C0001009D00013O0004593O009D00010012CF000100013O00262200010089000100010004593O008900012O008D000200083O001232000300196O0002000200014O000200046O00035O00202O0003000300104O000400056O000400046O00020004000200062O0002009D00013O0004593O009D00012O008D000200063O0012B40003001A3O00122O0004001B6O000200046O00025O00044O009D00010004593O008900012O008D00015O0020A300010001000E00205B00010001000F2O00DC00010002000200061C000100CC00013O0004593O00CC00012O008D000100073O00061C000100CC00013O0004593O00CC00012O008D000100093O0020C000010001001C4O00035O00202O00030003001D4O00010003000200262O000100CC000100020004593O00CC00012O008D000100033O00206300010001001E4O00035O00202O0003000300134O00010003000200062O000100CC00013O0004593O00CC00010012CF000100013O002622000100B5000100010004593O00B500012O008D000200083O0012BC000300146O0002000200014O000200046O00035O00202O00030003000E4O000400093O00202O0004000400154O0006000A6O0004000600024O000400046O00020004000200062O000200CC00013O0004593O00CC00012O008D000200063O0012B40003001F3O00122O000400206O000200046O00025O00044O00CC00010004593O00B500012O008D00015O0020A300010001000300205B0001000100042O00DC00010002000200061C000100EF00013O0004593O00EF00012O008D000100013O00061C000100EF00013O0004593O00EF00012O008D000100033O0020630001000100124O00035O00202O0003000300214O00010003000200062O000100EF00013O0004593O00EF00012O008D00015O0020A300010001002200205B0001000100062O00DC00010002000200061C000100EF00013O0004593O00EF00012O008D000100044O006700025O00202O0002000200034O000300056O000300036O00010003000200062O000100EF00013O0004593O00EF00012O008D000100063O0012CF000200233O0012CF000300244O00D8000100034O00BB00015O0012CF3O00023O0026223O009D2O0100180004593O009D2O012O008D00015O0020A300010001002500205B0001000100042O00DC00010002000200061C000100682O013O0004593O00682O012O008D0001000C3O00061C000100682O013O0004593O00682O012O008D000100033O00205B0001000100082O00DC000100020002000EB7002600052O0100010004593O00052O012O008D000100093O00205B0001000100272O00DC000100020002000E410019005B2O0100010004593O005B2O012O008D000100033O0020630001000100124O00035O00202O0003000300284O00010003000200062O0001001C2O013O0004593O001C2O012O008D000100093O00205B0001000100272O00DC0001000200020026130001001C2O0100190004593O001C2O012O008D000100033O00205B0001000100082O00DC0001000200020026130001001C2O0100290004593O001C2O012O008D00015O0020A300010001001000205B0001000100112O00DC0001000200020006790001005B2O0100010004593O005B2O012O008D000100033O0020630001000100124O00035O00202O0003000300284O00010003000200062O000100282O013O0004593O00282O012O008D000100093O00205B0001000100272O00DC000100020002000E410019005B2O0100010004593O005B2O012O008D000100033O00205B0001000100082O00DC000100020002000EB7002600322O0100010004593O00322O012O008D000100093O00205B0001000100272O00DC000100020002000E41002A00552O0100010004593O00552O012O008D000100033O0020630001000100124O00035O00202O0003000300284O00010003000200062O000100492O013O0004593O00492O012O008D000100093O00205B0001000100272O00DC000100020002002613000100492O01002A0004593O00492O012O008D000100033O00205B0001000100082O00DC000100020002002613000100492O0100290004593O00492O012O008D00015O0020A300010001001000205B0001000100112O00DC000100020002000679000100552O0100010004593O00552O012O008D000100033O0020630001000100124O00035O00202O0003000300284O00010003000200062O000100682O013O0004593O00682O012O008D000100093O00205B0001000100272O00DC000100020002000E14002A00682O0100010004593O00682O012O008D00015O0020A300010001000500205B0001000100062O00DC00010002000200061C000100682O013O0004593O00682O012O008D000100044O006700025O00202O0002000200254O000300056O000300036O00010003000200062O000100682O013O0004593O00682O012O008D000100063O0012CF0002002B3O0012CF0003002C4O00D8000100034O00BB00016O008D00015O0020A300010001000300205B0001000100042O00DC00010002000200061C000100812O013O0004593O00812O012O008D000100013O00061C000100812O013O0004593O00812O012O008D000100023O002622000100812O0100020004593O00812O012O008D000100044O006700025O00202O0002000200034O000300056O000300036O00010003000200062O000100812O013O0004593O00812O012O008D000100063O0012CF0002002D3O0012CF0003002E4O00D8000100034O00BB00016O008D00015O0020A300010001002500205B0001000100042O00DC00010002000200061C0001009C2O013O0004593O009C2O012O008D0001000C3O00061C0001009C2O013O0004593O009C2O012O008D000100093O00205B0001000100272O00DC000100020002000E140019009C2O0100010004593O009C2O012O008D000100044O006700025O00202O0002000200254O000300056O000300036O00010003000200062O0001009C2O013O0004593O009C2O012O008D000100063O0012CF0002002F3O0012CF000300304O00D8000100034O00BB00015O0012CF3O00313O0026223O0001000100310004593O000100012O008D00015O0020A300010001000E00205B00010001000F2O00DC00010002000200061C000100D02O013O0004593O00D02O012O008D000100073O00061C000100D02O013O0004593O00D02O012O008D000100023O000E53000200B82O0100010004593O00B82O012O008D00015O0020A300010001001000205B0001000100112O00DC00010002000200061C000100D02O013O0004593O00D02O012O008D000100033O0020630001000100124O00035O00202O0003000300134O00010003000200062O000100D02O013O0004593O00D02O010012CF000100013O002622000100B92O0100010004593O00B92O012O008D000200083O0012BC000300146O0002000200014O000200046O00035O00202O00030003000E4O000400093O00202O0004000400154O0006000A6O0004000600024O000400046O00020004000200062O000200D02O013O0004593O00D02O012O008D000200063O0012B4000300323O00122O000400336O000200046O00025O00044O00D02O010004593O00B92O012O008D00015O0020A300010001003400205B00010001000F2O00DC00010002000200061C000100E82O013O0004593O00E82O012O008D0001000D3O00061C000100E82O013O0004593O00E82O012O008D000100044O006700025O00202O0002000200344O000300056O000300036O00010003000200062O000100E82O013O0004593O00E82O012O008D000100063O0012B4000200353O00122O000300366O000100036O00015O00044O00E82O010004593O000100012O003F3O00017O000E3O00028O00030F3O00412O66656374696E67436F6D626174030B3O0042612O746C6553686F7574030A3O0049734361737461626C6503083O0042752O66446F776E030F3O0042612O746C6553686F757442752O6603103O0047726F757042752O664D692O73696E6703163O00C9763040F136F7D87F2B41E973D8D972275BF031C9DF03073O00A8AB1744349D53030C3O0042612O746C655374616E636503063O0042752O66557003173O00F670E1B92928B8E765F4A32628C7E463F0AE2A2085F56503073O00E7941195CD454D030D3O00546172676574497356616C696400653O0012CF3O00013O0026223O0001000100010004593O000100012O008D00015O00205B0001000100022O00DC00010002000200067900010048000100010004593O004800010012CF000100013O000E3700010009000100010004593O000900012O008D000200013O0020A300020002000300205B0002000200042O00DC00020002000200061C0002002E00013O0004593O002E00012O008D000200023O00061C0002002E00013O0004593O002E00012O008D00025O0020BE0002000200054O000400013O00202O0004000400064O000500016O00020005000200062O00020023000100010004593O002300012O008D000200033O0020BD0002000200074O000300013O00202O0003000300064O00020002000200062O0002002E00013O0004593O002E00012O008D000200044O008D000300013O0020A30003000300032O00DC00020002000200061C0002002E00013O0004593O002E00012O008D000200053O0012CF000300083O0012CF000400094O00D8000200044O00BB00026O008D000200013O0020A300020002000A00205B0002000200042O00DC00020002000200061C0002004800013O0004593O004800012O008D00025O0020C400020002000B4O000400013O00202O00040004000A4O00020004000200062O00020048000100010004593O004800012O008D000200044O008D000300013O0020A300030003000A2O00DC00020002000200061C0002004800013O0004593O004800012O008D000200053O0012B40003000C3O00122O0004000D6O000200046O00025O00044O004800010004593O000900012O008D000100033O0020A300010001000E2O001D00010001000200061C0001006400013O0004593O006400012O008D000100063O00061C0001006400013O0004593O006400012O008D00015O00205B0001000100022O00DC00010002000200067900010064000100010004593O006400010012CF000100013O000E3700010056000100010004593O005600012O008D000200084O001D0002000100022O00A4000200074O008D000200073O00061C0002006400013O0004593O006400012O008D000200074O0056000200023O0004593O006400010004593O005600010004593O006400010004593O000100012O003F3O00017O009D3O00028O00026O00F03F03113O0048616E646C65496E636F72706F7265616C03113O00496E74696D69646174696E6753686F7574031A3O00496E74696D69646174696E6753686F75744D6F7573656F766572026O00204003093O0053746F726D426F6C7403123O0053746F726D426F6C744D6F7573656F766572026O003440030D3O00546172676574497356616C6964026O000840030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O00B786EECF03063O009FE0C7A79B37030E3O00C7FC33DEB7F533C0B7D233D7BFBA03043O00B297935C026O002240027O0040030B3O004865726F69635468726F77030A3O0049734361737461626C6503093O004973496E52616E6765026O003E4003113O0084F85E3D1B4F4598F55E3D050C778DF44203073O001AEC9D2C52722C030D3O00577265636B696E675468726F77030F3O00412O66656374696E67436F6D62617403133O003D3CD0582127DB5C153ADD49253995562B27DB03043O003B4A4EB503063O00417661746172030D3O0024C75B4EB23791575BBA2B910803053O00D345B12O3A026O001C4003093O0053686F636B7761766503063O0042752O665570030A3O0041766174617242752O6603103O00556E73746F2O7061626C65466F726365030B3O004973417661696C61626C65030D3O0052756D626C696E67456172746803093O00536F6E6963422O6F6D03093O00497343617374696E67026O002440030E3O004973496E4D656C2O6552616E676503113O00A4ED76F6E2DCB6F37CB5E4CABEEB39A6BB03063O00ABD785199589030C3O00536869656C64436861726765030E3O0049735370652O6C496E52616E676503153O00F2C03BFFE334C341E9C920FDEA70F143E8C672A9BB03083O002281A8529A8F509C030B3O00536869656C64426C6F636B03143O0096BA3A0E444AB687BE3C08430E2O84BB3D4B1B1603073O00E9E5D2536B282E03063O00436861726765030E3O00C24A33C402C4023FD70CCF02618203053O0065A12252B603103O004865616C746850657263656E74616765030B3O00566963746F72795275736803073O004973526561647903113O00FE045AEAD4F09B11FA184AF69BEA872FE403083O004E886D399EBB82E203103O00496D70656E64696E67566963746F727903163O003732E9F4303BF0FF3900EFF83D2BF6E3277FF1F43F3303043O00915E5F99030F3O00446566656E736976655374616E6365031E3O00F9C812D040A4F4DB11EA5DA3FCC317D00EA0F5C418D00EA3FCC31FDC40B003063O00D79DAD74B52E030C3O0042612O746C655374616E6365031F3O0037B59FE6D6308B98E6DB3BB78EB2CD3DBD87F79A3BBB9FB2CE34BA80FBD43203053O00BA55D4EB9203153O00D1891FFB35EA67C18917EC3EEB18CF801FF079BD0C03073O0038A2E1769E598E03043O006B24E99B03063O00B83C65A0CF4203133O00576169742F502O6F6C205265736F7572636573026O001040030A3O0049676E6F72655061696E030B3O005261676544656669636974026O002E40030A3O00536869656C64536C616D030A3O00432O6F6C646F776E5570026O00444003103O004368616D70696F6E7342756C7761726B03113O0044656D6F72616C697A696E6753686F7574030C3O00422O6F6D696E67566F696365025O00804640030D3O004C6173745374616E6442752O66030E3O00552O6E657276696E67466F63757303133O0056696F6C656E744F7574627572737442752O6603123O004865617679526570657263752O73696F6E7303103O00496D70656E65747261626C6557612O6C025O00804B40026O003140026O00324003133O00388572B3238743AC308B72FC3C8375B271D02C03043O00DC51E21C03093O004C6173745374616E6403083O0042752O66446F776E030E3O00536869656C6457612O6C42752O66025O0080564003073O00426F6C7374657203073O004861735469657203143O001FD491EFD5D407D48CFFAAC316D387F5F9CE05D003063O00A773B5E29B8A03063O00F22EE6457E6303073O00A68242873C1B1103073O0052617661676572030D3O0052617661676572506C61796572030F3O00564BD8743741588E78314D448E276403053O0050242AAE15026O001440026O00184003063O004D052569410203043O001A2E7057030E3O0053706561726F6642617374696F6E03143O0053706561724F6642617374696F6E437572736F7203183O00AA33AE75AD804AB28621AA67ABB64ABAF92EAA7DB1FF17EC03083O00D4D943CB142ODF25030E3O005468756E6465726F7573526F617203173O00AE85BDDCBE88BADDAF9E97C0B58CBA92B78CA1DCFADEF803043O00B2DAEDC8030A3O0046657276696442752O6603133O00A5BDEFD5BAB1D9C3BAB4EB90BBB4EFDEF6E6B703043O00B0D6D58603063O00F7B8A4C7A74403073O003994CDD6B4C836030D3O0052617661676572437572736F72030F4O00FC23357117EF7539771BF375662203053O0016729D5554031A3O00C0CE1ECB4FF7A4CDD11ACA5AC9BBCCC406D01DFBA9CDC553960503073O00C8A4AB73A43D9603063O00AEF8025C86AC03053O00E3DE94632503143O0053706561724F6642617374696F6E506C6179657203183O00204257F7EB0C5D54C9FB324146FFF63D125FF7F03D1200AE03053O0099532O329603093O00426C2O6F644675727903113O005F7A7C1377944B48646A5C7EAA4453362703073O002D3D16137C13CB030A3O004265727365726B696E6703113O00C3171FE60762B2C81C0AB50F71B0CF525B03073O00D9A1726D956210030D3O00417263616E65546F2O72656E7403153O0013323B7DB2712D34376EAE711C347871BD7D1C2O6003063O00147240581CDC030E3O004C69676874734A7564676D656E7403173O003D08D5BCECC3823B14D6B3F5D5B32541DFB5F1DEFD605103073O00DD5161B2D498B0030B3O004261676F66547269636B7303163O00CCE91EFE09D9F51CF725CEE611F75AC0E614F55A9CB103053O007AAD877D9B03093O0046697265626C2O6F6403113O0082C812BC2O3DC78BC540B43E38C6C4905203073O00A8E4A160D95F51030D3O00416E6365737472616C43612O6C03163O00DADF2D593C43C9D022632C56D7DD6E512E5ED5917F0803063O0037BBB14E3C4F030F3O0048616E646C65445053506F74696F6E0074052O0012CF3O00013O0026223O000C000100010004593O000C00012O008D000100014O001D0001000100022O00A400016O008D00015O00061C0001000B00013O0004593O000B00012O008D00016O0056000100023O0012CF3O00023O0026223O0001000100020004593O000100012O008D000100023O00061C0001003700013O0004593O003700010012CF000100013O00262200010024000100020004593O002400012O008D000200033O0020830002000200034O000300043O00202O0003000300044O000400053O00202O00040004000500122O000500066O000600016O0002000600024O00028O00025O00062O0002003700013O0004593O003700012O008D00026O0056000200023O0004593O0037000100262200010012000100010004593O001200012O008D000200033O0020830002000200034O000300043O00202O0003000300074O000400053O00202O00040004000800122O000500096O000600016O0002000600024O00028O00025O00062O0002003500013O0004593O003500012O008D00026O0056000200023O0012CF000100023O0004593O001200012O008D000100033O0020A300010001000A2O001D00010001000200061C0001007305013O0004593O007305010012CF000100014O0096000200023O0026220001006D000100060004593O006D00012O008D000300063O000E14000B0064000100030004593O006400010012CF000300013O00262200030058000100020004593O005800012O008D000400073O00202600040004000C4O000500043O00202O00050005000D4O00068O000700083O00122O0008000E3O00122O0009000F6O000700096O00043O000200062O0004006400013O0004593O006400012O008D000400083O0012B4000500103O00122O000600116O000400066O00045O00044O0064000100262200030044000100010004593O004400012O008D000400094O001D0004000100022O00A400046O008D00045O00061C0004006200013O0004593O006200012O008D00046O0056000400023O0012CF000300023O0004593O004400012O008D0003000A4O001D0003000100022O00A400036O008D00035O00061C0003006C00013O0004593O006C00012O008D00036O0056000300023O0012CF000100123O002622000100D2000100130004593O00D200012O008D0003000B3O00061C0003008E00013O0004593O008E00012O008D000300043O0020A300030003001400205B0003000300152O00DC00030002000200061C0003008E00013O0004593O008E00012O008D0003000C3O00205B0003000300160012CF000500174O00B60003000500020006790003008E000100010004593O008E00012O008D0003000D4O00B2000400043O00202O0004000400144O0005000C3O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O0003008E00013O0004593O008E00012O008D000300083O0012CF000400183O0012CF000500194O00D8000300054O00BB00036O008D000300043O0020A300030003001A00205B0003000300152O00DC00030002000200061C000300B000013O0004593O00B000012O008D0003000E3O00061C000300B000013O0004593O00B000012O008D0003000C3O00205B00030003001B2O00DC00030002000200061C000300B000013O0004593O00B000012O008D0003000F4O001D00030001000200061C000300B000013O0004593O00B000012O008D0003000D4O00B2000400043O00202O00040004001A4O0005000C3O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O000300B000013O0004593O00B000012O008D000300083O0012CF0004001C3O0012CF0005001D4O00D8000300054O00BB00036O008D000300104O008D000400113O00064F000300D1000100040004593O00D100012O008D000300123O00061C000300D100013O0004593O00D100012O008D000300133O00061C000300BD00013O0004593O00BD00012O008D000300143O000679000300C0000100010004593O00C000012O008D000300133O000679000300D1000100010004593O00D100012O008D000300043O0020A300030003001E00205B0003000300152O00DC00030002000200061C000300D100013O0004593O00D100012O008D0003000D4O008D000400043O0020A300040004001E2O00DC00030002000200061C000300D100013O0004593O00D100012O008D000300083O0012CF0004001F3O0012CF000500204O00D8000300054O00BB00035O0012CF0001000B3O002622000100562O0100210004593O00562O012O008D000300043O0020A300030003002200205B0003000300152O00DC00030002000200061C000300F000013O0004593O00F000012O008D000300153O00061C000300F000013O0004593O00F000012O008D000300163O0020630003000300234O000500043O00202O0005000500244O00030005000200062O000300F000013O0004593O00F000012O008D000300043O0020A300030003002500205B0003000300262O00DC00030002000200061C000300F000013O0004593O00F000012O008D000300043O0020A300030003002700205B0003000300262O00DC00030002000200061C000300042O013O0004593O00042O012O008D000300043O0020A300030003002800205B0003000300262O00DC00030002000200061C0003001C2O013O0004593O001C2O012O008D000300043O0020A300030003002700205B0003000300262O00DC00030002000200061C0003001C2O013O0004593O001C2O012O008D000300063O000EB7000B001C2O0100030004593O001C2O012O008D0003000C3O00205B0003000300292O00DC00030002000200061C0003001C2O013O0004593O001C2O010012CF000300013O000E37000100052O0100030004593O00052O012O008D000400173O0012BC0005002A6O0004000200014O0004000D6O000500043O00202O0005000500224O0006000C3O00202O00060006002B4O000800186O0006000800024O000600066O00040006000200062O0004001C2O013O0004593O001C2O012O008D000400083O0012B40005002C3O00122O0006002D6O000400066O00045O00044O001C2O010004593O00052O012O008D000300104O008D000400113O00064F000300432O0100040004593O00432O012O008D000300043O0020A300030003002E00205B0003000300152O00DC00030002000200061C000300432O013O0004593O00432O012O008D000300193O00061C000300432O013O0004593O00432O012O008D0003001A3O00061C0003002F2O013O0004593O002F2O012O008D000300143O000679000300322O0100010004593O00322O012O008D0003001A3O000679000300432O0100010004593O00432O012O008D0003000D4O00C5000400043O00202O00040004002E4O0005000C3O00202O00050005002F4O000700043O00202O00070007002E4O0005000700024O000500056O00030005000200062O000300432O013O0004593O00432O012O008D000300083O0012CF000400303O0012CF000500314O00D8000300054O00BB00036O008D0003001B4O001D00030001000200061C000300552O013O0004593O00552O012O008D0003001C3O00061C000300552O013O0004593O00552O012O008D0003000D4O008D000400043O0020A30004000400322O00DC00030002000200061C000300552O013O0004593O00552O012O008D000300083O0012CF000400333O0012CF000500344O00D8000300054O00BB00035O0012CF000100063O002622000100CA2O0100020004593O00CA2O012O008D0003001D3O00061C000300752O013O0004593O00752O012O008D000300043O0020A300030003003500205B0003000300152O00DC00030002000200061C000300752O013O0004593O00752O012O008D0003001E3O000679000300752O0100010004593O00752O012O008D0003000D4O00C5000400043O00202O0004000400354O0005000C3O00202O00050005002F4O000700043O00202O0007000700354O0005000700024O000500056O00030005000200062O000300752O013O0004593O00752O012O008D000300083O0012CF000400363O0012CF000500374O00D8000300054O00BB00036O008D000300163O00205B0003000300382O00DC0003000200022O008D0004001F3O00064F000300AC2O0100040004593O00AC2O010012CF000300013O0026220003007C2O0100010004593O007C2O012O008D000400043O0020A300040004003900205B00040004003A2O00DC00040002000200061C000400942O013O0004593O00942O012O008D000400203O00061C000400942O013O0004593O00942O012O008D0004000D4O0067000500043O00202O0005000500394O0006001E6O000600066O00040006000200062O000400942O013O0004593O00942O012O008D000400083O0012CF0005003B3O0012CF0006003C4O00D8000400064O00BB00046O008D000400043O0020A300040004003D00205B00040004003A2O00DC00040002000200061C000400AC2O013O0004593O00AC2O012O008D000400203O00061C000400AC2O013O0004593O00AC2O012O008D0004000D4O0067000500043O00202O00050005003D4O0006001E6O000600066O00040006000200062O000400AC2O013O0004593O00AC2O012O008D000400083O0012B40005003E3O00122O0006003F6O000400066O00045O00044O00AC2O010004593O007C2O012O008D000300104O008D000400113O00064F000300C92O0100040004593O00C92O012O008D000300213O00061C000300C92O013O0004593O00C92O012O008D000300143O00061C000300B92O013O0004593O00B92O012O008D000300223O000679000300BC2O0100010004593O00BC2O012O008D000300223O000679000300C92O0100010004593O00C92O010012CF000300013O002622000300BD2O0100010004593O00BD2O012O008D000400234O001D0004000100022O00A400046O008D00045O00061C000400C92O013O0004593O00C92O012O008D00046O0056000400023O0004593O00C92O010004593O00BD2O010012CF000100133O00262200010039020100010004593O003902012O008D000300243O00061C000300ED2O013O0004593O00ED2O012O008D000300163O00205B0003000300382O00DC0003000200022O008D000400253O00060A000300ED2O0100040004593O00ED2O012O008D000300043O0020A300030003004000205B0003000300152O00DC00030002000200061C000300ED2O013O0004593O00ED2O012O008D000300163O0020C40003000300234O000500043O00202O0005000500404O00030005000200062O000300ED2O0100010004593O00ED2O012O008D0003000D4O008D000400043O0020A30004000400402O00DC00030002000200061C000300ED2O013O0004593O00ED2O012O008D000300083O0012CF000400413O0012CF000500424O00D8000300054O00BB00036O008D000300243O00061C0003000E02013O0004593O000E02012O008D000300163O00205B0003000300382O00DC0003000200022O008D000400253O00064F0004000E020100030004593O000E02012O008D000300043O0020A300030003004300205B0003000300152O00DC00030002000200061C0003000E02013O0004593O000E02012O008D000300163O0020C40003000300234O000500043O00202O0005000500434O00030005000200062O0003000E020100010004593O000E02012O008D0003000D4O008D000400043O0020A30004000400432O00DC00030002000200061C0003000E02013O0004593O000E02012O008D000300083O0012CF000400443O0012CF000500454O00D8000300054O00BB00036O008D000300193O00061C0003003802013O0004593O003802012O008D0003001A3O00061C0003001702013O0004593O001702012O008D000300143O0006790003001A020100010004593O001A02012O008D0003001A3O00067900030038020100010004593O003802012O008D000300104O008D000400113O00064F00030038020100040004593O003802012O008D000300043O0020A300030003002E00205B0003000300152O00DC00030002000200061C0003003802013O0004593O003802012O008D0003001E3O00067900030038020100010004593O003802012O008D0003000D4O00C5000400043O00202O00040004002E4O0005000C3O00202O00050005002F4O000700043O00202O00070007002E4O0005000700024O000500056O00030005000200062O0003003802013O0004593O003802012O008D000300083O0012CF000400463O0012CF000500474O00D8000300054O00BB00035O0012CF000100023O0026220001004A020100120004593O004A02012O008D000300073O00202600030003000C4O000400043O00202O00040004000D4O00058O000600083O00122O000700483O00122O000800496O000600086O00033O000200062O0003007305013O0004593O007305010012CF0003004A4O0056000300023O0004593O00730501000E37004B00C9030100010004593O00C903012O008D000300043O0020A300030003004C00205B00030003003A2O00DC00030002000200061C0003005403013O0004593O005403012O008D000300263O00061C0003005403013O0004593O005403012O008D000300274O001D00030001000200061C0003005403013O0004593O005403012O008D0003000C3O00205B0003000300382O00DC000300020002000EB700090054030100030004593O005403012O008D000300163O00205B00030003004D2O00DC000300020002002613000300690201004E0004593O006902012O008D000300043O0020A300030003004F00205B0003000300502O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC0003000200020026130003007A020100510004593O007A02012O008D000300043O0020A300030003002E00205B0003000300502O00DC00030002000200061C0003007A02013O0004593O007A02012O008D000300043O0020A300030003005200205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC00030002000200261300030085020100090004593O008502012O008D000300043O0020A300030003002E00205B0003000300502O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC00030002000200261300030096020100170004593O009602012O008D000300043O0020A300030003005300205B0003000300502O00DC00030002000200061C0003009602013O0004593O009602012O008D000300043O0020A300030003005400205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300A1020100090004593O00A102012O008D000300043O0020A300030003001E00205B0003000300502O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300BF020100550004593O00BF02012O008D000300043O0020A300030003005300205B0003000300502O00DC00030002000200061C000300BF02013O0004593O00BF02012O008D000300043O0020A300030003005400205B0003000300262O00DC00030002000200061C000300BF02013O0004593O00BF02012O008D000300163O0020630003000300234O000500043O00202O0005000500564O00030005000200062O000300BF02013O0004593O00BF02012O008D000300043O0020A300030003005700205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300D7020100170004593O00D702012O008D000300043O0020A300030003001E00205B0003000300502O00DC00030002000200061C000300D702013O0004593O00D702012O008D000300163O0020630003000300234O000500043O00202O0005000500564O00030005000200062O000300D702013O0004593O00D702012O008D000300043O0020A300030003005700205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC0003000200020026D100030047030100090004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300FA020100510004593O00FA02012O008D000300043O0020A300030003004F00205B0003000300502O00DC00030002000200061C000300FA02013O0004593O00FA02012O008D000300163O0020630003000300234O000500043O00202O0005000500584O00030005000200062O000300FA02013O0004593O00FA02012O008D000300043O0020A300030003005900205B0003000300262O00DC00030002000200061C000300FA02013O0004593O00FA02012O008D000300043O0020A300030003005A00205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300250301005B0004593O002503012O008D000300043O0020A300030003004F00205B0003000300502O00DC00030002000200061C0003002503013O0004593O002503012O008D000300163O0020630003000300234O000500043O00202O0005000500584O00030005000200062O0003002503013O0004593O002503012O008D000300163O0020630003000300234O000500043O00202O0005000500564O00030005000200062O0003002503013O0004593O002503012O008D000300043O0020A300030003005700205B0003000300262O00DC00030002000200061C0003002503013O0004593O002503012O008D000300043O0020A300030003005900205B0003000300262O00DC00030002000200061C0003002503013O0004593O002503012O008D000300043O0020A300030003005A00205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300360301005C0004593O003603012O008D000300043O0020A300030003004F00205B0003000300502O00DC00030002000200061C0003003603013O0004593O003603012O008D000300043O0020A300030003005900205B0003000300262O00DC00030002000200067900030047030100010004593O004703012O008D000300163O00205B00030003004D2O00DC000300020002002613000300540301005D0004593O005403012O008D000300043O0020A300030003004F00205B0003000300502O00DC00030002000200061C0003005403013O0004593O005403012O008D000300043O0020A300030003005A00205B0003000300262O00DC00030002000200061C0003005403013O0004593O005403012O008D0003000D4O0068000400043O00202O00040004004C4O000500066O000700016O00030007000200062O0003005403013O0004593O005403012O008D000300083O0012CF0004005E3O0012CF0005005F4O00D8000300054O00BB00036O008D000300284O001D00030001000200061C0003009603013O0004593O009603012O008D000300293O00061C0003009603013O0004593O009603012O008D000300043O0020A300030003006000205B0003000300152O00DC00030002000200061C0003009603013O0004593O009603012O008D000300163O0020630003000300614O000500043O00202O0005000500624O00030005000200062O0003009603013O0004593O009603012O008D0003000C3O00205B0003000300382O00DC000300020002000EB700630073030100030004593O007303012O008D000300043O0020A300030003005700205B0003000300262O00DC0003000200020006790003008B030100010004593O008B03012O008D0003000C3O00205B0003000300382O00DC0003000200020026130003007E030100090004593O007E03012O008D000300043O0020A300030003005700205B0003000300262O00DC0003000200020006790003008B030100010004593O008B03012O008D000300043O0020A300030003006400205B0003000300262O00DC0003000200020006790003008B030100010004593O008B03012O008D000300163O00202D00030003006500122O000500173O00122O000600136O00030006000200062O0003009603013O0004593O009603012O008D0003000D4O008D000400043O0020A30004000400602O00DC00030002000200061C0003009603013O0004593O009603012O008D000300083O0012CF000400663O0012CF000500674O00D8000300054O00BB00036O008D000300104O008D000400113O00064F000300C8030100040004593O00C803012O008D0003002A3O00061C000300C803013O0004593O00C803012O008D0003002B3O00061C000300A303013O0004593O00A303012O008D000300143O000679000300A6030100010004593O00A603012O008D0003002B3O000679000300C8030100010004593O00C803012O008D0003002C4O009B000400083O00122O000500683O00122O000600696O00040006000200062O000300C8030100040004593O00C803012O008D000300043O0020A300030003006A00205B0003000300152O00DC00030002000200061C000300C803013O0004593O00C803010012CF000300013O002622000300B4030100010004593O00B403012O008D000400173O0012320005002A6O0004000200014O0004000D6O000500053O00202O00050005006B4O0006001E6O000600066O00040006000200062O000400C803013O0004593O00C803012O008D000400083O0012B40005006C3O00122O0006006D6O000400066O00045O00044O00C803010004593O00B403010012CF0001006E3O002622000100410401006F0004593O004104012O008D000300104O008D000400113O00064F000300FD030100040004593O00FD03012O008D0003002D3O00061C000300FD03013O0004593O00FD03012O008D0003002E3O00061C000300D803013O0004593O00D803012O008D000300143O000679000300DB030100010004593O00DB03012O008D0003002E3O000679000300FD030100010004593O00FD03012O008D0003002F4O009B000400083O00122O000500703O00122O000600716O00040006000200062O000300FD030100040004593O00FD03012O008D000300043O0020A300030003007200205B0003000300152O00DC00030002000200061C000300FD03013O0004593O00FD03010012CF000300013O002622000300E9030100010004593O00E903012O008D000400173O001232000500096O0004000200014O0004000D6O000500053O00202O0005000500734O0006001E6O000600066O00040006000200062O000400FD03013O0004593O00FD03012O008D000400083O0012B4000500743O00122O000600756O000400066O00045O00044O00FD03010004593O00E903012O008D000300104O008D000400113O00064F00030023040100040004593O002304012O008D000300303O00061C0003002304013O0004593O002304012O008D000300313O00061C0003000A04013O0004593O000A04012O008D000300143O0006790003000D040100010004593O000D04012O008D000300313O00067900030023040100010004593O002304012O008D000300043O0020A300030003007600205B0003000300152O00DC00030002000200061C0003002304013O0004593O002304012O008D0003000D4O0077000400043O00202O0004000400764O0005000C3O00202O00050005002B4O000700186O0005000700024O000500056O00030005000200062O0003002304013O0004593O002304012O008D000300083O0012CF000400773O0012CF000500784O00D8000300054O00BB00036O008D000300043O0020A300030003004F00205B0003000300152O00DC00030002000200061C0003004004013O0004593O004004012O008D000300323O00061C0003004004013O0004593O004004012O008D000300163O0020630003000300234O000500043O00202O0005000500794O00030005000200062O0003004004013O0004593O004004012O008D0003000D4O0067000400043O00202O00040004004F4O0005001E6O000500056O00030005000200062O0003004004013O0004593O004004012O008D000300083O0012CF0004007A3O0012CF0005007B4O00D8000300054O00BB00035O0012CF000100213O002622000100CC0401006E0004593O00CC04012O008D000300104O008D000400113O00064F00030075040100040004593O007504012O008D0003002A3O00061C0003007504013O0004593O007504012O008D0003002B3O00061C0003005004013O0004593O005004012O008D000300143O00067900030053040100010004593O005304012O008D0003002B3O00067900030075040100010004593O007504012O008D0003002C4O009B000400083O00122O0005007C3O00122O0006007D6O00040006000200062O00030075040100040004593O007504012O008D000300043O0020A300030003006A00205B0003000300152O00DC00030002000200061C0003007504013O0004593O007504010012CF000300013O00262200030061040100010004593O006104012O008D000400173O0012320005002A6O0004000200014O0004000D6O000500053O00202O00050005007E4O0006001E6O000600066O00040006000200062O0004007504013O0004593O007504012O008D000400083O0012B40005007F3O00122O000600806O000400066O00045O00044O007504010004593O006104012O008D000300043O0020A300030003005300205B0003000300152O00DC00030002000200061C0003009904013O0004593O009904012O008D000300333O00061C0003009904013O0004593O009904012O008D000300043O0020A300030003005400205B0003000300262O00DC00030002000200061C0003009904013O0004593O009904010012CF000300013O00262200030085040100010004593O008504012O008D000400173O001232000500176O0004000200014O0004000D6O000500043O00202O0005000500534O0006001E6O000600066O00040006000200062O0004009904013O0004593O009904012O008D000400083O0012B4000500813O00122O000600826O000400066O00045O00044O009904010004593O008504012O008D000300104O008D000400113O00064F000300CB040100040004593O00CB04012O008D0003002D3O00061C000300CB04013O0004593O00CB04012O008D0003002E3O00061C000300A604013O0004593O00A604012O008D000300143O000679000300A9040100010004593O00A904012O008D0003002E3O000679000300CB040100010004593O00CB04012O008D0003002F4O009B000400083O00122O000500833O00122O000600846O00040006000200062O000300CB040100040004593O00CB04012O008D000300043O0020A300030003007200205B0003000300152O00DC00030002000200061C000300CB04013O0004593O00CB04010012CF000300013O002622000300B7040100010004593O00B704012O008D000400173O001232000500096O0004000200014O0004000D6O000500053O00202O0005000500854O0006001E6O000600066O00040006000200062O000400CB04013O0004593O00CB04012O008D000400083O0012B4000500863O00122O000600876O000400066O00045O00044O00CB04010004593O00B704010012CF0001006F3O000E37000B003E000100010004593O003E00012O008D000300104O008D000400113O00064F00030063050100040004593O006305012O008D000300343O00061C0003006305013O0004593O006305012O008D000300353O00061C000300DB04013O0004593O00DB04012O008D000300143O000679000300DE040100010004593O00DE04012O008D000300353O00067900030063050100010004593O006305010012CF000300013O00262200030004050100010004593O000405012O008D000400043O0020A300040004008800205B0004000400152O00DC00040002000200061C000400F204013O0004593O00F204012O008D0004000D4O008D000500043O0020A30005000500882O00DC00040002000200061C000400F204013O0004593O00F204012O008D000400083O0012CF000500893O0012CF0006008A4O00D8000400064O00BB00046O008D000400043O0020A300040004008B00205B0004000400152O00DC00040002000200061C0004000305013O0004593O000305012O008D0004000D4O008D000500043O0020A300050005008B2O00DC00040002000200061C0004000305013O0004593O000305012O008D000400083O0012CF0005008C3O0012CF0006008D4O00D8000400064O00BB00045O0012CF000300023O00262200030029050100020004593O002905012O008D000400043O0020A300040004008E00205B0004000400152O00DC00040002000200061C0004001705013O0004593O001705012O008D0004000D4O008D000500043O0020A300050005008E2O00DC00040002000200061C0004001705013O0004593O001705012O008D000400083O0012CF0005008F3O0012CF000600904O00D8000400064O00BB00046O008D000400043O0020A300040004009100205B0004000400152O00DC00040002000200061C0004002805013O0004593O002805012O008D0004000D4O008D000500043O0020A30005000500912O00DC00040002000200061C0004002805013O0004593O002805012O008D000400083O0012CF000500923O0012CF000600934O00D8000400064O00BB00045O0012CF000300133O000E37000B003D050100030004593O003D05012O008D000400043O0020A300040004009400205B0004000400152O00DC00040002000200061C0004006305013O0004593O006305012O008D0004000D4O008D000500043O0020A30005000500942O00DC00040002000200061C0004006305013O0004593O006305012O008D000400083O0012B4000500953O00122O000600966O000400066O00045O00044O00630501002622000300DF040100130004593O00DF04012O008D000400043O0020A300040004009700205B0004000400152O00DC00040002000200061C0004005005013O0004593O005005012O008D0004000D4O008D000500043O0020A30005000500972O00DC00040002000200061C0004005005013O0004593O005005012O008D000400083O0012CF000500983O0012CF000600994O00D8000400064O00BB00046O008D000400043O0020A300040004009A00205B0004000400152O00DC00040002000200061C0004006105013O0004593O006105012O008D0004000D4O008D000500043O0020A300050005009A2O00DC00040002000200061C0004006105013O0004593O006105012O008D000400083O0012CF0005009B3O0012CF0006009C4O00D8000400064O00BB00045O0012CF0003000B3O0004593O00DF04012O008D000300033O00205200030003009D4O0004000C3O00202O0004000400234O000600043O00202O0006000600244O000400066O00033O00024O000200033O00062O0002006F05013O0004593O006F05012O0056000200023O0012CF0001004B3O0004593O003E00010004593O007305010004593O000100012O003F3O00017O00323O00028O00027O0040030C3O004570696353652O74696E677303083O0053652O74696E6773030C3O0038DD5AD84EC08326D95EFD4303073O00E04DAE3F8B26AF030E3O0091525D1A8C54562A81537B22855103043O004EE4213803103O00DB6DB73497CB7DB90A8BC94ABA118AD903053O00E5AE1ED26303093O000EFE8370FB3C2D1AFF03073O00597B8DE6318D5D026O000840026O001040030C3O00F267F7181158C478E204336E03063O002A9311966C70030D3O001DA73B7EE0ED1D91246BEFCB2B03063O00886FC64D1F8703123O001101AE53B1E034A1031BA0538AED03A1212D03083O00C96269C736DD847703143O00AA1C8620101AAA9B0D90350B3AA28E059729211103073O00CCD96CE3416255026O001440026O00F03F030A3O004BD0F0C034C55DD6E1E003063O00A03EA395854C030E3O00C3B30807C6C4AF042CF7DEB2023803053O00A3B6C06D4F030A3O00213505F2F022230EC7F003053O0095544660A0030D3O002D1508DE300F08E13C3501EC3503043O008D58666D03143O00A75BDF7E1E3847CEA640F87F1B2F62C8A75BE95403083O00A1D333AA107A5D35030E3O00EEBDB70AFABAA624FE9DBA27EEBA03043O00489BCED203093O005369512D3B4768530B03053O0053261A346E03143O004D0422625D1A2854591B2E5C511920755018325203043O0026387747030C3O00E6FC5DF22040F2FC4CD7315303063O0036938F38B645030A3O00C392FA7BDEC080F84CCD03053O00BFB6E19F29030F3O003E012D66838EC727160B5D8A95C52E03073O00A24B724835EBE703113O00992F41D143078D2E6BE471039F284DED5D03063O0062EC5C24823303113O00B10A098E4DBDBB34A10B03AF569ABA31B603083O0050C4796CDA25C8D500BD3O0012CF3O00013O000E370002002400013O0004593O0024000100120E000100033O0020100001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O000E37000E004700013O0004593O0047000100120E000100033O0020100001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00124O00173O000E370018006A00013O0004593O006A000100120E000100033O0020100001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O0001000100024O0001000C3O00124O00023O0026223O0075000100170004593O0075000100120E000100033O00205A0001000100044O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00044O00BC00010026223O0098000100010004593O0098000100120E000100033O0020100001000100044O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00124O00183O0026223O00010001000D0004593O0001000100120E000100033O0020100001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O0003002F3O00122O000400306O0002000400024O0001000100024O000100143O00122O000100033O00202O0001000100044O000200013O00122O000300313O00122O000400326O0002000400024O0001000100024O000100153O00124O000E3O0004593O000100012O003F3O00017O003B3O00028O00026O001440030C3O004570696353652O74696E677303083O0053652O74696E6773030B3O000C72116B781A8B0E772A4F03073O00EA6013621F2B6E03103O00141E5ECBB57B85013C40DE8B6084130F03073O00EB667F32A7CC12030D3O0042A0F92F5D275EA6D6315D066003063O004E30C1954324026O001840026O00F03F03113O00250D853A48240A850A683D13951648240703053O0021507EE078030D3O00F9BB06ED5BE2A711C16CEDA10D03053O003C8CC863A4030C3O0092E7010FAC93F11630A789F103053O00C2E7946446027O0040026O00104003103O004445D5B7F3DA6F41CCB6F8C15255E99303063O00A8262CA1C396030C3O0089FB8C7922ED861789F2AA4603083O0076E09CE2165088D6030B3O004BE04D8550F85C8E47C66903043O00E0228E39030C3O00CBB4C0F172E2493DCAA6CBD903083O006EBEC7A5BD13913D030E3O00CFF872DA8ACBD6F27EE68CE4C8F203063O00A7BA8B1788EB030E3O000FA68D3E12BC8D011E97840219BE03043O006D7AD5E8026O000840030D3O00FDFFAB35E2F3803CE1F4A918DE03043O00508E97C2030C3O0010CE7E490FC2404D0FCA5F7C03043O002C63A617030D3O006AFE2A223CB665C53C253B8C4C03063O00C41C97495653026O001C4003113O00F7062F158C4B1160F6303D118C5B1D5EC303083O001693634970E23878030E3O00AA742OF48ABD67D1F099AC7CECF203053O00EDD8158295034O00030C3O00915E5A5EA2FA5B965A5651B703073O003EE22E2O3FD0A9030D3O00F00A50B017042A52E12E548F1303083O003E857935E37F6D4F030E3O00050737C3DFADB61F062BC7C3BDAA03073O00C270745295B6CE030F3O002CBB493BC8E3003EAD7F0CC1EC0D3C03073O006E59C82C78A08203093O00BED04E7656473648A703083O002DCBA32B26232A5B030C3O00C796D91093A646DFA7D32F9303073O0034B2E5BC43E7C903143O003452552DF9482A2C485405E3552D2672580BE24803073O004341213064973C00FF3O0012CF3O00013O0026223O0025000100020004593O0025000100120E000100033O00203C0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004593O000D00010012CF000100014O00A400015O001264000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O00010001000200062O00010018000100010004593O001800010012CF000100014O00A4000100023O001264000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200062O00010023000100010004593O002300010012CF000100014O00A4000100033O0012CF3O000B3O0026223O00400001000C0004593O0040000100120E000100033O0020740001000100044O000200013O00122O0003000D3O00122O0004000E6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00124O00133O000E370014006400013O0004593O0064000100120E000100033O00203C0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O00010001000200062O0001004C000100010004593O004C00010012CF000100014O00A4000100073O001264000100033O00202O0001000100044O000200013O00122O000300173O00122O000400186O0002000400024O00010001000200062O00010057000100010004593O005700010012CF000100014O00A4000100083O001264000100033O00202O0001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O00010001000200062O00010062000100010004593O006200010012CF000100014O00A4000100093O0012CF3O00023O0026223O007F000100130004593O007F000100120E000100033O0020740001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O0001000100024O0001000C3O00124O00213O0026223O00A30001000B0004593O00A3000100120E000100033O00203C0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O00010001000200062O0001008B000100010004593O008B00010012CF000100014O00A40001000D3O001264000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O00010001000200062O00010096000100010004593O009600010012CF000100014O00A40001000E3O001264000100033O00202O0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O00010001000200062O000100A1000100010004593O00A100010012CF000100014O00A40001000F3O0012CF3O00283O0026223O00C7000100280004593O00C7000100120E000100033O00203C0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O00010001000200062O000100AF000100010004593O00AF00010012CF000100014O00A4000100103O001264000100033O00202O0001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200062O000100BA000100010004593O00BA00010012CF0001002D4O00A4000100113O001264000100033O00202O0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100C5000100010004593O00C500010012CF0001002D4O00A4000100123O0004593O00FE00010026223O00E2000100210004593O00E2000100120E000100033O0020740001000100044O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100143O00122O000100033O00202O0001000100044O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100153O00124O00143O0026223O0001000100010004593O0001000100120E000100033O0020740001000100044O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000100163O00122O000100033O00202O0001000100044O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000100173O00122O000100033O00202O0001000100044O000200013O00122O0003003A3O00122O0004003B6O0002000400024O0001000100024O000100183O00124O000C3O0004593O000100012O003F3O00017O00233O00028O00026O000840030C3O004570696353652O74696E677303083O0053652O74696E677303113O00F7E2AFD4FAD1E09ED7E7D6E8A0F6F2D2E203053O0093BF87CEB8034O0003113O00AC29A8C5D4569B8A2BA9D3C85CA08129AA03073O00D2E448C6A1B83303113O003040F41867FC3344F2197DDD1541F6137803063O00AE562993701303113O00720E990E371D04BB4F37841F2D3C05BE5503083O00CB3B60ED6B456F7103163O000D18B8E423E2C2340283EF3DE9E02C1FB8E43DF9C43003073O00B74476CC81519003123O0027A364E119901BBD64D003900BBE78EB078603063O00E26ECD10846B026O00F03F027O0040030E3O00FED0E5F144EACFF4D152FFCCEEDC03053O00218BA380B903103O00424B01F6525908D7595F34D143510BD003043O00BE373864030D3O005EAA3D1207EBE042A0321B3BD303073O009336CF5C7E7383030F3O00052O347104700A013A69047103190503063O001E6D51551D6D030B3O00EA62518224D7F2F47440A503073O009C9F1134D656BE030A3O00BBFCB88EAFECB4BDA2FC03043O00DCCE8FDD030E3O00926F2419D3C9C6954A2403D0EFF603073O00B2E61D4D77B8AC030D3O00E7BF091276F4E689030F7FDBD103063O009895DE6A7B17008B3O0012CF3O00013O0026223O0017000100020004593O0017000100120E000100033O00203C0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004593O000D00010012CF000100074O00A400015O001219000100033O00202O0001000100044O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100023O00044O008A00010026223O003D000100010004593O003D000100120E000100033O00203C0001000100044O000200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200062O00010023000100010004593O002300010012CF000100014O00A4000100033O00122F000100033O00202O0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00124O00123O0026223O0066000100130004593O0066000100120E000100033O0020450001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O00010001000200062O00010059000100010004593O005900010012CF000100014O00A4000100093O001264000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200062O00010064000100010004593O006400010012CF000100014O00A40001000A3O0012CF3O00023O0026223O0001000100120004593O0001000100120E000100033O0020100001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00122O000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000E3O00124O00133O0004593O000100012O003F3O00017O001B3O00028O00026O001040030C3O0049734368612O6E656C696E67030F3O00412O66656374696E67436F6D626174026O00F03F026O00084003163O00476574456E656D696573496E4D656C2O6552616E6765030E3O004973496E4D656C2O6552616E6765030D3O00546172676574497356616C6964024O0080B3C540030C3O00466967687452656D61696E7303103O00426F2O73466967687452656D61696E73027O0040030C3O004570696353652O74696E677303073O00546F2O676C657303043O00D62FF54803053O00D5BD469623030D3O004973446561644F7247686F737403113O00496E74696D69646174696E6753686F7574030B3O004973417661696C61626C65026O0020402O033O00405A7703043O00682F35142O033O00A2438403063O006FC32CE17CDC2O033O00DB421303063O00CBB8266013CB00A63O0012CF3O00013O0026223O0029000100020004593O002900012O008D00015O00205B0001000100032O00DC000100020002000679000100A5000100010004593O00A500012O008D00015O00205B0001000100042O00DC00010002000200061C0001001B00013O0004593O001B00010012CF000100013O0026220001000E000100010004593O000E00012O008D000200024O001D0002000100022O00A4000200014O008D000200013O00061C000200A500013O0004593O00A500012O008D000200014O0056000200023O0004593O00A500010004593O000E00010004593O00A500010012CF000100013O0026220001001C000100010004593O001C00012O008D000200034O001D0002000100022O00A4000200014O008D000200013O00061C000200A500013O0004593O00A500012O008D000200014O0056000200023O0004593O00A500010004593O001C00010004593O00A500010026223O0032000100010004593O003200012O008D000100044O00860001000100014O000100056O0001000100014O000100066O00010001000100124O00053O0026223O0070000100060004593O007000012O008D000100073O00061C0001004500013O0004593O004500010012CF000100013O000E3700010038000100010004593O003800012O008D00025O0020AD0002000200074O000400096O0002000400024O000200086O000200086O000200026O0002000A3O00044O004700010004593O003800010004593O004700010012CF000100054O00A40001000A4O008D0001000C3O0020020001000100084O000300096O0001000300024O0001000B6O0001000D3O00202O0001000100094O00010001000200062O00010056000100010004593O005600012O008D00015O00205B0001000100042O00DC00010002000200061C0001006F00013O0004593O006F00010012CF000100013O00262200010063000100050004593O006300012O008D0002000E3O0026220002006F0001000A0004593O006F00012O008D0002000F3O00205E00020002000B4O000300086O00048O0002000400024O0002000E3O00044O006F000100262200010057000100010004593O005700012O008D0002000F3O00201700020002000C4O000300036O000400016O0002000400024O000200106O000200106O0002000E3O00122O000100053O00044O005700010012CF3O00023O000E37000D008900013O0004593O0089000100120E0001000E3O00208500010001000F4O000200123O00122O000300103O00122O000400116O0002000400024O0001000100024O000100116O00015O00202O0001000100124O00010002000200062O0001008000013O0004593O008000012O003F3O00014O008D000100133O0020A300010001001300205B0001000100142O00DC00010002000200061C0001008800013O0004593O008800010012CF000100154O00A4000100093O0012CF3O00063O0026223O0001000100050004593O0001000100120E0001000E3O00207400010001000F4O000200123O00122O000300163O00122O000400176O0002000400024O0001000100024O000100143O00122O0001000E3O00202O00010001000F4O000200123O00122O000300183O00122O000400196O0002000400024O0001000100024O000100073O00122O0001000E3O00202O00010001000F4O000200123O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O000100153O00124O000D3O0004593O000100012O003F3O00017O00033O0003053O005072696E7403313O0009617655CB3A67704EC079447853DC307C6B01CC20335C51C73A3D3972DB29637653DA3C773943D7796B5240C03C67760F03053O00AE5913192100084O00C67O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);
