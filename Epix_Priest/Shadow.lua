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
				if (Enum <= 152) then
					if (Enum <= 75) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
										elseif (Enum > 2) then
											local B;
											local A;
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
									elseif (Enum <= 6) then
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
									elseif (Enum > 7) then
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 11) then
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
									elseif (Enum > 12) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 15) then
									if (Enum == 14) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 16) then
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
								elseif (Enum == 17) then
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
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum > 19) then
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
									elseif (Enum > 21) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
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
								elseif (Enum <= 24) then
									if (Enum > 23) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 25) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 26) then
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
								end
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum == 28) then
										Stk[Inst[2]] = {};
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
								elseif (Enum <= 30) then
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
								elseif (Enum > 31) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 34) then
								if (Enum > 33) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 35) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 36) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum > 38) then
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
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 40) then
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
								elseif (Enum <= 43) then
									if (Enum == 42) then
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
								elseif (Enum <= 44) then
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
								elseif (Enum > 45) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								else
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								end
							elseif (Enum <= 51) then
								if (Enum <= 48) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										do
											return;
										end
									end
								elseif (Enum <= 49) then
									if (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 50) then
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 53) then
								if (Enum == 52) then
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								else
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
								end
							elseif (Enum <= 54) then
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
							elseif (Enum > 55) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 65) then
							if (Enum <= 60) then
								if (Enum <= 58) then
									if (Enum > 57) then
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
								elseif (Enum == 59) then
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
									Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 62) then
								if (Enum > 61) then
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
							elseif (Enum <= 63) then
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
								A = Inst[2];
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
							elseif (Enum == 64) then
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
						elseif (Enum <= 70) then
							if (Enum <= 67) then
								if (Enum > 66) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum <= 68) then
								VIP = Inst[3];
							elseif (Enum == 69) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 72) then
							if (Enum > 71) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 73) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						elseif (Enum > 74) then
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
					elseif (Enum <= 113) then
						if (Enum <= 94) then
							if (Enum <= 84) then
								if (Enum <= 79) then
									if (Enum <= 77) then
										if (Enum == 76) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 78) then
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
								elseif (Enum <= 81) then
									if (Enum > 80) then
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
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									end
								elseif (Enum <= 82) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 83) then
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
							elseif (Enum <= 89) then
								if (Enum <= 86) then
									if (Enum == 85) then
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
									end
								elseif (Enum <= 87) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 88) then
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
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								end
							elseif (Enum <= 91) then
								if (Enum > 90) then
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
							elseif (Enum <= 92) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 93) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							end
						elseif (Enum <= 103) then
							if (Enum <= 98) then
								if (Enum <= 96) then
									if (Enum == 95) then
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
								elseif (Enum == 97) then
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 100) then
								if (Enum > 99) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 101) then
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
							elseif (Enum == 102) then
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
						elseif (Enum <= 108) then
							if (Enum <= 105) then
								if (Enum == 104) then
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
									A = Inst[2];
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
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 106) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 107) then
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
						elseif (Enum <= 110) then
							if (Enum > 109) then
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
								A = Inst[2];
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
							end
						elseif (Enum <= 111) then
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
						elseif (Enum > 112) then
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 132) then
						if (Enum <= 122) then
							if (Enum <= 117) then
								if (Enum <= 115) then
									if (Enum == 114) then
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
								elseif (Enum > 116) then
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
									A = Inst[2];
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
								end
							elseif (Enum <= 119) then
								if (Enum > 118) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								end
							elseif (Enum <= 120) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 121) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
							end
						elseif (Enum <= 127) then
							if (Enum <= 124) then
								if (Enum > 123) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 125) then
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
							elseif (Enum > 126) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum <= 129) then
							if (Enum == 128) then
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
						elseif (Enum <= 130) then
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
						elseif (Enum == 131) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						else
							local A = Inst[2];
							Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 142) then
						if (Enum <= 137) then
							if (Enum <= 134) then
								if (Enum > 133) then
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
								else
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
							elseif (Enum <= 135) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							elseif (Enum > 136) then
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
						elseif (Enum <= 139) then
							if (Enum == 138) then
								local B;
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
						elseif (Enum <= 140) then
							local A = Inst[2];
							do
								return Unpack(Stk, A, A + Inst[3]);
							end
						elseif (Enum == 141) then
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
							VIP = Inst[3];
						end
					elseif (Enum <= 147) then
						if (Enum <= 144) then
							if (Enum > 143) then
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
						elseif (Enum <= 145) then
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum == 146) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 149) then
						if (Enum == 148) then
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						else
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
						end
					elseif (Enum <= 150) then
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
					elseif (Enum > 151) then
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
				elseif (Enum <= 229) then
					if (Enum <= 190) then
						if (Enum <= 171) then
							if (Enum <= 161) then
								if (Enum <= 156) then
									if (Enum <= 154) then
										if (Enum == 153) then
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									elseif (Enum == 155) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 158) then
									if (Enum > 157) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									end
								elseif (Enum <= 159) then
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
								elseif (Enum == 160) then
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
							elseif (Enum <= 166) then
								if (Enum <= 163) then
									if (Enum == 162) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 164) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
								end
							elseif (Enum <= 168) then
								if (Enum > 167) then
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 169) then
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
							elseif (Enum == 170) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 180) then
							if (Enum <= 175) then
								if (Enum <= 173) then
									if (Enum == 172) then
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
									else
										Stk[Inst[2]] = not Stk[Inst[3]];
									end
								elseif (Enum > 174) then
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
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 177) then
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
							elseif (Enum <= 178) then
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
							elseif (Enum > 179) then
								if (Inst[2] <= Stk[Inst[4]]) then
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
						elseif (Enum <= 185) then
							if (Enum <= 182) then
								if (Enum > 181) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 183) then
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
						elseif (Enum <= 187) then
							if (Enum == 186) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 188) then
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
						elseif (Enum == 189) then
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
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 209) then
						if (Enum <= 199) then
							if (Enum <= 194) then
								if (Enum <= 192) then
									if (Enum == 191) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 196) then
								if (Enum == 195) then
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
							elseif (Enum <= 197) then
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							elseif (Enum > 198) then
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
							end
						elseif (Enum <= 204) then
							if (Enum <= 201) then
								if (Enum == 200) then
									Env[Inst[3]] = Stk[Inst[2]];
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
							elseif (Enum == 203) then
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
						elseif (Enum <= 206) then
							if (Enum == 205) then
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
							end
						elseif (Enum <= 207) then
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
							Env[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 208) then
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
						elseif (Stk[Inst[2]] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 219) then
						if (Enum <= 214) then
							if (Enum <= 211) then
								if (Enum > 210) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 212) then
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
							elseif (Enum > 213) then
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
						elseif (Enum <= 216) then
							if (Enum > 215) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 217) then
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						elseif (Enum > 218) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						else
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 224) then
						if (Enum <= 221) then
							if (Enum == 220) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
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
						elseif (Enum <= 222) then
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
						elseif (Enum == 223) then
							if (Inst[2] < Stk[Inst[4]]) then
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
					elseif (Enum <= 226) then
						if (Enum == 225) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						VIP = Inst[3];
					elseif (Enum > 228) then
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
				elseif (Enum <= 267) then
					if (Enum <= 248) then
						if (Enum <= 238) then
							if (Enum <= 233) then
								if (Enum <= 231) then
									if (Enum == 230) then
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
								elseif (Enum > 232) then
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
							elseif (Enum <= 235) then
								if (Enum > 234) then
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
							elseif (Enum <= 236) then
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
							elseif (Enum > 237) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 243) then
							if (Enum <= 240) then
								if (Enum == 239) then
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
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 241) then
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum == 242) then
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
						elseif (Enum <= 245) then
							if (Enum > 244) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 247) then
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
					elseif (Enum <= 257) then
						if (Enum <= 252) then
							if (Enum <= 250) then
								if (Enum == 249) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
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
								end
							elseif (Enum > 251) then
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
						elseif (Enum <= 254) then
							if (Enum == 253) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 262) then
						if (Enum <= 259) then
							if (Enum == 258) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							end
						elseif (Enum <= 260) then
							Stk[Inst[2]] = Inst[3] ~= 0;
						elseif (Enum == 261) then
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
							A = Inst[2];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 264) then
						if (Enum == 263) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
						end
					elseif (Enum <= 265) then
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
					elseif (Enum > 266) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 286) then
					if (Enum <= 276) then
						if (Enum <= 271) then
							if (Enum <= 269) then
								if (Enum == 268) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 270) then
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
						elseif (Enum <= 273) then
							if (Enum > 272) then
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
						elseif (Enum <= 274) then
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
						elseif (Enum == 275) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 281) then
						if (Enum <= 278) then
							if (Enum > 277) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 279) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 280) then
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
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
						else
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
						end
					elseif (Enum <= 283) then
						if (Enum > 282) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
					elseif (Enum <= 284) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 285) then
						Stk[Inst[2]]();
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
				elseif (Enum <= 296) then
					if (Enum <= 291) then
						if (Enum <= 288) then
							if (Enum > 287) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum <= 289) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 290) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 293) then
						if (Enum == 292) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 294) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 295) then
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
					else
						Stk[Inst[2]] = Inst[3];
					end
				elseif (Enum <= 301) then
					if (Enum <= 298) then
						if (Enum == 297) then
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
							A = Inst[2];
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
						end
					elseif (Enum <= 299) then
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
					elseif (Enum == 300) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 303) then
					if (Enum == 302) then
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
				elseif (Enum <= 304) then
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
				elseif (Enum == 305) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!3B3O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403063O00506C6179657203063O005461726765742O033O0050657403053O00466F63757303093O004D6F7573654F76657203053O005370652O6C03043O004974656D03053O004D6163726F03043O004361737403053O005072652O73030B3O005072652O73437572736F7203073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03043O006D6174682O033O006D696E028O0003063O0050726965737403063O00536861646F77024O0080B3C540030A3O004D696E6462656E646572030B3O004973417661696C61626C65030B3O00536861646F776669656E6403103O005265676973746572466F724576656E7403143O00837C64450608C2817562590D05D89D716750061E03073O009DD330251C435A03243O00D53F7D3E4EA220C430682E5DB520C72C6C3451A633DD26682351A831CB3F613656A03AD003073O007F947C297718E7030E3O0022B20889FB22BD0E8DF63FA5088103053O00B771E24DC503143O006C7C94EE6E7C91E3736990F06C669CF27F6D94FE03043O00BC2039D503143O00D8256C6938D124726826D12C61643FDA3F797A3403053O007694602D3B030B3O00536861646F77437261736803163O005265676973746572496E466C69676874452O66656374024O005012094103103O005265676973746572496E466C69676874030F3O004465766F7572696E67506C6167756503133O005265676973746572504D756C7469706C69657203153O004465766F7572696E67506C61677565446562752O6603063O0053657441504C025O002070400010022O00126F3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004443O000A000100122E000300063O0020D900040003000700122E000500083O0020D900050005000900122E000600083O0020D900060006000A00062B00073O000100062O00FD3O00064O00FD8O00FD3O00044O00FD3O00014O00FD3O00024O00FD3O00054O00300108000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000D001000202O000F000D001100202O0010000D001200202O0011000D00130020D90012000D00140020350013000B001500202O0014000B001600122O0015000D3O00202O00160015001700202O00170015001800202O00180015001900202O00190015001A00202O001A0015001B00202O001A001A001C00202O001A001A001D0020D9001B0015001B002085001B001B001C00202O001B001B001E00122O001C001F3O00202O001C001C002000122O001D00216O001E8O001F8O00208O00218O002200503O0020D900510013002200201801510051002300202O00520014002200202O00520052002300202O00530016002200202O0053005300234O00548O005500593O00202O005A0015001B00202O005A005A001C4O005B005B3O001227015C00243O0012C3005D00246O005E8O005F5O00122O006000216O00618O00628O00638O00648O00655O00202O0066005100250020220166006600262O00F000660002000200062E0166005300013O0004443O005300010020D900660051002500062901660054000100010004443O005400010020D90066005100272O000401675O001227016800214O000401696O0046006A006C3O002022016D000B002800062B006F00010001000E2O00FD3O00634O00FD3O00644O00FD3O00654O00FD3O00674O00FD3O00684O00FD3O00694O00FD3O00604O00FD3O00614O00FD3O00624O00FD3O005F4O00FD3O005C4O00FD3O005D4O00FD3O005E4O00FD3O006A4O004B007000073O00122O007100293O00122O0072002A6O007000726O006D3O000100062B006D0002000100012O00FD3O005A3O002022016E000B002800062B00700003000100012O00FD3O006D4O004B007100073O00122O0072002B3O00122O0073002C6O007100736O006E3O0001002022016E000B002800062B00700004000100022O00FD3O00664O00FD3O00514O0083007100073O00122O0072002D3O00122O0073002E6O0071007300024O007200073O00122O0073002F3O00122O007400306O007200746O006E3O000100202O006E000B002800062B00700005000100012O00FD3O00514O004B007100073O00122O007200313O00122O007300326O007100736O006E3O00010020D9006E00510033002022016E006E0034001227017000354O0093006E007000010020D9006E00510033002022016E006E00362O0084006E0002000100062B006E0006000100022O00FD3O00514O00FD3O000E3O002076006F0051003700202O006F006F003800202O0071005100394O0072006E6O006F0072000100062B006F0007000100012O00FD3O00513O00062B00700008000100022O00FD3O001A4O00FD3O00513O00062B00710009000100012O00FD3O00513O0002030172000A3O00062B0073000B000100012O00FD3O00513O00062B0074000C000100022O00FD3O00514O00FD3O00633O00062B0075000D000100032O00FD3O00514O00FD3O00594O00FD3O006C3O00062B0076000E000100022O00FD3O00514O00FD3O006C3O00062B0077000F000100032O00FD3O00514O00FD3O006C4O00FD3O00683O00062B00780010000100022O00FD3O006F4O00FD3O00513O00062B00790011000100022O00FD3O00514O00FD3O000E3O00062B007A0012000100042O00FD3O00664O00FD3O00514O00FD3O00674O00FD3O000E3O00062B007B0013000100022O00FD3O000E4O00FD3O00513O000203017C00143O00062B007D0015000100042O00FD3O00514O00FD3O00684O00FD3O00674O00FD3O00593O00062B007E0016000100012O00FD3O00513O00062B007F0017000100022O00FD3O006F4O00FD3O00513O00062B00800018000100022O00FD3O00514O00FD3O00623O00062B00810019000100032O00FD3O00514O00FD3O00634O00FD3O00623O00062B0082001A000100012O00FD3O006F3O00062B0083001B0001000A2O00FD3O00514O00FD3O00184O00FD3O000F4O00FD3O00074O00FD3O006A4O00FD3O001F4O00FD3O000E4O00FD3O004E4O00FD3O00124O00FD3O00533O00062B0084001C000100072O00FD3O005E4O00FD3O006F4O00FD3O000F4O00FD3O00514O00FD3O005F4O00FD3O00654O00FD3O000E3O00062B0085001D0001000C2O00FD3O00704O00FD3O00574O00FD3O00614O00FD3O00624O00FD3O00514O00FD3O001A4O00FD3O00604O00FD3O00634O00FD3O001C4O00FD3O00594O00FD3O00504O00FD3O00643O00062B0086001E000100062O00FD3O000E4O00FD3O00514O00FD3O005D4O00FD3O005B4O00FD3O005A4O00FD3O00543O00062B0087001F0001000C2O00FD3O00514O00FD3O00184O00FD3O000F4O00FD3O00074O00FD3O005B4O00FD3O00864O00FD3O004E4O00FD3O00124O00FD3O000E4O00FD3O00534O00FD3O00664O00FD3O001F3O00062B00880020000100162O00FD3O00514O00FD3O000E4O00FD3O005A4O00FD3O00564O00FD3O00074O00FD3O00734O00FD3O000F4O00FD3O007B4O00FD3O00534O00FD3O00184O00FD3O00674O00FD3O00724O00FD3O00114O00FD3O00434O00FD3O00404O00FD3O00414O00FD3O00424O00FD3O006B4O00FD3O004E4O00FD3O00124O00FD3O007C4O00FD3O007E3O00062B008900210001000C2O00FD3O00514O00FD3O000E4O00FD3O005D4O00FD3O00184O00FD3O00074O00FD3O001F4O00FD3O005B4O00FD3O00864O00FD3O00664O00FD3O00674O00FD3O00594O00FD3O000B3O00062B008A00220001001E2O00FD3O00514O00FD3O005E4O00FD3O000E4O00FD3O00184O00FD3O000F4O00FD3O00074O00FD3O00634O00FD3O005A4O00FD3O00564O00FD3O007F4O00FD3O00534O00FD3O005B4O00FD3O00884O00FD3O005D4O00FD3O00754O00FD3O004E4O00FD3O00124O00FD3O00734O00FD3O00744O00FD3O006B4O00FD3O00844O00FD3O001F4O00FD3O00594O00FD3O00894O00FD3O00664O00FD3O006C4O00FD3O00674O00FD3O00684O00FD3O00774O00FD3O007D3O00062B008B0023000100062O00FD3O00514O00FD3O006F4O00FD3O000F4O00FD3O000E4O00FD3O00184O00FD3O00073O00062B008C0024000100212O00FD3O00854O00FD3O00514O00FD3O00604O00FD3O00644O00FD3O005A4O00FD3O00564O00FD3O00804O00FD3O000F4O00FD3O00534O00FD3O00074O00FD3O00634O00FD3O004E4O00FD3O00184O00FD3O00124O00FD3O000E4O00FD3O001F4O00FD3O005D4O00FD3O00594O00FD3O005B4O00FD3O00894O00FD3O008B4O00FD3O00824O00FD3O006B4O00FD3O00884O00FD3O00814O00FD3O005E4O00FD3O00624O00FD3O00664O00FD3O006C4O00FD3O00684O00FD3O00674O00FD3O00654O00FD3O00763O00062B008D00250001001D2O00FD3O00514O00FD3O00354O00FD3O000E4O00FD3O00364O00FD3O00184O00FD3O00074O00FD3O00334O00FD3O00344O00FD3O00234O00FD3O00254O00FD3O00244O00FD3O00524O00FD3O00534O00FD3O00324O00FD3O00314O00FD3O005A4O00FD3O000F4O00FD3O004B4O00FD3O004C4O00FD3O004D4O00FD3O00214O00FD3O00454O00FD3O00444O00FD3O00474O00FD3O00464O00FD3O00494O00FD3O00484O00FD3O00374O00FD3O00383O00062B008E0026000100092O00FD3O001D4O00FD3O00294O00FD3O00514O00FD3O00284O00FD3O000E4O00FD3O00184O00FD3O00534O00FD3O00074O00FD3O00273O00062B008F0027000100062O00FD3O00514O00FD3O00204O00FD3O005A4O00FD3O00184O00FD3O00534O00FD3O00073O00062B00900028000100302O00FD3O00264O00FD3O00074O00FD3O00274O00FD3O00284O00FD3O00294O00FD3O004A4O00FD3O004B4O00FD3O004C4O00FD3O004D4O00FD3O00364O00FD3O00374O00FD3O00384O00FD3O00394O00FD3O002A4O00FD3O002B4O00FD3O002C4O00FD3O002D4O00FD3O00324O00FD3O00334O00FD3O00344O00FD3O00354O00FD3O004E4O00FD3O004F4O00FD3O00504O00FD3O002E4O00FD3O002F4O00FD3O00304O00FD3O00314O00FD3O003A4O00FD3O003B4O00FD3O003C4O00FD3O003D4O00FD3O00464O00FD3O00474O00FD3O00484O00FD3O00494O00FD3O003E4O00FD3O003F4O00FD3O00404O00FD3O00414O00FD3O00424O00FD3O00434O00FD3O00444O00FD3O00454O00FD3O00224O00FD3O00234O00FD3O00244O00FD3O00253O00062B009100290001002F2O00FD3O005A4O00FD3O000E4O00FD3O001E4O00FD3O005B4O00FD3O00834O00FD3O008A4O00FD3O008D4O00FD3O00514O00FD3O00124O00FD3O00534O00FD3O002C4O00FD3O00694O00FD3O000F4O00FD3O006A4O00FD3O006F4O00FD3O00874O00FD3O00184O00FD3O00074O00FD3O00114O00FD3O002A4O00FD3O008F4O00FD3O00204O00FD3O002B4O00FD3O00594O00FD3O00584O00FD3O008C4O00FD3O002D4O00FD3O00634O00FD3O00654O00FD3O00564O00FD3O00574O00FD3O00554O00FD3O00214O00FD3O001D4O00FD3O00904O00FD3O001F4O00FD3O00264O00FD3O004A4O00FD3O008E4O00FD3O005C4O00FD3O000B4O00FD3O005D4O00FD3O006B4O00FD3O006C4O00FD3O00684O00FD3O00664O00FD3O00673O00062B0092002A000100042O00FD3O00154O00FD3O00074O00FD3O006D4O00FD3O00513O00204800930015003A00122O0094003B6O009500916O009600926O0093009600016O00013O002B3O00023O00026O00F03F026O00704002264O006100025O00122O000300016O00045O00122O000500013O00042O0003002100012O004D00076O00F7000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O004D000C00034O0010000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0092000C6O00A4000A3O0002002050000A000A00022O00B50009000A4O00DA00073O000100048D0003000500012O004D000300054O00FD000400024O00B6000300044O005800036O002F3O00017O000A3O00028O00026O000840026O001040026O001440027O0040026O00F03F03113O005661724D696E64536561724375746F2O66030D3O00566172502O6F6C416D6F756E74026O004E40024O0080B3C54000353O001227012O00013O002O26012O000A000100020004443O000A00012O00042O016O00FA00018O00018O000100016O00018O000100023O00124O00033O002O26012O0013000100030004443O001300012O00042O016O00192O0100033O00122O000100016O000100046O00018O000100053O00124O00043O002O26012O001C000100050004443O001C00010012272O0100014O00FA000100066O00018O000100076O00018O000100083O00124O00023O002O26012O0025000100060004443O002500012O00042O016O00CF000100093O00122O000100053O00122O000100073O00122O000100093O00122O000100083O00124O00053O002O26012O002E000100010004443O002E00010012272O01000A4O00192O01000A3O00122O0001000A6O0001000B6O00018O0001000C3O00124O00063O002O26012O0001000100040004443O000100012O0046000100014O007A0001000D3O0004443O003400010004443O000100012O002F3O00017O00023O0003123O0044697370652O6C61626C65446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667300054O00879O0000015O00202O00010001000200104O000100016O00019O003O00034O004D8O001D012O000100012O002F3O00017O00033O00030A3O004D696E6462656E646572030B3O004973417661696C61626C65030B3O00536861646F776669656E64000E4O00CE3O00013O00206O000100206O00026O0002000200064O000A00013O0004443O000A00012O004D3O00013O0020D95O0001000629012O000C000100010004443O000C00012O004D3O00013O0020D95O00032O007A8O002F3O00017O00053O00028O00030B3O00536861646F77437261736803163O005265676973746572496E466C69676874452O66656374024O005012094103103O005265676973746572496E466C69676874000F3O001227012O00013O002O26012O0001000100010004443O000100012O004D00015O00203B00010001000200202O00010001000300122O000300046O0001000300014O00015O00202O00010001000200202O0001000100054O00010002000100044O000E00010004443O000100012O002F3O00017O00143O00028O00027O004003103O00446973746F727465645265616C697479030B3O004973417661696C61626C650200344O33F33F03063O0042752O66557003103O004D696E644465766F7572657242752O6602345O33F33F026O000840026O00F03F03113O004461726B417363656E73696F6E42752O66026O00F43F03123O004461726B4576616E67656C69736D42752O6603093O0042752O66537461636B022O00AE47E17A843F03103O004465766F757265644665617242752O6603113O004465766F75726564507269646542752O660200CD4OCCF03F030B3O00566F6964746F75636865640200285C8FC2F5F03F004D3O001227012O00014O0046000100013O002O26012O0014000100020004443O001400012O004D00025O0020D90002000200030020220102000200042O00F000020002000200062E0102000B00013O0004443O000B00010020340001000100052O004D000200013O0020E20002000200064O00045O00202O0004000400074O00020004000200062O0002001300013O0004443O00130001002034000100010008001227012O00093O002O26012O0020000100010004443O002000010012272O01000A4O00A3000200013O00202O0002000200064O00045O00202O00040004000B4O00020004000200062O0002001F00013O0004443O001F000100203400010001000C001227012O000A3O002O26012O00410001000A0004443O004100012O004D000200013O0020E20002000200064O00045O00202O00040004000D4O00020004000200062O0002003100013O0004443O003100012O004D000200013O0020EE00020002000E4O00045O00202O00040004000D4O00020004000200102O0002000F000200102O0002000A00024O0001000100022O004D000200013O0020230102000200064O00045O00202O0004000400104O00020004000200062O0002003F000100010004443O003F00012O004D000200013O0020E20002000200064O00045O00202O0004000400114O00020004000200062O0002004000013O0004443O00400001002034000100010012001227012O00023O002O26012O0002000100090004443O000200012O004D00025O0020D90002000200130020220102000200042O00F000020002000200062E0102004A00013O0004443O004A00010020340001000100142O0042000100023O0004443O000200012O002F3O00017O00043O0003083O00446562752O66557003143O00536861646F77576F72645061696E446562752O6603133O0056616D7069726963546F756368446562752O6603153O004465766F7572696E67506C61677565446562752O6602203O00062E2O01001400013O0004443O0014000100202201023O00012O004D00045O0020D90004000400022O00F500020004000200062E0102001200013O0004443O0012000100202201023O00012O004D00045O0020D90004000400032O00F500020004000200062E0102001200013O0004443O0012000100202201023O00012O004D00045O0020D90004000400042O00F50002000400022O0042000200023O0004443O001F000100202201023O00012O004D00045O0020D90004000400022O00F500020004000200062E0102001E00013O0004443O001E000100202201023O00012O004D00045O0020D90004000400032O00F50002000400022O0042000200024O002F3O00017O00073O00028O00027O0040026O00F03F03053O00706169727303093O0054696D65546F44696503113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66023E3O001227010200014O0046000300043O002O2601020005000100020004443O000500012O0042000400023O000E310001000D000100020004443O000D0001000629012O000B000100010004443O000B00012O0046000500054O0042000500023O001227010300013O001227010200033O002O2601020002000100030004443O000200012O0046000400043O00122E000500044O00FD00066O00690005000200070004443O00390001001227010A00014O0046000B000B3O002O26010A0016000100010004443O00160001002022010C000900052O00F0000C000200022O00FD000B000C3O00062E2O01002E00013O0004443O002E00012O004D000C5O002047000D000900064O000F00013O00202O000F000F00074O000D000F6O000C3O00024O000C000B000C00062O000300390001000C0004443O00390001001227010C00013O002O26010C0027000100010004443O002700012O00FD0003000B4O00FD000400093O0004443O003900010004443O002700010004443O003900010006B7000300390001000B0004443O00390001001227010C00013O002O26010C0031000100010004443O003100012O00FD0003000B4O00FD000400093O0004443O003900010004443O003100010004443O003900010004443O001600010006EB00050014000100020004443O00140001001227010200023O0004443O000200012O002F3O00017O00023O00030D3O00446562752O6652656D61696E7303143O00536861646F77576F72645061696E446562752O6601063O0020BE00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00013O0003093O0054696D65546F44696501043O0020222O013O00012O00F00001000200022O0042000100024O002F3O00017O00023O00030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O6601063O0020BE00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O000A3O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603093O0054696D65546F446965026O002840030B3O00536861646F774372617368030F3O00432O6F6C646F776E52656D61696E73030D3O00446562752O6652656D61696E7303083O00496E466C6967687403113O0057686973706572696E67536861646F7773030B3O004973417661696C61626C6501273O0020E200013O00014O00035O00202O0003000300024O00010003000200062O0001002500013O0004443O002500010020222O013O00032O00F0000100020002000EB400040023000100010004443O002300012O004D00015O0020212O010001000500202O0001000100064O00010002000200202O00023O00074O00045O00202O0004000400024O00020004000200062O0002001A000100010004443O001A00012O004D00015O0020D90001000100050020222O01000100082O00F000010002000200062E2O01002400013O0004443O002400012O004D000100013O0006292O010025000100010004443O002500012O004D00015O00207F00010001000900202O00010001000A4O0001000200024O000100013O00044O002500012O001200016O00042O0100014O0042000100024O002F3O00017O00053O0003103O00446973746F727465645265616C697479030B3O004973417661696C61626C65026O00F03F030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6601144O00CE00015O00202O00010001000100202O0001000100024O00010002000200062O0001001100013O0004443O001100012O004D000100013O00260700010011000100030004443O001100010020222O013O00042O00E900035O00202O0003000300054O0001000300024O000200023O00062O00010002000100020004443O001100012O001200016O00042O0100014O0042000100024O002F3O00017O00043O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603103O00446973746F727465645265616C697479030B3O004973417661696C61626C6501113O00205C00013O00014O00035O00202O0003000300024O0001000300024O000200013O00062O00010008000100020004443O000E00012O004D00015O00207F00010001000300202O0001000100044O0001000200024O000100013O00044O000F00012O001200016O00042O0100014O0042000100024O002F3O00017O00053O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603093O004D696E64426C617374030B3O004578656375746554696D6503103O0046752O6C526563686172676554696D6501233O00200500013O00014O00035O00202O0003000300024O0001000300024O00025O00202O00020002000300202O0002000200044O00020002000200062O00020016000100010004443O001600012O004D00015O00201F2O010001000300202O0001000100054O0001000200024O000200016O00035O00202O00030003000300202O0003000300044O0003000200024O00020002000300062O0001000B000100020004443O002000012O004D000100024O001C01025O00202O00020002000300202O0002000200044O0002000200024O000300016O00020002000300062O00010002000100020004443O002000012O001200016O00042O0100014O0042000100024O002F3O00017O00043O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603093O004D696E6467616D657303083O004361737454696D6501144O002500018O00028O000300016O00010003000200062O0001001200013O0004443O001200010020222O013O00012O00DD000300013O00202O0003000300024O0001000300024O000200013O00202O00020002000300202O0002000200044O00020002000200062O00020002000100010004443O001100012O001200016O00042O0100014O0042000100024O002F3O00017O00063O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F44696503083O0042752O66446F776E030C3O00566F6964666F726D42752O6601183O0020232O013O00014O00035O00202O0003000300024O00010003000200062O00010016000100010004443O001600010020222O013O00032O002800035O00202O0003000300024O00010003000200202O00023O00044O00020002000200062O00010014000100020004443O001400012O004D000100013O00208E0001000100054O00035O00202O0003000300064O00010003000200044O001600012O001200016O00042O0100014O0042000100024O002F3O00017O00083O0003103O004865616C746850657263656E74616765026O003440030F3O00432O6F6C646F776E52656D61696E73026O00244003123O00496E657363617061626C65546F726D656E74030B3O004973417661696C61626C6503063O0042752O66557003103O004465617468737065616B657242752O6601223O0020222O013O00012O00F000010002000200260D2O01000F000100020004443O000F00012O004D00015O0020222O01000100032O00F0000100020002000E5D0004001F000100010004443O001F00012O004D000100013O0020D90001000100050020222O01000100062O00F000010002000200062E2O01001F00013O0004443O001F00012O004D000100023O00062E2O01001800013O0004443O001800012O004D000100013O0020D90001000100050020222O01000100062O00F00001000200020006292O010020000100010004443O002000012O004D000100033O00208E0001000100074O000300013O00202O0003000300084O00010003000200044O002000012O001200016O00042O0100014O0042000100024O002F3O00017O00043O0003103O004865616C746850657263656E74616765026O00344003063O0042752O66557003103O004465617468737065616B657242752O66010E3O0020222O013O00012O00F00001000200020026112O01000B000100020004443O000B00012O004D00015O00208E0001000100034O000300013O00202O0003000300044O00010003000200044O000C00012O001200016O00042O0100014O0042000100024O002F3O00017O00023O0003103O004865616C746850657263656E74616765026O00344001083O0020222O013O00012O00F00001000200020026112O010005000100020004443O000500012O001200016O00042O0100014O0042000100024O002F3O00017O00063O0003083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O66027O004003123O00496E657363617061626C65546F726D656E74030B3O004973417661696C61626C65026O001C4001193O0020E200013O00014O00035O00202O0003000300024O00010003000200062O0001001700013O0004443O001700012O004D000100013O00260E00010015000100030004443O001500012O004D000100023O00062E2O01001700013O0004443O001700012O004D00015O0020D90001000100040020222O01000100052O00F000010002000200062E2O01001700013O0004443O001700012O004D000100033O0026D000010016000100060004443O001600012O001200016O00042O0100014O0042000100024O002F3O00017O00023O00030D3O00446562752O6652656D61696E7303143O00536861646F77576F72645061696E446562752O6601063O0020BE00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O66027O0040010F4O004D00016O00FD00026O00F000010002000200062E2O01000D00013O0004443O000D00010020222O013O00012O004D000300013O0020D90003000300022O00F5000100030002000E5D0003000C000100010004443O000C00012O001200016O00042O0100014O0042000100024O002F3O00017O00053O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603093O0054696D65546F446965026O00324003083O00446562752O66557001173O0020E200013O00014O00035O00202O0003000300024O00010003000200062O0001001500013O0004443O001500010020222O013O00032O00F0000100020002000EB400040013000100010004443O001300010020222O013O00052O004D00035O0020D90003000300022O00F50001000300020006292O010015000100010004443O001500012O004D000100014O00AD000100013O0004443O001500012O001200016O00042O0100014O0042000100024O002F3O00017O00093O00028O00030B3O00536861646F774372617368030F3O00432O6F6C646F776E52656D61696E73030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O6603113O00446562752O665265667265736861626C6503093O0054696D65546F446965026O00324003083O00446562752O665570012A3O0012272O0100013O002O262O010001000100010004443O000100012O004D00025O00202A01020002000200202O0002000200034O00020002000200202O00033O00044O00055O00202O0005000500054O00030005000200062O00030004000100020004443O001000012O004D000200013O00062E0102002600013O0004443O0026000100202201023O00062O004D00045O0020D90004000400052O00F500020004000200062E0102002500013O0004443O0025000100202201023O00072O00F0000200020002000EB400080023000100020004443O0023000100202201023O00092O004D00045O0020D90004000400052O00F500020004000200062901020025000100010004443O002500012O004D000200024O00AD000200023O0004443O002500012O001200026O0004010200014O0042000200024O0046000200024O0042000200023O0004443O000100012O002F3O00019O002O0001064O00A800018O00028O00038O0001000300024O000100028O00017O00273O00028O00027O0040030D3O0056616D7069726963546F756368030A3O0049734361737461626C65030B3O00536861646F774372617368030B3O004973417661696C61626C65030C3O00432O6F6C646F776E446F776E03083O00496E466C69676874030E3O0049735370652O6C496E52616E6765031B3O0040B3FD00BD44BBF32FA059A7F318F446A0F513BB5BB0F104F407E603053O00D436D29070030E3O00536861646F77576F72645061696E03063O004D6973657279031D3O00988E2F878491119484942ABC9B87278DCB963C86888923818A926ED2DD03043O00E3EBE64E03043O0047554944030D3O00417263616E65546F2O72656E74031A3O005AA12B0EF2D5760B54A13A0AF2C4090F49B62B00F1D2480B1BE503083O007F3BD3486F9CB029026O00F03F03093O004973496E506172747903083O004973496E5261696403073O00A4EC48464795EE03053O002EE783262003093O004973496E52616E6765026O00444003183O00A5B95B4A18269757A4B049465721BA51B5BE574C1625E80C03083O0034D6D13A2E7751C803123O0060C2332695F070C2322E9EF066D9243883A203063O00D025AC564BEC03063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203183O00BAB5EE8FA3BE82EC99ADBAB5AF9BBEACBEE086AEA8A9AFD303053O00CCC9DD8FEB03093O005691BE2O6297ED4E6503043O002117E59E03183O0043B2C0BF5FADFEB842BBD2B310AAD3BE53B5CCB951AE81E303043O00DB30DAA100D73O001227012O00014O0046000100013O002O26012O004E000100020004443O004E00012O004D00025O0020D90002000200030020220102000200042O00F000020002000200062E0102003000013O0004443O003000012O004D00025O0020D90002000200050020220102000200062O00F000020002000200062E0102001E00013O0004443O001E00012O004D00025O0020D90002000200050020220102000200072O00F000020002000200062E0102001C00013O0004443O001C00012O004D00025O0020D90002000200050020220102000200082O00F000020002000200062E0102001E00013O0004443O001E000100062E2O01003000013O0004443O003000012O004D000200014O00D300035O00202O0003000300034O000400023O00202O0004000400094O00065O00202O0006000600034O0004000600024O000400046O000500016O00020005000200062O0002003000013O0004443O003000012O004D000200033O0012270103000A3O0012270104000B4O00B6000200044O005800026O004D00025O0020D900020002000C0020220102000200042O00F000020002000200062E010200D600013O0004443O00D600012O004D00025O0020D900020002000D0020220102000200062O00F0000200020002000629010200D6000100010004443O00D600012O004D000200014O001D00035O00202O00030003000C4O000400023O00202O0004000400094O00065O00202O00060006000C4O0004000600024O000400046O00020004000200062O000200D600013O0004443O00D600012O004D000200033O0012F90003000E3O00122O0004000F6O000200046O00025O00044O00D60001002O26012O006F000100010004443O006F00012O004D000200023O0020220102000200102O00F00002000200022O007A000200044O00CE00025O00202O00020002001100202O0002000200044O00020002000200062O0002006E00013O0004443O006E00012O004D000200053O00062E0102006E00013O0004443O006E00012O004D000200014O001D00035O00202O0003000300114O000400023O00202O0004000400094O00065O00202O0006000600114O0004000600024O000400046O00020004000200062O0002006E00013O0004443O006E00012O004D000200033O001227010300123O001227010400134O00B6000200044O005800025O001227012O00143O002O26012O0002000100140004443O000200012O004D000200063O0020220102000200152O00F00002000200020006F10001007A000100020004443O007A00012O004D000200063O0020220102000200162O00F00002000200022O00AD000100024O004D00025O0020D90002000200050020220102000200042O00F000020002000200062E010200D400013O0004443O00D400010006292O0100D4000100010004443O00D400012O004D000200074O0070000300033O00122O000400173O00122O000500186O00030005000200062O0002009A000100030004443O009A00012O004D000200014O002900035O00202O0003000300054O000400023O00202O00040004001900122O0006001A6O0004000600024O000400046O00020004000200062O000200D400013O0004443O00D400012O004D000200033O0012F90003001B3O00122O0004001C6O000200046O00025O00044O00D400012O004D000200074O0070000300033O00122O0004001D3O00122O0005001E6O00030005000200062O000200BD000100030004443O00BD00012O004D000200083O00202201020002001F2O00F000020002000200062E010200D400013O0004443O00D400012O004D000200063O0020220102000200202O004D000400084O00F500020004000200062E010200D400013O0004443O00D400012O004D000200014O0029000300093O00202O0003000300214O000400023O00202O00040004001900122O0006001A6O0004000600024O000400046O00020004000200062O000200D400013O0004443O00D400012O004D000200033O0012F9000300223O00122O000400236O000200046O00025O00044O00D400012O004D000200074O0070000300033O00122O000400243O00122O000500256O00030005000200062O000200D4000100030004443O00D400012O004D000200014O0029000300093O00202O0003000300214O000400023O00202O00040004001900122O0006001A6O0004000600024O000400046O00020004000200062O000200D400013O0004443O00D400012O004D000200033O001227010300263O001227010400274O00B6000200044O005800025O001227012O00023O0004443O000200012O002F3O00017O00113O00028O00030B3O00536861646F77437261736803083O00496E466C6967687403113O0057686973706572696E67536861646F7773030B3O004973417661696C61626C65026O00F03F030C3O00566F69644572757074696F6E030F3O00432O6F6C646F776E52656D61696E732O033O00474344026O000840030D3O004461726B417363656E73696F6E030A3O00432O6F6C646F776E5570030B3O00566F6964546F2O72656E74030B3O00507379636869634C696E6B026O00104003083O0042752O66446F776E030C3O00566F6964666F726D42752O6600563O001227012O00013O002O26012O001A000100010004443O001A00012O004D000100014O004D000200024O000401036O00F50001000300020006292O010013000100010004443O001300012O004D000100033O0020D90001000100020020222O01000100032O00F000010002000200062E2O01001300013O0004443O001300012O004D000100033O0020D90001000100040020222O01000100052O00F00001000200022O007A00016O00282O0100016O000200026O000300016O0001000300024O000100043O00124O00063O002O26012O0001000100060004443O000100012O004D000100033O00203F00010001000700202O0001000100084O0001000200024O000200063O00202O0002000200094O00020002000200202O00020002000A00062O0001002C000100020004443O002C00012O004D000100033O0020D90001000100070020222O01000100052O00F00001000200020006292O010052000100010004443O005200012O004D000100033O0020D900010001000B0020222O010001000C2O00F000010002000200062E2O01003800013O0004443O003800012O004D000100033O0020D900010001000B0020222O01000100052O00F00001000200020006292O010052000100010004443O005200012O004D000100033O0020D900010001000D0020222O01000100052O00F000010002000200062E2O01005200013O0004443O005200012O004D000100033O0020D900010001000E0020222O01000100052O00F000010002000200062E2O01005200013O0004443O005200012O004D000100033O0020D900010001000D0020222O01000100082O00F000010002000200260E000100500001000F0004443O005000012O004D000100063O00208E0001000100104O000300033O00202O0003000300114O00010003000200044O005200012O001200016O00042O0100014O007A000100053O0004443O005500010004443O000100012O002F3O00017O000E3O00028O00026O00F03F03093O0054696D65546F446965026O003240027O004003133O0056616D7069726963546F756368446562752O66030F3O0041757261416374697665436F756E74030B3O00536861646F77437261736803083O00496E466C6967687403113O0057686973706572696E67536861646F7773030B3O004973417661696C61626C65026O002040026O001040026O00084000663O001227012O00014O0046000100013O002O26012O0012000100020004443O001200012O004D00026O0089000300016O000400016O0002000400024O000100023O00062O0001001100013O0004443O001100010020220102000100032O00F0000200020002000EB400040011000100020004443O001100012O0004010200014O007A000200023O001227012O00053O002O26012O0044000100050004443O004400012O004D000200043O00207900020002000600202O0002000200074O0002000200024O000300056O000400043O00202O00040004000800202O0004000400094O00040002000200062O0004002300013O0004443O002300012O004D000400043O0020D900040004000A00202201040004000B2O00F00004000200022O00F00003000200020010C50003000C00032O00090102000200032O004D000300063O00069100030005000100020004443O002D00012O004D000200024O00AD000200023O0004443O002E00012O001200026O0004010200014O007A000200034O004D000200073O00062E0102004300013O0004443O004300012O004D000200043O0020D900020002000A00202201020002000B2O00F000020002000200062E0102004300013O0004443O004300012O004D000200064O00AE000300043O00202O00030003000600202O0003000300074O0003000200024O00020002000300262O000200410001000D0004443O004100012O001200026O0004010200014O007A000200073O001227012O000E3O002O26012O004E000100010004443O004E00012O004D000200084O003A000300096O0004000A6O0002000400024O000200066O00028O000200023O00124O00023O000E31000E000200013O0004443O000200012O004D000200043O00206C00020002000600202O0002000200074O0002000200024O000300056O000400076O000400046O00030002000200102O0003000C00034O0002000200034O000300063O00062O00030005000100020004443O006100012O004D000200024O00AD000200023O0004443O006200012O001200026O0004010200014O007A0002000B3O0004443O006500010004443O000200012O002F3O00017O000B3O0003063O0042752O665570030C3O00566F6964666F726D42752O6603113O00506F776572496E667573696F6E42752O6603113O004461726B417363656E73696F6E42752O66026O003440028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B65742O033O00434473026O00444003103O0048616E646C65546F705472696E6B6574003B4O008F7O00206O00014O000200013O00202O0002000200026O0002000200064O0018000100010004443O001800012O004D7O002023014O00014O000200013O00202O0002000200036O0002000200064O0018000100010004443O001800012O004D7O002023014O00014O000200013O00202O0002000200046O0002000200064O0018000100010004443O001800012O004D3O00023O00260D012O003A000100050004443O003A0001001227012O00063O002O26012O0029000100070004443O002900012O004D000100043O0020142O01000100084O000200053O00122O000300093O00122O0004000A6O000500056O0001000500024O000100036O000100033O00062O0001003A00013O0004443O003A00012O004D000100034O0042000100023O0004443O003A0001002O26012O0019000100060004443O001900012O004D000100043O0020142O010001000B4O000200053O00122O000300093O00122O0004000A6O000500056O0001000500024O000100036O000100033O00062O0001003800013O0004443O003800012O004D000100034O0042000100023O001227012O00073O0004443O001900012O002F3O00017O003B3O00028O00027O004003093O004D696E64426C617374030A3O0049734361737461626C65030E3O0049735370652O6C496E52616E676503143O00E978724DE44DECE5626809D45FE5EA746E09891F03073O008084111C29BB2F03093O004D696E645370696B6503143O000C3B083E6212220F3158413D163F53042046680F03053O003D6152665A03083O004D696E64466C617903133O00A127A54FF8511208B56EA45BC2592O1BEC7CFF03083O0069CC4ECB2BA7377E026O00F03F03083O00566F6964426F6C7403093O004973496E52616E6765026O00444003133O00B3A52A1A2C06C85DB1EA2C0E160AC243E5FB7503083O0031C5CA437E7364A7030F3O004465766F7572696E67506C6167756503073O0049735265616479031A3O00335EC926954457395CE0398C5759225E9F2690535032499F78D803073O003E573BBF49E036030B3O00536861646F774372617368030A3O00446562752O66446F776E03133O0056616D7069726963546F756368446562752O6603073O00C40DF4CFEE10F703043O00A987629A03153O00D87F2550F224F7C8652547F573C7DB722A51EF739A03073O00A8AB1744349D5303123O00D17FF0A03C6DB2FA75F0BF650E92E662FABF03073O00E7941195CD454D03063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203153O0093AFC6FF58E8BFA4D5FA44F7C0A8D7FE59FA92E79503063O009FE0C7A79B3703093O00D6E77CF1E2E12FDDE503043O00B297935C03153O009FF54D361D5B458FEF4D211A0C759CF84237000C2803073O001AEC9D2C52722C03133O002O27DB5F282BDB5F2F3C95543A2BDB5E386E8103043O003B4A4EB5030D3O004461726B417363656E73696F6E03173O0021D048518C24C2595FBD36D85554F32AC15F54B637910C03053O00D345B12O3A030C3O00566F69644572757074696F6E030B3O004973417661696C61626C6503173O00A1EA70F1D6CEA5F069E1E0C4B9A576E5ECC5B2F739A4BB03063O00ABD785199589030F3O00536861646F77576F7264446561746803123O00496E657363617061626C65546F726D656E7403083O00507265764743445003113O0054696D6553696E63654C61737443617374026O003440031A3O00F2C033FEE027C355EEDA36C5EB35FD56E9883D2OEA3EF950A19003083O002281A8529A8F509C03143O0088BB3D0F774C8584A1274B475E8C8BB7214B191E03073O00E9E5D2536B282E0073012O001227012O00013O000E310002004C00013O0004443O004C00012O004D00015O0020D90001000100030020222O01000100042O00F000010002000200062E2O01001B00013O0004443O001B00012O004D000100014O00D300025O00202O0002000200034O000300023O00202O0003000300054O00055O00202O0005000500034O0003000500024O000300036O000400016O00010004000200062O0001001B00013O0004443O001B00012O004D000100033O001227010200063O001227010300074O00B6000100034O005800016O004D00015O0020D90001000100080020222O01000100042O00F000010002000200062E2O01003300013O0004443O003300012O004D000100014O00D300025O00202O0002000200084O000300023O00202O0003000300054O00055O00202O0005000500084O0003000500024O000300036O000400016O00010004000200062O0001003300013O0004443O003300012O004D000100033O001227010200093O0012270103000A4O00B6000100034O005800016O004D00015O0020D900010001000B0020222O01000100042O00F000010002000200062E2O0100722O013O0004443O00722O012O004D000100014O00D300025O00202O00020002000B4O000300023O00202O0003000300054O00055O00202O00050005000B4O0003000500024O000300036O000400016O00010004000200062O000100722O013O0004443O00722O012O004D000100033O0012F90002000C3O00122O0003000D6O000100036O00015O00044O00722O01002O26012O00840001000E0004443O008400012O004D000100054O00490001000100022O007A000100044O004D000100043O00062E2O01005600013O0004443O005600012O004D000100044O0042000100024O004D00015O0020D900010001000F0020222O01000100042O00F000010002000200062E2O01006C00013O0004443O006C00012O004D000100014O002900025O00202O00020002000F4O000300023O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O0001006C00013O0004443O006C00012O004D000100033O001227010200123O001227010300134O00B6000100034O005800016O004D00015O0020D90001000100140020222O01000100152O00F000010002000200062E2O01008300013O0004443O008300012O004D000100014O001D00025O00202O0002000200144O000300023O00202O0003000300054O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O0001008300013O0004443O008300012O004D000100033O001227010200163O001227010300174O00B6000100034O005800015O001227012O00023O002O26012O0001000100010004443O000100012O004D00015O0020D90001000100180020222O01000100042O00F000010002000200062E2O0100E500013O0004443O00E500012O004D000100023O0020E20001000100194O00035O00202O00030003001A4O00010003000200062O000100E500013O0004443O00E500012O004D000100064O0070000200033O00122O0003001B3O00122O0004001C6O00020004000200062O000100AB000100020004443O00AB00012O004D000100014O002900025O00202O0002000200184O000300023O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O000100E500013O0004443O00E500012O004D000100033O0012F90002001D3O00122O0003001E6O000100036O00015O00044O00E500012O004D000100064O0070000200033O00122O0003001F3O00122O000400206O00020004000200062O000100CE000100020004443O00CE00012O004D000100073O0020222O01000100212O00F000010002000200062E2O0100E500013O0004443O00E500012O004D000100083O0020222O01000100222O004D000300074O00F500010003000200062E2O0100E500013O0004443O00E500012O004D000100014O0029000200093O00202O0002000200234O000300023O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O000100E500013O0004443O00E500012O004D000100033O0012F9000200243O00122O000300256O000100036O00015O00044O00E500012O004D000100064O0070000200033O00122O000300263O00122O000400276O00020004000200062O000100E5000100020004443O00E500012O004D000100014O0029000200093O00202O0002000200234O000300023O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O000100E500013O0004443O00E500012O004D000100033O001227010200283O001227010300294O00B6000100034O005800016O004D0001000A3O0020222O01000100042O00F000010002000200062E2O0100F700013O0004443O00F700012O004D0001000B3O00062E2O0100F700013O0004443O00F700012O004D000100014O004D0002000A4O00F000010002000200062E2O0100F700013O0004443O00F700012O004D000100033O0012270102002A3O0012270103002B4O00B6000100034O005800016O004D00015O0020D900010001002C0020222O01000100042O00F000010002000200062E2O0100082O013O0004443O00082O012O004D000100014O004D00025O0020D900020002002C2O00F000010002000200062E2O0100082O013O0004443O00082O012O004D000100033O0012270102002D3O0012270103002E4O00B6000100034O005800016O004D00015O0020D900010001002F0020222O01000100302O00F000010002000200062E2O0100702O013O0004443O00702O010012272O0100013O000E31000E00292O0100010004443O00292O012O004D00025O0020D900020002002F0020220102000200042O00F000020002000200062E010200702O013O0004443O00702O012O004D000200014O001100035O00202O00030003002F4O000400023O00202O00040004001000122O000600116O0004000600024O000400046O000500016O00020005000200062O000200702O013O0004443O00702O012O004D000200033O0012F9000300313O00122O000400326O000200046O00025O00044O00702O01002O262O01000F2O0100010004443O000F2O012O004D00025O0020D90002000200330020220102000200042O00F000020002000200062E010200562O013O0004443O00562O012O004D00025O0020D90002000200340020220102000200302O00F000020002000200062E010200562O013O0004443O00562O012O004D000200083O0020C600020002003500122O0004000E6O00055O00202O0005000500034O00020005000200062O000200562O013O0004443O00562O012O004D00025O0020D90002000200330020220102000200362O00F0000200020002000EDF003700562O0100020004443O00562O012O004D000200014O001D00035O00202O0003000300334O000400023O00202O0004000400054O00065O00202O0006000600334O0004000600024O000400046O00020004000200062O000200562O013O0004443O00562O012O004D000200033O001227010300383O001227010400394O00B6000200044O005800026O004D00025O0020D90002000200030020220102000200042O00F000020002000200062E0102006E2O013O0004443O006E2O012O004D000200014O00D300035O00202O0003000300034O000400023O00202O0004000400054O00065O00202O0006000600034O0004000600024O000400046O000500016O00020005000200062O0002006E2O013O0004443O006E2O012O004D000200033O0012270103003A3O0012270104003B4O00B6000200044O005800025O0012272O01000E3O0004443O000F2O01001227012O000E3O0004443O000100012O002F3O00017O00563O00028O00030D3O0056616D7069726963546F756368030A3O0049734361737461626C6503063O0042752O66557003153O00556E6675726C696E674461726B6E652O7342752O66030C3O004361737454617267657449662O033O00CC4B3C03053O0065A12252B6030E3O0049735370652O6C496E52616E676503173O00FE0C54EED2F08B2DD71956EBD8EAC228E10155FBC9A2D003083O004E886D399EBB82E2030F3O00536861646F77576F7264446561746803073O004973526561647903093O00436173744379636C6503183O00536861646F77576F726444656174684D6F7573656F766572031A3O002D37F8F53128C6E6312DFDCE2O3AF8E5367FFFF83233FCE37E6B03043O00915E5F9903113O004D696E645370696B65496E73616E697479031C3O00F0C41AD171A4EDC41FD071BEF3DE15DB47A3E48D12DC42BBF8DF548303063O00D79DAD74B52E03083O004D696E64466C617903143O004D696E64466C6179496E73616E69747942752O6603093O004D696E645370696B6503123O0038BD85F6E533B88AEB9A33BD87FEDF27F4D303053O00BA55D4EB92026O00F03F03093O004D696E6467616D657303093O004973496E52616E6765026O00444003133O00CF8818FA3EEF55C79256F830E254C79356AF6903073O0038A2E1769E598E03123O00496E657363617061626C65546F726D656E74030B3O004973417661696C61626C652O033O00510CCE03063O00B83C65A0CF42031B3O00228A7DB83E9543AB3E90788335877DA839C27AB53D8E79AE71D32E03043O00DC51E21C030A3O00446976696E655374617203103O004865616C746850657263656E74616765030C3O00446976696E6553746172485003103O00446976696E6553746172506C61796572026O00384003103O0017DC94F2E4C22CC696FAF8871BD083F703063O00A773B5E29B8A03043O0048616C6F030D3O00546172676574497356616C6964026O003E40031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503093O00EA23EB533B79C3E32E03073O00A68242873C1B11027O0040030F3O004465766F7572696E67506C61677565030C3O00566F6964666F726D42752O66031A3O00404FD87A255643C0720F5446CF7225410AC87C3C484FDC35611203053O0050242AAE1503143O004319397E710327734515777C471C3B7F5C50662203043O001A2E705703133O00B42AA57080B949B5A063AD7D2OB340A6F971FB03083O00D4D943CB142ODF25030B3O00536861646F77437261736803073O009982A6D4B39FA503043O00B2DAEDC803163O00A5BDE7D4B9A2D9D3A4B4F5D8F6B3EFDCBAB0F490E4E703043O00B0D6D58603123O00D1A3B3D9B1166CFAA9B3C6E8754CE6BEB9C603073O003994CDD6B4C83603063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203163O0001F534307905C236267701F575327F1EF130263640AF03053O0016729D555403093O00E5DF53E748E4BBCBD903073O00C8A4AB73A43D9603163O00ADFC02418CA9CB005782ADFC2O438AB2F80657C3ECA603053O00E3DE946325026O000840031B3O00205A53F2F6246D45F9EB376D56F3F8275A122OF03F5E57E4B9610603053O0099532O329603083O0049734D6F76696E6703243O004E7E72187CBC724A7961184CAF485C627B5C7EA45B587B761267EB4B547A7F1961EB1F0B03073O002D3D16137C13CB030E3O00536861646F77576F72645061696E2O033O00CC1B2O03073O00D9A1726D956210031A3O0001283978B3632D2O376EB84B02213172FC721B2C3479AE34407803063O00147240581CDC0014022O001227012O00013O002O26012O0080000100010004443O008000012O004D00015O0020D90001000100020020222O01000100032O00F000010002000200062E2O01002B00013O0004443O002B00012O004D000100013O0020E20001000100044O00035O00202O0003000300054O00010003000200062O0001002B00013O0004443O002B00012O004D000100023O0020AC0001000100064O00025O00202O0002000200024O000300036O000400043O00122O000500073O00122O000600086O0004000600024O000500056O000600064O004D000700063O0020730007000700094O00095O00202O0009000900024O0007000900024O000700076O0008000A6O000B00016O0001000B000200062O0001002B00013O0004443O002B00012O004D000100043O0012270102000A3O0012270103000B4O00B6000100034O005800016O004D00015O0020D900010001000C0020222O010001000D2O00F000010002000200062E2O01004800013O0004443O004800012O004D000100023O00204000010001000E4O00025O00202O00020002000C4O000300036O000400076O000500063O00202O0005000500094O00075O00202O00070007000C4O0005000700024O000500056O000600076O000800083O00202O00080008000F4O00010008000200062O0001004800013O0004443O004800012O004D000100043O001227010200103O001227010300114O00B6000100034O005800016O004D00015O0020D90001000100120020222O010001000D2O00F000010002000200062E2O01006000013O0004443O006000012O004D000100094O00D300025O00202O0002000200124O000300063O00202O0003000300094O00055O00202O0005000500124O0003000500024O000300036O000400016O00010004000200062O0001006000013O0004443O006000012O004D000100043O001227010200133O001227010300144O00B6000100034O005800016O004D00015O0020D90001000100150020222O01000100032O00F000010002000200062E2O01007F00013O0004443O007F00012O004D000100013O0020E20001000100044O00035O00202O0003000300164O00010003000200062O0001007F00013O0004443O007F00012O004D000100094O00D300025O00202O0002000200174O000300063O00202O0003000300094O00055O00202O0005000500174O0003000500024O000300036O000400016O00010004000200062O0001007F00013O0004443O007F00012O004D000100043O001227010200183O001227010300194O00B6000100034O005800015O001227012O001A3O002O26012O000C2O01001A0004443O000C2O012O004D00015O0020D900010001001B0020222O010001000D2O00F000010002000200062E2O01009900013O0004443O009900012O004D000100094O001100025O00202O00020002001B4O000300063O00202O00030003001C00122O0005001D6O0003000500024O000300036O000400016O00010004000200062O0001009900013O0004443O009900012O004D000100043O0012270102001E3O0012270103001F4O00B6000100034O005800016O004D00015O0020D900010001000C0020222O010001000D2O00F000010002000200062E2O0100C400013O0004443O00C400012O004D00015O0020D90001000100200020222O01000100212O00F000010002000200062E2O0100C400013O0004443O00C400012O004D0001000A3O00062E2O0100C400013O0004443O00C400012O004D000100023O0020160001000100064O00025O00202O00020002000C4O000300036O000400043O00122O000500223O00122O000600236O0004000600024O0005000B6O000600066O000700063O00202O0007000700094O00095O00202O00090009000C4O0007000900024O000700076O000800096O000A00083O00202O000A000A000F4O0001000A000200062O000100C400013O0004443O00C400012O004D000100043O001227010200243O001227010300254O00B6000100034O005800016O004D00015O0020D90001000100260020222O010001000D2O00F000010002000200062E2O0100E300013O0004443O00E300012O004D0001000C3O0020222O01000100272O00F000010002000200122E000200283O0006B7000100E3000100020004443O00E300012O004D0001000D3O00062E2O0100E300013O0004443O00E300012O004D000100094O0029000200083O00202O0002000200294O0003000C3O00202O00030003001C00122O0005002A6O0003000500024O000300036O00010003000200062O000100E300013O0004443O00E300012O004D000100043O0012270102002B3O0012270103002C4O00B6000100034O005800016O004D00015O0020D900010001002D0020222O010001000D2O00F000010002000200062E2O01000B2O013O0004443O000B2O012O004D000100023O0020D900010001002E2O004900010001000200062E2O01000B2O013O0004443O000B2O012O004D000100063O0020222O010001001C0012270103002F4O00F500010003000200062E2O01000B2O013O0004443O000B2O012O004D0001000E3O00062E2O01000B2O013O0004443O000B2O012O004D000100023O00202F2O01000100304O0002000F6O000300106O00010003000200062O0001000B2O013O0004443O000B2O012O004D000100094O003900025O00202O00020002002D4O000300036O000400016O00010004000200062O0001000B2O013O0004443O000B2O012O004D000100043O001227010200313O001227010300324O00B6000100034O005800015O001227012O00333O000E31003300B22O013O0004443O00B22O012O004D00015O0020D90001000100340020222O010001000D2O00F000010002000200062E2O01002C2O013O0004443O002C2O012O004D000100013O0020E20001000100044O00035O00202O0003000300354O00010003000200062O0001002C2O013O0004443O002C2O012O004D000100094O001D00025O00202O0002000200344O000300063O00202O0003000300094O00055O00202O0005000500344O0003000500024O000300036O00010003000200062O0001002C2O013O0004443O002C2O012O004D000100043O001227010200363O001227010300374O00B6000100034O005800016O004D00015O0020D90001000100170020222O01000100032O00F000010002000200062E2O0100442O013O0004443O00442O012O004D000100094O00D300025O00202O0002000200174O000300063O00202O0003000300094O00055O00202O0005000500174O0003000500024O000300036O000400016O00010004000200062O000100442O013O0004443O00442O012O004D000100043O001227010200383O001227010300394O00B6000100034O005800016O004D000100113O0020222O01000100032O00F000010002000200062E2O0100592O013O0004443O00592O012O004D000100094O00E6000200116O000300063O00202O0003000300094O000500116O0003000500024O000300036O000400016O00010004000200062O000100592O013O0004443O00592O012O004D000100043O0012270102003A3O0012270103003B4O00B6000100034O005800016O004D00015O0020D900010001003C0020222O01000100032O00F000010002000200062E2O0100B12O013O0004443O00B12O012O004D000100124O0070000200043O00122O0003003D3O00122O0004003E6O00020004000200062O000100772O0100020004443O00772O012O004D000100094O002900025O00202O00020002003C4O000300063O00202O00030003001C00122O0005001D6O0003000500024O000300036O00010003000200062O000100B12O013O0004443O00B12O012O004D000100043O0012F90002003F3O00122O000300406O000100036O00015O00044O00B12O012O004D000100124O0070000200043O00122O000300413O00122O000400426O00020004000200062O0001009A2O0100020004443O009A2O012O004D000100133O0020222O01000100432O00F000010002000200062E2O0100B12O013O0004443O00B12O012O004D000100013O0020222O01000100442O004D000300134O00F500010003000200062E2O0100B12O013O0004443O00B12O012O004D000100094O0029000200083O00202O0002000200454O000300063O00202O00030003001C00122O0005001D6O0003000500024O000300036O00010003000200062O000100B12O013O0004443O00B12O012O004D000100043O0012F9000200463O00122O000300476O000100036O00015O00044O00B12O012O004D000100124O0070000200043O00122O000300483O00122O000400496O00020004000200062O000100B12O0100020004443O00B12O012O004D000100094O0029000200083O00202O0002000200454O000300063O00202O00030003001C00122O0005001D6O0003000500024O000300036O00010003000200062O000100B12O013O0004443O00B12O012O004D000100043O0012270102004A3O0012270103004B4O00B6000100034O005800015O001227012O004C3O002O26012O00010001004C0004443O000100012O004D00015O0020D900010001000C0020222O010001000D2O00F000010002000200062E2O0100D12O013O0004443O00D12O012O004D000100023O00204000010001000E4O00025O00202O00020002000C4O000300036O000400146O000500063O00202O0005000500094O00075O00202O00070007000C4O0005000700024O000500056O000600076O000800083O00202O00080008000F4O00010008000200062O000100D12O013O0004443O00D12O012O004D000100043O0012270102004D3O0012270103004E4O00B6000100034O005800016O004D00015O0020D900010001000C0020222O010001000D2O00F000010002000200062E2O0100ED2O013O0004443O00ED2O012O004D000100013O0020222O010001004F2O00F000010002000200062E2O0100ED2O013O0004443O00ED2O012O004D000100094O001D00025O00202O00020002000C4O000300063O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O00010003000200062O000100ED2O013O0004443O00ED2O012O004D000100043O001227010200503O001227010300514O00B6000100034O005800016O004D00015O0020D90001000100520020222O010001000D2O00F000010002000200062E2O01001302013O0004443O001302012O004D000100013O0020222O010001004F2O00F000010002000200062E2O01001302013O0004443O001302012O004D000100023O0020AC0001000100064O00025O00202O0002000200524O000300036O000400043O00122O000500533O00122O000600546O0004000600024O000500156O000600064O004D000700063O0020C90007000700094O00095O00202O0009000900524O0007000900024O000700076O00010007000200062O0001001302013O0004443O001302012O004D000100043O0012F9000200553O00122O000300566O000100036O00015O00044O001302010004443O000100012O002F3O00017O00263O00028O00026O00F03F03093O00426C2O6F6446757279030A3O0049734361737461626C6503063O0042752O66557003113O00506F776572496E667573696F6E42752O66026O002E4003103O00330DDDBBFCEFBB2413CBF4FBD4AE715903073O00DD5161B2D498B0030D3O00416E6365737472616C43612O6C03153O00CCE91EFE09D9F51CF725CEE611F75ACEE30EBB4B9D03053O007AAD877D9B027O0040026O00084003093O0046697265626C2O6F64026O002040030F3O0082C812BC2O3DC78BC540BA3B2288D003073O00A8E4A160D95F51030A3O004265727365726B696E67026O00284003103O00D9D43C4F2A45D0D8205B6F54DFC26E0A03063O0037BBB14E3C4F030C3O00566F69644572757074696F6E030C3O00432O6F6C646F776E446F776E030F3O00432O6F6C646F776E52656D61696E73026O001040030A3O004D696E6462656E646572030B3O004973417661696C61626C6503123O00496E657363617061626C65546F726D656E7403093O004D696E64426C61737403073O0043686172676573030A3O00436F6D62617454696D6503143O003BC156EF79CA9238DE4BE249C1C02ECA4CAB179B03073O00E04DAE3F8B26AF030D3O004461726B417363656E73696F6E03093O00497343617374696E6703153O0080404A25BB404B2D814F4B278B4F182D8052187FD203043O004EE4213800F73O001227012O00013O002O26012O003A000100020004443O003A00012O004D00015O0020D90001000100030020222O01000100042O00F000010002000200062E2O01001E00013O0004443O001E00012O004D000100013O0020232O01000100054O00035O00202O0003000300064O00010003000200062O00010013000100010004443O001300012O004D000100023O00260E0001001E000100070004443O001E00012O004D000100034O004D00025O0020D90002000200032O00F000010002000200062E2O01001E00013O0004443O001E00012O004D000100043O001227010200083O001227010300094O00B6000100034O005800016O004D00015O0020D900010001000A0020222O01000100042O00F000010002000200062E2O01003900013O0004443O003900012O004D000100013O0020232O01000100054O00035O00202O0003000300064O00010003000200062O0001002E000100010004443O002E00012O004D000100023O00260E00010039000100070004443O003900012O004D000100034O004D00025O0020D900020002000A2O00F000010002000200062E2O01003900013O0004443O003900012O004D000100043O0012270102000B3O0012270103000C4O00B6000100034O005800015O001227012O000D3O002O26012O004D0001000E0004443O004D00012O004D000100053O00062E2O0100F600013O0004443O00F600010012272O0100013O002O262O010040000100010004443O004000012O004D000200074O00490002000100022O007A000200064O004D000200063O00062E010200F600013O0004443O00F600012O004D000200064O0042000200023O0004443O00F600010004443O004000010004443O00F60001000E310001008600013O0004443O008600012O004D00015O0020D900010001000F0020222O01000100042O00F000010002000200062E2O01006A00013O0004443O006A00012O004D000100013O0020232O01000100054O00035O00202O0003000300064O00010003000200062O0001005F000100010004443O005F00012O004D000100023O00260E0001006A000100100004443O006A00012O004D000100034O004D00025O0020D900020002000F2O00F000010002000200062E2O01006A00013O0004443O006A00012O004D000100043O001227010200113O001227010300124O00B6000100034O005800016O004D00015O0020D90001000100130020222O01000100042O00F000010002000200062E2O01008500013O0004443O008500012O004D000100013O0020232O01000100054O00035O00202O0003000300064O00010003000200062O0001007A000100010004443O007A00012O004D000100023O00260E00010085000100140004443O008500012O004D000100034O004D00025O0020D90002000200132O00F000010002000200062E2O01008500013O0004443O008500012O004D000100043O001227010200153O001227010300164O00B6000100034O005800015O001227012O00023O000E31000D000100013O0004443O000100012O004D00015O0020D90001000100170020222O01000100042O00F000010002000200062E2O0100C000013O0004443O00C000012O004D000100083O0020222O01000100182O00F000010002000200062E2O0100C000013O0004443O00C000012O004D000100093O00062E2O01009B00013O0004443O009B00012O004D000100083O0020222O01000100192O00F0000100020002000E5D001A00AA000100010004443O00AA00012O004D00015O0020D900010001001B0020222O010001001C2O00F000010002000200062E2O0100AA00013O0004443O00AA00012O004D0001000A3O000EDF000D00C0000100010004443O00C000012O004D00015O0020D900010001001D0020222O010001001C2O00F00001000200020006292O0100C0000100010004443O00C000012O004D00015O0020D900010001001E0020222O010001001F2O00F0000100020002002607000100B5000100010004443O00B500012O004D0001000B3O0020D90001000100202O0049000100010002000EDF000700C0000100010004443O00C000012O004D000100034O004D00025O0020D90002000200172O00F000010002000200062E2O0100C000013O0004443O00C000012O004D000100043O001227010200213O001227010300224O00B6000100034O005800016O004D00015O0020D90001000100230020222O01000100042O00F000010002000200062E2O0100F400013O0004443O00F400012O004D000100013O0020232O01000100244O00035O00202O0003000300234O00010003000200062O000100F4000100010004443O00F400012O004D000100093O00062E2O0100D500013O0004443O00D500012O004D000100083O0020222O01000100192O00F0000100020002000E5D001A00E9000100010004443O00E900012O004D00015O0020D900010001001B0020222O010001001C2O00F00001000200020006292O0100E0000100010004443O00E000012O004D000100083O0020222O01000100182O00F00001000200020006292O0100E9000100010004443O00E900012O004D0001000A3O000EDF000D00F4000100010004443O00F400012O004D00015O0020D900010001001D0020222O010001001C2O00F00001000200020006292O0100F4000100010004443O00F400012O004D000100034O004D00025O0020D90002000200232O00F000010002000200062E2O0100F400013O0004443O00F400012O004D000100043O001227010200253O001227010300264O00B6000100034O005800015O001227012O000E3O0004443O000100012O002F3O00017O005D3O00028O00026O00104003093O004D696E64426C617374030A3O0049734361737461626C6503083O0042752O66446F776E03103O004D696E644465766F7572657242752O66030C3O00566F69644572757074696F6E030A3O00432O6F6C646F776E5570030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503123O00C377BC07BACC72B310918E73B30A8B8E2CE403053O00E5AE1ED263030B3O00566F6964546F2O72656E7403093O00436173744379636C6503143O00566F6964546F2O72656E744D6F7573656F76657203143O000DE28F55D2293609FF835FF97D341AE48811BF6503073O00597B8DE6318D5D026O001440027O0040030F3O004465766F7572696E67506C6167756503073O004973526561647903153O004465766F7572696E67506C61677565446562752O66030C3O00426173654475726174696F6E03163O00F774E0030558FA7FF1330046F276E3095047F278F84C03063O002A9311966C70030F3O00496E73616E69747944656669636974026O00344003063O0042752O665570030C3O00566F6964666F726D42752O6603083O00566F6964426F6C74030F3O00432O6F6C646F776E52656D61696E73030B3O0042752O6652656D61696E73030B3O00504D756C7469706C6965720200344O33F33F03183O004465766F7572696E67506C616775654D6F7573656F76657203173O000BA33B70F2FA06A82A40F7E40EA1387AA7E50EAF233FBF03063O00886FC64D1F87030B3O00536861646F77437261736803113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603073O002106A950B4F61A03083O00C96269C736DD847703093O004973496E52616E6765026O00444003143O00AA0482250D2293BA1E82320A75A1B8058D61536503073O00CCD96CE341625503123O007BCDF0E835806BCDF1E03E807DD6E7F623D203063O00A03EA395854C03063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203143O00C5A80C2BCCC19F0E3DC2C5A84D22C2DFAE4D7E9303053O00A3B6C06D4F03093O00153240E3E026350FD203053O0095544660A003143O002B0E0CE9371132EE2A071EE5780B0CE436465CBD03043O008D58666D026O000840030D3O0056616D7069726963546F756368030C3O004361737454617267657449662O033O00BE5AC403083O00A1D333AA107A5D3503163O00EDAFBF38F2BCBB2BC4BABD3DF8A6F225FAA7BC68AAFC03043O00489BCED203113O004D696E645370696B65496E73616E69747903103O0046752O6C526563686172676554696D652O033O00474344030B3O0049646F6C4F66437468756E030C3O00432O6F6C646F776E446F776E031B3O004B735A0A0C556A5D053679735A1D3248734017734B7B5D0073142803053O0053261A346E03143O004D696E64466C6179496E73616E69747942752O6603113O00551E294267112B4741572A47511967140C03043O0026387747026O003E4003093O0054696D65546F446965026O002E40030D3O004461726B417363656E73696F6E03113O00FEE656D22753FDEB5DC4655BF2E656967703063O0036938F38B645026O00F03F03123O00496E657363617061626C65546F726D656E74030B3O004578656375746554696D65026O001C4003123O004D696E64426C6173744D6F7573656F76657203113O00DB88F14DE0D48DFE5ACB968CFE40D196D503053O00BFB6E19F29030F3O00536861646F77576F7264446561746803183O00536861646F77576F726444656174684D6F7573656F76657203183O00381A29518490FD3C1D3A51B483C72A0620152O86CB25527D03073O00A24B724835EBE703103O009A334DE66C00833050A25E03853204B403063O0062EC5C248233007D022O001227012O00013O002O26012O0056000100020004443O005600012O004D00015O0020D90001000100030020222O01000100042O00F000010002000200062E2O01003100013O0004443O003100012O004D000100013O00062E2O01003100013O0004443O003100012O004D000100023O0020232O01000100054O00035O00202O0003000300064O00010003000200062O0001001F000100010004443O001F00012O004D00015O0020D90001000100070020222O01000100082O00F000010002000200062E2O01003100013O0004443O003100012O004D00015O0020D90001000100070020222O01000100092O00F000010002000200062E2O01003100013O0004443O003100012O004D000100034O00D300025O00202O0002000200034O000300043O00202O00030003000A4O00055O00202O0005000500034O0003000500024O000300036O000400016O00010004000200062O0001003100013O0004443O003100012O004D000100053O0012270102000B3O0012270103000C4O00B6000100034O005800016O004D00015O0020D900010001000D0020222O01000100042O00F000010002000200062E2O01005200013O0004443O005200012O004D000100063O0006292O010052000100010004443O005200012O004D000100073O00202A00010001000E4O00025O00202O00020002000D4O000300086O000400096O000500043O00202O00050005000A4O00075O00202O00070007000D4O0005000700024O000500056O000600076O0008000A3O00202O00080008000F4O000900016O00010009000200062O0001005200013O0004443O005200012O004D000100053O001227010200103O001227010300114O00B6000100034O005800016O004D0001000C4O00490001000100022O007A0001000B3O001227012O00123O002O26012O00292O0100130004443O00292O012O004D00015O0020D90001000100140020222O01000100152O00F000010002000200062E2O01007800013O0004443O007800012O004D0001000D4O00AA00025O00202O00020002001600202O0002000200174O00020002000200202O00020002000200202O00020002000100062O00010078000100020004443O007800012O004D000100034O001D00025O00202O0002000200144O000300043O00202O00030003000A4O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O0001007800013O0004443O007800012O004D000100053O001227010200183O001227010300194O00B6000100034O005800016O004D00015O0020D90001000100140020222O01000100152O00F000010002000200062E2O0100C600013O0004443O00C600012O004D000100023O0020222O010001001A2O00F00001000200020026D0000100AF0001001B0004443O00AF00012O004D000100023O0020E200010001001C4O00035O00202O00030003001D4O00010003000200062O000100A100013O0004443O00A100012O004D00015O00200C2O010001001E00202O00010001001F4O0001000200024O000200023O00202O0002000200204O00045O00202O00040004001D4O00020004000200062O000200A1000100010004443O00A100012O004D00015O00206400010001001E00202O00010001001F4O0001000200024O000200023O00202O0002000200204O00045O00202O00040004001D4O00020004000200202O00020002001300062O0001000F000100020004443O00AF00012O004D000100023O0020E200010001001C4O00035O00202O0003000300064O00010003000200062O000100C600013O0004443O00C600012O004D000100023O00209E0001000100214O00035O00202O0003000300144O00010003000200262O000100C6000100220004443O00C600012O004D000100073O00204000010001000E4O00025O00202O0002000200144O000300086O0004000E6O000500043O00202O00050005000A4O00075O00202O0007000700144O0005000700024O000500056O000600076O0008000A3O00202O0008000800234O00010008000200062O000100C600013O0004443O00C600012O004D000100053O001227010200243O001227010300254O00B6000100034O005800016O004D00015O0020D90001000100260020222O01000100042O00F000010002000200062E2O0100282O013O0004443O00282O012O004D000100063O0006292O0100282O0100010004443O00282O012O004D000100043O0020E20001000100274O00035O00202O0003000300284O00010003000200062O000100282O013O0004443O00282O012O004D0001000F4O0070000200053O00122O000300293O00122O0004002A6O00020004000200062O000100EE000100020004443O00EE00012O004D000100034O002900025O00202O0002000200264O000300043O00202O00030003002B00122O0005002C6O0003000500024O000300036O00010003000200062O000100282O013O0004443O00282O012O004D000100053O0012F90002002D3O00122O0003002E6O000100036O00015O00044O00282O012O004D0001000F4O0070000200053O00122O0003002F3O00122O000400306O00020004000200062O000100112O0100020004443O00112O012O004D000100103O0020222O01000100312O00F000010002000200062E2O0100282O013O0004443O00282O012O004D000100023O0020222O01000100322O004D000300104O00F500010003000200062E2O0100282O013O0004443O00282O012O004D000100034O00290002000A3O00202O0002000200334O000300043O00202O00030003002B00122O0005002C6O0003000500024O000300036O00010003000200062O000100282O013O0004443O00282O012O004D000100053O0012F9000200343O00122O000300356O000100036O00015O00044O00282O012O004D0001000F4O0070000200053O00122O000300363O00122O000400376O00020004000200062O000100282O0100020004443O00282O012O004D000100034O00290002000A3O00202O0002000200334O000300043O00202O00030003002B00122O0005002C6O0003000500024O000300036O00010003000200062O000100282O013O0004443O00282O012O004D000100053O001227010200383O001227010300394O00B6000100034O005800015O001227012O003A3O002O26012O00BC2O01003A0004443O00BC2O012O004D00015O0020D900010001003B0020222O01000100042O00F000010002000200062E2O01004A2O013O0004443O004A2O012O004D000100073O00202100010001003C4O00025O00202O00020002003B4O000300086O000400053O00122O0005003D3O00122O0006003E6O0004000600024O000500116O000600124O004D000700043O0020C900070007000A4O00095O00202O00090009003B4O0007000900024O000700076O00010007000200062O0001004A2O013O0004443O004A2O012O004D000100053O0012270102003F3O001227010300404O00B6000100034O005800016O004D00015O0020D90001000100410020222O01000100152O00F000010002000200062E2O0100802O013O0004443O00802O012O004D000100013O00062E2O0100802O013O0004443O00802O012O004D00015O00203F00010001000300202O0001000100424O0001000200024O000200023O00202O0002000200434O00020002000200202O00020002003A00062O000200802O0100010004443O00802O012O004D00015O0020D90001000100440020222O01000100092O00F000010002000200062E2O0100802O013O0004443O00802O012O004D00015O0020D900010001000D0020222O01000100452O00F00001000200020006292O01006F2O0100010004443O006F2O012O004D00015O0020D900010001000D0020222O01000100092O00F00001000200020006292O0100802O0100010004443O00802O012O004D000100034O001100025O00202O0002000200414O000300043O00202O00030003002B00122O0005002C6O0003000500024O000300036O000400016O00010004000200062O000100802O013O0004443O00802O012O004D000100053O001227010200463O001227010300474O00B6000100034O005800016O004D000100133O0020222O01000100042O00F000010002000200062E2O0100BB2O013O0004443O00BB2O012O004D000100023O0020E200010001001C4O00035O00202O0003000300484O00010003000200062O000100BB2O013O0004443O00BB2O012O004D000100013O00062E2O0100BB2O013O0004443O00BB2O012O004D00015O00203F00010001000300202O0001000100424O0001000200024O000200023O00202O0002000200434O00020002000200202O00020002003A00062O000200BB2O0100010004443O00BB2O012O004D00015O0020D90001000100440020222O01000100092O00F000010002000200062E2O0100BB2O013O0004443O00BB2O012O004D00015O0020D900010001000D0020222O01000100452O00F00001000200020006292O0100AB2O0100010004443O00AB2O012O004D00015O0020D900010001000D0020222O01000100092O00F00001000200020006292O0100BB2O0100010004443O00BB2O012O004D000100034O00E6000200136O000300043O00202O00030003000A4O000500136O0003000500024O000300036O000400016O00010004000200062O000100BB2O013O0004443O00BB2O012O004D000100053O001227010200493O0012270103004A4O00B6000100034O005800015O001227012O00023O000E310001000902013O0004443O000902012O004D000100144O001D2O01000100012O004D000100153O00062E2O0100DE2O013O0004443O00DE2O012O004D0001000D3O0026112O0100D12O01004B0004443O00D12O012O004D000100043O0020222O010001004C2O00F0000100020002000EDF004D00DE2O0100010004443O00DE2O012O004D000100063O00062E2O0100D12O013O0004443O00D12O012O004D000100163O000EDF001300DE2O0100010004443O00DE2O010012272O0100013O002O262O0100D22O0100010004443O00D22O012O004D000200174O00490002000100022O007A0002000B4O004D0002000B3O00062E010200DE2O013O0004443O00DE2O012O004D0002000B4O0042000200023O0004443O00DE2O010004443O00D22O012O004D000100183O0020222O01000100042O00F000010002000200062E2O01000802013O0004443O000802012O004D000100013O00062E2O01000802013O0004443O000802012O004D0001000D3O0026112O0100EE2O01004B0004443O00EE2O012O004D000100043O0020222O010001004C2O00F0000100020002000EDF004D0008020100010004443O000802012O004D00015O0020D900010001004E0020222O01000100092O00F000010002000200062E2O0100FE2O013O0004443O00FE2O012O004D00015O00204A00010001004E00202O00010001001F4O0001000200024O000200193O00062O000100FE2O0100020004443O00FE2O012O004D0001000D3O00260D2O0100080201004D0004443O000802012O004D000100034O004D000200184O00F000010002000200062E2O01000802013O0004443O000802012O004D000100053O0012270102004F3O001227010300504O00B6000100034O005800015O001227012O00513O002O26012O0011020100120004443O001102012O004D0001000B3O00062E2O01007C02013O0004443O007C02012O004D0001000B4O0042000100023O0004443O007C0201002O26012O0001000100510004443O000100012O004D00015O0020D90001000100030020222O01000100042O00F000010002000200062E2O01004402013O0004443O004402012O004D0001001A3O00062E2O01004402013O0004443O004402012O004D00015O0020D90001000100520020222O01000100092O00F000010002000200062E2O01004402013O0004443O004402012O004D0001001B4O002200025O00202O00020002000300202O0002000200534O00020002000200062O00020044020100010004443O004402012O004D000100163O00260E00010044020100540004443O004402012O004D000100073O00202A00010001000E4O00025O00202O0002000200034O000300086O0004001C6O000500043O00202O00050005000A4O00075O00202O0007000700034O0005000700024O000500056O000600076O0008000A3O00202O0008000800554O000900016O00010009000200062O0001004402013O0004443O004402012O004D000100053O001227010200563O001227010300574O00B6000100034O005800016O004D00015O0020D90001000100580020222O01000100152O00F000010002000200062E2O01006102013O0004443O006102012O004D000100073O00204000010001000E4O00025O00202O0002000200584O000300086O0004001D6O000500043O00202O00050005000A4O00075O00202O0007000700584O0005000700024O000500056O000600076O0008000A3O00202O0008000800594O00010008000200062O0001006102013O0004443O006102012O004D000100053O0012270102005A3O0012270103005B4O00B6000100034O005800016O004D00015O0020D900010001001E0020222O01000100042O00F000010002000200062E2O01007A02013O0004443O007A02012O004D000100013O00062E2O01007A02013O0004443O007A02012O004D000100034O002900025O00202O00020002001E4O000300043O00202O00030003002B00122O0005002C6O0003000500024O000300036O00010003000200062O0001007A02013O0004443O007A02012O004D000100053O0012270102005C3O0012270103005D4O00B6000100034O005800015O001227012O00133O0004443O000100012O002F3O00017O00213O00028O00027O0040030B3O00566F6964546F2O72656E74030A3O0049734361737461626C6503063O0042752O665570030C3O00566F6964666F726D42752O66030E3O0049735370652O6C496E52616E6765031A3O00B21605BE7ABCBA22B61C02AE05B8B90FB0161EA840A6A170F54903083O0050C4796CDA25C8D5026O00F03F030F3O004465766F7572696E67506C6167756503073O0049735265616479030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O66026O001040030F3O00432O6F6C646F776E52656D61696E732O033O00474344031D3O00047614705E1C830E743D6F470F8D1576426F47319E0F61107A451ACA5603073O00EA6013621F2B6E03093O004D696E64426C61737403073O005072657647434403173O000B165CC3937087070C4687BC7EB4121040D5A97C9F464703073O00EB667F32A7CC1203083O00566F6964426F6C7403093O004973496E52616E6765026O00444003163O0046AEFC277B2C5FADE16354226FB5FA31562B5E2OB57103063O004E30C1954324030D3O0056616D7069726963546F75636803133O0056616D7069726963546F756368446562752O66026O001840031B3O00261F8D084822178327553F0B8310012012BF0C4E220C851655704A03053O0021507EE07800B83O001227012O00013O002O26012O0029000100020004443O002900012O004D00015O0020D90001000100030020222O01000100042O00F000010002000200062E2O0100B700013O0004443O00B700012O004D000100014O004D000200024O000401036O00F50001000300020006292O010016000100010004443O001600012O004D000100033O0020E20001000100054O00035O00202O0003000300064O00010003000200062O000100B700013O0004443O00B700012O004D000100044O00D300025O00202O0002000200034O000300023O00202O0003000300074O00055O00202O0005000500034O0003000500024O000300036O000400016O00010004000200062O000100B700013O0004443O00B700012O004D000100053O0012F9000200083O00122O000300096O000100036O00015O00044O00B70001002O26012O00740001000A0004443O007400012O004D00015O0020D900010001000B0020222O010001000C2O00F000010002000200062E2O01005300013O0004443O005300012O004D000100023O00202400010001000D4O00035O00202O00030003000E4O00010003000200262O000100530001000F0004443O005300012O004D00015O00206D00010001000300202O0001000100104O0001000200024O000200033O00202O0002000200114O00020002000200202O00020002000200062O00010053000100020004443O005300012O004D000100044O001D00025O00202O00020002000B4O000300023O00202O0003000300074O00055O00202O00050005000B4O0003000500024O000300036O00010003000200062O0001005300013O0004443O005300012O004D000100053O001227010200123O001227010300134O00B6000100034O005800016O004D00015O0020D90001000100140020222O01000100042O00F000010002000200062E2O01007300013O0004443O007300012O004D000100033O00205400010001001500122O0003000A6O00045O00202O0004000400144O00010004000200062O00010073000100010004443O007300012O004D000100044O00D300025O00202O0002000200144O000300023O00202O0003000300074O00055O00202O0005000500144O0003000500024O000300036O000400016O00010004000200062O0001007300013O0004443O007300012O004D000100053O001227010200163O001227010300174O00B6000100034O005800015O001227012O00023O002O26012O0001000100010004443O000100012O004D00015O0020D90001000100180020222O01000100042O00F000010002000200062E2O01008C00013O0004443O008C00012O004D000100044O002900025O00202O0002000200184O000300023O00202O00030003001900122O0005001A6O0003000500024O000300036O00010003000200062O0001008C00013O0004443O008C00012O004D000100053O0012270102001B3O0012270103001C4O00B6000100034O005800016O004D00015O0020D900010001001D0020222O01000100042O00F000010002000200062E2O0100B500013O0004443O00B500012O004D000100023O00202400010001000D4O00035O00202O00030003001E4O00010003000200262O000100B50001001F0004443O00B500012O004D00015O00206D00010001000300202O0001000100104O0001000200024O000200033O00202O0002000200114O00020002000200202O00020002000200062O000100B5000100020004443O00B500012O004D000100044O00D300025O00202O00020002001D4O000300023O00202O0003000300074O00055O00202O00050005001D4O0003000500024O000300036O000400016O00010004000200062O000100B500013O0004443O00B500012O004D000100053O001227010200203O001227010300214O00B6000100034O005800015O001227012O000A3O0004443O000100012O002F3O00017O005E3O00028O00030D3O0056616D7069726963546F756368030A3O0049734361737461626C65030B3O00536861646F77437261736803083O00496E466C6967687403113O0057686973706572696E67536861646F7773030B3O004973417661696C61626C6503093O00436173744379636C65030E3O0049735370652O6C496E52616E676503163O0056616D7069726963546F7563684D6F7573656F76657203143O00FAA90ED455FEA100FB48E3BD00CC1CEDA706840E03053O003C8CC863A403073O00A4FB0A20AB95F903053O00C2E794644603093O004973496E52616E6765026O00444003123O005544C0A7F9DF794FD3A2E5C0064DCEA6B69C03063O00A8262CA1C39603123O00A5F2877B29A8831884F9903613FDA4058FEE03083O0076E09CE2165088D603063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203123O0051E658844DF9668350EF4A8802EF568502BA03043O00E0228E3903093O00FFB385FE66E34E01CC03083O006EBEC7A5BD13913D03123O00C9E376EC84D0E5E865E998CF9AEA78EDCB9303063O00A7BA8B1788EB026O003E4003093O0054696D65546F446965026O002E40027O0040026O00F03F026O000840030B3O00566F6964546F2O72656E74030B3O00507379636869634C696E6B030F3O00432O6F6C646F776E52656D61696E7303133O0056616D7069726963546F756368446562752O66030F3O0041757261416374697665436F756E74026O00F83F03083O00496E73616E697479026O00494003083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O6603063O0042752O66557003103O004461726B526576657269657342752O66030C3O00566F6964666F726D42752O6603113O004461726B417363656E73696F6E42752O6603143O00566F6964546F2O72656E744D6F7573656F76657203133O000CBA810925A1871F08B086195AB487085AE7DE03043O006D7AD5E803143O004D696E64466C6179496E73616E69747942752O66030B3O0049646F6C4F66437468756E03103O00E3FEAC34D1F1AE31F7B7A33FEBB7F06803043O00508E97C2026O00104003153O0015C77A5C0AD47E4F3CD2785900CE374D0CC3371D5703043O002C63A61703113O004D696E645370696B65496E73616E69747903073O004973526561647903093O004D696E64426C61737403103O0046752O6C526563686172676554696D652O033O00474344030C3O00432O6F6C646F776E446F776E031A3O0071FE27320CB76CFE22330CAD72E428383AB065B7283936E42DAF03063O00C41C9749565303103O00FE0A2714BD5E1477EA43281F87184A2603083O001693634970E2387803083O0042752O66446F776E03103O004D696E644465766F7572657242752O66030C3O00566F69644572757074696F6E030A3O00432O6F6C646F776E557003113O00B57CECF1B2BA79E3E699F874EDF0CDEA2703053O00EDD815829503143O00536861646F77576F72645061696E446562752O66030D3O004461726B417363656E73696F6E03103O008F47515BB2CC50864B4D1FB1C65BC21803073O003EE22E2O3FD0A903083O004361737454696D6503123O00496E657363617061626C65546F726D656E74026O001C4003103O00E8105B87200F235FF60D158210086F0603083O003E857935E37F6D4F03083O00566F6964426F6C7403103O00061B3BF1E9ACAD1C0072F4D9ABE2414403073O00C270745295B6CE030F3O004465766F7572696E67506C61677565030F3O00496E73616E69747944656669636974026O003440030B3O0042752O6652656D61696E7303183O004465766F7572696E67506C616775654D6F7573656F76657203173O003DAD5A17D5F00737AF7308CCE3092CAD0C19CFE74E68FA03073O006E59C82C78A0820002032O001227012O00013O002O26012O00AF000100010004443O00AF00012O004D00016O001D2O01000100012O00CE000100013O00202O00010001000200202O0001000100034O00010002000200062O0001003500013O0004443O003500012O004D000100023O000EDF00010017000100010004443O001700012O004D000100033O0006292O010017000100010004443O001700012O004D000100013O0020D90001000100040020222O01000100052O00F000010002000200062E2O01001D00013O0004443O001D00012O004D000100013O0020D90001000100060020222O01000100072O00F00001000200020006292O010035000100010004443O003500012O004D000100043O00202A0001000100084O000200013O00202O0002000200024O000300056O000400066O000500073O00202O0005000500094O000700013O00202O0007000700024O0005000700024O000500056O000600076O000800083O00202O00080008000A4O000900016O00010009000200062O0001003500013O0004443O003500012O004D000100093O0012270102000B3O0012270103000C4O00B6000100034O005800016O004D000100013O0020D90001000100040020222O01000100032O00F000010002000200062E2O01009000013O0004443O009000012O004D0001000A3O0006292O010090000100010004443O009000012O004D0001000B4O0070000200093O00122O0003000D3O00122O0004000E6O00020004000200062O00010056000100020004443O005600012O004D0001000C4O0029000200013O00202O0002000200044O000300073O00202O00030003000F00122O000500106O0003000500024O000300036O00010003000200062O0001009000013O0004443O009000012O004D000100093O0012F9000200113O00122O000300126O000100036O00015O00044O009000012O004D0001000B4O0070000200093O00122O000300133O00122O000400146O00020004000200062O00010079000100020004443O007900012O004D0001000D3O0020222O01000100152O00F000010002000200062E2O01009000013O0004443O009000012O004D0001000E3O0020222O01000100162O004D0003000D4O00F500010003000200062E2O01009000013O0004443O009000012O004D0001000C4O0029000200083O00202O0002000200174O000300073O00202O00030003000F00122O000500106O0003000500024O000300036O00010003000200062O0001009000013O0004443O009000012O004D000100093O0012F9000200183O00122O000300196O000100036O00015O00044O009000012O004D0001000B4O0070000200093O00122O0003001A3O00122O0004001B6O00020004000200062O00010090000100020004443O009000012O004D0001000C4O0029000200083O00202O0002000200174O000300073O00202O00030003000F00122O000500106O0003000500024O000300036O00010003000200062O0001009000013O0004443O009000012O004D000100093O0012270102001C3O0012270103001D4O00B6000100034O005800016O004D0001000F3O00062E2O0100AE00013O0004443O00AE00012O004D000100103O0026112O0100A10001001E0004443O00A100012O004D000100073O0020222O010001001F2O00F0000100020002000EDF002000AE000100010004443O00AE00012O004D0001000A3O00062E2O0100A100013O0004443O00A100012O004D000100113O000EDF002100AE000100010004443O00AE00010012272O0100013O002O262O0100A2000100010004443O00A200012O004D000200134O00490002000100022O007A000200124O004D000200123O00062E010200AE00013O0004443O00AE00012O004D000200124O0042000200023O0004443O00AE00010004443O00A20001001227012O00223O002O26012O00482O0100230004443O00482O012O004D000100013O0020D90001000100240020222O01000100072O00F000010002000200062E2O0100FE00013O0004443O00FE00012O004D000100013O0020D90001000100250020222O01000100072O00F000010002000200062E2O0100FE00013O0004443O00FE00012O004D000100013O0020D90001000100240020222O01000100262O00F000010002000200260E000100FE000100230004443O00FE00012O004D0001000A3O00062E2O0100D000013O0004443O00D000012O004D000100114O0074000200013O00202O00020002002700202O0002000200284O0002000200024O000300116O0002000200034O00010001000200262O000100FE000100290004443O00FE00012O004D0001000E3O0020222O010001002A2O00F0000100020002000E5D002B00F1000100010004443O00F100012O004D000100073O0020232O010001002C4O000300013O00202O00030003002D4O00010003000200062O000100F1000100010004443O00F100012O004D0001000E3O0020232O010001002E4O000300013O00202O00030003002F4O00010003000200062O000100F1000100010004443O00F100012O004D0001000E3O0020232O010001002E4O000300013O00202O0003000300304O00010003000200062O000100F1000100010004443O00F100012O004D0001000E3O0020E200010001002E4O000300013O00202O0003000300314O00010003000200062O000100FE00013O0004443O00FE00010012272O0100013O002O262O0100F2000100010004443O00F200012O004D000200144O00490002000100022O007A000200124O004D000200123O00062E010200FE00013O0004443O00FE00012O004D000200124O0042000200023O0004443O00FE00010004443O00F200012O004D000100013O0020D90001000100240020222O01000100032O00F000010002000200062E2O0100222O013O0004443O00222O012O004D000100013O0020D90001000100250020222O01000100072O00F00001000200020006292O0100222O0100010004443O00222O012O004D000100043O00202A0001000100084O000200013O00202O0002000200244O000300056O000400156O000500073O00202O0005000500094O000700013O00202O0007000700244O0005000700024O000500056O000600076O000800083O00202O0008000800324O000900016O00010009000200062O000100222O013O0004443O00222O012O004D000100093O001227010200333O001227010300344O00B6000100034O005800016O004D000100163O0020222O01000100032O00F000010002000200062E2O0100442O013O0004443O00442O012O004D0001000E3O0020E200010001002E4O000300013O00202O0003000300354O00010003000200062O000100442O013O0004443O00442O012O004D000100013O0020D90001000100360020222O01000100072O00F000010002000200062E2O0100442O013O0004443O00442O012O004D0001000C4O00E6000200166O000300073O00202O0003000300094O000500166O0003000500024O000300036O000400016O00010004000200062O000100442O013O0004443O00442O012O004D000100093O001227010200373O001227010300384O00B6000100034O005800016O004D000100174O00490001000100022O007A000100123O001227012O00393O000E310021001702013O0004443O001702012O004D000100013O0020D90001000100020020222O01000100032O00F000010002000200062E2O0100772O013O0004443O00772O012O004D000100023O000EDF000100592O0100010004443O00592O012O004D000100013O0020D90001000100040020222O01000100052O00F000010002000200062E2O01005F2O013O0004443O005F2O012O004D000100013O0020D90001000100060020222O01000100072O00F00001000200020006292O0100772O0100010004443O00772O012O004D000100043O00202A0001000100084O000200013O00202O0002000200024O000300056O000400186O000500073O00202O0005000500094O000700013O00202O0007000700024O0005000700024O000500056O000600076O000800083O00202O00080008000A4O000900016O00010009000200062O000100772O013O0004443O00772O012O004D000100093O0012270102003A3O0012270103003B4O00B6000100034O005800016O004D000100013O0020D900010001003C0020222O010001003D2O00F000010002000200062E2O0100AD2O013O0004443O00AD2O012O004D000100193O00062E2O0100AD2O013O0004443O00AD2O012O004D000100013O00203F00010001003E00202O00010001003F4O0001000200024O0002000E3O00202O0002000200404O00020002000200202O00020002002300062O000200AD2O0100010004443O00AD2O012O004D000100013O0020D90001000100360020222O01000100072O00F000010002000200062E2O0100AD2O013O0004443O00AD2O012O004D000100013O0020D90001000100240020222O01000100412O00F00001000200020006292O01009C2O0100010004443O009C2O012O004D000100013O0020D90001000100240020222O01000100072O00F00001000200020006292O0100AD2O0100010004443O00AD2O012O004D0001000C4O0011000200013O00202O00020002003C4O000300073O00202O00030003000F00122O000500106O0003000500024O000300036O000400016O00010004000200062O000100AD2O013O0004443O00AD2O012O004D000100093O001227010200423O001227010300434O00B6000100034O005800016O004D000100163O0020222O01000100032O00F000010002000200062E2O0100E82O013O0004443O00E82O012O004D0001000E3O0020E200010001002E4O000300013O00202O0003000300354O00010003000200062O000100E82O013O0004443O00E82O012O004D000100193O00062E2O0100E82O013O0004443O00E82O012O004D000100013O00203F00010001003E00202O00010001003F4O0001000200024O0002000E3O00202O0002000200404O00020002000200202O00020002002300062O000200E82O0100010004443O00E82O012O004D000100013O0020D90001000100360020222O01000100072O00F000010002000200062E2O0100E82O013O0004443O00E82O012O004D000100013O0020D90001000100240020222O01000100412O00F00001000200020006292O0100D82O0100010004443O00D82O012O004D000100013O0020D90001000100240020222O01000100072O00F00001000200020006292O0100E82O0100010004443O00E82O012O004D0001000C4O00E6000200166O000300073O00202O0003000300094O000500166O0003000500024O000300036O000400016O00010004000200062O000100E82O013O0004443O00E82O012O004D000100093O001227010200443O001227010300454O00B6000100034O005800016O004D000100013O0020D900010001003E0020222O01000100032O00F000010002000200062E2O01001602013O0004443O001602012O004D0001001A3O00062E2O01001602013O0004443O001602012O004D0001000E3O0020232O01000100464O000300013O00202O0003000300474O00010003000200062O00010004020100010004443O000402012O004D000100013O0020D90001000100480020222O01000100492O00F000010002000200062E2O01001602013O0004443O001602012O004D000100013O0020D90001000100480020222O01000100072O00F000010002000200062E2O01001602013O0004443O001602012O004D0001000C4O00D3000200013O00202O00020002003E4O000300073O00202O0003000300094O000500013O00202O00050005003E4O0003000500024O000300036O000400016O00010004000200062O0001001602013O0004443O001602012O004D000100093O0012270102004A3O0012270103004B4O00B6000100034O005800015O001227012O00233O000E310039001F02013O0004443O001F02012O004D000100123O00062E2O01000103013O0004443O000103012O004D000100124O0042000100023O0004443O00010301002O26012O0001000100220004443O000100012O004D0001001B3O0020222O01000100032O00F000010002000200062E2O01005E02013O0004443O005E02012O004D000100073O0020E200010001002C4O000300013O00202O00030003004C4O00010003000200062O0001003002013O0004443O003002012O004D0001001A3O0006292O01003C020100010004443O003C02012O004D000100013O0020D90001000100040020222O01000100052O00F000010002000200062E2O01005E02013O0004443O005E02012O004D000100013O0020D90001000100060020222O01000100072O00F000010002000200062E2O01005E02013O0004443O005E02012O004D000100103O0026112O0100440201001E0004443O004402012O004D000100073O0020222O010001001F2O00F0000100020002000EDF0020005E020100010004443O005E02012O004D000100013O0020D900010001004D0020222O01000100072O00F000010002000200062E2O01005402013O0004443O005402012O004D000100013O00204A00010001004D00202O0001000100264O0001000200024O0002001C3O00062O00010054020100020004443O005402012O004D000100103O00260D2O01005E020100200004443O005E02012O004D0001000C4O004D0002001B4O00F000010002000200062E2O01005E02013O0004443O005E02012O004D000100093O0012270102004E3O0012270103004F4O00B6000100034O005800016O004D000100013O0020D900010001003E0020222O01000100032O00F000010002000200062E2O0100A502013O0004443O00A502012O004D000100013O00201F2O010001003E00202O00010001003F4O0001000200024O0002001C6O000300013O00202O00030003003E00202O0003000300504O0003000200024O00020002000300062O0001000A000100020004443O007902012O004D0001001D4O00B9000200013O00202O00020002003E00202O0002000200504O0002000200024O0003001C6O00020002000300062O000100A5020100020004443O00A502012O004D0001001E3O00062E2O0100A502013O0004443O00A502012O004D000100013O0020D90001000100510020222O01000100072O00F000010002000200062E2O0100A502013O0004443O00A502012O004D0001001D4O0022000200013O00202O00020002003E00202O0002000200504O00020002000200062O000200A5020100010004443O00A502012O004D000100113O00260E000100A5020100520004443O00A502012O004D0001000E3O0020E20001000100464O000300013O00202O0003000300474O00010003000200062O000100A502013O0004443O00A502012O004D0001000C4O00D3000200013O00202O00020002003E4O000300073O00202O0003000300094O000500013O00202O00050005003E4O0003000500024O000300036O000400016O00010004000200062O000100A502013O0004443O00A502012O004D000100093O001227010200533O001227010300544O00B6000100034O005800016O004D000100013O0020D90001000100550020222O01000100032O00F000010002000200062E2O0100BB02013O0004443O00BB02012O004D0001000C4O0029000200013O00202O0002000200554O000300073O00202O00030003000F00122O000500106O0003000500024O000300036O00010003000200062O000100BB02013O0004443O00BB02012O004D000100093O001227010200563O001227010300574O00B6000100034O005800016O004D000100013O0020D90001000100580020222O010001003D2O00F000010002000200062E2O0100FF02013O0004443O00FF02012O004D0001001F3O00062E2O0100E802013O0004443O00E802012O004D0001000E3O0020222O01000100592O00F00001000200020026D0000100E80201005A0004443O00E802012O004D0001000E3O0020E200010001002E4O000300013O00202O0003000300304O00010003000200062O000100FF02013O0004443O00FF02012O004D000100013O00200C2O010001005500202O0001000100264O0001000200024O0002000E3O00202O00020002005B4O000400013O00202O0004000400304O00020004000200062O000200FF020100010004443O00FF02012O004D000100013O00205700010001005500202O0001000100264O0001000200024O0002000E3O00202O00020002005B4O000400013O00202O0004000400304O00020004000200202O00020002002200202O00020002002200062O000100FF020100020004443O00FF02012O004D000100043O0020400001000100084O000200013O00202O0002000200584O000300056O000400206O000500073O00202O0005000500094O000700013O00202O0007000700584O0005000700024O000500056O000600076O000800083O00202O00080008005C4O00010008000200062O000100FF02013O0004443O00FF02012O004D000100093O0012270102005D3O0012270103005E4O00B6000100034O005800015O001227012O00213O0004443O000100012O002F3O00017O002B3O00028O0003043O004661646503073O004973526561647903103O004865616C746850657263656E74616765030E3O00ADC24F43034E3E4BAECD584F554F03083O002DCBA32B26232A5B030A3O0044697370657273696F6E030A3O0049734361737461626C6503143O00D68CCF3382BB47DB8AD26383AC52D78BCF2A91AC03073O0034B2E5BC43E7C9026O00F03F026O00084003193O0013445616F24F2B284F5744DF59222D485E03B76C2C35485F0A03073O004341213064973C03173O0052656672657368696E674865616C696E67506F74696F6E03253O00CDE2A8CAF6CCEFA7D6F49FEFABD9FFD6E9A998E3D0F3A7D7FD9FE3ABDEF6D1F4A7CEF69FB303053O0093BF87CEB8030F3O00446573706572617465507261796572031A3O00802DB5D1DD41B3902D99D1CA52AB813AE6C5DD55B78A3BAFD7DD03073O00D2E448C6A1B833030F3O0056616D7069726963456D6272616365030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40031D3O00417265556E69747342656C6F774865616C746850657263656E74616765031A3O002048FE007ADC3F4ACC157ECC2448F01533CA334FF61E60C7204C03063O00AE5629937013027O004003093O00466C6173684865616C030F3O00466C6173684865616C506C6179657203143O005D0C8C182D3019AE5A0CCD0F200914A548099B0E03083O00CB3B60ED6B456F7103053O0052656E6577030B3O0052656E6577506C61796572030F3O003613A2E426B0D32110A9EF22F9C12103073O00B74476CC815190030F3O00506F776572576F7264536869656C6403153O00506F776572576F7264536869656C64506C61796572031B3O001EA267E119BD19A262E0349106A475E80FC20AA876E1059107BB7503063O00E26ECD10846B030B3O004865616C746873746F6E6503173O00E3C6E1D555E3D0F4D64FEE83E4DC47EECDF3D057EE83B303053O00218BA380B9001F012O001227012O00013O002O26012O003A000100010004443O003A00012O004D00015O0020D90001000100020020222O01000100032O00F000010002000200062E2O01001F00013O0004443O001F00012O004D000100013O00062E2O01001F00013O0004443O001F00012O004D000100023O0020222O01000100042O00F00001000200022O004D000200033O0006C70001001F000100020004443O001F00012O004D000100044O003900025O00202O0002000200024O000300046O000500016O00010005000200062O0001001F00013O0004443O001F00012O004D000100053O001227010200053O001227010300064O00B6000100034O005800016O004D00015O0020D90001000100070020222O01000100082O00F000010002000200062E2O01003900013O0004443O003900012O004D000100023O0020222O01000100042O00F00001000200022O004D000200063O0006B700010039000100020004443O003900012O004D000100073O00062E2O01003900013O0004443O003900012O004D000100044O004D00025O0020D90002000200072O00F000010002000200062E2O01003900013O0004443O003900012O004D000100053O001227010200093O0012270103000A4O00B6000100034O005800015O001227012O000B3O002O26012O00600001000C0004443O006000012O004D000100083O00062E2O01001E2O013O0004443O001E2O012O004D000100023O0020222O01000100042O00F00001000200022O004D000200093O0006C70001001E2O0100020004443O001E2O012O004D0001000A4O0070000200053O00122O0003000D3O00122O0004000E6O00020004000200062O0001001E2O0100020004443O001E2O012O004D0001000B3O0020D900010001000F0020222O01000100032O00F000010002000200062E2O01001E2O013O0004443O001E2O012O004D000100044O00390002000C3O00202O00020002000F4O000300046O000500016O00010005000200062O0001001E2O013O0004443O001E2O012O004D000100053O0012F9000200103O00122O000300116O000100036O00015O00044O001E2O01002O26012O00A50001000B0004443O00A500012O004D00015O0020D90001000100120020222O01000100082O00F000010002000200062E2O01007C00013O0004443O007C00012O004D000100023O0020222O01000100042O00F00001000200022O004D0002000D3O0006C70001007C000100020004443O007C00012O004D0001000E3O00062E2O01007C00013O0004443O007C00012O004D000100044O004D00025O0020D90002000200122O00F000010002000200062E2O01007C00013O0004443O007C00012O004D000100053O001227010200133O001227010300144O00B6000100034O005800016O004D00015O0020D90001000100150020222O01000100032O00F000010002000200062E2O0100A400013O0004443O00A400012O004D0001000F3O0020D90001000100162O004900010001000200062E2O0100A400013O0004443O00A400012O004D000100103O0020222O0100010017001227010300184O00F500010003000200062E2O0100A400013O0004443O00A400012O004D000100113O00062E2O0100A400013O0004443O00A400012O004D0001000F3O00202F2O01000100194O000200126O000300136O00010003000200062O000100A400013O0004443O00A400012O004D000100044O003900025O00202O0002000200154O000300036O000400016O00010004000200062O000100A400013O0004443O00A400012O004D000100053O0012270102001A3O0012270103001B4O00B6000100034O005800015O001227012O001C3O002O26012O00010001001C0004443O000100012O004D000100143O00062E2O012O002O013O0004444O002O010012272O0100013O000E31000100E2000100010004443O00E200012O004D00025O0020D900020002001D0020220102000200082O00F000020002000200062E010200C700013O0004443O00C700012O004D000200023O0020220102000200042O00F00002000200022O004D000300153O0006C7000200C7000100030004443O00C700012O004D000200163O00062E010200C700013O0004443O00C700012O004D000200044O004D0003000C3O0020D900030003001E2O00F000020002000200062E010200C700013O0004443O00C700012O004D000200053O0012270103001F3O001227010400204O00B6000200044O005800026O004D00025O0020D90002000200210020220102000200082O00F000020002000200062E010200E100013O0004443O00E100012O004D000200023O0020220102000200042O00F00002000200022O004D000300173O0006C7000200E1000100030004443O00E100012O004D000200183O00062E010200E100013O0004443O00E100012O004D000200044O004D0003000C3O0020D90003000300222O00F000020002000200062E010200E100013O0004443O00E100012O004D000200053O001227010300233O001227010400244O00B6000200044O005800025O0012272O01000B3O000E31000B00AB000100010004443O00AB00012O004D00025O0020D90002000200250020220102000200082O00F000020002000200062E01022O002O013O0004444O002O012O004D000200023O0020220102000200042O00F00002000200022O004D000300193O0006C700022O002O0100030004444O002O012O004D0002001A3O00062E01022O002O013O0004444O002O012O004D000200044O004D0003000C3O0020D90003000300262O00F000020002000200062E01022O002O013O0004444O002O012O004D000200053O0012F9000300273O00122O000400286O000200046O00025O00045O002O010004443O00AB00012O004D0001000B3O0020D90001000100290020222O01000100032O00F000010002000200062E2O01001C2O013O0004443O001C2O012O004D0001001B3O00062E2O01001C2O013O0004443O001C2O012O004D000100023O0020222O01000100042O00F00001000200022O004D0002001C3O0006C70001001C2O0100020004443O001C2O012O004D000100044O00390002000C3O00202O0002000200294O000300046O000500016O00010005000200062O0001001C2O013O0004443O001C2O012O004D000100053O0012270102002A3O0012270103002B4O00B6000100034O005800015O001227012O000C3O0004443O000100012O002F3O00017O00103O0003073O0047657454696D65028O00030B3O00426F6479616E64536F756C030B3O004973417661696C61626C65030F3O00506F776572576F7264536869656C6403073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O6603153O00506F776572576F7264536869656C64506C61796572031D3O00475713DB456713D1455C3BCD5F5101D2536714D2564101CC17550BC85203043O00BE373864030E3O00416E67656C69634665617468657203143O00416E67656C696346656174686572506C61796572031B3O0057A13B1B1FEAF069A9391F07EBF644902C2O12FAF644EF311105E603073O009336CF5C7E7383005E3O0012563O00018O000100024O00019O003O00014O000100013O00062O0001005D00013O0004443O005D0001001227012O00023O002O26012O0008000100020004443O000800012O004D000100023O0020D90001000100030020222O01000100042O00F000010002000200062E2O01003200013O0004443O003200012O004D000100023O0020D90001000100050020222O01000100062O00F000010002000200062E2O01003200013O0004443O003200012O004D000100033O00062E2O01003200013O0004443O003200012O004D000100043O0020E20001000100074O000300023O00202O0003000300084O00010003000200062O0001003200013O0004443O003200012O004D000100043O0020E20001000100074O000300023O00202O0003000300094O00010003000200062O0001003200013O0004443O003200012O004D000100054O004D000200063O0020D900020002000A2O00F000010002000200062E2O01003200013O0004443O003200012O004D000100073O0012270102000B3O0012270103000C4O00B6000100034O005800016O004D000100023O0020D900010001000D0020222O01000100062O00F000010002000200062E2O01005D00013O0004443O005D00012O004D000100083O00062E2O01005D00013O0004443O005D00012O004D000100043O0020E20001000100074O000300023O00202O0003000300084O00010003000200062O0001005D00013O0004443O005D00012O004D000100043O0020E20001000100074O000300023O00202O0003000300094O00010003000200062O0001005D00013O0004443O005D00012O004D000100043O0020E20001000100074O000300023O00202O0003000300084O00010003000200062O0001005D00013O0004443O005D00012O004D000100054O004D000200063O0020D900020002000E2O00F000010002000200062E2O01005D00013O0004443O005D00012O004D000100073O0012F90002000F3O00122O000300106O000100036O00015O00044O005D00010004443O000800012O002F3O00017O00063O00030D3O005075726966794469736561736503073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E697403123O0050757269667944697365617365466F63757303153O001D2427740B6732353C6E087F1E347579046D1D343903063O001E6D51551D6D001A4O00CE7O00206O000100206O00026O0002000200064O001900013O0004443O001900012O004D3O00013O00062E012O001900013O0004443O001900012O004D3O00023O0020D95O00032O00493O0001000200062E012O001900013O0004443O001900012O004D3O00034O004D000100043O0020D90001000100042O00F03O0002000200062E012O001900013O0004443O001900012O004D3O00053O0012272O0100053O001227010200064O00B63O00024O00588O002F3O00017O006D3O00028O00026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E677303153O00CA62518639C9F9ED465BA432F8F3ED655DA223DAF903073O009C9F1134D656BE03113O009BFCB89DA0E8B8B0A7EC9BB9AFFBB5B9BC03043O00DCCE8FDD030E3O00B36E2835D7C8CBA7732924D7D9DE03073O00B2E61D4D77B8AC030D3O00D8B11C1E7AFDFBAA2E1E7BF9EC03063O009895DE6A7B17027O0040026O002440030D3O00E835F370BDDC22F954B3D234FB03053O00D5BD46962303123O007A46713E4E5864015D5C772D425766094C5003043O00682F351403113O00954D8C0CB51DAA4FA411BE1DA24F84348C03063O006FC32CE17CDC03143O00EE470D63A2B9D145257EA9B9D9450554B9A4CD5603063O00CBB8266013CB026O002640026O00144003063O001F727D44E60903053O00AE59131921030E3O001A015766F286073B1A415AF8890E03073O006B4F72322E97E7030D3O0011A3B4259E31A4D436A8B001BA03083O00A059C6D549EA59D703123O00787EA3FBD7617FB2EBD6417EBACBD64976B103053O00A52811D49E034O00026O001840030D3O00C1D01B2O23E9FD0D3133E3DF1B03053O004685B96853030B3O00204C573ACC0867512CCF1703053O00A96425244A030F3O002886AC540C828356068BAB531482A603043O003060E7C203113O00E05B002915DD868DCB551C3D16CAAA82C403083O00E3A83A6E4D79B8CF026O000840026O00104003113O005F39AC50B4C970B17E0CAD41A8DE638D4B03083O00C51B5CDF20D1BB11030C3O002756D0EB064DD0F20C51EBCB03043O009B633FA3030D3O00B7C2A4A9B09792D4B39EB08B8C03063O00E4E2B1C1EDD903073O0001A326C035B42603043O008654D04303103O0020A487581CBBA54E12BF8E6900AD815903043O003C73CCE603123O00D13BE660EE28E273D335FE73EF0FF871E03F03043O0010875A8B03103O0062750B23474671574009264D5C2O556C03073O0018341466532E3403113O00ED2135211DD63A313038CD3B29171BD12103053O006FA44F414403163O00EFD797DB3CF8D3C997F120E6DFEE8BD73AEFCAD090CA03063O008AA6B9E3BE4E03123O00E27AD13240310CDB60F13F40260AC37BC93303073O0079AB14A557324303123O00F32BBC12BC11D63DAB37AD07F62AB82FBC1003063O0062A658D956D903133O00C6F96E0494F5F8F06C128FD3F8C2781381D9E203063O00BC2O961961E6030F3O00EA8648071EC4D48F4A1105E2D4A16F03063O008DBAE93F626C03123O00C1E53BB337D8E42AA336F8E5229137FEFF3C03053O0045918A4CD603073O0040E6A788B2132103063O007610AF2OE9DF026O001C40026O00224003083O00BE973089EB85789C03073O001DEBE455DB8EEB03073O000FD1B4D860661703083O00325DB4DABD172E4703123O00EBB75E7C4BCB4DCC93545E40EF40D7A1574803073O0028BEC43B2C24BC03113O000C4ACBB1E84A022E41EFBCF37801386DEC03073O006D5C25BCD49A1D03073O0034C68AC23C5F5603063O003A648FC4A35103073O002A6B0DA2324CB603083O006E7A2243C35F298503073O0040A25E62D779BE03053O00B615D13B2A03063O009F56C912098E03063O00DED737A57D41026O00204003093O0004D0CA15D5D3E25F3C03083O002A4CB1A67A92A18D030D3O00909900EA7060AC8400FD6D77B703063O0016C5EA65AE19030C3O001827A0FA7AAEC48E0531A4D003083O00E64D54C5BC16CFB7030B3O00DF18C7EF8489F534F53CF603083O00559974A69CECC190030A3O0091F34881E503ADE141A003063O0060C4802DD38403104O009E7E77D7AEB8D13B8A4B50C6A6BBD603083O00B855ED1B3FB2CFD403113O00205C085301570E6F074D0050067708520D03043O003F683969030F3O002382A5480289A3740493AD4B05AF9403043O00246BE7C400EA012O001227012O00013O002O26012O0027000100020004443O0027000100122E000100033O0020720001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200062O00010025000100010004443O002500010012272O0100014O007A000100043O001227012O000D3O002O26012O00500001000E0004443O0050000100122E000100033O0020360001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O00010001000200062O00010043000100010004443O004300010012272O0100014O007A000100073O00127E000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O00010001000200062O0001004E000100010004443O004E00010012272O0100014O007A000100083O001227012O00173O002O26012O007C000100180004443O007C000100122E000100033O0020F40001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O00010001000200062O0001005C000100010004443O005C00010012272O0100014O007A000100093O0012BD000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200062O0001006F000100010004443O006F00010012272O0100014O007A0001000B3O00127E000100033O00202O0001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O00010001000200062O0001007A000100010004443O007A00010012272O0100214O007A0001000C3O001227012O00223O002O26012O009F0001000D0004443O009F000100122E000100033O0020550001000100044O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100103O00124O002B3O002O26012O00C80001002C0004443O00C8000100122E000100033O0020F40001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200062O000100AB000100010004443O00AB00010012272O0100014O007A000100113O00127E000100033O00202O0001000100044O000200013O00122O0003002F3O00122O000400306O0002000400024O00010001000200062O000100B6000100010004443O00B600010012272O0100014O007A000100123O0012A6000100033O00202O0001000100044O000200013O00122O000300313O00122O000400326O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100042O004D000200013O001208000300333O00122O000400346O0002000400024O0001000100024O000100143O00124O00183O002O26012O00EC000100170004443O00EC000100122E000100033O0020F40001000100044O000200013O00122O000300353O00122O000400366O0002000400024O00010001000200062O000100D4000100010004443O00D400010012272O0100214O007A000100153O00127E000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O00010001000200062O000100DF000100010004443O00DF00010012272O0100214O007A000100163O00127E000100033O00202O0001000100044O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100EA000100010004443O00EA00010012272O0100014O007A000100173O0004443O00E92O01002O26012O00122O01002B0004443O00122O0100122E000100033O0020360001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100183O00122O000100033O00202O0001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O000100193O00122O000100033O00202O0001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O00010001000200062O000100082O0100010004443O00082O010012272O0100014O007A0001001A3O001214000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O0001000100024O0001001B3O00124O002C3O002O26012O00412O0100220004443O00412O0100122E000100033O0020F40001000100044O000200013O00122O000300433O00122O000400446O0002000400024O00010001000200062O0001001E2O0100010004443O001E2O010012272O0100214O007A0001001C3O00127E000100033O00202O0001000100044O000200013O00122O000300453O00122O000400466O0002000400024O00010001000200062O000100292O0100010004443O00292O010012272O0100014O007A0001001D3O00127E000100033O00202O0001000100044O000200013O00122O000300473O00122O000400486O0002000400024O00010001000200062O000100342O0100010004443O00342O010012272O0100014O007A0001001E3O00127E000100033O00202O0001000100044O000200013O00122O000300493O00122O0004004A6O0002000400024O00010001000200062O0001003F2O0100010004443O003F2O010012272O0100214O007A0001001F3O001227012O004B3O002O26012O006A2O01004C0004443O006A2O0100122E000100033O00206E0001000100044O000200013O00122O0003004D3O00122O0004004E6O0002000400024O0001000100024O000100203O00122O000100033O00202O0001000100044O000200013O00122O0003004F3O00122O000400506O0002000400024O00010001000200062O000100552O0100010004443O00552O010012272O0100014O007A000100213O0012BD000100033O00202O0001000100044O000200013O00122O000300513O00122O000400526O0002000400024O0001000100024O000100223O00122O000100033O00202O0001000100044O000200013O00122O000300533O00122O000400546O0002000400024O00010001000200062O000100682O0100010004443O00682O010012272O0100014O007A000100233O001227012O000E3O000E31004B00962O013O0004443O00962O0100122E000100033O0020F40001000100044O000200013O00122O000300553O00122O000400566O0002000400024O00010001000200062O000100762O0100010004443O00762O010012272O0100214O007A000100243O00127E000100033O00202O0001000100044O000200013O00122O000300573O00122O000400586O0002000400024O00010001000200062O000100812O0100010004443O00812O010012272O0100214O007A000100253O0012BD000100033O00202O0001000100044O000200013O00122O000300593O00122O0004005A6O0002000400024O0001000100024O000100263O00122O000100033O00202O0001000100044O000200013O00122O0003005B3O00122O0004005C6O0002000400024O00010001000200062O000100942O0100010004443O00942O010012272O0100014O007A000100273O001227012O005D3O002O26012O00BF2O01005D0004443O00BF2O0100122E000100033O0020F40001000100044O000200013O00122O0003005E3O00122O0004005F6O0002000400024O00010001000200062O000100A22O0100010004443O00A22O010012272O0100014O007A000100283O001271000100033O00202O0001000100044O000200013O00122O000300603O00122O000400616O0002000400024O0001000100024O000100293O00122O000100033O00202O0001000100044O000200013O00122O000300623O00122O000400636O0002000400024O0001000100024O0001002A3O00122O000100033O00202O0001000100044O000200013O00122O000300643O00122O000400656O0002000400024O00010001000200062O000100BD2O0100010004443O00BD2O010012272O0100014O007A0001002B3O001227012O004C3O002O26012O0001000100010004443O0001000100122E000100033O0020360001000100044O000200013O00122O000300663O00122O000400676O0002000400024O0001000100024O0001002C3O00122O000100033O00202O0001000100044O000200013O00122O000300683O00122O000400696O0002000400024O0001000100024O0001002D3O00122O000100033O00202O0001000100044O000200013O00122O0003006A3O00122O0004006B6O0002000400024O00010001000200062O000100DB2O0100010004443O00DB2O010012272O0100214O007A0001002E3O00127E000100033O00202O0001000100044O000200013O00122O0003006C3O00122O0004006D6O0002000400024O00010001000200062O000100E62O0100010004443O00E62O010012272O0100014O007A0001002F3O001227012O00023O0004443O000100012O002F3O00017O00653O00028O00026O001440030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174026O00084003093O00497343617374696E67030C3O0049734368612O6E656C696E67026O00F03F03093O00496E74652O7275707403073O0053696C656E6365026O003E4003103O0053696C656E63654D6F7573656F766572027O004003113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O002040030F3O0048616E646C65412O666C6963746564030D3O005075726966794469736561736503163O00507572696679446973656173654D6F7573656F766572026O004440010003043O004755494403043O00502O6F6C03113O006DBAAD8B1DB3AD951D9AB282532OB0CF1403043O00E73DD5C2030B3O0044697370656C4D6167696303073O004973526561647903103O00556E69744861734D6167696342752O66030E3O0049735370652O6C496E52616E676503133O000DA42E630CA1027E08AA347049A93C7E08AA3803043O001369CD5D030E3O009907D18D7FAF07CCC11EA62D96C803053O005FC968BEE103113O0048616E646C65496E636F72706F7265616C030C3O00446F6D696E6174654D696E6403153O00446F6D696E6174654D696E644D6F7573656F766572030D3O00536861636B6C65556E6465616403163O00536861636B6C65556E646561644D6F7573656F766572030C3O00566F69644572757074696F6E030F3O00432O6F6C646F776E52656D61696E732O033O00474344030B3O004973417661696C61626C65030D3O004461726B417363656E73696F6E030A3O00432O6F6C646F776E5570030B3O00566F6964546F2O72656E74030B3O00507379636869634C696E6B026O00104003083O0042752O66446F776E030C3O00566F6964666F726D42752O6600030F3O009FC4CEC2EFCDCEDCEFE6C0C7A1838803043O00AECFABA103113O00476574456E656D696573496E52616E676503173O00476574456E656D696573496E53706C61736852616E6765026O0024402O033O00414F45031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74030C3O004570696353652O74696E677303073O00546F2O676C657303063O00E9F71EE3FDDB03063O00B78D9E6D939803043O00240CE70003043O006C4C6986030D3O004973446561644F7247686F737403083O0049734D6F76696E6703073O0047657454696D6503063O0050757269667903093O00466F637573556E69742O033O00E4CAB203053O00AE8BA5D1812O033O00A0B7F103083O0018C3D382A1A6631003123O00506F776572576F7264466F72746974756465030A3O0049734361737461626C6503163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E6703183O00506F776572576F7264466F72746974756465506C6179657203143O00560CFE294129510CFB286C104911FD254703420603063O00762663894C3303063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B030C3O00526573752O72656374696F6E030C3O00EF2316071B32F825111B062E03063O00409D4665726903143O0050A7B0E6027FBFA8F1147FAEA8F10449BCB2E71503053O007020C8C783030A3O00536861646F77666F726D030E3O00536861646F77666F726D42752O66030A3O003F585DBCCCBC2423425103073O00424C303CD8A3CB03103O00426F2O73466967687452656D61696E7303063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O6603103O004D696E64466C6179496E73616E69747903083O004D696E64466C6179026O00D03F03113O0054696D6553696E63654C61737443617374026O002E40024O0080B3C540030C3O00466967687452656D61696E73004C032O001227012O00013O002O26012O00AA2O0100020004443O00AA2O012O004D00015O0020D90001000100032O004900010001000200062E2O01004B03013O0004443O004B03010012272O0100013O002O262O01009A2O0100010004443O009A2O012O004D000200013O0020220102000200042O00F000020002000200062901020020000100010004443O002000012O004D000200023O00062E0102002000013O0004443O00200001001227010200013O002O2601020014000100010004443O001400012O004D000300044O00490003000100022O007A000300034O004D000300033O00062E0103002000013O0004443O002000012O004D000300034O0042000300023O0004443O002000010004443O001400012O004D000200013O0020220102000200042O00F000020002000200062901020028000100010004443O002800012O004D000200023O00062E010200992O013O0004443O00992O01001227010200013O002O2601020034000100050004443O003400012O004D000300054O00490003000100022O007A000300034O004D000300033O00062E010300992O013O0004443O00992O012O004D000300034O0042000300023O0004443O00992O01002O2601020093000100010004443O009300012O004D000300064O00490003000100022O007A000300034O004D000300033O00062E0103003E00013O0004443O003E00012O004D000300034O0042000300024O004D000300013O0020220103000300062O00F00003000200020006290103007C000100010004443O007C00012O004D000300013O0020220103000300072O00F00003000200020006290103007C000100010004443O007C0001001227010300013O002O260103005C000100080004443O005C00012O004D00045O00205F0004000400094O000500073O00202O00050005000A00122O0006000B6O000700016O000800086O000900093O00202O00090009000C4O0004000900024O000400036O000400033O00062O0004005B00013O0004443O005B00012O004D000400034O0042000400023O0012270103000D3O002O260103006B0001000D0004443O006B00012O004D00045O00201B00040004000E4O000500073O00202O00050005000F00122O000600106O0004000600024O000400036O000400033O00062O0004007C00013O0004443O007C00012O004D000400034O0042000400023O0004443O007C0001000E3100010049000100030004443O004900012O004D00045O0020960004000400094O000500073O00202O00050005000A00122O0006000B6O000700016O0004000700024O000400036O000400033O00062O0004007A00013O0004443O007A00012O004D000400034O0042000400023O001227010300083O0004443O004900012O004D0003000A3O00062E0103009200013O0004443O00920001001227010300013O002O2601030080000100010004443O008000012O004D00045O0020510004000400114O000500073O00202O0005000500124O000600093O00202O00060006001300122O000700146O0004000700024O000400036O000400033O00062O0004009200013O0004443O009200012O004D000400034O0042000400023O0004443O009200010004443O00800001001227010200083O002O260102002C2O01000D0004443O002C2O012O004D0003000B3O002O26010300C3000100150004443O00C300012O004D000300023O00062E010300C300013O0004443O00C300012O004D0003000C3O0020220103000300162O00F00003000200022O004D0004000D3O00069C000300C3000100040004443O00C300012O004D0003000E4O004D0004000C4O0004010500014O00F5000300050002000629010300C3000100010004443O00C30001001227010300013O002O26010300B3000100010004443O00B300012O004D0004000F4O00490004000100022O007A000400034O004D000400033O00062E010400B200013O0004443O00B200012O004D000400034O0042000400023O001227010300083O002O26010300A8000100080004443O00A800012O004D000400104O004D000500073O0020D90005000500172O00F000040002000200062E010400C500013O0004443O00C500012O004D000400113O0012F9000500183O00122O000600196O000400066O00045O00044O00C500010004443O00A800010004443O00C500012O0004010300014O007A0003000B4O004D000300123O00062E010300D800013O0004443O00D800012O004D000300133O00062E010300D800013O0004443O00D80001001227010300013O002O26010300CC000100010004443O00CC00012O004D000400144O00490004000100022O007A000400034O004D000400033O00062E010400D800013O0004443O00D800012O004D000400034O0042000400023O0004443O00D800010004443O00CC00012O004D000300073O0020D900030003001A00202201030003001B2O00F000030002000200062E010300052O013O0004443O00052O012O004D000300153O00062E010300052O013O0004443O00052O012O004D000300163O00062E010300052O013O0004443O00052O012O004D000300013O0020220103000300062O00F0000300020002000629010300052O0100010004443O00052O012O004D000300013O0020220103000300072O00F0000300020002000629010300052O0100010004443O00052O012O004D00035O0020D900030003001C2O004D0004000C4O00F000030002000200062E010300052O013O0004443O00052O012O004D000300104O001D000400073O00202O00040004001A4O0005000C3O00202O00050005001D4O000700073O00202O00070007001A4O0005000700024O000500056O00030005000200062O000300052O013O0004443O00052O012O004D000300113O0012270104001E3O0012270105001F4O00B6000300054O005800036O004D000300173O000E32000D00102O0100030004443O00102O012O004D000300183O000EDF0005002B2O0100030004443O002B2O012O004D000300013O0020220103000300042O00F000030002000200062E0103002B2O013O0004443O002B2O01001227010300013O002O260103001F2O0100080004443O001F2O012O004D000400104O004D000500073O0020D90005000500172O00F000040002000200062E0104002B2O013O0004443O002B2O012O004D000400113O0012F9000500203O00122O000600216O000400066O00045O00044O002B2O01002O26010300112O0100010004443O00112O012O004D000400194O00490004000100022O007A000400034O004D000400033O00062E010400292O013O0004443O00292O012O004D000400034O0042000400023O001227010300083O0004443O00112O01001227010200053O002O2601020029000100080004443O002900012O004D0003001A3O00062E010300572O013O0004443O00572O01001227010300013O002O26010300442O0100010004443O00442O012O004D00045O00209F0004000400224O000500073O00202O0005000500234O000600093O00202O00060006002400122O0007000B6O000800016O0004000800024O000400036O000400033O00062O000400432O013O0004443O00432O012O004D000400034O0042000400023O001227010300083O002O26010300322O0100080004443O00322O012O004D00045O00209F0004000400224O000500073O00202O0005000500254O000600093O00202O00060006002600122O0007000B6O000800016O0004000800024O000400036O000400033O00062O000400572O013O0004443O00572O012O004D000400034O0042000400023O0004443O00572O010004443O00322O012O000401036O00030003001B6O000300073O00202O00030003002700202O0003000300284O0003000200024O000400013O00202O0004000400294O00040002000200202O00040004000500062O000300692O0100040004443O00692O012O004D000300073O0020D900030003002700202201030003002A2O00F00003000200020006290103008F2O0100010004443O008F2O012O004D000300073O0020D900030003002B00202201030003002C2O00F000030002000200062E010300752O013O0004443O00752O012O004D000300073O0020D900030003002B00202201030003002A2O00F00003000200020006290103008F2O0100010004443O008F2O012O004D000300073O0020D900030003002D00202201030003002A2O00F000030002000200062E0103008F2O013O0004443O008F2O012O004D000300073O0020D900030003002E00202201030003002A2O00F000030002000200062E0103008F2O013O0004443O008F2O012O004D000300073O0020D900030003002D0020220103000300282O00F000030002000200260E0003008D2O01002F0004443O008D2O012O004D000300013O00208E0003000300304O000500073O00202O0005000500314O00030005000200044O008F2O012O001200036O0004010300014O007A0003001C4O004D0003000D3O002O26010300972O0100320004443O00972O012O004D0003000C3O0020220103000300162O00F00003000200022O007A0003000D3O0012270102000D3O0004443O002900010012272O0100083O002O262O010009000100080004443O000900012O004D000200104O004D000300073O0020D90003000300172O00F000020002000200062E0102004B03013O0004443O004B03012O004D000200113O0012F9000300333O00122O000400346O000200046O00025O00044O004B03010004443O000900010004443O004B0301000E31000D00D12O013O0004443O00D12O012O004D000100013O0020D600010001003500122O000300146O0001000300024O0001001D6O0001000C3O00202O00010001003600122O000300376O0001000300024O0001001E3O00122O000100383O00062O000100C72O013O0004443O00C72O010012272O0100013O000E31000100BA2O0100010004443O00BA2O012O004D0002001F4O00D7000200026O000200186O0002000C3O00202O00020002003900122O000400376O0002000400024O000200173O00044O00D02O010004443O00BA2O010004443O00D02O010012272O0100013O002O262O0100C82O0100010004443O00C82O01001227010200084O007A000200183O001227010200084O007A000200173O0004443O00D02O010004443O00C82O01001227012O00053O000E31000800E92O013O0004443O00E92O0100122E0001003A3O0020A900010001003B4O000200113O00122O0003003C3O00122O0004003D6O0002000400024O0001000100024O000100153O00122O0001003A3O00202O00010001003B4O000200113O00122O0003003E3O00122O0004003F6O0002000400024O0001000100024O000100206O000100013O00202O00010001003500122O0003000B6O0001000300024O0001001F3O00124O000D3O002O26012O001E020100050004443O001E02012O004D000100013O0020222O01000100402O00F000010002000200062E2O0100F12O013O0004443O00F12O012O002F3O00014O004D000100013O0020222O01000100412O00F00001000200020006292O0100F92O0100010004443O00F92O0100122E000100424O00490001000100022O007A000100214O004D000100013O0020222O01000100042O00F00001000200020006292O010001020100010004443O000102012O004D000100133O00062E2O01001D02013O0004443O001D02010012272O0100014O0046000200023O002O262O010014020100010004443O001402012O004D000300133O0006F10002000D020100030004443O000D02012O004D000300073O0020D900030003004300202201030003001B2O00F00003000200022O00FD000200034O004D00035O00202D0003000300444O000400026O000500076O0003000700024O000300033O00122O000100083O000E3100080003020100010004443O000302012O004D000300033O00062E0103001D02013O0004443O001D02012O004D000300034O0042000300023O0004443O001D02010004443O00030201001227012O002F3O002O26012O0033020100010004443O003302012O004D000100224O000A2O010001000100122O0001003A3O00202O00010001003B4O000200113O00122O000300453O00122O000400466O0002000400024O0001000100024O000100023O00122O0001003A3O00202O00010001003B4O000200113O00122O000300473O00122O000400486O0002000400024O0001000100024O000100233O00124O00083O002O26012O00010001002F0004443O000100012O004D000100013O0020222O01000100042O00F00001000200020006292O0100E1020100010004443O00E102012O004D000100023O00062E2O0100E102013O0004443O00E102010012272O0100013O002O262O01007A020100010004443O007A02012O004D000200073O0020D900020002004900202201020002004A2O00F000020002000200062E0102006302013O0004443O006302012O004D000200243O00062E0102006302013O0004443O006302012O004D000200013O0020D50002000200304O000400073O00202O00040004004B4O000500016O00020005000200062O00020058020100010004443O005802012O004D00025O00203201020002004C4O000300073O00202O00030003004B4O00020002000200062O0002006302013O0004443O006302012O004D000200104O004D000300093O0020D900030003004D2O00F000020002000200062E0102006302013O0004443O006302012O004D000200113O0012270103004E3O0012270104004F4O00B6000200044O005800026O004D0002000A3O00062E0102007902013O0004443O00790201001227010200013O002O2601020067020100010004443O006702012O004D00035O0020510003000300114O000400073O00202O0004000400124O000500093O00202O00050005001300122O000600146O0003000600024O000300036O000300033O00062O0003007902013O0004443O007902012O004D000300034O0042000300023O0004443O007902010004443O006702010012272O0100083O002O262O0100A20201000D0004443O00A202012O004D0002000C3O00062E010200E102013O0004443O00E102012O004D0002000C3O0020220102000200502O00F000020002000200062E010200E102013O0004443O00E102012O004D0002000C3O0020220102000200512O00F000020002000200062E010200E102013O0004443O00E102012O004D0002000C3O0020220102000200402O00F000020002000200062E010200E102013O0004443O00E102012O004D000200013O0020220102000200522O004D0004000C4O00F5000200040002000629010200E1020100010004443O00E102012O004D000200104O0039000300073O00202O0003000300534O000400046O000500016O00020005000200062O000200E102013O0004443O00E102012O004D000200113O0012F9000300543O00122O000400556O000200046O00025O00044O00E10201002O262O01003E020100080004443O003E02012O004D000200073O0020D900020002004900202201020002004A2O00F000020002000200062E010200C402013O0004443O00C402012O004D000200013O0020D50002000200304O000400073O00202O00040004004B4O000500016O00020005000200062O000200B9020100010004443O00B902012O004D00025O00203201020002004C4O000300073O00202O00030003004B4O00020002000200062O000200C402013O0004443O00C402012O004D000200104O004D000300093O0020D900030003004D2O00F000020002000200062E010200C402013O0004443O00C402012O004D000200113O001227010300563O001227010400574O00B6000200044O005800026O004D000200073O0020D900020002005800202201020002004A2O00F000020002000200062E010200DF02013O0004443O00DF02012O004D000200013O0020E20002000200304O000400073O00202O0004000400594O00020004000200062O000200DF02013O0004443O00DF02012O004D000200253O00062E010200DF02013O0004443O00DF02012O004D000200104O004D000300073O0020D90003000300582O00F000020002000200062E010200DF02013O0004443O00DF02012O004D000200113O0012270103005A3O0012270104005B4O00B6000200044O005800025O0012272O01000D3O0004443O003E02012O004D000100013O0020222O01000100412O00F000010002000200062E2O0100FB02013O0004443O00FB02012O004D000100013O0020222O01000100042O00F00001000200020006292O0100EE020100010004443O00EE02012O004D000100023O00062E2O0100FB02013O0004443O00FB02010012272O0100013O002O262O0100EF020100010004443O00EF02012O004D000200264O00490002000100022O007A000200034O004D000200033O00062E010200FB02013O0004443O00FB02012O004D000200034O0042000200023O0004443O00FB02010004443O00EF02012O004D00015O0020D90001000100032O00490001000100020006292O010005030100010004443O000503012O004D000100013O0020222O01000100042O00F000010002000200062E2O01004903013O0004443O004903010012272O0100013O002O262O010011030100010004443O001103012O004D000200283O00204E00020002005C4O000300036O000400016O0002000400024O000200276O000200276O000200293O00122O000100083O000E3100050027030100010004443O002703012O004D000200013O0020E200020002005D4O000400073O00202O00040004005E4O00020004000200062O0002001E03013O0004443O001E03012O004D000200073O0020D900020002005F00062901020020030100010004443O002003012O004D000200073O0020D90002000200602O007A0002002A4O00DB000200013O00202O0002000200294O00020002000200202O0002000200614O0002002B3O00044O00490301002O262O0100340301000D0004443O003403012O004D0002002D3O0020BF0002000200624O00020002000200102O0002006300024O0002002C6O0002002C3O00262O00020033030100010004443O00330301001227010200014O007A0002002C3O0012272O0100053O002O262O010006030100080004443O000603012O004D000200293O002O260102003F030100640004443O003F03012O004D000200283O00200F0002000200654O0003001E6O00048O0002000400024O000200294O004D0002002D3O0020220102000200622O00F00002000200020026D000020045030100630004443O004503012O001200026O0004010200014O007A0002002E3O0012272O01000D3O0004443O00060301001227012O00023O0004443O000100012O002F3O00017O000B3O00028O00026O00F03F03053O005072696E74031B3O00898E78F750D9648A9470F64CDA64B89F39D64FC727FAA476FC52E503073O0044DAE619933FAE030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03203O009E225248B9BA6A635EBFA839470CA0ED7B0302E4E37A020C94B46A7143B9A00103053O00D6CD4A332C03133O0056616D7069726963546F756368446562752O6603143O00526567697374657241757261547261636B696E67001D3O001227012O00013O002O26012O0012000100020004443O001200012O004D00015O0020060001000100034O000200013O00122O000300043O00122O000400056O000200046O00013O000100122O000100063O00202O0001000100074O000200013O00122O000300083O00122O000400096O000200046O00013O000100044O001C0001000E310001000100013O0004443O000100012O004D000100024O008A0001000100014O000100033O00202O00010001000A00202O00010001000B4O00010002000100124O00023O00044O000100012O002F3O00017O00", GetFEnv(), ...);
