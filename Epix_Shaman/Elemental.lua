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
				if (Enum <= 188) then
					if (Enum <= 93) then
						if (Enum <= 46) then
							if (Enum <= 22) then
								if (Enum <= 10) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
												local A = Inst[2];
												do
													return Unpack(Stk, A, A + Inst[3]);
												end
											else
												do
													return;
												end
											end
										elseif (Enum <= 2) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
										elseif (Enum > 3) then
											local A = Inst[2];
											Stk[A](Stk[A + 1]);
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
									elseif (Enum <= 7) then
										if (Enum <= 5) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
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
									elseif (Enum == 9) then
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									else
										local A;
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								elseif (Enum <= 16) then
									if (Enum <= 13) then
										if (Enum <= 11) then
											do
												return Stk[Inst[2]]();
											end
										elseif (Enum == 12) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 15) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 20) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum == 21) then
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
							elseif (Enum <= 34) then
								if (Enum <= 28) then
									if (Enum <= 25) then
										if (Enum <= 23) then
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
										elseif (Enum == 24) then
											local B;
											local A;
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 26) then
										if (Inst[2] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 27) then
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum <= 31) then
									if (Enum <= 29) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									elseif (Enum == 30) then
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
								elseif (Enum <= 32) then
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
								elseif (Enum == 33) then
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
							elseif (Enum <= 40) then
								if (Enum <= 37) then
									if (Enum <= 35) then
										local B;
										local A;
										Stk[Inst[2]] = #Stk[Inst[3]];
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum > 36) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 38) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = Inst[3];
								end
							elseif (Enum <= 43) then
								if (Enum <= 41) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 42) then
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
							elseif (Enum <= 44) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 45) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 69) then
							if (Enum <= 57) then
								if (Enum <= 51) then
									if (Enum <= 48) then
										if (Enum == 47) then
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
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										end
									elseif (Enum <= 49) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										do
											return Stk[Inst[2]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum > 50) then
										local B;
										local A;
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
								elseif (Enum <= 54) then
									if (Enum <= 52) then
										local B;
										local A;
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
									elseif (Enum > 53) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 55) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum > 56) then
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
									do
										return;
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								end
							elseif (Enum <= 63) then
								if (Enum <= 60) then
									if (Enum <= 58) then
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
									elseif (Enum > 59) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
								elseif (Enum <= 61) then
									if (Stk[Inst[2]] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 62) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 66) then
								if (Enum <= 64) then
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
								elseif (Enum > 65) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 68) then
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
						elseif (Enum <= 81) then
							if (Enum <= 75) then
								if (Enum <= 72) then
									if (Enum <= 70) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 71) then
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
								elseif (Enum <= 73) then
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								elseif (Enum > 74) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								end
							elseif (Enum <= 78) then
								if (Enum <= 76) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum > 77) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 79) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 80) then
								local A;
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 87) then
							if (Enum <= 84) then
								if (Enum <= 82) then
									do
										return Stk[Inst[2]];
									end
								elseif (Enum == 83) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 86) then
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
							end
						elseif (Enum <= 90) then
							if (Enum <= 88) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 89) then
								if (Inst[2] <= Inst[4]) then
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
						elseif (Enum <= 91) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 92) then
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 140) then
						if (Enum <= 116) then
							if (Enum <= 104) then
								if (Enum <= 98) then
									if (Enum <= 95) then
										if (Enum > 94) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 97) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 101) then
									if (Enum <= 99) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 100) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 102) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 103) then
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
							elseif (Enum <= 110) then
								if (Enum <= 107) then
									if (Enum <= 105) then
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
									elseif (Enum == 106) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 109) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
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
							elseif (Enum <= 113) then
								if (Enum <= 111) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 114) then
								local B;
								local A;
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
							elseif (Enum == 115) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 128) then
							if (Enum <= 122) then
								if (Enum <= 119) then
									if (Enum <= 117) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 118) then
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
											if (Mvm[1] == 181) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 121) then
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
								if (Enum <= 123) then
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
								elseif (Enum == 124) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 126) then
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
							elseif (Enum > 127) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 134) then
							if (Enum <= 131) then
								if (Enum <= 129) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 130) then
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
							elseif (Enum <= 132) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							elseif (Enum == 133) then
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
						elseif (Enum <= 137) then
							if (Enum <= 135) then
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
							elseif (Enum > 136) then
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
						elseif (Enum <= 138) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 139) then
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
						if (Enum <= 152) then
							if (Enum <= 146) then
								if (Enum <= 143) then
									if (Enum <= 141) then
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
									elseif (Enum > 142) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 145) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								else
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 149) then
								if (Enum <= 147) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 148) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
							elseif (Enum <= 150) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 151) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 158) then
							if (Enum <= 155) then
								if (Enum <= 153) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								elseif (Enum == 154) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
								end
							elseif (Enum <= 156) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							end
						elseif (Enum <= 161) then
							if (Enum <= 159) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							elseif (Enum == 160) then
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
						elseif (Enum <= 162) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 163) then
							local B;
							local A;
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 176) then
						if (Enum <= 170) then
							if (Enum <= 167) then
								if (Enum <= 165) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 168) then
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 169) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 173) then
							if (Enum <= 171) then
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
							elseif (Enum == 172) then
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
						elseif (Enum <= 174) then
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
						elseif (Enum == 175) then
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 182) then
						if (Enum <= 179) then
							if (Enum <= 177) then
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
							elseif (Enum == 178) then
								if (Inst[2] > Stk[Inst[4]]) then
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
						elseif (Enum <= 180) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 181) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
						end
					elseif (Enum <= 185) then
						if (Enum <= 183) then
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
						elseif (Enum == 184) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 186) then
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
						VIP = VIP + 1;
						Inst = Instr[VIP];
						do
							return Stk[Inst[2]];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						VIP = Inst[3];
					elseif (Enum > 187) then
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
						B = Stk[Inst[4]];
						if B then
							VIP = VIP + 1;
						else
							Stk[Inst[2]] = B;
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 282) then
					if (Enum <= 235) then
						if (Enum <= 211) then
							if (Enum <= 199) then
								if (Enum <= 193) then
									if (Enum <= 190) then
										if (Enum > 189) then
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
									elseif (Enum <= 191) then
										local B;
										local A;
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
									elseif (Enum == 192) then
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
								elseif (Enum <= 196) then
									if (Enum <= 194) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									elseif (Enum == 195) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 197) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 205) then
								if (Enum <= 202) then
									if (Enum <= 200) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 201) then
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 204) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 208) then
								if (Enum <= 206) then
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
								elseif (Enum == 207) then
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 209) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 210) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 223) then
							if (Enum <= 217) then
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
									elseif (Enum == 213) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 216) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 221) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 222) then
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
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
							end
						elseif (Enum <= 229) then
							if (Enum <= 226) then
								if (Enum <= 224) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Enum > 225) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum <= 227) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 228) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 232) then
							if (Enum <= 230) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
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
						elseif (Enum <= 233) then
							if (Inst[2] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 234) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						end
					elseif (Enum <= 258) then
						if (Enum <= 246) then
							if (Enum <= 240) then
								if (Enum <= 237) then
									if (Enum == 236) then
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 238) then
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
							elseif (Enum <= 243) then
								if (Enum <= 241) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 242) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 244) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
						elseif (Enum <= 252) then
							if (Enum <= 249) then
								if (Enum <= 247) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 248) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 250) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 251) then
								local A = Inst[2];
								local Results = {Stk[A]()};
								local Limit = Inst[4];
								local Edx = 0;
								for Idx = A, Limit do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 255) then
							if (Enum <= 253) then
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
							elseif (Enum == 254) then
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
						elseif (Enum <= 256) then
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 257) then
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
					elseif (Enum <= 270) then
						if (Enum <= 264) then
							if (Enum <= 261) then
								if (Enum <= 259) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 260) then
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
								end
							elseif (Enum <= 262) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
							elseif (Enum > 263) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 267) then
							if (Enum <= 265) then
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
							elseif (Enum > 266) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 268) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 269) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 276) then
						if (Enum <= 273) then
							if (Enum <= 271) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
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
						elseif (Enum <= 274) then
							Stk[Inst[2]] = not Stk[Inst[3]];
						elseif (Enum > 275) then
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
							Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 279) then
						if (Enum <= 277) then
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
						elseif (Enum == 278) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 280) then
						local A = Inst[2];
						local B = Inst[3];
						for Idx = A, B do
							Stk[Idx] = Vararg[Idx - A];
						end
					elseif (Enum == 281) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Stk[Inst[2]] < Inst[4]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 329) then
					if (Enum <= 305) then
						if (Enum <= 293) then
							if (Enum <= 287) then
								if (Enum <= 284) then
									if (Enum == 283) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 285) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 286) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 290) then
								if (Enum <= 288) then
									Env[Inst[3]] = Stk[Inst[2]];
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
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 291) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 292) then
								if (Inst[2] ~= Inst[4]) then
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
						elseif (Enum <= 299) then
							if (Enum <= 296) then
								if (Enum <= 294) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 297) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 298) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 302) then
							if (Enum <= 300) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 301) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							end
						elseif (Enum <= 303) then
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
						elseif (Enum > 304) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
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
					elseif (Enum <= 317) then
						if (Enum <= 311) then
							if (Enum <= 308) then
								if (Enum <= 306) then
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
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 307) then
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
							elseif (Enum <= 309) then
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum > 310) then
								if (Inst[2] ~= Stk[Inst[4]]) then
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
							if (Enum <= 312) then
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
							elseif (Enum == 313) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 316) then
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
					elseif (Enum <= 323) then
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
								if Stk[Inst[2]] then
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
						elseif (Enum <= 321) then
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
						elseif (Enum > 322) then
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
					elseif (Enum <= 326) then
						if (Enum <= 324) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 325) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 327) then
						if (Inst[2] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 328) then
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
				elseif (Enum <= 353) then
					if (Enum <= 341) then
						if (Enum <= 335) then
							if (Enum <= 332) then
								if (Enum <= 330) then
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
								elseif (Enum > 331) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 333) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 338) then
							if (Enum <= 336) then
								if (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 337) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 339) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 340) then
							Stk[Inst[2]] = Inst[3];
						else
							Stk[Inst[2]]();
						end
					elseif (Enum <= 347) then
						if (Enum <= 344) then
							if (Enum <= 342) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 343) then
								Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
						elseif (Enum <= 345) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 346) then
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
					elseif (Enum <= 350) then
						if (Enum <= 348) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						elseif (Enum > 349) then
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
					elseif (Enum <= 351) then
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 352) then
						if (Inst[2] < Inst[4]) then
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
						A = Inst[2];
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
				elseif (Enum <= 365) then
					if (Enum <= 359) then
						if (Enum <= 356) then
							if (Enum <= 354) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Stk[Inst[3]];
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
							end
						elseif (Enum <= 357) then
							local B;
							local A;
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
						elseif (Enum > 358) then
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
					elseif (Enum <= 362) then
						if (Enum <= 360) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 361) then
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
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 363) then
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
				elseif (Enum <= 371) then
					if (Enum <= 368) then
						if (Enum <= 366) then
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
						elseif (Enum == 367) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 369) then
						local B;
						local A;
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
				elseif (Enum <= 374) then
					if (Enum <= 372) then
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 373) then
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
				elseif (Enum <= 375) then
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
				elseif (Enum == 376) then
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
				elseif (Stk[Inst[2]] < Inst[4]) then
					VIP = Inst[3];
				else
					VIP = VIP + 1;
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503193O00F4D3D23DD988CF1FDCC2D51AC3B7C213D4CDCF24EAF5CB0BD003083O007EB1A3BB4586DBA703193O0014A07EEE0E837FF73CB179C914BC72FB34BE63F73DFE7BE33003043O009651D017002E3O0012193O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004B03O000A0001001239010300063O002092000400030007001239010500083O002092000500050009001239010600083O00209200060006000A00067700073O000100062O00B53O00064O00B58O00B53O00044O00B53O00014O00B53O00024O00B53O00053O00209200080003000B00209200090003000C2O0056000A5O001239010B000D3O000677000C0001000100022O00B53O000A4O00B53O000B4O00B5000D00073O001255010E000E3O001255010F000F4O0062000D000F0002000677000E0002000100032O00B53O00074O00B53O00094O00B53O00084O0010010A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001B00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00CD00076O004A010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00CD000C00034O0041010D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0075010C6O004B010A3O00020020AF000A000A00022O00E00009000A4O003101073O00010004240003000500012O00CD000300054O00B5000400024O008B000300044O00FB00036O00013O00017O001A3O00028O00026O00F03F025O00C8A440025O00A1B040025O00FAA040025O00A88F40025O00DAB040025O00408040025O00049A40025O0060AF40025O0012A340025O00A49340025O009CB040025O00C4B240025O00089140025O0044A940025O006EA840025O00B4A040025O00C2A940025O00F4AB40025O0026A140025O00A2A340025O00AAB040025O00889C40025O00A6A740025O00BAB04001583O001255010200014O00C9000300053O0026D500020007000100010004B03O00070001001255010300014O00C9000400043O001255010200023O0026D500020002000100020004B03O000200012O00C9000500053O002E5001030011000100040004B03O001100010026D500030011000100010004B03O00110001001255010400014O00C9000500053O001255010300023O000E3701020015000100030004B03O00150001002E500105000A000100060004B03O000A0001001255010600013O0026D500060016000100010004B03O001600010026C00004001C000100020004B03O001C0001002E5900070020000100080004B03O002000012O00B5000700054O007900086O00FE00076O00FB00075O002E59000900240001000A0004B03O00240001000E372O010026000100040004B03O00260001002E59000B00150001000C0004B03O00150001001255010700013O002E50010D004B0001000E0004B03O004B0001000E372O01002D000100070004B03O002D0001002E500110004B0001000F0004B03O004B0001001255010800013O002E0001110008000100110004B03O00360001002E0001120006000100120004B03O003600010026D500080036000100020004B03O00360001001255010700023O0004B03O004B0001002E500113002E000100140004B03O002E00010026C00008003C000100010004B03O003C0001002E500116002E000100150004B03O002E00012O00CD00096O0038000500093O002E5001180049000100170004B03O00490001002E50011900490001001A0004B03O004900010006CC00050049000100010004B03O004900012O00CD000900014O00B5000A6O0079000B6O00FE00096O00FB00095O001255010800023O0004B03O002E00010026D500070027000100020004B03O00270001001255010400023O0004B03O001500010004B03O002700010004B03O001500010004B03O001600010004B03O001500010004B03O005700010004B03O000A00010004B03O005700010004B03O000200012O00013O00017O004D3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503093O006BD223EF4557F3FD5403083O009826BD569C2018852O033O00CC52B303043O00269C37C703063O009C7C6E2F166003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C030A3O009643C5B4336320C4B75A03083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D9030C3O0047657454696D656C6F63616C03143O00476574576561706F6E456E6368616E74496E666F03063O00F45C7119B81003063O007EA7341074D903093O00ED22258DB117E8C92203073O009CA84E40E0D47903063O0034E6A4C306E003043O00AE678EC503093O0073245A352050EC572403073O009836483F58453E03063O00E7CCEF51D5CA03043O003CB4A48E03093O007D52002422E306595203073O0072383E6549478D03073O009BE6D6C9B7E7C803043O00A4D889BB03083O00F7F034A0BFF105D703073O006BB28651D2C69E03103O005265676973746572466F724576656E7403243O00A00FF93BD1A413FD3EC6B809FF2DD4B109EE3BC6AD05F733D3A803E32DC4A90DE335C2A503053O0087E14CAD7203143O00F83A26E19859A2EB2C37F69A50B9FD3138E7975E03073O00E6B47F67B3D61C030E3O00BC17564BEB53E485045371E557E503073O0080EC653F26842103163O005265676973746572496E466C69676874452O66656374024O00E8F71341030E3O009CBB1849B9F9CBA5A81D73B7FDCA03073O00AFCCC97124D68B03103O005265676973746572496E466C6967687403093O006BCD23DD2652DE26C803053O006427AC55BC024O0080B3C540028O0003063O0053657441504C025O006070400024023O0037000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0013001300142O004C00145O00122O001500223O00122O001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000F00142O004C00155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O0014001400150012390115002A3O0012390116002B4O00FD001700176O00188O00198O001A8O001B8O001C8O001D005B6O005C5O00122O005D002C3O00122O005E002D4O0062005C005E00022O006D005C000C005C4O005D5O00122O005E002E3O00122O005F002F6O005D005F00024O005C005C005D4O005D5O00122O005E00303O00122O005F00316O005D005F00022O006D005D000E005D4O005E5O00122O005F00323O00122O006000336O005E006000024O005D005D005E4O005E5O00122O005F00343O00122O006000356O005E006000022O0038005E0011005E2O00CD005F5O00128D006000363O00122O006100376O005F006100024O005E005E005F4O005F8O00605O00122O006100383O00122O006200396O0060006200024O0060000F00602O00CD00615O0012550162003A3O0012550163003B4O00620061006300022O003800600060006100067700613O000100032O00B53O005C4O00CD8O00B53O00603O0020BC00620004003C00067700640001000100012O00B53O00614O003E00655O00122O0066003D3O00122O0067003E6O006500676O00623O000100202O00620004003C00067700640002000100022O00B53O005C4O00CD8O004700655O00122O0066003F3O00122O006700406O006500676O00623O00014O00625O00122O006300413O00122O006400426O0062006400024O0062005C00620020BC006200620043001218006400446O0062006400014O00625O00122O006300453O00122O006400466O0062006400024O0062005C006200202O0062006200474O0062000200014O00625O001255016300483O001221006400496O0062006400024O0062005C006200202O0062006200474O00620002000100122O0062004A3O00122O0063004A6O006400673O00122O0068004B3O00122O0069004B3O000677006A0003000100022O00B53O00154O00CD7O000677006B0004000100012O00B53O005C3O000677006C0005000100012O00B53O005C3O000677006D0006000100012O00B53O005C3O000677006E0007000100012O00B53O005C3O000677006F0008000100012O00B53O005C3O00067700700009000100012O00B53O005C3O0006770071000A000100052O00B53O00084O00B53O005C4O00CD3O00014O00CD3O00024O00B53O00693O0006770072000B000100032O00B53O005C4O00CD8O00B53O00083O0006770073000C000100032O00B53O00084O00B53O005C4O00CD7O0006770074000D000100032O00B53O005C4O00CD8O00B53O00083O0006770075000E000100062O00B53O005C4O00CD8O00B53O001C4O00B53O00604O00B53O00124O00B53O005E3O0006770076000F000100062O00B53O005A4O00B53O00084O00B53O005B4O00B53O005C4O00CD8O00B53O00123O00067700770010000100142O00B53O00544O00B53O00084O00B53O00564O00B53O00584O00CD8O00B53O005D4O00B53O00124O00B53O005E4O00B53O005C4O00B53O00404O00B53O00464O00B53O003F4O00B53O00604O00B53O00444O00B53O00454O00B53O00414O00B53O00474O00B53O00484O00B53O00554O00B53O00573O00067700780011000100042O00B53O00174O00B53O00604O00B53O005F4O00B53O001A3O000677007900120001000F2O00B53O005C4O00CD8O00B53O00084O00B53O00294O00B53O003A4O00B53O001B4O00B53O00534O00B53O00634O00B53O00124O00B53O00234O00B53O000B4O00B53O00204O00B53O00284O00B53O00394O00B53O00253O000677007A0013000100312O00B53O005C4O00CD8O00B53O00214O00B53O00604O00B53O00674O00B53O006D4O00B53O000B4O00B53O00084O00B53O006C4O00B53O00284O00B53O00394O00B53O001B4O00B53O006E4O00B53O002F4O00B53O00364O00B53O001A4O00B53O00534O00B53O00634O00B53O003B4O00B53O00124O00B53O005E4O00B53O006B4O00B53O00224O00B53O001D4O00B53O00734O00B53O00244O00B53O00724O00B53O00254O00B53O006A4O00B53O00714O00B53O00134O00B53O00684O00B53O00204O00B53O001F4O00B53O00704O00B53O00234O00B53O00744O00B53O00694O00B53O002D4O00B53O00334O00B53O001E4O00B53O002C4O00B53O002E4O00B53O00344O00B53O00304O00B53O00354O00B53O00294O00B53O003A4O00B53O002A3O000677007B00140001002F2O00B53O005C4O00CD8O00B53O00234O00B53O00124O00B53O000B4O00B53O00224O00B53O00744O00B53O00084O00B53O00714O00B53O00734O00B53O00244O00B53O00684O00B53O00694O00B53O00724O00B53O00264O00B53O002A4O00B53O002F4O00B53O00364O00B53O001A4O00B53O00534O00B53O00634O00B53O003B4O00B53O005E4O00B53O002E4O00B53O00344O00B53O00304O00B53O00354O00B53O00284O00B53O00394O00B53O001B4O00B53O00604O00B53O00674O00B53O006E4O00B53O00254O00B53O006F4O00B53O00104O00B53O001E4O00B53O002C4O00B53O00204O00B53O001F4O00B53O001D4O00B53O002D4O00B53O00334O00B53O006B4O00B53O000A4O00B53O00294O00B53O003A3O000677007C0015000100122O00B53O00424O00B53O005C4O00CD8O00B53O00084O00B53O00434O00B53O00124O00B53O00174O00B53O00764O00B53O00094O00B53O005E4O00B53O00644O00B53O00654O00B53O00164O00B53O002B4O00B53O00184O00B53O00604O00B53O00794O00B53O000B3O000677007D0016000100212O00B53O004E4O00B53O00494O00B53O00174O00B53O00604O00B53O005C4O00B53O005E4O00B53O004A4O00B53O004B4O00B53O004F4O00B53O004D4O00B53O00754O00CD8O00B53O00594O00B53O001C4O00B53O004C4O00B53O00084O00B53O000B4O00B53O00124O00B53O007B4O00B53O00194O00B53O00684O00B53O00694O00B53O007A4O00B53O00274O00B53O00534O00B53O00634O00B53O00324O00B53O00384O00B53O001A4O00B53O00314O00B53O00374O00B53O00784O00B53O00773O000677007E0017000100192O00B53O00284O00CD8O00B53O00264O00B53O00274O00B53O003A4O00B53O001D4O00B53O001E4O00B53O001F4O00B53O00224O00B53O00204O00B53O00304O00B53O00334O00B53O00364O00B53O00344O00B53O00354O00B53O00394O00B53O002D4O00B53O002F4O00B53O002E4O00B53O00234O00B53O00244O00B53O00254O00B53O002B4O00B53O00294O00B53O002A3O000677007F0018000100162O00B53O003C4O00CD8O00B53O003D4O00B53O003E4O00B53O003F4O00B53O00404O00B53O00414O00B53O00444O00B53O00454O00B53O00464O00B53O00474O00B53O00484O00B53O002C4O00B53O003B4O00B53O00424O00B53O00434O00B53O005A4O00B53O005B4O00B53O00594O00B53O00494O00B53O004A4O00B53O004B3O00067700800019000100122O00B53O00374O00CD8O00B53O00384O00B53O00554O00B53O00544O00B53O00534O00B53O00504O00B53O00514O00B53O00524O00B53O004F4O00B53O00314O00B53O00324O00B53O004D4O00B53O004C4O00B53O00574O00B53O00564O00B53O00584O00B53O004E3O0006770081001A0001001E2O00B53O00084O00B53O001C4O00CD8O00B53O001B4O00B53O00664O00B53O00674O00B53O000B4O00B53O00194O00B53O00684O00B53O00694O00B53O007F4O00B53O007E4O00B53O00804O00B53O004D4O00B53O00174O00B53O005C4O00B53O00604O00B53O005E4O00B53O00624O00B53O00044O00B53O00634O00B53O007D4O00B53O007C4O00B53O00754O00B53O004E4O00B53O004B4O00B53O00494O00B53O004A4O00B53O001A4O00B53O00183O0006770082001B000100042O00B53O005C4O00CD8O00B53O00614O00B53O000F3O0020D80083000F004C00122O0084004D6O008500816O008600826O0083008600016O00013O001C3O00093O00030D3O001B0287C7A42B0BB1D6A32A079603053O00CA586EE2A6030B3O004973417661696C61626C65025O0006AA40025O00509D4003123O00E70691E72OCF0383F52OC62B87F5DFC5099103053O00AAA36FE29703173O003539A1284B3B251032BE3D6D223B0235963D4C222F172303073O00497150D2582E5700194O00CD8O0093000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000C000100010004B03O000C0001002E5900040018000100050004B03O001800012O00CD3O00024O0061000100013O00122O000200063O00122O000300076O0001000300024O000200026O000300013O00122O000400083O00122O000500096O0003000500024O0002000200032O00303O000100022O00013O00019O003O00034O00CD8O0054012O000100012O00013O00017O00193O00028O00025O00789B40025O0046A940025O00B08840025O00C09D40025O00BCA740025O00D4A940025O00D89E40025O00EEA940026O00F03F025O00C09440025O00188240025O008AA840025O00F09A40030E3O002AFFB1BDA3AFA313ECB487ADABA203073O00C77A8DD8D0CCDD03163O005265676973746572496E466C69676874452O66656374024O00E8F71341030E3O009DCF19FD77E4A9D411FC4FF7BBD803063O0096CDBD70901803103O005265676973746572496E466C69676874025O00406E40025O00249C4003093O000985A94D269D2O033103083O007045E4DF2C64E87100463O001255012O00014O00C9000100013O0026C03O0006000100010004B03O00060001002E5001030002000100020004B03O000200010012552O0100013O002E000104002E000100040004B03O003500010026D500010035000100010004B03O00350001001255010200014O00C9000300033O002E0001053O000100050004B03O000D0001002E500106000D000100070004B03O000D00010026D50002000D000100010004B03O000D0001001255010300013O002E500108001C000100090004B03O001C00010026C00003001A0001000A0004B03O001A0001002E50010B001C0001000C0004B03O001C00010012552O01000A3O0004B03O003500010026C000030020000100010004B03O00200001002E00010D00F6FF2O000E0004B03O001400012O00CD00046O0057000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O00040004001100122O000600126O0004000600014O00048O000500013O001255010600133O00129E000700146O0005000700024O00040004000500202O0004000400154O00040002000100122O0003000A3O00044O001400010004B03O003500010004B03O000D00010026C0000100390001000A0004B03O00390001002E5001170007000100160004B03O000700012O00CD00026O0051010300013O00122O000400183O00122O000500196O0003000500024O00020002000300202O0002000200154O00020002000100044O004500010004B03O000700010004B03O004500010004B03O000200012O00013O00017O00043O0003063O005368616D616E030E3O008179AA9407FE28EB90308F6DBF8603053O0053CD18D9E0026O004440000C4O009F9O003O0001000200122O000100016O000200013O00122O000300023O00122O000400036O0002000400024O0001000100028O000100104O00044O00523O00024O00013O00017O00023O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O6601063O00202E2O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00053O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F446965026O00144001133O0020B400013O00014O00035O00202O0003000300024O00010003000200062O0001001100013O0004B03O001100010020BC00013O00032O003500035O00202O0003000300024O00010003000200202O00023O00044O00020002000200202O00020002000500062O00010010000100020004B03O001000012O00E100016O00662O0100014O0052000100024O00013O00017O00063O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F446965026O001440028O0001193O0020B400013O00014O00035O00202O0003000300024O00010003000200062O0001001700013O0004B03O001700010020BC00013O00032O001301035O00202O0003000300024O00010003000200202O00023O00044O00020002000200202O00020002000500062O00010015000100020004B03O001500010020BC00013O00032O00CD00035O0020920003000300022O0062000100030002000EA900060016000100010004B03O001600012O00E100016O00662O0100014O0052000100024O00013O00017O00023O00030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O6601063O00202E2O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O66027O0040010A3O0020D700013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004B03O000700012O00E100016O00662O0100014O0052000100024O00013O00017O00023O00030D3O00446562752O6652656D61696E7303123O004C696768746E696E67526F64446562752O6601063O00202E2O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O001A3O00028O00026O00F03F025O003CA540025O0088B240025O00088240025O005EA340025O009AB040025O00F0AB40025O00588D40025O0013B34003093O004D61656C7374726F6D03093O00497343617374696E67025O005C9440030E3O00456C656D656E74616C426C617374025O00C0524003073O0049636566757279026O003940030D3O004C696768746E696E67426F6C74026O002440025O004CAE4003093O004C6176614275727374026O002840030E3O00436861696E4C696768746E696E67025O00689F40025O0082AD40026O00104000883O001255012O00014O00C9000100033O000E472O01000700013O0004B03O000700010012552O0100014O00C9000200023O001255012O00023O002E5900030002000100040004B03O000200010026D53O0002000100020004B03O000200012O00C9000300033O002E5900050013000100060004B03O001300010026D500010013000100010004B03O00130001001255010200014O00C9000300033O0012552O0100023O002E500108000C000100070004B03O000C0001000E470102000C000100010004B03O000C00010026C00002001B000100010004B03O001B0001002E59000A0017000100090004B03O001700012O00CD00045O00206001040004000B4O0004000200024O000300046O00045O00202O00040004000C4O00040002000200062O00040026000100010004B03O002600012O0052000300023O0004B03O00870001002E00010D000C0001000D0004B03O003200012O00CD00045O0020B400040004000C4O000600013O00202O00060006000E4O00040006000200062O0004003200013O0004B03O0032000100205701040003000F2O0052000400023O0004B03O008700012O00CD00045O0020B400040004000C4O000600013O00202O0006000600104O00040006000200062O0004004400013O0004B03O004400012O00CD000400024O0031000500033O00122O000600116O0004000600024O000500036O000600033O00122O000700116O0005000700024O0004000400054O000400023O00044O008700012O00CD00045O0020B400040004000C4O000600013O00202O0006000600124O00040006000200062O0004005600013O0004B03O005600012O00CD000400024O0031000500033O00122O000600136O0004000600024O000500036O000600033O00122O000700136O0005000700024O0004000400054O000400023O00044O00870001002E0001140014000100140004B03O006A00012O00CD00045O0020B400040004000C4O000600013O00202O0006000600154O00040006000200062O0004006A00013O0004B03O006A00012O00CD000400024O0031000500033O00122O000600166O0004000600024O000500036O000600033O00122O000700166O0005000700024O0004000400054O000400023O00044O008700012O00CD00045O00200D00040004000C4O000600013O00202O0006000600174O00040006000200062O00040073000100010004B03O00730001002E5900190080000100180004B03O008000012O00CD000400024O008A000500036O000600043O00102O0006001A00064O0004000600024O000500036O000600036O000700043O00102O0007001A00074O0005000700024O0004000400052O0052000400023O0004B03O008700012O0052000300023O0004B03O008700010004B03O001700010004B03O008700010004B03O000C00010004B03O008700010004B03O000200012O00013O00017O00333O00028O00025O00D1B240025O00E49640026O00F03F025O0068A440025O00488A40025O000CA140025O00E09940025O00588540025O00B0A040025O0022B140025O00108740025O001CB240025O0072A440025O00F49340025O00E08F4003133O00CBC4DE29E3D7C23BF2CDC818EA2OC038E8D1DE03043O005D86A5AD030B3O004973417661696C61626C65025O007FB240026O003840025O00A89940025O00AC9B4003063O0042752O66557003173O004D61737465726F66746865456C656D656E747342752O66025O00D2A340025O00F88440025O00A8A340025O00F8834003093O00497343617374696E67025O00DCA940025O00AAB14003093O004C6176614275727374025O0069B340025O008AA440025O006EB040025O00309A40030E3O00456C656D656E74616C426C617374025O00C08040025O00BEB040025O008AAB40026O00704003073O0049636566757279026O00B340025O00109340025O00DEA540030D3O004C696768746E696E67426F6C74025O0072AF40025O0082AD40025O005EA940030E3O00436861696E4C696768746E696E6700AB3O001255012O00014O00C9000100033O0026C03O0006000100010004B03O00060001002E0001020005000100030004B03O000900010012552O0100014O00C9000200023O001255012O00043O002E5001060002000100050004B03O000200010026D53O0002000100040004B03O000200012O00C9000300033O000E472O01001D000100010004B03O001D0001001255010400013O0026D500040015000100040004B03O001500010012552O0100043O0004B03O001D00010026C000040019000100010004B03O00190001002E5001070011000100080004B03O00110001001255010200014O00C9000300033O001255010400043O0004B03O00110001000E3701040023000100010004B03O00230001002E25010900230001000A0004B03O00230001002E59000B000E0001000C0004B03O000E00010026C000020027000100010004B03O00270001002E59000D00500001000E0004B03O00500001001255010400013O0026C00004002C000100010004B03O002C0001002E59000F004B000100100004B03O004B0001001255010500013O0026D500050031000100040004B03O00310001001255010400043O0004B03O004B00010026D50005002D000100010004B03O002D00012O00CD00066O006E000700013O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600134O00060002000200062O0006004100013O0004B03O00410001002E2501140041000100150004B03O00410001002E5900170043000100160004B03O004300012O006601066O0052000600024O00CD000600023O0020640106000600184O00085O00202O0008000800194O0006000800024O000300063O00122O000500043O0004B03O002D00010026D500040028000100040004B03O00280001001255010200043O0004B03O005000010004B03O00280001002E00011A00D3FF2O001A0004B03O00230001002E50011B00230001001C0004B03O002300010026D500020023000100040004B03O00230001002E00011D00070001001D0004B03O005D00012O00CD000400023O0020BC00040004001E2O002101040002000200066B0104005F00013O0004B03O005F0001002E00011F0004000100200004B03O006100012O0052000300023O0004B03O00AA00012O00CD000400023O00200D00040004001E4O00065O00202O0006000600214O00040006000200062O0004006A000100010004B03O006A0001002E500122006D000100230004B03O006D00012O0066010400014O0052000400023O0004B03O00AA0001002E590025007B000100240004B03O007B00012O00CD000400023O00200D00040004001E4O00065O00202O0006000600264O00040006000200062O00040078000100010004B03O00780001002E590028007B000100270004B03O007B00012O006601046O0052000400023O0004B03O00AA0001002E50012A0084000100290004B03O008400012O00CD000400023O00200D00040004001E4O00065O00202O00060006002B4O00040006000200062O00040086000100010004B03O00860001002E59002C00890001002D0004B03O008900012O006601046O0052000400023O0004B03O00AA0001002E00012E00090001002E0004B03O009200012O00CD000400023O00200D00040004001E4O00065O00202O00060006002F4O00040006000200062O00040094000100010004B03O00940001002E5001300097000100310004B03O009700012O006601046O0052000400023O0004B03O00AA0001002E000132000C000100320004B03O00A300012O00CD000400023O0020B400040004001E4O00065O00202O0006000600334O00040006000200062O000400A300013O0004B03O00A300012O006601046O0052000400023O0004B03O00AA00012O0052000300023O0004B03O00AA00010004B03O002300010004B03O00AA00010004B03O000E00010004B03O00AA00010004B03O000200012O00013O00017O00273O00028O00025O00588240025O0096AB40026O00F03F025O00F88040025O00F0B240026O006540025O00BCA340025O0018AB40025O00E2A640025O00F07540025O0004A84003093O00497343617374696E67025O007EAB40025O00F0A940025O00789840025O00BAA340030B3O0053746F726D6B2O65706572025O0016A140025O00789340025O00D0A840026O00A940025O0030AE40025O00C07C40025O00A88340025O00DC9F40030B3O008DE6CED037C5B77BAEF7D303083O001EDE92A1A25AAED2030B3O004973417661696C61626C65025O00F09940025O0014904003063O0042752O665570030F3O0053746F726D6B2O6570657242752O66025O00708040025O0024A940025O00D2A940025O0066B240025O00C0AA40025O00405640006F3O001255012O00014O00C9000100033O0026C03O0006000100010004B03O00060001002E5001030009000100020004B03O000900010012552O0100014O00C9000200023O001255012O00043O0026C03O000D000100040004B03O000D0001002E00010500F7FF2O00060004B03O000200012O00C9000300033O002E5001070012000100080004B03O00120001000E3701040014000100010004B03O00140001002E00010900500001000A0004B03O00620001002E59000B002F0001000C0004B03O002F00010026D50002002F000100040004B03O002F00012O00CD00045O0020BC00040004000D2O002101040002000200066B0104001F00013O0004B03O001F0001002E59000E00210001000F0004B03O002100012O0052000300023O0004B03O006E0001002E500110002D000100110004B03O002D00012O00CD00045O0020B400040004000D4O000600013O00202O0006000600124O00040006000200062O0004002D00013O0004B03O002D00012O0066010400014O0052000400023O0004B03O006E00012O0052000300023O0004B03O006E00010026C000020033000100010004B03O00330001002E5001130014000100140004B03O00140001001255010400014O00C9000500053O002E0001153O000100150004B03O003500010026D500040035000100010004B03O00350001001255010500013O002E000116001D000100160004B03O005700010026C000050040000100010004B03O00400001002E0001170019000100180004B03O00570001002E50011900500001001A0004B03O005000012O00CD000600014O006E000700023O00122O0008001B3O00122O0009001C6O0007000900024O00060006000700202O00060006001D4O00060002000200062O0006004E00013O0004B03O004E0001002E50011E00500001001F0004B03O005000012O006601066O0052000600024O00CD00065O0020640106000600204O000800013O00202O0008000800214O0006000800024O000300063O00122O000500043O002E590022003A000100230004B03O003A00010026D50005003A000100040004B03O003A0001001255010200043O0004B03O001400010004B03O003A00010004B03O001400010004B03O003500010004B03O001400010004B03O006E0001002E590024000E000100250004B03O000E00010026C000010068000100010004B03O00680001002E500126000E000100270004B03O000E0001001255010200014O00C9000300033O0012552O0100043O0004B03O000E00010004B03O006E00010004B03O000200012O00013O00017O002C3O00028O00025O00508940025O0095B140026O00F03F025O0099B040025O00109C40025O00F09A40025O00607B40026O002A40025O00E06B40025O00E8AE40025O0098A740025O001CA440025O0094A740025O00BCB140025O0027B340025O00807340025O00A07240025O00188340025O0048A140025O00A06940025O004FB04003073O00CC4D750CF05C6903043O006A852E10030B3O004973417661696C61626C65025O005C9C40025O00F49940025O0022AD40025O0070A64003063O0042752O665570030B3O004963656675727942752O66025O00B7B140025O00188940025O00E07240025O00F6A540025O00809D40025O00D88240025O008EA340025O00D88B4003093O00497343617374696E67025O00BBB24003073O0049636566757279025O0024B040025O0020914000753O001255012O00014O00C9000100033O002E5900020006000100030004B03O000600010026C03O0008000100040004B03O00080001002E500105006C000100060004B03O006C00012O00C9000300033O0026D50001000E000100010004B03O000E0001001255010200014O00C9000300033O0012552O0100043O002E5900080009000100070004B03O000900010026C000010014000100040004B03O00140001002E59000A0009000100090004B03O00090001002E50010C004D0001000B0004B03O004D00010026D50002004D000100010004B03O004D0001001255010400013O0026C00004001F000100010004B03O001F0001002E25010D001F0001000E0004B03O001F0001002E59001000440001000F0004B03O00440001001255010500013O000E3701040026000100050004B03O00260001002E6101110026000100120004B03O00260001002E5001140028000100130004B03O00280001001255010400043O0004B03O004400010026C00005002C000100010004B03O002C0001002E5001160020000100150004B03O002000012O00CD00066O006E000700013O00122O000800173O00122O000900186O0007000900024O00060006000700202O0006000600194O00060002000200062O0006003A00013O0004B03O003A0001002E25011A003A0001001B0004B03O003A0001002E50011C003C0001001D0004B03O003C00012O006601066O0052000600024O00CD000600023O00206401060006001E4O00085O00202O00080008001F4O0006000800024O000300063O00122O000500043O0004B03O00200001002E5001210019000100200004B03O001900010026C00004004A000100040004B03O004A0001002E5001230019000100220004B03O00190001001255010200043O0004B03O004D00010004B03O00190001002E5900250051000100240004B03O005100010026C000020053000100040004B03O00530001002E5001260014000100270004B03O001400012O00CD000400023O0020BC0004000400282O00210104000200020006CC0004005A000100010004B03O005A00012O0052000300023O0004B03O00740001002E000129000C000100290004B03O006600012O00CD000400023O0020B40004000400284O00065O00202O00060006002A4O00040006000200062O0004006600013O0004B03O006600012O0066010400014O0052000400023O0004B03O007400012O0052000300023O0004B03O007400010004B03O001400010004B03O007400010004B03O000900010004B03O007400010026C03O0070000100010004B03O00700001002E59002B00020001002C0004B03O000200010012552O0100014O00C9000200023O001255012O00043O0004B03O000200012O00013O00017O000A3O00025O0018A740025O00889240030D3O007B2C76FD54535D1363F548494C03063O00203840139C3A03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00394003123O00436C65616E7365537069726974466F63757303153O0059C4E05754E18565DBF55F48FB941ACCEC454AF78C03073O00E03AA885363A9200213O002E5900020020000100010004B03O002000012O00CD8O006E000100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O002000013O0004B03O002000012O00CD3O00023O00066B012O002000013O0004B03O002000012O00CD3O00033O0020925O00060012552O0100074O0021012O0002000200066B012O002000013O0004B03O002000012O00CD3O00044O00CD000100053O0020920001000100082O0021012O0002000200066B012O002000013O0004B03O002000012O00CD3O00013O0012552O0100093O0012550102000A4O008B3O00024O00FB8O00013O00017O000D3O00025O00488D40025O0066A74003103O004865616C746850657263656E74616765025O0010A340030C3O0071534AF17C8880384C444CF803083O006B39362B9D15E6E703073O0049735265616479025O0026A840030C3O004865616C696E675375726765025O00A9B240025O0019B34003163O00D38E10F9B0D2C8E49804E7BED98FD38E102OF9D3C0D803073O00AFBBEB7195D9BC00273O002E502O010026000100020004B03O002600012O00CD7O00066B012O002600013O0004B03O002600012O00CD3O00013O0020BC5O00032O0021012O000200022O00CD000100023O0006DE3O0026000100010004B03O00260001002E000104001B000100040004B03O002600012O00CD3O00034O006E000100043O00122O000200053O00122O000300066O0001000300028O000100206O00076O0002000200064O002600013O0004B03O00260001002E000108000F000100080004B03O002600012O00CD3O00054O00CD000100033O0020920001000100092O0021012O000200020006CC3O0021000100010004B03O00210001002E50010B00260001000A0004B03O002600012O00CD3O00043O0012552O01000C3O0012550102000D4O008B3O00024O00FB8O00013O00017O00563O00028O00026O00F03F025O0024AA40025O00309640025O00E4A240025O008EA140027O0040025O003EA140025O00308B4003103O004865616C746850657263656E74616765025O00208A40025O00D88E40025O00BEAA40025O00E6A74003193O00105D31CADB07EE2B563098F611E72E5139DF9E24E9365138D603073O0086423857B8BE7403173O000E340FA91CF8293C323621BE18E7282O3B0106AF10E42F03083O00555C5169DB798B4103073O0049735265616479025O0024A540025O00ECA84003173O0052656672657368696E674865616C696E67506F74696F6E03253O00EFB6565779CCF5BA5E423CD7F8B25C4C72D8BDA35F5175D02OF354407ADAF3A05953799FA903063O00BF9DD330251C031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O0059B140025O00488840025O0092A440025O0048914003193O00FB0DF11D37C81EF8173FCD0CDC193BD316FA1B0AD00BFD133403053O005ABF7F947C025O004AB240025O00EC9640025O0030AF40025O00A0AA4003253O007C952B1675902F1B73823C04388F2B16748E201038972103718820577C822812769427017D03043O007718E74E025O00AAAB40025O008EA040025O0063B040025O00208740030B3O001DBC955EE2754B34A6875803073O00185CCFE12C8319030B3O0041737472616C536869667403183O004AC0AC5E1A7174C0B0451D690BD7BD4A1E7358DAAE495B2C03063O001D2BB3D82C7B03113O009CD72349AECD324DB1FE3545B9D82E4FB803043O002CDDB940031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00D07E40025O00F6AC40025O00CDB140025O0058A74003113O00416E6365737472616C47756964616E6365031E4O00E94B5A6015F549534C06F2415B720FE44D1F7704E14D516008F14D1F2103053O00136187283F025O00A06E40025O0030A440025O0012A640025O0076A840025O00ECAC40025O00709340025O00D2A640025O00D49340025O00749040025O00709F4003123O0086593237263FA96F27292A30A3683C2F2A3C03063O0051CE3C535B4F03123O004865616C696E6753747265616D546F74656D025O0065B140025O0063B34003203O0046AED17E26CD4A9B5DBFC2772ECE72B041BFD57F6FC748A24BA5C37B39C60DF703083O00C42ECBB0124FA32D030B3O0090277F1230F3FCAC2D701B03073O008FD8421E7E449B025O0080AE40025O00D1B240025O0064AA40025O00A08940030B3O004865616C746873746F6E6503173O00A2CD0CC7D1ABC4F5A5C6088BC1A6D1E4A4DB04DDC0E38403083O0081CAA86DABA5C3B7025O00D88B40025O00D2B240025O00DC9540025O003498400016012O001255012O00014O00C9000100023O0026D53O000B2O0100020004B03O000B2O010026C000010008000100010004B03O00080001002E5001030004000100040004B03O00040001001255010200013O002E590006000D000100050004B03O000D0001000E370107000F000100020004B03O000F0001002E5001080067000100090004B03O006700012O00CD00035O00066B0103001800013O0004B03O001800012O00CD000300013O0020BC00030003000A2O00210103000200022O00CD000400023O00064900030003000100040004B03O001A0001002E50010C00152O01000B0004B03O00152O01001255010300014O00C9000400043O002E59000E001C0001000D0004B03O001C00010026D50003001C000100010004B03O001C0001001255010400013O0026D500040021000100010004B03O002100012O00CD000500034O005A010600043O00122O0007000F3O00122O000800106O00060008000200062O0005002B000100060004B03O002B00010004B03O004200012O00CD000500054O0093000600043O00122O000700113O00122O000800126O0006000800024O00050005000600202O0005000500134O00050002000200062O00050037000100010004B03O00370001002E5900150042000100140004B03O004200012O00CD000500064O00CD000600073O0020920006000600162O002101050002000200066B0105004200013O0004B03O004200012O00CD000500043O001255010600173O001255010700184O008B000500074O00FB00056O00CD000500033O0026C000050047000100190004B03O00470001002E59001A00152O01001B0004B03O00152O01002E59001D00530001001C0004B03O005300012O00CD000500054O0093000600043O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O0005000500134O00050002000200062O00050055000100010004B03O00550001002E50012000152O0100210004B03O00152O012O00CD000500064O00CD000600073O0020920006000600162O00210105000200020006CC0005005D000100010004B03O005D0001002E50012200152O0100230004B03O00152O012O00CD000500043O0012D9000600243O00122O000700256O000500076O00055O00044O00152O010004B03O002100010004B03O00152O010004B03O001C00010004B03O00152O010026C00002006D000100010004B03O006D0001002E610126006D000100270004B03O006D0001002E50012800AF000100290004B03O00AF00012O00CD000300084O006E000400043O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400202O0003000300134O00030002000200062O0003008B00013O0004B03O008B00012O00CD000300093O00066B0103008B00013O0004B03O008B00012O00CD000300013O0020BC00030003000A2O00210103000200022O00CD0004000A3O0006DE0003008B000100040004B03O008B00012O00CD000300064O00CD000400083O00209200040004002C2O002101030002000200066B0103008B00013O0004B03O008B00012O00CD000300043O0012550104002D3O0012550105002E4O008B000300054O00FB00036O00CD000300084O006E000400043O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300134O00030002000200062O0003009F00013O0004B03O009F00012O00CD0003000B3O00066B0103009F00013O0004B03O009F00012O00CD0003000C3O0020A00003000300314O0004000D6O0005000E6O00030005000200062O000300A1000100010004B03O00A10001002E50013300AE000100320004B03O00AE0001002E59003500AE000100340004B03O00AE00012O00CD000300064O00CD000400083O0020920004000400362O002101030002000200066B010300AE00013O0004B03O00AE00012O00CD000300043O001255010400373O001255010500384O008B000300054O00FB00035O001255010200023O002E50013900090001003A0004B03O000900010026C0000200B5000100020004B03O00B50001002E00013B0056FF2O003C0004B03O00090001001255010300013O0026D5000300BA000100020004B03O00BA0001001255010200073O0004B03O00090001002E50013E00B60001003D0004B03O00B600010026D5000300B6000100010004B03O00B60001002E50014000E30001003F0004B03O00E30001002E59004100E3000100420004B03O00E300012O00CD000400084O006E000500043O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400134O00040002000200062O000400E300013O0004B03O00E300012O00CD0004000F3O00066B010400E300013O0004B03O00E300012O00CD0004000C3O00207B0004000400314O000500106O000600116O00040006000200062O000400E300013O0004B03O00E300012O00CD000400064O00CD000500083O0020920005000500452O00210104000200020006CC000400DE000100010004B03O00DE0001002E59004700E3000100460004B03O00E300012O00CD000400043O001255010500483O001255010600494O008B000400064O00FB00046O00CD000400054O006E000500043O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400F600013O0004B03O00F600012O00CD000400123O00066B010400F600013O0004B03O00F600012O00CD000400013O0020BC00040004000A2O00210104000200022O00CD000500133O00064900040003000100050004B03O00F80001002E00014C000F0001004D0004B03O00052O01002E50014F00052O01004E0004B03O00052O012O00CD000400064O00CD000500073O0020920005000500502O002101040002000200066B010400052O013O0004B03O00052O012O00CD000400043O001255010500513O001255010600524O008B000400064O00FB00045O001255010300023O0004B03O00B600010004B03O000900010004B03O00152O010004B03O000400010004B03O00152O01002E5900530002000100540004B03O000200010026C03O00112O0100010004B03O00112O01002E5001560002000100550004B03O000200010012552O0100014O00C9000200023O001255012O00023O0004B03O000200012O00013O00017O00113O00028O00025O0048AE40026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00E49140025O00B0A140025O009CAE40025O00F4A940025O00B8984003103O0048616E646C65546F705472696E6B6574025O00A2AB40025O00E5B140025O0035B040025O00E07F40025O006EAC40025O00D07940003F3O001255012O00014O00C9000100013O002E0001023O000100020004B03O000200010026D53O0002000100010004B03O000200010012552O0100013O0026D50001001B000100030004B03O001B00012O00CD000200013O0020450102000200044O000300026O000400033O00122O000500056O000600066O0002000600024O00028O00025O00062O00020018000100010004B03O00180001002E6101070018000100060004B03O00180001002E0001080028000100090004B03O003E00012O00CD00026O0052000200023O0004B03O003E0001002E00010A00ECFF2O000A0004B03O000700010026D500010007000100010004B03O00070001001255010200013O0026D500020032000100010004B03O003200012O00CD000300013O00204501030003000B4O000400026O000500033O00122O000600056O000700076O0003000700024O00038O00035O00062O0003002F000100010004B03O002F0001002E50010D00310001000C0004B03O003100012O00CD00036O0052000300023O001255010200033O002E59000F00360001000E0004B03O00360001000E3701030038000100020004B03O00380001002E5900100020000100110004B03O002000010012552O0100033O0004B03O000700010004B03O002000010004B03O000700010004B03O003E00010004B03O000200012O00013O00017O006C3O00028O00026O00F03F026O009740025O0048AB40025O00406040025O00B49D40025O0004A440025O006AAD40025O00D6AC40025O0004A640025O002C9A40025O00507340025O00B2AC40025O00CAAB40025O00B2A640025O00308E40030B3O00B139AA58D14B14873DA05803073O0071E24DC52ABC20030A3O0049734361737461626C65030B3O000902FBA7371DF1B02A13E603043O00D55A7694030F3O00432O6F6C646F776E52656D61696E7303063O0042752O665570030F3O0053746F726D6B2O6570657242752O66025O008CAE40025O007CAF40025O0094A140025O00889840030B3O0053746F726D6B2O65706572025O00C49D40025O00C0A04003173O00483ABB4440502BB14648496EA444485821B9544C4F6EE603053O002D3B4ED436025O00E88740025O00409F4003073O003955868D933CB403083O00907036E3EBE64ECD03073O009A2B0AFAC549AA03063O003BD3486F9CB003073O0049636566757279030E3O0049735370652O6C496E52616E6765025O0046AD40025O00649E4003133O004784E62B5B95FA6D5E95E62E418AE12C5AC7B703043O004D2EE783025O00908740025O00A49940025O0046A540030E3O009F58B34DBF5AA241B676BA41A94003043O0020DA34D6030E3O00456C656D656E74616C426C617374031B3O004B1B34A5F4BE515B422833A4F0A3511A5E0534ABFEBD475B5A576703083O003A2E7751C891D02503093O00497343617374696E67030E3O001B9E39A1A6AF32228D3C9BA8AB3303073O00564BEC50CCC9DD030B3O004973417661696C61626C65025O00AEA040025O002O7040030E3O005072696D6F726469616C57617665031B3O0062537E88F19976487689C19C735772C5EE9977427888FC8A66012F03063O00EB122117E59E027O0040025O00909F40026O00084003093O004C6176614275727374030D3O00557365466C616D6553686F636B030A3O00D27DF4A0201E8FFB72FE03073O00E7941195CD454D03073O0049735265616479030A3O00466C616D6553686F636B025O00606540025O003C904003173O0086ABC6F652EC88A8C4F017EF92A2C4F45AFD81B387AA2O03063O009FE0C7A79B37030E3O00C7E135DFF8E138DBF6FF0BD3E1F603043O00B297935C025O0054A340025O0078A140026O00A340025O00489240031C3O009CEF453F1D5E7E85FC400D054D6C89BD5C20174F7581FF4D26521D2C03073O001AEC9D2C52722C025O00B49040025O0098B240025O00B9B240025O00A4A940030E3O0060A8C8B65FA8C5B251B6F6BA46BF03043O00DB30DAA1030A3O00C22O7D44DE7CE8EB727703073O008084111C29BB2F025O003EB340025O00B8804003173O00073E073758123A0939564122143F5E0E3F043B4941635603053O003D6152665A03093O00802FBD4AE5420C1AB803083O0069CC4ECB2BA7377E030E3O0080A62613160AD350A9882F1F001003083O0031C5CA437E7364A7030E3O001257DA2485584A3657FD2581454A03073O003E573BBF49E036030E3O00C20EFFC4E20CEEC8EB20F6C8F41603043O00A987629A025O00A49B40025O00A7B24003163O00C7763255FF26DAD8636444EF36CBC47A2655E9732O9903073O00A8AB1744349D53025O0074B24000DB012O001255012O00014O00C9000100023O0026C03O0006000100020004B03O00060001002E59000400D22O0100030004B03O00D22O010026C00001000A000100010004B03O000A0001002E5900060006000100050004B03O00060001001255010200013O0026D500020096000100010004B03O00960001001255010300014O00C9000400043O000E372O010015000100030004B03O00150001002EE900080015000100070004B03O00150001002E590009000F0001000A0004B03O000F0001001255010400013O0026D50004001A000100020004B03O001A0001001255010200023O0004B03O009600010026D500040016000100010004B03O00160001001255010500013O0026C000050021000100020004B03O00210001002E50010B00230001000C0004B03O00230001001255010400023O0004B03O001600010026C000050027000100010004B03O00270001002E50010D001D0001000E0004B03O001D0001002E59001000540001000F0004B03O005400012O00CD00066O006E000700013O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600134O00060002000200062O0006005400013O0004B03O005400012O00CD00066O000B010700013O00122O000800143O00122O000900156O0007000900024O00060006000700202O0006000600164O00060002000200262O00060054000100010004B03O005400012O00CD000600023O00200D0006000600174O00085O00202O0008000800184O00060008000200062O00060054000100010004B03O005400012O00CD000600033O00066B0106005400013O0004B03O005400012O00CD000600043O00066B0106004D00013O0004B03O004D00012O00CD000600053O0006CC00060050000100010004B03O005000012O00CD000600043O0006CC00060054000100010004B03O005400012O00CD000600064O00CD000700073O00067F00060056000100070004B03O00560001002E00011900110001001A0004B03O00650001002E50011C005E0001001B0004B03O005E00012O00CD000600084O00CD00075O00209200070007001D2O00210106000200020006CC00060060000100010004B03O00600001002E59001F00650001001E0004B03O006500012O00CD000600013O001255010700203O001255010800214O008B000600084O00FB00065O002E5001220091000100230004B03O009100012O00CD00066O006E000700013O00122O000800243O00122O000900256O0007000900024O00060006000700202O0006000600134O00060002000200062O0006009100013O0004B03O009100012O00CD00066O000B010700013O00122O000800263O00122O000900276O0007000900024O00060006000700202O0006000600164O00060002000200262O00060091000100010004B03O009100012O00CD000600093O00066B0106009100013O0004B03O009100012O00CD000600084O00BD00075O00202O0007000700284O0008000A3O00202O0008000800294O000A5O00202O000A000A00284O0008000A00024O000800086O00060008000200062O0006008C000100010004B03O008C0001002E59002A00910001002B0004B03O009100012O00CD000600013O0012550107002C3O0012550108002D4O008B000600084O00FB00065O001255010500023O0004B03O001D00010004B03O001600010004B03O009600010004B03O000F00010026C00002009A000100020004B03O009A0001002E50012F00EB0001002E0004B03O00EB0001002E0001300020000100300004B03O00BA00012O00CD00036O006E000400013O00122O000500313O00122O000600326O0004000600024O00030003000400202O0003000300134O00030002000200062O000300BA00013O0004B03O00BA00012O00CD0003000B3O00066B010300BA00013O0004B03O00BA00012O00CD000300084O000901045O00202O0004000400334O0005000A3O00202O0005000500294O00075O00202O0007000700334O0005000700024O000500056O00030005000200062O000300BA00013O0004B03O00BA00012O00CD000300013O001255010400343O001255010500354O008B000300054O00FB00036O00CD000300023O0020B40003000300364O00055O00202O0005000500334O00030005000200062O000300D700013O0004B03O00D700012O00CD0003000C3O00066B010300D700013O0004B03O00D700012O00CD0003000D3O00066B010300CA00013O0004B03O00CA00012O00CD000300053O0006CC000300CD000100010004B03O00CD00012O00CD0003000D3O0006CC000300D7000100010004B03O00D700012O00CD00036O0093000400013O00122O000500373O00122O000600386O0004000600024O00030003000400202O0003000300394O00030002000200062O000300D9000100010004B03O00D90001002E59003A00EA0001003B0004B03O00EA00012O00CD000300084O000901045O00202O00040004003C4O0005000A3O00202O0005000500294O00075O00202O00070007003C4O0005000700024O000500056O00030005000200062O000300EA00013O0004B03O00EA00012O00CD000300013O0012550104003D3O0012550105003E4O008B000300054O00FB00035O0012550102003F3O002E000140005E000100400004B03O00492O010026D5000200492O0100410004B03O00492O012O00CD000300023O0020B40003000300364O00055O00202O0005000500424O00030005000200062O000300162O013O0004B03O00162O01001239010300433O00066B010300162O013O0004B03O00162O012O00CD00036O006E000400013O00122O000500443O00122O000600456O0004000600024O00030003000400202O0003000300464O00030002000200062O000300162O013O0004B03O00162O012O00CD000300084O00BD00045O00202O0004000400474O0005000A3O00202O0005000500294O00075O00202O0007000700474O0005000700024O000500056O00030005000200062O000300112O0100010004B03O00112O01002E50014900162O0100480004B03O00162O012O00CD000300013O0012550104004A3O0012550105004B4O008B000300054O00FB00036O00CD000300023O0020B40003000300364O00055O00202O0005000500424O00030005000200062O000300332O013O0004B03O00332O012O00CD0003000C3O00066B010300332O013O0004B03O00332O012O00CD0003000D3O00066B010300262O013O0004B03O00262O012O00CD000300053O0006CC000300292O0100010004B03O00292O012O00CD0003000D3O0006CC000300332O0100010004B03O00332O012O00CD00036O0093000400013O00122O0005004C3O00122O0006004D6O0004000600024O00030003000400202O0003000300394O00030002000200062O000300352O0100010004B03O00352O01002E59004E00DA2O01004F0004B03O00DA2O012O00CD000300084O00BD00045O00202O00040004003C4O0005000A3O00202O0005000500294O00075O00202O00070007003C4O0005000700024O000500056O00030005000200062O000300432O0100010004B03O00432O01002E50015000DA2O0100510004B03O00DA2O012O00CD000300013O0012D9000400523O00122O000500536O000300056O00035O00044O00DA2O01002E500154000B000100550004B03O000B00010026D50002000B0001003F0004B03O000B0001001255010300013O002E50015700542O0100560004B03O00542O010026D5000300542O0100020004B03O00542O01001255010200413O0004B03O000B00010026D50003004E2O0100010004B03O004E2O012O00CD000400023O0020B40004000400364O00065O00202O0006000600334O00040006000200062O000400872O013O0004B03O00872O01001239010400433O00066B010400872O013O0004B03O00872O012O00CD00046O0093000500013O00122O000600583O00122O000700596O0005000700024O00040004000500202O0004000400394O00040002000200062O000400872O0100010004B03O00872O012O00CD00046O006E000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400464O00040002000200062O000400872O013O0004B03O00872O01002E50015D00872O01005C0004B03O00872O012O00CD000400084O000901055O00202O0005000500474O0006000A3O00202O0006000600294O00085O00202O0008000800474O0006000800024O000600066O00040006000200062O000400872O013O0004B03O00872O012O00CD000400013O0012550105005E3O0012550106005F4O008B000400064O00FB00046O00CD00046O006E000500013O00122O000600603O00122O000700616O0005000700024O00040004000500202O0004000400134O00040002000200062O000400CC2O013O0004B03O00CC2O012O00CD0004000E3O00066B010400CC2O013O0004B03O00CC2O012O00CD000400023O00200D0004000400364O00065O00202O0006000600424O00040006000200062O000400CC2O0100010004B03O00CC2O012O00CD00046O006E000500013O00122O000600623O00122O000700636O0005000700024O00040004000500202O0004000400394O00040002000200062O000400B92O013O0004B03O00B92O012O00CD00046O006E000500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O0004000400394O00040002000200062O000400CC2O013O0004B03O00CC2O012O00CD00046O0093000500013O00122O000600663O00122O000700676O0005000700024O00040004000500202O0004000400394O00040002000200062O000400CC2O0100010004B03O00CC2O012O00CD000400084O00BD00055O00202O0005000500424O0006000A3O00202O0006000600294O00085O00202O0008000800424O0006000800024O000600066O00040006000200062O000400C72O0100010004B03O00C72O01002E0001680007000100690004B03O00CC2O012O00CD000400013O0012550105006A3O0012550106006B4O008B000400064O00FB00045O001255010300023O0004B03O004E2O010004B03O000B00010004B03O00DA2O010004B03O000600010004B03O00DA2O01002E00016C0030FE2O006C0004B03O000200010026D53O0002000100010004B03O000200010012552O0100014O00C9000200023O001255012O00023O0004B03O000200012O00013O00017O00BB022O00028O00025O002CA540025O00D08040025O008EAE40025O00B9B040026O00F03F025O00908D40025O00DFB240025O00508F40025O004CAE40025O00888540027O0040030A3O003DE1875CE80E3114EE8D03073O00597B8DE6318D5D030A3O0049734361737461626C65025O00108B40025O0090A640025O0082B140025O009AAB40025O0064AE40025O00689240025O00BEA140026O000840025O00C88040025O0060A74003143O00C8AD06D450F59A0CCB48E9AC26C859E1AD0DD04F03053O003C8CC863A4030B3O004973417661696C61626C65030C3O00B4E11621A788F23429B582E603053O00C2E7946446026O008940025O004AA04003093O00436173744379636C65030A3O00466C616D6553686F636B030E3O0049735370652O6C496E52616E676503123O002O40C0AEF3F75544CEA0FD884743C4E3A59803063O00A8262CA1C39603063O0042752O66557003103O0053757267656F66506F77657242752O66030C3O00A03543EA470C853243D05C0603063O0062EC5C24823303163O00971215B857ADB43BA10B1F9C4CADA729801C01B356AD03083O0050C4796CDA25C8D5025O00ACAF40025O00806040025O0007B240025O00B8A74003123O00067F03724E3199087C01740B0F850533502903073O00EA6013621F2B6E025O009C9840025O0046A24003133O002B1E41D3A96084000B5AC2897E8E0B1A5CD3BF03073O00EB667F32A7CC12030C3O007CA8F22B502059AFF2114B2A03063O004E30C1954324025O00708140025O0098A84003123O0036128115440F0D8817423B5E811744704CD803053O0021507EE078025O00FEA840025O0076A340025O009C9F40025O0092AA40025O00F07240025O00A2AC40025O0026AE40025O00D8AD40025O00EAA940025O0053B040025O00509B40025O0011B14003133O0015071EF93D1402EB2C0E08C8340300E836121E03043O008D58666D030C3O009F5ACD780E335CCFB461C57403083O00A1D333AA107A5D3503103O00DDA2B325FE9DBA27F8A5962DF9BBB42E03043O00489BCED2030F3O0041757261416374697665436F756E74026O001840025O00D07B40025O0034A840025O007EA840025O00DCA34003123O00407655033679695C01304D3A55013606280603053O0053261A346E03143O007C122256540E1549570322427D1B224B5D19335503043O0026387747030C3O00C0FA4AD12059F5DF57C1204403063O0036938F38B64503103O00F08DFE44DAE589F04AD4F284FD5CD9D003053O00BFB6E19F29025O00708940025O00A4A840025O00A6B040025O0030794003123O002D1E29588EB8D1231D2B5ECB86CD2E527A0103073O00A24B724835EBE7025O001EAB40025O00CCB140025O00CEA340025O00DC9440025O0074B240030C3O00DF78F12O0444FA7FF13E1F4E03063O002A9311966C70031A3O0038AF237BF4F80AA7267AF5FB23A73B7ED5ED1CB33F78E2E60CA303063O00886FC64D1F87030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O6603093O0054696D65546F446965025O0044A740025O0098A74003123O000405A65BB8DB04A10D0AAC16BCEB12E9535103083O00C96269C736DD8477025O000CAA40025O00207D40030C3O0095058429163BA5B70BB12E0603073O00CCD96CE341625503163O006DC8ECE73EC55FC8F0F73FE657C6E7FC08C553CAE6E003063O00A03EA395854C03103O00F0AC0C22C6E5A8022CC8F2A50F3AC5D003053O00A3B6C06D4F025O00E6A840025O00A1B24003123O00322A01CDF00B3508CFF63F6601CFF02O745003053O0095544660A0025O00FCAB40025O00789C40026O002C40025O0045B040025O00709B40025O00EC9640025O00F4AC40025O0068AC40030E3O0022EF3C397900F93C357A25FC233103053O0016729D555403083O0042752O66446F776E03123O005072696D6F726469616C5761766542752O6603143O00E0CE16D451EF9ACBC407C159D3A4C1C616CA49E503073O00C8A4AB73A43D96030C3O008DE1114286B1F2334A94BBE603053O00E3DE94632503163O0053706C696E7465726564456C656D656E747342752O66025O0010A240025O0070AD40030C3O00436173745461726765744966030E3O005072696D6F726469616C576176652O033O003E5B5C03053O0099532O329603083O0053652O74696E677303073O007E797E117CA55E03073O002D3D16137C13CB030C3O00E51B1EE50E71A0F20614F90703073O00D9A1726D95621003093O005369676E617475726503163O0002323171B36616293970836313363D3CBD7B1760692803063O00147240581CDC025O0023B340025O001CB040030E3O000113DBB9F7C2B93800DE83F9C6B803073O00DD5161B2D498B003133O00E0E60EEF1FDFE81BEF12C8C211FE17C8E909E803053O007AAD877D9B030C3O00A8C807B12B3FC18AC632B63B03073O00A8E4A160D95F51025O00E8B140025O0091B0402O033O00D6D82003063O0037BBB14E3C4F03073O000EC152E649C19303073O00E04DAE3F8B26AF030C3O00A0484B3E8840411D9058542B03043O004EE42138025O00DC9A40025O00049C40025O0061B240025O006BB04003163O00DE6CBB0E8ADC7ABB0289F169B315808E7FBD06C59F2803053O00E5AE1ED263025O0060A240025O0030B240025O0032A140025O00B4B240025O00ADB240025O0095B040025O00A08340025O00A2AE40025O0084B140025O00E08540025O00C07440025O0044A84003103O003FDC93EEE3C33ED485F6EBF31CC187F603063O00A773B5E29B8A03073O004973526561647903063O00F22EE6457E6303073O00A68242873C1B1103163O004C69717569644D61676D61546F74656D506C6179657203093O004973496E52616E6765026O004440025O00909A40025O00489440025O00908940025O009EAE4003193O004843DF60394075C37437494BF1613F504FC335314B4F8E246103053O0050242AAE15025O00AAA940025O0090AB40030E3O007E023E77410233734F1C007B581503043O001A2E7057025O00849140025O00FEA540025O0044A0402O033O00B42AA503083O00D4D943CB142ODF2503073O009982A5DFB583BB03043O00B2DAEDC8030C3O0092BCF5C0BAB4FFE3A2ACEAD503043O00B0D6D58603163O00E42OBFD9A7445DFDACBAEBBF574FF1EDB7DBAD1608A603073O003994CDD6B4C836026O002040030A3O00864F04E3A5700DE1A34803043O008EC02365030D3O00557365466C616D6553686F636B025O0020A840025O0094A14003193O00D07928AEE2B3BF1ED97622E3EA83BA1FD87269A2E889EC4E8003083O0076B61549C387ECCC025O004CB240025O00207440030A3O002O2E1553103EF5073F1103073O009D685C7A20646D025O00F5B240025O00C08C40030A3O0046726F737453686F636B03193O00A5B4C0D929189EA3ACA5C48A30289BA2ADA18FCB3222CDF3FB03083O00CBC3C6AFAA5D47ED026O001440025O00749040025O0075B240025O009C9740025O00388740030E3O00DA1CC7F5828DF932F100C8F582A603083O00559974A69CECC190030E3O00436861696E4C696768746E696E6703163O00A7E84CBAEA3FA8E94ABBF00EADEE4AF3E50FA1A01BE303063O0060C4802DD38403083O00198C6D5EF0AAB5D503083O00B855ED1B3FB2CFD403053O00506F776572030B3O0042752O6652656D61696E73030E3O00417363656E64616E636542752O6603083O0024581F5E2A5C085203043O003F68396903083O004361737454696D65025O00307C40025O008EA740025O002AA140025O0050974003083O004C6176614265616D025O00F6A140025O00C08A4003103O000786B2453485A14506C7A54B0EC7F21603043O00246BE7C4025O00B09540026O005B40030E3O007EBDA38E5399AB8055A1AC8E53B203043O00E73DD5C2025O008AB140025O00C6A640025O0062A940025O0074AF4003163O000AA53C7A0792317A0EA5297D00A33A3308A238335FF903043O001369CD5D025O004DB040025O008CA34003093O0028EEB2C2134F16FCB003063O003A648FC4A35103133O00374330B73A5BEA080E4A2686334CE80B14563003083O006E7A2243C35F298503073O0048617354696572026O003E40030D3O0050A85E45D061B95E79C27AA35603053O00B615D13B2A030A3O0054616C656E7452616E6B026O004E40030B3O00915BCA0A2EB88758D2183303063O00DED737A57D41026O002440025O00988A40025O004CA540025O00789A40025O00849F40025O00D8AE40025O001CAF4003093O004C617661427572737403113O00202OD01BCDC3F8583FC5861BFDC4AD1F7A03083O002A4CB1A67A92A18D025O0082AB4003083O00898B13CF5B73A48703063O0016C5EA65AE19025O006CA540025O0068A34003103O002135B3DD49ADD2872074A4D373EF82DE03083O00E64D54C5BC16CFB7025O008CAD40025O0088AB40026O001040025O0010AB40025O00206D40030E3O00258BA75D0589B6510CA5AE51139303043O003060E7C203163O00ED5906221CCBA085EF480B2C0DEBBA8DCC5F1C2417DF03083O00E3A83A6E4D79B8CF025O00A07840025O00806F40030E3O00456C656D656E74616C426C61737403163O007E30BA4DB4D565A47703BD4CB0C865E57A33BA00E58D03083O00C51B5CDF20D1BB11025O00F0A740025O00F6AB40030A3O00265ED1EF0B6CCBF4005403043O009B633FA303163O00A7D2A982BC978DD7869FBC8596E2B483BD8190D8AF8A03063O00E4E2B1C1EDD9025O005AA540025O00B07A40030A3O00456172746853686F636B2O033O0039B92D03043O008654D043025O00CEAC40025O0048874003123O0016AD94481B9395541CAF8D1C12A3831C47F403043O003C73CCE6030A3O00C23BF964EF09E37FE43103043O0010875A8B03163O0071770E3C4B4777525314364F404B417A02365C5D765303073O0018341466532E34025O0048A740025O00ECA340025O003BB040025O00F0B240025O0012B140025O00608A40025O00B2AA4003123O00C12E333007FB3C292B0CCF6F202B0A847A7103053O006FA44F4144025O00349940025O00388F4003073O00EFDA86D83BF8DF03063O008AA6B9E3BE4E03073O00E277C03147310003073O0079AB14A5573243030F3O00432O6F6C646F776E52656D61696E7303113O00E334BC35AD10CF3EB033BD31CE37BA3DAA03063O0062A658D956D9030C3O00DAFF7E0992D2FFF87E3389D803063O00BC2O961961E603143O00FE8C5A1200F4E886501609E9FF855A0F09E3CE9A03063O008DBAE93F626C025O003C9A40025O0072A940025O00A88340025O0092AD4003073O0049636566757279030E3O00F8E929B030E3F36CB72AF4AA79E403053O0045918A4CD6025O004EA540025O00AEA240030A3O0056DD869AAB2578C08A8203063O007610AF2OE9DF03113O00AE8830B8FA99742O8D30BFDD8372888F2603073O001DEBE455DB8EEB030A3O00446562752O66446F776E03173O00456C65637472696669656453686F636B73446562752O66030B3O004963656675727942752O662O033O00474344030C3O0011DDBDD563402E5C3AE6B5D903083O00325DB4DABD172E4703143O00FAA15E5C48C57AD1AB4F4940F944DBA95E4250CF03073O0028BEC43B2C24BC025O0067B140025O004EA440025O00A07C40025O00D49640025O001EAF40025O009C944003193O003A57D3A7EE421E344ADFBFBA70022A4CD2B3BA7C02390589E003073O006D5C25BCD49A1D025O00707540026O001C40025O00BC9840025O00ACAA40026O006C40025O00DAA84003093O00A856E85BA642EC499003043O003AE4379E030D3O004C617661537572676542752O6603143O00908CD53E30B407BB86C42B388839B184D52028BE03073O0055D4E9B04E5CCD025O005EAD40025O006C944003113O0046599EE3755A9DF0594CC8E3455DC8B51C03043O00822A38E8025O0042AA40025O006CA74003073O00C3B621E5552DF303063O005F8AD544832003073O00032BA44563383103053O00164A48C12303113O000975E15B386BED5E257CE06B2476E7533F03043O00384C1984025O00409440025O00C09B40025O00C49B40025O00C0B240030E3O0057C2AE20DA4CD8EB27C05B81FC7E03053O00AF3EA1CB46025O00FCA340025O0022AF40025O00088640030A3O001ACFCC00210FD5CC103E03053O00555CBDA37303113O000CA0353B3DBE393E20A9340B21A32O333A03043O005849CC5003133O001B8D024325DF209719482EF92F8F114B20CE3703063O00BA4EE370264903123O00FA45F2464745EF5FF256583AFD58F8150B2A03063O001A9C379D353303083O00A0D900D89A558DD503063O0030ECB876B9D803083O00C9BC4131ED31E4B003063O005485DD3750AF025O00409340025O0053B140025O0050AE40025O00F2B140025O00C2A54003103O00B1E632A7F85EB8E629E6C653B8A77CF403063O003CDD8744C6A7025O005BB240025O0008AE40025O00D2B040025O000C9140025O00FAA240030E3O00CDB5F98A4CF5E7BAF0974CD0E0BA03063O00B98EDD98E322025O00389740025O00B8AE4003163O005BCD56F34D0CFB51C25FEE4D3AF95F8556F54673AF0C03073O009738A5379A2353025O0074A440025O006EB340025O00208440025O00A08440025O00309240025O009C9040030A3O00A1EF81733EECB71883F903083O0076E09CE2165088D6025O00CEB140025O00F07F40030A3O00417363656E64616E636503113O0043FD5A854CEA588E41EB19814DEB19D31003043O00E0228E39025O00A49740025O008CAA4003093O00F2A6D3DC51E44F1DCA03083O006EBEC7A5BD13913D03133O00F7EA64FC8E2OD5ED63E08EE2D6EE7AED85D3C903063O00A7BA8B1788EB030D3O003FAC8D021CA1800829A1871F1703043O006D7AD5E8030B3O00C8FBAD27E1F1923FF9F2B003043O00508E97C203163O0026C57F4306D5784A24D4724D17F5624207C365450DC103043O002C63A617030C3O0050FE2E3E27AA75F92E043CA003063O00C41C97495653031A3O004563686F65736F66477265617453756E646572696E6742752O6603133O00C60D3B158E5D1662FA0D2E338354197BFA173003083O001693634970E2387803113O00B4742OF4B2BA60F0E699F874EDF0CDEB2103053O00EDD8158295025O000AA940025O0016A640030A3O00A74F4D4BB8D84B83455A03073O003EE22E2O3FD0A903063O00E60C4790101F03083O003E857935E37F6D4F03163O0035173AFAD3BDAD163320F0D7BA91051A36F0C4A7AC1703073O00C270745295B6CE025O005C9140025O0038AB40025O0084A140025O0008AD4003103O0045617274687175616B65437572736F7203113O003CA95E0CC8F31B38A34958C1ED0B79FB1A03073O006E59C82C78A082025O00DDB140030A3O008EC259524B5B2E4CA0C603083O002DCBA32B26232A5B03063O00C289DD3A82BB03073O0034B2E5BC43E7C903163O000442580BF24F2C27664201F64810344F5401E5552D2603073O004341213064973C03103O0045617274687175616B65506C61796572025O003CA840026O005F40025O00A88640025O005EA74003113O00DAE6BCCCFBCEF2AFD3F69FE6A1DDB38CB103053O0093BF87CEB8025O0080A040025O000EA240030A3O00A129B4D5D042A78523A303073O00D2E448C6A1B83303063O00355CE1037CDC03063O00AE562993701303163O007E038504201C1EAD7C12880A313C04A55F059F022B0803083O00CB3B60ED6B456F71030E3O00011AA9EC34FEC3251A8EED30E3C303073O00B74476CC815190025O00449340025O000FB24003113O000BAC62F003931BAC7BE14B8301A830B75303063O00E26ECD10846B025O005C9740025O0092AC40025O0060A140025O00207F4003083O008509C8801DAC09D303053O005FC968BEE103083O0083CAD7CF8DCEC0C303043O00AECFABA103103O00E1FF1BF2C7D5E8FF00B3F9D8E8BE5BA503063O00B78D9E6D9398025O00B08940026O005240025O00B88440025O00FEA640030E3O000F01E7052225EF0B241DE805220E03043O006C4C6986025O00308440025O005AAF4003163O00E8CDB0E8C0D4C9B8E6C6FFCBB8EFC9ABC4BEE48EBD9D03053O00AE8BA5D181025O004C9E4003093O00812B454D94B838405803053O00D6CD4A332C03133O00D74DF1E872E843E4E87FFF69EEF97AFF42F6EF03053O00179A2C829C025O005CA040025O0008A240025O0046A340025O00249240025O0028824003113O001DA7BBAF091104B4BEBA76121EA3EDF96203063O007371C6CDCE56025O00EAAF40025O00C4954003093O008FB2F4C0E416626BB703083O0018C3D382A1A6631003143O006206EC3C5F0F740CE6385612630FEC215618521003063O00762663894C33031E3O0057696E64737065616B6572734C617661526573757267656E636542752O66025O00D2AB40025O00AEAD40025O0032B240025O00805F4003113O00F1272O133622E83416064921F2232O455903063O00409D46657269025O00F4B240025O0079B34003083O006CA9B1E23245A9AA03053O007020C8C78303084O00514AB9E1AE232103073O00424C303CD8A3CB025O00E5B140025O00E6AC40025O00F8A44003103O00B6876FF260CC21BB8B39F250CB64EDD403073O0044DAE619933FAE025O00B08840025O00BAAF40025O00DAAD40025O00789E40030D3O000C27C75E0F22D0562F20C15A2603043O003B4A4EB5030D3O0046697265456C656D656E74616C03143O0023D8485F8C20DD5F57B62BC55B56F324DE5F1AE103053O00D345B12O3A025O00B09E40030E3O0084F176E7E4EEBBE074F0E7DFB6E903063O00ABD785199589025O00308540025O00B07140025O00E07B40025O002AA340030E3O0053746F726D456C656D656E74616C025O0024B340025O00E2A24003153O00F2DC3DE8E20FF94EE4C537F4FB31F002E0C737BABB03083O002281A8529A8F509C030B3O00B6A63C192O458C80A2361903073O00E9E5D2536B282E030B3O00F2563DC408CA4737C600D303053O0065A12252B6030F3O0053746F726D6B2O6570657242752O66025O00ACA140025O0070AA40030B3O0053746F726D6B2O6570657203113O00FB1956ECD6E9872BF8084BBEDAED876EBF03083O004E886D399EBB82E2025O00609740025O008BB240030D3O000A30EDF43336FAC33B3CF8FD3203043O00915E5F9903103O00D1C405C047B3D0CC13D84F83F2D911D803063O00D79DAD74B52E025O00804640025O00E89A40025O00ECAA40030D3O00546F74656D6963526563612O6C025O0060AC40025O00DCAA4003143O0021BB9FF7D73CB7B4E0DF36B587FE9A34BB8EB28203053O00BA55D4EB9203103O00EE8807EB30EA75C3861BFF0DE14CC78C03073O0038A2E1769E598E03063O005F10D2BC2DCA03063O00B83C65A0CF42025O001EA740025O0050A040025O00E6AD40025O00BAA24003163O004C69717569644D61676D61546F74656D437572736F7203193O003D8B6DA9388643B1308571BD0E9673A8348F3CBD3E873CED6103043O00DC51E21C025O00BAA640025O005C9E40025O0090B140025O001BB040025O00DC9940025O0028A740025O00D07440030A3O00CEC2F2CD49FAD6E1D24403053O00218BA380B903063O00475405C7524A03043O00BE37386403163O0073AC341116F0FC50882E1B12F7C043A1381B01EAFD5103073O009336CF5C7E7383030E3O00283D307008701930395F017F1E2503063O001E6D51551D6D025O00B2A140025O00A0904003113O00FA7046A23ECFE9FE7A51F637D1F9BF220C03073O009C9F1134D656BE025O00D8AB40026O009340030A3O008BEEAFA8A6FEA8BDA5EA03043O00DCCE8FDD03063O0085683F04D7DE03073O00B2E61D4D77B8AC03113O00F0BF180F7FE9E0BF011E37F9FABB4A4F2703063O009895DE6A7B17025O002EA240025O008FB240030E3O006D7DB1F3C04665B5F2E74470A7EA03053O00A52811D49E03163O00C0DA003C23F6D60E1434E0D81C0033EBDD0D212FEBDE03053O004685B96853025O00FCA140025O005CA140025O00BAAC40025O0038B04003163O0001494127CC0A514526F606494539DD2O444B2F89501103053O00A96425244A025O0063B140025O001AA440030A3O00F827E457BDCC33F748B003053O00D5BD46962303063O005F5975114A4703043O00682F3514025O0027B140025O00EEB04003113O00A64D9308B41EB64D8A19FC0EAC49C148EC03063O006FC32CE17CDC025O000C9840025O00207E40025O008C9340025O002CA440030E3O00FD4A057EAEA5CC470C51A7AACB5203063O00CBB8266013CB03163O001C70714ECB2A7C7F66DC3C726D72DB37777C53C7377403053O00AE591319212O033O00221B5C03073O006B4F72322E97E7025O00F6A84003163O003CAAB0248F37A3C13599B7258B2AA38038A9B069DE6B03083O00A059C6D549EA59D700680D2O001255012O00014O00C9000100013O002E5001030006000100020004B03O00060001000E372O01000800013O0004B03O00080001002E5900050002000100040004B03O000200010012552O0100013O0026C00001000F000100060004B03O000F0001002EE90008000F000100070004B03O000F0001002E59000A006E030100090004B03O006E0301001255010200013O002E00010B00E82O01000B0004B03O00F82O010026D5000200F82O01000C0004B03O00F82O012O00CD00036O0093000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000F4O00030002000200062O00030020000100010004B03O00200001002E00011000D82O0100110004B03O00F62O01001255010300014O00C9000400053O002E59001300EE2O0100120004B03O00EE2O010026D5000300EE2O0100060004B03O00EE2O01002E0001143O000100140004B03O002600010026D500040026000100010004B03O00260001001255010500013O002E590015005F000100160004B03O005F00010026C000050031000100170004B03O00310001002E500119005F000100180004B03O005F00012O00CD00066O006E000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006004800013O0004B03O004800012O00CD000600023O00066B0106004800013O0004B03O004800012O00CD00066O006E000700013O00122O0008001D3O00122O0009001E6O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006004A00013O0004B03O004A0001002E50012000F62O01001F0004B03O00F62O012O00CD000600033O0020420106000600214O00075O00202O0007000700224O000800046O000900056O000A00063O00202O000A000A00234O000C5O00202O000C000C00224O000A000C00024O000A000A6O0006000A000200062O000600F62O013O0004B03O00F62O012O00CD000600013O0012D9000700243O00122O000800256O000600086O00065O00044O00F62O010026D5000500C70001000C0004B03O00C700012O00CD000600073O0020B40006000600264O00085O00202O0008000800274O00060008000200062O0006009700013O0004B03O009700012O00CD000600023O00066B0106009700013O0004B03O009700012O00CD00066O006E000700013O00122O000800283O00122O000900296O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006007F00013O0004B03O007F00012O00CD00066O006E000700013O00122O0008002A3O00122O0009002B6O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006009700013O0004B03O009700012O00CD000600033O0020050106000600214O00075O00202O0007000700224O000800046O000900056O000A00063O00202O000A000A00234O000C5O00202O000C000C00224O000A000C00022O0012010A000A4O00620006000A00020006CC00060092000100010004B03O00920001002E61012C00920001002D0004B03O00920001002E50012E00970001002F0004B03O009700012O00CD000600013O001255010700303O001255010800314O008B000600084O00FB00065O002E59003200C6000100330004B03O00C600012O00CD00066O006E000700013O00122O000800343O00122O000900356O0007000900024O00060006000700202O00060006001C4O00060002000200062O000600C600013O0004B03O00C600012O00CD000600023O00066B010600C600013O0004B03O00C600012O00CD00066O0093000700013O00122O000800363O00122O000900376O0007000900024O00060006000700202O00060006001C4O00060002000200062O000600C6000100010004B03O00C600012O00CD000600033O0020050106000600214O00075O00202O0007000700224O000800046O000900056O000A00063O00202O000A000A00234O000C5O00202O000C000C00224O000A000C00022O0012010A000A4O00620006000A00020006CC000600C1000100010004B03O00C10001002E0001380007000100390004B03O00C600012O00CD000600013O0012550107003A3O0012550108003B4O008B000600084O00FB00065O001255010500173O000E470106005A2O0100050004B03O005A2O01001255010600013O000E47010600CE000100060004B03O00CE00010012550105000C3O0004B03O005A2O01002E00013C00FCFF2O003C0004B03O00CA0001002E50013E00CA0001003D0004B03O00CA00010026D5000600CA000100010004B03O00CA0001001255010700013O002E50014000DD0001003F0004B03O00DD00010026C0000700DB000100060004B03O00DB0001002E50014200DD000100410004B03O00DD0001001255010600063O0004B03O00CA00010026C0000700E3000100010004B03O00E30001002EE9004300E3000100440004B03O00E30001002E50014500D5000100460004B03O00D50001002E000147003B000100470004B03O001E2O012O00CD00086O006E000900013O00122O000A00483O00122O000B00496O0009000B00024O00080008000900202O00080008001C4O00080002000200062O0008001E2O013O0004B03O001E2O012O00CD000800023O00066B0108001E2O013O0004B03O001E2O012O00CD00086O0093000900013O00122O000A004A3O00122O000B004B6O0009000B00024O00080008000900202O00080008001C4O00080002000200062O0008001E2O0100010004B03O001E2O012O00CD00086O00CB000900013O00122O000A004C3O00122O000B004D6O0009000B00024O00080008000900202O00080008004E4O00080002000200262O0008001E2O01004F0004B03O001E2O012O00CD000800033O0020050108000800214O00095O00202O0009000900224O000A00046O000B00086O000C00063O00202O000C000C00234O000E5O00202O000E000E00224O000C000E00022O0012010C000C4O00620008000C00020006CC000800192O0100010004B03O00192O01002E61015100192O0100500004B03O00192O01002E590052001E2O0100530004B03O001E2O012O00CD000800013O001255010900543O001255010A00554O008B0008000A4O00FB00086O00CD00086O006E000900013O00122O000A00563O00122O000B00576O0009000B00024O00080008000900202O00080008001C4O00080002000200062O0008003F2O013O0004B03O003F2O012O00CD000800023O00066B0108003F2O013O0004B03O003F2O012O00CD00086O0093000900013O00122O000A00583O00122O000B00596O0009000B00024O00080008000900202O00080008001C4O00080002000200062O0008003F2O0100010004B03O003F2O012O00CD00086O0016010900013O00122O000A005A3O00122O000B005B6O0009000B00024O00080008000900202O00080008004E4O00080002000200262O000800412O01004F0004B03O00412O01002E00015C00180001005D0004B03O00572O012O00CD000800033O0020050108000800214O00095O00202O0009000900224O000A00046O000B00086O000C00063O00202O000C000C00234O000E5O00202O000E000E00224O000C000E00022O0012010C000C4O00620008000C00020006CC000800522O0100010004B03O00522O01002E50015E00572O01005F0004B03O00572O012O00CD000800013O001255010900603O001255010A00614O008B0008000A4O00FB00085O001255010700063O0004B03O00D500010004B03O00CA00010026C00005005E2O0100010004B03O005E2O01002E590063002B000100620004B03O002B0001001255010600013O002E50016500E52O0100640004B03O00E52O010026D5000600E52O0100010004B03O00E52O01002E000166002B000100660004B03O008E2O012O00CD000700073O0020B40007000700264O00095O00202O0009000900274O00070009000200062O0007008E2O013O0004B03O008E2O012O00CD000700023O00066B0107008E2O013O0004B03O008E2O012O00CD00076O006E000800013O00122O000900673O00122O000A00686O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007008E2O013O0004B03O008E2O012O00CD00076O006E000800013O00122O000900693O00122O000A006A6O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007008E2O013O0004B03O008E2O012O00CD000700063O0020A500070007006B4O00095O00202O00090009006C4O0007000900024O000800063O00202O00080008006D4O00080002000200202O00080008000600062O000700902O0100080004B03O00902O01002E50016F00A42O01006E0004B03O00A42O012O00CD000700033O0020420107000700214O00085O00202O0008000800224O000900046O000A00086O000B00063O00202O000B000B00234O000D5O00202O000D000D00224O000B000D00024O000B000B6O0007000B000200062O000700A42O013O0004B03O00A42O012O00CD000700013O001255010800703O001255010900714O008B000700094O00FB00075O002E50017300E42O0100720004B03O00E42O012O00CD000700073O0020B40007000700264O00095O00202O0009000900274O00070009000200062O000700CE2O013O0004B03O00CE2O012O00CD000700023O00066B010700CE2O013O0004B03O00CE2O012O00CD00076O006E000800013O00122O000900743O00122O000A00756O0008000A00024O00070007000800202O00070007001C4O00070002000200062O000700C42O013O0004B03O00C42O012O00CD00076O006E000800013O00122O000900763O00122O000A00776O0008000A00024O00070007000800202O00070007001C4O00070002000200062O000700CE2O013O0004B03O00CE2O012O00CD00076O0016010800013O00122O000900783O00122O000A00796O0008000A00024O00070007000800202O00070007004E4O00070002000200262O000700D02O01004F0004B03O00D02O01002E00017A00160001007B0004B03O00E42O012O00CD000700033O0020420107000700214O00085O00202O0008000800224O000900046O000A00086O000B00063O00202O000B000B00234O000D5O00202O000D000D00224O000B000D00024O000B000B6O0007000B000200062O000700E42O013O0004B03O00E42O012O00CD000700013O0012550108007C3O0012550109007D4O008B000700094O00FB00075O001255010600063O0026D50006005F2O0100060004B03O005F2O01001255010500063O0004B03O002B00010004B03O005F2O010004B03O002B00010004B03O00F62O010004B03O002600010004B03O00F62O010026C0000300F22O0100010004B03O00F22O01002E50017E00220001007F0004B03O00220001001255010400014O00C9000500053O001255010300063O0004B03O002200010012552O01000C3O0004B03O006E03010026C0000200FC2O0100060004B03O00FC2O01002E50018100CA020100800004B03O00CA0201001255010300013O002E50018300C3020100820004B03O00C302010026D5000300C3020100010004B03O00C30201002E5900850063020100840004B03O006302012O00CD00046O006E000500013O00122O000600863O00122O000700876O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004003B02013O0004B03O003B02012O00CD000400093O00066B0104003B02013O0004B03O003B02012O00CD0004000A3O00066B0104001602013O0004B03O001602012O00CD0004000B3O0006CC00040019020100010004B03O001902012O00CD0004000A3O0006CC0004003B020100010004B03O003B02012O00CD000400073O0020B40004000400884O00065O00202O0006000600894O00040006000200062O0004003B02013O0004B03O003B02012O00CD00046O006E000500013O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004003B02013O0004B03O003B02012O00CD00046O0093000500013O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004003B020100010004B03O003B02012O00CD000400073O00200D0004000400884O00065O00202O00060006008E4O00040006000200062O0004003D020100010004B03O003D0201002E59009000630201008F0004B03O006302012O00CD000400033O00205A0004000400914O00055O00202O0005000500924O000600046O000700013O00122O000800933O00122O000900946O0007000900024O0008000C6O000900094O00CD000A00063O002095000A000A00234O000C5O00202O000C000C00924O000A000C00024O000A000A6O000B000B3O00122O000C00956O000D00013O00122O000E00963O00122O000F00974O0062000D000F00022O0044000C000C000D4O000D00013O00122O000E00983O00122O000F00996O000D000F00024O000C000C000D00202O000C000C009A4O0004000C000200062O0004006302013O0004B03O006302012O00CD000400013O0012550105009B3O0012550106009C4O008B000400064O00FB00045O002E59009E00C20201009D0004B03O00C202012O00CD00046O006E000500013O00122O0006009F3O00122O000700A06O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004009602013O0004B03O009602012O00CD000400093O00066B0104009602013O0004B03O009602012O00CD0004000A3O00066B0104007802013O0004B03O007802012O00CD0004000B3O0006CC0004007B020100010004B03O007B02012O00CD0004000A3O0006CC00040096020100010004B03O009602012O00CD000400073O0020B40004000400884O00065O00202O0006000600894O00040006000200062O0004009602013O0004B03O009602012O00CD00046O006E000500013O00122O000600A13O00122O000700A26O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004009602013O0004B03O009602012O00CD00046O006E000500013O00122O000600A33O00122O000700A46O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004009802013O0004B03O00980201002E5900A500C2020100A60004B03O00C202012O00CD000400033O0020380104000400914O00055O00202O0005000500924O000600046O000700013O00122O000800A73O00122O000900A86O0007000900024O0008000C6O000900096O000A00063O00202O000A000A00234O000C5O00202O000C000C00924O000A000C00024O000A000A6O000B000B3O00122O000C00956O000D00013O00122O000E00A93O00122O000F00AA6O000D000F00024O000C000C000D4O000D00013O00122O000E00AB3O00122O000F00AC6O000D000F00024O000C000C000D00202O000C000C009A4O0004000C000200062O000400BD020100010004B03O00BD0201002E6101AE00BD020100AD0004B03O00BD0201002E5900AF00C2020100B00004B03O00C202012O00CD000400013O001255010500B13O001255010600B24O008B000400064O00FB00045O001255010300063O0026C0000300C7020100060004B03O00C70201002E0001B30038FF2O00B40004B03O00FD2O010012550102000C3O0004B03O00CA02010004B03O00FD2O010026C0000200D0020100010004B03O00D00201002EE900B600D0020100B50004B03O00D00201002E5900B70010000100B80004B03O00100001001255010300013O002E0001B90006000100B90004B03O00D702010026D5000300D7020100060004B03O00D70201001255010200063O0004B03O00100001002E5001BA00D1020100BB0004B03O00D10201000E472O0100D1020100030004B03O00D10201002E0001BC0039000100BC0004B03O00140301002E5900BD0014030100BE0004B03O001403012O00CD00046O006E000500013O00122O000600BF3O00122O000700C06O0005000700024O00040004000500202O0004000400C14O00040002000200062O0004001403013O0004B03O001403012O00CD0004000D3O00066B0104001403013O0004B03O001403012O00CD0004000E3O00066B010400F202013O0004B03O00F202012O00CD0004000F3O0006CC000400F5020100010004B03O00F502012O00CD0004000E3O0006CC00040014030100010004B03O001403012O00CD000400104O00CD000500113O00061C00040014030100050004B03O001403012O00CD000400124O0027010500013O00122O000600C23O00122O000700C36O00050007000200062O00040014030100050004B03O001403012O00CD000400134O0002010500143O00202O0005000500C44O000600063O00202O0006000600C500122O000800C66O0006000800024O000600066O00040006000200062O0004000F030100010004B03O000F0301002E6101C7000F030100C80004B03O000F0301002E5900CA0014030100C90004B03O001403012O00CD000400013O001255010500CB3O001255010600CC4O008B000400064O00FB00045O002E5001CD006B030100CE0004B03O006B03012O00CD00046O006E000500013O00122O000600CF3O00122O000700D06O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004006B03013O0004B03O006B03012O00CD000400093O00066B0104006B03013O0004B03O006B03012O00CD0004000A3O00066B0104002903013O0004B03O002903012O00CD0004000B3O0006CC0004002C030100010004B03O002C03012O00CD0004000A3O0006CC0004006B030100010004B03O006B03012O00CD000400073O0020B40004000400884O00065O00202O0006000600894O00040006000200062O0004006B03013O0004B03O006B03012O00CD000400073O0020B40004000400264O00065O00202O0006000600274O00040006000200062O0004006B03013O0004B03O006B03012O00CD000400073O0020B40004000400884O00065O00202O00060006008E4O00040006000200062O0004006B03013O0004B03O006B0301002E5001D1006B030100D20004B03O006B0301002E0001D30028000100D30004B03O006B03012O00CD000400033O00205A0004000400914O00055O00202O0005000500924O000600046O000700013O00122O000800D43O00122O000900D56O0007000900024O0008000C6O000900094O00CD000A00063O002095000A000A00234O000C5O00202O000C000C00924O000A000C00024O000A000A6O000B000B3O00122O000C00956O000D00013O00122O000E00D63O00122O000F00D74O0062000D000F00022O0044000C000C000D4O000D00013O00122O000E00D83O00122O000F00D96O000D000F00024O000C000C000D00202O000C000C009A4O0004000C000200062O0004006B03013O0004B03O006B03012O00CD000400013O001255010500DA3O001255010600DB4O008B000400064O00FB00045O001255010300063O0004B03O00D102010004B03O001000010026D5000100B6030100DC0004B03O00B603012O00CD00026O006E000300013O00122O000400DD3O00122O000500DE6O0003000500024O00020002000300202O00020002000F4O00020002000200062O0002009303013O0004B03O00930301001239010200DF3O00066B0102009303013O0004B03O00930301002E5900E10093030100E00004B03O009303012O00CD000200033O0020420102000200214O00035O00202O0003000300224O000400046O000500156O000600063O00202O0006000600234O00085O00202O0008000800224O0006000800024O000600066O00020006000200062O0002009303013O0004B03O009303012O00CD000200013O001255010300E23O001255010400E34O008B000200044O00FB00025O002E5001E500670D0100E40004B03O00670D012O00CD00026O006E000300013O00122O000400E63O00122O000500E76O0003000500024O00020002000300202O00020002000F4O00020002000200062O000200A203013O0004B03O00A203012O00CD000200163O0006CC000200A4030100010004B03O00A40301002E5001E800670D0100E90004B03O00670D012O00CD000200134O000901035O00202O0003000300EA4O000400063O00202O0004000400234O00065O00202O0006000600EA4O0004000600024O000400046O00020004000200062O000200670D013O0004B03O00670D012O00CD000200013O0012D9000300EB3O00122O000400EC6O000200046O00025O00044O00670D010026D50001000B050100ED0004B03O000B0501001255010200014O00C9000300033O002E5001EE00BA030100EF0004B03O00BA03010026D5000200BA030100010004B03O00BA0301001255010300013O0026D500030033040100060004B03O00330401001255010400013O002E5900F10029040100F00004B03O00290401000E472O010029040100040004B03O002904012O00CD00056O006E000600013O00122O000700F23O00122O000800F36O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500E803013O0004B03O00E803012O00CD000500173O00066B010500E803013O0004B03O00E803012O00CD000500184O005C01050001000200066B010500E803013O0004B03O00E803012O00CD000500134O000901065O00202O0006000600F44O000700063O00202O0007000700234O00095O00202O0009000900F44O0007000900024O000700076O00050007000200062O000500E803013O0004B03O00E803012O00CD000500013O001255010600F53O001255010700F64O008B000500074O00FB00056O00CD00056O006E000600013O00122O000700F73O00122O000800F86O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005000B04013O0004B03O000B04012O00CD000500193O00066B0105000B04013O0004B03O000B04012O00CD000500073O0020B40005000500264O00075O00202O0007000700F94O00050007000200062O0005000B04013O0004B03O000B04012O00CD000500073O0020970005000500FA4O00075O00202O0007000700FB4O0005000700024O00068O000700013O00122O000800FC3O00122O000900FD6O0007000900024O00060006000700202O0006000600FE4O00060002000200062O0006000D040100050004B03O000D0401002E5001000128040100FF0004B03O002804010012550105002O012O00125501060002012O00061C00060028040100050004B03O002804012O00CD000500134O001101065O00122O00070003015O0006000600074O000700063O00202O0007000700234O00095O00122O000A0003015O00090009000A4O0007000900024O000700076O00050007000200062O00050023040100010004B03O0023040100125501050004012O00125501060005012O00061C00050028040100060004B03O002804012O00CD000500013O00125501060006012O00125501070007013O008B000500074O00FB00055O001255010400063O001255010500063O0006A800040030040100050004B03O0030040100125501050008012O00125501060009012O000652010500C2030100060004B03O00C203010012550103000C3O0004B03O003304010004B03O00C203010012550104000C3O00065201040062040100030004B03O006204012O00CD00046O006E000500013O00122O0006000A012O00122O0007000B015O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004004704013O0004B03O004704012O00CD000400173O00066B0104004704013O0004B03O004704012O00CD0004001A4O005C0104000100020006CC0004004B040100010004B03O004B04010012550104000C012O0012550105000D012O0006DE00040060040100050004B03O006004012O00CD000400134O00BD00055O00202O0005000500F44O000600063O00202O0006000600234O00085O00202O0008000800F44O0006000800024O000600066O00040006000200062O0004005B040100010004B03O005B04010012550104000E012O0012550105000F012O0006DE00050060040100040004B03O006004012O00CD000400013O00125501050010012O00125501060011013O008B000400064O00FB00045O0012552O01004F3O0004B03O000B050100125501040012012O00125501050013012O00061C000500BF030100040004B03O00BF0301001255010400013O000652010300BF030100040004B03O00BF03012O00CD00046O006E000500013O00122O00060014012O00122O00070015015O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400B904013O0004B03O00B904012O00CD0004001B3O00066B010400B904013O0004B03O00B904012O00CD00046O006E000500013O00122O00060016012O00122O00070017015O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400B904013O0004B03O00B904012O00CD0004001A4O005C0104000100020006CC000400B9040100010004B03O00B904012O00CD000400184O005C0104000100020006CC00040095040100010004B03O009504012O00CD000400073O00128F00060018015O00040004000600122O00060019012O00122O0007000C6O00040007000200062O000400B904013O0004B03O00B904012O00CD0004001C4O005C010400010002001255010500173O00061C000400B9040100050004B03O00B904012O00CD0004001D4O00AE0004000100024O00058O000600013O00122O0007001A012O00122O0008001B015O0006000800024O00050005000600122O0007001C015O0005000500074O000500020002001255010600ED4O005100050006000500122O0006001D015O0005000600054O0006001E6O00078O000800013O00122O0009001E012O00122O000A001F015O0008000A00024O0007000700080020BC00070007001C2O001D000700086O00063O000200122O0007000C6O0006000700064O00050005000600122O00060020015O00050005000600062O000400B9040100050004B03O00B904012O00CD0004001F3O001255010500ED3O00067F000400C1040100050004B03O00C1040100125501040021012O00125501050022012O00064900050005000100040004B03O00C1040100125501040023012O00125501050024012O0006DE000500DB040100040004B03O00DB040100125501040025012O00125501050026012O00061C000400DB040100050004B03O00DB04012O00CD000400033O0020820004000400214O00055O00122O00060027015O0005000500064O000600046O0007000C6O000800063O00202O0008000800234O000A5O00122O000B0027015O000A000A000B4O0008000A00024O000800086O00040008000200062O000400DB04013O0004B03O00DB04012O00CD000400013O00125501050028012O00125501060029013O008B000400064O00FB00045O0012550104002A012O0012550105002A012O00065201040007050100050004B03O000705012O00CD00046O006E000500013O00122O0006002B012O00122O0007002C015O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004000705013O0004B03O000705012O00CD000400193O00066B0104000705013O0004B03O000705012O00CD000400184O005C01040001000200066B0104000705013O0004B03O000705010012550104002D012O0012550105002E012O0006DE00050007050100040004B03O000705012O00CD000400134O006701055O00122O00060003015O0005000500064O000600063O00202O0006000600234O00085O00122O00090003015O0008000800094O0006000800024O000600066O00040006000200062O0004000705013O0004B03O000705012O00CD000400013O0012550105002F012O00125501060030013O008B000400064O00FB00045O001255010300063O0004B03O00BF03010004B03O000B05010004B03O00BA030100125501020031012O00125501030032012O0006DE000300A2060100020004B03O00A2060100125501020033012O0006A800020016050100010004B03O0016050100125501020034012O00125501030035012O00061C000200A2060100030004B03O00A206012O00CD00026O006E000300013O00122O00040036012O00122O00050037015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002003105013O0004B03O003105012O00CD000200203O00066B0102003105013O0004B03O003105012O00CD0002001F3O001255010300173O00065201020031050100030004B03O003105012O00CD00026O006E000300013O00122O00040038012O00122O00050039015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002003505013O0004B03O003505010012550102003A012O0012550103003B012O00061C00020048050100030004B03O004805012O00CD000200134O006701035O00122O0004003C015O0003000300044O000400063O00202O0004000400234O00065O00122O0007003C015O0006000600074O0004000600024O000400046O00020004000200062O0002004805013O0004B03O004805012O00CD000200013O0012550103003D012O0012550104003E013O008B000200044O00FB00025O0012550102003F012O00125501030040012O0006DE00020086050100030004B03O008605012O00CD00026O006E000300013O00122O00040041012O00122O00050042015O0003000500024O00020002000300202O0002000200C14O00020002000200062O0002008605013O0004B03O008605012O00CD000200213O00066B0102008605013O0004B03O008605012O00CD00026O006E000300013O00122O00040043012O00122O00050044015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002008605013O0004B03O0086050100125501020045012O00125501030046012O0006DE00030086050100020004B03O008605012O00CD000200033O0020F70002000200914O00035O00122O00040047015O0003000300044O000400046O000500013O00122O00060048012O00122O00070049015O0005000700024O000600224O00C9000700074O005E010800063O00202O0008000800234O000A5O00122O000B0047015O000A000A000B4O0008000A00024O000800086O00020008000200062O00020081050100010004B03O008105010012550102004A012O0012550103004B012O00065201020086050100030004B03O008605012O00CD000200013O0012550103004C012O0012550104004D013O008B000200044O00FB00026O00CD00026O006E000300013O00122O0004004E012O00122O0005004F015O0003000500024O00020002000300202O0002000200C14O00020002000200062O0002009D05013O0004B03O009D05012O00CD000200213O00066B0102009D05013O0004B03O009D05012O00CD00026O0093000300013O00122O00040050012O00122O00050051015O0003000500024O00020002000300202O00020002001C4O00020002000200062O000200A5050100010004B03O00A5050100125501020052012O00125501030053012O00064900020005000100030004B03O00A5050100125501020054012O00125501030055012O0006DE000300C0050100020004B03O00C0050100125501020056012O00125501030056012O000652010200C0050100030004B03O00C0050100125501020057012O00125501030058012O0006DE000200C0050100030004B03O00C005012O00CD000200134O006701035O00122O00040047015O0003000300044O000400063O00202O0004000400234O00065O00122O00070047015O0006000600074O0004000600024O000400046O00020004000200062O000200C005013O0004B03O00C005012O00CD000200013O00125501030059012O0012550104005A013O008B000200044O00FB00025O0012550102005B012O0012550103005C012O00061C00030029060100020004B03O002906012O00CD00026O006E000300013O00122O0004005D012O00122O0005005E015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002002906013O0004B03O002906012O00CD00026O0064000300013O00122O0004005F012O00122O00050060015O0003000500024O00020002000300122O00040061015O0002000200044O00020002000200122O000300013O00062O00020029060100030004B03O002906012O00CD000200233O00066B0102002906013O0004B03O002906012O00CD000200073O0020B40002000200884O00045O00202O0004000400FB4O00020004000200062O0002002906013O0004B03O002906012O00CD00026O006E000300013O00122O00040062012O00122O00050063015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002002906013O0004B03O002906012O00CD00026O006E000300013O00122O00040064012O00122O00050065015O0003000500024O00020002000300202O00020002001C4O00020002000200062O00022O0006013O0004B04O0006012O00CD0002001F3O001255010300ED3O00061C00022O00060100030004B04O0006012O00CD0002001A4O005C01020001000200066B0102000E06013O0004B03O000E06012O00CD00026O006E000300013O00122O00040066012O00122O00050067015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002002906013O0004B03O002906012O00CD0002001F3O001255010300173O00065201020029060100030004B03O0029060100125501020068012O00125501030069012O00061C00020029060100030004B03O002906010012550102006A012O0012550103006B012O0006DE00020029060100030004B03O002906012O00CD000200134O006701035O00122O0004006C015O0003000300044O000400063O00202O0004000400234O00065O00122O0007006C015O0006000600074O0004000600024O000400046O00020004000200062O0002002906013O0004B03O002906012O00CD000200013O0012550103006D012O0012550104006E013O008B000200044O00FB00025O0012550102006F012O00125501030070012O0006DE00030084060100020004B03O008406012O00CD00026O006E000300013O00122O00040071012O00122O00050072015O0003000500024O00020002000300202O00020002000F4O00020002000200062O0002008406013O0004B03O008406012O00CD000200163O00066B0102008406013O0004B03O008406012O00CD000200073O0020B40002000200884O00045O00202O0004000400FB4O00020004000200062O0002008406013O0004B03O008406012O00CD000200244O005C01020001000200066B0102008406013O0004B03O008406012O00CD00026O006E000300013O00122O00040073012O00122O00050074015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002008406013O0004B03O008406012O00CD000200063O0012E300040075015O0002000200044O00045O00122O00050076015O0004000400054O00020004000200062O00020064060100010004B03O006406012O00CD000200073O00209B0002000200FA4O00045O00122O00050077015O0004000400054O0002000400024O000300073O00122O00050078015O0003000300054O00030002000200062O00020084060100030004B03O008406012O00CD00026O006E000300013O00122O00040079012O00122O0005007A015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002007606013O0004B03O007606012O00CD0002001F3O001255010300ED3O00061C00020076060100030004B03O007606012O00CD0002001A4O005C01020001000200066B0102008806013O0004B03O008806012O00CD00026O006E000300013O00122O0004007B012O00122O0005007C015O0003000500024O00020002000300202O00020002001C4O00020002000200062O0002008406013O0004B03O008406012O00CD0002001F3O001255010300173O0006A800020088060100030004B03O008806010012550102007D012O0012550103007E012O0006DE000200A1060100030004B03O00A106010012550102007F012O00125501030080012O00061C000200A1060100030004B03O00A106012O00CD000200134O00BD00035O00202O0003000300EA4O000400063O00202O0004000400234O00065O00202O0006000600EA4O0004000600024O000400046O00020004000200062O0002009C060100010004B03O009C060100125501020081012O00125501030082012O000652010200A1060100030004B03O00A106012O00CD000200013O00125501030083012O00125501040084013O008B000200044O00FB00025O0012552O0100ED3O00125501020085012O00125501030085012O000652010200FD070100030004B03O00FD070100125501020086012O0006522O0100FD070100020004B03O00FD0701001255010200013O00125501030087012O00125501040088012O00061C00030035070100040004B03O00350701001255010300013O00065201030035070100020004B03O0035070100125501030089012O0012550104008A012O0006DE000300EE060100040004B03O00EE06012O00CD00036O006E000400013O00122O0005008B012O00122O0006008C015O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300EE06013O0004B03O00EE06012O00CD0003001B3O00066B010300EE06013O0004B03O00EE06012O00CD000300073O0020C70003000300264O00055O00122O0006008D015O0005000500064O00030005000200062O000300EE06013O0004B03O00EE06012O00CD00036O006E000400013O00122O0005008E012O00122O0006008F015O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300EE06013O0004B03O00EE060100125501030090012O00125501040091012O00061C000400EE060100030004B03O00EE06012O00CD000300033O0020820003000300214O00045O00122O00050027015O0004000400054O000500046O0006000C6O000700063O00202O0007000700234O00095O00122O000A0027015O00090009000A4O0007000900024O000700076O00030007000200062O000300EE06013O0004B03O00EE06012O00CD000300013O00125501040092012O00125501050093013O008B000300054O00FB00035O00125501030094012O00125501040095012O00061C00040034070100030004B03O003407012O00CD00036O006E000400013O00122O00050096012O00122O00060097015O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003001907013O0004B03O001907012O00CD00036O0064000400013O00122O00050098012O00122O00060099015O0004000600024O00030003000400122O00050061015O0003000300054O00030002000200122O000400013O00062O00030019070100040004B03O001907012O00CD000300233O00066B0103001907013O0004B03O001907012O00CD00036O006E000400013O00122O0005009A012O00122O0006009B015O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003001907013O0004B03O001907012O00CD000300253O001255010400ED3O00067F0003001D070100040004B03O001D07010012550103009C012O0012550104009D012O0006DE00040034070100030004B03O003407012O00CD000300134O001101045O00122O0005006C015O0004000400054O000500063O00202O0005000500234O00075O00122O0008006C015O0007000700084O0005000700024O000500056O00030005000200062O0003002F070100010004B03O002F07010012550103009E012O0012550104009F012O00065201030034070100040004B03O003407012O00CD000300013O001255010400A0012O001255010500A1013O008B000300054O00FB00035O001255010200063O001255010300A2012O001255010400BC3O00061C000400CD070100030004B03O00CD0701001255010300063O000652010200CD070100030004B03O00CD0701001255010300013O001255010400013O0006A800030044070100040004B03O00440701001255010400A3012O001255010500A4012O0006DE000400C3070100050004B03O00C307012O00CD00046O006E000500013O00122O000600A5012O00122O000700A6015O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004008707013O0004B03O008707012O00CD000400163O00066B0104008707013O0004B03O008707012O00CD000400244O005C01040001000200066B0104008707013O0004B03O008707012O00CD00046O006E000500013O00122O000600A7012O00122O000700A8015O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004008707013O0004B03O008707012O00CD000400063O00127701060075015O0004000400064O00065O00122O00070076015O0006000600074O00040006000200062O0004008707013O0004B03O008707012O00CD0004001F3O001255010500ED3O00061C00040087070100050004B03O008707012O00CD00046O006E000500013O00122O000600A9012O00122O000700AA015O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004008707013O0004B03O008707012O00CD000400134O000901055O00202O0005000500EA4O000600063O00202O0006000600234O00085O00202O0008000800EA4O0006000800024O000600066O00040006000200062O0004008707013O0004B03O008707012O00CD000400013O001255010500AB012O001255010600AC013O008B000400064O00FB00046O00CD00046O006E000500013O00122O000600AD012O00122O000700AE015O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400A307013O0004B03O00A307012O00CD000400193O00066B010400A307013O0004B03O00A307012O00CD000400073O0020970004000400FA4O00065O00202O0006000600FB4O0004000600024O00058O000600013O00122O000700AF012O00122O000800B0015O0006000800024O00050005000600202O0005000500FE4O00050002000200062O000500AB070100040004B03O00AB0701001255010400B1012O00125501050069012O00064900050005000100040004B03O00AB0701001255010400B2012O001255010500B3012O00061C000400C2070100050004B03O00C207012O00CD000400134O001101055O00122O00060003015O0005000500064O000600063O00202O0006000600234O00085O00122O00090003015O0008000800094O0006000800024O000600066O00040006000200062O000400BD070100010004B03O00BD0701001255010400B4012O001255010500B5012O0006DE000400C2070100050004B03O00C207012O00CD000400013O001255010500B6012O001255010600B7013O008B000400064O00FB00045O001255010300063O001255010400063O0006A8000400CA070100030004B03O00CA0701001255010400B8012O001255010500B9012O0006DE0004003D070100050004B03O003D07010012550102000C3O0004B03O00CD07010004B03O003D07010012550103000C3O000652010200AA060100030004B03O00AA0601001255010300BA012O001255010400BA012O000652010300FA070100040004B03O00FA0701001255010300BB012O001255010400BC012O00061C000300FA070100040004B03O00FA07012O00CD00036O006E000400013O00122O000500BD012O00122O000600BE015O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300FA07013O0004B03O00FA07012O00CD000300173O00066B010300FA07013O0004B03O00FA0701001255010300BF012O001255010400C0012O00061C000300FA070100040004B03O00FA07012O00CD000300134O000901045O00202O0004000400F44O000500063O00202O0005000500234O00075O00202O0007000700F44O0005000700024O000500056O00030005000200062O000300FA07013O0004B03O00FA07012O00CD000300013O001255010400C1012O001255010500C2013O008B000300054O00FB00035O0012552O0100DC3O0004B03O00FD07010004B03O00AA0601001255010200C3012O001255010300C4012O0006DE000200AE090100030004B03O00AE0901001255010200C5012O001255010300C6012O00061C000200AE090100030004B03O00AE09010012550102000C3O0006522O0100AE090100020004B03O00AE0901001255010200013O001255010300013O000652010200D5080100030004B03O00D50801001255010300013O001255010400013O0006A800030014080100040004B03O00140801001255010400C7012O001255010500C8012O00061C000400CF080100050004B03O00CF08012O00CD00046O006E000500013O00122O000600C9012O00122O000700CA015O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004003E08013O0004B03O003E08012O00CD000400263O00066B0104003E08013O0004B03O003E08012O00CD000400273O00066B0104002708013O0004B03O002708012O00CD0004000F3O0006CC0004002A080100010004B03O002A08012O00CD000400273O0006CC0004003E080100010004B03O003E08012O00CD000400104O00CD000500113O00061C0004003E080100050004B03O003E0801001255010400CB012O001255010500CC012O0006DE0005003E080100040004B03O003E08012O00CD000400134O003B00055O00122O000600CD015O0005000500064O00040002000200062O0004003E08013O0004B03O003E08012O00CD000400013O001255010500CE012O001255010600CF013O008B000400064O00FB00045O001255010400D0012O001255010500D1012O0006DE000400CE080100050004B03O00CE08012O00CD00046O006E000500013O00122O000600D2012O00122O000700D3015O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400CE08013O0004B03O00CE08012O00CD0004001B3O00066B010400CE08013O0004B03O00CE08012O00CD000400073O0020C70004000400264O00065O00122O0007008D015O0006000600074O00040006000200062O000400CE08013O0004B03O00CE08012O00CD00046O006E000500013O00122O000600D4012O00122O000700D5015O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400CE08013O0004B03O00CE08012O00CD0004001A4O005C0104000100020006CC000400CE080100010004B03O00CE08012O00CD0004001D4O00AE0004000100024O00058O000600013O00122O000700D6012O00122O000800D7015O0006000800024O00050005000600122O0007001C015O0005000500074O000500020002001255010600ED4O005100050006000500122O0006001D015O0005000600054O0006001E6O00078O000800013O00122O000900D8012O00122O000A00D9015O0008000A00024O0007000700080020BC00070007001C2O0026010700086O00063O000200122O0007000C6O0006000700064O00050005000600062O000500CE080100040004B03O00CE08012O00CD00046O0093000500013O00122O000600DA012O00122O000700DB015O0005000700024O00040004000500202O00040004001C4O00040002000200062O00040097080100010004B03O009708012O00CD00046O006E000500013O00122O000600DC012O00122O000700DD015O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004009F08013O0004B03O009F08012O00CD000400073O0020C70004000400264O00065O00122O000700DE015O0006000600074O00040006000200062O000400CE08013O0004B03O00CE08012O00CD000400073O0020B40004000400884O00065O00202O0006000600FB4O00040006000200062O000400B408013O0004B03O00B408012O00CD0004001F3O001255010500173O00061C000500B4080100040004B03O00B408012O00CD00046O006E000500013O00122O000600DF012O00122O000700E0015O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400B808013O0004B03O00B808012O00CD000400253O001255010500173O000652010400CE080100050004B03O00CE08012O00CD000400033O0020820004000400214O00055O00122O00060027015O0005000500064O000600046O0007000C6O000800063O00202O0008000800234O000A5O00122O000B0027015O000A000A000B4O0008000A00024O000800086O00040008000200062O000400CE08013O0004B03O00CE08012O00CD000400013O001255010500E1012O001255010600E2013O008B000400064O00FB00045O001255010300063O001255010400063O0006520103000D080100040004B03O000D0801001255010200063O0004B03O00D508010004B03O000D0801001255010300E3012O001255010400E4012O00061C0004005F090100030004B03O005F0901001255010300063O0006520102005F090100030004B03O005F09012O00CD00036O006E000400013O00122O000500E5012O00122O000600E6015O0004000600024O00030003000400202O0003000300C14O00030002000200062O0003000209013O0004B03O000209012O00CD000300283O00066B0103000209013O0004B03O000209012O00CD000300294O0027010400013O00122O000500E7012O00122O000600E8015O00040006000200062O00030002090100040004B03O000209012O00CD00036O0093000400013O00122O000500E9012O00122O000600EA015O0004000600024O00030003000400202O00030003001C4O00030002000200062O00030002090100010004B03O000209012O00CD0003001F3O001255010400173O00061C00040002090100030004B03O000209012O00CD000300253O001255010400173O00067F00040006090100030004B03O00060901001255010300EB012O001255010400EC012O0006DE0004001B090100030004B03O001B0901001255010300ED012O001255010400EE012O0006DE0003001B090100040004B03O001B09012O00CD000300134O0040000400143O00122O000500EF015O0004000400054O000500063O00202O0005000500C500122O000700C66O0005000700024O000500056O00030005000200062O0003001B09013O0004B03O001B09012O00CD000300013O001255010400F0012O001255010500F1013O008B000300054O00FB00035O001255010300F2012O001255010400F2012O0006520103005E090100040004B03O005E09012O00CD00036O006E000400013O00122O000500F3012O00122O000600F4015O0004000600024O00030003000400202O0003000300C14O00030002000200062O0003005E09013O0004B03O005E09012O00CD000300283O00066B0103005E09013O0004B03O005E09012O00CD000300294O0027010400013O00122O000500F5012O00122O000600F6015O00040006000200062O0003005E090100040004B03O005E09012O00CD00036O0093000400013O00122O000500F7012O00122O000600F8015O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003005E090100010004B03O005E09012O00CD0003001F3O001255010400173O00061C0004005E090100030004B03O005E09012O00CD000300253O001255010400173O00061C0004005E090100030004B03O005E09012O00CD000300134O00FA000400143O00122O000500F9015O0004000400054O000500063O00202O0005000500C500122O000700C66O0005000700024O000500056O00030005000200062O00030059090100010004B03O00590901001255010300FA012O001255010400FB012O00067F00030059090100040004B03O00590901001255010300FC012O001255010400FD012O00061C0004005E090100030004B03O005E09012O00CD000300013O001255010400FE012O001255010500FF013O008B000300054O00FB00035O0012550102000C3O0012550103000C3O0006A800020066090100030004B03O0066090100125501032O00022O00125501040001022O00061C00040009080100030004B03O000908012O00CD00036O006E000400013O00122O0005002O022O00122O00060003025O0004000600024O00030003000400202O0003000300C14O00030002000200062O000300AB09013O0004B03O00AB09012O00CD000300283O00066B010300AB09013O0004B03O00AB09012O00CD000300294O0027010400013O00122O00050004022O00122O00060005025O00040006000200062O000300AB090100040004B03O00AB09012O00CD00036O0093000400013O00122O00050006022O00122O00060007025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300AB090100010004B03O00AB09012O00CD00036O0093000400013O00122O00050008022O00122O00060009025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300AB090100010004B03O00AB09012O00CD0003001F3O001255010400173O000652010300AB090100040004B03O00AB09012O00CD000300253O001255010400173O000652010300AB090100040004B03O00AB09012O00CD000300134O00FA000400143O00122O000500EF015O0004000400054O000500063O00202O0005000500C500122O000700C66O0005000700024O000500056O00030005000200062O000300A6090100010004B03O00A609010012550103000A022O0012550104000B022O0006DE000400AB090100030004B03O00AB09012O00CD000300013O0012550104000C022O0012550105000D023O008B000300054O00FB00035O0012552O0100173O0004B03O00AE09010004B03O000908010012550102000E022O0012550103000F022O0006DE000200FD0A0100030004B03O00FD0A010012550102004F3O000652010200FD0A0100010004B03O00FD0A01001255010200013O001255010300013O0006520102002D0A0100030004B03O002D0A0100125501030010022O00125501040011022O00061C000400F7090100030004B03O00F709012O00CD00036O006E000400013O00122O00050012022O00122O00060013025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300F709013O0004B03O00F709012O00CD000300193O00066B010300F709013O0004B03O00F709012O00CD0003001F3O0012550104004F3O0006DE000400F7090100030004B03O00F709012O00CD000300073O0020B40003000300264O00055O00202O0005000500274O00030005000200062O000300F709013O0004B03O00F709012O00CD000300073O0020ED0003000300FA4O00055O00202O0005000500FB4O0003000500024O00048O000500013O00122O00060014022O00122O00070015025O0005000700024O00040004000500202O0004000400FE4O00040002000200062O000400F7090100030004B03O00F709012O00CD000300134O006701045O00122O00050003015O0004000400054O000500063O00202O0005000500234O00075O00122O00080003015O0007000700084O0005000700024O000500056O00030005000200062O000300F709013O0004B03O00F709012O00CD000300013O00125501040016022O00125501050017023O008B000300054O00FB00035O00125501030018022O00125501040019022O00061C0004002C0A0100030004B03O002C0A010012550103001A022O0012550104001B022O0006DE0003002C0A0100040004B03O002C0A012O00CD00036O006E000400013O00122O0005001C022O00122O0006001D025O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003002C0A013O0004B03O002C0A012O00CD000300173O00066B0103002C0A013O0004B03O002C0A012O00CD0003001F3O0012550104004F3O0006DE0004002C0A0100030004B03O002C0A012O00CD000300073O0020B40003000300264O00055O00202O0005000500274O00030005000200062O0003002C0A013O0004B03O002C0A010012550103001E022O0012550104001F022O00061C0003002C0A0100040004B03O002C0A012O00CD000300134O000901045O00202O0004000400F44O000500063O00202O0005000500234O00075O00202O0007000700F44O0005000700024O000500056O00030005000200062O0003002C0A013O0004B03O002C0A012O00CD000300013O00125501040020022O00125501050021023O008B000300054O00FB00035O001255010200063O0012550103000C3O0006A8000200340A0100030004B03O00340A0100125501030022022O001255010400183O00061C000300730A0100040004B03O00730A012O00CD00036O006E000400013O00122O00050023022O00122O00060024025O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003004F0A013O0004B03O004F0A012O00CD0003001B3O00066B0103004F0A013O0004B03O004F0A012O00CD0003001F3O001255010400173O0006520103004F0A0100040004B03O004F0A012O00CD00036O0093000400013O00122O00050025022O00122O00060026025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300530A0100010004B03O00530A0100125501030027022O00125501040028022O00061C000400710A0100030004B03O00710A0100125501030029022O00125501040029022O000652010300710A0100040004B03O00710A010012550103002A022O0012550104002B022O0006DE000400710A0100030004B03O00710A012O00CD000300033O0020820003000300214O00045O00122O00050027015O0004000400054O000500046O0006000C6O000700063O00202O0007000700234O00095O00122O000A0027015O00090009000A4O0007000900024O000700076O00030007000200062O000300710A013O0004B03O00710A012O00CD000300013O0012550104002C022O0012550105002D023O008B000300054O00FB00035O0012552O010086012O0004B03O00FD0A01001255010300063O0006A80002007A0A0100030004B03O007A0A010012550103002E022O0012550104002F022O00061C000300B6090100040004B03O00B609012O00CD00036O006E000400013O00122O00050030022O00122O00060031025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300A10A013O0004B03O00A10A012O00CD0003001B3O00066B010300A10A013O0004B03O00A10A012O00CD000300073O0020C70003000300264O00055O00122O0006008D015O0005000500064O00030005000200062O000300A10A013O0004B03O00A10A012O00CD00036O006E000400013O00122O00050032022O00122O00060033025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300A10A013O0004B03O00A10A012O00CD000300073O0020330003000300264O00055O00122O00060034025O0005000500064O00030005000200062O000300A50A0100010004B03O00A50A0100125501030035022O00125501040036022O0006DE000400BC0A0100030004B03O00BC0A012O00CD000300134O001101045O00122O00050027015O0004000400054O000500063O00202O0005000500234O00075O00122O00080027015O0007000700084O0005000700024O000500056O00030005000200062O000300B70A0100010004B03O00B70A0100125501030037022O00125501040038022O00061C000300BC0A0100040004B03O00BC0A012O00CD000300013O00125501040039022O0012550105003A023O008B000300054O00FB00035O0012550103003B022O0012550104003C022O0006DE000300FB0A0100040004B03O00FB0A012O00CD00036O006E000400013O00122O0005003D022O00122O0006003E025O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300E00A013O0004B03O00E00A012O00CD000300193O00066B010300E00A013O0004B03O00E00A012O00CD0003001A4O005C01030001000200066B010300E00A013O0004B03O00E00A012O00CD000300073O0020970003000300FA4O00055O00202O0005000500FB4O0003000500024O00048O000500013O00122O0006003F022O00122O00070040025O0005000700024O00040004000500202O0004000400FE4O00040002000200062O000400E40A0100030004B03O00E40A0100125501030041022O00125501040042022O0006DE000300FB0A0100040004B03O00FB0A01001255010300E03O00125501040043022O0006DE000400FB0A0100030004B03O00FB0A012O00CD000300134O006701045O00122O00050003015O0004000400054O000500063O00202O0005000500234O00075O00122O00080003015O0007000700084O0005000700024O000500056O00030005000200062O000300FB0A013O0004B03O00FB0A012O00CD000300013O00125501040044022O00125501050045023O008B000300054O00FB00035O0012550102000C3O0004B03O00B6090100125501020046022O00125501030047022O0006DE000200120C0100030004B03O00120C01001255010200013O0006522O0100120C0100020004B03O00120C0100125501020048022O00125501030049022O00061C0003002E0B0100020004B03O002E0B012O00CD00026O006E000300013O00122O0004004A022O00122O0005004B025O0003000500024O00020002000300202O0002000200C14O00020002000200062O0002002E0B013O0004B03O002E0B012O00CD0002002A3O00066B0102002E0B013O0004B03O002E0B012O00CD0002002B3O00066B0102001B0B013O0004B03O001B0B012O00CD0002000F3O0006CC0002001E0B0100010004B03O001E0B012O00CD0002002B3O0006CC0002002E0B0100010004B03O002E0B012O00CD000200104O00CD000300113O00061C0002002E0B0100030004B03O002E0B012O00CD000200134O003B00035O00122O0004004C025O0003000300044O00020002000200062O0002002E0B013O0004B03O002E0B012O00CD000200013O0012550103004D022O0012550104004E023O008B000200044O00FB00025O0012550102007A3O0012550103004F022O0006DE000300640B0100020004B03O00640B012O00CD00026O006E000300013O00122O00040050022O00122O00050051025O0003000500024O00020002000300202O0002000200C14O00020002000200062O0002004C0B013O0004B03O004C0B012O00CD0002002C3O00066B0102004C0B013O0004B03O004C0B012O00CD0002002D3O00066B010200450B013O0004B03O00450B012O00CD0002000F3O0006CC000200480B0100010004B03O00480B012O00CD0002002D3O0006CC0002004C0B0100010004B03O004C0B012O00CD000200104O00CD000300113O00067F000200500B0100030004B03O00500B0100125501020052022O00125501030053022O0006DE000200640B0100030004B03O00640B0100125501020054022O00125501030055022O00061C000200640B0100030004B03O00640B012O00CD000200134O008900035O00122O00040056025O0003000300044O00020002000200062O0002005F0B0100010004B03O005F0B0100125501020057022O00125501030058022O0006DE000200640B0100030004B03O00640B012O00CD000200013O00125501030059022O0012550104005A023O008B000200044O00FB00026O00CD00026O006E000300013O00122O0004005B022O00122O0005005C025O0003000500024O00020002000300202O00020002001C4O00020002000200062O000200A60B013O0004B03O00A60B012O00CD00026O0064000300013O00122O0004005D022O00122O0005005E025O0003000500024O00020002000300122O00040061015O0002000200044O00020002000200122O000300013O00062O000200A60B0100030004B03O00A60B012O00CD000200073O0020330002000200264O00045O00122O0005005F025O0004000400054O00020004000200062O000200A60B0100010004B03O00A60B012O00CD0002002E3O00066B010200A60B013O0004B03O00A60B012O00CD0002002F3O00066B0102008B0B013O0004B03O008B0B012O00CD0002000B3O0006CC0002008E0B0100010004B03O008E0B012O00CD0002002F3O0006CC000200A60B0100010004B03O00A60B012O00CD000200104O00CD000300113O00061C000200A60B0100030004B03O00A60B012O00CD000200184O005C0102000100020006CC000200A60B0100010004B03O00A60B0100125501020060022O00125501030061022O00061C000200A60B0100030004B03O00A60B012O00CD000200134O003B00035O00122O00040062025O0003000300044O00020002000200062O000200A60B013O0004B03O00A60B012O00CD000200013O00125501030063022O00125501040064023O008B000200044O00FB00025O00125501020065022O00125501030066022O0006DE000200C30B0100030004B03O00C30B012O00CD00026O006E000300013O00122O00040067022O00122O00050068025O0003000500024O00020002000300202O00020002000F4O00020002000200062O000200C30B013O0004B03O00C30B012O00CD00026O00DB000300013O00122O00040069022O00122O0005006A025O0003000500024O00020002000300122O00040061015O0002000200044O00020002000200122O0003006B022O00062O000300C30B0100020004B03O00C30B012O00CD000200303O0006CC000200C70B0100010004B03O00C70B010012550102006C022O0012550103006D022O0006DE000300D70B0100020004B03O00D70B012O00CD000200134O008900035O00122O0004006E025O0003000300044O00020002000200062O000200D20B0100010004B03O00D20B010012550102006F022O00125501030070022O00061C000200D70B0100030004B03O00D70B012O00CD000200013O00125501030071022O00125501040072023O008B000200044O00FB00026O00CD00026O006E000300013O00122O00040073022O00122O00050074025O0003000500024O00020002000300202O0002000200C14O00020002000200062O000200F80B013O0004B03O00F80B012O00CD0002000D3O00066B010200F80B013O0004B03O00F80B012O00CD0002000E3O00066B010200EA0B013O0004B03O00EA0B012O00CD0002000F3O0006CC000200ED0B0100010004B03O00ED0B012O00CD0002000E3O0006CC000200F80B0100010004B03O00F80B012O00CD000200104O00CD000300113O00061C000200F80B0100030004B03O00F80B012O00CD000200124O005A010300013O00122O00040075022O00122O00050076025O00030005000200062O00022O000C0100030004B04O000C0100125501020077022O00125501030078022O0006A800022O000C0100030004B04O000C0100125501020079022O0012550103007A022O0006DE000200110C0100030004B03O00110C012O00CD000200134O0040000300143O00122O0004007B025O0003000300044O000400063O00202O0004000400C500122O000600C66O0004000600024O000400046O00020004000200062O000200110C013O0004B03O00110C012O00CD000200013O0012550103007C022O0012550104007D023O008B000200044O00FB00025O0012552O0100063O0012550102007E022O0012550103007F022O0006DE00030009000100020004B03O00090001001255010200173O0006522O010009000100020004B03O00090001001255010200014O00C9000300033O00125501040080022O00125501050081022O0006DE0005001B0C0100040004B03O001B0C01001255010400013O0006520102001B0C0100040004B03O001B0C01001255010300013O00125501040082022O00125501050083022O00061C000400A50C0100050004B03O00A50C01001255010400013O000652010300A50C0100040004B03O00A50C0100125501040084022O00125501050084022O000652010400730C0100050004B03O00730C012O00CD00046O006E000500013O00122O00060085022O00122O00070086025O0005000700024O00040004000500202O0004000400C14O00040002000200062O000400730C013O0004B03O00730C012O00CD000400283O00066B010400730C013O0004B03O00730C012O00CD000400294O0027010500013O00122O00060087022O00122O00070088025O00050007000200062O000400730C0100050004B03O00730C012O00CD00046O0093000500013O00122O00060089022O00122O0007008A025O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400730C0100010004B03O00730C012O00CD00046O0093000500013O00122O0006008B022O00122O0007008C025O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400730C0100010004B03O00730C012O00CD0004001F3O001255010500173O000652010400730C0100050004B03O00730C012O00CD000400253O001255010500173O000652010400730C0100050004B03O00730C012O00CD000400134O00FA000500143O00122O000600F9015O0005000500064O000600063O00202O0006000600C500122O000800C66O0006000800024O000600066O00040006000200062O0004006E0C0100010004B03O006E0C010012550104008D022O0012550105008E022O0006DE000400730C0100050004B03O00730C012O00CD000400013O0012550105008F022O00125501060090023O008B000400064O00FB00045O00125501040091022O00125501050092022O0006DE000500A40C0100040004B03O00A40C012O00CD00046O006E000500013O00122O00060093022O00122O00070094025O0005000700024O00040004000500202O0004000400C14O00040002000200062O000400A40C013O0004B03O00A40C012O00CD000400283O00066B010400A40C013O0004B03O00A40C012O00CD000400294O0027010500013O00122O00060095022O00122O00070096025O00050007000200062O000400A40C0100050004B03O00A40C012O00CD000400073O0020C70004000400264O00065O00122O000700DE015O0006000600074O00040006000200062O000400A40C013O0004B03O00A40C012O00CD000400134O0040000500143O00122O000600EF015O0005000500064O000600063O00202O0006000600C500122O000800C66O0006000800024O000600066O00040006000200062O000400A40C013O0004B03O00A40C012O00CD000400013O00125501050097022O00125501060098023O008B000400064O00FB00045O001255010300063O00125501040099022O0012550105009A022O00061C000400E00C0100050004B03O00E00C010012550104000C3O000652010300E00C0100040004B03O00E00C012O00CD00046O006E000500013O00122O0006009B022O00122O0007009C025O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400DE0C013O0004B03O00DE0C012O00CD000400203O00066B010400DE0C013O0004B03O00DE0C012O00CD00046O006E000500013O00122O0006009D022O00122O0007009E025O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400DE0C013O0004B03O00DE0C010012550104009F022O001255010500A0022O00061C000500DE0C0100040004B03O00DE0C01001255010400A1022O001255010500A2022O0006DE000400DE0C0100050004B03O00DE0C012O00CD000400134O006701055O00122O0006003C015O0005000500064O000600063O00202O0006000600234O00085O00122O0009003C015O0008000800094O0006000800024O000600066O00040006000200062O000400DE0C013O0004B03O00DE0C012O00CD000400013O001255010500A3022O001255010600A4023O008B000400064O00FB00045O0012552O010033012O0004B03O00090001001255010400063O000652010400230C0100030004B03O00230C01001255010400013O001255010500063O000652010400E90C0100050004B03O00E90C010012550103000C3O0004B03O00230C01001255010500013O000652010400E40C0100050004B03O00E40C01001255010500A5022O001255010600A6022O00061C000600210D0100050004B03O00210D012O00CD00056O006E000600013O00122O000700A7022O00122O000800A8025O0006000800024O00050005000600202O0005000500C14O00050002000200062O000500210D013O0004B03O00210D012O00CD000500283O00066B010500210D013O0004B03O00210D012O00CD000500294O0027010600013O00122O000700A9022O00122O000800AA025O00060008000200062O000500210D0100060004B03O00210D012O00CD000500073O0020C70005000500264O00075O00122O000800DE015O0007000700084O00050007000200062O000500210D013O0004B03O00210D012O00CD000500134O00FA000600143O00122O000700F9015O0006000600074O000700063O00202O0007000700C500122O000900C66O0007000900024O000700076O00050007000200062O0005001C0D0100010004B03O001C0D01001255010500AB022O001255010600AC022O0006DE000500210D0100060004B03O00210D012O00CD000500013O001255010600AD022O001255010700AE023O008B000500074O00FB00055O001255010500AF022O001255010600B0022O0006DE0006005F0D0100050004B03O005F0D01001255010500B1022O001255010600B2022O00061C0005005F0D0100060004B03O005F0D012O00CD00056O006E000600013O00122O000700B3022O00122O000800B4025O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005005F0D013O0004B03O005F0D012O00CD000500203O00066B0105005F0D013O0004B03O005F0D012O00CD00056O006E000600013O00122O000700B5022O00122O000800B6025O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005005F0D013O0004B03O005F0D012O00CD000500033O0020F70005000500914O00065O00122O0007003C015O0006000600074O000700046O000800013O00122O000900B7022O00122O000A00B8025O0008000A00024O000900224O00C9000A000A4O005E010B00063O00202O000B000B00234O000D5O00122O000E003C015O000D000D000E4O000B000D00024O000B000B6O0005000B000200062O0005005A0D0100010004B03O005A0D01001255010500B9022O001255010600A5022O00061C0006005F0D0100050004B03O005F0D012O00CD000500013O001255010600BA022O001255010700BB023O008B000500074O00FB00055O001255010400063O0004B03O00E40C010004B03O00230C010004B03O000900010004B03O001B0C010004B03O000900010004B03O00670D010004B03O000200012O00013O00017O00BD032O00028O00025O00049840025O00A88540026O00F03F025O00CC9740025O00F49340026O000840025O000DB240026O002A4003073O00C4A6827D05A14A03083O005C8DC5E71B70D333030B3O004973417661696C61626C6503073O00CFFC8FA5C4F4E603053O00B1869FEAC3030F3O00432O6F6C646F776E52656D61696E7303113O0098E73AA3DDAFE239A9CCB9D837AFCAB6F803053O00A9DD8B5FC0030C3O00F28278373628D785780D2D2203063O0046BEEB1F5F42030C3O0096EB1DEEF1B4EB14E1D7B5E603053O0085DA827A86025O00249B4003073O0049636566757279030E3O0049735370652O6C496E52616E676503183O0035FCE6C2C9B1217CECEACADBAF3D03EBE2D6DBA62C7CABB303073O00585C9F83A4BCC3030A3O00A63CB058C3D8D58F2DB403073O00BDE04EDF2BB78B030A3O0049734361737461626C6503113O000BF08F15D53CF58C1FC42ACF8219C225EF03053O00A14E9CEA76030D3O00446562752O6652656D61696E7303173O00456C65637472696669656453686F636B73446562752O66027O0040030B3O0042752O6652656D61696E73030B3O004963656675727942752O662O033O00474344030C3O008BBECED4B3B9C0D2A085C6D803043O00BCC7D7A9025O0036AA40025O00C8AF40030A3O0046726F737453686F636B025O006CA640026O009940031C3O00FA1B5068FCC31A5774EBF7494C72E6FB055A44FCFD1B587EFCBC5D0D03053O00889C693F1B025O0087B040025O00889240025O00108140025O0052B240025O00BEAD40025O00188340030A3O003D9E76270FBF713B188703043O00547BEC1903113O00D587AF14B8A7F98DA312A886F884A91CBF03063O00D590EBCA77CC026O004940030C3O000F11D9223C2D442D1FEC252C03073O002D4378BE4A4843025O00EEA640025O00889040031C3O002630E2B6EDB7FDE12F21E6E5EA81E0EE2C27D2B1F89AE9EC3462B9F103083O008940428DC599E88E025O0030A840025O0049B24003083O002FD134A7AA06D12F03053O00E863B042C6030E3O00417363656E64616E636542752O6603083O00C0203E075988F82103083O004C8C4148661BED9903083O004361737454696D6503073O0048617354696572026O003F40026O001040025O006DB040025O00FEB14003083O004C6176614265616D031A3O0046DB00D3E803BB4BD756C1DE0FB946DF29C6D613B94FCE56868103073O00DE2ABA76B2B761025O00149A40025O00649840030D3O0066F7A54A652F43F0A5607E2D5E03063O00412A9EC22211030C3O002932400B28E21DDE1530571E03083O008E7A47326C4D8D7B03133O0038A3EC0C3E07ADF90C331087F31D3610ACEB0B03053O005B75C29F78025O0020AF40025O0046A240025O0038AF40030D3O004C696768746E696E67426F6C74031F3O001614391021FF2D141A011A3AFD305A0E371632FD2125093F0A32F4305A4E6803073O00447A7D5E785591025O00D49540025O00D8AF40030D3O003B15C856DCD7B3191BED51C4CD03073O00DA777CAF3EA8B903063O0042752O66557003103O0053757267656F66506F77657242752O66030C3O0089F94FCCB1FE41CAA2C247C003043O00A4C59028025O004AA440025O0062AC40031F3O008FF9AD83C9B88AFEADB4DFB98FE4EA98D4B884FCAFB4C9B791F7AF9F9DE5DB03063O00D6E390CAEBBD025O007CA540025O00A2A840025O0042AA40025O00406D40025O00A07C40025O0019B340025O008EA140025O00D49340025O00889E40025O00DEB140025O00888440030D3O008DC1C43A42B0CDE23A4CB8C2DC03053O002FD9AEB05F03103O0094D46717BB505527BFD07736BD407D2B03083O0046D8BD1662D23418025O0080464003093O00F6DEB586E0CFCDA48203053O00B3BABFC3E703123O00CA2F14EDF72B1DF6FC3B3DE8FC321DEAED2C03043O0084995F78025O001EA940025O00D49140025O0086AD40025O00A6A040030D3O00546F74656D6963526563612O6C031E3O00A5BD1A28FAD3A38EA00B2EF6D6ACF1A10723F0D6A58EA60F3FF0DFB4F1E503073O00C0D1D26E4D97BA03103O00CC0A33FCF6C0CD0225E4FEF0EF1727E403063O00A4806342899F03063O00039CFBAD0F9B03043O00DE60E98903093O0095B2B11EBBE6E2BEB603073O0090D9D3C77FE89303123O00CB3F3221DB510756FD2B1B24D048074AEC3C03083O0024984F5E48B5256203103O00F1D44632D2EB4F30D4D3633AD5CD413903043O005FB7B827030F3O0041757261416374697665436F756E7403103O00466C616D6553686F636B446562752O66026O001840025O00907B40025O00CDB040025O002FB140025O00308E4003163O004C69717569644D61676D61546F74656D437572736F7203093O004973496E52616E6765026O004440025O00D09840025O0008AD4003223O00B936F6335D843DB83EE02B55BF16BA2BE22B14930BBB38EB236B9403A738E23214D803073O0062D55F874634E0025O00207940025O00BAA340025O003AB240025O00349140030D3O0008422CD0741DF9234E30C1501D03073O009C4E2B5EB53171025O00F0AB40025O00E09740030D3O0046697265456C656D656E74616C025O0062A840025O00FAA040031E3O0074E1D6A634467577E5C1AD1F427532FBCDAD0C4F7C4DFCC5B10C466D32BA03073O00191288A4C36B23030E3O00DB39A65D7F99CDBDE528A75B73B003083O00D8884DC92F12DCA1025O0066AB40025O00D0A740030E3O0053746F726D456C656D656E74616C031F3O003EF824C805E38721E926DF06C88321AC38D306DB8E28D33FDB1ADB8739AC7F03073O00E24D8C4BBA68BC03103O00D2AAD8625DFA8EC87059FF97C66351F303053O00349EC3A91703063O006AB0336D832703083O00EB1ADC5214E6551B03093O00A4A0FFC3479DB3EEC703053O0014E8C189A203123O0011CFC9AFE998126327DBE0AAE281127F36CC03083O001142BFA5C687EC7703103O0029A3AF1EFADBE4DE0CA48A162OFDEAD703083O00B16FCFCE739F888C025O009BB140025O0015B34003163O004C69717569644D61676D61546F74656D506C61796572025O00E49E40025O0026A34003223O0009802O01DD4B6008881719D5704B0A9D1519945C560B8E1C11EB5B5E178E1500941703073O003F65E97074B42F030E3O00F329E41FF724C732EC1ECF37D53E03063O0056A35B8D729803083O0042752O66446F776E03123O005072696D6F726469616C5761766542752O6603163O0053706C696E7465726564456C656D656E747342752O66025O0012A240025O00608F40030C3O00436173745461726765744966030E3O005072696D6F726469616C576176652O033O005E027A03053O005A336B141303083O0053652O74696E677303073O00AEFF88E23283E303053O005DED90E58F030C3O0031FFE30907470CC5E400074303063O0026759690796B03093O005369676E6174757265025O0022A240025O0010794003203O003DA9E73722A9EA332CB7D12D2CADEB7A3EB2E03D21BED12E2CA9E93F39FBBF6A03043O005A4DDB8E025O00549B40025O009CB140026O001440025O005AAD40025O0096A240025O0008B240025O00CC9D4003093O00DC4E4C86D25A4894E403043O00E7902F3A03133O009FD9C9611D2FC03FA6D0DF501438C23CBCCCC903083O0059D2B8BA15785DAF030C3O009D5A7BDD6D34B85D7BE7763E03063O005AD1331CB519025O00408B40025O006C9A40025O00A49140025O00F88C4003093O00436173744379636C6503093O004C6176614275727374025O0016AB40025O0028A340031B3O00DC7A41EF80D26E45FDAB90685EE0B8DC7E68FABEC27C52FAFF862B03053O00DFB01B378E03093O0008BAD8B406AEDCA63003043O00D544DBAE03133O0026E130F32FD730791FE826C226C0327A05F43003083O001F6B8043874AA55F025O00C05240030E3O00FDE4F94044BFCCE9F06F4DB0CBFC03063O00D1B8889C2D2103113O0034DF7004B40EC67225B902C4661CAA08C503053O00D867A81568025O00406040025O00C07040025O0044B340025O00D09940031B3O0074AC55A547AF56B66BB903B771A344A87D9257A56AAA46B038FB1103043O00C418CD23030A3O000B8AF112269AF607258E03043O00664EEB8303073O004973526561647903063O00F93B2657482B03083O00549A4E54242759D7031A3O004563686F65736F66477265617453756E646572696E6742752O66030E3O00D8ED535500F3F5575427F1E0454C03053O00659D813638025O00A49740025O00C89D4003103O0045617274687175616B65437572736F72025O0028A040025O0066A840031B3O0018A898BF2B6808A881AE636A14A78DA7264609A898AC266D5DFFDE03063O00197DC9EACB43025O00F0A340025O00688040025O0058A840025O00F3B240030A3O005CF50A171C360678FF1D03073O007319947863744703063O001C31B83D441E03053O00216C5DD944030E3O00FE47A4A0DE45B5ACD769ADACC85F03043O00CDBB2BC103103O0045617274687175616B65506C61796572025O00A09540025O0005B140031B3O00FB7317CBF66310DEF57745CCF77C02D3FB4D11DEEC7500CBBE245103043O00BF9E1265025O0096B140025O005EAC40025O00B88040025O00C6AB40030A3O00E0C295A3A7D4D686BCAA03053O00CFA5A3E7D703063O00C5ECEB452B6203063O0010A62O99364403163O00F7B0C8493132F6D494D2432O35CAC7BDC4432628F7D503073O0099B2D3A0265441030E3O00A7075F2687054E2A8E29562A911F03043O004BE26B3A025O00405F40025O0052AE40025O0033B240025O00F89040031B3O005DDF036E19D3D859D5143A02CBC35FD2144505C3DF5FDB053A479403073O00AD38BE711A71A2030A3O00EEDF3F11FFDACB2C0EF203053O0097ABBE4D6503063O00D523F9B0FD6F03073O006BA54F98C9981D03163O00724DE0C4516C5848CFD9517E437DFDC5507A4547E6CC03063O001F372E88AB34030E3O00F424D9F9D426C8F5DD0AD0F5C23C03043O0094B148BC025O00C06040025O00E2A240025O007CAA40025O00EC9C40025O00F09C40025O00F09140031B3O00A3B745C7AEA742D2ADB317C0AFB850DFA38943D2B4B152C7E6E00103043O00B3C6D637025O00E8A340025O00CCA440025O0014AD40025O001AA440025O00289240025O00349240030E3O00D500777B40DDE40D7E5449D2E31803063O00B3906C12162503133O00EBA2089DCAD4AC1D9DC7C386178CC2C3AD0F9A03053O00AFA6C37BE903083O00446562752O665570030E3O00456C656D656E74616C426C617374025O0079B140025O00EAA94003203O00EACE5844F5E1D65C45CFEDCE5C5AE4AFD15447F7E3C7625DF1FDC5585DB0B99A03053O00908FA23D29025O00209140025O00D89B40030A3O00C6C1124366B43BEFD01603073O005380B37D3012E7025O00805B4003093O0071B6E5DC650B4FA4E703063O007E3DD793BD2703113O00436861726765734672616374696F6E616C03113O005DF318466CED144371FA197670F01E4E6B03043O0025189F7D030E3O00FFAA704FDFA86143D6847943C9B203043O0022BAC615030C3O00D401C255D6F601CB5AF0F70C03053O00A29868A53D025O000CA240025O00309840025O0072A240025O00B89840031C3O00CB3DBD6E64DADE27BD7E7BA5DE26BC7A7CE0F23BB36F77E0D96FE52D03063O0085AD4FD21D10030E3O00A870E8268872F92A815EE12A9E6803043O004BED1C8D030C3O00F056CBB93B15EEEFDB6DC3B503083O0081BC3FACD14F7B87025O002C9D40025O00A8944003203O0045E8E3C045EAF2CC4CDBE4C141F7F28D53EDE8CA4CE12OD941F6E1C854A4B19F03043O00AD208486030A3O006B2O1AFBA602C541182O03073O00AD2E7B688FCE51025O006CB140025O00C88840030A3O00456172746853686F636B025O004CA740025O0085B040025O00F49F40025O00F88B40031C3O00B11C309E4DBC12BC122181059008BA1A2E8F7A9700A61A279E05D45503073O0061D47D42EA25E3025O006AA040030A3O00ACF1B9260AB9EBB9361503053O007EEA83D65503113O00A1D94C595B96DC4F534A80E641554C8FC603053O002FE4B5293A030C3O008AF5DE33173E16A8FBEB340703073O007FC69CB95B6350025O00D6AA40031C3O00F308C3E3B3342AD6FA19C7B0B40237D9F91FF3E4A6193EDBE15A9BA603083O00BE957AAC90C76B5903093O001E04E7FFDC2717E2EA03053O009E5265919E030F3O00466C75784D656C74696E6742752O66031B3O007CFF14177B72EB10055030ED0B18437CFB3D024562F907020427A603053O0024109E6276026O001C40025O00C08140025O00EEB140025O0019B140025O00709440025O007C9A40025O00A0A140025O0036AB40025O00E49240025O007FB040025O005C9A40025O00F2A04003083O0061103AEE6F142DE203043O008F2D714C030C3O008BAD0E3BBDB71A0CB7AF192E03043O005C2OD87C025O00BAA240025O00D89E40031A3O005733BA41C25937AD4DBD483BA247F15E0DB841EF5C37B800AF2O03053O009D3B52CC20025O00B8AC40025O00C8A140030E3O001B36E2F3E7C6DAB6302AEDF3E7ED03083O00D1585E839A898AB3030C3O001BB4D67B1B2C371227B6C16E03083O004248C1A41C7E4351025O00B89240025O0077B240030E3O00436861696E4C696768746E696E6703203O00E424A9512849EB25AF503278EE22AF18357FE92BA45D1962E63EAF5D3236B47C03063O0016874CC83846025O009EA640025O003EA540025O0020AA40025O0066B240025O0092A640025O00405740030A3O005DC9DB585937D372D9DD03073O00B21CBAB83D3753030A3O00417363656E64616E6365031B3O00C5DE4439FC0AF4CACE427CE107FBC3C14203E60FE7C3C8537CA05A03073O0095A4AD275C926E030D3O00DF2E2O170E15FA29173D1517E703063O007B9347707F7A025O00C1B240025O00EAB040031F3O00C0C4857952C2C48C7679CEC28E6506DFC48C764AC9F2967054CBC89631149A03053O0026ACADE211025O00807A40025O00788140025O0099B24003093O00A131EE257FF49F23EC03063O0081ED5098443D030C3O0062BD16F419185E61A713F60E03073O003831C864937C7703133O00E13FACE4C92CB0F6D836BAD5C03BB2F5C22AAC03043O0090AC5EDF025O00907D40025O00FDB040025O0004A540025O00EAA240031B3O00280EB4461B0DB755371BE2542D01A54B2130B6463608A753645CF003043O0027446FC2030D3O00FAAFE0CF6DB9DFA8E0E576BBC203063O00D7B6C687A719030C3O00BE5CF84F8846EC78825EEF5A03043O0028ED298A025O009C9840025O0071B240031F3O00CB7DFDF05EC97DF4FF75C57BF6EC0AD47DF4FF46C24BEEF958C071EEB8199303053O002AA7149A98025O0022AC40025O000EA740025O004AA640026O002440025O00E09940025O0040A040025O0014B040030A3O00D1EF25CF19CBC5F8FE2103073O00AD979D4ABC6D98031D3O00221A37CEC86BC6FB2B0B339DCF5DDBF4280D07C9DD46D2F63048698C8A03083O0093446858BDBC34B5025O00688940025O00606A40025O0064B340025O00CEA740025O00508F40026O002040025O00F8A040025O00549240025O00B49740025O00B2AF40025O008C9B40025O00708040025O00ACAB40025O006FB240030E3O007DEDFC71EECA57E2F56CEEEF50E203063O00863E859D188003133O0032AB08DC23B4D813AC14DE0CB0DA06A813CD3603073O00B667C57AB94FD1025O0080B140025O00B07240025O0010A240025O0063B240025O00B0AB4003203O00F08FE07E0E77FF8EE67F1446FA89E6371341FD80ED723F5CF295E6721408ABDF03063O002893E7811760025O00807F40025O006AB140030D3O0059F18B4DAFA2D57BFFAE4AB7B803073O00BC1598EC25DBCC03133O0075E725094CEC391849E7302F41E5360149FD2E03043O006C208957031F3O00A6E107AE3BF74257ADD702A923ED0B4AA3E607AA2AC65F58B8EF05B26FA01B03083O0039CA8860C64F992B030A3O00E604CCE84CDB2FEAC31D03083O0085A076A39B388847030B3O00D0AE64EA9B1AB9E2AB7FF503073O00D596C21192D67F025O008EA040025O00FAAE40025O00D88D40031C3O001DBBABC7529BB13E14AAAF9455ADAC3117AC9BC047B6A5330FE9FC8403083O00567BC9C4B426C4C2030A3O00D1FAD6BCE3DBD1A0F4E303043O00CF9788B903113O008D8F2D81606A78AE8A2D8647707EAB883B03073O0011C8E348E21418025O0072B340025O0050A440031C3O00B65314C4DDCEFCF7BF421097DAF8E1F8BC4424C3C8E3E8FAA401438503083O009FD0217BB7A9918F025O00809C40025O00709940025O00D08D40025O00107D40025O0060AB40025O00B6B04003093O00DE5B2E37D04F2A25E603043O0056923A5803113O007DDCE2CFA1EF22F25DFAE6C5A3EC38EE4B03083O009A38BF8AA0CE895603093O00AA58E3864F2F93CB8303083O00ACE63995E71C5AE1030F3O0032B88FDF27C906A387DE1BCE10AD8303063O00BB62CAE6B248030E3O0004EDA13D4F2FF5A53C682DE0B72403053O002A4181C45003133O002F4B4ECE12150DE8164258FF1B020FEB0C5E4E03083O008E622A3DBA776762031B3O0034BE140907BD171A2BAB421B31B105043D8016092AB8071C78E75603043O006858DF62025O0010B240030E3O0061FBE7C307E350F6EEEC0EEC57E303063O008D249782AE62025O00849240025O00207F40025O0018B04003203O008176C7008174D60C8845C0018569D64D9773CC0A887FFD198568C508903A9A5B03043O006DE41AA2026O002240025O005BB340025O00BC9340030A3O00390B8820F6CAC7F01C0C03083O009F7F67E94D9399AF030D3O00557365466C616D6553686F636B03083O0049734D6F76696E67025O00E0AA40030A3O00466C616D6553686F636B031D3O0001FCE5A745F414F8EBA94B8B14F9EAAD4CCE38E4E5B847CE13B0B5FB1203063O00AB679084CA20030A3O003623E801151CE103132403043O006C704F89026O007D40025O00C2A840025O008BB040025O0058B240025O0004A140025O0084B040031D3O0039CE7525A83EFA3D30C17F68BE08E73233C74B3CAC13EE302B822579F903083O00555FA21448CD6189025O00DEA340026O004240025O003BB240025O002BB140030E3O00E2411C114490C84E150C44B5CF4E03063O00DCA1297D782A025O00A8914003213O00BF79A107B24EAC07BB79B400B57FA74EAF78AE09B0749F1ABD63A70BA831F15EE403043O006EDC11C0025O006C9B40025O00308F40030D3O0058703312FF39F8A9735B3B16FF03083O00C71419547A8B5791025O00109B40025O00AEAC4003203O004B00DAA60FE44E07DA9119E54B1D9DBD12E44005D8910FEB550ED8BA5BBB165903063O008A2769BDCE7B025O0020A040025O001FB240025O00089640025O0056AD40025O00507C40025O001AA640025O003EAD40030D3O00E520FE4ADD27F04CCE0BF64EDD03043O0022A94999030D3O004C617661537572676542752O6603093O0086ED1D8A88F91998BE03043O00EBCA8C6B03113O0029773CA7E621E3CD095138ADE422F9D11F03083O00A56C1454C8894797025O00B08340025O00C4A74003203O0076BD2C806EBA22867D8B298776A06B9B73BA2C847F8B3F8968B32E9C3AE57BDC03043O00E81AD44B025O00FEB240030A3O00115B7DFBE304417DEBFC03053O00975729128803113O007EA3CFD3EA49A6CCD9FB5F9CC2DFFD50BC03053O009E3BCFAAB0030B3O0069522651A14A522740824803053O00EC2F3E5329025O00F6AF40025O00188440025O0024A340025O0096B240031D3O00FCBB2F28BEBDE9A12F38A1C2E9A02E3CA687C5BD2129AD87EEE9716BFC03063O00E29AC9405BCA025O002CA140025O006CA340025O0023B340025O00E9B140025O00A09D40025O0052A740025O0036A040030A3O007BFE4B9949DF4C855EE703043O00EA3D8C2403093O000DDCAC733C34CFBD7703053O006F41BDDA1203113O006648133A045ABB4B4E3E390E51AA4D5F0803073O00CF232B7B556B3C030F3O0040B8A9E77662AEA9EB7543BFB2ED7C03053O001910CAC08A030E3O00D8C7A8EFACFAE9CAA1C0A5F5EEDF03063O00949DABCD82C9025O00804E4003093O000FD56228F3E331C76003063O009643B41449B1025O00804840025O00804F4003093O00A1190C4CAF0D085E9903043O002DED787A025O00F89340025O00288440025O001DB140025O00ACAE40031C3O00D1FAAD3FC3D7B124D8EBA96CC4E1AC2BDBED9D38D6FAA529C3A8F67403043O004CB788C2030A3O005CF4EA2B447C1C75E5EE03073O00741A868558302F03093O0032C0B6E58E670CC6A503063O00127EA1C084DD03113O007A2BA60B2O593CA60173532DA301584B3B03053O00363F48CE64030E3O00ED554077E075DC584958E97ADB4D03063O001BA839251A8503093O0001AB6AA9F538B86FBC03053O00B74DCA1CC8026O003840026O00434003093O003B329F0935269B1B2O03043O00687753E9025O00909C40025O003EA140025O00EEAF40025O00A8B240031C3O00F3EA283157CAEB2F2D40FEB8342B4DF2F4221D57F4EA202757B5AD7703053O00239598474203093O0035E954B1180CFA51A403053O005A798822D0031E3O0057696E64737065616B6572734C617661526573757267656E636542752O6603113O00E20D5D11C8084116C22B591BCA0B5B0AD403043O007EA76E3503093O002O1138F9EF2A2F172B03063O005F5D704E98BC030F3O00F1E78C18EBACD6C8F48926F1ACD5C403073O00B2A195E57584DE03133O00A5DACEB8A404A9259CD3D889AD13AB2686CFCE03083O0043E8BBBDCCC176C6030E3O00AE22B02D3E0CFB8A22972C3A11FB03073O008FEB4ED5405B62025O00F6A840025O00804B40025O00CAB240025O00788240031B3O00814992E84FB4985A97FD30A5844683E57589994996EE75A2CD1DD603063O00D6ED28E48910025O0081B140025O0018904003093O00A9E2F9D821B397F0FB03063O00C6E5838FB96303113O00748FA07C5E8ABC7B54A9A4765C89A6674203043O001331ECC803093O00D236E0B6D7AFEC30F303063O00DA9E5796D784030F3O00CB0CD0EF3930C9F21FD5D12330CAFE03073O00AD9B7EB982564203133O00C8A7A9D38DFEEAA0AECF8DC9E9A3B7C286F8F603063O008C85C6DAA7E8030E3O009022B17081BB3AB571A6B92FA76903053O00E4D54ED41D026O009740025O0006A740031B3O008B4DA004D48559A416FFC75FBF0BEC8B498911EA954BB311ABD21803053O008BE72CD665025O002AA94003093O00F5EE105F32A42305CD03083O0076B98F663E70D151030E3O00797C2CEBA01B0839505225E7B60103083O00583C104986C5757C025O00C4AB40025O00107E40025O00389A40025O0034A340025O008CA240025O00E8A640031B3O005CEBEEC97E52FFEADB5510F9F1C6465CEFC7DC4042EDFDDC0105BC03053O0021308A98A803093O005E172650E32260052403063O005712765031A1030E3O006912DFADB5420ADBAC92401FC9B403053O00D02C7EBAC003113O00DA15B1C800FDC040E42DADCA18DAC842FB03083O002E977AC4A6749CA9030C3O00C9E44112EFEBE4481DC9EAE903053O009B858D267A025O00D89240025O000C9040025O00249940031B3O00292BBA40707DB03739B8015C76AB2226A97E5B7EB7222FB8011A2703073O00C5454ACC212F1F025O00B5B040025O00DBB140030A3O000CA9CD976319B3CD877C03053O00174ADBA2E4030B3O001FEA53B7163CEA52A6353E03053O005B598626CF03113O0061E2CD3507C22E42E7CD3220D82847E5DB03073O0047248EA85673B0030C3O00F3A875B717B05F47D8937DBB03083O0029BFC112DF63DE36025O0082AA40025O00D4B040025O00D89840025O001C9E40031D3O00AD34C839BE9435CF25A9A066D423A4AC2AC215BEAA34C02FBEEB77977A03053O00CACB46A74A025O007C9140025O00E88240030E3O000F09DD3A7F0008DB3B652208D23403053O00114C61BC5303093O00A926CF36129659B09103083O00C3E547B95750E32B03113O00C5FF085FE0E6E80855CAECF90D55E1F4EF03053O008F809C6030025O0072AB4003213O00BBD9F11B1987DDF9151FACDFF91C10F8C2F91C10B4D4CF0616AAD6F50657E981A203053O0077D8B19072025O000EA640025O0062B040030D3O00CF3F0BE3DABD32ED312EE4C2A703073O005B83566C8BAED303083O00497341637469766503043O004E616D6503173O00DC39BD1649FE39F82449F439B55778F72EB51253EF2AB403053O003D9B4BD87703123O004C696768746E696E67526F64446562752O66025O00309640025O00888340031F3O0008A2B5344C07D40AAC8D3E5705C944B8BB325F05D83BBFB32E5F0CC944F2E403073O00BD64CBD25C3869030A3O000943F22O3B62F5272C5A03043O00484F319D03113O00ADBC34BF9CA238BA81B5358F80BF32B79B03043O00DCE8D051030B3O00D3B2F028015FADE1B7EB3703073O00C195DE85504C3A03093O00EA5C59D3E4485DC1D203043O00B2A63D2F03113O00DE49E075C538EF42ED5FC63BF64FE66ED903063O005E9B2A881AAA025O008EA940025O0023B040031C3O00822D29A6900035BD8B3C2DF5973628B2883A19A1852D21B0902O7FED03043O00D5E45F46025O0026AA40025O0014AC40025O00808940025O00C8B040025O0076A240025O00206240025O00A49B40025O00FCAE40025O00208440025O00F49840025O008EB240025O005AAB40025O00E08440025O00C49640025O00BEA04003073O008220AFA198B5E103073O0098CB43CAC7EDC703073O00D340A5090A676003083O00869A23C06F7F1519025O006AA840025O00A2AF40025O004C964003183O00B1252O0C35C0A1661A032ED5B423361E21C0BF231D4A798003063O00B2D846696A40025O00F4A340025O0004AD40030E3O001C237BFFC7F9DD87373F74FFC7D203083O00E05F4B1A96A9B5B403173O002CC8DD2950A9644BE9CC2756A1362ED6DD2541A2620AD603073O00166BBAB84824CC025O00C09640025O00608C4003203O00E4B5254700D8B12D4906F3B32D4009A7AE2D4009EBB81B5A0FF5BA215A4EBEE903053O006E87DD442E025O00689140025O00C6A640025O0046A840025O00907340025O00C09940025O00E6A940030B3O00CC2706183FF3FA36190F2003063O00989F53696A52030B3O00B2D25EE0C45784C341F7DB03063O003CE1A63192A9030F3O0053746F726D6B2O6570657242752O6603093O00031F392B32123D192A03063O00674F7E4F4A6103113O009F7CDB7C511CAE77D656521FB77ADD674D03063O007ADA1FB3133E030F3O00832OC4CCC6B341BAD7C1F2DCB342B603073O0025D3B6ADA1A9C1030B3O0053746F726D6B2O65706572025O0060B340031C3O00E42E42CB2570BCF22A48CB2O68B0F93D41DC176FB8E53D48CD6829E903073O00D9975A2DB9481B025O0006B040030B3O00F068E8005BC879E20253D103053O0036A31C8772030B3O001BCF529043742DDE4D875C03063O001F48BB3DE22E030C3O00F01351D5427122F30954D75503073O0044A36623B2271E030E3O009B7CDFCA06BB9710B252D6C610A103083O0071DE10BAA763D5E303093O00020FEDF71D1BE9F12B03043O00964E6E9B03113O00A0C62FEEAB18AB4880E02BE4A91BB1549603083O0020E5A54781C47EDF030F3O00F39BCD8C8E2OC780C58DB2C0D18EC103063O00B5A3E9A42OE1025O00449040025O00B09240031C3O00439F31655D803B72408E2C37438230705C8E01635199397244CB6C2503043O001730EB5E025O00B88E40025O00DAAB40025O00A4AF40030A3O00C0082034493472E9072A03073O001A866441592C6703113O00446562752O665265667265736861626C65030E3O00D4EF352EA1FFF7312F86FDE2233703053O00C491835043030D3O003BA903071EFC16B5351C17FA1303063O00887ED0666878030A3O0054616C656E7452616E6B025O00805640030D3O005D93CB4CA94635544B9EC151A203083O003118EAAE23CF325D026O004E40025O00B0AA40025O00606740025O001AA240025O00BC9940031C3O000AFEFC857433E1F5877207B2EE817F0BFEF8B7650DE0FA8D654CA3AF03053O00116C929DE8025O00A89E40025O002O9040025O00188140030A3O006DCF15E02A9B43CC17E603063O00C82BA3748D4F03103O00993A3C8EB5C7EBB03536A7B52OF6B93003073O0083DF565DE3D09403143O00C740B3A611ACD14AB9A218B1C649B3BB18BBF75603063O00D583252OD67D030A3O00073826BAEF222A2BBCE403053O0081464B45DF030E3O0076D9FAE473FD42C2F2E54BEE50CE03063O008F26AB93891C030D3O00E387B8E10AEDD3F68EB8FE06F003073O00B4B0E2D9936383030C3O00FEB8280AD29A2706DEBB2A1503043O0067B3D94F030B3O0079A313C74C87A64FA719C703073O00C32AD77CB521EC030C3O003E4C253920F70B69382920EA03063O00986D39575E452O033O00F4DE0403083O00C899B76AC3DEB234031C3O0034EF89304C6521EB873E421A21EA863A455F0DF7892F4E5F26A3D96903063O003A5283E85D29025O00209E40025O006DB340025O0061B340025O00FCAB40025O00E08C40025O0061B240025O00B88F40030A3O00A55BD118580C8B58D31E03063O005FE337B0753D03143O003C7B265BA7014C2C44BF1D7A0647AE157B2D5FB803053O00CB781E432B030A3O00D0364EEAD7F52443ECDC03053O00B991452D8F030E3O00BA0D10ABD3981B10A7D0BD1E0FA303053O00BCEA7F79C6030D3O000B371291313C14A534331E862B03043O00E3585273030C3O006E1EBDAA03504B1EB7A5076103063O0013237FDAC762030B3O002FEF05F011F00FE70CFE1803043O00827C9B6A030C3O00E6DEE4A8A6F97A8FDADCF3BD03083O00DFB5AB96CFC3961C025O005491402O033O004133ED03053O00692C5A83CE031C3O00F9ECB3B40D01ECE8BDBA037EECE9BCBE043BC0F4B3AB0F3BEBA0E3EF03063O005E9F80D2D968025O008EB140025O00BEA940030B3O0063ED09AD5274FC7F40FC1403083O001A309966DF3F1F99030B3O003154E2E10F4BE8F61245FF03043O009362208D026O005D40030E3O003D4FE6C703585F194FC1C607455F03073O002B782383AA6636030C3O00671395B1A0BF82640990B3B703073O00E43466E7D6C5D003113O002DF770C6E68217D133E170C6F99F0BD91303083O00B67E8015AA8AEB7903093O00A7DB23E7B50622018E03083O0066EBBA5586E6735003113O00720F36507DD2365F091B5377D92759182D03073O0042376C5E3F12B4030F3O00249F8C3A284B102O843B144C068A8003063O003974EDE55747025O0088AA40025O00A88040025O0066A440025O00A08740031C3O00B9A5E2F57AE542AFA1E8F537FD4EA4B6E1E248FA46B8B6E8F337BF1F03073O0027CAD18D87178E025O005CAB40025O00E0914000D6132O001255012O00014O00C9000100023O002E50010300CA130100020004B03O00CA13010026D53O00CA130100040004B03O00CA13010026D500010006000100010004B03O00060001001255010200013O002E59000600BD2O0100050004B03O00BD2O010026C00002000F000100070004B03O000F0001002E00010800B02O0100090004B03O00BD2O01001255010300013O0026D5000300A6000100040004B03O00A600012O00CD00046O006E000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005A00013O0004B03O005A00012O00CD00046O000B010500013O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000F4O00040002000200262O0004005A000100010004B03O005A00012O00CD000400023O00066B0104005A00013O0004B03O005A00012O00CD00046O006E000500013O00122O000600103O00122O000700116O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005A00013O0004B03O005A00012O00CD00046O006E000500013O00122O000600123O00122O000700136O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005A00013O0004B03O005A00012O00CD00046O006E000500013O00122O000600143O00122O000700156O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005A00013O0004B03O005A0001002E0001160013000100160004B03O005A00012O00CD000400034O000901055O00202O0005000500174O000600043O00202O0006000600184O00085O00202O0008000800174O0006000800024O000600066O00040006000200062O0004005A00013O0004B03O005A00012O00CD000400013O001255010500193O0012550106001A4O008B000400064O00FB00046O00CD00046O006E000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004009000013O0004B03O009000012O00CD000400053O00066B0104009000013O0004B03O009000012O00CD000400064O005C01040001000200066B0104009000013O0004B03O009000012O00CD00046O006E000500013O00122O0006001E3O00122O0007001F6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004009000013O0004B03O009000012O00CD000400043O00201A0104000400204O00065O00202O0006000600214O00040006000200262O00040086000100220004B03O008600012O00CD000400073O0020780004000400234O00065O00202O0006000600244O0004000600024O000500073O00202O0005000500254O00050002000200062O00040090000100050004B03O009000012O00CD00046O0093000500013O00122O000600263O00122O000700276O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040092000100010004B03O00920001002E50012900A5000100280004B03O00A500012O00CD000400034O00BD00055O00202O00050005002A4O000600043O00202O0006000600184O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400A0000100010004B03O00A00001002E00012B00070001002C0004B03O00A500012O00CD000400013O0012550105002D3O0012550106002E4O008B000400064O00FB00045O001255010300223O0026C0000300AC000100220004B03O00AC0001002E61012F00AC000100300004B03O00AC0001002E000131009A000100320004B03O00442O01001255010400013O0026C0000400B1000100010004B03O00B10001002E500133003F2O0100340004B03O003F2O012O00CD00056O006E000600013O00122O000700353O00122O000800366O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500FC00013O0004B03O00FC00012O00CD000500053O00066B010500FC00013O0004B03O00FC00012O00CD000500064O005C01050001000200066B010500FC00013O0004B03O00FC00012O00CD00056O006E000600013O00122O000700373O00122O000800386O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500FC00013O0004B03O00FC00012O00CD000500084O005C010500010002000E53003900FC000100050004B03O00FC00012O00CD000500043O00204F0105000500204O00075O00202O0007000700214O0005000700024O000600073O00202O0006000600254O00060002000200102O00060022000600062O000500FC000100060004B03O00FC00012O00CD000500094O005C01050001000200066B010500FC00013O0004B03O00FC00012O00CD00056O006E000600013O00122O0007003A3O00122O0008003B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500FC00013O0004B03O00FC00012O00CD000500034O00BD00065O00202O00060006002A4O000700043O00202O0007000700184O00095O00202O00090009002A4O0007000900024O000700076O00050007000200062O000500F7000100010004B03O00F70001002E50013C00FC0001003D0004B03O00FC00012O00CD000500013O0012550106003E3O0012550107003F4O008B000500074O00FB00055O002E500140002B2O0100410004B03O002B2O012O00CD00056O006E000600013O00122O000700423O00122O000800436O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005002B2O013O0004B03O002B2O012O00CD0005000A3O00066B0105002B2O013O0004B03O002B2O012O00CD0005000B3O000E1A0004002B2O0100050004B03O002B2O012O00CD0005000C3O000E1A0004002B2O0100050004B03O002B2O012O00CD0005000D4O005C01050001000200066B0105002B2O013O0004B03O002B2O012O00CD000500073O0020ED0005000500234O00075O00202O0007000700444O0005000700024O00068O000700013O00122O000800453O00122O000900466O0007000900024O00060006000700202O0006000600474O00060002000200062O0006002B2O0100050004B03O002B2O012O00CD000500073O00201000050005004800122O000700493O00122O0008004A6O00050008000200062O0005002D2O013O0004B03O002D2O01002E59004C003E2O01004B0004B03O003E2O012O00CD000500034O000901065O00202O00060006004D4O000700043O00202O0007000700184O00095O00202O00090009004D4O0007000900024O000700076O00050007000200062O0005003E2O013O0004B03O003E2O012O00CD000500013O0012550106004E3O0012550107004F4O008B000500074O00FB00055O001255010400043O0026D5000400AD000100040004B03O00AD0001001255010300073O0004B03O00442O010004B03O00AD0001002E50015100B62O0100500004B03O00B62O010026D5000300B62O0100010004B03O00B62O012O00CD00046O006E000500013O00122O000600523O00122O000700536O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004006D2O013O0004B03O006D2O012O00CD0004000E3O00066B0104006D2O013O0004B03O006D2O012O00CD000400094O005C01040001000200066B0104006D2O013O0004B03O006D2O012O00CD00046O0093000500013O00122O000600543O00122O000700556O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004006D2O0100010004B03O006D2O012O00CD00046O006E000500013O00122O000600563O00122O000700576O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004006F2O013O0004B03O006F2O01002E50015800822O0100590004B03O00822O01002E00015A00130001005A0004B03O00822O012O00CD000400034O000901055O00202O00050005005B4O000600043O00202O0006000600184O00085O00202O00080008005B4O0006000800024O000600066O00040006000200062O000400822O013O0004B03O00822O012O00CD000400013O0012550105005C3O0012550106005D4O008B000400064O00FB00045O002E50015E00B52O01005F0004B03O00B52O012O00CD00046O006E000500013O00122O000600603O00122O000700616O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B52O013O0004B03O00B52O012O00CD0004000E3O00066B010400B52O013O0004B03O00B52O012O00CD000400073O0020B40004000400624O00065O00202O0006000600634O00040006000200062O000400B52O013O0004B03O00B52O012O00CD00046O006E000500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B52O013O0004B03O00B52O012O00CD000400034O00BD00055O00202O00050005005B4O000600043O00202O0006000600184O00085O00202O00080008005B4O0006000800024O000600066O00040006000200062O000400B02O0100010004B03O00B02O01002E59006700B52O0100660004B03O00B52O012O00CD000400013O001255010500683O001255010600694O008B000400064O00FB00045O001255010300043O002E50016A00100001006B0004B03O001000010026D500030010000100070004B03O001000010012550102004A3O0004B03O00BD2O010004B03O001000010026D50002008B030100010004B03O008B0301001255010300014O00C9000400043O002E00016C3O0001006C0004B03O00C12O010026D5000300C12O0100010004B03O00C12O01001255010400013O0026C0000400CC2O0100070004B03O00CC2O01002E25016D00CC2O01006E0004B03O00CC2O01002E59006F00CE2O0100700004B03O00CE2O01001255010200043O0004B03O008B0301002E5900710077020100720004B03O00770201002E5900740077020100730004B03O007702010026D500040077020100040004B03O007702012O00CD00056O006E000600013O00122O000700753O00122O000800766O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005000502013O0004B03O000502012O00CD0005000F3O00066B0105000502013O0004B03O000502012O00CD00056O004C010600013O00122O000700773O00122O000800786O0006000800024O00050005000600202O00050005000F4O000500020002000E2O00790005020100050004B03O000502012O00CD00056O006E000600013O00122O0007007A3O00122O0008007B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500FF2O013O0004B03O00FF2O012O00CD00056O0093000600013O00122O0007007C3O00122O0008007D6O0006000800024O00050005000600202O00050005000C4O00050002000200062O00050009020100010004B03O000902012O00CD0005000B3O000E1A00040005020100050004B03O000502012O00CD0005000C3O000EA900040009020100050004B03O00090201002E61017E00090201007F0004B03O00090201002E5001800014020100810004B03O001402012O00CD000500034O00CD00065O0020920006000600822O002101050002000200066B0105001402013O0004B03O001402012O00CD000500013O001255010600833O001255010700844O008B000500074O00FB00056O00CD00056O006E000600013O00122O000700853O00122O000800866O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005006002013O0004B03O006002012O00CD000500103O00066B0105006002013O0004B03O006002012O00CD000500113O00066B0105002702013O0004B03O002702012O00CD000500123O0006CC0005002A020100010004B03O002A02012O00CD000500113O0006CC00050060020100010004B03O006002012O00CD000500134O00CD000600143O00061C00050060020100060004B03O006002012O00CD000500154O0027010600013O00122O000700873O00122O000800886O00060008000200062O00050060020100060004B03O006002012O00CD00056O006E000600013O00122O000700893O00122O0008008A6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005004902013O0004B03O004902012O00CD00056O0093000600013O00122O0007008B3O00122O0008008C6O0006000800024O00050005000600202O00050005000C4O00050002000200062O00050062020100010004B03O006202012O00CD00056O001D010600013O00122O0007008D3O00122O0008008E6O0006000800024O00050005000600202O00050005008F4O00050002000200262O00050062020100010004B03O006202012O00CD000500043O00201A0105000500204O00075O00202O0007000700904O00050007000200262O00050062020100910004B03O006202012O00CD0005000B3O000E1A00040060020100050004B03O006002012O00CD0005000C3O000EA900040062020100050004B03O00620201002E0001920016000100930004B03O00760201002E5001950076020100940004B03O007602012O00CD000500034O0002010600163O00202O0006000600964O000700043O00202O00070007009700122O000900986O0007000900024O000700076O00050007000200062O00050071020100010004B03O00710201002E00019900070001009A0004B03O007602012O00CD000500013O0012550106009B3O0012550107009C4O008B000500074O00FB00055O001255010400223O000E472O0100D6020100040004B03O00D60201001255010500013O000E370104007E020100050004B03O007E0201002E50019E00800201009D0004B03O00800201001255010400043O0004B03O00D60201000E372O010084020100050004B03O00840201002E59009F007A020100A00004B03O007A02012O00CD00066O006E000700013O00122O000800A13O00122O000900A26O0007000900024O00060006000700202O00060006001D4O00060002000200062O0006009E02013O0004B03O009E02012O00CD000600173O00066B0106009E02013O0004B03O009E02012O00CD000600183O00066B0106009702013O0004B03O009702012O00CD000600123O0006CC0006009A020100010004B03O009A02012O00CD000600183O0006CC0006009E020100010004B03O009E02012O00CD000600134O00CD000700143O00067F000600A0020100070004B03O00A00201002E5001A300AD020100A40004B03O00AD02012O00CD000600034O00CD00075O0020920007000700A52O00210106000200020006CC000600A8020100010004B03O00A80201002E5900A600AD020100A70004B03O00AD02012O00CD000600013O001255010700A83O001255010800A94O008B000600084O00FB00066O00CD00066O006E000700013O00122O000800AA3O00122O000900AB6O0007000900024O00060006000700202O00060006001D4O00060002000200062O000600D402013O0004B03O00D402012O00CD000600193O00066B010600D402013O0004B03O00D402012O00CD0006001A3O00066B010600C002013O0004B03O00C002012O00CD000600123O0006CC000600C3020100010004B03O00C302012O00CD0006001A3O0006CC000600D4020100010004B03O00D402012O00CD000600134O00CD000700143O00061C000600D4020100070004B03O00D40201002E5001AD00D4020100AC0004B03O00D402012O00CD000600034O00CD00075O0020920007000700AE2O002101060002000200066B010600D402013O0004B03O00D402012O00CD000600013O001255010700AF3O001255010800B04O008B000600084O00FB00065O001255010500043O0004B03O007A0201000E47012200C62O0100040004B03O00C62O012O00CD00056O006E000600013O00122O000700B13O00122O000800B26O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005002403013O0004B03O002403012O00CD000500103O00066B0105002403013O0004B03O002403012O00CD000500113O00066B010500EB02013O0004B03O00EB02012O00CD000500123O0006CC000500EE020100010004B03O00EE02012O00CD000500113O0006CC00050024030100010004B03O002403012O00CD000500134O00CD000600143O00061C00050024030100060004B03O002403012O00CD000500154O0027010600013O00122O000700B33O00122O000800B46O00060008000200062O00050024030100060004B03O002403012O00CD00056O006E000600013O00122O000700B53O00122O000800B66O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005000D03013O0004B03O000D03012O00CD00056O0093000600013O00122O000700B73O00122O000800B86O0006000800024O00050005000600202O00050005000C4O00050002000200062O00050026030100010004B03O002603012O00CD00056O001D010600013O00122O000700B93O00122O000800BA6O0006000800024O00050005000600202O00050005008F4O00050002000200262O00050026030100010004B03O002603012O00CD000500043O00201A0105000500204O00075O00202O0007000700904O00050007000200262O00050026030100910004B03O002603012O00CD0005000B3O000E1A00040024030100050004B03O002403012O00CD0005000C3O000EA900040026030100050004B03O00260301002E5001BC0038030100BB0004B03O003803012O00CD000500034O0002010600163O00202O0006000600BD4O000700043O00202O00070007009700122O000900986O0007000900024O000700076O00050007000200062O00050033030100010004B03O00330301002E5900BF0038030100BE0004B03O003803012O00CD000500013O001255010600C03O001255010700C14O008B000500074O00FB00056O00CD00056O006E000600013O00122O000700C23O00122O000800C36O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005005D03013O0004B03O005D03012O00CD0005001B3O00066B0105005D03013O0004B03O005D03012O00CD0005001C3O00066B0105005D03013O0004B03O005D03012O00CD000500134O00CD000600143O00061C0005005D030100060004B03O005D03012O00CD0005001D3O00066B0105005D03013O0004B03O005D03012O00CD000500073O0020B40005000500C44O00075O00202O0007000700C54O00050007000200062O0005005D03013O0004B03O005D03012O00CD000500073O00200D0005000500C44O00075O00202O0007000700C64O00050007000200062O0005005F030100010004B03O005F0301002E0001C7002A000100C80004B03O008703012O00CD0005001E3O0020380105000500C94O00065O00202O0006000600CA4O0007001F6O000800013O00122O000900CB3O00122O000A00CC6O0008000A00024O000900206O000A000A6O000B00043O00202O000B000B00184O000D5O00202O000D000D00CA4O000B000D00024O000B000B6O000C000C3O00122O000D00CD6O000E00013O00122O000F00CE3O00122O001000CF6O000E001000024O000D000D000E4O000E00013O00122O000F00D03O00122O001000D16O000E001000024O000D000D000E00202O000D000D00D24O0005000D000200062O00050082030100010004B03O00820301002E5900D30087030100D40004B03O008703012O00CD000500013O001255010600D53O001255010700D64O008B000500074O00FB00055O001255010400073O0004B03O00C62O010004B03O008B03010004B03O00C12O01002E5001D70063050100D80004B03O006305010026C000020091030100D90004B03O00910301002E5001DA0063050100DB0004B03O00630501001255010300013O0026C000030096030100010004B03O00960301002E5900DC0026040100DD0004B03O002604012O00CD00046O006E000500013O00122O000600DE3O00122O000700DF6O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400BB03013O0004B03O00BB03012O00CD000400213O00066B010400BB03013O0004B03O00BB03012O00CD00046O006E000500013O00122O000600E03O00122O000700E16O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400BB03013O0004B03O00BB03012O00CD0004000D4O005C0104000100020006CC000400BB030100010004B03O00BB03012O00CD00046O006E000500013O00122O000600E23O00122O000700E36O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400BD03013O0004B03O00BD0301002E5001E500D5030100E40004B03O00D50301002E5900E700D5030100E60004B03O00D503012O00CD0004001E3O0020050104000400E84O00055O00202O0005000500E94O0006001F6O000700226O000800043O00202O0008000800184O000A5O00202O000A000A00E94O0008000A00022O0012010800084O00620004000800020006CC000400D0030100010004B03O00D00301002E5001EA00D5030100EB0004B03O00D503012O00CD000400013O001255010500EC3O001255010600ED4O008B000400064O00FB00046O00CD00046O006E000500013O00122O000600EE3O00122O000700EF6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004001004013O0004B03O001004012O00CD000400213O00066B0104001004013O0004B03O001004012O00CD00046O006E000500013O00122O000600F03O00122O000700F16O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004001004013O0004B03O001004012O00CD0004000D4O005C0104000100020006CC00040010040100010004B03O001004012O00CD000400084O005C010400010002000EB200F20002040100040004B03O000204012O00CD000400084O005C010400010002000E5300390010040100040004B03O001004012O00CD00046O0093000500013O00122O000600F33O00122O000700F46O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040010040100010004B03O001004012O00CD00046O006E000500013O00122O000600F53O00122O000700F66O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004001004013O0004B03O001004012O00CD000400084O005C01040001000200263D00040012040100F70004B03O00120401002E5001F90025040100F80004B03O00250401002E5001FA00250401006C0004B03O002504012O00CD000400234O000901055O00202O0005000500E94O000600043O00202O0006000600184O00085O00202O0008000800E94O0006000800024O000600066O00040006000200062O0004002504013O0004B03O002504012O00CD000400013O001255010500FB3O001255010600FC4O008B000400064O00FB00045O001255010300043O0026D5000300BB040100040004B03O00BB04012O00CD00046O006E000500013O00122O000600FD3O00122O000700FE6O0005000700024O00040004000500202O0004000400FF4O00040002000200062O0004005604013O0004B03O005604012O00CD000400243O00066B0104005604013O0004B03O005604012O00CD000400254O0027010500013O00122O00062O00012O00122O0007002O015O00050007000200062O00040056040100050004B03O005604012O00CD000400073O0020C70004000400624O00065O00122O00070002015O0006000600074O00040006000200062O0004005604013O0004B03O005604012O00CD00046O0093000500013O00122O00060003012O00122O00070004015O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040052040100010004B03O005204012O00CD0004000B3O001255010500223O00067F0004005A040100050004B03O005A04012O00CD0004000B3O001255010500043O00067F0005005A040100040004B03O005A040100125501040005012O00125501050006012O0006DE0005006F040100040004B03O006F04012O00CD000400034O00FA000500163O00122O00060007015O0005000500064O000600043O00202O00060006009700122O000800986O0006000800024O000600066O00040006000200062O0004006A040100010004B03O006A040100125501040008012O00125501050009012O0006520104006F040100050004B03O006F04012O00CD000400013O0012550105000A012O0012550106000B013O008B000400064O00FB00045O0012550104000C012O0012550105000D012O0006DE000500BA040100040004B03O00BA04010012550104000E012O0012550105000F012O0006DE000400BA040100050004B03O00BA04012O00CD00046O006E000500013O00122O00060010012O00122O00070011015O0005000700024O00040004000500202O0004000400FF4O00040002000200062O000400BA04013O0004B03O00BA04012O00CD000400243O00066B010400BA04013O0004B03O00BA04012O00CD000400254O0027010500013O00122O00060012012O00122O00070013015O00050007000200062O000400BA040100050004B03O00BA04012O00CD000400073O0020C70004000400624O00065O00122O00070002015O0006000600074O00040006000200062O000400BA04013O0004B03O00BA04012O00CD00046O0093000500013O00122O00060014012O00122O00070015015O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400A1040100010004B03O00A104012O00CD0004000B3O001255010500223O00067F000400A5040100050004B03O00A504012O00CD0004000B3O001255010500043O00061C000500BA040100040004B03O00BA04012O00CD000400034O00FA000500163O00122O00060016015O0005000500064O000600043O00202O00060006009700122O000800986O0006000800024O000600066O00040006000200062O000400B5040100010004B03O00B5040100125501040017012O00125501050018012O00061C000500BA040100040004B03O00BA04012O00CD000400013O00125501050019012O0012550106001A013O008B000400064O00FB00045O001255010300223O001255010400073O0006A8000300C2040100040004B03O00C204010012550104001B012O0012550105001C012O000652010400C4040100050004B03O00C40401001255010200913O0004B03O00630501001255010400223O0006A8000300CB040100040004B03O00CB04010012550104001D012O0012550105001E012O0006DE00050092030100040004B03O009203012O00CD00046O006E000500013O00122O0006001F012O00122O00070020015O0005000700024O00040004000500202O0004000400FF4O00040002000200062O000400FB04013O0004B03O00FB04012O00CD000400243O00066B010400FB04013O0004B03O00FB04012O00CD000400254O0027010500013O00122O00060021012O00122O00070022015O00050007000200062O000400FB040100050004B03O00FB04012O00CD0004000B3O001255010500043O00061C000500FB040100040004B03O00FB04012O00CD0004000C3O001255010500043O00061C000500FB040100040004B03O00FB04012O00CD00046O0093000500013O00122O00060023012O00122O00070024015O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400FB040100010004B03O00FB04012O00CD00046O006E000500013O00122O00060025012O00122O00070026015O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400FF04013O0004B03O00FF040100125501040027012O00125501050028012O0006DE00050014050100040004B03O001405012O00CD000400034O00FA000500163O00122O00060007015O0005000500064O000600043O00202O00060006009700122O000800986O0006000800024O000600066O00040006000200062O0004000F050100010004B03O000F050100125501040029012O0012550105002A012O00065201040014050100050004B03O001405012O00CD000400013O0012550105002B012O0012550106002C013O008B000400064O00FB00046O00CD00046O006E000500013O00122O0006002D012O00122O0007002E015O0005000700024O00040004000500202O0004000400FF4O00040002000200062O0004004405013O0004B03O004405012O00CD000400243O00066B0104004405013O0004B03O004405012O00CD000400254O0027010500013O00122O0006002F012O00122O00070030015O00050007000200062O00040044050100050004B03O004405012O00CD0004000B3O001255010500043O00061C00050044050100040004B03O004405012O00CD0004000C3O001255010500043O00061C00050044050100040004B03O004405012O00CD00046O0093000500013O00122O00060031012O00122O00070032015O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040044050100010004B03O004405012O00CD00046O006E000500013O00122O00060033012O00122O00070034015O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004004805013O0004B03O0048050100125501040035012O00125501050036012O0006DE00050061050100040004B03O006105012O00CD000400034O00FA000500163O00122O00060016015O0005000500064O000600043O00202O00060006009700122O000800986O0006000800024O000600066O00040006000200062O0004005C050100010004B03O005C050100125501040037012O00125501050038012O00067F0004005C050100050004B03O005C050100125501040039012O0012550105003A012O00061C00040061050100050004B03O006105012O00CD000400013O0012550105003B012O0012550106003C013O008B000400064O00FB00045O001255010300073O0004B03O009203010012550103003D012O0012550104003E012O0006DE000300E3060100040004B03O00E306010012550103003F012O00125501040040012O0006DE000400E3060100030004B03O00E30601001255010300913O000652010300E3060100020004B03O00E3060100125501030041012O00125501040042012O0006DE000300AC050100040004B03O00AC05012O00CD00036O006E000400013O00122O00050043012O00122O00060044015O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300AC05013O0004B03O00AC05012O00CD000300263O00066B010300AC05013O0004B03O00AC05012O00CD00036O006E000400013O00122O00050045012O00122O00060046015O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003009505013O0004B03O009505012O00CD0003000D4O005C01030001000200066B010300AC05013O0004B03O00AC05012O00CD000300043O00128700050047015O0003000300054O00055O00202O0005000500214O00030005000200062O000300AC05013O0004B03O00AC05012O00CD000300034O001101045O00122O00050048015O0004000400054O000500043O00202O0005000500184O00075O00122O00080048015O0007000700084O0005000700024O000500056O00030005000200062O000300A7050100010004B03O00A7050100125501030049012O0012550104004A012O0006DE000300AC050100040004B03O00AC05012O00CD000300013O0012550104004B012O0012550105004C013O008B000300054O00FB00035O0012550103004D012O0012550104004E012O0006DE0003000D060100040004B03O000D06012O00CD00036O006E000400013O00122O0005004F012O00122O00060050015O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003000D06013O0004B03O000D06012O00CD000300053O00066B0103000D06013O0004B03O000D06012O00CD000300064O005C01030001000200066B0103000D06013O0004B03O000D06012O00CD0003000D4O005C01030001000200066B0103000D06013O0004B03O000D06012O00CD000300084O005C01030001000200125501040051012O00061C0003000D060100040004B03O000D06012O00CD00036O00DB000400013O00122O00050052012O00122O00060053015O0004000600024O00030003000400122O00050054015O0003000300054O00030002000200122O000400043O00062O0003000D060100040004B03O000D06012O00CD00036O006E000400013O00122O00050055012O00122O00060056015O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003000D06013O0004B03O000D06012O00CD00036O006E000400013O00122O00050057012O00122O00060058015O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003000D06013O0004B03O000D06012O00CD00036O0093000400013O00122O00050059012O00122O0006005A015O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003000D060100010004B03O000D06010012550103005B012O0012550104005C012O0006DE0004000D060100030004B03O000D06010012550103005D012O0012550104005E012O00061C0004000D060100030004B03O000D06012O00CD000300034O000901045O00202O00040004002A4O000500043O00202O0005000500184O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O0003000D06013O0004B03O000D06012O00CD000300013O0012550104005F012O00125501050060013O008B000300054O00FB00036O00CD00036O006E000400013O00122O00050061012O00122O00060062015O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003F06013O0004B03O003F06012O00CD000300263O00066B0103003F06013O0004B03O003F06012O00CD0003000D4O005C0103000100020006CC00030028060100010004B03O002806012O00CD00036O006E000400013O00122O00050063012O00122O00060064015O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003F06013O0004B03O003F06012O00CD000300034O001101045O00122O00050048015O0004000400054O000500043O00202O0005000500184O00075O00122O00080048015O0007000700084O0005000700024O000500056O00030005000200062O0003003A060100010004B03O003A060100125501030065012O00125501040066012O0006520103003F060100040004B03O003F06012O00CD000300013O00125501040067012O00125501050068013O008B000300054O00FB00036O00CD00036O006E000400013O00122O00050069012O00122O0006006A015O0004000600024O00030003000400202O0003000300FF4O00030002000200062O0003004C06013O0004B03O004C06012O00CD000300273O0006CC00030050060100010004B03O005006010012550103006B012O0012550104006C012O00061C0003006B060100040004B03O006B06012O00CD000300034O001101045O00122O0005006D015O0004000400054O000500043O00202O0005000500184O00075O00122O0008006D015O0007000700084O0005000700024O000500056O00030005000200062O00030066060100010004B03O006606010012550103006E012O0012550104006F012O00064900040005000100030004B03O0066060100125501030070012O00125501040071012O0006DE0003006B060100040004B03O006B06012O00CD000300013O00125501040072012O00125501050073013O008B000300054O00FB00035O00125501030074012O00125501040074012O000652010300B5060100040004B03O00B506012O00CD00036O006E000400013O00122O00050075012O00122O00060076015O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300B506013O0004B03O00B506012O00CD000300053O00066B010300B506013O0004B03O00B506012O00CD000300064O005C01030001000200066B010300B506013O0004B03O00B506012O00CD00036O006E000400013O00122O00050077012O00122O00060078015O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300B506013O0004B03O00B506012O00CD0003000D4O005C01030001000200066B010300B506013O0004B03O00B506012O00CD00036O0093000400013O00122O00050079012O00122O0006007A015O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300B5060100010004B03O00B506012O00CD0003000B3O001255010400043O00061C000400B5060100030004B03O00B506012O00CD0003000C3O001255010400043O00061C000400B5060100030004B03O00B506010012550103007B012O0012550104007B012O000652010300B5060100040004B03O00B506012O00CD000300034O000901045O00202O00040004002A4O000500043O00202O0005000500184O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300B506013O0004B03O00B506012O00CD000300013O0012550104007C012O0012550105007D013O008B000300054O00FB00036O00CD00036O006E000400013O00122O0005007E012O00122O0006007F015O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300E206013O0004B03O00E206012O00CD000300213O00066B010300E206013O0004B03O00E206012O00CD000300073O0020C70003000300624O00055O00122O00060080015O0005000500064O00030005000200062O000300E206013O0004B03O00E206012O00CD0003000B3O001255010400043O00061C000400E2060100030004B03O00E206012O00CD0003001E3O0020420103000300E84O00045O00202O0004000400E94O0005001F6O000600226O000700043O00202O0007000700184O00095O00202O0009000900E94O0007000900024O000700076O00030007000200062O000300E206013O0004B03O00E206012O00CD000300013O00125501040081012O00125501050082013O008B000300054O00FB00035O00125501020083012O00125501030084012O00125501040085012O00061C0003008B080100040004B03O008B0801001255010300223O0006520103008B080100020004B03O008B0801001255010300014O00C9000400043O00125501050086012O00125501060087012O00061C000600EC060100050004B03O00EC0601001255010500013O000652010300EC060100050004B03O00EC0601001255010400013O001255010500043O0006A8000400FB060100050004B03O00FB060100125501050088012O00125501060089012O00061C00060088070100050004B03O00880701001255010500013O001255010600043O0006A800050003070100060004B03O000307010012550106008A012O0012550107008B012O00061C00060005070100070004B03O00050701001255010400223O0004B03O008807010012550106008C012O001255010700813O00061C0007000C070100060004B03O000C0701001255010600013O0006A800050010070100060004B03O001007010012550106008D012O0012550107008E012O0006DE000700FC060100060004B03O00FC06012O00CD00066O006E000700013O00122O0008008F012O00122O00090090015O0007000900024O00060006000700202O00060006001D4O00060002000200062O0006003307013O0004B03O003307012O00CD0006000A3O00066B0106003307013O0004B03O003307012O00CD0006000B3O001255010700043O00061C00070033070100060004B03O003307012O00CD0006000C3O001255010700043O00061C00070033070100060004B03O003307012O00CD000600094O005C01060001000200066B0106003307013O0004B03O003307012O00CD00066O006E000700013O00122O00080091012O00122O00090092015O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006003707013O0004B03O0037070100125501060093012O00125501070094012O0006DE00060048070100070004B03O004807012O00CD000600034O000901075O00202O00070007004D4O000800043O00202O0008000800184O000A5O00202O000A000A004D4O0008000A00024O000800086O00060008000200062O0006004807013O0004B03O004807012O00CD000600013O00125501070095012O00125501080096013O008B000600084O00FB00065O00125501060097012O00125501070098012O00061C00070086070100060004B03O008607012O00CD00066O006E000700013O00122O00080099012O00122O0009009A015O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006008607013O0004B03O008607012O00CD000600283O00066B0106008607013O0004B03O008607012O00CD0006000B3O001255010700043O00061C00070086070100060004B03O008607012O00CD0006000C3O001255010700043O00061C00070086070100060004B03O008607012O00CD000600094O005C01060001000200066B0106008607013O0004B03O008607012O00CD00066O0093000700013O00122O0008009B012O00122O0009009C015O0007000900024O00060006000700202O00060006000C4O00060002000200062O00060086070100010004B03O008607010012550106009D012O0012550107009E012O00061C00060086070100070004B03O008607012O00CD000600034O006701075O00122O0008009F015O0007000700084O000800043O00202O0008000800184O000A5O00122O000B009F015O000A000A000B4O0008000A00024O000800086O00060008000200062O0006008607013O0004B03O008607012O00CD000600013O001255010700A0012O001255010800A1013O008B000600084O00FB00065O001255010500043O0004B03O00FC0601001255010500A2012O001255010600A3012O00061C000600EF070100050004B03O00EF0701001255010500A4012O001255010600A5012O00061C000500EF070100060004B03O00EF0701001255010500013O000652010400EF070100050004B03O00EF0701001255010500A6012O001255010600A7012O0006DE000600C1070100050004B03O00C107012O00CD00056O006E000600013O00122O000700A8012O00122O000800A9015O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500C107013O0004B03O00C107012O00CD000500293O00066B010500C107013O0004B03O00C107012O00CD0005002A3O00066B010500AA07013O0004B03O00AA07012O00CD000500123O0006CC000500AD070100010004B03O00AD07012O00CD0005002A3O0006CC000500C1070100010004B03O00C107012O00CD000500134O00CD000600143O00061C000500C1070100060004B03O00C107012O00CD000500094O005C0105000100020006CC000500C1070100010004B03O00C107012O00CD000500034O003B00065O00122O000700AA015O0006000600074O00050002000200062O000500C107013O0004B03O00C107012O00CD000500013O001255010600AB012O001255010700AC013O008B000500074O00FB00056O00CD00056O006E000600013O00122O000700AD012O00122O000800AE015O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500D907013O0004B03O00D907012O00CD0005000E3O00066B010500D907013O0004B03O00D907012O00CD000500094O005C01050001000200066B010500D907013O0004B03O00D907012O00CD000500073O00200D0005000500624O00075O00202O0007000700634O00050007000200062O000500DD070100010004B03O00DD0701001255010500AF012O001255010600B0012O00061C000500EE070100060004B03O00EE07012O00CD000500034O000901065O00202O00060006005B4O000700043O00202O0007000700184O00095O00202O00090009005B4O0007000900024O000700076O00050007000200062O000500EE07013O0004B03O00EE07012O00CD000500013O001255010600B1012O001255010700B2013O008B000500074O00FB00055O001255010400043O001255010500223O0006A8000400F6070100050004B03O00F60701001255010500B3012O001255010600B4012O00061C0006007B080100050004B03O007B0801001255010500013O001255010600B5012O001255010700B5012O00065201060075080100070004B03O00750801001255010600013O00065201060075080100050004B03O007508012O00CD00066O006E000700013O00122O000800B6012O00122O000900B7015O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006002708013O0004B03O002708012O00CD000600213O00066B0106002708013O0004B03O002708012O00CD000600094O005C01060001000200066B0106002708013O0004B03O002708012O00CD0006000D4O005C0106000100020006CC00060027080100010004B03O002708012O00CD00066O0093000700013O00122O000800B8012O00122O000900B9015O0007000900024O00060006000700202O00060006000C4O00060002000200062O00060027080100010004B03O002708012O00CD00066O0093000700013O00122O000800BA012O00122O000900BB015O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006002B080100010004B03O002B0801001255010600BC012O001255010700BD012O00061C00070040080100060004B03O004008012O00CD000600034O00BD00075O00202O0007000700E94O000800043O00202O0008000800184O000A5O00202O000A000A00E94O0008000A00024O000800086O00060008000200062O0006003B080100010004B03O003B0801001255010600BE012O001255010700BF012O0006DE00060040080100070004B03O004008012O00CD000600013O001255010700C0012O001255010800C1013O008B000600084O00FB00066O00CD00066O006E000700013O00122O000800C2012O00122O000900C3015O0007000900024O00060006000700202O00060006000C4O00060002000200062O0006007408013O0004B03O007408012O00CD0006000E3O00066B0106007408013O0004B03O007408012O00CD000600094O005C01060001000200066B0106007408013O0004B03O007408012O00CD00066O0093000700013O00122O000800C4012O00122O000900C5015O0007000900024O00060006000700202O00060006000C4O00060002000200062O00060074080100010004B03O007408012O00CD0006000D4O005C01060001000200066B0106007408013O0004B03O007408012O00CD000600034O00BD00075O00202O00070007005B4O000800043O00202O0008000800184O000A5O00202O000A000A005B4O0008000A00024O000800086O00060008000200062O0006006F080100010004B03O006F0801001255010600C6012O001255010700C7012O0006DE00070074080100060004B03O007408012O00CD000600013O001255010700C8012O001255010800C9013O008B000600084O00FB00065O001255010500043O001255010600043O000652010600F7070100050004B03O00F70701001255010400073O0004B03O007B08010004B03O00F70701001255010500CA012O001255010600CB012O00061C00060082080100050004B03O00820801001255010500073O0006A800040086080100050004B03O00860801001255010500CC012O0012550106009A3O00061C000600F4060100050004B03O00F40601001255010200073O0004B03O008B08010004B03O00F406010004B03O008B08010004B03O00EC0601001255010300CD012O000652010200B5080100030004B03O00B50801001255010300CE012O001255010400CE012O000652010300D5130100040004B03O00D51301001255010300CF012O001255010400D0012O0006DE000300D5130100040004B03O00D513012O00CD00036O006E000400013O00122O000500D1012O00122O000600D2015O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300D513013O0004B03O00D513012O00CD000300053O00066B010300D513013O0004B03O00D513012O00CD000300034O000901045O00202O00040004002A4O000500043O00202O0005000500184O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300D513013O0004B03O00D513012O00CD000300013O0012D9000400D3012O00122O000500D4015O000300056O00035O00044O00D5130100125501030083012O0006A8000300BC080100020004B03O00BC0801001255010300D5012O001255010400D6012O0006DE0003006E0A0100040004B03O006E0A01001255010300013O001255010400D7012O001255010500D8012O00061C000500CA080100040004B03O00CA0801001255010400D9012O001255010500D9012O000652010400CA080100050004B03O00CA0801001255010400073O000652010300CA080100040004B03O00CA0801001255010200DA012O0004B03O006E0A01001255010400223O0006A8000300D1080100040004B03O00D10801001255010400DB012O001255010500DC012O00061C0004005A090100050004B03O005A0901001255010400013O001255010500043O000652010400D7080100050004B03O00D70801001255010300073O0004B03O005A0901001255010500013O0006A8000400E2080100050004B03O00E20801001255010500DD012O001255010600DE012O00067F000600E2080100050004B03O00E20801001255010500DF012O001255010600E0012O00061C000500D2080100060004B03O00D20801001255010500E1012O001255010600E2012O00061C0005002O090100060004B03O002O09012O00CD00056O006E000600013O00122O000700E3012O00122O000800E4015O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002O09013O0004B03O002O09012O00CD000500283O00066B0105002O09013O0004B03O002O09012O00CD0005000D4O005C01050001000200066B0105002O09013O0004B03O002O09012O00CD00056O006E000600013O00122O000700E5012O00122O000800E6015O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002O09013O0004B03O002O09012O00CD0005000B3O001255010600043O00061C0006002O090100050004B03O002O09012O00CD0005000C3O001255010600043O00067F0006000D090100050004B03O000D0901001255010500E7012O001255010600E8012O00061C00050028090100060004B03O00280901001255010500E9012O001255010600E9012O00065201050028090100060004B03O002809012O00CD000500034O001101065O00122O0007009F015O0006000600074O000700043O00202O0007000700184O00095O00122O000A009F015O00090009000A4O0007000900024O000700076O00050007000200062O00050023090100010004B03O00230901001255010500EA012O001255010600EB012O0006DE00050028090100060004B03O002809012O00CD000500013O001255010600EC012O001255010700ED013O008B000500074O00FB00055O001255010500EE012O001255010600EF012O00061C00050058090100060004B03O005809012O00CD00056O006E000600013O00122O000700F0012O00122O000800F1015O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005005809013O0004B03O005809012O00CD0005000E3O00066B0105005809013O0004B03O005809012O00CD0005000D4O005C01050001000200066B0105005809013O0004B03O005809012O00CD00056O006E000600013O00122O000700F2012O00122O000800F3015O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005005809013O0004B03O005809012O00CD000500034O000901065O00202O00060006005B4O000700043O00202O0007000700184O00095O00202O00090009005B4O0007000900024O000700076O00050007000200062O0005005809013O0004B03O005809012O00CD000500013O001255010600F4012O001255010700F5013O008B000500074O00FB00055O001255010400043O0004B03O00D20801001255010400013O000652010300DA090100040004B03O00DA09012O00CD00046O006E000500013O00122O000600F6012O00122O000700F7015O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004009909013O0004B03O009909012O00CD000400053O00066B0104009909013O0004B03O009909012O00CD000400064O005C01040001000200066B0104009909013O0004B03O009909012O00CD00046O006E000500013O00122O000600F8012O00122O000700F9015O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004009909013O0004B03O009909012O00CD000400073O0020C70004000400C44O00065O00122O00070080015O0006000600074O00040006000200062O0004009909013O0004B03O009909012O00CD000400034O00BD00055O00202O00050005002A4O000600043O00202O0006000600184O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O00040094090100010004B03O00940901001255010400FA012O001255010500FB012O00067F00050094090100040004B03O009409010012550104002A012O001255010500FC012O00065201040099090100050004B03O009909012O00CD000400013O001255010500FD012O001255010600FE013O008B000400064O00FB00046O00CD00046O006E000500013O00122O000600FF012O00122O00072O00025O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400D909013O0004B03O00D909012O00CD000400053O00066B010400D909013O0004B03O00D909012O00CD000400064O005C01040001000200066B010400D909013O0004B03O00D909012O00CD00046O006E000500013O00122O00060001022O00122O0007002O025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400BC09013O0004B03O00BC09012O00CD000400043O0020910004000400204O00065O00202O0006000600214O00040006000200122O000500223O00062O000400C4090100050004B03O00C409012O00CD000400073O0020540004000400234O00065O00202O0006000600244O00040006000200122O000500913O00062O000400D9090100050004B03O00D909012O00CD000400034O00BD00055O00202O00050005002A4O000600043O00202O0006000600184O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400D4090100010004B03O00D4090100125501040003022O00125501050004022O00061C000400D9090100050004B03O00D909012O00CD000400013O00125501050005022O00125501060006023O008B000400064O00FB00045O001255010300043O001255010400043O0006A8000300E1090100040004B03O00E1090100125501040007022O00125501050008022O000652010400BD080100050004B03O00BD080100125501040009022O0012550105000A022O00061C000500400A0100040004B03O00400A010012550104000B022O0012550105000C022O00061C000400400A0100050004B03O00400A012O00CD00046O006E000500013O00122O0006000D022O00122O0007000E025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400400A013O0004B03O00400A012O00CD000400213O00066B010400400A013O0004B03O00400A012O00CD00046O0093000500013O00122O0006000F022O00122O00070010025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002C0A0100010004B03O002C0A012O00CD00046O0093000500013O00122O00060011022O00122O00070012025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002C0A0100010004B03O002C0A012O00CD00046O0093000500013O00122O00060013022O00122O00070014025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002C0A0100010004B03O002C0A012O00CD00046O006E000500013O00122O00060015022O00122O00070016025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002C0A013O0004B03O002C0A012O00CD00046O006E000500013O00122O00060017022O00122O00070018025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002C0A013O0004B03O002C0A012O00CD000400094O005C01040001000200066B010400400A013O0004B03O00400A012O00CD0004001E3O0020420104000400E84O00055O00202O0005000500E94O0006001F6O000700226O000800043O00202O0008000800184O000A5O00202O000A000A00E94O0008000A00024O000800086O00040008000200062O000400400A013O0004B03O00400A012O00CD000400013O00125501050019022O0012550106001A023O008B000400064O00FB00045O001255010400BD012O0012550105001B022O0006DE0004006C0A0100050004B03O006C0A012O00CD00046O006E000500013O00122O0006001C022O00122O0007001D025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004006C0A013O0004B03O006C0A012O00CD000400263O00066B0104006C0A013O0004B03O006C0A012O00CD000400034O001101055O00122O00060048015O0005000500064O000600043O00202O0006000600184O00085O00122O00090048015O0008000800094O0006000800024O000600066O00040006000200062O000400670A0100010004B03O00670A010012550104001E022O0012550105001F022O00064900040005000100050004B03O00670A0100125501040020022O0012550105001B022O0006520104006C0A0100050004B03O006C0A012O00CD000400013O00125501050021022O00125501060022023O008B000400064O00FB00045O001255010300223O0004B03O00BD080100125501030023022O0006A8000200750A0100030004B03O00750A0100125501030024022O00125501040025022O0006DE000300F90B0100040004B03O00F90B01001255010300013O001255010400223O000652010300D70A0100040004B03O00D70A012O00CD00046O006E000500013O00122O00060026022O00122O00070027025O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400A60A013O0004B03O00A60A0100123901040028022O00066B010400A60A013O0004B03O00A60A012O00CD000400073O00125501060029023O009D0004000400062O002101040002000200066B010400A60A013O0004B03O00A60A01001255010400E63O0012550105002A022O0006DE000400A60A0100050004B03O00A60A012O00CD0004001E3O0020820004000400E84O00055O00122O0006002B025O0005000500064O0006001F6O0007002B6O000800043O00202O0008000800184O000A5O00122O000B002B025O000A000A000B4O0008000A00024O000800086O00040008000200062O000400A60A013O0004B03O00A60A012O00CD000400013O0012550105002C022O0012550106002D023O008B000400064O00FB00046O00CD00046O006E000500013O00122O0006002E022O00122O0007002F025O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400B30A013O0004B03O00B30A0100123901040028022O0006CC000400BB0A0100010004B03O00BB0A0100125501040030022O00125501050031022O0006A8000400BB0A0100050004B03O00BB0A0100125501040032022O00125501050033022O00061C000500D60A0100040004B03O00D60A01001255010400E2012O00125501050034022O00061C000500D60A0100040004B03O00D60A0100125501040035022O00125501050035022O000652010400D60A0100050004B03O00D60A012O00CD000400034O006701055O00122O0006002B025O0005000500064O000600043O00202O0006000600184O00085O00122O0009002B025O0008000800094O0006000800024O000600066O00040006000200062O000400D60A013O0004B03O00D60A012O00CD000400013O00125501050036022O00125501060037023O008B000400064O00FB00045O001255010300073O00125501040038022O00125501050039022O00061C000500470B0100040004B03O00470B0100125501040008012O00125501050008012O000652010400470B0100050004B03O00470B01001255010400043O000652010300470B0100040004B03O00470B01001255010400013O0012550105003A022O0012550106003B022O00061C0006003D0B0100050004B03O003D0B01001255010500013O0006520104003D0B0100050004B03O003D0B012O00CD00056O006E000600013O00122O0007003C022O00122O0008003D025O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500FF0A013O0004B03O00FF0A012O00CD000500283O00066B010500FF0A013O0004B03O00FF0A012O00CD0005000B3O001255010600043O00061C000600FF0A0100050004B03O00FF0A012O00CD0005000C3O001255010600043O00067F000600030B0100050004B03O00030B010012550105003E022O001255010600D7012O000652010500160B0100060004B03O00160B012O00CD000500034O006701065O00122O0007009F015O0006000600074O000700043O00202O0007000700184O00095O00122O000A009F015O00090009000A4O0007000900024O000700076O00050007000200062O000500160B013O0004B03O00160B012O00CD000500013O0012550106003F022O00125501070040023O008B000500074O00FB00055O00125501050041022O00125501060042022O00061C0006003C0B0100050004B03O003C0B012O00CD00056O006E000600013O00122O00070043022O00122O00080044025O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005003C0B013O0004B03O003C0B012O00CD0005000E3O00066B0105003C0B013O0004B03O003C0B0100125501050045022O00125501060046022O00061C0005003C0B0100060004B03O003C0B012O00CD000500034O000901065O00202O00060006005B4O000700043O00202O0007000700184O00095O00202O00090009005B4O0007000900024O000700076O00050007000200062O0005003C0B013O0004B03O003C0B012O00CD000500013O00125501060047022O00125501070048023O008B000500074O00FB00055O001255010400043O00125501050049022O00125501060049022O000652010500E30A0100060004B03O00E30A01001255010500043O000652010400E30A0100050004B03O00E30A01001255010300223O0004B03O00470B010004B03O00E30A010012550104004A022O00125501050038012O00061C000500EB0B0100040004B03O00EB0B01001255010400013O000652010300EB0B0100040004B03O00EB0B01001255010400013O001255010500043O0006A8000400560B0100050004B03O00560B010012550105004B022O0012550106004C022O000652010500580B0100060004B03O00580B01001255010300043O0004B03O00EB0B01001255010500013O0006A80004005F0B0100050004B03O005F0B010012550105004D022O0012550106004E022O0006520105004F0B0100060004B03O004F0B010012550105004F022O0012550106004F022O000652010500A70B0100060004B03O00A70B012O00CD00056O006E000600013O00122O00070050022O00122O00080051025O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500A70B013O0004B03O00A70B012O00CD0005000E3O00066B010500A70B013O0004B03O00A70B012O00CD0005000D4O005C01050001000200066B010500A70B013O0004B03O00A70B012O00CD000500073O0020C70005000500C44O00075O00122O00080052025O0007000700084O00050007000200062O000500A70B013O0004B03O00A70B012O00CD00056O00DB000600013O00122O00070053022O00122O00080054025O0006000800024O00050005000600122O00070054015O0005000500074O00050002000200122O000600043O00062O000500A70B0100060004B03O00A70B012O00CD00056O006E000600013O00122O00070055022O00122O00080056025O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500A70B013O0004B03O00A70B0100125501050057022O00125501060058022O00061C000500A70B0100060004B03O00A70B012O00CD000500034O000901065O00202O00060006005B4O000700043O00202O0007000700184O00095O00202O00090009005B4O0007000900024O000700076O00050007000200062O000500A70B013O0004B03O00A70B012O00CD000500013O00125501060059022O0012550107005A023O008B000500074O00FB00055O001255010500C73O0012550106005B022O00061C000500E90B0100060004B03O00E90B012O00CD00056O006E000600013O00122O0007005C022O00122O0008005D025O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500E90B013O0004B03O00E90B012O00CD000500053O00066B010500E90B013O0004B03O00E90B012O00CD000500064O005C01050001000200066B010500E90B013O0004B03O00E90B012O00CD00056O0093000600013O00122O0007005E022O00122O0008005F025O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500E90B0100010004B03O00E90B012O00CD00056O0093000600013O00122O00070060022O00122O00080061025O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500E90B0100010004B03O00E90B0100125501050062022O00125501060063022O00061C000600E90B0100050004B03O00E90B012O00CD000500034O00BD00065O00202O00060006002A4O000700043O00202O0007000700184O00095O00202O00090009002A4O0007000900024O000700076O00050007000200062O000500E40B0100010004B03O00E40B0100125501050064022O00125501060065022O000652010500E90B0100060004B03O00E90B012O00CD000500013O00125501060066022O00125501070067023O008B000500074O00FB00055O001255010400043O0004B03O004F0B0100125501040068022O00125501050032022O00061C000400760A0100050004B03O00760A01001255010400073O0006A8000300F60B0100040004B03O00F60B0100125501040069022O0012550105006A022O0006DE000500760A0100040004B03O00760A01001255010200CD012O0004B03O00F90B010004B03O00760A010012550103006B022O0012550104006C022O0006DE00042O000C0100030004B04O000C010012550103004A3O0006A8000200040C0100030004B03O00040C010012550103006D022O0012550104006E022O000652010300770E0100040004B03O00770E012O00CD00036O006E000400013O00122O0005006F022O00122O00060070025O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300860C013O0004B03O00860C012O00CD000300053O00066B010300860C013O0004B03O00860C012O00CD000300064O005C01030001000200066B010300860C013O0004B03O00860C012O00CD000300094O005C01030001000200066B010300860C013O0004B03O00860C012O00CD00036O0093000400013O00122O00050071022O00122O00060072025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300860C0100010004B03O00860C012O00CD00036O0093000400013O00122O00050073022O00122O00060074025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300860C0100010004B03O00860C012O00CD00036O0093000400013O00122O00050075022O00122O00060076025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300860C0100010004B03O00860C012O00CD00036O006E000400013O00122O00050077022O00122O00060078025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300860C013O0004B03O00860C012O00CD000300084O005C01030001000200125501040079022O0006DE000400580C0100030004B03O00580C012O00CD000300084O005C010300010002001255010400F23O00061C000300580C0100040004B03O00580C012O00CD00036O0059010400013O00122O0005007A022O00122O0006007B025O0004000600024O00030003000400202O00030003000F4O0003000200024O000400073O00202O0004000400254O00040002000200067F0004006D0C0100030004B03O006D0C012O00CD000300084O005C0103000100020012550104007C022O0006DE000400860C0100030004B03O00860C012O00CD000300084O005C0103000100020012550104007D022O00061C000300860C0100040004B03O00860C012O00CD00036O00DA000400013O00122O0005007E022O00122O0006007F025O0004000600024O00030003000400202O00030003000F4O00030002000200122O000400013O00062O000400860C0100030004B03O00860C0100125501030080022O00125501040081022O00061C0004007D0C0100030004B03O007D0C012O00CD000300034O00BD00045O00202O00040004002A4O000500043O00202O0005000500184O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300810C0100010004B03O00810C0100125501030082022O00125501040083022O000652010300860C0100040004B03O00860C012O00CD000300013O00125501040084022O00125501050085023O008B000300054O00FB00035O00125501030024022O00125501040024022O000652010300E50C0100040004B03O00E50C012O00CD00036O006E000400013O00122O00050086022O00122O00060087025O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300E50C013O0004B03O00E50C012O00CD000300053O00066B010300E50C013O0004B03O00E50C012O00CD000300064O005C01030001000200066B010300E50C013O0004B03O00E50C012O00CD00036O0093000400013O00122O00050088022O00122O00060089025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300E50C0100010004B03O00E50C012O00CD00036O0093000400013O00122O0005008A022O00122O0006008B025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300E50C0100010004B03O00E50C012O00CD00036O0093000400013O00122O0005008C022O00122O0006008D025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300E50C0100010004B03O00E50C012O00CD000300084O005C01030001000200125501040039022O0006DE000400D00C0100030004B03O00D00C012O00CD000300084O005C010300010002001255010400393O00061C000300D00C0100040004B03O00D00C012O00CD00036O0059010400013O00122O0005008E022O00122O0006008F025O0004000600024O00030003000400202O00030003000F4O0003000200024O000400073O00202O0004000400254O00040002000200067F000400E90C0100030004B03O00E90C012O00CD000300084O005C01030001000200125501040090022O0006DE000400E50C0100030004B03O00E50C012O00CD000300084O005C01030001000200125501040091022O00061C000300E50C0100040004B03O00E50C012O00CD00036O00A6000400013O00122O00050092022O00122O00060093025O0004000600024O00030003000400202O00030003000F4O00030002000200122O000400013O00062O000400E90C0100030004B03O00E90C0100125501030094022O00125501040095022O00061C000400FE0C0100030004B03O00FE0C0100125501030096022O00125501040097022O0006DE000300FE0C0100040004B03O00FE0C012O00CD000300034O000901045O00202O00040004002A4O000500043O00202O0005000500184O00075O00202O00070007002A4O0005000700024O000500056O00030005000200062O000300FE0C013O0004B03O00FE0C012O00CD000300013O00125501040098022O00125501050099023O008B000300054O00FB00036O00CD00036O006E000400013O00122O0005009A022O00122O0006009B025O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003005F0D013O0004B03O005F0D012O00CD000300213O00066B0103005F0D013O0004B03O005F0D012O00CD000300073O0020C70003000300624O00055O00122O0006009C025O0005000500064O00030005000200062O0003005F0D013O0004B03O005F0D012O00CD00036O0093000400013O00122O0005009D022O00122O0006009E025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300630D0100010004B03O00630D012O00CD00036O0093000400013O00122O0005009F022O00122O000600A0025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300630D0100010004B03O00630D012O00CD00036O0093000400013O00122O000500A1022O00122O000600A2025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300630D0100010004B03O00630D012O00CD000300084O005C0103000100020012550104007D022O0006DE000400400D0100030004B03O00400D012O00CD00036O0093000400013O00122O000500A3022O00122O000600A4025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300630D0100010004B03O00630D012O00CD000300084O005C01030001000200125501040091022O0006DE000400550D0100030004B03O00550D012O00CD000300073O0020C70003000300624O00055O00122O00060002015O0005000500064O00030005000200062O000300550D013O0004B03O00550D012O00CD0003000B3O001255010400043O00061C000400550D0100030004B03O00550D012O00CD0003000C3O001255010400043O00067F000400630D0100030004B03O00630D012O00CD00036O006E000400013O00122O000500A5022O00122O000600A6025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300630D013O0004B03O00630D01001255010300A7022O001255010400A8022O00061C000300780D0100040004B03O00780D012O00CD000300034O00BD00045O00202O0004000400E94O000500043O00202O0005000500184O00075O00202O0007000700E94O0005000700024O000500056O00030005000200062O000300730D0100010004B03O00730D01001255010300A9022O001255010400AA022O0006DE000300780D0100040004B03O00780D012O00CD000300013O001255010400AB022O001255010500AC023O008B000300054O00FB00035O001255010300AD022O001255010400AE022O00061C000400D80D0100030004B03O00D80D012O00CD00036O006E000400013O00122O000500AF022O00122O000600B0025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300D80D013O0004B03O00D80D012O00CD000300213O00066B010300D80D013O0004B03O00D80D012O00CD000300073O0020C70003000300624O00055O00122O00060052025O0005000500064O00030005000200062O000300D80D013O0004B03O00D80D012O00CD00036O0093000400013O00122O000500B1022O00122O000600B2025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300C30D0100010004B03O00C30D012O00CD00036O0093000400013O00122O000500B3022O00122O000600B4025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300C30D0100010004B03O00C30D012O00CD00036O0093000400013O00122O000500B5022O00122O000600B6025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300C30D0100010004B03O00C30D012O00CD00036O006E000400013O00122O000500B7022O00122O000600B8025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300C30D013O0004B03O00C30D012O00CD00036O0093000400013O00122O000500B9022O00122O000600BA025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300D80D0100010004B03O00D80D01001255010300BB022O001255010400BC022O0006DE000300D80D0100040004B03O00D80D012O00CD000300034O000901045O00202O0004000400E94O000500043O00202O0005000500184O00075O00202O0007000700E94O0005000700024O000500056O00030005000200062O000300D80D013O0004B03O00D80D012O00CD000300013O001255010400BD022O001255010500BE023O008B000300054O00FB00035O001255010300BF022O001255010400BF022O000652010300010E0100040004B03O00010E012O00CD00036O006E000400013O00122O000500C0022O00122O000600C1025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300010E013O0004B03O00010E012O00CD000300213O00066B010300010E013O0004B03O00010E012O00CD000300073O0020B40003000300624O00055O00202O0005000500444O00030005000200062O000300010E013O0004B03O00010E012O00CD000300073O0020D200030003004800122O000500493O00122O0006004A6O00030006000200062O000300050E0100010004B03O00050E012O00CD00036O006E000400013O00122O000500C2022O00122O000600C3025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300050E013O0004B03O00050E01001255010300C4022O001255010400C5022O00061C000300210E0100040004B03O00210E01001255010300C6022O001255010400C7022O00061C000300210E0100040004B03O00210E01001255010300C8022O001255010400C9022O00061C000300210E0100040004B03O00210E012O00CD0003001E3O0020420103000300E84O00045O00202O0004000400E94O0005001F6O000600226O000700043O00202O0007000700184O00095O00202O0009000900E94O0007000900024O000700076O00030007000200062O000300210E013O0004B03O00210E012O00CD000300013O001255010400CA022O001255010500CB023O008B000300054O00FB00036O00CD00036O006E000400013O00122O000500CC022O00122O000600CD025O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003005A0E013O0004B03O005A0E012O00CD000300213O00066B0103005A0E013O0004B03O005A0E012O00CD000300073O0020B40003000300C44O00055O00202O0005000500444O00030005000200062O0003005A0E013O0004B03O005A0E012O00CD00036O006E000400013O00122O000500CE022O00122O000600CF025O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300490E013O0004B03O00490E012O00CD00036O0093000400013O00122O000500D0022O00122O000600D1025O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003005A0E0100010004B03O005A0E012O00CD00036O0093000400013O00122O000500D2022O00122O000600D3025O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003005A0E0100010004B03O005A0E012O00CD000300073O0020D200030003004800122O000500493O00122O0006004A6O00030006000200062O0003005E0E0100010004B03O005E0E01001255010300D4022O001255010400D5022O0006DE000300760E0100040004B03O00760E012O00CD0003001E3O0020050103000300E84O00045O00202O0004000400E94O0005001F6O000600226O000700043O00202O0007000700184O00095O00202O0009000900E94O0007000900022O0012010700074O00620003000700020006CC000300710E0100010004B03O00710E010012550103000C022O001255010400D6022O0006DE000300760E0100040004B03O00760E012O00CD000300013O001255010400D7022O001255010500D8023O008B000300054O00FB00035O001255010200D93O001255010300DA012O00065201030086100100020004B03O00861001001255010300013O001255010400A9022O001255010500A9022O000652010400210F0100050004B03O00210F01001255010400223O000652010300210F0100040004B03O00210F01001255010400D9022O001255010500DA022O0006DE000400CE0E0100050004B03O00CE0E012O00CD00046O006E000500013O00122O000600DB022O00122O000700DC025O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400B50E013O0004B03O00B50E012O00CD000400053O00066B010400B50E013O0004B03O00B50E012O00CD000400064O005C01040001000200066B010400B50E013O0004B03O00B50E012O00CD00046O0093000500013O00122O000600DD022O00122O000700DE025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B90E0100010004B03O00B90E012O00CD00046O006E000500013O00122O000600DF022O00122O000700E0025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B50E013O0004B03O00B50E012O00CD00046O006E000500013O00122O000600E1022O00122O000700E2025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B90E013O0004B03O00B90E01001255010400E3022O001255010500E4022O00061C000500CE0E0100040004B03O00CE0E01001255010400E5022O001255010500E6022O0006DE000400CE0E0100050004B03O00CE0E012O00CD000400034O000901055O00202O00050005002A4O000600043O00202O0006000600184O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400CE0E013O0004B03O00CE0E012O00CD000400013O001255010500E7022O001255010600E8023O008B000400064O00FB00045O001255010400E9022O001255010500EA022O00061C000500200F0100040004B03O00200F012O00CD00046O006E000500013O00122O000600EB022O00122O000700EC025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400200F013O0004B03O00200F012O00CD000400283O00066B010400200F013O0004B03O00200F012O00CD0004000D4O005C01040001000200066B010400200F013O0004B03O00200F012O00CD000400073O0020C70004000400C44O00065O00122O00070052025O0006000600074O00040006000200062O000400200F013O0004B03O00200F012O00CD00046O00DB000500013O00122O000600ED022O00122O000700EE025O0005000700024O00040004000500122O00060054015O0004000400064O00040002000200122O000500043O00062O000400200F0100050004B03O00200F012O00CD00046O006E000500013O00122O000600EF022O00122O000700F0025O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400200F013O0004B03O00200F012O00CD0004000B3O001255010500043O00061C000500200F0100040004B03O00200F012O00CD0004000C3O001255010500043O00061C000500200F0100040004B03O00200F01001255010400F1022O001255010500F1022O000652010400200F0100050004B03O00200F012O00CD000400034O006701055O00122O0006009F015O0005000500064O000600043O00202O0006000600184O00085O00122O0009009F015O0008000800094O0006000800024O000600066O00040006000200062O000400200F013O0004B03O00200F012O00CD000400013O001255010500F2022O001255010600F3023O008B000400064O00FB00045O001255010300073O001255010400043O000652010300CC0F0100040004B03O00CC0F01001255010400F4022O001255010500F5022O0006DE0004006F0F0100050004B03O006F0F012O00CD00046O006E000500013O00122O000600F6022O00122O000700F7025O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004006F0F013O0004B03O006F0F012O00CD0004000E3O00066B0104006F0F013O0004B03O006F0F012O00CD0004002C3O001255010600F8023O009D0004000400062O002101040002000200066B0104006F0F013O0004B03O006F0F012O00CD0004002C3O00121F000600F9025O0004000400064O0004000200024O000500013O00122O000600FA022O00122O000700FB025O00050007000200062O0004006F0F0100050004B03O006F0F012O00CD000400043O00127701060047015O0004000400064O00065O00122O000700FC025O0006000600074O00040006000200062O0004006F0F013O0004B03O006F0F012O00CD000400043O00120401060047015O0004000400064O00065O00202O0006000600214O00040006000200062O0004005A0F0100010004B03O005A0F012O00CD0004000D4O005C01040001000200066B0104006F0F013O0004B03O006F0F01001255010400FD022O001255010500FE022O00061C0005006F0F0100040004B03O006F0F012O00CD000400034O000901055O00202O00050005005B4O000600043O00202O0006000600184O00085O00202O00080008005B4O0006000800024O000600066O00040006000200062O0004006F0F013O0004B03O006F0F012O00CD000400013O001255010500FF022O00125501062O00033O008B000400064O00FB00046O00CD00046O006E000500013O00122O00060001032O00122O00070002035O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400CB0F013O0004B03O00CB0F012O00CD000400053O00066B010400CB0F013O0004B03O00CB0F012O00CD000400064O005C01040001000200066B010400CB0F013O0004B03O00CB0F012O00CD0004000D4O005C01040001000200066B010400CB0F013O0004B03O00CB0F012O00CD000400073O0020C70004000400C44O00065O00122O00070052025O0006000600074O00040006000200062O000400CB0F013O0004B03O00CB0F012O00CD00046O0093000500013O00122O0006002O032O00122O00070004035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400CB0F0100010004B03O00CB0F012O00CD00046O0093000500013O00122O00060005032O00122O00070006035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400CB0F0100010004B03O00CB0F012O00CD00046O00DB000500013O00122O00060007032O00122O00070008035O0005000700024O00040004000500122O00060054015O0004000400064O00040002000200122O000500043O00062O000400CB0F0100050004B03O00CB0F012O00CD00046O006E000500013O00122O00060009032O00122O0007000A035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400CB0F013O0004B03O00CB0F010012550104000B032O0012550105000C032O00061C000400CB0F0100050004B03O00CB0F012O00CD000400034O000901055O00202O00050005002A4O000600043O00202O0006000600184O00085O00202O00080008002A4O0006000800024O000600066O00040006000200062O000400CB0F013O0004B03O00CB0F012O00CD000400013O0012550105000D032O0012550106000E033O008B000400064O00FB00045O001255010300223O0012550104000F032O00125501050010032O0006DE000400D30F0100050004B03O00D30F01001255010400073O0006A8000300D70F0100040004B03O00D70F0100125501040011032O00125501050012032O0006DE000500D90F0100040004B03O00D90F0100125501020023022O0004B03O0086100100125501040013032O00125501050014032O0006DE0005007B0E0100040004B03O007B0E01001255010400013O0006520103007B0E0100040004B03O007B0E01001255010400013O00125501050015032O00125501060016032O0006DE000500EE0F0100060004B03O00EE0F0100125501050017032O00125501060018032O00061C000500EE0F0100060004B03O00EE0F01001255010500043O000652010500EE0F0100040004B03O00EE0F01001255010300043O0004B03O007B0E01001255010500013O0006A8000400F50F0100050004B03O00F50F0100125501050019032O0012550106001A032O00061C000500E10F0100060004B03O00E10F010012550105001B032O0012550106001B032O0006520105002E100100060004B03O002E10010012550105001C032O0012550106001D032O00061C0005002E100100060004B03O002E10012O00CD00056O006E000600013O00122O0007001E032O00122O0008001F035O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002E10013O0004B03O002E10012O00CD00056O00F2000600013O00122O00070020032O00122O00080021035O0006000800024O00050005000600202O00050005000F4O00050002000200122O000600013O00062O0005002E100100060004B03O002E10012O00CD000500023O00066B0105002E10013O0004B03O002E100100125501050022032O00125501060023032O0006DE0005002E100100060004B03O002E10012O00CD000500034O00BD00065O00202O0006000600174O000700043O00202O0007000700184O00095O00202O0009000900174O0007000900024O000700076O00050007000200062O00050029100100010004B03O002910010012550105005E3O00125501060024032O0006520105002E100100060004B03O002E10012O00CD000500013O00125501060025032O00125501070026033O008B000500074O00FB00055O00125501050027032O00125501060028032O00061C00050083100100060004B03O008310012O00CD00056O006E000600013O00122O00070029032O00122O0008002A035O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005008310013O0004B03O008310012O00CD000500283O00066B0105008310013O0004B03O008310012O00CD0005002C3O001255010700F8023O009D0005000500072O002101050002000200066B0105008310013O0004B03O008310012O00CD0005002C3O00121F000700F9025O0005000500074O0005000200024O000600013O00122O0007002B032O00122O0008002C035O00060008000200062O00050083100100060004B03O008310012O00CD000500043O00127701070047015O0005000500074O00075O00122O000800FC025O0007000700084O00050007000200062O0005008310013O0004B03O008310012O00CD000500043O00120401070047015O0005000500074O00075O00202O0007000700214O00050007000200062O00050064100100010004B03O006410012O00CD0005000D4O005C01050001000200066B0105008310013O0004B03O008310012O00CD0005000B3O001255010600043O00061C00060083100100050004B03O008310012O00CD0005000C3O001255010600043O00061C00060083100100050004B03O008310010012550105002D032O0012550106002E032O0006DE00060083100100050004B03O008310012O00CD000500034O006701065O00122O0007009F015O0006000600074O000700043O00202O0007000700184O00095O00122O000A009F015O00090009000A4O0007000900024O000700076O00050007000200062O0005008310013O0004B03O008310012O00CD000500013O0012550106002F032O00125501070030033O008B000500074O00FB00055O001255010400043O0004B03O00E10F010004B03O007B0E0100125501030031032O00125501040032032O0006DE00030009000100040004B03O00090001001255010300043O00065201020009000100030004B03O00090001001255010300013O001255010400223O0006A800030095100100040004B03O0095100100125501040033032O00125501050034032O00061C00040085110100050004B03O0085110100125501040035032O00125501050036032O00061C00040006110100050004B03O000611012O00CD00046O006E000500013O00122O00060037032O00122O00070038035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004000611013O0004B03O000611012O00CD00046O00F2000500013O00122O00060039032O00122O0007003A035O0005000700024O00040004000500202O00040004000F4O00040002000200122O000500013O00062O00040006110100050004B03O000611012O00CD000400073O0020330004000400624O00065O00122O0007003B035O0006000600074O00040006000200062O00040006110100010004B03O000611012O00CD0004002D3O00066B0104000611013O0004B03O000611012O00CD0004002E3O00066B010400BF10013O0004B03O00BF10012O00CD0004001D3O0006CC000400C2100100010004B03O00C210012O00CD0004002E3O0006CC00040006110100010004B03O000611012O00CD000400134O00CD000500143O00061C00040006110100050004B03O000611012O00CD000400073O0020B40004000400C44O00065O00202O0006000600444O00040006000200062O0004000611013O0004B03O000611012O00CD000400094O005C0104000100020006CC00040006110100010004B03O000611012O00CD000400073O0020B40004000400624O00065O00202O0006000600634O00040006000200062O0004000611013O0004B03O000611012O00CD00046O0093000500013O00122O0006003C032O00122O0007003D035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040006110100010004B03O000611012O00CD00046O0093000500013O00122O0006003E032O00122O0007003F035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040006110100010004B03O000611012O00CD00046O0093000500013O00122O00060040032O00122O00070041035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040006110100010004B03O000611012O00CD000400034O008900055O00122O00060042035O0005000500064O00040002000200062O00040001110100010004B03O0001110100125501040043032O001255010500FD022O0006DE00040006110100050004B03O000611012O00CD000400013O00125501050044032O00125501060045033O008B000400064O00FB00045O00125501040046032O001255010500EA022O00061C00050084110100040004B03O008411012O00CD00046O006E000500013O00122O00060047032O00122O00070048035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004008411013O0004B03O008411012O00CD00046O00F2000500013O00122O00060049032O00122O0007004A035O0005000700024O00040004000500202O00040004000F4O00040002000200122O000500013O00062O00040084110100050004B03O008411012O00CD000400073O0020330004000400624O00065O00122O0007003B035O0006000600074O00040006000200062O00040084110100010004B03O008411012O00CD0004002D3O00066B0104008411013O0004B03O008411012O00CD0004002E3O00066B0104003011013O0004B03O003011012O00CD0004001D3O0006CC00040033110100010004B03O003311012O00CD0004002E3O0006CC00040084110100010004B03O008411012O00CD000400134O00CD000500143O00061C00040084110100050004B03O008411012O00CD000400073O0020B40004000400C44O00065O00202O0006000600444O00040006000200062O0004008411013O0004B03O008411012O00CD000400094O005C0104000100020006CC00040084110100010004B03O008411012O00CD00046O006E000500013O00122O0006004B032O00122O0007004C035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007411013O0004B03O007411012O00CD00046O006E000500013O00122O0006004D032O00122O0007004E035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007411013O0004B03O007411012O00CD00046O0093000500013O00122O0006004F032O00122O00070050035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040074110100010004B03O007411012O00CD00046O0093000500013O00122O00060051032O00122O00070052035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040074110100010004B03O007411012O00CD00046O006E000500013O00122O00060053032O00122O00070054035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004008411013O0004B03O0084110100125501040055032O00125501050056032O00061C00040084110100050004B03O008411012O00CD000400034O003B00055O00122O00060042035O0005000500064O00040002000200062O0004008411013O0004B03O008411012O00CD000400013O00125501050057032O00125501060058033O008B000400064O00FB00045O001255010300073O00125501040059032O00125501050059032O0006520104008C110100050004B03O008C1101001255010400013O0006A800040090110100030004B03O009011010012550104005A032O0012550105005B032O0006DE00050092120100040004B03O009212012O00CD00046O006E000500013O00122O0006005C032O00122O0007005D035O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400FF11013O0004B03O00FF110100123901040028022O00066B010400FF11013O0004B03O00FF11012O00CD0004000B3O001255010500043O000652010400FF110100050004B03O00FF11012O00CD000400043O0012870006005E035O0004000400064O00065O00202O0006000600904O00040006000200062O000400FF11013O0004B03O00FF11012O00CD000400073O0020B40004000400C44O00065O00202O0006000600634O00040006000200062O000400FF11013O0004B03O00FF11012O00CD0004000D4O005C01040001000200066B010400E411013O0004B03O00E411012O00CD000400094O005C0104000100020006CC000400FF110100010004B03O00FF11012O00CD00046O006E000500013O00122O0006005F032O00122O00070060035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400D311013O0004B03O00D311012O00CD000400084O00AE0004000100024O00058O000600013O00122O00070061032O00122O00080062035O0006000800024O00050005000600122O00070063035O0005000500074O000500020002001255010600DA013O004A00050006000500125501060064033O00D000050006000500067F000400E4110100050004B03O00E411012O00CD000400084O00AE0004000100024O00058O000600013O00122O00070065032O00122O00080066035O0006000800024O00050005000600122O00070063035O0005000500074O000500020002001255010600D94O004A00050006000500125501060067033O00D000050006000500061C000400FF110100050004B03O00FF110100125501040068032O00125501050069032O0006DE000500FF110100040004B03O00FF11012O00CD000400034O001101055O00122O0006002B025O0005000500064O000600043O00202O0006000600184O00085O00122O0009002B025O0008000800094O0006000800024O000600066O00040006000200062O000400FA110100010004B03O00FA11010012550104006A032O0012550105006B032O000652010400FF110100050004B03O00FF11012O00CD000400013O0012550105006C032O0012550106006D033O008B000400064O00FB00045O0012550104006E032O00125501050088012O0006DE00050091120100040004B03O009112010012550104006F032O00125501050070032O0006DE00050091120100040004B03O009112012O00CD00046O006E000500013O00122O00060071032O00122O00070072035O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004009112013O0004B03O0091120100123901040028022O00066B0104009112013O0004B03O009112012O00CD00046O00F2000500013O00122O00060073032O00122O00070074035O0005000700024O00040004000500202O00040004008F4O00040002000200122O000500013O00062O00040091120100050004B03O009112012O00CD0004000B3O001255010500043O00061C00050091120100040004B03O009112012O00CD0004000C3O001255010500043O00061C00050091120100040004B03O009112012O00CD00046O0093000500013O00122O00060075032O00122O00070076035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040059120100010004B03O005912012O00CD00046O0093000500013O00122O00060077032O00122O00070078035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040059120100010004B03O005912012O00CD00046O0093000500013O00122O00060079032O00122O0007007A035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040059120100010004B03O005912012O00CD00046O0093000500013O00122O0006007B032O00122O0007007C035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040059120100010004B03O005912012O00CD00046O006E000500013O00122O0006007D032O00122O0007007E035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004009112013O0004B03O009112012O00CD0004000D4O005C0104000100020006CC0004006C120100010004B03O006C12012O00CD000400094O005C0104000100020006CC00040076120100010004B03O007612012O00CD00046O00A6000500013O00122O0006007F032O00122O00070080035O0005000700024O00040004000500202O00040004000F4O00040002000200122O000500013O00062O00050076120100040004B03O007612012O00CD00046O0093000500013O00122O00060081032O00122O00070082035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040091120100010004B03O009112012O00CD0004001E3O0020F40004000400C94O00055O00122O0006002B025O0005000500064O0006001F6O000700013O00122O00080083032O00122O00090084035O0007000900024O000800206O000900096O000A00043O00202O000A000A00184O000C5O00122O000D002B025O000C000C000D4O000A000C00024O000A000A6O0004000A000200062O0004009112013O0004B03O009112012O00CD000400013O00125501050085032O00125501060086033O008B000400064O00FB00045O001255010300043O00125501040087032O00125501050088032O00061C00040099120100050004B03O00991201001255010400073O0006A80003009D120100040004B03O009D120100125501040089032O0012550105008A032O0006520104009F120100050004B03O009F1201001255010200223O0004B03O000900010012550104008B032O0012550105008B032O0006520104008E100100050004B03O008E10010012550104008C032O0012550105008D032O0006DE0005008E100100040004B03O008E1001001255010400043O0006520103008E100100040004B03O008E10012O00CD00046O006E000500013O00122O0006008E032O00122O0007008F035O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004001013013O0004B03O0010130100123901040028022O00066B0104001013013O0004B03O001013012O00CD0004000B3O001255010500043O00061C00050010130100040004B03O001013012O00CD0004000C3O001255010500043O00061C00050010130100040004B03O001013012O00CD00046O0093000500013O00122O00060090032O00122O00070091035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400F1120100010004B03O00F112012O00CD00046O0093000500013O00122O00060092032O00122O00070093035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400F1120100010004B03O00F112012O00CD00046O0093000500013O00122O00060094032O00122O00070095035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400F1120100010004B03O00F112012O00CD00046O0093000500013O00122O00060096032O00122O00070097035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400F1120100010004B03O00F112012O00CD00046O006E000500013O00122O00060098032O00122O00070099035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004001013013O0004B03O001013012O00CD000400073O0020B40004000400624O00065O00202O0006000600634O00040006000200062O0004000613013O0004B03O000613012O00CD000400094O005C0104000100020006CC00040006130100010004B03O000613012O00CD00046O0093000500013O00122O0006009A032O00122O0007009B035O0005000700024O00040004000500202O00040004000C4O00040002000200062O00040014130100010004B03O001413012O00CD00046O006E000500013O00122O0006009C032O00122O0007009D035O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004001413013O0004B03O001413010012550104006B3O0012550105009E032O00061C00040033130100050004B03O00331301001255010400933O001255010500933O00065201040033130100050004B03O003313012O00CD0004001E3O0020580004000400C94O00055O00122O0006002B025O0005000500064O0006001F6O000700013O00122O0008009F032O00122O000900A0035O0007000900024O000800206O0009002B6O000A00043O00202O000A000A00184O000C5O00122O000D002B025O000C000C000D4O000A000C00024O000A000A6O0004000A000200062O0004003313013O0004B03O003313012O00CD000400013O001255010500A1032O001255010600A2033O008B000400064O00FB00045O001255010400A3032O001255010500A4032O0006DE000500C4130100040004B03O00C413012O00CD00046O006E000500013O00122O000600A5032O00122O000700A6035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B013013O0004B03O00B013012O00CD00046O00F2000500013O00122O000600A7032O00122O000700A8035O0005000700024O00040004000500202O00040004000F4O00040002000200122O000500013O00062O000400B0130100050004B03O00B013012O00CD000400073O0020330004000400624O00065O00122O0007003B035O0006000600074O00040006000200062O000400B0130100010004B03O00B013012O00CD0004002D3O00066B010400B013013O0004B03O00B013012O00CD0004002E3O00066B0104005D13013O0004B03O005D13012O00CD0004001D3O0006CC00040060130100010004B03O006013012O00CD0004002E3O0006CC000400B0130100010004B03O00B013012O00CD000400134O00CD000500143O00061C000400B0130100050004B03O00B013012O00CD000400073O0020B40004000400C44O00065O00202O0006000600444O00040006000200062O000400B013013O0004B03O00B013012O00CD000400094O005C0104000100020006CC000400B0130100010004B03O00B013012O00CD000400084O005C010400010002001255010500A9032O0006DE000500B0130100040004B03O00B013012O00CD00046O006E000500013O00122O000600AA032O00122O000700AB035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B013013O0004B03O00B013012O00CD00046O006E000500013O00122O000600AC032O00122O000700AD035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B013013O0004B03O00B013012O00CD00046O006E000500013O00122O000600AE032O00122O000700AF035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B013013O0004B03O00B013012O00CD00046O0093000500013O00122O000600B0032O00122O000700B1035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B0130100010004B03O00B013012O00CD00046O0093000500013O00122O000600B2032O00122O000700B3035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B0130100010004B03O00B013012O00CD00046O006E000500013O00122O000600B4032O00122O000700B5035O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400B413013O0004B03O00B41301001255010400B6032O001255010500B7032O00061C000400C4130100050004B03O00C41301001255010400B8032O001255010500B9032O0006DE000500C4130100040004B03O00C413012O00CD000400034O003B00055O00122O00060042035O0005000500064O00040002000200062O000400C413013O0004B03O00C413012O00CD000400013O001255010500BA032O001255010600BB033O008B000400064O00FB00045O001255010300223O0004B03O008E10010004B03O000900010004B03O00D513010004B03O000600010004B03O00D51301001255010300BC032O001255010400BD032O00061C00040002000100030004B03O00020001001255010300013O000652012O0002000100030004B03O000200010012552O0100014O00C9000200023O001255012O00043O0004B03O000200012O00013O00017O006B3O00028O00026O006440025O00BC9040025O00F09340025O00F2AA40025O00C1B140025O00406D40025O00849B40025O00B09340030B3O003F8999C412BB83D91F848F03043O00B07AE8EB030A3O0049734361737461626C6503083O0042752O66446F776E030F3O004561727468536869656C6442752O66030C3O00A574285BE6C0463246EB8C7103053O008EE0155A2F030E3O0051D8225BA1859175D80844A6829103073O00E514B44736C4EB030B3O004973417661696C61626C6503063O0042752O665570030F3O004C696768746E696E67536869656C64025O00D4A540025O00088D40030B3O004561727468536869656C64025O004C9540026O00784003133O002C7FD3F7FD95932177C4EFF1EA8D2877CFA3A703073O00E0491EA18395CA030F3O00DDECF658E5EBF85EF6D6F959F4E9F503043O003091859103133O004C696768746E696E67536869656C6442752O6603103O007645B2E6C5225342B2AEE2245349B9EA03063O004C3A2CD58EB1030E3O00EE2817207DC530132157D9261B3903053O0018AB44724D025O00ABB040025O00C9B240025O00807040025O00C89640025O00CAA440025O0088A24003173O00E314575A93D00DA3E822435A8EDB08A9AF10515B899E5603083O00CD8F7D3032E7BE64026O00F03F025O0018AB40025O0018AF40027O0040025O00489040025O00C4B240025O00808E40025O0046B340025O0078AB40025O00606840026O000840025O00E88740025O00AC9D40030F3O00CD2ACBADE4B6FE25C49BE7ABFE2DDC03063O00C28C44A8C897030F3O0063F5D620E656E9D429C652F2C72CE103053O0095229BB54503073O0049735265616479030F3O00412O66656374696E67436F6D62617403063O00457869737473030D3O004973446561644F7247686F737403093O00497341506C6179657203093O0043616E412O7461636B025O00B6A740025O0088864003183O00416E6365737472616C5370697269744D6F7573656F766572025O00808540025O0024AD40031A3O0002F3D6FF10E9C7FB0FC2C6EA0AEFDCEE43F0DAEF10F8DAEC06EF03043O009A639DB5025O00D6AE40025O0088974003193O00A402FCB2E39B0AE886E08C02E9B4E38308F9A5DB880EFCAFE203053O008CED6F8CC0024O00804F224103113O0020157C15030D7216010C782F03186D170803043O007866791D025O00DCAA40025O00E4AB4003123O00466C616D656E746F6E677565576561706F6E025O00709E40025O00E2A540031A3O00AAEFB836A9F7B635ABF6BC04BBE6B82BA3EDF93EA2E0B13AA2F703043O005BCC83D9025O00A4AF40025O00609F40030D3O00546172676574497356616C6964025O0078AD40025O00D09F40025O00D2AF40025O00F08040025O00309D40025O00DEAB40025O00FCA640025O00A08240025O00307840025O0060A840030F3O00416E6365737472616C537069726974025O00A08540025O00A4A04003103O00C0A91700F2F7CDA3CD980715E8F1D6B603083O00C2A1C774658183BF026O00AE40025O0080AA400084012O001255012O00014O00C9000100013O0026D53O0002000100010004B03O000200010012552O0100013O002E5001020009000100030004B03O000900010026C00001000B000100010004B03O000B0001002E000104008B000100050004B03O00940001001255010200013O002E5001070010000100060004B03O001000010026C000020012000100010004B03O00120001002E000108007F000100090004B03O008F00012O00CD00035O00066B0103003E00013O0004B03O003E00012O00CD000300014O006E000400023O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003E00013O0004B03O003E00012O00CD000300033O0020B400030003000D4O000500013O00202O00050005000E4O00030005000200062O0003003E00013O0004B03O003E00012O00CD000300044O005A010400023O00122O0005000F3O00122O000600106O00040006000200062O00030040000100040004B03O004000012O00CD000300014O006E000400023O00122O000500113O00122O000600126O0004000600024O00030003000400202O0003000300134O00030002000200062O0003003E00013O0004B03O003E00012O00CD000300033O00200D0003000300144O000500013O00202O0005000500154O00030005000200062O00030040000100010004B03O00400001002E500116004E000100170004B03O004E00012O00CD000300054O00CD000400013O0020920004000400182O00210103000200020006CC00030048000100010004B03O00480001002E500119008B0001001A0004B03O008B00012O00CD000300023O0012D90004001B3O00122O0005001C6O000300056O00035O00044O008B00012O00CD00035O00066B0103007A00013O0004B03O007A00012O00CD000300014O006E000400023O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003007A00013O0004B03O007A00012O00CD000300033O0020B400030003000D4O000500013O00202O00050005001F4O00030005000200062O0003007A00013O0004B03O007A00012O00CD000300044O005A010400023O00122O000500203O00122O000600216O00040006000200062O0003007E000100040004B03O007E00012O00CD000300014O006E000400023O00122O000500223O00122O000600236O0004000600024O00030003000400202O0003000300134O00030002000200062O0003007A00013O0004B03O007A00012O00CD000300033O00200D0003000300144O000500013O00202O0005000500184O00030005000200062O0003007E000100010004B03O007E0001002E250124007E000100250004B03O007E0001002E590027008B000100260004B03O008B00012O00CD000300054O00CD000400013O0020920004000400152O00210103000200020006CC00030086000100010004B03O00860001002E590028008B000100290004B03O008B00012O00CD000300023O0012550104002A3O0012550105002B4O008B000300054O00FB00036O00CD000300074O005C0103000100022O0006010300063O0012550102002C3O0026D50002000C0001002C0004B03O000C00010012552O01002C3O0004B03O009400010004B03O000C0001002E59002D00F00001002E0004B03O00F00001000E47012F00F0000100010004B03O00F00001001255010200014O00C9000300033O002E500130009A000100310004B03O009A0001002E590032009A000100330004B03O009A00010026D50002009A000100010004B03O009A0001001255010300013O002E59003500A7000100340004B03O00A700010026D5000300A70001002C0004B03O00A700010012552O0100363O0004B03O00F00001000E372O0100AB000100030004B03O00AB0001002E50013800A1000100370004B03O00A100012O00CD000400014O006E000500023O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400D900013O0004B03O00D900012O00CD000400014O006E000500023O00122O0006003B3O00122O0007003C6O0005000700024O00040004000500202O00040004003D4O00040002000200062O000400D900013O0004B03O00D900012O00CD000400033O0020BC00040004003E2O00210104000200020006CC000400D9000100010004B03O00D900012O00CD000400083O0020BC00040004003F2O002101040002000200066B010400D900013O0004B03O00D900012O00CD000400083O0020BC0004000400402O002101040002000200066B010400D900013O0004B03O00D900012O00CD000400083O0020BC0004000400412O002101040002000200066B010400D900013O0004B03O00D900012O00CD000400033O0020BC0004000400422O00CD000600084O006200040006000200066B010400DB00013O0004B03O00DB0001002E59004300E8000100440004B03O00E800012O00CD000400054O00CD000500093O0020920005000500452O00210104000200020006CC000400E3000100010004B03O00E30001002E0001460007000100470004B03O00E800012O00CD000400023O001255010500483O001255010600494O008B000400064O00FB00046O00CD0004000C4O00E20004000100054O0005000B6O0004000A3O00122O0003002C3O00044O00A100010004B03O00F000010004B03O009A0001002E50014B003F2O01004A0004B03O003F2O010026D50001003F2O0100360004B03O003F2O012O00CD000200014O006E000300023O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300202O0002000200134O00020002000200062O000200112O013O0004B03O00112O012O00CD0002000D3O00066B010200112O013O0004B03O00112O012O00CD0002000A3O00066B010200072O013O0004B03O00072O012O00CD0002000B3O00266A010200112O01004E0004B03O00112O012O00CD000200014O0093000300023O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200134O00020002000200062O000200132O0100010004B03O00132O01002E59005200202O0100510004B03O00202O012O00CD000200054O00CD000300013O0020920003000300532O00210102000200020006CC0002001B2O0100010004B03O001B2O01002E50015500202O0100540004B03O00202O012O00CD000200023O001255010300563O001255010400574O008B000200044O00FB00025O002E50015900832O0100580004B03O00832O012O00CD000200033O0020BC00020002003E2O00210102000200020006CC000200832O0100010004B03O00832O012O00CD0002000E3O00066B010200832O013O0004B03O00832O012O00CD0002000F3O00209200020002005A2O005C01020001000200066B010200832O013O0004B03O00832O01001255010200013O000E472O0100302O0100020004B03O00302O012O00CD000300104O005C0103000100022O0006010300063O002E50015C00832O01005B0004B03O00832O012O00CD000300063O00066B010300832O013O0004B03O00832O012O00CD000300064O0052000300023O0004B03O00832O010004B03O00302O010004B03O00832O010026D5000100050001002C0004B03O00050001001255010200013O0026C0000200482O0100010004B03O00482O01002EE9005D00482O01005E0004B03O00482O01002E50016000792O01005F0004B03O00792O012O00CD000300063O00066B0103004D2O013O0004B03O004D2O012O00CD000300064O0052000300023O002E50016200782O0100610004B03O00782O01002E50016300782O0100640004B03O00782O012O00CD000300113O00066B010300782O013O0004B03O00782O012O00CD000300113O0020BC00030003003F2O002101030002000200066B010300782O013O0004B03O00782O012O00CD000300113O0020BC0003000300412O002101030002000200066B010300782O013O0004B03O00782O012O00CD000300113O0020BC0003000300402O002101030002000200066B010300782O013O0004B03O00782O012O00CD000300033O0020BC0003000300422O00CD000500114O00620003000500020006CC000300782O0100010004B03O00782O012O00CD000300054O001E000400013O00202O0004000400654O000500056O000600016O00030006000200062O000300732O0100010004B03O00732O01002E59006700782O0100660004B03O00782O012O00CD000300023O001255010400683O001255010500694O008B000300054O00FB00035O0012550102002C3O0026C00002007D2O01002C0004B03O007D2O01002E59006A00422O01006B0004B03O00422O010012552O01002F3O0004B03O000500010004B03O00422O010004B03O000500010004B03O00832O010004B03O000200012O00013O00017O001C012O00028O00026O00F03F025O00807A40025O0088A940025O00ACAD40025O00407140025O00C0A240025O00549040025O00AC9140025O009EAC40025O000AB340025O00108340025O00F2A440025O000EA540025O001CAC40025O0062A940025O007CA540025O00F8AF40025O008EA040025O00805F40025O00E5B140025O0028A640025O00188E40025O00C07140025O00BEAC40025O00D07B40030F3O0048616E646C65412O666C6963746564030D3O00436C65616E736553706972697403163O00436C65616E73655370697269744D6F7573656F766572026O004440025O0032B140025O00B8AB40025O00CC9640025O00688A40025O0032AC40025O00B4A340025O00088940025O0086AC40030B3O005472656D6F72546F74656D026O003E40025O0078AD40025O00F08D40025O00688840025O00308540025O00A4AB40025O009CAC40025O0061B240025O009EA640025O0052AE40025O00508140025O00A89C40025O00B2AA4003143O00506F69736F6E436C65616E73696E67546F74656D025O00A06940025O00D08040025O00949A40025O0002A540025O00AAA04003113O0048616E646C65496E636F72706F7265616C2O033O00486578030C3O004865784D6F7573654F766572027O0040025O001AA540025O0056AF40025O008C9840025O0022A840025O00907D40025O00E6A64003053O00466F637573025O002EA840025O0046A040025O00E49440025O0078A440025O009AA940025O00C09B40025O00DC9840025O00C3B140025O00089540025O00849A40025O0010AF40025O00789740025O0064A640025O00E06C40025O00804B40025O00EDB140025O00208340030C3O00E9ED50D5A7D8ECFEEA47D3B603073O009EAE9F35B4D3BD030B3O004973417661696C61626C65030C3O0075EFE8DC63B040CDF8CF70B003063O00D5329D8DBD1703073O004973526561647903093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030C3O00477265617465725075726765030E3O0049735370652O6C496E52616E6765025O0028A340025O0090874003143O00F93481A166A1EC1994B560A3FB6680A17FA5F92303063O00C49E46E4C012026O000840025O00D07A40025O00A8834003053O007A4A0349DC03053O00B92A3F712E025O00249B40025O004EB24003053O005075726765030C3O00C4C8333E1E94D920341AD3D803053O007BB4BD4159030D3O00546172676574497356616C6964026O004E40025O00ECA840025O0068AB40025O00F08240025O0028B240025O00ACA540025O0030A440025O0074B340025O00888040025O00C49D40025O0072AF40025O00C05440025O0060A640025O00EC9040025O00B8B040025O00509640025O0078B24003043O00502O6F6C03173O0020B603F0E0D01FAB4CCFA9D817B509C8A1C417BC18B4E903063O00B670D96C9CC0025O00C08E40025O00F09740025O004FB040025O0032A540025O00049D40025O00AAA440025O00BAAF40025O00BEAA40025O0066AA40025O00AAA640025O001AB240025O00188040025O001C9140025O00FCA740025O00ACAF40025O00A89E40030E3O0004C256D17B32C24B9D1A3BC8119403053O005B54AD39BD025O00B88240025O00D09540025O0040A740025O00449E40025O00C6A340025O0054AF4003103O00720497DC24D9586F128ACF22D24E4F1603073O002B3C65E3A956BC030A3O0049734361737461626C6503103O004E61747572657353776966746E652O73025O00DAB240025O00DCAA4003193O007EC9C5AA48C9AA0863DFD8B94EC2BC246388DCBE53C2F9662203083O005710A8B1DF3AACD9030F3O0048616E646C65445053506F74696F6E03063O0042752O665570030E3O00417363656E64616E636542752O66025O0046AE40025O000C9840025O0052A740025O0036A640025O0030AC40025O002FB340025O0004A640025O005EA940025O00507A40025O00806F40025O0020AB40025O00C05540025O002C9F40025O00B89840025O007C9C40025O00DAAF40025O001CA840025O0080544003093O00E080FFEB8DE499E2FD03053O00E9A2EC9084030A3O0093D7FD1FB7F25EBCC7FB03073O003FD2A49E7AD996030A3O0012D8F5E947FC32C5F5E903063O009853AB968C29030F3O00432O6F6C646F776E52656D61696E73026O004940025O00C2B040025O00DEAB4003093O00426C2O6F644675727903113O0080E98C3CD0240E97F79A73D91A018CA5D103073O0068E285E353B47B030A3O00210E3143061928590D0C03043O0030636B43030A3O00FFB57ED5237FDFA87ED503063O001BBEC61DB04D025O00189E40025O003CB340030A3O004265727365726B696E6703113O00ED4EEF27AC5CE442F333E943EE42F374FD03063O002E8F2B9D54C9025O00609640025O0009B240025O008C9240025O005CB140025O00608C40025O00BC9440025O002CA340025O00F0944003093O002O7144C75D1FC7587C03073O00A8371836A23F73030A3O0036E92385DCCA16F4238503063O00AE779A40E0B2030A3O000B6DC67E0BA31BEA297B03083O00844A1EA51B65C77A03093O0046697265626C2O6F64025O0058A84003103O0029EEEDA2A5B9BB20E3BFAAA6BCBA6FB103073O00D44F879F2OC7D5030D3O0058AEB6424FC30A78AC964650DB03073O007819C0D5273CB7030A3O0039533C4D16443E461B4503043O002878205F030A3O001BB83A7FA11B3BA53A7F03063O007F5ACB591ACF025O00EEAB40025O0004A240030D3O00416E6365737472616C43612O6C025O003EB240025O00E49F4003153O00DC3BACCE1AE9CF34A3F40AFCD139EFC608F4D375F703063O009DBD55CFAB69025O00FC9840025O007AB340025O00107E40025O00909940025O00DCAB40025O00E3B040025O00808C40025O00B2A040030B3O00E4A0DFBA05F2B3D1B608D503053O0063A6C1B8D5030A3O00F7A483BE028ED7B983BE03063O00EAB6D7E0DB6C025O000C9B40025O0026A240025O009C9640025O0064A440030B3O004261676F66547269636B7303153O00C280BC0ACF878421D288B83ED3C1B634C98FFB649003043O0055A0E1DB025O0086A640025O00808A40025O00D2AD40025O00188F40025O00AC9640025O0076AA40025O006DB340026O009440025O0095B240025O0057B040025O0030B240025O000CA140025O0026AE40025O00F0A940025O0034AA40025O0036A740025O0042A840025O00ECA540026O00A740025O00709240025O0008B340025O00F8A040025O00989F40025O00EAA140025O002EAB40025O00609440025O0016A5400049042O001255012O00013O0026C03O0005000100020004B03O00050001002E50010400C7000100030004B03O00C700010012552O0100013O000E372O01000A000100010004B03O000A0001002E59000500C2000100060004B03O00C20001001255010200013O002E5900080013000100070004B03O00130001002E50010900130001000A0004B03O001300010026D500020013000100020004B03O001300010012552O0100023O0004B03O00C20001000E372O010017000100020004B03O00170001002E50010B000B0001000C0004B03O000B00012O00CD00035O00066B010300A300013O0004B03O00A30001001255010300014O00C9000400043O000E372O010020000100030004B03O00200001002E59000E001C0001000D0004B03O001C0001001255010400013O002E50011000250001000F0004B03O00250001000E372O010027000100040004B03O00270001002E5001120086000100110004B03O00860001001255010500013O0026D50005007F000100010004B03O007F0001001255010600013O0026D50006002F000100020004B03O002F0001001255010500023O0004B03O007F0001002E500114002B000100130004B03O002B00010026D50006002B000100010004B03O002B00012O00CD000700013O0006CC00070038000100010004B03O00380001002E5001150055000100160004B03O00550001001255010700014O00C9000800083O0026C00007003E000100010004B03O003E0001002E00011700FEFF2O00180004B03O003A0001001255010800013O0026C000080043000100010004B03O00430001002E500119003F0001001A0004B03O003F00012O00CD000900033O00207300090009001B4O000A00043O00202O000A000A001C4O000B00053O00202O000B000B001D00122O000C001E6O0009000C00024O000900026O000900023O00062O0009005500013O0004B03O005500012O00CD000900024O0052000900023O0004B03O005500010004B03O003F00010004B03O005500010004B03O003A00012O00CD000700063O00066B0107007D00013O0004B03O007D0001001255010700014O00C9000800083O0026C000070060000100010004B03O00600001002E25011F0060000100200004B03O00600001002E500121005A000100220004B03O005A0001001255010800013O002E5001240061000100230004B03O00610001000E372O010067000100080004B03O00670001002E00012500FCFF2O00260004B03O006100012O00CD000900033O00203201090009001B4O000A00043O00202O000A000A00274O000B00043O00202O000B000B002700122O000C00286O0009000C00024O000900023O002E2O002A0075000100290004B03O007500012O00CD000900023O0006CC00090077000100010004B03O00770001002E59002B007D0001002C0004B03O007D00012O00CD000900024O0052000900023O0004B03O007D00010004B03O006100010004B03O007D00010004B03O005A0001001255010600023O0004B03O002B0001002E59002D00280001002E0004B03O002800010026D500050028000100020004B03O00280001001255010400023O0004B03O008600010004B03O00280001002E59003000210001002F0004B03O002100010026D500040021000100020004B03O002100012O00CD000500073O0006CC00050091000100010004B03O00910001002E6101310091000100320004B03O00910001002E59003400A3000100330004B03O00A300012O00CD000500033O00207300050005001B4O000600043O00202O0006000600354O000700043O00202O00070007003500122O000800286O0005000800024O000500026O000500023O00062O000500A300013O0004B03O00A300012O00CD000500024O0052000500023O0004B03O00A300010004B03O002100010004B03O00A300010004B03O001C0001002E000136001D000100360004B03O00C000012O00CD000300083O00066B010300C000013O0004B03O00C00001001255010300013O002E50013700A9000100380004B03O00A90001002E59003A00A9000100390004B03O00A900010026D5000300A9000100010004B03O00A900012O00CD000400033O00200800040004003B4O000500043O00202O00050005003C4O000600053O00202O00060006003D00122O000700286O000800016O0004000800024O000400026O000400023O00066B010400C000013O0004B03O00C000012O00CD000400024O0052000400023O0004B03O00C000010004B03O00A90001001255010200023O0004B03O000B00010026D500010006000100020004B03O00060001001255012O003E3O0004B03O00C700010004B03O000600010026D53O00522O01003E0004B03O00522O010012552O0100014O00C9000200023O002E59003F00CB000100400004B03O00CB00010026D5000100CB000100010004B03O00CB0001001255010200013O0026C0000200D4000100010004B03O00D40001002E590042004B2O0100410004B03O004B2O01002E50014300082O0100440004B03O00082O01001239010300453O00066B010300082O013O0004B03O00082O01002E59004700082O0100460004B03O00082O012O00CD000300093O0006CC000300E0000100010004B03O00E00001002E50014900082O0100480004B03O00082O01001255010300014O00C9000400053O002E59004B00FE0001004A0004B03O00FE00010026D5000300FE000100020004B03O00FE00010026C0000400EA000100010004B03O00EA0001002E00014C00FEFF2O004D0004B03O00E60001001255010500013O002E59004E00EB0001004F0004B03O00EB00010026D5000500EB000100010004B03O00EB00012O00CD0006000A4O005C0106000100022O0006010600024O00CD000600023O0006CC000600F7000100010004B03O00F70001002E59005000082O0100510004B03O00082O012O00CD000600024O0052000600023O0004B03O00082O010004B03O00EB00010004B03O00082O010004B03O00E600010004B03O00082O01002E59005300E2000100520004B03O00E20001002E00015400E2FF2O00540004B03O00E200010026D5000300E2000100010004B03O00E20001001255010400014O00C9000500053O001255010300023O0004B03O00E20001002E500156004A2O0100550004B03O004A2O012O00CD000300044O006E0004000B3O00122O000500573O00122O000600586O0004000600024O00030003000400202O0003000300594O00030002000200062O0003004A2O013O0004B03O004A2O012O00CD0003000C3O00066B0103004A2O013O0004B03O004A2O012O00CD000300044O006E0004000B3O00122O0005005A3O00122O0006005B6O0004000600024O00030003000400202O00030003005C4O00030002000200062O0003004A2O013O0004B03O004A2O012O00CD0003000D3O00066B0103004A2O013O0004B03O004A2O012O00CD0003000E3O00066B0103004A2O013O0004B03O004A2O012O00CD0003000F3O0020BC00030003005D2O00210103000200020006CC0003004A2O0100010004B03O004A2O012O00CD0003000F3O0020BC00030003005E2O00210103000200020006CC0003004A2O0100010004B03O004A2O012O00CD000300033O00209200030003005F2O00CD000400104O002101030002000200066B0103004A2O013O0004B03O004A2O012O00CD000300114O00BD000400043O00202O0004000400604O000500103O00202O0005000500614O000700043O00202O0007000700604O0005000700024O000500056O00030005000200062O000300452O0100010004B03O00452O01002E500162004A2O0100630004B03O004A2O012O00CD0003000B3O001255010400643O001255010500654O008B000300054O00FB00035O001255010200023O000E47010200D0000100020004B03O00D00001001255012O00663O0004B03O00522O010004B03O00D000010004B03O00522O010004B03O00CB0001002E5900670025040100680004B03O002504010026D53O0025040100660004B03O002504012O00CD000100044O006E0002000B3O00122O000300693O00122O0004006A6O0002000400024O00010001000200202O00010001005C4O00010002000200062O000100792O013O0004B03O00792O012O00CD0001000C3O00066B2O0100792O013O0004B03O00792O012O00CD0001000D3O00066B2O0100792O013O0004B03O00792O012O00CD0001000E3O00066B2O0100792O013O0004B03O00792O012O00CD0001000F3O0020BC00010001005D2O00212O01000200020006CC000100792O0100010004B03O00792O012O00CD0001000F3O0020BC00010001005E2O00212O01000200020006CC000100792O0100010004B03O00792O012O00CD000100033O00209200010001005F2O00CD000200104O00212O01000200020006CC0001007B2O0100010004B03O007B2O01002E50016C008C2O01006B0004B03O008C2O012O00CD000100114O0009010200043O00202O00020002006D4O000300103O00202O0003000300614O000500043O00202O00050005006D4O0003000500024O000300036O00010003000200062O0001008C2O013O0004B03O008C2O012O00CD0001000B3O0012550102006E3O0012550103006F4O008B000100034O00FB00016O00CD000100033O0020920001000100702O005C2O010001000200066B2O01009B2O013O0004B03O009B2O012O00CD0001000F3O0020BC00010001005E2O00212O01000200020006CC0001009B2O0100010004B03O009B2O012O00CD0001000F3O0020BC00010001005D2O00212O010002000200066B2O01009D2O013O0004B03O009D2O01002E5001720048040100710004B03O004804010012552O0100014O00C9000200043O002E5001740019040100730004B03O001904010026D500010019040100020004B03O001904012O00C9000400043O0026D5000200B72O0100010004B03O00B72O01001255010500013O002E50017600B02O0100750004B03O00B02O01002E59007700B02O0100780004B03O00B02O01000E472O0100B02O0100050004B03O00B02O01001255010300014O00C9000400043O001255010500023O002E00017900F7FF2O00790004B03O00A72O01000E47010200A72O0100050004B03O00A72O01001255010200023O0004B03O00B72O010004B03O00A72O010026C0000200BB2O0100020004B03O00BB2O01002E00017A00EBFF2O007B0004B03O00A42O01002E50017C00F52O01007D0004B03O00F52O010026C0000300C12O0100660004B03O00C12O01002E59007F00F52O01007E0004B03O00F52O01001255010500014O00C9000600063O0026D5000500C32O0100010004B03O00C32O01001255010600013O0026D5000600D62O0100020004B03O00D62O01002E5001800048040100810004B03O004804012O00CD000700114O00CD000800043O0020920008000800822O002101070002000200066B0107004804013O0004B03O004804012O00CD0007000B3O0012D9000800833O00122O000900846O000700096O00075O00044O00480401000E472O0100C62O0100060004B03O00C62O01001255010700013O0026D5000700E82O0100010004B03O00E82O012O00CD000800124O005C0108000100022O0006010800023O002E50018500E32O0100860004B03O00E32O012O00CD000800023O0006CC000800E52O0100010004B03O00E52O01002E59008700E72O0100880004B03O00E72O012O00CD000800024O0052000800023O001255010700023O000E37010200EE2O0100070004B03O00EE2O01002EE9008A00EE2O0100890004B03O00EE2O01002E50018B00D92O01008C0004B03O00D92O01001255010600023O0004B03O00C62O010004B03O00D92O010004B03O00C62O010004B03O004804010004B03O00C32O010004B03O004804010026D5000300390201003E0004B03O00390201001255010500013O0026D5000500FC2O0100020004B03O00FC2O01001255010300663O0004B03O00390201002E50018E00F82O01008D0004B03O00F82O010026C00005002O020100010004B03O002O0201002E50018F00F82O0100900004B03O00F82O01001255010600013O002E5001910031020100920004B03O00310201000E472O010031020100060004B03O0031020100066B0104000A02013O0004B03O000A02012O0052000400024O00CD000700133O00066B0107003002013O0004B03O003002012O00CD000700143O000E1A003E0030020100070004B03O003002012O00CD000700153O000E1A003E0030020100070004B03O00300201001255010700013O0026C000070018020100020004B03O00180201002E000193000E000100940004B03O002402012O00CD000800114O00CD000900043O0020920009000900822O002101080002000200066B0108003002013O0004B03O003002012O00CD0008000B3O0012D9000900953O00122O000A00966O0008000A6O00085O00044O003002010026D500070014020100010004B03O001402012O00CD000800164O005C0108000100022O0006010800024O00CD000800023O00066B0108002E02013O0004B03O002E02012O00CD000800024O0052000800023O001255010700023O0004B03O00140201001255010600023O002E5001970003020100980004B03O000302010026D500060003020100020004B03O00030201001255010500023O0004B03O00F82O010004B03O000302010004B03O00F82O010026C00003003D020100020004B03O003D0201002E50019900630201009A0004B03O00630201002E59009B00590201009C0004B03O005902012O00CD000500044O006E0006000B3O00122O0007009D3O00122O0008009E6O0006000800024O00050005000600202O00050005009F4O00050002000200062O0005005902013O0004B03O005902012O00CD000500173O00066B0105005902013O0004B03O005902012O00CD000500114O00CD000600043O0020920006000600A02O00210105000200020006CC00050054020100010004B03O00540201002E5900A10059020100A20004B03O005902012O00CD0005000B3O001255010600A33O001255010700A44O008B000500074O00FB00056O00CD000500033O00205B0105000500A54O0006000F3O00202O0006000600A64O000800043O00202O0008000800A74O000600086O00053O00024O000400053O00122O0003003E3O0026D5000300BB2O0100010004B03O00BB2O01001255010500014O00C9000600063O0026D500050067020100010004B03O00670201001255010600013O002E5001A9006E020100A80004B03O006E02010026C000060070020100010004B03O00700201002E0001AA00972O0100AB0004B03O000504012O00CD000700184O00CD000800193O00061C00070080020100080004B03O008002012O00CD0007001A3O00066B0107008002013O0004B03O008002012O00CD0007001B3O00066B0107007D02013O0004B03O007D02012O00CD0007001C3O0006CC00070082020100010004B03O008202012O00CD0007001B3O00066B0107008202013O0004B03O00820201002E5001AD00B3030100AC0004B03O00B30301001255010700014O00C9000800083O0026C000070088020100010004B03O00880201002E5900AF0084020100AE0004B03O00840201001255010800013O002E5900B100F8020100B00004B03O00F802010026C00008008F020100010004B03O008F0201002E5900B200F8020100B30004B03O00F80201001255010900013O0026C000090094020100020004B03O00940201002E5001B40096020100B50004B03O00960201001255010800023O0004B03O00F802010026C00009009A020100010004B03O009A0201002E5001B70090020100B60004B03O00900201002E5001B900CE020100B80004B03O00CE02012O00CD000A00044O006E000B000B3O00122O000C00BA3O00122O000D00BB6O000B000D00024O000A000A000B00202O000A000A009F4O000A0002000200062O000A00CE02013O0004B03O00CE02012O00CD000A00044O006E000B000B3O00122O000C00BC3O00122O000D00BD6O000B000D00024O000A000A000B00202O000A000A00594O000A0002000200062O000A00C102013O0004B03O00C102012O00CD000A000F3O00200D000A000A00A64O000C00043O00202O000C000C00A74O000A000C000200062O000A00C1020100010004B03O00C102012O00CD000A00044O004C010B000B3O00122O000C00BE3O00122O000D00BF6O000B000D00024O000A000A000B00202O000A000A00C04O000A00020002000E2O00C100CE0201000A0004B03O00CE0201002E5001C300CE020100C20004B03O00CE02012O00CD000A00114O00CD000B00043O002092000B000B00C42O0021010A0002000200066B010A00CE02013O0004B03O00CE02012O00CD000A000B3O001255010B00C53O001255010C00C64O008B000A000C4O00FB000A6O00CD000A00044O006E000B000B3O00122O000C00C73O00122O000D00C86O000B000D00024O000A000A000B00202O000A000A009F4O000A0002000200062O000A00F602013O0004B03O00F602012O00CD000A00044O006E000B000B3O00122O000C00C93O00122O000D00CA6O000B000D00024O000A000A000B00202O000A000A00594O000A0002000200062O000A00E902013O0004B03O00E902012O00CD000A000F3O0020B4000A000A00A64O000C00043O00202O000C000C00A74O000A000C000200062O000A00F602013O0004B03O00F60201002E5900CB00F6020100CC0004B03O00F602012O00CD000A00114O00CD000B00043O002092000B000B00CD2O0021010A0002000200066B010A00F602013O0004B03O00F602012O00CD000A000B3O001255010B00CE3O001255010C00CF4O008B000A000C4O00FB000A5O001255010900023O0004B03O00900201002E0001D00087000100D00004B03O007F03010026C0000800FE020100020004B03O00FE0201002E5900D1007F030100D20004B03O007F0301001255010900013O002E0001D30077000100D30004B03O007603010026D500090076030100010004B03O00760301001255010A00013O0026C0000A0008030100010004B03O00080301002E5001D50071030100D40004B03O00710301002E5900D7003C030100D60004B03O003C03012O00CD000B00044O006E000C000B3O00122O000D00D83O00122O000E00D96O000C000E00024O000B000B000C00202O000B000B009F4O000B0002000200062O000B003C03013O0004B03O003C03012O00CD000B00044O006E000C000B3O00122O000D00DA3O00122O000E00DB6O000C000E00024O000B000B000C00202O000B000B00594O000B0002000200062O000B002F03013O0004B03O002F03012O00CD000B000F3O00200D000B000B00A64O000D00043O00202O000D000D00A74O000B000D000200062O000B002F030100010004B03O002F03012O00CD000B00044O004C010C000B3O00122O000D00DC3O00122O000E00DD6O000C000E00024O000B000B000C00202O000B000B00C04O000B00020002000E2O00C1003C0301000B0004B03O003C03012O00CD000B00114O00CD000C00043O002092000C000C00DE2O0021010B000200020006CC000B0037030100010004B03O00370301002E5900DF003C030100320004B03O003C03012O00CD000B000B3O001255010C00E03O001255010D00E14O008B000B000D4O00FB000B6O00CD000B00044O006E000C000B3O00122O000D00E23O00122O000E00E36O000C000E00024O000B000B000C00202O000B000B009F4O000B0002000200062O000B007003013O0004B03O007003012O00CD000B00044O006E000C000B3O00122O000D00E43O00122O000E00E56O000C000E00024O000B000B000C00202O000B000B00594O000B0002000200062O000B006103013O0004B03O006103012O00CD000B000F3O00200D000B000B00A64O000D00043O00202O000D000D00A74O000B000D000200062O000B0061030100010004B03O006103012O00CD000B00044O004C010C000B3O00122O000D00E63O00122O000E00E76O000C000E00024O000B000B000C00202O000B000B00C04O000B00020002000E2O00C100700301000B0004B03O00700301002E5900E90070030100E80004B03O007003012O00CD000B00114O00CD000C00043O002092000C000C00EA2O0021010B000200020006CC000B006B030100010004B03O006B0301002E5900EB0070030100EC0004B03O007003012O00CD000B000B3O001255010C00ED3O001255010D00EE4O008B000B000D4O00FB000B5O001255010A00023O0026D5000A0004030100020004B03O00040301001255010900023O0004B03O007603010004B03O00040301002E5900EF007A030100F00004B03O007A03010026C00009007C030100020004B03O007C0301002E0001F10085FF2O00F20004B03O00FF02010012550108003E3O0004B03O007F03010004B03O00FF0201002E5900F30089020100F40004B03O008902010026D5000800890201003E0004B03O00890201002E5900F500A0030100F60004B03O00A003012O00CD000900044O006E000A000B3O00122O000B00F73O00122O000C00F86O000A000C00024O00090009000A00202O00090009009F4O00090002000200062O000900A003013O0004B03O00A003012O00CD000900044O006E000A000B3O00122O000B00F93O00122O000C00FA6O000A000C00024O00090009000A00202O0009000900594O00090002000200062O000900A203013O0004B03O00A203012O00CD0009000F3O00200D0009000900A64O000B00043O00202O000B000B00A74O0009000B000200062O000900A2030100010004B03O00A20301002E5900FC00B3030100FB0004B03O00B30301002E5900FD00B3030100FE0004B03O00B303012O00CD000900114O00CD000A00043O002092000A000A00FF2O002101090002000200066B010900B303013O0004B03O00B303012O00CD0009000B3O0012D9000A2O00012O00122O000B002O015O0009000B6O00095O00044O00B303010004B03O008902010004B03O00B303010004B03O0084020100125501070002012O00125501080003012O00061C000800BC030100070004B03O00BC03012O00CD000700184O00CD000800193O0006DE000800BC030100070004B03O00BC03010004B03O002O040100125501070004012O00125501080005012O00061C0008002O040100070004B03O002O04012O00CD0007001D3O00066B0107002O04013O0004B03O002O04012O00CD0007001C3O00066B010700C903013O0004B03O00C903012O00CD0007001E3O0006CC000700CC030100010004B03O00CC03012O00CD0007001E3O0006CC0007002O040100010004B03O002O0401001255010700014O00C9000800093O001255010A00013O0006A8000700D50301000A0004B03O00D50301001255010A0006012O001255010B0007012O0006DE000B00D80301000A0004B03O00D80301001255010800014O00C9000900093O001255010700023O001255010A0008012O001255010B0009012O0006DE000B00CE0301000A0004B03O00CE0301001255010A00023O000652010700CE0301000A0004B03O00CE0301001255010A00013O0006A8000A00EA030100080004B03O00EA0301001255010A000A012O001255010B000B012O00067F000A00EA0301000B0004B03O00EA0301001255010A000C012O001255010B000D012O0006DE000A00DF0301000B0004B03O00DF0301001255010900013O001255010A00013O0006A8000A00F2030100090004B03O00F20301001255010A000E012O001255010B000F012O00061C000A00EB0301000B0004B03O00EB03012O00CD000A001F4O005C010A000100022O0006010A00024O00CD000A00023O0006CC000A00FC030100010004B03O00FC0301001255010A0010012O001255010B0011012O000652010A002O0401000B0004B03O002O04012O00CD000A00024O0052000A00023O0004B03O002O04010004B03O00EB03010004B03O002O04010004B03O00DF03010004B03O002O04010004B03O00CE0301001255010600023O001255010700023O0006A800060010040100070004B03O0010040100125501070012012O00125501080013012O00067F00070010040100080004B03O0010040100125501070014012O00125501080015012O00061C0007006A020100080004B03O006A0201001255010300023O0004B03O00BB2O010004B03O006A02010004B03O00BB2O010004B03O006702010004B03O00BB2O010004B03O004804010004B03O00A42O010004B03O00480401001255010500013O0006A800010020040100050004B03O0020040100125501050016012O00125501060017012O0006DE0005009F2O0100060004B03O009F2O01001255010200014O00C9000300033O0012552O0100023O0004B03O009F2O010004B03O004804010012552O010018012O00125501020018012O0006522O010001000100020004B03O000100010012552O0100013O0006522O01000100013O0004B03O000100010012552O0100013O001255010200013O0006522O01003D040100020004B03O003D04012O00CD000200204O00F30002000100024O000200023O00122O00020019012O00122O0003001A012O00062O0002003C040100030004B03O003C04012O00CD000200023O00066B0102003C04013O0004B03O003C04012O00CD000200024O0052000200023O0012552O0100023O001255010200023O0006A800010044040100020004B03O004404010012550102001B012O0012550103001C012O00061C0003002D040100020004B03O002D0401001255012O00023O0004B03O000100010004B03O002D04010004B03O000100012O00013O00017O009B3O00028O00025O0040AB40025O00649840025O001C9C40025O00A8B040026O000840026O00F03F025O00E88740025O00188940030C3O004570696353652O74696E677303083O00440DED320677186403073O007F176899466F1903113O001C14A39F3925BABC1B03AFAE271BB6A50C03083O00D36967C6CF4B4CD7026O001040025O0028A540025O003AA24003083O00F23D1723C836042403043O0057A1586303103O00072OEAE0BED72B06F7E6C2B0F22C1EED03073O004372998FACD7B003083O008DA7FA1AB7ACE91D03043O006EDEC28E03133O0002CA1E8753B502CB1EBA61B61EDF0FA757B20403063O00C177B97BC932026O00204003083O0022AC5562C91FAE5203053O00A071C9211603153O00C74CA3B5A4A6D15DBCA2BB9ADD4CA48AA0A3DD7B8803063O00CDB438CCC7C903083O00990D5CFB82A40F5B03053O00EBCA68288F03113O0018981E9A058A12B701821CB1198512B70A03043O00D96DEB7B03083O00148C6A4279DECAAE03083O00DD47E91E3610B0AD030D3O0021EF5B9A35EE4AB725E95FB43103043O00DF549C3E03083O00E5F9F6C9BE35D1EF03063O005BB69C82BDD7030D3O006B60A9707F61B85D6D7BA3567503043O00351E13CC025O00C07A40025O00788E40025O00D88840025O00589C40025O00D6A740025O00C0A34003083O00C2AFCC4D8C2EAC4E03083O003D91CAB839E540CB030D3O0049418C614E5D9A536F5A86445703043O00273C32E9027O004003083O00CAE56490AEF7E76303053O00C7998010E403113O00C439E03CABD427E017B3D026C715A6C23E03053O00C7B14A8579030D3O00557365466C616D6553686F636B03083O008BCCA8EA3EC82DAB03073O004AD8A9DC9E57A6030D3O00FD30160A56E92E161F52E7201803053O003A8843734C025O00A0A440025O006C9940025O00F07040025O00FAA940026O00184003083O00FC8C6100C687720703043O0074AFE91503113O002OEBBB75CF3E2DF3DDB243D63431EAF9B203073O005F9E98DE26BB5103083O00CBB821A6AAC6FFAE03063O00A898DD55D2C303103O00AACDF682A5DAF489A8DBC28EBF2OD6A303043O00E7CBBE9503083O00FE38F7E5B5FB1CDE03073O007BAD5D8391DC9503163O001ACDFC347DFD3BC5EA2C75CD19D0E82C43F002CCCE0503063O009976A48D4114026O001C40025O007FB040025O00A2A640025O00C2AB40025O004C9340025O0010AA40025O0018A04003083O00DD3792F6FE0EE92103063O00608E52E6829703133O0049B95D47C1E24ABD4A4CF0EF43874656ECCD6B03063O008E2FD02F228403083O00C5BB10162O52F1AD03063O003C96DE64623B03143O0056285844D69F3D40315258CFBB3D7235435EF89E03073O0051255C3736BBDA03083O003341B923880E43BE03053O00E16024CD5703183O00F9B44B74735D0DE0A72O4E7D590CDEAF5671514607E0856603073O006989C622191C2F026O001440025O00DAAB40025O00405140025O00707E40025O002O7040025O00A8A040025O00A0884003083O00DEEAD40CE4E1C70B03043O00788D8FA0030D3O0055BFB37353AFB35C44ADB8514503043O003220CCD603083O00B542216DBA1F815403063O0071E6275519D303133O00CBA803C42EDABE42DA9607EF2ACA9F44CABE0B03083O002BBEDB668847ABCB025O00EC9B40025O00909240025O00A09740025O00A8A340025O008EB140025O004AAF4003083O00117B244D2B70374A03043O0039421E5003103O003CCBA5338D2BF1A125DDAD108A2DF58803083O00E449B8C075E45994025O00509840025O00AAA840025O00A0AA40025O00A0AE40025O00F49F40025O0022AB4003083O002936B7388B26B5B003083O00C37A53C34CE248D2030A3O00F1C73ED722E1F22EEC3803053O004184B45B9E03083O003679C53A0C72D63D03043O004E651CB1030B3O0030A7E57D24A2E17320B5ED03043O003145D48003083O002409C4E6E8190BC303053O0081776CB092030C3O0029DC02E124181D1EDA15DE3103073O007C5CAF67AD456E03083O000BE1FAA5FA443FDF03083O00AC58848ED1932A5803103O009299C93A33F4AE8884E90335FDBF899E03073O00DEE7EAAC6D5695025O00B88A40025O00F88E4003083O00FDA2A4FB7702BDA503083O00D6AEC7D08F1E6CDA030E3O0004970E99B159CA441A810EBAA04403083O002971E46BCAC536B803083O0049882C4873833F4F03043O003C1AED5803103O00CD3971D2A1CC2F79EFADEA2F77E7A2D403053O00CEB84A148600D6012O001255012O00014O00C9000100013O002E5001030002000100020004B03O000200010026D53O0002000100010004B03O000200010012552O0100013O002E590004004A000100050004B03O004A00010026D50001004A000100060004B03O004A0001001255010200014O00C9000300033O0026D50002000D000100010004B03O000D0001001255010300013O0026C000030014000100070004B03O00140001002E5001090022000100080004B03O002200010012390104000A4O00C4000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O00045O00122O0001000F3O00044O004A00010026D500030010000100010004B03O00100001001255010400013O002E590011002B000100100004B03O002B00010026D50004002B000100070004B03O002B0001001255010300073O0004B03O001000010026D500040025000100010004B03O002500010012390105000A4O00D1000600013O00122O000700123O00122O000800136O0006000800024O0005000500064O000600013O00122O000700143O00122O000800156O0006000800024O0005000500064O000500023O00122O0005000A6O000600013O00122O000700163O00122O000800176O0006000800024O0005000500064O000600013O00122O000700183O00122O000800196O0006000800024O0005000500064O000500033O00122O000400073O0004B03O002500010004B03O001000010004B03O004A00010004B03O000D00010026D5000100590001001A0004B03O005900010012390102000A4O00C5000300013O00122O0004001B3O00122O0005001C6O0003000500024O0002000200034O000300013O00122O0004001D3O00122O0005001E6O0003000500024O0002000200034O000200043O00044O00D52O010026D500010080000100010004B03O008000010012390102000A4O0002000300013O00122O0004001F3O00122O000500206O0003000500024O0002000200034O000300013O00122O000400213O00122O000500226O0003000500024O0002000200034O000200053O00122O0002000A6O000300013O00122O000400233O00122O000500246O0003000500024O0002000200034O000300013O00122O000400253O00122O000500266O0003000500024O0002000200034O000200063O00122O0002000A6O000300013O00122O000400273O00122O000500286O0003000500024O0002000200034O000300013O00122O000400293O00122O0005002A6O0003000500024O0002000200034O000200073O00122O000100073O0026C000010084000100070004B03O00840001002E00012B003D0001002C0004B03O00BF0001001255010200013O0026C00002008B000100070004B03O008B0001002EE9002E008B0001002D0004B03O008B0001002E59002F0099000100300004B03O009900010012390103000A4O00C4000400013O00122O000500313O00122O000600326O0004000600024O0003000300044O000400013O00122O000500333O00122O000600346O0004000600024O0003000300044O000300083O00122O000100353O00044O00BF0001000E472O010085000100020004B03O00850001001255010300013O0026D5000300B7000100010004B03O00B700010012390104000A4O004C000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000500013O00122O000600383O00122O000700396O0005000700024O0004000400052O00A1000400093O00122O0004000A6O000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400054O000500013O00122O0006003D3O00122O0007003E4O00620005000700022O00380004000400050012200104003A3O001255010300073O000E37010700BB000100030004B03O00BB0001002E00013F00E3FF2O00400004B03O009C0001001255010200073O0004B03O008500010004B03O009C00010004B03O00850001002E59004100E8000100420004B03O00E800010026D5000100E8000100430004B03O00E800010012390102000A4O0002000300013O00122O000400443O00122O000500456O0003000500024O0002000200034O000300013O00122O000400463O00122O000500476O0003000500024O0002000200034O0002000A3O00122O0002000A6O000300013O00122O000400483O00122O000500496O0003000500024O0002000200034O000300013O00122O0004004A3O00122O0005004B6O0003000500024O0002000200034O0002000B3O00122O0002000A6O000300013O00122O0004004C3O00122O0005004D6O0003000500024O0002000200034O000300013O00122O0004004E3O00122O0005004F6O0003000500024O0002000200034O0002000C3O00122O000100503O002E500152001D2O0100510004B03O001D2O010026C0000100EE000100500004B03O00EE0001002E590053001D2O0100540004B03O001D2O01001255010200013O000E372O0100F3000100020004B03O00F30001002E500155000C2O0100560004B03O000C2O010012390103000A4O00D1000400013O00122O000500573O00122O000600586O0004000600024O0003000300044O000400013O00122O000500593O00122O0006005A6O0004000600024O0003000300044O0003000D3O00122O0003000A6O000400013O00122O0005005B3O00122O0006005C6O0004000600024O0003000300044O000400013O00122O0005005D3O00122O0006005E6O0004000600024O0003000300044O0003000E3O00122O000200073O0026D5000200EF000100070004B03O00EF00010012390103000A4O00C4000400013O00122O0005005F3O00122O000600606O0004000600024O0003000300044O000400013O00122O000500613O00122O000600626O0004000600024O0003000300044O0003000F3O00122O0001001A3O00044O001D2O010004B03O00EF00010026C0000100212O0100630004B03O00212O01002E0001640047000100650004B03O00662O01001255010200014O00C9000300033O0026C0000200272O0100010004B03O00272O01002E50016600232O0100670004B03O00232O01001255010300013O0026D5000300512O0100010004B03O00512O01001255010400013O0026C00004002F2O0100010004B03O002F2O01002E59006800482O0100690004B03O00482O010012390105000A4O00D1000600013O00122O0007006A3O00122O0008006B6O0006000800024O0005000500064O000600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000500103O00122O0005000A6O000600013O00122O0007006E3O00122O0008006F6O0006000800024O0005000500064O000600013O00122O000700703O00122O000800716O0006000800024O0005000500064O000500113O00122O000400073O002E500173004C2O0100720004B03O004C2O010026C00004004E2O0100070004B03O004E2O01002E500175002B2O0100740004B03O002B2O01001255010300073O0004B03O00512O010004B03O002B2O01002E59007700282O0100760004B03O00282O010026D5000300282O0100070004B03O00282O010012390104000A4O00C4000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000500013O00122O0006007A3O00122O0007007B6O0005000700024O0004000400054O000400123O00122O000100433O00044O00662O010004B03O00282O010004B03O00662O010004B03O00232O01002E50017C006A2O01007D0004B03O006A2O01000E370135006C2O0100010004B03O006C2O01002E59007F00A12O01007E0004B03O00A12O01001255010200014O00C9000300033O002E500180006E2O0100810004B03O006E2O010026D50002006E2O0100010004B03O006E2O01001255010300013O0026D50003008E2O0100010004B03O008E2O010012390104000A4O00D1000500013O00122O000600823O00122O000700836O0005000700024O0004000400054O000500013O00122O000600843O00122O000700856O0005000700024O0004000400054O000400133O00122O0004000A6O000500013O00122O000600863O00122O000700876O0005000700024O0004000400054O000500013O00122O000600883O00122O000700896O0005000700024O0004000400054O000400143O00122O000300073O0026D5000300732O0100070004B03O00732O010012390104000A4O00C4000500013O00122O0006008A3O00122O0007008B6O0005000700024O0004000400054O000500013O00122O0006008C3O00122O0007008D6O0005000700024O0004000400054O000400153O00122O000100063O00044O00A12O010004B03O00732O010004B03O00A12O010004B03O006E2O010026D5000100070001000F0004B03O00070001001255010200013O0026D5000200B42O0100070004B03O00B42O010012390103000A4O00C4000400013O00122O0005008E3O00122O0006008F6O0004000600024O0003000300044O000400013O00122O000500903O00122O000600916O0004000600024O0003000300044O000300163O00122O000100633O00044O000700010026C0000200B82O0100010004B03O00B82O01002E59009300A42O0100920004B03O00A42O010012390103000A4O00D1000400013O00122O000500943O00122O000600956O0004000600024O0003000300044O000400013O00122O000500963O00122O000600976O0004000600024O0003000300044O000300173O00122O0003000A6O000400013O00122O000500983O00122O000600996O0004000600024O0003000300044O000400013O00122O0005009A3O00122O0006009B6O0004000600024O0003000300044O000300183O00122O000200073O0004B03O00A42O010004B03O000700010004B03O00D52O010004B03O000200012O00013O00017O00593O00030C3O004570696353652O74696E677303083O00B0DB280C8AD03B0B03043O0078E3BE5C030C3O00284F1A4C2A52DDD135591E6903083O00825D3C7F1B433CB903083O007B372C5AE94D7A5B03073O001D2852582E802303113O002E56D13E00A83A46DD090EAA0F4AC0180C03063O00D85B25B47D6103083O00167308D75E2B710F03053O003745167CA3030F3O006DC059DCD7645EF07DC14FFCD0635D03083O009418B33C88BF113003083O00812FEDB4FFBC2DEA03053O0096D24A99C003143O00F6DB3DAB7B79B1F0DC2A8B795DA1EACC3984767F03073O00D483A858EA151A03083O0076719D983129426703063O00472514E9EC58030E3O00D855B53753F85E5DC175B81F46F803083O003CAD26D076208C2C03083O007237F5C729C1462103063O00AF215281B34003153O00FBFC35E739B3E2E63EC80FA6FCEA31C208BDFAEA3D03063O00D28E8F50AF5C03083O008AECE7D2B0E7F4D503043O00A6D9899303133O00E2AD71A3E252F1A27E81E44FE7A27CA5F46ED303063O002683C312C691028O0003083O0060D32EFF315A54C503063O003433B65A8B5803163O00F7B7D3E250E2ABD1EB64E3B0D4E64DF5BCF7F54CE3A903053O002396D9B08703083O00CA551F187E4D71EA03073O001699306B6C1723030D3O000F96AF087E7972E10783AF324F03083O00896EE5DB7A1F152103083O0029B82C6F3F45236D03083O001E7ADD581B562B4403143O00302DEA8A3126ECB52C3AEE87351CE4923D25C3B603043O00E658488B03083O0041B1020F0A065F6103073O003812D4767B636803173O0016ECF9DFD6D019DAECC1DADF13DDF7C7DAD339FBF7C6CF03063O00BE7E8998B3BF03083O001B0766DFA34E2F1103063O0020486212ABCA03113O0001892060FF159D337FF2378D2660FE0A8F03053O009764E85214034O0003083O004CDCE21C76D7F11B03043O00681FB99603173O00D0B02OE2EEC8CDC1DBB4F2C3E8D8E5CDEFBCE7E3EEC2E703083O00A0BCD9939787AC8003083O003CD804E433C708CE03063O00A96FBD70905A030A3O00CC9631A28C880087C18703083O00E2ADE345CDDFE06903083O006B3B364FC6155F2D03063O007B385E423BAF03093O00E94B7AE416FAB4E94603073O00E19A2313817A9E03103O007609EC5FE1E9D93A5D40D85FFCE2DC3003083O00543A608B379587B003083O00203AB71447C1390003073O005E735FC3602EAF03073O004B4E3E310102A403083O0080232B5F5D4E4DE703083O00971822201E70AEB703073O00C9C47D5654771E03093O00CBEB05B3ECC12797F303043O00DFA38E6403083O00B113D7A5B18C11D003053O00D8E276A3D1030E3O00ABE31E31426238BBC41A1350752B03073O005FDE907B61371003083O002A81AE57EA1783A903053O008379E4DA23031D3O00CCC32722751ED8DE31044A0BD0C22B154E12CDD803077F17D0D336047D03063O007BB9B042611903083O00FB0A0D451C215F2203083O0051A86F7931754F38031B3O00D219E082D50FE8B9D53EEAA2C207D2BFD302C4B0C106ECB5D30FE103043O00D6A76A8503083O001A3D585B3D71DE3A03073O00B949582C2F541F03243O009DC41F90DCF69BD81483DFFA89D909A9DDF8BCD80EA5DEC881C31281D5F984DE19B4D6FB03063O009FE8B77AC0B3001B012O00122F012O00016O000100013O00122O000200023O00122O000300036O0001000300028O00014O000100013O00122O000200043O00122O000300056O0001000300028O00019O0000124O00016O000100013O00122O000200063O00122O000300076O0001000300028O00014O000100013O00122O000200083O00122O000300096O0001000300028O00016O00023O00124O00016O000100013O00122O0002000A3O00122O0003000B6O0001000300028O00014O000100013O00122O0002000C3O00122O0003000D6O0001000300028O00016O00033O00124O00016O000100013O00122O0002000E3O00122O0003000F6O0001000300028O00014O000100013O00122O000200103O00122O000300116O0001000300028O00016O00043O00124O00016O000100013O00122O000200123O00122O000300136O0001000300028O00014O000100013O00122O000200143O00122O000300156O0001000300028O00016O00053O00124O00016O000100013O00122O000200163O00122O000300176O0001000300028O00014O000100013O00122O000200183O00122O000300196O0001000300028O00016O00063O00124O00016O000100013O00122O0002001A3O00122O0003001B6O0001000300028O00014O000100013O00122O0002001C3O0012550103001D4O00620001000300022O00385O00010006CC3O0056000100010004B03O00560001001255012O001E4O0006012O00073O0012CA3O00016O000100013O00122O0002001F3O00122O000300206O0001000300028O00014O000100013O00122O000200213O00122O000300226O0001000300028O000100064O0065000100010004B03O00650001001255012O001E4O0006012O00083O0012CA3O00016O000100013O00122O000200233O00122O000300246O0001000300028O00014O000100013O00122O000200253O00122O000300266O0001000300028O000100064O0074000100010004B03O00740001001255012O001E4O0006012O00093O0012CA3O00016O000100013O00122O000200273O00122O000300286O0001000300028O00014O000100013O00122O000200293O00122O0003002A6O0001000300028O000100064O0083000100010004B03O00830001001255012O001E4O0006012O000A3O0012CA3O00016O000100013O00122O0002002B3O00122O0003002C6O0001000300028O00014O000100013O00122O0002002D3O00122O0003002E6O0001000300028O000100064O0092000100010004B03O00920001001255012O001E4O0006012O000B3O0012CA3O00016O000100013O00122O0002002F3O00122O000300306O0001000300028O00014O000100013O00122O000200313O00122O000300326O0001000300028O000100064O00A1000100010004B03O00A10001001255012O00334O0006012O000C3O0012CA3O00016O000100013O00122O000200343O00122O000300356O0001000300028O00014O000100013O00122O000200363O00122O000300376O0001000300028O000100064O00B0000100010004B03O00B00001001255012O00334O0006012O000D3O0012E73O00016O000100013O00122O000200383O00122O000300396O0001000300028O00014O000100013O00122O0002003A3O00122O0003003B6O0001000300028O00016O000E3O00124O00016O000100013O00122O0002003C3O00122O0003003D6O0001000300028O00014O000100013O00122O0002003E3O00122O0003003F6O0001000300028O000100064O00CE000100010004B03O00CE00012O00CD3O00013O0012552O0100403O001255010200414O00623O000200022O0006012O000F3O0012E73O00016O000100013O00122O000200423O00122O000300436O0001000300028O00014O000100013O00122O000200443O00122O000300456O0001000300028O00016O00103O00124O00016O000100013O00122O000200463O00122O000300476O0001000300028O00014O000100013O00122O000200483O00122O000300496O0001000300028O000100064O00E9000100010004B03O00E90001001255012O001E4O0006012O00113O00127E3O00016O000100013O00122O0002004A3O00122O0003004B6O0001000300028O00014O000100013O00122O0002004C3O00122O0003004D6O0001000300022O00DF5O00016O00123O00124O00016O000100013O00122O0002004E3O00122O0003004F6O0001000300028O00014O000100013O00122O000200503O001255010300514O00600001000300028O00016O00133O00124O00016O000100013O00122O000200523O00122O000300536O0001000300028O00014O000100013O001255010200543O001255010300554O00600001000300028O00016O00143O00124O00016O000100013O00122O000200563O00122O000300576O0001000300028O00014O000100013O001255010200583O001239000300596O0001000300028O00016O00158O00017O00843O00028O00025O00549540025O005EB240027O0040025O00606B40025O0002AB40025O00F09240026O00F03F025O0004AC40025O00F0AE40025O00F2AD40025O00F49340025O00C8AF40025O00A07F40030C3O004570696353652O74696E677303083O00EA2D13E4F4D72F1403053O009DB9486790030E3O004DA18374A3B44DA0BD73BCB97A9703063O00D139D3EA1AC803083O0032CBB29559DC06DD03063O00B261AEC6E130030D3O00DD5707F879EA1CF85F10F95BC203073O006FAF3664911886025O00088740025O00C0584003083O00701C34014A17270603043O0075237940030E3O00C8AEEBFE264ED1A9E6C53740D3B803063O002FBDDD8EB64303083O0013BA33DF41A7273A03083O004940DF47AB28C94003103O001F9EC171A57C0684CA5E90721E84CB5703063O001D6AEDA439C0025O0006AA40025O0038A740026O007E40025O00E09940026O000840025O00509740025O00E4A14003083O001737BC352D3CAF3203043O00414452C803113O0023597528DBFD7B28517B2EDCEC7620537903073O001E453012402OAF03083O00C3290BF832FE2B0C03053O005B904C7F8C03113O00C9065224C1A82OC0F43F4F35DB89C1C5EE03083O00B080682641B3DAB503083O00E3C1D601D9CAC50603043O0075B0A4A203163O00ADCC11F5C86B91D211DFD4759DF50DF9CE7C88CB16E403063O0019E4A26590BA03083O007B33AD1AFBEA4F2503063O00842856D96E9203123O0057C533B9B561E94E6AFF2FAEA260F45172CF03083O003E1EAB47DCC7139C025O002C9240025O0068AB40025O00849040025O00649440025O0018A040025O00D6A640026O001040025O0042A340025O00CEA44003083O004628AC95407B2AAB03053O0029154DD8E103113O003C4C7C4118485B4B174260551B5F77441803043O0025742D12025O0035B240025O00407940025O00EC9240025O0050A040025O001CAE40025O003CB140026O004540025O009EA040025O0091B240025O00C89640025O0036A840025O0060A54003083O00D50F58F03C14AEF503073O00C9866A2C84557A030B3O00231F720B1305C62833186403083O0043566C175F616CA803083O00973D581EAD2AD24303083O0030C4582C6AC444B5030A3O0097CCD91181A7AB2D8ECC03083O004CE2BFBC43E0C4C2025O00089840025O00C2A340025O00406A40025O0048A34003083O007340B82254C7285E03083O002D2025CC563DA94F030D3O00715C16ACB070715007A9B37A4603063O001C2O3565DCD503083O003E591C5553AF57CC03083O00BF6D3C68213AC130030B3O00A3DE0BF782DB3AF281D10B03043O0087E7B778025O00F8A940025O0026B340025O0087B140025O006EB040025O00FCB140026O003040025O00607E40025O00349340025O007AA240025O0020874003083O0082A1F3AE2ODCA7E103083O0092D1C487DAB5B2C0030D3O002535821D44AF3E248C1F558F1D03063O00C74D50E3713003083O00193A4AD9233159DE03043O00AD4A5F3E030F3O00CE1C5D3AC209BBF616483FC40994F603073O00DCA6793C56AB67025O001CA640025O00B09040025O00A07940025O0018834003083O00DA0729A432C41DFA03073O007A89625DD05BAA03113O00AFE41D43DCBCAEFA88F51540DB9CA8C78203083O00AAE7817C2FB5D2C9034O0003083O00B8BE2E2403248CA803063O004AEBDB5A506A030F3O0044C2553F36F15BF44ACF52382EF17E03083O00922CA33B5B5A941A006C012O001255012O00013O002E590002005F000100030004B03O005F00010026D53O005F000100040004B03O005F00010012552O0100014O00C9000200023O0026C00001000B000100010004B03O000B0001002E5900060007000100050004B03O00070001001255010200013O002E000107002B000100070004B03O003700010026D500020037000100010004B03O00370001001255010300013O0026C000030015000100080004B03O00150001002E50010A0017000100090004B03O00170001001255010200083O0004B03O00370001002E59000C001B0001000B0004B03O001B00010026C00003001D000100010004B03O001D0001002E00010D00F6FF2O000E0004B03O001100010012390104000F4O00D1000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000500013O00122O000600123O00122O000700136O0005000700024O0004000400054O00045O00122O0004000F6O000500013O00122O000600143O00122O000700156O0005000700024O0004000400054O000500013O00122O000600163O00122O000700176O0005000700024O0004000400054O000400023O00122O000300083O0004B03O00110001002E5001190054000100180004B03O00540001000E4701080054000100020004B03O005400010012390103000F4O00D1000400013O00122O0005001A3O00122O0006001B6O0004000600024O0003000300044O000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000300033O00122O0003000F6O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000300043O00122O000200043O002E590023000C000100220004B03O000C00010026C00002005A000100040004B03O005A0001002E500125000C000100240004B03O000C0001001255012O00263O0004B03O005F00010004B03O000C00010004B03O005F00010004B03O000700010026C03O0063000100010004B03O00630001002E50012800A6000100270004B03O00A600010012552O0100013O0026D500010082000100010004B03O008200010012390102000F4O004C000300013O00122O000400293O00122O0005002A6O0003000500024O0002000200034O000300013O00122O0004002B3O00122O0005002C6O0003000500024O0002000200030006CC00020074000100010004B03O00740001001255010200014O0006010200053O00127E0002000F6O000300013O00122O0004002D3O00122O0005002E6O0003000500024O0002000200034O000300013O00122O0004002F3O00122O000500306O0003000500022O00380002000200032O0006010200063O0012552O0100083O0026D50001009D000100080004B03O009D00010012390102000F4O00D1000300013O00122O000400313O00122O000500326O0003000500024O0002000200034O000300013O00122O000400333O00122O000500346O0003000500024O0002000200034O000200073O00122O0002000F6O000300013O00122O000400353O00122O000500366O0003000500024O0002000200034O000300013O00122O000400373O00122O000500386O0003000500024O0002000200034O000200083O00122O000100043O002E59003900640001003A0004B03O00640001002E50013B00640001003C0004B03O006400010026D500010064000100040004B03O00640001001255012O00083O0004B03O00A600010004B03O00640001002E50013D00AA0001003E0004B03O00AA00010026C03O00AC0001003F0004B03O00AC0001002E000140000F000100410004B03O00B900010012392O01000F4O00C5000200013O00122O000300423O00122O000400436O0002000400024O0001000100024O000200013O00122O000300443O00122O000400456O0002000400024O0001000100024O000100093O00044O006B2O010026C03O00BD000100080004B03O00BD0001002E500146000F2O0100470004B03O000F2O010012552O0100013O002E59004800EB000100490004B03O00EB00010026C0000100C4000100080004B03O00C40001002E50014B00EB0001004A0004B03O00EB0001001255010200013O0026C0000200C9000100080004B03O00C90001002E00014C00040001004D0004B03O00CB00010012552O0100043O0004B03O00EB0001002E50014F00CF0001004E0004B03O00CF00010026C0000200D1000100010004B03O00D10001002E50015000C5000100510004B03O00C500010012390103000F4O00D1000400013O00122O000500523O00122O000600536O0004000600024O0003000300044O000400013O00122O000500543O00122O000600556O0004000600024O0003000300044O0003000A3O00122O0003000F6O000400013O00122O000500563O00122O000600576O0004000600024O0003000300044O000400013O00122O000500583O00122O000600596O0004000600024O0003000300044O0003000B3O00122O000200083O0004B03O00C50001000E47010400EF000100010004B03O00EF0001001255012O00043O0004B03O000F2O010026C0000100F5000100010004B03O00F50001002E25015A00F50001005B0004B03O00F50001002E59005D00BE0001005C0004B03O00BE00010012390102000F4O00D1000300013O00122O0004005E3O00122O0005005F6O0003000500024O0002000200034O000300013O00122O000400603O00122O000500616O0003000500024O0002000200034O0002000C3O00122O0002000F6O000300013O00122O000400623O00122O000500636O0003000500024O0002000200034O000300013O00122O000400643O00122O000500656O0003000500024O0002000200034O0002000D3O00122O000100083O0004B03O00BE00010026C03O00152O0100260004B03O00152O01002E25016600152O0100670004B03O00152O01002E5001680001000100690004B03O000100010012552O0100014O00C9000200023O000E372O01001B2O0100010004B03O001B2O01002E00016A00FEFF2O006B0004B03O00172O01001255010200013O002E59006C00222O01006D0004B03O00222O010026D5000200222O0100040004B03O00222O01001255012O003F3O0004B03O00010001000E372O0100262O0100020004B03O00262O01002E59006E00452O01006F0004B03O00452O010012390103000F4O004C000400013O00122O000500703O00122O000600716O0004000600024O0003000300044O000400013O00122O000500723O00122O000600736O0004000600024O0003000300040006CC000300342O0100010004B03O00342O01001255010300014O00060103000E3O0012CA0003000F6O000400013O00122O000500743O00122O000600756O0004000600024O0003000300044O000400013O00122O000500763O00122O000600776O0004000600024O00030003000400062O000300432O0100010004B03O00432O01001255010300014O00060103000F3O001255010200083O0026C00002004B2O0100080004B03O004B2O01002E610178004B2O0100790004B03O004B2O01002E00017A00D3FF2O007B0004B03O001C2O010012390103000F4O004C000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O000400013O00122O0005007E3O00122O0006007F6O0004000600024O0003000300040006CC000300592O0100010004B03O00592O01001255010300804O0006010300103O0012390103000F4O00C4000400013O00122O000500813O00122O000600826O0004000600024O0003000300044O000400013O00122O000500833O00122O000600846O0004000600024O0003000300044O000300113O00122O000200043O00044O001C2O010004B03O000100010004B03O00172O010004B03O000100012O00013O00017O00C53O00028O00026O00F03F025O00B4AE40027O0040025O00F08E40025O00E08040025O0046B240025O00CAA540025O00E06F40025O00C07140025O0050AC40025O00888140025O00E0A840030D3O004973446561644F7247686F7374026O000840030C3O004570696353652O74696E677303073O007A0F5F3A0286BA03073O00C92E60385D6EE303063O00BF0AFDE910CD03063O00A1DB638E997503073O0048BEA174C179A203053O00AD1CD1C61303073O0078E5B9B276E8A403043O00DB158CD7025O0062A640025O008C9B4003113O00476574456E656D696573496E52616E6765026O00444003173O00476574456E656D696573496E53706C61736852616E6765026O001440025O00CAA640025O0055B040025O00388840025O007085402O033O006D6178031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O00349240025O007CAC40026O001040025O0028A240025O00CCAD40025O00788E40025O00909E40025O00406640025O00E49940025O0050A840025O00189440025O001AAE40025O0082AD40025O0056AF40025O00507840025O00808940030F3O00412O66656374696E67436F6D626174025O00B4A740025O00B4A140025O00A7B040025O00FAA740025O00A08C40025O00B89A40025O00FEAA40025O00E88D40025O00B89940025O00C6A940026O003940025O00609240025O00C89C40025O00B89040025O00F8AF40025O00108740025O0021B240030D3O006BB4C3A6565BBDF5B7515AB1D203053O003828D8A6C703073O004973526561647903093O00466F637573556E6974026O003440025O00088940025O00207A40025O00FEA640025O00EAA940025O00BEA040025O007AA840025O00F2A740025O007AA940025O0008AA40025O00249D40030D3O00546172676574497356616C6964025O00C4B240025O00808340025O00E89B40025O0028A140025O00288640025O00C8AF40025O00C89B40025O003CAD40025O0082A140025O00408C40025O00E49340025O004CA84003103O00426F2O73466967687452656D61696E73025O00BCB040026O007D40025O00C1B140025O00C06D40024O0080B3C540025O00608440026O008440030C3O00466967687452656D61696E73025O00F88240025O00E7B040030C3O0049734368612O6E656C696E67025O00249940025O000FB340025O00B0AD40025O00E88B40025O00708C40025O0008AB40025O00FEA040025O0088AD40025O00709D40025O005FB140025O00F6AF40025O00588F40025O00509840025O00DAAC40025O00F8A540025O0029B140025O0086AB40025O00149B40025O00805A4003053O00466F637573025O007CA340025O00A06C40025O00788440025O00749740025O00E49A40025O00449C40025O00FAAA40026O003740025O00E8A540025O006DB140025O00405640025O00307A40025O0031B040025O00B49340025O00088140025O0068A540025O0006AD40026O002840025O00C05740025O0084A540030F3O0048616E646C65412O666C696374656403143O00506F69736F6E436C65616E73696E67546F74656D026O003E40025O00FC9F40026O008840025O002AA340025O002FB340025O0010A940025O00CEAD40025O0032B340025O00188440025O00909D40025O00189C40025O0023B040025O002AAE40025O00A6AE40025O00E8B140025O00C88740025O00ECA640030D3O00436C65616E736553706972697403163O00436C65616E73655370697269744D6F7573656F766572025O004EA040025O00F0A540030B3O005472656D6F72546F74656D025O00088C40025O00C07A40025O0046AE40025O0040B140025O00CC9A40025O007BB24003073O0063BA115A214C9903083O009537D5763D4D29EA2O033O001E02D903083O007B7D66AAA68959CF025O002EA840025O00AAA24003073O00FBF051A5A7CAEC03053O00CBAF9F36C22O033O0074C11A03073O00A21BAE795B3A2F03073O00E7CA18F233DCC003063O00B9B3A57F955F2O033O00507ACA03053O00773115AF94025O001EA040025O0082B240025O00F0A94000A9022O001255012O00014O00C9000100023O000E47010200A002013O0004B03O00A00201002E0001033O000100030004B03O000400010026D500010004000100010004B03O00040001001255010200013O000E370104000D000100020004B03O000D0001002E0001050037000100060004B03O00420001001255010300014O00C9000400043O002E590008000F000100070004B03O000F00010026D50003000F000100010004B03O000F0001001255010400013O002E50010900240001000A0004B03O00240001000E4701020024000100040004B03O00240001002E00010B000A0001000B0004B03O00220001002E50010C00220001000D0004B03O002200012O00CD00055O0020BC00050005000E2O002101050002000200066B0105002200013O0004B03O002200012O00013O00013O0012550102000F3O0004B03O004200010026D500040014000100010004B03O00140001001239010500104O00D1000600023O00122O000700113O00122O000800126O0006000800024O0005000500064O000600023O00122O000700133O00122O000800146O0006000800024O0005000500064O000500013O00122O000500106O000600023O00122O000700153O00122O000800166O0006000800024O0005000500064O000600023O00122O000700173O00122O000800186O0006000800024O0005000500064O000500033O00122O000400023O0004B03O001400010004B03O004200010004B03O000F00010026C0000200460001000F0004B03O00460001002E50011900740001001A0004B03O007400012O00CD00035O00205000030003001B00122O0005001C6O0003000500024O000300046O000300063O00202O00030003001D00122O0005001E6O0003000500024O000300056O000300073O00066B0103006800013O0004B03O00680001001255010300013O002E50011F0058000100200004B03O005800010026C00003005A000100010004B03O005A0001002E5001210054000100220004B03O005400012O00CD000400044O0023000400046O000400083O00122O000400236O000500063O00202O00050005002400122O0007001E6O0005000700024O000600086O0004000600024O000400093O00044O007300010004B03O005400010004B03O00730001001255010300013O0026C00003006D000100010004B03O006D0001002E5001260069000100250004B03O00690001001255010400024O0006010400083O001255010400024O0006010400093O0004B03O007300010004B03O00690001001255010200273O002E0001280004000100280004B03O00780001000E372O01007A000100020004B03O007A0001002E59002900970001002A0004B03O00970001001255010300013O0026C00003007F000100010004B03O007F0001002E59002B00900001002C0004B03O00900001001255010400013O002E59002D00880001002E0004B03O008800010026C000040086000100020004B03O00860001002E59003000880001002F0004B03O00880001001255010300023O0004B03O009000010026D500040080000100010004B03O008000012O00CD0005000A4O003A0005000100014O0005000B6O00050001000100122O000400023O00044O00800001000E470102007B000100030004B03O007B00012O00CD0004000C4O0054010400010001001255010200023O0004B03O009700010004B03O007B0001002E590031009B000100320004B03O009B00010026C00002009D000100270004B03O009D0001002E590034005F020100330004B03O005F02012O00CD00035O0020BC0003000300352O00210103000200020006CC000300A5000100010004B03O00A500012O00CD0003000D3O00066B010300032O013O0004B03O00032O01001255010300014O00C9000400053O002E50013700F1000100360004B03O00F10001000E37010200AD000100030004B03O00AD0001002E59003800F1000100390004B03O00F10001002E59003A00BB0001003B0004B03O00BB00010026C0000400B3000100020004B03O00B30001002E59003C00BB0001003D0004B03O00BB00012O00CD0006000E3O0006CC000600B8000100010004B03O00B80001002E00013E004D0001003F0004B03O00032O012O00CD0006000E4O0052000600023O0004B03O00032O010026C0000400BF000100010004B03O00BF0001002E00014000F0FF2O00410004B03O00AD0001001255010600013O0026C0000600C4000100020004B03O00C40001002E59004200C6000100430004B03O00C60001001255010400023O0004B03O00AD00010026C0000600CA000100010004B03O00CA0001002E59004400C0000100450004B03O00C00001001255010700013O002E000146001C000100460004B03O00E70001000E472O0100E7000100070004B03O00E700012O00CD0008000D3O000635010500DD000100080004B03O00DD00012O00CD0008000F4O00BB000900023O00122O000A00473O00122O000B00486O0009000B00024O00080008000900202O0008000800494O00080002000200062O000500DD000100080004B03O00DD00012O00CD000500014O00CD000800103O00207601080008004A4O000900056O000A00113O00122O000B004B6O000C000C3O00122O000D00406O0008000D00024O0008000E3O00122O000700023O0026C0000700EB000100020004B03O00EB0001002E50014C00CB0001004D0004B03O00CB0001001255010600023O0004B03O00C000010004B03O00CB00010004B03O00C000010004B03O00AD00010004B03O00032O010026C0000300F5000100010004B03O00F50001002E50014F00A70001004E0004B03O00A70001001255010600013O0026D5000600FA000100020004B03O00FA0001001255010300023O0004B03O00A70001002E59005000F6000100510004B03O00F600010026D5000600F6000100010004B03O00F60001001255010400014O00C9000500053O001255010600023O0004B03O00F600010004B03O00A70001002E500152005C2O0100530004B03O005C2O01002E590055005C2O0100540004B03O005C2O012O00CD000300103O0020920003000300562O005C0103000100020006CC000300112O0100010004B03O00112O012O00CD00035O0020BC0003000300352O002101030002000200066B0103005C2O013O0004B03O005C2O01001255010300014O00C9000400053O002E50015800172O0100570004B03O00172O01000E37010200192O0100030004B03O00192O01002E59005A00542O0100590004B03O00542O010026C00004001D2O0100010004B03O001D2O01002E50015C00192O01005B0004B03O00192O01001255010500013O000E372O0100222O0100050004B03O00222O01002E50015E003F2O01005D0004B03O003F2O01001255010600013O0026D5000600382O0100010004B03O00382O01001255010700013O002E590060002C2O01005F0004B03O002C2O010026D50007002C2O0100020004B03O002C2O01001255010600023O0004B03O00382O010026C0000700302O0100010004B03O00302O01002E59006200262O0100610004B03O00262O012O00CD000800133O0020140108000800634O0008000100024O000800126O000800126O000800143O00122O000700023O00044O00262O01000E370102003C2O0100060004B03O003C2O01002E50016400232O0100650004B03O00232O01001255010500023O0004B03O003F2O010004B03O00232O01002E500167001E2O0100660004B03O001E2O010026D50005001E2O0100020004B03O001E2O012O00CD000600143O0026D50006005C2O0100680004B03O005C2O01002E59006900492O01006A0004B03O00492O010004B03O005C2O012O00CD000600133O00207801060006006B4O000700046O00088O0006000800024O000600143O00044O005C2O010004B03O001E2O010004B03O005C2O010004B03O00192O010004B03O005C2O01002E50016C00132O01006D0004B03O00132O010026D5000300132O0100010004B03O00132O01001255010400014O00C9000500053O001255010300023O0004B03O00132O012O00CD00035O0020BC00030003006E2O00210103000200020006CC000300A8020100010004B03O00A802012O00CD00035O0020BC00030003006E2O00210103000200020006CC000300A8020100010004B03O00A80201001255010300014O00C9000400043O0026C00003006E2O0100010004B03O006E2O01002E25016F006E2O0100700004B03O006E2O01002E59007100682O0100720004B03O00682O01001255010400013O0026D5000400A22O0100020004B03O00A22O012O00CD00055O0020BC0005000500352O002101050002000200066B010500902O013O0004B03O00902O01001255010500014O00C9000600063O002E50017300782O0100740004B03O00782O01000E472O0100782O0100050004B03O00782O01001255010600013O002E0001753O000100750004B03O007D2O01000E372O0100832O0100060004B03O00832O01002E590076007D2O0100770004B03O007D2O012O00CD000700154O005C0107000100022O00060107000E4O00CD0007000E3O00066B010700A802013O0004B03O00A802012O00CD0007000E4O0052000700023O0004B03O00A802010004B03O007D2O010004B03O00A802010004B03O00782O010004B03O00A80201001255010500013O0026D5000500912O0100010004B03O00912O012O00CD000600164O005C0106000100022O00060106000E3O002E500179009B2O0100780004B03O009B2O012O00CD0006000E3O0006CC0006009D2O0100010004B03O009D2O01002E50017B00A80201007A0004B03O00A802012O00CD0006000E4O0052000600023O0004B03O00A802010004B03O00912O010004B03O00A80201002E00017C00CDFF2O007C0004B03O006F2O01002E50017D006F2O01007E0004B03O006F2O010026D50004006F2O0100010004B03O006F2O01001255010500013O0026C0000500AD2O0100020004B03O00AD2O01002E59007F00AF2O0100250004B03O00AF2O01001255010400023O0004B03O006F2O01002E59008100A92O0100800004B03O00A92O010026D5000500A92O0100010004B03O00A92O01001239010600823O0006CC000600BA2O0100010004B03O00BA2O01002E25018300BA2O0100840004B03O00BA2O01002E50018600DA2O0100850004B03O00DA2O01002E50018700DA2O0100880004B03O00DA2O012O00CD0006000D3O0006CC000600C12O0100010004B03O00C12O01002E59008900DA2O01008A0004B03O00DA2O01001255010600014O00C9000700073O0026C0000600C72O0100010004B03O00C72O01002E59008C00C32O01008B0004B03O00C32O01001255010700013O0026C0000700CC2O0100010004B03O00CC2O01002E00018D00FEFF2O008E0004B03O00C82O012O00CD000800174O005C0108000100022O00060108000E4O00CD0008000E3O0006CC000800D42O0100010004B03O00D42O01002E50018F00DA2O0100900004B03O00DA2O012O00CD0008000E4O0052000800023O0004B03O00DA2O010004B03O00C82O010004B03O00DA2O010004B03O00C32O01002E000191007F000100910004B03O005902012O00CD000600183O00066B0106005902013O0004B03O00590201001255010600014O00C9000700073O002E0001923O000100920004B03O00E12O010026D5000600E12O0100010004B03O00E12O01001255010700013O002E5900940005020100930004B03O000502010026D500070005020100020004B03O000502012O00CD000800193O00066B0108005902013O0004B03O00590201001255010800013O0026C0000800F22O0100010004B03O00F22O01002E59009600EE2O0100950004B03O00EE2O012O00CD000900103O0020630109000900974O000A000F3O00202O000A000A00984O000B000F3O00202O000B000B009800122O000C00996O0009000C00024O0009000E3O002E2O009B00590201009A0004B03O005902012O00CD0009000E3O00066B0109005902013O0004B03O005902012O00CD0009000E4O0052000900023O0004B03O005902010004B03O00EE2O010004B03O00590201002E59009C00E62O01009D0004B03O00E62O010026D5000700E62O0100010004B03O00E62O01001255010800014O00C9000900093O002E50019E000B0201009F0004B03O000B02010026D50008000B020100010004B03O000B0201001255010900013O0026C000090014020100010004B03O00140201002E5900A0004D020100A10004B03O004D0201002E5001A30019020100A20004B03O001902012O00CD000A001A3O0006CC000A001B020100010004B03O001B0201002E5001A40032020100A50004B03O00320201001255010A00013O002E5900A6001C020100A70004B03O001C0201002E5001A8001C020100A90004B03O001C0201000E472O01001C0201000A0004B03O001C02012O00CD000B00103O002073000B000B00974O000C000F3O00202O000C000C00AA4O000D00113O00202O000D000D00AB00122O000E001C6O000B000E00024O000B000E6O000B000E3O00062O000B003202013O0004B03O003202012O00CD000B000E4O0052000B00023O0004B03O003202010004B03O001C02012O00CD000A001B3O0006CC000A0037020100010004B03O00370201002E5900AD004C020100AC0004B03O004C0201001255010A00013O0026D5000A0038020100010004B03O003802012O00CD000B00103O002063010B000B00974O000C000F3O00202O000C000C00AE4O000D000F3O00202O000D000D00AE00122O000E00996O000B000E00024O000B000E3O002E2O00B0004C020100AF0004B03O004C02012O00CD000B000E3O00066B010B004C02013O0004B03O004C02012O00CD000B000E4O0052000B00023O0004B03O004C02010004B03O00380201001255010900023O002E5900B10010020100B20004B03O001002010026D500090010020100020004B03O00100201001255010700023O0004B03O00E62O010004B03O001002010004B03O00E62O010004B03O000B02010004B03O00E62O010004B03O005902010004B03O00E12O01001255010500023O0004B03O00A92O010004B03O006F2O010004B03O00A802010004B03O00682O010004B03O00A802010026D500020009000100020004B03O00090001001255010300013O002E5001B30074020100B40004B03O007402010026D500030074020100020004B03O00740201001239010400104O00C4000500023O00122O000600B53O00122O000700B66O0005000700024O0004000400054O000500023O00122O000600B73O00122O000700B86O0005000700024O0004000400054O0004001C3O00122O000200043O00044O000900010026D500030062020100010004B03O00620201001255010400013O0026C00004007B020100010004B03O007B0201002E5001B90094020100BA0004B03O00940201001239010500104O00D1000600023O00122O000700BB3O00122O000800BC6O0006000800024O0005000500064O000600023O00122O000700BD3O00122O000800BE6O0006000800024O0005000500064O0005001D3O00122O000500106O000600023O00122O000700BF3O00122O000800C06O0006000800024O0005000500064O000600023O00122O000700C13O00122O000800C26O0006000800024O0005000500064O000500073O00122O000400023O0026C000040098020100020004B03O00980201002E5001C300770201001C0004B03O00770201001255010300023O0004B03O006202010004B03O007702010004B03O006202010004B03O000900010004B03O00A802010004B03O000400010004B03O00A80201002E5001C50002000100C40004B03O000200010026D53O0002000100010004B03O000200010012552O0100014O00C9000200023O001255012O00023O0004B03O000200012O00013O00017O00183O00028O00025O0026AA40025O008EA640025O004FB340025O00E08540025O008EAB40025O001C9C40025O00E4A540025O003DB14003104O00B8142223871D2025BF312A24A1132903043O004F46D47503143O00526567697374657241757261547261636B696E67026O00F03F025O0090AB40025O0022B040025O00B07040025O0060A440025O0047B140025O00CAA740025O0032A740025O00AC934003053O005072696E74032F3O00821AE4CBFC03B317ED86CA05A61BE0C8B90FBE56C4D6F00EE956D2D3E91DA804F5C3FD4DA50FA1DED20CA913F5C9B703063O006DC77681A699003E3O001255012O00014O00C9000100013O002E5001030002000100020004B03O000200010026D53O0002000100010004B03O000200010012552O0100013O002E500105002C000100040004B03O002C00010026D50001002C000100010004B03O002C0001001255010200014O00C9000300033O002E500107000D000100060004B03O000D0001000E472O01000D000100020004B03O000D0001001255010300013O0026C000030016000100010004B03O00160001002E5900090021000100080004B03O002100012O00CD00046O0042000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O0004000200014O000400026O00040001000100122O0003000D3O002E59000E00120001000F0004B03O001200010026C0000300270001000D0004B03O00270001002E5900110012000100100004B03O001200010012552O01000D3O0004B03O002C00010004B03O001200010004B03O002C00010004B03O000D0001002E5900130007000100120004B03O000700010026C0000100320001000D0004B03O00320001002E5900140007000100150004B03O000700012O00CD000200033O0020280002000200164O000300013O00122O000400173O00122O000500186O000300056O00023O000100044O003D00010004B03O000700010004B03O003D00010004B03O000200012O00013O00017O00", GetFEnv(), ...);

