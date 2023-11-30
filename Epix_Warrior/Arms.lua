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
											if (Enum == 0) then
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
												local A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										end
									elseif (Enum <= 6) then
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
									elseif (Enum > 7) then
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
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
									elseif (Enum <= 11) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 15) then
									if (Enum > 14) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum == 19) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 21) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 24) then
									if (Enum == 23) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 25) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Enum > 26) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
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
								elseif (Enum <= 30) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 31) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 34) then
								if (Enum > 33) then
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
							elseif (Enum <= 35) then
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
							elseif (Enum == 36) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							end
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum > 38) then
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
									elseif (Enum == 40) then
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
										local A = Inst[2];
										Top = (A + Varargsz) - 1;
										for Idx = A, Top do
											local VA = Vararg[Idx - A];
											Stk[Idx] = VA;
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
								elseif (Enum == 45) then
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum == 47) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 49) then
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
								elseif (Enum == 50) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 53) then
								if (Enum == 52) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 54) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 55) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 65) then
							if (Enum <= 60) then
								if (Enum <= 58) then
									if (Enum == 57) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 59) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 62) then
								if (Enum > 61) then
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
								end
							elseif (Enum <= 63) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 64) then
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
						elseif (Enum <= 70) then
							if (Enum <= 67) then
								if (Enum > 66) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 68) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 69) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 72) then
							if (Enum == 71) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 73) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 74) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
					elseif (Enum <= 113) then
						if (Enum <= 94) then
							if (Enum <= 84) then
								if (Enum <= 79) then
									if (Enum <= 77) then
										if (Enum == 76) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											do
												return;
											end
										end
									elseif (Enum == 78) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 81) then
									if (Enum == 80) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										do
											return Unpack(Stk, A, Top);
										end
									end
								elseif (Enum <= 82) then
									if not Stk[Inst[2]] then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum <= 86) then
									if (Enum > 85) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 87) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 88) then
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
							elseif (Enum <= 91) then
								if (Enum == 90) then
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 92) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 93) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						elseif (Enum <= 103) then
							if (Enum <= 98) then
								if (Enum <= 96) then
									if (Enum == 95) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 97) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 100) then
								if (Enum > 99) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 101) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 102) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 108) then
							if (Enum <= 105) then
								if (Enum == 104) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 106) then
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
							elseif (Enum > 107) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 110) then
							if (Enum > 109) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if (Inst[2] <= Inst[4]) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									else
										do
											return Stk[Inst[2]];
										end
									end
								elseif (Enum > 116) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 119) then
								if (Enum == 118) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 120) then
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum == 121) then
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
						elseif (Enum <= 127) then
							if (Enum <= 124) then
								if (Enum == 123) then
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
									A = Inst[2];
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
								end
							elseif (Enum <= 125) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							elseif (Enum > 126) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 129) then
							if (Enum == 128) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 130) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						elseif (Enum == 131) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 142) then
						if (Enum <= 137) then
							if (Enum <= 134) then
								if (Enum == 133) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 135) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 136) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 139) then
							if (Enum > 138) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 141) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 147) then
						if (Enum <= 144) then
							if (Enum == 143) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 145) then
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
						elseif (Enum == 146) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 149) then
						if (Enum == 148) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 228) then
					if (Enum <= 190) then
						if (Enum <= 171) then
							if (Enum <= 161) then
								if (Enum <= 156) then
									if (Enum <= 154) then
										if (Enum > 153) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum > 155) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 158) then
									if (Enum > 157) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 159) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 166) then
								if (Enum <= 163) then
									if (Enum > 162) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 164) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum > 165) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = #Stk[Inst[3]];
								end
							elseif (Enum <= 168) then
								if (Enum > 167) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 169) then
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
							elseif (Enum > 170) then
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 180) then
							if (Enum <= 175) then
								if (Enum <= 173) then
									if (Enum == 172) then
										if (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
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
								elseif (Enum == 174) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
								else
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum <= 178) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 179) then
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
						elseif (Enum <= 185) then
							if (Enum <= 182) then
								if (Enum > 181) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 183) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 184) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 187) then
							if (Enum > 186) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 188) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 189) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 209) then
						if (Enum <= 199) then
							if (Enum <= 194) then
								if (Enum <= 192) then
									if (Enum > 191) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 193) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 196) then
								if (Enum > 195) then
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 197) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 198) then
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
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							end
						elseif (Enum <= 204) then
							if (Enum <= 201) then
								if (Enum == 200) then
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
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
								end
							elseif (Enum <= 202) then
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
							elseif (Enum > 203) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
						elseif (Enum <= 206) then
							if (Enum == 205) then
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
						elseif (Enum <= 207) then
							local B;
							local A;
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
							if (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 208) then
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
							do
								return Stk[Inst[2]]();
							end
						end
					elseif (Enum <= 218) then
						if (Enum <= 213) then
							if (Enum <= 211) then
								if (Enum == 210) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = #Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum == 212) then
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
						elseif (Enum <= 215) then
							if (Enum > 214) then
								local B;
								local A;
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
							elseif (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 216) then
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
						elseif (Enum == 217) then
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
					elseif (Enum <= 223) then
						if (Enum <= 220) then
							if (Enum > 219) then
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
						elseif (Enum <= 221) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 222) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 225) then
						if (Enum == 224) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 226) then
						local A = Inst[2];
						Stk[A] = Stk[A]();
					elseif (Enum > 227) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 266) then
					if (Enum <= 247) then
						if (Enum <= 237) then
							if (Enum <= 232) then
								if (Enum <= 230) then
									if (Enum > 229) then
										if (Stk[Inst[2]] == Inst[4]) then
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
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 231) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 234) then
								if (Enum == 233) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 235) then
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
							elseif (Enum == 236) then
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
							elseif (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 242) then
							if (Enum <= 239) then
								if (Enum == 238) then
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
							elseif (Enum <= 240) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 241) then
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
						elseif (Enum <= 244) then
							if (Enum > 243) then
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
						elseif (Enum <= 245) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						elseif (Enum > 246) then
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 256) then
						if (Enum <= 251) then
							if (Enum <= 249) then
								if (Enum > 248) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 250) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 253) then
							if (Enum > 252) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 254) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 261) then
						if (Enum <= 258) then
							if (Enum == 257) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 259) then
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
						elseif (Enum > 260) then
							if (Inst[2] == Inst[4]) then
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
					elseif (Enum <= 263) then
						if (Enum == 262) then
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
					elseif (Enum <= 264) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 265) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 285) then
					if (Enum <= 275) then
						if (Enum <= 270) then
							if (Enum <= 268) then
								if (Enum > 267) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 269) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 272) then
							if (Enum > 271) then
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
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 273) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 274) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 277) then
							if (Enum > 276) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							else
								Stk[Inst[2]]();
							end
						elseif (Enum <= 278) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 279) then
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
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
					elseif (Enum <= 282) then
						if (Enum == 281) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 283) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Enum == 284) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
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
				elseif (Enum <= 295) then
					if (Enum <= 290) then
						if (Enum <= 287) then
							if (Enum == 286) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
									if (Mvm[1] == 247) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 288) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 289) then
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
					elseif (Enum <= 292) then
						if (Enum > 291) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 293) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 294) then
						local B;
						local A;
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
						if (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 300) then
					if (Enum <= 297) then
						if (Enum == 296) then
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
					elseif (Enum <= 298) then
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					elseif (Enum == 299) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 302) then
					if (Enum == 301) then
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 303) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
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
				elseif (Enum == 304) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Inst[2] ~= Stk[Inst[4]]) then
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503153O00F4D3D23DD98CC60CC3CAD437D99AD513C28DD730E703083O007EB1A3BB4586DBA703153O00DE5AE162F509FA58FA73C52CC46BFA77D970F75FE903063O005E9B2A881AAA002C3O001206012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004353O000A0001001278000300063O00201D000400030007001278000500083O00201D000500050009001278000600083O00201D00060006000A00061F01073O000100062O00F73O00064O00F78O00F73O00044O00F73O00014O00F73O00024O00F73O00053O00201D00080003000B00201D00090003000C2O00CD000A5O001278000B000D3O00061F010C0001000100022O00F73O000A4O00F73O000B4O00F7000D00073O0012AA000E000E3O0012AA000F000F4O0001000D000F000200061F010E0002000100012O00F73O00074O00C4000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O003100025O00122O000300016O00045O00122O000500013O00042O0003002100012O008800076O002A000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O000100040A0003000500012O0088000300054O00F7000400024O008F000300044O005100036O004D3O00017O000A3O00028O00025O0050AA40026O00F03F025O0026A940025O00F1B140025O00707F40025O0007B340025O00A6A340025O00D0A140025O0080A74001443O0012AA000200014O00B4000300043O002E0501020007000100020004353O000900010026E600020009000100010004353O000900010012AA000300014O00B4000400043O0012AA000200033O0026D60002000D000100030004353O000D0001002E05010400F7FF2O00050004353O000200010012AA000500014O00B4000600063O002E0501063O000100060004353O000F00010026E60005000F000100010004353O000F00010012AA000600013O002E0501073O000100070004353O001400010026E600060014000100010004353O00140001002E3400090036000100080004353O003600010026E600030036000100010004353O003600010012AA000700014O00B4000800083O0026E60007001E000100010004353O001E00010012AA000800013O0026E60008002F000100010004353O002F00012O008800096O0044000400093O002E05010A00090001000A0004353O002E00010006520004002E000100010004353O002E00012O0088000900014O00F7000A6O002B000B6O009C00096O005100095O0012AA000800033O0026E600080021000100030004353O002100010012AA000300033O0004353O003600010004353O002100010004353O003600010004353O001E00010026E60003000D000100030004353O000D00012O00F7000700044O002B00086O009C00076O005100075O0004353O000D00010004353O001400010004353O000D00010004353O000F00010004353O000D00010004353O004300010004353O000200012O004D3O00017O00463O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C201885030C3O00C856B541F9439347EE50A25203043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D9026O00144003073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D479030C3O0047657445717569706D656E74026O002A40028O00026O002C4003073O0030EFB7DC0EE1B703043O00AE678EC503043O00773A522B03073O009836483F58453E03073O00E3C5FC4EDDCBFC03043O003CB4A48E03043O00794C083A03073O0072383E6549478D03073O008FE8C9D6B1E6C903043O00A4D889BB03043O00F3F43CA103073O006BB28651D2C69E024O0080B3C54003103O005265676973746572466F724576656E7403143O000822A3FF8F0A31B0E38D1D20BDE384192CAEE38E03053O00CA586EE2A603183O00F323A3CEEFF130A7C6FFEA3FAFD2E4F730A1DFEBED28A7D303053O00AAA36FE29703063O0053657441504C025O00C0514000FE013O008B000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100176O000F001100024O000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000E00134O00145O00122O001500203O00122O001600216O0014001600024O0013001300142O008800145O0012DE001500223O00122O001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000E00144O00155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O00140014001500122O0015002A6O001600166O00178O00188O00198O001A00576O00585O00122O0059002B3O00122O005A002C6O0058005A00024O0058000400584O00595O00122O005A002D3O00122O005B002E6O0059005B00024O00580058005900202O00590008002F4O00590002000200202O005A0059003000062O005A007E00013O0004353O007E00012O00F7005A000D3O00201D005B005900302O000F015A00020002000652005A0081000100010004353O008100012O00F7005A000D3O0012AA005B00314O000F015A0002000200201D005B00590032000622015B008900013O0004353O008900012O00F7005B000D3O00201D005C005900322O000F015B00020002000652005B008C000100010004353O008C00012O00F7005B000D3O0012AA005C00314O000F015B000200022O0088005C5O001237005D00333O00122O005E00346O005C005E00024O005C000C005C4O005D5O00122O005E00353O00122O005F00366O005D005F00024O005C005C005D4O005D5O00122O005E00373O00122O005F00386O005D005F00024O005D000D005D4O005E5O00122O005F00393O00122O0060003A6O005E006000024O005D005D005E4O005E5O00122O005F003B3O00122O0060003C6O005E006000024O005E0011005E4O005F5O00122O0060003D3O00122O0061003E6O005F006100024O005E005E005F4O005F8O006000603O00122O0061003F3O00122O0062003F3O00202O00630004004000061F01653O000100022O00F73O00614O00F73O00624O007B00665O00122O006700413O00122O006800426O006600686O00633O000100202O00630004004000061F01650001000100052O00F73O005B4O00F73O00594O00F73O000D4O00F73O00084O00F73O005A4O001400665O00122O006700433O00122O006800446O006600686O00633O00014O006300643O00061F01650002000100012O00F73O00093O00061F01660003000100022O00F73O005C4O00887O00061F01670004000100042O00F73O005C4O00F73O00084O00888O00F73O00643O00061F01680005000100042O00F73O00084O00F73O005C4O00F73O00644O00887O00061F016900060001001B2O00F73O005C4O00888O00F73O003E4O00F73O000B4O00F73O00484O00F73O00084O00F73O00124O00F73O005E4O00F73O003F4O00F73O00494O00F73O004C4O00F73O005D4O00F73O00404O00F73O004A4O00F73O003A4O00F73O00434O00F73O003B4O00F73O00444O00F73O00414O00F73O004B4O00F73O00514O00F73O003C4O00F73O00454O00F73O003D4O00F73O00464O00F73O00584O00F73O00473O00061F016A0007000100042O00F73O00164O00F73O00584O00F73O005F4O00F73O00193O00061F016B00080001000E2O00F73O00604O00F73O005C4O00888O00F73O00274O00F73O00124O00F73O00554O00F73O00624O00F73O001F4O00F73O00314O00F73O00194O00F73O002C4O00F73O00344O00F73O00234O00F73O001D3O00061F016C00090001002A2O00F73O005C4O00888O00F73O00224O00F73O00084O00F73O00124O00F73O00604O00F73O00234O00F73O00584O00F73O00634O00F73O00674O00F73O00204O00F73O00644O00F73O00094O00F73O00684O00F73O00294O00F73O00154O00F73O00244O00F73O002A4O00F73O002D4O00F73O001E4O00F73O003C4O00F73O00284O00F73O00554O00F73O00624O00F73O004E4O00F73O00324O00F73O00194O00F73O004F4O00F73O005E4O00F73O001C4O00F73O00304O00F73O002B4O00F73O00334O00F73O00264O00F73O00274O00F73O001F4O00F73O00314O00F73O00664O00F73O001A4O00F73O002F4O00F73O002C4O00F73O00343O00061F016D000A000100212O00F73O005C4O00888O00F73O00234O00F73O00124O00F73O00604O00F73O00554O00F73O00624O00F73O001C4O00F73O00304O00F73O00194O00F73O00084O00F73O00204O00F73O00264O00F73O00094O00F73O00154O00F73O00294O00F73O00644O00F73O00244O00F73O001A4O00F73O002F4O00F73O004E4O00F73O00324O00F73O004F4O00F73O005E4O00F73O00274O00F73O002B4O00F73O00334O00F73O002C4O00F73O00344O00F73O001F4O00F73O00314O00F73O00224O00F73O001E3O00061F016E000B000100232O00F73O005C4O00888O00F73O002D4O00F73O00084O00F73O00094O00F73O00124O00F73O00154O00F73O002A4O00F73O00604O00F73O00554O00F73O00624O00F73O001C4O00F73O00304O00F73O00194O00F73O00294O00F73O00644O00F73O00224O00F73O001E4O00F73O002B4O00F73O00334O00F73O00274O00F73O00244O00F73O00264O00F73O00234O00F73O004E4O00F73O00324O00F73O004F4O00F73O005E4O00F73O002C4O00F73O00344O00F73O001F4O00F73O00314O00F73O001A4O00F73O002F4O00F73O00283O00061F016F000C000100092O00F73O00084O00F73O005C4O00888O00F73O00124O00F73O001B4O00F73O00584O00F73O00174O00F73O00164O00F73O006B3O00061F0170000D0001001D2O00F73O00164O00F73O00694O00F73O00504O00F73O00584O00F73O005C4O00F73O005E4O00F73O001D4O00888O00F73O00604O00F73O00124O00F73O00094O00F73O00564O00F73O00364O00F73O00194O00F73O00554O00F73O00624O00F73O00084O00F73O006D4O00F73O006E4O00F73O000E4O00F73O002E4O00F73O00654O00F73O00184O00F73O00644O00F73O006C4O00F73O00574O00F73O00354O00F73O006A4O00F73O00213O00061F0171000E0001001C2O00F73O004E4O00888O00F73O002B4O00F73O002C4O00F73O00294O00F73O00274O00F73O00284O00F73O002F4O00F73O00304O00F73O00314O00F73O00324O00F73O00334O00F73O00344O00F73O001F4O00F73O001A4O00F73O001C4O00F73O002A4O00F73O002D4O00F73O002E4O00F73O00204O00F73O00214O00F73O00224O00F73O00234O00F73O00244O00F73O00264O00F73O001B4O00F73O001D4O00F73O001E3O00061F0172000F000100152O00F73O004C4O00888O00F73O00444O00F73O00454O00F73O00484O00F73O00374O00F73O00384O00F73O00394O00F73O003A4O00F73O003C4O00F73O003E4O00F73O003F4O00F73O003B4O00F73O00474O00F73O00464O00F73O004D4O00F73O004F4O00F73O003D4O00F73O00424O00F73O00434O00F73O00493O00061F017300100001000F2O00F73O00414O00888O00F73O004A4O00F73O004B4O00F73O00554O00F73O00524O00F73O00534O00F73O00544O00F73O00574O00F73O00564O00F73O00354O00F73O00364O00F73O00404O00F73O00514O00F73O00503O00061F01740011000100152O00F73O00734O00F73O00174O00888O00F73O00724O00F73O00714O00F73O00184O00F73O00634O00F73O00084O00F73O00154O00F73O00644O00F73O00604O00F73O00094O00F73O00584O00F73O00614O00F73O00044O00F73O00624O00F73O00164O00F73O00704O00F73O006F4O00F73O005C4O00F73O00193O00061F01750012000100022O00F73O000E4O00887O0020120176000E004500122O007700466O007800746O007900756O0076007900016O00013O00133O00023O00028O00024O0080B3C54000103O0012AA3O00014O00B4000100013O0026E63O0002000100010004353O000200010012AA000100013O002O0E00010005000100010004353O000500010012AA000200024O000700025O0012AA000200024O0007000200013O0004353O000F00010004353O000500010004353O000F00010004353O000200012O004D3O00017O00093O00028O00025O00707240025O00388840026O00F03F026O002C40025O00DCB240025O0096A740030C3O0047657445717569706D656E74026O002A40002D3O0012AA3O00013O002E3400020014000100030004353O00140001002O0E0004001400013O0004353O001400012O0088000100013O00201D0001000100050006222O01000F00013O0004353O000F00012O0088000100024O0088000200013O00201D0002000200052O000F2O010002000200065200010012000100010004353O001200012O0088000100023O0012AA000200014O000F2O01000200022O000700015O0004353O002C00010026D63O0018000100010004353O00180001002EED00060001000100070004353O000100012O0088000100033O00207C0001000100084O0001000200024O000100016O000100013O00202O00010001000900062O0001002600013O0004353O002600012O0088000100024O0088000200013O00201D0002000200092O000F2O010002000200065200010029000100010004353O002900012O0088000100023O0012AA000200014O000F2O01000200022O0007000100043O0012AA3O00043O0004353O000100012O004D3O00017O000B3O00028O00025O001AA240025O00CCA040026O00F03F025O0098A840025O00188740025O00E0B140025O003AB24003133O00556E6974476574546F74616C4162736F726273025O0006AE40025O00ACA74000233O0012AA3O00014O00B4000100023O002EED00030009000100020004353O000900010026E63O0009000100010004353O000900010012AA000100014O00B4000200023O0012AA3O00043O000E310104000D00013O0004353O000D0001002E05010500F7FF2O00060004353O00020001002E340007000D000100080004353O000D00010026E60001000D000100010004353O000D0001001278000300094O008800046O000F0103000200022O00F7000200033O000EE300010019000100020004353O00190001002E05010A00050001000B0004353O001C00012O00CC000300014O0073000300023O0004353O002200012O00CC00036O0073000300023O0004353O002200010004353O000D00010004353O002200010004353O000200012O004D3O00017O00063O0003103O004865616C746850657263656E74616765026O00344003083O003C31A12B4F343B1403073O00497150D2582E57030B3O004973417661696C61626C65025O0080414001163O00201C2O013O00012O000F2O0100020002000EE300020013000100010004353O001300012O008800016O0015000200013O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O00010002000200062O0001001400013O0004353O0014000100201C2O013O00012O000F2O010002000200268900010013000100060004353O001300012O00172O016O00CC000100014O0073000100024O004D3O00017O000B3O00030B3O00446562752O66537461636B031B3O00457865637574696F6E657273507265636973696F6E446562752O66027O0040030D3O00446562752O6652656D61696E7303103O00442O6570576F756E6473446562752O662O033O00474344030B3O00A53EC813E38F2DD815EF9503053O0087E14CAD72030B3O004973417661696C61626C65030A3O0038ECACA4A0B8AB15FFBC03073O00C77A8DD8D0CCDD012A3O00204500013O00014O00035O00202O0003000300024O00010003000200262O00010027000100030004353O0027000100201C2O013O00042O003A00035O00202O0003000300054O0001000300024O000200013O00202O0002000200064O00020002000200062O00010019000100020004353O002700012O008800016O0015000200023O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O00010002000200062O0001002800013O0004353O002800012O008800016O0015000200023O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O0001000100094O00010002000200062O0001002800013O0004353O002800012O0088000100033O0026C200010027000100030004353O002700012O00172O016O00CC000100014O0073000100024O004D3O00017O000A3O0003063O0042752O665570030F3O0053752O64656E446561746842752O66027O004003103O004865616C746850657263656E74616765026O00344003083O0080DC03E379F5BFD803063O0096CDBD709018030B3O004973417661696C61626C65025O00804140030F3O0053772O6570696E67537472696B657301264O002D00015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O00010024000100010004353O002400012O0088000100023O0026AC0001001C000100030004353O001C000100201C2O013O00042O000F2O010002000200268900010023000100050004353O002300012O0088000100014O0015000200033O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O00010002000200062O0001001C00013O0004353O001C000100201C2O013O00042O000F2O010002000200268900010023000100090004353O002300012O008800015O0020BD0001000100014O000300013O00202O00030003000A4O00010003000200044O002400012O00172O016O00CC000100014O0073000100024O004D3O00017O00633O00028O00025O00B4A340025O00C09840027O0040025O005AA94003093O00CC40640FF7587504E003043O006A852E10030A3O0049734361737461626C6503103O004865616C746850657263656E7461676503083O00556E69744E616D65030E3O00496E74657276656E65466F63757303133O00512E67F948565D2E76BC5E455E257DEF53565D03063O00203840139C3A030F3O007ECDE35354E1894CCDD6425BFC835F03073O00E03AA885363A9203083O0042752O66446F776E030F3O00446566656E736976655374616E6365025O006AB140025O0014A740025O0040A040025O00307D40031A3O005D534DF87B958E1D5C6958E97488840E19524EFB708894024F5303083O006B39362B9D15E6E7026O000840026O004D40025O00508340030C3O00F98A05E1B5D9FCCF8A1FF6BC03073O00AFBBEB7195D9BC030C3O0042612O746C655374616E6365025O00D88B40025O008EAC40032E3O003EAE9558EF7C472FBB8042E07C383DA99549F1397C39A98442F0706E39EF9258E2777B39EF8549E57C762FA6974903073O00185CCFE12C8319030B3O0063D6B9400F7558C7B7421E03063O001D2BB3D82C7B03073O0049735265616479025O00BFB040025O004CAC40026O004140025O0012A440030B3O004865616C746873746F6E6503173O00B5DC2140A9D13358B2D7250CB9DC2649B3CA295AB8997303043O002CDDB940026O001040030E3O00078DAB58019A381D2891B145109103083O007045E4DF2C64E871025O0078A640025O00AC9440025O00B89F40030E3O0042692O746572492O6D756E69747903193O00D61613C7B36EB9DD120AC6B87592CD5F03D6B07988C71611D603073O00E6B47F67B3D61C030D3O00A80C5A64FD75E889364849F64503073O0080EC653F268421025O00E09F40025O00508540030D3O00446965427954686553776F7264031A3O00A8A0147BB4F2F0B8A1147BA5FCC0BEAD5140B3EDCAA2BA1852B303073O00AFCCC97124D68B026O00F03F025O00D07040025O009CA240025O00208A40025O0024B040025O005AA740025O009C904003193O0033E24E4D7612EF41517441CF4D5E7F08E94F1F430EF341507D03053O00136187283F025O00CCA240025O002AA94003173O009C5935292A22A6553D3C0734AF503A352801A1483A342103063O0051CE3C535B4F03173O0052656672657368696E674865616C696E67506F74696F6E03253O005CAED6602AD045AD40AC907A2AC241AD40AC906220D744AB40EBD47729C643B747BDD5327B03083O00C42ECBB0124FA32D031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O009C307B1F29ECEEB4297B0C37D3EAB92E771023CBE0AC2B711003073O008FD8421E7E449B03253O00AEDA08CAC8B4D6EDA1CD1FD885ABD2E0A6C103CC85B3D8F5A3C7038BC1A6D1E4A4DB04DDC003083O0081CAA86DABA5C3B7025O00DEAB40025O006BB140030A3O006ECB3BD31642FC34D50A03053O006427AC55BC030A3O0049676E6F72655061696E025O00109D40025O0022A04003153O00A47FB78F21A847A9813AA338BD8535A876AA8925A803053O0053CD18D9E0030B3O00D4C4C131FFCCC33AC5D7D403043O005D86A5AD03103O00417370656374734661766F7242752O66030B3O0052612O6C79696E67437279030A3O004973536F6C6F4D6F6465031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O0096A040025O001EB34003163O00ACF3CDCE23C7BC7981F1D3DB7ACAB778BBFCD2CB2CCB03083O001EDE92A1A25AAED200A4012O0012AA3O00013O002E3400030058000100020004353O005800010026E63O0058000100040004353O00580001002E0501050028000100050004353O002D00012O008800016O0015000200013O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O00010002000200062O0001002D00013O0004353O002D00012O0088000100023O0006222O01002D00013O0004353O002D00012O0088000100033O00201C2O01000100092O000F2O01000200022O0088000200043O00063E0001002D000100020004353O002D00012O0088000100033O00202200010001000A4O0001000200024O000200053O00202O00020002000A4O00020002000200062O0001002D000100020004353O002D00012O0088000100064O0088000200073O00201D00020002000B2O000F2O01000200020006222O01002D00013O0004353O002D00012O0088000100013O0012AA0002000C3O0012AA0003000D4O008F000100034O005100016O008800016O0015000200013O00122O0003000E3O00122O0004000F6O0002000400024O00010001000200202O0001000100084O00010002000200062O0001004800013O0004353O004800012O0088000100053O00204B0001000100104O00035O00202O0003000300114O000400016O00010004000200062O0001004800013O0004353O004800012O0088000100083O0006222O01004800013O0004353O004800012O0088000100053O00201C2O01000100092O000F2O01000200022O0088000200093O00069900010003000100020004353O004A0001002EED00120057000100130004353O005700012O0088000100064O008800025O00201D0002000200112O000F2O010002000200065200010052000100010004353O00520001002EED00140057000100150004353O005700012O0088000100013O0012AA000200163O0012AA000300174O008F000100034O005100015O0012AA3O00183O0026E63O00A7000100180004353O00A70001002E34001900840001001A0004353O008400012O008800016O0015000200013O00122O0003001B3O00122O0004001C6O0002000400024O00010001000200202O0001000100084O00010002000200062O0001008400013O0004353O008400012O0088000100053O00204B0001000100104O00035O00202O00030003001D4O000400016O00010004000200062O0001008400013O0004353O008400012O0088000100083O0006222O01008400013O0004353O008400012O0088000100053O00201C2O01000100092O000F2O01000200022O00880002000A3O00068700020084000100010004353O008400012O0088000100064O008800025O00201D00020002001D2O000F2O01000200020006520001007F000100010004353O007F0001002E34001F00840001001E0004353O008400012O0088000100013O0012AA000200203O0012AA000300214O008F000100034O005100016O00880001000B4O0015000200013O00122O000300223O00122O000400236O0002000400024O00010001000200202O0001000100244O00010002000200062O0001009700013O0004353O009700012O00880001000C3O0006222O01009700013O0004353O009700012O0088000100053O00201C2O01000100092O000F2O01000200022O00880002000D3O00069900010003000100020004353O00990001002E34002500A6000100260004353O00A60001002EED002700A6000100280004353O00A600012O0088000100064O0088000200073O00201D0002000200292O000F2O01000200020006222O0100A600013O0004353O00A600012O0088000100013O0012AA0002002A3O0012AA0003002B4O008F000100034O005100015O0012AA3O002C3O0026E63O00EC000100010004353O00EC00012O008800016O0015000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200202O0001000100244O00010002000200062O000100BC00013O0004353O00BC00012O00880001000E3O0006222O0100BC00013O0004353O00BC00012O0088000100053O00201C2O01000100092O000F2O01000200022O00880002000F3O00069900010003000100020004353O00BE0001002E05012F000F000100300004353O00CB0001002E050131000D000100310004353O00CB00012O0088000100064O008800025O00201D0002000200322O000F2O01000200020006222O0100CB00013O0004353O00CB00012O0088000100013O0012AA000200333O0012AA000300344O008F000100034O005100016O008800016O0015000200013O00122O000300353O00122O000400366O0002000400024O00010001000200202O0001000100084O00010002000200062O000100DE00013O0004353O00DE00012O0088000100103O0006222O0100DE00013O0004353O00DE00012O0088000100053O00201C2O01000100092O000F2O01000200022O0088000200113O00069900010003000100020004353O00E00001002E050137000D000100380004353O00EB00012O0088000100064O008800025O00201D0002000200392O000F2O01000200020006222O0100EB00013O0004353O00EB00012O0088000100013O0012AA0002003A3O0012AA0003003B4O008F000100034O005100015O0012AA3O003C3O0026E63O00412O01002C0004353O00412O012O0088000100123O0006222O0100F700013O0004353O00F700012O0088000100053O00201C2O01000100092O000F2O01000200022O0088000200133O00069900010003000100020004353O00F90001002E34003E00A32O01003D0004353O00A32O010012AA000100014O00B4000200023O0026E6000100FB000100010004353O00FB00010012AA000200013O002E34003F00FE000100400004353O00FE00010026E6000200FE000100010004353O00FE0001002EED0042000C2O0100410004353O000C2O012O0088000300144O00A1000400013O00122O000500433O00122O000600446O00040006000200062O0003000C2O0100040004353O000C2O010004353O00232O01002EED004500232O0100460004353O00232O012O00880003000B4O0015000400013O00122O000500473O00122O000600486O0004000600024O00030003000400202O0003000300244O00030002000200062O000300232O013O0004353O00232O012O0088000300064O0088000400073O00201D0004000400492O000F010300020002000622010300232O013O0004353O00232O012O0088000300013O0012AA0004004A3O0012AA0005004B4O008F000300054O005100036O0088000300143O0026D6000300272O01004C0004353O00272O010004353O00A32O012O00880003000B4O0015000400013O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O0003000300244O00030002000200062O000300A32O013O0004353O00A32O012O0088000300064O0088000400073O00201D0004000400492O000F010300020002000622010300A32O013O0004353O00A32O012O0088000300013O0012230004004F3O00122O000500506O000300056O00035O00044O00A32O010004353O00FE00010004353O00A32O010004353O00FB00010004353O00A32O010026E63O00010001003C0004353O00010001002E34005100672O0100520004353O00672O012O008800016O0015000200013O00122O000300533O00122O000400546O0002000400024O00010001000200202O0001000100084O00010002000200062O000100672O013O0004353O00672O012O0088000100153O0006222O0100672O013O0004353O00672O012O0088000100053O00201C2O01000100092O000F2O01000200022O0088000200163O00063E000100672O0100020004353O00672O012O0088000100066O00025O00202O0002000200554O000300046O000500016O00010005000200062O000100622O0100010004353O00622O01002EED005700672O0100560004353O00672O012O0088000100013O0012AA000200583O0012AA000300594O008F000100034O005100016O008800016O0015000200013O00122O0003005A3O00122O0004005B6O0002000400024O00010001000200202O0001000100084O00010002000200062O000100A12O013O0004353O00A12O012O0088000100173O0006222O0100A12O013O0004353O00A12O012O0088000100053O00206F0001000100104O00035O00202O00030003005C4O00010003000200062O000100A12O013O0004353O00A12O012O0088000100053O00206F0001000100104O00035O00202O00030003005D4O00010003000200062O000100A12O013O0004353O00A12O012O0088000100053O00201C2O01000100092O000F2O01000200022O0088000200183O00063E0001008D2O0100020004353O008D2O012O0088000100193O00201D00010001005E2O00E2000100010002000652000100942O0100010004353O00942O012O0088000100193O0020C000010001005F4O000200186O0003001A6O00010003000200062O000100A12O013O0004353O00A12O012O0088000100064O008800025O00201D00020002005D2O000F2O01000200020006520001009C2O0100010004353O009C2O01002EED006100A12O0100600004353O00A12O012O0088000100013O0012AA000200623O0012AA000300634O008F000100034O005100015O0012AA3O00043O0004353O000100012O004D3O00017O000A3O00028O00026O00F03F025O0046AC4003103O0048616E646C65546F705472696E6B6574026O004440025O00A8A040025O000EAA40025O007DB140025O0022AC4003133O0048616E646C65426F2O746F6D5472696E6B657400383O0012AA3O00014O00B4000100023O0026E63O0007000100010004353O000700010012AA000100014O00B4000200023O0012AA3O00023O0026E63O0002000100020004353O00020001002E0501033O000100030004353O000900010026E600010009000100010004353O000900010012AA000200013O0026E600020020000100010004353O002000012O0088000300013O0020E50003000300044O000400026O000500033O00122O000600056O000700076O0003000700024O00035O002E2O0006001F000100070004353O001F00012O008800035O0006220103001F00013O0004353O001F00012O008800036O0073000300023O0012AA000200023O0026D600020024000100020004353O00240001002EED0008000E000100090004353O000E00012O0088000300013O0020D500030003000A4O000400026O000500033O00122O000600056O000700076O0003000700024O00038O00035O00062O0003003700013O0004353O003700012O008800036O0073000300023O0004353O003700010004353O000E00010004353O003700010004353O000900010004353O003700010004353O000200012O004D3O00017O002A3O00028O00025O002CAB40025O00688240025O00109B40025O00406040030D3O00115322D4D207F62E5123CCDB0603073O0086423857B8BE74030A3O0049734361737461626C65025O00188B40025O001EA940030D3O00536B752O6C73706C692O74657203173O002F3A1CB715F8313935251DBE0BAB3127393206B61BEA3503083O00555C5169DB798B41025O00C88440025O00BDB140030D3O00DEBC5C4A6FCCE8A063487DCCF503063O00BF9DD330251C030D3O00436F6C6F2O737573536D61736803183O00DC10F81329CC0AE72329D21EE7147ACF0DF11F35D21DF50803053O005ABF7F947C026O00F03F030A3O004F863C156A822F1C7D9503043O007718E74E030A3O00576172627265616B657203143O00952CB748CE45108928B70ACC52148122A848DD5403073O0071E24DC52ABC20025O00049140025O00FEAA4003093O001500F1A72A19E3B02803043O00D55A769403093O004F766572706F776572025O0084AB40025O00C4A04003133O005438B1445D5439B1440D4B3CB15542562CB54203053O002D3B4ED43603063O00335E8299812B03083O00907036E3EBE64ECD025O0046AB40025O0074A94003063O0043686172676503103O00B0200EEED75EF3381DF9D354BE2A0EE803063O003BD3486F9CB000BD3O0012AA3O00014O00B4000100013O0026D63O0006000100010004353O00060001002E05010200FEFF2O00030004353O000200010012AA000100013O0026E600010007000100010004353O000700012O008800025O0006220102009E00013O0004353O009E00010012AA000200014O00B4000300033O002EED0005000E000100040004353O000E00010026E60002000E000100010004353O000E00010012AA000300013O002O0E00010057000100030004353O005700012O0088000400014O0015000500023O00122O000600063O00122O000700076O0005000700024O00040004000500202O0004000400084O00040002000200062O0004002200013O0004353O002200012O0088000400033O00065200040024000100010004353O00240001002E34000A002F000100090004353O002F00012O0088000400044O0088000500013O00201D00050005000B2O000F0104000200020006220104002F00013O0004353O002F00012O0088000400023O0012AA0005000C3O0012AA0006000D4O008F000400064O005100045O002EED000E00560001000F0004353O005600012O0088000400054O0088000500063O00068700040056000100050004353O005600012O0088000400014O0015000500023O00122O000600103O00122O000700116O0005000700024O00040004000500202O0004000400084O00040002000200062O0004005600013O0004353O005600012O0088000400073O0006220104005600013O0004353O005600012O0088000400083O0006220104004800013O0004353O004800012O0088000400093O0006520004004B000100010004353O004B00012O0088000400083O00065200040056000100010004353O005600012O0088000400044O0088000500013O00201D0005000500122O000F0104000200020006220104005600013O0004353O005600012O0088000400023O0012AA000500133O0012AA000600144O008F000400064O005100045O0012AA000300153O0026E600030013000100150004353O001300012O0088000400054O0088000500063O0006870004007E000100050004353O007E00012O0088000400014O0015000500023O00122O000600163O00122O000700176O0005000700024O00040004000500202O0004000400084O00040002000200062O0004007E00013O0004353O007E00012O00880004000A3O0006220104007E00013O0004353O007E00012O00880004000B3O0006220104007000013O0004353O007000012O0088000400093O00065200040073000100010004353O007300012O00880004000B3O0006520004007E000100010004353O007E00012O0088000400044O0088000500013O00201D0005000500182O000F0104000200020006220104007E00013O0004353O007E00012O0088000400023O0012AA000500193O0012AA0006001A4O008F000400064O005100045O002EED001B009E0001001C0004353O009E00012O0088000400014O0015000500023O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004009E00013O0004353O009E00012O00880004000C3O0006220104009E00013O0004353O009E00012O0088000400044O0088000500013O00201D00050005001F2O000F01040002000200065200040095000100010004353O00950001002E340020009E000100210004353O009E00012O0088000400023O001223000500223O00122O000600236O000400066O00045O00044O009E00010004353O001300010004353O009E00010004353O000E00012O00880002000D3O000622010200AB00013O0004353O00AB00012O0088000200014O00E9000300023O00122O000400243O00122O000500256O0003000500024O00020002000300202O0002000200084O00020002000200062O000200AD000100010004353O00AD0001002EED002600BC000100270004353O00BC00012O0088000200044O0088000300013O00201D0003000300282O000F010200020002000622010200BC00013O0004353O00BC00012O0088000200023O001223000300293O00122O0004002A6O000200046O00025O00044O00BC00010004353O000700010004353O00BC00010004353O000200012O004D3O00017O0081012O00028O00025O0061B140025O0078AC40026O001040025O00206340025O007C9D40027O0040026O001440030C3O0036E29445EC310A0FFF8F5AE803073O00597B8DE6318D5D03073O004973526561647903063O0042752O665570030F3O0053772O6570696E67537472696B657303093O0042752O66537461636B03133O004372757368696E67416476616E636542752O66026O000840030C3O004D6F7274616C537472696B6503163O00FE7EE4181146CC62E21E1941F631FE0D130AAB20B85903063O002A9311966C70025O00949B40026O00844003093O0020B0286DF7E718A33F03063O00886FC64D1F87030A3O0049734361737461626C65030B3O00261BA257B9EA16BC0501B303083O00C96269C736DD8477030B3O004973417661696C61626C65026O006940025O00B6AF4003093O004F766572706F77657203103O00B61A8633123ABBBC1EC3290336ECE15E03073O00CCD96CE3416255026O00F03F025O0014A940025O00E09540025O00909540025O002EAE40030C3O0073CCE7F12DCC6DD7E7EC27C503063O00A03EA395854C025O00E06640025O001AAA4003093O00436173744379636C6503143O00DBAF1F3BC2DA9F1E3BD1DFAB086FCBD7A34D779003053O00A3B6C06D4F03073O00113E05C3E0202303053O0095544660A0030F3O0053752O64656E446561746842752O6603103O004865616C746850657263656E74616765026O00344003083O0015071EFE39051FE803043O008D58666D025O00804140025O00A07A40025O0098A94003073O0045786563757465025O0010AC40025O00F8AF40030E3O00B64BCF730F295081BB52C930426903083O00A1D333AA107A5D35025O0068AA40025O00E9B240025O00F5B140025O00F4AE40030F3O00D766794CCB46EEE342685BD244E5F703073O008084111C29BB2F030A3O00233E073E58122609285003053O003D6152665A030F3O00432O6F6C646F776E52656D61696E73026O002E40030A3O008E22AA4FC2440A06BE2303083O0069CC4ECB2BA7377E030E3O004973496E4D656C2O6552616E6765025O00E2A740025O006AA04003173O00B6BD261B030DC9569AB9370C1A0FC242E5A2221D53529F03083O0031C5CA437E7364A703043O00055ED12D03073O003E573BBF49E03603083O00CA03E9DAE601E8CC03043O00A987629A030B3O00FF7E2051F235EAC7782B5003073O00A8AB1744349D53030D3O00C77AE0A1293E97F878E1B9203F03073O00E7941195CD454D2O033O00474344030D3O00A3A8CBF444EC95B4F4F656EC8803063O009FE0C7A79B3703083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O66030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O66025O99D9314003043O0052656E64025O0012AF40025O0050B240030B3O00E5F632D6B7FB3DD1B7A46C03043O00B297935C025O00308840025O00707C4003073O006B9FE62E5B93E603043O004D2EE783030E3O004A752O6765726E61757442752O66030B3O0042752O6652656D61696E73030E3O00BF4CB343AF40B300B255B500EC2O03043O0020DA34D6030B3O007A1F24A6F5B5577942162103083O003A2E7751C891D025030F3O0009803FA3ADBC382FB838B9A7B9333903073O00564BEC50CCC9DD03043O004044798103063O00EB122117E59E03113O00446562752O665265667265736861626C65030B3O005468756E646572436C617003133O0044B2D4B554BFD38453B6C0AB10B2C0B810EC9903043O00DB30DAA1026O001C4003093O00B546564DBCDE578C4A03073O003EE22E2O3FD0A9030D3O00D60D5A911202296DF21647870C03083O003E857935E37F6D4F030E3O00361120E3D9BCAD163633E1C2A2A703073O00C270745295B6CE026O008A40025O0056A24003093O00576869726C77696E6403103O002EA0450ACCF50737AC0C10C1E14E60FB03073O006E59C82C78A08203063O0088CF4E47554F03083O002DCBA32B26232A5B030D3O00F197C9308FA05AD5A3D33184AC03073O0034B2E5BC43E7C903063O00436C65617665030D3O00224D5505E1596329405344AE0803073O004341213064973C030A3O00F6E0A0D7E1DAD7AFD1FD03053O0093BF87CEB8030A3O00A629B2D5D456BE8B3AA203073O00D2E448C6A1B833030F3O001747F41561E33747F21776C33347E703063O00AE562993701303043O0052616765026O003E4003083O0076019E18240C03AE03083O00CB3B60ED6B456F71030A3O0049676E6F72655061696E025O00389E40025O00B2A54003123O002D11A2EE23F5E83417A5EF71F8D62756F5B403073O00B74476CC81519003043O003DA171E903063O00E26ECD10846B030D3O00C8D1F5CA49E2CDE7FF4EF9C0E503053O00218BA380B9030E3O00715D16C8584A0BD8755910CA5B5D03043O00BE373864030E3O0070AA2E081CF1FC508D3D0A07EFF603073O009336CF5C7E7383025O00E08240025O003DB24003043O00536C616D030B3O001E3D34704D760C3275245B03063O001E6D51551D6D026O002040025O0050A040025O00B6A240025O00209F40025O0074A44003063O00E137F54F746303073O00A68242873C1B11030E3O00775ACB74224B4CEC74235043C17B03053O0050242AAE15030F3O00546573746F664D6967687442752O66030B3O007A15246E41161A7349182303043O001A2E7057025O00ECA940025O00207A4003143O0053706561724F6642617374696F6E437572736F72030E3O0049735370652O6C496E52616E6765030E3O0053706561726F6642617374696F6E03173O00AA33AE75AD804AB28621AA67ABB64ABAF92BAA77FFE81303083O00D4D943CB142ODF25030A3O009881A9D6BF9EBCDDA88003043O00B2DAEDC803083O0083BBEED9B8B2E3D403043O00B0D6D586030B3O00C0A8A5C0A75074FDAABEC003073O003994CDD6B4C836025O00C6AF40025O00D2A340030A3O00426C61646573746F726D025O0049B040025O00B8AF4003113O0010F134307301E93A267B52F534373645AA03053O0016729D5554030E3O000A37ECFF2O3AEBFE2B2CCBFE3F2D03043O00915E5F99030B3O00C9C807C141B1D0C413DD5A03063O00D79DAD74B52E03103O00442O6570576F756E6473446562752O66025O00805540025O00F08240030E3O005468756E6465726F7573526F6172025O002AA34003163O0021BC9EFCDE30A684E7C90AA684F3C875BC8AF19A62E103053O00BA55D4EB9203063O00D28D17E73CFC03073O0038A2E1769E598E030E3O006F15C5AE30D75A27C1BC36D1530B03063O00B83C65A0CF42030B3O0005876FA83E8451B5368A6803043O00DC51E21C025O00E8A440025O0083B04003143O0053706561724F6642617374696F6E506C61796572025O00B07140025O000EA64003174O00C587FA2OF81CD3BDF9EBD407DC8DF5AACF12D6C2ACBC03063O00A773B5E29B8A026O001840025O0092B040025O00E0764003093O00A8E20134B288E3013403053O00C2E794644603093O00695AC4B1E6C75149D303063O00A8262CA1C39603073O0043686172676573030B3O00B4F991623FEE9B1F87F49603083O0076E09CE2165088D6030B3O0076EB4A944DE8748945E64D03043O00E0228E39030A3O00FCA6D1C97FF45101CCA303083O006EBEC7A5BD13913D025O0080514003103O00D5FD72FA9BC8CDEE65A883C6D9AB2FB103063O00A7BA8B1788EB025O0068B240030B3O002EBD9D031EB09A2E16B49803043O006D7AD5E8025O000EAA40025O0060A74003133O00FAFFB73EEAF2B00FEDFBA320AEFFA3332OAEF203043O00508E97C2025O00289740025O00D09640030C3O002EC9655802CA445811CF7C4903043O002C63A61703143O0071F83B2232A843E43D243AAF79B7213730E425A603063O00C41C9749565303043O00C106271403083O001693634970E23878025O00606540025O0053B240030B3O00AA70ECF1CDB074E1B5D4EA03053O00EDD8158295025O00FAA040025O00E8B240030E3O00CFA6A726FFABA027EEBD8027FABC03043O00489BCED2025O0058AE40025O00089540025O0040AA4003163O00527241003743685B1B2079685B0F210672550D731E2F03053O0053261A346E025O00E89040026O00A64003093O006B1F2845530026505D03043O002638774703093O00C0E056DF2674FCE05503063O0036938F38B64503093O00497343617374696E6703093O0053686F636B77617665025O00ECAD40025O00E8B04003103O00C589F04AD4C180E94C9FDE80FC09878003053O00BFB6E19F2903093O002O042D479B88D52E0003073O00A24B724835EBE703093O00A32A41F0430D9B395603063O0062EC5C248233030A3O00862O18AE49ADB93FB61D03083O0050C4796CDA25C8D5030A3O00446562752O66646F776E030E3O005261676550657263656E74616765026O003940030A3O002272166B470B860F610603073O00EA6013621F2B6E025O002C9140025O0092B24003103O002O0957D5BC7D9C030D12CFAD71CB5E4803073O00EB667F32A7CC12025O0007B340025O001CB34003043O0063ADF42E03063O004E30C1954324030A3O00121F940C4D35128F0A4503053O0021507EE078030B3O00FFA402C91CE4A9008404B403053O003C8CC863A4025O00B2A240025O00809940025O00DCA24003093O00FAEF14E916DAEE13FF03053O007AAD877D9B030D3O00B7D50FAB323ECEB7D60FAB3B2203073O00A8E4A160D95F5103183O004D657263696C652O73426F6E656772696E64657242752O66030D3O0048752O726963616E6542752O66025O00C0984003103O00CCD9274E2340D2DF2A1C2756D891760C03063O0037BBB14E3C4F030D3O001EC54AE74ADC9021C74BFF43DD03073O00E04DAE3F8B26AF026O004440030B3O00B0485C2B8B477A228B4E5C03043O004EE42138030D3O00536B752O6C73706C692O746572031B3O00DD69B70695C770B53C96DA6CBB0880DD3EB71B80CD6BA606C5962F03053O00E5AE1ED263025O00DAA140025O0032A040030A3O00E6C712C058E5BCCBD91E03073O00C8A4AB73A43D96030B3O008AF110518CB8D90A428BAA03053O00E3DE94632503113O00315E53F2FC20465DE4F4735A53F5B9640A03053O0099532O329603063O007E7A761D65AE03073O002D3D16137C13CB030A3O00E31319E10E75B5CE000903073O00D9A1726D956210030C3O003F2F2A68BD7821342A75B77103063O00147240581CDC025O009CA640025O00DEA540030D3O00320DD7B5EED5FD3900D1F4AF8903073O00DD5161B2D498B0025O00EC9340025O002AAC40026O006E40025O0098924003093O00CC795BB53DC9FDE97403073O009C9F1134D656BE03093O009DE0B3B5ADCDB2B3A303043O00DCCE8FDD025O00D88340025O00A2A14003103O0095752214D3DBD390786D1FD9CF92DF2A03073O00B2E61D4D77B8AC025O00A49E40025O00B08040030A3O00D7B20B1F72EBE1B1181603063O009895DE6A7B17025O00806840025O009EA74003113O00DF2AF747B0CE32F951B89D2EF740F5847E03053O00D5BD469623026O00A040025O00CEA740025O00B07940025O0034A740030D3O00C2C73EF5FC23E951D2C533E9E703083O002281A8529A8F509C030D3O00436F6C6F2O737573536D61736803153O0086BD3F045B5D9C968D2006495D81C5BA322O0819DA03073O00E9E5D2536B282E030D3O00E24D3ED916D25721E508C0513A03053O0065A12252B603153O00EB0255F1C8F1973DD71E54FFC8EAC226E90E19A98F03083O004E886D399EBB82E2025O00809440025O00D2A54003063O00ADEB4D26135E03073O001AEC9D2C52722C025O00E8A040025O0098AA40025O00E09040025O00CCA64003063O00417661746172030D3O002B38D44F2B3C95532B2D950C7B03043O003B4A4EB5030A3O0012D04858A120D0515FA103053O00D345B12O3A030A3O00576172627265616B657203113O00A0E46BF7FBCEB6EE7CE7A9C3B6E639A2BB03063O00ABD7851995890066082O0012AA3O00014O00B4000100013O0026D63O0006000100010004353O00060001002E3400020002000100030004353O000200010012AA000100013O0026D60001000B000100040004353O000B0001002EED000600E1000100050004353O00E100010012AA000200013O0026E600020010000100070004353O001000010012AA000100083O0004353O00E10001002O0E0001006A000100020004353O006A00012O008800036O0015000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003A00013O0004353O003A00012O0088000300023O0006220103003A00013O0004353O003A00012O0088000300033O00206F00030003000C4O00055O00202O00050005000D4O00030005000200062O0003003A00013O0004353O003A00012O0088000300033O0020DD00030003000E4O00055O00202O00050005000F4O00030005000200262O0003003A000100100004353O003A00012O0088000300044O00D100045O00202O0004000400114O000500056O000500056O00030005000200062O0003003A00013O0004353O003A00012O0088000300013O0012AA000400123O0012AA000500134O008F000300054O005100035O002E3400150069000100140004353O006900012O008800036O0015000400013O00122O000500163O00122O000600176O0004000600024O00030003000400202O0003000300184O00030002000200062O0003006900013O0004353O006900012O0088000300063O0006220103006900013O0004353O006900012O0088000300033O00206F00030003000C4O00055O00202O00050005000D4O00030005000200062O0003006900013O0004353O006900012O008800036O0015000400013O00122O000500193O00122O0006001A6O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003006900013O0004353O00690001002E34001C00690001001D0004353O006900012O0088000300044O00D100045O00202O00040004001E4O000500056O000500056O00030005000200062O0003006900013O0004353O006900012O0088000300013O0012AA0004001F3O0012AA000500204O008F000300054O005100035O0012AA000200213O0026D60002006E000100210004353O006E0001002EED0022000C000100230004353O000C00010012AA000300013O0026E6000300D9000100010004353O00D90001002E3400240092000100250004353O009200012O008800046O0015000500013O00122O000600263O00122O000700276O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004009200013O0004353O009200012O0088000400023O0006220104009200013O0004353O00920001002EED00280092000100290004353O009200012O0088000400073O0020D400040004002A4O00055O00202O0005000500114O000600086O000700096O000800056O000800086O00040008000200062O0004009200013O0004353O009200012O0088000400013O0012AA0005002B3O0012AA0006002C4O008F000400064O005100046O008800046O0015000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400C400013O0004353O00C400012O00880004000A3O000622010400C400013O0004353O00C400012O0088000400033O00200D00040004000C4O00065O00202O00060006002F4O00040006000200062O000400C6000100010004353O00C600012O00880004000B3O0026AC000400BD000100070004353O00BD00012O00880004000C3O00201C0104000400302O000F010400020002002689000400C6000100310004353O00C600012O008800046O0015000500013O00122O000600323O00122O000700336O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400BD00013O0004353O00BD00012O00880004000C3O00201C0104000400302O000F010400020002002689000400C6000100340004353O00C600012O0088000400033O00200D00040004000C4O00065O00202O00060006000D4O00040006000200062O000400C6000100010004353O00C60001002E34003600D8000100350004353O00D800012O0088000400073O00204800040004002A4O00055O00202O0005000500374O000600086O0007000D6O000800056O000800086O00040008000200062O000400D3000100010004353O00D30001002E0501380007000100390004353O00D800012O0088000400013O0012AA0005003A3O0012AA0006003B4O008F000400064O005100045O0012AA000300213O002E05013C0096FF2O003C0004353O006F00010026E60003006F000100210004353O006F00010012AA000200073O0004353O000C00010004353O006F00010004353O000C00010026E6000100F92O0100010004353O00F92O010012AA000200014O00B4000300033O0026E6000200E5000100010004353O00E500010012AA000300013O0026E6000300EC000100070004353O00EC00010012AA000100213O0004353O00F92O01002EED003E008E2O01003D0004353O008E2O010026E60003008E2O0100210004353O008E2O01002E05013F00380001003F0004353O00282O012O008800046O0015000500013O00122O000600403O00122O000700416O0005000700024O00040004000500202O0004000400184O00040002000200062O000400282O013O0004353O00282O012O00880004000E3O000622010400282O013O0004353O00282O012O00880004000B3O000E3B000700282O0100040004353O00282O012O008800046O002C010500013O00122O000600423O00122O000700436O0005000700024O00040004000500202O0004000400444O000400020002000E2O004500162O0100040004353O00162O012O008800046O00E9000500013O00122O000600463O00122O000700476O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400282O0100010004353O00282O012O0088000400044O005500055O00202O00050005000D4O0006000C3O00202O0006000600484O0008000F6O0006000800024O000600066O00040006000200062O000400232O0100010004353O00232O01002EED004900282O01004A0004353O00282O012O0088000400013O0012AA0005004B3O0012AA0006004C4O008F000400064O005100046O008800046O0015000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004004C2O013O0004353O004C2O012O0088000400103O0006220104004C2O013O0004353O004C2O012O00880004000B3O0026E60004004C2O0100210004353O004C2O012O00880004000C3O00201C0104000400302O000F010400020002000EE30031007E2O0100040004353O007E2O012O008800046O0015000500013O00122O0006004F3O00122O000700506O0005000700024O00040004000500202O00040004001B4O00040002000200062O0004004C2O013O0004353O004C2O012O00880004000C3O00201C0104000400302O000F0104000200020026890004007E2O0100340004353O007E2O012O008800046O0015000500013O00122O000600513O00122O000700526O0005000700024O00040004000500202O00040004001B4O00040002000200062O0004008D2O013O0004353O008D2O012O008800046O0036000500013O00122O000600533O00122O000700546O0005000700024O00040004000500202O0004000400444O0004000200024O000500033O00202O0005000500554O00050002000200062O0004008D2O0100050004353O008D2O012O008800046O001E010500013O00122O000600563O00122O000700576O0005000700024O00040004000500202O0004000400444O0004000200024O000500033O00202O0005000500554O00050002000200062O000400772O0100050004353O00772O012O00880004000C3O00206F0004000400584O00065O00202O0006000600594O00040006000200062O0004008D2O013O0004353O008D2O012O00880004000C3O0020E800040004005A4O00065O00202O00060006005B4O00040006000200262O0004008D2O01005C0004353O008D2O012O0088000400044O00A200055O00202O00050005005D4O000600056O000600066O00040006000200062O000400882O0100010004353O00882O01002EED005F008D2O01005E0004353O008D2O012O0088000400013O0012AA000500603O0012AA000600614O008F000400064O005100045O0012AA000300073O0026D6000300922O0100010004353O00922O01002E34006200E8000100630004353O00E800012O008800046O0015000500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400BD2O013O0004353O00BD2O012O00880004000A3O000622010400BD2O013O0004353O00BD2O012O0088000400033O00206F00040004000C4O00065O00202O0006000600664O00040006000200062O000400BD2O013O0004353O00BD2O012O0088000400033O0020110104000400674O00065O00202O0006000600664O0004000600024O000500033O00202O0005000500554O00050002000200062O000400BD2O0100050004353O00BD2O012O0088000400044O00D100055O00202O0005000500374O000600056O000600066O00040006000200062O000400BD2O013O0004353O00BD2O012O0088000400013O0012AA000500683O0012AA000600694O008F000400064O005100046O008800046O0015000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400F52O013O0004353O00F52O012O0088000400113O000622010400F52O013O0004353O00F52O012O00880004000B3O000EBC000700F52O0100040004353O00F52O012O008800046O0015000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400F52O013O0004353O00F52O012O008800046O0015000500013O00122O0006006E3O00122O0007006F6O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400F52O013O0004353O00F52O012O00880004000C3O00206F0004000400704O00065O00202O00060006005B4O00040006000200062O000400F52O013O0004353O00F52O012O0088000400044O00D100055O00202O0005000500714O000600056O000600066O00040006000200062O000400F52O013O0004353O00F52O012O0088000400013O0012AA000500723O0012AA000600734O008F000400064O005100045O0012AA000300213O0004353O00E800010004353O00F92O010004353O00E500010026E6000100E1020100740004353O00E102012O008800026O0015000300013O00122O000400753O00122O000500766O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002001F02013O0004353O001F02012O0088000200123O0006220102001F02013O0004353O001F02012O008800026O00E9000300013O00122O000400773O00122O000500786O0003000500024O00020002000300202O00020002001B4O00020002000200062O00020021020100010004353O002102012O008800026O0015000300013O00122O000400793O00122O0005007A6O0003000500024O00020002000300202O00020002001B4O00020002000200062O0002001F02013O0004353O001F02012O00880002000B3O000EE300210021020100020004353O00210201002E05017B00120001007C0004353O003102012O0088000200044O005900035O00202O00030003007D4O0004000C3O00202O0004000400484O0006000F6O0004000600024O000400046O00020004000200062O0002003102013O0004353O003102012O0088000200013O0012AA0003007E3O0012AA0004007F4O008F000200044O005100026O008800026O0015000300013O00122O000400803O00122O000500816O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002005502013O0004353O005502012O0088000200133O0006220102005502013O0004353O005502012O008800026O00E9000300013O00122O000400823O00122O000500836O0003000500024O00020002000300202O00020002001B4O00020002000200062O00020055020100010004353O005502012O0088000200044O00D100035O00202O0003000300844O000400056O000400046O00020004000200062O0002005502013O0004353O005502012O0088000200013O0012AA000300853O0012AA000400864O008F000200044O005100026O008800026O0015000300013O00122O000400873O00122O000500886O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002009E02013O0004353O009E02012O0088000200143O0006220102009E02013O0004353O009E02012O008800026O0015000300013O00122O000400893O00122O0005008A6O0003000500024O00020002000300202O00020002001B4O00020002000200062O0002009E02013O0004353O009E02012O008800026O0015000300013O00122O0004008B3O00122O0005008C6O0003000500024O00020002000300202O00020002001B4O00020002000200062O0002009E02013O0004353O009E02012O0088000200033O00201C01020002008D2O000F010200020002000EBC008E009E020100020004353O009E02012O00880002000C3O00201C0102000200302O000F0102000200020026890002008F020100310004353O008F02012O008800026O0015000300013O00122O0004008F3O00122O000500906O0003000500024O00020002000300202O00020002001B4O00020002000200062O0002009E02013O0004353O009E02012O00880002000C3O00201C0102000200302O000F0102000200020026C30002009E020100340004353O009E02012O0088000200044O00A200035O00202O0003000300914O000400056O000400046O00020004000200062O00020099020100010004353O00990201002E0501920007000100930004353O009E02012O0088000200013O0012AA000300943O0012AA000400954O008F000200044O005100026O008800026O0015000300013O00122O000400963O00122O000500976O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200D102013O0004353O00D102012O0088000200153O000622010200D102013O0004353O00D102012O008800026O0015000300013O00122O000400983O00122O000500996O0003000500024O00020002000300202O00020002001B4O00020002000200062O000200D102013O0004353O00D102012O0088000200033O00201C01020002008D2O000F010200020002000EBC008E00D1020100020004353O00D102012O008800026O0015000300013O00122O0004009A3O00122O0005009B6O0003000500024O00020002000300202O00020002001B4O00020002000200062O000200C702013O0004353O00C702012O00880002000B3O0026D6000200D3020100210004353O00D302012O008800026O0015000300013O00122O0004009C3O00122O0005009D6O0003000500024O00020002000300202O00020002001B4O00020002000200062O000200D302013O0004353O00D30201002E05019E000F0001009F0004353O00E002012O0088000200044O00D100035O00202O0003000300A04O000400056O000400046O00020004000200062O000200E002013O0004353O00E002012O0088000200013O0012AA000300A13O0012AA000400A24O008F000200044O005100025O0012AA000100A33O0026D6000100E5020100070004353O00E50201002E3400A50030040100A40004353O003004010012AA000200014O00B4000300033O002EED00A600E7020100A70004353O00E702010026E6000200E7020100010004353O00E702010012AA000300013O002O0E00210088030100030004353O008803012O0088000400164O0088000500173O00068700040027030100050004353O002703012O0088000400183O0006220104002703013O0004353O002703012O0088000400193O000622010400FB02013O0004353O00FB02012O00880004001A3O000652000400FE020100010004353O00FE02012O0088000400193O00065200040027030100010004353O002703012O00880004001B4O004F000500013O00122O000600A83O00122O000700A96O00050007000200062O00040027030100050004353O002703012O008800046O0015000500013O00122O000600AA3O00122O000700AB6O0005000700024O00040004000500202O0004000400184O00040002000200062O0004002703013O0004353O002703012O0088000400033O00200D00040004000C4O00065O00202O0006000600AC4O00040006000200062O00040029030100010004353O002903012O008800046O00E9000500013O00122O000600AD3O00122O000700AE6O0005000700024O00040004000500202O00040004001B4O00040002000200062O00040027030100010004353O002703012O00880004000C3O00200D0004000400584O00065O00202O0006000600594O00040006000200062O00040029030100010004353O00290301002E0501AF0013000100B00004353O003A03012O0088000400044O00D90005001C3O00202O0005000500B14O0006000C3O00202O0006000600B24O00085O00202O0008000800B34O0006000800024O000600066O00040006000200062O0004003A03013O0004353O003A03012O0088000400013O0012AA000500B43O0012AA000600B54O008F000400064O005100046O0088000400164O0088000500173O00068700040076030100050004353O007603012O00880004001D3O0006220104007603013O0004353O007603012O00880004001E3O0006220104004703013O0004353O004703012O00880004001A3O0006520004004A030100010004353O004A03012O00880004001E3O00065200040076030100010004353O007603012O008800046O0015000500013O00122O000600B63O00122O000700B76O0005000700024O00040004000500202O0004000400184O00040002000200062O0004007603013O0004353O007603012O008800046O0015000500013O00122O000600B83O00122O000700B96O0005000700024O00040004000500202O00040004001B4O00040002000200062O0004007603013O0004353O007603012O0088000400033O00200D00040004000C4O00065O00202O0006000600AC4O00040006000200062O00040078030100010004353O007803012O008800046O00E9000500013O00122O000600BA3O00122O000700BB6O0005000700024O00040004000500202O00040004001B4O00040002000200062O00040076030100010004353O007603012O00880004000C3O00200D0004000400584O00065O00202O0006000600594O00040006000200062O00040078030100010004353O00780301002EED00BC0087030100BD0004353O008703012O0088000400044O00A200055O00202O0005000500BE4O000600056O000600066O00040006000200062O00040082030100010004353O00820301002EED00BF0087030100C00004353O008703012O0088000400013O0012AA000500C13O0012AA000600C24O008F000400064O005100045O0012AA000300073O0026E60003008C030100070004353O008C03010012AA000100103O0004353O003004010026E6000300EC020100010004353O00EC02012O0088000400164O0088000500173O000687000400CA030100050004353O00CA03012O00880004001F3O000622010400CA03013O0004353O00CA03012O0088000400203O0006220104009B03013O0004353O009B03012O00880004001A3O0006520004009E030100010004353O009E03012O0088000400203O000652000400CA030100010004353O00CA03012O008800046O0015000500013O00122O000600C33O00122O000700C46O0005000700024O00040004000500202O0004000400184O00040002000200062O000400CA03013O0004353O00CA03012O0088000400033O00200D00040004000C4O00065O00202O0006000600AC4O00040006000200062O000400CC030100010004353O00CC03012O008800046O00E9000500013O00122O000600C53O00122O000700C66O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400C0030100010004353O00C003012O00880004000C3O00200D0004000400584O00065O00202O0006000600594O00040006000200062O000400CC030100010004353O00CC03012O00880004000B3O000EBC002100CA030100040004353O00CA03012O00880004000C3O00200201040004005A4O00065O00202O0006000600C74O000400060002000E2O000100CC030100040004353O00CC0301002EED00C900DE030100C80004353O00DE03012O0088000400044O005500055O00202O0005000500CA4O0006000C3O00202O0006000600484O0008000F6O0006000800024O000600066O00040006000200062O000400D9030100010004353O00D90301002EED00CB00DE030100050004353O00DE03012O0088000400013O0012AA000500CC3O0012AA000600CD4O008F000400064O005100046O0088000400164O0088000500173O00068700040017040100050004353O001704012O0088000400183O0006220104001704013O0004353O001704012O0088000400193O000622010400EB03013O0004353O00EB03012O00880004001A3O000652000400EE030100010004353O00EE03012O0088000400193O00065200040017040100010004353O001704012O00880004001B4O004F000500013O00122O000600CE3O00122O000700CF6O00050007000200062O00040017040100050004353O001704012O008800046O0015000500013O00122O000600D03O00122O000700D16O0005000700024O00040004000500202O0004000400184O00040002000200062O0004001704013O0004353O001704012O0088000400033O00200D00040004000C4O00065O00202O0006000600AC4O00040006000200062O00040019040100010004353O001904012O008800046O00E9000500013O00122O000600D23O00122O000700D36O0005000700024O00040004000500202O00040004001B4O00040002000200062O00040017040100010004353O001704012O00880004000C3O00200D0004000400584O00065O00202O0006000600594O00040006000200062O00040019040100010004353O00190401002EED00D5002C040100D40004353O002C04012O0088000400044O00060005001C3O00202O0005000500D64O0006000C3O00202O0006000600B24O00085O00202O0008000800B34O0006000800024O000600066O00040006000200062O00040027040100010004353O00270401002EED00D8002C040100D70004353O002C04012O0088000400013O0012AA000500D93O0012AA000600DA4O008F000400064O005100045O0012AA000300213O0004353O00EC02010004353O003004010004353O00E702010026E6000100F1040100DB0004353O00F104010012AA000200013O0026E600020037040100070004353O003704010012AA000100743O0004353O00F10401002E3400DD00AB040100DC0004353O00AB04010026E6000200AB040100010004353O00AB04012O008800036O0015000400013O00122O000500DE3O00122O000600DF6O0004000600024O00030003000400202O0003000300184O00030002000200062O0003008904013O0004353O008904012O0088000300063O0006220103008904013O0004353O008904012O008800036O0064000400013O00122O000500E03O00122O000600E16O0004000600024O00030003000400202O0003000300E24O00030002000200262O00030077040100070004353O007704012O008800036O0015000400013O00122O000500E33O00122O000600E46O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003007C04013O0004353O007C04012O008800036O0015000400013O00122O000500E53O00122O000600E66O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003006D04013O0004353O006D04012O00880003000C3O00200D0003000300584O00055O00202O0005000500594O00030005000200062O0003007C040100010004353O007C04012O008800036O00E9000400013O00122O000500E73O00122O000600E86O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003007C040100010004353O007C04012O0088000300033O00201C01030003008D2O000F0103000200020026C300030089040100E90004353O008904012O0088000300044O00D100045O00202O00040004001E4O000500056O000500056O00030005000200062O0003008904013O0004353O008904012O0088000300013O0012AA000400EA3O0012AA000500EB4O008F000300054O005100035O002E0501EC0021000100EC0004353O00AA04012O008800036O0015000400013O00122O000500ED3O00122O000600EE6O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300AA04013O0004353O00AA04012O0088000300113O000622010300AA04013O0004353O00AA04012O00880003000B3O000EBC000700AA040100030004353O00AA0401002EED00F000AA040100EF0004353O00AA04012O0088000300044O00D100045O00202O0004000400714O000500056O000500056O00030005000200062O000300AA04013O0004353O00AA04012O0088000300013O0012AA000400F13O0012AA000500F24O008F000300054O005100035O0012AA000200213O002EED00F40033040100F30004353O003304010026E600020033040100210004353O003304012O008800036O0015000400013O00122O000500F53O00122O000600F66O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300C904013O0004353O00C904012O0088000300023O000622010300C904013O0004353O00C904012O0088000300044O00D100045O00202O0004000400114O000500056O000500056O00030005000200062O000300C904013O0004353O00C904012O0088000300013O0012AA000400F73O0012AA000500F84O008F000300054O005100036O008800036O0015000400013O00122O000500F93O00122O000600FA6O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300EF04013O0004353O00EF04012O0088000300103O000622010300EF04013O0004353O00EF04012O00880003000B3O0026E6000300EF040100210004353O00EF04012O00880003000C3O00206F0003000300704O00055O00202O00050005005B4O00030005000200062O000300EF04013O0004353O00EF04012O0088000300044O00A200045O00202O00040004005D4O000500056O000500056O00030005000200062O000300EA040100010004353O00EA0401002EED00FC00EF040100FB0004353O00EF04012O0088000300013O0012AA000400FD3O0012AA000500FE4O008F000300054O005100035O0012AA000200073O0004353O003304010026D6000100F5040100080004353O00F50401002E342O0001E5050100FF0004353O00E505012O0088000200164O0088000300173O0006870002000F050100030004353O000F05012O00880002001F3O0006220102000F05013O0004353O000F05012O0088000200203O0006220102000205013O0004353O000205012O00880002001A3O0006520002002O050100010004353O002O05012O0088000200203O0006520002000F050100010004353O000F05012O008800026O00E9000300013O00122O0004002O012O00122O00050002015O0003000500024O00020002000300202O0002000200184O00020002000200062O00020013050100010004353O001305010012AA00020003012O0012AA00030004012O00068700020027050100030004353O002705010012AA00020005012O0012AA00030005012O00060B01020027050100030004353O002705012O0088000200044O005900035O00202O0003000300CA4O0004000C3O00202O0004000400484O0006000F6O0004000600024O000400046O00020004000200062O0002002705013O0004353O002705012O0088000200013O0012AA00030006012O0012AA00040007013O008F000200044O005100025O0012AA00020008012O0012AA00030009012O00063E00020061050100030004353O006105012O008800026O0015000300013O00122O0004000A012O00122O0005000B015O0003000500024O00020002000300202O0002000200184O00020002000200062O0002006105013O0004353O006105012O0088000200213O0006220102006105013O0004353O006105012O00880002000B3O0012AA000300073O00068700030061050100020004353O006105012O008800026O00E9000300013O00122O0004000C012O00122O0005000D015O0003000500024O00020002000300202O00020002001B4O00020002000200062O0002004C050100010004353O004C05012O00880002000C3O0012AA0004000E013O00C90002000200042O000F0102000200020006220102006105013O0004353O006105012O0088000200044O00F400035O00122O0004000F015O0003000300044O0004000C3O00202O0004000400484O0006000F6O0004000600024O000400046O00020004000200062O0002005C050100010004353O005C05010012AA00020010012O0012AA00030011012O00063E00030061050100020004353O006105012O0088000200013O0012AA00030012012O0012AA00040013013O008F000200044O005100026O008800026O0015000300013O00122O00040014012O00122O00050015015O0003000500024O00020002000300202O0002000200184O00020002000200062O000200B105013O0004353O00B105012O0088000200063O000622010200B105013O0004353O00B105012O00880002000B3O0012AA000300213O00060B010200B1050100030004353O00B105012O008800026O001E000300013O00122O00040016012O00122O00050017015O0003000500024O00020002000300202O0002000200E24O00020002000200122O000300073O00062O00020096050100030004353O009605012O008800026O00E9000300013O00122O00040018012O00122O00050019015O0003000500024O00020002000300202O00020002001B4O00020002000200062O00020096050100010004353O009605012O00880002000C3O0012970004001A015O0002000200044O00045O00202O0004000400594O00020004000200062O000200A0050100010004353O00A005012O0088000200033O0012320004001B015O0002000200044O00020002000200122O0003001C012O00062O000200A0050100030004353O00A005012O008800026O0015000300013O00122O0004001D012O00122O0005001E015O0003000500024O00020002000300202O00020002001B4O00020002000200062O000200B105013O0004353O00B105012O0088000200044O00A200035O00202O00030003001E4O000400056O000400046O00020004000200062O000200AC050100010004353O00AC05010012AA0002001F012O0012AA00030020012O00063E000300B1050100020004353O00B105012O0088000200013O0012AA00030021012O0012AA00040022013O008F000200044O005100025O0012AA00020023012O0012AA00030024012O00063E000200E4050100030004353O00E405012O008800026O0015000300013O00122O00040025012O00122O00050026015O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200E405013O0004353O00E405012O0088000200153O000622010200E405013O0004353O00E405012O00880002000B3O0012AA000300213O00060B010200E4050100030004353O00E405012O008800026O00E9000300013O00122O00040027012O00122O00050028015O0003000500024O00020002000300202O00020002001B4O00020002000200062O000200E4050100010004353O00E405012O0088000200033O00126E0004001B015O0002000200044O00020002000200122O000300E93O00062O000300E4050100020004353O00E405012O0088000200044O00D100035O00202O0003000300A04O000400056O000400046O00020004000200062O000200E405013O0004353O00E405012O0088000200013O0012AA00030029012O0012AA0004002A013O008F000200044O005100025O0012AA000100DB3O0012AA000200103O000604000100EC050100020004353O00EC05010012AA0002002B012O0012AA0003002C012O00063E0002002B070100030004353O002B07010012AA000200013O0012AA000300073O00060B010300F2050100020004353O00F205010012AA000100043O0004353O002B07010012AA0003002D012O0012AA0004002D012O00060B01030088060100040004353O008806010012AA000300213O00060B01020088060100030004353O008806012O008800036O0015000400013O00122O0005002E012O00122O0006002F015O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003806013O0004353O003806012O0088000300123O0006220103003806013O0004353O003806012O00880003000B3O0012AA000400073O00063C00040024060100030004353O002406012O008800036O0015000400013O00122O00050030012O00122O00060031015O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003003806013O0004353O003806012O0088000300033O0020D700030003000C4O00055O00122O00060032015O0005000500064O00030005000200062O00030024060100010004353O002406012O0088000300033O00202701030003000C4O00055O00122O00060033015O0005000500064O00030005000200062O0003003806013O0004353O003806010012AA00030034012O0012AA00040034012O00060B01030038060100040004353O003806012O0088000300044O005900045O00202O00040004007D4O0005000C3O00202O0005000500484O0007000F6O0005000700024O000500056O00030005000200062O0003003806013O0004353O003806012O0088000300013O0012AA00040035012O0012AA00050036013O008F000300054O005100036O008800036O0015000400013O00122O00050037012O00122O00060038015O0004000600024O00030003000400202O0003000300184O00030002000200062O0003008706013O0004353O008706012O0088000300223O0006220103008706013O0004353O008706012O0088000300033O00201C01030003008D2O000F0103000200020012AA00040039012O00063C00030076060100040004353O007606012O008800036O0015000400013O00122O0005003A012O00122O0006003B015O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003008706013O0004353O008706012O00880003000C3O00205B00030003005A4O00055O00202O00050005005B4O00030005000200122O000400013O00062O00040087060100030004353O008706012O0088000300033O00206F00030003000C4O00055O00202O00050005000D4O00030005000200062O0003006806013O0004353O006806012O00880003000B3O0012AA000400073O00063C00040076060100030004353O007606012O00880003000C3O00200D0003000300584O00055O00202O0005000500594O00030005000200062O00030076060100010004353O007606012O0088000300033O00206F00030003000C4O00055O00202O0005000500AC4O00030005000200062O0003008706013O0004353O008706012O0088000300044O002900045O00122O0005003C015O0004000400054O0005000C3O00202O0005000500484O0007000F6O0005000700024O000500056O00030005000200062O0003008706013O0004353O008706012O0088000300013O0012AA0004003D012O0012AA0005003E013O008F000300054O005100035O0012AA000200073O0012AA000300013O00060B010200ED050100030004353O00ED05010012AA000300013O0012AA000400213O00060B01040091060100030004353O009106010012AA000200213O0004353O00ED05010012AA0004003F012O0012AA00050040012O0006870005008C060100040004353O008C06010012AA000400013O00060B0103008C060100040004353O008C06012O0088000400164O0088000500173O000687000400E7060100050004353O00E706012O00880004001D3O000622010400E706013O0004353O00E706012O00880004001E3O000622010400A506013O0004353O00A506012O00880004001A3O000652000400A8060100010004353O00A806012O00880004001E3O000652000400E7060100010004353O00E706012O008800046O0015000500013O00122O00060041012O00122O00070042015O0005000700024O00040004000500202O0004000400184O00040002000200062O000400E706013O0004353O00E706012O00880004000B3O0012AA000500213O000687000500CE060100040004353O00CE06012O0088000400033O00200D00040004000C4O00065O00202O0006000600AC4O00040006000200062O000400DA060100010004353O00DA06012O008800046O00E9000500013O00122O00060043012O00122O00070044015O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400CE060100010004353O00CE06012O00880004000C3O00200D0004000400584O00065O00202O0006000600594O00040006000200062O000400DA060100010004353O00DA06012O00880004000B3O0012AA000500213O000687000500E7060100040004353O00E706012O00880004000C3O00205B00040004005A4O00065O00202O0006000600C74O00040006000200122O000500013O00062O000500E7060100040004353O00E706012O0088000400044O00D100055O00202O0005000500BE4O000600056O000600066O00040006000200062O000400E706013O0004353O00E706012O0088000400013O0012AA00050045012O0012AA00060046013O008F000400064O005100046O008800046O0015000500013O00122O00060047012O00122O00070048015O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004002807013O0004353O002807012O0088000400133O0006220104002807013O0004353O002807012O00880004000B3O0012AA000500073O00063C00050017070100040004353O001707012O008800046O00E9000500013O00122O00060049012O00122O0007004A015O0005000700024O00040004000500202O00040004001B4O00040002000200062O00040028070100010004353O002807012O0088000400033O00202701040004000C4O00065O00122O00070032015O0006000600074O00040006000200062O0004002807013O0004353O002807012O008800046O0067000500013O00122O0006004B012O00122O0007004C015O0005000700024O00040004000500202O0004000400444O0004000200024O000500033O00202O0005000500554O00050002000200068700050028070100040004353O002807012O0088000400044O00A200055O00202O0005000500844O000600056O000600066O00040006000200062O00040023070100010004353O002307010012AA0004004D012O0012AA0005004E012O00068700040028070100050004353O002807012O0088000400013O0012AA0005004F012O0012AA00060050013O008F000400064O005100045O0012AA000300213O0004353O008C06010004353O00ED05010012AA000200A33O00060400010032070100020004353O003207010012AA00020051012O0012AA00030052012O00068700030095070100020004353O009507010012AA00020053012O0012AA00030054012O00068700020062070100030004353O006207012O008800026O0015000300013O00122O00040055012O00122O00050056015O0003000500024O00020002000300202O0002000200184O00020002000200062O0002006207013O0004353O006207012O0088000200213O0006220102006207013O0004353O006207012O008800026O0015000300013O00122O00040057012O00122O00050058015O0003000500024O00020002000300202O00020002001B4O00020002000200062O0002006207013O0004353O006207012O0088000200044O00F400035O00122O0004000F015O0003000300044O0004000C3O00202O0004000400484O0006000F6O0004000600024O000400046O00020004000200062O0002005D070100010004353O005D07010012AA00020059012O0012AA0003005A012O00068700030062070100020004353O006207012O0088000200013O0012AA0003005B012O0012AA0004005C013O008F000200044O005100025O0012AA0002005D012O0012AA0003005E012O00068700030065080100020004353O006508012O00880002001A3O0006220102006508013O0004353O006508012O0088000200164O0088000300173O00068700020065080100030004353O006508012O00880002001D3O0006220102006508013O0004353O006508012O00880002001E3O0006220102007607013O0004353O007607012O00880002001A3O00065200020079070100010004353O007907012O00880002001E3O00065200020065080100010004353O006508012O008800026O0015000300013O00122O0004005F012O00122O00050060015O0003000500024O00020002000300202O0002000200184O00020002000200062O0002006508013O0004353O006508010012AA00020061012O0012AA00030062012O00063E00020065080100030004353O006508012O0088000200044O00D100035O00202O0003000300BE4O000400056O000400046O00020004000200062O0002006508013O0004353O006508012O0088000200013O00122300030063012O00122O00040064015O000200046O00025O00044O006508010012AA00020065012O0012AA00030066012O00063E00020007000100030004353O000700010012AA000200213O00060B2O010007000100020004353O000700010012AA000200013O0012AA000300213O000604000300A4070100020004353O00A407010012AA00030067012O0012AA00040068012O00063E000400F8070100030004353O00F807012O0088000300164O0088000400173O000687000300CF070100040004353O00CF07012O0088000300233O000622010300CF07013O0004353O00CF07012O0088000300243O000622010300B107013O0004353O00B107012O00880003001A3O000652000300B4070100010004353O00B407012O0088000300243O000652000300CF070100010004353O00CF07012O008800036O0015000400013O00122O00050069012O00122O0006006A015O0004000600024O00030003000400202O0003000300184O00030002000200062O000300CF07013O0004353O00CF07012O0088000300073O00201001030003002A4O00045O00122O0005006B015O0004000400054O000500086O000600256O000700056O000700076O00030007000200062O000300CF07013O0004353O00CF07012O0088000300013O0012AA0004006C012O0012AA0005006D013O008F000300054O005100036O0088000300164O0088000400173O000687000300F7070100040004353O00F707012O0088000300233O000622010300F707013O0004353O00F707012O0088000300243O000622010300DC07013O0004353O00DC07012O00880003001A3O000652000300DF070100010004353O00DF07012O0088000300243O000652000300F7070100010004353O00F707012O008800036O0015000400013O00122O0005006E012O00122O0006006F015O0004000600024O00030003000400202O0003000300184O00030002000200062O000300F707013O0004353O00F707012O0088000300044O00C700045O00122O0005006B015O0004000400054O000500056O000500056O00030005000200062O000300F707013O0004353O00F707012O0088000300013O0012AA00040070012O0012AA00050071013O008F000300054O005100035O0012AA000200073O0012AA00030072012O0012AA00040073012O00063E00030001080100040004353O000108010012AA000300073O00060B01030001080100020004353O000108010012AA000100073O0004353O000700010012AA000300013O00060B0102009D070100030004353O009D07012O0088000300164O0088000400173O0006870003001E080100040004353O001E08012O0088000300263O0006220103001E08013O0004353O001E08012O0088000300273O0006220103001108013O0004353O001108012O00880003001A3O00065200030014080100010004353O001408012O0088000300273O0006520003001E080100010004353O001E08012O008800036O00E9000400013O00122O00050074012O00122O00060075015O0004000600024O00030003000400202O0003000300184O00030002000200062O00030022080100010004353O002208010012AA00030076012O0012AA00040077012O00063E00040034080100030004353O003408010012AA00030078012O0012AA00040079012O00063E00030034080100040004353O003408012O0088000300044O00C700045O00122O0005007A015O0004000400054O000500056O000500056O00030005000200062O0003003408013O0004353O003408012O0088000300013O0012AA0004007B012O0012AA0005007C013O008F000300054O005100036O0088000300164O0088000400173O00068700030060080100040004353O006008012O008800036O0015000400013O00122O0005007D012O00122O0006007E015O0004000600024O00030003000400202O0003000300184O00030002000200062O0003006008013O0004353O006008012O0088000300283O0006220103006008013O0004353O006008012O0088000300293O0006220103004B08013O0004353O004B08012O00880003001A3O0006520003004E080100010004353O004E08012O0088000300293O00065200030060080100010004353O006008012O00880003000B3O0012AA000400213O00068700040060080100030004353O006008012O0088000300044O00C700045O00122O0005007F015O0004000400054O000500056O000500056O00030005000200062O0003006008013O0004353O006008012O0088000300013O0012AA00040080012O0012AA00050081013O008F000300054O005100035O0012AA000200213O0004353O009D07010004353O000700010004353O006508010004353O000200012O004D3O00017O00CA3O00028O00026O00144003093O0026BB386119A22A761B03043O001369CD5D030A3O0049734361737461626C6503093O004F766572706F776572025O00C4AA40025O00D49B4003143O00A61EDB932FA61FDB937FAC10DB822ABD0D9ED76B03053O005FC968BEE1030A3O008DC7C0CAAAD8D5C1BDC603043O00AECFABA1025O0018B140025O00CCAF40030A3O00426C61646573746F726D025O00288940025O0042B04003153O00EFF20CF7FDC4F9F11FFEB8D2F5FB0EE6ECD2ADA85803063O00B78D9E6D9398026O001040025O0028B340026O00F03F025O00BAA340025O0023B24003093O000222A0CE66A0C0833F03083O00E64D54C5BC16CFB703043O0052616765026O00444003093O0042752O66537461636B03123O004D61727469616C50726F77652O7342752O66027O0040025O001EAF40025O00F8914003143O00F602C3EE9CAEE730EB54C3E489A2E521FC5490AC03083O00559974A69CECC19003073O0081F848B0F114A103063O0060C4802DD38403073O0049735265616479025O00C4AF40025O0097B04003073O004578656375746503123O0030957E5CC7BBB19830957E5CC7BBB19863DF03083O00B855ED1B3FB2CFD403093O003B51065C034E08490D03043O003F68396903093O003888AA4D08A5AB4B0603043O00246BE7C4030B3O004973417661696C61626C6503093O00497343617374696E67025O00989640025O0008814003093O0053686F636B77617665030E3O004973496E4D656C2O6552616E676503143O004EBDAD8456A2A39158F5A79F58B6B79358F5F4D403043O00E73DD5C2030F3O007C42710D5F5C7A0F7C41660144506703043O00682F3514025O00408340025O00E06840030F3O0053772O6570696E67537472696B6573031B3O00B05B8419AC06AD4BBE0FA81DAA47840FFC0ABB498209A80AE319D003063O006FC32CE17CDC03043O00EA430E7703063O00CBB8266013CB030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O662O033O00474344030C3O001B7F764ECA35766D55C7377403053O00AE59131921030A3O001813404CE5820A24174003073O006B4F72322E97E7030D3O001AA9B926992AA2D30AABB43A8203083O00A059C6D549EA59D7030F3O00432O6F6C646F776E52656D61696E73030A3O007F70A6FCD74D70BFFBD703053O00A52811D49E030A3O00D2D81A3134E0D803363403053O004685B9685303093O0054696D65546F446965026O002840025O0020B140025O00D0A140025O00D4B140025O00B0824003043O0052656E64030F3O0016404A2E89015D4129DC1040047F9B03053O00A96425244A03063O002191A344019503043O003060E7C2030D3O00EB5502220ACBBA90FB570F3E1103083O00E3A83A6E4D79B8CF030A3O00432O6F6C646F776E557003083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O66026O003440025O0046AD4003063O0041766174617203113O007A2ABE54B0C931A06339BC55A5DE31F02803083O00C51B5CDF20D1BB11025O0062AE40025O009EB24003063O009B8834A2EB9903073O001DEBE455DB8EEB030E3O000EC4BFDC654121703CC7AED4784003083O00325DB4DABD172E4703063O0042752O665570030F3O00546573746F664D6967687442752O66025O0088A440025O0040A34003143O0053706561724F6642617374696F6E506C61796572030E3O0049735370652O6C496E52616E6765030E3O0053706561726F6642617374696F6E031B3O00CDB45E4D56E347D89B594D57C841D1AA1B495CD94BCBB05E0C118B03073O0028BEC43B2C24BC026O000840025O00FAA840025O006EA740025O00C08D40025O00C05140025O0056A240025O00707A40025O0085B340025O00A7B240030D3O00F724342803D73F2O2D1BD02A3303053O006FA44F4144030B3O00F2DC90CA21ECEBD084D63A03063O008AA6B9E3BE4E030E3O005261676550657263656E74616765026O003E40030B3O00FF71D6235D2534C273CD2303073O0079AB14A5573243030D3O00E537B539AA11D32B8A3BB811CE03063O0062A658D956D9025O000AAA40025O0068AC40030D3O00536B752O6C73706C692O74657203183O00E5FD6C0D8ACFE6FA701592D9E4B67C1983DFE3E27C41D38B03063O00BC2O961961E6025O00F4AC40025O00B2A240030E3O00EE814A0C08E8C8864A113EE2DB9B03063O008DBAE93F626C030B3O00C5EF3FA22AF7C725B12DE503053O0045918A4CD6030E3O005468756E6465726F7573526F6172031A3O0064C79C87BB1362C09C9A80047FCE9BC9BA0E75CC9C9DBA56259803063O007610AF2OE9DF025O00709B40025O003EAD40025O004CA440025O0028A940030A3O00345ED1F9115AC2F0064D03043O009B633FA3025O0062B340025O00B8AC40030A3O00576172627265616B657203153O0095D0B38FAB8183DAA49FF9819AD4A298AD81C284F503063O00E4E2B1C1EDD9030D3O0017BF2FE927A336F507BD22F53C03043O008654D043025O0016AB40025O007AA940025O00D49640025O000AA240030D3O00436F6C6F2O737573536D61736803193O0010A38A5300BF934F2CBF8B5D00A4C6590BA9854907A9C6094603043O003C73CCE603073O00C222EE73F22EEE03043O0010875A8B030F3O0053752O64656E446561746842752O6603103O00442O6570576F756E6473446562752O6603123O00516C03305B407D14711E364D416C5134536503073O0018341466532E34025O003DB240025O00F07F40025O007EB040025O00309D40030C3O0001DED40EF3CDDE5E3ED8CD1F03083O002A4CB1A67A92A18D030B3O00446562752O66537461636B031B3O00457865637574696F6E657273507265636973696F6E446562752O66030C3O004D6F7274616C537472696B6503183O00A88517DA787A9A9911DC707DA0CA00D67C75B09E008E2C2F03063O0016C5EA65AE19025O0024A840025O0080594003063O003F50CEA7F56F03073O006D5C25BCD49A1D030E3O0037FFA1C2235502CDA5D025530BE103063O003A648FC4A351025O0039B040025O00C4974003143O0053706561724F6642617374696F6E437572736F72031B3O00095226A22D76EA08254022B02B40EA005A473BA63C5CF10B5A177403083O006E7A2243C35F298503063O0056BD5E4BC07003053O00B615D13B2A03063O00436C6561766503113O00B45BC01C37BBF752DD1822ABA35285487903063O00DED737A57D41025O00206F40025O00C0564000D2032O0012AA3O00014O00B4000100013O0026E63O0002000100010004353O000200010012AA000100013O0026E60001004F000100020004353O004F00012O008800026O0015000300013O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062O0002002300013O0004353O002300012O0088000200023O0006220102002300013O0004353O002300012O0088000200034O00A200035O00202O0003000300064O000400046O000400046O00020004000200062O0002001E000100010004353O001E0001002EED00070023000100080004353O002300012O0088000200013O0012AA000300093O0012AA0004000A4O008F000200044O005100026O0088000200054O0088000300063O0006870002003D000100030004353O003D00012O0088000200073O0006220102003D00013O0004353O003D00012O0088000200083O0006220102003000013O0004353O003000012O0088000200093O00065200020033000100010004353O003300012O0088000200083O0006520002003D000100010004353O003D00012O008800026O00E9000300013O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O0002000200054O00020002000200062O0002003F000100010004353O003F0001002EED000D00D10301000E0004353O00D103012O0088000200034O00A200035O00202O00030003000F4O000400046O000400046O00020004000200062O00020049000100010004353O00490001002E34001100D1030100100004353O00D103012O0088000200013O001223000300123O00122O000400136O000200046O00025O00044O00D10301002O0E001400D8000100010004353O00D800010012AA000200013O002O0E000100A5000100020004353O00A500010012AA000300013O002E0501150006000100150004353O005B0001002O0E0016005B000100030004353O005B00010012AA000200163O0004353O00A500010026D60003005F000100010004353O005F0001002E3400180055000100170004353O005500012O008800046O0015000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O0004000400054O00040002000200062O0004007800013O0004353O007800012O0088000400023O0006220104007800013O0004353O007800012O00880004000A3O00201C01040004001B2O000F0104000200020026C3000400780001001C0004353O007800012O00880004000A3O00200500040004001D4O00065O00202O00060006001E4O00040006000200262O0004007A0001001F0004353O007A0001002E3400200087000100210004353O008700012O0088000400034O00D100055O00202O0005000500064O000600046O000600066O00040006000200062O0004008700013O0004353O008700012O0088000400013O0012AA000500223O0012AA000600234O008F000400064O005100046O008800046O0015000500013O00122O000600243O00122O000700256O0005000700024O00040004000500202O0004000400264O00040002000200062O000400A300013O0004353O00A300012O00880004000B3O000622010400A300013O0004353O00A30001002E34002700A3000100280004353O00A300012O0088000400034O00D100055O00202O0005000500294O000600046O000600066O00040006000200062O000400A300013O0004353O00A300012O0088000400013O0012AA0005002A3O0012AA0006002B4O008F000400064O005100045O0012AA000300163O0004353O00550001002O0E00160052000100020004353O005200012O008800036O0015000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400202O0003000300054O00030002000200062O000300C300013O0004353O00C300012O00880003000C3O000622010300C300013O0004353O00C300012O008800036O00E9000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O0003000300304O00030002000200062O000300C5000100010004353O00C500012O00880003000D3O00201C0103000300312O000F010300020002000652000300C5000100010004353O00C50001002E34003200D5000100330004353O00D500012O0088000300034O005900045O00202O0004000400344O0005000D3O00202O0005000500354O0007000E6O0005000700024O000500056O00030005000200062O000300D500013O0004353O00D500012O0088000300013O0012AA000400363O0012AA000500374O008F000300054O005100035O0012AA000100023O0004353O00D800010004353O005200010026E60001009D2O0100010004353O009D2O012O0088000200054O0088000300063O000687000200EE000100030004353O00EE00012O00880002000F3O000622010200EE00013O0004353O00EE00012O008800026O0015000300013O00122O000400383O00122O000500396O0003000500024O00020002000300202O0002000200054O00020002000200062O000200EE00013O0004353O00EE00012O0088000200103O000EE3001600F0000100020004353O00F00001002E05013A00120001003B0004354O002O012O0088000200034O005900035O00202O00030003003C4O0004000D3O00202O0004000400354O0006000E6O0004000600024O000400046O00020004000200062O00022O002O013O0004354O002O012O0088000200013O0012AA0003003D3O0012AA0004003E4O008F000200044O005100026O008800026O0015000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300202O0002000200264O00020002000200062O0002004E2O013O0004353O004E2O012O0088000200113O0006220102004E2O013O0004353O004E2O012O00880002000D3O0020230102000200414O00045O00202O0004000400424O0002000400024O0003000A3O00202O0003000300434O00030002000200062O0002004E2O0100030004353O004E2O012O008800026O00E9000300013O00122O000400443O00122O000500456O0003000500024O00020002000300202O0002000200304O00020002000200062O0002004E2O0100010004353O004E2O012O008800026O00E9000300013O00122O000400463O00122O000500476O0003000500024O00020002000300202O0002000200304O00020002000200062O000200352O0100010004353O00352O012O008800026O001B010300013O00122O000400483O00122O000500496O0003000500024O00020002000300202O00020002004A4O00020002000200262O000200492O0100140004353O00492O012O008800026O0015000300013O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300202O0002000200304O00020002000200062O0002004E2O013O0004353O004E2O012O008800026O0092000300013O00122O0004004D3O00122O0005004E6O0003000500024O00020002000300202O00020002004A4O00020002000200262O0002004E2O0100140004353O004E2O012O00880002000D3O00201C01020002004F2O000F010200020002000EE3005000502O0100020004353O00502O01002EED0051005F2O0100520004353O005F2O01002E340054005F2O0100530004353O005F2O012O0088000200034O00D100035O00202O0003000300554O000400046O000400046O00020004000200062O0002005F2O013O0004353O005F2O012O0088000200013O0012AA000300563O0012AA000400574O008F000200044O005100026O0088000200054O0088000300063O0006870002009C2O0100030004353O009C2O012O0088000200123O0006220102009C2O013O0004353O009C2O012O0088000200133O0006220102006C2O013O0004353O006C2O012O0088000200093O0006520002006F2O0100010004353O006F2O012O0088000200133O0006520002009C2O0100010004353O009C2O012O008800026O0015000300013O00122O000400583O00122O000500596O0003000500024O00020002000300202O0002000200054O00020002000200062O0002009C2O013O0004353O009C2O012O008800026O00E9000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O00020002005C4O00020002000200062O0002008D2O0100010004353O008D2O012O00880002000D3O00200D00020002005D4O00045O00202O00040004005E4O00020004000200062O0002008D2O0100010004353O008D2O012O0088000200063O0026C30002009C2O01005F0004353O009C2O01002E050160000F000100600004353O009C2O012O0088000200034O00D100035O00202O0003000300614O000400046O000400046O00020004000200062O0002009C2O013O0004353O009C2O012O0088000200013O0012AA000300623O0012AA000400634O008F000200044O005100025O0012AA000100163O0026E60001008E0201001F0004353O008E02010012AA000200013O002E34006400E82O0100650004353O00E82O010026E6000200E82O0100160004353O00E82O012O0088000300054O0088000400063O000687000300E62O0100040004353O00E62O012O0088000300143O000622010300E62O013O0004353O00E62O012O0088000300153O000622010300B12O013O0004353O00B12O012O0088000300093O000652000300B42O0100010004353O00B42O012O0088000300153O000652000300E62O0100010004353O00E62O012O0088000300164O004F000400013O00122O000500663O00122O000600676O00040006000200062O000300E62O0100040004353O00E62O012O008800036O0015000400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O0003000300054O00030002000200062O000300E62O013O0004353O00E62O012O00880003000D3O00200D00030003005D4O00055O00202O00050005005E4O00030005000200062O000300D32O0100010004353O00D32O012O00880003000A3O00206F00030003006A4O00055O00202O00050005006B4O00030005000200062O000300E62O013O0004353O00E62O01002E34006D00E62O01006C0004353O00E62O012O0088000300034O00D9000400173O00202O00040004006E4O0005000D3O00202O00050005006F4O00075O00202O0007000700704O0005000700024O000500056O00030005000200062O000300E62O013O0004353O00E62O012O0088000300013O0012AA000400713O0012AA000500724O008F000300054O005100035O0012AA000100733O0004353O008E02010026D6000200EC2O0100010004353O00EC2O01002EED007400A02O0100750004353O00A02O010012AA000300013O0026D6000300F12O0100160004353O00F12O01002EED007600F32O0100770004353O00F32O010012AA000200163O0004353O00A02O01002EED007900ED2O0100780004353O00ED2O010026E6000300ED2O0100010004353O00ED2O01002EED007B00470201007A0004353O004702012O008800046O0015000500013O00122O0006007C3O00122O0007007D6O0005000700024O00040004000500202O0004000400054O00040002000200062O0004004702013O0004353O004702012O0088000400183O0006220104004702013O0004353O004702012O008800046O0015000500013O00122O0006007E3O00122O0007007F6O0005000700024O00040004000500202O0004000400304O00040002000200062O0004001502013O0004353O001502012O00880004000A3O00201C0104000400802O000F0104000200020026C200040035020100810004353O003502012O008800046O00E9000500013O00122O000600823O00122O000700836O0005000700024O00040004000500202O0004000400304O00040002000200062O00040047020100010004353O004702012O00880004000D3O00200D00040004005D4O00065O00202O00060006005E4O00040006000200062O00040030020100010004353O003002012O008800046O002E000500013O00122O000600843O00122O000700856O0005000700024O00040004000500202O00040004004A4O000400020002000E2O00020047020100040004353O004702012O00880004000A3O00201C0104000400802O000F0104000200020026AC00040047020100810004353O00470201002E3400860047020100870004353O004702012O0088000400034O005900055O00202O0005000500884O0006000D3O00202O0006000600354O0008000E6O0006000800024O000600066O00040006000200062O0004004702013O0004353O004702012O0088000400013O0012AA000500893O0012AA0006008A4O008F000400064O005100045O002EED008C008B0201008B0004353O008B02012O0088000400054O0088000500063O0006870004008B020100050004353O008B02012O0088000400193O0006220104008B02013O0004353O008B02012O00880004001A3O0006220104005602013O0004353O005602012O0088000400093O00065200040059020100010004353O005902012O00880004001A3O0006520004008B020100010004353O008B02012O008800046O0015000500013O00122O0006008D3O00122O0007008E6O0005000700024O00040004000500202O0004000400054O00040002000200062O0004008B02013O0004353O008B02012O00880004000A3O00200D00040004006A4O00065O00202O00060006006B4O00040006000200062O0004007B020100010004353O007B02012O008800046O00E9000500013O00122O0006008F3O00122O000700906O0005000700024O00040004000500202O0004000400304O00040002000200062O0004008B020100010004353O008B02012O00880004000D3O00206F00040004005D4O00065O00202O00060006005E4O00040006000200062O0004008B02013O0004353O008B02012O0088000400034O005900055O00202O0005000500914O0006000D3O00202O0006000600354O0008000E6O0006000800024O000600066O00040006000200062O0004008B02013O0004353O008B02012O0088000400013O0012AA000500923O0012AA000600934O008F000400064O005100045O0012AA000300163O0004353O00ED2O010004353O00A02O01002E340094001F030100950004353O001F0301002O0E0016001F030100010004353O001F03010012AA000200014O00B4000300033O002EED00960094020100970004353O009402010026E600020094020100010004353O009402010012AA000300013O0026E6000300F0020100010004353O00F002012O0088000400054O0088000500063O000687000400B5020100050004353O00B502012O00880004001B3O000622010400B502013O0004353O00B502012O00880004001C3O000622010400A802013O0004353O00A802012O0088000400093O000652000400AB020100010004353O00AB02012O00880004001C3O000652000400B5020100010004353O00B502012O008800046O00E9000500013O00122O000600983O00122O000700996O0005000700024O00040004000500202O0004000400054O00040002000200062O000400B7020100010004353O00B70201002EED009A00C40201009B0004353O00C402012O0088000400034O00D100055O00202O00050005009C4O000600046O000600066O00040006000200062O000400C402013O0004353O00C402012O0088000400013O0012AA0005009D3O0012AA0006009E4O008F000400064O005100046O0088000400054O0088000500063O000687000400DE020100050004353O00DE02012O00880004001D3O000622010400DE02013O0004353O00DE02012O00880004001E3O000622010400D102013O0004353O00D102012O0088000400093O000652000400D4020100010004353O00D402012O00880004001E3O000652000400DE020100010004353O00DE02012O008800046O00E9000500013O00122O0006009F3O00122O000700A06O0005000700024O00040004000500202O0004000400054O00040002000200062O000400E0020100010004353O00E00201002E3400A100EF020100A20004353O00EF0201002EED00A300EF020100A40004353O00EF02012O0088000400034O00D100055O00202O0005000500A54O000600046O000600066O00040006000200062O000400EF02013O0004353O00EF02012O0088000400013O0012AA000500A63O0012AA000600A74O008F000400064O005100045O0012AA000300163O002O0E00160099020100030004353O009902012O008800046O0015000500013O00122O000600A83O00122O000700A96O0005000700024O00040004000500202O0004000400264O00040002000200062O0004001A03013O0004353O001A03012O00880004000B3O0006220104001A03013O0004353O001A03012O00880004000A3O00206F00040004006A4O00065O00202O0006000600AA4O00040006000200062O0004001A03013O0004353O001A03012O00880004000D3O0020830004000400414O00065O00202O0006000600AB4O000400060002000E2O0001001A030100040004353O001A03012O0088000400034O00D100055O00202O0005000500294O000600046O000600066O00040006000200062O0004001A03013O0004353O001A03012O0088000400013O0012AA000500AC3O0012AA000600AD4O008F000400064O005100045O0012AA0001001F3O0004353O001F03010004353O009902010004353O001F03010004353O009402010026D600010023030100730004353O00230301002E3400AE0005000100AF0004353O000500010012AA000200013O0026D600020028030100160004353O00280301002EED00B00055030100B10004353O005503012O008800036O0015000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400202O0003000300264O00030002000200062O0003005303013O0004353O005303012O00880003001F3O0006220103005303013O0004353O005303012O00880003000D3O0020450003000300B44O00055O00202O0005000500B54O00030005000200262O000300460301001F0004353O004603012O00880003000D3O0020230103000300414O00055O00202O0005000500AB4O0003000500024O0004000A3O00202O0004000400434O00040002000200062O00030053030100040004353O005303012O0088000300034O00D100045O00202O0004000400B64O000500046O000500056O00030005000200062O0003005303013O0004353O005303012O0088000300013O0012AA000400B73O0012AA000500B84O008F000300054O005100035O0012AA000100143O0004353O000500010026E600020024030100010004353O002403010012AA000300013O002EED00BA00C6030100B90004353O00C603010026E6000300C6030100010004353O00C603012O0088000400054O0088000500063O0006870004009E030100050004353O009E03012O0088000400143O0006220104009E03013O0004353O009E03012O0088000400153O0006220104006903013O0004353O006903012O0088000400093O0006520004006C030100010004353O006C03012O0088000400153O0006520004009E030100010004353O009E03012O0088000400164O004F000500013O00122O000600BB3O00122O000700BC6O00050007000200062O0004009E030100050004353O009E03012O008800046O0015000500013O00122O000600BD3O00122O000700BE6O0005000700024O00040004000500202O0004000400054O00040002000200062O0004009E03013O0004353O009E03012O00880004000D3O00200D00040004005D4O00065O00202O00060006005E4O00040006000200062O0004008B030100010004353O008B03012O00880004000A3O00206F00040004006A4O00065O00202O00060006006B4O00040006000200062O0004009E03013O0004353O009E0301002E3400C0009E030100BF0004353O009E03012O0088000400034O00D9000500173O00202O0005000500C14O0006000D3O00202O00060006006F4O00085O00202O0008000800704O0006000800024O000600066O00040006000200062O0004009E03013O0004353O009E03012O0088000400013O0012AA000500C23O0012AA000600C34O008F000400064O005100046O008800046O0015000500013O00122O000600C43O00122O000700C56O0005000700024O00040004000500202O0004000400264O00040002000200062O000400C503013O0004353O00C503012O0088000400203O000622010400C503013O0004353O00C503012O0088000400103O000EBC001F00C5030100040004353O00C503012O00880004000D3O0020110104000400414O00065O00202O0006000600AB4O0004000600024O0005000A3O00202O0005000500434O00050002000200062O000400C5030100050004353O00C503012O0088000400034O00D100055O00202O0005000500C64O000600046O000600066O00040006000200062O000400C503013O0004353O00C503012O0088000400013O0012AA000500C73O0012AA000600C84O008F000400064O005100045O0012AA000300163O0026D6000300CA030100160004353O00CA0301002E3400C90058030100CA0004353O005803010012AA000200163O0004353O002403010004353O005803010004353O002403010004353O000500010004353O00D103010004353O000200012O004D3O00017O0056012O00028O00026O001040025O0004B240025O003C9C4003093O00CF27373AD9520B4AFC03083O0024984F5E48B5256203073O0049735265616479030D3O00E4CC482DDAD7410CC0D7553BC403043O005FB7B827030B3O004973417661696C61626C65030B3O00813AF4325B862FBC38EF3203073O0062D55F874634E0030E3O005261676550657263656E74616765026O00544003083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O6603093O00576869726C77696E64030E3O004973496E4D656C2O6552616E6765031B3O00E9ABC06558E9AAC77314EDAAC77058FB9CDD7646F9A6DD3705AEFB03053O00349EC3A917030B3O004EB4277A823069A876BD2203083O00EB1ADC5214E6551B030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O662O033O00474344030B3O00BCA8EDC77B8E83E5CD7B8C03053O0014E8C189A2030B3O005468756E646572436C6170031E3O0036D7D0A8E389054E21D3C4B6A79F1E7F25D3C099F38D057627CB85F7B7D503083O001142BFA5C687EC77026O00F03F030A3O002DA3AF17FAFBF8DE1DA203083O00B16FCFCE739F888C030A3O0049734361737461626C6503093O002D9C0206DD4C5E0B8C03073O003F65E97074B42F03063O0042752O665570030F3O00546573746F664D6967687442752O66030B3O00F73EFE06F730EE32EA1AEC03063O0056A35B8D729803083O0066057C7A34540E7003053O005A336B1413030B3O00B9F596FB328BDD8CE8359903053O005DED90E58F030A3O00426C61646573746F726D031C3O0017FAF11D0E5501F9E2144B551CF8F7150E7901F7E21E0E5255A7A14903063O0026759690796B026O001440025O00C88340025O0066B140030F3O001F1EE3093C00E80B1F1DF405270CF503043O006C4C6986030F3O0053772O6570696E67537472696B657303213O00F8D2B4E4DEE2CBB6DEDDFFD7B8EACBF885A2E8C0ECC9B4DEDAEAD7B6E4DAAB9CE603053O00AE8BA5D18103073O0086ABE7C2D3177503083O0018C3D382A1A66310030F3O0053752O64656E446561746842752O66025O0030A240025O00907740025O005EA94003073O004578656375746503183O00431BEC2F46022O43FA255D114A06D63852044106FD6C0A4E03063O00762663894C33025O00709540025O002AAF40030C3O00D0291706082CCE32171B022503063O00409D46657269030C3O004D6F7274616C537472696B65031E3O004DA7B5F7114C97B4F70249A3A2A30349A6A0EF157FBCA6F11745BCE7BA4903053O007020C8C783025O0080AD40025O00A89C40026O002040025O00109440025O002EAF4003063O00E00A46D3517B03073O0044A36623B2271E03063O00436C65617665025O005BB040025O00D2A94003183O00BD7CDFC615B0C302B77EDDCB068A9710AC77DFD343E4D14203083O0071DE10BAA763D5E3026O002240025O000C914003063O009973D672481F03063O007ADA1FB3133E03073O0048617354696572026O003D40027O0040030D3O0090C4D8D2C1A84BB4F0C2D3CAA403073O0025D3B6ADA1A9C1025O008CAD40025O0016AE4003183O00F43648D83E7EF9E43343DE247E86E33B5FDE2D6FF9A6681C03073O00D9975A2DB9481B030A3O00E170E61653D068E8005B03053O0036A31C8772031C3O002AD75C864B6C3CD44F8F0E6C21D55A8E4B403CDA4F854B6B688A0FD003063O001F48BB3DE22E025O00288540025O00B49240026O000840025O00DCAE40030E3O0085BA1B23F3DFB2BEA71D1FF8DBB203073O00C0D1D26E4D97BA030B3O00D40631FDF0C2CD0A25E1EB03063O00A4806342899F025O00802O40030B3O00348CFAAA0F8FC4B70781FD03043O00DE60E989030E3O005468756E6465726F7573526F617203213O00ADBBB2118CF6E2B6A6B4209AFCF1ABF3B41686F4FCBC8CB31E9AF4F5ADF3F64FDF03073O0090D9D3C77FE893025O00F0B240025O00A06140030D3O0041E3D1AF0750697EE1D0B70E5103073O00191288A4C36B23030B3O00DC28BA5B7DBAECB1EF25BD03083O00D8884DC92F12DCA103103O00442O6570576F756E6473446562752O66030D3O000EE327D51BCF973EDF26DB1BD403073O00E24D8C4BBA68BC030F3O00432O6F6C646F776E52656D61696E73025O00A4AB40025O003EAE40030D3O00536B752O6C73706C692O746572031F3O00AA2OC53343AADEDC365BADCBC27F5CB0C0D7334A86DAD12D48BCDA906E1FEC03053O002FD9AEB05F030D3O008BD6630EBE47682AB1C96207A003083O0046D8BD1662D23418030B3O00EEDAB0932ODCF2AA80DBCE03053O00B3BABFC3E7025O00C4AD40025O00B8A840031F3O00EA340DE8F52C08E8F02B0CE1EB7F0BEDF73814E1C62B19F6FE3A0CA4A86F4E03043O0084995F78025O00FAA340025O0052A440025O001CA240025O00E8904003043O001C0BF5F203043O00964E6E9B03113O00446562752O665265667265736861626C65030D3O00A6D732F2AC17B147A3CA35E2A103083O0020E5A54781C47EDF03043O0052656E64025O00AAA940025O00F2AA4003163O00D18CCA85C1C6CA87C38D84EAD788D68684C183D896D503063O00B5A3E9A42OE103093O001EB3E13926ACEF2C2803043O005A4DDB8E03093O00D50B2F304F2575E90903073O001A866441592C6703093O00497343617374696E67025O00688040025O0014954003093O0053686F636B77617665025O003AB040031B3O00E2EB3F20AFE6E22O26E4E2EA3E24A8F4DC2422B6F6E62463F5A0B203053O00C49183504303093O0029B80F1A14FF17BE0203063O00887ED0666878030D3O004B9EC151A25D3B626F85DC47BC03083O003118EAAE23CF325D030B3O0038F7EE9C7E0ADFF48F791803053O00116C929DE8030D3O0068CC18E23CBB5ED027E02EBB4303063O00C82BA3748D4F026O001C40025O00EEA240031B3O00A83E3491BCE3EAB1327D90B9FAE4B3330297B1E6E4BA227DD2E1A703073O0083DF565DE3D094025O0068B240025O00CAAD4003093O00CC53B3A40DBAF440A403063O00D583252OD67D03093O00093D20ADF1293C20AD03053O0081464B45DF03073O0043686172676573030A3O0064CAE7FD70EA4AC4E1ED03063O008F26AB93891C026O003940030A3O00F283ADE70FE6D8DF90BD03073O00B4B0E2D9936383025O00206340025O001EA04003093O004F766572706F776572025O0030A440031B3O00DCAF2A15C3B63802C1F93C0EDDBE2302ECAD2E15D4BC3B4782E87B03043O0067B3D94F026O001840025O006C9B40025O00A88540025O002OAA4003063O00E6A84523C02603063O005485DD3750AF030E3O008EF721A7D553BBC525B5D355B2E903063O003CDD8744C6A7030D3O00CDB2F48C51CAFBAECB8E43CAE603063O00B98EDD98E322030A3O006FC445F85136F653C04503073O009738A5379A235303143O0053706561724F6642617374696F6E437572736F72030E3O0049735370652O6C496E52616E6765030E3O0053706561726F6642617374696F6E025O00EFB140025O00E8A74003223O00B35300EFB27C0AE89F4104FDB44A0A2OE0500CE0A74F00D1B44217E9A55745BFF01103043O008EC02365030A3O00E1743BA1F589AD1DD36703083O0076B61549C387ECCC030A3O00576172627265616B657203093O004973496E52616E6765025O00B8A940025O00EC9640031C3O001F3D08421608FC033908001704F30F301F7F100CEF0F390E00555DAE03073O009D685C7A20646D030D3O0080A9C3C52E3498B890ABCED93503083O00CBC3C6AFAA5D47ED030D3O00436F6C6F2O737573536D61736803203O002D4432DA4202E93D742DD85002F46E5837DB561DF9115F3FC75614E86E1A6E8103073O009C4E2B5EB53171025O00689540026O00834003063O002CD1C20A302E03053O00555CBDA373030E3O001ABC35393BA3361A28BF243126A203043O005849CC50030D3O000D8C1C493AC93B90234B28C92603063O00BA4EE3702649030A3O00CB56EF57417FFD5CF84703063O001A9C379D353303143O0053706561724F6642617374696F6E506C6179657203223O009FC813D8AA6F83DE29DBB94398D119D7F84385D611D5BD6F98D904DEBD44CC89468B03063O0030ECB876B9D8025O007AA840025O00389A40025O0071B240025O0038944003043O001E5552BC03073O00424C303CD8A3CB030B3O008E8F7DF650C806B68976F703073O0044DAE619933FAE030D3O009E214640BABE3A5F45A2B92F4103053O00D6CD4A332C030D3O00D943EEF364E959F1CF7AFB5FEA03053O00179A2C829C030A3O00232OA3AA121613B3ABA803063O007371C6CDCE56030C3O00426173654475726174696F6E026O33EB3F03163O009652F05EC444F754835BFB659056EC5D8143BE0BD40703043O003AE4379E03063O00959FD13A3DBF03073O0055D4E9B04E5CCD030F3O007D599AEE454A8CF17E579AEF4F569C03043O00822A38E8030D3O00C9BA28EC532CFFA617EE412CE203063O005F8AD5448320030A3O00432O6F6C646F776E5570030F3O001D29B34F79382CB277793825A44D6203053O00164A48C123030D3O000F76E8573F6AF14B1F74E54B2403043O00384C198403063O00417661746172025O003EA540025O0020754003183O005FD7AA32CE4C81B82FC159CDAE19DB5FD3AC23DB1E90FB7703053O00AF3EA1CB46025O00AEA140025O00F0B040030B3O00600E92B8A1B596770A86A603073O00E43466E7D6C5D0030A3O003CE161DEE68E15D90CE403083O00B67E8015AA8AEB79030F3O00A9D63AE982123E02BFD220E882162203083O0066EBBA5586E67350031E3O0043042B5176D130680F325E6294315E02395377EB36561E395A669473065403073O0042376C5E3F12B403093O003B9B8025375603889703063O003974EDE55747030A3O00446562752O66446F776E026O004940030A3O0088B0F9F37BEB4BA5A3E903073O0027CAD18D87178E031B3O00F0250C1822F7E8361B4A212OF134050F0DECFE210E0F26B8AE625003063O00989F53696A5203093O00B6CE58E0C54B88C85503063O003CE1A63192A903183O004D657263696C652O73426F6E656772696E64657242752O66025O00109240025O00107840031B3O00381626380D1026102B6A120E2119232F3E132E0C282F15477E4C7F03063O00674F7E4F4A61025O009C9B40025O000CB04003043O0079BB1DD803073O00C32AD77CB521EC030D3O002E4B222O2DF1035E113137FB0803063O00986D39575E4503043O0052616765026O004E40030B3O00CDD219B7B1D479A1FEDF1E03083O00C899B76AC3DEB234030C3O001BEE982F464C37E7BB31485703063O003A5283E85D29030E3O00A552C203522D8C51F214492B8F5203063O005FE337B0753D030E3O003E7B315DA40A712569AA0C6A2F4E03053O00CB781E432B03043O00536C616D03163O00E2294CE299E22C43E8D5F41A59EECBF62059AF88A07003053O00B991452D8F025O0078A840025O0042AD4003093O00BD1710B4D09D1617A203053O00BCEA7F79C6030D3O000B261C91353D15B02F3D01872B03043O00E3585273030E3O00651AA8B10D614C1998A616674F1A03063O0013237FDAC762025O00FAB240025O004EB340031B3O000BF303F010EC03EC18BB19EB12FC06E723EF0BF01BFE1EA24DAA5C03043O00827C9B6A03043O00E6C7F7A203083O00DFB5AB96CFC3961C030D3O006F28F6BD014534E488065E39E603053O00692C5A83CE030D3O00DCF2A7AA0037F1E794B61A3DFA03063O005E9F80D2D968026O003E40030E3O0076FC14A9506DF67C72F812AB537A03083O001A309966DF3F1F99030E3O002445FFE50D52E2F52041F9E70E4503043O009362208D025O00C49940025O0018A44003163O000B4FE2C74645421644EFCF39424A0A44E6DE46071A4F03073O002B782383AA66360012072O0012AA3O00014O00B4000100013O0026E63O0002000100010004353O000200010012AA000100013O002O0E000200E8000100010004353O00E800010012AA000200013O0026D60002000C000100010004353O000C0001002E050103006E000100040004353O007800012O008800036O0015000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003004900013O0004353O004900012O0088000300023O0006220103004900013O0004353O004900012O008800036O0015000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004900013O0004353O004900012O008800036O0015000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004900013O0004353O004900012O0088000300033O00201C01030003000D2O000F010300020002000EBC000E0049000100030004353O004900012O0088000300043O00206F00030003000F4O00055O00202O0005000500104O00030005000200062O0003004900013O0004353O004900012O0088000300054O005900045O00202O0004000400114O000500043O00202O0005000500124O000700066O0005000700024O000500056O00030005000200062O0003004900013O0004353O004900012O0088000300013O0012AA000400133O0012AA000500144O008F000300054O005100036O008800036O0015000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O0003000300074O00030002000200062O0003007700013O0004353O007700012O0088000300073O0006220103007700013O0004353O007700012O0088000300043O0020230103000300174O00055O00202O0005000500184O0003000500024O000400033O00202O0004000400194O00040002000200062O00030077000100040004353O007700012O008800036O00E9000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000A4O00030002000200062O00030077000100010004353O007700012O0088000300054O00D100045O00202O00040004001C4O000500086O000500056O00030005000200062O0003007700013O0004353O007700012O0088000300013O0012AA0004001D3O0012AA0005001E4O008F000300054O005100035O0012AA0002001F3O0026E6000200080001001F0004353O000800012O0088000300094O00880004000A3O000687000300E5000100040004353O00E500012O00880003000B3O000622010300E500013O0004353O00E500012O00880003000C3O0006220103008700013O0004353O008700012O00880003000D3O0006520003008A000100010004353O008A00012O00880003000C3O000652000300E5000100010004353O00E500012O008800036O0015000400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O0003000300224O00030002000200062O000300E500013O0004353O00E500012O008800036O0015000400013O00122O000500233O00122O000600246O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300B600013O0004353O00B600012O0088000300033O00200D0003000300254O00055O00202O0005000500264O00030005000200062O000300D8000100010004353O00D800012O008800036O00E9000400013O00122O000500273O00122O000600286O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300B6000100010004353O00B600012O0088000300043O00200D00030003000F4O00055O00202O0005000500104O00030005000200062O000300D8000100010004353O00D800012O008800036O0015000400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300E500013O0004353O00E500012O0088000300033O00200D0003000300254O00055O00202O0005000500264O00030005000200062O000300D8000100010004353O00D800012O008800036O00E9000400013O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300E5000100010004353O00E500012O0088000300043O00206F00030003000F4O00055O00202O0005000500104O00030005000200062O000300E500013O0004353O00E500012O0088000300054O00D100045O00202O00040004002D4O000500086O000500056O00030005000200062O000300E500013O0004353O00E500012O0088000300013O0012AA0004002E3O0012AA0005002F4O008F000300054O005100035O0012AA000100303O0004353O00E800010004353O000800010026E60001004F2O0100010004353O004F2O01002EED003100102O0100320004353O00102O012O0088000200094O00880003000A3O000687000200102O0100030004353O00102O012O00880002000E3O000622010200102O013O0004353O00102O012O008800026O0015000300013O00122O000400333O00122O000500346O0003000500024O00020002000300202O0002000200224O00020002000200062O000200102O013O0004353O00102O012O00880002000F3O000EBC001F00102O0100020004353O00102O012O0088000200054O005900035O00202O0003000300354O000400043O00202O0004000400124O000600066O0004000600024O000400046O00020004000200062O000200102O013O0004353O00102O012O0088000200013O0012AA000300363O0012AA000400374O008F000200044O005100026O008800026O0015000300013O00122O000400383O00122O000500396O0003000500024O00020002000300202O0002000200074O00020002000200062O000200212O013O0004353O00212O012O0088000200033O00200D0002000200254O00045O00202O00040004003A4O00020004000200062O000200232O0100010004353O00232O01002E34003B00322O01003C0004353O00322O01002E05013D000F0001003D0004353O00322O012O0088000200054O00D100035O00202O00030003003E4O000400086O000400046O00020004000200062O000200322O013O0004353O00322O012O0088000200013O0012AA0003003F3O0012AA000400404O008F000200044O005100025O002E340041004E2O0100420004353O004E2O012O008800026O0015000300013O00122O000400433O00122O000500446O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004E2O013O0004353O004E2O012O0088000200103O0006220102004E2O013O0004353O004E2O012O0088000200054O00D100035O00202O0003000300454O000400086O000400046O00020004000200062O0002004E2O013O0004353O004E2O012O0088000200013O0012AA000300463O0012AA000400474O008F000200044O005100025O0012AA0001001F3O002EED004900D02O0100480004353O00D02O010026E6000100D02O01004A0004353O00D02O010012AA000200013O0026D6000200582O01001F0004353O00582O01002EED004C00762O01004B0004353O00762O012O008800036O0015000400013O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300742O013O0004353O00742O012O0088000300113O000622010300742O013O0004353O00742O012O0088000300054O00A200045O00202O00040004004F4O000500086O000500056O00030005000200062O0003006F2O0100010004353O006F2O01002EED005000742O0100510004353O00742O012O0088000300013O0012AA000400523O0012AA000500534O008F000300054O005100035O0012AA000100543O0004353O00D02O010026E6000200542O0100010004353O00542O01002E050155002F000100550004353O00A72O012O008800036O0015000400013O00122O000500563O00122O000600576O0004000600024O00030003000400202O0003000300074O00030002000200062O000300A72O013O0004353O00A72O012O0088000300113O000622010300A72O013O0004353O00A72O012O0088000300033O00200301030003005800122O000500593O00122O0006005A6O00030006000200062O000300A72O013O0004353O00A72O012O008800036O00E9000400013O00122O0005005B3O00122O0006005C6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300A72O0100010004353O00A72O01002E34005D00A72O01005E0004353O00A72O012O0088000300054O00D100045O00202O00040004004F4O000500086O000500056O00030005000200062O000300A72O013O0004353O00A72O012O0088000300013O0012AA0004005F3O0012AA000500604O008F000300054O005100036O0088000300094O00880004000A3O000687000300CE2O0100040004353O00CE2O012O00880003000B3O000622010300CE2O013O0004353O00CE2O012O00880003000C3O000622010300B42O013O0004353O00B42O012O00880003000D3O000652000300B72O0100010004353O00B72O012O00880003000C3O000652000300CE2O0100010004353O00CE2O012O008800036O0015000400013O00122O000500613O00122O000600626O0004000600024O00030003000400202O0003000300224O00030002000200062O000300CE2O013O0004353O00CE2O012O0088000300054O00D100045O00202O00040004002D4O000500086O000500056O00030005000200062O000300CE2O013O0004353O00CE2O012O0088000300013O0012AA000400633O0012AA000500644O008F000300054O005100035O0012AA0002001F3O0004353O00542O01002EED006500A4020100660004353O00A402010026E6000100A4020100670004353O00A402010012AA000200013O0026E6000200330201001F0004353O00330201002E050168005A000100680004353O003102012O0088000300094O00880004000A3O00068700030031020100040004353O003102012O0088000300123O0006220103003102013O0004353O003102012O0088000300133O000622010300E62O013O0004353O00E62O012O00880003000D3O000652000300E92O0100010004353O00E92O012O0088000300133O00065200030031020100010004353O003102012O008800036O0015000400013O00122O000500693O00122O0006006A6O0004000600024O00030003000400202O0003000300224O00030002000200062O0003003102013O0004353O003102012O0088000300033O00200D0003000300254O00055O00202O0005000500264O00030005000200062O00030021020100010004353O002102012O008800036O0015000400013O00122O0005006B3O00122O0006006C6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003001002013O0004353O001002012O0088000300043O00206F00030003000F4O00055O00202O0005000500104O00030005000200062O0003001002013O0004353O001002012O0088000300033O00201C01030003000D2O000F010300020002002689000300210201006D0004353O002102012O008800036O00E9000400013O00122O0005006E3O00122O0006006F6O0004000600024O00030003000400202O00030003000A4O00030002000200062O00030031020100010004353O003102012O0088000300043O00206F00030003000F4O00055O00202O0005000500104O00030005000200062O0003003102013O0004353O003102012O0088000300054O005900045O00202O0004000400704O000500043O00202O0005000500124O000700066O0005000700024O000500056O00030005000200062O0003003102013O0004353O003102012O0088000300013O0012AA000400713O0012AA000500724O008F000300054O005100035O0012AA000100023O0004353O00A40201002EED007400D52O0100730004353O00D52O010026E6000200D52O0100010004353O00D52O012O008800036O0015000400013O00122O000500753O00122O000600766O0004000600024O00030003000400202O0003000300224O00030002000200062O0003007502013O0004353O007502012O0088000300143O0006220103007502013O0004353O007502012O008800036O00E9000400013O00122O000500773O00122O000600786O0004000600024O00030003000400202O00030003000A4O00030002000200062O00030075020100010004353O007502012O0088000300043O0020830003000300174O00055O00202O0005000500794O000300050002000E2O00010075020100030004353O007502012O0088000300043O00200D00030003000F4O00055O00202O0005000500104O00030005000200062O00030066020100010004353O006602012O008800036O002E000400013O00122O0005007A3O00122O0006007B6O0004000600024O00030003000400202O00030003007C4O000300020002000E2O00670075020100030004353O00750201002E34007D00750201007E0004353O007502012O0088000300054O00D100045O00202O00040004007F4O000500086O000500056O00030005000200062O0003007502013O0004353O007502012O0088000300013O0012AA000400803O0012AA000500814O008F000300054O005100036O008800036O0015000400013O00122O000500823O00122O000600836O0004000600024O00030003000400202O0003000300224O00030002000200062O000300A202013O0004353O00A202012O0088000300143O000622010300A202013O0004353O00A202012O008800036O0015000400013O00122O000500843O00122O000600856O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300A202013O0004353O00A202012O0088000300043O0020830003000300174O00055O00202O0005000500794O000300050002000E2O000100A2020100030004353O00A20201002E34008700A2020100860004353O00A202012O0088000300054O00D100045O00202O00040004007F4O000500086O000500056O00030005000200062O000300A202013O0004353O00A202012O0088000300013O0012AA000400883O0012AA000500894O008F000300054O005100035O0012AA0002001F3O0004353O00D52O01002EED008A00D80201008B0004353O00D802010026E6000100D8020100540004353O00D80201002E34008D00110701008C0004353O001107012O008800026O0015000300013O00122O0004008E3O00122O0005008F6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001107013O0004353O001107012O0088000200153O0006220102001107013O0004353O001107012O0088000200043O00206F0002000200904O00045O00202O0004000400184O00020004000200062O0002001107013O0004353O001107012O008800026O00E9000300013O00122O000400913O00122O000500926O0003000500024O00020002000300202O00020002000A4O00020002000200062O00020011070100010004353O001107012O0088000200054O00A200035O00202O0003000300934O000400086O000400046O00020004000200062O000200D2020100010004353O00D20201002EED00950011070100940004353O001107012O0088000200013O001223000300963O00122O000400976O000200046O00025O00044O001107010026E60001009E030100300004353O009E03010012AA000200013O0026E60002004F030100010004353O004F03012O008800036O0015000400013O00122O000500983O00122O000600996O0004000600024O00030003000400202O0003000300224O00030002000200062O000300F902013O0004353O00F902012O0088000300163O000622010300F902013O0004353O00F902012O008800036O00E9000400013O00122O0005009A3O00122O0006009B6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300FB020100010004353O00FB02012O0088000300043O00201C01030003009C2O000F010300020002000652000300FB020100010004353O00FB0201002E34009E000D0301009D0004353O000D03012O0088000300054O005500045O00202O00040004009F4O000500043O00202O0005000500124O000700066O0005000700024O000500056O00030005000200062O00030008030100010004353O00080301002EED00A0000D030100860004353O000D03012O0088000300013O0012AA000400A13O0012AA000500A24O008F000300054O005100036O008800036O0015000400013O00122O000500A33O00122O000600A46O0004000600024O00030003000400202O0003000300074O00030002000200062O0003004E03013O0004353O004E03012O0088000300023O0006220103004E03013O0004353O004E03012O008800036O0015000400013O00122O000500A53O00122O000600A66O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004E03013O0004353O004E03012O008800036O0015000400013O00122O000500A73O00122O000600A86O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004E03013O0004353O004E03012O008800036O00FC000400013O00122O000500A93O00122O000600AA6O0004000600024O00030003000400202O00030003007C4O0003000200024O000400033O00202O0004000400194O00040002000200202O0004000400AB00062O0004004E030100030004353O004E0301002E0501AC0012000100AC0004353O004E03012O0088000300054O005900045O00202O0004000400114O000500043O00202O0005000500124O000700066O0005000700024O000500056O00030005000200062O0003004E03013O0004353O004E03012O0088000300013O0012AA000400AD3O0012AA000500AE4O008F000300054O005100035O0012AA0002001F3O002EED00B000DB020100AF0004353O00DB02010026E6000200DB0201001F0004353O00DB02012O008800036O0015000400013O00122O000500B13O00122O000600B26O0004000600024O00030003000400202O0003000300224O00030002000200062O0003008A03013O0004353O008A03012O0088000300173O0006220103008A03013O0004353O008A03012O008800036O0064000400013O00122O000500B33O00122O000600B46O0004000600024O00030003000400202O0003000300B54O00030002000200262O000300800301005A0004353O008003012O008800036O00E9000400013O00122O000500B63O00122O000600B76O0004000600024O00030003000400202O00030003000A4O00030002000200062O00030080030100010004353O008003012O0088000300043O00200D00030003000F4O00055O00202O0005000500104O00030005000200062O0003008C030100010004353O008C03012O0088000300033O00201C01030003000D2O000F0103000200020026890003008C030100B80004353O008C03012O008800036O00E9000400013O00122O000500B93O00122O000600BA6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003008C030100010004353O008C0301002E0501BB0011000100BC0004353O009B03012O0088000300054O00A200045O00202O0004000400BD4O000500086O000500056O00030005000200062O00030096030100010004353O00960301002E0501BE00070001003D0004353O009B03012O0088000300013O0012AA000400BF3O0012AA000500C04O008F000300054O005100035O0012AA000100C13O0004353O009E03010004353O00DB02010026E60001004E0401005A0004353O004E04010012AA000200013O000E312O0100A5030100020004353O00A50301002EED00C20022040100C30004353O00220401002E0501C40050000100C40004353O00F503012O0088000300094O00880004000A3O000687000300F5030100040004353O00F503012O0088000300183O000622010300F503013O0004353O00F503012O0088000300193O000622010300B403013O0004353O00B403012O00880003000D3O000652000300B7030100010004353O00B703012O0088000300193O000652000300F5030100010004353O00F503012O00880003001A4O004F000400013O00122O000500C53O00122O000600C66O00040006000200062O000300F5030100040004353O00F503012O008800036O0015000400013O00122O000500C73O00122O000600C86O0004000600024O00030003000400202O0003000300224O00030002000200062O000300F503013O0004353O00F503012O008800036O0067000400013O00122O000500C93O00122O000600CA6O0004000600024O00030003000400202O00030003007C4O0003000200024O000400033O00202O0004000400194O0004000200020006990003000E000100040004353O00E203012O008800036O0036000400013O00122O000500CB3O00122O000600CC6O0004000600024O00030003000400202O00030003007C4O0003000200024O000400033O00202O0004000400194O00040002000200062O000300F5030100040004353O00F503012O0088000300054O00060004001B3O00202O0004000400CD4O000500043O00202O0005000500CE4O00075O00202O0007000700CF4O0005000700024O000500056O00030005000200062O000300F0030100010004353O00F00301002EED00D000F5030100D10004353O00F503012O0088000300013O0012AA000400D23O0012AA000500D34O008F000300054O005100036O0088000300094O00880004000A3O00068700030021040100040004353O002104012O00880003001C3O0006220103002104013O0004353O002104012O00880003001D3O0006220103000204013O0004353O000204012O00880003000D3O00065200030005040100010004353O000504012O00880003001D3O00065200030021040100010004353O002104012O008800036O0015000400013O00122O000500D43O00122O000600D56O0004000600024O00030003000400202O0003000300224O00030002000200062O0003002104013O0004353O002104012O0088000300054O000800045O00202O0004000400D64O000500043O00202O0005000500D700122O0007004A6O0005000700024O000500056O00030005000200062O0003001C040100010004353O001C0401002E3400D80021040100D90004353O002104012O0088000300013O0012AA000400DA3O0012AA000500DB4O008F000300054O005100035O0012AA0002001F3O0026E6000200A10301001F0004353O00A103012O0088000300094O00880004000A3O0006870003004B040100040004353O004B04012O00880003001E3O0006220103004B04013O0004353O004B04012O00880003001F3O0006220103003104013O0004353O003104012O00880003000D3O00065200030034040100010004353O003404012O00880003001F3O0006520003004B040100010004353O004B04012O008800036O0015000400013O00122O000500DC3O00122O000600DD6O0004000600024O00030003000400202O0003000300224O00030002000200062O0003004B04013O0004353O004B04012O0088000300054O00D100045O00202O0004000400DE4O000500086O000500056O00030005000200062O0003004B04013O0004353O004B04012O0088000300013O0012AA000400DF3O0012AA000500E04O008F000300054O005100035O0012AA000100673O0004353O004E04010004353O00A103010026E6000100810501001F0004353O008105010012AA000200014O00B4000300033O002O0E00010052040100020004353O005204010012AA000300013O0026D6000300590401001F0004353O00590401002E0501E10050000100E20004353O00A704012O0088000400094O00880005000A3O000687000400A5040100050004353O00A504012O0088000400183O000622010400A504013O0004353O00A504012O0088000400193O0006220104006604013O0004353O006604012O00880004000D3O00065200040069040100010004353O006904012O0088000400193O000652000400A5040100010004353O00A504012O00880004001A4O004F000500013O00122O000600E33O00122O000700E46O00050007000200062O000400A5040100050004353O00A504012O008800046O0015000500013O00122O000600E53O00122O000700E66O0005000700024O00040004000500202O0004000400224O00040002000200062O000400A504013O0004353O00A504012O008800046O0067000500013O00122O000600E73O00122O000700E86O0005000700024O00040004000500202O00040004007C4O0004000200024O000500033O00202O0005000500194O0005000200020006990004000E000100050004353O009404012O008800046O0036000500013O00122O000600E93O00122O000700EA6O0005000700024O00040004000500202O00040004007C4O0004000200024O000500033O00202O0005000500194O00050002000200062O000400A5040100050004353O00A504012O0088000400054O00D90005001B3O00202O0005000500EB4O000600043O00202O0006000600CE4O00085O00202O0008000800CF4O0006000800024O000600066O00040006000200062O000400A504013O0004353O00A504012O0088000400013O0012AA000500EC3O0012AA000600ED4O008F000400064O005100045O0012AA0001005A3O0004353O00810501002EED00EF0055040100EE0004353O005504010026E600030055040100010004353O00550401002E3400F1000C050100F00004353O000C05012O008800046O0015000500013O00122O000600F23O00122O000700F36O0005000700024O00040004000500202O0004000400074O00040002000200062O0004000C05013O0004353O000C05012O0088000400153O0006220104000C05013O0004353O000C05012O0088000400043O0020470004000400174O00065O00202O0006000600184O0004000600024O000500033O00202O0005000500194O00050002000200062O0004003C000100050004353O00FF04012O008800046O0015000500013O00122O000600F43O00122O000700F56O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004000C05013O0004353O000C05012O008800046O0036000500013O00122O000600F63O00122O000700F76O0005000700024O00040004000500202O00040004007C4O0004000200024O000500033O00202O0005000500194O00050002000200062O0004000C050100050004353O000C05012O008800046O0067000500013O00122O000600F83O00122O000700F96O0005000700024O00040004000500202O00040004007C4O0004000200024O000500033O00202O0005000500194O00050002000200069900040008000100050004353O00EF04012O0088000400043O00206F00040004000F4O00065O00202O0006000600104O00040006000200062O0004000C05013O0004353O000C05012O0088000400043O0020AE0004000400174O00065O00202O0006000600184O0004000600024O00058O000600013O00122O000700FA3O00122O000800FB6O0006000800024O00050005000600202O0005000500FC4O00050002000200202O0005000500FD00062O0004000C050100050004353O000C05012O0088000400054O00D100055O00202O0005000500934O000600086O000600066O00040006000200062O0004000C05013O0004353O000C05012O0088000400013O0012AA000500FE3O0012AA000600FF4O008F000400064O005100046O0088000400094O00880005000A3O0006870004007D050100050004353O007D05012O0088000400203O0006220104007D05013O0004353O007D05012O0088000400213O0006220104001905013O0004353O001905012O00880004000D3O0006520004001C050100010004353O001C05012O0088000400213O0006520004007D050100010004353O007D05012O008800046O0015000500013O00122O00062O00012O00122O0007002O015O0005000700024O00040004000500202O0004000400224O00040002000200062O0004007D05013O0004353O007D05012O008800046O0015000500013O00122O00060002012O00122O00070003015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004004F05013O0004353O004F05012O0088000400033O00201C01040004000D2O000F0104000200020012AA0005006D3O0006870004004F050100050004353O004F05012O008800046O00D2000500013O00122O00060004012O00122O00070005015O0005000700024O00040004000500122O00060006015O0004000400064O00040002000200062O0004006B050100010004353O006B05012O0088000400043O00200D00040004000F4O00065O00202O0006000600104O00040006000200062O0004006B050100010004353O006B05012O0088000400033O00200D0004000400254O00065O00202O0006000600264O00040006000200062O0004006B050100010004353O006B05012O008800046O00E9000500013O00122O00060007012O00122O00070008015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004007D050100010004353O007D05012O008800046O00D2000500013O00122O00060009012O00122O0007000A015O0005000700024O00040004000500122O00060006015O0004000400064O00040002000200062O0004006B050100010004353O006B05012O0088000400043O00206F00040004000F4O00065O00202O0006000600104O00040006000200062O0004007D05013O0004353O007D05012O0088000400054O006B00055O00122O0006000B015O0005000500064O000600086O000600066O00040006000200062O00040078050100010004353O007805010012AA0004000C012O0012AA0005000D012O00060B0104007D050100050004353O007D05012O0088000400013O0012AA0005000E012O0012AA0006000F013O008F000400064O005100045O0012AA0003001F3O0004353O005504010004353O008105010004353O005204010012AA00020010012O0012AA00030011012O00063E00020018060100030004353O001806010012AA000200AB3O00060B2O010018060100020004353O001806012O008800026O0015000300013O00122O00040012012O00122O00050013015O0003000500024O00020002000300202O0002000200074O00020002000200062O000200B605013O0004353O00B605012O0088000200073O000622010200B605013O0004353O00B605012O008800026O0015000300013O00122O00040014012O00122O00050015015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200B605013O0004353O00B605012O008800026O0015000300013O00122O00040016012O00122O00050017015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200B605013O0004353O00B605012O0088000200054O00D100035O00202O00030003001C4O000400086O000400046O00020004000200062O000200B605013O0004353O00B605012O0088000200013O0012AA00030018012O0012AA00040019013O008F000200044O005100026O008800026O0015000300013O00122O0004001A012O00122O0005001B015O0003000500024O00020002000300202O0002000200224O00020002000200062O000200EE05013O0004353O00EE05012O0088000200173O000622010200EE05013O0004353O00EE05012O0088000200043O0012DC0004001C015O0002000200044O00045O00202O0004000400104O00020004000200062O000200DB05013O0004353O00DB05012O0088000200033O00201C01020002000D2O000F0102000200020012AA0003001D012O000687000200DB050100030004353O00DB05012O008800026O0015000300013O00122O0004001E012O00122O0005001F015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200E105013O0004353O00E105012O0088000200033O00201C01020002000D2O000F0102000200020012AA000300B83O000687000200EE050100030004353O00EE05012O0088000200054O00D100035O00202O0003000300BD4O000400086O000400046O00020004000200062O000200EE05013O0004353O00EE05012O0088000200013O0012AA00030020012O0012AA00040021013O008F000200044O005100026O008800026O0015000300013O00122O00040022012O00122O00050023015O0003000500024O00020002000300202O0002000200074O00020002000200062O0002000306013O0004353O000306012O0088000200023O0006220102000306013O0004353O000306012O0088000200033O0020D70002000200254O00045O00122O00050024015O0004000400054O00020004000200062O00020007060100010004353O000706010012AA00020025012O0012AA00030026012O00063E00020017060100030004353O001706012O0088000200054O004000035O00202O0003000300114O000400043O00202O0004000400D700122O0006004A6O0004000600024O000400046O00020004000200062O0002001706013O0004353O001706012O0088000200013O0012AA00030027012O0012AA00040028013O008F000200044O005100025O0012AA0001004A3O0012AA000200C13O0006040001001F060100020004353O001F06010012AA00020029012O0012AA0003002A012O00068700030005000100020004353O000500012O008800026O0015000300013O00122O0004002B012O00122O0005002C015O0003000500024O00020002000300202O0002000200074O00020002000200062O0002007E06013O0004353O007E06012O0088000200223O0006220102007E06013O0004353O007E06012O008800026O0015000300013O00122O0004002D012O00122O0005002E015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002004E06013O0004353O004E06012O0088000200043O00206F00020002000F4O00045O00202O0004000400104O00020004000200062O0002004E06013O0004353O004E06012O0088000200033O0012270004002F015O0002000200044O00020002000200122O00030030012O00062O0003004E060100020004353O004E06012O008800026O00E9000300013O00122O00040031012O00122O00050032015O0003000500024O00020002000300202O00020002000A4O00020002000200062O00020058060100010004353O005806012O008800026O0015000300013O00122O00040033012O00122O00050034015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002007E06013O0004353O007E06012O008800026O0015000300013O00122O00040035012O00122O00050036015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002007006013O0004353O007006012O008800026O0015000300013O00122O00040037012O00122O00050038015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002007E06013O0004353O007E06012O00880002000F3O0012AA0003001F3O00060B0102007E060100030004353O007E06012O0088000200054O00C700035O00122O00040039015O0003000300044O000400086O000400046O00020004000200062O0002007E06013O0004353O007E06012O0088000200013O0012AA0003003A012O0012AA0004003B013O008F000200044O005100025O0012AA0002003C012O0012AA0003003D012O000687000200BB060100030004353O00BB06012O008800026O0015000300013O00122O0004003E012O00122O0005003F015O0003000500024O00020002000300202O0002000200074O00020002000200062O000200BB06013O0004353O00BB06012O0088000200023O000622010200BB06013O0004353O00BB06012O008800026O00E9000300013O00122O00040040012O00122O00050041015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200A7060100010004353O00A706012O008800026O0015000300013O00122O00040042012O00122O00050043015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200BB06013O0004353O00BB06012O00880002000F3O0012AA0003001F3O000687000300BB060100020004353O00BB06012O0088000200054O005500035O00202O0003000300114O000400043O00202O0004000400124O000600066O0004000600024O000400046O00020004000200062O000200B6060100010004353O00B606010012AA00020044012O0012AA00030045012O00060B010200BB060100030004353O00BB06012O0088000200013O0012AA00030046012O0012AA00040047013O008F000200044O005100026O008800026O0015000300013O00122O00040048012O00122O00050049015O0003000500024O00020002000300202O0002000200074O00020002000200062O0002000D07013O0004353O000D07012O0088000200223O0006220102000D07013O0004353O000D07012O008800026O00E9000300013O00122O0004004A012O00122O0005004B015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200E3060100010004353O00E306012O008800026O00E9000300013O00122O0004004C012O00122O0005004D015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002000D070100010004353O000D07012O0088000200033O0012270004002F015O0002000200044O00020002000200122O0003004E012O00062O0003000D070100020004353O000D07012O008800026O0015000300013O00122O0004004F012O00122O00050050015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200FB06013O0004353O00FB06012O008800026O0015000300013O00122O00040051012O00122O00050052015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002000D07013O0004353O000D07012O00880002000F3O0012AA0003001F3O00060B0102000D070100030004353O000D07010012AA00020053012O0012AA00030054012O00063E0002000D070100030004353O000D07012O0088000200054O00C700035O00122O00040039015O0003000300044O000400086O000400046O00020004000200062O0002000D07013O0004353O000D07012O0088000200013O0012AA00030055012O0012AA00040056013O008F000200044O005100025O0012AA000100AB3O0004353O000500010004353O001107010004353O000200012O004D3O00017O001B3O00028O00025O0048B140025O0020A940030F3O00412O66656374696E67436F6D626174025O00709840025O006CAC40025O0014A340025O00CCAF40030C3O00728A2A635C8E0D6351853D7203043O001730EB5E030A3O0049734361737461626C6503083O0042752O66446F776E030C3O0042612O746C655374616E6365030D3O007EDBCC495B36ED6FCED953543603073O00B21CBAB83D3753030B3O00E6CC5328FE0BC6CCC2522803073O0095A4AD275C926E030F3O0042612O746C6553686F757442752O6603103O0047726F757042752O664D692O73696E67030B3O0042612O746C6553686F757403163O00F126040B161ECC3418102O0FB337021A1914FE25110B03063O007B9347707F7A030D3O00546172676574497356616C6964026O00AF40025O00F09040025O0029B040025O003C9C40008A3O0012AA3O00014O00B4000100013O000E312O01000600013O0004353O00060001002EED00020002000100030004353O000200010012AA000100013O0026E600010007000100010004353O000700012O008800025O00201C0102000200042O000F0102000200020006220102001000013O0004353O00100001002E3400060061000100050004353O006100010012AA000200014O00B4000300033O0026E600020012000100010004353O001200010012AA000300013O0026E600030015000100010004353O00150001002E3400070036000100080004353O003600012O0088000400014O0015000500023O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004003600013O0004353O003600012O008800045O00204B00040004000C4O000600013O00202O00060006000D4O000700016O00040007000200062O0004003600013O0004353O003600012O0088000400034O0088000500013O00201D00050005000D2O000F0104000200020006220104003600013O0004353O003600012O0088000400023O0012AA0005000E3O0012AA0006000F4O008F000400064O005100046O0088000400014O0015000500023O00122O000600103O00122O000700116O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004006100013O0004353O006100012O0088000400043O0006220104006100013O0004353O006100012O008800045O00202F01040004000C4O000600013O00202O0006000600124O000700016O00040007000200062O00040052000100010004353O005200012O0088000400053O0020AF0004000400134O000500013O00202O0005000500124O00040002000200062O0004006100013O0004353O006100012O0088000400034O0088000500013O00201D0005000500142O000F0104000200020006220104006100013O0004353O006100012O0088000400023O001223000500153O00122O000600166O000400066O00045O00044O006100010004353O001500010004353O006100010004353O001200012O0088000200053O00201D0002000200172O00E20002000100020006220102008900013O0004353O008900012O0088000200063O0006220102008900013O0004353O008900012O008800025O00201C0102000200042O000F0102000200020006220102007000013O0004353O00700001002EED00180089000100190004353O008900010012AA000200014O00B4000300033O0026D600020076000100010004353O00760001002E34001A00720001001B0004353O007200010012AA000300013O002O0E00010077000100030004353O007700012O0088000400084O00E20004000100022O0007000400074O0088000400073O0006220104008900013O0004353O008900012O0088000400074O0073000400023O0004353O008900010004353O007700010004353O008900010004353O007200010004353O008900010004353O000700010004353O008900010004353O000200012O004D3O00017O00A33O00028O00026O00F03F025O00B07B40025O00D09640025O0026A540025O00E06F40025O001CAF40025O00F4B240025O0041B240025O00DEA640025O00B6A740025O0053B140025O00A49E40025O0058AB40025O00B8834003113O0048616E646C65496E636F72706F7265616C03093O0053746F726D426F6C7403123O0053746F726D426F6C744D6F7573656F766572026O003440025O00C89C40025O00E8AE4003113O00496E74696D69646174696E6753686F7574031A3O00496E74696D69646174696E6753686F75744D6F7573656F766572026O002040025O0096A040025O00689740030D3O00546172676574497356616C6964025O00EC9E40025O00109E40025O00408A40025O00FCB04003063O00EFC5836341C903053O0026ACADE211030A3O0049734361737461626C6503063O00436861726765030E3O0049735370652O6C496E52616E6765030E3O004E192DFD4A146CE24C1822AF1E4503043O008F2D714C030F3O0048616E646C65445053506F74696F6E03083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O66027O0040025O00E7B140025O0093B140025O007DB040025O0042B040025O0034A640025O00E3B24003093O00AB40F84D8F45E5478903043O0028ED298A03093O0046697265626C2O6F6403113O00C17DE8FD48CB7BF5FC0ACA75F3F60A932703053O002AA7149A98030D3O006BF0A147623558FFAE61702D4603063O00412A9EC22211025O00549640025O0006AE40030D3O00416E6365737472616C43612O6C03163O001B2951093EF909EF1618510D21E15BE31B2E5C4C79B903083O008E7A47326C4D8D7B026O000840025O008AA440025O00CAA74003093O009AB41333BC9E092EA103043O005C2OD87C03093O00426C2O6F644675727903123O00593EA34FF96434B952E41B3FAD49F31B61F503053O009D3B52CC20025O00EEAA40025O00B2A640030A3O001A3BF1E9ECF8D8B8363903083O00D1585E839A898AB3030D3O00446562752O6652656D61696E73026O001840030A3O004265727365726B696E6703123O002AA4D66F1B313A2B26A684711F2A3F627CF103083O004248C1A41C7E4351030B3O0037A3F8173D21B0F61B300603053O005B75C29F78030A3O00446562752O66446F776E030C3O0037122C0C34FD170E0F37133003073O00447A7D5E785591030A3O00432O6F6C646F776E5570030B3O004261676F66547269636B7303153O00151DC861C7DF85030EC65DC3CAFA1A1DC6502O88EA03073O00DA777CAF3EA8B9025O0002A640025O00088040025O00E08640025O00ECA340025O0022A840025O00806440030D3O00C63EAB592873D323BA4A2378F303063O0016874CC83846030C3O00A03FEA305CEDBE24EA2D56E403063O0081ED5098443D030F3O00432O6F6C646F776E52656D61696E73026O00F83F03043O0052616765026O004940025O00BC9640025O00E4AE40030D3O00417263616E65546F2O72656E7403093O004973496E52616E676503163O0050BA07F22O126745A716E12O194C11A505FA12570C0003073O003831C864937C77030E3O00E037B8F8D82D95E5C839B2F5C22A03043O0090AC5EDF030C3O000900B053250391533606A94203043O0027446FC2025O00C06240030E3O004C69676874734A7564676D656E7403173O00DAAFE0CF6DA4E9ACF2C37EBAD3A8F38774B6DFA8A7932B03063O00D7B6C687A719025O00F2A840025O009CAD4003083O0090EA2CB3C8BEF93A03053O00A9DD8B5FC0030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765025O00804140025O00F07C40025O0046AB40030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O00E9AA560B03063O0046BEEB1F5F4203133O00576169742F502O6F6C205265736F7572636573025O00EAA340025O0018A040030D3O00DAB782781BBA5D3BD9AD95740703083O005C8DC5E71B70D333030F3O00412O66656374696E67436F6D626174025O002EAF40025O00CCA840030D3O00577265636B696E675468726F77026O003E4003133O00F1ED8FA0DAEFF18D9CC5EEED85B491EBFE83AD03053O00B1869FEAC3025O00A8A940025O00249C40025O007BB040025O00CDB040025O0060AD40025O00206E40025O00D89840025O00B08F40025O00149040025O0070A140025O00CC9C40025O0050B040025O00688540025O0075B240025O00B4A840030B3O008DF55ACBACF37CCCB7FF5F03043O00A4C59028030B3O004865726F69635468726F7703113O008BF5B884D4B5BCE4A299D2A1C3FDAB82D303063O00D6E390CAEBBD025O0063B040025O005EA940025O0062AD40025O006EA0400009032O0012AA3O00014O00B4000100023O0026E63O0002030100020004353O000203010026D600010008000100010004353O00080001002EED00040004000100030004353O000400010012AA000200013O0026D60002000D000100010004353O000D0001002E3400050030000100060004353O003000010012AA000300014O00B4000400043O0026E60003000F000100010004353O000F00010012AA000400013O0026E600040016000100020004353O001600010012AA000200023O0004353O003000010026E600040012000100010004353O001200010012AA000500013O002EED0007001F000100080004353O001F0001002O0E0002001F000100050004353O001F00010012AA000400023O0004353O00120001002E05010900FAFF2O00090004353O001900010026E600050019000100010004353O001900012O0088000600014O00E20006000100022O000700066O008800065O0006220106002B00013O0004353O002B00012O008800066O0073000600023O0012AA000500023O0004353O001900010004353O001200010004353O003000010004353O000F0001002E34000A00090001000B0004353O000900010026E600020009000100020004353O000900012O0088000300023O0006220103007300013O0004353O007300010012AA000300014O00B4000400043O002EED000D00390001000C0004353O00390001002O0E00010039000100030004353O003900010012AA000400013O002O0E0001005A000100040004353O005A00010012AA000500013O0026D600050045000100010004353O00450001002EED000E00550001000F0004353O005500012O0088000600033O00205D0006000600104O000700043O00202O0007000700114O000800053O00202O00080008001200122O000900136O000A00016O0006000A00024O00068O00065O0006220106005400013O0004353O005400012O008800066O0073000600023O0012AA000500023O0026E600050041000100020004353O004100010012AA000400023O0004353O005A00010004353O00410001002E340014003E000100150004353O003E00010026E60004003E000100020004353O003E00012O0088000500033O0020710005000500104O000600043O00202O0006000600164O000700053O00202O00070007001700122O000800186O000900016O0005000900024O00055O002E2O001A0073000100190004353O007300012O008800055O0006220105007300013O0004353O007300012O008800056O0073000500023O0004353O007300010004353O003E00010004353O007300010004353O003900012O0088000300033O00201D00030003001B2O00E20003000100020006220103000803013O0004353O000803010012AA000300014O00B4000400053O0026E60003007F000100010004353O007F00010012AA000400014O00B4000500053O0012AA000300023O0026E60003007A000100020004353O007A00010026D600040085000100010004353O00850001002E05011C00832O01001D0004353O000602010012AA000600013O0026D60006008A000100010004353O008A0001002E34001F00B50001001E0004353O00B500012O0088000700063O000622010700AB00013O0004353O00AB00012O0088000700044O0015000800073O00122O000900203O00122O000A00216O0008000A00024O00070007000800202O0007000700224O00070002000200062O000700AB00013O0004353O00AB00012O0088000700083O000652000700AB000100010004353O00AB00012O0088000700094O00D9000800043O00202O0008000800234O0009000A3O00202O0009000900244O000B00043O00202O000B000B00234O0009000B00024O000900096O00070009000200062O000700AB00013O0004353O00AB00012O0088000700073O0012AA000800253O0012AA000900264O008F000700094O005100076O0088000700033O0020980007000700274O0008000A3O00202O0008000800284O000A00043O00202O000A000A00294O0008000A6O00073O00024O000500073O00122O000600023O002O0E002A00B9000100060004353O00B900010012AA000400023O0004353O00060201002E34002C00860001002B0004353O008600010026E600060086000100020004353O00860001000622010500C000013O0004353O00C000012O0073000500024O0088000700083O0006220107000402013O0004353O000402012O00880007000B3O0006220107000402013O0004353O000402012O00880007000C3O000622010700CC00013O0004353O00CC00012O00880007000D3O000652000700CF000100010004353O00CF00012O00880007000C3O00065200070004020100010004353O000402012O00880007000E4O00880008000F3O00068700070004020100080004353O000402010012AA000700013O002E34002E00152O01002D0004353O00152O010026E6000700152O01002A0004353O00152O01002E34002F00F6000100300004353O00F600012O0088000800044O0015000900073O00122O000A00313O00122O000B00326O0009000B00024O00080008000900202O0008000800224O00080002000200062O000800F600013O0004353O00F600012O00880008000A3O00206F0008000800284O000A00043O00202O000A000A00294O0008000A000200062O000800F600013O0004353O00F600012O0088000800094O0088000900043O00201D0009000900332O000F010800020002000622010800F600013O0004353O00F600012O0088000800073O0012AA000900343O0012AA000A00354O008F0008000A4O005100086O0088000800044O0015000900073O00122O000A00363O00122O000B00376O0009000B00024O00080008000900202O0008000800224O00080002000200062O000800072O013O0004353O00072O012O00880008000A3O00200D0008000800284O000A00043O00202O000A000A00294O0008000A000200062O000800092O0100010004353O00092O01002EED003900142O0100380004353O00142O012O0088000800094O0088000900043O00201D00090009003A2O000F010800020002000622010800142O013O0004353O00142O012O0088000800073O0012AA0009003B3O0012AA000A003C4O008F0008000A4O005100085O0012AA0007003D3O0026D6000700192O0100010004353O00192O01002E34003F005C2O01003E0004353O005C2O010012AA000800013O0026E6000800572O0100010004353O00572O012O0088000900044O0015000A00073O00122O000B00403O00122O000C00416O000A000C00024O00090009000A00202O0009000900224O00090002000200062O000900382O013O0004353O00382O012O00880009000A3O00206F0009000900284O000B00043O00202O000B000B00294O0009000B000200062O000900382O013O0004353O00382O012O0088000900094O0088000A00043O00201D000A000A00422O000F010900020002000622010900382O013O0004353O00382O012O0088000900073O0012AA000A00433O0012AA000B00444O008F0009000B4O005100095O002EED004600562O0100450004353O00562O012O0088000900044O0015000A00073O00122O000B00473O00122O000C00486O000A000C00024O00090009000A00202O0009000900224O00090002000200062O000900562O013O0004353O00562O012O00880009000A3O0020830009000900494O000B00043O00202O000B000B00294O0009000B0002000E2O004A00562O0100090004353O00562O012O0088000900094O0088000A00043O00201D000A000A004B2O000F010900020002000622010900562O013O0004353O00562O012O0088000900073O0012AA000A004C3O0012AA000B004D4O008F0009000B4O005100095O0012AA000800023O0026E60008001A2O0100020004353O001A2O010012AA000700023O0004353O005C2O010004353O001A2O010026E60007008B2O01003D0004353O008B2O012O0088000800044O0015000900073O00122O000A004E3O00122O000B004F6O0009000B00024O00080008000900202O0008000800224O00080002000200062O0008000402013O0004353O000402012O00880008000A3O00206F0008000800504O000A00043O00202O000A000A00294O0008000A000200062O0008000402013O0004353O000402012O0088000800044O00E9000900073O00122O000A00513O00122O000B00526O0009000B00024O00080008000900202O0008000800534O00080002000200062O00080004020100010004353O000402012O0088000800094O00D9000900043O00202O0009000900544O000A000A3O00202O000A000A00244O000C00043O00202O000C000C00544O000A000C00024O000A000A6O0008000A000200062O0008000402013O0004353O000402012O0088000800073O001223000900553O00122O000A00566O0008000A6O00085O00044O000402010026E6000700D4000100020004353O00D400010012AA000800014O00B4000900093O0026E60008008F2O0100010004353O008F2O010012AA000900013O0026D6000900962O0100020004353O00962O01002E34005700982O0100580004353O00982O010012AA0007002A3O0004353O00D400010026D60009009C2O0100010004353O009C2O01002EED005A00922O0100590004353O00922O010012AA000A00013O002E34005C00FB2O01005B0004353O00FB2O010026E6000A00FB2O0100010004353O00FB2O012O0088000B00044O0015000C00073O00122O000D005D3O00122O000E005E6O000C000E00024O000B000B000C00202O000B000B00224O000B0002000200062O000B00CC2O013O0004353O00CC2O012O0088000B00044O002E000C00073O00122O000D005F3O00122O000E00606O000C000E00024O000B000B000C00202O000B000B00614O000B00020002000E2O006200CC2O01000B0004353O00CC2O012O0088000B00103O00201C010B000B00632O000F010B000200020026C3000B00CC2O0100640004353O00CC2O01002EED006500CC2O0100660004353O00CC2O012O0088000B00094O0040000C00043O00202O000C000C00674O000D000A3O00202O000D000D006800122O000F00186O000D000F00024O000D000D6O000B000D000200062O000B00CC2O013O0004353O00CC2O012O0088000B00073O0012AA000C00693O0012AA000D006A4O008F000B000D4O0051000B6O0088000B00044O0015000C00073O00122O000D006B3O00122O000E006C6O000C000E00024O000B000B000C00202O000B000B00224O000B0002000200062O000B00FA2O013O0004353O00FA2O012O0088000B000A3O00206F000B000B00504O000D00043O00202O000D000D00294O000B000D000200062O000B00FA2O013O0004353O00FA2O012O0088000B00044O00E9000C00073O00122O000D006D3O00122O000E006E6O000C000E00024O000B000B000C00202O000B000B00534O000B0002000200062O000B00FA2O0100010004353O00FA2O01002E05016F00130001006F0004353O00FA2O012O0088000B00094O00D9000C00043O00202O000C000C00704O000D000A3O00202O000D000D00244O000F00043O00202O000F000F00704O000D000F00024O000D000D6O000B000D000200062O000B00FA2O013O0004353O00FA2O012O0088000B00073O0012AA000C00713O0012AA000D00724O008F000B000D4O0051000B5O0012AA000A00023O0026E6000A009D2O0100020004353O009D2O010012AA000900023O0004353O00922O010004353O009D2O010004353O00922O010004353O00D400010004353O008F2O010004353O00D400010012AA0006002A3O0004353O00860001002EED00730044020100740004353O004402010026E6000400440201002A0004353O004402012O0088000600044O0015000700073O00122O000800753O00122O000900766O0007000900024O00060006000700202O0006000600774O00060002000200062O0006001902013O0004353O001902012O00880006000A3O00201C0106000600782O000F0106000200020026890006001E020100790004353O001E02012O00880006000A3O00201C0106000600782O000F0106000200020026C30006002D020100130004353O002D02010012AA000600013O0026E60006001F020100010004353O001F02012O0088000700114O00E20007000100022O000700076O008800075O00065200070029020100010004353O00290201002E05017A00060001007B0004353O002D02012O008800076O0073000700023O0004353O002D02010004353O001F02012O0088000600124O00E20006000100022O000700066O008800065O0006220106003502013O0004353O003502012O008800066O0073000600024O0088000600133O00205A00060006007C4O000700043O00202O00070007007D4O00088O000900073O00122O000A007E3O00122O000B007F6O0009000B6O00063O000200062O0006000803013O0004353O000803010012AA000600804O0073000600023O0004353O000803010026E600040081000100020004353O008100010012AA000600013O0026E6000600A0020100020004353O00A00201002EED00820073020100810004353O007302012O0088000700044O0015000800073O00122O000900833O00122O000A00846O0008000A00024O00070007000800202O0007000700224O00070002000200062O0007007302013O0004353O007302012O0088000700143O0006220107007302013O0004353O007302012O00880007000A3O00201C0107000700852O000F0107000200020006220107007302013O0004353O007302012O0088000700154O00E20007000100020006220107007302013O0004353O00730201002EED00870073020100860004353O007302012O0088000700094O0040000800043O00202O0008000800884O0009000A3O00202O00090009006800122O000B00896O0009000B00024O000900096O00070009000200062O0007007302013O0004353O007302012O0088000700073O0012AA0008008A3O0012AA0009008B4O008F000700094O005100076O0088000700163O0006220107007902013O0004353O007902012O0088000700173O000EE3002A007B020100070004353O007B0201002EED008C009F0201008D0004353O009F02010012AA000700014O00B4000800093O002EED008E00970201008F0004353O009702010026E600070097020100020004353O009702010026D600080085020100010004353O00850201002E3400900081020100910004353O008102010012AA000900013O0026E600090086020100010004353O008602012O0088000A00184O00E2000A000100022O0007000A6O0088000A5O000652000A0090020100010004353O00900201002EED0092009F020100930004353O009F02012O0088000A6O0073000A00023O0004353O009F02010004353O008602010004353O009F02010004353O008102010004353O009F0201000E312O01009B020100070004353O009B0201002EED0095007D020100940004353O007D02010012AA000800014O00B4000900093O0012AA000700023O0004353O007D02010012AA0006002A3O000E312O0100A4020100060004353O00A40201002EED009700F3020100960004353O00F302010012AA000700013O0026E6000700EC020100010004353O00EC02012O00880008000E4O00880009000F3O000687000800C8020100090004353O00C802012O0088000800193O000622010800B702013O0004353O00B702012O00880008000D3O000622010800B402013O0004353O00B402012O00880008001A3O000652000800B9020100010004353O00B902012O00880008001A3O000622010800B902013O0004353O00B90201002E34009900C8020100980004353O00C802010012AA000800013O0026E6000800BA020100010004353O00BA02012O00880009001B4O00E20009000100022O000700095O002E05019A00090001009A0004353O00C802012O008800095O000622010900C802013O0004353O00C802012O008800096O0073000900023O0004353O00C802010004353O00BA02012O00880008001C3O000622010800EB02013O0004353O00EB02012O0088000800044O0015000900073O00122O000A009B3O00122O000B009C6O0009000B00024O00080008000900202O0008000800224O00080002000200062O000800EB02013O0004353O00EB02012O00880008000A3O00201C0108000800680012AA000A00894O00010008000A0002000652000800EB020100010004353O00EB02012O0088000800094O0040000900043O00202O00090009009D4O000A000A3O00202O000A000A006800122O000C00896O000A000C00024O000A000A6O0008000A000200062O000800EB02013O0004353O00EB02012O0088000800073O0012AA0009009E3O0012AA000A009F4O008F0008000A4O005100085O0012AA000700023O0026D6000700F0020100020004353O00F00201002E0501A000B7FF2O00A10004353O00A502010012AA000600023O0004353O00F302010004353O00A502010026D6000600F70201002A0004353O00F70201002E3400A20047020100A30004353O004702010012AA0004002A3O0004353O008100010004353O004702010004353O008100010004353O000803010004353O007A00010004353O000803010004353O000900010004353O000803010004353O000400010004353O000803010026E63O0002000100010004353O000200010012AA000100014O00B4000200023O0012AA3O00023O0004353O000200012O004D3O00017O009A3O00028O00025O0074B040025O00805840026O001840025O00708440025O0002A740030C3O004570696353652O74696E677303083O006289BC675882AF6003043O001331ECC803113O00EB24F384F4BFFF25D9B1C6BBED23FFB8EA03063O00DA9E5796D78403083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203113O00F0B5BFF380F9EBA2BFD587F9F694B5C69A03063O008C85C6DAA7E8026O00F03F03083O00862BA0698DBB29A703053O00E4D54ED41D030D3O00925FB332EA954EA400EA8C49A403053O008BE72CD665026O001C40026O000840025O0084A240025O00CCB14003083O002DC4B4F0B47C19D203063O00127EA1C084DD03123O004A3BAB37415A2DBE0D2O581BBA165F542DBD03053O00363F48CE64026O001040025O006CA340025O009CAA4003083O0010D1603DD8F824C703063O009643B41449B103103O00980B1F7E860D16419E081644990C1F5F03043O002DED787A03083O00E4EDB638DEE6A53F03043O004CB788C203073O006FF5E00B5C4E1903073O00741A868558302F025O00108040025O000EA240025O0044A440025O00BC964003083O002OEA124A19BF360503083O0076B98F663E70D151030C3O005D6628F2A4072B3148780AC203083O00583C104986C5757C03083O0063EFECDC485EEDEB03053O0021308A98A803103O00701A3155C4246619225CF63E661E137503063O005712765031A1025O00C1B140025O0098B04003083O007F1BCEB4B94219C903053O00D02C7EBAC003133O00F415A8C907EFDC5DC417A5D51CCBC05AFF398003083O002E977AC4A6749CA9026O002040025O006C9A4003083O00D6E8520EF2EBEA5503053O009B858D267A03143O00363AA9405D50A3072BBF554670AB1223B8496C5B03073O00C5454ACC212F1F03083O00C34A4E93F9415D9403043O00E7902F3A03143O00A6D0CF7B1C38DD36A7CBE87A192FF830A6D0F95103083O0059D2B8BA15785DAF03083O00825668C17034B64003063O005AD1331CB51903103O00C77A45ECADD57A5CEBADE77243E69CF403053O00DFB01B378E026O001440025O00D88740025O002FB040025O001C9340025O001AA740025O00AAA34003083O00BE4D90FD79B88A5B03063O00D6ED28E4891003103O0090F0EAFA0CAA8AF0FCCC109588E2FCD103063O00C6E5838FB963025O00788540025O0015B040025O0040724003083O000E153AECD5313A2O03063O005F5D704E98BC03093O00D4E68034F2BFC6C0E703073O00B2A195E57584DE03083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C6030D3O009E3DB0023703EB8E3DA12F290F03073O008FEB4ED5405B62025O00889C40025O00AEB040025O009C9840025O00789F40025O00405F40025O004DB040025O00349D4003083O00FB5C516EEC75CF4A03063O001BA839251A85030E3O0038B9799CDF38A478ADC50EA67DB803053O00B74DCA1CC803083O0024369D1C1E3D8E1B03043O00687753E9030C3O00E0EB22154BFCEA2B354AFBFC03053O002395984742025O00D07740025O00F8AD4003083O002AED56A43317EF5103053O005A798822D003103O00D21D5029D50B5615CE00522ACF1C5A0903043O007EA76E35025O00E0A940025O0012A94003083O0028896D2012827E2703043O00547BEC19030A3O00E598AF32B4B0F39EBE1203063O00D590EBCA77CC03083O00101DCA3E212D4A3003073O002D4378BE4A4843030E3O003531E88DFC9AE1E02316E5B7F69F03083O008940428DC599E88E03083O0030D536B2810DD73103053O00E863B042C6030F3O00F9322D2B749FED2DE0123C147286FC03083O004C8C4148661BED99027O004003083O0079DF02C6DE0FB95903073O00DE2ABA76B2B761030C3O0048FF41A54BE9569A52FB419803043O00EA3D8C2403083O0012D8AE66062FDAA903053O006F41BDDA1203073O0056581E070E52AB03073O00CF232B7B556B3C025O00489240026O002O4003083O0043AFB4FE707EADB303053O001910CAC08A030C3O00E8D8A8D1A1FBFEC0BAE3BFF103063O00949DABCD82C903083O0089E70EF2ECB4E50903053O0085DA827A86030E3O0029EC2OE6DDB72C30FAD0CCD3B62C03073O00585C9F83A4BCC303083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B03093O003BEF8F35C92FEE8D1303053O00A14E9CEA7603083O0094B2DDC8AEB9CECF03043O00BCC7D7A903093O00E91A5A58E4F908497E03053O00889C693F1B00F2012O0012AA3O00014O00B4000100013O0026D63O0006000100010004353O00060001002EED00020002000100030004353O000200010012AA000100013O0026E600010038000100040004353O003800010012AA000200013O002E3400050027000100060004353O002700010026E600020027000100010004353O00270001001278000300074O00DB000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O00035O00122O000300076O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000300023O00122O000200103O0026E60002000A000100100004353O000A0001001278000300074O0003000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000300033O00122O000100153O00044O003800010004353O000A00010026D60001003C000100160004353O003C0001002E0501170031000100180004353O006B00010012AA000200013O0026E60002004D000100100004353O004D0001001278000300074O0003000400013O00122O000500193O00122O0006001A6O0004000600024O0003000300044O000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000300043O00122O0001001D3O00044O006B0001002EED001E003D0001001F0004353O003D00010026E60002003D000100010004353O003D0001001278000300074O00E1000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000300053O00122O000300076O000400013O00122O000500243O00122O000600256O0004000600024O0003000300044O000400013O00122O000500263O00122O000600276O0004000600024O0003000300044O000300063O00122O000200103O00044O003D00010026E6000100A8000100150004353O00A800010012AA000200013O0026D600020072000100010004353O00720001002EED00290095000100280004353O009500010012AA000300013O0026E600030077000100100004353O007700010012AA000200103O0004353O00950001002E34002B00730001002A0004353O007300010026E600030073000100010004353O00730001001278000400074O00E1000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000400073O00122O000400076O000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000400083O00122O000300103O00044O00730001002E340035006E000100340004353O006E0001002O0E0010006E000100020004353O006E0001001278000300074O0003000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O0003000300044O000300093O00122O0001003A3O00044O00A800010004353O006E0001002E05013B00290001003B0004353O00D100010026E6000100D10001003A0004353O00D10001001278000200074O00A0000300013O00122O0004003C3O00122O0005003D6O0003000500024O0002000200034O000300013O00122O0004003E3O00122O0005003F6O0003000500024O0002000200034O0002000A3O00122O000200076O000300013O00122O000400403O00122O000500416O0003000500024O0002000200034O000300013O00122O000400423O00122O000500436O0003000500024O0002000200034O0002000B3O00122O000200076O000300013O00122O000400443O00122O000500456O0003000500024O0002000200034O000300013O00122O000400463O00122O000500476O0003000500024O0002000200034O0002000C3O00044O00F12O010026D6000100D5000100480004353O00D50001002E34004A00182O0100490004353O00182O010012AA000200014O00B4000300033O002E05014B3O0001004B0004353O00D700010026E6000200D7000100010004353O00D700010012AA000300013O0026D6000300E0000100100004353O00E00001002E34004C00EE0001004D0004353O00EE0001001278000400074O0003000500013O00122O0006004E3O00122O0007004F6O0005000700024O0004000400054O000500013O00122O000600503O00122O000700516O0005000700024O0004000400054O0004000D3O00122O000100043O00044O00182O010026E6000300DC000100010004353O00DC00010012AA000400013O002E34005200F7000100530004353O00F700010026E6000400F7000100100004353O00F700010012AA000300103O0004353O00DC0001002E05015400FAFF2O00540004353O00F10001002O0E000100F1000100040004353O00F10001001278000500074O00E1000600013O00122O000700553O00122O000800566O0006000800024O0005000500064O000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O0005000E3O00122O000500076O000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500064O000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500064O0005000F3O00122O000400103O00044O00F100010004353O00DC00010004353O00182O010004353O00D700010026E60001005F2O01001D0004353O005F2O010012AA000200014O00B4000300033O002E05015D3O0001005D0004353O001C2O01002O0E0001001C2O0100020004353O001C2O010012AA000300013O002E34005F004A2O01005E0004353O004A2O010026E60003004A2O0100010004353O004A2O010012AA000400013O002EED0061002C2O0100600004353O002C2O010026E60004002C2O0100100004353O002C2O010012AA000300103O0004353O004A2O01002EED006300262O0100620004353O00262O010026E6000400262O0100010004353O00262O01001278000500074O00E1000600013O00122O000700643O00122O000800656O0006000800024O0005000500064O000600013O00122O000700663O00122O000800676O0006000800024O0005000500064O000500103O00122O000500076O000600013O00122O000700683O00122O000800696O0006000800024O0005000500064O000600013O00122O0007006A3O00122O0008006B6O0006000800024O0005000500064O000500113O00122O000400103O00044O00262O010026D60003004E2O0100100004353O004E2O01002EED006D00212O01006C0004353O00212O01001278000400074O0003000500013O00122O0006006E3O00122O0007006F6O0005000700024O0004000400054O000500013O00122O000600703O00122O000700716O0005000700024O0004000400054O000400123O00122O000100483O00044O005F2O010004353O00212O010004353O005F2O010004353O001C2O010026E6000100902O0100100004353O00902O010012AA000200013O0026D6000200662O0100010004353O00662O01002EED0072007F2O0100730004353O007F2O01001278000300074O00DB000400013O00122O000500743O00122O000600756O0004000600024O0003000300044O000400013O00122O000500763O00122O000600776O0004000600024O0003000300044O000300133O00122O000300076O000400013O00122O000500783O00122O000600796O0004000600024O0003000300044O000400013O00122O0005007A3O00122O0006007B6O0004000600024O0003000300044O000300143O00122O000200103O0026E6000200622O0100100004353O00622O01001278000300074O0003000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O000400013O00122O0005007E3O00122O0006007F6O0004000600024O0003000300044O000300153O00122O000100803O00044O00902O010004353O00622O010026E6000100C72O0100800004353O00C72O010012AA000200014O00B4000300033O002O0E000100942O0100020004353O00942O010012AA000300013O0026E6000300B22O0100010004353O00B22O01001278000400074O00DB000500013O00122O000600813O00122O000700826O0005000700024O0004000400054O000500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000400163O00122O000400076O000500013O00122O000600853O00122O000700866O0005000700024O0004000400054O000500013O00122O000600873O00122O000700886O0005000700024O0004000400054O000400173O00122O000300103O002EED008A00972O0100890004353O00972O010026E6000300972O0100100004353O00972O01001278000400074O0003000500013O00122O0006008B3O00122O0007008C6O0005000700024O0004000400054O000500013O00122O0006008D3O00122O0007008E6O0005000700024O0004000400054O000400183O00122O000100163O00044O00C72O010004353O00972O010004353O00C72O010004353O00942O010026E600010007000100010004353O00070001001278000200074O00A4000300013O00122O0004008F3O00122O000500906O0003000500024O0002000200034O000300013O00122O000400913O00122O000500926O0003000500024O0002000200034O000200193O00122O000200076O000300013O00122O000400933O00122O000500946O0003000500024O0002000200034O000300013O00122O000400953O00122O000500966O0003000500024O0002000200034O0002001A3O00122O000200076O000300013O00122O000400973O00122O000500986O0003000500024O0002000200034O000300013O00122O000400993O00122O0005009A6O0003000500024O0002000200034O0002001B3O00122O000100103O00044O000700010004353O00F12O010004353O000200012O004D3O00017O006E3O00028O00026O00F03F025O0050AA40025O00808740026O000840025O0034AE40030C3O004570696353652O74696E677303083O00F5A60F9DC6C8A40803053O00AFA6C37BE9030A3O00FACC4E5DF1E1C15861C003053O00908FA23D2903083O00D3D609447B8934F303073O005380B37D3012E7030F3O0059BEF6FF5E2A55B2C0CA480C599FC303063O007E3DD793BD27027O0040025O00989640025O00D2AD40026O001040025O008AA240025O004CB140025O00C07F40025O001CB24003083O004BFA095171F11A5603043O0025189F7D030C3O00D3A17B4DC8A34543D3A85D7203043O0022BAC61503083O00CB0DD149CBF60FD603053O00A29868A53D030B3O00C421A67862F3C821B7554003063O0085AD4FD21D10025O00B0944003083O0017BEDAA12DB5C9A603043O00D544DBAE03093O001EF326D73FC8327A0703083O001F6B8043874AA55F03083O00EBEDE85948BFDFFB03063O00D1B8889C2D21030C3O0012DB703BAC08DA782AB70BDC03053O00D867A8156803083O004BA857B071A344B703043O00C418CD2303143O003B98E62F209FEA0B278FE2122785E4352684F61203043O00664EEB8303083O00C92B20504E37B02703083O00549A4E54242759D703113O00E8F2537A0CE9F5534A2CF0EC43560CE9F803053O00659D813638025O00107A40025O0059B04003083O00CD7711CBF77C02CC03043O00BF9E1265030D3O002OD0829EA8CBCC95B29FC4CA8903053O00CFA5A3E7D703083O00F5FCED422D7EC1EA03063O0010A62O993644030C3O00C7A0C56F3A35FCC0A5C5483103073O0099B2D3A026544103083O002EAC9EBF2A771ABA03063O00197DC9EACB4303123O006CE71D2711211677E7111511140778FA1B0603073O007319947863744703083O003F38AD3048023AAA03053O00216C5DD94403103O00CE58A489D24E83B4EF43A49ECC44B3A903043O00CDBB2BC103083O00BE79F93F8472EA3803043O004BED1C8D03103O00CE5EC0BD3612E9E6FF4DD5963D14F2F103083O0081BC3FACD14F7B8703083O0073E1F2D949EAE1DE03043O00AD208486030D3O005C1A04E3B738C349381AF6860103073O00AD2E7B688FCE5103083O008718369E4C8D06A703073O0061D47D42EA25E3030D3O009CEAB5211198FA84200D82CB8603053O007EEA83D65503083O00B7D05D4E468AD25A03053O002FE4B5293A030C3O00B5ECDC3A11031AB2E8D0350403073O007FC69CB95B635003063O00E516CDE9A21903083O00BE957AAC90C76B59025O00307C40025O0060A240025O00349540025O009EA540025O00D09640025O0064AA40025O00F8AA40025O0078AB4003083O00B10E4E3F8B055D3803043O004BE26B3A030E3O004DCD144810CEC141D71F7D32D0D403073O00AD38BE711A71A203083O00F8DB3911FEC5D93E03053O0097ABBE4D65030E3O00D03CFD9FF17E1FCA3DE19BED6E2O03073O006BA54F98C9981D03083O00644BFCDF5D71505D03063O001F372E88AB3403103O00D321C8E0D43AF5F9DC3DD2FDC531F4C403043O0094B148BC03083O0095B343C7AFB850C003043O00B3C6D63703113O00F40974734BC0F91A774551D2FE0F775E7503063O00B3906C121625025O0052AE40025O00889D40008F012O0012AA3O00014O00B4000100023O0026E63O00882O0100020004353O00882O010026D600010008000100010004353O00080001002EED00030004000100040004353O000400010012AA000200013O002O0E00050063000100020004353O006300010012AA000300013O002E0501060023000100060004353O002F00010026E60003002F000100010004353O002F0001001278000400074O005C000500013O00122O000600083O00122O000700096O0005000700024O0004000400054O000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500062O0004001E000100010004353O001E00010012AA000400014O000700045O001229010400076O000500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400054O000500013O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500062O0004002D000100010004353O002D00010012AA000400014O0007000400023O0012AA000300023O0026D600030033000100100004353O00330001002E0501110004000100120004353O003500010012AA000200133O0004353O006300010026E60003000C000100020004353O000C00010012AA000400013O0026D60004003C000100020004353O003C0001002EED0015003E000100140004353O003E00010012AA000300103O0004353O000C0001002E3400160038000100170004353O003800010026E600040038000100010004353O00380001001278000500074O005C000600013O00122O000700183O00122O000800196O0006000800024O0005000500064O000600013O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600062O00050050000100010004353O005000010012AA000500014O0007000500033O001229010500076O000600013O00122O0007001C3O00122O0008001D6O0006000800024O0005000500064O000600013O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600062O0005005F000100010004353O005F00010012AA000500014O0007000500043O0012AA000400023O0004353O003800010004353O000C0001002E0501200035000100200004353O009800010026E600020098000100010004353O00980001001278000300074O003D000400013O00122O000500213O00122O000600226O0004000600024O0003000300044O000400013O00122O000500233O00122O000600246O0004000600024O0003000300044O000300053O00122O000300076O000400013O00122O000500253O00122O000600266O0004000600024O0003000300044O000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000300063O00122O000300076O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000400013O00122O0005002B3O00122O0006002C6O0004000600024O0003000300044O000300073O00122O000300076O000400013O00122O0005002D3O00122O0006002E6O0004000600024O0003000300044O000400013O00122O0005002F3O00122O000600306O0004000600024O0003000300044O000300083O00122O000200023O002O0E000200DE000100020004353O00DE00010012AA000300014O00B4000400043O002O0E0001009C000100030004353O009C00010012AA000400013O0026E6000400A3000100100004353O00A300010012AA000200103O0004353O00DE0001002E34003100C0000100320004353O00C000010026E6000400C0000100020004353O00C00001001278000500074O00DB000600013O00122O000700333O00122O000800346O0006000800024O0005000500064O000600013O00122O000700353O00122O000800366O0006000800024O0005000500064O000500093O00122O000500076O000600013O00122O000700373O00122O000800386O0006000800024O0005000500064O000600013O00122O000700393O00122O0008003A6O0006000800024O0005000500064O0005000A3O00122O000400103O002O0E0001009F000100040004353O009F0001001278000500074O00E1000600013O00122O0007003B3O00122O0008003C6O0006000800024O0005000500064O000600013O00122O0007003D3O00122O0008003E6O0006000800024O0005000500064O0005000B3O00122O000500076O000600013O00122O0007003F3O00122O000800406O0006000800024O0005000500064O000600013O00122O000700413O00122O000800426O0006000800024O0005000500064O0005000C3O00122O000400023O00044O009F00010004353O00DE00010004353O009C00010026E6000200202O0100130004353O00202O01001278000300074O005C000400013O00122O000500433O00122O000600446O0004000600024O0003000300044O000400013O00122O000500453O00122O000600466O0004000600024O00030003000400062O000300EE000100010004353O00EE00010012AA000300014O00070003000D3O001229010300076O000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O000400013O00122O000500493O00122O0006004A6O0004000600024O00030003000400062O000300FD000100010004353O00FD00010012AA000300014O00070003000E3O001229010300076O000400013O00122O0005004B3O00122O0006004C6O0004000600024O0003000300044O000400013O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400062O0003000C2O0100010004353O000C2O010012AA000300014O00070003000F3O001229010300076O000400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O000400013O00122O000500513O00122O000600526O0004000600024O00030003000400062O0003001E2O0100010004353O001E2O012O0088000300013O0012AA000400533O0012AA000500544O00010003000500022O0007000300103O0004353O008E2O01002EED00550009000100560004353O000900010026E600020009000100100004353O000900010012AA000300014O00B4000400043O002E34005700262O0100580004353O00262O010026E6000300262O0100010004353O00262O010012AA000400013O002E34005900522O01005A0004353O00522O01002O0E000100522O0100040004353O00522O010012AA000500013O0026D6000500342O0100010004353O00342O01002E34005C004D2O01005B0004353O004D2O01001278000600074O00DB000700013O00122O0008005D3O00122O0009005E6O0007000900024O0006000600074O000700013O00122O0008005F3O00122O000900606O0007000900024O0006000600074O000600113O00122O000600076O000700013O00122O000800613O00122O000900626O0007000900024O0006000600074O000700013O00122O000800633O00122O000900646O0007000900024O0006000600074O000600123O00122O000500023O0026E6000500302O0100020004353O00302O010012AA000400023O0004353O00522O010004353O00302O010026E60004007B2O0100020004353O007B2O010012AA000500013O0026E6000500592O0100020004353O00592O010012AA000400103O0004353O007B2O01002O0E000100552O0100050004353O00552O01001278000600074O005C000700013O00122O000800653O00122O000900666O0007000900024O0006000600074O000700013O00122O000800673O00122O000900686O0007000900024O00060006000700062O000600692O0100010004353O00692O010012AA000600014O0007000600133O001229010600076O000700013O00122O000800693O00122O0009006A6O0007000900024O0006000600074O000700013O00122O0008006B3O00122O0009006C6O0007000900024O00060006000700062O000600782O0100010004353O00782O010012AA000600014O0007000600143O0012AA000500023O0004353O00552O01000E310110007F2O0100040004353O007F2O01002E34006D002B2O01006E0004353O002B2O010012AA000200053O0004353O000900010004353O002B2O010004353O000900010004353O00262O010004353O000900010004353O008E2O010004353O000400010004353O008E2O010026E63O0002000100010004353O000200010012AA000100014O00B4000200023O0012AA3O00023O0004353O000200012O004D3O00017O004F3O00028O00026O000840030C3O004570696353652O74696E677303083O0034A00ECD26BFD11403073O00B667C57AB94FD103103O00E694E45F0549FF8EEF703047E78EEE7903063O002893E781176003083O0046FD9851B2A2DB6603073O00BC1598EC25DBCC030D3O0048EC360054E124184FE732247003043O006C208957026O00F03F025O00C0A140025O0098AC4003083O0099ED14B226F74C4A03083O0039CA8860C64F992B030F3O00A3262OAB84A9FF9B2CBEAE82A9D09B03073O0098CB43CAC7EDC7026O001040025O00DCA740025O00089E40025O005DB040025O00BCA34003083O000100E5EAF73C02E203053O009E5265919E03113O0076F7051E5042FB0F174D7EED211E4173F503053O0024109E627603083O00F313D7EF51E620F603083O0085A076A39B38884703113O00DFAC65F7A40DA0E6B646FBA21786E2B77F03073O00D596C21192D67F025O008C9340025O0044974003083O0028ACB0C04FAAA52503083O00567BC9C4B426C4C203163O00DEE6CDAAE5FACCBFE3C7D7A3EEDFD1A6E3EDD5A6E4FC03043O00CF9788B9025O00F08440025O00AC9B40025O00CC9640025O0090744003083O009B863C967D2O76BB03073O0011C8E348E2141803123O00994F0FD2DBE3FAEFA47513C5CCE2E7F0BC4503083O009FD0217BB7A9918F03083O00C15F2C22FB543F2503043O0056923A58030B3O004DCCEFF4BCE038F15DCBF903083O009A38BF8AA0CE895603083O00B55CE193753486DF03083O00ACE63995E71C5AE1030A3O0017B983E029D80BAB8AC103063O00BB62CAE6B248027O0040025O00BCA640025O0060914003083O0012E4B024432FE6B703053O002A4181C450030E3O00165854D41C0216FD354349D2342303083O008E622A3DBA77676203083O000BBA161C31B1051B03043O006858DF62030D3O0056F6E1C703E157C0EBDA0ACE6003063O008D249782AE6203083O00B77FD6198D74C51E03043O006DE41AA2030E3O004BF6F850E5E752F1F56BF4E950E003063O00863E859D1880025O00188240025O00FCB14003083O00C946B41B167B7EF503083O00869A23C06F7F151903113O009023080629DCBF16061E29DDB62O08072503063O00B2D846696A40034O0003083O000C2E6EE2C0DBD39303083O00E05F4B1A96A9B5B403113O0023DBD62C48A95F05D9D73A54A3640EDBD403073O00166BBAB84824CC0008012O0012AA3O00014O00B4000100013O002O0E0001000200013O0004353O000200010012AA000100013O0026E60001003C000100020004353O003C00010012AA000200013O0026E600020026000100010004353O00260001001278000300034O003F000400013O00122O000500043O00122O000600056O0004000600024O0003000300044O000400013O00122O000500063O00122O000600076O0004000600024O0003000300042O000700035O001229010300036O000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400062O00030024000100010004353O002400010012AA000300014O0007000300023O0012AA0002000C3O0026D60002002A0001000C0004353O002A0001002EED000E00080001000D0004353O00080001001278000300034O005C000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000400013O00122O000500113O00122O000600126O0004000600024O00030003000400062O00030038000100010004353O003800010012AA000300014O0007000300033O0012AA000100133O0004353O003C00010004353O000800010026D600010040000100010004353O00400001002EED00140074000100150004353O007400010012AA000200013O0026D600020045000100010004353O00450001002E3400160061000100170004353O00610001001278000300034O005C000400013O00122O000500183O00122O000600196O0004000600024O0003000300044O000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400062O00030053000100010004353O005300010012AA000300014O0007000300043O001204010300036O000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000300053O00122O0002000C3O000E31010C0065000100020004353O00650001002E3400210041000100200004353O00410001001278000300034O0003000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000400013O00122O000500243O00122O000600256O0004000600024O0003000300044O000300063O00122O0001000C3O00044O007400010004353O004100010026D6000100780001000C0004353O00780001002E0501260037000100270004353O00AD00010012AA000200014O00B4000300033O0026E60002007A000100010004353O007A00010012AA000300013O002EED0029009A000100280004353O009A00010026E60003009A000100010004353O009A0001001278000400034O00DB000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000400073O00122O000400036O000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000400083O00122O0003000C3O002O0E000C007D000100030004353O007D0001001278000400034O0003000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000400093O00122O000100363O00044O00AD00010004353O007D00010004353O00AD00010004353O007A00010026E6000100E4000100360004353O00E400010012AA000200014O00B4000300033O0026E6000200B1000100010004353O00B100010012AA000300013O002E34003800D1000100370004353O00D100010026E6000300D1000100010004353O00D10001001278000400034O00DB000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400054O0004000A3O00122O000400036O000500013O00122O0006003D3O00122O0007003E6O0005000700024O0004000400054O000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O0004000B3O00122O0003000C3O002O0E000C00B4000100030004353O00B40001001278000400034O0003000500013O00122O000600413O00122O000700426O0005000700024O0004000400054O000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O0004000C3O00122O000100023O00044O00E400010004353O00B400010004353O00E400010004353O00B10001002E3400450005000100460004353O00050001002O0E00130005000100010004353O00050001001278000200034O005C000300013O00122O000400473O00122O000500486O0003000500024O0002000200034O000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300062O000200F6000100010004353O00F600010012AA0002004B4O00070002000D3O001233000200036O000300013O00122O0004004C3O00122O0005004D6O0003000500024O0002000200034O000300013O00122O0004004E3O00122O0005004F6O0003000500024O0002000200034O0002000E3O00044O00072O010004353O000500010004353O00072O010004353O000200012O004D3O00017O00443O00028O00026O00F03F030C3O004570696353652O74696E677303073O00D3B2234902E2AE03053O006E87DD442E2O033O00EC390F03073O005B83566C8BAED3027O0040025O00F89F40025O007AB040025O0070A340025O00508940025O00BAB240025O00D8AB40025O00507040025O00206140025O00688440025O008C9A4003163O00476574456E656D696573496E4D656C2O6552616E6765030E3O004973496E4D656C2O6552616E6765025O00ACA340025O00D4A740030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O00C7B240025O0020664003103O00426F2O73466967687452656D61696E73025O009EAC40025O00F88A40024O0080B3C540030C3O00466967687452656D61696E73025O0064AF40025O0052B240030C3O0049734368612O6E656C696E67025O00807840025O00B8A040025O00B3B140025O0042A840025O002EAE40025O0006A940025O001AA140025O00E88E40025O0095B040026O002E40025O00607840025O00E2A340025O00D49A40025O001BB240025O00805D40025O00289340025O0040A940025O006EAD40025O00108640030D3O004973446561644F7247686F737403113O00DCB0F1392153A5F4AAEC3E2B69A9FAABF103073O00C195DE85504C3A030B3O004973417661696C61626C65026O002040025O00B8A940025O000C974003073O00CF24BF1051FE3803053O003D9B4BD8772O033O0005A4B703073O00BD64CBD25C386903073O001B5EFA2F2354EE03043O00484F319D2O033O008BB42203043O00DCE8D0510016012O0012AA3O00014O00B4000100013O0026E63O0002000100010004353O000200010012AA000100013O0026E600010037000100010004353O003700010012AA000200014O00B4000300033O0026E600020009000100010004353O000900010012AA000300013O0026E60003001D000100020004353O001D00012O008800046O0014010400010001001204010400036O000500023O00122O000600043O00122O000700056O0005000700024O0004000400054O000500023O00122O000600063O00122O000700076O0005000700024O0004000400054O000400013O00122O000300083O002EED000900230001000A0004353O002300010026E600030023000100080004353O002300010012AA000100023O0004353O003700010026E60003000C000100010004353O000C00010012AA000400013O0026E60004002D000100010004353O002D00012O0088000500034O00140105000100012O0088000500044O00140105000100010012AA000400023O002E34000C00260001000B0004353O002600010026E600040026000100020004353O002600010012AA000300023O0004353O000C00010004353O002600010004353O000C00010004353O003700010004353O00090001002EED000E00CE0001000D0004353O00CE00010026E6000100CE000100080004353O00CE00012O0088000200053O00065200020040000100010004353O00400001002EED000F0050000100100004353O005000010012AA000200013O0026D600020045000100010004353O00450001002EED00120041000100110004353O004100012O0088000300073O0020D30003000300134O000500086O0003000500024O000300066O000300066O000300036O000300093O00044O005200010004353O004100010004353O005200010012AA000200024O0007000200094O00880002000B3O0020CF0002000200144O000400086O0002000400024O0002000A3O002E2O00150087000100160004353O008700012O00880002000C3O00201D0002000200172O00E200020001000200065200020063000100010004353O006300012O0088000200073O00201C0102000200182O000F0102000200020006220102008700013O0004353O008700010012AA000200014O00B4000300033O0026E600020065000100010004353O006500010012AA000300013O002E34001A0075000100190004353O007500010026E600030075000100010004353O007500012O00880004000E3O0020F200040004001B4O000500056O000600016O0004000600024O0004000D6O0004000D6O0004000F3O00122O000300023O002EED001D00680001001C0004353O006800010026E600030068000100020004353O006800012O00880004000F3O0026D60004007D0001001E0004353O007D00010004353O008700012O00880004000E3O00201F00040004001F4O000500066O00068O0004000600024O0004000F3O00044O008700010004353O006800010004353O008700010004353O00650001002EED002000152O0100210004353O00152O012O0088000200073O00201C0102000200222O000F010200020002000652000200152O0100010004353O00152O012O0088000200073O00201C0102000200182O000F01020002000200065200020095000100010004353O00950001002E34002400A7000100230004353O00A700010012AA000200013O0026D60002009A000100010004353O009A0001002EED00250096000100260004353O009600012O0088000300114O00E20003000100022O0007000300103O002E0501270078000100270004353O00152O012O0088000300103O000622010300152O013O0004353O00152O012O0088000300104O0073000300023O0004353O00152O010004353O009600010004353O00152O010012AA000200014O00B4000300043O002E34002900C5000100280004353O00C500010026E6000200C5000100020004353O00C50001002E34002A00AD0001002B0004353O00AD0001002O0E000100AD000100030004353O00AD00010012AA000400013O002EED002C00B20001002D0004353O00B200010026E6000400B2000100010004353O00B200012O0088000500124O00E20005000100022O0007000500103O002EED002F00152O01002E0004353O00152O012O0088000500103O000622010500152O013O0004353O00152O012O0088000500104O0073000500023O0004353O00152O010004353O00B200010004353O00152O010004353O00AD00010004353O00152O010026D6000200C9000100010004353O00C90001002E05013000E2FF2O00310004353O00A900010012AA000300014O00B4000400043O0012AA000200023O0004353O00A900010004353O00152O01002E3400320005000100330004353O000500010026E600010005000100020004353O000500010012AA000200014O00B4000300033O0026E6000200D4000100010004353O00D400010012AA000300013O0026E6000300EE000100020004353O00EE0001002E34003500E1000100340004353O00E100012O0088000400073O00201C0104000400362O000F010400020002000622010400E100013O0004353O00E100012O004D3O00014O0088000400134O0015000500023O00122O000600373O00122O000700386O0005000700024O00040004000500202O0004000400394O00040002000200062O000400ED00013O0004353O00ED00010012AA0004003A4O0007000400083O0012AA000300083O002EED003C000B2O01003B0004353O000B2O01002O0E0001000B2O0100030004353O000B2O01001278000400034O00DB000500023O00122O0006003D3O00122O0007003E6O0005000700024O0004000400054O000500023O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000400053O00122O000400036O000500023O00122O000600413O00122O000700426O0005000700024O0004000400054O000500023O00122O000600433O00122O000700446O0005000700024O0004000400054O000400143O00122O000300023O0026E6000300D7000100080004353O00D700010012AA000100083O0004353O000500010004353O00D700010004353O000500010004353O00D400010004353O000500010004353O00152O010004353O000200012O004D3O00017O00033O0003053O005072696E74032B3O00E74F42C1866A4EC0D45440C0865F5692E34D46D1881D7CC7D64D40C0D2584B92C4440FCAED5C41D7D2520103043O00B2A63D2F00084O000E016O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

