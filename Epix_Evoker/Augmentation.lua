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
				if (Enum <= 153) then
					if (Enum <= 76) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												local A = Inst[2];
												do
													return Unpack(Stk, A, A + Inst[3]);
												end
											else
												Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
											Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
											local A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
										else
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
										end
									elseif (Enum <= 11) then
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 12) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 15) then
									if (Enum > 14) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Env[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 16) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 17) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum == 19) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 21) then
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
										VIP = Inst[3];
									end
								elseif (Enum <= 24) then
									if (Enum == 23) then
										local A = Inst[2];
										Stk[A] = Stk[A]();
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									end
								elseif (Enum <= 25) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 26) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								end
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum <= 30) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 31) then
									if (Stk[Inst[2]] < Inst[4]) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 34) then
								if (Enum == 33) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 35) then
								local B = Inst[3];
								local K = Stk[B];
								for Idx = B + 1, Inst[4] do
									K = K .. Stk[Idx];
								end
								Stk[Inst[2]] = K;
							elseif (Enum == 36) then
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
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum == 38) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 40) then
										local B;
										local A;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 43) then
									if (Enum == 42) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 44) then
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
								elseif (Enum == 45) then
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum > 47) then
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								elseif (Enum <= 49) then
									Stk[Inst[2]] = not Stk[Inst[3]];
								elseif (Enum == 50) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 53) then
								if (Enum == 52) then
									local B;
									local A;
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 54) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							elseif (Enum == 55) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							if (Enum <= 61) then
								if (Enum <= 58) then
									if (Enum == 57) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 60) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 63) then
								if (Enum > 62) then
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
							elseif (Enum <= 64) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 65) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 71) then
							if (Enum <= 68) then
								if (Enum == 67) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
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
							elseif (Enum <= 69) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 70) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 73) then
							if (Enum == 72) then
								if (Inst[2] == Stk[Inst[4]]) then
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
						elseif (Enum <= 74) then
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
						elseif (Enum > 75) then
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
							A = Inst[2];
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
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 114) then
						if (Enum <= 95) then
							if (Enum <= 85) then
								if (Enum <= 80) then
									if (Enum <= 78) then
										if (Enum == 77) then
											Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
									end
								elseif (Enum <= 82) then
									if (Enum == 81) then
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
								elseif (Enum <= 83) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 84) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
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
							elseif (Enum <= 90) then
								if (Enum <= 87) then
									if (Enum == 86) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 88) then
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 89) then
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
									do
										return Stk[Inst[2]];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 92) then
								if (Enum == 91) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 93) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 94) then
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
							elseif (Inst[2] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 104) then
							if (Enum <= 99) then
								if (Enum <= 97) then
									if (Enum > 96) then
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
								elseif (Enum > 98) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 101) then
								if (Enum == 100) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 102) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum == 103) then
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
								Stk[Inst[2]] = Inst[3] ~= 0;
							end
						elseif (Enum <= 109) then
							if (Enum <= 106) then
								if (Enum == 105) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									local B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 107) then
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
							elseif (Enum == 108) then
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
						elseif (Enum <= 111) then
							if (Enum == 110) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 112) then
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
						elseif (Enum > 113) then
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 133) then
						if (Enum <= 123) then
							if (Enum <= 118) then
								if (Enum <= 116) then
									if (Enum == 115) then
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
								elseif (Enum == 117) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 120) then
								if (Enum == 119) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 121) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 122) then
								local B;
								local A;
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
								Stk[A] = Stk[A]();
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
						elseif (Enum <= 128) then
							if (Enum <= 125) then
								if (Enum > 124) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 126) then
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 127) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 130) then
							if (Enum == 129) then
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
								Env[Inst[3]] = Stk[Inst[2]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 131) then
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
						elseif (Enum > 132) then
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
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 143) then
						if (Enum <= 138) then
							if (Enum <= 135) then
								if (Enum == 134) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 136) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							elseif (Enum > 137) then
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
						elseif (Enum <= 140) then
							if (Enum == 139) then
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
						elseif (Enum <= 141) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 142) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 148) then
						if (Enum <= 145) then
							if (Enum == 144) then
								local B;
								local A;
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 146) then
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
						elseif (Enum == 147) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 150) then
						if (Enum > 149) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 151) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 152) then
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
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 230) then
					if (Enum <= 191) then
						if (Enum <= 172) then
							if (Enum <= 162) then
								if (Enum <= 157) then
									if (Enum <= 155) then
										if (Enum > 154) then
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
									elseif (Enum > 156) then
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
								elseif (Enum <= 159) then
									if (Enum == 158) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 160) then
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
								elseif (Enum > 161) then
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
									local Edx;
									local Results, Limit;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 167) then
								if (Enum <= 164) then
									if (Enum == 163) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 165) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 166) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 169) then
								if (Enum > 168) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								else
									local A;
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 170) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 171) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 181) then
							if (Enum <= 176) then
								if (Enum <= 174) then
									if (Enum > 173) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 175) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 178) then
								if (Enum == 177) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 179) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							elseif (Enum == 180) then
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
						elseif (Enum <= 186) then
							if (Enum <= 183) then
								if (Enum == 182) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								else
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum <= 184) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 185) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 188) then
							if (Enum > 187) then
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
						elseif (Enum <= 189) then
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
						elseif (Enum == 190) then
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 210) then
						if (Enum <= 200) then
							if (Enum <= 195) then
								if (Enum <= 193) then
									if (Enum > 192) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Inst[2] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 194) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
								else
									local B;
									local Edx;
									local Results, Limit;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 197) then
								if (Enum == 196) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 199) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum <= 205) then
							if (Enum <= 202) then
								if (Enum > 201) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 203) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 204) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 207) then
							if (Enum == 206) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 208) then
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
						elseif (Enum > 209) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 220) then
						if (Enum <= 215) then
							if (Enum <= 212) then
								if (Enum > 211) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								end
							elseif (Enum <= 213) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
							elseif (Enum > 214) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 217) then
							if (Enum > 216) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 218) then
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
						elseif (Enum > 219) then
							local B;
							local A;
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
							do
								return Stk[Inst[2]];
							end
						end
					elseif (Enum <= 225) then
						if (Enum <= 222) then
							if (Enum == 221) then
								local Edx;
								local Results, Limit;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 223) then
							VIP = Inst[3];
						elseif (Enum == 224) then
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
						end
					elseif (Enum <= 227) then
						if (Enum == 226) then
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 228) then
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
					elseif (Enum > 229) then
						local A = Inst[2];
						Stk[A](Stk[A + 1]);
					else
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					end
				elseif (Enum <= 269) then
					if (Enum <= 249) then
						if (Enum <= 239) then
							if (Enum <= 234) then
								if (Enum <= 232) then
									if (Enum > 231) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 233) then
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
								else
									local A;
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 236) then
								if (Enum > 235) then
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
							elseif (Enum <= 237) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Enum == 238) then
								if (Inst[2] < Stk[Inst[4]]) then
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
						elseif (Enum <= 244) then
							if (Enum <= 241) then
								if (Enum > 240) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 242) then
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
							elseif (Enum == 243) then
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
						elseif (Enum <= 246) then
							if (Enum > 245) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 247) then
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Enum > 248) then
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
					elseif (Enum <= 259) then
						if (Enum <= 254) then
							if (Enum <= 251) then
								if (Enum > 250) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 252) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum > 253) then
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
						elseif (Enum <= 256) then
							if (Enum == 255) then
								if (Stk[Inst[2]] == Inst[4]) then
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
									if (Mvm[1] == 63) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 257) then
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
						elseif (Enum == 258) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 264) then
						if (Enum <= 261) then
							if (Enum == 260) then
								if (Inst[2] ~= Inst[4]) then
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
						elseif (Enum <= 262) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 266) then
						if (Enum > 265) then
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
						end
					elseif (Enum <= 267) then
						local B;
						local A;
						A = Inst[2];
						Stk[A] = Stk[A]();
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						if (Inst[2] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 268) then
						local B;
						local A;
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
						Stk[A] = Stk[A]();
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
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 288) then
					if (Enum <= 278) then
						if (Enum <= 273) then
							if (Enum <= 271) then
								if (Enum > 270) then
									local Edx;
									local Results, Limit;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								else
									Stk[Inst[2]] = {};
								end
							elseif (Enum > 272) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							end
						elseif (Enum <= 275) then
							if (Enum == 274) then
								Stk[Inst[2]]();
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
						elseif (Enum <= 276) then
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
						elseif (Enum > 277) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
						end
					elseif (Enum <= 283) then
						if (Enum <= 280) then
							if (Enum == 279) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 281) then
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 282) then
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
					elseif (Enum <= 285) then
						if (Enum == 284) then
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
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						end
					elseif (Enum <= 286) then
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
						Stk[Inst[2]] = Inst[3] ~= 0;
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
						Stk[Inst[2]] = not Stk[Inst[3]];
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
					elseif (Enum > 287) then
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
				elseif (Enum <= 298) then
					if (Enum <= 293) then
						if (Enum <= 290) then
							if (Enum == 289) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 291) then
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
						elseif (Enum > 292) then
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
					elseif (Enum <= 295) then
						if (Enum > 294) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Env[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 296) then
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 297) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
					end
				elseif (Enum <= 303) then
					if (Enum <= 300) then
						if (Enum > 299) then
							do
								return Stk[Inst[2]]();
							end
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 301) then
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
					elseif (Enum == 302) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 305) then
					if (Enum > 304) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Stk[Inst[4]]];
					elseif (Inst[2] > Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 306) then
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
				elseif (Enum == 307) then
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
					do
						return;
					end
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD99ED111DAC6C91AC7AEC013D4CDCF24F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O00A4D658EAF67997C95AF7DB63A0D356FFCC5295C745FBC652CFCA44F303063O003CE1A63192A9002E3O0012543O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004DF3O000A00010012B6000300063O0020BF0004000300070012B6000500083O0020BF0005000500090012B6000600083O0020BF00060006000A00060001073O000100062O003F3O00064O003F8O003F3O00044O003F3O00014O003F3O00024O003F3O00053O0020BF00080003000B0020BF00090003000C2O000E010A5O0012B6000B000D3O000600010C0001000100022O003F3O000A4O003F3O000B4O003F000D00073O0012FE000E000E3O0012FE000F000F4O00E5000D000F0002000600010E0002000100032O003F3O00074O003F3O00094O003F3O00084O0025000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O008F00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00B700076O0029010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00B7000C00034O00BD000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00DE000C6O0066000A3O00020020BE000A000A00022O002F0009000A4O00C400073O00010004020003000500012O00B7000300054O003F000400024O00D8000300044O008800036O0034012O00017O00083O00028O00025O005AAC40025O001AB040026O00F03F025O0086A240025O00B8AA40025O0050A040025O00B6A240011C3O0012FE000200014O00C9000300033O00267E00020006000100010004DF3O00060001002E1901030010000100020004DF3O001000012O00B700046O00FC000300043O0006390003000F000100010004DF3O000F00012O00B7000400014O003F00056O007200066O001A00046O008800045O0012FE000200043O002E1500050014000100060004DF3O0014000100267E00020016000100040004DF3O00160001002E1901080002000100070004DF3O000200012O003F000400034O007200056O001A00046O008800045O0004DF3O000200012O0034012O00017O005B3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203093O00862B0525768AEDAE3603073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503063O00C856B541F94303043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C030A3O009643C5B4336320C4B75A03083O00A1DB36A9C05A305003043O006056052803043O004529226003053O0089D7DE061103063O004BDCA3B76A6203043O0021BB982303053O00B962DAEB57030D3O00E83D34F2FFA4C52O33E7CAAFCF03063O00CAAB5C4786BE030B3O000AC03F9C19CE238420CF2B03043O00E849A14C03053O0096D8414F1103053O007EDBB9223D03053O003CDC5B616D03083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D982O033O000903B403043O004B6776D903073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903043O0005E1AAC203043O00AE678EC5028O0003063O00733E5033204C03073O009836483F58453E030C3O00F5D1E951D1CAFA5DC0CDE15203043O003CB4A48E03063O007D480A2O22FF03073O0072383E6549478D030C3O0099FCDCC9BDE7CFC5ACE0D4CA03043O00A4D889BB03063O00F7F03EB9A3EC03073O006BB28651D2C69E030C3O00191B85CBAF361A83D2A3370003053O00CA586EE2A603073O00E0008FFAC5CD1C03053O00AAA36FE29703083O003426B72A5738271403073O00497150D2582E57030B3O00A723C306E88701CC15EE8203053O0087E14CAD72030B3O004973417661696C61626C65026O001040026O000840030B3O003CE2B6A4A3BB8A1BEAB1B303073O00C77A8DD8D0CCDD029A5O99E93F026O00F03F024O0080B3C54003093O0099DC19FC4BE1A4CD1503063O0096CDBD709018031B3O000685AC5844BC101929C48C5B0D9814506DADB158019A03053590F603083O007045E4DF2C64E871030A3O00E31609D4946980D21A1303073O00E6B47F67B3D61C031C3O00AF044C52A476E982021F64F147E689111F0ECD4FF489174D53F455A903073O0080EC653F26842103103O005265676973746572466F724576656E7403143O009C85307D93D9F09E8C366198D4EA8288336893CF03073O00AFCCC97124D68B030E3O00D5F5E811CAF6F21ECEE4E31AC3E103043O005D86A5AD03143O0092D7E0F014EB96418DC2E4EE16F19B5081C62OE003083O001EDE92A1A25AAED203063O0053657441504C025O0004974000BD013O006B000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F00122O001000046O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011001000114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012001000124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013001000134O00145O00122O001500203O00122O001600216O0014001600024O0014001000142O006300155O00122O001600223O00122O001700236O0015001700024O0015001000154O00165O00122O001700243O00122O001800256O0016001800022O00FC0016001000162O006300175O00122O001800263O00122O001900276O0017001900024O0016001600174O00175O00122O001800283O00122O001900296O0017001900022O00FC0016001600172O006300175O00122O0018002A3O00122O0019002B6O0017001900024O0017001000174O00185O00122O0019002C3O00122O001A002D6O0018001A00022O00C30017001700184O00185O00122O0019002E3O00122O001A002F6O0018001A00024O00170017001800122O001800306O00198O001A8O001B6O0068001C6O0068001D6O00C9001E00444O006300455O00122O004600313O00122O004700326O0045004700024O0045000C00454O00465O00122O004700333O00122O004800346O0046004800022O00FC0045004500462O006300465O00122O004700353O00122O004800366O0046004800024O0046000E00464O00475O00122O004800373O00122O004900386O0047004900022O00FC0046004600472O006300475O00122O004800393O00122O0049003A6O0047004900024O0047001400474O00485O00122O0049003B3O00122O004A003C6O0048004A00022O00FC0047004700482O000E01486O006300495O00122O004A003D3O00122O004B003E6O0049004B00024O0049001000494O004A5O00122O004B003F3O00122O004C00406O004A004C00022O002A00490049004A4O004A8O004B5O00122O004C00413O00122O004D00426O004B004D00024O004B0045004B00202O004B004B00434O004B0002000200062O004B00B000013O0004DF3O00B000010012FE004B00443O000639004B00B1000100010004DF3O00B100010012FE004B00454O00B7004C5O001210004D00463O00122O004E00476O004C004E00024O004C0045004C00202O004C004C00434O004C0002000200062O004C00BD00013O0004DF3O00BD00010012FE004C00483O000639004C00BE000100010004DF3O00BE00010012FE004C00493O0012FE004D004A3O0012E9004E004A3O00122O004F00493O00122O005000496O005100026O005200036O00535O00122O0054004B3O00122O0055004C6O0053005500024O0053004500534O00545O00122O0055004D3O00122O0056004E6O00540056000200025000556O00F70052000300012O000E015300034O006300545O00122O0055004F3O00122O005600506O0054005600024O0054004500544O00555O00122O005600513O00122O005700526O005500570002000250005600014O00F70053000300012O00F70051000200010020C800520004005300060001540002000100022O003F3O004D4O003F3O004E4O00B900555O00122O005600543O00122O005700556O005500576O00523O000100202O00520004005300060001540003000100042O003F3O004B4O003F3O00454O00B78O003F3O004C4O001800555O00122O005600563O00122O005700576O0055005700024O00565O00122O005700583O00122O005800596O005600586O00523O00014O005200523O000250005300044O00C9005400543O00060001550005000100032O00B78O003F3O00064O003F3O00544O00C9005600563O00060001570006000100052O00B78O003F3O00064O003F3O00074O003F3O00564O003F3O000A3O00060001580007000100112O003F3O001E4O00B78O003F3O00494O003F3O00204O003F3O00454O003F3O001F4O003F3O00114O003F3O00474O003F3O001B4O003F3O00304O003F3O00074O003F3O00214O003F3O000B4O003F3O00544O003F3O00564O003F3O00224O003F3O000A3O00060001590008000100082O003F3O000B4O003F3O00494O003F3O00454O00B78O003F3O00154O003F3O00474O003F3O003A4O003F3O000A3O000600015A00090001000F2O003F3O00454O00B78O003F3O00304O003F3O00074O003F3O00494O003F3O00114O003F3O00214O003F3O000B4O003F3O00544O003F3O00474O003F3O00224O003F3O001E4O003F3O001F4O003F3O00564O003F3O00203O000600015B000A0001000A2O003F3O00284O00B78O003F3O00454O003F3O00074O003F3O002A4O003F3O00114O003F3O00474O003F3O000B4O003F3O00294O003F3O002B3O000600015C000B000100232O003F3O001B4O003F3O00454O00B78O003F3O00074O003F3O00114O003F3O003E4O003F3O003D4O003F3O00324O003F3O00314O003F3O00594O003F3O00354O003F3O00494O003F3O00474O003F3O00364O003F3O000A4O003F3O003F4O003F3O00154O003F3O004E4O003F3O00484O003F3O00424O003F3O00184O003F3O00434O003F3O001C4O003F3O005B4O003F3O003C4O003F3O003B4O003F3O00044O003F3O00414O00B73O00014O00B73O00024O003F3O00404O003F3O00504O003F3O00124O003F3O004B4O003F3O004F3O000600015D000C000100282O003F3O003A4O00B78O003F3O003B4O003F3O003C4O003F3O003D4O003F3O002C4O003F3O002D4O003F3O002A4O003F3O002B4O003F3O00324O003F3O00334O003F3O00344O003F3O00354O003F3O00364O003F3O00374O003F3O00384O003F3O00394O003F3O002E4O003F3O002F4O003F3O00304O003F3O00314O003F3O00264O003F3O00274O003F3O00284O003F3O00294O003F3O00224O003F3O00234O003F3O00244O003F3O00254O003F3O003E4O003F3O003F4O003F3O00404O003F3O00414O003F3O001E4O003F3O001F4O003F3O00204O003F3O00214O003F3O00424O003F3O00434O003F3O00443O000600015E000D0001002C2O003F3O00494O003F3O00074O003F3O00194O003F3O005C4O003F3O00454O003F3O00504O003F3O00044O00B78O003F3O00584O003F3O00084O003F3O00474O003F3O00464O003F3O00334O003F3O00344O003F3O00154O003F3O002D4O003F3O002F4O003F3O002E4O003F3O004F4O003F3O00124O003F3O005D4O003F3O001A4O003F3O001B4O003F3O00314O003F3O00554O003F3O000B4O003F3O00214O003F3O00544O003F3O00574O003F3O001E4O003F3O001F4O003F3O00564O003F3O001C4O003F3O00284O003F3O00294O003F3O001D4O003F3O000A4O003F3O00184O003F3O00424O003F3O00434O003F3O005A4O003F3O004D4O003F3O004E4O003F3O005B3O000600015F000E000100042O003F3O00494O00B78O003F3O00104O003F3O00453O00202D00600010005A00122O0061005B6O0062005E6O0063005F6O0060006300016O00013O000F8O00034O00683O00014O00DB3O00024O0034012O00019O003O00034O00683O00014O00DB3O00024O0034012O00017O00033O00028O00025O0001B240024O0080B3C54000123O0012FE3O00014O00C9000100013O002E6400023O000100020004DF3O000200010026FF3O0002000100010004DF3O000200010012FE000100013O000E4800010007000100010004DF3O000700010012FE000200034O002600025O0012FE000200034O0026000200013O0004DF3O001100010004DF3O000700010004DF3O001100010004DF3O000200012O0034012O00017O00143O00028O00025O00209F40025O0074A440026O00F03F025O000C9040025O0068AA40025O00ECA940025O00207A40030B3O0061C33BC80B41E134DB0D4403053O006427AC55BC030B3O004973417661696C61626C65026O001040026O000840030B3O008B77B7943CAB55B8873AAE03053O0053CD18D9E0029A5O99E93F025O00449240025O0094A140025O00C6AF40025O00D2A340003D3O0012FE3O00014O00C9000100023O002E1500020032000100030004DF3O003200010026FF3O0032000100040004DF3O003200010026FF00010006000100010004DF3O000600010012FE000200013O00267E0002000F000100010004DF3O000F0001002EC00006000F000100050004DF3O000F0001002E64000700FCFF2O00080004DF3O000900012O00B7000300014O0024010400023O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003001C00013O0004DF3O001C00010012FE0003000C3O0006390003001D000100010004DF3O001D00010012FE0003000D4O002600036O00B7000300014O0024010400023O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003002B00013O0004DF3O002B00010012FE000300103O0006390003002C000100010004DF3O002C00010012FE000300044O0026000300033O0004DF3O003C00010004DF3O000900010004DF3O003C00010004DF3O000600010004DF3O003C0001002E1500110036000100120004DF3O0036000100267E3O0038000100010004DF3O00380001002E1500130002000100140004DF3O000200010012FE000100014O00C9000200023O0012FE3O00043O0004DF3O000200012O0034012O00019O003O00014O0034012O00017O00423O00028O00025O00CCA640027O0040025O0049B040025O00B8AF40026O00F03F025O00588040025O00288C40025O00805540025O00F08240025O00206340025O002AA340025O00B49740025O00A4AF40025O00E8A440025O0083B040025O0026B140025O00B07140025O000EA640025O00FC9D40025O00107240030A3O00556E6974496E5261696403063O00F5427113E05C03043O006A852E1003043O006A217AF803063O00203840139C3A025O0092B040025O00E07640030B3O00556E6974496E506172747903063O004AC4E44F5FE003073O00E03AA885363A9203053O00695759E96C03083O006B39362B9D15E6E7025O00D49240025O00788740025O0002A440025O00D49A4003053O007061697273025O0068B240025O00EC9A40025O0020AC4003063O0045786973747303163O00556E697447726F7570526F6C6573412O7369676E656403063O00F3AE30D99CEE03073O00AFBBEB7195D9BC03093O004973496E52616E6765026O00394003103O004865616C746850657263656E74616765025O000EAA40025O0060A740025O008EA940025O0084994003043O0047554944025O00289740025O00D09640025O003EA840025O0072A640025O0026AC40025O00A88640025O00606540025O0053B240025O0036A640025O00FAA040025O00E8B240025O00C06540025O00A6A34000C93O0012FE3O00014O00C9000100043O002E6400020004000100020004DF3O0006000100267E3O0008000100030004DF3O00080001002E15000400B8000100050004DF3O00B800010026FF000100AD000100060004DF3O00AD00012O00C9000400043O0012FE000500013O00267E00050012000100010004DF3O00120001002E3001080012000100070004DF3O00120001002E15000A00A0000100090004DF3O00A000010012FE000600013O000E5F00010017000100060004DF3O00170001002E15000C009B0001000B0004DF3O009B0001002E19010D001B0001000E0004DF3O001B000100267E0002001D000100010004DF3O001D0001002E150010004F0001000F0004DF3O004F00010012FE000700013O002E6400110004000100110004DF3O0022000100267E00070024000100010004DF3O00240001002E150013004A000100120004DF3O004A00012O00C9000300033O002E1901150036000100140004DF3O003600010012B6000800164O009100095O00122O000A00173O00122O000B00186O0009000B6O00083O000200062O0008003600013O0004DF3O003600012O00B7000800014O00CA00095O00122O000A00193O00122O000B001A6O0009000B00024O00030008000900044O00490001002E19011C00470001001B0004DF3O004700010012B60008001D4O009100095O00122O000A001E3O00122O000B001F6O0009000B6O00083O000200062O0008004700013O0004DF3O004700012O00B7000800014O00CA00095O00122O000A00203O00122O000B00216O0009000B00024O00030008000900044O004900012O006800086O00DB000800023O0012FE000700063O0026FF0007001E000100060004DF3O001E00010012FE000200063O0004DF3O004F00010004DF3O001E00010026FF0002009A000100060004DF3O009A00010012FE000700013O00267E00070056000100010004DF3O00560001002E1901220095000100230004DF3O009500010012FE000800013O00267E0008005B000100010004DF3O005B0001002E1500240090000100250004DF3O009000012O00C9000400043O0012B6000900264O003F000A00034O000301090002000B0004DF3O008D0001002E640027002D000100270004DF3O008D0001002E150028008D000100290004DF3O008D00010020C8000E000D002A2O0009000E000200020006CB000E008D00013O0004DF3O008D00010012B6000E002B4O0076000F000C6O000E000200024O000F5O00122O0010002C3O00122O0011002D6O000F0011000200062O000E008D0001000F0004DF3O008D00010020C8000E000D002E0012FE0010002F4O00E5000E001000020006CB000E008D00013O0004DF3O008D00010020C8000E000D00302O0009000E00020002000EEE0001008D0001000E0004DF3O008D00010012FE000E00014O00C9000F000F3O002E150032007C000100310004DF3O007C0001002E150034007C000100330004DF3O007C00010026FF000E007C000100010004DF3O007C00010012FE000F00013O0026FF000F0083000100010004DF3O008300012O003F0004000D3O0020C80010000D00352O00090010000200022O0026001000023O0004DF3O008D00010004DF3O008300010004DF3O008D00010004DF3O007C000100064A00090060000100020004DF3O006000010012FE000800063O0026FF00080057000100060004DF3O005700010012FE000700063O0004DF3O009500010004DF3O005700010026FF00070052000100060004DF3O005200010012FE000200033O0004DF3O009A00010004DF3O005200010012FE000600063O000E4800060013000100060004DF3O001300010012FE000500063O0004DF3O00A000010004DF3O00130001002E150037000C000100360004DF3O000C00010026FF0005000C000100060004DF3O000C0001002E150039000B000100380004DF3O000B00010026FF0002000B000100030004DF3O000B00012O00DB000400023O0004DF3O000B00010004DF3O000C00010004DF3O000B00010004DF3O00C8000100267E000100B3000100010004DF3O00B30001002E04013A00B30001003B0004DF3O00B30001002E15003D00080001003C0004DF3O000800010012FE000200014O00C9000300033O0012FE000100063O0004DF3O000800010004DF3O00C80001002E64003E00040001003E0004DF3O00BC000100267E3O00BE000100010004DF3O00BE0001002E19014000C10001003F0004DF3O00C100010012FE000100014O00C9000200023O0012FE3O00063O00267E3O00C5000100060004DF3O00C50001002E1500420002000100410004DF3O000200012O00C9000300043O0012FE3O00033O0004DF3O000200012O0034012O00017O00393O00028O00026O00F03F025O003BB140025O00909F40025O0058AE40025O00089540025O0040AA40025O00E89040026O00A640025O000C9540030A3O00556E6974496E5261696403063O002CA38055E66B03073O00185CCFE12C8319025O00ECAD40025O00E8B04003043O0079D2B14803063O001D2BB3D82C7B025O006DB140030B3O00556E6974496E506172747903063O00ADD52155B8CB03043O002CDDB940025O002C9140025O0092B24003053O0031E65A4B6A03053O00136187283F025O0007B340025O001CB340025O00F4B040025O0070A640025O00B2A240025O00809940025O00C08140025O003EA140025O00DCA240025O009AAD40025O00F88A40025O00C09840025O00C06D40025O0085B340025O00BDB040025O00B6AD4003043O004755494403053O007061697273025O00DAA140025O0032A04003063O00457869737473030C3O00497354616E6B696E67416F45026O00204003093O00497354616E6B696E6703163O00556E697447726F7570526F6C6573412O7369676E656403043O009A7D1D1003063O0051CE3C535B4F03093O004973496E52616E6765026O00394003103O004865616C746850657263656E74616765025O009CA640025O00DEA54000C83O0012FE3O00014O00C9000100023O0026FF3O0007000100010004DF3O000700010012FE000100014O00C9000200023O0012FE3O00023O002E1500040002000100030004DF3O00020001000E480002000200013O0004DF3O000200010012FE000300013O00267E00030010000100010004DF3O00100001002E190105000C000100060004DF3O000C0001002E6400070045000100070004DF3O005500010026FF00010055000100010004DF3O005500010012FE000400013O0026FF0004004C000100010004DF3O004C00010012FE000500013O002E1500080045000100090004DF3O00450001000E4800010045000100050004DF3O004500012O00C9000200023O002E64000A000A0001000A0004DF3O002700010012B60006000B4O002101075O00122O0008000C3O00122O0009000D6O000700096O00063O000200062O00060029000100010004DF3O00290001002E15000F00300001000E0004DF3O003000012O00B7000600014O00CA00075O00122O000800103O00122O000900116O0007000900024O00020006000700044O00440001002E640012000A000100120004DF3O003A00010012B6000600134O002101075O00122O000800143O00122O000900156O000700096O00063O000200062O0006003C000100010004DF3O003C0001002E1500170043000100160004DF3O004300012O00B7000600014O00CA00075O00122O000800183O00122O000900196O0007000900024O00020006000700044O004400012O00B7000200023O0012FE000500023O002E15001A00180001001B0004DF3O001800010026FF00050018000100020004DF3O001800010012FE000400023O0004DF3O004C00010004DF3O0018000100267E00040052000100020004DF3O00520001002E04011C00520001001D0004DF3O00520001002E15001E00150001001F0004DF3O001500010012FE000100023O0004DF3O005500010004DF3O00150001002E150020000B000100210004DF3O000B0001000E480002000B000100010004DF3O000B00012O00B7000400023O0006CE0002008A000100040004DF3O008A00010012FE000400014O00C9000500063O0026FF00040063000100010004DF3O006300010012FE000500014O00C9000600063O0012FE000400023O002E64002200FBFF2O00220004DF3O005E00010026FF0004005E000100020004DF3O005E000100267E0005006B000100010004DF3O006B0001002E1500230067000100240004DF3O006700010012FE000600013O002E6400253O000100250004DF3O006C0001002E190126006C000100270004DF3O006C00010026FF0006006C000100010004DF3O006C00010012FE000700014O00C9000800083O002E1901290074000100280004DF3O007400010026FF00070074000100010004DF3O007400010012FE000800013O000E4800010079000100080004DF3O007900012O00B7000900023O00205900090009002A4O0009000200024O000900036O000900026O000900023O00044O007900010004DF3O006C00010004DF3O007400010004DF3O006C00010004DF3O00C000010004DF3O006700010004DF3O00C000010004DF3O005E00010004DF3O00C000010012B60004002B4O003F000500024O00030104000200060004DF3O00BE0001002E19012D00BE0001002C0004DF3O00BE00010020C800090008002E2O00090009000200020006CB000900BE00013O0004DF3O00BE00010020C800090008002F0012FE000B00304O00E50009000B00020006390009009E000100010004DF3O009E00010020C80009000800312O00B7000B00044O00E50009000B00020006CB000900BE00013O0004DF3O00BE00010012B6000900324O0076000A00076O0009000200024O000A5O00122O000B00333O00122O000C00346O000A000C000200062O000900BE0001000A0004DF3O00BE00010020C80009000800350012FE000B00364O00E50009000B00020006CB000900BE00013O0004DF3O00BE00010020C80009000800372O0009000900020002000EEE000100BE000100090004DF3O00BE00010012FE000900013O0026FF000900B1000100010004DF3O00B100010012FE000A00013O00267E000A00B8000100010004DF3O00B80001002E19013800B4000100390004DF3O00B400010020C8000B0008002A2O0009000B000200022O0026000B00034O00DB000800023O0004DF3O00B400010004DF3O00B1000100064A0004008E000100020004DF3O008E00012O00C9000400044O00DB000400023O0004DF3O000B00010004DF3O000C00010004DF3O000B00010004DF3O00C700010004DF3O000200012O0034012O00017O00A83O00028O00025O00E0A440025O002EB340026O000840025O0018A740025O0001B140025O009CAB40025O0062A04003083O007D123DADF2A4405E03083O003A2E7751C891D025025O00EC9340025O002AAC40026O006E40025O00989240025O006EA940025O00B08040026O00F03F025O009EB040025O006CB140025O00D88340025O00A2A140025O00A49E4003093O004E616D6564556E6974026O003940025O00806840025O009EA74003103O00098039BFBDB8242282379FAABC3A2E9F03073O00564BEC50CCC9DD030A3O0049734361737461626C6503093O0042752O66537461636B03143O00426C6973746572696E675363616C657342752O66026O00A040025O00CEA74003143O00426C6973746572696E675363616C65734E616D65025O0035B240025O0035B140031D3O00704D7E96EA8E60487982C19871407B80EDCB62537286F186704063C5AC03063O00EB122117E59E030C3O0064B3D18F58BFF2B851B6C4A803043O00DB30DAA1025O00DFB140025O005C9E40030C3O005469705468655363616C6573031A3O00F0786C76CF47E5DB627F48D74AF3A4616E4CD840EDE67068098D03073O008084111C29BB2F026O001040025O00607440025O00C49140025O00109440025O00B07940025O0034A74003133O006CA7D5613CCA43A341ADC47A2AE15FAB40B1D503083O00C42ECBB0124FA32D03083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E6703133O00426C652O73696E676F6674686542726F6E7A65026O00A840025O00C4AA4003203O00BA2E7B0D37F2E1BF1D71181BEFE7BD1D7C0C2B2OF5BD626E0C21F8E0B5207F0A03073O008FD8421E7E449B025O00809440025O00D2A54003043O008BDD19C403083O0081CAA86DABA5C3B7030D3O00115722CADD11E9247536DFD71703073O0086423857B8BE7403093O004973496E52616E676503043O0047554944030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O00E8A040025O0098AA40025O00E09040025O00CCA64003123O00536F757263656F664D61676963466F637573025O0088AF40025O0017B14003193O002F3E1CA91AEE1E2O3A0E04BA1EE222752C230CB816E623342803083O00555C5169DB798B41025O00B0AE40025O00D49B40027O0040025O008AA440025O007AA740025O0078A440025O00607A40025O0018B140025O00CCAF40025O00288940025O0042B040025O00A09D40025O00049D4003103O00793CBB58575E0FA04258552BB953434F03053O002D3B4ED43603143O0042726F6E7A65412O74756E656D656E7442752O6603063O0042752O66557003133O00426C61636B412O74756E656D656E7442752O66025O00E89640025O00C07E4003103O0042726F6E7A65412O74756E656D656E74031B3O0012448C859C2B92F1044296858323A8FE04169399832DA2FD12579703083O00907036E3EBE64ECD03043O00923D1BF303063O003BD3486F9CB003103O006C8BEA3E5A82F1244080D02E4F8BE63E03043O004D2EE78303153O00426C6973746572696E675363616C6573466F637573031D3O00B858BF53AE51A449B4538953B955BA45A914A652BF57B94DB855A200E803043O0020DA34D6025O00208B40025O001AAE4003083O00CEB65C407FCBF8B703063O00BF9DD330251C025O0028B340025O005C9C40025O006DB240025O00AEAC40030D3O00EC10E10E39DA10F2313BD816F703053O005ABF7F947C026O006B40025O00C0714003113O00536F757263656F664D616769634E616D65025O00BAA340025O0023B24003193O006B883B057B8211187EB823167F8E2D5768952B14778A2C166C03043O007718E74E025O001EAF40025O00F89140025O00C4AF40025O0097B040025O0072A940025O003EA140030F3O00A021A449D761059638AB4FD1451F9603073O0071E24DC52ABC20030F3O00426C61636B412O74756E656D656E74025O004EA040025O00206140025O00989640025O00088140031A3O00381AF5B63129F5A12E03FAB03713FAA17A06E6B03919F9B73B0203043O00D55A7694025O00408340025O00E0684003093O00243009347008350E2E03053O003D6152665A03073O0049735265616479025O0020B140025O00D0A140025O00D4B140025O00B0824003093O0045626F6E4D69676874025O00A6AE40025O009BB24003163O00A92CA445F85A170EA43AEB5BD5521D06A12CAA5F870F03083O0069CC4ECB2BA7377E025O0046AD40025O00409B40030B3O0089A335171D03E15DA4A72603083O0031C5CA437E7364A7025O0062AE40025O009EB240026O006F40030B3O004C6976696E67466C616D65030E3O0049735370652O6C496E52616E676503193O003B52C9208E51613157DE2485164E255EDC268D545F231B8E7903073O003E573BBF49E0360025022O0012FE3O00014O00C9000100013O002E1901020002000100030004DF3O000200010026FF3O0002000100010004DF3O000200010012FE000100013O0026FF00010083000100040004DF3O008300010012FE000200014O00C9000300033O00267E0002000F000100010004DF3O000F0001002E190106000B000100050004DF3O000B00010012FE000300013O000E480001007C000100030004DF3O007C0001002E190108001B000100070004DF3O001B00012O00B700046O001B000500013O00122O000600093O00122O0007000A6O00050007000200062O00040060000100050004DF3O00600001002E19010C001E0001000B0004DF3O001E00010004DF3O006000010012FE000400014O00C9000500063O002E19010D00290001000E0004DF3O00290001002E15001000290001000F0004DF3O00290001000E4800010029000100040004DF3O002900010012FE000500014O00C9000600063O0012FE000400113O002E190112002D000100130004DF3O002D000100267E0004002F000100110004DF3O002F0001002E1901150020000100140004DF3O00200001002E190110002F000100160004DF3O002F00010026FF0005002F000100010004DF3O002F00012O00B7000700023O00207500070007001700122O000800186O000900036O0007000900024O000600073O002E2O001900600001001A0004DF3O006000012O00B7000700044O0024010800013O00122O0009001B3O00122O000A001C6O0008000A00024O00070007000800202O00070007001D4O00070002000200062O0007006000013O0004DF3O006000010020C800070006001E2O0062000900043O00202O00090009001F4O0007000900024O000800053O00062O00070060000100080004DF3O00600001002E1500200060000100210004DF3O006000012O00B7000700064O0060000800073O00202O0008000800224O0009000A6O0007000A000200062O00070057000100010004DF3O00570001002E1500230060000100240004DF3O006000012O00B7000700013O0012BC000800253O00122O000900266O000700096O00075O00044O006000010004DF3O002F00010004DF3O006000010004DF3O002000012O00B7000400083O0006CB0004007B00013O0004DF3O007B00012O00B7000400044O0024010500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004007B00013O0004DF3O007B0001002E15002A007B000100290004DF3O007B00012O00B7000400064O00E7000500043O00202O00050005002B4O000600066O00040006000200062O0004007B00013O0004DF3O007B00012O00B7000400013O0012FE0005002C3O0012FE0006002D4O00D8000400064O008800045O0012FE000300113O0026FF00030010000100110004DF3O001000010012FE0001002E3O0004DF3O008300010004DF3O001000010004DF3O008300010004DF3O000B000100267E00010087000100010004DF3O00870001002E19013000F90001002F0004DF3O00F900010012FE000200013O002E6400310004000100310004DF3O008C000100267E0002008E000100010004DF3O008E0001002E15003300F0000100320004DF3O00F000012O00B7000300044O0024010400013O00122O000500343O00122O000600356O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300B800013O0004DF3O00B800012O00B7000300093O0006CB000300B800013O0004DF3O00B800012O00B70003000A3O0020320003000300364O000500043O00202O0005000500374O000600016O00030006000200062O000300AA000100010004DF3O00AA00012O00B7000300023O0020170103000300384O000400043O00202O0004000400374O00030002000200062O000300B800013O0004DF3O00B800012O00B7000300064O0060000400043O00202O0004000400394O000500056O00030005000200062O000300B3000100010004DF3O00B30001002E15003B00B80001003A0004DF3O00B800012O00B7000300013O0012FE0004003C3O0012FE0005003D4O00D8000300054O008800035O002E15003E00EF0001003F0004DF3O00EF00012O00B70003000B4O001B000400013O00122O000500403O00122O000600416O00040006000200062O000300EF000100040004DF3O00EF00012O00B7000300044O0024010400013O00122O000500423O00122O000600436O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300DE00013O0004DF3O00DE00012O00B70003000C3O0020C80003000300440012FE000500184O00E50003000500020006CB000300DE00013O0004DF3O00DE00012O00B70003000D4O00B70004000C3O0020C80004000400452O00090004000200020006CE000300DE000100040004DF3O00DE00012O00B70003000C3O0020AB0003000300464O000500043O00202O0005000500474O00030005000200262O000300E0000100480004DF3O00E00001002E15004A00EF000100490004DF3O00EF0001002E15004B00EF0001004C0004DF3O00EF00012O00B7000300064O00B7000400073O0020BF00040004004D2O0009000300020002000639000300EA000100010004DF3O00EA0001002E19014F00EF0001004E0004DF3O00EF00012O00B7000300013O0012FE000400503O0012FE000500514O00D8000300054O008800035O0012FE000200113O002E6400520004000100520004DF3O00F4000100267E000200F6000100110004DF3O00F60001002E15003B0088000100530004DF3O008800010012FE000100113O0004DF3O00F900010004DF3O0088000100267E000100FD000100540004DF3O00FD0001002E150056006D2O0100550004DF3O006D2O010012FE000200013O00267E000200042O0100110004DF3O00042O01002E30015700042O0100580004DF3O00042O01002E15005900062O01005A0004DF3O00062O010012FE000100043O0004DF3O006D2O01000E5F0001000A2O0100020004DF3O000A2O01002E19015C00FE0001005B0004DF3O00FE0001002E19015E00392O01005D0004DF3O00392O012O00B7000300044O0024010400013O00122O0005005F3O00122O000600606O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300392O013O0004DF3O00392O012O00B70003000A3O0020A30003000300364O000500043O00202O0005000500614O00030005000200062O000300392O013O0004DF3O00392O012O00B70003000A3O0020A30003000300624O000500043O00202O0005000500634O00030005000200062O000300392O013O0004DF3O00392O012O00B70003000A3O0020320003000300624O000500043O00202O0005000500634O00068O00030006000200062O000300392O0100010004DF3O00392O01002E15006500392O0100640004DF3O00392O012O00B7000300064O00B7000400043O0020BF0004000400662O00090003000200020006CB000300392O013O0004DF3O00392O012O00B7000300013O0012FE000400673O0012FE000500684O00D8000300054O008800036O00B700036O0019000400013O00122O000500693O00122O0006006A6O00040006000200062O000300412O0100040004DF3O00412O010004DF3O006B2O012O00B7000300044O0024010400013O00122O0005006B3O00122O0006006C6O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003006B2O013O0004DF3O006B2O012O00B70003000C3O0020C80003000300440012FE000500184O00E50003000500020006CB0003006B2O013O0004DF3O006B2O012O00B70003000C3O00202A01030003001E4O000500043O00202O00050005001F4O0003000500024O000400053O00062O0003006B2O0100040004DF3O006B2O012O00B70003000E4O00B70004000C3O0020C80004000400452O00090004000200020006CE0003006B2O0100040004DF3O006B2O012O00B7000300064O00E7000400073O00202O00040004006D4O000500066O00030006000200062O0003006B2O013O0004DF3O006B2O012O00B7000300013O0012FE0004006E3O0012FE0005006F4O00D8000300054O008800035O0012FE000200113O0004DF3O00FE0001002E19017000DC2O0100710004DF3O00DC2O010026FF000100DC2O0100110004DF3O00DC2O012O00B70002000B4O0019000300013O00122O000400723O00122O000500736O00030005000200062O000200792O0100030004DF3O00792O010004DF3O00B72O010012FE000200014O00C9000300043O002E6400740034000100740004DF3O00AF2O010026FF000200AF2O0100110004DF3O00AF2O01000E5F000100832O0100030004DF3O00832O01002E190176007F2O0100750004DF3O007F2O012O00B7000500023O00208300050005001700122O000600186O0007000F6O0005000700024O000400053O002E2O0077002E000100770004DF3O00B72O010006CB000400B72O013O0004DF3O00B72O012O00B7000500044O0024010600013O00122O000700783O00122O000800796O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500B72O013O0004DF3O00B72O010020C80005000400462O00B7000700043O0020BF0007000700472O00E5000500070002002620000500B72O0100480004DF3O00B72O01002E15007A00A52O01007B0004DF3O00A52O012O00B7000500064O00B7000600073O0020BF00060006007C2O0009000500020002000639000500A72O0100010004DF3O00A72O01002E19017E00B72O01007D0004DF3O00B72O012O00B7000500013O0012BC0006007F3O00122O000700806O000500076O00055O00044O00B72O010004DF3O007F2O010004DF3O00B72O01000E5F000100B32O0100020004DF3O00B32O01002E190181007B2O0100820004DF3O007B2O010012FE000300014O00C9000400043O0012FE000200113O0004DF3O007B2O01002E19018300DB2O0100840004DF3O00DB2O01002E19018600DB2O0100850004DF3O00DB2O012O00B7000200044O0024010300013O00122O000400873O00122O000500886O0003000500024O00020002000300202O00020002001D4O00020002000200062O000200DB2O013O0004DF3O00DB2O012O00B70002000A3O0020A30002000200364O000400043O00202O0004000400634O00020004000200062O000200DB2O013O0004DF3O00DB2O012O00B7000200064O00B7000300043O0020BF0003000300892O0009000200020002000639000200D62O0100010004DF3O00D62O01002EC0008A00D62O01008B0004DF3O00D62O01002E19018C00DB2O01008D0004DF3O00DB2O012O00B7000200013O0012FE0003008E3O0012FE0004008F4O00D8000200044O008800025O0012FE000100543O000E5F002E00E02O0100010004DF3O00E02O01002E6400900029FE2O00910004DF3O000700012O00B7000200044O00C1000300013O00122O000400923O00122O000500936O0003000500024O00020002000300202O0002000200944O00020002000200062O000200EC2O0100010004DF3O00EC2O01002E15009500FC2O0100960004DF3O00FC2O01002E19019800FC2O0100970004DF3O00FC2O012O00B7000200064O0060000300043O00202O0003000300994O000400046O00020004000200062O000200F72O0100010004DF3O00F72O01002E15009B00FC2O01009A0004DF3O00FC2O012O00B7000200013O0012FE0003009C3O0012FE0004009D4O00D8000200044O008800025O002E64009E00280001009E0004DF3O00240201002E64009F00260001009F0004DF3O002402012O00B7000200044O0024010300013O00122O000400A03O00122O000500A16O0003000500024O00020002000300202O00020002001D4O00020002000200062O0002002402013O0004DF3O00240201002E1901A20024020100A30004DF3O00240201002E1500A40024020100820004DF3O002402012O00B7000200064O00E4000300043O00202O0003000300A54O000400056O000600103O00202O0006000600A64O000800043O00202O0008000800A54O0006000800024O000600066O0002000600020006CB0002002402013O0004DF3O002402012O00B7000200013O0012BC000300A73O00122O000400A86O000200046O00025O00044O002402010004DF3O000700010004DF3O002402010004DF3O000200012O0034012O00017O001B3O00028O00025O0088A440025O0040A34003063O0045786973747303093O004973496E52616E6765026O003E4003173O0044697370652O6C61626C65467269656E646C79556E697403073O00C21AEADCE905FF03043O00A987629A03073O004973526561647903133O00556E6974486173506F69736F6E446562752O66025O00FAA840025O006EA740030C3O00457870756E6765466F637573030E3O00EE6F3441F334CD8B732D47ED36C403073O00A8AB1744349D53026O00F03F025O0034AF40025O00607240030E3O00DB61E5BF203E94FD7FF29F2A2C9503073O00E7941195CD454D03113O00556E6974486173456E7261676542752O66025O00A49940025O00A88540030E3O004F2O7072652O73696E67526F617203163O00AFB7D7E952EC93AEC9FC17CD8FA6D5BB53F693B7C2F703063O009FE0C7A79B37005E3O0012FE3O00013O0026FF3O0037000100010004DF3O00370001002E1901030019000100020004DF3O001900012O00B700015O0006CB0001001800013O0004DF3O001800012O00B700015O0020C80001000100042O00090001000200020006CB0001001800013O0004DF3O001800012O00B700015O0020C80001000100050012FE000300064O00E50001000300020006CB0001001800013O0004DF3O001800012O00B7000100013O0020BF0001000100072O001700010001000200063900010019000100010004DF3O001900012O0034012O00014O00B7000100024O0024010200033O00122O000300083O00122O000400096O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001002900013O0004DF3O002900012O00B7000100013O0020BF00010001000B2O00B700026O00090001000200020006390001002B000100010004DF3O002B0001002E15000C00360001000D0004DF3O003600012O00B7000100044O00B7000200053O0020BF00020002000E2O00090001000200020006CB0001003600013O0004DF3O003600012O00B7000100033O0012FE0002000F3O0012FE000300104O00D8000100034O008800015O0012FE3O00113O002E1500130001000100120004DF3O000100010026FF3O0001000100110004DF3O000100012O00B7000100024O0024010200033O00122O000300143O00122O000400156O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001005D00013O0004DF3O005D00012O00B7000100063O0006CB0001005D00013O0004DF3O005D00012O00B7000100013O0020BF0001000100162O00B7000200074O00090001000200020006CB0001005D00013O0004DF3O005D0001002E190118005D000100170004DF3O005D00012O00B7000100044O00B7000200023O0020BF0002000200192O00090001000200020006CB0001005D00013O0004DF3O005D00012O00B7000100033O0012BC0002001A3O00122O0003001B6O000100036O00015O00044O005D00010004DF3O000100012O0034012O00017O005F3O00028O00026O00F03F025O00C08D40025O00C05140025O0056A240025O00707A40025O00A7B140025O0076A14003133O00D5FF39C1E4FA32D5F8F528DAF2D12EDDF9E93903043O00B297935C030A3O0049734361737461626C6503083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E67025O0085B340025O00A7B24003133O00426C652O73696E676F6674686542726F6E7A6503203O008EF149210145748BC243342D587289C24E201D426089BD5C20174F7581FF4D2603073O001AEC9D2C52722C025O000AAA40025O0068AC4003043O000B3BC15403043O003B4A4EB5030D3O0016DE4F48B020DE5C77B222D85903053O00D345B12O3A03093O004973496E52616E6765026O00394003043O0047554944030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O00F4AC40025O00B2A240025O00E08B40025O00F4924003123O00536F757263656F664D61676963466F63757303193O00A4EA6CE7EACE88EA7FCAE4CAB0EC7AB5F9D9B2E676F8EBCAA303063O00ABD785199589025O00709B40025O003EAD40025O00E2A940025O002FB240027O0040025O00E8AE40025O0022A540025O004CA440025O0028A940025O009C9E40025O00BAA740025O0062B340025O00B8AC4003083O00D2CD3EFFEC24F94603083O002281A8529A8F509C025O00649340025O004AA140025O0016AB40025O007AA940025O00D49640025O000AA24003093O004E616D6564556E6974025O0029B340025O006EB340030D3O00B6BD26192O4B86839F320C414D03073O00E9E5D2536B282E03113O00536F757263656F664D616769634E616D6503193O00D24D27C406C47D3DD03ACC4335DF06815220D306CE4F30D71103053O0065A12252B603043O00C9184DF103083O004E886D399EBB82E203103O001C33F0E22A3AEBF83038CAF23F33FCE203043O00915E5F9903093O0042752O66537461636B03143O00426C6973746572696E675363616C657342752O66025O00CAAB4003153O00426C6973746572696E675363616C6573466F637573025O003DB240025O00F07F4003193O00FFC11DC65AB2EFC41AD271A4FECC18D05DF7F0CC1DDB0EE4A903063O00D79DAD74B52E03083O0006B187F7D921B18F03053O00BA55D4EB92025O007EB040025O00309D40025O0024A840025O00805940025O0010774003103O00E08D1FED2DEB4ACB8F11CD3AEF54C79203073O0038A2E1769E598E025O000AAC40025O0056A74003143O00426C6973746572696E675363616C65734E616D6503193O005E09C9BC36DD4E0CCEA81DCB5F04CCAA31985104C9A1628B0803063O00B83C65A0CF42025O0039B040025O00C497400057012O0012FE3O00014O00C9000100023O00267E3O0006000100020004DF3O00060001002E150003004E2O0100040004DF3O004E2O01002E1500060006000100050004DF3O0006000100267E0001000C000100010004DF3O000C0001002E1901070006000100080004DF3O000600010012FE000200013O0026FF00020070000100010004DF3O007000012O00B700036O0024010400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003900013O0004DF3O003900012O00B7000300023O0006CB0003003900013O0004DF3O003900012O00B7000300033O00203200030003000C4O00055O00202O00050005000D4O000600016O00030006000200062O0003002B000100010004DF3O002B00012O00B7000300043O00201701030003000E4O00045O00202O00040004000D4O00030002000200062O0003003900013O0004DF3O00390001002E15001000390001000F0004DF3O003900012O00B7000300054O00E700045O00202O0004000400114O000500056O00030005000200062O0003003900013O0004DF3O003900012O00B7000300013O0012FE000400123O0012FE000500134O00D8000300054O008800035O002E1901140043000100150004DF3O004300012O00B7000300064O0019000400013O00122O000500163O00122O000600176O00040006000200062O00030043000100040004DF3O004300010004DF3O006F00012O00B700036O0024010400013O00122O000500183O00122O000600196O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003006F00013O0004DF3O006F00012O00B7000300073O0020C800030003001A0012FE0005001B4O00E50003000500020006CB0003006F00013O0004DF3O006F00012O00B7000300084O00B7000400073O0020C800040004001C2O00090004000200020006CE0003006F000100040004DF3O006F00012O00B7000300073O0020C600030003001D4O00055O00202O00050005001E4O00030005000200262O0003006F0001001F0004DF3O006F0001002E150021006F000100200004DF3O006F0001002E190122006F000100230004DF3O006F00012O00B7000300054O00B7000400093O0020BF0004000400242O00090003000200020006CB0003006F00013O0004DF3O006F00012O00B7000300013O0012FE000400253O0012FE000500264O00D8000300054O008800035O0012FE000200023O0026FF000200062O0100020004DF3O00062O010012FE000300013O002E190127007B000100280004DF3O007B0001002E150029007B0001002A0004DF3O007B00010026FF0003007B000100020004DF3O007B00010012FE0002002B3O0004DF3O00062O0100267E0003007F000100010004DF3O007F0001002E19012C00730001002D0004DF3O007300010012FE000400013O002E15002E00860001002F0004DF3O008600010026FF00040086000100020004DF3O008600010012FE000300023O0004DF3O00730001002E190130008A000100310004DF3O008A000100267E0004008C000100010004DF3O008C0001002E1500320080000100330004DF3O008000012O00B7000500064O001B000600013O00122O000700343O00122O000800356O00060008000200062O000500CE000100060004DF3O00CE0001002EC0003700CE000100360004DF3O00CE0001002E1901380098000100390004DF3O009800010004DF3O00CE00010012FE000500014O00C9000600073O0026FF0005009F000100010004DF3O009F00010012FE000600014O00C9000700073O0012FE000500023O0026FF0005009A000100020004DF3O009A0001002E15003A00A10001003B0004DF3O00A100010026FF000600A1000100010004DF3O00A100012O00B7000800043O0020CD00080008003C00122O0009001B6O000A000A6O0008000A00024O000700083O002E2O003D00CE0001003E0004DF3O00CE00010006CB000700CE00013O0004DF3O00CE00012O00B700086O0024010900013O00122O000A003F3O00122O000B00406O0009000B00024O00080008000900202O00080008000B4O00080002000200062O000800CE00013O0004DF3O00CE00010020C800080007001D2O00B7000A5O0020BF000A000A001E2O00E50008000A0002002620000800CE0001001F0004DF3O00CE00012O00B7000800054O00B7000900093O0020BF0009000900412O00090008000200020006CB000800CE00013O0004DF3O00CE00012O00B7000800013O0012BC000900423O00122O000A00436O0008000A6O00085O00044O00CE00010004DF3O00A100010004DF3O00CE00010004DF3O009A00012O00B70005000B4O001B000600013O00122O000700443O00122O000800456O00060008000200062O000500032O0100060004DF3O00032O012O00B700056O0024010600013O00122O000700463O00122O000800476O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500032O013O0004DF3O00032O012O00B7000500073O0020C800050005001A0012FE0007001B4O00E50005000700020006CB000500032O013O0004DF3O00032O012O00B7000500073O00202A0105000500484O00075O00202O0007000700494O0005000700024O0006000C3O00062O000500032O0100060004DF3O00032O012O00B70005000D4O00B7000600073O0020C800060006001C2O00090006000200020006CE000500032O0100060004DF3O00032O01002E64004A00090001004A0004DF3O00FC00012O00B7000500054O0060000600093O00202O00060006004B4O000700086O00050008000200062O000500FE000100010004DF3O00FE0001002E19014C00032O01004D0004DF3O00032O012O00B7000500013O0012FE0006004E3O0012FE0007004F4O00D8000500074O008800055O0012FE000400023O0004DF3O008000010004DF3O00730001000E48002B000D000100020004DF3O000D00012O00B70003000B4O0019000400013O00122O000500503O00122O000600516O00040006000200062O000300112O0100040004DF3O00112O01002E15005200562O0100530004DF3O00562O010012FE000300014O00C9000400053O002E15005500432O0100540004DF3O00432O01002E640056002E000100560004DF3O00432O010026FF000300432O0100020004DF3O00432O01000E48000100192O0100040004DF3O00192O012O00B7000600043O00205D00060006003C00122O0007001B6O0008000E6O0006000800024O000500066O00068O000700013O00122O000800573O00122O000900586O0007000900024O00060006000700202O00060006000B4O00060002000200062O000600322O013O0004DF3O00322O010020C80006000500482O00F200085O00202O0008000800494O0006000800024O0007000C3O00062O00060003000100070004DF3O00342O01002E19015900562O01005A0004DF3O00562O012O00B7000600054O00E7000700093O00202O00070007005B4O000800096O00060009000200062O000600562O013O0004DF3O00562O012O00B7000600013O0012BC0007005C3O00122O0008005D6O000600086O00065O00044O00562O010004DF3O00192O010004DF3O00562O01000E48000100132O0100030004DF3O00132O010012FE000400014O00C9000500053O0012FE000300023O0004DF3O00132O010004DF3O00562O010004DF3O000D00010004DF3O00562O010004DF3O000600010004DF3O00562O01002E19015F00020001005E0004DF3O000200010026FF3O0002000100010004DF3O000200010012FE000100014O00C9000200023O0012FE3O00023O0004DF3O000200012O0034012O00017O00493O00028O00025O001AB140025O004AA640025O00206F40025O00C05640025O0004B240025O003C9C40025O00C88340025O0066B140030B3O00018E7DA534903C933F8E6503043O00DC51E21C025O00C09A40025O0024AC40025O00BBB140025O005AA540030E3O0025D090FFEBC907F08FF9F8C610D003063O00A773B5E29B8A03073O004973526561647903103O004865616C746850657263656E74616765025O0030A240025O00907740025O005EA94003143O0056657264616E74456D6272616365506C6179657203173O00F427F5587A7FD2DD27EA5E6970C5E762EA5D727F86B67203073O00A68242873C1B11025O00709540025O002AAF4003083O00615CCB67294B44CB03053O0050242AAE1503083O00601F233A7A11397103043O001A2E7057030E3O008F26B970BEB15191B421B975BCBA03083O00D4D943CB142ODF25025O004EA440025O0018804003133O0056657264616E74456D6272616365466F63757303173O00AC88BAD6BB83BCEDBF80AAC0BB8EAD92B78CA1DCFAD9F803043O00B2DAEDC8026O00F03F025O0080AD40025O00A89C40025O0054AD40025O00508940025O00849940025O00E49E40030B3O0086B9E7C9B3A7A6FFB8B9FF03043O00B0D6D586025O00B0B140025O0046AC40030E3O00D1A0B3C6A95A5DD6A1B9C7BB595403073O003994CDD6B4C836025O00109440025O002EAF4003143O00456D6572616C64426C6F2O736F6D506C61796572025O00806540025O0058A04003173O0017F03026771EF90A367A1DEE263B7B52F0343D7852A96703053O0016729D5554025O0090A04003083O00E1DD16D644F9A6C103073O00C8A4AB73A43D96025O005BB040025O00D2A940025O000C9140030E3O009BF9065782B2F021498CADE70C4803053O00E3DE946325025O00BCA240025O00607640025O008CAD40025O0016AE4003133O00456D6572616C64426C6F2O736F6D466F63757303173O00365F57E4F83F566DF4F53C2O41F9F4735F53FFF773060003053O0099532O329600D53O0012FE3O00014O00C9000100013O002E1901030006000100020004DF3O0006000100267E3O0008000100010004DF3O00080001002E1901040002000100050004DF3O000200010012FE000100013O00267E0001000D000100010004DF3O000D0001002E640006006A000100070004DF3O007500010012FE000200013O0026FF0002006C000100010004DF3O006C0001002E150008003D000100090004DF3O003D00012O00B700036O0019000400013O00122O0005000A3O00122O0006000B6O00040006000200062O0003001B000100040004DF3O001B0001002E19010D003D0001000C0004DF3O003D0001002E15000F002D0001000E0004DF3O002D00012O00B7000300024O0024010400013O00122O000500103O00122O000600116O0004000600024O00030003000400202O0003000300124O00030002000200062O0003002D00013O0004DF3O002D00012O00B7000300033O0020C80003000300132O00090003000200022O00B7000400043O00062B0103002F000100040004DF3O002F0001002E190114003D000100150004DF3O003D0001002E640016000E000100160004DF3O003D00012O00B7000300054O00E7000400063O00202O0004000400174O000500056O00030005000200062O0003003D00013O0004DF3O003D00012O00B7000300013O0012FE000400183O0012FE000500194O00D8000300054O008800035O002E19011A006B0001001B0004DF3O006B00012O00B700036O0019000400013O00122O0005001C3O00122O0006001D6O00040006000200062O0003004D000100040004DF3O004D00012O00B700036O001B000400013O00122O0005001E3O00122O0006001F6O00040006000200062O0003006B000100040004DF3O006B00012O00B7000300024O0024010400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O0003000300124O00030002000200062O0003005D00013O0004DF3O005D00012O00B7000300073O0020C80003000300132O00090003000200022O00B7000400043O00062B0103005F000100040004DF3O005F0001002E150022006B000100230004DF3O006B00012O00B7000300054O00E7000400063O00202O0004000400244O000500056O00030005000200062O0003006B00013O0004DF3O006B00012O00B7000300013O0012FE000400253O0012FE000500264O00D8000300054O008800035O0012FE000200273O002E150029000E000100280004DF3O000E000100267E00020072000100270004DF3O00720001002E19012A000E0001002B0004DF3O000E00010012FE000100273O0004DF3O007500010004DF3O000E00010026FF00010009000100270004DF3O00090001002E15002C00A20001002D0004DF3O00A200012O00B7000200084O001B000300013O00122O0004002E3O00122O0005002F6O00030005000200062O000200A2000100030004DF3O00A20001002E1500310092000100300004DF3O009200012O00B7000200024O0024010300013O00122O000400323O00122O000500336O0003000500024O00020002000300202O0002000200124O00020002000200062O0002009200013O0004DF3O009200012O00B7000200033O0020C80002000200132O00090002000200022O00B7000300093O00062B01020094000100030004DF3O00940001002E15003500A2000100340004DF3O00A200012O00B7000200054O0060000300063O00202O0003000300364O000400046O00020004000200062O0002009D000100010004DF3O009D0001002E15003800A2000100370004DF3O00A200012O00B7000200013O0012FE000300393O0012FE0004003A4O00D8000200044O008800025O002E64003B00090001003B0004DF3O00AB00012O00B7000200084O001B000300013O00122O0004003C3O00122O0005003D6O00030005000200062O000200D4000100030004DF3O00D40001002E15003E00AE0001003F0004DF3O00AE00010004DF3O00D40001002E6400400026000100400004DF3O00D400012O00B7000200024O0024010300013O00122O000400413O00122O000500426O0003000500024O00020002000300202O0002000200124O00020002000200062O000200C000013O0004DF3O00C000012O00B7000200073O0020C80002000200132O00090002000200022O00B7000300093O00062B010200C2000100030004DF3O00C20001002E6400430014000100440004DF3O00D40001002E19014500D4000100460004DF3O00D400012O00B7000200054O00E7000300063O00202O0003000300474O000400046O00020004000200062O000200D400013O0004DF3O00D400012O00B7000200013O0012BC000300483O00122O000400496O000200046O00025O00044O00D400010004DF3O000900010004DF3O00D400010004DF3O000200012O0034012O00017O00DC012O00028O00025O00288540025O00B49240026O00F03F025O00DCAE40027O0040025O00F0B240025O00A06140025O00A6A240025O001DB240025O00A4AB40025O003EAE40025O00C49340025O00AEA540030C3O00B02O481A8C446B2D854D5D3D03043O004EE42138030A3O0049734361737461626C65030A3O00E877A006A7DC7BB3178D03053O00E5AE1ED263030F3O00432O6F6C646F776E52656D61696E732O033O00474344030C3O005469705468655363616C657303163O000FE4966EF9353C24FE8550E1382A5BE08758E37D684B03073O00597B8DE6318D5D026O000840025O00C4AD40025O00B8A840025O004EB140025O00804940025O003C9D40025O00389F40030E3O00E2E50EF21EC4E613C819CCEB18E803053O007AAD877D9B03103O004865616C746850657263656E7461676503083O0042752O66446F776E030E3O004F6273696469616E5363616C6573025O0046A040025O00E4AE4003153O008BC313B03B38C98AD203B83334DBC4CC01B031719E03073O00A8E4A160D95F5103093O00FED32152025EDCD93A03063O0037BBB14E3C4F03073O0049735265616479030F3O0042752O665265667265736861626C6503113O0045626F6E4D6967687453656C6642752O66026O001040025O00FAA340025O0052A440025O00049D40025O00804D4003093O0045626F6E4D6967687403113O0028CC50E579C2892AC64BAB4BCE89238E0703073O00E04DAE3F8B26AF025O001CA240025O00E89040025O00409340025O00CAA740025O00AAA940025O00F2AA40026O005A40025O00688040025O00149540025O00B6B140025O002EA740025O003AB040025O00EEA240025O0080A240025O0068B240025O00CAAD40025O007DB240025O00B8AB40030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C696374656403073O00457870756E676503103O00457870756E67654D6F7573656F766572026O004440025O00549F40025O004FB240025O00206340025O001EA040025O0030A440025O005EA940025O006C9B40025O00A8854003113O0048616E646C65496E636F72706F7265616C03093O00536C2O657077616C6B03123O00536C2O657077616C6B4D6F7573656F766572026O003E40025O009C9B40025O00A08C40025O002OAA40025O000AAC40025O00C4AC40026O001440025O00C05240025O00E07A40025O00EFB140025O00E8A740030B3O002FCF61450DC1514002CB7203043O002C63A61703063O0042752O66557003113O004C656170696E67466C616D657342752O6603103O005AFE3B3311B679F63D3E17A17EE22F3003063O00C41C97495653030F3O0041757261416374697665436F756E74025O00B8A940025O00EC9640030B3O004C6976696E67466C616D65030E3O0049735370652O6C496E52616E6765025O003DB040025O0026A94003143O00FF0A3F198C5F2770FF022415C255197FFD437B4203083O001693634970E23878025O007C9C40025O00BCA540025O00689540026O008340025O007AA840025O00389A4003073O008D7BF0F49BBD7903053O00EDD815829503073O00556E726176656C030E3O0097404D5EA6CC52C2435E56BE890C03073O003EE22E2O3FD0A9026O001840025O0071B240025O00389440025O00D4AA40025O00909B40030C3O00240D57C6B87A84003A5DC9BF03073O00EB667F32A7CC1203093O0075A3FA2D692757A9E103063O004E30C195432403073O00103D950A523F0C03053O0021507EE078025O0090AF40025O00709C4003123O004272656174686F66456F6E73437572736F7203093O004973496E52616E6765026O004940025O003EA540025O0020754003163O00EEBA06C548E4970CC263E9A70DD71CE1A90ACA1CBDF003053O003C8CC863A4025O0060B040025O00C2A340030C3O00A4FB0A20AB95F90532AB88FA03053O00C2E7946446025O00AEA140025O00F0B040025O00489840025O002AA240030C3O004272656174686F66456F6E7303163O00445EC4A2E2C07943C79CF3C7485F81AEF7C1480C90FB03063O00A8262CA1C39603133O00B4F98F663FFAB71AB7F3977834CCB31495FA8403083O0076E09CE2165088D6030C3O0060FC5C8156E6568667E1579303043O00E0228E3903063O00F3A6CBC872FD03083O006EBEC7A5BD13913D03063O00F7EA79FD8ACB03063O00A7BA8B1788EB025O00109240025O00107840025O00509140025O00ADB140025O000CB040025O0078A840025O0042AD40025O000FB140025O0008AA40025O00FAB240025O004EB340025O00C49940025O0018A440025O00A0A640025O0021B240025O0048B140025O0020A94003103O0048616E646C65546F705472696E6B6574025O00709840025O006CAC4003133O0048616E646C65426F2O746F6D5472696E6B6574025O0014A340025O00CCAF40025O00908B40026O003540030F3O0048616E646C65445053506F74696F6E03133O002EB0851D15A789012DBA9D031E918D2O0FB38E03043O006D7AD5E8030C3O00CCE5A731FAFFAD36CBF8AC2303043O00508E97C2025O008AA240025O00B5B240025O00BC9C40025O00C09140026O00AF40025O00F0904003073O0047657454696D65025O00CCAA4003053O00757965196103073O002D3D16137C13CB03053O00486F766572030C3O00C91D1BF01030B4C01B03B55003073O00D9A1726D956210025O00608740025O00E0A140030F3O00412O66656374696E67436F6D626174025O00D88B40025O0079B140025O0029B040025O003C9C40025O00B07B40025O00D09640025O0026A540025O00E06F40025O001CAF40025O00F4B240025O0041B240030D3O0020253679AB7D1C271A70BD6E1703063O00147240581CDC025O00FEA740025O00AEA440025O00DEA640025O00B6A740030D3O0052656E6577696E67426C617A65025O00C88340025O00A0994003143O000304DCB1EFD9B33623DEB5E2D5FD3C00DBBAB88603073O00DD5161B2D498B0025O0053B140025O00A49E40025O0068AD40025O00C8A240025O00C6AD40025O003EB040025O0058AB40025O00B88340025O00388740025O00804740025O001EAC40025O008C9040025O00C89C40025O00E8AE40030B3O00C910438A110A0952E4145003083O003E857935E37F6D4F030A3O00436F6D62617454696D65030B3O003C1D24FCD8A9841C153FF003073O00C270745295B6CE03083O004361737454696D65025O0096A040025O00689740025O006C9540025O0096A34003133O0035A15A11CEE5313FA44D15C5A20338A142589403073O006E59C82C78A08203083O009FCA46437041325D03083O002DCBA32B26232A5B030A3O00F48CCE26A5BB51D391D403073O0034B2E5BC43E7C903083O0014515801F64A222D03073O004341213064973C030A3O00EFF5ABCBF0D6E2A0DBF603053O0093BF87CEB8025O00804140025O002EAC40025O00D0A340025O00EC9E40025O00109E40025O00989140025O00B6AC40025O00408A40025O00FCB04003093O00486F76657242752O66025O0020AA40025O003EAC40025O00E7B140025O0093B14003083O0054696D65536B697003113O009021ABC4E740B98D38E6CCD95ABCC47AF203073O00D2E448C6A1B833025O00A8B240025O00406A40030D3O003E46E515618E3B48FA1E339C6203063O00AE562993701303113O004F09800E1A1C1AA24B40800A2C0151F90F03083O00CB3B60ED6B456F71025O006AA440025O0080A540030A3O00021FBEE413E2D22502A403073O00B74476CC815190030C3O002FA373ED0E8C1A8B7CE5068703063O00E26ECD10846B030B3O004973417661696C61626C65030B3O0042752O6652656D61696E73030F3O00456D706F7765724361737454696D65025O007DB040025O0042B040025O00BEB140025O008EA040025O003C9040025O0034A640025O00E3B240025O0023B040025O0002B240025O0021B040026O008540030A3O004669726542726561746803013O0031026O003940031D3O00EDCAF2DC7EE9D1E5D855E383E5D451E4D4E5CB01BA83EDD848E583B28F03053O00218BA380B9026O001C40025O00D88F40025O0014AB40025O00549640025O0006AE40025O008AA440030A3O00F923F35397CF23F757BD03053O00D5BD469623030C3O006D4771095B5D7B0E6A5A7A1B03043O00682F3514025O00EEAA40025O00B2A640030A3O00442O657042726561746803133O00A749840C830DB1498008B44FAE4D8812FC5CF103063O006FC32CE17CDC026O002040025O0002A640025O00088040025O00207240025O00B88A40030A3O00715116DB754A01DF435003043O00BE373864030C3O0077A13F1716EDE770A33D131603073O009336CF5C7E7383025O00E08640025O00ECA340025O0022A840025O0080644003143O000B382778327C1F2O3469053E083C25721A7B1F7103063O001E6D51551D6D03083O00BF7C55BF389EAEA703073O009C9F1134D656BE025O00F9B140025O005EB14003083O009BFFB5B9AFF9BCB003043O00DCCE8FDD03143O00456E656D696573436F756E74387953706C617368025O00BC9640025O00C06240025O00188F40025O0066A04003083O00557068656176616C03113O00936D2512D9DAD38A3D281AC8C3C5836F6D03073O00B2E61D4D77B8AC03083O00B5B30B1279B8A6EE03063O009895DE6A7B17025O00088E40025O004CAF40025O00F2A840025O009CAD4003083O00FD541563BFA2D74803063O00CBB8266013CB03083O001C616C51DA307C7703053O00AE5913192103103O00452O73656E636554696D65546F4D617803083O000A00475EE38E042103073O006B4F72322E97E703103O00452O73656E6365427572737442752O6603083O004572757074696F6E03103O003CB4A0399E30B8CE79ABB4208479E49603083O00A059C6D549EA59D7025O000CA540025O00F6B240030B3O006478A2F7CB4F57B8FFC84D03053O00A52811D49E03083O0049734D6F76696E6703123O00D5CC183A2AEADF293F23FDCA1C2127F6C30903053O004685B96853025O00F07C40025O0046AB4003143O00084C5223C7037A4226C809400427C80D4B047E9B03053O00A96425244A025O00EAA340025O0018A040030B3O00219DB74205B4B642098CA703043O003060E7C203123O00F84F1E2415D7A9A2C45F163E0DCAAE90D25B03083O00E3A83A6E4D79B8CF025O004EB040025O002AAD40030B3O00417A757265537472696B6503143O007A26AA52B4E462B16935B445F1D670AC757CEB1403083O00C51B5CDF20D1BB11025O0084A440025O00408440025O00EC9840025O003CA040025O002EAF40025O00CCA840025O008C9940025O00688440030A3O00D578E4093258F670E20403063O002A9311966C70030D3O0023A32C6FEEE60880217EEAED1C03063O00886FC64D1F8703083O003600AA538EEF1EB903083O00C96269C736DD847703113O00900297241022A3AF098D150A27A9B8089003073O00CCD96CE341625503083O006ACAF8E01FCB57D303063O00A03EA395854C025O0034AD40025O00A8A940025O00249C40025O007BB040025O00CDB040025O00F6AE40025O0086B240025O0060AD40025O00206E40031D3O00D0A91F2AFCD4B2082ED7DEE00822D3D9B7083D8387E0002ECAD8E05C7D03053O00A3B6C06D4F030A3O00122F12C5D7262301D4FD03053O0095544660A0030D3O0014030CFD31080ACB340700E82B03043O008D58666D03083O00875AC77529365CD103083O00A1D333AA107A5D3503113O00D2A0A62DE9B9BD3EFEA08620E9ABB32CE803043O00489BCED203083O007273590B004D734403053O0053261A346E025O00D89840025O00B08F40025O00D0AF40025O0057B240025O0058A140025O0092A640025O00149040025O0070A140025O00CC9C40025O0050B040025O00688540025O0075B240025O00B4A84003143O005E1E35436715354359032F065D1A37494F12350603043O002638774703083O00B3E259DF2B16A2BB03063O0036938F38B645025O0063B04003083O00E391F74CDEC080F303053O00BFB6E19F2903083O001F1B2550B88CCB3B03073O00A24B724835EBE703113O00A53250E74115832A41EC670A9E3945E64003063O0062EC5C24823303083O00901001BF76A3BC2003083O0050C4796CDA25C8D5025O0062AD40025O006EA040025O0032B340025O002FB140025O0098AC40025O0074B040025O00805840025O00C6A640025O00806840025O00708440025O0002A740031A3O0015630A7A4A188B0C330772441E9D0561422E0B038B097D422E1D03073O00EA6013621F2B6E025O0084A240025O00CCB140001B082O0012FE3O00014O00C9000100023O002E150002000F080100030004DF3O000F08010026FF3O000F080100040004DF3O000F0801002E640005008B000100050004DF3O00910001000E4800060091000100010004DF3O009100010012FE000300013O002E150008003D000100070004DF3O003D0001002E190109003D0001000A0004DF3O003D00010026FF0003003D000100040004DF3O003D0001002E19010B003B0001000C0004DF3O003B0001002E19010D003B0001000E0004DF3O003B00012O00B700045O0006CB0004003B00013O0004DF3O003B00012O00B7000400014O0024010500023O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O00040002000200062O0004003B00013O0004DF3O003B00012O00B7000400014O0037000500023O00122O000600123O00122O000700136O0005000700024O00040004000500202O0004000400144O0004000200024O000500033O00202O0005000500154O0005000200020006730004003B000100050004DF3O003B00012O00B7000400044O00E7000500013O00202O0005000500164O000600066O00040006000200062O0004003B00013O0004DF3O003B00012O00B7000400023O0012FE000500173O0012FE000600184O00D8000400064O008800045O0012FE000100193O0004DF3O00910001002E19011B000B0001001A0004DF3O000B000100267E00030043000100010004DF3O00430001002E19011C000B0001001D0004DF3O000B0001002E15001E006D0001001F0004DF3O006D00012O00B7000400014O0024010500023O00122O000600203O00122O000700216O0005000700024O00040004000500202O0004000400114O00040002000200062O0004006D00013O0004DF3O006D00012O00B7000400033O0020C80004000400222O00090004000200022O00B7000500053O0006730004006D000100050004DF3O006D00012O00B7000400063O0006CB0004006D00013O0004DF3O006D00012O00B7000400033O0020A30004000400234O000600013O00202O0006000600244O00040006000200062O0004006D00013O0004DF3O006D00012O00B7000400044O0060000500013O00202O0005000500244O000600076O00040007000200062O00040068000100010004DF3O00680001002E150026006D000100250004DF3O006D00012O00B7000400023O0012FE000500273O0012FE000600284O00D8000400064O008800046O00B7000400014O0024010500023O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O00040004002B4O00040002000200062O0004008F00013O0004DF3O008F00012O00B7000400033O00204600040004002C4O000600013O00202O00060006002D00122O0007002E6O00040007000200062O0004008F00013O0004DF3O008F0001002E15002F008F000100300004DF3O008F0001002E190132008F000100310004DF3O008F00012O00B7000400044O00E7000500013O00202O0005000500334O000600066O00040006000200062O0004008F00013O0004DF3O008F00012O00B7000400023O0012FE000500343O0012FE000600354O00D8000400064O008800045O0012FE000300043O0004DF3O000B00010026FF000100082O0100010004DF3O00082O01002E19013700BC000100360004DF3O00BC00012O00B7000300073O0006390003009D000100010004DF3O009D00012O00B7000300083O0006390003009D000100010004DF3O009D0001002E6400380021000100390004DF3O00BC00010012FE000300014O00C9000400053O00267E000300A3000100010004DF3O00A30001002E15003B00A60001003A0004DF3O00A600010012FE000400014O00C9000500053O0012FE000300043O002E64003C00040001003C0004DF3O00AA0001000E5F000400AC000100030004DF3O00AC0001002E19013E009F0001003D0004DF3O009F0001002E19014000B00001003F0004DF3O00B0000100267E000400B2000100010004DF3O00B20001002E15004100AC0001001A0004DF3O00AC00012O00B7000600094O00170006000100022O003F000500063O0006CB000500BC00013O0004DF3O00BC00012O00DB000500023O0004DF3O00BC00010004DF3O00AC00010004DF3O00BC00010004DF3O009F0001002E6400420028000100420004DF3O00E400012O00B70003000A3O000639000300C3000100010004DF3O00C30001002E15003B00E4000100430004DF3O00E400010012FE000300014O00C9000400043O002E15004500C5000100440004DF3O00C50001000E48000100C5000100030004DF3O00C500010012FE000400013O002E15004700CA000100460004DF3O00CA00010026FF000400CA000100010004DF3O00CA00012O00B70005000B3O0020820005000500494O000600013O00202O00060006004A4O0007000C3O00202O00070007004B00122O0008004C6O00050008000200122O000500483O00122O000500483O00062O000500DE000100010004DF3O00DE0001002EC0004E00DE0001004D0004DF3O00DE0001002E64004F0008000100500004DF3O00E400010012B6000500484O00DB000500023O0004DF3O00E400010004DF3O00CA00010004DF3O00E400010004DF3O00C500012O00B70003000D3O0006CB000300072O013O0004DF3O00072O010012FE000300014O00C9000400043O00267E000300ED000100010004DF3O00ED0001002E64005100FEFF2O00520004DF3O00E900010012FE000400013O00267E000400F2000100010004DF3O00F20001002E15005300EE000100540004DF3O00EE00012O00B70005000B3O0020650005000500554O000600013O00202O0006000600564O0007000C3O00202O00070007005700122O000800586O000900016O00050009000200122O000500483O00122O000500483O00062O0005003O0100010004DF3O003O01002E15005900072O01005A0004DF3O00072O010012B6000500484O00DB000500023O0004DF3O00072O010004DF3O00EE00010004DF3O00072O010004DF3O00E900010012FE000100043O002E64005B00690001005B0004DF3O00712O01002E19015C00712O01005D0004DF3O00712O010026FF000100712O01005E0004DF3O00712O010012FE000300013O00267E000300132O0100010004DF3O00132O01002E150060004A2O01005F0004DF3O004A2O01000639000200172O0100010004DF3O00172O01002E15006100182O0100620004DF3O00182O012O00DB000200024O00B7000400014O0024010500023O00122O000600633O00122O000700646O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400332O013O0004DF3O00332O012O00B7000400033O0020A30004000400654O000600013O00202O0006000600664O00040006000200062O000400332O013O0004DF3O00332O012O00B7000400014O000D010500023O00122O000600673O00122O000700686O0005000700024O00040004000500202O0004000400694O000400020002000E2O000100352O0100040004DF3O00352O01002E19016A00492O01006B0004DF3O00492O012O00B7000400044O00EC000500013O00202O00050005006C4O000600076O0008000E3O00202O00080008006D4O000A00013O00202O000A000A006C4O0008000A00024O000800086O00040008000200062O000400442O0100010004DF3O00442O01002E15006E00492O01006F0004DF3O00492O012O00B7000400023O0012FE000500703O0012FE000600714O00D8000400064O008800045O0012FE000300043O002E190172004E2O0100730004DF3O004E2O0100267E000300502O0100040004DF3O00502O01002E64007400C1FF2O00750004DF3O000F2O01002E150077006E2O0100760004DF3O006E2O012O00B7000400014O0024010500023O00122O000600783O00122O000700796O0005000700024O00040004000500202O00040004002B4O00040002000200062O0004006E2O013O0004DF3O006E2O012O00B7000400044O00E4000500013O00202O00050005007A4O000600076O0008000E3O00202O00080008006D4O000A00013O00202O000A000A007A4O0008000A00024O000800086O0004000800020006CB0004006E2O013O0004DF3O006E2O012O00B7000400023O0012FE0005007B3O0012FE0006007C4O00D8000400064O008800045O0012FE0001007D3O0004DF3O00712O010004DF3O000F2O010026FF0001006F0201002E0004DF3O006F02010012FE000300013O002E19017F004D0201007E0004DF3O004D02010026FF0003004D020100010004DF3O004D0201002E15008100D22O0100800004DF3O00D22O012O00B700045O0006CB000400D22O013O0004DF3O00D22O012O00B7000400014O0024010500023O00122O000600823O00122O000700836O0005000700024O00040004000500202O0004000400114O00040002000200062O000400D22O013O0004DF3O00D22O012O00B7000400033O0020270104000400654O000600013O00202O00060006002D4O00040006000200062O000400982O0100010004DF3O00982O012O00B7000400014O009E000500023O00122O000600843O00122O000700856O0005000700024O00040004000500202O0004000400144O00040002000200262O000400D22O01002E0004DF3O00D22O012O00B70004000F4O001B000500023O00122O000600863O00122O000700876O00050007000200062O000400B42O0100050004DF3O00B42O01002E19018900AC2O0100880004DF3O00AC2O012O00B7000400104O00700005000C3O00202O00050005008A4O0006000E3O00202O00060006008B00122O0008008C6O0006000800024O000600066O00040006000200062O000400AE2O0100010004DF3O00AE2O01002E64008D00260001008E0004DF3O00D22O012O00B7000400023O0012BC0005008F3O00122O000600906O000400066O00045O00044O00D22O01002E15009200D22O0100910004DF3O00D22O012O00B70004000F4O001B000500023O00122O000600933O00122O000700946O00050007000200062O000400D22O0100050004DF3O00D22O01002E15009500D22O0100960004DF3O00D22O01002E19019700D22O0100980004DF3O00D22O012O00B7000400044O0020010500013O00202O0005000500994O000600076O0008000E3O00202O00080008008B00122O000A008C6O0008000A00024O000800086O00040008000200062O000400D22O013O0004DF3O00D22O012O00B7000400023O0012FE0005009A3O0012FE0006009B4O00D8000400064O008800046O00B7000400014O000D010500023O00122O0006009C3O00122O0007009D6O0005000700024O00040004000500202O0004000400694O000400020002000E2O000100E62O0100040004DF3O00E62O012O00B7000400014O00A5000500023O00122O0006009E3O00122O0007009F6O0005000700024O00040004000500202O0004000400144O000400020002000E2O005800ED2O0100040004DF3O00ED2O012O00B70004000F4O001B000500023O00122O000600A03O00122O000700A16O00050007000200062O00042O00020100050004DF4O0002012O00B7000400113O0026C500042O00020100580004DF4O0002012O00B7000400033O0020A30004000400654O000600013O00202O00060006002D4O00040006000200062O000400FE2O013O0004DF3O00FE2O012O00B70004000F4O0019000500023O00122O000600A23O00122O000700A36O00050007000200062O00042O00020100050004DF4O000201002E1500A4004C020100A50004DF3O004C02010012FE000400014O00C9000500053O002E1901A60006020100A70004DF3O0006020100267E00040008020100010004DF3O00080201002E1901A8002O020100590004DF3O002O02010012FE000500013O002E1901A90035020100AA0004DF3O0035020100267E0005000F020100010004DF3O000F0201002E1500AB0035020100AC0004DF3O003502010012FE000600014O00C9000700073O00267E00060015020100010004DF3O00150201002E6400AD00FEFF2O00AE0004DF3O001102010012FE000700013O002E1500AF001E020100B00004DF3O001E020100267E0007001C020100040004DF3O001C0201002E1901B2001E020100B10004DF3O001E02010012FE000500043O0004DF3O0035020100267E00070022020100010004DF3O00220201002E1500B30016020100B40004DF3O001602012O00B70008000B3O0020470008000800B54O000900126O000A5O00122O000B004C6O000C000C6O0008000C000200122O000800483O00122O000800483O00062O0008002F020100010004DF3O002F0201002E1901B70031020100B60004DF3O003102010012B6000800484O00DB000800023O0012FE000700043O0004DF3O001602010004DF3O003502010004DF3O001102010026FF00050009020100040004DF3O000902012O00B70006000B3O00200A0106000600B84O000700126O00085O00122O0009004C6O000A000A6O0006000A000200122O000600483O002E2O00B9004C020100BA0004DF3O004C0201002E1901BC004C020100BB0004DF3O004C02010012B6000600483O0006CB0006004C02013O0004DF3O004C02010012B6000600484O00DB000600023O0004DF3O004C02010004DF3O000902010004DF3O004C02010004DF3O002O02010012FE000300043O0026FF000300742O0100040004DF3O00742O012O00B70004000B3O0020A90004000400BD4O000500016O000600023O00122O000700BE3O00122O000800BF6O0006000800024O00050005000600202O0005000500694O000500020002000E2O00010069020100050004DF3O006902012O00B7000500014O000D010600023O00122O000700C03O00122O000800C16O0006000800024O00050005000600202O0005000500144O000500020002000E2O00580069020100050004DF3O006902012O00B7000500113O0026C500050069020100580004DF3O006902012O00D500056O0068000500014O00090004000200022O003F000200043O0012FE0001005E3O0004DF3O006F02010004DF3O00742O01002E1500C200FA020100C30004DF3O00FA02010026FF000100FA020100040004DF3O00FA02010012FE000300013O0026FF000300CC020100010004DF3O00CC02010012FE000400013O000E5F0004007D020100040004DF3O007D0201002EC000C4007D020100C50004DF3O007D0201002E1500C6007F020100C70004DF3O007F02010012FE000300043O0004DF3O00CC02010026FF00040077020100010004DF3O007702012O00B7000500133O0006CB000500A302013O0004DF3O00A302010012B6000500C84O00050105000100024O000600146O0005000500064O000600153O00062O0005008C020100060004DF3O008C02010004DF3O00A30201002E6400C90017000100C90004DF3O00A302012O00B7000500014O0024010600023O00122O000700CA3O00122O000800CB6O0006000800024O00050005000600202O00050005002B4O00050002000200062O000500A302013O0004DF3O00A302012O00B7000500104O00B7000600013O0020BF0006000600CC2O00090005000200020006CB000500A302013O0004DF3O00A302012O00B7000500023O0012FE000600CD3O0012FE000700CE4O00D8000500074O008800055O002E1500CF00CA020100D00004DF3O00CA02012O00B7000500163O0006CB000500CA02013O0004DF3O00CA02012O00B7000500033O0020C80005000500D12O00090005000200020006CB000500CA02013O0004DF3O00CA02010012FE000500014O00C9000600073O002E1901D200B3020100D30004DF3O00B3020100267E000500B5020100010004DF3O00B50201002E1901D400B8020100D50004DF3O00B802010012FE000600014O00C9000700073O0012FE000500043O00267E000500BC020100040004DF3O00BC0201002E1500D700AF020100D60004DF3O00AF02010026FF000600BC020100010004DF3O00BC02012O00B7000800174O00170008000100022O003F000700083O000639000700C5020100010004DF3O00C50201002E1901D800CA020100D90004DF3O00CA02012O00DB000700023O0004DF3O00CA02010004DF3O00BC02010004DF3O00CA02010004DF3O00AF02010012FE000400043O0004DF3O00770201002E1500DA0074020100DB0004DF3O007402010026FF00030074020100040004DF3O00740201002E6400DC0027000100DC0004DF3O00F702012O00B7000400014O0024010500023O00122O000600DD3O00122O000700DE6O0005000700024O00040004000500202O0004000400114O00040002000200062O000400E502013O0004DF3O00E502012O00B7000400033O0020C80004000400222O00090004000200022O00B7000500183O000673000400E5020100050004DF3O00E502012O00B7000400193O000639000400E7020100010004DF3O00E70201002E1500DF00F7020100E00004DF3O00F70201002E1901E100F7020100E20004DF3O00F702012O00B7000400044O0060000500013O00202O0005000500E34O000600076O00040007000200062O000400F2020100010004DF3O00F20201002E1901E500F7020100E40004DF3O00F702012O00B7000400023O0012FE000500E63O0012FE000600E74O00D8000400064O008800045O0012FE000100063O0004DF3O00FA02010004DF3O00740201002E1500E9004F040100E80004DF3O004F0401002E1901EB004F040100EA0004DF3O004F04010026FF0001004F0401007D0004DF3O004F04010012FE000300013O00267E00030007030100010004DF3O00070301002E3001ED0007030100EC0004DF3O00070301002E1500EE00DD030100EF0004DF3O00DD03010012FE000400013O002E1901F1000E030100F00004DF3O000E03010026FF0004000E030100040004DF3O000E03010012FE000300043O0004DF3O00DD0301002E1500F30008030100F20004DF3O00080301000E4800010008030100040004DF3O00080301002E1901F40042030100F50004DF3O004203012O00B7000500014O0024010600023O00122O000700F63O00122O000800F76O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005004203013O0004DF3O004203012O00B70005001A3O00201F0005000500F84O0005000100024O000600016O000700023O00122O000800F93O00122O000900FA6O0007000900024O00060006000700202O0006000600FB4O00060002000200202O00060006000600062O00050042030100060004DF3O00420301002E1500FD0042030100FC0004DF3O00420301002E1500FE0042030100FF0004DF3O004203012O00B7000500044O00E4000600013O00202O00060006006C4O000700086O0009000E3O00202O00090009006D4O000B00013O00202O000B000B006C4O0009000B00024O000900096O0005000900020006CB0005004203013O0004DF3O004203012O00B7000500023O0012FE00062O00012O0012FE0007002O013O00D8000500074O008800056O00B700055O0006CB0005008C03013O0004DF3O008C03012O00B70005001B3O0006CB0005008C03013O0004DF3O008C03012O00B7000500014O0024010600023O00122O00070002012O00122O00080003015O0006000800024O00050005000600202O0005000500114O00050002000200062O0005008C03013O0004DF3O008C03012O00B70005001C4O0023010600016O000700023O00122O00080004012O00122O00090005015O0007000900024O00060006000700202O0006000600144O0006000200024O000700016O000800023O0012FE00090006012O001298000A0007015O0008000A00024O00070007000800202O0007000700144O0007000200024O0006000600074O000700016O000800023O00122O00090008012O00122O000A0009013O00E50008000A00022O004C00070007000800202O0007000700144O000700086O00053O00024O0006001D6O000700016O000800023O00122O00090004012O00122O000A0005015O0008000A00022O00FC0007000700080020510007000700144O0007000200024O000800016O000900023O00122O000A0006012O00122O000B0007015O0009000B00024O00080008000900202O0008000800144O0008000200022O00D30007000700082O0030000800016O000900023O00122O000A0008012O00122O000B0009015O0009000B00024O00080008000900202O0008000800144O000800096O00063O00024O0005000500060012FE0006000A012O00062B01060094030100050004DF3O009403010012FE0005000B012O0012FE0006000C012O00065800050094030100060004DF3O009403010012FE0005000D012O0012FE0006000E012O0006CE000500DB030100060004DF3O00DB03010012FE0005000F012O0012FE00060010012O0006730005009B030100060004DF3O009B03012O00B70005001E3O0006390005009F030100010004DF3O009F03010012FE00050011012O0012FE00060012012O000673000600CE030100050004DF3O00CE03012O00B7000500033O0020900005000500654O000700013O00122O00080013015O0007000700084O00050007000200062O000500AB030100010004DF3O00AB03010012FE00050014012O0012FE00060015012O000628010600BD030100050004DF3O00BD03010012FE00050016012O0012FE00060017012O000673000600DB030100050004DF3O00DB03012O00B7000500044O0009010600013O00122O00070018015O0006000600074O000700076O00050007000200062O000500DB03013O0004DF3O00DB03012O00B7000500023O0012BC00060019012O00122O0007001A015O000500076O00055O00044O00DB03012O00B7000500044O0060000600013O00202O0006000600CC4O000700076O00050007000200062O000500C8030100010004DF3O00C803010012FE0005001B012O0012FE0006001C012O000628010500DB030100060004DF3O00DB03012O00B7000500023O0012BC0006001D012O00122O0007001E015O000500076O00055O00044O00DB03012O00B7000500044O0009010600013O00122O00070018015O0006000600074O000700076O00050007000200062O000500DB03013O0004DF3O00DB03012O00B7000500023O0012FE0006001F012O0012FE00070020013O00D8000500074O008800055O0012FE000400043O0004DF3O000803010012FE000400043O000658000400E4030100030004DF3O00E403010012FE00040021012O0012FE00050022012O00067300050001030100040004DF3O000103012O00B7000400014O0024010500023O00122O00060023012O00122O00070024015O0005000700024O00040004000500202O0004000400114O00040002000200062O0004004C04013O0004DF3O004C04012O00B7000400014O0018010500023O00122O00060025012O00122O00070026015O0005000700024O00040004000500122O00060027015O0004000400064O00040002000200062O0004004C040100010004DF3O004C04012O00B7000400033O00120B00060028015O0004000400064O000600013O00202O00060006002D4O0004000600024O000500033O00122O00070029015O00050005000700122O000700046O00050007000200062O0005004C040100040004DF3O004C04010012FE000400014O00C9000500063O0012FE0007002A012O0012FE0008002B012O00067300080016040100070004DF3O001604010012FE0007002C012O0012FE0008002D012O00067300080016040100070004DF3O001604010012FE000700013O0006CE00040016040100070004DF3O001604010012FE000500014O00C9000600063O0012FE000400043O0012FE000700043O0006580004001D040100070004DF3O001D04010012FE0007002E012O0012FE0008008E3O0006CE00070008040100080004DF3O000804010012FE0007002F012O0012FE00080030012O0006730007001D040100080004DF3O001D04010012FE000700013O0006CE0007001D040100050004DF3O001D04010012FE000600013O0012FE000700013O0006580006002C040100070004DF3O002C04010012FE00070031012O0012FE00080032012O00067300080025040100070004DF3O002504010012FE000700044O00260007001F3O0012FE00070033012O0012FE00080034012O0006280108004C040100070004DF3O004C04012O00B7000700204O0086000800013O00122O00090035015O0008000800094O00095O00122O000A0036015O000B000E3O00202O000B000B008B00122O000D0037015O000B000D00024O000B000B6O000C000C6O0007000C000200062O0007004C04013O0004DF3O004C04012O00B7000700023O0012BC00080038012O00122O00090039015O000700096O00075O00044O004C04010004DF3O002504010004DF3O004C04010004DF3O001D04010004DF3O004C04010004DF3O000804010012FE0001003A012O0004DF3O004F04010004DF3O000103010012FE0003003B012O0012FE0004003C012O00067300030084050100040004DF3O008405010012FE0003003A012O0006CE00010084050100030004DF3O008405010012FE000300014O00C9000400043O0012FE000500013O0006580003005F040100050004DF3O005F04010012FE0005003D012O0012FE0006003E012O00062801060058040100050004DF3O005804010012FE000400013O0012FE000500043O00065800040067040100050004DF3O006704010012FE0005003F012O0012FE000600393O00067300060094040100050004DF3O009404012O00B7000500014O0024010600023O00122O00070040012O00122O00080041015O0006000800024O00050005000600202O0005000500114O00050002000200062O0005009204013O0004DF3O009204012O00B7000500014O0018010600023O00122O00070042012O00122O00080043015O0006000800024O00050005000600122O00070027015O0005000500074O00050002000200062O00050092040100010004DF3O009204010012FE00050044012O0012FE00060045012O00062801060092040100050004DF3O009204012O00B7000500044O001B010600013O00122O00070046015O0006000600074O000700086O0009000E3O00202O00090009008B00122O000B008C6O0009000B00024O000900096O00050009000200062O0005009204013O0004DF3O009204012O00B7000500023O0012FE00060047012O0012FE00070048013O00D8000500074O008800055O0012FE00010049012O0004DF3O008405010012FE000500013O0006580004009B040100050004DF3O009B04010012FE0005004A012O0012FE0006004B012O00067300050060040100060004DF3O006004010012FE0005004C012O0012FE0006004D012O000628010500FD040100060004DF3O00FD04012O00B7000500014O0024010600023O00122O0007004E012O00122O0008004F015O0006000800024O00050005000600202O0005000500114O00050002000200062O000500FD04013O0004DF3O00FD04012O00B7000500014O001F010600023O00122O00070050012O00122O00080051015O0006000800024O00050005000600122O00070027015O0005000500074O00050002000200062O000500FD04013O0004DF3O00FD04012O00B7000500033O00129B00070028015O0005000500074O000700013O00202O00070007002D4O0005000700024O000600033O00122O00080029015O0006000600084O000800216O00060008000200062O000600FD040100050004DF3O00FD04010012FE000500014O00C9000600073O0012FE000800043O000658000500CA040100080004DF3O00CA04010012FE00080052012O0012FE00090053012O000628010900F6040100080004DF3O00F604010012FE000800013O0006CE000600CA040100080004DF3O00CA04010012FE000700013O0012FE00080054012O0012FE00090055012O000673000900CE040100080004DF3O00CE04010012FE000800013O0006CE000700CE040100080004DF3O00CE04012O00B7000800214O00260008001F4O00B7000800204O001E010900013O00122O000A0035015O00090009000A4O000A8O000B00216O000C000E3O00202O000C000C008B00122O000E0037015O000C000E00024O000C000C6O000D000D6O0008000D000200062O000800FD04013O0004DF3O00FD04012O00B7000800023O00123500090056012O00122O000A0057015O0008000A00024O000900216O000A00023O00122O000B0058012O00122O000C0059015O000A000C00024O00080008000A4O000800023O00044O00FD04010004DF3O00CE04010004DF3O00FD04010004DF3O00CA04010004DF3O00FD04010012FE000800013O0006CE000800C3040100050004DF3O00C304010012FE000600014O00C9000700073O0012FE000500043O0004DF3O00C304010012FE0005005A012O0012FE0006005B012O00067300060080050100050004DF3O008005012O00B7000500014O0024010600023O00122O0007005C012O00122O0008005D015O0006000800024O00050005000600202O0005000500114O00050002000200062O0005008005013O0004DF3O008005012O00B7000500033O00120B00070028015O0005000500074O000700013O00202O00070007002D4O0005000700024O000600033O00122O00080029015O00060006000800122O000800046O00060008000200062O00060080050100050004DF3O008005010012FE000500043O0012B60006005E012O0012FE000700043O00067300070030050100060004DF3O003005010012B60006005E012O0012FE0007002E3O00067300060030050100070004DF3O003005012O00B7000600033O00120B00080028015O0006000600084O000800013O00202O00080008002D4O0006000800024O000700033O00122O00090029015O00070007000900122O000900066O00070009000200062O00070030050100060004DF3O003005010012FE000500063O0004DF3O006505010012FE0006005F012O0012FE000700263O0006280106004B050100070004DF3O004B05010012B60006005E012O0012FE000700193O0006730007004B050100060004DF3O004B05010012B60006005E012O0012FE0007007D3O0006730006004B050100070004DF3O004B05012O00B7000600033O00120B00080028015O0006000600084O000800013O00202O00080008002D4O0006000800024O000700033O00122O00090029015O00070007000900122O000900196O00070009000200062O0007004B050100060004DF3O004B05010012FE000500193O0004DF3O006505010012FE00060060012O0012FE00070060012O0006CE00060065050100070004DF3O006505010012B60006005E012O0012FE0007005E3O00067300070060050100060004DF3O006005012O00B7000600033O0012F000080028015O0006000600084O000800013O00202O00080008002D4O0006000800024O000700033O00122O00090029015O0007000700094O000900216O00070009000200062O00070064050100060004DF3O006405010012FE00060061012O0012FE00070062012O00062801070065050100060004DF3O006505012O00B7000500214O0026000500224O00ED000600206O000700013O00122O00080063015O0007000700084O00088O000900056O000A000E3O00202O000A000A008B00122O000C0037015O000A000C00022O0031000A000A4O00C9000B000B4O00E50006000B00020006CB0006008005013O0004DF3O008005012O00B7000600023O00122200070064012O00122O00080065015O0006000800024O000700056O000800023O00122O00090066012O00122O000A0067015O0008000A00024O0006000600084O000600023O0012FE000400043O0004DF3O006004010004DF3O008405010004DF3O005804010012FE00030068012O0012FE00040069012O00067300030038060100040004DF3O003806010012FE00030049012O0006CE00010038060100030004DF3O003806010012FE0003006A012O0012FE0004006B012O000628010300D1050100040004DF3O00D105012O00B7000300014O0024010400023O00122O0005006C012O00122O0006006D015O0004000600024O00030003000400202O00030003002B4O00030002000200062O000300D105013O0004DF3O00D105012O00B7000300033O00122C00050028015O0003000300054O000500013O00202O00050005002D4O0003000500024O000400016O000500023O00122O0006006E012O00122O0007006F015O0005000700024O00040004000500202O0004000400FB4O00040002000200062O000400BF050100030004DF3O00BF05012O00B7000300033O00129F00050070015O0003000300054O0003000200024O000400016O000500023O00122O00060071012O00122O00070072015O0005000700024O00040004000500202O0004000400FB4O00040002000200062O000300BF050100040004DF3O00BF05012O00B7000300033O0020DC0003000300654O000500013O00122O00060073015O0005000500064O00030005000200062O000300D105013O0004DF3O00D105012O00B7000300044O001B010400013O00122O00050074015O0004000400054O000500066O0007000E3O00202O00070007008B00122O00090037015O0007000900024O000700076O00030007000200062O000300D105013O0004DF3O00D105012O00B7000300023O0012FE00040075012O0012FE00050076013O00D8000300054O008800035O0012FE00030077012O0012FE00040078012O000673000300F0050100040004DF3O00F005012O00B7000300014O0024010400023O00122O00050079012O00122O0006007A015O0004000600024O00030003000400202O0003000300114O00030002000200062O000300F005013O0004DF3O00F005012O00B7000300033O0012FE0005007B013O00310103000300052O00090003000200020006CB000300F405013O0004DF3O00F405012O00B7000300014O0018010400023O00122O0005007C012O00122O0006007D015O0004000600024O00030003000400122O00050027015O0003000300054O00030002000200062O000300F4050100010004DF3O00F405010012FE0003007E012O0012FE0004007F012O0006CE0003002O060100040004DF3O002O06012O00B7000300044O00E4000400013O00202O00040004006C4O000500066O0007000E3O00202O00070007006D4O000900013O00202O00090009006C4O0007000900024O000700076O0003000700020006CB0003002O06013O0004DF3O002O06012O00B7000300023O0012FE00040080012O0012FE00050081013O00D8000300054O008800035O0012FE00030082012O0012FE00040083012O0006280104001A080100030004DF3O001A08012O00B7000300014O0024010400023O00122O00050084012O00122O00060085015O0004000600024O00030003000400202O0003000300114O00030002000200062O0003001F06013O0004DF3O001F06012O00B7000300014O001F010400023O00122O00050086012O00122O00060087015O0004000600024O00030003000400122O00050027015O0003000300054O00030002000200062O0003002306013O0004DF3O002306010012FE00030088012O0012FE00040089012O0006280103001A080100040004DF3O001A08012O00B7000300044O006C000400013O00122O0005008A015O0004000400054O000500066O0007000E3O00202O00070007006D4O000900013O00122O000A008A015O00090009000A4O0007000900022O0031000700074O00E50003000700020006CB0003001A08013O0004DF3O001A08012O00B7000300023O0012BC0004008B012O00122O0005008C015O000300056O00035O00044O001A08010012FE000300193O0006580001003F060100030004DF3O003F06010012FE0003008D012O0012FE0004008E012O00062801030006000100040004DF3O000600010012FE000300014O00C9000400043O0012FE0005008F012O0012FE00060090012O00062801050041060100060004DF3O004106010012FE000500013O0006CE00030041060100050004DF3O004106010012FE000400013O0012FE00050091012O0012FE00060092012O0006280106007F070100050004DF3O007F07010012FE000500013O0006CE0004007F070100050004DF3O007F07010012FE000500013O0012FE00060093012O0012FE00070094012O0006730007005A060100060004DF3O005A06010012FE000600043O0006CE0005005A060100060004DF3O005A06010012FE000400043O0004DF3O007F07010012FE000600013O0006CE00050051060100060004DF3O005106012O00B7000600014O0024010700023O00122O00080095012O00122O00090096015O0007000900024O00060006000700202O0006000600114O00060002000200062O000600E606013O0004DF3O00E606012O00B7000600014O0018010700023O00122O00080097012O00122O00090098015O0007000900024O00060006000700122O00080027015O0006000600084O00060002000200062O000600E6060100010004DF3O00E606012O00B7000600014O001F010700023O00122O00080099012O00122O0009009A015O0007000900024O00060006000700122O00080027015O0006000600084O00060002000200062O000600E606013O0004DF3O00E606012O00B7000600014O0018010700023O00122O0008009B012O00122O0009009C015O0007000900024O00060006000700122O00080027015O0006000600084O00060002000200062O000600E6060100010004DF3O00E606012O00B7000600014O00BA000700023O00122O0008009D012O00122O0009009E015O0007000900024O00060006000700202O0006000600144O0006000200024O000700033O00122O00090029015O00070007000900122O000900046O00070009000200062O000600E6060100070004DF3O00E606012O00B7000600033O00120B00080028015O0006000600084O000800013O00202O00080008002D4O0006000800024O000700033O00122O00090029015O00070007000900122O000900046O00070009000200062O000700E6060100060004DF3O00E606010012FE000600014O00C9000700083O0012FE000900043O0006CE000600DF060100090004DF3O00DF06010012FE0009009F012O0012FE000A009F012O0006CE000900B00601000A0004DF3O00B006010012FE000900013O000658000700B4060100090004DF3O00B406010012FE000900A0012O0012FE000A00A1012O000628010900A90601000A0004DF3O00A906010012FE000800013O0012FE000900A2012O0012FE000A00A3012O000628010900B50601000A0004DF3O00B506010012FE000900013O000658000800C0060100090004DF3O00C006010012FE000900A4012O0012FE000A00A5012O000673000A00B5060100090004DF3O00B506010012FE000900044O00340009001F6O000900206O000A00013O00122O000B0035015O000A000A000B4O000B5O00122O000C0036015O000D000E3O00202O000D000D008B00122O000F0037015O000D000F00024O000D000D6O000E000E6O0009000E000200062O000900D5060100010004DF3O00D506010012FE000900A6012O0012FE000A00A7012O000673000900E60601000A0004DF3O00E606012O00B7000900023O0012BC000A00A8012O00122O000B00A9015O0009000B6O00095O00044O00E606010004DF3O00B506010004DF3O00E606010004DF3O00A906010004DF3O00E606010012FE000900013O0006CE000600A6060100090004DF3O00A606010012FE000700014O00C9000800083O0012FE000600043O0004DF3O00A606012O00B7000600014O0024010700023O00122O000800AA012O00122O000900AB015O0007000900024O00060006000700202O0006000600114O00060002000200062O0006002D07013O0004DF3O002D07012O00B7000600014O001F010700023O00122O000800AC012O00122O000900AD015O0007000900024O00060006000700122O00080027015O0006000600084O00060002000200062O0006002D07013O0004DF3O002D07012O00B7000600014O001F010700023O00122O000800AE012O00122O000900AF015O0007000900024O00060006000700122O00080027015O0006000600084O00060002000200062O0006002D07013O0004DF3O002D07012O00B7000600014O0018010700023O00122O000800B0012O00122O000900B1015O0007000900024O00060006000700122O00080027015O0006000600084O00060002000200062O0006002D070100010004DF3O002D07012O00B7000600014O0029000700023O00122O000800B2012O00122O000900B3015O0007000900024O00060006000700202O0006000600144O0006000200024O000700033O00122O00090029015O0007000700094O000900216O00070009000200062O0006002D070100070004DF3O002D07012O00B7000600033O0012F000080028015O0006000600084O000800013O00202O00080008002D4O0006000800024O000700033O00122O00090029015O0007000700094O000900216O00070009000200062O00070031070100060004DF3O003107010012FE000600B4012O0012FE000700B5012O0006280106007D070100070004DF3O007D07010012FE000600014O00C9000700083O0012FE000900013O0006580006003A070100090004DF3O003A07010012FE000900B6012O0012FE000A00B7012O000673000A003D070100090004DF3O003D07010012FE000700014O00C9000800083O0012FE000600043O0012FE000900043O00065800060048070100090004DF3O004807010012FE000900B8012O0012FE000A00B9012O00062B010A0048070100090004DF3O004807010012FE000900BA012O0012FE000A00BB012O000628010A0033070100090004DF3O003307010012FE000900013O0006580007004F070100090004DF3O004F07010012FE000900BC012O0012FE000A00BD012O000628010A0048070100090004DF3O004807010012FE000800013O0012FE000900013O00065800090057070100080004DF3O005707010012FE000900BE012O0012FE000A00BF012O000673000A0050070100090004DF3O005007012O00B7000900214O00260009001F3O0012FE000900C0012O0012FE000A00C0012O0006CE0009007D0701000A0004DF3O007D07012O00B7000900204O001E010A00013O00122O000B0035015O000A000A000B4O000B8O000C00216O000D000E3O00202O000D000D008B00122O000F0037015O000D000F00024O000D000D6O000E000E6O0009000E000200062O0009007D07013O0004DF3O007D07012O00B7000900023O001235000A00C1012O00122O000B00C2015O0009000B00024O000A00216O000B00023O00122O000C00C3012O00122O000D00C4015O000B000D00024O00090009000B4O000900023O00044O007D07010004DF3O005007010004DF3O007D07010004DF3O004807010004DF3O007D07010004DF3O003307010012FE000500043O0004DF3O005106010012FE000500043O00065800040086070100050004DF3O008607010012FE000500C5012O0012FE000600523O0006CE00050049060100060004DF3O004906012O00B7000500014O0024010600023O00122O000700C6012O00122O000800C7015O0006000800024O00050005000600202O0005000500114O00050002000200062O000500C207013O0004DF3O00C207012O00B7000500014O001F010600023O00122O000700C8012O00122O000800C9015O0006000800024O00050005000600122O00070027015O0005000500074O00050002000200062O000500C207013O0004DF3O00C207012O00B7000500014O0018010600023O00122O000700CA012O00122O000800CB015O0006000800024O00050005000600122O00070027015O0005000500074O00050002000200062O000500C2070100010004DF3O00C207012O00B7000500014O00BA000600023O00122O000700CC012O00122O000800CD015O0006000800024O00050005000600202O0005000500144O0005000200024O000600033O00122O00080029015O00060006000800122O000800046O00060008000200062O000500C2070100060004DF3O00C207012O00B7000500033O00121E00070028015O0005000500074O000700013O00202O00070007002D4O0005000700024O000600033O00122O00080029015O00060006000800122O000800046O00060008000200062O000600C6070100050004DF3O00C607010012FE000500CE012O0012FE000600CF012O0006730005002O080100060004DF3O002O08010012FE000500014O00C9000600073O0012FE000800013O0006CE000500CE070100080004DF3O00CE07010012FE000600014O00C9000700073O0012FE000500043O0012FE000800043O000658000500D5070100080004DF3O00D507010012FE000800D0012O0012FE000900D1012O000673000800C8070100090004DF3O00C807010012FE000800D2012O0012FE000900D2012O0006CE000800DC070100090004DF3O00DC07010012FE000800013O000658000600E0070100080004DF3O00E007010012FE000800D3012O0012FE000900D4012O000628010800D5070100090004DF3O00D507010012FE000700013O0012FE000800D5012O0012FE000900D6012O000628010900E1070100080004DF3O00E107010012FE000800013O0006CE000700E1070100080004DF3O00E107010012FE000800044O0026000800223O0012FE000800D7012O0012FE000900D8012O0006730008002O080100090004DF3O002O08012O00B7000800204O0086000900013O00122O000A0063015O00090009000A4O000A5O00122O000B0036015O000C000E3O00202O000C000C008B00122O000E0037015O000C000E00024O000C000C6O000D000D6O0008000D000200062O0008002O08013O0004DF3O002O08012O00B7000800023O0012BC000900D9012O00122O000A00DA015O0008000A6O00085O00044O002O08010004DF3O00E107010004DF3O002O08010004DF3O00D507010004DF3O002O08010004DF3O00C807010012FE0001002E3O0004DF3O000600010004DF3O004906010004DF3O000600010004DF3O004106010004DF3O000600010004DF3O001A08010012FE000300013O0006583O0016080100030004DF3O001608010012FE000300DB012O0012FE000400DC012O0006CE00030002000100040004DF3O000200010012FE000100014O00C9000200023O0012FE3O00043O0004DF3O000200012O0034012O00017O0003012O00028O00025O006CA340025O009CAA40026O00F03F025O001EB240025O007CAE40025O00108040025O000EA240026O001C40025O00309140025O00309440025O0044A440025O00BC9640025O00C1B140025O0098B040025O00188140025O006EAB40025O006C9A40025O00A07340025O00A8A040030C3O004570696353652O74696E677303083O00CF52E9415A74FB4403063O001A9C379D353303113O00B9CB13F6A8409EDD05CAB15E8BEA19D8AA03063O0030ECB876B9D803083O00D6B84324C63AE2AE03063O005485DD3750AF03103O0088F42194C252B8F02DA8C07EB1E63EA303063O003CDD8744C6A7027O0040026O002040025O00208D40025O00D88740025O002FB04003083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030F3O006AC059FF543AF95FE75BFB5936DF6803073O009738A5379A235303083O00934611FAA94D02FD03043O008EC0236503113O00E3662C8CE59FA512DF742790E48DA013C503083O0076B61549C387ECCC026O000840025O001C934003083O003B5C1D4B01570E4C03043O003F683969030A3O003E94A1760A84AD45079403043O00246BE7C403083O006EB0B69354BBA59403043O00E73DD5C203103O003CBE385B0CAC317A07AA0D7C1DA4327D03043O001369CD5D025O00F6A640025O000EB140025O001AA740025O00AAA340026O001040025O0002AF40025O0092AC4003083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB703103O00CF11D4F88DAFE410F416D4FD8FA4D80503083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD38403103O0010807E4DD3A3B0FA3982684CDDA29CE803083O00B855ED1B3FB2CFD4026O00144003083O0073ADB3F7194EAFB403053O007020C8C783030B3O0008594FA8C6A70039565AAB03073O00424C303CD8A3CB03083O0089836DE756C023A903073O0044DAE619933FAE030E3O0098395664B3AC264744A5B9255D4903053O00D6CD4A332C026O001840025O00788540025O0015B040025O008C9540025O00D89640025O00FEB140025O002OAE40025O00407240025O00A89840025O00A08F4003083O00C949F6E87EF44BF103053O00179A2C829C030D3O0039A3ACA2221B02B2A2A0333B2103063O007371C6CDCE5603083O00B752EA4E8D59F94903043O003AE4379E030F3O009C88DE2A30A814B28FDC273FB930B003073O0055D4E9B04E5CCD025O00889C40025O00BEA240025O0074AA40025O00AEB040025O009C9840025O0028AB40025O005DB240025O00789F40025O00405F4003083O00795D9CF643568FF103043O00822A38E803113O00C2B42AE74C3AC3BB27EC522FE5A721E24C03063O005F8AD544832003083O00192DB5577F242FB203053O00164A48C12303113O000577F05D3E6BF148384EED4C244AF04D2203043O00384C1984025O004DB040025O00349D4003083O006DC4BF32C650C6B803053O00AF3EA1CB4603163O0015D3D716272EC8D3071A32D1DA243D35C9C61F3C2FC903053O00555CBDA37303083O001AA9242C20A2372B03043O005849CC5003123O00078D04433BC83B93047221C82B90184925DE03063O00BA4EE370264903083O009A0DCA9536A70FCD03053O005FC968BEE103113O0087CEC0C2A6C5C6FEA0DFC8C1A1E5C0C3AA03043O00AECFABA1034O0003083O00DEFB19E7F1D9EAED03063O00B78D9E6D9398030F3O00040CE7002507E13C231DEF032221D603043O006C4C698603083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103163O0096A0E7E3CA06636BAABDE5EEC037787D81A1EDCFDC0603083O0018C3D382A1A6631003083O007506FD385A18411003063O00762663894C33030D3O00D92F16020C2CD9232O070F26EE03063O00409D46657269025O0016B140025O0022AD40025O00D07740025O00F8AD40025O004AB340025O00B4944003083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC030F3O000C57D9A7F974083246D99AFB70086F03073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A351030F3O002A5026B03C40E00019470DA2324CB103083O006E7A2243C35F2985025O00E0A940025O0012A94003083O0046B44F5EDF7BB64803053O00B615D13B2A03133O008152D71920B0A372C81F33BFB452F00E20B9B203063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03133O00808700DC787AA1A809C16A65AA8730DD7871A003063O0016C5EA65AE19025O00489240026O002O40025O0050AA40025O0080874003083O00F871D1235B2D1ED803073O0079AB14A557324303113O00F537AC24BA07E93E9437BE0BC516B83BBC03063O0062A658D956D903083O00C5F36D158FD2F1E503063O00BC2O961961E6030F3O00EA9B5A110FE4DF875C0739FEDB8E5A03063O008DBAE93F626C025O0034AE40025O00E4A640025O002EB040025O00388240025O00A06040025O00989640025O00D2AD4003083O00C2EF38A22CFFED3F03053O0045918A4CD6030F3O0040DD8C9ABC1F75C18A8C91177DCAD803063O007610AF2OE9DF03083O00B88121AFE7857A9803073O001DEBE455DB8EEB030F3O000DC6BFCE7447225C3ED194DC7A4B7503083O00325DB4DABD172E47025O008AA240025O004CB140025O00C07F40025O001CB240026O007B40025O00B09440025O00C09640025O0080B04003083O003B390E540D03FA1B03073O009D685C7A20646D03103O008CA4DCC3392E8CA590A5CEC63834A59B03083O00CBC3C6AFAA5D47ED03083O001D4E2AC1581FFB3D03073O009C4E2B5EB5317103113O0050FAC1A21F4B7674CDCBAD18766A73EFC103073O00191288A4C36B23025O00107A40025O0059B040025O00889A40025O00A0A240025O00307C40025O0060A240026O002240025O002EA540025O00C8AD4003083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA103103O0018FF2EF207CA873FD822D70DEF8924FC03073O00E24D8C4BBA68BC03083O008ACBC42B46B7C9C303053O002FD9AEB05F030B3O008DCE7336BB597D15B3D46603083O0046D8BD1662D23418025O00349540025O009EA54003083O00305AD7EF0A51C4E803043O009B633FA303153O00A0DDA89EAD8190D8AF2O8A8783DDA49E8C9783D6A403063O00E4E2B1C1EDD903083O0007B537F23DBE24F503043O008654D04303173O0031A08F4F07A994551DABB55F12A0834F21A9804E16BF8E03043O003C73CCE6025O00D09640025O0064AA40025O00508740025O0046A24003083O00D43FFF64EE34EC6303043O0010875A8B03143O0076780F205A516A5D7A01004D557451672832435103073O0018341466532E3403013O003003083O00F72A353006CA283203053O006FA44F414403123O00F5D696CC2DEFE9DFAEDF29E3C5EC90DF29EF03063O008AA6B9E3BE4E025O00F8AA40025O0078AB4003083O00E9DAB793DAD4D8B003053O00B3BABFC3E703083O00CC2C1DCCF6291DF603043O0084995F7803083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA03093O00C80C34ECEDF0E90E2703063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E989030E3O0095B2A91B9BFFF9BDB6920C89F4F503073O0090D9D3C77FE8930033032O0012FE3O00014O00C9000100023O002E1500020009000100030004DF3O000900010026FF3O0009000100010004DF3O000900010012FE000100014O00C9000200023O0012FE3O00043O00267E3O000F000100040004DF3O000F0001002EC00005000F000100060004DF3O000F0001002E1500080002000100070004DF3O00020001000E480001000F000100010004DF3O000F00010012FE000200013O00267E00020016000100090004DF3O00160001002E15000B00710001000A0004DF3O007100010012FE000300014O00C9000400043O002E19010D00180001000C0004DF3O001800010026FF00030018000100010004DF3O001800010012FE000400013O002E19010F00480001000E0004DF3O0048000100267E00040023000100010004DF3O00230001002E1901110048000100100004DF3O004800010012FE000500013O002E640012001F000100120004DF3O0043000100267E0005002A000100010004DF3O002A0001002E1901140043000100130004DF3O004300010012B6000600154O0063000700013O00122O000800163O00122O000900176O0007000900024O0006000600074O000700013O00122O000800183O00122O000900196O0007000900022O00FC0006000600072O002600065O0012B6000600154O0063000700013O00122O0008001A3O00122O0009001B6O0007000900024O0006000600074O000700013O00122O0008001C3O00122O0009001D6O0007000900022O00FC0006000600072O0026000600023O0012FE000500043O0026FF00050024000100040004DF3O002400010012FE000400043O0004DF3O004800010004DF3O002400010026FF0004004C0001001E0004DF3O004C00010012FE0002001F3O0004DF3O00710001002E6400200004000100200004DF3O00500001000E5F00040052000100040004DF3O00520001002E190122001D000100210004DF3O001D00010012B6000500154O0063000600013O00122O000700233O00122O000800246O0006000800024O0005000500064O000600013O00122O000700253O00122O000800266O0006000800022O00FC00050005000600063900050060000100010004DF3O006000010012FE000500014O0026000500033O0012E1000500156O000600013O00122O000700273O00122O000800286O0006000800024O0005000500064O000600013O00122O000700293O00122O0008002A6O0006000800024O0005000500064O000500043O00122O0004001E3O00044O001D00010004DF3O007100010004DF3O001800010026FF000200C30001002B0004DF3O00C300010012FE000300014O00C9000400043O002E64002C3O0001002C0004DF3O007500010026FF00030075000100010004DF3O007500010012FE000400013O0026FF00040095000100040004DF3O009500010012B6000500154O0063000600013O00122O0007002D3O00122O0008002E6O0006000800024O0005000500064O000600013O00122O0007002F3O00122O000800306O0006000800022O00FC0005000500062O0026000500053O0012B6000500154O0063000600013O00122O000700313O00122O000800326O0006000800024O0005000500064O000600013O00122O000700333O00122O000800346O0006000800022O00FC0005000500062O0026000500063O0012FE0004001E3O00267E0004009B0001001E0004DF3O009B0001002E040135009B000100360004DF3O009B0001002E190137009D000100380004DF3O009D00010012FE000200393O0004DF3O00C3000100267E000400A1000100010004DF3O00A10001002E15003A007A0001003B0004DF3O007A00010012B6000500154O0063000600013O00122O0007003C3O00122O0008003D6O0006000800024O0005000500064O000600013O00122O0007003E3O00122O0008003F6O0006000800022O00FC000500050006000639000500AF000100010004DF3O00AF00010012FE000500014O0026000500073O0012A7000500156O000600013O00122O000700403O00122O000800416O0006000800024O0005000500064O000600013O00122O000700423O00122O000800436O0006000800024O00050005000600062O000500BE000100010004DF3O00BE00010012FE000500014O0026000500083O0012FE000400043O0004DF3O007A00010004DF3O00C300010004DF3O007500010026FF000200162O0100440004DF3O00162O010012FE000300013O0026FF000300E1000100010004DF3O00E100010012B6000400154O0063000500013O00122O000600453O00122O000700466O0005000700024O0004000400054O000500013O00122O000600473O00122O000700486O0005000700022O00FC0004000400052O0026000400093O0012B6000400154O0063000500013O00122O000600493O00122O0007004A6O0005000700024O0004000400054O000500013O00122O0006004B3O00122O0007004C6O0005000700022O00FC0004000400052O00260004000A3O0012FE000300043O0026FF000300E50001001E0004DF3O00E500010012FE0002004D3O0004DF3O00162O01002E19014E00C60001004F0004DF3O00C6000100267E000300EB000100040004DF3O00EB0001002E64005000DDFF2O00510004DF3O00C600010012FE000400013O000E5F000400F0000100040004DF3O00F00001002E15005200F2000100530004DF3O00F200010012FE0003001E3O0004DF3O00C60001002E64005400FAFF2O00540004DF3O00EC000100267E000400F8000100010004DF3O00F80001002E15005500EC000100560004DF3O00EC00010012B6000500154O0063000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O000600013O00122O000700593O00122O0008005A6O0006000800022O00FC000500050006000639000500062O0100010004DF3O00062O010012FE000500014O00260005000B3O0012E1000500156O000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500064O000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O0005000C3O00122O000400043O00044O00EC00010004DF3O00C60001002E64005F00530001005F0004DF3O00692O0100267E0002001C2O01004D0004DF3O001C2O01002E19016100692O0100600004DF3O00692O010012FE000300014O00C9000400043O002E190163001E2O0100620004DF3O001E2O0100267E000300242O0100010004DF3O00242O01002E190165001E2O0100640004DF3O001E2O010012FE000400013O002E15006700422O0100660004DF3O00422O01000E48000100422O0100040004DF3O00422O010012B6000500154O0063000600013O00122O000700683O00122O000800696O0006000800024O0005000500064O000600013O00122O0007006A3O00122O0008006B6O0006000800022O00FC0005000500062O00260005000D3O0012B6000500154O0063000600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000600013O00122O0007006E3O00122O0008006F6O0006000800022O00FC0005000500062O00260005000E3O0012FE000400043O0026FF000400462O01001E0004DF3O00462O010012FE000200093O0004DF3O00692O01002E15007100252O0100700004DF3O00252O010026FF000400252O0100040004DF3O00252O010012B6000500154O0063000600013O00122O000700723O00122O000800736O0006000800024O0005000500064O000600013O00122O000700743O00122O000800756O0006000800022O00FC0005000500062O00260005000F3O0012A7000500156O000600013O00122O000700763O00122O000800776O0006000800024O0005000500064O000600013O00122O000700783O00122O000800796O0006000800024O00050005000600062O000500642O0100010004DF3O00642O010012FE000500014O0026000500103O0012FE0004001E3O0004DF3O00252O010004DF3O00692O010004DF3O001E2O010026FF000200A22O0100390004DF3O00A22O010012B6000300154O0063000400013O00122O0005007A3O00122O0006007B6O0004000600024O0003000300044O000400013O00122O0005007C3O00122O0006007D6O0004000600022O00FC000300030004000639000300792O0100010004DF3O00792O010012FE0003007E4O0026000300113O0012A7000300156O000400013O00122O0005007F3O00122O000600806O0004000600024O0003000300044O000400013O00122O000500813O00122O000600826O0004000600024O00030003000400062O000300882O0100010004DF3O00882O010012FE000300014O0026000300123O00128B000300156O000400013O00122O000500833O00122O000600846O0004000600024O0003000300044O000400013O00122O000500853O00122O000600866O0004000600024O0003000300044O000300133O00122O000300156O000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000400013O00122O000500893O00122O0006008A6O0004000600024O0003000300044O000300143O00122O000200443O00267E000200A82O01001E0004DF3O00A82O01002E30018B00A82O01008C0004DF3O00A82O01002E15008E00F62O01008D0004DF3O00F62O010012FE000300013O00267E000300AD2O0100010004DF3O00AD2O01002E15008F00CC2O0100900004DF3O00CC2O010012B6000400154O0063000500013O00122O000600913O00122O000700926O0005000700024O0004000400054O000500013O00122O000600933O00122O000700946O0005000700022O00FC000400040005000639000400BB2O0100010004DF3O00BB2O010012FE0004007E4O0026000400153O0012A7000400156O000500013O00122O000600953O00122O000700966O0005000700024O0004000400054O000500013O00122O000600973O00122O000700986O0005000700024O00040004000500062O000400CA2O0100010004DF3O00CA2O010012FE0004007E4O0026000400163O0012FE000300043O00267E000300D02O0100040004DF3O00D02O01002E15009900EF2O01009A0004DF3O00EF2O010012B6000400154O0063000500013O00122O0006009B3O00122O0007009C6O0005000700024O0004000400054O000500013O00122O0006009D3O00122O0007009E6O0005000700022O00FC000400040005000639000400DE2O0100010004DF3O00DE2O010012FE0004007E4O0026000400173O0012A7000400156O000500013O00122O0006009F3O00122O000700A06O0005000700024O0004000400054O000500013O00122O000600A13O00122O000700A26O0005000700024O00040004000500062O000400ED2O0100010004DF3O00ED2O010012FE0004007E4O0026000400183O0012FE0003001E3O002E1500A400A92O0100A30004DF3O00A92O010026FF000300A92O01001E0004DF3O00A92O010012FE0002002B3O0004DF3O00F62O010004DF3O00A92O0100267E000200FA2O0100040004DF3O00FA2O01002E1500A5004A020100A60004DF3O004A02010012FE000300013O0026FF0003001C020100010004DF3O001C02010012B6000400154O0063000500013O00122O000600A73O00122O000700A86O0005000700024O0004000400054O000500013O00122O000600A93O00122O000700AA6O0005000700022O00FC0004000400050006390004000B020100010004DF3O000B02010012FE0004007E4O0026000400193O0012A7000400156O000500013O00122O000600AB3O00122O000700AC6O0005000700024O0004000400054O000500013O00122O000600AD3O00122O000700AE6O0005000700024O00040004000500062O0004001A020100010004DF3O001A02010012FE0004007E4O00260004001A3O0012FE000300043O002E6400AF0008000100AF0004DF3O0024020100267E000300220201001E0004DF3O00220201002E1901B10024020100B00004DF3O002402010012FE0002001E3O0004DF3O004A0201002E1500B30028020100B20004DF3O0028020100267E0003002A020100040004DF3O002A0201002E6400B400D3FF2O00B50004DF3O00FB2O010012B6000400154O0063000500013O00122O000600B63O00122O000700B76O0005000700024O0004000400054O000500013O00122O000600B83O00122O000700B96O0005000700022O00FC00040004000500063900040038020100010004DF3O003802010012FE0004007E4O00260004001B3O0012A7000400156O000500013O00122O000600BA3O00122O000700BB6O0005000700024O0004000400054O000500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500062O00040047020100010004DF3O004702010012FE0004007E4O00260004001C3O0012FE0003001E3O0004DF3O00FB2O0100267E0002004E0201001F0004DF3O004E0201002E1500BF00A8020100BE0004DF3O00A802010012FE000300013O002E1901C00084020100C10004DF3O00840201002E6400C20033000100C20004DF3O008402010026FF00030084020100010004DF3O008402010012FE000400013O002E6400C30025000100C30004DF3O007B0201002E1500C4007B020100C50004DF3O007B02010026FF0004007B020100010004DF3O007B02010012B6000500154O0063000600013O00122O000700C63O00122O000800C76O0006000800024O0005000500064O000600013O00122O000700C83O00122O000800C96O0006000800022O00FC0005000500060006390005006A020100010004DF3O006A02010012FE000500014O00260005001D3O0012A7000500156O000600013O00122O000700CA3O00122O000800CB6O0006000800024O0005000500064O000600013O00122O000700CC3O00122O000800CD6O0006000800024O00050005000600062O00050079020100010004DF3O007902010012FE0005007E4O00260005001E3O0012FE000400043O002E1901CE0056020100CF0004DF3O0056020100267E00040081020100040004DF3O00810201002E1500D10056020100D00004DF3O005602010012FE000300043O0004DF3O008402010004DF3O00560201002E1500D2008A020100D30004DF3O008A02010026FF0003008A0201001E0004DF3O008A02010012FE000200D43O0004DF3O00A80201002E1901D5004F020100D60004DF3O004F02010026FF0003004F020100040004DF3O004F02010012B6000400154O0063000500013O00122O000600D73O00122O000700D86O0005000700024O0004000400054O000500013O00122O000600D93O00122O000700DA6O0005000700022O00FC0004000400052O00260004001F3O0012E1000400156O000500013O00122O000600DB3O00122O000700DC6O0005000700024O0004000400054O000500013O00122O000600DD3O00122O000700DE6O0005000700024O0004000400054O000400203O00122O0003001E3O00044O004F02010026FF00022O00030100010004DF4O0003010012FE000300014O00C9000400043O002E1901DF00AC020100E00004DF3O00AC0201000E48000100AC020100030004DF3O00AC02010012FE000400013O000E48000100D2020100040004DF3O00D202010012B6000500154O0063000600013O00122O000700E13O00122O000800E26O0006000800024O0005000500064O000600013O00122O000700E33O00122O000800E46O0006000800022O00FC000500050006000639000500C1020100010004DF3O00C102010012FE0005007E4O0026000500213O0012A7000500156O000600013O00122O000700E53O00122O000800E66O0006000800024O0005000500064O000600013O00122O000700E73O00122O000800E86O0006000800024O00050005000600062O000500D0020100010004DF3O00D002010012FE000500014O0026000500223O0012FE000400043O002E1901E900F7020100EA0004DF3O00F7020100267E000400D8020100040004DF3O00D80201002E1500EC00F7020100EB0004DF3O00F702010012B6000500154O0063000600013O00122O000700ED3O00122O000800EE6O0006000800024O0005000500064O000600013O00122O000700EF3O00122O000800F06O0006000800022O00FC000500050006000639000500E6020100010004DF3O00E602010012FE000500F14O0026000500233O0012A7000500156O000600013O00122O000700F23O00122O000800F36O0006000800024O0005000500064O000600013O00122O000700F43O00122O000800F56O0006000800024O00050005000600062O000500F5020100010004DF3O00F502010012FE0005007E4O0026000500243O0012FE0004001E3O00267E000400FB0201001E0004DF3O00FB0201002E1901F700B1020100F60004DF3O00B102010012FE000200043O0004DF4O0003010004DF3O00B102010004DF4O0003010004DF3O00AC02010026FF00020012000100D40004DF3O001200010012B6000300154O0063000400013O00122O000500F83O00122O000600F96O0004000600024O0003000300044O000400013O00122O000500FA3O00122O000600FB6O0004000600022O00FC0003000300042O0026000300253O0012A7000300156O000400013O00122O000500FC3O00122O000600FD6O0004000600024O0003000300044O000400013O00122O000500FE3O00122O000600FF6O0004000600024O00030003000400062O0003001C030100010004DF3O001C03010012FE000300014O0026000300263O0012A7000300156O000400013O00122O00052O00012O00122O0006002O015O0004000600024O0003000300044O000400013O00122O00050002012O00122O00060003015O0004000600024O00030003000400062O0003002B030100010004DF3O002B03010012FE0003007E4O0026000300273O0004DF3O003203010004DF3O001200010004DF3O003203010004DF3O000F00010004DF3O003203010004DF3O000200012O0034012O00017O009F012O00028O00025O0074A740025O00F08B40026O001040025O0052AE40025O00889D40030D3O00546172676574497356616C6964025O00C0A140025O0098AC40026O00F03F027O0040025O00809540025O00209040025O00DCA740025O00089E40025O00F6A240030F3O00412O66656374696E67436F6D626174025O005DB040025O00BCA340025O0046AB40025O0082AA40025O008C9340025O00449740025O005AAE40025O00D8B040030C3O0049734368612O6E656C696E67030A3O0046697265427265617468025O002OA040025O00689B40025O00F08440025O00AC9B40025O00CC9640025O00907440025O00E8B140025O0090A94003073O0047657454696D6503093O00436173745374617274025O00BCA640025O00609140030F3O00456D706F7765724361737454696D65025O00188240025O00FCB140025O00F89F40025O007AB040025O0070A340025O00508940030D3O00DAF0BBBA2O3BEBF4BBB70F2DCC03063O005E9F80D2D968025O00408F4003143O0063ED09AF4F76F77D10DF0FAD5A3FDB6855F812B703083O001A309966DF3F1F99025O004C9040025O00CCAB40026O000840025O00BAB240025O00D8AB40025O00C05140025O00507040025O00206140025O00D2A540025O00688440025O008C9A4003093O00497343617374696E67025O00ACA340025O00D4A740025O00888140025O00788C40025O00C7B240025O00206640025O00288540025O002FB040025O009EAC40025O00F88A40025O0064AF40025O0052B240025O0046B140025O00E8A14003093O00496E74652O7275707403053O005175652O6C026O002440025O00807840025O00B8A040030E3O005175652O6C4D6F7573656F766572025O00B3B140025O0042A840025O0074AA40025O00F8A340025O0044B340025O00308C4003113O00496E74652O72757074576974685374756E03093O005461696C5377697065026O002040025O002EAE40025O00707F40025O00449640025O0006A940025O001AA140025O00E88E40025O0095B040025O0007B340026O002E40025O00607840025O00A6A340025O00D0A140025O0080A740025O00E2A340025O00D49A40025O00707240025O00388840025O00DCB240025O0096A740030B3O001037128F2C3A0097373C1603043O00E358527303073O004973526561647903103O004865616C746850657263656E74616765030B3O004865616C746873746F6E6503173O004B1ABBAB167B500BB5A90733471ABCA20C604A09BFE75103063O0013237FDAC762025O001BB240025O00805D40025O00289340025O0040A94003193O002EFE0CF019E802EB12FC4ACA19FA06EB12FC4AD213EF03ED1203043O00827C9B6A025O006EAD40025O0010864003173O00E7CEF0BDA6E574B6DBCCDEAAA2FA75B1D2FBF9BBAAF97203083O00DFB5AB96CFC3961C025O00B8A940025O000C9740025O001AA240025O00CCA04003173O0052656672657368696E674865616C696E67506F74696F6E03253O005E3FE5BC0C5F32EAA00E0C32E6AF054534E4EE19432EEAA1070C3EE6A80C4229EAB82O0C6E03053O00692C5A83CE025O0098A840025O00188740025O00A5B240025O00FC9440025O00E0B140025O003AB24003083O00557068656176616C025O0006AE40025O00ACA740025O005C9B40025O00E09740025O00688D40025O00ABB040025O00B4A340025O00C09840025O005AA940025O00D89740025O00C09340025O006AB140025O0014A740025O0048AB40025O00208E40030D3O002750E4F03145F9E70B4EEAE03103043O009362208D025O00488F4003113O002B57ECDA165F451F03D6DA0E534A0E42EF03073O002B782383AA663603043O00502O6F6C03043O006327AE8203073O00E43466E7D6C5D0025O0040A040025O00307D4003093O00576169742F502O6F6C026O004D40025O00508340030C3O004570696353652O74696E677303073O00CC20392FD9401103083O0024984F5E48B525622O033O00D8D74403043O005FB7B82703073O008130E02158851103073O0062D55F874634E02O033O00FFACCC03053O00349EC3A91703073O004EB335738A306803083O00EB1ADC5214E6551B2O033O008BA5FA03053O0014E8C189A2025O004CA540025O00E2B140025O00D88B40025O008EAC40030D3O004973446561644F7247686F7374025O000FB240025O00E09B40025O00108140025O00BC904003073O007613646634540E03053O005A336B141303173O0044697370652O6C61626C65467269656E646C79556E6974025O00FEB240025O0072AC40025O00BFB040025O004CAC40025O0044A640025O00288F4003093O00466F637573556E6974026O003E40026O004140025O0012A440025O0054B040025O0096B140030F3O00CDF68AFD7DA9F996FF3881FC8CE13A03053O005DED90E58F030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C0724003043O0034E3E41603063O0026759690796B030D3O001EB4FB282EBEE13C00BAE9332E03043O005A4DDB8E030A3O0049734361737461626C65025O00A06240025O00E88B40025O00349040025O00489B40025O0078A640025O00AC9440030C3O0053686F756C6452657475726E03083O00A6022E2B0C3475CB03073O001A866441592C67025O00B89F40025O00E09F40025O00508540025O00D07040025O009CA240025O00208A40025O0024B04003043O004755494403123O00466F637573537065636966696564556E6974026O003940025O005AA740025O009C904003043O00D0F6242C03053O00C49183504303093O0042752O66537461636B03143O00426C6973746572696E675363616C657342752O6603103O003CBC0F1B0CED0CB9080F2BEB1FBC031B03063O00887ED0666878025O0034AD40025O00D8AC40025O00CCA240025O002AA940025O00DCAD40025O00B88940025O00DEAB40025O006BB140025O0062B340025O0094A840025O00109D40025O0022A040025O00B07D40025O0032B040025O0096A040025O001EB340025O00405E40025O00206040025O0014A040025O005EB340030F3O00388CC151EF7031586B9ECB51A65C3A03083O003118EAAE23CF325D025O007C9B40025O0046AC4003083O0029E4F89A6803FCF803053O00116C929DE8030E3O007DC606E92EA65FE619EF3DA948C603063O00C82BA3748D4F025O00BFB140025O00607640025O004C9F40025O00A8A040025O000EAA4003143O00FF303291F0C2E6AD323C8DA4B4C6B2342F82B3F103073O0083DF565DE3D09403083O00C653B3A404BAED4003063O00D583252OD67D030E3O00032620ADE02A2F07B3EE35382AB203053O0081464B45DF025O007DB140025O0022AC40025O0080A240025O008AA540026O00AF40025O002CAB40025O0068824003143O0006CDFCFB3CCA4BCEE1E870EB06E9FFE66FFC49C603063O008F26AB93891C025O00608940025O00389D4003083O00FE8DADB337E2DADB03073O00B4B0E2D9936383030E3O00E5BC3D03D2B73B22DEBB3D06D0BC03043O0067B3D94F025O00109B40025O00406040025O00188B40025O001EA940025O0062AE4003063O00D1F22B8F9BE003083O00C899B76AC3DEB234025O000C9640025O00A8A240025O00C88440025O00BDB14003133O0072E5872F097237E28434475D72CB8D3C455F2003063O003A5283E85D29025O00A3B24003073O00A776FD347A1AB103063O005FE337B0753D03143O0058782C59EB307B2247A21679636FAA157F244EB903053O00CB781E432B025O00805840025O0052A240025O00C9B040025O006C9340025O00E06440025O006CB140030C3O00476574466F637573556E697403063O0062923DF964BE03073O00C32AD77CB521EC03073O0029781A1F02DD3F03063O00986D39575E45025O00C8AD40025O0012A840025O00049140025O00FEAA4003073O0016D0C2A1EB890403083O001142BFA5C687EC7703043O0007AAAF1F03083O00B16FCFCE739F888C03073O0031861713D84A4C03073O003F65E97074B42F03063O00C732FE02FD3A03063O0056A35B8D7298025O0036AC40025O0011B340030F3O00456E656D696573387953706C61736803173O00476574456E656D696573496E53706C61736852616E6765025O0084AB40025O00C4A04003143O00456E656D696573436F756E74387953706C617368031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O0016A140025O00D2AD40025O0074A94003083O0049734D6F76696E67025O0061B140025O0078AC40030A3O00456E656D69657332357903113O00476574456E656D696573496E52616E6765025O00C07A40025O00C88E40025O0010A740025O00F88F40025O00206340025O007C9D40025O00508140025O0034AB40025O00949B40026O008440025O00805240025O009AAB4003053O00D92A5BEACB03053O00B991452D8F03083O0042752O66446F776E03053O00486F766572030C3O0082100FA3CECA1218AFD2CA4D03053O00BCEA7F79C6025O00E49940025O00EEA940026O006940025O00B6AF40025O00409940025O00588F40025O0014A940025O00E09540025O00909540025O00E06640025O001AAA40025O00A07A40025O0098A940025O00B0AC40025O0010AC40025O00F8AF40025O00208340025O00E89040025O0068AA4003103O00426F2O73466967687452656D61696E73025O00BCA040025O00E9B240025O00F5B140024O0080B3C540025O00409A40025O00688740030C3O00466967687452656D61696E73025O00709F40025O00A06A40025O00A4B140025O004CA240025O00F4AE40025O00E2A740025O006AA040025O00C4A240025O00EAAA40026O006440025O00BCAB40025O0012AF40025O0050B240025O00308840025O00707C400074062O0012FE3O00014O00C9000100013O002E1500030002000100020004DF3O000200010026FF3O0002000100010004DF3O000200010012FE000100013O000E5F0004000B000100010004DF3O000B0001002E190105002A020100060004DF3O002A02012O00B700025O0020BF0002000200072O001700020001000200063900020012000100010004DF3O00120001002E1500090073060100080004DF3O007306010012FE000200014O00C9000300043O0026FF000200230201000A0004DF3O002302010026FF00030016000100010004DF3O001600010012FE000400013O00267E0004001F0001000B0004DF3O001F0001002E30010C001F0001000D0004DF3O001F0001002E15000E00930001000F0004DF3O009300010012FE000500013O002E640010006C000100100004DF3O008C0001000E480001008C000100050004DF3O008C00012O00B7000600013O0020C80006000600112O00090006000200020006390006002C000100010004DF3O002C00012O00B7000600023O0006CB0006004900013O0004DF3O004900010012FE000600014O00C9000700083O0026FF00060033000100010004DF3O003300010012FE000700014O00C9000800083O0012FE0006000A3O00267E000600370001000A0004DF3O00370001002E190112002E000100130004DF3O002E0001002E190115003B000100140004DF3O003B000100267E0007003D000100010004DF3O003D0001002E1901170037000100160004DF3O003700012O00B7000900034O00170009000100022O003F000800093O00063900080044000100010004DF3O00440001002E1901190049000100180004DF3O004900012O00DB000800023O0004DF3O004900010004DF3O003700010004DF3O004900010004DF3O002E00012O00B7000600013O00202701060006001A4O000800043O00202O00080008001B4O00060008000200062O00060054000100010004DF3O00540001002EC0001C00540001001D0004DF3O00540001002E64001E00390001001F0004DF3O008B00010012FE000600014O00C9000700073O002E1500210056000100200004DF3O00560001000E5F0001005C000100060004DF3O005C0001002E1500220056000100230004DF3O005600010012B6000800244O000B0108000100024O000900013O00202O0009000900254O0009000200024O000700080009002E2O0027008B000100260004DF3O008B00012O00B7000800013O0020C80008000800282O00B7000A00054O00E50008000A00020006280108008B000100070004DF3O008B00010012FE000800014O00C9000900093O002E190129006C0001002A0004DF3O006C0001000E480001006C000100080004DF3O006C00010012FE000900013O002E15002B00710001002C0004DF3O007100010026FF00090071000100010004DF3O007100010012FE000A00013O002E19012E00760001002D0004DF3O00760001000E48000100760001000A0004DF3O007600012O00B7000B00064O0003000C00073O00122O000D002F3O00122O000E00306O000C000E000200202O000B000C00314O000B00073O00122O000C00323O00122O000D00336O000B000D6O000B5O00044O007600010004DF3O007100010004DF3O008B00010004DF3O006C00010004DF3O008B00010004DF3O005600010012FE0005000A3O002E1500340020000100350004DF3O00200001000E48000A0020000100050004DF3O002000010012FE000400363O0004DF3O009300010004DF3O00200001002E15003800412O0100370004DF3O00412O01002E64003900AC000100390004DF3O00412O010026FF000400412O0100010004DF3O00412O010012FE000500013O00267E0005009E000100010004DF3O009E0001002E15003A00382O01003B0004DF3O00382O010012FE000600013O000E48000A00A3000100060004DF3O00A300010012FE0005000A3O0004DF3O00382O01002E64003C00040001003C0004DF3O00A7000100267E000600A9000100010004DF3O00A90001002E15003E009F0001003D0004DF3O009F00012O00B7000700013O0020C80007000700112O0009000700020002000639000700D5000100010004DF3O00D500012O00B7000700013O0020C800070007003F2O0009000700020002000639000700D5000100010004DF3O00D500012O00B7000700023O0006CB000700D500013O0004DF3O00D500010012FE000700014O00C9000800093O002E15004000CD000100410004DF3O00CD000100267E000700BE0001000A0004DF3O00BE0001002E19014300CD000100420004DF3O00CD00010026FF000800BE000100010004DF3O00BE00012O00B7000A00084O0017000A000100022O003F0009000A3O002E19014500D5000100440004DF3O00D50001000639000900C9000100010004DF3O00C90001002E15004700D5000100460004DF3O00D500012O00DB000900023O0004DF3O00D500010004DF3O00BE00010004DF3O00D50001002E15004900B8000100480004DF3O00B800010026FF000700B8000100010004DF3O00B800010012FE000800014O00C9000900093O0012FE0007000A3O0004DF3O00B80001002E15004A00362O01004B0004DF3O00362O01002E19014D00362O01004C0004DF3O00362O012O00B7000700013O0020C800070007003F2O0009000700020002000639000700362O0100010004DF3O00362O012O00B7000700013O0020C800070007001A2O0009000700020002000639000700362O0100010004DF3O00362O010012FE000700014O00C9000800083O0026FF000700F5000100010004DF3O00F500012O00B700095O00202501090009004E4O000A00043O00202O000A000A004F00122O000B00506O000C00016O0009000C00024O000800093O00062O000800F3000100010004DF3O00F30001002E19015200F4000100510004DF3O00F400012O00DB000800023O0012FE0007000A3O0026FF000700062O01000B0004DF3O00062O012O00B700095O00200D00090009004E4O000A00043O00202O000A000A004F00122O000B00506O000C00016O000D00096O000E000A3O00202O000E000E00534O0009000E00024O000800093O00062O000800362O013O0004DF3O00362O012O00DB000800023O0004DF3O00362O0100267E0007000A2O01000A0004DF3O000A2O01002E15005400E5000100550004DF3O00E500010012FE000900014O00C9000A000A3O00267E000900102O0100010004DF3O00102O01002E150056000C2O0100570004DF3O000C2O010012FE000A00013O000E480001002C2O01000A0004DF3O002C2O010012FE000B00013O00267E000B00182O0100010004DF3O00182O01002E19015800252O0100590004DF3O00252O012O00B7000C5O0020BB000C000C005A4O000D00043O00202O000D000D005B00122O000E005C6O000C000E00024O0008000C3O002E2O005D00050001005D0004DF3O00242O010006CB000800242O013O0004DF3O00242O012O00DB000800023O0012FE000B000A3O00267E000B00292O01000A0004DF3O00292O01002E15005F00142O01005E0004DF3O00142O010012FE000A000A3O0004DF3O002C2O010004DF3O00142O01002E19016100112O0100600004DF3O00112O01000E48000A00112O01000A0004DF3O00112O010012FE0007000B3O0004DF3O00E500010004DF3O00112O010004DF3O00E500010004DF3O000C2O010004DF3O00E500010012FE0006000A3O0004DF3O009F0001002E190162009A000100630004DF3O009A0001002E6400640060FF2O00640004DF3O009A00010026FF0005009A0001000A0004DF3O009A00010012FE0004000A3O0004DF3O00412O010004DF3O009A0001002E15006500B62O0100660004DF3O00B62O01002E19016800B62O0100670004DF3O00B62O010026FF000400B62O01000A0004DF3O00B62O010012FE000500013O002E6400690065000100690004DF3O00AD2O01000E48000100AD2O0100050004DF3O00AD2O010012FE000600013O002E15006B00552O01006A0004DF3O00552O01002E19016C00552O01006D0004DF3O00552O010026FF000600552O01000A0004DF3O00552O010012FE0005000A3O0004DF3O00AD2O0100267E000600592O0100010004DF3O00592O01002E15006E004D2O01006F0004DF3O004D2O012O00B70007000B4O0024010800073O00122O000900703O00122O000A00716O0008000A00024O00070007000800202O0007000700724O00070002000200062O000700792O013O0004DF3O00792O012O00B70007000C3O0006CB000700792O013O0004DF3O00792O012O00B7000700013O0020C80007000700732O00090007000200022O00B70008000D3O000628010700792O0100080004DF3O00792O012O00B70007000E4O00DA0008000A3O00202O0008000800744O0009000A6O000B00016O0007000B000200062O000700792O013O0004DF3O00792O012O00B7000700073O0012FE000800753O0012FE000900764O00D8000700094O008800076O00B70007000F3O0006CB000700822O013O0004DF3O00822O012O00B7000700013O0020C80007000700732O00090007000200022O00B7000800103O00062201070003000100080004DF3O00842O01002E6400770029000100780004DF3O00AB2O01002E190179008E2O01007A0004DF3O008E2O012O00B7000700114O0019000800073O00122O0009007B3O00122O000A007C6O0008000A000200062O0007008E2O0100080004DF3O008E2O010004DF3O00AB2O01002E19017E00AB2O01007D0004DF3O00AB2O012O00B70007000B4O0024010800073O00122O0009007F3O00122O000A00806O0008000A00024O00070007000800202O0007000700724O00070002000200062O000700AB2O013O0004DF3O00AB2O01002E15008200AB2O0100810004DF3O00AB2O01002E15008400AB2O0100830004DF3O00AB2O012O00B70007000E4O00DA0008000A3O00202O0008000800854O0009000A6O000B00016O0007000B000200062O000700AB2O013O0004DF3O00AB2O012O00B7000700073O0012FE000800863O0012FE000900874O00D8000700094O008800075O0012FE0006000A3O0004DF3O004D2O0100267E000500B32O01000A0004DF3O00B32O01002E04018800B32O0100890004DF3O00B32O01002E19018A00482O01008B0004DF3O00482O010012FE0004000B3O0004DF3O00B62O010004DF3O00482O01002E19018C00190001008D0004DF3O001900010026FF00040019000100360004DF3O001900012O00B7000500013O0020A300050005001A4O000700043O00202O00070007008E4O00050007000200062O0005000F02013O0004DF3O000F02010012FE000500014O00C9000600073O00267E000500C92O01000A0004DF3O00C92O01002E04018F00C92O0100900004DF3O00C92O01002E1901910009020100920004DF3O000902010026FF000600C92O0100010004DF3O00C92O010012B6000800244O000B0108000100024O000900013O00202O0009000900254O0009000200024O000700080009002E2O0093000F020100940004DF3O000F02012O00B7000800013O0020C80008000800282O00B7000A00124O00E50008000A00020006280108000F020100070004DF3O000F02010012FE000800014O00C9000900093O002E19019600DB2O0100950004DF3O00DB2O010026FF000800DB2O0100010004DF3O00DB2O010012FE000900013O002E6400973O000100970004DF3O00E02O010026FF000900E02O0100010004DF3O00E02O010012FE000A00014O00C9000B000B3O002E15009900E62O0100980004DF3O00E62O010026FF000A00E62O0100010004DF3O00E62O010012FE000B00013O0026FF000B00EB2O0100010004DF3O00EB2O010012FE000C00013O00267E000C00F42O0100010004DF3O00F42O01002E30019A00F42O01009B0004DF3O00F42O01002E15009C00EE2O01009D0004DF3O00EE2O012O00B7000D00064O0003000E00073O00122O000F009E3O00122O0010009F6O000E0010000200202O000D000E00A04O000D00073O00122O000E00A13O00122O000F00A26O000D000F6O000D5O00044O00EE2O010004DF3O00EB2O010004DF3O00E02O010004DF3O00E62O010004DF3O00E02O010004DF3O000F02010004DF3O00DB2O010004DF3O000F02010004DF3O00C92O010004DF3O000F02010026FF000500C32O0100010004DF3O00C32O010012FE000600014O00C9000700073O0012FE0005000A3O0004DF3O00C32O012O00B7000500134O00A1000600043O00202O0006000600A34O00078O000800073O00122O000900A43O00122O000A00A56O0008000A6O00053O000200062O0005001C020100010004DF3O001C0201002E1500A60073060100A70004DF3O007306010012FE000500A84O00DB000500023O0004DF3O007306010004DF3O001900010004DF3O007306010004DF3O001600010004DF3O007306010026FF00020014000100010004DF3O001400010012FE000300014O00C9000400043O0012FE0002000A3O0004DF3O001400010004DF3O00730601002E1901A90055020100AA0004DF3O005502010026FF00010055020100010004DF3O005502012O00B7000200144O00120102000100010012B6000200AB4O0063000300073O00122O000400AC3O00122O000500AD6O0003000500024O0002000200034O000300073O00122O000400AE3O00122O000500AF6O0003000500022O00FC0002000200032O0026000200023O00128B000200AB6O000300073O00122O000400B03O00122O000500B16O0003000500024O0002000200034O000300073O00122O000400B23O00122O000500B36O0003000500024O0002000200034O000200153O00122O000200AB6O000300073O00122O000400B43O00122O000500B56O0003000500024O0002000200034O000300073O00122O000400B63O00122O000500B76O0003000500024O0002000200034O000200163O00122O0001000A3O00267E000100590201000A0004DF3O00590201002E6400B8009F020100B90004DF3O00F604010012FE000200013O0026FF0002005E0201000B0004DF3O005E02010012FE0001000B3O0004DF3O00F6040100267E000200620201000A0004DF3O00620201002E1901BB00D5040100BA0004DF3O00D504012O00B7000300013O0020C80003000300BC2O000900030002000200063900030069020100010004DF3O00690201002E6400BD0003000100BE0004DF3O006A02012O0034012O00013O002E1500BF00AB020100C00004DF3O00AB02012O00B7000300173O0006CB000300AB02013O0004DF3O00AB02012O00B7000300044O0024010400073O00122O000500C13O00122O000600C26O0004000600024O00030003000400202O0003000300724O00030002000200062O000300AB02013O0004DF3O00AB02012O00B700035O0020BF0003000300C32O00170003000100020006CB000300AB02013O0004DF3O00AB02010012FE000300014O00C9000400053O000E5F00010084020100030004DF3O00840201002E1500C40099020100C50004DF3O009902010012FE000600013O00267E000600890201000A0004DF3O00890201002E1901C6008B020100C70004DF3O008B02010012FE0003000A3O0004DF3O00990201002E1901C90085020100C80004DF3O008502010026FF00060085020100010004DF3O008502012O00B7000400174O000500075O00202O0007000700CA4O000800046O0009000A3O00122O000A00CB6O0007000A00024O000500073O00122O0006000A3O00044O00850201002E1500CC0080020100CD0004DF3O008002010026FF000300800201000A0004DF3O00800201002E1500CE00D4040100CF0004DF3O00D404010006CB000500D404013O0004DF3O00D404012O003F000600054O0032010700073O00122O000800D03O00122O000900D16O0007000900024O0006000600074O000600023O00044O00D404010004DF3O008002010004DF3O00D404012O00B7000300184O00170003000100020006CB0003001203013O0004DF3O001203012O00B7000300193O0020C60003000300D24O000500043O00202O0005000500D34O00030005000200262O00030012030100D40004DF3O001203012O00B70003001A4O001B000400073O00122O000500D53O00122O000600D66O00040006000200062O00030012030100040004DF3O001203012O00B7000300184O002800030001000200202O0003000300D24O000500043O00202O0005000500D34O00030005000200262O00030012030100D40004DF3O001203012O00B7000300044O0024010400073O00122O000500D73O00122O000600D86O0004000600024O00030003000400202O0003000300D94O00030002000200062O0003001203013O0004DF3O001203010012FE000300014O00C9000400043O000E5F000100D5020100030004DF3O00D50201002E6400DA00FEFF2O00DB0004DF3O00D102010012FE000400013O002E1901DC00E7020100DD0004DF3O00E7020100267E000400DC0201000A0004DF3O00DC0201002E6400DE000D000100DF0004DF3O00E702010012B6000500E03O0006CB000500D404013O0004DF3O00D404010012B6000500E04O0032010600073O00122O000700E13O00122O000800E26O0006000800024O0005000500064O000500023O00044O00D404010026FF000400D6020100010004DF3O00D602010012FE000500013O002E6400E30006000100E30004DF3O00F002010026FF000500F00201000A0004DF3O00F002010012FE0004000A3O0004DF3O00D6020100267E000500F4020100010004DF3O00F40201002E6400E400F8FF2O00E50004DF3O00EA02010012FE000600013O00267E000600F90201000A0004DF3O00F90201002E1901E700FB020100E60004DF3O00FB02010012FE0005000A3O0004DF3O00EA0201002E1901E800F5020100E90004DF3O00F502010026FF000600F5020100010004DF3O00F502012O00B7000700184O007A00070001000200202O0007000700EA4O0007000200024O0007001B6O00075O00202O0007000700EB4O000800186O00080001000200122O000900EC6O00070009000200120E000700E03O0012FE0006000A3O0004DF3O00F502010004DF3O00EA02010004DF3O00D602010004DF3O00D404010004DF3O00D102010004DF3O00D40401002E1500EE0094030100ED0004DF3O009403012O00B70003001C4O00170003000100020006CB0003009403013O0004DF3O009403012O00B70003001D4O001B000400073O00122O000500EF3O00122O000600F06O00040006000200062O00030094030100040004DF3O009403012O00B70003001C4O001700030001000200202A0103000300F14O000500043O00202O0005000500F24O0003000500024O0004001E3O00062O00030094030100040004DF3O009403012O00B7000300044O0024010400073O00122O000500F33O00122O000600F46O0004000600024O00030003000400202O0003000300D94O00030002000200062O0003009403013O0004DF3O009403010012FE000300014O00C9000400053O0026FF000300880301000A0004DF3O00880301002E1500F60036030100F50004DF3O00360301002E1500F70036030100F80004DF3O003603010026FF00040036030100010004DF3O003603010012FE000500013O00267E00050041030100010004DF3O00410301002E1901F90072030100FA0004DF3O007203010012FE000600013O002E1901FB0046030100FC0004DF3O0046030100267E000600480301000A0004DF3O00480301002E6400FD0004000100FE0004DF3O004A03010012FE0005000A3O0004DF3O0072030100267E00060052030100010004DF3O00520301002E3001000152030100FF0004DF3O005203010012FE0007002O012O0012FE00080002012O00067300080042030100070004DF3O004203010012FE000700013O0012FE0008000A3O0006580007005E030100080004DF3O005E03010012FE00080003012O0012FE00090004012O00062201090005000100080004DF3O005E03010012FE00080005012O0012FE00090006012O00062801090060030100080004DF3O006003010012FE0006000A3O0004DF3O004203010012FE000800013O0006CE00070053030100080004DF3O005303012O00B70008001C4O007A00080001000200202O0008000800EA4O0008000200024O0008001F6O00085O00202O0008000800EB4O0009001C6O00090001000200122O000A00EC6O0008000A000200120E000800E03O0012FE0007000A3O0004DF3O005303010004DF3O004203010012FE0006000A3O00065800050079030100060004DF3O007903010012FE00060007012O0012FE00070008012O0006730007003D030100060004DF3O003D03010012B6000600E03O0006CB000600D404013O0004DF3O00D404010012B6000600E04O0032010700073O00122O00080009012O00122O0009000A015O0007000900024O0006000600074O000600023O00044O00D404010004DF3O003D03010004DF3O00D404010004DF3O003603010004DF3O00D404010012FE0006000B012O0012FE0007000B012O0006CE00060034030100070004DF3O003403010012FE000600013O0006CE00030034030100060004DF3O003403010012FE000400014O00C9000500053O0012FE0003000A3O0004DF3O003403010004DF3O00D404010012FE0003000C012O0012FE0004000C012O0006CE000300AC030100040004DF3O00AC03012O00B7000300203O0006CB000300AC03013O0004DF3O00AC03012O00B7000300214O001B000400073O00122O0005000D012O00122O0006000E015O00040006000200062O000300AC030100040004DF3O00AC03012O00B7000300044O00C1000400073O00122O0005000F012O00122O00060010015O0004000600024O00030003000400202O0003000300724O00030002000200062O000300B0030100010004DF3O00B003010012FE00030011012O0012FE00040012012O0006CE000300CF030100040004DF3O00CF03010012FE000300013O0012FE00040013012O0012FE00050013012O0006CE000400B1030100050004DF3O00B103010012FE00040014012O0012FE00050015012O000673000400B1030100050004DF3O00B103010012FE000400013O0006CE000300B1030100040004DF3O00B103012O00B700045O0020D00004000400CA4O00058O000600086O00040008000200122O000400E03O00122O000400E03O00062O000400D404013O0004DF3O00D404010012B6000400E04O0032010500073O00122O00060016012O00122O00070017015O0005000700024O0004000400054O000400023O00044O00D404010004DF3O00B103010004DF3O00D404012O00B7000300203O0006CB000300E303013O0004DF3O00E303012O00B7000300224O001B000400073O00122O00050018012O00122O00060019015O00040006000200062O000300E3030100040004DF3O00E303012O00B7000300044O00C1000400073O00122O0005001A012O00122O0006001B015O0004000600024O00030003000400202O0003000300724O00030002000200062O000300EB030100010004DF3O00EB03010012FE0003001C012O0012FE0004001D012O00062201030005000100040004DF3O00EB03010012FE000300363O0012FE0004001E012O0006CE0003000A040100040004DF3O000A04010012FE000300013O0012FE000400013O000658000300F3030100040004DF3O00F303010012FE0004001F012O0012FE00050020012O000673000500EC030100040004DF3O00EC03012O00B700045O00205E0004000400CA4O00058O000600086O00040008000200122O000400E03O00122O000400E03O00062O00042O00040100010004DF4O0004010012FE00040021012O0012FE00050022012O0006CE000400D4040100050004DF3O00D404010012B6000400E04O0032010500073O00122O00060023012O00122O00070024015O0005000700024O0004000400054O000400023O00044O00D404010004DF3O00EC03010004DF3O00D404010012FE00030025012O0012FE00040026012O000628010300D4040100040004DF3O00D404012O00B7000300203O0006CB000300D404013O0004DF3O00D404012O00B7000300214O001B000400073O00122O00050027012O00122O00060028015O00040006000200062O000300D4040100040004DF3O00D404012O00B7000300044O0024010400073O00122O00050029012O00122O0006002A015O0004000600024O00030003000400202O0003000300724O00030002000200062O000300D404013O0004DF3O00D404010012FE000300014O00C9000400063O0012FE0007002B012O0012FE0008002C012O000628010800C9040100070004DF3O00C904010012FE0007000A3O0006CE000300C9040100070004DF3O00C904012O00C9000600063O0012FE0007000A3O00065800040033040100070004DF3O003304010012FE0007002D012O0012FE0008002E012O00067300080093040100070004DF3O009304010012FE0007002F012O0012FE0008002F012O0006CE00070067040100080004DF3O006704010020C80007000500732O00090007000200020020C80008000600732O000900080002000200067300070067040100080004DF3O006704010012FE000700014O00C9000800083O0012FE000900013O0006CE0007003F040100090004DF3O003F04010012FE000800013O0012FE000900013O0006CE00080043040100090004DF3O004304012O00B700095O0020DD0009000900CA4O000A8O000B000C6O000D00073O00122O000E0030012O00122O000F0031015O000D000F6O00093O000200122O000900E03O00122O00090032012O00122O000A0033012O00062O000900D40401000A0004DF3O00D404010012FE00090034012O0012FE000A0035012O000628010900D40401000A0004DF3O00D404010012B6000900E03O0006CB000900D404013O0004DF3O00D404010012B6000900E04O0032010A00073O00122O000B0036012O00122O000C0037015O000A000C00024O00090009000A4O000900023O00044O00D404010004DF3O004304010004DF3O00D404010004DF3O003F04010004DF3O00D404010020C80007000600732O00090007000200020020C80008000500732O0009000800020002000673000700D4040100080004DF3O00D404010012FE000700014O00C9000800083O0012FE00090038012O0012FE000A0038012O0006CE0009006F0401000A0004DF3O006F04010012FE000900013O0006CE0007006F040100090004DF3O006F04010012FE000800013O0012FE000900013O0006CE00080077040100090004DF3O007704012O00B700095O00200F0109000900CA4O000A8O000B000C6O000D00073O00122O000E0039012O00122O000F003A015O000D000F6O00093O000200122O000900E03O00122O000900E03O0006CB000900D404013O0004DF3O00D404010012B6000900E04O0032010A00073O00122O000B003B012O00122O000C003C015O000A000C00024O00090009000A4O000900023O00044O00D404010004DF3O007704010004DF3O00D404010004DF3O006F04010004DF3O00D404010012FE000700013O0006580004009A040100070004DF3O009A04010012FE0007003D012O0012FE0008003E012O0006280108002C040100070004DF3O002C04010012FE000700013O0012FE0008003F012O0012FE00090040012O000673000900A4040100080004DF3O00A404010012FE0008000A3O0006CE000700A4040100080004DF3O00A404010012FE0004000A3O0004DF3O002C04010012FE00080041012O0012FE00090042012O0006280108009B040100090004DF3O009B04010012FE000800013O0006CE0007009B040100080004DF3O009B04012O00B700085O0012C200090043015O0008000800094O00098O000A000A6O000B00073O00122O000C0044012O00122O000D0045015O000B000D6O00083O000200062O000500B8040100080004DF3O00B804012O00B7000500014O00B700085O0012C200090043015O0008000800094O00098O000A000A6O000B00073O00122O000C0046012O00122O000D0047015O000B000D6O00083O000200062O000600C5040100080004DF3O00C504012O00B7000600013O0012FE0007000A3O0004DF3O009B04010004DF3O002C04010004DF3O00D404010012FE000700013O000658000300D0040100070004DF3O00D004010012FE00070048012O0012FE00080049012O00067300070024040100080004DF3O002404010012FE000400014O00C9000500053O0012FE0003000A3O0004DF3O002404010012FE0002000B3O0012FE0003004A012O0012FE0004004B012O0006280103005A020100040004DF3O005A02010012FE000300013O0006CE0002005A020100030004DF3O005A02010012B6000300AB4O0063000400073O00122O0005004C012O00122O0006004D015O0004000600024O0003000300044O000400073O00122O0005004E012O00122O0006004F015O0004000600022O00FC0003000300042O0026000300203O0012E1000300AB6O000400073O00122O00050050012O00122O00060051015O0004000600024O0003000300044O000400073O00122O00050052012O00122O00060053015O0004000600024O0003000300044O000300233O00122O0002000A3O00044O005A02010012FE0002000B3O0006CE0001003D050100020004DF3O003D05010012FE000200013O0012FE0003000A3O00065800020001050100030004DF3O000105010012FE00030054012O0012FE00040055012O00067300040018050100030004DF3O001805012O00B7000300243O00128100050057015O00030003000500122O0005005C6O00030005000200122O00030056015O000300153O00062O0003000E050100010004DF3O000E05010012FE00030058012O0012FE00040059012O00067300030015050100040004DF3O001505012O00B7000300243O0012260105005B015O00030003000500122O0005005C6O00030005000200122O0003005A012O00044O001705010012FE0003000A3O00120E0003005A012O0012FE0002000B3O0012FE0003000B3O0006CE0002001D050100030004DF3O001D05010012FE000100363O0004DF3O003D05010012FE0003005C012O0012FE0004005D012O000673000300FA040100040004DF3O00FA04010012FE000300013O00065800020028050100030004DF3O002805010012FE000300143O0012FE0004005E012O000628010300FA040100040004DF3O00FA04012O00B7000300013O0012FE0005005F013O00310103000300052O00090003000200020006CB0003003205013O0004DF3O003205010012FE00030060012O0012FE00040061012O00067300030035050100040004DF3O003505010012B6000300244O00170003000100022O0026000300254O00B7000300013O00128700050063015O00030003000500122O000500EC6O00030005000200122O00030062012O00122O0002000A3O00044O00FA04010012FE00020064012O0012FE00030065012O00062801020007000100030004DF3O000700010012FE000200363O0006CE00010007000100020004DF3O000700010012FE000200014O00C9000300033O0012FE00040066012O0012FE00050067012O00062801050046050100040004DF3O004605010012FE000400013O00065800020051050100040004DF3O005105010012FE00040068012O0012FE00050069012O00062801050046050100040004DF3O004605010012FE000300013O0012FE0004000A3O0006CE000300BD050100040004DF3O00BD05012O00B7000400263O0006CB0004009305013O0004DF3O009305012O00B7000400023O00063900040060050100010004DF3O006005012O00B7000400013O0020C80004000400112O00090004000200020006CB0004009305013O0004DF3O009305010012FE0004006A012O0012FE0005006B012O00062801040070050100050004DF3O007005010012FE0004006C012O0012FE0005006D012O00067300050070050100040004DF3O007005010012B6000400244O00050104000100024O000500256O0004000400054O000500273O00062O00040070050100050004DF3O007005010004DF3O009305010012FE0004006E012O0012FE0005006F012O00062801040093050100050004DF3O009305012O00B7000400044O0024010500073O00122O00060070012O00122O00070071015O0005000700024O00040004000500202O0004000400724O00040002000200062O0004009305013O0004DF3O009305012O00B7000400013O00121C00060072015O0004000400064O000600043O00122O00070073015O0006000600074O00040006000200062O0004009305013O0004DF3O009305012O00B70004000E4O005B000500043O00122O00060073015O0005000500064O00040002000200062O0004009305013O0004DF3O009305012O00B7000400073O0012FE00050074012O0012FE00060075013O00D8000400064O008800045O0012FE00040076012O0012FE00050077012O000673000400BC050100050004DF3O00BC05010012FE00040078012O0012FE00050079012O000673000400BC050100050004DF3O00BC05012O00B7000400023O000639000400A3050100010004DF3O00A305012O00B7000400013O0020C80004000400112O00090004000200020006CB000400BC05013O0004DF3O00BC05010012FE000400014O00C9000500053O0012FE000600013O000658000400AC050100060004DF3O00AC05010012FE0006007A012O0012FE0007007B012O0006CE000600A5050100070004DF3O00A505010012FE000500013O0012FE000600013O0006CE000500AD050100060004DF3O00AD05012O00B7000600284O001700060001000200120E000600E03O0012B6000600E03O0006CB000600BC05013O0004DF3O00BC05010012B6000600E04O00DB000600023O0004DF3O00BC05010004DF3O00AD05010004DF3O00BC05010004DF3O00A505010012FE0003000B3O0012FE000400013O000658000300C4050100040004DF3O00C405010012FE0004007C012O0012FE0005007D012O00062801040068060100050004DF3O006806010012FE0004007E012O0012FE0005005D3O00067300040024060100050004DF3O002406012O00B700045O0020BF0004000400072O0017000400010002000639000400D2050100010004DF3O00D205012O00B7000400013O0020C80004000400112O00090004000200020006CB0004002406013O0004DF3O002406010012FE000400014O00C9000500063O0012FE0007007F012O0012FE00080080012O000628010700DE050100080004DF3O00DE05010012FE000700013O0006CE000400DE050100070004DF3O00DE05010012FE000500014O00C9000600063O0012FE0004000A3O0012FE0007000A3O000658000400E9050100070004DF3O00E905010012FE00070081012O0012FE00080082012O00062B010800E9050100070004DF3O00E905010012FE00070083012O0012FE000800493O000628010700D4050100080004DF3O00D405010012FE000700013O000658000700F0050100050004DF3O00F005010012FE00070084012O0012FE00080085012O0006CE000700E9050100080004DF3O00E905010012FE000600013O0012FE00070086012O0012FE00080087012O00067300070004060100080004DF3O000406010012FE00070088012O0012FE00080088012O0006CE00070004060100080004DF3O000406010012FE000700013O0006CE00060004060100070004DF3O000406012O00B7000700063O00120A00080089015O0007000700084O0007000100024O000700296O000700296O0007002A3O00122O0006000A3O0012FE0007008A012O0012FE0008008A012O0006CE000700F1050100080004DF3O00F105010012FE0007000A3O0006CE000700F1050100060004DF3O00F105010012FE0007008B012O0012FE0008008C012O00062801080013060100070004DF3O001306012O00B70007002A3O0012FE0008008D012O00065800070017060100080004DF3O001706010012FE0007008E012O0012FE0008008F012O00067300070024060100080004DF3O002406012O00B7000700063O0012A800080090015O00070007000800122O00080062015O00098O0007000900024O0007002A3O00044O002406010004DF3O00F105010004DF3O002406010004DF3O00E905010004DF3O002406010004DF3O00D405012O00B7000400203O0006CB0004002F06013O0004DF3O002F06012O00B7000400023O0006CB0004002F06013O0004DF3O002F06012O00B7000400013O0020C80004000400112O00090004000200020006CB0004003306013O0004DF3O003306010012FE00040091012O0012FE00050092012O00067300040067060100050004DF3O006706010012FE000400014O00C9000500063O0012FE00070093012O0012FE00080094012O00062801080043060100070004DF3O004306010012FE00070095012O0012FE00080095012O0006CE00070043060100080004DF3O004306010012FE000700013O0006CE00040043060100070004DF3O004306010012FE000500014O00C9000600063O0012FE0004000A3O0012FE0007000A3O0006580004004E060100070004DF3O004E06010012FE00070096012O0012FE00080097012O00062201070005000100080004DF3O004E06010012FE00070098012O0012FE00080099012O0006CE00070035060100080004DF3O003506010012FE0007009A012O0012FE0008009B012O0006280107004E060100080004DF3O004E06010012FE000700013O00065800050059060100070004DF3O005906010012FE0007009C012O0012FE0008009D012O0006280108004E060100070004DF3O004E06012O00B70007002B4O00170007000100022O003F000600073O00063900060062060100010004DF3O006206010012FE0007009E012O0012FE0008009F012O00067300070067060100080004DF3O006706012O00DB000600023O0004DF3O006706010004DF3O004E06010004DF3O006706010004DF3O003506010012FE0003000A3O0012FE0004000B3O0006CE00030052050100040004DF3O005205010012FE000100043O0004DF3O000700010004DF3O005205010004DF3O000700010004DF3O004605010004DF3O000700010004DF3O007306010004DF3O000200012O0034012O00017O001F3O00028O00025O00A06240025O00F4AA40026O00F03F026O008A40025O0056A240025O00389E40025O00B2A540025O009CAA40025O00C6A440027O004003123O0073052D4F77D82E560E325A56D120420A384C03073O0042376C5E3F12B403183O00308496272255188C873B22691B849638297D118F9031214A03063O003974EDE5574703053O005072696E7403223O008BA42OEA72E053ABA5E4E879AE62BCBEE6E265AE45B3F1C8F77EED0788BEE2EA5CA003073O0027CAD18D87178E025O00EAAA40025O00E08240025O003DB240030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03263O00DE260E0737F6EB321D033DF6BF161F0539FDED731F4A63A8B161475A61B8DD2A49283DF7F21803063O00989F53696A52025O0007B34003103O0038E967CFC8991CD70AE851CFE89E1FD003083O00B67E8015AA8AEB7903143O00526567697374657241757261547261636B696E6703133O00BFDF38F68901310ABCD520E8823735049EDC3303083O0066EBBA5586E6735000523O0012FE3O00014O00C9000100013O002E1901020002000100030004DF3O00020001000E480001000200013O0004DF3O000200010012FE000100013O00267E0001000B000100040004DF3O000B0001002E6400050022000100060004DF3O002B00010012FE000200013O00267E00020012000100040004DF3O00120001002E0401070012000100080004DF3O00120001002E19010900140001000A0004DF3O001400010012FE0001000B3O0004DF3O002B0001000E480001000C000100020004DF3O000C00012O00B700036O00D9000400013O00122O0005000C3O00122O0006000D6O0004000600024O00058O000600013O00122O0007000E3O00122O0008000F6O0006000800024O0005000500064O0003000400054O000300023O00202O0003000300104O000400013O00122O000500113O00122O000600126O000400066O00033O000100122O000200043O00044O000C0001002E640013000E000100130004DF3O00390001000E5F000B0031000100010004DF3O00310001002E640014000A000100150004DF3O003900010012B6000200163O00201C0102000200174O000300013O00122O000400183O00122O000500196O000300056O00023O000100044O00510001002E64001A00CEFF2O001A0004DF3O000700010026FF00010007000100010004DF3O000700012O00B7000200034O00CC000300013O00122O0004001B3O00122O0005001C6O0003000500024O00020002000300202O00020002001D4O0002000200014O000200036O000300013O00122O0004001E3O00122O0005001F6O0003000500024O00020002000300202O00020002001D4O00020002000100122O000100043O00044O000700010004DF3O005100010004DF3O000200012O0034012O00017O00", GetFEnv(), ...);

