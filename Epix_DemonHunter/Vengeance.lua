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
				if (Enum <= 155) then
					if (Enum <= 77) then
						if (Enum <= 38) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												local B;
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
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
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
											end
										elseif (Enum > 2) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
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
											do
												return Stk[A](Unpack(Stk, A + 1, Top));
											end
										end
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
									elseif (Enum <= 6) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
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
										elseif not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 11) then
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum > 12) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 15) then
									if (Enum == 14) then
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
								elseif (Enum <= 16) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 28) then
								if (Enum <= 23) then
									if (Enum <= 20) then
										if (Enum > 19) then
											local A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
										end
									elseif (Enum <= 21) then
										local B;
										local T;
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
										Stk[Inst[2]] = {};
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
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 22) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									if (Enum > 24) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 26) then
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
								elseif (Enum == 27) then
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
									Stk[Inst[2]] = #Stk[Inst[3]];
								end
							elseif (Enum <= 33) then
								if (Enum <= 30) then
									if (Enum == 29) then
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
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									else
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
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 31) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 32) then
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
							elseif (Enum <= 35) then
								if (Enum == 34) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 36) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 37) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 57) then
							if (Enum <= 47) then
								if (Enum <= 42) then
									if (Enum <= 40) then
										if (Enum == 39) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
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
									elseif (Enum > 41) then
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
								elseif (Enum <= 44) then
									if (Enum == 43) then
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
								elseif (Enum <= 45) then
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
								elseif (Enum > 46) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 52) then
								if (Enum <= 49) then
									if (Enum == 48) then
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
										if not Stk[Inst[2]] then
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
								elseif (Enum <= 50) then
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
								elseif (Enum == 51) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 54) then
								if (Enum > 53) then
									if (Inst[2] < Stk[Inst[4]]) then
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
							elseif (Enum <= 55) then
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
							elseif (Enum > 56) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 67) then
							if (Enum <= 62) then
								if (Enum <= 59) then
									if (Enum > 58) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 60) then
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
								elseif (Enum == 61) then
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
							elseif (Enum <= 64) then
								if (Enum == 63) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 66) then
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
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 72) then
							if (Enum <= 69) then
								if (Enum > 68) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
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
						elseif (Enum <= 74) then
							if (Enum > 73) then
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
							elseif (Inst[2] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 75) then
							local A;
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						elseif (Enum > 76) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 116) then
						if (Enum <= 96) then
							if (Enum <= 86) then
								if (Enum <= 81) then
									if (Enum <= 79) then
										if (Enum == 78) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 80) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 83) then
									if (Enum == 82) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									end
								elseif (Enum <= 84) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 85) then
									if (Inst[2] == Stk[Inst[4]]) then
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
							elseif (Enum <= 91) then
								if (Enum <= 88) then
									if (Enum > 87) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 89) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 90) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 93) then
								if (Enum == 92) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 94) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 95) then
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
							elseif (Inst[2] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 106) then
							if (Enum <= 101) then
								if (Enum <= 98) then
									if (Enum > 97) then
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
										do
											return Stk[Inst[2]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										do
											return;
										end
									end
								elseif (Enum <= 99) then
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
								elseif (Enum == 100) then
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
								elseif (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 103) then
								if (Enum == 102) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 105) then
								if (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 111) then
							if (Enum <= 108) then
								if (Enum > 107) then
									if (Inst[2] == Inst[4]) then
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
							elseif (Enum <= 109) then
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
							elseif (Enum == 110) then
								Stk[Inst[2]] = Inst[3] ~= 0;
							else
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 113) then
							if (Enum == 112) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 114) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 115) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 135) then
						if (Enum <= 125) then
							if (Enum <= 120) then
								if (Enum <= 118) then
									if (Enum == 117) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 119) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 122) then
								if (Enum > 121) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 123) then
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
						elseif (Enum <= 130) then
							if (Enum <= 127) then
								if (Enum == 126) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 128) then
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
							elseif (Enum == 129) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 132) then
							if (Enum > 131) then
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
						elseif (Enum == 134) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
						else
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
						end
					elseif (Enum <= 145) then
						if (Enum <= 140) then
							if (Enum <= 137) then
								if (Enum > 136) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 138) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 139) then
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
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 142) then
							if (Enum > 141) then
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 143) then
							if (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 144) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
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
					elseif (Enum <= 150) then
						if (Enum <= 147) then
							if (Enum == 146) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 148) then
							local T;
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 149) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						end
					elseif (Enum <= 152) then
						if (Enum > 151) then
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
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						end
					elseif (Enum <= 153) then
						Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
				elseif (Enum <= 233) then
					if (Enum <= 194) then
						if (Enum <= 174) then
							if (Enum <= 164) then
								if (Enum <= 159) then
									if (Enum <= 157) then
										if (Enum > 156) then
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
										end
									elseif (Enum == 158) then
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
								elseif (Enum <= 161) then
									if (Enum == 160) then
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
										Stk[Inst[2]] = Inst[3];
									else
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									end
								elseif (Enum <= 162) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum > 163) then
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
							elseif (Enum <= 169) then
								if (Enum <= 166) then
									if (Enum > 165) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									end
								elseif (Enum <= 167) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								elseif (Enum == 168) then
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 171) then
								if (Enum == 170) then
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
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 172) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 173) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 184) then
							if (Enum <= 179) then
								if (Enum <= 176) then
									if (Enum > 175) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 177) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 178) then
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
							elseif (Enum <= 181) then
								if (Enum == 180) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 182) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							elseif (Enum == 183) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							end
						elseif (Enum <= 189) then
							if (Enum <= 186) then
								if (Enum > 185) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
							elseif (Enum == 188) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 191) then
							if (Enum > 190) then
								do
									return Stk[Inst[2]];
								end
							else
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							end
						elseif (Enum <= 192) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 193) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 213) then
						if (Enum <= 203) then
							if (Enum <= 198) then
								if (Enum <= 196) then
									if (Enum == 195) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									end
								elseif (Enum == 197) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 200) then
								if (Enum > 199) then
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
							elseif (Enum <= 201) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 208) then
							if (Enum <= 205) then
								if (Enum > 204) then
									do
										return;
									end
								else
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 206) then
								if (Inst[2] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 207) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 210) then
							if (Enum > 209) then
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
						elseif (Enum <= 211) then
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
						elseif (Enum > 212) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 223) then
						if (Enum <= 218) then
							if (Enum <= 215) then
								if (Enum == 214) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 216) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 217) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 220) then
							if (Enum > 219) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 221) then
							local A = Inst[2];
							local B = Inst[3];
							for Idx = A, B do
								Stk[Idx] = Vararg[Idx - A];
							end
						elseif (Enum == 222) then
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 228) then
						if (Enum <= 225) then
							if (Enum > 224) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 226) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 227) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 230) then
						if (Enum == 229) then
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
							local B = Stk[Inst[4]];
							if not B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 231) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						if (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
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
				elseif (Enum <= 272) then
					if (Enum <= 252) then
						if (Enum <= 242) then
							if (Enum <= 237) then
								if (Enum <= 235) then
									if (Enum == 234) then
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
								elseif (Enum > 236) then
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
							elseif (Enum <= 239) then
								if (Enum > 238) then
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
							elseif (Enum <= 240) then
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
							elseif (Enum == 241) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
							end
						elseif (Enum <= 247) then
							if (Enum <= 244) then
								if (Enum == 243) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum <= 245) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 246) then
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
						elseif (Enum <= 249) then
							if (Enum > 248) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 250) then
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 251) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 262) then
						if (Enum <= 257) then
							if (Enum <= 254) then
								if (Enum == 253) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 256) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 259) then
							if (Enum == 258) then
								Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum <= 260) then
							Stk[Inst[2]] = {};
						elseif (Enum == 261) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 264) then
							if (Enum > 263) then
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
						elseif (Enum <= 265) then
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
						elseif (Enum > 266) then
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
					elseif (Enum <= 269) then
						if (Enum > 268) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 270) then
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
					elseif (Enum == 271) then
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
				elseif (Enum <= 292) then
					if (Enum <= 282) then
						if (Enum <= 277) then
							if (Enum <= 274) then
								if (Enum == 273) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 275) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							elseif (Enum > 276) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 279) then
							if (Enum > 278) then
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
						elseif (Enum <= 280) then
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
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 281) then
							if (Stk[Inst[2]] ~= Inst[4]) then
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
					elseif (Enum <= 287) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 285) then
							if (Inst[2] < Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 289) then
						if (Enum == 288) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 290) then
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
					else
						Stk[Inst[2]]();
					end
				elseif (Enum <= 302) then
					if (Enum <= 297) then
						if (Enum <= 294) then
							if (Enum == 293) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 295) then
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
						elseif (Enum == 296) then
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
								if (Mvm[1] == 168) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum == 298) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 300) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 301) then
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
				elseif (Enum <= 307) then
					if (Enum <= 304) then
						if (Enum > 303) then
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Inst[2] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 305) then
						local A;
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
					elseif (Enum == 306) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 309) then
					if (Enum > 308) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 310) then
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
				elseif (Enum > 311) then
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
				else
					local A = Inst[2];
					Stk[A](Stk[A + 1]);
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031E3O00F4D3D23DD99FC213DECDF330E8AFC20CEEF5DE2BE1BEC610D2C69529F3BA03083O007EB1A3BB4586DBA7031E3O00D55F539FCF6B5F8AFF417292FE5B5F95CF795F89F74A5B89F34A148BE54E03043O00E7902F3A002E3O00127B3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001002O043O000A00010012C8000300063O0020440004000300070012C8000500083O0020440005000500090012C8000600083O00204400060006000A00062801073O000100062O00A83O00064O00A88O00A83O00044O00A83O00014O00A83O00024O00A83O00053O00204400080003000B00204400090003000C2O0004010A5O0012C8000B000D3O000628010C0001000100022O00A83O000A4O00A83O000B4O00A8000D00073O00122A000E000E3O00122A000F000F4O0084000D000F0002000628010E0002000100032O00A83O00074O00A83O00094O00A83O00084O00E5000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00F600025O00122O000300016O00045O00122O000500013O00042O0003002100012O002D01076O00EA000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004090003000500012O002D010300054O00A8000400024O0096000300044O008B00036O00CD3O00017O00123O00028O00025O00649B40025O007C9040025O00805440025O00E88940026O00F03F025O002EAE40025O008C9740025O00D0A640026O00AE40025O00D09D40025O00B0A040025O00E07F40025O00A07A40025O0098A940025O0010AC40025O00F8AF40025O0068AA4001443O00122A000200014O00CC000300043O002E8E0003000B00010002002O043O000B00010026190102000800010001002O043O00080001002E500005000B00010004002O043O000B000100122A000300014O00CC000400043O00122A000200063O002E8E0008000200010007002O043O0002000100268F0002000200010006002O043O0002000100122A000500014O00CC000600063O00268F0005001100010001002O043O0011000100122A000600013O002E8E000900140001000A002O043O0014000100268F0006001400010001002O043O00140001002E6C000B001E0001000B002O043O00360001000E560001003600010003002O043O0036000100122A000700013O002E8E000D00250001000C002O043O002500010026190107002300010006002O043O00230001002E8E000F00250001000E002O043O0025000100122A000300063O002O043O00360001000E2F2O01002900010007002O043O00290001002E6C001000F6FF2O0011002O043O001D00012O002D01086O00A2000400083O002E6C0012000900010012002O043O0034000100060A0004003400010001002O043O003400012O002D010800014O00A800096O009E000A6O000200086O008B00085O00122A000700063O002O043O001D000100268F0003000F00010006002O043O000F00012O00A8000700044O009E00086O000200076O008B00075O002O043O000F0001002O043O00140001002O043O000F0001002O043O00110001002O043O000F0001002O043O00430001002O043O000200012O00CD3O00017O00503O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003043O009FC2C41E03063O004BDCA3B76A62030D3O0021BB9823EA17BD8C32CA16BF8F03053O00B962DAEB57030D3O00E83D34F2FFA4C52O33E7CAAFCF03063O00CAAB5C4786BE03053O0019D3299B3A03043O00E849A14C03053O0096D8414F1103053O007EDBB9223D03073O002FC1537F7179E003083O00876CAE3E121E179303083O0093FF2FD901A13DC203083O00A7D6894AAB78CE5303053O00BEE43B51EB03063O00C7EB90523D98030F3O002A13AB2C0222B8290B139B322C13A003043O004B6776D92O033O00C9417D03063O007EA7341074D903043O00CA212F8C03073O009CA84E40E0D47903073O0047657454696D6503043O006D6174682O033O000AEFBD03043O00AE678EC503043O00552D563403073O009836483F58453E2O033O00D9CDE003043O003CB4A48E026O001440030B3O007C5B082629C507564A003B03073O0072383E6549478D03093O008EECD5C3BDE8D5C7BD03043O00A4D889BB030B3O00F6E33CBDA8D61EDCF234A003073O006BB28651D2C69E03093O000E0B8CC1AF390081C303053O00CA586EE2A6030B3O00E70A8FF8C4EB1A8CE3CFD103053O00AAA36FE29703093O002735BC3F4B3627123503073O00497150D2582E57028O00024O0080B3C540024O0068AE0441024O0088AE0441024O00209F0441024O0090AE0441024O00A8AE0441024O00A0AE0441024O00B0AE044103103O005265676973746572466F724576656E7403143O00B100EC2BC2B313FF37C0A402F237C9A00EE137C303053O0087E14CAD7203063O0053657441504C025O002882400007023O0012000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O0012FD000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O0012FD0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O0012FD000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122A000D00123O00122A000E00134O0084000C000E00022O00A2000C0004000C2O0079000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100176O000F001100022O0063000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B6O0011001300022O00630011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F6O0013001500022O00A20013000E00132O002D01145O00122A001500203O00122A001600214O00840014001600022O00A20014000E00142O002D01155O001213001600223O00122O001700236O0015001700024O0015000E00154O00165O00122O001700243O00122O001800256O0016001800024O0015001500164O00165O00122O001700263O00122O001800276O0016001800024O0016000400164O00175O00122O001800283O00122O001900296O0017001900024O0016001600174O00175O00122O0018002A3O00122O0019002B6O0017001900024O0017001500174O00185O00122O0019002C3O00122O001A002D6O0018001A00024O00180015001800122O0019002E3O00122O001A002F6O001B5O00122O001C00303O00122O001D00316O001B001D00024O001A001A001B00122O001B002F6O001C5O00122O001D00323O00122O001E00336O001C001E00024O001B001B001C00122O001C002F6O001D5O00122O001E00343O00122O001F00356O001D001F00024O001C001C001D00122O001D00366O001E001E6O001F8O00208O00218O002200536O00545O00122O005500373O00122O005600386O0054005600024O0054000C00544O00555O00122O005600393O00122O0057003A6O0055005700024O0054005400554O00555O00122O0056003B3O00122O0057003C6O0055005700024O0055000D00554O00565O00122O0057003D3O00122O0058003E6O0056005800024O0055005500564O00565O00122O0057003F3O00122O005800406O0056005800024O0056001400564O00575O00122A005800413O001215005900426O0057005900024O0056005600574O00578O005800593O00122O005A00436O005B00606O006100013O00122O006200443O00122O006300446O006400073O00122O006500453O00122O006600463O00122O006700473O00122O006800483O00122O006900493O00122O006A004A3O00122O006B004B6O00640007000100209D00650004004C00062801673O000100022O00A83O00624O00A83O00634O003100685O00122O0069004D3O00122O006A004E6O0068006A6O00653O0001000628016500010001000C2O00A83O00584O00A83O00084O00A83O00544O002D017O00A83O005A4O00A83O00594O00A83O001C4O002D012O00014O002D012O00024O00A83O001A4O00A83O00604O00A83O00163O00062801660002000100072O00A83O005C4O00A83O005B4O00A83O00604O00A83O00544O002D017O00A83O00084O00A83O00093O00062801670003000100012O00A83O00543O00062801680004000100012O00A83O00543O00062801690005000100042O00A83O001E4O00A83O00154O00A83O00574O00A83O00213O000628016A00060001000E2O00A83O00544O002D017O00A83O00284O00A83O005B4O00A83O00134O00A83O00274O00A83O00564O00A83O00094O00A83O001D4O00A83O00254O00A83O00294O00A83O00084O00A83O00514O00A83O00263O000628016B0007000100142O00A83O004C4O00A83O00084O00A83O004E4O00A83O00504O002D017O00A83O00554O00A83O00134O00A83O00564O00A83O00544O00A83O003C4O00A83O00604O00A83O005D4O00A83O003F4O00A83O003E4O00A83O00414O00A83O00094O00A83O003D4O00A83O00404O00A83O004D4O00A83O004F3O000628016C00080001000C2O00A83O00544O002D017O00A83O002F4O00A83O00084O00A83O00514O00A83O00134O00A83O00564O00A83O00094O00A83O001D4O00A83O002C4O00A83O00304O00A83O00313O000628016D00090001001B2O00A83O00544O002D017O00A83O00494O00A83O00634O00A83O00334O00A83O00214O00A83O00374O00A83O00134O00A83O00094O00A83O001D4O00A83O00354O00A83O00394O00A83O00324O00A83O00084O00A83O00364O00A83O00604O00A83O003B4O00A83O003A4O00A83O00564O00A83O00254O00A83O005B4O00A83O00284O00A83O00584O00A83O002A4O00A83O006C4O00A83O00344O00A83O002B3O000628016E000A000100202O00A83O00544O002D017O00A83O00604O00A83O00584O00A83O002B4O00A83O00134O00A83O00094O00A83O001D4O00A83O00334O00A83O00214O00A83O00374O00A83O00494O00A83O00634O00A83O00344O00A83O00324O00A83O00084O00A83O00364O00A83O003B4O00A83O003A4O00A83O00564O00A83O00614O00A83O002A4O00A83O005B4O00A83O00244O002D012O00014O002D012O00024O00A83O00264O00A83O00294O00A83O005C4O00A83O00514O00A83O00354O00A83O00393O000628016F000B000100162O00A83O00544O002D017O00A83O00254O002D012O00014O00A83O00084O002D012O00024O00A83O00134O00A83O005B4O00A83O00284O00A83O00224O00A83O00244O00A83O00584O00A83O002B4O00A83O00094O00A83O001D4O00A83O00264O00A83O003D4O00A83O00514O00A83O00564O00A83O00604O00A83O00614O00A83O002A3O0006280170000C0001001A2O00A83O00544O002D017O00A83O00354O00A83O00214O00A83O00394O00A83O00494O00A83O00634O00A83O00134O00A83O00094O00A83O00344O00A83O005B4O00A83O00334O00A83O00374O00A83O001D4O00A83O00614O00A83O002A4O00A83O00254O00A83O00284O00A83O006C4O00A83O00324O00A83O00084O00A83O00364O00A83O00604O00A83O003B4O00A83O003A4O00A83O00563O0006280171000D0001001B2O00A83O00544O002D017O00A83O00284O00A83O00134O00A83O005B4O00A83O00584O00A83O002A4O00A83O006C4O00A83O00344O00A83O002B4O00A83O00094O00A83O001D4O00A83O00254O00A83O00354O00A83O00214O00A83O00394O00A83O00494O00A83O00634O00A83O00334O00A83O00374O00A83O00324O00A83O00084O00A83O00364O00A83O00604O00A83O003B4O00A83O003A4O00A83O00563O0006280172000E000100242O00A83O00284O002D017O00A83O00294O00A83O00264O00A83O00274O00A83O002A4O00A83O002B4O00A83O002C4O00A83O002D4O00A83O003B4O00A83O00524O00A83O00534O00A83O00324O00A83O00334O00A83O00344O00A83O00354O00A83O00404O00A83O00414O00A83O00514O00A83O003A4O00A83O003C4O00A83O003D4O00A83O003E4O00A83O003F4O00A83O00224O00A83O00234O00A83O00244O00A83O00254O00A83O00304O00A83O00314O00A83O002E4O00A83O002F4O00A83O00364O00A83O00374O00A83O00384O00A83O00393O0006280173000F0001000E2O00A83O004C4O002D017O00A83O004B4O00A83O004D4O00A83O00454O00A83O00494O00A83O00424O00A83O00464O00A83O00504O00A83O004F4O00A83O004E4O00A83O004A4O00A83O00474O00A83O00483O00062801740010000100302O00A83O005E4O00A83O00084O00A83O00094O00A83O00154O00A83O00624O00A83O00044O00A83O00634O00A83O005F4O00A83O00454O00A83O001E4O00A83O00544O00A83O00564O002D017O00A83O00234O00A83O00424O00A83O00134O00A83O006B4O00A83O00274O00A83O001D4O00A83O00494O00A83O003E4O00A83O00534O00A83O005B4O00A83O006F4O00A83O00604O00A83O00704O00A83O00714O00A83O00614O002D012O00014O002D012O00024O00A83O002C4O00A83O00064O00A83O00644O00A83O000A4O00A83O001F4O00A83O006A4O00A83O004A4O00A83O00214O00A83O004B4O00A83O00694O00A83O006E4O00A83O006D4O00A83O00664O00A83O005D4O00A83O00204O00A83O00654O00A83O00724O00A83O00733O00062801750011000100032O00A83O000E4O002D017O00A83O00543O0020000176000E004F00122O007700506O007800746O007900756O0076007900016O00013O00123O00063O00028O00025O0092A240025O0050A340025O0098A540025O0018A740024O0080B3C54000143O00122A3O00014O00CC000100013O002E500002000200010003002O043O0002000100268F3O000200010001002O043O0002000100122A000100013O0026192O01000B00010001002O043O000B0001002E500005000700010004002O043O0007000100122A000200064O000E00025O00122A000200064O000E000200013O002O043O00130001002O043O00070001002O043O00130001002O043O000200012O00CD3O00017O0012012O00028O00025O00E9B240025O00F5B140025O00F0A840025O00EAAA40026O00F03F025O00A7B240025O0012AB4003093O0042752O66537461636B030D3O00536F756C467261676D656E7473030A3O0029FDB1A2A5A98515E0BA03073O00C77A8DD8D0CCDD03113O0054696D6553696E63654C617374436173742O033O00474344025O00FEAC40025O00B07F40025O00F4AE40025O00E2A740025O006AA040025O0098A940025O0045B240025O00C0A140025O004C9140025O0012AF40025O0050B240025O00788C40025O00488040025O00B8AD40025O0080AA4003063O0042752O66557003113O004D6574616D6F7270686F73697342752O66030A3O009ED205FC5BF7BFCB15E203063O0096CDBD709018030B3O004973417661696C61626C65030A3O00168BAA4027890306209603083O007045E4DF2C64E871030A3O00E71012DF957D94C21A1503073O00E6B47F67B3D61C030C3O00A0044C52C740F39831564BE103073O0080EC653F268421025O00308840025O00707C40026O008A40025O0056A240025O00388D40025O00406440025O00E07940025O007C9240025O00389E40025O00B2A540027O0040026O001440030A3O009FA6044895EADDBAAC2O03073O00AFCCC97124D68B030C3O006BCD26C82746DF21E80D4AC903053O006427AC55BC03083O008B6AB88327B86ABC03053O0053CD18D9E003083O00C0D7CC3EF2D0DF3803043O005D86A5AD03083O0098E0C0C12EDBA07B03083O001EDE92A1A25AAED2030C3O00C94F631EC64F631ED1477D0F03043O006A852E10025O0002B040025O00F08740025O0080AE40025O00805840025O00E08240025O003DB240025O009FB040025O00288140025O0050A040025O00B6A240025O00807D40025O0020804003083O007E3272FF4E554A2503063O00203840139C3A030C3O0076C9F64279F3934EFCEC5B5F03073O00E03AA885363A92025O00A8B040025O00B88E4003053O006A5E4EFC6703083O006B39362B9D15E6E703083O00FD9910F6ADC9DDDE03073O00AFBBEB7195D9BC03053O000FA7844DF103073O00185CCFE12C8319025O00207840025O009FB140025O00209F40025O0074A44003053O0078DBBD4D0903063O001D2BB3D82C7B030C3O0091D833589ED8335889D02D4903043O002CDDB940025O00BBB240025O00F2A740030A3O0032E85D534008E041536003053O00136187283F025O00ECA940025O00207A40025O0014B340025O00C49B40025O00C6AF40025O00D2A340025O006AA740025O0008A840025O00189240025O009DB240025O0049B040025O00B8AF40025O00608A40025O00406F40025O00805540025O00F08240025O00206340025O002AA340025O0095B240025O0008AC40030C3O009D553432231EA87A3F3A223403063O0051CE3C535B4F030C3O004C6173744361737454696D65030E3O007DA2D77B23EC4B9747A7D57C2CC603083O00C42ECBB0124FA32D030D3O008B2B791728D4E99B2A7F172AE803073O008FD8421E7E449B030D3O008FC414D8CCA2D9C5AFCB1FCEC003083O0081CAA86DABA5C3B7030C3O00115130D1D23BE0045436D5DB03073O0086423857B8BE74030E3O000F380EB215C42706353D0CB51AEE03083O00555C5169DB798B41030D3O00CEBA574C70F0FB90584475D1EE03063O00BF9DD330251C030D3O00FA13ED0F33DE11D01939CD1AF103053O005ABF7F947C025O00E8A440025O0083B040025O00A06840025O006CB140025O00B07D40025O00C06C40030D3O005D8B3704718620337D843C127D03043O007718E74E030D3O00A721BC59D5411FA628A658D94503073O0071E24DC52ABC20030C3O001617E7A11917E7A10E1FF9B003043O00D55A7694025O00B07140025O000EA640025O0092B040025O00E07640025O0068B240025O00405140025O00206140025O00F0A140025O000EAA40025O0060A740025O00A08040025O00809540026O000840025O00289740025O00D09640025O00889A40025O004AA540025O00C0AF40025O00606540025O0053B24003073O007D2FB85A424E3A03053O002D3B4ED436030E3O00395B8E848A2FB9F91F58A29E942F03083O00907036E3EBE64ECD030E3O009A2502F3DC5AA72100F2F14EA12903063O003BD3486F9CB0030C3O006286F0396D86F0397A8EEE2803043O004D2EE783025O00BCA140025O0054A840025O00709840025O00CEA940025O00FAA040025O00E8B240030E3O009359BB4FB655A249B55A9755A85503043O0020DA34D6030C3O00621622BCD2B1564E7A1E3CAD03083O003A2E7751C891D025025O0058AE40025O00089540026O33E33F025O0040AA40030E3O0009993CA78CA522398D33B8A0B23803073O00564BEC50CCC9DD030E3O0050547B8EDB9366537686EA827D4F03063O00EB122117E59E030E3O0072AFCDB075A2D5A951B9D5B25FB403043O00DB30DAA1030C3O00C8706F5DF84EF3F0457544DE03073O008084111C29BB2F025O00E8A040025O0094A840025O00708540025O0066A140025O00E88240025O007CA640025O00A06140025O00E89040026O00A640030E3O0023270A31781926143B5E153B093403053O003D6152665A030C3O00802FB85FE4560D1D9827A64E03083O0069CC4ECB2BA7377E025O00ECAD40025O00E8B040025O00A07D40025O00A49040025O002C9140025O0092B240025O0007B340025O001CB340025O002BB040025O00CAA840025O00B2A240025O0080994003053O00706169727303023O004944025O0028B140025O00DCA240025O00C09840025O00A88F40025O00408040025O00DAA140025O0032A040030A3O00C77EE0A1162480FD7DE603073O00E7941195CD454D025O009CA640025O00DEA540030D3O00536967696C4F66436861696E73030D3O00456C797369616E446563722O65025O00B4AB40025O008EA540025O0060AF40025O00D2AB40030C3O00536967696C4F66466C616D65030E3O00536967696C4F6653696C656E6365025O00049D40025O0044A94003073O002OA6CBF758EA9403063O009FE0C7A79B37025O00EC9340025O002AAC40030E3O00492O6D6F6C6174696F6E41757261025O00C8AF40025O00709240026O006E40025O00989240025O00A2A34003073O0050726576474344030A3O0096A536123005D547A0B803083O0031C5CA437E7364A703083O001149DE2A94434C3203073O003E573BBF49E03603053O00D40AFFC8F503043O00A987629A030E3O00E962285FD82BDCD9762740F43CC603073O00A8AB1744349D53025O0006AA40026O009440025O00D88340025O00A2A140025O00188240025O00A49E40025O00B08040025O00D2A240005D042O00122A3O00014O00CC000100013O002E8E0003000200010002002O043O0002000100268F3O000200010001002O043O0002000100122A000100013O00268F0001002E00010001002O043O002E000100122A000200013O002E8E0004001000010005002O043O0010000100268F0002001000010006002O043O0010000100122A000100063O002O043O002E0001002E500008000A00010007002O043O000A000100268F0002000A00010001002O043O000A00012O002D010300013O0020E90003000300094O000500023O00202O00050005000A4O0003000500024O00038O000300026O000400033O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O0003000200024O000400013O00202O00040004000E4O00040002000200062O0004000600010003002O043O002C0001002E50000F002A00010010002O043O002A0001002O043O002C000100122A000300014O000E000300043O00122A000200063O002O043O000A0001002E6C001100D9FF2O0011002O043O00070001000E560006000700010001002O043O000700012O002D010200043O0026190102003700010001002O043O00370001002E8E0012006003010013002O043O0060030100122A000200014O00CC000300043O000E560001004C00010002002O043O004C000100122A000500013O002E8E0014004300010015002O043O0043000100268F0005004300010001002O043O0043000100122A000300014O00CC000400043O00122A000500063O002E8E0017003C00010016002O043O003C00010026190105004900010006002O043O00490001002E8E0019003C00010018002O043O003C000100122A000200063O002O043O004C0001002O043O003C0001002E8E001B00390001001A002O043O0039000100268F0002003900010006002O043O00390001002E50001D00500001001C002O043O00500001000E560001005000010003002O043O005000012O002D010500013O00205800050005001E4O000700023O00202O00070007001F4O00050007000200062O0005005E00013O002O043O005E000100122A000500063O0006E60004005F00010005002O043O005F000100122A000400014O002D010500024O004F000600033O00122O000700203O00122O000800216O0006000800024O00050005000600202O0005000500224O00050002000200062O0005008400013O002O043O008400012O002D010500024O005C000600033O00122O000700233O00122O000800246O0006000800024O00050005000600202O00050005000D4O0005000200024O000600013O00202O00060006000E4O00060002000200062O0005008400010006002O043O008400012O002D010500024O002O010600033O00122O000700253O00122O000800266O0006000800024O0005000500064O000600033O00122O000700273O00122O000800286O0006000800024O0005000500064O000600053O00062O0005008600010006002O043O00860001002E50002900B30001002A002O043O00B3000100122A000500014O00CC000600063O000E2F2O01008E00010005002O043O008E0001002E60002B008E0001002C002O043O008E0001002E8E002D00880001002E002O043O0088000100122A000600013O002E50002F008F00010030002O043O008F00010026190106009500010001002O043O00950001002E6C003100FCFF2O0032002O043O008F00012O002D010700064O00A0000800076O00095O00122O000A00336O0008000A00024O000900086O000A5O00122O000B00336O0009000B00024O00080008000900122O000900344O00840007000900022O000E000700044O002D010700024O00FF000800033O00122O000900353O00122O000A00366O0008000A00024O0007000700084O000800033O00122O000900373O00122O000A00386O0008000A00024O0007000700084O000700053O00044O003E0401002O043O008F0001002O043O003E0401002O043O00880001002O043O003E04012O002D010500024O004F000600033O00122O000700393O00122O0008003A6O0006000800024O00050005000600202O0005000500224O00050002000200062O000500142O013O002O043O00142O012O002D010500024O005C000600033O00122O0007003B3O00122O0008003C6O0006000800024O00050005000600202O00050005000D4O0005000200024O000600013O00202O00060006000E4O00060002000200062O000500142O010006002O043O00142O012O002D010500024O00B9000600033O00122O0007003D3O00122O0008003E6O0006000800024O0005000500064O000600033O00122O0007003F3O00122O000800406O0006000800024O0005000500064O000600053O00062O000500142O010006002O043O00142O0100122A000500014O00CC000600073O002E50004200E100010041002O043O00E1000100268F000500E100010001002O043O00E1000100122A000600014O00CC000700073O00122A000500063O002619010500E500010006002O043O00E50001002E8E004300DA00010044002O043O00DA0001000E2F2O0100EB00010006002O043O00EB0001002E60004500EB00010046002O043O00EB0001002E8E004700E500010048002O043O00E5000100122A000700013O002619010700F200010001002O043O00F20001002ECE004A00F200010049002O043O00F20001002E50004C00EC0001004B002O043O00EC00012O002D010800064O00C6000900076O000A5O00202O000A000A00334O000B00046O0009000B00024O000A00086O000B5O00202O000B000B00334O000C00046O000A000C00024O00090009000A00122O000A00346O0008000A00024O000800046O000800026O000900033O00122O000A004D3O00122O000B004E6O0009000B00024O0008000800094O000900033O00122O000A004F3O00122O000B00506O0009000B00024O0008000800094O000800053O00044O003E0401002O043O00EC0001002O043O003E0401002O043O00E50001002O043O003E0401002O043O00DA0001002O043O003E0401002E500052005C2O010051002O043O005C2O012O002D010500024O005C000600033O00122O000700533O00122O000800546O0006000800024O00050005000600202O00050005000D4O0005000200024O000600013O00202O00060006000E4O00060002000200062O0005005C2O010006002O043O005C2O012O002D010500024O00B9000600033O00122O000700553O00122O000800566O0006000800024O0005000500064O000600033O00122O000700573O00122O000800586O0006000800024O0005000500064O000600053O00062O0005005C2O010006002O043O005C2O0100122A000500014O00CC000600063O00268F000500332O010001002O043O00332O0100122A000600013O002E50005900362O01005A002O043O00362O01002E8E005B00362O01005C002O043O00362O0100268F000600362O010001002O043O00362O012O002D010700064O00C6000800076O00095O00202O0009000900064O000A00046O0008000A00024O000900086O000A5O00202O000A000A00064O000B00046O0009000B00024O00080008000900122O000900346O0007000900024O000700046O000700026O000800033O00122O0009005D3O00122O000A005E6O0008000A00024O0007000700084O000800033O00122O0009005F3O00122O000A00606O0008000A00024O0007000700084O000700053O00044O003E0401002O043O00362O01002O043O003E0401002O043O00332O01002O043O003E0401002E500062007602010061002O043O007602012O002D010500024O004F000600033O00122O000700633O00122O000800646O0006000800024O00050005000600202O0005000500224O00050002000200062O0005007602013O002O043O0076020100122A000500014O00CC000600083O000E2F2O0100702O010005002O043O00702O01002E60006500702O010066002O043O00702O01002E6C0067001300010068002O043O00812O0100122A000900013O002619010900772O010006002O043O00772O01002E49006900772O01006A002O043O00772O01002E6C006B00040001006C002O043O00792O0100122A000500063O002O043O00812O010026190109007D2O010001002O043O007D2O01002E8E006E00712O01006D002O043O00712O0100122A000600014O00CC000700073O00122A000900063O002O043O00712O01002619010500872O010006002O043O00872O01002E49006F00872O010070002O043O00872O01002E6C007100E5FF2O0072002O043O006A2O012O00CC000800083O0026190106008C2O010001002O043O008C2O01002E8E007400DF2O010073002O043O00DF2O0100122A000900013O002619010900932O010001002O043O00932O01002E49007600932O010075002O043O00932O01002E50007700D62O010078002O043O00D62O012O002D010A00094O0038010B00026O000C00033O00122O000D00793O00122O000E007A6O000C000E00024O000B000B000C00202O000B000B007B4O000C00026O000D00033O00122O000E007C3O00122A000F007D4O004B000D000F00024O000C000C000D00202O000C000C007B4O000D00026O000E00033O00122O000F007E3O00122O0010007F6O000E001000024O000D000D000E00202O000D000D007B2O002D010E00024O00E0000F00033O00122O001000803O00122O001100816O000F001100024O000E000E000F00202O000E000E007B4O000A000E00024O0007000A6O000A00066O000B00024O002D010C00033O001245000D00823O00122O000E00836O000C000E00024O000B000B000C00202O000B000B000D4O000B000200024O000C00026O000D00033O00122O000E00843O00122O000F00854O0084000D000F00022O006D000C000C000D00202O000C000C000D4O000C000200024O000D00026O000E00033O00122O000F00863O00122O001000876O000E001000024O000D000D000E00202O000D000D000D2O00AB000D000200022O0086000E00026O000F00033O00122O001000883O00122O001100896O000F001100024O000E000E000F00202O000E000E000D4O000E000F6O000A3O00024O0008000A3O00122A000900063O002619010900DC2O010006002O043O00DC2O01002E49008B00DC2O01008A002O043O00DC2O01002E50008D008D2O01008C002O043O008D2O0100122A000600063O002O043O00DF2O01002O043O008D2O01002619010600E32O010006002O043O00E32O01002E50008E00882O01008F002O043O00882O012O002D010900024O004F000A00033O00122O000B00903O00122O000C00916O000A000C00024O00090009000A00202O0009000900224O00090002000200062O0009002O02013O002O043O002O02012O002D010900024O0025010A00033O00122O000B00923O00122O000C00936O000A000C00024O00090009000A4O000A00033O00122O000B00943O00122O000C00956O000A000C00024O00090009000A00068D0007002O02010009002O043O002O02012O002D010900013O00209D00090009000E2O00AB00090002000200062F0008002O02010009002O043O002O02012O002D010900053O00068D0007000402010009002O043O00040201002E8E0097004A02010096002O043O004A020100122A000900014O00CC000A000C3O002E500099004302010098002O043O0043020100268F0009004302010006002O043O004302012O00CC000C000C3O002E6C009A002F0001009A002O043O003A020100268F000A003A02010006002O043O003A0201002E8E009B00150201009C002O043O00150201000E56000600150201000B002O043O001502012O000E000700053O002O043O003E0401002E6C009D00FAFF2O009D002O043O000F0201002E8E009F000F0201009E002O043O000F020100268F000B000F02010001002O043O000F020100122A000D00013O002619010D002002010001002O043O00200201002E8E00A10033020100A0002O043O003302012O002D010E00064O0016010F000A3O00122O001000A26O000E001000024O000C000E6O000E00066O000F00076O00108O0011000C6O000F001100024O001000086O00118O0012000C6O0010001200024O000F000F001000122O001000346O000E001000024O000E00043O00122O000D00063O00268F000D001C02010006002O043O001C020100122A000B00063O002O043O000F0201002O043O001C0201002O043O000F0201002O043O003E0401002E8E00A4000B020100A3002O043O000B020100268F000A000B02010001002O043O000B020100122A000B00014O00CC000C000C3O00122A000A00063O002O043O000B0201002O043O003E040100268F0009000602010001002O043O0006020100122A000A00014O00CC000B000B3O00122A000900063O002O043O00060201002O043O003E04012O002D010900013O00209D00090009000E2O00AB00090002000200062F0008003E04010009002O043O003E04012O002D010900053O0006620007003E04010009002O043O003E040100122A000900014O00CC000A000A3O002E5000A50054020100A6002O043O0054020100268F0009005402010001002O043O0054020100122A000A00013O002E6C00A73O000100A7002O043O00590201002619010A005F02010001002O043O005F0201002E8E00A90059020100A8002O043O005902012O002D010B00064O000B000C00076O000D5O00122O000E00066O000C000E00024O000D00086O000E5O00122O000F00066O000D000F00024O000C000C000D00122O000D00346O000B000D00024O000B00046O000700053O00044O003E0401002O043O00590201002O043O003E0401002O043O00540201002O043O003E0401002O043O00882O01002O043O003E0401002O043O006A2O01002O043O003E04012O002D010500024O004F000600033O00122O000700AA3O00122O000800AB6O0006000800024O00050005000600202O0005000500224O00050002000200062O000500DC02013O002O043O00DC02012O002D010500024O005C000600033O00122O000700AC3O00122O000800AD6O0006000800024O00050005000600202O00050005000D4O0005000200024O000600013O00202O00060006000E4O00060002000200062O000500DC02010006002O043O00DC02012O002D010500024O00B9000600033O00122O000700AE3O00122O000800AF6O0006000800024O0005000500064O000600033O00122O000700B03O00122O000800B16O0006000800024O0005000500064O000600053O00062O000500DC02010006002O043O00DC020100122A000500014O00CC000600073O002619010500A102010001002O043O00A10201002E6C00B20005000100B3002O043O00A4020100122A000600014O00CC000700073O00122A000500063O002619010500A802010006002O043O00A80201002E5000B5009D020100B4002O043O009D0201002619010600AC02010006002O043O00AC0201002E5000B700B9020100B6002O043O00B902012O002D010800024O00FF000900033O00122O000A00B83O00122O000B00B96O0009000B00024O0008000800094O000900033O00122O000A00BA3O00122O000B00BB6O0009000B00024O0008000800094O000800053O00044O003E040100268F000600A802010001002O043O00A8020100122A000800013O00268F000800C002010006002O043O00C0020100122A000600063O002O043O00A80201002619010800C402010001002O043O00C40201002E5000BC00BC020100BD002O043O00BC02012O002D010900064O0001000A000A3O00122O000B00346O0009000B000200102O000700BE00094O000900066O000A00076O000B8O000C00076O000A000C00024O000B00084O002D010C6O0031010D00076O000B000D00024O000A000A000B00122O000B00346O0009000B00024O000900043O00122O000800063O00044O00BC0201002O043O00A80201002O043O003E0401002O043O009D0201002O043O003E0401002E6C00BF0027000100BF002O043O002O03012O002D010500024O004F000600033O00122O000700C03O00122O000800C16O0006000800024O00050005000600202O0005000500224O00050002000200062O0005002O03013O002O043O002O03012O002D010500024O005C000600033O00122O000700C23O00122O000800C36O0006000800024O00050005000600202O00050005000D4O0005000200024O000600013O00202O00060006000E4O00060002000200062O0005002O03010006002O043O002O03012O002D010500024O002O010600033O00122O000700C43O00122O000800C56O0006000800024O0005000500064O000600033O00122O000700C63O00122O000800C76O0006000800024O0005000500064O000600053O00062O0005000503010006002O043O00050301002E5000C9003E040100C8002O043O003E040100122A000500014O00CC000600073O00268F0005004503010006002O043O00450301002E5000CA0032030100CB002O043O0032030100268F0006003203010001002O043O0032030100122A000800014O00CC000900093O002E6C00CC3O000100CC002O043O000F030100268F0008000F03010001002O043O000F030100122A000900013O0026190109001803010006002O043O00180301002E5000CD001A030100CE002O043O001A030100122A000600063O002O043O0032030100268F0009001403010001002O043O001403012O002D010A00064O0016010B000A3O00122O000C00346O000A000C00024O0007000A6O000A00066O000B00076O000C8O000D00076O000B000D00024O000C00086O000D8O000E00076O000C000E00024O000B000B000C00122O000C00346O000A000C00024O000A00043O00122O000900063O002O043O00140301002O043O00320301002O043O000F0301002E8E00CF0009030100D0002O043O0009030100268F0006000903010006002O043O000903012O002D010800024O00FF000900033O00122O000A00D13O00122O000B00D26O0009000B00024O0008000800094O000900033O00122O000A00D33O00122O000B00D46O0009000B00024O0008000800094O000800053O00044O003E0401002O043O00090301002O043O003E04010026190105004903010001002O043O00490301002E8E00D60007030100D5002O043O0007030100122A000800013O002E5000D70053030100D8002O043O005303010026190108005003010001002O043O00500301002E8E00DA0053030100D9002O043O0053030100122A000600014O00CC000700073O00122A000800063O002E8E00DB004A030100DC002O043O004A030100268F0008004A03010006002O043O004A030100122A000500063O002O043O00070301002O043O004A0301002O043O00070301002O043O003E0401002O043O00500001002O043O003E0401002O043O00390001002O043O003E040100122A000200014O00CC000300053O002E5000DE002F040100DD002O043O002F040100268F0002002F04010006002O043O002F04012O00CC000500053O000E2F0133006B03010003002O043O006B0301002E8E00DF0080030100E0002O043O008003010012C8000600E14O00A8000700054O004C000600020008002O043O007D030100209D000B000A00E22O00AB000B0002000200068D0004007D0301000B002O043O007D030100209D000B000A000D2O0054000B000200024O000C00013O00202O000C000C000E4O000C0002000200062O000C007D0301000B002O043O007D030100122A000B00014O000E000B00043O002O043O003E04010006B20006006F03010002002O043O006F0301002O043O003E0401002E6C00E30070000100E3002O043O00F00301002E6C00E4006E000100E4002O043O00F00301000E56000600F003010003002O043O00F0030100122A000600014O00CC000700073O002E6C00E53O000100E5002O043O0088030100268F0006008803010001002O043O0088030100122A000700013O002E6C00E60006000100E6002O043O0093030100268F0007009303010006002O043O0093030100122A000300333O002O043O00F0030100268F0007008D03010001002O043O008D0301002E6C00E70044000100E7002O043O00D90301002E5000E900D9030100E8002O043O00D903012O002D010800024O004F000900033O00122O000A00EA3O00122O000B00EB6O0009000B00024O00080008000900202O0008000800224O00080002000200062O000800D903013O002O043O00D9030100122A000800014O00CC000900093O002619010800A903010001002O043O00A90301002E5000EC00A5030100ED002O043O00A5030100122A000900013O00268F000900B703010006002O043O00B703012O002D010A000B4O001E000B00056O000C00023O00202O000C000C00EE4O000A000C00014O000A000B6O000B00056O000C00023O00202O000C000C00EF4O000A000C000100044O00D9030100268F000900AA03010001002O043O00AA030100122A000A00014O00CC000B000B3O002619010A00BF03010001002O043O00BF0301002E8E00F000BB030100F1002O043O00BB030100122A000B00013O002E5000F300CF030100F2002O043O00CF0301000E56000100CF0301000B002O043O00CF03012O002D010C000B4O001D000D00056O000E00023O00202O000E000E00F44O000C000E00014O000C000B6O000D00056O000E00023O00202O000E000E00F54O000C000E000100122O000B00063O00268F000B00C003010006002O043O00C0030100122A000900063O002O043O00AA0301002O043O00C00301002O043O00AA0301002O043O00BB0301002O043O00AA0301002O043O00D90301002O043O00A50301002E5000F600EC030100F7002O043O00EC03012O002D010800024O001E010900033O00122O000A00F83O00122O000B00F96O0009000B00024O00080008000900202O0008000800224O00080002000200062O000800E703010001002O043O00E70301002E5000FB00EC030100FA002O043O00EC03012O002D0108000B4O00A8000900054O002D010A00023O002044000A000A00FC2O00D50008000A000100122A000700063O002O043O008D0301002O043O00F00301002O043O00880301000E560001006703010003002O043O0067030100122A000600014O00CC000700073O002E5000FE00F4030100FD002O043O00F40301002E5000FF00F403012O00012O043O00F4030100122A000800013O00068D000800F403010006002O043O00F4030100122A000700013O00122A0008002O012O00122A0009002O012O00068D0008000504010009002O043O0005040100122A000800063O00068D0007000504010008002O043O0005040100122A000300063O002O043O0067030100122A000800013O00068D000700FC03010008002O043O00FC03012O002D010800013O001294000A0002015O00080008000A00122O000A00066O0008000A00024O000400086O000800046O000900026O000A00033O00122O000B0003012O00122O000C0004015O000A000C00024O00090009000A4O000A00026O000B00033O00122O000C0005012O00122O000D0006015O000B000D00024O000A000A000B4O000B00026O000C00033O00122O000D0007012O00122O000E0008015O000C000E00024O000B000B000C4O000C00026O000D00033O00122O000E0009012O00122O000F000A015O000D000F00024O000C000C000D4O0008000400012O00A8000500083O00122A000700063O002O043O00FC0301002O043O00670301002O043O00F40301002O043O00670301002O043O003E040100122A0006000B012O00122A0007000C012O00062F0007006203010006002O043O0062030100122A000600013O0006620002003A04010006002O043O003A040100122A0006000D012O00122A0007000E012O00062F0007006203010006002O043O0062030100122A000300014O00CC000400043O00122A000200063O002O043O0062030100122A0002002C3O00122A0003000F012O0006690003004D04010002002O043O004D040100122A00020010012O00122A00030011012O00062F0003004D04010002002O043O004D04012O002D010200044O002D01035O00062F0003004D04010002002O043O004D04012O002D010200044O000E00025O002O043O005C040100122A00020012012O00122A00030012012O00068D0002005604010003002O043O005604012O002D010200043O00122A000300013O0006690002005604010003002O043O00560401002O043O005C040100122A000200014O000E000200043O002O043O005C0401002O043O00070001002O043O005C0401002O043O000200012O00CD3O00017O00143O00028O00025O00806840025O009EA740026O00F03F025O00108E40025O0014AD40026O00A040025O00CEA74003083O00D1F630D0FBF238D703043O00B297935C03113O0054696D6553696E63654C617374436173742O033O00474344030E3O00A5F34A3700427B80CE58201B477F03073O001AEC9D2C52722C025O00B6A240025O00B2A440025O00B07940025O0034A740030E3O004973496E4D656C2O6552616E6765026O001440004F3O00122A3O00013O002E8E0002000500010003002O043O00050001002619012O000700010004002O043O00070001002E8E0006001100010005002O043O001100012O002D2O0100013O00060A0001000F00010001002O043O000F00012O002D2O0100023O000E360001000E00010001002O043O000E00012O00F400016O006E000100014O000E00015O002O043O004E0001002E8E0007000100010008002O043O0001000100268F3O000100010001002O043O000100012O002D2O0100034O00B1000200043O00122O000300093O00122O0004000A6O0002000400024O00010001000200202O00010001000B4O0001000200024O000200053O00202O00020002000C4O0002000200020006720001002F00010002002O043O002F00012O002D2O0100034O005C000200043O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O00010001000B4O0001000200024O000200053O00202O00020002000C4O00020002000200062O0001004700010002002O043O0047000100122A000100013O002E50000F004300010010002O043O0043000100268F0001004300010001002O043O0043000100122A000200013O000E560004003900010002002O043O0039000100122A000100043O002O043O004300010026190102003D00010001002O043O003D0001002E8E0012003500010011002O043O003500012O006E000300014O008C000300016O000300016O00035O00122O000200043O00044O00350001000E560004003000010001002O043O003000012O00CD3O00013O002O043O003000012O002D2O0100063O00209C00010001001300122O000300146O0001000300024O000100013O00124O00043O00044O000100012O00CD3O00017O00023O00030D3O00446562752O6652656D61696E7303103O0046696572794272616E64446562752O6601063O00201F2O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O0003083O00446562752O66557003103O0046696572794272616E64446562752O6601063O00201F2O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00173O00028O00025O00809440025O00D2A540025O00E8A040025O0098AA40025O00E09040025O00CCA640025O00749540025O0088B240026O00F03F025O005EA340025O00D8A74003103O0048616E646C65546F705472696E6B6574026O004440025O00C4AA40025O00D49B40025O0082AD40025O00A4914003133O0048616E646C65426F2O746F6D5472696E6B6574025O00849240025O0068A440025O0018B140025O00CCAF4000513O00122A3O00014O00CC000100013O002E8E0002000200010003002O043O0002000100268F3O000200010001002O043O0002000100122A000100013O000E2F2O01000B00010001002O043O000B0001002E8E0005003900010004002O043O0039000100122A000200014O00CC000300033O002E8E0006001100010007002O043O001100010026190102001300010001002O043O00130001002E500009000D00010008002O043O000D000100122A000300013O00268F000300180001000A002O043O0018000100122A0001000A3O002O043O00390001000E560001001400010003002O043O0014000100122A000400013O002E50000B00210001000C002O043O00210001000E56000A002100010004002O043O0021000100122A0003000A3O002O043O0014000100268F0004001B00010001002O043O001B00012O002D010500013O00200901050005000D4O000600026O000700033O00122O0008000E6O000900096O0005000900024O00058O00055O00062O0005003200010001002O043O00320001002E49000F003200010010002O043O00320001002E500011003400010012002O043O003400012O002D01056O00BF000500023O00122A0004000A3O002O043O001B0001002O043O00140001002O043O00390001002O043O000D0001000E56000A000700010001002O043O000700012O002D010200013O0020F20002000200134O000300026O000400033O00122O0005000E6O000600066O0002000600024O00025O002E2O0014005000010015002O043O005000012O002D01025O00060A0002004A00010001002O043O004A0001002E8E0016005000010017002O043O005000012O002D01026O00BF000200023O002O043O00500001002O043O00070001002O043O00500001002O043O000200012O00CD3O00017O00683O00028O00025O0080B140025O00588540026O00F03F025O00288940025O0042B040025O0028B340025O00D8A540025O0080A340027O0040025O00BAA340025O0023B24003053O00028A79BD2303043O00DC51E21C030A3O0049734361737461626C65025O001EAF40025O00F89140025O001CB240025O0034AC4003053O00536865617203124O00DD87FAF88703C787F8E5CA11D4962OBB9703063O00A773B5E29B8A025O00C4AF40025O0097B040025O00989640025O00088140025O00408340025O00E06840025O0020B140025O00D0A140025O00D4B140025O00B08240030E3O00D4C312D05CB9FCC127C15CBEF6C803063O00D79DAD74B52E026O003840025O00A09E40025O00F88340025O0026AA40025O0046AD4003143O00496E6665726E616C537472696B65506C61796572030E3O004973496E4D656C2O6552616E6765031B3O003CBA8DF7C83BB587CDC921A682F9DF75A499F7D93AB989F3CE75E203053O00BA55D4EB92025O0047B040025O00BEB04003083O00E49317FD2DFB4AC703073O0038A2E1769E598E025O00E2AA40025O008AAB4003083O00467261637475726503143O005A17C1AC36CD4E0080BF30DD5F0ACDAD23CC1C5D03063O00B83C65A0CF42025O0012B040025O0064B340025O0062AE40025O009EB240025O0088A440025O0040A340025O00249240025O001EA440025O00FAA840025O006EA740025O0096AB40025O00AEAB4003083O0049734D6F76696E67030C3O001927D2522601D37D262FD85E03043O003B4A4EB5025O00C08D40025O00C05140025O0056A240025O00707A4003063O0035DD5B43B63703053O00D345B12O3A03123O0094EA77F6ECC5A3F778E1ECCF84EC7EFCE5D803063O00ABD785199589030B3O004973417661696C61626C65025O0085B340025O00A7B24003123O00536967696C4F66466C616D65506C61796572031A3O00F2C135F3E30FF344DECE3EFBE235BC52F3CD31F5E232FD56A19A03083O002281A8529A8F509C025O000AAA40025O0068AC4003063O0086A72118475C03073O00E9E5D2536B282E03123O00536967696C4F66466C616D65437572736F7203093O004973496E52616E6765026O003E40031A3O00D24B35DF09FE4D34E903CD433FD345D15037D50ACC4033C2459303053O0065A12252B6025O00F88040030E3O00C10054F1D7E39627E70378EBC9E303083O004E886D399EBB82E2030E3O00492O6D6F6C6174696F6E41757261031B3O003732F4FE323EEDF82O31C6F02B2DF8B12E2DFCF23132FBF02A7FAD03043O00915E5F99025O00F4AC40025O00B2A240025O0098AD40026O004640025O00709B40025O003EAD40025O00B6B240025O00A0A5400034012O00122A3O00014O00CC000100023O002E8E000300292O010002002O043O00292O01002619012O000800010004002O043O00080001002E50000600292O010005002O043O00292O01002E6C00073O00010007002O043O0008000100268F0001000800010001002O043O0008000100122A000200013O002E8E0009003300010008002O043O00330001002619010200130001000A002O043O00130001002E50000C00330001000B002O043O003300012O002D01036O004F000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003002300013O002O043O002300012O002D010300023O0006DE0003002300013O002O043O002300012O002D010300033O00060A0003002500010001002O043O00250001002E50001000332O010011002O043O00332O01002E50001300332O010012002O043O00332O012O002D010300044O002D01045O0020440004000400142O00AB0003000200020006DE000300332O013O002O043O00332O012O002D010300013O0012EF000400153O00122O000500166O000300056O00035O00044O00332O01002E500017009000010018002O043O0090000100268F0002009000010004002O043O0090000100122A000300014O00CC000400043O0026190103003D00010001002O043O003D0001002E50001900390001001A002O043O0039000100122A000400013O0026190104004200010004002O043O00420001002E6C001B00040001001C002O043O0044000100122A0002000A3O002O043O009000010026190104004800010001002O043O00480001002E8E001D003E0001001E002O043O003E0001002E50002000570001001F002O043O005700012O002D01056O004F000600013O00122O000700213O00122O000800226O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005005700013O002O043O005700012O002D010500053O00060A0005005900010001002O043O00590001002E6C0023001600010024002O043O006D0001002E500025006D00010026002O043O006D0001002E6C0027001200010027002O043O006D00012O002D010500044O003C000600063O00202O0006000600284O000700073O00202O0007000700294O000900086O0007000900024O000700076O00050007000200062O0005006D00013O002O043O006D00012O002D010500013O00122A0006002A3O00122A0007002B4O0096000500074O008B00055O002E8E002C008C0001002D002O043O008C00012O002D01056O004F000600013O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005008C00013O002O043O008C00012O002D010500093O0006DE0005008C00013O002O043O008C00012O002D010500033O0006DE0005008C00013O002O043O008C0001002E500030008C00010031002O043O008C00012O002D010500044O002D01065O0020440006000600322O00AB0005000200020006DE0005008C00013O002O043O008C00012O002D010500013O00122A000600333O00122A000700344O0096000500074O008B00055O00122A000400043O002O043O003E0001002O043O00900001002O043O00390001002E500035000D00010036002O043O000D0001002E500037000D00010038002O043O000D0001000E560001000D00010002002O043O000D000100122A000300013O002E50003A009B00010039002O043O009B00010026190103009D00010001002O043O009D0001002E6C003B00810001003C002O043O001C2O0100122A000400013O002619010400A400010004002O043O00A40001002E49003D00A40001003E002O043O00A40001002E50004000A60001003F002O043O00A6000100122A000300043O002O043O001C2O0100268F0004009E00010001002O043O009E00012O002D0105000A3O0006DE000500BA00013O002O043O00BA00012O002D0105000B3O00209D0005000500412O00AB00050002000200060A000500BA00010001002O043O00BA00012O002D01056O001E010600013O00122O000700423O00122O000800436O0006000800024O00050005000600202O00050005000F4O00050002000200062O000500BC00010001002O043O00BC0001002E8E004400FB00010045002O043O00FB0001002E8E004700E200010046002O043O00E200012O002D0105000C4O000D010600013O00122O000700483O00122O000800496O00060008000200062O000500CF00010006002O043O00CF00012O002D01056O004F000600013O00122O0007004A3O00122O0008004B6O0006000800024O00050005000600202O00050005004C4O00050002000200062O000500E200013O002O043O00E20001002E8E004E00FB0001004D002O043O00FB00012O002D010500044O003C000600063O00202O00060006004F4O000700073O00202O0007000700294O000900086O0007000900024O000700076O00050007000200062O000500FB00013O002O043O00FB00012O002D010500013O0012EF000600503O00122O000700516O000500076O00055O00044O00FB0001002E50005200FB00010053002O043O00FB00012O002D0105000C4O007A000600013O00122O000700543O00122O000800556O00060008000200062O000500FB00010006002O043O00FB00012O002D010500044O00AF000600063O00202O0006000600564O000700073O00202O00070007005700122O000900586O0007000900024O000700076O00050007000200062O000500FB00013O002O043O00FB00012O002D010500013O00122A000600593O00122A0007005A4O0096000500074O008B00055O002E6C005B001F0001005B002O043O001A2O012O002D01056O004F000600013O00122O0007005C3O00122O0008005D6O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005001A2O013O002O043O001A2O012O002D0105000D3O0006DE0005001A2O013O002O043O001A2O012O002D010500044O003C00065O00202O00060006005E4O000700073O00202O0007000700294O000900086O0007000900024O000700076O00050007000200062O0005001A2O013O002O043O001A2O012O002D010500013O00122A0006005F3O00122A000700604O0096000500074O008B00055O00122A000400043O002O043O009E0001002E8E006200202O010061002O043O00202O01002619010300222O010004002O043O00222O01002E500063009700010064002O043O0097000100122A000200043O002O043O000D0001002O043O00970001002O043O000D0001002O043O00332O01002O043O00080001002O043O00332O01002E500065002D2O010066002O043O002D2O01002619012O002F2O010001002O043O002F2O01002E500067000200010068002O043O0002000100122A000100014O00CC000200023O00122A3O00043O002O043O000200012O00CD3O00017O006A3O00028O00025O004CA440025O0028A940027O004003103O004865616C746850657263656E74616765025O00C5B240025O0004A84003193O00015754E4FC205A5BF8FE737A57F7F53A5C55B6C93C465BF9F703053O0099532O329603173O006F73750E76B8455478743476AA415478742C7CBF44527803073O002D3D16137C13CB03073O004973526561647903173O0052656672657368696E674865616C696E67506F74696F6E03233O00D3170BE70763B1C81C0AB50A75B8CD1B03F24260B6D51B02FB4274BCC71703E60B66BC03073O00D9A1726D956210031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O0048A040025O007EAB40025O00F7B240025O0030AE4003193O0036323D7DB163132C3379AE673A253970B57A15103768B57B1C03063O00147240581CDC025O0062B340025O00B8AC40025O00B2B040025O0016AB40025O007AA94003253O003513D7B5F5C7BC3D0AD7A6EB90B53400DEBDF6D7FD210EC6BDF7DEFD3504D4B1F6C3B4270403073O00DD5161B2D498B0025O00149040025O00D49640025O000AA240026O00F03F025O00405640030B3O00C627EA537542D6EB29E24F03073O00A68242873C1B11030A3O0049734361737461626C6503083O0042752O66446F776E030F3O0044656D6F6E5370696B657342752O6603113O004D6574616D6F7270686F73697342752O6603103O0046696572794272616E64446562752O66025O003DB240025O00F07F40025O00508940025O00808D40030B3O00604FC37A3E775AC77E355703053O0050242AAE1503113O00436861726765734672616374696F6E616C026O66FE3F025O007EB040025O00309D40025O005EAB40026O002A40030B3O0044656D6F6E5370696B657303203O004A153A75402F246A471B32690E14327C4B1E24735815243A0633366A5E152O3303043O001A2E7057025O0024A840025O00805940025O0055B340025O0094A74003203O00BD26A67BB18056A4B028AE67FFBB40B2BC2DB87DA9BA56F4F107AA7AB8BA57FD03083O00D4D943CB142ODF25025O00089940025O00A07240025O0039B040025O00C49740030D3O009788BCD3B782BAC2B282BBDBA903043O00B2DAEDC803093O0054696D65546F446965026O002E40025O005DB040025O004FB04003133O004D6574616D6F7270686F736973506C6179657203183O00BBB0F2D1BBBAF4C0BEBAF5D9A5F5E2D52OB0E8C3BFA3E3C303043O00B0D6D586025O000DB240025O005C9C40025O00A49D40025O00607440025O00206F40025O00C05640025O00F6A540025O001CA540025O00A6AB40025O00809D40030A3O00D2A4B3C6B1744BF5A3B203073O003994CDD6B4C836025O0004B240025O003C9C40030A3O0046696572794272616E64030E3O0049735370652O6C496E52616E676503163O0014F430266F2DFF27357816BD2O317017F3263D6017EE03053O0016729D5554025O00C88E40025O005AA640025O00C88340025O0066B140030B3O00ECCE12C849FEBBD0C41DC103073O00C8A4AB73A43D96030B3O004865616C746873746F6E65025O0030A240025O00907740025O00A9B240025O009AB24003153O00B6F1024997B6E7174A8DBBB4074085BBFA104C95BB03053O00E3DE946325006B012O00122A3O00014O00CC000100013O00268F3O000200010001002O043O0002000100122A000100013O002E8E0002005E00010003002O043O005E000100268F0001005E00010004002O043O005E00012O002D01025O0006DE0002006A2O013O002O043O006A2O012O002D010200013O00209D0002000200052O00AB0002000200022O002D010300023O0006690002006A2O010003002O043O006A2O0100122A000200014O00CC000300033O00268F0002001400010001002O043O0014000100122A000300013O0026190103001B00010001002O043O001B0001002E500006001700010007002O043O001700012O002D010400034O007A000500043O00122O000600083O00122O000700096O00050007000200062O0004003700010005002O043O003700012O002D010400054O004F000500043O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004003700013O002O043O003700012O002D010400064O002D010500073O00204400050005000D2O00AB0004000200020006DE0004003700013O002O043O003700012O002D010400043O00122A0005000E3O00122A0006000F4O0096000400064O008B00046O002D010400033O0026190104003C00010010002O043O003C0001002E8E0012006A2O010011002O043O006A2O01002E500014006A2O010013002O043O006A2O012O002D010400054O001E010500043O00122O000600153O00122O000700166O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004004A00010001002O043O004A0001002E8E0017006A2O010018002O043O006A2O01002E6C001900202O010019002O043O006A2O012O002D010400064O002D010500073O00204400050005000D2O00AB00040002000200060A0004005400010001002O043O00540001002E50001A006A2O01001B002O043O006A2O012O002D010400043O0012EF0005001C3O00122O0006001D6O000400066O00045O00044O006A2O01002O043O00170001002O043O006A2O01002O043O00140001002O043O006A2O01002E6C001E009F0001001E002O043O00FD0001002E8E001F00FD00010020002O043O00FD0001000E56000100FD00010001002O043O00FD000100122A000200013O000E560021006900010002002O043O0069000100122A000100213O002O043O00FD0001002E6C002200FCFF2O0022002O043O0065000100268F0002006500010001002O043O006500012O002D010300084O004F000400043O00122O000500233O00122O000600246O0004000600024O00030003000400202O0003000300254O00030002000200062O0003009500013O002O043O009500012O002D010300093O0006DE0003009500013O002O043O009500012O002D010300013O0020580003000300264O000500083O00202O0005000500274O00030005000200062O0003009500013O002O043O009500012O002D010300013O0020580003000300264O000500083O00202O0005000500284O00030005000200062O0003009500013O002O043O009500012O002D0103000A3O00268F0003009200010021002O043O009200012O002D010300013O0020340003000300264O000500083O00202O0005000500294O00030005000200062O0003009900010001002O043O009900012O002D0103000A3O000E360021009900010003002O043O00990001002ECE002A00990001002B002O043O00990001002E50002D00CB0001002C002O043O00CB00012O002D010300084O0082000400043O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O0003000300304O000300020002000E2O003100A700010003002O043O00A70001002E49003200A700010033002O043O00A70001002E8E003400B300010035002O043O00B300012O002D010300064O002D010400083O0020440004000400362O00AB0003000200020006DE000300CB00013O002O043O00CB00012O002D010300043O0012EF000400373O00122O000500386O000300056O00035O00044O00CB00012O002D0103000B3O00060A000300BC00010001002O043O00BC00012O002D010300013O00209D0003000300052O00AB0003000200022O002D0104000C3O000669000300CB00010004002O043O00CB0001002E8E003A00C400010039002O043O00C400012O002D010300064O002D010400083O0020440004000400362O00AB00030002000200060A000300C600010001002O043O00C60001002E8E003B00CB0001003C002O043O00CB00012O002D010300043O00122A0004003D3O00122A0005003E4O0096000300054O008B00035O002E8E004000FB0001003F002O043O00FB0001002E50004200FB00010041002O043O00FB00012O002D010300084O004F000400043O00122O000500433O00122O000600446O0004000600024O00030003000400202O0003000300254O00030002000200062O000300FB00013O002O043O00FB00012O002D0103000D3O0006DE000300FB00013O002O043O00FB00012O002D010300013O00209D0003000300052O00AB0003000200022O002D0104000E3O000669000300FB00010004002O043O00FB00012O002D010300013O0020340003000300264O000500083O00202O0005000500284O00030005000200062O000300EE00010001002O043O00EE00012O002D0103000F3O00209D0003000300452O00AB00030002000200262B000300FB00010046002O043O00FB0001002E8E004800FB00010047002O043O00FB00012O002D010300064O002D010400073O0020440004000400492O00AB0003000200020006DE000300FB00013O002O043O00FB00012O002D010300043O00122A0004004A3O00122A0005004B4O0096000300054O008B00035O00122A000200213O002O043O00650001000E560021000500010001002O043O0005000100122A000200014O00CC000300033O002E8E004D003O01004C002O043O003O0100268F0002003O010001002O043O003O0100122A000300013O002E8E004F000C2O01004E002O043O000C2O01000E560021000C2O010003002O043O000C2O0100122A000100043O002O043O00050001000E2F2O0100122O010003002O043O00122O01002ECE005000122O010051002O043O00122O01002E50005200062O010053002O043O00062O01002E500055003D2O010054002O043O003D2O012O002D010400084O004F000500043O00122O000600563O00122O000700576O0005000700024O00040004000500202O0004000400254O00040002000200062O0004002A2O013O002O043O002A2O012O002D010400103O0006DE0004002A2O013O002O043O002A2O012O002D0104000B3O00060A0004002C2O010001002O043O002C2O012O002D010400013O00209D0004000400052O00AB0004000200022O002D010500113O0006430004000300010005002O043O002C2O01002E6C0058001300010059002O043O003D2O012O002D010400064O0037000500083O00202O00050005005A4O0006000F3O00202O00060006005B4O000800083O00202O00080008005A4O0006000800024O000600066O00040006000200062O0004003D2O013O002O043O003D2O012O002D010400043O00122A0005005C3O00122A0006005D4O0096000400064O008B00045O002E50005E00632O01005F002O043O00632O01002E8E006000632O010061002O043O00632O012O002D010400054O004F000500043O00122O000600623O00122O000700636O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400632O013O002O043O00632O012O002D010400123O0006DE000400632O013O002O043O00632O012O002D010400013O00209D0004000400052O00AB0004000200022O002D010500133O000669000400632O010005002O043O00632O012O002D010400064O002D010500073O0020440005000500642O00AB00040002000200060A0004005E2O010001002O043O005E2O01002ECE0065005E2O010066002O043O005E2O01002E6C0067000700010068002O043O00632O012O002D010400043O00122A000500693O00122A0006006A4O0096000400064O008B00045O00122A000300213O002O043O00062O01002O043O00050001002O043O003O01002O043O00050001002O043O006A2O01002O043O000200012O00CD3O00017O00743O00028O00025O00A09B40026O00F03F025O0024AA40025O00A09640025O005EA940030E3O00C8A7B521F781B41BF2A2B726F8AB03043O00489BCED2030A3O0049734361737461626C6503083O0049734D6F76696E67030E3O006563570236497C76073D42735A0903053O0053261A346E030B3O004973417661696C61626C65030E3O006B1E204F54382175511B22485B1203043O0026387747025O00E4A240025O0050B140025O00789B40025O00BEAA4003063O002OE359CF204403063O0036938F38B64503123O00F58EF14ADAD895ED48CBD385CC40D8DF8DEC03053O00BFB6E19F29025O00709540025O002AAF4003143O00536967696C4F6653696C656E6365506C61796572030E3O004973496E4D656C2O6552616E676503203O00381B2F5C87B8CD2O2D3B5C8782CC281768458786DB2E006853828BCE2E00682O03073O00A24B724835EBE7025O0080AD40025O00A89C4003063O008F2956F15C1003063O0062EC5C248233025O0056A040025O00D4A74003143O00536967696C4F6653696C656E6365437572736F7203093O004973496E52616E6765026O003E40025O00109440025O002EAF4003203O00B7100BB34997BA369B0A05B640A6B635E41A19A8562OA770A21000B640BAF56603083O0050C4796CDA25C8D5030B3O00347B10705C2986017A147A03073O00EA6013621F2B6E030B3O005468726F77476C61697665030E3O0049735370652O6C496E52616E6765025O005BB040025O00D2A94003153O00121740C8BB4D8C0A1E5BD1A9328D0F135EC2BE32D303073O00EB667F32A7CC12025O0022B140025O00489140025O000C9140025O0030AF40025O009AAB40025O00AAAB40025O003BB040025O008CAD40025O0016AE40025O00288540025O00B49240025O000DB140025O0012A640025O00DCAE40030D3O00FEEE1AF216E2E13EF31BC4E90E03053O007AAD877D9B030E3O00A7D803B53A3ECEA6C80EBD363FCF03073O00A8E4A160D95F51030D3O00E8D829552378DDF2265D2659C803063O0037BBB14E3C4F03063O003DC25EF243DD03073O00E04DAE3F8B26AF03123O00A74E562D814F4C3C85555D2AB7485F27885203043O004EE4213803133O00536967696C4F66436861696E73506C61796572031F3O00DD77B50A89F171B43C86C67FBB0D968E6EBE029CCB6CF2058CC272B711C59C03053O00E5AE1ED26303063O0018F89442E22F03073O00597B8DE6318D5D025O00749040025O0028AC40025O0012B340025O0080AE4003133O00536967696C4F66436861696E73437572736F72031F3O00E078F1051C75FC77C90F184BFA7FE54C135FE162F91E504CFA7DFA09020AA103063O002A9311966C70030D3O003CAF2A76EBC7098B246CE2FA1603063O00886FC64D1F87030E3O002110A45AB8EB118B0B07A35FB3E303083O00C96269C736DD8477030D3O008A0584280E1AAA94059024102C03073O00CCD96CE341625503063O004ECFF4FC29D203063O00A03EA395854C03123O00F5AF032CC6D8B41F2ED7D3A43E26C4DFAC1E03053O00A3B6C06D4F025O00FC9840025O0030AD40025O00F0B240025O00A0614003133O00536967696C4F664D6973657279506C61796572031F3O00272F07C9F90B2906FFF83D3505D2EC74360CC1EC313440C6FC382A05D2B56003053O0095544660A0025O00A4AB40025O003EAE4003063O003B131FFE371403043O008D58666D025O005EA740025O0052B14003133O00536967696C4F664D6973657279437572736F72031F3O00A05ACD7916025AC78C5EC3631F2F4C81B046D863152F15C7BA5FC675087D0103083O00A1D333AA107A5D35025O00C4AD40025O00B8A840025O00309A40025O00A09A4000A0012O00122A3O00014O00CC000100023O002E6C000200952O010002002O043O00972O01000E56000300972O013O002O043O00972O0100268F0001000600010001002O043O0006000100122A000200013O002E500005009C00010004002O043O009C000100268F0002009C00010003002O043O009C0001002E6C0006002800010006002O043O003500012O002D01036O004F000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003003500013O002O043O003500012O002D010300023O0006DE0003003500013O002O043O003500012O002D010300033O00209D00030003000A2O00AB00030002000200060A0003003500010001002O043O003500012O002D01036O004F000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003003500013O002O043O003500012O002D01036O001E010400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003003700010001002O043O00370001002E500011007B00010010002O043O007B0001002E8E0012005D00010013002O043O005D00012O002D010300044O000D010400013O00122O000500143O00122O000600156O00040006000200062O0003004A00010004002O043O004A00012O002D01036O004F000400013O00122O000500163O00122O000600176O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003005D00013O002O043O005D0001002E500018007B00010019002O043O007B00012O002D010300054O003C000400063O00202O00040004001A4O000500073O00202O00050005001B4O000700086O0005000700024O000500056O00030005000200062O0003007B00013O002O043O007B00012O002D010300013O0012EF0004001C3O00122O0005001D6O000300056O00035O00044O007B0001002E8E001F00660001001E002O043O006600012O002D010300044O007A000400013O00122O000500203O00122O000600216O00040006000200062O0003007B00010004002O043O007B0001002E500023006900010022002O043O00690001002O043O007B00012O002D010300054O000C010400063O00202O0004000400244O000500073O00202O00050005002500122O000700266O0005000700024O000500056O00030005000200062O0003007600010001002O043O00760001002E8E0028007B00010027002O043O007B00012O002D010300013O00122A000400293O00122A0005002A4O0096000300054O008B00036O002D01036O004F000400013O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009F2O013O002O043O009F2O012O002D010300093O0006DE0003009F2O013O002O043O009F2O012O002D010300054O00F300045O00202O00040004002D4O000500073O00202O00050005002E4O00075O00202O00070007002D4O0005000700024O000500056O00030005000200062O0003009600010001002O043O00960001002E8E002F009F2O010030002O043O009F2O012O002D010300013O0012EF000400313O00122O000500326O000300056O00035O00044O009F2O01002619010200A000010001002O043O00A00001002E8E0033000900010034002O043O0009000100122A000300014O00CC000400043O002E6C00353O00010035002O043O00A2000100268F000300A200010001002O043O00A2000100122A000400013O002E8E0037008A2O010036002O043O008A2O0100268F0004008A2O010001002O043O008A2O0100122A000500013O002E8E003800B400010039002O043O00B40001002E50003A00B40001003B002O043O00B40001000E56000300B400010005002O043O00B4000100122A000400033O002O043O008A2O01002E8E003C00AC0001003D002O043O00AC000100268F000500AC00010001002O043O00AC0001002E8E003F00202O01003E002O043O00202O01002E6C0040006600010040002O043O00202O012O002D01066O004F000700013O00122O000800413O00122O000900426O0007000900024O00060006000700202O0006000600094O00060002000200062O000600202O013O002O043O00202O012O002D0106000A3O0006DE000600202O013O002O043O00202O012O002D010600033O00209D00060006000A2O00AB00060002000200060A000600202O010001002O043O00202O012O002D01066O004F000700013O00122O000800433O00122O000900446O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600202O013O002O043O00202O012O002D01066O004F000700013O00122O000800453O00122O000900466O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600202O013O002O043O00202O012O002D010600044O000D010700013O00122O000800473O00122O000900486O00070009000200062O000600F300010007002O043O00F300012O002D01066O004F000700013O00122O000800493O00122O0009004A6O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600042O013O002O043O00042O012O002D010600054O003C000700063O00202O00070007004B4O000800073O00202O00080008001B4O000A00086O0008000A00024O000800086O00060008000200062O000600202O013O002O043O00202O012O002D010600013O0012EF0007004C3O00122O0008004D6O000600086O00065O00044O00202O012O002D010600044O007A000700013O00122O0008004E3O00122O0009004F6O00070009000200062O000600202O010007002O043O00202O01002E500051000E2O010050002O043O000E2O01002O043O00202O01002E8E005300202O010052002O043O00202O012O002D010600054O00AF000700063O00202O0007000700544O000800073O00202O00080008002500122O000A00266O0008000A00024O000800086O00060008000200062O000600202O013O002O043O00202O012O002D010600013O00122A000700553O00122A000800564O0096000600084O008B00066O002D01066O004F000700013O00122O000800573O00122O000900586O0007000900024O00060006000700202O0006000600094O00060002000200062O000600882O013O002O043O00882O012O002D0106000B3O0006DE000600882O013O002O043O00882O012O002D010600033O00209D00060006000A2O00AB00060002000200060A000600882O010001002O043O00882O012O002D01066O004F000700013O00122O000800593O00122O0009005A6O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600882O013O002O043O00882O012O002D01066O004F000700013O00122O0008005B3O00122O0009005C6O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600882O013O002O043O00882O012O002D010600044O000D010700013O00122O0008005D3O00122O0009005E6O00070009000200062O000600592O010007002O043O00592O012O002D01066O001E010700013O00122O0008005F3O00122O000900606O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600592O010001002O043O00592O01002E6C0061001500010062002O043O006C2O01002E8E006400882O010063002O043O00882O012O002D010600054O003C000700063O00202O0007000700654O000800073O00202O00080008001B4O000A00086O0008000A00024O000800086O00060008000200062O000600882O013O002O043O00882O012O002D010600013O0012EF000700663O00122O000800676O000600086O00065O00044O00882O01002E50006800752O010069002O043O00752O012O002D010600044O007A000700013O00122O0008006A3O00122O0009006B6O00070009000200062O000600882O010007002O043O00882O01002E50006D00782O01006C002O043O00782O01002O043O00882O012O002D010600054O00AF000700063O00202O00070007006E4O000800073O00202O00080008002500122O000A00266O0008000A00024O000800086O00060008000200062O000600882O013O002O043O00882O012O002D010600013O00122A0007006F3O00122A000800704O0096000600084O008B00065O00122A000500033O002O043O00AC0001002E50007200A700010071002O043O00A7000100268F000400A700010003002O043O00A7000100122A000200033O002O043O00090001002O043O00A70001002O043O00090001002O043O00A20001002O043O00090001002O043O009F2O01002O043O00060001002O043O009F2O01002619012O009B2O010001002O043O009B2O01002E6C00730069FE2O0074002O043O0002000100122A000100014O00CC000200023O00122A3O00033O002O043O000200012O00CD3O00017O00803O00028O00026O00F03F025O00FAA340025O0052A440025O00E49140025O00DEA540025O00E49D40025O001CA240025O00E89040025O004CA040025O00E09F40025O00AAA940025O00F2AA40030E3O0076A4F907413851B2E12250275FAF03063O004E30C195432403073O004973526561647903113O0013118C1444330A890E441110870D48231603053O0021507EE078030B3O004973417661696C61626C65030E3O00DFBC0CCF59F8A006E250EDA506D703053O003C8CC863A4025O00688040025O00149540030E3O0046656C4465766173746174696F6E030E3O004973496E4D656C2O6552616E676503193O0081F10819A682E20535B686E00D29ACC7F60D219D86FB0166F003053O00C2E794644603073O007244C48BE3C65203063O00A8262CA1C396030A3O0049734361737461626C65025O00C4AD40025O003AB040025O00EEA24003073O0054686548756E7403093O004973496E52616E6765026O00494003123O0094F4874938FDB802C0FE8B710FE9B913C0A803083O0076E09CE2165088D6025O00E07F40025O0032B140025O0068B240025O00CAAD40030D3O0067E240934BEF57A447ED4B854703043O00E0228E3903083O0049734D6F76696E67025O00B49D40025O0058AE4003063O00CEAB2OC476E303083O006EBEC7A5BD13913D025O0019B140025O0050734003133O00456C797369616E446563722O65506C61796572025O00206340025O001EA04003213O00DFE76EFB82C62OD473ED88D5DFEE37EA82C0E5EA78EDCB919AA347E48ADEDFF93E03063O00A7BA8B1788EB03063O0019A09A1E15A703043O006D7AD5E803133O00456C797369616E446563722O65437572736F72026O003E4003213O00EBFBBB23E7F6AC0FEAF2A122EBF2E232E7F09D31E1F2E266AEBF8125FCE4AD22A703043O00508E97C2025O00F07640025O00B2A640027O0040025O00849A40025O00D2A24003083O00360633F6C2BBB01503073O00C270745295B6CE03083O00467261637475726503133O003FBA4D1BD4F71C3CE84E11C7DD0F36AD0C499403073O006E59C82C78A08203053O0098CB4E475103083O002DCBA32B26232A5B025O004AAE40025O0046A54003053O005368656172025O0030A440025O005EA940025O007AA340025O00AEA04003103O00C18DD92295E956DB82E32288AC1483D303073O0034B2E5BC43E7C9025O006C9B40025O00A88540025O002OAA40030A3O00124E4508D4502620575503073O004341213064973C030A3O00536F756C436C65617665025O00EFB140025O00E8A740025O003C9040025O00C8984003163O00CCE8BBD4CCDCEBABD9E5DAA7ACD1F4E0E6A1DDB38EBF03053O0093BF87CEB8026O000840025O0054A340025O00B3B140026O00A340025O00A08E40025O00B49040025O00B8A940025O00EC9640030E3O0025C37B6806D0765F17C763450CC803043O002C63A617025O00689540026O00834003193O007AF2250937A16AF63A2232B075F8277631AD7BC8283936E42403063O00C41C97495653025O007AA840025O00389A40030A3O00C00C3C1CA1590A60F61103083O001693634970E23878025O0071B240025O00389440030A3O00536F756C43617276657203163O00AB7AF7F9B2BB74F0E388AA35E0FC8A8774EDF0CDE92503053O00EDD8158295025O00B9B240025O003AA240030A3O00B15E564DB9DD7C8D435D03073O003EE22E2O3FD0A9026O001040025O003EB340025O00A09440030A3O00537069726974426F6D6203163O00F6095C911619105CEA1457C31D042861E41650C34E5F03083O003E857935E37F6D4F00F9012O00122A3O00014O00CC000100033O000E56000200F22O013O002O043O00F22O012O00CC000300033O002E8E0003000C00010004002O043O000C000100268F0001000C00010001002O043O000C000100122A000200014O00CC000300033O00122A000100023O002E8E0005000500010006002O043O00050001000E560002000500010001002O043O00050001002E6C000700E600010007002O043O00F60001002E50000900F600010008002O043O00F6000100268F000200F600010001002O043O00F6000100122A000400013O000E2F2O01001B00010004002O043O001B0001002E50000A00940001000B002O043O0094000100122A000500013O00268F0005002000010002002O043O0020000100122A000400023O002O043O00940001000E2F2O01002400010005002O043O00240001002E8E000D001C0001000C002O043O001C00012O002D01066O004F000700013O00122O0008000E3O00122O0009000F6O0007000900024O00060006000700202O0006000600104O00060002000200062O0006005200013O002O043O005200012O002D010600024O002D010700033O00062F0006005200010007002O043O005200012O002D010600043O0006DE0006005200013O002O043O005200012O002D010600053O0006DE0006003B00013O002O043O003B00012O002D010600063O00060A0006003E00010001002O043O003E00012O002D010600063O00060A0006005200010001002O043O005200012O002D01066O001E010700013O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600134O00060002000200062O0006005400010001002O043O005400012O002D01066O001E010700013O00122O000800143O00122O000900156O0007000900024O00060006000700202O0006000600134O00060002000200062O0006005400010001002O043O00540001002E500017006400010016002O043O006400012O002D010600074O003C00075O00202O0007000700184O000800083O00202O0008000800194O000A00096O0008000A00024O000800086O00060008000200062O0006006400013O002O043O006400012O002D010600013O00122A0007001A3O00122A0008001B4O0096000600084O008B00066O002D01066O004F000700013O00122O0008001C3O00122O0009001D6O0007000900024O00060006000700202O00060006001E4O00060002000200062O0006007E00013O002O043O007E00012O002D010600024O002D010700033O00062F0006007E00010007002O043O007E00012O002D0106000A3O0006DE0006007E00013O002O043O007E00012O002D010600053O0006DE0006007B00013O002O043O007B00012O002D0106000B3O00060A0006008000010001002O043O008000012O002D0106000B3O0006DE0006008000013O002O043O00800001002E8E002000920001001F002O043O00920001002E6C0021001200010021002O043O009200012O002D010600074O00AF00075O00202O0007000700224O000800083O00202O00080008002300122O000A00246O0008000A00024O000800086O00060008000200062O0006009200013O002O043O009200012O002D010600013O00122A000700253O00122A000800264O0096000600084O008B00065O00122A000500023O002O043O001C00010026190104009800010002002O043O00980001002E6C00270081FF2O0028002O043O00170001002E8E002A00BD00010029002O043O00BD00012O002D01056O004F000600013O00122O0007002B3O00122O0008002C6O0006000800024O00050005000600202O00050005001E4O00050002000200062O000500BD00013O002O043O00BD00012O002D010500024O002D010600033O00062F000500BD00010006002O043O00BD00012O002D0105000C3O0006DE000500BD00013O002O043O00BD00012O002D0105000D3O00209D00050005002D2O00AB00050002000200060A000500BD00010001002O043O00BD00012O002D010500053O0006DE000500B600013O002O043O00B600012O002D0105000E3O00060A000500B900010001002O043O00B900012O002D0105000E3O00060A000500BD00010001002O043O00BD00012O002D0105000F4O002D010600103O000672000600BF00010005002O043O00BF0001002E8E002F00F30001002E002O043O00F300012O002D010500114O007A000600013O00122O000700303O00122O000800316O00060008000200062O000500DB00010006002O043O00DB0001002E8E003300F300010032002O043O00F300012O002D010500074O0030000600123O00202O0006000600344O000700083O00202O0007000700194O000900096O0007000900024O000700076O00050007000200062O000500D500010001002O043O00D50001002E6C0035002000010036002O043O00F300012O002D010500013O0012EF000600373O00122O000700386O000500076O00055O00044O00F300012O002D010500114O000D010600013O00122O000700393O00122O0008003A6O00060008000200062O000500E300010006002O043O00E30001002O043O00F300012O002D010500074O00AF000600123O00202O00060006003B4O000700083O00202O00070007002300122O0009003C6O0007000900024O000700076O00050007000200062O000500F300013O002O043O00F300012O002D010500013O00122A0006003D3O00122A0007003E4O0096000500074O008B00055O00122A000200023O002O043O00F60001002O043O00170001002E50003F00642O010040002O043O00642O01000E56004100642O010002002O043O00642O0100122A000400013O00268F0004003A2O010001002O043O003A2O01002E50004200192O010043002O043O00192O012O002D01056O004F000600013O00122O000700443O00122O000800456O0006000800024O00050005000600202O00050005001E4O00050002000200062O000500192O013O002O043O00192O012O002D010500133O0006DE000500192O013O002O043O00192O012O002D010500074O004200065O00202O0006000600464O000700146O000700076O00050007000200062O000500192O013O002O043O00192O012O002D010500013O00122A000600473O00122A000700484O0096000500074O008B00056O002D01056O004F000600013O00122O000700493O00122O0008004A6O0006000800024O00050005000600202O00050005001E4O00050002000200062O000500262O013O002O043O00262O012O002D010500153O00060A000500282O010001002O043O00282O01002E8E004B00392O01004C002O043O00392O012O002D010500074O007400065O00202O00060006004D4O000700146O000700076O00050007000200062O000500342O010001002O043O00342O01002E60004E00342O01004F002O043O00342O01002E50005000392O010051002O043O00392O012O002D010500013O00122A000600523O00122A000700534O0096000500074O008B00055O00122A000400023O0026190104003E2O010002002O043O003E2O01002E8E005400FB00010055002O043O00FB0001002E6C0056002300010056002O043O00612O012O002D01056O004F000600013O00122O000700573O00122O000800586O0006000800024O00050005000600202O0005000500104O00050002000200062O000500612O013O002O043O00612O012O002D010500163O00262B000500612O010002002O043O00612O012O002D010500173O0006DE000500612O013O002O043O00612O012O002D010500074O007400065O00202O0006000600594O000700146O000700076O00050007000200062O0005005C2O010001002O043O005C2O01002E49005A005C2O01005B002O043O005C2O01002E8E005D00612O01005C002O043O00612O012O002D010500013O00122A0006005E3O00122A0007005F4O0096000500074O008B00055O00122A000200603O002O043O00642O01002O043O00FB0001002E8E006100712O010062002O043O00712O0100268F000200712O010060002O043O00712O012O002D010400184O00B60004000100022O00A8000300043O002E50006400F82O010063002O043O00F82O010006DE000300F82O013O002O043O00F82O012O00BF000300023O002O043O00F82O0100268F0002001000010002002O043O0010000100122A000400013O002E6C0065005100010065002O043O00C52O010026190104007A2O010001002O043O007A2O01002E50006600C52O010067002O043O00C52O012O002D01056O004F000600013O00122O000700683O00122O000800696O0006000800024O00050005000600202O0005000500104O00050002000200062O000500A62O013O002O043O00A62O012O002D010500024O002D010600033O00062F000500A62O010006002O043O00A62O012O002D010500043O0006DE000500A62O013O002O043O00A62O012O002D010500053O0006DE000500912O013O002O043O00912O012O002D010500063O00060A000500942O010001002O043O00942O012O002D010500063O00060A000500A62O010001002O043O00A62O012O002D010500074O003000065O00202O0006000600184O000700083O00202O0007000700194O000900096O0007000900024O000700076O00050007000200062O000500A12O010001002O043O00A12O01002E6C006A00070001006B002O043O00A62O012O002D010500013O00122A0006006C3O00122A0007006D4O0096000500074O008B00055O002E8E006F00C42O01006E002O043O00C42O012O002D01056O004F000600013O00122O000700703O00122O000800716O0006000800024O00050005000600202O00050005001E4O00050002000200062O000500C42O013O002O043O00C42O012O002D010500193O0006DE000500C42O013O002O043O00C42O01002E50007300C42O010072002O043O00C42O012O002D010500074O004200065O00202O0006000600744O000700146O000700076O00050007000200062O000500C42O013O002O043O00C42O012O002D010500013O00122A000600753O00122A000700764O0096000500074O008B00055O00122A000400023O000E2F010200C92O010004002O043O00C92O01002E50007700742O010078002O043O00742O012O002D01056O004F000600013O00122O000700793O00122O0008007A6O0006000800024O00050005000600202O0005000500104O00050002000200062O000500D92O013O002O043O00D92O012O002D010500163O000E6A007B00D92O010005002O043O00D92O012O002D0105001A3O00060A000500DB2O010001002O043O00DB2O01002E50007C00EB2O01007D002O043O00EB2O012O002D010500074O003C00065O00202O00060006007E4O000700083O00202O0007000700194O000900096O0007000900024O000700076O00050007000200062O000500EB2O013O002O043O00EB2O012O002D010500013O00122A0006007F3O00122A000700804O0096000500074O008B00055O00122A000200413O002O043O00100001002O043O00742O01002O043O00100001002O043O00F82O01002O043O00050001002O043O00F82O0100268F3O000200010001002O043O0002000100122A000100014O00CC000200023O00122A3O00023O002O043O000200012O00CD3O00017O00B53O00028O00025O00A49B40026O00F03F025O003EA540025O00207540025O00AEA140025O00F0B040025O00C09C40025O00949640030A3O000A637053C72D51764CCC03053O00AE5913192103073O0049735265616479026O001440025O00109240025O00107840025O0068A940025O00D08040030A3O00537069726974426F6D62030E3O004973496E4D656C2O6552616E6765025O009C9B40025O000CB040025O002C9440025O00AAA740031B3O003C025B5CFE93342D1D5F4CB781022A004B71F382062601570EA6D503073O006B4F72322E97E7027O0040025O0078A840025O0042AD40030E3O00FB23FA67B0CB27E557B4C92FF94D03053O00D5BD469623025O00908D40025O0042A140030E3O0046656C4465766173746174696F6E031E3O00495078374B5062095C41751C465A7A48495C711A566A700D425C670D0F0D03043O00682F3514030A3O00904394109F0EB15A840E03063O006FC32CE17CDC030A3O0049734361737461626C65025O00FAB240025O004EB340025O00C49940025O0018A440030A3O00536F756C436172766572025O00108B40025O0020B140031B3O00CB49157F94A8D9541676B9EBDE4F0561B294DC430D7AB8AE98175003063O00CBB8266013CB026O000840025O0048B140025O0020A940025O0060A740025O00689540030D3O005E30A653B8DA7F817E3FAD45B403083O00C51B5CDF20D1BB1103083O0049734D6F76696E67025O00709840025O006CAC40025O0014A340025O00CCAF4003063O001353C2E2064D03043O009B633FA3025O00D1B24003133O00456C797369616E446563722O65506C6179657203273O0087DDB89EB0858CEEA588BA9687D4E18BB08190C89E89BC898BC2A4CDEBD4C2999181B89D87C3E803063O00E4E2B1C1EDD903063O0037A531F53BA203043O008654D043026O00AF40025O00F09040025O00A08840025O00E2AF4003133O00456C797369616E446563722O65437572736F7203093O004973496E52616E6765026O003E4003273O0016A09F4F1AAD886317A9854E16A9C65A1AA994452CA883511ABF831C41FCC61430B9944F1CBECF03043O003C73CCE6030A3O00D435FE7CC436EE71F13F03043O0010875A8B030B3O004675727944656669636974025O0046A240026O003D40030A3O00536F756C436C65617665025O0029B040025O003C9C40031B3O00477B133F715774517510360E527151661F0C4A51755D6703731C0603073O0018341466532E34025O00B07B40025O00D09640025O0026A540025O00E06F40025O001CAF40025O00F4B24003083O00D97458B43ADFF8FA03073O009C9F1134D656BE030E3O0088EAB198ABF9BCAFBAEEA9B5A1E103043O00DCCE8FDD030F3O00432O6F6C646F776E52656D61696E73030E3O00A0782133DDDAD395692C03D1C3DC03073O00B2E61D4D77B8AC030B3O004578656375746554696D65030A3O0047434452656D61696E7303043O0046757279026O004940025O009C9F40025O0006AD4003083O0046656C626C61646503173O00F3BB06197BF9F1BB4A1D7EFDE7A7351F72F5FCAD0F5B2103063O009895DE6A7B17025O007AAB40025O0026AE40025O0041B240030E3O00AD25ABCED452A68D27A8E0CD41B303073O00D2E448C6A1B833025O00DEA640025O00B6A740030E3O00492O6D6F6C6174696F6E41757261031E3O003F44FE1F7FCF2240FC1E4CCF235BF25075C7335BEA2F77CB3B40E015339C03063O00AE5629937013025O0053B140025O00A49E40030C3O0068098A022920178D5701800E03083O00CB3B60ED6B456F7103123O000719A2E234FEC33617B8E435C3DE231FA0F203073O00B74476CC815190030B3O004973417661696C61626C6503113O00446562752O665265667265736861626C6503123O00536967696C4F66466C616D65446562752O6603123O002DA27EE70E8C1ABF71F00E863DA477ED079103063O00E26ECD10846B03063O00FBCFE1C044F903053O00218BA380B9025O0058AB40025O00B8834003123O00536967696C4F66466C616D65506C61796572025O0008A140025O00EAA94003263O00445103D75B670BD8685E08DF5A5D44D85E5D16C7685C01D35E4B019E03184CEE5B591DDB451103043O00BE373864025O00C89C40025O00E8AE4003063O0055BA2E0D1CF103073O009336CF5C7E7383025O0096A040025O0068974003123O00536967696C4F66466C616D65437572736F72025O0034A840025O0050924003263O001E383274014102370A7B017F0034757B047B1F280A7908730422303D593E4512206F1E711F7803063O001E6D51551D6D025O00EC9E40025O00109E40025O0078B040025O00708940030A3O000AB6BC3B832D95CF34A403083O00A059C6D549EA59D7026O001040025O000EAF40025O00CCB140025O00789C40025O00488E40031B3O005B61BDECCC5C4EB6F1C84A31B2F7C05A688BFAC04578A7FB85192503053O00A52811D49E030A3O00D6C901212FF1FB073E2403053O004685B96853026O001840025O00709B40025O00549440025O00408A40025O00FCB040031B3O0017554D38C0107A4625C406054223CC165C7B2ECC094C572F89551303053O00A96425244A025O0070AD40025O00E7B140025O0093B14003073O00348FA7781589B603043O003060E7C203073O0054686548756E7403183O00DC520B1211CDA197885C07280BC19087CD57073E1C98FEDB03083O00E3A83A6E4D79B8CF025O007DB040025O0042B04000A6022O00122A3O00014O00CC000100023O002E6C0002009B02010002002O043O009D0201002619012O000800010003002O043O00080001002E6C0004009702010005002O043O009D0201000E560001000800010001002O043O0008000100122A000200013O002E8E0006000F00010007002O043O000F00010026190102001100010003002O043O00110001002E8E0008009C00010009002O043O009C000100122A000300014O00CC000400043O00268F0003001300010001002O043O0013000100122A000400013O00268F0004004500010003002O043O004500012O002D01056O004F000600013O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005002B00013O002O043O002B00012O002D010500023O00268F0005002B00010003002O043O002B00012O002D010500033O000E6A000D002B00010005002O043O002B00012O002D010500043O00060A0005002F00010001002O043O002F0001002E49000E002F0001000F002O043O002F0001002E8E0010004300010011002O043O004300012O002D010500054O003000065O00202O0006000600124O000700063O00202O0007000700134O000900076O0007000900024O000700076O00050007000200062O0005003E00010001002O043O003E0001002ECE0015003E00010014002O043O003E0001002E500017004300010016002O043O004300012O002D010500013O00122A000600183O00122A000700194O0096000500074O008B00055O00122A0002001A3O002O043O009C000100268F0004001600010001002O043O00160001002E50001B00630001001C002O043O006300012O002D01056O004F000600013O00122O0007001D3O00122O0008001E6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005006300013O002O043O006300012O002D010500083O0006DE0005006300013O002O043O006300012O002D010500093O0006DE0005005C00013O002O043O005C00012O002D0105000A3O00060A0005005F00010001002O043O005F00012O002D0105000A3O00060A0005006300010001002O043O006300012O002D0105000B4O002D0106000C3O0006720005006500010006002O043O00650001002E6C001F001200010020002O043O007500012O002D010500054O003C00065O00202O0006000600214O000700063O00202O0007000700134O000900076O0007000900024O000700076O00050007000200062O0005007500013O002O043O007500012O002D010500013O00122A000600223O00122A000700234O0096000500074O008B00056O002D01056O004F000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O0005000500264O00050002000200062O0005008200013O002O043O008200012O002D0105000D3O00060A0005008400010001002O043O00840001002E6C0027001600010028002O043O00980001002E8E002900910001002A002O043O009100012O002D010500054O003000065O00202O00060006002B4O000700063O00202O0007000700134O000900076O0007000900024O000700076O00050007000200062O0005009300010001002O043O00930001002E50002D00980001002C002O043O009800012O002D010500013O00122A0006002E3O00122A0007002F4O0096000500074O008B00055O00122A000400033O002O043O00160001002O043O009C0001002O043O00130001000E2F013000A200010002002O043O00A20001002E49003100A200010032002O043O00A20001002E8E003300252O010034002O043O00252O012O002D01036O004F000400013O00122O000500353O00122O000600366O0004000600024O00030003000400202O0003000300264O00030002000200062O000300C500013O002O043O00C500012O002D0103000E3O0006DE000300C500013O002O043O00C500012O002D0103000F3O00209D0003000300372O00AB00030002000200060A000300C500010001002O043O00C500012O002D010300093O0006DE000300BA00013O002O043O00BA00012O002D010300103O00060A000300BD00010001002O043O00BD00012O002D010300103O00060A000300C500010001002O043O00C500012O002D0103000B4O002D0104000C3O00062F000300C500010004002O043O00C500012O002D010300024O002D010400113O000672000400C700010003002O043O00C70001002E50003900FE00010038002O043O00FE0001002E50003A00E30001003B002O043O00E300012O002D010300124O007A000400013O00122O0005003C3O00122O0006003D6O00040006000200062O000300E300010004002O043O00E30001002E6C003E002E0001003E002O043O00FE00012O002D010300054O003C000400133O00202O00040004003F4O000500063O00202O0005000500134O000700076O0005000700024O000500056O00030005000200062O000300FE00013O002O043O00FE00012O002D010300013O0012EF000400403O00122O000500416O000300056O00035O00044O00FE00012O002D010300124O000D010400013O00122O000500423O00122O000600436O00040006000200062O000300EC00010004002O043O00EC0001002E8E004400FE00010045002O043O00FE0001002E50004600FE00010047002O043O00FE00012O002D010300054O00AF000400133O00202O0004000400484O000500063O00202O00050005004900122O0007004A6O0005000700024O000500056O00030005000200062O000300FE00013O002O043O00FE00012O002D010300013O00122A0004004B3O00122A0005004C4O0096000300054O008B00036O002D01036O004F000400013O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300A502013O002O043O00A502012O002D0103000F3O00209D00030003004F2O00AB000300020002002617010300A50201004A002O043O00A502012O002D010300143O00060A000300A502010001002O043O00A502012O002D010300153O0006DE000300A502013O002O043O00A50201002E50005100A502010050002O043O00A502012O002D010300054O007400045O00202O0004000400524O000500166O000500056O00030005000200062O0003001F2O010001002O043O001F2O01002E50005300A502010054002O043O00A502012O002D010300013O0012EF000400553O00122O000500566O000300056O00035O00044O00A50201002619010200292O010001002O043O00292O01002E8E0058000B02010057002O043O000B020100122A000300013O0026190103002E2O010003002O043O002E2O01002E50005900782O01005A002O043O00782O01002E8E005B00762O01005C002O043O00762O012O002D01046O004F000500013O00122O0006005D3O00122O0007005E6O0005000700024O00040004000500202O0004000400264O00040002000200062O000400762O013O002O043O00762O012O002D010400173O0006DE000400762O013O002O043O00762O012O002D01046O0025000500013O00122O0006005F3O00122O000700606O0005000700024O00040004000500202O0004000400614O0004000200024O000500186O00068O000700013O00122O000800623O00122O000900636O0007000900024O00060006000700202O0006000600644O0006000200024O0007000F3O00202O0007000700654O000700086O00053O00024O000600196O00078O000800013O00122O000900623O00122O000A00636O0008000A00024O00070007000800202O0007000700644O0007000200024O0008000F3O00202O0008000800654O000800096O00063O00024O00050005000600062O000400762O010005002O043O00762O012O002D0104000F3O00209D0004000400662O00AB00040002000200262B000400762O010067002O043O00762O01002E50006800762O010069002O043O00762O012O002D010400054O004200055O00202O00050005006A4O000600166O000600066O00040006000200062O000400762O013O002O043O00762O012O002D010400013O00122A0005006B3O00122A0006006C4O0096000400064O008B00045O00122A000200033O002O043O000B020100268F0003002A2O010001002O043O002A2O01002E50006D009D2O01006E002O043O009D2O01002E6C006F00210001006F002O043O009D2O012O002D01046O004F000500013O00122O000600703O00122O000700716O0005000700024O00040004000500202O0004000400264O00040002000200062O0004009D2O013O002O043O009D2O012O002D0104001A3O0006DE0004009D2O013O002O043O009D2O01002E500072009D2O010073002O043O009D2O012O002D010400054O003C00055O00202O0005000500744O000600063O00202O0006000600134O000800076O0006000800024O000600066O00040006000200062O0004009D2O013O002O043O009D2O012O002D010400013O00122A000500753O00122A000600764O0096000400064O008B00045O002E8E0078000902010077002O043O000902012O002D01046O004F000500013O00122O000600793O00122O0007007A6O0005000700024O00040004000500202O0004000400264O00040002000200062O0004000902013O002O043O000902012O002D0104001B3O0006DE0004000902013O002O043O000902012O002D0104000F3O00209D0004000400372O00AB00040002000200060A0004000902010001002O043O000902012O002D0104001C3O00060A000400BE2O010001002O043O00BE2O012O002D01046O001E010500013O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O00040004007D4O00040002000200062O0004000902010001002O043O000902012O002D010400063O00205800040004007E4O00065O00202O00060006007F4O00040006000200062O0004000902013O002O043O000902012O002D01046O001E010500013O00122O000600803O00122O000700816O0005000700024O00040004000500202O00040004007D4O00040002000200062O000400D82O010001002O043O00D82O012O002D0104001D4O000D010500013O00122O000600823O00122O000700836O00050007000200062O000400D82O010005002O043O00D82O01002E8E008400EB2O010085002O043O00EB2O012O002D010400054O0030000500133O00202O0005000500864O000600063O00202O0006000600134O000800076O0006000800024O000600066O00040006000200062O000400E52O010001002O043O00E52O01002E6C0087002600010088002O043O000902012O002D010400013O0012EF000500893O00122O0006008A6O000400066O00045O00044O00090201002E50008B00F52O01008C002O043O00F52O012O002D0104001D4O000D010500013O00122O0006008D3O00122O0007008E6O00050007000200062O000400F52O010005002O043O00F52O01002O043O00090201002E8E0090002O0201008F002O043O002O02012O002D010400054O000C010500133O00202O0005000500914O000600063O00202O00060006004900122O0008004A6O0006000800024O000600066O00040006000200062O0004000402010001002O043O00040201002E8E0092000902010093002O043O000902012O002D010400013O00122A000500943O00122A000600954O0096000400064O008B00045O00122A000300033O002O043O002A2O01000E2F011A000F02010002002O043O000F0201002E6C009600FEFD2O0097002O043O000B000100122A000300013O002E8E0099006602010098002O043O0066020100268F0003006602010001002O043O006602012O002D01046O004F000500013O00122O0006009A3O00122O0007009B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002A02013O002O043O002A02012O002D010400023O000E1D0103002A02010004002O043O002A02012O002D010400023O0026170104002A0201000D002O043O002A02012O002D010400033O000E6A009C002A02010004002O043O002A02012O002D010400043O00060A0004002C02010001002O043O002C0201002E6C009D00140001009E002O043O003E02012O002D010400054O003000055O00202O0005000500124O000600063O00202O0006000600134O000800076O0006000800024O000600066O00040006000200062O0004003902010001002O043O00390201002E50009F003E020100A0002O043O003E02012O002D010400013O00122A000500A13O00122A000600A24O0096000400064O008B00046O002D01046O004F000500013O00122O000600A33O00122O000700A46O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004005102013O002O043O005102012O002D010400023O000E6A00A5005102010004002O043O005102012O002D010400033O000E6A0030005102010004002O043O005102012O002D010400043O00060A0004005302010001002O043O00530201002E5000A60065020100A7002O043O006502012O002D010400054O003000055O00202O0005000500124O000600063O00202O0006000600134O000800076O0006000800024O000600066O00040006000200062O0004006002010001002O043O00600201002E5000A90065020100A8002O043O006502012O002D010400013O00122A000500AA3O00122A000600AB4O0096000400064O008B00045O00122A000300033O002E6C00AC00AAFF2O00AC002O043O00100201002E5000AE0010020100AD002O043O0010020100268F0003001002010003002O043O001002012O002D01046O004F000500013O00122O000600AF3O00122O000700B06O0005000700024O00040004000500202O0004000400264O00040002000200062O0004009602013O002O043O009602012O002D0104001E3O0006DE0004009602013O002O043O009602012O002D010400093O0006DE0004007F02013O002O043O007F02012O002D0104001F3O00060A0004008202010001002O043O008202012O002D0104001F3O00060A0004009602010001002O043O009602012O002D0104000B4O002D0105000C3O00062F0004009602010005002O043O009602012O002D010400054O00AF00055O00202O0005000500B14O000600063O00202O00060006004900122O0008004A6O0006000800024O000600066O00040006000200062O0004009602013O002O043O009602012O002D010400013O00122A000500B23O00122A000600B34O0096000400064O008B00045O00122A000200303O002O043O000B0001002O043O00100201002O043O000B0001002O043O00A50201002O043O00080001002O043O00A50201002E5000B50002000100B4002O043O0002000100268F3O000200010001002O043O0002000100122A000100014O00CC000200023O00122A3O00033O002O043O000200012O00CD3O00017O00B63O00028O00025O002CA140025O00249340025O0034A640025O00E3B240026O000840025O0042A840026O00F03F026O001040025O00DC9A40025O001AA94003083O002FBF3C701DB82F7603043O001369CD5D030A3O0049734361737461626C65030E3O008F0DD2A53ABF09CD953EBD01D18F03053O005FC968BEE1030F3O00432O6F6C646F776E52656D61696E73030E3O0089CECDEAAADDC0DDBBCAD5C7A0C503043O00AECFABA1030B3O004578656375746554696D65030A3O0047434452656D61696E7303043O0046757279026O004940025O00549640025O0006AE40025O0078A740025O007CA64003083O004672616374757265025O008AA440025O00CAA740025O00A3B140025O00B4B24003173O00EBEC0CF0ECC2FFFB4DFEF9DEE3EA08FDF9D9EEFB4DA2AC03063O00B78D9E6D9398025O0044A840025O0072A84003053O001F01E30D3E03043O006C4C6986030E3O00CDC0BDC5CBFDC4A2F5CFFFCCBEEF03053O00AE8BA5D181030E3O0085B6EEE5C315716BB7B2F6C8C90D03083O0018C3D382A1A6631003053O00536865617203143O00550BEC2D41564B02E02247134802E72F2O56175503063O00762663894C33025O00804740025O00489440027O0040025O0094A140025O0012B040025O00607040025O0061B040025O0020A740025O00C08A40030E3O0017987754F7B7A0CA348E6F56DDA103083O00B855ED1B3FB2CFD403073O0050726576474344030A3O00537069726974426F6D62025O00B09540025O00EEAA40025O00B2A640030E3O0042756C6B45787472616374696F6E031E3O000A4C0554375C114B1A580A4B0156071F055800511C5C075E065A0C1F590903043O003F683969025O00BAAE40026O007A4003083O002D82A8460786A04103043O00246BE7C4030B3O004675727944656669636974026O00444003083O0046656C626C616465025O00806F40025O00B8874003173O005BB0AE8551B4A6821DB8A38E53A1A7895CBBA1821DE4F003043O00E73DD5C2025O0002A640025O00088040025O00488740025O00EAA340025O0074A540025O00EDB240030A3O00969A0CDC7062878508CC03063O0016C5EA65AE1903073O0049735265616479026O001440030E3O004973496E4D656C2O6552616E6765025O00E08640025O00ECA34003193O003E24ACCE7FBBE8842239A79C7BAEDE883931ABDD78ACD2C67B03083O00E64D54C5BC16CFB7030E3O00D019CBF380A0E43CF61AE7E99EA003083O00559974A69CECC190025O0022A840025O00806440030E3O00492O6D6F6C6174696F6E41757261031D3O00ADED40BCE801B0E942BDDB01B1F24CF3E901ADEE59B6EA01AAE348F3BC03063O0060C4802DD384025O00BC9640025O00E4AE40025O00AEA240025O003EA440030A3O00E226243616E63D202A0B03053O006FA44F4144030A3O00446562752O66446F776E03103O0046696572794272616E64446562752O66030C3O00F5D084D722C5C0FF8FDF23EF03063O008AA6B9E3BE4E030C3O00F87DC23E5E0C1FED78C43A5703073O0079AB14A5573243030A3O00F537AC3A9A03D42EBC2403063O0062A658D956D9030A3O00C5F96C0DA5DDE4E07C1303063O00BC2O961961E6030E3O00FC8C532609FBDB9A4B0318E4D58703063O008DBAE93F626C030E3O00D7EF209220E7EB3FA224E5E323B803053O0045918A4CD6030C3O0054C09E87961856C38884BA0503063O007610AF2OE9DF030B3O004973417661696C61626C65030A3O00AD8D30A9F7A96F2O8A3103073O001DEBE455DB8EEB03103O0046752O6C526563686172676554696D65030A3O001BDDBFCF6E6C355333D003083O00325DB4DABD172E47025O00C06240030A3O0046696572794272616E64030E3O0049735370652O6C496E52616E676503193O00D8AD2O5E5DE34ACCA5554804D149D7AA4F494ADD46DDA11B1E03073O0028BEC43B2C24BC030C3O000F4CDBBDF6520B1A49DDB9FF03073O006D5C25BCD49A1D03083O0049734D6F76696E67025O00F2A840025O009CAD4003123O0027E0AAC0345410FDA5D7345E37E6A3CA3D4903063O003A648FC4A35103063O000A4E22BA3A5B03083O006E7A2243C35F2985025O00AC9240025O009C9440025O00ACAA40025O0096A14003123O00536967696C4F66466C616D65506C61796572025O00F07C40025O0046AB4003253O0066B85C43DA4ABE5D75D079B0564F9678B05244C270BF5A44D570F10F0A9E45BD5A53D367F803053O00B615D13B2A025O0018A04003063O00B442D70E2EAC03063O00DED737A57D41025O0008A640026O006C4003123O00536967696C4F66466C616D65437572736F7203093O004973496E52616E6765026O003E4003253O003FD8C1132OFEE24C13D7CA1BFFC4AD472DD8C80EF7CFEC442FD4864EB289CE5F3EC2C908BB03083O002A4CB1A67A92A18D025O002EAF40025O00CCA840025O005EAD40025O00C49040025O00A8A940025O00249C40025O0024AE40025O00C09B40030A3O00CE360C2O0034DF29081003063O00409D46657269026O001840031A3O0053B8AEF1195497A5EC1D42E8AAE2194EBCA2ED114EABA2A3411803053O007020C8C783025O0054AA40025O0072A940025O007BB040025O00CDB040030A3O001F5F49B4E0A7272D465903073O00424C303CD8A3CB030A3O00536F756C436C65617665025O0060AD40025O00206E40031A3O00A9896CFF60CD28BF876FF61FC325B3886DF651CF2AB98339A10F03073O0044DAE619933FAE00F1022O00122A3O00013O002E8E000300B400010002002O043O00B40001002E50000400B400010005002O043O00B4000100268F3O00B400010006002O043O00B4000100122A000100014O00CC000200023O002E6C00073O00010007002O043O0009000100268F0001000900010001002O043O0009000100122A000200013O00268F0002001200010008002O043O0012000100122A3O00093O002O043O00B40001000E560001000E00010002002O043O000E000100122A000300013O002E8E000A00AC0001000B002O043O00AC000100268F000300AC00010001002O043O00AC00012O002D01046O004F000500013O00122O0006000C3O00122O0007000D6O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004005000013O002O043O005000012O002D010400023O0006DE0004005000013O002O043O005000012O002D01046O0025000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O0004000200024O000500036O00068O000700013O00122O000800123O00122O000900136O0007000900024O00060006000700202O0006000600144O0006000200024O000700043O00202O0007000700154O000700086O00053O00024O000600056O00078O000800013O00122O000900123O00122O000A00136O0008000A00024O00070007000800202O0007000700144O0007000200024O000800043O00202O0008000800154O000800096O00063O00024O00050005000600062O0004005000010005002O043O005000012O002D010400043O00209D0004000400162O00AB0004000200020026ED0004005400010017002O043O00540001002E490019005400010018002O043O00540001002E8E001A00650001001B002O043O006500012O002D010400064O007400055O00202O00050005001C4O000600076O000600066O00040006000200062O0004006000010001002O043O00600001002ECE001E00600001001D002O043O00600001002E6C001F000700010020002O043O006500012O002D010400013O00122A000500213O00122A000600224O0096000400064O008B00045O002E8E002300AB00010024002O043O00AB00012O002D01046O004F000500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400AB00013O002O043O00AB00012O002D010400083O0006DE000400AB00013O002O043O00AB00012O002D01046O0025000500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O0004000400114O0004000200024O000500036O00068O000700013O00122O000800293O00122O0009002A6O0007000900024O00060006000700202O0006000600144O0006000200024O000700043O00202O0007000700154O000700086O00053O00024O000600056O00078O000800013O00122O000900293O00122O000A002A6O0008000A00024O00070007000800202O0007000700144O0007000200024O000800043O00202O0008000800154O000800096O00063O00024O00050005000600062O000400AB00010005002O043O00AB00012O002D010400043O00209D0004000400162O00AB00040002000200262B000400AB00010017002O043O00AB00012O002D010400064O004200055O00202O00050005002B4O000600076O000600066O00040006000200062O000400AB00013O002O043O00AB00012O002D010400013O00122A0005002C3O00122A0006002D4O0096000400064O008B00045O00122A000300083O00268F0003001500010008002O043O0015000100122A000200083O002O043O000E0001002O043O00150001002O043O000E0001002O043O00B40001002O043O00090001002E50002E00162O01002F002O043O00162O0100268F3O00162O010030002O043O00162O0100122A000100014O00CC000200023O002E8E003100BA00010032002O043O00BA000100268F000100BA00010001002O043O00BA000100122A000200013O00268F000200C300010008002O043O00C3000100122A3O00063O002O043O00162O01002E50003300BF00010034002O043O00BF000100268F000200BF00010001002O043O00BF0001002E50003600EF00010035002O043O00EF00012O002D01036O004F000400013O00122O000500373O00122O000600386O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300EF00013O002O043O00EF00012O002D010300093O0006DE000300EF00013O002O043O00EF00012O002D010300043O00207C00030003003900122O000500086O00065O00202O00060006003A4O00030006000200062O000300EF00013O002O043O00EF0001002E6C003B00110001003B002O043O00EF0001002E8E003D00EF0001003C002O043O00EF00012O002D010300064O004200045O00202O00040004003E4O000500076O000500056O00030005000200062O000300EF00013O002O043O00EF00012O002D010300013O00122A0004003F3O00122A000500404O0096000300054O008B00035O002E50004200122O010041002O043O00122O012O002D01036O004F000400013O00122O000500433O00122O000600446O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300122O013O002O043O00122O012O002D0103000A3O0006DE000300122O013O002O043O00122O012O002D010300043O00209D0003000300452O00AB000300020002000E6A004600122O010003002O043O00122O012O002D010300064O007400045O00202O0004000400474O000500076O000500056O00030005000200062O0003000D2O010001002O043O000D2O01002E50004900122O010048002O043O00122O012O002D010300013O00122A0004004A3O00122A0005004B4O0096000300054O008B00035O00122A000200083O002O043O00BF0001002O043O00162O01002O043O00BA0001002619012O001A2O010008002O043O001A2O01002E50004C00682O01004D002O043O00682O0100122A000100013O002E8E004E00632O01004F002O043O00632O0100268F000100632O010001002O043O00632O01002E8E005000432O010051002O043O00432O012O002D01026O004F000300013O00122O000400523O00122O000500536O0003000500024O00020002000300202O0002000200544O00020002000200062O000200432O013O002O043O00432O012O002D0102000B3O000E6A005500432O010002002O043O00432O012O002D0102000C3O0006DE000200432O013O002O043O00432O012O002D010200064O003000035O00202O00030003003A4O0004000D3O00202O0004000400564O0006000E6O0004000600024O000400046O00020004000200062O0002003E2O010001002O043O003E2O01002E8E005800432O010057002O043O00432O012O002D010200013O00122A000300593O00122A0004005A4O0096000200044O008B00026O002D01026O004F000300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O00020002000E4O00020002000200062O000200622O013O002O043O00622O012O002D0102000F3O0006DE000200622O013O002O043O00622O01002E50005E00622O01005D002O043O00622O012O002D010200064O003C00035O00202O00030003005F4O0004000D3O00202O0004000400564O0006000E6O0004000600024O000400046O00020004000200062O000200622O013O002O043O00622O012O002D010200013O00122A000300603O00122A000400614O0096000200044O008B00025O00122A000100083O00268F0001001B2O010008002O043O001B2O0100122A3O00303O002O043O00682O01002O043O001B2O01002E8E0062008C02010063002O043O008C020100268F3O008C02010001002O043O008C020100122A000100014O00CC000200023O00268F0001006E2O010001002O043O006E2O0100122A000200013O00268F0002008102010001002O043O00810201002E500064002B02010065002O043O002B02012O002D01036O004F000400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003002B02013O002O043O002B02012O002D010300103O0006DE0003002B02013O002O043O002B02012O002D0103000D3O0020580003000300684O00055O00202O0005000500694O00030005000200062O000300E92O013O002O043O00E92O012O002D01036O0078000400013O00122O0005006A3O00122O0006006B6O0004000600024O00030003000400202O0003000300114O0003000200024O00048O000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O0004000400144O0004000200024O000500043O00202O0005000500154O0005000200024O00040004000500062O0003001802010004002O043O001802012O002D01036O0088000400013O00122O0005006E3O00122O0006006F6O0004000600024O00030003000400202O0003000300114O0003000200024O000400036O00058O000600013O00122O000700703O00122O000800716O0006000800024O00050005000600202O0005000500144O0005000200024O000600043O00202O0006000600154O000600076O00043O00024O000500056O00068O000700013O00122O000800703O00122O000900716O0007000900024O00060006000700202O0006000600144O0006000200024O000700043O00202O0007000700154O000700086O00053O00024O00040004000500062O0003001802010004002O043O001802012O002D01036O0088000400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O0003000300114O0003000200024O000400036O00058O000600013O00122O000700743O00122O000800756O0006000800024O00050005000600202O0005000500144O0005000200024O000600043O00202O0006000600154O000600076O00043O00024O000500056O00068O000700013O00122O000800743O00122O000900756O0007000900024O00060006000700202O0006000600144O0006000200024O000700043O00202O0007000700154O000700086O00053O00024O00040004000500062O0003001802010004002O043O001802012O002D01036O004F000400013O00122O000500763O00122O000600776O0004000600024O00030003000400202O0003000300784O00030002000200062O0003002B02013O002O043O002B02012O002D01036O0026010400013O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O00030003007B4O0003000200024O000400036O00058O000600013O00122O0007007C3O00122O0008007D6O0006000800024O00050005000600202O0005000500144O0005000200024O000600043O00202O0006000600154O000600076O00043O00024O000500056O00068O000700013O00122O0008007C3O00122O0009007D6O0007000900024O00060006000700202O0006000600144O0006000200024O000700043O00202O0007000700154O000700086O00053O00024O00040004000500062O0003002B02010004002O043O002B0201002E6C007E00130001007E002O043O002B02012O002D010300064O003700045O00202O00040004007F4O0005000D3O00202O0005000500804O00075O00202O00070007007F4O0005000700024O000500056O00030005000200062O0003002B02013O002O043O002B02012O002D010300013O00122A000400813O00122A000500824O0096000300054O008B00036O002D01036O004F000400013O00122O000500833O00122O000600846O0004000600024O00030003000400202O00030003000E4O00030002000200062O0003008002013O002O043O008002012O002D010300043O00209D0003000300852O00AB00030002000200060A0003008002010001002O043O00800201002E8E0086004D02010087002O043O004D02012O002D01036O001E010400013O00122O000500883O00122O000600896O0004000600024O00030003000400202O0003000300784O00030002000200062O0003004F02010001002O043O004F02012O002D010300114O000D010400013O00122O0005008A3O00122O0006008B6O00040006000200062O0003004F02010004002O043O004F0201002E8E008D00640201008C002O043O00640201002E50008F00800201008E002O043O008002012O002D010300064O0030000400123O00202O0004000400904O0005000D3O00202O0005000500564O0007000E6O0005000700024O000500056O00030005000200062O0003005E02010001002O043O005E0201002E6C0091002400010092002O043O008002012O002D010300013O0012EF000400933O00122O000500946O000300056O00035O00044O00800201002E8E0095006E0201004F002O043O006E02012O002D010300114O000D010400013O00122O000500963O00122O000600976O00040006000200062O0003006E02010004002O043O006E0201002O043O00800201002E500099008002010098002O043O008002012O002D010300064O00AF000400123O00202O00040004009A4O0005000D3O00202O00050005009B00122O0007009C6O0005000700024O000500056O00030005000200062O0003008002013O002O043O008002012O002D010300013O00122A0004009D3O00122A0005009E4O0096000300054O008B00035O00122A000200083O002E8E00A000850201009F002O043O008502010026190102008702010008002O043O00870201002E5000A100712O0100A2002O043O00712O0100122A3O00083O002O043O008C0201002O043O00712O01002O043O008C0201002O043O006E2O01002619012O009002010009002O043O00900201002E8E00A30001000100A4002O043O00010001002E8E00A600C3020100A5002O043O00C302012O002D2O016O004F000200013O00122O000300A73O00122O000400A86O0002000400024O00010001000200202O0001000100544O00010002000200062O000100C302013O002O043O00C302012O002D2O0100043O00209D0001000100452O00AB00010002000200262B000100C30201009C002O043O00C302012O002D2O0100133O000E6A003000A702010001002O043O00A702012O002D2O01000B3O000E65005500AD02010001002O043O00AD02012O002D2O0100133O000E6A00A900C302010001002O043O00C302012O002D2O01000B3O000E6A000900C302010001002O043O00C302012O002D2O0100143O00060A000100C302010001002O043O00C302012O002D2O01000C3O0006DE000100C302013O002O043O00C302012O002D2O0100064O003C00025O00202O00020002003A4O0003000D3O00202O0003000300564O0005000E6O0003000500024O000300036O00010003000200062O000100C302013O002O043O00C302012O002D2O0100013O00122A000200AA3O00122A000300AB4O0096000100034O008B00015O002E8E00AD00F0020100AC002O043O00F00201002E8E00AE00F0020100AF002O043O00F002012O002D2O016O004F000200013O00122O000300B03O00122O000400B16O0002000400024O00010001000200202O0001000100544O00010002000200062O000100F002013O002O043O00F002012O002D2O0100043O00209D0001000100452O00AB00010002000200262B000100F00201009C002O043O00F002012O002D2O01000B3O0026172O0100F002010006002O043O00F002012O002D2O0100143O00060A000100F002010001002O043O00F002012O002D2O0100153O0006DE000100F002013O002O043O00F002012O002D2O0100064O007400025O00202O0002000200B24O000300076O000300036O00010003000200062O000100E902010001002O043O00E90201002E5000B300F0020100B4002O043O00F002012O002D2O0100013O0012EF000200B53O00122O000300B66O000100036O00015O00044O00F00201002O043O000100012O00CD3O00017O00953O00028O00026O00F03F025O00D89840025O00B08F40025O00FAA240025O003C9240025O00B8AE40025O00E88D40025O00208440025O00149040025O0070A140025O00A3B240025O00309240025O001C9140025O00CC9C40025O0050B04003073O00992256642OA33E03053O00D6CD4A332C030A3O0049734361737461626C65025O00688540025O0075B240025O00F07F40025O002FB240025O002EAB40025O0094A240025O00B4A84003073O0054686548756E7403093O004973496E52616E6765026O003E4003183O00EE44E7C37FEF42F6BC64F342E5F072C558E3EE70FF58A2AE03053O00179A2C829C025O002AA040025O00FAB040030A3O0022A9B8A2151203B0A8BC03063O007371C6CDCE56025O0063B040025O005EA940030A3O00536F756C436172766572025O0062AD40025O006EA040031B3O009758EB56BB54FF489252EC1A975EF05D8852C14E8545F95F9017AA03043O003AE4379E030E3O00928CDC0A39BB34A79DD13A35A23B03073O0055D4E9B04E5CCD03073O004973526561647903113O00695784EE4F5B9CEB5C5DA9EC2O4D81F14203043O00822A38E8030B3O004973417661696C61626C65030E3O00D9A12BE8452BE2B002EF4132EFA603063O005F8AD5448320030C3O00083DB34D7F242F834F79252C03053O00164A48C123026O005F40025O00E06740030E3O0046656C4465766173746174696F6E030E3O004973496E4D656C2O6552616E6765031F3O002A7CE867287CF2593F6DE54C2576EA183F70EA5F207CDB4C2D6BE35D3839B203043O00384C1984027O0040025O0074B040025O00805840025O00B88440025O008AA140025O00708440025O0002A740030A3O001D442BD9721DF92F5D3B03073O009C4E2B5EB53171025O0084A240025O00CCB140025O00209940025O00D09740025O006CA340025O009CAA40030A3O00536F756C436C65617665031C3O0061E7D1AF34407577E9D2A64B50707CEFC8A634577860EFC1B74B122103073O00191288A4C36B23026O000840025O00108040025O000EA240025O0044A440025O00BC9640025O00288240025O00ACA540025O00C1B140025O0098B04003083O00865104EDB45617EB03043O008EC0236503083O00467261637475726503193O00D06728A0F399BE13966620ADE080A929C2743BA4E298EC478203083O0076B61549C387ECCC025O00EEAB40025O00849440025O006C9A4003053O003B341F411603073O009D685C7A20646D03053O00536865617203163O00B0AECACB2F679EA2ADA1C3CF02338CB9A4A3DB8A6C7103083O00CBC3C6AFAA5D47ED025O00D88740025O002FB040025O001C9340025O00E5B140025O006C9240025O001AA740025O00AAA340025O00C4B240025O00B08840025O00788540025O0015B040030A3O008EE831AAE450B8E632A303063O003CDD8744C6A7030D3O00C8B2FB9651DCEA9EF48643CFEB03063O00B98EDD98E322025O00B07140025O00D4A240025O00C4A340025O008C9E40025O00407240031C3O004BCA42F67C30FB5DC441FF0320FE56C25BFF7C27F64AC252EE0362A503073O009738A5379A2353025O00889C40025O00AEB040025O009C9840030D3O007BCDB235C65FCF8F23CC4CC4AE03053O00AF3EA1CB4603083O0049734D6F76696E67025O00789F40025O00405F4003063O002CD1C20A302E03053O00555CBDA373025O00309E4003133O00456C797369616E446563722O65506C6179657203273O002CA0292B20AD3E072DA9332A2CA9702B20A237342C9324393BAB352C69F42O7019A031212CBE7903043O005849CC50025O00C88B40025O00E2A240025O004DB040025O00349D4003063O002D96025526C803063O00BA4EE370264903133O00456C797369616E446563722O65437572736F72025O00D07740025O00F8AD4003273O00F95BE4465A7BF268F92O5068F952BD465A74FB5BF86A477BEE50F8411322BC1FDE404169F345B403063O001A9C379D3533030E3O00AADD1AFDBD468DCB02D8AC5983D603063O0030ECB876B9D803203O00E3B85B0FCB31F3BC4424CE20ECB25970DC3DEBBA5B35F020E4AF5035DB74B4ED03063O005485DD3750AF003C022O00122A3O00014O00CC000100023O00268F3O001100010001002O043O0011000100122A000300013O000E2F0102000900010003002O043O00090001002E8E0003000B00010004002O043O000B000100122A3O00023O002O043O00110001000E560001000500010003002O043O0005000100122A000100014O00CC000200023O00122A000300023O002O043O00050001002E500006000200010005002O043O0002000100268F3O000200010002002O043O00020001002E50000800D600010007002O043O00D6000100268F000100D600010001002O043O00D6000100122A000300014O00CC000400043O002E6C00093O00010009002O043O001B0001000E560001001B00010003002O043O001B000100122A000400013O0026190104002400010001002O043O00240001002E8E000B00850001000A002O043O0085000100122A000500013O002E6C000C00060001000C002O043O002B000100268F0005002B00010002002O043O002B000100122A000400023O002O043O00850001002E50000E00250001000D002O043O00250001000E2F2O01003100010005002O043O00310001002E8E001000250001000F002O043O002500012O002D01066O004F000700013O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600134O00060002000200062O0006004B00013O002O043O004B00012O002D010600023O0006DE0006004B00013O002O043O004B00012O002D010600033O0006DE0006004400013O002O043O004400012O002D010600043O00060A0006004700010001002O043O004700012O002D010600043O00060A0006004B00010001002O043O004B00012O002D010600054O002D010700063O0006720006004F00010007002O043O004F0001002ECE0015004F00010014002O043O004F0001002E6C0016001600010017002O043O00630001002E8E0019006300010018002O043O00630001002E6C001A00120001001A002O043O006300012O002D010600074O00AF00075O00202O00070007001B4O000800083O00202O00080008001C00122O000A001D6O0008000A00024O000800086O00060008000200062O0006006300013O002O043O006300012O002D010600013O00122A0007001E3O00122A0008001F4O0096000600084O008B00065O002E8E0020008300010021002O043O008300012O002D01066O004F000700013O00122O000800223O00122O000900236O0007000900024O00060006000700202O0006000600134O00060002000200062O0006007200013O002O043O007200012O002D010600093O00060A0006007400010001002O043O00740001002E6C0024001100010025002O043O008300012O002D010600074O007400075O00202O0007000700264O0008000A6O000800086O00060008000200062O0006007E00010001002O043O007E0001002E500027008300010028002O043O008300012O002D010600013O00122A000700293O00122A0008002A4O0096000600084O008B00065O00122A000500023O002O043O0025000100268F0004002000010002002O043O002000012O002D01056O004F000600013O00122O0007002B3O00122O0008002C6O0006000800024O00050005000600202O00050005002D4O00050002000200062O000500BF00013O002O043O00BF00012O002D0105000B3O0006DE000500BF00013O002O043O00BF00012O002D010500033O0006DE0005009A00013O002O043O009A00012O002D0105000C3O00060A0005009D00010001002O043O009D00012O002D0105000C3O00060A000500BF00010001002O043O00BF00012O002D010500054O002D010600063O00062F000500BF00010006002O043O00BF00012O002D01056O001E010600013O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O0005000500304O00050002000200062O000500C100010001002O043O00C100012O002D01056O004F000600013O00122O000700313O00122O000800326O0006000800024O00050005000600202O0005000500304O00050002000200062O000500BF00013O002O043O00BF00012O002D01056O001E010600013O00122O000700333O00122O000800346O0006000800024O00050005000600202O0005000500304O00050002000200062O000500C100010001002O043O00C10001002E50003600D100010035002O043O00D100012O002D010500074O003C00065O00202O0006000600374O000700083O00202O0007000700384O0009000D6O0007000900024O000700076O00050007000200062O000500D100013O002O043O00D100012O002D010500013O00122A000600393O00122A0007003A4O0096000500074O008B00055O00122A000100023O002O043O00D60001002O043O00200001002O043O00D60001002O043O001B00010026192O0100DC0001003B002O043O00DC0001002E49003C00DC0001003D002O043O00DC0001002E50003F00522O01003E002O043O00522O0100122A000300013O002E50004000062O010041002O043O00062O0100268F000300062O010002002O043O00062O012O002D01046O004F000500013O00122O000600423O00122O000700436O0005000700024O00040004000500202O00040004002D4O00040002000200062O000400F100013O002O043O00F100012O002D0104000E3O00060A000400F100010001002O043O00F100012O002D0104000F3O00060A000400F500010001002O043O00F50001002E60004400F500010045002O043O00F50001002E6C0046001100010047002O043O00042O01002E8E004800042O010049002O043O00042O012O002D010400074O004200055O00202O00050005004A4O0006000A6O000600066O00040006000200062O000400042O013O002O043O00042O012O002D010400013O00122A0005004B3O00122A0006004C4O0096000400064O008B00045O00122A0001004D3O002O043O00522O01000E56000100DD00010003002O043O00DD000100122A000400013O0026190104000D2O010002002O043O000D2O01002E8E004F000F2O01004E002O043O000F2O0100122A000300023O002O043O00DD0001002E50005100092O010050002O043O00092O01000E56000100092O010004002O043O00092O01002E8E005200312O010053002O043O00312O01002E50005500312O010054002O043O00312O012O002D01056O004F000600013O00122O000700563O00122O000800576O0006000800024O00050005000600202O0005000500134O00050002000200062O000500312O013O002O043O00312O012O002D010500103O0006DE000500312O013O002O043O00312O012O002D010500074O004200065O00202O0006000600584O0007000A6O000700076O00050007000200062O000500312O013O002O043O00312O012O002D010500013O00122A000600593O00122A0007005A4O0096000500074O008B00055O002E50005C004F2O01005B002O043O004F2O01002E6C005D001C0001005D002O043O004F2O012O002D01056O004F000600013O00122O0007005E3O00122O0008005F6O0006000800024O00050005000600202O0005000500134O00050002000200062O0005004F2O013O002O043O004F2O012O002D010500113O0006DE0005004F2O013O002O043O004F2O012O002D010500074O004200065O00202O0006000600604O0007000A6O000700076O00050007000200062O0005004F2O013O002O043O004F2O012O002D010500013O00122A000600613O00122A000700624O0096000500074O008B00055O00122A000400023O002O043O00092O01002O043O00DD00010026192O0100562O01004D002O043O00562O01002E500064005F2O010063002O043O005F2O012O002D010300124O00B60003000100022O00A8000200033O002E6C006500E200010065002O043O003B02010006DE0002003B02013O002O043O003B02012O00BF000200023O002O043O003B0201002E8E0067001500010066002O043O001500010026192O0100652O010002002O043O00652O01002E500068001500010069002O043O0015000100122A000300014O00CC000400043O00268F000300672O010001002O043O00672O0100122A000400013O0026190104006E2O010002002O043O006E2O01002E6C006A00330001006B002O043O009F2O01002E50006C008A2O01006D002O043O008A2O012O002D01056O004F000600013O00122O0007006E3O00122O0008006F6O0006000800024O00050005000600202O00050005002D4O00050002000200062O0005008A2O013O002O043O008A2O012O002D01056O004F000600013O00122O000700703O00122O000800716O0006000800024O00050005000600202O0005000500304O00050002000200062O0005008A2O013O002O043O008A2O012O002D0105000E3O00060A0005008A2O010001002O043O008A2O012O002D0105000F3O00060A0005008C2O010001002O043O008C2O01002E8E0073009D2O010072002O043O009D2O01002E8E0075009D2O010074002O043O009D2O01002E6C0076000F00010076002O043O009D2O012O002D010500074O004200065O00202O00060006004A4O0007000A6O000700076O00050007000200062O0005009D2O013O002O043O009D2O012O002D010500013O00122A000600773O00122A000700784O0096000500074O008B00055O00122A0001003B3O002O043O00150001002E6C007900CBFF2O0079002O043O006A2O0100268F0004006A2O010001002O043O006A2O0100122A000500013O00268F000500A82O010002002O043O00A82O0100122A000400023O002O043O006A2O0100268F000500A42O010001002O043O00A42O01002E50007B00090201007A002O043O000902012O002D01066O004F000700013O00122O0008007C3O00122O0009007D6O0007000900024O00060006000700202O0006000600134O00060002000200062O0006000902013O002O043O000902012O002D010600133O0006DE0006000902013O002O043O000902012O002D010600143O00209D00060006007E2O00AB00060002000200060A0006000902010001002O043O000902012O002D010600033O0006DE000600C42O013O002O043O00C42O012O002D010600153O00060A000600C72O010001002O043O00C72O012O002D010600153O00060A0006000902010001002O043O000902012O002D010600054O002D010700063O00062F0006000902010007002O043O000902012O002D010600164O002D010700173O00062F0007000902010006002O043O00090201002E8E008000EB2O01007F002O043O00EB2O012O002D010600184O007A000700013O00122O000800813O00122O000900826O00070009000200062O000600EB2O010007002O043O00EB2O01002E6C0083003100010083002O043O000902012O002D010600074O003C000700193O00202O0007000700844O000800083O00202O0008000800384O000A000D6O0008000A00024O000800086O00060008000200062O0006000902013O002O043O000902012O002D010600013O0012EF000700853O00122O000800866O000600086O00065O00044O00090201002E8E008700F72O010088002O043O00F72O01002E8E008A00F72O010089002O043O00F72O012O002D010600184O000D010700013O00122O0008008B3O00122O0009008C6O00070009000200062O000600F72O010007002O043O00F72O01002O043O000902012O002D010600074O000C010700193O00202O00070007008D4O000800083O00202O00080008001C00122O000A001D6O0008000A00024O000800086O00060008000200062O0006000402010001002O043O00040201002E8E008F00090201008E002O043O000902012O002D010600013O00122A000700903O00122A000800914O0096000600084O008B00066O002D01066O004F000700013O00122O000800923O00122O000900936O0007000900024O00060006000700202O00060006002D4O00060002000200062O0006003302013O002O043O003302012O002D0106000B3O0006DE0006003302013O002O043O003302012O002D010600033O0006DE0006001C02013O002O043O001C02012O002D0106000C3O00060A0006001F02010001002O043O001F02012O002D0106000C3O00060A0006003302010001002O043O003302012O002D010600054O002D010700063O00062F0006003302010007002O043O003302012O002D010600074O003C00075O00202O0007000700374O000800083O00202O0008000800384O000A000D6O0008000A00024O000800086O00060008000200062O0006003302013O002O043O003302012O002D010600013O00122A000700943O00122A000800954O0096000600084O008B00065O00122A000500023O002O043O00A42O01002O043O006A2O01002O043O00150001002O043O00672O01002O043O00150001002O043O003B0201002O043O000200012O00CD3O00017O00813O00028O00027O0040025O00E0A940025O0012A940025O00489240026O002O4003053O001EB3EB3B3F03043O005A4DDB8E030A3O0049734361737461626C65025O00609740025O0092A14003053O005368656172025O0050AA40025O00808740025O004AA740025O00D0744003123O00F50C24385E4769EB052D35730675E344706103073O001A866441592C67025O0034AE40030A3O00C2EC252F87FDE63135A103053O00C49183504303073O0049735265616479030A3O00536F756C436C65617665025O00989640025O00D2AD4003183O000DBF130427EB12B5071E1DA80DBD070414D71FBF03484AB803063O00887ED0666878025O008AA240025O004CB140025O00C07F40025O001CB240026O00F03F025O00B09440030A3O0049B32778A534699D7FAE03083O00EB1ADC5214E6551B025O00107A40025O0059B040030A3O00536F756C43617276657203183O009BAEFCCE4B8BA0FBD4719AE1FACF7584ADD6C37B8DE1B89203053O0014E8C189A2025O00C07640025O004CB340025O00307C40025O0060A240030A3O0011CFCCB4EE98357E2FDD03083O001142BFA5C687EC77026O001440025O00349540025O009EA540030A3O00537069726974426F6D62030E3O004973496E4D656C2O6552616E676503183O001CBFA701F6FC2OD300A2AC53ECE5EDDD0390AF1CFAA8BD8303083O00B16FCFCE739F888C025O00B2A140025O00508040025O00D09640025O0064AA40030A3O0036860518F7435A049F1503073O003F65E97074B42F030D3O00E534EE07EB33C718E117F920C603063O0056A35B8D7298030B3O004973417661696C61626C65025O0038B040025O00AC994003183O004004617F05500771722C564B677E3B5F074B7235564B252703053O005A336B141303083O00ABE284EC2998E28003053O005DED90E58F025O00F8AA40025O0078AB40025O00F4A540025O00EAA04003083O00467261637475726503153O0013E4F11A1F5307F3B00A064719FACF18044355A7A603063O0026759690796B03073O00DC25AC2O67B2D503083O00D8884DC92F12DCA1025O0055B240025O006CA64003073O0054686548756E7403093O004973496E52616E6765026O003E4003143O0039E42EE500C98C39AC38D709D08E12ED24DF488E03073O00E24D8C4BBA68BC025O00507640025O00C8AD40030E3O009FCBDC1B4AAFCFC32B4EADC7DF3103053O002FD9AEB05F03113O009BD27A0EB7576C2FAED8570CB5417135B003083O0046D8BD1662D23418030E3O00E9CBAC8CD6CED7A6A1DFDBD2A69403053O00B3BABFC3E7030C3O00DB2A0AEAF0311FC6F53017E003043O0084995F78025O0052AE40025O00889D40025O00889240030E3O0046656C4465766173746174696F6E031B3O002OB70212F3DFB6B0A11A2CE3D3AFBFF21D20F6D6AC8EB30128B78E03073O00C0D1D26E4D97BA030D3O00C50F3BFAF6C5EE2O27EAEDC1E503063O00A4806342899F03083O0049734D6F76696E67025O00C0A140025O0098AC40025O00508240025O0018834003063O001085E8A7059B03043O00DE60E98903133O00456C797369616E446563722O65506C61796572025O00DCA740025O00089E40025O00AAB240025O00C0584003233O00BCBFBE0C81F2FE86B7A21C9AF6F5F9A0AA1E84FFCFB8BCA25FDEB3B889BFA6068DE1B903073O0090D9D3C77FE89303063O00FB3A2C3BDA5703083O0024984F5E48B5256203133O00456C797369616E446563722O65437572736F72025O005DB040025O00BCA34003233O00D2D45E2CDED94900D3DD442DD2DD072CDAD94B33E8D9483A978E0777F4CD552CD8CA0E03043O005FB7B827030E3O00933AEB02519603A62BE6325D8F0C03073O0062D55F874634E0025O00A49F40025O0049B240031B3O00F8A6C54850FBB5C86440FFB7C0785ABEB0C47658F29CC87851BEFB03053O00349EC3A91700ED012O00122A3O00014O00CC000100013O000E2F0102000600013O002O043O00060001002E8E0003005200010004002O043O00520001002E8E0006001500010005002O043O001500012O002D01026O004F000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002001500013O002O043O001500012O002D010200023O00060A0002001700010001002O043O00170001002E50000B00280001000A002O043O002800012O002D010200034O007400035O00202O00030003000C4O000400046O000400046O00020004000200062O0002002300010001002O043O00230001002E49000D00230001000E002O043O00230001002E8E000F002800010010002O043O002800012O002D010200013O00122A000300113O00122A000400124O0096000200044O008B00025O002E6C0013002100010013002O043O004900012O002D01026O004F000300013O00122O000400143O00122O000500156O0003000500024O00020002000300202O0002000200164O00020002000200062O0002004900013O002O043O004900012O002D010200053O0026170102004900010002002O043O004900012O002D010200063O0006DE0002004900013O002O043O004900012O002D010200034O007400035O00202O0003000300174O000400046O000400046O00020004000200062O0002004400010001002O043O00440001002E6C0018000700010019002O043O004900012O002D010200013O00122A0003001A3O00122A0004001B4O0096000200044O008B00026O002D010200074O00B60002000100022O00A8000100023O00060A0001005000010001002O043O00500001002E8E001D00EC2O01001C002O043O00EC2O012O00BF000100023O002O043O00EC2O01002E50001E00E60001001F002O043O00E6000100268F3O00E600010020002O043O00E60001002E6C0021001E00010021002O043O007400012O002D01026O004F000300013O00122O000400223O00122O000500236O0003000500024O00020002000300202O0002000200094O00020002000200062O0002007400013O002O043O007400012O002D010200083O0006DE0002007400013O002O043O00740001002E500024007400010025002O043O007400012O002D010200034O004200035O00202O0003000300264O000400046O000400046O00020004000200062O0002007400013O002O043O007400012O002D010200013O00122A000300273O00122A000400284O0096000200044O008B00025O002E8E0029009A0001002A002O043O009A0001002E8E002B009A0001002C002O043O009A00012O002D01026O004F000300013O00122O0004002D3O00122O0005002E6O0003000500024O00020002000300202O0002000200164O00020002000200062O0002009A00013O002O043O009A00012O002D010200053O000E6A002F009A00010002002O043O009A00012O002D010200093O0006DE0002009A00013O002O043O009A0001002E500030009A00010031002O043O009A00012O002D010200034O003C00035O00202O0003000300324O0004000A3O00202O0004000400334O0006000B6O0004000600024O000400046O00020004000200062O0002009A00013O002O043O009A00012O002D010200013O00122A000300343O00122A000400354O0096000200044O008B00025O002E50003700C700010036002O043O00C70001002E50003800C700010039002O043O00C700012O002D01026O004F000300013O00122O0004003A3O00122O0005003B6O0003000500024O00020002000300202O0002000200164O00020002000200062O000200C700013O002O043O00C700012O002D01026O004F000300013O00122O0004003C3O00122O0005003D6O0003000500024O00020002000300202O00020002003E4O00020002000200062O000200C700013O002O043O00C700012O002D010200053O002617010200C700010002002O043O00C700012O002D010200063O0006DE000200C700013O002O043O00C70001002E8E004000C70001003F002O043O00C700012O002D010200034O004200035O00202O0003000300174O000400046O000400046O00020004000200062O000200C700013O002O043O00C700012O002D010200013O00122A000300413O00122A000400424O0096000200044O008B00026O002D01026O004F000300013O00122O000400433O00122O000500446O0003000500024O00020002000300202O0002000200094O00020002000200062O000200D400013O002O043O00D400012O002D0102000C3O00060A000200D600010001002O043O00D60001002E50004600E500010045002O043O00E50001002E8E004800E500010047002O043O00E500012O002D010200034O004200035O00202O0003000300494O000400046O000400046O00020004000200062O000200E500013O002O043O00E500012O002D010200013O00122A0003004A3O00122A0004004B4O0096000200044O008B00025O00122A3O00023O00268F3O000200010001002O043O000200012O002D01026O004F000300013O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200142O013O002O043O00142O012O002D0102000D3O0006DE000200142O013O002O043O00142O012O002D0102000E3O0006DE000200FB00013O002O043O00FB00012O002D0102000F3O00060A000200FE00010001002O043O00FE00012O002D0102000F3O00060A000200142O010001002O043O00142O012O002D010200104O002D010300113O00062F000200142O010003002O043O00142O01002E50004F00142O01004E002O043O00142O012O002D010200034O00AF00035O00202O0003000300504O0004000A3O00202O00040004005100122O000600526O0004000600024O000400046O00020004000200062O000200142O013O002O043O00142O012O002D010200013O00122A000300533O00122A000400544O0096000200044O008B00025O002E8E005500622O010056002O043O00622O012O002D01026O004F000300013O00122O000400573O00122O000500586O0003000500024O00020002000300202O0002000200164O00020002000200062O0002004E2O013O002O043O004E2O012O002D010200123O0006DE0002004E2O013O002O043O004E2O012O002D0102000E3O0006DE000200292O013O002O043O00292O012O002D010200133O00060A0002002C2O010001002O043O002C2O012O002D010200133O00060A0002004E2O010001002O043O004E2O012O002D010200104O002D010300113O00062F0002004E2O010003002O043O004E2O012O002D01026O001E010300013O00122O000400593O00122O0005005A6O0003000500024O00020002000300202O00020002003E4O00020002000200062O000200502O010001002O043O00502O012O002D01026O004F000300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O00020002003E4O00020002000200062O0002004E2O013O002O043O004E2O012O002D01026O001E010300013O00122O0004005D3O00122O0005005E6O0003000500024O00020002000300202O00020002003E4O00020002000200062O000200502O010001002O043O00502O01002E50005F00622O010060002O043O00622O01002E6C0061001200010061002O043O00622O012O002D010200034O003C00035O00202O0003000300624O0004000A3O00202O0004000400334O0006000B6O0004000600024O000400046O00020004000200062O000200622O013O002O043O00622O012O002D010200013O00122A000300633O00122A000400644O0096000200044O008B00026O002D01026O004F000300013O00122O000400653O00122O000500666O0003000500024O00020002000300202O0002000200094O00020002000200062O000200852O013O002O043O00852O012O002D010200143O0006DE000200852O013O002O043O00852O012O002D010200153O00209D0002000200672O00AB00020002000200060A000200852O010001002O043O00852O012O002D0102000E3O0006DE0002007A2O013O002O043O007A2O012O002D010200163O00060A0002007D2O010001002O043O007D2O012O002D010200163O00060A000200852O010001002O043O00852O012O002D010200104O002D010300113O00062F000200852O010003002O043O00852O012O002D010200174O002D010300183O000672000300892O010002002O043O00892O01002E49006900892O010068002O043O00892O01002E6C006A00370001006B002O043O00BE2O012O002D010200194O007A000300013O00122O0004006C3O00122O0005006D6O00030005000200062O000200A52O010003002O043O00A52O012O002D010200034O00300003001A3O00202O00030003006E4O0004000A3O00202O0004000400334O0006000B6O0004000600024O000400046O00020004000200062O0002009F2O010001002O043O009F2O01002E49006F009F2O010070002O043O009F2O01002E50007100BE2O010072002O043O00BE2O012O002D010200013O0012EF000300733O00122O000400746O000200046O00025O00044O00BE2O012O002D010200194O007A000300013O00122O000400753O00122O000500766O00030005000200062O000200BE2O010003002O043O00BE2O012O002D010200034O000C0103001A3O00202O0003000300774O0004000A3O00202O00040004005100122O000600526O0004000600024O000400046O00020004000200062O000200B92O010001002O043O00B92O01002E50007800BE2O010079002O043O00BE2O012O002D010200013O00122A0003007A3O00122A0004007B4O0096000200044O008B00026O002D01026O004F000300013O00122O0004007C3O00122O0005007D6O0003000500024O00020002000300202O0002000200164O00020002000200062O000200D82O013O002O043O00D82O012O002D010200123O0006DE000200D82O013O002O043O00D82O012O002D0102000E3O0006DE000200D12O013O002O043O00D12O012O002D010200133O00060A000200D42O010001002O043O00D42O012O002D010200133O00060A000200D82O010001002O043O00D82O012O002D010200104O002D010300113O000672000200DA2O010003002O043O00DA2O01002E8E007F00EA2O01007E002O043O00EA2O012O002D010200034O003C00035O00202O0003000300624O0004000A3O00202O0004000400334O0006000B6O0004000600024O000400046O00020004000200062O000200EA2O013O002O043O00EA2O012O002D010200013O00122A000300803O00122A000400814O0096000200044O008B00025O00122A3O00203O002O043O000200012O00CD3O00017O000A012O00028O00025O00649840025O00A8A440025O008C9340025O00449740026O00F03F025O00F08440025O00AC9B40030C3O004570696353652O74696E677303083O0001E69C29405435F003063O003A5283E85D2903083O009644D526553A824503063O005FE337B0753D03083O002B7B375FA216793003053O00CB781E432B030F3O00E43648DCD0F62C41C0DFD7294CE2DC03053O00B991452D8F027O0040026O004640025O008CA840025O00CC9640025O00907440025O00649C40025O00D8AF4003083O00E0BC3B13DAB7281403043O0067B3D94F03113O005FA419FC4C81AC46B608DC4E2O825FA51D03073O00C32AD77CB521EC03083O003E5C232A2CF60A4A03063O00986D39575E4503113O00ECC40F8AB0D451BAF7D60690AAC05DA3FC03083O00C899B76AC3DEB234025O00AAB140025O00406D40025O00BCA640025O00609140025O0010B240025O00D09840025O00188240025O00FCB140025O00F89F40025O007AB040025O00349140025O0026A040025O0070A340025O0050894003083O00B91A0DB2D584180A03053O00BCEA7F79C6030D3O002D2116B037271FA0343712953D03043O00E358527303083O00701AAEB30B7D440C03063O0013237FDAC762030D3O0009E80FD10CF218EB08D905EF1E03043O00827C9B6A025O00BAB240025O00D8AB40025O00507040025O0020614003083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C030E3O005929E69A015E35F489054D33F5AB03053O00692C5A83CE03083O00CCE5A6AD0130F8F303063O005E9F80D2D968030C3O0045EA039C577EF6697EF610BE03083O001A309966DF3F1F99025O00805E40025O000AA740026O000840026O002040025O00688440025O008C9A4003083O0029182A0C3CFF230903073O00447A7D5E78559103133O001210D64DC1D8B43319CC4CCDDC891B15CB5BDA03073O00DA777CAF3EA8B903083O0096F55CD0ACFE4FD703043O00A4C5902803153O0085F9AF99C49491F1A48FF2B085F5A498D4A086FCB303063O00D6E390CAEBBD03083O00DEA0936F19BD542F03083O005C8DC5E71B70D33303183O00EBFA9EA2DCE9ED9AABDEF5F6998CD7E0FA84B0D8F0FA86BA03053O00B1869FEAC3025O0036AF40026O001040025O00A8A240025O00689D40025O0066AB40025O006AA34003083O00CC361D1E3BF6F82003063O00989F53696A5203103O0094D554D7C54592CF50FCED5982D454F703063O003CE1A63192A903083O001C1B3B3E0809280D03063O00674F7E4F4A6103113O00AF6CD6555B169E7AC5724D0EBB6BDA7C5003063O007ADA1FB3133E025O00ACA340025O00D4A740025O00288D40025O003AA840025O00E49E40025O005EA840025O00C7B240025O0020664003083O0080D3D9D5C0AF42A003073O0025D3B6ADA1A9C1030D3O00E22948EA276EB5D43B5FCF2D6903073O00D9975A2DB9481B03083O00F079F3065FCD7BF403053O0036A31C8772030A3O003DC858B6467A00CE539603063O001F48BB3DE22E026O001440025O0022A240025O00BCAA40026O001C40025O005AAD40025O0027B340025O009EAC40025O00F88A40025O00408B40025O007CB040025O00549540025O008EB04003083O00BE35EC3054EF8A2303063O0081ED5098443D030C3O0057A101E105354A50A600DB2C03073O003831C864937C7703083O00FF3BABE4C530B8E303043O0090AC5EDF030F3O00290AB6462900B0572C00B14E37279203043O0027446FC2025O0064AF40025O0052B240025O00C07040025O00CEAB4003083O00E5A3F3D370B9D1B503063O00D7B6C687A719030C3O009E40ED41817AEF5C9940E44F03043O0028ED298A03063O00D778FBE14FD503053O002AA7149A9803083O0079FBB656782F4DED03063O00412A9EC2221103143O001F2B4B1F24EC15CA1F24400928DE1EFA0E2E5C0B03083O008E7A47326C4D8D7B03063O0005AEFE013E0703053O005B75C29F78026O001840025O00D8A440025O00949F40025O00BC9940025O0058A840025O00807840025O00B8A040025O00B3B140025O0042A840025O002EAE40025O0065B240025O0096B14003083O00C022040B1315F43403063O007B9347707F7A030E3O00D9DE875543C1C28C4256C5C6876203053O0026ACADE21103083O007E1438FB441F2BFC03043O008F2D714C030D3O00ADAB191AB1BD0E259AAA1D32BC03043O005C2OD87C025O0006A940025O001AA140025O00789E40025O0006AE4003083O006837B854F45535BF03053O009D3B52CC2003103O002O2DE6D7ECFED2BC372CF3F2E6F9DAA203083O00D1585E839A898AB303083O001BA4D068172D363103083O004248C1A41C7E4351030D3O00E329A5572845F725A35D355ED703063O0016874CC83846025O00E88E40025O0095B040025O00E2A240025O00CEAC4003083O004B8FDA57A65C3A4203083O003118EAAE23CF325D03113O0019E1F8AA6400F9D890651EF3FE9C7803FC03053O00116C929DE803083O0078C600F926A64CD003063O00C82BA3748D4F030F3O00AA2538A0BFFAF0AA3B38AEB1F3EABC03073O0083DF565DE3D094025O00C2A240025O00EC9C40026O002E40025O00607840025O00649B40025O0074AB4003083O00D0402OA214BBE45603063O00D583252OD67D030B3O0033382099E42A2O29BEE52303053O0081464B45DF03083O0075CEE7FD75E141D803063O008F26AB93891C030B3O00C591BCD511E2D7C497ABF603073O00B4B0E2D9936383025O00189D40025O0028AD40025O0079B140025O00789A40025O00E2A340025O00D49A40025O000C9140025O004CA740025O001BB240025O00805D4003083O00B8DF21F28F1D371503083O0066EBBA5586E6735003103O00421F3B6C7BD32B5B23387C7AD52B591F03073O0042376C5E3F12B403083O00278891232E57139E03063O003974EDE5574703103O00BFA2E8D47EE94EA69EEBCA7EFD42B8A803073O0027CAD18D87178E03083O003145F9E70B4EEAE003043O009362208D030A3O000D50E6EE0F45590D53F703073O002B782383AA663603083O00670393A2ACBE834703073O00E43466E7D6C5D003113O000BF370F9E38C10DA31E646C3E68E17D51B03083O00B67E8015AA8AEB79025O00289340025O0040A940025O006AA040025O00D09B40025O0019B140025O00709E4003083O00F00357C64E7023D003073O0044A36623B2271E03133O00BB7CC3D40AB48D35BB73C8C206828A05B653FE03083O0071DE10BAA763D5E303083O001D0BEFE22700FCE503043O00964E6E9B03143O0083C02BC5A108BE5391C433E8AB10884991CD04C503083O0020E5A54781C47EDF026O008D40025O007FB040025O00C09440025O00609C40025O006EAD40025O00108640025O00B8A940025O000C974003083O00F08CD09588DBC49A03063O00B5A3E9A42OE103103O0043842B7B738A2C615599097E44831D5303043O001730EB5E03083O004FDFCC495E3DD56F03073O00B21CBAB83D3753030D3O00D0C54214E700E1F3C45334D12A03073O0095A4AD275C926E025O00689440025O00C8A1400008032O00122A3O00014O00CC000100013O002E500002000200010003002O043O00020001002619012O000800010001002O043O00080001002E500005000200010004002O043O0002000100122A000100013O0026192O01000D00010006002O043O000D0001002E6C0007005000010008002O043O005B000100122A000200013O00268F0002002900010006002O043O002900010012C8000300094O008A000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O00035O00122O000300096O000400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000300023O00122O000200123O00268F0002005200010001002O043O0052000100122A000300013O002E8E0013003400010014002O043O00340001002E8E0016003400010015002O043O0034000100268F0003003400010006002O043O0034000100122A000200063O002O043O005200010026190103003800010001002O043O00380001002E8E0018002C00010017002O043O002C00010012C8000400094O008A000500013O00122O000600193O00122O0007001A6O0005000700024O0004000400054O000500013O00122O0006001B3O00122O0007001C6O0005000700024O0004000400054O000400033O00122O000400096O000500013O00122O0006001D3O00122O0007001E6O0005000700024O0004000400054O000500013O00122O0006001F3O00122O000700206O0005000700024O0004000400054O000400043O00122O000300063O002O043O002C0001002E8E0022000E00010021002O043O000E0001002E500024000E00010023002O043O000E000100268F0002000E00010012002O043O000E000100122A000100123O002O043O005B0001002O043O000E0001002E50002600B100010025002O043O00B10001002E50002700B100010028002O043O00B1000100268F000100B100010012002O043O00B1000100122A000200013O002E8E002900660001002A002O043O006600010026190102006800010001002O043O00680001002E8E002C008D0001002B002O043O008D000100122A000300013O002E50002E00860001002D002O043O0086000100268F0003008600010001002O043O008600010012C8000400094O008A000500013O00122O0006002F3O00122O000700306O0005000700024O0004000400054O000500013O00122O000600313O00122O000700326O0005000700024O0004000400054O000400053O00122O000400096O000500013O00122O000600333O00122O000700346O0005000700024O0004000400054O000500013O00122O000600353O00122O000700366O0005000700024O0004000400054O000400063O00122O000300063O002E8E0038006900010037002O043O0069000100268F0003006900010006002O043O0069000100122A000200063O002O043O008D0001002O043O006900010026190102009100010006002O043O00910001002E8E003900AA0001003A002O043O00AA00010012C8000300094O008A000400013O00122O0005003B3O00122O0006003C6O0004000600024O0003000300044O000400013O00122O0005003D3O00122O0006003E6O0004000600024O0003000300044O000300073O00122O000300096O000400013O00122O0005003F3O00122O000600406O0004000600024O0003000300044O000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O000300083O00122O000200123O002619010200AE00010012002O043O00AE0001002E8E0044006200010043002O043O0062000100122A000100453O002O043O00B10001002O043O00620001000E2F014600B500010001002O043O00B50001002E8E004800DD00010047002O043O00DD00010012C8000200094O0025010300013O00122O000400493O00122O0005004A6O0003000500024O0002000200034O000300013O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300060A000200C300010001002O043O00C3000100122A000200014O000E000200093O0012B4000200096O000300013O00122O0004004D3O00122O0005004E6O0003000500024O0002000200034O000300013O00122O0004004F3O00122O000500506O0003000500022O00A20002000200032O000E0002000A3O0012C8000200094O00FF000300013O00122O000400513O00122O000500526O0003000500024O0002000200034O000300013O00122O000400533O00122O000500546O0003000500024O0002000200034O0002000B3O00044O00070301002E6C0055006200010055002O043O003F2O0100268F0001003F2O010056002O043O003F2O0100122A000200014O00CC000300033O00268F000200E300010001002O043O00E3000100122A000300013O000E2F2O0100EA00010003002O043O00EA0001002E8E005700112O010058002O043O00112O0100122A000400013O002619010400EF00010001002O043O00EF0001002E50005900082O01005A002O043O00082O010012C8000500094O008A000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500064O000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O0005000C3O00122O000500096O000600013O00122O0007005F3O00122O000800606O0006000800024O0005000500064O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O0005000D3O00122O000400063O002E8E0063000C2O010064002O043O000C2O010026190104000E2O010006002O043O000E2O01002E8E006600EB00010065002O043O00EB000100122A000300063O002O043O00112O01002O043O00EB0001002E8E006700382O010068002O043O00382O01002E50006A00382O010069002O043O00382O0100268F000300382O010006002O043O00382O0100122A000400013O00268F000400332O010001002O043O00332O010012C8000500094O008A000600013O00122O0007006B3O00122O0008006C6O0006000800024O0005000500064O000600013O00122O0007006D3O00122O0008006E6O0006000800024O0005000500064O0005000E3O00122O000500096O000600013O00122O0007006F3O00122O000800706O0006000800024O0005000500064O000600013O00122O000700713O00122O000800726O0006000800024O0005000500064O0005000F3O00122O000400063O00268F000400182O010006002O043O00182O0100122A000300123O002O043O00382O01002O043O00182O0100268F000300E600010012002O043O00E6000100122A000100733O002O043O003F2O01002O043O00E60001002O043O003F2O01002O043O00E30001002E50007400AD2O010075002O043O00AD2O01000E56007600AD2O010001002O043O00AD2O0100122A000200013O002E8E007700752O010078002O043O00752O01002E8E007A00752O010079002O043O00752O0100268F000200752O010001002O043O00752O0100122A000300013O002E50007B00512O01007C002O043O00512O0100268F000300512O010006002O043O00512O0100122A000200063O002O043O00752O01002E8E007D004B2O01007E002O043O004B2O0100268F0003004B2O010001002O043O004B2O010012C8000400094O0025010500013O00122O0006007F3O00122O000700806O0005000700024O0004000400054O000500013O00122O000600813O00122O000700826O0005000700024O00040004000500060A000400632O010001002O043O00632O0100122A000400014O000E000400103O00120F010400096O000500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000500013O00122O000600853O00122O000700866O0005000700024O00040004000500062O000400722O010001002O043O00722O0100122A000400014O000E000400113O00122A000300063O002O043O004B2O01002E8E0087007B2O010088002O043O007B2O0100268F0002007B2O010012002O043O007B2O0100122A000100463O002O043O00AD2O0100268F000200442O010006002O043O00442O0100122A000300013O00268F000300822O010006002O043O00822O0100122A000200123O002O043O00442O01002619010300862O010001002O043O00862O01002E6C008900FAFF2O008A002O043O007E2O010012C8000400094O0025010500013O00122O0006008B3O00122O0007008C6O0005000700024O0004000400054O000500013O00122O0006008D3O00122O0007008E6O0005000700024O00040004000500060A000400972O010001002O043O00972O012O002D010400013O00122A0005008F3O00122A000600904O00840004000600022O000E000400123O00120F010400096O000500013O00122O000600913O00122O000700926O0005000700024O0004000400054O000500013O00122O000600933O00122O000700946O0005000700024O00040004000500062O000400A92O010001002O043O00A92O012O002D010400013O00122A000500953O00122A000600964O00840004000600022O000E000400133O00122A000300063O002O043O007E2O01002O043O00442O010026192O0100B12O010097002O043O00B12O01002E500098000402010099002O043O0004020100122A000200014O00CC000300033O002E8E009A00B32O01009B002O043O00B32O01002619010200B92O010001002O043O00B92O01002E50009D00B32O01009C002O043O00B32O0100122A000300013O002619010300BE2O010012002O043O00BE2O01002E8E009E00C02O01009F002O043O00C02O0100122A000100763O002O043O00040201002E6C00A00004000100A0002O043O00C42O01002619010300C62O010001002O043O00C62O01002E6C00A1001B000100A2002O043O00DF2O010012C8000400094O008A000500013O00122O000600A33O00122O000700A46O0005000700024O0004000400054O000500013O00122O000600A53O00122O000700A66O0005000700024O0004000400054O000400143O00122O000400096O000500013O00122O000600A73O00122O000700A86O0005000700024O0004000400054O000500013O00122O000600A93O00122O000700AA6O0005000700024O0004000400054O000400153O00122O000300063O002E5000AC00E32O0100AB002O043O00E32O01000E2F010600E52O010003002O043O00E52O01002E8E00AE00BA2O0100AD002O043O00BA2O010012C8000400094O00C2000500013O00122O000600AF3O00122O000700B06O0005000700024O0004000400054O000500013O00122O000600B13O00122O000700B26O0005000700024O0004000400054O000400163O00122O000400096O000500013O00122O000600B33O00122O000700B46O0005000700024O0004000400054O000500013O00122O000600B53O00122O000700B66O0005000700024O00040004000500062O000400FF2O010001002O043O00FF2O0100122A000400014O000E000400173O00122A000300123O002O043O00BA2O01002O043O00040201002O043O00B32O01002E5000B70052020100B8002O043O0052020100268F0001005202010001002O043O0052020100122A000200014O00CC000300033O0026190102000E02010001002O043O000E0201002E5000BA000A020100B9002O043O000A020100122A000300013O00268F0003002A02010001002O043O002A02010012C8000400094O008A000500013O00122O000600BB3O00122O000700BC6O0005000700024O0004000400054O000500013O00122O000600BD3O00122O000700BE6O0005000700024O0004000400054O000400183O00122O000400096O000500013O00122O000600BF3O00122O000700C06O0005000700024O0004000400054O000500013O00122O000600C13O00122O000700C26O0005000700024O0004000400054O000400193O00122O000300063O002E8E00C40032020100C3002O043O00320201002E8E00C50032020100C6002O043O0032020100268F0003003202010012002O043O0032020100122A000100063O002O043O005202010026190103003602010006002O043O00360201002E5000C8000F020100C7002O043O000F02010012C8000400094O008A000500013O00122O000600C93O00122O000700CA6O0005000700024O0004000400054O000500013O00122O000600CB3O00122O000700CC6O0005000700024O0004000400054O0004001A3O00122O000400096O000500013O00122O000600CD3O00122O000700CE6O0005000700024O0004000400054O000500013O00122O000600CF3O00122O000700D06O0005000700024O0004000400054O0004001B3O00122O000300123O002O043O000F0201002O043O00520201002O043O000A02010026192O01005602010045002O043O00560201002E8E00D200A2020100D1002O043O00A2020100122A000200013O002E5000D4005F020100D3002O043O005F0201002E8E00D6005F020100D5002O043O005F020100268F0002005F02010012002O043O005F020100122A000100563O002O043O00A2020100268F0002008602010006002O043O0086020100122A000300013O0026190103006602010006002O043O00660201002E5000D80068020100D7002O043O0068020100122A000200123O002O043O008602010026190103006C02010001002O043O006C0201002E6C00D900F8FF2O00DA002O043O006202010012C8000400094O008A000500013O00122O000600DB3O00122O000700DC6O0005000700024O0004000400054O000500013O00122O000600DD3O00122O000700DE6O0005000700024O0004000400054O0004001C3O00122O000400096O000500013O00122O000600DF3O00122O000700E06O0005000700024O0004000400054O000500013O00122O000600E13O00122O000700E26O0005000700024O0004000400054O0004001D3O00122O000300063O002O043O0062020100268F0002005702010001002O043O005702010012C8000300094O008A000400013O00122O000500E33O00122O000600E46O0004000600024O0003000300044O000400013O00122O000500E53O00122O000600E66O0004000600024O0003000300044O0003001E3O00122O000300096O000400013O00122O000500E73O00122O000600E86O0004000600024O0003000300044O000400013O00122O000500E93O00122O000600EA6O0004000600024O0003000300044O0003001F3O00122O000200063O002O043O00570201002E5000EB00A6020100EC002O043O00A60201000E2F017300A802010001002O043O00A80201002E6C00ED0063FD2O00EE002O043O0009000100122A000200013O000E56001200AD02010002002O043O00AD020100122A000100973O002O043O00090001002619010200B102010001002O043O00B10201002E8E00EF00D4020100F0002O043O00D4020100122A000300013O00268F000300CD02010001002O043O00CD02010012C8000400094O008A000500013O00122O000600F13O00122O000700F26O0005000700024O0004000400054O000500013O00122O000600F33O00122O000700F46O0005000700024O0004000400054O000400203O00122O000400096O000500013O00122O000600F53O00122O000700F66O0005000700024O0004000400054O000500013O00122O000600F73O00122O000700F86O0005000700024O0004000400054O000400213O00122O000300063O002E8E00F900B2020100FA002O043O00B20201000E56000600B202010003002O043O00B2020100122A000200063O002O043O00D40201002O043O00B20201002E8E00FB00A9020100FC002O043O00A90201002E5000FE00A9020100FD002O043O00A9020100268F000200A902010006002O043O00A9020100122A000300013O002E8E2O0001F9020100FF002O043O00F9020100122A000400013O00068D000300F902010004002O043O00F902010012C8000400094O008A000500013O00122O0006002O012O00122O00070002015O0005000700024O0004000400054O000500013O00122O00060003012O00122O00070004015O0005000700024O0004000400054O000400223O00122O000400096O000500013O00122O00060005012O00122O00070006015O0005000700024O0004000400054O000500013O00122O00060007012O00122O00070008015O0005000700024O0004000400054O000400233O00122O000300063O00122A000400063O00066200032O0003010004002O044O00030100122A00040009012O00122A0005000A012O000669000500DB02010004002O043O00DB020100122A000200123O002O043O00A90201002O043O00DB0201002O043O00A90201002O043O00090001002O043O00070301002O043O000200012O00CD3O00017O00683O00028O00025O00A5B240025O00FC9440025O0077B240025O00049240027O0040025O005C9B40025O00E09740025O00688D40025O00ABB040025O00D89740025O00C09340026O00F03F030C3O004570696353652O74696E677303083O0012D8AE66062FDAA903053O006F41BDDA1203103O0056581E1D0E5DA34A451C050448A64C4503073O00CF232B7B556B3C026O000840025O0020AA40025O0048AB40025O00208E4003083O0030D536B2810DD73103053O00E863B042C6030E3O00F83321087088ED3FDB283C0E58A903083O004C8C4148661BED9903083O0079DF02C6DE0FB95903073O00DE2ABA76B2B761030E3O0048FF41A258ED489E55FF508553E903043O00EA3D8C24026O00104003083O002DC4B4F0B47C19D203063O00127EA1C084DD03113O007729A0002O5A01A007594D38A116535E2403053O00363F48CE64025O004CA540025O00E2B140025O006CAE40025O0058B14003083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC003113O00D88278373614DB867E362C35FD837A3C2903063O0046BEEB1F5F4203083O0089E70EF2ECB4E50903053O0085DA827A86030B3O0038F6F0D4D9AF1A29F9E5D703073O00585C9F83A4BCC3025O000FB240025O00E09B40025O00BAA040025O0012B34003083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B03113O0007F29E13D33CE99A02F627E88225D53BF203053O00A14E9CEA76025O00108140025O00BC9040025O00FDB040025O00B4B24003083O00E4EDB638DEE6A53F03043O004CB788C203113O0052E3E4345941134AE9F1315F413A7BEBE003073O00741A868558302F034O00025O00FEB240025O0072AC40025O00D6A240025O00C88F40025O0044A640025O00288F4003083O0043AFB4FE707EADB303053O001910CAC08A030D3O00F5CEACEEBDFCEEDFA2ECACDCCD03063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B1030F3O00851D1B4184161D7D820C134283302A03043O002DED787A025O0054B040025O0096B140025O00608440025O00289C40025O00A06240025O00E88B40025O0022AC40025O00B89A40025O00C49F40025O0068894003083O00101DCA3E212D4A3003073O002D4378BE4A4843030B3O003531E891EB81E0E22536FE03083O008940428DC599E88E025O00349040025O00489B40025O00888640025O00B4974003083O0094B2DDC8AEB9CECF03043O00BCC7D7A903163O00D5074B7EFAEE1C4F6FC7F205464CE0F51D5A77E1EF1D03053O00889C693F1B03083O0028896D2012827E2703043O00547BEC1903123O00D985BE12BEA7E59BBE23A4A7F598A218A0B103063O00D590EBCA77CC002A012O00122A3O00014O00CC000100013O002619012O000600010001002O043O00060001002E500002000200010003002O043O0002000100122A000100013O002E500005004800010004002O043O004800010026192O01000D00010006002O043O000D0001002E500007004800010008002O043O0048000100122A000200014O00CC000300033O002E500009000F0001000A002O043O000F000100268F0002000F00010001002O043O000F000100122A000300013O002E8E000C00260001000B002O043O0026000100268F000300260001000D002O043O002600010012C80004000E4O004D000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O00045O00122O000100133O00044O00480001002E6C001400EEFF2O0014002O043O001400010026190103002C00010001002O043O002C0001002E8E0015001400010016002O043O001400010012C80004000E4O008A000500013O00122O000600173O00122O000700186O0005000700024O0004000400054O000500013O00122O000600193O00122O0007001A6O0005000700024O0004000400054O000400023O00122O0004000E6O000500013O00122O0006001B3O00122O0007001C6O0005000700024O0004000400054O000500013O00122O0006001D3O00122O0007001E6O0005000700024O0004000400054O000400033O00122O0003000D3O002O043O00140001002O043O00480001002O043O000F000100268F000100570001001F002O043O005700010012C80002000E4O00FF000300013O00122O000400203O00122O000500216O0003000500024O0002000200034O000300013O00122O000400223O00122O000500236O0003000500024O0002000200034O000200043O00044O00292O0100268F0001009100010001002O043O0091000100122A000200013O0026190102006000010001002O043O00600001002E600024006000010025002O043O00600001002E500027007C00010026002O043O007C00010012C80003000E4O0025010400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400060A0003006E00010001002O043O006E000100122A000300014O000E000300053O0012640003000E6O000400013O00122O0005002C3O00122O0006002D6O0004000600024O0003000300044O000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000300063O00122O0002000D3O002619010200820001000D002O043O00820001002E600030008200010031002O043O00820001002E8E0033005A00010032002O043O005A00010012C80003000E4O004D000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000300073O00122O0001000D3O00044O00910001002O043O005A0001000E56001300DB00010001002O043O00DB000100122A000200013O002E8E0038009800010039002O043O00980001000E2F010D009A00010002002O043O009A0001002E8E003B00AB0001003A002O043O00AB00010012C80003000E4O0025010400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O000400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400060A000300A800010001002O043O00A8000100122A000300404O000E000300083O00122A0001001F3O002O043O00DB0001002619010200AF00010001002O043O00AF0001002E8E0041009400010042002O043O0094000100122A000300013O002E50004400D500010043002O043O00D50001002E50004600D500010045002O043O00D5000100268F000300D500010001002O043O00D500010012C80004000E4O0025010500013O00122O000600473O00122O000700486O0005000700024O0004000400054O000500013O00122O000600493O00122O0007004A6O0005000700024O00040004000500060A000400C400010001002O043O00C4000100122A000400014O000E000400093O00120F0104000E6O000500013O00122O0006004B3O00122O0007004C6O0005000700024O0004000400054O000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500062O000400D300010001002O043O00D3000100122A000400014O000E0004000A3O00122A0003000D3O000E56000D00B000010003002O043O00B0000100122A0002000D3O002O043O00940001002O043O00B00001002O043O00940001002E8E004F00DF00010050002O043O00DF00010026192O0100E10001000D002O043O00E10001002E500052000700010051002O043O0007000100122A000200014O00CC000300033O002619010200E900010001002O043O00E90001002E60005300E900010054002O043O00E90001002E50005500E300010056002O043O00E3000100122A000300013O002619010300EE0001000D002O043O00EE0001002E8E005700FC00010058002O043O00FC00010012C80004000E4O004D000500013O00122O000600593O00122O0007005A6O0005000700024O0004000400054O000500013O00122O0006005B3O00122O0007005C6O0005000700024O0004000400054O0004000B3O00122O000100063O00044O0007000100268F000300EA00010001002O043O00EA000100122A000400013O002E50005D00052O01005E002O043O00052O01000E56000D00052O010004002O043O00052O0100122A0003000D3O002O043O00EA0001002619010400092O010001002O043O00092O01002E8E006000FF0001005F002O043O00FF00010012C80005000E4O008A000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000600013O00122O000700633O00122O000800646O0006000800024O0005000500064O0005000C3O00122O0005000E6O000600013O00122O000700653O00122O000800666O0006000800024O0005000500064O000600013O00122O000700673O00122O000800686O0006000800024O0005000500064O0005000D3O00122O0004000D3O002O043O00FF0001002O043O00EA0001002O043O00070001002O043O00E30001002O043O00070001002O043O00292O01002O043O000200012O00CD3O00017O0031012O00028O00025O006FB240025O00FAA540025O0034AD40025O00D8AC40025O00B0AB40026O000840025O00DCAD40025O00B88940030C3O00497354616E6B696E67416F45026O00204003093O00497354616E6B696E67030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O0062B340025O0094A840025O00D4A440025O0072B34003103O00426F2O73466967687452656D61696E73026O00F03F025O00B07D40025O0032B040025O00405E40025O00206040025O00607040025O00709940025O000CB040024O0080B3C540030C3O00466967687452656D61696E73025O002EB240025O0014A040025O005EB34003113O0048616E646C65496E636F72706F7265616C03083O00496D707269736F6E03113O00496D707269736F6E4D6F7573656F766572026O003440025O007C9B40030C3O0049734368612O6E656C696E6703093O00497343617374696E67027O0040025O00B6B040025O00E88E40025O00BFB140025O00607640025O004C9F40030C3O00DD38F8A4F1B7FB1AF7B0EDB903063O00DA9E5796D784030B3O004973417661696C61626C65030C3O00D811D7F1232FC8D61FDEEB3503073O00AD9B7EB982564203073O004973526561647903103O00556E69744861734D6167696342752O66030C3O00436F6E73756D654D61676963030E3O0049735370652O6C496E52616E6765025O0006A440025O00FDB04003143O00E2B4BFC69CE9F799AAD29AEBE0E6BEC685EDE2A303063O008C85C6DAA7E8025O0080A240025O008AA540026O00AF40025O00B4A340025O0051B040025O00849240025O00B0A840025O00608940025O00389D40025O0062AE40025O000C9640025O00A8A240030E3O009C20B27896BB2FB84E90A727BF7803053O00E4D54ED41D030A3O0049734361737461626C65030E3O00AE42B000F9894DBA36FF9545BD0003053O008BE72CD66503113O00436861726765734672616374696F6E616C026O66FE3F030E3O00F0E1005B02BF301AEAFB14571BB403083O0076B98F663E70D15103113O0054696D6553696E63654C61737443617374025O00BC934003143O00496E6665726E616C537472696B65506C61796572030E3O004973496E4D656C2O6552616E676503163O00557E2FE3B71B1D342O633DF4AC1E1978517120E8E54703083O00583C104986C5757C030D3O007DEFECC94C5FF8E8C04E43E3EB03053O0021308A98A803083O0042752O66446F776E03113O004D6574616D6F7270686F73697342752O66030A3O00446562752O66446F776E03103O0046696572794272616E64446562752O66025O00F8AF40026O007D4003133O004D6574616D6F7270686F736973506C61796572025O0018A640025O0028A04003143O007F132450CC386006385ED23E61563D50C839324203063O005712765031A1025O006C9040025O0064B340025O00C4A740025O0084B040025O0023B340025O00BCA340026O001040025O00BAAB40025O00E9B140025O00609340025O0088A140025O00A3B240025O00307C40025O0002B340025O00A89940025O00807840025O00805840025O0052A240025O00AEA340025O00C9B040025O006C9340025O00E8A640025O003BB140025O00E06440025O006CB140025O00C8AD40025O0012A840025O0036AC40025O0011B340025O0016A140025O00D2AD40026O001440025O00C07A40025O00C88E40025O00805940025O0010A740025O00F88F40025O00508140025O0034AB40025O00949B40025O00B49240025O00D4B040025O0030A440025O006AA640025O00CC9840025O00C06F40025O0062B040030E3O00E7F08931E1A8D3D2E18401EDB1DC03073O00B2A195E57584DE030F3O00432O6F6C646F776E52656D61696E73030A3O00BBD4C8A0821AA3229EDE03083O0043E8BBBDCCC176C6030B3O004578656375746554696D65030A3O0047434452656D61696E7303043O0046757279026O004940025O00805240025O009AAB40030B3O00BF26A72F2C25E38A27A32503073O008FEB4ED5405B62030E3O0056616C75654973496E412O72617903053O004E50434944025O0023B040025O00707C40030B3O005468726F77476C61697665032B3O008B4780ED75A4CD5C8BA964BE880882E571BB885BC4E67EF699408BFA75F68B4188FD78AFCD4C81E47FB89E03063O00D6ED28E48910025O00E49940025O00EEA940025O00308640025O0014AC40025O00707540025O00C49640030B3O00B1EBFDD6148189E2E6CF0603063O00C6E5838FB963025O00B4AF40025O00D4954003143O005468726F77476C616976654D6F7573656F76657203283O005783AC77549EE8675ECCBC7B54CCAE7F5081AD60119EAD725298E863549EE87E5E99BB765E9AAD6103043O001331ECC8025O00208D40025O00F4A340025O00409940025O00588F40025O00B0AC40025O00F88A40025O00509940025O00BEAD40025O00208340025O00E89040025O00BCA040025O00409A40025O00688740025O00709F40025O00A06A40025O00907340025O00788C40025O00A4B140025O004CA240025O008EA740025O0002A040025O00C4A240025O00EAAA40026O006440025O00BCAB40025O00E88240025O00608840025O00A06240025O00F4AA40030B3O006A17DFB2A9681BD7A9A34903053O00D02C7EBAC003103O00D113A1D40DDEDB4FF91E80C316E9CF4803083O002E977AC4A6749CA9030F3O0041757261416374697665436F756E74025O00B09240025O00807340025O009CAA40025O00C6A440025O00B88E40025O00C8A940025O002O9C40025O00188140025O006DB340025O00909540025O0007B340025O00A0A240025O00E08940025O00E08540025O00A07F40025O0010AC40025O0044AB40025O0022AE40025O00289E40030F3O0048616E646C65445053506F74696F6E025O00A88040025O00B08840025O00A08740025O00406D40025O0012AE40025O00C07140026O001840025O003AAC40025O0020A340025O00C49840025O00D4A540025O0004AF40025O00107240025O00C9B240025O00249F40025O009FB040025O00CC9040025O0018AB40025O00AEB240025O0060684003163O004163746976654D697469676174696F6E4E2O65646564025O00E88740025O00AAAB40025O0079B240025O00D6AE40025O00FC9140025O00949240025O00EC9B40025O00F2A140025O0048B040025O00D89A40025O0096A240025O002CA840025O00688040025O0010A640025O00D6AF40025O006DB240030F3O00141D3EEAD32938140AF1CF2D28003A03063O005F5D704E98BC025O0082A340025O00709E40026O00244003163O00476574456E656D696573496E4D656C2O6552616E6765025O0086AD40026O009740030C3O004570696353652O74696E677303073O002DE745B7361CFB03053O005A798822D02O033O00C40A4603043O007EA76E35030D3O004973446561644F7247686F7374025O00F08040025O0050B040025O0060A840025O00A8B140025O0086B140025O003EB240025O00A08540025O00F89740025O00AC9140025O00708340025O00049640025O0022A040025O00405240025O0010834003073O00FC56427DE97EDB03063O001BA839251A852O033O0022A57F03053O00B74DCA1CC803073O00233C8E0F1B369A03043O00687753E92O033O00F4F72203053O00239598474200A5042O00122A3O00014O00CC000100013O002E8E0003000200010002002O043O00020001002E8E0005000200010004002O043O0002000100268F3O000200010001002O043O0002000100122A000100013O002E6C000600AE03010006002O043O00B703010026192O01000F00010007002O043O000F0001002E50000800B703010009002O043O00B703012O002D010200013O00209D00020002000A00122A0004000B4O008400020004000200060A0002001900010001002O043O001900012O002D010200013O00209D00020002000C2O002D010400024O00840002000400022O000E00026O002D010200033O00204400020002000D2O00B600020001000200060A0002002600010001002O043O002600012O002D010200013O00209D00020002000E2O00AB00020002000200060A0002002600010001002O043O00260001002E6C000F003900010010002O043O005D000100122A000200014O00CC000300033O00268F0002002800010001002O043O0028000100122A000300013O00268F0003004800010001002O043O0048000100122A000400014O00CC000500053O00268F0004002F00010001002O043O002F000100122A000500013O0026190105003600010001002O043O00360001002E8E0012003F00010011002O043O003F00012O002D010600053O0020870006000600134O000700076O000800016O0006000800024O000600046O000600046O000600063O00122O000500143O0026190105004300010014002O043O00430001002E500016003200010015002O043O0032000100122A000300143O002O043O00480001002O043O00320001002O043O00480001002O043O002F00010026190103004E00010014002O043O004E0001002E490018004E00010017002O043O004E0001002E50001A002B00010019002O043O002B0001002E6C001B000F0001001B002O043O005D00012O002D010400063O00268F0004005D0001001C002O043O005D00012O002D010400053O00202701040004001D4O000500076O00068O0004000600024O000400063O00044O005D0001002O043O002B0001002O043O005D0001002O043O002800012O002D010200083O0006DE0002007F00013O002O043O007F000100122A000200014O00CC000300033O002E6C001E3O0001001E002O043O00620001000E2F2O01006800010002002O043O00680001002E50002000620001001F002O043O0062000100122A000300013O000E560001006900010003002O043O006900012O002D010400033O0020180104000400214O0005000A3O00202O0005000500224O0006000B3O00202O00060006002300122O000700246O0004000700024O000400093O002E2O0025000B00010025002O043O007F00012O002D010400093O0006DE0004007F00013O002O043O007F00012O002D010400094O00BF000400023O002O043O007F0001002O043O00690001002O043O007F0001002O043O006200012O002D010200033O00204400020002000D2O00B60002000100020006DE000200A404013O002O043O00A404012O002D010200013O00209D0002000200262O00AB00020002000200060A000200A404010001002O043O00A404012O002D010200013O00209D0002000200272O00AB00020002000200060A000200A404010001002O043O00A4040100122A000200014O00CC000300063O00268F000200AA03010028002O043O00AA0301002E8E002A009B00010029002O043O009B00010026190103009800010001002O043O00980001002E6C002B00050001002C002O043O009B000100122A000400014O00CC000500053O00122A000300143O00268F0003009200010014002O043O009200012O00CC000600063O002E6C002D00DE0001002D002O043O007C2O0100268F0004007C2O010014002O043O007C2O0100122A000700013O00268F0007000C2O010001002O043O000C2O012O002D0108000A4O004F0009000C3O00122O000A002E3O00122O000B002F6O0009000B00024O00080008000900202O0008000800304O00080002000200062O000800E200013O002O043O00E200012O002D0108000D3O0006DE000800E200013O002O043O00E200012O002D0108000A4O004F0009000C3O00122O000A00313O00122O000B00326O0009000B00024O00080008000900202O0008000800334O00080002000200062O000800E200013O002O043O00E200012O002D0108000E3O0006DE000800E200013O002O043O00E200012O002D010800013O00209D0008000800272O00AB00080002000200060A000800E200010001002O043O00E200012O002D010800013O00209D0008000800262O00AB00080002000200060A000800E200010001002O043O00E200012O002D010800033O0020440008000800342O002D010900024O00AB0008000200020006DE000800E200013O002O043O00E200012O002D0108000F4O00F30009000A3O00202O0009000900354O000A00023O00202O000A000A00364O000C000A3O00202O000C000C00354O000A000C00024O000A000A6O0008000A000200062O000800DD00010001002O043O00DD0001002E6C0037000700010038002O043O00E200012O002D0108000C3O00122A000900393O00122A000A003A4O00960008000A4O008B00086O002D01085O00060A000800E700010001002O043O00E70001002E6C000700260001003B002O043O000B2O0100122A000800014O00CC0009000A3O002619010800EF00010001002O043O00EF0001002ECE003D00EF0001003C002O043O00EF0001002E6C003E00050001003F002O043O00F2000100122A000900014O00CC000A000A3O00122A000800143O002E8E004000E900010041002O043O00E90001000E56001400E900010008002O043O00E90001002E8E004200F600010043002O043O00F6000100268F000900F600010001002O043O00F6000100122A000A00013O002E6C00443O00010044002O043O00FB000100268F000A00FB00010001002O043O00FB00012O002D010B00104O00B6000B000100022O00A80006000B3O0006DE0006000B2O013O002O043O000B2O012O00BF000600023O002O043O000B2O01002O043O00FB0001002O043O000B2O01002O043O00F60001002O043O000B2O01002O043O00E9000100122A000700143O002E50004500122O010046002O043O00122O0100268F000700122O010028002O043O00122O0100122A000400283O002O043O007C2O0100268F000700A300010014002O043O00A300012O002D0108000A4O004F0009000C3O00122O000A00473O00122O000B00486O0009000B00024O00080008000900202O0008000800494O00080002000200062O000800472O013O002O043O00472O012O002D010800113O00060A0008002B2O010001002O043O002B2O012O002D0108000A4O001B0109000C3O00122O000A004A3O00122O000B004B6O0009000B00024O00080008000900202O00080008004C4O000800020002000E2O004D00472O010008002O043O00472O012O002D0108000A4O001B0109000C3O00122O000A004E3O00122O000B004F6O0009000B00024O00080008000900202O0008000800504O000800020002000E2O002800472O010008002O043O00472O01002E6C0051001200010051002O043O00472O012O002D0108000F4O003C0009000B3O00202O0009000900524O000A00023O00202O000A000A00534O000C00126O000A000C00024O000A000A6O0008000A000200062O000800472O013O002O043O00472O012O002D0108000C3O00122A000900543O00122A000A00554O00960008000A4O008B00086O002D010800134O002D010900063O00062F000800692O010009002O043O00692O012O002D0108000A4O004F0009000C3O00122O000A00563O00122O000B00576O0009000B00024O00080008000900202O0008000800494O00080002000200062O000800692O013O002O043O00692O012O002D010800143O0006DE000800692O013O002O043O00692O012O002D010800153O0006DE000800692O013O002O043O00692O012O002D010800013O0020580008000800584O000A000A3O00202O000A000A00594O0008000A000200062O000800692O013O002O043O00692O012O002D010800023O00203400080008005A4O000A000A3O00202O000A000A005B4O0008000A000200062O0008006B2O010001002O043O006B2O01002E6C005C00110001005D002O043O007A2O012O002D0108000F4O00740009000B3O00202O00090009005E4O000A00166O000A000A6O0008000A000200062O000800752O010001002O043O00752O01002E50005F007A2O010060002O043O007A2O012O002D0108000C3O00122A000900613O00122A000A00624O00960008000A4O008B00085O00122A000700283O002O043O00A30001002619010400802O010007002O043O00802O01002E500064001202010063002O043O0012020100122A000700014O00CC000800083O002E50006500822O010066002O043O00822O0100268F000700822O010001002O043O00822O0100122A000800013O0026190108008B2O010028002O043O008B2O01002E8E0067008D2O010068002O043O008D2O0100122A000400693O002O043O0012020100268F000800A62O010001002O043O00A62O0100122A000900013O002E50006A00962O01006B002O043O00962O0100268F000900962O010014002O043O00962O0100122A000800143O002O043O00A62O01002E8E006C00902O01006D002O043O00902O01002E6C006E00F8FF2O006E002O043O00902O0100268F000900902O010001002O043O00902O012O002D010A00174O00B6000A000100022O00A80006000A3O00060A000600A32O010001002O043O00A32O01002E50007000A42O01006F002O043O00A42O012O00BF000600023O00122A000900143O002O043O00902O01000E2F011400AA2O010008002O043O00AA2O01002E8E007100872O010072002O043O00872O012O002D010900183O000E36001400D12O010009002O043O00D12O01002E8E007400B02O010073002O043O00B02O01002O043O00D12O0100122A000900014O00CC000A000B3O002E6C0075001700010075002O043O00C92O01002E50007700C92O010076002O043O00C92O0100268F000900C92O010014002O043O00C92O01002E8E007800B82O010079002O043O00B82O01002E8E007A00B82O01007B002O043O00B82O0100268F000A00B82O010001002O043O00B82O012O002D010C00194O00B6000C000100022O00A8000B000C3O00060A000B00C52O010001002O043O00C52O01002E50007C00D12O01007D002O043O00D12O012O00BF000B00023O002O043O00D12O01002O043O00B82O01002O043O00D12O01002619010900CD2O010001002O043O00CD2O01002E50007F00B22O01007E002O043O00B22O0100122A000A00014O00CC000B000B3O00122A000900143O002O043O00B22O01002E500080000E02010081002O043O000E02012O002D010900183O000E1D0114000E02010009002O043O000E02012O002D010900183O0026170109000E02010082002O043O000E020100122A000900014O00CC000A000C3O002E8E0083000802010084002O043O0008020100268F0009000802010014002O043O000802012O00CC000C000C3O00268F000A00F12O010001002O043O00F12O0100122A000D00013O002619010D00E72O010014002O043O00E72O01002E50002900E92O010085002O043O00E92O0100122A000A00143O002O043O00F12O01002E8E008700E32O010086002O043O00E32O0100268F000D00E32O010001002O043O00E32O0100122A000B00014O00CC000C000C3O00122A000D00143O002O043O00E32O01002E8E008800F52O010089002O043O00F52O01002619010A00F72O010014002O043O00F72O01002E8E008A00E02O01008B002O043O00E02O01002619010B00FB2O010001002O043O00FB2O01002E8E008C00F72O01008D002O043O00F72O012O002D010D001A4O00B6000D000100022O00A8000C000D3O00060A000C002O02010001002O043O002O0201002E50008E000E0201008F002O043O000E02012O00BF000C00023O002O043O000E0201002O043O00F72O01002O043O000E0201002O043O00E02O01002O043O000E020100268F000900DB2O010001002O043O00DB2O0100122A000A00014O00CC000B000B3O00122A000900143O002O043O00DB2O0100122A000800283O002O043O00872O01002O043O00120201002O043O00822O0100268F000400CA02010001002O043O00CA020100122A000700013O000E2F2O01001902010007002O043O00190201002E500091007202010090002O043O007202012O002D0108000A4O00260109000C3O00122O000A00923O00122O000B00936O0009000B00024O00080008000900202O0008000800944O0008000200024O0009001C6O000A000A6O000B000C3O00122O000C00953O00122O000D00966O000B000D00024O000A000A000B00202O000A000A00974O000A000200024O000B00013O00202O000B000B00984O000B000C6O00093O00024O000A001D6O000B000A6O000C000C3O00122O000D00953O00122O000E00966O000C000E00024O000B000B000C00202O000B000B00974O000B000200024O000C00013O00202O000C000C00984O000C000D6O000A3O00024O00090009000A00062O0008004302010009002O043O004302012O002D010800013O00209D0008000800992O00AB0008000200020026ED000800440201009A002O043O004402012O00F400086O006E000800014O000E0008001B3O002E8E009B00710201009C002O043O007102012O002D0108000A4O004F0009000C3O00122O000A009D3O00122O000B009E6O0009000B00024O00080008000900202O0008000800494O00080002000200062O0008007102013O002O043O007102012O002D0108001E3O0006DE0008007102013O002O043O007102012O002D0108001F3O00203200080008009F4O000900206O000A00023O00202O000A000A00A04O000A000B6O00083O000200062O0008007102013O002O043O00710201002E5000A20071020100A1002O043O007102012O002D0108000F4O00370009000A3O00202O0009000900A34O000A00023O00202O000A000A00364O000C000A3O00202O000C000C00A34O000A000C00024O000A000A6O0008000A000200062O0008007102013O002O043O007102012O002D0108000C3O00122A000900A43O00122A000A00A54O00960008000A4O008B00085O00122A000700143O002E5000A60076020100A7002O043O007602010026190107007802010028002O043O00780201002E8E00A9007A020100A8002O043O007A020100122A000400143O002O043O00CA0201002E5000AA0015020100AB002O043O0015020100268F0007001502010014002O043O001502012O002D0108000A4O004F0009000C3O00122O000A00AC3O00122O000B00AD6O0009000B00024O00080008000900202O0008000800334O00080002000200062O000800A702013O002O043O00A702012O002D0108001E3O0006DE000800A702013O002O043O00A702012O002D0108001F3O00203200080008009F4O000900206O000A00213O00202O000A000A00A04O000A000B6O00083O000200062O000800A702013O002O043O00A70201002E8E00AF00A7020100AE002O043O00A702012O002D0108000F4O00370009000B3O00202O0009000900B04O000A00023O00202O000A000A00364O000C000A3O00202O000C000C00A34O000A000C00024O000A000A6O0008000A000200062O000800A702013O002O043O00A702012O002D0108000C3O00122A000900B13O00122A000A00B24O00960008000A4O008B00085O002E5000B300C8020100B4002O043O00C802012O002D010800013O00209D00080008000E2O00AB00080002000200060A000800C802010001002O043O00C802012O002D010800223O0006DE000800C802013O002O043O00C8020100122A000800014O00CC000900093O00268F000800B302010001002O043O00B3020100122A000900013O002619010900BA02010001002O043O00BA0201002E6C00B500FEFF2O00B6002O043O00B602012O002D010A00234O00B6000A000100022O00A80006000A3O00060A000600C302010001002O043O00C30201002E4900B700C3020100B8002O043O00C30201002E5000BA00C8020100B9002O043O00C802012O00BF000600023O002O043O00C80201002O043O00B60201002O043O00C80201002O043O00B3020100122A000700283O002O043O0015020100268F0004007C03010028002O043O007C030100122A000700014O00CC000800083O002E5000BB00CE020100BC002O043O00CE020100268F000700CE02010001002O043O00CE020100122A000800013O002E6C00BD0006000100BD002O043O00D9020100268F000800D902010028002O043O00D9020100122A000400073O002O043O007C030100268F0008006103010014002O043O0061030100122A000900013O00268F000900E002010014002O043O00E0020100122A000800283O002O043O00610301000E56000100DC02010009002O043O00DC02012O002D010A00134O002D010B00063O000643000B002F0001000A002O043O00140301002E5000BE00E9020100BF002O043O00E90201002O043O001403012O002D010A00243O0006DE000A00F502013O002O043O00F502012O002D010A00253O0006DE000A00F202013O002O043O00F202012O002D010A00263O00060A000A00F902010001002O043O00F902012O002D010A00263O0006DE000A00F902013O002O043O00F90201002ECE00C000F9020100C1002O043O00F90201002E5000C30014030100C2002O043O0014030100122A000A00014O00CC000B000B3O002E8E00C500FF020100C4002O043O00FF0201002619010A000103010001002O043O00010301002E8E00C600FB020100C7002O043O00FB020100122A000B00013O002619010B000603010001002O043O00060301002E6C00C800FEFF2O00C9002O043O000203012O002D010C00274O00B6000C000100022O00A80006000C3O002E8E00CA000D030100CB002O043O000D030100060A0006000F03010001002O043O000F0301002E6C00CC0007000100CD002O043O001403012O00BF000600023O002O043O00140301002O043O00020301002O043O00140301002O043O00FB0201002E5000CE005F030100CF002O043O005F03012O002D010A000A4O004F000B000C3O00122O000C00D03O00122O000D00D16O000B000D00024O000A000A000B00202O000A000A00304O000A0002000200062O000A005F03013O002O043O005F03012O002D010A000A4O001B010B000C3O00122O000C00D23O00122O000D00D36O000B000D00024O000A000A000B00202O000A000A00D44O000A00020002000E2O0014005F0301000A002O043O005F030100122A000A00014O00CC000B000D3O002E5000D60035030100D5002O043O00350301002619010A003203010001002O043O00320301002E5000D70035030100D8002O043O0035030100122A000B00014O00CC000C000C3O00122A000A00143O002E6C00C90004000100C9002O043O00390301002619010A003B03010014002O043O003B0301002E6C00D900F3FF2O00DA002O043O002C03012O00CC000D000D3O000E2F2O0100400301000B002O043O00400301002E8E00DB0043030100DC002O043O0043030100122A000C00014O00CC000D000D3O00122A000B00143O002E5000DE003C030100DD002O043O003C0301002E6C00DF00F7FF2O00DF002O043O003C0301000E560014003C0301000B002O043O003C0301002619010C004F03010001002O043O004F0301002ECE00E0004F030100E1002O043O004F0301002E5000E20049030100E3002O043O004903012O002D010E00284O00B6000E000100022O00A8000D000E3O002E6C00E4000D000100E4002O043O005F030100060A000D005803010001002O043O00580301002E8E00E6005F030100E5002O043O005F03012O00BF000D00023O002O043O005F0301002O043O00490301002O043O005F0301002O043O003C0301002O043O005F0301002O043O002C030100122A000900143O002O043O00DC020100268F000800D302010001002O043O00D3020100122A000900013O000E2F2O01006803010009002O043O00680301002E6C00E7000C000100E5002O043O007203012O002D010A00033O002044000A000A00E82O00B6000A000100022O00A80005000A3O002E6C00E90005000100E9002O043O007103010006DE0005007103013O002O043O007103012O00BF000500023O00122A000900143O0026190109007603010014002O043O00760301002E8E00EA0064030100EB002O043O0064030100122A000800143O002O043O00D30201002O043O00640301002O043O00D30201002O043O007C0301002O043O00CE0201002E5000EC009E000100ED002O043O009E0001002E6C00EE0020FD2O00EE002O043O009E000100268F0004009E00010069002O043O009E00012O002D010700183O00262B00070086030100EF002O043O00860301002O043O00A4040100122A000700014O00CC000800093O002E6C00F00017000100F0002O043O009F0301002E5000F2009F030100F1002O043O009F030100268F0007009F03010014002O043O009F0301002E5000F3008E030100E6002O043O008E0301002E5000F5008E030100F4002O043O008E030100268F0008008E03010001002O043O008E03012O002D010A00294O00B6000A000100022O00A80009000A3O002E5000F700A4040100F6002O043O00A404010006DE000900A404013O002O043O00A404012O00BF000900023O002O043O00A40401002O043O008E0301002O043O00A4040100268F0007008803010001002O043O0088030100122A000800014O00CC000900093O00122A000700143O002O043O00880301002O043O00A40401002O043O009E0001002O043O00A40401002O043O00920001002O043O00A40401000E56000100AF03010002002O043O00AF030100122A000300014O00CC000400043O00122A000200143O002619010200B303010014002O043O00B30301002E8E00F80090000100F9002O043O009000012O00CC000500063O00122A000200283O002O043O00900001002O043O00A4040100268F000100F203010028002O043O00F2030100122A000200013O002E6C00FA0006000100FA002O043O00C0030100268F000200C003010028002O043O00C0030100122A000100073O002O043O00F20301002619010200C403010014002O043O00C40301002E5000FB00CB030100FC002O043O00CB03012O002D0103002A4O007F0003000100014O000300013O00202O0003000300FD4O0003000200024O0003002B3O00122O000200283O002E8E00FE00BA030100FF002O043O00BA030100122A00032O00012O000E562O0001BA03010003002O043O00BA030100122A000300013O00068D000200BA03010003002O043O00BA030100122A000300013O00122A000400143O00068D000400D903010003002O043O00D9030100122A000200143O002O043O00BA030100122A000400013O000662000400E003010003002O043O00E0030100122A0004002O012O00122A00050002012O00062F000400D403010005002O043O00D4030100122A00040003012O00122A00050003012O00068D000400EB03010005002O043O00EB03012O002D0104002C3O0006DE000400EB03013O002O043O00EB03012O002D010400074O001C000400044O000E000400183O002O043O00ED030100122A000400144O000E000400184O002D0104002D4O002301040001000100122A000300143O002O043O00D40301002O043O00BA030100122A00020004012O00122A00030005012O0006690002004D04010003002O043O004D040100122A000200143O000662000100FD03010002002O043O00FD030100122A00020006012O00122A00030007012O0006690002004D04010003002O043O004D040100122A000200013O00122A000300143O0006620003000904010002002O043O0009040100122A00030008012O00122A00040009012O0006720004000904010003002O043O0009040100122A0003000A012O00122A0004000B012O00062F0004002404010003002O043O0024040100122A0003000C012O00122A0004000D012O0006690003001704010004002O043O001704012O002D0103000A4O001E0104000C3O00122O0005000E012O00122O0006000F015O0004000600024O00030003000400202O0003000300304O00030002000200062O0003001B04010001002O043O001B040100122A00030010012O00122A00040011012O0006690003001D04010004002O043O001D040100122A00030012013O000E000300124O002D010300013O0012AA00050013015O0003000300054O000500126O0003000500024O000300073O00122O000200283O00122A00030014012O00122A00040014012O00068D0003004304010004002O043O0043040100122A00030015012O00122A00040015012O00068D0003004304010004002O043O0043040100122A000300013O00068D0002004304010003002O043O004304010012C800030016013O00D70004000C3O00122O00050017012O00122O00060018015O0004000600024O0003000300044O0004000C3O00122O00050019012O00122O0006001A015O0004000600024O0003000300044O000300256O000300013O00122O0005001B015O0003000300054O00030002000200062O0003004204013O002O043O004204012O00CD3O00013O00122A000200143O00122A0003001C012O00122A0004001C012O00068D000300FE03010004002O043O00FE030100122A000300283O00068D000300FE03010002002O043O00FE030100122A000100283O002O043O004D0401002O043O00FE030100122A000200013O0006620001005404010002002O043O0054040100122A0002001D012O00122A0003001E012O00062F0002000900010003002O043O0009000100122A000200013O00122A000300013O00068D0002007704010003002O043O0077040100122A000300013O00122A0004001F012O00122A00050020012O00062F0005006004010004002O043O0060040100122A000400143O0006620003006404010004002O043O0064040100122A00040021012O00122A00050022012O0006690004006604010005002O043O0066040100122A000200143O002O043O0077040100122A00040023012O00122A00050024012O0006690005005904010004002O043O0059040100122A000400013O0006620003007104010004002O043O0071040100122A00040025012O00122A00050026012O00062F0005005904010004002O043O005904012O002D0104002E4O00230004000100014O0004002F6O00040001000100122O000300143O00044O0059040100122A000300143O0006620002008204010003002O043O0082040100122A00030027012O00122A0004001E3O0006620003008204010004002O043O0082040100122A00030028012O00122A00040029012O00068D0003009B04010004002O043O009B04010012C800030016013O008A0004000C3O00122O0005002A012O00122O0006002B015O0004000600024O0003000300044O0004000C3O00122O0005002C012O00122O0006002D015O0004000600024O0003000300044O000300223O00122O00030016015O0004000C3O00122O0005002E012O00122O0006002F015O0004000600024O0003000300044O0004000C3O00122O00050030012O00122O00060031015O0004000600024O0003000300044O0003002C3O00122O000200283O00122A000300283O00068D0002005504010003002O043O0055040100122A000100143O002O043O00090001002O043O00550401002O043O00090001002O043O00A40401002O043O000200012O00CD3O00017O000D3O00028O00025O00E09540025O00F89C40025O00E8B140025O005EA340025O0028A640025O002AAA4003053O005072696E7403353O00D3E8481DFEE4E3451FBBC1E84B15F5A5C55314EFE0FF0618E2A5C85613F8ABAD750FEBF5E2540EFEE1AD4403BBFDC64714FEF1E20803053O009B858D267A03103O000323A953565DB72O24A8654A7DB0232C03073O00C5454ACC212F1F03143O00526567697374657241757261547261636B696E6700213O00122A3O00014O00CC000100013O000E2F2O01000600013O002O043O00060001002E500003000200010002002O043O0002000100122A000100013O0026192O01000D00010001002O043O000D0001002ECE0004000D00010005002O043O000D0001002E8E0007000700010006002O043O000700012O002D01025O0020440002000200082O0031000300013O00122O000400093O00122O0005000A6O000300056O00023O00012O0021000200026O000300013O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000D4O00020002000100044O00200001002O043O00070001002O043O00200001002O043O000200012O00CD3O00017O00", GetFEnv(), ...);

