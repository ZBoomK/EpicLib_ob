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
				if (Enum <= 211) then
					if (Enum <= 105) then
						if (Enum <= 52) then
							if (Enum <= 25) then
								if (Enum <= 12) then
									if (Enum <= 5) then
										if (Enum <= 2) then
											if (Enum <= 0) then
												Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
											elseif (Enum > 1) then
												local B;
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
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
										elseif (Enum <= 3) then
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 4) then
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
									elseif (Enum <= 8) then
										if (Enum <= 6) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 7) then
											local A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
									elseif (Enum <= 10) then
										if (Enum > 9) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 18) then
									if (Enum <= 15) then
										if (Enum <= 13) then
											Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
										elseif (Enum > 14) then
											Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
										local A = Inst[2];
										do
											return Unpack(Stk, A, Top);
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
										if (Inst[2] < Stk[Inst[4]]) then
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
								elseif (Enum <= 21) then
									if (Enum <= 19) then
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
									elseif (Enum == 20) then
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
									end
								elseif (Enum <= 23) then
									if (Enum > 22) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 24) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 38) then
								if (Enum <= 31) then
									if (Enum <= 28) then
										if (Enum <= 26) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 27) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 29) then
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									elseif (Enum == 30) then
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
								elseif (Enum <= 34) then
									if (Enum <= 32) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum == 33) then
										local A;
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 36) then
									if (Enum == 35) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
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
								elseif (Enum == 37) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								end
							elseif (Enum <= 45) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									elseif (Enum > 40) then
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
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 43) then
									if (Enum > 42) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 48) then
								if (Enum <= 46) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 47) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 50) then
								if (Enum > 49) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 78) then
							if (Enum <= 65) then
								if (Enum <= 58) then
									if (Enum <= 55) then
										if (Enum <= 53) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
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
										elseif (Enum > 54) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 57) then
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
										do
											return Stk[Inst[2]];
										end
									end
								elseif (Enum <= 61) then
									if (Enum <= 59) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 60) then
										local B;
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
								elseif (Enum <= 63) then
									if (Enum == 62) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
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
								elseif (Enum > 64) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								if (Enum <= 68) then
									if (Enum <= 66) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum <= 74) then
								if (Enum <= 72) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 73) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 76) then
								if (Enum == 75) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 77) then
								local B;
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
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 91) then
							if (Enum <= 84) then
								if (Enum <= 81) then
									if (Enum <= 79) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
									elseif (Enum > 80) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 82) then
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
								elseif (Enum > 83) then
									local B;
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
							elseif (Enum <= 87) then
								if (Enum <= 85) then
									local B;
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
							elseif (Enum <= 89) then
								if (Enum > 88) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 90) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 98) then
							if (Enum <= 94) then
								if (Enum <= 92) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								elseif (Enum > 93) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 96) then
								if (Enum > 95) then
									local B;
									local A;
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 97) then
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
						elseif (Enum <= 101) then
							if (Enum <= 99) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							elseif (Enum > 100) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							end
						elseif (Enum <= 103) then
							if (Enum > 102) then
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
						elseif (Enum > 104) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 158) then
						if (Enum <= 131) then
							if (Enum <= 118) then
								if (Enum <= 111) then
									if (Enum <= 108) then
										if (Enum <= 106) then
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										elseif (Enum == 107) then
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
										else
											local B;
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
									elseif (Enum <= 109) then
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
									elseif (Enum > 110) then
										local Edx;
										local Results, Limit;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 114) then
									if (Enum <= 112) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 113) then
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
										A = Inst[2];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 116) then
									if (Enum > 115) then
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
								elseif (Enum > 117) then
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
							elseif (Enum <= 124) then
								if (Enum <= 121) then
									if (Enum <= 119) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									elseif (Enum > 120) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum <= 122) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 123) then
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
								elseif (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 127) then
								if (Enum <= 125) then
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
								elseif (Enum > 126) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 129) then
								if (Enum == 128) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							else
								local A;
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
						elseif (Enum <= 144) then
							if (Enum <= 137) then
								if (Enum <= 134) then
									if (Enum <= 132) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 133) then
										local B;
										local A;
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 135) then
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
								elseif (Enum > 136) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 140) then
								if (Enum <= 138) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 139) then
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
							elseif (Enum <= 142) then
								if (Enum > 141) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum > 143) then
								local B;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 151) then
							if (Enum <= 147) then
								if (Enum <= 145) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 146) then
									local B;
									local A;
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
									local B;
									local A;
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
							elseif (Enum <= 149) then
								if (Enum > 148) then
									local Edx;
									local Results, Limit;
									local A;
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
							elseif (Enum == 150) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Inst[3] ~= 0;
							end
						elseif (Enum <= 156) then
							if (Enum == 155) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[A] = Stk[A]();
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
						elseif (Enum > 157) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						end
					elseif (Enum <= 184) then
						if (Enum <= 171) then
							if (Enum <= 164) then
								if (Enum <= 161) then
									if (Enum <= 159) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 160) then
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
								elseif (Enum <= 162) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 163) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 167) then
								if (Enum <= 165) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Inst[2] < Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								end
							elseif (Enum <= 169) then
								if (Enum > 168) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum > 170) then
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
							end
						elseif (Enum <= 177) then
							if (Enum <= 174) then
								if (Enum <= 172) then
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
								elseif (Enum > 173) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 175) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							elseif (Enum == 176) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 180) then
							if (Enum <= 178) then
								local B;
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							if (Enum == 181) then
								local B;
								local A;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum == 183) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
					elseif (Enum <= 197) then
						if (Enum <= 190) then
							if (Enum <= 187) then
								if (Enum <= 185) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 186) then
									local Edx;
									local Results, Limit;
									local A;
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
									if (Stk[Inst[2]] < Inst[4]) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 189) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							else
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							end
						elseif (Enum <= 193) then
							if (Enum <= 191) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 192) then
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
								A = Inst[2];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 195) then
							if (Enum > 194) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							else
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum == 196) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Top));
							end
						else
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
						end
					elseif (Enum <= 204) then
						if (Enum <= 200) then
							if (Enum <= 198) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 199) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 202) then
							if (Enum > 201) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 203) then
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 207) then
						if (Enum <= 205) then
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
						elseif (Enum > 206) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 209) then
						if (Enum > 208) then
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
					elseif (Enum == 210) then
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
				elseif (Enum <= 317) then
					if (Enum <= 264) then
						if (Enum <= 237) then
							if (Enum <= 224) then
								if (Enum <= 217) then
									if (Enum <= 214) then
										if (Enum <= 212) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										elseif (Enum > 213) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 215) then
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 216) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 220) then
									if (Enum <= 218) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
									elseif (Enum == 219) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = #Stk[Inst[3]];
									end
								elseif (Enum <= 222) then
									if (Enum == 221) then
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
									end
								elseif (Enum == 223) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									VIP = Inst[3];
								end
							elseif (Enum <= 230) then
								if (Enum <= 227) then
									if (Enum <= 225) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									elseif (Enum > 226) then
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
								elseif (Enum <= 228) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 229) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 232) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 235) then
								if (Enum > 234) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 236) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
							end
						elseif (Enum <= 250) then
							if (Enum <= 243) then
								if (Enum <= 240) then
									if (Enum <= 238) then
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
									elseif (Enum > 239) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 241) then
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
								elseif (Enum == 242) then
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
							elseif (Enum <= 246) then
								if (Enum <= 244) then
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
									Env[Inst[3]] = Stk[Inst[2]];
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
								elseif (Enum > 245) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 248) then
								if (Enum == 247) then
									local B;
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 249) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 257) then
							if (Enum <= 253) then
								if (Enum <= 251) then
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
								elseif (Enum == 252) then
									local B;
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
							elseif (Enum <= 255) then
								if (Enum > 254) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 256) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum > 259) then
								local B;
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
							end
						elseif (Enum <= 262) then
							if (Enum == 261) then
								local B;
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
						elseif (Enum > 263) then
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
							Env[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
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
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 290) then
						if (Enum <= 277) then
							if (Enum <= 270) then
								if (Enum <= 267) then
									if (Enum <= 265) then
										local A = Inst[2];
										local T = Stk[A];
										for Idx = A + 1, Top do
											Insert(T, Stk[Idx]);
										end
									elseif (Enum == 266) then
										local B;
										local A;
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
								elseif (Enum <= 268) then
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 269) then
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
							elseif (Enum <= 273) then
								if (Enum <= 271) then
									local B;
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
								elseif (Enum > 272) then
									Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
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
								end
							elseif (Enum <= 275) then
								if (Enum > 274) then
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
							elseif (Enum == 276) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum <= 283) then
							if (Enum <= 280) then
								if (Enum <= 278) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 281) then
								local Edx;
								local Results;
								local A;
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
							elseif (Enum > 282) then
								local B;
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
						elseif (Enum <= 286) then
							if (Enum <= 284) then
								local B;
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
							elseif (Enum == 285) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 288) then
							if (Enum > 287) then
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
								A = Inst[2];
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
						elseif (Enum > 289) then
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
						end
					elseif (Enum <= 303) then
						if (Enum <= 296) then
							if (Enum <= 293) then
								if (Enum <= 291) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Enum > 292) then
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
							elseif (Enum <= 294) then
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
							elseif (Enum > 295) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 299) then
							if (Enum <= 297) then
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 298) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							else
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							end
						elseif (Enum <= 301) then
							if (Enum > 300) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum > 302) then
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
						elseif (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 310) then
						if (Enum <= 306) then
							if (Enum <= 304) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum == 305) then
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 308) then
							if (Enum > 307) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 309) then
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
								if (Mvm[1] == 397) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
					elseif (Enum <= 313) then
						if (Enum <= 311) then
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
						elseif (Enum == 312) then
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
					elseif (Enum <= 315) then
						if (Enum == 314) then
							if (Inst[2] < Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum == 316) then
						do
							return;
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
				elseif (Enum <= 370) then
					if (Enum <= 343) then
						if (Enum <= 330) then
							if (Enum <= 323) then
								if (Enum <= 320) then
									if (Enum <= 318) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum == 319) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 321) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 322) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 326) then
								if (Enum <= 324) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 325) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 328) then
								if (Enum == 327) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
							elseif (Enum == 329) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 336) then
							if (Enum <= 333) then
								if (Enum <= 331) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 332) then
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
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								end
							elseif (Enum <= 334) then
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
							elseif (Enum > 335) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 339) then
							if (Enum <= 337) then
								if (Inst[2] == Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 341) then
							if (Enum == 340) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum == 342) then
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
						end
					elseif (Enum <= 356) then
						if (Enum <= 349) then
							if (Enum <= 346) then
								if (Enum <= 344) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 345) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							elseif (Enum <= 347) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 348) then
								local A;
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum <= 352) then
							if (Enum <= 350) then
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 351) then
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
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 354) then
							if (Enum > 353) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum > 355) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 363) then
						if (Enum <= 359) then
							if (Enum <= 357) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 358) then
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
						elseif (Enum <= 361) then
							if (Enum == 360) then
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
						elseif (Enum > 362) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						else
							Stk[Inst[2]] = Upvalues[Inst[3]];
						end
					elseif (Enum <= 366) then
						if (Enum <= 364) then
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
						elseif (Enum > 365) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 368) then
						if (Enum == 367) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						end
					elseif (Enum > 369) then
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
					else
						local A = Inst[2];
						local T = Stk[A];
						local B = Inst[3];
						for Idx = 1, B do
							T[Idx] = Stk[A + Idx];
						end
					end
				elseif (Enum <= 396) then
					if (Enum <= 383) then
						if (Enum <= 376) then
							if (Enum <= 373) then
								if (Enum <= 371) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 372) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 374) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 375) then
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 379) then
							if (Enum <= 377) then
								Stk[Inst[2]]();
							elseif (Enum == 378) then
								Env[Inst[3]] = Stk[Inst[2]];
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
						elseif (Enum <= 381) then
							if (Enum == 380) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum == 382) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 389) then
						if (Enum <= 386) then
							if (Enum <= 384) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 385) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 387) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 388) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 392) then
						if (Enum <= 390) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum > 391) then
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
					elseif (Enum <= 394) then
						if (Enum > 393) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						else
							local B;
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
					elseif (Enum > 395) then
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
				elseif (Enum <= 409) then
					if (Enum <= 402) then
						if (Enum <= 399) then
							if (Enum <= 397) then
								Stk[Inst[2]] = Stk[Inst[3]];
							elseif (Enum == 398) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 400) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 401) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							Stk[A] = Stk[A]();
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
						elseif (Inst[2] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 405) then
						if (Enum <= 403) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 404) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 407) then
						if (Enum == 406) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum == 408) then
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
					else
						local A = Inst[2];
						local T = Stk[A];
						for Idx = A + 1, Inst[3] do
							Insert(T, Stk[Idx]);
						end
					end
				elseif (Enum <= 416) then
					if (Enum <= 412) then
						if (Enum <= 410) then
							local B;
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
						elseif (Enum > 411) then
							local B;
							local A;
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
						end
					elseif (Enum <= 414) then
						if (Enum > 413) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum > 415) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 419) then
					if (Enum <= 417) then
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
					elseif (Enum > 418) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 421) then
					if (Enum > 420) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum == 422) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Inst[2] == Inst[4]) then
					VIP = VIP + 1;
				else
					VIP = Inst[3];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503183O00F4D3D23DD996C810DAFCEC2CE8BFD01FDDC8DE37A8B7D21F03083O007EB1A3BB4586DBA703183O0076C23734E8A15CDC3513E0855DD6292DDB8756C07020C28D03063O00EC33B25E4CB7002E3O0012AE3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004E03O000A0001001278010300063O0020D4000400030007001278010500083O0020D4000500050009001278010600083O0020D400060006000A00063501073O000100062O008D012O00064O008D017O008D012O00044O008D012O00014O008D012O00024O008D012O00053O0020D400080003000B0020D400090003000C2O004F010A5O001278010B000D3O000635010C0001000100022O008D012O000A4O008D012O000B4O008D010D00073O001228000E000E3O001228000F000F4O005C000D000F0002000635010E0002000100032O008D012O00074O008D012O00094O008D012O00084O00FB000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O003901025O00122O000300016O00045O00122O000500013O00042O0003002100012O006A01076O00D2000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O006A010C00034O002F000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0013010C6O0007000A3O000200205A010A000A00022O007B0109000A4O002A01073O000100044A0003000500012O006A010300054O008D010400024O0049010300044O001000036O003C012O00017O000D3O00028O00025O00C6AE40025O00349E40026O00F03F025O00E89740025O00B4A040025O00188040025O00406540025O00588D40025O00288C40025O00549940025O003CAE40025O002AA24001463O001228000200014O0074000300043O00260C01020006000100010004E03O00060001002EE800020013000100030004E03O00130001001228000500013O000E510104000B000100050004E03O000B0001001228000200043O0004E03O00130001002E8F00050007000100060004E03O000700010026BF00050007000100010004E03O00070001001228000300014O0074000400043O001228000500043O0004E03O000700010026BF00020002000100040004E03O00020001001228000500013O002EA701073O000100070004E03O001600010026BF00050016000100010004E03O0016000100260C0103001E000100040004E03O001E0001002EE800090022000100080004E03O002200012O008D010600044O002B01076O00C400066O001000065O0026BF00030015000100010004E03O00150001001228000600014O0074000700073O000E512O010026000100060004E03O00260001001228000700013O000E512O010037000100070004E03O003700012O006A01086O0032010400083O0006A30004003100013O0004E03O00310001002E8F000B00360001000A0004E03O003600012O006A010800014O008D01096O002B010A6O00C400086O001000085O001228000700043O002E8F000D00290001000C0004E03O002900010026BF00070029000100040004E03O00290001001228000300043O0004E03O001500010004E03O002900010004E03O001500010004E03O002600010004E03O001500010004E03O001600010004E03O001500010004E03O004500010004E03O000200012O003C012O00017O00723O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F958B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C030A3O009643C5B4336320C4B75A03083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O001CD525843A03043O00E849A14C03053O00706169727303073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903043O00E5212E8B03073O009CA84E40E0D479030A3O0030E7ABCA10EFA9C502FC03043O00AE678EC503043O007B27513303073O009836483F58453E030A3O00E3CDE058C3C5E257D1D603043O003CB4A48E03043O0075510B2203073O0072383E6549478D030A3O008FE0D5C0AFE8D7CFBDFB03043O00A4D889BB03113O00F3EA36B7B2F60AC0D624A8BCF20EF0E92903073O006BB28651D2C69E03023O00494403113O001A0B83C5A5361A8DD2A23D2C87DFA5360A03053O00CA586EE2A603073O00E70583E5DFD60103053O00AAA36FE29703173O003522B33F41392F1822B71A413A2B3539A1284B393A142203073O00497150D2582E5703153O00A43ED802F38822CA21F7842DDF34F5802BC017E99503053O0087E14CAD72030F3O0033FFB1B4A9A8B43CFFB9B7A1B8A90E03073O00C77A8DD8D0CCDD030F3O0080DC1EF97BD1BFD415F66CF9BFDE1803063O0096CDBD709018024O0080B3C54003083O001681AD490A81050903083O007045E4DF2C64E871030B3O004973417661696C61626C65026O00F03F027O004003083O00F81A00E0A17983C403073O00E6B47F67B3D61C03153O00AF044C52A46DE58B456C51E144F0CC4D6C52F14FA903073O0080EC653F268421030B3O009EA01F4399EDFFA9A8124103073O00AFCCC97124D68B03193O0064CD26C84475C53BDB4468CA75EC0146CF309C4C74D820D24D03053O006427AC55BC03093O009D79AB813FB46BB09303053O0053CD18D9E003153O00C5C4DE29A6F5CC2FE7C9D42EEFD68D75D5D1D833AF03043O005D86A5AD028O00030C3O0047657445717569706D656E74026O002A40026O002C4003073O009DFDCCCF35C0A103083O001EDE92A1A25AAED203083O00C0587518FC417E0F03043O006A852E1003073O007B2F7EF1554E4B03063O00203840139C3A03043O0077C7EB5D03073O00E03AA885363A9203103O005265676973746572466F724576656E7403243O00FAA825DC8FF9F0EBA730CC9CEEF0E8BB34D690FDE3F2B130C190F3E1E4A839D497FBEAFF03073O00AFBBEB7195D9BC03143O000C83A075C64B470E8AA669CD465D128EA360C65D03073O00185CCFE12C8319030E3O008EE9056091EA1F6F95F80E6B98FD03043O002CDDB94003143O002DC2696D5D24C3776C4324CB64605A2FD87C7E5103053O00136187283F03183O009E7012020A039179020E060183791D0F1012867D1D1C0A1503063O0051CE3C535B4F03063O0053657441504C025O00D07040003F033O00572O0100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O00130004001300122O001400206O00155O00122O001600213O00122O001700226O0015001700022O00320115000F00152O004400165O00122O001700233O00122O001800246O0016001800024O0015001500164O00165O00122O001700253O00122O001800266O0016001800022O00320115001500162O004400165O00122O001700273O00122O001800286O0016001800024O0016000F00164O00175O00122O001800293O00122O0019002A6O0017001900022O00680116001600174O00175O00122O0018002B3O00122O0019002C6O0017001900024O0016001600172O009900176O009900186O009900196O0099001A6O0099001B6O0074001C00354O004400365O00122O0037002D3O00122O0038002E6O0036003800024O0036000C00364O00375O00122O0038002F3O00122O003900306O0037003900022O00320136003600372O004400375O00122O003800313O00122O003900326O0037003900024O0037000E00374O00385O00122O003900333O00122O003A00346O0038003A00022O00320137003700382O004400385O00122O003900353O00122O003A00366O0038003A00024O0038001100384O00395O00122O003A00373O00122O003B00386O0039003B00022O00030138003800394O003900066O003A5O00122O003B00393O00122O003C003A6O003A003C00024O003A0037003A00202O003A003A003B4O003A000200024O003B5O001228003C003C3O001288003D003D6O003B003D00024O003B0037003B00202O003B003B003B4O003B000200024O003C5O00122O003D003E3O00122O003E003F6O003C003E00024O003C0037003C002014013C003C003B2O0070013C000200024O003D5O00122O003E00403O00122O003F00416O003D003F00024O003D0037003D00202O003D003D003B4O003D000200024O003E5O00122O003F00423O001288004000436O003E004000024O003E0037003E00202O003E003E003B4O003E000200024O003F5O00122O004000443O00122O004100456O003F004100024O003F0037003F002014013F003F003B2O0030013F000200022O00FA00405O00122O004100463O00122O004200476O0040004200024O00400037004000202O00400040003B4O004000416O00393O00012O0074003A003C3O00123E003D00483O00122O003E00486O003F003F6O00408O00418O00428O00438O00448O00456O007000465O00122O004700493O00122O0048004A6O0046004800024O00460036004600202O00460046004B4O00460002000200062O004600D700013O0004E03O00D700010012280046004C3O000682014600D8000100010004E03O00D800010012280046004D4O004F014700034O004F014800034O004400495O00122O004A004E3O00122O004B004F6O0049004B00024O0049003600494O004A5O00122O004B00503O00122O004C00516O004A004C0002000211014B6O00710148000300012O004F014900034O0044004A5O00122O004B00523O00122O004C00536O004A004C00024O004A0036004A4O004B5O00122O004C00543O00122O004D00556O004B004D0002000211014C00014O00710149000300012O004F014A00034O0044004B5O00122O004C00563O00122O004D00576O004B004D00024O004B0036004B4O004C5O00122O004D00583O00122O004E00596O004C004E0002000211014D00024O0071014A000300012O00710147000300012O009900485O0012600049005A3O00202O004A0007005B4O004A0002000200202O004B004A005C00062O004B000A2O013O0004E03O000A2O012O008D014B000E3O0020D4004C004A005C2O0030014B00020002000682014B000D2O0100010004E03O000D2O012O008D014B000E3O001228004C005A4O0030014B000200020020D4004C004A005D0006A3004C00152O013O0004E03O00152O012O008D014C000E3O0020D4004D004A005D2O0030014C00020002000682014C00182O0100010004E03O00182O012O008D014C000E3O001228004D005A4O0030014C000200022O006A014D5O001228004E005E3O001228004F005F4O005C004D004F00022O0032014D000F004D2O0044004E5O00122O004F00603O00122O005000616O004E005000024O004D004D004E4O004E5O00122O004F00623O00122O005000636O004E005000022O0068014E000F004E4O004F5O00122O005000643O00122O005100656O004F005100024O004E004E004F000635014F0003000100032O008D012O004D4O006A017O008D012O00133O00201401500004006600063501520004000100012O008D012O004F4O007500535O00122O005400673O00122O005500686O005300556O00503O000100202O00500004006600063501520005000100032O008D012O003E4O008D012O00494O008D012O003D4O007500535O00122O005400693O00122O0055006A6O005300556O00503O000100202O00500004006600063501520006000100032O008D012O00464O008D012O00364O006A017O00CB00535O00122O0054006B3O00122O0055006C6O0053005500024O00545O00122O0055006D3O00122O0056006E6O005400566O00503O000100202O00500004006600063501520007000100052O008D012O004A4O008D012O00074O008D012O004B4O008D012O000E4O008D012O004C4O002101535O00122O0054006F3O00122O005500706O005300556O00503O000100063501500008000100032O006A012O00014O008D012O00074O006A012O00023O00063501510009000100032O006A012O00014O008D012O00074O006A012O00023O0006350152000A000100012O008D012O00073O0006350153000B000100062O008D012O00144O008D012O003B4O008D012O00364O006A012O00014O006A012O00024O006A016O0006350154000C000100072O006A012O00014O008D012O00154O008D012O00074O008D012O00364O006A012O00024O006A017O008D012O00533O0006350155000D000100042O008D012O00364O006A017O008D012O00534O008D012O003C3O0006350156000E000100072O008D012O00144O008D012O003A4O008D012O00364O006A017O008D012O00074O008D012O00134O008D012O00083O0006350157000F000100042O008D012O00144O008D012O003B4O008D012O00134O006A016O00063501580010000100012O008D012O00363O00063501590011000100042O006A012O00014O008D012O00364O008D012O00154O006A012O00023O000635015A0012000100052O006A012O00014O008D012O00364O008D012O00154O008D012O00084O006A012O00023O000635015B0013000100032O008D012O00364O008D012O00154O008D012O00553O000635015C0014000100012O008D012O00363O000211015D00153O000635015E0016000100012O008D012O00363O000635015F0017000100012O008D012O00363O00063501600018000100022O008D012O00364O008D012O00073O00063501610019000100012O008D012O00363O0006350162001A000100092O008D012O00364O006A017O008D012O00124O008D012O00084O008D012O00104O008D012O001A4O008D012O00354O008D012O00384O008D012O00073O0006350163001B000100132O008D012O00364O006A017O008D012O002E4O008D012O00074O008D012O002F4O008D012O00124O008D012O00304O008D012O00314O008D012O002C4O008D012O002D4O008D012O00324O008D012O00334O008D012O00374O008D012O00244O008D012O00254O008D012O00384O008D012O00214O008D012O00234O008D012O00223O0006350164001C000100102O006A017O008D012O00374O008D012O004B4O008D012O004C4O008D012O00124O008D012O00384O008D012O00084O008D012O00464O008D012O00074O008D012O00364O008D012O003F4O008D012O003E4O008D012O001D4O008D012O004D4O008D012O00394O008D012O001A3O0006350165001D000100092O008D012O00364O006A017O008D012O00084O008D012O00104O008D012O00074O008D012O00124O008D012O001A4O008D012O00354O008D012O00383O0006350166001E000100102O008D012O00364O006A017O008D012O003C4O008D012O004D4O008D012O003A4O008D012O005E4O008D012O00084O008D012O00554O008D012O00074O008D012O00344O008D012O00124O008D012O00384O008D012O000A4O008D012O00524O008D012O005B4O008D012O00593O0006350167001F0001001A2O008D012O00364O006A017O008D012O00084O008D012O003E4O008D012O003C4O008D012O00074O008D012O00104O008D012O00554O008D012O003F4O008D012O00354O008D012O00124O008D012O00384O008D012O00414O008D012O002B4O008D012O00524O008D012O004D4O008D012O001C4O008D012O00114O008D012O00184O008D012O00194O008D012O00564O008D012O002A4O008D012O00544O008D012O00344O008D012O000A4O008D012O00663O00063501680020000100162O008D012O00364O006A017O008D012O00084O008D012O003E4O008D012O003C4O008D012O00074O008D012O00104O008D012O00344O008D012O00124O008D012O00384O008D012O000A4O008D012O00414O008D012O002B4O008D012O00184O008D012O00194O008D012O00564O008D012O00524O008D012O004D4O008D012O001C4O008D012O00114O008D012O00354O008D012O002A3O000635016900210001000D2O008D012O00364O006A017O008D012O00084O008D012O00104O008D012O00074O008D012O004D4O008D012O003B4O008D012O005E4O008D012O003A4O008D012O00524O008D012O005B4O008D012O00124O008D012O00383O000635016A0022000100112O008D012O00364O006A017O008D012O003C4O008D012O00524O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00084O008D012O005E4O008D012O00104O008D012O00074O008D012O00554O008D012O005A4O008D012O00604O008D012O003B4O008D012O00124O008D012O00383O000635016B00230001000F2O008D012O00364O006A017O008D012O00074O008D012O00104O008D012O00084O008D012O00524O008D012O004D4O008D012O003A4O008D012O005B4O008D012O005E4O008D012O005A4O008D012O00604O008D012O00124O008D012O00384O008D012O00553O000635016C0024000100112O008D012O00364O006A017O008D012O00074O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00084O008D012O00524O008D012O00104O008D012O005E4O008D012O00604O008D012O005A4O008D012O00124O008D012O00384O008D012O00614O008D012O003B4O008D012O00553O000635016D0025000100102O008D012O00364O006A017O008D012O00524O008D012O00074O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00084O008D012O00104O008D012O005A4O008D012O005E4O008D012O003B4O008D012O00124O008D012O00384O008D012O00614O008D012O00603O000635016E0026000100082O008D012O00364O006A017O008D012O00084O008D012O00104O008D012O00524O008D012O00074O008D012O00124O008D012O00383O000635016F00270001000D2O008D012O00364O006A017O008D012O00074O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00084O008D012O003C4O008D012O00104O008D012O00524O008D012O00554O008D012O005E4O008D012O00123O000635017000280001000C2O008D012O00364O006A017O008D012O00524O008D012O00074O008D012O00104O008D012O00084O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00124O008D012O00554O008D012O005E3O000635017100290001000E2O008D012O00364O006A017O008D012O00074O008D012O00104O008D012O00084O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00524O008D012O00124O008D012O003E4O008D012O005E4O008D012O003B4O008D012O00553O0006350172002A0001000E2O008D012O00364O006A017O008D012O004D4O008D012O003A4O008D012O00584O008D012O00084O008D012O00524O008D012O005B4O008D012O00104O008D012O00074O008D012O005E4O008D012O003E4O008D012O00124O008D012O00543O0006350173002B000100092O008D012O00364O006A017O008D012O00074O008D012O00084O008D012O00104O008D012O00124O008D012O003E4O008D012O00524O008D012O00543O0006350174002C000100112O008D012O00364O006A017O008D012O00074O008D012O00104O008D012O00084O008D012O00524O008D012O003C4O008D012O004D4O008D012O003A4O008D012O005B4O008D012O00504O008D012O003E4O006A012O00014O008D012O00154O006A012O00024O008D012O00594O008D012O00123O0006350175002D000100112O008D012O00364O006A017O008D012O00104O008D012O00084O008D012O00524O008D012O00074O008D012O003C4O008D012O00574O008D012O00124O008D012O00194O008D012O004D4O008D012O001C4O008D012O00114O008D012O003A4O008D012O00584O008D012O00554O008D012O00543O0006350176002E0001001B2O008D012O00224O006A017O008D012O00204O008D012O00214O008D012O001F4O008D012O001D4O008D012O001E4O008D012O00354O008D012O001C4O008D012O00264O008D012O00274O008D012O00284O008D012O00294O008D012O002A4O008D012O002B4O008D012O002C4O008D012O002D4O008D012O002E4O008D012O00234O008D012O00244O008D012O00254O008D012O00344O008D012O00324O008D012O00334O008D012O002F4O008D012O00304O008D012O00313O0006350177002F000100352O008D012O00074O008D012O00264O008D012O00364O006A017O008D012O001B4O008D012O004D4O008D012O00174O008D012O00624O008D012O00744O008D012O00414O008D012O003E4O008D012O00424O008D012O00084O008D012O003F4O008D012O00284O008D012O00384O008D012O00294O008D012O000A4O008D012O00094O008D012O00124O008D012O00524O008D012O003B4O008D012O005C4O008D012O005F4O006A012O00014O008D012O00154O006A012O00024O008D012O00044O008D012O003A4O008D012O00594O008D012O003C4O008D012O00724O008D012O00734O008D012O00704O008D012O00714O008D012O006D4O008D012O006E4O008D012O006B4O008D012O006C4O008D012O00694O008D012O006A4O008D012O006F4O008D012O001A4O008D012O00674O008D012O00684O008D012O00634O008D012O00654O008D012O00644O008D012O00104O008D012O00184O008D012O00194O008D012O00764O008D012O003D3O00063501780030000100032O006A017O008D012O004F4O008D012O000F3O0020D10079000F007100122O007A00726O007B00776O007C00786O0079007C00016O00013O00318O00034O00993O00014O003A3O00024O003C012O00019O003O00034O00993O00014O003A3O00024O003C012O00019O003O00034O00993O00014O003A3O00024O003C012O00017O00053O0003123O007D5F58ED708A8B0A5B5A4ED97084920D5F4503083O006B39362B9D15E6E7030A3O004D657267655461626C6503183O0044697370652O6C61626C65506F69736F6E446562752O667303193O0044697370652O6C61626C6544697365617365446562752O6673000E4O001E9O00000100013O00122O000200013O00122O000300026O0001000300024O000200023O00202O0002000200034O00035O00202O0003000300044O00045O0020D40004000400052O005C0002000400022O00273O000100022O003C012O00019O003O00034O006A017O0079012O000100012O003C012O00017O000A3O00028O00025O00708B40025O0049B040026O00F03F025O008AA640025O00E0AA40024O0080B3C540025O00406E40025O0080AF40025O00508E40002E3O0012283O00014O0074000100023O00260C012O0006000100010004E03O00060001002E8F00030009000100020004E03O00090001001228000100014O0074000200023O0012283O00043O00260C012O000D000100040004E03O000D0001002EA7010500F7FF2O00060004E03O000200010026BF0001000D000100010004E03O000D0001001228000200013O0026BF00020015000100040004E03O00150001001228000300074O006501035O0004E03O002D00010026BF00020010000100010004E03O00100001001228000300013O00260C0103001C000100010004E03O001C0001002EA701080007000100090004E03O00210001001228000400014O0065010400013O001228000400074O0065010400023O001228000300043O002EA7010A00F7FF2O000A0004E03O001800010026BF00030018000100040004E03O00180001001228000200043O0004E03O001000010004E03O001800010004E03O001000010004E03O002D00010004E03O000D00010004E03O002D00010004E03O000200012O003C012O00017O00053O0003083O0078D6AA4915745FCA03063O001D2BB3D82C7B030B3O004973417661696C61626C65026O00F03F027O004000104O006A012O00014O0070000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000D00013O0004E03O000D00010012283O00043O000682012O000E000100010004E03O000E00010012283O00054O0065017O003C012O00017O00073O00028O00025O0006AD40025O00F4A940030C3O0047657445717569706D656E74026O002A40026O00F03F026O002C4000393O0012283O00014O0074000100013O000E512O01000200013O0004E03O00020001001228000100013O00260C2O010009000100010004E03O00090001002EE800020024000100030004E03O00240001001228000200013O0026BF0002001F000100010004E03O001F00012O006A010300013O0020130003000300044O0003000200024O00038O00035O00202O00030003000500062O0003001A00013O0004E03O001A00012O006A010300034O006A01045O0020D40004000400052O00300103000200020006820103001D000100010004E03O001D00012O006A010300033O001228000400014O00300103000200022O0065010300023O001228000200063O0026BF0002000A000100060004E03O000A0001001228000100063O0004E03O002400010004E03O000A00010026BF00010005000100060004E03O000500012O006A01025O0020D40002000200070006A30002003000013O0004E03O003000012O006A010200034O006A01035O0020D40003000300072O003001020002000200068201020033000100010004E03O003300012O006A010200033O001228000300014O00300102000200022O0065010200043O0004E03O003800010004E03O000500010004E03O003800010004E03O000200012O003C012O00017O00053O0003043O006D61746803053O00666C2O6F7203183O00456E6572677954696D65546F4D6178507265646963746564026O002440026O00E03F00153O0012903O00013O00206O00024O00018O000200013O00202O0002000200034O00020002000200202O00020002000400122O000300056O0001000300024O000200024O006A010300013O0020960003000300034O00030002000200202O00030003000400122O000400056O0002000400024O0001000100026O0002000200206O00046O00028O00017O00043O0003043O006D61746803053O00666C2O6F72030F3O00456E65726779507265646963746564026O00E03F00123O001205012O00013O00206O00024O00018O000200013O00202O0002000200034O00020002000200122O000300046O0001000300024O000200026O000300013O0020140103000300032O008200030002000200122O000400046O0002000400024O0001000100026O00019O008O00017O00023O0003073O0050726576474344026O00F03F01084O00862O015O00202O00010001000100122O000300026O00048O0001000400024O000100016O000100028O00017O000D3O00028O00025O00E07A40025O001AA640026O00F03F03083O00446562752O66557003143O004D61726B6F667468654372616E65446562752O66025O00688440025O00089140025O00508640025O00CAA140030E3O0063AAC27920C559AC4B88C27321C603083O00C42ECBB0124FA32D030B3O004973417661696C61626C65004E3O0012283O00014O0074000100023O002EE800020009000100030004E03O000900010026BF3O0009000100010004E03O00090001001228000100014O0074000200023O0012283O00043O000E510104000200013O0004E03O00020001001228000300013O0026BF0003000C000100010004E03O000C00010026BF00010028000100040004E03O002800012O006A01046O006A010500014O00FF0004000200060004E03O002500010020140109000800052O006A010B00023O0020D4000B000B00062O005C0009000B00020006820109001C000100010004E03O001C0001002E8F00080025000100070004E03O002500012O006A010900034O0052000A00023O00122O000B00046O0009000B00024O000A00046O000B00023O00122O000C00046O000A000C00024O00020009000A0006CA00040014000100020004E03O001400012O003A000200023O0026BF0001000B000100010004E03O000B0001001228000400014O0074000500053O0026BF0004002C000100010004E03O002C0001001228000500013O00260C01050033000100010004E03O00330001002E8F000A0041000100090004E03O004100012O006A010600024O00A4000700053O00122O0008000B3O00122O0009000C6O0007000900024O00060006000700202O00060006000D4O00060002000200062O0006003F000100010004E03O003F0001001228000600014O003A000600023O001228000200013O001228000500043O000E510104002F000100050004E03O002F0001001228000100043O0004E03O000B00010004E03O002F00010004E03O000B00010004E03O002C00010004E03O000B00010004E03O000C00010004E03O000B00010004E03O004D00010004E03O000200012O003C012O00017O00193O00028O00026O000840026O00F03F03063O0042752O665570031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O66026O33D33F03083O00045924CCF811E33603073O0086423857B8BE74030A3O0054616C656E7452616E6B029A5O99A93F026O001040027O0040025O00588440025O0035B340025O00B0AC40025O00606340030B3O0089DA0CC5C095D8F3BECD1503083O0081CAA86DABA5C3B7029A5O99B93F025O00249940025O00B88640030E3O0095236C152BFDFBB0275D0C25F5EA03073O008FD8421E7E449B030B3O004973417661696C61626C65020AD7A3703D0AC73F00833O0012283O00014O0074000100033O0026BF3O0037000100020004E03O003700012O006A01045O0012CC000500036O000600016O000700023O00202O0007000700044O000900033O00202O0009000900054O000700096O00063O000200102O0006000600064O0004000600022O006A010500043O0012CC000600036O000700016O000800023O00202O0008000800044O000A00033O00202O000A000A00054O0008000A6O00073O000200102O0007000600074O0005000700022O00260004000400052O00B50002000200044O00045O00122O000500036O000600036O000700053O00122O000800073O00122O000900086O0007000900024O00060006000700202O0006000600092O00300106000200020010A00006000A00064O0004000600024O000500043O00122O000600036O000700036O000800053O00122O000900073O00122O000A00086O0008000A00024O0007000700080020140107000700092O007700070002000200102O0007000A00074O0005000700024O0004000400054O00020002000400124O000B3O00260C012O003B0001000C0004E03O003B0001002E8F000E00650001000D0004E03O00650001002EE8001000400001000F0004E03O004000010026292O010040000100010004E03O004000010004E03O004A00012O006A01045O00125C010500036O0006000100034O0004000600024O000500043O00122O000600036O0007000100034O0005000700024O0004000400054O0002000200042O006A01045O0012E5000500036O000600036O000700053O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600094O00060002000200102O0006001300062O005C0004000600022O00DE000500043O00122O000600036O000700036O000800053O00122O000900113O00122O000A00126O0008000A00024O00070007000800202O0007000700094O00070002000200104C0107001300072O005C0005000700022O00260004000400052O00640002000200040012283O00023O00260C012O0069000100010004E03O00690001002E8F00140079000100150004E03O007900012O006A010400034O00A4000500053O00122O000600163O00122O000700176O0005000700024O00040004000500202O0004000400184O00040002000200062O00040075000100010004E03O00750001001228000400014O003A000400024O006A010400064O00B10004000100022O008D2O0100043O0012283O00033O0026BF3O007C0001000B0004E03O007C00012O003A000200023O0026BF3O0002000100030004E03O00020001001228000200033O001228000300193O0012283O000C3O0004E03O000200012O003C012O00017O00153O00028O00026O007340025O00806240026O00F03F025O006CA840025O000FB340025O00606740025O00D08740025O00FC9B40025O00CEAD40025O00806940025O00F07640025O000C9E40030E3O0011301BB016ED353D39121BBA17EE03083O00555C5169DB798B41030B3O004973417661696C61626C65026O00A740025O00BEAC40026O001440025O0036AF40025O0018884000673O0012283O00014O0074000100033O00260C012O0006000100010004E03O00060001002E8F00020009000100030004E03O00090001001228000100014O0074000200023O0012283O00043O0026BF3O0002000100040004E03O000200012O0074000300033O00260C2O010010000100010004E03O00100001002E8F00060013000100050004E03O00130001001228000200014O0074000300033O001228000100043O0026BF0001000C000100040004E03O000C0001001228000400013O00260C0104001A000100010004E03O001A0001002E8F00080016000100070004E03O00160001002EA701090030000100090004E03O004A00010026BF0002004A000100010004E03O004A0001001228000500014O0074000600063O00260C01050024000100010004E03O00240001002EE8000A00200001000B0004E03O00200001001228000600013O0026BF00060041000100010004E03O00410001001228000700013O002E8F000C002E0001000D0004E03O002E00010026BF0007002E000100040004E03O002E0001001228000600043O0004E03O004100010026BF00070028000100010004E03O002800012O006A01086O00A4000900013O00122O000A000E3O00122O000B000F6O0009000B00024O00080008000900202O0008000800104O00080002000200062O0008003C000100010004E03O003C00012O0099000800014O003A000800024O006A010800024O00B10008000100022O008D010300083O001228000700043O0004E03O00280001002EE800110025000100120004E03O002500010026BF00060025000100040004E03O00250001001228000200043O0004E03O004A00010004E03O002500010004E03O004A00010004E03O002000010026BF00020015000100040004E03O00150001001228000500013O0026BF0005004D000100010004E03O004D0001001228000600013O0026BF00060050000100010004E03O005000012O006A010700033O00068C01070059000100030004E03O00590001000E7C00130059000100030004E03O00590001002E8F0014005B000100150004E03O005B00012O0099000700014O003A000700024O009900076O003A000700023O0004E03O005000010004E03O004D00010004E03O001500010004E03O001600010004E03O001500010004E03O006600010004E03O000C00010004E03O006600010004E03O000200012O003C012O00017O00293O00028O00025O00049540025O001C9E40026O00F03F025O00406F40025O002AA640025O008CAF40025O00A0AF40027O0040025O00849040025O0012A44003133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564030F3O00412O66656374696E67436F6D62617403073O00497344752O6D79030F3O00F612E42835CA1CFC133CFB1AF5083203053O005ABF7F947C030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765026O002E4003063O004865616C7468030B3O00436F6D70617265546869732O033O0075863603043O007718E74E025O00607E40025O001AA040025O009C9B40025O006DB040025O00F4AE40030C3O00B622B049D44F17A628A45ED403073O0071E24DC52ABC2003073O0049735265616479025O00A4B240025O00C4A340030C3O00C9BC454674D0FB97554468D703063O00BF9DD330251C030A3O00432O6F6C646F776E557003063O0042752O665570031F3O0048692O64656E4D617374657273466F7262692O64656E546F75636842752O66025O003EAC40025O0070AE4000BC3O0012283O00014O0074000100033O002EE8000200AB000100030004E03O00AB00010026BF3O00AB000100040004E03O00AB00012O0074000300033O001228000400013O0026BF000400A2000100010004E03O00A20001000E5101040076000100010004E03O00760001001228000500014O0074000600063O002EE80005000E000100060004E03O000E00010026BF0005000E000100010004E03O000E0001001228000600013O000E9101040017000100060004E03O00170001002EA701070004000100080004E03O00190001001228000100093O0004E03O00760001002E8F000A00130001000B0004E03O00130001000E512O010013000100060004E03O001300012O006A01076O006A010800014O00FF0007000200090004E03O005B0001002014010C000B000C2O0030010C00020002000682010C0054000100010004E03O00540001002014010C000B000D2O0030010C00020002000682010C0054000100010004E03O00540001002014010C000B000E2O0030010C00020002000682010C0031000100010004E03O00310001002014010C000B000F2O0030010C000200020006A3000C005400013O0004E03O005400012O006A010C00024O0070000D00033O00122O000E00103O00122O000F00116O000D000F00024O000C000C000D00202O000C000C00124O000C0002000200062O000C003F00013O0004E03O003F0001002014010C000B00132O0030010C00020002002631010C0046000100140004E03O00460001002014010C000B00152O0061000C000200024O000D00043O00202O000D000D00154O000D0002000200062O000C00540001000D0004E03O005400010006A30003005600013O0004E03O005600012O006A010C00053O002O20010C000C00164O000D00033O00122O000E00173O00122O000F00186O000D000F000200202O000E000B00154O000E000200024O000F00036O000C000F000200062O000C0056000100010004E03O00560001002EA7011900070001001A0004E03O005B00012O008D010C000B3O002014010D000B00152O0030010D000200022O008D0103000D4O008D0102000C3O0006CA00070021000100020004E03O002100010006A30002006200013O0004E03O006200012O006A010700063O00068C01020064000100070004E03O00640001002EE8001C00720001001B0004E03O00720001002EA7011D000E0001001D0004E03O007200012O006A010700024O00A4000800033O00122O0009001E3O00122O000A001F6O0008000A00024O00070007000800202O0007000700204O00070002000200062O00070072000100010004E03O007200012O0074000700074O003A000700023O001228000600043O0004E03O001300010004E03O007600010004E03O000E0001000E512O0100A1000100010004E03O00A10001001228000500013O0026BF0005009C000100010004E03O009C0001001228000600013O002E8F00220082000100210004E03O008200010026BF00060082000100040004E03O00820001001228000500043O0004E03O009C00010026BF0006007C000100010004E03O007C00012O006A010700024O00A4000800033O00122O000900233O00122O000A00246O0008000A00024O00070007000800202O0007000700254O00070002000200062O00070097000100010004E03O009700012O006A010700043O00208F0107000700264O000900023O00202O0009000900274O00070009000200062O00070097000100010004E03O009700012O0074000700074O003A000700024O0074000700074O0074000300034O008D010200073O001228000600043O0004E03O007C0001000E5101040079000100050004E03O00790001001228000100043O0004E03O00A100010004E03O00790001001228000400043O000E5101040008000100040004E03O000800010026BF00010007000100090004E03O000700012O003A000200023O0004E03O000700010004E03O000800010004E03O000700010004E03O00BB00010026BF3O0002000100010004E03O00020001001228000400013O002E8F002800B4000100290004E03O00B400010026BF000400B4000100040004E03O00B400010012283O00043O0004E03O000200010026BF000400AE000100010004E03O00AE0001001228000100014O0074000200023O001228000400043O0004E03O00AE00010004E03O000200012O003C012O00017O00133O00028O00025O00DC9040025O00709840026O00F03F027O0040025O00BC9D40025O0014B140025O0028B340025O00FAB240025O000CA940025O0008B34003133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564030F3O00412O66656374696E67436F6D62617403073O00497344752O6D79030B3O00436F6D70617265546869732O033O003717EC03043O00D55A769403093O0054696D65546F446965006A3O0012283O00014O0074000100043O002EE800020009000100030004E03O000900010026BF3O0009000100010004E03O00090001001228000100014O0074000200023O0012283O00043O000E510104000D00013O0004E03O000D00012O0074000300043O0012283O00053O002EE800060002000100070004E03O00020001000E510105000200013O0004E03O000200010026BF0001001E000100010004E03O001E0001001228000500013O0026BF00050018000100040004E03O00180001001228000100043O0004E03O001E0001000E512O010014000100050004E03O00140001001228000200014O0074000300033O001228000500043O0004E03O001400010026BF00010011000100040004E03O001100012O0074000400043O001228000500013O00260C01050026000100010004E03O00260001002EE800080022000100090004E03O002200010026BF00020029000100040004E03O002900012O003A000300023O0026BF00020021000100010004E03O00210001001228000600013O002EE8000A00320001000B0004E03O003200010026BF00060032000100040004E03O00320001001228000200043O0004E03O002100010026BF0006002C000100010004E03O002C00012O0074000700074O0019010400046O000300076O00078O000800016O00070002000900044O005E0001002014010C000B000C2O0030010C00020002000682010C005E000100010004E03O005E0001002014010C000B000D2O0030010C00020002000682010C005E000100010004E03O005E0001002014010C000B000E2O0030010C00020002000682010C004B000100010004E03O004B0001002014010C000B000F2O0030010C000200020006A3000C005E00013O0004E03O005E00010006A30004005900013O0004E03O005900012O006A010C00023O002072000C000C00104O000D00033O00122O000E00113O00122O000F00126O000D000F000200202O000E000B00134O000E000200024O000F00046O000C000F000200062O000C005E00013O0004E03O005E00012O008D010C000B3O002014010D000B00132O0030010D000200022O008D0104000D4O008D0103000C3O0006CA0007003B000100020004E03O003B0001001228000600043O0004E03O002C00010004E03O002100010004E03O002200010004E03O002100010004E03O006900010004E03O001100010004E03O006900010004E03O000200012O003C012O00017O00023O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O6601063O00201B00013O00014O00035O00202O0003000300024O000100036O00019O0000017O00053O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O6603083O00446562752O66557003183O00536B79726561636845786861757374696F6E446562752O66026O003440011D4O004F00015O00202O00023O00014O000400013O00202O0004000400024O0002000400024O000300023O00202O00043O00034O000600013O00202O0006000600044O000400064O000700033O00020020780003000300054O0001000300024O000200033O00202O00033O00014O000500013O00202O0005000500024O0003000500024O000400023O00202O00053O00034O000700013O0020D40007000700042O0095000500076O00043O000200202O0004000400054O0002000400024O0001000100024O000100028O00017O00053O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O66030A3O00446562752O66446F776E03183O00536B79726561636845786861757374696F6E446562752O66026O003440011F4O002F2O015O00202O00023O00014O000400013O00202O0004000400024O0002000400024O000300026O000400033O00202O0004000400034O000600013O00202O0006000600042O0023010400064O003100033O000200202O0003000300054O0001000300024O000200043O00202O00033O00014O000500013O00202O0005000500024O0003000500024O000400026O000500033O0020140105000500032O00BB000700013O00202O0007000700044O000500076O00043O000200202O0004000400054O0002000400024O0001000100024O000100028O00017O00053O00030D3O00446562752O6652656D61696E7303143O004D61726B6F667468654372616E65446562752O6603093O0054696D65546F44696503123O00536B79726561636843726974446562752O66026O00344001143O0020DA00013O00014O00035O00202O0003000300024O0001000300024O000200016O000300026O000300016O00023O000200202O00033O00034O00030002000200201401043O00012O004801065O00202O0006000600044O00040006000200202O0004000400054O0003000300044O0002000200034O0001000100024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O6601063O00201B00013O00014O00035O00202O0003000300024O000100036O00019O0000017O00013O0003093O0054696D65546F44696501043O0020142O013O00012O00492O0100024O001000016O003C012O00017O00023O00030D3O00446562752O6652656D61696E7303123O00536B79726561636843726974446562752O6601063O00201B00013O00014O00035O00202O0003000300024O000100036O00019O0000017O00023O00030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O6601063O00201B00013O00014O00035O00202O0003000300024O000100036O00019O0000017O00043O00030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66030B3O0042752O6652656D61696E7303133O0043612O6C746F446F6D696E616E636542752O66010F3O00205B2O013O00014O00035O00202O0003000300024O0001000300024O000200013O00202O0002000200034O00045O00202O0004000400044O00020004000200062O0002000C000100010004E03O000C00012O004700016O0099000100014O003A000100024O003C012O00017O00033O00030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66025O00804B40010A3O0020732O013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004E03O000700012O004700016O0099000100014O003A000100024O003C012O00017O003C3O00028O00026O00F03F025O00CC9C40025O00D49440025O00E07F4003083O0051497EA7EB99615503063O00EB122117E59E03073O0049735265616479030C3O0076BBC4B759B4C48844B5CCAB03043O00DB30DAA1030B3O004973417661696C61626C65025O00B09640025O00588F4003083O00436869427572737403093O004973496E52616E6765026O00444003153O00E7797576D95AF2F7653C59C94AE3EB7C7E48CF0FB603073O008084111C29BB2F03073O00223A0F0D5C173703053O003D6152665A026O008A4003073O004368695761766503143O00AF26A274D056080CEC3EB94EC458130BAD3AEB1303083O0069CC4ECB2BA7377E025O00349B40026O00794003163O00683BB95B425519BC5F595E1ABD5148491DA057594E2B03053O002D3B4ED436030A3O0049734361737461626C65025O00588740025O00FEAC40025O00C8B14003063O00205A8292833C03083O00907036E3EBE64ECD025O0016AD40025O00C06D40031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572030E3O004973496E4D656C2O6552616E6765026O00144003253O00A03D02F1DF558C3F07F5C45E8C3C06FBD5498C3B1BFDC44EB6681FEED558BC250DFDC41BE103063O003BD3486F9CB003063O006D92F13E419503043O004D2EE783031C3O0053752O6D6F6E57686974655469676572537461747565437572736F7203253O00A941BB4DB55A8957B25DA2458540BF47BF468953AE55A255BF14A652BF57B94DB855A200E803043O0020DA34D603093O006B0F21ADFD9844484303083O003A2E7751C891D0252O033O0043686903063O004368694D6178025O003AB240025O00F0784003093O00457870656C4861726D026O00204003163O002E9420A9A5823E2A9E3DECB9AF3328833DAEA8A9767F03073O00564BEC50CCC9DD025O00D0A640025O0088A440025O00A06E40025O00949F4000D13O0012283O00014O0074000100023O0026BF3O00C8000100020004E03O00C80001002EA701033O000100030004E03O000400010026BF00010004000100010004E03O00040001001228000200013O0026BF00020052000100020004E03O00520001002E8F00050034000100040004E03O003400012O006A01036O0070000400013O00122O000500063O00122O000600076O0004000600024O00030003000400202O0003000300084O00030002000200062O0003003400013O0004E03O003400012O006A01036O00A4000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O00030034000100010004E03O00340001002E8F000D00340001000C0004E03O003400012O006A010300024O00D300045O00202O00040004000E4O000500033O00202O00050005000F00122O000700106O0005000700024O000500056O000600016O00030006000200062O0003003400013O0004E03O003400012O006A010300013O001228000400113O001228000500124O0049010300054O001000036O006A01036O0070000400013O00122O000500133O00122O000600146O0004000600024O00030003000400202O0003000300084O00030002000200062O000300D000013O0004E03O00D00001002EA701150092000100150004E03O00D000012O006A010300044O001C01045O00202O0004000400164O000500066O000700033O00202O00070007000F00122O000900106O0007000900024O000700076O00030007000200062O000300D000013O0004E03O00D000012O006A010300013O00121F010400173O00122O000500186O000300056O00035O00044O00D000010026BF00020009000100010004E03O00090001001228000300013O002E8F001A00BD000100190004E03O00BD00010026BF000300BD000100010004E03O00BD00012O006A01046O0070000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004006600013O0004E03O006600012O006A010400053O00068201040068000100010004E03O00680001002EA7011E00310001001F0004E03O00970001002EA70120001C000100200004E03O008400012O006A010400064O000C000500013O00122O000600213O00122O000700226O00050007000200062O00040084000100050004E03O00840001002E8F00240097000100230004E03O009700012O006A010400024O0056000500073O00202O0005000500254O000600033O00202O00060006002600122O000800276O0006000800024O000600066O00040006000200062O0004009700013O0004E03O009700012O006A010400013O00121F010500283O00122O000600296O000400066O00045O00044O009700012O006A010400064O0047010500013O00122O0006002A3O00122O0007002B6O00050007000200062O0004008C000100050004E03O008C00010004E03O009700012O006A010400024O006A010500073O0020D400050005002C2O00300104000200020006A30004009700013O0004E03O009700012O006A010400013O0012280005002D3O0012280006002E4O0049010400064O001000046O006A01046O0070000500013O00122O0006002F3O00122O000700306O0005000700024O00040004000500202O0004000400084O00040002000200062O000400A900013O0004E03O00A900012O006A010400083O00201A0104000400314O0004000200024O000500083O00202O0005000500324O00050002000200062O000400AB000100050004E03O00AB0001002E8F003300BC000100340004E03O00BC00012O006A010400044O001C01055O00202O0005000500354O000600076O000800033O00202O00080008002600122O000A00366O0008000A00024O000800086O00040008000200062O000400BC00013O0004E03O00BC00012O006A010400013O001228000500373O001228000600384O0049010400064O001000045O001228000300023O002EE8003A0055000100390004E03O00550001000E5101020055000100030004E03O00550001001228000200023O0004E03O000900010004E03O005500010004E03O000900010004E03O00D000010004E03O000400010004E03O00D00001002E8F003B00020001003C0004E03O000200010026BF3O0002000100010004E03O00020001001228000100014O0074000200023O0012283O00023O0004E03O000200012O003C012O00017O00333O00028O0003093O0080B2331B1F2CC643A803083O0031C5CA437E7364A7030A3O0049734361737461626C6503103O004865616C746850657263656E7461676503093O00457870656C4861726D030A3O001243CF2C8C16763649D203073O003E573BBF49E036030A3O00C303F7D9E20CD2C8F50F03043O00A987629A03083O0042752O66446F776E03123O00466F7274696679696E674272657742752O66025O0068B040025O003EA540030A3O0044616D70656E4861726D030B3O00EF762944F83D88E376365903073O00A8AB1744349D53026O00F03F025O0084A340025O008C9C40030E3O00D27EE7B92C2B9EFD7FF28F37289003073O00E7941195CD454D030E3O0044616D70656E4861726D42752O66025O00F8A440025O007AA440030E3O00466F7274696679696E6742726577030F3O00A6A8D5EF5EF999AEC9FC17DD92A2D003063O009FE0C7A79B37030C3O00D3FA3AD4E2E039FFF6F435D103043O00B297935C030C3O0044692O667573654D61676963030D3O00A8F44A34075F7FCCD04D351B4F03073O001AEC9D2C52722C027O0040025O002C9840025O00B9B140030B3O00022BD4573E26C64F2520D003043O003B4A4EB503073O0049735265616479030B3O004865616C746873746F6E65025O00F8A540025O0066A54003173O002DD45B56A72DC24E55BD20915E5FB520DF4953A520910903053O00D345B12O3A03193O0085E07FE7ECD8BFEC77F2A9E3B2E475FCE7CCF7D576E1E0C4B903063O00ABD78519958903173O00D3CD34E8EA23F44BEFCF1AFFEE3CF54CE6F83DEEE63FF203083O002281A8529A8F509C03173O0052656672657368696E674865616C696E67506F74696F6E03253O0097B735194D5D818CBC344B404B8889BB3D0C085E8691BB3C05084A8C83B73D1841588CC5E603073O00E9E5D2536B282E00E43O0012283O00013O0026BF3O0049000100010004E03O004900012O006A2O016O0070000200013O00122O000300023O00122O000400036O0002000400024O00010001000200202O0001000100044O00010002000200062O0001002100013O0004E03O002100012O006A2O0100023O0006A30001002100013O0004E03O002100012O006A2O0100033O0020142O01000100052O00302O01000200022O006A010200043O0006D700010021000100020004E03O002100012O006A2O0100054O006A01025O0020D40002000200062O00302O01000200020006A30001002100013O0004E03O002100012O006A2O0100013O001228000200073O001228000300084O00492O0100034O001000016O006A2O016O0070000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200202O0001000100044O00010002000200062O0001003B00013O0004E03O003B00012O006A2O0100063O0006A30001003B00013O0004E03O003B00012O006A2O0100033O0020642O010001000B4O00035O00202O00030003000C4O00010003000200062O0001003B00013O0004E03O003B00012O006A2O0100033O0020142O01000100052O00302O01000200022O006A010200073O00065F2O010003000100020004E03O003D0001002EE8000D00480001000E0004E03O004800012O006A2O0100054O006A01025O0020D400020002000F2O00302O01000200020006A30001004800013O0004E03O004800012O006A2O0100013O001228000200103O001228000300114O00492O0100034O001000015O0012283O00123O002E8F00140093000100130004E03O009300010026BF3O0093000100120004E03O009300012O006A2O016O0070000200013O00122O000300153O00122O000400166O0002000400024O00010001000200202O0001000100044O00010002000200062O0001006700013O0004E03O006700012O006A2O0100083O0006A30001006700013O0004E03O006700012O006A2O0100033O0020642O010001000B4O00035O00202O0003000300174O00010003000200062O0001006700013O0004E03O006700012O006A2O0100033O0020142O01000100052O00302O01000200022O006A010200093O00065F2O010003000100020004E03O00690001002EE800180074000100190004E03O007400012O006A2O0100054O006A01025O0020D400020002001A2O00302O01000200020006A30001007400013O0004E03O007400012O006A2O0100013O0012280002001B3O0012280003001C4O00492O0100034O001000016O006A2O016O0070000200013O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200202O0001000100044O00010002000200062O0001009200013O0004E03O009200012O006A2O01000A3O0006A30001009200013O0004E03O009200012O006A2O0100033O0020142O01000100052O00302O01000200022O006A0102000B3O0006D700010092000100020004E03O009200012O006A2O0100054O006A01025O0020D400020002001F2O00302O01000200020006A30001009200013O0004E03O009200012O006A2O0100013O001228000200203O001228000300214O00492O0100034O001000015O0012283O00223O002EE800230001000100240004E03O000100010026BF3O0001000100220004E03O000100012O006A2O01000C4O0070000200013O00122O000300253O00122O000400266O0002000400024O00010001000200202O0001000100274O00010002000200062O000100B900013O0004E03O00B900012O006A2O01000D3O0006A3000100B900013O0004E03O00B900012O006A2O0100033O0020142O01000100052O00302O01000200022O006A0102000E3O0006D7000100B9000100020004E03O00B900012O006A2O0100054O00E30002000F3O00202O0002000200284O000300046O000500016O00010005000200062O000100B4000100010004E03O00B40001002EE8002900B90001002A0004E03O00B900012O006A2O0100013O0012280002002B3O0012280003002C4O00492O0100034O001000016O006A2O0100103O0006A3000100E300013O0004E03O00E300012O006A2O0100033O0020142O01000100052O00302O01000200022O006A010200113O0006D7000100E3000100020004E03O00E300012O006A2O0100124O0047010200013O00122O0003002D3O00122O0004002E6O00020004000200062O000100CA000100020004E03O00CA00010004E03O00E300012O006A2O01000C4O0070000200013O00122O0003002F3O00122O000400306O0002000400024O00010001000200202O0001000100274O00010002000200062O000100E300013O0004E03O00E300012O006A2O0100054O00D00002000F3O00202O0002000200314O000300046O000500016O00010005000200062O000100E300013O0004E03O00E300012O006A2O0100013O00121F010200323O00122O000300336O000100036O00015O00044O00E300010004E03O000100012O003C012O00017O00B3012O00028O00026O002240025O00F08F40026O00F03F025O007DB240025O0008A340025O00806C40025O00B07D40030C3O004570696353652O74696E677303083O00F24726C20CCF452103053O0065A12252B603133O00DC0249CAC9EB8C25ED197AF1D5E68B3AE1025703083O004E886D399EBB82E203093O00446F6E277420557365030F3O00133EF7F83D18EBF83B39EDFE2C3CF103043O00915E5F9903123O004973457175692O706564416E645265616479025O002AA140025O0090874003023O004944030F3O00D0CC1ADC4D90EFC411D35AB8EFCE1C03063O00D79DAD74B52E030A3O0048617355736542752O66030A3O005472696E6B6574546F7003093O004973496E52616E6765026O004440025O00D4AF40025O0063B140031B3O0038B585FBD90AB399FBDF33A084E0D93DF49FE0D33BBF8EE6C975E603053O00BA55D4EB92025O002C9940030F3O00EF8018F73AC94ACB8410EA36FC5BCA03073O0038A2E1769E598E030D3O005472696E6B6574426F2O746F6D031B3O005104CEA621E75B17C9AA24CC5317C3A762CC4E0CCEA427CC4F459203063O00B83C65A0CF42025O00908140025O0021B240025O00A1B140025O00CAA740030F3O0093F50D4C8099E60A4085AAFB11468B03053O00E3DE94632503083O0042752O66446F776E030C3O00536572656E69747942752O66030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66026O000840030E3O00155357FAF03D577AF7EB3E5D5CEF03053O0099532O3296030B3O004973417661696C61626C6503173O007478651378AE7548737D287BAE7A557F671947A24A586403073O002D3D16137C13CB030F3O00432O6F6C646F776E52656D61696E73026O003E4003083O00F2171FF00C79ADD803073O00D9A1726D956210030C3O00432O6F6C646F776E446F776E027O0040030E3O0034213D70B57A1708396EB17B1C3903063O00147240581CDC026O001440025O009C9740025O00F6A240030F3O001C00DCBDFBF7AF3804D4A0F7C2BE3903073O00DD5161B2D498B0025O00E09B4003243O00C0E613F219F2E00FF21FCBF312E919C5A70EFE08C8E914EF03F2F30FF214C6E209E85A9503053O007AAD877D9B030F3O00A9C00EB03C16DA8DC406AD3023CB8C03073O00A8E4A160D95F51025O0028A940025O008AAE4003243O00D6D020552C68DCC327592943D4C32D546F44DEC32B522643C2EE3A4E2659D0D43A4F6F0F03063O0037BBB14E3C4F025O00609B40025O0030AF4003113O000FCB5EE849C19422DA57EE64CA9922C05B03073O00E04DAE3F8B26AF030E3O00A2405D228D4F5D06855355218A5803043O004EE4213803173O00E770A40C8ECB46A7068BFA76B7348DC76AB7378CC97BA003053O00E5AE1ED26303083O0028E89454E3342D0203073O00597B8DE6318D5D030E3O00D570F3001944F659F71E1D45FD6803063O002A9311966C70026O002440025O00805540025O0072A640025O004AB340025O00DEA84003113O002DA32C7CE8E61BA93977E2CA0ABF2271E303063O00886FC64D1F87025O0022A140025O0080464003284O000CA655B2EA28BD0D36B35EB8DB15AC1B06A952FDF712BB2O07AE42A4DB03BB0B07AC53A9F757F103083O00C96269C736DD847703113O009B0982220D3BB8B6188B242030B5B6028703073O00CCD96CE3416255025O00449F40025O0050774003283O005CC6F4E623CE61D7FADA38C85BFCF7E035CF50C7B5F629D25BCDFCF135FF4AD1FCEB27C54AD0B5BD03063O00A03EA395854C025O0092B140025O00A4934003113O00108E7BB9258A7DAE019766A63D875EB32903043O00DC51E21C03173O003ADB94F4E1C22BC087F5DECF16E28AF2FEC227DC85FEF803063O00A773B5E29B8A026O003940025O0048A140025O00C07C4003113O00C32EE0596F79C7F012F246617DC3C02DFF03073O00A68242873C1B11025O00C0AF40025O00F0A740025O0006A940025O007DB14003273O004546C970244C4BDC4A205150D479357B48C16D70574FDC703E4D5ED74A245643C07E3550598E2103053O0050242AAE1503113O006F1C307F5A1836687E052D60422O15755603043O001A2E7057025O00349540025O0090AB40025O00B07740025O00F0934003273O00B82FAC71ABB744A68633BE6EA5B3408BBB2CB334ACBA57B1B72ABF6D80AB57BDB728AE60ACFF1103083O00D4D943CB142ODF2503153O002O9FBDC2AE84A6D5899DADD3A8ABBAD3BD80ADDCAE03043O00B2DAEDC803063O0042752O665570025O00609540025O008DB14003153O0093A7F3C0A2BCE8D785A5E3D1A493F4D1B1B8E3DEA203043O00B0D6D586025O00C3B240025O00EAAD40032B3O00F1BFA3C4BC5F57F392A5C4AD574BCBABA4D5AF5B5CFAB9F6C7AD445CFAA4A2CD97424BFDA3BDD1BC4519A203073O003994CDD6B4C836025O004CA540025O0090764003153O0037EF2024621BF332076617FC27126413FA3831780603053O0016729D5554032B3O00C1D906D449FFA6C3F400D458F7BAFBCD01C55AFBADCADF53D758E4ADCAC207DD62E2BACDC518C149E5E89203073O00C8A4AB73A43D9603073O00F2AA0C3DD6C3AE03053O00A3B6C06D4F030B3O00122F13D4E63B2026D5E72D03053O0095544660A003173O0011081BE2330335F83D0839E53D3105E42C0339E43F031F03043O008D58666D026O002840025O00407140025O003C9E40025O009EB140025O00789E4003073O00446A61722O756E026O00204003363O00B759CB620F285BFEA35AC67C1B2F6ACEB56CDE781F0250CDB756D84F1C3154CCB613D97508385BC8A74AF56408345BCAB647D9304B6F03083O00A1D333AA107A5D35025O00B09240025O008AAF40025O0066AC40025O00E4AB4003173O00A9F294793BED8E0385F2B67E35DFBE1F94F9B67F37EDA403083O0076E09CE2165088D6025O00DCA940025O0090AA40025O00D08540025O00308140025O009CAC40030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574025O00C05940025O0042B140025O00C09640025O00B8B240026O00B04003103O0048616E646C65546F705472696E6B6574025O000CA740025O00707F40025O003C9340025O00A88C40030E3O0064EF5C8C4BE05CA843FC548F4CF703043O00E0228E3903173O00F7A9D3D278F4651BDBA9F1D576C65507CAA2F1D474F44F03083O006EBEC7A5BD13913D03083O00E9EE65ED852OCEF203063O00A7BA8B1788EB030E3O003CB48D0113BB8D251BA7850214AC03043O006D7AD5E8025O00E88040025O00909340025O00C08640025O00E2B040025O00B3B140025O007CA840025O00E06440026O007B40025O00949F40025O0060684003173O00DFBCB32FF4A0B421E9AB9027F6AC9621E8BEB726E8ABA003043O00489BCED203083O00446562752O665570030E3O00607B51023A487F7C0F214B755A1703053O0053261A346E03173O007119314953121F535D19134E5D202F4F4C12134F5F123503043O002638774703083O00C0EA4AD32B5FE7F603063O0036938F38B645030E3O00F080FA45D6D884D748CDDB8EF15003053O00BFB6E19F29025O0055B040025O0004AF40025O00E49140025O00D4924003173O000F0029528489C422002D77848AC00F1B3B458E89D12E0003073O00A24B724835EBE7025O0050A540025O00C49040026O00474003253O00882E45E55C0C8A3556E76C00833146DD570B9F2C41EC40079E7C50F05A0C873950F11353D803063O0062EC5C24823303173O00800B0DBD4AA6B339B61C2EB548AA9139B72O09B456ADA703083O0050C4796CDA25C8D5025O005EA140025O0016B34003253O000461037844008C09610740490187024C0676581E8F0E60076D0B1A98097D097A5F1DCA512703073O00EA6013621F2B6E025O00FC9A40025O009EA340030F3O002F0D5BC3A96798200D53C0A177851203073O00EB667F32A7CC1203173O0079AFE32C4F2B68B4F02D70265596FD2A502B64A8F2265603063O004E30C1954324025O0040A840025O00708740025O00AEA340025O00849040030F3O00190C891C44250DA60A40371385165503053O0021507EE078031C3O00E5BA0AC059F9BB3CC24EEDAF0EC152F8E817D655E2A306D04FACF95603053O003C8CC863A4025O000BB340025O0054AA40030F3O00AEE60D22A792E72234A380F90128B603053O00C2E7946446025O0032B140025O00C89C40031C3O004F5EC8A7F3DD5573C7B1F7CF4B49CFB7B6DC5445CFA8F3DC550C90F603063O00A8262CA1C396025O0078A940025O0007B140025O0073B340025O00BDB240025O0037B140025O001C9A40025O00606940025O00C2A74003113O00CFFBA535FAFFA322DEE2B82AE2F2803FF603043O00508E97C203173O002AC8614308C34F5906C8434406F17F4517C3434504C36503043O002C63A61703153O0053746F726D4561727468416E644669726542752O66025O00B6AF4003113O005DFB2E3327AC7DE5192329BE70F20B392B03063O00C41C97495653025O0056AA40025O00A0A440025O00ECAA40025O00188E4003233O00F20F2E1596501964CC133C0A98541D49F10C3150915D1E49E711201E895D0C65B3527F03083O001693634970E2387803113O009979E5F099B074F0C598A26FEEF0AFB76D03053O00EDD8158295025O0069B140025O0008A140025O00D0A040025O0078A44003233O008342585AA4C15F90714F4AAAD35287715D50A8894D8748604BA2C050892O4B4CF0980803073O003EE22E2O3FD0A903153O00C00B40930B042159D60950820D2B3D5FE214508D0B03083O003E857935E37F6D4F03133O00496E766F6B65727344656C6967687442752O66025O00CCAE40025O005EAC40025O00907E40025O00DCA04003153O00350627E5C2A7AC172722F0D7BC84021535F8D3A0B603073O00C270745295B6CE03273O003CBA5908D4EB003E975F08C5E31C06AE5E19C7EF0B37BC0C0BC5E4312DBA4516CBE71A2AE81D4003073O006E59C82C78A08203153O008ED15E565743354A98D34E47516C294CACCE4E485703083O002DCBA32B26232A5B025O00309940025O00C9B14003273O00D797C93393A05AD5BACF3382A846ED83CE2280A451DC919C3082AF6BC697D52D8CAC40C1C58D7B03073O0034B2E5BC43E7C9025O00E8A140025O002FB340025O006C9440025O00808740030F3O000C405E0DF47B3128445610F84E202903073O004341213064973C030E3O00F9E6ABD4FAD1E286D9E1D2E8A0C103053O0093BF87CEB803173O00AD26B0CED3568A912DA8F5D056858C21B2C4EC5AB5813A03073O00D2E448C6A1B833030E3O001048F61C7AC03361F2027EC1385003063O00AE5629937013030F3O0076018302262803A25E069904370C1903083O00CB3B60ED6B456F71025O00689C4003203O002917A2E832CFD0361FA9E725FFC5271EECF234F6E83004A5EF3AF5C33756FEB103073O00B74476CC815190030F3O0023AC7EED08A51CA475E21F8D1CAE7803063O00E26ECD10846B025O00E0A840025O0011B34003203O00E6C2EED042D4C4F2D044EDD7EFCB42E383F3DC47D4D7F2D04FE0C6F4CA01B99303053O00218BA380B903113O00755D05DD585610D1435001FC52410BD05303043O00BE373864030E3O0070AE39121AEDF67EAE2E131CEDEA03073O009336CF5C7E738303173O00243F2372067B35243073397608063D74197B393832781F03063O001E6D51551D6D030E3O00D97051BA3FD0F9D77046BB39D0E503073O009C9F1134D656BE025O00B09A40025O00A08140025O00B2A040025O007CAF40025O00E4A24003113O008CEABCBFA1E1A9B3BAE7B89EABF62OB2AA03043O00DCCE8FDD025O0063B040025O00F8984003243O0084782C14D7C2ED92721203D0C9ED84783418D6C89295782B28CCDEDB88762803CB8C80D403073O00B2E61D4D77B8AC03113O00D7BB0B1878F6E1B11E1372DAF0A705157303063O009895DE6A7B1703243O00DF23F740BAD319E24C8AC92EF37CB7D83FF94DB19D35F3458AC934FF4DBED832E503E78F03053O00D5BD46962303073O006B5F751A5A407A03043O00682F3514030B3O0085459208AF00A56A940EA503063O006FC32CE17CDC03173O00F148167CA0AEE053057D9FA3DD71087ABFAEEC4F0776B903063O00CBB8266013CB03313O003D797853DB2C7D4651C7357F7853F136754655C63C4C7C4DCA3C614647C2387E7C01DD3C754655DC307D7244DA2A332B1503053O00AE59131921025O0081B240025O00806940025O0006A340025O0034A940025O00C8AA40025O0058A640025O00F49340025O005AAB40025O0020A14003173O000B005349F8890D2600576CF88A090B1B415EF289182A0003073O006B4F72322E97E7030E3O001FA7B0258337B2E838B4B826842003083O00A059C6D549EA59D703173O00617FA2F1CE4D49A1FBCB7C79B1C9CD4165B1CACC4F74A603053O00A52811D49E030E3O00C3D80D3F2FEBDC203234E8D6062A03053O004685B96853025O006BB240025O00F88740025O009C944003173O002057452DC60A434D38CC264A4928ED0D56542FC717405603053O00A96425244A025O0096B140025O00208B4003293O000495A3570F89A45912829D520F8AA06F048EB1400589B15512C7B15506B8B6420989A9551494E2025603043O003060E7C203173O00EC480F2A16D6A98ADA5F2C2214DA8B8ADB4A0B230ADDBD03083O00E3A83A6E4D79B8CF03293O007F2EBE47BED577AC69398042BED6739A7F35AC50B4D562A0697CAC45B7E465B77232B445A5C831F72D03083O00C51B5CDF20D1BB11025O002EAD40025O00806540030F3O002A4DCAFF064AD0DD115EC4F60651D703043O009B633FA303173O00ABDFB782B281BAC4A4838D8C87E6A984AD81B6D8A688AB03063O00E4E2B1C1EDD9025O00ECB240025O0084AA40025O004C9F40025O00DCA840025O0054B140025O0050AC40030F3O001DA22AE231A530C026B124EB31BE3703043O008654D043031C3O001ABE8F5816B9956315BE875B1EA9884853B894551DA7834800ECD40403043O003C73CCE6025O005CB140025O00949A40030F3O00CE28E274E22FF856F53BEC7DE234FF03043O0010875A8B025O002CAF40031C3O005D660F374B412O6B72143249597D5A6046275C5D765F7112200E062003073O0018341466532E34025O008CAC40025O001AAE40025O0062AF40025O00E8A04003173O00ED21372B04C117342101F027241307CD3B241006C32A3303053O006FA44F4144025O00E8A540025O00EC9140025O0044A840025O00EAA140025O00049540025O00308A40025O00788840030E3O00E0D886D227E4C3F182CC23E5C8C003063O008AA6B9E3BE4E03173O00E27AD338592621DE71CB035A262EC37DD132662A1ECE6603073O0079AB14A5573243030E3O00E039BC3AB00CC310B824B40DC82103063O0062A658D956D9025O00D2A140025O00FAB040025O00FAA240025O00D08740025O0098A340025O00C2A840025O00AFB240025O00589440025O0016A740025O002CA840025O0052AA4000560A2O0012283O00014O0074000100023O002EE800020009000100030004E03O000900010026BF3O0009000100010004E03O00090001001228000100014O0074000200023O0012283O00043O000E510104000200013O0004E03O0002000100260C2O01000F000100010004E03O000F0001002EE800050093000100060004E03O00930001001228000300013O0026BF00030014000100040004E03O00140001001228000100043O0004E03O0093000100260C01030018000100010004E03O00180001002EE800080010000100070004E03O00100001001278010400094O004400055O00122O0006000A3O00122O0007000B6O0005000700024O0004000400054O00055O00122O0006000C3O00122O0007000D6O0005000700022O00320104000400050026BF000400260001000E0004E03O002600012O004700026O0099000200013O0006A30002009100013O0004E03O009100012O006A010400014O007000055O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O00040002000200062O0004009100013O0004E03O00910001001228000400014O0074000500063O00260C01040039000100010004E03O00390001002E8F0012003C000100130004E03O003C0001001228000500014O0074000600063O001228000400043O0026BF00040035000100040004E03O003500010026BF0005003E000100010004E03O003E0001001228000600013O000E512O010041000100060004E03O004100012O006A010700023O0020C10007000700144O0007000200024O000800016O00095O00122O000A00153O00122O000B00166O0009000B00024O00080008000900202O0008000800144O00080002000200062O00070067000100080004E03O006700012O006A010700033O0020140107000700172O003001070002000200068201070067000100010004E03O006700012O006A010700044O0027010800053O00202O0008000800184O000900063O00202O00090009001900122O000B001A6O0009000B00024O000900096O00070009000200062O00070062000100010004E03O00620001002E8F001C00670001001B0004E03O006700012O006A01075O0012280008001D3O0012280009001E4O0049010700094O001000075O002EA7011F002A0001001F0004E03O009100012O006A010700033O0020C10007000700144O0007000200024O000800016O00095O00122O000A00203O00122O000B00216O0009000B00024O00080008000900202O0008000800144O00080002000200062O00070091000100080004E03O009100012O006A010700023O0020140107000700172O003001070002000200068201070091000100010004E03O009100012O006A010700044O0056000800053O00202O0008000800224O000900063O00202O00090009001900122O000B001A6O0009000B00024O000900096O00070009000200062O0007009100013O0004E03O009100012O006A01075O00121F010800233O00122O000900246O000700096O00075O00044O009100010004E03O004100010004E03O009100010004E03O003E00010004E03O009100010004E03O00350001001228000300043O0004E03O001000010026BF0001000B000100040004E03O000B00012O006A010300073O0026BF00030033050100040004E03O00330501001228000300013O002E8F00250034030100260004E03O003403010026BF00030034030100010004E03O003403010006A3000200FB02013O0004E03O00FB0201001228000400014O0074000500063O0026BF000400F5020100040004E03O00F502010026BF000500A3000100010004E03O00A30001001228000600013O00260C010600AA000100040004E03O00AA0001002E8F0027000A020100280004E03O000A02012O006A010700014O007000085O00122O000900293O00122O000A002A6O0008000A00024O00070007000800202O0007000700114O00070002000200062O000700572O013O0004E03O00572O012O006A010700023O0020140107000700172O0030010700020002000682010700D9000100010004E03O00D900012O006A010700033O0020140107000700172O0030010700020002000682010700D9000100010004E03O00D900012O006A010700083O00206401070007002B4O000900093O00202O00090009002C4O00070009000200062O000700D900013O0004E03O00D900012O006A0107000A3O000682010700D9000100010004E03O00D900012O006A010700063O00207301070007002D4O000900093O00202O00090009002E4O000700090002000E2O002F000B2O0100070004E03O000B2O012O006A010700094O007000085O00122O000900303O00122O000A00316O0008000A00024O00070007000800202O0007000700324O00070002000200062O0007000B2O013O0004E03O000B2O012O006A010700023O0020140107000700172O0030010700020002000682010700E3000100010004E03O00E300012O006A010700033O0020140107000700172O00300107000200020006A3000700082O013O0004E03O00082O012O006A010700094O001200085O00122O000900333O00122O000A00346O0008000A00024O00070007000800202O0007000700354O000700020002000E2O003600082O0100070004E03O00082O012O006A010700094O007000085O00122O000900373O00122O000A00386O0008000A00024O00070007000800202O0007000700394O00070002000200062O000700082O013O0004E03O00082O012O006A010700063O00207301070007002D4O000900093O00202O00090009002E4O000700090002000E2O003A000B2O0100070004E03O000B2O012O006A010700094O007000085O00122O0009003B3O00122O000A003C6O0008000A00024O00070007000800202O0007000700324O00070002000200062O0007000B2O013O0004E03O000B2O012O006A0107000B3O002650010700572O01003D0004E03O00572O01001228000700014O0074000800083O0026BF0007000D2O0100010004E03O000D2O01001228000800013O00260C010800142O0100010004E03O00142O01002E8F003F00102O01003E0004E03O00102O012O006A010900023O0020A60009000900144O0009000200024O000A00016O000B5O00122O000C00403O00122O000D00416O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900222O01000A0004E03O00222O010004E03O00342O012O006A010900044O0027010A00053O00202O000A000A00184O000B00063O00202O000B000B001900122O000D001A6O000B000D00024O000B000B6O0009000B000200062O0009002F2O0100010004E03O002F2O01002E8F004200342O01003D0004E03O00342O012O006A01095O001228000A00433O001228000B00444O00490109000B4O001000096O006A010900033O0020C10009000900144O0009000200024O000A00016O000B5O00122O000C00453O00122O000D00466O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900572O01000A0004E03O00572O012O006A010900044O0027010A00053O00202O000A000A00224O000B00063O00202O000B000B001900122O000D001A6O000B000D00024O000B000B6O0009000B000200062O0009004E2O0100010004E03O004E2O01002EE8004800572O0100470004E03O00572O012O006A01095O00121F010A00493O00122O000B004A6O0009000B6O00095O00044O00572O010004E03O00102O010004E03O00572O010004E03O000D2O01002EE8004B00FB0201004C0004E03O00FB02012O006A010700014O007000085O00122O0009004D3O00122O000A004E6O0008000A00024O00070007000800202O0007000700114O00070002000200062O000700FB02013O0004E03O00FB02012O006A010700023O0020140107000700172O0030010700020002000682010700882O0100010004E03O00882O012O006A010700033O0020140107000700172O0030010700020002000682010700882O0100010004E03O00882O012O006A010700083O00206401070007002B4O000900093O00202O00090009002C4O00070009000200062O000700882O013O0004E03O00882O012O006A0107000A3O000682010700882O0100010004E03O00882O012O006A010700063O00207301070007002D4O000900093O00202O00090009002E4O000700090002000E2O003A00BA2O0100070004E03O00BA2O012O006A010700094O007000085O00122O0009004F3O00122O000A00506O0008000A00024O00070007000800202O0007000700324O00070002000200062O000700BA2O013O0004E03O00BA2O012O006A010700023O0020140107000700172O0030010700020002000682010700922O0100010004E03O00922O012O006A010700033O0020140107000700172O00300107000200020006A3000700B72O013O0004E03O00B72O012O006A010700094O001200085O00122O000900513O00122O000A00526O0008000A00024O00070007000800202O0007000700354O000700020002000E2O003600B72O0100070004E03O00B72O012O006A010700094O007000085O00122O000900533O00122O000A00546O0008000A00024O00070007000800202O0007000700394O00070002000200062O000700B72O013O0004E03O00B72O012O006A010700063O00207301070007002D4O000900093O00202O00090009002E4O000700090002000E2O003A00BA2O0100070004E03O00BA2O012O006A010700094O007000085O00122O000900553O00122O000A00566O0008000A00024O00070007000800202O0007000700324O00070002000200062O000700BA2O013O0004E03O00BA2O012O006A0107000B3O002650010700FB020100570004E03O00FB0201001228000700014O0074000800083O00260C010700C02O0100010004E03O00C02O01002E8F005900BC2O0100580004E03O00BC2O01001228000800013O00260C010800C52O0100010004E03O00C52O01002EE8005A00C12O01005B0004E03O00C12O012O006A010900023O0020A60009000900144O0009000200024O000A00016O000B5O00122O000C005C3O00122O000D005D6O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900D32O01000A0004E03O00D32O010004E03O00E52O01002EA7015E00120001005E0004E03O00E52O012O006A010900044O0056000A00053O00202O000A000A00184O000B00063O00202O000B000B001900122O000D005F6O000B000D00024O000B000B6O0009000B000200062O000900E52O013O0004E03O00E52O012O006A01095O001228000A00603O001228000B00614O00490109000B4O001000096O006A010900033O0020C10009000900144O0009000200024O000A00016O000B5O00122O000C00623O00122O000D00636O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900FB0201000A0004E03O00FB0201002EE8006400F52O0100650004E03O00F52O010004E03O00FB02012O006A010900044O0056000A00053O00202O000A000A00224O000B00063O00202O000B000B001900122O000D005F6O000B000D00024O000B000B6O0009000B000200062O000900FB02013O0004E03O00FB02012O006A01095O00121F010A00663O00122O000B00676O0009000B6O00095O00044O00FB02010004E03O00C12O010004E03O00FB02010004E03O00BC2O010004E03O00FB02010026BF000600A6000100010004E03O00A60001001228000700013O000E5101040011020100070004E03O00110201001228000600043O0004E03O00A6000100260C01070015020100010004E03O00150201002EE80068000D020100690004E03O000D02012O006A010800014O007000095O00122O000A006A3O00122O000B006B6O0009000B00024O00080008000900202O0008000800114O00080002000200062O0008003602013O0004E03O003602012O006A0108000A3O0006820108002C020100010004E03O002C02012O006A010800094O00A400095O00122O000A006C3O00122O000B006D6O0009000B00024O00080008000900202O0008000800324O00080002000200062O00080033020100010004E03O003302012O006A010800083O00208F01080008002B4O000A00093O00202O000A000A002C4O0008000A000200062O00080038020100010004E03O003802012O006A0108000B3O00266A000800380201006E0004E03O00380201002EA7016F0053000100700004E03O00890201001228000800013O000E512O010039020100080004E03O003902012O006A010900023O0020C10009000900144O0009000200024O000A00016O000B5O00122O000C00713O00122O000D00726O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O0009004D0201000A0004E03O004D02012O006A010900033O0020140109000900172O00300109000200020006A30009004F02013O0004E03O004F0201002EE800730061020100740004E03O00610201002EE800750061020100760004E03O006102012O006A010900044O0056000A00053O00202O000A000A00184O000B00063O00202O000B000B001900122O000D001A6O000B000D00024O000B000B6O0009000B000200062O0009006102013O0004E03O006102012O006A01095O001228000A00773O001228000B00784O00490109000B4O001000096O006A010900033O0020C10009000900144O0009000200024O000A00016O000B5O00122O000C00793O00122O000D007A6O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900730201000A0004E03O007302012O006A010900023O0020140109000900172O00300109000200020006A30009007502013O0004E03O00750201002EE8007C00890201007B0004E03O008902012O006A010900044O0027010A00053O00202O000A000A00224O000B00063O00202O000B000B001900122O000D001A6O000B000D00024O000B000B6O0009000B000200062O00090082020100010004E03O00820201002EA7017D00090001007E0004E03O008902012O006A01095O00121F010A007F3O00122O000B00806O0009000B6O00095O00044O008902010004E03O003902012O006A010800014O007000095O00122O000A00813O00122O000B00826O0009000B00024O00080008000900202O0008000800114O00080002000200062O000800EF02013O0004E03O00EF02012O006A010800083O0020640108000800834O000A00093O00202O000A000A002C4O0008000A000200062O000800EF02013O0004E03O00EF0201001228000800014O0074000900093O002E8F0084009C020100850004E03O009C0201000E512O01009C020100080004E03O009C0201001228000900013O000E512O0100A1020100090004E03O00A102012O006A010A00023O0020C1000A000A00144O000A000200024O000B00016O000C5O00122O000D00863O00122O000E00876O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00C70201000B0004E03O00C702012O006A010A00033O002014010A000A00172O0030010A00020002000682010A00C7020100010004E03O00C702012O006A010A00044O0027010B00053O00202O000B000B00184O000C00063O00202O000C000C001900122O000E001A6O000C000E00024O000C000C6O000A000C000200062O000A00C2020100010004E03O00C20201002E8F008800C7020100890004E03O00C702012O006A010A5O001228000B008A3O001228000C008B4O0049010A000C4O0010000A5O002EE8008D00EF0201008C0004E03O00EF02012O006A010A00033O0020C1000A000A00144O000A000200024O000B00016O000C5O00122O000D008E3O00122O000E008F6O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00EF0201000B0004E03O00EF02012O006A010A00023O002014010A000A00172O0030010A00020002000682010A00EF020100010004E03O00EF02012O006A010A00044O0056000B00053O00202O000B000B00224O000C00063O00202O000C000C001900122O000E001A6O000C000E00024O000C000C6O000A000C000200062O000A00EF02013O0004E03O00EF02012O006A010A5O00121F010B00903O00122O000C00916O000A000C6O000A5O00044O00EF02010004E03O00A102010004E03O00EF02010004E03O009C0201001228000700043O0004E03O000D02010004E03O00A600010004E03O00FB02010004E03O00A300010004E03O00FB02010026BF000400A1000100010004E03O00A10001001228000500014O0074000600063O001228000400043O0004E03O00A100012O006A0104000C3O0006A30004001F03013O0004E03O001F03012O006A010400014O007000055O00122O000600923O00122O000700936O0005000700024O00040004000500202O0004000400114O00040002000200062O0004001F03013O0004E03O001F03012O006A010400094O005401055O00122O000600943O00122O000700956O0005000700024O00040004000500202O0004000400354O00040002000200262O0004001C0301003A0004E03O001C03012O006A010400094O008301055O00122O000600963O00122O000700976O0005000700024O00040004000500202O0004000400354O000400020002000E2O00570021030100040004E03O002103012O006A0104000B3O00266A00040021030100980004E03O00210301002E8F009A0033030100990004E03O00330301002EE8009C00330301009B0004E03O003303012O006A010400044O0056000500053O00202O00050005009D4O000600063O00202O00060006001900122O0008009E6O0006000800024O000600066O00040006000200062O0004003303013O0004E03O003303012O006A01045O0012280005009F3O001228000600A04O0049010400064O001000045O001228000300043O002EE800A10099000100A20004E03O009900010026BF00030099000100040004E03O009900010006A3000200550A013O0004E03O00550A01001228000400013O0026BF00040013040100040004E03O00130401002E8F00A400A2030100A30004E03O00A203012O006A0105000A3O0006820105004C030100010004E03O004C03012O006A010500094O00A400065O00122O000700A53O00122O000800A66O0006000800024O00050005000600202O0005000500324O00050002000200062O000500A2030100010004E03O00A203012O006A010500083O0020640105000500834O000700093O00202O00070007002C4O00050007000200062O000500A203013O0004E03O00A20301001228000500014O0074000600073O002E8F00A7009A030100A80004E03O009A03010026BF0005009A030100040004E03O009A0301000E912O01005D030100060004E03O005D0301002EA701A900FEFF2O00AA0004E03O00590301001228000700013O002EA701AB0014000100AB0004E03O007203010026BF00070072030100040004E03O007203012O006A0108000D3O0020080108000800AD4O0009000E6O000A000F3O00122O000B001A6O000C000C6O0008000C000200122O000800AC3O002E2O00AE0038000100AE0004E03O00A20301001278010800AC3O0006A3000800A203013O0004E03O00A20301001278010800AC4O003A000800023O0004E03O00A2030100260C01070076030100010004E03O00760301002EE800AF005E030100B00004E03O005E0301001228000800013O0026BF00080091030100010004E03O00910301001228000900013O0026BF0009007E030100040004E03O007E0301001228000800043O0004E03O0091030100260C01090082030100010004E03O00820301002E8F00B1007A030100B20004E03O007A03012O006A010A000D3O002038000A000A00B34O000B000E6O000C000F3O00122O000D001A6O000E000E6O000A000E000200122O000A00AC3O00122O000A00AC3O00062O000A008F03013O0004E03O008F0301001278010A00AC4O003A000A00023O001228000900043O0004E03O007A03010026BF00080077030100040004E03O00770301001228000700043O0004E03O005E03010004E03O007703010004E03O005E03010004E03O00A203010004E03O005903010004E03O00A2030100260C0105009E030100010004E03O009E0301002EA701B400B9FF2O00B50004E03O00550301001228000600014O0074000700073O001228000500043O0004E03O00550301002E8F00B700550A0100B60004E03O00550A012O006A010500063O00207301050005002D4O000700093O00202O00070007002E4O000500070002000E2O003D00DA030100050004E03O00DA03012O006A010500094O007000065O00122O000700B83O00122O000800B96O0006000800024O00050005000600202O0005000500324O00050002000200062O000500DA03013O0004E03O00DA03012O006A010500094O001200065O00122O000700BA3O00122O000800BB6O0006000800024O00050005000600202O0005000500354O000500020002000E2O003600550A0100050004E03O00550A012O006A010500094O007000065O00122O000700BC3O00122O000800BD6O0006000800024O00050005000600202O0005000500394O00050002000200062O000500550A013O0004E03O00550A012O006A010500063O00207301050005002D4O000700093O00202O00070007002E4O000500070002000E2O003D00DA030100050004E03O00DA03012O006A010500094O00A400065O00122O000700BE3O00122O000800BF6O0006000800024O00050005000600202O0005000500324O00050002000200062O000500550A0100010004E03O00550A01001228000500014O0074000600063O00260C010500E0030100010004E03O00E00301002E8F00C100DC030100C00004E03O00DC0301001228000600013O0026BF000600FB030100010004E03O00FB0301001228000700013O00260C010700E8030100010004E03O00E80301002E8F00C300F6030100C20004E03O00F603012O006A0108000D3O0020380008000800B34O0009000E6O000A000F3O00122O000B001A6O000C000C6O0008000C000200122O000800AC3O00122O000800AC3O00062O000800F503013O0004E03O00F50301001278010800AC4O003A000800023O001228000700043O0026BF000700E4030100040004E03O00E40301001228000600043O0004E03O00FB03010004E03O00E4030100260C010600FF030100040004E03O00FF0301002EA701C400E4FF2O00C50004E03O00E103012O006A0107000D3O00206B0007000700AD4O0008000E6O0009000F3O00122O000A001A6O000B000B6O0007000B000200122O000700AC3O00122O000700AC3O00062O0007000C040100010004E03O000C0401002EA701C6004B060100C70004E03O00550A01001278010700AC4O003A000700023O0004E03O00550A010004E03O00E103010004E03O00550A010004E03O00DC03010004E03O00550A010026BF0004003B030100010004E03O003B0301002EE800C900BC040100C80004E03O00BC04012O006A010500014O007000065O00122O000700CA3O00122O000800CB6O0006000800024O00050005000600202O0005000500114O00050002000200062O000500BC04013O0004E03O00BC04012O006A010500023O0020140105000500172O00300105000200020006820105003C040100010004E03O003C04012O006A010500033O0020140105000500172O00300105000200020006820105003C040100010004E03O003C04012O006A010500063O00208F0105000500CC4O000700093O00202O00070007002E4O00050007000200062O0005006E040100010004E03O006E04012O006A010500094O007000065O00122O000700CD3O00122O000800CE6O0006000800024O00050005000600202O0005000500324O00050002000200062O0005006E04013O0004E03O006E04012O006A010500023O0020140105000500172O003001050002000200068201050046040100010004E03O004604012O006A010500033O0020140105000500172O00300105000200020006A30005006B04013O0004E03O006B04012O006A010500094O001200065O00122O000700CF3O00122O000800D06O0006000800024O00050005000600202O0005000500354O000500020002000E2O0057006B040100050004E03O006B04012O006A010500094O007000065O00122O000700D13O00122O000800D26O0006000800024O00050005000600202O0005000500394O00050002000200062O0005006B04013O0004E03O006B04012O006A010500063O00208F0105000500CC4O000700093O00202O00070007002E4O00050007000200062O0005006E040100010004E03O006E04012O006A010500094O007000065O00122O000700D33O00122O000800D46O0006000800024O00050005000600202O0005000500324O00050002000200062O0005006E04013O0004E03O006E04012O006A0105000B3O002650010500BC040100570004E03O00BC0401001228000500014O0074000600063O002E8F00D60070040100D50004E03O007004010026BF00050070040100010004E03O00700401001228000600013O002E8F00D70075040100D80004E03O007504010026BF00060075040100010004E03O007504012O006A010700023O0020C10007000700144O0007000200024O000800016O00095O00122O000A00D93O00122O000B00DA6O0009000B00024O00080008000900202O0008000800144O00080002000200062O00070099040100080004E03O00990401002E8F00DB0089040100DC0004E03O008904010004E03O009904012O006A010700044O0056000800053O00202O0008000800184O000900063O00202O00090009001900122O000B00DD6O0009000B00024O000900096O00070009000200062O0007009904013O0004E03O009904012O006A01075O001228000800DE3O001228000900DF4O0049010700094O001000076O006A010700033O0020A60007000700144O0007000200024O000800016O00095O00122O000A00E03O00122O000B00E16O0009000B00024O00080008000900202O0008000800144O00080002000200062O000700A8040100080004E03O00A80401002E8F00E300BC040100E20004E03O00BC04012O006A010700044O0056000800053O00202O0008000800224O000900063O00202O00090009001900122O000B00DD6O0009000B00024O000900096O00070009000200062O000700BC04013O0004E03O00BC04012O006A01075O00121F010800E43O00122O000900E56O000700096O00075O00044O00BC04010004E03O007504010004E03O00BC04010004E03O00700401002E8F00E6002E050100E70004E03O002E05012O006A010500014O007000065O00122O000700E83O00122O000800E96O0006000800024O00050005000600202O0005000500114O00050002000200062O0005002E05013O0004E03O002E05012O006A0105000A3O000682010500D5040100010004E03O00D504012O006A010500094O00A400065O00122O000700EA3O00122O000800EB6O0006000800024O00050005000600202O0005000500324O00050002000200062O000500DC040100010004E03O00DC04012O006A010500083O00208F0105000500834O000700093O00202O00070007002C4O00050007000200062O000500DF040100010004E03O00DF04012O006A0105000B3O0026500105002E0501006E0004E03O002E0501001228000500014O0074000600073O000E5101040026050100050004E03O0026050100260C010600E7040100010004E03O00E70401002EE800EC00E3040100ED0004E03O00E30401001228000700013O0026BF000700E8040100010004E03O00E80401002EE800EF0004050100EE0004E03O000405012O006A010800023O0020C10008000800144O0008000200024O000900016O000A5O00122O000B00F03O00122O000C00F16O000A000C00024O00090009000A00202O0009000900144O00090002000200062O00080004050100090004E03O000405012O006A010800044O006A010900053O0020D40009000900182O00300108000200020006A30008000405013O0004E03O000405012O006A01085O001228000900F23O001228000A00F34O00490108000A4O001000085O002EE800F50014050100F40004E03O001405012O006A010800033O0020A60008000800144O0008000200024O000900016O000A5O00122O000B00F63O00122O000C00F76O000A000C00024O00090009000A00202O0009000900144O00090002000200062O00080014050100090004E03O001405010004E03O002E05012O006A010800044O006A010900053O0020D40009000900222O00300108000200020006820108001C050100010004E03O001C0501002EE800F8002E050100F90004E03O002E05012O006A01085O00121F010900FA3O00122O000A00FB6O0008000A6O00085O00044O002E05010004E03O00E804010004E03O002E05010004E03O00E304010004E03O002E050100260C0105002A050100010004E03O002A0501002EE800FD00E1040100FC0004E03O00E10401001228000600014O0074000700073O001228000500043O0004E03O00E10401001228000400043O0004E03O003B03010004E03O00550A010004E03O009900010004E03O00550A01001228000300013O000E512O0100DE070100030004E03O00DE07010006A3000200A607013O0004E03O00A60701001228000400014O0074000500063O0026BF0004003F050100010004E03O003F0501001228000500014O0074000600063O001228000400043O000E510104003A050100040004E03O003A0501002EE800FF0041050100FE0004E03O004105010026BF00050041050100010004E03O00410501001228000600013O00260C0106004B050100010004E03O004B05010012280007002O012O000E5101000139060100070004E03O00390601001228000700013O00122800080002012O00122800090003012O0006030008002F060100090004E03O002F0601001228000800013O0006220107002F060100080004E03O002F06012O006A010800014O007000095O00122O000A0004012O00122O000B0005015O0009000B00024O00080008000900202O0008000800114O00080002000200062O000800C805013O0004E03O00C805012O006A0108000A3O0006820108006A050100010004E03O006A05012O006A010800094O00A400095O00122O000A0006012O00122O000B0007015O0009000B00024O00080008000900202O0008000800324O00080002000200062O00080072050100010004E03O007205012O006A010800083O00209300080008002B4O000A00093O00122O000B0008015O000A000A000B4O0008000A000200062O00080076050100010004E03O007605012O006A0108000B3O0012280009006E3O000603000800C8050100090004E03O00C80501001228000800014O0074000900093O001228000A00013O000622010A0078050100080004E03O00780501001228000900013O001228000A0009012O001228000B0009012O000622010A007C0501000B0004E03O007C0501001228000A00013O0006220109007C0501000A0004E03O007C05012O006A010A00023O0020C1000A000A00144O000A000200024O000B00016O000C5O00122O000D000A012O00122O000E000B015O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00A40501000B0004E03O00A40501001228000A000C012O001228000B000D012O0006D7000A00950501000B0004E03O009505010004E03O00A405012O006A010A00044O006A010B00053O0020D4000B000B00182O0030010A00020002000682010A009F050100010004E03O009F0501001228000A000E012O001228000B000F012O0006D7000A00A40501000B0004E03O00A405012O006A010A5O001228000B0010012O001228000C0011013O0049010A000C4O0010000A6O006A010A00033O0020A6000A000A00144O000A000200024O000B00016O000C5O00122O000D0012012O00122O000E0013015O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00B50501000B0004E03O00B50501001228000A0014012O001228000B0015012O0006D7000A00C80501000B0004E03O00C805012O006A010A00044O006A010B00053O0020D4000B000B00222O0030010A00020002000682010A00BF050100010004E03O00BF0501001228000A0016012O001228000B0017012O000603000B00C80501000A0004E03O00C805012O006A010A5O00121F010B0018012O00122O000C0019015O000A000C6O000A5O00044O00C805010004E03O007C05010004E03O00C805010004E03O007805012O006A010800014O007000095O00122O000A001A012O00122O000B001B015O0009000B00024O00080008000900202O0008000800114O00080002000200062O000800DA05013O0004E03O00DA05012O006A010800083O0020930008000800834O000A00093O00122O000B001C015O000A000A000B4O0008000A000200062O000800DE050100010004E03O00DE05010012280008001D012O0012280009001E012O0006030008002E060100090004E03O002E0601001228000800014O0074000900093O001228000A00013O00068C010800E70501000A0004E03O00E70501001228000A001F012O001228000B0020012O000603000B00E00501000A0004E03O00E00501001228000900013O001228000A00013O000622010900E80501000A0004E03O00E805012O006A010A00023O0020C1000A000A00144O000A000200024O000B00016O000C5O00122O000D0021012O00122O000E0022015O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00080601000B0004E03O000806012O006A010A00044O0056000B00053O00202O000B000B00184O000C00063O00202O000C000C001900122O000E001A6O000C000E00024O000C000C6O000A000C000200062O000A000806013O0004E03O000806012O006A010A5O001228000B0023012O001228000C0024013O0049010A000C4O0010000A6O006A010A00033O0020A6000A000A00144O000A000200024O000B00016O000C5O00122O000D0025012O00122O000E0026015O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00160601000B0004E03O001606010004E03O002E0601001228000A0027012O001228000B0028012O0006D7000A002E0601000B0004E03O002E06012O006A010A00044O0056000B00053O00202O000B000B00224O000C00063O00202O000C000C001900122O000E001A6O000C000E00024O000C000C6O000A000C000200062O000A002E06013O0004E03O002E06012O006A010A5O00121F010B0029012O00122O000C002A015O000A000C6O000A5O00044O002E06010004E03O00E805010004E03O002E06010004E03O00E00501001228000700043O001228000800043O00068C01070036060100080004E03O003606010012280008002B012O0012280009002C012O0006030009004C050100080004E03O004C0501001228000600043O0004E03O003906010004E03O004C0501001228000700043O00068C01060040060100070004E03O004006010012280007002D012O0012280008002E012O00060300070046050100080004E03O004605012O006A010700014O007000085O00122O0009002F012O00122O000A0030015O0008000A00024O00070007000800202O0007000700114O00070002000200062O000700E206013O0004E03O00E206012O006A010700023O0020140107000700172O003001070002000200068201070071060100010004E03O007106012O006A010700033O0020140107000700172O003001070002000200068201070071060100010004E03O007106012O006A010700083O00209C01070007002B4O000900093O00122O000A0008015O00090009000A4O00070009000200062O0007007106013O0004E03O007106012O006A0107000A3O00068201070071060100010004E03O007106012O006A010700063O00203000070007002D4O000900093O00202O00090009002E4O00070009000200122O0008002F3O00062O0008009C060100070004E03O009C06012O006A010700094O007000085O00122O00090031012O00122O000A0032015O0008000A00024O00070007000800202O0007000700324O00070002000200062O0007009C06013O0004E03O009C06012O006A010700023O0020140107000700172O00300107000200020006820107007B060100010004E03O007B06012O006A010700033O0020140107000700172O00300107000200020006A30007009806013O0004E03O009806012O006A010700094O00BC00085O00122O00090033012O00122O000A0034015O0008000A00024O00070007000800202O0007000700354O00070002000200122O000800363O00062O00080098060100070004E03O009806012O006A010700063O00203000070007002D4O000900093O00202O00090009002E4O00070009000200122O0008003A3O00062O0008009C060100070004E03O009C06012O006A010700094O007000085O00122O00090035012O00122O000A0036015O0008000A00024O00070007000800202O0007000700324O00070002000200062O0007009C06013O0004E03O009C06012O006A0107000B3O0012280008003D3O000603000700E2060100080004E03O00E20601001228000700014O0074000800083O001228000900013O0006220107009E060100090004E03O009E0601001228000800013O001228000900013O000622010900A2060100080004E03O00A206012O006A010900023O0020C10009000900144O0009000200024O000A00016O000B5O00122O000C0037012O00122O000D0038015O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900C20601000A0004E03O00C20601001228000900C83O001228000A0039012O0006D7000900B70601000A0004E03O00B706010004E03O00C206012O006A010900044O006A010A00053O0020D4000A000A00182O00300109000200020006A3000900C206013O0004E03O00C206012O006A01095O001228000A003A012O001228000B003B013O00490109000B4O001000096O006A010900033O0020C10009000900144O0009000200024O000A00016O000B5O00122O000C003C012O00122O000D003D015O000B000D00024O000A000A000B00202O000A000A00144O000A0002000200062O000900E20601000A0004E03O00E206012O006A010900044O006A010A00053O0020D4000A000A00222O0030010900020002000682010900D9060100010004E03O00D906010012280009003E012O001228000A003F012O000603000A00E2060100090004E03O00E206012O006A01095O00121F010A0040012O00122O000B0041015O0009000B6O00095O00044O00E206010004E03O00A206010004E03O00E206010004E03O009E06012O006A010700014O007000085O00122O00090042012O00122O000A0043015O0008000A00024O00070007000800202O0007000700114O00070002000200062O000700A607013O0004E03O00A607012O006A010700023O0020140107000700172O003001070002000200068201070013070100010004E03O001307012O006A010700033O0020140107000700172O003001070002000200068201070013070100010004E03O001307012O006A010700083O00209C01070007002B4O000900093O00122O000A0008015O00090009000A4O00070009000200062O0007001307013O0004E03O001307012O006A0107000A3O00068201070013070100010004E03O001307012O006A010700063O00203000070007002D4O000900093O00202O00090009002E4O00070009000200122O0008003A3O00062O0008003E070100070004E03O003E07012O006A010700094O007000085O00122O00090044012O00122O000A0045015O0008000A00024O00070007000800202O0007000700324O00070002000200062O0007003E07013O0004E03O003E07012O006A010700023O0020140107000700172O00300107000200020006820107001D070100010004E03O001D07012O006A010700033O0020140107000700172O00300107000200020006A30007003A07013O0004E03O003A07012O006A010700094O00BC00085O00122O00090046012O00122O000A0047015O0008000A00024O00070007000800202O0007000700354O00070002000200122O000800363O00062O0008003A070100070004E03O003A07012O006A010700063O00203000070007002D4O000900093O00202O00090009002E4O00070009000200122O0008003A3O00062O0008003E070100070004E03O003E07012O006A010700094O007000085O00122O00090048012O00122O000A0049015O0008000A00024O00070007000800202O0007000700324O00070002000200062O0007003E07013O0004E03O003E07012O006A0107000B3O001228000800573O000603000700A6070100080004E03O00A60701001228000700014O0074000800093O001228000A00013O00068C010700470701000A0004E03O00470701001228000A004A012O001228000B004B012O000603000A004A0701000B0004E03O004A0701001228000800014O0074000900093O001228000700043O001228000A00043O00068C010700510701000A0004E03O00510701001228000A004C012O001228000B004A012O0006D7000A00400701000B0004E03O00400701001228000A00013O000622010800510701000A0004E03O00510701001228000900013O001228000A004D012O001228000B004E012O000603000B00550701000A0004E03O00550701001228000A00013O000622010900550701000A0004E03O005507012O006A010A00023O0020C1000A000A00144O000A000200024O000B00016O000C5O00122O000D004F012O00122O000E0050015O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A007D0701000B0004E03O007D07012O006A010A00044O0027010B00053O00202O000B000B00184O000C00063O00202O000C000C001900122O000E005F6O000C000E00024O000C000C6O000A000C000200062O000A0078070100010004E03O00780701001228000A0051012O001228000B0052012O0006D7000A007D0701000B0004E03O007D07012O006A010A5O001228000B0053012O001228000C0054013O0049010A000C4O0010000A6O006A010A00033O0020C1000A000A00144O000A000200024O000B00016O000C5O00122O000D0055012O00122O000E0056015O000C000E00024O000B000B000C00202O000B000B00144O000B0002000200062O000A00A60701000B0004E03O00A607012O006A010A00044O0056000B00053O00202O000B000B00224O000C00063O00202O000C000C001900122O000E005F6O000C000E00024O000C000C6O000A000C000200062O000A00A607013O0004E03O00A607012O006A010A5O00121F010B0057012O00122O000C0058015O000A000C6O000A5O00044O00A607010004E03O005507010004E03O00A607010004E03O005107010004E03O00A607010004E03O004007010004E03O00A607010004E03O004605010004E03O00A607010004E03O004105010004E03O00A607010004E03O003A05012O006A0104000C3O0006A3000400DD07013O0004E03O00DD07012O006A010400014O007000055O00122O00060059012O00122O0007005A015O0005000700024O00040004000500202O0004000400114O00040002000200062O000400DD07013O0004E03O00DD07012O006A010400094O00BC00055O00122O0006005B012O00122O0007005C015O0005000700024O00040004000500202O0004000400354O00040002000200122O0005003A3O00062O000400C9070100050004E03O00C907012O006A010400094O008A01055O00122O0006005D012O00122O0007005E015O0005000700024O00040004000500202O0004000400354O00040002000200122O000500573O00062O000500CD070100040004E03O00CD07012O006A0104000B3O001228000500983O000603000400DD070100050004E03O00DD07012O006A010400044O0056000500053O00202O00050005009D4O000600063O00202O00060006001900122O0008009E6O0006000800024O000600066O00040006000200062O000400DD07013O0004E03O00DD07012O006A01045O0012280005005F012O00122800060060013O0049010400064O001000045O001228000300043O00122800040061012O00122800050062012O00060300050034050100040004E03O00340501001228000400043O00062201030034050100040004E03O00340501000682010200EB070100010004E03O00EB070100122800040063012O00122800050064012O000603000500550A0100040004E03O00550A01001228000400014O0074000500053O001228000600013O000622010400ED070100060004E03O00ED0701001228000500013O001228000600013O00062201050048090100060004E03O00480901001228000600014O0074000700073O001228000800013O00068C010600FD070100080004E03O00FD070100122800080065012O00122800090066012O0006D7000800F6070100090004E03O00F60701001228000700013O001228000800043O00062201080003080100070004E03O00030801001228000500043O0004E03O00480901001228000800013O00068C0107000A080100080004E03O000A080100122800080067012O00122800090068012O0006D7000900FE070100080004E03O00FE0701001228000800013O001228000900013O00068C01080012080100090004E03O001208010012280009009A3O001228000A0069012O000603000A003B090100090004E03O003B09012O006A010900014O0070000A5O00122O000B006A012O00122O000C006B015O000A000C00024O00090009000A00202O0009000900114O00090002000200062O000900C008013O0004E03O00C008012O006A010900023O0020140109000900172O003001090002000200068201090037080100010004E03O003708012O006A010900033O0020140109000900172O003001090002000200068201090037080100010004E03O003708012O006A010900063O00208F0109000900CC4O000B00093O00202O000B000B002E4O0009000B000200062O00090061080100010004E03O006108012O006A010900094O0070000A5O00122O000B006C012O00122O000C006D015O000A000C00024O00090009000A00202O0009000900324O00090002000200062O0009006108013O0004E03O006108012O006A010900023O0020140109000900172O003001090002000200068201090041080100010004E03O004108012O006A010900033O0020140109000900172O00300109000200020006A30009005D08013O0004E03O005D08012O006A010900094O00BC000A5O00122O000B006E012O00122O000C006F015O000A000C00024O00090009000A00202O0009000900354O00090002000200122O000A00573O00062O000A005D080100090004E03O005D08012O006A010900063O00208F0109000900CC4O000B00093O00202O000B000B002E4O0009000B000200062O00090061080100010004E03O006108012O006A010900094O0070000A5O00122O000B0070012O00122O000C0071015O000A000C00024O00090009000A00202O0009000900324O00090002000200062O0009006108013O0004E03O006108012O006A0109000B3O001228000A00573O000603000900C00801000A0004E03O00C00801001228000900014O0074000A000B3O001228000C00013O000622010900690801000C0004E03O00690801001228000A00014O0074000B000B3O001228000900043O001228000C00043O000622010900630801000C0004E03O00630801001228000C00013O00068C010C00730801000A0004E03O00730801001228000C0072012O001228000D0073012O000603000C006C0801000D0004E03O006C0801001228000B00013O001228000C00013O000622010B00740801000C0004E03O00740801001228000C0074012O001228000D0074012O000622010C00890801000D0004E03O008908012O006A010C00023O0020A6000C000C00144O000C000200024O000D00016O000E5O00122O000F0075012O00122O00100076015O000E001000024O000D000D000E00202O000D000D00144O000D0002000200062O000C00890801000D0004E03O008908010004E03O009D08012O006A010C00044O0027010D00053O00202O000D000D00184O000E00063O00202O000E000E001900122O001000DD6O000E001000024O000E000E6O000C000E000200062O000C0098080100010004E03O00980801001228000C0077012O001228000D0078012O0006D7000C009D0801000D0004E03O009D08012O006A010C5O001228000D0079012O001228000E007A013O0049010C000E4O0010000C6O006A010C00033O0020C1000C000C00144O000C000200024O000D00016O000E5O00122O000F007B012O00122O0010007C015O000E001000024O000D000D000E00202O000D000D00144O000D0002000200062O000C00C00801000D0004E03O00C008012O006A010C00044O0056000D00053O00202O000D000D00224O000E00063O00202O000E000E001900122O001000DD6O000E001000024O000E000E6O000C000E000200062O000C00C008013O0004E03O00C008012O006A010C5O00121F010D007D012O00122O000E007E015O000C000E6O000C5O00044O00C008010004E03O007408010004E03O00C008010004E03O006C08010004E03O00C008010004E03O006308010012280009007F012O001228000A0080012O0006D7000A003A090100090004E03O003A09012O006A010900014O0070000A5O00122O000B0081012O00122O000C0082015O000A000C00024O00090009000A00202O0009000900114O00090002000200062O0009003A09013O0004E03O003A09012O006A0109000A3O000682010900DB080100010004E03O00DB08012O006A010900094O00A4000A5O00122O000B0083012O00122O000C0084015O000A000C00024O00090009000A00202O0009000900324O00090002000200062O000900E3080100010004E03O00E308012O006A010900083O0020930009000900834O000B00093O00122O000C0008015O000B000B000C4O0009000B000200062O000900E7080100010004E03O00E708012O006A0109000B3O001228000A006E3O0006030009003A0901000A0004E03O003A0901001228000900014O0074000A000A3O001228000B00013O00068C010900F00801000B0004E03O00F00801001228000B0085012O001228000C0086012O0006D7000B00E90801000C0004E03O00E90801001228000A00013O001228000B0087012O001228000C0088012O0006D7000B00F10801000C0004E03O00F10801001228000B00013O000622010A00F10801000B0004E03O00F10801001228000B0089012O001228000C008A012O0006D7000C000A0901000B0004E03O000A09012O006A010B00023O0020A6000B000B00144O000B000200024O000C00016O000D5O00122O000E008B012O00122O000F008C015O000D000F00024O000C000C000D00202O000C000C00144O000C0002000200062O000B000A0901000C0004E03O000A09010004E03O001509012O006A010B00044O006A010C00053O0020D4000C000C00182O0030010B000200020006A3000B001509013O0004E03O001509012O006A010B5O001228000C008D012O001228000D008E013O0049010B000D4O0010000B5O001228000B008F012O001228000C0090012O0006D7000C00270901000B0004E03O002709012O006A010B00033O0020A6000B000B00144O000B000200024O000C00016O000D5O00122O000E0091012O00122O000F0092015O000D000F00024O000C000C000D00202O000C000C00144O000C0002000200062O000B00270901000C0004E03O002709010004E03O003A09012O006A010B00044O006A010C00053O0020D4000C000C00222O0030010B00020002000682010B0031090100010004E03O00310901001228000B0093012O001228000C00F93O000603000B003A0901000C0004E03O003A09012O006A010B5O00121F010C0094012O00122O000D0095015O000B000D6O000B5O00044O003A09010004E03O00F108010004E03O003A09010004E03O00E90801001228000800043O001228000900043O00068C01090042090100080004E03O0042090100122800090096012O001228000A0097012O000603000A000B080100090004E03O000B0801001228000700043O0004E03O00FE07010004E03O000B08010004E03O00FE07010004E03O004809010004E03O00F6070100122800060098012O00122800070099012O0006D7000700F1070100060004E03O00F10701001228000600043O000622010500F1070100060004E03O00F107012O006A0106000A3O0006820106005C090100010004E03O005C09012O006A010600094O00A400075O00122O0008009A012O00122O0009009B015O0007000900024O00060006000700202O0006000600324O00060002000200062O000600BA090100010004E03O00BA09012O006A010600083O00209C0106000600834O000800093O00122O00090008015O0008000800094O00060008000200062O000600BA09013O0004E03O00BA0901001228000600014O0074000700073O0012280008009C012O0012280009009D012O00060300090066090100080004E03O00660901001228000800013O00062201060066090100080004E03O00660901001228000700013O001228000800043O00068C01070075090100080004E03O007509010012280008009E012O0012280009009F012O0006D700080083090100090004E03O008309012O006A0108000D3O0020380008000800AD4O0009000E6O000A000F3O00122O000B001A6O000C000C6O0008000C000200122O000800AC3O00122O000800AC3O00062O000800BA09013O0004E03O00BA0901001278010800AC4O003A000800023O0004E03O00BA0901001228000800013O0006220107006E090100080004E03O006E0901001228000800014O0074000900093O001228000A00013O000622010A0088090100080004E03O00880901001228000900013O001228000A00043O000622010900910901000A0004E03O00910901001228000700043O0004E03O006E0901001228000A00013O00068C010A0098090100090004E03O00980901001228000A00A0012O001228000B00A1012O000603000A008C0901000B0004E03O008C0901001228000A00013O001228000B00013O000622010A00AE0901000B0004E03O00AE09012O006A010B000D3O0020F4000B000B00B34O000C000E6O000D000F3O00122O000E001A6O000F000F6O000B000F000200122O000B00AC3O00122O000B00983O00122O000C00A2012O00062O000B00AD0901000C0004E03O00AD0901001278010B00AC3O0006A3000B00AD09013O0004E03O00AD0901001278010B00AC4O003A000B00023O001228000A00043O001228000B00043O000622010A00990901000B0004E03O00990901001228000900043O0004E03O008C09010004E03O009909010004E03O008C09010004E03O006E09010004E03O008809010004E03O006E09010004E03O00BA09010004E03O006609012O006A010600063O00203000060006002D4O000800093O00202O00080008002E4O00060008000200122O0007003D3O00062O000700ED090100060004E03O00ED09012O006A010600094O007000075O00122O000800A3012O00122O000900A4015O0007000900024O00060006000700202O0006000600324O00060002000200062O000600ED09013O0004E03O00ED09012O006A010600094O00BC00075O00122O000800A5012O00122O000900A6015O0007000900024O00060006000700202O0006000600354O00060002000200122O000700363O00062O000700E9090100060004E03O00E909012O006A010600063O00203000060006002D4O000800093O00202O00080008002E4O00060008000200122O0007003D3O00062O000700ED090100060004E03O00ED09012O006A010600094O007000075O00122O000800A7012O00122O000900A8015O0007000900024O00060006000700202O0006000600324O00060002000200062O000600ED09013O0004E03O00ED0901001228000600A9012O001228000700AA012O000603000700550A0100060004E03O00550A01001228000600014O0074000700083O001228000900013O000622010600F5090100090004E03O00F50901001228000700014O0074000800083O001228000600043O001228000900043O000622010600EF090100090004E03O00EF0901001228000900013O000622010700F8090100090004E03O00F80901001228000800013O001228000900013O0006220108002D0A0100090004E03O002D0A01001228000900013O001228000A00013O00068C010900070A01000A0004E03O00070A01001228000A00AB012O001228000B00AC012O0006D7000A00270A01000B0004E03O00270A01001228000A00013O001228000B00013O000622010A001D0A01000B0004E03O001D0A012O006A010B000D3O00206B000B000B00B34O000C000E6O000D000F3O00122O000E001A6O000F000F6O000B000F000200122O000B00AC3O00122O000B00AC3O00062O000B001A0A0100010004E03O001A0A01001228000B00AD012O001228000C00AE012O000603000C001C0A01000B0004E03O001C0A01001278010B00AC4O003A000B00023O001228000A00043O001228000B00043O00068C010A00240A01000B0004E03O00240A01001228000B00FD3O001228000C00AF012O000622010B00080A01000C0004E03O00080A01001228000900043O0004E03O00270A010004E03O00080A01001228000A00043O00062201092O000A01000A0004E04O000A01001228000800043O0004E03O002D0A010004E04O000A01001228000900043O00068C010800340A0100090004E03O00340A01001228000900B0012O001228000A00B1012O0006D7000A00FC090100090004E03O00FC09012O006A0109000D3O00206B0009000900AD4O000A000E6O000B000F3O00122O000C001A6O000D000D6O0009000D000200122O000900AC3O00122O000900AC3O00062O000900430A0100010004E03O00430A01001228000900B2012O001228000A00B3012O000622010900550A01000A0004E03O00550A01001278010900AC4O003A000900023O0004E03O00550A010004E03O00FC09010004E03O00550A010004E03O00F809010004E03O00550A010004E03O00EF09010004E03O00550A010004E03O00F107010004E03O00550A010004E03O00ED07010004E03O00550A010004E03O003405010004E03O00550A010004E03O000B00010004E03O00550A010004E03O000200012O003C012O00017O005C3O00028O00026O00F03F025O00C09240025O00508A40027O0040025O0035B340025O00F09640030C3O0022EEA1CF385401DCB0CC3C4A03063O003A648FC4A351030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66030A3O00446562752O66446F776E03183O00536B79726561636845786861757374696F6E446562752O66025O00D4A540025O00708B40030C3O004661656C696E6553746F6D70030E3O004973496E4D656C2O6552616E6765026O00144003133O000E4B24A62D76F50F164F63AC2F4CEB0B08027503083O006E7A2243C35F2985025O00BCA240025O0082A94003093O0050A94B4FDA5DB0494703053O00B615D13B2A03073O004973526561647903083O00945FCC3F34ACA44303063O00DED737A57D41030B3O004973417661696C61626C652O033O00436869026O000840025O00288C4003093O00457870656C4861726D026O00204003133O0029C9D61F2OFEE54B3EDC8615E2C4E34F3E919E03083O002A4CB1A67A92A18D03083O001685727DC7BDA7CC03083O00B855ED1B3FB2CFD4030A3O004368694465666963697403083O00436869427572737403093O004973496E52616E6765026O00444003133O000B5100600A4C1B4C1C19064F0D570C4D48085D03043O003F683969025O00B89F40025O00806C40025O00288240025O00DCB140025O00806340025O008DB04003073O0086820CF97860A003063O0016C5EA65AE1903073O0043686957617665025O00606F40025O00907A4003123O002E3CACE361AEC1836D3BB5D978AAC5C67C6403083O00E64D54C5BC16CFB703093O00DC0CD6F98089F127F403083O00559974A69CECC190026O00AC40025O00608E40025O00A89C40025O005C904003143O00A1F85DB6E83FACE15FBEA40FB4E543B6F640F5B203063O0060C4802DD384025O00988A40025O00F88E40025O00406B4003163O00C5E3740C89D2C1FE701583E8FFF17C13B5C8F7E26C0403063O00BC2O961961E603063O00EA855E1B09FF03063O008DBAE93F626C031C3O0053752O6D6F6E57686974655469676572537461747565506C6179657203223O00E2FF21BB2AFFD53BBE2CE5EF13A22CF6EF3E8936E5EB38A320B1E53CB32BF4F86CE403053O0045918A4CD603063O0053DA9B9AB00403063O007610AF2OE9DF025O001AAB40025O0006AC40031C3O0053752O6D6F6E57686974655469676572537461747565437572736F72025O007AA040025O0050874003223O00989138B6E185429C8C3CAFEBB469828330A9D198698A9020BEAE846D8E8A30A9AED903073O001DEBE455DB8EEB03093O0018CCAAD87B6626403003083O00325DB4DABD172E4703083O00FDAC526E51CE5BCA03073O0028BEC43B2C24BC025O00CC9B40025O00FEAB4003133O00395DCCB1F642053D57D1F4F56D083240CEF4AE03073O006D5C25BCD49A1D007F012O0012283O00014O0074000100023O0026BF3O00782O0100020004E03O00782O01002EE800040004000100030004E03O000400010026BF00010004000100010004E03O00040001001228000200013O0026BF0002006F000100020004E03O006F0001001228000300013O0026BF00030010000100020004E03O00100001001228000200053O0004E03O006F0001002EE80007000C000100060004E03O000C0001000E512O01000C000100030004E03O000C00012O006A01046O0070000500013O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004002C00013O0004E03O002C00012O006A010400023O00207701040004000B4O00065O00202O00060006000C4O00040006000200262O0004002C000100050004E03O002C00012O006A010400023O00208F01040004000D4O00065O00202O00060006000E4O00040006000200062O0004002E000100010004E03O002E0001002EE8000F003F000100100004E03O003F00012O006A010400034O001C01055O00202O0005000500114O000600076O000800023O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O0004003F00013O0004E03O003F00012O006A010400013O001228000500143O001228000600154O0049010400064O001000045O002EE80016006D000100170004E03O006D00012O006A01046O0070000500013O00122O000600183O00122O000700196O0005000700024O00040004000500202O00040004001A4O00040002000200062O0004006D00013O0004E03O006D00012O006A01046O0070000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004006D00013O0004E03O006D00012O006A010400043O00201401040004001E2O00300104000200020026BF0004006D0001001F0004E03O006D0001002EA701200013000100200004E03O006D00012O006A010400034O001C01055O00202O0005000500214O000600076O000800023O00202O00080008001200122O000A00226O0008000A00024O000800086O00040008000200062O0004006D00013O0004E03O006D00012O006A010400013O001228000500233O001228000600244O0049010400064O001000045O001228000300023O0004E03O000C00010026BF000200970001001F0004E03O009700012O006A01036O0070000400013O00122O000500253O00122O000600266O0004000600024O00030003000400202O00030003001A4O00030002000200062O0003007E2O013O0004E03O007E2O012O006A010300043O00201401030003001E2O0030010300020002000E3A0102007E2O0100030004E03O007E2O012O006A010300043O0020140103000300272O0030010300020002000E2E0105007E2O0100030004E03O007E2O012O006A010300054O00D300045O00202O0004000400284O000500023O00202O00050005002900122O0007002A6O0005000700024O000500056O000600016O00030006000200062O0003007E2O013O0004E03O007E2O012O006A010300013O00121F0104002B3O00122O0005002C6O000300056O00035O00044O007E2O01000E51010500F7000100020004E03O00F70001001228000300014O0074000400043O002E8F002E009B0001002D0004E03O009B0001000E512O01009B000100030004E03O009B0001001228000400013O0026BF000400F0000100010004E03O00F00001001228000500013O002EE8002F00EB000100300004E03O00EB00010026BF000500EB000100010004E03O00EB0001002E8F003100CB000100320004E03O00CB00012O006A01066O0070000700013O00122O000800333O00122O000900346O0007000900024O00060006000700202O00060006001A4O00060002000200062O000600CB00013O0004E03O00CB00012O006A010600043O0020140106000600272O0030010600020002000E2E010500CB000100060004E03O00CB00012O006A010600034O003400075O00202O0007000700354O000800096O000A00023O00202O000A000A002900122O000C002A6O000A000C00024O000A000A6O0006000A000200062O000600C6000100010004E03O00C60001002E8F003700CB000100360004E03O00CB00012O006A010600013O001228000700383O001228000800394O0049010600084O001000066O006A01066O00A4000700013O00122O0008003A3O00122O0009003B6O0007000900024O00060006000700202O00060006001A4O00060002000200062O000600D7000100010004E03O00D70001002E8F003C00EA0001003D0004E03O00EA0001002E8F003F00EA0001003E0004E03O00EA00012O006A010600034O001C01075O00202O0007000700214O000800096O000A00023O00202O000A000A001200122O000C00226O000A000C00024O000A000A6O0006000A000200062O000600EA00013O0004E03O00EA00012O006A010600013O001228000700403O001228000800414O0049010600084O001000065O001228000500023O0026BF000500A3000100020004E03O00A30001001228000400023O0004E03O00F000010004E03O00A30001000E51010200A0000100040004E03O00A000010012280002001F3O0004E03O00F700010004E03O00A000010004E03O00F700010004E03O009B00010026BF00020009000100010004E03O00090001001228000300014O0074000400043O0026BF000300FB000100010004E03O00FB0001001228000400013O002EA701420006000100420004E03O00042O010026BF000400042O0100020004E03O00042O01001228000200023O0004E03O00090001002EE8004400FE000100430004E03O00FE00010026BF000400FE000100010004E03O00FE00012O006A01056O0070000600013O00122O000700453O00122O000800466O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500442O013O0004E03O00442O012O006A010500063O0006A3000500442O013O0004E03O00442O012O006A010500074O000C000600013O00122O000700473O00122O000800486O00060008000200062O0005002D2O0100060004E03O002D2O012O006A010500054O0056000600083O00202O0006000600494O000700023O00202O00070007001200122O000900136O0007000900024O000700076O00050007000200062O000500442O013O0004E03O00442O012O006A010500013O00121F0106004A3O00122O0007004B6O000500076O00055O00044O00442O012O006A010500074O000C000600013O00122O0007004C3O00122O0008004D6O00060008000200062O000500442O0100060004E03O00442O01002EA7014E00030001004F0004E03O00372O010004E03O00442O012O006A010500054O006A010600083O0020D40006000600502O00300105000200020006820105003F2O0100010004E03O003F2O01002EE8005100442O0100520004E03O00442O012O006A010500013O001228000600533O001228000700544O0049010500074O001000056O006A01056O0070000600013O00122O000700553O00122O000800566O0006000800024O00050005000600202O00050005001A4O00050002000200062O0005005D2O013O0004E03O005D2O012O006A01056O0070000600013O00122O000700573O00122O000800586O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005005D2O013O0004E03O005D2O012O006A010500043O0020140105000500272O0030010500020002000E7C001F005F2O0100050004E03O005F2O01002E8F005A00702O0100590004E03O00702O012O006A010500034O001C01065O00202O0006000600214O000700086O000900023O00202O00090009001200122O000B00226O0009000B00024O000900096O00050009000200062O000500702O013O0004E03O00702O012O006A010500013O0012280006005B3O0012280007005C4O0049010500074O001000055O001228000400023O0004E03O00FE00010004E03O000900010004E03O00FB00010004E03O000900010004E03O007E2O010004E03O000400010004E03O007E2O010026BF3O0002000100010004E03O00020001001228000100014O0074000200023O0012283O00023O0004E03O000200012O003C012O00017O006A3O00028O00025O00309F40025O001CA740025O00B2B14003133O003893B64D0082AB421F8FA1730289A0480495A003043O00246BE7C403073O0049735265616479030B3O0069BDB789592OB08154A6B603043O00E73DD5C2030B3O004973417661696C61626C65026O000840030C3O0043617374546172676574496603133O00537472696B656F6674686557696E646C6F72642O033O0004AC2503043O001369CD5D030E3O004973496E4D656C2O6552616E6765026O00144003223O00BA1CCC8834AC37D18700BD00DBBE28A006DA8D30BB0C9E833BAB37CD842BBC189ED303053O005FC968BEE1030C3O008DC4CFCBABDED2DA8DD9C4D903043O00AECFABA1030A3O0049734361737461626C652O033O00436869026O001040026O006640025O0076A24003063O00DDF20CEAFDC503063O00B78D9E6D9398025O000CA440025O0040564003123O00426F6E656475737442726577506C6179657203093O004973496E52616E6765026O00204003193O002E06E809281CF518130BF4093B49E4082E36F509381CF64C7803043O006C4C6986025O00D49D40025O005BB040030C3O00C8CABFE7C7F9C8B0F5C7E4CB03053O00AE8BA5D181030C3O00426F6E656475737442726577026O00444003193O00A1BCECC4C216636C9CB1F0C4D143727CA18CF1C4D2166038F703083O0018C3D382A1A66310025O002O7040025O0009B24003063O006516FB3F5C0403063O00762663894C3303123O00426F6E656475737442726577437572736F7203193O00FF290B170D35EE323A101B25EA6607160B1FEE2311071960A903063O00409D46657269025O00688740025O00C2B14003123O0065A6A2EE0900BDA9E71552E884F60253A7B503053O007020C8C78303063O0045786973747303093O0043616E412O7461636B03193O002E5F52BDC7BE31386F5EAAC6BC622E545E87D0AE3639401CEC03073O00424C303CD8A3CB026O00F03F027O0040025O0043B240025O004EB140030C3O000824A0407D253DB5687F292303053O00164A48C123030C3O00426C61636B6F75744B69636B03133O001B71ED4A2070EA5F086BE55F2377D44D227AEC03043O00384C19842O033O0053C8A503053O00AF3EA1CB4603193O003ED1C2103E33C8D72C3E35DEC8533738DFFC003028C8D3536D03053O00555CBDA373025O002C9540025O0024994003093O001DA5373D3B9C31342403043O005849CC5003093O00546967657250616C6D030A3O004368694465666963697403063O0042752O66557003153O0053746F726D4561727468416E644669726542752O66025O00A9B1402O033O00238A1E03063O00BA4EE370264903163O00E85EFA504145EC56F1581378F855C246566EE947BD2O03063O001A9C379D3533025O00E2A440025O00BEB140030D3O00888F6AFA51C917AF8852FA5CC503073O0044DAE619933FAE030D3O00526973696E6753756E4B69636B03133O009A225A5EBAA4245468A4AC2D5C4286B824504403053O00D6CD4A332C2O033O00F745EC03053O00179A2C829C031C3O0003AFBEA738142EB5B8A0092O18A5A6EE34171399BEAB220601E6FCFE03063O007371C6CDCE56025O0006B340025O00089F40030D3O00B65EED538A50CD4F8A7CF7598F03043O003AE4379E03133O008381D93C30A43BB3ADC22F3BA23B849CDE2D3403073O0055D4E9B04E5CCD025O0064A9402O033O0047518603043O00822A38E8031C3O00F8BC37EA4E38D5A631ED7F34E3B62FA3423BE88A37E6542AFAF575B103063O005F8AD544832000B9012O0012283O00014O0074000100013O002EA701023O000100020004E03O000200010026BF3O0002000100010004E03O00020001001228000100013O0026BF000100CD000100010004E03O00CD0001001228000200013O00260C0102000E000100010004E03O000E0001002EE8000400C8000100030004E03O00C800012O006A01036O0070000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003003D00013O0004E03O003D00012O006A01036O0070000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003D00013O0004E03O003D00012O006A010300023O000E3A010B003D000100030004E03O003D00012O006A010300033O00200E01030003000C4O00045O00202O00040004000D4O000500046O000600013O00122O0007000E3O00122O0008000F6O0006000800024O000700056O000800086O000900063O00202O00090009001000122O000B00116O0009000B00024O000900096O00030009000200062O0003003D00013O0004E03O003D00012O006A010300013O001228000400123O001228000500134O0049010300054O001000036O006A01036O0070000400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300164O00030002000200062O0003005000013O0004E03O005000012O006A010300074O00B10003000100020006A30003005000013O0004E03O005000012O006A010300083O0020140103000300172O0030010300020002000E7C00180052000100030004E03O00520001002E8F001A00C7000100190004E03O00C700012O006A010300094O0047010400013O00122O0005001B3O00122O0006001C6O00040006000200062O0003005B000100040004E03O005B0001002EA7011D00130001001E0004E03O006C00012O006A0103000A4O00560004000B3O00202O00040004001F4O000500063O00202O00050005002000122O000700216O0005000700024O000500056O00030005000200062O000300C700013O0004E03O00C700012O006A010300013O00121F010400223O00122O000500236O000300056O00035O00044O00C70001002E8F00240086000100250004E03O008600012O006A010300094O000C000400013O00122O000500263O00122O000600276O00040006000200062O00030086000100040004E03O008600012O006A0103000A4O005600045O00202O0004000400284O000500063O00202O00050005002000122O000700296O0005000700024O000500056O00030005000200062O000300C700013O0004E03O00C700012O006A010300013O00121F0104002A3O00122O0005002B6O000300056O00035O00044O00C70001002EE8002C00A00001002D0004E03O00A000012O006A010300094O000C000400013O00122O0005002E3O00122O0006002F6O00040006000200062O000300A0000100040004E03O00A000012O006A0103000A4O00560004000B3O00202O0004000400304O000500063O00202O00050005002000122O000700296O0005000700024O000500056O00030005000200062O000300C700013O0004E03O00C700012O006A010300013O00121F010400313O00122O000500326O000300056O00035O00044O00C70001002EE8003300C7000100340004E03O00C700012O006A010300094O000C000400013O00122O000500353O00122O000600366O00040006000200062O000300C7000100040004E03O00C700012O006A0103000C3O0006A3000300C700013O0004E03O00C700012O006A0103000C3O0020140103000300372O00300103000200020006A3000300C700013O0004E03O00C700012O006A010300083O0020140103000300382O006A0105000C4O005C0003000500020006A3000300C700013O0004E03O00C700012O006A0103000A4O00560004000B3O00202O0004000400304O000500063O00202O00050005002000122O000700296O0005000700024O000500056O00030005000200062O000300C700013O0004E03O00C700012O006A010300013O001228000400393O0012280005003A4O0049010300054O001000035O0012280002003B3O0026BF0002000A0001003B0004E03O000A00010012280001003B3O0004E03O00CD00010004E03O000A000100260C2O0100D10001003C0004E03O00D10001002E8F003D00402O01003E0004E03O00402O012O006A01026O0070000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300202O0002000200074O00020002000200062O000200072O013O0004E03O00072O012O006A0102000D4O006A01035O0020D40003000300412O00300102000200020006A3000200072O013O0004E03O00072O012O006A01026O00A4000300013O00122O000400423O00122O000500436O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200072O0100010004E03O00072O012O006A010200074O00B1000200010002000682010200072O0100010004E03O00072O012O006A010200033O00200E01020002000C4O00035O00202O0003000300414O000400046O000500013O00122O000600443O00122O000700456O0005000700024O0006000E6O000700076O000800063O00202O00080008001000122O000A00116O0008000A00024O000800086O00020008000200062O000200072O013O0004E03O00072O012O006A010200013O001228000300463O001228000400474O0049010200044O001000025O002EE8004800B82O0100490004E03O00B82O012O006A01026O0070000300013O00122O0004004A3O00122O0005004B6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200B82O013O0004E03O00B82O012O006A0102000D4O006A01035O0020D400030003004C2O00300102000200020006A3000200B82O013O0004E03O00B82O012O006A010200083O00201401020002004D2O0030010200020002000E2E013C00B82O0100020004E03O00B82O012O006A010200083O00206401020002004E4O00045O00202O00040004004F4O00020004000200062O000200B82O013O0004E03O00B82O01002EA701500093000100500004E03O00B82O012O006A010200033O00200E01020002000C4O00035O00202O00030003004C4O000400046O000500013O00122O000600513O00122O000700526O0005000700024O0006000F6O000700076O000800063O00202O00080008001000122O000A00116O0008000A00024O000800086O00020008000200062O000200B82O013O0004E03O00B82O012O006A010200013O00121F010300533O00122O000400546O000200046O00025O00044O00B82O0100260C2O0100442O01003B0004E03O00442O01002E8F00560007000100550004E03O000700012O006A01026O0070000300013O00122O000400573O00122O000500586O0003000500024O00020002000300202O0002000200074O00020002000200062O0002007B2O013O0004E03O007B2O012O006A0102000D4O006A01035O0020D40003000300592O00300102000200020006A30002007B2O013O0004E03O007B2O012O006A010200083O0020140102000200172O0030010200020002000E2E0111007B2O0100020004E03O007B2O012O006A01026O0070000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002007B2O013O0004E03O007B2O012O006A010200033O00200E01020002000C4O00035O00202O0003000300594O000400046O000500013O00122O0006005C3O00122O0007005D6O0005000700024O0006000E6O000700076O000800063O00202O00080008001000122O000A00116O0008000A00024O000800086O00020008000200062O0002007B2O013O0004E03O007B2O012O006A010200013O0012280003005E3O0012280004005F4O0049010200044O001000025O002EE8006100B42O0100600004E03O00B42O012O006A01026O0070000300013O00122O000400623O00122O000500636O0003000500024O00020002000300202O0002000200074O00020002000200062O000200B42O013O0004E03O00B42O012O006A0102000D4O006A01035O0020D40003000300592O00300102000200020006A3000200B42O013O0004E03O00B42O012O006A010200023O000E2E013C00B42O0100020004E03O00B42O012O006A01026O0070000300013O00122O000400643O00122O000500656O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200B42O013O0004E03O00B42O01002EA70166001A000100660004E03O00B42O012O006A010200033O00200E01020002000C4O00035O00202O0003000300594O000400046O000500013O00122O000600673O00122O000700686O0005000700024O0006000E6O000700076O000800063O00202O00080008001000122O000A00116O0008000A00024O000800086O00020008000200062O000200B42O013O0004E03O00B42O012O006A010200013O001228000300693O0012280004006A4O0049010200044O001000025O0012280001003C3O0004E03O000700010004E03O00B82O010004E03O000200012O003C012O00017O0059012O00028O00026O00F03F025O0042A140025O00FAAE40025O000AB340025O0094A640025O00D49740025O00A8B140025O00308A40025O00308840025O00D3B040025O00F2AB40025O008EB240025O00EEAF4003173O00C123BF4079B9F9ADED239D47778BC9B1FC289D4675B9D303083O00D8884DC92F12DCA1030A3O0049734361737461626C6503093O0054696D65546F446965026O003940026O005E40026O004E40030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66027O0040025O00804B4003083O001EE939DF06D5963403073O00E24D8C4BBA68BC030A3O00432O6F6C646F776E5570026O000840030B3O00426C2O6F646C7573745570026O00374003173O00496E766F6B655875656E5468655768697465546967657203093O004973496E52616E6765026O00444003243O00B0C0C63044BCF1C82A4AB7F1C4374A86D9D8365BBCF1C43648BCDC903C4B86DDD5390FEF03053O002FD9AEB05F03113O008BC97910BF717934ACD5570CB6727134BD03083O0046D8BD1662D23418030C3O00F8D0AD82D7CFCCB7A5C1DFC803053O00B3BABFC3E7030B3O004973417661696C61626C65026O003E40030C3O00DB3016E1FD2A0BF0DB2D1DF303043O0084995F78030F3O00432O6F6C646F776E52656D61696E73026O0010402O033O0043686903063O0042752O66557003103O00426F6E65647573744272657742752O66030C3O0093BD0028F3CFB3A5901C28E003073O00C0D1D26E4D97BA03173O00C90D34E6F4C1D81627E7CBCCE5342AE0EBC1D40A25ECED03063O00A4806342899F03113O00339DE6AC0DACE8AC1481C8B004AFE0AC0503043O00DE60E98903103O0046752O6C526563686172676554696D6503113O0053746F726D4561727468416E6446697265031D3O00AAA7A80D85CCF5B8A1B317B7F2FEBD8CA1169AF6B0BAB7980C8DF5B0E103073O0090D9D3C77FE893025O0042B240025O00B07840025O00B8AC40025O00806940025O00F6A740025O0060A74003163O00BFCD1BD4B75EBBD01FCDBD6485DF13CB8B448DCC03DC03063O0030ECB876B9D803173O00CCB3413FC431DDA8523EFB3CE08A5F39DB31D1B45035DD03063O005485DD3750AF03173O0094E932A9CC5985F221A8F354B8D02CAFD35989EE23A3D503063O003CDD8744C6A7026O00494003063O00DEB1F99A47CB03063O00B98EDD98E322031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572030E3O004973496E4D656C2O6552616E6765026O00144003223O004BD05AF74C3DC84FCD5EEE460CE351C252E87C20E359D142FF0330F367D652FC036103073O009738A5379A235303063O00835617FDAF5103043O008EC02365031C3O0053752O6D6F6E57686974655469676572537461747565437572736F72025O003AA340025O00C4A84003223O00C56024AEE8829301DE7C3DA6D898A511D36716B0F38DB803D3352AA7D89FA910962703083O0076B61549C387ECCC03173O0021320C4F0F08C51D3914740C08CA00350E453004FA0D2E03073O009D685C7A20646D030C3O0081A9C1CF39329EBF81B4CADD03083O00CBC3C6AFAA5D47ED030C3O000C4430D05504EF3A692CD04603073O009C4E2B5EB53171025O003C9C40025O0038B04003243O007BE6D2AC002O466AFDC1AD34577177D7D3AB02577C4DFCCDA40E513971ECFBB00E45392603073O00191288A4C36B23025O0099B140025O003EAA40025O0054A240025O00189A40025O006EA740025O007FB140030D3O0035838632344D068C891426551803063O003974EDE5574703173O0083BFFBE87CEB7FBFB4E3D37FEB70A2B8F9E243E740AFA303073O0027CAD18D87178E026O003440030D3O00416E6365737472616C43612O6C03183O00FE3D0A0F21ECED32053531F9F33F490936C7EC360F4A60AA03063O00989F53696A5203093O00A3CA5EFDCD7A94D44803063O003CE1A63192A903173O00061039250A02170B2A24350F2A29272315021B17282F1303063O00674F7E4F4A6103093O00426C2O6F6446757279025O002EAA40025O0068A54003143O00B873DC7C5A25BC6AC16A1E19BE40C076585AE82B03063O007ADA1FB3133E030C3O0006EC9D3E415534C78D3C5D5203063O003A5283E85D29025O0070A340026O006D40025O00606E40025O00107140030C3O00546F7563686F66446561746803083O00446562752O66557003123O00426F6E656475737442726577446562752O66026O002440025O00388440025O0080AB40025O00407C40025O00ECA44003043O004755494403243O005710AFA40A2O4C1985A307725717FAA4064C501ABCE70F724A11F7B30361441AAEE7532503063O0013237FDAC76203073O0047657454696D65030E3O0030FA19F628FA18E519EF39F51DEB03043O00827C9B6A025O00408F40025O00949140025O0057B340025O00C0A040025O001BB140025O0076A540025O00806040030E3O00F9CAE5BB97F76EB8D0DFC5B8A2E603083O00DFB5AB96CFC3961C026O00594003233O005835F6AD017335E5910D493BF7A6494F3EDCBD0C4A7AECA80F012EE2BC0E492EA3FF5F03053O00692C5A83CE025O00D08240025O000AA84003243O00EBEFA7BA0001F0E68DBD0D3FEBE8F2BA0C01ECE5B4F9053FF6EEFFAD092CF8E5A6F9596603063O005E9F80D2D968030E3O007CF815AB6B7EEB7D55ED35A85E6F03083O001A309966DF3F1F99025O0020A040025O002EA140030E3O002E41FEE73641FFF40754DEE4035003043O009362208D025O00688440025O008AAF4003233O000C4CF6C90E69441E7CE7CF0742435840E7F515534D584CE5CC4B424A0A44E6DE46071303073O002B782383AA6636025O0078A340025O002OAC4003093O004973496E506172747903083O004973496E52616964025O0014A340025O0002A640030C3O00B758C51655308573D514493703063O005FE337B0753D03073O004973526561647903083O0042752O66446F776E030C3O00536572656E69747942752O6603063O004865616C7468030B3O0042752O6652656D61696E73031F3O0048692O64656E4D617374657273466F7262692O64656E546F75636842752O66025O0082AE40025O00B4AD40025O0085B24003243O000C713648A327712574AF1D7F3743EB1B7A1C58AE1E3E2E4AA21633374AB91F7B370BFA4C03053O00CB781E432B030E3O00DD245EFBEDF0374AEACDC2324CFF03053O00B991452D8F025O00FC9D40025O00D2A240025O00388340025O00A08A40030E3O00A61E0AB2E88B0D1EA3C8B90818B603053O00BCEA7F79C6025O0088AE40025O0068874003233O002C3D0680300D1C85073616822C3A53803C0D00863E721C853E7F07822A35169778634703043O00E3585273025O00A4AC40025O00308540030C3O00600992B5ADBF827F0795BBA403073O00E43466E7D6C5D003173O0037EE63C5E18E21C31BEE41C2EFBC11DF0AE541C3ED8E0B03083O00B67E8015AA8AEB79025O00805640026O00304003173O00A2D423E98D1608138ED401EE8324380F9FDF01EF81162203083O0066EBBA5586E67350025O00E06340030C3O00546F7563686F664B61726D6103183O0043032B5C7AEB2D5133355E60D923170F3A6061D124175E6E03073O0042376C5E3F12B4025O00808C40025O0038A640025O00F08140025O00CCB24003113O00CB3B313AD8600356EC271F26D1630B56FD03083O0024984F5E48B52562030C3O00F5D7493AD3CD542BF5CA422803043O005FB7B827026O002E4003113O00862BE83459A503A72BEF075A8424BC2DE203073O0062D55F874634E003173O00D7ADDF785FFB9BDC725ACAABCC405CF7B7CC435DF9A6DB03053O00349EC3A917025O008CA840031D3O0069A83D668B0A7E8A68A83A4B873B7FB47CB52071C6367FB469B92O34DF03083O00EB1ADC5214E6551B025O0058A540025O0070AC40030C3O00AAAEE7C7709DB2FDE0668DB603053O0014E8C189A203153O0053746F726D4561727468416E644669726542752O66026O002640030A3O00446562752O66446F776E03063O0012D3C4BFE29E03083O001142BFA5C687EC77025O00E89C40025O00807A4003123O00426F6E656475737442726577506C61796572026O002040025O00E88C40025O0080664003173O000D2OA016FBFDFFC530ADBC16E8A8EFD530BCAB15BFB9BC03083O00B16FCFCE739F888C030C3O0026861E12DD5D52049D191BDA03073O003F65E97074B42F025O0008A540025O00408D40030C3O00426F6E65647573744272657703173O00C134E317FC23D02FD210EA33D47BEE16C725C63DAD43A803063O0056A35B8D7298025O00709440025O0094924003063O00701E6660354103053O005A336B141303123O00426F6E656475737442726577437572736F72025O00C07340025O00DBB24003173O008FFF8BEA3998E391D03F9FF592AF3E89CF96EA3BCDA1D503053O005DED90E58F025O0066A040025O0032A64003123O0030F8F514120600F8F41C190636E3E20A045403063O0026759690796B03063O0045786973747303093O0043616E412O7461636B03173O002FB4E03F29AEFD2E12B9FC3F3AFBED3E12A8EB3C6DEABE03043O005A4DDB8E025O00EAAF40025O00307040025O0015B340025O00C07540025O00B07D40025O00BCAF40030C3O00C40B2F3C481269F226333C5B03073O001A866441592C67030C3O00D3EC3E26A0E4F02401B62OF403053O00C49183504303113O002DA4091A15CD1FA2120039E61A960F1A1D03063O00887ED066687803073O004368617267657303113O004B9EC151A2773C436C82EF4DAB7434437D03083O003118EAAE23CF325D03173O0025FCEB877A09CAE88D7F38FAF8BF7905E6F8BC780BF7EF03053O00116C929DE803173O0062CD02E224AD73D611E31BA04EF41CE43BAD7FCA13E83D03063O00C82BA3748D4F026O002A4003113O008C223291BDD1E2AD2235A2BEF0C5B6243803073O0083DF565DE3D09403113O00D051B9A41090E257A2BE3CBBE763BFA41803063O00D583252OD67D025O0060AE40025O00908C40025O00F89140025O00508A40025O00989D40025O00E2A24003113O00153F2AADEC032A37ABE907252199E8342E03053O0081464B45DF03113O0075DFFCFB71CA47D9E7E15DE142EDFAFB7903063O008F26AB93891C03173O00F98CAFFC08E6ECC587B7C70BE6E3D88BADF637EAD3D59003073O00B4B0E2D993638303113O00E0AD2015DE9C2E15C7B10E09D79F2615D603043O0067B3D94F030B3O006CBE0FC15283A56CA20ECC03073O00C32AD77CB521EC026O00224003133O003A513E2C29F1035E132C24FF0257072O2BFB0503063O00986D39575E45026O002840025O0020B040025O00DEA540025O00C4A040025O00689040031E3O00EAC305B1B3ED51A9EBC3029CBFDC5097FFDE18A6FED15097EAD20CE3EF8003083O00C899B76AC3DEB234025O00B8B140025O0050864003093O00952ODFC4CBAD4ABCD203073O0025D3B6ADA1A9C103173O00DE345BD6237E81E23F43ED207E8EFF3359DC1C72BEF22803073O00D9975A2DB9481B03093O0046697265626C2O6F6403133O00C575F51754CF73E82O16C078D80153C53CB54403053O0036A31C8772030A3O000ADE4F914B6D23D2538503063O001F48BB3DE22E03173O00EA0855DD4C7B1CD6034DE64F7B13CB0F57D7737723C61403073O0044A36623B2271E025O0038AC40025O00BAA540030A3O004265727365726B696E6703143O00BC75C8D406A78818B0779AC4078A9014B830889F03083O0071DE10BAA763D5E3030B3O000C0FFCF9283AE9FF2D05E803043O00964E6E9B030B3O004261676F66547269636B7303173O0087C420DEAB18805497CC24EAB75EBC44BAD622E7E44DEF03083O0020E5A54781C47EDF030E3O00EF80C38995C6E99CC0868CD0CD9D03063O00B5A3E9A42OE1030E3O004C69676874734A7564676D656E7403193O005C82397F4498017D458F397A55852A37538F0164558D7E240203043O001730EB5E00B3062O0012283O00014O0074000100023O000E512O01000700013O0004E03O00070001001228000100014O0074000200023O0012283O00023O002EE800030002000100040004E03O000200010026BF3O0002000100020004E03O00020001002E8F0006000B000100050004E03O000B00010026BF0001000B000100010004E03O000B0001001228000200013O00260C01020014000100010004E03O00140001002EE80008008C2O0100070004E03O008C2O01001228000300014O0074000400043O00260C0103001A000100010004E03O001A0001002E8F000900160001000A0004E03O00160001001228000400013O00260C0104001F000100020004E03O001F0001002EE8000B00D70001000C0004E03O00D70001001228000500013O002E8F000E00D20001000D0004E03O00D200010026BF000500D2000100010004E03O00D200012O006A01066O0070000700013O00122O0008000F3O00122O000900106O0007000900024O00060006000700202O0006000600114O00060002000200062O0006006D00013O0004E03O006D00012O006A010600023O0020140106000600122O0030010600020002000E3A01130036000100060004E03O003600012O006A010600033O000E5E0114005C000100060004E03O005C00012O006A010600033O00265001060054000100150004E03O005400012O006A010600023O0020220006000600164O00085O00202O0008000800174O00060008000200262O00060047000100180004E03O004700012O006A010600023O0020D60006000600164O00085O00202O0008000800174O000600080002000E2O00190054000100060004E03O005400012O006A01066O0070000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006005400013O0004E03O005400012O006A010600043O00266A0006005C0001001D0004E03O005C00012O006A010600053O00201401060006001E2O00300106000200020006820106005C000100010004E03O005C00012O006A010600033O0026500106006D0001001F0004E03O006D00012O006A010600064O001C01075O00202O0007000700204O000800096O000A00023O00202O000A000A002100122O000C00226O000A000C00024O000A000A6O0006000A000200062O0006006D00013O0004E03O006D00012O006A010600013O001228000700233O001228000800244O0049010600084O001000066O006A01066O0070000700013O00122O000800253O00122O000900266O0007000900024O00060006000700202O0006000600114O00060002000200062O000600D100013O0004E03O00D100012O006A01066O0070000700013O00122O000800273O00122O000900286O0007000900024O00060006000700202O0006000600294O00060002000200062O000600D100013O0004E03O00D100012O006A010600033O002650010600930001002A0004E03O009300012O006A01066O0054010700013O00122O0008002B3O00122O0009002C6O0007000900024O00060006000700202O00060006002D4O00060002000200262O000600930001002E0004E03O009300012O006A010600053O00201401060006002F2O0030010600020002000E7C002E00B0000100060004E03O00B000012O006A010600053O00208F0106000600304O00085O00202O0008000800314O00060008000200062O000600B0000100010004E03O00B000012O006A010600074O00B1000600010002000682010600D1000100010004E03O00D100012O006A010600043O000E2E011D00D1000100060004E03O00D100012O006A01066O006B010700013O00122O000800323O00122O000900336O0007000900024O00060006000700202O00060006002D4O00060002000200262O000600D1000100180004E03O00D100012O006A010600053O00201401060006002F2O0030010600020002000E2E011800D1000100060004E03O00D100012O006A010600083O000682010600C5000100010004E03O00C500012O006A01066O0071000700013O00122O000800343O00122O000900356O0007000900024O00060006000700202O00060006002D4O0006000200024O00078O000800013O00122O000900363O00122O000A00376O0008000A00024O00070007000800202O0007000700384O00070002000200062O000700D1000100060004E03O00D100012O006A010600064O00F200075O00202O0007000700394O000800086O00060008000200062O000600D100013O0004E03O00D100012O006A010600013O0012280007003A3O0012280008003B4O0049010600084O001000065O001228000500023O0026BF00050020000100020004E03O00200001001228000400183O0004E03O00D700010004E03O00200001002E8F003D00DD0001003C0004E03O00DD00010026BF000400DD000100180004E03O00DD0001001228000200023O0004E03O008C2O0100260C010400E1000100010004E03O00E10001002EE8003E001B0001003F0004E03O001B0001001228000500013O00260C010500E6000100020004E03O00E60001002EE8004000E8000100410004E03O00E80001001228000400023O0004E03O001B0001000E512O0100E2000100050004E03O00E200012O006A01066O0070000700013O00122O000800423O00122O000900436O0007000900024O00060006000700202O0006000600114O00060002000200062O0006003B2O013O0004E03O003B2O012O006A01066O00A4000700013O00122O000800443O00122O000900456O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006000E2O0100010004E03O000E2O012O006A010600043O000E5E012E000E2O0100060004E03O000E2O012O006A01066O0083010700013O00122O000800463O00122O000900476O0007000900024O00060006000700202O00060006002D4O000600020002000E2O0048000E2O0100060004E03O000E2O012O006A010600033O0026290106003B2O01002A0004E03O003B2O012O006A010600094O000C000700013O00122O000800493O00122O0009004A6O00070009000200062O000600262O0100070004E03O00262O012O006A0106000A4O00560007000B3O00202O00070007004B4O000800023O00202O00080008004C00122O000A004D6O0008000A00024O000800086O00060008000200062O0006003B2O013O0004E03O003B2O012O006A010600013O00121F0107004E3O00122O0008004F6O000600086O00065O00044O003B2O012O006A010600094O0047010700013O00122O000800503O00122O000900516O00070009000200062O0006002E2O0100070004E03O002E2O010004E03O003B2O012O006A0106000A4O006A0107000B3O0020D40007000700522O0030010600020002000682010600362O0100010004E03O00362O01002E8F0054003B2O0100530004E03O003B2O012O006A010600013O001228000700553O001228000800564O0049010600084O001000066O006A01066O0070000700013O00122O000800573O00122O000900586O0007000900024O00060006000700202O0006000600114O00060002000200062O000600742O013O0004E03O00742O012O006A0106000C3O000682010600712O0100010004E03O00712O012O006A010600023O0020140106000600122O0030010600020002000E3A011300712O0100060004E03O00712O012O006A01066O0070000700013O00122O000800593O00122O0009005A6O0007000900024O00060006000700202O0006000600294O00060002000200062O000600712O013O0004E03O00712O012O006A01066O006B010700013O00122O0008005B3O00122O0009005C6O0007000900024O00060006000700202O00060006002D4O00060002000200262O000600712O01004D0004E03O00712O012O006A010600043O002650010600692O01001D0004E03O00692O012O006A010600053O00201401060006002F2O0030010600020002000E7C001D00762O0100060004E03O00762O012O006A010600043O000E2E011D00712O0100060004E03O00712O012O006A010600053O00201401060006002F2O0030010600020002000E7C001800762O0100060004E03O00762O012O006A010600033O00266A000600762O0100130004E03O00762O01002EE8005E00872O01005D0004E03O00872O012O006A010600064O001C01075O00202O0007000700204O000800096O000A00023O00202O000A000A002100122O000C00226O000A000C00024O000A000A6O0006000A000200062O000600872O013O0004E03O00872O012O006A010600013O0012280007005F3O001228000800604O0049010600084O001000065O001228000500023O0004E03O00E200010004E03O001B00010004E03O008C2O010004E03O0016000100260C010200902O0100180004E03O00902O01002E8F006100C3030100620004E03O00C30301001228000300014O0074000400043O0026BF000300922O0100010004E03O00922O01001228000400013O00260C010400992O0100020004E03O00992O01002EE8006300F22O0100640004E03O00F22O01001228000500013O002E8F006500ED2O0100660004E03O00ED2O010026BF000500ED2O0100010004E03O00ED2O012O006A01066O0070000700013O00122O000800673O00122O000900686O0007000900024O00060006000700202O0006000600114O00060002000200062O000600C42O013O0004E03O00C42O012O006A01066O0083010700013O00122O000800693O00122O0009006A6O0007000900024O00060006000700202O00060006002D4O000600020002000E2O002A00B82O0100060004E03O00B82O012O006A0106000C3O000682010600B82O0100010004E03O00B82O012O006A010600033O002650010600C42O01006B0004E03O00C42O012O006A010600064O00F200075O00202O00070007006C4O000800086O00060008000200062O000600C42O013O0004E03O00C42O012O006A010600013O0012280007006D3O0012280008006E4O0049010600084O001000066O006A01066O0070000700013O00122O0008006F3O00122O000900706O0007000900024O00060006000700202O0006000600114O00060002000200062O000600EC2O013O0004E03O00EC2O012O006A01066O0083010700013O00122O000800713O00122O000900726O0007000900024O00060006000700202O00060006002D4O000600020002000E2O002A00DE2O0100060004E03O00DE2O012O006A0106000C3O000682010600DE2O0100010004E03O00DE2O012O006A010600033O002650010600EC2O01006B0004E03O00EC2O012O006A010600064O004A01075O00202O0007000700734O000800086O00060008000200062O000600E72O0100010004E03O00E72O01002EE8007400EC2O0100750004E03O00EC2O012O006A010600013O001228000700763O001228000800774O0049010600084O001000065O001228000500023O000E510102009A2O0100050004E03O009A2O01001228000400183O0004E03O00F22O010004E03O009A2O010026BF000400BC030100010004E03O00BC0301001228000500013O0026BF000500B7030100010004E03O00B703012O006A01066O0070000700013O00122O000800783O00122O000900796O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006007203013O0004E03O007203012O006A0106000D3O0006A30006007203013O0004E03O00720301001228000600014O0074000700093O000E910102000A020100060004E03O000A0201002EE8007A006A0301007B0004E03O006A03012O0074000900093O002EE8007C00C40201007D0004E03O00C402010026BF000700C4020100180004E03O00C402010006A30009007203013O0004E03O007203012O006A010A000E4O006A010B5O0020D4000B000B007E2O0030010A000200020006A3000A007203013O0004E03O007203010006A30008007702013O0004E03O00770201002014010A000900122O0030010A00020002000E5E011500280201000A0004E03O00280201002014010A0009007F2O006A010C5O0020D4000C000C00802O005C000A000C0002000682010A0028020100010004E03O002802012O006A010A00033O00266A000A0028020100810004E03O00280201002EE800830072030100820004E03O00720301002EE800840043020100850004E03O00430201002014010A000900862O0005000A000200024O000B00023O00202O000B000B00864O000B0002000200062O000A00430201000B0004E03O004302012O006A010A00064O001C010B5O00202O000B000B007E4O000C000D6O000E00023O00202O000E000E004C00122O0010004D6O000E001000024O000E000E6O000A000E000200062O000A007203013O0004E03O007203012O006A010A00013O00121F010B00873O00122O000C00886O000A000C6O000A5O00044O00720301001278010A00894O00E1000A000100024O000B000F6O000C00013O00122O000D008A3O00122O000E008B6O000C000E00024O000B000B000C4O000A000A000B00202O000A000A008C4O000B00103O0006DD000A00720301000B0004E03O00720301002E8F008E00530201008D0004E03O005302010004E03O00720301001228000A00014O0074000B000B3O002E8F008F0055020100900004E03O005502010026BF000A0055020100010004E03O00550201001228000B00013O002EE80092005A020100910004E03O005A02010026BF000B005A020100010004E03O005A02012O006A010C000F4O009B010D00013O00122O000E00933O00122O000F00946O000D000F000200122O000E00896O000E000100024O000C000D000E4O000C000A6O000D00113O00122O000E00954O007B010D000E4O0007000C3O00020006A3000C007203013O0004E03O007203012O006A010C00013O00121F010D00963O00122O000E00976O000C000E6O000C5O00044O007203010004E03O005A02010004E03O007203010004E03O005502010004E03O00720301002014010A000900862O0005000A000200024O000B00023O00202O000B000B00864O000B0002000200062O000A00920201000B0004E03O00920201002EE800980072030100990004E03O007203012O006A010A00064O001C010B5O00202O000B000B007E4O000C000D6O000E00023O00202O000E000E004C00122O0010004D6O000E001000024O000E000E6O000A000E000200062O000A007203013O0004E03O007203012O006A010A00013O00121F010B009A3O00122O000C009B6O000A000C6O000A5O00044O00720301001278010A00894O00E1000A000100024O000B000F6O000C00013O00122O000D009C3O00122O000E009D6O000C000E00024O000B000B000C4O000A000A000B00202O000A000A008C4O000B00103O000603000A00A00201000B0004E03O00A002010004E03O00720301001228000A00014O0074000B000B3O002EE8009E00A20201009F0004E03O00A202010026BF000A00A2020100010004E03O00A20201001228000B00013O000E512O0100A70201000B0004E03O00A702012O006A010C000F4O009B010D00013O00122O000E00A03O00122O000F00A16O000D000F000200122O000E00896O000E000100024O000C000D000E4O000C000A6O000D00113O00122O000E00954O007B010D000E4O0007000C3O0002000682010C00BA020100010004E03O00BA0201002E8F00A30072030100A20004E03O007203012O006A010C00013O00121F010D00A43O00122O000E00A56O000C000E6O000C5O00044O007203010004E03O00A702010004E03O007203010004E03O00A202010004E03O00720301002EE800A600DD020100A70004E03O00DD02010026BF000700DD020100010004E03O00DD0201001228000A00013O0026BF000A00D6020100010004E03O00D602012O006A010B00053O002014010B000B00A82O0030010B000200020006F6000800D40201000B0004E03O00D402012O006A010B00053O002014010B000B00A92O0030010B000200022O00190008000B4O0074000900093O001228000A00023O002EA701AA00F3FF2O00AA0004E03O00C90201000E51010200C90201000A0004E03O00C90201001228000700023O0004E03O00DD02010004E03O00C902010026BF0007000B020100020004E03O000B0201002EA701AB000C000100AB0004E03O00EB02012O006A010A00123O0006A3000A00EB02013O0004E03O00EB02012O006A010A00133O0006A3000A00EB02013O0004E03O00EB02012O006A010A00144O00B1000A000100022O008D0109000A3O0004E03O00F602012O006A010A6O0070000B00013O00122O000C00AC3O00122O000D00AD6O000B000D00024O000A000A000B00202O000A000A00AE4O000A0002000200062O000A00F602013O0004E03O00F602012O006A010900023O0006A30009006703013O0004E03O006703010006A30008000E03013O0004E03O000E03012O006A010A00053O002064010A000A00AF4O000C5O00202O000C000C00B04O000A000C000200062O000A000E03013O0004E03O000E03012O006A010A000E4O006A010B5O0020D4000B000B007E2O0030010A000200020006A3000A000E03013O0004E03O000E0301002014010A000900B12O00AB000A000200024O000B00053O00202O000B000B00B14O000B0002000200062O000A001E0301000B0004E03O001E03012O006A010A00053O002022000A000A00B24O000C5O00202O000C000C00B34O000A000C000200262O000A001E030100180004E03O001E03012O006A010A00053O002024000A000A00B24O000C5O00202O000C000C00B34O000A000C000200202O000B000900124O000B0002000200062O000B00670301000A0004E03O00670301002EA701B4001D000100B40004E03O003B0301002014010A000900862O0005000A000200024O000B00023O00202O000B000B00864O000B0002000200062O000A003B0301000B0004E03O003B03012O006A010A00064O0034000B5O00202O000B000B007E4O000C000D6O000E00023O00202O000E000E004C00122O0010004D6O000E001000024O000E000E6O000A000E000200062O000A0035030100010004E03O00350301002EE800B60067030100B50004E03O006703012O006A010A00013O00121F010B00B73O00122O000C00B86O000A000C6O000A5O00044O00670301001278010A00894O00E1000A000100024O000B000F6O000C00013O00122O000D00B93O00122O000E00BA6O000C000E00024O000B000B000C4O000A000A000B00202O000A000A008C4O000B00103O00065F010B00030001000A0004E03O004A0301002E8F00BC0067030100BB0004E03O00670301001228000A00013O002EE800BD004B030100BE0004E03O004B03010026BF000A004B030100010004E03O004B03012O006A010B000F4O002E000C00013O00122O000D00BF3O00122O000E00C06O000C000E000200122O000D00896O000D000100024O000B000C000D002E2O00C20067030100C10004E03O006703012O006A010B000A4O0043010C00113O00122O000D00956O000C000D6O000B3O000200062O000B006703013O0004E03O006703012O006A010B00013O00121F010C00C33O00122O000D00C46O000B000D6O000B5O00044O006703010004E03O004B0301001228000700183O0004E03O000B02010004E03O00720301002E8F00C60006020100C50004E03O000602010026BF00060006020100010004E03O00060201001228000700014O0074000800083O001228000600023O0004E03O000602012O006A01066O0070000700013O00122O000800C73O00122O000900C86O0007000900024O00060006000700202O0006000600114O00060002000200062O000600B603013O0004E03O00B603012O006A010600153O0006A3000600B603013O0004E03O00B603012O006A01066O0070000700013O00122O000800C93O00122O000900CA6O0007000900024O00060006000700202O0006000600294O00060002000200062O0006009503013O0004E03O009503012O006A010600033O000E5E01CB00A5030100060004E03O00A503012O006A010600083O000682010600A5030100010004E03O00A503012O006A0106000C3O000682010600A5030100010004E03O00A503012O006A010600033O00266A000600A5030100CC0004E03O00A503012O006A01066O00A4000700013O00122O000800CD3O00122O000900CE6O0007000900024O00060006000700202O0006000600294O00060002000200062O000600B6030100010004E03O00B603012O006A010600033O000E5E01CF00A5030100060004E03O00A503012O006A0106000C3O0006A3000600B603013O0004E03O00B603012O006A010600064O001C01075O00202O0007000700D04O000800096O000A00023O00202O000A000A002100122O000C006B6O000A000C00024O000A000A6O0006000A000200062O000600B603013O0004E03O00B603012O006A010600013O001228000700D13O001228000800D24O0049010600084O001000065O001228000500023O0026BF000500F52O0100020004E03O00F52O01001228000400023O0004E03O00BC03010004E03O00F52O010026BF000400952O0100180004E03O00952O010012280002001D3O0004E03O00C303010004E03O00952O010004E03O00C303010004E03O00922O010026BF0002001A060100020004E03O001A0601001228000300014O0074000400043O002E8F00D300C7030100D40004E03O00C703010026BF000300C7030100010004E03O00C70301001228000400013O00260C010400D0030100010004E03O00D00301002E8F00D600EE040100D50004E03O00EE0401001228000500013O0026BF000500E4040100010004E03O00E404012O006A01066O0070000700013O00122O000800D73O00122O000900D86O0007000900024O00060006000700202O0006000600114O00060002000200062O0006000F04013O0004E03O000F04012O006A01066O00A4000700013O00122O000800D93O00122O000900DA6O0007000900024O00060006000700202O0006000600294O00060002000200062O0006000F040100010004E03O000F04012O006A010600083O00068201060001040100010004E03O000104012O006A010600023O0020140106000600122O0030010600020002000E3A01DB000F040100060004E03O000F04012O006A01066O0071000700013O00122O000800DC3O00122O000900DD6O0007000900024O00060006000700202O0006000600384O0006000200024O00078O000800013O00122O000900DE3O00122O000A00DF6O0008000A00024O00070007000800202O00070007002D4O00070002000200062O0006000F040100070004E03O000F0401002EA701E0000E000100E00004E03O000F04012O006A010600064O00F200075O00202O0007000700394O000800086O00060008000200062O0006000F04013O0004E03O000F04012O006A010600013O001228000700E13O001228000800E24O0049010600084O001000065O002EE800E300E3040100E40004E03O00E304012O006A01066O0070000700013O00122O000800E53O00122O000900E66O0007000900024O00060006000700202O0006000600114O00060002000200062O000600E304013O0004E03O00E304012O006A010600053O0020640106000600AF4O00085O00202O0008000800314O00060008000200062O0006003404013O0004E03O003404012O006A010600053O0020640106000600304O00085O00202O0008000800E74O00060008000200062O0006003404013O0004E03O003404012O006A010600053O0020770106000600B24O00085O00202O0008000800E74O00060008000200262O00060034040100E80004E03O003404012O006A010600074O00B100060001000200068201060065040100010004E03O006504012O006A010600053O0020640106000600AF4O00085O00202O0008000800314O00060008000200062O0006004A04013O0004E03O004A04012O006A010600033O0026500106004A0401002A0004E03O004A04012O006A010600033O000E3A0181004A040100060004E03O004A04012O006A010600074O00B10006000100020006A30006004A04013O0004E03O004A04012O006A010600053O00201401060006002F2O0030010600020002000E7C002E0065040100060004E03O006504012O006A010600033O00266A00060065040100810004E03O006504012O006A010600023O0020640106000600E94O00085O00202O0008000800174O00060008000200062O0006005B04013O0004E03O005B04012O006A010600043O000E2E012E005B040100060004E03O005B04012O006A010600164O00B1000600010002000E7C00180065040100060004E03O006504012O006A010600083O0006A3000600E304013O0004E03O00E304012O006A010600074O00B10006000100020006A3000600E304013O0004E03O00E304012O006A010600043O000E2E012E00E3040100060004E03O00E304012O006A010600174O0047010700013O00122O000800EA3O00122O000900EB6O00070009000200062O0006006E040100070004E03O006E0401002E8F00EC0081040100ED0004E03O008104012O006A0106000A4O00270107000B3O00202O0007000700EE4O000800023O00202O00080008002100122O000A00EF6O0008000A00024O000800086O00060008000200062O0006007B040100010004E03O007B0401002EE800F000E3040100F10004E03O00E304012O006A010600013O00121F010700F23O00122O000800F36O000600086O00065O00044O00E304012O006A010600174O0047010700013O00122O000800F43O00122O000900F56O00070009000200062O0006008A040100070004E03O008A0401002EE800F6009B040100F70004E03O009B04012O006A0106000A4O005600075O00202O0007000700F84O000800023O00202O00080008002100122O000A00226O0008000A00024O000800086O00060008000200062O000600E304013O0004E03O00E304012O006A010600013O00121F010700F93O00122O000800FA6O000600086O00065O00044O00E30401002E8F00FC00B8040100FB0004E03O00B804012O006A010600174O000C000700013O00122O000800FD3O00122O000900FE6O00070009000200062O000600B8040100070004E03O00B804012O006A0106000A4O00270107000B3O00202O0007000700FF4O000800023O00202O00080008002100122O000A00226O0008000A00024O000800086O00060008000200062O000600B2040100010004E03O00B204010012280006002O012O002650010600E304012O000104E03O00E304012O006A010600013O00121F01070002012O00122O00080003015O000600086O00065O00044O00E3040100122800060004012O00122800070005012O000603000600E3040100070004E03O00E304012O006A010600174O000C000700013O00122O00080006012O00122O00090007015O00070009000200062O000600E3040100070004E03O00E304012O006A010600183O0006A3000600E304013O0004E03O00E304012O006A010600183O00122800080008013O00BD0006000600082O00300106000200020006A3000600E304013O0004E03O00E304012O006A010600053O00123F00080009015O0006000600084O000800186O00060008000200062O000600E304013O0004E03O00E304012O006A0106000A4O00560007000B3O00202O0007000700FF4O000800023O00202O00080008002100122O000A00226O0008000A00024O000800086O00060008000200062O000600E304013O0004E03O00E304012O006A010600013O0012280007000A012O0012280008000B013O0049010600084O001000065O001228000500023O001228000600023O00068C010600EB040100050004E03O00EB04010012280006000C012O0012280007000D012O000603000600D1030100070004E03O00D10301001228000400023O0004E03O00EE04010004E03O00D10301001228000500183O000622010400F3040100050004E03O00F30401001228000200183O0004E03O001A0601001228000500023O00068C010400FA040100050004E03O00FA04010012280005000E012O0012280006000F012O0006D7000500CC030100060004E03O00CC0301001228000500013O001228000600023O00062201062O00050100050004E04O000501001228000400183O0004E03O00CC030100122800060010012O00122800070011012O000603000600FB040100070004E03O00FB0401001228000600013O000622010600FB040100050004E03O00FB04012O006A010600053O0020640106000600AF4O00085O00202O0008000800314O00060008000200062O000600B905013O0004E03O00B905012O006A01066O0070000700013O00122O00080012012O00122O00090013015O0007000900024O00060006000700202O0006000600294O00060002000200062O000600B905013O0004E03O00B905012O006A01066O00C3000700013O00122O00080014012O00122O00090015015O0007000900024O00060006000700202O00060006002D4O00060002000200122O000700183O00062O000600B9050100070004E03O00B905012O006A010600033O001228000700153O0006030007004F050100060004E03O004F05012O006A01066O0083000700013O00122O00080016012O00122O00090017015O0007000900024O00060006000700122O00080018015O0006000600084O00060002000200122O000700013O00062O0007003E050100060004E03O003E05012O006A01066O00BC000700013O00122O00080019012O00122O0009001A015O0007000900024O00060006000700202O00060006002D4O00060002000200122O000700813O00062O0007004F050100060004E03O004F05012O006A010600083O0006820106007B050100010004E03O007B05012O006A01066O008A010700013O00122O0008001B012O00122O0009001C015O0007000900024O00060006000700202O00060006002D4O00060002000200122O000700813O00062O0007007B050100060004E03O007B05012O006A0106000C3O0006820106007B050100010004E03O007B05012O006A010600083O0006820106005D050100010004E03O005D05012O006A01066O00BC000700013O00122O0008001D012O00122O0009001E015O0007000900024O00060006000700202O00060006002D4O00060002000200122O0007001F012O00062O000700B9050100060004E03O00B905012O006A01066O0083000700013O00122O00080020012O00122O00090021015O0007000900024O00060006000700122O00080018015O0006000600084O00060002000200122O000700013O00062O0007007B050100060004E03O007B05012O006A01066O008A010700013O00122O00080022012O00122O00090023015O0007000900024O00060006000700202O00060006002D4O00060002000200122O0007001F012O00062O0007007B050100060004E03O007B05012O006A010600053O0020640106000600304O00085O00202O0008000800E74O00060008000200062O000600B905013O0004E03O00B90501001228000600014O0074000700093O001228000A00013O000622010600830501000A0004E03O00830501001228000700014O0074000800083O001228000600023O001228000A00023O0006220106007D0501000A0004E03O007D05012O0074000900093O001228000A00023O00068C0107008E0501000A0004E03O008E0501001228000A0024012O001228000B0025012O0006D7000A009E0501000B0004E03O009E0501001228000A0026012O001228000B0026012O000622010A008E0501000B0004E03O008E0501001228000A00013O0006220108008E0501000A0004E03O008E05012O006A010A00194O00B1000A000100022O008D0109000A3O0006A3000900B905013O0004E03O00B905012O003A000900023O0004E03O00B905010004E03O008E05010004E03O00B90501001228000A0027012O001228000B0027012O000622010A00870501000B0004E03O00870501001228000A00013O000622010700870501000A0004E03O00870501001228000A00013O001228000B0028012O001228000C0029012O0006D7000B00AF0501000C0004E03O00AF0501001228000B00023O000622010A00AF0501000B0004E03O00AF0501001228000700023O0004E03O00870501001228000B00013O000622010A00A60501000B0004E03O00A60501001228000800014O0074000900093O001228000A00023O0004E03O00A605010004E03O008705010004E03O00B905010004E03O007D05012O006A01066O0070000700013O00122O0008002A012O00122O0009002B015O0007000900024O00060006000700202O0006000600114O00060002000200062O0006000106013O0004E03O000106012O006A010600033O0012280007006B3O0006DD00060005060100070004E03O000506012O006A01066O00A2000700013O00122O0008002C012O00122O0009002D015O0007000900024O00060006000700122O00080018015O0006000600084O00060002000200122O000700183O00062O00060001060100070004E03O000106012O006A01066O0071000700013O00122O0008002E012O00122O0009002F015O0007000900024O00060006000700202O00060006002D4O0006000200024O00078O000800013O00122O00090030012O00122O000A0031015O0008000A00024O00070007000800202O0007000700384O00070002000200062O00070001060100060004E03O000106012O006A01066O00C3000700013O00122O00080032012O00122O00090033015O0007000900024O00060006000700202O00060006002D4O00060002000200122O00070034012O00062O00060001060100070004E03O000106012O006A010600053O00201401060006002F2O0030010600020002001228000700183O0006D700070001060100060004E03O000106012O006A01066O0062010700013O00122O00080035012O00122O00090036015O0007000900024O00060006000700202O00060006002D4O00060002000200122O00070037012O00062O00060005000100070004E03O0005060100122800060038012O00122800070039012O0006D700060015060100070004E03O001506010012280006003A012O0012280007003B012O00060300070015060100060004E03O001506012O006A010600064O00F200075O00202O0007000700394O000800086O00060008000200062O0006001506013O0004E03O001506012O006A010600013O0012280007003C012O0012280008003D013O0049010600084O001000065O001228000500023O0004E03O00FB04010004E03O00CC03010004E03O001A06010004E03O00C703010012280003001D3O00068C01030021060100020004E03O002106010012280003003E012O0012280004003F012O0006D700030010000100040004E03O001000012O006A01036O0070000400013O00122O00050040012O00122O00060041015O0004000600024O00030003000400202O0003000300114O00030002000200062O0003004A06013O0004E03O004A06012O006A01036O008A010400013O00122O00050042012O00122O00060043015O0004000600024O00030003000400202O00030003002D4O00030002000200122O0004002A3O00062O0004003D060100030004E03O003D06012O006A0103000C3O0006820103003D060100010004E03O003D06012O006A010300033O001228000400813O0006030003004A060100040004E03O004A06012O006A010300064O000B00045O00122O00050044015O0004000400054O000500056O00030005000200062O0003004A06013O0004E03O004A06012O006A010300013O00122800040045012O00122800050046013O0049010300054O001000036O006A01036O0070000400013O00122O00050047012O00122O00060048015O0004000600024O00030003000400202O0003000300114O00030002000200062O0003006606013O0004E03O006606012O006A01036O008A010400013O00122O00050049012O00122O0006004A015O0004000600024O00030003000400202O00030003002D4O00030002000200122O0004002A3O00062O0004006A060100030004E03O006A06012O006A0103000C3O0006820103006A060100010004E03O006A06012O006A010300033O001228000400DB3O0006DD0003006A060100040004E03O006A06010012280003004B012O0012280004004C012O0006D700030077060100040004E03O007706012O006A010300064O000B00045O00122O0005004D015O0004000400054O000500056O00030005000200062O0003007706013O0004E03O007706012O006A010300013O0012280004004E012O0012280005004F013O0049010300054O001000036O006A01036O0070000400013O00122O00050050012O00122O00060051015O0004000600024O00030003000400202O0003000300114O00030002000200062O0003009506013O0004E03O009506012O006A010300053O0020640103000300AF4O00055O00202O0005000500E74O00030005000200062O0003009506013O0004E03O009506012O006A010300064O000B00045O00122O00050052015O0004000400054O000500056O00030005000200062O0003009506013O0004E03O009506012O006A010300013O00122800040053012O00122800050054013O0049010300054O001000036O006A01036O0070000400013O00122O00050055012O00122O00060056015O0004000600024O00030003000400202O0003000300114O00030002000200062O000300B206013O0004E03O00B206012O006A010300064O000B00045O00122O00050057015O0004000400054O000500056O00030005000200062O000300B206013O0004E03O00B206012O006A010300013O00121F01040058012O00122O00050059015O000300056O00035O00044O00B206010004E03O001000010004E03O00B206010004E03O000B00010004E03O00B206010004E03O000200012O003C012O00017O0015012O00028O00025O00E49640025O00DEB240025O00BC9340025O00DEAD40026O00F03F026O004240025O0080AC40025O00AAAD4003173O0078A612FC17126044AD0AC714126F59A110F6281E5F54BA03073O003831C864937C77030A3O0049734361737461626C6503093O0054696D65546F446965026O003940026O005E40026O004E40030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66027O0040025O00804B4003083O00FF3BADF5C237ABE903043O0090AC5EDF030A3O00432O6F6C646F776E5570026O000840030B3O00426C2O6F646C7573745570026O00374003173O00496E766F6B655875656E5468655768697465546967657203093O004973496E52616E6765026O00444003293O002D01B4482F0A9D5F310AAC783007A7783307AB532130B64E230AB007270B9D54211DA7492D1BBB077203043O0027446FC2026O006040025O0044A340030C3O00F4A9E9C27DA2C5B2C5D57CA003063O00D7B6C687A71903083O0042752O66446F776E03103O00426F6E65647573744272657742752O6603083O00BE4CF84D8340FE5103043O0028ED298A03083O00F471E8FD44CE60E303053O002AA7149A98030F3O00432O6F6C646F776E52656D61696E73026O002E40026O003E40026O00244003063O007AF2A35B743303063O00412A9EC2221103123O00426F6E656475737442726577506C61796572026O002040025O0090A740025O0084A240031B3O0018285C0929F808FA2O2540093AAD18EA2534571E28E312FA03670A03083O008E7A47326C4D8D7B030C3O0036ADF11E3207AFFE0C321AAC03053O005B75C29F78030C3O00426F6E656475737442726577031B3O001812301D31E4370E223C0A30E6642O19010B30E3212O142A0175A903073O00447A7D5E78559103063O003409DD4DC7CB03073O00DA777CAF3EA8B9025O00C88740025O00DEB04003123O00426F6E656475737442726577437572736F72025O00B4B140025O001C9340031B3O00A7FF46C1A1E55BD09AF25AC1B2B04BC09AE34DD6A0FE41D0BCB01003043O00A4C5902803123O00A6FEAF86C4F696FEAE8ECFF6A0E5B898D2A403063O00D6E390CAEBBD025O00B88540025O00E4AD4003063O0045786973747303093O0043616E412O7461636B025O00FAB040025O0092A940025O003EAC40031B3O00EFAA897E14A64028D2A7957E07F35038D2B6826915BD5A28F4E5DF03083O005C8DC5E71B70D333025O009DB040025O00A88F40025O0038AB40025O00A2A64003083O00D5FA98A6DFEFEB9303053O00B1869FEAC303063O0042752O66557003133O00496E766F6B65727344656C6967687442752O6603113O0099F936AEC2B4E53888C6AFE51CAFDFB8F903053O00A9DD8B5FC0030B3O004973417661696C61626C65025O00405A4003173O00F78569302923E69E7A31162EDBBC772O3623EA82783A3003063O0046BEEB1F5F42025O00FEAF40025O0095B240025O00849740025O00CEB14003083O00536572656E69747903173O00A9E708E3EBB3F603A6E6BEDD09E3F7BFEC13F2FCFAB34A03053O0085DA827A86030C3O0008F0F6C7D4AC3E18FAE2D0D403073O00585C9F83A4BCC3025O00D2A440025O00D88C40025O0016B140025O00FAA940026O009940025O0076B040025O000CA840030C3O00B421AA48DFE4DBA42BBE5FDF03073O00BDE04EDF2BB78B03073O0049735265616479025O0054AD40025O00BCA640025O0020A640025O00F2AC40030C3O00536572656E69747942752O66030C3O00546F7563686F66446561746803063O004865616C7468030B3O0042752O6652656D61696E73031F3O0048692O64656E4D617374657273466F7262692O64656E546F75636842752O66025O00806540025O00407F4003043O0047554944030E3O004973496E4D656C2O6552616E6765026O00144003243O003AF39F15C911F38C29C52BFD9E1E812DF8B505C428BC8717C820B19E17D329F99E56907C03053O00A14E9CEA7603073O0047657454696D65030E3O008BB6DAC893B62ODBA2A3FACBA6A703043O00BCC7D7A9025O00408F40026O005040025O00EEB240030E3O00D0084C6FDCFD1B587EFCCF1E5E6B03053O00889C693F1B026O00594003233O000F836C3713B3763224887C350F8439371FB36A311DCC76321DC16D35098B7C205BDD2B03043O00547BEC1903093O004973496E506172747903083O004973496E52616964025O00907740025O0076A240025O00F6AA4003083O00446562752O66557003123O00426F6E656475737442726577446562752O6603243O00E484BF14A48AFF8D9513A9B4E483EA14A88AE38EAC57A1B4F985E703ADA7F78EBE57FDE103063O00D590EBCA77CC025O00D07840025O00C49740030E3O000F19CD3E1C225F241DCA193F225D03073O002D4378BE4A4843025O000CB240025O0084AC40025O00EEA240025O001CA040025O0064A340025O00349640030E3O000C23FEB1CD89FCEE2536DEB2F89803083O008940428DC599E88E025O00488E40025O0078914003233O0017DF37A5803CDF24998C06D136AEC800D41DB58D05902DA08E4EC423B48F06C462F7DC03053O00E863B042C6025O00109F40025O0088A640025O00307940026O008440025O00307340025O0002A24003243O00F82E3D0573B2F62AD3252D076F85B92FE81E3B037DCDF42DE52F65127A9FFE29F861795003083O004C8C4148661BED99030E3O0066DB05C6E300AC4DDF02E1C000AE03073O00DE2ABA76B2B761025O00188C40025O006AAB40030E3O0071ED579E69ED568D58F8779D5CFC03043O00EA3D8C2403233O0035D2AF71071ED2BC4D0B24DCAE7A4F22D985610A279DB574096CC9BB600824C9FA235903053O006F41BDDA12025O0034A640025O0026A740025O00EAAA40025O0020AB40025O00B89340025O00788A4003163O004FCFD550583DE574D3CC58633AD579C8EB495627C77903073O00B21CBAB83D375303173O00EDC35133F90BCDD1C84908FA0BC2CCC45339C607F2C1DF03073O0095A4AD275C926E026O00104003173O00DA290610111ECB3215112E13F61018160E1EC72E171A0803063O007B9347707F7A026O00494003063O00FCC1836843DE03053O0026ACADE211031C3O0053752O6D6F6E57686974655469676572537461747565506C6179657203273O005E0421E2421F13F8451838EA720525E8480313FC591038FA48512FEB720229FD481F25FB54517E03043O008F2D714C025O005C9440025O0056AC4003063O009BAD0E2FB7AA03043O005C2OD87C025O0088A440025O00407A40031C3O0053752O6D6F6E57686974655469676572537461747565437572736F7203273O004827A14DF2550DBB48F44F379354F45C37BE7FEE4F33B855F81B31A87FEE5E20A94EF44F2BEC1203053O009D3B52CC20025O0020B240025O00A0734003173O0011302OF5E2EFEBA43D30D7F2ECDDDBB82C3BD7F3EEEFC103083O00D1585E839A898AB3030C3O000AAECA791A3622360AB3C16B03083O004248C1A41C7E4351030C3O00C523A65D2263F4388A4A236103063O0016874CC8384603293O00843EEE2B56E4B228ED2153DE9938FD1B4AE98424FD1B49E88A35EA645EE5B223FD3658EF8424E1640903063O0081ED5098443D025O0046A640025O00B6AF40025O00707D40025O0072A640025O00107D40025O00088840025O00488840030C3O0077440E360353A9684A09380A03073O00CF232B7B556B3C025O00805640030C3O00546F7563686F664B61726D61031D3O0064A5B5E9714FA5A6D57271B8ADEB3973AE9FF97C62AFAEE36D69EAF1B203053O001910CAC08A025O00488240026O00344003093O005CEFF73D52431B75E203073O00741A868558302F026O002A4003093O0046697265626C2O6F6403183O0018C8B2E1BF7E11CE2OA4BE7621D2A5F6B87C17D5B9A4EF2603063O00127EA1C084DD030A3O007D2DBC17534D23A70A5103053O00363F48CE64025O00E8AD40025O00C05A40030A3O004265727365726B696E6703193O00CA5C5769E069C3504B7DA578CC66567FF77EC6505163A5299E03063O001BA839251A85025O00908F40025O00BBB240030D3O00DCC5AEE7BAE0EFCAA1C1A8F8F103063O00949DABCD82C9025O0078A040025O00B89C40030D3O00416E6365737472616C43612O6C031D3O0022DA772CC2E231D57816D2F72FD8342AD5C930D1662CDFFF37CD347B8103063O009643B41449B103093O00AF141542893E0F5F9403043O002DED787A03093O00426C2O6F6446757279025O00349440026O00784003193O00D5E4AD23D3D7A439C5F1E22FD3D7B129C5EDAC25C3F1E27E8503043O004CB788C2025O006CA340025O000BB140025O0002A940025O0008B340030B3O000FAB7BA7D119B875ABDC3E03053O00B74DCA1CC8030B3O004261676F66547269636B73025O00E1B140025O00F09040031C3O0015328E371835B61C053A8A0304738A0C28208C1A123D801C0E73DB5003043O00687753E9030E3O00D9F1202A57E6D2322644F8FD293603053O002395984742030E3O004C69676874734A7564676D656E74031E3O0015E145B82E0AD748A53E1EE547BE2E59EB468F291CFA47BE330DF102E36A03053O005A798822D000AC042O0012283O00014O0074000100013O002EE800020002000100030004E03O000200010026BF3O0002000100010004E03O00020001001228000100013O002EE8000400122O0100050004E03O00122O010026BF000100122O0100060004E03O00122O01001228000200014O0074000300033O002EA701073O000100070004E03O000D00010026BF0002000D000100010004E03O000D0001001228000300013O002EE8000800092O0100090004E03O00092O010026BF000300092O0100010004E03O00092O012O006A01046O0070000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005F00013O0004E03O005F00012O006A010400023O00201401040004000D2O0030010400020002000E3A010E0028000100040004E03O002800012O006A010400033O000E5E010F004E000100040004E03O004E00012O006A010400033O00265001040046000100100004E03O004600012O006A010400023O0020220004000400114O00065O00202O0006000600124O00040006000200262O00040039000100130004E03O003900012O006A010400023O0020D60004000400114O00065O00202O0006000600124O000400060002000E2O00140046000100040004E03O004600012O006A01046O0070000500013O00122O000600153O00122O000700166O0005000700024O00040004000500202O0004000400174O00040002000200062O0004004600013O0004E03O004600012O006A010400043O00266A0004004E000100180004E03O004E00012O006A010400053O0020140104000400192O00300104000200020006820104004E000100010004E03O004E00012O006A010400033O0026500104005F0001001A0004E03O005F00012O006A010400064O001C01055O00202O00050005001B4O000600076O000800023O00202O00080008001C00122O000A001D6O0008000A00024O000800086O00040008000200062O0004005F00013O0004E03O005F00012O006A010400013O0012280005001E3O0012280006001F4O0049010400064O001000045O002E8F002000082O0100210004E03O00082O012O006A01046O0070000500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400082O013O0004E03O00082O012O006A010400053O0020640104000400244O00065O00202O0006000600254O00040006000200062O0004008C00013O0004E03O008C00012O006A01046O00A4000500013O00122O000600263O00122O000700276O0005000700024O00040004000500202O0004000400174O00040002000200062O0004008F000100010004E03O008F00012O006A01046O0083010500013O00122O000600283O00122O000700296O0005000700024O00040004000500202O00040004002A4O000400020002000E2O002B008F000100040004E03O008F00012O006A010400033O0026500104008C0001002C0004E03O008C00012O006A010400033O000E5E012D008F000100040004E03O008F00012O006A010400033O002650010400082O01002D0004E03O00082O012O006A010400074O000C000500013O00122O0006002E3O00122O0007002F6O00050007000200062O000400A9000100050004E03O00A900012O006A010400084O0027010500093O00202O0005000500304O000600023O00202O00060006001C00122O000800316O0006000800024O000600066O00040006000200062O000400A3000100010004E03O00A30001002EA701320067000100330004E03O00082O012O006A010400013O00121F010500343O00122O000600356O000400066O00045O00044O00082O012O006A010400074O000C000500013O00122O000600363O00122O000700376O00050007000200062O000400C1000100050004E03O00C100012O006A010400084O005600055O00202O0005000500384O000600023O00202O00060006001C00122O0008001D6O0006000800024O000600066O00040006000200062O000400082O013O0004E03O00082O012O006A010400013O00121F010500393O00122O0006003A6O000400066O00045O00044O00082O012O006A010400074O0047010500013O00122O0006003B3O00122O0007003C6O00050007000200062O000400CA000100050004E03O00CA0001002E8F003E00DD0001003D0004E03O00DD00012O006A010400084O0027010500093O00202O00050005003F4O000600023O00202O00060006001C00122O0008001D6O0006000800024O000600066O00040006000200062O000400D7000100010004E03O00D70001002EE8004000082O0100410004E03O00082O012O006A010400013O00121F010500423O00122O000600436O000400066O00045O00044O00082O012O006A010400074O0047010500013O00122O000600443O00122O000700456O00050007000200062O000400E6000100050004E03O00E60001002EA701460024000100470004E03O00082O012O006A0104000A3O0006A3000400F400013O0004E03O00F400012O006A0104000A3O0020140104000400482O00300104000200020006A3000400F400013O0004E03O00F400012O006A010400053O0020140104000400492O006A0106000A4O005C000400060002000682010400F6000100010004E03O00F60001002EE8004A00082O01004B0004E03O00082O01002EA7014C00120001004C0004E03O00082O012O006A010400084O0056000500093O00202O00050005003F4O000600023O00202O00060006001C00122O0008001D6O0006000800024O000600066O00040006000200062O000400082O013O0004E03O00082O012O006A010400013O0012280005004D3O0012280006004E4O0049010400064O001000045O001228000300063O002E8F005000120001004F0004E03O001200010026BF00030012000100060004E03O00120001001228000100133O0004E03O00122O010004E03O001200010004E03O00122O010004E03O000D0001000E51011300FB020100010004E03O00FB0201001228000200013O002E8F005200F4020100510004E03O00F402010026BF000200F4020100010004E03O00F402012O006A01036O0070000400013O00122O000500533O00122O000600546O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300472O013O0004E03O00472O012O006A010300053O00208F0103000300554O00055O00202O0005000500564O00030005000200062O000300492O0100010004E03O00492O012O006A0103000B3O0006A30003003A2O013O0004E03O003A2O012O006A01036O0070000400013O00122O000500573O00122O000600586O0004000600024O00030003000400202O0003000300594O00030002000200062O0003003A2O013O0004E03O003A2O012O006A010300033O000E5E015A00492O0100030004E03O00492O012O006A01036O0070000400013O00122O0005005B3O00122O0006005C6O0004000600024O00030003000400202O0003000300594O00030002000200062O000300492O013O0004E03O00492O012O006A010300033O00266A000300492O01002B0004E03O00492O01002EE8005E00572O01005D0004E03O00572O01002E8F005F00572O0100600004E03O00572O012O006A010300064O00F200045O00202O0004000400614O000500056O00030005000200062O000300572O013O0004E03O00572O012O006A010300013O001228000400623O001228000500634O0049010300054O001000036O006A01036O0070000400013O00122O000500643O00122O000600656O0004000600024O00030003000400202O0003000300174O00030002000200062O000300F302013O0004E03O00F302012O006A0103000C3O0006A3000300F302013O0004E03O00F30201001228000300014O0074000400063O00260C0103006A2O0100060004E03O006A2O01002EE8006600ED020100670004E03O00ED02012O0074000600063O0026BF00040001020100060004E03O00010201001228000700014O0074000800083O002EE80069006F2O0100680004E03O006F2O010026BF0007006F2O0100010004E03O006F2O01001228000800013O002EA7016A00060001006A0004E03O007A2O01000E510106007A2O0100080004E03O007A2O01001228000400133O0004E03O0001020100260C0108007E2O0100010004E03O007E2O01002EE8006B00742O01006C0004E03O00742O012O006A0109000D3O0006A3000900882O013O0004E03O00882O012O006A0109000E3O0006A3000900882O013O0004E03O00882O012O006A0109000F4O00B10009000100022O008D010600093O0004E03O00952O012O006A01096O00A4000A00013O00122O000B006D3O00122O000C006E6O000A000C00024O00090009000A00202O00090009006F4O00090002000200062O000900942O0100010004E03O00942O01002EE8007000952O0100710004E03O00952O012O006A010600023O000682010600992O0100010004E03O00992O01002E8F007300FD2O0100720004E03O00FD2O010006A3000500AF2O013O0004E03O00AF2O012O006A010900053O0020640109000900244O000B5O00202O000B000B00744O0009000B000200062O000900AF2O013O0004E03O00AF2O012O006A010900104O006A010A5O0020D4000A000A00752O00300109000200020006A3000900AF2O013O0004E03O00AF2O010020140109000600762O00AB0009000200024O000A00053O00202O000A000A00764O000A0002000200062O000900C12O01000A0004E03O00C12O012O006A010900053O0020220009000900774O000B5O00202O000B000B00784O0009000B000200262O000900C12O0100130004E03O00C12O012O006A010900053O0020840109000900774O000B5O00202O000B000B00784O0009000B000200202O000A0006000D4O000A0002000200062O000A00C12O0100090004E03O00C12O01002E8F007A00FD2O0100790004E03O00FD2O0100201401090006007B2O00050009000200024O000A00023O00202O000A000A007B4O000A0002000200062O000900DA2O01000A0004E03O00DA2O012O006A010900064O001C010A5O00202O000A000A00754O000B000C6O000D00023O00202O000D000D007C00122O000F007D6O000D000F00024O000D000D6O0009000D000200062O000900FD2O013O0004E03O00FD2O012O006A010900013O00121F010A007E3O00122O000B007F6O0009000B6O00095O00044O00FD2O01001278010900804O00E10009000100024O000A00116O000B00013O00122O000C00813O00122O000D00826O000B000D00024O000A000A000B4O00090009000A00202O0009000900834O000A00123O00065F010A0003000100090004E03O00E92O01002E8F008500FD2O0100840004E03O00FD2O012O006A010900114O009B010A00013O00122O000B00863O00122O000C00876O000A000C000200122O000B00806O000B000100024O0009000A000B4O000900086O000A00133O00122O000B00884O007B010A000B4O000700093O00020006A3000900FD2O013O0004E03O00FD2O012O006A010900013O001228000A00893O001228000B008A4O00490109000B4O001000095O001228000800063O0004E03O00742O010004E03O000102010004E03O006F2O01000E512O01000E020100040004E03O000E02012O006A010700053O00201401070007008B2O00300107000200020006F60005000C020100070004E03O000C02012O006A010700053O00201401070007008C2O00300107000200022O0019000500074O0074000600063O001228000400063O002E8F008D006B2O01008E0004E03O006B2O010026BF0004006B2O0100130004E03O006B2O010006A3000600F302013O0004E03O00F302012O006A010700104O006A01085O0020D40008000800752O00300107000200020006A3000700F302013O0004E03O00F302010006A30005008C02013O0004E03O008C0201002EA7018F00D70001008F0004E03O00F3020100201401070006000D2O0030010700020002000E5E0110002B020100070004E03O002B02010020140107000600902O006A01095O0020D40009000900912O005C0007000900020006820107002B020100010004E03O002B02012O006A010700033O002650010700F30201002D0004E03O00F302012O006A010700053O0020640107000700244O00095O00202O0009000900744O00070009000200062O000700F302013O0004E03O00F3020100201401070006007B2O00050007000200024O000800023O00202O00080008007B4O00080002000200062O0007004B020100080004E03O004B02012O006A010700064O001C01085O00202O0008000800754O0009000A6O000B00023O00202O000B000B007C00122O000D007D6O000B000D00024O000B000B6O0007000B000200062O000700F302013O0004E03O00F302012O006A010700013O00121F010800923O00122O000900936O000700096O00075O00044O00F30201002E8F0094005B020100950004E03O005B0201001278010700804O00E10007000100024O000800116O000900013O00122O000A00963O00122O000B00976O0009000B00024O0008000800094O00070007000800202O0007000700834O000800123O0006030007005B020100080004E03O005B02010004E03O00F30201001228000700014O0074000800093O0026BF00070062020100010004E03O00620201001228000800014O0074000900093O001228000700063O002EE80099005D020100980004E03O005D02010026BF0007005D020100060004E03O005D0201002EE8009B00660201009A0004E03O006602010026BF00080066020100010004E03O00660201001228000900013O002EE8009D006B0201009C0004E03O006B0201000E512O01006B020100090004E03O006B02012O006A010A00114O002E000B00013O00122O000C009E3O00122O000D009F6O000B000D000200122O000C00806O000C000100024O000A000B000C002E2O00A000F3020100A10004E03O00F302012O006A010A00084O0043010B00133O00122O000C00886O000B000C6O000A3O000200062O000A00F302013O0004E03O00F302012O006A010A00013O00121F010B00A23O00122O000C00A36O000A000C6O000A5O00044O00F302010004E03O006B02010004E03O00F302010004E03O006602010004E03O00F302010004E03O005D02010004E03O00F302012O006A010700053O00208F0107000700244O00095O00202O0009000900744O00070009000200062O00070095020100010004E03O00950201002E8F00A500F3020100A40004E03O00F30201002EE800A600B2020100A70004E03O00B2020100201401070006007B2O00050007000200024O000800023O00202O00080008007B4O00080002000200062O000700B2020100080004E03O00B202012O006A010700064O003400085O00202O0008000800754O0009000A6O000B00023O00202O000B000B007C00122O000D007D6O000B000D00024O000B000B6O0007000B000200062O000700AC020100010004E03O00AC0201002E8F00A900F3020100A80004E03O00F302012O006A010700013O00121F010800AA3O00122O000900AB6O000700096O00075O00044O00F30201001278010700804O00E10007000100024O000800116O000900013O00122O000A00AC3O00122O000B00AD6O0009000B00024O0008000800094O00070007000800202O0007000700834O000800123O000603000700C0020100080004E03O00C002010004E03O00F30201001228000700014O0074000800093O0026BF000700C7020100010004E03O00C70201001228000800014O0074000900093O001228000700063O0026BF000700C2020100060004E03O00C20201000E512O0100C9020100080004E03O00C90201001228000900013O00260C010900D0020100010004E03O00D00201002EE800AF00CC020100AE0004E03O00CC02012O006A010A00114O009B010B00013O00122O000C00B03O00122O000D00B16O000B000D000200122O000C00806O000C000100024O000A000B000C4O000A00086O000B00133O00122O000C00884O007B010B000C4O0007000A3O00020006A3000A00F302013O0004E03O00F302012O006A010A00013O00121F010B00B23O00122O000C00B36O000A000C6O000A5O00044O00F302010004E03O00CC02010004E03O00F302010004E03O00C902010004E03O00F302010004E03O00C202010004E03O00F302010004E03O006B2O010004E03O00F30201000E512O0100662O0100030004E03O00662O01001228000400014O0074000500053O001228000300063O0004E03O00662O01001228000200063O002E8F00B400152O0100B50004E03O00152O010026BF000200152O0100060004E03O00152O01001228000100183O0004E03O00FB02010004E03O00152O010026BF000100A4030100010004E03O00A40301001228000200014O0074000300033O0026BF000200FF020100010004E03O00FF0201001228000300013O000E5101060006030100030004E03O00060301001228000100063O0004E03O00A40301002EE800B60002030100B70004E03O00020301000E512O010002030100030004E03O00020301002E8F00B9005F030100B80004E03O005F03012O006A01046O0070000500013O00122O000600BA3O00122O000700BB6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005F03013O0004E03O005F03012O006A01046O00A4000500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500202O0004000400174O00040002000200062O00040030030100010004E03O003003012O006A010400043O000E5E01BE0030030100040004E03O003003012O006A01046O0083010500013O00122O000600BF3O00122O000700C06O0005000700024O00040004000500202O00040004002A4O000400020002000E2O00C10030030100040004E03O003003012O006A010400033O0026290104005F0301002C0004E03O005F03012O006A010400144O000C000500013O00122O000600C23O00122O000700C36O00050007000200062O00040048030100050004E03O004803012O006A010400084O0056000500093O00202O0005000500C44O000600023O00202O00060006007C00122O0008007D6O0006000800024O000600066O00040006000200062O0004005F03013O0004E03O005F03012O006A010400013O00121F010500C53O00122O000600C66O000400066O00045O00044O005F0301002E8F00C70052030100C80004E03O005203012O006A010400144O0047010500013O00122O000600C93O00122O000700CA6O00050007000200062O00040052030100050004E03O005203010004E03O005F0301002EE800CC005F030100CB0004E03O005F03012O006A010400084O006A010500093O0020D40005000500CD2O00300104000200020006A30004005F03013O0004E03O005F03012O006A010400013O001228000500CE3O001228000600CF4O0049010400064O001000045O002E8F00D100A0030100D00004E03O00A003012O006A01046O0070000500013O00122O000600D23O00122O000700D36O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400A003013O0004E03O00A003012O006A0104000B3O00068201040087030100010004E03O008703012O006A01046O0070000500013O00122O000600D43O00122O000700D56O0005000700024O00040004000500202O0004000400594O00040002000200062O0004008703013O0004E03O008703012O006A01046O006B010500013O00122O000600D63O00122O000700D76O0005000700024O00040004000500202O00040004002A4O00040002000200262O000400870301007D0004E03O008703012O006A010400023O00201401040004000D2O0030010400020002000E5E010E008F030100040004E03O008F03012O006A010400053O0020140104000400192O00300104000200020006820104008F030100010004E03O008F03012O006A010400033O002650010400A00301000E0004E03O00A003012O006A010400064O001C01055O00202O00050005001B4O000600076O000800023O00202O00080008001C00122O000A001D6O0008000A00024O000800086O00040008000200062O000400A003013O0004E03O00A003012O006A010400013O001228000500D83O001228000600D94O0049010400064O001000045O001228000300063O0004E03O000203010004E03O00A403010004E03O00FF02010026BF0001008D040100180004E03O008D0401001228000200014O0074000300033O00260C010200AC030100010004E03O00AC0301002EE800DB00A8030100DA0004E03O00A80301001228000300013O00260C010300B1030100010004E03O00B10301002E8F00DD0085040100DC0004E03O00850401001228000400013O002EA701DE0006000100DE0004E03O00B803010026BF000400B8030100060004E03O00B80301001228000300063O0004E03O008504010026BF000400B2030100010004E03O00B20301002EE800DF00DB030100E00004E03O00DB03012O006A010500153O0006A3000500DB03013O0004E03O00DB03012O006A01056O0070000600013O00122O000700E13O00122O000800E26O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500DB03013O0004E03O00DB03012O006A010500033O000E5E01E300CF030100050004E03O00CF03012O006A010500033O002650010500DB0301002D0004E03O00DB03012O006A010500064O00F200065O00202O0006000600E44O000700076O00050007000200062O000500DB03013O0004E03O00DB03012O006A010500013O001228000600E53O001228000700E64O0049010500074O001000055O002EA701E700A8000100E70004E03O008304012O006A010500053O00208F0105000500554O00075O00202O0007000700744O00050007000200062O000500E7030100010004E03O00E703012O006A010500033O00265001050083040100E80004E03O00830401001228000500013O0026BF0005001B040100060004E03O001B04012O006A01066O0070000700013O00122O000800E93O00122O000900EA6O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006000204013O0004E03O00020401002EA701EB000E000100EB0004E03O000204012O006A010600064O00F200075O00202O0007000700EC4O000800086O00060008000200062O0006000204013O0004E03O000204012O006A010600013O001228000700ED3O001228000800EE4O0049010600084O001000066O006A01066O0070000700013O00122O000800EF3O00122O000900F06O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006001A04013O0004E03O001A0401002EE800F2001A040100F10004E03O001A04012O006A010600064O00F200075O00202O0007000700F34O000800086O00060008000200062O0006001A04013O0004E03O001A04012O006A010600013O001228000700F43O001228000800F54O0049010600084O001000065O001228000500133O00260C0105001F040100010004E03O001F0401002E8F00F7005B040100F60004E03O005B0401001228000600013O0026BF00060024040100060004E03O00240401001228000500063O0004E03O005B04010026BF00060020040100010004E03O002004012O006A01076O0070000800013O00122O000900F83O00122O000A00F96O0008000A00024O00070007000800202O00070007000C4O00070002000200062O0007003E04013O0004E03O003E0401002EE800FB003E040100FA0004E03O003E04012O006A010700064O00F200085O00202O0008000800FC4O000900096O00070009000200062O0007003E04013O0004E03O003E04012O006A010700013O001228000800FD3O001228000900FE4O0049010700094O001000076O006A01076O0070000800013O00122O000900FF3O00122O000A2O00015O0008000A00024O00070007000800202O00070007000C4O00070002000200062O0007005904013O0004E03O005904012O006A010700064O00A800085O00122O0009002O015O0008000800094O000900096O00070009000200062O00070054040100010004E03O0054040100122800070002012O00122800080003012O0006D700070059040100080004E03O005904012O006A010700013O00122800080004012O00122800090005013O0049010700094O001000075O001228000600063O0004E03O0020040100122800060006012O00122800070007012O000603000600E8030100070004E03O00E80301001228000600133O000622010500E8030100060004E03O00E8030100122800060008012O00122800070009012O00060300060083040100070004E03O008304012O006A01066O0070000700013O00122O0008000A012O00122O0009000B015O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006008304013O0004E03O008304012O006A010600064O00A800075O00122O0008000C015O0007000700084O000800086O00060008000200062O0006007C040100010004E03O007C04010012280006000D012O0012280007000E012O00060300060083040100070004E03O008304012O006A010600013O00121F0107000F012O00122O00080010015O000600086O00065O00044O008304010004E03O00E80301001228000400063O0004E03O00B20301001228000400063O000622010300AD030100040004E03O00AD0301001228000100BE3O0004E03O008D04010004E03O00AD03010004E03O008D04010004E03O00A80301001228000200BE3O00062201020007000100010004E03O000700012O006A01026O0070000300013O00122O00040011012O00122O00050012015O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200AB04013O0004E03O00AB04012O006A010200064O000B00035O00122O00040013015O0003000300044O000400046O00020004000200062O000200AB04013O0004E03O00AB04012O006A010200013O00121F01030014012O00122O00040015015O000200046O00025O00044O00AB04010004E03O000700010004E03O00AB04010004E03O000200012O003C012O00017O007C3O00028O00025O0066A440025O0088A240025O009AAE40025O00A08440025O00E89240025O00D88A40025O00D49240026O00F03F025O0048AD40030C3O00E10F5012CE00502DD301580E03043O007EA76E35030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66030C3O004661656C696E6553746F6D7003093O004973496E52616E6765026O003E40025O0022AE40025O0038B240031D3O003B112BF4D531382F3DECD3322D503DFDCE3A33193AE1E33328033AB88E03063O005F5D704E98BC030B3O00E7FC9601F7B1D4E7E0970C03073O00B2A195E57584DE03073O0049735265616479030B3O0042752O6652656D61696E73030C3O00536572656E69747942752O66030C3O00436173745461726765744966030B3O0046697374736F66467572792O033O0085DAC503083O0043E8BBBDCCC176C6030E3O004973496E4D656C2O6552616E6765026O002040031D3O008D27A634283DE08D11B335291BAF982BA725350BFB9211B9352816AFDF03073O008FEB4ED5405B62027O0040025O0078A540025O00208B40030D3O00BF4197E07EB1BE5D8AC279B58603063O00D6ED28E48910030D3O00526973696E6753756E4B69636B2O033O0088E2F703063O00C6E5838FB963026O001440031F3O004385BB7A5F8B976044829778588FA3334289BA765F85BC6A6E80BD6045CCF003043O001331ECC8025O00207040025O005EA040030C3O00DC3BF7B4EFB5EB23DDBEE7B103063O00DA9E5796D784030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O0008402O033O00F617D703073O00AD9B7EB9825642031D3O00E7AABBC483E3F0B285CC81EFEEE6A9C29AE9EBAFAEDEB7E0F0B5AE87DE03063O008C85C6DAA7E8025O0070824003133O00863AA6748FB021B2698CB019BD7380B921A67903053O00E4D54ED41D030B3O00B344A30BEF825EB00CF89303053O008BE72CD665030B3O004973417661696C61626C6503133O00537472696B656F6674686557696E646C6F72642O033O00D4EE1E03083O0076B98F663E70D151025O0054B140025O00806E4003273O004F643BEFAE1023375A4F3DEEA02A0B31527425E9B7115C2B59622CE8AC01050750653AF2E5444C03083O00583C104986C5757C030B3O0076E3EBDC525FECDEDD534903053O0021308A98A803063O0042752O66557003133O00496E766F6B65727344656C6967687442752O662O033O007F172803063O005712765031A1031E3O004A17C9B4A37311DC9FB6590CC3E0A3490CDFAEB95807E5ACA55F0A9AF1E203053O00D02C7EBAC003093O00497343617374696E67025O008C9D40025O00A6AA40025O00407E40025O0092A64003073O0053746F70466F4603253O00F113B7D207C3C648C81CB1D40DC3CA4FF919A1CA54EFCC5CF214ADD20DC3C55BE40EE4974003083O002E977AC4A6749CA9030C3O00C7E14719F0EAF85231F22OE603053O009B858D267A03073O00486173546965722O033O002823A203073O00C5454ACC212F1F031E3O00F2435B84FB404F93CF445384FB0F4982E24A548EE456658BE55C4EC7A11903043O00E7902F3A03113O0081C8D37B1634C13E91CADB7B1D16C63AB903083O0059D2B8BA15785DAF03113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O66026O001840025O0044924003243O00A24375DB7733BF5443D66B3BBF5643DE7039BA136FD06B3FBF5A68CC4636A4406895286203063O005AD1331CB519030C3O00F27756EDB4DF6E43C5B6D37003053O00DFB01B378E2O033O0029BAD603043O00D544DBAE031E3O0009EC22E421CA2A6B34EB2AE421852C7A19E52DEE3EDC00731EF337A7789503083O001F6B8043874AA55F03133O00EFE0F55F4DB8D6EFD85F40B6D7E6CC584FB2D003063O00D1B8889C2D2103133O00576869726C696E67447261676F6E50756E6368025O00C08D40025O00A2A14003263O0010C07C1AB40EC67237BC15C97207B638D86006BB0F88660DAA02C67C1CA138C4601BAC479A2703053O00D867A81568025O00D08240025O001AA84003093O004CA444A16A9D42A87503043O00C418CD2303173O001A8EE2052682ED013D84E512268ECE09208AF0122B99FA03043O00664EEB8303093O00546967657250616C6D031B3O00EE2733415506A735F6237457422BB23AF33A2D7B4B2CA420BA7C6003083O00549A4E54242759D70021022O0012283O00014O0074000100013O00260C012O0006000100010004E03O00060001002EE800020002000100030004E03O00020001001228000100013O002EA7010400D7000100040004E03O00DE00010026BF000100DE000100010004E03O00DE0001001228000200014O0074000300033O002E8F0005000D000100060004E03O000D00010026BF0002000D000100010004E03O000D0001001228000300013O00260C01030016000100010004E03O00160001002EE80008006E000100070004E03O006E0001001228000400013O0026BF0004001B000100090004E03O001B0001001228000300093O0004E03O006E00010026BF00040017000100010004E03O00170001002EA7010A00260001000A0004E03O004300012O006A01056O0070000600013O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005004300013O0004E03O004300012O006A010500023O00207701050005000E4O00075O00202O00070007000F4O00050007000200262O00050043000100090004E03O004300012O006A010500034O003400065O00202O0006000600104O000700086O000900023O00202O00090009001100122O000B00126O0009000B00024O000900096O00050009000200062O0005003E000100010004E03O003E0001002EA701130007000100140004E03O004300012O006A010500013O001228000600153O001228000700164O0049010500074O001000056O006A01056O0070000600013O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500194O00050002000200062O0005006C00013O0004E03O006C00012O006A010500043O00207701050005001A4O00075O00202O00070007001B4O00050007000200262O0005006C000100090004E03O006C00012O006A010500053O00200E01050005001C4O00065O00202O00060006001D4O000700066O000800013O00122O0009001E3O00122O000A001F6O0008000A00024O000900076O000A000A6O000B00023O00202O000B000B002000122O000D00216O000B000D00024O000B000B6O0005000B000200062O0005006C00013O0004E03O006C00012O006A010500013O001228000600223O001228000700234O0049010500074O001000055O001228000400093O0004E03O001700010026BF000300D5000100090004E03O00D50001001228000400013O0026BF00040075000100090004E03O00750001001228000300243O0004E03O00D500010026BF00040071000100010004E03O00710001002EE80026009B000100250004E03O009B00012O006A01056O0070000600013O00122O000700273O00122O000800286O0006000800024O00050005000600202O0005000500194O00050002000200062O0005009B00013O0004E03O009B00012O006A010500053O00200E01050005001C4O00065O00202O0006000600294O000700086O000800013O00122O0009002A3O00122O000A002B6O0008000A00024O000900076O000A000A6O000B00023O00202O000B000B002000122O000D002C6O000B000D00024O000B000B6O0005000B000200062O0005009B00013O0004E03O009B00012O006A010500013O0012280006002D3O0012280007002E4O0049010500074O001000055O002E8F002F00D3000100300004E03O00D300012O006A01056O0070000600013O00122O000700313O00122O000800326O0006000800024O00050005000600202O0005000500194O00050002000200062O000500D300013O0004E03O00D300012O006A010500094O006A01065O0020D40006000600332O00300105000200020006A3000500D300013O0004E03O00D300012O006A010500043O0020580005000500344O00075O00202O0007000700354O00050007000200262O000500D3000100360004E03O00D300012O006A010500043O00207701050005001A4O00075O00202O0007000700354O00050007000200262O000500D3000100090004E03O00D300012O006A010500053O00200E01050005001C4O00065O00202O0006000600334O000700086O000800013O00122O000900373O00122O000A00386O0008000A00024O0009000A6O000A000A6O000B00023O00202O000B000B002000122O000D002C6O000B000D00024O000B000B6O0005000B000200062O000500D300013O0004E03O00D300012O006A010500013O001228000600393O0012280007003A4O0049010500074O001000055O001228000400093O0004E03O00710001002EA7013B003DFF2O003B0004E03O001200010026BF00030012000100240004E03O00120001001228000100093O0004E03O00DE00010004E03O001200010004E03O00DE00010004E03O000D00010026BF0001007D2O0100090004E03O007D2O012O006A01026O0070000300013O00122O0004003C3O00122O0005003D6O0003000500024O00020002000300202O0002000200194O00020002000200062O0002000E2O013O0004E03O000E2O012O006A01026O0070000300013O00122O0004003E3O00122O0005003F6O0003000500024O00020002000300202O0002000200404O00020002000200062O0002000E2O013O0004E03O000E2O012O006A010200053O00208C00020002001C4O00035O00202O0003000300414O000400086O000500013O00122O000600423O00122O000700436O0005000700024O000600076O000700076O000800023O00202O00080008002000122O000A002C6O0008000A00024O000800086O00020008000200062O000200092O0100010004E03O00092O01002EA701440007000100450004E03O000E2O012O006A010200013O001228000300463O001228000400474O0049010200044O001000026O006A01026O0070000300013O00122O000400483O00122O000500496O0003000500024O00020002000300202O0002000200194O00020002000200062O000200372O013O0004E03O00372O012O006A010200043O00206401020002004A4O00045O00202O00040004004B4O00020004000200062O000200372O013O0004E03O00372O012O006A010200053O00200E01020002001C4O00035O00202O00030003001D4O000400066O000500013O00122O0006004C3O00122O0007004D6O0005000700024O000600076O000700076O000800023O00202O00080008002000122O000A00216O0008000A00024O000800086O00020008000200062O000200372O013O0004E03O00372O012O006A010200013O0012280003004E3O0012280004004F4O0049010200044O001000026O006A010200043O00208F0102000200504O00045O00202O00040004001D4O00020004000200062O000200402O0100010004E03O00402O01002EE80052004D2O0100510004E03O004D2O01002EE80053004D2O0100540004E03O004D2O012O006A0102000B4O006A0103000C3O0020D40003000300552O00300102000200020006A30002004D2O013O0004E03O004D2O012O006A010200013O001228000300563O001228000400574O0049010200044O001000026O006A01026O0070000300013O00122O000400583O00122O000500596O0003000500024O00020002000300202O0002000200194O00020002000200062O0002007C2O013O0004E03O007C2O012O006A010200094O006A01035O0020D40003000300332O00300102000200020006A30002007C2O013O0004E03O007C2O012O006A010200043O0020A101020002005A00122O000400123O00122O000500246O00020005000200062O0002007C2O013O0004E03O007C2O012O006A010200053O00200E01020002001C4O00035O00202O0003000300334O000400086O000500013O00122O0006005B3O00122O0007005C6O0005000700024O0006000A6O000700076O000800023O00202O00080008002000122O000A002C6O0008000A00024O000800086O00020008000200062O0002007C2O013O0004E03O007C2O012O006A010200013O0012280003005D3O0012280004005E4O0049010200044O001000025O001228000100243O0026BF00010007000100240004E03O000700012O006A01026O0070000300013O00122O0004005F3O00122O000500606O0003000500024O00020002000300202O0002000200194O00020002000200062O000200962O013O0004E03O00962O012O006A010200094O006A01035O0020D40003000300612O00300102000200020006A3000200962O013O0004E03O00962O012O006A010200043O00208F01020002004A4O00045O00202O0004000400624O00020004000200062O000200982O0100010004E03O00982O01002EE8006400A92O0100630004E03O00A92O012O006A010200034O001C01035O00202O0003000300614O000400056O000600023O00202O00060006002000122O000800216O0006000800024O000600066O00020006000200062O000200A92O013O0004E03O00A92O012O006A010200013O001228000300653O001228000400664O0049010200044O001000026O006A01026O0070000300013O00122O000400673O00122O000500686O0003000500024O00020002000300202O0002000200194O00020002000200062O000200D12O013O0004E03O00D12O012O006A010200094O006A01035O0020D40003000300332O00300102000200020006A3000200D12O013O0004E03O00D12O012O006A010200053O00200E01020002001C4O00035O00202O0003000300334O000400086O000500013O00122O000600693O00122O0007006A6O0005000700024O000600076O000700076O000800023O00202O00080008002000122O000A002C6O0008000A00024O000800086O00020008000200062O000200D12O013O0004E03O00D12O012O006A010200013O0012280003006B3O0012280004006C4O0049010200044O001000026O006A01026O0070000300013O00122O0004006D3O00122O0005006E6O0003000500024O00020002000300202O0002000200194O00020002000200062O000200EE2O013O0004E03O00EE2O012O006A010200034O003400035O00202O00030003006F4O000400056O000600023O00202O00060006002000122O0008002C6O0006000800024O000600066O00020006000200062O000200E92O0100010004E03O00E92O01002EA701700007000100710004E03O00EE2O012O006A010200013O001228000300723O001228000400734O0049010200044O001000025O002EE800740020020100750004E03O002002012O006A01026O0070000300013O00122O000400763O00122O000500776O0003000500024O00020002000300202O0002000200194O00020002000200062O0002002002013O0004E03O002002012O006A01026O0070000300013O00122O000400783O00122O000500796O0003000500024O00020002000300202O0002000200404O00020002000200062O0002002002013O0004E03O002002012O006A010200043O0020770102000200344O00045O00202O0004000400354O00020004000200262O00020020020100360004E03O002002012O006A010200034O001C01035O00202O00030003007A4O000400056O000600023O00202O00060006002000122O0008002C6O0006000800024O000600066O00020006000200062O0002002002013O0004E03O002002012O006A010200013O00121F0103007B3O00122O0004007C6O000200046O00025O00044O002002010004E03O000700010004E03O002002010004E03O000200012O003C012O00017O00D93O00028O00025O00606740025O003C9E40026O00F03F025O0070A240025O004EAA40025O00388E40025O00408C40025O002AA240025O00108440026O001040030C3O007AD3EBC3A5E623EE73D6E9CB03083O009A38BF8AA0CE895603073O004973526561647903123O00B551F483732D83C39E50FB80482884CD824A03083O00ACE63995E71C5AE1030B3O004973417661696C61626C65026O000840030C3O00426C61636B6F75744B69636B030C3O004361737454617267657449662O033O000FA38803063O00BB62CAE6B248030E3O004973496E4D656C2O6552616E6765026O001440031D3O0023EDA533412EF4B00F4128E2AF705924F3A13E4335F89B314524A1F76403053O002A4181C45003133O00315E4FD31C020DE8164258ED1E0906E20D585903083O008E622A3DBA77676203133O00537472696B656F6674686557696E646C6F72642O033O0035BE1A03043O006858DF6203263O0057E3F0C709E87BF8E4F116E541C8F5C70CE948F8F0CA42FE41E5E7C00BF95DC8E3C107AD17A103063O008D249782AE6203113O00B76ACB038A73CC0AA768C3038151CB0E8F03043O006DE41AA203113O005370692O6E696E674372616E654B69636B025O00B5B140025O00806740025O0028A440025O00F6AE40026O00204003233O004DF5F476EEEF50E2C27BF2E750E0C273E9E555A5EE7DF2E350ECE961DFE751E0BD2BB803063O00863E859D1880025O00309540025O003CA94003133O0030AD13CB23B8D8008108D828BED837B014DA2703073O00B667C57AB94FD103133O00576869726C696E67447261676F6E50756E636803253O00E48FE8650C41FD80DE731249F488EF48105DFD84E937134DE182EF7E1451CC86EE72401CA303063O002893E7811760025O00C0A340025O0032A440030C3O00D716CDF3AC042CCADE13CFFB03083O00BE957AAC90C76B59026O00184003073O0048617354696572026O003E40027O0040025O00A09240025O000495402O033O003F0CFF03053O009E5265919E031D3O0072F203154F7FEB16294F79FD09565775EC07184D64E73D174B75BE504003053O0024109E627603113O00F306CAF556E129E2E304C2F55DC32EE6CB03083O0085A076A39B388847025O002OAC4003233O00E5B278FCB816BBF19D72E0B711B0C9A978F1BD5FA6F3B074FCBF0BACC9A37EF7F64DED03073O00D596C21192D67F025O00D07840025O00DCA64003093O002FA0A3D15494A33A1603083O00567BC9C4B426C4C203093O00546967657250616C6D2O033O00FAE1D703043O00CF9788B9025O002CB340025O00B89340031A3O00BC8A2F87664761A98F25C2677D63AD8D21966D4770A78668D12403073O0011C8E348E21418030F3O00825408DFC0FFE8D5B1451EE0C0FFEB03083O009FD0217BB7A9918F03083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66030F3O0052757368696E674A61646557696E6403213O00E04F2B3EFB543F09F85B3C33CD4D3138F61A2B33E05F363FE6430737FD5F7865A003043O0056923A58025O00CCA440025O00C89F40025O00C4B140025O00509D40030C3O00DBE053540CF3E4654C0AF0F103053O00659D813638030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66025O002EA740030C3O004661656C696E6553746F6D7003093O004973496E52616E6765031C3O001BA88FA72A77189699BF2C740DE999AE317C13A09EB21C7812ACCAF903063O00197DC9EACB4303113O004AE4110D1A2E1D7ED70A021A223870F71303073O007319947863744703063O0042752O66557003103O0044616E63656F664368696A6942752O66025O00E49440025O00108C4003223O001F2DB02A4F0533BE1B421E3CB7217E0734BA2F011F38AB214F0529A01B400338F97C03053O00216C5DD944025O001CAA40025O00FCAF40030D3O00E942B2A4D54C92B8D560A8AED003043O00CDBB2BC103113O005072652O73757265506F696E7442752O66030D3O00526973696E6753756E4B69636B2O033O00F37B0B03043O00BF9E1265031F3O00D7CA94BEA1C2FC94A2A1FAC88EB4A485D082A5AACBCA93AE90C4CC82F7FE9503053O00CFA5A3E7D7030D3O00F4F0EA5F2A77F5ECF77D2D73CD03063O0010A62O9936442O033O00DFBACE03073O0099B2D3A0265441031F3O00900249228C0C6538970565208B08516B910E482E8C024E32BD0A552EC25A0803043O004BE26B3A025O008AAE40025O00E06840025O0021B340025O00E07E40025O006FB14003133O00F5B70980C4C3AC1D9DC7C3941287CBCAAC098D03053O00AFA6C37BE9030B3O00DBCA4847F4EAD05B40E3FB03053O00908FA23D2903133O0043612O6C746F446F6D696E616E636542752O66026O0024402O033O00EDD20503073O005380B37D3012E703263O004EA3E1D44C1B62B8F5E253165888E4D4491A51B8E1D9070D58A5F6D34E0A4488F2D2425E0CE303063O007E3DD793BD27026O00AC40025O00A88D40030C3O005EFE184971F118766CF0105503043O0025189F7D031D3O00DCA7704ED3A8707DC9B27A4FCAE66647C8A37B4BCEBF4A43D5A335138C03043O0022BAC615025O00B6AF40025O0058A540030C3O007AD210791ACDD84CF518791A03073O00AD38BE711A71A203093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66030B3O0042752O6652656D61696E732O033O00C6D72303053O0097ABBE4D65031C3O00C723F9AAF3721ED110F3A0FB764BD62AEAACF6741FDC10F9A6FD3D5D03073O006BA54F98C9981D030C3O007542E9C85F70425AC3C2577403063O001F372E88AB3403123O00E220DDF0DE3FDEFBC921D2F3E53AD9F5D53B03043O0094B148BC2O033O00ABBF5903043O00B3C6D637031C3O00F20073754EDCE5184D7D4CD0FB4C617357D6FE05666F7AD2FF09322203063O00B3906C121625025O000EB040025O00D6A340030C3O0057F48D46B0A3C961D38546B003073O00BC1598EC25DBCC025O0076A840025O0088A7402O033O004DE82F03043O006C208957031D3O00A8E401A524F65E4D95E309A524B9585CB8ED0EAF3BE07458A5ED40F27D03083O0039CA8860C64F992B025O00A89140025O00D08A4003093O009F2AADA29F97F9A72E03073O0098CB43CAC7EDC703173O00CE46A10C177C77E1E94CA61B177054E9F442B31B1A676003083O00869A23C06F7F1519025O00E89E40025O00688840031A3O00AC2F0E0F32EDA827050760C1BD340C0429C6A11908052592EC7203063O00B2D846696A40025O00BAB140025O00FFB140025O00988D40025O0042AC4003133O0073F0F4C44BE1E9CB54ECE3FA49EAE2C14FF6E203043O00AD208486030B3O007A131DE1AA34DF48121BFB03073O00AD2E7B688FCE512O033O00B91C3A03073O0061D47D42EA25E303263O0099F7A43C158FDCB933219EEBB30A0983EDB2391198E7F6261B98E6B83C0A93DCB73A1BCAB1E403053O007EEA83D65503113O00B7C54054418DDB4E795D85DB4C714687DE03053O002FE4B5293A025O00C05040025O0004914003233O00B5ECD0350D3911A1C3DA29023E1A99F7D03808700CA3EEDC350A240699FDD63E43624B03073O007FC69CB95B6350030B3O00DE01D649D1F70EE348D0E103053O00A29868A53D03133O00496E766F6B65727344656C6967687442752O66030B3O0046697374736F66467572792O033O00C02EAA03063O0085AD4FD21D10025O00D49440025O00407F40031D3O008B75FE3F9E43E22DB27AF839943CFE2E9F79E3229965D22A8279AD7AD503043O004BED1C8D03093O00497343617374696E6703073O0053746F70466F4603243O00DA56DFA53C24E8E7E359D9A33624E4E0D25CC9BD6F08E2F3D951C5A53624E6EED91F9EE103083O0081BC3FACD14F7B87002B042O0012283O00014O0074000100023O00260C012O0006000100010004E03O00060001002EE800030009000100020004E03O00090001001228000100014O0074000200023O0012283O00043O002EE800050002000100060004E03O000200010026BF3O0002000100040004E03O00020001002EE80008000D000100070004E03O000D00010026BF0001000D000100010004E03O000D0001001228000200013O002E8F000A00B0000100090004E03O00B000010026BF000200B00001000B0004E03O00B000012O006A01036O0070000400013O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003004B00013O0004E03O004B00012O006A01036O0070000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O0003004B00013O0004E03O004B00012O006A010300023O000E2E0112004B000100030004E03O004B00012O006A010300034O006A01045O0020D40004000400132O00300103000200020006A30003004B00013O0004E03O004B00012O006A010300043O00200E0103000300144O00045O00202O0004000400134O000500056O000600013O00122O000700153O00122O000800166O0006000800024O000700066O000800086O000900073O00202O00090009001700122O000B00186O0009000B00024O000900096O00030009000200062O0003004B00013O0004E03O004B00012O006A010300013O001228000400193O0012280005001A4O0049010300054O001000036O006A01036O0070000400013O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003006D00013O0004E03O006D00012O006A010300043O00200E0103000300144O00045O00202O00040004001D4O000500056O000600013O00122O0007001E3O00122O0008001F6O0006000800024O000700086O000800086O000900073O00202O00090009001700122O000B00186O0009000B00024O000900096O00030009000200062O0003006D00013O0004E03O006D00012O006A010300013O001228000400203O001228000500214O0049010300054O001000036O006A01036O0070000400013O00122O000500223O00122O000600236O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003007D00013O0004E03O007D00012O006A010300034O006A01045O0020D40004000400242O00300103000200020006820103007F000100010004E03O007F0001002EE800250092000100260004E03O00920001002EE800270092000100280004E03O009200012O006A010300094O001C01045O00202O0004000400244O000500066O000700073O00202O00070007001700122O000900296O0007000900024O000700076O00030007000200062O0003009200013O0004E03O009200012O006A010300013O0012280004002A3O0012280005002B4O0049010300054O001000035O002EE8002C00AF0001002D0004E03O00AF00012O006A01036O0070000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300AF00013O0004E03O00AF00012O006A010300094O001C01045O00202O0004000400304O000500066O000700073O00202O00070007001700122O000900186O0007000900024O000700076O00030007000200062O000300AF00013O0004E03O00AF00012O006A010300013O001228000400313O001228000500324O0049010300054O001000035O001228000200183O0026BF0002006C2O0100120004E03O006C2O01001228000300013O002EE8003300132O0100340004E03O00132O010026BF000300132O0100010004E03O00132O012O006A01046O0070000500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400EB00013O0004E03O00EB00012O006A010400023O002650010400EB000100370004E03O00EB00012O006A010400034O006A01055O0020D40005000500132O00300104000200020006A3000400EB00013O0004E03O00EB00012O006A0104000A3O0020A101040004003800122O000600393O00122O0007003A6O00040007000200062O000400EB00013O0004E03O00EB0001002EE8003B00EB0001003C0004E03O00EB00012O006A010400043O00200E0104000400144O00055O00202O0005000500134O000600056O000700013O00122O0008003D3O00122O0009003E6O0007000900024O000800066O000900096O000A00073O00202O000A000A001700122O000C00186O000A000C00024O000A000A6O0004000A000200062O000400EB00013O0004E03O00EB00012O006A010400013O0012280005003F3O001228000600404O0049010400064O001000046O006A01046O0070000500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400122O013O0004E03O00122O012O006A010400034O006A01055O0020D40005000500242O00300104000200020006A3000400122O013O0004E03O00122O012O006A0104000B4O00B10004000100020006A3000400122O013O0004E03O00122O01002EA701430013000100430004E03O00122O012O006A010400094O001C01055O00202O0005000500244O000600076O000800073O00202O00080008001700122O000A00296O0008000A00024O000800086O00040008000200062O000400122O013O0004E03O00122O012O006A010400013O001228000500443O001228000600454O0049010400064O001000045O001228000300043O0026BF000300172O01003A0004E03O00172O010012280002000B3O0004E03O006C2O0100260C0103001B2O0100040004E03O001B2O01002EA70146009AFF2O00470004E03O00B300012O006A01046O0070000500013O00122O000600483O00122O000700496O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400482O013O0004E03O00482O012O006A010400034O006A01055O0020D400050005004A2O00300104000200020006A3000400482O013O0004E03O00482O012O006A010400023O0026BF000400482O0100180004E03O00482O012O006A010400043O00208C0004000400144O00055O00202O00050005004A4O000600056O000700013O00122O0008004B3O00122O0009004C6O0007000900024O0008000C6O000900096O000A00073O00202O000A000A001700122O000C00186O000A000C00024O000A000A6O0004000A000200062O000400432O0100010004E03O00432O01002EA7014D00070001004E0004E03O00482O012O006A010400013O0012280005004F3O001228000600504O0049010400064O001000046O006A01046O0070000500013O00122O000600513O00122O000700526O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004006A2O013O0004E03O006A2O012O006A0104000A3O0020640104000400534O00065O00202O0006000600544O00040006000200062O0004006A2O013O0004E03O006A2O012O006A010400094O001C01055O00202O0005000500554O000600076O000800073O00202O00080008001700122O000A00296O0008000A00024O000800086O00040008000200062O0004006A2O013O0004E03O006A2O012O006A010400013O001228000500563O001228000600574O0049010400064O001000045O0012280003003A3O0004E03O00B300010026BF0002002F020100010004E03O002F0201001228000300013O00260C010300732O0100010004E03O00732O01002EA70158005B000100590004E03O00CC2O01001228000400013O002E8F005B00C72O01005A0004E03O00C72O010026BF000400C72O0100010004E03O00C72O012O006A01056O0070000600013O00122O0007005C3O00122O0008005D6O0006000800024O00050005000600202O00050005005E4O00050002000200062O0005009C2O013O0004E03O009C2O012O006A010500073O00207701050005005F4O00075O00202O0007000700604O00050007000200262O0005009C2O0100040004E03O009C2O01002EA701610013000100610004E03O009C2O012O006A010500094O001C01065O00202O0006000600624O000700086O000900073O00202O00090009006300122O000B00396O0009000B00024O000900096O00050009000200062O0005009C2O013O0004E03O009C2O012O006A010500013O001228000600643O001228000700654O0049010500074O001000056O006A01056O0070000600013O00122O000700663O00122O000800676O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500B32O013O0004E03O00B32O012O006A010500034O006A01065O0020D40006000600242O00300105000200020006A3000500B32O013O0004E03O00B32O012O006A0105000A3O00208F0105000500684O00075O00202O0007000700694O00050007000200062O000500B52O0100010004E03O00B52O01002EE8006A00C62O01006B0004E03O00C62O012O006A010500094O001C01065O00202O0006000600244O000700086O000900073O00202O00090009001700122O000B00296O0009000B00024O000900096O00050009000200062O000500C62O013O0004E03O00C62O012O006A010500013O0012280006006C3O0012280007006D4O0049010500074O001000055O001228000400043O0026BF000400742O0100040004E03O00742O01001228000300043O0004E03O00CC2O010004E03O00742O010026BF000300D02O01003A0004E03O00D02O01001228000200043O0004E03O002F0201002EE8006E006F2O01006F0004E03O006F2O01000E510104006F2O0100030004E03O006F2O012O006A01046O0070000500013O00122O000600703O00122O000700716O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004000402013O0004E03O000402012O006A0104000A3O0020640104000400684O00065O00202O0006000600724O00040006000200062O0004000402013O0004E03O000402012O006A0104000A3O0020A101040004003800122O000600393O00122O0007003A6O00040007000200062O0004000402013O0004E03O000402012O006A010400043O00200E0104000400144O00055O00202O0005000500734O000600056O000700013O00122O000800743O00122O000900756O0007000900024O000800066O000900096O000A00073O00202O000A000A001700122O000C00186O000A000C00024O000A000A6O0004000A000200062O0004000402013O0004E03O000402012O006A010400013O001228000500763O001228000600774O0049010400064O001000046O006A01046O0070000500013O00122O000600783O00122O000700796O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004002D02013O0004E03O002D02012O006A0104000A3O0020A101040004003800122O000600393O00122O0007003A6O00040007000200062O0004002D02013O0004E03O002D02012O006A010400043O00200E0104000400144O00055O00202O0005000500734O000600056O000700013O00122O0008007A3O00122O0009007B6O0007000900024O000800066O000900096O000A00073O00202O000A000A001700122O000C00186O000A000C00024O000A000A6O0004000A000200062O0004002D02013O0004E03O002D02012O006A010400013O0012280005007C3O0012280006007D4O0049010400064O001000045O0012280003003A3O0004E03O006F2O01002EA7017E00E40001007E0004E03O001303010026BF00020013030100040004E03O00130301001228000300013O000E91013A0038020100030004E03O00380201002E8F0080003A0201007F0004E03O003A02010012280002003A3O0004E03O00130301000E910104003E020100030004E03O003E0201002E8F00820099020100810004E03O009902012O006A01046O0070000500013O00122O000600833O00122O000700846O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004007402013O0004E03O007402012O006A01046O0070000500013O00122O000600853O00122O000700866O0005000700024O00040004000500202O0004000400114O00040002000200062O0004007402013O0004E03O007402012O006A0104000A3O0020640104000400684O00065O00202O0006000600874O00040006000200062O0004007402013O0004E03O007402012O006A010400023O00265001040074020100880004E03O007402012O006A010400043O0020EE0004000400144O00055O00202O00050005001D4O000600056O000700013O00122O000800893O00122O0009008A6O0007000900024O000800086O0009000D4O006A010A00073O0020EF000A000A001700122O000C00186O000A000C00024O000A000A6O0004000A000200062O0004007402013O0004E03O007402012O006A010400013O0012280005008B3O0012280006008C4O0049010400064O001000045O002E8F008E00980201008D0004E03O009802012O006A01046O0070000500013O00122O0006008F3O00122O000700906O0005000700024O00040004000500202O00040004005E4O00040002000200062O0004009802013O0004E03O009802012O006A010400073O00207701040004005F4O00065O00202O0006000600604O00040006000200262O000400980201003A0004E03O009802012O006A010400094O001C01055O00202O0005000500624O000600076O000800073O00202O00080008006300122O000A00396O0008000A00024O000800086O00040008000200062O0004009802013O0004E03O009802012O006A010400013O001228000500913O001228000600924O0049010400064O001000045O0012280003003A3O0026BF00030034020100010004E03O00340201001228000400013O0026BF000400A0020100040004E03O00A00201001228000300043O0004E03O003402010026BF0004009C020100010004E03O009C0201002E8F009400DA020100930004E03O00DA02012O006A01056O0070000600013O00122O000700953O00122O000800966O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500DA02013O0004E03O00DA02012O006A010500034O006A01065O0020D40006000600132O00300105000200020006A3000500DA02013O0004E03O00DA02012O006A0105000A3O0020580005000500974O00075O00202O0007000700984O00050007000200262O000500DA020100120004E03O00DA02012O006A0105000A3O0020770105000500994O00075O00202O0007000700984O00050007000200262O000500DA020100040004E03O00DA02012O006A010500043O00200E0105000500144O00065O00202O0006000600134O000700056O000800013O00122O0009009A3O00122O000A009B6O0008000A00024O000900066O000A000A6O000B00073O00202O000B000B001700122O000D00186O000B000D00024O000B000B6O0005000B000200062O000500DA02013O0004E03O00DA02012O006A010500013O0012280006009C3O0012280007009D4O0049010500074O001000056O006A01056O0070000600013O00122O0007009E3O00122O0008009F6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005001003013O0004E03O001003012O006A010500034O006A01065O0020D40006000600132O00300105000200020006A30005001003013O0004E03O001003012O006A0105000B4O00B100050001000200068201050010030100010004E03O001003012O006A01056O0070000600013O00122O000700A03O00122O000800A16O0006000800024O00050005000600202O0005000500114O00050002000200062O0005001003013O0004E03O001003012O006A010500043O00200E0105000500144O00065O00202O0006000600134O000700056O000800013O00122O000900A23O00122O000A00A36O0008000A00024O000900066O000A000A6O000B00073O00202O000B000B001700122O000D00186O000B000D00024O000B000B6O0005000B000200062O0005001003013O0004E03O001003012O006A010500013O001228000600A43O001228000700A54O0049010500074O001000055O001228000400043O0004E03O009C02010004E03O00340201002E8F00A70072030100A60004E03O007203010026BF00020072030100180004E03O007203012O006A01036O0070000400013O00122O000500A83O00122O000600A96O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003002703013O0004E03O002703012O006A010300034O006A01045O0020D40004000400132O003001030002000200068201030029030100010004E03O00290301002E8F00AA0041030100AB0004E03O004103012O006A010300043O00200E0103000300144O00045O00202O0004000400134O000500056O000600013O00122O000700AC3O00122O000800AD6O0006000800024O000700086O000800086O000900073O00202O00090009001700122O000B00186O0009000B00024O000900096O00030009000200062O0003004103013O0004E03O004103012O006A010300013O001228000400AE3O001228000500AF4O0049010300054O001000035O002E8F00B1002A040100B00004E03O002A04012O006A01036O0070000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003002A04013O0004E03O002A04012O006A01036O0070000400013O00122O000500B43O00122O000600B56O0004000600024O00030003000400202O0003000300114O00030002000200062O0003002A04013O0004E03O002A04012O006A0103000A3O0020770103000300974O00055O00202O0005000500984O00030005000200262O0003002A040100120004E03O002A0401002E8F00B7002A040100B60004E03O002A04012O006A010300094O001C01045O00202O00040004004A4O000500066O000700073O00202O00070007001700122O000900186O0007000900024O000700076O00030007000200062O0003002A04013O0004E03O002A04012O006A010300013O00121F010400B83O00122O000500B96O000300056O00035O00044O002A04010026BF000200120001003A0004E03O00120001001228000300014O0074000400043O002E8F00BA0076030100BB0004E03O007603010026BF00030076030100010004E03O00760301001228000400013O002E8F00BC00DE030100BD0004E03O00DE03010026BF000400DE030100040004E03O00DE0301001228000500013O0026BF000500D9030100010004E03O00D903012O006A01066O0070000700013O00122O000800BE3O00122O000900BF6O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600AE03013O0004E03O00AE03012O006A01066O0070000700013O00122O000800C03O00122O000900C16O0007000900024O00060006000700202O0006000600114O00060002000200062O000600AE03013O0004E03O00AE03012O006A010600043O00200E0106000600144O00075O00202O00070007001D4O000800056O000900013O00122O000A00C23O00122O000B00C36O0009000B00024O000A00086O000B000B6O000C00073O00202O000C000C001700122O000E00186O000C000E00024O000C000C6O0006000C000200062O000600AE03013O0004E03O00AE03012O006A010600013O001228000700C43O001228000800C54O0049010600084O001000066O006A01066O0070000700013O00122O000800C63O00122O000900C76O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600D803013O0004E03O00D803012O006A010600034O006A01075O0020D40007000700242O00300106000200020006A3000600D803013O0004E03O00D803012O006A0106000A3O0020640106000600684O00085O00202O0008000800694O00060008000200062O000600D803013O0004E03O00D803012O006A010600094O003400075O00202O0007000700244O000800096O000A00073O00202O000A000A001700122O000C00296O000A000C00024O000A000A6O0006000A000200062O000600D3030100010004E03O00D30301002EE800C900D8030100C80004E03O00D803012O006A010600013O001228000700CA3O001228000800CB4O0049010600084O001000065O001228000500043O0026BF00050080030100040004E03O008003010012280004003A3O0004E03O00DE03010004E03O008003010026BF000400E20301003A0004E03O00E20301001228000200123O0004E03O001200010026BF0004007B030100010004E03O007B03012O006A01056O0070000600013O00122O000700CC3O00122O000800CD6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005000F04013O0004E03O000F04012O006A0105000A3O0020640105000500684O00075O00202O0007000700CE4O00050007000200062O0005000F04013O0004E03O000F04012O006A010500043O00208C0005000500144O00065O00202O0006000600CF4O0007000E6O000800013O00122O000900D03O00122O000A00D16O0008000A00024O000900086O000A000A6O000B00073O00202O000B000B001700122O000D00296O000B000D00024O000B000B6O0005000B000200062O0005000A040100010004E03O000A0401002E8F00D2000F040100D30004E03O000F04012O006A010500013O001228000600D43O001228000700D54O0049010500074O001000056O006A0105000A3O0020640105000500D64O00075O00202O0007000700CF4O00050007000200062O0005002104013O0004E03O002104012O006A0105000F4O006A010600103O0020D40006000600D72O00300105000200020006A30005002104013O0004E03O002104012O006A010500013O001228000600D83O001228000700D94O0049010500074O001000055O001228000400043O0004E03O007B03010004E03O001200010004E03O007603010004E03O001200010004E03O002A04010004E03O000D00010004E03O002A04010004E03O000200012O003C012O00017O00DD3O00028O00026O002E40025O0049B040026O001C40025O00E6A540025O00DCA14003093O00E0D4263C09E4DC2D3403053O007BB4BD415903073O004973526561647903173O00F689F1E781CB822OF786C498F8E1A4CD82F1F79DC79EE903053O00E9A2EC9084030B3O004973417661696C61626C6503093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O00084003093O00546967657250616C6D030E3O004973496E4D656C2O6552616E6765026O00144003193O00A6CDF91FABC94FB3C8F35AAAF34DB7CAF70EA0C90BA684AA4E03073O003FD2A49E7AD996025O0096B140025O0034A340025O0010A140025O0016AE40026O00F03F025O00349D40025O00808D40025O00CAA840030C3O000B72C0E0FEA5953D55C8E0FE03073O00E0491EA18395CA03123O00C2EDF054FEF2F35FE9ECFF57C5F7F451F5F603043O0030918591030C3O00426C61636B6F75744B69636B030C3O004361737454617267657449662O033O005745BB03063O004C3A2CD58EB1031C3O00C928132E73C431061273C227196D6BCE36172371DF3D2D796C8B774003053O0018AB44724D03133O00DC09425B8CDB0BABFB1555658ED000A1E00F5403083O00CD8F7D3032E7BE64025O008EA840025O001DB34003133O00537472696B656F6674686557696E646C6F72642O033O00CCA60C03083O00C2A1C774658183BF03253O00FF30DAA1FCA7D32BCE97E3AAE91BDFA1F9A6E02BDAACB7B1E936CDA6FEB6F51B9CBCB7F1B803063O00C28C44A8C89703113O0071EBDC2BFB4BF5D206E743F5D00EFC41F003053O0095229BB54503113O005370692O6E696E674372616E654B69636B025O00A7B240025O00406D40026O00204003223O0010EDDCF40DF4DBFD3CFEC7FB0DF8EAF10AFEDEBA10F8C7FF0DF4C1E33CA9C1BA50AB03043O009A639DB5026O001840030C3O0070F1ECDE7CBA47E9C6D474BE03063O00D5329D8DBD17025O0005B340025O009891402O033O00F3279C03063O00C49E46E4C012031C3O004853104DD2454A0571D2435C1A0ECA4F4D1440D05E462E1ACD0A0B4303053O00B92A3F712E025O0034B040025O004EB04003133O00BA07E5B2E08401EB84FE8C08E3AEDC9801EFA803053O008CED6F8CC0025O00849240025O00E09A4003133O00576869726C696E67447261676F6E50756E636803243O002O11742O0A10731F391D6F1901167327160C731B0E596E1D141C73111200424C12592E4003043O007866791D030F3O009EF6AA33A5EDBE11ADE7BC0CA5EDBD03043O005BCC83D903083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66030F3O0052757368696E674A61646557696E6403203O00DCEA46DCBAD3F9F1F554D0B6E2E9C7F15194A0D8ECCBF15CC0AAE2AADABF018403073O009EAE9F35B4D3BD025O004EA840025O000C9940030D3O0036A2A135560EEE11A599355B0203073O00BD64CBD25C386903063O0042752O66557003113O005072652O73757265506F696E7442752O66030C3O000D5EF32D2B44EE3C0D43F83F03043O00484F319D030D3O00526973696E6753756E4B69636B2O033O0085B93F03043O00DCE8D051025O00249A40025O00CAA440031D3O00E7B7F639225D9EE6ABEB0F2753A22OFEF6353E5FAFFCAAFC0F784EE1AD03073O00C195DE85504C3A030C3O00192A7FFAC0DBD1B32B2477E603083O00E05F4B1A96A9B5B4030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66025O00349940025O00809340030C3O004661656C696E6553746F6D7003093O004973496E52616E6765026O003E40031B3O000DDBDD244DA27334C9CC2749BC3618DFCA2D4AA56212E58C3C04FE03073O00166BBAB84824CC03093O00D3B4234B1CD7BC284303053O006E87DD442E2O033O00EE3F0203073O005B83566C8BAED303183O00EF22BF124FC43BB91B50BB38BD0558F522AC0E62AF3FF84303053O003D9B4BD877025O004DB340025O00388240030C3O00FDAD73BC08B1435DF4A871B403083O0029BFC112DF63DE36030B3O0042752O6652656D61696E732O033O00A62FC903053O00CACB46A74A025O00E08D40025O00BEA140031B3O002E0DDD307A2314C80C7A2502D773622913D93D783818E367656C5703053O00114C61BC53027O0040030D3O00F4545CDBC85A7CC7C87646D1CD03043O00B2A63D2F03073O00486173546965722O033O00F643E603063O005E9B2A881AAA025O005C9C40025O00DEAC40031E3O00963635BC8A3819A6913119BE8D3C2DF5973A34B08A3632ACBB6B32F5D56F03043O00D5E45F46030D3O0018B2D18D792D88D78A5C23B8C903053O00174ADBA2E42O033O0034EF4803053O005B598626CF031E3O0056E7DB3F1DD71857FBC60918D9244FAEDB3301D5294DFAD10947C46715BC03073O0047248EA85673B0025O00908440025O00509A40025O005FB240025O00E0714003133O00B633CB3E3B8644A5912FDC00398D4FAF8A35DD03083O00C3E547B95750E32B030B3O00D4F4155EEBE5EE0659FCF403053O008F809C603003133O0043612O6C746F446F6D696E616E636542752O66025O0056A440025O002O8040025O00E06840025O0042B2402O033O00B5D0E803053O0077D8B1907203253O00DA3DEB4BC22CC64DCF16ED4ACC16EE4BC72DF54DDB2DB951CC3BFC4CC03DE07D9D3DB9139D03043O0022A94999030C3O008CED0E87A3E20EB8BEE3069B03043O00EBCA8C6B031C3O000A7531A4E029F2FA1F603BA5F967E4C01E713AA1FD3EC891183465FE03083O00A56C1454C8894797025O00E88F40025O00C89140030B3O005CBD389C69BB2DAE6FA63203043O00E81AD44B03133O00496E766F6B65727344656C6967687442752O66030B3O0046697374736F66467572792O033O003A486A03053O009757291288031C3O005DA6D9C4ED64A0CCEFF84EBDD390ED5EBDCFDEF74FB6F584EA1BFE9203053O009E3BCFAAB003093O00497343617374696E6703073O0053746F70466F4603233O004957205D9F705135768A5A4C2A768F4E50304C800F4D365B8941572750B31B4A731BDC03053O00EC2F3E532903133O00C9BD2O32A187F5AF3433AFB5F3A72437A590FE03063O00E29AC9405BCA030B3O00F54108164EB9D34F140B5E03063O00DCA1297D782A2O033O00B170B803043O006EDC11C0025O0086AF40026O00424003253O00676D2613E032CEA872462012EE08E6AE7A7D3815F933B1B4716B3114E223E898206D7448B903083O00C71419547A8B5791025O0008864003113O007419D4A015E3490EFEBC1AE44222D4AD1003063O008A2769BDCE7B03103O0044616E63656F664368696A6942752O66025O00609640025O0049B14003223O000C178023FDF0C1F820049B2CFDFCF0F41604826DE0FCDDFA110E9D34CCADDBBF4D5303083O009F7F67E94D9399AF026O001040025O001DB240025O00E0B240025O0092A440025O0082B140030D3O0035F9F7A34ECC34E5EA8149C80C03063O00AB679084CA20025O004EA040025O00F4A5402O033O001D26E703043O006C704F89031E3O002DCB6721A306D6262ACC4B23A402E2752CC7662DA308FD2C00966068FF5703083O00555FA21448CD6189030C3O00D5F12BDF06F7D8E3D623DF0603073O00AD979D4ABC6D98025O008DB1402O033O0029013603083O0093446858BDBC34B5031C3O0018848AD311879EC4258382D311C898D5088D85D90E91B4840EC8D98803043O00B07AE8EB025O00B4AB40025O001C994003113O00B3653341E0897B3D6CFC817B3F64E7837E03053O008EE0155A2F025O00A6A140025O00B8B14003223O0067C42E58AA828B73EB2444A585804BDF2E55AFCB9671C62258AD9F9C4B803316F7DB03073O00E514B44736C4EB0022042O0012283O00014O0074000100013O00260C012O0006000100010004E03O00060001002EA7010200FEFF2O00030004E03O00020001001228000100013O00260C2O01000B000100040004E03O000B0001002E8F00050038000100060004E03O003800012O006A01026O0070000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002002104013O0004E03O002104012O006A01026O0070000300013O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002002104013O0004E03O002104012O006A010200023O00207701020002000D4O00045O00202O00040004000E4O00020004000200262O000200210401000F0004E03O002104012O006A010200034O001C01035O00202O0003000300104O000400056O000600043O00202O00060006001100122O000800126O0006000800024O000600066O00020006000200062O0002002104013O0004E03O002104012O006A010200013O00121F010300133O00122O000400146O000200046O00025O00044O0021040100260C2O01003C000100120004E03O003C0001002E8F001500CC000100160004E03O00CC0001001228000200013O002EE8001700A4000100180004E03O00A40001000E512O0100A4000100020004E03O00A40001001228000300013O0026BF00030046000100190004E03O00460001001228000200193O0004E03O00A40001000E912O01004A000100030004E03O004A0001002EE8001A00420001001B0004E03O00420001002EA7011C00340001001C0004E03O007E00012O006A01046O0070000500013O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004007E00013O0004E03O007E00012O006A01046O0070000500013O00122O0006001F3O00122O000700206O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007E00013O0004E03O007E00012O006A010400054O006A01055O0020D40005000500212O00300104000200020006A30004007E00013O0004E03O007E00012O006A010400063O00200E0104000400224O00055O00202O0005000500214O000600076O000700013O00122O000800233O00122O000900246O0007000900024O000800086O000900096O000A00043O00202O000A000A001100122O000C00126O000A000C00024O000A000A6O0004000A000200062O0004007E00013O0004E03O007E00012O006A010400013O001228000500253O001228000600264O0049010400064O001000046O006A01046O00A4000500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008A000100010004E03O008A0001002E8F002A00A2000100290004E03O00A200012O006A010400063O00200E0104000400224O00055O00202O00050005002B4O000600076O000700013O00122O0008002C3O00122O0009002D6O0007000900024O000800096O000900096O000A00043O00202O000A000A001100122O000C00126O000A000C00024O000A000A6O0004000A000200062O000400A200013O0004E03O00A200012O006A010400013O0012280005002E3O0012280006002F4O0049010400064O001000045O001228000300193O0004E03O004200010026BF0002003D000100190004E03O003D00012O006A01036O0070000400013O00122O000500303O00122O000600316O0004000600024O00030003000400202O0003000300094O00030002000200062O000300B600013O0004E03O00B600012O006A010300054O006A01045O0020D40004000400322O0030010300020002000682010300B8000100010004E03O00B80001002EE8003300C9000100340004E03O00C900012O006A010300034O001C01045O00202O0004000400324O000500066O000700043O00202O00070007001100122O000900356O0007000900024O000700076O00030007000200062O000300C900013O0004E03O00C900012O006A010300013O001228000400363O001228000500374O0049010300054O001000035O001228000100383O0004E03O00CC00010004E03O003D00010026BF000100482O0100380004E03O00482O01001228000200014O0074000300033O0026BF000200D0000100010004E03O00D00001001228000300013O000E510119003O0100030004E03O003O012O006A01046O0070000500013O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400FF00013O0004E03O00FF00012O006A010400054O006A01055O0020D40005000500212O00300104000200020006A3000400FF00013O0004E03O00FF0001002E8F003C00FF0001003B0004E03O00FF00012O006A010400063O00200E0104000400224O00055O00202O0005000500214O000600076O000700013O00122O0008003D3O00122O0009003E6O0007000900024O000800096O000900096O000A00043O00202O000A000A001100122O000C00126O000A000C00024O000A000A6O0004000A000200062O000400FF00013O0004E03O00FF00012O006A010400013O0012280005003F3O001228000600404O0049010400064O001000045O001228000100043O0004E03O00482O01000E912O0100052O0100030004E03O00052O01002EA7014100D0FF2O00420004E03O00D300012O006A01046O0070000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400094O00040002000200062O000400222O013O0004E03O00222O01002EE8004500222O0100460004E03O00222O012O006A010400034O001C01055O00202O0005000500474O000600076O000800043O00202O00080008001100122O000A00126O0008000A00024O000800086O00040008000200062O000400222O013O0004E03O00222O012O006A010400013O001228000500483O001228000600494O0049010400064O001000046O006A01046O0070000500013O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400442O013O0004E03O00442O012O006A010400023O00206401040004004C4O00065O00202O00060006004D4O00040006000200062O000400442O013O0004E03O00442O012O006A010400034O001C01055O00202O00050005004E4O000600076O000800043O00202O00080008001100122O000A00356O0008000A00024O000800086O00040008000200062O000400442O013O0004E03O00442O012O006A010400013O0012280005004F3O001228000600504O0049010400064O001000045O001228000300193O0004E03O00D300010004E03O00482O010004E03O00D000010026BF000100D82O0100010004E03O00D82O01001228000200013O002EE8005200862O0100510004E03O00862O010026BF000200862O0100190004E03O00862O012O006A01036O0070000400013O00122O000500533O00122O000600546O0004000600024O00030003000400202O0003000300094O00030002000200062O000300842O013O0004E03O00842O012O006A010300023O0020640103000300554O00055O00202O0005000500564O00030005000200062O000300842O013O0004E03O00842O012O006A01036O00A4000400013O00122O000500573O00122O000600586O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300842O0100010004E03O00842O012O006A010300063O00208C0003000300224O00045O00202O0004000400594O000500076O000600013O00122O0007005A3O00122O0008005B6O0006000800024O000700086O000800086O000900043O00202O00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O0003007F2O0100010004E03O007F2O01002EA7015C00070001005D0004E03O00842O012O006A010300013O0012280004005E3O0012280005005F4O0049010300054O001000035O001228000100193O0004E03O00D82O010026BF0002004B2O0100010004E03O004B2O012O006A01036O0070000400013O00122O000500603O00122O000600616O0004000600024O00030003000400202O0003000300624O00030002000200062O000300992O013O0004E03O00992O012O006A010300043O0020220003000300634O00055O00202O0005000500644O00030005000200262O0003009B2O0100190004E03O009B2O01002EE8006500AE2O0100120004E03O00AE2O01002EA701660013000100660004E03O00AE2O012O006A010300034O001C01045O00202O0004000400674O000500066O000700043O00202O00070007006800122O000900696O0007000900024O000700076O00030007000200062O000300AE2O013O0004E03O00AE2O012O006A010300013O0012280004006A3O0012280005006B4O0049010300054O001000036O006A01036O0070000400013O00122O0005006C3O00122O0006006D6O0004000600024O00030003000400202O0003000300094O00030002000200062O000300D62O013O0004E03O00D62O012O006A010300054O006A01045O0020D40004000400102O00300103000200020006A3000300D62O013O0004E03O00D62O012O006A010300063O00200E0103000300224O00045O00202O0004000400104O000500076O000600013O00122O0007006E3O00122O0008006F6O0006000800024O0007000A6O000800086O000900043O00202O00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O000300D62O013O0004E03O00D62O012O006A010300013O001228000400703O001228000500714O0049010300054O001000035O001228000200193O0004E03O004B2O0100260C2O0100DC2O0100190004E03O00DC2O01002EE800720078020100730004E03O00780201001228000200013O0026BF00020019020100190004E03O001902012O006A01036O0070000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O0003000300094O00030002000200062O0003001702013O0004E03O001702012O006A010300054O006A01045O0020D40004000400212O00300103000200020006A30003001702013O0004E03O001702012O006A010300023O00205800030003000D4O00055O00202O00050005000E4O00030005000200262O000300170201000F0004E03O001702012O006A010300023O0020770103000300764O00055O00202O00050005000E4O00030005000200262O00030017020100190004E03O001702012O006A010300063O00208C0003000300224O00045O00202O0004000400214O000500076O000600013O00122O000700773O00122O000800786O0006000800024O000700086O000800086O000900043O00202O00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O00030012020100010004E03O00120201002EE8007A0017020100790004E03O001702012O006A010300013O0012280004007B3O0012280005007C4O0049010300054O001000035O0012280001007D3O0004E03O007802010026BF000200DD2O0100010004E03O00DD2O012O006A01036O0070000400013O00122O0005007E3O00122O0006007F6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003004D02013O0004E03O004D02012O006A010300023O0020640103000300554O00055O00202O0005000500564O00030005000200062O0003004D02013O0004E03O004D02012O006A010300023O0020A101030003008000122O000500693O00122O0006007D6O00030006000200062O0003004D02013O0004E03O004D02012O006A010300063O00208C0003000300224O00045O00202O0004000400594O000500076O000600013O00122O000700813O00122O000800826O0006000800024O000700086O000800086O000900043O00202O00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O00030048020100010004E03O00480201002E8F0084004D020100830004E03O004D02012O006A010300013O001228000400853O001228000500864O0049010300054O001000036O006A01036O0070000400013O00122O000500873O00122O000600886O0004000600024O00030003000400202O0003000300094O00030002000200062O0003007602013O0004E03O007602012O006A010300023O0020A101030003008000122O000500693O00122O0006007D6O00030006000200062O0003007602013O0004E03O007602012O006A010300063O00200E0103000300224O00045O00202O0004000400594O000500076O000600013O00122O000700893O00122O0008008A6O0006000800024O000700086O000800086O000900043O00202O00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O0003007602013O0004E03O007602012O006A010300013O0012280004008B3O0012280005008C4O0049010300054O001000035O001228000200193O0004E03O00DD2O01002E8F008D000B0301008E0004E03O000B0301000E51017D000B030100010004E03O000B0301001228000200013O002EE8009000DB0201008F0004E03O00DB0201000E512O0100DB020100020004E03O00DB02012O006A01036O0070000400013O00122O000500913O00122O000600926O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009C02013O0004E03O009C02012O006A01036O0070000400013O00122O000500933O00122O000600946O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003009C02013O0004E03O009C02012O006A010300023O00208F0103000300554O00055O00202O0005000500954O00030005000200062O0003009E020100010004E03O009E0201002EE8009600B8020100970004E03O00B80201002EE8009800B8020100990004E03O00B802012O006A010300063O0020EE0003000300224O00045O00202O00040004002B4O000500076O000600013O00122O0007009A3O00122O0008009B6O0006000800024O000700096O0008000B4O006A010900043O0020EF00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O000300B802013O0004E03O00B802012O006A010300013O0012280004009C3O0012280005009D4O0049010300054O001000036O006A01036O0070000400013O00122O0005009E3O00122O0006009F6O0004000600024O00030003000400202O0003000300624O00030002000200062O000300DA02013O0004E03O00DA02012O006A010300043O0020770103000300634O00055O00202O0005000500644O00030005000200262O000300DA0201007D0004E03O00DA02012O006A010300034O001C01045O00202O0004000400674O000500066O000700043O00202O00070007006800122O000900696O0007000900024O000700076O00030007000200062O000300DA02013O0004E03O00DA02012O006A010300013O001228000400A03O001228000500A14O0049010300054O001000035O001228000200193O00260C010200DF020100190004E03O00DF0201002EE800A3007D020100A20004E03O007D02012O006A01036O0070000400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400202O0003000300094O00030002000200062O0003000803013O0004E03O000803012O006A010300023O0020640103000300554O00055O00202O0005000500A64O00030005000200062O0003000803013O0004E03O000803012O006A010300063O00200E0103000300224O00045O00202O0004000400A74O000500076O000600013O00122O000700A83O00122O000800A96O0006000800024O000700096O000800086O000900043O00202O00090009001100122O000B00356O0009000B00024O000900096O00030009000200062O0003000803013O0004E03O000803012O006A010300013O001228000400AA3O001228000500AB4O0049010300054O001000035O0012280001000F3O0004E03O000B03010004E03O007D02010026BF000100820301000F0004E03O00820301001228000200013O0026BF00020051030100010004E03O005103012O006A010300023O0020640103000300AC4O00055O00202O0005000500A74O00030005000200062O0003002203013O0004E03O002203012O006A0103000C4O006A0104000D3O0020D40004000400AD2O00300103000200020006A30003002203013O0004E03O002203012O006A010300013O001228000400AE3O001228000500AF4O0049010300054O001000036O006A01036O0070000400013O00122O000500B03O00122O000600B16O0004000600024O00030003000400202O0003000300094O00030002000200062O0003005003013O0004E03O005003012O006A01036O0070000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003005003013O0004E03O005003012O006A010300063O00208C0003000300224O00045O00202O00040004002B4O000500076O000600013O00122O000700B43O00122O000800B56O0006000800024O000700096O000800086O000900043O00202O00090009001100122O000B00126O0009000B00024O000900096O00030009000200062O0003004B030100010004E03O004B0301002E8F00B60050030100B70004E03O005003012O006A010300013O001228000400B83O001228000500B94O0049010300054O001000035O001228000200193O0026BF0002000E030100190004E03O000E0301002EA701BA002C000100BA0004E03O007F03012O006A01036O0070000400013O00122O000500BB3O00122O000600BC6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003007F03013O0004E03O007F03012O006A010300054O006A01045O0020D40004000400322O00300103000200020006A30003007F03013O0004E03O007F03012O006A010300023O0020640103000300554O00055O00202O0005000500BD4O00030005000200062O0003007F03013O0004E03O007F0301002EE800BE007F030100BF0004E03O007F03012O006A010300034O001C01045O00202O0004000400324O000500066O000700043O00202O00070007001100122O000900356O0007000900024O000700076O00030007000200062O0003007F03013O0004E03O007F03012O006A010300013O001228000400C03O001228000500C14O0049010300054O001000035O001228000100C23O0004E03O008203010004E03O000E030100260C2O010086030100C20004E03O00860301002E8F00C40007000100C30004E03O00070001001228000200013O002E8F00C500F0030100C60004E03O00F003010026BF000200F0030100010004E03O00F00301001228000300013O0026BF000300EB030100010004E03O00EB03012O006A01046O0070000500013O00122O000600C73O00122O000700C86O0005000700024O00040004000500202O0004000400094O00040002000200062O0004009F03013O0004E03O009F03012O006A010400023O00208F0104000400554O00065O00202O0006000600564O00040006000200062O000400A1030100010004E03O00A10301002EE800CA00B9030100C90004E03O00B903012O006A010400063O00200E0104000400224O00055O00202O0005000500594O000600076O000700013O00122O000800CB3O00122O000900CC6O0007000900024O000800086O000900096O000A00043O00202O000A000A001100122O000C00126O000A000C00024O000A000A6O0004000A000200062O000400B903013O0004E03O00B903012O006A010400013O001228000500CD3O001228000600CE4O0049010400064O001000046O006A01046O0070000500013O00122O000600CF3O00122O000700D06O0005000700024O00040004000500202O0004000400094O00040002000200062O000400EA03013O0004E03O00EA03012O006A010400054O006A01055O0020D40005000500212O00300104000200020006A3000400EA03013O0004E03O00EA03012O006A010400023O0020A101040004008000122O000600693O00122O0007007D6O00040007000200062O000400EA03013O0004E03O00EA0301002EA701D1001A000100D10004E03O00EA03012O006A010400063O00200E0104000400224O00055O00202O0005000500214O000600076O000700013O00122O000800D23O00122O000900D36O0007000900024O000800086O000900096O000A00043O00202O000A000A001100122O000C00126O000A000C00024O000A000A6O0004000A000200062O000400EA03013O0004E03O00EA03012O006A010400013O001228000500D43O001228000600D54O0049010400064O001000045O001228000300193O0026BF0003008C030100190004E03O008C0301001228000200193O0004E03O00F003010004E03O008C030100260C010200F4030100190004E03O00F40301002EE800D60087030100D70004E03O008703012O006A01036O0070000400013O00122O000500D83O00122O000600D96O0004000600024O00030003000400202O0003000300094O00030002000200062O0003000804013O0004E03O000804012O006A010300054O006A01045O0020D40004000400322O00300103000200020006A30003000804013O0004E03O000804012O006A0103000E4O00B10003000100020006820103000A040100010004E03O000A0401002EA701DA0013000100DB0004E03O001B04012O006A010300034O001C01045O00202O0004000400324O000500066O000700043O00202O00070007001100122O000900356O0007000900024O000700076O00030007000200062O0003001B04013O0004E03O001B04012O006A010300013O001228000400DC3O001228000500DD4O0049010300054O001000035O001228000100123O0004E03O000700010004E03O008703010004E03O000700010004E03O002104010004E03O000200012O003C012O00017O00FF3O00028O00025O00849740025O00F89140026O00F03F030D3O0008A22A73A11809BE3751A61C3103063O007F5ACB591ACF03073O004973526561647903073O0048617354696572026O003E40027O0040025O00C88D40025O00E6AB40025O0046A640030C3O00436173745461726765744966030D3O00526973696E6753756E4B69636B2O033O00D03CA103063O009DBD55CFAB69030E3O004973496E4D656C2O6552616E6765026O001440031E3O00D4A8CBBC0DC19ECBA00DF9AAD1B60886B2DDA706C8A8CCAC3C95B598E45103053O0063A6C1B8D5025O00149840025O0012A840030C3O00F4BB81B80785C3A3ABB20F8103063O00EAB6D7E0DB6C030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O000840030B3O0042752O6652656D61696E73025O0076B040025O00A49A402O033O00CD88B503043O0055A0E1DB031B3O005E0982CA3DD35E483A88C035D70B4F0091CC38D55F453AD0DD768A03073O002B3C65E3A956BC025O00407340025O00B07540025O00FEA240025O00649440030C3O0056C9D4B353C2BC0464C7DCAF03083O005710A8B1DF3AACD9030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66030C3O004661656C696E6553746F6D7003093O004973496E52616E6765031C3O0032CC5CD1323AC866CE2F3BC0499D2831DF5CD33220D4668E2F749C0D03053O005B54AD39BD03133O0023AD1EF5ABD31FBF18F4A5E119B708F0AFC41403063O00B670D96C9CC0030B3O009E005DE18FAF1A4EE698BE03053O00EBCA68288F030B3O004973417661696C61626C6503063O0042752O66557003133O0043612O6C746F446F6D696E616E636542752O66025O008AA040025O0026A24003133O00537472696B656F6674686557696E646C6F72642O034O008A2O03043O00D96DEB7B03253O00349D6C5F7BD5F2B221B66A5E75EFDAB4298D725962D48DAE229B7B5879C4D482749D3E072603083O00DD47E91E3610B0AD025O00B4AC40025O0046AA40025O00908640025O00708E40025O0068A740025O009AB240025O00A49640030C3O0015CAF3E040F636F8E2E344E803063O009853AB968C29031B3O0084E4863FDD150DBDF6973CD90B4891E09136DA121C9BDAD027944903073O0068E285E353B47B025O00ACA940026O00AC4003093O0037022455113B225C0E03043O0030636B4303093O00546967657250616C6D2O033O00D3AF7303063O001BBEC61DB04D025O00AEAF40025O00F8AB4003183O00FB42FA31BB71FF4AF139E95DEA59F83AA05AF674AE20E91A03063O002E8F2B9D54C9025O0042AB40025O008FB040025O00B08740025O002FB140025O000C9040025O00988A40030D3O00657145CB5114FB42767DCB5C1803073O00A8371836A23F7303113O005072652O73757265506F696E7442752O662O033O001AF32E03063O00AE779A40E0B2031D3O003877D6720BA025F73F70FA700CA411A4397BD77E0BAE0EFD152DD13B5D03083O00844A1EA51B65C77A030D3O001DEEECAEA9B2873AE9D4AEA4BE03073O00D44F879F2OC7D5025O00F08640025O003AA440025O00508140025O0034AD402O033O0074A9BB03073O007819C0D5273CB7031E3O000A492C411647005B0D4E0043114334080B452D4D16492B5127132B08491003043O002878205F025O00588340025O000AB240025O004AA740025O00E07240025O007C9640025O00707A4003093O00497343617374696E67030B3O0046697374736F664675727903073O0053746F70466F46026O003640025O00D0A34003233O00F7A3CB4D961FA45BCEACCD4B9C1FA85CFFA9DD55C533AE4FF4A4D14D9C1FF849B1F88A03083O003D91CAB839E540CB025O00C8A040025O00909F4003133O006F469B4E2O578641485A8C70555C8D4B53408D03043O00273C32E9030B3O002E3BB622862DA0A51320B703083O00C37A53C34CE248D22O033O00E9D52303053O004184B45B9E026O009640025O00C4904003253O001668C3270E79EE210343C5260043C6270B78DD211778913D006ED4200C68C8115668917C5103043O004E651CB1025O00B88A40025O00BEA840025O009C9240025O0024934003133O0007E84CB63FF951B920F45B883DF25AB33BEE5A03043O00DF549C3E030B3O00E2F4F7D3B33EC4FAEBCEA303063O005BB69C82BDD7025O00B8A840025O004498402O033O007372B403043O00351E13CC03253O00EAF4628DACFCDF7F8298EDE875BBB0F0EE7488A8EBE43097A2EBE57E8DB3E0DF2390E7A8B803053O00C7998010E4025O00C49C40025O004AAC40030B3O00F723F60DB4DE2CC30CB5C803053O00C7B14A857903133O00496E766F6B65727344656C6967687442752O662O033O00B5C8A403073O004AD8A9DC9E57A6026O002040031C3O00EE2A003849D72C15135CFD310A6C49ED31162253FC3A2C7F4EA8714303053O003A8843734C025O0060A540025O0046A040025O00E09840026O008B40025O00089940025O0026A740030C3O00ED857417C4866000E480761F03043O0074AFE915025O00C2A1402O033O00F3F9A603073O005F9E98DE26BB51031C3O00FAB134B1A8C7EDA90AB9AACBF3FD26B7B1CDF6B421AB9C9BECFD61E003063O00A898DD55D2C303093O009FD7F282B9EEF48BA603043O00E7CBBE9503173O00F938E2F2B4FC15CA2EECF7A8FD1EE032EDF0AFE11EDF2403073O007BAD5D8391DC95025O0083B040025O003C954003193O0002CDEA2466C606C5E12C34EA13D6E82F7DED0FFBBE3534AD4203063O009976A48D4114025O00E4AA40025O0064A340026O001040025O000EAD40025O004EAE40025O00609F40025O00B5B04003133O00B14F3C6BBF188840116BB2168949056CBD128E03063O0071E6275519D3025O00607640025O00E4B04003133O00576869726C696E67447261676F6E50756E6368025O00D08F40025O00CC904003243O00C9B30FFA2BC2A54CE1BF14E920C4A574CEAE08EB2F8BB84ECCBE08E133D29418CAFB55B003083O002BBEDB668847ABCB030F3O00106B23512B703773237A356E2B703403043O0039421E5003083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66025O00409740025O00406940030F3O0052757368696E674A61646557696E6403203O003BCDB31D8D37F3BB23D9A410BB2EFD8A2D98B310963CFA8D3DC19F469079A0D403083O00E449B8C075E45994025O00F8B240025O0054A440030C3O0033880AA9AE59CD5D3A8D08A103083O002971E46BCAC536B803123O0049853958759A3A536284365B4E9F3D5D7E9E03043O003C1AED58025O00D09440025O002888402O033O00D5237A03053O00CEB84A1486031C3O003AE8EFB2F8452DD807EFE7B2F80A2BC92AE1E0B8E753079F2CA4BDE503083O00AC58848ED1932A5803133O00B49EDE043DF0B1819EC40801FCB08386C31F3203073O00DEE7EAAC6D56952O033O00E0EED803043O00788D8FA0025O00FCA840025O0076A74003253O0053B8A45B4BA9895D4693A25A4593A15B4EA8BA5D52A8F64145BEB35C49B8AF6D13B8F6011603043O003220CCD603113O0016A4E95F2BBDEE5606A6E15F209FE9522E03043O003145D48003113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O66025O00D4A340025O000BB24003223O00041CD9FCEF1E02D7CDE2050DDEF7DE1C05D3F9A10409C2F7EF1E18C9CDB2034C82A403053O0081776CB092030C3O001EC306CE2E010928E40ECE2E03073O007C5CAF67AD456E025O00A06740025O009AA9402O033O00CC310D03043O0057A15863031C3O0010F5EECFBCDF3606C6E4C5B4DB6301FCFDC9B9D9370BC6BCD8F7827B03073O004372998FACD7B003113O008DB2E700B0ABE0099DB0EF00BB89E70DB503043O006EDEC28E025O00F89B40025O00788B40025O000CAE40025O0040A94003223O0004C912A75CA819DE24AA40A019DC24A25BA21C9908AC40A419D00FB06DF2039948F903063O00C177B97BC932025O0066AB40025O003EA240030C3O005504F82504760A6323F0250403073O007F176899466F192O033O00040EA803083O00D36967C6CF4B4CD7031C3O00CCABB1EC7503AFA2F1ACB9EC754CA9B3DCA2BEE66A1585E5DAE7E3BD03083O00D6AEC7D08F1E6CDA0057042O0012283O00014O0074000100013O00260C012O0006000100010004E03O00060001002EE800020002000100030004E03O00020001001228000100013O0026BF000100E7000100040004E03O00E70001001228000200014O0074000300033O000E512O01000B000100020004E03O000B0001001228000300013O0026BF00030078000100010004E03O007800012O006A01046O0070000500013O00122O000600053O00122O000700066O0005000700024O00040004000500202O0004000400074O00040002000200062O0004002100013O0004E03O002100012O006A010400023O0020B800040004000800122O000600093O00122O0007000A6O00040007000200062O00040023000100010004E03O00230001002E8F000C003D0001000B0004E03O003D0001002EA7010D001A0001000D0004E03O003D00012O006A010400033O00200E01040004000E4O00055O00202O00050005000F4O000600046O000700013O00122O000800103O00122O000900116O0007000900024O000800056O000900096O000A00063O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O0004003D00013O0004E03O003D00012O006A010400013O001228000500143O001228000600154O0049010400064O001000045O002EE800160077000100170004E03O007700012O006A01046O0070000500013O00122O000600183O00122O000700196O0005000700024O00040004000500202O0004000400074O00040002000200062O0004007700013O0004E03O007700012O006A010400074O006A01055O0020D400050005001A2O00300104000200020006A30004007700013O0004E03O007700012O006A010400023O00205800040004001B4O00065O00202O00060006001C4O00040006000200262O000400770001001D0004E03O007700012O006A010400023O00207701040004001E4O00065O00202O00060006001C4O00040006000200262O00040077000100040004E03O00770001002EE8002000770001001F0004E03O007700012O006A010400033O00200E01040004000E4O00055O00202O00050005001A4O000600046O000700013O00122O000800213O00122O000900226O0007000900024O000800056O000900096O000A00063O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O0004007700013O0004E03O007700012O006A010400013O001228000500233O001228000600244O0049010400064O001000045O001228000300043O00260C0103007C0001000A0004E03O007C0001002EE80026007E000100250004E03O007E00010012280001000A3O0004E03O00E70001002EE80028000E000100270004E03O000E00010026BF0003000E000100040004E03O000E0001001228000400013O0026BF000400DD000100010004E03O00DD00012O006A01056O0070000600013O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O00050005002B4O00050002000200062O000500A700013O0004E03O00A700012O006A010500063O00207701050005002C4O00075O00202O00070007002D4O00050007000200262O000500A70001000A0004E03O00A700012O006A010500084O001C01065O00202O00060006002E4O000700086O000900063O00202O00090009002F00122O000B00096O0009000B00024O000900096O00050009000200062O000500A700013O0004E03O00A700012O006A010500013O001228000600303O001228000700314O0049010500074O001000056O006A01056O0070000600013O00122O000700323O00122O000800336O0006000800024O00050005000600202O0005000500074O00050002000200062O000500C200013O0004E03O00C200012O006A01056O0070000600013O00122O000700343O00122O000800356O0006000800024O00050005000600202O0005000500364O00050002000200062O000500C200013O0004E03O00C200012O006A010500023O00208F0105000500374O00075O00202O0007000700384O00050007000200062O000500C4000100010004E03O00C40001002EE8003A00DC000100390004E03O00DC00012O006A010500033O0020EE00050005000E4O00065O00202O00060006003B4O000700046O000800013O00122O0009003C3O00122O000A003D6O0008000A00024O000900096O000A000A4O006A010B00063O0020EF000B000B001200122O000D00136O000B000D00024O000B000B6O0005000B000200062O000500DC00013O0004E03O00DC00012O006A010500013O0012280006003E3O0012280007003F4O0049010500074O001000055O001228000400043O00260C010400E1000100040004E03O00E10001002EA7014000A4FF2O00410004E03O008300010012280003000A3O0004E03O000E00010004E03O008300010004E03O000E00010004E03O00E700010004E03O000B00010026BF000100BC2O0100010004E03O00BC2O01001228000200013O0026BF000200EE0001000A0004E03O00EE0001001228000100043O0004E03O00BC2O0100260C010200F2000100010004E03O00F20001002E8F0043004D2O0100420004E03O004D2O01001228000300013O00260C010300F7000100040004E03O00F70001002EA701440004000100450004E03O00F90001001228000200043O0004E03O004D2O01002EA7014600FAFF2O00460004E03O00F300010026BF000300F3000100010004E03O00F300012O006A01046O0070000500013O00122O000600473O00122O000700486O0005000700024O00040004000500202O00040004002B4O00040002000200062O0004001F2O013O0004E03O001F2O012O006A010400063O00207701040004002C4O00065O00202O00060006002D4O00040006000200262O0004001F2O0100040004E03O001F2O012O006A010400084O001C01055O00202O00050005002E4O000600076O000800063O00202O00080008002F00122O000A00096O0008000A00024O000800086O00040008000200062O0004001F2O013O0004E03O001F2O012O006A010400013O001228000500493O0012280006004A4O0049010400064O001000045O002EE8004B004B2O01004C0004E03O004B2O012O006A01046O0070000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O0004000400074O00040002000200062O0004004B2O013O0004E03O004B2O012O006A010400074O006A01055O0020D400050005004F2O00300104000200020006A30004004B2O013O0004E03O004B2O012O006A010400033O00208C00040004000E4O00055O00202O00050005004F4O000600046O000700013O00122O000800503O00122O000900516O0007000900024O0008000B6O000900096O000A00063O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O000400462O0100010004E03O00462O01002EE80052004B2O0100530004E03O004B2O012O006A010400013O001228000500543O001228000600554O0049010400064O001000045O001228000300043O0004E03O00F30001002E8F005600EA000100570004E03O00EA00010026BF000200EA000100040004E03O00EA0001001228000300013O002E8F005800B62O0100590004E03O00B62O010026BF000300B62O0100010004E03O00B62O01002E8F005B00812O01005A0004E03O00812O012O006A01046O0070000500013O00122O0006005C3O00122O0007005D6O0005000700024O00040004000500202O0004000400074O00040002000200062O000400812O013O0004E03O00812O012O006A010400023O0020640104000400374O00065O00202O00060006005E4O00040006000200062O000400812O013O0004E03O00812O012O006A010400033O00200E01040004000E4O00055O00202O00050005000F4O000600046O000700013O00122O0008005F3O00122O000900606O0007000900024O000800056O000900096O000A00063O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O000400812O013O0004E03O00812O012O006A010400013O001228000500613O001228000600624O0049010400064O001000046O006A01046O0070000500013O00122O000600633O00122O000700646O0005000700024O00040004000500202O0004000400074O00040002000200062O000400992O013O0004E03O00992O012O006A010400023O0020640104000400374O00065O00202O00060006005E4O00040006000200062O000400992O013O0004E03O00992O012O006A010400023O0020B800040004000800122O000600093O00122O0007000A6O00040007000200062O0004009B2O0100010004E03O009B2O01002E8F006600B52O0100650004E03O00B52O01002E8F006700B52O0100680004E03O00B52O012O006A010400033O00200E01040004000E4O00055O00202O00050005000F4O000600046O000700013O00122O000800693O00122O0009006A6O0007000900024O000800056O000900096O000A00063O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O000400B52O013O0004E03O00B52O012O006A010400013O0012280005006B3O0012280006006C4O0049010400064O001000045O001228000300043O000E51010400522O0100030004E03O00522O010012280002000A3O0004E03O00EA00010004E03O00522O010004E03O00EA00010026BF000100830201000A0004E03O00830201001228000200013O00260C010200C32O01000A0004E03O00C32O01002EA7016D00040001006E0004E03O00C52O010012280001001D3O0004E03O00830201000E91010400C92O0100020004E03O00C92O01002EE8006F0018020100700004E03O00180201001228000300013O000E91010400CE2O0100030004E03O00CE2O01002E8F007100D02O0100720004E03O00D02O010012280002000A3O0004E03O001802010026BF000300CA2O0100010004E03O00CA2O012O006A010400023O0020640104000400734O00065O00202O0006000600744O00040006000200062O000400E62O013O0004E03O00E62O012O006A0104000C4O006A0105000D3O0020D40005000500752O0030010400020002000682010400E12O0100010004E03O00E12O01002E8F007700E62O0100760004E03O00E62O012O006A010400013O001228000500783O001228000600794O0049010400064O001000045O002E8F007B00160201007A0004E03O001602012O006A01046O0070000500013O00122O0006007C3O00122O0007007D6O0005000700024O00040004000500202O0004000400074O00040002000200062O0004001602013O0004E03O001602012O006A01046O0070000500013O00122O0006007E3O00122O0007007F6O0005000700024O00040004000500202O0004000400364O00040002000200062O0004001602013O0004E03O001602012O006A010400033O00208C00040004000E4O00055O00202O00050005003B4O000600046O000700013O00122O000800803O00122O000900816O0007000900024O000800096O000900096O000A00063O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O00040011020100010004E03O00110201002E8F00820016020100830004E03O001602012O006A010400013O001228000500843O001228000600854O0049010400064O001000045O001228000300043O0004E03O00CA2O010026BF000200BF2O0100010004E03O00BF2O01001228000300013O00260C0103001F020100010004E03O001F0201002E8F0087007B020100860004E03O007B0201002EE80088004F020100890004E03O004F02012O006A01046O0070000500013O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500202O0004000400074O00040002000200062O0004004F02013O0004E03O004F02012O006A01046O0070000500013O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O0004000400364O00040002000200062O0004004F02013O0004E03O004F0201002EE8008F004F0201008E0004E03O004F02012O006A010400033O0020EE00040004000E4O00055O00202O00050005003B4O000600046O000700013O00122O000800903O00122O000900916O0007000900024O000800096O0009000E4O006A010A00063O0020EF000A000A001200122O000C00136O000A000C00024O000A000A6O0004000A000200062O0004004F02013O0004E03O004F02012O006A010400013O001228000500923O001228000600934O0049010400064O001000045O002EE80094007A020100950004E03O007A02012O006A01046O0070000500013O00122O000600963O00122O000700976O0005000700024O00040004000500202O0004000400074O00040002000200062O0004007A02013O0004E03O007A02012O006A010400023O0020640104000400374O00065O00202O0006000600984O00040006000200062O0004007A02013O0004E03O007A02012O006A010400033O00200E01040004000E4O00055O00202O0005000500744O0006000F6O000700013O00122O000800993O00122O0009009A6O0007000900024O000800096O000900096O000A00063O00202O000A000A001200122O000C009B6O000A000C00024O000A000A6O0004000A000200062O0004007A02013O0004E03O007A02012O006A010400013O0012280005009C3O0012280006009D4O0049010400064O001000045O001228000300043O00260C0103007F020100040004E03O007F0201002EE8009E001B0201009F0004E03O001B0201001228000200043O0004E03O00BF2O010004E03O001B02010004E03O00BF2O01002E8F00A100E2020100A00004E03O00E202010026BF000100E2020100130004E03O00E20201002E8F00A200B3020100A30004E03O00B302012O006A01026O0070000300013O00122O000400A43O00122O000500A56O0003000500024O00020002000300202O0002000200074O00020002000200062O000200B302013O0004E03O00B302012O006A010200074O006A01035O0020D400030003001A2O00300102000200020006A3000200B302013O0004E03O00B30201002EA701A6001A000100A60004E03O00B302012O006A010200033O00200E01020002000E4O00035O00202O00030003001A4O000400046O000500013O00122O000600A73O00122O000700A86O0005000700024O000600096O000700076O000800063O00202O00080008001200122O000A00136O0008000A00024O000800086O00020008000200062O000200B302013O0004E03O00B302012O006A010200013O001228000300A93O001228000400AA4O0049010200044O001000026O006A01026O0070000300013O00122O000400AB3O00122O000500AC6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200CE02013O0004E03O00CE02012O006A01026O0070000300013O00122O000400AD3O00122O000500AE6O0003000500024O00020002000300202O0002000200364O00020002000200062O000200CE02013O0004E03O00CE02012O006A010200023O00202200020002001B4O00045O00202O00040004001C4O00020004000200262O000200D00201001D0004E03O00D00201002E8F00AF0056040100B00004E03O005604012O006A010200084O001C01035O00202O00030003004F4O000400056O000600063O00202O00060006001200122O000800136O0006000800024O000600066O00020006000200062O0002005604013O0004E03O005604012O006A010200013O00121F010300B13O00122O000400B26O000200046O00025O00044O00560401002E8F00B4009B030100B30004E03O009B03010026BF0001009B030100B50004E03O009B0301001228000200013O0026BF000200EB0201000A0004E03O00EB0201001228000100133O0004E03O009B030100260C010200EF020100040004E03O00EF0201002EE800B7003D030100B60004E03O003D0301001228000300013O00260C010300F4020100010004E03O00F40201002EE800B90038030100B80004E03O003803012O006A01046O00A4000500013O00122O000600BA3O00122O000700BB6O0005000700024O00040004000500202O0004000400074O00040002000200062O00042O00030100010004E04O000301002EE800BD0013030100BC0004E03O001303012O006A010400084O003400055O00202O0005000500BE4O000600076O000800063O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O0004000E030100010004E03O000E0301002E8F00C00013030100BF0004E03O001303012O006A010400013O001228000500C13O001228000600C24O0049010400064O001000046O006A01046O0070000500013O00122O000600C33O00122O000700C46O0005000700024O00040004000500202O0004000400074O00040002000200062O0004002403013O0004E03O002403012O006A010400023O00208F0104000400C54O00065O00202O0006000600C64O00040006000200062O00040026030100010004E03O00260301002EA701C70013000100C80004E03O003703012O006A010400084O001C01055O00202O0005000500C94O000600076O000800063O00202O00080008001200122O000A009B6O0008000A00024O000800086O00040008000200062O0004003703013O0004E03O003703012O006A010400013O001228000500CA3O001228000600CB4O0049010400064O001000045O001228000300043O0026BF000300F0020100040004E03O00F002010012280002000A3O0004E03O003D03010004E03O00F00201002E8F00CD00E7020100CC0004E03O00E702010026BF000200E7020100010004E03O00E702012O006A01036O0070000400013O00122O000500CE3O00122O000600CF6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003007503013O0004E03O007503012O006A01036O0070000400013O00122O000500D03O00122O000600D16O0004000600024O00030003000400202O0003000300364O00030002000200062O0003007503013O0004E03O007503012O006A010300074O006A01045O0020D400040004001A2O00300103000200020006A30003007503013O0004E03O00750301002EE800D30075030100D20004E03O007503012O006A010300033O00200E01030003000E4O00045O00202O00040004001A4O000500046O000600013O00122O000700D43O00122O000800D56O0006000800024O000700056O000800086O000900063O00202O00090009001200122O000B00136O0009000B00024O000900096O00030009000200062O0003007503013O0004E03O007503012O006A010300013O001228000400D63O001228000500D74O0049010300054O001000036O006A01036O0070000400013O00122O000500D83O00122O000600D96O0004000600024O00030003000400202O0003000300074O00030002000200062O0003009903013O0004E03O009903012O006A010300033O00208C00030003000E4O00045O00202O00040004003B4O000500046O000600013O00122O000700DA3O00122O000800DB6O0006000800024O000700096O000800086O000900063O00202O00090009001200122O000B00136O0009000B00024O000900096O00030009000200062O00030094030100010004E03O00940301002EA701DC0007000100DD0004E03O009903012O006A010300013O001228000400DE3O001228000500DF4O0049010300054O001000035O001228000200043O0004E03O00E702010026BF000100070001001D0004E03O000700012O006A01026O0070000300013O00122O000400E03O00122O000500E16O0003000500024O00020002000300202O0002000200074O00020002000200062O000200CB03013O0004E03O00CB03012O006A010200074O006A01035O0020D40003000300E22O00300102000200020006A3000200CB03013O0004E03O00CB03012O006A010200023O0020640102000200374O00045O00202O0004000400E34O00020004000200062O000200CB03013O0004E03O00CB03012O006A010200104O00B10002000100020006A3000200CB03013O0004E03O00CB0301002EE800E400CB030100E50004E03O00CB03012O006A010200084O001C01035O00202O0003000300E24O000400056O000600063O00202O00060006001200122O0008009B6O0006000800024O000600066O00020006000200062O000200CB03013O0004E03O00CB03012O006A010200013O001228000300E63O001228000400E74O0049010200044O001000026O006A01026O0070000300013O00122O000400E83O00122O000500E96O0003000500024O00020002000300202O0002000200074O00020002000200062O000200E203013O0004E03O00E203012O006A010200074O006A01035O0020D400030003001A2O00300102000200020006A3000200E203013O0004E03O00E203012O006A010200023O0020B800020002000800122O000400093O00122O0005000A6O00020005000200062O000200E4030100010004E03O00E40301002EA701EA001A000100EB0004E03O00FC03012O006A010200033O00200E01020002000E4O00035O00202O00030003001A4O000400046O000500013O00122O000600EC3O00122O000700ED6O0005000700024O000600056O000700076O000800063O00202O00080008001200122O000A00136O0008000A00024O000800086O00020008000200062O000200FC03013O0004E03O00FC03012O006A010200013O001228000300EE3O001228000400EF4O0049010200044O001000026O006A01026O0070000300013O00122O000400F03O00122O000500F16O0003000500024O00020002000300202O0002000200074O00020002000200062O0002000C04013O0004E03O000C04012O006A010200074O006A01035O0020D40003000300E22O00300102000200020006820102000E040100010004E03O000E0401002EE800F20021040100F30004E03O002104012O006A010200084O003400035O00202O0003000300E24O000400056O000600063O00202O00060006001200122O0008009B6O0006000800024O000600066O00020006000200062O0002001C040100010004E03O001C0401002E8F00F40021040100F50004E03O002104012O006A010200013O001228000300F63O001228000400F74O0049010200044O001000025O002EE800F90052040100F80004E03O005204012O006A01026O0070000300013O00122O000400FA3O00122O000500FB6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002005204013O0004E03O005204012O006A010200074O006A01035O0020D400030003001A2O00300102000200020006A30002005204013O0004E03O005204012O006A010200023O00205800020002001B4O00045O00202O00040004001C4O00020004000200262O000200520401000A0004E03O005204012O006A010200033O00200E01020002000E4O00035O00202O00030003001A4O000400046O000500013O00122O000600FC3O00122O000700FD6O0005000700024O000600056O000700076O000800063O00202O00080008001200122O000A00136O0008000A00024O000800086O00020008000200062O0002005204013O0004E03O005204012O006A010200013O001228000300FE3O001228000400FF4O0049010200044O001000025O001228000100B53O0004E03O000700010004E03O005604010004E03O000200012O003C012O00017O00DE3O00028O00026O00F03F025O00309A40025O00AEAC40026O001040025O003EAA40025O00B09340030C3O00EF8F24AEB48F1C96E68A26A603083O00E2ADE345CDDFE06903073O0049735265616479030C3O00426C61636B6F75744B69636B03073O0048617354696572026O003E40027O0040025O0006AB40025O002EAB40030C3O004361737454617267657449662O033O0055372C03063O007B385E423BAF030E3O004973496E4D656C2O6552616E6765026O001440031C3O00F84F72E211F194EE7C78E819F5C1E94661E414F795E37C21F55AACD703073O00E19A2313817A9E025O00F89C40025O00689340030C3O00780CEA54FEE8C5207109E85C03083O00543A608B379587B003093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66025O00F09A40025O002BB2402O033O001E36AD03073O005E735FC3602EAF031C3O0041472O3E252292F47C40363E256D94E5514E31343A34B8B2570B6D6503083O0080232B5F5D4E4DE7030C3O0086112O371C71BCB0363F371C03073O00C9C47D5654771E030B3O00E5E717ABD0E10299D6FC1D03043O00DFA38E64030F3O00432O6F6C646F776E52656D61696E7303123O00B11EC2B5B79514CCA9B18C11F7A3BD8312D003053O00D8E276A3D1030B3O004973417661696C61626C65025O0064AC40025O007AB3402O033O00B3F91503073O005FDE907B613710031C3O001B88BB40E81691AE7CE81087B103F01C96BF4DEA0D9D8511F759D7EA03053O008379E4DA23025O002CAB40025O0077B140030D3O00B1D72F118DD90F0D8DF5351B8803043O0078E3BE5C03063O0042752O66557003113O005072652O73757265506F696E7442752O66030D3O00526973696E6753756E4B69636B2O033O0030551103083O00825D3C7F1B433CB9031E3O005A3B2B47EE44425B273671EB4A7E43722B4BF2467341262171B2573D196203073O001D2852582E8023025O0074AF40025O00AC9240030D3O00094CC7140FBF0850DA3608BB3003063O00D85B25B47D61025O006CB040025O008046402O033O00287F1203053O003745167CA3031E3O006ADA4FE1D1766FE76DDD63E3D6725BB46BD64EEDD17844ED478148A88E2303083O009418B33C88BF1130025O0004B040030C3O009026F8A3FDBD3FED8BFFB12103053O0096D24A99C0026O000840030B3O0042752O6652656D61696E732O033O00EEC13603073O00D483A858EA151A026O009040025O002C9940031B3O004778888F33285060B68731244E349A892A224B7D9D9507755134DF03063O00472514E9EC5803113O00EAC02B0F77122OD701137815DCFB2B027203063O007BB9B042611903113O005370692O6E696E674372616E654B69636B03103O0044616E63656F664368696A6942752O66025O0058AA40025O00088C40025O0068A640025O00D4AD40026O00204003223O00DB1F105F1B265636F70C0B501B2A673AC10C1211062A4A34C6060D482A7D4C719B5D03083O0051A86F7931754F3803113O00F41AECB8C903EBB1E418E4B8C221ECB5CC03043O00D6A76A85025O00F07B40025O0048824003223O003A2845413A76D72E074F5D3571DC1633454C2O3FCA2C2A49413D6BC0166A580F672B03073O00B949582C2F541F025O00B6B140025O0044AB4003133O00BFDF13B2DFF686D03EB2D2F887D92AB5DDFC8003063O009FE8B77AC0B303133O00576869726C696E67447261676F6E50756E636803243O00333AA133283BA6261B36BA20233DA61E3427A6222C72BB243637A628302B97733072FB7703043O00414452C8026O001840025O0058A640025O003DB340030D3O00DBAF517072483AFCA869707F4403073O006989C622191C2F025O001EA640025O002076402O033O001CA04F03053O00A071C92116031D3O00C651BFAEA7AAEB4BB9A996A6DD5BA7E7BAA8C65DA2AEBDB4EB0AB8E7F103063O00CDB438CCC7C9025O00F8A440025O00E07D40030C3O00C83383EEFE0EEB0192EDFA1003063O00608E52E68297030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O6603183O00536B79726561636845786861757374696F6E446562752O66030A3O00446562752O66446F776E030C3O004661656C696E6553746F6D7003093O004973496E52616E6765031B3O0049B14A4EEDE04A8F5C56EBE35FF05C47F6EB41B92O5BDBBC5BF01D03063O008E2FD02F228403093O00C2B70307496CF7B20903063O003C96DE64623B03093O00546967657250616C6D2O033O0048355903073O0051255C3736BBDA025O00349140025O00AEA14003183O00144DAA32933F54AC3B8C4057A825840E4DB92EBE5250ED6303053O00E16024CD57025O009BB240030C3O00075C7323C4C06B312O7B23C403073O001E453012402OAF2O033O00FD2D0703053O005B904C7F8C025O004C9540025O009AA040031C3O00E2044722D8B5C0C4DF034F22D8FAC6D5F20D4828C7A3EA82F448157903083O00B080682641B3DAB503093O00E4CDC510C2F4C319DD03043O0075B0A4A203173O00B0C704F3D2708AC516FFDC6D8CC728FFD47897D600E2C303063O0019E4A26590BA025O00A8B240025O0096B24003193O005C3FBE0BE0DB5837B503B2F74D24BC00FBF05109EB1AB2B01803063O00842856D96E92025O00808240025O0080A740025O0098B040025O0052B040025O00707F40025O00AAA240030B3O001E21F8922B27EDA02D3AF203043O00E658488B03133O00496E766F6B65727344656C6967687442752O66025O0035B140025O00289740030B3O0046697374736F66467572792O033O007FB50E03073O003812D4767B6368031C3O0018E0EBC7CCE111EFC7D5CACC07A9EBD6CDDB10E0ECCAE08C0AA9AA8303063O00BE7E8998B3BF03093O00497343617374696E67025O0040A94003073O0053746F70466F4603233O002E0B61DFB97F27044DCDBF52313D71CAA4432D0E32D8AF522D0C7BDFB37F7A163299F803063O0020486212ABCA025O0045B240025O00989D4003133O00379C207DFC01873460FF01BF3B7AF30887207003053O009764E85214030B3O004BD1E3067BDCE40E76CAE203043O00681FB99603133O00537472696B656F6674686557696E646C6F72642O033O00D1B8EB03083O00A0BCD9939787AC8003253O001CC902F931CC30D216CF2EC10AE207F934CD03D202F47ADA0ACF15FE33DD16E242E47A9B5B03063O00A96FBD70905A025O0080AA40025O00F09340025O0080AE40025O00B2AB4003133O00C5ADC2EE48F3B6D6F34BF38ED9E947FAB6C2E303053O002396D9B087030B3O00CD581E02734664FF592O1803073O001699306B6C1723025O00089940025O0062A4402O033O000384A303083O00896EE5DB7A1F1521025O00EAA740025O004DB04003253O0009A92A723D4E1B711C822C733374337714B93474244F646D1FAF3D753F5F3D4148A9782A6E03083O001E7ADD581B562B44025O00A09F40030C3O00EB47B51A49E2496FD949BD0603083O003CAD26D076208C2C025O00388D40025O008AA040031C3O004733E4DF29C1440DF2C72FC25172F2D632CA4F3BF5CA1F9D5572B08703063O00AF215281B340025O004AB140025O00B0764003133O00DDFB22C637B7E1E924C73985E7E134C333A0EA03063O00D28E8F50AF5C030B3O008DE1E6C8BDECE1C0B0FAE703043O00A6D9899303133O0043612O6C746F446F6D696E616E636542752O66025O00C889402O033O00EEA26A03063O002683C312C69103253O0040C228E233516CD93CD42C5C56E92DE236505FD928EF784756C43FE531404AE968FF782O0503063O003433B65A8B58001B042O0012283O00014O0074000100023O0026BF3O0007000100010004E03O00070001001228000100014O0074000200023O0012283O00023O00260C012O000B000100020004E03O000B0001002EE800040002000100030004E03O000200010026BF0001000B000100010004E03O000B0001001228000200013O0026BF000200D2000100050004E03O00D20001001228000300014O0074000400043O002EE800070012000100060004E03O00120001000E512O010012000100030004E03O00120001001228000400013O0026BF00040086000100010004E03O00860001001228000500013O000E510102001E000100050004E03O001E0001001228000400023O0004E03O008600010026BF0005001A000100010004E03O001A00012O006A01066O0070000700013O00122O000800083O00122O000900096O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006003700013O0004E03O003700012O006A010600024O006A01075O0020D400070007000B2O00300106000200020006A30006003700013O0004E03O003700012O006A010600033O0020B800060006000C00122O0008000D3O00122O0009000E6O00060009000200062O00060039000100010004E03O00390001002EE8001000510001000F0004E03O005100012O006A010600043O00200E0106000600114O00075O00202O00070007000B4O000800056O000900013O00122O000A00123O00122O000B00136O0009000B00024O000A00066O000B000B6O000C00073O00202O000C000C001400122O000E00156O000C000E00024O000C000C6O0006000C000200062O0006005100013O0004E03O005100012O006A010600013O001228000700163O001228000800174O0049010600084O001000065O002E8F00190084000100180004E03O008400012O006A01066O0070000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006008400013O0004E03O008400012O006A010600024O006A01075O0020D400070007000B2O00300106000200020006A30006008400013O0004E03O008400012O006A010600033O00205800060006001C4O00085O00202O00080008001D4O00060008000200262O000600840001000E0004E03O00840001002EE8001E00840001001F0004E03O008400012O006A010600043O00200E0106000600114O00075O00202O00070007000B4O000800056O000900013O00122O000A00203O00122O000B00216O0009000B00024O000A00066O000B000B6O000C00073O00202O000C000C001400122O000E00156O000C000E00024O000C000C6O0006000C000200062O0006008400013O0004E03O008400012O006A010600013O001228000700223O001228000800234O0049010600084O001000065O001228000500023O0004E03O001A00010026BF00040017000100020004E03O001700012O006A01056O0070000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500CD00013O0004E03O00CD00012O006A010500024O006A01065O0020D400060006000B2O00300105000200020006A3000500CD00013O0004E03O00CD00012O006A01056O0012000600013O00122O000700263O00122O000800276O0006000800024O00050005000600202O0005000500284O000500020002000E2O001500CD000100050004E03O00CD00012O006A01056O0070000600013O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O00050005002B4O00050002000200062O000500CD00013O0004E03O00CD00012O006A010500033O00205800050005001C4O00075O00202O00070007001D4O00050007000200262O000500CD000100020004E03O00CD0001002E8F002C00CD0001002D0004E03O00CD00012O006A010500043O00200E0105000500114O00065O00202O00060006000B4O000700056O000800013O00122O0009002E3O00122O000A002F6O0008000A00024O000900066O000A000A6O000B00073O00202O000B000B001400122O000D00156O000B000D00024O000B000B6O0005000B000200062O000500CD00013O0004E03O00CD00012O006A010500013O001228000600303O001228000700314O0049010500074O001000055O001228000200153O0004E03O00D200010004E03O001700010004E03O00D200010004E03O001200010026BF000200762O0100020004E03O00762O01001228000300013O00260C010300D9000100010004E03O00D90001002EA701320060000100330004E03O00372O012O006A01046O0070000500013O00122O000600343O00122O000700356O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400092O013O0004E03O00092O012O006A010400033O0020640104000400364O00065O00202O0006000600374O00040006000200062O000400092O013O0004E03O00092O012O006A010400033O0020A101040004000C00122O0006000D3O00122O0007000E6O00040007000200062O000400092O013O0004E03O00092O012O006A010400043O00200E0104000400114O00055O00202O0005000500384O000600056O000700013O00122O000800393O00122O0009003A6O0007000900024O000800066O000900096O000A00073O00202O000A000A001400122O000C00156O000A000C00024O000A000A6O0004000A000200062O000400092O013O0004E03O00092O012O006A010400013O0012280005003B3O0012280006003C4O0049010400064O001000045O002E8F003E00362O01003D0004E03O00362O012O006A01046O0070000500013O00122O0006003F3O00122O000700406O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400362O013O0004E03O00362O012O006A010400033O0020A101040004000C00122O0006000D3O00122O0007000E6O00040007000200062O000400362O013O0004E03O00362O01002E8F004200362O0100410004E03O00362O012O006A010400043O00200E0104000400114O00055O00202O0005000500384O000600056O000700013O00122O000800433O00122O000900446O0007000900024O000800066O000900096O000A00073O00202O000A000A001400122O000C00156O000A000C00024O000A000A6O0004000A000200062O000400362O013O0004E03O00362O012O006A010400013O001228000500453O001228000600464O0049010400064O001000045O001228000300023O0026BF000300D5000100020004E03O00D50001002EA70147003A000100470004E03O00732O012O006A01046O0070000500013O00122O000600483O00122O000700496O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400732O013O0004E03O00732O012O006A010400024O006A01055O0020D400050005000B2O00300104000200020006A3000400732O013O0004E03O00732O012O006A010400033O00205800040004001C4O00065O00202O00060006001D4O00040006000200262O000400732O01004A0004E03O00732O012O006A010400033O00207701040004004B4O00065O00202O00060006001D4O00040006000200262O000400732O0100020004E03O00732O012O006A010400043O00208C0004000400114O00055O00202O00050005000B4O000600056O000700013O00122O0008004C3O00122O0009004D6O0007000900024O000800066O000900096O000A00073O00202O000A000A001400122O000C00156O000A000C00024O000A000A6O0004000A000200062O0004006E2O0100010004E03O006E2O01002E8F004F00732O01004E0004E03O00732O012O006A010400013O001228000500503O001228000600514O0049010400064O001000045O0012280002000E3O0004E03O00762O010004E03O00D50001000E51011500ED2O0100020004E03O00ED2O01001228000300013O0026BF000300CB2O0100010004E03O00CB2O012O006A01046O0070000500013O00122O000600523O00122O000700536O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400922O013O0004E03O00922O012O006A010400024O006A01055O0020D40005000500542O00300104000200020006A3000400922O013O0004E03O00922O012O006A010400033O00208F0104000400364O00065O00202O0006000600554O00040006000200062O000400942O0100010004E03O00942O01002E8F005600A72O0100570004E03O00A72O01002EE8005800A72O0100590004E03O00A72O012O006A010400084O001C01055O00202O0005000500544O000600076O000800073O00202O00080008001400122O000A005A6O0008000A00024O000800086O00040008000200062O000400A72O013O0004E03O00A72O012O006A010400013O0012280005005B3O0012280006005C4O0049010400064O001000046O006A01046O0070000500013O00122O0006005D3O00122O0007005E6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400CA2O013O0004E03O00CA2O012O006A010400024O006A01055O0020D40005000500542O00300104000200020006A3000400CA2O013O0004E03O00CA2O01002E8F005F00CA2O0100600004E03O00CA2O012O006A010400084O001C01055O00202O0005000500544O000600076O000800073O00202O00080008001400122O000A005A6O0008000A00024O000800086O00040008000200062O000400CA2O013O0004E03O00CA2O012O006A010400013O001228000500613O001228000600624O0049010400064O001000045O001228000300023O00260C010300CF2O0100020004E03O00CF2O01002EE8006300792O0100640004E03O00792O012O006A01046O0070000500013O00122O000600653O00122O000700666O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400EA2O013O0004E03O00EA2O012O006A010400084O001C01055O00202O0005000500674O000600076O000800073O00202O00080008001400122O000A00156O0008000A00024O000800086O00040008000200062O000400EA2O013O0004E03O00EA2O012O006A010400013O001228000500683O001228000600694O0049010400064O001000045O0012280002006A3O0004E03O00ED2O010004E03O00792O01002EE8006B00920201006C0004E03O009202010026BF00020092020100010004E03O00920201001228000300014O0074000400043O0026BF000300F32O0100010004E03O00F32O01001228000400013O0026BF00040025020100020004E03O002502012O006A01056O0070000600013O00122O0007006D3O00122O0008006E6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005002302013O0004E03O002302012O006A010500033O0020640105000500364O00075O00202O0007000700374O00050007000200062O0005002302013O0004E03O00230201002EE8007000230201006F0004E03O002302012O006A010500043O00200E0105000500114O00065O00202O0006000600384O000700056O000800013O00122O000900713O00122O000A00726O0008000A00024O000900066O000A000A6O000B00073O00202O000B000B001400122O000D00156O000B000D00024O000B000B6O0005000B000200062O0005002302013O0004E03O002302012O006A010500013O001228000600733O001228000700744O0049010500074O001000055O001228000200023O0004E03O00920201002E8F007600F62O0100750004E03O00F62O01000E512O0100F62O0100040004E03O00F62O01001228000500013O0026BF00050088020100010004E03O008802012O006A01066O0070000700013O00122O000800773O00122O000900786O0007000900024O00060006000700202O0006000600794O00060002000200062O0006005D02013O0004E03O005D02012O006A010600073O00207701060006007A4O00085O00202O00080008007B4O00060008000200262O0006005D0201000E0004E03O005D02012O006A010600073O0020BA00060006007A4O00085O00202O00080008007C4O0006000800024O000600063O00262O0006005D0201000E0004E03O005D02012O006A010600073O00206401060006007D4O00085O00202O00080008007C4O00060008000200062O0006005D02013O0004E03O005D02012O006A010600084O001C01075O00202O00070007007E4O000800096O000A00073O00202O000A000A007F00122O000C000D6O000A000C00024O000A000A6O0006000A000200062O0006005D02013O0004E03O005D02012O006A010600013O001228000700803O001228000800814O0049010600084O001000066O006A01066O0070000700013O00122O000800823O00122O000900836O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006008702013O0004E03O008702012O006A010600024O006A01075O0020D40007000700842O00300106000200020006A30006008702013O0004E03O008702012O006A010600043O00208C0006000600114O00075O00202O0007000700844O000800056O000900013O00122O000A00853O00122O000B00866O0009000B00024O000A00096O000B000B6O000C00073O00202O000C000C001400122O000E00156O000C000E00024O000C000C6O0006000C000200062O00060082020100010004E03O00820201002E8F00880087020100870004E03O008702012O006A010600013O001228000700893O0012280008008A4O0049010600084O001000065O001228000500023O002EA7018B00A2FF2O008B0004E03O002A02010026BF0005002A020100020004E03O002A0201001228000400023O0004E03O00F62O010004E03O002A02010004E03O00F62O010004E03O009202010004E03O00F32O01000E51016A00ED020100020004E03O00ED02012O006A01036O0070000400013O00122O0005008C3O00122O0006008D6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300BE02013O0004E03O00BE02012O006A010300024O006A01045O0020D400040004000B2O00300103000200020006A3000300BE02013O0004E03O00BE02012O006A010300043O00208C0003000300114O00045O00202O00040004000B4O000500056O000600013O00122O0007008E3O00122O0008008F6O0006000800024O0007000A6O000800086O000900073O00202O00090009001400122O000B00156O0009000B00024O000900096O00030009000200062O000300B9020100010004E03O00B90201002EE8009100BE020100900004E03O00BE02012O006A010300013O001228000400923O001228000500934O0049010300054O001000036O006A01036O0070000400013O00122O000500943O00122O000600956O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003001A04013O0004E03O001A04012O006A01036O0070000400013O00122O000500963O00122O000600976O0004000600024O00030003000400202O00030003002B4O00030002000200062O0003001A04013O0004E03O001A04012O006A010300033O00207701030003001C4O00055O00202O00050005001D4O00030005000200262O0003001A0401004A0004E03O001A0401002EE80099001A040100980004E03O001A04012O006A010300084O001C01045O00202O0004000400844O000500066O000700073O00202O00070007001400122O000900156O0007000900024O000700076O00030007000200062O0003001A04013O0004E03O001A04012O006A010300013O00121F0104009A3O00122O0005009B6O000300056O00035O00044O001A04010026BF000200730301004A0004E03O00730301001228000300013O002E8F009C00400301009D0004E03O004003010026BF00030040030100010004E03O00400301001228000400013O002EE8009F00FB0201009E0004E03O00FB02010026BF000400FB020100020004E03O00FB0201001228000300023O0004E03O00400301002E8F00A000F5020100A10004E03O00F502010026BF000400F5020100010004E03O00F502012O006A01056O0070000600013O00122O000700A23O00122O000800A36O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005001003013O0004E03O001003012O006A010500033O00208F0105000500364O00075O00202O0007000700A44O00050007000200062O00050012030100010004E03O00120301002EE800A5002A030100A60004E03O002A03012O006A010500043O00200E0105000500114O00065O00202O0006000600A74O0007000B6O000800013O00122O000900A83O00122O000A00A96O0008000A00024O0009000A6O000A000A6O000B00073O00202O000B000B001400122O000D005A6O000B000D00024O000B000B6O0005000B000200062O0005002A03013O0004E03O002A03012O006A010500013O001228000600AA3O001228000700AB4O0049010500074O001000056O006A010500033O0020640105000500AC4O00075O00202O0007000700A74O00050007000200062O0005003E03013O0004E03O003E0301002EA701AD000D000100AD0004E03O003E03012O006A0105000C4O006A0106000D3O0020D40006000600AE2O00300105000200020006A30005003E03013O0004E03O003E03012O006A010500013O001228000600AF3O001228000700B04O0049010500074O001000055O001228000400023O0004E03O00F5020100260C01030044030100020004E03O00440301002E8F00B100F0020100B20004E03O00F002012O006A01046O0070000500013O00122O000600B33O00122O000700B46O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004007003013O0004E03O007003012O006A01046O0070000500013O00122O000600B53O00122O000700B66O0005000700024O00040004000500202O00040004002B4O00040002000200062O0004007003013O0004E03O007003012O006A010400043O00200E0104000400114O00055O00202O0005000500B74O000600056O000700013O00122O000800B83O00122O000900B96O0007000900024O0008000A6O000900096O000A00073O00202O000A000A001400122O000C00156O000A000C00024O000A000A6O0004000A000200062O0004007003013O0004E03O007003012O006A010400013O001228000500BA3O001228000600BB4O0049010400064O001000045O001228000200053O0004E03O007303010004E03O00F00201000E51010E000E000100020004E03O000E0001001228000300014O0074000400043O002E8F00BD0077030100BC0004E03O007703010026BF00030077030100010004E03O00770301001228000400013O000E9101020080030100040004E03O00800301002E8F00BE00B2030100BF0004E03O00B203012O006A01056O0070000600013O00122O000700C03O00122O000800C16O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009403013O0004E03O009403012O006A01056O00A4000600013O00122O000700C23O00122O000800C36O0006000800024O00050005000600202O00050005002B4O00050002000200062O00050096030100010004E03O00960301002E8F00C500B0030100C40004E03O00B003012O006A010500043O0020EE0005000500114O00065O00202O0006000600B74O000700056O000800013O00122O000900C63O00122O000A00C76O0008000A00024O0009000A6O000A000E4O006A010B00073O002011000B000B001400122O000D00156O000B000D00024O000B000B6O0005000B000200062O000500AB030100010004E03O00AB0301002EA701C80007000100C90004E03O00B003012O006A010500013O001228000600CA3O001228000700CB4O0049010500074O001000055O0012280002004A3O0004E03O000E00010026BF0004007C030100010004E03O007C0301002EA701CC0026000100CC0004E03O00DA03012O006A01056O0070000600013O00122O000700CD3O00122O000800CE6O0006000800024O00050005000600202O0005000500794O00050002000200062O000500DA03013O0004E03O00DA03012O006A010500073O00207701050005007A4O00075O00202O00070007007B4O00050007000200262O000500DA0301000E0004E03O00DA03012O006A010500084O003400065O00202O00060006007E4O000700086O000900073O00202O00090009007F00122O000B000D6O0009000B00024O000900096O00050009000200062O000500D5030100010004E03O00D50301002E8F00D000DA030100CF0004E03O00DA03012O006A010500013O001228000600D13O001228000700D24O0049010500074O001000055O002EE800D40011040100D30004E03O001104012O006A01056O0070000600013O00122O000700D53O00122O000800D66O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005001104013O0004E03O001104012O006A01056O0070000600013O00122O000700D73O00122O000800D86O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005001104013O0004E03O001104012O006A010500033O0020640105000500364O00075O00202O0007000700D94O00050007000200062O0005001104013O0004E03O00110401002EA701DA001A000100DA0004E03O001104012O006A010500043O0020EE0005000500114O00065O00202O0006000600B74O000700056O000800013O00122O000900DB3O00122O000A00DC6O0008000A00024O0009000A6O000A000F4O006A010B00073O0020EF000B000B001400122O000D00156O000B000D00024O000B000B6O0005000B000200062O0005001104013O0004E03O001104012O006A010500013O001228000600DD3O001228000700DE4O0049010500074O001000055O001228000400023O0004E03O007C03010004E03O000E00010004E03O007703010004E03O000E00010004E03O001A04010004E03O000B00010004E03O001A04010004E03O000200012O003C012O00017O00A03O00028O00025O0062AF40025O00E06940026O00F03F025O00208240025O00A6AD40025O00889640025O0016A340025O0078A940025O0071B240025O00B8B240025O00ABB240030C3O0058CA22B0AE7DF96D6AC42AAC03083O003E1EAB47DCC7139C030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303113O004661654578706F73757265446562752O66027O0040030A3O00446562752O66446F776E03183O00536B79726561636845786861757374696F6E446562752O66025O0043B240025O0064A040030C3O004661656C696E6553746F6D7003093O004973496E52616E6765026O003E40025O00FCAA40025O0007B240031B3O004644A93A54C72A725351A33B4D893C485240A23F49D0105E5405FE03083O002D2025CC563DA94F03093O00615C02B9A74C54590803063O001C2O3565DCD503073O004973526561647903093O00546967657250616C6D025O00449340025O00AEAC40025O00108340025O0060B240030E3O004973496E4D656C2O6552616E6765026O00144003183O0019550F44489E40DE015148525FB355D10448117E49B5108B03083O00BF6D3C68213AC130025O00649840025O004CA340030D3O00B5DE0BEE89D02BF289FC11E48C03043O0087E7B778025O00408C40030D3O00526973696E6753756E4B69636B031D3O00F4035FED3B1D96F51F42DB3E13AAED4A5FE1271FA7EF1E55DB260EE9BE03073O00C9866A2C84557A030C3O001400763C0A03DD371D05743403083O0043566C175F616CA8030C3O00426C61636B6F75744B69636B03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O000840030B3O0042752O6652656D61696E73025O004AA140025O008CAC40031B3O00A6344D09AF2BC0449B334509AF64C655B63D4203B03DEA43B0781A03083O0030C4582C6AC444B5025O00C2AA40025O00EAAC40025O0024AD40025O00FAAE40025O00C2AF40025O00A6B240025O0016AC40025O0066AD40025O00E88040030C3O00CB0E3CB330C50FFD2934B33003073O007A89625DD05BAA03073O0048617354696572025O007CAF40025O0096B140031C3O0085ED1D4CDEBDBCDEB8EA154CDEF2BACF95E41246C1AB96D993A14E1D03083O00AAE7817C2FB5D2C903113O00B8AB333E042385BC19220B248E902O330103063O004AEBDB5A506A03113O005370692O6E696E674372616E654B69636B03063O0042752O66557003103O0044616E63656F664368696A6942752O66026O00204003223O005FD3523534FD74F573C0493A34F145F945C0507B29F168F742CA4F2205E76EB21E9703083O00922CA33B5B5A941A025O00606140025O00ECB240025O0026A140025O0046A44003093O00497343617374696E67030B3O0046697374736F664675727903073O0053746F70466F4603233O002B39900543982236BC1745B5340F80105EA4283CC30255B5283E8A0549983E24C3400803063O00C74D50E3713003133O00192B4CC4213A51CB3E375BFA23315AC1252D5A03043O00AD4A5F3E03133O0043612O6C746F446F6D696E616E636542752O6603133O00537472696B656F6674686557696E646C6F7264025O00BEB140025O00B89C4003253O00D50D4E3FC00283C91F6322C30283D1105232C708AEC2594F33D902B2CF0D4509D813FC944903073O00DCA6793C56AB67025O00B09B40025O00CCB240025O0080A940025O00588E40030C3O005721B982427A38ACAA40762603053O0029154DD8E1026O008840025O0088A640031C3O00164173461F4267512B467B461F0D614006487C4C00544D56000D201303043O0025742D12025O00A09C40025O0066AB4003133O00F8F75FB0A7C6F15186B9CEF859AC9BDAF155AA03053O00CBAF9F36C203133O00576869726C696E67447261676F6E50756E636803243O006CC610295646CC7CF11D295B48CD75F1092E544CCA3BDD1C295F41CB6FD726284E0F902303073O00A21BAE795B3A2F03093O00E7CC18F02DE9D2C91203063O00B9B3A57F955F03173O006570CEF71F587BC8E7185761C7F13A5E7BCEE7035467D603053O00773115AF94030B3O004973417661696C61626C65025O00C8AB40025O00F4A94003193O0043BC11583F769AF45BB8564E285B8FFB5EA10F623E5DCAA60703083O009537D5763D4D29EA03133O00700D321C481C2F13571125224A1724194C0B2403043O0075237940030B3O00E9B5FBD8274ACFBBE7C53703063O002FBDDD8EB643025O00804B40025O00408F40025O0041B040025O00EEAC40025O0070A14003253O0033AB35C243AC1F2O268033C34D9637202EBB2BC45AAD603A25AD22C541BD391633AB679A1C03083O004940DF47AB28C940030B3O002C84D74DB3720CABD14BB903063O001D6AEDA439C003133O00496E766F6B65727344656C6967687442752O66025O004AA040025O0056A540031C3O00B7ADF4AEC6EDAFF48EA2F2A8CC92B3F7A3A1E9B3C1CB9FE1A5E4B6EC03083O0092D1C487DAB5B2C0025O00F07340025O0047B040030C3O00A4DED92F89AAA71F96D0D13303083O004CE2BFBC43E0C4C2025O0098A440031C3O00DF2902FCF4D72D38E3E9D62517B0EEDC3A02FEF4CD3138E3E999795703053O009DB948679003133O006AA79873A3B456B59E72AD8650BD8E76A7A35D03063O00D139D3EA1AC8030B3O0035C6B38F54D713C8AF924403063O00B261AEC6E130025O00DDB040025O0078A84003253O00DC4216F873E330C0503BE570E330D85F0AF574E91DCB1617F46AE301C6421DCE6BF24F9E0403073O006FAF366491188600D7022O0012283O00014O0074000100023O002E8F000300D0020100020004E03O00D002010026BF3O00D0020100040004E03O00D00201002E8F00050006000100060004E03O000600010026BF00010006000100010004E03O00060001001228000200013O00260C0102000F000100010004E03O000F0001002E8F000800D2000100070004E03O00D20001001228000300013O00260C01030014000100010004E03O00140001002EA7010900680001000A0004E03O007A0001001228000400013O002EE8000C00730001000B0004E03O007300010026BF00040073000100010004E03O007300012O006A01056O0070000600013O00122O0007000D3O00122O0008000E6O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005003100013O0004E03O003100012O006A010500023O0020770105000500104O00075O00202O0007000700114O00050007000200262O00050031000100120004E03O003100012O006A010500023O00208F0105000500134O00075O00202O0007000700144O00050007000200062O00050033000100010004E03O00330001002EE800150046000100160004E03O004600012O006A010500034O003400065O00202O0006000600174O000700086O000900023O00202O00090009001800122O000B00196O0009000B00024O000900096O00050009000200062O00050041000100010004E03O00410001002EE8001B00460001001A0004E03O004600012O006A010500013O0012280006001C3O0012280007001D4O0049010500074O001000056O006A01056O0070000600013O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O0005000500204O00050002000200062O0005005D00013O0004E03O005D00012O006A010500023O0020640105000500134O00075O00202O0007000700144O00050007000200062O0005005D00013O0004E03O005D00012O006A010500044O006A01065O0020D40006000600212O00300105000200020006820105005F000100010004E03O005F0001002E8F00230072000100220004E03O00720001002EE800240072000100250004E03O007200012O006A010500034O001C01065O00202O0006000600214O000700086O000900023O00202O00090009002600122O000B00276O0009000B00024O000900096O00050009000200062O0005007200013O0004E03O007200012O006A010500013O001228000600283O001228000700294O0049010500074O001000055O001228000400043O00260C01040077000100040004E03O00770001002EE8002B00150001002A0004E03O00150001001228000300043O0004E03O007A00010004E03O001500010026BF000300CB000100040004E03O00CB00012O006A01046O0070000500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O0004000400204O00040002000200062O0004009900013O0004E03O00990001002EA7012E00130001002E0004E03O009900012O006A010400034O001C01055O00202O00050005002F4O000600076O000800023O00202O00080008002600122O000A00276O0008000A00024O000800086O00040008000200062O0004009900013O0004E03O009900012O006A010400013O001228000500303O001228000600314O0049010400064O001000046O006A01046O0070000500013O00122O000600323O00122O000700336O0005000700024O00040004000500202O0004000400204O00040002000200062O000400B700013O0004E03O00B700012O006A010400044O006A01055O0020D40005000500342O00300104000200020006A3000400B700013O0004E03O00B700012O006A010400053O0020580004000400354O00065O00202O0006000600364O00040006000200262O000400B7000100370004E03O00B700012O006A010400053O0020220004000400384O00065O00202O0006000600364O00040006000200262O000400B9000100040004E03O00B90001002E8F003A00CA000100390004E03O00CA00012O006A010400034O001C01055O00202O0005000500344O000600076O000800023O00202O00080008002600122O000A00276O0008000A00024O000800086O00040008000200062O000400CA00013O0004E03O00CA00012O006A010400013O0012280005003B3O0012280006003C4O0049010400064O001000045O001228000300123O002EE8003D00100001003E0004E03O001000010026BF00030010000100120004E03O00100001001228000200043O0004E03O00D200010004E03O001000010026BF0002008F2O0100120004E03O008F2O01001228000300014O0074000400043O00260C010300DA000100010004E03O00DA0001002EE8004000D60001003F0004E03O00D60001001228000400013O002EE80041003E2O0100420004E03O003E2O010026BF0004003E2O0100040004E03O003E2O01001228000500013O00260C010500E4000100040004E03O00E40001002E8F004400E6000100430004E03O00E60001001228000400123O0004E03O003E2O01002EA7014500FAFF2O00450004E03O00E000010026BF000500E0000100010004E03O00E000012O006A01066O0070000700013O00122O000800463O00122O000900476O0007000900024O00060006000700202O0006000600204O00060002000200062O000600142O013O0004E03O00142O012O006A010600044O006A01075O0020D40007000700342O00300106000200020006A3000600142O013O0004E03O00142O012O006A010600053O0020A101060006004800122O000800193O00122O000900126O00060009000200062O000600142O013O0004E03O00142O01002E8F004900142O01004A0004E03O00142O012O006A010600034O001C01075O00202O0007000700344O000800096O000A00023O00202O000A000A002600122O000C00276O000A000C00024O000A000A6O0006000A000200062O000600142O013O0004E03O00142O012O006A010600013O0012280007004B3O0012280008004C4O0049010600084O001000066O006A01066O0070000700013O00122O0008004D3O00122O0009004E6O0007000900024O00060006000700202O0006000600204O00060002000200062O0006003C2O013O0004E03O003C2O012O006A010600044O006A01075O0020D400070007004F2O00300106000200020006A30006003C2O013O0004E03O003C2O012O006A010600053O0020640106000600504O00085O00202O0008000800514O00060008000200062O0006003C2O013O0004E03O003C2O012O006A010600034O001C01075O00202O00070007004F4O000800096O000A00023O00202O000A000A002600122O000C00526O000A000C00024O000A000A6O0006000A000200062O0006003C2O013O0004E03O003C2O012O006A010600013O001228000700533O001228000800544O0049010600084O001000065O001228000500043O0004E03O00E00001002EE8005500442O0100560004E03O00442O010026BF000400442O0100120004E03O00442O01001228000200373O0004E03O008F2O0100260C010400482O0100010004E03O00482O01002E8F005800DB000100570004E03O00DB0001001228000500013O0026BF0005004D2O0100040004E03O004D2O01001228000400043O0004E03O00DB00010026BF000500492O0100010004E03O00492O012O006A010600053O0020640106000600594O00085O00202O00080008005A4O00060008000200062O000600612O013O0004E03O00612O012O006A010600064O006A010700073O0020D400070007005B2O00300106000200020006A3000600612O013O0004E03O00612O012O006A010600013O0012280007005C3O0012280008005D4O0049010600084O001000066O006A01066O0070000700013O00122O0008005E3O00122O0009005F6O0007000900024O00060006000700202O0006000600204O00060002000200062O0006008A2O013O0004E03O008A2O012O006A010600023O0020DF0006000600104O00085O00202O0008000800144O0006000800024O000700053O00202O0007000700384O00095O00202O0009000900604O00070009000200062O0007008A2O0100060004E03O008A2O012O006A010600034O003400075O00202O0007000700614O000800096O000A00023O00202O000A000A002600122O000C00276O000A000C00024O000A000A6O0006000A000200062O000600852O0100010004E03O00852O01002E8F0062008A2O0100630004E03O008A2O012O006A010600013O001228000700643O001228000800654O0049010600084O001000065O001228000500043O0004E03O00492O010004E03O00DB00010004E03O008F2O010004E03O00D60001002E8F00660004020100670004E03O000402010026BF00020004020100370004E03O00040201002EE8006900B82O0100680004E03O00B82O012O006A01036O0070000400013O00122O0005006A3O00122O0006006B6O0004000600024O00030003000400202O0003000300204O00030002000200062O000300B82O013O0004E03O00B82O012O006A010300044O006A01045O0020D40004000400342O00300103000200020006A3000300B82O013O0004E03O00B82O012O006A010300034O003400045O00202O0004000400344O000500066O000700023O00202O00070007002600122O000900276O0007000900024O000700076O00030007000200062O000300B32O0100010004E03O00B32O01002EA7016C00070001006D0004E03O00B82O012O006A010300013O0012280004006E3O0012280005006F4O0049010300054O001000035O002EE8007000D52O0100710004E03O00D52O012O006A01036O0070000400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O0003000300204O00030002000200062O000300D52O013O0004E03O00D52O012O006A010300034O001C01045O00202O0004000400744O000500066O000700023O00202O00070007002600122O000900276O0007000900024O000700076O00030007000200062O000300D52O013O0004E03O00D52O012O006A010300013O001228000400753O001228000500764O0049010300054O001000036O006A01036O0070000400013O00122O000500773O00122O000600786O0004000600024O00030003000400202O0003000300204O00030002000200062O000300D602013O0004E03O00D602012O006A01036O0070000400013O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O00030003007B4O00030002000200062O000300D602013O0004E03O00D602012O006A010300053O0020770103000300354O00055O00202O0005000500364O00030005000200262O000300D6020100370004E03O00D602012O006A010300034O003400045O00202O0004000400214O000500066O000700023O00202O00070007002600122O000900276O0007000900024O000700076O00030007000200062O000300FE2O0100010004E03O00FE2O01002E8F007C00D60201007D0004E03O00D602012O006A010300013O00121F0104007E3O00122O0005007F6O000300056O00035O00044O00D60201000E510104000B000100020004E03O000B0001001228000300014O0074000400043O0026BF00030008020100010004E03O00080201001228000400013O0026BF0004000F020100120004E03O000F0201001228000200123O0004E03O000B00010026BF00040066020100040004E03O006602012O006A01056O0070000600013O00122O000700803O00122O000800816O0006000800024O00050005000600202O0005000500204O00050002000200062O0005002C02013O0004E03O002C02012O006A01056O0070000600013O00122O000700823O00122O000800836O0006000800024O00050005000600202O00050005007B4O00050002000200062O0005002C02013O0004E03O002C02012O006A010500023O0020730105000500104O00075O00202O0007000700144O000500070002000E2O0084002E020100050004E03O002E0201002EA701850015000100860004E03O00410201002EE800880041020100870004E03O004102012O006A010500034O001C01065O00202O0006000600614O000700086O000900023O00202O00090009002600122O000B00276O0009000B00024O000900096O00050009000200062O0005004102013O0004E03O004102012O006A010500013O001228000600893O0012280007008A4O0049010500074O001000056O006A01056O0070000600013O00122O0007008B3O00122O0008008C6O0006000800024O00050005000600202O0005000500204O00050002000200062O0005005202013O0004E03O005202012O006A010500053O00208F0105000500504O00075O00202O00070007008D4O00050007000200062O00050054020100010004E03O00540201002EE8008F00650201008E0004E03O006502012O006A010500034O001C01065O00202O00060006005A4O000700086O000900023O00202O00090009002600122O000B00526O0009000B00024O000900096O00050009000200062O0005006502013O0004E03O006502012O006A010500013O001228000600903O001228000700914O0049010500074O001000055O001228000400123O002E8F0092000B020100930004E03O000B02010026BF0004000B020100010004E03O000B02012O006A01056O0070000600013O00122O000700943O00122O000800956O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005008E02013O0004E03O008E02012O006A010500023O0020770105000500104O00075O00202O0007000700114O00050007000200262O0005008E020100120004E03O008E0201002EA701960013000100960004E03O008E02012O006A010500034O001C01065O00202O0006000600174O000700086O000900023O00202O00090009001800122O000B00196O0009000B00024O000900096O00050009000200062O0005008E02013O0004E03O008E02012O006A010500013O001228000600973O001228000700984O0049010500074O001000056O006A01056O0070000600013O00122O000700993O00122O0008009A6O0006000800024O00050005000600202O0005000500204O00050002000200062O000500C802013O0004E03O00C802012O006A01056O0070000600013O00122O0007009B3O00122O0008009C6O0006000800024O00050005000600202O00050005007B4O00050002000200062O000500C802013O0004E03O00C802012O006A010500053O0020640105000500504O00075O00202O0007000700604O00050007000200062O000500C802013O0004E03O00C802012O006A010500023O0020DF0005000500104O00075O00202O0007000700144O0005000700024O000600053O00202O0006000600384O00085O00202O0008000800604O00060008000200062O000600C8020100050004E03O00C80201002E8F009E00C80201009D0004E03O00C802012O006A010500034O001C01065O00202O0006000600614O000700086O000900023O00202O00090009002600122O000B00276O0009000B00024O000900096O00050009000200062O000500C802013O0004E03O00C802012O006A010500013O0012280006009F3O001228000700A04O0049010500074O001000055O001228000400043O0004E03O000B02010004E03O000B00010004E03O000802010004E03O000B00010004E03O00D602010004E03O000600010004E03O00D602010026BF3O0002000100010004E03O00020001001228000100014O0074000200023O0012283O00043O0004E03O000200012O003C012O00017O00F83O00028O00026O00F03F025O004C9740025O00A2A540027O0040025O0020AC40025O006AB340030C3O003F1A0EA97912031B817B1E1D03053O00127D766FCA03073O004973526561647903093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O00084003123O00633458FE3FBAC5F4483557FD04BFC2FA542F03083O009B305C399A50CDA7030B3O004973417661696C61626C65025O008C9240025O00EEAE40025O0098AE40030C3O00436173745461726765744966030C3O00426C61636B6F75744B69636B2O033O00B4C4B503073O0025D9ADDBDF98CB030E3O004973496E4D656C2O6552616E6765026O001440031C3O000B091E3544A7E31D3A143F4CA3B60D0019375AA4E2360410330FF9A203073O009669657F562FC803133O00F92OFAA7CBC9C0F5D7A7C6C7C1FCC3A0C9C3C603063O00A0AE9293D5A7025O00B88140025O0068A64003133O00576869726C696E67447261676F6E50756E636803243O0057EC135600484EE325401E4047EB147B1C544EE71204084446E50F48187E41EB1F045D1703063O002120847A246C025O0092A940025O00988240025O0064B040025O0034AB40025O00FEAA40025O00208640025O00E49540025O0040834003113O007035260CE0DF8644063D03E0D3A34A262403073O00E823454F628EB603063O0042752O66557003103O00426F6E65647573744272657742752O6603113O005370692O6E696E674372616E654B69636B026O00204003223O006A1016F3770911FA46030DFC770520F6700314BD7D0519FC6C0C0BC2780F1ABD285003043O009D19607F030D3O00958AE60C5E369496FB2E5932AC03063O0051C7E395653003113O005072652O73757265506F696E7442752O6603073O0048617354696572026O003E40030D3O00526973696E6753756E4B69636B2O033O00705BF503083O00DB1D329B7196E65C025O0056B140025O00A09240031E3O00C329D672F14F72C235CB44F4414EDA60C17EF94958DD34FA7AF04D0D807203073O002DB140A51B9F28026O001040025O0084A240025O0074A94003113O002125A809EB275A193127A009E0055D1D1903083O007E7255C167854E34030B3O00E2D2216CD7D4345ED1C92B03043O0018A4BB52030F3O00432O6F6C646F776E52656D61696E732O033O00436869025O005EB04003223O00E2CA55A4FFF8D45B95F2E3DB52AFCEFAD35FA1B1F5DF5AABE4FDCE63ABFEF49A0FFA03053O002O91BA3CCA030F3O00D4C5200CEFDE342EE7D43633EFDE3703043O006486B05303083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66025O005CA040025O001DB040030F3O0052757368696E674A61646557696E64025O00549940025O009AAE4003203O00C1D451B5BA1BD4FE48BCB710ECD64BB3B755D7C444BCA619C7FE43B2B655809303063O0075B3A122DDD3025O002EA740025O0024B14003113O00060129B73B182EBE160321B7303A29BA3E03043O00D9557140030B3O006D06DFD4FC8DE36D1ADED903073O00852B6FACA08FE2030B3O00426C2O6F646C757374557003133O00496E766F6B65727344656C6967687442752O66025O00F6A040025O00ECAB4003223O00D8B359DFCEC2AD57EEC3D9A25ED4FFC0AA53DA80CFA656D0D5C7B76FD0CFCEE3028703053O00A0ABC330B1025O00D88340025O00489940030C3O00F10F772E57CEBAD3F80A752603083O00A7B363164D3CA1CF03123O0032778A5C43167D8440450F78BF4A49007B9803053O002C611FEB38026O002E40030B3O00D21CF9AAF438F7B6E50BE003043O00C4916E982O033O005527F003043O0092384E9E031C3O002FD74EE55122CE5BD95124D844A65E28DD4EF35639E44EE95F6D891703053O003A4DBB2F86025O0081B14003113O002E16C3C8E730A11C3E14CBC8EC12A6181603083O007B7D66AAA68959CF03103O0044616E63656F664368696A6942752O66025O000CB140025O008EA04003213O005D105133008AA7493F5B2F0F8DAC710B513E05C3AD4B0659280297964F0F5D7D5C03073O00C92E60385D6EE3025O004EAC40025O0010834003133O008817FCF01EC4B405FAF110F6B20DEAF51AD3BF03063O00A1DB638E9975030B3O0048B9B37DC979A3A07ADE6803053O00AD1CD1C61303133O00537472696B656F6674686557696E646C6F72642O033O0078EDAF03043O00DB158CD703243O005BACD4AE534D87C9A1675CB0C3984F41B6C2AB575ABC86A35D4EB9D3AB4C77B9C9A2181C03053O003828D8A6C7025O0046AE40025O0071B240025O00FC9240025O003C974003133O0011BC1C3D2ABD1B2802A6142829BA253A28B71D03043O004F46D47503233O00B01EE8D4F504A911DEC2EB0CA019EFF9E918A915E986FD08A117F4CAED32A619E486AF03063O006DC77681A699030B3O0017B964E222BF71D024A26E03043O009651D017025O001AB140025O0063B140025O0054B240025O0064A040030B3O0046697374736F66467572792O033O00F4C4F803043O00EB99A580031B3O00BD40B13B5519A5F8844FB73D5F66AEFBBD48B7235219ABF1BE09FA03083O009EDB29C24F2646CA025O0028AF40025O0036AE40025O006AAB40025O0028A740030C3O006FBCFBC50FF0B0599BF3C50F03073O00C52DD09AA6649F2O033O0024FD8803053O00534994E6DC025O00988E40025O0046B040031C3O0031D3F7E3E48626CBC9EBE68A389FF2E5E98826D3E2DFEE86369FA5B403063O00E953BF96808F03133O00C492DD7B06F289C96605F2B1C67C09FB89DD7603053O006D97E6AF12025O0072A340025O0054AF402O033O00ADFB5903053O00E0C09A212403253O0090400A8B8851278D856B0C8A866B0F8B8D50148D9150582O865219978F4027838C5158D1D503043O00E2E33478030C3O0027E7EDA741B0C2AD2EE2EFAF03083O00D9658B8CC42ADFB703123O002907AE1E4B2O0DA0024D14089B08411B0BBC03053O00247A6FCF7A2O033O002O01EA03063O00546C68842OD8025O007AB140025O00D89B40031C3O00CE17C75BEBAB57D824CD51E3AF02C81EC059F5A856F31AC95DA0F71A03073O0022AC7BA63880C403083O00872OA1E95F61C60003083O0074C4C9C8AB2A13B5030A3O0043686944656669636974025O00C07440025O00F0754003083O00436869427572737403093O004973496E52616E6765026O00444003183O00758EF26217150E6592BB5910061D638AEF62140F1936D2AB03073O007C16E69B3D7560025O00606F40025O003AB240025O0028A440025O008CAD40025O00E6B140025O00107E40026O007740025O00FCAA40030D3O008B1D614272BE27674557B0177903053O001CD974122B03133O00E55FDF46DCA732D573C455D7A132E242D857D803073O005CB237B634B0CE03133O002D3D7807163C7F123E277012153B410014367903043O00757A5511030B3O00AEE63950B5D28EC93F56BF03063O00BDE88F4A24C6031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O662O033O00F1A30403063O006A9CCA6A2EB7025O00FAA540025O00C4A940031E3O002F10683A243A2668262402127230217D1D7E352B28156F0C2B321C3B627203053O004A5D791B5303093O0058A3F67B7193E76C7003043O001E1DDB86030D3O0067AE0AF3FA582B1B5B8C10F9FF03083O006E35C7799A943F78030A3O00432O6F6C646F776E557003133O00320EED3652F90E1CEB375CCB0814FB3356EE0503063O009C617A9F5F39030B3O00E8BFC9EC180D39E8A3C8E103073O005FAED6BA986B6203093O00457870656C4861726D025O00B88F40025O0020714003193O008C16618E1FF9810F638653C28C08709E1FD2B60F7E8E5394D903063O00A6E96E11EB73025O00C0A840025O0074AF4003113O004B1ECDCFFCB7727F2DD6C0FCBB57710DCF03073O001C186EA4A192DE030B3O007DCA453148CC50034ED14F03043O00453BA336030D3O00436869456E6572677942752O66026O00244003223O00A3B8C3443DC4B8B797C95832C3B38FA3C349388DB2B5AECB5F3FD989B1A7CF0A619F03073O00D6D0C8AA2A53AD025O00088840025O007EA14003083O00FA297B8260CB326603053O0015B94112C0030A3O0049734361737461626C6503063O00456E65726779026O004940025O00F0924003183O00FD5E5424A3EB444E0FE1FA535B1AB4F242621AAEFB160F4F03053O00C19E363D7B025O000CA040025O00D7B240025O0028894000A3042O0012283O00014O0074000100023O0026BF3O009A040100020004E03O009A0401002E8F00030004000100040004E03O00040001000E512O010004000100010004E03O00040001001228000200013O000E51010200F3000100020004E03O00F30001001228000300014O0074000400043O0026BF0003000D000100010004E03O000D0001001228000400013O00260C01040014000100050004E03O00140001002EE800070016000100060004E03O00160001001228000200053O0004E03O00F30001000E510102007A000100040004E03O007A0001001228000500013O0026BF00050073000100010004E03O007300012O006A01066O0070000700013O00122O000800083O00122O000900096O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006003600013O0004E03O003600012O006A010600023O00205800060006000B4O00085O00202O00080008000C4O00060008000200262O000600360001000D0004E03O003600012O006A01066O00A4000700013O00122O0008000E3O00122O0009000F6O0007000900024O00060006000700202O0006000600104O00060002000200062O00060038000100010004E03O00380001002E8F00120052000100110004E03O00520001002EA70113001A000100130004E03O005200012O006A010600033O00200E0106000600144O00075O00202O0007000700154O000800046O000900013O00122O000A00163O00122O000B00176O0009000B00024O000A00056O000B000B6O000C00063O00202O000C000C001800122O000E00196O000C000E00024O000C000C6O0006000C000200062O0006005200013O0004E03O005200012O006A010600013O0012280007001A3O0012280008001B4O0049010600084O001000066O006A01066O0070000700013O00122O0008001C3O00122O0009001D6O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006007200013O0004E03O007200012O006A010600073O000E2E01190072000100060004E03O00720001002E8F001E00720001001F0004E03O007200012O006A010600084O001C01075O00202O0007000700204O000800096O000A00063O00202O000A000A001800122O000C00196O000A000C00024O000A000A6O0006000A000200062O0006007200013O0004E03O007200012O006A010600013O001228000700213O001228000800224O0049010600084O001000065O001228000500023O00260C01050077000100020004E03O00770001002E8F00230019000100240004E03O00190001001228000400053O0004E03O007A00010004E03O00190001002E8F00260010000100250004E03O001000010026BF00040010000100010004E03O00100001001228000500013O000E5101020083000100050004E03O00830001001228000400023O0004E03O00100001002EE80028007F000100270004E03O007F00010026BF0005007F000100010004E03O007F0001002EE8002A00B5000100290004E03O00B500012O006A01066O0070000700013O00122O0008002B3O00122O0009002C6O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600B500013O0004E03O00B500012O006A010600023O00206401060006002D4O00085O00202O00080008002E4O00060008000200062O000600B500013O0004E03O00B500012O006A010600094O006A01075O0020D400070007002F2O00300106000200020006A3000600B500013O0004E03O00B500012O006A0106000A4O00B10006000100020006A3000600B500013O0004E03O00B500012O006A010600084O001C01075O00202O00070007002F4O000800096O000A00063O00202O000A000A001800122O000C00306O000A000C00024O000A000A6O0006000A000200062O000600B500013O0004E03O00B500012O006A010600013O001228000700313O001228000800324O0049010600084O001000066O006A01066O0070000700013O00122O000800333O00122O000900346O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600EE00013O0004E03O00EE00012O006A010600023O00206401060006002D4O00085O00202O00080008002E4O00060008000200062O000600EE00013O0004E03O00EE00012O006A010600023O00206401060006002D4O00085O00202O0008000800354O00060008000200062O000600EE00013O0004E03O00EE00012O006A010600023O0020A101060006003600122O000800373O00122O000900056O00060009000200062O000600EE00013O0004E03O00EE00012O006A010600033O00208C0006000600144O00075O00202O0007000700384O000800046O000900013O00122O000A00393O00122O000B003A6O0009000B00024O000A00056O000B000B6O000C00063O00202O000C000C001800122O000E00196O000C000E00024O000C000C6O0006000C000200062O000600E9000100010004E03O00E90001002EE8003B00EE0001003C0004E03O00EE00012O006A010600013O0012280007003D3O0012280008003E4O0049010600084O001000065O001228000500023O0004E03O007F00010004E03O001000010004E03O00F300010004E03O000D00010026BF000200FD2O01000D0004E03O00FD2O01001228000300013O0026BF000300FA000100050004E03O00FA00010012280002003F3O0004E03O00FD2O010026BF0003005B2O0100020004E03O005B2O01002EE8004000342O0100410004E03O00342O012O006A01046O0070000500013O00122O000600423O00122O000700436O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400342O013O0004E03O00342O012O006A010400094O006A01055O0020D400050005002F2O00300104000200020006A3000400342O013O0004E03O00342O012O006A01046O0083010500013O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400464O000400020002000E2O000D001D2O0100040004E03O001D2O012O006A010400023O0020140104000400472O0030010400020002000E3A013F00342O0100040004E03O00342O012O006A0104000A4O00B10004000100020006A3000400342O013O0004E03O00342O01002EA701480013000100480004E03O00342O012O006A010400084O001C01055O00202O00050005002F4O000600076O000800063O00202O00080008001800122O000A00306O0008000A00024O000800086O00040008000200062O000400342O013O0004E03O00342O012O006A010400013O001228000500493O0012280006004A4O0049010400064O001000046O006A01046O0070000500013O00122O0006004B3O00122O0007004C6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400452O013O0004E03O00452O012O006A010400023O00208F01040004004D4O00065O00202O00060006004E4O00040006000200062O000400472O0100010004E03O00472O01002EE80050005A2O01004F0004E03O005A2O012O006A010400084O003400055O00202O0005000500514O000600076O000800063O00202O00080008001800122O000A00306O0008000A00024O000800086O00040008000200062O000400552O0100010004E03O00552O01002E8F0053005A2O0100520004E03O005A2O012O006A010400013O001228000500543O001228000600554O0049010400064O001000045O001228000300053O0026BF000300F6000100010004E03O00F60001001228000400013O00260C010400622O0100010004E03O00622O01002EE8005700F72O0100560004E03O00F72O012O006A01056O0070000600013O00122O000700583O00122O000800596O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500912O013O0004E03O00912O012O006A010500094O006A01065O0020D400060006002F2O00300105000200020006A3000500912O013O0004E03O00912O012O006A01056O0083010600013O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O0005000500464O000500020002000E2O000D00812O0100050004E03O00812O012O006A010500023O0020140105000500472O0030010500020002000E3A010500912O0100050004E03O00912O012O006A0105000A4O00B10005000100020006A3000500912O013O0004E03O00912O012O006A010500023O00201401050005005C2O0030010500020002000682010500932O0100010004E03O00932O012O006A010500023O00208F01050005002D4O00075O00202O00070007005D4O00050007000200062O000500932O0100010004E03O00932O01002E8F005F00A42O01005E0004E03O00A42O012O006A010500084O001C01065O00202O00060006002F4O000700086O000900063O00202O00090009001800122O000B00306O0009000B00024O000900096O00050009000200062O000500A42O013O0004E03O00A42O012O006A010500013O001228000600603O001228000700614O0049010500074O001000055O002E8F006200F62O0100630004E03O00F62O012O006A01056O0070000600013O00122O000700643O00122O000800656O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500F62O013O0004E03O00F62O012O006A01056O0070000600013O00122O000700663O00122O000800676O0006000800024O00050005000600202O0005000500104O00050002000200062O000500F62O013O0004E03O00F62O012O006A010500094O006A01065O0020D40006000600152O00300105000200020006A3000500F62O013O0004E03O00F62O012O006A010500023O0020A101050005003600122O000700373O00122O000800056O00050008000200062O000500F62O013O0004E03O00F62O012O006A010500023O00206401050005004D4O00075O00202O00070007002E4O00050007000200062O000500F62O013O0004E03O00F62O012O006A010500073O002650010500DB2O0100680004E03O00DB2O012O006A01056O0070000600013O00122O000700693O00122O0008006A6O0006000800024O00050005000600202O0005000500104O00050002000200062O000500DE2O013O0004E03O00DE2O012O006A010500073O002650010500F62O0100300004E03O00F62O012O006A010500033O00200E0105000500144O00065O00202O0006000600154O000700046O000800013O00122O0009006B3O00122O000A006C6O0008000A00024O000900056O000A000A6O000B00063O00202O000B000B001800122O000D00196O000B000D00024O000B000B6O0005000B000200062O000500F62O013O0004E03O00F62O012O006A010500013O0012280006006D3O0012280007006E4O0049010500074O001000055O001228000400023O0026BF0004005E2O0100020004E03O005E2O01001228000300023O0004E03O00F600010004E03O005E2O010004E03O00F600010026BF000200B9020100010004E03O00B90201001228000300013O002EA7016F00610001006F0004E03O006102010026BF00030061020100010004E03O006102012O006A01046O0070000500013O00122O000600703O00122O000700716O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004001F02013O0004E03O001F02012O006A010400094O006A01055O0020D400050005002F2O00300104000200020006A30004001F02013O0004E03O001F02012O006A010400023O00206401040004002D4O00065O00202O0006000600724O00040006000200062O0004001F02013O0004E03O001F02012O006A0104000A4O00B100040001000200068201040021020100010004E03O00210201002E8F00730032020100740004E03O003202012O006A010400084O001C01055O00202O00050005002F4O000600076O000800063O00202O00080008001800122O000A00306O0008000A00024O000800086O00040008000200062O0004003202013O0004E03O003202012O006A010400013O001228000500753O001228000600764O0049010400064O001000045O002EE800780060020100770004E03O006002012O006A01046O0070000500013O00122O000600793O00122O0007007A6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004006002013O0004E03O006002012O006A01046O0070000500013O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O0004000400104O00040002000200062O0004006002013O0004E03O006002012O006A010400033O00200E0104000400144O00055O00202O00050005007D4O000600046O000700013O00122O0008007E3O00122O0009007F6O0007000900024O0008000B6O000900096O000A00063O00202O000A000A001800122O000C00196O000A000C00024O000A000A6O0004000A000200062O0004006002013O0004E03O006002012O006A010400013O001228000500803O001228000600814O0049010400064O001000045O001228000300023O0026BF00030065020100050004E03O00650201001228000200023O0004E03O00B902010026BF00032O00020100020004E04O000201001228000400013O0026BF0004006C020100020004E03O006C0201001228000300053O0004E04O000201000E912O010070020100040004E03O00700201002E8F00830068020100820004E03O00680201002E8F00840090020100850004E03O009002012O006A01056O0070000600013O00122O000700863O00122O000800876O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009002013O0004E03O009002012O006A010500073O000E3A01300090020100050004E03O009002012O006A010500084O001C01065O00202O0006000600204O000700086O000900063O00202O00090009001800122O000B00196O0009000B00024O000900096O00050009000200062O0005009002013O0004E03O009002012O006A010500013O001228000600883O001228000700894O0049010500074O001000056O006A01056O00A4000600013O00122O0007008A3O00122O0008008B6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009C020100010004E03O009C0201002EE8008D00B60201008C0004E03O00B60201002EE8008F00B60201008E0004E03O00B602012O006A010500033O00200E0105000500144O00065O00202O0006000600904O000700046O000800013O00122O000900913O00122O000A00926O0008000A00024O0009000B6O000A000A6O000B00063O00202O000B000B001800122O000D00306O000B000D00024O000B000B6O0005000B000200062O000500B602013O0004E03O00B602012O006A010500013O001228000600933O001228000700944O0049010500074O001000055O001228000400023O0004E03O006802010004E04O00020100260C010200BD0201003F0004E03O00BD0201002E8F00950071030100960004E03O00710301002E8F009800EA020100970004E03O00EA02012O006A01036O0070000400013O00122O000500993O00122O0006009A6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300EA02013O0004E03O00EA02012O006A010300023O00205800030003000B4O00055O00202O00050005000C4O00030005000200262O000300EA0201000D0004E03O00EA02012O006A010300033O00208C0003000300144O00045O00202O0004000400154O000500046O000600013O00122O0007009B3O00122O0008009C6O0006000800024O000700056O000800086O000900063O00202O00090009001800122O000B00196O0009000B00024O000900096O00030009000200062O000300E5020100010004E03O00E50201002EE8009E00EA0201009D0004E03O00EA02012O006A010300013O0012280004009F3O001228000500A04O0049010300054O001000036O006A01036O00A4000400013O00122O000500A13O00122O000600A26O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300F6020100010004E03O00F60201002EE800A4000E030100A30004E03O000E03012O006A010300033O00200E0103000300144O00045O00202O00040004007D4O000500046O000600013O00122O000700A53O00122O000800A66O0006000800024O0007000B6O000800086O000900063O00202O00090009001800122O000B00196O0009000B00024O000900096O00030009000200062O0003000E03013O0004E03O000E03012O006A010300013O001228000400A73O001228000500A84O0049010300054O001000036O006A01036O0070000400013O00122O000500A93O00122O000600AA6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004603013O0004E03O004603012O006A01036O0070000400013O00122O000500AB3O00122O000600AC6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003004603013O0004E03O004603012O006A010300094O006A01045O0020D40004000400152O00300103000200020006A30003004603013O0004E03O004603012O006A0103000A4O00B100030001000200068201030046030100010004E03O004603012O006A010300033O00208C0003000300144O00045O00202O0004000400154O000500046O000600013O00122O000700AD3O00122O000800AE6O0006000800024O000700056O000800086O000900063O00202O00090009001800122O000B00196O0009000B00024O000900096O00030009000200062O00030041030100010004E03O00410301002EA701AF0007000100B00004E03O004603012O006A010300013O001228000400B13O001228000500B24O0049010300054O001000036O006A01036O0070000400013O00122O000500B33O00122O000600B46O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003005D03013O0004E03O005D03012O006A010300023O0020140103000300B52O0030010300020002000E2E01020058030100030004E03O005803012O006A010300073O00260C0103005F030100020004E03O005F03012O006A010300023O0020140103000300B52O0030010300020002000E7C0005005F030100030004E03O005F0301002EA701B600452O0100B70004E03O00A204012O006A0103000C4O00D300045O00202O0004000400B84O000500063O00202O0005000500B900122O000700BA6O0005000700024O000500056O000600016O00030006000200062O000300A204013O0004E03O00A204012O006A010300013O00121F010400BB3O00122O000500BC6O000300056O00035O00044O00A204010026BF00020009000100050004E03O00090001001228000300014O0074000400043O0026BF00030075030100010004E03O00750301001228000400013O00260C0104007C030100050004E03O007C0301002EE800BE007E030100BD0004E03O007E03010012280002000D3O0004E03O00090001002E8F00BF0024040100C00004E03O00240401000E512O010024040100040004E03O00240401001228000500013O002EE800C2001F040100C10004E03O001F04010026BF0005001F040100010004E03O001F0401002E8F00C300D9030100C40004E03O00D903012O006A01066O0070000700013O00122O000800C53O00122O000900C66O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600D903013O0004E03O00D903012O006A010600023O0020B800060006003600122O000800373O00122O000900056O00060009000200062O000600BF030100010004E03O00BF03012O006A01066O0070000700013O00122O000800C73O00122O000900C86O0007000900024O00060006000700202O0006000600104O00060002000200062O000600D903013O0004E03O00D903012O006A01066O0054010700013O00122O000800C93O00122O000900CA6O0007000900024O00060006000700202O0006000600464O00060002000200262O000600D90301000D0004E03O00D903012O006A01066O0012000700013O00122O000800CB3O00122O000900CC6O0007000900024O00060006000700202O0006000600464O000600020002000E2O000D00D9030100060004E03O00D903012O006A010600023O00206401060006004D4O00085O00202O0008000800CD4O00060008000200062O000600D903013O0004E03O00D903012O006A010600033O00208C0006000600144O00075O00202O0007000700384O000800046O000900013O00122O000A00CE3O00122O000B00CF6O0009000B00024O000A00056O000B000B6O000C00063O00202O000C000C001800122O000E00196O000C000E00024O000C000C6O0006000C000200062O000600D4030100010004E03O00D40301002E8F00D100D9030100D00004E03O00D903012O006A010600013O001228000700D23O001228000800D34O0049010600084O001000066O006A01066O0070000700013O00122O000800D43O00122O000900D56O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006001E04013O0004E03O001E04012O006A010600023O0020140106000600472O00300106000200020026BF000600FC030100020004E03O00FC03012O006A01066O00A4000700013O00122O000800D63O00122O000900D76O0007000900024O00060006000700202O0006000600D84O00060002000200062O0006000B040100010004E03O000B04012O006A01066O00A4000700013O00122O000800D93O00122O000900DA6O0007000900024O00060006000700202O0006000600D84O00060002000200062O0006000B040100010004E03O000B04012O006A010600023O0020140106000600472O00300106000200020026BF0006001E040100050004E03O001E04012O006A01066O0070000700013O00122O000800DB3O00122O000900DC6O0007000900024O00060006000700202O0006000600D84O00060002000200062O0006001E04013O0004E03O001E04012O006A010600084O003400075O00202O0007000700DD4O000800096O000A00063O00202O000A000A001800122O000C00306O000A000C00024O000A000A6O0006000A000200062O00060019040100010004E03O00190401002EA701DE0007000100DF0004E03O001E04012O006A010600013O001228000700E03O001228000800E14O0049010600084O001000065O001228000500023O0026BF00050083030100020004E03O00830301001228000400023O0004E03O002404010004E03O0083030100260C01040028040100020004E03O00280401002EA701E20052FF2O00E30004E03O00780301001228000500013O000E512O01008C040100050004E03O008C04012O006A01066O0070000700013O00122O000800E43O00122O000900E56O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006005D04013O0004E03O005D04012O006A010600094O006A01075O0020D400070007002F2O00300106000200020006A30006005D04013O0004E03O005D04012O006A01066O0054010700013O00122O000800E63O00122O000900E76O0007000900024O00060006000700202O0006000600464O00060002000200262O0006005D040100190004E03O005D04012O006A010600023O0020D600060006000B4O00085O00202O0008000800E84O000600080002000E2O00E9005D040100060004E03O005D04012O006A010600084O001C01075O00202O00070007002F4O000800096O000A00063O00202O000A000A001800122O000C00306O000A000C00024O000A000A6O0006000A000200062O0006005D04013O0004E03O005D04012O006A010600013O001228000700EA3O001228000800EB4O0049010600084O001000065O002E8F00EC008B040100ED0004E03O008B04012O006A01066O0070000700013O00122O000800EE3O00122O000900EF6O0007000900024O00060006000700202O0006000600F04O00060002000200062O0006008B04013O0004E03O008B04012O006A010600023O0020140106000600472O00300106000200020026500106008B040100190004E03O008B04012O006A010600023O00201401060006005C2O003001060002000200068201060078040100010004E03O007804012O006A010600023O0020140106000600F12O00300106000200020026500106008B040100F20004E03O008B0401002EA701F30013000100F30004E03O008B04012O006A0106000C4O00D300075O00202O0007000700B84O000800063O00202O0008000800B900122O000A00BA6O0008000A00024O000800086O000900016O00060009000200062O0006008B04013O0004E03O008B04012O006A010600013O001228000700F43O001228000800F54O0049010600084O001000065O001228000500023O002EA701F6009DFF2O00F60004E03O00290401000E5101020029040100050004E03O00290401001228000400053O0004E03O007803010004E03O002904010004E03O007803010004E03O000900010004E03O007503010004E03O000900010004E03O00A204010004E03O000400010004E03O00A20401002E8F00F80002000100F70004E03O00020001000E512O01000200013O0004E03O00020001001228000100014O0074000200023O0012283O00023O0004E03O000200012O003C012O00017O00DE3O00028O00025O00B0A040025O000AA440026O00F03F025O00349040025O00707D40025O00A6AB40025O0004B240026O000840025O004CA140025O0034A240025O00E89940025O00DEAC40025O00F8B140025O0026A34003113O0026A22C3CB4431C12913733B44F391CB12E03073O007275D24552DA2A03073O004973526561647903113O005370692O6E696E674372616E654B69636B030B3O0062DF4B67BF4BD07E66BE5D03053O00CC24B63813030F3O00432O6F6C646F776E52656D61696E7303093O0042752O66537461636B030D3O00436869456E6572677942752O66026O002440030E3O004973496E4D656C2O6552616E6765026O00204003213O00FA5BD58D73311CEE74DF917C3617D640D580767816EC4DDD96712C2DBD5F9CD12D03073O0072892BBCE31D58030C3O00C611A913EF12BD04CF14AB1B03043O0070847DC8030C3O00426C61636B6F75744B69636B03073O0048617354696572026O003E40027O0040030C3O004361737454617267657449662O033O00F0B1FD03063O00959DD893133A026O001440031B3O00CB8A19CBC2890DDCF68D11CBC2C61CCDCF870DC4DDB94CDC89D44A03043O00A8A9E67803083O00DF858D35E99F972O03043O00779CEDE4030A3O0049734361737461626C652O033O00436869030B3O00426C2O6F646C757374557003063O00456E65726779026O004940025O00C4AF40025O00AAA540025O00F08C40025O00F4904003083O00436869427572737403093O004973496E52616E6765026O00444003173O00C0D90941C1C4126DD791047BC5D01572D7EE546A2O835403043O001EA3B160026O00104003113O00F6BBEFE5F0E4FBC288F4EAF0E8DECCA8ED03073O0095A5CB868B9E8D03063O0042752O66557003103O0044616E63656F664368696A6942752O66025O00C6B240025O0026A140025O00E6A140025O0012B34003203O0020BC49283DA54E210CAF52273DA97F2D3AAF4B6637A9462726A0541967B8007403043O004653CC20025O00D07F40025O00CEAA4003133O003D951989058404861A890EB7078F0F8C01930F03043O00E06EE16B030B3O00C07EC83F34C1D6F27FCE2503073O00A49416BD5150A4030B3O004973417661696C61626C65025O00E08F40025O00C8A24003133O00537472696B656F6674686557696E646C6F72642O033O00BF816F03073O0017D2E017D3472B03233O00BA9202BE5E2EE3FFAFB904BF5014CBF9A7821CB8472F9CF4AC8011A2593FE3A4BDC64403083O0090C9E670D7354BBC030B3O0073CC0AFEE5AA53E30CF8EF03063O00C535A5798A96030B3O0046697374736F66467572792O033O00E0DEC103043O00408DBFB9031A3O0005E3A3CEE4F6A905D5B6CFE5D0E607EFB6DBE2C5B23CBEA49AA103073O00C6638AD0BA97A9025O00209240025O00F08140025O00FEB240025O0046A740030D3O003FFC905703F2B04B03DE8A5D0603043O003E6D95E303103O00426F6E65647573744272657742752O6603113O005072652O73757265506F696E7442752O66025O001FB040025O00D3B040030D3O00526973696E6753756E4B69636B2O033O00FE818703053O006093E8E9B4031C3O003A310942833E172B0F45B232213B110B893C2E390F4799067C2C5A1303063O005948587A2BED03113O001FABAC381525B5A215092DB5A01D122FB003053O007B4CDBC556025O00407340025O0088904003213O004BC81C02E03656DF2A0FFC3E56DD2A07E73C53981109E83E4DD40133BA2B18894503063O005F38B8756C8E025O00C09B40025O0066A040025O00088240025O00C06640030D3O00C2CB35E5FEC515F9FEE92FEFFB03043O008C90A24603083O0042752O66446F776E030B3O00F6214A66FDDF2E7F67FCC903053O008EB0483912025O00688440025O005FB0402O033O00AB381E03043O0044C65170031D3O00A506A31D421A881CA51A7316BE0CBB544818B10EA5185822E31BF0451E03063O007DD76FD0742C025O006BB140025O00D0B040025O0006A940025O00908C40025O0030A940030C3O00254B4EF07353125364FA7B5703063O003C67272F9318031B3O005465616368696E67736F667468654D6F6E61737465727942752O6603123O00DF02F684D9E44CE312FE8ED1C75CE90BF39303073O002E8C6A97E0B6932O033O00E6247303043O00228B4D1D025O00408640025O004EA340031B3O00B2FC1C5722BFE5096B22B9F316142DB5F61C4125A4CF494069E1A403053O0049D0907D34025O0084B340025O0024B340030D3O0018E599C2C91760DE24C783C8CC03083O00AB4A8CEAABA770332O033O0022074203063O00CD4F6E2C3F91031D3O00B5562CC1BA0C9B0FB25100C3BD08AF5CA35A39C9A107B023F34B7F99E203083O007CC73F5FA8D46BC4025O008EAC40025O00A6B24003093O0023B0433FA8DF88E10B03083O009366C8335AC497E9030D3O0009F9FCC4B0E7082EFE2OC4BDEB03073O002O5B908FADDE80030A3O00432O6F6C646F776E557003133O0010B45E58A04B2CA65859AE792AAE485DA45C2703063O002E43C02C31CB030B3O0022DF3DB637AB0322C33CBB03073O006564B64EC244C403093O00457870656C4861726D025O00ECA440025O0030774003183O004D5020F0817470D45A4570F1884D79C0445C0FA1990B298D03083O00B52O285095ED2B18025O0040A34003113O0029305C873322DA1D034788332EFF13235E03073O00B47A4035E95D4B030B3O00F01E0029C518151BC3050A03043O005DB6777303213O00910FDA82B9F78C18EC8FA5FF8C1AEC87BEFD895FD789B1FF9713C7B3E3EAC24D8503063O009EE27FB3ECD703133O00C6C8C0C4FDC9C7D1D5D2C8D1FECEF9C3FFC3C103043O00B691A0A903133O00576869726C696E67447261676F6E50756E636803233O002E283904AB0637270F12B50E3E2F3E29B71A37233856A30A3F21251AB3306D347044FF03063O006F59405076C7025O001C9740025O002EAB40030C3O009DBB0F45B4B81B5294BE0D4D03043O0026DFD76E2O033O0053D20203053O00CB3EBB6CA5025O00BCAB40025O00589B40031B3O00FB78493D7AF1C5ED4B433772F590FD714E3F64F2C4C6205C7E22AE03073O00B09914285E119E026O001840030C3O00EFCEA858BDB9D8D68252B5BD03063O00D6ADA2C93BD6025O00EC9A40025O002CAC402O033O002E70A403063O00404319CA21B7031B3O00EBE270BF25DD56FDD17AB52DD903EDEB77BD3BDE57D6BA65FC7D8A03073O0023898E11DC4EB2025O008C9040025O00A07C40030F3O009A26A85BCCA6349152C1AD04B25DC103053O00A5C853DB3303133O0052757368696E674A61646557696E6442752O66025O0073B340025O00B0A840030F3O0052757368696E674A61646557696E64025O000CA840025O005EA840031F3O00D5FF6773D82OBBDBCDEB707EEEA2B5EAC3AA707ED7B4A9E8D3D5206F91E6EE03083O0084A78A141BB1D5DC03133O002OC1F14537F7DAE55834F7E2EA4238FEDAF14803053O005C92B5832C025O00B6AD40025O00C6B0402O033O0046FF5903083O00BD2B9E21E6DE207703243O004DD45F58835BFF4257B74AC8486E9F57CE495D874CC40D558D58C1585D9C61945911DB0A03053O00E83EA02D3103113O0047C3FCA2AF7DDDF28FB375DDF087A877D803053O00C114B395CC030B3O00F10892D6C40E87E4C2139803043O00A2B761E103213O003AD5EDF912EBAF2EFAE7E51DECA416CEEDF417A2A52CC3E5E210F69E7DD12OA44A03073O00C149A584977C82000A042O0012283O00014O0074000100023O00260C012O0006000100010004E03O00060001002EA701020005000100030004E03O00090001001228000100014O0074000200023O0012283O00043O000E910104000D00013O0004E03O000D0001002E8F00050002000100060004E03O0002000100260C2O010011000100010004E03O00110001002EA7010700FEFF2O00080004E03O000D0001001228000200013O00260C01020016000100090004E03O00160001002EA7010A00AC0001000B0004E03O00C00001001228000300014O0074000400043O000E512O010018000100030004E03O00180001001228000400013O002EE8000C008B0001000D0004E03O008B00010026BF0004008B000100010004E03O008B0001001228000500013O0026BF00050024000100040004E03O00240001001228000400043O0004E03O008B00010026BF00050020000100010004E03O00200001002EE8000F005A0001000E0004E03O005A00012O006A01066O0070000700013O00122O000800103O00122O000900116O0007000900024O00060006000700202O0006000600124O00060002000200062O0006005A00013O0004E03O005A00012O006A010600024O006A01075O0020D40007000700132O00300106000200020006A30006005A00013O0004E03O005A00012O006A01066O0012000700013O00122O000800143O00122O000900156O0007000900024O00060006000700202O0006000600164O000600020002000E2O0009005A000100060004E03O005A00012O006A010600033O0020D60006000600174O00085O00202O0008000800184O000600080002000E2O0019005A000100060004E03O005A00012O006A010600044O001C01075O00202O0007000700134O000800096O000A00053O00202O000A000A001A00122O000C001B6O000A000C00024O000A000A6O0006000A000200062O0006005A00013O0004E03O005A00012O006A010600013O0012280007001C3O0012280008001D4O0049010600084O001000066O006A01066O0070000700013O00122O0008001E3O00122O0009001F6O0007000900024O00060006000700202O0006000600124O00060002000200062O0006008900013O0004E03O008900012O006A010600024O006A01075O0020D40007000700202O00300106000200020006A30006008900013O0004E03O008900012O006A010600033O0020A101060006002100122O000800223O00122O000900236O00060009000200062O0006008900013O0004E03O008900012O006A010600063O00200E0106000600244O00075O00202O0007000700204O000800076O000900013O00122O000A00253O00122O000B00266O0009000B00024O000A00086O000B000B6O000C00053O00202O000C000C001A00122O000E00276O000C000E00024O000C000C6O0006000C000200062O0006008900013O0004E03O008900012O006A010600013O001228000700283O001228000800294O0049010600084O001000065O001228000500043O0004E03O002000010026BF0004001B000100040004E03O001B00012O006A01056O0070000600013O00122O0007002A3O00122O0008002B6O0006000800024O00050005000600202O00050005002C4O00050002000200062O000500A600013O0004E03O00A600012O006A010500033O00201401050005002D2O0030010500020002002650010500A6000100270004E03O00A600012O006A010500033O00201401050005002E2O0030010500020002000682010500A8000100010004E03O00A800012O006A010500033O00201401050005002F2O003001050002000200266A000500A8000100300004E03O00A80001002EE8003100BB000100320004E03O00BB0001002EE8003300BB000100340004E03O00BB00012O006A010500094O00D300065O00202O0006000600354O000700053O00202O00070007003600122O000900376O0007000900024O000700076O000800016O00050008000200062O000500BB00013O0004E03O00BB00012O006A010500013O001228000600383O001228000700394O0049010500074O001000055O0012280002003A3O0004E03O00C000010004E03O001B00010004E03O00C000010004E03O001800010026BF000200452O0100010004E03O00452O012O006A01036O0070000400013O00122O0005003B3O00122O0006003C6O0004000600024O00030003000400202O0003000300124O00030002000200062O000300DD00013O0004E03O00DD00012O006A010300024O006A01045O0020D40004000400132O00300103000200020006A3000300DD00013O0004E03O00DD00012O006A010300033O00206401030003003D4O00055O00202O00050005003E4O00030005000200062O000300DD00013O0004E03O00DD00012O006A0103000A4O00B1000300010002000682010300DF000100010004E03O00DF0001002EE8003F00F2000100400004E03O00F20001002EE8004100F2000100420004E03O00F200012O006A010300044O001C01045O00202O0004000400134O000500066O000700053O00202O00070007001A00122O0009001B6O0007000900024O000700076O00030007000200062O000300F200013O0004E03O00F200012O006A010300013O001228000400433O001228000500444O0049010300054O001000035O002EE8004500222O0100460004E03O00222O012O006A01036O0070000400013O00122O000500473O00122O000600486O0004000600024O00030003000400202O0003000300124O00030002000200062O000300222O013O0004E03O00222O012O006A01036O0070000400013O00122O000500493O00122O0006004A6O0004000600024O00030003000400202O00030003004B4O00030002000200062O000300222O013O0004E03O00222O01002E8F004C00222O01004D0004E03O00222O012O006A010300063O00200E0103000300244O00045O00202O00040004004E4O000500076O000600013O00122O0007004F3O00122O000800506O0006000800024O0007000B6O000800086O000900053O00202O00090009001A00122O000B00276O0009000B00024O000900096O00030009000200062O000300222O013O0004E03O00222O012O006A010300013O001228000400513O001228000500524O0049010300054O001000036O006A01036O0070000400013O00122O000500533O00122O000600546O0004000600024O00030003000400202O0003000300124O00030002000200062O000300442O013O0004E03O00442O012O006A010300063O00200E0103000300244O00045O00202O0004000400554O000500076O000600013O00122O000700563O00122O000800576O0006000800024O0007000B6O000800086O000900053O00202O00090009001A00122O000B001B6O0009000B00024O000900096O00030009000200062O000300442O013O0004E03O00442O012O006A010300013O001228000400583O001228000500594O0049010300054O001000035O001228000200043O002EE8005B00030201005A0004E03O000302010026BF00020003020100040004E03O00030201001228000300013O0026BF000300C02O0100010004E03O00C02O01001228000400013O002EE8005D00B92O01005C0004E03O00B92O010026BF000400B92O0100010004E03O00B92O012O006A01056O0070000600013O00122O0007005E3O00122O0008005F6O0006000800024O00050005000600202O0005000500124O00050002000200062O000500702O013O0004E03O00702O012O006A010500033O00206401050005003D4O00075O00202O0007000700604O00050007000200062O000500702O013O0004E03O00702O012O006A010500033O00206401050005003D4O00075O00202O0007000700614O00050007000200062O000500702O013O0004E03O00702O012O006A010500033O0020B800050005002100122O000700223O00122O000800236O00050008000200062O000500722O0100010004E03O00722O01002EE80063008A2O0100620004E03O008A2O012O006A010500063O00200E0105000500244O00065O00202O0006000600644O000700076O000800013O00122O000900653O00122O000A00666O0008000A00024O000900086O000A000A6O000B00053O00202O000B000B001A00122O000D00276O000B000D00024O000B000B6O0005000B000200062O0005008A2O013O0004E03O008A2O012O006A010500013O001228000600673O001228000700684O0049010500074O001000056O006A01056O0070000600013O00122O000700693O00122O0008006A6O0006000800024O00050005000600202O0005000500124O00050002000200062O000500B82O013O0004E03O00B82O012O006A010500033O00206401050005003D4O00075O00202O0007000700604O00050007000200062O000500B82O013O0004E03O00B82O012O006A010500024O006A01065O0020D40006000600132O00300105000200020006A3000500B82O013O0004E03O00B82O012O006A0105000A4O00B10005000100020006A3000500B82O013O0004E03O00B82O012O006A010500044O003400065O00202O0006000600134O000700086O000900053O00202O00090009001A00122O000B001B6O0009000B00024O000900096O00050009000200062O000500B32O0100010004E03O00B32O01002EE8006C00B82O01006B0004E03O00B82O012O006A010500013O0012280006006D3O0012280007006E4O0049010500074O001000055O001228000400043O002EE8006F004D2O0100700004E03O004D2O010026BF0004004D2O0100040004E03O004D2O01001228000300043O0004E03O00C02O010004E03O004D2O01002EE80072004A2O0100710004E03O004A2O010026BF0003004A2O0100040004E03O004A2O012O006A01046O0070000500013O00122O000600733O00122O000700746O0005000700024O00040004000500202O0004000400124O00040002000200062O000400E62O013O0004E03O00E62O012O006A010400033O0020640104000400754O00065O00202O0006000600604O00040006000200062O000400E62O013O0004E03O00E62O012O006A010400033O00206401040004003D4O00065O00202O0006000600614O00040006000200062O000400E62O013O0004E03O00E62O012O006A01046O0083010500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O0004000400164O000400020002000E2O002700E82O0100040004E03O00E82O01002EE800792O00020100780004E04O0002012O006A010400063O00200E0104000400244O00055O00202O0005000500644O000600076O000700013O00122O0008007A3O00122O0009007B6O0007000900024O000800086O000900096O000A00053O00202O000A000A001A00122O000C00276O000A000C00024O000A000A6O0004000A000200062O00042O0002013O0004E04O0002012O006A010400013O0012280005007C3O0012280006007D4O0049010400064O001000045O001228000200233O0004E03O000302010004E03O004A2O010026BF000200C1020100230004E03O00C10201001228000300014O0074000400043O00260C0103000B020100010004E03O000B0201002EA7017E00FEFF2O007F0004E03O00070201001228000400013O002EE800810073020100800004E03O007302010026BF00040073020100010004E03O00730201002EA701820037000100820004E03O004702012O006A01056O0070000600013O00122O000700833O00122O000800846O0006000800024O00050005000600202O0005000500124O00050002000200062O0005004702013O0004E03O004702012O006A010500033O0020580005000500174O00075O00202O0007000700854O00050007000200262O00050047020100090004E03O004702012O006A01056O0070000600013O00122O000700863O00122O000800876O0006000800024O00050005000600202O00050005004B4O00050002000200062O0005004702013O0004E03O004702012O006A010500063O00208C0005000500244O00065O00202O0006000600204O000700076O000800013O00122O000900883O00122O000A00896O0008000A00024O000900086O000A000A6O000B00053O00202O000B000B001A00122O000D00276O000B000D00024O000B000B6O0005000B000200062O00050042020100010004E03O00420201002E8F008B00470201008A0004E03O004702012O006A010500013O0012280006008C3O0012280007008D4O0049010500074O001000055O002EE8008F00720201008E0004E03O007202012O006A01056O0070000600013O00122O000700903O00122O000800916O0006000800024O00050005000600202O0005000500124O00050002000200062O0005007202013O0004E03O007202012O006A010500033O0020A101050005002100122O000700223O00122O000800236O00050008000200062O0005007202013O0004E03O007202012O006A010500063O00200E0105000500244O00065O00202O0006000600644O000700076O000800013O00122O000900923O00122O000A00936O0008000A00024O000900086O000A000A6O000B00053O00202O000B000B001A00122O000D00276O000B000D00024O000B000B6O0005000B000200062O0005007202013O0004E03O007202012O006A010500013O001228000600943O001228000700954O0049010500074O001000055O001228000400043O00260C01040077020100040004E03O00770201002E8F0097000C020100960004E03O000C02012O006A01056O0070000600013O00122O000700983O00122O000800996O0006000800024O00050005000600202O0005000500124O00050002000200062O000500BC02013O0004E03O00BC02012O006A010500033O00201401050005002D2O00300105000200020026BF0005009A020100040004E03O009A02012O006A01056O00A4000600013O00122O0007009A3O00122O0008009B6O0006000800024O00050005000600202O00050005009C4O00050002000200062O000500A9020100010004E03O00A902012O006A01056O00A4000600013O00122O0007009D3O00122O0008009E6O0006000800024O00050005000600202O00050005009C4O00050002000200062O000500A9020100010004E03O00A902012O006A010500033O00201401050005002D2O00300105000200020026BF000500BC020100230004E03O00BC02012O006A01056O0070000600013O00122O0007009F3O00122O000800A06O0006000800024O00050005000600202O00050005009C4O00050002000200062O000500BC02013O0004E03O00BC02012O006A010500044O003400065O00202O0006000600A14O000700086O000900053O00202O00090009001A00122O000B001B6O0009000B00024O000900096O00050009000200062O000500B7020100010004E03O00B70201002E8F00A200BC020100A30004E03O00BC02012O006A010500013O001228000600A43O001228000700A54O0049010500074O001000055O001228000200093O0004E03O00C102010004E03O000C02010004E03O00C102010004E03O00070201000E51013A0050030100020004E03O00500301001228000300014O0074000400043O002EA701A63O000100A60004E03O00C502010026BF000300C5020100010004E03O00C50201001228000400013O0026BF0004001C030100010004E03O001C03012O006A01056O0070000600013O00122O000700A73O00122O000800A86O0006000800024O00050005000600202O0005000500124O00050002000200062O00052O0003013O0004E04O0003012O006A010500024O006A01065O0020D40006000600132O00300105000200020006A300052O0003013O0004E04O0003012O006A01056O0083010600013O00122O000700A93O00122O000800AA6O0006000800024O00050005000600202O0005000500164O000500020002000E2O000900EB020100050004E03O00EB02012O006A010500033O00201401050005002D2O0030010500020002000E3A013A2O00030100050004E04O0003012O006A0105000A4O00B10005000100020006A300052O0003013O0004E04O0003012O006A010500044O001C01065O00202O0006000600134O000700086O000900053O00202O00090009001A00122O000B001B6O0009000B00024O000900096O00050009000200062O00052O0003013O0004E04O0003012O006A010500013O001228000600AB3O001228000700AC4O0049010500074O001000056O006A01056O0070000600013O00122O000700AD3O00122O000800AE6O0006000800024O00050005000600202O0005000500124O00050002000200062O0005001B03013O0004E03O001B03012O006A010500044O001C01065O00202O0006000600AF4O000700086O000900053O00202O00090009001A00122O000B00276O0009000B00024O000900096O00050009000200062O0005001B03013O0004E03O001B03012O006A010500013O001228000600B03O001228000700B14O0049010500074O001000055O001228000400043O002EE800B200CA020100B30004E03O00CA02010026BF000400CA020100040004E03O00CA02012O006A01056O0070000600013O00122O000700B43O00122O000800B56O0006000800024O00050005000600202O0005000500124O00050002000200062O0005004B03013O0004E03O004B03012O006A010500033O0020580005000500174O00075O00202O0007000700854O00050007000200262O0005004B030100090004E03O004B03012O006A010500063O00208C0005000500244O00065O00202O0006000600204O000700076O000800013O00122O000900B63O00122O000A00B76O0008000A00024O000900086O000A000A6O000B00053O00202O000B000B001A00122O000D00276O000B000D00024O000B000B6O0005000B000200062O00050046030100010004E03O00460301002E8F00B8004B030100B90004E03O004B03012O006A010500013O001228000600BA3O001228000700BB4O0049010500074O001000055O001228000200273O0004E03O005003010004E03O00CA02010004E03O005003010004E03O00C502010026BF0002007D030100BC0004E03O007D03012O006A01036O0070000400013O00122O000500BD3O00122O000600BE6O0004000600024O00030003000400202O0003000300124O00030002000200062O0003006203013O0004E03O006203012O006A010300024O006A01045O0020D40004000400202O003001030002000200068201030064030100010004E03O00640301002EE800C00009040100BF0004E03O000904012O006A010300063O00200E0103000300244O00045O00202O0004000400204O000500076O000600013O00122O000700C13O00122O000800C26O0006000800024O000700086O000800086O000900053O00202O00090009001A00122O000B00276O0009000B00024O000900096O00030009000200062O0003000904013O0004E03O000904012O006A010300013O00121F010400C33O00122O000500C46O000300056O00035O00044O000904010026BF00020012000100270004E03O00120001001228000300013O002EE800C600CF030100C50004E03O00CF03010026BF000300CF030100010004E03O00CF03012O006A01046O0070000500013O00122O000600C73O00122O000700C86O0005000700024O00040004000500202O0004000400124O00040002000200062O0004009503013O0004E03O009503012O006A010400033O00208F0104000400754O00065O00202O0006000600C94O00040006000200062O00040097030100010004E03O00970301002E8F00CA00AA030100CB0004E03O00AA03012O006A010400044O003400055O00202O0005000500CC4O000600076O000800053O00202O00080008001A00122O000A001B6O0008000A00024O000800086O00040008000200062O000400A5030100010004E03O00A50301002E8F00CE00AA030100CD0004E03O00AA03012O006A010400013O001228000500CF3O001228000600D04O0049010400064O001000046O006A01046O00A4000500013O00122O000600D13O00122O000700D26O0005000700024O00040004000500202O0004000400124O00040002000200062O000400B6030100010004E03O00B60301002E8F00D400CE030100D30004E03O00CE03012O006A010400063O00200E0104000400244O00055O00202O00050005004E4O000600076O000700013O00122O000800D53O00122O000900D66O0007000900024O0008000B6O000900096O000A00053O00202O000A000A001A00122O000C00276O000A000C00024O000A000A6O0004000A000200062O000400CE03013O0004E03O00CE03012O006A010400013O001228000500D73O001228000600D84O0049010400064O001000045O001228000300043O0026BF00030080030100040004E03O008003012O006A01046O0070000500013O00122O000600D93O00122O000700DA6O0005000700024O00040004000500202O0004000400124O00040002000200062O0004000104013O0004E03O000104012O006A010400024O006A01055O0020D40005000500132O00300104000200020006A30004000104013O0004E03O000104012O006A01046O0083010500013O00122O000600DB3O00122O000700DC6O0005000700024O00040004000500202O0004000400164O000400020002000E2O000900F0030100040004E03O00F003012O006A010400033O00201401040004002D2O0030010400020002000E3A013A0001040100040004E03O000104012O006A010400044O001C01055O00202O0005000500134O000600076O000800053O00202O00080008001A00122O000A001B6O0008000A00024O000800086O00040008000200062O0004000104013O0004E03O000104012O006A010400013O001228000500DD3O001228000600DE4O0049010400064O001000045O001228000200BC3O0004E03O001200010004E03O008003010004E03O001200010004E03O000904010004E03O000D00010004E03O000904010004E03O000200012O003C012O00017O0013012O00028O00026O00F03F025O004AB140025O007EAC40027O004003093O0085A564A03D08A1AF7903063O0040C0DD14C55103073O00497352656164792O033O00436869030D3O009DFFF1ABA9A8C5F7AC8CA6F5E903053O00C7CF9682C2030A3O00432O6F6C646F776E557003133O00865E69E148B0457DFC4BB07D72E647B94569EC03053O0023D52A1B88030B3O00868E28ABCBFDA6A12EADC103063O0092C0E75BDFB8025O00549A40025O00E2AD4003093O00457870656C4861726D030E3O004973496E4D656C2O6552616E6765026O00204003183O005FE9E62CDD8B2O0F48FCB62DD4B2061B56E5C97AC5F42O5603083O006E3A919649B1D467026O000840030D3O004FCA39482D384ED6246A2A3C7603063O005F1DA34A214303083O0042752O66446F776E03103O00426F6E65647573744272657742752O6603063O0042752O66557003113O005072652O73757265506F696E7442752O66025O0072AD40025O0006A640025O00ACB240025O002CA440030C3O00436173745461726765744966030D3O00526973696E6753756E4B69636B2O033O00713B4E03073O00641C5220571FEA026O001440031D3O00235BF378F5D1D72D245CDF7AF2D5E37E3557E670EEDAFC016246A020AF03083O005E513280119BB688030D3O00B935F730ECB32F928517ED3AE903083O00E7EB5C845982D47C03073O0048617354696572026O003E40025O00FC9140025O0036AE402O033O00F3BDFA03063O00259ED4945FB1031D3O006615B78E037323B792034B17AD84063418A1810C6110B0B85E605CF5D103053O006D147CC4E7025O00049A40026O007640026O004B40025O0052AE40025O004C9C40025O00F7B04003113O00999610FCA48F17F5899418FCAFAD10F1A103043O0092CAE67903113O005370692O6E696E674372616E654B69636B030D3O00DCE6FD17C9B5932BE0C4E71DCC03083O005E8E8F8E7EA7D2C0030C3O00432O6F6C646F776E446F776E030B3O0026CC0EF5D40FC33BF4D51903053O00A760A57D81026O00104003113O0034C219544F034A9A13DE37484600429A0203083O00E867B6762622462B030B3O004973417661696C61626C65030C3O00175821E6346426430DF1356603063O001155374F835003083O00FB80ABA931C191A003053O005FA8E5D9CC03213O00992B8F878432888EB5389488843EB98283388DC98E3E80889F3792B6D92FC6DADC03043O00E9EA5BE6026O001840030D3O00D449000474D1D6BBE86B1A0E7103083O00CE8620736D1AB685030B3O0010F1DC074E5230DEDA014403063O003D5698AF733D030F3O00432O6F6C646F776E52656D61696E73025O00A49340025O0056B1402O033O00A408D203083O00A7C961BC50B1E143031D3O005C0197A6F286711B91A1C38A470B8FEFF884480991A3E8BE1D1CC4FCA803063O00E12E68E4CF9C025O00389640025O00DCA140030C3O0088CCB24D3C5CA7AB81C9B04503083O00DFCAA0D32E5733D203093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66025O0060A640030C3O00426C61636B6F75744B69636B2O033O00DBE01403053O006DB6897A14031B3O0050A513F9EBD8FF686DA21BF9EB97EE7954A807F6F4E8B96812FA4203083O001C32C9729A80B78A025O00BEAD40025O0074AC40025O0054974003133O00D65804237F4B06CFC5420C367C4C38DDEF530503083O00A881306D51132268025O00A06B40025O0024B04003133O00576869726C696E67447261676F6E50756E6368025O00805140025O0088924003233O00601C0522D32CB5FE48101E31D82AB5C667010233D765BFFC7115193CCB1AE8ED37465A03083O009917746C50BF45DB03083O006A17F4FAED99655D03073O0016297F9DB898EB030A3O0049734361737461626C65030B3O00426C2O6F646C757374557003063O00456E65726779026O004940025O00F4A740025O00E0864003083O00436869427572737403093O004973496E52616E6765026O004440025O0094AD40025O00E0A54003173O0014CFE8F515D2F3D90387E5CF11C6F4C603F8B2DE5795B903043O00AA77A781025O00D07040025O003C9E4003113O00E9E0B57D8D57D4F79F618250DFDBB5708803063O003EBA90DC13E3030B3O0087F5FFC2B2F3EAF0B4EEF503043O00B6C19C8C030D3O00436869456E6572677942752O66026O002E40025O00249A40025O0024954003213O00D25C1FBCE836CF4B29B1F43ECF4929B9EF3CCA0C12B7E03ED440028DB52B811F4403063O005FA12C76D286025O00408B40025O0098804003133O00CF1B00CE428772DFE80717F0408C79D5F31D1603083O00B99C6F72A729E21D030B3O003F0D032EB0E619031F33A003063O00836B657640D403173O00E8D83A244CC5F1D4D3221F4FC5FEC9DF382E73C9CE2OC403073O00A9A1B64C4B27A0026O00344003133O00537472696B656F6674686557696E646C6F72642O033O00D453AF03073O00C8B932D7EB7B4203233O00E195CBEB817325FD87E6F6827325E588D7E6867908F6C1DDE78C770FFE95E6B19E364C03073O007A92E1B982EA16025O00188F40025O00D49B40025O001AAC40025O0043B040030C3O000F422402264130150647260A03043O00614D2E4503123O00ECD701A1D0C802AAC7D60EA2EBCD05A4DBCC03043O00C52OBF60026O005F40025O00CC9D402O033O00C720E303073O002DAA498D2E3888031A3O008303CCE6A488129530C6ECAC8C47850ACBE4BA8B13BE5CD9A5FD03073O0067E16FAD85CFE703113O007F94FC5B428DFB526F96F45B49AFFC564703043O00352CE49503103O0044616E63656F664368696A6942752O6603203O00DECB320BC52DC3DC0406D925C3DE040EC227C69B3F00CD25D8D72F3A98308D8F03063O0044ADBB5B65AB025O004C9940025O00F4A440025O005EAB40025O00B09440025O00488140025O005C9840030C3O00D638CBF140C4FCE01FC3F14003073O00899454AA922BAB2O033O000CD67103053O001761BF1F9D025O00B1B040025O00B88E40031B3O00848E2O06D63D9396380ED4318DC20300DB33938E133A8E26C6D05703063O0052E6E26765BD03133O00B83EA1B81F8E25B5A51C8E1DBABF108725A1B503053O0074EB4AD3D12O033O00253DC603043O0045485CBE03243O00252FF6DDA0AD29B83004F0DCAE9701BE383FE8DBB9AC56B3333DE5C1A7BC29E4227BB68603083O00D7565B84B4CBC876025O00307340025O00EAA640030C3O0011E287D038E193C718E785D803043O00B3538EE603123O00E927FC313608F5D0C226F3322O0DF22ODE3C03083O00BFBA4F9D55597F97030D3O00C473B7C78A42C56FAAE58D46FD03063O0025961AC4AEE42O033O00C4F9BC03063O00E9A990D23557031B3O00204AECDF2949F8C81D4DE4DF2906E9D92447F8D03679BEC86214B903043O00BC42268D025O00CBB140030B3O009FEBD3DBFCB4BFC4D5DDF603063O00DBD982A0AF8F030B3O0046697374736F66467572792O033O0033BD5A03043O005D5EDC22031A3O0009C1D29EC9C8F209F7C79FC8EEBD0BCDC78BCFFBE9309BD5CA8203073O009D6FA8A1EABA97030D3O002O496638CCBE8190756B7C32C903083O00E51B201551A2D9D22O033O0021C5F503053O002A4CAC9B5A031D3O00E08492200EF5B2923C0ECD86882A0BB289842F01E781951653E6CDD07903053O006092EDE14903113O00DB6E01E64773ACEF5D1AE9477F89E17D2O03073O00C2881E6888291A025O004AAD4003213O00CFC60A461AB9A728E3D511491AB596242OD52O0810B5AF2EC9DA177747A4E97E8E03083O004FBCB6632874D0C9026O001C40025O00608A40025O00F09B4003113O00373378C417AC39030063CB17A01C0D207A03073O0057644311AA79C503113O00DD9FB5925A90EF99AE8876BBEAADB3925203063O00D58EEBDAE03703083O003BA7EBC006ABEDDC03043O00A568C299025O00C2A140025O0053B14003213O009420D0A5F75483800FDAB9F85388B83BD0A8F21D898236D8BEF549B2D42499FFAD03073O00EDE750B9CB993D025O00D8AB40025O0014A040025O00F0AB40025O006AA040025O009DB240025O0020A040025O00689F40025O00A08540030C3O00734D8370AC5E549658AE524A03053O00C73121E213030B3O007452500BD42O5D650AD54B03053O00A7323B237F026O007840025O002CA1402O033O00451A5C03053O00C82873328C025O0033B240025O0052AB40031B3O00F121761CF822620BCC267E1CF86D731AF52C6213E712240BB37E2F03043O007F934D17030F3O00B9F3E67C7985E1DF75748ED1FC7A7403053O0010EB86951403133O0052757368696E674A61646557696E6442752O66030F3O0052757368696E674A61646557696E64025O0012B240025O0082A340031F3O00C85E5DAE05890BE5414FA209B81BD3454AE608820ADB5E42B233D4189A1F1E03073O006CBA2B2EC66CE7025O00B8B040025O0016A940030C3O0010B3F402773DAAE12A7531B403053O001C52DF956103123O009E3D4C5AA2224F51B53C43599927485FA92603043O003ECD552D2O033O007805AF03073O0069156CC1C962E9031B3O0042891AFDC831CF54BA10F7C0359A44801DFFD632CE7FD60FBE976C03073O00BA20E57B9EA35E025O00E06B40025O000AAD40000B052O0012283O00014O0074000100023O00260C012O0006000100020004E03O00060001002EE8000300FF040100040004E03O00FF04010026BF00010006000100010004E03O00060001001228000200013O000E51010500B8000100020004E03O00B80001001228000300013O000E5101020055000100030004E03O005500012O006A01046O0070000500013O00122O000600063O00122O000700076O0005000700024O00040004000500202O0004000400084O00040002000200062O0004004000013O0004E03O004000012O006A010400023O0020140104000400092O00300104000200020026BF00040031000100020004E03O003100012O006A01046O00A4000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040042000100010004E03O004200012O006A01046O00A4000500013O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040042000100010004E03O004200012O006A010400023O0020140104000400092O00300104000200020026BF00040040000100050004E03O004000012O006A01046O00A4000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040042000100010004E03O00420001002EE800120053000100110004E03O005300012O006A010400034O001C01055O00202O0005000500134O000600076O000800043O00202O00080008001400122O000A00156O0008000A00024O000800086O00040008000200062O0004005300013O0004E03O005300012O006A010400013O001228000500163O001228000600174O0049010400064O001000045O001228000200183O0004E03O00B80001000E512O01000C000100030004E03O000C00012O006A01046O0070000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004006F00013O0004E03O006F00012O006A010400023O00206401040004001B4O00065O00202O00060006001C4O00040006000200062O0004006F00013O0004E03O006F00012O006A010400023O00208F01040004001D4O00065O00202O00060006001E4O00040006000200062O00040071000100010004E03O00710001002EE8001F008B000100200004E03O008B0001002E8F0022008B000100210004E03O008B00012O006A010400053O00200E0104000400234O00055O00202O0005000500244O000600066O000700013O00122O000800253O00122O000900266O0007000900024O000800076O000900096O000A00043O00202O000A000A001400122O000C00276O000A000C00024O000A000A6O0004000A000200062O0004008B00013O0004E03O008B00012O006A010400013O001228000500283O001228000600294O0049010400064O001000046O006A01046O0070000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004009C00013O0004E03O009C00012O006A010400023O0020B800040004002C00122O0006002D3O00122O000700056O00040007000200062O0004009E000100010004E03O009E0001002EA7012E001A0001002F0004E03O00B600012O006A010400053O00200E0104000400234O00055O00202O0005000500244O000600066O000700013O00122O000800303O00122O000900316O0007000900024O000800076O000900096O000A00043O00202O000A000A001400122O000C00276O000A000C00024O000A000A6O0004000A000200062O000400B600013O0004E03O00B600012O006A010400013O001228000500323O001228000600334O0049010400064O001000045O001228000300023O0004E03O000C000100260C010200BC000100270004E03O00BC0001002EE8003400812O0100350004E03O00812O01001228000300013O000E91010200C1000100030004E03O00C10001002E8F0037001D2O0100360004E03O001D2O01002EE80038001B2O0100390004E03O001B2O012O006A01046O0070000500013O00122O0006003A3O00122O0007003B6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004001B2O013O0004E03O001B2O012O006A010400084O006A01055O0020D400050005003C2O00300104000200020006A30004001B2O013O0004E03O001B2O012O006A01046O0070000500013O00122O0006003D3O00122O0007003E6O0005000700024O00040004000500202O00040004003F4O00040002000200062O0004001B2O013O0004E03O001B2O012O006A01046O0070000500013O00122O000600403O00122O000700416O0005000700024O00040004000500202O00040004003F4O00040002000200062O0004001B2O013O0004E03O001B2O012O006A010400023O0020140104000400092O0030010400020002000E3A0142001B2O0100040004E03O001B2O012O006A01046O0070000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400454O00040002000200062O00042O002O013O0004E04O002O012O006A01046O0070000500013O00122O000600463O00122O000700476O0005000700024O00040004000500202O0004000400454O00040002000200062O0004000A2O013O0004E03O000A2O012O006A01046O0070000500013O00122O000600483O00122O000700496O0005000700024O00040004000500202O0004000400454O00040002000200062O0004001B2O013O0004E03O001B2O012O006A010400034O001C01055O00202O00050005003C4O000600076O000800043O00202O00080008001400122O000A00156O0008000A00024O000800086O00040008000200062O0004001B2O013O0004E03O001B2O012O006A010400013O0012280005004A3O0012280006004B4O0049010400064O001000045O0012280002004C3O0004E03O00812O01000E512O0100BD000100030004E03O00BD00012O006A01046O0070000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O0004000400084O00040002000200062O000400382O013O0004E03O00382O012O006A01046O0012000500013O00122O0006004F3O00122O000700506O0005000700024O00040004000500202O0004000400514O000400020002000E2O004200382O0100040004E03O00382O012O006A010400023O0020140104000400092O0030010400020002000E5E0118003A2O0100040004E03O003A2O01002EA70152001A000100530004E03O00522O012O006A010400053O00200E0104000400234O00055O00202O0005000500244O000600066O000700013O00122O000800543O00122O000900556O0007000900024O000800076O000900096O000A00043O00202O000A000A001400122O000C00276O000A000C00024O000A000A6O0004000A000200062O000400522O013O0004E03O00522O012O006A010400013O001228000500563O001228000600574O0049010400064O001000045O002EE80058007F2O0100590004E03O007F2O012O006A01046O0070000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004007F2O013O0004E03O007F2O012O006A010400023O00205800040004005C4O00065O00202O00060006005D4O00040006000200262O0004007F2O0100180004E03O007F2O01002EA7015E001A0001005E0004E03O007F2O012O006A010400053O00200E0104000400234O00055O00202O00050005005F4O000600066O000700013O00122O000800603O00122O000900616O0007000900024O000800076O000900096O000A00043O00202O000A000A001400122O000C00276O000A000C00024O000A000A6O0004000A000200062O0004007F2O013O0004E03O007F2O012O006A010400013O001228000500623O001228000600634O0049010400064O001000045O001228000300023O0004E03O00BD0001002E8F00650021020100640004E03O002102010026BF00020021020100420004E03O00210201001228000300014O0074000400043O0026BF000300872O0100010004E03O00872O01001228000400013O0026BF000400E62O0100010004E03O00E62O01001228000500013O002EA701660052000100660004E03O00DF2O010026BF000500DF2O0100010004E03O00DF2O012O006A01066O00A4000700013O00122O000800673O00122O000900686O0007000900024O00060006000700202O0006000600084O00060002000200062O0006009D2O0100010004E03O009D2O01002E8F006A00B02O0100690004E03O00B02O012O006A010600034O003400075O00202O00070007006B4O000800096O000A00043O00202O000A000A001400122O000C00276O000A000C00024O000A000A6O0006000A000200062O000600AB2O0100010004E03O00AB2O01002EE8006D00B02O01006C0004E03O00B02O012O006A010600013O0012280007006E3O0012280008006F4O0049010600084O001000066O006A01066O0070000700013O00122O000800703O00122O000900716O0007000900024O00060006000700202O0006000600724O00060002000200062O000600C92O013O0004E03O00C92O012O006A010600023O0020140106000600092O0030010600020002002650010600C92O0100270004E03O00C92O012O006A010600023O0020140106000600732O0030010600020002000682010600CB2O0100010004E03O00CB2O012O006A010600023O0020140106000600742O003001060002000200266A000600CB2O0100750004E03O00CB2O01002EE8007600DE2O0100770004E03O00DE2O012O006A010600094O00C000075O00202O0007000700784O000800043O00202O00080008007900122O000A007A6O0008000A00024O000800086O000900016O00060009000200062O000600D92O0100010004E03O00D92O01002E8F007B00DE2O01007C0004E03O00DE2O012O006A010600013O0012280007007D3O0012280008007E4O0049010600084O001000065O001228000500023O002E8F007F008D2O0100800004E03O008D2O010026BF0005008D2O0100020004E03O008D2O01001228000400023O0004E03O00E62O010004E03O008D2O010026BF0004008A2O0100020004E03O008A2O012O006A01056O0070000600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O0005000500084O00050002000200062O0005001C02013O0004E03O001C02012O006A010500084O006A01065O0020D400060006003C2O00300105000200020006A30005001C02013O0004E03O001C02012O006A01056O0054010600013O00122O000700833O00122O000800846O0006000800024O00050005000600202O0005000500514O00050002000200262O0005001C020100180004E03O001C02012O006A010500023O0020D600050005005C4O00075O00202O0007000700854O000500070002000E2O0086001C020100050004E03O001C0201002E8F0088001C020100870004E03O001C02012O006A010500034O001C01065O00202O00060006003C4O000700086O000900043O00202O00090009001400122O000B00156O0009000B00024O000900096O00050009000200062O0005001C02013O0004E03O001C02012O006A010500013O001228000600893O0012280007008A4O0049010500074O001000055O001228000200273O0004E03O002102010004E03O008A2O010004E03O002102010004E03O00872O010026BF000200CE020100010004E03O00CE0201001228000300014O0074000400043O00260C01030029020100010004E03O00290201002EA7018B00FEFF2O008C0004E03O00250201001228000400013O0026BF00040067020100020004E03O006702012O006A01056O0070000600013O00122O0007008D3O00122O0008008E6O0006000800024O00050005000600202O0005000500084O00050002000200062O0005006502013O0004E03O006502012O006A01056O0070000600013O00122O0007008F3O00122O000800906O0006000800024O00050005000600202O0005000500454O00050002000200062O0005006502013O0004E03O006502012O006A01056O0083010600013O00122O000700913O00122O000800926O0006000800024O00050005000600202O0005000500514O000500020002000E2O0093004D020100050004E03O004D02012O006A0105000A3O00265001050065020100270004E03O006502012O006A010500053O00200E0105000500234O00065O00202O0006000600944O000700066O000800013O00122O000900953O00122O000A00966O0008000A00024O0009000B6O000A000A6O000B00043O00202O000B000B001400122O000D00276O000B000D00024O000B000B6O0005000B000200062O0005006502013O0004E03O006502012O006A010500013O001228000600973O001228000700984O0049010500074O001000055O001228000200023O0004E03O00CE020100260C0104006B020100010004E03O006B0201002E8F009A002A020100990004E03O002A0201002EE8009B00A20201009C0004E03O00A202012O006A01056O0070000600013O00122O0007009D3O00122O0008009E6O0006000800024O00050005000600202O0005000500084O00050002000200062O000500A202013O0004E03O00A202012O006A010500023O00205800050005005C4O00075O00202O00070007005D4O00050007000200262O000500A2020100180004E03O00A202012O006A01056O0070000600013O00122O0007009F3O00122O000800A06O0006000800024O00050005000600202O0005000500454O00050002000200062O000500A202013O0004E03O00A20201002EE800A100A2020100A20004E03O00A202012O006A010500053O00200E0105000500234O00065O00202O00060006005F4O000700066O000800013O00122O000900A33O00122O000A00A46O0008000A00024O000900076O000A000A6O000B00043O00202O000B000B001400122O000D00276O000B000D00024O000B000B6O0005000B000200062O000500A202013O0004E03O00A202012O006A010500013O001228000600A53O001228000700A64O0049010500074O001000056O006A01056O0070000600013O00122O000700A73O00122O000800A86O0006000800024O00050005000600202O0005000500084O00050002000200062O000500CA02013O0004E03O00CA02012O006A010500084O006A01065O0020D400060006003C2O00300105000200020006A3000500CA02013O0004E03O00CA02012O006A010500023O00206401050005001D4O00075O00202O0007000700A94O00050007000200062O000500CA02013O0004E03O00CA02012O006A010500034O001C01065O00202O00060006003C4O000700086O000900043O00202O00090009001400122O000B00156O0009000B00024O000900096O00050009000200062O000500CA02013O0004E03O00CA02012O006A010500013O001228000600AA3O001228000700AB4O0049010500074O001000055O001228000400023O0004E03O002A02010004E03O00CE02010004E03O00250201002E8F00AC0073030100AD0004E03O007303010026BF00020073030100180004E03O00730301001228000300013O00260C010300D7020100010004E03O00D70201002EA701AE005A000100AF0004E03O002F0301001228000400013O000E51010200DC020100040004E03O00DC0201001228000300023O0004E03O002F030100260C010400E0020100010004E03O00E00201002EA701B000FAFF2O00B10004E03O00D802012O006A01056O0070000600013O00122O000700B23O00122O000800B36O0006000800024O00050005000600202O0005000500084O00050002000200062O0005000B03013O0004E03O000B03012O006A010500023O00205800050005005C4O00075O00202O00070007005D4O00050007000200262O0005000B030100050004E03O000B03012O006A010500053O00208C0005000500234O00065O00202O00060006005F4O000700066O000800013O00122O000900B43O00122O000A00B56O0008000A00024O000900076O000A000A6O000B00043O00202O000B000B001400122O000D00276O000B000D00024O000B000B6O0005000B000200062O00050006030100010004E03O00060301002E8F00B6000B030100B70004E03O000B03012O006A010500013O001228000600B83O001228000700B94O0049010500074O001000056O006A01056O0070000600013O00122O000700BA3O00122O000800BB6O0006000800024O00050005000600202O0005000500084O00050002000200062O0005002D03013O0004E03O002D03012O006A010500053O00200E0105000500234O00065O00202O0006000600944O000700066O000800013O00122O000900BC3O00122O000A00BD6O0008000A00024O0009000B6O000A000A6O000B00043O00202O000B000B001400122O000D00276O000B000D00024O000B000B6O0005000B000200062O0005002D03013O0004E03O002D03012O006A010500013O001228000600BE3O001228000700BF4O0049010500074O001000055O001228000400023O0004E03O00D80201002E8F00C000D3020100C10004E03O00D302010026BF000300D3020100020004E03O00D302012O006A01046O0070000500013O00122O000600C23O00122O000700C36O0005000700024O00040004000500202O0004000400084O00040002000200062O0004007003013O0004E03O007003012O006A010400023O00206401040004001D4O00065O00202O00060006005D4O00040006000200062O0004007003013O0004E03O007003012O006A01046O00A4000500013O00122O000600C43O00122O000700C56O0005000700024O00040004000500202O0004000400454O00040002000200062O00040058030100010004E03O005803012O006A01046O0012000500013O00122O000600C63O00122O000700C76O0005000700024O00040004000500202O0004000400514O000400020002000E2O00020070030100040004E03O007003012O006A010400053O00200E0104000400234O00055O00202O00050005005F4O000600066O000700013O00122O000800C83O00122O000900C96O0007000900024O000800076O000900096O000A00043O00202O000A000A001400122O000C00276O000A000C00024O000A000A6O0004000A000200062O0004007003013O0004E03O007003012O006A010400013O001228000500CA3O001228000600CB4O0049010400064O001000045O001228000200423O0004E03O007303010004E03O00D30201002EA701CC0088000100CC0004E03O00FB03010026BF000200FB030100020004E03O00FB03012O006A01036O0070000400013O00122O000500CD3O00122O000600CE6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003009903013O0004E03O009903012O006A010300053O00200E0103000300234O00045O00202O0004000400CF4O0005000C6O000600013O00122O000700D03O00122O000800D16O0006000800024O0007000B6O000800086O000900043O00202O00090009001400122O000B00156O0009000B00024O000900096O00030009000200062O0003009903013O0004E03O009903012O006A010300013O001228000400D23O001228000500D34O0049010300054O001000036O006A01036O0070000400013O00122O000500D43O00122O000600D56O0004000600024O00030003000400202O0003000300084O00030002000200062O000300D003013O0004E03O00D003012O006A010300023O00206401030003001D4O00055O00202O00050005001C4O00030005000200062O000300D003013O0004E03O00D003012O006A010300023O00206401030003001D4O00055O00202O00050005001E4O00030005000200062O000300D003013O0004E03O00D003012O006A010300023O0020A101030003002C00122O0005002D3O00122O000600056O00030006000200062O000300D003013O0004E03O00D003012O006A010300053O00200E0103000300234O00045O00202O0004000400244O000500066O000600013O00122O000700D63O00122O000800D76O0006000800024O000700076O000800086O000900043O00202O00090009001400122O000B00276O0009000B00024O000900096O00030009000200062O000300D003013O0004E03O00D003012O006A010300013O001228000400D83O001228000500D94O0049010300054O001000036O006A01036O0070000400013O00122O000500DA3O00122O000600DB6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300FA03013O0004E03O00FA03012O006A010300023O00206401030003001D4O00055O00202O00050005001C4O00030005000200062O000300FA03013O0004E03O00FA03012O006A010300084O006A01045O0020D400040004003C2O00300103000200020006A3000300FA03013O0004E03O00FA03012O006A010300034O003400045O00202O00040004003C4O000500066O000700043O00202O00070007001400122O000900156O0007000900024O000700076O00030007000200062O000300F5030100010004E03O00F50301002EE800DC00FA030100660004E03O00FA03012O006A010300013O001228000400DD3O001228000500DE4O0049010300054O001000035O001228000200053O00260C010200FF030100DF0004E03O00FF0301002E8F00E10041040100E00004E03O004104012O006A01036O0070000400013O00122O000500E23O00122O000600E36O0004000600024O00030003000400202O0003000300084O00030002000200062O0003000A05013O0004E03O000A05012O006A010300084O006A01045O0020D400040004003C2O00300103000200020006A30003000A05013O0004E03O000A05012O006A010300023O0020140103000300092O0030010300020002000E3A0127001E040100030004E03O001E04012O006A01036O00A4000400013O00122O000500E43O00122O000600E56O0004000600024O00030003000400202O0003000300454O00030002000200062O0003002D040100010004E03O002D04012O006A010300023O0020140103000300092O0030010300020002000E3A0142000A050100030004E03O000A05012O006A01036O0070000400013O00122O000500E63O00122O000600E76O0004000600024O00030003000400202O0003000300454O00030002000200062O0003000A05013O0004E03O000A05012O006A010300034O003400045O00202O00040004003C4O000500066O000700043O00202O00070007001400122O000900156O0007000900024O000700076O00030007000200062O0003003B040100010004E03O003B0401002EE800E9000A050100E80004E03O000A05012O006A010300013O00121F010400EA3O00122O000500EB6O000300056O00035O00044O000A050100260C010200450401004C0004E03O00450401002E8F00EC0009000100ED0004E03O00090001001228000300014O0074000400043O00260C0103004B040100010004E03O004B0401002E8F00EE0047040100EF0004E03O00470401001228000400013O002E8F00F100B9040100F00004E03O00B904010026BF000400B9040100010004E03O00B90401001228000500013O00260C01050055040100020004E03O00550401002E8F00F20057040100F30004E03O00570401001228000400023O0004E03O00B904010026BF00050051040100010004E03O005104012O006A01066O0070000700013O00122O000800F43O00122O000900F56O0007000900024O00060006000700202O0006000600084O00060002000200062O0006007304013O0004E03O007304012O006A010600084O006A01075O0020D400070007005F2O00300106000200020006A30006007304013O0004E03O007304012O006A01066O00A4000700013O00122O000800F63O00122O000900F76O0007000900024O00060006000700202O00060006003F4O00060002000200062O00060075040100010004E03O00750401002EE800F9008F040100F80004E03O008F04012O006A010600053O00208C0006000600234O00075O00202O00070007005F4O000800066O000900013O00122O000A00FA3O00122O000B00FB6O0009000B00024O000A00076O000B000B6O000C00043O00202O000C000C001400122O000E00276O000C000E00024O000C000C6O0006000C000200062O0006008A040100010004E03O008A0401002E8F00FC008F040100FD0004E03O008F04012O006A010600013O001228000700FE3O001228000800FF4O0049010600084O001000066O006A01066O0070000700013O00122O00082O00012O00122O0009002O015O0007000900024O00060006000700202O0006000600084O00060002000200062O000600B704013O0004E03O00B704012O006A010600023O00209C01060006001B4O00085O00122O00090002015O0008000800094O00060008000200062O000600B704013O0004E03O00B704012O006A010600034O002900075O00122O00080003015O0007000700084O000800096O000A00043O00202O000A000A001400122O000C00156O000A000C00024O000A000A6O0006000A0002000682010600B2040100010004E03O00B2040100122800060004012O00122800070005012O000603000600B7040100070004E03O00B704012O006A010600013O00122800070006012O00122800080007013O0049010600084O001000065O001228000500023O0004E03O00510401001228000500023O0006220104004C040100050004E03O004C040100122800050008012O00122800060009012O0006D7000600F6040100050004E03O00F604012O006A01056O0070000600013O00122O0007000A012O00122O0008000B015O0006000800024O00050005000600202O0005000500084O00050002000200062O000500F604013O0004E03O00F604012O006A010500084O006A01065O0020D400060006005F2O00300105000200020006A3000500F604013O0004E03O00F604012O006A01056O0070000600013O00122O0007000C012O00122O0008000D015O0006000800024O00050005000600202O0005000500454O00050002000200062O000500F604013O0004E03O00F604012O006A0105000D4O00B1000500010002000682010500F6040100010004E03O00F604012O006A010500053O00200E0105000500234O00065O00202O00060006005F4O000700066O000800013O00122O0009000E012O00122O000A000F015O0008000A00024O000900076O000A000A6O000B00043O00202O000B000B001400122O000D00276O000B000D00024O000B000B6O0005000B000200062O000500F604013O0004E03O00F604012O006A010500013O00122800060010012O00122800070011013O0049010500074O001000055O001228000200DF3O0004E03O000900010004E03O004C04010004E03O000900010004E03O004704010004E03O000900010004E03O000A05010004E03O000600010004E03O000A050100122800030012012O00122800040013012O0006D700030002000100040004E03O00020001001228000300013O000622012O0002000100030004E03O00020001001228000100014O0074000200023O0012283O00023O0004E03O000200012O003C012O00017O001F012O00028O00025O005C9540025O00B6A140026O001440030D3O008613DB1B1ED4870FC63919D0BF03063O00B3D47AA8727003073O0049735265616479025O00F89240025O00F89F40030C3O00436173745461726765744966030D3O00526973696E6753756E4B69636B2O033O0074738A03043O00AD191AE4030E3O004973496E4D656C2O6552616E6765031D3O00047FDAB3161149DAAF16297DC0B9135672CCBC19037ADD854A02369DE803053O00787616A9DA030C3O00E52CB7E5CC2FA3F2EC29B5ED03043O0086A740D6030C3O00426C61636B6F75744B69636B025O002O94402O033O000980F003063O00A864E99EE8A9031B3O00705818FF795B0CE84D5F10FF79141DF974550CF0666B4BE832004D03043O009C123479025O00FFB240030C3O006511DEC68DBB00EC571FD6DA03083O00BF2370BBAAE4D565030A3O0049734361737461626C65030C3O004661656C696E6553746F6D7003093O004973496E52616E6765026O003E40025O00F89740026O005440031B3O00BEAE795937127A87BC685A330C3FBCAA7A542B106B87FD68156A4A03073O001FD8CF1C355E7C03113O001237A201552829AC2C492029AE2452222C03053O003B4147CB6F03113O005370692O6E696E674372616E654B69636B2O033O0043686903113O0024B4736686293505B474558508121EB27903073O005477C01C14EB6C030B3O004973417661696C61626C65026O00104003083O00BFFB36F31435BD5803083O0021EC9E44967A5CC9025O0001B040026O00B140026O00204003213O00F3C8F01747F8372OE7FA0B48FF3CDFD3F01A42B13DE5DEF80C45E506B2CCB94D1103073O005980B899792991027O0040026O00F03F025O00288840025O00A6B240030D3O0037FE957CCFE136E2885EC8E50E03063O00866597E615A1030B3O008F832940303DE68F9F284D03073O0080C9EA5A344352030A3O00432O6F6C646F776E5570025O00A4A040025O00C09040031C3O00B6442D7DC4A3722D61C49B463777C1E4493B72CBB1412A4B98B00D6803053O00AAC42D5E14030B3O00584D1620D22F365851172D03073O00501E246554A140030B3O0046697374736F66467572792O033O00AB500103063O005BC6317922B8031A3O0032CF64AD9A0BC971868F21D46EF98D31C076AC8520F925ADC96C03053O00E954A617D9025O004EA040025O00A06240025O00949340025O00489940030C3O00873C81714EAA2594594CA63B03053O0025C550E01203093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66026O00084003123O002A4A4D42BB0E40435EBD17457854B118465F03053O00D479222C262O033O00B7B32403083O003E2ODA4A651ECD92031A3O0040A578F2D631513B7DA270F2D67E402A44A86CFDC901163B02FB03083O004F22C91991BD5E2403133O007338F8034B514F2AFE0245634922EE064F464403063O0034204C8A6A20030B3O008CF225C87EBDE836CF69AC03053O001AD89A50A603173O00E5C7FB4C7629F4DCE84D4924C9FEE54A6929F8C0EA466F03063O004CACA98D231D030F3O00432O6F6C646F776E52656D61696E73026O003440025O00B08E40025O00C09D4003133O00537472696B656F6674686557696E646C6F72642O033O00D1D8E003043O0063BCB998025O0050B040025O00C6A34003233O00C100A407A8D72BB9089CC61CB331B4DB1AB202ACC010F60AA6D415A302B7ED46A24EF703053O00C3B274D66E025O00BAA340025O006AA140025O00109940025O00D88640025O00B89640025O00F88940025O00B6B240025O00A0AF40025O00A49D40025O007C9340025O007CA640025O006CAF40025O007DB24003113O006ABD017A57A406737ABF097A5C8601775203043O001439CD6803063O0042752O66557003103O0044616E63656F664368696A6942752O6603213O003BBB11B714533D2F941BAB1B543617A011BA111A372DAD19AC164E0C7ABF58EB4803073O005348CB78D97A3A03083O009FE1B281BAAFACA803073O00DFDC89DBC3CFDD03063O00456E65726779026O004940025O00908340025O00909A4003083O004368694275727374026O00444003173O00104056DD2E065A4CF66C174D59E3391F5C60B038531A0B03053O004C73283F82025O006CA340025O0038AE40030C3O00CE7C4073F509CF13C779427B03083O00678C1021109E66BA025O00A07140025O00C49940025O002AA940025O006094402O033O00CA84B303063O005CA7EDDD1563031B3O00FD2O2C25F42F3832C02B2425F4602923F921382AEB1F7F32BF717503043O00469F404D025O00507640030C3O00F54353FC11D85A46D413D44403053O007AB72F329F03113O005072652O73757265506F696E7442752O6603073O00507265764743442O033O00CF38A903053O00E0A251C72F031B3O00EA49323E88E750270288E146387D87ED4332288FFC7A6129C3BA1503053O00E38825535D025O0082B340025O00BCAB40025O004CB040025O00FAB140025O00A49740025O00DAA84003093O003AEF6E20EE251EE57303063O006D7F971E4582030D3O00E08C6411CBD78103DCAE7E1BCE03083O0076B2E51778A5B0D203133O0036C85E0007AA2EBB11D4493E05A125B10ACE4803083O00DD65BC2C696CCF41030B3O00703904B6C1593631B7C04F03053O00B2365077C2025O0060AD40025O00A06C4003093O00457870656C4861726D03183O00311751C7E3C6B1C3260201C6EAFFB8D7381B7E90FBB9E89603083O00A2546F21A28F99D9025O002EA240025O00EAA54003083O0004D314A832C90E9E03043O00EA47BB7D030B3O00426C2O6F646C7573745570025O00EAB140025O0060AB4003173O0012345864FC042E424FBE1539575AEB1D286E09EA516D0703053O009E715C313B025O00A89A40025O0050A740030D3O004A71EBEF38264B6DF6CD3F227303063O00412O1898865603073O00486173546965722O033O00B13EE603043O0029DC5788031D3O00373FF0F9C0AC1A25F6FEF1A02C35E8B0CAAE2337F6FCDA947722A3A19E03063O00CB45568390AE030D3O008B174050C657D404B7352O5AC303083O0071D97E3339A83087031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O662O033O00121C3803083O00AE7F75562O281F16031D3O00CE325F2OD23C73C8C93573D0D538479BD83E4ADAC93758E48E2F0C8A8E03043O00BBBC5B2C025O002AA140025O00F8AB40025O00C88F40025O00809540030C3O006FF222FBD2D62EB366F720F303083O00C72D9E43982OB95B2O033O005770B303083O00B03A19DDCEB076B7031B3O00301DD805E5B72705E60DE7BB3951DD03E8B9271DCD39BCAC72428B03063O00D85271B9668E030C3O00605721DB764D4E34F374415003053O001D223B40B8030D3O0020175BC33B5A210B46E13C5E1903063O003D727E28AA55030C3O00432O6F6C646F776E446F776E030B3O00EA21642DD07CCA0E622BDA03063O0013AC481759A303083O0042752O66446F776E03103O00426F6E65647573744272657742752O66026O00F83F2O033O003A55C103073O00C5573CAF855532025O00689740025O007CA140031B3O001672D5D01F71C1C72B75DDD01F3ED0D6127FC1DF004186C7542D8203043O00B3741EB4025O00D6A640025O002AB340030F3O00D9D3FE89E2C8EAABEAC2E8B6E2C8E903043O00E18BA68D03133O0052757368696E674A61646557696E6442752O66025O00E89B40025O003EAD40030F3O0052757368696E674A61646557696E64031F3O005F9EE7284485F31F478AF025729CFD2E49CBF0254B8AE12C59B4A6340DD8AC03043O00402DEB9403113O00454133EC52DC785619F05DDB737A33E15703063O00B516315A823C029A5O990540025O00EC9F40026O00914003213O001CC1B10701D8B60E30D2AA0801D4870206D2B3490BD4BE081ADDAC365DC5F85D5F03043O00696FB1D8025O0056AA40025O00488C40025O003BB240025O0006AE40025O003CA240025O0048A040025O00B89740026O009940025O00B2AC4003133O00B40E3FA4BDD4881C39A5B3E68E1429A1B9C38303063O00B1E77A4DCDD62O033O0049125903063O003C24732120C903243O00A462454F475B02AEB149434E49612AA8B9725B495E5A7DA5B2705653404A02F3A336051003083O00C1D71637262C3E5D030C3O000D1E0FCCDEF43A0625C6D6F003063O009B4F726EAFB503123O006B5CD8E0BE9BD7574CD0EAB6B8C75D55DDF703073O00B53834B984D1EC030D4O0045C1A14BAEC92742F9A146A203073O009A522CB2C825C9025O0040A340025O0078A2402O033O0078E20C03073O002O158B626DDE28031B3O0006E0AD8F310BF9B8B3310DEFA7CC3E01EAAD993610D3FE987A56B403053O005A648CCCEC025O002FB240025O007AA34003133O009B1C37DEBB11A2131ADEB61FA31A0ED9B91BA403063O0078CC745EACD703133O00576869726C696E67447261676F6E50756E636803233O0014B5B11AE7AB7E783CB9AA09ECAD7E4013A8B60BE3E2747A05BCAD04FF9D226B43EEE803083O001F63DDD8688BC210030D3O0007A9F90507E406B5E42700E03E03063O008355C08A6C6903123O0005AC7E0739B37D0C2EAD710402B67A0232B703043O006356C41F030B3O00763D5CE94CA80976215DE403073O006F30542F9D3FC7030F3O00221385A93D380794B3221F0185A63C03053O004E7A66E0C72O033O00F1117A03083O009F9C7814635465CE031D3O006E189F76C6464834691FB374C1427C6778148A7EDD4D63182E05CC2C9C03083O00471C71EC1FA82117025O0075B340025O00309D400040052O0012283O00014O0074000100013O0026BF3O0002000100010004E03O00020001001228000100013O002EE8000200BE000100030004E03O00BE00010026BF000100BE000100040004E03O00BE00012O006A01026O00A4000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O00020015000100010004E03O00150001002EE80009002D000100080004E03O002D00012O006A010200023O00200E01020002000A4O00035O00202O00030003000B4O000400036O000500013O00122O0006000C3O00122O0007000D6O0005000700024O000600046O000700076O000800053O00202O00080008000E00122O000A00046O0008000A00024O000800086O00020008000200062O0002002D00013O0004E03O002D00012O006A010200013O0012280003000F3O001228000400104O0049010200044O001000026O006A01026O0070000300013O00122O000400113O00122O000500126O0003000500024O00020002000300202O0002000200074O00020002000200062O0002005700013O0004E03O005700012O006A010200064O006A01035O0020D40003000300132O00300102000200020006A30002005700013O0004E03O00570001002EA70114001A000100140004E03O005700012O006A010200023O00200E01020002000A4O00035O00202O0003000300134O000400036O000500013O00122O000600153O00122O000700166O0005000700024O000600076O000700076O000800053O00202O00080008000E00122O000A00046O0008000A00024O000800086O00020008000200062O0002005700013O0004E03O005700012O006A010200013O001228000300173O001228000400184O0049010200044O001000025O002EA701190025000100190004E03O007C00012O006A01026O0070000300013O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002007C00013O0004E03O007C00012O006A010200064O006A01035O0020D400030003001D2O00300102000200020006A30002007C00013O0004E03O007C00012O006A010200084O003400035O00202O00030003001D4O000400056O000600053O00202O00060006001E00122O0008001F6O0006000800024O000600066O00020006000200062O00020077000100010004E03O00770001002EE80020007C000100210004E03O007C00012O006A010200013O001228000300223O001228000400234O0049010200044O001000026O006A01026O0070000300013O00122O000400243O00122O000500256O0003000500024O00020002000300202O0002000200074O00020002000200062O000200AA00013O0004E03O00AA00012O006A010200064O006A01035O0020D40003000300262O00300102000200020006A3000200AA00013O0004E03O00AA00012O006A010200093O0020140102000200272O0030010200020002000E3A0104009B000100020004E03O009B00012O006A01026O00A4000300013O00122O000400283O00122O000500296O0003000500024O00020002000300202O00020002002A4O00020002000200062O000200AC000100010004E03O00AC00012O006A010200093O0020140102000200272O0030010200020002000E3A012B00AA000100020004E03O00AA00012O006A01026O00A4000300013O00122O0004002C3O00122O0005002D6O0003000500024O00020002000300202O00020002002A4O00020002000200062O000200AC000100010004E03O00AC0001002EA7012E00950401002F0004E03O003F05012O006A010200084O001C01035O00202O0003000300264O000400056O000600053O00202O00060006000E00122O000800306O0006000800024O000600066O00020006000200062O0002003F05013O0004E03O003F05012O006A010200013O00121F010300313O00122O000400326O000200046O00025O00044O003F05010026BF0001009B2O0100010004E03O009B2O01001228000200014O0074000300033O0026BF000200C2000100010004E03O00C20001001228000300013O0026BF000300C9000100330004E03O00C90001001228000100343O0004E03O009B2O01002E8F003500172O0100360004E03O00172O010026BF000300172O0100340004E03O00172O012O006A01046O0070000500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O0004000400074O00040002000200062O000400E100013O0004E03O00E100012O006A01046O00A4000500013O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400E3000100010004E03O00E30001002EA7013C00130001003D0004E03O00F400012O006A010400084O001C01055O00202O00050005000B4O000600076O000800053O00202O00080008000E00122O000A00046O0008000A00024O000800086O00040008000200062O000400F400013O0004E03O00F400012O006A010400013O0012280005003E3O0012280006003F4O0049010400064O001000046O006A01046O0070000500013O00122O000600403O00122O000700416O0005000700024O00040004000500202O0004000400074O00040002000200062O000400162O013O0004E03O00162O012O006A010400023O00200E01040004000A4O00055O00202O0005000500424O000600036O000700013O00122O000800433O00122O000900446O0007000900024O0008000A6O000900096O000A00053O00202O000A000A000E00122O000C00306O000A000C00024O000A000A6O0004000A000200062O000400162O013O0004E03O00162O012O006A010400013O001228000500453O001228000600464O0049010400064O001000045O001228000300333O002EE8004800C5000100470004E03O00C500010026BF000300C5000100010004E03O00C50001001228000400013O00260C010400202O0100010004E03O00202O01002EE8004A00912O0100490004E03O00912O012O006A01056O0070000600013O00122O0007004B3O00122O0008004C6O0006000800024O00050005000600202O0005000500074O00050002000200062O000500532O013O0004E03O00532O012O006A010500093O00205800050005004D4O00075O00202O00070007004E4O00050007000200262O000500532O01004F0004E03O00532O012O006A01056O0070000600013O00122O000700503O00122O000800516O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500532O013O0004E03O00532O012O006A010500023O00200E01050005000A4O00065O00202O0006000600134O000700036O000800013O00122O000900523O00122O000A00536O0008000A00024O000900076O000A000A6O000B00053O00202O000B000B000E00122O000D00046O000B000D00024O000B000B6O0005000B000200062O000500532O013O0004E03O00532O012O006A010500013O001228000600543O001228000700554O0049010500074O001000056O006A01056O0070000600013O00122O000700563O00122O000800576O0006000800024O00050005000600202O0005000500074O00050002000200062O000500742O013O0004E03O00742O012O006A01056O0070000600013O00122O000700583O00122O000800596O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500742O013O0004E03O00742O012O006A01056O0083010600013O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O00050005005C4O000500020002000E2O005D00762O0100050004E03O00762O012O006A0105000B3O00266A000500762O0100040004E03O00762O01002E8F005F00902O01005E0004E03O00902O012O006A010500023O00208C00050005000A4O00065O00202O0006000600604O000700036O000800013O00122O000900613O00122O000A00626O0008000A00024O0009000A6O000A000A6O000B00053O00202O000B000B000E00122O000D00046O000B000D00024O000B000B6O0005000B000200062O0005008B2O0100010004E03O008B2O01002EE8006300902O0100640004E03O00902O012O006A010500013O001228000600653O001228000700664O0049010500074O001000055O001228000400343O00260C010400952O0100340004E03O00952O01002EE80067001C2O0100680004E03O001C2O01001228000300343O0004E03O00C500010004E03O001C2O010004E03O00C500010004E03O009B2O010004E03O00C20001002E8F006A0079020100690004E03O007902010026BF00010079020100330004E03O00790201001228000200014O0074000300033O002E8F006C00A12O01006B0004E03O00A12O010026BF000200A12O0100010004E03O00A12O01001228000300013O00260C010300AA2O0100330004E03O00AA2O01002EE8006D00AC2O01006E0004E03O00AC2O010012280001004F3O0004E03O00790201002E8F0070000C0201006F0004E03O000C02010026BF0003000C020100340004E03O000C0201001228000400013O00260C010400B52O0100340004E03O00B52O01002EE8007200B72O0100710004E03O00B72O01001228000300333O0004E03O000C02010026BF000400B12O0100010004E03O00B12O01002EA70173002A000100730004E03O00E32O012O006A01056O0070000600013O00122O000700743O00122O000800756O0006000800024O00050005000600202O0005000500074O00050002000200062O000500E32O013O0004E03O00E32O012O006A010500064O006A01065O0020D40006000600262O00300105000200020006A3000500E32O013O0004E03O00E32O012O006A010500093O0020640105000500764O00075O00202O0007000700774O00050007000200062O000500E32O013O0004E03O00E32O012O006A010500084O001C01065O00202O0006000600264O000700086O000900053O00202O00090009000E00122O000B00306O0009000B00024O000900096O00050009000200062O000500E32O013O0004E03O00E32O012O006A010500013O001228000600783O001228000700794O0049010500074O001000056O006A01056O0070000600013O00122O0007007A3O00122O0008007B6O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005000A02013O0004E03O000A02012O006A010500093O0020140105000500272O00300105000200020026500105000A020100040004E03O000A02012O006A010500093O00201401050005007C2O00300105000200020026500105000A0201007D0004E03O000A0201002EE8007E000A0201007F0004E03O000A02012O006A0105000C4O00D300065O00202O0006000600804O000700053O00202O00070007001E00122O000900816O0007000900024O000700076O000800016O00050008000200062O0005000A02013O0004E03O000A02012O006A010500013O001228000600823O001228000700834O0049010500074O001000055O001228000400343O0004E03O00B12O01002E8F008400A62O0100850004E03O00A62O010026BF000300A62O0100010004E03O00A62O012O006A01046O0070000500013O00122O000600863O00122O000700876O0005000700024O00040004000500202O0004000400074O00040002000200062O0004002102013O0004E03O002102012O006A010400093O00209E00040004004D4O00065O00202O00060006004E4O00040006000200262O00040023020100330004E03O00230201002EE80089003D020100880004E03O003D0201002E8F008B003D0201008A0004E03O003D02012O006A010400023O00200E01040004000A4O00055O00202O0005000500134O000600036O000700013O00122O0008008C3O00122O0009008D6O0007000900024O000800076O000900096O000A00053O00202O000A000A000E00122O000C00046O000A000C00024O000A000A6O0004000A000200062O0004003D02013O0004E03O003D02012O006A010400013O0012280005008E3O0012280006008F4O0049010400064O001000045O002EA701900038000100900004E03O007502012O006A01046O0070000500013O00122O000600913O00122O000700926O0005000700024O00040004000500202O0004000400074O00040002000200062O0004007502013O0004E03O007502012O006A010400093O0020640104000400764O00065O00202O0006000600934O00040006000200062O0004007502013O0004E03O007502012O006A010400093O0020140104000400272O0030010400020002000E3A01330075020100040004E03O007502012O006A010400093O00204300040004009400122O000600346O00075O00202O00070007000B4O00040007000200062O0004007502013O0004E03O007502012O006A010400023O00200E01040004000A4O00055O00202O0005000500134O000600036O000700013O00122O000800953O00122O000900966O0007000900024O000800076O000900096O000A00053O00202O000A000A000E00122O000C00046O000A000C00024O000A000A6O0004000A000200062O0004007502013O0004E03O007502012O006A010400013O001228000500973O001228000600984O0049010400064O001000045O001228000300343O0004E03O00A62O010004E03O007902010004E03O00A12O01002EE8009A0068030100990004E03O006803010026BF00010068030100340004E03O00680301001228000200013O00260C01020082020100340004E03O00820201002E8F009C00FB0201009B0004E03O00FB0201001228000300013O0026BF000300F6020100010004E03O00F60201002E8F009D00CC0201009E0004E03O00CC02012O006A01046O0070000500013O00122O0006009F3O00122O000700A06O0005000700024O00040004000500202O0004000400074O00040002000200062O000400CC02013O0004E03O00CC02012O006A010400093O0020140104000400272O00300104000200020026BF000400AA020100340004E03O00AA02012O006A01046O00A4000500013O00122O000600A13O00122O000700A26O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400B9020100010004E03O00B902012O006A01046O00A4000500013O00122O000600A33O00122O000700A46O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400B9020100010004E03O00B902012O006A010400093O0020140104000400272O00300104000200020026BF000400CC020100330004E03O00CC02012O006A01046O0070000500013O00122O000600A53O00122O000700A66O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400CC02013O0004E03O00CC0201002EE800A800CC020100A70004E03O00CC02012O006A010400084O001C01055O00202O0005000500A94O000600076O000800053O00202O00080008000E00122O000A00306O0008000A00024O000800086O00040008000200062O000400CC02013O0004E03O00CC02012O006A010400013O001228000500AA3O001228000600AB4O0049010400064O001000045O002EE800AC00F5020100AD0004E03O00F502012O006A01046O0070000500013O00122O000600AE3O00122O000700AF6O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400F502013O0004E03O00F502012O006A010400093O0020140104000400B02O00300104000200020006A3000400F502013O0004E03O00F502012O006A010400093O0020140104000400272O0030010400020002002650010400F5020100040004E03O00F502012O006A0104000C4O00C000055O00202O0005000500804O000600053O00202O00060006001E00122O000800816O0006000800024O000600066O000700016O00040007000200062O000400F0020100010004E03O00F00201002E8F00B100F5020100B20004E03O00F502012O006A010400013O001228000500B33O001228000600B44O0049010400064O001000045O001228000300343O0026BF00030083020100340004E03O00830201001228000200333O0004E03O00FB02010004E03O008302010026BF000200FF020100330004E03O00FF0201001228000100333O0004E03O006803010026BF0002007E020100010004E03O007E0201001228000300013O0026BF00030060030100010004E03O00600301002E8F00B5002F030100B60004E03O002F03012O006A01046O0070000500013O00122O000600B73O00122O000700B86O0005000700024O00040004000500202O0004000400074O00040002000200062O0004002F03013O0004E03O002F03012O006A010400093O0020A10104000400B900122O0006001F3O00122O000700336O00040007000200062O0004002F03013O0004E03O002F03012O006A010400023O00200E01040004000A4O00055O00202O00050005000B4O000600036O000700013O00122O000800BA3O00122O000900BB6O0007000900024O000800076O000900096O000A00053O00202O000A000A000E00122O000C00046O000A000C00024O000A000A6O0004000A000200062O0004002F03013O0004E03O002F03012O006A010400013O001228000500BC3O001228000600BD4O0049010400064O001000046O006A01046O0070000500013O00122O000600BE3O00122O000700BF6O0005000700024O00040004000500202O0004000400074O00040002000200062O0004005F03013O0004E03O005F03012O006A010400093O00208F0104000400764O00065O00202O0006000600C04O00040006000200062O00040047030100010004E03O004703012O006A010400093O0020640104000400764O00065O00202O0006000600934O00040006000200062O0004005F03013O0004E03O005F03012O006A010400023O00200E01040004000A4O00055O00202O00050005000B4O000600036O000700013O00122O000800C13O00122O000900C26O0007000900024O000800076O000900096O000A00053O00202O000A000A000E00122O000C00046O000A000C00024O000A000A6O0004000A000200062O0004005F03013O0004E03O005F03012O006A010400013O001228000500C33O001228000600C44O0049010400064O001000045O001228000300343O002E8F00C50002030100C60004E03O000203010026BF00030002030100340004E03O00020301001228000200343O0004E03O007E02010004E03O000203010004E03O007E02010026BF000100400401002B0004E03O00400401001228000200013O002EA701C70006000100C70004E03O007103010026BF00020071030100330004E03O00710301001228000100043O0004E03O00400401002EA701C80077000100C80004E03O00E80301000E512O0100E8030100020004E03O00E803012O006A01036O0070000400013O00122O000500C93O00122O000600CA6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003009E03013O0004E03O009E03012O006A010300093O00205800030003004D4O00055O00202O00050005004E4O00030005000200262O0003009E0301004F0004E03O009E03012O006A010300023O00200E01030003000A4O00045O00202O0004000400134O000500036O000600013O00122O000700CB3O00122O000800CC6O0006000800024O000700076O000800086O000900053O00202O00090009000E00122O000B00046O0009000B00024O000900096O00030009000200062O0003009E03013O0004E03O009E03012O006A010300013O001228000400CD3O001228000500CE4O0049010300054O001000036O006A01036O0070000400013O00122O000500CF3O00122O000600D06O0004000600024O00030003000400202O0003000300074O00030002000200062O000300E703013O0004E03O00E703012O006A010300064O006A01045O0020D40004000400132O00300103000200020006A3000300E703013O0004E03O00E703012O006A01036O0070000400013O00122O000500D13O00122O000600D26O0004000600024O00030003000400202O0003000300D34O00030002000200062O000300E703013O0004E03O00E703012O006A01036O0070000400013O00122O000500D43O00122O000600D56O0004000600024O00030003000400202O0003000300D34O00030002000200062O000300E703013O0004E03O00E703012O006A010300093O00208F0103000300D64O00055O00202O0005000500D74O00030005000200062O000300CD030100010004E03O00CD03012O006A0103000D4O00B1000300010002002650010300E7030100D80004E03O00E703012O006A010300023O00208C00030003000A4O00045O00202O0004000400134O000500036O000600013O00122O000700D93O00122O000800DA6O0006000800024O000700076O000800086O000900053O00202O00090009000E00122O000B00046O0009000B00024O000900096O00030009000200062O000300E2030100010004E03O00E20301002E8F00DC00E7030100DB0004E03O00E703012O006A010300013O001228000400DD3O001228000500DE4O0049010300054O001000035O001228000200343O00260C010200EC030100340004E03O00EC0301002E8F00E0006B030100DF0004E03O006B03012O006A01036O0070000400013O00122O000500E13O00122O000600E26O0004000600024O00030003000400202O0003000300074O00030002000200062O0003001004013O0004E03O001004012O006A010300093O0020640103000300D64O00055O00202O0005000500E34O00030005000200062O0003001004013O0004E03O00100401002EE800E40010040100E50004E03O001004012O006A010300084O001C01045O00202O0004000400E64O000500066O000700053O00202O00070007000E00122O000900306O0007000900024O000700076O00030007000200062O0003001004013O0004E03O001004012O006A010300013O001228000400E73O001228000500E84O0049010300054O001000036O006A01036O0070000400013O00122O000500E93O00122O000600EA6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003002B04013O0004E03O002B04012O006A010300093O0020640103000300764O00055O00202O0005000500D74O00030005000200062O0003002B04013O0004E03O002B04012O006A010300064O006A01045O0020D40004000400262O00300103000200020006A30003002B04013O0004E03O002B04012O006A0103000D4O00B1000300010002000E7C00EB002D040100030004E03O002D0401002EA701EC0013000100ED0004E03O003E04012O006A010300084O001C01045O00202O0004000400264O000500066O000700053O00202O00070007000E00122O000900306O0007000900024O000700076O00030007000200062O0003003E04013O0004E03O003E04012O006A010300013O001228000400EE3O001228000500EF4O0049010300054O001000035O001228000200333O0004E03O006B0301002E8F00F10005000100F00004E03O00050001000E51014F0005000100010004E03O00050001001228000200014O0074000300033O0026BF00020046040100010004E03O00460401001228000300013O00260C0103004D040100330004E03O004D0401002EE800F2004F040100F30004E03O004F04010012280001002B3O0004E03O0005000100260C01030053040100010004E03O00530401002E8F00F400C6040100F50004E03O00C60401001228000400013O0026BF00040058040100340004E03O00580401001228000300343O0004E03O00C60401002EE800F60054040100F70004E03O005404010026BF00040054040100010004E03O00540401002EA701F80026000100F80004E03O008204012O006A01056O0070000600013O00122O000700F93O00122O000800FA6O0006000800024O00050005000600202O0005000500074O00050002000200062O0005008204013O0004E03O00820401002EA70147001A000100470004E03O008204012O006A010500023O00200E01050005000A4O00065O00202O0006000600604O000700036O000800013O00122O000900FB3O00122O000A00FC6O0008000A00024O0009000A6O000A000A6O000B00053O00202O000B000B000E00122O000D00046O000B000D00024O000B000B6O0005000B000200062O0005008204013O0004E03O008204012O006A010500013O001228000600FD3O001228000700FE4O0049010500074O001000056O006A01056O0070000600013O00122O000700FF3O00122O00082O00015O0006000800024O00050005000600202O0005000500074O00050002000200062O000500A804013O0004E03O00A804012O006A010500093O0020640105000500764O00075O00202O00070007004E4O00050007000200062O000500A804013O0004E03O00A804012O006A01056O00A4000600013O00122O0007002O012O00122O00080002015O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500AC040100010004E03O00AC04012O006A01056O008A010600013O00122O00070003012O00122O00080004015O0006000800024O00050005000600202O00050005005C4O00050002000200122O000600343O00062O000600AC040100050004E03O00AC040100122800050005012O00122800060006012O0006D7000500C4040100060004E03O00C404012O006A010500023O00200E01050005000A4O00065O00202O0006000600134O000700036O000800013O00122O00090007012O00122O000A0008015O0008000A00024O000900076O000A000A6O000B00053O00202O000B000B000E00122O000D00046O000B000D00024O000B000B6O0005000B000200062O000500C404013O0004E03O00C404012O006A010500013O00122800060009012O0012280007000A013O0049010500074O001000055O001228000400343O0004E03O00540401001228000400343O00068C010400CD040100030004E03O00CD04010012280004000B012O0012280005000C012O00062201040049040100050004E03O00490401001228000400013O001228000500013O0006220104002F050100050004E03O002F05012O006A01056O0070000600013O00122O0007000D012O00122O0008000E015O0006000800024O00050005000600202O0005000500074O00050002000200062O000500ED04013O0004E03O00ED04012O006A010500084O002900065O00122O0007000F015O0006000600074O000700086O000900053O00202O00090009000E00122O000B00046O0009000B00024O000900096O0005000900020006A3000500ED04013O0004E03O00ED04012O006A010500013O00122800060010012O00122800070011013O0049010500074O001000056O006A01056O0070000600013O00122O00070012012O00122O00080013015O0006000800024O00050005000600202O0005000500074O00050002000200062O0005002E05013O0004E03O002E05012O006A01056O00A4000600013O00122O00070014012O00122O00080015015O0006000800024O00050005000600202O00050005002A4O00050002000200062O0005002E050100010004E03O002E05012O006A01056O00BC000600013O00122O00070016012O00122O00080017015O0006000800024O00050005000600202O00050005005C4O00050002000200122O0006002B3O00062O0006002E050100050004E03O002E05012O006A01056O0070000600013O00122O00070018012O00122O00080019015O0006000800024O00050005000600202O00050005002A4O00050002000200062O0005002E05013O0004E03O002E05012O006A010500023O00200E01050005000A4O00065O00202O00060006000B4O000700036O000800013O00122O0009001A012O00122O000A001B015O0008000A00024O000900076O000A000A6O000B00053O00202O000B000B000E00122O000D00046O000B000D00024O000B000B6O0005000B000200062O0005002E05013O0004E03O002E05012O006A010500013O0012280006001C012O0012280007001D013O0049010500074O001000055O001228000400343O001228000500343O00068C01040036050100050004E03O003605010012280005001E012O0012280006001F012O0006D7000500CE040100060004E03O00CE0401001228000300333O0004E03O004904010004E03O00CE04010004E03O004904010004E03O000500010004E03O004604010004E03O000500010004E03O003F05010004E03O000200012O003C012O00017O00CC3O00028O00026O00F03F026O000840025O00409440025O00E6A940025O0064B140025O00C08C40025O0090A140030C3O00FE04C2BD55F5C91CE8B75DF103063O009ABC68A3DE3E03073O004973526561647903093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O66027O0040030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66030C3O00426C61636B6F75744B69636B030E3O004973496E4D656C2O6552616E6765026O001440031B3O0037E12CF81B40D721D226F213448231E82BFA0543D60AFE39BB421903073O00A2558D4D9B702F025O0098AE4003083O003121AF6C073BB55A03043O002E7249C6030A3O0049734361737461626C652O033O0043686903063O00456E65726779026O00494003083O00436869427572737403093O004973496E52616E6765026O00444003173O00A6767FD02C5FB76D62AF2A4FA37F63E33A75B66A36BD7603063O002AC51E168F4E025O00F0A840025O007EA04003133O0040514D3678405039674D5A087A4B5B337C575B03043O005F13253F026O003E40025O007EAC4003133O00537472696B656F6674686557696E646C6F726403243O006238B5F57A024E23A1C3650F7413B0F57F037D23B5F83103742AA6E97D134E3FB3BC225703063O0067114CC79C1103113O00803A8CE65219B7FD903884E6593BB0F9B803083O009AD34AE5883C70D903113O005370692O6E696E674372616E654B69636B03063O0042752O66557003103O0044616E63656F664368696A6942752O66026O00204003213O00BC0CE3C30B4EA11BD5CE1746A119D5C60C44A45CEEC80346BA10FEF21653EF4FB803063O0027CF7C8AAD65026O001040025O00406740025O007CB24003093O000EADA67DFE03B4A47503053O00924BD5D618030D3O007877D24D7442665F70EA4D794E03073O00352A1EA1241A25030A3O00432O6F6C646F776E557003133O00CEEDE5E9F6FCF8E6E9F1F2D7F4F7F3ECF2EBF303043O00809D9997030B3O00507C9F3D067C7053993B0C03063O00131615EC4975025O0032B040025O00F1B14003093O00457870656C4861726D03183O0072DDB2ACFB8225F765C8E2ADF2BB2CE37BD19DBAE3FD7FA403083O009617A5C2C997DD4D03083O005D33E1386B29FB0E03043O007A1E5B88030B3O00426C2O6F646C7573745570025O0002A940025O0078AD4003173O00BCACEC2O8FAAB6F6A4CDBBA1E3B198B3B0DAA399FFF6B103053O00EDDFC485D0025O0063B140025O0084A040025O0096A840025O0006A340030B3O0099812DD6AAFAED999D2CDB03073O008BDFE85EA2D995025O00F7B240025O006DB140030B3O0046697374736F6646757279031B3O00D38A30E5A86AC5D3BC25E4A94C8AD18625F0AE59DEEA9037B1EA0C03073O00AAB5E34391DB35025O00C09140025O0018A540030D3O006B8C0DBB57822DA757AE17B15203043O00D239E57E030D3O00526973696E6753756E4B69636B031D3O00AA3AF9AF3CC2BCAB26E49939CC80B373EEA334C496B427D5B52685D1E803073O00E3D8538AC652A5025O0018AD40025O0010AE40030C3O00604C4BD6CDBC0B755941D7D403073O006E262D2EBAA4D203113O004661654578706F73757265446562752O66030C3O004661656C696E6553746F6D70031A3O007EBFAD1A3776BB97052A77B3B8563A7DB8A903326C81BB027E2E03053O005E18DEC876030D3O002FC9351013C7150C13EB2F1A1603043O00797DA04603113O005072652O73757265506F696E7442752O66025O00804B40031C3O00E1E328BBFDED04A1E6E404B9FAE930F2F7EF3DB32OE62F8DE0FE7BEA03043O00D2938A5B025O0037B140025O0092A940025O002AB240030D3O00DE3CB7882C80332EE21EAD822903083O005B8C55C4E142E760030B3O0015B1A4A5583CBE91A4592A03053O002B53D8D7D1031C3O0059AEA302204C98A31E2074ACB908250BA3B50D2F5EABA4343D5FE7E203053O004E2BC7D06B030B3O005481130AA835C3F0679A1903083O00B612E8607EDB5AA503083O0042752O66446F776E025O00B89C40025O0066B040031A3O003B5734BC2E6128AE025832BA241E23AD3B5F32A4296134BC7D0A03043O00C85D3E47025O0024AC40025O00EAAE40025O00F07040030C4O00DB08502FEC6836FC00502F03073O001D42B769334483031B3O00472948CD4E2A5CDA7A2E40CD4E654DCB43245CC2511A5ADA05711B03043O00AE254529025O00989D40025O00508440030C3O00EC0D42C3A9C11457EBABCD0A03053O00C2AE6123A0030D3O00CD292E0BF1270E17F10B3401F403043O00629F405D030F3O00432O6F6C646F776E52656D61696E73025O00DAA640025O00F09540031B3O000CBD2C1C1A094E3031BA241C1A465F2108B03813053948304EE27903083O00446ED14D7F71663B03113O009DF4AE410DCAA0A9C7B54E0DC685A7E7AC03073O002OCE84C72F63A303103O00426F6E65647573744272657742752O66029A5O990540025O00EAA640025O0090AC4003213O00E5D2DE7C5FFFCCD04D52E4C3D9776EFDCBD47911F2C7D17344FAD6E86145B6918103053O003196A2B71203133O007E22B23316E9164E0EA9201DEF16793FB5221203073O0078294ADB417A80025O00E6AE40025O00E0894003133O00576869726C696E67447261676F6E50756E636803233O004D0E5508E9AEDB5D395808E4A0DA54394C0FEBA4DD1A02591CE4B2D94E394F0EA5F48D03073O00B53A663C7A85C7030F3O0061F7CF11735DE5F6187E562OD5177E03053O001A3382BC7903133O0052757368696E674A61646557696E6442752O66025O00188840025O005BB040025O00849840026O00AE40030F3O0052757368696E674A61646557696E64031F3O00FA973F114010F066E283281C7609FE57ECC2281C4F1FE255FCBD3F0D094AA703083O003988E24C79297E97025O00E09A40025O007AB340030C3O0017F1C9483B1C20E9E342331803063O0073559DA82B5003073O0050726576474344025O00A8A940025O0064A640031B3O00FD56865487C653DDC0518E54878942CCF95B925B98F655DDBF0BD703083O00A99F3AE737ECA92603133O0022D5AD19CF117317D5B715F31D7215CDB002C003073O001C71A1DF70A474030B3O00F25052775FC34A417048D203053O003BA6382719030B3O004973417661696C61626C6503083O0081DDD4CD4DBBCCDF03053O0023D2B8A6A803173O0070576B4D2F72614C784C107F5C6E754B30726D507A473603063O00172O391D2244026O003440030B3O0064390A2254340D2A59220B03043O004C30517F025O0080414003243O001DB143BE0171E25F089A45BF0F4BCA5900A15DB818709D540BA350A20660E2431AE500E503083O00306EC531D76A14BD025O0014AC40025O00209940025O00D08040025O0050AD40030D3O002F1B5BA5CE2C7519133941AFCB03083O006C7D7228CCA04B26031A3O004B69636B736F66466C6F77696E674D6F6D656E74756D42752O66025O0008B040025O00207D40031D3O002779EC043B77C01E207EC0063C73F44D3175F90C207CEB322664BF5C6103043O006D55109F030C3O0005FFAC581057A533D8A4581003073O00D04793CD3B7B38031B3O00552C85BB5C2F91AC682B8DBB5C6080BD512191B4431F97AC1771D203043O00D83740E4000E042O0012283O00014O0074000100023O0026BF3O0007040100020004E03O000704010026BF00010004000100010004E03O00040001001228000200013O0026BF000200C2000100030004E03O00C20001001228000300014O0074000400043O002EA701043O000100040004E03O000B00010026BF0003000B000100010004E03O000B0001001228000400013O00260C01040014000100010004E03O00140001002EA701050055000100060004E03O00670001002E8F0007003F000100080004E03O003F00012O006A01056O0070000600013O00122O000700093O00122O0008000A6O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005003F00013O0004E03O003F00012O006A010500023O00205800050005000C4O00075O00202O00070007000D4O00050007000200262O0005003F0001000E0004E03O003F00012O006A010500033O0020D600050005000F4O00075O00202O0007000700104O000500070002000E2O0002003F000100050004E03O003F00012O006A010500044O001C01065O00202O0006000600114O000700086O000900033O00202O00090009001200122O000B00136O0009000B00024O000900096O00050009000200062O0005003F00013O0004E03O003F00012O006A010500013O001228000600143O001228000700154O0049010500074O001000055O002EA701160027000100160004E03O006600012O006A01056O0070000600013O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500194O00050002000200062O0005006600013O0004E03O006600012O006A010500023O00201401050005001A2O003001050002000200265001050066000100130004E03O006600012O006A010500023O00201401050005001B2O0030010500020002002650010500660001001C0004E03O006600012O006A010500054O00D300065O00202O00060006001D4O000700033O00202O00070007001E00122O0009001F6O0007000900024O000700076O000800016O00050008000200062O0005006600013O0004E03O006600012O006A010500013O001228000600203O001228000700214O0049010500074O001000055O001228000400023O00260C0104006B000100020004E03O006B0001002EE8002200BB000100230004E03O00BB00012O006A01056O0070000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005009200013O0004E03O009200012O006A010500033O00207301050005000F4O00075O00202O0007000700104O000500070002000E2O0026007F000100050004E03O007F00012O006A010500063O00265001050092000100130004E03O00920001002EA701270013000100270004E03O009200012O006A010500044O001C01065O00202O0006000600284O000700086O000900033O00202O00090009001200122O000B00136O0009000B00024O000900096O00050009000200062O0005009200013O0004E03O009200012O006A010500013O001228000600293O0012280007002A4O0049010500074O001000056O006A01056O0070000600013O00122O0007002B3O00122O0008002C6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500BA00013O0004E03O00BA00012O006A010500074O006A01065O0020D400060006002D2O00300105000200020006A3000500BA00013O0004E03O00BA00012O006A010500023O00206401050005002E4O00075O00202O00070007002F4O00050007000200062O000500BA00013O0004E03O00BA00012O006A010500044O001C01065O00202O00060006002D4O000700086O000900033O00202O00090009001200122O000B00306O0009000B00024O000900096O00050009000200062O000500BA00013O0004E03O00BA00012O006A010500013O001228000600313O001228000700324O0049010500074O001000055O0012280004000E3O0026BF000400100001000E0004E03O00100001001228000200333O0004E03O00C200010004E03O001000010004E03O00C200010004E03O000B00010026BF000200822O01000E0004E03O00822O01001228000300014O0074000400043O0026BF000300C6000100010004E03O00C60001001228000400013O000E91010200CD000100040004E03O00CD0001002EE80035003A2O0100340004E03O003A2O012O006A01056O0070000600013O00122O000700363O00122O000800376O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500FF00013O0004E03O00FF00012O006A010500023O00201401050005001A2O00300105000200020026BF000500F0000100020004E03O00F000012O006A01056O00A4000600013O00122O000700383O00122O000800396O0006000800024O00050005000600202O00050005003A4O00050002000200062O0005003O0100010004E03O003O012O006A01056O00A4000600013O00122O0007003B3O00122O0008003C6O0006000800024O00050005000600202O00050005003A4O00050002000200062O0005003O0100010004E03O003O012O006A010500023O00201401050005001A2O00300105000200020026BF000500FF0001000E0004E03O00FF00012O006A01056O00A4000600013O00122O0007003D3O00122O0008003E6O0006000800024O00050005000600202O00050005003A4O00050002000200062O0005003O0100010004E03O003O01002E8F004000122O01003F0004E03O00122O012O006A010500044O001C01065O00202O0006000600414O000700086O000900033O00202O00090009001200122O000B00306O0009000B00024O000900096O00050009000200062O000500122O013O0004E03O00122O012O006A010500013O001228000600423O001228000700434O0049010500074O001000056O006A01056O0070000600013O00122O000700443O00122O000800456O0006000800024O00050005000600202O0005000500194O00050002000200062O000500392O013O0004E03O00392O012O006A010500023O0020140105000500462O00300105000200020006A3000500392O013O0004E03O00392O012O006A010500023O00201401050005001A2O0030010500020002002650010500392O0100130004E03O00392O012O006A010500054O00C000065O00202O00060006001D4O000700033O00202O00070007001E00122O0009001F6O0007000900024O000700076O000800016O00050008000200062O000500342O0100010004E03O00342O01002EE8004800392O0100470004E03O00392O012O006A010500013O001228000600493O0012280007004A4O0049010500074O001000055O0012280004000E3O002E8F004C00402O01004B0004E03O00402O010026BF000400402O01000E0004E03O00402O01001228000200033O0004E03O00822O0100260C010400442O0100010004E03O00442O01002EE8004D00C90001004E0004E03O00C900012O006A01056O00A4000600013O00122O0007004F3O00122O000800506O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500502O0100010004E03O00502O01002EA701510013000100520004E03O00612O012O006A010500044O001C01065O00202O0006000600534O000700086O000900033O00202O00090009001200122O000B00306O0009000B00024O000900096O00050009000200062O000500612O013O0004E03O00612O012O006A010500013O001228000600543O001228000700554O0049010500074O001000055O002EE80056007E2O0100570004E03O007E2O012O006A01056O0070000600013O00122O000700583O00122O000800596O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005007E2O013O0004E03O007E2O012O006A010500044O001C01065O00202O00060006005A4O000700086O000900033O00202O00090009001200122O000B00136O0009000B00024O000900096O00050009000200062O0005007E2O013O0004E03O007E2O012O006A010500013O0012280006005B3O0012280007005C4O0049010500074O001000055O001228000400023O0004E03O00C900010004E03O00822O010004E03O00C600010026BF0002003A020100010004E03O003A0201001228000300013O00260C010300892O0100020004E03O00892O01002E8F005E00DC2O01005D0004E03O00DC2O012O006A01046O0070000500013O00122O0006005F3O00122O000700606O0005000700024O00040004000500202O0004000400194O00040002000200062O000400B22O013O0004E03O00B22O012O006A010400033O00207701040004000F4O00065O00202O0006000600104O00040006000200262O000400B22O0100020004E03O00B22O012O006A010400033O00207701040004000F4O00065O00202O0006000600614O00040006000200262O000400B22O0100030004E03O00B22O012O006A010400044O001C01055O00202O0005000500624O000600076O000800033O00202O00080008001E00122O000A00266O0008000A00024O000800086O00040008000200062O000400B22O013O0004E03O00B22O012O006A010400013O001228000500633O001228000600644O0049010400064O001000046O006A01046O0070000500013O00122O000600653O00122O000700666O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400DB2O013O0004E03O00DB2O012O006A010400023O00208F01040004002E4O00065O00202O0006000600674O00040006000200062O000400CA2O0100010004E03O00CA2O012O006A010400033O0020D600040004000F4O00065O00202O0006000600104O000400060002000E2O006800DB2O0100040004E03O00DB2O012O006A010400044O001C01055O00202O00050005005A4O000600076O000800033O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O000400DB2O013O0004E03O00DB2O012O006A010400013O001228000500693O0012280006006A4O0049010400064O001000045O0012280003000E3O002EE8006C00330201006B0004E03O003302010026BF00030033020100010004E03O00330201002EA7016D00270001006D0004E03O000702012O006A01046O0070000500013O00122O0006006E3O00122O0007006F6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004000702013O0004E03O000702012O006A01046O0070000500013O00122O000600703O00122O000700716O0005000700024O00040004000500202O00040004003A4O00040002000200062O0004000702013O0004E03O000702012O006A010400044O001C01055O00202O00050005005A4O000600076O000800033O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O0004000702013O0004E03O000702012O006A010400013O001228000500723O001228000600734O0049010400064O001000046O006A01046O0070000500013O00122O000600743O00122O000700756O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004003202013O0004E03O003202012O006A010400023O0020640104000400764O00065O00202O0006000600674O00040006000200062O0004003202013O0004E03O003202012O006A010400033O00207701040004000F4O00065O00202O0006000600104O00040006000200262O00040032020100680004E03O003202012O006A010400044O003400055O00202O0005000500534O000600076O000800033O00202O00080008001200122O000A00306O0008000A00024O000800086O00040008000200062O0004002D020100010004E03O002D0201002E8F00780032020100770004E03O003202012O006A010400013O001228000500793O0012280006007A4O0049010400064O001000045O001228000300023O002EA7017B0052FF2O007B0004E03O00852O010026BF000300852O01000E0004E03O00852O01001228000200023O0004E03O003A02010004E03O00852O010026BF00020060020100130004E03O00600201002E8F007D000D0401007C0004E03O000D04012O006A01036O0070000400013O00122O0005007E3O00122O0006007F6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003000D04013O0004E03O000D04012O006A010300074O006A01045O0020D40004000400112O00300103000200020006A30003000D04013O0004E03O000D04012O006A010300044O001C01045O00202O0004000400114O000500066O000700033O00202O00070007001200122O000900136O0007000900024O000700076O00030007000200062O0003000D04013O0004E03O000D04012O006A010300013O00121F010400803O00122O000500816O000300056O00035O00044O000D04010026BF0002001F030100330004E03O001F0301001228000300014O0074000400043O0026BF00030064020100010004E03O00640201001228000400013O00260C0104006B0201000E0004E03O006B0201002E8F0082006D020100830004E03O006D0201001228000200133O0004E03O001F03010026BF000400CC020100010004E03O00CC02012O006A01056O0070000600013O00122O000700843O00122O000800856O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005009D02013O0004E03O009D02012O006A010500023O00206401050005002E4O00075O00202O00070007000D4O00050007000200062O0005009D02013O0004E03O009D02012O006A01056O0012000600013O00122O000700863O00122O000800876O0006000800024O00050005000600202O0005000500884O000500020002000E2O0002009D020100050004E03O009D02012O006A010500044O003400065O00202O0006000600114O000700086O000900033O00202O00090009001200122O000B00136O0009000B00024O000900096O00050009000200062O00050098020100010004E03O00980201002EE80089009D0201008A0004E03O009D02012O006A010500013O0012280006008B3O0012280007008C4O0049010500074O001000056O006A01056O0070000600013O00122O0007008D3O00122O0008008E6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500CB02013O0004E03O00CB02012O006A010500023O00206401050005002E4O00075O00202O00070007008F4O00050007000200062O000500CB02013O0004E03O00CB02012O006A010500074O006A01065O0020D400060006002D2O00300105000200020006A3000500CB02013O0004E03O00CB02012O006A010500084O00B1000500010002000E2E019000CB020100050004E03O00CB02012O006A010500044O003400065O00202O00060006002D4O000700086O000900033O00202O00090009001200122O000B00306O0009000B00024O000900096O00050009000200062O000500C6020100010004E03O00C60201002EA701910007000100920004E03O00CB02012O006A010500013O001228000600933O001228000700944O0049010500074O001000055O001228000400023O000E5101020067020100040004E03O00670201001228000500013O0026BF00050015030100010004E03O001503012O006A01066O00A4000700013O00122O000800953O00122O000900966O0007000900024O00060006000700202O00060006000B4O00060002000200062O000600DD020100010004E03O00DD0201002E8F009700EE020100980004E03O00EE02012O006A010600044O001C01075O00202O0007000700994O000800096O000A00033O00202O000A000A001200122O000C00136O000A000C00024O000A000A6O0006000A000200062O000600EE02013O0004E03O00EE02012O006A010600013O0012280007009A3O0012280008009B4O0049010600084O001000066O006A01066O0070000700013O00122O0008009C3O00122O0009009D6O0007000900024O00060006000700202O00060006000B4O00060002000200062O000600FF02013O0004E03O00FF02012O006A010600023O00208F0106000600764O00085O00202O00080008009E4O00060008000200062O00060001030100010004E03O00010301002EA7019F0015000100A00004E03O00140301002E8F00A10014030100A20004E03O001403012O006A010600044O001C01075O00202O0007000700A34O000800096O000A00033O00202O000A000A001200122O000C00306O000A000C00024O000A000A6O0006000A000200062O0006001403013O0004E03O001403012O006A010600013O001228000700A43O001228000800A54O0049010600084O001000065O001228000500023O00260C01050019030100020004E03O00190301002E8F00A700CF020100A60004E03O00CF02010012280004000E3O0004E03O006702010004E03O00CF02010004E03O006702010004E03O001F03010004E03O006402010026BF00020007000100020004E03O00070001001228000300013O0026BF000300A3030100010004E03O00A303012O006A01046O0070000500013O00122O000600A83O00122O000700A96O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004005503013O0004E03O005503012O006A010400023O00206401040004002E4O00065O00202O0006000600674O00040006000200062O0004005503013O0004E03O005503012O006A010400023O00201401040004001A2O0030010400020002000E3A010E0055030100040004E03O005503012O006A010400023O0020430004000400AA00122O000600026O00075O00202O00070007005A4O00040007000200062O0004005503013O0004E03O00550301002EE800AC0055030100AB0004E03O005503012O006A010400044O001C01055O00202O0005000500114O000600076O000800033O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O0004005503013O0004E03O005503012O006A010400013O001228000500AD3O001228000600AE4O0049010400064O001000046O006A01046O0070000500013O00122O000600AF3O00122O000700B06O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400A203013O0004E03O00A203012O006A01046O0070000500013O00122O000600B13O00122O000700B26O0005000700024O00040004000500202O0004000400B34O00040002000200062O0004007D03013O0004E03O007D03012O006A01046O0070000500013O00122O000600B43O00122O000700B56O0005000700024O00040004000500202O0004000400B34O00040002000200062O0004007D03013O0004E03O007D03012O006A01046O0083010500013O00122O000600B63O00122O000700B76O0005000700024O00040004000500202O0004000400884O000400020002000E2O00B80091030100040004E03O009103012O006A010400063O00266A00040091030100130004E03O009103012O006A01046O0070000500013O00122O000600B93O00122O000700BA6O0005000700024O00040004000500202O0004000400B34O00040002000200062O000400A203013O0004E03O00A203012O006A010400033O0020D600040004000F4O00065O00202O0006000600104O000400060002000E2O00BB00A2030100040004E03O00A203012O006A010400044O001C01055O00202O0005000500284O000600076O000800033O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O000400A203013O0004E03O00A203012O006A010400013O001228000500BC3O001228000600BD4O0049010400064O001000045O001228000300023O0026BF000300A70301000E0004E03O00A703010012280002000E3O0004E03O00070001002E8F00BF0022030100BE0004E03O002203010026BF00030022030100020004E03O00220301002EE800C000DF030100C10004E03O00DF03012O006A01046O0070000500013O00122O000600C23O00122O000700C36O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400DF03013O0004E03O00DF03012O006A010400023O00208F01040004002E4O00065O00202O0006000600C44O00040006000200062O000400CC030100010004E03O00CC03012O006A010400023O00208F01040004002E4O00065O00202O0006000600674O00040006000200062O000400CC030100010004E03O00CC03012O006A010400033O0020D600040004000F4O00065O00202O0006000600104O000400060002000E2O006800DF030100040004E03O00DF03012O006A010400044O003400055O00202O00050005005A4O000600076O000800033O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O000400DA030100010004E03O00DA0301002E8F00C500DF030100C60004E03O00DF03012O006A010400013O001228000500C73O001228000600C84O0049010400064O001000046O006A01046O0070000500013O00122O000600C93O00122O000700CA6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004000104013O0004E03O000104012O006A010400023O00205800040004000C4O00065O00202O00060006000D4O00040006000200262O00040001040100030004E03O000104012O006A010400044O001C01055O00202O0005000500114O000600076O000800033O00202O00080008001200122O000A00136O0008000A00024O000800086O00040008000200062O0004000104013O0004E03O000104012O006A010400013O001228000500CB3O001228000600CC4O0049010400064O001000045O0012280003000E3O0004E03O002203010004E03O000700010004E03O000D04010004E03O000400010004E03O000D04010026BF3O0002000100010004E03O00020001001228000100014O0074000200023O0012283O00023O0004E03O000200012O003C012O00017O00983O00028O00027O004003093O001CC3147BF762E6123403083O006059BB641E9B2A8703073O0049735265616479030A3O0043686944656669636974026O00F03F03093O00457870656C4861726D030E3O004973496E4D656C2O6552616E6765026O00204003163O0028D5134F764225CC11473A7B2CC10F5E726F388D521E03063O001D4DAD632A1A030C3O00A6EE067950E0E219AFEB047103083O006DE482671A3B8F97030C3O00426C61636B6F75744B69636B026O001440025O0080A440025O0040AD40025O00609F40025O00E4AF40030C3O004361737454617267657449662O033O008E71A003083O00E4E318CEB95E2A4F03193O00CC2E36ABBF1425DA1D3CA1B71070C8233BA4A01322DB6266FE03073O0050AE4257C8D47B025O00E8A74003113O00F86937C6F91AC57E1DDAF61DCE5237CBFC03063O0073AB195EA89703113O005370692O6E696E674372616E654B69636B03093O0042752O66537461636B030D3O00436869456E6572677942752O66026O003E4003083O0042752O66446F776E03153O0053746F726D4561727468416E644669726542752O66030D3O003EBBF728F90B81F12FDC05B1EF03053O00976CD28441030F3O00432O6F6C646F776E52656D61696E73030B3O00FE5D1A5CD54EC172CD461003083O0034B8346928A621A7030D3O006007DEA134D3FF4700E6A139DF03073O00AC326EADC85AB4026O000840030B3O00DDB3E758E8B5F26AEEA8ED03043O002C9BDA942O033O00436869030D3O00DFF23F32DA2082F8F50732D72C03073O00D18D9B4C5BB447030B3O00D574CC5F09FC7BF95E08EA03053O007A931DBF2B026O001040026O002440026O001C40025O00FCAF40025O0068A240031F3O00AFC05707D4F6827983D34C08D4FAB375B5D35549DCFE8072A8D84C1C9AAED403083O001EDCB03E69BA9FEC025O00E88040025O0022A240025O00308F40025O00804B40030D3O00A9CF86B138D083B29ACF80BE2203083O00DDE8BDE5D056B5D7030A3O0049734361737461626C65030D3O00417263616E65546F2O72656E74031A3O000DA6F7DD20098BE0D33C1EB1FAC86E0AB5F8D03A04A6E19C7C5C03053O004E6CD494BC025O009C9340025O00B0924003093O000F191327FE30BA2O3603083O005A5B7074428C60DB025O00F7B140025O00BC974003093O00546967657250616C6D03163O00D15E0D09F29714C45B074CE6A908C943021EF5E8569103073O0064A5376A6C80C8025O003CA540025O005AA34003093O00B0C078FD97DA85C57203063O008AE4A91F98E503063O0042752O66557003103O00506F776572537472696B657342752O66025O00FC9F40025O00E067402O033O00C1054C03063O00A3AC6C22558003153O003318F082C97B98552B1CB781DA4884402F03E2C78D03083O0034477197E7BB24E8025O00DCB240025O00A0664003163O00A2A44F0D1B8DBF40093A80B24B221986BE5A00198FB103053O0070E1D62E6E03183O00546865456D7065726F7273436170616369746F7242752O66026O00334003163O003D362258EFB1E51023095AE0B8C017232B4FEAB4E21903073O008C7E44433B84DD030B3O004578656375746554696D65030D3O00B07814424318B5977F2C424E1403073O00E6E211672B2D7F03163O00F35EC5488CDC45CA4CADD148C1678ED744D0458EDE4B03053O00E7B02CA42B026O002C4003083O0092C336ACA085B5DF03063O00ECC1A644C9CE03083O00373EDA740A32DC6803043O0011645BA8030B3O004973417661696C61626C65025O0048AD40026O00734003163O00437261636B6C696E674A6164654C696768746E696E67030E3O0049735370652O6C496E52616E6765025O00889E40025O0065B34003233O0059B48DEFB82F7254A1B3E6B2277E65AA85EBBB377553A88BACB5227756B284FEA6632903073O001B3AC6EC8CD343025O00E2A240025O0068B140030C3O0007CCC94680E524FED84584FB03063O008B41ADAC2AE9030C3O004661656C696E6553746F6D70025O00A8A040025O00309A4003093O004973496E52616E676503183O00815774D4CD79E57794427ED5D437E6498B5A65D0D662A01C03083O0028E73611B8A41780025O0024A740025O0094A040025O00F89C40025O00B9B140026O00B34003093O00539568A87AA579BF7B03043O00CD16ED1803153O00BB6063CD35817072DA34FE7E72C435AA7061DD79E603053O0059DE1813A8026O006F40025O004AB34003083O00D6515A9504E74A4703053O0071953933D703083O004368694275727374026O00444003153O007A78C289E0D56B63DFF6E4C1757CDFBEF0D539219B03063O00A01910ABD682025O00D2A440025O00ACA44003073O0052D03E4A7CC48E03073O00EB11B8572O1DB2025O00406140026O008540025O00FAB140025O0054A14003073O004368695761766503143O00A9A170C7E7ABBF7CB8F6ABA575ECF8B8BC39A9A203053O0090CAC91998008B022O0012283O00013O0026BF3O00E2000100020004E03O00E200012O006A2O016O0070000200013O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O00010002000200062O0001002300013O0004E03O002300012O006A2O0100023O0020142O01000100062O00302O0100020002000E2E01070023000100010004E03O002300012O006A2O0100034O001C01025O00202O0002000200084O000300046O000500043O00202O00050005000900122O0007000A6O0005000700024O000500056O00010005000200062O0001002300013O0004E03O002300012O006A2O0100013O0012280002000B3O0012280003000C4O00492O0100034O001000016O006A2O016O0070000200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O0001000100054O00010002000200062O0001003600013O0004E03O003600012O006A2O0100054O006A01025O0020D400020002000F2O00302O01000200020006A30001003600013O0004E03O003600012O006A2O0100063O000E7C00100038000100010004E03O00380001002EA70111001C000100120004E03O00520001002E8F00130052000100140004E03O005200012O006A2O0100073O00200E2O01000100154O00025O00202O00020002000F4O000300086O000400013O00122O000500163O00122O000600176O0004000600024O000500096O000600066O000700043O00202O00070007000900122O000900106O0007000900024O000700076O00010007000200062O0001005200013O0004E03O005200012O006A2O0100013O001228000200183O001228000300194O00492O0100034O001000015O002EA7011A008F0001001A0004E03O00E100012O006A2O016O0070000200013O00122O0003001B3O00122O0004001C6O0002000400024O00010001000200202O0001000100054O00010002000200062O000100E100013O0004E03O00E100012O006A2O0100054O006A01025O0020D400020002001D2O00302O01000200020006A3000100C400013O0004E03O00C400012O006A2O0100023O00203B2O010001001E4O00035O00202O00030003001F4O0001000300024O000200063O00102O00020010000200102O00020020000200062O000200C4000100010004E03O00C400012O006A2O0100023O0020642O01000100214O00035O00202O0003000300224O00010003000200062O000100C400013O0004E03O00C400012O006A2O016O0012000200013O00122O000300233O00122O000400246O0002000400024O00010001000200202O0001000100254O000100020002000E2O00020089000100010004E03O008900012O006A2O016O0083010200013O00122O000300263O00122O000400276O0002000400024O00010001000200202O0001000100254O000100020002000E2O000200CE000100010004E03O00CE00012O006A2O016O0054010200013O00122O000300283O00122O000400296O0002000400024O00010001000200202O0001000100254O00010002000200262O000100A20001002A0004E03O00A200012O006A2O016O0012000200013O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200202O0001000100254O000100020002000E2O002A00A2000100010004E03O00A200012O006A2O0100023O0020142O010001002D2O00302O0100020002000E5E012A00CE000100010004E03O00CE00012O006A2O016O0012000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200202O0001000100254O000100020002000E2O002A00BB000100010004E03O00BB00012O006A2O016O0054010200013O00122O000300303O00122O000400316O0002000400024O00010001000200202O0001000100254O00010002000200262O000100BB0001002A0004E03O00BB00012O006A2O0100023O0020142O010001002D2O00302O0100020002000E5E013200CE000100010004E03O00CE00012O006A2O0100023O0020142O01000100062O00302O01000200020026292O0100C4000100070004E03O00C400012O006A2O01000A4O00B100010001000200266A000100CE000100020004E03O00CE00012O006A2O0100023O0020D600010001001E4O00035O00202O00030003001F4O000100030002000E2O003300E1000100010004E03O00E100012O006A2O01000B3O0026502O0100E1000100340004E03O00E100012O006A2O0100034O003400025O00202O00020002001D4O000300046O000500043O00202O00050005000900122O0007000A6O0005000700024O000500056O00010005000200062O000100DC000100010004E03O00DC0001002EE8003500E1000100360004E03O00E100012O006A2O0100013O001228000200373O001228000300384O00492O0100034O001000015O0012283O002A3O002E8F003900232O01003A0004E03O00232O010026BF3O00232O01002A0004E03O00232O01002E8F003C00032O01003B0004E03O00032O012O006A2O016O0070000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200202O00010001003F4O00010002000200062O000100032O013O0004E03O00032O012O006A2O0100023O0020142O01000100062O00302O0100020002000E2E010700032O0100010004E03O00032O012O006A2O0100034O00F200025O00202O0002000200404O000300036O00010003000200062O000100032O013O0004E03O00032O012O006A2O0100013O001228000200413O001228000300424O00492O0100034O001000015O002E8F0044008A020100430004E03O008A02012O006A2O016O0070000200013O00122O000300453O00122O000400466O0002000400024O00010001000200202O0001000100054O00010002000200062O0001008A02013O0004E03O008A0201002EE80048008A020100470004E03O008A02012O006A2O0100034O001C01025O00202O0002000200494O000300046O000500043O00202O00050005000900122O000700106O0005000700024O000500056O00010005000200062O0001008A02013O0004E03O008A02012O006A2O0100013O00121F0102004A3O00122O0003004B6O000100036O00015O00044O008A0201002EE8004D00090201004C0004E03O000902010026BF3O0009020100010004E03O00090201001228000100013O0026BF000100702O0100070004E03O00702O012O006A01026O0070000300013O00122O0004004E3O00122O0005004F6O0003000500024O00020002000300202O0002000200054O00020002000200062O000200542O013O0004E03O00542O012O006A010200054O006A01035O0020D40003000300492O00300102000200020006A3000200542O013O0004E03O00542O012O006A010200023O0020720102000200064O0002000200024O0003000C3O00122O000400026O0005000D6O000600023O00202O0006000600504O00085O00202O0008000800514O000600084O001301056O002A00033O00024O0004000E3O00122O000500026O0006000D6O000700023O00202O0007000700504O00095O00202O0009000900514O000700096O00066O000700043O00022O002600030003000400065F01030003000100020004E03O00562O01002EE80052006E2O0100530004E03O006E2O012O006A010200073O00200E0102000200154O00035O00202O0003000300494O000400086O000500013O00122O000600543O00122O000700556O0005000700024O0006000F6O000700076O000800043O00202O00080008000900122O000A00106O0008000A00024O000800086O00020008000200062O0002006E2O013O0004E03O006E2O012O006A010200013O001228000300563O001228000400574O0049010200044O001000025O0012283O00073O0004E03O0009020100260C2O0100742O0100010004E03O00742O01002EE8005800282O0100590004E03O00282O01001228000200013O0026BF00020001020100010004E03O000102012O006A01036O0070000400013O00122O0005005A3O00122O0006005B6O0004000600024O00030003000400202O0003000300054O00030002000200062O000300C52O013O0004E03O00C52O012O006A010300023O0020D600030003001E4O00055O00202O00050005005C4O000300050002000E2O005D00A72O0100030004E03O00A72O012O006A0103000A4O009D0003000100024O00048O000500013O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500202O0004000400604O00040002000200202O000400040007000603000400A72O0100030004E03O00A72O012O006A01036O004B010400013O00122O000500613O00122O000600626O0004000600024O00030003000400202O0003000300254O0003000200024O00048O000500013O00122O000600633O001228000700644O00170105000700024O00040004000500202O0004000400604O00040002000200062O000400C72O0100030004E03O00C72O012O006A010300023O0020D600030003001E4O00055O00202O00050005005C4O000300050002000E2O006500C52O0100030004E03O00C52O012O006A01036O0054010400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O0003000300254O00030002000200262O000300C22O0100100004E03O00C22O012O006A01036O00A4000400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O00030003006A4O00030002000200062O000300C72O0100010004E03O00C72O012O006A0103000B3O00266A000300C72O0100100004E03O00C72O01002EA7016B00160001006C0004E03O00DB2O012O006A010300034O001500045O00202O00040004006D4O000500066O000700043O00202O00070007006E4O00095O00202O00090009006D4O0007000900024O000700076O000300070002000682010300D62O0100010004E03O00D62O01002EE8007000DB2O01006F0004E03O00DB2O012O006A010300013O001228000400713O001228000500724O0049010300054O001000035O002E8F00732O00020100740004E04O0002012O006A01036O0070000400013O00122O000500753O00122O000600766O0004000600024O00030003000400202O00030003003F4O00030002000200062O00032O0002013O0004E04O0002012O006A010300054O006A01045O0020D40004000400772O00300103000200020006A300032O0002013O0004E04O000201002EE800792O00020100780004E04O0002012O006A010300034O001C01045O00202O0004000400774O000500066O000700043O00202O00070007007A00122O000900206O0007000900024O000700076O00030007000200062O00032O0002013O0004E04O0002012O006A010300013O0012280004007B3O0012280005007C4O0049010300054O001000035O001228000200073O002EA7017D0074FF2O007D0004E03O00752O010026BF000200752O0100070004E03O00752O01001228000100073O0004E03O00282O010004E03O00752O010004E03O00282O01002EE8007F00010001007E0004E03O000100010026BF3O0001000100070004E03O00010001001228000100013O00260C2O010012020100010004E03O00120201002EE800810063020100800004E03O006302012O006A01026O0070000300013O00122O000400823O00122O000500836O0003000500024O00020002000300202O0002000200054O00020002000200062O0002003502013O0004E03O003502012O006A010200023O0020140102000200062O0030010200020002000E2E01070035020100020004E03O003502012O006A010200063O000E3A01020035020100020004E03O003502012O006A010200034O001C01035O00202O0003000300084O000400056O000600043O00202O00060006000900122O0008000A6O0006000800024O000600066O00020006000200062O0002003502013O0004E03O003502012O006A010200013O001228000300843O001228000400854O0049010200044O001000025O002E8F00860062020100870004E03O006202012O006A01026O0070000300013O00122O000400883O00122O000500896O0003000500024O00020002000300202O00020002003F4O00020002000200062O0002006202013O0004E03O006202012O006A010200023O0020140102000200062O0030010200020002000E2E01070049020100020004E03O004902012O006A010200063O00260C01020051020100070004E03O005102012O006A010200023O0020140102000200062O0030010200020002000E2E01020062020100020004E03O006202012O006A010200063O000E2E01020062020100020004E03O006202012O006A010200104O00D300035O00202O00030003008A4O000400043O00202O00040004007A00122O0006008B6O0004000600024O000400046O000500016O00020005000200062O0002006202013O0004E03O006202012O006A010200013O0012280003008C3O0012280004008D4O0049010200044O001000025O001228000100073O002EE8008F000E0201008E0004E03O000E02010026BF0001000E020100070004E03O000E02012O006A01026O00A4000300013O00122O000400903O00122O000500916O0003000500024O00020002000300202O00020002003F4O00020002000200062O00020073020100010004E03O00730201002E8F00930086020100920004E03O00860201002EE800950086020100940004E03O008602012O006A010200034O001C01035O00202O0003000300964O000400056O000600043O00202O00060006007A00122O0008008B6O0006000800024O000600066O00020006000200062O0002008602013O0004E03O008602012O006A010200013O001228000300973O001228000400984O0049010200044O001000025O0012283O00023O0004E03O000100010004E03O000E02010004E03O000100012O003C012O00017O001E012O00028O00025O00989D40025O00BAA540026O00F03F025O004C9240025O00FAAF40025O00B9B040025O0009B040025O00408D40025O001AAD40025O0018954003133O00186CDED2D9D1247ED8D3D7E32276C8D7DDC62F03063O00B44B18ACBBB203073O0049735265616479030B3O00F7D1F00D7821EB162OCAF103083O0070A3B985631C4499030B3O004973417661696C61626C6503133O00537472696B656F6674686557696E646C6F7264030E3O004973496E4D656C2O6552616E6765026O00224003213O00B840EEC2A051C3C4AD6BE8C3AE6BEBC2A550F0C4B950BCD8AE46F9C5A240E58BF903043O00ABCB349C03113O0089DA74BF2488B3A799D87CBF2FAAB4A3B103083O00C0DAAA1DD14AE1DD03113O005370692O6E696E674372616E654B69636B03063O0042752O66557003103O0044616E63656F664368696A6942752O66027O0040026O002040031F3O0090CC520EC14427FABCDF4901C14816F68ADF5040DC483BF88DD54F198F1C7D03083O009DE3BC3B60AF2D49025O00589C40025O00A88140030B3O00188D19A1E38E32A62B961303083O00E05EE46AD590E15403133O00496E766F6B65727344656C6967687442752O66026O000840030C3O009AE943C528B7E64ED408BFE603053O0061D08827A0026O001040030B3O00426C2O6F646C7573745570025O0034AA40025O00F0A240030B3O0046697374736F664675727903193O00F020D0924A2D34F016C5934B0B7BE52CD183571B2FEF6992D603073O005B9649A3E63972030B3O0068A4A142E304B8795BBFAB03083O003F2ECDD236906BDE025O002O9040025O00688140025O002AA640025O00507240025O00909D40025O004CA04003043O0047554944025O00789440025O0005B14003213O00F625E7532OCF23F278DAE53EED07D3FE29CB40DFF46CE742CEF522FD53C5B07DA003053O00BC904C942703073O0047657454696D65030E3O00A94A66B0780D3052805F46B34D1C03083O0035E52B15C42C6C42025O00408F40025O00208740025O001CA340030E3O001F3404B1073405A2362124B2322503043O00C5535577026O005940032C3O0049F30D235CC5113170FC0B2556BA11394AC519344BBA113149B70A365DFD1B230FE91B254AF4172356BA4F6303043O00572F9A7E025O00549A40025O0034AC40026O001440025O0006A840025O0096B140025O00B6AD40026O001840025O00709840025O006CA54003113O00C21644BFC2F8084A92DEF008489AC5F20D03053O00AC91662DD1025O0010B340025O00F49F40025O00EC9840025O00EAA340031F3O00E71D054E8577FA0A3343997FFA08334B827DFF4D1F45997BFA041859CB2AA603063O001E946D6C20EB030C3O00364B105C1F48044B3F4E125403043O003F742771030C3O00426C61636B6F75744B69636B025O00F88F40025O00E09A40025O00807640025O00A88A4003193O003A5CC6EF1B27BD2C6FCCE51323E82B55D5E91E21BC211093B803073O00C85830A78C7048030F3O00DABBDD225FE6EF84CF2E53DFE1A0CA03063O002O88CEAE4A3603083O0042752O66446F776E03133O0052757368696E674A61646557696E6442752O66030F3O0052757368696E674A61646557696E64031D3O0036E6958D5AAABC1BF98781569BAC2DFD82C540A1A921FD8F914AE4E87C03073O00DB4493E6E533C4030D3O004E47E5E90840286940DDE9054C03073O007B1C2E96806627030C3O00436173745461726765744966030D3O00526973696E6753756E4B69636B2O033O0008401303083O001565297D377BE95B025O00849640025O001AAE40031B3O0090E2BDFA0235BDF8BBFD33398BE8A5B31F3790EEA0FA182BC2BFFE03063O0052E28BCE936C025O00A6AE40025O0084AA4003133O00F55621B9EECB502F8FF0C35927A5D2D7502BA303053O0082A23E48CB025O002C9740025O005EA84003133O00576869726C696E67447261676F6E50756E636803213O00B4BFB4628B89E1FA9CB3AF71808FE1C2B3A2B3738FC0FCF8B1B2B3799399AFA9F503083O009DC3D7DD10E7E08F03093O004BD00C89F14FD8078103053O00831FB96BEC03173O009FAE4B27A3A24423B8A44C30A3AE672BA5AA5930AEB95303043O00442OCB2A03093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O6603093O00546967657250616C6D03163O00575E72DC516865D84F5A35CA464570D74A436C99170F03043O00B9233715025O00C05840025O00D2A240025O000EB240025O0070A540025O000DB240025O0071B340025O0042B240025O0032AF40025O00F07F40025O00F09F40030D3O00DF721D17A1DBDE6E0035A6DFE603063O00BC8D1B6E7ECF03113O005072652O73757265506F696E7442752O66030C3O00AF395072E0FD1A99144C72F303073O0069ED563E17848803073O0048617354696572026O003E40025O004AA740026O0041402O033O00B4403203063O007DD9295C2D43031A3O004BBD15568D5C66A71351BC2O50B70D1F905E4BB10856974219EC03063O003B39D4663FE3025O0042AA40025O00BFB140030C3O005FE47E0476E76A1356E17C0C03043O00671D881F030B3O0042752O6652656D61696E732O033O001327D403053O00267E4EBA4A03183O00C34C2B894C8BD45415814E87CA00398F5581CF493E9307D203063O00E4A1204AEA27025O00A09840025O0039B340025O00249340030B3O00E3C222A7D6C43795D0D92803043O00D3A5AB51030C3O00536572656E69747942752O66025O0099B140025O00549E4003183O00027CC1DEC4E30B73EDCCC2CE1D35C1CFC5D90A7CC6D3978E03063O00BC6415B2AAB7030C3O005C1B51B0B9C26B037BBAB1C603063O00AD1E7730D3D203123O0068D1383E54CE3B3543D0373D6FCB3C3B5FCA03043O005A3BB9592O033O004DF95403063O001D20903A2F5B03183O00113970BE4AAE06214EB648A2187562B853A41D3C65A401F503063O00C1735511DD21025O0024AD40030F3O009B0AF7D626A718CEDF2BAC28EDD02B03053O004FC97F84BE025O0016A440031D3O003A01FAC1211AEEF62215EDCC1703E0C72C54FACC3A11E7C03C0DA99B7A03043O00A9487489030C3O005B76C8A57275DCB25273CAAD03043O00C6191AA903123O007A7BDC2288467970517AD321B3432O7E4D6003083O001F2913BD46E7311B2O033O00BADA5F03043O0086D7B33103193O00E3F857E55E1CF4E069ED5C10EAB445E34716EFFD42FF1541B503063O00738194368635025O0024A440025O006EAD4003113O00DA975945D6011DEEA4424AD60D38E0845B03073O007389E7302BB868026O660240025O00EBB140025O00BEA140031F3O00CAF913EDA7A931DED619F1A8AE3AE6E213E0A2E02CDCFB1FEDA0B42699BB4C03073O005FB9897A83C9C003133O004522D51A2E7339C1072D7301CE1D217A39D51703053O00451656A77303223O004B9055884E22678B41BE512F5DBB50884B23548B558505345D96428F4C3341C415D903063O004738E427E125025O00806040025O00ACAA40025O00DC9B40025O0028A340025O00ACA140025O0088A040025O00E2AB40030D3O008DC3C41F3FB8F9C2181AB6C9DC03053O0051DFAAB7762O033O002B48A203073O00714621CCDB9952031B3O00E38B2C35F0B7CE912A32C1BBF881347CEDB5E3873135EAA9B1D36903063O00D091E25F5C9E030C3O009CEDDC4FE4FABA0C95E8DE4703083O0078DE81BD2C8F95CF2O033O0089181303083O00D8E4717DD1AA2B1903173O00FBF659467971ECEE674E7B7DF2BA4B40607BF7F34C5C3203063O001E999A382512025O0002A840025O00388D4003113O002EA9FE023514B7F02F291CB7F227321EB203053O005B7DD9976C031F3O00EA03AF7ED0F01DA14FDDEB12A875E1F21AA57B9EEA16B475D0F007BF308CA903053O00BE9973C610030C3O001877AB843174BF931172A98C03043O00E75A1BCA025O00F2A540025O00AEA8402O033O008C8D5603053O003EE1E438C203193O0014B5B82E7F5A03AD86267D561DF9AA28665018B0AD2O34044E03063O0035762OD94D14025O000CA140025O0070B340025O0053B240025O00C88A40025O00CC9540025O00A89740025O00BAAD40030D3O0082E8F720F4EA11A5EFCF20F9E603073O0042D08184499A8D030B3O006C56C5E95950D0DB5F4DCF03043O009D2A3FB6030F3O00432O6F6C646F776E52656D61696E73025O00449F40025O00B070402O033O00D6372703053O00AFBB5E499C025O0023B240025O00A8A940031B3O0034365C291524FF352A411F102AC32D7F5C250926CE2F2B5660487303073O00A0465F2F407B43030C3O00FC567532D5556125F553773A03043O0051BE3A14030B3O006A44A56390265915595FAF03083O00532C2DD617E3493F03123O00C6B247BA2FE2B849A629FBBD72AC25F4BE5503053O004095DA26DE2O033O0017AEC403043O00B07AC7AA03193O001007B1D33A24071F8FDB3828194BA3D5232E1C02A4C971784003063O004B726BD0B051025O00805F40025O0008A840025O007CA140025O00C06D40025O0066A440025O0066A540025O00308D4003113O00CA3B207BF7222772DA39287BFC002076F203043O0015994B49031F3O001A0344FCBC4F071472F1A047071672F9BB4502535EF7A043071A59EBF2155D03063O002669732D92D203133O00351E05643F0B180B5221031103780317180F7E03053O005362766C1603213O005EE3703FA98D2D4ED47D3FA4832C47D46938AB872B09F87C3FA08A2A5DF2397EF303073O0043298B194DC5E40017062O0012283O00014O0074000100023O00260C012O0006000100010004E03O00060001002E8F00030009000100020004E03O00090001001228000100014O0074000200023O0012283O00043O002EA7010500F9FF2O00050004E03O000200010026BF3O0002000100040004E03O00020001002EE80006000D000100070004E03O000D0001000E512O01000D000100010004E03O000D0001001228000200013O0026BF0002003E2O0100040004E03O003E2O01001228000300014O0074000400043O0026BF00030016000100010004E03O00160001001228000400013O002EE800090078000100080004E03O007800010026BF00040078000100040004E03O00780001001228000500013O002E8F000B00730001000A0004E03O007300010026BF00050073000100010004E03O007300012O006A01066O0070000700013O00122O0008000C3O00122O0009000D6O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006004700013O0004E03O004700012O006A01066O0070000700013O00122O0008000F3O00122O000900106O0007000900024O00060006000700202O0006000600114O00060002000200062O0006004700013O0004E03O004700012O006A010600024O001C01075O00202O0007000700124O000800096O000A00033O00202O000A000A001300122O000C00146O000A000C00024O000A000A6O0006000A000200062O0006004700013O0004E03O004700012O006A010600013O001228000700153O001228000800164O0049010600084O001000066O006A01066O0070000700013O00122O000800173O00122O000900186O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006007200013O0004E03O007200012O006A010600044O006A01075O0020D40007000700192O00300106000200020006A30006007200013O0004E03O007200012O006A010600053O00206401060006001A4O00085O00202O00080008001B4O00060008000200062O0006007200013O0004E03O007200012O006A010600063O000E2E011C0072000100060004E03O007200012O006A010600024O001C01075O00202O0007000700194O000800096O000A00033O00202O000A000A001300122O000C001D6O000A000C00024O000A000A6O0006000A000200062O0006007200013O0004E03O007200012O006A010600013O0012280007001E3O0012280008001F4O0049010600084O001000065O001228000500043O0026BF0005001E000100040004E03O001E00010012280004001C3O0004E03O007800010004E03O001E000100260C0104007C0001001C0004E03O007C0001002EE80020007E000100210004E03O007E00010012280002001C3O0004E03O003E2O01000E512O010019000100040004E03O001900012O006A01056O0070000600013O00122O000700223O00122O000800236O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500A900013O0004E03O00A900012O006A010500053O00206401050005001A4O00075O00202O0007000700244O00050007000200062O000500A100013O0004E03O00A100012O006A010500063O0026500105009E000100250004E03O009E00012O006A01056O00A4000600013O00122O000700263O00122O000800276O0006000800024O00050005000600202O0005000500114O00050002000200062O000500AB000100010004E03O00AB00012O006A010500063O000E5E012800AB000100050004E03O00AB00012O006A010500053O0020140105000500292O0030010500020002000682010500AB000100010004E03O00AB00012O006A010500063O00260C010500AB0001001C0004E03O00AB0001002E8F002A00BC0001002B0004E03O00BC00012O006A010500024O001C01065O00202O00060006002C4O000700086O000900033O00202O00090009001300122O000B001D6O0009000B00024O000900096O00050009000200062O000500BC00013O0004E03O00BC00012O006A010500013O0012280006002D3O0012280007002E4O0049010500074O001000056O006A01056O0070000600013O00122O0007002F3O00122O000800306O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005003A2O013O0004E03O003A2O01001228000500014O0074000600083O00260C010500CC000100040004E03O00CC0001002E8F003100322O0100320004E03O00322O012O0074000800083O00260C010600D1000100010004E03O00D10001002EA70133000F000100340004E03O00DE0001001228000900013O000E512O0100D7000100090004E03O00D70001001228000700014O0074000800083O001228000900043O00260C010900DB000100040004E03O00DB0001002EE8003600D2000100350004E03O00D20001001228000600043O0004E03O00DE00010004E03O00D200010026BF000600CD000100040004E03O00CD00010026BF000700E0000100010004E03O00E000012O006A010900074O00B10009000100022O008D010800093O0006A30008003A2O013O0004E03O003A2O010020140109000800372O00050009000200024O000A00033O00202O000A000A00374O000A0002000200062O000900FC0001000A0004E03O00FC0001002E8F0038003A2O0100390004E03O003A2O012O006A010900084O006A010A5O0020D4000A000A002C2O00300109000200020006A30009003A2O013O0004E03O003A2O012O006A010900013O00121F010A003A3O00122O000B003B6O0009000B6O00095O00044O003A2O012O006A010900093O0006A30009003A2O013O0004E03O003A2O010012780109003C4O00E10009000100024O000A000A6O000B00013O00122O000C003D3O00122O000D003E6O000B000D00024O000A000A000B4O00090009000A00202O00090009003F4O000A000B3O0006D7000A003A2O0100090004E03O003A2O01001228000900014O0074000A000A3O0026BF0009000E2O0100010004E03O000E2O01001228000A00013O000E912O0100152O01000A0004E03O00152O01002EE8004100112O0100400004E03O00112O012O006A010B000A4O009B010C00013O00122O000D00423O00122O000E00436O000C000E000200122O000D003C6O000D000100024O000B000C000D4O000B00086O000C000C3O00122O000D00444O007B010C000D4O0007000B3O00020006A3000B003A2O013O0004E03O003A2O012O006A010B00013O00121F010C00453O00122O000D00466O000B000D6O000B5O00044O003A2O010004E03O00112O010004E03O003A2O010004E03O000E2O010004E03O003A2O010004E03O00E000010004E03O003A2O010004E03O00CD00010004E03O003A2O01002E8F004700C8000100480004E03O00C800010026BF000500C8000100010004E03O00C80001001228000600014O0074000700073O001228000500043O0004E03O00C80001001228000400043O0004E03O001900010004E03O003E2O010004E03O001600010026BF000200FC2O0100490004E03O00FC2O01001228000300014O0074000400043O00260C010300462O0100010004E03O00462O01002E8F004B00422O01004A0004E03O00422O01001228000400013O002EA7014C00060001004C0004E03O004D2O01000E51011C004D2O0100040004E03O004D2O010012280002004D3O0004E03O00FC2O0100260C010400512O0100040004E03O00512O01002EE8004F00A32O01004E0004E03O00A32O012O006A01056O0070000600013O00122O000700503O00122O000800516O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500682O013O0004E03O00682O012O006A010500044O006A01065O0020D40006000600192O00300105000200020006A3000500682O013O0004E03O00682O012O006A010500053O00208F01050005001A4O00075O00202O00070007001B4O00050007000200062O0005006A2O0100010004E03O006A2O01002EE80052007D2O0100530004E03O007D2O012O006A010500024O003400065O00202O0006000600194O000700086O000900033O00202O00090009001300122O000B001D6O0009000B00024O000900096O00050009000200062O000500782O0100010004E03O00782O01002EE80055007D2O0100540004E03O007D2O012O006A010500013O001228000600563O001228000700574O0049010500074O001000056O006A01056O0070000600013O00122O000700583O00122O000800596O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005008D2O013O0004E03O008D2O012O006A010500044O006A01065O0020D400060006005A2O00300105000200020006820105008F2O0100010004E03O008F2O01002EA7015B00150001005C0004E03O00A22O012O006A010500024O003400065O00202O00060006005A4O000700086O000900033O00202O00090009001300122O000B00496O0009000B00024O000900096O00050009000200062O0005009D2O0100010004E03O009D2O01002EE8005E00A22O01005D0004E03O00A22O012O006A010500013O0012280006005F3O001228000700604O0049010500074O001000055O0012280004001C3O0026BF000400472O0100010004E03O00472O01001228000500013O0026BF000500F22O0100010004E03O00F22O012O006A01066O0070000700013O00122O000800613O00122O000900626O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600CD2O013O0004E03O00CD2O012O006A010600053O0020640106000600634O00085O00202O0008000800644O00060008000200062O000600CD2O013O0004E03O00CD2O012O006A010600063O000E2E012500CD2O0100060004E03O00CD2O012O006A010600024O001C01075O00202O0007000700654O000800096O000A00033O00202O000A000A001300122O000C001D6O000A000C00024O000A000A6O0006000A000200062O000600CD2O013O0004E03O00CD2O012O006A010600013O001228000700663O001228000800674O0049010600084O001000066O006A01066O0070000700013O00122O000800683O00122O000900696O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600F12O013O0004E03O00F12O012O006A0106000A3O00208C00060006006A4O00075O00202O00070007006B4O0008000D6O000900013O00122O000A006C3O00122O000B006D6O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O000600EC2O0100010004E03O00EC2O01002E8F006F00F12O01006E0004E03O00F12O012O006A010600013O001228000700703O001228000800714O0049010600084O001000065O001228000500043O00260C010500F62O0100040004E03O00F62O01002E8F007200A62O0100730004E03O00A62O01001228000400043O0004E03O00472O010004E03O00A62O010004E03O00472O010004E03O00FC2O010004E03O00422O010026BF000200480201004D0004E03O004802012O006A01036O0070000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003001B02013O0004E03O001B0201002E8F0076001B020100770004E03O001B02012O006A010300024O001C01045O00202O0004000400784O000500066O000700033O00202O00070007001300122O000900496O0007000900024O000700076O00030007000200062O0003001B02013O0004E03O001B02012O006A010300013O001228000400793O0012280005007A4O0049010300054O001000036O006A01036O0070000400013O00122O0005007B3O00122O0006007C6O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003001606013O0004E03O001606012O006A01036O0070000400013O00122O0005007D3O00122O0006007E6O0004000600024O00030003000400202O0003000300114O00030002000200062O0003001606013O0004E03O001606012O006A010300053O00207701030003007F4O00055O00202O0005000500804O00030005000200262O00030016060100250004E03O001606012O006A010300024O001C01045O00202O0004000400814O000500066O000700033O00202O00070007001300122O000900496O0007000900024O000700076O00030007000200062O0003001606013O0004E03O001606012O006A010300013O00121F010400823O00122O000500836O000300056O00035O00044O0016060100260C0102004C020100010004E03O004C0201002EE800850062030100840004E03O00620301001228000300014O0074000400043O00260C01030052020100010004E03O00520201002EA7018600FEFF2O00870004E03O004E0201001228000400013O002E8F00880059020100890004E03O005902010026BF000400590201001C0004E03O00590201001228000200043O0004E03O006203010026BF000400F3020100040004E03O00F30201001228000500013O002E8F008B00620201008A0004E03O006202010026BF00050062020100040004E03O006202010012280004001C3O0004E03O00F30201002EE8008C005C0201008D0004E03O005C0201000E512O01005C020100050004E03O005C02012O006A01066O0070000700013O00122O0008008E3O00122O0009008F6O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006009F02013O0004E03O009F02012O006A010600063O0026BF00060084020100280004E03O008402012O006A010600053O00206401060006001A4O00085O00202O0008000800904O00060008000200062O0006008402013O0004E03O008402012O006A01066O0070000700013O00122O000800913O00122O000900926O0007000900024O00060006000700202O0006000600114O00060002000200062O000600A102013O0004E03O00A102012O006A010600063O00260C010600A1020100040004E03O00A102012O006A010600063O00262901060091020100250004E03O009102012O006A010600053O00208F01060006001A4O00085O00202O0008000800904O00060008000200062O000600A1020100010004E03O00A102012O006A010600053O00206401060006001A4O00085O00202O0008000800904O00060008000200062O0006009F02013O0004E03O009F02012O006A010600053O0020B800060006009300122O000800943O00122O0009001C6O00060009000200062O000600A1020100010004E03O00A10201002EA70195001A000100960004E03O00B902012O006A0106000A3O00200E01060006006A4O00075O00202O00070007006B4O0008000D6O000900013O00122O000A00973O00122O000B00986O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O000600B902013O0004E03O00B902012O006A010600013O001228000700993O0012280008009A4O0049010600084O001000065O002E8F009B00F10201009C0004E03O00F102012O006A01066O0070000700013O00122O0008009D3O00122O0009009E6O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600F102013O0004E03O00F102012O006A010600044O006A01075O0020D400070007005A2O00300106000200020006A3000600F102013O0004E03O00F102012O006A010600053O00205800060006007F4O00085O00202O0008000800804O00060008000200262O000600F1020100250004E03O00F102012O006A010600053O00207701060006009F4O00085O00202O0008000800804O00060008000200262O000600F1020100040004E03O00F102012O006A0106000A3O00200E01060006006A4O00075O00202O00070007005A4O0008000D6O000900013O00122O000A00A03O00122O000B00A16O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O000600F102013O0004E03O00F102012O006A010600013O001228000700A23O001228000800A34O0049010600084O001000065O001228000500043O0004E03O005C02010026BF00040053020100010004E03O00530201001228000500013O002EA701A40006000100A40004E03O00FC02010026BF000500FC020100040004E03O00FC0201001228000400043O0004E03O00530201002E8F00A600F6020100A50004E03O00F60201000E512O0100F6020100050004E03O00F602012O006A01066O0070000700013O00122O000800A73O00122O000900A86O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006002403013O0004E03O002403012O006A010600053O00207701060006009F4O00085O00202O0008000800A94O00060008000200262O00060024030100040004E03O00240301002EE800AB0024030100AA0004E03O002403012O006A010600024O001C01075O00202O00070007002C4O000800096O000A00033O00202O000A000A001300122O000C001D6O000A000C00024O000A000A6O0006000A000200062O0006002403013O0004E03O002403012O006A010600013O001228000700AC3O001228000800AD4O0049010600084O001000066O006A01066O0070000700013O00122O000800AE3O00122O000900AF6O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006005D03013O0004E03O005D03012O006A010600044O006A01075O0020D400070007005A2O00300106000200020006A30006005D03013O0004E03O005D03012O006A0106000F4O00B10006000100020006820106005D030100010004E03O005D03012O006A010600063O000E3A0128005D030100060004E03O005D03012O006A01066O0070000700013O00122O000800B03O00122O000900B16O0007000900024O00060006000700202O0006000600114O00060002000200062O0006005D03013O0004E03O005D03012O006A0106000A3O00200E01060006006A4O00075O00202O00070007005A4O0008000D6O000900013O00122O000A00B23O00122O000B00B36O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O0006005D03013O0004E03O005D03012O006A010600013O001228000700B43O001228000800B54O0049010600084O001000065O001228000500043O0004E03O00F602010004E03O005302010004E03O006203010004E03O004E02010026BF00020035040100250004E03O00350401001228000300014O0074000400043O0026BF00030066030100010004E03O00660301001228000400013O000E512O0100D4030100040004E03O00D40301001228000500013O0026BF000500CD030100010004E03O00CD0301002EA701B60029000100B60004E03O009703012O006A01066O0070000700013O00122O000800B73O00122O000900B86O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006009703013O0004E03O009703012O006A010600053O0020640106000600634O00085O00202O0008000800644O00060008000200062O0006009703013O0004E03O009703012O006A010600063O000E2E01490097030100060004E03O00970301002EA701B90013000100B90004E03O009703012O006A010600024O001C01075O00202O0007000700654O000800096O000A00033O00202O000A000A001300122O000C001D6O000A000C00024O000A000A6O0006000A000200062O0006009703013O0004E03O009703012O006A010600013O001228000700BA3O001228000800BB4O0049010600084O001000066O006A01066O0070000700013O00122O000800BC3O00122O000900BD6O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600CC03013O0004E03O00CC03012O006A01066O0070000700013O00122O000800BE3O00122O000900BF6O0007000900024O00060006000700202O0006000600114O00060002000200062O000600CC03013O0004E03O00CC03012O006A010600063O000E2E012500CC030100060004E03O00CC03012O006A010600044O006A01075O0020D400070007005A2O00300106000200020006A3000600CC03013O0004E03O00CC03012O006A0106000A3O00200E01060006006A4O00075O00202O00070007005A4O0008000D6O000900013O00122O000A00C03O00122O000B00C16O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O000600CC03013O0004E03O00CC03012O006A010600013O001228000700C23O001228000800C34O0049010600084O001000065O001228000500043O00260C010500D1030100040004E03O00D10301002E8F00C5006C030100C40004E03O006C0301001228000400043O0004E03O00D403010004E03O006C0301000E510104002C040100040004E03O002C0401001228000500013O0026BF00050025040100010004E03O002504012O006A01066O0070000700013O00122O000800C63O00122O000900C76O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006000604013O0004E03O000604012O006A010600044O006A01075O0020D40007000700192O00300106000200020006A30006000604013O0004E03O000604012O006A010600063O000E5E012500F3030100060004E03O00F303012O006A010600063O000E3A011C0006040100060004E03O000604012O006A010600104O00B1000600010002000E2E01C80006040100060004E03O000604012O006A010600024O003400075O00202O0007000700194O000800096O000A00033O00202O000A000A001300122O000C001D6O000A000C00024O000A000A6O0006000A000200062O00060001040100010004E03O00010401002EE800C90006040100CA0004E03O000604012O006A010600013O001228000700CB3O001228000800CC4O0049010600084O001000066O006A01066O0070000700013O00122O000800CD3O00122O000900CE6O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006002404013O0004E03O002404012O006A010600063O000E2E01250024040100060004E03O002404012O006A010600024O001C01075O00202O0007000700124O000800096O000A00033O00202O000A000A001300122O000C00146O000A000C00024O000A000A6O0006000A000200062O0006002404013O0004E03O002404012O006A010600013O001228000700CF3O001228000800D04O0049010600084O001000065O001228000500043O00260C01050029040100040004E03O00290401002E8F00D200D7030100D10004E03O00D703010012280004001C3O0004E03O002C04010004E03O00D70301002EE800D30069030100D40004E03O006903010026BF000400690301001C0004E03O00690301001228000200283O0004E03O003504010004E03O006903010004E03O003504010004E03O006603010026BF000200160501001C0004E03O00160501001228000300014O0074000400043O002EE800D60039040100D50004E03O003904010026BF00030039040100010004E03O00390401001228000400013O002EA701D7006B000100D70004E03O00A904010026BF000400A9040100010004E03O00A90401001228000500013O0026BF000500A4040100010004E03O00A404012O006A01066O0070000700013O00122O000800D83O00122O000900D96O0007000900024O00060006000700202O00060006000E4O00060002000200062O0006007104013O0004E03O007104012O006A010600063O0026BF00060071040100280004E03O007104012O006A010600053O00206401060006001A4O00085O00202O0008000800904O00060008000200062O0006007104013O0004E03O007104012O006A0106000A3O00200E01060006006A4O00075O00202O00070007006B4O0008000D6O000900013O00122O000A00DA3O00122O000B00DB6O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O0006007104013O0004E03O007104012O006A010600013O001228000700DC3O001228000800DD4O0049010600084O001000066O006A01066O0070000700013O00122O000800DE3O00122O000900DF6O0007000900024O00060006000700202O00060006000E4O00060002000200062O000600A304013O0004E03O00A304012O006A010600063O0026BF000600A3040100250004E03O00A304012O006A010600044O006A01075O0020D400070007005A2O00300106000200020006A3000600A304013O0004E03O00A304012O006A010600053O0020A101060006009300122O000800943O00122O0009001C6O00060009000200062O000600A304013O0004E03O00A304012O006A0106000A3O00200E01060006006A4O00075O00202O00070007005A4O0008000D6O000900013O00122O000A00E03O00122O000B00E16O0009000B00024O000A000E6O000B000B6O000C00033O00202O000C000C001300122O000E00496O000C000E00024O000C000C6O0006000C000200062O000600A304013O0004E03O00A304012O006A010600013O001228000700E23O001228000800E34O0049010600084O001000065O001228000500043O0026BF00050043040100040004E03O00430401001228000400043O0004E03O00A904010004E03O00430401002EE800E5000D050100E40004E03O000D05010026BF0004000D050100040004E03O000D05012O006A01056O0070000600013O00122O000700E63O00122O000800E76O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500D504013O0004E03O00D504012O006A010500044O006A01065O0020D40006000600192O00300105000200020006A3000500D504013O0004E03O00D504012O006A010500063O000E2E012500D5040100050004E03O00D504012O006A0105000F4O00B10005000100020006A3000500D504013O0004E03O00D504012O006A010500024O001C01065O00202O0006000600194O000700086O000900033O00202O00090009001300122O000B001D6O0009000B00024O000900096O00050009000200062O000500D504013O0004E03O00D504012O006A010500013O001228000600E83O001228000700E94O0049010500074O001000056O006A01056O0070000600013O00122O000700EA3O00122O000800EB6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005000C05013O0004E03O000C05012O006A010500044O006A01065O0020D400060006005A2O00300105000200020006A30005000C05013O0004E03O000C05012O006A010500063O000E3A0104000C050100050004E03O000C05012O006A010500063O0026500105000C050100280004E03O000C05012O006A010500053O00205800050005007F4O00075O00202O0007000700804O00050007000200262O0005000C0501001C0004E03O000C0501002E8F00EC000C050100ED0004E03O000C05012O006A0105000A3O00200E01050005006A4O00065O00202O00060006005A4O0007000D6O000800013O00122O000900EE3O00122O000A00EF6O0008000A00024O0009000E6O000A000A6O000B00033O00202O000B000B001300122O000D00496O000B000D00024O000B000B6O0005000B000200062O0005000C05013O0004E03O000C05012O006A010500013O001228000600F03O001228000700F14O0049010500074O001000055O0012280004001C3O002EE800F2003E040100F30004E03O003E04010026BF0004003E0401001C0004E03O003E0401001228000200253O0004E03O001605010004E03O003E04010004E03O001605010004E03O00390401002EA701F400FCFA2O00F40004E03O001200010026BF00020012000100280004E03O00120001001228000300013O002EE800F500AD050100F60004E03O00AD05010026BF000300AD050100010004E03O00AD0501001228000400013O002E8F00F700A3050100F80004E03O00A305010026BF000400A3050100010004E03O00A305012O006A01056O0070000600013O00122O000700F93O00122O000800FA6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005003B05013O0004E03O003B05012O006A010500063O0026BF0005003B0501001C0004E03O003B05012O006A01056O0083010600013O00122O000700FB3O00122O000800FC6O0006000800024O00050005000600202O0005000500FD4O000500020002000E2O0049003D050100050004E03O003D0501002EE800FE0059050100FF0004E03O005905012O006A0105000A3O00208C00050005006A4O00065O00202O00060006006B4O0007000D6O000800013O00122O00092O00012O00122O000A002O015O0008000A00024O0009000E6O000A000A6O000B00033O00202O000B000B001300122O000D00496O000B000D00024O000B000B6O0005000B000200062O00050054050100010004E03O0054050100122800050002012O00122800060003012O00062201050059050100060004E03O005905012O006A010500013O00122800060004012O00122800070005013O0049010500074O001000056O006A01056O0070000600013O00122O00070006012O00122O00080007015O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500A205013O0004E03O00A205012O006A010500044O006A01065O0020D400060006005A2O00300105000200020006A3000500A205013O0004E03O00A205012O006A010500063O0012280006001C3O000622010500A2050100060004E03O00A205012O006A01056O00BC000600013O00122O00070008012O00122O00080009015O0006000800024O00050005000600202O0005000500FD4O00050002000200122O000600493O00062O000600A2050100050004E03O00A205012O006A01056O0070000600013O00122O0007000A012O00122O0008000B015O0006000800024O00050005000600202O0005000500114O00050002000200062O000500A205013O0004E03O00A205012O006A010500053O00205000050005007F4O00075O00202O0007000700804O00050007000200122O000600043O00062O000500A2050100060004E03O00A205012O006A0105000A3O00200E01050005006A4O00065O00202O00060006005A4O0007000D6O000800013O00122O0009000C012O00122O000A000D015O0008000A00024O0009000E6O000A000A6O000B00033O00202O000B000B001300122O000D00496O000B000D00024O000B000B6O0005000B000200062O000500A205013O0004E03O00A205012O006A010500013O0012280006000E012O0012280007000F013O0049010500074O001000055O001228000400043O00122800050010012O00122800060010012O00062201050020050100060004E03O00200501001228000500043O00062201040020050100050004E03O00200501001228000300043O0004E03O00AD05010004E03O002005010012280004001C3O000622010300B2050100040004E03O00B20501001228000200493O0004E03O0012000100122800040011012O00122800050012012O0006D70005001B050100040004E03O001B0501001228000400043O0006220103001B050100040004E03O001B0501001228000400013O00122800050013012O00122800060014012O0006D70005000A060100060004E03O000A0601001228000500013O0006220104000A060100050004E03O000A060100122800050015012O00122800060016012O000603000600EA050100050004E03O00EA05012O006A01056O0070000600013O00122O00070017012O00122O00080018015O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500EA05013O0004E03O00EA05012O006A010500044O006A01065O0020D40006000600192O00300105000200020006A3000500EA05013O0004E03O00EA05012O006A010500063O001228000600043O000603000600EA050100050004E03O00EA05012O006A010500024O001C01065O00202O0006000600194O000700086O000900033O00202O00090009001300122O000B001D6O0009000B00024O000900096O00050009000200062O000500EA05013O0004E03O00EA05012O006A010500013O00122800060019012O0012280007001A013O0049010500074O001000056O006A01056O0070000600013O00122O0007001B012O00122O0008001C015O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005000906013O0004E03O000906012O006A010500063O001228000600043O00060300060009060100050004E03O000906012O006A010500024O001C01065O00202O0006000600784O000700086O000900033O00202O00090009001300122O000B00496O0009000B00024O000900096O00050009000200062O0005000906013O0004E03O000906012O006A010500013O0012280006001D012O0012280007001E013O0049010500074O001000055O001228000400043O001228000500043O000622010400BA050100050004E03O00BA05010012280003001C3O0004E03O001B05010004E03O00BA05010004E03O001B05010004E03O001200010004E03O001606010004E03O000D00010004E03O001606010004E03O000200012O003C012O00017O00913O00028O00026O00F03F025O0054A240025O00206940025O006CA640025O00388740030C3O004570696353652O74696E677303083O0023FF681713F7CB2O03073O00AC709A1C637A9903113O00E3F2A112C2F9A72EC4E3A911C5D9A113CE03043O007EAB97C0034O00027O0040025O00E4A940025O0048834003083O008848AD4EF4B54AAA03053O009DDB2DD93A03123O0099B322D0ECA2A826C1CAB8AF33C6F6BFB13203053O009ED0DD56B503083O00D344FE1F29B13FF303073O005880218A6B40DF03103O00F4E1705DA87AE2C8FC7245A26FE7CEFC03073O008EA1922O15CD1B025O00688640025O000AA74003083O001DA1145A7220A31303053O001B4EC4602E03163O00C3F5A6BD685659FAEF9DB6765D7BE2F2A6BD764D5FFE03073O002C8A9BD2D81A24025O00BEA040025O0028A74003083O0080FCAB90BAF7B89703043O00E4D399DF030A3O0061FC5D19300746FA4D3303063O0066348F385D5A03083O007512B43CEC4810B303053O00852677C04803113O00DEAF60FEE5B361EBE3967DEFFF9260EEF903043O009B97C114026O002040025O00C09F40025O000CB14003083O00E71FE516E98719D703083O00A4B47A916280E97E031B3O00881116C0B40A2CC5B2101EF9B2031EDF88101AD9AE012EDEBA031E03043O00ADDB647B03083O00872D581F1ABA2F5F03053O0073D4482C6B030A3O008FF6577EF80AAB488DF603083O0024EC8F34129D4ECE025O008C9C40025O0068A140026O000840025O00988540025O002CB04003083O00CEDF12B125F7DBC203083O00B19DBA66C54C99BC030D3O0086B733BFA7B204AAA0AB26A9B103043O00CFC2DE4003083O002870C35481DD1C6603063O00B37B15B720E8030B3O00E22ADF2DB60EE436CA3BA003063O0062A643AC5DD303083O00D4E6C3C10B44E5F403073O00828783B7B5622A030F3O00EBB735E72CC6973DE52CCAB52FE62403053O0040A3D65B83026O001040025O00E8AC40025O005AAB40025O00AAA640025O0060AC4003083O00222A0C22361F280B03053O005F714F785603113O0083F52EB48A0816C7A8FB32A0891F3AC8A703083O00A9CB9440D0E66D5F03083O00FB2O12A623153BF503083O0086A87766D24A7B5C030F3O009E1D196DA41B1F5184083758B9031D03043O0039CB6E7C025O0032A340025O00588D4003083O009DD6013D09A0D40603053O0060CEB37549030F3O00B43072118E36742DAE25532080377F03043O0045E14317026O001440025O00406B40025O0050914003083O00F78427A1D58DDE6803083O001BA4E153D5BCE3B903113O00BD1C87D8C89A1B8BF8DE810185DCD58D1803053O00A7E86FE29E03083O0077213B0C1253F7A203083O00D124444F787B3D9003103O006AEE412F094AF85A35076EF3562C287C03053O00602C81335B03083O00260A18B2FAE6F40603073O0093756F6CC69388030C3O003FA5C77112A6C75822B7D05903043O00346AD6A2026O001840026O00A540025O0040884003083O000D1BED080EF45E2D03073O00395E7E997C679A030F3O003FC24815DF4F10F7460DDF4E19EF7903063O002177A72979B603083O0074B12F42A25D1B2B03083O005827D45B36CB337C030E3O0019BFB1A27ECFC438A4A79E74C0CD03073O00A84CCCD4EA1BAE03083O00BF01275000E8499F03073O002EEC6453246986030D3O0011FF868C95072AEE888E84270903063O006F599AE7E0E1026O001C40025O00804F40025O004CAF4003083O0038E894368550766103083O00126B8DE042EC3E1103113O0089A012F2AFBA0FE389BD19E09EBC1DF0AE03043O0097CBCF7C03083O00D2B4A99C16BDE6A203063O00D381D1DDE87F030F3O003C5C4300F51BB6531A4A6B25FB14B303083O0026692F26449C7DD003083O00BF85B150F5268B9303063O0048ECE0C5249C030E3O00E0A2428CD1B841A7C5AC4D89EC9B03043O00EAA4CB24025O0061B340025O00689F4003083O00360ACAB0F80B08CD03053O0091656FBEC4030B3O0075D591E94378CC93E1676003053O002F30ADE18C03083O0070C895CC22A244DE03063O00CC23ADE1B84B030D3O00DB57E6A9E7AB1EEB4ACB8CF4AB03073O006E8E2483ED86C603083O004845A7E4317547A003053O00581B20D390030C3O00A9AAB32CCEA373719FA6960C03083O0010EDCBDE5CABCD3B00BA012O0012283O00013O00260C012O0005000100020004E03O00050001002E8F00030039000100040004E03O00390001001228000100013O00260C2O01000A000100020004E03O000A0001002EA701050013000100060004E03O001B0001001278010200074O0044000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O000300013O00122O0004000A3O00122O0005000B6O0003000500022O003201020002000300068201020018000100010004E03O001800010012280002000C4O006501025O0012283O000D3O0004E03O0039000100260C2O01001F000100010004E03O001F0001002E8F000E00060001000F0004E03O00060001001278010200074O0044000300013O00122O000400103O00122O000500116O0003000500024O0002000200034O000300013O00122O000400123O00122O000500136O0003000500022O00320102000200032O0065010200023O001278010200074O0044000300013O00122O000400143O00122O000500156O0003000500024O0002000200034O000300013O00122O000400163O00122O000500176O0003000500022O00320102000200032O0065010200033O001228000100023O0004E03O000600010026BF3O006C000100010004E03O006C0001001228000100013O002E8F0018004E000100190004E03O004E00010026BF0001004E000100020004E03O004E0001001278010200074O0044000300013O00122O0004001A3O00122O0005001B6O0003000500024O0002000200034O000300013O00122O0004001C3O00122O0005001D6O0003000500022O00320102000200032O0065010200043O0012283O00023O0004E03O006C0001002EE8001E003C0001001F0004E03O003C00010026BF0001003C000100010004E03O003C0001001278010200074O0044000300013O00122O000400203O00122O000500216O0003000500024O0002000200034O000300013O00122O000400223O00122O000500236O0003000500022O00320102000200032O0065010200053O001278010200074O0044000300013O00122O000400243O00122O000500256O0003000500024O0002000200034O000300013O00122O000400263O00122O000500276O0003000500022O00320102000200032O0065010200063O001228000100023O0004E03O003C000100260C012O0070000100280004E03O00700001002EE8002A008F000100290004E03O008F00010012782O0100074O0044000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000200013O00122O0003002D3O00122O0004002E6O0002000400022O00322O01000100020006822O01007E000100010004E03O007E00010012280001000C4O00652O0100073O0012782O0100074O0044000200013O00122O0003002F3O00122O000400306O0002000400024O0001000100024O000200013O00122O000300313O00122O000400326O0002000400022O00322O01000100020006822O01008D000100010004E03O008D00010012280001000C4O00652O0100083O0004E03O00B92O01002E8F003300C2000100340004E03O00C200010026BF3O00C2000100350004E03O00C20001001228000100013O002E8F003600B1000100370004E03O00B100010026BF000100B1000100010004E03O00B10001001278010200074O0044000300013O00122O000400383O00122O000500396O0003000500024O0002000200034O000300013O00122O0004003A3O00122O0005003B6O0003000500022O00320102000200032O0065010200093O001278010200074O0044000300013O00122O0004003C3O00122O0005003D6O0003000500024O0002000200034O000300013O00122O0004003E3O00122O0005003F6O0003000500022O00320102000200032O00650102000A3O001228000100023O0026BF00010094000100020004E03O00940001001278010200074O0044000300013O00122O000400403O00122O000500416O0003000500024O0002000200034O000300013O00122O000400423O00122O000500436O0003000500022O00320102000200032O00650102000B3O0012283O00443O0004E03O00C200010004E03O00940001002E8F004600F7000100450004E03O00F70001000E51014400F700013O0004E03O00F70001001228000100013O00260C2O0100CB000100010004E03O00CB0001002EA70147001B000100480004E03O00E40001001278010200074O0044000300013O00122O000400493O00122O0005004A6O0003000500024O0002000200034O000300013O00122O0004004B3O00122O0005004C6O0003000500022O00320102000200032O00650102000C3O001278010200074O0044000300013O00122O0004004D3O00122O0005004E6O0003000500024O0002000200034O000300013O00122O0004004F3O00122O000500506O0003000500022O00320102000200032O00650102000D3O001228000100023O002E8F005200C7000100510004E03O00C700010026BF000100C7000100020004E03O00C70001001278010200074O0044000300013O00122O000400533O00122O000500546O0003000500024O0002000200034O000300013O00122O000400553O00122O000500566O0003000500022O00320102000200032O00650102000E3O0012283O00573O0004E03O00F700010004E03O00C70001002E8F005800232O0100590004E03O00232O01000E51015700232O013O0004E03O00232O010012782O0100074O0044000200013O00122O0003005A3O00122O0004005B6O0002000400024O0001000100024O000200013O00122O0003005C3O00122O0004005D6O0002000400022O00322O01000100022O00652O01000F3O0012782O0100074O0044000200013O00122O0003005E3O00122O0004005F6O0002000400024O0001000100024O000200013O00122O000300603O00122O000400616O0002000400022O00322O01000100020006822O0100152O0100010004E03O00152O01001228000100014O00652O0100103O0012782O0100074O0044000200013O00122O000300623O00122O000400636O0002000400024O0001000100024O000200013O00122O000300643O00122O000400656O0002000400022O00322O01000100022O00652O0100113O0012283O00663O00260C012O00272O01000D0004E03O00272O01002E8F006700522O0100680004E03O00522O010012782O0100074O0044000200013O00122O000300693O00122O0004006A6O0002000400024O0001000100024O000200013O00122O0003006B3O00122O0004006C6O0002000400022O00322O01000100020006822O0100352O0100010004E03O00352O01001228000100014O00652O0100123O00126D2O0100076O000200013O00122O0003006D3O00122O0004006E6O0002000400024O0001000100024O000200013O00122O0003006F3O00122O000400706O0002000400024O0001000100024O000100133O00122O000100076O000200013O00122O000300713O00122O000400726O0002000400024O0001000100024O000200013O00122O000300733O00122O000400746O0002000400024O00010001000200062O000100502O0100010004E03O00502O01001228000100014O00652O0100143O0012283O00353O0026BF3O00892O0100750004E03O00892O01001228000100013O002E8F0076006A2O0100770004E03O006A2O010026BF0001006A2O0100020004E03O006A2O01001278010200074O0044000300013O00122O000400783O00122O000500796O0003000500024O0002000200034O000300013O00122O0004007A3O00122O0005007B6O0003000500022O0032010200020003000682010200672O0100010004E03O00672O010012280002000C4O0065010200153O0012283O00283O0004E03O00892O01000E512O0100552O0100010004E03O00552O01001278010200074O0044000300013O00122O0004007C3O00122O0005007D6O0003000500024O0002000200034O000300013O00122O0004007E3O00122O0005007F6O0003000500022O00320102000200032O0065010200163O001278010200074O0044000300013O00122O000400803O00122O000500816O0003000500024O0002000200034O000300013O00122O000400823O00122O000500836O0003000500022O0032010200020003000682010200862O0100010004E03O00862O01001228000200014O0065010200173O001228000100023O0004E03O00552O01000E910166008D2O013O0004E03O008D2O01002EE800840001000100850004E03O000100010012782O0100074O0044000200013O00122O000300863O00122O000400876O0002000400024O0001000100024O000200013O00122O000300883O00122O000400896O0002000400022O00322O01000100020006822O01009B2O0100010004E03O009B2O01001228000100014O00652O0100183O00126D2O0100076O000200013O00122O0003008A3O00122O0004008B6O0002000400024O0001000100024O000200013O00122O0003008C3O00122O0004008D6O0002000400024O0001000100024O000100193O00122O000100076O000200013O00122O0003008E3O00122O0004008F6O0002000400024O0001000100024O000200013O00122O000300903O00122O000400916O0002000400024O00010001000200062O000100B62O0100010004E03O00B62O01001228000100014O00652O01001A3O0012283O00753O0004E03O000100012O003C012O00017O005E012O00028O00025O00E07740025O0062A440026O000840025O0016A240025O00207A40025O00806440025O005EB040030F3O00412O66656374696E67436F6D62617403053O0056164205ED03063O004F1273366A9503073O0049735265616479025O000C9D40025O008AA240030C3O0053686F756C6452657475726E03093O00466F637573556E6974025O00C2AE40025O00F08040030D3O00546172676574497356616C6964025O005CB240025O00606440025O00BEA840025O00C88340025O00EDB040025O00BC9840026O00F03F025O00607840025O008AB240025O003CA840025O0022AB40025O00406940025O00507640025O0067B040025O0092AC40025O00549F40025O00A2B240025O0002A840026O001840025O00805F40025O00BEA240025O0034B340025O0064A44003173O00ACF0A65043044A1480F084574D367A0891FB84564F046003083O0061E59ED03F286112030B3O004973417661696C61626C65026O005E40030D3O00446562752O6652656D61696E7303183O00536B79726561636845786861757374696F6E446562752O66030D3O001FC7614F822AFD6748A724CD7903053O00EC4DAE1226030F3O00432O6F6C646F776E52656D61696E73030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003103O00426F6E65647573744272657742752O6603083O00536572656E697479030C3O004661656C696E6553746F6D70027O0040025O002AA740025O00DCAA40025O00A8AE40025O00188840025O00E49040025O00C49140025O00FEB040025O000EA740030F3O0048616E646C65412O666C696374656403053O004465746F78030E3O004465746F784D6F7573656F766572026O004440025O00289E40025O009CB240025O00F89C40025O00F08940025O0050874003113O0048616E646C65496E636F72706F7265616C03093O00506172616C7973697303123O00506172616C797369734D6F7573656F766572026O003440025O006EB040025O0096A64003093O00497343617374696E67030C3O0049734368612O6E656C696E67025O009C9940025O0028A540025O0060A540025O00D2B040025O0064AF40025O00B49E40025O00F8A640025O000EA14003113O00496E74652O72757074576974685374756E03083O004C656753772O6570026O002040025O00C09840025O005AAF4003093O00496E74652O72757074030F3O00537065617248616E64537472696B6503183O00537065617248616E64537472696B654D6F7573656F766572025O00288B40025O00D4A840025O00C6AB40025O0002A340025O0057B040025O00A8A540025O00C09B40025O00509C40025O00F4A840025O0022B140025O0068994003053O006E575A513D03083O00C62A322E3E451DED03173O0044697370652O6C61626C65467269656E646C79556E6974025O00189A40026O004E40030A3O004465746F78466F637573030A3O00C6BF023630E0035ACBB403083O003BA2DA765948C06E030C3O00C55056497ECCE662474A7AD203063O00A28331332517030A3O0049734361737461626C65030E3O007978FB267D517CD62B665276F03303053O00143F199E4A030C3O004361737454617267657449662O033O0077D35203083O00D91ABA3CCD1FB04803093O004973496E52616E6765026O003E40025O008EA740025O0044A34003143O00DD7003E0D27F03D3C86509E1CB310BEDD27F46B403043O008CBB116603093O001882A3443EBBA54D2103043O00214CEBC403083O0042752O66446F776E030C3O00536572656E69747942752O6603093O0042752O66537461636B031B3O005465616368696E67736F667468654D6F6E61737465727942752O6603093O00546967657250616C6D030A3O004368694465666963697403103O00506F776572537472696B657342752O6603173O00212OE450A735BD900DE4C657A9078D8C1CEFC656AB359703083O00E5688A923FCC50E503083O0093780CCCAE740AD003043O00A9C01D7E03083O0002CE1C9934C4068303043O00EB51A56503083O004B8F460D8A11CF7003073O00AC18E43F79E564030A3O00436F6D62617454696D65026O001440025O00DCAC40025O00F4A5402O033O008747DB03043O00ADEA2EB5030E3O004973496E4D656C2O6552616E6765025O007BB140025O00F3B04003123O00CB3BEC3A31E022EA332E9F3FEA362D9F63BB03053O0043BF528B5F03083O001EE54EE02OF92EF903063O008B5D8D27A28C030C3O000AA20CDB1722A63AC31121B303053O007E4CC369B7030C3O007949A17D50BA5A7BB07E54A403063O00D43F28C41139030C3O00432O6F6C646F776E446F776E030E3O008FCAF5F6A0C5F5D2A8D9FDF5A7D203043O009AC9AB9003083O00436869427572737403113O0081E6A1F2B41AADAE96AEA5CCBF01FFECD603083O00DDE28EC8ADD66FDF026O001040025O00406740025O00F08340025O00E88640025O0012B240025O00C06F40025O00D0AC40025O00206740025O0042AC40025O00A08840025O00ECAF40025O009DB040025O00C6AF40025O0091B140025O00B5B040025O0020A640025O00804540025O006EAC40025O002C9B40025O004C9740025O0030A140025O00B4AC40025O00649540025O00805640025O006CA140026O007F40025O00E88B40025O0002AA40025O0022A040025O0053B040025O00FEA740025O0062B040025O00E2A940025O00C05440025O00E4A040025O006C9040025O0074A540025O00E8A040025O00D8AB40025O00409F40025O00CCA840025O00889740025O0026AD40025O0066AF40025O0016A940025O00A49740025O0014A140025O00804440025O00CEA140025O00ECA140025O00B2AD40025O0052B340025O008AAD40025O0080A740025O005CAF40025O00DC9F40025O00B8B240025O00E06040025O009EA340025O009AB040025O00E08E40030B3O00426C2O6F646C7573745570025O00507C40025O00B49340025O003CA040025O0074B040025O00D2AF40025O00EAA240025O00DCAD40025O00B0A340025O0012AF40025O00C2AC40025O0016A640025O00989040025O00D4B240025O0062A040025O0006A640025O00309540025O00E49E40025O00FC9340025O004DB140025O0086A040025O003AA54003083O003D4BAD34A6075AA603053O00C86E2EDF51025O0016A740025O0020A540025O0008AE40025O00806040025O00B2A940025O00C5B240025O009CA540025O00907A4003083O0025422E312CDB560F03073O002276275C5442B2025O00B6AA40025O00D08D40025O002EB040025O00608B40025O003CAE40025O00F08740025O0088AF40025O0087B340025O0050AB40025O00BCB040025O0032B140025O00BC9940025O0072A340025O005C9B40025O006AA640025O00DCA240025O009CA9402O033O0043686903083O00B358DD108E54DB0C03043O0075E03DAF03173O00C249D087E042FE9DEE49F280EE70CE81FF42F281EC42D403043O00E88B27A6025O008AAC40025O0014AA40025O003BB040025O00E4AD40025O0088A240030A3O00502O6F6C456E65726779030B3O007B873E0E6E8CC176598F2803083O00132BE851624EC9AF025O009AA340025O0047B040030C3O004570696353652O74696E677303073O009FEE82EB293BDC03083O0014CB81E58C455EAF2O033O00AEC95103063O0082CFA634568F03073O007E5514EAA67E3203073O00412A3A738DCA1B03053O00481D56CD2A03053O004F2B6435A1025O00F4B140025O00A8B24003073O00644E3F48F3555203053O009F3021582F2O033O00104D1A03083O00577F227992D38157025O005DB240025O00A88340025O00089040025O0076A340025O00405840025O00A49A40025O00D2A540025O00808140025O000CAA40024O0080B3C540030C3O00466967687452656D61696E73025O00E0A540025O0078B24003103O00426F2O73466967687452656D61696E7303173O00EF1EB85776FC6DD315A06C75FC62CE19BA5D49F052C30203073O0035A670CE381D9903113O0054696D6553696E63654C61737443617374026O003840025O00F88740025O00907B40025O00EC9F40025O00405240030D3O004973446561644F7247686F7374025O0093B14003163O00476574456E656D696573496E4D656C2O6552616E676503073O00C4CBC84858492503083O002490A4AF2F342C562O033O00330BE803053O001F506F9BC403073O006756E6D323564A03053O004F333981B403063O0033BB2348DC3B03053O00B957D25038025O0059B240025O007EB340025O0088B240025O009CA6400048072O0012283O00014O0074000100013O002E8F00020002000100030004E03O000200010026BF3O0002000100010004E03O00020001001228000100013O00260C2O01000B000100040004E03O000B0001002E8F00050005060100060004E03O00050601002E8F0007003C000100080004E03O003C00012O006A01025O0020140102000200092O00300102000200020006A30002003C00013O0004E03O003C00012O006A010200013O0006A30002003C00013O0004E03O003C00012O006A010200024O0070000300033O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002002200013O0004E03O002200012O006A010200043O00068201020024000100010004E03O00240001002EA7010D001A0001000E0004E03O003C0001001228000200014O0074000300033O0026BF00020026000100010004E03O00260001001228000300013O0026BF00030029000100010004E03O002900012O006A010400053O0020070104000400104O000500016O000600086O00040008000200122O0004000F3O002E2O0012003C000100110004E03O003C00010012780104000F3O0006A30004003C00013O0004E03O003C00010012780104000F4O003A000400023O0004E03O003C00010004E03O002900010004E03O003C00010004E03O002600012O006A010200053O0020D40002000200132O00B100020001000200068201020043000100010004E03O00430001002EE800140047070100150004E03O00470701001228000200014O0074000300033O000E512O010045000100020004E03O00450001001228000300013O000E912O01004C000100030004E03O004C0001002EE8001600ED050100170004E03O00ED0501001228000400014O0074000500053O00260C01040052000100010004E03O00520001002E8F0018004E000100190004E03O004E0001001228000500013O0026BF000500570001001A0004E03O005700010012280003001A3O0004E03O00ED0501002EE8001B00530001001C0004E03O005300010026BF00050053000100010004E03O00530001001228000600013O002EE8001D00620001001E0004E03O006200010026BF000600620001001A0004E03O006200010012280005001A3O0004E03O005300010026BF0006005C000100010004E03O005C00012O006A01075O0020140107000700092O00300107000200020006820107006C000100010004E03O006C00012O006A010700063O0006820107006E000100010004E03O006E0001002EA7011F0012000100200004E03O007E0001001228000700014O0074000800083O002E8F00220070000100210004E03O007000010026BF00070070000100010004E03O007000012O006A010900074O00B10009000100022O008D010800093O002EA701230007000100230004E03O007E00010006A30008007E00013O0004E03O007E00012O003A000800023O0004E03O007E00010004E03O00700001002E8F002500E8050100240004E03O00E805012O006A01075O0020140107000700092O003001070002000200068201070088000100010004E03O008800012O006A010700063O0006A3000700E805013O0004E03O00E80501001228000700014O0074000800093O0026BF00070095000100260004E03O009500012O006A010A00084O00B1000A000100022O008D0109000A3O00068201090093000100010004E03O00930001002E8F002800E8050100270004E03O00E805012O003A000900023O0004E03O00E80501002EE8002A00DB000100290004E03O00DB00010026BF000700DB0001001A0004E03O00DB00012O006A010A00024O0070000B00033O00122O000C002B3O00122O000D002C6O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A00A700013O0004E03O00A700012O006A010A000A3O00266A000A00A70001002E0004E03O00A700012O0047000A6O0099000A00014O0065010A00094O006A010A000C3O002022000A000A002F4O000C00023O00202O000C000C00304O000A000C000200262O000A00BA0001001A0004E03O00BA00012O006A010A00024O0025000B00033O00122O000C00313O00122O000D00326O000B000D00024O000A000A000B00202O000A000A00334O000A0002000200262O000A00BB0001001A0004E03O00BB00012O0047000A6O0099000A00014O0065010A000B4O006A010A00053O0020D4000A000A00342O006A010B5O00208F010B000B00354O000D00023O00202O000D000D00364O000B000D000200062O000B00D5000100010004E03O00D500012O006A010B5O00208F010B000B00354O000D00023O00202O000D000D00374O000B000D000200062O000B00D5000100010004E03O00D500012O006A010B5O00208F010B000B00354O000D00023O00202O000D000D00384O000B000D000200062O000B00D5000100010004E03O00D500012O006A010B000D4O0030010A000200022O008D0108000A3O0006A3000800DA00013O0004E03O00DA00012O003A000800023O001228000700393O002E8F003A00C82O01003B0004E03O00C82O010026BF000700C82O0100010004E03O00C82O01001228000A00013O00260C010A00E40001001A0004E03O00E40001002EE8003C00232O01003D0004E03O00232O01002EE8003E00042O01003F0004E03O00042O012O006A010B000E3O0006A3000B00042O013O0004E03O00042O01001228000B00014O0074000C000C3O002EE8004100EB000100400004E03O00EB00010026BF000B00EB000100010004E03O00EB0001001228000C00013O0026BF000C00F0000100010004E03O00F000012O006A010D00053O002001000D000D00424O000E00023O00202O000E000E00434O000F000F3O00202O000F000F004400122O001000456O000D001000024O0009000D3O002E2O00460009000100460004E03O00042O010006A3000900042O013O0004E03O00042O012O003A000900023O0004E03O00042O010004E03O00F000010004E03O00042O010004E03O00EB00012O006A010B00103O000682010B00092O0100010004E03O00092O01002EE8004700222O0100480004E03O00222O01001228000B00014O0074000C000C3O00260C010B000F2O0100010004E03O000F2O01002EE80049000B2O01004A0004E03O000B2O01001228000C00013O0026BF000C00102O0100010004E03O00102O012O006A010D00053O002046010D000D004B4O000E00023O00202O000E000E004C4O000F000F3O00202O000F000F004D00122O0010004E6O000D001000024O0009000D3O00062O000900222O013O0004E03O00222O012O003A000900023O0004E03O00222O010004E03O00102O010004E03O00222O010004E03O000B2O01001228000A00393O0026BF000A00272O0100390004E03O00272O010012280007001A3O0004E03O00C82O0100260C010A002B2O0100010004E03O002B2O01002EE8004F00E0000100500004E03O00E000012O006A010B5O002014010B000B00512O0030010B00020002000682010B009F2O0100010004E03O009F2O012O006A010B5O002014010B000B00522O0030010B00020002000682010B009F2O0100010004E03O009F2O01001228000B00014O0074000C000D3O0026BF000B00972O01001A0004E03O00972O01000E91011A003D2O01000C0004E03O003D2O01002E8F005400642O0100530004E03O00642O01001228000E00014O0074000F000F3O00260C010E00432O0100010004E03O00432O01002E8F0056003F2O0100550004E03O003F2O01001228000F00013O0026BF000F00482O01001A0004E03O00482O01001228000C00393O0004E03O00642O01002E8F005800442O0100570004E03O00442O010026BF000F00442O0100010004E03O00442O01001228001000013O002E8F005A00532O0100590004E03O00532O010026BF001000532O01001A0004E03O00532O01001228000F001A3O0004E03O00442O010026BF0010004D2O0100010004E03O004D2O012O006A011100053O00206700110011005B4O001200023O00202O00120012005C00122O0013005D6O0011001300024O000D00113O00062O000D005F2O013O0004E03O005F2O012O003A000D00023O0012280010001A3O0004E03O004D2O010004E03O00442O010004E03O00642O010004E03O003F2O01002E8F005E00792O01005F0004E03O00792O010026BF000C00792O0100390004E03O00792O012O006A010E00053O0020C7000E000E00604O000F00023O00202O000F000F006100122O001000456O001100016O001200116O0013000F3O00202O0013001300624O000E001300024O000D000E3O000682010D00772O0100010004E03O00772O01002EE80064009F2O0100630004E03O009F2O012O003A000D00023O0004E03O009F2O0100260C010C007D2O0100010004E03O007D2O01002E8F006500392O0100660004E03O00392O01001228000E00013O002E8F006800842O0100670004E03O00842O010026BF000E00842O01001A0004E03O00842O01001228000C001A3O0004E03O00392O0100260C010E00882O0100010004E03O00882O01002E8F006A007E2O0100690004E03O007E2O012O006A010F00053O002042010F000F00604O001000023O00202O00100010006100122O0011005D6O001200016O000F001200024O000D000F3O00062O000D00932O013O0004E03O00932O012O003A000D00023O001228000E001A3O0004E03O007E2O010004E03O00392O010004E03O009F2O01002E8F000D00372O01006B0004E03O00372O010026BF000B00372O0100010004E03O00372O01001228000C00014O0074000D000D3O001228000B001A3O0004E03O00372O01002E8F006D00C62O01006C0004E03O00C62O012O006A010B00123O0006A3000B00C62O013O0004E03O00C62O012O006A010B00013O0006A3000B00B92O013O0004E03O00B92O012O006A010B00043O0006A3000B00B92O013O0004E03O00B92O012O006A010B00024O0070000C00033O00122O000D006E3O00122O000E006F6O000C000E00024O000B000B000C00202O000B000B000C4O000B0002000200062O000B00B92O013O0004E03O00B92O012O006A010B00053O0020D4000B000B00702O00B1000B00010002000682010B00BB2O0100010004E03O00BB2O01002EE8007100C62O0100720004E03O00C62O012O006A010B00134O006A010C000F3O0020D4000C000C00732O0030010B000200020006A3000B00C62O013O0004E03O00C62O012O006A010B00033O001228000C00743O001228000D00754O0049010B000D4O0010000B5O001228000A001A3O0004E03O00E000010026BF000700D2020100040004E03O00D202010006A3000900CD2O013O0004E03O00CD2O012O003A000900024O006A010A00024O0070000B00033O00122O000C00763O00122O000D00776O000B000D00024O000A000A000B00202O000A000A00784O000A0002000200062O000A000102013O0004E03O000102012O006A010A00144O006A010B00023O0020D4000B000B00382O0030010A000200020006A3000A000102013O0004E03O000102012O006A010A00024O0070000B00033O00122O000C00793O00122O000D007A6O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A000102013O0004E03O000102012O006A010A00053O0020EE000A000A007B4O000B00023O00202O000B000B00384O000C00156O000D00033O00122O000E007C3O00122O000F007D6O000D000F00024O000E00166O000F00174O006A0110000C3O00201100100010007E00122O0012007F6O0010001200024O001000106O000A0010000200062O000A00FC2O0100010004E03O00FC2O01002EA701800007000100810004E03O000102012O006A010A00033O001228000B00823O001228000C00834O0049010A000C4O0010000A6O006A010A00024O0070000B00033O00122O000C00843O00122O000D00856O000B000D00024O000A000A000B00202O000A000A000C4O000A0002000200062O000A006C02013O0004E03O006C02012O006A010A5O002064010A000A00864O000C00023O00202O000C000C00874O000A000C000200062O000A006C02013O0004E03O006C02012O006A010A5O002077010A000A00884O000C00023O00202O000C000C00894O000A000C000200262O000A006C020100040004E03O006C02012O006A010A00144O006A010B00023O0020D4000B000B008A2O0030010A000200020006A3000A006C02013O0004E03O006C02012O006A010A5O002067010A000A008B4O000A000200024O000B00183O00122O000C00396O000D00196O000E5O00202O000E000E00354O001000023O00202O00100010008C4O000E00106O000D8O000B3O00024O000C001A3O00122O000D00396O000E00196O000F5O00202O000F000F00354O001100023O00202O00110011008C4O000F00116O000E8O000C3O00024O000B000B000C00062O000B006C0201000A0004E03O006C02012O006A010A00024O00A4000B00033O00122O000C008D3O00122O000D008E6O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A004D020100010004E03O004D02012O006A010A00024O0070000B00033O00122O000C008F3O00122O000D00906O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A006902013O0004E03O006902012O006A010A00024O00A4000B00033O00122O000C00913O00122O000D00926O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A0061020100010004E03O006102012O006A010A00024O0070000B00033O00122O000C00933O00122O000D00946O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A006902013O0004E03O006902012O006A010A001B3O0020D4000A000A00952O00B1000A00010002000E5E019600690201000A0004E03O006902012O006A010A000D3O0006A3000A006C02013O0004E03O006C02012O006A010A000B3O0006A3000A006E02013O0004E03O006E0201002E8F00970088020100980004E03O008802012O006A010A00053O00208C000A000A007B4O000B00023O00202O000B000B008A4O000C001C6O000D00033O00122O000E00993O00122O000F009A6O000D000F00024O000E001D6O000F000F6O0010000C3O00202O00100010009B00122O001200966O0010001200024O001000106O000A0010000200062O000A0083020100010004E03O00830201002EA7019C00070001009D0004E03O008802012O006A010A00033O001228000B009E3O001228000C009F4O0049010A000C4O0010000A6O006A010A00024O0070000B00033O00122O000C00A03O00122O000D00A16O000B000D00024O000A000A000B00202O000A000A00784O000A0002000200062O000A00D102013O0004E03O00D102012O006A010A00024O0070000B00033O00122O000C00A23O00122O000D00A36O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A00D102013O0004E03O00D102012O006A010A00024O0070000B00033O00122O000C00A43O00122O000D00A56O000B000D00024O000A000A000B00202O000A000A00A64O000A0002000200062O000A00D102013O0004E03O00D102012O006A010A5O002014010A000A008B2O0030010A00020002000E2E011A00AE0201000A0004E03O00AE02012O006A010A001E3O00260C010A00B60201001A0004E03O00B602012O006A010A5O002014010A000A008B2O0030010A00020002000E2E013900D10201000A0004E03O00D102012O006A010A001E3O000E2E013900D10201000A0004E03O00D102012O006A010A00024O00A4000B00033O00122O000C00A73O00122O000D00A86O000B000D00024O000A000A000B00202O000A000A002D4O000A0002000200062O000A00D1020100010004E03O00D102012O006A010A00134O00D3000B00023O00202O000B000B00A94O000C000C3O00202O000C000C007E00122O000E00456O000C000E00024O000C000C6O000D00016O000A000D000200062O000A00D102013O0004E03O00D102012O006A010A00033O001228000B00AA3O001228000C00AB4O0049010A000C4O0010000A5O001228000700AC3O0026BF0007007C030100960004E03O007C0301001228000A00013O0026BF000A00230301001A0004E03O002303012O006A010B001E3O00260C010B00DC020100390004E03O00DC0201002EA7012A001F000100AD0004E03O00F90201001228000B00014O0074000C000D3O002E8F00AE00F1020100AF0004E03O00F10201000E51011A00F10201000B0004E03O00F10201002E8F00B100E2020100B00004E03O00E202010026BF000C00E2020100010004E03O00E202012O006A010E001F4O00B1000E000100022O008D010D000E3O000682010D00ED020100010004E03O00ED0201002EE800B200F9020100B30004E03O00F902012O003A000D00023O0004E03O00F902010004E03O00E202010004E03O00F9020100260C010B00F5020100010004E03O00F50201002E8F00B400DE020100B50004E03O00DE0201001228000C00014O0074000D000D3O001228000B001A3O0004E03O00DE02012O006A010B001E3O00260C010B00FD0201001A0004E03O00FD02010004E03O00220301001228000B00014O0074000C000E3O00260C010B002O030100010004E03O002O0301002EE800B70006030100B60004E03O00060301001228000C00014O0074000D000D3O001228000B001A3O002E8F00B800FF020100B90004E03O00FF0201000E51011A00FF0201000B0004E03O00FF02012O0074000E000E3O0026BF000C001A0301001A0004E03O001A0301000E912O0100110301000D0004E03O00110301002EE800BA000D030100BB0004E03O000D03012O006A010F00204O00B1000F000100022O008D010E000F3O0006A3000E002203013O0004E03O002203012O003A000E00023O0004E03O002203010004E03O000D03010004E03O002203010026BF000C000B030100010004E03O000B0301001228000D00014O0074000E000E3O001228000C001A3O0004E03O000B03010004E03O002203010004E03O00FF0201001228000A00393O0026BF000A0077030100010004E03O007703012O006A010B001E3O00260C010B0029030100BC0004E03O002903010004E03O00440301001228000B00014O0074000C000D3O002EA701BD0007000100BD0004E03O003203010026BF000B0032030100010004E03O00320301001228000C00014O0074000D000D3O001228000B001A3O0026BF000B002B0301001A0004E03O002B0301002EE800BF0034030100BE0004E03O003403010026BF000C0034030100010004E03O003403012O006A010E00214O00B1000E000100022O008D010D000E3O000682010D003F030100010004E03O003F0301002E8F00C10044030100C00004E03O004403012O003A000D00023O0004E03O004403010004E03O003403010004E03O004403010004E03O002B03012O006A010B001E3O0026BF000B0076030100040004E03O00760301001228000B00014O0074000C000E3O0026BF000B004E030100010004E03O004E0301001228000C00014O0074000D000D3O001228000B001A3O000E51011A00490301000B0004E03O004903012O0074000E000E3O00260C010C0055030100010004E03O00550301002E8F00C20062030100C30004E03O00620301001228000F00013O0026BF000F005B030100010004E03O005B0301001228000D00014O0074000E000E3O001228000F001A3O002EE800C50056030100C40004E03O00560301000E51011A00560301000F0004E03O00560301001228000C001A3O0004E03O006203010004E03O00560301000E51011A00510301000C0004E03O00510301000E912O0100680301000D0004E03O00680301002EA701C600FEFF2O00C70004E03O006403012O006A010F00224O00B1000F000100022O008D010E000F3O002E8F00C80076030100C90004E03O007603010006A3000E007603013O0004E03O007603012O003A000E00023O0004E03O007603010004E03O006403010004E03O007603010004E03O005103010004E03O007603010004E03O00490301001228000A001A3O0026BF000A00D5020100390004E03O00D50201001228000700263O0004E03O007C03010004E03O00D502010026BF0007007F050100AC0004E03O007F0501001228000A00013O00260C010A00830301001A0004E03O00830301002E8F00CB00E1040100CA0004E03O00E10401002EA701CC00342O0100CC0004E03O00B704012O006A010B5O002064010B000B00354O000D00023O00202O000D000D00874O000B000D000200062O000B00B704013O0004E03O00B70401001228000B00014O0074000C000D3O0026BF000B00AF0401001A0004E03O00AF040100260C010C0094030100010004E03O00940301002EE800CE0090030100CD0004E03O00900301001228000D00013O0026BF000D00D1030100390004E03O00D103012O006A010E001E3O00260C010E009C030100390004E03O009C0301002E8F00D000B3030100CF0004E03O00B30301001228000E00014O0074000F00103O0026BF000E00A3030100010004E03O00A30301001228000F00014O0074001000103O001228000E001A3O0026BF000E009E0301001A0004E03O009E03010026BF000F00A5030100010004E03O00A503012O006A011100234O00B10011000100022O008D011000113O002EA701D10009000100D10004E03O00B303010006A3001000B303013O0004E03O00B303012O003A001000023O0004E03O00B303010004E03O00A503010004E03O00B303010004E03O009E0301002EA701D20006000100D20004E03O00B903012O006A010E001E3O00260C010E00B90301001A0004E03O00B903010004E03O00B70401001228000E00014O0074000F00103O000E912O0100BF0301000E0004E03O00BF0301002E8F00D400C2030100D30004E03O00C20301001228000F00014O0074001000103O001228000E001A3O0026BF000E00BB0301001A0004E03O00BB03010026BF000F00C4030100010004E03O00C403012O006A011100244O00B10011000100022O008D011000113O0006A3001000B704013O0004E03O00B704012O003A001000023O0004E03O00B704010004E03O00C403010004E03O00B704010004E03O00BB03010004E03O00B704010026BF000D00360401001A0004E03O00360401001228000E00013O0026BF000E00D80301001A0004E03O00D80301001228000D00393O0004E03O00360401002EE800D500D4030100D60004E03O00D403010026BF000E00D4030100010004E03O00D403012O006A010F001E3O00260C010F00E0030100AC0004E03O00E003010004E03O00050401001228000F00014O0074001000113O002E8F00D600F5030100D70004E03O00F503010026BF000F00F50301001A0004E03O00F50301002EA701D83O000100D80004E03O00E603010026BF001000E6030100010004E03O00E603012O006A011200254O00B10012000100022O008D011100123O002E8F00D90005040100DA0004E03O000504010006A30011000504013O0004E03O000504012O003A001100023O0004E03O000504010004E03O00E603010004E03O000504010026BF000F00E2030100010004E03O00E20301001228001200013O000E91011A00FC030100120004E03O00FC0301002E8F00DC00FE030100DB0004E03O00FE0301001228000F001A3O0004E03O00E203010026BF001200F8030100010004E03O00F80301001228001000014O0074001100113O0012280012001A3O0004E03O00F803010004E03O00E203012O006A010F001E3O00260C010F0009040100040004E03O000904010004E03O00340401001228000F00014O0074001000123O000E51011A002E0401000F0004E03O002E04012O0074001200123O00260C01100012040100010004E03O00120401002EE8009D001F040100DD0004E03O001F0401001228001300013O002E8F00DE0019040100DF0004E03O001904010026BF001300190401001A0004E03O001904010012280010001A3O0004E03O001F04010026BF00130013040100010004E03O00130401001228001100014O0074001200123O0012280013001A3O0004E03O001304010026BF0010000E0401001A0004E03O000E04010026BF00110021040100010004E03O002104012O006A011300264O00B10013000100022O008D011200133O0006A30012003404013O0004E03O003404012O003A001200023O0004E03O003404010004E03O002104010004E03O003404010004E03O000E04010004E03O003404010026BF000F000B040100010004E03O000B0401001228001000014O0074001100113O001228000F001A3O0004E03O000B0401001228000E001A3O0004E03O00D40301002EE800E10095030100E00004E03O009503010026BF000D0095030100010004E03O00950301001228000E00014O0074000F000F3O0026BF000E003C040100010004E03O003C0401001228000F00013O00260C010F00430401001A0004E03O00430401002E8F00E20045040100E30004E03O00450401001228000D001A3O0004E03O0095030100260C010F0049040100010004E03O00490401002E8F00E4003F040100E50004E03O003F0401001228001000013O0026BF0010004E0401001A0004E03O004E0401001228000F001A3O0004E03O003F0401002E8F00E6004A040100E70004E03O004A04010026BF0010004A040100010004E03O004A0401002EA701E80024000100E80004E03O007604012O006A01115O0020140111001100E92O00300111000200020006A30011007604013O0004E03O00760401001228001100014O0074001200133O00260C0111005F040100010004E03O005F0401002EA701EA0005000100EB0004E03O00620401001228001200014O0074001300133O0012280011001A3O002E8F00EC005B040100ED0004E03O005B04010026BF0011005B0401001A0004E03O005B0401000E912O01006A040100120004E03O006A0401002E8F00EE0066040100EF0004E03O006604012O006A011400274O00B10014000100022O008D011300143O00068201130071040100010004E03O00710401002EE800F00076040100CE0004E03O007604012O003A001300023O0004E03O007604010004E03O006604010004E03O007604010004E03O005B04012O006A0111001E3O000E3A01AC00A6040100110004E03O00A60401001228001100014O0074001200143O0026BF001100A00401001A0004E03O00A004012O0074001400143O0026BF0012008D040100010004E03O008D0401001228001500013O00260C011500850401001A0004E03O00850401002E8F00F20087040100F10004E03O008704010012280012001A3O0004E03O008D04010026BF00150081040100010004E03O00810401001228001300014O0074001400143O0012280015001A3O0004E03O008104010026BF0012007E0401001A0004E03O007E0401002E8F00F4008F040100F30004E03O008F04010026BF0013008F040100010004E03O008F04012O006A011500284O00B10015000100022O008D011400153O002EA701F50010000100F50004E03O00A604010006A3001400A604013O0004E03O00A604012O003A001400023O0004E03O00A604010004E03O008F04010004E03O00A604010004E03O007E04010004E03O00A604010026BF0011007B040100010004E03O007B0401001228001200014O0074001300133O0012280011001A3O0004E03O007B04010012280010001A3O0004E03O004A04010004E03O003F04010004E03O009503010004E03O003C04010004E03O009503010004E03O00B704010004E03O009003010004E03O00B70401002EE800F7008E030100F60004E03O008E03010026BF000B008E030100010004E03O008E0301001228000C00014O0074000D000D3O001228000B001A3O0004E03O008E03012O006A010B001E3O002629010B00BB040100AC0004E03O00BB04010004E03O00E00401001228000B00014O0074000C000E3O0026BF000B00DA0401001A0004E03O00DA04012O0074000E000E3O002EA701F80013000100F80004E03O00D304010026BF000C00D30401001A0004E03O00D3040100260C010D00C8040100010004E03O00C80401002EA701F900FEFF2O00FA0004E03O00C404012O006A010F00294O00B1000F000100022O008D010E000F3O000682010E00CF040100010004E03O00CF0401002EE800FC00E0040100FB0004E03O00E004012O003A000E00023O0004E03O00E004010004E03O00C404010004E03O00E004010026BF000C00C0040100010004E03O00C00401001228000D00014O0074000E000E3O001228000C001A3O0004E03O00C004010004E03O00E004010026BF000B00BD040100010004E03O00BD0401001228000C00014O0074000D000D3O001228000B001A3O0004E03O00BD0401001228000A00393O002EE800FD00E7040100FE0004E03O00E704010026BF000A00E7040100390004E03O00E70401001228000700963O0004E03O007F0501000E512O01007F0301000A0004E03O007F03012O006A010B002A3O0006A3000B00F604013O0004E03O00F604012O006A010B00024O0070000C00033O00122O000D00FF3O00122O000E2O00015O000C000E00024O000B000B000C00202O000B000B002D4O000B0002000200062O000B00FA04013O0004E03O00FA0401001228000B00173O001228000C002O012O000603000C00380501000B0004E03O00380501001228000B00014O0074000C000E3O001228000F0002012O00122800100003012O0006D7000F0006050100100004E03O00060501001228000F00013O000622010F00060501000B0004E03O00060501001228000C00014O0074000D000D3O001228000B001A3O001228000F001A3O000622010F00FC0401000B0004E03O00FC04012O0074000E000E3O001228000F001A3O000622010F001D0501000C0004E03O001D0501001228000F00013O00068C010D00140501000F0004E03O00140501001228000F0004012O00122800100005012O0006D70010000D0501000F0004E03O000D05012O006A010F002B4O00B1000F000100022O008D010E000F3O0006A3000E003805013O0004E03O003805012O003A000E00023O0004E03O003805010004E03O000D05010004E03O00380501001228000F00013O000622010C000A0501000F0004E03O000A0501001228000F00013O0012280010001A3O00068C010F0028050100100004E03O0028050100122800100006012O00122800110007012O0006D70010002A050100110004E03O002A0501001228000C001A3O0004E03O000A050100122800100008012O00122800110008012O00062201100021050100110004E03O00210501001228001000013O000622010F0021050100100004E03O00210501001228000D00014O0074000E000E3O001228000F001A3O0004E03O002105010004E03O000A05010004E03O003805010004E03O00FC04012O006A010B002A3O0006A3000B004505013O0004E03O004505012O006A010B00024O00A4000C00033O00122O000D0009012O00122O000E000A015O000C000E00024O000B000B000C00202O000B000B002D4O000B0002000200062O000B0049050100010004E03O00490501001228000B000B012O001228000C000C012O000622010B007D0501000C0004E03O007D0501001228000B00014O0074000C000E3O001228000F00013O000622010B00510501000F0004E03O00510501001228000C00014O0074000D000D3O001228000B001A3O001228000F000D012O0012280010000E012O0006D70010004B0501000F0004E03O004B0501001228000F001A3O000622010B004B0501000F0004E03O004B05012O0074000E000E3O001228000F000F012O00122800100010012O0006D7001000700501000F0004E03O00700501001228000F001A3O000622010C00700501000F0004E03O00700501001228000F00013O000622010D00600501000F0004E03O006005012O006A010F002C4O0037010F000100024O000E000F3O00122O000F0011012O00122O00100012012O00062O000F007D050100100004E03O007D05010006A3000E007D05013O0004E03O007D05012O003A000E00023O0004E03O007D05010004E03O006005010004E03O007D0501001228000F0013012O00122800100013012O000622010F0059050100100004E03O00590501001228000F00013O000622010C00590501000F0004E03O00590501001228000D00014O0074000E000E3O001228000C001A3O0004E03O005905010004E03O007D05010004E03O004B0501001228000A001A3O0004E03O007F0301001228000A00393O00068C010700860501000A0004E03O00860501001228000A0014012O001228000B0015012O000622010A008A0001000B0004E03O008A0001001228000A00013O001228000B00393O00068C010B008E0501000A0004E03O008E0501001228000B0016012O001228000C0017012O0006D7000C00900501000B0004E03O00900501001228000700043O0004E03O008A0001001228000B001A3O00068C010A00970501000B0004E03O00970501001228000B00E23O001228000C0018012O000622010B00A20501000C0004E03O00A20501001228000B0019012O001228000C0019012O000622010B009E0501000C0004E03O009E05010006A30009009E05013O0004E03O009E05012O003A000900024O006A010B002D4O00B1000B000100022O008D0109000B3O001228000A00393O001228000B00013O00068C010A00A90501000B0004E03O00A90501001228000B001A012O001228000C001B012O0006D7000C00870501000B0004E03O008705012O006A010B001B3O0020D4000B000B00952O00B1000B00010002001228000C00AC3O000603000B00CD0501000C0004E03O00CD05012O006A010B5O0012D5000D001C015O000B000B000D4O000B0002000200122O000C00963O00062O000B00CD0501000C0004E03O00CD05012O006A010B00024O00A4000C00033O00122O000D001D012O00122O000E001E015O000C000E00024O000B000B000C00202O000B000B002D4O000B0002000200062O000B00CD050100010004E03O00CD05012O006A010B000D3O0006A3000B00D105013O0004E03O00D105012O006A010B00024O0070000C00033O00122O000D001F012O00122O000E0020015O000C000E00024O000B000B000C00202O000B000B002D4O000B0002000200062O000B00D105013O0004E03O00D10501001228000B0021012O001228000C0022012O000603000B00E20501000C0004E03O00E20501001228000B00014O0074000C000C3O001228000D0023012O001228000E0024012O0006D7000E00D30501000D0004E03O00D30501001228000D00013O000622010D00D30501000B0004E03O00D305012O006A010D002E4O00B1000D000100022O008D010C000D3O0006A3000C00E205013O0004E03O00E205012O003A000C00023O0004E03O00E205010004E03O00D305012O006A010B002F4O00B1000B000100022O008D0109000B3O001228000A001A3O0004E03O008705010004E03O008A00010012280006001A3O0004E03O005C00010004E03O005300010004E03O00ED05010004E03O004E000100122800040025012O00122800050025012O00062201040048000100050004E03O004800010012280004001A3O00062201030048000100040004E03O004800012O006A010400304O000D010500023O00122O00060026015O0005000500064O00040002000200062O0004004707013O0004E03O004707012O006A010400033O00121F01050027012O00122O00060028015O000400066O00045O00044O004707010004E03O004800010004E03O004707010004E03O004500010004E03O00470701001228000200013O0006222O010045060100020004E03O00450601001228000200013O001228000300393O0006220102000E060100030004E03O000E06010012280001001A3O0004E03O004506010012280003001A3O00068C01020015060100030004E03O0015060100122800030029012O0012280004002A012O0006030004002E060100030004E03O002E06010012780103002B013O0044000400033O00122O0005002C012O00122O0006002D015O0004000600024O0003000300044O000400033O00122O0005002E012O00122O0006002F015O0004000600022O00320103000300042O0065010300313O0012780103002B013O0044000400033O00122O00050030012O00122O00060031015O0004000600024O0003000300044O000400033O00122O00050032012O00122O00060033015O0004000600022O00320103000300042O0065010300323O001228000200393O00122800030034012O00122800040035012O00060300030009060100040004E03O00090601001228000300013O00062201030009060100020004E03O000906012O006A010300334O00790103000100010012780103002B013O0044000400033O00122O00050036012O00122O00060037015O0004000600024O0003000300044O000400033O00122O00050038012O00122O00060039015O0004000600022O00320103000300042O0065010300063O0012280002001A3O0004E03O00090601001228000200393O0006222O0100F1060100020004E03O00F10601001228000200013O0012280003003A012O0012280004003A012O000622010300CF060100040004E03O00CF06010012280003001A3O000622010200CF060100030004E03O00CF0601001228000300013O0012280004001A3O00068C01030058060100040004E03O005806010012280004003B012O0012280005003C012O0006D70005005A060100040004E03O005A0601001228000200393O0004E03O00CF06010012280004003D012O0012280005003E012O00060300050051060100040004E03O00510601001228000400013O00062201030051060100040004E03O005106012O006A010400053O0020D40004000400132O00B10004000100020006820104006B060100010004E03O006B06012O006A01045O0020140104000400092O00300104000200020006A3000400B406013O0004E03O00B40601001228000400014O0074000500063O001228000700013O00062201040073060100070004E03O00730601001228000500014O0074000600063O0012280004001A3O0012280007001A3O00068C0104007A060100070004E03O007A060100122800070004012O001228000800F63O0006220107006D060100080004E03O006D06010012280007003F012O00122800080040012O0006030007007A060100080004E03O007A0601001228000700013O0006220105007A060100070004E03O007A0601001228000600013O0012280007001A3O00068C01060089060100070004E03O0089060100122800070041012O00122800080042012O00060300080096060100070004E03O009606012O006A0107000A3O00122800080043012O00068C0107008E060100080004E03O008E06010004E03O00B406012O006A0107001B3O00123D01080044015O0007000700084O000800156O00098O0007000900024O0007000A3O00044O00B4060100122800070045012O00122800080046012O00060300070082060100080004E03O00820601001228000700013O00062201060082060100070004E03O00820601001228000700013O001228000800013O000622010700A9060100080004E03O00A906012O006A0108001B3O00122100090047015O0008000800094O0008000100024O000800346O000800346O0008000A3O00122O0007001A3O0012280008001A3O0006220107009E060100080004E03O009E06010012280006001A3O0004E03O008206010004E03O009E06010004E03O008206010004E03O00B406010004E03O007A06010004E03O00B406010004E03O006D06012O006A010400053O0020D40004000400132O00B1000400010002000682010400BE060100010004E03O00BE06012O006A01045O0020140104000400092O00300104000200020006A3000400CD06013O0004E03O00CD06012O006A010400024O0023000500033O00122O00060048012O00122O00070049015O0005000700024O00040004000500122O0006004A015O0004000400064O00040002000200122O0005004B012O00062O00040002000100050004E03O00CB06012O004700046O0099000400014O00650104000D3O0012280003001A3O0004E03O00510601001228000300393O000622010200D4060100030004E03O00D40601001228000100043O0004E03O00F10601001228000300013O00068C010200DB060100030004E03O00DB06010012280003004C012O0012280004004D012O00062201030049060100040004E03O004906012O006A010300313O0006A3000300E206013O0004E03O00E206012O006A010300154O00DC000300034O00650103001E3O0004E03O00E406010012280003001A4O00650103001E3O0012280003004E012O0012280004004F012O000603000400EF060100030004E03O00EF06012O006A01035O00122800050050013O00BD0003000300052O00300103000200020006A3000300EF06013O0004E03O00EF06012O003C012O00013O0012280002001A3O0004E03O0049060100122800020051012O00122800030051012O00062201020007000100030004E03O000700010012280002001A3O00062201020007000100010004E03O00070001001228000200014O0074000300033O001228000400013O000622010200FA060100040004E03O00FA0601001228000300013O0012280004001A3O0006220103000E070100040004E03O000E07012O006A01045O00126D00060052015O00040004000600122O000600966O0004000600024O0004001C6O00045O00122O00060052015O00040004000600122O0006005D6O0004000600022O0065010400153O001228000300393O001228000400013O00062201030038070100040004E03O00380701001228000400013O001228000500013O0006220104002E070100050004E03O002E07010012780105002B013O0044000600033O00122O00070053012O00122O00080054015O0006000800024O0005000500064O000600033O00122O00070055012O00122O00080056015O0006000800022O00320105000500062O00650105002A3O0012780105002B013O0044000600033O00122O00070057012O00122O00080058015O0006000800024O0005000500064O000600033O00122O00070059012O00122O0008005A015O0006000800022O00320105000500062O0065010500043O0012280004001A3O0012280005005B012O0012280006005C012O0006D700050012070100060004E03O001207010012280005001A3O00062201040012070100050004E03O001207010012280003001A3O0004E03O003807010004E03O00120701001228000400393O00068C0103003F070100040004E03O003F07010012280004005D012O0012280005005E012O0006D7000400FE060100050004E03O00FE0601001228000100393O0004E03O000700010004E03O00FE06010004E03O000700010004E03O00FA06010004E03O000700010004E03O004707010004E03O000200012O003C012O00017O000F3O00028O00026O00F03F025O00D89C40025O0016A540025O0050AF40025O00F2A140030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03223O00925372DA90B2C18CA0483CF388BDC6C7B31A2D8EC9E183D7F51A5E2OC791C288A87103083O00E7C53A1CBEE7D3AD03053O005072696E7403263O007CDAF6A2D3EC8640D6EAE6E9E2844093EAA9D0EC9E42DCF6E6C6F4CA6EC3F1A584CF8544DED303073O00EA2BB398C6A48D025O00DEB140025O00ACAF4000443O0012283O00014O0074000100023O00260C012O0006000100020004E03O00060001002E8F0004003D000100030004E03O003D000100260C2O01000A000100010004E03O000A0001002EE800050006000100060004E03O00060001001228000200013O0026BF00020015000100020004E03O00150001001278010300073O0020460003000300084O00045O00122O000500093O00122O0006000A6O000400066O00033O000100044O004300010026BF0002000B000100010004E03O000B0001001228000300014O0074000400043O000E512O010019000100030004E03O00190001001228000400013O0026BF00040020000100020004E03O00200001001228000200023O0004E03O000B00010026BF0004001C000100010004E03O001C0001001228000500013O0026BF0005002F000100010004E03O002F00012O006A010600014O00C20006000100014O000600023O00202O00060006000B4O00075O00122O0008000C3O00122O0009000D6O000700096O00063O000100122O000500023O00260C01050033000100020004E03O00330001002E8F000E00230001000F0004E03O00230001001228000400023O0004E03O001C00010004E03O002300010004E03O001C00010004E03O000B00010004E03O001900010004E03O000B00010004E03O004300010004E03O000600010004E03O00430001000E512O01000200013O0004E03O00020001001228000100014O0074000200023O0012283O00023O0004E03O000200012O003C012O00017O00", GetFEnv(), ...);

