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
				if (Enum <= 157) then
					if (Enum <= 78) then
						if (Enum <= 38) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
												local B;
												local A;
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
													VIP = Inst[3];
												else
													VIP = VIP + 1;
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
										elseif (Enum > 2) then
											Stk[Inst[2]]();
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
											if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
											do
												return Stk[Inst[2]];
											end
										end
									elseif (Enum <= 6) then
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
										Stk[Inst[2]] = not Stk[Inst[3]];
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
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									elseif (Enum <= 11) then
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
									elseif (Enum > 12) then
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
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									end
								elseif (Enum <= 15) then
									if (Enum == 14) then
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
										A = Inst[2];
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
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
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
								elseif (Enum <= 16) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 17) then
									local A;
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
								if (Enum <= 23) then
									if (Enum <= 20) then
										if (Enum > 19) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											if not B then
												VIP = VIP + 1;
											else
												Stk[Inst[2]] = B;
												VIP = Inst[3];
											end
										else
											local A = Inst[2];
											local B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
										end
									elseif (Enum <= 21) then
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									elseif (Enum == 22) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
									end
								elseif (Enum <= 25) then
									if (Enum > 24) then
										do
											return;
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 27) then
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
								end
							elseif (Enum <= 33) then
								if (Enum <= 30) then
									if (Enum == 29) then
										local A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 31) then
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
								elseif (Enum == 32) then
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 35) then
								if (Enum > 34) then
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
							elseif (Enum <= 36) then
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum > 37) then
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 58) then
							if (Enum <= 48) then
								if (Enum <= 43) then
									if (Enum <= 40) then
										if (Enum > 39) then
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
									elseif (Enum <= 41) then
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
									elseif (Enum == 42) then
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
								elseif (Enum <= 45) then
									if (Enum > 44) then
										local B;
										local T;
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
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									end
								elseif (Enum <= 46) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 47) then
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
									Stk[Inst[2]] = -Stk[Inst[3]];
								end
							elseif (Enum <= 53) then
								if (Enum <= 50) then
									if (Enum == 49) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
									end
								elseif (Enum <= 51) then
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
								elseif (Enum > 52) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 55) then
								if (Enum == 54) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 57) then
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
						elseif (Enum <= 68) then
							if (Enum <= 63) then
								if (Enum <= 60) then
									if (Enum > 59) then
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
										Stk[Inst[2]] = Stk[Inst[3]];
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
								elseif (Enum == 62) then
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
								end
							elseif (Enum <= 65) then
								if (Enum == 64) then
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
								else
									Env[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 66) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
								end
							elseif (Enum > 67) then
								Stk[Inst[2]] = Stk[Inst[3]];
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 73) then
							if (Enum <= 70) then
								if (Enum > 69) then
									local B;
									local A;
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
									A = Inst[2];
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
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 71) then
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
							elseif (Enum == 72) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 75) then
							if (Enum == 74) then
								local B;
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 76) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 77) then
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
					elseif (Enum <= 117) then
						if (Enum <= 97) then
							if (Enum <= 87) then
								if (Enum <= 82) then
									if (Enum <= 80) then
										if (Enum == 79) then
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
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											local Edx;
											local Results, Limit;
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 81) then
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
								elseif (Enum <= 84) then
									if (Enum == 83) then
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
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Inst[2] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 85) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								elseif (Enum == 86) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								end
							elseif (Enum <= 92) then
								if (Enum <= 89) then
									if (Enum > 88) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local Results, Limit = _R(Stk[A]());
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum <= 90) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								elseif (Enum > 91) then
									local B = Stk[Inst[4]];
									if B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
							elseif (Enum <= 94) then
								if (Enum > 93) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
							elseif (Enum <= 95) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 96) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							end
						elseif (Enum <= 107) then
							if (Enum <= 102) then
								if (Enum <= 99) then
									if (Enum == 98) then
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
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum <= 100) then
									Stk[Inst[2]] = {};
								elseif (Enum == 101) then
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
							elseif (Enum <= 104) then
								if (Enum > 103) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 105) then
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
							elseif (Enum == 106) then
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
							end
						elseif (Enum <= 112) then
							if (Enum <= 109) then
								if (Enum > 108) then
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
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								end
							elseif (Enum <= 110) then
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
							elseif (Enum == 111) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 114) then
							if (Enum == 113) then
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
						elseif (Enum <= 115) then
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
						elseif (Enum == 116) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 137) then
						if (Enum <= 127) then
							if (Enum <= 122) then
								if (Enum <= 119) then
									if (Enum > 118) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 120) then
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
								elseif (Enum > 121) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 124) then
								if (Enum == 123) then
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
							elseif (Enum <= 125) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum > 126) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 132) then
							if (Enum <= 129) then
								if (Enum == 128) then
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
							elseif (Enum <= 130) then
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
							elseif (Enum > 131) then
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
							end
						elseif (Enum <= 134) then
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
						elseif (Enum <= 135) then
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
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 136) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 147) then
						if (Enum <= 142) then
							if (Enum <= 139) then
								if (Enum > 138) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
										VIP = Inst[3];
									end
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 140) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum == 141) then
								Stk[Inst[2]] = #Stk[Inst[3]];
							elseif (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 144) then
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
							elseif (Stk[Inst[2]] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 145) then
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
							B = Stk[Inst[4]];
							if not B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						elseif (Enum > 146) then
							local B;
							local A;
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
							A = Inst[2];
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
					elseif (Enum <= 152) then
						if (Enum <= 149) then
							if (Enum > 148) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
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
						elseif (Enum <= 150) then
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A]();
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum == 151) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
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
					elseif (Enum <= 154) then
						if (Enum > 153) then
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						else
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 155) then
						if (Stk[Inst[2]] <= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 156) then
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
						local Edx;
						local Results, Limit;
						local A;
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
				elseif (Enum <= 236) then
					if (Enum <= 196) then
						if (Enum <= 176) then
							if (Enum <= 166) then
								if (Enum <= 161) then
									if (Enum <= 159) then
										if (Enum == 158) then
											if (Inst[2] < Stk[Inst[4]]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										else
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 160) then
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
								elseif (Enum <= 163) then
									if (Enum > 162) then
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
								elseif (Enum <= 164) then
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
								elseif (Enum > 165) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 171) then
								if (Enum <= 168) then
									if (Enum == 167) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 170) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 173) then
								if (Enum > 172) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 174) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 175) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							else
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
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							end
						elseif (Enum <= 186) then
							if (Enum <= 181) then
								if (Enum <= 178) then
									if (Enum > 177) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 179) then
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
								elseif (Enum > 180) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 183) then
								if (Enum == 182) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 184) then
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
							elseif (Enum > 185) then
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
						elseif (Enum <= 191) then
							if (Enum <= 188) then
								if (Enum == 187) then
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									A = Inst[2];
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
									VIP = Inst[3];
								end
							elseif (Enum <= 189) then
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							elseif (Enum == 190) then
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
							if (Enum == 192) then
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 194) then
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
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
						elseif (Enum == 195) then
							local Edx;
							local Results, Limit;
							local A;
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
					elseif (Enum <= 216) then
						if (Enum <= 206) then
							if (Enum <= 201) then
								if (Enum <= 198) then
									if (Enum > 197) then
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
								elseif (Enum <= 199) then
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
								elseif (Enum > 200) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 203) then
								if (Enum == 202) then
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
							elseif (Enum <= 204) then
								local B;
								local A;
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 205) then
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
						elseif (Enum <= 211) then
							if (Enum <= 208) then
								if (Enum > 207) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 209) then
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
							elseif (Enum == 210) then
								local B;
								local T;
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
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum <= 213) then
							if (Enum == 212) then
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
							else
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							end
						elseif (Enum <= 214) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 215) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 226) then
						if (Enum <= 221) then
							if (Enum <= 218) then
								if (Enum == 217) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 219) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 220) then
								if (Inst[2] > Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 223) then
							if (Enum == 222) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 224) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						elseif (Enum > 225) then
							local B;
							local A;
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
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
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
					elseif (Enum <= 231) then
						if (Enum <= 228) then
							if (Enum > 227) then
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
						elseif (Enum <= 229) then
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 230) then
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
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 233) then
						if (Enum == 232) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 234) then
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
					elseif (Enum == 235) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 275) then
					if (Enum <= 255) then
						if (Enum <= 245) then
							if (Enum <= 240) then
								if (Enum <= 238) then
									if (Enum == 237) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 239) then
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
							elseif (Enum <= 242) then
								if (Enum == 241) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 243) then
								local A;
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
							elseif (Enum > 244) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 250) then
							if (Enum <= 247) then
								if (Enum > 246) then
									local B;
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
									Stk[A] = Stk[A]();
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 248) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 249) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 252) then
							if (Enum == 251) then
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
						elseif (Enum <= 253) then
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
						elseif (Enum == 254) then
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
						end
					elseif (Enum <= 265) then
						if (Enum <= 260) then
							if (Enum <= 257) then
								if (Enum > 256) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 259) then
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
						elseif (Enum <= 262) then
							if (Enum > 261) then
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
									if (Mvm[1] == 68) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							else
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 263) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 264) then
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
					elseif (Enum <= 270) then
						if (Enum <= 267) then
							if (Enum == 266) then
								local B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
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
						elseif (Enum <= 268) then
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
						elseif (Enum == 269) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 272) then
						if (Enum > 271) then
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
					elseif (Enum <= 273) then
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
						Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 274) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 295) then
					if (Enum <= 285) then
						if (Enum <= 280) then
							if (Enum <= 277) then
								if (Enum > 276) then
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
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum <= 278) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 279) then
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
						elseif (Enum <= 282) then
							if (Enum == 281) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							end
						elseif (Enum <= 283) then
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
							VIP = Inst[3];
						elseif (Enum > 284) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 290) then
						if (Enum <= 287) then
							if (Enum == 286) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 288) then
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
						elseif (Enum > 289) then
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 292) then
						if (Enum > 291) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							B = Stk[Inst[4]];
							if not B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 293) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 294) then
						local B;
						local A;
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
						Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
				elseif (Enum <= 305) then
					if (Enum <= 300) then
						if (Enum <= 297) then
							if (Enum == 296) then
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
						elseif (Enum <= 298) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 299) then
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
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A]();
						end
					elseif (Enum <= 302) then
						if (Enum > 301) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 303) then
						Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
					elseif (Enum == 304) then
						local A;
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] == Inst[4]) then
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
						T = Stk[A];
						B = Inst[3];
						for Idx = 1, B do
							T[Idx] = Stk[A + Idx];
						end
					end
				elseif (Enum <= 310) then
					if (Enum <= 307) then
						if (Enum == 306) then
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
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							if (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 308) then
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Stk[A + 1]));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
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
						local B = Inst[3];
						local K = Stk[B];
						for Idx = B + 1, Inst[4] do
							K = K .. Stk[Idx];
						end
						Stk[Inst[2]] = K;
					end
				elseif (Enum <= 312) then
					if (Enum == 311) then
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
						Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
						Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 313) then
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
					Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
				elseif (Enum > 314) then
					local A;
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!2E3O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403063O00506C6179657203063O0054617267657403053O00466F63757303093O004D6F7573654F76657203053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03053O005574696C7303093O00422O6F6C546F496E7403053O00416F454F4E03053O004344734F4E03043O0042696E6403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03053O00706169727303043O006D6174682O033O006D696E2O033O006D61782O033O0061627303053O00526F67756503083O00537562746C657479030A3O004576697363657261746503153O00526567697374657244616D616765466F726D756C6103073O005275707475726503133O005265676973746572504D756C7469706C69657203063O0053657441504C025O00507040006A012O0012BE3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004433O000A0001001224000300063O0020D5000400030007001224000500083O0020D5000500050009001224000600083O0020D500060006000A002O0601073O000100062O00443O00064O00448O00443O00044O00443O00014O00443O00024O00443O00054O00100108000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000D001000202O000F000D001100202O0010000D001200202O0011000D00130020090012000B001400202O0013000B001500202O0014000B001600202O0015000B001700202O0016000B001700202O00160016001800202O0017000B001900202O0018000B001A00202O0019000B001B00202O001A000B001C0020D5001B000B001D0020D5001C000B001E0020B0001C001C001F00202O001C001C002000202O001D000B001E00202O001D001D001F00202O001D001D002100122O001E00223O00122O001F00083O00202O001F001F000A00122O002000233O00202O002000200024001224002100233O0020E100210021002500122O002200233O00202O0022002200264O00238O00248O00258O002600533O002O0601540001000100292O00443O004B4O00443O00074O00443O004C4O00443O004D4O00443O004E4O00443O00434O00443O00444O00443O00454O00443O00464O00443O00294O00443O002A4O00443O002B4O00443O002C4O00443O00264O00443O00344O00443O00274O00443O00284O00443O004F4O00443O00504O00443O00514O00443O00524O00443O00474O00443O00484O00443O00494O00443O004A4O00443O003F4O00443O00404O00443O00414O00443O00424O00443O00324O00443O00334O00443O00394O00443O003A4O00443O002D4O00443O002E4O00443O00304O00443O00314O00443O003B4O00443O003C4O00443O003D4O00443O003E3O0020090055000B001E00202O00550055001F00202O0056000B001E00202O00560056002700202O00570012002700202O00570057002800202O00580014002700202O00580058002800202O0059001A002700202O0059005900282O0064005A6O0015005B006E3O0020D5006F00570029002013006F006F002A002O0601710002000100042O00443O000E4O00443O006A4O00443O00574O00443O000F4O0007016F007100010020D5006F0057002B002013006F006F002C002O0601710003000100022O00443O000E4O00443O00574O0007016F00710001002O06016F0004000100012O00443O00673O002O0601700005000100042O00443O004B4O00443O00074O00443O000E4O00443O000F3O002O0601710006000100052O00443O00614O00443O00334O00443O00074O00443O000F4O00443O000E3O002O0601720007000100062O00443O000F4O00443O001E4O00443O00554O00443O001B4O00443O00074O00443O00113O002O0601730008000100032O00443O001C4O00443O00574O00443O00613O002O0601740009000100022O00443O00574O00443O00163O002O060175000A000100072O00443O00614O00443O001C4O00443O00574O00443O00164O00443O006E4O00443O006C4O00443O006B3O002O060176000B000100042O00443O000E4O00443O00574O00443O00614O00443O00563O002O060177000C000100042O00443O000E4O00443O00574O00443O00614O00443O000F3O002O060178000D000100032O00443O000E4O00443O00574O00443O00613O002O060179000E000100042O00443O000E4O00443O00574O00443O00614O00443O006B3O002O06017A000F000100032O00443O000E4O00443O00574O00443O00613O002O06017B0010000100022O00443O000E4O00443O00573O002O06017C0011000100192O00443O006E4O00443O00574O00443O000F4O00443O00684O00443O006B4O00443O005D4O00443O00564O00443O00694O00443O000B4O00443O00074O00443O00614O00443O000E4O00443O007A4O00443O00594O00443O001B4O00443O00244O00443O00554O00443O00644O00443O00724O00443O00624O00443O007B4O00443O00204O00443O00214O00443O00604O00443O00773O002O06017D00120001000F2O00443O000E4O00443O00574O00443O00614O00443O00244O00443O00164O00443O006E4O00443O006B4O00443O006C4O00443O000F4O00443O007B4O00443O00564O00443O007C4O00443O001C4O00443O005D4O00443O00203O002O06017E00130001000B2O00443O00574O00443O00254O00443O00644O00443O000B4O00443O00594O00443O00074O00443O000E4O00443O00504O00443O00514O00443O00524O00443O007D3O002O06017F0014000100042O00443O00644O00443O00554O00443O005A4O00443O00253O002O0601800015000100172O00443O005D4O00443O00254O00443O00574O00443O000E4O00443O006B4O00443O000F4O00443O000B4O00443O00074O00443O00614O00443O006C4O00443O00784O00443O001B4O00443O00414O00443O00564O00443O00394O00443O00644O00443O007E4O00443O00344O00443O007F4O00443O006E4O00443O00764O00443O00704O00443O003C3O002O0601810016000100112O00443O00254O00443O00574O00443O000E4O00443O000F4O00443O00614O00443O00744O00443O006C4O00443O000B4O00443O00074O00443O00644O00443O007E4O00443O005D4O00443O004A4O00443O00754O00443O00164O00443O00794O00443O00703O002O06018200170001000A2O00443O005D4O00443O00574O00443O000E4O00443O006B4O00443O00564O00443O00074O00443O000B4O00443O00244O00443O00614O00443O00163O002O0601830018000100312O00443O000E4O00443O000F4O00443O00574O00443O00554O00443O005D4O00443O007D4O00443O00074O00443O000B4O00443O006B4O00443O00644O00443O007C4O00443O00234O00443O00614O00443O00564O00443O00604O00443O006D4O00443O00814O00443O006A4O00443O006C4O00443O001C4O00443O00824O00443O00804O00443O00534O00443O001B4O00443O00254O00443O00594O00443O00544O00443O00244O00443O006E4O00443O00714O00443O00734O00443O00214O00443O00224O00443O00204O00443O00104O00443O00684O00443O00694O00443O00494O00443O00584O00443O002B4O00443O00294O00443O005F4O00443O005C4O00443O00624O00443O005B4O00443O005E4O00443O00654O00443O00674O00443O00663O002O0601840019000100022O00443O000B4O00443O00073O002O200185000B002D00122O0086002E6O008700836O008800846O0085008800016O00013O001A3O00023O00026O00F03F026O00704002264O00A200025O00122O000300016O00045O00122O000500013O00042O0003002100012O00D700076O0028010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004FC0003000500012O00D7000300054O0044000400024O006C000300044O00AF00036O00193O00017O005C3O00028O00026O002040030C3O004570696353652O74696E677303083O0053652O74696E6773030F3O00131CA9170F3908BF162B1508B51A3903053O005C5169DB79031A3O003CD0E9BA5F2F38C6EDB6632400DAFEA755253FCAFFA75C2418C603063O00416CBF9DD33003123O001032CA6E2A31DA721735CD72223ED05B001E03043O001C435ABF03143O002F501A7A88F80F46115C82F50841387E81D33F6D03063O00947C297718E7026O002240026O00184003073O00378724ABC339B203053O00B771E24DC5030A3O00734DB0DD4C4DBDF36F7A03043O00BC2039D5030E3O00D712445605FB0E7B5217F8276E7F03053O007694602D3B03083O0070B7F91EA07191D403053O00D436D29070026O001C40026O00F03F030F3O00A3832F8F828829B38492278C85AE1E03043O00E3EBE64E030E3O006EA02D27F9D1450B53A03C00F2D503083O007F3BD3486F9CB029030D3O00AFE6474C5A8FF0524F4082CB7603053O002EE783262003113O009FBF4E4B0523BD44A286535A1F02BC41B803083O0034D6D13A2E7751C8027O0040030A3O0070DF33198DB34CCD3A3803063O00D025AC564BEC030B3O009CAEEABFBEA0B3E48EB8BA03053O00CCC9DD8FEB03103O004296FB697284F2487982CE4E638CF14F03043O002117E59E03113O0078BFC0B759B4C68B5FAEC8B45E94C0B65503043O00DB30DAA103123O00D7797D4DD458C2E870784CC860E6E2565F6D03073O008084111C29BB2F03123O00373308334E0901123F5C0D260E175C02200903053O003D6152665A03163O009F26AA4FC840130CA02A985FC256121DA403AA48D55803083O0069CC4ECB2BA7377E03173O0096A2221A1C13E350ABA9262D0701C65DB1A20E1F1016C803083O0031C5CA437E7364A7030A3O001C52DC22AF50581078FB03073O003E573BBF49E036030D3O00D416FFC8EB16F2E6E104DDEAC303043O00A987629A03133O00EE612D47FE36DACA632170D014E7CD713751E903073O00A8AB1744349D53030C3O00C779D1882622A4FC70E7AA2003073O00E7941195CD454D026O00144003103O00B4AFCEE843F38593C2FA78F98680E4DF03063O009FE0C7A79B37030F3O00D4FC30D6D5FF33DDF3DC3AD42OD01803043O00B297935C03143O00A1FC5E3917487C83EF6837135872A3FB4A15316803073O001AEC9D2C52722C030D3O00093CDC563921DB6D232FD9731A03043O003B4A4EB5026O000840030E3O0017D0545DB621FC4F56A72CF5556E03053O00D345B12O3A03133O0082F67CC5FBC2B8F770E1F0F9B8F178E1E0C4B903063O00ABD785199589030C3O00D2FC1FFCCB11EF66D1FB11DE03083O002281A8529A8F509C03133O00AEBB37054D57BA8DBD2722465A8C97A0261B5C03073O00E9E5D2536B282E026O00104003163O00E84C26D317D35722C22ACF4E2BE10DC85637DA0CD25603053O0065A12252B603123O00C1034DFBC9F0973EFC3951ECDEF18A21E40903083O004E886D399EBB82E2030D3O000E30F0E22O31CBF4382DFCE23603043O00915E5F9903133O00CDC21DC641B9CFC812C74BA4F5EE1BD84CB6E903063O00D79DAD74B52E030A3O0007B588FBDB39A7ACD1FE03053O00BA55D4EB92030D3O00F08015F738E24BED8710D91ACA03073O0038A2E1769E598E030C3O006A04CEA631D07303C68801FC03063O00B83C65A0CF4203113O00028A7DB83E9558BD3F81799337845B9F1503043O00DC51E21C0076012O0012C93O00013O00268E3O0024000100020004433O00240001001224000100033O0020730001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O00268E3O00470001000E0004433O00470001001224000100033O0020730001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00124O00173O00268E3O0073000100180004433O00730001001224000100033O0020980001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O00010001000200062O00010053000100010004433O005300010012C9000100014O0097000100093O00127F000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200062O00010066000100010004433O006600010012C9000100014O00970001000B3O0012B3000100033O00202O0001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O00010001000200062O00010071000100010004433O007100010012C9000100014O00970001000C3O0012C93O00213O00268E3O0099000100010004433O00990001001224000100033O00206B0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300283O00122O000400296O0002000400024O00010001000200062O00010097000100010004433O009700010012C9000100014O0097000100103O0012C93O00183O00268E3O00BC0001000D0004433O00BC0001001224000100033O0020900001000100044O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O0012C90003002C3O00123A0104002D6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400022O00550001000100022O00FB000100133O00122O000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100143O00044O00752O0100268E3O00E2000100170004433O00E20001001224000100033O0020860001000100044O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100153O00122O000100033O00202O0001000100044O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100163O00122O000100033O00202O0001000100044O000200013O00122O000300363O00122O000400376O0002000400024O00010001000200062O000100D8000100010004433O00D800012O0028000100014O0097000100173O001237000100033O00202O0001000100044O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000100183O00124O00023O00268E3O00052O01003A0004433O00052O01001224000100033O0020730001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100193O00122O000100033O00202O0001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O0001001A3O00122O000100033O00202O0001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O0001000100024O0001001B3O00122O000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O0001000100024O0001001C3O00124O000E3O00268E3O00282O0100430004433O00282O01001224000100033O0020730001000100044O000200013O00122O000300443O00122O000400456O0002000400024O0001000100024O0001001D3O00122O000100033O00202O0001000100044O000200013O00122O000300463O00122O000400476O0002000400024O0001000100024O0001001E3O00122O000100033O00202O0001000100044O000200013O00122O000300483O00122O000400496O0002000400024O0001000100024O0001001F3O00122O000100033O00202O0001000100044O000200013O00122O0003004A3O00122O0004004B6O0002000400024O0001000100024O000100203O00124O004C3O00268E3O00512O0100210004433O00512O01001224000100033O0020980001000100044O000200013O00122O0003004D3O00122O0004004E6O0002000400024O00010001000200062O000100342O0100010004433O00342O010012C9000100014O0097000100213O0012B3000100033O00202O0001000100044O000200013O00122O0003004F3O00122O000400506O0002000400024O00010001000200062O0001003F2O0100010004433O003F2O010012C9000100014O0097000100223O001236000100033O00202O0001000100044O000200013O00122O000300513O00122O000400526O0002000400024O0001000100024O000100233O00122O000100033O00202O0001000100042O00D7000200013O001274000300533O00122O000400546O0002000400024O0001000100024O000100243O00124O00433O00268E3O00010001004C0004433O00010001001224000100033O0020730001000100044O000200013O00122O000300553O00122O000400566O0002000400024O0001000100024O000100253O00122O000100033O00202O0001000100044O000200013O00122O000300573O00122O000400586O0002000400024O0001000100024O000100263O00122O000100033O00202O0001000100044O000200013O00122O000300593O00122O0004005A6O0002000400024O0001000100024O000100273O00122O000100033O00202O0001000100044O000200013O00122O0003005B3O00122O0004005C6O0002000400024O0001000100024O000100283O00124O003A3O0004433O000100012O00193O00017O00183O0003143O00412O7461636B506F77657244616D6167654D6F6402BA490C022B87C63F02008FC2F5285CF33F030C3O004E696768747374616C6B6572030B3O004973417661696C61626C6503093O00537465616C746855700248E17A14AE47F13F026O00F03F030F3O00442O6570657253747261746167656D02005OCCF03F030A3O004461726B536861646F7703063O0042752O665570030F3O00536861646F7744616E636542752O660200CD4OCCF43F030E3O0053796D626F6C736F6644656174680200984O99F13F03163O0046696E616C6974794576697363657261746542752O6602CD5OCCF43F030A3O004D617374657279506374026O00594003113O00566572736174696C697479446D6750637403083O00446562752O66557003123O0046696E645765616B6E652O73446562752O66026O00F83F00684O00927O00206O00016O000200024O000100019O00000100206O000200206O00034O000100023O00202O00010001000400202O0001000100054O00010002000200062O0001001700013O0004433O001700012O00D700015O0020B60001000100064O000300016O00048O00010004000200062O0001001700013O0004433O001700010012C9000100073O0006C100010018000100010004433O001800010012C9000100084O002C5O00012O00C5000100023O00202O00010001000900202O0001000100054O00010002000200062O0001002200013O0004433O002200010012C90001000A3O0006C100010023000100010004433O002300010012C9000100084O002C5O00012O00C5000100023O00202O00010001000B00202O0001000100054O00010002000200062O0001003400013O0004433O003400012O00D700015O0020ED00010001000C4O000300023O00202O00030003000D4O00010003000200062O0001003400013O0004433O003400010012C90001000E3O0006C100010035000100010004433O003500010012C9000100084O002C5O00012O00EB00015O00202O00010001000C4O000300023O00202O00030003000F4O00010003000200062O0001004000013O0004433O004000010012C9000100103O0006C100010041000100010004433O004100010012C9000100084O002C5O00012O00EB00015O00202O00010001000C4O000300023O00202O0003000300114O00010003000200062O0001004C00013O0004433O004C00010012C9000100123O0006C10001004D000100010004433O004D00010012C9000100084O002C5O00012O003200015O00202O0001000100134O00010002000200202O00010001001400102O0001000800018O00014O00015O00202O0001000100154O00010002000200202O00010001001400100C0001000800012O002C5O00012O00EB000100033O00202O0001000100164O000300023O00202O0003000300174O00010003000200062O0001006400013O0004433O006400010012C9000100183O0006C100010065000100010004433O006500010012C9000100084O002C5O00012O00043O00024O00193O00017O00043O0003063O0042752O66557003133O0046696E616C6974795275707475726542752O66026OCCF43F026O00F03F000D4O00EB7O00206O00014O000200013O00202O0002000200026O0002000200064O000A00013O0004433O000A00010012C93O00033O0006C13O000B000100010004433O000B00010012C93O00044O00043O00024O00193O00019O002O0001054O00D700015O0006C100010004000100010004433O000400012O00978O00193O00017O00063O0003193O003CDBC2D9E5D400D091BBE4C807958BF5AAE306DB85FEE5C90003063O00A773B5E29B8A030F3O004973496E44756E67656F6E4172656103063O00C32EF05D2O6203073O00A68242873C1B11030C3O004973496E426F2O734C69737400214O00999O00000100013O00122O000200013O00122O000300026O00010003000200064O000F000100010004433O000F00012O00D73O00023O0020135O00032O001D3O000200020006253O000F00013O0004433O000F00012O00288O00043O00023O0004433O002000012O00D78O00D6000100013O00122O000200043O00122O000300056O00010003000200064O001E000100010004433O001E00012O00D73O00033O0020135O00062O001D3O000200020006C13O001E000100010004433O001E00012O00288O00043O00023O0004433O002000012O00283O00014O00043O00024O00193O00017O00123O00028O00027O004003063O006546D974295703053O0050242AAE1503093O00611E77584103247F5D03043O001A2E7057030C3O004973496E426F2O734C69737403043O009836BF7B03083O00D4D943CB142ODF2503123O00496E7374616E636544692O666963756C7479026O00304003053O004E50434944024O00B8F60041024O00C8610441024O00D8610441024O00D0610441024O0038650641024O00B86B064100583O0012C93O00013O00268E3O0001000100010004433O000100012O00D700015O0026E500010009000100020004433O000900012O002800016O0004000100023O0004433O005400012O00D7000100014O00DB000200023O00122O000300033O00122O000400046O00020004000200062O00010013000100020004433O001300012O0028000100014O0004000100023O0004433O005400012O00D7000100014O00DB000200023O00122O000300053O00122O000400066O00020004000200062O00010022000100020004433O002200012O00D7000100033O0020130001000100072O001D0001000200020006250001002200013O0004433O002200012O0028000100014O0004000100023O0004433O005400012O00D7000100014O00DB000200023O00122O000300083O00122O000400096O00020004000200062O00010054000100020004433O005400012O00D7000100043O00201300010001000A2O001D00010002000200268E000100360001000B0004433O003600012O00D7000100033O00201300010001000C2O001D00010002000200268E000100360001000D0004433O003600012O0028000100014O0004000100023O0004433O005400012O00D7000100033O00201300010001000C2O001D000100020002002667000100450001000E0004433O004500012O00D7000100033O00201300010001000C2O001D000100020002002667000100450001000F0004433O004500012O00D7000100033O00201300010001000C2O001D00010002000200268E00010048000100100004433O004800012O0028000100014O0004000100023O0004433O005400012O00D7000100033O00201300010001000C2O001D00010002000200266700010052000100110004433O005200012O00D7000100033O00201300010001000C2O001D00010002000200268E00010054000100120004433O005400012O0028000100014O0004000100024O002800016O0004000100023O0004433O000100012O00193O00017O000B3O00028O0003043O0047554944026O00F03F03103O00556E697449734379636C6556616C6964030D3O00446562752O6652656D61696E7303093O0054696D65546F44696503063O0045786973747303103O00BE82BC92A99DADDEB6CDBCD3A88AADC603043O00B2DAEDC803133O00B2BAF2902OA5E3DCBAF5EBDFA3A6E3DFA0B0F403043O00B0D6D58605673O0012C9000500014O0015000600083O00268E0005000C000100010004433O000C00012O0015000900094O003F000700026O000600096O00095O00202O0009000900024O0009000200024O000800093O00122O000500033O000E1501030002000100050004433O000200012O00D7000900014O0044000A00034O006300090002000B0004433O002B0001002013000E000D00022O001D000E000200020006C0000E002B000100080004433O002B00012O00D7000E00023O00201C000E000E00044O000F000D6O001000073O00202O0011000D00054O00138O0011001300024O001100116O000E0011000200062O000E002B00013O0004433O002B00012O0044000E00014O0044000F000D4O001D000E00020002000625000E002B00013O0004433O002B00012O0044000E000D3O002013000F000D00062O001D000F000200022O00440007000F4O00440006000E3O0006EA00090012000100020004433O001200010006250006004900013O0004433O004900012O00D700095O0006250009004900013O0004433O004900012O00D700095O0020130009000900072O001D0009000200020006250009004900013O0004433O004900010020130009000600022O006F0009000200024O000A5O00202O000A000A00024O000A0002000200062O000900490001000A0004433O004900012O00D7000900034O0044000A6O001D0009000200020006250009006600013O0004433O006600012O00D7000900043O00123D000A00083O00122O000B00096O0009000B6O00095O00044O006600010006250006006600013O0004433O006600012O00D7000900053O0006250009006600013O0004433O006600012O00D7000900053O0020130009000900072O001D0009000200020006250009006600013O0004433O006600010020130009000600022O006F0009000200024O000A00053O00202O000A000A00024O000A0002000200062O000900660001000A0004433O006600012O00D7000900034O0044000A00044O001D0009000200020006250009006600013O0004433O006600012O00D7000900043O00123D000A000A3O00122O000B000B6O0009000B6O00095O00044O006600010004433O000200012O00193O00017O00083O0003053O005669676F72030B3O004973417661696C61626C65026O003440026O003940030F3O004D61737465726F66536861646F7773030B3O00536861646F77466F63757303083O00416C616372697479026O001040002B4O0032019O000100013O00202O00010001000100202O0001000100024O000100029O00000200206O000300104O00046O00018O000200013O00202O00020002000500202O0002000200024O000200036O00013O000200202O0001000100038O00014O00018O000200013O00202O00020002000600202O0002000200024O000200036O00013O000200202O0001000100048O00014O00018O000200013O00202O00020002000700202O0002000200024O000200036O00013O000200202O0001000100038O00014O00018O000200023O000E2O00080025000100020004433O002500012O001700026O0028000200014O003B2O010002000200202O0001000100048O00016O00028O00017O00053O00030B3O00536861646F7744616E636503113O00436861726765734672616374696F6E616C03113O00536861646F7744616E636554616C656E74030B3O004973417661696C61626C65026O00E83F00114O000E7O00206O000100206O00026O000200024O000100016O00025O00202O00020002000300202O0002000200044O000200036O00013O000200102O00010005000100062O0001000200013O0004433O000E00012O00178O00283O00014O00043O00024O00193O00017O00063O0003083O005365616C46617465030B3O004973417661696C61626C65026O001040030F3O0053687572696B656E546F726E61646F027O0040026O00F03F002C4O00539O00000100016O000200023O00202O00020002000100202O0002000200024O000200036O00013O000200102O00010003000100064O000D000100010004433O000D00012O00283O00014O00043O00023O0004433O002B00012O00D78O0076000100036O000200023O00202O00020002000400202O0002000200024O000200036O00013O000200102O00010005000100102O00010003000100062O0001001E00013O0004433O001E00012O00D73O00043O0006253O002500013O0004433O002500012O00D77O000E540003002500013O0004433O002500012O00D73O00053O00268F3O0022000100060004433O002200012O00178O00283O00014O00043O00023O0004433O002B00012O00D73O00063O00268F3O0029000100060004433O002900012O00178O00283O00014O00043O00024O00193O00017O00033O0003063O0042752O665570030C3O00536C696365616E6444696365030A3O0043504D61785370656E6400114O00497O00206O00014O000200013O00202O0002000200026O0002000200064O000F000100010004433O000F00012O00D73O00024O00D7000100033O0020D50001000100032O002C2O010001000200064E0001000200013O0004433O000E00012O00178O00283O00014O00043O00024O00193O00017O00063O0003063O0042752O665570030A3O0054686973746C65546561026O00F03F03083O00446562752O66557003073O0052757074757265027O0040011D4O00EB00015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O0001000A00013O0004433O000A00012O00D7000100023O0026670001001A000100030004433O001A000100065C0001001B00013O0004433O001B00012O00D7000100023O0026670001001A000100030004433O001A00012O00D7000100033O0020ED0001000100044O000300013O00202O0003000300054O00010003000200062O0001001B00013O0004433O001B00012O00D7000100023O000EDD0006001A000100010004433O001A00012O001700016O0028000100014O0004000100024O00193O00017O00053O0003063O0042752O665570030D3O005072656D656469746174696F6E026O00F03F03093O00546865526F2O74656E030B3O004973417661696C61626C6500174O00497O00206O00014O000200013O00202O0002000200026O0002000200064O000A000100010004433O000A00012O00D73O00023O0026673O0014000100030004433O001400012O00D73O00013O0020D55O00040020135O00052O001D3O000200020006253O001400013O0004433O001400012O00D73O00023O000E9E0003001400013O0004433O001400012O00178O00283O00014O00043O00024O00193O00017O00083O0003083O0042752O66446F776E03113O005072656D656469746174696F6E42752O66026O00F03F027O004003063O0042752O665570030D3O00546865526F2O74656E42752O6603073O0048617354696572026O003E40001F4O00497O00206O00014O000200013O00202O0002000200026O0002000200064O001D000100010004433O001D00012O00D73O00023O000E9E0003001C00013O0004433O001C00012O00D73O00033O00269B3O001B000100040004433O001B00012O00D77O0020ED5O00054O000200013O00202O0002000200066O0002000200064O001D00013O0004433O001D00012O00D77O0020065O000700122O000200083O00122O000300048O000300029O0000044O001D00012O00178O00283O00014O00043O00024O00193O00017O00063O0003093O0042752O66537461636B03103O0044616E73654D61636162726542752O66026O000840030C3O0044616E73654D616361627265030B3O004973417661696C61626C65027O004002183O00065C0002001600013O0004433O001600012O00D700025O0020D00002000200014O000400013O00202O0004000400024O000200040002000E2O0003000F000100020004433O000F00012O00D7000200013O0020D50002000200040020130002000200052O001D0002000200020006C100020014000100010004433O001400010006250001001500013O0004433O001500012O00D7000200023O00268E00020015000100060004433O001500012O001700026O0028000200014O0004000200024O00193O00017O00043O0003063O0042752O665570030F3O00536861646F7744616E636542752O6603113O0054696D6553696E63654C61737443617374030B3O00536861646F7744616E636501134O00EB00015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O0001001100013O0004433O0011000100201300013O00032O00010001000200024O000200013O00202O00020002000400202O0002000200034O00020002000200062O00010010000100020004433O001000012O001700016O0028000100014O0004000100024O00193O00017O00443O00028O00027O004003073O0052757074757265030A3O0049734361737461626C6503113O00446562752O665265667265736861626C6503113O0046696C746572656454696D65546F44696503013O003E026O001840030D3O00446562752O6652656D61696E7303133O0054696D65546F44696549734E6F7456616C6964030A3O0043616E446F54556E697403073O004973526561647903043O0043617374030E3O00D7ACA5C0E8644CE4B9A3C6AD160803073O003994CDD6B4C836026O00F03F03063O0042752O66557003133O0046696E616C6974795275707475726542752O6603083O004461726B42726577030B3O004973417661696C61626C65030C3O0044616E73654D616361627265030B3O00536861646F7744616E6365030F3O00432O6F6C646F776E52656D61696E73026O00284003113O00436861726765734672616374696F6E616C03173O0031FC26203620E825206300F8757C501BF334387F06E47C03053O0016729D555403093O00436F6C64426C2O6F64030F3O00536563726574546563686E69717565030F3O00E7CA00D01DD5A7C8CF53E651F9A7C003073O00C8A4AB73A43D9603153O009DF51051C38DF1005786AAB4374080B6FA0A5496BB03053O00E3DE946325026O00084003103O00527570747572654D6F7573656F766572030E3O0053796D626F6C736F664465617468026O002040026O001440030E3O00105341E2B9014742E2EC215712A403053O0099532O3296030B3O00426C61636B506F7764657203113O007E7760083389415C75785C43A45A59736103073O002D3D16137C13CB030A3O0045766973636572617465030F3O00E2131EE14255AFC8010EF01071ADC403073O00D9A1726D956210030F3O00536861646F7744616E636542752O66030B3O0042752O6652656D61696E7303113O005072656D656469746174696F6E42752O66030D3O005072656D656469746174696F6E03023O00494403133O00496D70726F766564536861646F7744616E6365030A3O0054616C656E7452616E6B030D3O00546865466972737444616E6365030E3O00436F6D626F506F696E74734D6178026O00104003073O0048617354696572026O003E40030C3O00536C696365616E644469636503143O0046696C7465726564466967687452656D61696E73026O00FC3F03073O0043686172676573026O33F33F031C3O0031212B68FC471E293B79FC751C247858B5771760704CAE711F253C3503063O00147240581CDC0200CD4OCCFC3F03133O001200C1A0B8E3B13802D7F4F9DEB97125DBB7FD03073O00DD5161B2D498B002AB022O0012C9000200014O0015000300083O000E15010200FE000100020004433O00FE00010006250008000900013O0004433O000900012O00D700095O0006250009005600013O0004433O005600012O00D7000900013O0020D50009000900030020130009000900042O001D0009000200020006250009005600013O0004433O005600012O00D7000900023O00204D0009000900054O000B00013O00202O000B000B00034O000C00036O0009000C000200062O0009005600013O0004433O005600012O00D7000900043O000E332O010056000100090004433O005600012O00D7000900053O0006250009005600013O0004433O005600012O00D7000900023O00208300090009000600122O000B00073O00122O000C00086O000D00023O00202O000D000D00094O000F00013O00202O000F000F00034O000D000F00024O000D000D6O0009000D000200062O0009002F000100010004433O002F00012O00D7000900023O00201300090009000A2O001D0009000200020006250009005600013O0004433O005600012O00D7000900063O0020F100090009000B4O000A00026O000B00076O0009000B000200062O0009005600013O0004433O005600012O00D7000900023O00204D0009000900054O000B00013O00202O000B000B00034O000C00036O0009000C000200062O0009005600013O0004433O005600010006253O004400013O0004433O004400012O00D7000900013O0020D50009000900032O0004000900023O0004433O005600012O00D7000900013O0020D500090009000300201300090009000C2O001D0009000200020006250009005600013O0004433O005600012O00D7000900083O00209C00090009000D4O000A00013O00202O000A000A00034O00090002000200062O0009005600013O0004433O005600012O00D7000900093O0012C9000A000E3O0012C9000B000F4O006C0009000B4O00AF00095O0006C10008009B000100010004433O009B00012O00D7000900013O0020D50009000900030020130009000900042O001D0009000200020006250009009B00013O0004433O009B00012O00D7000900043O000E332O01009B000100090004433O009B00012O00D70009000A3O00268E0009009B000100100004433O009B00012O00D70009000B3O0020ED0009000900114O000B00013O00202O000B000B00124O0009000B000200062O0009009B00013O0004433O009B00012O00D7000900013O0020D50009000900130020130009000900142O001D0009000200020006C100090077000100010004433O007700012O00D7000900013O0020D50009000900150020130009000900142O001D0009000200020006250009009B00013O0004433O009B00012O00D7000900013O0020D50009000900160020130009000900172O001D0009000200020026E50009009B000100180004433O009B00012O00D7000900013O0020D50009000900160020130009000900192O001D00090002000200269B0009009B000100100004433O009B00010006253O008900013O0004433O008900012O00D7000900013O0020D50009000900032O0004000900023O0004433O009B00012O00D7000900013O0020D500090009000300201300090009000C2O001D0009000200020006250009009B00013O0004433O009B00012O00D7000900083O00209C00090009000D4O000A00013O00202O000A000A00034O00090002000200062O0009009B00013O0004433O009B00012O00D7000900093O0012C9000A001A3O0012C9000B001B4O006C0009000B4O00AF00096O00D7000900013O0020D500090009001C00201300090009000C2O001D000900020002000625000900C200013O0004433O00C200012O00D70009000C4O0044000A00034O0044000B00074O00AA0009000B0002000625000900C200013O0004433O00C200012O00D7000900013O0020D500090009001D00201300090009000C2O001D000900020002000625000900C200013O0004433O00C200010012C9000900013O00268E000900AE000100010004433O00AE00010006253O00B500013O0004433O00B500012O00D7000A000D3O0020D5000A000A001D2O0004000A00024O00D7000A000E4O00D7000B000D3O0020D5000B000B001D2O001D000A00020002000625000A00C200013O0004433O00C200012O00D7000A00093O00123D000B001E3O00122O000C001F6O000A000C6O000A5O00044O00C200010004433O00AE00012O00D7000900013O0020D500090009001D00201300090009000C2O001D000900020002000625000900FD00013O0004433O00FD00012O00D70009000C4O0044000A00034O0044000B00074O00AA0009000B0002000625000900FD00013O0004433O00FD00012O00D7000900013O0020D500090009001C0020130009000900142O001D000900020002000625000900E800013O0004433O00E800012O00D7000900013O0020D500090009001C00201300090009000C2O001D0009000200020006C1000900E8000100010004433O00E800012O00D70009000B3O0020AD0009000900114O000B00013O00202O000B000B001C4O0009000B000200062O000900E8000100010004433O00E800012O00D7000900013O00203801090009001C00202O0009000900174O00090002000200202O000A0004000200062O000A00FD000100090004433O00FD00010012C9000900013O00268E000900E9000100010004433O00E900010006253O00F000013O0004433O00F000012O00D7000A000D3O0020D5000A000A001D2O0004000A00024O00D7000A000E4O00D7000B000D3O0020D5000B000B001D2O001D000A00020002000625000A00FD00013O0004433O00FD00012O00D7000A00093O00123D000B00203O00122O000C00216O000A000C6O000A5O00044O00FD00010004433O00E900010012C9000200223O00268E000200D82O0100220004433O00D82O010006C10008007F2O0100010004433O007F2O012O00D7000900013O0020D50009000900030020130009000900042O001D0009000200020006250009007F2O013O0004433O007F2O010012C9000900013O00268E000900092O0100010004433O00092O010006C13O00342O0100010004433O00342O012O00D7000A000F3O000625000A00342O013O0004433O00342O012O00D7000A5O0006C1000A00342O0100010004433O00342O012O00D7000A000A3O000E54000200342O01000A0004433O00342O010012C9000A00014O0015000B000B3O00268E000A00212O0100010004433O00212O012O0015000B000B3O002O06010B3O000100042O00D73O00104O00D73O00074O00D73O00014O00D73O00033O0012C9000A00103O00268E000A00182O0100100004433O00182O012O00D7000C00124O00C2000D00013O00202O000D000D00034O000E000B3O00102O000F000200064O001000136O0011000D3O00202O0011001100234O000C001100024O000C00116O000C00113O000625000C00342O013O0004433O00342O012O00D7000C00114O0004000C00023O0004433O00342O010004433O00182O012O00D7000A00053O000625000A007F2O013O0004433O007F2O012O00D7000A00023O0020B5000A000A00094O000C00013O00202O000C000C00034O000A000C00024O000B00013O00202O000B000B002400202O000B000B00174O000B0002000200202O000B000B002500202O000B000B000200062O000A007F2O01000B0004433O007F2O012O00D7000A00043O000E332O01007F2O01000A0004433O007F2O012O00D7000A00013O0020D5000A000A0024002013000A000A00172O001D000A0002000200269B000A007F2O0100260004433O007F2O012O00D7000A00063O0020F1000A000A000B4O000B00026O000C00076O000A000C000200062O000A007F2O013O0004433O007F2O012O00D7000A00023O002087000A000A000600122O000C00076O000D00013O00202O000D000D002400202O000D000D00174O000D0002000200102O000D0026000D4O000E00023O00202O000E000E00094O001000013O00202O0010001000034O000E001000024O000E000E6O000A000E000200062O000A007F2O013O0004433O007F2O010006253O006B2O013O0004433O006B2O012O00D7000A00013O0020D5000A000A00032O0004000A00023O0004433O007F2O012O00D7000A00013O0020D5000A000A0003002013000A000A000C2O001D000A00020002000625000A007F2O013O0004433O007F2O012O00D7000A00083O00209C000A000A000D4O000B00013O00202O000B000B00034O000A0002000200062O000A007F2O013O0004433O007F2O012O00D7000A00093O00123D000B00273O00122O000C00286O000A000C6O000A5O00044O007F2O010004433O00092O012O00D7000900013O0020D50009000900290020130009000900042O001D000900020002000625000900B32O013O0004433O00B32O012O00D700095O0006C10009008B2O0100010004433O008B2O012O00D70009000A3O000EDD0022009C2O0100090004433O009C2O012O00D70009000A3O00268E000900B32O0100020004433O00B32O01000625000300B32O013O0004433O00B32O012O00D7000900013O0020D50009000900150020130009000900142O001D000900020002000625000900B32O013O0004433O00B32O012O00D7000900144O00D7000A00013O0020D5000A000A00292O001D0009000200020006C1000900B32O0100010004433O00B32O010006253O00A22O013O0004433O00A22O012O00D7000900013O0020D50009000900292O0004000900023O0004433O00B32O012O00D7000900013O0020D500090009002900201300090009000C2O001D000900020002000625000900B32O013O0004433O00B32O012O00D70009000E4O00D7000A00013O0020D5000A000A00292O001D000900020002000625000900B32O013O0004433O00B32O012O00D7000900093O0012C9000A002A3O0012C9000B002B4O006C0009000B4O00AF00096O00D7000900013O0020D500090009002C0020130009000900042O001D000900020002000625000900D62O013O0004433O00D62O012O00D7000900053O000625000900D62O013O0004433O00D62O012O00D7000900043O000E33011000D62O0100090004433O00D62O010006253O00C52O013O0004433O00C52O012O00D7000900013O0020D500090009002C2O0004000900023O0004433O00D62O012O00D7000900013O0020D500090009002C00201300090009000C2O001D000900020002000625000900D62O013O0004433O00D62O012O00D70009000E4O00D7000A00013O0020D5000A000A002C2O001D000900020002000625000900D62O013O0004433O00D62O012O00D7000900093O0012C9000A002D3O0012C9000B002E4O006C0009000B4O00AF00096O002800096O0004000900023O00268E000200EE2O0100010004433O00EE2O012O00D70009000B3O0020A60009000900114O000B00013O00202O000B000B002F4O0009000B00024O000300094O00D70009000B3O0020A60009000900304O000B00013O00202O000B000B002F4O0009000B00024O000400094O00D70009000B3O0020A60009000900304O000B00013O00202O000B000B00244O0009000B00024O000500094O00D7000600043O0012C9000200103O00268E00020002000100100004433O000200012O00D70009000B3O0020140009000900114O000B00013O00202O000B000B00314O0009000B000200062O000700FE2O0100090004433O00FE2O0100065C000700FE2O0100010004433O00FE2O012O00D7000900013O0020D50009000900320020130009000900142O001D0009000200022O0044000700093O0006250001003002013O0004433O003002010020130009000100332O00930009000200024O000A00013O00202O000A000A001600202O000A000A00334O000A0002000200062O000900300201000A0004433O003002010012C9000900013O00268E00090012020100010004433O001202012O0028000300014O0039010A00013O00202O000A000A003400202O000A000A00354O000A0002000200102O00040025000A00122O000900103O00268E00090009020100100004433O000902012O00D7000A00013O0020D5000A000A0036002013000A000A00142O001D000A00020002000625000A002202013O0004433O002202012O00D7000A00154O0014010B000B3O00202O000B000B00374O000B000200024O000C00043O00202O000C000C00384O000A000C00024O0006000A4O00D7000A000B3O0020EF000A000A003900122O000C003A3O00122O000D00026O000A000D000200062O000A003002013O0004433O003002012O00D7000A00164O004F000B00053O00122O000C00086O000A000C00024O0005000A3O00044O003002010004433O000902012O00D7000900013O0020D500090009003B0020130009000900042O001D000900020002000625000900A402013O0004433O00A402012O00D7000900083O0020CE00090009003C4O000A00173O00122O000B00076O000C000B3O00202O000C000C00304O000E00013O00202O000E000E003B4O000C000E6O00093O000200062O000900A402013O0004433O00A402012O00D7000900013O0020D50009000900320020130009000900142O001D0009000200020006250009007E02013O0004433O007E02012O00D70009000A3O0026E50009007E020100260004433O007E02012O00D7000900013O0020D50009000900160020130009000900192O001D0009000200020026E5000900A40201003D0004433O00A402012O00D70009000B3O0020DA0009000900304O000B00013O00202O000B000B003B4O0009000B00024O000A00013O00202O000A000A002400202O000A000A00174O000A0002000200062O000900A40201000A0004433O00A402012O00D7000900013O0020D500090009001600201300090009003E2O001D000900020002000E54001000A4020100090004433O00A402012O000E0109000500040026E5000900A40201003F0004433O00A402010006253O006B02013O0004433O006B02012O00D7000900013O0020D500090009003B2O0004000900023O0004433O00A402012O00D7000900013O0020D500090009003B00201300090009000C2O001D000900020002000625000900A402013O0004433O00A402012O00D7000900083O00209C00090009000D4O000A00013O00202O000A000A003B4O00090002000200062O000900A402013O0004433O00A402012O00D7000900093O00123D000A00403O00122O000B00416O0009000B6O00095O00044O00A402012O00D70009000A3O0026E5000900A4020100080004433O00A402010006C1000300A4020100010004433O00A402012O00D70009000B3O0020380009000900304O000B00013O00202O000B000B003B4O0009000B000200202O000A0006004200102O000A0010000A00062O000900A40201000A0004433O00A402010006253O009202013O0004433O009202012O00D7000900013O0020D500090009003B2O0004000900023O0004433O00A402012O00D7000900013O0020D500090009003B00201300090009000C2O001D000900020002000625000900A402013O0004433O00A402012O00D7000900083O00209C00090009000D4O000A00013O00202O000A000A003B4O00090002000200062O000900A402013O0004433O00A402012O00D7000900093O0012C9000A00433O0012C9000B00444O006C0009000B4O00AF00096O00D7000900184O00AE000A00036O0009000200024O000800093O00122O000200023O00044O000200012O00193O00013O00013O00033O00030A3O0043616E446F54556E697403113O00446562752O665265667265736861626C6503073O0052757074757265010E4O00BF00015O00202O0001000100014O00028O000300016O00010003000200062O0001000C00013O0004433O000C000100201300013O00022O00D7000300023O0020D50003000300032O00D7000400034O00AA0001000400022O0004000100024O00193O00017O003B3O00028O00026O001C4003093O0042752O66537461636B03133O00506572666F72617465645665696E7342752O66026O001440026O000840030A3O00476C2O6F6D626C616465030A3O0049734361737461626C65030F3O00506572666F72617465645665696E7303083O004261636B7374616203093O00537465616C7468557003063O0042752O665570030A3O0053657073697342752O66026O001040030C3O00536861646F77737472696B65030D3O0053687572696B656E53746F726D026O002040026O00F03F03113O005072656D656469746174696F6E42752O66030D3O005072656D656469746174696F6E030B3O004973417661696C61626C65030F3O0053696C656E7453746F726D42752O66030B3O0053696C656E7453746F726D027O0040030D3O00446562752O6652656D61696E7303123O0046696E645765616B6E652O73446562752O66030E3O0053796D626F6C736F664465617468030F3O00432O6F6C646F776E52656D61696E73026O00324003073O00537465616C7468030C3O0044616E73654D61636162726503103O0044616E73654D61636162726542752O66030A3O0043504D61785370656E64026O001840030F3O00536861646F7744616E636542752O66030B3O0042752O6652656D61696E73030D3O00546865526F2O74656E42752O66030F3O004C696E676572696E67536861646F77030A3O00446562752O66446F776E03153O00496D70726F76656453687572696B656E53746F726D030F3O0053687572696B656E546F726E61646F03083O005365616C46617465030F3O00442O6570657253747261746167656D030F3O0053656372657453747261746167656D03143O00452O66656374697665436F6D626F506F696E747303093O004973496E52616E6765026O003940030C3O00537465616C74685370652O6C03023O004944030F3O0056616E69736842752O665370652O6C03063O0056616E697368030B3O00536861646F7744616E636503133O00496D70726F766564536861646F7744616E6365030A3O0054616C656E7452616E6B03093O00546865526F2O74656E03073O0048617354696572026O003E40030D3O00546865466972737444616E6365030E3O00436F6D626F506F696E74734D61780259022O0012C9000200014O00150003000E3O00268E00020071000100020004433O007100012O00D7000F5O002024010F000F00034O001100013O00202O0011001100044O000F00110002000E2O000500390001000F0004433O003900012O00D7000F00023O0026E5000F0039000100060004433O003900012O00D7000F00013O0020D5000F000F0007002013000F000F00082O001D000F00020002000625000F002400013O0004433O002400010006253O003900013O0004433O003900010006250001001C00013O0004433O001C00012O00D7000F00013O0020D5000F000F00072O0004000F00023O0004433O003900012O0064000F00024O00D2001000013O00202O0010001000074O001100013O00202O0011001100094O000F000200012O0004000F00023O0004433O003900012O00D7000F00013O0020D5000F000F000A002013000F000F00082O001D000F00020002000625000F003900013O0004433O003900010006253O003900013O0004433O003900010006250001003200013O0004433O003200012O00D7000F00013O0020D5000F000F000A2O0004000F00023O0004433O003900012O0064000F00024O00D2001000013O00202O00100010000A4O001100013O00202O0011001100094O000F000200012O0004000F00023O000625000D005300013O0004433O005300012O00D7000F5O0020D1000F000F000B4O001100016O00128O000F0012000200062O000F0053000100010004433O005300010006C100010053000100010004433O005300012O00D7000F5O0020ED000F000F000C4O001100013O00202O00110011000D4O000F0011000200062O000F005300013O0004433O005300012O00D7000F00023O0026E5000F00530001000E0004433O005300010006253O005300013O0004433O005300012O00D7000F00013O0020D5000F000F000F2O0004000F00024O00D7000F00033O000625000F007000013O0004433O007000012O00D7000F00013O0020D5000F000F0010002013000F000F00082O001D000F00020002000625000F007000013O0004433O007000012O00D7000F00024O0021001000046O001100056O00100002000200102O00100006001000062O001000700001000F0004433O007000010006250008006B00013O0004433O006B00012O00D7000F00023O000E54000200700001000F0004433O007000012O00D7000F00053O0006C1000F0070000100010004433O007000010006253O007000013O0004433O007000012O00D7000F00013O0020D5000F000F00102O0004000F00023O0012C9000200113O000E1501120093000100020004433O009300012O00D7000F00064O004A000700076O0006000F6O000F5O00202O000F000F000C4O001100013O00202O0011001100134O000F0011000200062O000800840001000F0004433O0084000100065C00080084000100010004433O008400012O00D7000F00013O0020D5000F000F0014002013000F000F00152O001D000F000200022O00440008000F4O00D7000F5O002014000F000F000C4O001100013O00202O0011001100164O000F0011000200062O000900920001000F0004433O0092000100065C00090092000100010004433O009200012O00D7000F00013O0020D5000F000F0017002013000F000F00152O001D000F000200022O00440009000F3O0012C9000200183O00268E000200BD000100110004433O00BD0001000625000D00B400013O0004433O00B400012O00D7000F00083O0020F5000F000F00194O001100013O00202O00110011001A4O000F0011000200262O000F00AF000100120004433O00AF00012O00D7000F00013O0020D5000F000F001B002013000F000F001C2O001D000F000200020026E5000F00B40001001D0004433O00B400012O00D7000F00083O0020DA000F000F00194O001100013O00202O00110011001A4O000F001100024O001000013O00202O00100010001B00202O00100010001C4O00100002000200062O000F00B4000100100004433O00B400010006253O00B400013O0004433O00B400012O00D7000F00013O0020D5000F000F000F2O0004000F00023O000625000D00BB00013O0004433O00BB00010006253O00BB00013O0004433O00BB00012O00D7000F00013O0020D5000F000F000F2O0004000F00024O0028000F6O0004000F00023O00268E0002001E2O0100050004433O001E2O012O00D7000F00013O0020D5000F000F0007002013000F000F00082O001D000F00020002000625000F00E600013O0004433O00E60001000625000E00D000013O0004433O00D000012O00D7000F00094O00D7001000013O0020D50010001000072O001D000F00020002000625000F00D700013O0004433O00D700012O00D7000F00023O00268E000F00D7000100180004433O00D7000100269B000600E6000100180004433O00E60001000625000500E600013O0004433O00E600012O00D7000F00023O00269B000F00E6000100060004433O00E600010006253O00E600013O0004433O00E60001000625000100DF00013O0004433O00DF00012O00D7000F00013O0020D5000F000F00072O0004000F00023O0004433O00E600012O0064000F00024O00D2001000013O00202O0010001000074O001100013O00202O00110011001E4O000F000200012O0004000F00024O00D7000F00013O0020D5000F000F000A002013000F000F00082O001D000F00020002000625000F00132O013O0004433O00132O01000625000E00132O013O0004433O00132O012O00D7000F00013O0020D5000F000F001F002013000F000F00152O001D000F00020002000625000F00132O013O0004433O00132O012O00D7000F00094O00D7001000013O0020D500100010000A2O001D000F000200020006C1000F00132O0100010004433O00132O012O00D7000F5O002079000F000F00034O001100013O00202O0011001100204O000F0011000200262O000F00132O0100180004433O00132O012O00D7000F00023O00269B000F00132O0100180004433O00132O010006253O00132O013O0004433O00132O010006250001000C2O013O0004433O000C2O012O00D7000F00013O0020D5000F000F000A2O0004000F00023O0004433O00132O012O0064000F00024O00D2001000013O00202O00100010000A4O001100013O00202O00110011001E4O000F000200012O0004000F00024O00D7000F000A3O0020D5000F000F00212O002C010F0001000200064B000F001D2O01000C0004433O001D2O012O00D7000F000B4O004400106O0044001100014O006C000F00114O00AF000F5O0012C9000200223O00268E000200332O0100010004433O00332O012O00D7000F5O002002010F000F000C4O001100013O00202O0011001100234O000F001100024O0003000F6O000F5O00202O000F000F00244O001100013O00202O0011001100234O000F001100024O0004000F6O000F5O00202O000F000F000C4O001100013O00202O0011001100254O000F001100024O0005000F3O00122O000200123O00268E000200882O01000E0004433O00882O01000625000D00462O013O0004433O00462O010006C1000A003B2O0100010004433O003B2O01000625000B00462O013O0004433O00462O012O00D7000F00023O0026E6000F00412O01000E0004433O00412O012O00D7000F00053O000625000F00462O013O0004433O00462O010006253O00462O013O0004433O00462O012O00D7000F00013O0020D5000F000F000F2O0004000F00024O00D7000F5O00205F000F000F00034O001100013O00202O0011001100204O000F0011000200262O000F005E2O0100050004433O005E2O01002667000700512O0100180004433O00512O0100268E0007005E2O0100060004433O005E2O010006C1000800552O0100010004433O00552O010026E5000C005E2O0100020004433O005E2O012O00D7000F00023O00268F000F005F2O0100110004433O005F2O012O00D7000F00013O00203C000F000F002600202O000F000F00154O000F000200024O000E000F3O00044O00602O012O0017000E6O0028000E00013O000625000E00712O013O0004433O00712O01000625000900712O013O0004433O00712O012O00D7000F00083O0020ED000F000F00274O001100013O00202O00110011001A4O000F0011000200062O000F00712O013O0004433O00712O012O00D7000F00013O0020D5000F000F0028002013000F000F00152O001D000F000200020006C1000F00822O0100010004433O00822O012O00D7000F00013O0020D5000F000F001F002013000F000F00152O001D000F00020002000625000F00872O013O0004433O00872O0100269B000600872O0100120004433O00872O012O00D7000F00023O00268E000F00872O0100180004433O00872O012O00D7000F00094O00D7001000013O0020D50010001000102O001D000F000200020006C1000F00872O0100010004433O00872O010006253O00872O013O0004433O00872O012O00D7000F00013O0020D5000F000F00102O0004000F00023O0012C9000200053O00268E000200C42O0100220004433O00C42O012O00D7000F5O0020ED000F000F000C4O001100013O00202O0011001100294O000F0011000200062O000F00982O013O0004433O00982O0100269B000700982O0100180004433O00982O012O00D7000F000B4O004400106O0044001100014O006C000F00114O00AF000F6O00D7000F00024O0011011000046O001100013O00202O00110011002A00202O0011001100154O001100126O00103O000200102O0010000E001000062O001000A92O01000F0004433O00A92O01000E54000E00A92O01000C0004433O00A92O012O00D7000F000B4O004400106O0044001100014O006C000F00114O00AF000F6O00D7000F000C4O0075001000013O00202O00100010002A00202O0010001000154O00100002000200062O001000BA2O0100010004433O00BA2O012O00D7001000013O0020D500100010002B0020130010001000152O001D0010000200020006C1001000BA2O0100010004433O00BA2O012O00D7001000013O0020D500100010002C0020130010001000152O001D0010000200022O001D000F0002000200100C000F0012000F00064B000700C32O01000F0004433O00C32O012O00D7000F000B4O004400106O0044001100014O006C000F00114O00AF000F5O0012C9000200023O000E15010600ED2O0100020004433O00ED2O012O00D7000F000A3O00208B000F000F002D4O001000066O000F000200024O000C000F6O000F00013O00202O000F000F000F00202O000F000F00084O000F0002000200062O000D00DD2O01000F0004433O00DD2O0100060A010D00DD2O01000A0004433O00DD2O0100060A010D00DD2O01000B0004433O00DD2O0100060A010D00DD2O0100030004433O00DD2O012O00D7000F5O0020A6000F000F000C4O001100013O00202O00110011000D4O000F001100024O000D000F3O0006C1000A00E12O0100010004433O00E12O01000625000B00E92O013O0004433O00E92O01000625000D00E82O013O0004433O00E82O012O00D7000F00083O002013000F000F002E0012C90011002F4O00AA000F001100022O0044000D000F3O0004433O00EC2O01000625000D00EC2O013O0004433O00EC2O012O00D7000D000D3O0012C90002000E3O00268E00020002000100180004433O000200012O00D7000F5O002091000F000F000C4O0011000A3O00202O0011001100304O001100016O000F3O000200062O000A00040201000F0004433O0004020100065C000A0004020100010004433O00040201002013000F000100312O0046000F000200024O0010000A3O00202O0010001000304O00100001000200202O0010001000314O00100002000200062O000F0003020100100004433O000302012O0017000A6O0028000A00014O00D7000F5O002091000F000F000C4O0011000A3O00202O0011001100324O001100016O000F3O000200062O000B00180201000F0004433O0018020100065C000B0018020100010004433O00180201002013000F000100312O0002000F000200024O001000013O00202O00100010003300202O0010001000314O00100002000200062O000F0017020100100004433O001702012O0017000B6O0028000B00013O0006250001005602013O0004433O00560201002013000F000100312O0093000F000200024O001000013O00202O00100010003400202O0010001000314O00100002000200062O000F0056020100100004433O005602010012C9000F00013O000E152O01002C0201000F0004433O002C02012O0028000300014O0039011000013O00202O00100010003500202O0010001000364O00100002000200102O00040011001000122O000F00123O000E15011200230201000F0004433O002302012O00D7001000013O0020D50010001000370020130010001000152O001D0010000200020006250010003C02013O0004433O003C02012O00D700105O0020EF00100010003800122O001200393O00122O001300186O00100013000200062O0010003C02013O0004433O003C02012O0028000500014O00D7001000013O0020D500100010003A0020130010001000152O001D0010000200020006250010005602013O0004433O005602010012C9001000013O00268E00100043020100010004433O004302012O00D70011000E4O00BC00125O00202O00120012003B4O0012000200024O001300063O00202O00130013000600202O0013001300124O0011001300024O000600116O00115O00202O00110011003B4O0011000200024O00070011000600044O005602010004433O004302010004433O005602010004433O002302010012C9000200063O0004433O000200012O00193O00017O00153O00028O00027O0040026O00F03F030B3O00536861646F7744616E636503043O004361737403013O007C03063O0056616E69736803023O00D1A703053O007AAD877D9B026O00084003053O00506F77657203073O00B4CE0FB5363FCF03073O00A8E4A160D95F5103023O004944030B3O00F8D03D486F61DADF274F2703063O0037BBB14E3C4F030A3O00536861646F776D656C64030F3O000ECF4CFF06FC882CCA50FC4BCA8C2903073O00E04DAE3F8B26AF03113O00A7404B3AC472502F804E4F6EA040562D8103043O004EE4213802BF3O0012C9000200014O0015000300043O00268E0002003C000100020004433O003C00012O0064000500024O004400066O0044000700034O00050105000200012O0044000400053O0020D50005000400032O00D700065O0020D500060006000400067B00050023000100060004433O002300012O00D7000500013O0006250005002300013O0004433O002300010012C9000500013O00268E00050012000100010004433O001200012O00D7000600033O0020780006000600054O000700043O00202O0007000700044O000800016O0006000800024O000600026O000600023O00062O0006003B00013O0004433O003B00010012C9000600064O0004000600023O0004433O003B00010004433O001200010004433O003B00010020D50005000400032O00D700065O0020D500060006000700067B0005003B000100060004433O003B00010012C9000500013O00268E00050029000100010004433O002900012O00D7000600033O0020260106000600054O00075O00202O0007000700074O0006000200024O000600026O000600023O00062O0006003B00013O0004433O003B00012O00D7000600053O00123D000700083O00122O000800096O000600086O00065O00044O003B00010004433O002900010012C90002000A3O00268E000200400001000A0004433O004000012O002800056O0004000500023O00268E000200B2000100030004433O00B200012O00D7000500063O00201300050005000B2O001D00050002000200068A0005004C000100010004433O004C00012O00D7000500053O0012C90006000C3O0012C90007000D4O006C000500074O00AF00055O00201300053O000E2O00930005000200024O00065O00202O00060006000700202O00060006000E4O00060002000200062O0005006D000100060004433O006D00012O00D7000500073O0006250005005900013O0004433O005900010006C10003006D000100010004433O006D00010012C9000500013O000E152O01005A000100050004433O005A00012O00D7000600033O0020170106000600054O00075O00202O0007000700074O000800016O00060008000200062O0006006900013O0004433O006900012O00D7000600053O0012C90007000F3O0012C9000800104O006C000600084O00AF00066O002800066O0004000600023O0004433O005A00010004433O00B1000100201300053O000E2O00930005000200024O00065O00202O00060006001100202O00060006000E4O00060002000200062O0005008E000100060004433O008E00012O00D7000500083O0006250005007A00013O0004433O007A00010006C10003008E000100010004433O008E00010012C9000500013O00268E0005007B000100010004433O007B00012O00D7000600033O0020170106000600054O00075O00202O0007000700114O000800016O00060008000200062O0006008A00013O0004433O008A00012O00D7000600053O0012C9000700123O0012C9000800134O006C000600084O00AF00066O002800066O0004000600023O0004433O007B00010004433O00B1000100201300053O000E2O00930005000200024O00065O00202O00060006000400202O00060006000E4O00060002000200062O000500B1000100060004433O00B100012O00D7000500093O0006250005009B00013O0004433O009B00010006C1000300B1000100010004433O00B100012O00D7000500013O000625000500B100013O0004433O00B100010012C9000500013O00268E0005009F000100010004433O009F00012O00D7000600033O0020170106000600054O000700043O00202O0007000700044O000800016O00060008000200062O000600AE00013O0004433O00AE00012O00D7000600053O0012C9000700143O0012C9000800154O006C000600084O00AF00066O002800066O0004000600023O0004433O009F00010012C9000200023O000E152O010002000100020004433O000200012O00D70005000A4O00F2000600016O00078O0005000700024O000300053O00062O000100BC000100010004433O00BC00010012C9000100033O0012C9000200033O0004433O000200012O00193O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O0012C93O00013O00268E3O0011000100020004433O001100012O00D7000100013O00200F2O01000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O0004433O002200012O00D700016O0004000100023O0004433O0022000100268E3O0001000100010004433O000100012O00D7000100013O00200F2O01000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O0004433O002000012O00D700016O0004000100023O0012C93O00023O0004433O000100012O00193O00017O006F3O00028O00027O0040030C3O00466C6167652O6C6174696F6E03073O004973526561647903093O00537465616C74685570026O00144003113O0046696C746572656454696D65546F44696503013O003E026O00244003043O004361737403113O00ED7FA117C5E872B30480C272B3178CC17003053O00E5AE1ED263030F3O0053687572696B656E546F726E61646F030A3O0049734361737461626C65026O00F03F030E3O0053796D626F6C736F664465617468030A3O00432O6F6C646F776E5570030B3O00536861646F7744616E636503073O0043686172676573030B3O004973417661696C61626C6503063O0042752O66557003113O005072656D656469746174696F6E42752O6603063O00456E65726779026O004E4003153O0038EC9545AD0E310EFF8F5AE833792FE2945FEC393603073O00597B8DE6318D5D030B3O00536861646F77466F637573030B3O0043617374502O6F6C696E6703193O00C37EF900504CFC63B63F185FE178FD091E0AC77EE402114EFC03063O002A9311966C7003013O0031026O00084003063O0053657073697303013O003C026O003040030B3O002CA73E6BA7DB0AB63E76F403063O00886FC64D1F87030B3O0042752O6652656D61696E7303073O0048617354696572026O003E4003093O00546865526F2O74656E030F3O00432O6F6C646F776E52656D61696E7303153O002108B442FDD70EA40006AB45FDEB11E9260CA642B503083O00C96269C736DD8477030E3O004D61726B6564666F72446561746803153O009A0D90354218ADAB0786254233A3AB4CA7240321A403073O00CCD96CE3416255030A3O0043504D61785370656E64030D3O004361737453752O67657374656403153O007DC2E6F16CED5FD1FEE0288058CCE7A508C55FD7FD03063O00A03EA395854C026O00104003063O0056616E69736803093O0042752O66537461636B03103O0044616E73654D61636162726542752O66030F3O00536563726574546563686E6971756503123O00E0A10326D0DEE0202EC0C4AF4D67E7FBE94D03053O00A3B6C06D4F03093O00436F6C64426C2O6F64030F3O00172713D4B517290CC4B5162A0FCFF103053O0095544660A0030C3O00536861646F77426C61646573030F3O00536861646F7744616E636542752O6603023O00665B03043O008D58666D026O00204003083O00446562752O66557003183O00426F2O7346696C7465726564466967687452656D61696E7303023O00EF0E03083O00A1D333AA107A5D35026O00344003123O00D8AFA13CBB9DBA29FFA1A568D9A2B32CFEBD03043O00489BCED203103O004563686F696E6752657072696D616E6403113O005265736F756E64696E67436C6172697479030C3O0044616E73654D61636162726503163O00657B471A7363795C013A487D143C3656685D0332487E03053O0053261A346E031B3O007B16345218242F534A1E2C43565713494A1926422O576F7557336E03043O0026387747031D3O00D0EE4BC22O65FBFA4ADF2E53FDAF6CD93758F2EB57966D72F2E15BD36C03063O0036938F38B64503023O008ADC03053O00BFB6E19F29031D3O00181A29518490820F1326568EC7EF2A113A5ACBCFEE24056861BFA38B6B03073O00A24B724835EBE7030A3O0054686973746C6554656103163O00456E6572677944656669636974507265646963746564026O00594003123O00436F6D626F506F696E74734465666963697403113O00436861726765734672616374696F6E616C026O00064003023O00D06103063O0062EC5C248233026O001840030B3O00901105A951A4B070901C0D03083O0050C4796CDA25C8D503093O0046697265626C2O6F64030E3O002372116B0B28831276007344018E03073O00EA6013621F2B6E030D3O00416E6365737472616C43612O6C03133O00251E41D3EC5385051A41D3BE7387463C53CBA003073O00EB667F32A7CC1203093O00426C2O6F6446757279030F3O0073A0E637040C5CAEFA27040845B3EC03063O004E30C1954324030A3O004265727365726B696E67030F3O00131F930C01121B920B44221589164603053O0021507EE07803203O00C8A90DC759ACE343F745E1AA0CC84FACE007D14EE5A6048468E3BA0DC558E3E103053O003C8CC863A400BE032O0012C93O00014O0015000100013O00268E3O0092000100020004433O009200012O00D700025O0006250002003000013O0004433O003000012O00D7000200013O0006250002003000013O0004433O003000012O00D7000200023O0020D50002000200030020130002000200042O001D0002000200020006250002003000013O0004433O003000010006250001003000013O0004433O003000012O00D7000200033O0020D10002000200054O00048O00058O00020005000200062O00020030000100010004433O003000012O00D7000200043O000E5400060030000100020004433O003000012O00D7000200053O0020EF00020002000700122O000400083O00122O000500096O00020005000200062O0002003000013O0004433O003000012O00D7000200063O00200401020002000A4O000300023O00202O0003000300034O000400046O00020004000200062O0002003000013O0004433O003000012O00D7000200073O0012C90003000B3O0012C90004000C4O006C000200044O00AF00026O00D7000200023O0020D500020002000D00201300020002000E2O001D0002000200020006250002009100013O0004433O009100012O00D7000200083O00269B000200910001000F0004433O009100010006250001009100013O0004433O009100012O00D7000200023O0020D50002000200100020130002000200112O001D0002000200020006250002009100013O0004433O009100012O00D7000200023O0020D50002000200120020130002000200132O001D000200020002000E54000F0091000100020004433O009100012O00D7000200023O0020D50002000200030020130002000200142O001D0002000200020006250002005700013O0004433O005700012O00D7000200033O0020AD0002000200154O000400023O00202O0004000400034O00020004000200062O00020057000100010004433O005700012O00D7000200083O000E5400060091000100020004433O009100012O00D7000200043O00269B00020091000100020004433O009100012O00D7000200033O0020AD0002000200154O000400023O00202O0004000400164O00020004000200062O00020091000100010004433O009100012O00D7000200033O0020130002000200172O001D000200020002000E5400180073000100020004433O007300012O00D7000200063O00209C00020002000A4O000300023O00202O00030003000D4O00020002000200062O0002009100013O0004433O009100012O00D7000200073O00123D000300193O00122O0004001A6O000200046O00025O00044O009100012O00D7000200023O0020D500020002001B0020130002000200142O001D0002000200020006C100020091000100010004433O009100010012C9000200013O00268E0002007A000100010004433O007A00012O00D7000300063O00209C00030003001C4O000400023O00202O00040004000D4O00030002000200062O0003008800013O0004433O008800012O00D7000300073O0012C90004001D3O0012C90005001E4O006C000300054O00AF00036O00D7000300033O0020130003000300172O001D000300020002000E5400180091000100030004433O009100010012C90003001F4O0004000300023O0004433O009100010004433O007A00010012C93O00203O00268E3O004C2O0100200004433O004C2O012O00D700025O000625000200062O013O0004433O00062O010012C9000200013O00268E00020098000100010004433O009800012O00D7000300013O000625000300BB00013O0004433O00BB00012O00D7000300023O0020D50003000300210020130003000300042O001D000300020002000625000300BB00013O0004433O00BB0001000625000100BB00013O0004433O00BB00012O00D7000300093O000E54000F00BB000100030004433O00BB00012O00D7000300053O0020E300030003000700122O000500223O00122O000600236O00030006000200062O000300BB000100010004433O00BB00012O00D7000300063O00209C00030003000A4O000400023O00202O0004000400214O00030002000200062O000300BB00013O0004433O00BB00012O00D7000300073O0012C9000400243O0012C9000500254O006C000300054O00AF00036O00D7000300023O0020D500030003001000201300030003000E2O001D000300020002000625000300062O013O0004433O00062O012O00D7000300033O0020790003000300264O000500023O00202O0005000500104O00030005000200262O000300CE000100200004433O00CE00012O00D7000300023O0020D50003000300120020130003000300112O001D000300020002000625000300D500013O0004433O00D500012O00D7000300033O0020E300030003002700122O000500283O00122O000600026O00030006000200062O000300062O0100010004433O00062O012O00D70003000A4O002C010300010002000625000300062O013O0004433O00062O01000625000100062O013O0004433O00062O012O00D7000300023O0020D50003000300030020130003000300142O001D0003000200020006C1000300EA000100010004433O00EA00012O00D7000300043O00268F000300F90001000F0004433O00F900012O00D7000300023O0020D50003000300290020130003000300142O001D000300020002000625000300F900013O0004433O00F900012O00D7000300023O0020D500030003000300201300030003002A2O001D000300020002000E9E000900F9000100030004433O00F900012O00D7000300023O0020D50003000300030020130003000300112O001D000300020002000625000300062O013O0004433O00062O012O00D7000300043O000E54000600062O0100030004433O00062O012O00D70003000B4O00D7000400023O0020D50004000400102O001D000300020002000625000300062O013O0004433O00062O012O00D7000300073O00123D0004002B3O00122O0005002C6O000300056O00035O00044O00062O010004433O009800012O00D7000200023O0020D500020002002D00201300020002000E2O001D0002000200020006250002004B2O013O0004433O004B2O010012C9000200013O00268E0002000D2O0100010004433O000D2O012O00D7000300053O00202901030003000700122O000500226O000600096O00030006000200062O000300232O013O0004433O00232O012O00D7000300063O00207200030003000A4O000400023O00202O00040004002D4O0005000C6O00030005000200062O000300232O013O0004433O00232O012O00D7000300073O0012C90004002E3O0012C90005002F4O006C000300054O00AF00036O00D7000300033O0020D10003000300054O000500016O000600016O00030006000200062O0003004B2O0100010004433O004B2O012O00D7000300094O00D70004000D3O0020D50004000400302O002C01040001000200064B0004004B2O0100030004433O004B2O012O00D70003000E3O0006C1000300392O0100010004433O00392O012O00D7000300063O00201B0103000300314O000400023O00202O00040004002D4O00030002000100044O004B2O012O00D7000300013O0006250003004B2O013O0004433O004B2O012O00D7000300063O00207200030003000A4O000400023O00202O00040004002D4O0005000C6O00030005000200062O0003004B2O013O0004433O004B2O012O00D7000300073O00123D000400323O00122O000500336O000300056O00035O00044O004B2O010004433O000D2O010012C93O00343O00268E3O009B2O01000F0004433O009B2O012O00D7000200023O0020D500020002003500201300020002000E2O001D0002000200020006250002007E2O013O0004433O007E2O012O00D7000200043O00269B0002007E2O0100020004433O007E2O012O00D7000200033O0020560002000200364O000400023O00202O0004000400374O000200040002000E2O0020007E2O0100020004433O007E2O012O00D7000200023O0020D500020002003800201300020002002A2O001D000200020002000EDD0028006A2O0100020004433O006A2O012O00D7000200023O0020D50002000200380020130002000200142O001D0002000200020006C10002007E2O0100010004433O007E2O010012C9000200013O00268E0002006B2O0100010004433O006B2O012O00D7000300104O00F3000400023O00202O0004000400354O0003000200024O0003000F6O0003000F3O00062O0003007E2O013O0004433O007E2O012O00D7000300073O001240000400393O00122O0005003A6O0003000500024O0004000F6O0003000300044O000300023O00044O007E2O010004433O006B2O012O00D7000200023O0020D500020002003B0020130002000200042O001D0002000200020006250002009A2O013O0004433O009A2O012O00D7000200023O0020D50002000200380020130002000200142O001D0002000200020006C10002009A2O0100010004433O009A2O012O00D7000200043O000E540006009A2O0100020004433O009A2O012O00D7000200063O00201701020002000A4O000300023O00202O00030003003B4O000400016O00020004000200062O0002009A2O013O0004433O009A2O012O00D7000200073O0012C90003003C3O0012C90004003D4O006C000200044O00AF00025O0012C93O00023O00268E3O0088030100340004433O008803012O00D7000200013O0006250002008603013O0004433O008603010012C9000200013O00268E000200B72O0100200004433O00B72O012O00D7000300113O0006250003008603013O0004433O008603012O00D7000300013O0006250003008603013O0004433O008603010012C9000300013O000E152O0100AA2O0100030004433O00AA2O012O00D7000400124O002C0104000100022O00970004000F4O00D70004000F3O0006250004008603013O0004433O008603012O00D70004000F4O0004000400023O0004433O008603010004433O00AA2O010004433O0086030100268E00020038020100010004433O003802012O00D7000300023O0020D500030003003E00201300030003000E2O001D0003000200020006250003000502013O0004433O000502012O00D7000300033O0020AD0003000300154O000500023O00202O00050005003F4O00030005000200062O000300CC2O0100010004433O00CC2O012O00D7000300023O0020D500030003001200201300030003002A2O001D0003000200020026E500030005020100090004433O00050201000625000100EE2O013O0004433O00EE2O012O00D7000300093O000E54000200EE2O0100030004433O00EE2O012O00D7000300053O0020CF0003000300074O000500073O00122O000600403O00122O000700416O00050007000200122O000600096O00030006000200062O000300EE2O013O0004433O00EE2O012O00D7000300023O0020D50003000300210020130003000300142O001D000300020002000625000300F82O013O0004433O00F82O012O00D7000300023O0020D500030003002100201300030003002A2O001D00030002000200268F000300F82O0100420004433O00F82O012O00D7000300053O0020AD0003000300434O000500023O00202O0005000500214O00030005000200062O000300F82O0100010004433O00F82O012O00D7000300063O00201C0103000300444O000400073O00122O000500453O00122O000600466O00040006000200122O000500476O00030005000200062O0003000502013O0004433O000502012O00D7000300063O00201701030003000A4O000400023O00202O00040004003E4O000500016O00030005000200062O0003000502013O0004433O000502012O00D7000300073O0012C9000400483O0012C9000500494O006C000300054O00AF00036O00D7000300023O0020D500030003004A0020130003000300042O001D0003000200020006250003003702013O0004433O003702012O00D700035O0006250003003702013O0004433O003702012O00D7000300093O000E5400200037020100030004433O003702012O00D7000300133O0006C10003001D020100010004433O001D02012O00D7000300083O00268F0003001D020100340004433O001D02012O00D7000300023O0020D500030003004B0020130003000300142O001D0003000200020006250003003702013O0004433O003702012O00D7000300033O0020AD0003000300154O000500023O00202O00050005003F4O00030005000200062O0003002A020100010004433O002A02012O00D7000300023O0020D500030003004C0020130003000300142O001D0003000200020006C100030037020100010004433O003702012O00D7000300063O00200401030003000A4O000400023O00202O00040004004A4O000500056O00030005000200062O0003003702013O0004433O003702012O00D7000300073O0012C90004004D3O0012C90005004E4O006C000300054O00AF00035O0012C90002000F3O00268E000200BD0201000F0004433O00BD02012O00D7000300023O0020D500030003000D0020130003000300042O001D0003000200020006250003008A02013O0004433O008A02010012C9000300013O00268E00030041020100010004433O004102012O00D7000400143O0006250004006602013O0004433O006602012O00D7000400033O0020ED0004000400154O000600023O00202O0006000600104O00040006000200062O0004006602013O0004433O006602012O00D7000400043O00269B00040066020100020004433O006602012O00D7000400033O0020ED0004000400154O000600023O00202O0006000600164O00040006000200062O0004005A02013O0004433O005A02012O00D7000400083O000E3301340066020100040004433O006602012O00D7000400063O00209C00040004000A4O000500023O00202O00050005000D4O00040002000200062O0004006602013O0004433O006602012O00D7000400073O0012C90005004F3O0012C9000600504O006C000400064O00AF00046O00D7000400023O0020D50004000400030020130004000400142O001D0004000200020006C10004008A020100010004433O008A02012O00D7000400083O000E540020008A020100040004433O008A02012O00D7000400023O0020D50004000400120020130004000400132O001D000400020002000E54000F008A020100040004433O008A02012O00D7000400033O0020D10004000400054O000600016O000700016O00040007000200062O0004008A020100010004433O008A02012O00D7000400063O00209C00040004000A4O000500023O00202O00050005000D4O00040002000200062O0004008A02013O0004433O008A02012O00D7000400073O00123D000500513O00122O000600526O000400066O00045O00044O008A02010004433O004102012O00D7000300023O0020D500030003001200201300030003000E2O001D000300020002000625000300BC02013O0004433O00BC02012O00D7000300154O002C010300010002000625000300BC02013O0004433O00BC02012O00D7000300033O0020AD0003000300154O000500023O00202O00050005003F4O00030005000200062O000300BC020100010004433O00BC02012O00D7000300063O00201C0103000300444O000400073O00122O000500533O00122O000600546O00040006000200122O000500426O00030005000200062O000300BC02013O0004433O00BC02012O00D7000300013O000625000300BC02013O0004433O00BC02010012C9000300013O00268E000300A9020100010004433O00A902012O00D7000400104O00F3000500023O00202O0005000500124O0004000200024O0004000F6O0004000F3O00062O000400BC02013O0004433O00BC02012O00D7000400073O001240000500553O00122O000600566O0004000600024O0005000F6O0004000400054O000400023O00044O00BC02010004433O00A902010012C9000200023O00268E000200A12O0100020004433O00A12O012O00D7000300013O0006250003002903013O0004433O002903012O00D7000300023O0020D50003000300570020130003000300042O001D0003000200020006250003002903013O0004433O002903012O00D7000300023O0020D500030003001000201300030003002A2O001D000300020002000EDD002000D5020100030004433O00D502012O00D7000300033O0020ED0003000300154O000500023O00202O0005000500104O00030005000200062O000300F602013O0004433O00F602012O00D7000300033O0020AD0003000300154O000500023O00202O0005000500574O00030005000200062O000300F6020100010004433O00F602012O00D7000300033O0020130003000300582O001D000300020002000E54005900E9020100030004433O00E902012O00D7000300033O00201300030003005A2O001D000300020002000EDD0002001C030100030004433O001C03012O00D7000300083O000EDD0020001C030100030004433O001C03012O00D7000300023O0020D500030003005700201300030003005B2O001D000300020002000E54005C00F6020100030004433O00F602012O00D7000300033O0020AD0003000300154O000500023O00202O00050005003F4O00030005000200062O0003001C030100010004433O001C03012O00D7000300033O0020240103000300264O000500023O00202O00050005003F4O000300050002000E2O00340007030100030004433O000703012O00D7000300033O0020AD0003000300154O000500023O00202O0005000500574O00030005000200062O00030007030100010004433O000703012O00D7000300083O000EDD0020001C030100030004433O001C03012O00D7000300033O0020AD0003000300154O000500023O00202O0005000500574O00030005000200062O00030029030100010004433O002903012O00D7000300063O0020000103000300444O000400073O00122O0005005D3O00122O0006005E6O0004000600024O000500023O00202O00050005005700202O0005000500134O00050002000200102O0005005F00054O00030005000200062O0003002903013O0004433O002903012O00D70003000B4O0035000400023O00202O0004000400574O000500066O000700016O00030007000200062O0003002903013O0004433O002903012O00D7000300073O0012C9000400603O0012C9000500614O006C000300054O00AF00036O00D7000300033O0020ED0003000300154O000500023O00202O0005000500104O00030005000200062O0003008403013O0004433O008403010012C9000300013O00268E0003005A0301000F0004433O005A03012O00D7000400023O0020D500040004006200201300040004000E2O001D0004000200020006250004004603013O0004433O004603012O00D7000400063O00207200040004000A4O000500023O00202O0005000500624O000600166O00040006000200062O0004004603013O0004433O004603012O00D7000400073O0012C9000500633O0012C9000600644O006C000400064O00AF00046O00D7000400023O0020D500040004006500201300040004000E2O001D0004000200020006250004008403013O0004433O008403012O00D7000400063O00207200040004000A4O000500023O00202O0005000500654O000600166O00040006000200062O0004008403013O0004433O008403012O00D7000400073O00123D000500663O00122O000600676O000400066O00045O00044O0084030100268E00030031030100010004433O003103012O00D7000400023O0020D500040004006800201300040004000E2O001D0004000200020006250004006F03013O0004433O006F03012O00D7000400063O00207200040004000A4O000500023O00202O0005000500684O000600166O00040006000200062O0004006F03013O0004433O006F03012O00D7000400073O0012C9000500693O0012C90006006A4O006C000400064O00AF00046O00D7000400023O0020D500040004006B00201300040004000E2O001D0004000200020006250004008203013O0004433O008203012O00D7000400063O00207200040004000A4O000500023O00202O00050005006B4O000600166O00040006000200062O0004008203013O0004433O008203012O00D7000400073O0012C90005006C3O0012C90006006D4O006C000400064O00AF00045O0012C90003000F3O0004433O003103010012C9000200203O0004433O00A12O012O002800026O0004000200023O00268E3O0002000100010004433O000200012O00D7000200033O0020ED0002000200154O000400023O00202O00040004000D4O00020004000200062O000200B803013O0004433O00B803012O00D7000200023O0020D500020002001000201300020002000E2O001D000200020002000625000200B803013O0004433O00B803012O00D7000200023O0020D500020002001200201300020002000E2O001D000200020002000625000200B803013O0004433O00B803012O00D7000200033O0020AD0002000200154O000400023O00202O0004000400104O00020004000200062O000200B8030100010004433O00B803012O00D7000200033O0020AD0002000200154O000400023O00202O00040004003F4O00020004000200062O000200B8030100010004433O00B803012O00D7000200063O00201701020002000A4O000300023O00202O0003000300104O000400016O00020004000200062O000200B803013O0004433O00B803012O00D7000200073O0012C90003006E3O0012C90004006F4O006C000200044O00AF00026O00D7000200144O002C0102000100022O0044000100023O0012C93O000F3O0004433O000200012O00193O00017O002A3O00028O00030B3O00536861646F7744616E636503143O0054696D6553696E63654C617374446973706C6179026O33D33F030A3O00536861646F776D656C640200304O33D33F03093O00497354616E6B696E6703063O0056616E697368030A3O0049734361737461626C65030C3O0044616E73654D616361627265030B3O004973417661696C61626C65026O000840026O00F03F030C3O00466C6167652O6C6174696F6E030F3O00432O6F6C646F776E52656D61696E73026O004E4003183O00426F2O7346696C7465726564466967687452656D61696E7303023O00DBA903053O00C2E794644603073O0043686172676573026O003E40030D3O00704DCFAAE5C00661C0A0E4C70603063O00A8262CA1C39603113O00436861726765734672616374696F6E616C03113O00536861646F7744616E636554616C656E74026O00E83F030B3O0042752O6652656D61696E73030E3O0053796D626F6C736F664465617468029A5O990140030F3O00536563726574546563686E69717565026O00224003173O00466C6167652O6C6174696F6E5065727369737442752O66026O001840026O001040026O00244003143O00B3F483723FFF92178EFF87361DE9B5048FBCD33603083O0076E09CE2165088D603013O003C03083O00446562752O66557003073O005275707475726503143O0071E658844DF97D814CED5CC06FEF5A924DAE0BC003043O00E0228E390131012O0012C9000100013O000E152O01002B2O0100010004433O002B2O012O00D700025O0006250002005D00013O0004433O005D00012O00D7000200013O0020D50002000200020020130002000200032O001D000200020002000E330104005D000100020004433O005D00012O00D7000200013O0020D50002000200050020130002000200032O001D000200020002000E330106005D000100020004433O005D00012O00D7000200023O0020130002000200072O00D7000400034O00AA0002000400020006C10002005D000100010004433O005D00012O00D7000200013O0020D50002000200080020130002000200092O001D0002000200020006250002005D00013O0004433O005D00012O00D7000200013O0020D500020002000A00201300020002000B2O001D0002000200020006250002002700013O0004433O002700012O00D7000200043O000E54000C005D000100020004433O005D00012O00D7000200054O002C0102000100020006C10002005D000100010004433O005D00012O00D7000200063O000E33010D005D000100020004433O005D00012O00D7000200013O0020D500020002000E00201300020002000F2O001D000200020002000EDD00100048000100020004433O004800012O00D7000200013O0020D500020002000E00201300020002000B2O001D0002000200020006250002004800013O0004433O004800012O00D7000200073O0020000102000200114O000300083O00122O000400123O00122O000500136O0003000500024O000400013O00202O00040004000800202O0004000400144O00040002000200102O0004001500044O00020004000200062O0002005D00013O0004433O005D00010012C9000200013O00268E00020049000100010004433O004900012O00D70003000A4O0018010400013O00202O0004000400084O00058O0003000500024O000300096O000300093O00062O0003005D00013O0004433O005D00012O00D7000300083O001240000400163O00122O000500176O0003000500024O000400096O0003000300044O000300023O00044O005D00010004433O004900012O00D70002000B3O0006250002002A2O013O0004433O002A2O012O00D700025O0006250002002A2O013O0004433O002A2O012O00D7000200013O0020D50002000200020020130002000200092O001D0002000200020006250002002A2O013O0004433O002A2O012O00D7000200013O0020D50002000200020020130002000200142O001D000200020002000E54000D002A2O0100020004433O002A2O012O00D7000200013O0020D50002000200080020130002000200032O001D000200020002000E330104002A2O0100020004433O002A2O012O00D7000200013O0020D50002000200050020130002000200032O001D000200020002000E330106002A2O0100020004433O002A2O012O00D700025O0006C100020090000100010004433O009000012O00D7000200013O00202101020002000200202O0002000200184O0002000200024O0003000C6O000400013O00202O00040004001900202O00040004000B4O00040002000200062O0004008C000100010004433O008C00010012C90004001A3O0006C10004008D000100010004433O008D00010012C9000400014O000E01030003000400064B0003002A2O0100020004433O002A2O010012C9000200013O00268E00020091000100010004433O009100012O00D70003000D4O002C010300010002000625000300AF00013O0004433O00AF00012O00D7000300013O0020D500030003001900201300030003000B2O001D0003000200020006C1000300AB000100010004433O00AB00012O00D7000300023O00203A00030003001B4O000500013O00202O00050005001C4O0003000500024O0004000E6O000500013O00202O00050005000E00202O00050005000B4O000500066O00043O00020010220104001D000400064E0004002A000100030004433O00D400012O00D7000300054O002C0103000100020006C1000300D4000100010004433O00D400012O00D7000300013O0020D500030003001900201300030003000B2O001D000300020002000625000300C400013O0004433O00C400012O00D7000300013O0020D500030003001E00201300030003000F2O001D00030002000200269B000300C40001001F0004433O00C400012O00D7000300043O00268F000300D40001000C0004433O00D400012O00D7000300013O0020D500030003000A00201300030003000B2O001D0003000200020006C1000300D4000100010004433O00D400012O00D7000300023O0020D000030003001B4O000500013O00202O0005000500204O000300050002000E2O002100D4000100030004433O00D400012O00D7000300043O000E54002200ED000100030004433O00ED00012O00D7000300013O0020D500030003001C00201300030003000F2O001D000300020002000E33012300ED000100030004433O00ED00012O00D70003000F4O002C010300010002000625000300ED00013O0004433O00ED00010012C9000300013O00268E000300D9000100010004433O00D900012O00D70004000A4O0018010500013O00202O0005000500024O00068O0004000600024O000400096O000400093O00062O000400ED00013O0004433O00ED00012O00D7000400083O001240000500243O00122O000600256O0004000600024O000500096O0004000400054O000400023O00044O00ED00010004433O00D900012O00D7000300104O002C0103000100020006250003002A2O013O0004433O002A2O012O00D70003000D4O002C010300010002000625000300FF00013O0004433O00FF00012O00D7000300073O00205000030003001100122O000400266O000500013O00202O00050005001C00202O00050005000F4O000500066O00033O000200062O000300132O0100010004433O00132O012O00D7000300013O0020D500030003001900201300030003000B2O001D0003000200020006C10003002A2O0100010004433O002A2O012O00D7000300033O0020ED0003000300274O000500013O00202O0005000500284O00030005000200062O0003002A2O013O0004433O002A2O012O00D7000300043O00269B0003002A2O0100220004433O002A2O012O00D70003000F4O002C0103000100020006250003002A2O013O0004433O002A2O010012C9000300013O00268E000300142O0100010004433O00142O012O00D70004000A4O0018010500013O00202O0005000500024O00068O0004000600024O000400096O000400093O00062O0004002A2O013O0004433O002A2O012O00D7000400083O001240000500293O00122O0006002A6O0004000600024O000500096O0004000400054O000400023O00044O002A2O010004433O00142O010004433O002A2O010004433O009100010012C90001000D3O00268E000100010001000D0004433O000100012O002800026O0004000200023O0004433O000100012O00193O00017O00223O00028O00026O00F03F03103O004563686F696E6752657072696D616E64030B3O004973417661696C61626C6503063O00456E65726779026O004E40027O004003063O0042752O66557003113O004563686F696E6752657072696D616E6433026O00084003113O004563686F696E6752657072696D616E6434026O00104003113O004563686F696E6752657072696D616E643503093O0054696D65546F536874026O00E03F026O00144003143O00FB8B85FA76FF581CDFB3CACF33C15201D2AECBDA03083O006EBEC7A5BD13913D030A3O00476C2O6F6D626C616465030A3O0049734361737461626C6503043O0043617374030F3O00F9EA64FCCBE0D6E478E589CBDBEF7203063O00A7BA8B1788EB03083O004261636B73746162030D3O0039B49B195A97890E11A69C0C1803043O006D7AD5E8030F3O00456E65726779507265646963746564030D3O0053687572696B656E53746F726D030B3O0042752O6652656D61696E7303133O004C696E676572696E67536861646F7742752O66026O00184003133O00506572666F72617465645665696E7342752O6603133O00CDF6B124AEC4AA25FCFEA935E0B79124E1E5AF03043O00508E97C201B73O0012C9000100014O0015000200023O00268E00010077000100020004433O007700012O00D700035O0006250003007500013O0004433O007500010012C9000300013O00268E00030008000100010004433O000800012O00D7000400013O0020D50004000400030020130004000400042O001D0004000200020006250004004A00013O0004433O004A00012O00D7000400023O0020130004000400052O001D0004000200020026E50004004A000100060004433O004A00012O00D7000400033O00268E0004001F000100070004433O001F00012O00D7000400023O0020AD0004000400084O000600013O00202O0006000600094O00040006000200062O00040033000100010004433O003300012O00D7000400033O00268E000400290001000A0004433O002900012O00D7000400023O0020AD0004000400084O000600013O00202O00060006000B4O00040006000200062O00040033000100010004433O003300012O00D7000400033O00268E0004004A0001000C0004433O004A00012O00D7000400023O0020ED0004000400084O000600013O00202O00060006000D4O00040006000200062O0004004A00013O0004433O004A00012O00D7000400043O0020D500040004000E0012C90005000A4O001D0004000200020026E6000400450001000F0004433O004500012O00D7000400043O0020D500040004000E0012C90005000C4O001D0004000200020026E600040045000100020004433O004500012O00D7000400043O0020D500040004000E0012C9000500104O001D0004000200020026E50004004A000100020004433O004A00012O00D7000400053O0012C9000500113O0012C9000600124O006C000400064O00AF00046O00D7000400013O0020D50004000400130020130004000400142O001D0004000200020006250004005F00013O0004433O005F00010006250002007500013O0004433O007500012O00D7000400063O00209C0004000400154O000500013O00202O0005000500134O00040002000200062O0004007500013O0004433O007500012O00D7000400053O00123D000500163O00122O000600176O000400066O00045O00044O007500012O00D7000400013O0020D50004000400180020130004000400142O001D0004000200020006250004007500013O0004433O007500010006250002007500013O0004433O007500012O00D7000400063O00209C0004000400154O000500013O00202O0005000500184O00040002000200062O0004007500013O0004433O007500012O00D7000400053O00123D000500193O00122O0006001A6O000400066O00045O00044O007500010004433O000800012O002800036O0004000300023O00268E00010002000100010004433O000200010006253O008100013O0004433O008100012O00D7000300023O00201300030003001B2O001D00030002000200064E3O0002000100030004433O008100012O001700026O0028000200014O00D7000300073O000625000300B400013O0004433O00B400012O00D7000300013O0020D500030003001C0020130003000300142O001D000300020002000625000300B400013O0004433O00B400012O00D7000300084O00D7000400094O00C5000500013O00202O00050005001300202O0005000500044O00050002000200062O0005009A00013O0004433O009A00012O00D7000500023O0020D000050005001D4O000700013O00202O00070007001E4O000500070002000E2O001F00A1000100050004433O00A100012O00D7000500023O0020F80005000500084O000700013O00202O0007000700204O00050007000200044O00A200012O001700056O0028000500014O001D00040002000200100C00040007000400064B000400B4000100030004433O00B40001000625000200B400013O0004433O00B400012O00D7000300063O00209C0003000300154O000400013O00202O00040004001C4O00030002000200062O000300B400013O0004433O00B400012O00D7000300053O0012C9000400213O0012C9000500224O006C000300054O00AF00035O0012C9000100023O0004433O000200012O00193O00017O00033O0003073O00435F54696D657203053O004166746572026O00D03F00373O0012243O00013O0020D55O00020012C9000100033O002O0601023O000100312O00D78O00D73O00014O00D73O00024O00D73O00034O00D73O00044O00D73O00054O00D73O00064O00D73O00074O00D73O00084O00D73O00094O00D73O000A4O00D73O000B4O00D73O000C4O00D73O000D4O00D73O000E4O00D73O000F4O00D73O00104O00D73O00114O00D73O00124O00D73O00134O00D73O00144O00D73O00154O00D73O00164O00D73O00174O00D73O00184O00D73O00194O00D73O001A4O00D73O001B4O00D73O001C4O00D73O001D4O00D73O001E4O00D73O001F4O00D73O00204O00D73O00214O00D73O00224O00D73O00234O00D73O00244O00D73O00254O00D73O00264O00D73O00274O00D73O00284O00D73O00294O00D73O002A4O00D73O002B4O00D73O002C4O00D73O002D4O00D73O002E4O00D73O002F4O00D73O00304O0007012O000200012O00193O00013O00013O00993O00028O00026O001C40030C3O0049734368612O6E656C696E67030A3O00546F2O676C654D61696E030F3O00412O66656374696E67436F6D62617403063O0056616E69736803113O0054696D6553696E63654C61737443617374026O00F03F030D3O00546172676574497356616C6964030E3O0049735370652O6C496E52616E6765030C3O00536861646F77737472696B6503093O00537465616C74685570030B3O00436173744162696C69747903043O007479706503053O0017C775400603043O002C63A61703043O004361737403063O00756E7061636B03243O004FE32C373FB074F22D761EA57FE5267610A56FE3693921E44CF8263A73EC53D80A7F69E403063O00C41C97495653031E3O00C0172C118E4C1073F7430A11914C5879E143191F8D54583EDC2C0A59D81803083O001693634970E23878026O00144003063O00F83DCDDAAEF103053O00EDD8158295027O0040030C3O00536C696365616E6444696365030A3O0049734361737461626C65030A3O0043504D61785370656E6403143O0046696C7465726564466967687452656D61696E7303013O003E026O001840030B3O0042752O6652656D61696E732O033O00474344026O00104003073O004973526561647903223O00A14F4C4BF0FA528B4D5A1FB1C75AC26A565CB58916AE41481F94DC4C835A5650BE8003073O003EE22E2O3FD0A903053O00506F776572026O00344003073O00D5165A8F16032803083O003E857935E37F6D4F03053O00041530F9D303073O00C270745295B6CE03243O000ABC4919CCF6063CAC0C35C1E11C36E86F19D3F64E36BA0C28CFED0279E06337E3AB547903073O006E59C82C78A082031E3O0098D74E474F5E3348AF836847505E7B42B9837B494C467B0584EC680F190A03083O002DCBA32B26232A5B03113O00E191D9228BBD5CD7819C1388A658DB8BDB03073O0034B2E5BC43E7C9026O000840030F3O00456E65726779507265646963746564030D3O00122O5505FB482B61627417AD1C03073O004341213064973C03063O0042752O665570030D3O00546865526F2O74656E42752O6603183O00426F2O7346696C7465726564466967687452656D61696E7303013O003C03083O005365616C46617465030B3O004973417661696C61626C6503083O00F9EEA0D1E0D7BDEE03053O0093BF87CEB803073O00A63DAFCDDC09F203073O00D2E448C6A1B833030D3O00055DF6117FDA3E09D03460947603063O00AE562993701303053O0078249E516503083O00CB3B60ED6B456F7103043O005368697603093O00497343617374696E6703113O00556E6974486173456E7261676542752O6603063O00201FBFF134FC03073O00B74476CC815190030A3O00436F6D62617454696D65026O002440030B3O00536861646F7744616E6365030A3O00432O6F6C646F776E5570026O002640030A3O00476C2O6F6D626C61646503113O0021BD75EA0E904E8A7CEB048F0CA171E00E03063O00E26ECD10846B030A3O00446562752O66446F776E03073O0052757074757265030E3O00C4D3E5D744F983D2CC51FFD6F2DC03053O00218BA380B9030C3O00536861646F77426C6164657303083O0042752O66446F776E03133O00784801D0524A44ED5F5900D1407A08DF535D1703043O00BE373864030D3O0053687572696B656E53746F726D03173O0079BF391016F1B365A7290C1AE8F658EF081101EDF252A003073O009336CF5C7E738303123O0022213073086C4D023D7C09711A1534730E7B03063O001E6D51551D6D03093O00D06151B833CCBCCC4203073O009C9F1134D656BE030E3O0053796D626F6C736F66446561746803153O0081FFB8B2AB2OFD8FB7E2BFB3A2FCB2BA8AEABCA8A603043O00DCCE8FDD030C3O004570696353652O74696E677303073O00546F2O676C65732O033O0089722E03073O00B2E61D4D77B8AC2O033O00F4B10F03063O009895DE6A7B172O033O00DE22E503053O00D5BD46962303093O00456E657267794D617803113O004563686F696E6752657072696D616E643303113O004563686F696E6752657072696D616E643403113O004563686F696E6752657072696D616E643503093O0054696D65546F536874030D3O00456E6572677954696D65546F58025O00804140030A3O0047434452656D61696E73026O00E03F030F3O0053687572696B656E546F726E61646F03113O0054696D65546F4E657874546F726E61646F026O00D03F030B3O004372696D736F6E5669616C03073O00506F69736F6E7303063O0045786973747303103O00547269636B736F66746865547261646503153O00547269636B736F667468655472616465466F637573031D3O005F47710B405876095B15601A46567F1B705A72375B5D71375B47750C4A03043O00682F351403093O0049734D6F756E74656403073O00537465616C746803083O00537465616C746832030F3O009058841DB01BAB0CC933932CEA16C103063O006FC32CE17CDC026O33D33F030A3O004576697363657261746503063O0044616D616765030B3O004865616C746873746F6E6503103O004865616C746850657263656E74616765030C3O00F043017FBFA3CB520F7DAEEB03063O00CBB8266013CB03173O0052656672657368696E674865616C696E67506F74696F6E03183O000B767F53CB2A7B704FC91176784DC73774494EDA307C770103053O00AE5913192103113O00476574456E656D696573496E52616E6765026O003E4003163O00476574456E656D696573496E4D656C2O6552616E6765030B3O00436F6D626F506F696E747303143O00452O66656374697665436F6D626F506F696E747303123O00436F6D626F506F696E74734465666963697403103O004163726F6261746963537472696B6573026O002040026O002A40030E3O004973496E4D656C2O6552616E676503063O003B1D5549FB8203073O006B4F72322E97E7007F042O0012C93O00013O00268E3O0090020100020004433O009002012O00D700015O0020130001000100032O001D0001000200020006C10001007E040100010004433O007E0401001224000100043O0006250001007E04013O0004433O007E04010012C9000100013O00268E0001000C000100010004433O000C00012O00D700025O0020130002000200052O001D0002000200020006C100020081000100010004433O008100012O00D7000200013O0020130002000200052O001D0002000200020006250002008100013O0004433O008100012O00D7000200023O0020D50002000200060020130002000200072O001D000200020002000E3301080081000100020004433O008100010012C9000200013O00268E0002001F000100010004433O001F00012O00D7000300033O0020D50003000300092O002C0103000100020006250003007F00013O0004433O007F00012O00D7000300013O0020AD00030003000A4O000500023O00202O00050005000B4O00030005000200062O00030030000100010004433O003000012O00D7000300043O0006250003007F00013O0004433O007F00012O00D700035O0020B600030003000C4O000500016O000600016O00030006000200062O0003006A00013O0004433O006A00010012C9000300013O00268E00030038000100010004433O003800012O00D7000400054O0033000500016O00040002000200122O0004000D3O00122O0004000D3O00062O0004007F00013O0004433O007F00010012240004000E3O0012B90005000D6O0004000200024O000500063O00122O0006000F3O00122O000700106O00050007000200062O0004005C000100050004433O005C00010012240004000D4O008D000400043O000E330108005C000100040004433O005C00012O00D7000400073O0020C300040004001100122O000500123O00122O0006000D6O000500066O00043O000200062O0004007F00013O0004433O007F00012O00D7000400063O00123D000500133O00122O000600146O000400066O00045O00044O007F00012O00D7000400073O0020D50004000400110012240005000D4O001D0004000200020006250004007F00013O0004433O007F00012O00D7000400063O00123D000500153O00122O000600166O000400066O00045O00044O007F00010004433O003800010004433O007F00012O00D7000300083O000E540017007F000100030004433O007F00010012C9000300013O00268E0003006E000100010004433O006E00012O00D70004000A4O002C0104000100022O0097000400094O00D7000400093O0006250004007F00013O0004433O007F00012O00D7000400094O00E9000500063O00122O000600183O00122O000700196O0005000700024O0004000400054O000400023O00044O007F00010004433O006E00012O00193O00013O0004433O001F00012O00D7000200033O0020D50002000200092O002C0102000100020006250002007E04013O0004433O007E04012O00D70002000B3O0006C10002008E000100010004433O008E00012O00D700025O0020130002000200052O001D0002000200020006250002007E04013O0004433O007E04010012C9000200013O00268E000200142O01001A0004433O00142O012O00D7000300023O0020D500030003001B00201300030003001C2O001D000300020002000625000300D300013O0004433O00D300012O00D70003000C4O00D70004000D3O0020D500040004001D2O002C01040001000200068A000300D3000100040004433O00D300012O00D7000300073O00200301030003001E4O0004000E3O00122O0005001F3O00122O000600206O00030006000200062O000300D300013O0004433O00D300012O00D700035O0020850003000300214O000500023O00202O00050005001B4O0003000500024O00045O00202O0004000400224O00040002000200062O000300D3000100040004433O00D300012O00D7000300083O000E54002300D3000100030004433O00D300012O00D7000300023O0020D500030003001B0020130003000300242O001D000300020002000625000300D300013O0004433O00D300010012C9000300013O000E152O0100B9000100030004433O00B900012O00D7000400073O00209C0004000400114O000500023O00202O00050005001B4O00040002000200062O000400C700013O0004433O00C700012O00D7000400063O0012C9000500253O0012C9000600264O006C000400064O00AF00046O00D700045O0020130004000400272O001D0004000200020026E5000400D3000100280004433O00D300012O00D7000400063O00123D000500293O00122O0006002A6O000400066O00045O00044O00D300010004433O00B900012O00D700035O0020B600030003000C4O000500016O000600016O00030006000200062O000300132O013O0004433O00132O010012C9000300013O00268E0003000B2O0100010004433O000B2O012O00D7000400054O0033000500016O00040002000200122O0004000D3O00122O0004000D3O00062O0004000A2O013O0004433O000A2O010012240004000E3O0012B90005000D6O0004000200024O000500063O00122O0006002B3O00122O0007002C6O00050007000200062O000400FF000100050004433O00FF00010012240004000D4O008D000400043O000E33010800FF000100040004433O00FF00012O00D7000400073O0020C300040004001100122O000500123O00122O0006000D6O000500066O00043O000200062O0004000A2O013O0004433O000A2O012O00D7000400063O00123D0005002D3O00122O0006002E6O000400066O00045O00044O000A2O012O00D7000400073O0020D50004000400110012240005000D4O001D0004000200020006250004000A2O013O0004433O000A2O012O00D7000400063O0012C90005002F3O0012C9000600304O006C000400064O00AF00045O0012C9000300083O000E15010800DB000100030004433O00DB00012O00D7000400063O00123D000500313O00122O000600326O000400066O00045O00044O00DB00010012C9000200333O00268E0002008F2O0100330004433O008F2O012O00D700035O0020130003000300342O001D0003000200022O00D70004000F3O00064B0004002F2O0100030004433O002F2O010012C9000300013O00268E0003001D2O0100010004433O001D2O012O00D7000400104O000D0105000F6O0004000200024O000400096O000400093O00062O0004002F2O013O0004433O002F2O012O00D7000400063O001240000500353O00122O000600366O0004000600024O000500096O0004000400054O000400023O00044O002F2O010004433O001D2O012O00D7000300114O00D70004000D3O0020D500040004001D2O002C01040001000200064E00040023000100030004433O00572O012O00D7000300124O0037010400136O00055O00202O0005000500374O000700023O00202O0007000700384O000500076O00043O000200102O00040008000400062O00030018000100040004433O00572O012O00D7000300073O0020F600030003003900122O0004003A3O00122O0005001A6O00030005000200062O0003004A2O013O0004433O004A2O012O00D7000300113O000EDD003300572O0100030004433O00572O012O00D70003000C4O0011010400136O000500023O00202O00050005003B00202O00050005003C4O000500066O00043O000200102O00040023000400062O0004006A2O0100030004433O006A2O012O00D7000300113O000E540023006A2O0100030004433O006A2O010012C9000300013O00268E000300582O0100010004433O00582O012O00D70004000A4O002C0104000100022O0097000400094O00D7000400093O0006250004007E04013O0004433O007E04012O00D7000400063O0012400005003D3O00122O0006003E6O0004000600024O000500096O0004000400054O000400023O00044O007E04010004433O00582O010004433O007E04010012C9000300013O00268E0003007C2O0100080004433O007C2O012O00D7000400144O000D0105000F6O0004000200024O000400096O000400093O00062O0004007E04013O0004433O007E04012O00D7000400063O0012400005003F3O00122O000600406O0004000600024O000500096O0004000400054O000400023O00044O007E040100268E0003006B2O0100010004433O006B2O012O00D7000400104O000D0105000F6O0004000200024O000400096O000400093O00062O0004008C2O013O0004433O008C2O012O00D7000400063O00125D000500413O00122O000600426O0004000600024O000500096O0004000400054O000400023O0012C9000300083O0004433O006B2O010004433O007E040100268E0002009F2O0100080004433O009F2O012O00D7000300154O002C0103000100022O0097000300094O00D7000300093O0006250003009E2O013O0004433O009E2O012O00D7000300063O00125D000400433O00122O000500446O0003000500024O000400096O0003000300044O000300023O0012C90002001A3O00268E0002008F000100010004433O008F00012O00D7000300163O000625000300C72O013O0004433O00C72O012O00D7000300023O0020D50003000300450020130003000300242O001D000300020002000625000300C72O013O0004433O00C72O012O00D700035O0020130003000300462O001D0003000200020006C1000300C72O0100010004433O00C72O012O00D700035O0020130003000300032O001D0003000200020006C1000300C72O0100010004433O00C72O012O00D7000300033O0020D50003000300472O00D7000400014O001D000300020002000625000300C72O013O0004433O00C72O012O00D7000300174O00FD000400023O00202O0004000400454O000500046O000500056O00030005000200062O000300C72O013O0004433O00C72O012O00D7000300063O0012C9000400483O0012C9000500494O006C000300054O00AF00036O00D7000300073O0020D500030003004A2O002C0103000100020026E50003008B0201004B0004433O008B02012O00D7000300073O0020D500030003004A2O002C010300010002000E332O01008B020100030004433O008B02012O00D7000300023O0020D500030003004C00201300030003004D2O001D0003000200020006250003008B02013O0004433O008B02012O00D7000300023O0020D50003000300060020130003000300072O001D000300020002000E33014E008B020100030004433O008B02010012C9000300013O00268E0003000F0201001A0004433O000F02012O00D7000400023O0020D500040004004F0020130004000400072O001D000400020002000E33013300F52O0100040004433O00F52O012O00D70004000C3O00269B000400F52O0100080004433O00F52O012O00D7000400073O00209C0004000400114O000500023O00202O00050005004F4O00040002000200062O000400F52O013O0004433O00F52O012O00D7000400063O0012C9000500503O0012C9000600514O006C000400064O00AF00046O00D7000400013O0020ED0004000400524O000600023O00202O0006000600534O00040006000200062O0004000E02013O0004433O000E02012O00D70004000C3O00269B0004000E020100080004433O000E02012O00D7000400083O000E332O01000E020100040004433O000E02012O00D7000400073O00209C0004000400114O000500023O00202O0005000500534O00040002000200062O0004000E02013O0004433O000E02012O00D7000400063O0012C9000500543O0012C9000600554O006C000400064O00AF00045O0012C9000300333O000E1501080041020100030004433O004102012O00D7000400023O0020D500040004005600201300040004001C2O001D0004000200020006250004002B02013O0004433O002B02012O00D700045O0020ED0004000400574O000600023O00202O0006000600564O00040006000200062O0004002B02013O0004433O002B02012O00D7000400073O0020170104000400114O000500023O00202O0005000500564O000600016O00040006000200062O0004002B02013O0004433O002B02012O00D7000400063O0012C9000500583O0012C9000600594O006C000400064O00AF00046O00D7000400023O0020D500040004005A00201300040004001C2O001D0004000200020006250004004002013O0004433O004002012O00D70004000C3O000E54001A0040020100040004433O004002012O00D7000400073O00209C0004000400114O000500023O00202O00050005005A4O00040002000200062O0004004002013O0004433O004002012O00D7000400063O0012C90005005B3O0012C90006005C4O006C000400064O00AF00045O0012C90003001A3O00268E0003005A020100330004433O005A02012O00D7000400023O0020D500040004004C00201300040004001C2O001D0004000200020006250004008B02013O0004433O008B02012O00D7000400183O0006250004008B02013O0004433O008B02012O00D7000400073O0020170104000400114O000500193O00202O00050005004C4O000600016O00040006000200062O0004008B02013O0004433O008B02012O00D7000400063O00123D0005005D3O00122O0006005E6O000400066O00045O00044O008B020100268E000300DE2O0100010004433O00DE2O012O00D700045O0020B600040004000C4O000600016O000700016O00040007000200062O0004006F02013O0004433O006F02012O00D7000400073O00209C0004000400114O000500023O00202O00050005000B4O00040002000200062O0004006F02013O0004433O006F02012O00D7000400063O0012C90005005F3O0012C9000600604O006C000400064O00AF00046O00D7000400023O0020D500040004006100201300040004001C2O001D0004000200020006250004008902013O0004433O008902012O00D700045O0020ED0004000400574O000600023O00202O0006000600614O00040006000200062O0004008902013O0004433O008902012O00D7000400073O0020170104000400114O000500023O00202O0005000500614O000600016O00040006000200062O0004008902013O0004433O008902012O00D7000400063O0012C9000500623O0012C9000600634O006C000400064O00AF00045O0012C9000300083O0004433O00DE2O010012C9000200083O0004433O008F00010004433O007E04010004433O000C00010004433O007E040100268E3O00AD020100010004433O00AD02012O00D70001001A4O00BA00010001000100122O000100643O00202O0001000100654O000200063O00122O000300663O00122O000400676O0002000400024O0001000100024O0001000B3O00122O000100643O0020900001000100654O000200063O00122O000300683O00122O000400696O0002000400024O0001000100024O0001001B3O00122O000100643O00202O0001000100654O000200063O0012740003006A3O00122O0004006B6O0002000400024O0001000100024O000100183O00124O00083O00268E3O0056030100230004433O005603012O00D70001001D4O00F70001000100024O0001001C6O00015O00202O00010001006C4O0001000200024O0002001E6O0002000100024O0001000100024O0001000F6O000100116O000200083O00062O00020007030100010004433O000703012O00D7000100123O000E33011A0007030100010004433O000703012O00D700015O0020130001000100052O001D0001000200020006250001000703013O0004433O000703012O00D7000100083O00268E000100CF0201001A0004433O00CF02012O00D700015O0020ED0001000100374O000300023O00202O00030003006D4O00010003000200062O000100E302013O0004433O00E302012O00D7000100083O00268E000100D9020100330004433O00D902012O00D700015O0020ED0001000100374O000300023O00202O00030003006E4O00010003000200062O000100E302013O0004433O00E302012O00D7000100083O00268E00010007030100230004433O000703012O00D700015O0020AD0001000100374O000300023O00202O00030003006F4O00010003000200062O00010007030100010004433O000703010012C9000100014O0015000200023O00268E000100F4020100010004433O00F402012O00D70003000D3O00203001030003007000122O000400236O0003000200024O000200033O00262O000200F3020100010004433O00F302012O00D70003000D3O0020D50003000300700012C9000400174O001D0003000200022O0044000200033O0012C9000100083O00268E000100E5020100080004433O00E502012O00D70003001F4O006200045O00202O00040004007100122O000600726O0004000600024O00055O00202O0005000500734O000500066O00033O000200202O00030003007400202O00030003000100062O00020007030100030004433O000703012O00D7000300084O0097000300113O0004433O000703010004433O00E502012O00D700015O0020EC0001000100374O000300023O00202O0003000300754O000400046O000500016O00010005000200062O0001005503013O0004433O005503012O00D7000100084O00D70002000D3O0020D500020002001D2O002C01020001000200068A00010055030100020004433O005503010012C9000100014O0015000200023O00268E00010018030100010004433O001803012O00D70003000D3O0020960003000300764O0003000100024O000200036O00035O00202O0003000300734O00030002000200062O00020009000100030004433O002B03012O00D7000300204O00BB00045O00202O0004000400734O0004000200024O0004000400024O00030002000200262O00030055030100770004433O005503010012C9000300014O0015000400043O00268E0003003E030100080004433O003E03012O00D70005001F4O009F000600126O00060006000400122O000700016O0005000700024O000500126O000500116O0006000D3O00202O00060006001D4O00060001000200062O00050055030100060004433O005503012O00D7000500084O0097000500113O0004433O0055030100268E0003002D030100010004433O002D03012O00D70005000C4O00DC000600136O00075O00202O0007000700374O000900023O00202O0009000900564O000700096O00063O00024O0004000500064O000500216O000600086O0006000600044O0007000D3O00202O00070007001D4O000700016O00053O00024O000500083O00122O000300083O00044O002D03010004433O005503010004433O001803010012C93O00173O000E15012000B803013O0004433O00B803012O00D70001000D3O0020390001000100784O0001000100024O000100096O000100093O00062O0001006103013O0004433O006103012O00D7000100094O0004000100024O00D700015O0020130001000100052O001D0001000200020006C100010092030100010004433O009203010012C9000100013O00268E00010073030100010004433O007303012O00D70002000D3O0020390002000200794O0002000100024O000200096O000200093O00062O0002007203013O0004433O007203012O00D7000200094O0004000200023O0012C9000100083O00268E00010067030100080004433O006703012O00D7000200033O0020D50002000200092O002C0102000100020006250002009203013O0004433O009203012O00D7000200223O00201300020002007A2O001D0002000200020006250002009203013O0004433O009203012O00D7000200023O0020D500020002007B0020130002000200242O001D0002000200020006250002009203013O0004433O009203012O00D7000200174O00D7000300193O0020D500030003007C2O001D0002000200020006250002009203013O0004433O009203012O00D7000200063O00123D0003007D3O00122O0004007E6O000200046O00025O00044O009203010004433O006703012O00D700015O0020130001000100052O001D0001000200020006C1000100B7030100010004433O00B703012O00D700015O00201300010001007F2O001D0001000200020006C1000100B7030100010004433O00B703012O00D7000100033O0020D50001000100092O002C2O0100010002000625000100B703013O0004433O00B703010012C9000100013O000E152O0100A2030100010004433O00A203012O00D70002000D3O0020650002000200804O000300023O00202O0003000300814O000400046O0002000400024O000200096O000200093O00062O000200B703013O0004433O00B703012O00D7000200063O001240000300823O00122O000400836O0002000400024O000300096O0002000200034O000200023O00044O00B703010004433O00A203010012C93O00023O00268E3O000B040100170004433O000B04012O00D7000100113O0020272O010001002300102O00010023000100202O0001000100844O000100236O000100023O00202O00010001008500202O0001000100864O0001000200024O000200256O0001000100022O0097000100244O00C5000100263O00202O00010001008700202O0001000100244O00010002000200062O000100E803013O0004433O00E803012O00D700015O0020130001000100882O001D0001000200022O00D7000200273O00068A000100E8030100020004433O00E803012O00D700015O0020130001000100032O001D0001000200020006C1000100E8030100010004433O00E803012O00D700015O0020130001000100462O001D0001000200020006C1000100E8030100010004433O00E803012O00D7000100073O00209C0001000100114O000200193O00202O0002000200874O00010002000200062O000100E803013O0004433O00E803012O00D7000100063O0012C9000200893O0012C90003008A4O006C000100034O00AF00016O00D7000100263O0020D500010001008B0020130001000100242O001D0001000200020006250001000A04013O0004433O000A04012O00D700015O0020130001000100882O001D0001000200022O00D7000200283O00068A0001000A040100020004433O000A04012O00D700015O0020130001000100032O001D0001000200020006C10001000A040100010004433O000A04012O00D700015O0020130001000100462O001D0001000200020006C10001000A040100010004433O000A04012O00D7000100073O00209C0001000100114O000200193O00202O00020002008B4O00010002000200062O0001000A04013O0004433O000A04012O00D7000100063O0012C90002008C3O0012C90003008D4O006C000100034O00AF00015O0012C93O00203O00268E3O0049040100330004433O004904012O00D70001001B3O0006250001002B04013O0004433O002B04010012C9000100013O00268E0001001E040100010004433O001E04012O00D700025O0020E700020002008E00122O0004008F6O0002000400024O000200296O00025O00202O0002000200904O0004002A6O0002000400024O0002000E3O00122O000100083O00268E00010011040100080004433O001104012O00D70002000E4O000B000200026O0002000C6O00025O00202O0002000200904O0004002C6O0002000400024O0002002B3O00044O003B04010004433O001104010004433O003B04010012C9000100013O00268E00010033040100080004433O003304010012C9000200084O00970002000C4O006400026O00970002002B3O0004433O003B040100268E0001002C040100010004433O002C04012O006400026O0080000200296O00028O0002000E3O00122O000100083O00044O002C04012O00D700015O00205E0001000100914O0001000200024O000100086O0001000D3O00202O0001000100924O000200086O0001000200024O000100116O00015O00202O0001000100932O001D0001000200022O0097000100123O0012C93O00233O00268E3O006C0401001A0004433O006C04012O00D7000100023O0020D500010001009400201300010001003C2O001D0001000200020006250001005404013O0004433O005404010012C9000100953O0006C100010055040100010004433O005504010012C9000100174O00970001002C4O00C5000100023O00202O00010001009400202O00010001003C4O00010002000200062O0001005F04013O0004433O005F04010012C9000100963O0006C100010060040100010004433O006004010012C90001004B4O00970001002A4O00FE000100013O00202O0001000100974O0003002C6O0001000300024O000100046O000100013O00202O0001000100974O0003002A6O0001000300024O0001002D3O00124O00333O00268E3O0001000100080004433O00010001001224000100643O002O200001000100654O000200063O00122O000300983O00122O000400996O0002000400024O00010001000200122O000100046O000100016O0001002E6O000100014O00970001002F3O0012C9000100014O0097000100303O0012C93O001A3O0004433O000100012O00193O00017O00033O0003053O005072696E74032B3O000AB3B73D863CA3D97994BA2E9F3CF7C220E69039833AF9800AB3A539852BA3C53DE6B730CA1EB8CA302OB403083O00A059C6D549EA59D700084O001E7O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);
