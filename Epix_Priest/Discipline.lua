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
				if (Enum <= 149) then
					if (Enum <= 74) then
						if (Enum <= 36) then
							if (Enum <= 17) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
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
										elseif (Enum == 2) then
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
											local Results = {Stk[A](Stk[A + 1])};
											local Edx = 0;
											for Idx = A, Inst[4] do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
										end
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 6) then
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
									elseif (Enum > 7) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum > 9) then
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
									elseif (Enum == 11) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 14) then
									if (Enum == 13) then
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
									end
								elseif (Enum <= 15) then
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
								elseif (Enum == 16) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum == 18) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 20) then
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
								elseif (Enum <= 23) then
									if (Enum > 22) then
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
									end
								elseif (Enum <= 24) then
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
								elseif (Enum > 25) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum > 27) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local T;
										local A;
										Stk[Inst[2]] = {};
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
										Stk[Inst[2]] = {};
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
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 29) then
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
								elseif (Enum == 30) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 33) then
								if (Enum > 32) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
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
							elseif (Enum > 35) then
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
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 55) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum == 37) then
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
									elseif (Enum == 39) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 42) then
									if (Enum == 41) then
										if (Stk[Inst[2]] ~= Inst[4]) then
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
									end
								elseif (Enum <= 43) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 44) then
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
									local T;
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
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
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 50) then
								if (Enum <= 47) then
									if (Enum > 46) then
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
										A = Inst[2];
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
									end
								elseif (Enum <= 48) then
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								elseif (Enum == 49) then
									Stk[Inst[2]] = #Stk[Inst[3]];
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
							elseif (Enum <= 52) then
								if (Enum == 51) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 53) then
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
							elseif (Enum > 54) then
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
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 64) then
							if (Enum <= 59) then
								if (Enum <= 57) then
									if (Enum > 56) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 58) then
									local A = Inst[2];
									Stk[A] = Stk[A]();
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 61) then
								if (Enum == 60) then
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 62) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 63) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 69) then
							if (Enum <= 66) then
								if (Enum == 65) then
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
								elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 67) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 68) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 71) then
							if (Enum > 70) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 72) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 73) then
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
						else
							do
								return;
							end
						end
					elseif (Enum <= 111) then
						if (Enum <= 92) then
							if (Enum <= 83) then
								if (Enum <= 78) then
									if (Enum <= 76) then
										if (Enum > 75) then
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
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum > 77) then
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
								elseif (Enum <= 80) then
									if (Enum == 79) then
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
							elseif (Enum <= 87) then
								if (Enum <= 85) then
									if (Enum == 84) then
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
								elseif (Enum == 86) then
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 89) then
								if (Enum > 88) then
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
							elseif (Enum <= 90) then
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 101) then
							if (Enum <= 96) then
								if (Enum <= 94) then
									if (Enum > 93) then
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
									end
								elseif (Enum > 95) then
									if (Stk[Inst[2]] < Inst[4]) then
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
							elseif (Enum <= 98) then
								if (Enum > 97) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 99) then
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
							elseif (Enum > 100) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 106) then
							if (Enum <= 103) then
								if (Enum > 102) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 104) then
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
							elseif (Enum == 105) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							if (Enum == 107) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							else
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 109) then
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
							VIP = Inst[3];
						elseif (Enum > 110) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
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
						end
					elseif (Enum <= 130) then
						if (Enum <= 120) then
							if (Enum <= 115) then
								if (Enum <= 113) then
									if (Enum == 112) then
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
								elseif (Enum == 114) then
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
							elseif (Enum <= 117) then
								if (Enum > 116) then
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
							elseif (Enum <= 118) then
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
							elseif (Enum == 119) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
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
						elseif (Enum <= 125) then
							if (Enum <= 122) then
								if (Enum == 121) then
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
							elseif (Enum <= 123) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 124) then
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
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 127) then
							if (Enum > 126) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 128) then
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 129) then
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
					elseif (Enum <= 139) then
						if (Enum <= 134) then
							if (Enum <= 132) then
								if (Enum == 131) then
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
							elseif (Enum == 133) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							end
						elseif (Enum <= 136) then
							if (Enum > 135) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 137) then
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
						elseif (Enum == 138) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Enum <= 141) then
							if (Enum > 140) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 142) then
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
						elseif (Enum > 143) then
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
					elseif (Enum <= 146) then
						if (Enum == 145) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 147) then
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
					elseif (Enum > 148) then
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
				elseif (Enum <= 224) then
					if (Enum <= 186) then
						if (Enum <= 167) then
							if (Enum <= 158) then
								if (Enum <= 153) then
									if (Enum <= 151) then
										if (Enum == 150) then
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
												if (Mvm[1] == 216) then
													Indexes[Idx - 1] = {Stk,Mvm[3]};
												else
													Indexes[Idx - 1] = {Upvalues,Mvm[3]};
												end
												Lupvals[#Lupvals + 1] = Indexes;
											end
											Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 152) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 155) then
									if (Enum == 154) then
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
								elseif (Enum <= 156) then
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
								elseif (Enum == 157) then
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
								if (Enum <= 160) then
									if (Enum > 159) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 161) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								else
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								end
							elseif (Enum <= 164) then
								if (Enum > 163) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 165) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							elseif (Enum == 166) then
								local B;
								local T;
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
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
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
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
						elseif (Enum <= 176) then
							if (Enum <= 171) then
								if (Enum <= 169) then
									if (Enum == 168) then
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									else
										Stk[Inst[2]] = #Stk[Inst[3]];
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
									end
								elseif (Enum == 170) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 173) then
								if (Enum > 172) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								else
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 174) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 175) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 181) then
							if (Enum <= 178) then
								if (Enum == 177) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
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
							elseif (Enum <= 179) then
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
							elseif (Enum == 180) then
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
						elseif (Enum <= 183) then
							if (Enum == 182) then
								Stk[Inst[2]] = not Stk[Inst[3]];
							else
								local B;
								local T;
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
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
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 184) then
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
					elseif (Enum <= 205) then
						if (Enum <= 195) then
							if (Enum <= 190) then
								if (Enum <= 188) then
									if (Enum == 187) then
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 189) then
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Enum == 191) then
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
							elseif (Enum > 194) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 200) then
							if (Enum <= 197) then
								if (Enum == 196) then
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
								else
									local B;
									local T;
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
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
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 198) then
								local A;
								Stk[Inst[2]]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							elseif (Enum > 199) then
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
						elseif (Enum <= 202) then
							if (Enum > 201) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
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
								Stk[Inst[2]] = {};
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
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							elseif (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 203) then
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
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
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 204) then
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
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 214) then
						if (Enum <= 209) then
							if (Enum <= 207) then
								if (Enum > 206) then
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
							elseif (Enum == 208) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
						elseif (Enum <= 211) then
							if (Enum > 210) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 212) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 213) then
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
					elseif (Enum <= 219) then
						if (Enum <= 216) then
							if (Enum > 215) then
								Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum <= 217) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 218) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3] ~= 0;
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
					elseif (Enum <= 221) then
						if (Enum > 220) then
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
					elseif (Enum <= 222) then
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
					elseif (Enum == 223) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 261) then
					if (Enum <= 242) then
						if (Enum <= 233) then
							if (Enum <= 228) then
								if (Enum <= 226) then
									if (Enum > 225) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 227) then
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
							elseif (Enum <= 230) then
								if (Enum == 229) then
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
							elseif (Enum <= 231) then
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
							elseif (Enum > 232) then
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
						elseif (Enum <= 237) then
							if (Enum <= 235) then
								if (Enum > 234) then
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
									Stk[Inst[2]]();
								end
							elseif (Enum > 236) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 239) then
							if (Enum > 238) then
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
							end
						elseif (Enum <= 240) then
							VIP = Inst[3];
						elseif (Enum == 241) then
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
					elseif (Enum <= 251) then
						if (Enum <= 246) then
							if (Enum <= 244) then
								if (Enum == 243) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
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
								end
							elseif (Enum > 245) then
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
								local T;
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
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
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 248) then
							if (Enum == 247) then
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
							end
						elseif (Enum <= 249) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 250) then
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
							Stk[Inst[2]] = Inst[3] ~= 0;
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
					elseif (Enum <= 256) then
						if (Enum <= 253) then
							if (Enum == 252) then
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
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
						elseif (Enum <= 254) then
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
						elseif (Enum == 255) then
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
					elseif (Enum <= 258) then
						if (Enum == 257) then
							local B;
							local T;
							local A;
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
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
					elseif (Enum <= 259) then
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 260) then
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
				elseif (Enum <= 280) then
					if (Enum <= 270) then
						if (Enum <= 265) then
							if (Enum <= 263) then
								if (Enum > 262) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 264) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 267) then
							if (Enum > 266) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 268) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
						elseif (Enum == 269) then
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
					elseif (Enum <= 275) then
						if (Enum <= 272) then
							if (Enum > 271) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
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
						elseif (Enum <= 273) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 274) then
							local B;
							local T;
							local A;
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
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
					elseif (Enum <= 277) then
						if (Enum > 276) then
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
						else
							Upvalues[Inst[3]] = Stk[Inst[2]];
						end
					elseif (Enum <= 278) then
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
					elseif (Enum > 279) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 289) then
					if (Enum <= 284) then
						if (Enum <= 282) then
							if (Enum == 281) then
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
						elseif (Enum > 283) then
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
					elseif (Enum <= 286) then
						if (Enum > 285) then
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
					elseif (Enum <= 287) then
						local B = Stk[Inst[4]];
						if B then
							VIP = VIP + 1;
						else
							Stk[Inst[2]] = B;
							VIP = Inst[3];
						end
					elseif (Enum == 288) then
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
				elseif (Enum <= 294) then
					if (Enum <= 291) then
						if (Enum == 290) then
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
						elseif Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 292) then
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
					elseif (Enum > 293) then
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
				elseif (Enum <= 296) then
					if (Enum == 295) then
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
				elseif (Enum <= 297) then
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
				elseif (Enum == 298) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
					Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!513O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403063O00506C6179657203063O0054617267657403053O00466F63757303093O004D6F7573654F7665722O033O0050657403053O005370652O6C03043O004974656D03053O005574696C7303043O004361737403043O0042696E6403053O005072652O7303053O004D6163726F03073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03063O00666F726D6174028O0003103O0052616D705261707475726554696D6573025O00F6A440025O00805140025O00406540025O00E0704003133O0052616D704576616E67656C69736D54696D6573025O00E06040025O00206C40025O00D07840030D3O0052616D70426F746854696D6573025O00F0A440026O002E40025O00206240025O00406F40025O00F4A440026O005E40025O00606840025O00D07140025O00F8A440025O00206740025O00E07540025O00FEA440026O001440025O00C05C40025O00A06940025O00707240026O00A540025O00804640025O00806140025O00C06C40025O0002A540025O00405A40025O00107340025O000AA540025O00405F40025O00A06E40025O00FAA440025O00805340025O00E06540025O00D07040025O0060764003063O00507269657374030A3O004469736369706C696E6503103O005265676973746572466F724576656E7403243O00D48E1104DE54CA9D090CD154C792161DCD52DC8C0904D250C1840A03D752DD8C0B0ACD5503063O001195CD454D8803063O0053657441504C026O0070400027022O0012933O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004F03O000A000100124F000300063O0020A200040003000700124F000500083O0020A200050005000900124F000600083O0020A200060006000A00069600073O000100062O00D83O00064O00D88O00D83O00044O00D83O00014O00D83O00024O00D83O00054O006E0008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000D001000202O000F000D001100202O0010000D001200202O0011000D00130020A20012000D001400200B0113000B001500202O0014000B001600202O0015000B001700122O0016000D3O00202O00170016001800202O00180016001900202O00190016001A00202O001A0016001B00202O001B0016001C00202O001B001B001D0020A2001B001B001E002085001C0016001C00202O001C001C001D00202O001C001C001F00122O001D00013O00202O001D001D00204O001E005A6O005B8O005C8O005D8O005E6O0056005F5O0012CB006000213O00122O006100216O00628O00635O00122O006300223O00122O006300226O006400033O00122O006500243O00122O006600253O00122O006700264O00FC0064000300010010E30063002300642O001B00635O00122O006300273O00122O006300276O006400033O00122O006500283O00122O006600293O00122O0067002A6O0064000300010010E30063002300642O001B00635O00122O0063002B3O00122O0063002B6O006400033O00122O0065002D3O00122O0066002E3O00122O0067002F6O0064000300010010E30063002C006400122D0063002B6O006400043O00122O0065002D3O00122O006600313O00122O006700323O00122O006800336O0064000400010010E30063003000640012C50063002B6O006400033O00122O0065002D3O00122O006600353O00122O006700366O0064000300010010E300630034006400122D0063002B6O006400043O00122O006500383O00122O006600393O00122O0067003A3O00122O0068003B6O0064000400010010E30063003700640012C50063002B6O006400033O00122O0065003D3O00122O0066003E3O00122O0067003F6O0064000300010010E30063003C00640012C50063002B6O006400033O00122O006500413O00122O0066003A3O00122O006700426O0064000300010010E300630040006400122D0063002B6O006400043O00122O0065002D3O00122O006600443O00122O006700353O00122O006800456O0064000400010010E300630043006400122D0063002B6O006400043O00122O006500473O00122O006600483O00122O006700493O00122O0068004A6O0064000400010010E30063004600640020C400630013004B00202O00630063004C00202O00640014004B00202O00640064004C00202O0065001A004B00202O00650065004C4O00668O006700793O00202O007A0016001C00202O007A007A001D000696007B0001000100032O00D83O00634O00D83O007A4O00D83O00153O0020D6007C000B004D000696007E0002000100012O00D83O007B4O002C007F00073O00122O0080004E3O00122O0081004F6O007F00816O007C3O0001000696007C0003000100012O00D83O00633O000696007D0004000100022O00D83O00634O00D83O000E3O000696007E0005000100062O00D83O00634O00D83O005D4O00D83O007A4O00D83O00194O00D83O00654O00D83O00073O000696007F00060001000F2O00D83O00644O00D83O00314O00D83O000E4O00D83O00324O00D83O00194O00D83O00654O00D83O00074O00D83O001F4O00D83O00214O00D83O00204O00D83O00634O00D83O002F4O00D83O00304O00D83O002D4O00D83O002E3O00069600800007000100032O00D83O007A4O00D83O00664O00D83O005C3O00069600810008000100092O00D83O00604O00D83O00254O00D83O00634O00D83O00244O00D83O000E4O00D83O00194O00D83O00654O00D83O00074O00D83O00233O000696008200090001000C2O00D83O00774O00D83O00104O00D83O003E4O00D83O000E4O00D83O00634O00D83O00194O00D83O00654O00D83O00074O00D83O007A4O00D83O003F4O00D83O00404O00D83O000F3O0006960083000A000100132O00D83O00634O00D83O00474O00D83O00104O00D83O00484O00D83O00194O00D83O00654O00D83O00074O00D83O00494O00D83O007A4O00D83O004A4O00D83O004B4O00D83O00414O00D83O00424O00D83O00434O00D83O000E4O00D83O006E4O00D83O00464O00D83O00444O00D83O00453O0006960084000B000100282O00D83O00634O00D83O007A4O00D83O00104O00D83O00074O00D83O00574O00D83O00194O00D83O00654O00D83O000E4O00D83O00514O00D83O006F4O00D83O00564O00D83O00554O00D83O00774O00D83O005B4O00D83O003E4O00D83O00824O00D83O004F4O00D83O00784O00D83O000F4O00D83O003D4O00D83O005C4O00D83O004C4O00D83O004D4O00D83O004E4O00D83O003F4O00D83O00404O00D83O00504O00D83O00524O00D83O00534O00D83O00544O00D83O00414O00D83O00424O00D83O00434O00D83O006E4O00D83O00474O00D83O00484O00D83O00794O00D83O003A4O00D83O003B4O00D83O003C3O0006960085000C000100052O00D83O00634O00D83O000F4O00D83O00194O00D83O00074O00D83O00703O0006960086000D000100102O00D83O00074O00D83O00794O00D83O007A4O00D83O000F4O00D83O006B4O00D83O00194O00D83O00654O00D83O00784O00D83O00634O00D83O000E4O00D83O00774O00D83O003F4O00D83O00404O00D83O00824O00D83O00694O00D83O00103O0006960087000E000100132O00D83O00634O00D83O007D4O00D83O00734O00D83O00194O00D83O000F4O00D83O00074O00D83O000E4O00D83O00694O00D83O00104O00D83O00784O00D83O007A4O00D83O00654O00D83O00794O00D83O00724O00D83O006B4O00D83O00774O00D83O003F4O00D83O00404O00D83O00823O0006960088000F000100202O00D83O00634O00D83O00194O00D83O000F4O00D83O00074O00D83O00794O00D83O007A4O00D83O00654O00D83O00784O00D83O005D4O00D83O00274O00D83O000E4O00D83O001E4O00D83O005C4O00D83O00714O00D83O00734O00D83O00804O00D83O00624O00D83O00704O00D83O00754O00D83O00854O00D83O00764O00D83O00864O00D83O00744O00D83O00874O00D83O00694O00D83O00104O00D83O00814O00D83O00724O00D83O00774O00D83O003F4O00D83O00404O00D83O00823O000696008900100001000F2O00D83O007F4O00D83O007A4O00D83O00884O00D83O000E4O00D83O00814O00D83O00284O00D83O00634O00D83O00654O00D83O00104O00D83O00264O00D83O007E4O00D83O005C4O00D83O00834O00D83O00294O00D83O00843O000696008A00110001000F2O00D83O00634O00D83O00224O00D83O000E4O00D83O007A4O00D83O00194O00D83O00654O00D83O00074O00D83O00284O00D83O00104O00D83O00264O00D83O007E4O00D83O005B4O00D83O00844O00D83O00814O00D83O000F3O000696008B0012000100082O00D83O00104O00D83O00634O00D83O00584O00D83O000E4O00D83O00194O00D83O00654O00D83O00074O00D83O007A3O000696008C00130001000F2O00D83O00744O00D83O00634O00D83O00754O00D83O000E4O00D83O00764O00D83O00874O00D83O00194O00D83O00654O00D83O006E4O00D83O00074O00D83O00864O00D83O00104O00D83O00704O00D83O007A4O00D83O00613O000696008D00140001000F2O00D83O00704O00D83O00634O00D83O000E4O00D83O00764O00D83O00744O00D83O00754O00D83O007A4O00D83O00864O00D83O00874O00D83O00104O00D83O00194O00D83O00654O00D83O00074O00D83O006E4O00D83O00613O000696008E00150001000F2O00D83O00754O00D83O00634O00D83O00704O00D83O000E4O00D83O00764O00D83O00194O00D83O00654O00D83O006E4O00D83O00074O00D83O00104O00D83O00614O00D83O00744O00D83O007A4O00D83O00864O00D83O00873O000696008F00160001001D2O00D83O001E4O00D83O00074O00D83O001F4O00D83O00204O00D83O00214O00D83O00264O00D83O00274O00D83O00284O00D83O00294O00D83O002A4O00D83O002B4O00D83O002C4O00D83O002D4O00D83O002E4O00D83O002F4O00D83O00304O00D83O00314O00D83O00324O00D83O00334O00D83O00344O00D83O00354O00D83O00224O00D83O00234O00D83O00244O00D83O00254O00D83O00364O00D83O00374O00D83O00384O00D83O00393O00069600900017000100222O00D83O004E4O00D83O00074O00D83O004F4O00D83O00504O00D83O00514O00D83O00564O00D83O00574O00D83O00584O00D83O00594O00D83O00464O00D83O00474O00D83O00484O00D83O00494O00D83O003E4O00D83O003F4O00D83O00404O00D83O00414O00D83O003C4O00D83O003D4O00D83O004C4O00D83O004D4O00D83O00424O00D83O00434O00D83O00444O00D83O00454O00D83O005A4O00D83O004A4O00D83O004B4O00D83O003A4O00D83O003B4O00D83O00524O00D83O00534O00D83O00544O00D83O00553O00069600910018000100222O00D83O000E4O00D83O007A4O00D83O00634O00D83O005E4O00D83O00074O00D83O00614O00D83O000B4O00D83O00694O00D83O00684O00D83O006B4O00D83O006A4O00D83O00774O00D83O00784O00D83O00794O00D83O006E4O00D83O008F4O00D83O00904O00D83O005B4O00D83O005C4O00D83O005D4O00D83O00624O00D83O005A4O00D83O00594O00D83O00604O00D83O00264O00D83O005F4O00D83O006F4O00D83O008B4O00D83O008C4O00D83O00894O00D83O008D4O00D83O008E4O00D83O008A4O00D83O00883O00069600920019000100032O00D83O007B4O00D83O00164O00D83O00073O00207300930016005000122O009400516O009500916O009600926O0093009600016O00013O001A3O00023O00026O00F03F026O00704002264O00DD00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00AC00076O008E000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004180003000500012O00AC000300054O00D8000400024O0087000300044O00A500036O004A3O00017O00063O00030E3O00496D70726F766564507572696679030B3O004973417661696C61626C6503123O0044697370652O6C61626C65446562752O6673030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667300154O001D7O00206O000100206O00026O0002000200064O001000013O0004F03O001000012O00AC3O00014O0044000100023O00202O0001000100044O000200013O00202O0002000200054O000300013O00202O0003000300064O00010003000200104O0003000100044O001400012O00AC3O00014O00AC000100013O0020A20001000100050010E33O000300012O004A3O00019O003O00034O00AC8O00EA3O000100012O004A3O00017O00043O0003113O00446562752O665265667265736861626C65030E3O00536861646F77576F72645061696E03093O0054696D65546F446965026O002840010E3O0020F900013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004F03O000C00010020D600013O00032O00CC000100020002000E7F0004000B000100010004F03O000B00012O00102O016O0056000100014O00212O0100024O004A3O00017O00073O00028O0003133O005477696C69676874457175696C69627269756D030B3O004973417661696C61626C65030B3O0042752O6652656D61696E7303123O00536861646F77436F76656E616E7442752O6603053O00536D697465030B3O004578656375746554696D65001B3O0012F13O00013O0026C93O0001000100010004F03O000100012O00AC00015O0020A20001000100020020D60001000100032O00CC0001000200020006232O01001700013O0004F03O001700012O00AC000100013O0020270001000100044O00035O00202O0003000300054O0001000300024O00025O00202O00020002000600202O0002000200074O00020002000200062O00020015000100010004F03O001500012O00102O016O0056000100014O00212O0100024O005600016O00212O0100023O0004F03O000100012O004A3O00017O00063O0003063O0050757269667903073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974030B3O00507572696679466F637573030D3O00B7D2E95E74CBC0A3CEE84777DE03073O00E0C7A79B3712B2001A4O001D7O00206O000100206O00026O0002000200064O001900013O0004F03O001900012O00AC3O00013O000623012O001900013O0004F03O001900012O00AC3O00023O0020A25O00032O003A3O00010002000623012O001900013O0004F03O001900012O00AC3O00034O00AC000100043O0020A20001000100042O00CC3O00020002000623012O001900013O0004F03O001900012O00AC3O00053O0012F1000100053O0012F1000200064O00873O00024O00A58O004A3O00017O00133O00028O00026O00F03F030B3O004865616C746873746F6E6503073O004973526561647903103O004865616C746850657263656E7461676503173O0034C17B80E944E028CB7489BD48F63AC1749FF45AF67C9703073O00935CA41AEC9D2C03193O007E4A5D38175F475224150C675E2B1E45415C6A22435B52251C03053O00722C2F3B4A03173O0052656672657368696E674865616C696E67506F74696F6E03253O0016B623C3D017BB2CDFD244BB20D0D90DBD2291C50BA72CDEDB44B720D7D00AA02CC7D044E703053O00B564D345B103043O0046616465030E3O000FCAB35F49CFB25C0CC5A4531FCE03043O003A69ABD7030F3O00446573706572617465507261796572030A3O0049734361737461626C65031A3O00F1EC9252E46BF4FD847DF16BF4F08450A17DF0EF844CF270E3EC03063O00199589E12281007E3O0012F13O00013O0026C93O0043000100020004F03O004300012O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O01001F00013O0004F03O001F00012O00AC000100013O0006232O01001F00013O0004F03O001F00012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC000200033O0006420001001F000100020004F03O001F00012O00AC000100044O001B010200053O00202O0002000200034O000300046O000500016O00010005000200062O0001001F00013O0004F03O001F00012O00AC000100063O0012F1000200063O0012F1000300074O0087000100034O00A500016O00AC000100073O0006232O01007D00013O0004F03O007D00012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC000200083O0006420001007D000100020004F03O007D00012O00AC000100094O00ED000200063O00122O000300083O00122O000400096O00020004000200062O0001007D000100020004F03O007D00012O00AC00015O0020A200010001000A0020D60001000100042O00CC0001000200020006232O01007D00013O0004F03O007D00012O00AC000100044O001B010200053O00202O00020002000A4O000300046O000500016O00010005000200062O0001007D00013O0004F03O007D00012O00AC000100063O0012760002000B3O00122O0003000C6O000100036O00015O00044O007D00010026C93O0001000100010004F03O000100012O00AC0001000A3O0020A200010001000D0020D60001000100042O00CC0001000200020006232O01006100013O0004F03O006100012O00AC0001000B3O0006232O01006100013O0004F03O006100012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC0002000C3O00064200010061000100020004F03O006100012O00AC000100044O001B0102000A3O00202O00020002000D4O000300046O000500016O00010005000200062O0001006100013O0004F03O006100012O00AC000100063O0012F10002000E3O0012F10003000F4O0087000100034O00A500016O00AC0001000A3O0020A20001000100100020D60001000100112O00CC0001000200020006232O01007B00013O0004F03O007B00012O00AC0001000D3O0006232O01007B00013O0004F03O007B00012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC0002000E3O0006420001007B000100020004F03O007B00012O00AC000100044O00AC0002000A3O0020A20002000200102O00CC0001000200020006232O01007B00013O0004F03O007B00012O00AC000100063O0012F1000200123O0012F1000300134O0087000100034O00A500015O0012F13O00023O0004F03O000100012O004A3O00017O00063O00028O00026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O0012F13O00013O0026C93O0011000100020004F03O001100012O00AC00015O00209B0001000100044O000200016O000300023O00122O000400056O000500056O00010005000200122O000100033O00122O000100033O00062O0001002200013O0004F03O0022000100124F000100034O00212O0100023O0004F03O002200010026C93O0001000100010004F03O000100012O00AC00015O00209B0001000100064O000200016O000300023O00122O000400056O000500056O00010005000200122O000100033O00122O000100033O00062O0001002000013O0004F03O0020000100124F000100034O00212O0100023O0012F13O00023O0004F03O000100012O004A3O00017O00103O0003073O0047657454696D65028O00030B3O00426F6479616E64536F756C030B3O004973417661696C61626C65030F3O00506F776572576F7264536869656C6403073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O6603153O00506F776572576F7264536869656C64506C61796572031D3O00EAE027F9C6B625F5FD34C3C7813BFFE334C3C48533E3EA22BCD98624FF03073O00529A8F509CB4E9030E3O00416E67656C69634665617468657203143O00416E67656C696346656174686572506C61796572031B3O0032054F4B310CC28D350E495A3500D38D23074957381781BF3C1D4D03083O00D2536B282E5D65A1005E3O0012C83O00018O000100024O00019O003O00014O000100013O00062O0001005D00013O0004F03O005D00010012F13O00023O0026C93O0008000100020004F03O000800012O00AC000100023O0020A20001000100030020D60001000100042O00CC0001000200020006232O01003200013O0004F03O003200012O00AC000100023O0020A20001000100050020D60001000100062O00CC0001000200020006232O01003200013O0004F03O003200012O00AC000100033O0006232O01003200013O0004F03O003200012O00AC000100043O0020F90001000100074O000300023O00202O0003000300084O00010003000200062O0001003200013O0004F03O003200012O00AC000100043O0020F90001000100074O000300023O00202O0003000300094O00010003000200062O0001003200013O0004F03O003200012O00AC000100054O00AC000200063O0020A200020002000A2O00CC0001000200020006232O01003200013O0004F03O003200012O00AC000100073O0012F10002000B3O0012F10003000C4O0087000100034O00A500016O00AC000100023O0020A200010001000D0020D60001000100062O00CC0001000200020006232O01005D00013O0004F03O005D00012O00AC000100083O0006232O01005D00013O0004F03O005D00012O00AC000100043O0020F90001000100074O000300023O00202O0003000300084O00010003000200062O0001005D00013O0004F03O005D00012O00AC000100043O0020F90001000100074O000300023O00202O0003000300094O00010003000200062O0001005D00013O0004F03O005D00012O00AC000100043O0020F90001000100074O000300023O00202O0003000300084O00010003000200062O0001005D00013O0004F03O005D00012O00AC000100054O00AC000200063O0020A200020002000E2O00CC0001000200020006232O01005D00013O0004F03O005D00012O00AC000100073O0012760002000F3O00122O000300106O000100036O00015O00044O005D00010004F03O000800012O004A3O00017O00103O0003073O0049735265616479028O0003103O004865616C746850657263656E7461676503063O0042752O66557003123O00536861646F77436F76656E616E7442752O6603123O004461726B52657072696D616E64466F637573031C3O00D2813C39E9922B22C4892333D8841134D9833B2196902B3CD78E2D3703043O0052B6E04E030C3O0050656E616E6365466F63757303153O0049FBD5E38C0E5CC1DDED81184ABECBE78C0C57FDDE03063O006D399EBB82E2032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66030E3O0049735370652O6C496E52616E6765030F3O002E3AF7F0303CFCB12E3AF7F0303CFC03043O00915E5F99014E4O00AC00015O0020D60001000100012O00CC0001000200020006232O01004D00013O0004F03O004D00010012F1000100023O0026C900010006000100020004F03O000600012O00AC000200013O0006230102002F00013O0004F03O002F00012O00AC000200013O0020D60002000200032O00CC0002000200022O00AC000300023O0006420002002F000100030004F03O002F00012O00AC000200033O0020F90002000200044O000400043O00202O0004000400054O00020004000200062O0002002400013O0004F03O002400012O00AC000200054O00AC000300063O0020A20003000300062O00CC0002000200020006230102002F00013O0004F03O002F00012O00AC000200073O001276000300073O00122O000400086O000200046O00025O00044O002F00012O00AC000200054O00AC000300063O0020A20003000300092O00CC0002000200020006230102002F00013O0004F03O002F00012O00AC000200073O0012F10003000A3O0012F10004000B4O0087000200044O00A500025O00069D3O004D000100010004F03O004D00012O00AC000200083O00201E00020002000C4O000300043O00202O00030003000D4O000400096O00058O00068O0002000600024O0003000A3O00062O0002004D000100030004F03O004D00012O00AC000200054O002001038O0004000B3O00202O00040004000E4O00068O0004000600024O000400046O00020004000200062O0002004D00013O0004F03O004D00012O00AC000200073O0012760003000F3O00122O000400106O000200046O00025O00044O004D00010004F03O000600012O004A3O00017O002A3O00028O00026O00F03F030D3O00506F776572576F72644C69666503073O004973526561647903103O004865616C746850657263656E7461676503063O0045786973747303123O00506F776572576F72644C696665466F637573031D3O00EDC203D05C88EAC206D171BBF4CB119546B2FCC12BD641B8F1C91BC24003063O00D79DAD74B52E030F3O004C756D696E6F757342612O72696572031D3O00417265556E69747342656C6F774865616C746850657263656E74616765031E3O0039A186FBD43AA198CDD834A699FBDF27F483F7DB398B88FDD539B084E5D403053O00BA55D4EB9203113O00506F776572576F726452616469616E636503063O0042752O66557003153O0052616469616E7450726F766964656E636542752O6603163O00506F776572576F726452616469616E6365466F63757303293O00D28E01FB2BD14FCD9312C12BEF5CCB8018FD3CD151CC9202FF37FA18CA8417F206ED57CD8D12F12EE003073O0038A2E1769E598E03063O007D0BD9A02CDD03063O00B83C65A0CF42030F3O005061696E53752O7072652O73696F6E03083O0042752O66446F776E03143O005061696E53752O7072652O73696F6E466F637573031E3O00218375B20E9169AC219079AF228B73B2718A79BD3DBD7FB33E8E78B3268C03043O00DC51E21C03093O0027D48CF0AAE81DD99B03063O00A773B5E29B8A03073O00436F2O6D6F6E73030D3O00556E697447726F7570526F6C6503043O00D603C97703073O00A68242873C1B11031E3O00544BC77B0F575FDE65224159DD7C3F4A0AC670314875CD7A3F484EC1623E03053O0050242AAE15030D3O007A1139710E11397E0E2332764803043O001A2E705703043O008D02855F03083O00D4D943CB142ODF2503063O0092A889FE9FBF03043O00B2DAEDC8031E3O00A6B4EFDE89A6F3C0A6A7E3C3A5BCE9DEF6BDE3D1BA8AE5DF2OB9E2DFA1BB03043O00B0D6D5860005012O0012F13O00013O0026C93O003E000100020004F03O003E00012O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O01002200013O0004F03O002200012O00AC000100013O0006232O01002200013O0004F03O002200012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC000200033O00064200010022000100020004F03O002200012O00AC000100023O0020D60001000100062O00CC0001000200020006232O01002200013O0004F03O002200012O00AC000100044O00AC000200053O0020A20002000200072O00CC0001000200020006232O01002200013O0004F03O002200012O00AC000100063O0012F1000200083O0012F1000300094O0087000100034O00A500016O00AC00015O0020A200010001000A0020D60001000100042O00CC0001000200020006232O0100042O013O0004F03O00042O012O00AC000100073O0006232O0100042O013O0004F03O00042O012O00AC000100083O0020002O010001000B4O000200096O0003000A6O00010003000200062O000100042O013O0004F03O00042O012O00AC000100044O00AC00025O0020A200020002000A2O00CC0001000200020006232O0100042O013O0004F03O00042O012O00AC000100063O0012760002000C3O00122O0003000D6O000100036O00015O00044O00042O010026C93O0001000100010004F03O000100012O00AC00015O0020A200010001000E0020D60001000100042O00CC0001000200020006232O01006400013O0004F03O006400012O00AC0001000B3O0006232O01006400013O0004F03O006400012O00AC000100083O0020002O010001000B4O0002000C6O0003000D6O00010003000200062O0001006400013O0004F03O006400012O00AC0001000E3O0020F900010001000F4O00035O00202O0003000300104O00010003000200062O0001006400013O0004F03O006400012O00AC000100044O0039000200053O00202O0002000200114O000300036O0004000F6O00010004000200062O0001006400013O0004F03O006400012O00AC000100063O0012F1000200123O0012F1000300134O0087000100034O00A500016O00AC000100104O00ED000200063O00122O000300143O00122O000400156O00020004000200062O0001008F000100020004F03O008F00012O00AC00015O0020A20001000100160020D60001000100042O00CC0001000200020006232O0100022O013O0004F03O00022O012O00AC000100023O0020F90001000100174O00035O00202O0003000300164O00010003000200062O000100022O013O0004F03O00022O012O00AC000100113O0006232O0100022O013O0004F03O00022O012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC000200123O000642000100022O0100020004F03O00022O012O00AC000100044O001B010200053O00202O0002000200184O000300046O000500016O00010005000200062O000100022O013O0004F03O00022O012O00AC000100063O001276000200193O00122O0003001A6O000100036O00015O00044O00022O012O00AC000100104O00ED000200063O00122O0003001B3O00122O0004001C6O00020004000200062O000100C4000100020004F03O00C400012O00AC00015O0020A20001000100160020D60001000100042O00CC0001000200020006232O0100022O013O0004F03O00022O012O00AC000100023O0020F90001000100174O00035O00202O0003000300164O00010003000200062O000100022O013O0004F03O00022O012O00AC000100113O0006232O0100022O013O0004F03O00022O012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC000200123O000642000100022O0100020004F03O00022O0100124F0001001D3O00204300010001001E4O000200026O0001000200024O000200063O00122O0003001F3O00122O000400206O00020004000200062O000100022O0100020004F03O00022O012O00AC000100044O001B010200053O00202O0002000200184O000300046O000500016O00010005000200062O000100022O013O0004F03O00022O012O00AC000100063O001276000200213O00122O000300226O000100036O00015O00044O00022O012O00AC000100104O00ED000200063O00122O000300233O00122O000400246O00020004000200062O000100022O0100020004F03O00022O012O00AC00015O0020A20001000100160020D60001000100042O00CC0001000200020006232O0100022O013O0004F03O00022O012O00AC000100023O0020F90001000100174O00035O00202O0003000300164O00010003000200062O000100022O013O0004F03O00022O012O00AC000100113O0006232O0100022O013O0004F03O00022O012O00AC000100023O0020D60001000100052O00CC0001000200022O00AC000200123O000642000100022O0100020004F03O00022O0100124F0001001D3O00200100010001001E4O000200026O0001000200024O000200063O00122O000300253O00122O000400266O00020004000200062O000100F5000100020004F03O00F5000100124F0001001D3O00204300010001001E4O000200026O0001000200024O000200063O00122O000300273O00122O000400286O00020004000200062O000100022O0100020004F03O00022O012O00AC000100044O001B010200053O00202O0002000200184O000300046O000500016O00010005000200062O000100022O013O0004F03O00022O012O00AC000100063O0012F1000200293O0012F10003002A4O0087000100034O00A500015O0012F13O00023O0004F03O000100012O004A3O00017O004A3O00028O00027O0040030F3O00506F776572576F7264536869656C6403073O0049735265616479030D3O00556E697447726F7570526F6C6503043O00C08C98FF03073O003994CDD6B4C83603103O004865616C746850657263656E7461676503083O0042752O66446F776E030D3O0041746F6E656D656E7442752O6603063O0045786973747303143O00506F776572576F7264536869656C64466F637573031B3O0002F22231642DEA3A26722DEE2O3D731EF90A20771CF6753C7313F103053O0016729D555403093O00466C6173684865616C030C3O0042696E64696E674865616C73030B3O004973417661696C61626C6503043O0047554944030E3O00466C6173684865616C466F637573030F3O00C2C712D755C9A0C1CA1F8455F3A9C803073O00C8A4AB73A43D9603163O00AEFB14409181E30C578781E70B4C86B2F0434D86BFF803053O00E3DE94632503053O0052656E6577030A3O0052656E6577466F637573030A3O0021575CF3EE735A57F7F503053O0099532O3296026O000840030F3O00412O66656374696E67436F6D626174030D3O00546172676574497356616C6964030C3O0053686F756C6452657475726E03133O005B7A720F7B944558777F237CA44E1D7E761D7F03073O002D3D16137C13CB026O00F03F03093O004973496E52616E6765026O003E4003133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C6179657203103O00C52O1BFC0C7586D2060CE74278BCC01E03073O00D9A1726D956210030A3O004576616E67656C69736D03273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403083O004973496E5261696403093O004973496E5061727479032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74030F3O0017363972BB711E292B71FC7C17213403063O00147240581CDC03063O0042752O665570030C3O0053757267656F664C6967687403173O00370DD3A7F0EFB53400DE8BF1DEAE2500DCA0B8D8B8300D03073O00DD5161B2D498B003073O005261707475726503323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030C3O0052617074757265466F637573030C3O00DFE60DEF0FDFE25DF31FCCEB03053O007AAD877D9B03113O00506F776572576F726452616469616E6365031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503153O0052616469616E7450726F766964656E636542752O6603163O00506F776572576F726452616469616E6365466F63757303293O0094CE17BC2D0EDF8BD304862D30CC8DC00EBA3A0EC18AD214B83125888CC401B50032C78BCD04B6283F03073O00A8E4A160D95F51030D3O00506F776572576F72644C69666503123O00506F776572576F72644C696665466F637573031D3O00CBDE39593D68CCDE3C58105BD2D72B1C2752DADD115F2058D7D5214B2103063O0037BBB14E3C4F030E3O00536861646F77436F76656E616E74030C3O00432O6F6C646F776E446F776E031A3O003DC148EE54F09722DC5BD454CE8424CF51E8438FD26DC65AEA4A03073O00E04DAE3F8B26AF030A3O0048616C6F506C61796572026O00384003093O008C405421C4495D2F8803043O004EE42138009A022O0012F13O00013O000E7C000200BF00013O0004F03O00BF00012O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O01003700013O0004F03O003700012O00AC000100013O0020430001000100054O000200026O0001000200024O000200033O00122O000300063O00122O000400076O00020004000200062O00010037000100020004F03O003700012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC000200043O00063D00010037000100020004F03O003700012O00AC000100023O0020530001000100094O00035O00202O00030003000A4O00010003000200062O00010027000100010004F03O002700012O00AC000100023O0020F90001000100094O00035O00202O0003000300034O00010003000200062O0001003700013O0004F03O003700012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01003700013O0004F03O003700012O00AC000100054O00AC000200063O0020A200020002000C2O00CC0001000200020006232O01003700013O0004F03O003700012O00AC000100033O0012F10002000D3O0012F10003000E4O0087000100034O00A500016O00AC00015O0020A200010001000F0020D60001000100042O00CC0001000200020006232O01007100013O0004F03O007100012O00AC00015O0020A20001000100100020D60001000100112O00CC0001000200020006232O01007100013O0004F03O007100012O00AC000100023O0020292O01000100124O0001000200024O000200073O00202O0002000200124O00020002000200062O00010071000100020004F03O007100012O00AC000100023O0020F90001000100094O00035O00202O00030003000A4O00010003000200062O0001007100013O0004F03O007100012O00AC000100073O0020F90001000100094O00035O00202O00030003000A4O00010003000200062O0001007100013O0004F03O007100012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC000200083O00063D00010071000100020004F03O007100012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01007100013O0004F03O007100012O00AC000100054O0039000200063O00202O0002000200134O000300036O000400096O00010004000200062O0001007100013O0004F03O007100012O00AC000100033O0012F1000200143O0012F1000300154O0087000100034O00A500016O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O01009400013O0004F03O009400012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC0002000A3O00063D00010094000100020004F03O009400012O00AC000100023O0020F90001000100094O00035O00202O00030003000A4O00010003000200062O0001009400013O0004F03O009400012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01009400013O0004F03O009400012O00AC000100054O00AC000200063O0020A200020002000C2O00CC0001000200020006232O01009400013O0004F03O009400012O00AC000100033O0012F1000200163O0012F1000300174O0087000100034O00A500016O00AC00015O0020A20001000100180020D60001000100042O00CC0001000200020006232O0100BE00013O0004F03O00BE00012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC0002000B3O00063D000100BE000100020004F03O00BE00012O00AC000100023O0020F90001000100094O00035O00202O00030003000A4O00010003000200062O000100BE00013O0004F03O00BE00012O00AC000100023O0020F90001000100094O00035O00202O0003000300184O00010003000200062O000100BE00013O0004F03O00BE00012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O0100BE00013O0004F03O00BE00012O00AC000100054O00AC000200063O0020A20002000200192O00CC0001000200020006232O0100BE00013O0004F03O00BE00012O00AC000100033O0012F10002001A3O0012F10003001B4O0087000100034O00A500015O0012F13O001C3O000E7C001C00182O013O0004F03O00182O012O00AC0001000C3O0020D60001000100042O00CC0001000200020006232O0100EC00013O0004F03O00EC00012O00AC0001000D3O0006232O0100EC00013O0004F03O00EC00012O00AC000100073O0020D600010001001D2O00CC0001000200020006232O0100D300013O0004F03O00D300012O00AC000100013O0020A200010001001E2O003A00010001000200069D000100EC000100010004F03O00EC00012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC0002000E3O00063D000100EC000100020004F03O00EC00012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O0100EC00013O0004F03O00EC00010012F1000100013O0026C9000100DF000100010004F03O00DF00012O00AC0002000F4O008F000300016O00020002000200122O0002001F3O00122O0002001F3O00062O000200EC00013O0004F03O00EC000100124F0002001F4O0021010200023O0004F03O00EC00010004F03O00DF00012O00AC00015O0020A200010001000F0020D60001000100042O00CC0001000200020006232O01009902013O0004F03O009902012O00AC0001000D3O0006232O01009902013O0004F03O009902012O00AC000100073O0020D600010001001D2O00CC0001000200020006232O0100FF00013O0004F03O00FF00012O00AC000100013O0020A200010001001E2O003A00010001000200069D00010099020100010004F03O009902012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC000200103O00063D00010099020100020004F03O009902012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01009902013O0004F03O009902012O00AC000100054O001B010200063O00202O0002000200134O000300036O000400016O00010004000200062O0001009902013O0004F03O009902012O00AC000100033O001276000200203O00122O000300216O000100036O00015O00044O009902010026C93O00F32O0100220004F03O00F32O012O00AC000100113O0020D60001000100042O00CC0001000200020006232O01003D2O013O0004F03O003D2O012O00AC000100013O0020A200010001001E2O003A0001000100020006232O01003D2O013O0004F03O003D2O012O00AC000100123O0020D60001000100230012F1000300244O007E0001000300020006232O01003D2O013O0004F03O003D2O012O00AC000100133O0006232O01003D2O013O0004F03O003D2O012O00AC000100023O0020D60001000100252O00CC00010002000200069D0001003D2O0100010004F03O003D2O012O00AC000100054O00AC000200063O0020A20002000200262O00CC0001000200020006232O01003D2O013O0004F03O003D2O012O00AC000100033O0012F1000200273O0012F1000300284O0087000100034O00A500016O00AC00015O0020A20001000100290020D60001000100042O00CC0001000200020006232O0100752O013O0004F03O00752O012O00AC000100143O0006232O0100752O013O0004F03O00752O012O00AC000100153O0006232O0100752O013O0004F03O00752O012O00AC000100073O0020D600010001001D2O00CC0001000200020006232O0100752O013O0004F03O00752O012O00AC000100013O00203B00010001002A4O000200166O0001000200024O000200173O00062O000200752O0100010004F03O00752O012O00AC000100073O0020D600010001002B2O00CC00010002000200069D000100752O0100010004F03O00752O012O00AC000100073O0020D600010001002C2O00CC0001000200020006232O0100752O013O0004F03O00752O012O00AC000100013O00201E00010001002D4O00025O00202O00020002000A4O000300186O00048O00058O0001000500024O000200193O00062O000100752O0100020004F03O00752O012O00AC000100054O00AC00025O0020A20002000200292O00CC0001000200020006232O0100752O013O0004F03O00752O012O00AC000100033O0012F10002002E3O0012F10003002F4O0087000100034O00A500016O00AC00015O0020A200010001000F0020D60001000100042O00CC0001000200020006232O0100AF2O013O0004F03O00AF2O012O00AC000100023O0020530001000100094O00035O00202O00030003000A4O00010003000200062O000100902O0100010004F03O00902O012O00AC000100023O0020F90001000100094O00035O00202O0003000300034O00010003000200062O000100AF2O013O0004F03O00AF2O012O00AC000100023O0020F90001000100094O00035O00202O0003000300184O00010003000200062O000100AF2O013O0004F03O00AF2O012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC0002001A3O00063D000100AF2O0100020004F03O00AF2O012O00AC000100073O0020F90001000100304O00035O00202O0003000300314O00010003000200062O000100AF2O013O0004F03O00AF2O012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O0100AF2O013O0004F03O00AF2O012O00AC000100054O0039000200063O00202O0002000200134O000300036O000400096O00010004000200062O000100AF2O013O0004F03O00AF2O012O00AC000100033O0012F1000200323O0012F1000300334O0087000100034O00A500016O00AC00015O0020A20001000100340020D60001000100042O00CC0001000200020006232O0100F22O013O0004F03O00F22O012O00AC000100073O0020D600010001002B2O00CC00010002000200069D000100F22O0100010004F03O00F22O012O00AC000100073O0020D600010001002C2O00CC0001000200020006232O0100F22O013O0004F03O00F22O012O00AC0001001B3O0006232O0100F22O013O0004F03O00F22O012O00AC000100143O0006232O0100F22O013O0004F03O00F22O012O00AC000100073O0020D600010001001D2O00CC0001000200020006232O0100F22O013O0004F03O00F22O012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC0002001C3O00063D000100F22O0100020004F03O00F22O012O00AC000100013O00201E0001000100354O00025O00202O00020002000A4O000300186O00048O00058O0001000500024O0002001D3O00062O000200F22O0100010004F03O00F22O012O00AC000100023O0020F90001000100094O00035O00202O00030003000A4O00010003000200062O000100F22O013O0004F03O00F22O012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O0100F22O013O0004F03O00F22O012O00AC000100054O00AC000200063O0020A20002000200362O00CC0001000200020006232O0100F22O013O0004F03O00F22O012O00AC000100033O0012F1000200373O0012F1000300384O0087000100034O00A500015O0012F13O00023O0026C93O0001000100010004F03O000100012O00AC00015O0020A20001000100390020D60001000100042O00CC0001000200020006232O01001E02013O0004F03O001E02012O00AC0001001E3O0006232O01001E02013O0004F03O001E02012O00AC000100013O0020002O010001003A4O0002001F6O000300206O00010003000200062O0001001E02013O0004F03O001E02012O00AC000100073O0020F90001000100304O00035O00202O00030003003B4O00010003000200062O0001001E02013O0004F03O001E02012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01001E02013O0004F03O001E02012O00AC000100054O0039000200063O00202O00020002003C4O000300036O000400216O00010004000200062O0001001E02013O0004F03O001E02012O00AC000100033O0012F10002003D3O0012F10003003E4O0087000100034O00A500016O00AC00015O0020A200010001003F0020D60001000100042O00CC0001000200020006232O01003D02013O0004F03O003D02012O00AC000100223O0006232O01003D02013O0004F03O003D02012O00AC000100023O0020D60001000100082O00CC0001000200022O00AC000200233O0006420001003D020100020004F03O003D02012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01003D02013O0004F03O003D02012O00AC000100054O00AC000200063O0020A20002000200402O00CC0001000200020006232O01003D02013O0004F03O003D02012O00AC000100033O0012F1000200413O0012F1000300424O0087000100034O00A500016O00AC00015O0020A20001000100390020D60001000100042O00CC0001000200020006232O01006C02013O0004F03O006C02012O00AC0001001E3O0006232O01006C02013O0004F03O006C02012O00AC000100013O0020002O010001003A4O0002001F6O000300206O00010003000200062O0001006C02013O0004F03O006C02012O00AC000100023O0020530001000100094O00035O00202O00030003000A4O00010003000200062O0001005A020100010004F03O005A02012O00AC00015O0020A20001000100430020D60001000100442O00CC0001000200020006232O01006C02013O0004F03O006C02012O00AC000100023O0020D600010001000B2O00CC0001000200020006232O01006C02013O0004F03O006C02012O00AC000100054O0039000200063O00202O00020002003C4O000300036O000400216O00010004000200062O0001006C02013O0004F03O006C02012O00AC000100033O0012F1000200453O0012F1000300464O0087000100034O00A500016O00AC000100243O0020D60001000100042O00CC0001000200020006232O01009702013O0004F03O009702012O00AC000100013O0020A200010001001E2O003A0001000100020006232O01009702013O0004F03O009702012O00AC000100123O0020D60001000100230012F1000300244O007E0001000300020006232O01009702013O0004F03O009702012O00AC000100253O0006232O01009702013O0004F03O009702012O00AC000100013O0020002O010001003A4O000200266O000300276O00010003000200062O0001009702013O0004F03O009702012O00AC000100054O00BD000200063O00202O0002000200474O000300023O00202O00030003002300122O000500486O0003000500024O000300036O000400016O00010004000200062O0001009702013O0004F03O009702012O00AC000100033O0012F1000200493O0012F10003004A4O0087000100034O00A500015O0012F13O00223O0004F03O000100012O004A3O00017O00193O00028O00030E3O0050757267655468655769636B656403073O0049735265616479030A3O00446562752O66446F776E03143O0050757267655468655769636B6564446562752O6603093O0054696D65546F446965030C3O00426173654475726174696F6E026O33D33F030E3O0049735370652O6C496E52616E6765031A3O00DE6BA00480F16ABA06BAD977B10880CA3EA21180DE41A1008AD803053O00E5AE1ED26303093O004D696E64426C61737403143O0016E48855D23F351AFE9211FD2F3C0BD29552E22B03073O00597B8DE6318D5D026O00F03F027O0040031C3O00E364E40B1575E779F3330743F07AF308505AE174E6330349FC67B65E03063O002A9311966C70030F3O00506F776572576F7264536F6C616365031B3O001FA93A7AF5D718A93F7BD8FB00AA2C7CE2A81FB4286FD8FB0CA93B03063O00886FC64D1F8703053O00536D697465030A3O0049734361737461626C65030F3O001104AE42B8A407BB07199845BEEB0103083O00C96269C736DD847700A53O0012F13O00013O0026C93O0047000100010004F03O004700012O00AC00015O0020A20001000100020020D60001000100032O00CC0001000200020006232O01002B00013O0004F03O002B00012O00AC000100013O0020F90001000100044O00035O00202O0003000300054O00010003000200062O0001002B00013O0004F03O002B00012O00AC000100013O00201C2O01000100064O0001000200024O00025O00202O00020002000500202O0002000200074O00020002000200102O00020008000200062O0002002B000100010004F03O002B00012O00AC000100024O00A400025O00202O0002000200024O000300013O00202O0003000300094O00055O00202O0005000500024O0003000500024O000300036O00010003000200062O0001002B00013O0004F03O002B00012O00AC000100033O0012F10002000A3O0012F10003000B4O0087000100034O00A500016O00AC00015O0020A200010001000C0020D60001000100032O00CC0001000200020006232O01004600013O0004F03O004600012O00AC000100043O00069D00010046000100010004F03O004600012O00AC000100024O00AA00025O00202O00020002000C4O000300013O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O000400016O00010004000200062O0001004600013O0004F03O004600012O00AC000100033O0012F10002000D3O0012F10003000E4O0087000100034O00A500015O0012F13O000F3O0026C93O006B000100100004F03O006B00012O00AC00015O0020A20001000100020020D60001000100032O00CC0001000200020006232O0100A400013O0004F03O00A400012O00AC000100013O00201C2O01000100064O0001000200024O00025O00202O00020002000500202O0002000200074O00020002000200102O00020008000200062O000200A4000100010004F03O00A400012O00AC000100024O00A400025O00202O0002000200024O000300013O00202O0003000300094O00055O00202O0005000500024O0003000500024O000300036O00010003000200062O000100A400013O0004F03O00A400012O00AC000100033O001276000200113O00122O000300126O000100036O00015O00044O00A400010026C93O00010001000F0004F03O000100012O00AC00015O0020A20001000100130020D60001000100032O00CC0001000200020006232O01008700013O0004F03O008700012O00AC000100043O00069D00010087000100010004F03O008700012O00AC000100024O00A400025O00202O0002000200134O000300013O00202O0003000300094O00055O00202O0005000500134O0003000500024O000300036O00010003000200062O0001008700013O0004F03O008700012O00AC000100033O0012F1000200143O0012F1000300154O0087000100034O00A500016O00AC00015O0020A20001000100160020D60001000100172O00CC0001000200020006232O0100A200013O0004F03O00A200012O00AC000100043O00069D000100A2000100010004F03O00A200012O00AC000100024O00AA00025O00202O0002000200164O000300013O00202O0003000300094O00055O00202O0005000500164O0003000500024O000300036O000400016O00010004000200062O000100A200013O0004F03O00A200012O00AC000100033O0012F1000200183O0012F1000300194O0087000100034O00A500015O0012F13O00103O0004F03O000100012O004A3O00017O005B3O00028O00027O0040030C3O0053686F756C6452657475726E03123O00A9098D200C36A9F91F8B2E102193AA0F8C3703073O00CCD96CE341625503073O0049735265616479030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40026O00F03F030A3O0048616C6F506C61796572026O00384003113O0056C2F9EA6C921ED0FDEA3ED461D0F6EA3A03063O00A03EA395854C03133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C6179657203183O00D2A91B26CDD39F1E3BC2C4E05F6FD0DEAF1F3BFCC5A3023903053O00A3B6C06D4F030F3O00536861646F77576F7264446561746803103O004865616C746850657263656E74616765026O003440030E3O0049735370652O6C496E52616E6765031E3O00272E01C4FA231917CFE7301904C5F4202E4092B5272E0FD2E10B3503CFE303053O0095544660A0026O000840026O00104003113O00300701E278554DFE30091FF907150EE22E03043O008D58666D03093O004D696E64426C61737403173O00BE5AC474253F59C0A0478A225A2E5DCEA147F56319324303083O00A1D333AA107A5D3503183O00FFA7A421F5AB8D3BEFAFA068A8EEA120F4BCA617E8ADBD3E03043O00489BCED203073O0054696D65546F58030B3O0042752O6652656D61696E7303123O00536861646F77436F76656E616E7442752O66031E3O005572550A3C51454301214245500B325272145A7355725B1C27796957012503053O0053261A346E026O00144003093O00457870696174696F6E030B3O004973417661696C61626C6503173O00551E294267152B474B03671718042F494A0318555B183103043O002638774703093O004D696E6467616D657303143O005368612O746572656450657263657074696F6E7303163O00FEE656D22257FEEA4B967416E0E757C43169E0EC57C003063O0036938F38B645031E3O00C589FE4DD0C1BEE846CDD2BEFB4CDEC289BF1A9FC589F05BCBE992FC46C903053O00BFB6E19F2903163O00261B26518C86CF2E016807CB94CA24003C6A9884CD3D03073O00A24B724835EBE7030E3O0050757267655468655769636B656403113O00446562752O665265667265736861626C6503143O0050757267655468655769636B6564446562752O6603093O0054696D65546F446965030C3O00426173654475726174696F6E026O33D33F031B3O009C2956E5563D983441DD440B8F3741E61311843356F66C118F335203063O0062EC5C248233031E3O00B7110DBE4ABF8A27AB0B088541ADB424AC595DFA56A0BA22B0261FB94ABE03083O0050C4796CDA25C8D503323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O6603123O0010760C7E450D8F40600A70591AB513700D6903073O00EA6013621F2B6E030B3O004C6967687473577261746803173O000A1655CFB861B4110D53D3A432980E1040D39361882O0903073O00EB667F32A7CC12030F3O00506F776572576F7264536F6C616365031C3O0040AEE226561147AEE7277B3D5FADF420416E43A9FA31501143A2FA3503063O004E30C195432403083O00486F6C794E6F766103093O0042752O66537461636B030C3O0052686170736F647942752O66026O00284003143O0038118C017E3E1196190123168F0A550F0D83175703053O0021507EE07803053O00536D69746503103O00FFA50AD059ACBB0BCB4EF89710C753FA03053O003C8CC863A4030E3O00536861646F77436F76656E616E7403133O00536861646F77436F76656E616E74466F637573031A3O0094FC0522AD90CB0729B482FA0528B6C7E70C29B093CB1725AD9103053O00C2E794644603063O0053636869736D031A3O005544C0A7F9DF794FCEB5F3C64742D5E3E5C0495ED59CE5CB495A03063O00A8262CA1C39603113O0088FD8E7970B9F60588F390620FFBB5199603083O0076E09CE2165088D603183O0046E74F894CEB669356EF4BC013AE4A884DFC4DBF51ED569603043O00E0228E3900D5022O0012F13O00013O0026C93O0074000100020004F03O0074000100124F000100033O0006232O01000B00013O0004F03O000B00012O00AC00015O0012F1000200043O0012F1000300054O0087000100034O00A500016O00AC000100013O0020D60001000100062O00CC0001000200020006232O01002F00013O0004F03O002F00012O00AC000100023O0020A20001000100072O003A0001000100020006232O01002F00013O0004F03O002F00012O00AC000100033O0020D60001000100080012F1000300094O007E0001000300020006232O01002F00013O0004F03O002F00012O00AC000100043O000E06010A002F000100010004F03O002F00012O00AC000100054O00BD000200063O00202O00020002000B4O000300033O00202O00030003000800122O0005000C6O0003000500024O000300036O000400016O00010004000200062O0001002F00013O0004F03O002F00012O00AC00015O0012F10002000D3O0012F10003000E4O0087000100034O00A500016O00AC000100073O0020D60001000100062O00CC0001000200020006232O01005700013O0004F03O005700012O00AC000100023O0020A20001000100072O003A0001000100020006232O01005700013O0004F03O005700012O00AC000100033O0020D60001000100080012F1000300094O007E0001000300020006232O01005700013O0004F03O005700012O00AC000100033O0020D600010001000F2O00CC00010002000200069D00010057000100010004F03O005700012O00AC000100043O000E06010A0057000100010004F03O005700012O00AC000100054O009E000200063O00202O0002000200104O000300033O00202O00030003000800122O0005000C6O0003000500024O000300036O00010003000200062O0001005700013O0004F03O005700012O00AC00015O0012F1000200113O0012F1000300124O0087000100034O00A500016O00AC000100083O0020A20001000100130020D60001000100062O00CC0001000200020006232O01007300013O0004F03O007300012O00AC000100033O0020D60001000100142O00CC00010002000200266000010073000100150004F03O007300012O00AC000100054O00A4000200083O00202O0002000200134O000300033O00202O0003000300164O000500083O00202O0005000500134O0003000500024O000300036O00010003000200062O0001007300013O0004F03O007300012O00AC00015O0012F1000200173O0012F1000300184O0087000100034O00A500015O0012F13O00193O0026C93O00F70001001A0004F03O00F700012O00AC000100013O0020D60001000100062O00CC0001000200020006232O01009700013O0004F03O009700012O00AC000100023O0020A20001000100072O003A0001000100020006232O01009700013O0004F03O009700012O00AC000100033O0020D60001000100080012F1000300094O007E0001000300020006232O01009700013O0004F03O009700012O00AC000100054O00BD000200063O00202O00020002000B4O000300033O00202O00030003000800122O0005000C6O0003000500024O000300036O000400016O00010004000200062O0001009700013O0004F03O009700012O00AC00015O0012F10002001B3O0012F10003001C4O0087000100034O00A500016O00AC000100083O0020A200010001001D0020D60001000100062O00CC0001000200020006232O0100AF00013O0004F03O00AF00012O00AC000100054O00AA000200083O00202O00020002001D4O000300033O00202O0003000300164O000500083O00202O00050005001D4O0003000500024O000300036O000400016O00010004000200062O000100AF00013O0004F03O00AF00012O00AC00015O0012F10002001E3O0012F10003001F4O0087000100034O00A500016O00AC000100073O0020D60001000100062O00CC0001000200020006232O0100D400013O0004F03O00D400012O00AC000100023O0020A20001000100072O003A0001000100020006232O0100D400013O0004F03O00D400012O00AC000100033O0020D60001000100080012F1000300094O007E0001000300020006232O0100D400013O0004F03O00D400012O00AC000100033O0020D600010001000F2O00CC00010002000200069D000100D4000100010004F03O00D400012O00AC000100054O009E000200063O00202O0002000200104O000300033O00202O00030003000800122O0005000C6O0003000500024O000300036O00010003000200062O000100D400013O0004F03O00D400012O00AC00015O0012F1000200203O0012F1000300214O0087000100034O00A500016O00AC000100083O0020A20001000100130020D60001000100062O00CC0001000200020006232O0100F600013O0004F03O00F600012O00AC000100033O00201700010001002200122O000300156O0001000300024O000200093O00202O0002000200234O000400083O00202O0004000400244O00020004000200062O000200F6000100010004F03O00F600012O00AC000100054O00A4000200083O00202O0002000200134O000300033O00202O0003000300164O000500083O00202O0005000500134O0003000500024O000300036O00010003000200062O000100F600013O0004F03O00F600012O00AC00015O0012F1000200253O0012F1000300264O0087000100034O00A500015O0012F13O00273O0026C93O00762O0100190004F03O00762O012O00AC000100083O0020A200010001001D0020D60001000100062O00CC0001000200020006232O0100172O013O0004F03O00172O012O00AC000100083O0020A20001000100280020D60001000100292O00CC0001000200020006232O0100172O013O0004F03O00172O012O00AC000100054O00AA000200083O00202O00020002001D4O000300033O00202O0003000300164O000500083O00202O00050005001D4O0003000500024O000300036O000400016O00010004000200062O000100172O013O0004F03O00172O012O00AC00015O0012F10002002A3O0012F10003002B4O0087000100034O00A500016O00AC000100083O0020A200010001002C0020D60001000100062O00CC0001000200020006232O0100352O013O0004F03O00352O012O00AC000100083O0020A200010001002D0020D60001000100292O00CC0001000200020006232O0100352O013O0004F03O00352O012O00AC000100054O00AA000200083O00202O00020002002C4O000300033O00202O0003000300164O000500083O00202O00050005002C4O0003000500024O000300036O000400016O00010004000200062O000100352O013O0004F03O00352O012O00AC00015O0012F10002002E3O0012F10003002F4O0087000100034O00A500016O00AC000100083O0020A20001000100130020D60001000100062O00CC0001000200020006232O01005D2O013O0004F03O005D2O012O00AC000100083O0020A20001000100280020D60001000100292O00CC0001000200020006232O01005D2O013O0004F03O005D2O012O00AC000100033O00201700010001002200122O000300156O0001000300024O000200093O00202O0002000200234O000400083O00202O0004000400244O00020004000200062O0002005D2O0100010004F03O005D2O012O00AC000100054O00A4000200083O00202O0002000200134O000300033O00202O0003000300164O000500083O00202O0005000500134O0003000500024O000300036O00010003000200062O0001005D2O013O0004F03O005D2O012O00AC00015O0012F1000200303O0012F1000300314O0087000100034O00A500016O00AC000100083O0020A200010001002C0020D60001000100062O00CC0001000200020006232O0100752O013O0004F03O00752O012O00AC000100054O00AA000200083O00202O00020002002C4O000300033O00202O0003000300164O000500083O00202O00050005002C4O0003000500024O000300036O000400016O00010004000200062O000100752O013O0004F03O00752O012O00AC00015O0012F1000200323O0012F1000300334O0087000100034O00A500015O0012F13O001A3O0026C93O00E52O01000A0004F03O00E52O012O00AC000100083O0020A20001000100340020D60001000100062O00CC0001000200020006232O0100A02O013O0004F03O00A02O012O00AC000100033O0020F90001000100354O000300083O00202O0003000300364O00010003000200062O000100A02O013O0004F03O00A02O012O00AC000100033O00201C2O01000100374O0001000200024O000200083O00202O00020002003600202O0002000200384O00020002000200102O00020039000200062O000200A02O0100010004F03O00A02O012O00AC000100054O00A4000200083O00202O0002000200344O000300033O00202O0003000300164O000500083O00202O0005000500344O0003000500024O000300036O00010003000200062O000100A02O013O0004F03O00A02O012O00AC00015O0012F10002003A3O0012F10003003B4O0087000100034O00A500016O00AC000100083O0020A20001000100130020D60001000100062O00CC0001000200020006232O0100C22O013O0004F03O00C22O012O00AC000100033O0020D60001000100142O00CC000100020002002660000100C22O0100150004F03O00C22O012O00AC000100083O0020A20001000100280020D60001000100292O00CC0001000200020006232O0100C22O013O0004F03O00C22O012O00AC000100054O00A4000200083O00202O0002000200134O000300033O00202O0003000300164O000500083O00202O0005000500134O0003000500024O000300036O00010003000200062O000100C22O013O0004F03O00C22O012O00AC00015O0012F10002003C3O0012F10003003D4O0087000100034O00A500016O00AC0001000A3O0020D60001000100062O00CC0001000200020006232O0100E12O013O0004F03O00E12O012O00AC000100023O0020092O010001003E4O000200083O00202O00020002003F4O0003000B6O00048O00058O0001000500024O0002000C3O00062O000100E12O0100020004F03O00E12O012O00AC000100054O00200102000A6O000300033O00202O0003000300164O0005000A6O0003000500024O000300036O00010003000200062O000100E12O013O0004F03O00E12O012O00AC00015O0012F1000200403O0012F1000300414O0087000100034O00A500016O00AC0001000D4O003A00010001000200123F000100033O0012F13O00023O0026C93O0058020100270004F03O005802012O00AC000100083O0020A20001000100420020D60001000100062O00CC0001000200020006232O0100FF2O013O0004F03O00FF2O012O00AC000100054O00AA000200083O00202O0002000200424O000300033O00202O0003000300164O000500083O00202O0005000500424O0003000500024O000300036O000400016O00010004000200062O000100FF2O013O0004F03O00FF2O012O00AC00015O0012F1000200433O0012F1000300444O0087000100034O00A500016O00AC000100083O0020A20001000100450020D60001000100062O00CC0001000200020006232O01001602013O0004F03O001602012O00AC000100054O00A4000200083O00202O0002000200454O000300033O00202O0003000300164O000500083O00202O0005000500454O0003000500024O000300036O00010003000200062O0001001602013O0004F03O001602012O00AC00015O0012F1000200463O0012F1000300474O0087000100034O00A500016O00AC000100083O0020A20001000100480020D60001000100062O00CC0001000200020006232O01003F02013O0004F03O003F02012O00AC000100093O00203E0001000100494O000300083O00202O00030003004A4O00010003000200262O0001003F020100150004F03O003F02012O00AC0001000E3O000ED90002003F020100010004F03O003F02012O00AC000100054O0007000200083O00202O0002000200484O000300033O00202O00030003000800122O0005004B6O00030005000200062O00030035020100010004F03O003502012O00AC0003000F3O00206D00030003000800122O0005004B6O0003000500024O000300033O00044O003702012O001001036O0056000300014O007E0001000300020006232O01003F02013O0004F03O003F02012O00AC00015O0012F10002004C3O0012F10003004D4O0087000100034O00A500016O00AC000100083O0020A200010001004E0020D60001000100062O00CC0001000200020006232O0100D402013O0004F03O00D402012O00AC000100054O00AA000200083O00202O00020002004E4O000300033O00202O0003000300164O000500083O00202O00050005004E4O0003000500024O000300036O000400016O00010004000200062O000100D402013O0004F03O00D402012O00AC00015O0012760002004F3O00122O000300506O000100036O00015O00044O00D402010026C93O0001000100010004F03O000100012O00AC000100083O0020A20001000100510020D60001000100062O00CC0001000200020006232O01006E02013O0004F03O006E02012O00AC0001000F3O0006232O01006E02013O0004F03O006E02012O00AC000100054O00AC000200063O0020A20002000200522O00CC0001000200020006232O01006E02013O0004F03O006E02012O00AC00015O0012F1000200533O0012F1000300544O0087000100034O00A500016O00AC000100083O0020A20001000100550020D60001000100062O00CC0001000200020006232O01008602013O0004F03O008602012O00AC000100054O00AA000200083O00202O0002000200554O000300033O00202O0003000300164O000500083O00202O0005000500554O0003000500024O000300036O000400016O00010004000200062O0001008602013O0004F03O008602012O00AC00015O0012F1000200563O0012F1000300574O0087000100034O00A500016O00AC000100013O0020D60001000100062O00CC0001000200020006232O0100AA02013O0004F03O00AA02012O00AC000100023O0020A20001000100072O003A0001000100020006232O0100AA02013O0004F03O00AA02012O00AC000100033O0020D60001000100080012F1000300094O007E0001000300020006232O0100AA02013O0004F03O00AA02012O00AC000100043O000E06010A00AA020100010004F03O00AA02012O00AC000100054O00BD000200063O00202O00020002000B4O000300033O00202O00030003000800122O0005000C6O0003000500024O000300036O000400016O00010004000200062O000100AA02013O0004F03O00AA02012O00AC00015O0012F1000200583O0012F1000300594O0087000100034O00A500016O00AC000100073O0020D60001000100062O00CC0001000200020006232O0100D202013O0004F03O00D202012O00AC000100023O0020A20001000100072O003A0001000100020006232O0100D202013O0004F03O00D202012O00AC000100033O0020D60001000100080012F1000300094O007E0001000300020006232O0100D202013O0004F03O00D202012O00AC000100033O0020D600010001000F2O00CC00010002000200069D000100D2020100010004F03O00D202012O00AC000100043O000E06010A00D2020100010004F03O00D202012O00AC000100054O009E000200063O00202O0002000200104O000300033O00202O00030003000800122O0005000C6O0003000500024O000300036O00010003000200062O000100D202013O0004F03O00D202012O00AC00015O0012F10002005A3O0012F10003005B4O0087000100034O00A500015O0012F13O000A3O0004F03O000100012O004A3O00017O00713O00028O00026O00104003053O00536D69746503073O0049735265616479030E3O0049735370652O6C496E52616E676503113O00CDAACCC976B10C4ED2A8CBDA4CE25E01C803083O006EBEC7A5BD13913D03083O00486F6C794E6F766103093O0042752O66537461636B030C3O0052686170736F647942752O66026O003440027O004003093O004973496E52616E6765026O00284003153O00D2E47BF1B4C9D5FD76A8DA87D6E479EFB4D4D9E46103063O00A7BA8B1788EB03093O004D696E6467616D657303153O0017BC86091DB4850809F5DB4D16BA860A25A68B020C03043O006D7AD5E803093O004D696E64426C61737403163O00E3FEAC34D1F5AE31FDE3E262AEFBAD3EE9C8B1332OE103043O00508E97C2030F3O00536861646F77576F72644465617468031D3O0010CE76480CD1485B0CD42O7307C376580B86240C0FC9794B3CD574431503043O002C63A617030D3O00546172676574497356616C6964026O003E4003133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C61796572026O00384003173O0078FE2O3F3DA143E43D3721E428B725393DA343E42A392503063O00C41C97495653026O001440030A3O0048616C6F506C6179657203103O00FB02251FC20C587AFC0D2E2F915B176003083O001693634970E23878030F3O00506F776572576F7264536F6C616365031D3O00A87AF5F09F8762EDE7898766EDF98CBB70A2A7CDB47AECF2B2AB76EDE303053O00EDD815829503153O008A4153468FC751944F1F0DF0C5518C49604CB3C64803073O003EE22E2O3FD0A903113O00F6145C971A4D7D1EE9165B84201E2C51F303083O003E857935E37F6D4F030E3O00536861646F77436F76656E616E7403133O00536861646F77436F76656E616E74466F63757303193O00031C33F1D9B99D131B24F0D8AFAC04543EFAD8A99D03173DE303073O00C270745295B6CE03063O0053636869736D03193O002AA04D1CCFF5313AA75A1DCEE3002DE84017CEE5312AAB430E03073O006E59C82C78A082026O00F03F03103O00A3C24749031B7B41A4CD4C795049345B03083O002DCBA32B26232A5B03173O00D68CCA2A89AC6BC191DD31C7F814DE8AD224B8BA57DD9303073O0034B2E5BC43E7C9030E3O0050757267655468655769636B656403113O00446562752O665265667265736861626C6503143O0050757267655468655769636B6564446562752O6603093O0054696D65546F446965030C3O00426173654475726174696F6E026O33D33F031A3O0031544203F2633729446F13FE5F2824451008F852241E52530BE103073O004341213064973C03103O004865616C746850657263656E7461676503093O00457870696174696F6E030B3O004973417661696C61626C65031D3O00CCEFAFDCFCC8D8B9D7E1DBD8AADDF2CBEFEE89B3D3E8A0DF2OCCE4A1CE03053O0093BF87CEB8026O00084003073O0054696D65546F58030B3O0042752O6652656D61696E7303123O00536861646F77436F76656E616E7442752O66031D3O009720A7C5D7448D9327B4C5E757B7853CAE818C13BE8B26A1FECB50BD9203073O00D2E448C6A1B833030B3O004C6967687473577261746803163O003A40F41867DD095EE11167C67645FC1E74F1254AFC0603063O00AE5629937013031D3O004B0F9A0E373006A44904B2182A0310A85E40DC4B29001FAC64138E043303083O00CB3B60ED6B456F7103323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O6603123O003413A2E03FF3D26405A4EE23E4E83715A3F703073O00B74476CC815190030C3O0053686F756C6452657475726E03133O001EA87EE505810BED22A4078D00AA4FF7088D1803063O00E26ECD10846B03143O005368612O746572656450657263657074696F6E7303153O00E6CAEEDD46EACEE5CA01BA83ECD64FECFCF3DA4EFD03053O00218BA380B9031D3O00445005DA584F3BC9584A00E1535D05CA5F18579E5B570AD9684B07D14103043O00BE37386403153O005BA6321A14E2FE53BC7C4C53EFFC58A8030D10ECE503073O009336CF5C7E738303164O00383B79327C013026694D2C4D3D3A730A411E323A6B03063O001E6D51551D6D03103O00F77058B9768DBCF37E5AB109CDFFF06703073O009C9F1134D656BE03173O00AAE6ABB5A0EA82AFBAEEAFFCFDAFB1B3A0E882AFADE0AB03043O00DCCE8FDD03123O0096782316D6CFD7C66E2518CAD8ED957E220103073O00B2E61D4D77B8AC03063O0042752O665570030F3O0048617273684469736369706C696E6503133O00E5BB041A79FBF0FE2O5B7BF7FBB9350874F7E303063O009895DE6A7B1703103O00D527FA4CF58F66FA4CBBDA19E540BACB03053O00D5BD46962303173O004B5C620141504B1B5B5466481D15780741524B1B4C5A6203043O00682F3514031D3O00B0448018B3189C5B8E0EB830A7498008B44FF10C8D13B2089C5F8213AA03063O006FC32CE17CDC03163O00D54F0E7794A9D4471367EBFA984A0F7DAC94CB450F6503063O00CBB8266013CB00CC042O0012F13O00013O000E7C000200C700013O0004F03O00C700012O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O01002600013O0004F03O002600012O00AC000100014O003A0001000100020006232O01001400013O0004F03O001400012O00AC000100014O003A0001000100020006232O01002600013O0004F03O002600012O00AC000100023O0006232O01002600013O0004F03O002600012O00AC000100034O00AA00025O00202O0002000200034O000300043O00202O0003000300054O00055O00202O0005000500034O0003000500024O000300036O000400016O00010004000200062O0001002600013O0004F03O002600012O00AC000100053O0012F1000200063O0012F1000300074O0087000100034O00A500016O00AC00015O0020A20001000100080020D60001000100042O00CC0001000200020006232O01005A00013O0004F03O005A00012O00AC000100014O003A0001000100020006232O01003700013O0004F03O003700012O00AC000100014O003A0001000100020006232O01005A00013O0004F03O005A00012O00AC000100023O0006232O01005A00013O0004F03O005A00012O00AC000100063O00203E0001000100094O00035O00202O00030003000A4O00010003000200262O0001005A0001000B0004F03O005A00012O00AC000100073O000ED9000C005A000100010004F03O005A00012O00AC000100034O000700025O00202O0002000200084O000300043O00202O00030003000D00122O0005000E6O00030005000200062O00030050000100010004F03O005000012O00AC000300083O00206D00030003000D00122O0005000E6O0003000500024O000300033O00044O005200012O001001036O0056000300014O007E0001000300020006232O01005A00013O0004F03O005A00012O00AC000100053O0012F10002000F3O0012F1000300104O0087000100034O00A500016O00AC00015O0020A20001000100110020D60001000100042O00CC0001000200020006232O01007200013O0004F03O007200012O00AC000100034O00AA00025O00202O0002000200114O000300043O00202O0003000300054O00055O00202O0005000500114O0003000500024O000300036O000400016O00010004000200062O0001007200013O0004F03O007200012O00AC000100053O0012F1000200123O0012F1000300134O0087000100034O00A500016O00AC00015O0020A20001000100140020D60001000100042O00CC0001000200020006232O01008A00013O0004F03O008A00012O00AC000100034O00AA00025O00202O0002000200144O000300043O00202O0003000300054O00055O00202O0005000500144O0003000500024O000300036O000400016O00010004000200062O0001008A00013O0004F03O008A00012O00AC000100053O0012F1000200153O0012F1000300164O0087000100034O00A500016O00AC00015O0020A20001000100170020D60001000100042O00CC0001000200020006232O0100A100013O0004F03O00A100012O00AC000100034O00A400025O00202O0002000200174O000300043O00202O0003000300054O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O000100A100013O0004F03O00A100012O00AC000100053O0012F1000200183O0012F1000300194O0087000100034O00A500016O00AC000100093O0020D60001000100042O00CC0001000200020006232O0100C600013O0004F03O00C600012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O0100C600013O0004F03O00C600012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O0100C600013O0004F03O00C600012O00AC000100043O0020D600010001001C2O00CC00010002000200069D000100C6000100010004F03O00C600012O00AC000100034O009E0002000B3O00202O00020002001D4O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O00010003000200062O000100C600013O0004F03O00C600012O00AC000100053O0012F10002001F3O0012F1000300204O0087000100034O00A500015O0012F13O00213O0026C93O00432O0100210004F03O00432O012O00AC0001000C3O0020D60001000100042O00CC0001000200020006232O0100EA00013O0004F03O00EA00012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O0100EA00013O0004F03O00EA00012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O0100EA00013O0004F03O00EA00012O00AC000100034O00BD0002000B3O00202O0002000200224O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O000400016O00010004000200062O000100EA00013O0004F03O00EA00012O00AC000100053O0012F1000200233O0012F1000300244O0087000100034O00A500016O00AC00015O0020A20001000100250020D60001000100042O00CC0001000200020006232O01003O013O0004F03O003O012O00AC000100034O00A400025O00202O0002000200254O000300043O00202O0003000300054O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O0001003O013O0004F03O003O012O00AC000100053O0012F1000200263O0012F1000300274O0087000100034O00A500016O00AC00015O0020A20001000100080020D60001000100042O00CC0001000200020006232O01002A2O013O0004F03O002A2O012O00AC000100063O00203E0001000100094O00035O00202O00030003000A4O00010003000200262O0001002A2O01000B0004F03O002A2O012O00AC000100073O000ED9000C002A2O0100010004F03O002A2O012O00AC000100034O000700025O00202O0002000200084O000300043O00202O00030003000D00122O0005000E6O00030005000200062O000300202O0100010004F03O00202O012O00AC000300083O00206D00030003000D00122O0005000E6O0003000500024O000300033O00044O00222O012O001001036O0056000300014O007E0001000300020006232O01002A2O013O0004F03O002A2O012O00AC000100053O0012F1000200283O0012F1000300294O0087000100034O00A500016O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O0100CB04013O0004F03O00CB04012O00AC000100034O00AA00025O00202O0002000200034O000300043O00202O0003000300054O00055O00202O0005000500034O0003000500024O000300036O000400016O00010004000200062O000100CB04013O0004F03O00CB04012O00AC000100053O0012760002002A3O00122O0003002B6O000100036O00015O00044O00CB04010026C93O0034020100010004F03O003402012O00AC00015O0020A200010001002C0020D60001000100042O00CC0001000200020006232O0100592O013O0004F03O00592O012O00AC000100083O0006232O0100592O013O0004F03O00592O012O00AC000100034O00AC0002000B3O0020A200020002002D2O00CC0001000200020006232O0100592O013O0004F03O00592O012O00AC000100053O0012F10002002E3O0012F10003002F4O0087000100034O00A500016O00AC00015O0020A20001000100300020D60001000100042O00CC0001000200020006232O0100712O013O0004F03O00712O012O00AC000100034O00AA00025O00202O0002000200304O000300043O00202O0003000300054O00055O00202O0005000500304O0003000500024O000300036O000400016O00010004000200062O000100712O013O0004F03O00712O012O00AC000100053O0012F1000200313O0012F1000300324O0087000100034O00A500016O00AC0001000C3O0020D60001000100042O00CC0001000200020006232O0100A02O013O0004F03O00A02O012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O0100A02O013O0004F03O00A02O012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O0100A02O013O0004F03O00A02O012O00AC000100014O003A0001000100020006232O01008C2O013O0004F03O008C2O012O00AC000100014O003A0001000100020006232O0100A02O013O0004F03O00A02O012O00AC0001000D3O0006232O0100A02O013O0004F03O00A02O012O00AC0001000E3O000E06013300A02O0100010004F03O00A02O012O00AC000100034O00BD0002000B3O00202O0002000200224O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O000400016O00010004000200062O000100A02O013O0004F03O00A02O012O00AC000100053O0012F1000200343O0012F1000300354O0087000100034O00A500016O00AC000100093O0020D60001000100042O00CC0001000200020006232O0100D32O013O0004F03O00D32O012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O0100D32O013O0004F03O00D32O012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O0100D32O013O0004F03O00D32O012O00AC000100043O0020D600010001001C2O00CC00010002000200069D000100D32O0100010004F03O00D32O012O00AC000100014O003A0001000100020006232O0100C02O013O0004F03O00C02O012O00AC000100014O003A0001000100020006232O0100D32O013O0004F03O00D32O012O00AC0001000D3O0006232O0100D32O013O0004F03O00D32O012O00AC0001000E3O000E06013300D32O0100010004F03O00D32O012O00AC000100034O009E0002000B3O00202O00020002001D4O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O00010003000200062O000100D32O013O0004F03O00D32O012O00AC000100053O0012F1000200363O0012F1000300374O0087000100034O00A500016O00AC00015O0020A20001000100380020D60001000100042O00CC0001000200020006232O01000602013O0004F03O000602012O00AC000100014O003A0001000100020006232O0100E42O013O0004F03O00E42O012O00AC000100014O003A0001000100020006232O01000602013O0004F03O000602012O00AC000100023O0006232O01000602013O0004F03O000602012O00AC000100043O0020F90001000100394O00035O00202O00030003003A4O00010003000200062O0001000602013O0004F03O000602012O00AC000100043O00201C2O010001003B4O0001000200024O00025O00202O00020002003A00202O00020002003C4O00020002000200102O0002003D000200062O00020006020100010004F03O000602012O00AC000100034O00A400025O00202O0002000200384O000300043O00202O0003000300054O00055O00202O0005000500384O0003000500024O000300036O00010003000200062O0001000602013O0004F03O000602012O00AC000100053O0012F10002003E3O0012F10003003F4O0087000100034O00A500016O00AC00015O0020A20001000100170020D60001000100042O00CC0001000200020006232O01003302013O0004F03O003302012O00AC000100043O0020D60001000100402O00CC000100020002002660000100330201000B0004F03O003302012O00AC00015O0020A20001000100410020D60001000100422O00CC0001000200020006232O01003302013O0004F03O003302012O00AC000100014O003A0001000100020006232O01002202013O0004F03O002202012O00AC000100014O003A0001000100020006232O01003302013O0004F03O003302012O00AC0001000D3O0006232O01003302013O0004F03O003302012O00AC000100034O00A400025O00202O0002000200174O000300043O00202O0003000300054O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O0001003302013O0004F03O003302012O00AC000100053O0012F1000200433O0012F1000300444O0087000100034O00A500015O0012F13O00333O0026C93O00D3020100450004F03O00D302012O00AC00015O0020A20001000100170020D60001000100042O00CC0001000200020006232O01006302013O0004F03O006302012O00AC000100014O003A0001000100020006232O01004702013O0004F03O004702012O00AC000100014O003A0001000100020006232O01006302013O0004F03O006302012O00AC0001000D3O0006232O01006302013O0004F03O006302012O00AC000100043O00201700010001004600122O0003000B6O0001000300024O000200063O00202O0002000200474O00045O00202O0004000400484O00020004000200062O00020063020100010004F03O006302012O00AC000100034O00A400025O00202O0002000200174O000300043O00202O0003000300054O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O0001006302013O0004F03O006302012O00AC000100053O0012F1000200493O0012F10003004A4O0087000100034O00A500016O00AC00015O0020A200010001004B0020D60001000100042O00CC0001000200020006232O01008602013O0004F03O008602012O00AC000100014O003A0001000100020006232O01007402013O0004F03O007402012O00AC000100014O003A0001000100020006232O01008602013O0004F03O008602012O00AC000100023O0006232O01008602013O0004F03O008602012O00AC000100034O00AA00025O00202O00020002004B4O000300043O00202O0003000300054O00055O00202O00050005004B4O0003000500024O000300036O000400016O00010004000200062O0001008602013O0004F03O008602012O00AC000100053O0012F10002004C3O0012F10003004D4O0087000100034O00A500016O00AC00015O0020A20001000100250020D60001000100042O00CC0001000200020006232O0100A802013O0004F03O00A802012O00AC000100014O003A0001000100020006232O01009702013O0004F03O009702012O00AC000100014O003A0001000100020006232O0100A802013O0004F03O00A802012O00AC000100023O0006232O0100A802013O0004F03O00A802012O00AC000100034O00A400025O00202O0002000200254O000300043O00202O0003000300054O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100A802013O0004F03O00A802012O00AC000100053O0012F10002004E3O0012F10003004F4O0087000100034O00A500016O00AC0001000F3O0020D60001000100042O00CC0001000200020006232O0100C702013O0004F03O00C702012O00AC0001000A3O0020092O01000100504O00025O00202O0002000200514O000300106O00048O00058O0001000500024O000200113O00062O000100C7020100020004F03O00C702012O00AC000100034O00200102000F6O000300043O00202O0003000300054O0005000F6O0003000500024O000300036O00010003000200062O000100C702013O0004F03O00C702012O00AC000100053O0012F1000200523O0012F1000300534O0087000100034O00A500016O00AC000100124O003A00010001000200123F000100543O00124F000100543O0006232O0100D202013O0004F03O00D202012O00AC000100053O0012F1000200553O0012F1000300564O0087000100034O00A500015O0012F13O00023O000E7C000C00D403013O0004F03O00D403012O00AC00015O0020A20001000100110020D60001000100042O00CC0001000200020006232O0100FE02013O0004F03O00FE02012O00AC00015O0020A20001000100570020D60001000100422O00CC0001000200020006232O0100FE02013O0004F03O00FE02012O00AC000100014O003A0001000100020006232O0100EC02013O0004F03O00EC02012O00AC000100014O003A0001000100020006232O0100FE02013O0004F03O00FE02012O00AC0001000D3O0006232O0100FE02013O0004F03O00FE02012O00AC000100034O00AA00025O00202O0002000200114O000300043O00202O0003000300054O00055O00202O0005000500114O0003000500024O000300036O000400016O00010004000200062O000100FE02013O0004F03O00FE02012O00AC000100053O0012F1000200583O0012F1000300594O0087000100034O00A500016O00AC00015O0020A20001000100170020D60001000100042O00CC0001000200020006232O01003103013O0004F03O003103012O00AC00015O0020A20001000100410020D60001000100422O00CC0001000200020006232O01003103013O0004F03O003103012O00AC000100014O003A0001000100020006232O01001503013O0004F03O001503012O00AC000100014O003A0001000100020006232O01003103013O0004F03O003103012O00AC0001000D3O0006232O01003103013O0004F03O003103012O00AC000100043O00201700010001004600122O0003000B6O0001000300024O000200063O00202O0002000200474O00045O00202O0004000400484O00020004000200062O00020031030100010004F03O003103012O00AC000100034O00A400025O00202O0002000200174O000300043O00202O0003000300054O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O0001003103013O0004F03O003103012O00AC000100053O0012F10002005A3O0012F10003005B4O0087000100034O00A500016O00AC00015O0020A20001000100110020D60001000100042O00CC0001000200020006232O01005403013O0004F03O005403012O00AC000100014O003A0001000100020006232O01004203013O0004F03O004203012O00AC000100014O003A0001000100020006232O01005403013O0004F03O005403012O00AC0001000D3O0006232O01005403013O0004F03O005403012O00AC000100034O00AA00025O00202O0002000200114O000300043O00202O0003000300054O00055O00202O0005000500114O0003000500024O000300036O000400016O00010004000200062O0001005403013O0004F03O005403012O00AC000100053O0012F10002005C3O0012F10003005D4O0087000100034O00A500016O00AC00015O0020A20001000100140020D60001000100042O00CC0001000200020006232O01007703013O0004F03O007703012O00AC000100014O003A0001000100020006232O01006503013O0004F03O006503012O00AC000100014O003A0001000100020006232O01007703013O0004F03O007703012O00AC0001000D3O0006232O01007703013O0004F03O007703012O00AC000100034O00AA00025O00202O0002000200144O000300043O00202O0003000300054O00055O00202O0005000500144O0003000500024O000300036O000400016O00010004000200062O0001007703013O0004F03O007703012O00AC000100053O0012F10002005E3O0012F10003005F4O0087000100034O00A500016O00AC0001000C3O0020D60001000100042O00CC0001000200020006232O0100A303013O0004F03O00A303012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O0100A303013O0004F03O00A303012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O0100A303013O0004F03O00A303012O00AC000100014O003A0001000100020006232O01009203013O0004F03O009203012O00AC000100014O003A0001000100020006232O0100A303013O0004F03O00A303012O00AC0001000D3O0006232O0100A303013O0004F03O00A303012O00AC000100034O00BD0002000B3O00202O0002000200224O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O000400016O00010004000200062O000100A303013O0004F03O00A303012O00AC000100053O0012F1000200603O0012F1000300614O0087000100034O00A500016O00AC000100093O0020D60001000100042O00CC0001000200020006232O0100D303013O0004F03O00D303012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O0100D303013O0004F03O00D303012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O0100D303013O0004F03O00D303012O00AC000100043O0020D600010001001C2O00CC00010002000200069D000100D3030100010004F03O00D303012O00AC000100014O003A0001000100020006232O0100C303013O0004F03O00C303012O00AC000100014O003A0001000100020006232O0100D303013O0004F03O00D303012O00AC0001000D3O0006232O0100D303013O0004F03O00D303012O00AC000100034O009E0002000B3O00202O00020002001D4O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O00010003000200062O000100D303013O0004F03O00D303012O00AC000100053O0012F1000200623O0012F1000300634O0087000100034O00A500015O0012F13O00453O0026C93O0001000100330004F03O000100012O00AC0001000F3O0020D60001000100042O00CC0001000200020006232O0100F503013O0004F03O00F503012O00AC0001000A3O0020092O01000100504O00025O00202O0002000200514O000300106O00048O00058O0001000500024O000200113O00062O000100F5030100020004F03O00F503012O00AC000100034O00200102000F6O000300043O00202O0003000300054O0005000F6O0003000500024O000300036O00010003000200062O000100F503013O0004F03O00F503012O00AC000100053O0012F1000200643O0012F1000300654O0087000100034O00A500016O00AC000100014O003A0001000100020006232O012O0004013O0004F04O0004012O00AC000100014O003A0001000100020006232O01001704013O0004F03O001704012O00AC0001000D3O0006232O01001704013O0004F03O001704012O00AC000100063O0020F90001000100664O00035O00202O0003000300674O00010003000200062O0001001704013O0004F03O001704010012F1000100013O0026C900010008040100010004F03O000804012O00AC000200124O003A00020001000200123F000200543O00124F000200543O0006230102001704013O0004F03O001704012O00AC000200053O001276000300683O00122O000400696O000200046O00025O00044O001704010004F03O000804012O00AC0001000C3O0020D60001000100042O00CC0001000200020006232O01004604013O0004F03O004604012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O01004604013O0004F03O004604012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O01004604013O0004F03O004604012O00AC000100014O003A0001000100020006232O01003204013O0004F03O003204012O00AC000100014O003A0001000100020006232O01004604013O0004F03O004604012O00AC0001000D3O0006232O01004604013O0004F03O004604012O00AC0001000E3O000E0601330046040100010004F03O004604012O00AC000100034O00BD0002000B3O00202O0002000200224O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O000400016O00010004000200062O0001004604013O0004F03O004604012O00AC000100053O0012F10002006A3O0012F10003006B4O0087000100034O00A500016O00AC000100093O0020D60001000100042O00CC0001000200020006232O01007904013O0004F03O007904012O00AC0001000A3O0020A200010001001A2O003A0001000100020006232O01007904013O0004F03O007904012O00AC000100043O0020D600010001000D0012F10003001B4O007E0001000300020006232O01007904013O0004F03O007904012O00AC000100043O0020D600010001001C2O00CC00010002000200069D00010079040100010004F03O007904012O00AC000100014O003A0001000100020006232O01006604013O0004F03O006604012O00AC000100014O003A0001000100020006232O01007904013O0004F03O007904012O00AC0001000D3O0006232O01007904013O0004F03O007904012O00AC0001000E3O000E0601330079040100010004F03O007904012O00AC000100034O009E0002000B3O00202O00020002001D4O000300043O00202O00030003000D00122O0005001E6O0003000500024O000300036O00010003000200062O0001007904013O0004F03O007904012O00AC000100053O0012F10002006C3O0012F10003006D4O0087000100034O00A500016O00AC00015O0020A20001000100170020D60001000100042O00CC0001000200020006232O0100A004013O0004F03O00A004012O00AC000100043O0020D60001000100402O00CC000100020002002660000100A00401000B0004F03O00A004012O00AC000100014O003A0001000100020006232O01008F04013O0004F03O008F04012O00AC000100014O003A0001000100020006232O0100A004013O0004F03O00A004012O00AC0001000D3O0006232O0100A004013O0004F03O00A004012O00AC000100034O00A400025O00202O0002000200174O000300043O00202O0003000300054O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O000100A004013O0004F03O00A004012O00AC000100053O0012F10002006E3O0012F10003006F4O0087000100034O00A500016O00AC00015O0020A20001000100140020D60001000100042O00CC0001000200020006232O0100C904013O0004F03O00C904012O00AC00015O0020A20001000100410020D60001000100422O00CC0001000200020006232O0100C904013O0004F03O00C904012O00AC000100014O003A0001000100020006232O0100B704013O0004F03O00B704012O00AC000100014O003A0001000100020006232O0100C904013O0004F03O00C904012O00AC0001000D3O0006232O0100C904013O0004F03O00C904012O00AC000100034O00AA00025O00202O0002000200144O000300043O00202O0003000300054O00055O00202O0005000500144O0003000500024O000300036O000400016O00010004000200062O000100C904013O0004F03O00C904012O00AC000100053O0012F1000200703O0012F1000300714O0087000100034O00A500015O0012F13O000C3O0004F03O000100012O004A3O00017O007E3O00028O00026O00104003093O004D696E64426C61737403073O0049735265616479030E3O00536861646F77436F76656E616E74030B3O004973417661696C61626C65030F3O00432O6F6C646F776E52656D61696E7303083O00432O6F6C646F776E030E3O0049735370652O6C496E52616E676503113O00347A7745F13B7F7852DA7977784CCF3E7603053O00AE5913192103093O004D696E6467616D657303143O005368612O746572656450657263657074696F6E7303123O00221B5C4AF086062A01121FB7830A2213554B03073O006B4F72322E97E7030F3O00536861646F77576F7264446561746803093O00457870696174696F6E03073O0054696D65546F58026O003440026O00E03F031A3O002AAEB42D852E88D736B4B1168E3CB6D431E6E7698E38BAC13EA303083O00A059C6D549EA59D703123O004578BAFAC2497CB1ED851A31B0FFC84976B103053O00A52811D49E030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40030A3O0048616C6F506C61796572026O003840030B3O00EDD8043C66E1D8053221E003053O004685B9685303133O004973466163696E67426C61636B6C6973746564030A3O00446976696E655374617203103O00446976696E6553746172506C6179657203124O004C5223C7017A573EC81605402BC405424103053O00A96425244A026O001440030C3O0053686F756C6452657475726E03113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O002040030B3O0044697370656C4D6167696303093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O6603133O00048EB140058B9D5D0180AB534083A35D0180A703043O003060E7C2030D3O00417263616E65546F2O72656E74030E3O004D616E6150657263656E74616765025O0040554003153O00C9480D2C17DD9097C7481C2817CCEF87C9570F2A1C03083O00E3A83A6E4D79B8CF03083O0042752O66446F776E030A3O005445486F6C7942752O66030C3O005445536861646F7742752O6603063O0042752O665570026O00F03F027O0040030A3O004D696E6462656E64657203123O00536861646F77436F76656E616E7442752O6603113O007635B144B3DE7FA17E2EFF44B0D670A27E03083O00C51B5CDF20D1BB1103113O00506F776572496E667573696F6E42752O66030A3O00432O6F6C646F776E5570030E3O0050757267655468655769636B6564030D3O00446562752O6652656D61696E7303143O0050757267655468655769636B6564446562752O66030E3O00536861646F77576F72645061696E03093O0054696D65546F446965030C3O00426173654475726174696F6E0200304O33D33F03113O00446562752O665265667265736861626C6503113O005061696E66756C50756E6973686D656E7403073O0050656E616E636503173O00134AD1FC0660D7F30660D4F20054C6FF435BC2F60258C603043O009B633FA3026O000840030F3O00506F776572576F7264536F6C61636503183O0092DEB688ABBB95DEB38986978DDDA08EBCC486D0AC8CBE8103063O00E4E2B1C1EDD9031A3O0027B822E23BA71CF13BA227D930B522F23CF070A630B12EE733B503043O008654D04303083O00486F6C794E6F766103093O0042752O66537461636B030C3O0052686170736F647942752O66026O00284003123O001BA38A452CA2894A12ECD71C17AD8B5D14A903043O003C73CCE603053O00536D697465030A3O0049734361737461626C65030C3O00F437E264E27AEF71EA3BEC7503043O0010875A8B03083O0049734D6F76696E6703123O005C7B0A2A715A77427546610E50795975013603073O0018341466532E34026O00184003203O00D43A33230AFB3B292130D326222F0AC0102C2B19C122242A1B842B20290EC32A03053O006FA44F414403203O00D5D182DA21FDF9CE8CCC2AD5D6D88AD011E7C9CF86D32BE4D29987DF23EBC1DC03063O008AA6B9E3BE4E030D3O00456D6272616365536861646F77030F3O0048617273684469736369706C696E6503133O0048617273684469736369706C696E6542752O66030B3O00536861646F776669656E64025O0080564003123O00D87CC4335D341FC271CB33122718C675C23203073O0079AB14A557324302405O33D33F03173O00D530B832B615F92FB624BD3DD639B038F906C735B831BC03063O0062A658D956D903063O0053636869736D03163O00E5FE780589CBC9F5761783D2F7F86D4182DDFBF77E0403063O00BC2O961961E603103O004865616C746850657263656E74616765031A3O00C9815E0603FAE59E501008D2DE8C5E1604AD8BC95B0301ECDD8C03063O008DBAE93F626C03323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O6603123O00E1EF22B72BF2EF6CA52DFEF8388936F2E53A03053O0045918A4CD6030E3O0060CA8788B115758F8D88B21777CA03063O007610AF2OE9DF030B3O004C69676874735772617468030E3O005772617468556E6C65617368656403133O00878D32B3FA98429C9634AFE6CB798A8934BCEB03073O001DEBE455DB8EEB009C042O0012F13O00013O000E7C0002001C2O013O0004F03O001C2O012O00AC00015O0020A20001000100030020D60001000100042O00CC0001000200020006232O01002B00013O0004F03O002B00012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01001900013O0004F03O001900012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002000300202O0002000200084O00020002000200062O0002002B000100010004F03O002B00012O00AC000100014O00AA00025O00202O0002000200034O000300023O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O000400016O00010004000200062O0001002B00013O0004F03O002B00012O00AC000100033O0012F10002000A3O0012F10003000B4O0087000100034O00A500016O00AC00015O0020A200010001000C0020D60001000100042O00CC0001000200020006232O01005900013O0004F03O005900012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01004100013O0004F03O004100012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002000C00202O0002000200084O00020002000200062O00020059000100010004F03O005900012O00AC00015O0020A200010001000D0020D60001000100062O00CC0001000200020006232O01005900013O0004F03O005900012O00AC000100014O00AA00025O00202O00020002000C4O000300023O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O000400016O00010004000200062O0001005900013O0004F03O005900012O00AC000100033O0012F10002000E3O0012F10003000F4O0087000100034O00A500016O00AC00015O0020A20001000100100020D60001000100042O00CC0001000200020006232O01009100013O0004F03O009100012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01006F00013O0004F03O006F00012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002001000202O0002000200084O00020002000200062O00020091000100010004F03O009100012O00AC00015O0020A20001000100110020D60001000100062O00CC0001000200020006232O01009100013O0004F03O009100012O00AC000100023O0020042O010001001200122O000300136O0001000300024O00025O00202O00020002001000202O0002000200084O00020002000200102O00020014000200062O00020091000100010004F03O009100012O00AC000100014O00A400025O00202O0002000200104O000300023O00202O0003000300094O00055O00202O0005000500104O0003000500024O000300036O00010003000200062O0001009100013O0004F03O009100012O00AC000100033O0012F1000200153O0012F1000300164O0087000100034O00A500016O00AC00015O0020A200010001000C0020D60001000100042O00CC0001000200020006232O0100BF00013O0004F03O00BF00012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O0100A700013O0004F03O00A700012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002000C00202O0002000200084O00020002000200062O000200BF000100010004F03O00BF00012O00AC00015O0020A200010001000D0020D60001000100062O00CC00010002000200069D000100BF000100010004F03O00BF00012O00AC000100014O00AA00025O00202O00020002000C4O000300023O00202O0003000300094O00055O00202O00050005000C4O0003000500024O000300036O000400016O00010004000200062O000100BF00013O0004F03O00BF00012O00AC000100033O0012F1000200173O0012F1000300184O0087000100034O00A500016O00AC000100043O0020D60001000100042O00CC0001000200020006232O0100E600013O0004F03O00E600012O00AC000100053O0020A20001000100192O003A0001000100020006232O0100E600013O0004F03O00E600012O00AC000100023O0020D600010001001A0012F10003001B4O007E0001000300020006232O0100E600013O0004F03O00E600012O00AC00015O0020A20001000100050020D60001000100062O00CC00010002000200069D000100E6000100010004F03O00E600012O00AC000100014O00BD000200063O00202O00020002001C4O000300023O00202O00030003001A00122O0005001D6O0003000500024O000300036O000400016O00010004000200062O000100E600013O0004F03O00E600012O00AC000100033O0012F10002001E3O0012F10003001F4O0087000100034O00A500016O00AC000100073O0020D60001000100042O00CC0001000200020006232O01001B2O013O0004F03O001B2O012O00AC000100053O0020A20001000100192O003A0001000100020006232O01001B2O013O0004F03O001B2O012O00AC000100023O0020D600010001001A0012F10003001B4O007E0001000300020006232O01001B2O013O0004F03O001B2O012O00AC000100023O0020D60001000100202O00CC00010002000200069D0001001B2O0100010004F03O001B2O012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01000B2O013O0004F03O000B2O012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002002100202O0002000200084O00020002000200062O0002001B2O0100010004F03O001B2O012O00AC000100014O009E000200063O00202O0002000200224O000300023O00202O00030003001A00122O0005001D6O0003000500024O000300036O00010003000200062O0001001B2O013O0004F03O001B2O012O00AC000100033O0012F1000200233O0012F1000300244O0087000100034O00A500015O0012F13O00253O0026C93O008A2O0100010004F03O008A2O012O00AC000100053O0020060001000100274O00025O00202O00020002002800122O000300296O00010003000200122O000100263O00122O000100263O00062O0001002A2O013O0004F03O002A2O0100124F000100264O00212O0100024O00AC00015O0020A200010001002A0020D60001000100042O00CC0001000200020006232O0100572O013O0004F03O00572O012O00AC000100083O0006232O0100572O013O0004F03O00572O012O00AC000100093O0006232O0100572O013O0004F03O00572O012O00AC0001000A3O0020D600010001002B2O00CC00010002000200069D000100572O0100010004F03O00572O012O00AC0001000A3O0020D600010001002C2O00CC00010002000200069D000100572O0100010004F03O00572O012O00AC000100053O0020A200010001002D2O00AC000200024O00CC0001000200020006232O0100572O013O0004F03O00572O012O00AC000100014O00A400025O00202O00020002002A4O000300023O00202O0003000300094O00055O00202O00050005002A4O0003000500024O000300036O00010003000200062O000100572O013O0004F03O00572O012O00AC000100033O0012F10002002E3O0012F10003002F4O0087000100034O00A500016O00AC00015O0020A20001000100300020D60001000100042O00CC0001000200020006232O0100732O013O0004F03O00732O012O00AC0001000B3O0006232O0100732O013O0004F03O00732O012O00AC0001000C3O0006232O0100732O013O0004F03O00732O012O00AC0001000A3O0020D60001000100312O00CC00010002000200265A000100732O0100320004F03O00732O012O00AC000100014O00AC00025O0020A20002000200302O00CC0001000200020006232O0100732O013O0004F03O00732O012O00AC000100033O0012F1000200333O0012F1000300344O0087000100034O00A500016O00AC0001000A3O0020F90001000100354O00035O00202O0003000300364O00010003000200062O0001007F2O013O0004F03O007F2O012O00AC0001000A3O0020D60001000100352O00AC00035O0020A20003000300372O007E0001000300022O00142O01000D4O00AC0001000A3O0020530001000100384O00035O00202O0003000300364O00010003000200062O000100882O0100010004F03O00882O012O00AC0001000D4O00142O01000E3O0012F13O00393O0026C93O00600201003A0004F03O006002012O00AC00015O0020A200010001003B0020D60001000100042O00CC0001000200020006232O0100A72O013O0004F03O00A72O012O00AC0001000C3O0006232O0100A72O013O0004F03O00A72O012O00AC0001000A3O0020530001000100384O00035O00202O00030003003C4O00010003000200062O000100A72O0100010004F03O00A72O012O00AC000100014O00AC00025O0020A200020002003B2O00CC0001000200020006232O0100A72O013O0004F03O00A72O012O00AC000100033O0012F10002003D3O0012F10003003E4O0087000100034O00A500016O00AC0001000C3O0006232O0100BE2O013O0004F03O00BE2O012O00AC0001000A3O0020F90001000100384O00035O00202O00030003003F4O00010003000200062O000100BE2O013O0004F03O00BE2O010012F1000100013O0026C9000100B22O0100010004F03O00B22O012O00AC0002000F4O003A00020001000200123F000200263O00124F000200263O000623010200BE2O013O0004F03O00BE2O0100124F000200264O0021010200023O0004F03O00BE2O010004F03O00B22O012O00AC00015O0020A20001000100050020D60001000100402O00CC0001000200020006232O0100F42O013O0004F03O00F42O012O00AC000100103O00069D000100F42O0100010004F03O00F42O012O00AC000100113O0006232O0100E72O013O0004F03O00E72O012O00AC000100123O0006232O0100F42O013O0004F03O00F42O012O00AC00015O0020A20001000100410020D60001000100062O00CC0001000200020006232O0100DA2O013O0004F03O00DA2O012O00AC000100023O0020450001000100424O00035O00202O0003000300434O00010003000200262O000100E72O0100130004F03O00E72O012O00AC00015O0020A20001000100410020D60001000100062O00CC00010002000200069D000100F42O0100010004F03O00F42O012O00AC000100023O0020910001000100424O00035O00202O0003000300444O00010003000200262O000100F42O0100130004F03O00F42O010012F1000100013O000E7C000100E82O0100010004F03O00E82O012O00AC000200134O003A00020001000200123F000200263O00124F000200263O000623010200F42O013O0004F03O00F42O0100124F000200264O0021010200023O0004F03O00F42O010004F03O00E82O012O00AC000100123O0006232O01000A02013O0004F03O000A02012O00AC000100143O0006232O01000A02013O0004F03O000A02012O00AC000100103O00069D0001000A020100010004F03O000A02010012F1000100013O000E7C000100FE2O0100010004F03O00FE2O012O00AC000200154O003A00020001000200123F000200263O00124F000200263O0006230102000A02013O0004F03O000A020100124F000200264O0021010200023O0004F03O000A02010004F03O00FE2O012O00AC000100163O0006232O01002002013O0004F03O002002012O00AC000100143O0006232O01002002013O0004F03O002002012O00AC000100103O00069D00010020020100010004F03O002002010012F1000100013O0026C900010014020100010004F03O001402012O00AC000200174O003A00020001000200123F000200263O00124F000200263O0006230102002002013O0004F03O0020020100124F000200264O0021010200023O0004F03O002002010004F03O001402012O00AC00015O0020A20001000100410020D60001000100042O00CC0001000200020006232O01005F02013O0004F03O005F02012O00AC000100023O00201C2O01000100454O0001000200024O00025O00202O00020002004100202O0002000200464O00020002000200102O00020047000200062O0002005F020100010004F03O005F02012O00AC000100023O0020F90001000100484O00035O00202O0003000300434O00010003000200062O0001005F02013O0004F03O005F02012O00AC00015O0020A20001000100490020D60001000100062O00CC0001000200020006232O01004E02013O0004F03O004E02012O00AC00015O0020A20001000100490020D60001000100062O00CC0001000200020006232O01005F02013O0004F03O005F02012O00AC000100023O0020160001000100424O00035O00202O0003000300434O0001000300024O00025O00202O00020002004A00202O0002000200074O00020002000200062O0001005F020100020004F03O005F02012O00AC000100014O00A400025O00202O0002000200414O000300023O00202O0003000300094O00055O00202O0005000500414O0003000500024O000300036O00010003000200062O0001005F02013O0004F03O005F02012O00AC000100033O0012F10002004B3O0012F10003004C4O0087000100034O00A500015O0012F13O004D3O000E7C0025001303013O0004F03O001303012O00AC00015O0020A200010001004E0020D60001000100042O00CC0001000200020006232O01007902013O0004F03O007902012O00AC000100014O00A400025O00202O00020002004E4O000300023O00202O0003000300094O00055O00202O00050005004E4O0003000500024O000300036O00010003000200062O0001007902013O0004F03O007902012O00AC000100033O0012F10002004F3O0012F1000300504O0087000100034O00A500016O00AC00015O0020A20001000100100020D60001000100042O00CC0001000200020006232O0100AB02013O0004F03O00AB02012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01008F02013O0004F03O008F02012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002001000202O0002000200084O00020002000200062O000200AB020100010004F03O00AB02012O00AC000100023O0020042O010001001200122O000300136O0001000300024O00025O00202O00020002001000202O0002000200084O00020002000200102O00020014000200062O000200AB020100010004F03O00AB02012O00AC000100014O00A400025O00202O0002000200104O000300023O00202O0003000300094O00055O00202O0005000500104O0003000500024O000300036O00010003000200062O000100AB02013O0004F03O00AB02012O00AC000100033O0012F1000200513O0012F1000300524O0087000100034O00A500016O00AC00015O0020A20001000100530020D60001000100042O00CC0001000200020006232O0100D402013O0004F03O00D402012O00AC0001000A3O00203E0001000100544O00035O00202O0003000300554O00010003000200262O000100D4020100130004F03O00D402012O00AC000100183O000ED9003A00D4020100010004F03O00D402012O00AC000100014O000700025O00202O0002000200534O000300023O00202O00030003001A00122O000500566O00030005000200062O000300CA020100010004F03O00CA02012O00AC000300193O00206D00030003001A00122O000500566O0003000500024O000300033O00044O00CC02012O001001036O0056000300014O007E0001000300020006232O0100D402013O0004F03O00D402012O00AC000100033O0012F1000200573O0012F1000300584O0087000100034O00A500016O00AC00015O0020A20001000100590020D600010001005A2O00CC0001000200020006232O0100EC02013O0004F03O00EC02012O00AC000100014O00AA00025O00202O0002000200594O000300023O00202O0003000300094O00055O00202O0005000500594O0003000500024O000300036O000400016O00010004000200062O000100EC02013O0004F03O00EC02012O00AC000100033O0012F10002005B3O0012F10003005C4O0087000100034O00A500016O00AC0001000A3O0020D600010001005D2O00CC0001000200020006232O0100FE02013O0004F03O00FE02010012F1000100013O0026C9000100F2020100010004F03O00F202012O00AC0002001A4O003A00020001000200123F000200263O00124F000200263O000623010200FE02013O0004F03O00FE020100124F000200264O0021010200023O0004F03O00FE02010004F03O00F202012O00AC00015O0020A20001000100530020D60001000100042O00CC0001000200020006232O01001203013O0004F03O001203012O00AC000100183O000ED9003A0012030100010004F03O001203012O00AC000100014O00AC00025O0020A20002000200532O00CC0001000200020006232O01001203013O0004F03O001203012O00AC000100033O0012F10002005E3O0012F10003005F4O0087000100034O00A500015O0012F13O00603O000E7C0060004403013O0004F03O004403012O00AC00015O0020A20001000100410020D60001000100042O00CC0001000200020006232O01002C03013O0004F03O002C03012O00AC000100014O00A400025O00202O0002000200414O000300023O00202O0003000300094O00055O00202O0005000500414O0003000500024O000300036O00010003000200062O0001002C03013O0004F03O002C03012O00AC000100033O0012F1000200613O0012F1000300624O0087000100034O00A500016O00AC00015O0020A20001000100440020D60001000100042O00CC0001000200020006232O01009B04013O0004F03O009B04012O00AC000100014O00A400025O00202O0002000200444O000300023O00202O0003000300094O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O0001009B04013O0004F03O009B04012O00AC000100033O001276000200633O00122O000300646O000100036O00015O00044O009B04010026C93O00AC030100390004F03O00AC03012O00AC0001000A3O0020530001000100384O00035O00202O0003000300374O00010003000200062O0001004E030100010004F03O004E03012O00AC0001000D4O00142O01001B4O001D00015O00202O00010001000500202O0001000100064O00010002000200062O0001005903013O0004F03O005903012O00AC00015O0020A20001000100650020D60001000100062O00CC0001000200022O00142O0100164O001D00015O00202O00010001000500202O0001000100064O00010002000200062O0001006503013O0004F03O006503012O00AC00015O0020A20001000100650020D60001000100062O00CC0001000200022O00B6000100014O00142O0100124O001D00015O00202O00010001006600202O0001000100064O00010002000200062O0001007403013O0004F03O007403012O00AC0001000A3O00201C0001000100544O00035O00202O0003000300674O00010003000200262O000100740301004D0004F03O007403012O00102O016O0056000100014O002B000100116O00015O00202O00010001000500202O0001000100404O00010002000200062O0001007F03013O0004F03O007F03012O00AC000100113O00069D00010084030100010004F03O008403012O00AC0001000A3O0020D60001000100382O00AC00035O0020A200030003003C2O007E0001000300022O00142O0100144O001D00015O00202O00010001006800202O0001000100044O00010002000200062O000100AB03013O0004F03O00AB03012O00AC0001000C3O0006232O0100AB03013O0004F03O00AB03012O00AC0001000A3O0020D60001000100312O00CC000100020002002660000100AB030100690004F03O00AB03012O00AC00015O0020A200010001003B0020D60001000100062O00CC00010002000200069D000100AB030100010004F03O00AB03012O00AC0001000A3O0020530001000100384O00035O00202O00030003003C4O00010003000200062O000100AB030100010004F03O00AB03012O00AC000100014O00AC00025O0020A20002000200682O00CC0001000200020006232O0100AB03013O0004F03O00AB03012O00AC000100033O0012F10002006A3O0012F10003006B4O0087000100034O00A500015O0012F13O003A3O000E7C004D000100013O0004F03O000100012O00AC00015O0020A20001000100440020D60001000100042O00CC0001000200020006232O0100F303013O0004F03O00F303012O00AC00015O0020A20001000100410020D60001000100062O00CC00010002000200069D000100F3030100010004F03O00F303012O00AC000100023O00201C2O01000100454O0001000200024O00025O00202O00020002004400202O0002000200464O00020002000200102O0002006C000200062O000200F3030100010004F03O00F303012O00AC000100023O0020F90001000100484O00035O00202O0003000300444O00010003000200062O000100F303013O0004F03O00F303012O00AC00015O0020A20001000100490020D60001000100062O00CC0001000200020006232O0100E203013O0004F03O00E203012O00AC00015O0020A20001000100490020D60001000100062O00CC0001000200020006232O0100F303013O0004F03O00F303012O00AC000100023O0020160001000100424O00035O00202O0003000300444O0001000300024O00025O00202O00020002004A00202O0002000200074O00020002000200062O000100F3030100020004F03O00F303012O00AC000100014O00A400025O00202O0002000200444O000300023O00202O0003000300094O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O000100F303013O0004F03O00F303012O00AC000100033O0012F10002006D3O0012F10003006E4O0087000100034O00A500016O00AC00015O0020A200010001006F0020D60001000100042O00CC0001000200020006232O01001104013O0004F03O001104012O00AC00015O0020A20001000100050020D60001000100062O00CC00010002000200069D00010011040100010004F03O001104012O00AC000100014O00AA00025O00202O00020002006F4O000300023O00202O0003000300094O00055O00202O00050005006F4O0003000500024O000300036O000400016O00010004000200062O0001001104013O0004F03O001104012O00AC000100033O0012F1000200703O0012F1000300714O0087000100034O00A500016O00AC00015O0020A20001000100100020D60001000100042O00CC0001000200020006232O01003D04013O0004F03O003D04012O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01002704013O0004F03O002704012O00AC00015O0020EF00010001000500202O0001000100074O0001000200024O00025O00202O00020002001000202O0002000200084O00020002000200062O0002003D040100010004F03O003D04012O00AC000100023O0020D60001000100722O00CC0001000200020026600001003D040100130004F03O003D04012O00AC000100014O00A400025O00202O0002000200104O000300023O00202O0003000300094O00055O00202O0005000500104O0003000500024O000300036O00010003000200062O0001003D04013O0004F03O003D04012O00AC000100033O0012F1000200733O0012F1000300744O0087000100034O00A500016O00AC0001001C3O0020D60001000100042O00CC0001000200020006232O01005C04013O0004F03O005C04012O00AC000100053O0020092O01000100754O00025O00202O0002000200764O0003001D6O00048O00058O0001000500024O0002001E3O00062O0001005C040100020004F03O005C04012O00AC000100014O00200102001C6O000300023O00202O0003000300094O0005001C6O0003000500024O000300036O00010003000200062O0001005C04013O0004F03O005C04012O00AC000100033O0012F1000200773O0012F1000300784O0087000100034O00A500016O00AC00015O0020A20001000100050020D60001000100062O00CC0001000200020006232O01006B04013O0004F03O006B04012O00AC00015O0020032O010001000500202O0001000100074O0001000200024O0002001C3O00202O0002000200084O00020002000200062O0002007B040100010004F03O007B04010012F1000100013O0026C90001006C040100010004F03O006C04012O00AC0002001F4O003A00020001000200123F000200263O00124F000200263O0006230102007B04013O0004F03O007B04012O00AC000200033O001276000300793O00122O0004007A6O000200046O00025O00044O007B04010004F03O006C04012O00AC00015O0020A200010001007B0020D60001000100042O00CC0001000200020006232O01009904013O0004F03O009904012O00AC00015O0020A200010001007C0020D60001000100062O00CC0001000200020006232O01009904013O0004F03O009904012O00AC000100014O00AA00025O00202O00020002007B4O000300023O00202O0003000300094O00055O00202O00050005007B4O0003000500024O000300036O000400016O00010004000200062O0001009904013O0004F03O009904012O00AC000100033O0012F10002007D3O0012F10003007E4O0087000100034O00A500015O0012F13O00023O0004F03O000100012O004A3O00017O001B3O00028O00030C3O0053686F756C6452657475726E026O00F03F027O0040030D3O00546172676574497356616C696403083O0049734D6F76696E67030F3O0048616E646C65412O666C6963746564030D3O00506F776572576F72644C69666503163O00506F776572576F72644C6966654D6F7573656F766572026O004440026O00104003093O00466C6173684865616C03123O00466C6173684865616C4D6F7573656F766572026O000840030D3O004461726B52657072696D616E6403163O004461726B52657072696D616E644D6F7573656F76657203063O00507572696679030F3O005075726966794D6F7573656F76657203073O0050656E616E636503103O0050656E616E63654D6F7573656F766572030D3O0048616E646C654368726F6D696503113O0048616E646C65496E636F72706F7265616C030D3O00536861636B6C65556E6465616403163O00536861636B6C65556E646561644D6F7573656F766572026O003E40030C3O00446F6D696E6174654D696E6403153O00446F6D696E6174654D696E644D6F7573656F766572001E012O0012F13O00013O0026C93O000C000100010004F03O000C00012O00AC00016O003A00010001000200123F000100023O00124F000100023O0006232O01000B00013O0004F03O000B000100124F000100024O00212O0100023O0012F13O00033O0026C93O0034000100040004F03O003400012O00AC000100013O0020A20001000100052O003A0001000100020006232O01002100013O0004F03O002100010012F1000100013O0026C900010014000100010004F03O001400012O00AC000200024O003A00020001000200123F000200023O00124F000200023O0006230102001D2O013O0004F03O001D2O0100124F000200024O0021010200023O0004F03O001D2O010004F03O001400010004F03O001D2O012O00AC000100033O0020D60001000100062O00CC0001000200020006232O01001D2O013O0004F03O001D2O010012F1000100013O0026C900010027000100010004F03O002700012O00AC000200044O003A00020001000200123F000200023O00124F000200023O0006230102001D2O013O0004F03O001D2O0100124F000200024O0021010200023O0004F03O001D2O010004F03O002700010004F03O001D2O010026C93O0001000100030004F03O000100012O00AC000100053O0006232O01009100013O0004F03O009100010012F1000100013O0026C90001004B000100030004F03O004B00012O00AC000200013O0020580002000200074O000300063O00202O0003000300084O000400073O00202O00040004000900122O0005000A6O00020005000200122O000200023O00122O000200023O00062O0002004A00013O0004F03O004A000100124F000200024O0021010200023O0012F1000100043O0026C90001005D0001000B0004F03O005D00012O00AC000200013O0020240002000200074O000300063O00202O00030003000C4O000400073O00202O00040004000D00122O0005000A6O000600016O00020006000200122O000200023O00122O000200023O00062O0002009100013O0004F03O0091000100124F000200024O0021010200023O0004F03O009100010026C90001006E0001000E0004F03O006E00012O00AC000200013O0020580002000200074O000300063O00202O00030003000F4O000400073O00202O00040004001000122O0005000A6O00020005000200122O000200023O00122O000200023O00062O0002006D00013O0004F03O006D000100124F000200024O0021010200023O0012F10001000B3O0026C90001007F000100010004F03O007F00012O00AC000200013O0020580002000200074O000300063O00202O0003000300114O000400073O00202O00040004001200122O0005000A6O00020005000200122O000200023O00122O000200023O00062O0002007E00013O0004F03O007E000100124F000200024O0021010200023O0012F1000100033O0026C90001003A000100040004F03O003A00012O00AC000200013O0020580002000200074O000300063O00202O0003000300134O000400073O00202O00040004001400122O0005000A6O00020005000200122O000200023O00122O000200023O00062O0002008F00013O0004F03O008F000100124F000200024O0021010200023O0012F10001000E3O0004F03O003A00012O00AC000100083O0006232O01001B2O013O0004F03O001B2O010012F1000100013O0026C9000100C6000100010004F03O00C600012O00AC000200093O000623010200A700013O0004F03O00A700010012F1000200013O0026C90002009B000100010004F03O009B00012O00AC0003000A4O003A00030001000200123F000300023O00124F000300023O000623010300A700013O0004F03O00A7000100124F000300024O0021010300023O0004F03O00A700010004F03O009B00012O00AC0002000B3O000623010200B700013O0004F03O00B700010012F1000200013O0026C9000200AB000100010004F03O00AB00012O00AC0003000C4O003A00030001000200123F000300023O00124F000300023O000623010300B700013O0004F03O00B7000100124F000300024O0021010300023O0004F03O00B700010004F03O00AB00012O00AC000200013O0020580002000200154O000300063O00202O0003000300134O000400073O00202O00040004001400122O0005000A6O00020005000200122O000200023O00122O000200023O00062O000200C500013O0004F03O00C5000100124F000200024O0021010200023O0012F1000100033O0026C9000100FA000100040004F03O00FA00012O00AC0002000D3O000623010200F100013O0004F03O00F100010012F1000200013O0026C9000200DE000100030004F03O00DE00012O00AC000300013O0020240003000300164O000400063O00202O0004000400174O000500073O00202O00050005001800122O000600196O000700016O00030007000200122O000300023O00122O000300023O00062O000300F100013O0004F03O00F1000100124F000300024O0021010300023O0004F03O00F100010026C9000200CC000100010004F03O00CC00012O00AC000300013O0020240003000300164O000400063O00202O00040004001A4O000500073O00202O00050005001B00122O000600196O000700016O00030007000200122O000300023O00122O000300023O00062O000300EF00013O0004F03O00EF000100124F000300024O0021010300023O0012F1000200033O0004F03O00CC00012O00AC0002000E4O003A00020001000200123F000200023O00124F000200023O0006230102001B2O013O0004F03O001B2O0100124F000200024O0021010200023O0004F03O001B2O010026C900010095000100030004F03O009500012O00AC000200013O0020580002000200154O000300063O00202O00030003000F4O000400073O00202O00040004001000122O0005000A6O00020005000200122O000200023O00122O000200023O00062O0002000A2O013O0004F03O000A2O0100124F000200024O0021010200024O00AC000200013O0020240002000200154O000300063O00202O00030003000C4O000400073O00202O00040004000D00122O0005000A6O000600016O00020006000200122O000200023O00122O000200023O00062O000200192O013O0004F03O00192O0100124F000200024O0021010200023O0012F1000100043O0004F03O009500010012F13O00043O0004F03O000100012O004A3O00017O00283O00028O0003123O00506F776572576F7264466F72746974756465030A3O0049734361737461626C6503083O0042752O66446F776E03163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E6703183O00506F776572576F7264466F72746974756465506C6179657203143O002DDBADD86571305D2FD085DB785C335B29C1BED803083O00325DB4DABD172E47027O0040030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C696374656403073O0050656E616E636503103O0050656E616E63654D6F7573656F766572026O004440026O000840026O00104003093O00466C6173684865616C03123O00466C6173684865616C4D6F7573656F766572026O00F03F030D3O00506F776572576F72644C69666503163O00506F776572576F72644C6966654D6F7573656F766572030D3O004461726B52657072696D616E6403163O004461726B52657072696D616E644D6F7573656F76657203063O00507572696679030F3O005075726966794D6F7573656F76657203083O0049734D6F76696E6703063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B03163O0044656164467269656E646C79556E697473436F756E7403103O004D612O73526573752O72656374696F6E03113O00D3A5485F7BCE4DCDB1495E41DF5CD7AB5503073O0028BEC43B2C24BC030C3O00526573752O72656374696F6E030C3O002E40CFA1E86F083F51D5BBF403073O006D5C25BCD49A1D03143O0014E0B3C6236513E0B6C70E5C0BFDB0CA254F00EA03063O003A648FC4A3510023012O0012F13O00013O0026C93O0082000100010004F03O008200012O00AC00015O0020A20001000100020020D60001000100032O00CC0001000200020006232O01002600013O0004F03O002600012O00AC000100013O0006232O01002600013O0004F03O002600012O00AC000100023O00200C2O01000100044O00035O00202O0003000300054O000400016O00010004000200062O0001001B000100010004F03O001B00012O00AC000100033O0020550001000100064O00025O00202O0002000200054O00010002000200062O0001002600013O0004F03O002600012O00AC000100044O00AC000200053O0020A20002000200072O00CC0001000200020006232O01002600013O0004F03O002600012O00AC000100063O0012F1000200083O0012F1000300094O0087000100034O00A500016O00AC000100073O0006232O01008100013O0004F03O008100010012F1000100013O0026C90001003B0001000A0004F03O003B00012O00AC000200033O00205800020002000C4O00035O00202O00030003000D4O000400053O00202O00040004000E00122O0005000F6O00020005000200122O0002000B3O00122O0002000B3O00062O0002003A00013O0004F03O003A000100124F0002000B4O0021010200023O0012F1000100103O0026C90001004D000100110004F03O004D00012O00AC000200033O00202400020002000C4O00035O00202O0003000300124O000400053O00202O00040004001300122O0005000F6O000600016O00020006000200122O0002000B3O00122O0002000B3O00062O0002008100013O0004F03O0081000100124F0002000B4O0021010200023O0004F03O008100010026C90001005E000100140004F03O005E00012O00AC000200033O00205800020002000C4O00035O00202O0003000300154O000400053O00202O00040004001600122O0005000F6O00020005000200122O0002000B3O00122O0002000B3O00062O0002005D00013O0004F03O005D000100124F0002000B4O0021010200023O0012F10001000A3O0026C90001006F000100100004F03O006F00012O00AC000200033O00205800020002000C4O00035O00202O0003000300174O000400053O00202O00040004001800122O0005000F6O00020005000200122O0002000B3O00122O0002000B3O00062O0002006E00013O0004F03O006E000100124F0002000B4O0021010200023O0012F1000100113O000E7C0001002A000100010004F03O002A00012O00AC000200033O00205800020002000C4O00035O00202O0003000300194O000400053O00202O00040004001A00122O0005000F6O00020005000200122O0002000B3O00122O0002000B3O00062O0002007F00013O0004F03O007F000100124F0002000B4O0021010200023O0012F1000100143O0004F03O002A00010012F13O00143O0026C93O00BF000100140004F03O00BF00012O00AC000100083O0006232O0100AC00013O0004F03O00AC00010012F1000100013O0026C900010088000100010004F03O008800012O00AC000200093O0006230102009A00013O0004F03O009A00010012F1000200013O0026C90002008E000100010004F03O008E00012O00AC0003000A4O003A00030001000200123F0003000B3O00124F0003000B3O0006230103009A00013O0004F03O009A000100124F0003000B4O0021010300023O0004F03O009A00010004F03O008E00012O00AC0002000B3O000623010200AC00013O0004F03O00AC00010012F1000200013O0026C90002009E000100010004F03O009E00012O00AC0003000C4O003A00030001000200123F0003000B3O00124F0003000B3O000623010300AC00013O0004F03O00AC000100124F0003000B4O0021010300023O0004F03O00AC00010004F03O009E00010004F03O00AC00010004F03O008800012O00AC000100023O0020D600010001001B2O00CC0001000200020006232O0100BE00013O0004F03O00BE00010012F1000100013O0026C9000100B2000100010004F03O00B200012O00AC0002000D4O003A00020001000200123F0002000B3O00124F0002000B3O000623010200BE00013O0004F03O00BE000100124F0002000B4O0021010200023O0004F03O00BE00010004F03O00B200010012F13O000A3O0026C93O00010001000A0004F03O000100012O00AC0001000E3O0006232O012O002O013O0004F04O002O012O00AC0001000E3O0020D600010001001C2O00CC0001000200020006232O012O002O013O0004F04O002O012O00AC0001000E3O0020D600010001001D2O00CC0001000200020006232O012O002O013O0004F04O002O012O00AC0001000E3O0020D600010001001E2O00CC0001000200020006232O012O002O013O0004F04O002O012O00AC000100023O0020D600010001001F2O00AC0003000E4O007E00010003000200069D00012O002O0100010004F04O002O010012F1000100014O00AD000200023O0026C9000100DB000100010004F03O00DB00012O00AC000300033O0020A20003000300202O003A0003000100022O00D8000200033O000ED9001400F1000100020004F03O00F100012O00AC000300044O001B01045O00202O0004000400214O000500056O000600016O00030006000200062O00032O002O013O0004F04O002O012O00AC000300063O001276000400223O00122O000500236O000300056O00035O00045O002O012O00AC000300044O001B01045O00202O0004000400244O000500056O000600016O00030006000200062O00032O002O013O0004F04O002O012O00AC000300063O001276000400253O00122O000500266O000300056O00035O00045O002O010004F03O00DB00012O00AC00015O0020A20001000100020020D60001000100032O00CC0001000200020006232O0100222O013O0004F03O00222O012O00AC000100023O00200C2O01000100044O00035O00202O0003000300054O000400016O00010004000200062O000100152O0100010004F03O00152O012O00AC000100033O0020550001000100064O00025O00202O0002000200054O00010002000200062O000100222O013O0004F03O00222O012O00AC000100044O00AC000200053O0020A20002000200072O00CC0001000200020006232O0100222O013O0004F03O00222O012O00AC000100063O001276000200273O00122O000300286O000100036O00015O00044O00222O010004F03O000100012O004A3O00017O00133O00028O00026O00F03F03083O0042752O66446F776E030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E7303063O0042752O66557003073O0052617074757265030F3O00506F776572576F7264536869656C6403073O004973526561647903143O00506F776572576F7264536869656C64466F63757303163O000A4D34A62D76F20108461CB03740E0021E022BA63E4503083O006E7A2243C35F298503053O0052656E6577030A3O0052656E6577466F637573030A3O0067B4554FC135B95E4BDA03053O00B615D13B2A030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66026O00344000503O0012F13O00013O000E7C0002003D00013O0004F03O003D00012O00AC00015O0020530001000100034O000300013O00202O0003000300044O00010003000200062O00010012000100010004F03O001200012O00AC00015O0020330001000100054O000300013O00202O0003000300044O0001000300024O000200023O00062O0001004F000100020004F03O004F00012O00AC000100033O0020F90001000100064O000300013O00202O0003000300074O00010003000200062O0001002B00013O0004F03O002B00012O00AC000100013O0020A20001000100080020D60001000100092O00CC0001000200020006232O01004F00013O0004F03O004F00012O00AC000100044O00AC000200053O0020A200020002000A2O00CC0001000200020006232O01004F00013O0004F03O004F00012O00AC000100063O0012760002000B3O00122O0003000C6O000100036O00015O00044O004F00012O00AC000100013O0020A200010001000D0020D60001000100092O00CC0001000200020006232O01004F00013O0004F03O004F00012O00AC000100044O00AC000200053O0020A200020002000E2O00CC0001000200020006232O01004F00013O0004F03O004F00012O00AC000100063O0012760002000F3O00122O000300106O000100036O00015O00044O004F00010026C93O0001000100010004F03O000100012O00AC000100073O0020DE0001000100124O000200013O00202O0002000200044O000300026O000400053O00122O000600136O00010006000200122O000100113O00122O000100113O00062O0001004D00013O0004F03O004D000100124F000100114O00212O0100023O0012F13O00023O0004F03O000100012O004A3O00017O00243O00028O00026O00F03F030E3O00536861646F77436F76656E616E74030B3O004973417661696C61626C65030D3O00456D6272616365536861646F77027O0040026O00104003073O005261707475726503073O004973526561647903083O0042752O66446F776E030C3O0053686F756C6452657475726E03113O00506F776572576F726452616469616E636503163O00506F776572576F726452616469616E6365466F63757303293O00A758D2183381A058D7191EACB653CC1C2FBDB268CC1332AAB659D15D29BBB65BFA1E2EB1BB53CA0A2F03063O00DED737A57D41030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73026O001840030F3O00506F776572576F7264536869656C6403143O00506F776572576F7264536869656C64466F63757303163O003CDED11FE0FEFA453ED5F909FAC8E8462891CE1FF3CD03083O002A4CB1A67A92A18D030C3O0052617074757265466F637573030C3O00B78B15DA6C64A0CA0DCB787A03063O0016C5EA65AE19030F3O0048617273684469736369706C696E6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66026O000840030A3O00432O6F6C646F776E557003063O0042752O66557003123O00536861646F77436F76656E616E7442752O6603183O00466F637573556E69745265667265736861626C6542752O66026O00344003073O0047657454696D6503113O0053686F756C645261707475726552616D7000E93O0012F13O00014O00AD000100013O0026C93O001C000100020004F03O001C00012O00AC000200013O0020A20002000200030020D60002000200042O00CC0002000200020006230102000E00013O0004F03O000E00012O00AC000200013O0020A20002000200050020D60002000200042O00CC0002000200022O001401026O001D000200013O00202O00020002000300202O0002000200044O00020002000200062O0002001A00013O0004F03O001A00012O00AC000200013O0020A20002000200050020D60002000200042O00CC0002000200022O00B6000200024O0014010200023O0012F13O00063O000E7C000700A200013O0004F03O00A200012O00AC000200013O0020A20002000200080020D60002000200092O00CC00020002000200069D0002006C000100010004F03O006C00012O00AC000200033O0020F900020002000A4O000400013O00202O0004000400084O00020004000200062O0002006C00013O0004F03O006C00010012F1000200013O0026C900020042000100020004F03O004200012O00AC00035O0006230103006C00013O0004F03O006C00012O00AC000300043O0006230103006C00013O0004F03O006C00010012F1000300013O0026C900030035000100010004F03O003500012O00AC000400054O003A00040001000200123F0004000B3O00124F0004000B3O0006230104006C00013O0004F03O006C000100124F0004000B4O0021010400023O0004F03O006C00010004F03O003500010004F03O006C00010026C90002002C000100010004F03O002C00012O00AC000300013O0020A200030003000C0020D60003000300092O00CC0003000200020006230103005700013O0004F03O005700012O00AC000300064O0039000400073O00202O00040004000D4O000500056O000600086O00030006000200062O0003005700013O0004F03O005700012O00AC000300093O0012F10004000E3O0012F10005000F4O0087000300054O00A500036O00AC000300023O0006230103006A00013O0004F03O006A00012O00AC000300043O0006230103006A00013O0004F03O006A00010012F1000300013O0026C90003005E000100010004F03O005E00012O00AC0004000A4O003A00040001000200123F0004000B3O00124F0004000B3O0006230104006A00013O0004F03O006A000100124F0004000B4O0021010400023O0004F03O006A00010004F03O005E00010012F1000200023O0004F03O002C00012O00AC0002000B3O00205300020002000A4O000400013O00202O0004000400104O00020004000200062O0002007A000100010004F03O007A00012O00AC0002000B3O0020910002000200114O000400013O00202O0004000400104O00020004000200262O000200E8000100120004F03O00E800010012F1000200013O000E7C0001007B000100020004F03O007B00012O00AC000300013O0020A20003000300130020D60003000300092O00CC0003000200020006230103008E00013O0004F03O008E00012O00AC000300064O00AC000400073O0020A20004000400142O00CC0003000200020006230103008E00013O0004F03O008E00012O00AC000300093O0012F1000400153O0012F1000500164O0087000300054O00A500036O00AC000300013O0020A20003000300080020D60003000300092O00CC000300020002000623010300E800013O0004F03O00E800012O00AC000300064O00AC000400073O0020A20004000400172O00CC000300020002000623010300E800013O0004F03O00E800012O00AC000300093O001276000400183O00122O000500196O000300056O00035O00044O00E800010004F03O007B00010004F03O00E800010026C93O00C4000100060004F03O00C400012O00AC000200013O0020A200020002001A0020D60002000200042O00CC000200020002000623010200B200013O0004F03O00B200012O00AC000200033O00201C00020002001B4O000400013O00202O00040004001C4O00020004000200262O000200B20001001D0004F03O00B200012O001001026O0056000200014O002B0002000C6O000200013O00202O00020002000300202O00020002001E4O00020002000200062O000200BD00013O0004F03O00BD00012O00AC0002000C3O00069D000200C2000100010004F03O00C200012O00AC000200033O0020D600020002001F2O00AC000400013O0020A20004000400202O007E0002000400022O0014010200043O0012F13O001D3O0026C93O00D50001001D0004F03O00D500012O00AC0002000D3O00205C0002000200214O000300013O00202O00030003001000122O000400126O000500063O00122O000700226O00020007000200122O0002000B3O00122O0002000B3O00062O000200D400013O0004F03O00D4000100124F0002000B4O0021010200023O0012F13O00073O0026C93O0002000100010004F03O0002000100124F000200234O003A0002000100022O00AC0003000E4O0030000100020003000ED9002200E6000100010004F03O00E600010012F1000200013O0026C9000200DE000100010004F03O00DE00012O005600035O00123F000300243O0012F1000300014O00140103000E3O0004F03O00E600010004F03O00DE00010012F13O00023O0004F03O000200012O004A3O00017O00283O00028O00027O0040030F3O0048617273684469736369706C696E65030B3O004973417661696C61626C6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66026O000840030E3O00536861646F77436F76656E616E74030A3O00432O6F6C646F776E557003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66026O00F03F030D3O00456D6272616365536861646F77030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66030D3O0041746F6E656D656E7442752O66026O001840026O003440026O001040030A3O004576616E67656C69736D03073O004973526561647903083O0042752O66446F776E030B3O0042752O6652656D61696E73030F3O00506F776572576F7264536869656C6403143O00506F776572576F7264536869656C64466F63757303163O003D3BB2D96490C0893F309ACF7EA6D28A2974ADD977A303083O00E64D54C5BC16CFB7026O001C4003113O00506F776572576F726452616469616E636503163O00506F776572576F726452616469616E6365466F63757303293O00E91BD1F92O9EE73AEB10F9EE8DA5F934F7172OC385AFE321F81AD2BC84A4F139C617C9F380A5FF22F703083O00559974A69CECC190030F3O00A1F64CBDE305A8E95EBEA408A1E14103063O0060C4802DD38403053O0052656E6577030A3O0052656E6577466F637573030A3O002788755AC5EFBCDD348103083O00B855ED1B3FB2CFD403073O0047657454696D6503143O0053686F756C644576616E67656C69736D52616D7000F63O0012F13O00014O00AD000100013O0026C93O0024000100020004F03O002400012O00AC000200013O0020A20002000200030020D60002000200042O00CC0002000200020006230102001200013O0004F03O001200012O00AC000200023O00201C0002000200054O000400013O00202O0004000400064O00020004000200262O00020012000100070004F03O001200012O001001026O0056000200014O002B00028O000200013O00202O00020002000800202O0002000200094O00020002000200062O0002001D00013O0004F03O001D00012O00AC00025O00069D00020022000100010004F03O002200012O00AC000200023O0020D600020002000A2O00AC000400013O0020A200040004000B2O007E0002000400022O0014010200033O0012F13O00073O0026C93O003E0001000C0004F03O003E00012O00AC000200013O0020A20002000200080020D60002000200042O00CC0002000200020006230102003000013O0004F03O003000012O00AC000200013O0020A200020002000D0020D60002000200042O00CC0002000200022O0014010200044O001D000200013O00202O00020002000800202O0002000200044O00020002000200062O0002003C00013O0004F03O003C00012O00AC000200013O0020A200020002000D0020D60002000200042O00CC0002000200022O00B6000200024O0014010200053O0012F13O00023O0026C93O004F000100070004F03O004F00012O00AC000200063O00205C00020002000F4O000300013O00202O00030003001000122O000400116O000500063O00122O000700126O00020007000200122O0002000E3O00122O0002000E3O00062O0002004E00013O0004F03O004E000100124F0002000E4O0021010200023O0012F13O00133O0026C93O00E2000100130004F03O00E200012O00AC000200013O0020A20002000200140020D60002000200152O00CC00020002000200069D00020082000100010004F03O008200010012F1000200013O0026C900020058000100010004F03O005800012O00AC000300053O0006230103006D00013O0004F03O006D00012O00AC000300033O0006230103006D00013O0004F03O006D00010012F1000300013O0026C900030061000100010004F03O006100012O00AC000400074O003A00040001000200123F0004000E3O00124F0004000E3O0006230104006D00013O0004F03O006D000100124F0004000E4O0021010400023O0004F03O006D00010004F03O006100012O00AC000300043O0006230103008200013O0004F03O008200012O00AC000300033O0006230103008200013O0004F03O008200010012F1000300013O0026C900030074000100010004F03O007400012O00AC000400084O003A00040001000200123F0004000E3O00124F0004000E3O0006230104008200013O0004F03O0082000100124F0004000E4O0021010400023O0004F03O008200010004F03O007400010004F03O008200010004F03O005800012O00AC000200093O0020530002000200164O000400013O00202O0004000400104O00020004000200062O00020090000100010004F03O009000012O00AC000200093O0020910002000200174O000400013O00202O0004000400104O00020004000200262O000200F5000100110004F03O00F500010012F1000200013O0026C9000200CC000100010004F03O00CC00012O00AC000300013O0020A20003000300180020D60003000300152O00CC000300020002000623010300A400013O0004F03O00A400012O00AC0003000A4O00AC0004000B3O0020A20004000400192O00CC000300020002000623010300A400013O0004F03O00A400012O00AC0003000C3O0012F10004001A3O0012F10005001B4O0087000300054O00A500035O000ED9001C00CB000100010004F03O00CB00012O00AC000300013O0020A200030003001D0020D60003000300152O00CC000300020002000623010300BA00013O0004F03O00BA00012O00AC0003000A4O00390004000B3O00202O00040004001E4O000500056O0006000D6O00030006000200062O000300CB00013O0004F03O00CB00012O00AC0003000C3O0012760004001F3O00122O000500206O000300056O00035O00044O00CB00012O00AC000300013O0020A20003000300140020D60003000300152O00CC000300020002000623010300CB00013O0004F03O00CB00012O00AC0003000A4O00AC000400013O0020A20004000400142O00CC000300020002000623010300CB00013O0004F03O00CB00012O00AC0003000C3O0012F1000400213O0012F1000500224O0087000300054O00A500035O0012F10002000C3O0026C9000200910001000C0004F03O009100012O00AC000300013O0020A20003000300230020D60003000300152O00CC000300020002000623010300F500013O0004F03O00F500012O00AC0003000A4O00AC0004000B3O0020A20004000400242O00CC000300020002000623010300F500013O0004F03O00F500012O00AC0003000C3O001276000400253O00122O000500266O000300056O00035O00044O00F500010004F03O009100010004F03O00F500010026C93O0002000100010004F03O0002000100124F000200274O003A0002000100022O00AC0003000E4O0030000100020003000ED9001200F3000100010004F03O00F300010012F1000200013O0026C9000200EB000100010004F03O00EB00012O005600035O00123F000300283O0012F1000300014O00140103000E3O0004F03O00F300010004F03O00EB00010012F13O000C3O0004F03O000200012O004A3O00017O002C3O00028O00026O00F03F030E3O00536861646F77436F76656E616E74030B3O004973417661696C61626C65030D3O00456D6272616365536861646F77030F3O0048617273684469736369706C696E6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66026O000840030A3O00432O6F6C646F776E557003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66027O004003073O005261707475726503073O004973526561647903083O0042752O66446F776E026O00244003113O00506F776572576F726452616469616E636503163O00506F776572576F726452616469616E6365466F63757303293O0018561E5A1A661E501A5D364D095D005E065A0C6001571A4B09571D1F005C0853375A0650045D06480603043O003F683969030A3O004576616E67656C69736D030F3O000E91A54A0C82A84D188AE44C0E86A803043O00246BE7C403053O0052656E6577030A3O0052656E6577466F637573030A3O004FB0AC824AF5AA825CB903043O00E73DD5C2030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73026O001840030F3O00506F776572576F7264536869656C6403143O00506F776572576F7264536869656C64466F63757303163O0019A22A761B922A7C1BA9026001A4387F0DED357608A103043O001369CD5D030C3O0052617074757265466F637573030C3O00BB09CE952ABB0D9E893AA80403053O005FC968BEE103073O0047657454696D65026O003940030E3O0053686F756C64426F746852616D70030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66026O0034400013012O0012F13O00014O00AD000100013O0026C93O0030000100020004F03O003000012O00AC000200013O0020A20002000200030020D60002000200042O00CC0002000200020006230102000F00013O0004F03O000F00012O00AC000200013O0020A20002000200050020D60002000200042O00CC0002000200022O00B6000200024O001401026O001D000200013O00202O00020002000600202O0002000200044O00020002000200062O0002001E00013O0004F03O001E00012O00AC000200033O00201C0002000200074O000400013O00202O0004000400084O00020004000200262O0002001E000100090004F03O001E00012O001001026O0056000200014O002B000200026O000200013O00202O00020002000300202O00020002000A4O00020002000200062O0002002900013O0004F03O002900012O00AC000200023O00069D0002002E000100010004F03O002E00012O00AC000200033O0020D600020002000B2O00AC000400013O0020A200040004000C2O007E0002000400022O0014010200043O0012F13O000D3O0026C93O00B2000100090004F03O00B200012O00AC000200013O0020A200020002000E0020D600020002000F2O00CC00020002000200069D0002007C000100010004F03O007C00012O00AC000200033O0020F90002000200104O000400013O00202O00040004000E4O00020004000200062O0002007C00013O0004F03O007C00010012F1000200013O0026C900020040000100010004F03O00400001000ED900110069000100010004F03O006900012O00AC000300013O0020A20003000300120020D600030003000F2O00CC0003000200020006230103005800013O0004F03O005800012O00AC000300054O0039000400063O00202O0004000400134O000500056O000600076O00030006000200062O0003006900013O0004F03O006900012O00AC000300083O001276000400143O00122O000500156O000300056O00035O00044O006900012O00AC000300013O0020A20003000300160020D600030003000F2O00CC0003000200020006230103006900013O0004F03O006900012O00AC000300054O00AC000400013O0020A20004000400162O00CC0003000200020006230103006900013O0004F03O006900012O00AC000300083O0012F1000400173O0012F1000500184O0087000300054O00A500036O00AC000300013O0020A20003000300190020D600030003000F2O00CC0003000200020006230103007C00013O0004F03O007C00012O00AC000300054O00AC000400063O0020A200040004001A2O00CC0003000200020006230103007C00013O0004F03O007C00012O00AC000300083O0012760004001B3O00122O0005001C6O000300056O00035O00044O007C00010004F03O004000012O00AC000200093O0020530002000200104O000400013O00202O00040004001D4O00020004000200062O0002008A000100010004F03O008A00012O00AC000200093O00209100020002001E4O000400013O00202O00040004001D4O00020004000200262O000200122O01001F0004F03O00122O010012F1000200013O0026C90002008B000100010004F03O008B00012O00AC000300013O0020A20003000300200020D600030003000F2O00CC0003000200020006230103009E00013O0004F03O009E00012O00AC000300054O00AC000400063O0020A20004000400212O00CC0003000200020006230103009E00013O0004F03O009E00012O00AC000300083O0012F1000400223O0012F1000500234O0087000300054O00A500036O00AC000300013O0020A200030003000E0020D600030003000F2O00CC000300020002000623010300122O013O0004F03O00122O012O00AC000300054O00AC000400063O0020A20004000400242O00CC000300020002000623010300122O013O0004F03O00122O012O00AC000300083O001276000400253O00122O000500266O000300056O00035O00044O00122O010004F03O008B00010004F03O00122O010026C93O00CF000100010004F03O00CF000100124F000200274O003A0002000100022O00AC0003000A4O0030000100020003000ED9002800C3000100010004F03O00C300010012F1000200013O0026C9000200BB000100010004F03O00BB00012O005600035O00123F000300293O0012F1000300014O00140103000A3O0004F03O00C300010004F03O00BB00012O00AC000200013O0020A20002000200030020D60002000200042O00CC000200020002000623010200CD00013O0004F03O00CD00012O00AC000200013O0020A20002000200050020D60002000200042O00CC0002000200022O00140102000B3O0012F13O00023O0026C93O00020001000D0004F03O000200012O00AC0002000C3O00205C00020002002B4O000300013O00202O00030003001D00122O0004001F6O000500063O00122O0007002C6O00020007000200122O0002002A3O00122O0002002A3O00062O000200DF00013O0004F03O00DF000100124F0002002A4O0021010200024O00AC000200013O0020A20002000200160020D600020002000F2O00CC00020002000200069D000200102O0100010004F03O00102O010012F1000200013O000E7C000100E6000100020004F03O00E600012O00AC00035O000623010300FB00013O0004F03O00FB00012O00AC000300043O000623010300FB00013O0004F03O00FB00010012F1000300013O0026C9000300EF000100010004F03O00EF00012O00AC0004000D4O003A00040001000200123F0004002A3O00124F0004002A3O000623010400FB00013O0004F03O00FB000100124F0004002A4O0021010400023O0004F03O00FB00010004F03O00EF00012O00AC0003000B3O000623010300102O013O0004F03O00102O012O00AC000300043O000623010300102O013O0004F03O00102O010012F1000300013O0026C9000300022O0100010004F03O00022O012O00AC0004000E4O003A00040001000200123F0004002A3O00124F0004002A3O000623010400102O013O0004F03O00102O0100124F0004002A4O0021010400023O0004F03O00102O010004F03O00022O010004F03O00102O010004F03O00E600010012F13O00093O0004F03O000200012O004A3O00017O00423O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030A3O009AD8C4FCAE2OC8CFA3D803043O00AECFABA103103O00D8ED08DBFDD6E1F703F4C8D8F9F702FD03063O00B78D9E6D939803113O00040CE7002507E13C231DEF032227E7012903043O006C4C6986034O00030F3O00C3C0B0EDC7E5C281EEDAE2CABFC9FE03053O00AE8BA5D181026O00F03F027O0040030D3O0087BAF1D1C30F547DA1A6E4C7D503083O0018C3D382A1A66310030B3O00620AFA3C561A6416EF2A4003063O00762663894C33030F3O00D5270B160525DC20031E0023E9230103063O00409D4665726903113O00682OA9E71C4581A9E01F52B8A8F11541A403053O007020C8C783026O00084003113O00055E48BDD1B9373C446BB1D7A31138455203073O00424C303CD8A3CB03163O0093886DF64DDC31AA9256FD53D713B28F6DF653C737AE03073O0044DAE619933FAE03123O0084244749A4BF3F435882A538565FBEA2265703053O00D6CD4A332C03123O00CF5FE7D872E95CE7EE76EE49D2EE76E349F003053O00179A2C829C026O00104003113O0035A32OBE330110B2A89E241208A3BF860603063O007371C6CDCE5603073O00B144FB7C8553FB03043O003AE4379E03063O009288D42B149D03073O0055D4E9B04E5CCD030E3O007F4B8DCA4F5984F6424B9CED445D03043O00822A38E8026O001440030D3O00C2B025EF5437F9A12BED4517DA03063O005F8AD544832003123O001A27B646640326A756652327AF76652B2FA403053O00164A48C12303133O001C76F35D3E50EA5E396AED57224DE54A2B7CF003043O00384C1984030F3O006ECEBC23DD77CFAD33DC57CEA50EFF03053O00AF3EA1CB46026O00184003153O0009CEC6233A2BD8D1243A2ED9E51C2728D4D706313903053O00555CBDA37303113O001CBF351927AB353420AF163D28B8383D3B03043O005849CC50030E3O001B90156426DE37A21E421AD53B8F03063O00BA4EE3702649030D3O00D158EB505E7FF243D9505F7BE503063O001A9C379D353303123O00BCD701DCAA7982DE03CAB15F82FF04D6AD4003063O0030ECB876B9D803073O00D5947931C231B403063O005485DD3750AF03073O008DCE0AA7CA59EF03063O003CDD8744C6A703073O00DE94D6824FDCBD03063O00B98EDD98E322001F012O0012F13O00013O0026C93O002A000100010004F03O002A000100124F000100023O0020120001000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O00122O000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O00010001000200062O0001001D000100010004F03O001D00010012F10001000A4O00142O0100033O001219000100023O00202O0001000100034O000200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200062O00010028000100010004F03O002800010012F1000100014O00142O0100043O0012F13O000D3O0026C93O004D0001000E0004F03O004D000100124F000100023O0020DF0001000100034O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00122O000100023O00202O0001000100034O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100073O00122O000100023O00202O0001000100034O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00124O00173O0026C93O0070000100170004F03O0070000100124F000100023O0020DF0001000100034O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00122O000100023O00202O0001000100034O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00122O000100023O00202O0001000100034O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100023O00202O0001000100034O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00124O00203O0026C93O0099000100200004F03O0099000100124F000100023O0020830001000100034O000200013O00122O000300213O00122O000400226O0002000400024O00010001000200062O0001007C000100010004F03O007C00010012F1000100014O00142O01000D3O001297000100023O00202O0001000100034O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100023O00202O0001000100034O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O0001008F000100010004F03O008F00010012F1000100014O00142O01000F3O001272000100023O00202O0001000100034O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O000100103O00124O00293O0026C93O00C8000100290004F03O00C8000100124F000100023O0020830001000100034O000200013O00122O0003002A3O00122O0004002B6O0002000400024O00010001000200062O000100A5000100010004F03O00A500010012F1000100014O00142O0100113O001219000100023O00202O0001000100034O000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200062O000100B0000100010004F03O00B000010012F10001000A4O00142O0100123O001219000100023O00202O0001000100034O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100BB000100010004F03O00BB00010012F10001000A4O00142O0100133O001219000100023O00202O0001000100034O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100C6000100010004F03O00C600010012F1000100014O00142O0100143O0012F13O00323O0026C93O00EE0001000D0004F03O00EE000100124F000100023O00207D0001000100034O000200013O00122O000300333O00122O000400346O0002000400024O0001000100024O000100153O00122O000100023O0020120001000100034O000200013O00122O000300353O00122O000400366O0002000400024O0001000100024O000100163O00122O000100023O00202O0001000100034O000200013O00122O000300373O00122O000400386O0002000400024O0001000100024O000100173O00122O000100023O00202O0001000100034O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100EC000100010004F03O00EC00010012F1000100014O00142O0100183O0012F13O000E3O0026C93O0001000100320004F03O0001000100124F000100023O0020830001000100034O000200013O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200062O000100FA000100010004F03O00FA00010012F1000100014O00142O0100193O001219000100023O00202O0001000100034O000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200062O000100052O0100010004F03O00052O010012F10001000A4O00142O01001A3O001219000100023O00202O0001000100034O000200013O00122O0003003F3O00122O000400406O0002000400024O00010001000200062O000100102O0100010004F03O00102O010012F10001000A4O00142O01001B3O001219000100023O00202O0001000100034O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O0001001B2O0100010004F03O001B2O010012F10001000A4O00142O01001C3O0004F03O001E2O010004F03O000100012O004A3O00017O004E3O00028O00026O001440030C3O004570696353652O74696E677303083O0053652O74696E6773030F3O007DD356F44436FB51D65ADD513CE24803073O009738A5379A2353030B3O00864F04FDA86B00EFAC6B3503043O008EC0236503103O00F07928B0EFA4A917DA463CB1E089842603083O0076B61549C387ECCC03123O002E301B530C25F8093038490A09F4063B327003073O009D685C7A20646D026O001840026O001C4003113O0093A9D8CF2F1082B9A795C7C3382B89839303083O00CBC3C6AFAA5D47ED03153O001E4429D04326F33C4F0DDD5814F02A7F3FDB5A39CC03073O009C4E2B5EB5317103163O0053FCCBAD0E4E2O7CFCF7B319467876DAC1A519466A7A03073O00191288A4C36B2303193O00C939A64177B1C4B6FC1EB95D77BDC588E93FBD5655AECEADF803083O00D8884DC92F12DCA1026O002040027O004003143O001DED22D43BC9923DFE2EC91BD58D23D938DB0FD903073O00E24D8C4BBA68BC034O0003103O008CDDD50F40AECBC20840ABCAFC3649BC03053O002FD9AEB05F030F3O0088D26107A0637734BCF17F04B77C4803083O0046D8BD1662D2341803123O00EFCCA6ABC6D7D6AD88C6C9FDA295C1D3DAB103053O00B3BABFC3E7026O00084003093O00C93A16E5F73C1DCCC903043O0084995F78030B3O0090A60123F2D7A5BFA6261D03073O00C0D1D26E4D97BA030E3O00C1172DE7FAC9E50D36CEEDCBF51303063O00A4806342899F03143O00359AEC8E0F9EECAC3786FBBA3288EDB70187EABB03043O00DE60E989026O00F03F026O00104003093O0091B2AB10AFE1FFACA303073O0090D9D3C77FE893030D3O00CD3C3B0CDC530B4AFD1C2A29C703083O0024984F5E48B52562030D3O00E2CB421AC1D94938D2D44E2CDA03043O005FB7B827030C3O009029E62853850EBC2CEA0E6403073O0062D55F874634E003133O00CEACDE7246C9ACDB7366FFA7C0765AFDA6E14703053O00349EC3A91703163O004AB32571940274997E8E33708F3475887F9B207B932503083O00EB1ADC5214E6551B03123O00BDB2ECF27581AFDAD76498B3ECD16781AEE703053O0014E8C189A203113O0012DECCA8D499076130DAD6B5EE8319591203083O001142BFA5C687EC7703183O002EBBA11DFAE5E9DF1B9CBE01FAE9E8E30EA6AA34EDE7F9C103083O00B16FCFCE739F888C03113O00299C2O1DDA404A16AB1106C6465A17A12003073O003F65E97074B42F03143O00EF2EE01BF639D628CF13EA24CA3EFF35EA39D62B03063O0056A35B8D729803073O006618715B3B5F0403053O005A336B141303063O00A5F189E015BD03053O005DED90E58F030A3O0020E5F52B0A5601E3E21C03063O0026759690796B03093O001FBAFE2E38A9EB121D03043O005A4DDB8E030C3O00D405312D59157FC1162E2C5C03073O001A866441592C6703073O00C3E63E26B3D9D303053O00C4918350430071012O0012F13O00013O0026C93O0030000100020004F03O0030000100124F000100033O0020830001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004F03O000D00010012F1000100014O00142O015O001219000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O00010001000200062O00010018000100010004F03O001800010012F1000100014O00142O0100023O001219000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200062O00010023000100010004F03O002300010012F1000100014O00142O0100033O001219000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200062O0001002E000100010004F03O002E00010012F1000100014O00142O0100043O0012F13O000D3O000E7C000E005F00013O0004F03O005F000100124F000100033O0020830001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O00010001000200062O0001003C000100010004F03O003C00010012F1000100014O00142O0100053O001219000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O00010001000200062O00010047000100010004F03O004700010012F1000100014O00142O0100063O001219000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O00010001000200062O00010052000100010004F03O005200010012F1000100014O00142O0100073O001219000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O00010001000200062O0001005D000100010004F03O005D00010012F1000100014O00142O0100083O0012F13O00173O0026C93O0088000100180004F03O0088000100124F000100033O0020830001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O00010001000200062O0001006B000100010004F03O006B00010012F10001001B4O00142O0100093O001297000100033O00202O0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200062O0001007E000100010004F03O007E00010012F1000100014O00142O01000B3O001272000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000C3O00124O00223O0026C93O00B4000100010004F03O00B4000100124F000100033O0020830001000100044O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O00010094000100010004F03O009400010012F1000100014O00142O01000D3O001219000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O0001009F000100010004F03O009F00010012F1000100014O00142O01000E3O001219000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O00010001000200062O000100AA000100010004F03O00AA00010012F1000100014O00142O01000F3O001272000100033O00202O0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100103O00124O002B3O0026C93O00DD0001002C0004F03O00DD000100124F000100033O0020830001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200062O000100C0000100010004F03O00C000010012F1000100014O00142O0100113O00124F000100033O0020120001000100044O000200013O00122O0003002F3O00122O000400306O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O000300313O00122O000400326O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O000300333O00122O000400346O0002000400024O00010001000200062O000100DB000100010004F03O00DB00010012F1000100014O00142O0100143O0012F13O00023O000E7C002B00092O013O0004F03O00092O0100124F000100033O0020830001000100044O000200013O00122O000300353O00122O000400366O0002000400024O00010001000200062O000100E9000100010004F03O00E900010012F1000100014O00142O0100153O001219000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O00010001000200062O000100F4000100010004F03O00F400010012F1000100014O00142O0100163O001297000100033O00202O0001000100044O000200013O00122O000300393O00122O0004003A6O0002000400024O0001000100024O000100173O00122O000100033O00202O0001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200062O000100072O0100010004F03O00072O010012F1000100014O00142O0100183O0012F13O00183O0026C93O00172O0100170004F03O00172O0100124F000100033O0020830001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200062O000100152O0100010004F03O00152O010012F1000100014O00142O0100193O0004F03O00702O010026C93O00432O0100220004F03O00432O0100124F000100033O0020830001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O00010001000200062O000100232O0100010004F03O00232O010012F1000100014O00142O01001A3O001219000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O0001002E2O0100010004F03O002E2O010012F1000100014O00142O01001B3O001297000100033O00202O0001000100044O000200013O00122O000300433O00122O000400446O0002000400024O0001000100024O0001001C3O00122O000100033O00202O0001000100044O000200013O00122O000300453O00122O000400466O0002000400024O00010001000200062O000100412O0100010004F03O00412O010012F1000100014O00142O01001D3O0012F13O002C3O0026C93O00010001000D0004F03O0001000100124F000100033O0020222O01000100044O000200013O00122O000300473O00122O000400486O0002000400024O0001000100024O0001001E3O00122O000100033O00202O0001000100044O000200013O00122O000300493O00122O0004004A6O0002000400024O00010001000200062O000100572O0100010004F03O00572O010012F1000100014O00142O01001F3O001219000100033O00202O0001000100044O000200013O00122O0003004B3O00122O0004004C6O0002000400024O00010001000200062O000100622O0100010004F03O00622O010012F1000100014O00142O0100203O001219000100033O00202O0001000100044O000200013O00122O0003004D3O00122O0004004E6O0002000400024O00010001000200062O0001006D2O0100010004F03O006D2O010012F1000100014O00142O0100213O0012F13O000E3O0004F03O000100012O004A3O00017O00463O00028O00026O00084003083O004973496E5261696403093O004973496E5061727479026O00F03F031A3O00467269656E646C79556E6974735769746842752O66436F756E74030D3O0041746F6E656D656E7442752O6603073O005365744356617203083O002CB10B183BDE1FA203063O00887ED066687803073O005261707475726503073O004973526561647903053O00706169727303103O0052616D705261707475726554696D6573030E3O004973497454696D65546F52616D70026O00144003083O004A8BC3538C643C4303083O003118EAAE23CF325D030A3O00436F6D62617454696D65030A3O004576616E67656C69736D03133O0052616D704576616E67656C69736D54696D657303083O003EF3F098523AF3EF03053O00116C929DE8027O0040030D3O0052616D70426F746854696D657303083O0079C219FD0C9E4AD103063O00C82BA3748D4F030D3O004973446561644F7247686F737403093O0049734D6F756E746564026O00104003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66030D3O004461726B52657072696D616E6403073O0050656E616E636503103O00446976696E6553746172536861646F77030A3O00446976696E6553746172030A3O0048616C6F536861646F7703043O0048616C6F03083O0042752O66446F776E03153O0052616469616E7450726F766964656E636542752O66026O001840030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00B0393E03073O0083DF565DE3D0942O033O00E041A503063O00D583252OD67D03063O002O2236AFE42A03053O0081464B45DF030F3O00432O6F6C646F776E52656D61696E73026O00364003083O0049734D6F76696E6703073O0047657454696D65030F3O00412O66656374696E67436F6D62617403063O00507572696679030C3O0053686F756C6452657475726E03093O00466F637573556E6974026O003440030A3O00456E656D69657334307903113O00476574456E656D696573496E52616E6765026O00444003163O00476574456E656D696573496E4D656C2O6552616E6765026O002840026O00384003043O0054CAFEF903063O008F26AB93891C03063O00C392ABF602E703073O00B4B0E2D9936383030C3O0053757267656F664C69676874030C3O0049734368612O6E656C696E6700A4022O0012F13O00014O00AD000100053O0026C93O00BE000100020004F03O00BE00012O00AC00065O0020D60006000600032O00CC00060002000200069D0006000F000100010004F03O000F00012O00AC00065O0020D60006000600042O00CC00060002000200069D0006000F000100010004F03O000F00010012F1000500053O0006232O01001B00013O0004F03O001B00012O00AC000600013O0020FB0006000600064O000700023O00202O0007000700074O00088O00098O00060009000200062O0005001B000100060004F03O001B00012O005600016O00AC000600033O000623010600B100013O0004F03O00B100010012F1000600013O000E7C00010053000100060004F03O0053000100124F000700084O00A0000800043O00122O000900093O00122O000A000A6O0008000A000200122O000900016O0007000900014O000700023O00202O00070007000B00202O00070007000C4O00070002000200062O0007005200013O0004F03O0052000100069D00020052000100010004F03O0052000100124F0007000D3O00124F0008000E4O00030007000200090004F03O005000012O00AC000C00013O002035000C000C000F4O000D000A6O000E000B3O00122O000F00106O000C000F000200062O000C005000013O0004F03O005000010012F1000C00013O0026C9000C0048000100010004F03O004800012O0056000200013O001298000D00086O000E00043O00122O000F00113O00122O001000126O000E0010000200122O000F00056O000D000F000100122O000C00053O0026C9000C003D000100050004F03O003D00012O00AC000D00063O0020A2000D000D00132O003A000D000100022O0014010D00053O0004F03O005000010004F03O003D000100068100070034000100020004F03O003400010012F1000600053O0026C90006001F000100050004F03O001F00012O00AC000700023O0020A20007000700140020D600070007000C2O00CC0007000200020006230107007F00013O0004F03O007F000100069D0003007F000100010004F03O007F000100124F0007000D3O00124F000800154O00030007000200090004F03O007D00012O00AC000C00013O002035000C000C000F4O000D000A6O000E000B3O00122O000F00106O000C000F000200062O000C007D00013O0004F03O007D00010012F1000C00013O0026C9000C0071000100050004F03O007100012O00AC000D00063O0020A2000D000D00132O003A000D000100022O0014010D00053O0004F03O007D00010026C9000C006A000100010004F03O006A00012O0056000300013O001204000D00086O000E00043O00122O000F00163O00122O001000176O000E0010000200122O000F00186O000D000F000100122O000C00053O00044O006A000100068100070061000100020004F03O006100012O00AC000700023O0020A20007000700140020D600070007000C2O00CC000700020002000623010700B100013O0004F03O00B100012O00AC000700023O0020A200070007000B0020D600070007000C2O00CC000700020002000623010700B100013O0004F03O00B1000100069D000400B1000100010004F03O00B1000100124F0007000D3O00124F000800194O00030007000200090004F03O00AD00012O00AC000C00013O002035000C000C000F4O000D000A6O000E000B3O00122O000F00106O000C000F000200062O000C00AD00013O0004F03O00AD00010012F1000C00013O000E7C000500A10001000C0004F03O00A100012O00AC000D00063O0020A2000D000D00132O003A000D000100022O0014010D00053O0004F03O00AD00010026C9000C009A000100010004F03O009A00012O0056000400013O001204000D00086O000E00043O00122O000F001A3O00122O0010001B6O000E0010000200122O000F00026O000D000F000100122O000C00053O00044O009A000100068100070091000100020004F03O009100010004F03O00B100010004F03O001F00012O00AC00065O0020D600060006001C2O00CC000600020002000623010600B700013O0004F03O00B700012O004A3O00014O00AC00065O0020D600060006001D2O00CC000600020002000623010600BD00013O0004F03O00BD00012O004A3O00013O0012F13O001E3O0026C93O00062O0100100004F03O00062O010012F1000600013O0026C9000600C1000100010004F03O00C100012O00AC000700084O00A9000700076O000700076O0007000A6O000700076O000700093O00044O00D500010004F03O00C100010004F03O00D500010012F1000600013O0026C9000600CD000100010004F03O00CD00010012F1000700054O0014010700093O0012F1000700054O0014010700073O0004F03O00D500010004F03O00CD00012O00AC00065O0020F900060006001F4O000800023O00202O0008000800204O00060008000200062O000600E000013O0004F03O00E000012O00AC000600023O0020A200060006002100069D000600E2000100010004F03O00E200012O00AC000600023O0020A20006000600222O00140106000B4O00FE00065O00202O00060006001F4O000800023O00202O0008000800204O00060008000200062O000600EE00013O0004F03O00EE00012O00AC000600023O0020A200060006002300069D000600F0000100010004F03O00F000012O00AC000600023O0020A20006000600242O00140106000C4O00FE00065O00202O00060006001F4O000800023O00202O0008000800204O00060008000200062O000600FC00013O0004F03O00FC00012O00AC000600023O0020A200060006002500069D000600FE000100010004F03O00FE00012O00AC000600023O0020A20006000600262O00140106000D4O005700065O00202O0006000600274O000800023O00202O0008000800284O0006000800024O0006000E3O00124O00293O0026C93O00252O0100010004F03O00252O012O00AC0006000F4O00C60006000100014O000600106O00060001000100122O0006002A3O00202O00060006002B4O000700043O00122O0008002C3O00122O0009002D6O0007000900024O0006000600074O000600113O00122O0006002A3O00202O00060006002B4O000700043O00122O0008002E3O00122O0009002F6O0007000900024O0006000600074O000600123O00122O0006002A3O00202O00060006002B4O000700043O00122O000800303O00122O000900316O0007000900024O0006000600074O000600133O00124O00053O0026C93O00B82O0100180004F03O00B82O012O005600046O005600066O0014010600144O00AC000600033O000623010600AB2O013O0004F03O00AB2O010012F1000600013O0026C90006005F2O0100050004F03O005F2O0100124F0007000D3O00124F000800194O00030007000200090004F03O005C2O0100124F000C000D4O00D8000D000B4O0003000C0002000E0004F03O005A2O012O00AC001100023O00202200110011000B00202O0011001100324O0011000200024O001200063O00202O0012001200134O0012000100024O00110011001200062O0011005A2O0100100004F03O005A2O012O00AC001100023O00202200110011001400202O0011001100324O0011000200024O001200063O00202O0012001200134O0012000100024O00110011001200062O0011005A2O0100100004F03O005A2O012O00AC001100063O0020A20011001100132O003A0011000100022O00300011001000110026600011005A2O0100330004F03O005A2O012O00AC001100063O0020A20011001100132O003A0011000100022O0030001100100011000ED90001005A2O0100110004F03O005A2O012O0056001100014O0014011100143O000681000C00382O0100020004F03O00382O01000681000700342O0100020004F03O00342O010004F03O00AB2O010026C90006002E2O0100010004F03O002E2O0100124F0007000D3O00124F0008000E4O00030007000200090004F03O00832O0100124F000C000D4O00D8000D000B4O0003000C0002000E0004F03O00812O012O00AC001100023O00202200110011000B00202O0011001100324O0011000200024O001200063O00202O0012001200134O0012000100024O00110011001200062O001100812O0100100004F03O00812O012O00AC001100063O0020A20011001100132O003A0011000100022O0030001100100011002660001100812O0100330004F03O00812O012O00AC001100063O0020A20011001100132O003A0011000100022O0030001100100011000ED9000100812O0100110004F03O00812O012O0056001100014O0014011100143O000681000C00692O0100020004F03O00692O01000681000700652O0100020004F03O00652O0100124F0007000D3O00124F000800154O00030007000200090004F03O00A72O0100124F000C000D4O00D8000D000B4O0003000C0002000E0004F03O00A52O012O00AC001100023O00202200110011001400202O0011001100324O0011000200024O001200063O00202O0012001200134O0012000100024O00110011001200062O001100A52O0100100004F03O00A52O012O00AC001100063O0020A20011001100132O003A0011000100022O0030001100100011002660001100A52O0100330004F03O00A52O012O00AC001100063O0020A20011001100132O003A0011000100022O0030001100100011000ED9000100A52O0100110004F03O00A52O012O0056001100014O0014011100143O000681000C008D2O0100020004F03O008D2O01000681000700892O0100020004F03O00892O010012F1000600053O0004F03O002E2O012O00AC000500154O00AC00065O0020D60006000600032O00CC00060002000200069D000600B72O0100010004F03O00B72O012O00AC00065O0020D60006000600042O00CC000600020002000623010600B72O013O0004F03O00B72O012O00AC000500163O0012F13O00023O0026C93O00FC2O01001E0004F03O00FC2O012O00AC00065O0020D60006000600342O00CC00060002000200069D000600C22O0100010004F03O00C22O0100124F000600354O003A0006000100022O0014010600173O00069D000100EC2O0100010004F03O00EC2O012O00AC00065O0020D60006000600362O00CC00060002000200069D000600CF2O0100010004F03O00CF2O012O00AC000600113O00069D000600CF2O0100010004F03O00CF2O012O00AC000600183O000623010600EC2O013O0004F03O00EC2O010012F1000600014O00AD000700073O000E7C000100E32O0100060004F03O00E32O012O00AC000800183O00061F010700DB2O0100080004F03O00DB2O012O00AC000800023O0020A20008000800370020D600080008000C2O00CC0008000200022O00D8000700084O00AC000800013O0020F80008000800394O000900076O000A000C3O00122O000D003A6O0008000D000200122O000800383O00122O000600053O0026C9000600D12O0100050004F03O00D12O0100124F000800383O000623010800EC2O013O0004F03O00EC2O0100124F000800384O0021010800023O0004F03O00EC2O010004F03O00D12O012O00AC00065O00200E00060006003C00122O0008003D6O00060008000200122O0006003B6O00065O00202O00060006003E00122O0008003F6O0006000800024O000600086O00065O00202O00060006003E00122O000800406O0006000800024O0006000A3O00124O00103O0026C93O0012020100050004F03O0012020100124F0006002A3O00204B00060006002B4O000700043O00122O000800413O00122O000900426O0007000900024O0006000600074O000600033O00122O0006002A3O00202O00060006002B4O000700043O00122O000800433O00122O000900446O0007000900024O0006000600074O000600196O000100196O00028O00035O00124O00183O0026C93O0002000100290004F03O000200012O00AC00065O0020B10006000600274O000800023O00202O0008000800454O0006000800024O0006001A6O00065O00202O0006000600464O00060002000200062O000600A3020100010004F03O00A302012O00AC00065O0020D60006000600362O00CC0006000200020006230106007402013O0004F03O007402010012F1000600013O0026C900060046020100010004F03O004602010006232O01003602013O0004F03O003602010012F1000700013O0026C90007002A020100010004F03O002A02012O00AC0008001B4O003A00080001000200123F000800383O00124F000800383O0006230108003602013O0004F03O0036020100124F000800384O0021010800023O0004F03O003602010004F03O002A02010006230102004502013O0004F03O004502010012F1000700013O0026C900070039020100010004F03O003902012O00AC0008001C4O003A00080001000200123F000800383O00124F000800383O0006230108004502013O0004F03O0045020100124F000800384O0021010800023O0004F03O004502010004F03O003902010012F1000600053O0026C900060051020100180004F03O005102012O00AC0007001D4O003A00070001000200123F000700383O00124F000700383O000623010700A302013O0004F03O00A3020100124F000700384O0021010700023O0004F03O00A302010026C900060025020100050004F03O002502010006230103006202013O0004F03O006202010012F1000700013O0026C900070056020100010004F03O005602012O00AC0008001E4O003A00080001000200123F000800383O00124F000800383O0006230108006202013O0004F03O0062020100124F000800384O0021010800023O0004F03O006202010004F03O005602010006230104007102013O0004F03O007102010012F1000700013O0026C900070065020100010004F03O006502012O00AC0008001F4O003A00080001000200123F000800383O00124F000800383O0006230108007102013O0004F03O0071020100124F000800384O0021010800023O0004F03O007102010004F03O006502010012F1000600183O0004F03O002502010004F03O00A302012O00AC000600113O000623010600A302013O0004F03O00A302010012F1000600013O0026C90006008D020100010004F03O008D02010006232O01008902013O0004F03O008902010012F1000700013O0026C90007007D020100010004F03O007D02012O00AC0008001B4O003A00080001000200123F000800383O00124F000800383O0006230108008902013O0004F03O0089020100124F000800384O0021010800023O0004F03O008902010004F03O007D02012O00AC000700204O003A00070001000200123F000700383O0012F1000600053O0026C900060098020100050004F03O0098020100124F000700383O0006230107009402013O0004F03O0094020100124F000700384O0021010700024O00AC000700214O003A00070001000200123F000700383O0012F1000600183O000E7C00180078020100060004F03O0078020100124F000700383O000623010700A302013O0004F03O00A3020100124F000700384O0021010700023O0004F03O00A302010004F03O007802010004F03O00A302010004F03O000200012O004A3O00017O00093O00028O0003053O005072696E74031F3O00F7B03C04DAA9230EDDBC6F37C1B02A14C7F92D1E939C3F0ED0F90D08DCB40403043O0067B3D94F026O00F03F030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03243O006EBE0FD6489CAF43B91995719EAA4FA4089557CCF21AF94E9B11DEE368AE5CF74E83AE6103073O00C32AD77CB521EC00193O0012F13O00013O0026C93O000D000100010004F03O000D00012O00AC00016O00E90001000100014O000100013O00202O0001000100024O000200023O00122O000300033O00122O000400046O000200046O00013O000100124O00053O0026C93O0001000100050004F03O0001000100124F000100063O0020E60001000100074O000200023O00122O000300083O00122O000400096O000200046O00013O000100044O001800010004F03O000100012O004A3O00017O00", GetFEnv(), ...);
